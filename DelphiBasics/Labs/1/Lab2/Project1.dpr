Program Project1;
{
 Let there be some natural number M. Find the sum of the squares
 of the digits of this number by getting a new number, with this new number
 do the same procedure. After a finite number of repetitions
 this procedure yields either the number 1 or the number 4. Develop
 an algorithm and a program for finding numbers and their numbers on the
 interval [1..N], which, upon completion of the above procedure, give
 result 1 or 4, the value of which is determined by the user,
 reason N <= 30000
}

// Compiler directive, sets the application type as console
{$APPTYPE CONSOLE}

// Connecting the system library
Uses
  SysUtils;

// Variable declaration block
Var
N, NumberValue, Counter, Holder, SumSqr, TempNumber, Cutted: Integer;
Result, Another,  Digit: Byte;
Indicator, Flag: Boolean;
{
 N - the finite number of the interval [1..N];
 Number Value - the current value of the number of the interval with
 which the procedure is performed;
 Counter - counter of the number of numbers that are completed
 the procedures give the result;
 Holder, TempNumber - variables containing the current value
 the number that will have the sum of the squares of its digits;
 SumSqr - sum of squares of digits of the current number;
 Cutted - variable used to find the value
 the last digit of the current value of the number;
 Result - the result of the procedure entered by the user;
 Another - the second possible value of the result of the procedure,
 different from the one entered by the user;
 Digit - the digit of the current number from the category of units
 used to find the sum of squares;
 Indicator - a logical variable for skipping numbers, the result
 of the procedure of which is equal to the second possible the value
 of the procedure result other than the one entered by the user
 Flag - a logical variable for determining the correctness of
 the entered data;
}

Begin

  // Assigning a false value to a Boolean variable to enter
  // a loop and enter data
  Flag := False;

  // Entering the cycle to check the correctness of the entered
  // values of the N and Result
  While Flag = False do
  Begin

    // Identification of exceptional input situations
    Try

      // user input of source data: N, Result
      Writeln(' Enter the value of N to which the search will be performed');
      Writeln(' The number N is natural, no more than 30000');
      Write(' ');
      Readln(N);
      Writeln(' Enter 1 or 4 - what should be obtained at the end of the procedure');
      Write(' ');
      Readln(Result);

      // Assigning a true value to a boolean variable
      // so as not to enter the loop in case of correct data entry
      Flag := True;

    // Exceptional situation block
    Except

      // Output of a message about the incorrectness of the entered
      // value of N or Result
      Writeln(' Incorrect input!');
      Writeln(' The value of the N or Result must be an integer');

      // Assigning a false value to a Boolean variable to re-enter
      // the loop and enter data
      Flag := False;
    End;
    If Flag = True then

    // Checking the entered value of N for correctness
    If (N <= 0) or (N > 30000) then
    Begin

      // Output of a message about the incorrectness of the entered N value
      Writeln(' Incorrect input!');
      Writeln(' The value of the N must be in the range [1,30000]');

      // Assigning a false value to a Boolean variable to re-enter
      // the loop and enter data
      Flag := False;
    End;
    If Flag = True then

      // Checking the entered value of Result for correctness
      If (Result <> 1) and (Result <> 4) then
      Begin

        // Output of a message about the incorrectness of the entered
        // Result value
        Writeln(' Incorrect input!');
        Writeln(' The value of the Result must be 1 or 4');

        // Assigning a false value to a Boolean variable to re-enter
        // the loop and enter data
        Flag := False;
      End;
  End;
  
  // Defining the value of a variable Another
  If Result = 4 then
    Another := 1
  Else
    Another := 4;

  // Assignment to variables that determine the current value of
  // the number with which the procedure is performed, and to the
  // counter of initial values
  NumberValue := 1;
  Counter := 0;
  Writeln(' Numbers that, upon completion, give the result: ', Result);

  // A cycle for finding numbers satisfying the condition
  For NumberValue := NumberValue to N do
  Begin

    // Assigning a true value to a boolean variable for subsequent
    // output of the value of the initial number of the interval
    Indicator := True;
    Holder := NumberValue;
    SumSqr := 0;

    // The cycle of finding the sum of the squares of the digits
    // of the current number
    While SumSqr <> Result do
    Begin

      // Exclusion of numbers whose sum of squares of digits
      // results in a value other than the value entered by the user
      If SumSqr <> Another then
      Begin
        TempNumber := Holder;
        SumSqr := 0;

        // Finding the sum of the squares of the digits of the current
        // value of the number
        While TempNumber >= 1 do
        Begin

          // Finding the lowest digit of a number
          Cutted := Trunc(TempNumber/10);
          Digit := TempNumber-Cutted*10;
          SumSqr := SumSqr+Digit*Digit;
          TempNumber := Cutted;
          Holder := SumSqr;
        End;
      End
      Else
      Begin
        SumSqr := Result;
        // Assigning a false value to a Boolean variable to move to
        // another number of the interval
        Indicator := False;
      End;
    End;

    // The output of the values of numbers that, at the end
    // of the procedure, give the result entered by the user
    If Indicator = True then
    Begin
      Writeln(' M = ', NumberValue);
      Counter := Counter+1;
    End;
  End;

  // Output of the number of required numbers
  Writeln(' The number of required numbers Counter = ', Counter);
  readln
End.
