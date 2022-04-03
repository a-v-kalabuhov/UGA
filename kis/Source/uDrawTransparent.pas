unit uDrawTransparent;

interface

uses
  SysUtils, Windows, Graphics, Contnrs, Types,
  uGC, uTasks,
  uKisIntf;

type
  IDrawTransparent = interface
    ['{684931DC-42B4-49ED-A379-99F8DB43A1B8}']
    procedure Draw(Target, Source: TBitmap; TransparentClr: TColor);
  end;

  TDrawTransparentKind = (drawThreaded, drawBlt);

  TDrawTransparentFactory = class
  public
    class function GetDraw(Folders: IKIsFolders; const Kind: TDrawTransparentKind): IDrawTransparent;
  end;

implementation

type
  TThreadedDrawTransparent = class(TInterfacedObject, IDrawTransparent)
  private
    FThreadCount: Byte;
    procedure Draw(Target, Source: TBitmap; TransparentClr: TColor);
  public
    constructor Create(const ThreadCount: Byte);
  end;

  TBltDrawTransparent = class(TInterfacedObject, IDrawTransparent)
  private
    procedure Draw(Target, Source: TBitmap; TransparentClr: TColor);
  end;

  TDrawTransparent = class
  private type
    TDrawTranspTask = class(TTask)
    private
      FTarget, FSource: TBitmap;
      FG, FB, FR: Byte;
      FStart, FEnd: Integer;
    protected
      procedure Execute; override;
    public
      constructor Create(Target, Source: TBitmap; Rt, Gt, Bt: Byte; StartLine, EndLine: Integer);
      destructor Destroy; override;
      //
      property Start: Integer read FStart;
      property Result: TBitmap read FTarget;
    end;
  private
    class procedure IntDraw(Target, Source: TBitmap; Rt, Gt, Bt: Byte);
  public
    class procedure Draw(Target, Source: TBitmap; TransparentClr: TColor; const TaskCount: Byte);
  end;

{ TDrawTransparent }

class procedure TDrawTransparent.Draw(Target, Source: TBitmap;
  TransparentClr: TColor; const TaskCount: Byte);
var
  Cnt, I, N, Y1, Y2: Integer;
  Bmp: TBitmap;
  Box: IBox;
  Exec: TTaskExecutor;
  aTask: TDrawTranspTask;
  Tasks: TObjectList;
  Rt, Bt, Gt: Byte;
//  Ba1, Ba2: Boolean;
begin
  if (Target.Width = 0) or (Target.Height = 0) or (Source.Width = 0) or (Source.Height = 0) then
    Exit;
//  Ba1 := Target.IsBottomUp;
//  Ba2 := Source.IsBottomUp;
  if (Target.Width <> Source.Width) or (Target.Height <> Source.Height) then
  begin
    Bmp := TBitmap.Create;
    Box := Bmp.Forget;
    Bmp.PixelFormat := pf24bit;
    Bmp.SetSize(Target.Width, Target.Height);
    Bmp.Canvas.StretchDraw(Rect(0, 0, Bmp.Width, Bmp.Height), Source);
//    if Bmp.IsBottomUp <> Ba1 then
//      Beep;
  end
  else
    Bmp := Source;
  //
  Rt := GetRValue(TransparentClr);
  Gt := GetGValue(TransparentClr);
  Bt := GetBValue(TransparentClr);
  //
  Cnt := TaskCount;
  if Cnt < 1 then
    Cnt := 1;
  if Cnt > 0 then // чисто дл€ тестов
//  if Cnt < 2 then
    IntDraw(Target, Bmp, Rt, Gt, Bt)
  else
  begin
    Exec := TTaskExecutor.Create;
    Exec.Forget;
    Tasks := TObjectList.Create;
    Tasks.Forget;
    //
    N := Target.Height div Cnt;
    Y1 := 0;
    for I := 1 to Cnt do
    begin
      if I = Cnt then
        Y2 := Target.Height - 1
      else
        Y2 := Y1 + N - 1;
      aTask := TDrawTranspTask.Create(Target, Bmp, Rt, Gt, Bt, Y1, Y2);
      Exec.AddTask(aTask);
      Tasks.Add(aTask);
      Y1 := Y2 + 1;
    end;
    Exec.Execute('ѕрозрачна€ прорисовка', 600000);
    //
    for I := 0 to Tasks.Count - 1 do
    begin
      aTask := Tasks[I] as TDrawTranspTask;
      Target.Canvas.Draw(0, aTask.Start, aTask.Result);
    end;
  end;
end;

class procedure TDrawTransparent.IntDraw(Target, Source: TBitmap; Rt, Gt, Bt: Byte);
var
  X, Y, Idx: Integer;
  ScanLine1, ScanLine2: PByteArray;
  R2, G2, B2: Byte;
begin
  for Y := 0 to Target.Height - 1 do
  begin
    ScanLine1 := Target.ScanLine[Y];
    ScanLine2 := Source.ScanLine[Y];
    //
    Idx := 0;
    for X := 0 to Target.Width - 1 do
    begin
      R2 := ScanLine2[Idx];
      G2 := ScanLine2[Idx + 1];
      B2 := ScanLine2[Idx + 2];
      if (R2 <> Rt) or (B2 <> Bt) or (G2 <> Gt) then
      begin
        ScanLine1[Idx] := R2;
        ScanLine1[Idx + 1] := G2;
        ScanLine1[Idx + 2] := B2;
      end;
      Idx := Idx + 3;
    end;
  end;
end;

{ TDrawTransparent.TDrawTranspTask }

constructor TDrawTransparent.TDrawTranspTask.Create(Target, Source: TBitmap; Rt,
  Gt, Bt: Byte; StartLine, EndLine: Integer);
begin
  inherited Create;
  FTarget := TBitmap.Create;
  FTarget.PixelFormat := pf24bit;
  FTarget.SetSize(Target.Width, EndLine - StartLine + 1);
  FTarget.Canvas.CopyRect(
    Rect(0, 0, FTarget.Width, FTarget.Height),
    Target.Canvas,
    Rect(0, StartLine, Target.Width, EndLine));
  FSource := Source;
  FG := Gt;
  FB := Bt;
  FR := Rt;
  FStart := StartLine;
  FEnd := EndLine;
end;

destructor TDrawTransparent.TDrawTranspTask.Destroy;
begin
  FreeAndNil(FTarget);
  inherited;
end;

procedure TDrawTransparent.TDrawTranspTask.Execute;
var
  X, Y, Idx: Integer;
  ScanLine1, ScanLine2: PByteArray;
  R, G, B: Byte;
begin
  for Y := FStart to FEnd do
  begin
    ScanLine1 := FTarget.ScanLine[Y - FStart];
    ScanLine2 := FSource.ScanLine[Y];
    //
    Idx := 0;
    for X := 0 to FTarget.Width - 1 do
    begin
      R := ScanLine2[Idx];
      G := ScanLine2[Idx + 1];
      B := ScanLine2[Idx + 2];
      if (R <> FR) or (B <> FB) or (G <> FG) then
      begin
        ScanLine1[Idx] := R;
        ScanLine1[Idx + 1] := G;
        ScanLine1[Idx + 2] := B;
      end;
      Idx := Idx + 3;
    end;
  end;
end;

{ TDrawTransparentFactory }

class function TDrawTransparentFactory.GetDraw(Folders: IKIsFolders; const Kind: TDrawTransparentKind): IDrawTransparent;
begin
  case Kind of
    drawThreaded:
      Result := TThreadedDrawTransparent.Create(Folders.ThreadCount) as IDrawTransparent;
    drawBlt:
      Result := TBltDrawTransparent.Create() as IDrawTransparent;
  end;
end;

{ TThreadedDrawTransparent }

constructor TThreadedDrawTransparent.Create(const ThreadCount: Byte);
begin
  inherited Create;
  FThreadCount := ThreadCount;
end;

procedure TThreadedDrawTransparent.Draw(Target, Source: TBitmap; TransparentClr: TColor);
begin
  TDrawTransparent.Draw(Target, Source, TransparentClr, FThreadCount);
end;

{ TBltDrawTransparent }

procedure TBltDrawTransparent.Draw(Target, Source: TBitmap; TransparentClr: TColor);
var
  B1: Bool;
  RgbClr: Integer;
//  RgbClr2: Integer;
//  ScanLine2: PByteArray;
//  R, G, B: Byte;
begin
  RgbClr := ColorToRGB(TransparentClr);
{
  TransparentClr := Source.Canvas.Pixels[0, 0];
  RgbClr := ColorToRGB(TransparentClr);
  ScanLine2 := Source.ScanLine[0];
  R := ScanLine2[0];
  G := ScanLine2[1];
  B := ScanLine2[2];
  RgbClr2 := RGB(R, G, B);
  if RgbClr <> RgbClr2 then
    RgbClr := RgbClr2;
}
  B1 := TransparentBlt(
    Target.Canvas.Handle,
    0,
    0,
    Target.Width - 1,
    Target.Height - 1,
    Source.Canvas.Handle,
    0,
    0,
    Source.Width - 1,
    Source.Height - 1,
    RgbClr
  );
  if not B1 then
    RaiseLastOSError;
end;

end.
