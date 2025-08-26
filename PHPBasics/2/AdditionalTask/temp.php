<?php

$pst = array ( "dimension" => 5, "arr_elements1" => "asvscd", "arr_elements2" => "2 3",
    "arr_elements3" => "3 4", "arr_elements4" => "4 5", "arr_elements5" => "5 6", "array_btn" =>"yes" );

const SEPARATORS_NUM = 3;
const SEPARATORS = [",", " ", ";"];
//const ARRAY_DIMENTION = 5;
if(isset($pst["array_btn"])){
    if(isset($pst["dimension"])){
        $arr_dimension = $pst["dimension"];
        $res_array = check_array($arr_dimension, $pst);
        if($res_array){
            print_r($res_array);
        }
    }
    else{
        echo "<h2>Some problems with array dimension value. Try to input your data again</h2>";
    }
}

function check_array(int $dimnsn, array $pst) : array | null{
    $is_correct_data = true;
    $el_array = array();
    $arr_pntr = &$el_array;
    for($i = 1; $i <= $dimnsn  && $is_correct_data; $i++){
        $arr_pntr["dim".$i] = array();
        if($pst["arr_elements".$i] != ""){
            unset($array_numbers);
            $elem_str = $pst["arr_elements".$i];
            $is_correct_data = false;
            $sep_ind = 0;
            while($sep_ind < SEPARATORS_NUM && !$is_correct_data)
            {
                $is_correct_data = strpos($elem_str, SEPARATORS[$sep_ind], 0);
                $sep_ind++;
            }
            if($is_correct_data){
                $sep_ind--;
                $array_numbers = explode(SEPARATORS[$sep_ind], $elem_str);
            }
            else{

                $array_numbers[] = $elem_str;
                $is_correct_data = true;
            }
            /*for($i = 0; $i < SEPARATORS_NUM && !$is_correct_data; $i++){
               //$array_numbers = explode(SEPARATORS[$i], $elem_str);
                if(!empty($array_numbers)){
                    //$i = SEPARATORS_NUM;
                    $is_correct_data = true;
                }
            }*/
            //if($is_correct_data){
            $values_count = count($array_numbers);
            for($j = 0; $j < $values_count && $is_correct_data; $j++){
                if(!is_numeric($array_numbers[$j])){
                    $is_correct_data = false;
                    $el_array = null;
                    echo "<h2>All arrays elements must be numbers separated by one of characters: ',', ' ', ';'</h2>";
                }
                else{
                    $arr_pntr["dim".$i][] = $array_numbers[$j];
                }
            }
            //}
            /*else{
                $el_array = null;
                echo "<h2>Elements of array must be </h2>";
            }*/
        }
        if($el_array){
            $arr_pntr = &$arr_pntr["dim".$i];
        }
    }
    return $el_array;
}
