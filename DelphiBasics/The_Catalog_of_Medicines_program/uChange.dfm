object fAdding: TfAdding
  Left = 496
  Top = 324
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1087#1088#1077#1087#1072#1088#1072#1090#1072
  ClientHeight = 419
  ClientWidth = 492
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblTitle: TLabel
    Left = 24
    Top = 32
    Width = 192
    Height = 24
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1088#1077#1087#1072#1088#1072#1090#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblDescription: TLabel
    Left = 24
    Top = 88
    Width = 262
    Height = 24
    Caption = #1054#1073#1097#1077#1077' '#1086#1087#1080#1089#1072#1085#1080#1077' '#1087#1088#1077#1087#1072#1088#1072#1090#1072': '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblCost: TLabel
    Left = 24
    Top = 320
    Width = 210
    Height = 24
    Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1087#1088#1077#1087#1072#1088#1072#1090#1072': '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblCategory: TLabel
    Left = 24
    Top = 264
    Width = 213
    Height = 24
    Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1077' '#1087#1088#1077#1087#1072#1088#1072#1090#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object edtTitle: TEdit
    Left = 248
    Top = 32
    Width = 225
    Height = 32
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object memDescription: TMemo
    Left = 24
    Top = 112
    Width = 449
    Height = 129
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object edtCost: TEdit
    Left = 248
    Top = 320
    Width = 105
    Height = 32
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object btnAddInCatalog: TButton
    Left = 288
    Top = 376
    Width = 145
    Height = 33
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    Enabled = False
    TabOrder = 3
    OnClick = btnAddInCatalogClick
  end
  object edtCategory: TEdit
    Left = 248
    Top = 264
    Width = 225
    Height = 32
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object btnClear: TButton
    Left = 8
    Top = 448
    Width = 145
    Height = 33
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1086#1083#1103
    TabOrder = 5
    OnClick = btnClearClick
  end
  object btnEditInCatalog: TButton
    Left = 72
    Top = 376
    Width = 145
    Height = 33
    Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
    Enabled = False
    TabOrder = 6
    OnClick = btnEditInCatalogClick
  end
end
