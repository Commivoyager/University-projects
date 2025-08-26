<?php

class FormBuilder
{
    const METHOD_POST = "post";
    const METHOD_GET = "get";

    //
    public array $form;
    public string $outp_form;

    public function __construct(string $method_type, string $target_path, string $btn_lbl)
    {
        $this->form["form_open"] = '<form method="' . $method_type . '" target="' . $target_path . '">';
        $this->form["editable"] = array();
        $this->form["form_btn"] = '<input type="submit" value="' . $btn_lbl . '" />';
        $this->form["close"] = "</form>";
    }

    public function addTextField(string $name, string $value = null)
    {
        $str = '<input type="text" name="' . $name;
        if ($value != null) {
            $str .= '" value="' . $value;
        }
        $this->form["editable"][$name] = $str . '"/>';
    }

    public function addRadioGroup(string $name, array $values)
    {
        $this->form["editable"][$name] = array();
        foreach ($values as $val) {
            $this->form["editable"][$name][$val] = '<input type="radio" name="' . $name . '" value="' . $val . '"/>';
        }
    }

    protected function get_from_arr(array $arr): string
    {
        $res = null;
        foreach ($arr as $val) {
            if (is_array($val)) {
                $res .= $this->get_from_arr($val);
            } else {
                $res .= $val;
            }
        }
        return $res;
    }

    public function getForm()
    {
        //print_r($this->form);
        $this->outp_form = $this->get_from_arr($this->form);
        echo $this->outp_form;
    }
}