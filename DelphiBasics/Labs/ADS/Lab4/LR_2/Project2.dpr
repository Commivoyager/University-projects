program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils;

Type
  Pntr = ^El;
  El = record
    Next, Prev: Pntr;
    Data: Integer;
  End;
  Pntr_1 = ^El_1;
  El_1 = record
    Next: Pntr_1;
    Data: Integer;
  End;

Var
  P1, First1: Pntr;
  P_1,First_1: Pntr_1;


Function Input(): Integer;
  Var
    Num: Integer;
    Flag: Boolean;
  Begin
    Flag := False;
    While not Flag do
    Begin
      Readln(Num);
      If (length(IntToStr(Num))=3) or (length(IntToStr(Num))=7) or (Num = 0) then
      Begin
        Flag := True;
        Result := Num
      End
      Else
        Writeln('Incorrect input. Try again');
    End;
  End;


Procedure Make(Var P, First: Pntr);
  Var
    Flag: Boolean;
    Num: Integer;

  Begin
    Writeln('Enter three-digit or seven-digit phone numbers. To complete, enter 0');
    New(P);
    P^.Prev := nil;
    First := P;
    Flag := False;
    Num := Input;

    If Num = 0 then
      Flag := True;
    While not Flag do
    Begin
      New(P^.Next);
      P^.Data := Num;
      P^.Next^.Prev := P;
      P := P^.Next;
      Num := Input;
      If Num = 0 then
        Flag := True;
    End;
    P^.Prev^.Next := nil;
  End;

Procedure Delete(Var P: Pntr);
  Begin
    If P^.Prev <> nil then
      P^.Prev^.Next := P^.Next;
    If P^.Next <> nil then
      P^.Next^.Prev := P^.Prev;
  End;

Procedure Delete3(Var First: Pntr);
  Var
    P: Pntr;
  Begin
    P := First;
    While P <> nil do
    Begin
      If Length(IntToStr(P^.Data)) = 3 then
      Begin
        If P^.Prev = nil then
          First := P^.Next;
        Delete(P)
      End;
      P := P^.Next;
    End;
  End;


Procedure minEl(Var First: Pntr; Var Min: Integer);
  Var
    P,DeleteP: Pntr;
  Begin
    Min := First^.Data;
    DeleteP := First;
    P := First^.Next;
    While P <> nil do
    Begin
      If P^.Data < Min then
      Begin
        Min := P^.Data;
        DeleteP := P;
      End
      Else
        P := P^.Next
    End;
    If DeleteP^.Prev = nil then
      First := DeleteP^.Next;
    Delete(DeleteP);
  End;

Procedure Make_1(Var First: Pntr; Var First_1: Pntr_1 );
  Var
    P_1: Pntr_1;
    Min: Integer;
  Begin
    New(P_1);
    First_1 := P_1;
    While First <> nil do
    Begin
      minEl(First,Min);
      P_1^.Data := Min;
      New(P_1^.Next);
      If First <> nil then
        P_1 := P_1^.Next
      Else
        P_1^.Next := nil
    End;
  End;

begin
  Make(P1,First1);
  P1 := First1;
  While P1^.Next <> nil do
  Begin
    P1 := P1^.Next;
  End;
  While P1 <> nil do
  Begin
    Write(P1^.Data, '; ');
    P1 := P1^.Prev;
  End;
  Delete3(First1);
  Make_1(First1, First_1);
  P_1 := First_1;
  Writeln;
  While P_1 <> nil do
  Begin
    Write(P_1^.Data,'; ');
    P_1 := P_1^.Next;
  End;
  Readln
end.

 {//ToDelete
  P1 := First1;
  While P1 <> nil do
  Begin
    Write(P1^.Data, '; ');
    P1 := P1^.Next;
  End;
  Writeln;
  Write(First1^.data,'  ', First1^.next^.data); }
    Writeln;
  Writeln;
  Write(First_1^.Data,'  ',First_1^.Next^.Data );