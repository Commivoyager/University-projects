<?php
function sqr(float|int $x) : float|int
{
    return $x*$x;
}
echo sqr(2)."\n\n";
function func()
{
    $num = func_num_args();
    echo "Args number: ".$num."\n";
    if($num > 0)
    {
        for($i = 0; $i < $num; $i++)
        {
            echo $i.": ".func_get_arg($i)."\n";
        }
    }
    print_r(func_get_args());
}

func(1,2,3,4);
func("One", "Two", "Three");