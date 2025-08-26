<?php
class Logger
{
    private $log_method;
    const IN_FILE = true;
    const ON_SCREEN = false;
    const LOG_FILE_NAME = "error.log";

    public function __construct(bool $outp){
        if(Logger::IN_FILE == $outp){
            // записываем в массив ссылку на текущий объект
            // и метод объекта, реализующий запись в файл
            $this->log_method = array($this, 'log_in_file');
        }else{
            // записываем в массив ссылку на текущий объект
            // и метод объекта, реализующий запись в консоль
            $this->log_method = array($this, 'log_on_screen');
        }
    }
    private function log_in_file(string $message){
        file_put_contents(Logger::LOG_FILE_NAME, $message, FILE_APPEND);
    }
    private function log_on_screen(string $message){
        echo $message;
    }
    public function log_message(string $message){
        $mess = date('H:i:s d-m-Y') ."\n". $message . "\n\n";
        call_user_func($this->log_method, $mess);
    }
}