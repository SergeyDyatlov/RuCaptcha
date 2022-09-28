unit MainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ExtDlgs, JPEG, Vcl.ComCtrls, Vcl.OleCtrls,
  SHDocVw, IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze, RuCaptcha,
  System.Actions, Vcl.ActnList, HCaptchaFrm, ReCaptchaFrm, TextCaptchaFrm;

type
  TMainForm = class(TForm)
    edtAPIKey: TEdit;
    Label2: TLabel;
    lblShowBalance: TLabel;
    edtCaptchaId: TEdit;
    btnReportBad: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Image1: TImage;
    Button1: TButton;
    btnSolveSimpleCaptcha: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
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
    procedure Button1Click(Sender: TObject);
    procedure btnSolveSimpleCaptchaClick(Sender: TObject);
    procedure lblShowBalanceClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actReportBadExecute(Sender: TObject);
    procedure actReportGoodExecute(Sender: TObject);
    procedure edtAPIKeyChange(Sender: TObject);
  private
    { Private declarations }
    FRuCaptcha: TRuCaptcha;
    FFileName: string;
  public
    { Public declarations }
    property RuCaptcha: TRuCaptcha read FRuCaptcha;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  SimpleCaptcha, TextCaptcha, WBUtils, MSHTML, System.Threading;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
  begin
    FFileName := OpenPictureDialog1.FileName;
    Image1.Picture.LoadFromFile(FFileName);
  end;
end;

procedure TMainForm.edtAPIKeyChange(Sender: TObject);
begin
  FRuCaptcha.APIKey := edtAPIKey.Text;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FRuCaptcha := TRuCaptcha.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FRuCaptcha.Free;
end;

procedure TMainForm.btnSolveSimpleCaptchaClick(Sender: TObject);
begin
  edtCaptchaId.Text := EmptyStr;
  edtCaptchaAnswer.Text := EmptyStr;
  btnSolveSimpleCaptcha.Enabled := False;

  TTask.Run(
    procedure
    var
      Captcha: TSimpleCaptcha;
    begin
      Captcha := TSimpleCaptcha.Create(FFileName);
      try
        FRuCaptcha.SolveCaptcha(Captcha);
      finally
        TThread.Synchronize(TThread.Current,
          procedure
          begin
            edtCaptchaId.Text := Captcha.Id;
            edtCaptchaAnswer.Text := Captcha.Answer;
            btnSolveSimpleCaptcha.Enabled := True;
          end);

        Captcha.Free;
      end;
    end);
end;

procedure TMainForm.actReportBadExecute(Sender: TObject);
begin
  FRuCaptcha.ReportBad(edtCaptchaId.Text);
end;

procedure TMainForm.actReportGoodExecute(Sender: TObject);
begin
  FRuCaptcha.ReportGood(edtCaptchaId.Text);
end;

procedure TMainForm.lblShowBalanceClick(Sender: TObject);
begin
  ShowMessage(FRuCaptcha.Balance);
end;

end.
