<?php
if($argc > 1 && is_numeric($argv[1])){
    $res = 0;
    $source = $argv[1];
    for($i = 0; $i < strlen($source); $i++){
        $digit = $source[$i];
        if(is_numeric($digit)){
            $res += $digit;
        }
    }
    echo "\n" . $res . "\n";
}