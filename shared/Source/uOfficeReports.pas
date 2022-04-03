unit uOfficeReports;

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}

interface

uses
  Windows, ComObj, SysUtils, Graphics, Variants, Classes, ActiveX, StrUtils, DB, IOUtils,
  Clipbrd;

type

  TOfficeReport = class;
  TExcelReport = class;
  TWordReport = class;

  TSetRowEvent = procedure(Sender: TOfficeReport; oRow: Variant;
    sName: String; oDataSet: TDataSet) of object;

  TSetGraphgicState = (sgrUnknown, sgrOK, sgrError, sgrEmptyRange, sgrCantPasteShape,
    sgrShapeIsEmpty, sgrEmptyGraphic);
  TSetGraphicResult = record
    State: TSetGraphgicState;
    Message: string;
    Rs: HResult;
  end;

  TTemplateInfo = record
    FileName: String;
    FileType: String;
    Title: String;
    Subject: String;
    Author: String;
    Keywords: String;
    Comments: String;
  end;
  TTemplatesInfo = array of TTemplateInfo;

  TOfficeReport = class
  private
    fApp: Variant;
    fDoc: Variant;
    fPath: String;
    fUnloadOnDestroy: Boolean;
    FAppVersion: String;
    function GetVisible: Boolean;
    procedure SetVisible(const Value: Boolean);
  protected
    function GetClassName: String; virtual; abstract;
    function GetDocs: Variant; virtual; abstract;
    procedure LoadFromBlank(const sBlankPath: String);
    function GetRangeByName(sName: string; sField: String = ''): Variant; virtual; abstract;
  public
    constructor Create(const sBlankPath: String; NewApp: Boolean = False);
    destructor Destroy; override;
    //
    class function CreateReport(const sTemplatePath: String): TOfficeReport; overload; static;
    class function CreateReport(const TemplateInfo: TTemplateInfo): TOfficeReport; overload; static;
    class function EnumerateTemplates(sTemplatesPath: String): TTemplatesInfo; static;
    //
    procedure Protect(const sPassword: String = ''); virtual;
    procedure Unprotect(const sPassword: String = ''); virtual;
    procedure SaveAs(const sPath: String);
    procedure Save;
    procedure PrintOut; virtual;
    procedure PrintPreview; virtual;
    // Работа с таблицами
    function OpenTable(sName: String): Variant; virtual; abstract;
    function InsertTableRow(oTable: Variant;
      iRow: Integer = 0): Variant; virtual; abstract;
    procedure CloseTable(oTable: Variant); virtual; abstract;
    // Установить значение
    function  InsertGraphic(oRange: Variant; Graphic: TGraphic): TSetGraphicResult; virtual; abstract;
    function SetGraphic(const sName: String; Graphic: TGraphic): TSetGraphicResult; virtual; abstract;
    function SetGraphicField(oRow: Variant; sName, sField: String;
      Graphic: TGraphic): TSetGraphicResult; overload; virtual; abstract;
    //
    procedure SetValue(sName: String; Value: Variant); overload; virtual; abstract;
    procedure SetValue(sName: String; Color: TColor); overload; virtual; abstract;
    procedure SetValue(sName: String; Lines: TStrings); overload; virtual; abstract;
    //Alena 14/Dec/2004 удаление значений
    procedure SetValue(sName: String); overload; virtual; abstract;

    // Установить значение поля в стоке
    procedure SetField(oRow: Variant; sName, sField: String;
      Strings: TStrings); overload; virtual; abstract;
    procedure SetField(oRow: Variant; sName, sField: String;
      Value: Variant); overload; virtual; abstract;
    procedure SetField(oRow: Variant; sName, sField: String;
      Color: TColor); overload; virtual; abstract;
    procedure SetField(oRow: Variant; sName, sField: String); overload; virtual; abstract;

    // Установить значение датасета
    procedure SetDataSet(const sName: String; oDataSet: TDataSet;
      OnSetRow: TSetRowEvent = nil); virtual;
    //
    property App: Variant read fApp;
    property AppClassName: String read GetClassName;
    property Doc: Variant read fDoc;
    property UnloadOnDestroy: Boolean read fUnloadOnDestroy write fUnloadOnDestroy;
    property Visible: Boolean read GetVisible write SetVisible;
  end;

  TExcelReport = class(TOfficeReport)
  strict private
    const UseClipboardGraphic: Boolean = True;
  private
    FWorkCycle: Boolean; //Признак начала работы с циклическими ячейками
    FNoNeedPicturesID: String;//Список индексов для удаление - ненужные картинки Excel
    procedure RepairFormatFormulas(oTable: Variant; NewRowNum,
      OldRowNum: Integer);
    function InsertG1(oRange: Variant; Graphic: TGraphic): TSetGraphicResult;
    function InsertG2(oRange: Variant; aGraphic: TGraphic): TSetGraphicResult;
  protected
    function GetClassName: String; override;
    function GetDocs: Variant; override;
    function GetRangeByName(sName: string; sField: String = ''): Variant; override;
    function GetFieldRange(oRow: Variant; sName, sField: String): Variant;
    function IsNameExists(aName: String): Boolean;
    function IsGraphicExists(aGraphicName: String): Boolean;
    procedure DeleteNoNeedImages;
  public
    procedure Unprotect(const sPassword: String = ''); override;
    procedure Protect(const sPassword: String = ''); override;
    procedure PrintPreview; override;
    // Работа с таблицами
    function OpenTable(sName: String): Variant; override;
    function InsertTableRow(oTable: Variant; iRow: Integer = 0): Variant; override;
    procedure CloseTable(oTable: Variant); override;
    // Установить значение
    function InsertGraphic(oRange: Variant; Graphic: TGraphic): TSetGraphicResult; override;
    function SetGraphic(const sName: String; Graphic: TGraphic): TSetGraphicResult; override;
    function SetGraphicField(oRow: Variant; sName, sField: String;
      Graphic: TGraphic): TSetGraphicResult; override;
    //
    procedure SetValue(sName: String; Value: Variant); override;
    procedure SetValue(sName: String; Color: TColor); override;
    //Alena 14/Dec/2004 удаление значений
    procedure SetValue(sName: String); override;
    // Установить значение поля в стоке
    procedure SetField(oRow: Variant; sName, sField: String; Strings: TStrings); override;
    procedure SetField(oRow: Variant; sName, sField: String; Value: Variant); override;
   procedure SetField(oRow: Variant; sName, sField: String; Color: TColor); override;
  end;

  TWordReport = class(TOfficeReport)
  protected
    function GetClassName: String; override;
    function GetDocs: Variant; override;
    function GetRangeByName(sName: string; sField: String = ''): Variant; override;
    function IsNameExists(aName: String): Boolean;
  public
    procedure PrintPreview; override;
    // Работа с таблицами
    function OpenTable(sName: String): Variant; override;
    function InsertTableRow(oTable: Variant;
      iRow: Integer = 0): Variant; override;
    procedure CloseTable(oTable: Variant); override;
    // Установить значение
    function InsertGraphic(oRange: Variant; Graphic: TGraphic): TSetGraphicResult; override;
    function SetGraphic(const sName: String; Graphic: TGraphic): TSetGraphicResult; override;
    function SetGraphicField(oRow: Variant; sName, sField: String;
      Graphic: TGraphic): TSetGraphicResult; override;
    //
    procedure SetValue(sName: String; Value: Variant); override;
    procedure SetValue(sName: String; Lines: TStrings); override;
    procedure SetValue(sName: String; Color: TColor); override;
    //Alena 14/Dec/2004 удаление значений
    procedure SetValue(sName: String); override;
    // Установить значение поля в стоке
    procedure SetField(oRow: Variant; sName, sField: String;
      Strings: TStrings); override;
    procedure SetField(oRow: Variant; sName, sField: String;
      Value: Variant); override;
    procedure SetField(oRow: Variant; sName, sField: String;
      Color: TColor); override;
  end;

implementation

uses
  uExceptions, uFileUtils;

const
  xlShiftToRight = $FFFFEFBF;
  xlShiftDown    = $FFFFEFE7;
  xlShiftToLeft  = $FFFFEFC1;
  xlShiftUp      = $FFFFEFBE;

class function TOfficeReport.CreateReport(const sTemplatePath: String): TOfficeReport;
const TheMethod = 'uOfficeReports.CreateReport';
var
  Ext: String;
begin
  Result := nil;
  try
    Ext := UpperCase(ExtractFileExt(sTemplatePath));
    if Pos('.DOC', Ext) = 1 then
    begin
      Result := TWordReport.Create(sTemplatePath, False);
      Exit;
    end;
    if Pos('.XLS', Ext) = 1 then
    begin
      Result := TExcelReport.Create(sTemplatePath, True);
      Exit;
    end;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

class function TOfficeReport.CreateReport(const TemplateInfo: TTemplateInfo): TOfficeReport;
const TheMethod = 'TOfficeReport.CreateReport2';
begin
  Result := nil;
  try
    Result := CreateReport(TemplateInfo.FileName);
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure GetSummaryInfo(var Template: TTemplateInfo);
const TheMethod = 'uOfficeReports.GetSummaryInfo';
var
  sFileExt: String;
  PFileName: PWideChar;
  Storage: IStorage;
  PropSetStg: IPropertySetStorage;
  PropStg: IPropertyStorage;
  ps: PROPSPEC;
  pv: PROPVARIANT;

  function ReadStrValue(pv: PROPVARIANT): String;
  var
    S1: AnsiString;
  begin
    if pv.vt = VT_LPSTR then
    begin
      S1 := pv.pszVal;
      Result := String(S1);
    end
    else
    if pv.vt = VT_LPWSTR then
      Result := pv.pwszVal
    else
      Result := '';
  end;

const
  FMTID_SummaryInformation: TGUID = '{F29F85E0-4FF9-1068-AB91-08002B27B3D9}';
begin
  try
    sFileExt := UpperCase(ExtractFileExt(Template.FileName));
    if sFileExt = '.DOC' then
      Template.FileType := 'Microsoft Word document';
    if sFileExt = '.XLS' then
      Template.FileType := 'Microsoft Excel sheet';
    //
    PFileName := StringToOleStr(Template.FileName);
    try
      // Open compound storage
      OleCheck(StgOpenStorage(PFileName, nil,
        STGM_DIRECT or STGM_READ or STGM_SHARE_EXCLUSIVE, nil, 0, Storage));
    finally
      SysFreeString(PFileName);
    end;
    // Summary information is in a stream under the root storage
    PropSetStg := Storage as IPropertySetStorage;
    // Get the IPropertyStorage
    OleCheck(PropSetStg.Open(FMTID_SummaryInformation,
      STGM_DIRECT or STGM_READ or STGM_SHARE_EXCLUSIVE, PropStg));
    //
    ps.ulKind := PRSPEC_PROPID;
    // Read property
    ps.propid := PIDSI_TITLE;
    PropStg.ReadMultiple(1, @ps, @pv);
    Template.Title := ReadStrValue(pv);
    // Read property
    ps.propid := PIDSI_SUBJECT;
    PropStg.ReadMultiple(1, @ps, @pv);
    Template.Subject := ReadStrValue(pv);
    // Read property
    ps.propid := PIDSI_AUTHOR;
    PropStg.ReadMultiple(1, @ps, @pv);
    Template.Author := ReadStrValue(pv);
    // Read property
    ps.propid := PIDSI_KEYWORDS;
    PropStg.ReadMultiple(1, @ps, @pv);
    Template.Keywords := ReadStrValue(pv);
    // Read property
    ps.propid := PIDSI_COMMENTS;
    PropStg.ReadMultiple(1, @ps, @pv);
    Template.Comments := ReadStrValue(pv);
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

class function TOfficeReport.EnumerateTemplates(sTemplatesPath: String): TTemplatesInfo;
const TheMethod = 'TOfficeReport.EnumerateTemplates';
var
  oFileNames: TStringList;
  SearchRec: TSearchRec;
  i: Integer;
begin
  try
    oFileNames := TStringList.Create;
    try
      if FindFirst(sTemplatesPath, 0, SearchRec) = 0 then
      begin
        repeat
          oFileNames.Add(
            ExpandFileName(ExtractFilePath(sTemplatesPath) + SearchRec.Name));
        until FindNext(SearchRec) <> 0;
      end;
      //
      SetLength(Result, oFileNames.Count);
      for i := 0 to oFileNames.Count - 1 do begin
        Result[i].FileName := oFileNames[i];
        GetSummaryInfo(Result[i]);
      end;
    finally
      FindClose(SearchRec);
      oFileNames.Free;
    end;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

{ TOfficeReport }

constructor TOfficeReport.Create(const sBlankPath: String; NewApp: Boolean = False);
const TheMethod = 'OfficeReport.Create';
var
  Res: HResult;
  AppIntf: IUnknown;
  I: Integer;
begin
  try
    Res := GetActiveObject(ProgIDToClassID(GetClassName), nil, AppIntf);
    if (Res = MK_E_UNAVAILABLE) or NewApp then
      fApp := CreateOleObject(GetClassName)
    else
      fApp := GetActiveOleObject(GetClassName);
    FAppVersion := fApp.Version;
    I := Pos('.', FAppVersion);
    if I > 0 then
      SetLength(FAppVersion, Pred(I));
    fPath := '';
    fUnloadOnDestroy := True;
    LoadFromBlank(sBlankPath);
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

destructor TOfficeReport.Destroy;
const TheMethod = 'OfficeReport.Destroy';
begin
  try
    if fUnloadOnDestroy then
    begin
      if (not VarIsEmpty(fDoc)) and (not VarIsNull(fDoc)) then
      try
        if fPath <> '' then
          fDoc.Save
        else
          fDoc.Saved := True;
      except
      end;
      try
        fApp.Quit;
      except
      end;
    end;
    inherited;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr);
  end;
end;

function TOfficeReport.GetVisible: Boolean;
const TheMethod = 'TOfficeReport.GetVisible';
begin
  try
    Result := fApp.Visible;
  except
    Result := False;
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TOfficeReport.LoadFromBlank(const sBlankPath: String);
const TheMethod = 'TOfficeReport.LoadFromBlank';
var
  aDocs: Variant;
begin
  try
    aDocs := GetDocs;
    fDoc := aDocs.Open(sBlankPath);
    fPath := '';
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TOfficeReport.PrintOut;
const TheMethod = 'TOfficeReport.PrintOut';
begin
  try
    fDoc.PrintOut;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TOfficeReport.PrintPreview;
const TheMethod = 'TOfficeReport.PrintPreview';
begin
  try
    SetVisible(True);
    try
      fDoc.PrintPreview;
    except
    end;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TOfficeReport.Protect(const sPassword: String);
const TheMethod = 'TOfficeReport.Protect';
begin

end;

procedure TOfficeReport.Save;
const TheMethod = 'TOfficeReport.Save';
begin
  try
    if fPath <> '' then
      fDoc.Save;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TOfficeReport.SaveAs(const sPath: String);
const TheMethod = 'TOfficeReport.SaveAs';
begin
  try
    fPath := sPath;
    DeleteFile(fPath);
    fDoc.SaveAs(fPath);
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TOfficeReport.SetDataSet(const sName: String; oDataSet: TDataSet; OnSetRow: TSetRowEvent);
const TheMethod = 'TOfficeReport.SetDataSet';
var
  oTable: Variant;
  oRow: Variant;
  iField: Integer;
  sFieldName: String;
begin
  try
    oTable := OpenTable(sName);
    oDataSet.First;
    while not oDataSet.Eof do
    begin
      oRow := InsertTableRow(oTable, oDataSet.RecNo - 1);
      SetField(oRow, sName, 'ROWNUM', oDataSet.RecNo);
      for iField := 0 to oDataSet.Fields.Count - 1 do
      begin
        sFieldName := oDataSet.Fields[iField].FieldName;
        SetField(oRow, sName, sFieldName, oDataSet.Fields[iField].AsVariant);
      end;
      if Assigned(OnSetRow) then
      begin
        OnSetRow(Self, oRow, sName, oDataSet);
      end;
      oDataSet.Next;
    end;
    CloseTable(oTable);
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TOfficeReport.SetVisible(const Value: Boolean);
const TheMethod = 'TOfficeReport.SetVisible';
begin
  try
    fApp.Visible := Value;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TOfficeReport.Unprotect(const sPassword: String);
const TheMethod = 'TOfficeReport.Unprotect';
begin

end;

{ TWordReport }

procedure TWordReport.CloseTable(oTable: Variant);
const TheMethod = 'TWordReport.CloseTable';
begin

end;

function TWordReport.GetClassName: String;
const TheMethod = 'TWordReport.GetClassName';
begin
  try
    Result := 'Word.Application';
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

function TWordReport.GetDocs: Variant;
const TheMethod = 'TWordReport.GetDocs';
begin
  try
      Result := fApp.Documents;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

function TWordReport.GetRangeByName(sName, sField: String): Variant;
const TheMethod = 'TWordReport.GetRangeByName';
begin
  try
      if sField <> '' then
        sName := sName + '_' + sField;
      //md-77 11/Mar/2005
      if IsNameExists(sName) then
        Result := fDoc.Bookmarks.Item(sName).Range
      else
        Result := Unassigned;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

function TWordReport.IsNameExists(aName: String): Boolean;
const TheMethod = 'TWordReport.IsNameExists';
var
  i: Integer;
  sName: String;
begin
  Result := False;
  try
    //
      for i := 1 to fDoc.Bookmarks.Count do
      begin
        sName := fDoc.Bookmarks.Item(i).Name;
        //
        if AnsiUpperCase(sName) = AnsiUpperCase(aName) then
        begin
          Result := True;
          Exit;
        end;
      end;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

function TWordReport.InsertGraphic(oRange: Variant; Graphic: TGraphic): TSetGraphicResult;
const TheMethod = 'TWordReport.InsertGraphic';
var
  AFormat: Word;
  AData: THandle;
  APalette: HPALETTE;
  oShape, oShapes: Variant;
begin
  Result.State := sgrUnknown;
  Result.Message := '';
  Result.Rs := 0;
  try
    Graphic.SaveToClipboardFormat(AFormat, AData, APalette);
    Clipboard.SetAsHandle(AFormat, AData);
    oRange.Paste;
    Clipboard.Clear;
    //
    oShapes := fDoc.InlineShapes;
    oShape := oShapes.Item(oShapes.Count);
    if not VarIsEmpty(oShape) then
    begin
      oShape.PictureFormat.TransparentBackground := True;
      oShape.PictureFormat.TransparencyColor := ColorToRGB(clWhite);
      oShape.Fill.Visible := False;
      Result.State := sgrOK;
    end
    else
    begin
      Result.State := sgrCantPasteShape;
      Result.Message := TheMethod;
    end;
  except
    Result.State := sgrError;
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

function TWordReport.InsertTableRow(oTable: Variant; iRow: Integer): Variant;
const TheMethod = 'TWordReport.InsertTableRow';
var
  sBookmark: String;
  oBookmark: Variant;
  oRange: Variant;
  iStart, iEnd, iSize: Integer;
begin
  try
    Result := Unassigned;
    iStart := oTable.Start;
    iEnd := oTable.End;
    iSize := iEnd - iStart + 1;
    oBookmark := oTable.Bookmarks.Item(1);
    sBookmark := oBookmark.Name;
    if iRow > 1 then //md-77 23/Mar/2005 смена индекса в соответствии с изменениями в Excel
    begin
      oTable.Copy;
      oRange := fDoc.Range(oTable.Start, oTable.Start);
      oRange.Paste;
      oTable.End := iEnd + iSize - 1;
      oTable.Start := iStart + iSize - 1;
      fDoc.Bookmarks.Add(sBookmark, oTable);
    end;
    Result := oTable;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

function TWordReport.OpenTable(sName: String): Variant;
const TheMethod = 'TWordReport.OpenTable';
begin
  try
    Result := GetRangeByName(sName);
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TWordReport.PrintPreview;
const TheMethod = 'TWordReport.PrintPreview';
begin
  try
    fDoc.Saved := True;
    fUnloadOnDestroy := False;
    inherited;
    fApp.Activate;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TWordReport.SetField(oRow: Variant; sName, sField: String; Strings: TStrings);
const TheMethod = 'TWordReport.SetField';
begin
  try
    SetValue(sName + '_' + sField, Strings);
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TWordReport.SetField(oRow: Variant; sName, sField: String; Value: Variant);
const TheMethod = 'TWordReport.SetField';
begin
  try
    if Value <> ' ' then
      SetValue(sName + '_' + sField, Value)
    else
      SetValue(sName + '_' + sField);
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

function TWordReport.SetGraphicField(oRow: Variant; sName, sField: String;
  Graphic: TGraphic): TSetGraphicResult;
const TheMethod = 'TWordReport.SetGraphicField';
begin
  Result.State := sgrUnknown;
  Result.Message := '';
  Result.Rs := 0;
  try
    Result := SetGraphic(sName + '_' + sField, Graphic);
  except
    Result.State := sgrUnknown;
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TWordReport.SetField(oRow: Variant; sName, sField: String; Color: TColor);
const TheMethod = 'TWordReport.SetField';
begin
  try
    SetValue(sName + '_' + sField, Color);
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TWordReport.SetValue(sName: String; Value: Variant);
const TheMethod = 'TWordReport.SetValue';
var
  oRange: Variant;
begin
  try
    oRange := GetRangeByName(sName);
    //md-77 10/Mar/2005
    if VarIsEmpty(oRange) then
      Exit;
    //
    if VarIsStr(Value) then
      oRange.Text := String(Value)
    else
      oRange.Text := Value;
    fDoc.Bookmarks.Add(sName, oRange);
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TWordReport.SetValue(sName: String);
const TheMethod = 'TWordReport.SetValue';
var
  oRange: Variant;
begin
  try
    oRange := GetRangeByName(sName);
    if VarIsEmpty(oRange) then
      Exit;
    oRange.Cut;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

function TWordReport.SetGraphic(const sName: String; Graphic: TGraphic): TSetGraphicResult;
const TheMethod = 'TWordReport.SetGraphic';
var
  oRange: Variant;
begin
  Result.State := sgrUnknown;
  Result.Message := '';
  Result.Rs := 0;
  try
    oRange := GetRangeByName(sName);
    //md-77 10/Mar/2005
    if VarIsEmpty(oRange) then
      Result.State := sgrEmptyRange
    else
    begin
      Result := InsertGraphic(oRange, Graphic);
      fDoc.Bookmarks.Add(sName, oRange);
    end;
  except
    Result.State := sgrError;
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TWordReport.SetValue(sName: String; Color: TColor);
const TheMethod = 'TWordReport.SetValue';
var
  oRange: Variant;
begin
  try
    oRange := GetRangeByName(sName);
    //md-77 10/Mar/2005
    if VarIsEmpty(oRange) then
      Exit;
    oRange.Cells.Shading.BackgroundPatternColor := ColorToRGB(Color);
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TWordReport.SetValue(sName: String; Lines: TStrings);
const TheMethod = 'TWordReport.SetValue';
var
  oRange: Variant;
begin
  try
    oRange := GetRangeByName(sName);
    //md-77 10/Mar/2005
    if VarIsEmpty(oRange) then
      Exit;
    //
    oRange.Text := String(Lines.Text);
    fDoc.Bookmarks.Add(sName, oRange);
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

{ TExcelReport }

procedure TExcelReport.CloseTable(oTable: Variant);
const TheMethod = 'TExcelReport.CloseTable';
begin
  try
    if VarIsEmpty(oTable) then
      Exit;
    //
    oTable.Delete(xlShiftUp);
    FWorkCycle := False; //Признак начала работы с циклическими ячейками
except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

function TExcelReport.GetClassName: String;
const TheMethod = 'TExcelReport.GetClassName';
begin
  try
    Result := 'Excel.Application';
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

function TExcelReport.GetDocs: Variant;
const TheMethod = 'TExcelReport.GetDocs';
begin
  try
    Result := fApp.Workbooks;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

function TExcelReport.GetFieldRange(oRow: Variant; sName, sField: String): Variant;
const TheMethod = 'TExcelReport.GetFieldRange';
var
  oTable: Variant;
begin
  try
    oTable := GetRangeByName(sName);
    Result := GetRangeByName(sName, sField);
    //md-77 09/Mar/2005 Нет таких ячеек
    if VarIsEmpty(oTable) or VarIsEmpty(Result) then
    begin
      Result := Unassigned;
      Exit;
    end;
    //
    if oTable.Rows.Count < oTable.Columns.Count then
    begin
      Result.Offset[oRow.Row - oTable.Row, 0]; //10/Mar/2005 md-77 без прислвоения Result
      //Так как на большом количестве компьютеров Offset в данной ситуации не работает
      //Result := Result.Offset[oRow.Row - oTable.Row, 0];
    end
    else
    begin
      Result := Result.Offset[0, oRow.Column - oTable.Column];
    end;
    //if Result.MergeCells then
    //  Result.MergeArea[1, 1];
    Result.Worksheet.Activate;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

function TExcelReport.GetRangeByName(sName, sField: String): Variant;
const TheMethod = 'TExcelReport.GetRangeByName';
var
  oName: Variant;
begin
  try
    if sField <> '' then
    begin
      sName := sName + '_' + sField;
    end;
    //md-77 09/Mar/2005 проверка имени в шаблоне
    if IsNameExists(sName) then
      oName := fDoc.Names.Item(sName)
    else
      oName := Unassigned;
    //md-77 09/Mar/2005
    if VarIsEmpty(oName) then
      Result := Unassigned
    else
    begin
      Result := oName.RefersToRange;
      Result.Worksheet.Activate;
    end;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

function TExcelReport.IsNameExists(aName: String): Boolean;
const TheMethod = 'TExcelReport.IsNameExists';
var
  i: Integer;
  sName: String;
begin
  Result := False;
  try
    for i := 1 to fDoc.Names.Count do
    begin
      sName := fDoc.Names.Item(i).Name;
      //
      if AnsiUpperCase(sName) = AnsiUpperCase(aName) then
      begin
        Result := True;
        Exit;
      end;
    end;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

function TExcelReport.InsertG1(oRange: Variant; Graphic: TGraphic): TSetGraphicResult;
const TheMethod = 'TExcelReport.InsertG1';
var
  AFormat: Word;
  AData: THandle;
  APalette: HPALETTE;
  oShape, oShapes, oSingleShape: Variant;
  C1, C2: Integer;
begin
  Result.State := sgrUnknown;
  Result.Message := '';
  Result.Rs := 0;
  try
    oShape := Unassigned;
    Graphic.SaveToClipboardFormat(AFormat, AData, APalette);
    Clipboard.SetAsHandle(AFormat, AData);
    try
      oShapes := fApp.ActiveSheet.Shapes;
      C1 := oShapes.Count;
      oRange.Select;
      Result.Rs := oRange.PasteSpecial;
      C2 := oShapes.Count;
      Clipboard.Clear;
      //
      oShape := fApp.Selection;
      oShape.Top := oShape.Top + 2;
      oShape.Left := oShape.Left + 2;
      //md-77 23/Mar/2005 Make icon transparent
      oSingleShape := oShapes.Item(oShapes.Count);
      if not VarIsEmpty(oSingleShape) then
      begin
        if FAppVersion <> '12' then
        begin
          oSingleShape.PictureFormat.TransparentBackground := True;
          oSingleShape.PictureFormat.TransparencyColor := ColorToRGB(clWhite);
          oSingleShape.Fill.Visible := False;
        end;
      end;
      //
      if C1 = C2 then
      begin
        Result.State := sgrCantPasteShape;
        Result.Message := TheMethod;
      end
      else
      if VarIsEmpty(oSingleShape) then
      begin
        Result.State := sgrShapeIsEmpty;
        Result.Message := TheMethod;
      end;
      //
      if FWorkCycle then
      begin
        //Записываем индексы только что добавленных картинок, чтобы после копирвоания в новую строку
        //удалить временные, это нужно только в Excel
        //Различить можно только по индекусу, так при присвоении имени только что вставленной картинке
        //После копирования будут две картинки с одним и тем же именем - такая фича...
        //Но при удалении нумерация картинок продолжается, несмотря что например "Рисунок2" был удален
        //Следующий буде называться "Рисунок3", на самом деле это не имя, а сквозной индекс
        if FNoNeedPicturesID <> '' then
          FNoNeedPicturesID := FNoNeedPicturesID + sLineBreak + IntToStr(fApp.ActiveSheet.Shapes.Count)
        else
          FNoNeedPicturesID := IntToStr(fApp.ActiveSheet.Shapes.Count);
      end;
    except
      on E: Exception do
      begin
        Result.State := sgrError;
        Result.Message := TheMethod + sLineBreak + E.Message;
      end;
    end;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

function TExcelReport.InsertG2(oRange: Variant; aGraphic: TGraphic): TSetGraphicResult;
const TheMethod = 'TExcelReport.InsertG2';
var
  oShape, oShapes, oSingleShape: Variant;
  C1, C2, W, H, Wg, Hg, PPi: Integer;
  aFileName: string;
  K: Double;
begin
  Result.State := sgrUnknown;
  Result.Message := '';
  Result.Rs := 0;
  try
    oShape := Unassigned;
    //
    aFileName := TPath.GetTempPath + TPath.GetGUIDFileName;
    aGraphic.SaveToFile(aFileName);
    try
      try
        oShapes := fApp.ActiveSheet.Shapes;
        C1 := oShapes.Count;
        PPi := fApp.DefaultWebOptions.PixelsPerInch;
        Wg := fApp.InchesToPoints(aGraphic.Width / PPi);
        Hg := fApp.InchesToPoints(aGraphic.Height / PPi);
        if (Wg > 1) and (Hg > 1) then
        begin
          W := oRange.Width;
          H := oRange.Height;
          K := W / Wg;
          if H < (Hg * K) then
            K := H / Hg;
          Wg := Round(Wg * K);
          Hg := Round(Hg * K);
          oShape := oShapes.AddPicture(aFilename, $00000000, $FFFFFFFF, oRange.Left, oRange.Top,
            Wg - 3, Hg - 3);
          C2 := oShapes.Count;
          //
          oShape.Top := oShape.Top + 2;
          oShape.Left := oShape.Left + 2;
          //md-77 23/Mar/2005 Make icon transparent
          oSingleShape := oShapes.Item(oShapes.Count);
          if not VarIsEmpty(oSingleShape) then
          begin
            if FAppVersion <> '12' then
            begin
              oSingleShape.PictureFormat.TransparentBackground := True;
              oSingleShape.PictureFormat.TransparencyColor := ColorToRGB(clWhite);
              oSingleShape.Fill.Visible := False;
            end;
          end;
          //
          if C1 = C2 then
          begin
            Result.State := sgrCantPasteShape;
            Result.Message := TheMethod;
          end
          else
          if VarIsEmpty(oSingleShape) then
          begin
            Result.State := sgrShapeIsEmpty;
            Result.Message := TheMethod;
          end;
          //
          if FWorkCycle then
          begin
            //Записываем индексы только что добавленных картинок, чтобы после копирвоания в новую строку
            //удалить временные, это нужно только в Excel
            //Различить можно только по индекусу, так при присвоении имени только что вставленной картинке
            //После копирования будут две картинки с одним и тем же именем - такая фича...
            //Но при удалении нумерация картинок продолжается, несмотря что например "Рисунок2" был удален
            //Следующий буде называться "Рисунок3", на самом деле это не имя, а сквозной индекс
            if FNoNeedPicturesID <> '' then
              FNoNeedPicturesID := FNoNeedPicturesID + sLineBreak + IntToStr(fApp.ActiveSheet.Shapes.Count)
            else
              FNoNeedPicturesID := IntToStr(fApp.ActiveSheet.Shapes.Count);
          end;
        end
        else
        begin
          Result.State := sgrEmptyGraphic;
          Result.Message := TheMethod;
        end;
      except
        on E: Exception do
        begin
          Result.State := sgrError;
          Result.Message := TheMethod + sLineBreak + E.Message;
        end;
      end;
    finally
      DeleteFile(aFileName);
    end;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

function TExcelReport.InsertGraphic(oRange: Variant; Graphic: TGraphic): TSetGraphicResult;
const TheMethod = 'TExcelReport.InsertGraphic';
begin
  Result.State := sgrUnknown;
  Result.Message := '';
  Result.Rs := 0;
  try
    if UseClipboardGraphic then
    begin
      Result := InsertG1(oRange, Graphic);
      if Result.State <> sgrOK then
        Result := InsertG2(oRange, Graphic);
    end
    else
      Result := InsertG2(oRange, Graphic);
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

function TExcelReport.IsGraphicExists(aGraphicName: String): Boolean;
const TheMethod = 'TExcelReport.IsGraphicExists';
var
  i: Integer;
  sName: String;
begin
  Result := False;
  try
    for i := 1 to fApp.ActiveSheet.Shapes.Count do
    begin
      sName := fApp.ActiveSheet.Shapes.Item(i).Name;
      //
      if AnsiUpperCase(sName) = AnsiUpperCase(aGraphicName) then
      begin
        Result := True;
        Exit;
      end;
    end;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

const
  xlDown = $FFFFEFE7;
  xlToLeft = $FFFFEFC1;
  xlToRight = $FFFFEFBF;
  xlUp = $FFFFEFBE;

procedure ClearExcelRangeValues(aRange: Variant);
const TheMethod = 'uOfficeReports.ClearExcelRangeValues';
var
  I, C: Integer;
  aCell: Variant;
begin
  try
    C := aRange.Count;
    for I := 1 to C do
    begin
      aCell := aRange.Item[I];
      if not aCell.HasFormula then
        aCell.Value := '';
    end;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

function TExcelReport.InsertTableRow(oTable: Variant;
  iRow: Integer): Variant;
const TheMethod = 'TExcelReport.InsertTableRow';
const
  xlPasteFormats = $FFFFEFE6;
  xlPasteSpecialOperationNone = $FFFFEFD2;
begin
  try
      if VarIsEmpty(oTable) then
        Exit;
      //
      if oTable.Rows.Count < oTable.Columns.Count then
      begin
        // Insert empty row
        Result := oTable.Offset[iRow * oTable.Rows.Count, 0];
        if iRow > 1 then
        begin
          Result := oTable.Offset[Pred(iRow) * oTable.Rows.Count, 0];
          Result.Insert(xlShiftDown);
          // Copy data and format from template row to new one
          Result := oTable.Offset[Pred(iRow) * oTable.Rows.Count, 0];
          oTable.Copy(Result);
  //        ClearExcelRangeValues(oTable);
  //        oTable.Value := '';
          DeleteNoNeedImages;
        end;
      end
      else
      begin
        // Insert empty column
        Result := oTable.Offset[0, iRow * oTable.Columns.Count];
        Result.Insert(xlShiftToRight);
        // Copy data and format from template row to new one
        Result := oTable.Offset[0, iRow * oTable.Columns.Count];
        oTable.Copy(Result);
        RepairFormatFormulas(Result, iRow + 3, oTable.Row);
        DeleteNoNeedImages;
      end;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

const
  xlCellValue = $00000001;
  xlExpression = $00000002;

procedure TExcelReport.RepairFormatFormulas(oTable: Variant;
  NewRowNum, OldRowNum: Integer);
const TheMethod = 'TExcelReport.RepairFormatFormulas';
var
  aCell, FC, F1, F2, Op: Variant;
  I, J, L: Integer;
  F1s, F2s, OldRowStr, NewRowStr: String;
begin
  try
    if FAppVersion = '12' then
      Exit;
      OldRowStr := '$' + IntToStr(OldRowNum);
      NewRowStr := '$' + IntToStr(NewRowNum);
      L := Length(OldRowStr);
      for I := 1 to oTable.Count do
      begin
        aCell := oTable.Cells[I];
    //    aCell := oTable;
        for J := 1 to aCell.FormatConditions.Count do
        begin
          FC := aCell.FormatConditions[J];
          F1 := FC.Formula1;
          if not(VarIsNull(F1) or VarIsEmpty(F1)) then
          begin
            F1s := F1;
            if AnsiEndsStr(OldRowStr, F1s) then
            begin
              SetLength(F1s, Length(F1s) - L);
              F1 := F1s + NewRowStr;
            end
            else
            begin
              F1s := StringReplace(F1s, OldRowStr + ' ', NewRowStr + ' ', [rfReplaceAll]);
              F1 := F1s;
            end;
          end;
          //
          try
            Op := FC.Operator;
          except
            Op := 3;  // equals
          end;
          //
          try
            F2 := FC.Formula2;
            //
            if not (VarIsNull(F2) or VarIsEmpty(F2)) then
            begin
              F2s := F2;
              if AnsiEndsStr(OldRowStr, F2s) then
              begin
                SetLength(F2s, Length(F2s) - L);
                F2 := F2s + NewRowStr;
              end
              else
              begin
                F2s := StringReplace(F2s, OldRowStr + ' ', NewRowStr + ' ', [rfReplaceAll]);
                F2 := F2s;
              end;
            end;
          except
            F2 := EmptyParam;
          end;
          //
          FC.Modify(FC.Type, Op, F1, F2);
        end;
      end;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TExcelReport.DeleteNoNeedImages;
const TheMethod = 'TExcelReport.DeleteNoNeedImages';
var
  i: Integer;
  slImages: TStringList;
begin
  try
      slImages := TStringList.Create;
      try
        slImages.Text := FNoNeedPicturesID;
        //Метим все что нужно удалить дохлым именем
        for i := 1 to fApp.ActiveSheet.Shapes.Count do
        begin
          if slImages.IndexOf(IntToStr(i)) <> - 1 then
            fApp.ActiveSheet.Shapes.Item(i).Name := 'delete_me'; //ooohh delete me! delete me!!! aaaahh..
        end;
        //Удаляем что пометили
        while IsGraphicExists('delete_me') do
        begin
          //Так заУмно, потому что количество уменьшается, а мы прокручиваем по количеству
          //чтобы не было обращений к несуществующему элементу
          //Я не нашел как идентифицировать картинку в наборе картинок, иначе чем через индекс
          //этого набора... Вот если бы был инкрементальный уникальный ID, который бы при
          //копировании оставался уникальным, было бы попроще...
          for i := 1 to fApp.ActiveSheet.Shapes.Count do
          begin
            if fApp.ActiveSheet.Shapes.Item(i).Name = 'delete_me' then
            begin
              fApp.ActiveSheet.Shapes.Item(i).Delete;
              Break;
            end;
          end;
        end;
        //
      finally
        if slImages <> nil then
          slImages.Free;
      end;
      FNoNeedPicturesID := '';
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

function TExcelReport.OpenTable(sName: String): Variant;
const TheMethod = 'TExcelReport.OpenTable';
begin
  try
    FWorkCycle := True; //Признак начала работы с циклическими ячейками
    FNoNeedPicturesID := '';
    Result := GetRangeByName(sName);
    //Result := Result.EntireRow;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TExcelReport.PrintPreview;
const TheMethod = 'TExcelReport.PrintPreview';
{var
  bVisible: Boolean;}
begin
  try
    //start md-77 Don't Close Excel after Preview - John can Save Document
    fDoc.Saved := True;
    fUnloadOnDestroy := False;
    //start md-77 Don't Close Excel after Preview - John can Save Document
    //bVisible := GetVisible;
    inherited;
    //SetVisible(bVisible); //Comment - refer to upper fix
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TExcelReport.Protect(const sPassword: String);
const TheMethod = 'TExcelReport.Protect';
var
  iWorksheet: Integer;
begin
  try
    for iWorksheet := 1 to fDoc.Worksheets.Count do
    begin
      fDoc.Worksheets[iWorksheet].Protect(sPassword);
    end;
    fDoc.Protect(sPassword);
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TExcelReport.SetField(oRow: Variant; sName, sField: String; Strings: TStrings);
const TheMethod = 'TExcelReport.SetField';
var
  oCell: Variant;
  oWorksheet: Variant;
  iHeight: Integer;
  sText: String;
begin
  try
    oCell := GetFieldRange(oRow, sName, sField);
    //md-77 10/Mar/2005
    if VarIsEmpty(oCell) then
      Exit;
    // Set height
    oWorksheet := oCell.Worksheet;
    iHeight := oWorksheet.StandardHeight * Strings.Count;
    if iHeight > oCell.Height then
      oCell.RowHeight := iHeight;
    // Set text
    sText := Strings.Text;
    sText := StringReplace(sText, #13, '', [rfReplaceAll]);
    oCell.Value := String(sText);
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

function TExcelReport.SetGraphicField(oRow: Variant; sName, sField: String; Graphic: TGraphic): TSetGraphicResult;
const TheMethod = 'TExcelReport.SetGraphicField';
var
  oCell: Variant;
begin
  Result.State := sgrUnknown;
  Result.Message := '';
  Result.Rs := 0;
  try
    oCell := GetFieldRange(oRow, sName, sField);
    //md-77 10/Mar/2005
    if VarIsEmpty(oCell) then
      Result.State := sgrEmptyRange
    else
      Result := InsertGraphic(oCell, Graphic);
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TExcelReport.SetField(oRow: Variant; sName, sField: String; Color: TColor);
const TheMethod = 'TExcelReport.SetField';
var
  oCell: Variant;
begin
  try
    oCell := GetFieldRange(oRow, sName, sField);
    //md-77 10/Mar/2005
    if VarIsEmpty(oCell) then
      Exit;
    oCell.Interior.Color := ColorToRGB(Color);
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TExcelReport.SetField(oRow: Variant; sName, sField: String; Value: Variant);
const TheMethod = 'TExcelReport.SetField';
var
  oCell: Variant;
begin
  try
      oCell := GetFieldRange(oRow, sName, sField);
      //md-77 09/Mar/2005 Нет ячеек
      if VarIsEmpty(oCell) then
        Exit;
      //
      if VarIsStr(Value) then
        oCell.Value := String(Value)
      else
        oCell.Value := Value;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

function TExcelReport.SetGraphic(const sName: String; Graphic: TGraphic): TSetGraphicResult;
const TheMethod = 'TExcelReport.SetGraphic';
var
  oRange: Variant;
begin
  Result.State := sgrUnknown;
  Result.Message := '';
  Result.Rs := 0;
  try
    oRange := GetRangeByName(sName);
    if VarIsEmpty(oRange) then
      Result.State := sgrEmptyRange
    else
      Result := InsertGraphic(oRange, Graphic);
  except
    Result.State := sgrError;
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TExcelReport.SetValue(sName: String; Color: TColor);
const TheMethod = 'TExcelReport.SetValue';
var
  oRange: Variant;
begin
  try
    oRange := GetRangeByName(sName);
    if VarIsEmpty(oRange) then
      Exit;
    oRange.Interior.Color := ColorToRGB(Color);
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TExcelReport.SetValue(sName: String; Value: Variant);
const TheMethod = 'TExcelReport.SetValue';
var
  oRange: Variant;
begin
  try
    oRange := GetRangeByName(sName);
    if VarIsEmpty(oRange) then
      Exit;
    //
    if VarIsStr(Value) then
      oRange.Value := String(Value)
    else
      oRange.Value := Value;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TExcelReport.Unprotect(const sPassword: String);
const TheMethod = 'TExcelReport.Unprotect';
var
  iWorksheet: Integer;
begin
  try
    fDoc.Unprotect(sPassword);
    for iWorksheet := 1 to fDoc.Worksheets.Count do
      fDoc.Worksheets[iWorksheet].Unprotect(sPassword);
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

procedure TExcelReport.SetValue(sName: String);
const TheMethod = 'TExcelReport.SetValue';
var
  oRange: Variant;
begin
  try
    oRange := GetRangeByName(sName);
    if VarIsEmpty(oRange) then
      Exit;
    oRange.ClearContents;
  except
    ExceptInternal(TheMethod, ExceptObject, ExceptAddr, True);
  end;
end;

end.
