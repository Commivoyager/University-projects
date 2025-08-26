<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>File manager</title>
</head>
<body>
<form method="POST" enctype="multipart/form-data">
    <label>
        Choose file
        <input type="file" name="filename" value="Choose">
    </label>
    <input type="submit" value="Upload"><br>

    <?php
    include('../FileManager.php');
    $manager = new FileManager();
    echo $manager->get_content();
    ?>

</form>
</body>
</html>