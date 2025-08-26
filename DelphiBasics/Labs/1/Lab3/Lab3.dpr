program Lab3Pred;

{$APPTYPE CONSOLE}

uses
  SysUtils;
Const
  xStart = 0.1;
  xFinish = 0.9;
  xStep = 0.1;
  E = 1E-5;
Var
x, Temp2, TempSum, Sum, PrevSum, Delta: Real;
k, Temp1, Temp3, Counter: Integer;

begin
  x := xStart;
  While x <= xFinish do
  Begin
    k := 1;
    Temp1 := -1;
    Temp2 := 1/x;
    Temp3 := k;
    PrevSum := 0;
    Delta := E;
    Counter := 0;
    While Delta >= E do
    Begin
      Temp1 := Temp1*(-1);
      Temp2 := Temp2*x*x;
      Temp3 := Temp3*(k+1);
      TempSum := Temp1*Temp2/Temp3;
      Sum := PrevSum+TempSum;
      Counter := Counter+1;
      Delta := Abs(Sum-PrevSum);
      k := k+1;
      PrevSum := Sum;
    End;
    Write('x = ', x:3:1);
    Write(' Sum = ', Sum:7:7);
    Writeln('  Counter = ', Counter);
    x := x+xStep
  End;
  Readln
end.                       
