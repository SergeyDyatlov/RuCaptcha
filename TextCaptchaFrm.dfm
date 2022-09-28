object TextCaptchaFrame: TTextCaptchaFrame
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
  object edtTextCaptcha: TEdit
    Left = 225
    Top = 287
    Width = 350
    Height = 26
    TabOrder = 0
    Text = #1045#1089#1083#1080' '#1079#1072#1074#1090#1088#1072' '#1089#1091#1073#1073#1086#1090#1072', '#1090#1086' '#1082#1072#1082#1086#1081' '#1089#1077#1075#1086#1076#1085#1103' '#1076#1077#1085#1100'?'
  end
  object btnSolveTextCaptcha: TButton
    Left = 447
    Top = 327
    Width = 128
    Height = 32
    Caption = #1056#1072#1079#1075#1072#1076#1072#1090#1100
    TabOrder = 1
    OnClick = btnSolveTextCaptchaClick
  end
end
