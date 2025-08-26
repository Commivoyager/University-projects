program Lab11;

{$APPTYPE CONSOLE}

uses
  SysUtils;

Type
  TpEl = ^TEl;
  TEl = Record
    Num: Integer;
    Prev: TpEl;
  End;

Var
  StackTop: TpEl;
  ExprF: Text;
{
Procedure MakeStack(Var Top: TpEl);
  Begin
    //New(Top);
    Top := nil;
  End;     }

Procedure Push(Var Top: TpEl; Var Number: Integer);
  Var
    pEl: TpEl;
  Begin
    New(pEl);
    pEl^.prev := Top;
    Top := pEl;
    Top^.Num := Number;
  End;

Procedure Pop(Var Top: TpEl; Var Number: Integer);
  Var
    pEl: TpEl;
  Begin
    Number := Top^.Num;
    pEl := Top;
    Top := Top^.Prev;
    Dispose(pEl);
  End;

Procedure DeleteStack(Var Top: TpEl);
  Var
    pEl: TpEl;
  Begin
    While Top <> nil do
    Begin
      pEl := Top;
      Top := Top^.Prev;
      Dispose(pEl);
    End;
  End;

Function Calc(Var F: Text; Var STop: TpEl):Integer;
  Var
    Symb: Char;
    ExprNum,Num1,Num2,i: Integer;
  Begin
    Reset(F);
    While not EoF(F) do
    Begin
      Read(F,Symb);
      If (Symb >= '0') and (Symb <= '9') then
      Begin
        ExprNum := Ord(Symb)-Ord('0');
        Push(STop,ExprNum);
      End
      Else
      Begin
        Pop(STop,Num2);
        Pop(STop,Num1);
        Case Symb of
          '+':
          Begin
            ExprNum := Num1+Num2;
            Push(STop,ExprNum);
          End;
          '-':
          Begin
            ExprNum := Num1-Num2;
            Push(STop,ExprNum);
          End;
          '*':
          Begin
            ExprNum := Num1*Num2;
            Push(STop,ExprNum);
          End;
          '@':
          Begin
            ExprNum := 1;
            For i := 1 to Num2 do
              ExprNum := ExprNum*Num1;
            Push(STop,ExprNum);
          End;
        End;
      End;
    End;
    Close(F);
    Result := STop^.Num;
  End;

begin
  AssignFile(ExprF, 'File.txt');
  //MakeStack(StackTop);
  StackTop := nil;
  Write('The result of expression: ', Calc(ExprF,StackTop));
  DeleteStack(StackTop);
  Readln;
end.
