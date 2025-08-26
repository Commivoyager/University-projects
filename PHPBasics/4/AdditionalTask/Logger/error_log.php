<?php
require_once('Logger.php');

$file_logger = new Logger(Logger::IN_FILE);
$screen_logger = new Logger(Logger::ON_SCREEN);

date_default_timezone_set('Europe/Minsk');
for($i = 0; $i < 5; $i++){
    $file_logger->log_message("Some message in file №".$i);
    sleep(1);
    $screen_logger->log_message("Some message on screen №".$i);
    sleep(1);
}