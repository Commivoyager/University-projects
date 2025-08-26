Program LR1FunctionsInterim;
{
  Develop a program for calculating matrix expressions. The program must have functions without using global parameters
}

// Determining the Console Program Type
{$APPTYPE CONSOLE}

// Determining the type for matrixes
Type
  Matr = array[1..3, 1..3] of Integer;

// Declaring the constants
Const
  A: Matr = ((4,2,1),(3,-2,0),(0,-1,2));
  B: Matr = ((2,0,2),(5,-7,-2),(1,0,-1));
  Factor = 2;
  Size = 3;
{
  A, B - arrays that keep values of initial matrix;
  Factor - constant storing the value of the multiplier in the original expression;
  Size - constant storing the value of the size of given square matrices
}

// Variable declaration section
Var
  Temp1, Temp2, Temp3: Matr;
  Sign: ShortInt;
{
  Temp1, Temp2, Temp3 - variables storing intermediate values of matrixes;
  Sign - variable for determining the sign in matrix sum expressions
}

// Subprogram for calculating the multiplication of given marices
{
  Matrices M1 and M2  are given and they are joint. The subrogram calculates multiplication of them and returns new calculated matrix in specified array
}
Function MatrMultipl(Const M1, M2: Matr; Const Size: Byte): Matr;

// Variable declaration section
Var
  i, j, k: Integer;
{
  i, j, k - counter variables
}

Begin

  // A loop for iterating matrix values by rows
  For i := 1 to Size do

    // Loop for iterating matrix values by columns
    For j := 1 to Size do
    Begin

      // Zeroing array elements to avoid having other values in them
      Result[i,j] := 0;

      // The cycle of searching for elements of the product of matrices
      For k := 1 to Size do
        Result[i,j] := Result[i,j] + M1[i,k]*M2[k,j];
    End;
End;

// Subprogram for calculating the sum or difference of given matrices
{
  Matrices M1 and M2 are given and have the same size. The subprogram calculates sum or subtraction (it depends on Sign parameter) of this matrices and returns it in specified array
}
Function MatrSumSub(Const M1, M2: Matr; Const Size: Byte; Const S: ShortInt): Matr;

// Variable declaration section
Var
  i, j: Integer;

Begin
  For i := 1 to Size do
    For j := 1 to Size do
      Result[i,j] := M1[i,j]+S*M2[i,j];
End;

// Subprogram for calculating the multiplying of a matrix by a number
{
  Matrices M1 is given. The subrogram calculates multiplication of it by a number and returns new calculated matrix in specified array
}
Function NumMultipl(Const Num, Size: Byte; Const M1: Matr): Matr;

// Variable declaration section
Var
  i, j: Integer;

Begin
  For i := 1 to Size do
    For j := 1 to Size do
      Result[i,j] := Num*M1[i,j];
End;

// Subprogram for outputting calculated value of search matrix
{
  The values of matrix that is need to output are given, subprogram returnes them
}
Procedure Outp(Const Res: Matr; Const Data: String; Const Size: Byte);

// Variable declaration section
Var
  i,j: Integer;

Begin

  // Information about the output data
  Writeln('The value of the ');
  Writeln(Data, ' is:');
  For i := 1 to Size do
  Begin
    For j := 1 to Size do
      Write(Res[i,j]:4);
    Writeln
  End;
  Writeln;
End;



Begin

  // Outputting of the values of the original matrices
  Outp(A, 'A', Size);
  Outp(B, 'B', Size);

  // Ñalculating the squares of the matrix A and B
  Temp1 := MatrMultipl(A, A, Size);
  Outp(Temp1, 'A*A', Size);

  Temp2 := MatrMultipl(B, B, Size);
  Outp(Temp2, 'B*B', Size);

  // Ñalculating the difference of squares of the matrix A and B
  Sign := -1;
  Temp3 := MatrSumSub(Temp1, Temp2, Size, Sign);
  Outp(Temp3, 'A*A-B*B', Size);

  // Multiplying the difference of squares of matrices by 3
  Temp1 := NumMultipl(Size, Size, Temp3);
  Outp(Temp1, '3*(A*A-B*B)', Size);

  // Multiplication of matrix A by matrix B
  Temp2 := MatrMultipl(A, B, Size);
  Outp(Temp2, 'A*B', Size);

  // Multiplying the product of matrices A and B by 2
  Temp3 := NumMultipl(Factor, Size, Temp2);
  Outp(Temp3, '2*A*B', Size);

  // Calculating the value of the original expression
  Temp2 := MatrSumSub(Temp1, Temp3, Size, Sign);
  Outp(Temp2, 'original expression', Size);
  Readln
End.
