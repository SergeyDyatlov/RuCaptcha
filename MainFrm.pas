unit MainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ExtDlgs, JPEG, Vcl.ComCtrls, Vcl.OleCtrls,
  SHDocVw, IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze, RuCaptcha,
  System.Actions, Vcl.ActnList, HCaptchaFrm, ReCaptchaFrm, TextCaptchaFrm,
  SimpleCaptchaFrm;

type
  TMainForm = class(TForm)
    edtAPIKey: TEdit;
    Label2: TLabel;
    lblBalance: TLabel;
    edtCaptchaId: TEdit;
    btnReportBad: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    IdAntiFreeze1: TIdAntiFreeze;
    edtCaptchaAnswer: TEdit;
    btnReportGood: TButton;
    lblCaptchaAnswer: TLabel;
    lblCaptchaId: TLabel;
    ActionList1: TActionList;
    actReportGood: TAction;
    actReportBad: TAction;
    TabSheet4: TTabSheet;
    HCaptchaFrame1: THCaptchaFrame;
    ReCaptchaFrame1: TReCaptchaFrame;
    TextCaptchaFrame1: TTextCaptchaFrame;
    SimpleCaptchaFrame1: TSimpleCaptchaFrame;
    procedure lblBalanceClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actReportBadExecute(Sender: TObject);
    procedure actReportGoodExecute(Sender: TObject);
    procedure edtAPIKeyChange(Sender: TObject);
  private
    { Private declarations }
    FRuCaptcha: TRuCaptcha;
  public
    { Public declarations }
    property RuCaptcha: TRuCaptcha read FRuCaptcha;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.edtAPIKeyChange(Sender: TObject);
begin
  FRuCaptcha.APIKey := edtAPIKey.Text;
  lblBalance.OnClick(Sender);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FRuCaptcha := TRuCaptcha.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FRuCaptcha.Free;
end;

procedure TMainForm.actReportBadExecute(Sender: TObject);
begin
  FRuCaptcha.ReportBad(edtCaptchaId.Text);
end;

procedure TMainForm.actReportGoodExecute(Sender: TObject);
begin
  FRuCaptcha.ReportGood(edtCaptchaId.Text);
end;

procedure TMainForm.lblBalanceClick(Sender: TObject);
begin
  lblBalance.Caption := Format('Баланс: %s', [FRuCaptcha.Balance]);
end;

end.
