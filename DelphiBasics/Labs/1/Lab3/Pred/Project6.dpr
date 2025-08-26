program Lab3pre6;
{
  Calculate with accuracy E = E-6 the value of the function *f(x,n)* for the
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
  E = 1E-6;
{
 xStart - the initial value of x from the interval;
 xFinish - the final value of x from the interval;
 xStep - the value of the change step x
 E - the value of the counting accuracy
}  

// Variable declaration block 
Var
x, Temp2, TempSum, Sum, PrevSum, Delta: Real;
k, Temp1, Temp3, Counter: Integer;
{
 x - the current value of the variable x;
 Temp1 - the value of the intermediate value of the sum calculation, equal
 to the power -1;
 Temp2 - the value of the intermediate value of the sum calculation, equal
 to the power of the variable x;
 Temp3 - the value of the intermediate value of the sum calculation, equal
 to the denominator of the current term;
 TempSum - the value of the summand for a certain k;
 Sum - the value of the sum for a certain k;
 PrevSum - the value of the sum for the previous to a certain k;
 Delta - the modulus of the difference of the sum values for the allocated k
 and the previous one for it. The value that affects the end of the process
 calculating the amount;
 k - the current value of k;
 Counter - variable for counting the number of iterations.
}  

Begin
  x := xStart;
  Writeln('=================================');
  Writeln('~  x  ~     Sum     ~  Counter  ~');
  Writeln('=================================');

  // The sum calculation cycle for each x to xFinish
  While x <= xFinish do
  Begin
    
    // Initialization Block
    k := 1;
    Temp1 := -1;
    Temp2 := 1/x;
    Temp3 := k;
    PrevSum := 0;
    
    // Assigning Delta a value greater than E to enter the loop
    Delta := E+1;
    
    // Initialization of the iteration count variable
    Counter := 0;
    
    // Entering the sum calculation cycle for a certain x
    While Delta >= E do
    Begin
      
      // Calculation of intermediate values of the summand
      Temp1 := Temp1*(-1);
      Temp2 := Temp2*x*x;
      Temp3 := Temp3*(k+1);
      
      // Calculation of the summand value for a certain k
      TempSum := Temp1*Temp2/Temp3;
      
      // The value of the sum for a certain k
      Sum := PrevSum+TempSum;
      Counter := Counter+1;
      
      // Determination of the value of the quantity affecting
      // at the end of the calculation of the amount
      Delta := Abs(Sum-PrevSum);
      
      // Preparation block
      k := k+1;
      PrevSum := Sum;
    End;
    
    // Output of x and the desired values
    Write('~ ', x:3:1, ' ~  ');
    Write(Sum:7:7, '  ~     ');
    Writeln(Counter, '     ~');
    Writeln('=================================');

    // Increasing the value of x by the amount of the step
    x := x+xStep
  End;
  Readln
end.                       
