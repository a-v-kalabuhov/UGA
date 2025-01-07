unit uMStClassesProjectsSearch;

interface

uses
  SysUtils,
  uMStKernelClasses, uMStKernelStack, uMStKernelClassesSearch,
  uMStConsts,
  uMStModuleApp;

type
  TmstProjectAddressSearchData = class(TmstTextSearchData)
  private
    FStack: TmstObjectStack;
    procedure OnProjectLoaded(Sender: TObject);
  public
    procedure DoSearch(AStack: TmstObjectStack); override;
    function SearchText: String;
  end;

implementation

{ TmstProjectAddressSearchData }

procedure TmstProjectAddressSearchData.DoSearch(AStack: TmstObjectStack);
begin
  inherited;
  FStack := aStack;
  with mstClientAppModule do
    LoadProjectsByField(SF_ADDRESS, SearchText, False, OnProjectLoaded);
end;

procedure TmstProjectAddressSearchData.OnProjectLoaded(Sender: TObject);
begin
  if Assigned(Sender) then
  if Assigned(FStack) then
  begin
    FStack.AddObject(TmstObject(Sender));
    Found := True;
  end;
end;

function TmstProjectAddressSearchData.SearchText: String;
begin
  Result := StringReplace(FText, ' ', '%', [rfReplaceAll]);
  Result := '%' + Result + '%';
  while Pos('%%', Result) > 0 do
    Result := StringReplace(Result, '%%', '%', [rfReplaceAll]);
end;

end.
