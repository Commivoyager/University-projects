<?php
$password = '';
$hostname = 'localhost';
$username = 'root';
$dbname = 'first_bd';

$conn = new mysqli($hostname,$username,$password, $dbname);
if($conn->connect_error){
    die("Connection error: ". $conn->connect_error);
}
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


$sql="SELECT Students.fml, Students.stud_id, Specialty.spec_name
FROM Students JOIN Specialty On Specialty.id = Students.spec_id
ORDER BY Specialty.id DESC";
get_from_bd($sql,$conn);

$conn->close();

function get_from_bd(string $sql, $conn){
    $styles = "
    <style>
            table {
                border-collapse: collapse;
            }
            th, td {
                border: 1px solid black;
                padding: 8px;
                text-align: left;
            }
    </style>
    ";
    if($info = $conn->query($sql)){
        if($row = $info->fetch_assoc()){
            $table = $styles."<br><table>\n<thread>\n<tr>\n";
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