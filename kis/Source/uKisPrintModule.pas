{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Модуль печать                                   }
{                                                       }
{       Copyright (c) 2005, МП УГА                      }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание:
  Имя модуля: Print Module
  Версия: 1.01
  Дата последнего изменения: 
  Цель: содержит класс для печать отчетов
  Используется:
  Использует:
  Исключения:   }
{
  1.01    28.06.2005
     - при создании модуля FastReport'у устанавливается дефолтный принтер

  1.00
     - первая версия
}
unit uKisPrintModule;

interface

{$I KisFlags.pas}

uses
  // System
  SysUtils, Classes, DB, IBDatabase,
  // FastReport
  FR_Shape, FR_E_CSV, FR_DCtrl, FR_Class, FR_E_TXT, FR_IBXDB, FR_IBXQUERY,
  FR_E_RTF, FR_DSet, FR_DBSet, FR_Desgn, frRtfExp,
  // Common
  uGC, FR_ChBox;

type
  TKisPrintModule = class(TDataModule)
    frReport: TfrReport;
    frDesigner: TfrDesigner;
    frDataSet: TfrDBDataSet;
    RTFExport: TfrRTFExport;
    DialogControls: TfrDialogControls;
    CSVExport: TfrCSVExport;
    frDataSetAdditional: TfrDBDataSet;
    ShapeObject: TfrShapeObject;
    UserDataset: TfrUserDataset;
    RtfAdvExport: TfrRtfAdvExport;
    frCheckBoxObject: TfrCheckBoxObject;
  private
    FLastPrinterIndex: Integer;
    procedure Init;
    function GetReportFileName: String;
    procedure SetReportFileName(const Value: String);
    function GetReportTitle: String;
    procedure SetReportTitle(const Value: String);
  public
    constructor Create(AOwner: tComponent); override;
    // назначает DataSet для бэнда с именем BandName
    procedure SetMasterDataSet(DataSet: TDataSet; const BandName: String);
    procedure SetAdditionalDataSet(DataSet: TDataSet; const BandName: String);
    procedure SetReportTransaction(Transaction: TIBTransaction;
      const ObjectName: String = '');
    procedure SetParamValue(const ParamName: String; const Value: Variant);
    function ParamExists(const ParamName: String): Boolean;
    procedure SetPictureFromStream(Stream: TStream; const ObjectName: String);
    procedure PrintReport;
    property ReportFile: String read GetReportFileName write SetReportFileName;
    property ReportTitle: String read GetReportTitle write SetReportTitle;
  end;

  function PrintModule(DoInit: Boolean = True): TKisPrintModule;

implementation

{$R *.dfm}

uses
  // Sysytem
  Forms, Printers, Variants,
  // fastReport
  FR_Prntr,
  // Project
  uKisConsts;

var
  KisPrintModule: TKisPrintModule;

function PrintModule(DoInit: Boolean): TKisPrintModule;
begin
  if not Assigned(KisPrintModule) then
  begin
    KisPrintModule := TKisPrintModule.Create(Application);
    DoInit := True;
  end;
  if DoInit then
    KisPrintModule.Init;
  Result := KisPrintModule;
end;

{ TKisPrintModule }

constructor TKisPrintModule.Create(AOwner: tComponent);
begin
  inherited;
  FR_Prntr.Prn.Printer := Printer;
  FLastPrinterIndex := FR_Prntr.Prn.PrinterIndex;
end;

function TKisPrintModule.GetReportFileName: String;
begin
  Result := frReport.FileName;
end;

function TKisPrintModule.GetReportTitle: String;
begin
  Result := frReport.Title;
end;

procedure TKisPrintModule.Init;
begin
  frReport.FileName := '';
  frReport.Clear;
end;

function TKisPrintModule.ParamExists(const ParamName: String): Boolean;
begin
  Result := frReport.Dictionary.Variables.IndexOf(ParamName) >= 0;
end;

procedure TKisPrintModule.PrintReport;
begin
  frReport.ChangePrinter(0, FLastPrinterIndex);
  frReport.ShowReport;
  FLastPrinterIndex := FR_Prntr.Prn.PrinterIndex;
end;

procedure TKisPrintModule.SetAdditionalDataSet(DataSet: TDataSet;
  const BandName: String);
var
  Band: TfrBandView;
begin
  frDataSetAdditional.DataSet := DataSet;
  Band := TfrBandView(frReport.FindObject(BandName));
  if Assigned(Band) and (Band is TfrBandView) then
      Band.DataSet := 'frDataSetAdditional';
end;

procedure TKisPrintModule.SetMasterDataSet(DataSet: TDataSet;
  const BandName: String);
var
  MasterData: TfrView;
begin
  frDataSet.DataSet := DataSet;
  MasterData := frReport.FindObject(BandName);
  if Assigned(MasterData) and (MasterData is TfrBandView) then
      TfrBandView(MasterData).DataSet := 'frDataSet';
end;

procedure TKisPrintModule.SetParamValue(const ParamName: String;
  const Value: Variant);
begin
  if VarType(Value) <> varBoolean then
    frReport.Dictionary.Variables[ParamName] := QuotedStr(Value)
  else
    frReport.Dictionary.Variables[ParamName] := Value;
end;

procedure TKisPrintModule.SetPictureFromStream(Stream: TStream;
  const ObjectName: String);
var
  Obj: TObject;
begin
  Obj := frReport.FindObject(ObjectName);
  if Assigned(Obj) then
  if not (Obj is TfrPictureView) then
    Obj := nil;
  if Assigned(Obj) then
  begin
    Stream.Position := 0;
    TfrPictureView(Obj).Picture.Bitmap.LoadFromStream(Stream);
  end;
end;

procedure TKisPrintModule.SetReportFileName(const Value: String);
var
  Dir: String;
begin
  if not FileExists(Value) then
    raise Exception.Create(S_FILE + S_NOT_FOUND + #13 + Value);
  frReport.LoadFromFile(Value);
  Dir := GetCurrentDir;
  SetCurrentDir(Dir);
end;

procedure TKisPrintModule.SetReportTitle(const Value: String);
begin
  frReport.Title := Value;
end;

procedure TKisPrintModule.SetReportTransaction(Transaction: TIBTransaction;
  const ObjectName: String);
var
  I, J, C: Integer;
  P: TfrView;
begin
  if ObjectName = '' then
  with frReport do
  begin
    for I := 0 to Pred(Pages.Count) do
    begin
      C := Pred(Pages[I].Objects.Count);
      for J := 0 to C do
      begin
        P := Pages[I].Objects[J];
        if Assigned(P) and (P is TfrIBXQuery) then
           TfrIBXQuery(P).Query.Transaction := Transaction;
      end;
    end;
  end
  else
  begin
    P := frReport.FindObject(ObjectName);
    if Assigned(P) and (P is TfrIBXQuery) then
       TfrIBXQuery(P).Query.Transaction := Transaction;
  end;
end;

initialization
  KisPrintModule := nil;

end.

