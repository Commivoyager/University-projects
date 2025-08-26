<?php
require_once('FormBuilder.php');
class SafeFormBuilder extends FormBuilder
{
    private const CHANGE_PARAM = 'value="';

    //длина строки 'name="' - чтобы найти позицию её вхождения
    //и начать обработку последующих символов
    private const CHANGE_POS = 7;

    public function __construct(string $method_type, string $target_path, string $btn_lbl)
    {
        parent::__construct($method_type, $target_path, $btn_lbl);
    }

    private function get_from_global(string $name): string|bool
    {
        if (isset($_POST[$name])) {
            return $_POST[$name];
        }
        if (isset($_GET[$name])) {
            return $_GET[$name];
        }
        return false;
    }

    private function change_name(string $curr, string $new)
    {
        $changing_str = $this->form["editable"][$curr];
        $ch_str_len = strlen($changing_str);
        $replace_start = strpos($changing_str, SafeFormBuilder::CHANGE_PARAM);
        if ($replace_start) {
            $replace_start += SafeFormBuilder::CHANGE_POS;
            $i = $replace_start;
            while ($i < $ch_str_len && $changing_str[$i] != '"') {
                $i++;
            }
            $replace_len = $i - $replace_start;
            // замена значения атрибута name
            //$this->form["editable"][$curr] = substr_replace($changing_str, $new, $replace_start, $replace_len);

        } else {
            $new = ' value="' . $new . '"';
            $replace_start = strpos($changing_str, '/>');
            $replace_len = 0;
            //$this->form["editable"][$curr] = substr_replace($changing_str, $new, $replace_start, 0);
        }
        $this->form["editable"][$curr] = substr_replace($changing_str, $new, $replace_start, $replace_len);
    }

    public function names_forming()
    {
        foreach ($this->form["editable"] as $key => $value) {
            $new_name = $this->get_from_global($key);
            if ($new_name !== false) {
                $this->change_name($key, $new_name);
            }
        }
    }

}