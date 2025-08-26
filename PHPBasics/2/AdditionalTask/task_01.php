<?php
$res = null;
for($i = 1; $i < $argc; $i++){
    $val = $argv[$i];
    $res .= $val . ": ";
    if(is_numeric($val)){
        if(is_int($val+0)){
            $res .= "int\n";
        }
        else{
            $res .= "float\n";
        }
    }
    else{
        $res .= "string\n";
    }
}
echo $res;