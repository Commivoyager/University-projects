<?php
$password = '200988';
$hostname = 'localhost';
$username = 'root';
$dbname = 'file_manager_1';
$tname = 'Users';


$conn = new mysqli($hostname,$username,$password);
if($conn->connect_error){
    die("Connection error: ". $conn->connect_error);
}

/*$sql="DROP DATABASE IF EXISTS $dbname";
if($conn->query($sql)){
    die("deleted");
}else{
    die("error with delete");
}*/

$sql="CREATE DATABASE IF NOT EXISTS $dbname CHARACTER SET utf8 COLLATE utf8_general_ci";
if($conn->query($sql)){
    echo "БД создана успешно\n";
}else{
    echo "Ошибка при создании БД: ".$conn->error;
}

$conn->select_db($dbname);
$sql="SET CHARACTER SET 'UTF8'";
if(!$conn->query($sql)){
    echo "Ошибка при настройке кодировки utf-8: " . $conn->error;
}
$sql="SET NAMES 'UTF8'";
if(!$conn->query($sql)){
    echo "Ошибка при настройке кодировки utf-8: " . $conn->error;
}

$sql="CREATE TABLE IF NOT EXISTS $tname (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    login VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);";
if($conn->query($sql)){
    echo "Новая таблица создана успешно\n";
}else{
    echo "Ошибка при создании таблицы: ". $conn->error;
}

