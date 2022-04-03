unit uHintWindow;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfmHINT = class(TForm)
    Timer: TTimer;
    laHINT1: TLabel;
    laHINT2: TLabel;
    procedure TimerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    BM:TBitmap;
    BM2:TBitmap;
    Moving:Boolean;
    procedure WMEraseBkgnd(var Msg:TWMEraseBkgnd);message WM_EraseBkgnd;
    procedure WMPaint(var Msg:TWMPaint);message WM_Paint;
    procedure WMMove(var Msg:TMessage);message WM_Move;
    procedure WMEnterSizeMove(var Msg:TMessage);message WM_EnterSizeMove;
    procedure WMExitSizeMove(var Msg:TMessage);message WM_ExitSizeMove;
  public
    constructor CreateHintWindow(AOwner: TComponent; const Text1, text2: String);
  end;

var
  fmHINT: TfmHINT;

procedure ShowTransparentHint(const ATop, ALeft: Integer; const Text1, Text2: String);

const
  Transparency: Integer = 40;
  TranspColor: TColor = 14352090;
  DelayTime: Integer = 400;

type
  PRGBArray = ^TRGBArray;
  TRGBArray = array[0..1000000] of TRGBTriple;

implementation

procedure Delay (DelayTime : cardinal);
var
  TicksNow : cardinal;
begin
  TicksNow := GetTickCount;
  repeat
    Application.ProcessMessages
  until (GetTickCount - TicksNow) >= DelayTime;
end;

procedure ShowTransparentHint(const ATop, ALeft: Integer; const Text1, Text2: String);
begin
  with TfmHINT.CreateHintWindow(Application, Text1, Text2) do
  begin
    Top := ATop;
    Left := ALeft;
    Show;
  end;
end;

procedure TfmHINT.WMEraseBkgnd;
begin
  Msg.Result := 1;
end;

procedure TfmHINT.WMPaint;
var
  DC:HDC;
  PS:TPaintStruct;
  CW,CH,CX,CY:Integer;
  SL:PRGBArray;
  X,Y:Integer;
begin
  CW:=ClientWidth;
  CH:=ClientHeight;
  CX:=ClientOrigin.X;
  CY:=ClientOrigin.Y;

  if not Moving then
  begin
    ShowWindow(Handle,SW_Hide);
    SetActiveWindow(0);
    Delay(400);
    DC:=GetDC(0);
    BitBlt(BM.Canvas.Handle,0,0,BM.Width,BM.Height,DC,0,0,SrcCopy);
    ReleaseDC(0,DC);
  end;

  BM2.Width:=CW+1;
  BM2.Height:=CH+1;
  BM2.PixelFormat:=pf24bit;
  BM2.Canvas.Draw(-CX,-CY,BM);
  for Y:=0 to CH do
  begin
    SL:=BM2.ScanLine[Y];
    for X:=0 to CW do
    begin
      SL[X].rgbtRed:=(Transparency*SL[X].rgbtRed+(100-Transparency)*GetRValue(TranspColor)) div 100;
      SL[X].rgbtGreen:=(Transparency*SL[X].rgbtGreen+(100-Transparency)*GetGValue(TranspColor)) div 100;
      SL[X].rgbtBlue:=(Transparency*SL[X].rgbtBlue+(100-Transparency)*GetBValue(TranspColor)) div 100
    end;
  end;

  ShowWindow(Handle,SW_Show);

  DC:=BeginPaint(Handle,PS);

  BitBlt(DC,0,0,BM2.Width,BM2.Height,BM2.Canvas.Handle,0,0,SrcCopy);

  Msg.DC:=DC;
  inherited;

  EndPaint(Handle,PS);
end;

procedure TfmHINT.WMMove;
begin
  Invalidate;
  inherited;
end;

procedure TfmHINT.WMEnterSizeMove;
begin
  Moving:=True;
  inherited;
end;

procedure TfmHINT.WMExitSizeMove;
begin
  inherited;
  Moving:=False;
end;


procedure TfmHINT.TimerTimer(Sender: TObject);
begin
  fmHINT.Free;
end;

procedure TfmHINT.FormDestroy(Sender: TObject);
begin
  BM.Free;
  BM2.Free
end;

constructor TfmHINT.CreateHintWindow(AOwner: TComponent; const Text1,
  text2: String);
var
  Rgn : HRgn;
  Tops : array [0..14] of TPoint;
  HintWidth : integer;
begin
  inherited;
  laHINT1.Left := 10;
  if Length(Text1) > Length(Text2) then
    HintWidth := fmHINT.Canvas.TextWidth(Text1)
  else
    HintWidth := fmHINT.Canvas.TextWidth(Text2);
  Width := HintWidth + laHINT1.Left + 30;
  laHINT1.Caption := Text1;
  if Text2 = '' then
    laHINT1.Top:= 22
  else
  begin
    laHINT2.Caption:= Text2;
    laHINT1.Top:= 13;
    laHINT2.Top:= 29;
    laHINT2.Left:= laHINT1.Left;
    laHINT2.Width:= Width;
    laHINT2.Visible:= true;
  end;

  Color:= 14352090;

  Tops[0]:= Point(10,0);
  Tops[1]:= Point(24,14);
  Tops[2]:= Point(32 + HintWidth,14);

  Tops[3]:= Point(35 + HintWidth,16 + 2);
  Tops[4]:= Point(37 + HintWidth,20 + 5);
  Tops[5]:= Point(37 + HintWidth,27 + 12);
  Tops[6]:= Point(35 + HintWidth,31 + 15);
  Tops[7]:= Point(32 + HintWidth,33 + 17);
  Tops[8]:= Point(5,33 + 17);
  Tops[9]:= Point(3,31 + 15);
  Tops[10]:= Point(0,27 + 12);
  Tops[11]:= Point(0,20 + 5);
  Tops[12]:= Point(2,16 + 2);

  Tops[13]:= Point(5,14);
  Tops[14]:= Point(14,14);
  Rgn:= CreatePolygonRgn(Tops, 15, WINDING);
  SetWindowRgn(Handle, Rgn, True);


  BM := TBitmap.Create;
  BM.PixelFormat := pf24bit;
  BM.SetSize(GetSystemMetrics(SM_CXScreen), GetSystemMetrics(SM_CYScreen));
  BM2:=TBitmap.Create;
  Moving:=False
end;

end.

