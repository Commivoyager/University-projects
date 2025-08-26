program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils;

Type
  Tp = ^El;
  El = record
    next,prev: TP;
    data: Integer;
  end;

Var
  P, First: Tp;
  i: Integer;

Procedure Make(Var P1, First:TP);
  Var
    i: Integer;
  begin
    New(P1);
    First := P1;
    P1^.prev := Nil;
    i := 1;
    While i<= 10 do
    Begin
      New(P1^.next);
      P1^.data := i;
      P1^.next^.prev := P1;
      P1 := P1^.next;
      inc(i);
    End;
    P1^.data := i;
    //P1^.next^.prev := P1;
    //P1 := P1^.next;
    P1^.next := nil;
    //P1^.data := i+1;
  end;

Procedure Delete(Var P1: TP);
  Begin
  {  If P1^.prev = nil then
      P1^.next^.prev := nil
    Else
    Begin
      If P1^.next = nil then
        P1^.prev^.next := nil
      Else
        P1^.next^.prev := P1^.prev;
        P1^.prev^.next := P1^.next;
    End;}

    If P1^.prev <> nil then
      P1^.prev^.next := P1^.next;
    If P1^.next <> nil then
      P1^.next^.prev := P1^.prev;
  End;

begin
  Make(P,First);
  For i :=  1 to 11 do
  Begin
    Write(P^.data);
    P := P^.prev;
  End;
  P := First;
  For i := 1 to 11 do
  Begin
    Writeln(P^.data);
    P := P^.next;
  End;
  P := First;
  For i := 1 to 5 do
    P := P^.next;
  Delete(P);
  P := First;
  For i := 1 to 10 do
  Begin
    Writeln(P^.data);
    P := P^.next;
  End;
  Readln
end.
 