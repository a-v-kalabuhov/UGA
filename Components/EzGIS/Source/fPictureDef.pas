unit fPictureDef;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
interface

uses
  Windows, Classes, Graphics, Forms, Controls,  StdCtrls, Dialogs, SysUtils,
  ComCtrls, ExtCtrls, EzBaseGis, EzLib, EzBase, extdlgs;

type
  TfrmPict1 = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    PaintBox1: TPaintBox;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FEditFileName: string;
    FGraphLink : TEzGraphicLink;
    FEntityID: TEzEntityID;
    FCommonSubDir: string;
    FImageWidth: integer;
    FImageHeight: integer;
    procedure ReadThePicture;
  public
    { Public declarations }
    function Enter(EntityID: TEzEntityID; const FileName, CommonSubDir: string): Word;
    property EditFileName: string read FEditFileName;
    property ImageWidth: Integer read FImageWidth;
    property ImageHeight: Integer read FImageHeight;
  end;

implementation

{$R *.DFM}

uses
  EzSystem, EzActions, EzConsts, EzGraphics, EzGisTiff;

resourcestring
  SDefinePicTitle= 'Define image';
  SPictNotDefined= 'Image not already defined !';

function TfrmPict1.Enter(EntityID: TEzEntityID; const FileName, CommonSubDir: string): Word;
begin
  FEntityID:= EntityID;
  FCommonSubDir:= AddSlash(CommonSubDir);

  FGraphLink := TEzGraphicLink.Create;

  FEditFileName:= FileName;

  if not (FEntityID = idBandsBitmap) and (Length(FEditFileName)> 0) and  FileExists(FEditFileName) then
    ReadThePicture;

  Result:= ShowModal;
end;

procedure TfrmPict1.ReadThePicture;
var
  IsCompressed:Boolean;
  Exten: string;
begin
  if not FileExists(FEditFileName) then Exit;
  if FEntityID = idBandsBitmap then
  begin
    Exten:= AnsiUpperCase(ExtractFileExt(FEditFileName));
    If Exten='.BMP' then
      GetDIBDimensions( FEditFileName, nil, FImageWidth, FImageHeight, IsCompressed)
    else If Exten='.TIF' then
      GetTiffDimensions( FEditFileName, nil, FImageWidth, FImageHeight, IsCompressed)
    else If Exten='.BIL' then
      GetBILDimensions( FEditFileName, FImageWidth, FImageHeight);
    PaintBox1.Invalidate;
    Exit;
  end;
  FGraphLink.ReadGeneric(FEditFileName);
  PaintBox1.Invalidate;
  FImageWidth:= FGraphLink.Bitmap.Width;
  FImageHeight:= FGraphLink.Bitmap.Height;
end;

procedure TfrmPict1.Button1Click(Sender: TObject);
var
  ListImageKind: TListImageKind;
begin
  if FEntityID in [idPictureRef, idBandsBitmap] then
  begin
    if FEntityID=idBandsBitmap then
      ListImageKind:= liBitmaps
    else
      ListImageKind:= liAllImages;
    Self.FEditFileName := SelectCommonElement(FCommonSubdir, '', ListImageKind);
  end else
  begin
    with TOpenPictureDialog.Create(nil) do
      try
        Filter:= SBitmapFilter
{$IFDEF JPEG_SUPPORT}
                + '|' + SJPGFilter
{$ENDIF}
{$IFDEF GIF_SUPPORT}
                + '|' + SGIFFilter
{$ENDIF}
                + '|' + SMetafileFilter
                + '|' + SICOFilter
{$IFDEF USE_GRAPHICEX}
  {$IFDEF TIFFGraphic}
                + '|' + STIFFilter
  {$ENDIF}
  {$IFDEF TargaGraphic}
                + '|' + STargaFilter
  {$ENDIF}
  {$IFDEF PCXGraphic}
                + '|' + SPCXFilter
  {$ENDIF}
  {$IFDEF PCDGraphic}
                + '|' + SPCDFilter
  {$ENDIF}
{$IFNDEF GIF_SUPPORT}
  {$IFDEF GIFGraphic}
                + '|' + SGIFFilter
  {$ENDIF}
{$ENDIF}
  {$IFDEF PhotoshopGraphic}
                + '|' + SPSDFilter
  {$ENDIF}
  {$IFDEF PaintshopProGraphic}
                + '|' + SPSPFilter
  {$ENDIF}
  {$IFDEF PortableNetworkGraphic}
                + '|' + SPNGFilter
  {$ENDIF}

{$ENDIF}
          ;

         Options := [ofPathMustExist, ofFileMustExist];
         Title   := SDefinePicTitle;
         FileName:= Self.FEditFileName;
         if not Execute then Exit;
         Self.FEditFileName := FileName;
      finally
         Free;
      end;
  end;
  ReadThePicture;
end;

procedure TfrmPict1.Button2Click(Sender: TObject);
begin
  FGraphLink.Bitmap.Assign( nil );
  PaintBox1.Invalidate;
  FEditFileName :='';
end;

procedure TfrmPict1.OKBtnClick(Sender: TObject);
begin
  if not FileExists(FEditFileName) then
  begin
     MessageToUser(SPictNotDefined, smsgerror,MB_ICONERROR);
     ModalResult:= mrNone;
     Exit;
  end;
end;

procedure TfrmPict1.FormDestroy(Sender: TObject);
begin
  FGraphLink.Free;
end;

procedure TfrmPict1.PaintBox1Paint(Sender: TObject);
var
  hPaintPal, hOldPal : HPalette; {Used for realizing the palette}
  BoundsR: TRect;
begin
  with PaintBox1.Canvas do
  begin
    Boundsr:= PaintBox1.ClientRect;
    DrawEdge(Handle,Boundsr,EDGE_RAISED, BF_RECT {or BF_MIDDLE or BF_FLAT});
  end;
  if FEntityID = idBandsBitmap then
  begin
    with PaintBox1.Canvas do
    begin
      //Brush.Style:= bsSolid;
      BoundsR:= PaintBox1.ClientRect;
      //with BoundsR do Rectangle(Left,Top,Right,Bottom);
      if Length(FEditFileName)>0 then
      begin
        Font.Handle:= EzSystem.DefaultFontHandle;
        InflateRect(BoundsR,-1,-1);
        SetBkMode(Handle, TRANSPARENT);
        Drawtext(Handle, PChar(FEditFileName), -1, BoundsR,
          DT_SINGLELINE or DT_VCENTER or DT_CENTER or DT_PATH_ELLIPSIS);
      end;
    end;
    Exit;
  end;

  if ( FGraphLink.Bitmap = Nil) Or ( FGraphLink.Bitmap.Handle = 0 ) then
  begin
    with PaintBox1.Canvas do
    begin
      BoundsR:= PaintBox1.ClientRect;
      FEditFileName:= '(No Picture)';
      Font.Handle:= EzSystem.DefaultFontHandle;
      InflateRect(BoundsR,-1,-1);
      SetBkMode(Handle, TRANSPARENT);
      Drawtext(Handle, PChar(FEditFileName), -1, BoundsR,
        DT_SINGLELINE or DT_VCENTER or DT_CENTER or DT_PATH_ELLIPSIS);
    end;
    exit;
  end;
  hPaintPal := FGraphLink.Bitmap.Palette;

  {Get the old palette and select the new palette}
  hOldPal:= SelectPalette(PaintBox1.Canvas.Handle, hPaintPal, False);

  {Realize palette}
  RealizePalette(PaintBox1.Canvas.Handle);

  {Set the stretch blt mode}
  SetStretchBltMode(PaintBox1.Canvas.Handle, STRETCH_DELETESCANS);

  with PaintBox1 do
     StretchBlt(PaintBox1.Canvas.Handle,0,0,ClientWidth,ClientHeight,
        FGraphLink.Bitmap.Canvas.Handle,0,0,
        FGraphLink.Bitmap.Width,
        FGraphLink.Bitmap.Height,SRCCOPY);
  if hOldPal <> 0 then
     SelectPalette(PaintBox1.Canvas.Handle, hOldPal, False);
end;

procedure TfrmPict1.FormCreate(Sender: TObject);
begin
{$IFDEF LANG_SPA}
  Caption:= 'Imagen';
  Button1.Caption:= '&Definir...';
  Button2.Caption:= '&Limpiar...';
  OkBtn.Caption:= 'Aceptar';
  CancelBtn.Caption:= 'Cancelar';
{$ENDIF}
end;

end.
