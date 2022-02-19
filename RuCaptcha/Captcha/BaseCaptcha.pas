unit BaseCaptcha;

interface

uses
  IdMultipartFormData;

type
  TBaseCaptcha = class
  private
    FFormData: TIdMultiPartFormDataStream;
    FId: string;
    FAnswer: string;
  protected
    property FormData: TIdMultiPartFormDataStream read FFormData;
  public
    constructor Create;
    destructor Destroy; override;
    function BuildFormData: TIdMultiPartFormDataStream; virtual; abstract;
    property Id: string read FId write FId;
    property Answer: string read FAnswer write FAnswer;
  end;

implementation

{ TBaseCaptcha }

constructor TBaseCaptcha.Create;
begin
  FFormData := TIdMultiPartFormDataStream.Create;
end;

destructor TBaseCaptcha.Destroy;
begin
  FFormData.Free;
  inherited;
end;

end.
