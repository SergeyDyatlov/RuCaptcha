object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MainForm'
  ClientHeight = 658
  ClientWidth = 408
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 18
  object Label2: TLabel
    Left = 16
    Top = 10
    Width = 128
    Height = 18
    Caption = 'RuCaptcha API Key'
  end
  object lblShowBalance: TLabel
    Left = 339
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
    OnClick = lblShowBalanceClick
  end
  object edtCaptchaKey: TEdit
    Left = 16
    Top = 35
    Width = 373
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
  object edtCaptchaId: TEdit
    Left = 16
    Top = 605
    Width = 153
    Height = 26
    TabOrder = 1
  end
  object btnSendReport: TButton
    Left = 257
    Top = 602
    Width = 136
    Height = 32
    Caption = #1055#1086#1078#1072#1083#1086#1074#1072#1090#1100#1089#1103
    TabOrder = 2
    OnClick = btnSendReportClick
  end
  object PageControl1: TPageControl
    Left = 16
    Top = 78
    Width = 377
    Height = 518
    ActivePage = TabSheet1
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = #1054#1073#1099#1095#1085#1099#1077' '#1082#1072#1087#1095#1080
      object Label1: TLabel
        Left = 10
        Top = 17
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
        Left = 10
        Top = 56
        Width = 351
        Height = 209
        Center = True
        Proportional = True
      end
      object Button1: TButton
        Left = 194
        Top = 12
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
      object btnSolveSimpleCaptcha: TButton
        Left = 233
        Top = 278
        Width = 128
        Height = 32
        Caption = #1056#1072#1079#1075#1072#1076#1072#1090#1100
        TabOrder = 1
        OnClick = btnSolveSimpleCaptchaClick
      end
      object edtCaptchaResult: TEdit
        Left = 10
        Top = 281
        Width = 207
        Height = 26
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        TextHint = #1056#1077#1079#1091#1083#1100#1090#1072#1090
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1082#1072#1087#1095#1080
      ImageIndex = 1
      object edtTextCaptcha: TEdit
        Left = 11
        Top = 16
        Width = 350
        Height = 26
        TabOrder = 0
        Text = #1045#1089#1083#1080' '#1079#1072#1074#1090#1088#1072' '#1089#1091#1073#1073#1086#1090#1072', '#1090#1086' '#1082#1072#1082#1086#1081' '#1089#1077#1075#1086#1076#1085#1103' '#1076#1077#1085#1100'?'
      end
      object btnSolveTextCaptcha: TButton
        Left = 233
        Top = 55
        Width = 128
        Height = 32
        Caption = #1056#1072#1079#1075#1072#1076#1072#1090#1100
        TabOrder = 1
        OnClick = btnSolveTextCaptchaClick
      end
      object edtTextCaptchaResult: TEdit
        Left = 11
        Top = 58
        Width = 206
        Height = 26
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        TextHint = #1056#1077#1079#1091#1083#1100#1090#1072#1090
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'ReCaptchaV2'
      ImageIndex = 2
      object WebBrowser1: TWebBrowser
        Left = 0
        Top = 41
        Width = 369
        Height = 403
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 120
        ExplicitTop = 96
        ExplicitWidth = 300
        ExplicitHeight = 150
        ControlData = {
          4C00000023260000A72900000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 369
        Height = 41
        Align = alTop
        TabOrder = 1
        object edtURL: TEdit
          Left = 10
          Top = 8
          Width = 283
          Height = 26
          TabOrder = 0
          Text = 'https://www.google.com/recaptcha/api2/demo'
        end
        object btnGo: TButton
          Left = 299
          Top = 8
          Width = 50
          Height = 27
          Caption = 'Go'
          TabOrder = 1
          OnClick = btnGoClick
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 444
        Width = 369
        Height = 41
        Align = alBottom
        TabOrder = 2
        ExplicitTop = 547
        object btnSolveReCaptchaV2: TButton
          Left = 233
          Top = -2
          Width = 128
          Height = 32
          Caption = #1056#1072#1079#1075#1072#1076#1072#1090#1100
          TabOrder = 0
          OnClick = btnSolveReCaptchaV2Click
        end
      end
    end
  end
  object OpenPictureDialog1: TOpenPictureDialog
    FilterIndex = 0
    Left = 328
    Top = 35
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 48
    Top = 32
  end
end
