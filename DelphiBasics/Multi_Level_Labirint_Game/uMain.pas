unit uMain;       //Всё должно делать OnActive DetermLocation

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  uModel, StdCtrls, Menus, ExtCtrls, AppEvnts;

type
  TfrmGame = class(TForm)
    pnlSettings: TPanel;
    lblLevel: TLabel;
    cbWalls: TComboBox;
    cbRoom: TComboBox;
    pnlBegin: TPanel;
    lblWidth: TLabel;
    lblHeight: TLabel;
    lblMaxLevelNum: TLabel;
    btnStart: TButton;
    editWidth: TEdit;
    editHeight: TEdit;
    editMaxLevelNum: TEdit;
    btnDetermLocation: TButton;
    lblnameInfo: TLabel;
    memInfo: TMemo;
    ApplicationEvents1: TApplicationEvents;
    pnlExiCheckB: TPanel;
    checkbElevator: TCheckBox;
    checkbStairs: TCheckBox;
    checkbRoom: TCheckBox;
    procedure FormPaint(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure paintMaze(Sender: TObject);
    procedure btnDetermLocationClick(Sender: TObject);
    procedure paintPlayer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnDetermLocationKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);

    procedure DtrmNextLoc(Sender: TObject);
    procedure brushcolor();
    procedure paintRoom(Sender: TObject);
    procedure btnDetermLocationKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure checkbRoomClick(Sender: TObject);
    procedure checkbStairsClick(Sender: TObject);
    procedure checkbElevatorClick(Sender: TObject);
  protected
    //fH, fW: Integer;

    //fRH, fRW: Integer;

    fDelta, fRoomDelta: Integer;
    fPaintMaze, fPaintRoom: Boolean;
    clrM, clrR: Integer;
    //TileArr{, RoomTileArr}: TTileArr;
    //fPaintRoom: Boolean;

    //fXPlayer, fYPlayer: Integer;

    //fRoomDelta: Integer;
    FCanChangeLoc: Boolean;

    fRoomWay, fStairsWay, fElevWay: Boolean;
  public
    { Public declarations }
  end;

var
  frmGame: TfrmGame;
  Build: TBuilding;

implementation

{$R *.dfm}
Var
  fH, fW: Integer;


  //_q: TStrings;
  {MArr, EArr: MTArr;
 } //startX, startY, endX, endY: Integer;

procedure TfrmGame.brushcolor();
Begin
Case Build.wColor of
    0:
      clrM := $507FFF; // orange
    1:
      clrM := $00FFFF; // yellow
    2:
      clrM := $2FFFAD; // green
    3:
      clrM := $FFFF00; // blue
    4:
      clrM := $82004B; // purple
  End;
  Case Build.rColor of
    0:
      clrR := $696969; // gray
    1:
      clrR := $000000; // black
    2:
      clrR := $FFFFFF; // white
  End;
End;

procedure TfrmGame.paintMaze(Sender: TObject);
Var
  i, j: Integer;
  x1,x2,y1,y2: Integer;
  //clrM, clrR: Integer;
begin
  x1 := fDelta;
  y1 := fDelta;                           //  0000FF - red    FFFFFF - White - переходы  CD0000 - синий
  x2 := x1 + fDelta - 2;                //      507FFF - orange  00FFFF  2FFFAD  FFFF00    82004B
  y2 := y1+fDelta-2;
  {
  Case Build.wColor of
    0:
      clrM := $507FFF; // orange
    1:
      clrM := $00FFFF; // yellow
    2:
      clrM := $2FFFAD; // green
    3:
      clrM := $FFFF00; // blue
    4:
      clrM := $82004B; // purple
  End;

  Case Build.rColor of
    0:
      clrR := $696969; // gray
    1:
      clrR := $000000; // black
    2:
      clrR := $FFFFFF; // white
  End;
  }
  //Debugging
  //Canvas.Brush.Color := clBlack;
 //Canvas.FillRect(Rect(0,0,1000,1000));
  //frmGame.Color := clBlack;
  Canvas.Brush.Color := clrM;
  For i := -1 to fH do
  Begin
    For j := -1 to fW do
    Begin
      if (i = -1) or (i = fH) or (j = -1) or (j = fW) then
      Begin
        //Canvas.Brush.Color := clYellow;
        If (i = 0) or (i = fH-1) then
        Begin
          Canvas.Brush.Color := clWhite;
          Canvas.FillRect(Rect(x1,y1,x2,y2));
          Canvas.Brush.Color := clrM;
        End
        Else
          Canvas.FillRect(Rect(x1,y1,x2,y2));
      End
      else
      Begin
        if Build.FMArr[i,j] then
        Begin
          //Canvas.Brush.Color := clYellow;
          If (i <> Build.rHeight) or (j <> Build.rWidth) then
          Begin
            Canvas.FillRect(Rect(x1,y1,x2,y2));
          End
          Else
          Begin
            Canvas.Brush.Color := clWhite;
            Canvas.FillRect(Rect(x1,y1,x2,y2));
            Canvas.Brush.Color := clrM;
          End;
        End
        Else
        Begin
          If fRoomWay or fStairsWay or fElevWay then
          If Build.FEArr[i,j] then
          Begin
            Canvas.Brush.Color := clGreen;
            Canvas.FillRect(Rect(x1,y1,x2,y2));
            //Canvas.Ellipse(x1,y1,x2,y2);
            Canvas.Brush.Color := clrM;
          End
        End;

      End;

      x1 := x1+fDelta;
      x2 := x2+fDelta;
    End;
    x1 := fDelta;
    y1 := y1+fDelta;
    x2 := x1+fDelta-2;
    y2 := y2+fDelta;

  End;

  {
  // Пока не удалять
  //debugging

    x1 := 0;
    y1 := 0;
    x2 := fDelta;
    y2 := fDelta;
    For i := 1 to fW+4 do
    begin
      if i mod 2 = 0 then
        Canvas.Brush.Color := clWhite
      Else
        Canvas.Brush.Color := $FAE6E6;
      Canvas.FillRect(Rect(x1,y1,x2,y2));
      x1 := x1+fDelta;
      x2 := x2+fDelta;
    end;
  }
end;

procedure TfrmGame.paintRoom(Sender: TObject);
Var
  i, j: Integer;
  x1,x2,y1,y2: Integer;
Begin
  x1 := froomDelta;
  y1 := froomDelta;
  x2 := x1 + froomDelta - 2;
  y2 := y1+froomDelta-2;
  Canvas.Brush.Color := clrM;
  For i := 0 to 10 do
  Begin
    For j := 0 to 10 do
    Begin
      if (i = 0) or (i = 10) or (j = 0) or (j = 10) then
      Begin
        Canvas.Brush.Color := clrM;
        Canvas.FillRect(Rect(x1,y1,x2,y2));
      End
      else
      Begin
        //if Build.FMArr[i,j] then
        //Begin
          //Canvas.Brush.Color := clYellow;
        If (i<>5) or (j<>5) then
        Begin
          Canvas.Brush.Color := clrR;
          Canvas.FillRect(Rect(x1,y1,x2,y2));
        End
        Else
        Begin
          Canvas.Brush.Color := clBlue;
          Canvas.FillRect(Rect(x1,y1,x2,y2));
        End;
        //End;
      End;

      x1 := x1+froomDelta;
      x2 := x2+froomDelta;
    End;
    x1 := froomDelta;
    y1 := y1+froomDelta;
    x2 := x1+froomDelta-2;
    y2 := y2+froomDelta;
  End;
End;

procedure TfrmGame.paintPlayer(Sender: TObject);
begin
  Canvas.Brush.Color := clBlack;
  Canvas.Pen.Color := clWhite;
  Canvas.Pen.Width := 2;
  With Build do
    Canvas.Ellipse(xPl,yPl,xPl+Build.fTileSize,yPl+Build.fTileSize);
end;

procedure TfrmGame.FormPaint(Sender: TObject);
begin
  //
  //Case Num of
  //0,1:
    //begin
    If fPaintMaze then
    Begin
      paintMaze(Sender);
      paintPlayer(Sender);
      //paintPlayer(Sender);
    End;
    If fPaintRoom then
    Begin
      paintRoom(Sender);
      paintPlayer(Sender);
    End;
    //end;
  //2:
  //startX := 0;
  //startY := 0;
  //endX := StrToInt(Build.mWidth)-1;
  //endY := StrToInt(Build.mHeight)-1;
  //MG(MArr, EArr, mHeight, mWidth, startX, startY, endX, endY);
  //Case FArrEl

end;

procedure TfrmGame.btnStartClick(Sender: TObject);
begin
  lblLevel.Caption := 'Maze';                                       // Вынести ли подобное куда-то отдельно
  Build.mWidth := editWidth.Text;
  Build.mHeight := editHeight.Text;

  fW := StrToInt(Build.mWidth);
  fH := StrToInt(Build.mHeight);

  If  fW > fH then
  begin
    ClientWidth := 1155;                //Const
    fDelta := (ClientWidth-255) div (fW+4);            //поменял ...div (fW+6);
    while fDelta mod 3 <> 0 do
      inc(FDelta);
    ClientWidth := (fW+4)*fDelta+255;
    ClientHeight := (fH+4)*fDelta;
  End
  Else
  Begin
    ClientHeight := 900;                //Const
    fDelta := ClientHeight div (fH+4);                   //поменял ...div (fW+6);
    While fDelta mod 3 <> 0 do
      inc(fDelta);
    ClientHeight := (fH+4)*fDelta;
    ClientWidth := (fW+4)*fDelta+255;
  End;
  fRoomDelta := ClientHeight div 13;

  //MG(MArr, EArr, mHeight, mWidth, startX, startY, endX, endY);
  Build.MGenerate();
  //brushcolor();


  ///////////////////////////////Num


  //btnDetermLocation.Enabled := True;

  // Задание координаты комнаты в самом лабиринте
  Build.rWidth := fW;
  Build.rHeight := fH;
  Build.DetermRoom(Build.FMArr);


  //Build.fTileRoomArrWSize := 11;
  //Build.fTileRoomArrHSize := 11;

  //Build.FRealRWidth := 11*3;
  //Build.FRealRHeight := 11*3;

  //Build.rHeight := fRH;
  //Build.rWidth := fRW;

  cbWalls.Enabled := True;
  cbRoom.Enabled := True;
  btnDetermLocation.Enabled:= True;

  memInfo.Text := 'Specify the color of the walls and floor to determine your location';
  if StrToInt(editMaxLevelNum.Text) > 15 then
  begin
    memInfo.Text := memInfo.Text + #13#10 + 'The maximum number of levels is 15';                           //delete showmessage
    editMaxLevelNum.Text := '15';
  end;
  Build.maxLevel := editMaxLevelNum.Text;


  //Build.DetermLevel();

  Build.LocationSet();
  brushcolor();
  //ShowMessage(IntToStr(Build.currLevel));
  //ShowMessage(IntToStr(Build.wColor)+' '+IntToStr(Build.rColor));

  //ShowMessage(cbFloor.Items.Strings[0]);
  //ShowMessage(IntToStr(cbFloor.Items.Count));
  //ShowMessage(cbFloor.Text);
  //ShowMessage(IntToStr(cbFloor.ItemIndex));


  build.fillTileArr(fDelta);   //БЫЛ ОСНОВНЫМ МАССИВОМ СО СТЕНАМИ ЛАБИРИНТА

  build.fTileRoomArrHSize := 39; //const
  build.fTileRoomArrWSize := 39;
  build.FillRoomTileArr(fRoomDelta);
  build.ChooseTileSize(build.fRoomTileSize);
  //Build.ChooseTileSize(Build.FRoomTileArr);
  //Build.TileArr := Build.FRoomTileArr;

  With Build do
  Begin
    //xPl := fW-1;
    //yPl := fH-1;
    xPl := 6;
    yPl := 5;

    determTile(fXPlayer, fYPlayer);
    //ShowMessage(IntToStr(fXPlayer) +' '+ IntToStr(fYPlayer));
    FKey := '0';
    frmGame.ActiveControl := btnDetermLocation; // Расставить для всех контролов
  End;

  fRoomWay := False;
  fStairsWay := False;
  fElevWay := False;
  checkbRoom.Checked := False;
  checkbStairs.Checked := False;
  checkbElevator.Checked := False;
  checkbRoom.Enabled := False;
  checkbStairs.Enabled := False;
  checkbElevator.Enabled := False;

  FCanChangeLoc := True;
  Build.FCanMove := True;
  Build.TileArr := Build.FRoomTileArr;
  fPaintMaze := False;
  fPaintRoom := True;

  Invalidate;
end;



procedure TfrmGame.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //Invalidate;
end;



procedure TfrmGame.FormCreate(Sender: TObject);
begin
  fPaintMaze := False;
  Build := TBuilding.Create;
  DoubleBuffered := True;
end;



procedure TfrmGame.btnDetermLocationClick(Sender: TObject);
begin
  If (cbWalls.ItemIndex <> -1) and (cbRoom.ItemIndex <> -1) then
  Begin
    //ShowMessage('Right');

    Build.DetermLocation(cbRoom.ItemIndex, cbWalls.ItemIndex);

    //Build.DetermLevel();
    //ShowMessage(IntToStr(Build.currLevel));
    memInfo.Text := 'You are at level ' + IntToStr(Build.FDetrmdLevel);
    memInfo.Text := memInfo.Text + #13#10 + 'You are in ' + Build.FDetrmdR;
    //Build.currLevel := Build.FDetrmdLevel; // НЕПРАВИЛЬНО
    lblLevel.Caption := 'Level' + IntToStr(Build.FDetrmdLevel);
  End
  Else
  Begin
    memInfo.Text := 'It was not possible to determine the level' + #13#10 + 'Choose the color of the walls and floor';
  End;

  //ShowMessage('Width' + IntToStr(ClientWidth) + #13#10 + 'Height' + IntToStr(ClientHeight));
end;

procedure TfrmGame.FormKeyPress(Sender: TObject; var Key: Char);
begin
//
end;

procedure TfrmGame.DtrmNextLoc(Sender: TObject);
Var
  NextDrctn: ShortInt;
  drctn: string[4];
  gEnd: Boolean;
Begin
  Case Build.FArrEl of
    2..5:
    Begin
      If Build.FArrEl mod 2 = 0 then
      Begin
        If Build.currLevel <> 1 then
        Begin
          NextDrctn := -1;
          drctn := 'down';
          gEnd := False;
        End
        Else
        Begin
          gEnd := True;
        End;
      End
      Else
      Begin
        If Build.currLevel <> StrToInt(Build.maxLevel) then
        Begin
          NextDrctn := 1;
          drctn := 'up';
          gEnd := False;
        End
        Else
        Begin
          gEnd := True;
        End;
      End;
      If not gEnd then
      Begin
        //NextDrctn := -1;
        Build.DetermNextLevel(NextDrctn);
        Build.MGenerate();

      {
      Build.MGenerate();
      build.fillTileArr(fDelta);
      Build.TileArr := Build.FRoomTileArr;
      }

      memInfo.Text := 'You went ' + drctn + ' to the ' + IntToStr(Build.currLevel) + 'th floor';
      lblLevel.Caption := 'Level' + IntToStr(Build.currLevel);
      brushcolor();

      With Build do
      Begin
        rWidth := fW;
        rHeight := fH;
        DetermRoom(Build.FMArr);

        fillTileArr(fDelta);
        Build.TileArr := Build.FFillTileArr;
        //xPl := fW-1;
        //yPl := fH-1;
        //determTile(fXPlayer, fYPlayer); // Нужно ли это делать ещё раз
        FKey := '0';
        //FCanMove := False;
      End;

        fRoomWay := False;
        fStairsWay := False;
        fElevWay := False;
        checkbRoom.Checked := False;
        checkbStairs.Checked := False;
        checkbElevator.Checked := False;

        FCanChangeLoc := False;
        fPaintRoom := false;
        fPaintMaze := true;
      End// If not gEnd
      Else
      If Build.currLevel = 1 then
      Begin
        frmGame.Color := clBlack;
        btnDetermLocation.Enabled := False;
        frmGame.ActiveControl := btnStart;
        fPaintRoom := false;
        fPaintMaze := false;
        memInfo.Text := 'Congratulations, you have left the ship!!!';
        Invalidate;
      End
      Else
      Begin
        gEnd := False;
        memInfo.Text := 'This is the last floor. It is impossible to climb higher';
      End;
    End;
    {3,5:
    Begin
      NextDrctn := 1;
      Build.DetermNextLevel(NextDrctn);
      fPaintMaze := true;
      fPaintRoom := false;
    End;    }
    6:
    Begin
      Build.FKey := '0';
      Case Build.rColor of
      0:
        Build.FDetrmdR := 'Room';
      1:
        Build.FDetrmdR := 'Prison';
      2:
        Build.FDetrmdR := 'Lab';
      End;
      memInfo.Text := 'You are in the ' + Build.FDetrmdR;
      //Build.FillRoomTileArr(fRoomDelta);
      Build.TileArr := Build.FRoomTileArr;
      build.ChooseTileSize(build.fRoomTileSize);

      //Build.GoToMazeCrdnt(build.fTileSize,5,5);
      build.fXPlayer := 22*build.fTileSize;
      build.fYPlayer := 22*build.fTileSize;

      fRoomWay := False;
        fStairsWay := False;
        fElevWay := False;
        checkbRoom.Checked := False;
        checkbStairs.Checked := False;
      checkbElevator.Checked := False;
      checkbRoom.Enabled := False;
      checkbStairs.Enabled := False;
      checkbElevator.Enabled := False;

      FCanChangeLoc := False;
      fPaintMaze := false;
      fPaintRoom := true;
     // Build.FCanMove := False;

      {
      build.fillTileArr(fDelta);
  With Build do
  Begin
    xPl := fW-1;
    yPl := fH-1;
    determTile(fXPlayer, fYPlayer);
    //ShowMessage(IntToStr(fXPlayer) +' '+ IntToStr(fYPlayer));
    FKey := '0';

    FCanMove := True;
      }
    End;
    7: // Выход из комнаты
    Begin
      Build.FKey := '0';
      Build.TileArr := Build.FFillTileArr;
      build.ChooseTileSize(build.fMazeTileSize);
      Build.GoToMazeCrdnt(build.fTileSize, Build.rHeight, Build.rWidth);  // ИЗМЕНИТЬ КООРДИНАТУ ПРИ ПЕРЕХОДЕ В КОМНАТУ

      checkbRoom.Enabled := True;
      checkbStairs.Enabled := True;
      checkbElevator.Enabled := True;

      FCanChangeLoc := False;
      fPaintMaze := true;
      fPaintRoom := false;
    End;
  End;//Case
End;


procedure TfrmGame.btnDetermLocationKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Build.FKey <> chr(Key) then
  Begin
  Build.FKey := chr(Key);
  With Build do
  Begin
  Case chr(Key) of      //fRightOrDown  fVertical
    'W':
    Begin
      fRightOrDown := -1;
      fVertical := True;
    End;
    'D':
    Begin
      fRightOrDown := 1;
      fVertical := False;
    End;
    'S':
    Begin
      fRightOrDown := 1;
      fVertical := True;
    End;
    'A':
    Begin
      fRightOrDown := -1;
      fVertical := False;
    End;
  End;//Case
  End;//With
  Build.walk(Build.fXPlayer,Build.fYPlayer);
  End //If
  Else
  Begin
  End;

  build.move();
  If (not Build.FCanMove) and (FCanChangeLoc) then                  //FCanMove - отвечает за то, пе
    DtrmNextLoc(Sender);
  Invalidate;

  //ShowMessage(IntToStr(Build.fXPlayer) + #13#10 + IntToStr(Build.fYPlayer));
  //ShowMessage(IntToStr(Build.fMoveDistance));
end;

procedure TfrmGame.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  Invalidate;
end;

procedure TfrmGame.btnDetermLocationKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FCanChangeLoc := True;
end;

procedure TfrmGame.checkbRoomClick(Sender: TObject);
begin
  fRoomWay := checkbRoom.Checked;
  If fRoomWay then
  Begin
    Build.PrepareExit(fDelta,Build.rWidth, Build.rHeight);
    Build.EFinding();
  End;
  frmGame.ActiveControl := btnDetermLocation;
end;

procedure TfrmGame.checkbStairsClick(Sender: TObject);
begin
  fStairsWay := checkbStairs.Checked;
  If fStairsWay then
  Begin
    If Build.currLevel mod 2 = 0 then
    Begin
      Build.PrepareExit(fDelta,0, 0);
    End
    Else
    Begin
      Build.PrepareExit(fDelta,FW-1,0);
    End;
    Build.EFinding();
  End;
  frmGame.ActiveControl := btnDetermLocation;
end;

procedure TfrmGame.checkbElevatorClick(Sender: TObject);
begin
  fElevWay := checkbElevator.Checked;
  If fElevWay then
  Begin
    If Build.currLevel mod 2 = 0 then
    Begin
      Build.PrepareExit(fDelta,0, fH-1);
    End
    Else
    Begin
      Build.PrepareExit(fDelta,FW-1,fH-1);
    End;
    Build.EFinding();
  End;
  frmGame.ActiveControl := btnDetermLocation;
end;

end.
