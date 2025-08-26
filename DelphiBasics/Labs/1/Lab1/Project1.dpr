program Project1;

{$APPTYPE CONSOLE}

uses
  SysUtils;
const
  xStart = 0.6;
  xFinish = 1.1;
  xStep = 0.1;
  kStart = 1;
  nStart = 10;
  nFinish = 15;
var
  Temp1, Temp2, Temp3, TempFinish: real;
  Sum, x, f: real;
  k, n: integer;
begin
  x := xStart;
  while x <= xFinish do
  begin
    k := kStart;
    Sum := 0;
    for k := kStart to ((nStart)-1) do
    begin
      Temp1 := exp((k*x-3)/k);
      Temp2 := ln((k+1)*x);
      Temp3 := 3/(5+ln(k*x)/ln(2));
      Sum := Sum+Temp1/(Temp2+Temp3);
    end;
    n := nStart;
    for n := nStart to nFinish do
    begin
      Temp1 := exp((n*x-3)/n);
      Temp2 := ln((n+1)*x);
      Temp3 := 3/(5+ln(n*x)/ln(2));
      TempFinish := exp(ln(x+(n-1)/n)/(n-1));
      Sum := Temp1/(Temp2+Temp3)+Sum;
      f := TempFinish+Sum;
      write('x=', x:3:1, '  ');
      write('n=', n:4, '  ');
      writeln('f=', f:8:5, '  ');
    end;
  x := x+xStep;
  end;
readln
end.

