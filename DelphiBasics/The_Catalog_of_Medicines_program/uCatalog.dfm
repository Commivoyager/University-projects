object frmCatalog: TfrmCatalog
  Left = 500
  Top = 364
  AutoScroll = False
  Caption = #1050#1072#1090#1072#1083#1086#1075
  ClientHeight = 419
  ClientWidth = 592
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 480
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 274
    Top = 0
    Height = 419
  end
  object pnlActions: TPanel
    Left = 464
    Top = 0
    Width = 128
    Height = 419
    Align = alRight
    Constraints.MinWidth = 120
    TabOrder = 0
    DesignSize = (
      128
      419)
    object btnAdd: TButton
      Left = 7
      Top = 88
      Width = 114
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 0
      OnClick = btnAddClick
    end
    object btnExit: TButton
      Left = 7
      Top = 392
      Width = 114
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      TabOrder = 1
      OnClick = btnExitClick
    end
    object btnRestore: TButton
      Left = 7
      Top = 120
      Width = 114
      Height = 25
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' '#1087#1088#1077#1076#1099#1076#1091#1097#1077#1075#1086' '#1091#1076#1072#1083#1105#1085#1085#1086#1075#1086' '#1087#1088#1077#1087#1072#1088#1072#1090#1072
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnRestoreClick
    end
    object edtSearch: TEdit
      Left = 0
      Top = 0
      Width = 125
      Height = 21
      TabOrder = 3
    end
    object btnSearch: TButton
      Left = 7
      Top = 24
      Width = 114
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Caption = #1055#1086#1080#1089#1082
      TabOrder = 4
      OnClick = btnSearchClick
    end
    object btnAll: TButton
      Left = 7
      Top = 56
      Width = 114
      Height = 25
      Caption = #1042#1077#1089#1100' '#1082#1072#1090#1072#1083#1086#1075
      TabOrder = 5
      OnClick = btnAllClick
    end
    object phlChoice: TPanel
      Left = 7
      Top = 152
      Width = 114
      Height = 233
      BorderWidth = 3
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      object lblTitleSort: TLabel
        Left = 8
        Top = 16
        Width = 97
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1102':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object lblCategoruSort: TLabel
        Left = 8
        Top = 80
        Width = 89
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1102':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object lblCostSort: TLabel
        Left = 8
        Top = 144
        Width = 89
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1080':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object lblSortChoice: TLabel
        Left = 8
        Top = 0
        Width = 97
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1087#1086':'
        Layout = tlCenter
      end
      object rbtnTitleUp: TRadioButton
        Tag = 1
        Left = 5
        Top = 32
        Width = 89
        Height = 17
        Caption = #1055#1086' '#1072#1083#1092#1072#1074#1080#1090#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = rbtnClick
      end
      object rbtnTitleDown: TRadioButton
        Tag = 2
        Left = 5
        Top = 56
        Width = 89
        Height = 17
        Caption = #1054#1073#1088#1072#1090#1085#1086
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = rbtnClick
      end
      object rbtnCategoryDown: TRadioButton
        Tag = 4
        Left = 5
        Top = 120
        Width = 89
        Height = 17
        Caption = #1054#1073#1088#1072#1090#1085#1086
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = rbtnClick
      end
      object rbtnCostUp: TRadioButton
        Tag = 5
        Left = 5
        Top = 160
        Width = 104
        Height = 17
        Caption = #1055#1086' '#1074#1086#1079#1088#1072#1089#1090#1072#1085#1080#1102
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = rbtnClick
      end
      object rbtnCostDown: TRadioButton
        Tag = 6
        Left = 5
        Top = 184
        Width = 89
        Height = 17
        Caption = #1055#1086' '#1091#1073#1099#1074#1072#1085#1080#1102
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = rbtnClick
      end
      object rbtnCategoryUp: TRadioButton
        Tag = 3
        Left = 5
        Top = 96
        Width = 92
        Height = 17
        Caption = #1055#1086' '#1072#1083#1092#1072#1074#1080#1090#1091
        TabOrder = 5
        OnClick = rbtnClick
      end
      object btnSortList: TButton
        Left = 8
        Top = 205
        Width = 97
        Height = 22
        Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100
        Enabled = False
        TabOrder = 6
        OnClick = btnSortListClick
      end
    end
  end
  object scrBList: TScrollBox
    Left = 0
    Top = 0
    Width = 274
    Height = 419
    Align = alLeft
    Anchors = [akLeft, akTop, akRight, akBottom]
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    TabOrder = 1
  end
  object pnlDrugInfo: TPanel
    Left = 277
    Top = 0
    Width = 187
    Height = 419
    Align = alClient
    Constraints.MinWidth = 140
    TabOrder = 2
    DesignSize = (
      187
      419)
    object lblMainCategory: TLabel
      Left = 8
      Top = 248
      Width = 164
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Color = clCream
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNone
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    object lblMainCategotyTitle: TLabel
      Left = 8
      Top = 225
      Width = 113
      Height = 24
      AutoSize = False
      Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1077':'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNone
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    object lblMainCost: TLabel
      Left = 8
      Top = 304
      Width = 105
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Color = clCream
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNone
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    object lblMainCostTitle: TLabel
      Left = 8
      Top = 281
      Width = 105
      Height = 24
      AutoSize = False
      Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNone
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    object memDrugInfo: TMemo
      Left = 1
      Top = 25
      Width = 185
      Height = 184
      Align = alTop
      BorderStyle = bsNone
      Color = clCream
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object pnlMainTitle: TPanel
      Left = 1
      Top = 1
      Width = 185
      Height = 24
      Align = alTop
      Alignment = taLeftJustify
      TabOrder = 1
      object lblMainTitle: TLabel
        Left = 73
        Top = 1
        Width = 280
        Height = 22
        AutoSize = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNone
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Layout = tlCenter
      end
    end
    object btnDelete: TButton
      Left = 8
      Top = 344
      Width = 97
      Height = 25
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Enabled = False
      TabOrder = 2
      OnClick = btnDeleteClick
    end
    object btnEdit: TButton
      Left = 8
      Top = 384
      Width = 97
      Height = 25
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
      Enabled = False
      TabOrder = 3
      OnClick = btnEditClick
    end
  end
end
