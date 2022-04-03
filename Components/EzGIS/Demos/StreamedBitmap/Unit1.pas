unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  EzCmdLine, EzBaseGIS, EzCtrls, EzLib, Buttons, ExtCtrls, EzBasicCtrls;

type
  TMemMapFile = class;

  TForm1 = class(TForm)
    EzGIS1: TEzGIS;
    GISView1: TEzDrawBox;
    CmdLine1: TEzCmdLine;
    Panel1: TPanel;
    BtnHand: TSpeedButton;
    BtnZoomRT: TSpeedButton;
    ZoomWBtn: TSpeedButton;
    ZoomAll: TSpeedButton;
    PriorViewBtn: TSpeedButton;
    ZoomIn: TSpeedButton;
    ZoomOut: TSpeedButton;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EzGIS1AfterPaintEntity(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; Entity: TEzEntity; Grapher: TEzGrapher;
      Canvas: TCanvas; const Clip: TEzRect; DrawMode: TEzDrawMode);
    procedure BtnHandClick(Sender: TObject);
    procedure BtnZoomRTClick(Sender: TObject);
    procedure ZoomWBtnClick(Sender: TObject);
    procedure ZoomAllClick(Sender: TObject);
    procedure PriorViewBtnClick(Sender: TObject);
    procedure ZoomInClick(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure EzGIS1BeforePaintEntity(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; Entity: TEzEntity; Grapher: TEzGrapher;
      Canvas: TCanvas; const Clip: TEzRect; DrawMode: TEzDrawMode;
      var CanShow: Boolean; var EntList: TEzEntityList;
      var AutoFree: Boolean);
  private
    { Private declarations }
    FPath: string;
    FMemMapFile: TMemMapFile;
  public
    { Public declarations }
  end;

{ TMemMapFile - a Windows memory mapped file as a stream
  used as a sample how to use the TEBandsBitamp2d.Stream property
  in order to display a bitmap by reading from a stream

  This can also be a good technique for displaying very big bitmaps
  that are feed from a windows memory mapped file }

  { TMemMapFile - a windows memory mapped file as a stream }

  TMemMapFile = class(TStream)
  private
    fFileName: String;
    fSize: Longint;
    fFileSize: Longint;
    fFileMode: Integer;
    fFileHandle: Integer;
    fMapHandle: Integer;
    fData: PChar;
    fMapNow: Boolean;
    fPosition: Longint;
    fVirtualSize: Longint;

    procedure AllocFileHandle;
    procedure AllocFileMapping;
    procedure AllocFileView;
  public
    constructor Create(FileName: String; FileMode: integer;
                       Size: integer; MapNow: Boolean);
    destructor Destroy; override;
    procedure FreeMapping;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;

    property Data: PChar read fData;
    property VirtualSize: Longint read fVirtualSize;
    property FileName: String read fFileName;
    property FileHandle: Integer read fFileHandle;
    property MapHandle: Integer read fMapHandle;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses
  EzSystem, EzBase, EzEntities, EzGraphics;

{ Implementation of TMemMapFile }

constructor TMemMapFile.Create(FileName: string; FileMode: integer;
  Size: integer; MapNow: Boolean);
{ Creates Memory Mapped view of FileName file.
  FileName: Full pathname of file.
  FileMode: Use fmXXX constants.
  Size: size of memory map.  Pass zero as the size to use the
        file's own size.
}
begin

  { Initialize private fields }
  fMapNow:= MapNow;
  fFileName:= FileName;
  fFileMode:= FileMode;

  AllocFileHandle;                      // Obtain a file handle of the disk file.
  { Assume file is < 2 gig  }

  fFileSize:= GetFileSize(fFileHandle, nil);
  fSize:= Size;

  try
    AllocFileMapping;                   // Get the file mapping object handle.
  except
    on E:Exception do
    begin
      CloseHandle(fFileHandle);         // close file handle on error
      fFileHandle:= 0;                  // set handle back to 0 for clean up
      raise;                            // re-raise exception
    end;
  end;
  if fMapNow then
    AllocFileView;                      // Map the view of the file
end;

destructor TMemMapFile.Destroy;
begin

  if fFileHandle <> 0 then
    CloseHandle(fFileHandle);           // Release file handle.

  { Release file mapping object handle }
  if fMapHandle <> 0 then
    CloseHandle(fMapHandle);

  FreeMapping;                          { Unmap the file mapping view . }
  inherited Destroy;
end;

procedure TMemMapFile.FreeMapping;
{ This method unmaps the view of the file from this process's address
  space. }
begin
  if fData <> nil then
  begin
    UnmapViewOfFile(fData);
    fData:= nil;
  end;
end;

procedure TMemMapFile.AllocFileHandle;
{ creates or opens disk file before creating memory mapped file }
begin
  if fFileMode = fmCreate then
    fFileHandle:= FileCreate(fFileName)
  else
    fFileHandle:= FileOpen(fFileName, fFileMode);

  if fFileHandle < 0 then
    raise Exception.Create('Failed to open or create file');
end;

procedure TMemMapFile.AllocFileMapping;
var
  ProtAttr: DWORD;
begin
  if fFileMode = fmOpenRead then        // obtain correct protection attribute
    ProtAttr:= Page_ReadOnly
  else
    ProtAttr:= Page_ReadWrite;
  { attempt to create file mapping of disk file.
    Raise exception on error. }
  fMapHandle:= CreateFileMapping(fFileHandle, nil, ProtAttr, 0, fSize, nil);
  if fMapHandle = 0 then
    raise Exception.Create('Failed to create file mapping');
end;

procedure TMemMapFile.AllocFileView;
var
  Access: Longint;
begin
  if fFileMode = fmOpenRead then        // obtain correct file mode
    Access:= File_Map_Read
  else
    Access:= File_Map_All_Access;
  fData:= MapViewOfFile(fMapHandle, Access, 0, 0, fSize);
  if fData = nil then
    raise Exception.Create('Failed to map view of file');
end;

function TMemMapFile.Read(var Buffer; Count: Longint): Longint;
begin
  if fPosition + Count > self.Size then
    raise Exception.Create('Position beyond EOF');
  Move((fData + fPosition)^, Buffer, Count);
  Inc(fPosition, Count);
  Result:= Count;
end;

function TMemMapFile.Write(const Buffer; Count: Integer): Longint;
begin
  result:=0;
end;

function TMemMapFile.Seek(Offset: Longint; Origin: Word): Integer;
begin
  case Origin of
    soFromBeginning:
      fPosition:= Offset;
    soFromCurrent:
      fPosition:= fPosition + Offset;
    soFromEnd:
      fPosition:= fFileSize - Offset;
  end;
  Result:= fPosition;
end;


{ implementation of TForm1 }
procedure TForm1.FormCreate(Sender: TObject);
var
  bitmapWidth, bitmapHeight:integer;
  IsCompressed:boolean;
  MapExtents: TEzRect;
begin
  FPath:= AddSlash(ExtractFilePath(ExpandFilename('..\..\data\txt.fnt')));
  if not FileExists(FPath+'txt.fnt') then
  begin
    ShowMessage('No font files found !');
  end;
  Ez_VectorFonts.AddFontFile(FPath+'complex.fnt');
  Ez_VectorFonts.AddFontFile(FPath+'txt.fnt');
  //Ez_VectorFonts.AddFontFile(FPath+'romanc.fnt');
  //Ez_VectorFonts.AddFontFile(FPath+'arial.fnt');

  { ALWAYS load the symbols after the vectorial fonts
    because the symbols can include vectorial fonts entities and
    if the vector font is not found, then the entity will be configured
    with another font }
  if FileExists(FPath + 'symbols.ezs') then
  begin
    Ez_Symbols.FileName:= FPath + 'symbols.ezs';
    Ez_Symbols.Open;
  end;

  // load line types
  if FileExists(FPath + 'Linetypes.ezl') then
  begin
    Ez_LineTypes.FileName:=FPath + 'Linetypes.ezl';
    Ez_LineTypes.Open;
  end;

  Ez_Preferences.CommonSubDir:= FPath;

  { delete all files for the layer }
  SysUtils.DeleteFile(FPath + 'tempo.dbf');
  SysUtils.DeleteFile(FPath + 'tempo.epj');
  SysUtils.DeleteFile(FPath + 'tempo.ezd');
  SysUtils.DeleteFile(FPath + 'tempo.ezx');
  SysUtils.DeleteFile(FPath + 'tempo.rtc');
  SysUtils.DeleteFile(FPath + 'tempo.rtx');
  { create a new temporal map }

  EzGis1.FileName:= FPath + 'SampleMap.Ezm';
  EzGis1.Open;
  MapExtents:= EzGis1.MapInfo.Extension;
  EzGis1.Layers.CreateNew(FPath + 'tempo', nil);
  EzGis1.CurrentLayerName:= 'tempo';

  // extract bitmap dimension
  GetDibDimensions( FPath + 'Bahia Kino1.bmp', nil, BitmapWidth, BitmapHeight, IsCompressed);
  // this after GetDIBDimensions
  FMemMapFile:= TMemMapFile.Create( FPath + 'Bahia Kino1.bmp', fmOpenRead, 0, true );

  // add a bitmap to the current layer
  GisView1.AddEntityFromText('',
    Format('BANDSBITMAP (%f, %f), (%f, %f), "DUMMY_KEY", 0',
        [MapExtents.X1, MapExtents.Y1, MapExtents.X2, MapExtents.Y2]));

  GisView1.ZoomToExtension;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  EzGis1.Close;
  SysUtils.DeleteFile(FPath + 'tempo.dbf');   // the .dbf file of the layer
  SysUtils.DeleteFile(FPath + 'tempo.epj');   // the projection params of the layer
  SysUtils.DeleteFile(FPath + 'tempo.ezd');   // the entities information of the layer goes here
  SysUtils.DeleteFile(FPath + 'tempo.ezx');   // the index of the .ezd file
  SysUtils.DeleteFile(FPath + 'tempo.rtc');   // the catalog file of the r-tree (general info and deleted pages of .rtx file are saved here )
  SysUtils.DeleteFile(FPath + 'tempo.rtx');   // the r-tree pages goes here

  FMemMapFile.Free;
end;

procedure TForm1.EzGIS1AfterPaintEntity(Sender: TObject;
  Layer: TEzBaseLayer; Recno: Integer; Entity: TEzEntity;
  Grapher: TEzGrapher; Canvas: TCanvas; const Clip: TEzRect;
  DrawMode: TEzDrawMode);
begin
  if (AnsiCompareText(Layer.name,'tempo')=0) and (Entity.EntityID=idBandsBitmap) and
     (AnsiCompareText(TEzBandsBitmap(Entity).FileName,'DUMMY_KEY')=0) then
  begin
    // this avoids the class TEzBandsBitmap to automatically destroy the stream
    TEzBandsBitmap(Entity).Stream:= nil;
  end;
end;

procedure TForm1.BtnHandClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('SCROLL','');
end;

procedure TForm1.BtnZoomRTClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('REALTIMEZOOMB','');
end;

procedure TForm1.ZoomWBtnClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMWIN','');
end;

procedure TForm1.ZoomAllClick(Sender: TObject);
begin
  CmdLine1.Clear;
  GISView1.ZoomToExtension;
end;

procedure TForm1.PriorViewBtnClick(Sender: TObject);
begin
  CmdLine1.Clear;
  GISView1.ZoomPrevious;
end;

procedure TForm1.ZoomInClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMIN','');
end;

procedure TForm1.ZoomOutClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMOUT','');
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.EzGIS1BeforePaintEntity(Sender: TObject;
  Layer: TEzBaseLayer; Recno: Integer; Entity: TEzEntity;
  Grapher: TEzGrapher; Canvas: TCanvas; const Clip: TEzRect;
  DrawMode: TEzDrawMode; var CanShow: Boolean; var EntList: TEzEntityList;
  var AutoFree: Boolean);
begin
  if (AnsiCompareText(Layer.name,'tempo')=0) and (Entity.EntityID=idBandsBitmap) and
     (AnsiCompareText(TEzBandsBitmap(Entity).FileName,'DUMMY_KEY')=0) then
  begin
    { This will cause that instead of reading the bitmap from a file, this is read from
      a stream.
      In this case, a memory mapped file stream is used in order to speed up a little more
      the displaying of the bitmap.
      This technique is also good for displaying really very big bitmaps very fast.
      Example, you can have a 300 MB bitmap and if you use a memory mapped file
      then it is as if the bitmap was already loaded on memory by Windows.
      Do you have such a beast bitmap (300 MB) for testing here ? Currently, I don't :-)

      Note:
        It is not needed to use a memory mapped file as is showed on this demo,
        EzGis's TEzBandsBitmap and TEzBandsTiff2D entities will display very
        big bitmaps by buffering stright from the hard disk without any
        intervention on your side (property Ez_Preferences.BandsBitmapChunkSize
        is used for defining the buffer size). This demo is for showing a technique that
        is useful for displaying a little more faster the big bitmaps, and if
        you have enough RAM memory.
    }
    TEzBandsBitmap(Entity).Stream:= FMemMapFile;
  end;
end;

end.
