Program Project2;

{$APPTYPE CONSOLE}

Uses
  SysUtils;

Const
  N = 10;

Type
  TArray = Array[1..N] of Real;

Var
  Massiv: TArray;
  i, r, rTemp, Counter, rExit: Integer;

Begin
  For i := 1 to N do
  Begin
    Writeln('Enter the element Massiv[i] = ');
    Readln(Massiv[i]);
  End;
  rTemp := 1;
  r := rTemp+1;
  Counter := 1;
  i := 2;
  While i <= N-1 do
  Begin
    If (Massiv[i] < Massiv[i-1]) and (Massiv[i] < Massiv[i+1]) then
    Begin
      rTemp := rTemp+2;
      i := i+2;
      rExit := rTemp;
    End
    Else
    Begin
      If rTemp = r then
        Counter := Counter+1;
      If rTemp > r then
        r := rTemp;
      i := i+1;
      rTemp := 1;
    End;
  End;
  If rExit = r then
    Counter := Counter+1;
  If rExit > r then
    r := rExit;
  If r < 3 then
  Begin
    Counter := 0;
    r := 0;
  End;
  Write('Source array: ');
  For i := 1 to N do
    Write(Massiv[i]:6:2, ' ');
  Writeln;
  Writeln('The length of the longest <sawtooth> (teeth down) of sequence r = ', r);
  Writeln('Their number: ', Counter);
  Readln
End.
