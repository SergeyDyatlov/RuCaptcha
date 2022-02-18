unit MainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ExtDlgs, JPEG, Vcl.ComCtrls, Vcl.OleCtrls,
  SHDocVw, IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze;

type
  TMainForm = class(TForm)
    edtCaptchaKey: TEdit;
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
  private
    { Private declarations }
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
  RuCaptcha, MSHTML, System.Threading;

procedure TMainForm.btnSolveReCaptchaV2Click(Sender: TObject);
var
  GoogleKey: string;
  CaptchaResult: string;
  Element: IDispatch;
begin
  btnSolveReCaptchaV2.Enabled := False;
  Element := GetElementById(WebBrowser1.Document, 'recaptcha-demo');
  GoogleKey := (Element as IHTMLElement).getAttribute('data-sitekey', 0);
  ReCaptchaV2.CaptchaKey := edtCaptchaKey.Text;

  TTask.Run(
    procedure
    var
      CaptchaResult: string;
    begin
      try
        CaptchaResult := ReCaptchaV2.Solve(GoogleKey, WebBrowser1.LocationURL);
      finally
        TThread.Synchronize(TThread.Current,
          procedure
          begin
            Element := GetElementById(WebBrowser1.Document,
              'g-recaptcha-response');
            (Element as IHTMLTextAreaElement).Value := CaptchaResult;

            Element := GetElementById(WebBrowser1.Document,
              'recaptcha-demo-submit');
            (Element as IHTMLElement).click;
            btnSolveReCaptchaV2.Enabled := True;
          end);
      end;
    end);
end;

procedure TMainForm.btnSolveTextCaptchaClick(Sender: TObject);
begin
  btnSolveTextCaptcha.Enabled := False;
  TextCaptcha.CaptchaKey := edtCaptchaKey.Text;

  TTask.Run(
    procedure
    var
      CaptchaResult: string;
    begin
      try
        CaptchaResult := TextCaptcha.Solve(edtTextCaptcha.Text);
      finally
        TThread.Synchronize(TThread.Current,
          procedure
          begin
            edtTextCaptchaResult.Text := CaptchaResult;
            edtCaptchaId.Text := TextCaptcha.CaptchaId;
            btnSolveTextCaptcha.Enabled := True;
          end);
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

procedure TMainForm.btnSolveSimpleCaptchaClick(Sender: TObject);
begin
  btnSolveSimpleCaptcha.Enabled := False;
  SimpleCaptcha.CaptchaKey := edtCaptchaKey.Text;

  TTask.Run(
    procedure
    var
      CaptchaResult: string;
    begin
      try
        CaptchaResult := SimpleCaptcha.Solve(FFileName);
      finally
        TThread.Synchronize(TThread.Current,
          procedure
          begin
            edtCaptchaResult.Text := CaptchaResult;
            edtCaptchaId.Text := SimpleCaptcha.CaptchaId;
            btnSolveSimpleCaptcha.Enabled := True;
          end);
      end;
    end);
end;

procedure TMainForm.btnSendReportClick(Sender: TObject);
begin
  SimpleCaptcha.SendReport(edtCaptchaId.Text);
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
  SimpleCaptcha.CaptchaKey := edtCaptchaKey.Text;
  ShowMessage(SimpleCaptcha.Balance);
end;

end.
