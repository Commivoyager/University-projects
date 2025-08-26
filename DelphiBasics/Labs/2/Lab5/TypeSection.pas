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
  AnswrStr - the type of ? string containing information about whether the array is sorted;
  TInpStr - the type of string passed to the input procedure to output information to the user;
  TElArray - the type of sorted array;
  TSizez - the type of array that stores the dimensions of the sorted arrays;
  TRes - the type of record whose fields are arrays storing sorting results: number of comparisons;
  TArrType - the type of record whose fields are records storing sorting results
}