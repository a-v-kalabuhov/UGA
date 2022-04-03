unit SelectAddress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  IBDatabase, StdCtrls;

type
  TfrmSelectAddress = class(TForm)
    Button3: TButton;
    Button4: TButton;
    GroupBox1: TGroupBox;
    Button1: TButton;
    Edit1: TEdit;
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  end;

  function DoSelectAddress(WithBuilding: Boolean; var AddressStr: String): Boolean;

implementation

{$R *.dfm}

uses
  Streets, uKisAppModule, uKisConsts;

function DoSelectAddress(WithBuilding: Boolean; var AddressStr: String): Boolean;
begin
  with TfrmSelectAddress.Create(Application) do
  try
    Edit1.Text := AddressStr;
    Result := ShowModal = mrOK;
    if Result then
      AddressStr := Edit1.Text;
  finally
    Release;
  end;
end;

procedure TfrmSelectAddress.Button3Click(Sender: TObject);
begin
  if Trim(Edit1.Text) = '' then
  begin
    MessageBox(Handle, PChar(S_PLEASE_FILL_FIELD + ' "Адрес"!'), PChar(S_WARN), MB_ICONWARNING);
    Edit1.SetFocus;
  end
  else
    ModalResult := mrOK;
end;

procedure TfrmSelectAddress.Button1Click(Sender: TObject);
var
  Id, VilId: Integer;
  S, StreetName, StreetMark, VillageName, VillageMark: String;
  V: Variant;
  T: TIBTransaction;
begin
  Id := 0;
  StreetName := '';
  StreetMark := '';
  VillageName := '';
  VillageMark := '';
  if SelectStreet(Id) then
  begin
    T := AppModule.Pool.Get;
    try
      T.StartTransaction;
      if AppModule.GetFieldValue(T, ST_STREETS, SF_ID, SF_NAME, Id, V) then
        StreetName := V;
      if AppModule.GetFieldValue(T, ST_STREETS, SF_ID, SF_STREET_MARKING_NAME, Id, V) then
        StreetMark := V;
      if AppModule.GetFieldValue(T, ST_STREETS, SF_ID, SF_VILLAGES_ID, Id, V) then
        if v <> NULL then
        begin
          VilId := V;
          if AppModule.GetFieldValue(T, ST_VILLAGES, SF_ID, SF_NAME, VilId, V) then
            VillageName := V;
          if AppModule.GetFieldValue(T, ST_VILLAGES, SF_ID, SF_STREET_MARKING_NAME, VilId, V) then
            VillageMark := V;
        end;
        S := VillageMark + VillageName;
      if Trim(S) <> '' then S := S + ', ';
      S := S + StreetMark + StreetName;
      Edit1.Text := Copy(Edit1.Text, 1, Succ(Edit1.SelStart)) + S +
        Copy(Edit1.Text, Edit1.SelStart + Edit1.SelLength + 1, Length(Edit1.Text));
    finally
      T.Commit;
      AppModule.Pool.Back(T);
    end;
  end;
end;

end.
