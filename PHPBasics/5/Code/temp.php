<?php
$password = '';
$hostname = 'localhost';
$username = 'root';
$dbname = 'first_bd';

$add_data_indicator = false;//false;//true;

$conn = new mysqli($hostname,$username,$password);
if($conn->connect_error){
    die("Connection error: ". $conn->connect_error);
}

// Создание БД
//
//utf8_general_ci - устанавливается сопоставление(правила сортировки и сравнения строк
//в бд): используется кодировка utf-8, general - сопоставление будет общим, не
// специфичным для какого-то языка, ci - сравнения производятся без учёта регистра
//То есть как будут сравниваться строки на основе кодировки
$sql="CREATE DATABASE IF NOT EXISTS $dbname CHARACTER SET utf8 COLLATE utf8_general_ci";
//Создание БД
if($conn->query($sql)){
    echo "БД создана успешно\n";
}else{
    echo "Ошибка при создании БД: ".$conn->error;
}

// Определение БД, с которой будут производиться действия
//
$conn->select_db($dbname);

$sql="SET CHARACTER SET 'UTF8'";
if(!$conn->query($sql)){
    echo "Ошибка при настройке кодировки utf-8: " . $conn->error;
}
$sql="SET NAMES 'UTF8'";
if(!$conn->query($sql)){
    echo "Ошибка при настройке кодировки utf-8: " . $conn->error;
}

/*if(!$conn ->set_charset("utf8")){
    echo "Ошибка при настройке кодировки utf-8: " . $conn->error;
}*/

//////////////////////////////////////////////////////////////////////////

/*$sql = "DROP TABLE Tours";
if($conn->query($sql)===true){
    echo "DELETE";
}*/

/*$sql="CREATE TABLE IF NOT EXISTS Tours (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    tour_place VARCHAR(50),
    tour_date DATETIME,
    guid_name VARCHAR(50), 
    max_people INT,
    is_free BOOLEAN
);";
if($conn->query($sql)){
    echo "Новая таблица создана успешно\n";
}else{
    echo "Ошибка при создании 1-ой таблицы: ". $conn->error;
}*/
//////////////////

// Создание таблиц
//
// FOREIGN KEY - значение определяется как внешний ключ
// PRIMARY KEY - значит это будет первичным ключом в таблице
$sql="CREATE TABLE IF NOT EXISTS Specialty (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    spec_name VARCHAR(100) NOT NULL UNIQUE, 
    spec_descript TEXT
);";

if($conn->query($sql)){
    echo "Первая таблица создана успешно\n";
}else{
    echo "Ошибка при создании 1-ой таблицы: ". $conn->error;
}

$sql="CREATE TABLE IF NOT EXISTS Students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fml VARCHAR(70) NOT NULL,
    stud_id VARCHAR(30) NOT NULL UNIQUE,
    spec_id INT,
    FOREIGN KEY (spec_id) REFERENCES Specialty(id)
);";

if($conn->query($sql)){
    echo "Вторая таблица создана успешно\n";
}else{
    echo "Ошибка при создании 2-ой таблицы: ". $conn->error;
}

// Добавление информации в таблицы
//
if($add_data_indicator){
    $sql = "INSERT INTO Specialty (spec_name, spec_descript) VALUES
        ('POIT', 'The specialty POIT at BSUIR focuses on developing IT solutions and innovative software systems'),
        ('IiTP', 'The Information Technology and Software Engineering specialty at BSUIR encompasses a wide range of skills, including software development, data analysis, and IT project management')
";

    if($conn->query($sql)){
        echo "Информация была усспешно добавлена в первую таблицу\n";
    }else{
        echo "Ошибка при добавлении информации в 1-ую таблицу: ". $conn->error;
    }


    $sql = "INSERT INTO Students (fml, stud_id, spec_id) VALUES 
            ('Ivanov I.I.', '25100101', 1),
            ('Petrov P.P.', '35100101', 2),
            ('Sidorov I.I.', '35100102', 2),
            ('Vasiljev V.V.', '25100102', 1)
            
";
    if($conn->query($sql)){
        echo "Информация была усспешно добавлена во 2-ую таблицу\n";
    }else{
        echo "Ошибка при добавлении информации во 2-ую таблицу: ". $conn->error;
    }
}else{
    echo "Не режим добавления\n";
}

// Извлечение ВСЕЙ информации из таблиц БД - выделение данных
//
echo "Getting all info from DB\n";
$sql = "SELECT * FROM Specialty";
get_from_bd($sql, $conn);

$sql = "SELECT * FROM Students";
get_from_bd($sql, $conn);

// Извлечение информации из определённых столбцов таблицы БД (фильтрация) - выделение данных
//
$sql = "SELECT fml, stud_id FROM Students ";
echo "\nGetting name and id of students:\n";
get_from_bd($sql, $conn);

// Извлечение информации из определённых столбцов таблицы БД (фильтрация) - выделение данных
//
echo "\nGetting POIT students info:\n";
$sql = "SELECT fml FROM Students WHERE spec_id = 1";
get_from_bd($sql, $conn);

// Извлечение информации из таблицы с сортировкой по именам БД (фильтрация) - выделение данных
//
echo "\nGetting students info sorted by student id:\n";
$sql = "SELECT * FROM Students ORDER BY stud_id ASC";
get_from_bd($sql, $conn);

// Извлечение объединённых данных - имя студента + название специальности
// В таблице со студентами у каждого есть внешний ключ, относящийся к таблице со специальностями
// это id соответствующей специальности, по которому из таблицы со специальностями можно получать
// НАЗВАНИЕ специальности
//
echo "\nGetting names of students and names of their specialties:\n";
$sql = "SELECT Students.fml, Specialty.spec_name FROM Students 
    JOIN Specialty On Specialty.id = Students.spec_id";
get_from_bd($sql, $conn);

// Редактирование данных
//
echo "Edit name of 1 student:\n";
$sql = "UPDATE Students SET fml = 'Ivanov I.I.' WHERE id = 9"; /////////////////////////////////
if($conn->query($sql)){
    $sql = "SELECT fml FROM Students WHERE id = 9";
    get_from_bd($sql, $conn);
}else{
    echo "Ошибка при попытке редактирования данных таблицы";
}


$conn->close();

function get_from_bd(string $sql, $conn){
    if($info = $conn->query($sql)){
        /*foreach($info as $key => $val){
            echo "$key row:\n";
            foreach($val as $num => $elem){
                echo "\t$num:\n\t$elem\n";
            }
            echo "\n";
        }*/
        if($row = $info->fetch_assoc()){
            $table = "<br><table>\n<thread>\n<tr>\n";
            foreach($row as $key => $val){

                $table .= '<th>' . $key . "</th>\n";
            }
            $table .= "</tr>\n</thead>\n<tbody>\n";
            foreach($info as $key => $next_row){
                $table .= "<tr>\n";
                foreach($next_row as $val){
                    $table .= '<td>'.$val."</td>\n";
                }
                $table .= "</tr>\n";
            }
            $table .= "</tbody>\n</table><br>\n\n";
            echo $table;
        }

        $info->free();
    }else{
        echo "Ошибка при извлечении информации: ". $conn->error;
    }
}