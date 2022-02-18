unit RuCaptcha;

interface

uses System.SysUtils, IdHTTP, IdMultipartFormData;

type
  ERuCaptchaError = class(Exception);

  TRuCaptcha = class
  private
    FHTTPClient: TIdHTTP;
    FCaptchaKey: string;
    FCaptchaId: string;
    FRequestTimeout: Integer;
  protected
    function GetBalance: string;
    function SendFormData(AFormData: TIdMultiPartFormDataStream): string;
    function ParseResponse(const Response: string): string;
    function GetAnswer(const CaptchaId: string): string;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure SendReport(const CaptchaId: string);
    property Balance: string read GetBalance;
    property CaptchaId: string read FCaptchaId;
  published
    property CaptchaKey: string read FCaptchaKey write FCaptchaKey;
    property RequestTimeout: Integer read FRequestTimeout write FRequestTimeout;
  end;

  TSimpleCaptcha = class(TRuCaptcha)
  public
    function Solve(const AFileName: string): string;
  end;

  TTextCaptcha = class(TRuCaptcha)
  public
    function Solve(const AText: string): string;
  end;

  TReCaptchaV2 = class(TRuCaptcha)
  public
    function Solve(const AGoogleKey, APageURL: string): string;
  end;

var
  SimpleCaptcha: TSimpleCaptcha;
  TextCaptcha: TTextCaptcha;
  ReCaptchaV2: TReCaptchaV2;

implementation

uses System.Classes, StrUtils, Vcl.Forms, System.Generics.Collections,
  DateUtils;

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
    [FCaptchaKey, CaptchaId]);

  Content := TStringStream.Create;
  try
    FHTTPClient.Get(URL, Content);
    Result := ParseResponse(Content.DataString);
    Result := UTF8Decode(Result);
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
    [FCaptchaKey]);

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

procedure TRuCaptcha.SendReport(const CaptchaId: string);
var
  URL: string;
  Content: TStringStream;
begin
  URL := Format('http://rucaptcha.com/res.php?key=%s&action=reportbad&id=%s',
    [FCaptchaKey, CaptchaId]);

  Content := TStringStream.Create;
  try
    FHTTPClient.Get(URL, Content);
  finally
    Content.Free;
  end;
end;

{ TSimpleCaptcha }

function TSimpleCaptcha.Solve(const AFileName: string): string;
var
  FormData: TIdMultiPartFormDataStream;
begin
  FormData := TIdMultiPartFormDataStream.Create;
  try
    FormData.AddFormField('soft_id', '838');
    FormData.AddFormField('key', CaptchaKey);
    FormData.AddFile('file', AFileName);

    FCaptchaId := SendFormData(FormData);
    repeat
      Sleep(FRequestTimeout);
      Result := GetAnswer(CaptchaId);
    until Result <> 'CAPCHA_NOT_READY';
  finally
    FormData.Free;
  end;
end;

{ TTextCaptcha }

function TTextCaptcha.Solve(const AText: string): string;
var
  FormData: TIdMultiPartFormDataStream;
begin
  FormData := TIdMultiPartFormDataStream.Create;
  try
    FormData.AddFormField('soft_id', '838');
    FormData.AddFormField('key', CaptchaKey);
    FormData.AddFormField('textcaptcha', AText, 'utf-8').ContentTransfer
      := '8bit';

    FCaptchaId := SendFormData(FormData);
    repeat
      Sleep(FRequestTimeout);
      Result := GetAnswer(CaptchaId);
    until Result <> 'CAPCHA_NOT_READY';
  finally
    FormData.Free;
  end;
end;

{ TReCaptchaV2 }

function TReCaptchaV2.Solve(const AGoogleKey, APageURL: string): string;
var
  FormData: TIdMultiPartFormDataStream;
begin
  FormData := TIdMultiPartFormDataStream.Create;
  try
    FormData.AddFormField('soft_id', '838');
    FormData.AddFormField('key', CaptchaKey);
    FormData.AddFormField('method', 'userrecaptcha');
    FormData.AddFormField('googlekey', AGoogleKey);
    FormData.AddFormField('pageurl', APageURL);

    FCaptchaId := SendFormData(FormData);
    repeat
      Sleep(FRequestTimeout);
      Result := GetAnswer(CaptchaId);
    until Result <> 'CAPCHA_NOT_READY';
  finally
    FormData.Free;
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
