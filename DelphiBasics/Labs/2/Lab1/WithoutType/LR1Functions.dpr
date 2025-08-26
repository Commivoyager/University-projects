Program LR1interim;    
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
  Sign: ShortInt;
{
  Sign - variable for determining the sign in matrix sum expressions
}

// Subprogram for calculating the multiplication of given marices
{
  Matrices M1 and M2  are given and they are joint. The subrogram calculates multiplication of them and returns new calculated matrix in specified array
}
Function MatrMultipl(Const M1, M2; Const Size: Byte): Matr;

// Determining the type for matrixes
Type
  Matr = array[1..3, 1..3] of Integer;

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
        Result[i,j] := Result[i,j] + Matr(M1)[i,k]*Matr(M2)[k,j];
    End;
End;

// Subprogram for calculating the sum or difference of given matrices
{
  Matrices M1 and M2 are given and  have the same size. The subprogram calculates sum or subtraction (it depends on Sign parameter) of this matrices and returns it in specified array
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

  // Calculating the value of the original expression
  Sign := -1;

  // Functions for calculating matrix expressions are introduced as parameters of the inference procedure
  Outp(MatrSumSub(NumMultipl(Size, Size, MatrSumSub(MatrMultipl(A, A, Size), MatrMultipl(B, B, Size), Size, Sign)), NumMultipl(Factor, Size, MatrMultipl(A, B, Size)), Size, Sign), 'original expression', Size);
  Readln
End.
