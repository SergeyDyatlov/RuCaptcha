program RuCaptchaExample;

uses
  Vcl.Forms,
  MainFrm in 'MainFrm.pas' {MainForm},
  RuCaptcha in 'RuCaptcha\RuCaptcha.pas',
  TextCaptcha in 'RuCaptcha\Captcha\TextCaptcha.pas',
  ReCaptcha in 'RuCaptcha\Captcha\ReCaptcha.pas',
  BaseCaptcha in 'RuCaptcha\Captcha\BaseCaptcha.pas',
  SimpleCaptcha in 'RuCaptcha\Captcha\SimpleCaptcha.pas',
  HCaptcha in 'RuCaptcha\Captcha\HCaptcha.pas',
  HCaptchaFrm in 'HCaptchaFrm.pas' {HCaptchaFrame: TFrame},
  WBUtils in 'WBUtils.pas',
  ReCaptchaFrm in 'ReCaptchaFrm.pas' {ReCaptchaFrame: TFrame},
  TextCaptchaFrm in 'TextCaptchaFrm.pas' {TextCaptchaFrame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
