unit uMstDialogEditMPObjSemantics;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, DBCtrls, Mask,
  RxMemDS,
  uMStConsts,
  uMStClassesProjectsMP, uMStClassesMPVoltages, uMStClassesMPPressures;

type
  TmstEditMPObjSemanticsDialog = class(TForm)
    DataSource1: TDataSource;
    DBLookupComboBox1: TDBLookupComboBox;
    dsNetStates: TDataSource;
    mdNetStates: TRxMemoryData;
    mdNetStatesID: TIntegerField;
    mdNetStatesNAME: TStringField;
    lObjState: TLabel;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
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
    lLayer: TLabel;
    lNumber: TLabel;
    DBCheckBox5: TDBCheckBox;
    dsVoltage: TDataSource;
    mdVoltage: TRxMemoryData;
    IntegerField1: TIntegerField;
    StringField1: TStringField;
    mdPressure: TRxMemoryData;
    IntegerField2: TIntegerField;
    StringField2: TStringField;
    dsPressure: TDataSource;
    Label1: TLabel;
    DBLookupComboBox2: TDBLookupComboBox;
    Label9: TLabel;
    DBLookupComboBox3: TDBLookupComboBox;
  private
    procedure PrepareNetStates();
    procedure PreparePressures();
    procedure PrepareVoltages();
  public
    procedure Execute(aProject: TmstProjectMP; aDataSet: TDataSet);
  end;

implementation

{$R *.dfm}

uses
  uMStClassesMPStatuses;

{ TmstEditMPObjSemanticsDialog }

procedure TmstEditMPObjSemanticsDialog.Execute(aProject: TmstProjectMP; aDataSet: TDataSet);
begin
  PrepareNetStates();
  PreparePressures();
  PrepareVoltages();
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
  for I := TmstMPStatuses.MinId to TmstMPStatuses.MaxId do
  begin
    S := TmstMPStatuses.StatusName(I);
    mdNetStates.Insert;
    mdNetStatesID.AsInteger := I;
    mdNetStatesNAME.AsString := S;
    mdNetStates.Post;
  end;
end;

procedure TmstEditMPObjSemanticsDialog.PreparePressures;
var
  I: Integer;
begin
  mdPressure.Active := False;
  mdPressure.Active := True;
  for I := TmstMPPressures.MinId to TmstMPPressures.MaxId do
  begin
    mdPressure.Insert;
    mdPressure.FieldByName(SF_ID).AsInteger := I;
    mdPressure.FieldByName(SF_NAME).AsString := TmstMPPressures.StatusName(I);
    mdPressure.Post;
  end;
end;

procedure TmstEditMPObjSemanticsDialog.PrepareVoltages;
var
  I: Integer;
begin
  mdVoltage.Active := False;
  mdVoltage.Active := True;
  for I := TmstMPVoltages.MinId to TmstMPVoltages.MaxId do
  begin
    mdVoltage.Insert;
    mdVoltage.FieldByName(SF_ID).AsInteger := I;
    mdVoltage.FieldByName(SF_NAME).AsString := TmstMPVoltages.StatusName(I);
    mdVoltage.Post;
  end;
end;

end.
