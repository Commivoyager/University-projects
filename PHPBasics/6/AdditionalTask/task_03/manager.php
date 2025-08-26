<?php
    session_start();
    if(!isset($_SESSION['login'])){
        header("Location: index.php?page=logon.html&message=To get started, you need to log in!<br>");
        exit();
    }
    $login = $_SESSION['login'];
    require_once('../FileManager.php');
    $repl_str = ['{message}','{info}'];
    $content = file_get_contents('manager.html');
    $message = "<h2>Hello, $login!</h2>";

    $manager = new FileManager($_SESSION['login']);
    $content = str_replace($repl_str, [$message, $manager->get_content()],$content);
    echo $content;
