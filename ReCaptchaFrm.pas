unit ReCaptchaFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.OleCtrls, SHDocVw, Vcl.StdCtrls, RuCaptcha, ReCaptcha;

type
  TReCaptchaFrame = class(TFrame)
    edtURL: TEdit;
    btnGo: TButton;
    WebBrowser1: TWebBrowser;
    btnSolveCaptcha: TButton;
    procedure btnGoClick(Sender: TObject);
    procedure btnSolveCaptchaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  WBUtils, MSHTML, System.Threading, MainFrm;

{$R *.dfm}

function GetSiteKey(WebBrowser: TWebBrowser): string;
var
  Element: IDispatch;
begin
  Element := GetElementById(WebBrowser.Document, 'recaptcha-demo');
  Result := (Element as IHTMLElement).getAttribute('data-sitekey', 0);
end;

procedure SubmitForm(WebBrowser: TWebBrowser; Response: string);
var
  Element: IDispatch;
begin
  Element := GetElementById(WebBrowser.Document, 'g-recaptcha-response');
  (Element as IHTMLTextAreaElement).Value := Response;

  Element := GetElementById(WebBrowser.Document, 'recaptcha-demo-submit');
  (Element as IHTMLElement).click;
end;

procedure TReCaptchaFrame.btnGoClick(Sender: TObject);
begin
  WebBrowser1.Navigate(edtURL.Text);
end;

procedure TReCaptchaFrame.btnSolveCaptchaClick(Sender: TObject);
var
  GoogleKey: string;
  Element: IDispatch;
  PageURL: string;
begin
  MainForm.edtCaptchaId.Text := EmptyStr;
  MainForm.edtCaptchaAnswer.Text := EmptyStr;
  btnSolveCaptcha.Enabled := False;

  GoogleKey := GetSiteKey(WebBrowser1);
  PageURL := WebBrowser1.LocationURL;

  TTask.Run(
    procedure
    var
      Captcha: TReCaptcha;
    begin
      Captcha := TReCaptcha.Create(GoogleKey, PageURL);
      try
        MainForm.RuCaptcha.SolveCaptcha(Captcha);
      finally
        TThread.Synchronize(TThread.Current,
          procedure
          begin
            SubmitForm(WebBrowser1, Captcha.Answer);

            MainForm.edtCaptchaId.Text := Captcha.Id;
            MainForm.edtCaptchaAnswer.Text := Captcha.Answer;
            btnSolveCaptcha.Enabled := True;
          end);

        Captcha.Free;
      end;
    end);
end;

end.
