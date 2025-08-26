<?php
$res = "\n<table>\n";
if($argc > 1){
    if(is_numeric($argv[1]) && is_int($argv[1]+0)){
        for($i = 1; $i <= $argv[1]; $i++){
            $res .= "\t<tr>". $i . "</tr>\n";
        }
        $res .= "</table>\n";
    }
    else{
        $res = "\nIncorrect input\n";
    }
    echo $res;
}