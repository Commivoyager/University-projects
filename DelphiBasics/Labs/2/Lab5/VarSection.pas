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