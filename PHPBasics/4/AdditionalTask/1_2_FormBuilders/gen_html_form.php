<?php
require_once('FormBuilder.php');
require_once('SafeFormBuilder.php');

//FormBuilder object:
/*$my_form = new FormBuilder(FormBuilder::METHOD_POST, '/destination.php', 'Send!');
$my_form->addTextField('someName', 'Default value');
$my_form->addRadioGroup('someRadioName', ['A', 'B']);
$my_form->getForm();*/

//SafeFormBuilder object:
$my_form = new SafeFormBuilder(FormBuilder::METHOD_POST, '', 'Send!');
$my_form->addTextField('someName', 'Default value');
$my_form->addTextField('someName2', 'Default value2');
$my_form->addRadioGroup('someRadioName', ['A', 'B']);
$my_form->getForm();
echo htmlspecialchars($my_form->outp_form);
$_POST["someName"] = 'From $_POST';
$_GET["someName2"] = 'From $_GET';
$my_form->names_forming();
$my_form->getForm();
echo htmlspecialchars($my_form->outp_form);