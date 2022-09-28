object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MainForm'
  ClientHeight = 773
  ClientWidth = 831
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
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
    Left = 731
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
  object lblCaptchaAnswer: TLabel
    Left = 20
    Top = 694
    Width = 178
    Height = 18
    Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090' '#1088#1072#1089#1087#1086#1079#1085#1072#1074#1072#1085#1080#1103
  end
  object lblCaptchaId: TLabel
    Left = 439
    Top = 697
    Width = 109
    Height = 18
    Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
  end
  object edtAPIKey: TEdit
    Left = 16
    Top = 35
    Width = 373
    Height = 27
    Hint = '786cc5c7e99f51ac5725d122e95d1e02'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnChange = edtAPIKeyChange
  end
  object edtCaptchaId: TEdit
    Left = 439
    Top = 721
    Width = 145
    Height = 26
    TabOrder = 1
  end
  object btnReportBad: TButton
    Left = 711
    Top = 718
    Width = 105
    Height = 32
    Action = actReportBad
    TabOrder = 2
  end
  object PageControl1: TPageControl
    Left = 16
    Top = 78
    Width = 800
    Height = 600
    ActivePage = TabSheet4
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = #1054#1073#1099#1095#1085#1099#1077' '#1082#1072#1087#1095#1080
      object Label1: TLabel
        Left = 205
        Top = 97
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
        Left = 205
        Top = 138
        Width = 351
        Height = 209
        Center = True
        Proportional = True
      end
      object Button1: TButton
        Left = 428
        Top = 92
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
        Left = 428
        Top = 361
        Width = 128
        Height = 32
        Caption = #1056#1072#1079#1075#1072#1076#1072#1090#1100
        TabOrder = 1
        OnClick = btnSolveSimpleCaptchaClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1082#1072#1087#1095#1080
      ImageIndex = 1
      object edtTextCaptcha: TEdit
        Left = 205
        Top = 229
        Width = 350
        Height = 26
        TabOrder = 0
        Text = #1045#1089#1083#1080' '#1079#1072#1074#1090#1088#1072' '#1089#1091#1073#1073#1086#1090#1072', '#1090#1086' '#1082#1072#1082#1086#1081' '#1089#1077#1075#1086#1076#1085#1103' '#1076#1077#1085#1100'?'
      end
      object btnSolveTextCaptcha: TButton
        Left = 427
        Top = 271
        Width = 128
        Height = 32
        Caption = #1056#1072#1079#1075#1072#1076#1072#1090#1100
        TabOrder = 1
        OnClick = btnSolveTextCaptchaClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'ReCaptchaV2'
      ImageIndex = 2
      inline ReCaptchaFrame1: TReCaptchaFrame
        Left = 0
        Top = 0
        Width = 792
        Height = 567
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        inherited WebBrowser1: TWebBrowser
          ControlData = {
            4C000000092300001A2800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'hCaptcha'
      ImageIndex = 3
      inline HCaptchaFrame1: THCaptchaFrame
        Left = 0
        Top = 0
        Width = 792
        Height = 567
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        ExplicitLeft = 64
        ExplicitTop = 17
        ExplicitWidth = 792
        ExplicitHeight = 567
        inherited WebBrowser1: TWebBrowser
          ControlData = {
            4C000000092300001A2800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
    end
  end
  object edtCaptchaAnswer: TEdit
    Left = 20
    Top = 721
    Width = 297
    Height = 26
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    TextHint = #1056#1077#1079#1091#1083#1100#1090#1072#1090
  end
  object btnReportGood: TButton
    Left = 600
    Top = 718
    Width = 105
    Height = 32
    Action = actReportGood
    TabOrder = 5
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
  object ActionList1: TActionList
    Left = 336
    Top = 600
    object actReportBad: TAction
      Caption = #1055#1083#1086#1093#1086
      OnExecute = actReportBadExecute
    end
    object actReportGood: TAction
      Caption = #1061#1086#1088#1086#1096#1086
      OnExecute = actReportGoodExecute
    end
  end
end
