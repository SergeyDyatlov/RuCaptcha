unit API.RuCaptcha;

interface

uses IdHTTP, IdMultipartFormData;

type
  TRuCaptcha = class
  private
    FCaptchaKey: string;
    FHTTPClient: TIdHTTP;
    function UploadFile(const FileName: string): string;
    function GetAnswer(const CaptchaId: string): string;
    function ParseCaptchaId(const Answer: string): string;
    function ParseCaptchaText(const Answer: string): string;
    function GetBalance: string;
  public
    constructor Create;
    destructor Destroy; override;
    function Recognize(const FileName: string): string;
    procedure SendReport(const CaptchaId: string);
    property Balance: string read GetBalance;
  published
    property CaptchaKey: string read FCaptchaKey write FCaptchaKey;
  end;

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

function TRuCaptcha.Recognize(const FileName: string): string;
var
  vCaptchaId: string;
begin
  vCaptchaId := UploadFile(FileName);

  repeat
    Result := GetAnswer(vCaptchaId);
    Wait(2);
  until Result <> 'CAPCHA_NOT_READY';
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

function TRuCaptcha.UploadFile(const FileName: string): string;
var
  vURL: string;
  vFormData: TIdMultiPartFormDataStream;
  vContent: TStringStream;
begin
  vURL := 'http://rucaptcha.com/in.php';

  vFormData := TIdMultiPartFormDataStream.Create;
  try
    vFormData.AddFormField('soft_id', '838');
    vFormData.AddFormField('key', FCaptchaKey);
    vFormData.AddFile('file', FileName);

    vContent := TStringStream.Create;
    try
      FHTTPClient.Post(vURL, vFormData, vContent);
      Result := ParseCaptchaId(vContent.DataString);
    finally
      vContent.Free;
    end;
  finally
    vFormData.Free;
  end;
end;

end.
