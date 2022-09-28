object SimpleCaptchaFrame: TSimpleCaptchaFrame
  Left = 0
  Top = 0
  Width = 800
  Height = 600
  TabOrder = 0
  object Label1: TLabel
    Left = 224
    Top = 153
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
    Left = 224
    Top = 195
    Width = 351
    Height = 209
    Center = True
    Proportional = True
  end
  object Button1: TButton
    Left = 447
    Top = 148
    Width = 128
    Height = 32
    Caption = #1054#1073#1079#1086#1088
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object btnSolveCaptcha: TButton
    Left = 447
    Top = 417
    Width = 128
    Height = 32
    Caption = #1056#1072#1079#1075#1072#1076#1072#1090#1100
    TabOrder = 1
    OnClick = btnSolveCaptchaClick
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 384
    Top = 288
  end
end
