unit uMzGeneration;

interface
Type
  TArr = array of array of Boolean;

Procedure MG(Var MArr: TArr; mHeight, mWidth: Integer);
procedure ME(Var mArr, EArr: TArr; mHeight, mWidth, startX, startY, endX, endY: Integer);

implementation              

Type
  TDirect = Set of 1..4;
  TCell = record
    X, Y: Integer;
    Direct: TDirect;
  End;
  PStack = ^TStack;
  TStack = record
    Next: PStack;
    Data: TCell;
  End;

    {
Var
  mazeHeight, mazeWidth: Integer;
  mazeArr, ExitArr: TArr;
  endX: Integer = mazeWidth;
  endY: Integer = 1;
  startX, startY, endX, endY: Integer;  //Look through
  }
Procedure stackPush(Var p: PStack; Var Cell: TCell);
Var
  addP: PStack;
Begin
  New(addP);
  addP.Data := Cell;
  addP.Next := p;
  p := addP;
End;

Procedure stackPop(Var p: PStack; Var Cell: TCell);
Var
  removeP: PStack;
Begin
  Cell := p.Data;
  removeP := p;
  p := p.Next;
  Dispose(removeP);
End;

Procedure mazeInit(Var Arr: TArr; Const Hght, Wdth: Integer{; Var floor: Boolean});
Var
  I, J: Integer;
Begin
  For I := 0 to Hght-1 do
  Begin
    For J := 0 to Wdth-1 do
    Begin
      Arr[I,J] := True;
    End;
  End;
End;

// Проверяет, есть ли соседи и не посещённые ли они
Procedure CellNeighbour(Var Arr: TArr; Const Wdth, Hght: Integer; X, Y: Integer;
                        Var drct: TDirect; step: Integer; conditn: Boolean);
Begin
  drct := [1,2,3,4];
  If Y - step >= 0 then
  Begin
    If Arr[Y-step,X] = conditn then
      drct := drct - [1]
  End
  Else
    drct := drct - [1];
  If X + step < Wdth then
  Begin
    If Arr[Y,X+step] = conditn then
      drct := drct - [2]
  End
  Else
    drct := drct - [2];
  If Y + step < Hght then
  Begin
    If Arr[Y+step,X] = conditn then
      drct := drct - [3]
  End
  Else
    drct := drct - [3];
  If X-step >= 0 then
  Begin
    If Arr[Y,X-step] = conditn then
      drct := drct - [4];
  End
  Else
    drct := drct - [4];
End;

// Определение координаты соседа и удаление стены
Procedure coordinateDeterm(Var Arr: TArr; Var X, Y: Integer; WhrToGo: Byte);
Const
  Step = 2;
  delStep = 1;
Var
  delX, delY: Integer;
Begin
  Case whrToGo of
    1:
      Begin
        Y := Y-Step;
        delX := X;
        delY := Y+delStep;
      End;
    2:
      Begin
        X := X+Step;
        delX := X-delStep;
        delY := Y;
      End;
    3:
      Begin
        Y := Y+Step;
        delX := X;
        delY := Y-delStep;
      End;
    4:
      Begin
        X := X-Step;
        delX := X+delStep;
        delY := Y;
      End;
  End;
  Arr[delY,delX] := False;
  Arr[Y,X] := False;
End;

Procedure mazeGen(Var Arr: TArr; Const Hght, Wdth: Integer);
Var
  visitFinished: Boolean;
  X, Y: Integer;
  step: Integer;
  Condtn: Boolean;
  drct: TDirect;
  WhrToGo: Byte;
  goFlag: Boolean;
  cell: TCell;
  stack: pStack;
Begin
  SetLength(Arr, Hght, Wdth); //SetLength 2 раз!@
  Randomize;
  Condtn := False;
  Step := 2;
  mazeInit(Arr, Hght, Wdth);
  stack := nil;
  visitFinished := False;

  X := 0;
  Y := 0;

  Arr[Y,X] := False;
  While not visitFinished do
  Begin
      CellNeighbour(Arr,Wdth,Hght,X,Y,drct,step,Condtn);
    If drct <> [] then
    Begin
      cell.X := X;
      cell.Y := Y;
      cell.Direct := drct;
      stackPush(stack, cell);
      goFlag := False;
      While not goFlag do
      Begin
        WhrToGo := random(4)+1;
        If WhrToGo in drct then
          goFlag := True;
      End;
      coordinateDeterm(Arr,X,Y,WhrToGo);
    End
    Else
    Begin
      Repeat
        If stack <> nil then
        Begin
          stackPop(stack, cell);
          X := cell.X;
          Y := cell.Y;
          drct := cell.Direct;
        End
        Else
          visitFinished := True;
      Until (drct <> []) or (stack = nil);
    End;
  End;
End;

Procedure ExitArrInit(Var EArr: TArr; Const W, H: Integer);
Var
  I, J: Integer;
Begin
  For I := 0 to H-1 do
   For J := 0 to W-1 do
    EArr[I,J] := False;
End;

Function CalcNext(Var motion: Byte): Byte;
Begin
  motion := (motion + 1) mod 4;
  If motion = 0 then
  Begin
    motion := 4;
  End;
  Result := motion;
End;

Procedure NextDirctn(Var motion: Byte; drct: TDirect);
Begin
  motion := motion+2;
  If CalcNext(motion) in drct then
    Else If CalcNext(motion) in drct then
      Else If CalcNext(motion) in drct then
        Else
          CalcNext(motion)
End;

Procedure NextCoordinate(Var StepDirctn: Byte; Var X, Y, prX, prY: Integer);
Begin
  prX := X;
  prY := Y;
  Case StepDirctn of
    1:
      Begin
        Y := Y-1;
      End;
    2:
      Begin
        X := X+1;
      End;
    3:
      Begin
        Y := Y+1;
      End;
    0 or 4:
      Begin
        X := X-1;
      End;
  End;
End;

// Выход из лабиринта
Procedure FindExit(Var Arr, EArr: TArr; Const W, H: Integer; Var endX, endY: Integer; X, Y: Integer);
Var
  {X, Y,} prevX, prevY: Integer;
  StepDirctn: Byte;
  step: Integer;
  Condtn: Boolean;
  drct: TDirect;

Begin
{
  //endY := H;
  If endY mod 2 = 0 then
    dec(endY);
  //endX := W;
  If endX mod 2 = 0 then
    dec(endX);
  X := 1;
  Y := 1;
  }
  StepDirctn := 2;
  step := 1;
  Condtn := True;
  ExitArrInit(EArr, W, H);
  While (X <> endX) or (Y <> endY) do
  Begin
    CellNeighbour(Arr, W, H, X, Y, drct, step, condtn);
    NextDirctn(StepDirctn, drct);
    NextCoordinate(StepDirctn, X, Y, prevX, prevY);
    If not EArr[Y,X] then
      EArr[Y,X] := True
    Else
      EArr[PrevY,PrevX] := False;
  End;
End;



Procedure MG(Var MArr: TArr; mHeight, mWidth{, startX, startY}: Integer);
Begin
  {mHeight := 20;
  mWidth := 50; }

  {
  If mHeight mod 2 = 0 then
  begin
    inc(mHeight);
    //inc(startY);
  end;
  If mWidth mod 2 = 0 then
  begin
    inc(mWidth);
    //inc(startX);
  end;
  }

  SetLength(mArr, mHeight, mWidth);
  //SetLength(EArr, mHeight, mWidth);
  {
  startX := 0;
  startY := 0;
   }
  mazeGen(mArr, mHeight, mWidth);

  //DrawMaze(mArr, mHeight, mWidth);
  {
  endX := mWidth-1;
  endY := mHeight-1;
  }
  //      ///FindExit(mArr,EArr,mWidth,mHeight, endX, EndY, startX, startY);

  //DrawMaze_2(mArr,EArr,mHeight,mWidth);
End;

procedure ME(Var mArr, EArr: TArr; mHeight, mWidth, startX, startY, endX, endY: Integer);
Begin
  SetLength(EArr, mHeight, mWidth);
  FindExit(mArr,EArr,mWidth,mHeight, endX, EndY, startX, startY);
End;

End.
end.
