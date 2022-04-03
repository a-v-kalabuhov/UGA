Unit EzReg;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
{$R ..\RES\EZREGRES.DCR}
{$IFDEF GIS_CONTROLS}
  {$IFDEF LEVEL5}
    {.$DEFINE USE_INDY}               { Uncomment for using as MiddleWare with Indy }
    {.$DEFINE ADO_CS}                { uncomment for install TEzADOGis }
    {.$DEFINE DBISAM_CS}             { uncomment for install TDBISAMGis }
    {.$DEFINE INTERBASE_CS}          { uncomment for install TEzIBGis }
    {.$DEFINE BDE_CS}                { uncomment for install TEzBDEGis }
    { switch for installing TEzIWMap, IntraWeb( http://www.atozedsoftware.com ) compatible }
    {.$DEFINE USE_INTRAWEB}
  {$ENDIF}
{$ENDIF}
{.$DEFINE INSPECTOR_PROVIDER}
Interface

Uses
{$IFDEF LEVEL6}
  Classes, //DesignIntf, DesignEditors, Variants;
{$ELSE}
  Classes;//, //DesignIntf;
{$ENDIF}

Procedure Register;

Implementation

Uses
  Dialogs, SysUtils, EzBaseGIS, EzBasicCtrls, EzCmdLine, EzBase,
  EzActionLaunch, EzShpImport, EzDxfImport, EzDGNImport, EzMifImport,
  EzPolyClip, EzProjections, eznumed, Tablet,
  EzInspect, EzNetwork, EzPreview, EzMiscelCtrls, EzColorPicker, EzSDLImport
{$IFDEF USE_INDY}
  , EzIndyGIS
{$ENDIF}
{$IFDEF INSPECTOR_PROVIDER}
  // No se porque esta causando problemas
  , fEzProviderWizard
{$ENDIF}
{$IFDEF ISACTIVEX}
  , EzActiveX
{$ENDIF}
{$IFDEF GIS_CONTROLS}
  , EzTable, EzCtrls, EzHTMLmap, EzOwnImport, EzThematics
{$ENDIF}
{$IFDEF CAD_CONTROLS}
  , EzCADCtrls
{$ENDIF}
{$IFDEF ADO_CS}
  , EzAdoGis
{$ENDIF}
{$IFDEF DBISAM_CS}
  , EzDBISAMGis
{$ENDIF}
{$IFDEF USE_INTRAWEB}
  , IWCompMap
{$ENDIF}
{$IFDEF INTERBASE_CS}
  , EzIBGis
{$ENDIF}
{$IFDEF BDE_CS}
  , EzBDEGis
{$ENDIF}
  ;

{$IFDEF INSPECTOR_PROVIDER}

type

  TEzInspectorProviderCompEditor = class(TComponentEditor)
  private
  protected
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  public
  end;


{ TEzInspectorProviderCompEditor }

procedure TEzInspectorProviderCompEditor.ExecuteVerb(Index: Integer);
begin
  With TfrmEzProviderWizard.Create( Nil ) Do
  Try
    Enter(TEzInspectorProvider(Component));
  Finally
    Free;
  End;
end;

function TEzInspectorProviderCompEditor.GetVerb(Index: Integer): string;
begin
  If Index = 0 Then
    Result := 'Inspector Provider Wizard...'
end;

function TEzInspectorProviderCompEditor.GetVerbCount: Integer;
begin
  Result:= 1;
end;
{$ENDIF}

// register all EzGIS components
Procedure Register;
Begin
  RegisterComponents( 'EzSoft', [
{$IFDEF CAD_CONTROLS}
                      TEzCAD,
{$ENDIF}
{$IFDEF GIS_CONTROLS}
                      TEzGIS, TEzMemoryGIS,
  {$IFDEF INTERBASE_CS}
                      TEzIBGis,
  {$ENDIF}
  {$IFDEF DBISAM_CS}
                      TDBISAMGIS,
  {$ENDIF}
  {$IFDEF ADO_CS}
                      TEzADOGIS,
  {$ENDIF}
  {$IFDEF USE_INDY}
                      TEzIndyClientGIS,
  {$ENDIF}
  {$IFDEF BDE_CS}
                      TEzBDEGIS,
  {$ENDIF}
{$ENDIF}
                      TEzDrawBox,         TEzCmdLine,
                      TEzPreviewBox,      TEzHRuler,
                      TEzVRuler,          TEzAerialView,
                      TEzMosaicView,      TEzActionLauncher,
                      TEzSHPImport,       TEzSHPExport,
                      TEzDxfImport,       TEzDxfExport,
                      TEzDgnImport,       TEzProjector,
                      TEzMifImport,       TEzMIFExport,
                      TEzSDLImport,       TEzSDLExport,
                      TEzPolygonClipper,  TEzModifyPreferences,
                      TTablet,            TEzNetwork,
                      TEzInspector
{$IFDEF GIS_CONTROLS}
                      , TEzTable,         TEzGeorefImage,
                      TEzHTMLMap,         TEzOwnImport,
                      TEzOwnExport,       TEzThematicBuilder,
                      TEzDataSetProvider, TEzLegend
  {$IFDEF INSPECTOR_PROVIDER}
                      , TEzInspectorProvider
  {$ENDIF}
  //{$IFDEF ISACTIVEX}
  //                  TEzGisAx,           TEzCADAx,
  //                  TEzPreviewBoxAx,
  //{$ENDIF}
{$ENDIF}
                    ] );


  RegisterComponents( 'EzControls', [
                      TEzSymbolsBox,
                      TEzSymbolsGridBox,      TEzSymbolsListBox,
                      TEzNumEd,               {$IFNDEF BCB}eznumed.TEzDBNumEd,{$ENDIF}
                      TEzLayerGridBox,        TEzLayerListBox,
                      TEzLinetypeGridBox,     TEzLinetypeListBox,
                      TEzBrushPatternGridBox, TEzBrushPatternListBox,
                      TEzColorBox,
                      TEzBlocksGridBox,       TEzBlocksListBox,
                      {TEzInspector,}           TEzFlatComboBox,
                      TEzScaleBar
                    ] );

{$IFDEF USE_INTRAWEB}
  RegisterComponents( 'IW Application', [TEzIWMap, TEzIWScaleBar] );
{$ENDIF}

{$IFDEF INSPECTOR_PROVIDER}
  RegisterComponentEditor( TEzInspectorProvider, TEzInspectorProviderCompEditor );
{$ENDIF}
End;

End.
