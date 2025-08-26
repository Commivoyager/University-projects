unit uModel;

interface
  uses                                                                                 
    SysUtils, Windows, uMzGeneration;
Type
    MTArr = array of array of Boolean;
    TTileArr = array of array of Byte;
    TStr = string;
    TPlayer = record
      v: Single;
      x, y: Integer;
      Startt, Maxt: Integer;
      Dist: Integer;
      eX, eY: Integer;                                         
    End;

    TBuilding = class
      protected
        FWidth, FHeight: Integer;  // размер лабиринта из формы, либо инкрементированный, если введён чётный
        FWRoom, FHRoom: Integer;    // КООРДИНАТА!!! комнаты
        FMaxLevel, FCurrLevel: Integer;
        FwColor, FrColor: Integer;


        {
        fTileSize, fTileArrWSize, fTileArrHSize: Integer;
        //fTileArrSize: Integer;
        fTilePos: Integer;
        fEvenly: Boolean;
        fMoveDistance, fPosNext: Integer;
        fRightOrDown: Byte;
        FVertical: Boolean; // True - движение по вертикали
         }
        fPl: TPlayer;

      private

        function GetHeight: String;
        function GetWidth: String;
        procedure SetHeight(const Value: String);
        procedure SetWidth(const Value: String);
      function GetRH: Integer;
    function GetRW: Integer;
    procedure SetRH(const Value: Integer);
    procedure SetRW(const Value: Integer);
    //function GetCurrLevel: String;
    function GetMaxLevel: String;
    //procedure SetCurrLevel(const Value: String);
    procedure SetMaxLevel(const Value: String);
    function GetCurrLevel: Integer;
    procedure SetCurrLevel(const Value: Integer);


      public
        FDetrmdR: String;
        FDetrmdLevel: Integer;

        FMArr, FEArr: TArr;
        FFillTileArr: TTileArr;
        FRoomTileArr: TTileArr;
        TileArr: TTileArr;

        //fRH, fRW: Integer;

        fTileSize, fTileArrWSize, fTileArrHSize: Integer;


        //fTileArrSize: Integer;
        fTilePos: Integer;
        fEvenly: Boolean;
        fMoveDistance, fPosNext: Integer;
        fRightOrDown: ShortInt;
        FVertical: Boolean; // True - движение по вертикали

        fXPlayer, fYPlayer: Integer;  // координаты игрока
        FKey: Char;
        //FRoom, FNextStair, FPrevStair, FNextElevator, FPrevElevator: Boolean;
        FArrEl: Byte;
        //Num: Byte;
        FCanMove: Boolean;
        FXStartE, FYStartE, FXEndE, FYEndE: Integer;

        fTileRoomArrWSize, fTileRoomArrHSize: Integer;
        //FRealRWidth; FRealRHeight: Integer;
        fRoomTileSize,fMazeTileSize: Integer;

        property mHeight: String read GetHeight write SetHeight;
        property mWidth: String read GetWidth write SetWidth;
        procedure MGenerate();
        procedure DetermRoom(Var Arr: TArr);


        function ColorToNum(wCol,rCol: Integer): Integer;
        procedure DetermLevel();
        procedure LocationSet();

        function DetermLocation(Const rColor, wColor: Integer): Integer;

        //Tiles
        procedure CalcTilePos(Var crdnt: Integer);
        procedure fillTileArr(delta: Integer);
        procedure CalcDistance(Var crdnt: Integer);
        procedure determTile(Var w, h: Integer);

        procedure walk(Var x,y: Integer);
        procedure move();

        procedure FillRoomTileArr(delta: Integer);

        procedure PrepareExit(delta, x, y: Integer);
        procedure EFinding();

        procedure NumToColor(Level: Integer);
        procedure DetermNextLevel(NxtDrct: ShortInt);

        procedure ChooseTileSize(Size: Integer);
        procedure GoToMazeCrdnt(delta: Integer; H, W: Integer);

        property rHeight: Integer read GetRH write SetRH;
        property rWidth: Integer read GetRW write SetRW;

        property maxLevel: String read GetMaxLevel write SetMaxLevel;
        property currLevel: Integer read GetCurrLevel write SetCurrLevel;
        property wColor: Integer read FwColor write FwColor;
        property rColor: Integer read FrColor write FrColor;

        property xPl: Integer read fXPlayer write fXPlayer;
        property yPl: Integer read fYPlayer write fYPlayer;

    End;

implementation



{ TBuilding }

function TBuilding.GetHeight: String;
begin
  Result := IntToStr(FHeight);
end;

function TBuilding.GetWidth: String;
begin
  Result := IntToStr(FWidth);
end;

procedure TBuilding.SetHeight(const Value: String);
Var
  temp: Integer;
begin
  temp := StrToInt(Value);
  If temp mod 2 = 0 then
  begin
    inc(temp);
  end;
  FHeight := temp;
end;

procedure TBuilding.SetWidth(const Value: String);
Var
  temp: Integer;
begin
  temp := StrToInt(Value);
  if temp mod 2 = 0 then
  begin
    inc(temp);
  end;
  FWidth := temp;
end;

procedure TBuilding.MGenerate();
Begin
  MG(FMArr, FHeight, FWidth);
End;

procedure TBuilding.PrepareExit(delta, x, y: Integer);
Begin
  FXStartE := fXPlayer div delta - 2;
  FYStartE := fYPlayer div delta - 2;

  FXEndE := x;
  FYEndE := y;
  If FMArr[FYEndE,FXEndE] then
  Begin

  FXEndE := x;
  FYEndE := y+1;
  If FMArr[FYEndE,FXEndE] then
  Begin
    FXEndE := x-1;
    FYEndE := y;
    If FMArr[FYEndE,FXEndE] then
    Begin
      FXEndE := x;
      FYEndE := y-1;
      If FMArr[FYEndE,FXEndE] then
      Begin
        FXEndE := x+1;
        FYEndE := y;
      End;
    End;
  End;

  End;
End;

procedure TBuilding.EFinding();
Begin
  ME(FMArr, FEArr, FHeight, FWidth, FXStartE, FYStartE, FXEndE, FYEndE);
End;

//Tile   (FMArr, FWidth, FHeight);

procedure TBuilding.DetermRoom(Var Arr: TArr);
Begin
  FWRoom := FWRoom div 2;
  FHRoom := FHRoom div 2;
  if not arr[FHRoom,FWRoom] then
  Begin
    inc(FHRoom);
    if not arr[FHRoom,FWRoom] then
    Begin
    inc(FWRoom);
    if not arr[FHRoom,FWRoom] then
      Begin
        dec(FHRoom);
      End;
    End;
  End;
  If arr[FHRoom+1,FWRoom] and arr[FHRoom-1,FWRoom] and arr[FHRoom,FWRoom+1] and arr[FHRoom,FWRoom-1] then
  Begin
    inc(FHRoom);
  End;
End;


function TBuilding.GetRH: Integer;
begin
  Result := FHRoom;
end;                          

function TBuilding.GetRW: Integer;
begin
  Result := FWRoom;
end;

procedure TBuilding.SetRH(const Value: Integer);
begin
  FHRoom := Value;
end;

procedure TBuilding.SetRW(const Value: Integer);
begin
  FWRoom := Value;
end;



function TBuilding.GetMaxLevel: String;
begin
  Result := IntToStr(FMaxLevel);
end;

procedure TBuilding.SetMaxLevel(const Value: String);
begin
  FMaxLevel := StrToInt(Value);
end;
      {
function TBuilding.GetCurrLevel: String;
begin
  Result := IntToStr(FCurrLevel);
end;

procedure TBuilding.SetCurrLevel(const Value: String);
begin
  FCurrLevel := StrToInt(Value);
end; }

function TBuilding.GetCurrLevel: Integer;
begin
  Result := FCurrLevel;
end;

procedure TBuilding.SetCurrLevel(const Value: Integer);
begin
  FCurrLevel := Value;
end;

function TBuilding.ColorToNum(wCol,rCol: Integer): Integer;
Var
  w, r: Integer;
  temp: Integer;
Begin
  r := 0;
  w := 0;
  temp := 1;
  While (w <> wCol) or (r <> rCol) do
  Begin
    r := (r+1) mod 3;
    w := (w+1) mod 5;
    inc(temp);
  End;
  Result := temp;
End;

procedure TBuilding.DetermLevel();
//Var                    // Определить эиаж на моменте генерации рандомного цветц
Begin
  FCurrLevel := ColorToNum(FwColor,FrColor);
  {While w <> FwColor do
  Begin
    While r <> FrColor do
    Begin
      r := (r+1) mod 3;
      inc(temp);
    End;
      w := (w+1) mod 5;
  End;}
  //FCurrLevel := temp;
End;

procedure TBuilding.LocationSet();
Var                           // Установить рандомный цвет
  temp: Integer;
Begin
  randomize;
  Repeat
    repeat
      temp := random(5);
    Until temp <> FwColor;
    FwColor := temp;
    FrColor := random(3);
    DetermLevel();
  until FMaxLevel >= FCurrLevel;
End;

function TBuilding.DetermLocation(Const rColor, wColor: Integer): Integer;
                                  //Определить этаж по запросу пользователя
Begin
  FDetrmdLevel := ColorToNum(wColor,rColor);
  Case rColor of
    0:
      FDetrmdR := 'Room';
    1:
      FDetrmdR := 'Prison';
    2:
      FDetrmdR := 'Lab';
  End;
End;
     {
procedure TBuilding.calcTileSize(delta, width, height: Integer);
Begin

End;
     }




Procedure TBuilding.fillTileArr(delta: Integer);// Инициализация // width = TForm.Width}
Var
  i,j: Integer;
  x,y: Integer;
  st1, st2, el1, el2: Integer;
Begin
  fMazeTileSize := delta div 3;
  //fTileArrWSize := width div fTileSize - 1;
  //fTileArrHSize := height div fTileSize - 1;
  fTileArrWSize := (FWidth+4)*3; // с учётом границы и отступа лабиринта
  fTileArrHSize := (FHeight+4)*3;
  SetLength(FFillTileArr,fTileArrHSize,fTileArrWSize);   // SetLength(массив,строки,столбцы);
  for i := 3 to fTileArrHSize-1-3 do    // так как нужно пропустить 3 тайла (1 блок) - отступ лабиринта и от длины отнять 1, тк нумерация с 0
  Begin
    x := i div 3-2;   // так как div даст значения с учётом отступа и внешней стены лабиринта (т.е. 0 - отступ, 1 - внешняя стена) и внешняя стена не входит в массив лабиринта
    for j := 3 to fTileArrWSize-1-3 do
    Begin
      y := j div 3-2;
      if (x = -1) or (x = FHeight) or (y = -1) or (y = FWidth) then
      Begin
        FFillTileArr[i,j] := 1; // 1 - True - стена
      End
      Else
      Begin
        if FMArr[x,y] then
          FFillTileArr[i,j] := 1
        Else
          FFillTileArr[i,j] := 0;
      End;
    End;
  End;                                     // Чётные этажи - слева вниз
  if FCurrLevel mod 2 = 0 then             // 2 - stars down 3 - up 4 - elevator down 5 - up 6 - room
  Begin                                    // stUp, stDown, elUp, elDown: Integer;
    st1 := 2;
    st2 := 3;
    el1 := 4;
    el2 := 5;
  End
  Else
  Begin
    st1 := 3;
    st2 := 2;
    el1 := 5;
    el2 := 4;
  End;
  for i := 6 to 8 do
  Begin
      for j := 3 to 5 do
      Begin
        FFillTileArr[i,j] := st1;
        FFillTileArr[i,j+(FWidth+1)*3] := st2;
        FFillTileArr[i+(FHeight-1)*3,j] := el1;
        FFillTileArr[i+(FHeight-1)*3,j+(FWidth+1)*3] := el2;
        FFillTileArr[i+FHRoom*3, j+3+3*FWRoom] := 6;          // Да, FWRoom используется как координата
      End;
  End;
  {for i := (2+FWRoom)*3 do
  Begin

  End;}
End;


procedure TBuilding.FillRoomTileArr(delta: Integer);
Var
  i,j: Integer;
  x,y: Integer;
  //st1, st2, el1, el2: Integer;
Begin
  fRoomTileSize := delta div 3;
  //fTileRoomArrWSize := fTileRoomArrWSize*3;
  //fTileRoomArrHSize := fTileRoomArrHSize*3;
  SetLength(FRoomTileArr,fTileRoomArrHSize,fTileRoomArrWSize);   // SetLength(массив,строки,столбцы);
  for i := 0 to fTileRoomArrHSize-1 do    // так как нужно пропустить 3 тайла (1 блок) - отступ лабиринта и от длины отнять 1, тк нумерация с 0
  Begin
    x := i div 3;
    for j := 0 to fTileRoomArrWSize-1 do
    Begin
      y := j div 3;
      if (x = 1) or (x = 11) or (y = 1) or (y = 11) then
      Begin
        FRoomTileArr[i,j] := 1; // 1 - True - стена
      End
      Else
      Begin
        If (x > 1) or (x < 11) or (y > 1) or (y < 11) then
        FRoomTileArr[i,j] := 0;
      End;
      {
      Begin
        if FMArr[x,y] then
          FFillTileArr[i,j] := 1
        Else
          FFillTileArr[i,j] := 0;
      End;
      }
    End;
  End;
  for i := 18 to 20 do
  Begin
      for j := 18 to 20 do
      Begin
        FRoomTileArr[i,j] := 7;
      End;
  End;
End;
                    // TileArr
procedure TBuilding.ChooseTileSize(Size: Integer);
Begin
  fTileSize := Size;
End;


procedure TBuilding.CalcTilePos(Var crdnt: Integer); // crdnt - координата оси, перпендикулярно которой движемся
Begin                                                // какие тайлы вдоль движения пересекает
  fTilePos := crdnt div fTileSize;   //fTilePos - позиция в тайлах, занимаемая игроком(позиция вершины)
  if fTileSize*fTilePos < crdnt then
  Begin
    fEvenly := False;
  End
  Else
    fEvenly := True;
End;

procedure TBuilding.CalcDistance(Var crdnt: Integer);      // crdnt - координата той оси, вдоль которой движемся
Var
  i, j, ArrNextEl: Integer;
Begin                                                          //  fRightOrDown > 0 - right or down
  fMoveDistance := 0;
  fPosNext := crdnt div fTileSize;   // номер ряда тайлов, в котором мы
  if fRightOrDown > 0 then
  Begin
    If fPosNext*fTileSize < crdnt then
    Begin                                 // не ровно в тайле
      fPosNext := fPosNext+2; //прям координата следующей клетки, куда направляется игрок, но ещё не затрагивает её
      fMoveDistance := fPosNext*fTileSize - (crdnt+fTileSize);
    End
    Else
    Begin
      fPosNext := fPosNext+1;
    End;
    //fMoveDistance := fTileSize-(crdnt+fTileSize) mod fTileSize;

  End
  Else
  Begin
    fPosNext := fPosNext - 1;
    fMoveDistance := crdnt - (fPosNext+1)*fTileSize;     //crdnt mod fTileSize;
  End;
  if fVertical then
  Begin
    i := fPosNext;
    j := fTilePos;
  End
  Else
  Begin
    i := fTilePos;
    j := fPosNext;
  End;
  //ArrEl := TileArr[i,j];
  //While ArrEl = 0 do
  Repeat
  FArrEl := TileArr[i,j];
     //Begin
    {0
    Case FArrEl of
    2:
      Begin
        FRoom := True;
      End;
    // и другие числа   }
   { 1:
    Begin
      fPl.v := 0;
    End;
    0:  }
    If FArrEl = 0 then
    Begin
      If not fEvenly then
      Begin
        if fVertical then
          Begin
            FArrEl := TileArr[i,j+1];//[i,j+fRightOrDown];
          End
          Else
          Begin
            FArrEl := TileArr[i+1,j];//[i+fRightOrDown,j];
          End;
        If FArrEl = 0 then
        //0:
        Begin
          fMoveDistance := fMoveDistance+fTileSize;
          if fVertical then
          Begin
            i := i+fRightOrDown
          End
          Else
          Begin
            j := j+fRightOrDown;
          End;
        End;
        {2:
        Begin
          FRoom := True;
        End;
        3:
        Begin
          FNextStair := True;
        End;
        4:
        Begin
          FPrevStair := True;
        End;
        5:
        Begin
          FNextElevator := True;
        End;
        6:
        Begin
          FPrevElevator := True;
        End; }
       { 1:
        Begin
          fPl.v := 0;
        End;}
        // и другие
        {End; //Case  }

      End // If not fEvenly
      Else
      Begin
        fMoveDistance := fMoveDistance+fTileSize;
          if fVertical then
          Begin
            i := i+fRightOrDown
          End
          Else
          Begin
            j := j+fRightOrDown;
          End;
      End;
    End;// If FArrEl = 0 then

    //End; // Внешний Case
  //End; //While
  Until FArrEl <> 0;
End;

procedure TBuilding.determTile(Var w, h: Integer); //fTileSize - решить
Begin
  w := ((w)*3+1)*fTileSize;
  h := ((h)*3+1)*fTileSize;
End;

procedure TBuilding.walk(Var x,y: Integer);
Var
  crdntNormal, crdntParallel: Integer;
Begin
  if fVertical then
  Begin
    crdntNormal := x;    // координата оси, перпендикулярно которой движемся   ?
    crdntParallel := y;  // параллельно
  End
  Else
  Begin
    crdntNormal := y;
    crdntParallel := x;
  End;
  CalcTilePos(crdntNormal);
  CalcDistance(crdntParallel);

  fPl.v := fTileSize/500;                       //мб больше
  fPl.Maxt := fMoveDistance div fTileSize;
  fPl.x := fXPlayer;
  fPl.y := fYPlayer;
  fPl.Startt := GetTickCount;
  fPl.Dist := 0;
  If fVertical then
  Begin
    fPl.eY := fPl.y + fRightOrDown*fMoveDistance;
    fPl.eX := fPl.x;
  End
  Else
  Begin
    fPl.eX := fPl.x + fRightOrDown*fMoveDistance;
    fPl.eY := fPl.y
  End;

End;


procedure TBuilding.move();
Var
  Nowt, Dt: Integer;
  endx, EndY: Integer;
Begin
  Nowt := GetTickCount;
  Dt := Nowt-fPl.Startt;
  If fVertical then
  Begin
    fPl.y := fPl.y+Round(fRightOrDown*Dt*fPl.v);
    fYPlayer := fPl.y;
  End
  Else
  Begin
    fPl.x := fPl.x+Round(fRightOrDown*Dt*fPl.v);
    fXPlayer := fPl.x;
  End;
  fPl.Dist := fPl.Dist+Round(Dt*fPl.v);

  If fPl.Dist >= fMoveDistance then
  Begin
    fPl.v := 0;
    fXPlayer := fPl.eX;
    fYPlayer := fPl.eY;
    fPl.x := fPl.eX;
    fPl.y := fPl.eY;
    //Num := FArrEl;

    //FKey := '0';
    FCanMove := False;
  End
  Else
    FCanMove := True;
End;

    {TPlayer = record
      v: Integer;
      x, y: Integer;
      Dt, Maxt: Integer;
    End;}
    {FRoom, FNext, FPrev: Boolean}

procedure TBuilding.NumToColor(Level: Integer);
Var
  w, r: Integer;
  temp: Integer;
Begin
  r := 0;
  w := 0;
  temp := 1;
  While temp <> Level do
  Begin
    r := (r+1) mod 3;
    w := (w+1) mod 5;
    inc(temp);
  End;
  FwColor := w;
  FrColor := r;
  FCurrLevel := Level;
End;

procedure TBuilding.DetermNextLevel(NxtDrct: ShortInt);
Begin
  NumToColor(FCurrLevel+NxtDrct);
End;

procedure TBuilding.GoToMazeCrdnt(delta: Integer; H, W: Integer);//delta = FRoomDelta
Begin   //FHRoom
  fYPlayer := H+1;
  fXPlayer := W;
  If TileArr[6+fYPlayer*3,6+fXPlayer*3] <> 0 then
  Begin
    fYPlayer := H;
    fXPlayer := W-1;
    If TileArr[6+fYPlayer*3,6+fXPlayer*3] <> 0 then
    Begin
      fYPlayer := H-1;
      fXPlayer := W;
      If TileArr[6+fYPlayer*3,6+fXPlayer*3] <> 0 then
      Begin
        fYPlayer := H;
        fXPlayer := W + 1;
      End;
    End;
  End;
  fXPlayer := ((2+fXPlayer)*3+1)*delta;
  fYPlayer := ((2+fYPlayer)*3+1)*delta;
  //fXPlayer := 3*delta;
  //fYPlayer := 3*delta;
End;

end.
