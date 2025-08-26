<?php
require_once('Authorizer.php');
/*$password = '200988';
$hostname = 'localhost';
$username = 'root';
$dbname = 'file_manager_1';
$tname = 'Users';*/

if(isset($_POST['login']) && isset($_POST['password'])){
    $db_info = new Authorizer();
    if($db_info->message !== ''){
        die($db_info->message);
    }
    $user_login =  $_POST['login'];
    $user_password = $_POST['password'];
    //$conn = new mysqli($hostname,$username,$password, $dbname);
    /*if($conn->connect_error){
        die("DB connection error: ". $conn->connect_error); ///////////////////////////////////////////////////////
    }*/
    //$sql = "SELECT login FROM $tname";
    //$correct_login = true;
    //get_from_bd($sql
    //$logins = $conn->query($sql);
    if($db_info->is_uniq_login($user_login))
    {
        $hash = password_hash($user_password, PASSWORD_DEFAULT);
        if($db_info->register($user_login, $hash)){
            header("Location: index.php?page=logon.html&message=".$db_info->message);
            exit();
        }else{
            header("Location: index.php?page=registration.html&mess=") . $db_info->message;
            exit();
        }
    }else{
        header("Location: index.php?page=registration.html&message=This login already exists. Try another value!<br>");
        exit();
    }
}





/*


    if($correct_login){
        //echo "Well!!!";

        $hash = password_hash($password, PASSWORD_DEFAULT);
        // Для защиты SQL запросов от инъекций
        // подготовка. ? - будут заменены экранированными значениями
        $prepare = $conn->prepare("INSERT INTO $tname (login, password) VALUES (?,?)");
        // связывание параметров
        $prepare->bind_param("ss", $user_login, $user_password);
        // выполнение запроса
        if($prepare->execute()){
            header("Location: index.php?page=logon.html&message=Successful registration!<br>You need to log in to your account<br>");
            //echo "Successful registration!<br>You need to log in to your account<br>";
            exit();
        }else{
            header("Location: index.php?page=registration.html&mess=Registration error:$prepare->error");
            exit();
        }

    }else{
        //echo "Exists!!!";
        header("Location: index.php?page=registration.html&message=This login already exists. Try another value!<br>");
        //header("index.php");
        exit();
    }

    //print_r($_POST);
    $prepare->close();
    $conn->close();



 */