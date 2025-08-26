<?php
$someIntVar = 1;
$someStrVar = 'Hello';
$someBoolVar = True;
$resVar = $someIntVar + $someBoolVar;
print_r("Var1:\n=");
print_r($resVar);
print_r("\nVar2:\n=");
echo $someIntVar + $someBoolVar + (int)$someStrVar;