<?php
session_start();
require_once('Authorizer.php');
if(isset($_POST['login']) && isset($_POST['password'])) {
    $db_info = new Authorizer();
    $user_login =  $_POST['login'];
    $user_password = $_POST['password'];
    if($db_info->is_uniq_login($user_login))
    {
        header("Location: index.php?page=logon.html&message=You have entered either a non-existent username or incorrect password!<br>");
        exit();
    }else{
        if(password_verify($user_password, $db_info->get_hash($user_login))){
            $_SESSION['login'] = $user_login;
            header("Location: index.php?page=manager.php&message=You have been successfully logged in!<br>");
            exit();
        }else{
            header("Location: index.php?page=logon.html&message=You have entered either a non-existent username or incorrect password!<br>");
            exit();
        }
    }
}