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
      'Не верный формат параметра key, должно быть 32 символа');
    vErrors.Add('ERROR_KEY_DOES_NOT_EXIST', 'Использован несуществующий key');
    vErrors.Add('ERROR_ZERO_BALANCE', 'Баланс Вашего аккаунта нулевой');
    vErrors.Add('ERROR_NO_SLOT_AVAILABLE',
      'Текущая ставка распознования выше, чем максимально установленная в настройках Вашего аккаунта. Либо на сервере скопилась очередь и работники не успевают её разобрать, повторите загрузку через 5 секунд.');
    vErrors.Add('ERROR_ZERO_CAPTCHA_FILESIZE', 'Размер капчи меньше 100 Байт');
    vErrors.Add('ERROR_TOO_BIG_CAPTCHA_FILESIZE',
      'Размер капчи более 100 КБайт');
    vErrors.Add('ERROR_WRONG_FILE_EXTENSION',
      'Ваша капча имеет неверное расширение, допустимые расширения jpg,jpeg,gif,png');
    vErrors.Add('ERROR_IMAGE_TYPE_NOT_SUPPORTED',
      'Сервер не может определить тип файла капчи');
    vErrors.Add('ERROR_IP_NOT_ALLOWED',
      'В Вашем аккаунте настроено ограничения по IP с которых можно делать запросы. И IP, с которого пришёл данный запрос не входит в список разрешённых.');
    vErrors.Add('IP_BANNED',
      'IP-адрес, с которого пришёл запрос заблокирован из-за частых обращений с различными неверными ключами. Блокировка снимается через час');

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
      'Вы использовали неверный key в запросе');
    vErrors.Add('ERROR_WRONG_ID_FORMAT',
      'Неверный формат ID капчи. ID должен содержать только цифры');
    vErrors.Add('ERROR_CAPTCHA_UNSOLVABLE',
      'Капчу не смогли разгадать 3 разных работника. Списанные средства за это изображение возвращаются обратно на баланс');
    vErrors.Add('ERROR_WRONG_CAPTCHA_ID',
      'Вы пытаетесь получить ответ на капчу или пожаловаться на капчу, которая была загружена более 15 минут назад');
    vErrors.Add('ERROR_BAD_DUPLICATES',
      'Ошибка появляется при включённом 100%м распознании. Было использовано максимальное количество попыток, но необходимое количество одинаковых ответов не было набрано');
    vErrors.Add('REPORT_NOT_RECORDED',
      'Такой ответ сервер может отдать на жалобу (reportbad), если до этого вы пожаловались на большое количество верных распознаний');

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
