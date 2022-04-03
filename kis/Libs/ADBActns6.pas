unit ADBActns6;

interface

uses ActnList, Dbactns, SysUtils;

type
  TDataSetFind=class(TDataSetAction)
  public
  published
    property DataSource;
  end;

  TDataSetUnFind=class(TDataSetAction)
  published
    property DataSource;
  end;

  TDataSetSort=class(TDataSetAction)
  published
    property DataSource;
  end;

  TRestoreGridDefaults=class(TDataSetAction)
  published
    property DataSource;
  end;

  TDataSetShow=class(TDataSetAction)
  public
    procedure UpdateTarget(Target: TObject); override;
  published
    property DataSource;
  end;

  TDataSetReopen=class(TDataSetAction)
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  published
    property DataSource;
  end;

procedure Register;

implementation

procedure TDataSetReopen.ExecuteTarget(Target: TObject);
begin
  with GetDataSet(Target) do
  begin
    Close;
    Open;
  end;
end;

procedure TDataSetReopen.UpdateTarget(Target: TObject);
begin
  with GetDataSet(Target) do
    Enabled := Active;
end;

procedure TDataSetShow.UpdateTarget(Target: TObject);
begin
  with GetDataSet(Target) do
    Enabled := Active and not (Bof and Eof);
end;

procedure Register;
begin
  RegisterActions('DataSet', [TDataSetFind, TDataSetUnFind, TDataSetSort, TRestoreGridDefaults, TDatasetShow, TDataSetReopen], nil);
end;

end.
