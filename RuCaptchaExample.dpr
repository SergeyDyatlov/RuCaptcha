program RuCaptchaExample;

uses
  Vcl.Forms,
  MainFrm in 'MainFrm.pas' {MainForm},
  RuCaptcha in 'RuCaptcha.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
