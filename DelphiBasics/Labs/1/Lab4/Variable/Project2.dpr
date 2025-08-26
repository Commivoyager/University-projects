Program Project2;
{
 f
}

// Compiler directive, sets the application type as console
{$APPTYPE CONSOLE}

// Connecting the system library
uses
  SysUtils;

// Ñonstant declaration block
Const
  N = 10;
{
 N - number of array elements
}

// Variable declaration block
Var
  Y: array[1..N] of Real;
  i, r, rTemp, rExit: Integer;
  Flag: Boolean;
{
 Y - full typed variable array;
 i - index of the current array element;
 r - the length of the longest desired sequence;
 rTemp - an intermediate value of the length of the sequence under consideration;
 rExit - a variable for outputting the maximum length of a sequence if it ends on the last element of the array;
 Flag - a logical variable for determining the correctness of the entered data
}

Begin
  
  // Assigning a false value to a Boolean variable to enter a loop and enter data
  Flag := False;

  // Entering the cycle to check the correctness of the entered values of the arrays elements
  While Flag = False do
  Begin

    // Identification of exceptional input situations
    Try

    // User input of array elements
    For i := 1 to N do
    Begin
      Write('Enter the element Y[i] = ');
      Readln(Y[i]);
    End;

    // Assigning a true value to a boolean variable so as not to enter the loop in case of correct data entry
    Flag := True;

    // Exceptional situation block
    Except

      // Output of a message about the incorrectness of the entered values of the arrays elements
      Writeln('Incorrect input!');
      Writeln('Arrays elements must be of Real type');
      Writeln('Please, restart arrays elements input');

      // Assigning a false value to a Boolean variable to re-enter the loop and enter data
      Flag := False;
    End;
  End;
  
  // Initialization Block 
  rTemp := 1;
  r := rTemp+1;
  i := 2;

  // The cycle of searching for the longest sequence
  While i <= N-1 do
  Begin

    // Checking whether an element with index i will be smaller than its neighbors
    If (Y[i] < Y[i-1]) and (Y[i] < Y[i+1]) then

    // Changing the calculated length and switching to other elements
    Begin
      rTemp := rTemp+2;
      i := i+2;

      // Assigning the calculated length to a variable for further output
      rExit := rTemp;
    End
    Else

    // Comparing the resulting length with the previous one and moving to the next element of the array
    Begin

      // Change of the calculated length in case of finding a larger
      If rTemp > r then
        r := rTemp;

      // The necessary change of the loop parameter and the storage variable of the calculated length
      i := i+1;
      rTemp := 1;
    End;
  End;

  // Change of the calculated length in case of finding a larger
  If rExit > r then
    r := rExit;

  // Zeroing of variables of maximum length in the absence of the desired sequences
  If r < 3 then
  Begin
    r := 0;
  End;
  
  // Output of the entered array and the resulting length of the desired sequence 
  Write('Source array: ');
  For i := 1 to N do
    Write(Y[i]:7:2, ' ');
  Writeln;
  Writeln('The length of the longest <sawtooth> (teeth down) of sequence r = ', r);
  Readln
End.

