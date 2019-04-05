unit API.RuCaptcha;

interface

uses IdHTTP, IdMultipartFormData, System.SysUtils;

type
  ERuCaptchaError = class(Exception);

  TRuCaptcha = class
  private
    FCaptchaKey: string;
    FHTTPClient: TIdHTTP;
  protected
    function SendFormData(AFormData: TIdMultiPartFormDataStream): string;
    function ParseResponse(const Response: string): string;
    function GetAnswer(const CaptchaId: string): string;
    function GetBalance: string;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure SendReport(const CaptchaId: string);
    property CaptchaKey: string read FCaptchaKey write FCaptchaKey;
    property Balance: string read GetBalance;
  end;

  TSimpleCaptcha = class(TRuCaptcha)
  public
    function Recognize(const FileName: string; out CaptchaId: string): string;
  end;

  TTextCaptcha = class(TRuCaptcha)
  public
    function Recognize(const AText: string; out CaptchaId: string): string;
  end;

  TReCaptchaV2 = class(TRuCaptcha)
  public
    function Recognize(const AGoogleKey, APageURL: string;
      out CaptchaId: string): string;
  end;

const
  cInternalTimeout = 5;

var
  SimpleCaptcha: TSimpleCaptcha;
  TextCaptcha: TTextCaptcha;
  ReCaptchaV2: TReCaptchaV2;

implementation

uses System.Classes, StrUtils, Vcl.Forms, System.Generics.Collections,
  DateUtils;

procedure Wait(Seconds: Int64);
var
  Target: TTime;
begin
  Target := IncSecond(Now, Seconds);
  while (Target > Now) do
  begin
    Application.ProcessMessages;

    if Application.Terminated then
      Exit;

    System.SysUtils.Sleep(30);
  end;
end;

{ TRuCaptcha }

constructor TRuCaptcha.Create;
begin
  FHTTPClient := TIdHTTP.Create(nil);
  FHTTPClient.ReadTimeout := 30000;
  FHTTPClient.ConnectTimeout := 30000;
end;

destructor TRuCaptcha.Destroy;
begin
  FHTTPClient.Free;
  inherited;
end;

function TRuCaptcha.GetAnswer(const CaptchaId: string): string;
var
  vURL: string;
  vContent: TStringStream;
begin
  vURL := Format('http://rucaptcha.com/res.php?key=%s&action=get&id=%s',
    [FCaptchaKey, CaptchaId]);

  vContent := TStringStream.Create;
  try
    FHTTPClient.Get(vURL, vContent);
    Result := ParseResponse(vContent.DataString);
    Result := UTF8Decode(Result);
  finally
    vContent.Free;
  end;
end;

function TRuCaptcha.GetBalance: string;
var
  vURL: string;
  vContent: TStringStream;
begin
  vURL := Format('http://rucaptcha.com/res.php?key=%s&action=getbalance',
    [FCaptchaKey]);

  vContent := TStringStream.Create;
  try
    FHTTPClient.Get(vURL, vContent);
    Result := vContent.DataString;
  finally
    vContent.Free;
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
  vContent: TStringStream;
begin
  vContent := TStringStream.Create;
  try
    FHTTPClient.Post(URL, AFormData, vContent);
    Result := ParseResponse(vContent.DataString);
  finally
    vContent.Free;
  end;
end;

procedure TRuCaptcha.SendReport(const CaptchaId: string);
var
  vURL: string;
  vContent: TStringStream;
begin
  vURL := Format('http://rucaptcha.com/res.php?key=%s&action=reportbad&id=%s',
    [FCaptchaKey, CaptchaId]);

  vContent := TStringStream.Create;
  try
    FHTTPClient.Get(vURL, vContent);
  finally
    vContent.Free;
  end;
end;

{ TSimpleCaptcha }

function TSimpleCaptcha.Recognize(const FileName: string;
  out CaptchaId: string): string;
var
  vFormData: TIdMultiPartFormDataStream;
begin
  vFormData := TIdMultiPartFormDataStream.Create;
  try
    vFormData.AddFormField('soft_id', '838');
    vFormData.AddFormField('key', CaptchaKey);
    vFormData.AddFile('file', FileName);

    CaptchaId := SendFormData(vFormData);
    repeat
      Result := GetAnswer(CaptchaId);
      Wait(cInternalTimeout);
    until Result <> 'CAPCHA_NOT_READY';
  finally
    vFormData.Free;
  end;
end;

{ TTextCaptcha }

function TTextCaptcha.Recognize(const AText: string;
  out CaptchaId: string): string;
var
  vFormData: TIdMultiPartFormDataStream;
begin
  vFormData := TIdMultiPartFormDataStream.Create;
  try
    vFormData.AddFormField('soft_id', '838');
    vFormData.AddFormField('key', CaptchaKey);
    vFormData.AddFormField('textcaptcha', AText, 'utf-8').ContentTransfer
      := '8bit';

    CaptchaId := SendFormData(vFormData);
    repeat
      Result := GetAnswer(CaptchaId);
      Wait(cInternalTimeout);
    until Result <> 'CAPCHA_NOT_READY';
  finally
    vFormData.Free;
  end;
end;

{ TReCaptchaV2 }

function TReCaptchaV2.Recognize(const AGoogleKey, APageURL: string;
  out CaptchaId: string): string;
var
  vFormData: TIdMultiPartFormDataStream;
begin
  vFormData := TIdMultiPartFormDataStream.Create;
  try
    vFormData.AddFormField('soft_id', '838');
    vFormData.AddFormField('key', CaptchaKey);
    vFormData.AddFormField('method', 'userrecaptcha');
    vFormData.AddFormField('googlekey', AGoogleKey);
    vFormData.AddFormField('pageurl', APageURL);

    CaptchaId := SendFormData(vFormData);
    repeat
      Result := GetAnswer(CaptchaId);
      Wait(cInternalTimeout);
    until Result <> 'CAPCHA_NOT_READY';
  finally
    vFormData.Free;
  end;
end;

initialization

SimpleCaptcha := TSimpleCaptcha.Create;
TextCaptcha := TTextCaptcha.Create;
ReCaptchaV2 := TReCaptchaV2.Create;

finalization

SimpleCaptcha.Free;
TextCaptcha.Free;
ReCaptchaV2.Free;

end.
