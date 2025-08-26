<?php
    function generator(int $start, int $end){
        for($i = $start; $i <= $end; $i++){
            $now = $i*$i;
            yield $now;
        }
    }

    $generated = generator(3,10);
    print_r($generated);
    foreach($generated as $val)
    {
        echo $val . "\n";
    }

    foreach(generator(3,10) as $val){
        echo $val . "\n";
    }

function longGenerator(int $start)
{
    $i = $start;
    yield $i*$i;
    $i++;
    yield $i*$i;
    $i++;
    yield $i*$i;
    $i++;
    yield $i*$i;
    $i++;
    yield $i*$i;
    $i++;
    yield $i*$i;
    $i++;
    yield $i*$i;
    $i++;
    yield $i*$i;
}
    echo "long\n";
    foreach(longGenerator(3) as $val){
        echo $val . "\n";
    }

    function fromGenerator(){
        yield [1,2,3,4,5];
        yield 0;
    }

    echo "\nfrom\n";
    foreach(fromGenerator() as $val){
        print_r($val);
    }