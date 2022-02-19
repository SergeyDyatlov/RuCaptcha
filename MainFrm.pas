unit MainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ExtDlgs, JPEG, Vcl.ComCtrls, Vcl.OleCtrls,
  SHDocVw, IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze, RuCaptcha;

type
  TMainForm = class(TForm)
    edtAPIKey: TEdit;
    Label2: TLabel;
    lblShowBalance: TLabel;
    edtCaptchaId: TEdit;
    btnSendReport: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Image1: TImage;
    Button1: TButton;
    btnSolveSimpleCaptcha: TButton;
    edtCaptchaResult: TEdit;
    OpenPictureDialog1: TOpenPictureDialog;
    TabSheet2: TTabSheet;
    edtTextCaptcha: TEdit;
    btnSolveTextCaptcha: TButton;
    edtTextCaptchaResult: TEdit;
    TabSheet3: TTabSheet;
    WebBrowser1: TWebBrowser;
    Panel1: TPanel;
    edtURL: TEdit;
    btnGo: TButton;
    Panel2: TPanel;
    btnSolveReCaptchaV2: TButton;
    IdAntiFreeze1: TIdAntiFreeze;
    procedure Button1Click(Sender: TObject);
    procedure btnSolveSimpleCaptchaClick(Sender: TObject);
    procedure lblShowBalanceClick(Sender: TObject);
    procedure btnSendReportClick(Sender: TObject);
    procedure btnSolveTextCaptchaClick(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure btnSolveReCaptchaV2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FRuCaptcha: TRuCaptcha;
    FFileName: string;
  public
    { Public declarations }
    function GetElementById(const Document: IDispatch; ElementId: string)
      : IDispatch;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  SimpleCaptcha, TextCaptcha, ReCaptcha, MSHTML, System.Threading;

procedure TMainForm.btnSolveReCaptchaV2Click(Sender: TObject);
var
  GoogleKey: string;
  CaptchaResult: string;
  Element: IDispatch;
  PageURL: string;
begin
  btnSolveReCaptchaV2.Enabled := False;
  Element := GetElementById(WebBrowser1.Document, 'recaptcha-demo');
  GoogleKey := (Element as IHTMLElement).getAttribute('data-sitekey', 0);
  PageURL := WebBrowser1.LocationURL;
  FRuCaptcha.APIKey := edtAPIKey.Text;

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

            edtCaptchaId.Text := Captcha.Id;
            btnSolveReCaptchaV2.Enabled := True;
          end);

        Captcha.Free;
      end;
    end);
end;

procedure TMainForm.btnSolveTextCaptchaClick(Sender: TObject);
begin
  btnSolveTextCaptcha.Enabled := False;
  FRuCaptcha.APIKey := edtAPIKey.Text;

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
            edtTextCaptchaResult.Text := Captcha.Answer;
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
  btnSolveSimpleCaptcha.Enabled := False;
  FRuCaptcha.APIKey := edtAPIKey.Text;

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
            edtCaptchaResult.Text := Captcha.Answer;
            edtCaptchaId.Text := Captcha.Id;
            btnSolveSimpleCaptcha.Enabled := True;
          end);

        Captcha.Free;
      end;
    end);
end;

procedure TMainForm.btnSendReportClick(Sender: TObject);
begin
  FRuCaptcha.SendReport(edtCaptchaId.Text);
end;

procedure TMainForm.btnGoClick(Sender: TObject);
begin
  WebBrowser1.Navigate(edtURL.Text);
end;

function TMainForm.GetElementById(const Document: IDispatch; ElementId: string)
  : IDispatch;
begin
  Result := (Document as IHTMLDocument3).GetElementById(ElementId);
end;

procedure TMainForm.lblShowBalanceClick(Sender: TObject);
begin
  FRuCaptcha.APIKey := edtAPIKey.Text;
  ShowMessage(FRuCaptcha.Balance);
end;

end.
