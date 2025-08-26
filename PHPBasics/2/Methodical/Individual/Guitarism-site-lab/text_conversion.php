<?php
const LETTER_STYLE = "<span style=\"color: purple;\">";
if(isset($_POST["input_text"])){
    $text_content = $_POST["input_text"];
    //Text output
    $o_count = preg_match_all('/[oOоО]/u', $text_content, $str_arr);
    $str_arr =  preg_split('/\W+/u', $text_content, -1, PREG_SPLIT_NO_EMPTY);
    foreach($str_arr as $key => $value){
        if(2 == $key%3){
            //Изменение регистра
            $str_arr[$key] = mb_strtoupper($value);
        }
        //нет мультибайтового аналога substr_replace
        $symb3 = mb_substr($str_arr[$key], 2, 1); // пустая строка (false), если длина меньше 3
        if($symb3){
            $symb3 = LETTER_STYLE . $symb3 . "</span>";
            //$symb3 = mb_substr_replace($value, $letter_style, 2, 0);
            $str_arr[$key] = mb_substr_replace($str_arr[$key], $symb3, 2, 2);
        }
    }
    echo "<div style=\"background-color: rgb(53, 55, 56, 0.90);\"><p>". 'There are '. $o_count . ' letters "o" or "O" in your text' . "</p>";
    echo "<p>";
    foreach($str_arr as $value){
        echo $value . "<br/>";
    }
    echo "</p>";
} else {
    echo "<h2>Text didn't reach the server</h2>";
}
function mb_substr_replace(string $source_str, string $repl_str, int $start_pos, int $endPos) : string
{
    return mb_substr($source_str, 0, $start_pos) . $repl_str . mb_substr($source_str, $endPos+1);
}