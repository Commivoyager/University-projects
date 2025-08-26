<?php
$password = '';
$hostname = 'localhost';
$username = 'root';
$dbname = 'first_bd';

$table_name = "Tours";
$col_names = ["id", "tour_place", "tour_date", "guid_name", "max_people", "is_free"];
$col_types = ["number", "text", "date", "text", "number", "bool"];
$add_num = 5;

$add_mode = false;

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
if($add_mode){
    $sql = add_query_gen($table_name, $col_names, $col_types, $add_num);
    //echo $sql;
    if($conn->query($sql)){
        echo "Информация была усспешно добавлена в таблицу\n";
    }else{
        echo "Ошибка при добавлении информации в таблицу: ". $conn->error;
    }
}
else{
}

$sql = "SELECT * FROM $table_name";
get_from_bd($sql, $conn);



function add_query_gen(string $table, array $names, array $types, int $num) : string{
    $sql = "INSERT INTO ".$table . " (";
    $size = count($names);
    for($i = 1; $i < $size; $i++){
        $sql .= $names[$i];
        if($i < $size-1)
        {
            $sql .= ", ";
        }
    }
    $sql .= ") VALUES ";

    for($i = 0; $i < $num; $i++){
        $sql .="(";
        for($j = 1; $j < $size; $j++){
            $sql .= get_val($types[$j]);
            if($j < $size-1){
                $sql.= ',';
            }
        }
        if($i < $num-1){
            $sql .= "),";
        }else{
            $sql .= ")";
        }
    }
    return $sql;
}

function get_val(string $type) : string|int|bool|null{
    $res = null;
    if($type == 'text'){
        $res = "'". rand_str()."'";
    }elseif($type == 'number'){
        $res = rand(1,100);
    }elseif($type == 'date'){
        $start_date = time()+24*3600;//
        //echo date('Y-m-d H:i:s',$start_date-$start_date);
        //echo date('Y-m-d H:i:s',$start_date-$start_date);711
        $last_date = $start_date + 31*24*3600; // на месяц позже
        $res = "'".date('Y-m-d H:i:s',rand($start_date, $last_date)) . "'";
    }elseif($type == 'bool')
    {
        $res = rand(0,1);
    }
    return $res;
}

function rand_str(): string{
    $res = '';
    $size = rand(0, 20);
    for($i = 0; $i < $size; $i++){
        $res .= chr(rand(ord('a'), ord('z')));
    }
    return $res;
}
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