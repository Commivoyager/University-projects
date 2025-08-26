<?php
    $age = 1;
    function myFunc(){
        global $age;
        echo "In function: " . $age . "\n";
        $age++;
    }
    myFunc();
    echo $age . "\n";

    $age = 1;
    function myFunc2(){
        $funcAge = $GLOBALS["age"];
        $funcAge++;
        echo $funcAge . "\n";
    }
    myFunc2();
    echo $age;
