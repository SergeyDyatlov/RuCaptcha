unit API.RuCaptcha;

interface

uses IdHTTP, IdMultipartFormData;

type
  TRuCaptcha = class
  private
    FCaptchaKey: string;
    FHTTPClient: TIdHTTP;
  protected
    function SendFormData(AFormData: TIdMultiPartFormDataStream): string;
    function ParseCaptchaId(const Answer: string): string;
    function ParseCaptchaText(const Answer: string): string;
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

implementation

uses System.Classes, StrUtils, System.SysUtils, Vcl.Forms,
  System.Generics.Collections, DateUtils;

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
    Result := ParseCaptchaText(vContent.DataString);
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

function TRuCaptcha.ParseCaptchaId(const Answer: string): string;
var
  vErrors: TDictionary<string, string>;
begin
  vErrors := TDictionary<string, string>.Create;
  try
    vErrors.Add('ERROR_WRONG_USER_KEY',
      '�� ������ ������ ��������� key, ������ ���� 32 �������');
    vErrors.Add('ERROR_KEY_DOES_NOT_EXIST', '����������� �������������� key');
    vErrors.Add('ERROR_ZERO_BALANCE', '������ ������ �������� �������');
    vErrors.Add('ERROR_NO_SLOT_AVAILABLE',
      '������� ������ ������������� ����, ��� ����������� ������������� � ���������� ������ ��������. ���� �� ������� ��������� ������� � ��������� �� �������� � ���������, ��������� �������� ����� 5 ������.');
    vErrors.Add('ERROR_ZERO_CAPTCHA_FILESIZE', '������ ����� ������ 100 ����');
    vErrors.Add('ERROR_TOO_BIG_CAPTCHA_FILESIZE',
      '������ ����� ����� 100 �����');
    vErrors.Add('ERROR_WRONG_FILE_EXTENSION',
      '���� ����� ����� �������� ����������, ���������� ���������� jpg,jpeg,gif,png');
    vErrors.Add('ERROR_IMAGE_TYPE_NOT_SUPPORTED',
      '������ �� ����� ���������� ��� ����� �����');
    vErrors.Add('ERROR_IP_NOT_ALLOWED',
      '� ����� �������� ��������� ����������� �� IP � ������� ����� ������ �������. � IP, � �������� ������ ������ ������ �� ������ � ������ �����������.');
    vErrors.Add('IP_BANNED',
      'IP-�����, � �������� ������ ������ ������������ ��-�� ������ ��������� � ���������� ��������� �������. ���������� ��������� ����� ���');

    if vErrors.ContainsKey(Answer) then
      raise Exception.CreateFmt('RuCaptcha: %s', [vErrors[Answer]]);

    Result := ReplaceStr(Answer, 'OK|', '');
  finally
    vErrors.Free;
  end;
end;

function TRuCaptcha.ParseCaptchaText(const Answer: string): string;
var
  vErrors: TDictionary<string, string>;
begin
  vErrors := TDictionary<string, string>.Create;
  try
    vErrors.Add('ERROR_KEY_DOES_NOT_EXIST',
      '�� ������������ �������� key � �������');
    vErrors.Add('ERROR_WRONG_ID_FORMAT',
      '�������� ������ ID �����. ID ������ ��������� ������ �����');
    vErrors.Add('ERROR_CAPTCHA_UNSOLVABLE',
      '����� �� ������ ��������� 3 ������ ���������. ��������� �������� �� ��� ����������� ������������ ������� �� ������');
    vErrors.Add('ERROR_WRONG_CAPTCHA_ID',
      '�� ��������� �������� ����� �� ����� ��� ������������ �� �����, ������� ���� ��������� ����� 15 ����� �����');
    vErrors.Add('ERROR_BAD_DUPLICATES',
      '������ ���������� ��� ���������� 100%� �����������. ���� ������������ ������������ ���������� �������, �� ����������� ���������� ���������� ������� �� ���� �������');
    vErrors.Add('REPORT_NOT_RECORDED',
      '����� ����� ������ ����� ������ �� ������ (reportbad), ���� �� ����� �� ������������ �� ������� ���������� ������ �����������');

    if vErrors.ContainsKey(Answer) then
      raise Exception.CreateFmt('RuCaptcha: %s', [vErrors[Answer]]);

    Result := ReplaceStr(Answer, 'OK|', '');
  finally
    vErrors.Free;
  end;
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
    Result := ParseCaptchaId(vContent.DataString);
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

end.
