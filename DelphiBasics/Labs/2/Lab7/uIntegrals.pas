unit uIntegrals;

interface

// Declaration of functions for calculating the values of integrals by certain methods
Function RightRectangle(E: Real; Var Funct; a, b: Real; Var N: Integer): Real;
Function CentralRectangle(E: Real; Const F; a, b: Real; Var N: Integer): Real;

implementation

// Type declaration block
Type
  TFunct = Function(Var x: Real): Real;
  {
    The type of a procedural type parameter for calculating the value of a function at a point
  }


// The subroutine for calculating the value of the integral by the method of right rectangles
{
  The calculation accuracy, the integrated function and the limits are transmitted to the subroutine
}
Function RightRectangle(E: Real; Var Funct; a, b: Real; Var N: Integer): Real;

  Var
    Temp, tempE, h, x: Real;
    i: Integer;
    F: TFunct absolute Funct;

  Begin
    Temp := (b-a)*F(b);
    n := 1;
    Repeat
      Result := 0;
      n := n*2;
      h := (b-a)/n;
      For i := 1 to n do
      Begin
        x := a+i*h;
        Result := Result+h*F(x);
      End;
      tempE := Abs(Temp-Result);
      Temp := Result;
    Until tempE < E
  End;

// The subroutine for calculating the value of the integral by the method of central rectangles
{
  The calculation accuracy, the integrated function and the limits are transmitted to the subroutine
}
Function CentralRectangle(E: Real; Const F; a, b: Real; Var N: Integer): Real;

  Var
    x, Temp, tempE, h: Real;
    i: Integer;

  Begin
    x := (a+b)/2;
    Temp := (b-a)*TFunct(F)(x);
    n := 1;
    Repeat
      Result := 0;
      n := n*2;
      h := (b-a)/n;
      For i := 0 to n-1 do
      Begin
        x := a+h/2+i*h;
        Result := Result+h*TFunct(F)(x);
      End;
      tempE := Abs(Temp-Result);
      Temp := Result
    Until tempE < E
  End;

end.
 