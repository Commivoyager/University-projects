Program Const2;
{
A matrix X of Dimension n*n is given. Get a one-dimensional array Y of dimension n*n by selecting matrix elements along the chain, selecting matrix elements along the chain, starting from the upper left corner, moving along diagonals parallel to the side diagonal of the matrix
}

// Compiler directive, sets the application type as console
{$APPTYPE CONSOLE}

// Connecting the system library
uses
  SysUtils;

// Ñonstant declaration block
Const
  N = 4;
  X: Array[1..N,1..N] of Real = ((1,2,6,7),(3,5,8,13),(4,9,12,14),(10,11,15,16));
{
 N - number of array elements;
 X - the typed array of constants was entered arbitrarily manually. The original two-dimensional array
}

// Declaring a custom array type
Type
  Massiv = array[1..N*N] of real;

// Variable declaration block 
Var
  Y: Massiv;
  iShift, jShift: Byte;
  iDirect, jDirect, Diff: ShortInt;
  Ind, Count, CurrN, i, j: Integer;
{
 Y - the resulting array;
 iShift - variable for moving from one diagonal to another in a row;
 jShift - variable for moving from one diagonal to another by column;
 iDirect - variable for moving along the rows of diagonals of the matrix;
 jDirect - variable for moving through the columns of the diagonals of the matrix;
 Diff - variable for considering the diagonal of the required length;
 Ind - index of the current array element Y;
 Count - counting elements in the diagonal;
 CurrN - length of the current diagonal;
 i - index of the current array element X;
 j - index of the current array element X
}

Begin
  
  // Output of the values of the source array
  For i := 1 to N do
  Begin
    For j := 1 to N do
    Begin
      Write(X[i,j]:6:2);
    End;
    Writeln;
  End;

  // Initialization Block
  CurrN := 2;
  i := 1;
  j := 1;

  // It is equal to 1, since it then changes to 0, and initially the transition to the diagonal in question occurs along the line
  iShift := 1;

  // Is equal to -1, since then it becomes equal to 1, and moving through the rows occurs initially to a larger
  iDirect := -1;

  // Initially we assign the first element of the array Y
  Ind := 1;
  Diff := 1;

  // Finding the first element of the desired array
  Y[Ind] := X[i,j];

  // A loop to find all the remaining elements of the original array
  While CurrN > 0 do
  Begin
    
    // Move to the next element
    Ind := Ind+1;
    
    // The value of this value is the opposite of iShift
    jShift := iShift;
    
    // Each iteration alternates between switching to a new row and a new column to consider the next diagonal
    If iShift = 1 then
      iShift := 0
    Else
      iShift := 1;

    // There is also an alternation of increasing and decreasing numbers of columns and rows when moving diagonally
    jDirect := iDirect;
    iDirect := iDirect*(-1);
    Count := 0;

    // Move to the next diagonal
    j := j+jShift;
    i := i+iShift;

    // A cycle to determine the values of the Y array for a certain diagonal of the original matrix
    While Count < CurrN do
    Begin

      // Determining the value of the current element of the matrix Y
      Y[Ind] := X[i,j];
      Count := Count+1;

      // In case of equality, all elements of the diagonal under consideration will be taken into account
      If Count <> CurrN then
      
      // Transition to the following elements of the diagonal under consideration
      Begin
        j := j+jDirect;
        i := i+iDirect;
        Ind := Ind+1;
      End;
    End;
    
    // Checking whether the diagonal in question is a side one
    If Count = N then
    Begin
      
      // All diagonals parallel to the side, smaller than its length
      Diff := -1;

      // These values must be saved, so they are changed here, since then they will change the value at the beginning of the cycle
      If iShift = 1 then
        iShift := 0
      Else
        iShift := 1;
    End;
    
    // Changing the length of the diagonal in question
    CurrN := CurrN+Diff;
  End;
  
  // Output of the values of the desired array
  For Count := 1 to N*N do
    Write(Y[Count]:6:2);
  Readln
End.
 