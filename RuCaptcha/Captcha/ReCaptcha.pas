unit ReCaptcha;

interface

uses
  BaseCaptcha, System.SysUtils, IdMultipartFormData;

type
  TReCaptcha = class(TBaseCaptcha)
  private
    FVersion: string;
    FGoogleKey: string;
    FPageURL: string;
    FInvisible: Boolean;
    FAction: string;
    FMinScore: Double;
  public
    constructor Create(const AGoogleKey, APageURL: string);
    function BuildFormData: TIdMultiPartFormDataStream; override;
  published
    property Version: string read FVersion write FVersion;
    property GoogleKey: string read FGoogleKey write FGoogleKey;
    property PageURL: string read FPageURL write FPageURL;
    property Invisible: Boolean read FInvisible write FInvisible;
    property Action: string read FAction write FAction;
    property MinScore: Double read FMinScore write FMinScore;
  end;

implementation

uses
  StrUtils;

{ TReCaptcha }

function TReCaptcha.BuildFormData: TIdMultiPartFormDataStream;
begin
  FormData.AddFormField('method', 'userrecaptcha');
  FormData.AddFormField('version', FVersion);
  FormData.AddFormField('googlekey', FGoogleKey);
  FormData.AddFormField('pageurl', FPageURL);
  FormData.AddFormField('invisible', IfThen(FInvisible, '1', '0'));
  FormData.AddFormField('action', FAction);
  FormData.AddFormField('min_score', FMinScore.ToString);
  Result := FormData;
end;

constructor TReCaptcha.Create(const AGoogleKey, APageURL: string);
begin
  inherited Create;
  FGoogleKey := AGoogleKey;
  FPageURL := APageURL;
  FVersion := EmptyStr;
  FInvisible := False;
  FAction := 'verify';
  FMinScore := 0.4;
end;

end.
