<?php
$myArr = array(1,2,3,4,'myKey' => 5);
foreach($myArr as $key => $val)
{
    echo $key." => ".$val."\n";
}
echo "\n\n";
foreach($myArr as $value)
{
    echo $value."; ";
}