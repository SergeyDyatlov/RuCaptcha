unit RuCaptcha;

interface

uses System.SysUtils, IdHTTP, IdMultipartFormData, BaseCaptcha;

type
  ERuCaptchaError = class(Exception);

{$M+}

  TRuCaptcha = class
  private
    FHTTPClient: TIdHTTP;
    FAPIKey: string;
    FRequestTimeout: Integer;
  protected
    function GetBalance: string;
    function SendFormData(AFormData: TIdMultiPartFormDataStream): string;
    function ParseResponse(const Response: string): string;
    function GetAnswer(const CaptchaId: string): string;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure SolveCaptcha(Captcha: TBaseCaptcha);
    procedure ReportBad(const CaptchaId: string);
    procedure ReportGood(const CaptchaId: string);
    property Balance: string read GetBalance;
  published
    property APIKey: string read FAPIKey write FAPIKey;
    property RequestTimeout: Integer read FRequestTimeout write FRequestTimeout;
  end;

{$M-}

implementation

uses System.Classes, StrUtils;

{ TRuCaptcha }

constructor TRuCaptcha.Create;
begin
  FHTTPClient := TIdHTTP.Create(nil);
  FHTTPClient.ReadTimeout := 30000;
  FHTTPClient.ConnectTimeout := 30000;

  FRequestTimeout := 5000;
end;

destructor TRuCaptcha.Destroy;
begin
  FHTTPClient.Free;
  inherited;
end;

function TRuCaptcha.GetAnswer(const CaptchaId: string): string;
var
  URL: string;
  Content: TStringStream;
begin
  URL := Format('http://rucaptcha.com/res.php?key=%s&action=get&id=%s',
    [FAPIKey, CaptchaId]);

  Content := TStringStream.Create('', TEncoding.UTF8);
  try
    FHTTPClient.Get(URL, Content);
    Result := ParseResponse(Content.DataString);
  finally
    Content.Free;
  end;
end;

function TRuCaptcha.GetBalance: string;
var
  URL: string;
  Content: TStringStream;
begin
  URL := Format('http://rucaptcha.com/res.php?key=%s&action=getbalance',
    [FAPIKey]);

  Content := TStringStream.Create;
  try
    FHTTPClient.Get(URL, Content);
    Result := Content.DataString;
  finally
    Content.Free;
  end;
end;

function TRuCaptcha.ParseResponse(const Response: string): string;
begin
  if AnsiSameText('CAPCHA_NOT_READY', Response) then
    Exit(Response);

  if AnsiPos('OK|', Response) <= 0 then
    raise ERuCaptchaError.Create(Response);

  Result := ReplaceText(Response, 'OK|', '');
end;

function TRuCaptcha.SendFormData(AFormData: TIdMultiPartFormDataStream): string;
const
  URL = 'http://rucaptcha.com/in.php';

var
  Content: TStringStream;
begin
  Content := TStringStream.Create;
  try
    FHTTPClient.Post(URL, AFormData, Content);
    Result := ParseResponse(Content.DataString);
  finally
    Content.Free;
  end;
end;

procedure TRuCaptcha.ReportBad(const CaptchaId: string);
var
  URL: string;
  Content: TStringStream;
begin
  URL := Format('http://rucaptcha.com/res.php?key=%s&action=reportbad&id=%s',
    [FAPIKey, CaptchaId]);

  Content := TStringStream.Create;
  try
    FHTTPClient.Get(URL, Content);
  finally
    Content.Free;
  end;
end;

procedure TRuCaptcha.ReportGood(const CaptchaId: string);
var
  URL: string;
  Content: TStringStream;
begin
  URL := Format('http://rucaptcha.com/res.php?key=%s&action=reportgood&id=%s',
    [FAPIKey, CaptchaId]);

  Content := TStringStream.Create;
  try
    FHTTPClient.Get(URL, Content);
  finally
    Content.Free;
  end;
end;

procedure TRuCaptcha.SolveCaptcha(Captcha: TBaseCaptcha);
var
  FormData: TIdMultiPartFormDataStream;
  Answer: string;
begin
  FormData := Captcha.BuildFormData;
  FormData.AddFormField('soft_id', '838');
  FormData.AddFormField('key', FAPIKey);

  Captcha.Id := SendFormData(FormData);
  repeat
    Sleep(FRequestTimeout);
    Answer := GetAnswer(Captcha.Id);
  until Answer <> 'CAPCHA_NOT_READY';
  Captcha.Answer := Answer;
end;

end.
