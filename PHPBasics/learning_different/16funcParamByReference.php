<?php
    function func(&$num){
        echo $num++;
    }
    $number = 5;
    func($number);
    echo $number;