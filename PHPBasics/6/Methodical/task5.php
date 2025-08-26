<?php
session_start();
$form_fields = [
    'page_color' => '#ffffff',
    'text_color' => '#000000',
    'text_size' => 14,
    'header_color' => '#000000',
    'header_size' => 28
];
if(isset($_POST)){
    foreach($form_fields as $key => $val)
    if(isset($_POST[$key])){
        $_SESSION[$key] = $_POST[$key];
        $form_fields[$key] = $_POST[$key];
    }
}

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Task5</title>
    <style>
        body{
            background-color: <?php echo $form_fields['page_color'];?>;
            font-size: <?php echo $form_fields['text_size']."px"; ?>;
            color: <?php echo $form_fields['text_color']; ?>;
        }
        .headers{
            font-size: <?php echo $form_fields['header_size']."px"; ?>;
            color: <?php echo $form_fields['header_color']; ?>;
        }
    </style>
</head>
<body>
    <h1 class="headers">Заголовок</h1>
    <form method="post">
        <label>Choose page color:
            <input type="color" name="page_color" value=<?php echo $form_fields['page_color'];?>>
        </label>
        <br><br>

        <label>Choose main text color:
            <input type="color" name="text_color" value=<?php echo $form_fields['text_color'];?>>
        </label>
        <br><br>

        <label>Choose main text size
            <input type="number" name="text_size" min="1" max="72" value="<?php echo $form_fields['text_size'];?>">
        </label>
        <br><br>

        <label>Choose header text color:
            <input type="color" name="header_color" value=<?php echo $form_fields['header_color'];?>>
        </label>
        <br><br>

        <label>Choose header text size
            <input type="number" name="header_size" min="1" max="72" value="<?php echo $form_fields['header_size'];?>">
        </label>
        <br><br>

        <input type="submit" value="Submit">
    </form>
</body>
</html>
<?php