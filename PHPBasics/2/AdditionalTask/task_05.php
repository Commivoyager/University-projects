<?php
$res = array();
$max_len = 0;
for($i = 1; $i < $argc; $i++){
    if(strlen($argv[$i]) > $max_len){
        unset($res);
        $res[] = $argv[$i];
        $max_len = mb_strlen($argv[$i]);
    }
    elseif (strlen($argv[$i]) == $max_len){
        $res[] = $argv[$i];
    }
}
foreach($res as $val){
    echo "\n". $val;
}
echo "\nLength: ". $max_len;