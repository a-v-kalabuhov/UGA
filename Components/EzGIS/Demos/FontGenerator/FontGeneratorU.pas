unit FontGeneratorU;

{$I ez_flag.pas}
interface

uses Windows, Classes, Graphics, Forms, Controls, SysUtils, StdCtrls,
  CheckLst, Dialogs, Buttons, ezlib, ComCtrls, ExtCtrls;

type
  TfrmFontGenerator = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    btnDlg: TSpeedButton;
    LblFontname: TLabel;
    Label5: TLabel;
    OKBtn: TButton;
    BtnSelect: TButton;
    CheckListBox1: TCheckListBox;
    PaintBox1: TPaintBox;
    Button1: TButton;
    chkFlattened: TCheckBox;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    Button5: TButton;
    Edit2: TEdit;
    UpDown1: TUpDown;
    FontDialog1: TFontDialog;
    SaveDialog1: TSaveDialog;
    Button6: TButton;
    LblShpFontName: TLabel;
    Label6: TLabel;
    SpeedButton1: TSpeedButton;
    btnOk: TButton;
    btnGenFont: TButton;
    Edit3: TEdit;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    Label7: TLabel;
    Pbox2: TPaintBox;
    LblASCII: TLabel;
    ChkShow: TCheckBox;
    Label8: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    procedure BtnSelectClick(Sender: TObject);
    procedure CheckListBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure btnDlgClick(Sender: TObject);
    procedure CheckListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Button5Click(Sender: TObject);
    procedure chkFlattenedClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure btnGenFontClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
    FVector: TEzVector;
    CurrPath: string;
    FMemoLines: TStrings;
    procedure GenerateChar(const AText: string; Importing: Boolean);
    procedure FillList;
    procedure DoSelect(FromChar, ToChar: Integer);
  public
    { Public declarations }
  end;

var
  frmFontGenerator: TfrmFontGenerator;

implementation

{$R *.DFM}

uses
  Math, ezbase, ezentities, ezSystem, EzStrArru;

procedure TfrmFontGenerator.FillList;
var
  i: Integer;
  FontName: string;
begin
  CheckListBox1.Items.Clear;
  CheckListBox1.Font.Assign(FontDialog1.Font);
  CheckListBox1.ItemHeight:= Abs(CheckListBox1.Font.Height)+10;
  for I:= 1 to 255 do
     CheckListBox1.Items.Add(Chr(I));
  FontName:= StringReplace(FontDialog1.Font.Name,#32,'_',[rfReplaceAll, rfIgnoreCase]);
  Edit1.Text:= CurrPath + FontName + '.fnt';
  LblFontname.Caption:= FontDialog1.Font.Name;
end;

procedure TfrmFontGenerator.BtnSelectClick(Sender: TObject);
begin
  if not FontDialog1.Execute then Exit;
  FillList;
end;

{ calculates a bezier curve and stores in uv }
procedure bezier(const ap0, ap1, ap2, ap3: TEzPoint; res: integer; uv: TEzVector);
var
  i:integer;
  k,r,x,y:double;
begin
  r:=1.0/res;
  k:=0.0;
  for i:=1 to res+1 do
    begin
      x:=(1-k)*(1-k)*(1-k)*ap0.x+3*k*(1-k)*(1-k)*ap1.x+3*k*k*(1-k)*ap2.x+k*k*k*ap3.x;
      y:=(1-k)*(1-k)*(1-k)*ap0.y+3*k*(1-k)*(1-k)*ap1.y+3*k*k*(1-k)*ap2.y+k*k*k*ap3.y;
      uv.Add(Point2D(X,Y));
      k:=k+r;
    end;
end;

procedure TfrmFontGenerator.GenerateChar(const AText: string; Importing: Boolean);
type
  TPointsArray = array[0..1000000] of TPoint;  // array of TPoint storing vertices
  TTypesArray  = array[0..1000000] of Byte;    // array of bytes storing vertices types
var
  PtCount : Integer;
  Points : ^TPointsArray;
  Types : ^TTypesArray;
  iCount, NumBezier, PartIndex : Integer;
  p0,p1,p2,p3: TEzPoint;
begin
  with PaintBox1.Canvas do
  begin
     Font.Assign(CheckListBox1.Font);
     Font.Size := 150;

     Brush.Style := bsSolid;
     Brush.Color := clWhite;
     FillRect(PaintBox1.ClientRect);

     Pen.Color:= clBlack;
     Pen.Width:= 1;
     { begin a path bracket }
     BeginPath(Handle);

     { set the background mode to transparent, this is necessary so that the path
       will consist of the area inside of the text. without this, the path is
       defined as the area outside of the text }
     SetBkMode(Handle, TRANSPARENT);

     { output a char to the canvas. this is captured as part of the path. }
     Windows.TextOut(Handle,0,0,PChar(AText),Length(AText));

     EndPath(Handle);

     { Convert the path into a series of lines segment }
     if ChkFlattened.Checked then
       FlattenPath(Handle);

     if not Importing then
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
     PartIndex := 0;
     FVector.Clear;
     try
        for iCount:= 0 to PtCount - 1 do
        begin
           {record the type of point }
           case (Types[iCount] and not PT_CLOSEFIGURE) of
              PT_MOVETO, PT_LINETO :
                 begin
                    FVector.Add(Point2D(Points[iCount].X, Points[iCount].Y));
                 end;
              PT_BEZIERTO :
                 begin
                    case NumBezier of
                       0 : begin
                             { the previous point is the starting point of the bezier curve }
                             p0:= Point2D( Points[iCount-1].X, Points[iCount-1].Y);
                             { and this point is a control point }
                             p1:= Point2D( Points[iCount].X, Points[iCount].Y);
                             Inc(NumBezier);
                           end;
                       1 : begin
                             { the second control point of the bezier curve }
                             p2:= Point2D( Points[iCount].X, Points[iCount].Y);
                             Inc(NumBezier);
                           end;
                       2 : begin
                             { last point of bezier curve }
                             p3:= Point2D( Points[iCount].X, Points[iCount].Y);
                             { now create the bezier entity }
                             bezier(p0,p1,p2,p3,UpDown1.Position,FVector);
                             NumBezier:= 0;
                           end;
                    end;
                 end;
           end;

           { check if it is a close figure command }
           if (Types[iCount] and PT_CLOSEFIGURE)=PT_CLOSEFIGURE then
           begin
             FVector.Parts.Add(PartIndex);
             PartIndex:= FVector.Count;
           end;
        end;
     finally
        { free the memory used to store the points and vertex types }
        FreeMem(Points);
        FreeMem(Types);
     end;

     StrokePath(Handle);

     if FVector.Parts.Count < 2 then FVector.Parts.Clear;

  end;
end;

procedure TfrmFontGenerator.CheckListBox1Click(Sender: TObject);
begin
  PaintBox1.Invalidate;
end;

procedure TfrmFontGenerator.Button1Click(Sender: TObject);
var
  I, J:Integer;
  VectorFont: TEzVectorFont;
  VectorChar: TEzVectorChar;
  Found: Boolean;
  TmpExt, Bounds: TEzRect;
  CharVectList: TSparseList;
  V: TEzVector;
  M,M1,M2: TEzMatrix;
  MaxChar: Integer;
begin
  VectorFont:= TEzVectorFont.create;
  CharVectList:= TSparseList.Create(SPALarge);
  Found:=False;
  try
    { fix the y coordinate for the vectors
      start calculating min/max bounds... }
    Bounds:= INVALID_EXTENSION;
    for I:= 0 to checkListBox1.Items.Count-1 do
    begin
      if checkListBox1.Checked[I] then
      begin
        GenerateChar(CheckListBox1.Items[I][1], True);
        if Self.FVector.Count=0 then Continue;
        TmpExt:= Self.FVector.Extension;
        MinBound(Bounds.Emin, TmpExt.Emin);
        MaxBound(Bounds.Emax, TmpExt.Emax);
        V:= TEzVector.Create(Self.FVector.Count);
        V.Assign(Self.FVector);
        CharVectList[I]:= V;

        Found:=True;
      end;
    end;
    { ...now fix the y coordinate }
    for I:= 0 to CharVectList.Count-1 do
    begin
      if CharVectList[I] <> nil then
      begin
        V:= TEzVector(CharVectList[I]);
        for J:= 0 to V.Count-1 do
          V[J] := Point2D( V[J].X - Bounds.Emin.X,
                           Bounds.Emax.Y - V[J].Y );
      end;
    end;
    { calculate final resulting min,max bounds }
    Bounds:= INVALID_EXTENSION;
    for I:= 0 to CharVectList.Count-1 do
    begin
      if CharVectList[I] <> nil then
      begin
        V:= TEzVector(CharVectList[I]);
        TmpExt:= V.Extension;
        MinBound(Bounds.Emin, TmpExt.Emin);
        MaxBound(Bounds.Emax, TmpExt.Emax);
      end;
    end;
    { Now transform all the vectors }
    M1 := Translate2D(-Bounds.Emin.X, -Bounds.Emin.Y);
    M2 := Scale2D(1/Abs(Bounds.Emax.X-Bounds.Emin.X), 1/Abs(Bounds.Emax.Y-Bounds.Emin.Y), Bounds.Emin);
    M  := MultiplyMatrix2D(M1, M2);
    MaxChar:= 0;
    for I:= 0 to CharVectList.Count-1 do
      if (CharVectList[I] <> nil) and (I>MaxChar) then
        MaxChar:=I;
    if MaxChar>0 then
      VectorFont.MaxChar:= MaxChar+1
    else
      exit;
    for I:= 0 to CharVectList.Count-1 do
      if CharVectList[I] <> nil then
      begin
        V:= TEzVector(CharVectList[I]);
        for J:= 0 to V.Count-1 do
          V[J] := TransformPoint2D(V[J], M);
        VectorChar:= TEzVectorChar.Create;
        VectorChar.Vector.Assign(V);
        VectorFont.Chars[I+1] := VectorChar;
        V.Free;
      end;
    VectorFont.Name:= LblFontname.Caption;
    VectorFont.SaveToFile(Edit1.Text);
  finally
    VectorFont.Free;
    CharVectList.Free;
  end;
  PaintBox1.Refresh;
  if not Found then
    ShowMessage('No characters selected')
  else
    ShowMessage('Font File generation succesful')
end;

procedure TfrmFontGenerator.FormCreate(Sender: TObject);
begin
  FVector:= TEzVector.Create(500);
  CurrPath:= AddSlash(ExtractFilePath(Application.ExeName));
  FillList;
  FMemoLines:= TStringList.create;
end;

procedure TfrmFontGenerator.FormDestroy(Sender: TObject);
begin
  FVector.free;
  FMemoLines.free;
end;

procedure TfrmFontGenerator.PaintBox1Paint(Sender: TObject);
begin
  if CheckListBox1.ItemIndex<0 then exit;
  GenerateChar(CheckListBox1.Items[CheckListBox1.ItemIndex][1], False);
  FVector.Clear;
end;

procedure TfrmFontGenerator.DoSelect(FromChar, ToChar: Integer);
var
  I: Integer;
begin
  for I:= 0 to CheckListBox1.Items.Count-1 do
    CheckListBox1.Checked[I] := False;
  if ToChar < FromChar then Exit;
  for I:= IMax(0,FromChar) to IMin(CheckListBox1.Items.Count-1,ToChar) do
    CheckListBox1.Checked[I] := True;
end;

procedure TfrmFontGenerator.Button2Click(Sender: TObject);
begin
  DoSelect(0,CheckListBox1.Items.Count-1);
end;

procedure TfrmFontGenerator.Button3Click(Sender: TObject);
begin
  DoSelect(32,125);
end;

procedure TfrmFontGenerator.Button4Click(Sender: TObject);
begin
  DoSelect(32,254);
end;

procedure TfrmFontGenerator.OKBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFontGenerator.btnDlgClick(Sender: TObject);
begin
  SaveDialog1.FileName:= Edit1.Text;
  if not SaveDialog1.Execute then Exit;
  Edit1.Text := SaveDialog1.FileName;
  CurrPath:= AddSlash(ExtractFilePath(SaveDialog1.FileName));
end;

procedure TfrmFontGenerator.CheckListBox1DrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  R: TRect;
  TmpText: string;
begin
  with CheckListBox1.Canvas do
  begin
    FillRect(Rect);
    Font.Assign(FontDialog1.Font);
    if odSelected in State then
       Font.Color:= clHighlightText
    else
       Font.Color:= clWindowText;
    TextOut(Rect.Left, Rect.Top, CheckListBox1.Items[Index]);
    R:= Rect;
    DrawText(Handle, PChar(CheckListBox1.Items[Index]), -1, R, DT_SINGLELINE or DT_CENTER or DT_VCENTER or DT_CALCRECT);
    Font.Name:= 'Arial';
    Font.Size:= 9;
    Font.Style:= [];
    R.Left:= R.Right + 4;
    R.Right:= Rect.Right;
    InflateRect(R,-2,-2);
    TmpText:= IntToStr(Index+1);
    DrawText(Handle, PChar(TmpText), -1, R, DT_SINGLELINE or DT_RIGHT or DT_VCENTER);
  end;
end;

procedure TfrmFontGenerator.Button5Click(Sender: TObject);
begin
  DoSelect(0,-1);
end;

procedure TfrmFontGenerator.chkFlattenedClick(Sender: TObject);
begin
  Label5.Enabled  := not chkFlattened.Checked;
  Edit2.Enabled   := not chkFlattened.Checked;
  UpDown1.Enabled := not chkFlattened.Checked;
end;

procedure TfrmFontGenerator.Button6Click(Sender: TObject);
var
  shpName: string;
begin
  if not Opendialog1.Execute then Exit;
  shpName:= ChangeFileExt(ExtractFileName(OpenDialog1.FileName),'');
  Edit3.Text:= CurrPath + ShpName + '.fnt';
  LblShpFontName.Caption:= shpName;
  try
    Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
  except
  end;
  { this is done because win95,98 does not acept > 32K text}
  FMemoLines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TfrmFontGenerator.btnGenFontClick(Sender: TObject);
var
  SHPLinePos: Integer;
  SHPElems: TStringList;
  ShapeType, code: Integer;
  temp,FontName: string;
  UCaseLetterHeight: Integer;
  BaselineDescend:integer;
  OrientationMode:integer;
  tmpint: Integer;
  numChar: Integer;
  BoxSize:Integer;
  StartPoint:TEzPoint;
  CurrentPos:TEzPoint;
  scalefactor: double;
  xStack, yStack: ezlib.TEzDoubleList;
  VectorFont: TEzVectorFont;
  VectorChar: TEzVectorChar;
  CharVectList: TSparseList;
  TempVector: TEzVector;
  Distance: Double;
  AngleCode: Integer;
  Angle: Double;
  DisplX: Double;
  DisplY: Double;
  IsDrawing: Boolean;
  NewPt: TEzPoint;
  TmpExt: TEzRect;
  Bounds: TEzRect;
  M1,M2,M: TEzMatrix;
  I: Integer;
  NumDefs: Integer;
  tmpval: Integer;
  ExecuteCommand: Boolean;
  n: Integer;
  CommandCode: Integer;
  V: TEzVector;
  J: Integer;
  IsValidChar: Boolean;
  MaxChar: Integer;
  p: Integer;
  BasicVectorLength: Integer;
  VectorLocation: Integer;
  MaxX: Double;
  Bulge: Double;
  sa:Double;
  StartOctant,StopOctant:Integer;
  p1,p2,p3,MidPoint:TEzPoint;
  OctRadius:Double;
  OctCounterClockWise:Boolean;
  BeginningOctant:Integer;
  NumOctants:Integer;
  BulgeHeight:Double;
  BulgePt:TEzPoint;
  Arc:TEzArc;
  Index1,Index2:Integer;
  PenStyle:TEzPenstyle;
  Grapher: TEzGrapher;

  function GetNumber(const s: string): Integer;
  const
    HexDigs = ['0'..'9','a'..'f','A'..'F'];
  var
    IsHexa:Boolean;
    I:Integer;
    work: string;
  begin
    work:=s;
    if (length(work)>0) and (work[1]='(') then
      System.Delete(work,1,1);
    if (length(work)>0) and (work[length(work)]=')') then
      System.Delete(work,length(work),1);
    IsHexa:= false;
    for I:=1 to length(s) do
      if s[i] in ['A'..'Z','a'..'z'] then
      begin
        IsHexa:= true;
        break;
      end;
    if IsHexa or ((length(work)=3) and (work[1]='0')) then
    begin
      IsHexa:=true;
      for I:=1 to length(work) do
        if not(work[I] in HexDigs) then
        begin
          isHexa:=false;
          break;
        end;
     if IsHexa then
     begin
       result:= StrToInt('$' + work);  // an error will be raised if wrong value
       exit;
     end;
    end;
    result:= StrToInt(work);  // an error will be raised if wrong value
  end;

  function SplitElems(const temp: string; CommaFinished: Boolean): Boolean;
  var
    p:Integer;
    Work: string;
  begin
    result:=true;
    Work:= temp;
    p:=Pos(',',Work);
    if p=length(Work) then
    begin
      Work:=copy(Work,1,p-1);
      result:=false;
    end else
      while (p>0) and (length(Work)>0) do
      begin
        SHPElems.Add(Trim(Copy(Work,1,p-1)));
        System.Delete(Work,1,p);
        if length(Work)>0 then
        begin
          p:=Pos(',',Work);
          if not CommaFinished and (p=length(Work)) then
            result:=false;
        end;
      end;
    if Length(Work)>0 then
      SHPElems.Add(Work);
  end;

  function FetchSHPData(CommaFinished: Boolean): Boolean;
  var
    temp: string;
  begin
    SHPElems.Clear;
    repeat
      repeat
        Inc(SHPLinePos);
        Result := SHPLinePos < FMemoLines.Count;
        if not Result then Exit;
        temp:= Trim(FMemoLines[SHPLinePos]);
        { this parse assume comments starts on first non blank character on the line }
        if (length(temp)>0) and (temp[1]=';') then temp:='';  // ignore comments
      until Length(temp) <> 0;
    until SplitElems(temp,CommaFinished)=true;
  end;

begin
  VectorFont:= TEzVectorFont.create;
  CharVectList:= TSparseList.Create(SPALarge);
  SHPElems:= TStringList.create;
  xStack:= TEzDoubleList.create;
  yStack:= TEzDoubleList.create;
  Grapher:= TEzGrapher.Create(10,adScreen);
  try
    SHPLinePos:= -1;
    Bounds:= INVALID_EXTENSION;
    MaxChar:= -1;

    { *** read definition line }
    if not FetchSHPData(false) or (SHPElems.Count<3) then exit;
    { detect the name of the font }
    temp:= ShpElems[0];
    if (length(temp)=0) or ((length(temp)>0) and (temp[1]<>'*')) then exit;

    //Val(copy(temp,2,length(temp)),shapeType,Code);
    //if (Code<>0) or (shapeType<>0) then Exit;   // invalid file because shapeType must be 0
    Val(shpElems[1],NumDefs,Code);
    if (Code<>0) or (NumDefs<4) then exit;
    { the font name as is defined in the .shp file }
    Fontname:= shpElems[2];
    p:=AnsiPos(' copyright',LowerCase(Fontname));
    if p>0 then
      Fontname:=Trim(Copy(FontName,1,p-1));

    { *** read definition elements }
    if not FetchSHPData(false) or (SHPElems.Count<4) then exit;
    Val(shpElems[0],UCaseLetterHeight,code);
    if code<>0 then exit;
    Val(shpElems[1],BaselineDescend,code);
    if code<>0 then exit;
    Val(shpElems[2],OrientationMode,code);
    if code<>0 then exit;
    Val(shpElems[3],tmpval,code);
    if (code<>0) or (tmpval<>0)then exit;

    { process the next character }
    BoxSize:= UCaseLetterHeight;
{$IFDEF FALSE}
    if OrientationMode=0 then     // horizontal orientation
    begin
      StartPoint.X:= 0;
      StartPoint.Y:= 0;
    end else if OrientationMode=2 then  // vertical orientation
    begin
      StartPoint.X:= 0;
      StartPoint.Y:= BoxSize;
    end;
{$ENDIF}
    StartPoint.X:= 0;
    StartPoint.Y:= 0;
    MaxX:= 0;
    CurrentPos:= StartPoint;
    xStack.Clear;
    yStack.Clear;
    { now read all the characters defined in this font file }
    while fetchSHPData(true) do
    begin

      if shpElems.Count<2 then exit;    // not enough data
      { read number of character }
      temp:= shpElems[0];
      if temp[1] <> '*' then
      begin
        exit;      // bad data
      end;
      temp:=copy(temp,2,length(temp));
      IsValidChar:= true;
      if length(temp)=5 then
      begin
        try
          numChar:= StrToInt('$' + temp);
        except
          IsValidChar:= false;
        end;
      end else
        try
          numChar:=GetNumber(temp);
        except
          IsValidChar:= false;
        end;
      { read number of definitions for this character }
      val(shpElems[1],numDefs,code);
      if code<>0 then IsValidChar:=false;
      { shpElems[2] is the name of the char and is ignored }

      { now read the definitions }

      if not fetchSHPData(false) {or (shpElems.Count>numDefs)} then
      begin
        // error here !!!
        exit;
      end;

      ExecuteCommand:= true;
      FVector.Clear;
      IsDrawing:= false;   // means can draw
      scalefactor:= 1;
      CurrentPos:=StartPoint;
      n:= 0;
      CommandCode:= GetNumber(shpElems[n]);
      //if CommandCode in [10..13,15] then Continue;
      while (n<shpElems.Count-1) and (CommandCode <>0) do
      begin
        if CommandCode > 15 then   // it is a standard line length and angle ?
        begin
          { calculate the distance from the number }
          BasicVectorLength:= CommandCode div 16;
          VectorLocation := CommandCode - (BasicVectorLength * 16) + 16;
          case VectorLocation of
            16:
              begin
                DisplX := 1.0;
                DisplY := 0.0;
              end;
            17:
              begin
                DisplX := 1.0;
                DisplY := 0.5;
              end;
            18:
              begin
                DisplX := 1.0;
                DisplY := 1.0;
              end;
            19:
              begin
                DisplX := 0.5;
                DisplY := 1.0;
              end;
            20:
              begin
                DisplX := 0.0;
                DisplY := 1.0;
              end;
            21:
              begin
                DisplX := -0.5;
                DisplY :=  1.0;
              end;
            22:
              begin
                DisplX := -1.0;
                DisplY := 1.0;
              end;
            23:
              begin
                DisplX := -1.0;
                DisplY :=  0.5;
              end;
            24:
              begin
                DisplX := -1.0;
                DisplY :=  0.0;
              end;
            25:
              begin
                DisplX := -1.0;
                DisplY := -0.5;
              end;
            26:
              begin
                DisplX := -1.0;
                DisplY := -1.0;
              end;
            27:
              begin
                DisplX := -0.5;
                DisplY := -1.0;
              end;
            28:
              begin
                DisplX :=  0.0;
                DisplY := -1.0;
              end;
            29:
              begin
                DisplX :=  0.5;
                DisplY := -1.0;
              end;
            30:
              begin
                DisplX :=  1.0;
                DisplY := -1.0;
              end;
            31:
              begin
                DisplX :=  1.0;
                DisplY := -0.5;
              end;
          end;
          { add a line from CurrentPos }
          DisplX := DisplX * (BasicVectorLength * scalefactor);
          DisplY := DisplY * (BasicVectorLength * scalefactor);
          NewPt:= Point2d(CurrentPos.X+DisplX,CurrentPos.Y+DisplY);
          if NewPt.X > MaxX then MaxX:= NewPt.X;
          if ExecuteCommand then
          begin
            if IsDrawing then
              FVector.Add(NewPt);
            CurrentPos:= NewPt;
          end;

          ExecuteCommand:= true;
        end else
        begin
          case CommandCode of
            0: break; // end of shape definition
            1:  // pen down
              begin
                if ExecuteCommand then
                begin
                  if FVector.Count>0 then
                  begin
                    if FVector.Parts.Count=0 then
                      FVector.Parts.Add(0);
                    FVector.Parts.Add(FVector.Count);
                  end;
                  FVector.Add(CurrentPos);
                  IsDrawing:= true;
                end;

                ExecuteCommand:= true;
              end;
            2:  // pen up
              begin
                if ExecuteCommand then
                  IsDrawing:= false;

                ExecuteCommand:= true;
              end;
            3:  // divide line length
              begin
                inc(n);
                tmpval:= GetNumber(shpElems[n]);
                if ExecuteCommand then
                  scalefactor:= scalefactor / tmpval;

                ExecuteCommand:= true;
              end;
            4:  // multiply line length
              begin
                inc(n);
                tmpval:= GetNumber(shpElems[n]);
                if ExecuteCommand then
                  scalefactor := scalefactor * tmpval;

                ExecuteCommand:= true;
              end;
            5:  // push location
              begin
                if ExecuteCommand then
                begin
                  xStack.Add(CurrentPos.X);
                  yStack.Add(CurrentPos.Y);
                end;

                ExecuteCommand:= true;
              end;
            6:  // Pop location
              begin
                if ExecuteCommand then
                begin
                  CurrentPos.X:= xStack[xStack.Count-1];
                  CurrentPos.Y:= yStack[yStack.Count-1];
                  xStack.Delete(xStack.Count-1);
                  yStack.Delete(yStack.Count-1);
                end;

                ExecuteCommand:= true;
              end;
            7:  // subshape drawing
              begin
                inc(n);
                tmpval:= GetNumber(shpElems[n]);  { this is the character }
              end;
            8:  // pen displacement
              begin
                inc(n);
                DisplX:= GetNumber(shpElems[n]) * scalefactor;
                inc(n);
                DisplY:= GetNumber(shpElems[n]) * scalefactor;
                NewPt:= Point2d(CurrentPos.X+DisplX, CurrentPos.Y + DisplY);
                if NewPt.X > MaxX then MaxX:= NewPt.X;
                if ExecuteCommand then
                begin
                  if IsDrawing then
                    FVector.Add(NewPt);
                  CurrentPos:= NewPt;
                end;
                ExecuteCommand:= true;
              end;
            9: // multiple pen displacements
              begin
                inc(n);
                DisplX:= GetNumber(shpElems[n]) * scalefactor;
                inc(n);
                DisplY:= GetNumber(shpElems[n]) * scalefactor;
                while not((DisplX=0) and (DisplY=0)) do
                begin
                  NewPt:= Point2d(CurrentPos.X+DisplX, CurrentPos.Y + DisplY);
                  if NewPt.X > MaxX then MaxX:= NewPt.X;
                  if ExecuteCommand then
                  begin
                    if IsDrawing then
                      FVector.Add(NewPt);
                    CurrentPos:= NewPt;
                  end;
                  inc(n);
                  DisplX:= GetNumber(shpElems[n]) * scalefactor;
                  inc(n);
                  DisplY:= GetNumber(shpElems[n]) * scalefactor;
                end;

                ExecuteCommand:= true;
              end;
            10: // Octant arc defined by next two bytes (not yet finished)
              begin
                inc(n);
                OctRadius:= GetNumber(shpElems[n]) * ScaleFactor;
                inc(n);
                temp:= shpElems[n];
                if temp[1]='-' then
                begin
                  OctCounterClockWise:=false;
                  temp:=Copy(temp,2,length(temp));
                end else
                  OctCounterClockWise:=true;
                val(Copy(temp,2,1),StartOctant,code);
                val(Copy(temp,3,1),NumOctants,code);
                p1:=CurrentPos;
                sa:= StartOctant*45;
                if OctCounterClockWise then
                begin
                  StopOctant:= StartOctant + NumOctants;
                  //ea:=StopOctant*45;
                  //angle:= DegToRad(ea-sa);
                  //MidPoint:=Point2d(Radius*Cos(angle),Radius*Sin(Angle));
                  //NewPt:=Point2d(Radius*Cos(ea),Radius*Sin(ea));
                end else
                begin
                  StopOctant:= StartOctant - NumOctants;

                end;

                ExecuteCommand:= true;
              end;
            11: // Fractional arc defined by next five bytes  (not yet finished)
              begin
                inc(n);
                tmpval:= GetNumber(shpElems[n]);
                inc(n);
                tmpval:= GetNumber(shpElems[n]);
                inc(n);
                tmpval:= GetNumber(shpElems[n]);
                inc(n);
                tmpval:= GetNumber(shpElems[n]);
                inc(n);
                tmpval:= GetNumber(shpElems[n]);

                ExecuteCommand:= true;
              end;
            12: // Bulge-specified arc
              begin
                inc(n);
                DisplX:= GetNumber(shpElems[n]) * scalefactor;
                inc(n);
                DisplY:= GetNumber(shpElems[n]) * scalefactor;
                inc(n);
                Bulge:= GetNumber(shpElems[n]);
                // calculate next point
                NewPt:= Point2d(CurrentPos.X+DisplX, CurrentPos.Y+DisplY);
                // now use the bulge factor to calculate arc points
                MidPoint:= Point2d((CurrentPos.X+Newpt.X)/2,(CurrentPos.Y+Newpt.Y)/2);
                BulgeHeight:= (Abs(Bulge)/254)*Dist2d(CurrentPos,NewPt);
                // calculate a point that goes from MidPoint to Newpt a distance BulgeHeight
                V:= TEzVector.Create(2);
                try
                  V.Add(CurrentPos);
                  V.Add(NewPt);
                  V.TravelDistance(Dist2d(CurrentPos,MidPoint)+BulgeHeight,BulgePt,Index1,Index2);
                finally
                  V.Free;
                end;
                // now rotate this point 90 degrees clockwise or counterclockwise
                if Bulge<0 then
                  M:=Rotate2d(System.Pi/2,MidPoint)
                else
                  M:=Rotate2d(-System.Pi/2,MidPoint);
                BulgePt:= TransformPoint2d(BulgePt,M);
                // build an arc with the three points calculated
                Arc:=TEzArc.CreateEntity(CurrentPos,BulgePt,NewPt);
                try
                  Arc.PointsInCurve:=10;    // 10=enough for now
                  if NewPt.X > MaxX then MaxX:= NewPt.X;
                  if ExecuteCommand then
                  begin
                    if IsDrawing then
                    begin
                      // add all the arc points to the resulting vector
                      for J:=0 to Arc.DrawPoints.Count-1 do
                        FVector.Add(Arc.DrawPoints[J]);
                    end;
                    CurrentPos:= NewPt;
                  end;
                finally
                  Arc.Free;
                end;

                ExecuteCommand:= true;
              end;
            13:  // Multiple Bulge-specified arc
              begin
                inc(n);
                DisplX:= GetNumber(shpElems[n]) * scalefactor;
                inc(n);
                DisplY:= GetNumber(shpElems[n]) * scalefactor;
                while not((DisplX=0) and (DisplY=0)) do
                begin
                  inc(n);
                  Bulge:= GetNumber(shpElems[n]);

                  // calculate next point
                  NewPt:= Point2d(CurrentPos.X+DisplX, CurrentPos.Y+DisplY);
                  // now use the bulge factor to calculate arc points
                  MidPoint:= Point2d((CurrentPos.X+Newpt.X)/2,(CurrentPos.Y+Newpt.Y)/2);
                  BulgeHeight:= (Abs(Bulge)/254)*Dist2d(CurrentPos,NewPt);
                  // calculate a point that goes from MidPoint to Newpt a distance BulgeHeight
                  V:= TEzVector.Create(2);
                  try
                    V.Add(CurrentPos);
                    V.Add(NewPt);
                    V.TravelDistance(Dist2d(CurrentPos,MidPoint)+BulgeHeight,BulgePt,Index1,Index2);
                  finally
                    V.Free;
                  end;
                  // now rotate this point 90 degrees clockwise or counterclockwise
                  if Bulge<0 then
                    M:=Rotate2d(System.Pi/2,MidPoint)
                  else
                    M:=Rotate2d(-System.Pi/2,MidPoint);
                  BulgePt:= TransformPoint2d(BulgePt,M);
                  // build an arc with the three points calculated
                  Arc:=TEzArc.CreateEntity(CurrentPos,BulgePt,NewPt);
                  try
                    Arc.PointsInCurve:=10;    // 10=enough for now
                    if NewPt.X > MaxX then MaxX:= NewPt.X;
                    if ExecuteCommand then
                    begin
                      if IsDrawing then
                      begin
                        // add all the arc points to the resulting vector
                        for J:=0 to Arc.DrawPoints.Count-1 do
                          FVector.Add(Arc.DrawPoints[J]);
                      end;
                      CurrentPos:= NewPt;
                    end;
                  finally
                    Arc.Free;
                  end;

                  inc(n);
                  DisplX:= GetNumber(shpElems[n]) * scalefactor;
                  inc(n);
                  DisplY:= GetNumber(shpElems[n]) * scalefactor;
                end;
                ExecuteCommand:= true;
              end;
            14: // Process if vertical
              begin
                //ExecuteCommand:= (OrientationMode=2);
                ExecuteCommand:= false;
              end;
          end;
        end;
        Inc(n);
        CommandCode:= GetNumber(shpElems[n]);
      end;

      if FVector.Count=0 then continue;

      if FVector.Parts.Count < 2 then
        FVector.Parts.Clear;

      TmpExt:= FVector.Extension;
      MinBound(Bounds.Emin, TmpExt.Emin);
      MaxBound(Bounds.Emax, TmpExt.Emax);

      if IsValidChar then
      begin
        V:= TEzVector.Create(FVector.Count);
        V.Assign(FVector);
        CharVectList[numChar]:= V;
        if numChar > MaxChar then MaxChar := numChar;
      end;

      StartPoint.X:= 0;
      StartPoint.Y:= 0;
    end;
    if ChkShow.Checked then
    begin
      with PBox2.Canvas do
      begin
        Brush.Style := bsSolid;
        Brush.Color := clWhite;
        FillRect(ClientRect);
      end;
      Grapher.SetViewport(0, 0, Pbox2.Width, Pbox2.Height);
      Grapher.SetWindow(Bounds.X1-1, Bounds.X2+1, Bounds.Y1-1, Bounds.Y2+1);
      PenStyle.style:=1;
      PenStyle.Color:=clBlack;
      PenStyle.Scale:=0;
      for I:= 0 to MaxChar do
        if CharVectList[I] <> nil then
        begin
          LblAscii.Caption:= IntToStr(I);
          V:= TEzVector(CharVectList[I]);
          PBox2.Refresh;
          V.DrawOpened( Pbox2.Canvas,
                        Bounds,
                        Bounds,
                        Grapher,
                        PenStyle,
                        IDENTITY_MATRIX2D,
                        dmNormal );
          if MessageDlg('Continue ?',mtConfirmation,[mbYes,mbNo],0)<>mryes then break;
        end;
    end;

    { Now transform all the vectors }
    VectorFont.MaxChar:= MaxChar;   // this will increase capacity
    M1 := Translate2D(-Bounds.Emin.X, -Bounds.Emin.Y);
    M2 := Scale2D(1/Abs(Bounds.Emax.X-Bounds.Emin.X), 1/Abs(Bounds.Emax.Y-Bounds.Emin.Y), Bounds.Emin);
    M  := MultiplyMatrix2D(M1, M2);
    for I:= 0 to MaxChar do
      if CharVectList[I] <> nil then
      begin
        V:= TEzVector(CharVectList[I]);
        for J:= 0 to V.Count-1 do
          V[J] := TransformPoint2D(V[J], M);

        VectorChar:= TEzVectorChar.Create;
        VectorChar.Vector.Assign(V);
        VectorFont.Chars[I] := VectorChar;
        V.Free;
      end;
    VectorFont.Name:= LblShpFontname.Caption;
    VectorFont.MaxChar:= MaxChar;
    VectorFont.SaveToFile(Edit3.Text);
  finally
    VectorFont.free;
    SHPElems.Free;
    xStack.free;
    yStack.free;
    CharVectList.free;
    Grapher.free;
  end;
  ShowMessage('Font File generation succesful');

end;

procedure TfrmFontGenerator.SpeedButton1Click(Sender: TObject);
begin
  SaveDialog1.FileName:= Edit3.Text;
  if not SaveDialog1.Execute then Exit;
  Edit3.Text := SaveDialog1.FileName;
  CurrPath:= AddSlash(ExtractFilePath(SaveDialog1.FileName));
end;

end.
