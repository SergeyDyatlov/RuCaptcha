unit WBUtils;

interface

function GetElementById(const Document: IDispatch; ElementId: string)
  : IDispatch;

implementation

uses
  MSHTML;

function GetElementById(const Document: IDispatch; ElementId: string)
  : IDispatch;
begin
  Result := (Document as IHTMLDocument3).GetElementById(ElementId);
end;

end.
