<?php
const SEPARATORS_NUM = 3;
const SEPARATORS = [",", " ", ";"];
const LVL_COLORS = ["red", "blue", "green", "purple", "yellow"];
const NUM_COLORS = 5;

if(isset($_POST["array_btn"])){
    if(isset($_POST["dimension"])){
        $arr_dimension = $_POST["dimension"];
        $res_array = check_array($arr_dimension);
        if($res_array){
            print_r($res_array);
            echo outp_color_arr($res_array);
        }
    }
    else{
        echo "<h2>Some problems with array dimension value. Try to input your data again</h2>";
    }
}

function check_array(int $dimnsn) : array | null{
    $is_correct_data = true;
    $el_array = array();
    $arr_pntr = &$el_array;
    for($i = 1; $i <= $dimnsn  && $is_correct_data; $i++){
        //$arr_pntr["dim".$i] = array();
        //if(isset($_POST["arr_elements".$i])){
        if($_POST["arr_elements".$i] != ""){
            unset($array_numbers);
            $elem_str = $_POST["arr_elements".$i];
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
            $values_count = count($array_numbers);
            for($j = 0; $j < $values_count && $is_correct_data; $j++){
                if(!is_numeric($array_numbers[$j])){
                    $is_correct_data = false;
                    $el_array = null;
                    echo "<h2>All arrays elements must be numbers separated by one of characters: ',', ' ', ';'</h2>";
                }
                else{
                    $arr_pntr[] = $array_numbers[$j];
                }
            }
        }
        if($i < $dimnsn){
            $arr_pntr["dim".($i+1)] = array();
            $arr_pntr = &$arr_pntr["dim".($i+1)];
        }

    }
    return $el_array;
}

function outp_color_arr(array $arr, int $dim = 1) : string { //NUM_COLORS
    if($dim > NUM_COLORS){
        $dim = NUM_COLORS;
    }
    $res = sprintf("<div style=\"color: %s; padding: 5px; background-color: darkgrey; border: 1px solid black\">", LVL_COLORS[$dim-1]);
    $inner_arr = null;
    foreach($arr as $val){
        if(is_array($val)){

            $inner_arr = outp_color_arr($val, $dim+1);
        }
        else{
            $res .= $val." ";
        }
    }
    $res .= $inner_arr . "</div>";
    return $res;
}
