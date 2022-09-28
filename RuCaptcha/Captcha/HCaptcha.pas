unit HCaptcha;

interface

uses
  BaseCaptcha, System.SysUtils, IdMultipartFormData;

type
  THCaptcha = class(TBaseCaptcha)
  private
    FSiteKey: string;
    FPageURL: string;
  public
    constructor Create(const ASiteKey, APageURL: string);
    function BuildFormData: TIdMultiPartFormDataStream; override;
    property SiteKey: string read FSiteKey write FSiteKey;
    property PageURL: string read FPageURL write FPageURL;
  end;

implementation

{ THCaptcha }

function THCaptcha.BuildFormData: TIdMultiPartFormDataStream;
begin
  FormData.AddFormField('method', 'hcaptcha');
  FormData.AddFormField('sitekey', FSiteKey);
  FormData.AddFormField('pageurl', FPageURL);
  Result := FormData;
end;

constructor THCaptcha.Create(const ASiteKey, APageURL: string);
begin
  inherited Create;
  FSiteKey := ASiteKey;
  FPageURL := APageURL;
end;

end.
