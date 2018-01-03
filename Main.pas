unit Main;

interface

uses
  API.RuCaptcha, Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ExtDlgs, JPEG, Vcl.ComCtrls,
  Vcl.OleCtrls, SHDocVw, IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze;

type
  TForm1 = class(TForm)
    edtCaptchaKey: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtCaptchaId: TEdit;
    Button3: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    Edit2: TEdit;
    OpenPictureDialog1: TOpenPictureDialog;
    TabSheet2: TTabSheet;
    edtTextCaptcha: TEdit;
    btnRecognizeTextCaptcha: TButton;
    edtTextCaptchaResult: TEdit;
    TabSheet3: TTabSheet;
    WebBrowser1: TWebBrowser;
    Panel1: TPanel;
    edtURL: TEdit;
    btnGo: TButton;
    Panel2: TPanel;
    btnRecognizeReCaptcha: TButton;
    IdAntiFreeze1: TIdAntiFreeze;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btnRecognizeTextCaptchaClick(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure btnRecognizeReCaptchaClick(Sender: TObject);
  private
    { Private declarations }
    FileName: string;
    SimpleCaptcha: TSimpleCaptcha;
    TextCaptcha: TTextCaptcha;
    ReCaptcha: TReCaptchaV2;
  public
    { Public declarations }
    function GetElementById(const Document: IDispatch; ElementId: string)
      : IDispatch;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  MSHTML;

procedure TForm1.btnRecognizeReCaptchaClick(Sender: TObject);
var
  GoogleKey: string;
  CaptchaText: string;
  CaptchaId: string;
  Element: IDispatch;
begin
  Element := GetElementById(WebBrowser1.Document, 'recaptcha-demo');
  GoogleKey := (Element as IHTMLElement).getAttribute('data-sitekey', 0);

  ReCaptcha.CaptchaKey := edtCaptchaKey.Text;
  CaptchaText := ReCaptcha.Recognize(GoogleKey, WebBrowser1.LocationURL,
    CaptchaId);

  Element := GetElementById(WebBrowser1.Document, 'g-recaptcha-response');
  (Element as IHTMLTextAreaElement).Value := CaptchaText;
  Application.ProcessMessages;

  Element := GetElementById(WebBrowser1.Document, 'recaptcha-demo-submit');
  (Element as IHTMLElement).click;
end;

procedure TForm1.btnRecognizeTextCaptchaClick(Sender: TObject);
var
  CaptchaId: string;
begin
  TextCaptcha.CaptchaKey := edtCaptchaKey.Text;
  edtTextCaptchaResult.Text := TextCaptcha.Recognize(edtTextCaptcha.Text,
    CaptchaId);
  edtCaptchaId.Text := CaptchaId;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
  begin
    FileName := OpenPictureDialog1.FileName;
    Image1.Picture.LoadFromFile(FileName);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  CaptchaId: string;
begin
  SimpleCaptcha.CaptchaKey := edtCaptchaKey.Text;
  Edit2.Text := SimpleCaptcha.Recognize(FileName, CaptchaId);
  edtCaptchaId.Text := CaptchaId;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  SimpleCaptcha.SendReport(edtCaptchaId.Text);
end;

procedure TForm1.btnGoClick(Sender: TObject);
begin
  WebBrowser1.Navigate(edtURL.Text);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SimpleCaptcha := TSimpleCaptcha.Create;
  TextCaptcha := TTextCaptcha.Create;
  ReCaptcha := TReCaptchaV2.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ReCaptcha.Free;
  TextCaptcha.Free;
  SimpleCaptcha.Free;
end;

function TForm1.GetElementById(const Document: IDispatch; ElementId: string)
  : IDispatch;
begin
  Result := (Document as IHTMLDocument3).GetElementById(ElementId);
end;

procedure TForm1.Label3Click(Sender: TObject);
begin
  SimpleCaptcha.CaptchaKey := edtCaptchaKey.Text;
  ShowMessage(SimpleCaptcha.Balance);
end;

end.
