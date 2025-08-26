<?php
const MIN_DIMENSION = 5;
if(isset($_POST["dimension_btn"])){
    if(isset($_POST["dimension_value"])){
        $arr_dimension = $_POST["dimension_value"];
        if(is_numeric($arr_dimension)){
            if($arr_dimension >= MIN_DIMENSION){
                $form_elem_templ = "<label>
                                    %s dimension
                                    <input type=\"text\" size=\"20\" name=\"arr_elements%s\"></input>
                                    </label>";
                $input_forms = "<br/><form method=\"POST\">
                                <input value=\"%d\" type=\"hidden\" name=\"dimension\"></input><br/>
                                Input values of the:%s<br/>
                                <button type=\"submit\" name=\"array_btn\">Send</button></form>";
                $temp = null;
                for($i = 0; $i < $arr_dimension; $i++){
                    $temp .= "<br/>". sprintf($form_elem_templ, $i+1, $i+1);
                }
                echo sprintf($input_forms, $arr_dimension, $temp);
            }
            else{
                echo "<h2>Arrays dimension can't be less than 5</h2>";
            }
        }
        else{
            echo "<h2>Not numeric</h2>";
        }
    }
    else{
        echo "<h2>No value</h2>";
    }
}
//DEBUG
//print_r($_POST);
/*else{
    echo "<h2>No btn</h2>";
}*/
/*print_r($_POST);*/
