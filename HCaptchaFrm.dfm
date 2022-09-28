object HCaptchaFrame: THCaptchaFrame
  Left = 0
  Top = 0
  Width = 800
  Height = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object edtURL: TEdit
    Left = 230
    Top = 67
    Width = 283
    Height = 26
    TabOrder = 0
    Text = 'https://accounts.hcaptcha.com/demo'
  end
  object btnGo: TButton
    Left = 519
    Top = 67
    Width = 50
    Height = 27
    Caption = 'Go'
    TabOrder = 1
    OnClick = btnGoClick
  end
  object WebBrowser1: TWebBrowser
    Left = 230
    Top = 106
    Width = 339
    Height = 388
    Align = alCustom
    TabOrder = 2
    ControlData = {
      4C000000092300001A2800000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object btnSolveCaptcha: TButton
    Left = 441
    Top = 506
    Width = 128
    Height = 32
    Caption = #1056#1072#1079#1075#1072#1076#1072#1090#1100
    TabOrder = 3
    OnClick = btnSolveCaptchaClick
  end
end
