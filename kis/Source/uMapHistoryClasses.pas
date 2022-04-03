unit uMapHistoryClasses;

interface

uses
  SysUtils, Classes, Contnrs, Controls, Graphics, Types, DB,
  uKisEntityEditor, uKisMap500Graphics, uKisClasses;

type
  TKisMap500Figure = class(TKisEntity)
  private
    FPoints: TList;
    FHistoryElementId: Integer;
    FFigureType: Boolean;
    FFigureColor: TColor;
    FExtent: TRect;
    procedure SetHistoryElementId(const Value: Integer);
    procedure SetFigureType(const Value: Boolean);
    procedure SetFigureColor(const Value: TColor);
    function GetPoints(Index: Integer): TPoint;
    procedure AddPoint(X, Y: Integer);
    procedure ClearPoints;
    procedure DeleteLastPoint(Sender: TObject);
    function GetPointCount: Integer;
    procedure DrawPolyLine(Canvas: TCanvas; const aExtent: TRect);
    procedure DrawPoint(const X, Y: Integer; Canvas: TCanvas);
    procedure CopyPoints(aPoints: TList);
  public
    constructor Create(Mngr: TKisMngr); override;
    destructor Destroy; override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    procedure Draw(Canvas: TCanvas; const aExtent: TRect);
    function Clone: TKisMap500Figure;
    property Points[Index: Integer]: TPoint read GetPoints;
    property HistoryElementId: Integer read FHistoryElementId write SetHistoryElementId;
    property FigureType: Boolean read FFigureType write SetFigureType;
    property FigureColor: TColor read FFigureColor write SetFigureColor;
    property PointCount: Integer read GetPointCount;
  end;

  /// <summary>
  /// Элемент истории планшета.  
  /// </summary>
  TKisMapHistoryElement = class(TKisVisualEntity)
  private
    FMap500Id: Integer;
    FOrderNumber: String;
    FDateOfWorks: String;
    FWorksExecutor: String;
    FHorizontalMapping: String;
    FHighRiseMapping: String;
    FMensMapping: String;
    FTacheometricMapping: String;
    FCurrentChangesMapping: String;
    FNewlyBuildingMapping: String;
    FEnginNetMapping: String;
    FTotalSum: String;
    FDraftWorksExecutor: String;
    FChief: String;
    FDateOfAccept: String;
    FFigures: TObjectList;
    FGraphicsEditor: TKisMap500Graphics;
    FFiguresState: TkisFiguresState;
    procedure SetMap500Id(const Value: Integer);
    procedure SetOrderNumber(const Value: String);
    procedure SetDateOfWorks(const Value: String);
    procedure SetWorksExecutor(const Value: String);
    procedure SetHorizontalMapping(const Value: String);
    procedure SetHighRiseMapping(const Value: String);
    procedure SetMensMapping(const Value: String);
    procedure SetTacheometricMapping(const Value: String);
    procedure SetCurrentChangesMapping(const Value: String);
    procedure SetNewlyBuildingMapping(const Value: String);
    procedure SetEnginNetMapping(const Value: String);
    procedure SetTotalSum(const Value: String);
    procedure SetDraftWorksExecutor(const Value: String);
    procedure SetChief(const Value: String);
    procedure SetDateOfAccept(const Value: String);
    procedure DrawHistoryElement(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    function GetFigures(Index: Integer): TKisMap500Figure;
    function GetSurveyImage(const ImageWidth, ImageHeight: Integer): TBitmap;
    procedure UpdateEditorBySurveyImage;
    procedure UpdateGraphEditorByState;
    procedure CopyFigures(aFiguresList: TObjectList);
  protected
    procedure SetID(const Value: Integer); override;
    function CreateEditor: TKisEntityEditor; override;
    procedure PrepareEditor(AEditor: TKisEntityEditor); override;
    procedure LoadDataIntoEditor(AEditor: TKisEntityEditor); override;
    procedure ReadDataFromEditor(AEditor: TKisEntityEditor); override;
    function CheckEditor(AEditor: TKisEntityEditor): Boolean; override;

    //графическая часть
    procedure EditMap(Sender: TObject);
    procedure PrepareFiguresEditor(Editor: TKisEntityEditor);
    procedure CreateLine(Sender: TObject);
    procedure CreateArea(Sender: TObject);
    procedure CommitFigure(Sender: TObject);
    procedure DeleteLastPoint(Sender: TObject);
    procedure SetFigureColor(Color: TColor);
    procedure EndDrawing(Sender: TObject);
    procedure ClearBitmap(Sender: TObject);
    procedure Draw(Canvas: TCanvas; const aExtent: TRect);
    procedure DrawCrosses(Canvas: TCanvas;
      const Top, Left, Width, Height: Integer);
  public
    constructor Create(Mngr: TKisMngr); override;
    destructor Destroy; override;
    //
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    //
    procedure PaintFigures(Sender: TObject);
    //
    property Map500Id: Integer read FMap500Id write SetMap500Id;
    property OrderNumber: String read FOrderNumber write SetOrderNumber;
    property DateOfWorks: String read FDateOfWorks write SetDateOfWorks;
    property WorksExecutor: String read FWorksExecutor write SetWorksExecutor;
    property HorizontalMapping: String read FHorizontalMapping write SetHorizontalMapping;
    property HighRiseMapping: String read FHighRiseMapping write SetHighRiseMapping;
    property MensMapping: String read FMensMapping write SetMensMapping;
    property TacheometricMapping: String read FTacheometricMapping write SetTacheometricMapping;
    property CurrentChangesMapping: String read FCurrentChangesMapping write SetCurrentChangesMapping;
    property NewlyBuildingMapping: String read FNewlyBuildingMapping write SetNewlyBuildingMapping;
    property EnginNetMapping: String read FEnginNetMapping write SetEnginNetMapping;
    property TotalSum: String read FTotalSum write SetTotalSum;
    property DraftWorksExecutor: String read FDraftWorksExecutor write SetDraftWorksExecutor;
    property Chief: String read FChief write SetChief;
    property DateOfAccept: String read FDateOfAccept write SetDateOfAccept;
    property Figures[Index: Integer]: TKisMap500Figure read GetFigures;
    property GraphicsEditor: TKisMap500Graphics read FGraphicsEditor;
  end;

implementation

end.
