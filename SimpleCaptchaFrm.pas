unit SimpleCaptchaFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ExtDlgs, RuCaptcha, SimpleCaptcha;

type
  TSimpleCaptchaFrame = class(TFrame)
    Label1: TLabel;
    Button1: TButton;
    Image1: TImage;
    btnSolveCaptcha: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure btnSolveCaptchaClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FFileName: string;
  public
    { Public declarations }
  end;

implementation

uses
  WBUtils, MSHTML, System.Threading, MainFrm;

{$R *.dfm}

procedure TSimpleCaptchaFrame.btnSolveCaptchaClick(Sender: TObject);
begin
  MainForm.edtCaptchaId.Text := EmptyStr;
  MainForm.edtCaptchaAnswer.Text := EmptyStr;
  btnSolveCaptcha.Enabled := False;

  TTask.Run(
    procedure
    var
      Captcha: TSimpleCaptcha;
    begin
      Captcha := TSimpleCaptcha.Create(FFileName);
      try
        MainForm.RuCaptcha.SolveCaptcha(Captcha);
      finally
        TThread.Synchronize(TThread.Current,
          procedure
          begin
            MainForm.edtCaptchaId.Text := Captcha.Id;
            MainForm.edtCaptchaAnswer.Text := Captcha.Answer;
            btnSolveCaptcha.Enabled := True;
          end);

        Captcha.Free;
      end;
    end);
end;

procedure TSimpleCaptchaFrame.Button1Click(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
  begin
    FFileName := OpenPictureDialog1.FileName;
    Image1.Picture.LoadFromFile(FFileName);
  end;
end;

end.
