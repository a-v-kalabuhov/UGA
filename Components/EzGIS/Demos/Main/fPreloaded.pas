unit fPreloaded;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, CheckLst, Messages;

type

  TfrmPreloaded = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    LblCommonSubDir: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Check1: TCheckBox;
    Check2: TCheckBox;
    Check3: TCheckBox;
    CheckList1: TCheckListBox;
    CheckList2: TCheckListBox;
    CheckList3: TCheckListBox;
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CheckList1Click(Sender: TObject);
    procedure CheckList2Click(Sender: TObject);
    procedure CheckList3Click(Sender: TObject);
    procedure CheckList1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  ezsystem, ezbase;

procedure TfrmPreloaded.FormCreate(Sender: TObject);
var
  i,N:integer;
  Filter,Filters, filenam:string;

  procedure PopulateList(CheckList: TCheckListBox);
  var
    I: integer;
    srchRec: TSearchRec;
  begin
    i:=FindFirst(AddSlash(Ez_Preferences.CommonSubDir)+Filter, (faReadOnly+faHidden), srchRec);
    try
      while i=0 do
      begin
        if (srchRec.Name<>'.') and (srchRec.Name<>'..') then
        begin
          CheckList.Items.AddObject( srchRec.Name, Pointer(srchRec.Size) );
        end;
        I:=FindNext(srchRec);
      end;
    finally
      FindClose(srchRec);
    end;
  end;

begin

  { dynamically created tabbed check list boxed }

  LblCommonSubdir.Caption:= Ez_Preferences.CommonSubDir;

          Filters:= '.bmp' +
{$IFDEF GIF_SUPPORT}
                '.gif' +
{$ENDIF}
                '.wmf' +
                '.emf' +
                '.ico'
{$IFDEF USE_GRAPHICEX}
  {$IFDEF TIFFGraphic}
                + '.tif'
  {$ENDIF}
  {$IFDEF TargaGraphic}
                + '.tga'
  {$ENDIF}
  {$IFDEF PCXGraphic}
                + '.pcx'
  {$ENDIF}
  {$IFDEF PCDGraphic}
                + '.pcd'
  {$ENDIF}
{$IFNDEF GIF_SUPPORT}
  {$IFDEF GIFGraphic}
                + '.gif'
  {$ENDIF}
{$ENDIF}
  {$IFDEF PhotoshopGraphic}
                + '.psd'
                + '.pdd'
  {$ENDIF}
  {$IFDEF PaintshopProGraphic}
                + '.psp'
  {$ENDIF}
  {$IFDEF PortableNetworkGraphic}
                + '.png'
  {$ENDIF}

{$ENDIF}
          ;
  N:= Length(Filters) div 4;
  for i:=1 to N do
  begin
    Filter:='*'+Copy(Filters,(I-1)*4+1,4);
    PopulateList(CheckList1);
  end;
  { check the already preloaded }
  for I:= 0 to CheckList1.Items.Count-1 do
  begin
    filenam:= CheckList1.Items[I];
    If Ez_Preferences.PreloadedImages.IndexOf(filenam)>=0 then
      CheckList1.Checked[I]:= True;
  end;
  Check1.Checked:= Ez_Preferences.UsePreloadedImages;

  Filter:='*.BMP';
  PopulateList(CheckList2);
  Filter:='*.BIL';
  PopulateList(CheckList2);
  Filter:='*.TIF';
  PopulateList(CheckList2);
  for I:= 0 to CheckList2.Items.Count-1 do
  begin
    filenam:= CheckList2.Items[I];
    If Ez_Preferences.PreloadedBandedImages.IndexOf(filenam)>=0 then
      CheckList2.Checked[I]:= True;
  end;
  Check2.Checked:= Ez_Preferences.UsePreloadedBandedImages;

  Filter:='*.edb';
  PopulateList(CheckList3);

  for I:= 0 to CheckList3.Items.Count-1 do
  begin
    filenam:= CheckList3.Items[I];
    If Ez_Preferences.PreloadedBlocks.IndexOf(filenam)>=0 then
      CheckList3.Checked[I]:= True;
  end;
  Check3.Checked:= Ez_Preferences.UsePreloadedBlocks;

end;

procedure TfrmPreloaded.CheckList1Click(Sender: TObject);
var
  filenam: string;
begin
  If CheckList1.ItemIndex < 0 then Exit;
  filenam:= CheckList1.Items[CheckList1.ItemIndex];
  If CheckList1.Checked[CheckList1.ItemIndex] Then
  begin
    Screen.Cursor:= crHourglass;
    try
      try
        Ez_Preferences.AddPreloadedImage(AddSlash(Ez_Preferences.CommonSubdir)+filenam);
      except
        CheckList1.Checked[CheckList1.ItemIndex]:=false;
        raise;
      end;
    finally
      Screen.Cursor:= crDefault;
    end;
  end else
    Ez_Preferences.DeletePreloadedImage(AddSlash(Ez_Preferences.CommonSubdir)+filenam);
end;

procedure TfrmPreloaded.CheckList2Click(Sender: TObject);
var
  filenam: string;
begin
  If (CheckList2.ItemIndex < 0) then Exit;
  filenam:= CheckList2.Items[CheckList2.ItemIndex];
  If CheckList2.Checked[CheckList2.ItemIndex] Then
  begin
    Screen.Cursor:= crHourglass;
    try
      try
        Ez_Preferences.AddPreloadedBandedImage(AddSlash(Ez_Preferences.CommonSubdir)+filenam);
      except
        CheckList2.Checked[CheckList2.ItemIndex]:=false;
        raise;
      end;
    finally
      Screen.Cursor:= crDefault;
    end;
  end else
    Ez_Preferences.DeletePreloadedBandedImage(AddSlash(Ez_Preferences.CommonSubdir)+filenam);
end;

procedure TfrmPreloaded.CheckList3Click(Sender: TObject);
var
  filenam: string;
begin
  If (CheckList3.ItemIndex < 0) then Exit;
  filenam:= CheckList3.Items[CheckList3.ItemIndex];
  if CheckList3.Checked[CheckList3.ItemIndex] then
  begin
    Screen.Cursor:= crHourglass;
    try
      try
        Ez_Preferences.AddPreloadedBlock(AddSlash(Ez_Preferences.CommonSubdir)+filenam);
      except
        CheckList3.Checked[CheckList3.ItemIndex]:=false;
        raise;
      end;
    finally
      Screen.Cursor:= crDefault;
    end;
  end else
    Ez_Preferences.DeletePreloadedBlock(AddSlash(Ez_Preferences.CommonSubdir)+filenam);
end;

procedure TfrmPreloaded.OKBtnClick(Sender: TObject);
begin
  Ez_Preferences.UsePreloadedImages:= Check1.Checked;
  Ez_Preferences.UsePreloadedBandedImages:= Check2.Checked;
  Ez_Preferences.UsePreloadedBlocks:= Check3.Checked;
end;

procedure TfrmPreloaded.CheckList1DrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  AText: string;
  ASize: integer;
begin
  with (Control as TCheckListBox) do
  begin
    AText:= Items[Index];
    ASize:= Longint(Items.Objects[Index]);
  end;
  with (Control as TCheckListBox).Canvas do
  begin
    if odSelected in State then
       Brush.Color := clHighlight
    else
       Brush.Color := (Control as TCheckListBox).Color;
    Brush.Style := bsSolid;
    FillRect( Rect );
    Brush.Style := bsClear;
    Font.Assign((Control as TCheckListBox).Font);
    if odSelected in State then
       Font.Color := clHighlightText;
    DrawText(Handle,PChar(AText),-1,Rect, DT_LEFT or DT_VCENTER);
    Rect.Left:= Rect.Left + Round(0.60 * (Rect.Right - Rect.Left));
    AText:= Format('%14.0n',[ASize*1.0]);
    DrawText(Handle,PChar(AText),-1,Rect, DT_LEFT or DT_VCENTER);
  end;
end;

end.
