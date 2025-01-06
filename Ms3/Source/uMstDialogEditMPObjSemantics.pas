unit uMstDialogEditMPObjSemantics;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, DBCtrls, Mask,
  RxMemDS,
  uMStClassesProjectsMP;

type
  TmstEditMPObjSemanticsDialog = class(TForm)
    DataSource1: TDataSource;
    DBLookupComboBox1: TDBLookupComboBox;
    dsNetStates: TDataSource;
    mdNetStates: TRxMemoryData;
    mdNetStatesID: TIntegerField;
    mdNetStatesNAME: TStringField;
    Label1: TLabel;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    DBCheckBox4: TDBCheckBox;
    Label3: TLabel;
    DBEdit2: TDBEdit;
    Label4: TLabel;
    DBEdit3: TDBEdit;
    Label5: TLabel;
    DBEdit4: TDBEdit;
    Label6: TLabel;
    DBEdit5: TDBEdit;
    Label7: TLabel;
    DBEdit6: TDBEdit;
    Label8: TLabel;
    DBEdit7: TDBEdit;
    btnOK: TButton;
    btnCancel: TButton;
    DBText1: TDBText;
    DBText2: TDBText;
    Label9: TLabel;
    Label10: TLabel;
  private
    procedure PrepareNetStates();
  public
    procedure Execute(aProject: TmstProjectMP; aDataSet: TDataSet);
  end;

implementation

{$R *.dfm}

{ TmstEditMPObjSemanticsDialog }

procedure TmstEditMPObjSemanticsDialog.Execute(aProject: TmstProjectMP; aDataSet: TDataSet);
begin
  PrepareNetStates();
  DataSource1.DataSet := aDataSet;
  if ShowModal = mrOk then
    aDataSet.Post
  else
    aDataSet.Cancel;
end;

procedure TmstEditMPObjSemanticsDialog.PrepareNetStates;
var
  I: Integer;
  S: string;
begin
  mdNetStates.Active := False;
  mdNetStates.Active := True;
  for I := 1 to MaxInt - 1 do
  begin
    S := TmstProjectMP.StatusName(I);
    if S = 'ошибка' then
      Break
    else
    begin
      mdNetStates.Insert;
      mdNetStatesID.AsInteger := I;
      mdNetStatesNAME.AsString := S;
      mdNetStates.Post;
    end;
  end;
end;

end.
