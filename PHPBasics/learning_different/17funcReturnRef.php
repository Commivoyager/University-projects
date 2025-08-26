<?php
    function &func1(&$num){
        $num++;
        return $num;
    }
    $num1 = 1;
    $num2 = &func1($num1);
    $num2=0;
    echo "num1: " . $num1 . "; num2: " . $num2;


    