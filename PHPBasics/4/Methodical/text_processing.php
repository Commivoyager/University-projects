<?php
//<textarea name="inp_text" cols="35" rows="20"></textarea>
$page_content='</textarea>
    </label>
    <button type="submit" name="send_text_btn">Send</button>
    </form><br>';

if(isset($_POST["send_text_btn"])){
    if(isset($_POST["inp_text"])){
        $str = $_POST["inp_text"];
        $page_content = $str . $page_content;
        $str = preg_replace_callback(
            '/\b[A-Za-zА-ЯЁа-яё]{8,}\b/u',
            function($matches){
                return mb_substr($matches[0],0, 6) . "*";
            },
            $str
        );
        $page_content .=  "<div>$str</div>";
    }else{
        $page_content  .= "<h2>To process the text, you need to enter it</h2>";
    }
}
echo $page_content;