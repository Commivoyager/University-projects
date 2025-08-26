<?php
const FILE_NAME = "list.csv";
// символы-разделители для формата csv
const CSV_COL_DEVIDER = ",";
const CSV_ROW_DEVIDER = "\r\n";
$table_elem = array();
// шаблон для формы
$form_template = "
<label>id<br><input type=\"text\" name=\"product_id\" value='%s</label><br><br>
<label>name<br><input type=\"text\" name=\"product_name\" value='%s</label><br><br>
<label>price<br><input type=\"text\" name=\"product_price\" value='%s</label><br><br>
<label>description<br><input type=\"text\" name=\"product_description\" value='%s</label><br><br>
<button type='submit' name='add_btn'>Send</button><br><br>
</form>";
// шаблон для выводимых пользователю данных
$outp_inf_template = "<div style='display: flex; gap:50px;'>";

//$res = null;

$list = null;
$elem_info = null;
// в случае нажатия кнопки обрабатываются данные формы
if(isset($_POST["add_btn"])){
    $form_val = array();
    if(gen_form_elemnts($form_val)){
        add_to_file(FILE_NAME, $form_val);
    }
    echo sprintf($form_template, $form_val["product_id"]["str"], $form_val["product_name"]["str"], $form_val["product_price"]["str"], $form_val["product_description"]["str"]);
}
else{
    $close_tag = "'>";
    echo sprintf($form_template, $close_tag, $close_tag, $close_tag, $close_tag);
}
// получение информации из файла
$file_content = file_get_contents(FILE_NAME);
$table_elem = array();
if($file_content){
    $table_rows = explode(CSV_ROW_DEVIDER, $file_content);
    //print_r($table_rows);
    for($i = 0; $i < count($table_rows) - 1; $i++){
        $table_elem[] = explode(CSV_COL_DEVIDER, $table_rows[$i]);
    }
}
//print_r($table_elem);
$el_info = null;
if(isset($_GET["name"])){
    $inf = $table_elem[$_GET["name"]];
    $discount_price = round($inf[2] * 0.85, 2);
    $el_info = "<div style='border: 1px solid black; padding: 5px 10px;'> Information about selected product<br>Id: ". $inf[0].
        "<br>Name: ". $inf[1].
        "<br>price: " . $inf[2]. "; price with 15% discount: ". $discount_price.
        "<br>Description: ". $inf[3] . "</div>";
}
echo $outp_inf_template.outp_list($table_elem).$el_info."</div>";


// генерация формы после отправкки данных на основе корректности введённых данных
function gen_form_elemnts(array &$forming_arr) : bool{
    //$forming_arr = array();
    $str_names = ["product_id", "product_name", "product_description"];
    $all_correct = true;
    for($i = 0; $i < count($str_names); $i++){
        $modif_str = incorrect_to_csv($_POST[$str_names[$i]]);
        // значение с ключом "val" используется для запоминания вводимого значения
        $forming_arr[$str_names[$i]]["val"] = $_POST[$str_names[$i]];
        if($modif_str){
            $forming_arr[$str_names[$i]]["str"] = $modif_str;
            // если введённое значение некорректно, то в массиве введённых данных оно помечается
            // ложным булевским значением, чтобы в дальнейшем вывести необходимую информацию пользователю
            $forming_arr[$str_names[$i]]["flag"] = false;
            $all_correct = false;
        }
        else{
            //Нужно дописать пустое значение атрибута value (чтобы ничего не выводилось в поле)
            //и закрыть тег input
            $forming_arr[$str_names[$i]]["str"] = "'>";
            // Если значение было введено корректно, то оно помечается true в массиве данных
            $forming_arr[$str_names[$i]]["flag"] = true;
        }
    }
    // Значение из поля для стоимости должно быть неотрицательным числом
    $modif_str = check_num($_POST["product_price"]);
    $forming_arr["product_price"]["val"] = $_POST["product_price"];
    if($modif_str){
        $forming_arr["product_price"]["str"] = $modif_str;
        // Так же, как и для остальных значений
        $forming_arr["product_price"]["flag"] = false;
        $all_correct = false;
    }
    else{
        $forming_arr["product_price"]["str"] = "'>";
        // Так же, как и для остальных значений
        $forming_arr["product_price"]["flag"] = true;
    }
    if(!$all_correct){
        foreach($forming_arr as $key => $value){
            if($forming_arr[$key]["flag"]){
                $forming_arr[$key]["str"] = $_POST[$key] . $forming_arr[$key]["str"];
            }
        }
    }
    return $all_correct;
}
// проверка, подходит ли вводимое значение для внесения в файл csv
function incorrect_to_csv(string $inp_val) : string | null{
    $res = $inp_val;
    $messg = "' style='background-color: red;'>";
    if(0 !== preg_match_all('/\r\n|\n|\r|,/', $inp_val)){
        $res .= $messg . " The input data cannot contain line breaks and commas, because this will violate the CSV formatting of the table";
    }
    else{
        //Нужно дописать пустое значение атрибута value (чтобы ничего не выводилось в поле)
        //и закрыть тег input, если в данное поле были введены корректные данные
        $res = null;
    }
    return $res;
}
// проверка, корректное ли значение было введено в поле для ввода числа
function check_num(string $inp_val) : string | null{
    //Установка цвета и закрытие тега для поля ввода цены
    $res = $inp_val;
    $messg = "' style='background-color: red;'>";
    // значение цены должно быть числовым
    if(is_numeric($inp_val)){
        // значение цены должно быть как минимум неотрицательным
        if($inp_val < 0){
            $res .= $messg . " It is negative value. But price of product can be only at least 0!";
        }
        else{
            return null;
        }
    }
    else{
        $res .= $messg . " This value is not numeric. The cost of the product can be either an integer or a real positive number";
    }
    return $res;
}
// запись в файл данных, полученных в массив из формы
function add_to_file(string $fname, array $val){
    $add_str = $val["product_id"]["val"] . "," . $val["product_name"]["val"] . "," . $val["product_price"]["val"] . "," . $val["product_description"]["val"] . "\r\n";
    file_put_contents($fname, $add_str, FILE_APPEND);
}
// генерация html разметки для вывода списка продуктов, хранящихся в массиве
function outp_list(array $elements) : string {
    $res = "<div>";
    foreach($elements as $key => $value){
        $res .= "<a href='?name=" . $key . "'>" . $value[1] . "</a><br>";
    }
    $res .= "</div>";
    return $res;
}