unit TextCaptchaFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, RuCaptcha, TextCaptcha;

type
  TTextCaptchaFrame = class(TFrame)
    edtTextCaptcha: TEdit;
    btnSolveCaptcha: TButton;
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

procedure TTextCaptchaFrame.btnSolveCaptchaClick(Sender: TObject);
begin
  MainForm.edtCaptchaId.Text := EmptyStr;
  MainForm.edtCaptchaAnswer.Text := EmptyStr;
  btnSolveCaptcha.Enabled := False;

  TTask.Run(
    procedure
    var
      Captcha: TTextCaptcha;
    begin
      Captcha := TTextCaptcha.Create(edtTextCaptcha.Text);
      try
        Captcha.Lang := 'ru';
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

end.
