<?php
$form_template = "<label>Cities: <br><textarea type='text' rows='5' cols='30' name='cities' %s </textarea></label>
    <button type='submit' name='cities_btn'>Send</button><br><br>";
$city_name_templ = "/^[A-Z][a-z-]*$|^[А-ЯЁ][а-яё-]*$/u"; //
$error_message = null;
if(isset($_GET["cities_btn"])){
    if(isset($_GET["cities"])){
        $cities_names = preg_split('/\W+/u',$_GET["cities"], -1, PREG_SPLIT_NO_EMPTY);
        //print_r($cities_names);
        $correct_str = true;
        $check_res = null;
        if($cities_names){
            $cities_numb = count($cities_names);
            for($i = 0; $i < $cities_numb && $correct_str; $i++){
                $check_res = preg_match($city_name_templ,$cities_names[$i]);
                if($check_res === 0){
                    $correct_str = false;
                    $error_message = "<p>The string \"". $cities_names[$i] . "\" does not correspond to the name of the city - it must consist 
of either Cyrillic or Latin characters, 
it may contain a hyphen starting with an uppercase letter</p>";
                    //echo err_form($form_template, $error_message);
                }elseif($check_res === false){
                    $correct_str = false;
                    $error_message = "<h2>The entered text cannot be processed</h2>";
                    //echo err_form($form_template, $error_message);
                }
            }
            if($correct_str){
                sort($cities_names);
                for($i = 1; $i < $cities_numb; $i++){
                    if(!strcmp($cities_names[$i-1], $cities_names[$i])){
                        unset($cities_names[$i-1]);
                    }
                }
                $res = sprintf($form_template, ">");

                foreach($cities_names as $value){
                    $res .= $value . "<br>";
                }
                echo $res;
            }
        }
        else{
            $error_message =  "<h2>The entered text cannot be processed</h2>";
        }
    }
    else{
        $error_message = "<h2>Text didn't reach the server</h2>";
    }
    if($error_message){
        echo err_form($form_template, $error_message);
    }
}else{
    echo sprintf($form_template, ">");
}

function err_form(string $f_templ, string $err_mess) : string{
    $f_templ = sprintf($f_templ,"style='background-color: red'>". $_GET["cities"]);
    $f_templ .= "<br>" . $err_mess;
    return $f_templ;
}