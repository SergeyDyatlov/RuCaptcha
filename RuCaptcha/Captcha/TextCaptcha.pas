unit TextCaptcha;

interface

uses
  BaseCaptcha, System.SysUtils, IdMultipartFormData;

type
  TTextCaptcha = class(TBaseCaptcha)
  private
    FLang: string;
    FText: string;
  public
    constructor Create(const AText: string);
    function BuildFormData: TIdMultiPartFormDataStream; override;
    property Lang: string read FLang write FLang;
    property Text: string read FText write FText;
  end;

implementation

{ TTextCaptcha }

function TTextCaptcha.BuildFormData: TIdMultiPartFormDataStream;
begin
  FormData.AddFormField('lang', FLang);
  FormData.AddFormField('textcaptcha', FText, 'utf-8').ContentTransfer
    := '8bit';
  Result := FormData;
end;

constructor TTextCaptcha.Create(const AText: string);
begin
  inherited Create;
  FText := AText;
  FLang := EmptyStr;
end;

end.
