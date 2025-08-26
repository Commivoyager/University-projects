program V1_4;

{$APPTYPE CONSOLE}

uses
  SysUtils;

Type
  Pntr =^Rec;
  Rec = Record
    Data: Integer;
    Next, Prev: Pntr;
  End;

Var
  Pointer: Pntr;

Procedure Make(Var P: Pntr; Const NSl, NAb: Integer);   //Пользователь вводит NSl, NAb

  Var
    PDop: Pntr;

  Begin
    New(P);
    P^Prev := nil;
    For i := 1 to (NSl+NAb) do
    Begin
      PDop := P;
      New(P);
      PDop^Next := P;
      P^Prev := PDop;
    End;

  End;

Begin

End.
 