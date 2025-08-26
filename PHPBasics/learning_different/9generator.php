<?php
    function func(int $start, int $end)
    {
        for($i = $start; $i < $end; $i++)
        {
            yield $i;
        }
    }