<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
    <form method="POST">
        <label>
            Input arrays dimension
            <input type="number" min="5" size="5" value="5" name="dimension_value"></input>
        </label>
        <button type="submit" name="dimension_btn">Send</button>
    </form>
    <?php include 'genForms.php'?>
    <?php include 'arrayProcessing.php'?>
</body>
</html>