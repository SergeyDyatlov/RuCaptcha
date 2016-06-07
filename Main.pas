unit Main;

interface

uses
  API.RuCaptcha, Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ExtDlgs, JPEG;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Button2: TButton;
    Image1: TImage;
    Edit2: TEdit;
    OpenPictureDialog1: TOpenPictureDialog;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FileName: string;
    RuCaptcha: TRuCaptcha;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

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
  RuCaptcha.CaptchaKey := Edit1.Text;
  Edit2.Text := RuCaptcha.Recognize(FileName);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  RuCaptcha := TRuCaptcha.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  RuCaptcha.Free;
end;

procedure TForm1.Label3Click(Sender: TObject);
begin
  RuCaptcha.CaptchaKey := Edit1.Text;
  ShowMessage(RuCaptcha.Balance);
end;

end.
