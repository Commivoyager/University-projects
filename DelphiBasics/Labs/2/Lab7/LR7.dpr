{Find by numerical methods the values of the following definite integrals with given accuracy Eps1=10-5 and Eps2=10-6 by the method of central and right rectangles}
Program LR7;

// Determining the Console Program Type
{$APPTYPE CONSOLE}

// Ñonnecting a custom module for processing integrals
uses
  uIntegrals in 'uIntegrals.pas';

// Type declaration block
Type
  TFunct = Function(Var x: Real): Real;
  {
    The type of a procedural type parameter for calculating the value of a function at a point
  }

// Variable declaration section
Var
  F1, F2: TFunct;
  N: Integer;
  {
    F1, F2 - The actual parameter is the function of calculating the value of the original function at the point;
    N - the number of segments into which the range of the function is divided during integration
  }

// Ñonstant declaration section
Const
  E1 = 1E-5;
  E2 = 1E-6;
  a1 = 1.2;
  b1 = 3;
  a2 = 0.5;
  b2 = 1.3;
  {
    E1,E2 - calculation accuracy values;
    a1,a2,b1,b2 - integration boundaries
  }

// A subroutine for calculating the value of the first function at a point
{
  As calculations are performed, the value of the argument will be passed to this subroutine, for which it will be necessary to calculate the value of the function
}
Function Funct1(Var x: Real): Real;
  Begin
    Result := Sqrt(2*x*x+0.7)/(1.5+Sqrt(0.8*x+1));
  End;

// A subroutine for calculating the value of the second function at a point
{
  As calculations are performed, the value of the argument will be passed to this subroutine, for which it will be necessary to calculate the value of the function
}
Function Funct2(Var x: Real): Real;
  Begin
    Result := Cos(x*x+0.2)/(1.3+sin(2*x+0.4));
  End;

begin

  // Assigning function addresses to procedural type variables for their transfer to a subroutine
  F1 := Funct1;
  F2 := Funct2;

  // Calculation of integral values by calling the corresponding functions and output of the resulting values
  Writeln('Integral of the function y = Sqrt(2*x*x+0.7)/(1.5+Sqrt(0.8*x+1)');
  Writeln('Lower bound: ', a1:3:1);
  Writeln('Higher bound: ', b1{:3:1});
  Writeln('With accuracy: E = ', E1:7:5,':',RightRectangle(E1,F1,a1,b1,N):8:5);
  Writeln('Number of iterations: ', N);
  Writeln('With accuracy: E = ', E2:8:6,':',RightRectangle(E2,F1,a1,b1,N):9:6);
  Writeln('Number of iterations: ', N);
  Writeln;
  Writeln('Integral of the function y = Cos(x*x+0.2)/(1.3+sin(2*x+0.4))');
  Writeln('Lower bound: ', a2:3:1);
  Writeln('Higher bound: ', b2:3:1);
  Writeln('With accuracy: E = ', E1:7:5,':',CentralRectangle(E1,F2,a2,b2,N):8:5);
  Writeln('Number of iterations: ', N);
  Writeln('With accuracy: E = ', E2:8:6,':',CentralRectangle(E2,F2,a2,b2,N):9:6);
  Writeln('Number of iterations: ', N);
  Readln
end.

