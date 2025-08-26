<?php
class FileManager
{
    private $page_content = '';
    private $fname = "filename";
    private $fpath = "./files";
    private $files = array();
    //private $login;

    public function __construct(string $login=""){
        //$this->login = $login;
        if($login){
            $this->fpath .= "/".$login;
        }
        if(!is_dir($this->fpath)){
            mkdir($this->fpath, 0777, true);
        }
    }
    private function upload_file(){/*public function __construct(){
        $page_content = '';
    }*/
        if($_FILES && $_FILES[$this->fname]["error"] == UPLOAD_ERR_OK){
            $source_name = $_FILES[$this->fname]["name"];
            $host_path = $this->fpath . "/" . $source_name;
            //echo $_FILES[$this->fname]["tmp_name"];
            move_uploaded_file($_FILES[$this->fname]["tmp_name"], $host_path);
            //$this->files[] = $source_name;
            $this->page_content .= "File was \"". $source_name . "\" uploaded successfully"."<br>";
        }
    }
    private function show_files(){
        if(!empty($this->files)){
            $content = "<ul>";
            $count = 0;
            foreach($this->files as $key => $val) {
                $download = $this->fpath."/".$val;
                $content .= "<a href='$download' download>$val</a><span>   </span><input type='submit' value=\"Delete\" name=\"$count\"><br>";
                $count++;
            }
            $content .= "</ul>";
            $this->page_content .= $content;
        }else{
            $this->page_content .= "There are no files yet. But you can add some";
        }
    }

    private function update_files(){
        if(is_dir($this->fpath)){
            if($dir = opendir($this->fpath)){
                unset($this->files);
                while(($file = readdir($dir)) !== false){
                    if(is_dir($file) === false){
                        $this->files[] = $file;
                        //echo $file;
                    }
                }
                closedir($dir);
            }else{
                $this->page_content .= "The directory with files could not be opened";
            }
        }else{
            $this->page_content .= "There is no directory with files";
        }

        foreach($_POST as $key => $val){
            if($val === 'Delete')
            {
                if(isset($this->files[$key])){
                    $del_path = $this->fpath. "/". $this->files[$key];
                    //echo $del_path;
                    if(file_exists($del_path)){
                        if(!unlink($del_path)){
                            $this->page_content .= "This file cannot be deleted";
                        }else{
                            $this->page_content .= "File \"". $this->files[$key] . "\" was successfully deleted";
                            unset($this->files[$key]);
                        }
                    }else{
                        $this->page_content .= "This file cannot be deleted";
                    }
                }
            }
        }
    }

    public function get_content(){
        $this->upload_file();
        $this->update_files();
        $this->show_files();
        return $this->page_content;
    }
}




/*$count = 0;
while(($file = readdir($dir)) !== false){
    if(is_dir($file) === false){
        //$get_val = "file".$count;
        //$content .= "<a href=\"?$get_val=$file;\">$file</a><br>";
        $download = $this->fpath.$file;
        $content .= "<a href='$download' download>$file</a>
                        <input type='submit' value=\"Delete\" name=\"$count\"><br>";
        $this->files[$count] = $file;
        $count++;
    }
}*/