<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<form method="get">
    <label>Words: <br><textarea type="text" rows="5" cols="30" name="words"></textarea></label>
    <button type='submit' name="words_btn">Send</button><br><br>
    <?php include 'uppercase_and_purple.php'?>
</form>

<form method="get">

    <?php include 'cities_sort.php'?>
</form>
</body>
</html>