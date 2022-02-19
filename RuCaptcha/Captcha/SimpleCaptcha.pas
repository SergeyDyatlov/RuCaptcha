unit SimpleCaptcha;

interface

uses
  BaseCaptcha, System.SysUtils, IdMultipartFormData;

type
  TSimpleCaptcha = class(TBaseCaptcha)
  private
    FFileName: string;
    FPhrase: Boolean;
    FCaseSensitive: Boolean;
    FNumeric: Integer;
    FCalc: Boolean;
    FMinLength: Integer;
    FMaxLength: Integer;
    FLang: string;
    FTextHint: string;
    FImageHint: string;
  public
    constructor Create(const AFileName: string);
    function BuildFormData: TIdMultiPartFormDataStream; override;
    property FileName: string read FFileName write FFileName;
    property Phrase: Boolean read FPhrase write FPhrase;
    property CaseSensitive: Boolean read FCaseSensitive write FCaseSensitive;
    property Numeric: Integer read FNumeric write FNumeric;
    property Calc: Boolean read FCalc write FCalc;
    property MinLength: Integer read FMinLength write FMinLength;
    property MaxLength: Integer read FMaxLength write FMaxLength;
    property Lang: string read FLang write FLang;
    property TextHint: string read FTextHint write FTextHint;
    property ImageHint: string read FImageHint write FImageHint;
  end;

implementation

uses
  StrUtils;

{ TSimpleCaptcha }

function TSimpleCaptcha.BuildFormData: TIdMultiPartFormDataStream;
begin
  FormData.AddFile('file', FFileName);
  FormData.AddFormField('phrase', IfThen(FPhrase, '1', '0'));
  FormData.AddFormField('regsense', IfThen(FCaseSensitive, '1', '0'));
  FormData.AddFormField('numeric', FNumeric.ToString);
  FormData.AddFormField('calc', IfThen(FCalc, '1', '0'));
  FormData.AddFormField('min_len', FMinLength.ToString);
  FormData.AddFormField('max_len', FMaxLength.ToString);
  FormData.AddFormField('lang', FLang);
  FormData.AddFormField('textinstructions', FTextHint);
  FormData.AddFormField('imginstructions', FImageHint);
  Result := FormData;
end;

constructor TSimpleCaptcha.Create(const AFileName: string);
begin
  inherited Create;
  FFileName := AFileName;
  FPhrase := False;
  FCaseSensitive := False;
  FNumeric := 0;
  FCalc := False;
  FMinLength := 0;
  FMaxLength := 0;
  FLang := EmptyStr;
  FTextHint := EmptyStr;
  FImageHint := EmptyStr;
end;

end.
