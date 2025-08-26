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
  Ar:array[1..N] of Real = (4.9, 3.1, 5.1, 5.1, 2.7, 6.0, 5.99, 7.2, 8.9, 100.22);
{
 N - number of array elements;
 Ar - typed constant array was entered arbitrarily manually, it will search for the desired sequence
}

// Variable declaration block 
Var
  i, r, rTemp, Counter, rExit: Integer;
{
 i - index of the current array element;
 r - the length of the longest desired sequence;
 rTemp - an intermediate value of the length of the sequence under consideration;
 Counter - counter of the longest sequences;
 rExit - a variable for outputting the maximum length of a sequence if it ends on the last element of the array 
}

Begin

  
  // Initialization Block 
  rTemp := 1;
  r := rTemp+1;
  i := 2;
  
  // The cycle of searching for the longest sequence
  While i <= N-1 do
  Begin
    
    // Checking whether an element with index i will be smaller than its neighbors
    If (Ar[i] < Ar[i-1]) and (Ar[i] < Ar[i+1]) then
    
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
    Write(Ar[i]:6:2, ' ');
  Writeln;
  Writeln('The length of the longest <sawtooth> (teeth down) of sequence r = ', r);
  Readln
End.
  
  // Zeroing of variables of maximum length and their number in the absence of the desired sequences
  If r < 3 then
  Begin
    Counter := 0;
    r := 0;
  End;
  
  // Output of the entered array and the resulting length of the desired sequence 
  Write('Source array: ');
  For i := 1 to N do
    Write(Ar[i]:6:2, ' ');
  Writeln;
  Writeln('The length of the longest <sawtooth> (teeth down) of sequence r = ', r);
  Writeln('Their number: ', Counter);
  Readln
End.
