unit IWCompMap;

{********************************************}
{   TEzIWMap Component                       }
{   IntraWeb Compatible TDrawBox             }
{                                            }
{   Copyright (c) 2002 by EzSoft Engineering }
{   All Rights Reserved                      }
{                                            }
{   Intraweb is Copyright:                   }
{   Copyright © 2001-2002 AToZed Software.   }
{   All rights Reserved.                     }
{********************************************}

{$I EZ_FLAG.PAS}
interface

uses
  Windows, SysUtils, Classes, Controls, IWExtCtrls, EzBase, EzLib, EzBaseGis,
  EzBasicCtrls, IWHTMLTag, IWAppForm, IWGrids, IWCompCheckBox ;

type

  TEzCurrentAction = ( caNone, caZoomIn, caZoomOut, caPickEntity, caZoomWin,
                       caPan, caSelect, caCircleSelect );

  TEzEdge = ( edNone, edBump, edEtched, edRaised, edSunken );

  TEzIWScaleBar = Class;

  TEzIWMap = class(TIWDynamicImage)
  Private
    FDrawBox: TEzDrawBox;
    FCurrentAction: TEzCurrentAction;
    FStackedSelList: TStrings;
    FEdge: TEzEdge;
    FUseMyOnClick : Boolean;
    FIWScaleBar : TEzIWScaleBar;
    FGraphicOperator : TEzGraphicOperator;
    FUseCircleSelect : Boolean;
    FNumberOfLabelsInCS : Integer;
    FCoordFunction : String;

    FOnEntityClick: TEzEntityClickEvent;
    Procedure SetDrawBox( Value: TEzDrawBox );
    Procedure SetIWScaleBar( Value: TEzIWScaleBar );
    function GetAbout: TEzAbout;
    procedure SetAbout(const Value: TEzAbout);
  {$IFDEF BCB}
    function GetCoordFunction: String;
    function GetDrawBox: TEzDrawBox;
    function GetEdge: TEzEdge;
    function GetGraphicOperator: TEzGraphicOperator;
    function GetIWScaleBar: TEzIWScaleBar;
    function GetNumberOfLabelsInCS: Integer;
    function GetOnEntityClick: TEzEntityClickEvent;
    procedure SetEdge(const Value: TEzEdge);
    procedure SetGraphicOperator(const Value: TEzGraphicOperator);
    procedure SetOnEntityClick(const Value: TEzEntityClickEvent);
  {$ENDIF}
  protected
    Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
    Procedure AddIWScaleBarScript(Form : TIWAppForm);
    Procedure SetNumberOfLabelsInCS(const value : Integer);
    Procedure SetCoordFunction(const value : String);
    Function GetWindowParams : String;
  Public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ProcessMouseDown(ASender: TObject; const AX: Integer; const AY: Integer);
    procedure MyOnClick(ASender: TObject);
    Procedure AddScript(Form : TIWAppForm);
    Procedure RemoveScriptFrom(Form : TIWAppForm);
    function RenderHTML: TIWHTMLTag; override;

    Property CurrentAction: TEzCurrentAction read FCurrentAction write FCurrentAction;
  Published
    Property About: TEzAbout read GetAbout write SetAbout;
    Property DrawBox: TEzDrawBox read {$IFDEF BCB} GetDrawBox {$ELSE} FDrawBox {$ENDIF} write SetDrawBox;
    Property Edge: TEzEdge read {$IFDEF BCB} GetEdge write SetEdge {$ELSE} FEdge write FEdge {$ENDIF} default edEtched;
    Property IWScaleBar : TEzIWScaleBar Read {$IFDEF BCB} GetIWScaleBar {$ELSE} FIWScaleBar {$ENDIF} write SetIWScaleBar;
    Property GraphicOperator : TEzGraphicOperator Read {$IFDEF BCB} GetGraphicOperator Write SetGraphicOperator {$ELSE} FGraphicOperator Write FGraphicOperator {$ENDIF} Default goWithin;
    Property NumberOfLabelsInCS : Integer Read {$IFDEF BCB} GetNumberOfLabelsInCS {$ELSE} FNumberOfLabelsInCS {$ENDIF} Write SetNumberOfLabelsInCS;
    Property CoordFunction : String Read {$IFDEF BCB} GetCoordFunction {$ELSE} FCoordFunction {$ENDIF} Write SetCoordFunction;

    Property OnEntityClick: TEzEntityClickEvent read {$IFDEF BCB} GetOnEntityClick write SetOnEntityClick {$ELSE} FOnEntityClick write FOnEntityClick {$ENDIF};
  End;

  TEzIWScaleBar = Class( TIWDynamicImage )
  Private
    FIWMap : TEzIWMap;
    procedure SetIWMap(const Value: TEzIWMap);
    function GetAbout: TEzAbout;
    procedure SetAbout(const Value: TEzAbout);
  {$IFDEF BCB}
    function GetIWMap: TEzIWMap;
  {$ENDIF}
  Protected
    Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
  Public
    Constructor Create(AOwner : TComponent); Override;
    function RenderHTML: TIWHTMLTag; override;

  Published
    Property About: TEzAbout read GetAbout write SetAbout;
    Property IWMap : TEzIWMap Read {$IFDEF BCB}GetIWMap {$ELSE} FIWMap {$ENDIF} Write SetIWMap;
  End;


implementation

uses
  StdCtrls, EzConsts, IWCompLabel, Graphics, IWCompButton, EzEntities;


{ TEzIWMap }

Procedure TEzIWMap.AddIWScaleBarScript(Form : TIWAppForm);
begin
  With Form.JavaScript Do Begin
    { IWScaleBarVars }
    Add('var ' + FIWScaleBar.Name + 'Nav = (document.layers)  ');
    Add('var ' + FIWScaleBar.Name + 'Left = 0;  ');
    Add('var ' + FIWScaleBar.Name + 'Top = 0;  ');
    Add('var ' + FIWScaleBar.Name + 'MDown = false;  ');
    Add('var ' + FIWScaleBar.Name + 'XRel = 0;  ');
    Add('var ' + FIWScaleBar.Name + 'YRel = 0;  ');
    Add('var ' + FIWScaleBar.Name + 'FirstTime = true;  ');
    Add('  ');

    { IWScaleBarLoad }
    Add('function ' + FIWScaleBar.Name + 'Load(ASender){  ');
    Add('  ' + FIWScaleBar.Name + 'FirstTime = true;  ');
    Add('}  ');
    Add('  ');

    { IWScaleBarInitialization }
    Add('function ' + FIWScaleBar.Name + 'Initilization( ){  ');
    Add('  if (' + FIWScaleBar.Name + 'Nav){  ');
    Add('    //Netscape  ');
    Add('  } else {  ');
    Add('    //IExplorer  ');
    Add('    var tmp = ' + FIWScaleBar.HTMLName + '.style.left;  ');
    Add('    tmp = tmp.substring(0, tmp.indexOf(''p'', 1));  ');
    Add('    ' + FIWScaleBar.Name + 'Left = tmp;  ');
    Add('    tmp = ' + FIWScaleBar.HTMLName + '.style.top;  ');
    Add('    tmp = tmp.substring(0, tmp.indexOf(''p'', 1));  ');
    Add('    ' + FIWScaleBar.Name + 'Top = tmp;  ');
    Add('    ' + FIWScaleBar.Name + 'FirstTime = false;  ');
    Add('  }  ');
    Add('}  ');
    Add('  ');

    { IWScaleBarMouseDown }
    Add('function ' + FIWScaleBar.Name + 'MouseDown(ASender){  ');
    Add('  if (' + FIWScaleBar.Name + 'FirstTime) ' + FIWScaleBar.Name + 'Initilization( );  ');
    Add('  ' + FIWScaleBar.Name + 'MDown = !' + FIWScaleBar.Name + 'MDown;  ');
    Add('  if (!' + FIWScaleBar.Name + 'MDown) return;  ');
    Add('  ' + FIWScaleBar.Name + 'XRel = ( (' + FIWScaleBar.Name + 'Nav) ? e.pageX : event.x + document.body.scrollLeft ) - ' + FIWScaleBar.Name + 'Left;  ');
    Add('  ' + FIWScaleBar.Name + 'YRel = ( (' + FIWScaleBar.Name + 'Nav) ? e.pageY : event.y + document.body.scrollTop ) - ' + FIWScaleBar.Name + 'Top;  ');
    Add('}  ');
    Add('  ');

    { IWScaleBarMouseMove }
    Add('function ' + FIWScaleBar.Name + 'MouseMove(ASender){  ');
    Add('  if (!' + FIWScaleBar.Name + 'MDown) return;  ');
    Add('  ' + FIWScaleBar.Name + 'Left = ( (' + FIWScaleBar.Name + 'Nav) ? e.pageX : event.x + document.body.scrollLeft ) - ' + FIWScaleBar.Name + 'XRel;  ');
    Add('  ' + FIWScaleBar.Name + 'Top  = ( (' + FIWScaleBar.Name + 'Nav) ? e.pageY : event.y + document.body.scrollTop ) - ' + FIWScaleBar.Name + 'YRel;  ');
    Add('  if (' + FIWScaleBar.Name + 'Nav){  ');
    Add('    //Netscape  ');
    Add('  } else {  ');
    Add('    ' + FIWScaleBar.HTMLName + '.style.left = ' + FIWScaleBar.Name + 'Left + "px";  ');
    Add('    ' + FIWScaleBar.HTMLName + '.style.top = ' + FIWScaleBar.Name + 'Top + "px";  ');
    Add('  }  ');
    Add('}  ');

    FIWScaleBar.ScriptEvents.Values['OnLoad'] := FIWScaleBar.Name + 'Load(ASender)';
    FIWScaleBar.ScriptEvents.Values['OnMouseDown'] := FIWScaleBar.Name + 'MouseDown(ASender)';
    FIWScaleBar.ScriptEvents.Values['OnMouseMove'] := {FIWScaleBar.}Name + 'MouseMove(ASender)';
  End;
end;

Procedure TEzIWMap.AddScript(Form : TIWAppForm);
Var
  btn : TIWButton;
  w : String;
  h : String;
  i : Integer;
  Function CreateLabel(Const LabelName : String) : TIWLabel;
  Begin
    Result := TIWLabel.Create(Form);
    With Result Do Begin
      Font.FontName := 'Courrier';
      Font.Size := 10;
      Font.Color := clRed;
      Name := Self.Name + LabelName;
      Left := -10;
      Top  := 20;
      Caption := 'X';
    End;
  End;


  Function iif(Bool : Boolean; val1, val2 : String) : String;
  Begin
    If Bool Then
      Result := val1
    Else
      Result := val2;
  End;

begin

  CreateLabel('L1');
  CreateLabel('L2');
  CreateLabel('L3');

  If FUseCircleSelect Then Begin
    With CreateLabel('CSLBL0') Do Begin
        ScriptEvents.Values['OnMouseMove'] := Self.Name + 'CSMouseMove(ASender)';
        ScriptEvents.Values['OnMouseDown'] := Self.Name + 'CSMouseDown(ASender)';
    End;
    For i := 1 To FNumberOfLabelsInCS Do
      With CreateLabel('CSLBL' + IntToStr(i)) Do Begin
        Caption := '*';
        ScriptEvents.Values['OnMouseMove'] := Self.Name + 'CSMouseMove(ASender)';
        ScriptEvents.Values['OnMouseDown'] := Self.Name + 'CSMouseDown(ASender)';
      End;
  End;

  h := '6';
  w := '4';

  btn := TIWButton.Create(Form);
  btn.Name := 'btn' + Name + 'Clicker';
  btn.Left := -30;
  btn.Top := 5;
  btn.Width := 20;
  btn.Height := 20;
  btn.Caption := '?';

  ScriptEvents.Values['OnLoad'] := Name + 'Load("caNone' + GetWindowParams + '")';
  ScriptEvents.Values['OnMouseDown'] := Name + 'MouseDown(ASender)';
  ScriptEvents.Values['OnMouseMove'] := Name + 'MouseMove(ASender)';
  ScriptEvents.Values['OnClick'] := Name + 'Click(ASender)';
  With Form.JavaScript Do Begin
    Add('/*' + Name + '*/');
    If Assigned(FIWScaleBar) Then AddIWScaleBarScript(Form);

    { IWMapVars }
    Add(' ');
    Add('var ' + Name + 'Nav = (document.layers)  ');
    Add('var ' + Name + 'X1  ');
    Add('var ' + Name + 'Y1  ');
    Add('var ' + Name + 'CurrentX ');
    Add('var ' + Name + 'CurrentY ');
    Add('var ' + Name + 'MDown  ');
    Add('var ' + Name + 'ActionID  ');
    Add('var ' + Name + 'UseScaleBar = false; ');
    Add('var ' + Name + 'WindowParams = new Array( ); ');
    Add('var ' + Name + 'XWorld = 0; ');
    Add('var ' + Name + 'YWorld = 0; ');
    Add('var ' + Name + 'Loaded = false ');
    Add('  ');

    If FUseCircleSelect Then Begin
      { IWMapCSVars }
      Add(' ');
      Add(' /*CircleSelect implementation*/ ');
      Add('var ' + Name + 'CSXCenter = 0; ');
      Add('var ' + Name + 'CSYCenter = 0; ');
      Add('var ' + Name + 'CSelect = false; ');
      Add('var ' + Name + 'CSAngle = 0; ');
      Add('var ' + Name + 'CSAngleIncrement = Math.PI / 25; ');
      Add('var ' + Name + 'CSRadio = 0; ');
      Add('var ' + Name + 'CSNav = (document.layers); ');
      Add('var ' + Name + 'CSTimerID = null; ');
      Add('var ' + Name + 'CSTimerRunning = false; ');
      Add('var ' + Name + 'CSNLabels = ' + IntToStr(FNumberOfLabelsInCS) + '; ');
      Add('var ' + Name + 'CSSeparation = (2 * Math.PI) / ' + Name + 'CSNLabels; ');
      Add(' ');

      { IWMapCSClock }
      Add('function ' + Name + 'CSStopClock( ){ ');
      Add('  if (' + Name + 'CSTimerRunning) clearTimeout(' + Name + 'CSTimerID); ');
      Add('  ' + Name + 'CSTimerRunning = false; ');
      Add('} ');
      Add(' ');

      { IWMapCSResetAngle }
      Add('function ' + Name + 'CSResetAngle(angle) ');
      Add('{ ');
      Add('  return ( (angle > 2 * Math.PI) ? angle - 2 * Math.PI : angle ); ');
      Add('} ');
      Add(' ');

      { IWMapCSTimer }
      Add('function ' + Name + 'CSTimer( ) ');
      Add('{ ');
      Add('  ' + Name + 'CSAngle += ' + Name + 'CSAngleIncrement; ');
      Add('  ' + Name + 'CSAngle = ' + Name + 'CSResetAngle(' + Name + 'CSAngle); ');
      Add('  var tmp = ' + Name + 'CSAngle; ');
      Add('  for ( var i = 1; i <= ' + Name + 'CSNLabels; i++, tmp += ' + Name + 'CSSeparation){ ');
      Add('      eval("' + HTMLName + 'CSLBL" + i + ".style.left = (' + Name + 'CSXCenter + Math.cos(tmp) * ' + Name + 'CSRadio) +\"px\""); ');
      Add('      eval("' + HTMLName + 'CSLBL" + i + ".style.top = (' + Name + 'CSYCenter - Math.sin(tmp) * ' + Name + 'CSRadio) + \"px\""); ');
      Add('  } ');
      Add('  ' + Name + 'CSTimerID = setTimeout("' + Name + 'CSTimer( )", 50); ');
      Add('  ' + Name + 'CSTimerRunning = true; ');
      Add('} ');
      Add(' ');

      { IWMapCSMouseDown }
      Add('function ' + Name + 'CSMouseDown(ASender) ');
      Add('{ ');
      Add('  ' + Name + 'CSelect = !' + Name + 'CSelect; ');
      Add('  var ' + Name + 'CSX = (' + Name + 'CSNav) ? e.pageX : event.x + document.body.scrollLeft; ');
      Add('  var ' + Name + 'CSY = (' + Name + 'CSNav) ? e.pageY : event.y + document.body.scrollTop; ');
      Add('  if (' + Name + 'CSelect){ ');
      Add('    ' + Name + 'CSXCenter = ' + Name + 'CSX; ');
      Add('    ' + Name + 'CSYCenter = ' + Name + 'CSY; ');
      Add('    ' + Name + 'CSelect = true; ');
      Add('    ' + Name + 'CSAngle = 0; ');
      Add('    ' + Name + 'CSRadio = 0; ');
      Add('    if (' + Name + 'CSNav){ ');
      Add('    } else { ');
      Add('      ' + HTMLName + 'CSLBL0.style.left = ' + Name + 'CSXCenter + "px"; ');
      Add('      ' + HTMLName + 'CSLBL0.style.top = ' + Name + 'CSYCenter + "px"; ');
      Add('    } ');
      Add('    ' + Name + 'CSStopClock( ); ');
      Add('    ' + Name + 'CSTimer( ); ');
      Add('    for (var i  = 0; i <= ' + Name + 'CSNLabels; i++){ ');
      Add('      if (' + Name + 'CSNav){ ');
      Add('      } else { ');
      Add('        eval("' + HTMLName + 'CSLBL" + i + ".style.visibility = \"visible\""); ');
      Add('      } ');
      Add('    } ');
      Add('  } else { ');
      Add('    ' + Name + 'CSStopClock( ); ');
      Add('    for (var i  = 0; i <= ' + Name + 'CSNLabels; i++){ ');
      Add('      if (' + Name + 'CSNav){ ');
      Add('      } else { ');
      Add('        eval("' + HTMLName + 'CSLBL" + i + ".style.visibility = \"hidden\""); ');

      Add('        var send = "ActionID:" + ' + Name + 'ActionID + ";"; ');
      If Assigned(FIWScaleBar) Then Begin
        Add('    if (' + Name + 'UseScaleBar){ ');
        Add('      if (' + FIWScaleBar.Name + 'FirstTime) ' + FIWScaleBar.Name + 'Initilization( ); ');
        Add('      send = send + "ScaleBar:" + ' + IWScaleBar.Name + 'Left + "," + ' + FIWScaleBar.Name + 'Top + ";"; ');
        Add('    } ');
      End;

      Add('        var l = ' + HTMLName + '.style.left; ');
      Add('        var t = ' + HTMLName + '.style.top; ');
      Add('        l = l.substring(0, l.indexOf(''p'', 1)); ');
      Add('        t = t.substring(0, t.indexOf(''p'',1)); ');
      Add('        send = send + (' + Name + 'CSXCenter - l)+ "," + (' + Name + 'CSYCenter - t)+ ","  + (' + Name + 'CSX - l)+ ","  + (' + Name + 'CSY  - t)+ ","; ');
      Add('        SubmitClickConfirm(''' + btn.HTMLName + ''', send, ' + iif(Confirmation <> '', 'true', 'false') + ', ''' + Confirmation + ''');  ');
      Add('      } ');
      Add('    } ');
      Add('  } ');
      Add('} ');
      Add(' ');

      { IWMapCSMouseMove }
      Add('function ' + Name + 'CSMouseMove(ASender) ');
      Add('{ ');
      Add('  if (!' + Name + 'CSelect) return; ');
      Add('  var X = (' + Name + 'CSNav) ? e.pageX : event.x + document.body.scrollLeft; ');
      Add('  var Y = (' + Name + 'CSNav) ? e.pageY : event.y + document.body.scrollTop; ');
      Add('  ' + Name + 'CSRadio =  Math.sqrt(Math.abs( (' + Name + 'CSXCenter - X) * (' + Name + 'CSXCenter - X) + ');
      Add('                                      (' + Name + 'CSYCenter - Y) * (' + Name + 'CSYCenter - Y) )); ');
      Add('} ');
      Add(' ');
    End;

    { IWMapClick }
    Add('function ' + Name + 'Click(ASender){');
    Add('  return (false); ');
    Add('} ');

    { IWMapLabels }
    Add('function ' + Name + 'Labels(vis){  ');
    Add('  ' + HTMLName + 'L1.style.visibility = vis;  ');
    Add('  ' + HTMLName + 'L2.style.visibility = vis;  ');
    Add('  ' + HTMLName + 'L3.style.visibility = vis;  ');
    Add('}  ');
    Add('  ');

    { IWMapSetAction }
    Add('function ' + Name + 'SetAction(Action){  ');
    Add('  ' + Name + 'ActionID = Action;  ');
    Add('  if (Action == "caZoomExtension" || Action == "caZoomAll"){ ');
    Add('    var send = "Action:" + Action + ";"; ');
    If Assigned(FIWScaleBar) Then Begin
      Add('    if (' + Name + 'UseScaleBar){ ');
      Add('      if (' + FIWScaleBar.Name + 'FirstTime) ' + FIWScaleBar.Name + 'Initilization( ); ');
      Add('      send = send + "ScaleBar:" + ' + IWScaleBar.Name + 'Left + "," + ' + FIWScaleBar.Name + 'Top + ";"; ');
      Add('    } ');
    End;
    Add('    SubmitClickConfirm(''' + btn.HTMLName + ''', send, ' + iif(Confirmation <> '', 'true', 'false') + ', ''' + Confirmation + ''');  ');
    Add('  } ');
    Add('  return(false);  ');
    Add('}  ');
    Add('  ');

    { IWMapCalcCoords }
    Add('function ' + Name + 'CalcCoords( ){ ');
    Add('  if (!' + Name + 'Loaded) return;  ');
    Add(' ' + Name + 'XWorld = ' + Name + 'WindowParams[0] + ( ' + Name + 'CurrentX - ' + Name + 'WindowParams[4]) / ' + Name + 'WindowParams[2]; ');
    Add(' ' + Name + 'YWorld = ' + Name + 'WindowParams[1] - ( ' + Name + 'CurrentY - ' + Name + 'WindowParams[5]) / ' + Name + 'WindowParams[3]; ');
    If FCoordFunction <> '' Then Begin
      Add('  ' + FCoordFunction + '( ' + Name + 'XWorld, ' + Name + 'YWorld );  ');
    End;
    Add('} ');
    Add(' ');

    { IWMapLoad }
    Add('function ' + Name + 'Load(Action){ ');
    Add('  ' + Name + 'Labels("hidden"); ');
    Add('  ' + Name + 'MDown = false; ');
    Add('  ' + Name + 'UseScaleBar = ' + iif(Assigned(FIWScaleBar), 'true', 'false') + '; ');
    Add(' ');
    Add('  ' + Name + 'ActionID = Action.substring(0, Action.indexOf('';'', 1)); ');
    Add('  Action = Action.substring(Action.indexOf('';'', 1), Action.length); ');
    Add(' ');
    Add('  for (var i = 0; i < 6; i++){ ');
    Add('    ' + Name + 'WindowParams[i] = 1 * Action.substring(1, Action.indexOf('';'', 2)); ');
    Add('    Action = Action.substring(Action.indexOf('';'', 2), Action.length); ');
    Add('  } ');
    Add('  ' + Name + 'Loaded = true  ');
    Add('} ');
    Add(' ');

    { IWMapMouseDown }
    Add('function ' + Name + 'MouseDown(ASender){  ');
    If FUseCircleSelect Then Begin
      Add('  if (' + Name + 'ActionID == "caCircleSelect"){ ');
      Add('    ' + Name + 'CSMouseDown(ASender); ');
      Add('    return; ');
      Add('  } ');
    End;
    If Assigned(FIWScaleBar) Then Begin
      Add('  if (' + FIWScaleBar.Name + 'MDown){ ');
      Add('    '  + FIWScaleBar.Name + 'MouseDown(ASender); ');
      Add('    return; ');
      Add('  }' );
    End;
    Add('  if (' + Name + 'ActionID == "caNone") return;  ');
    Add('  var x = ((' + Name + 'Nav) ? e.pageX : event.x + document.body.scrollLeft);');
    Add('  var y = ((' + Name + 'Nav) ? e.pageY : event.y + document.body.scrollTop );');
    Add('  ' + Name + 'MDown = !' + Name + 'MDown;  ');
    Add('  if (' + Name + 'Nav){  ');
    Add('   //Netscape  ');
    Add('  } else {  ');
    Add('  ');
    Add('    ' + HTMLName + 'L1.style.left = x - ' + w + ' + "px";  ');
    Add('    ' + HTMLName + 'L2.style.left = x - ' + w + ' + "px";  ');
    Add('    ' + HTMLName + 'L3.style.left = x - ' + w + ' + "px";  ');
    Add('  ');
    Add('    ' + HTMLName + 'L1.style.top = y - ' + h + ' + "px";  ');
    Add('    ' + HTMLName + 'L2.style.top = y - ' + h + ' + "px";  ');
    Add('    ' + HTMLName + 'L3.style.top = y - ' + h + ' + "px";  ');
    Add('  ');
    Add('    if (' + Name + 'MDown){  ');
    Add('      ' + Name + 'X1 = x;  ');
    Add('      ' + Name + 'Y1 = y;  ');
    Add('    }  ');
    Add('    if (' + Name + 'MDown){  ');
    Add('      if (' + Name + 'ActionID == "caZoomWin" || ' + Name + 'ActionID == "caSelect"){  ');
    Add('        ' + Name + 'Labels("visible");  ');
    Add('      } else if (' + Name + 'ActionID == "caPan"){  ');
    Add('        ' + HTMLName + 'L1.style.visibility = "visible";  ');
    Add('      }  ');
    Add('    }  ');
    Add('    if (' + Name + 'MDown == true &&  ');
    Add('       ( ' + Name + 'ActionID == "caZoomWin" || ' + Name + 'ActionID == "caPan" || ' + Name + 'ActionID == "caSelect") ) return;  ');
    Add('    ' + Name + 'Labels("hidden");  ');
    Add('    var send = "Action:" + ' + Name + 'ActionID + ";";  ');

    If Assigned(FIWScaleBar) Then Begin
      Add('    if (' + Name + 'UseScaleBar){ ');
      Add('      if (' + FIWScaleBar.Name + 'FirstTime) ' + FIWScaleBar.Name + 'Initilization( );  ');
      Add('      send = send + "ScaleBar:" + ' + FIWScaleBar.Name + 'Left + "," + ' + FIWScaleBar.Name + 'Top + ";";  ');
      Add('    } ');
    End;

    Add('    var l = ' + HTMLName + '.style.left;  ');
    Add('    var t = ' + HTMLName + '.style.top;  ');
    Add('    l = l.substring(0, l.indexOf(''p'', 1)); ');
    Add('    t = t.substring(0, t.indexOf(''p'',1));  ');
    Add('    var tmp = "";  ');
    Add('    tmp = "x : " + l + " y: " + t;  ');
    Add('    send = send + (' + Name + 'X1 - l)+ "," + (' + Name + 'Y1 - t)+ ","  + (x - l)+ ","  + (y  - t)+ ",";  ');
    Add('    SubmitClickConfirm(''' + btn.HTMLName + ''', send, ' + iif(Confirmation <> '', 'true', 'false') + ', ''' + Confirmation + ''');  ');
    Add('    return (false);  ');
    Add('  }  ');
    Add('}  ');
    Add('  ');


    { IWMapMouseMove }
    Add('function ' + Name + 'MouseMove(ASender){  ');
    Add('  var x2 = ((' + Name + 'Nav) ? page.x : event.x + document.body.scrollLeft) - ' + w + ';');
    Add('  var y2 = ((' + Name + 'Nav) ? page.y : event.y + document.body.scrollTop ) - ' + h + ';');
    Add('  ' + Name + 'CurrentX = x2; ');
    Add('  ' + Name + 'CurrentY = y2; ');
    Add('  ' + Name + 'CalcCoords( ); ');
    If FUseCircleSelect Then Begin
      Add(' ');
      Add('  if (' + Name + 'ActionID == "caCircleSelect"){ ');
      Add('    ' + Name + 'CSMouseMove(ASender); ');
      Add('    return; ');
      Add('  } ');
    End;
    If Assigned(FIWScaleBar) Then Begin
      Add('  if (' + FIWScaleBar.Name + 'MDown){ ');
      Add('    '  + FIWScaleBar.Name + 'MouseMove(ASender); ');
      Add('    return; ');
      Add('  }' );
    End;
    Add('  ');
    Add('  if (' + Name + 'ActionID == "caNone") return;  ');
    Add('  if (' + Name + 'MDown != true) return;  ');
    Add('  ');
    Add('  var x1 = ' + Name + 'X1;  ');
    Add('  var y1 = ' + Name + 'Y1;  ');
    Add('  ');
    Add('  if (' + Name + 'Nav){  ');
    Add('  } else {  ');
    Add('     ' + HTMLName + 'L1.style.left = x1 - ' + w + ' + "px";  ');
    Add('     ' + HTMLName + 'L2.style.left = x2 - ' + w + ' + "px";  ');
    Add('     ' + HTMLName + 'L3.style.left = x1 - ' + w + ' + "px";  ');
    Add('  ');
    Add('     ' + HTMLName + 'L1.style.top = y1 - ' + h + ' + "px";  ');
    Add('     ' + HTMLName + 'L2.style.top = y1 - ' + h + ' + "px";  ');
    Add('     ' + HTMLName + 'L3.style.top = y2 - ' + h + ' + "px";  ');
    Add('  }  ');
    Add('}  ');
    Add('  ');
    Add('/*' + Name + '*/');
  End;
  btn.OnClick := MyOnClick;
  FUseMyOnClick := True;
  OnClick := Nil;
end;

Procedure TEzIWMap.RemoveScriptFrom(Form : TIWAppForm);
Var
  Str : String;
  i : Integer;
  Procedure RemoveComponent(AName : String);
  Var
    Component : TComponent;
  Begin
    Component := Form.FindComponent(AName);
    If (Component <> Nil) Then Begin
      Form.RemoveComponent(Component);
      Component.Free;
    End;
  End;
Begin
  RemoveComponent(Name + 'L1');
  RemoveComponent(Name + 'L2');
  RemoveComponent(Name + 'L3');
  RemoveComponent('btn' + Name + 'Clicker');

  RemoveComponent(Name + 'CSLBL0');
  For i := 1 To FNumberOfLabelsInCS Do
    RemoveComponent(Name + 'CSLBL' + IntToStr(i));

  i := 0;
  With Form.JavaScript Do Begin
    Repeat
      if i >= Count Then Break;
      Str := Strings[i];
      Inc(i);
    Until AnsiCompareText(Str, '/*' + Name + '*/') = 0;

    If AnsiCompareText(Str, '/*' + Name + '*/') = 0 Then Begin
      Delete(i - 1);
      Repeat
        if i >= Count Then Break;
        Str := Strings[i];
        Delete(i);
      Until AnsiCompareText(Str, '/*' + Name + '*/') = 0;
    End;
  End;
  FUseMyOnClick := False;
  With ScriptEvents Do Begin
    Values['OnLoad'] := '';
    Values['OnClick'] := '';
    Values['OnMouseDown'] := '';
    Values['OnMouseMove'] := '';
  End;
  If Assigned(FIWScaleBar) Then
    With FIWScaleBar.ScriptEvents Do Begin
      Values['OnLoad'] := '';
      Values['OnMouseDown'] := '';
      Values['OnMouseMove'] := '';
    End;
  OnMouseDown := ProcessMouseDown;
  CurrentAction := caZoomIn;
End;

Function TEzIWMap.GetWindowParams : String;
Begin
  If Not Assigned( FDrawBox ) Then
    Result := ''
  Else With FDrawBox.Grapher Do Begin
     Result := Format(';%f;%f;%f;%f;%f;%f;',[
     CurrentParams.VisualWindow.X1,
     CurrentParams.VisualWindow.Y2,
     CurrentParams.XScale,
     CurrentParams.YScale,
     ViewPortRect.X1,
     ViewPortRect.Y2]);
  End;
End;


constructor TEzIWMap.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CreatePicture;
  FEdge:= edEtched;
  FUseMyOnClick := False;
  FUseCircleSelect := True;
  FNumberOfLabelsInCS := 10;
  FCurrentAction := caNone;
  OnMouseDown := ProcessMouseDown;
end;

destructor TEzIWMap.Destroy;
begin
  DrawBox:=nil;
  if Assigned( FStackedSelList ) then FStackedSelList.free;
  inherited Destroy;
end;

{ for actions that requires only single mouse click }
procedure TEzIWMap.ProcessMouseDown(ASender: TObject; const AX, AY: Integer);
var
  WX, WY: Double;
  CurrPoint, OldPoint, NewPoint: TEzPoint;

  Procedure DoPickEntity;
  var
    Extension: TEzRect;
    TmpLayer, PrevLayer: TEzBaseLayer;
    PickedPoint, I, TmpRecNo, PrevRecno, PrevSelCount, N: Integer;
    Picked, Processed: Boolean;
  Begin
    with FDrawBox do
    begin
      If StackedSelect Then
      Begin
        If FStackedSelList = Nil Then
          FStackedSelList := TStringList.Create
        Else
          FStackedSelList.Clear;
        PrevSelCount := Selection.NumSelected;
        If PrevSelCount = 1 Then
        Begin
          PrevLayer := Selection[0].Layer;
          PrevRecno := Selection[0].SelList[0];
        End;
      End
      Else If FStackedSelList <> Nil Then
        FreeAndNil( FStackedSelList );

      Picked := PickEntity( CurrPoint.X, CurrPoint.Y, 4,
        '', TmpLayer, TmpRecNo, PickedPoint, FStackedSelList );

      If Selection.Count > 0 Then
      Begin
        { repintar el area seleccionada }
        Extension := Selection.GetExtension;
        Selection.Clear;
        RepaintRect( Extension );
      End;

      If Picked Then
      Begin
        If ( FStackedSelList <> Nil ) And ( PrevSelCount = 1 ) And ( FStackedSelList.Count > 1 ) Then
        Begin
          For I := 0 To FStackedSelList.Count - 1 Do
          Begin
            If ( PrevLayer = GIS.Layers.LayerByName( FStackedSelList[I] ) ) And
              ( PrevRecno = Longint( FStackedSelList.Objects[I] ) ) Then
            Begin
              If I < FStackedSelList.Count - 1 Then
                N := I + 1
              Else
                N := 0;
              TmpLayer := GIS.Layers.LayerByName( FStackedSelList[N] );
              TmpRecno := Longint( FStackedSelList.Objects[N] );
              Break;
            End;
          End;
        End;
        Selection.Add( TmpLayer, TmpRecNo );
        If Assigned( OnSelectionChanged ) Then
          OnSelectionChanged( FDrawBox );
        Selection.RepaintSelectionArea;

        If Assigned(Self.FOnEntityClick) then
        Begin
          Processed:= True;
          Self.FOnEntityClick( Self, mbLeft, [], AX, AY, WX, WY, TmpLayer,
                               TmpRecno, Processed );
        End;
      End Else
      Begin
        If Assigned(Self.FOnEntityClick) then
        Begin
          Processed:= True;
          Self.FOnEntityClick( Self, mbLeft, [], AX, AY, WX, WY, Nil, 0, Processed );
        End;
      End;

    end;
  End;

begin
  if FDrawBox.Gis = Nil then Exit;
  { conviert from pixels to map coordinates }
  FDrawBox.DrawBoxToWorld( AX, AY, WX, WY );
  CurrPoint:= Point2d( WX, WY );

  case FCurrentAction of
    caZoomIn:
      begin
        OldPoint := Point2D( WX, WY );
        FDrawBox.Grapher.InUpdate := true; {don't generate two history views}
        FDrawBox.Grapher.Zoom( 0.85 );
        FDrawBox.Grapher.InUpdate := false;
        NewPoint := FDrawBox.Grapher.PointToReal( Point( AX, AY ) );
        With FDrawBox.Grapher.CurrentParams.MidPoint Do
          FDrawBox.Grapher.ReCentre( X + ( OldPoint.X - NewPoint.X ),
                                     Y + ( OldPoint.Y - NewPoint.Y ) );
        FDrawBox.Repaint;
      end;
    caZoomOut:
      begin
        OldPoint := Point2D( WX, WY );
        FDrawBox.Grapher.InUpdate := true; {don't generate two history views}
        FDrawBox.Grapher.Zoom( 1 / 0.85 );
        FDrawBox.Grapher.InUpdate := false;
        NewPoint := FDrawBox.Grapher.PointToReal( Point( AX, AY ) );
        With FDrawBox.Grapher.CurrentParams.MidPoint Do
          FDrawBox.Grapher.ReCentre( X + ( OldPoint.X - NewPoint.X ),
                                     Y + ( OldPoint.Y - NewPoint.Y ) );
        FDrawBox.Repaint;
      end;
    caPickEntity:
      begin
        { detect which entity was picked }

        DoPickEntity;

      end;
  end;

end;

procedure TEzIWMap.MyOnClick(ASender: TObject);
var
  str : String;
  index : Integer;
  arr : Array [0..4] Of Integer;
  i : Integer;
  Rect : TEzRect;
  ActionID : String;
  Layers : TEzBaseLayers;
  Ent : TEzEntity;
  Poly : TEzEntity;
  dx: Double;

  Procedure UpdateScaleBar;
  Var
    l, t : Integer;
  Begin
    //Borrar la parte que dice "ScaleBar:"
    index := Pos(':', str);
    Delete(str, 1, index);
    //Buscar la coordenada left
    index := Pos(',', str);
    l := StrToInt(Copy(str, 1, index - 1));
    Delete(str, 1, index);
    //Buscar la coordenada top
    index := Pos(';', str);
    t := StrToInt(Copy(str, 1, index - 1));
    Delete(str, 1, index);
    If Assigned(FIWScaleBar) Then Begin
      FIWScaleBar.Left := l;
      FIWScaleBar.Top := t;
    End;
  End;

  Function getCurrentActionStr : String;
  Begin
    Case CurrentAction Of
      caZoomIn      : Result := 'caZoomIn';
      caZoomOut     : Result := 'caZoomOut';
      caZoomWin     : Result := 'caZoomWin';
      caPan         : Result := 'caPan';
      caPickEntity  : Result := 'caPickEntity';
      caSelect      : Result := 'caSelect';
      caCircleSelect: Result := 'caCircleSelect';
    Else
      Result := 'caNone';
    End;
  End;
begin
  If Not FUseMyOnClick Then Exit;
  //Se espera que esta cadena tenga el siguiente formato
  //'ActionID:action;x1,y1,x2,y2'
  //Donde action puede ser : caPickEntity ó caZoomIn ó caZoomOut ó caZoomWin ó caPan
  //Si ActionID = "caZoomExtension" ó ActionID = "caZoomAll" no seran necesarias las coordenadas
  str := WebApplication.Request.ContentFields.Values['IW_ActionParam'];

  //Si la cadena esta vacia abandonar la funcion
  if Length(str) = 0 Then exit;

  //Obtener el ActionID
  Index := Pos(':', str);
  Delete(str, 1, index);
  Index := Pos(';', str);
  ActionID := Copy(str, 1, index - 1);
  Delete(str, 1, index);

  //Actualizar las coordenadas del ScaleBar (Si hay uno ligado)
  index := Pos('ScaleBar', str);
  If index > 0 Then UpdateScaleBar;

  If (AnsiCompareText(ActionID, 'caZoomAll') = 0) Or
     (AnsiCompareText(ActionID, 'caZoomExtension') = 0) Then Begin
    FDrawBox.ZoomToExtension;
    //Para conservar la accion anterior al ZoomToExtension
    ScriptEvents.Values['OnLoad'] := Name + 'Load("' + getCurrentActionStr + GetWindowParams + '")';
    Exit;
  End;

  //Obteniendo los puntos de cordenadas desde "str"
  For i := 0 To 3 Do Begin
    index := Pos(',', str);
    arr[i] := StrToInt(Copy(str, 1, index -1));
    Delete(Str, 1, index);
  End;

  Rect.Emin := FDrawBox.Grapher.PointToReal(Point(arr[0],arr[1]));
  Rect.Emax := FDrawBox.Grapher.PointToReal(Point(arr[2],arr[3]));

  If AnsiCompareText(ActionID, 'caZoomIn') = 0 Then Begin
    CurrentAction := caZoomIn;
    ProcessMouseDown(ASender, arr[0], arr[1]);

  End Else If AnsiCompareText(ActionID, 'caZoomOut') = 0 Then Begin
    CurrentAction := caZoomOut;
    ProcessMouseDown(ASender, arr[0], arr[1]);

  End Else If AnsiCompareText(ActionID, 'caPickEntity') = 0 Then Begin
    CurrentAction := caPickEntity;
    ProcessMouseDown(ASender, arr[0], arr[1]);

  End Else If AnsiCompareText(ActionID, 'caZoomWin') = 0 Then Begin
    CurrentAction := caZoomWin;
    Rect := ReorderRect2D(Rect);
    FDrawBox.SetViewTo(Rect.X1, Rect.Y1, Rect.X2, Rect.Y2);

  End Else If AnsiCompareText(ActionID, 'caSelect') = 0 Then Begin
    CurrentAction := caSelect;
    Rect := ReorderRect2D(Rect);
    Layers := FDrawBox.GIS.Layers;
    For i := 0 To Layers.Count - 1 Do
      If Layers[i].LayerInfo.Selectable Then
        FDrawBox.RectangleSelect(Rect.X1, Rect.Y1, Rect.X2, Rect.Y2, Layers[i].Name, '', FGraphicOperator );

  End Else If AnsiCompareText(ActionID, 'caCircleSelect') = 0 Then Begin
    CurrentAction := caCircleSelect;
    Layers := FDrawBox.GIS.Layers;

    dx :=  Sqrt( Sqr(Rect.X1 - Rect.X2) + Sqr(Rect.Y1 - Rect.Y2) );
    Rect.X2 := Rect.X1 + dx;
    Rect.Y2 := Rect.Y1 + dx;
    Rect.X1 := Rect.X1 - dx;
    Rect.Y1 := Rect.Y1 - dx;

    Ent := TEzEllipse.CreateEntity(Rect.Emin, Rect.Emax);
    Poly := TEzPolygon.Create(1);
    Poly.Points.Assign(Ent.DrawPoints);
    Try
      For i := 0 To Layers.Count - 1 Do
        If Layers[i].LayerInfo.Selectable Then
          FDrawBox.PolygonSelect(Poly, Layers[i].Name, '', FGraphicOperator);
    Finally
      Ent.Free;
      If Assigned(Poly) Then Poly.Free;
    End;

  End Else If AnsiCompareText(ActionID, 'caPan') = 0 Then Begin
    CurrentAction := caPan;
    FDrawBox.Panning(Rect.X1 - Rect.X2, Rect.Y1 - Rect.Y2);
  End;// Else Exit; //Si no se reconocio el ActionID no hace falta redibujar el DrawBox.

  //Para que al regresar la pagina conserve la accion que se esta ejecutando actualmente.
  ScriptEvents.Values['OnLoad'] := Name + 'Load("' + ActionID + GetWindowParams + '")';

  FDrawBox.Repaint;
End;

procedure TEzIWMap.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  Inherited Notification( AComponent, Operation );
  If ( Operation = opRemove ) Then
    If  ( AComponent = FDrawBox ) Then
      FDrawBox := Nil
    Else If ( AComponent = FIWScaleBar ) Then
      FIWScaleBar := Nil
end;

procedure TEzIWMap.SetDrawBox(Value: TEzDrawBox);
begin
{$IFDEF LEVEL5}
  if Assigned( FDrawBox ) then FDrawBox.RemoveFreeNotification( Self );
{$ENDIF}
  If Value <> FDrawBox Then
  Begin
    FDrawBox := Value;
    if Assigned( FDrawBox ) then FDrawBox.FreeNotification( Self );
  End;
end;

procedure TEzIWMap.SetIWScaleBar(Value: TEzIWScaleBar);
begin
{$IFDEF LEVEL5}
  if Assigned( FIWScaleBar ) then FIWScaleBar.RemoveFreeNotification( Self );
{$ENDIF}
  If Value <> FIWScaleBar Then
  Begin
    FIWScaleBar := Value;
    if Assigned( FIWScaleBar ) then FIWScaleBar.FreeNotification( Self );
  End;
end;

Procedure TEzIWMap.SetCoordFunction(const value : String);
Begin
  If FUseMyOnClick Then
    Raise Exception.Create('No se puede modificar esta propiedad cuando el script ya esta añadido en la forma');
  FCoordFunction := value;
End;

Procedure TEzIWMap.SetNumberOfLabelsInCS(const value : Integer);
Begin
  If FUseMyOnClick Then
    Raise Exception.Create('No se puede modificar esta propiedad cuando el script ya esta añadido en la forma');
  If value > 0 Then
    FNumberOfLabelsInCS := Value;
End;

function TEzIWMap.RenderHTML: TIWHTMLTag;
var
  theRect: TRect;
  TmpEdge, Border: UINT;
begin
  if Assigned(FDrawBox) then
    with FDrawBox.ScreenBitmap do
    begin
      FPicture.Bitmap.Width:=Width;
      FPicture.Bitmap.Height:=Height;
      FPicture.Bitmap.Assign(FDrawBox.ScreenBitmap);
    end;

  if Edge <> edNone then
  begin
    with FPicture.Bitmap do
      theRect:= Rect(0, 0, Width, Height );
    case Edge of
      edBump:
        TmpEdge:= EDGE_BUMP;
      edEtched:
        TmpEdge:= EDGE_ETCHED;
      edRaised:
        TmpEdge:= EDGE_RAISED;
      edSunken:
        TmpEdge:= EDGE_SUNKEN;
    end;
    Border := BF_RECT;
    DrawEdge( FPicture.Bitmap.Canvas.Handle, theRect, TmpEdge, Border );
  end;

  result:=inherited RenderHTML;
end;

{$IFDEF BCB}
function TEzIWMap.GetCoordFunction: String;
begin
  Result := FCoordFunction;
end;

function TEzIWMap.GetDrawBox: TEzDrawBox;
begin
  Result := FDrawBox;
end;

function TEzIWMap.GetEdge: TEzEdge;
begin
  Result := FEdge;
end;

function TEzIWMap.GetGraphicOperator: TEzGraphicOperator;
begin
  Result := FGraphicOperator;
end;

function TEzIWMap.GetIWScaleBar: TEzIWScaleBar;
begin
  Result := FIWScaleBar;
end;

function TEzIWMap.GetNumberOfLabelsInCS: Integer;
begin
  Result := FNumberOfLabelsInCS;
end;

function TEzIWMap.GetOnEntityClick: TEzEntityClickEvent;
begin
  Result := FOnEntityClick;
end;

procedure TEzIWMap.SetEdge(const Value: TEzEdge);
begin
  FEdge := Value;
end;

procedure TEzIWMap.SetGraphicOperator(const Value: TEzGraphicOperator);
begin
  FGraphicOperator := Value;
end;

procedure TEzIWMap.SetOnEntityClick(const Value: TEzEntityClickEvent);
begin
  FOnEntityClick := Value;
end;
{$ENDIF}

function TEzIWMap.GetAbout: TEzAbout;
begin
  Result:= SEz_GisVersion;
end;

procedure TEzIWMap.SetAbout(const Value: TEzAbout);
begin
end;

{ TEzIWScaleBar }

Constructor TEzIWScaleBar.Create(AOwner : TComponent);
begin
  inherited;
end;

function TEzIWScaleBar.RenderHTML: TIWHTMLTag;
var
  RealDist, UnitsFactor: Double;
  AWidth, AHeight: Integer;
  ScaleDistPixels, TotalTextHeight: Integer;
  ScaleBar : TEzScaleBar;
begin
  If Assigned(FIWMap) And Assigned(FIWMap.DrawBox) And Assigned(FIWMap.DrawBox.ScaleBar) Then Begin
    ScaleBar := FIWMap.DrawBox.ScaleBar;
    ScaleBar.Transparent := False;
    If TEzDrawBox(ScaleBar.Parent).GIS.MapInfo.CoordsUnits = cuDeg then
      UnitsFactor:= 1.0
    Else
      UnitsFactor:= pj_units[TEzBaseDrawbox(ScaleBar.Parent).GIS.MapInfo.CoordsUnits].to_meter * ( 1 / pj_units[ScaleBar.Units].to_meter );

    ScaleBar.NeededDimensions( FPicture.Bitmap.Canvas, UnitsFactor, AWidth, AHeight, RealDist,
                                ScaleDistPixels, TotalTextHeight );

    If ( AWidth <= 0 ) Or ( AHeight <= 0 ) then Begin
      Result := Inherited RenderHTML;
      Exit;
    End;

    FPicture.Bitmap.Width := AWidth;
    FPicture.Bitmap.Height := AHeight;

    ScaleBar.PaintTo( FPicture.Bitmap.Canvas, ClientRect, UnitsFactor, AWidth, AHeight, RealDist,
                       ScaleDistPixels, TotalTextHeight );
  End;
  Result := Inherited RenderHTML;
end;

procedure TEzIWScaleBar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  Inherited Notification( AComponent, Operation );
  If ( Operation = opRemove ) And ( AComponent = FIWMap ) Then
      FIWMap := Nil
end;

procedure TEzIWScaleBar.SetIWMap(const Value: TEzIWMap);
begin
{$IFDEF LEVEL5}
  if Assigned( FIWMap ) then FIWMap.RemoveFreeNotification( Self );
{$ENDIF}
  If Value <> FIWMap Then
  Begin
    FIWMap := Value;
    if Assigned( FIWMap ) then FIWMap.FreeNotification( Self );
  End;
end;

{$IFDEF BCB}
function TEzIWScaleBar.GetIWMap: TEzIWMap;
begin
  Result := FIWMap;
end;
{$ENDIF}

function TEzIWScaleBar.GetAbout: TEzAbout;
begin
  Result:= SEz_GisVersion;
end;

procedure TEzIWScaleBar.SetAbout(const Value: TEzAbout);
begin
end;

end.
