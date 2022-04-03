unit fImpTT;

{$I EZ_FLAG.PAS}
interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls,
  CheckLst, Dialogs, EzBaseGIS, ExtCtrls;

type
  TFmImportTT = class(TForm)
    OKBtn: TButton;
    BtnSelect: TButton;
    Label1: TLabel;
    FontDialog1: TFontDialog;
    CheckListBox1: TCheckListBox;
    Label2: TLabel;
    ChkFlattened: TCheckBox;
    Label3: TLabel;
    PaintBox1: TPaintBox;
    Button1: TButton;
    procedure BtnSelectClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure CheckListBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FDrawBox: TEzBaseDrawBox;
    FImporting: Boolean;
    FAddToSymbolList: Boolean;
    procedure FillList;
  public
    { Public declarations }
    function Enter(DrawBox: TEzBaseDrawBox; AddToSymbolList: Boolean): Word;
  end;

implementation

{$R *.DFM}

uses
  EzLib, EzEntities, EzSystem;

function TFmImportTT.Enter(DrawBox: TEzBaseDrawBox; AddToSymbolList: Boolean): Word;
begin
  FDrawBox:= DrawBox;
  FillList;
  FAddToSymbolList:= AddToSymbolList;
  Result:= ShowModal;
end;

procedure TFmImportTT.FillList;
var
  i: Integer;
begin
  CheckListBox1.Items.Clear;
  CheckListBox1.Font.Assign(FontDialog1.Font);
  for I:= 33 to 255 do
     CheckListBox1.Items.Add(Chr(I));
end;

procedure TFmImportTT.BtnSelectClick(Sender: TObject);
begin
  if not FontDialog1.Execute then Exit;
  FillList;
end;

procedure TFmImportTT.PaintBox1Paint(Sender: TObject);
type
  TPointsArray = array[0..1000000] of TPoint;  // array of TPoint storing vertices
  TTypesArray  = array[0..1000000] of Byte;    // array of bytes storing vertex types
var
  Text : String;
  PtCount : Integer;
  Points : ^TPointsArray;
  Types : ^TTypesArray;
  iCount, NumBezier : Integer;
  V : TEzVector;
  Entity : TEzEntity;
  Symbol : TEzSymbol;
  EntityList : TList;
  MinY, MaxY : Integer;
begin
  if CheckListBox1.ItemIndex < 0 then Exit;
  with PaintBox1.Canvas do
  begin
     Font.Assign(CheckListBox1.Font);
     Font.Size := 100;

     Brush.Style := bsSolid;
     Brush.Color := clWhite;
     FillRect(PaintBox1.ClientRect);

     Pen.Color:= clBlack;
     { begin a path bracket }
     BeginPath(Handle);

     { set the background mode to transparent, this is necessary so that the path
       will consist of the area inside of the text. without this, the path is
       defined as the area outside of the text }
     SetBkMode(Handle, TRANSPARENT);

     { output a char to the canvas. this is captured as part of the path. }
     Text := CheckListBox1.Items[CheckListBox1.ItemIndex];
     Windows.TextOut(Handle,1,1,PChar(Text),Length(Text));

     EndPath(Handle);

     { Convert the path into a series of lines segment }
     if ChkFlattened.Checked then FlattenPath(Handle);

     if not FImporting then
     begin
        StrokePath(Handle);
        Exit;
     end;

     { retrieve the number of points defining the path }
     PtCount := GetPath(Handle, Points^, Types^, 0);
     if PtCount <= 0 then Exit;

     { allocate enough memory to store the points and their type flags }
     GetMem( Points, SizeOf( TPoint ) * PtCount );
     GetMem( Types, SizeOf( Byte ) * PtCount );

     { retrieves the points and vertex types of the path }
     GetPath( Handle, Points^, Types^, PtCount );

     NumBezier := 0;
     V := TEzVector.Create(500);
     EntityList := TList.Create;
     try
        { find maximum and minimum }
        MinY := MaxInt;
        MaxY:= -MaxInt;
        for iCount:= 0 to PtCount - 1 do
        begin
           MinY := IMin(MinY, Points[iCount].Y);
           MaxY := IMax(MaxY, Points[iCount].Y);
        end;
        for iCount:= 0 to PtCount - 1 do
        begin
           {record the type of point }
           case (Types[iCount] and not PT_CLOSEFIGURE) of
              PT_MOVETO :
                 begin
                    { start of new entity }
                    V.Clear;
                    V.Add(Point2D(Points[iCount].X, MinY+(Maxy-MinY)-Points[iCount].Y));
                 end;
              PT_LINETO :
                 begin
                    V.Add(Point2D(Points[iCount].X, MinY+(Maxy-MinY)-Points[iCount].Y));
                 end;
              PT_BEZIERTO :
                 begin
                    case NumBezier of
                       0 : begin
                           { first create the previous polyline entity }
                           if V.Count > 0 then
                           begin
                              Entity:= TEzPolyline.CreateEntity([Point2D(0,0)]);
                              Entity.Points.Assign(V);
                              FDrawBox.AddEntity(FDrawBox.GIS.CurrentLayerName,Entity);
                              Entity.Free;
                           end;
                           { clear the points for current entity }
                           V.Clear;
                           { the previous point is the starting point of the bezier curve }
                           V.Add(Point2D( Points[iCount-1].X, MinY+(Maxy-MinY)-Points[iCount-1].Y) );
                           { and this point is a control point }
                           V.Add(Point2D( Points[iCount].X, MinY+(Maxy-MinY)-Points[iCount].Y) );
                           Inc(NumBezier);
                           end;
                       1 : begin
                           { the second control point of the bezier curve }
                           V.Add(Point2D( Points[iCount].X, MinY+(Maxy-MinY)-Points[iCount].Y) );
                           Inc(NumBezier);
                           end;
                       2 : begin
                           { last point of bezier curve }
                           V.Add(Point2D( Points[iCount].X, MinY+(Maxy-MinY)-Points[iCount].Y) );
                           { now create the bezier entity }
                           Entity:= TEzSpline.CreateEntity([Point2D(0,0)]);
                           Entity.Points.Assign(V);
                           V.Clear;
                           NumBezier:= 0;
                           end;
                    end;
                 end;
           end;

           { check if it is a closed figure }
           if (Types[iCount] and PT_CLOSEFIGURE)=PT_CLOSEFIGURE then
              if ChkFlattened.Checked then
              begin
                 { create a polygon entity }
                 if V.Count > 2 then
                 begin
                    Entity:= TEzPolygon.CreateEntity([Point2D(0,0)]);
                    Entity.Points.Assign(V);
                    EntityList.Add(Entity);
                 end;
              end else
              begin
                 { create a polyline entity }
                 if V.Count > 1 then
                 begin
                    Entity:= TEzPolyline.CreateEntity([Point2D(0,0)]);
                    Entity.Points.Assign(V);
                    EntityList.Add(Entity);
                 end;
              end;
        end;
        if FAddToSymbolList then
        begin
          Symbol:= Ez_Symbols[Ez_Symbols.Add( TEzSymbol.Create(Ez_Symbols) )];
          for iCount := 0 to EntityList.Count -1 do
            Symbol.Add(TEzEntity(EntityList[iCount]));
        end else
        begin
          for iCount := 0 to EntityList.Count -1 do
            FDrawBox.AddEntity(FDrawBox.Gis.Layers[0].Name, TEzEntity(EntityList[iCount]));
        end;
        CheckListBox1.Checked[CheckListBox1.ItemIndex]:= True;
     finally
        V.free;
        EntityList.free;
        { free the memory used to store the points and vertex types }
        FreeMem(Points);
        FreeMem(Types);
     end;

     StrokePath(Handle);

  end;
end;

procedure TFmImportTT.CheckListBox1Click(Sender: TObject);
begin
  PaintBox1.Invalidate;
end;

procedure TFmImportTT.Button1Click(Sender: TObject);
var
  I:Integer;
begin
  FImporting:= true;
  for I:= 0 to checkListBox1.Items.Count-1 do
    if checkListBox1.Checked[I] then
    begin
      checkListBox1.ItemIndex:= I;
      PaintBox1.Refresh;
    end;
  FImporting:=False;
end;

end.
 