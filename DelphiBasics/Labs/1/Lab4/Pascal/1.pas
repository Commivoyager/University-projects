Program Project2;
{
 f
}

// Compiler directive, sets the application type as console
{$APPTYPE CONSOLE}

// Connecting the system library 
Uses
  SysUtils;

// Сonstant declaration block
Const
  N = 10;
{
 N - number of array elements
}

// Declaring a custom array type
Type
  TArray = Array[1..N] of Real;

// Variable declaration block 
Var
  Massiv: TArray;
  i, r, rTemp, Counter, rExit: Integer;
{
 Massive - full variable array;
 i - index of the current array element;
 r - the length of the longest desired sequence;
 rTemp - an intermediate value of the length of the sequence under consideration;
 Counter - counter of the longest sequences;
 rExit - a variable for outputting the maximum length of a sequence if it ends on the last element of the array 
}

Begin
  
  // User input of array elements
  For i := 1 to N do
  Begin
    Writeln('Enter the element Massiv[i] = ');
    Readln(Massiv[i]);
  End;
  
  // Initialization Block 
  rTemp := 1;
  r := rTemp+1;
  Counter := 1;
  i := 2;
  
  // The cycle of searching for the longest sequence or their number
  While i <= N-1 do
  Begin
    
    // Checking whether an element with index i will be smaller than its neighbors
    If (Massiv[i] < Massiv[i-1]) and (Massiv[i] < Massiv[i+1]) then
    
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
      
      // Counting the number of longest sequences
      If rTemp = r then
        Counter := Counter+1;
      
      // Change of the calculated length in case of finding a larger
      If rTemp > r then
      Begin
        r := rTemp;
        Counter := 1;
      End;
      
      // The necessary change of the loop parameter and the storage variable of the calculated length
      i := i+1;
      rTemp := 1;
    End;
  End;
  
  // Counting the number of longest sequences 
  If rExit = r then
    Counter := Counter+1;
  
  // Change of the calculated length in case of finding a larger
  If rExit > r then
    r := rExit;
  
  // Zeroing of variables of maximum length and their number in the absence of the desired sequences
  If r < 3 then
  Begin
    Counter := 0;
    r := 0;
  End;
  
  // Output of the entered array and the resulting length of the desired sequence 
  Write('Source array: ');
  For i := 1 to N do
    Write(Massiv[i]:6:2, ' ');
  Writeln;
  Writeln('The length of the longest <sawtooth> (teeth down) of sequence r = ', r);
  Writeln('Their number: ', Counter);
  Readln
End.