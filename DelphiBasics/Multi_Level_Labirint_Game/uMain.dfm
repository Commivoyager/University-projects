object frmGame: TfrmGame
  Left = 396
  Top = 5
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Game'
  ClientHeight = 803
  ClientWidth = 1009
  Color = clBlack
  Constraints.MinHeight = 770
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnMouseUp = FormMouseUp
  OnPaint = FormPaint
  PixelsPerInch = 120
  TextHeight = 16
  object pnlSettings: TPanel
    Left = 754
    Top = 0
    Width = 255
    Height = 803
    Align = alRight
    Color = clGradientActiveCaption
    Ctl3D = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Serif'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    object lblLevel: TLabel
      Left = 1
      Top = 1
      Width = 253
      Height = 67
      Align = alTop
      Alignment = taCenter
      Caption = 'Maze'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -67
      Font.Name = 'MS PGothic'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
      Layout = tlBottom
    end
    object lblnameInfo: TLabel
      Left = 8
      Top = 80
      Width = 45
      Height = 29
      Caption = 'Info:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -25
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object cbWalls: TComboBox
      Left = 8
      Top = 320
      Width = 233
      Height = 31
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI Light'
      Font.Style = []
      ItemHeight = 23
      ParentFont = False
      TabOrder = 0
      Text = 'Choose color of walls'
      Items.Strings = (
        'Orange'
        'Yellow'
        'Green'
        'Blue'
        'Purple')
    end
    object cbRoom: TComboBox
      Left = 6
      Top = 360
      Width = 235
      Height = 31
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI Light'
      Font.Style = []
      ItemHeight = 23
      ParentFont = False
      TabOrder = 1
      Text = 'Choose color of floor'
      Items.Strings = (
        'Gray'
        'Black'
        'White')
    end
    object pnlBegin: TPanel
      Left = 1
      Top = 590
      Width = 253
      Height = 212
      Align = alBottom
      Color = clHighlight
      TabOrder = 2
      object lblWidth: TLabel
        Left = 16
        Top = 72
        Width = 133
        Height = 29
        Caption = 'Maze width: '
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -25
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object lblHeight: TLabel
        Left = 16
        Top = 120
        Width = 136
        Height = 29
        Caption = 'Maze height:'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -25
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object lblMaxLevelNum: TLabel
        Left = 16
        Top = 24
        Width = 107
        Height = 29
        Caption = 'Max level:'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -25
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object btnStart: TButton
        Left = 16
        Top = 160
        Width = 217
        Height = 33
        Caption = 'Start the game over'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -25
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnStartClick
      end
      object editWidth: TEdit
        Left = 176
        Top = 72
        Width = 57
        Height = 28
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Text = '5'
      end
      object editHeight: TEdit
        Left = 176
        Top = 122
        Width = 57
        Height = 28
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        Text = '5'
      end
      object editMaxLevelNum: TEdit
        Left = 176
        Top = 24
        Width = 57
        Height = 28
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Text = '3'
      end
    end
    object btnDetermLocation: TButton
      Left = 8
      Top = 400
      Width = 233
      Height = 41
      Caption = 'Determine location'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -25
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = btnDetermLocationClick
      OnKeyDown = btnDetermLocationKeyDown
      OnKeyUp = btnDetermLocationKeyUp
    end
    object memInfo: TMemo
      Left = 8
      Top = 104
      Width = 233
      Height = 201
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'MS UI Gothic'
      Font.Style = []
      Lines.Strings = (
        'Let'#39's start the '
        'game!'
        'Select the '
        'maximum number'
        'of levels, the size of '
        'the field and click '
        'on the "Start the '
        'game over" button')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 4
    end
    object pnlExiCheckB: TPanel
      Left = 8
      Top = 448
      Width = 233
      Height = 137
      TabOrder = 5
      object checkbElevator: TCheckBox
        Left = 8
        Top = 85
        Width = 225
        Height = 49
        Caption = 'Way to elevator'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -23
        Font.Name = 'MS Reference Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = checkbElevatorClick
      end
      object checkbStairs: TCheckBox
        Left = 8
        Top = 40
        Width = 225
        Height = 49
        Caption = 'Way to stairs'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -23
        Font.Name = 'MS Reference Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = checkbStairsClick
      end
      object checkbRoom: TCheckBox
        Left = 8
        Top = 0
        Width = 225
        Height = 41
        Caption = 'Way to room'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -23
        Font.Name = 'MS Reference Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = checkbRoomClick
      end
    end
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 32
    Top = 16
  end
end
