unit MainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ExtDlgs, JPEG, Vcl.ComCtrls, Vcl.OleCtrls,
  SHDocVw, IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze, RuCaptcha,
  System.Actions, Vcl.ActnList, HCaptchaFrm;

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
    edtTextCaptcha: TEdit;
    btnSolveTextCaptcha: TButton;
    TabSheet3: TTabSheet;
    WebBrowser1: TWebBrowser;
    IdAntiFreeze1: TIdAntiFreeze;
    edtCaptchaAnswer: TEdit;
    btnReportGood: TButton;
    lblCaptchaAnswer: TLabel;
    lblCaptchaId: TLabel;
    ActionList1: TActionList;
    actReportGood: TAction;
    actReportBad: TAction;
    edtURL: TEdit;
    btnGo: TButton;
    btnSolveReCaptchaV2: TButton;
    TabSheet4: TTabSheet;
    HCaptchaFrame1: THCaptchaFrame;
    procedure Button1Click(Sender: TObject);
    procedure btnSolveSimpleCaptchaClick(Sender: TObject);
    procedure lblShowBalanceClick(Sender: TObject);
    procedure btnSolveTextCaptchaClick(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure btnSolveReCaptchaV2Click(Sender: TObject);
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
  SimpleCaptcha, TextCaptcha, ReCaptcha, WBUtils, MSHTML, System.Threading;

procedure TMainForm.btnSolveReCaptchaV2Click(Sender: TObject);
var
  GoogleKey: string;
  Element: IDispatch;
  PageURL: string;
begin
  edtCaptchaAnswer.Text := EmptyStr;
  edtCaptchaId.Text := EmptyStr;
  btnSolveReCaptchaV2.Enabled := False;

  Element := GetElementById(WebBrowser1.Document, 'recaptcha-demo');
  GoogleKey := (Element as IHTMLElement).getAttribute('data-sitekey', 0);
  PageURL := WebBrowser1.LocationURL;

  TTask.Run(
    procedure
    var
      Captcha: TReCaptcha;
    begin
      Captcha := TReCaptcha.Create(GoogleKey, PageURL);
      try
        FRuCaptcha.SolveCaptcha(Captcha);
      finally
        TThread.Synchronize(TThread.Current,
          procedure
          begin
            Element := GetElementById(WebBrowser1.Document,
              'g-recaptcha-response');
            (Element as IHTMLTextAreaElement).Value := Captcha.Answer;

            Element := GetElementById(WebBrowser1.Document,
              'recaptcha-demo-submit');
            (Element as IHTMLElement).click;

            edtCaptchaAnswer.Text := Captcha.Answer;
            edtCaptchaId.Text := Captcha.Id;
            btnSolveReCaptchaV2.Enabled := True;
          end);

        Captcha.Free;
      end;
    end);
end;

procedure TMainForm.btnSolveTextCaptchaClick(Sender: TObject);
begin
  edtCaptchaAnswer.Text := EmptyStr;
  edtCaptchaId.Text := EmptyStr;
  btnSolveTextCaptcha.Enabled := False;

  TTask.Run(
    procedure
    var
      Captcha: TTextCaptcha;
    begin
      Captcha := TTextCaptcha.Create(edtTextCaptcha.Text);
      try
        Captcha.Lang := 'ru';
        FRuCaptcha.SolveCaptcha(Captcha);
      finally
        TThread.Synchronize(TThread.Current,
          procedure
          begin
            edtCaptchaAnswer.Text := Captcha.Answer;
            edtCaptchaId.Text := Captcha.Id;
            btnSolveTextCaptcha.Enabled := True;
          end);

        Captcha.Free;
      end;
    end);
end;

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
  edtCaptchaAnswer.Text := EmptyStr;
  edtCaptchaId.Text := EmptyStr;
  btnSolveSimpleCaptcha.Enabled := False;

  TTask.Run(
    procedure
    var
      Captcha: TSimpleCaptcha;
    begin
      Captcha := TSimpleCaptcha.Create(FFileName);
      try
        try
          FRuCaptcha.SolveCaptcha(Captcha);
        except
          on E: Exception do
          begin
            TThread.Synchronize(TThread.Current,
              procedure
              begin
                Application.ShowException(E);
              end);
          end;
        end;
      finally
        TThread.Synchronize(TThread.Current,
          procedure
          begin
            edtCaptchaAnswer.Text := Captcha.Answer;
            edtCaptchaId.Text := Captcha.Id;
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

procedure TMainForm.btnGoClick(Sender: TObject);
begin
  WebBrowser1.Navigate(edtURL.Text);
end;

procedure TMainForm.lblShowBalanceClick(Sender: TObject);
begin
  FRuCaptcha.APIKey := edtAPIKey.Text;
  ShowMessage(FRuCaptcha.Balance);
end;

end.
