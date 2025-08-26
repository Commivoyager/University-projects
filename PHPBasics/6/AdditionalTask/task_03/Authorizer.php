<?php
class Authorizer{
    public string $message = '';
    private $password = '200988';
    private $hostname = 'localhost';
    private $username = 'root';
    private $dbname = 'file_manager_1';
    private $tname = 'Users';

    private $conn;
    private array $users_info;
    public function __construct(){
        $this->conn = new mysqli($this->hostname,$this->username,$this->password, $this->dbname);
        if($this->conn->connect_error){
            $this->message = "DB connection error: ". $this->conn->connect_error;
        }
    }
    public function __destruct(){
        $this->conn->close();
    }
    public function is_uniq_login(string $checked) : bool{
        $flag = true;
        $this->get_users_info();
        // $user - Array ( [login] => Vadim [password] => 123 ) Array ( [login] => Vad [password] => 123 )...
        foreach($this->users_info as $key => $user){
            if((string)$key === $checked){
                $flag = false;
            }
            /*foreach($user as $val){
                if($val === $checked){

                }
            }*/
        }
        //echo $flag;
        return $flag;
    }
    private function get_users_info(){
        $sql = "SELECT login, password FROM $this->tname";
        $temp_inf = $this->conn->query($sql);
        foreach($temp_inf as $val){
            $this->users_info[$val['login']] = $val['password'];
        }
        //print_r($this->users_info);
    }

    public function register(string $login, string $hash_passwrd) : bool{
        // Для защиты SQL запросов от инъекций
        // подготовка. ? - будут заменены экранированными значениями
        $prepare = $this->conn->prepare("INSERT INTO $this->tname (login, password) VALUES (?,?)");
        // связывание параметров
        $prepare->bind_param("ss", $login, $hash_passwrd);
        // выполнение запроса
        if($prepare->execute()){
            $this->message = "Successful registration!<br>You need to log in to your account<br>";
            $prepare->close();
            return true;
        }else{
            $this->message = "Registration error:$prepare->error";
            $prepare->close();
            return false;
        }
    }

    public function get_hash(string $login) : string{
        if(isset($this->users_info[$login])){
            return $this->users_info[$login];
        }else{
            return '';
        }
    }
}