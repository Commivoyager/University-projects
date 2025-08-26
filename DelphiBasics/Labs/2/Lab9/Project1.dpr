program Project1;

{$APPTYPE CONSOLE}

uses
  SysUtils;
{
Const
  Ñonsonants =  }
Type
  TSet = Set of 'à'..'ÿ';

Var
  wordF: text;
  Result: TSet = ['á','â','ã','ä','æ','ç','ê','ë','ì','í','ï','ð','ñ','ò','ô','õ','ö','÷','ø','ù'];

Procedure Scan(Var F: text; Var Res: TSet);
  Var
    Symb: Char;
  Begin
    Reset(F);
    Repeat
      Read(F,Symb);
      If Symb In Res then
        Res := Res - [Symb]
    Until Symb = '.';
    Close(F);
  End;

Procedure Outp(Var F: text; Var Res: TSet);
  Var
    Symb: Char;
  Begin
    Append(F);
    For Symb := 'à' to 'ÿ' do
    Begin
      If Symb In Res then
        Write(F,Symb);
    End;
    Close(F);
  End;

begin
  AssignFile(wordF,'Words.txt');
  Scan(wordF,Result);
  Outp(wordF,Result);
end.
