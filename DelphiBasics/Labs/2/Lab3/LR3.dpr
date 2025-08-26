{To conduct a comparative analysis of the methods of sorting HeapSort arrays and sorting by choice. Dimensions of arrays , respectively: 100, 250, 500, 1000, 2000, 3000. Array types: random, sorted, inverted. Develop a data structure for storing calculation results. According to the obtained calculation results, draw the appropriate conclusions}
Program LR3;

// Determining the Console Program Type
{$APPTYPE CONSOLE}

// Ñonnecting a standard module for processing input data
uses
  SysUtils;

// Type declaration block
Type
  AnswrStr = String[3];
  TInpStr = String[50];
  TElArray = array[1..3000] of Integer;
  TSizez = array[1..6] of Integer;

  TRes = Record
    TheorRes: array[1..6] of Real;
    ExperRes: array[1..6] of Integer;
    ArrSorted: array[1..6] of AnswrStr;
  End;

  TArrType = Record
    Sort,Reverse,Random: TRes;
  End;
{
  AnswrStr - the type of à string containing information about whether the array is sorted;
  TInpStr - the type of string passed to the input procedure to output information to the user;
  TElArray - the type of sorted array;
  TSizez - the type of array that stores the dimensions of the sorted arrays;
  TRes - the type of record whose fields are arrays storing sorting results: number of comparisons;
  TArrType - the type of record whose fields are records storing sorting results
}

// Variable declaration section
Var
  RandArr, SortArr, ReversArr: TElArray;
  Heap, Select: TArrType;
  ExprComprs, i: Integer;
  IsSrtd: AnswrStr;
{
  RandArr, SortArr, ReversArr - variables storing sortable arrays;
  Heap, Select - records whose fields are records storing sorting results for each array type;
  ExprComprs - variable for counting comparisons;
  i - variable-cycle counter;
  IsSrtd - variable for transmitting a response about whether the array is sorted
}

// Ñonstant declaration section
Const
  N = 6;
  Sizes: TSizez = (100,250,500,1000,2000,3000);
{
  N - number of dimensions of arrays;
  Sizes - array with array dimensions
}

// A subroutine for entering the boundaries of a segment on which arbitrary numbers will be calculated to fill an arbitrary array to be sorted
{
  The user enters the boundaries, the entered data is processed as a string TInpStr. In case of incorrect input, the subroutine will display a message about the need to repeat, otherwise this value will be assigned to the Input variable
}
Procedure InputCheck(Var Str; Var Input: Integer);

  // Type declaration block
  Type
    TInpStr = String[50];
  {
  TInpStr - the type of string passed to the input procedure to output information to the user;
  }

  // Ñonstant declaration section
  Const
    IntPart = MaxInt mod 2000000000;
  {
    IntPart - a value to check whether a number is of type integer
  }

  // Variable declaration section
  Var
    i, Shift: Integer;
    InpStr: String[12];
    IntCheck: String[9];
    CorrectInp: Boolean;
  {
    i - position in the string of the character in question;
    Shift - shift by character indexes when checking whether the entered number corresponds to the Integer type;
    InpStr - a string entered by the user;
    IntCheck - a string whose value is converted to an integer and compared with IntPart to determine whether the number entered by the user does not exceed the limits of the Integer type;
    CorrectInp - a boolean variable that determines whether the input is correct
  }

  Begin

    // The string is reset to zero so that values can be added to it in the future, the boolean value is set to False to enter the verification cycle
    IntCheck := '000000000';
    CorrectInp := False;

    // A loop for checking the input for correctness
    While not CorrectInp do
    Begin

      // If the input is incorrect, the value will be reassigned to False in order to enter the input loop again
      CorrectInp := True;
      Write(TInpStr(Str));
      Readln(InpStr);
      i := 1;

      // If a number takes more than 11 characters, then it is definitely not in the range of Integer values
      If Length(InpStr) > 11 then
        CorrectInp := False;

      // Character-by-character check whether they are digits
      While (i <= Length(InpStr)) and CorrectInp do
      Begin
        If (Ord(InpStr[i]) < 48) or (Ord(InpStr[i]) > 57) then
        Begin
          CorrectInp := False;

          // The first element can be a minus sign
          If (i = 1) and (Length(InpStr) > 1) then
            If (Ord(InpStr[i]) = 45) then
              CorrectInp := True
        End
        Else

          // The entered number can be 11 characters long only if the first character is a minus sign
          If (i = 1) and (Length(InpStr) = 11) then
            CorrectInp := False;
        Inc(i)
      End;

      // If the entered number is 10 or 11 characters long, then it must be modulo less than the maximum number from the range of Integer values
      If CorrectInp and (Length(InpStr) >= 10) then
      Begin
         If Length(InpStr) = 11 then
           Shift := 2
         Else
           Shift := 1;

         // The first character of a number of this length should not be greater than 2
         If Ord(InpStr[Shift]) <> 45 then
         Begin
           If Ord(InpStr[Shift]) > 50 then
             CorrectInp := False
           Else
           Begin

             // Checking whether the entered number is in the range of Integer values
             For i := 1 to 9 do
               IntCheck[i] := InpStr[i+Shift];
             If StrToInt(IntCheck) > IntPart then
               CorrectInp := False;
           End;
         End;
      End;
      If CorrectInp then
        Input := StrToInt(InpStr)
      Else
        Writeln('Invalid input: it must be an integer type number. Repeat');
    End;
  End;

// Subroutine for filling arrays
{
  RndArr - random array is filled with numbers in the range that the user entered , SArr - sorted array, RvArr - reverse array
}
Procedure ArrFill(Var RndArr, SArr, RvArr);

  // Variable declaration section
  Var
    i, RndFrom, RndTo: Integer;
    Str1, Str2: TInpStr;
    Flag: Boolean;
    Randm: TElArray absolute RndArr;
    Sorted: TElArray absolute SArr;
    Reverse: TElArray absolute RvArr;
  {
    i - variable-cycle counter;
    RndFrom, RndTo - variables storing values left and right boundaries of the random number range;
    Str1, Str2 - lines for displaying messages to the user;
    Flag - boolean variable for input validation
  }

  // Constant declaration section
  Const
    Size = Length(Randm);
  {
    Size - sizes of arrays to be filled in
  }

  Begin
    Str1 := 'Enter min number for random filling of array: ';
    Str2 := 'Enter max number for random filling of array: ';
    Flag := False;

    // A loop for entering the values of the units with a check that the left border of the range is smaller than the right one
    While not Flag do
    Begin

      // Entering boundary values
      InputCheck(Str1,RndFrom);
      InputCheck(Str2,RndTo);
      If RndFrom >= RndTo then
        Writeln('The left border of the random range should be smaller than the right one. Repeat input')
      Else
        Flag := True;
    End;
    Randomize;
    For i := 1 to Size do
    Begin

      // Filling an array with arbitrary values from the selected range
      Randm[i] := Random(RndTo-RndFrom)+1+RndFrom;

      // Filling an array with sorted values
      Sorted[i] := i;

      // Filling an inverted array
      Reverse[i] := Size+1-i;
    End;
    Writeln
  End;

// Routine for checking whether the array is sorted
{
  In the Arr array of Size, neighboring elements are compared alternately, and if the condition is not met that the left element is smaller than the right, then No will be written to the Soted string, otherwise Yes
}
Procedure IsSorted(Var Arr: TElArray; Const Size: Integer; Var Sorted);

  // Type declaration block
  Type
    AnswrStr = String[3];
  {
   AnswrStr - the type of à string containing information about whether the array is sorted;
  }

  // Variable declaration section
  Var
    i: Integer;
  {
    i - number of the array element to be checked
  }

  Begin
    i := 1;

    // The left element of the array must be smaller than the right one
    While (i < Size) and (Arr[i] <= Arr[i+1])  do
    Begin
      inc(i);
    End;
    If i <> Size then
      AnswrStr(Sorted) := 'No '
    Else
      AnswrStr(Sorted) := 'Yes';
  End;

// Subroutine for exchanging elements
{
  Elements El1 and El2 are swapped
}
Procedure Swap(Var El1, El2);

  // Variable declaration section
  Var
    Temp: Integer;
    E1: Integer absolute El1;
    E2: Integer absolute El2;
  {
    Temp - variable to re-assign
  }

  Begin
    Temp := E1;
    E1 := E2;
    E2:= Temp;
  End;

// A subroutine for sifting elements in a tree
{
  In the ArrSift array, elements are sifted starting with an element with the CNode index, ending with an element with the LstNode index, while comparisons are counted, entered into the NExper variable
}
Procedure Sifting(Var ArrSift: TElArray; CNode: Integer; Var LstNode, NExper);

  // Variable declaration section
  Var
    Child: Integer;
    Sifted: Boolean;
  {
    Child - a variable that stores the index of the descendant of the sifted element;
    Sifted - a boolean variable that determines whether the array is sorted
  }

  Begin

    // The array starts with the first element, so the left child will be defined like this
    Child := CNode*2;

    // Assigning a false value to enter the loop
    Sifted := False;
    While (Sifted = False) and (Child <= Integer(LstNode)) do
    Begin

      // Choosing a descendant to compare with -  it should be the largest
      If (Child+1 <= Integer(LstNode)) and (ArrSift[Child] < ArrSift[Child+1]) then
        Child := Child+1;

      // Sifting occurs only when the descendant is larger
      If ArrSift[Child] > ArrSift[CNode] then
      Begin
        Swap(ArrSift[Child],ArrSift[CNode]);

        // The next sieved element becomes a descendant
        CNode := Child;
        Child := CNode *2
      End
      Else
        Sifted := True;
      Inc(Integer(NExper))
    End;
  End;

// Subroutine for sorting an array using the HeapSort method
{
  An Arr array of Size is sorted. At the same time, comparisons are counted in the NExper variable. At the end of sorting, it checks whether the array is sorted and the result is entered in Sorted
}
Procedure HeapSort(Arr: TElArray; Const Size: Integer; Var NExper: Integer; Var Sorted);

  // Variable declaration section
  Var
    CurrNode, LastNode: Integer;
    SrtdStr: AnswrStr absolute Sorted;
  {
    CurrNode - a variable that stores the value of the sifted index;
    LastNode - a variable that stores the value of the last index in the sortable tree
  }

  Begin
    NExper := 0;

    // Since the array starts with the first element, the index of its last element will be equal to its length
    LastNode := Size;

    // Sifting starts from the last element that has a descendant
    CurrNode := LastNode div 2;

    // Creating MaxHeap, when all elements are sifted through to the first
    While CurrNode >= 1 do
    Begin
      Sifting(Arr, CurrNode, LastNode, NExper);

      // The next sifted element after the one under consideration will be the previous one
      Dec(CurrNode)
    End;

    // The last stage of sorting is the creation of a sorted subarray by exchanging the first and last elements and sifting the first
    CurrNode := 1;
    While LastNode > 1 do
    Begin
      Swap(Arr[CurrNode],Arr[LastNode]);
      Dec(LastNode);
      Sifting(Arr, CurrNode, LastNode, NExper);
    End;

    // Checking whether the array is sorted after sorting HeapSort
    IsSorted(Arr,Size,SrtdStr);
  End;

// Array sorting routine by the Selection sort method
{
  The Arr array of Size is sorted by the Selection sort method. At the same time, the number of comparisons in the NExper variable is calculated and at the end of sorting, the array is checked whether it is sorted
}
Procedure SelectSort(Arr: TElArray; Const Size; Var NExper: Integer; Var Sorted: AnswrStr);

  // Variable declaration section
  Var
    i, j, Min: Integer;
  {
    i, j - variables for organizing a loop to search for the minimum element in the array;
    Min - a variable that stores the index of the minimum element in the sorted subarray
  }

  Begin
    NExper := 0;
    For i := 1 to Integer(Size)-1 do
    Begin
      Min := i;
      For j := i+1 to Integer(Size) do
      Begin
        If Arr[j] < Arr[Min] then
          Min := j;
        Inc(NExper);
      End;
      If i <> Min then
        Swap(Arr[i],Arr[Min]);
    End;

    // Checking whether the array is sorted after sorting Selection sort
    IsSorted(Arr,Integer(Size),Sorted);
  End;

// A subroutine for displaying the resulting results in a table
Procedure TableOutp(Var HeapInfo, SelectInfo; Const Sizes: TSizez; Const N: Integer);

  // Variable declaration section
  Var
    i: Integer;
    HInf: TArrType absolute HeapInfo;
    SInf: TArrType absolute SelectInfo;
  {
    i - variable for the organization of the cycle
  }

  Begin
    Writeln('-------------------------------------------------------------------------------------');
    Writeln('| Dimension of |  array   |          HeapSort          |       Selection Sort       |');
    Writeln('| the array    |  type    |---------------------------------------------------------|');
    Writeln('|              |          | Experimental | Theoretical | Experimental | Theoretical |');
    Writeln('|===================================================================================|');
    For i := 1 to N do
    Begin
      Write('| N = ', Sizes[i]:4, '     |  Sorted  | ', HInf.Sort.ExperRes[i]:6, '       | ', HInf.Sort.TheorRes[i]:6:0, '      | ');
      Writeln(SInf.Sort.ExperRes[i]:10, '  | ', SInf.Sort.TheorRes[i]:10:0, '   |');
      Writeln('|-------------------------|----------------------------|----------------------------|');
      Write('|      Is it sorted?      |             ', HInf.Sort.ArrSorted[i], '            |             ');
      Writeln(SInf.Sort.ArrSorted[i], '            |');
      Writeln('|-----------------------------------------------------------------------------------|');
      Write('| N = ', Sizes[i]:4, '     |  Random  | ', HInf.Random.ExperRes[i]:6, '       | ', HInf.Random.TheorRes[i]:6:0, '      | ');
      Writeln(SInf.Random.ExperRes[i]:10, '  | ', SInf.Random.TheorRes[i]:10:0, '   |');
      Writeln('|-------------------------|----------------------------|----------------------------|');
      Write('|      Is it sorted?      |             ', HInf.Random.ArrSorted[i], '            |             ');
      Writeln(SInf.Random.ArrSorted[i], '            |');
      Writeln('|-----------------------------------------------------------------------------------|');
      Write('| N = ', Sizes[i]:4, '     |  Reverse | ', HInf.Reverse.ExperRes[i]:6, '       | ', HInf.Reverse.TheorRes[i]:6:0, '      | ');
      Writeln(SInf.Reverse.ExperRes[i]:10, '  | ', SInf.Reverse.TheorRes[i]:10:0, '   |');
      Writeln('|-------------------------|----------------------------|----------------------------|');
      Write('|      Is it sorted?      |             ', HInf.Reverse.ArrSorted[i], '            |             ');
      Writeln(SInf.Reverse.ArrSorted[i], '            |');
      Writeln('|===================================================================================|');
      Writeln('|===================================================================================|');
    End;
  End;



Begin

  // Filling in arrays
  ArrFill(RandArr, SortArr, ReversArr);

  // A cycle for sorting and recording results for arrays of each of the required dimensions
  For i := 1 to N do
  Begin

    // Sorting by the HeapSort method of a sorted array
    HeapSort(SortArr, Sizes[i], ExprComprs, IsSrtd);

    // Recording of the experimentally obtained number of comparisons
    Heap.Sort.ExperRes[i] := ExprComprs;

    // Calculation and recording of the theoretically obtained number of comparisons
    Heap.Sort.TheorRes[i] := Sizes[i]*(Ln(Sizes[i])/Ln(2));   //2n log (n + 1) + 3n.

    // Recording information about whether the array is sorted
    Heap.Sort.ArrSorted[i] := IsSrtd;

    // Sorting by the HeapSort method of a random array
    HeapSort(RandArr, Sizes[i], ExprComprs, IsSrtd);
    Heap.Random.ExperRes[i] := ExprComprs;
    Heap.Random.TheorRes[i] := Sizes[i]*(Ln(Sizes[i])/Ln(2));
    Heap.Random.ArrSorted[i] := IsSrtd;

    // Sorting by the HeapSort method of a inverted array
    HeapSort(ReversArr, Sizes[i], ExprComprs, IsSrtd);
    Heap.Reverse.ExperRes[i] := ExprComprs;
    Heap.Reverse.TheorRes[i] := Sizes[i]*(Ln(Sizes[i])/Ln(2));
    Heap.Reverse.ArrSorted[i] := IsSrtd;

    // Sorting by the Selection sort method of a sorted array
    SelectSort(SortArr, Sizes[i], ExprComprs, IsSrtd);
    Select.Sort.ExperRes[i] := ExprComprs;
    Select.Sort.TheorRes[i] := (Sizes[i]*Sizes[i]-Sizes[i])/2;
    Select.Sort.ArrSorted[i] := IsSrtd;

    // Sorting by the Selection sort method of a random array
    SelectSort(RandArr, Sizes[i], ExprComprs, IsSrtd);
    Select.Random.ExperRes[i] := ExprComprs;
    Select.Random.TheorRes[i] := (Sizes[i]*Sizes[i]-Sizes[i])/2;
    Select.Random.ArrSorted[i] := IsSrtd;

    // Sorting by the Selection sort method of a inverted array
    SelectSort(ReversArr, Sizes[i], ExprComprs, IsSrtd);
    Select.Reverse.ExperRes[i] := ExprComprs;
    Select.Reverse.TheorRes[i] := (Sizes[i]*Sizes[i]-Sizes[i])/2;
    Select.Reverse.ArrSorted[i] := IsSrtd;
  End;

  // Output of the results to the table
  TableOutp(Heap, Select, Sizes, N);
  Readln
End.


