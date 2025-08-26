program Lab1_2v;

{$APPTYPE CONSOLE}

uses
  SysUtils;

Type
  Arr = array[1..64] of Integer;
  Pntr = ^Element;
  Element = Record
    Next: Pntr;
    Num: Integer;
  End;

Var
  k, N, quantity, i, d, q: Integer;
  First, Start, Deleted, P: Pntr;
  Delet: Arr;

Procedure Make( Var First: Pntr; Const N: Integer);
  Var
    i: Integer;
    P: Pntr;

  Begin
    New(P);
    First := P;
    For i := 1 to N do
    Begin
      New(P^.next);
      P := P^.next;
      P^.Num := i;
    End;
    P^.next := First^.next;
  End;

Procedure Input(Var k, N, quantity: Integer);
  Var
    kCheck, NCheck: String;
    Flag: Boolean;

  Begin
    Flag := False;
    While not Flag do
    Begin
      Flag := True;
      Writeln('Enter k');
      Readln(kCheck);
      Writeln('Enter N');
      Readln(nCheck);
      //If (length(kCheck) > 2) or (Length(NCheck))
      For i := 1 to length(kCheck) do
      Begin
        If (Ord(kCheck[i]) < 48) or (Ord(kCheck[i]) > 57) then
          Flag := False;
      End;
      For i := 1 to length(NCheck) do
      Begin
        If (Ord(NCheck[i]) < 48) or (Ord(NCheck[i]) > 57) then
          Flag := False;
      End;
      If not Flag then
        Writeln('The values of k and N must be a number');
      If Flag then
      Begin
        k := StrToInt(kCheck);
        N := StrToInt(NCheck);
        If (k = 0) or (N < k) then
        Begin
          Flag := False;
          Writeln('The value of k must be greater than 0 and less than or equal to N');
        End
        Else
        Begin
          quantity := N-1;
          {If k = 1 then
            quantity := N-k
          Else
            quantity := N-k+1;
           }
        End;
      End;
    End;
  End;

Procedure Outp(Var First, Deleted: Pntr; Var i, d: Integer; Var Delet: Arr);
  Var
    t: Integer;
    P: Pntr;

  Begin
    Delet[i] := Deleted^.Num;
    //Writeln;
    //Write('--------|');
    {For t := 1 to i do
    Begin
      Write('---');
    End;
    Writeln; }
    Write('| ',Deleted^.Num:2);
    {For t := 1 to i do
    Begin
      Write('|', Delet[t]:2);
    End;   }
    //Write('|');
    inc(d)
  End;

Procedure Delete(Var Start, Deleted, First: Pntr; Const k: Integer);
  Var
    i: Integer;
  Begin
    For i := 1 to k-1 do
      Start := Start^.Next;
    If Start^.next = First^.next then
      First := Start^.next;
    Deleted := Start^.Next;
    Start^.next := Start^.Next^.next;
  End;

begin
  Input(k,n,quantity);
  Make(First,N);
  Start := First;
  Writeln;
  For i := 1 to 6 do
    Write('----');

  //Write('Deleted | All');
  Writeln;
  For q := 1 to N do
  Begin
    Make(First,q);
    Start := First;
    Write(' N = ', q:2, ' ');
    d := 0;
    For i := 1 to q-1 do
    Begin
      Delete(Start,Deleted,First,k);
      Outp(First,Deleted,i,d,Delet);
    End;
    //Writeln;
    //Writeln;
    Write('| Remained: ');
    P := First^.next;
    For i := 1 to q-d do
    Begin
      Write(P^.Num:3, ' ');
      P := P^.Next;
    End;
    Writeln;
    For i := 1 to q+6 do
      Write('----');
    Writeln;
  End;
  Write(' Step   |');
  For i := 1 to quantity do
    Write(i:3,'|');
  Writeln;
  For i := 1 to quantity+2 do
    Write('----');
  Readln
end.
