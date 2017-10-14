unit Main;

interface

uses
  API.RuCaptcha, Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ExtDlgs, JPEG, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Edit3: TEdit;
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
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btnRecognizeTextCaptchaClick(Sender: TObject);
  private
    { Private declarations }
    FileName: string;
    SimpleCaptcha: TSimpleCaptcha;
    TextCaptcha: TTextCaptcha;
    CaptchaId: string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnRecognizeTextCaptchaClick(Sender: TObject);
begin
  TextCaptcha.CaptchaKey := Edit1.Text;
  edtTextCaptchaResult.Text := TextCaptcha.Recognize(edtTextCaptcha.Text,
    CaptchaId);
  Edit3.Text := CaptchaId;
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
begin
  SimpleCaptcha.CaptchaKey := Edit1.Text;
  Edit2.Text := SimpleCaptcha.Recognize(FileName, CaptchaId);
  Edit3.Text := CaptchaId;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  SimpleCaptcha.SendReport(CaptchaId);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SimpleCaptcha := TSimpleCaptcha.Create;
  TextCaptcha := TTextCaptcha.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  TextCaptcha.Free;
  SimpleCaptcha.Free;
end;

procedure TForm1.Label3Click(Sender: TObject);
begin
  SimpleCaptcha.CaptchaKey := Edit1.Text;
  ShowMessage(SimpleCaptcha.Balance);
end;

end.
