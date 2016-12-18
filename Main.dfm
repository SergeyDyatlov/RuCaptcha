object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 427
  ClientWidth = 331
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 19
  object Label1: TLabel
    Left = 16
    Top = 77
    Width = 143
    Height = 19
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1082#1072#1088#1090#1080#1085#1082#1091
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Image1: TImage
    Left = 16
    Top = 115
    Width = 297
    Height = 201
    Center = True
    Proportional = True
  end
  object Label2: TLabel
    Left = 16
    Top = 10
    Width = 136
    Height = 19
    Caption = 'RuCaptcha API Key'
  end
  object Label3: TLabel
    Left = 263
    Top = 10
    Width = 50
    Height = 19
    Cursor = crHandPoint
    Caption = #1041#1072#1083#1072#1085#1089
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label3Click
  end
  object Edit1: TEdit
    Left = 16
    Top = 35
    Width = 297
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = '786cc5c7e99f51ac5725d122e95d1e02'
  end
  object Button1: TButton
    Left = 185
    Top = 72
    Width = 128
    Height = 32
    Caption = #1054#1073#1079#1086#1088
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 185
    Top = 331
    Width = 128
    Height = 32
    Caption = #1056#1072#1079#1075#1072#1076#1072#1090#1100
    TabOrder = 2
    OnClick = Button2Click
  end
  object Edit2: TEdit
    Left = 16
    Top = 333
    Width = 153
    Height = 27
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 3
    TextHint = #1054#1090#1074#1077#1090
  end
  object Edit3: TEdit
    Left = 16
    Top = 384
    Width = 153
    Height = 27
    TabOrder = 4
  end
  object Button3: TButton
    Left = 185
    Top = 382
    Width = 128
    Height = 32
    Caption = #1055#1086#1078#1072#1083#1086#1074#1072#1090#1100#1089#1103
    TabOrder = 5
    OnClick = Button3Click
  end
  object OpenPictureDialog1: TOpenPictureDialog
    FilterIndex = 0
    Left = 56
    Top = 131
  end
end
