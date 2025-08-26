<?php
if(isset($_GET["name"])){
    $name = $_GET["name"];
}
else{
    $name = "no name";
}
if(isset($_GET["age"])){
    $age = $_GET["age"];
}
else{
    $age = "no age";
}

echo "Name: " . $name . "; Age: " . $age;