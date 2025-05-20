unit uMStFramesMPIntersectItem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ImgList, Menus, Clipbrd,
  JvExControls, JvSpeedButton,
  EzLib,
  uCK36, uGeoTypes,
  uEzGeometry, StdActns, ActnList, ExtCtrls;

type
  TmstMPIntersectItemFrame = class;

  TIntersectItemEvent = procedure (Sender: TmstMPIntersectItemFrame; const ObjId: Integer) of object;

  TmstMPIntersectItemFrame = class(TFrame)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    edPoint1: TEdit;
    Label4: TLabel;
    edPoint2: TEdit;
    btnCopyPoint1: TJvSpeedButton;
    btnCopyPoint2: TJvSpeedButton;
    PopupMenu1: TPopupMenu;
    JvSpeedButton3: TJvSpeedButton;
    N1: TMenuItem;
    N2: TMenuItem;
    N11: TMenuItem;
    N21: TMenuItem;
    ImageList1: TImageList;
    N3: TMenuItem;
    Label1: TLabel;
    edID: TEdit;
    Label3: TLabel;
    edAddress: TEdit;
    Label5: TLabel;
    edProjectNum: TEdit;
    ActionList1: TActionList;
    PopupMenu2: TPopupMenu;
    N4: TMenuItem;
    acCopyPoint: TAction;
    Image1: TImage;
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure btnCopyPoint1Click(Sender: TObject);
    procedure btnCopyPoint2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure acCopyPointExecute(Sender: TObject);
  private
    FPoint2: TEzPoint;
    FPoint2Empty: Boolean;
    FPoint1: TEzPoint;
    FPoint1Empty: Boolean;
    FCoordSystem: TCoordSystem;
    FKind: TSegmentsArrangement;
    FObjId: Integer;
    FOnItemProperties: TIntersectItemEvent;
    FOnDisplayItem: TIntersectItemEvent;
    FDisplaying: Boolean;
    FOnLocateItem: TIntersectItemEvent;
    procedure SetTitle(const Value: string);
    function GetTitle: string;
    procedure SetPoint1(const Value: TEzPoint);
    procedure SetPoint2(const Value: TEzPoint);
    procedure SetCoordSystem(const Value: TCoordSystem);
    function PointToText(const aPoint: TEzPoint; const Empty: Boolean): String;
    procedure UpdatePointsText();
    procedure SetObjId(const Value: Integer);
    procedure SetOnItemProperties(const Value: TIntersectItemEvent);
    procedure SetOnDisplayItem(const Value: TIntersectItemEvent);
    procedure SetDisplaying(const Value: Boolean);
    procedure CopyPointToClipboard(const aPt: TEzPoint);
    procedure SetOnLocateItem(const Value: TIntersectItemEvent);
    procedure SetAddress(const Value: string);
    procedure SetProjectNumber(const Value: string);
    function GetAddress: string;
    function GetProjectNumber: string;
  public
    constructor Create(AOwner: TComponent); override;
    //
    property ObjId: Integer read FObjId write SetObjId;
    property Title: string read GetTitle write SetTitle;
    property Address: string read GetAddress write SetAddress;
    property ProjectNumber: string read GetProjectNumber write SetProjectNumber;
    property Point1: TEzPoint read FPoint1 write SetPoint1;
    property Point2: TEzPoint read FPoint2 write SetPoint2;
    property CoordSystem: TCoordSystem read FCoordSystem write SetCoordSystem;
    function IsPoint1Empty: Boolean;
    function IsPoint2Empty: Boolean;
    //
    property Displaying: Boolean read FDisplaying write SetDisplaying;
    //
    property OnDisplayItem: TIntersectItemEvent read FOnDisplayItem write SetOnDisplayItem;
    property OnItemProperties: TIntersectItemEvent read FOnItemProperties write SetOnItemProperties;
    property OnLocateItem: TIntersectItemEvent read FOnLocateItem write SetOnLocateItem;
  end;

implementation

{$R *.dfm}

{ TFrame1 }

procedure TmstMPIntersectItemFrame.CopyPointToClipboard(const aPt: TEzPoint);
var
  S: string;
begin
  S := Format('%0.2f', [aPt.Y]) + #9 +
       Format('%0.9f', [aPt.X]) + #9;
  if FCoordSystem = csMCK36 then
    S := S + 'MSK36'
  else
    S := S + 'VRN';
  S := S + #9;
  Clipboard.AsText := S;
end;

constructor TmstMPIntersectItemFrame.Create(AOwner: TComponent);
begin
  inherited;
  FPoint1Empty := True;
  FPoint2Empty := True;
  FDisplaying := False;
end;

function TmstMPIntersectItemFrame.GetAddress: string;
begin
  Result := edAddress.Text;
end;

function TmstMPIntersectItemFrame.GetProjectNumber: string;
begin
  Result := edProjectNum.Text;
end;

function TmstMPIntersectItemFrame.GetTitle: string;
begin
  Result := GroupBox1.Caption;
end;

function TmstMPIntersectItemFrame.IsPoint1Empty: Boolean;
begin
  Result := FPoint1Empty;
end;

function TmstMPIntersectItemFrame.IsPoint2Empty: Boolean;
begin
  Result := FPoint2Empty;
end;

procedure TmstMPIntersectItemFrame.acCopyPointExecute(Sender: TObject);
begin
  if (Screen.ActiveControl = edPoint1) then
  begin
    if FPoint1Empty then
      Exit;
    CopyPointToClipboard(FPoint1);
  end
  else
  if (Screen.ActiveControl = edPoint2) then
  begin
    if FPoint2Empty then
      Exit;
    CopyPointToClipboard(FPoint2);
  end;
end;

procedure TmstMPIntersectItemFrame.btnCopyPoint1Click(Sender: TObject);
begin
  if FPoint1Empty then
    Exit;
  CopyPointToClipboard(FPoint1);
end;

procedure TmstMPIntersectItemFrame.btnCopyPoint2Click(Sender: TObject);
begin
  if FPoint2Empty then
    Exit;
  CopyPointToClipboard(FPoint2);
end;

procedure TmstMPIntersectItemFrame.N1Click(Sender: TObject);
begin
  if Assigned(FOnDisplayItem) then
    FOnDisplayItem(Self, FObjId);
end;

procedure TmstMPIntersectItemFrame.N2Click(Sender: TObject);
begin
  if Assigned(FOnItemProperties) then
  begin
    FOnItemProperties(Self, FObjId);
  end;
end;

procedure TmstMPIntersectItemFrame.N3Click(Sender: TObject);
begin
  if Assigned(FOnLocateItem) then
    FOnLocateItem(Self, FObjId);
end;

function TmstMPIntersectItemFrame.PointToText(const aPoint: TEzPoint; const Empty: Boolean): String;
var
  X, Y: Double;
begin
  if Empty then
  begin
    Result := 'X: -; Y: -';
  end
  else
  begin
    if FCoordSystem = csMCK36 then
      ToCK36(aPoint.X, aPoint.y, X, Y)
    else
    begin
      X := aPoint.x;
      Y := aPoint.y;
    end;
    //
    Result := Format('X: %8.2f; Y: %8.2f', [Y, X]);
  end;
end;

procedure TmstMPIntersectItemFrame.SetAddress(const Value: string);
begin
  edAddress.Text := Value;
end;

procedure TmstMPIntersectItemFrame.SetCoordSystem(const Value: TCoordSystem);
begin
  FCoordSystem := Value;
  UpdatePointsText();
end;

procedure TmstMPIntersectItemFrame.SetDisplaying(const Value: Boolean);
begin
  FDisplaying := Value;
  Image1.Visible := FDisplaying;
end;

procedure TmstMPIntersectItemFrame.SetObjId(const Value: Integer);
begin
  FObjId := Value;
  edID.Text := IntToStr(Value);
end;

procedure TmstMPIntersectItemFrame.SetOnDisplayItem(const Value: TIntersectItemEvent);
begin
  FOnDisplayItem := Value;
end;

procedure TmstMPIntersectItemFrame.SetOnItemProperties(const Value: TIntersectItemEvent);
begin
  FOnItemProperties := Value;
end;

procedure TmstMPIntersectItemFrame.SetOnLocateItem(const Value: TIntersectItemEvent);
begin
  FOnLocateItem := Value;
end;

procedure TmstMPIntersectItemFrame.SetPoint1(const Value: TEzPoint);
begin
  FPoint1 := Value;
  FPoint1Empty := False;
  edPoint1.Text := PointToText(FPoint1, FPoint1Empty);
  btnCopyPoint1.Enabled := not FPoint1Empty;
end;

procedure TmstMPIntersectItemFrame.SetPoint2(const Value: TEzPoint);
begin
  FPoint2 := Value;
  FPoint2Empty := False;
  edPoint2.Text := PointToText(FPoint2, FPoint2Empty);
  btnCopyPoint2.Enabled := not FPoint2Empty;
end;

procedure TmstMPIntersectItemFrame.SetProjectNumber(const Value: string);
begin
  edProjectNum.Text := Value;
end;

procedure TmstMPIntersectItemFrame.SetTitle(const Value: string);
begin
  GroupBox1.Caption := Value;
end;

procedure TmstMPIntersectItemFrame.UpdatePointsText;
begin
  edPoint1.Text := PointToText(FPoint1, FPoint1Empty);
  edPoint2.Text := PointToText(FPoint2, FPoint2Empty);
end;

end.
