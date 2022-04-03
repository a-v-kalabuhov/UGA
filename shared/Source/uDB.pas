unit uDB;

interface

uses
  SysUtils, DB;

type
  TDataSetHelper = class helper for TDataSet
  public
    function GetId(): Integer;
    function LocateId(Id: Integer): Boolean;
    procedure Reopen();
    procedure AdvReopen();
    procedure SoftCancel();
    function SoftEdit(): Boolean;
    procedure SoftPost();
    procedure SoftRefresh();
  end;

  TFieldHelper = class helper for TField
  public
    function AsBlob: TBlobField;
  end;

implementation

{ TDataSetHelper }

procedure TDataSetHelper.AdvReopen;
var
  CurId: Integer;
begin
  DisableControls;
  try
    CurId := GetId();
    Close;
    Open;
    LocateId(CurId);
  finally
    EnableControls;
  end;
end;

function TDataSetHelper.GetId: Integer;
begin
  Result := 0;
  if AnsiUpperCase(Fields[0].FieldName) = 'ID' then
    Result := Fields[0].AsInteger;
end;

function TDataSetHelper.LocateId(Id: Integer): Boolean;
begin
  Result := (Id > 0) and Self.Locate('ID', Id, []);
end;

procedure TDataSetHelper.Reopen;
begin
  Self.Close;
  Self.Open;
end;

procedure TDataSetHelper.SoftCancel;
begin
  if Self.State in [dsEdit, dsInsert] then
    Self.Cancel;
end;

function TDataSetHelper.SoftEdit: Boolean;
begin
  Result := not (Self.State in [dsEdit, dsInsert]);
  if Result then
    Self.Edit;
end;

procedure TDataSetHelper.SoftPost;
begin
  if Self.State in [dsEdit, dsInsert] then
    try
      Self.Post;
    except
      Self.Cancel;
      raise;
    end;
end;

procedure TDataSetHelper.SoftRefresh;
begin
  if not (Self.Bof and Self.Eof) then
    Self.Refresh;
end;

{ TFieldHelper }

function TFieldHelper.AsBlob: TBlobField;
begin
  Result := TBlobField(Self);
end;

end.
