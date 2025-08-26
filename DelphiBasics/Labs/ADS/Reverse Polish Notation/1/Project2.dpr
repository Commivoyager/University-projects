program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils;

Type
  Prior = record
    StackPrior, RelPrior: Integer;
  End;
  St = ^El;
  El = record
    ElSymb: Char;
    ElStackPrior: Integer;
    Prev: St;
  End;

Var
  i, ScnSymb, rank: Integer;
  s: String;
  Stack: St;

Procedure EnterStr(Var s: String);
  Begin
    Writeln('Your infix expression: ');
    Read(s);
  End;

Procedure Make(Var MTop: St);
  Begin
    New(MTop);
    MTop^.Prev := nil;
    MTop^.ElStackPrior := -1;
  End;

Function ScanSymb( Var symb: Char): Prior;
  Begin
    Case symb of
      '+', '-':
      Begin
        Result.StackPrior := 2;
        Result.RelPrior := 1;
      End;
      '*', '/':
      Begin
        Result.StackPrior := 4;
        Result.RelPrior := 3;
      End;
      '^':
      Begin
        Result.StackPrior := 5;
        Result.RelPrior := 6;
      End;
      '0'..'9', 'A'..'Z', 'a'..'z':
      Begin
        Result.StackPrior := 8;
        Result.RelPrior := 7;
      End;
      '(':
      Begin
        Result.StackPrior := 0;
        Result.RelPrior := 9;
      End;
      ')':
      Begin
        Result.RelPrior := 0;
      End;
    End;
  End;

Procedure Push(Var Top: St; Var PushSymbol: Char);

  Var
    NewEl: St;

  Begin
    New(NewEl);
    NewEl.Prev := Top;
    Top := NewEl;
    Top.ElStackPrior := ScanSymb(PushSymbol).StackPrior{PushPrior};
    Top.ElSymb := PushSymbol;
  End;

Procedure Pop(Var Top: St; Var rank: Integer);
  Var
    Delete: St;

  Begin
    If Top.ElSymb <> '(' then
    Begin
      Write(Top.ElSymb);
      If Top.ElStackPrior = 8 then
        inc(rank)
      Else
        dec(rank);
    End;
    Delete := Top;
    Top := Top.Prev;
    Dispose(Delete);
  End;


Begin
  EnterStr(s);
  Make(Stack);
  rank := 0;
  For i := 1 to Length(s) do
  Begin
    ScnSymb := ScanSymb(s[i]).RelPrior;
    While Stack.ElStackPrior > ScnSymb do
    Begin
      Pop(Stack,rank);
    End;
    If Stack.ElStackPrior = ScnSymb then
    Begin
      Pop(Stack,rank);
    End
    Else
      Push(Stack, s[i]);
  End;
  While Stack.Prev <> nil do
  Begin
    Pop(Stack,rank);
  End;
  Dispose(Stack) ;
  Writeln;
  Writeln('The rank of expression: ', rank);
  Readln;
  Readln;
End.

