program Lab3Post;
{
 Calculate with accuracy E = E-5 the value of the function *f(x,n)* for the
 value of x, varying from xStart = 0.1 to xFinish = 0.9 with xStep = 0.1
}

// Compiler directive, sets the application type as console
{$APPTYPE CONSOLE}

// Connecting the system library
uses
  SysUtils;

// Ñonstant declaration block
Const
  xStart = 0.1;
  xFinish = 0.9;
  xStep = 0.1;
  E5 = 1E-5;
  E6 = 1E-6;
{
 xStart - the initial value of x from the interval;
 xFinish - the final value of x from the interval;
 xStep - the value of the change step x
 E - the value of the counting accuracy
}

// Variable declaration block
Var
x, Temp2, Sum, El, Delta: Real;
k, Temp1, Temp3, Counter: Integer;
Check: Boolean;
{
 x - the current value of the variable x;
 Temp1 - the value of the intermediate value of the sum calculation, equal
 to the power -1;
 Temp2 - the value of the intermediate value of the sum calculation, equal
 to the power of the variable x;
 Temp3 - the value of the intermediate value of the sum calculation, equal
 to the denominator of the current term;
 Sum - the value of the sum for a certain k;
 El - the current term;
 Delta - the module of the current term. The value that affects the end of
 the process calculating the amount;
 k - the current value of k;
 Counter - variable for counting the number of iterations
}

begin
  x := xStart;

  //
  Check := True;
  Writeln('|===========================================================|');
  Writeln('|  E  |          1E-5            |          1E-6            |');
  Writeln('|===========================================================|');
  Writeln('|  x  |     Sum     |  Counter   |     Sum     |  Counter   |');
  Writeln('|===========================================================|');

  // The sum calculation cycle for each x to xFinish
  While x <= xFinish do
  Begin

    // Initialization Block
    k := 1;
    Temp1 := -1;
    Temp2 := 1/x;
    Temp3 := k;
    Sum := 0;

    // Initialization of the iteration count variable
    Counter := 0;

    // Entering the sum calculation cycle for a certain x
    Repeat

      // Calculation of intermediate values of the summand
      Temp1 := Temp1*(-1);
      Temp2 := Temp2*x*x;
      Temp3 := Temp3*(k+1);

      // Calculation of the summand value for a certain k
      El := Temp1*Temp2/Temp3;

      // The value of the sum for a certain k
      Sum := Sum+El;
      Counter := Counter+1;

      // Determination of the value of the quantity affecting
      // at the end of the calculation of the amount
      Delta := Abs(El);

      // Preparation block
      k := k+1;

      //
      If (Delta < E5) and (Check = True) then
      Begin
        Write('| ', x:3:1, ' |  ');
        Write(Sum:7:7, '  |     ');
        Write(Counter, '      | ');
        Check := False;
      End;
    Until Delta < E6;

    // Output of x and the desired values
    Write(Sum:7:7, '   |     ');
    Writeln(Counter, '      |');
    Writeln('|===========================================================|');
    
    //
    Check := True;

    // Increasing the value of x by the amount of the step
    x := x+xStep
  End;
  Readln
end.
