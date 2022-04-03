unit uKisTakeBackFiles;

interface

uses
  SysUtils, Graphics, Contnrs;

type
  TTakeBackKind = (tbNone, tbNoChanges, tbEntireMap, tbZones);

  TZoneFile = class
  private
    FBackColor: TColor;
    FFileName: string;
  public
    property BackColor: TColor read FBackColor write FBackColor;
    property FileName: string read FFileName write FFileName;
  end;

  TTakeBackFileInfo = class
  private
    FFileName: String;
    FKind: TTakeBackKind;
    FNomenclature: string;
    FConfirmed: Boolean;
    FMergedFile: string;
    procedure SetKind(const Value: TTakeBackKind);
  public
    constructor Create();
    //
    property Confirmed: Boolean read FConfirmed write FConfirmed;
    property FileName: String read FFileName write FFileName;
    property Kind: TTakeBackKind read FKind write SetKind;
    property MergedFile: string read FMergedFile write FMergedFile;
    property Nomenclature: string read FNomenclature write FNomenclature;
  end;

  TTakeBackFiles = class(TObjectList)
  private
    function GetItems(const Index: Integer): TTakeBackFileInfo;
    procedure SetItems(const Index: Integer; const Value: TTakeBackFileInfo);
  public
    function Add: TTakeBackFileInfo;
    //
    property Items[const Index: Integer]: TTakeBackFileInfo read GetItems write SetItems; default;
  end;

implementation

{ TTakeBackFiles }

function TTakeBackFiles.Add: TTakeBackFileInfo;
begin
  Result := TTakeBackFileInfo.Create;
  inherited Add(Result);
end;

function TTakeBackFiles.GetItems(const Index: Integer): TTakeBackFileInfo;
begin
  Result := inherited Items[Index] as TTakeBackFileInfo;
end;

procedure TTakeBackFiles.SetItems(const Index: Integer;
  const Value: TTakeBackFileInfo);
begin
  inherited Items[Index] := Value;
end;

{ TTakeBackFileInfo }

constructor TTakeBackFileInfo.Create;
begin

end;

procedure TTakeBackFileInfo.SetKind(const Value: TTakeBackKind);
begin
  FKind := Value;
end;

end.
