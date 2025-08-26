<?php
    //require_once("TemplEng.php"); // мб просто здесь же добавить функцию вместо класса
    $page = '';
    $mess = '';
    if(!empty($_GET) && isset($_GET['page'])){
        $page = $_GET['page'];
        if($page === 'manager.php'){
            header("Location: ".$page);
            exit();
        }
        if(isset($_GET['message'])){
            $mess = $_GET['message'];
        }
    }else{
        $page = "logon.html";
        session_start();
        session_unset();
        session_destroy();
    }
    unset($_POST);
    unset($_GET);
    echo go_to($page, $mess);

    function go_to(string $file_name, string $mess = "") : string{
        $replace_str = "{message}";
        if(!is_file($file_name)){
            return "There is no such page:<br>\"$file_name\"";
        }else{
            $templ = file_get_contents($file_name);
            $mess = "<h2>$mess</h2>";
            return str_replace($replace_str, $mess, $templ);
        }
    }