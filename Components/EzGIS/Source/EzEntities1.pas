Unit EzEntities;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  Controls, SysUtils, Classes, Windows, Graphics, Math, dialogs,
  EzLib, EzBase, EzBaseGIS, EzStrArru;

Const
  TwoPi = 2 * System.Pi;

Type

  TEzSymbols = Class;

  {-------------------------------------------------------------------------------}
  {                  TEzSymbols                                                   }
  {-------------------------------------------------------------------------------}

  { The symbols used in the system }
  TEzSymbol = Class
  Private
    FEntities: TList;
    FSymbols: TEzSymbols; { belongs to }
    FExtension: TEzRect;
    FCentroid: TEzPoint;
    FInsertionPoint: TEzPoint; { used when inserting as a block }
    FName: String;
    FDestroying: Boolean;

    Function Get( Index: Integer ): TEzEntity;
    Procedure ConfigureSpecialItems( Item: TEzEntity );
    procedure SetName(const Value: String);
  Public

    Constructor Create( Symbols: TEzSymbols );
    Constructor CreateFromStream( Symbols: TEzSymbols; Stream: TStream );
    Destructor Destroy; Override;

    Procedure LoadFromStream( Stream: TStream );
    Procedure SaveToStream( Stream: TStream );
    Procedure Assign( Symbol: TEzSymbol );
    Procedure Clear;
    Function Count: Integer;

    Function Add( Item: TEzEntity ): Integer;
    Procedure Insert( Index: Integer; Item: TEzEntity );
    Procedure Delete( Index: Integer );
    Function IndexOf( Item: TEzEntity ): Integer;

    Procedure Exchange( Index1, Index2: Integer );
    Procedure UpdateExtension;

    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      Const Matrix: TEzMatrix; DrawMode: TEzDrawMode; Data: Pointer = Nil );
{$IFDEF BCB}
    Procedure DrawDefault( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode );
{$ENDIF}
    Procedure DrawVector( V: TEzVector; Const PenStyle: TEzPenStyle; Grapher: TEzGrapher;
      Canvas: TCanvas; Const Clip: TEzRect; Const Matrix: TEzMatrix;
      DrawMode: TEzDrawMode );
{$IFDEF BCB}
    Procedure DrawVectorDefault( V: TEzVector; Const PenStyle: TEzPenStyle; Grapher: TEzGrapher;
      Canvas: TCanvas; Const Clip: TEzRect; DrawMode: TEzDrawMode );
{$ENDIF}

    Property Name: String Read FName Write SetName;
    Property Extension: TEzRect Read FExtension;
    Property Centroid: TEzPoint Read FCentroid;
    Property InsertionPoint: TEzPoint Read FInsertionPoint Write FInsertionPoint;

    Property Entities[Index: Integer]: TEzEntity Read Get;
  End;

  TEzSymbols = Class
  Private
    FActive: Boolean;
    FFileName: String;
    FList: TList;
    FIsLineType: Boolean;

    FOnChange: TNotifyEvent;

    Function Get( Index: Integer ): TEzSymbol;
    Procedure SetActive( Value: Boolean );
    Procedure SetIsLineType( Value: Boolean );
  Public
    Constructor Create;
    Destructor Destroy; Override;

    Procedure Assign( Symbols: TEzSymbols );
    Procedure Open;
    Procedure Close;

    Procedure LoadFromFile( const FileName: string );
    Procedure SaveToFile( const FileName: string );
    Procedure Save;
    Procedure SaveAs( Const FileName: String );
    Procedure LoadFromStream( Stream: TStream );
    Procedure SaveToStream( Stream: TStream );

    Procedure Clear;
    Function Add( Item: TEzSymbol ): Integer;
    Procedure Delete( Index: Integer );
    Function Count: Integer;
    Procedure ExChange( Index1, Index2: Integer );
    Procedure Up( Index : Integer );
    procedure Down( Index : Integer );
    Procedure BringToTop( Index: Integer );
    Procedure SendToBack( Index: Integer );

    Function IndexOfName( Const Name: String ): Integer;
    Procedure AtLeastOne;

    Property Items[Index: Integer]: TEzSymbol Read Get; Default;
    Property FileName: String Read FFileName Write FFileName;
    Property Active: Boolean Read FActive Write SetActive;
    Property IsLineType: Boolean Read FIsLineType Write SetIsLineType;

    Property OnChange: TNotifyEvent Read FOnChange Write FOnChange;
  End;


  {-------------------------------------------------------------------------------}
  {                  TEzNone - this just have database information                }
  {-------------------------------------------------------------------------------}

  TEzNone = Class( TEzEntity )
  Protected
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
  Public
    Constructor CreateEntity;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean = false): Boolean; Override;
  End;

  {-------------------------------------------------------------------------------}
  {                  TPoinTEzEntity                                               }
  {-------------------------------------------------------------------------------}

  TEzPointShape = ( psEllipse, psPoint );

  TEzPointEntity = Class( TEzEntity )
  Private
    FColor: TColor;
    FSymbolIndex: Integer;
    FPointShape: TEzPointShape;
  {$IFDEF BCB}
    function GetColor: TColor;
    function GetPointShape: TEzPointShape;
    function GetSymbolIndex: Integer;
    procedure SetColor(const Value: TColor);
    procedure SetPointShape(const Value: TEzPointShape);
    procedure SetSymbolIndex(const Value: Integer);
  {$ENDIF}
  Protected
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
    Function AttribsAsString: string; Override;
  Public
    Constructor CreateEntity( Const P: TEzPoint; Clr: TColor );
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean; Override;

    Property Color: TColor {$IFDEF BCB} Read GetColor Write SetColor {$ELSE} Read FColor Write FColor {$ENDIF};
    Property SymbolIndex: Integer {$IFDEF BCB} Read GetSymbolIndex Write SetSymbolIndex {$ELSE} Read FSymbolIndex Write FSymbolIndex {$ENDIF};
    Property PointShape: TEzPointShape {$IFDEF BCB} Read GetPointShape Write SetPointShape {$ELSE} Read FPointShape Write FPointShape {$ENDIF};
  End;

  {-------------------------------------------------------------------------------}
  {                  TEzPlace - symbols on the map                                }
  {-------------------------------------------------------------------------------}

  TEzPlace = Class( TEzEntity )
  Private
    FSymbolTool: TEzSymbolTool;
    FText: String;
    Procedure SetSymbolTool( Value: TEzSymbolTool );
    Function GetSymbolTool: TEzSymbolTool;
    function CalcBoundingBox: TEzRect;
    procedure MoveAndRotateControlPts(var MovePt, RotatePt: TEzPoint; Grapher: TEzGrapher);
    {$IFDEF BCB}
    function GetText: String;
    procedure SetText(const Value: String);
    {$ENDIF}
  Protected
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
    Function AttribsAsString: string; Override;
  Public
    { methods }
    Constructor CreateEntity( Const Pt: TEzPoint );
    Destructor Destroy; Override;
    procedure Initialize; Override;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Function PointCode( Const Pt: TEzPoint; Const Aperture: Double;
      Var Distance: Double; SelectPickingInside: Boolean; UseDrawPoints: Boolean = True ): Integer; Override;
    Procedure UpdateExtension; Override;
    Function StorageSize: Integer; Override;
    function GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector; Override;
    function GetControlPointType(Index: Integer): TEzControlPointType; Override;
    procedure UpdateControlPoint(Index: Integer; const Value: TEzPoint; Grapher: TEzGrapher=Nil); Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean = False ): Boolean; Override;

    Property SymbolTool: TEzSymbolTool Read GetSymbolTool Write SetSymbolTool;
    { if this property is <> '' then the first entity that is text
      in the list of entities for the symbol, will be replaced with this text }
    Property Text: String {$IFDEF BCB} Read GetText Write SetText {$ELSE} Read FText Write FText{$ENDIF};
  End;

  {-------------------------------------------------------------------------------}
  {                  TEzPolyLine                                                  }
  {-------------------------------------------------------------------------------}

  TEzPolyLine = Class( TEzOpenedEntity )
  Protected
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
  Public
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil ); Override;
  End;

  {-------------------------------------------------------------------------------}
  {                  TEzPolygon                                                   }
  {-------------------------------------------------------------------------------}

  TEzPolygon = Class( TEzClosedEntity )
  Protected
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
  Public
    Procedure LoadFromStream( Stream: TStream ); Override;
    Function IsClosed: Boolean; Override;
    Procedure UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil ); Override;
  End;

  {-------------------------------------------------------------------------------}
  {                  TEz                                                 }
  {-------------------------------------------------------------------------------}

  TEzRectangle = Class( TEzClosedEntity )
  private
    {$IFDEF BCB}
    function GetRotangle: Double;
    {$ENDIF}
  Protected
    FRotangle: Double;
    FPolyPoints: TEzVector;
    Procedure MakePolyPoints;
    Function GetDrawPoints: TEzVector; Override;
    Procedure MoveAndRotateControlPts( Var MovePt, RotatePt: TEzPoint; Grapher: TEzGrapher );
    Procedure SetRotangle( Value: Double );
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
  Public
    Constructor CreateEntity( Const P1, P2: TEzPoint );
    Destructor Destroy; Override;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Procedure UpdateExtension; Override;
    Procedure UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil ); Override;
    Function GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector; Override;
    Function GetControlPointType( Index: Integer ): TEzControlPointType; Override;
    Procedure ApplyTransform; Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean; Override;


    Property Rotangle: Double {$IFDEF BCB} Read GetRotangle {$ELSE} Read FRotangle {$ENDIF} Write SetRotangle;
  End;

  {-------------------------------------------------------------------------------}
  {                  TEzArc                                                       }
  {-------------------------------------------------------------------------------}

  TEzArc = Class( TEzOpenedEntity )
  Private
    FCenterX, FCenterY, FRadius: Double;
{$IFDEF BCB}
    function GetCenterX: Double;
    function GetCenterY: Double;
    function GetPointsInCurve: Word;
    function GetRadius: Double;
    procedure SetCenterX(const Value: Double);
    procedure SetCenterY(const Value: Double);
    procedure SetRadius(const Value: Double);
{$ENDIF}
    Procedure MoveAndRotateControlPts( Var MovePt, RotatePt: TEzPoint; Grapher: TEzGrapher=Nil );
  Protected
    FPointsInCurve: Word;
    FCurvePoints: TEzVector;
    Function GetDrawPoints: TEzVector; Override;
    Procedure SetPointsInCurve( N: Word );
    Function NormalizeAngle( Const Angle: Double ): Double;
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
  Public
    { P1, P2, P3 are 3 points where the arc passes }
    Constructor CreateEntity( Const P1, P2, P3: TEzPoint );
    Destructor Destroy; Override;
    procedure Initialize; Override;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Procedure MakeCurvePoints;
    Procedure UpdateExtension; Override;
    Procedure SetArc( Const CX, CY, R, StartAng, NumRadians: Double;
      IsCounterClockWise: Boolean );
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Procedure Centroid( Var CX, CY: Double ); Override;
    Procedure CalcCenterRadius;
    Function IsColinear: Boolean;
    Function StartAngle: Double;
    Function EndAngle: Double;
    Function SweepAngle: Double;
    Function GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector; Override;
    Procedure UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil ); Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean; Override;

    Property PointsInCurve: Word {$IFDEF BCB} Read GetPointsInCurve {$ElSE} Read FPointsInCurve {$ENDIF} Write SetPointsInCurve;
    Property CenterX: Double {$IFDEF BCB} Read GetCenterX Write SetCenterX {$ElSE} Read FCenterX Write FCenterX {$ENDIF};
    Property CenterY: Double {$IFDEF BCB} Read GetCenterY Write SetCenterY {$ElSE} Read FCenterY Write FCenterY {$ENDIF};
    Property Radius: Double {$IFDEF BCB} Read GetRadius Write SetRadius {$ElSE} Read FRadius Write FRadius {$ENDIF};

  End;

  {-------------------------------------------------------------------------------}
  {                  TEzEllipse2D                                                   }
  {-------------------------------------------------------------------------------}

  TEzEllipse = Class( TEzClosedEntity )
  Private
    FRotangle: Double;
    Procedure SetRotangle( Const Value: Double );
    Procedure MoveAndRotateControlPts( Var MovePt, RotatePt: TEzPoint; Grapher: TEzGrapher );
  {$IFDEF BCB}
    function GetPointsInCurve: Integer;
    function GetRotangle: Double;
  {$ENDIF}
  Protected
    FPointsInCurve: Integer;
    FCurvePoints: TEzVector;
    Function GetDrawPoints: TEzVector; Override;
    Procedure SetPointsInCurve( N: Integer );
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
  Public
    Constructor CreateEntity( Const P1, P2: TEzPoint );
    Destructor Destroy; Override;
    Procedure Initialize; Override;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Procedure UpdateExtension; Override;
    Procedure UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil ); Override;
    Function GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector; Override;
    Function GetControlPointType( Index: Integer ): TEzControlPointType; Override;
    Procedure ApplyTransform; Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean; Override;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Procedure MakeCurvePoints;

    Property PointsInCurve: Integer {$IFDEF BCB} Read GetPointsInCurve {$ELSE} Read FPointsInCurve {$ENDIF} Write SetPointsInCurve;
    Property Rotangle: Double {$IFDEF BCB} Read GetRotangle {$ELSE} Read FRotangle {$ENDIF} Write SetRotangle;
  End;

  {-------------------------------------------------------------------------------}
  {                  TEzPictureRef a picture referenced                           }
  {-------------------------------------------------------------------------------}

  TEzPictureRef = Class( TEzRectangle )
  Private
    FFileName: String;
    FGraphicLink: TEzGraphicLink;
    FAlphaChannel: Byte;
    { assigned temporarily }
    FStream: TStream;
    Function DoReadFile: Boolean;
    Function GetGraphicLink: TEzGraphicLink;
  {$IFDEF BCB}
    function GetAlphaChannel: byte;
    function GetFileName: String;
    function GetStream: TStream;
    procedure SetAlphaChannel(const Value: byte);
    procedure SetFileName(const Value: String);
    procedure SetStream(const Value: TStream);
  {$ENDIF}
  Protected
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
  Public
    Constructor CreateEntity( Const P1, P2: TEzPoint; Const FileName: String );
    Destructor Destroy; Override;
    Procedure Initialize; Override;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Function StorageSize: Integer; Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean; Override;

    { This property determines the AlphaChannel of the image
      0= opaque, 255= transparent }
    Property AlphaChannel: byte {$IFDEF BCB} Read GetAlphaChannel Write SetAlphaChannel {$ELSE} Read FAlphaChannel Write FAlphaChannel {$ENDIF};
    Property FileName: String {$IFDEF BCB} Read GetFileName Write SetFileName {$ELSE} Read FFileName Write FFileName {$ENDIF};
    { When this property is defined, instead of loading the bitmap from a
      disk file, the bitmap is loaded from this stream.
      If the source of the bitmap is a blob field in a c/s database, then you
      can use the property Filename as a key to the corresponding record on the
      c/s database.
      You can set the Stream property on event OnBeforPaintEntity
      and when this class is destroyed, the FStream will also be freed
      automatically if FStream<>nil }
    Property Stream: TStream {$IFDEF BCB} Read GetStream Write SetStream {$ELSE} Read FStream Write FStream {$ENDIF};
  End;

  {-------------------------------------------------------------------------------}
  {                  TEzPersistBitmap  - this is saved to the file                }
  {-------------------------------------------------------------------------------}

  TEzPersistBitmap = Class( TEzRectangle )
  Private
    FBitmap: TBitmap;
    FTransparent: Boolean;
  {$IFDEF BCB}
    function GetBitmap: TBitmap;
    function GetTransparent: Boolean;
    procedure SetTransparent(const Value: Boolean);
  {$ENDIF}
  Protected
    Function GetEntityID: TEzEntityID; Override;
  Public
    Constructor CreateEntity( Const P1, P2: TEzPoint; Const FileName: String );
    Destructor Destroy; Override;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Function StorageSize: Integer; Override;

    Property Transparent: Boolean {$IFDEF BCB} Read GetTransparent Write SetTransparent {$ELSE} Read FTransparent Write FTransparent {$ENDIF};
    Property Bitmap: TBitmap {$IFDEF BCB} Read GetBitmap {$ELSE} Read FBitmap {$ENDIF};
  End;

  {---------------------------------------------------------------------------}
  {  TEzBandsBitmap  - banded bitmap and BIL reader entity                    }
  {---------------------------------------------------------------------------}

  TEzImageFormat = (ifBitmap, ifTiff, ifBIL);

  TEzBandsBitmap = Class( TEzClosedEntity )
  Private
    FFileName: String;
    FAlphaChannel: Byte;
    FVector: TEzVector;
    { temporarily assigned only (in events mainly) }
    FStream: TStream;
  {$IFDEF BCB}
    function GetAlphaChannel: Byte;
    function GetFileName: String;
    function GetStream: TStream;
    procedure SetAlphaChannel(const Value: Byte);
    procedure SetFileName(const Value: String);
    procedure SetStream(const Value: TStream);
  {$ENDIF}
  Protected
    Function GetDrawPoints: TEzVector; Override;
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
  Public
    Constructor CreateEntity( Const P1, P2: TEzPoint; Const FileName: String );
    Destructor Destroy; Override;
    Procedure Initialize; Override;
    function GetFormat: TEzImageFormat;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Function StorageSize: Integer; Override;
    Procedure UpdateExtension; Override;
    Procedure UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil ); Override;
    Function GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector; Override;
    Function GetControlPointType( Index: Integer ): TEzControlPointType; Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean; Override;

    Property FileName: String {$IFDEF BCB} Read GetFileName Write SetFileName {$ELSE} Read FFileName Write FFileName {$ENDIF};
    { When this property is defined, instead of loading the bitmap from a
      disk file, the bitmap is loaded from this stream.
      If the source of the bitmap is a blob field in a c/s database, then you
      can use the property Filename as a key to the corresponding record on the
      c/s database.
      You can set the Stream property on event OnBeforPaintEntity
      and when this class is destroyed, the FStream will also be freed
      automatically if FStream<>nil }
    Property Stream: TStream {$IFDEF BCB} Read GetStream Write SetStream {$ELSE} Read FStream Write FStream {$ENDIF};
    { This property determines the percent of AlphaChannel of the image
      0= opaque, 255= transparent }
    Property AlphaChannel: Byte {$IFDEF BCB} Read GetAlphaChannel Write SetAlphaChannel {$ELSE} Read FAlphaChannel Write FAlphaChannel {$ENDIF};
  End;

  { a custom picture - in event OnBeforePaintEntity you must assign a picture
    (bitmap, metafile, icon, etc. ) to draw here. Example, you can use this
    entity in order to draw a Tee Chart or any other image }
  TEzCustomPicture = Class( TEzClosedEntity )
  Private
    FPicture: TPicture;
    FTransparent: Boolean;
    FVector: TEzVector;
  {$IFDEF BCB}
    function GetPicture: TPicture;
    function GetTransparent: Boolean;
    procedure SetPicture(const Value: TPicture);
    procedure SetTransparent(const Value: Boolean);
  {$ENDIF}
  Protected
    Function GetDrawPoints: TEzVector; Override;
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
  Public
    Constructor CreateEntity( Const P1, P2: TEzPoint );
    Destructor Destroy; Override;
    Procedure Initialize; Override;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Procedure UpdateExtension; Override;
    Procedure UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil ); Override;
    Function GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector; Override;
    Function GetControlPointType( Index: Integer ): TEzControlPointType; Override;

    Property Transparent: Boolean {$IFDEF BCB} Read GetTransparent Write SetTransparent {$ELSE} Read FTransparent Write FTransparent {$ENDIF};
    Property Picture: TPicture {$IFDEF BCB} Read GetPicture Write SetPicture {$ELSE} Read FPicture Write FPicture {$ENDIF};
  End;


  {-------------------------------------------------------------------------------}
  {                  TEzSpline                                                    }
  {-------------------------------------------------------------------------------}

  TEzSpline = Class( TEzPolyline )
  private
  {$IFDEF BCB}
    function GetOrder: Byte;
    function GetPointsInCurve: Word;
    procedure SetOrder(const Value: Byte);
    procedure SetPointsInCurve(const Value: Word);
  {$ENDIF}
  Protected
    FPointsInCurve: Word;
    FOrder: Byte;
    FCurvePoints: TEzVector;
    Function GetDrawPoints: TEzVector; Override;
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
  Public
    Destructor Destroy; Override;
    Procedure Initialize; Override;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Procedure GetCurvePoints;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;

    Property PointsInCurve: Word {$IFDEF BCB} Read GetPointsInCurve Write SetPointsInCurve {$ELSE} Read FPointsInCurve Write FPointsInCurve {$ENDIF};
    Property Order: Byte {$IFDEF BCB} Read GetOrder Write SetOrder {$ELSE} Read FOrder Write FOrder {$ENDIF};
  End;

  {------------------------------------------------------------------------------}
  {                             TEzTrueTypeText                                }
  {------------------------------------------------------------------------------}

  TEzTrueTypeText = Class( TEzClosedEntity )
  Private
    FText: String;
    FAlignment: TAlignment;
    FFontTool: TEzFontTool;
    Function GetBasePoint: TEzPoint;
    Procedure SetBasePoint(const Value: TEzPoint);
    procedure DoPolyPoints(const XY: TEzPoint; ByCenter: Boolean;
      Grapher: TEzGrapher = nil);
    function GetFontTool: TEzFontTool;
  {$IFDEF BCB}
    function GetAlignment: TAlignment;
    function GetText: String;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetText(const Value: String);
  {$ENDIF}
    function DrawPolygon(Grapher: TEzGrapher; Canvas: TCanvas;
      const Clip: TEzRect; DrawMode: TEzDrawMode): Boolean;
    procedure DrawAsPath(Grapher: TEzGrapher; Canvas: TCanvas;
      const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer);
  Protected
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
    Function AttribsAsString: string; Override;
  Public
    Constructor CreateEntity( Const Pt: TEzPoint;
      Const Text: String; Const Height, Angle: Double );
    Destructor Destroy; Override;
    Procedure Initialize; Override;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Procedure UpdateExtension; Override;
    procedure Draw(Grapher: TEzGrapher; Canvas: TCanvas; const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = nil); override;
    Function StorageSize: Integer; Override;
    Procedure UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil ); Override;
    Procedure ApplyTransform; Override;
    Procedure ShowDirection( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; DirectionPos: TEzDirectionpos;
      Const DirectionPen: TEzPenStyle; Const DirectionBrush: TEzBrushStyle;
      RevertDirection: Boolean ); Override;
    Procedure MakePolyPoints(Grapher: TEzGrapher = Nil);
    Procedure MakePolyPointsByCenter( Const XY: TEzPoint; Grapher: TEzGrapher = Nil );
    Function GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector; Override;
    Function GetControlPointType( Index: Integer ): TEzControlPointType; Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean; Override;

    Property Text: String {$IFDEF BCB} Read GetText Write SetText {$ELSE} Read FText Write FText {$ENDIF};
    { angle in radians }
    Property FontTool: TEzFontTool Read GetFontTool ;
    Property Alignment: TAlignment {$IFDEF BCB} Read GetAlignment Write SetAlignment {$ELSE} Read FAlignment Write FAlignment {$ENDIF};
    Property BasePoint: TEzPoint Read GetBasePoint Write SetBasePoint;
  End;

  {------------------------------------------------------------------------------}
  {                  TEzGroupEntity - container for grouping entities          }
  {------------------------------------------------------------------------------}

    { The type of grouping actually done }
  TEzGroupType = ( gtNone, gtFitToPath );

  TEzGroupEntity = Class( TEzEntity )
  Private
    FGroupType: TEzGroupType;
    FEntities: TList;
    Function GetEntities( Index: Integer ): TEzEntity;
    Procedure MoveAndRotateControlPts( Var MovePt, RotatePt: TEzPoint; Grapher: TEzGrapher );
  {$IFDEF BCB}
    function GetGroupType: TEzGroupType;
    procedure SetGroupType(const Value: TEzGroupType);
  {$ENDIF}
  Protected
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
  Public
    Constructor CreateEntity;
    Destructor Destroy; Override;
    Procedure Initialize; Override;
    Procedure Clear;
    Procedure Add( Ent: TEzEntity );
    Function Count: Integer;

    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Function StorageSize: Integer; Override;
    Procedure UpdateExtension; Override;
    Procedure ApplyTransform; Override;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Function PointCode( Const Pt: TEzPoint; Const Aperture: Double;
      Var Distance: Double; SelectPickingInside: Boolean; UseDrawPoints: Boolean = True ): Integer; Override;
    Procedure InternalClearList;
    Procedure UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil ); Override;
    Function GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector; Override;
    Function GetControlPointType( Index: Integer ): TEzControlPointType; Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean; Override;

    Property GroupType: TEzGroupType {$IFDEF BCB} Read GetGroupType Write SetGroupType {$ELSE} Read FGroupType Write FGroupType {$ENDIF};
    Property Entities[Index: Integer]: TEzEntity Read GetEntities;
  End;


  {-------------------------------------------------------------------------------}
  {                  Vectorial fonts                                              }
  {-------------------------------------------------------------------------------}

  { one single character
    Every single character is enclosed in a (0,0) to (1,1) unit
    coordinates in order to support transformation }
  TEzVectorChar = Class
  Private
    { A multi-part vector is used }
    FVector: TEzVector;
    { the extension of the character }
    FExtension: TEzRect;
  Public
    { pass the number of vectors to create on start up }
    Constructor Create;
    Destructor Destroy; Override;
    Procedure LoadFromStream( stream: TStream );
    Procedure SaveToStream( stream: TStream );
    Procedure UpdateExtension;

    Property Vector: TEzVector Read FVector;
    Property Extension: TEzRect Read FExtension;
  End;

  { a list of TEzVectorChar by using a sparse list if > 255 chars or
    a TList if < 255 for faster access time }
  TEzVectorCharList = Class
  Private
    FList: TList;
    FSparseList: TSparseList;
    FCapacity: Integer;
    Function Get( Index: Integer ): TEzVectorChar;
    Procedure Put( Index: Integer; Value: TEzVectorChar );
    Procedure SetCapacity( Value: Integer );
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Clear;

    Property Items[Index: Integer]: TEzVectorChar Read Get Write Put; Default;
    Property Capacity: Integer Read FCapacity Write SetCapacity;
  End;

  { This class contains the list of chars that builds up the font typeface }
  TEzVectorFont = Class
  Private
    FChars: TEzVectorCharList;
    FName: String;
    FMaxChar: Integer;
    Function GetChar( Index: Integer ): TEzVectorChar;
    Procedure SetChar( Index: Integer; VectorChar: TEzVectorChar );
    Procedure SetMaxChar( Value: Integer );
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure LoadFromStream( Stream: TStream );
    Procedure SaveToStream( Stream: TStream );
    Procedure LoadFromFile( Const FileName: String );
    Procedure SaveToFile( Const FileName: String );
    Function GetTextExtension( Const Value: String;
      Const Height: Double;
      Const InterCharSpacing: Double;
      Const InterLineSpacing: Double ): TEzRect;
    Function GetFittedTextExtension( Const Value: String;
      InterCharSpacing: Double ): TEzRect;

    Property Chars[Index: Integer]: TEzVectorChar Read GetChar Write SetChar;
    Property Name: String Read FName Write FName;
    Property MaxChar: Integer Read FMaxChar Write SetMaxChar;
  End;

  { TEzVectorFonts the list of fonts }
  TEzVectorFonts = Class
  Private
    { a list of TEzVectorFont }
    FFontList: TList;
    FNullChar: TEzVectorChar;
    FDefaultFont: TEzVectorFont;
    Function Get( Index: Integer ): TEzVectorFont;
    Function GetDefaultFont: TEzVectorFont;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Function Count: Integer;
    { add a font file (Arial.fnt) to the list}
    Procedure AddFontFile( Const FileName: String );
    Procedure AddFont( VectorFont: TEzVectorFont );
    { Clear the list of fonts}
    Procedure Clear;
    { delete a font by ordinal position }
    Procedure Delete( Index: Integer );
    { delete a font given a font name }
    Procedure DeleteByName( Const FontName: String );
    { Given a font name ("Arial") this function returns the
      TEzVectorFont associated with that name.
      If the given name is not found, the default font is returned }
    Function FontByName( Const FontName: String ): TEzVectorFont;
    { this function return the vector font given an index on the
      list of fonts }
    Function FontByIndex( Index: Integer ): TEzVectorFont;
    { given a vector font, this function return the position on the list
      of fonts }
    Function IndexOfFont( VectorFont: TEzVectorFont ): Integer;
    { given a font name, this function return the position on the
      list of fonts }
    Function IndexOfFontByName( Const FontName: String ): Integer;
    { This procedure defines the default font by name
      is the font name is not found, the 0 position font is used }
    Procedure SetDefaultFontByName( Const FontName: String );
    { set the default font by ordinal position }
    Procedure SetDefaultFontByIndex( Index: Integer );
    { populates a TStrings with the list of font names }
    Procedure PopulateTo( Strings: TStrings );

    Property Items[Index: Integer]: TEzVectorFont Read Get; Default;
    Property NullChar: TEzVectorChar Read FNullChar;
    Property DefaultFont: TEzVectorFont Read GetDefaultFont;
  End;

  TEzHorzAlignment = ( haLeft, haCenter, haRight );
  TEzVertAlignment = ( vaTop, vaCenter, vaBottom );

  { TEzJustifVectorText - an enhanced justified vectorial text }

  TEzJustifVectorText = Class( TEzClosedEntity )
  Private
    FVectorFont: TEzVectorFont;
    FText: String;
    FHeight: Double;
    FAngle: Double;
    FFontColor: TColor;
    FHorzAlignment: TEzHorzAlignment;
    FVertAlignment: TEzVertAlignment;
    FInterCharSpacing: Double;
    FInterLineSpacing: Double;
    FTextBox: TEzRect;
    { this function returns the text extension as if not angle is given }
    Function GetFontName: String;
    Procedure SetFontName( Const Value: String );
    Procedure SetInterCharSpacing( Const Value: Double );
    Procedure SetInterLineSpacing( Const Value: Double );
    Procedure SetAngle( Const Value: Double );
    Procedure SetHeight( Const Value: Double );
    Procedure SetTextBox( Const Value: TEzRect );
    Procedure DoNormalizedVector( Const Emin, Emax: TEzPoint );
    Procedure PopulatePoints;
    Procedure DoRotation;
    Procedure SetText( Const Value: String );
    Procedure MoveAndRotateControlPoint( Var MovePt, RotatePt: TEzPoint; Grapher: TEzGrapher );
  {$IFDEF BCB}
    function GetAngle: Double;
    function GetFontColor: TColor;
    function GetHeight: Double;
    function GetHorzAlignment: TEzHorzAlignment;
    function GetInterCharSpacing: Double;
    function GetInterLineSpacing: Double;
    function GetText: String;
    function GetTextBox: TEzRect;
    function GetVectorFont: TEzVectorFont;
    function GetVertAlignment: TEzVertAlignment;
    procedure SetFontColor(const Value: TColor);
    procedure SetHorzAlignment(const Value: TEzHorzAlignment);
    procedure SetVectorFont(const Value: TEzVectorFont);
    procedure SetVertAlignment(const Value: TEzVertAlignment);
  {$ENDIF}
  Protected
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
    Function AttribsAsString: string; Override;
  Public
    Constructor CreateEntity( Const TextBox: TEzRect; Const Height: Double; Const Text: String );
    procedure Initialize; Override;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Function StorageSize: Integer; Override;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Procedure ApplyTransform; Override;
    Procedure UpdateExtension; Override;
    Function IsClosed: Boolean; Override;
    Procedure UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil ); Override;
    Procedure UpdateExtensionFromControlPts; Override;
    Function GetTextExtension: TEzRect;
    Procedure MakePolyPointsByCenter( Const Center: TEzPoint );
    Function GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector; Override;
    Function GetControlPointType( Index: Integer ): TEzControlPointType; Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean; Override;

    { The text to show on the map }
    Property Text: String {$IFDEF BCB} Read GetText {$ELSE} Read FText {$ENDIF} Write SetText;
    { the height of the text inside the bounding box }
    Property Height: Double {$IFDEF BCB} Read GetHeight {$ELSE} Read FHeight {$ENDIF} Write SetHeight;
    { this is the angle of the text in radians }
    Property Angle: Double{$IFDEF BCB} Read GetAngle {$ELSE} Read  FAngle {$ENDIF} Write SetAngle;
    { the font color }
    Property FontColor: TColor {$IFDEF BCB} Read GetFontColor Write SetFontColor {$ELSE} Read FFontColor Write FFontColor {$ENDIF};
    { the vector font object used for drawing }
    Property VectorFont: TEzVectorFont {$IFDEF BCB} Read GetVectorFont Write SetVectorFont {$ELSE} Read FVectorFont Write FVectorFont {$ENDIF};
    { an indirect reference to the vector font }
    Property FontName: String Read GetFontName Write SetFontName; // no data associated
    { the horizontal alignment }
    Property HorzAlignment: TEzHorzAlignment {$IFDEF BCB} Read GetHorzAlignment Write SetHorzAlignment {$ELSE} Read FHorzAlignment Write FHorzAlignment {$ENDIF};
    { the vertical alignment }
    Property VertAlignment: TEzVertAlignment {$IFDEF BCB} Read GetVertAlignment Write SetVertAlignment {$ELSE} Read FVertAlignment Write FVertAlignment {$ENDIF};
    { the interchar spacing: 0.3 means 30% of text height }
    Property InterCharSpacing: Double {$IFDEF BCB} Read GetInterCharSpacing {$ELSE} Read FInterCharSpacing {$ENDIF} Write SetInterCharSpacing;
    { the interline spacing: 0.3 means 30% of text height }
    Property InterLineSpacing: Double {$IFDEF BCB} Read GetInterLineSpacing {$ELSE} Read FInterLineSpacing {$ENDIF} Write SetInterLineSpacing;
    Property TextBox: TEzRect {$IFDEF BCB} Read GetTextBox {$ELSE} Read FTextBox {$ENDIF} Write SetTextBox;
  End;

  { TEzFittedVectorText an enhanced multi-line fitted vectorial text }

  TEzTextBorderStyle = ( tbsNone, tbsBanner, tbsCallout, tbsBulletLeader );

  TEzFittedVectorText = Class( TEzClosedEntity )
  Private
    FVectorFont: TEzVectorFont;
    FText: String;
    FHeight: Double;
    FWidth: Double;
    FAngle: Double;
    FFontColor: TColor;
    FInterCharSpacing: Double;
    FInterLineSpacing: Double;
    FTextBorderStyle: TEzTextBorderStyle;
    FPivot: TEzPoint;
    FHideShadow: Boolean;
    { this function returns the text extension as if not angle is given }
    Function GetFontName: String;
    Procedure SetFontName( Const Value: String );
    Procedure SetInterCharSpacing( Const Value: Double );
    Procedure SetInterLineSpacing( Const Value: Double );
    Procedure SetAngle( Const Value: Double );
    Procedure SetHeight( Const Value: Double );
    Procedure SetWidth( Const Value: Double );
    Procedure DoNormalizedVector( Const BasePt: TEzPoint; V: TEzVector );
    Procedure PopulatePoints;
    Function GetBasePoint: TEzPoint;
    Procedure SetBasePoint( Const Value: TEzPoint );
    Procedure SetText( Const Value: String );
    Procedure DoDrawing( Path: TEzVector; FittedToLen: Boolean;
      Grapher: TEzGrapher; Canvas: TCanvas;
      Const Clip: TEzRect; DrawMode: TEzDrawMode );
    Procedure MoveAndRotateControlPoint( Var MovePt, RotatePt: TEzPoint; Grapher: TEzGrapher );
  {$IFDEF BCB}
    function GetAngle: Double;
    function GetFontColor: TColor;
    function GetHeight: Double;
    function GetHideShadow: Boolean;
    function GetInterCharSpacing: Double;
    function GetInterLineSpacing: Double;
    function GetPivot: TEzPoint;
    function GetText: String;
    function GetTextBorderStyle: TEzTextBorderStyle;
    function GetVectorFont: TEzVectorFont;
    function GetWidth: Double;
    procedure SetFontColor(const Value: TColor);
    procedure SetHideShadow(const Value: Boolean);
    procedure SetTextBorderStyle(const Value: TEzTextBorderStyle);
    procedure SetVectorFont(const Value: TEzVectorFont);
    procedure SetPivot(const Value: TEzPoint);
  {$ENDIF}
  Protected
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
    Function AttribsAsString: string; Override;
  Public
    Constructor CreateEntity( Const BasePoint: TEzPoint; Const Text: String;
      Const Height, Width, Angle: Double );
    procedure Initialize; Override;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Function StorageSize: Integer; Override;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Procedure DrawToPath( Path: TEzVector; FittedToLen: Boolean;
      Grapher: TEzGrapher; Canvas: TCanvas;
      Const Clip: TEzRect; DrawMode: TEzDrawMode );
    Procedure ApplyTransform; Override;
    Procedure UpdateExtension; Override;
    Function IsClosed: Boolean; Override;
    Procedure UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil ); Override;
    Procedure UpdateExtensionFromControlPts; Override;
    Function GetTextExtension: TEzRect;
    Procedure MakePolyPointsByCenter( Const Center: TEzPoint );
    Function GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector; Override;
    Function GetControlPointType( Index: Integer ): TEzControlPointType; Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean; Override;


    { The text to show on the map }
    Property Text: String {$IFDEF BCB} Read GetText {$ELSE} Read FText {$ENDIF} Write SetText;
    Property BasePoint: TEzPoint Read GetBasePoint Write SetBasePoint;
    { the height of the text inside the bounding box }
    Property Height: Double {$IFDEF BCB} Read GetHeight {$ELSE} Read FHeight  {$ENDIF} Write SetHeight;
    { the width of the text inside the bounding box }
    Property Width: Double {$IFDEF BCB} Read GetWidth {$ELSE} Read FWidth  {$ENDIF} Write SetWidth;
    { this is the angle of the text in radians }
    Property Angle: Double {$IFDEF BCB} Read GetAngle {$ELSE} Read FAngle  {$ENDIF} Write SetAngle;
    { the font color }
    Property FontColor: TColor {$IFDEF BCB} Read GetFontColor Write SetFontColor {$ELSE} Read FFontColor Write FFontColor {$ENDIF};
    { the vector font object used for drawing }
    Property VectorFont: TEzVectorFont {$IFDEF BCB} Read GetVectorFont Write SetVectorFont {$ELSE} Read FVectorFont Write FVectorFont {$ENDIF};
    { an indirect reference to the vector font }
    Property FontName: String Read GetFontName Write SetFontName; // no data associated
    { the interchar spacing: 0.3 means 30% of text height }
    Property InterCharSpacing: Double {$IFDEF BCB} Read GetInterCharSpacing {$ELSE} Read FInterCharSpacing  {$ENDIF} Write SetInterCharSpacing;
    { the interline spacing: 0.3 means 30% of text height }
    Property InterLineSpacing: Double {$IFDEF BCB} Read GetInterLineSpacing {$ELSE} Read FInterLineSpacing  {$ENDIF} Write SetInterLineSpacing;
    Property TextBorderStyle: TEzTextBorderStyle {$IFDEF BCB} Read GetTextBorderStyle {$ELSE} Read FTextBorderStyle  {$ENDIF} Write FTextBorderStyle;
    Property Pivot: TEzPoint {$IFDEF BCB} Read GetPivot Write SetPivot {$ELSE} Read FPivot Write FPivot {$ENDIF};
    Property HideShadow: Boolean {$IFDEF BCB} Read GetHideShadow Write SetHideShadow {$ELSE} Read FHideShadow Write FHideShadow {$ENDIF};
  End;

  {------------------------------------------------------------------------------}
  //              Hatch patterns
  {------------------------------------------------------------------------------}

  PEzHatchData = ^TEzHatchData;

  TEzHatchData = Packed Record
    Angle: Double;
    Origin: TEzPoint;
    Delta: TEzPoint;
    NumDashes: Integer;
    Dashes: Array[0..5] Of Double;
  End;

  TEzHatch = Class
  Private
    FName: String;
    FDescription: String;
    FList: TList;
    Function Get( Index: Integer ): TEzHatchData;
    Procedure Put( Index: Integer; Const Value: TEzHatchData );
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Clear;
    Procedure Add( Const Hatch: TEzHatchData );
    Procedure DrawHatchTo( Vector: TEzVector; Const Clip, Extent: TEzRect;
      Grapher: TEzGrapher; Canvas: TCanvas; Color: TColor; Const Scale, Angle: Double;
      Const Matrix: TEzMatrix );
    Function Count: Integer;

    Property Name: String Read FName Write FName;
    Property Description: String Read FDescription Write FDescription;
    Property Items[Index: Integer]: TEzHatchData Read Get Write Put; Default;
  End;

  TEzHatchList = Class
  Private
    FList: TList;
    Function Get( Index: Integer ): TEzHatch;
    Procedure Put( Index: Integer; Value: TEzHatch );
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Function Add: TEzHatch;
    Function Count: Integer;
    Procedure Clear;
    Procedure AddPATFile( Const FileName: String );

    Property Items[Index: Integer]: TEzHatch Read Get Write Put; Default;
  End;

  TEzMap500Entity = class(TEzRectangle)
  private
    FText: TEzTrueTypeText;
    FNomenclature: String;
    function GetFontTool: TEzFontTool;
    procedure SetNomenclature(const Value: String);
    function SetTopLeft(var X, Y: Integer): Boolean;
    function LatinToArabian(const Latin: String): Integer;
    procedure CreateText;
  protected
    function GetEntityID: TEzEntityID; override;
    procedure ReCreate;
    function NomenclatureIsBad: Boolean;
  public
    constructor CreateEntity(const ANomenclature: String);
    destructor Destroy; override;
    procedure Initialize; override;
    procedure Draw(Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    property FontTool: TEzFontTool read GetFontTool;
    property Nomenclature: String read FNomenclature write SetNomenclature;
  end;

  TEzAxis = class(TEzPolyline)
  private
    FAdd1, FAdd2: TEzPolyline;
    FLabel1, FLabel2: TEzTrueTypeText;
    FCircle1, FCircle2: TEzEllipse;
    FName: String;
    FShowNameAtTop: Boolean;
    FShowNameAtBottom: Boolean;
    procedure SetName(const Value: String);
    procedure SetPoint1(const Value: TEzPoint);
    procedure SetPoint2(const Value: TEzPoint);
    function GetPoint1: TEzPoint;
    function GetPoint2: TEzPoint;
  protected
    procedure CreateFirstAddLine;
    procedure CreateSecondAddLine;
    procedure CreateAdditionalLines;
  protected
    function GetEntityID: TEzEntityID; override;
  public
    constructor CreateEntity(const P1, P2: TEzPoint; const aName: String);
    destructor Destroy; override;
    procedure Initialize; override;
    procedure Draw(Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure UpdateExtension; override;
    function PointCode(const Pt: TEzPoint; const Aperture: Double;
      var Distance: Double; SelectPickingInside: Boolean;
      UseDrawPoints: Boolean = True ): Integer; override;
    //
    property Point1: TEzPoint read GetPoint1 write SetPoint1;
    property Point2: TEzPoint read GetPoint2 write SetPoint2;
    property Name: String read FName write SetName;
    property ShowNameAtTop: Boolean read FShowNameAtTop write FSHowNameAtTop;
    property ShowNameAtBottom: Boolean read FShowNameAtBottom write FSHowNameAtBottom;
  end;

Implementation

Uses
  Printers, EzBaseExpr, ezdims, EzPolyclip, EzSystem, EzGraphics, EzConsts,
  EzBasicCtrls, EzGisTiff ;


Const
  SYMBOL_ID = 8011;
  SYMBOL_VERSIONNUMBER = 100;

{------------------------------------------------------------------------------}
{                  Symbols                                                     }
{------------------------------------------------------------------------------}

{ TEzSymbol }

Constructor TEzSymbol.Create( Symbols: TEzSymbols );
Begin
  Inherited Create;
  FSymbols := Symbols;
  FEntities := TList.Create;
  UpdateExtension;
End;

Destructor TEzSymbol.Destroy;
Begin
  FDestroying := True;
  Clear;
  FEntities.Free;
  Inherited Destroy;
End;

Constructor TEzSymbol.CreateFromStream( Symbols: TEzSymbols; Stream: TStream );
Begin
  Inherited Create;
  FSymbols := Symbols;
  FEntities := TList.Create;
  LoadFromStream( Stream );
End;

procedure TEzSymbol.Assign(Symbol: TEzSymbol);
var
  I, SymbCount: Integer;
  TmpClass: TEzEntityClass;
  Ent, TmpEnt: TEzEntity;
begin
  Clear;
  FName := Symbol.FName;
  SymbCount := Symbol.Count - 1;
  for I := 0 to SymbCount do
  begin
    Ent := Symbol.Entities[I];
    TmpClass := GetClassFromID(Ent.EntityID);
    TmpEnt := TmpClass.Create(Ent.Points.Count);
    TmpEnt.Assign(Ent);
    FEntities.Add(TmpEnt);
  end;
  UpdateExtension;
end;

procedure TEzSymbol.LoadFromStream(Stream: TStream);
var
  I, N: Integer;
  EntityID: TEzEntityID;
  TmpClass: TEzEntityClass;
  TmpEntity: TEzEntity;
begin
  Clear;
  with Stream do
  begin
    FName := EzReadStrFromStream(Stream);
    Read(N, SizeOf(Integer));
    Dec(N);
    for I := 0 to N do
    begin
      Read(EntityID, SizeOf(TEzEntityID));
      TmpClass := GetClassFromID(EntityID);
      TmpEntity := TmpClass.Create(2);
      TmpEntity.LoadFromStream(Stream);
      FEntities.Add(TmpEntity);
    end;
    Read(FInsertionPoint, SizeOf(TEzPoint));
  end;
  UpdateExtension;
end;

procedure TEzSymbol.SaveToStream(Stream: TStream);
var
  I, N: Integer;
  EntityID: TEzEntityID;
  TmpEnt: TEzEntity;
Begin
  N := FEntities.Count;
  with Stream do
  begin
    EzWriteStrToStream(FName, Stream);
    Write(N, SizeOf(Integer));
    Dec(N);
    for I := 0 to N do
    begin
      TmpEnt := TEzEntity(FEntities[I]);
      EntityID := TmpEnt.EntityID;
      Write(EntityID, SizeOf(TEzEntityID));
      TmpEnt.SaveToStream(Stream);
    end;
    FInsertionPoint:= FCentroid;
    Write(FInsertionPoint, SizeOf(TEzPoint));
  end;
end;

procedure TEzSymbol.Clear;
var
  I, EntCnt: Integer;
Begin
  EntCnt := FEntities.Count;
  if EntCnt = 0 then Exit;
  Dec(EntCnt);
  for I := 0 to EntCnt do
    TEzEntity(FEntities[I]).Free;
  FEntities.Clear;
  if not FDestroying then
    UpdateExtension;
end;

Function TEzSymbol.Count: Integer;
Begin
  Result := FEntities.Count;
End;

Procedure TEzSymbol.Insert( Index: Integer; Item: TEzEntity );
Begin
  ConfigureSpecialItems( Item );
  If Item = Nil Then Exit;
  FEntities.Insert( Index, Item );
  UpdateExtension;
End;

Function TEzSymbol.Add( Item: TEzEntity ): Integer;
Begin
  Result := -1;
  ConfigureSpecialItems( Item );
  If Item = Nil Then Exit;
  Result := FEntities.Add( Item );
  UpdateExtension;
End;

procedure TEzSymbol.ConfigureSpecialItems(Item: TEzEntity);
begin
  with Item do
    if EntityID = idPolygon then
    begin
      if Points.Parts.Count < 2 then
      begin
        if not EzLib.EqualPoint2D(Points[0], Points[Pred(Points.Count)]) then
          Points.Add(Points[0]);
      end
      else
      begin
        // It is assumed only simple polygons will be added
      end;
    End;
End;

procedure TEzSymbol.Delete(Index: Integer);
begin
  if (Index < 0) or ( Index > Pred(FEntities.Count)) then
    EzGisError(SEntityOutOfBound);
  TEzEntity(FEntities[Index]).Free;
  FEntities.Delete(Index);
  UpdateExtension;
end;

Function TEzSymbol.IndexOf( Item: TEzEntity ): Integer;
Begin
  Result := FEntities.IndexOf( Item );
End;

Procedure TEzSymbol.Exchange( Index1, Index2: Integer );
Begin
  FEntities.Exchange( Index1, Index2 );
End;

function TEzSymbol.Get(Index: Integer): TEzEntity;
begin
  if (Index < 0) or (Index > Pred(FEntities.Count)) then
    EzGisError(SEntityOutOfBound);
  Result := TEzEntity(FEntities[Index]);
end;

procedure TEzSymbol.UpdateExtension;
var
  I, N: Integer;
  Item: TEzRect;
  OldExtents: TEzRect;
  OldCentroid: TEzPoint;
  FirstY, LeftMostX: Double;
begin
  OldExtents := FExtension;
  OldCentroid := FCentroid;
  FExtension := INVALID_EXTENSION;
  FillChar(FCentroid, SizeOf(TEzPoint), 0);
  N := Pred(FEntities.Count);
  LeftMostX := MAXCOORD;
  FirstY := 0;
  for I := 0 to N do
  begin
    Item := TEzEntity(FEntities[I]).Points.Extension;
    MaxBound(FExtension.Emax, Item.Emax);
    MinBound(FExtension.Emin, Item.Emin);
    if Assigned(FSymbols) and FSymbols.FIsLineType and (Item.X1 < LeftMostX) then
    begin
      FirstY := Item.Y1;
      LeftMostX := Item.X1;
    end;
  end;
  if N >= 0 then
  begin
    FCentroid.X := FExtension.Emin.X + (FExtension.Emax.X - FExtension.Emin.X) / 2;
    if Assigned(FSymbols) and FSymbols.FIsLineType then
      FCentroid.Y := FirstY
    else
      FCentroid.Y := FExtension.Emin.Y + (FExtension.Emax.Y - FExtension.Emin.Y) / 2;
  end;
  if Assigned(FSymbols) and Assigned(FSymbols.OnChange) and
     ((EqualRect2D(OldExtents, FExtension) = False ) or
       (CompareMem(@OldCentroid, @FCentroid, SizeOf(TEzPoint)) = False))
  then
    FSymbols.OnChange(FSymbols);
end;

{$IFDEF BCB}
Procedure TEzSymbol.DrawDefault( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
  DrawMode: TEzDrawMode );
begin
  Draw( Grapher, Canvas, Clip, IDENTITY_MATRIX2D, DrawMode );
end;
{$ENDIF}

procedure TEzSymbol.Draw( Grapher: TEzGrapher;
                          Canvas: TCanvas;
                          const Clip: TEzRect;
                          const Matrix: TEzMatrix;
                          DrawMode: TEzDrawMode; Data: Pointer = nil);
var
  Entity: TEzEntity;
  OldBox: TEzRect;
  I, Cnt: Integer;
begin
  Cnt := Pred(FEntities.Count);
  for I := 0 to Cnt do
  begin
    Entity := TEzEntity(FEntities[I]);
    OldBox := Entity.FBox;
    Entity.SetTransformMatrix(Matrix);
    if Entity.EntityID = idPersistBitmap then
      with TEzPersistBitmap(Entity) do
        Transparent := True;

    Entity.Draw(Grapher, Canvas, Clip, DrawMode);

    { restore original }
    Entity.SetTransformMatrix(IDENTITY_MATRIX2D);
    Entity.FBox := OldBox;
  end;
end;

{$IFDEF BCB}
Procedure TEzSymbol.DrawVectorDefault( V: TEzVector;
  Const PenStyle: TEzPenStyle; Grapher: TEzGrapher;
  Canvas: TCanvas; Const Clip: TEzRect; DrawMode: TEzDrawMode );
Begin
  DrawVector( V, Penstyle, Grapher, Canvas, Clip, IDENTITY_MATRIX2D, DrawMode);
End;
{$ENDIF}

Procedure TEzSymbol.DrawVector( V: TEzVector;
                                Const PenStyle: TEzPenStyle;
                                Grapher: TEzGrapher;
                                Canvas: TCanvas;
                                Const Clip: TEzRect;
                                Const Matrix: TEzMatrix;
                                DrawMode: TEzDrawMode );
Var
  I, J, N, Idx1, Idx2, Cnt: Integer;
  Box: TEzRect;
  SymbolWidth, Scale, AcumX: Double;
  SegmDist, SegmAngle, ResidualDist: Double;
  p1, p2, TmpPt1, TmpPt2: TEzPoint;
  TmpV: TEzVector;
  M, M1, M2: TEzMatrix;
  Entity: TEzEntity;
  APenStyle: TEzPenStyle;
Begin
  n := 0;
  If V.Parts.Count < 2 Then
  Begin
    Idx1 := 0;
    Idx2 := V.Count - 1;
  End
  Else
  Begin
    Idx1 := V.Parts[n];
    Idx2 := V.Parts[n + 1] - 1;
  End;

  Box := FExtension;
  APenStyle:= PenStyle;
  If APenStyle.Scale <= 0 Then
    Scale := 1
  Else
    Scale := APenStyle.Scale;
  APenStyle.Width:= 0;
  SymbolWidth := ( Box.Emax.X - Box.Emin.X ) * Scale;
  TmpV := TEzVector.Create( 2 );
  Try
    Repeat
      For I := Idx1 To Idx2 - 1 Do
      Begin
        TmpPt1 := TransformPoint2d( V[I], Matrix );
        TmpPt2 := TransformPoint2d( V[I + 1], Matrix );
        SegmDist := Dist2d( TmpPt1, TmpPt2 );
        SegmAngle := Angle2d( TmpPt1, TmpPt2 );
        N := trunc( SegmDist / SymbolWidth );
        If N = 0 Then
        Begin
          // not enough space for drawing the line type
          TmpV[0] := TmpPt1;
          TmpV[1] := TmpPt2;

          TmpV.DrawOpened( Canvas, Clip, TmpV.Extension, Grapher, APenStyle,
                           IDENTITY_MATRIX2D, DrawMode );
        End
        Else
        Begin
          ResidualDist := ( SegmDist - SymbolWidth * N ) / 2;
          p1 := TmpPt1;
          p2 := Point2d( p1.X + SegmDist, p1.Y );
          AcumX := 0;
          If ResidualDist > 0 Then
          Begin
            // draw the start segment
            TmpV[0] := p1;
            TmpV[1] := Point2d( p1.X + ResidualDist, p1.y );
            M1 := Rotate2d( SegmAngle, p1 );
            TmpV.DrawOpened( Canvas,
                             Clip,
                             TmpV.Extension,
                             Grapher,
                             APenStyle,
                             M1,
                             DrawMode );
            // draw the finish segment
            TmpV[0] := Point2d( p2.X - ResidualDist, p1.y );
            TmpV[1] := p2;

            TmpV.DrawOpened( Canvas, Clip, TmpV.Extension, Grapher, APenStyle,
                             M1, DrawMode );
            AcumX := AcumX + ResidualDist;
          End;
          Cnt := Pred(FEntities.Count);
          For J := 0 To Cnt Do
          Begin
            Entity := TEzEntity( FEntities[J] );
            If Entity Is TEzFittedVectorText Then
              TEzFittedVectorText( Entity ).FontColor := APenStyle.Color
            Else If Entity Is TEzJustifVectorText Then
              TEzJustifVectorText( Entity ).FontColor := APenStyle.Color
            Else If Entity Is TEzOpenedEntity Then
              TEzOpenedEntity( Entity ).Pentool.FPenStyle := APenStyle
            Else If Entity Is TEzPointEntity Then
            Begin
              TEzPointEntity( Entity ).Color := APenStyle.Color;
              TEzPointEntity( Entity ).PointShape := psPoint;
            End;
          End;
          While N > 0 Do
          Begin
            { move the centroid of the symbol to (0,0) then translate to center
              of next segment }
            TmpPt1 := TransformPoint2d( Point2d( p1.X + AcumX + SymbolWidth / 2, p1.Y ),
              Rotate2d( SegmAngle, p1 ) );
            M1 := Translate2d( -FCentroid.X + TmpPt1.X, -FCentroid.Y + TmpPt1.Y );
            M2 := Scale2d( Scale, Scale, FCentroid );
            M := MultiplyMatrix2d( M1, M2 );
            If SegmAngle <> 0 Then
              M := MultiplyMatrix2d( M, Rotate2d( SegmAngle, FCentroid ) );

            Self.Draw( Grapher, Canvas, Clip, M, DrawMode );

            AcumX := AcumX + SymbolWidth;
            Dec( N );
          End;
        End;
      End;

      If V.Parts.Count < 2 Then
        Break;
      Inc( n );
      If n >= V.Parts.Count Then
        Break;
      Idx1 := V.Parts[n];
      If n < V.Parts.Count - 1 Then
        Idx2 := V.Parts[n + 1] - 1
      Else
        Idx2 := V.Count - 1;
    Until False;
  Finally
    TmpV.Free;
  End;
End;

procedure TEzSymbol.SetName(const Value: String);
begin
  FName := StringReplace(Value,#32,'',[rfReplaceAll]);
end;

{TEzSymbols - class implementation}
type

  { The header for the symbol file }
  TEzSymbolsHeader = Packed Record
    HeaderID: smallint;
    VersionNumber: SmallInt;
    RecordCount: Integer;
    Reserved: Array[0..99] Of byte;
  End;

Constructor TEzSymbols.Create;
Begin
  Inherited Create;
  FList := TList.Create;
  FFileName := 'SYMBOLS.EZS';
  AtLeastOne;
End;

Destructor TEzSymbols.Destroy;
Begin
  Clear;
  FList.Free;
  Inherited Destroy;
End;

Procedure TEzSymbols.ExChange( Index1, Index2: Integer );
begin
  if (Index1<0) or (Index1>FList.Count-1) or (Index2<0) or
     (Index2>FList.Count-1) then
  begin
    Exit;
  end;
  FList.Exchange( Index1, Index2 );
end;

procedure TEzSymbols.Up(Index: Integer);
begin
  if (Index <= 0) or (Index > Pred(FList.Count)) then
    Exit;
  Exchange(Index, Pred(Index));
end;

procedure TEzSymbols.Down(Index : Integer);
begin
  if (Index < 0) or (Index >= Pred(FList.Count)) then Exit;
  Exchange(Index, Succ(Index));
end;

procedure TEzSymbols.BringToTop(Index: Integer);
var
  I, Cnt: Integer;
  Temp: Pointer;
begin
  if (Index < 0) or (Index >= Pred(FList.Count)) then
    Exit;
  Temp := FList[Index];
  Cnt := Count - 2;
  for I := Index to Cnt do
    FList[I] := FList[I + 1];
  FList[Count - 1] := Temp;
end;

procedure TEzSymbols.SendToBack( Index: Integer );
var
  I: Integer;
  Temp: Pointer;
begin
  if (Index < 0) or (Index >= Pred(Count)) then
    Exit;
  Temp := FList[Index];
  for I := Index downto 1 do
    FList[I] := FList[Pred(I)];
  FList[0] := Temp;
end;

procedure TEzSymbols.Assign(Symbols: TEzSymbols);
var
  I, Cnt: Integer;
  S: TEzSymbol;
begin
  Clear;
  FFileName := Symbols.FileName;
  FIsLineType := Symbols.IsLineType;
  Cnt := Symbols.Count - 1;
  for I := 0 to Cnt do
  begin
    S := TEzSymbol.Create(Self);
    S.Assign(Symbols[I]);
    Add(S);
  end;
end;

Procedure TEzSymbols.SetIsLineType( Value: Boolean );
Begin
  If Value Then
  Begin
    ChangeFileExt( FFileName, '.EZL' );
    FFileName := 'LINETYPES.EZL';
  End
  Else
  Begin
    ChangeFileExt( FFileName, '.EZS' );
    FFileName := 'SYMBOLS.EZS';
  End;
  FIsLineType := Value;
  Clear;
  AtLeastOne;
End;

Procedure TEzSymbols.AtLeastOne;
Var
  S: TEzSymbol;
  E: TEzEntity;
Begin
  If FList.Count > 0 Then
    exit;
  { ensure at least one entity }
  S := TEzSymbol.Create( Self );
  If Not FIsLineType Then
  Begin
    E := TEzRectangle.CreateEntity( Point2D( 0, 0 ), Point2D( 10, 10 ) );
    TEzRectangle( E ).PenTool.Style := 1;
    TEzRectangle( E ).PenTool.Color := clBlack;
  End
  Else
  Begin
    E := TEzPolyLine.CreateEntity( [Point2D( 0, 0 ), Point2D( 10, 0 )] );
    TEzPolyLine( E ).PenTool.Style := 1;
  End;
  S.Add( E );
  Add( S );
End;

procedure TEzSymbols.Clear;
var
  I, Cnt: Integer;
begin
  Cnt := FList.Count - 1;
  for I := 0 to Cnt do
    TEzSymbol(FList[I]).Free;
  FList.Clear;
end;

Function TEzSymbols.Count: Integer;
Begin
  Result := FList.Count;
End;

procedure TEzSymbols.LoadFromStream( Stream: TStream );
var
  I, Cnt: Integer;
  SymbolsHeader: TEzSymbolsHeader;
Begin
  Clear;
  With Stream Do
  Begin
    Read( SymbolsHeader, SizeOf( TEzSymbolsHeader ) );
    If SymbolsHeader.HeaderID <> SYMBOL_ID Then
      EzGisError( SInvalidSymbolFile );
    If SymbolsHeader.VersionNumber <> SYMBOL_VERSIONNUMBER Then
      EzGisError( SInvalidSymbolVersion );
    Cnt := SymbolsHeader.RecordCount - 1;
    For I := 0 To Cnt Do
      FList.Add( TEzSymbol.CreateFromStream( Self, Stream ) );
  End;
  AtLeastOne;
  if Assigned(FOnChange) then
    FOnChange(Self);
End;

Procedure TEzSymbols.SaveToStream( Stream: TStream );
Var
  I, Cnt: Integer;
  SymbolsHeader: TEzSymbolsHeader;
Begin
  With Stream Do
  Begin
    With SymbolsHeader Do
    Begin
      HeaderID := SYMBOL_ID;
      VersionNumber := SYMBOL_VERSIONNUMBER;
      RecordCount := FList.Count;
    End;
    Write( SymbolsHeader, SizeOf( TEzSymbolsHeader ) );
    Cnt := FList.Count - 1;
    For I := 0 To Cnt Do
      TEzSymbol( FList[I] ).SaveToStream( Stream );
  End;
End;

Function TEzSymbols.Add( Item: TEzSymbol ): Integer;
Begin
  Item.FSymbols := Self;
  Result := FList.Add( Item );
  If Item.Name = '' Then
  Begin
    If FIsLineType Then
      Item.Name := Format( SLinetypeCaption, [Result] )
    Else
      Item.Name := Format( SSymbolCaption, [Result] );
  End;
End;

Procedure TEzSymbols.Delete( Index: Integer );
Begin
  If ( Index < 0 ) Or ( Index > Pred(FList.Count) ) Then
    EzGisError( SSymbolOutOfBound );
  TEzSymbol( FList[Index] ).Free;
  FList.Delete( Index );
End;

Function TEzSymbols.Get( Index: Integer ): TEzSymbol;
Begin
  If ( Index < 0 ) Or ( Index > Pred(FList.Count) ) Then
    EzGisError( SSymbolOutOfBound );
  Result := TEzSymbol( FList[Index] );
End;

Function TEzSymbols.IndexOfName( Const Name: String ): Integer;
Var
  I, Cnt: Integer;
Begin
  Result := -1;
  Cnt := FList.Count - 1;
  For i := 0 To Cnt Do
    If AnsiCompareText( TEzSymbol( FList[i] ).Name, Name ) = 0 Then
    Begin
      Result := i;
      Exit;
    End;
End;

Procedure TEzSymbols.LoadFromFile( const FileName: string );
Begin
  Self.FFileName:= FileName;
  Open;
End;

Procedure TEzSymbols.SaveToFile( const FileName: string );
Begin
  Self.FFileName:= FileName;
  Save;
End;

Procedure TEzSymbols.Open;
Var
  Stream: TStream;
Begin
  If ( Length( FFileName ) = 0 ) Or ( Not FileExists( FFilename ) ) Then Exit;
  Stream := TFileStream.Create( FFilename, fmOpenRead Or fmShareDenyNone );
  Try
    LoadFromStream( Stream );
  Finally
    Stream.Free;
  End;
End;

Procedure TEzSymbols.Close;
Begin
  Clear;
End;

Procedure TEzSymbols.Save;
Begin
  If Length( FFileName ) = 0 Then Exit;
  SaveAs( FFileName );
End;

Procedure TEzSymbols.SaveAs( Const Filename: String );
Var
  Stream: TFileStream;
Begin
  Stream := TFileStream.Create( FileName, fmCreate );
  Try
    SaveToStream( Stream );
    FFileName := Filename;
  Finally
    Stream.Free;
  End;
End;

Procedure TEzSymbols.SetActive( Value: Boolean );
Begin
  If FActive = Value Then
    Exit;
  FActive := Value;
  If FActive Then
    Open
  Else
    Close;
End;



{------------------------------------------------------------------------------}
{                  TEzNone                                                   }
{------------------------------------------------------------------------------}

Constructor TEzNone.CreateEntity;
Begin
  Inherited Create( 1, False );
End;

Function TEzNone.GetEntityID: TEzEntityID;
Begin
  result := idNone;
End;

Procedure TEzNone.LoadFromStream( Stream: TStream );
Begin
  With Stream Do
    Read( ID, SizeOf( ID ) );
  FOriginalSize := 0;
End;

Procedure TEzNone.SaveToStream( Stream: TStream );
Begin
  With Stream Do
    Write( ID, SizeOf( ID ) );
  FOriginalSize := 0;
End;

Procedure TEzNone.Draw( Grapher: TEzGrapher; Canvas: TCanvas;
  Const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer = Nil );
Begin
End;

function TEzNone.IsEqualTo(Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean;
begin
  Result:= ( Entity.EntityID = idNone );
end;

Function TEzNone.BasicInfoAsString: string;
Begin
  Result:= sNoneInfo;
End;

{------------------------------------------------------------------------------}
{                  TEzPointEntity                                            }
{------------------------------------------------------------------------------}

Constructor TEzPointEntity.CreateEntity( Const P: TEzPoint; Clr: TColor );
Begin
  Inherited Create( 1, False );
  FColor := Clr;
  FPoints.Add( P );
  FBox.Emin := P;
  FBox.Emax := P;
End;

Function TEzPointEntity.GetEntityID: TEzEntityID;
Begin
  result := idPoint;
End;

{$IFDEF BCB}
function TEzPointEntity.GetColor: TColor;
begin
  Result := FColor;
end;

function TEzPointEntity.GetPointShape: TEzPointShape;
begin
  Result := FPointShape;
end;

function TEzPointEntity.GetSymbolIndex: Integer;
begin
  Result := FSymbolIndex;
end;

procedure TEzPointEntity.SetColor(const Value: TColor);
begin
  FColor := Value;
end;

procedure TEzPointEntity.SetPointShape(const Value: TEzPointShape);
begin
  FPointShape := Value;
end;

procedure TEzPointEntity.SetSymbolIndex(const Value: Integer);
begin
  FSymbolIndex := Value;
end;
{$ENDIF}


Procedure TEzPointEntity.Draw( Grapher: TEzGrapher;
  Canvas: TCanvas; Const Clip: TEzRect;
  DrawMode: TEzDrawMode; Data: Pointer = Nil );
Var
  DrawPt: TEzPoint;
  DevicePt: TPoint;
  Dist: Integer;
Begin
  DrawPt := TransformPoint2D( FPoints[0], GetTransformMatrix );

  If Not IsPointInBox2D( DrawPt, Clip ) Then Exit;

  DevicePt := Grapher.RealToPoint( DrawPt );
  Dist := (Grapher.DpiY Div POINT_WIDTH) + Ez_Preferences.PointEntitySize;
  If DrawMode In [dmRubberPen, dmSelection] Then
  Begin
    Canvas.Pen.Color := Ez_Preferences.SelectionPen.FPenStyle.Color;
    With DevicePt Do
      Canvas.Ellipse( X - Dist, Y - Dist, X + Dist, Y + Dist );
    {With DevicePt Do
      TmpR := Rect( X - ( Dist + 1 ), Y - ( Dist + 1 ), X + ( Dist + 1 ), Y + ( Dist + 1 ) );
    With TmpR Do
      Canvas.Rectangle( Left, Top, Right, Bottom );}
  End;
  Case FPointShape Of
    psEllipse:
      Begin
        Canvas.Pen.Color := FColor;
        With DevicePt Do
          Canvas.Ellipse( X - Dist, Y - Dist, X + Dist, Y + Dist );
      End;
    psPoint:
      With DevicePt Do
        Canvas.Pixels[X, Y] := FColor;
  Else
    Begin
      Canvas.Pen.Color := FColor;
      With DevicePt Do
        Canvas.Ellipse( X - Dist, Y - Dist, X + Dist, Y + Dist );
    End;
  End;
End;

Procedure TEzPointEntity.LoadFromStream( Stream: TStream );
Var
  TmpPt: TEzPoint;
Begin
  FPoints.DisableEvents := true;
  FPoints.Clear;
  With stream Do
  Begin
    Read( ID, sizeof( ID ) );
    Read( TmpPt, SizeOf( TEzPoint ) );
    FPoints.Add( TmpPt );
    Read( FSymbolIndex, SizeOf( FSymbolIndex ) );
    Read( FColor, SizeOf( TColor ) );
  End;
  FPoints.CanGrow := False;
  FPoints.DisableEvents := false;
  FPoints.OnChange := UpdateExtension;
  UpdateExtension;
  FOriginalSize := StorageSize;
End;

Procedure TEzPointEntity.SaveToStream( Stream: TStream );
Var
  TmpPt: TEzPoint;
Begin
  With stream Do
  Begin
    Write( ID, sizeof( ID ) );
    TmpPt := FPoints[0];
    Write( TmpPt, sizeof( TEzPoint ) );
    Write( FSymbolIndex, SizeOf( FSymbolIndex ) );
    Write( FColor, sizeof( TColor ) );
  End;
  FOriginalSize := StorageSize;
End;

function TEzPointEntity.IsEqualTo(Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean;
begin
  Result:= False;
  if ( Entity.EntityID <> idPoint ) Or Not FPoints.IsEqualTo( Entity.Points )
     {$IFDEF FALSE}Or ( IncludeAttribs And
       ( ( FColor <> TEzPointEntity(entity).FColor ) Or
         ( FSymbolIndex <> TEzPointEntity(entity).FSymbolIndex ) Or
         ( FPointShape <> TEzPointEntity(entity).FPointShape ) ) ){$ENDIF} Then Exit;
  Result:= True;
end;

Function TEzPointEntity.AttribsAsString: string;
Begin
  Result:= Format(sPenInfo, [1,Color,0.0] );
End;

Function TEzPointEntity.BasicInfoAsString: string;
Begin
  Result:= Format(sPointInfo, [FPoints.AsString]);
End;

{------------------------------------------------------------------------------}
{                  TEzPlace                                                  }
{------------------------------------------------------------------------------}

Constructor TEzPlace.CreateEntity( Const Pt: TEzPoint );
Begin
  Inherited Create( 1, False );
  FPoints.Add( Pt );
End;

Destructor TEzPlace.Destroy;
Begin
  FSymbolTool.Free;
  Inherited Destroy;
End;

procedure TEzPlace.Initialize;
begin
  SymbolTool.Assign(Ez_Preferences.DefSymbolStyle );
end;

Function TEzPlace.GetEntityID: TEzEntityID;
Begin
  result := idPlace;
End;

{$IFDEF BCB}
function TEzPlace.GetText: String;
begin
  Result := FText;
end;

procedure TEzPlace.SetText(const Value: String);
begin
  FText := Value;
end;
{$ENDIF}

Function TEzPlace.GetSymbolTool: TEzSymbolTool;
Begin
  If FSymbolTool = Nil Then
    FSymbolTool := TEzSymbolTool.Create;
  result := FSymbolTool;
End;

Procedure TEzPlace.SetSymbolTool( Value: TEzSymbolTool );
Begin
  FSymbolTool.Assign( Value );
End;

function TEzPlace.StorageSize: Integer;
begin
  Result:= inherited StorageSize + Length(FText);
end;

Procedure TEzPlace.LoadFromStream( Stream: TStream );
Begin
  If FSymbolTool = Nil Then
    FSymbolTool := TEzSymbolTool.Create;
  FPoints.DisableEvents := true;
  Inherited LoadFromStream( Stream ); // read ID and points
  FSymbolTool.LoadFromStream( stream );
  FText := EzReadStrFromStream( stream );
  FPoints.DisableEvents := false;
  FPoints.CanGrow := false;
  FPoints.OnChange := UpdateExtension;
  FOriginalSize := StorageSize;
  UpdateExtension;
End;

Procedure TEzPlace.SaveToStream( Stream: TStream );
Begin
  Inherited SaveToStream( stream ); // save ID and points
  FSymbolTool.SaveToStream( stream );
  EzWriteStrToStream( FText, stream );
  FOriginalSize := StorageSize;
End;

function TEzPlace.CalcBoundingBox: TEzRect;
var
  TmpPt: TEzPoint;
  halfSize: Double;
begin
  TmpPt:= FPoints[0];
  halfSize:= FSymbolTool.FSymbolStyle.Height / 2;
  Result:= Rect2d( TmpPt.X - halfSize, TmpPt.Y - halfSize,
                   TmpPt.X + halfSize, TmpPt.Y + halfSize );
end;

procedure TEzPlace.MoveAndRotateControlPts(var MovePt, RotatePt: TEzPoint; Grapher: TEzGrapher);
Var
  M: TEzMatrix;
  TmpBox: TEzRect;
Begin
  TmpBox:= CalcBoundingBox;
  If Not EqualPoint2d(Ez_Preferences.GRotatePoint, INVALID_POINT) Then
  Begin
    MovePt:= Ez_Preferences.GRotatePoint;
  End Else
  Begin
    MovePt.X := ( TmpBox.X1 + TmpBox.X2 ) / 2;
    MovePt.Y := ( TmpBox.Y1 + TmpBox.Y2 ) / 2;
  End;
  RotatePt.Y := MovePt.Y;
  If Grapher <> Nil Then
    RotatePt.X := MovePt.X + Grapher.DistToRealX(Grapher.ScreenDpiX div 2)
  Else
    RotatePt.X := MovePt.X + ( dMax( TmpBox.X1, TmpBox.X2 ) - MovePt.X ) * ( 2 / 3 );
  If FSymboltool.FSymbolstyle.Rotangle <> 0 Then
  Begin
    M := Rotate2d( Symboltool.FSymbolStyle.Rotangle, MovePt );
    RotatePt := TransformPoint2d( RotatePt, M );
  End;
end;

function TEzPlace.GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector;
Var
  TmpPt, MovePt, RotatePt: TEzPoint;
  M: TEzMatrix;
  I: Integer;
  TmpBox: TEzRect;
Begin
  if TransfPts then
    Result := TEzVector.Create( 4 )
  else
    Result := TEzVector.Create( 2 );
  { 1
    +----------+
    |          |
    |          |
    |          |
    +----------+
    0
  }
  TmpBox:= CalcBoundingBox;
  TmpPt:= FPoints[0];
  With Result Do
  Begin
    Add( TmpBox.Emin ); // LOWER LEFT
    AddPoint( TmpBox.X1, TmpBox.Y2 ); // UPPER LEFT
    If TransfPts Then
    Begin
      MoveAndRotateControlPts( MovePt, RotatePt, Grapher );
      Add( MovePt );
      Add( RotatePt );
    End;
  End;
  If FSymbolTool.FSymbolStyle.Rotangle <> 0 Then
  Begin
    { Rotate with respect to the centroid }
    M := Rotate2d( FSymbolTool.FSymbolStyle.Rotangle, TmpPt );
    For I := 0 To 1 Do
      Result[I] := TransformPoint2d( Result[I], M );
  End;
end;

function TEzPlace.GetControlPointType(Index: Integer): TEzControlPointType;
begin
  Result := cptNode;
  If Index = 2 Then
    Result := cptMove
  Else If Index = 3 Then
    Result := cptRotate;
end;

procedure TEzPlace.UpdateControlPoint(Index: Integer; const Value: TEzPoint; Grapher: TEzGrapher=Nil);
Var
  theMovePt, theRotatePt: TEzPoint;
  halfSize, phiEnd: Double;
  V: TEzVector;
Begin
  FPoints.DisableEvents := True;
  V := GetControlPoints(True);
  Try
    { 1
      +---------+
      |         |
      |         |
      |         |
      +---------+
      0
    }
    Case Index Of
      1:
        Begin
          SymbolTool.FSymbolStyle.Height := Dist2d(V[0],Value);
          halfSize:= SymbolTool.FSymbolStyle.Height / 2;
          FPoints[0] := Point2d(V[0].X + halfSize, V[0].Y + halfSize);
          if SymbolTool.FSymbolStyle.Rotangle <> 0 then
            FPoints[0] := TransformPoint2d( FPoints[0],
                                            Rotate2d(SymbolTool.FSymbolStyle.Rotangle, V[0]));
        End;
      2: // the move point
        Begin
          // calculate current move point
          FPoints[0] := Value;
        End;
      3: // the rotate point
        Begin
          MoveAndRotateControlPts( theMovePt, theRotatePt, Grapher );
          phiEnd := Angle2d( theMovePt, value );
          SymbolTool.FSymbolStyle.Rotangle := phiEnd;
        End;
    Else
      Exit;
    End;
  Finally
    FPoints.DisableEvents := false;
    V.free;
  End;
end;

Procedure TEzPlace.Draw( Grapher: TEzGrapher;
  Canvas: TCanvas; Const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer = Nil );
Var
  Matrix: TEzMatrix;
  Sx, Tx, Ty, MaxHeight: Double;
  Symbol: TEzSymbol;
  TmpPt: TEzPoint;
  TmpBox: TEzRect;
  TmpDrawMode: TEzDrawMode;
  TmpHeight: Double;
  Ent: TEzEntity;
  Found: Boolean;
  FoundType: TEzEntityID;
  tmp: String;
  I, Wdt, TmpIndex: Integer;
Begin
  With FSymbolTool.FSymbolStyle Do
  Begin
    TmpHeight := Height;
    TmpIndex:= Index;
    if Not((Index >= 0) And (Index <= Ez_Symbols.Count-1)) then TmpIndex:= 0;
    If TmpHeight = 0 Then Exit;
    Symbol := Ez_Symbols[ TmpIndex ];
    if Symbol.Count = 0 then Exit;

    { is there some text to replace ? }
    Found := false;
    Ent := Nil;
    FoundType := idNone;
    If Length( FText ) > 0 Then
    Begin
      For I := 0 To Symbol.Count - 1 Do
      Begin
        Ent := Symbol.Entities[i];
        If Ent.EntityID = idFittedVectText Then
        Begin
          tmp := TEzJustifVectorText( Ent ).Text;
          TEzJustifVectorText( Ent ).Text := FText;
          Found := true;
          Foundtype := Ent.EntityID;
          Break;
        End Else If Ent.EntityID = idJustifVectText Then
        Begin
          tmp := TEzFittedVectorText( Ent ).Text;
          TEzFittedVectorText( Ent ).Text := fText;
          Found := true;
          Foundtype := Ent.EntityID;
          Break;
        End Else If Ent.EntityID = idTrueTypeText Then
        begin
          tmp := TEzTrueTypeText( Ent ).Text;
          TEzTrueTypeText( Ent ).Text := fText;
          Found := true;
          Foundtype := Ent.EntityID;
          Break;
        end;
      End;
    End;

    { Create the translate matrix }
    TmpPt := TransformPoint2D( FPoints[0], Self.GetTransformMatrix );
    { Move the symbol centroid to 0,0 then translate to point of place }
    Tx := -Symbol.Centroid.X + TmpPt.X;
    Ty := -Symbol.Centroid.Y + TmpPt.Y;
    { Create the scale matrix }
    With Symbol.Extension Do
    Begin
      MaxHeight := dMax( Emax.X - Emin.X, Emax.Y - Emin.Y );
      Sx := TmpHeight / MaxHeight;
      //Sy := Sx; //FSize / MaxSize;
    End;

    Matrix := BuildTransformationMatrix( Sx, Sx, Rotangle, Tx, Ty, Symbol.Centroid );

    // check if symbol is visible
    TmpBox := TransformBoundingBox2D( Symbol.Extension, Matrix );
    If Not IsRectVisible( TmpBox, Clip ) Then Exit;
    TmpDrawMode := DrawMode;
    If TmpDrawMode = dmSelection Then
      TmpDrawMode := dmNormal;

    Symbol.Draw( Grapher, Canvas, Clip, Matrix, TmpDrawMode );

    { Draw a small rectangle if selected }
    If (DrawMode = dmSelection) and (Grapher.Device = adScreen) Then
    Begin
      //Canvas.Brush.Color := clGray;
      Canvas.Brush.Style := bsClear;
      Canvas.Pen.Style := psSolid;
      Canvas.Pen.Color := clRed;
      Wdt := Ez_Preferences.ControlPointsWidth Div 2;
      with Grapher.RealToPoint( FPoints[0] ) do
        Canvas.Rectangle( X - Wdt, Y - Wdt, X + Wdt, Y + Wdt );
    End;

    If Found Then
    Begin
      If FoundType = idJustifVectText Then
        TEzJustifVectorText( Ent ).Text := tmp
      Else If FoundType = idFittedVectText Then
        TEzFittedVectorText( Ent ).Text := tmp
      Else If FoundType = idTrueTypeText Then
        TEzTrueTypeText( Ent ).Text := tmp;
    End;
  End;
End;

Function TEzPlace.PointCode( Const Pt: TEzPoint; Const Aperture: Double; Var
  Distance: Double; SelectPickingInside: Boolean; UseDrawPoints: Boolean = True ): Integer;
Begin
  Result := PICKED_NONE;
  If IsPointInBox2D( Pt, FBox ) Then
  Begin
    Distance := 0;
    Result := PICKED_INTERIOR;
  End;
End;

Procedure TEzPlace.UpdateExtension;
Var
  halfSize: Double;
  M: TEzMatrix;
Begin
  If FPoints.Count = 0 Then Exit;
  halfSize := SymbolTool.FSymbolStyle.Height / 2;
  FBox := Rect2D( FPoints[0].X - halfSize, FPoints[0].Y - halfSize,
    FPoints[0].X + halfSize, FPoints[0].Y + halfSize );
  with SymbolTool.FSymbolStyle do
    if Rotangle <> 0 then
    begin
      M:= Rotate2d(Rotangle, FPoints[0]);
      matrix3x3PreMultiply( self.GetTransformMatrix, M );
    end else
      M:= Self.GetTransformMatrix;
  FBox := TransformBoundingBox2D( FBox, M );
End;


function TEzPlace.IsEqualTo(Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean;
begin
  Result:= False;
  if ( Entity.EntityID <> idPlace ) Or Not FPoints.IsEqualTo( Entity.Points )
      {$IFDEF FALSE}Or
      ( IncludeAttribs And
        ( Not CompareMem( @FSymbolTool.FSymbolStyle,
                          @TEzPlace(Entity).FSymbolTool.FSymbolStyle,
                          SizeOf( TEzSymbolStyle ) ) Or
          ( FText <> TEzPlace(Entity).FText ) ) ){$ENDIF} Then Exit;
  Result:= True;
end;

Function TEzPlace.BasicInfoAsString: string;
Begin
  Result:= Format(SPlaceInfo, [FPoints.AsString,FText]);
End;

Function TEzPlace.AttribsAsString: string;
Begin
  with Symboltool do
    Result:= Format(sSymbolInfo, [Index,RadToDeg(Rotangle),Height]);
End;

{------------------------------------------------------------------------------}
{                  TEzPolyLine                                               }
{------------------------------------------------------------------------------}

Function TEzPolyLine.BasicInfoAsString: string;
Begin
  Result:= Format(sPolylineInfo, [FPoints.AsString]);
End;

Function TEzPolyLine.GetEntityID: TEzEntityID;
Begin
  result := idPolyline;
End;

Procedure TEzPolyLine.LoadFromStream( Stream: TStream );
Begin
  Inherited LoadFromStream( Stream );
  UpdateExtension;
End;

Procedure TEzPolyLine.UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil );
Var
  M: TEzMatrix;
  MovePt, RotatePt: TEzPoint;
  phiStart, phiEnd: Double;
  I, Cnt: Integer;
Begin
  FPoints.DisableEvents := true;
  Try
    If (Index >= 0) And (Index <= Pred(FPoints.Count)) Then
      FPoints[Index] := Value
    Else If Index = FPoints.Count Then
    Begin
      MoveAndRotateControlPts( MovePt, RotatePt, Grapher );
      M := Translate2d( Value.X - MovePt.X, Value.Y - MovePt.Y );
      Cnt := FPoints.Count - 1;
      For I := 0 To Cnt Do
        FPoints[I] := TransformPoint2d( FPoints[I], M );
    End
    Else If Index = FPoints.Count + 1 Then
    Begin
      MoveAndRotateControlPts( MovePt, RotatePt, Grapher );
      phiStart := Angle2D( RotatePt, MovePt );
      phiEnd := Angle2d( value, MovePt );
      M := Rotate2d( phiEnd - phiStart, MovePt );
      Cnt := FPoints.Count - 1;
      For I := 0 To Cnt Do
        FPoints[I] := TransformPoint2d( FPoints[I], M );
    End;
  Finally
    FPoints.DisableEvents := false;
  End;
End;

{------------------------------------------------------------------------------}
{                  TEzPolygon                                                }
{------------------------------------------------------------------------------}

Function TEzPolygon.BasicInfoAsString: string;
Begin
  Result:= Format(sPolygonInfo, [FPoints.AsString]);
End;

Function TEzPolygon.GetEntityID: TEzEntityID;
Begin
  result := idPolygon;
End;

Procedure TEzPolygon.LoadFromStream( Stream: TStream );
Begin
  Inherited LoadFromStream( Stream );
  UpdateExtension;
End;

Function TEzPolygon.IsClosed: Boolean;
Begin
  result := True;
End;

Procedure TEzPolygon.UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil );
Var
  IsEqual: Boolean;
  M: TEzMatrix;
  MovePt, RotatePt: TEzPoint;
  phiStart, phiEnd: Double;
  I, Cnt: Integer;
Begin
  FPoints.DisableEvents := true;
  Try
    If Index = 0 Then
    Begin
      { if point 0 or last point is moved, then set the first or last point
        to the same location because it must be a closed polygon }
      IsEqual := EqualPoint2D( FPoints[0], FPoints[FPoints.Count - 1] );
      FPoints[0] := Value;
      If IsEqual Then
        FPoints[FPoints.Count - 1] := Value;
    End
    Else If Index = FPoints.Count - 1 Then
    Begin
      IsEqual := EqualPoint2D( FPoints[0], FPoints[FPoints.Count - 1] );
      FPoints[FPoints.Count - 1] := Value;
      If IsEqual Then
        FPoints[0] := Value;
    End
    Else If ( Index > 0 ) And ( Index <= FPoints.Count - 2 ) Then
      FPoints[Index] := Value
    Else If Index = FPoints.Count Then
    Begin
      MoveAndRotateControlPts( MovePt, RotatePt, Grapher );
      M := Translate2d( Value.X - MovePt.X, Value.Y - MovePt.Y );
      Cnt := FPoints.Count - 1;
      For I := 0 To Cnt Do
        FPoints[I] := TransformPoint2d( FPoints[I], M );
    End
    Else If Index = FPoints.Count + 1 Then
    Begin
      MoveAndRotateControlPts( MovePt, RotatePt, Grapher );
      phiStart := Angle2D( RotatePt, MovePt );
      phiEnd := Angle2d( value, MovePt );
      M := Rotate2d( phiEnd - phiStart, MovePt );
      Cnt := FPoints.Count - 1;
      For I := 0 To Cnt Do
        FPoints[I] := TransformPoint2d( FPoints[I], M );
    End;
  Finally
    FPoints.DisableEvents := false;
  End;
End;

{------------------------------------------------------------------------------}
{                  TEzRectangle                                              }
{------------------------------------------------------------------------------}

Constructor TEzRectangle.CreateEntity( Const P1, P2: TEzPoint );
var
  Box: TEzRect;
begin
  Inherited CreateEntity( [P1, P2], False );
  { reorder the points }
  Box.Emin:= P1;
  Box.Emax:= P2;
  Box:= ReorderRect2d(Box);
  BeginUpdate;
  FPoints[0]:= Box.Emin;
  FPoints[1]:= Box.Emax;
  EndUpdate;
End;

Destructor TEzRectangle.Destroy;
Begin
  If FPolyPoints <> Nil Then
    FPolyPoints.Free;
  Inherited Destroy;
End;

Function TEzRectangle.BasicInfoAsString: string;
Begin
  Result:= Format(sRectangleInfo, [FPoints.AsString,RadToDeg(FRotangle)]);
End;

Function TEzRectangle.GetEntityID: TEzEntityID;
Begin
  result := idRectangle;
End;

Procedure TEzRectangle.Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
  DrawMode: TEzDrawMode; Data: Pointer = Nil );
var
  OldStyle: TPenStyle;
begin
  Oldstyle:= Canvas.Pen.Style;
  If (DrawMode = dmRubberPen) And (ID <> -2) then
      Canvas.Pen.Style:= psDot;
  inherited Draw( Grapher, Canvas, Clip, DrawMode, Data );
  If (DrawMode = dmRubberPen) And (ID <> -2) then
    Canvas.Pen.Style:= Oldstyle;
end;

{$IFDEF BCB}
function TEzRectangle.GetRotangle: Double;
begin
  Result := FRotangle;
end;
{$ENDIF}

procedure TEzRectangle.ApplyTransform;
var
  I, Cnt: Integer;
  CX, CY, SemiDistX, SemiDistY: Double;
begin
  Cnt := FPolyPoints.Count - 1;
  For I := 0 To Cnt Do
    FPolyPoints[I] := TransformPoint2d( FPolyPoints[I], Self.GetTransformMatrix );
  { calculate centroid of FPolyPoints }
  Centroid( CX, CY );
  FRotangle:=  Angle2d(FPolyPoints[0], FPolyPoints[1]);
  SemiDistX := Dist2d( FPolyPoints[0], FPolyPoints[1]) / 2;
  SemiDistY := Dist2D( FPolyPoints[0], FPolyPoints[3]) / 2;
  BeginUpdate;
  FPoints[0]:= Point2d(CX - SemiDistX, CY - SemiDistY);
  FPoints[1]:= Point2d(CX + SemiDistX, CY + SemiDistY);
  Self.SetTransformMatrix( IDENTITY_MATRIX2D );
  EndUpdate;
end;

Procedure TEzRectangle.SetRotangle( Value: Double );
Begin
  FRotangle := Value;
  UpdateExtension;
End;

Procedure TEzRectangle.MoveAndRotateControlPts( Var MovePt, RotatePt: TEzPoint; Grapher: TEzGrapher );
Var
  M: TEzMatrix;
Begin
  If Not EqualPoint2d(Ez_Preferences.GRotatePoint, INVALID_POINT) Then
  Begin
    MovePt:= Ez_Preferences.GRotatePoint;
  End Else
  Begin
    MovePt.X := ( FPoints[0].X + FPoints[1].X ) / 2;
    MovePt.Y := ( FPoints[0].Y + FPoints[1].Y ) / 2;
  End;
  RotatePt.Y := MovePt.Y;
  If Grapher <> Nil Then
    RotatePt.X := MovePt.X + Grapher.DistToRealX( Grapher.ScreenDpiX div 2 )
  Else
    RotatePt.X := MovePt.X + ( dMax( FPoints[0].X, FPoints[1].X ) - MovePt.X ) * ( 2 / 3 );
  If FRotangle <> 0 Then
  Begin
    M := Rotate2d( FRotangle, MovePt );
    RotatePt := TransformPoint2d( RotatePt, M );
  End;
End;

Function TEzRectangle.GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector;
Var
  MovePt, RotatePt: TEzPoint;
  V: TEzVector;
Begin
  Result := TEzVector.Create( 10 );
  { 6 (3)           5              4  (2)
    +---------------+---------------+
    |                               |
  7 +                               + 3
    | (4)                           |
    +---------------+---------------+
    0 (0)           1               2 (1)
  }
  If FPolyPoints = Nil Then
    MakePolyPoints;
  V := FPolyPoints;
  With Result Do
  Begin
    Add( V[0] ); // LOWER LEFT
    Add( Point2d( ( V[0].X + V[1].X ) / 2, ( V[0].Y + V[1].Y ) / 2 ) ); // MIDDLE BOTTOM
    Add( V[1] ); // LOWER RIGHT
    Add( Point2d( ( V[1].X + V[2].X ) / 2, ( V[1].Y + V[2].Y ) / 2 ) ); // MIDDLE RIGHT
    Add( V[2] ); // UPPER RIGHT
    Add( Point2d( ( V[2].X + V[3].X ) / 2, ( V[2].Y + V[3].Y ) / 2 ) ); // MIDDLE TOP
    Add( V[3] ); // UPPER LEFT
    Add( Point2d( ( V[0].X + V[3].X ) / 2, ( V[0].Y + V[3].Y ) / 2 ) ); // MIDDLE LEFT
    if TransfPts then
    begin
      MoveAndRotateControlPts( MovePt, RotatePt, Grapher );
      Add( MovePt );
      Add( RotatePt );
    end;
  End;
End;

Function TEzRectangle.GetControlPointType( Index: Integer ): TEzControlPointType;
Begin
  Result := cptNode;
  If Index = 8 Then
    Result := cptMove
  Else If Index = 9 Then
    Result := cptRotate;
End;

Procedure TEzRectangle.UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil );
Var
  M: TEzMatrix;
  theMovePt, theRotatePt: TEzPoint;
  I, Cnt: Integer;
  phiStart, phiEnd, CX, CY, DistX, DistY: Double;
  V: TEzVector;
  Bx: TEzRect;
Begin
  FPoints.DisableEvents := True;
  Try
    { 6                5                  4
      +---------------+-------------------+
      |                                   |
    7 +                                   + 3
      |                                   |
      +---------------+-------------------+
      0               1                   2
    }
    V := FPolyPoints;
    Case Index Of
      0: // calculate the point
        Begin
          V[0] := Value;
          V[4] := Value;
          V[3] := Perpend( Value, V[2], V[3] );
          V[1] := Perpend( Value, V[1], V[2] );
        End;
      1:
        Begin
          V[0] := Perpend( Value, V[0], V[3] );
          V[4] := V[0];
          V[1] := Perpend( Value, V[1], V[2] );
        End;
      2:
        Begin
          V[1] := Value;
          V[2] := Perpend( Value, V[2], V[3] );
          V[0] := Perpend( Value, V[0], V[3] );
          V[4] := V[0];
        End;
      3:
        Begin
          V[1] := Perpend( Value, V[0], V[1] );
          V[2] := Perpend( Value, V[2], V[3] );
        End;
      4:
        Begin
          V[2] := Value;
          V[1] := Perpend( Value, V[0], V[1] );
          V[3] := Perpend( Value, V[0], V[3] );
        End;
      5:
        Begin
          V[2] := Perpend( Value, V[1], V[2] );
          V[3] := Perpend( Value, V[0], V[3] );
        End;
      6:
        Begin
          V[3] := Value;
          V[0] := Perpend( Value, V[0], V[1] );
          V[4] := V[0];
          V[2] := Perpend( Value, V[1], V[2] );
        End;
      7:
        Begin
          V[3] := Perpend( Value, V[2], V[3] );
          V[0] := Perpend( Value, V[0], V[1] );
          V[4] := V[0];
        End;
      8: // the move point
        Begin
          // calculate current move point
          MoveAndRotateControlPts( theMovePt, theRotatePt, Grapher );
          M := Translate2d( Value.X - theMovePt.X, Value.Y - theMovePt.Y );
          Cnt := V.Count - 1;
          For I := 0 To Cnt Do
            V[I] := TransformPoint2d( V[I], M );
        End;
      9: // the rotate point
        Begin
          MoveAndRotateControlPts( theMovePt, theRotatePt, Grapher );
          phiStart := Angle2D( theRotatePt, theMovePt );
          phiEnd := Angle2d( value, theMovePt );
          M := Rotate2d( phiEnd - phiStart, theMovePt );
          Cnt := V.Count - 1;
          For I := 0 To Cnt Do
            V[I] := TransformPoint2d( V[I], M );
        End;
    End;
    FRotangle := Angle2d( V[0], V[1] );
    Bx := V.Extension;
    CX := ( Bx.Emin.X + Bx.Emax.X ) / 2;
    CY := ( Bx.Emin.Y + Bx.Emax.Y ) / 2;
    DistX := Dist2d( V[0], V[1] );
    DistY := Dist2d( V[0], V[3] );
    FPoints[0] := Point2d( CX - DistX / 2, CY - DistY / 2 );
    FPoints[1] := Point2d( CX + DistX / 2, CY + DistY / 2 );
  Finally
    FPoints.DisableEvents := false;
  End;
End;

Procedure TEzRectangle.MakePolyPoints;
Var
  Cx, Cy: Double;
  M: TEzMatrix;
  I, Cnt: Integer;
  TmpR: TEzRect;
Begin
  If FPolyPoints = Nil Then
    FPolyPoints := TEzVector.Create( 5 )
  Else
    FPolyPoints.Clear;
  TmpR.Emin := FPoints[0];
  TmpR.Emax := FPoints[1];
  TmpR := ReorderRect2D( TmpR );
  With FPolyPoints Do
  Begin
    { 3                2
      +---------------+
      |               |
      |               |
      |               |
    4 +---------------+
      0               1
    }
    Add( TmpR.Emin );
    Add( Point2D( TmpR.Emax.X, TmpR.Emin.Y ) );
    Add( TmpR.Emax );
    Add( Point2D( TmpR.Emin.X, TmpR.Emax.Y ) );
    Add( TmpR.Emin );
  End;
  If FRotangle <> 0 Then
  Begin
    { rotate with respect to the centroid }
    CX := ( FPoints[0].X + FPoints[1].X ) / 2;
    CY := ( FPoints[0].Y + FPoints[1].Y ) / 2;
    M := Rotate2d( FRotangle, Point2d( CX, CY ) );
    Cnt := FPolyPoints.Count - 1;
    For I := 0 To Cnt Do
      FPolyPoints[I] := TransformPoint2d( FPolyPoints[I], M );
  End;
End;

Procedure TEzRectangle.LoadFromStream( Stream: TStream );
Begin
  Inherited LoadFromStream( Stream );
  stream.Read( FRotangle, sizeof( FRotangle ) );
  FPoints.CanGrow := False;
  UpdateExtension;
End;

Procedure TEzRectangle.SaveToStream( Stream: TStream );
Begin
  Inherited SaveToStream( Stream );
  Stream.Write( FRotangle, sizeof( FRotangle ) );
End;

Procedure TEzRectangle.UpdateExtension;
Begin
  If FPoints.Count < 2 Then Exit;
  MakePolyPoints;
  FBox := ReorderRect2D( TransformBoundingBox2D( FPolyPoints.Extension, Self.GetTransformMatrix ) );
End;

Function TEzRectangle.GetDrawPoints: TEzVector;
Begin
  If FPolyPoints = Nil Then MakePolyPoints;
  Result := FPolyPoints;
End;

function TEzRectangle.IsEqualTo(Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean;
begin
  Result:= False;
  if Not ( Entity.EntityID = idRectangle ) Or
    ( Inherited IsEqualTo( Entity, IncludeAttribs ) = False )
    {$IFDEF FALSE} Or
    ( IncludeAttribs And ( FRotangle <> TEzRectangle(Entity).FRotangle ) ){$ENDIF} Then Exit;
  Result:= True;
end;

{------------------------------------------------------------------------------}
{                  TEzArc                                                    }
{------------------------------------------------------------------------------}

Constructor TEzArc.CreateEntity( Const P1, P2, P3: TEzPoint );
Begin
  (* circular arcs are drawn by defining 3 points *)
  Inherited CreateEntity( [P1, P2, p3], False );
End;

Destructor TEzArc.Destroy;
Begin
  If FCurvePoints <> Nil Then
    FCurvePoints.Free;
  Inherited Destroy;
End;

procedure TEzArc.Initialize;
begin
  inherited;
  FPointsInCurve := Ez_Preferences.ArcSegs;
  If FPointsInCurve < 50 Then
    FPointsInCurve := 50;
  FCurvePoints := TEzVector.Create( FPointsInCurve );
end;

Function TEzArc.BasicInfoAsString: string;
begin
  Result:= Format(sArcInfo, [FPoints.AsString]);
end;

Function TEzArc.GetEntityID: TEzEntityID;
Begin
  result := idArc;
End;

{$IFDEF BCB}
function TEzArc.GetCenterX: Double;
begin
  Result := FCenterX;
end;

function TEzArc.GetCenterY: Double;
begin
  Result := FCenterY;
end;

function TEzArc.GetPointsInCurve: Word;
begin
  Result := FPointsInCurve;
end;

function TEzArc.GetRadius: Double;
begin
  Result := FRadius;
end;

procedure TEzArc.SetCenterX(const Value: Double);
begin
  FCenterX := Value;
end;

procedure TEzArc.SetCenterY(const Value: Double);
begin
  FCenterY := Value;
end;

procedure TEzArc.SetRadius(const Value: Double);
begin
 FRadius := Value;
end;
{$ENDIF}

Procedure TEzArc.LoadFromStream( Stream: TStream );
Begin
  Inherited LoadFromStream( Stream );
  stream.Read( FPointsInCurve, SizeOf( FPointsInCurve ) );
  If FCurvePoints = Nil Then
    FCurvePoints := TEzVector.Create( FPointsInCurve );
  FPoints.CanGrow := false;
  UpdateExtension;
End;

Procedure TEzArc.SaveToStream( Stream: TStream );
Begin
  Inherited SaveToStream( stream );
  stream.Write( FPointsInCurve, SizeOf( FPointsInCurve ) );
End;

Procedure TEzArc.SetPointsInCurve( N: Word );
Begin
  If N <> FPointsInCurve Then
  Begin
    FPointsInCurve := N;
    UpdateExtension;
  End;
End;

Procedure TEzArc.MakeCurvePoints;
Var
  I, Cnt: Integer;
  Delta, CurrAngle, TmpAngle, StartAng, EndAng: Double;
  TmpCenter: TEzPoint;
Begin
  CalcCenterRadius;
  if IsColinear then
  begin
    FCurvePoints.Clear;
    for I:= 0 to FPoints.COunt-1 do
      FCurvePoints.Add( FPoints[I] );
    Exit;
  end;

  TmpCenter := Point2D( FCenterX, FCenterY );
  StartAng := NormalizeAngle( Angle2D( TmpCenter, FPoints[0] ) );
  EndAng := NormalizeAngle( Angle2D( TmpCenter, FPoints[2] ) );

  If IsCounterClockWise( FPoints ) Then
  Begin
    If EndAng > StartAng Then
      Delta := ( EndAng - StartAng ) / ( FPointsInCurve - 1 )
    Else
      Delta := ( TwoPi - ( StartAng - EndAng ) ) / ( FPointsInCurve - 1 );
  End
  Else
  Begin
    If EndAng > StartAng Then
      Delta := ( TwoPi - ( EndAng - StartAng ) ) / ( FPointsInCurve - 1 )
    Else
      Delta := ( StartAng - EndAng ) / ( FPointsInCurve - 1 );
    Delta := -Delta;
  End;
  FCurvePoints.Clear;
  CurrAngle := StartAng;
  Cnt := FPointsInCurve - 1;
  For I := 0 To Cnt Do
  Begin
    TmpAngle := CurrAngle;
    If TmpAngle > TwoPi Then
      TmpAngle := TmpAngle - TwoPi
    Else If TmpAngle < 0 Then
      TmpAngle := TmpAngle + TwoPi;
    FCurvePoints.Add( Point2D( FCenterX + FRadius * Cos( TmpAngle ),
                      FCenterY + FRadius * Sin( TmpAngle ) ) );
    CurrAngle := CurrAngle + Delta
  End;
End;

Procedure TEzArc.Centroid( Var CX, CY: Double );
Begin
  CalcCenterRadius;
  CX:= FCenterX;
  CY:= FCenterY;
End;

Procedure TEzArc.Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
  DrawMode: TEzDrawMode; Data: Pointer = Nil );
var
  RadiusLines: TEzEntity;
  p: TEzPoint;
  Oldstyle: TPenstyle;
  Angle1, Angle2: Double;
begin
  Angle1:= 0;
  Angle2:= 0;
  If Points.Count = 3 then
  begin
    Angle1:= RadToDeg( Angle2d( Points[0], Points[1]) );
    Angle2:= RadToDeg( Angle2d( Points[0], Points[2]) );
  end;
  If (ID<>-2) And (DrawMode = dmRubberPen) And (Points.Count = 3) then
  begin
    // If they are colinar then don't draw.
    If Abs(Angle1 - Angle2)>=0.1 Then
    begin
      p:= Point2d(0,0);
      RadiusLines:= TEzPolyline.CreateEntity( [p,p,p,p] );
      try
        with RadiusLines do
        begin
          BeginUpdate;
          Points[0]:= Point2d( FCenterX, FCenterY );
          Points[1]:= Self.Points[0];
          Points[2]:= Point2d( FCenterX, FCenterY );
          Points[3]:= Self.Points[2];
          Points.Parts.Add( 0 );
          Points.Parts.Add( 2 );
          EndUpdate;
          Oldstyle:= Canvas.Pen.Style;
          Canvas.Pen.Style:= psDot;
          SetTransformMatrix( Self.GetTransformMatrix);
          Draw( Grapher, Canvas, Clip, DrawMode, Data );
          Canvas.Pen.Style:= Oldstyle;
        end;
      finally
        RadiusLines.Free;
      end;
    end;
  end;
  If (Points.Count = 3) And (Abs(Angle1 - Angle2)>=0.1) Then
    inherited Draw( Grapher, Canvas, Clip, DrawMode, Data )
  else
    Points.DrawOpened( Canvas, Clip, FBox, Grapher, Pentool.FPenStyle,
      Self.GetTransformMatrix, DrawMode );
end;

Procedure TEzArc.SetArc( Const CX, CY, R, StartAng, NumRadians: Double; IsCounterClockWise: Boolean );

  Procedure ArcAddPoint( Const ang: Double );
  Begin
    FPoints.Add( Point2D( CX + R * Cos( ang ), CY + R * Sin( ang ) ) );
  End;

Begin
  (* StartAng and EndAng (in radians) always CounterClockWise *)
  FPoints.DisableEvents := True;
  FPoints.Clear;
  If IsCounterClockWise Then
  Begin
    ArcAddPoint( StartAng );
    ArcAddPoint( StartAng + NumRadians / 2 );
    ArcAddPoint( StartAng + NumRadians );
  End
  Else
  Begin
    ArcAddPoint( StartAng );
    ArcAddPoint( StartAng - NumRadians / 2 );
    ArcAddPoint( StartAng - NumRadians );
  End;
  FPoints.DisableEvents := False;
  UpdateExtension;
End;

(* Calculate center of circle and radius*)
Function TEzArc.IsColinear: Boolean;
Var
  A, B, G, aX, aY, bX, bY, cX, cY: Double;
Begin
  Result:= True;
  If FPoints.Count <> 3 Then Exit;
  aX := FPoints[0].X;
  aY := FPoints[0].Y;
  bX := FPoints[1].X;
  bY := FPoints[1].Y;
  cX := FPoints[2].X;
  cY := FPoints[2].Y;
  //if ((bX>aX) and (cX<bX)) or ((bX<aX) and (cX>bX)) then Exit;
  A := bX - aX;
  B := bY - aY;
  G := 2.0 * ( A * ( cY - bY ) - B * ( cX - bX ) );
  Result:= (G = 0); // the points are colinear
End;

Procedure TEzArc.CalcCenterRadius;
Var
  A, B, C, D, E, F, G, aX, aY, bX, bY, cX, cY: Double;
Begin
  FCenterX := 0;
  FCenterY := 0;
  FRadius := 0;
  If FPoints.Count <> 3 Then Exit;
  aX := FPoints[0].X;
  aY := FPoints[0].Y;
  bX := FPoints[1].X;
  bY := FPoints[1].Y;
  cX := FPoints[2].X;
  cY := FPoints[2].Y;
  //if ((bX>aX) and (cX<bX)) or ((bX<aX) and (cX>bX)) then Exit;
  A := bX - aX;
  B := bY - aY;
  C := cX - aX;
  D := cY - aY;
  E := A * ( aX + bX ) + B * ( aY + bY );
  F := C * ( aX + cX ) + D * ( aY + cY );
  G := 2.0 * ( A * ( cY - bY ) - B * ( cX - bX ) );
  If G = 0 Then Exit; // the points are colinear
  // center of the circle
  FCenterX := ( D * E - B * F ) / G;
  FCenterY := ( A * F - C * E ) / G;
  // radius of the circle
  FRadius := Sqrt( Sqr( aX - FCenterX ) + Sqr( aY - FCenterY ) );
End;

Function TEzArc.NormalizeAngle( Const Angle: Double ): Double;
Begin
  Result := Angle;
  If Result < 0 Then
    Result := Result + TwoPi;
End;

Function TEzArc.StartAngle: Double;
Begin
  { start angle is always returned as the angle in counterclockwise rotation }
  CalcCenterRadius;
  If IsCounterClockWise( FPoints ) Then
    Result:= NormalizeAngle( Angle2D( Point2D( FCenterX, FCenterY ), FPoints[0] ) )
  Else
    Result:= NormalizeAngle( Angle2D( Point2D( FCenterX, FCenterY ), FPoints[2] ) );
End;

Function TEzArc.EndAngle: Double;
Begin
  CalcCenterRadius;
  If IsCounterClockWise( FPoints ) Then
    Result:= NormalizeAngle( Angle2D( Point2D( FCenterX, FCenterY ), FPoints[2] ) )
  Else
    Result:= NormalizeAngle( Angle2D( Point2D( FCenterX, FCenterY ), FPoints[0] ) );
End;

Function TEzArc.SweepAngle: Double;
Begin
  Result:= EndAngle - StartAngle;
End;

Procedure TEzArc.UpdateExtension;
Begin
  If FPoints.Count <> 3 Then Exit;
  If FCurvePoints = Nil Then
  Begin
    FPointsInCurve := 50;
    FCurvePoints := TEzVector.Create( FPointsInCurve );
  End;
  MakeCurvePoints;
  FBox := FCurvePoints.Extension;
  FBox := TransformBoundingBox2D( FBox, Self.GetTransformMatrix );
End;

Function TEzArc.GetDrawPoints: TEzVector;
Begin
  Result := FCurvePoints;
End;

procedure TEzArc.MoveAndRotateControlPts(var MovePt, RotatePt: TEzPoint; Grapher: TEzGrapher=Nil);
Begin
  If Not EqualPoint2d(Ez_Preferences.GRotatePoint, INVALID_POINT) Then
  Begin
    MovePt:= Ez_Preferences.GRotatePoint;
  End Else
  Begin
    CalcCenterRadius;
    MovePt:= Point2d( FCenterX, FCenterY );
  End;
  If Grapher <> Nil Then
    RotatePt := Point2d( MovePt.X + Grapher.DistToRealX(Grapher.ScreenDpiX), MovePt.Y )
  Else
    RotatePt := Point2d( MovePt.X + FRadius * (3/4), MovePt.Y );
end;

Function TEzArc.GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector;
Var
  MovePt, RotatePt: TEzPoint;
Begin
  Result := TEzVector.Create( FPoints.Count + 2 );
  Result.Assign( FPoints );
  if TransfPts then
  begin
    MoveAndRotateControlPts( MovePt, RotatePt, Grapher );
    Result.Add( MovePt );
    Result.Add( RotatePt );
  end;
End;

procedure TEzArc.UpdateControlPoint(Index: Integer; const Value: TEzPoint; Grapher: TEzGrapher=Nil);
var
  MovePt, RotatePt: TEzPoint;
  phiStart, phiEnd: Double;
  M: TEzMatrix;
  I, Cnt: Integer;
begin
  if Index <= 2 then
    inherited UpdateControlPoint(Index, Value, Grapher)
  else
  begin
    MoveAndRotateControlPts( MovePt, RotatePt, Grapher );
    if Index = 3 then             // move
    begin
      M := Translate2d( Value.X - MovePt.X, Value.Y - MovePt.Y );
      Cnt := FPoints.Count - 1;
      For I := 0 To Cnt Do
        FPoints[I] := TransformPoint2d( FPoints[I], M );
    end else if Index = 4 then    // rotate
    begin
      phiStart := Angle2D( RotatePt, MovePt );
      phiEnd := Angle2d( value, MovePt );
      M := Rotate2d( phiEnd - phiStart, MovePt );
      Cnt := FPoints.Count - 1;
      For I := 0 To Cnt Do
        FPoints[I] := TransformPoint2d( FPoints[I], M );
    end;
  end;
end;

function TEzArc.IsEqualTo(Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean;
begin
  Result:= False;
  if Not ( Entity.EntityID = idArc ) Or
    ( Inherited IsEqualTo( Entity, IncludeAttribs ) = False )
    {$IFDEF FALSE}Or ( IncludeAttribs And ( ( FCenterX <> TEzArc(Entity).FCenterX ) Or
                           ( FCenterY <> TEzArc(Entity).FCenterY ) Or
                           ( FRadius <> TEzArc(Entity).FRadius ) ) ){$ENDIF} Then Exit;
  Result:= True;
end;
{------------------------------------------------------------------------------}
{                  TEzEllipse                                                }
{------------------------------------------------------------------------------}

Constructor TEzEllipse.CreateEntity( Const P1, P2: TEzPoint );
Begin
  Inherited CreateEntity( [P1, P2], False );
End;

Destructor TEzEllipse.Destroy;
Begin
  If FCurvePoints <> Nil Then
    FCurvePoints.Free;
  Inherited Destroy;
End;

Procedure TEzEllipse.Initialize;
begin
  inherited;
  FPointsInCurve := Ez_Preferences.EllipseSegs;
  If FPointsInCurve < 80 Then
    FPointsInCurve := 80;
  FCurvePoints := TEzVector.Create( FPointsInCurve );
end;

Function TEzEllipse.BasicInfoAsString: string;
Begin
  Result:= Format(sEllipseInfo, [FPoints.AsString,RadToDeg(FRotangle)]);
End;

Function TEzEllipse.GetEntityID: TEzEntityID;
Begin
  result := idEllipse;
End;

{$IFDEF BCB}
function TEzEllipse.GetPointsInCurve: Integer;
begin
  Result := FPointsInCurve;
end;

function TEzEllipse.GetRotangle: Double;
begin
  Result := FRotangle;
end;
{$ENDIF}

procedure TEzEllipse.ApplyTransform;
var
  V: TEzVector;
  I, Cnt: Integer;
  CX, CY, SemiDistX, SemiDistY: Double;
begin
  V:= GetControlPoints(True);
  try
    Cnt := V.Count - 1;
    for I := 0 to Cnt do
      V[I] := TransformPoint2d( V[I], Self.GetTransformMatrix );
    CX:= V[8].X;
    CY:= V[8].Y;
    SemiDistX := Dist2D(V[0], V[1]);
    SemiDistY := Dist2D(V[0], V[7]);
    FRotangle:= Angle2d(V[0], V[1]);
    BeginUpdate;
    FPoints[0]:= Point2d(CX - SemiDistX, CY - SemiDistY);
    FPoints[1]:= Point2d(CX + SemiDistX, CY + SemiDistY);
    Self.SetTransformMatrix( IDENTITY_MATRIX2D );
    EndUpdate;
  finally
    V.Free;
  end;
end;

Procedure TEzEllipse.SetRotangle( Const Value: Double );
Begin
  FRotangle := Value;
  UpdateExtension;
End;

Procedure TEzEllipse.MoveAndRotateControlPts( Var MovePt, RotatePt: TEzPoint; Grapher: TEzGrapher );
Begin
  If Not EqualPoint2d(Ez_Preferences.GRotatePoint, INVALID_POINT) Then
  Begin
    MovePt:= Ez_Preferences.GRotatePoint;
  End Else
  Begin
    MovePt.X := ( FPoints[0].X + FPoints[1].X ) / 2;
    MovePt.Y := ( FPoints[0].Y + FPoints[1].Y ) / 2;
  End;
  RotatePt.Y := MovePt.Y;
  If Grapher <> Nil Then
    RotatePt.X := MovePt.X + Grapher.DistToRealX( Grapher.ScreenDpiX div 2 )
  Else
    RotatePt.X := MovePt.X + ( dMax( FPoints[0].X, FPoints[1].X ) - MovePt.X ) * ( 2 / 3 );
End;

Function TEzEllipse.GetControlPointType( Index: Integer ): TEzControlPointType;
Begin
  Result := cptNode;
  If Index = 8 Then
    Result := cptMove
  Else If Index = 9 Then
    Result := cptRotate;
End;

Function TEzEllipse.GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector;
Var
  TmpR: TEzRect;
  M: TEzMatrix;
  I, Cnt: Integer;
  MovePt, RotatePt: TEzPoint;
Begin
  Result := TEzVector.Create( 8 );
  TmpR.Emin := FPoints[0];
  TmpR.Emax := FPoints[1];
  TmpR := ReorderRect2D( TmpR );
  With Result Do
  Begin
    Add( TmpR.Emin ); // LOWER LEFT
    AddPoint( ( TmpR.Emin.X + TmpR.Emax.X ) / 2, TmpR.Emin.Y ); // MIDDLE BOTTOM
    AddPoint( TmpR.Emax.X, TmpR.Emin.Y ); // LOWER RIGHT
    AddPoint( TmpR.Emax.X, ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2 ); // MIDDLE RIGHT
    Add( TmpR.Emax ); // UPPER RIGHT
    AddPoint( ( TmpR.Emin.X + TmpR.Emax.X ) / 2, TmpR.Emax.Y ); // MIDDLE TOP
    AddPoint( TmpR.Emin.X, TmpR.Emax.Y ); // UPPER LEFT
    AddPoint( TmpR.Emin.X, ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2 ); // MIDDLE LEFT
    if TransfPts then
    begin
      MoveAndRotateControlPts( MovePt, RotatePt, Grapher );
      Add( MovePt );
      Add( RotatePt );
    end;
  End;
  If FRotangle <> 0 Then
  Begin
    M := Rotate2d( FRotangle, MovePt );
    Cnt := Result.Count - 1;
    For I := 0 To Cnt Do
      Result[I] := TransformPoint2d( Result[I], M );
  End;
End;

Procedure TEzEllipse.UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil );
Var
  M: TEzMatrix;
  theMovePt, theRotatePt: TEzPoint;
  I, Cnt: Integer;
  phiStart, phiEnd, CX, CY, DistX, DistY: Double;
  V: TEzVector;
  Bx, TmpR: TEzRect;
Begin
  FPoints.DisableEvents := True;
  V := TEzVector.Create( 5 );
  Try
    { 6                5                  4
      +---------------+-------------------+
      |                                   |
    7 +                                   + 3
      |                                   |
      +---------------+-------------------+
      0               1                   2
    }
    TmpR.Emin := FPoints[0];
    TmpR.Emax := FPoints[1];
    TmpR := ReorderRect2D( TmpR );
    With V Do
    Begin
      { 3                2
        +---------------+
        |               |
        |               |
        |               |
      4 +---------------+
        0               1
      }
      Add( TmpR.Emin );
      Add( Point2D( TmpR.Emax.X, TmpR.Emin.Y ) );
      Add( TmpR.Emax );
      Add( Point2D( TmpR.Emin.X, TmpR.Emax.Y ) );
      Add( TmpR.Emin );
    End;
    If FRotangle <> 0 Then
    Begin
      CX := ( TmpR.Emin.X + TmpR.Emax.X ) / 2;
      CY := ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2;
      M := Rotate2d( FRotangle, Point2d( CX, CY ) );
      Cnt := V.Count - 1;
      For I := 0 To Cnt Do
        V[I] := TransformPoint2d( V[I], M );
    End;
    Case Index Of
      0: // calculate the point
        Begin
          V[0] := Value;
          V[4] := Value;
          V[3] := Perpend( Value, V[2], V[3] );
          V[1] := Perpend( Value, V[1], V[2] );
        End;
      1:
        Begin
          V[0] := Perpend( Value, V[0], V[3] );
          V[4] := V[0];
          V[1] := Perpend( Value, V[1], V[2] );
        End;
      2:
        Begin
          V[1] := Value;
          V[2] := Perpend( Value, V[2], V[3] );
          V[0] := Perpend( Value, V[0], V[3] );
          V[4] := V[0];
        End;
      3:
        Begin
          V[1] := Perpend( Value, V[0], V[1] );
          V[2] := Perpend( Value, V[2], V[3] );
        End;
      4:
        Begin
          V[2] := Value;
          V[1] := Perpend( Value, V[0], V[1] );
          V[3] := Perpend( Value, V[0], V[3] );
        End;
      5:
        Begin
          V[2] := Perpend( Value, V[1], V[2] );
          V[3] := Perpend( Value, V[0], V[3] );
        End;
      6:
        Begin
          V[3] := Value;
          V[0] := Perpend( Value, V[0], V[1] );
          V[4] := V[0];
          V[2] := Perpend( Value, V[1], V[2] );
        End;
      7:
        Begin
          V[3] := Perpend( Value, V[2], V[3] );
          V[0] := Perpend( Value, V[0], V[1] );
          V[4] := V[0];
        End;
      8: // the move point
        Begin
          // calculate current move point
          MoveAndRotateControlPts( theMovePt, theRotatePt, Grapher );
          M := Translate2d( Value.X - theMovePt.X, Value.Y - theMovePt.Y );
          Cnt := V.Count - 1;
          For I := 0 To Cnt Do
            V[I] := TransformPoint2d( V[I], M );
        End;
      9: // the rotate point
        Begin
          MoveAndRotateControlPts( theMovePt, theRotatePt, Grapher );
          M := Rotate2d( FRotangle, theMovePt );
          theRotatePt := TransformPoint2d( theRotatePt, M );
          phiStart := Angle2d( theRotatePt, theMovePt );
          phiEnd := Angle2d( value, theMovePt );
          M := Rotate2d( phiEnd - phiStart, theMovePt );
          Cnt := V.Count - 1;
          For I := 0 To Cnt Do
            V[I] := TransformPoint2d( V[I], M );
        End;
    End;
    FRotangle := Angle2d( V[0], V[1] );
    Bx := V.Extension;
    CX := ( Bx.Emin.X + Bx.Emax.X ) / 2;
    CY := ( Bx.Emin.Y + Bx.Emax.Y ) / 2;
    DistX := Dist2d( V[0], V[1] );
    DistY := Dist2d( V[0], V[3] );
    FPoints[0] := Point2d( CX - DistX / 2, CY - DistY / 2 );
    FPoints[1] := Point2d( CX + DistX / 2, CY + DistY / 2 );
    MakeCurvePoints;
  Finally
    FPoints.DisableEvents := false;
    V.free;
  End;
End;

Function TEzEllipse.GetDrawPoints: TEzVector;
Begin
  Result := FCurvePoints;
End;

Procedure TEzEllipse.UpdateExtension;
Begin
  If FPoints.Count <> 2 Then Exit;
  If FCurvePoints = Nil Then
  Begin
    If FPointsInCurve < 50 Then
      FPointsInCurve := 50;
    FCurvePoints := TEzVector.Create( FPointsInCurve );
  End;
  MakeCurvePoints;
  FBox := TransformBoundingBox2D( FCurvePoints.Extension, self.GetTransformMatrix );
End;

Procedure TEzEllipse.MakeCurvePoints;
Var
  cnt, Sect, aCount: Integer;
  TmpX, TmpY, Delta, CurrAngle, CX, RX, CY, RY: Double;
  M: TEzMatrix;
Begin
  Delta := TwoPi / FPointsInCurve;
  CurrAngle := 0;
  RX := Abs( FPoints[1].X - FPoints[0].X ) / 2.0;
  RY := Abs( FPoints[1].Y - FPoints[0].Y ) / 2.0;
  CX := ( FPoints[1].X + FPoints[0].X ) / 2.0;
  CY := ( FPoints[1].Y + FPoints[0].Y ) / 2.0;
  FCurvePoints.Clear;
  Sect := Round( TwoPi / ( 4 * Delta ) );
  For cnt := 0 To Sect Do
  Begin
    TmpX := RX * Cos( CurrAngle );
    TmpY := RY * Sin( CurrAngle );
    FCurvePoints[cnt] := Point2D( CX + TmpX, CY + TmpY );
    FCurvePoints[2 * Sect - cnt] := Point2D( CX - TmpX, CY + TmpY );
    FCurvePoints[cnt + 2 * Sect] := Point2D( CX - TmpX, CY - TmpY );
    FCurvePoints[4 * Sect - cnt] := Point2D( CX + TmpX, CY - TmpY );
    CurrAngle := CurrAngle + Delta
  End;
  FBox := Rect2D( CX - RX, CY - RY, CX + RX, CY + RY );
  If FRotangle <> 0 Then
  Begin
    M := Rotate2d( FRotangle, Point2d( CX, CY ) );
    aCount := FCurvePoints.Count - 1;
    For cnt := 0 To aCount Do
      FCurvePoints[cnt] := TransformPoint2d( FCurvePoints[cnt], M );
  End;
End;

Procedure TEzEllipse.Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
  DrawMode: TEzDrawMode; Data: Pointer = Nil );
var
  OldStyle: TPenstyle;
  Poly: TEzEntity;
  p: TEzPoint;
  M: TEzMatrix;
  RX,RY,CX,CY: Double;
begin
  If (FPoints.Count > 1) And (DrawMode = dmRubberPen) And (ID<>-2) then   // -2= code for no drawing interior axis
  begin
    Oldstyle:= Canvas.Pen.Style;
    If ID <> -3 Then // -3= draw solid line
      Canvas.Pen.Style:= psDot;
    p:= Point2d(0,0);
    Poly:= TEzPolyline.CreateEntity( [p,p,p,p] );
    try
      { draw the major and minor axis }
      RX := Abs( FPoints[1].X - FPoints[0].X ) / 2.0;
      RY := Abs( FPoints[1].Y - FPoints[0].Y ) / 2.0;
      CX := ( FPoints[1].X + FPoints[0].X ) / 2.0;
      CY := ( FPoints[1].Y + FPoints[0].Y ) / 2.0;
      Poly.Points[0]:= Point2d(CX-RX,CY);
      Poly.Points[1]:= Point2d(CX+RX,CY);
      Poly.Points[2]:= Point2d(CX,CY-RY);
      Poly.Points[3]:= Point2d(CX,CY+RY);
      Poly.Points.Parts.Add(0);
      Poly.Points.Parts.Add(2);
      If FRotangle <> 0 then
      begin
        M:= Rotate2d(FRotangle, Point2d(cx,cy));
        Matrix3x3Premultiply(Self.GetTransformMatrix,M);
        Poly.SetTransformMatrix( M );
      end else
        Poly.SetTransformMatrix(Self.GetTransformMatrix);
      Poly.Draw( Grapher, Canvas, Clip, DrawMode, Data );
    finally
      Poly.free;
      If ID <> -3 Then
        Canvas.Pen.Style:= Oldstyle;
    end;
  end;
  inherited Draw( Grapher, Canvas, Clip, DrawMode, Data );
end;

Procedure TEzEllipse.LoadFromStream( Stream: TStream );
Begin
  Inherited LoadFromStream( stream );
  stream.Read( FPointsInCurve, SizeOf( FPointsInCurve ) );
  stream.Read( FRotangle, SizeOf( FRotangle ) );
  If FCurvePoints = Nil Then
    FCurvePoints := TEzVector.Create( FPointsInCurve );
  FPoints.CanGrow := false;
  UpdateExtension;
End;

Procedure TEzEllipse.SaveToStream( Stream: TStream );
Begin
  Inherited SaveToStream( stream );
  stream.Write( FPointsInCurve, SizeOf( FPointsInCurve ) );
  stream.Write( FRotangle, SizeOf( FRotangle ) );
End;

Procedure TEzEllipse.SetPointsInCurve( N: Integer );
Begin
  If N <> FPointsInCurve Then
  Begin
    FPointsInCurve := N;
    UpdateExtension;
  End;
End;

function TEzEllipse.IsEqualTo(Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean;
begin
  Result:= False;
  if Not ( Entity.EntityID = idEllipse ) Or
    ( Inherited IsEqualTo( Entity, IncludeAttribs ) = False )
    {$IFDEF FALSE}Or
    ( IncludeAttribs And ( FRotangle <> TEzEllipse(Entity).FRotangle ) ){$ENDIF} Then Exit;
  Result:= True;
end;

{------------------------------------------------------------------------------}
{                  TEzPictureRef                                             }
{------------------------------------------------------------------------------}

Constructor TEzPictureRef.CreateEntity( Const P1, P2: TEzPoint;
  Const FileName: String );
Begin
  Inherited CreateEntity( P1, P2 );
  //FAlphaChannel:= 0;
  FFileName := FileName;
End;

Destructor TEzPictureRef.Destroy;
Begin
  If FGraphicLink <> Nil Then
    FGraphicLink.Free;
  If FStream <> Nil Then
    FStream.Free;
  Inherited Destroy;
End;

Procedure TEzPictureRef.Initialize;
begin
  inherited;
  If FGraphicLink = Nil Then
    FGraphicLink := TEzGraphicLink.Create;
end;

Function TEzPictureRef.BasicInfoAsString: string;
Begin
  Result:= Format(sPicRefInfo, [FPoints.AsString,FFileName,FAlphaChannel,FRotangle]);
End;

Function TEzPictureRef.GetEntityID: TEzEntityID;
Begin
  Result := idPictureRef;
End;

{$IFDEF BCB}
function TEzPictureRef.GetAlphaChannel: byte;
begin
  Result := FAlphaChannel;
end;

function TEzPictureRef.GetFileName: String;
begin
  Result := FFileName;
end;

function TEzPictureRef.GetStream: TStream;
begin
  Result := FStream;
end;

procedure TEzPictureRef.SetAlphaChannel(const Value: byte);
begin
  FAlphaChannel := Value;
end;

procedure TEzPictureRef.SetFileName(const Value: String);
begin
  FFileName := Value;
end;

procedure TEzPictureRef.SetStream(const Value: TStream);
begin
  FStream := Value;
end;
{$ENDIF}

Function TEzPictureRef.GetGraphicLink: TEzGraphicLink;
Var
  Index: Integer;
Begin
  If Ez_Preferences.UsePreloadedImages Then
  Begin
    Index := Ez_Preferences.PreloadedImages.IndexOf( FFileName );
    If Index < 0 Then
    Begin
      If FGraphicLink = Nil Then
        FGraphicLink := TEzGraphicLink.Create;
      Result := FGraphicLink;
    End
    Else
    Begin
      Result := TEzGraphicLink( Ez_Preferences.PreloadedImages.Objects[Index] );
    End;
  End
  Else
  Begin
    If FGraphicLink = Nil Then
      FGraphicLink := TEzGraphicLink.Create;
    Result := FGraphicLink;
  End;
End;

Function TEzPictureRef.DoReadFile: Boolean;
Var
  filnam: String;
  TheGraphicLink: TEzGraphicLink;
Begin
  { first, check if the image is in the list of preloaded images }
  TheGraphicLink := Self.GetGraphicLink;
  If TheGraphicLink = FGraphicLink Then
  Begin
    filnam := AddSlash( Ez_Preferences.CommonSubDir ) + FFileName;
    If FileExists( filnam ) Then
      TheGraphicLink.ReadGeneric( filnam );
  End;
  Result := Not TheGraphicLink.Bitmap.Empty;
End;

Procedure TEzPictureRef.LoadFromStream( Stream: TStream );
Var
  Reserved: Array[0..41] Of byte;
Begin
  { read ID and points }
  FPoints.DisableEvents := true;
  Stream.Read( ID, SizeOf( ID ) );
  FPoints.LoadFromStream( Stream );
  FPoints.DisableEvents := False;
  FPoints.OnChange := UpdateExtension;

  { read pen}
  If PenTool = Nil Then
    PenTool := TEzPenTool.Create;
  PenTool.LoadFromStream( Stream );

  { read brush - not used this info}
  If FBrushTool = Nil Then
    FBrushTool := TEzBrushTool.Create;
  FBrushTool.LoadFromStream( Stream );

  With Stream Do
  Begin
    Read( FAlphaChannel, SizeOf( Byte ) );
    FFileName := EzReadStrFromStream( stream );
    Read(FRotangle,sizeof(FRotangle));
    Read(Reserved, sizeof(Reserved));
  End;
  FPoints.CanGrow := false;
  UpdateExtension;

  FOriginalSize := StorageSize;
End;

Procedure TEzPictureRef.SaveToStream( Stream: TStream );
Var
  Reserved: Array[0..41] Of byte;
Begin
  Stream.Write( ID, SizeOf( ID ) );
  FPoints.SaveToStream( Stream );

  { save pen}
  FPenTool.SaveToStream( Stream ); // save pen

  { save brush - not used this info }
  FBrushTool.SaveToStream( Stream );

  { save this entity info}
  With Stream Do
  Begin
    Write( fAlphaChannel, SizeOf( Byte ) );
    EzWriteStrToStream( FFileName, stream );
    Write(FRotangle,sizeof(FRotangle));
    Write( Reserved, sizeof( Reserved ) );
  End;
  FOriginalSize := StorageSize;
End;

Function TEzPictureRef.StorageSize: Integer;
Begin
  Result := Inherited StorageSize + Length( FFileName );
End;

Procedure TEzPictureRef.Draw( Grapher: TEzGrapher;
  Canvas: TCanvas; Const Clip: TEzRect; DrawMode: TEzDrawMode;
  Data: Pointer = Nil );
var
  GLink: TEzGraphicLink;
  Pass: Boolean;
  BitmapOriginal, BitmapRotated, TmpBitmap: TBitmap;
  Center, NewCenter: TPOINT;
  Rotated: Boolean;
  hPaintPal, hOldPal: HPalette;
  x, y, bgx, bgy, bgw, bgh: integer;
  BlendTable: Array[-255..255] Of Smallint;
  BmpRect, Src, Dest: TRect;
  BackgFormat: TPixelformat;
  scanlin: Pointer;
  p1_24, p2: pRGBTripleArray;
  p1_32: pRGBQuadArray;
  Work: TEzRect;
  fx, fy: Double;
  I,L, T, W, H: Integer;
  DevPoints: array[0..4] of TPoint;
  PolyRgn: HRgn;
Begin
  If Not IsBoxInBox2D( FBox, Clip ) Then Exit;
  GLink := Self.GetGraphicLink;
  If DrawMode = dmNormal Then
  Begin
    If FStream = Nil Then
      Pass := DoReadFile
    Else
    Begin
      FStream.Seek( 0, 0 );
      FGraphicLink.Bitmap.LoadFromStream( FStream );
      GLink := FGraphicLink;
      Pass := true;
    End;
  End
  Else
    Pass := false;

  If ( DrawMode <> dmNormal ) Or Not Pass Then
  Begin
    Brushtool.Pattern:= 0;
    Inherited Draw(Grapher, Canvas, Clip, DrawMode, Data);
    Exit;
  End;

  BitmapOriginal:= GLink.Bitmap;

  { rotate the bitmap if needed }
  Rotated:= False;
  If Abs(FRotangle) > 0.0001 Then
  Begin
    { Calculate }
    BitmapRotated:= TBitmap.Create;
    Center := POINT( BitmapOriginal.width div 2 , BitmapOriginal.Height div 2 );
    RotateBitmap( BitmapOriginal, BitmapRotated, FRotangle, Center, NewCenter );
    BitmapOriginal:= BitmapRotated;
    Rotated:= True;

    { define a polygonal clipping region }
    for I:= 0 to FPolyPoints.Count-1 do
      DevPoints[I]:= Grapher.RealToPoint(FPolyPoints[I]);
    PolyRgn := CreatePolygonRgn( DevPoints, FPolyPoints.Count, WINDING);
    Grapher.CanvasRegionStacker.Push(Canvas,PolyRgn)
  End;

  hPaintPal := BitmapOriginal.Palette;

  hOldPal := 0;
  If hPaintPal <> 0 Then
  Begin
    { Get the old palette and select the new palette }
    hOldPal := SelectPalette( Canvas.Handle, hPaintPal, False );

    { Realize palette }
    RealizePalette( Canvas.Handle );
  End;

  If FAlphaChannel > 0 Then
  Begin
    For x := -255 To 255 Do
      BlendTable[x] := ( FAlphaChannel * x ) Shr 8;
  End;

  SetStretchBltMode( Canvas.Handle, COLORONCOLOR );

  If IsBoxFullInBox2D( fBox, Clip ) Then
  Begin
    Dest := ReorderRect( Grapher.RealToRect( FBox ) );
    If Grapher.Device = adScreen Then
    Begin
      If FAlphaChannel > 0 Then
      Begin
        TmpBitmap := TBitmap.Create;
        Try
          TmpBitmap.PixelFormat := pf24bit;
          TmpBitmap.Width := succ( Dest.Right - Dest.Left );
          TmpBitmap.Height := succ( Dest.Bottom - Dest.Top );
          TmpBitmap.Canvas.StretchDraw( Rect( 0, 0, TmpBitmap.Width, TmpBitmap.Height ), BitmapOriginal );
          bgw := BufferBitmap.Width;
          bgh := BufferBitmap.Height;
          BackgFormat := BufferBitmap.PixelFormat;
          For y := 0 To TmpBitmap.Height - 1 Do
          Begin
            bgy := y + Dest.Top;
            If ( bgy < 0 ) Or ( bgy > bgh - 1 ) Then Continue;
            scanlin := BufferBitmap.ScanLine[bgy];
            p1_24 := scanlin;
            p1_32 := scanlin;
            p2 := TmpBitmap.ScanLine[y];
            For x := 0 To TmpBitmap.Width - 1 Do
            Begin
              bgx := x + Dest.Left;
              If ( bgx < 0 ) Or ( bgx > bgw - 1 ) Then Continue;
              Case BackgFormat Of
                pf24bit:
                  With p1_24^[bgx] Do
                  Begin
                    rgbtBlue := BlendTable[rgbtBlue - p2^[x].rgbtBlue] + p2^[x].rgbtBlue;
                    rgbtGreen := BlendTable[rgbtGreen - p2^[x].rgbtGreen] + p2^[x].rgbtGreen;
                    rgbtRed := BlendTable[rgbtRed - p2^[x].rgbtRed] + p2^[x].rgbtRed;
                  End;
                pf32bit:
                  With p1_32^[bgx] Do
                  Begin
                    rgbBlue := BlendTable[rgbBlue - p2^[x].rgbtBlue] + p2^[x].rgbtBlue;
                    rgbGreen := BlendTable[rgbGreen - p2^[x].rgbtGreen] + p2^[x].rgbtGreen;
                    rgbRed := BlendTable[rgbRed - p2^[x].rgbtRed] + p2^[x].rgbtRed;
                  End;
              End;
            End;
          End;
        Finally
          TmpBitmap.free;
        End;
      End
      Else
        Canvas.StretchDraw( Dest, BitmapOriginal );
    End
    Else
    Begin
      EzGraphics.PrintBitmapEx( Canvas, Dest, BitmapOriginal,
        Rect( 0, 0, BitmapOriginal.Width, BitmapOriginal.Height ) );
    End;
  End
  Else
  Begin
    // Calculate image rectangle
    Work := IntersectRect2D( FBox, Clip );
    If IsRectEmpty2D( Work ) Then Exit;
    Dest := Grapher.RealToRect( Work );
    BmpRect := Grapher.RealToRect( fBox );
    Src := Dest;
    With BmpRect Do
    Begin
      fx := Grapher.DistToRealX( BitmapOriginal.Width ) / Abs( FBox.X2 - FBox.X1 );
      fy := Grapher.DistToRealY( BitmapOriginal.Height ) / Abs( FBox.Y2 - FBox.Y1 );
      OffsetRect( Src, -Left, -Top );
    End;
    L := round( Src.Left * fx );
    T := round( Src.Top * fy );
    W := round( ( Src.Right - Src.Left ) * fx );
    H := round( ( Src.Bottom - Src.Top ) * fy );
    If ( W = 0 ) Or ( H = 0 ) Then Exit;

    If Grapher.Device = adScreen Then
    Begin
      If FAlphaChannel > 0 Then
      Begin
        TmpBitmap := TBitmap.Create;
        Try
          TmpBitmap.PixelFormat := pf24bit;
          TmpBitmap.Width := succ( Dest.Right - Dest.Left );
          TmpBitmap.Height := succ( Dest.Bottom - Dest.Top );
          SetStretchBltMode( TmpBitmap.Canvas.Handle, COLORONCOLOR );
          StretchBlt( TmpBitmap.Canvas.Handle,
            0, 0,
            TmpBitmap.Width, TmpBitmap.Height,
            BitmapOriginal.Canvas.Handle,
            L, T, W, H, SRCCOPY );
          bgw := BufferBitmap.Width;
          bgh := BufferBitmap.Height;
          BackgFormat := BufferBitmap.PixelFormat;
          For y := 0 To TmpBitmap.Height - 1 Do
          Begin
            bgy := y + Dest.Top;
            If ( bgy < 0 ) Or ( bgy > bgh - 1 ) Then
              Continue;
            scanlin := BufferBitmap.ScanLine[bgy];
            p1_24 := scanlin;
            p1_32 := scanlin;
            p2 := TmpBitmap.ScanLine[y];
            For x := 0 To TmpBitmap.Width - 1 Do
            Begin
              bgx := x + Dest.Left;
              If ( bgx < 0 ) Or ( bgx > bgw - 1 ) Then
                Continue;
              Case BackgFormat Of
                pf24bit:
                  With p1_24^[bgx] Do
                  Begin
                    rgbtBlue := BlendTable[rgbtBlue - p2^[x].rgbtBlue] + p2^[x].rgbtBlue;
                    rgbtGreen := BlendTable[rgbtGreen - p2^[x].rgbtGreen] + p2^[x].rgbtGreen;
                    rgbtRed := BlendTable[rgbtRed - p2^[x].rgbtRed] + p2^[x].rgbtRed;
                  End;
                pf32bit:
                  With p1_32^[bgx] Do
                  Begin
                    rgbBlue := BlendTable[rgbBlue - p2^[x].rgbtBlue] + p2^[x].rgbtBlue;
                    rgbGreen := BlendTable[rgbGreen - p2^[x].rgbtGreen] + p2^[x].rgbtGreen;
                    rgbRed := BlendTable[rgbRed - p2^[x].rgbtRed] + p2^[x].rgbtRed;
                  End;
              End;
            End;
          End;
        Finally
          TmpBitmap.free;
        End;
      End
      Else
        StretchBlt( Canvas.Handle,
          Dest.Left,
          Dest.Top,
          ( Dest.Right - Dest.Left ),
          ( Dest.Bottom - Dest.Top ),
          BitmapOriginal.Canvas.Handle,
          L, T, W, H,
          SRCCOPY );
    End
    Else
    Begin
      With Dest Do
        EzGraphics.PrintBitmapEx( Canvas,
          Dest,
          BitmapOriginal,
          Rect( L, T, L + W, T + H ) );
    End;
  End;
  {Restore the old palette}
  If ( hPaintPal <> 0 ) And ( hOldPal <> 0 ) Then
    SelectPalette( Canvas.Handle, hOldPal, False );

  If Rotated Then
  begin
    BitmapRotated.Free;
    Grapher.CanvasRegionStacker.Pop(Canvas);
  end;

End;

function TEzPictureRef.IsEqualTo(Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean;
begin
  Result:= False;
  if Not ( Entity.EntityID = idPictureRef ) Or
    ( Inherited IsEqualTo( Entity, IncludeAttribs ) = False )
    {$IFDEF FALSE}Or
    ( IncludeAttribs And ( FFileName <> TEzPictureRef(Entity).FFileName ) ){$ENDIF} Then Exit;
  Result:= True;
end;

{------------------------------------------------------------------------------}
{                  TEzPersistBitmap                                          }
{------------------------------------------------------------------------------}

Constructor TEzPersistBitmap.CreateEntity( Const P1, P2: TEzPoint; Const FileName: String );
Var
  filnam: String;
Begin
  Inherited CreateEntity(P1, P2);
  FBitmap := TBitmap.Create;
  If Length( FileName ) > 0 Then
  Begin
    filnam := AddSlash( Ez_Preferences.CommonSubDir ) + Filename;
    If FileExists( filnam ) Then
      FBitmap.LoadFromFile( filnam );
  End;
  FPoints.CanGrow := False;
End;

Destructor TEzPersistBitmap.Destroy;
Begin
  If FBitmap <> Nil Then
    FBitmap.Free;
  Inherited Destroy;
End;

Function TEzPersistBitmap.GetEntityID: TEzEntityID;
Begin
  result := idPersistBitmap;
End;

{$IFDEF BCB}
function TEzPersistBitmap.GetBitmap: TBitmap;
begin
  Result := FBitmap;
end;

function TEzPersistBitmap.GetTransparent: Boolean;
begin
  Result := FTransparent;
end;

procedure TEzPersistBitmap.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
end;
{$ENDIF}

Procedure TEzPersistBitmap.Draw( Grapher: TEzGrapher;
  Canvas: TCanvas; Const Clip: TEzRect; DrawMode: TEzDrawMode;
  Data: Pointer = Nil );
Var
  BmpRect, Src, Dest: TRect;
  Work: TEzRect;
  fx, fy: Double;
  L, T, W, H: Integer;
  hPaintPal, hOldPal: HPalette; { Used for realizing the palette }
  Oldstyle: TPenstyle;
  RotatedBmp: TBitmap;
  TheBitmap: TBitmap;
  Rotated: Boolean;
  Center, NewCenter: TPOINT;
  I: Integer;
  DevPoints: array[0..4] of TPoint;
  PolyRgn: HRgn;
  //AngleRot: Double;
  TM: TEzMatrix;
Begin
  If Not IsBoxInBox2D( FBox, Clip ) Then Exit;

  If ( DrawMode <> dmNormal ) Or FBitmap.Empty Then
  Begin
    Oldstyle:= Canvas.Pen.Style;
    If DrawMode = dmRubberpen Then
      Canvas.Pen.Style:= psDot;
    FPolyPoints.DrawOpened( Canvas, Clip, FBox, Grapher, PenTool.FPenStyle,
      Self.GetTransformMatrix, DrawMode );
    If DrawMode = dmRubberpen Then
      Canvas.Pen.Style:= Oldstyle;
    Exit;
  End;
  // Calculate picture rectangle

  TheBitmap:= FBitmap;

  { rotate the bitmap if needed }
  Rotated:= False;
  //AngleRot:= Angle2d(FPolyPoints[0], FPolyPoints[1]);
  If Abs(FRotangle) > 0.0001 Then
  Begin
    { Calculate }
    RotatedBmp:= TBitmap.Create;
    Center := Point(TheBitmap.width div 2, TheBitmap.Height div 2);
    RotateBitmap( TheBitmap, RotatedBmp, FRotangle, Center, NewCenter );
    TheBitmap:= RotatedBmp;
    Rotated:= True;

    { define a polygonal clipping region }
    TM:= Self.GetTransformMatrix;
    for I:= 0 to FPolyPoints.Count-1 do
      DevPoints[I]:= Grapher.RealToPoint(TransformPoint2d(FPolyPoints[I],TM));
    PolyRgn := CreatePolygonRgn( DevPoints, FPolyPoints.Count, WINDING);
    Grapher.CanvasRegionStacker.Push(Canvas,PolyRgn)
  End;

  If FTransparent Then
  Begin
    TheBitmap.Transparent := true;
    TheBitmap.TransparentMode := tmAuto;
    //TheBitmap.TransparentColor:= clWhite;
  End;

  hPaintPal := TheBitmap.Palette;

  {Get the old palette and select the new palette}
  hOldPal := SelectPalette( Canvas.Handle, hPaintPal, False );

  {Realize palette}
  RealizePalette( Canvas.Handle );

  {Set the stretch blt mode}
  SetStretchBltMode( Canvas.Handle, STRETCH_DELETESCANS );

  If IsBoxFullInBox2D( FBox, Clip ) Then
  Begin
    Dest := ReorderRect( Grapher.RealToRect( FBox ) );
    If Grapher.Device = adScreen Then
      Canvas.StretchDraw( Dest, TheBitmap )
    Else
      EzGraphics.PrintBitmapEx( Canvas,
        Dest,
        TheBitmap,
        Rect( 0, 0, TheBitmap.Width, TheBitmap.Height ) );
  End
  Else
  Begin
    // Calculate image rectangle
    Work := IntersectRect2D( FBox, Clip );
    If IsRectEmpty2D( Work ) Then Exit;

    Dest := Grapher.RealToRect( Work );
    BmpRect := Grapher.RealToRect( fBox );
    Src := Dest;
    With BmpRect Do
    Begin
      fx := Grapher.DistToRealX( TheBitmap.Width ) / Abs( FBox.X2 - FBox.X1 );
      fy := Grapher.DistToRealY( TheBitmap.Height ) / Abs( FBox.Y2 - FBox.Y1 );
      OffsetRect( Src, -Left, -Top );
    End;
    L := round( Src.Left * fx );
    T := round( Src.Top * fy );
    W := round( ( Src.Right - Src.Left ) * fx );
    H := round( ( Src.Bottom - Src.Top ) * fy );
    If ( W = 0 ) Or ( H = 0 ) Then Exit;

    If Grapher.Device = adScreen Then
      //Canvas.StretchDraw(BmpRect, TheBitmap)
      With Dest Do
        StretchBlt( Canvas.Handle,
          Left,
          Top,
          ( Right - Left ),
          ( Bottom - Top ),
          TheBitmap.Canvas.Handle,
          L, T, W, H,
          SRCCOPY )
    Else
      With Dest Do
        EzGraphics.PrintBitmapEx( Canvas,
          Dest,
          TheBitmap,
          Rect( L, T, L + W, T + H ) );
  End;
  // Restore the old palette
  If hOldPal <> 0 Then
    SelectPalette( Canvas.Handle, hOldPal, False );

  If Rotated then
  begin
    RotatedBmp.Free;
    Grapher.CanvasRegionStacker.Pop(Canvas);
  end;
End;

Procedure TEzPersistBitmap.LoadFromStream( Stream: TStream );
Var
  ms: TMemoryStream;
  msSize: Integer;
  ffu: Array[0..13] of byte;
Begin
  If FBitmap = Nil Then
    FBitmap := TBitmap.Create;

  FPoints.DisableEvents := true;

  If FPenTool = Nil Then
    FPenTool := TEzPenTool.Create;
  Stream.Read( ID, SizeOf( ID ) );
  FPoints.LoadFromStream( Stream );
  FPenTool.LoadFromStream( Stream ); // read pen
  If FBrushTool = Nil Then
    FBrushTool := TEzBrushTool.Create;
  { brush not used }
  Stream.Read(FRotangle,sizeof(Double));
  Stream.Read(ffu, sizeof(ffu));

  With Stream Do
  Begin
    Read( FTransparent, SizeOf( Boolean ) );
    Read( msSize, sizeof( Integer ) );
  End;
  ms := TMemoryStream.Create;
  Try
    ms.CopyFrom( Stream, msSize );
    ms.Position := 0;
    FBitmap.LoadFromStream( ms );
  Finally
    ms.Free;
  End;
  FPoints.CanGrow := False;

  FPoints.OnChange := UpdateExtension;
  FOriginalSize := StorageSize;
  UpdateExtension;
End;

Procedure TEzPersistBitmap.SaveToStream( Stream: TStream );
Var
  ms: TMemoryStream;
  msSize: Integer;
  ffu: Array[0..13] of byte;
Begin
  Stream.Write( ID, SizeOf( ID ) );
  FPoints.SaveToStream( Stream );
  FPenTool.SaveToStream( Stream );    // not needed
  { brush not used }
  Stream.Write(FRotangle,sizeof(Double));
  Stream.Write(ffu, sizeof(ffu));
  With Stream Do
  Begin
    Write( FTransparent, SizeOf( Boolean ) );
    ms := TMemoryStream.Create;
    Try
      FBitmap.SaveToStream( ms );
      msSize := ms.Size;
      Write( msSize, sizeof( Integer ) );
      ms.Position := 0;
      CopyFrom( ms, msSize );
    Finally
      ms.Free;
    End;
  End;
  FOriginalSize := StorageSize;
End;

Function TEzPersistBitmap.StorageSize: Integer;
Var
  BitmapSize: Integer;
  Stream: TStream;
Begin
  Stream := TMemoryStream.Create;
  Try
    FBitmap.SaveToStream( Stream );
    BitmapSize := Stream.Size;
  Finally
    Stream.Free;
  End;
  result := Inherited StorageSize + BitmapSize;
End;

{------------------------------------------------------------------------------}
//                  TEzCustomPicture
{------------------------------------------------------------------------------}

Constructor TEzCustomPicture.CreateEntity( Const P1, P2: TEzPoint );
Begin
  Inherited CreateEntity( [P1, P2], False );
End;

Destructor TEzCustomPicture.Destroy;
Begin
  If FVector <> Nil Then
    FVector.Free;
  Inherited Destroy;
End;

Procedure TEzCustomPicture.Initialize;
begin
  inherited;
  FVector := TEzVector.Create( 5 );
end;

Function TEzCustomPicture.BasicInfoAsString: string;
Begin
  Result:= Format(sCustomPicInfo, [FPoints.AsString]);
End;

Function TEzCustomPicture.GetEntityID: TEzEntityID;
Begin
  result := idCustomPicture;
End;

{$IFDEF BCB}
function TEzCustomPicture.GetPicture: TPicture;
begin
  Result := FPicture;
end;

function TEzCustomPicture.GetTransparent: Boolean;
begin
  Result := FTransparent;
end;

procedure TEzCustomPicture.SetPicture(const Value: TPicture);
begin
  FPicture := Value;
end;

procedure TEzCustomPicture.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
end;
{$ENDIF}

Procedure TEzCustomPicture.Draw( Grapher: TEzGrapher;
  Canvas: TCanvas; Const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer = Nil );
Var
  BmpRect, Src, Dest: TRect;
  Work: TEzRect;
  fx, fy: Double;
  L, T, W, H: Integer;
  hPaintPal, hOldPal: HPalette; {Used for realizing the palette}
  Bitmap: TBitmap;
  Metafile: TMetafile;
  Oldstyle: TPenstyle;
Begin
  If (FPicture = Nil) or (DrawMode <> dmNormal) Then
  Begin
    Oldstyle:= Canvas.Pen.Style;
    If DrawMode = dmRubberpen Then
      Canvas.Pen.Style:= psDot;
    FVector.DrawOpened( Canvas, Clip, FBox, Grapher, PenTool.FPenStyle,
                        Self.GetTransformMatrix, DrawMode );
    If DrawMode = dmRubberpen Then
      Canvas.Pen.Style:= Oldstyle;
    Exit;
  End;
  If Not IsBoxInBox2D( FBox, Clip ) Then Exit;

  Bitmap := Nil;
  Metafile:= Nil;
  if FPicture.Graphic is TBitmap then
    Bitmap:= FPicture.Bitmap
  else if FPicture.Graphic is TIcon then
    Exit  // no icons please :-)
  else if FPicture.Graphic is TMetafile then
    Metafile:= FPicture.Metafile;
  if (Bitmap = Nil) and (Metafile = Nil) then Exit;
  If ( DrawMode <> dmNormal ) Or ( ( Bitmap <> Nil) And Bitmap.Empty) Or
     ( (Metafile <> Nil) And (Metafile.Empty) ) Then
  Begin
    FVector.DrawOpened( Canvas, Clip, FBox, Grapher, PenTool.FPenStyle,
                        Self.GetTransformMatrix, DrawMode );
    Exit;
  End;
  (* Calculate picture rectangle *)
  If FTransparent And (Bitmap <> Nil) Then
  Begin
    Bitmap.Transparent := true;
    Bitmap.TransparentMode := tmAuto;
  End;

  hOldPal := 0;
  if Bitmap <> Nil then
  Begin
    hPaintPal := Bitmap.Palette;

    {Get the old palette and select the new palette}
    hOldPal := SelectPalette( Canvas.Handle, hPaintPal, False );

    {Realize palette}
    RealizePalette( Canvas.Handle );
  End;

  { Set the stretch blt mode }
  SetStretchBltMode( Canvas.Handle, STRETCH_DELETESCANS );

  If IsBoxFullInBox2D( FBox, Clip ) Then
  Begin
    Dest := ReorderRect( Grapher.RealToRect( FBox ) );
    if Bitmap <> Nil then
    Begin
      If Grapher.Device = adScreen Then
        Canvas.StretchDraw( Dest, Bitmap )
      Else
        EzGraphics.PrintBitmapEx( Canvas, Dest, Bitmap,
          Rect( 0, 0, Bitmap.Width, Bitmap.Height ) );
    End Else if Metafile <> Nil then
    Begin
      Canvas.StretchDraw( Dest, Metafile )
    End;
  End
  Else
  Begin
    if Bitmap <> Nil then
    Begin
      // Calculate image rectangle
      Work := IntersectRect2D( FBox, Clip );
      If IsRectEmpty2D( Work ) Then Exit;
      Dest := Grapher.RealToRect( Work );
      BmpRect := Grapher.RealToRect( fBox );
      Src := Dest;
      With BmpRect Do
      Begin
        fx := Grapher.DistToRealX( Bitmap.Width ) / Abs( FBox.X2 - FBox.X1 );
        fy := Grapher.DistToRealY( Bitmap.Height ) / Abs( FBox.Y2 - FBox.Y1 );
        OffsetRect( Src, -Left, -Top );
      End;
      L := round( Src.Left * fx );
      T := round( Src.Top * fy );
      W := round( ( Src.Right - Src.Left ) * fx );
      H := round( ( Src.Bottom - Src.Top ) * fy );
      If ( W = 0 ) Or ( H = 0 ) Then  Exit;
      If Grapher.Device = adScreen Then
        //Canvas.StretchDraw(BmpRect, FBitmap)
        With Dest Do
          StretchBlt( Canvas.Handle, Left, Top, ( Right - Left ), ( Bottom - Top ),
            Bitmap.Canvas.Handle, L, T, W, H, SRCCOPY )
      Else
        With Dest Do
          EzGraphics.PrintBitmapEx( Canvas, Dest, Bitmap,
            Rect( L, T, L + W, T + H ) );
    End Else if Metafile <> Nil Then
    Begin
      Dest := ReorderRect( Grapher.RealToRect( FBox ) );
      Canvas.StretchDraw( Dest, Metafile )
    End;
  End;
  {Restore the old palette}
  If (Bitmap <> Nil) And (hOldPal <> 0) Then
    SelectPalette( Canvas.Handle, hOldPal, False );
End;

Function TEzCustomPicture.GetDrawPoints: TEzVector;
Begin
  Result := FVector;
End;

Procedure TEzCustomPicture.LoadFromStream( Stream: TStream );
Begin
  Inherited LoadFromStream( stream );
  With Stream Do
  Begin
    Read( FTransparent, SizeOf( Boolean ) );
  End;
  FPoints.CanGrow := False;
  UpdateExtension;
End;

Procedure TEzCustomPicture.SaveToStream( Stream: TStream );
Begin
  Inherited SaveToStream( Stream );
  With Stream Do
  Begin
    Write( FTransparent, SizeOf( Boolean ) );
  End;
End;

Procedure TEzCustomPicture.UpdateExtension;
Begin
  Inherited UpdateExtension;
  If FPoints.Count <> 2 Then Exit;
  If FVector = Nil Then
    FVector := TEzVector.Create( 5 )
  Else
    FVector.Clear;
  With FVector Do
  Begin
    Add( FPoints[0] );
    Add( Point2D( FPoints[0].X, FPoints[1].Y ) );
    Add( FPoints[1] );
    Add( Point2D( FPoints[1].X, FPoints[0].Y ) );
    Add( FPoints[0] );
  End;
End;

Function TEzCustomPicture.GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector;
Var
  TmpR: TEzRect;
  Movept: TEzPoint;
Begin
  Result := TEzVector.Create( 8 );
  TmpR.Emin := FPoints[0];
  TmpR.Emax := FPoints[1];
  TmpR := ReorderRect2D( TmpR );
  With Result Do
  Begin
    Add( TmpR.Emin ); // LOWER LEFT
    AddPoint( ( TmpR.Emin.X + TmpR.Emax.X ) / 2, TmpR.Emin.Y ); // MIDDLE BOTTOM
    AddPoint( TmpR.Emax.X, TmpR.Emin.Y ); // LOWER RIGHT
    AddPoint( TmpR.Emax.X, ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2 ); // MIDDLE RIGHT
    Add( TmpR.Emax ); // UPPER RIGHT
    AddPoint( ( TmpR.Emin.X + TmpR.Emax.X ) / 2, TmpR.Emax.Y ); // MIDDLE TOP
    AddPoint( TmpR.Emin.X, TmpR.Emax.Y ); // UPPER LEFT
    AddPoint( TmpR.Emin.X, ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2 ); // MIDDLE LEFT
    if TransfPts then
    begin
      // the move control point
      MovePt.X := ( TmpR.Emin.X + TmpR.Emax.X ) / 2;
      MovePt.Y := ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2;
      AddPoint( MovePt.X, MovePt.Y );
    end;
  End;
End;

Function TEzCustomPicture.GetControlPointType( Index: Integer ): TEzControlPointType;
Begin
  If Index = 8 Then
    Result := cptMove
  Else
    Result := cptNode;
End;

Procedure TEzCustomPicture.UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil );
Var
  TmpR: TEzRect;
  Movept: TEzPoint;
  M: TEzMatrix;
Begin
  FPoints.DisableEvents := True;
  Try
    TmpR.Emin := FPoints[0];
    TmpR.Emax := FPoints[1];
    TmpR := ReorderRect2D( TmpR );
    Case Index Of
      0: // LOWER LEFT
        Begin
          TmpR.Emin := Value;
        End;
      1: // MIDDLE BOTTOM
        Begin
          TmpR.Emin.Y := Value.Y;
        End;
      2: // LOWER RIGHT
        Begin
          TmpR.Emax.X := Value.X;
          TmpR.Emin.Y := Value.Y;
        End;
      3: // MIDDLE RIGHT
        Begin
          TmpR.Emax.X := Value.X;
        End;
      4: // UPPER RIGHT
        Begin
          TmpR.Emax := Value;
        End;
      5: // MIDDLE TOP
        Begin
          TmpR.Emax.Y := Value.Y;
        End;
      6: // UPPER LEFT
        Begin
          TmpR.Emin.X := Value.X;
          TmpR.Emax.Y := Value.Y;
        End;
      7: // MIDDLE LEFT
        Begin
          TmpR.Emin.X := Value.X;
        End;
      8: // MOVE POINT
        Begin
          // calculate current move point
          MovePt.X := ( TmpR.Emin.X + TmpR.Emax.X ) / 2;
          MovePt.Y := ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2;
          M := Translate2d( Value.X - MovePt.X, Value.Y - MovePt.Y );
          TmpR.Emin := TransformPoint2d( TmpR.Emin, M );
          TmpR.Emax := TransformPoint2d( TmpR.Emax, M );
        End;
    End;
    FPoints[0] := TmpR.Emin;
    FPoints[1] := TmpR.Emax;
    UpdateExtension;
  Finally
    FPoints.DisableEvents := false;
  End;
End;

{------------------------------------------------------------------------------}
{                  TEzBandsBitmap                                            }
{------------------------------------------------------------------------------}

Constructor TEzBandsBitmap.CreateEntity( Const P1, P2: TEzPoint; Const FileName: String );
Begin
  Inherited CreateEntity( [P1, P2], False );
  FFileName := FileName;
End;

Destructor TEzBandsBitmap.Destroy;
Begin
  FVector.Free;
  If FStream <> Nil Then
    FStream.Free;
  Inherited Destroy;
End;

procedure TEzBandsBitmap.Initialize;
begin
  inherited;
  FVector := TEzVector.Create( 5 );
end;

Function TEzBandsBitmap.BasicInfoAsString: string;
Begin
  Result:= Format(sBandsBmpInfo, [FPoints.AsString,FFileName,FAlphaChannel]);
End;

Function TEzBandsBitmap.GetEntityID: TEzEntityID;
Begin
  result := idBandsBitmap;
End;

{$IFDEF BCB}
function TEzBandsBitmap.GetAlphaChannel: Byte;
begin
  Result := FAlphaChannel;
end;

function TEzBandsBitmap.GetFileName: String;
begin
  Result := FFileName;
end;

function TEzBandsBitmap.GetStream: TStream;
begin
  Result := FStream;
end;

procedure TEzBandsBitmap.SetAlphaChannel(const Value: Byte);
begin
  FAlphaChannel := Value;
end;

procedure TEzBandsBitmap.SetFileName(const Value: String);
begin
  FFileName := Value;
end;

procedure TEzBandsBitmap.SetStream(const Value: TStream);
begin
  FStream := Value;
end;
{$ENDIF}

Function TEzBandsBitmap.GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector;
Var
  TmpR: TEzRect;
  Movept: TEzPoint;
Begin
  Result := TEzVector.Create( 8 );
  TmpR.Emin := FPoints[0];
  TmpR.Emax := FPoints[1];
  TmpR := ReorderRect2D( TmpR );
  With Result Do
  Begin
    Add( TmpR.Emin ); // LOWER LEFT
    AddPoint( ( TmpR.Emin.X + TmpR.Emax.X ) / 2, TmpR.Emin.Y ); // MIDDLE BOTTOM
    AddPoint( TmpR.Emax.X, TmpR.Emin.Y ); // LOWER RIGHT
    AddPoint( TmpR.Emax.X, ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2 ); // MIDDLE RIGHT
    Add( TmpR.Emax ); // UPPER RIGHT
    AddPoint( ( TmpR.Emin.X + TmpR.Emax.X ) / 2, TmpR.Emax.Y ); // MIDDLE TOP
    AddPoint( TmpR.Emin.X, TmpR.Emax.Y ); // UPPER LEFT
    AddPoint( TmpR.Emin.X, ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2 ); // MIDDLE LEFT
    if TransfPts then
    begin
      // the move control point
      MovePt.X := ( TmpR.Emin.X + TmpR.Emax.X ) / 2;
      MovePt.Y := ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2;
      AddPoint( MovePt.X, MovePt.Y );
    end;
  End;
End;

Function TEzBandsBitmap.GetControlPointType( Index: Integer ): TEzControlPointType;
Begin
  If Index = 8 Then
    Result := cptMove
  Else
    Result := cptNode;
End;

Procedure TEzBandsBitmap.UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil );
Var
  TmpR: TEzRect;
  Movept: TEzPoint;
  M: TEzMatrix;
Begin
  FPoints.DisableEvents := True;
  Try
    TmpR.Emin := FPoints[0];
    TmpR.Emax := FPoints[1];
    TmpR := ReorderRect2D( TmpR );
    Case Index Of
      0: // LOWER LEFT
        Begin
          TmpR.Emin := Value;
        End;
      1: // MIDDLE BOTTOM
        Begin
          TmpR.Emin.Y := Value.Y;
        End;
      2: // LOWER RIGHT
        Begin
          TmpR.Emax.X := Value.X;
          TmpR.Emin.Y := Value.Y;
        End;
      3: // MIDDLE RIGHT
        Begin
          TmpR.Emax.X := Value.X;
        End;
      4: // UPPER RIGHT
        Begin
          TmpR.Emax := Value;
        End;
      5: // MIDDLE TOP
        Begin
          TmpR.Emax.Y := Value.Y;
        End;
      6: // UPPER LEFT
        Begin
          TmpR.Emin.X := Value.X;
          TmpR.Emax.Y := Value.Y;
        End;
      7: // MIDDLE LEFT
        Begin
          TmpR.Emin.X := Value.X;
        End;
      8: // MOVE POINT
        Begin
          // calculate current move point
          MovePt.X := ( TmpR.Emin.X + TmpR.Emax.X ) / 2;
          MovePt.Y := ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2;
          M := Translate2d( Value.X - MovePt.X, Value.Y - MovePt.Y );
          TmpR.Emin := TransformPoint2d( TmpR.Emin, M );
          TmpR.Emax := TransformPoint2d( TmpR.Emax, M );
        End;
    End;
    FPoints[0] := TmpR.Emin;
    FPoints[1] := TmpR.Emax;
    UpdateExtension;
  Finally
    FPoints.DisableEvents := false;
  End;
End;

Function TEzBandsBitmap.GetFormat: TEzImageFormat;
begin
  Result:= ifBitmap;
  If AnsiCompareText('.bmp',ExtractFileExt(FFileName))=0 then
  else If AnsiCompareText('.tif',ExtractFileExt(FFileName))=0 then
    Result:= ifTiff
  else If AnsiCompareText('.bil',ExtractFileExt(FFileName))=0 then
    Result:= ifBIL;
end;

Procedure TEzBandsBitmap.Draw( Grapher: TEzGrapher;
  Canvas: TCanvas; Const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer = Nil );
Var
  BmpRect, Src, Dest: TRect;
  Work: TEzRect;
  fx, fy: Double;
  BitmapWidth, BitmapHeight, L, T, W, H: Integer;
  BitmapEx: TEzBitmapEx;
  BILReader: TEzBILReader;
  IsCompressed: boolean;
  filnam: String;
  PreloadedSet: Boolean;
  Index: Integer;
  ImgFormat: TEzImageFormat;
{$IFDEF USE_GRAPHICEX}
  TiffEx: TEzTiffEx;
{$ENDIF}

  Procedure DrawAsFrame;
  var
    Oldstyle: TPenstyle;
  Begin
    Oldstyle:= Canvas.Pen.Style;
    If DrawMode = dmRubberpen Then
      Canvas.Pen.Style:= psDot;
    FVector.DrawOpened( Canvas, Clip, FBox, Grapher, PenTool.FPenStyle, self.GetTransformMatrix, DrawMode );
    If DrawMode = dmRubberpen Then
      Canvas.Pen.Style:= Oldstyle;
  End;

Begin
  If Not IsBoxInBox2D( FBox, Clip ) Then Exit;
  If DrawMode <> dmNormal Then
  Begin
    DrawAsFrame;
    Exit;
  End;

  ImgFormat:= GetFormat;

  { search on the preloaded banded images }
  PreloadedSet := false;
  If ( FStream = Nil ) And Ez_Preferences.UsePreloadedBandedImages Then
  Begin
    Index := Ez_Preferences.PreloadedBandedImages.IndexOf( FFileName );
    If Index >= 0 Then
    Begin
      FStream := TStream( Ez_Preferences.PreloadedBandedImages.Objects[Index] );
      FStream.Position := 0;
      PreloadedSet := true;
    End;
  End;

  filnam := AddSlash( Ez_Preferences.CommonSubDir ) + FFileName;
  If (FStream = Nil) and Not FileExists( filnam ) Then
  Begin
    DrawAsFrame;
    Exit;
  end;

  IsCompressed:= False;
  case ImgFormat of
    ifBitmap:
      If Not GetDIBDimensions( filnam, FStream, BitmapWidth, BitmapHeight, IsCompressed ) Then
      Begin
        If PreloadedSet Then
          FStream := Nil;
        Exit;
      End;
    ifTiff:
{$IFDEF USE_GRAPHICEX}
      If Not GetTiffDimensions( filnam, Stream, BitmapWidth, BitmapHeight, IsCompressed ) Then
      Begin
        If PreloadedSet Then
          Stream := Nil;
        Exit;
      End
{$ENDIF}
      ;
    ifBIL:
      If Not GetBILDimensions( filnam, BitmapWidth, BitmapHeight ) Then
      Begin
        If PreloadedSet Then
          FStream := Nil;
        Exit;
      End;
  end;

  If IsCompressed Then
  Begin
    If PreloadedSet Then
      FStream := Nil;
    DrawAsFrame;
    Exit;
  End;

  BILReader := Nil;
  BitmapEx := Nil;
{$IFDEF USE_GRAPHICEX}
  TiffEx:= Nil;
{$ENDIF}

  case ImgFormat of
    ifBitmap:
      BitmapEx := TEzBitmapEx.Create;
    ifTiff:
      {$IFDEF USE_GRAPHICEX} TiffEx := TEzTiffEx.Create{$ENDIF};
    ifBIL:
      BILReader := TEzBILReader.Create(filnam);
  end;
  Try
    case ImgFormat of
      ifBitmap:
        begin
          BitmapEx.BufferBitmap := Self.BufferBitmap;
          BitmapEx.AlphaChannel := Self.AlphaChannel;
          BitmapEx.PainterObject := Self.PainterObject;
        end;
      ifTiff:
{$IFDEF USE_GRAPHICEX}
        begin
          TiffEx.BufferBitmap := Self.BufferBitmap;
          TiffEx.AlphaChannel := Self.AlphaChannel;
          TiffEx.PainterObject := Self.PainterObject;
        end
{$ENDIF}
        ;
      ifBIL:
        begin
          BILReader.BufferBitmap := Self.BufferBitmap;
          BILReader.AlphaChannel := Self.AlphaChannel;
          BILReader.PainterObject := Self.PainterObject;
        end;
    end;
    If IsBoxFullInBox2D( fBox, Clip ) Then
    Begin
      Dest := ReorderRect( Grapher.RealToRect( FBox ) );
      With Dest Do
        case ImgFormat of
          ifBitmap:
            BitmapEx.BitDIBFromFileInBands( filnam,
              FStream,
              Canvas.Handle,
              Left,
              Top,
              ( Right - Left ),
              ( Bottom - Top ),
              ( Bottom - Top ),
              0, 0,
              BitmapWidth,
              BitmapHeight,
              Ez_Preferences.BandsBitmapChunkSize );
          ifTiff:
{$IFDEF USE_GRAPHICEX}
            TiffEx.TiffFromFileInStrips( filnam,
              Stream,
              Canvas.Handle,
              Left,
              Top,
              ( Right - Left ),
              ( Bottom - Top ),
              ( Bottom - Top ),
              0, 0,
              BitmapWidth,
              BitmapHeight )
{$ENDIF}
            ;
          ifBIL:
            BILReader.BILFromFileInBands( FStream, Canvas.Handle,
              Left,
              Top,
              ( Right - Left ),
              ( Bottom - Top ),
              ( Bottom - Top ),
              0, 0,
              BitmapWidth,
              BitmapHeight,
              Ez_Preferences.BandsBitmapChunkSize );
        end;
    End
    Else
    Begin
      // Calculate image rectangle
      Work := IntersectRect2D( FBox, Clip );
      If IsRectEmpty2D( Work ) Then  Exit;

      Dest := Grapher.RealToRect( Work );
      BmpRect := Grapher.RealToRect( fBox );
      Src := Dest;
      With BmpRect Do
      Begin
        fx := BitmapWidth / ( Right - Left );
        fy := BitmapHeight / ( bottom - top );
        OffsetRect( Src, -Left, -Top );
      End;
      L := round( Src.Left * fx );
      T := round( Src.Top * fy );
      W := round( ( Src.Right - Src.Left ) * fx );
      H := round( ( Src.Bottom - Src.Top ) * fy );
      If ( W = 0 ) Or ( H = 0 ) Then Exit;
      With Dest Do
        case ImgFormat of
          ifBitmap:
            BitmapEx.BitDIBFromFileInBands( filnam,  // a bitmap
              FStream,
              Canvas.Handle,
              Left,
              Top,
              ( Right - Left ),
              ( Bottom - Top ),
              ( BmpRect.Bottom - BmpRect.Top ),
              L, T, W, H,
              Ez_Preferences.BandsBitmapChunkSize );
          ifTiff:
{$IFDEF USE_GRAPHICEX}
            TiffEx.TiffFromFileInStrips( filnam,
              FStream,
              Canvas.Handle,
              Left,
              Top,
              ( Right - Left ),
              ( Bottom - Top ),
              ( BmpRect.Bottom - BmpRect.Top ),
              L, T, W, H );
{$ENDIF}
          ifBIL:
            BILReader.BILFromFileInBands( FStream, Canvas.Handle,  // a .BIL
              Left,
              Top,
              ( Right - Left ),
              ( Bottom - Top ),
              ( BmpRect.Bottom - BmpRect.Top ),
              L, T, W, H,
              Ez_Preferences.BandsBitmapChunkSize );
        end;
    End;
    case ImgFormat of
      ifBitmap:
        Self.WasSuspended := BitmapEx.WasSuspended;
      ifTiff:
        {$IFDEF USE_GRAPHICEX}WasSuspended := TiffEx.WasSuspended{$ENDIF};
      ifBIL:
        Self.WasSuspended := BILReader.WasSuspended
    end;
  Finally
    case ImgFormat of
      ifBitmap:
        BitmapEx.Free;
      ifTiff:
{$IFDEF USE_GRAPHICEX}
        TiffEx.Free;
{$ENDIF}
      ifBIL:
        BILReader.Free;
    end;
    If PreloadedSet Then
      FStream := Nil;
  End;
End;

Function TEzBandsBitmap.GetDrawPoints: TEzVector;
Begin
  If FVector = Nil Then
    FVector := TEzVector.Create( 5 );
  Result := FVector;
End;

Procedure TEzBandsBitmap.LoadFromStream( Stream: TStream );
Var
  Reserved: Array[0..49] Of byte;
Begin
  Inherited LoadFromStream( stream );
  FFileName := EzReadStrFromStream( stream );
  stream.Read( FAlphaChannel, sizeof( Byte ) );
  stream.Read( Reserved, sizeof( Reserved ) );
  FPoints.CanGrow := false;
  UpdateExtension;
End;

Procedure TEzBandsBitmap.SaveToStream( Stream: TStream );
Var
  Reserved: Array[0..49] Of byte;
Begin
  Inherited SaveToStream( Stream );
  EzWriteStrToStream( FFileName, stream );
  stream.Write( FAlphaChannel, sizeof( Byte ) );
  stream.Write( Reserved, sizeof( Reserved ) );
End;

Function TEzBandsBitmap.StorageSize: Integer;
Begin
  Result := Inherited StorageSize + Length( FFileName );
End;

Procedure TEzBandsBitmap.UpdateExtension;
Begin
  Inherited UpdateExtension;
  If FPoints.Count <> 2 Then Exit;
  If FVector = Nil Then
  Begin
    FVector := TEzVector.Create( 5 );
    FVector.CanGrow := False;
  End
  Else
    FVector.Clear;
  With FVector Do
  Begin
    Add( FPoints[0] );
    Add( Point2D( FPoints[0].X, FPoints[1].Y ) );
    Add( FPoints[1] );
    Add( Point2D( FPoints[1].X, FPoints[0].Y ) );
    Add( FPoints[0] );
  End;
End;

function TEzBandsBitmap.IsEqualTo(Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean;
begin
  Result:= False;
  if Not ( Entity.EntityID = idBandsBitmap ) Or
    ( Inherited IsEqualTo( Entity, IncludeAttribs ) = False )
    {$IFDEF FALSE}Or
    ( IncludeAttribs And ( FFileName <> TEzBandsBitmap(Entity).FFileName ) ){$ENDIF} Then Exit;
  Result:= True;
end;

{------------------------------------------------------------------------------}
{                  TEzSpline                                                 }
{------------------------------------------------------------------------------}

Function Knot( I, K, N: Integer ): Integer;
Begin
  If I < K Then
    Result := 0
  Else If I > N Then
    Result := N - K + 2
  Else
    Result := I - K + 1;
End;

Function NBlend( I, K, OK, N: Integer; U: Double ): Double;
Var
  T: Integer;
  V: Double;
Begin
  If K = 1 Then
  Begin
    V := 0;
    If ( Knot( i, OK, N ) <= u ) And ( u < Knot( i + 1, OK, N ) ) Then
      V := 1;
  End
  Else
  Begin
    V := 0;
    T := Knot( I + K - 1, OK, N ) - Knot( I, OK, N );
    If T <> 0 Then
      V := ( U - Knot( I, OK, N ) ) * NBlend( I, K - 1, OK, N, U ) / T;
    T := Knot( I + K, OK, N ) - Knot( I + 1, OK, N );
    If T <> 0 Then
      V := V + ( Knot( I + K, OK, N ) - U ) * NBlend( I + 1, K - 1, OK, N, U ) / T;
  End;
  Result := V;
End;

Function BSpline2D( U: Double; N, K: Integer; Const Points: TEzVector ): TEzPoint;
Var
  I: Integer;
  B: Double;
Begin
  Result := Point2D( 0, 0 );
  For I := 0 To N Do
  Begin
    B := NBlend( I, K, K, N, U );
    Result.X := Result.X + Points[I].X * B;
    Result.Y := Result.Y + Points[I].Y * B;
  End;
End;

Procedure CreateSpline( Order, PointsInCurve: Integer; ControlPoints, CurvePoints: TEzVector );
Var
  cnt: Integer;
Begin
  CurvePoints.Clear;
  If PointsInCurve <= ControlPoints.Count Then
    PointsInCurve := ControlPoints.Count * 10;
  // 10=arbitrarily given. This can result in low speed redrawing
  For cnt := 0 To PointsInCurve - 1 Do
    CurvePoints.Add( BSpline2D( cnt / PointsInCurve * ( ControlPoints.Count - 2 ),
      ControlPoints.Count - 1, Order, ControlPoints ) );
  If ControlPoints.Count > Order Then
    CurvePoints.Add( ControlPoints[ControlPoints.Count - 1] );
End;

Function TEzSpline.GetEntityID: TEzEntityID;
Begin
  result := idSpline;
End;

{$IFDEF BCB}
function TEzSpline.GetOrder: Byte;
begin
  Result := FOrder;
end;

function TEzSpline.GetPointsInCurve: Word;
begin
  Result := FPointsInCurve;
end;

procedure TEzSpline.SetOrder(const Value: Byte);
begin
  FOrder := Value;
end;

procedure TEzSpline.SetPointsInCurve(const Value: Word);
begin
  FPointsInCurve := Value;
end;
{$ENDIF}

Procedure TEzSpline.GetCurvePoints;
Begin
  If FCurvePoints = Nil Then
  Begin
    If FPointsInCurve = 0 Then
      FPointsInCurve := 100;
    If FOrder = 0 Then
      FOrder := 3;
    FCurvePoints := TEzVector.Create( FPointsInCurve );
  End;
  CreateSpline( FOrder, FPointsInCurve, Points, FCurvePoints );
End;

Destructor TEzSpline.Destroy;
Begin
  If FCurvePoints <> Nil Then
    FCurvePoints.Free;
  Inherited Destroy;
End;

Procedure TEzSpline.Initialize;
begin
  inherited;
  FPointsInCurve := Ez_Preferences.SplineSegs;
  FOrder := 3;
  FCurvePoints := TEzVector.Create( FPointsInCurve );
end;

Function TEzSpline.BasicInfoAsString: string;
Begin
  Result:= Format(sSplineInfo, [FPoints.AsString]);
End;

Procedure TEzSpline.LoadFromStream( Stream: TStream );
Begin
  { Load the standard properties }
  Inherited LoadFromStream( Stream );
  With Stream Do
  Begin
    Read( FOrder, SizeOf( FOrder ) );
    Read( FPointsInCurve, SizeOf( FPointsInCurve ) );
  End;
  If FCurvePoints <> Nil Then
    FreeAndNil( FCurvePoints );
  UpdateExtension;
End;

Procedure TEzSpline.SaveToStream( Stream: TStream );
Begin
  Inherited SaveToStream( Stream );
  With Stream Do
  Begin
    Write( FOrder, SizeOf( FOrder ) );
    Write( FPointsInCurve, SizeOf( FPointsInCurve ) );
  End;
End;

Function TEzSpline.GetDrawPoints: TEzVector;
Begin
  GetCurvePoints;
  Result := FCurvePoints;
End;

Procedure TEzSpline.Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
  DrawMode: TEzDrawMode; Data: Pointer = Nil );
var
  OldStyle: TPenstyle;
  Poly: TEzEntity;
begin
  If (DrawMode = dmRubberPen) And (ID<>-2) then
  begin
    Oldstyle:= Canvas.Pen.Style;
    Canvas.Pen.Style:= psDot;
    Poly:= TEzPolyline.Create( Self.Points.Count );
    try
      Poly.SetTransformMatrix( Self.GetTransformMatrix);
      Poly.Points.Assign( Self.Points );
      Poly.Draw( Grapher, Canvas, Clip, DrawMode, Data );
    finally
      Poly.free;
      Canvas.Pen.Style:= Oldstyle;
    end;
  end;
  inherited Draw( Grapher, Canvas, CLip, DrawMode, Data );
end;

{------------------------------------------------------------------------------}
{                  TEzGroupEntity                                            }
{------------------------------------------------------------------------------}

Constructor TEzGroupEntity.CreateEntity;
Begin
  Inherited Create( 2, False );
End;

Destructor TEzGroupEntity.Destroy;
Begin
  Clear;
  FEntities.Free;
  Inherited Destroy;
End;

Procedure TEzGroupEntity.Initialize;
begin
  FEntities:= TList.Create;
end;

Function TEzGroupEntity.BasicInfoAsString: string;
var
  I: Integer;
Begin
  Result:= sGroupCaption + CrLf ;
  For I:= 0 to FEntities.Count-1 do
    Result:= Result + TEzEntity(FEntities[I]).AsString(true,false,nil) + CrLf;
  Result:= Result + '}';
End;

Function TEzGroupEntity.GetEntityID: TEzEntityID;
Begin
  result := idGroup;
End;

{$IFDEF BCB}
function TEzGroupEntity.GetGroupType: TEzGroupType;
begin
  Result := FGroupType;
end;

procedure TEzGroupEntity.SetGroupType(const Value: TEzGroupType);
begin
  FGroupType := Value;
end;
{$ENDIF}

Function TEzGroupEntity.GetEntities( Index: Integer ): TEzEntity;
Begin
  If FEntities = Nil Then
    FEntities := TList.Create;
  Result := Nil;
  If ( Index < 0 ) Or ( Index > FEntities.Count - 1 ) Then Exit;
  result := TEzEntity( FEntities[Index] );
End;

Procedure TEzGroupEntity.Clear;
Var
  i: Integer;
Begin
  self.SetTransformMatrix( IDENTITY_MATRIX2D );
  For i := 0 To Count - 1 Do
    Entities[i].Free;
  FEntities.Clear;
  UpdateExtension;
End;

Procedure TEzGroupEntity.Add( Ent: TEzEntity );
Begin
  If FEntities = Nil Then
    FEntities := TList.Create;
  FEntities.Add( Ent );
  UpdateExtension;
End;

Function TEzGroupEntity.Count: Integer;
Begin
  If FEntities = Nil Then
    FEntities := TList.Create;
  result := FEntities.Count;
End;

Procedure TEzGroupEntity.LoadFromStream( Stream: TStream );
Var
  i, n: Integer;
  TmpClass: TEzEntityClass;
  TmpEntity: TEzEntity;
  EntityID: TEzEntityID;
Begin
  Clear;
  FPoints.DisableEvents := true;
  Try
    FPoints.Clear;
    With Stream Do
    Begin
      Read( ID, SizeOf( ID ) );
      Read( FGroupType, sizeof( FGroupType ) );
      FPoints.LoadFromStream( Stream );
      { read the entities of this group }
      Read( n, sizeof( n ) );
      For i := 1 To n Do
      Begin
        Read( EntityID, SizeOf( TEzEntityID ) );
        TmpClass := GetClassFromID( EntityID );
        TmpEntity := TmpClass.Create( 1 );
        TmpEntity.LoadFromStream( Stream );
        FEntities.Add( TmpEntity );
      End;
    End;
    FPoints.CanGrow := False;
    FPoints.OnChange := UpdateExtension;
    FOriginalSize := StorageSize;
  Finally
    FPoints.DisableEvents := false;
  End;
  UpdateExtension;
End;

Procedure TEzGroupEntity.SaveToStream( Stream: TStream );
Var
  i, n: Integer;
  EntityID: TEzEntityID;
  TmpEnt: TEzEntity;
Begin
  With Stream Do
  Begin
    Write( ID, SizeOf( ID ) );
    Write( FGroupType, sizeof( FGroupType ) );
    FPoints.SaveToStream( Stream );
    n := Self.Count;
    Write( n, SizeOf( n ) );
    For I := 0 To N - 1 Do
    Begin
      TmpEnt := Entities[I];
      EntityID := TmpEnt.EntityID;
      Write( EntityID, SizeOf( EntityID ) );
      TmpEnt.SaveToStream( Stream );
    End;
  End;
  FOriginalSize := StorageSize;
End;

Function TEzGroupEntity.StorageSize: Integer;
Var
  i: integer;
Begin
  result := Inherited StorageSize;
  For i := 0 To Count - 1 Do
    result := result + Entities[i].StorageSize;
End;

Procedure TEzGroupEntity.UpdateExtension;
Var
  i: integer;
  TmpR, BBox: TEzRect;
Begin
  BBox := INVALID_EXTENSION;
  For i := 0 To Count - 1 Do
  Begin
    TmpR := Entities[i].FBox;
    BBox.Emin.X := dMin( BBox.Emin.X, TmpR.Emin.X );
    BBox.Emin.Y := dMin( BBox.Emin.Y, TmpR.Emin.Y );
    BBox.Emax.X := dMax( BBox.Emax.X, TmpR.Emax.X );
    BBox.Emax.Y := dMax( BBox.Emax.Y, TmpR.Emax.Y );
  End;
  FPoints.DisableEvents := true;
  FPoints[0] := BBox.Emin;
  FPoints[1] := BBox.Emax;
  FPoints.DisableEvents := false;
  Inherited;
End;

Procedure TEzGroupEntity.ApplyTransform;
Var
  I: integer;
Begin
  For i := 0 To Count - 1 Do
  Begin
    Entities[i].SetTransformMatrix( Self.GetTransformMatrix );
    Entities[i].ApplyTransform;
  End;
  Inherited ApplyTransform;
End;

Procedure TEzGroupEntity.MoveAndRotateControlPts( Var MovePt, RotatePt: TEzPoint; Grapher: TEzGrapher );
Begin
  If Not EqualPoint2d(Ez_Preferences.GRotatePoint, INVALID_POINT) Then
  Begin
    MovePt:= Ez_Preferences.GRotatePoint;
  End Else
  Begin
    Self.Centroid( MovePt.X, MovePt.Y );
  End;
  RotatePt.Y := MovePt.Y;
  If Grapher <> Nil Then
    RotatePt.X := MovePt.X + Grapher.DistToRealX(Grapher.ScreenDpiX div 2)
  Else
    RotatePt.X := MovePt.X + ( FBox.Emax.X - MovePt.X ) * ( 2 / 3 );
End;

Function TEzGroupEntity.GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector;
Var
  MovePt, RotatePt: TEzPoint;
Begin
  Result := Nil;
  If FGroupType In [gtNone, gtFitToPath] Then
  Begin
    Result := TEzVector.Create( FPoints.Count + 2 );
    Result.Assign( FPoints );
    if TransfPts then
    begin
      MoveAndRotateControlPts( MovePt, RotatePt, Grapher );
      Result.Add( MovePt );
      Result.Add( RotatePt );
    end;
  End;
End;

Function TEzGroupEntity.GetControlPointType( Index: Integer ): TEzControlPointType;
Begin
  Result := cptNode;
  If FGroupType In [gtNone, gtFitToPath] Then
  Begin
    If Index = 2 Then
      Result := cptMove
    Else If Index = 3 Then
      Result := cptRotate;
  End;
End;

Procedure TEzGroupEntity.UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil );
Var
  PrevBox, NewBox: TEzRect;
  ScaleX, ScaleY, Tx, Ty, DeltaX, DeltaY, Angle: Double;
  M: TEzMatrix;
  i: Integer;
  MovePt, RotatePt, TmpCentr: TEzPoint;
Begin
  If FGroupType In [gtNone, gtFitToPath] Then
  Begin
    If ( Index = 0 ) Or ( Index = 1 ) Then // reshaping
    Begin
      PrevBox := FPoints.Extension;
      FPoints.DisableEvents := true;
      Points[Index] := Value;
      FPoints.DisableEvents := false;
      NewBox := FPoints.Extension;
      ScaleX := Abs( NewBox.X1 - NewBox.X2 ) / Abs( PrevBox.X1 - PrevBox.X2 );
      ScaleY := Abs( NewBox.Y1 - NewBox.Y2 ) / Abs( PrevBox.Y1 - PrevBox.Y2 );
      Tx := NewBox.X1 - PrevBox.X1;
      Ty := NewBox.Y1 - PrevBox.Y1;
      M := MultiplyMatrix2d( Translate2d( Tx, Ty ), Scale2d( ScaleX, ScaleY, PrevBox.Emin ) );
      For i := 0 To Count - 1 Do
      Begin
        Entities[i].SetTransformMatrix( M );
        Entities[i].ApplyTransform;
      End;
      UpdateExtension;
    End
    Else If Index = 2 Then // moving
    Begin
      MoveAndRotateControlPts( MovePt, RotatePt, Grapher );
      Tx := Value.X - Movept.X;
      Ty := Value.Y - Movept.Y;
      M := Translate2d( Tx, Ty );
      For i := 0 To Count - 1 Do
      Begin
        Entities[i].SetTransformMatrix( M );
        Entities[i].ApplyTransform;
      End;
    End
    Else If Index = 3 Then // rotating
    Begin
      Self.Centroid( MovePt.X, MovePt.Y );
      Angle := Angle2d( MovePt, Value );
      M := Rotate2d( Angle, MovePt );
      For i := 0 To Count - 1 Do
      Begin
        If Entities[i].ClassType = TEzRectangle Then
        Begin
          With TEzRectangle( Entities[i] ) Do
          Begin
            Rotangle := Rotangle + Angle;
            Centroid( TmpCentr.X, TmpCentr.Y );
            TmpCentr := TransformPoint2d( TmpCentr, M );
            DeltaX := ( Points[1].X - Points[0].X ) / 2;
            DeltaY := ( Points[1].Y - Points[0].Y ) / 2;
            Points[0] := Point2d( TmpCentr.X - DeltaX, TmpCentr.Y - DeltaY );
            Points[1] := Point2d( TmpCentr.X + DeltaX, TmpCentr.Y + DeltaY );
          End;
        End
        Else
        Begin
          Entities[i].SetTransformMatrix( M );
          Entities[i].ApplyTransform;
        End;
      End;
    End;
  End;
End;

Procedure TEzGroupEntity.Draw( Grapher: TEzGrapher;
  Canvas: TCanvas; Const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer = Nil );
Var
  i: Integer;
Begin
  If DrawMode = dmRubberPen Then
  Begin
    For i := 0 To Count - 1 Do
    Begin
      Entities[i].SetTransformMatrix( Self.GetTransformMatrix );
      Entities[i].Draw( Grapher, Canvas, Clip, DrawMode );
      If FGroupType = gtFitToPath Then
        break;
    End;
    exit;
  End;
  If FGroupType = gtFitToPath Then
  Begin
    { when it is fit to path, there must be two entities:
      - first entity is the path
      - second entity is the text }
    Entities[0].Draw( Grapher, Canvas, Clip, DrawMode );
    If Entities[1].EntityID = idFittedVectText Then
    Begin
      TEzFittedVectorText( Entities[1] ).DrawToPath(
        Entities[0].DrawPoints, True, Grapher, Canvas, Clip, DrawMode );
    End;
  End
  Else
  Begin
    For i := 0 To Count - 1 Do
      Entities[i].Draw( Grapher, Canvas, Clip, DrawMode );
  End;
End;

Function TEzGroupEntity.PointCode( Const Pt: TEzPoint;
  Const Aperture: Double; Var Distance: Double;
  SelectPickingInside: Boolean; UseDrawPoints: Boolean = True ): Integer;
Var
  I: Integer;
Begin
  Result := PICKED_NONE;
  For I := 0 To Count - 1 Do
  Begin
    Result := Entities[I].PointCode( Pt, Aperture, Distance, SelectPickingInside, UseDrawPoints );
    If Result >= PICKED_INTERIOR Then Break;
  End;
  If Result > PICKED_INTERIOR Then
  Begin
    Result := PICKED_POINT;
    Ez_Preferences.GNumPoint:= 0;
  End;
End;

Procedure TEzGroupEntity.InternalClearList;
Begin
  FEntities.Clear;
  UpdateExtension;
End;

function TEzGroupEntity.IsEqualTo(Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean;
Var
  I: Integer;
Begin
  Result := False;
  if (Entity.EntityID <> idGroup) Or ( Count <> TEzGroupEntity(Entity).Count) then Exit;
  For I := 0 To Count - 1 Do
    If Not Entities[I].IsEqualTo( TEzGroupEntity(Entity).Entities[I], IncludeAttribs ) then Exit;
  Result:= True;
end;

{-------------------------------------------------------------------------------}
{                  Vectorial fonts                                              }
{-------------------------------------------------------------------------------}

{ TEzVectorChar }

Constructor TEzVectorChar.Create;
Begin
  Inherited Create;
  FVector := TEzVector.Create( 10 );
End;

Destructor TEzVectorChar.Destroy;
Begin
  FVector.Free;
  Inherited Destroy;
End;

Procedure TEzVectorChar.UpdateExtension;
Begin
  If FVector.Count = 0 Then
    FExtension := Rect2D( 0, 0, 0, 0 )
  Else
    FExtension := FVector.Extension;
End;

Procedure TEzVectorChar.LoadFromStream( stream: TStream );
Var
  I, n: Integer;
  tempw: Word;
  TmpPt: TEzPoint;
Begin
  FVector.DisableEvents := true;
  Try
    FVector.Clear;
    With Stream Do
    Begin
      { read the parts }
      Stream.Read( n, SizeOf( Integer ) );
      If n > 1 Then
      Begin
        FVector.Parts.Clear;
        For I := 1 To n Do
        Begin
          Stream.Read( tempw, SizeOf( Word ) );
          FVector.Parts.Add( tempw );
        End;
      End;
      { read the points }
      Read( n, sizeof( Integer ) );
      FVector.Capacity := n;
      For I := 1 To n Do
      Begin
        Read( TmpPt, SizeOf( TEzPoint ) );
        FVector.Add( TmpPt );
      End;
    End;
  Finally
    FVector.DisableEvents := False;
  End;
  UpdateExtension;
End;

Procedure TEzVectorChar.SaveToStream( stream: TStream );
Var
  I, n: Integer;
  tempw: Word;
  TmpPt: TEzPoint;
Begin
  With Stream Do
  Begin
    { write the parts }
    n := FVector.Parts.Count;
    Write( n, sizeof( Integer ) );
    If n > 1 Then
      For I := 0 To n - 1 Do
      Begin
        tempw := FVector.Parts[i];
        Stream.Write( tempw, SizeOf( Word ) );
      End;
    { write the points }
    n := FVector.Count;
    Write( n, sizeof( Integer ) );
    For I := 0 To n - 1 Do
    Begin
      TmpPt := FVector[I];
      Write( TmpPt, sizeof( TEzPoint ) );
    End;
  End;
End;

{ TEzVectorFont }

Constructor TEzVectorFont.Create;
Begin
  Inherited Create;
  FChars := TEzVectorCharList.Create;
End;

Destructor TEzVectorFont.Destroy;
Begin
  FChars.Free;
  Inherited Destroy;
End;

Function TEzVectorFont.GetChar( Index: Integer ): TEzVectorChar;
Begin
  Result := FChars[Index];
End;

Procedure TEzVectorFont.SetChar( Index: Integer; VectorChar: TEzVectorChar );
Var
  Prev: TEzVectorChar;
Begin
  Prev := FChars[Index];
  FChars[Index] := VectorChar;
  If Prev <> Nil Then
    Prev.Free;
End;

Function TEzVectorFont.GetTextExtension( Const Value: String;
  Const Height,
  InterCharSpacing,
  InterLineSpacing: Double ): TEzRect;
Var
  I: Integer;
  Ch: AnsiChar;
  VectorChar: TEzVectorChar;
  RowWidth: Double;
  RowHeight: Double;
  MaxRowWidth: Double;
Begin
  Result := Rect2D( 0.0, 1.0, 0.0, Height );
  MaxRowWidth := 0.0;
  RowWidth := 0.0;
  RowHeight := 0.0;
  For I := 1 To Length( Value ) Do
  Begin
    Ch := Value[I];
    VectorChar := GetChar( Ord( Ch ) );
    If VectorChar <> Nil Then
      With VectorChar.Extension Do
      Begin
        RowWidth := RowWidth + ( X2 + InterCharSpacing );
        RowHeight := dMax( RowHeight, 1.0 - Y1 );
      End
    Else If Ch = #32 Then // the SPACE
      RowWidth := RowWidth + ( 0.50 + InterCharSpacing )
    Else If Ch <> #13 Then
      With Ez_VectorFonts.NullChar.Extension Do
        RowWidth := RowWidth + ( X2 + InterCharSpacing );
    If Ch = #13 Then // ONE MORE LINE
    Begin
      MaxRowWidth := dMax( MaxRowWidth, RowWidth - InterCharSpacing );
      Result.Y1 := Result.Y1 - ( InterLineSpacing + RowHeight );
      RowWidth := 0.0;
      RowHeight := 0.0;
    End;
  End;
  MaxRowWidth := dMax( MaxRowWidth, RowWidth - InterCharSpacing );
  Result.Y1 := ( Result.Y1 - RowHeight ) * Height;
  Result.X2 := MaxRowWidth * Height;
End;

Function TEzVectorFont.GetFittedTextExtension( Const Value: String;
  InterCharSpacing: Double ): TEzRect;
Var
  I: Integer;
  Ch: AnsiChar;
  VectorChar: TEzVectorChar;
Begin
  Result := Rect2d( 0, 1, 0, 0 );
  For I := 1 To Length( Value ) Do
  Begin
    Ch := Value[I];
    VectorChar := GetChar( Ord( Ch ) );
    If VectorChar <> Nil Then
      With VectorChar.Extension Do
      Begin
        If I = 1 Then
          Result.X1 := X1;
        Result.X2 := Result.X2 + ( X2 + InterCharSpacing );
        Result.Y1 := dMin( Result.Y1, Y1 );
        Result.Y2 := dMax( Result.Y2, Y2 );
      End
    Else If Ch = #32 Then // the SPACE
      Result.X2 := Result.X2 + ( 0.50 + InterCharSpacing )
    Else If Ch <> #13 Then
      With Ez_VectorFonts.NullChar.Extension Do
        Result.X2 := Result.X2 + ( X2 + InterCharSpacing );
  End;
  Result.X2 := Result.X2 - InterCharSpacing;
End;

Procedure TEzVectorFont.LoadFromStream( Stream: TStream );
Var
  I, n, NumChar: Integer;
  VectorChar: TEzVectorChar;
Begin
  FChars.Clear;
  With stream Do
  Begin
    { read the name of the font }
    FName := EzReadStrFromStream( stream );
    { read the maximum character }
    Read( FMaxChar, sizeof( FMaxChar ) );
    FChars.Capacity := FMaxChar;
    { read the number of characters for this font }
    Read( n, sizeof( Integer ) );
    For I := 1 To n Do
    Begin
      { read the character num }
      Read( NumChar, sizeof( Integer ) );
      VectorChar := TEzVectorChar.Create;
      Try
        VectorChar.LoadFromStream( stream );
      Except
        VectorChar.free;
        Raise;
      End;
      FChars[NumChar] := VectorChar;
    End;
  End;
End;

Procedure TEzVectorFont.SaveToStream( Stream: TStream );
Var
  I, n, NumChar: Integer;
Begin
  { count the characters }
  n := 0;
  For I := 0 To FMaxChar Do
    If FChars[I] <> Nil Then
      Inc( n );
  With stream Do
  Begin
    { write the name of the font }
    EzWriteStrToStream( FName, stream );
    { write the maximum character }
    Write( FMaxChar, sizeof( FMaxChar ) );
    Write( n, sizeof( Integer ) );
    For I := 0 To FMaxChar Do
    Begin
      If FChars[I] = Nil Then
        Continue;
      NumChar := I;
      Write( NumChar, sizeof( Integer ) );
      TEzVectorChar( FChars[I] ).SaveToStream( Stream );
    End;
  End;
End;

Procedure TEzVectorFont.LoadFromFile( Const FileName: String );
Var
  stream: TStream;
Begin
  stream := TFileStream.create( FileName, fmOpenRead Or fmShareDenyNone );
  Try
    LoadFromStream( stream );
  Finally
    stream.free;
  End;
End;

Procedure TEzVectorFont.SaveToFile( Const FileName: String );
Var
  stream: TStream;
Begin
  stream := TFileStream.create( FileName, fmCreate );
  Try
    SaveToStream( stream );
  Finally
    stream.free;
  End;
End;

Procedure TEzVectorFont.SetMaxChar( Value: Integer );
Begin
  FMaxChar := Value;
  FChars.Capacity := Value;
End;

{ TEzVectorFonts }

Constructor TEzVectorFonts.Create;
Begin
  Inherited Create;
  FFontList := TList.create;
  FNullChar := TEzVectorChar.Create;
  FNullChar.FVector.AddPoint( 0.0, 0.0 );
  FNullChar.FVector.AddPoint( 0.8, 0.0 );
  FDefaultFont := Nil;
End;

Destructor TEzVectorFonts.Destroy;
Begin
  Clear;
  FFontList.Free;
  FNullChar.Free;
  Inherited Destroy;
End;

Function TEzVectorFonts.Count: Integer;
Begin
  result := FFontList.Count;
End;

Procedure TEzVectorFonts.AddFont( VectorFont: TEzVectorFont );
Begin
  FFontList.Add( VectorFont );
  If FDefaultFont = Nil Then
  begin
    FDefaultFont := VectorFont;
  end;
End;

Procedure TEzVectorFonts.AddFontFile( Const FileName: String );
Var
  stream: TStream;
  VectorFont: TEzVectorFont;
Begin
  If Not FileExists( Filename ) Then Exit;

  stream := TFileStream.Create( FileName, fmOpenRead Or fmShareDenyNone );
  Try
    VectorFont := TEzVectorFont.Create;
    Try
      VectorFont.LoadFromStream( Stream );
    Except
      VectorFont.Free;
      Raise;
    End;
    FFontList.Add( VectorFont );
    If FDefaultFont = Nil Then
    begin
      FDefaultFont := VectorFont;
    end;
  Finally
    stream.free;
  End;
End;

Procedure TEzVectorFonts.Clear;
Var
  I: Integer;
Begin
  For I := 0 To FFontList.Count - 1 Do
    TEzVectorFont( FFontList[I] ).Free;
  FFontList.Clear;
End;

Procedure TEzVectorFonts.Delete( Index: Integer );
Begin
  If ( Index < 0 ) Or ( Index < FFontList.Count - 1 ) Then Exit;
  TEzVectorFont( FFontList[Index] ).Free;
  FFontList.Delete( Index );
End;

Procedure TEzVectorFonts.DeleteByName( Const FontName: String );
Var
  I: Integer;
Begin
  For I := 0 To FFontList.Count - 1 Do
    If AnsiCompareText( TEzVectorFont( FFontList[I] ).Name, FontName ) = 0 Then
    Begin
      TEzVectorFont( FFontList[I] ).Free;
      FFontList.Delete( I );
      Exit;
    End;
End;

Function TEzVectorFonts.FontByIndex( Index: Integer ): TEzVectorFont;
Begin
  If ( Index >= 0 ) And ( Index <= FFontList.Count - 1 ) Then
    Result := TEzVectorFont( FFontList[Index] )
  Else
    Result := GetDefaultFont;
End;

Function TEzVectorFonts.FontByName( Const FontName: String ): TEzVectorFont;
Var
  I: Integer;
Begin
  For I := 0 To FFontList.Count - 1 Do
    If AnsiCompareText( TEzVectorFont( FFontList[I] ).Name, FontName ) = 0 Then
    Begin
      Result := TEzVectorFont( FFontList[I] );
      Exit;
    End;
  Result := GetDefaultFont;
End;

Function TEzVectorFonts.IndexOfFont( VectorFont: TEzVectorFont ): Integer;
Var
  I: Integer;
Begin
  Result := -1;
  For I := 0 To FFontList.Count - 1 Do
    If TEzVectorFont( FFontList[I] ) = VectorFont Then
    Begin
      Result := I;
      Exit;
    End;
End;

Function TEzVectorFonts.IndexOfFontByName( Const FontName: String ): Integer;
Var
  I: Integer;
Begin
  Result := -1;
  For I := 0 To FFontList.Count - 1 Do
    If AnsiCompareText( TEzVectorFont( FFontList[I] ).Name, FontName ) = 0 Then
    Begin
      Result := I;
      Exit;
    End;
End;

Function TEzVectorFonts.Get( Index: Integer ): TEzVectorFont;
Begin
  Result := Nil;
  If ( Index < 0 ) Or ( Index > FFontList.Count - 1 ) Then
    Exit;
  Result := TEzVectorFont( FFontList[Index] );
End;

Procedure TEzVectorFonts.PopulateTo( Strings: TStrings );
Var
  I: Integer;
Begin
  Strings.Clear;
  For I := 0 To FFontList.Count - 1 Do
    Strings.Add( TEzVectorFont( FFontList[I] ).Name );
End;

Procedure TEzVectorFonts.SetDefaultFontByIndex( Index: Integer );
Begin
  If ( Index < 0 ) Or ( Index > FFontList.Count - 1 ) Then
    Exit;
  FDefaultFont := TEzVectorFont( FFontList[Index] );
End;

Procedure TEzVectorFonts.SetDefaultFontByName( Const FontName: String );
Var
  I: Integer;
Begin
  For I := 0 To FFontList.Count - 1 Do
    If AnsiCompareText( TEzVectorFont( FFontList[I] ).Name, FontName ) = 0 Then
    Begin
      FDefaultFont := TEzVectorFont( FFontList[I] );
      Exit;
    End;
End;

Function TEzVectorFonts.GetDefaultFont: TEzVectorFont;
Begin
  If ( FDefaultFont = Nil ) And ( FFontList.Count > 0 ) Then
    FDefaultFont := TEzVectorFont( FFontList[0] );
  Result := FDefaultFont;
End;

{ TEzJustifVectorText }

Constructor TEzJustifVectorText.CreateEntity( Const TextBox: TEzRect;
  Const Height: Double; Const Text: String );
Begin
  Inherited CreateEntity( [NULL_POINT, NULL_POINT, NULL_POINT, NULL_POINT, NULL_POINT], False);
  FText := Text;
  If Length( FText ) = 0 Then FText := 'W';
  FHeight := Height;
  FAngle := Angle;

  FTextBox := ReorderRect2D( TextBox );
  PopulatePoints;
  DoNormalizedVector( FTextBox.Emin, FTextBox.Emax );

  UpdateExtension;
End;

procedure TEzJustifVectorText.Initialize;
begin
  inherited;
  FVectorFont := Ez_VectorFonts.FontByName( Ez_Preferences.DefFontStyle.Name );
  FFontColor := Ez_Preferences.DefFontStyle.Color;
  FInterCharSpacing := 0.10;
  FInterLineSpacing := 0.02;
  FHorzAlignment := haLeft;
  FVertAlignment := vaTop;
  PenTool.FPenStyle.Style := 0;
  BrushTool.FBrushStyle.Pattern := 0;
end;

Function TEzJustifVectorText.BasicInfoAsString: string;
Begin
  With FTextBox do
    Result:= Format(sJustifTextInfo, [X1,Y1,X2,Y2,FText,FHeight,RadToDeg(FAngle),
      FontColor,Ord(FHorzAlignment),Ord(FVertAlignment)]);
End;

Function TEzJustifVectorText.AttribsAsString: string;
Begin
  Result:= Format(sVectorFontInfo, [GetFontName]);
End;

Function TEzJustifVectorText.GetEntityID: TEzEntityID;
Begin
  result := idJustifVectText;
End;

Procedure TEzJustifVectorText.PopulatePoints;
Var
  I: Integer;
Begin
  If FPoints.Count = 5 Then Exit;
  FPoints.DisableEvents := true;
  FPoints.CanGrow:= True;
  Try
    For I := FPoints.Count + 1 To 5 Do
      FPoints.Add( NULL_POINT );
    FPoints[0] := FTextBox.Emin;
  Finally
    FPoints.DisableEvents := False;
    FPoints.CanGrow:= False;
  End;
End;

Procedure TEzJustifVectorText.DoNormalizedVector( Const Emin, Emax: TEzPoint );
Begin
  FPoints.DisableEvents := true;
  Try
    {
     3 +----------------+ 2
       |                |
     4 +----------------+ 1
       0
    }
    FPoints[0] := Emin;
    FPoints[1] := Point2D( Emax.X, Emin.Y );
    FPoints[2] := Emax;
    FPoints[3] := Point2D( Emin.X, Emax.Y );
    FPoints[4] := FPoints[0];
  Finally
    FPoints.DisableEvents := false;
  End;
End;

Procedure TEzJustifVectorText.ApplyTransform;
Var
  I: Integer;
  TransformedHeight, TransformedWidth: Double;
Begin
  //TextExt:= GetTextExtension;
  { Create the auxiliary basic vector }
  DoNormalizedVector( FTextBox.Emin, FTextBox.Emax );
  { apply the transformation matrix }
  FPoints.DisableEvents := true;
  Try
    { first apply the angle }
    DoRotation;
    { then apply the transformation matrix }
    For I := 0 To FPoints.Count - 1 Do
      FPoints[I] := TransformPoint2D( FPoints[I], Self.GetTransformMatrix );
  Finally
    FPoints.DisableEvents := False;
  End;
  { calculate the rotation angle for the text }
  FAngle := Angle2D( FPoints[0], FPoints[1] );
  //CurrHeight := Abs(TextExt.Emax.Y - TextExt.Emin.Y);
  { calculate transformed height and width }
  TransformedHeight := Dist2D( FPoints[0], FPoints[3] );
  TransformedWidth := Dist2D( FPoints[0], FPoints[1] );
  { calculate the new height by scaling the same proportion }
  //FHeight := FHeight * (TransformedHeight / CurrHeight );
  If FHeight > TransformedHeight Then
    FHeight := TransformedHeight;
  { now calculate the new rectangular area where the text is defined }
  FTextBox.Emin := FPoints[0];
  FTextBox.Emax := Point2D( FTextBox.Emin.X + TransformedWidth, FTextBox.Emin.Y + TransformedHeight );
  Self.SetTransformMatrix( IDENTITY_MATRIX2D );
  { and now, calculate the FPoints vector taking into account }
  UpdateExtension;
End;

Procedure TEzJustifVectorText.Draw( Grapher: TEzGrapher;
  Canvas: TCanvas; Const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer = Nil );
Var
  TextExt: TEzRect;
  CurrBasePt: TEzPoint;
  CharPos: Integer;
  WorkStr: String;
  WorkRow: String;
  TempPenStyle: TEzPenStyle;
  TempBrushStyle: TEzBrushStyle;

  Procedure DrawChar( Ch: AnsiChar; Var DrawPoint: TEzPoint );
  Var
    VectorChar: TEzVectorChar;
    TmpVectorChar: TEzVectorChar;
    TmpMatrix: TEzMatrix;
    TmpExt: TEzRect;
  Begin
    VectorChar := Nil;
    TmpVectorChar := FVectorFont.Chars[Ord( Ch )];
    If Ch = #32 Then
    Begin
      DrawPoint.X := DrawPoint.X + ( 0.5 + InterCharSpacing ) * FHeight;
      Exit;
    End
    Else If TmpVectorChar <> Nil Then
      VectorChar := TmpVectorChar
    Else If Ch <> #13 Then
      VectorChar := Ez_VectorFonts.FNullChar;
    If VectorChar = Nil Then
      Exit;
    With VectorChar Do
    Begin
      TmpExt := Extension;
      TmpMatrix := MultiplyMatrix2D( Translate2D( DrawPoint.X, DrawPoint.Y ),
        Scale2D( FHeight, FHeight, Point2D( 0, 0 ) ) );
      If FAngle <> 0 Then
        TmpMatrix := MultiplyMatrix2D( Rotate2D( FAngle, FPoints[0] ), TmpMatrix );

      FVector.DrawOpened( Canvas,
        Clip,
        FBox,
        Grapher,
        PenTool.FPenStyle,
        MultiplyMatrix2D( self.GetTransformMatrix, TmpMatrix ),
        DrawMode );
      DrawPoint.X := DrawPoint.X + ( TmpExt.X2 + FInterCharSpacing ) * FHeight;
    End;
  End;

  Procedure DrawTextLine( BasePt: TEzPoint; Const WkStr: String );
  Var
    I: Integer;
  Begin
    For I := 1 To Length( WkStr ) Do
      DrawChar( WkStr[I], BasePt );
  End;

Begin
  If ( FVectorFont = Nil ) Or Not Ez_Preferences.ShowText Then exit;
  { save current pen and fill attribs }
  TempPenStyle := PenTool.FPenStyle;
  TempBrushStyle := BrushTool.FBrushStyle;
  If DrawMode = dmRubberPen Then
    PenTool.FPenStyle.Style := 1;
  If ( PenTool.FPenStyle.Style <> 0 ) Or ( BrushTool.FBrushStyle.Pattern <> 0 )
    Or ( DrawMode = dmSelection ) Then
  Begin
    FPoints.DrawClosed( Canvas,
                        Clip,
                        FBox,
                        Grapher,
                        PenTool.FPenStyle,
                        BrushTool.FBrushStyle,
                        self.GetTransformMatrix,
                        DrawMode, Nil );
    If DrawMode In [dmRubberPen, dmSelection] Then
    Begin
      { restore pen and fill attribs }
      PenTool.FPenStyle := TempPenStyle;
      BrushTool.FBrushStyle := TempBrushStyle;
      Exit;
    End;
  End;
  { define the pen and fill attribs for the text }
  PenTool.FPenStyle.Style := 1;
  PenTool.FPenStyle.Scale := 0;
  PenTool.FPenStyle.Color := FontColor;
  BrushTool.FBrushStyle.Pattern := 0;

  TextExt := GetTextExtension;
  CurrBasePt.X := TextExt.X1;
  CurrBasePt.Y := TextExt.Y2 - FHeight;
  WorkStr := FText;
  CharPos := AnsiPos( #13, WorkStr );
  While CharPos > 0 Do
  Begin
    WorkRow := Copy( WorkStr, 1, CharPos - 1 );
    System.Delete( WorkStr, 1, CharPos );
    If WorkStr[1] = #10 Then
      System.Delete( WorkStr, 1, 1 );
    DrawTextLine( CurrBasePt, WorkRow );
    TextExt := FVectorFont.GetTextExtension( WorkRow, FHeight, FInterCharSpacing, FInterLineSpacing );
    CurrBasePt.Y := CurrBasePt.Y - ( TextExt.Y2 - TextExt.Y1 ) - FHeight * FInterLineSpacing;

    CharPos := AnsiPos( #13, WorkStr );
  End;
  DrawTextLine( CurrBasePt, WorkStr );
  { restore pen and fill attribs }
  PenTool.FPenStyle := TempPenStyle;
  BrushTool.FBrushStyle := TempBrushStyle;
End;

Function TEzJustifVectorText.GetFontName: String;
Begin
  Result := '';
  If FVectorFont = Nil Then Exit;
  Result := FVectorFont.Name;
End;

Procedure TEzJustifVectorText.SetFontName( Const Value: String );
Begin
  FVectorFont := Ez_VectorFonts.FontByName( Value );
  UpdateExtension;
End;

Procedure TEzJustifVectorText.SetTextBox( Const Value: TEzRect );
Begin
  FTextBox := Value;
  UpdateExtension;
End;

{ get the text extension without including the rotation angle }

Function TEzJustifVectorText.GetTextExtension: TEzRect;
Var
  TmpRect: TEzRect;
  CurrRect: TEzRect;
  DeltaX, Tx, Ty: Double;
Begin
  If FVectorFont <> Nil Then
    TmpRect := FVectorFont.GetTextExtension( FText, FHeight, FInterCharSpacing,
                                             FInterlineSpacing )
  Else
    TmpRect := Rect2D( 0, 0, 0, 0 );
  CurrRect.Emin := FTextBox.Emin;
  CurrRect.Emax := FTextBox.Emax;
  CurrRect := ReorderRect2D( CurrRect );

  DeltaX := TmpRect.X2 - TmpRect.X1;
  Case FHorzAlignment Of
    haLeft: Tx := CurrRect.X1;
    haRight: Tx := CurrRect.X2 - DeltaX;
    haCenter: Tx := ( CurrRect.X1 + CurrRect.X2 - DeltaX ) / 2.0;
  Else
    Tx := CurrRect.X1;
  End;
  Case FVertAlignment Of
    vaTop: Ty := CurrRect.Y2 - TmpRect.Y2;
    vaBottom: Ty := CurrRect.Y1 - TmpRect.Y1;
    vaCenter: Ty := ( CurrRect.Y2 + CurrRect.Y1 ) / 2.0;
  Else
    Ty := CurrRect.Y2 - TmpRect.Y2;
  End;
  Result := TransformRect2D( TmpRect, Translate2D( Tx, Ty ) );
End;

Procedure TEzJustifVectorText.SetAngle( Const Value: Double );
Begin
  FAngle := Value;
  UpdateExtension;
End;

Procedure TEzJustifVectorText.SetHeight( Const Value: Double );
Begin
  FHeight := Value;
  UpdateExtension;
End;

Procedure TEzJustifVectorText.SetInterCharSpacing( Const Value: Double );
Begin
  FInterCharSpacing := Value;
  UpdateExtension;
End;

Procedure TEzJustifVectorText.SetInterLineSpacing( Const Value: Double );
Begin
  FInterLineSpacing := Value;
  UpdateExtension;
End;

Procedure TEzJustifVectorText.DoRotation;
Var
  I: Integer;
  M: TEzMatrix;
Begin
  If FAngle = 0 Then Exit;
  M := Rotate2D( FAngle, FPoints[0] );
  For I := 0 To FPoints.Count - 1 Do
    FPoints[I] := TransformPoint2D( FPoints[I], M );
End;

Procedure TEzJustifVectorText.UpdateExtension;
Var
  Extent: TEzRect;
Begin
  PopulatePoints;
  Extent := GetTextExtension;
  DoNormalizedVector( Extent.Emin, Extent.Emax );
  { resize FTextBox }
  FTextBox.Emax.X := dMax( FTextBox.Emax.X, FPoints[1].X );
  FTextBox.Emin.Y := dMin( FTextBox.Emin.Y, FPoints[0].Y );
  FTextBox.Emax.Y := dMax( FTextBox.Emax.Y, FPoints[2].Y );
  DoNormalizedVector( FTextBox.Emin, FTextBox.Emax );
  { apply transformation matrix }
  FPoints.DisableEvents := true;
  Try
    DoRotation;
  Finally
    FPoints.DisableEvents := false;
  End;
  FBox := FPoints.Extension;
End;

Procedure TEzJustifVectorText.LoadFromStream( Stream: TStream );
Var
  NumFont: Integer;
  Unused: DWord;
Begin
  If PenTool = Nil Then
    PenTool := TEzPenTool.Create;
  If BrushTool = Nil Then
    BrushTool := TEzBrushTool.Create;
  FPoints.DisableEvents := true;
  With Stream Do
  Begin
    { the identifier for this entity }
    Read( ID, SizeOf( ID ) );
    Read( FTextBox, sizeof( TEzRect ) );
    { read specific data}
    Read( NumFont, sizeof( Integer ) );
    FVectorFont := Ez_VectorFonts.FontByIndex( NumFont );
    FText := EzReadStrFromStream( stream );
    Read( FHeight, sizeof( FHeight ) );
    Read( FAngle, sizeof( FAngle ) );
    Read( FFontColor, sizeof( TColor ) );
    Read( FHorzAlignment, sizeof( FHorzAlignment ) );
    Read( FVertAlignment, sizeof( FVertAlignment ) );
    Read( FInterCharSpacing, sizeof( FInterCharSpacing ) );
    Read( FInterLineSpacing, sizeof( FInterLineSpacing ) );
    { read attributes }
    PenTool.LoadFromStream( stream );
    BrushTool.LoadFromStream( stream );
    Read( Unused, sizeof( Unused ) );
  End;
  FPoints.DisableEvents := false;
  UpdateExtension;
  FOriginalSize := StorageSize;
End;

Procedure TEzJustifVectorText.SaveToStream( Stream: TStream );
Var
  NumFont: Integer;
  Unused: DWord;
Begin
  Unused := 0;
  With Stream Do
  Begin
    Write( ID, SizeOf( ID ) );
    Write( FTextBox, sizeof( TEzRect ) );
    NumFont := Ez_VectorFonts.IndexOfFont( FVectorFont );
    Write( NumFont, sizeof( Integer ) );
    EzWriteStrToStream( FText, stream );
    Write( FHeight, sizeof( FHeight ) );
    Write( FAngle, sizeof( FAngle ) );
    Write( FFontColor, sizeof( TColor ) );
    Write( FHorzAlignment, sizeof( FHorzAlignment ) );
    Write( FVertAlignment, sizeof( FVertAlignment ) );
    Write( FInterCharSpacing, sizeof( FInterCharSpacing ) );
    Write( FInterLineSpacing, sizeof( FInterLineSpacing ) );
    PenTool.SaveToStream( stream );
    BrushTool.SaveToStream( stream );
    Write( Unused, sizeof( Unused ) );
  End;
  FOriginalSize := StorageSize;
End;

Function TEzJustifVectorText.StorageSize: Integer;
Begin
  Result := Inherited StorageSize + Length( FText );
End;

Function TEzJustifVectorText.IsClosed: Boolean;
Begin
  Result := True;
End;

Function TEzJustifVectorText.GetControlPointType( Index: Integer ): TEzControlPointType;
Begin
  Result := cptNode;
  If Index = 8 Then
    result := cptMove // move must ALWAYS go before cptRotate
  Else If Index = 9 Then
    result := cptRotate
End;

Procedure TEzJustifVectorText.MoveAndRotateControlPoint( Var MovePt, RotatePt: TEzPoint; Grapher: TEzGrapher );
Var
  xmid1, ymid1, xmid2, ymid2, Dist, angl: Double;
Begin
  xmid1 := ( FPoints[0].X + FPoints[3].X ) / 2;
  ymid1 := ( FPoints[0].Y + FPoints[3].Y ) / 2;
  xmid2 := ( FPoints[1].X + FPoints[2].X ) / 2;
  ymid2 := ( FPoints[1].Y + FPoints[2].Y ) / 2;
  If Not EqualPoint2d(Ez_Preferences.GRotatePoint, INVALID_POINT) Then
    MovePt:= Ez_Preferences.GRotatePoint
  Else
    MovePt := Point2d( ( xmid1 + xmid2 ) / 2, ( ymid1 + ymid2 ) / 2 );
  If Grapher <> Nil Then
    Dist:= Grapher.DistToRealX(Grapher.ScreenDpiX div 2)
  Else
    Dist := Dist2D( MovePt, Point2D( xmid2, ymid2 ) ) * ( 2 / 3 );
  Angl := Angle2D( MovePt, Point2D( xmid2, ymid2 ) );
  RotatePt := Point2d( MovePt.x + Dist * Cos( Angl ), MovePt.y + Dist * Sin( Angl ) );
End;

Function TEzJustifVectorText.GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector;
Var
  theMovePt, theRotatePt: TEzPoint;
Begin
  Result := TEzVector.Create( 10 );
  { crearemos 8 puntos de control de los cuales, solo cuatro
    que son las cuatro esquinas, pertenecen a vertices reales
    de FPoints }
  With Result Do
  Begin
    Add( FPoints[0] ); // LOWER LEFT
    AddPoint( ( FPoints[0].X + FPoints[1].X ) / 2, ( FPoints[0].Y + FPoints[1].Y ) / 2 ); // MIDDLE BOTTOM
    Add( FPoints[1] ); // LOWER RIGHT
    AddPoint( ( FPoints[1].X + FPoints[2].X ) / 2, ( FPoints[1].Y + FPoints[2].Y ) / 2 ); // MIDDLE RIGHT
    Add( FPoints[2] ); // UPPER RIGHT
    AddPoint( ( FPoints[2].X + FPoints[3].X ) / 2, ( FPoints[2].Y + FPoints[3].Y ) / 2 ); // MIDDLE TOP
    Add( FPoints[3] ); // UPPER LEFT
    AddPoint( ( FPoints[0].X + FPoints[3].X ) / 2, ( FPoints[0].Y + FPoints[3].Y ) / 2 ); // MIDDLE LEFT
    if TransfPts then
    begin
      MoveAndRotateControlPoint( theMovePt, theRotatePt, Grapher );
      Add( theMovePt );
      Add( theRotatePt );
    end;
  End;
End;

Procedure TEzJustifVectorText.UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil );
Var
  M: TEzMatrix;
  theMovePt, theRotatePt: TEzPoint;
  I: Integer;
  phiStart, phiEnd: Double;
Begin
  FPoints.DisableEvents := True;
  Try
    { 6                5                  4
      +---------------+-------------------+
      |                                   |
    7 +                                   + 3
      |                                   |
      +---------------+-------------------+
      0               1                   2
    }
    Case Index Of
      0: // calculate the point
        Begin
          FPoints[0] := Value;
          FPoints[4] := Value;
          FPoints[3] := Perpend( Value, FPoints[2], FPoints[3] );
          FPoints[1] := Perpend( Value, FPoints[1], FPoints[2] );
        End;
      1:
        Begin
          FPoints[0] := Perpend( Value, FPoints[0], FPoints[3] );
          FPoints[4] := FPoints[0];
          FPoints[1] := Perpend( Value, FPoints[1], FPoints[2] );
        End;
      2:
        Begin
          FPoints[1] := Value;
          FPoints[2] := Perpend( Value, FPoints[2], FPoints[3] );
          FPoints[0] := Perpend( Value, FPoints[0], FPoints[3] );
          FPoints[4] := FPoints[0];
        End;
      3:
        Begin
          FPoints[1] := Perpend( Value, FPoints[0], FPoints[1] );
          FPoints[2] := Perpend( Value, FPoints[2], FPoints[3] );
        End;
      4:
        Begin
          FPoints[2] := Value;
          FPoints[1] := Perpend( Value, FPoints[0], FPoints[1] );
          FPoints[3] := Perpend( Value, FPoints[0], FPoints[3] );
        End;
      5:
        Begin
          FPoints[2] := Perpend( Value, FPoints[1], FPoints[2] );
          FPoints[3] := Perpend( Value, FPoints[0], FPoints[3] );
        End;
      6:
        Begin
          FPoints[3] := Value;
          FPoints[0] := Perpend( Value, FPoints[0], FPoints[1] );
          FPoints[4] := FPoints[0];
          FPoints[2] := Perpend( Value, FPoints[1], FPoints[2] );
        End;
      7:
        Begin
          FPoints[3] := Perpend( Value, FPoints[2], FPoints[3] );
          FPoints[0] := Perpend( Value, FPoints[0], FPoints[1] );
          FPoints[4] := FPoints[0];
        End;
      8: // the move point
        Begin
          // calculate current move point
          MoveAndRotateControlPoint( theMovePt, theRotatePt, Grapher );
          M := Translate2d( Value.X - theMovePt.X, Value.Y - theMovePt.Y );
          For I := 0 To FPoints.Count - 1 Do
            FPoints[I] := TransformPoint2d( FPoints[I], M );
        End;
      9: // the rotate point
        Begin
          MoveAndRotateControlPoint( theMovePt, theRotatePt, Grapher );
          phiStart := Angle2D( theRotatePt, theMovePt );
          phiEnd := Angle2d( value, theMovePt );
          M := Rotate2d( phiEnd - phiStart, theMovePt );
          For I := 0 To FPoints.Count - 1 Do
            FPoints[I] := TransformPoint2d( FPoints[I], M );
        End;
    End;
  Finally
    FPoints.DisableEvents := false;
  End;
End;

Procedure TEzJustifVectorText.UpdateExtensionFromControlPts;
Var
  TempV: TEzVector;
  M: TEzMatrix;
  I: Integer;
Begin
  TempV := TEzVector.create( FPoints.Count );
  Try
    TempV.Assign( FPoints );
    FAngle := Angle2d( FPoints[0], FPoints[1] );
    M := Rotate2D( -FAngle, TempV[0] );
    For I := 0 To TempV.Count - 1 Do
      TempV[I] := TransformPoint2D( TempV[I], M );
    FTextBox.Emin := TempV[0];
    FTextBox.Emax := TempV[2];
  Finally
    TempV.Free;
  End;
  UpdateExtension;
End;

Procedure TEzJustifVectorText.SetText( Const Value: String );
Begin
  FText := Value;
  UpdateExtension;
End;

Procedure TEzJustifVectorText.MakePolyPointsByCenter( Const Center: TEzPoint );
Var
  DX, DY: Double;
Begin
  DX := ( FTextBox.Emax.X - FTextBox.Emin.X ) / 2;
  DY := ( FTextBox.Emax.Y - FTextBox.Emin.Y ) / 2;
  FTextBox.Emin := Point2D( Center.X - DX, Center.Y - DY );
  FTextBox.Emax := Point2D( Center.Y + DY, Center.Y + DY );
  UpdateExtension;
End;

function TEzJustifVectorText.IsEqualTo(Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean;
begin
  Result:= False;
  if ( Entity.EntityID <> idJustifVectText ) Or
     ( Inherited IsEqualTo( Entity, IncludeAttribs ) = False )
     {$IFDEF FALSE}Or
     ( IncludeAttribs And
       ( ( FText <> TEzJustifVectorText( Entity ).FText ) Or
         ( FHeight <> TEzJustifVectorText( Entity ).FHeight ) Or
         ( FAngle <> TEzJustifVectorText( Entity ).FAngle ) Or
         ( FHorzAlignment <> TEzJustifVectorText( Entity ).FHorzAlignment ) Or
         ( FVertAlignment <> TEzJustifVectorText( Entity ).FVertAlignment ) Or
         ( FInterCharSpacing <> TEzJustifVectorText( Entity ).FInterCharSpacing ) Or
         ( FInterLineSpacing <> TEzJustifVectorText( Entity ).FInterLineSpacing ) Or
         Not EqualRect2d( FTextBox, TEzJustifVectorText( Entity ).FTextBox ) Or
         ( FFontColor <> TEzJustifVectorText( Entity ).FFontColor ) ) ){$ENDIF} Then Exit;
  Result:= True;
end;

{$IFDEF BCB}
function TEzJustifVectorText.GetAngle: Double;
begin
  Result := FAngle;
end;

function TEzJustifVectorText.GetFontColor: TColor;
begin
  Result := FFontColor;
end;

function TEzJustifVectorText.GetHeight: Double;
begin
  Result := FHeight;
end;

function TEzJustifVectorText.GetHorzAlignment: TEzHorzAlignment;
begin
  Result := FHorzAlignment;
end;

function TEzJustifVectorText.GetInterCharSpacing: Double;
begin
  Result := FInterCharSpacing;
end;

function TEzJustifVectorText.GetInterLineSpacing: Double;
begin
  Result := FInterLineSpacing;
end;

function TEzJustifVectorText.GetText: String;
begin
  Result := FText;
end;

function TEzJustifVectorText.GetTextBox: TEzRect;
begin
  Result := FTextBox;
end;

function TEzJustifVectorText.GetVectorFont: TEzVectorFont;
begin
  Result := FVectorFont;
end;

function TEzJustifVectorText.GetVertAlignment: TEzVertAlignment;
begin
  Result := FVertAlignment;
end;

procedure TEzJustifVectorText.SetFontColor(const Value: TColor);
begin
  FFontColor := Value;
end;

procedure TEzJustifVectorText.SetHorzAlignment(
  const Value: TEzHorzAlignment);
begin
  FHorzAlignment := Value;
end;

procedure TEzJustifVectorText.SetVectorFont(const Value: TEzVectorFont);
begin
  FVectorFont := Value;
end;

procedure TEzJustifVectorText.SetVertAlignment(
  const Value: TEzVertAlignment);
begin
  FVertAlignment := Value;
end;
{$ENDIF}

{ TEzFittedVectorText }

Constructor TEzFittedVectorText.CreateEntity( Const BasePoint: TEzPoint;
  Const Text: String; Const Height, Width, Angle: Double );
Begin
  Inherited CreateEntity( [NULL_POINT, NULL_POINT, NULL_POINT, NULL_POINT, NULL_POINT], False );
  FText := Text;
  If Length( FText ) = 0 Then FText := 'W';
  FHeight := Height;
  FPoints[0] := BasePoint;
  Self.Width := Width;
  FAngle := Angle;

  PopulatePoints;
  DoNormalizedVector( BasePoint, FPoints );

  UpdateExtension;
End;

procedure TEzFittedVectorText.Initialize;
begin
  inherited;
  FVectorFont := Ez_VectorFonts.FontByName( Ez_Preferences.DefFontStyle.Name );
  FInterCharSpacing := 0.10;
  FInterLineSpacing := 0.02;
  FFontColor := Ez_Preferences.DefFontStyle.Color;
  Pentool.FPenStyle.Style := 0;
  Brushtool.FBrushStyle.Pattern := 0;
  Brushtool.FBrushStyle.Color := clWhite;
end;

Function TEzFittedVectorText.BasicInfoAsString: string;
Begin
  Result:= Format(sFittedTextInfo, [FPoints[0].X,FPoints[0].Y,FText,FHeight,Width,RadToDeg(FAngle),FFontColor]);
End;

Function TEzFittedVectorText.AttribsAsString: string;
Begin
  Result:= Format(sVectorFontInfo, [GetFontName]);
End;

Function TEzFittedVectorText.GetEntityID: TEzEntityID;
Begin
  result := idFittedVectText;
End;

Procedure TEzFittedVectorText.PopulatePoints;
Var
  I: Integer;
Begin
  If FPoints.Count = 5 Then Exit;
  FPoints.DisableEvents := true;
  FPoints.CanGrow:= True;
  Try
    For I := FPoints.Count + 1 To 5 Do
      FPoints.Add( NULL_POINT );
  Finally
    FPoints.DisableEvents := false;
    FPoints.CanGrow:= False;
  End;
End;

Procedure TEzFittedVectorText.DoNormalizedVector( Const BasePt: TEzPoint; V: TEzVector );
Begin
  V.DisableEvents := true;
  Try
    {  4
     0 +----------------+ 3
       |                |
     1 +----------------+ 2
    }
    V[0] := BasePt;
    V[1] := Point2D( BasePt.X, BasePt.Y - FHeight );
    V[2] := Point2D( BasePt.X + FWidth, BasePt.Y - FHeight );
    V[3] := Point2D( BasePt.X + FWidth, BasePt.Y );
    V[4] := V[0];
  Finally
    V.DisableEvents := false;
  End;
End;

Function TEzFittedVectorText.GetTextExtension: TEzRect;
Begin
  Result.Emin := Point2D( FPoints[0].X, FPoints[0].Y - FHeight );
  Result.Emax := Point2D( FPoints[0].X + FWidth, FPoints[0].Y );
End;

Procedure TEzFittedVectorText.ApplyTransform;
Var
  I: Integer;
  M: TEzMatrix;
Begin
  { Create the auxiliary basic vector }
  DoNormalizedVector( FPoints[0], FPoints );
  { apply the transformation matrix }
  FPoints.DisableEvents := true;
  Try
    If FAngle <> 0 Then
    Begin
      M := Rotate2D( FAngle, FPoints[0] );
      For I := 0 To FPoints.Count - 1 Do
        FPoints[I] := TransformPoint2D( FPoints[I], M );
    End;
    For I := 0 To FPoints.Count - 1 Do
      FPoints[I] := TransformPoint2D( FPoints[I], Self.GetTransformMatrix );
  Finally
    FPoints.DisableEvents := False;
  End;
  { calculate the rotation angle for the text }
  FAngle := Angle2D( FPoints[0], FPoints[3] );
  { calculate the new with and height by scaling the same proportion }
  FHeight := Dist2D( FPoints[0], FPoints[1] );
  FWidth := Dist2D( FPoints[0], FPoints[3] );
  self.SetTransformMatrix( IDENTITY_MATRIX2D );
  { and now, calculate the FPoints vector taking into account
    only the actual text extension }
  UpdateExtension;
End;

Procedure TEzFittedVectorText.DoDrawing( Path: TEzVector;
                                         FittedToLen: Boolean;
                                         Grapher: TEzGrapher;
                                         Canvas: TCanvas;
                                         Const Clip: TEzRect;
                                         DrawMode: TEzDrawMode );
Var
  TmpRect: TEzRect;
  CurrBasePt: TEzPoint;
  TempPenStyle: TEzPenStyle;
  TempBrushStyle: TEzBrushStyle;
  ScaleX, ScaleY, dist: Double;
  I, NumLines, CharPos: Integer;
  WorkStr, RowStr: String;
  Lines: Array[1..100] Of String;
  LineHeight: Double;
  HalfLineSpacing, MinDist: Double;
  V, V1, V2: TEzVector;
  M: TEzMatrix;
  subject, clipping, clipresult: TEzEntityList;
  subjEnt, clipEnt, drawEnt: TEzEntity;
  MidPoint, p0, p1: TEzPoint;
  Rotangle, BoxH, CX, CY: Double;
  TmpColor: TColor;
  Found, DrawExtensionLine: Boolean;
  EquidistVector: TEzVector;
  EquidistList: TIntegerList;
  WidthList: TEzDoubleList;
  TextExt: TEzRect;

  Procedure DrawChar( CharIndex: Integer; Ch: AnsiChar; Var DrawPoint: TEzPoint );
  Var
    VectorChar: TEzVectorChar;
    TmpVectorChar: TEzVectorChar;
    TmpMatrix: TEzMatrix;
    TmpExt: TEzRect;
    RotAngle: Double;
    pt: TEzPoint;
    nIndex: Integer;
    RotationPt, TranslateTo: TEzPoint;
  Begin
    VectorChar := Nil;
    TmpVectorChar := FVectorFont.Chars[Ord( Ch )];
    If Ch = #32 Then
    Begin
      DrawPoint.X := DrawPoint.X + ( 0.5 + FInterCharSpacing ) * ScaleX;
      Exit;
    End
    Else If TmpVectorChar <> Nil Then
      VectorChar := TmpVectorChar
    Else If Ch <> #13 Then
      VectorChar := Ez_VectorFonts.FNullChar;
    If VectorChar = Nil Then Exit;
    If Path <> Nil Then
    Begin
      { obtain the index of the char }
      nIndex:= EquidistList[CharIndex-1];
      Pt:= EquidistVector[nIndex];
      if nIndex = EquidistVector.Count-1 then
        RotAngle := Angle2D( EquidistVector[nIndex-1], EquidistVector[nIndex] )
      else
        RotAngle := Angle2D( EquidistVector[nIndex], EquidistVector[nIndex + 1] );
      RotationPt := pt;
      TranslateTo := pt;
    End
    Else
    Begin
      RotAngle := FAngle;
      RotationPt := FPoints[0];
      TranslateTo := DrawPoint;
    End;
    With VectorChar Do
    Begin
      TmpExt := Extension;
      TmpMatrix := MultiplyMatrix2D( Translate2D( TranslateTo.X - TmpRect.X1 * ScaleX,
                                                  TranslateTo.Y - TmpRect.Y1 * ScaleY ),
                                     Scale2D( ScaleX, ScaleY, Point2D( 0, 0 ) ) );
      If RotAngle <> 0 Then
        TmpMatrix := MultiplyMatrix2D( Rotate2D( RotAngle, RotationPt ), TmpMatrix );

      FVector.DrawOpened( Canvas,
                          Clip,
                          FBox,
                          Grapher,
                          Pentool.FPenStyle,
                          MultiplyMatrix2D( Self.GetTransformMatrix, TmpMatrix ),
                          DrawMode );
      DrawPoint.X := DrawPoint.X + ( TmpExt.X2 + FInterCharSpacing ) * ScaleX;
    End;
  End;

  Procedure DrawTextLine( BasePt: TEzPoint; Const WkStr: String );
  Var
    I: Integer;
  Begin
    For I := 1 To Length( WkStr ) Do
      DrawChar( I, WkStr[I], BasePt );
  End;

  Procedure DrawBackGround( TheV: TEzVector );
  Begin
    TheV.DrawClosed( Canvas,
                     Clip,
                     FBox,
                     Grapher,
                     PenTool.FPenStyle,
                     BrushTool.FBrushStyle,
                     self.GetTransformMatrix,
                     DrawMode,
                     Nil );
  End;

  Procedure InflateThis( TheV: TEzVector; Const Dist: Double );
  Begin
    TheV[0] := Point2d( TheV[0].X - Dist, TheV[0].Y + Dist );
    TheV[1] := Point2d( TheV[1].X - Dist, TheV[1].Y - Dist );
    TheV[2] := Point2d( TheV[2].X + Dist, TheV[2].Y - Dist );
    TheV[3] := Point2d( TheV[3].X + Dist, TheV[3].Y + Dist );
    TheV[4] := TheV[0];
  End;

Begin
  If ( Length( FText ) = 0 ) Or Not Ez_Preferences.ShowText Or ( FVectorFont = Nil ) Or
    ( ( Path <> Nil ) And ( Path.Count = 0 ) ) Then Exit;

  { save current pen and fill attribs }
  TempPenStyle := PenTool.FPenStyle;
  TempBrushStyle := Brushtool.FBrushStyle;
  {If ( Path = Nil ) And ( DrawMode In [dmRubberPen, dmSelection] ) Then
  Begin
    DrawBackGround( FPoints );
    PenTool.FPenStyle := TempPenStyle;
    BrushTool.FBrushStyle := TempBrushStyle;
    Exit;
  End; }
  If DrawMode = dmRubberPen Then
    Pentool.FPenStyle.Style := 1;
  If ( Path = Nil ) And ( FTextBorderStyle <> tbsNone ) Then
  Begin
    FAngle := 0;
    Case FTextBorderStyle Of
      tbsBanner:
        Begin
          // slide the shadow
          V := TEzVector.Create( 5 );
          Try
            DoNormalizedVector( FPoints[0], V );
            MinDist := dMin( FHeight, FWidth ) * 0.125;
            {  4
             0 +----------------+ 3
               |                |
             1 +----------------+ 2
            }
            InflateThis( V, MinDist );
            If Not FHideShadow Then
            Begin
              For I := 0 To V.Count - 1 Do
                V[I] := Point2d( V[I].X + MinDist, V[I].Y - MinDist );
              PenTool.FPenStyle.Style := 0;
              BrushTool.FBrushStyle.Pattern := 1;
              TmpColor := BrushTool.FBrushStyle.Color;
              BrushTool.FBrushStyle.Color := clSilver;
              DrawBackGround( V );
              BrushTool.FBrushStyle.Color := TmpColor;
            End;
            With PenTool.FPenStyle Do
            Begin
              Style := 1;
              Scale := 0;
            End;
            BrushTool.FBrushStyle.Pattern := 1;
            If Not FHideShadow Then
            Begin
              For I := 0 To V.Count - 1 Do
                V[I] := Point2d( V[I].X - MinDist, V[I].Y + MinDist );
            End;
            DrawBackGround( V );
          Finally
            V.Free;
          End;
        End;
      tbsCallout:
        Begin
          subjEnt := TEzPolygon.Create( 5 );
          DoNormalizedVector( FPoints[0], subjEnt.Points );
          // slide the shadow
          MinDist := dMin( FHeight, FWidth ) * 0.125;
          {  4
           0 +----------------+ 3
             |                |
           1 +----------------+ 2
          }
          InflateThis( subjEnt.Points, MinDist );
          DrawExtensionLine := Not IsPointInBox2d( FPivot, subjEnt.FBox );
          // build other vector in order to do a UNION clipping
          subject := Nil;
          clipping := Nil;
          clipresult := Nil;
          If DrawExtensionLine Then
          Begin
            subject := TEzEntityList.create;
            clipping := TEzEntityList.create;
            clipresult := TEzEntityList.create;
          End;
          Try
            If DrawExtensionLine Then
            Begin
              subject.add( subjEnt );
              clipEnt := TEzPolygon.Create( 4 );
              clipping.Add( clipEnt );
              // create clipping entity
              MidPoint := Point2d( ( subjEnt.Points[0].X + subjEnt.Points[2].X ) / 2,
                ( subjEnt.Points[0].Y + subjEnt.Points[2].Y ) / 2 );
              BoxH := ( subjEnt.Points[0].Y - subjEnt.Points[1].Y ) / 3;
              With clipEnt.Points Do
              Begin
                p0 := Point2d( MidPoint.X - BoxH, MidPoint.Y );
                p1 := Point2d( MidPoint.X + BoxH, MidPoint.Y );
                Rotangle := Angle2d( MidPoint, FPivot ) + System.Pi / 2;
                M := Rotate2d( Rotangle, MidPoint );
                p0 := TransformPoint2d( p0, M );
                p1 := TransformPoint2d( p1, M );
                Add( p0 );
                Add( FPivot );
                Add( p1 );
                Add( P0 );
              End;
              PolygonClip( pcUNION, subject, clipping, clipresult, Nil );
              drawEnt := clipResult[0];
            End
            Else
              drawEnt := subjEnt;
            // offset all the points except the pivot in order to paint the shadow
            TmpColor := clBlack;
            If Not FHideShadow Then
            Begin
              PenTool.FPenStyle.Style := 0;
              BrushTool.FBrushStyle.Pattern := 1;
              TmpColor := BrushTool.FBrushStyle.Color;
              BrushTool.FBrushStyle.Color := clSilver;
            End;
            With drawEnt Do
            Begin
              If Not FHideShadow Then
              Begin
                For I := 0 To Points.Count - 1 Do
                  If Not FuzzEqualPoint2d( Points[I], FPivot ) Then
                    Points[I] := Point2d( Points[I].X + MinDist, Points[I].Y - MinDist );
                DrawBackGround( Points );
                // restore position
                For I := 0 To Points.Count - 1 Do
                  If Not FuzzEqualPoint2d( Points[I], FPivot ) Then
                    Points[I] := Point2d( Points[I].X - MinDist, Points[I].Y + MinDist );
              End;
              // and draw with the background
              With self.PenTool.FPenStyle Do
              Begin
                Style := 1;
                Scale := 0;
              End;
              self.BrushTool.FBrushStyle.Pattern := 1;
              self.BrushTool.FBrushStyle.Color := TmpColor;
              DrawBackGround( Points );
            End;
          Finally
            If DrawExtensionLine Then
            Begin
              subject.free;
              clipping.free;
              clipresult.free;
            End;
          End;
        End;
      tbsBulletLeader:
        Begin
          V := TEzVector.Create( 2 );
          V1 := TEzVector.Create( 2 );
          V2 := TEzVector.Create( 2 );
          Try
            Self.Centroid( CX, CY );
            V.AddPoint( CX, CY );
            V.Add( Pivot );
            V1.Assign( Self.FPoints );
            MinDist := dMin( FHeight, FWidth ) * 0.125;
            InflateThis( V1, MinDist );
            { find the intersection }
            Found := false;
            If VectIntersect( V, V1, V2, true ) Then
            Begin
              MinDist := MAXCOORD;
              For I := 0 To V2.Count - 1 Do
              Begin
                dist := Dist2D( V2[I], Pivot );
                If dist < MinDist Then
                Begin
                  MinDist := dist;
                  p0 := V2[I];
                  Found := true;
                End;
              End;
            End;
            If found Then
            Begin
              V[0] := p0;
              self.Pentool.Style := 1;
              V.DrawOpened( Canvas,
                Clip,
                FBox,
                Grapher,
                self.PenTool.FPenstyle,
                self.GetTransformMatrix,
                DrawMode );
            End;
          Finally
            V.free;
            V1.free;
            V2.Free;
          End;
        End;
    End;
  End;
  { define the pen and fill attribs for the text }
  PenTool.FPenStyle.Style := 1;
  PenTool.FPenStyle.Scale := 0;
  PenTool.FPenStyle.Color := FFontColor;
  BrushTool.FBrushStyle.Pattern := 0;

  Charpos := AnsiPos( #13, FText );
  If (Charpos = 0) or (Path <> Nil) Then
  Begin
    { single line or when fitted to a path must be single line only }
    TmpRect := FVectorFont.GetFittedTextExtension( FText, FInterCharSpacing );
    If ( TmpRect.X2 - TmpRect.X1 ) <> 0 Then
      ScaleX := FWidth / ( TmpRect.X2 - TmpRect.X1 )
    Else
      ScaleX := 0;
    If ( TmpRect.Y2 - TmpRect.Y1 ) <> 0 Then
      ScaleY := FHeight / ( TmpRect.Y2 - TmpRect.Y1 )
    Else
      ScaleY := 0;

    WidthList:= Nil;
    If Path <> Nil Then
    Begin
      { create a equidistant vector }
      EquidistList:= TIntegerList.Create;
      EquidistVector:= TEzVector.Create(Path.Count + Length(FText));
      if Not FittedToLen then
      begin
        { obtener la longitud de cada caracter }
        WidthList:= TEzDoubleList.Create;
        for I:= 1 to Length(FText) do
        begin
          TextExt:= FVectorFont.GetTextExtension(FText[I], FHeight, 0, 0);
          WidthList.Add( (TextExt.X2 - TextExt.X1) * (1.0 + FInterCharSpacing) );
        end;
      end;

      EquidistVector.SplitEquidistant( Path, Length(FText), EquidistList, WidthList );
      while EquidistList.Count < Length(FText) do
        EquidistList.Add(EquidistVector.Count - 1);
    End
    Else
    Begin
      CurrBasePt.X := FPoints[0].X;
      CurrBasePt.Y := FPoints[0].Y - FHeight;
    End;

    DrawTextLine( CurrBasePt, FText );

    if Path <> Nil then
    begin
      EquidistVector.Free;
      EquidistList.Free;
      if Not FittedToLen then
        WidthList.Free;
    end;
  End
  Else
  Begin
    { multiline text }
    NumLines := 0;
    WorkStr := FText;
    While CharPos > 0 Do
    Begin
      RowStr := Copy( WorkStr, 1, CharPos - 1 );
      System.Delete( WorkStr, 1, CharPos );
      If WorkStr[1] = #10 Then
        System.Delete( WorkStr, 1, 1 );
      Inc( NumLines );
      Lines[NumLines] := RowStr;

      CharPos := AnsiPos( #13, WorkStr );
    End;
    Inc( NumLines );
    Lines[NumLines] := WorkStr;

    LineHeight := FHeight / NumLines;
    HalfLineSpacing := ( FInterLineSpacing * FHeight ) / 2;
    { now draw every line }
    For I := 1 To NumLines Do
    Begin
      WorkStr := Lines[I];
      TmpRect := FVectorFont.GetFittedTextExtension( WorkStr, FInterCharSpacing );
      ScaleX := FWidth / ( TmpRect.X2 - TmpRect.X1 );
      ScaleY := ( LineHeight - HalfLineSpacing ) / ( TmpRect.Y2 - TmpRect.Y1 );

      CurrBasePt.X := FPoints[0].X;
      CurrBasePt.Y := FPoints[0].Y - LineHeight * I;

      DrawTextLine( CurrBasePt, WorkStr );
    End;
  End;

  { restore pen and fill attribs }
  PenTool.FPenStyle := TempPenStyle;
  BrushTool.FBrushStyle := TempBrushStyle;
End;

Procedure TEzFittedVectorText.Draw( Grapher: TEzGrapher;
  Canvas: TCanvas; Const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer = Nil );
Begin
  DoDrawing( Nil, False, Grapher, Canvas, Clip, DrawMode );
End;

Procedure TEzFittedVectorText.DrawToPath( Path: TEzVector;
  FittedToLen: Boolean; Grapher: TEzGrapher; Canvas: TCanvas;
  Const Clip: TEzRect; DrawMode: TEzDrawMode );
Begin
  DoDrawing( Path, FittedToLen, Grapher, Canvas, Clip, DrawMode );
End;

Function TEzFittedVectorText.GetFontName: String;
Begin
  Result := '';
  If FVectorFont = Nil Then
    Exit;
  Result := FVectorFont.Name;
End;

Procedure TEzFittedVectorText.SetAngle( Const Value: Double );
Begin
  FAngle := Value;
  UpdateExtension;
End;

Procedure TEzFittedVectorText.SetFontName( Const Value: String );
Begin
  FVectorFont := Ez_VectorFonts.FontByName( Value );
  UpdateExtension;
End;

Procedure TEzFittedVectorText.SetHeight( Const Value: Double );
Begin
  FHeight := Value;
  UpdateExtension;
End;

Procedure TEzFittedVectorText.SetWidth( Const Value: Double );
Var
  TxExt: TEzRect;
  Workst, Rowst: String;
  P: Integer;
Begin
  FWidth := Value;
  If ( FVectorFont <> Nil ) And ( FWidth <= 0 ) Then
  Begin
    // Calculate max text width
    FWidth := 0;
    Workst := FText;
    P := AnsiPos( #13, Workst );
    While P > 0 Do
    Begin
      Rowst := Copy( Workst, 1, P - 1 );
      System.Delete( Workst, 1, P );
      If Workst[1] = #10 Then
        System.Delete( Workst, 1, 1 );
      TxExt := FVectorFont.GetFittedTextExtension( Rowst, FInterCharSpacing );
      FWidth := dMax( FWidth, ( TxExt.X2 - TxExt.X1 ) * FHeight );
      P := AnsiPos( #13, Workst );
    End;
    TxExt := FVectorFont.GetFittedTextExtension( Workst, FInterCharSpacing );
    FWidth := dMax( FWidth, ( TxExt.X2 - TxExt.X1 ) * FHeight );
  End;
  UpdateExtension;
End;

Procedure TEzFittedVectorText.SetInterCharSpacing( Const Value: Double );
Begin
  FInterCharSpacing := Value;
  UpdateExtension;
End;

Procedure TEzFittedVectorText.SetInterLineSpacing( Const Value: Double );
Begin
  FInterLineSpacing := Value;
  UpdateExtension;
End;

Procedure TEzFittedVectorText.UpdateExtension;
Var
  I: Integer;
  M: TEzMatrix;
Begin
  PopulatePoints;
  DoNormalizedVector( FPoints[0], FPoints );
  { apply transformation matrix }
  If FAngle <> 0 Then
  Begin
    M := Rotate2D( FAngle, FPoints[0] );
    FPoints.DisableEvents := True;
    Try
      For I := 0 To FPoints.Count - 1 Do
        FPoints[I] := TransformPoint2D( FPoints[I], M );
    Finally
      FPoints.DisableEvents := False;
    End;
  End;
  FBox := FPoints.Extension;
  If FTextBorderStyle <> tbsNone Then
  Begin
    MaxBound( FBox.Emax, FPivot );
    MinBound( FBox.Emin, FPivot );
  End;
End;

Procedure TEzFittedVectorText.LoadFromStream( Stream: TStream );
Var
  NumFont: Integer;
  TmpPt: TEzPoint;
Begin
  If PenTool = Nil Then
    PenTool := TEzPenTool.Create;
  If BrushTool = Nil Then
    BrushTool := TEzBrushTool.Create;
  FPoints.DisableEvents := true;
  FPoints.Clear;
  With Stream Do
  Begin
    { the identifier for this entity }
    Read( ID, SizeOf( ID ) );
    Read( TmpPt, sizeof( TEzPoint ) );
    FPoints.Add( TmpPt );
    { read specific data}
    Read( NumFont, sizeof( Integer ) );
    FVectorFont := Ez_VectorFonts.FontByIndex( NumFont );
    FText := EzReadStrFromStream( stream );
    Read( FHeight, sizeof( FHeight ) );
    Read( FWidth, sizeof( FWidth ) );
    Read( FAngle, sizeof( FAngle ) );
    Read( FFontColor, sizeof( TColor ) );
    Read( FInterCharSpacing, sizeof( FInterCharSpacing ) );
    Read( FInterLineSpacing, sizeof( FInterLineSpacing ) );
    Read( FTextBorderStyle, sizeof( FTextBorderStyle ) );
    Read( FPivot, sizeof( FPivot ) );
    Read( FHideShadow, sizeof( FHideShadow ) );

    { read attributes }
    PenTool.LoadFromStream( stream );
    BrushTool.LoadFromStream( stream );
  End;
  FPoints.DisableEvents := false;
  UpdateExtension;
  FOriginalSize := StorageSize;
End;

Procedure TEzFittedVectorText.SaveToStream( Stream: TStream );
Var
  NumFont: Integer;
  TmpPt: TEzPoint;
Begin
  With Stream Do
  Begin
    Write( ID, SizeOf( ID ) );
    TmpPt := FPoints[0];
    Write( TmpPt, sizeof( TEzPoint ) );
    NumFont := Ez_VectorFonts.IndexOfFont( FVectorFont );
    Write( NumFont, sizeof( Integer ) );
    EzWriteStrToStream( FText, stream );
    Write( FHeight, sizeof( FHeight ) );
    Write( FWidth, sizeof( FWidth ) );
    Write( FAngle, sizeof( FAngle ) );
    Write( FFontColor, sizeof( TColor ) );
    Write( FInterCharSpacing, sizeof( FInterCharSpacing ) );
    Write( FInterLineSpacing, sizeof( FInterLineSpacing ) );
    Write( FTextBorderStyle, sizeof( FTextBorderStyle ) );
    Write( FPivot, sizeof( FPivot ) );
    Write( FHideShadow, sizeof( FHideShadow ) );
    PenTool.SaveToStream( stream );
    BrushTool.SaveToStream( stream );
  End;
  FOriginalSize := StorageSize;
End;

Function TEzFittedVectorText.StorageSize: Integer;
Begin
  Result := Inherited StorageSize + Length( FText );
End;

Function TEzFittedVectorText.GetBasePoint: TEzPoint;
Begin
  Result := FPoints[0];
End;

Procedure TEzFittedVectorText.SetBasePoint( Const Value: TEzPoint );
Begin
  FPoints[0] := Value;
  UpdateExtension;
End;

Function TEzFittedVectorText.IsClosed: Boolean;
Begin
  Result := True;
End;

Function TEzFittedVectorText.GetControlPointType( Index: Integer ): TEzControlPointType;
Begin
  Result := cptNode;
  If Index = 8 Then
    result := cptMove // move must ALWAYS go before cptRotate
  Else If Index = 9 Then
    result := cptRotate;
End;

Function TEzFittedVectorText.GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector;
Var
  theMovePt, theRotatePt: TEzPoint;
Begin
  Result := TEzVector.Create( 10 );
  { crearemos 8 puntos de control de los cuales, solo cuatro
    que son las cuatro esquinas, pertenecen a vertices reales
    de FPoints }
  With Result Do
  Begin
    Add( FPoints[0] ); // UPPER LEFT
    AddPoint( ( FPoints[0].X + FPoints[1].X ) / 2, ( FPoints[0].Y + FPoints[1].Y ) / 2 ); // MIDDLE LEFT
    Add( FPoints[1] ); // LOWER LEFT
    AddPoint( ( FPoints[1].X + FPoints[2].X ) / 2, ( FPoints[1].Y + FPoints[2].Y ) / 2 ); // MIDDLE BOTTON
    Add( FPoints[2] ); // LOWER RIGHT
    AddPoint( ( FPoints[2].X + FPoints[3].X ) / 2, ( FPoints[2].Y + FPoints[3].Y ) / 2 ); // MIDDLE RIGHT
    Add( FPoints[3] ); // UPPER RIGHT
    AddPoint( ( FPoints[3].X + FPoints[0].X ) / 2, ( FPoints[3].Y + FPoints[0].Y ) / 2 ); // MIDDLE TOP
    if TransfPts then
    begin
      { the movept}
      MoveAndRotateControlPoint( theMovePt, theRotatePt, nil );
      Add( theMovePt );
      //if FTextBorderStyle=tbsNone then
      Add( theRotatePt );
      If FTextBorderStyle In [tbsCallout, tbsBulletLeader] Then
        Add( FPivot );
    end;
  End;
End;

Procedure TEzFittedVectorText.MoveAndRotateControlPoint( Var MovePt, RotatePt: TEzPoint; Grapher: TEzGrapher );
Var
  xmid1, ymid1, xmid2, ymid2, Dist, angl: Double;
Begin
  xmid1 := ( FPoints[0].X + FPoints[1].X ) / 2;
  ymid1 := ( FPoints[0].Y + FPoints[1].Y ) / 2;
  xmid2 := ( FPoints[2].X + FPoints[3].X ) / 2;
  ymid2 := ( FPoints[2].Y + FPoints[3].Y ) / 2;
  If Not EqualPoint2d(Ez_Preferences.GRotatePoint, INVALID_POINT) Then
    MovePt:= Ez_Preferences.GRotatePoint
  Else
    MovePt := Point2d( ( xmid1 + xmid2 ) / 2, ( ymid1 + ymid2 ) / 2 );
  If Grapher<>Nil Then
    Dist:= Grapher.DistToRealX(Grapher.ScreenDpiX)
  Else
    Dist := Dist2D( MovePt, Point2D( xmid2, ymid2 ) ) * ( 2 / 3 );
  Angl := Angle2D( MovePt, Point2D( xmid2, ymid2 ) );
  RotatePt := Point2d( MovePt.x + Dist * Cos( Angl ), MovePt.y + Dist * Sin( Angl ) );
End;

Procedure TEzFittedVectorText.UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil );
Var
  M: TEzMatrix;
  theMovePt, theRotatePt: TEzPoint;
  I: Integer;
  phiStart, phiEnd: Double;
Begin
  FPoints.DisableEvents := True;
  Try
    { 0                7                  6
      +---------------+-------------------+
      |                                   |
    1 +                                   + 5
      |                                   |
      +---------------+-------------------+
      2               3                   4
    }
    Case Index Of
      0: // calculate the point
        Begin
          FPoints[0] := Value;
          FPoints[4] := Value;
          FPoints[3] := Perpend( Value, FPoints[2], FPoints[3] );
          FPoints[1] := Perpend( Value, FPoints[1], FPoints[2] );
        End;
      1:
        Begin
          FPoints[0] := Perpend( Value, FPoints[0], FPoints[3] );
          FPoints[4] := FPoints[0];
          FPoints[1] := Perpend( Value, FPoints[1], FPoints[2] );
        End;
      2:
        Begin
          FPoints[1] := Value;
          FPoints[2] := Perpend( Value, FPoints[2], FPoints[3] );
          FPoints[0] := Perpend( Value, FPoints[0], FPoints[3] );
          FPoints[4] := FPoints[0];
        End;
      3:
        Begin
          FPoints[1] := Perpend( Value, FPoints[0], FPoints[1] );
          FPoints[2] := Perpend( Value, FPoints[2], FPoints[3] );
        End;
      4:
        Begin
          FPoints[2] := Value;
          FPoints[1] := Perpend( Value, FPoints[0], FPoints[1] );
          FPoints[3] := Perpend( Value, FPoints[0], FPoints[3] );
        End;
      5:
        Begin
          FPoints[2] := Perpend( Value, FPoints[1], FPoints[2] );
          FPoints[3] := Perpend( Value, FPoints[0], FPoints[3] );
        End;
      6:
        Begin
          FPoints[3] := Value;
          FPoints[0] := Perpend( Value, FPoints[0], FPoints[1] );
          FPoints[4] := FPoints[0];
          FPoints[2] := Perpend( Value, FPoints[1], FPoints[2] );
        End;
      7:
        Begin
          FPoints[3] := Perpend( Value, FPoints[2], FPoints[3] );
          FPoints[0] := Perpend( Value, FPoints[0], FPoints[1] );
          FPoints[4] := FPoints[0];
        End;
      8: // the move point
        Begin
          // calculate current move point
          MoveAndRotateControlPoint( theMovePt, theRotatePt, Grapher );
          M := Translate2d( Value.X - theMovePt.X, Value.Y - theMovePt.Y );
          For I := 0 To FPoints.Count - 1 Do
            FPoints[I] := TransformPoint2d( FPoints[I], M );
        End;
      9: // the rotate point
        Begin
          MoveAndRotateControlPoint( theMovePt, theRotatePt, Grapher );
          phiStart := Angle2D( theRotatePt, theMovePt );
          phiEnd := Angle2d( value, theMovePt );
          M := Rotate2d( phiEnd - phiStart, theMovePt );
          For I := 0 To FPoints.Count - 1 Do
            FPoints[I] := TransformPoint2d( FPoints[I], M );
        End;
      10: // pivot for callout and bullet leader text
        Begin
          FPivot := Value;
        End;
    End;
  Finally
    FPoints.DisableEvents := false;
  End;
End;

Procedure TEzFittedVectorText.UpdateExtensionFromControlPts;
Begin
  FHeight := Dist2D( FPoints[0], FPoints[1] );
  FWidth := Dist2D( FPoints[1], FPoints[2] );
  FAngle := Angle2d( FPoints[1], FPoints[2] );
  UpdateExtension;
End;

Procedure TEzFittedVectorText.SetText( Const Value: String );
Begin
  FText := Value;
  UpdateExtension;
End;

Procedure TEzFittedVectorText.MakePolyPointsByCenter( Const Center: TEzPoint );
Var
  DX, DY: Double;
  TmpExt: TEzRect;
Begin
  Initialize;
  DoNormalizedVector( FPoints[0], FPoints );
  TmpExt := FPoints.Extension;
  DX := ( TmpExt.Emax.X - TmpExt.Emin.X ) / 2;
  DY := ( TmpExt.Emax.Y - TmpExt.Emin.Y ) / 2;
  FPoints[0] := Point2D( Center.X - DX, Center.Y + DY );
  UpdateExtension;
End;

function TEzFittedVectorText.IsEqualTo(Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean;
begin
  Result:= False;
  if ( Entity.EntityID <> idFittedVectText ) Or
     ( Inherited IsEqualTo( Entity, IncludeAttribs ) = False )
     {$IFDEF FALSE}Or
     ( IncludeAttribs And
       ( ( FText <> TEzFittedVectorText( Entity ).FText ) Or
         ( FHeight <> TEzFittedVectorText( Entity ).FHeight ) Or
         ( FWidth <> TEzFittedVectorText( Entity ).FWidth ) Or
         ( FAngle <> TEzFittedVectorText( Entity ).FAngle ) Or
         ( FInterCharSpacing <> TEzFittedVectorText( Entity ).FInterCharSpacing ) Or
         ( FInterLineSpacing <> TEzFittedVectorText( Entity ).FInterLineSpacing ) Or
         ( FTextBorderStyle <> TEzFittedVectorText( Entity ).FTextBorderStyle ) Or
         Not EqualPoint2d( FPivot, TEzFittedVectorText( Entity ).FPivot ) Or
         ( FHideShadow <> TEzFittedVectorText( Entity ).FHideShadow ) Or
         ( FFontColor <> TEzFittedVectorText( Entity ).FFontColor ) ) ){$ENDIF} Then Exit;
  Result:= True;
end;

{$IFDEF BCB}
function TEzFittedVectorText.GetAngle: Double;
begin
  Result := FAngle;
end;

function TEzFittedVectorText.GetFontColor: TColor;
begin
  Result := FFontColor;
end;

function TEzFittedVectorText.GetHeight: Double;
begin
  Result := FHeight;
end;

function TEzFittedVectorText.GetHideShadow: Boolean;
begin
  Result := FHideShadow
end;

function TEzFittedVectorText.GetInterCharSpacing: Double;
begin
  Result := FInterCharSpacing;
end;

function TEzFittedVectorText.GetInterLineSpacing: Double;
begin
  Result := FInterLineSpacing;
end;

function TEzFittedVectorText.GetPivot: TEzPoint;
begin
  Result := FPivot;
end;

function TEzFittedVectorText.GetText: String;
begin
  Result := FText;
end;

function TEzFittedVectorText.GetTextBorderStyle: TEzTextBorderStyle;
begin
  Result := FTextBorderStyle;
end;

function TEzFittedVectorText.GetVectorFont: TEzVectorFont;
begin
  Result := FVectorFont;
end;

function TEzFittedVectorText.GetWidth: Double;
begin
  Result := FWidth;
end;

procedure TEzFittedVectorText.SetFontColor(const Value: TColor);
begin
  FFontColor := Value;
end;

procedure TEzFittedVectorText.SetHideShadow(const Value: Boolean);
begin
  FHideShadow := Value;
end;

procedure TEzFittedVectorText.SetTextBorderStyle(
  const Value: TEzTextBorderStyle);
begin
  FTextBorderStyle := Value;
end;

procedure TEzFittedVectorText.SetVectorFont(const Value: TEzVectorFont);
begin
  FVectorFont := Value;
end;

procedure TEzFittedVectorText.SetPivot(const Value: TEzPoint);
begin
  FPivot := Value;
end;
{$ENDIF}

{ TEzVectorCharList }

Constructor TEzVectorCharList.Create;
Begin
  Inherited Create;
  { if there are less than 256 characters in the vector font, then a TList
    is used and if there are > 255 characters, a TList is used for the first
    255 characters and a TSparseList is used for others
    Will this increase the redrawing speed of chars or a TSparseList is enough ? }
  FList := TList.Create;
  FSparseList := TSparseList.Create( SPALarge );
End;

Destructor TEzVectorCharList.Destroy;
Begin
  Clear;
  FList.Free;
  FSparseList.Free;
  Inherited destroy;
End;

Procedure TEzVectorCharList.Clear;
Var
  I: Integer;
  V: TEzVectorChar;
Begin
  For I := 0 To IMin( FCapacity, FList.Count - 1 ) Do
  Begin
    V := TEzVectorChar( FList[I] );
    If V <> Nil Then
      V.Free;
  End;
  If FCapacity > 255 Then
  Begin
    For I := 256 To FCapacity Do
    Begin
      V := TEzVectorChar( FSparseList[I] );
      If V <> Nil Then
        V.Free;
    End;
  End;
  FList.Clear;
  FSparseList.Clear;
End;

Function TEzVectorCharList.Get( Index: Integer ): TEzVectorChar;
Begin
  If Index <= 255 Then  
    Result := TEzVectorChar( FList[Index] )
  Else
    Result := TEzVectorChar( FSparseList[Index] );
End;

Procedure TEzVectorCharList.Put( Index: Integer; Value: TEzVectorChar );
Begin
  If Index <= 255 Then
    FList[Index] := Value
  Else
    FSparseList[Index] := Value;
End;

Procedure TEzVectorCharList.SetCapacity( Value: Integer );
Var
  I: Integer;
Begin
  If Value <= 255 Then
  Begin
    If FList.Capacity < Value Then
      FList.Capacity := Value;
    For I := FList.Count To Value Do
      FList.Add( Nil );
  End
  Else
  Begin
    For I := FList.Count To 255 Do
      FList.Add( Nil );
  End;
End;

{-------------------------------------------------------------------------------}
//                     TEzHatch
{-------------------------------------------------------------------------------}

Constructor TEzHatch.Create;
Begin
  Inherited Create;
  FList := TList.Create;
End;

Destructor TEzHatch.Destroy;
Begin
  Clear;
  FList.Free;
  Inherited destroy;
End;

Procedure TEzHatch.Clear;
Var
  I: Integer;
Begin
  For I := 0 To FList.Count - 1 Do
    Dispose( PEzHatchData( FList[I] ) );
  FList.Clear;
End;

Procedure TEzHatch.Add( Const Hatch: TEzHatchData );
Var
  Item: PEzHatchData;
Begin
  New( Item );
  Item^ := Hatch;
  FList.Add( Item );
End;

Function TEzHatch.Count: Integer;
Begin
  Result := FList.Count;
End;

Function TEzHatch.Get( Index: Integer ): TEzHatchData;
Begin
  If ( Index < 0 ) Or ( Index > FList.Count - 1 ) Then
    exit;
  Result := PEzHatchData( FList[Index] )^;
End;

Procedure TEzHatch.Put( Index: Integer; Const Value: TEzHatchData );
Begin
  If ( Index < 0 ) Or ( Index > FList.Count - 1 ) Then
    exit;
  PEzHatchData( FList[Index] )^ := Value;
End;

Procedure TEzHatch.DrawHatchTo( Vector: TEzVector;
  Const Clip,
  Extent: TEzRect;
  Grapher: TEzGrapher;
  Canvas: TCanvas;
  Color: TColor;
  Const Scale,
  Angle: Double;
  Const Matrix: TEzMatrix );
Var
  HatchData: TEzHatchData;
  I, J: Integer;
  //Ang,
  DashesWidth: Double;
Begin
  //Ang := Angle;
  //If Ang < 0 Then
  //  Ang := Ang + System.PI * 2;
  For I := 0 To FList.Count - 1 Do
  Begin
    HatchData := PEzHatchData( FList[I] )^;
    With HatchData Do
    Begin
      // scale 0 and 1 are equals and means no scaling
      If Not ( ( Scale = 0 ) Or ( Scale = 1 ) ) Then
      Begin
        Origin.X := Origin.X * Scale;
        Origin.Y := Origin.Y * Scale;
        Delta.X := Delta.X * Scale;
        Delta.Y := Delta.Y * Scale;
        For J := 0 To NumDashes - 1 Do
          Dashes[J] := Dashes[J] * Scale;
      End;
      {if Angle<>0 then
      begin
        TmpAngle:=DegToRad(Angle)+Ang;
      end;}
      // calculate width of all dashes
      DashesWidth := 0;
      For J := 0 To NumDashes - 1 Do
        DashesWidth := DashesWidth + Abs( Dashes[J] );

    End;
  End;
End;

{ TEzHatchList }

Constructor TEzHatchList.Create;
Begin
  Inherited Create;
  FList := TList.Create;
End;

Destructor TEzHatchList.Destroy;
Begin
  Clear;
  FList.Free;
  Inherited Destroy;
End;

Function TEzHatchList.Add: TEzHatch;
Begin
  Result := TEzHatch.Create;
  FList.Add( Result );
End;

Function TEzHatchList.Count: Integer;
Begin
  Result := FList.Count;
End;

Function TEzHatchList.Get( Index: Integer ): TEzHatch;
Begin
  Result := Nil;
  If ( Index < 0 ) Or ( Index > FList.Count - 1 ) Then
    exit;
  Result := TEzHatch( FList[Index] );
End;

Procedure TEzHatchList.Put( Index: Integer; Value: TEzHatch );
Begin
  If ( Index < 0 ) Or ( Index > FList.Count - 1 ) Then
    exit;
  FList[Index] := Value;
End;

Procedure TEzHatchList.Clear;
Var
  I, Cnt: Integer;
Begin
  Cnt := FList.Count - 1;
  For I := 0 To Cnt Do
    TEzHatch( FList[I] ).Free;
  FList.Clear;
End;

Procedure TEzHatchList.AddPATFile( Const FileName: String );
Var
  PatElems: TStrings;
  temp: String;
  I, PATLinePos, Code: Integer;
  FFileLines: TStrings;
  Hatch: TEzHatch;
  HatchData: TEzHatchData;
  TempDbl: Double;

  Function SplitElems( Const temp: String;
    CommaFinished: Boolean; MaxDefault: Integer ): Boolean;
  Var
    p: Integer;
    Work: String;
  Begin
    result := true;
    Work := temp;
    p := Pos( ',', Work );
    If p = length( Work ) Then
    Begin
      Work := copy( Work, 1, p - 1 );
      result := false;
    End
    Else
      While ( p > 0 ) And ( length( Work ) > 0 ) Do
      Begin
        PATElems.Add( Trim( Copy( Work, 1, p - 1 ) ) );
        System.Delete( Work, 1, p );
        If length( Work ) > 0 Then
        Begin
          If ( MaxDefault > 0 ) And ( PATElems.Count >= MaxDefault ) Then
            Break;
          p := Pos( ',', Work );
          If Not CommaFinished And ( p = length( Work ) ) Then
            result := false;
        End;
      End;
    If Length( Work ) > 0 Then
      PATElems.Add( Work );
  End;

  Function FetchNextLine( CommaFinished: Boolean; MaxDefault: Integer ): Boolean;
  Var
    temp: String;
  Begin
    PATElems.Clear;
    Repeat
      Repeat
        Inc( PATLinePos );
        Result := PATLinePos < FFileLines.Count;
        If Not Result Then
          Exit;
        temp := Trim( FFileLines[PATLinePos] );
        { this parse assume comments starts on first non blank character on the line }
        If ( length( temp ) > 0 ) And ( temp[1] = ';' ) Then
          temp := ''; // ignore comments
      Until Length( temp ) <> 0;
    Until SplitElems( temp, CommaFinished, MaxDefault ) = true;
  End;

Begin
  // add from an AutoCAD .pat file
  If Not FileExists( FileName ) Then
    Exit;
  FFileLines := TStringList.Create;
  PATElems := TStringList.create;
  Try
    FFileLines.LoadFromFile( FileName );
    PATLinePos := -1;
    Repeat
      If Not FetchNextLine( False, 1 ) Or ( PATElems.Count < 1 ) Then
        Break;

      { detect the name of the  }
      temp := PATElems[0];
      If ( length( temp ) = 0 ) Or ( ( length( temp ) > 0 ) And ( temp[1] <> '*' ) ) Then
        exit;
      Hatch := Self.Add;

      Hatch.Name := copy( temp, 2, Length( temp ) );
      If PATElems.Count > 1 Then
        Hatch.Description := PATElems[1];

      While FetchNextLine( true, -1 ) Do
      Begin
        If PATElems.Count = 0 Then
          Continue;
        temp := PATElems[0];
        If ( Length( temp ) > 0 ) And ( temp[1] = '*' ) Then
        Begin
          Dec( PATLinePos );
          break;
        End;
        If PATElems.Count < 5 Then
          Continue; // not enough data
        // angle
        temp := PATElems[0];
        Val( temp, HatchData.Angle, Code );
        If Code <> 0 Then
          exit;
        If HatchData.Angle < 0 Then
          HatchData.Angle := HatchData.Angle + 360;
        // origin
        temp := PATElems[1];
        Val( temp, HatchData.Origin.X, Code );
        If Code <> 0 Then
          exit;
        temp := PATElems[2];
        Val( temp, HatchData.Origin.Y, Code );
        If Code <> 0 Then
          exit;
        // delta
        temp := PATElems[3];
        Val( temp, HatchData.Delta.X, Code );
        If Code <> 0 Then
          exit;
        temp := PATElems[4];
        Val( temp, HatchData.Delta.Y, Code );
        If Code <> 0 Then
          exit;
        // numdashes
        HatchData.NumDashes := PATElems.Count - 5;
        For I := 0 To HatchData.NumDashes - 1 Do
        Begin
          temp := PATElems[I + 5];
          Val( temp, TempDbl, Code );
          If Code <> 0 Then
            exit;
          HatchData.Dashes[I] := TempDbl;
        End;
        Hatch.Add( HatchData );
      End;
    Until false;
  Finally
    FFileLines.Free;
    PATElems.Free;
  End;
End;

{ TEzTrueTypeText }

Constructor TEzTrueTypeText.CreateEntity( Const Pt: TEzPoint;
  Const Text: String; Const Height, Angle: Double );
Var
  I: Integer;
Begin
  Inherited Create( 5 );
  FontTool.Height := Height;
  FontTool.Angle := Angle;
  FText := Text;
  If FPoints.Count = 0 Then
    For I := 1 To 5 Do
      FPoints.AddPoint( 0, 0 );
  FPoints[0] := Pt;
  FPoints.DisableEvents := False;
  UpdateExtension;
End;

Destructor TEzTrueTypeText.Destroy;
Begin
  FFontTool.Free;
  Inherited Destroy;
End;

Procedure TEzTrueTypeText.Initialize;
begin
  inherited;
  FFontTool := TEzFontTool.Create;
  FFontTool.Assign( Ez_Preferences.DefTTFontStyle );
  PenTool.Style := 0;
  BrushTool.Pattern := 0;
end;

Function TEzTrueTypeText.AttribsAsString: string;
Begin
  with Fonttool do
    Result:= Format(sTTFontInfo, [Name,
      EzBaseExpr.NBoolean[fsbold in Style],
      EzBaseExpr.NBoolean[fsitalic in Style],
      EzBaseExpr.NBoolean[fsUnderline in Style],
      EzBaseExpr.NBoolean[fsStrikeout in Style],
      Color,Windows.ANSI_CHARSET]);
End;

Function TEzTrueTypeText.BasicInfoAsString: string;
Begin
  Result:= Format(sTTTextInfo, [FPoints[0].X,FPoints[0].Y,FText,Ord(FAlignment),
    Fonttool.Height,RadToDeg(Fonttool.Angle)]);
End;

procedure TEzTrueTypeText.UpdateExtension;
begin
  if Assigned(FPoints) and (FPoints.Count > 0) then
  begin
    DoPolyPoints(FPoints[0], False);
    inherited UpdateExtension;
  end;
End;

procedure TEzTrueTypeText.ApplyTransform;
var
  Cnt, PtCnt: Integer;
begin
  BeginUpdate;
  try
    PtCnt := Pred(FPoints.Count);
    for Cnt := 0 to PtCnt do
      FPoints[Cnt] := TransformPoint2D(FPoints[Cnt], Self.GetTransformMatrix);
    Self.SetTransformMatrix(IDENTITY_MATRIX2D);
    if FFontTool = nil then
      FFontTool := TEzFontTool.Create;
    FFontTool.Angle := Angle2D(FPoints[0], FPoints[3]);
    UpdateExtension;
  finally
    EndUpdate;
  end;
end;

procedure TEzTrueTypeText.DoPolyPoints(const XY: TEzPoint; ByCenter: Boolean;
  Grapher: TEzGrapher = nil);
var
  TmpWidth, TmpHeight: Double;
  IntWidth, IntHeight: LongWord;
  dc: HDC;
  NewFont, OldFont: HFont;
  Origin: TEzPoint;
  fnWeight: Integer;

  tm: TTEXTMETRIC;
  FontHeightPixels: Integer;
  fdwItalic, fdwUnderline, fdwStrikeOut: Integer;
  FontName: String;
  M: TEzMatrix;
  OldDisable, OldCanGrow: Boolean;
  CharPos: Integer;
  Workstr: String;
  Workrow: String;
  I: Integer;
  ASize: TSize;

  function TextLineWidth(const Str: String): LongWord;
  var
    abc: TABC;
    I, StrLen: Integer;
  begin
    Result := 0;
    StrLen := Length(Str);
    for I := 1 to StrLen do
    begin
      GetCharABCWidths(dc, Ord(Str[I]), Ord(Str[I]), abc);
      if abc.abcA > 0 then
        Inc(Result, abc.abcA);
//        Result := Result + LongWord(abc.abcA);
      Result := Result + LongWord(abc.abcB);
      if abc.abcC > 0 then
        Inc(Result, LongWord(abc.abcC));
//        Result := Result + LongWord(abc.abcC);
    end;
  end;

begin
  Origin := XY;
  OldDisable := FPoints.DisableEvents;
  FPoints.DisableEvents := true;
  OldCanGrow := FPoints.CanGrow;
  FPoints.CanGrow := true;
  try
    if FPoints.Count <> 5 then
    begin
      FPoints.Clear;
      for I := 1 to 5 do
        FPoints.AddPoint( 0, 0 );
    end;
    IntWidth := 0;
    IntHeight := 0;
    if FText <> '' then
    begin
      { calculate text width }
      dc := GetDC(0);
      try
        { 1/8 of the viewport height will represent the height }
        if fsBold in FFontTool.Style then
          fnWeight := FW_BOLD
        else
          fnWeight := FW_NORMAL;
        // BasePoints is the base point for the calculation
        if Assigned(Grapher) then
          FontHeightPixels := Grapher.RealToDistY(FFontTool.Height)
        else
          FontHeightPixels := Trunc(24 * GetDeviceCaps(dc, LOGPIXELSY) / 72);
        if fsItalic in FFontTool.Style then
          fdwItalic := 1
        else
          fdwItalic := 0;
        if fsUnderline in FFontTool.Style then
          fdwUnderline := 1
        else
          fdwUnderline := 0;
        if fsStrikeOut in FFontTool.Style then
          fdwStrikeOut := 1
        else
          fdwStrikeOut := 0;
        FontName := FFontTool.Name;
        NewFont := CreateFont(FontHeightPixels, 0, 0, 0,
          fnWeight, fdwItalic, fdwUnderline, fdwStrikeOut,
          DEFAULT_CHARSET, OUT_TT_ONLY_PRECIS,
          CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE,
          PChar(FontName));
        OldFont := SelectObject(dc, NewFont);
        if AnsiPos(#13, FText) = 0 then
        begin
          // single line text
          ASize.cX := 0;
          ASize.cY := 0;
          Windows.GetTextExtentPoint32(dc, PChar(FText), Length(FText), ASize);
          IntWidth := IntWidth + LongWord(ASize.cX);
          IntHeight := IntHeight + LongWord(ASize.cY);
        end
        else
        begin
          // multi-line text
          Workstr := FText;
          CharPos := AnsiPos(#13, Workstr);
          while CharPos > 0 do
          begin
            Workrow := Copy(Workstr, 1, Pred(CharPos));
            System.Delete(Workstr, 1, CharPos);
            if WorkStr[1] = #10 then
              System.Delete(Workstr, 1, 1);
            if WorkRow = '' then
              WorkRow := ' ';
            ASize.cX := 0;
            ASize.cY := 0;
            Windows.GetTextExtentPoint32(dc, PChar(Workrow), Length(Workrow), ASize);
            IntWidth := EzLib.IMax(IntWidth, ASize.cX);
            IntHeight := IntHeight + LongWord(ASize.cY);

            CharPos := AnsiPos(#13, Workstr);
          end;
          if WorkRow = '' then
            WorkRow := ' ';
          ASize.cX := 0;
          ASize.cY := 0;
          Windows.GetTextExtentPoint32(dc, PChar(Workrow), Length(Workrow), ASize);
          IntWidth := EzLib.IMax(IntWidth, ASize.cX);
          IntHeight := IntHeight + LongWord(ASize.cY);
          GetTextMetrics(dc, tm);
          IntHeight := IntHeight + LongWord(tm.tmExternalLeading);
        end;
        SelectObject(dc, OldFont);
        DeleteObject(NewFont);

        if Assigned(Grapher) then
        begin
          TmpWidth := Grapher.DistToRealX(IntWidth);
          TmpHeight := Grapher.DistToRealY(IntHeight);
        end
        else
        begin
          TmpWidth := (IntWidth / FontHeightPixels) * FFontTool.Height;
          TmpHeight := (IntHeight / FontHeightPixels) * FFontTool.Height;
        end;

        { now calculate the points }
        if ByCenter then
        begin
          Origin.X := Origin.X - TmpWidth / 2;
          Origin.Y := Origin.Y - TmpHeight / 2;
        end;
        FPoints[0] := Origin;
        FPoints[1] := Point2D(Origin.X, Origin.Y - TmpHeight);
        FPoints[2] := Point2D(Origin.X + TmpWidth, FPoints[1].Y);
        FPoints[3] := Point2D(FPoints[2].X, Origin.Y);
        { rotate around first point }
        if FFontTool.Angle <> 0 then
        begin
          M := Rotate2D(FFontTool.Angle, Origin);
          { Rotate the polygon }
          FPoints[1] := TransformPoint2D(FPoints[1], M);
          FPoints[2] := TransformPoint2D(FPoints[2], M);
          FPoints[3] := TransformPoint2D(FPoints[3], M);
        end;
        FPoints[4] := FPoints[0];
      finally
        ReleaseDC(0, dc);
      end;
    end;
  finally
    FPoints.DisableEvents := OldDisable;
    FPoints.CanGrow := OldCanGrow;
  end;
end;

Procedure TEzTrueTypeText.Draw(Grapher: TEzGrapher; Canvas: TCanvas;
  const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer = nil);
var
  TmpRect: TRect;
  TmpHeight: Integer;
  Origin: TPoint;
  DrawFlags: Word;
  WasCalculated, IsSingleLine, PointsCalculated: Boolean;
  UseAngle: Double;
  UseWorldTransform: Boolean;
  TmpR: TEzRect;
  xForm: TXForm;
Begin
  if not Ez_Preferences.ShowText then Exit;

  // ≈ÒÎË ÌÂÓ·ıÓ‰ËÏÓ ËÒÛÂÏ ÔÓÎË„ÓÌ ÔÓ‰ ÚÂÍÒÚÓÏ
  PointsCalculated := DrawPolygon(Grapher, Canvas, Clip, DrawMode);

  if Self.HasTransform then
  begin
    TmpR.Emin := FPoints[0];
    TmpR.Emax := Point2D(
      FPoints[0].X + FFontTool.Height,
      FPoints[0].Y + FFontTool.Height
      );
    TmpR := TransformRect2d(TmpR, Self.GetTransformMatrix);
    TmpHeight := Abs(Grapher.RealToDistY(Abs(TmpR.Y2 - TmpR.Y1)));
  end
  else
    TmpHeight := Abs(Grapher.RealToDistY(FFontTool.Height));
  if TmpHeight <= 1 then
  begin
    Origin := Grapher.RealToPoint(
      TransformPoint2D(FPoints[0], Self.GetTransformMatrix)
    );
    Canvas.Pixels[Origin.X, Origin.Y] := FFontTool.Color;
    Exit;
  end;

  WasCalculated := False;

  if DrawMode = dmSelection then
  begin
    if not PointsCalculated then
      DoPolyPoints(FPoints[0], False, Grapher);
    WasCalculated := True;
    FPoints.DrawClosed(Canvas, Clip, FBox, Grapher, PenTool.FPenStyle,
      BrushTool.FBrushStyle, Self.GetTransformMatrix, DrawMode, nil);
  end;

  { draw the text }
  Canvas.Font.Name := FFontTool.Name;
  Canvas.Font.Style := FFontTool.Style;
  Canvas.Font.Height := TmpHeight;
  Canvas.Font.Color := FFontTool.Color;
  if Grapher.Device = adPrinter then
    Canvas.Font.PixelsPerInch := Grapher.PrinterDpiY;
  UseAngle := FFontTool.Angle;
  IsSingleLine := AnsiPos(#13, FText) = 0;

  { path }
  if DrawMode = dmRubberPen then
    BeginPath(Canvas.Handle);
  UseWorldTransform := (DrawMode <> dmRubberPen) and (UseAngle <> 0);
  if UseWorldTransform then
  begin
    SetGraphicsMode(Canvas.Handle, GM_ADVANCED);
    Origin := Grapher.RealToPoint(TransformPoint2D(FPoints[0], Self.GetTransformMatrix));
    with xForm do
    begin
      eM11 := cos(-UseAngle);
      eM12 := sin(-UseAngle);
      eM21 := -eM12;
      eM22 := eM11;
      eDx := Origin.X;
      eDy := Origin.Y;
    end;
    SetWorldTransform(Canvas.Handle, xForm);
  end;

  SetBkMode(Canvas.Handle, TRANSPARENT);

  if IsSingleLine then
  begin
    if UseWorldTransform then
      Origin := Point(0, 0)
    else
      Origin := Grapher.RealToPoint(TransformPoint2D(FPoints[0], Self.GetTransformMatrix));
    Canvas.TextOut(Origin.X, Origin.Y, FText);
  end
  else
  begin
    if not WasCalculated and not (FAlignment = taLeftJustify) then
      MakePolyPoints(Grapher);
    if UseWorldTransform then
    begin
      TmpRect := Rect(0, 0, 0, 0);
      DrawFlags := DT_CALCRECT;
      Windows.DrawText(Canvas.Handle, PChar(FText), Length(FText), TmpRect, DrawFlags);
    end
    else
    begin
      TmpRect.TopLeft := Grapher.RealToPoint(TransformPoint2D(FPoints[0], Self.GetTransformMatrix));
      TmpRect.BottomRight := Grapher.RealToPoint(TransformPoint2D(FPoints[2], Self.GetTransformMatrix));
    end;
    DrawFlags := 0;
    case FAlignment of
      taLeftJustify: DrawFlags := DT_LEFT;
      taRightJustify: DrawFlags := DT_RIGHT;
      taCenter: DrawFlags := DT_CENTER;
    end;
    DrawFlags := DrawFlags or DT_NOCLIP or DT_NOPREFIX or DT_VCENTER;
    Windows.DrawText(Canvas.Handle, PChar(FText), Length(FText), TmpRect, DrawFlags);
  end;
  if UseWorldTransform then
  begin
    with xForm do
    begin
      eM11 := 1;
      eM12 := 0;
      eM21 := 0;
      eM22 := 1;
      eDx := 0;
      eDy := 0;
    end;
    SetWorldTransform(Canvas.Handle, xForm);
  end;

  { create the path path }
  if DrawMode = dmRubberPen then
  begin
    EndPath(Canvas.Handle);
    DrawAsPath(Grapher, Canvas, Clip, DrawMode, Data);
  end;
end;

Function TEzTrueTypeText.GetEntityID: TEzEntityID;
Begin
  result := idTrueTypeText;
End;

function TEzTrueTypeText.GetFontTool: TEzFontTool;
begin
  If FFontTool = Nil Then
    FFonttool:= TEzFonttool.Create;
  Result := FFontTool;
end;

{$IFDEF BCB}
function TEzTrueTypeText.GetAlignment: TAlignment;
begin
  Result := FAlignment;
end;

function TEzTrueTypeText.GetText: String;
begin
  Result := FText;
end;

procedure TEzTrueTypeText.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
end;

procedure TEzTrueTypeText.SetText(const Value: String);
begin
  FText := Value;
end;
{$ENDIF}

Procedure TEzTrueTypeText.LoadFromStream( Stream: TStream );
Begin
  If FFontTool = Nil Then
    FFontTool := TEzFontTool.Create;
  FPoints.DisableEvents := true;
  Inherited LoadFromStream( Stream ); // read ID and points
  FFontTool.LoadFromStream( stream );
  FText := EzReadStrFromStream( stream );
  FPoints.DisableEvents := false;
  FPoints.CanGrow := false;
  FPoints.OnChange := UpdateExtension;
  FOriginalSize := StorageSize;
  UpdateExtension;
End;

Procedure TEzTrueTypeText.SaveToStream( Stream: TStream );
Begin
  Inherited SaveToStream( stream ); // save ID and points
  FFontTool.SaveToStream( stream );
  EzWriteStrToStream( FText, stream );
  FOriginalSize := StorageSize;
End;

Procedure TEzTrueTypeText.MakePolyPoints(Grapher: TEzGrapher = Nil);
Begin
  DoPolyPoints( FPoints[0], false, Grapher );
End;

Procedure TEzTrueTypeText.MakePolyPointsByCenter( Const XY: TEzPoint;
  Grapher: TEzGrapher = Nil );
Begin
  DoPolyPoints( XY, true, Grapher );
End;

Procedure TEzTrueTypeText.ShowDirection( Grapher: TEzGrapher;
  Canvas: TCanvas;
  Const Clip: TEzRect;
  DrawMode: TEzDrawMode;
  DirectionPos: TEzDirectionpos;
  Const DirectionPen: TEzPenStyle;
  Const DirectionBrush: TEzBrushStyle;
  RevertDirection: Boolean );
Begin
  // nothing to do here
End;

Function TEzTrueTypeText.StorageSize: Integer;
Begin
  Result := Inherited StorageSize + Length( FText ) + Length( FFontTool.Name );
End;

Function TEzTrueTypeText.GetBasePoint: TEzPoint;
Var
  I: Integer;
Begin
  If FPoints.Count = 0 Then
    For I := 1 To 5 Do
      FPoints.AddPoint( 0, 0 );
  result := FPoints[0];
End;

Procedure TEzTrueTypeText.SetBasePoint( Const Value: TEzPoint );
Var
  I: Integer;
Begin
  If FPoints.Count = 0 Then
    For I := 1 To 5 Do
      FPoints.AddPoint( 0, 0 );
  FPoints[0] := Value;
  UpdateExtension;
End;

Function TEzTrueTypeText.GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector;
Var
  MovePt: TEzPoint;
  V: TEzVector;
Begin
  Result := TEzVector.Create( 10 );
  { 0-4 (0)           7              3  (6)
    +---------------+---------------+
    |                               |
  1 +                               + 5
    |                               |
    +---------------+---------------+
    1 (2)           3               2 (4)
  }
  If ( FPoints = Nil ) Or ( FPoints.Count <> 5 ) Then
    UpdateExtension;
  V := FPoints;
  With Result Do
  Begin
    Add( V[0] );
    AddPoint( ( V[0].X + V[1].X ) / 2, ( V[0].Y + V[1].Y ) / 2 );
    Add( V[1] );
    AddPoint( ( V[1].X + V[2].X ) / 2, ( V[1].Y + V[2].Y ) / 2 );
    Add( V[2] );
    AddPoint( ( V[2].X + V[3].X ) / 2, ( V[2].Y + V[3].Y ) / 2 );
    Add( V[3] );
    AddPoint( ( V[0].X + V[3].X ) / 2, ( V[0].Y + V[3].Y ) / 2 );
    if TransfPts then
    begin
      Self.Centroid( MovePt.X, MovePt.Y );
      Add( MovePt );
      AddPoint( ( MovePt.X + Result[5].X ) / 2, ( MovePt.Y + Result[5].Y ) / 2 );
    end;
  End;
End;

Function TEzTrueTypeText.GetControlPointType( Index: Integer ): TEzControlPointType;
Begin
  Result := cptNode;
  If Index = 8 Then
    Result := cptMove
  Else If Index = 9 Then
    Result := cptRotate;
End;

Procedure TEzTrueTypeText.UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil );
Var
  M: TEzMatrix;
  TmpPt, theMovePt, theRotatePt: TEzPoint;
  I, Cnt: Integer;
  phiStart, phiEnd: Double;
  V: TEzVector;
Begin
  FPoints.DisableEvents := True;
  Try
    { 0 (0-4)          7                  6 (3)
      +---------------+-------------------+
      |                                   |
    1 +                                   + 5
      |                                   |
      +---------------+-------------------+
      2 (1)           3                   4 (2)
    }
    V := FPoints;
    Case Index Of
      0: // calculate the point
        Begin
          V[0] := Value;
          V[4] := Value;
          V[1] := Perpend( Value, V[1], V[2] );
          V[3] := Perpend( Value, V[2], V[3] );
          FFontTool.Height := Dist2d( V[0], V[1] );
        End;
      1:
        Begin
          V[0] := Perpend( Value, V[0], V[3] );
          V[4] := V[0];
          V[1] := Perpend( Value, V[1], V[2] );
        End;
      2:
        Begin
          V[1] := Value;
          V[0] := Perpend( Value, V[0], V[3] );
          V[4] := V[0];
          V[2] := Perpend( Value, V[2], V[3] );
          FFontTool.Height := Dist2d( V[0], V[1] );
        End;
      3:
        Begin
          V[1] := Perpend( Value, V[0], V[1] );
          V[2] := Perpend( Value, V[2], V[3] );
          FFontTool.Height := Dist2d( V[0], V[1] );
        End;
      4:
        Begin
          V[2] := Value;
          V[1] := Perpend( Value, V[0], V[1] );
          V[3] := Perpend( Value, V[0], V[3] );
          FFontTool.Height := Dist2d( V[0], V[1] );
        End;
      5:
        Begin
          V[2] := Perpend( Value, V[1], V[2] );
          V[3] := Perpend( Value, V[0], V[3] );
        End;
      6:
        Begin
          V[3] := Value;
          V[0] := Perpend( Value, V[0], V[1] );
          V[4] := V[0];
          V[2] := Perpend( Value, V[1], V[2] );
          FFontTool.Height := Dist2d( V[0], V[1] );
        End;
      7:
        Begin
          V[3] := Perpend( Value, V[2], V[3] );
          V[0] := Perpend( Value, V[0], V[1] );
          V[4] := V[0];
          FFontTool.Height := Dist2d( V[0], V[1] );
        End;
      8: // the move point
        Begin
          // calculate current move point
          Self.Centroid( theMovePt.X, theMovePt.Y );
          M := Translate2d( Value.X - theMovePt.X, Value.Y - theMovePt.Y );
          Cnt := V.Count - 1;
          For I := 0 To Cnt Do
            V[I] := TransformPoint2d( V[I], M );
        End;
      9: // the rotate point
        Begin
          Self.Centroid( theMovePt.X, theMovePt.Y );
          TmpPt := Point2d( ( V[2].X + V[3].X ) / 2, ( V[2].Y + V[3].Y ) / 2 );
          TheRotatePt := Point2d( ( theMovePt.X + Tmppt.X ) / 2, ( theMovePt.Y + Tmppt.Y ) / 2 );
          phiStart := Angle2D( theRotatePt, theMovePt );
          phiEnd := Angle2d( value, theMovePt );
          M := Rotate2d( phiEnd - phiStart, theMovePt );
          Cnt := V.Count - 1;
          For I := 0 To Cnt Do
            V[I] := TransformPoint2d( V[I], M );
          FFontTool.Angle := Angle2d( V[0], V[3] );
        End;
    End;
  Finally
    FPoints.DisableEvents := false;
  End;
End;

function TEzTrueTypeText.IsEqualTo(Entity: TEzEntity; IncludeAttribs: Boolean  = false): Boolean;
begin
  Result:= False;
  if Not ( Entity.EntityID = idTrueTypeText ) Or
    ( Inherited IsEqualTo( Entity, IncludeAttribs ) = False )
    {$IFDEF FALSE}Or
    ( IncludeAttribs And ( ( FText <> TEzTrueTypeText(Entity).FText ) Or
                           ( FAlignment <> TEzTrueTypeText(Entity).FAlignment ) Or
                             Not CompareMem( @FFontTool.FFontStyle,
                                             @TEzTrueTypeText(Entity).FFontTool.FFontStyle,
                                             SizeOf( TEzFontStyle ) ) ) ){$ENDIF} Then Exit;
  Result:= True;
end;


{ TmstMap500Entity }

const
  I_MAP500_SIZE = 250; // ‚ ÏÂÚ‡ı
  S_NOMENCLATURE_CHARS = '¿¡¬√ƒ≈∆«» ÀÃÕŒœ–—“”‘’÷◊ÿŸ›ﬁﬂ';
  
constructor TEzMap500Entity.CreateEntity(const ANomenclature: String);
begin
  inherited CreateEntity(Point2D(0, 0), Point2D(0 + I_MAP500_SIZE, 0 - I_MAP500_SIZE));
  Nomenclature := ANomenclature;
end;

destructor TEzMap500Entity.Destroy;
begin
  FText.Free;
  inherited;
end;

procedure TEzMap500Entity.Draw(Grapher: TEzGrapher; Canvas: TCanvas;
  const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer);
begin
  inherited;
  FText.Draw(Grapher, Canvas, Clip, DrawMode, Data);
end;

function TEzMap500Entity.GetFontTool: TEzFontTool;
begin
  Result := FText.FontTool;
end;

procedure TEzMap500Entity.LoadFromStream(Stream: TStream);
begin
  inherited;
  Nomenclature := EzReadStrFromStream(Stream);
  FontTool.LoadFromStream(Stream);
end;

function TEzMap500Entity.LatinToArabian(const Latin: String): Integer;
var
  I, L1, L2, Last: Integer;

  function GetNumber(const A: Char): Integer;
  begin
    case A of
    'X' : Result := 10;
    'I' : Result := 1;
    'V' : Result := 5;
    else  Result := 0;
    end;
  end;

begin
  Result := 0;
  Last := 0;
  L2 := 0;
  case Length(Latin) of
  0 : Exit;
  1 : Result := GetNumber(Latin[1]);
  else
      begin
        I := 2;
        while I <= Length(Latin) do
        begin
          L1 := GetNumber(Latin[Pred(I)]);
          L2 := GetNumber(Latin[I]);
          if L2 > L1 then
          begin
            Dec(L2, L1);
            Inc(Result, L2);
            Last := I;
            Inc(I, 2);
          end
          else
          begin
            Inc(Result, L1);
            Last := Pred(I);
            Inc(I);
          end;
        end;
        if Last < Length(Latin) then
          Inc(Result, L2);
      end;
  end;
end;

function TEzMap500Entity.SetTopLeft(var X, Y: Integer): Boolean;
var
  Parts: TStringList;
  K, I: Integer;
  S: String;
begin
  Result := False;
  Parts := TStringList.Create;
  try
    Parts.Delimiter := '-';
    Parts.DelimitedText := Nomenclature;
    if Parts.Count < 3 then
    begin
      FNomenclature := 'Œ¯Ë·Í‡';
      Parts.Free;
      Exit;
    end;
    // Ò˜ËÚ‡ÂÏ x
    S := Parts.Strings[0];
    if S[1] = '0' then
    begin
      I := Pos(S[2], S_NOMENCLATURE_CHARS);
      if I < 1 then
      begin
        Parts.Free;
        Exit;
      end;
      if I < 23 then
        X := I + 13
      else
        X := I - 42;
    end
    else
    begin
      I := Pos(S[1], S_NOMENCLATURE_CHARS);
      if I < 1 then
      begin
        Parts.Free;
        Exit;
      end;
      X := 14 - I;
    end;
    X := X * 1000;
    K := StrToInt(Parts.Strings[2]);
    case K of
    1, 2, 3, 4     : ;//X := X;
    5, 6, 7, 8     : Dec(X, 250);
    9, 10, 11, 12  : Dec(X, 500);
    13, 14, 15, 16 : Dec(X, 750);
    else
      begin
        Parts.Free;
        Exit;
      end;
    end;
    // Ò˜ËÚ‡ÂÏ y
    S := Parts.Strings[1];
    if (S[1] = '0') and (Length(S) > 1) then
      Delete(S, 1, 1);
    I := LatinToArabian(S);
    Y := (I - 11) * 1000;
    case K of
    1, 5, 9, 13  : ;//Y := Y;
    2, 6, 10, 14 : Y := Y + 250;
    3, 7, 11, 15 : Y := Y + 500;
    4, 8, 12, 16 : Y := Y + 750;
    else
      begin
        Parts.Free;
        Exit;
      end;
    end;
    Result := True;
  finally
    Parts.Free;
  end;
end;

procedure TEzMap500Entity.SaveToStream(Stream: TStream);
begin
  inherited;
  EzWriteStrToStream(Nomenclature, Stream);
  FontTool.SaveToStream(Stream);
end;

procedure TEzMap500Entity.SetNomenclature(const Value: String);
begin
  if Value = '' then
    FNomenclature := 'Œ¯Ë·Í‡'
  else
    FNomenclature := Value;
  ReCreate;
end;

procedure TEzMap500Entity.CreateText;
begin
  if Assigned(FText) then
    FreeAndNil(FText);
  FText := TEzTrueTypeText.CreateEntity(Point2D(0, 0), FNomenclature, I_MAP500_SIZE div 10, 0);
  // —ÏÂ˘‡ÂÏ ‚ ˆÂÌÚ Í‚‡‰‡Ú‡
  FText.BasePoint := Point2D(
    Self.FBox.xmin + (I_MAP500_SIZE - FText.FBox.xmax - FText.FBox.xmin) / 2,
    Self.FBox.ymin + I_MAP500_SIZE / 2 + FText.FontTool.Height / 2
  );
end;

function TEzMap500Entity.GetEntityID: TEzEntityID;
begin
  Result := idMap500;
end;

procedure TEzMap500Entity.Initialize;
begin
  inherited;
  if NomenclatureIsBad then
    Nomenclature := '';
  ReCreate;
end;

procedure TEzMap500Entity.ReCreate;
var
  Left, Top: Integer;
begin
  if NomenclatureIsBad or not SetTopLeft(Top, Left) then
  begin
    Left := 0;
    Top := 0;
  end;
  if Points.Count = 2 then
  begin
    Points[0] := Point2D(Left, Top);
    Points[1] := Point2D(Left + I_MAP500_SIZE, Top - I_MAP500_SIZE);
  end;
  CreateText;
end;

function TEzMap500Entity.NomenclatureIsBad: Boolean;
begin
  Result := (FNomenclature = '') or (FNomenclature = 'Œ¯Ë·Í‡');
end;

function TEzTrueTypeText.DrawPolygon(Grapher: TEzGrapher; Canvas: TCanvas;
  const Clip: TEzRect; DrawMode: TEzDrawMode): Boolean;
begin
  Result := (Pentool.Style <> 0) or (Brushtool.Pattern <> 0);
  if Result then
  begin
    DoPolyPoints(FPoints[0], False, Grapher);
    inherited Draw(Grapher, Canvas, Clip, DrawMode);
  end;
end;

procedure TEzTrueTypeText.DrawAsPath(Grapher: TEzGrapher; Canvas: TCanvas;
  const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer);
type
  TTypesArray = array[0..1000000] of Byte;    // array of bytes storing vertex types
var
  TmpVector: TEzVector;
  APoints: PPointArray;
  Types: ^TTypesArray;
  Entity: tEzEntity;
  EntityList: TEzEntityList;
  I, PtCount, TmpCount: Integer;
  UseAngle: Double;
  TextBasePoint: TEzPoint;
  Matrix: tEzMatrix;
begin
  try
    { Convert the path into a series of lines segment }
    FlattenPath(Canvas.Handle);
    {  etrieve the number of points defining the path }
    APoints := nil;
    Types := nil;
    PtCount := GetPath(Canvas.Handle, APoints^, Types^, 0);
    if PtCount <= 0 then Exit;

    { allocate enough memory to store the points and their type flags }
    GetMem(APoints, SizeOf(TPoint) * PtCount);
    GetMem(Types, SizeOf(Byte) * PtCount);

    { retrieves the points and vertex types of the path }
    GetPath(Canvas.Handle, APoints^, Types^, PtCount);

    UseAngle := FFontTool.Angle;
    if UseAngle <> 0 then
    begin
      TextBasePoint := TransformPoint2D(FPoints[0], Self.GetTransformMatrix);
      Matrix := Rotate2d(UseAngle, TextBasePoint);
    end;

    TmpVector := TEzVector.Create(500);
    EntityList := TEzEntityList.Create;
    try
      Dec(PtCount);
      for I := 0 to PtCount do
      begin
        { record the type of point }
        case Types[I] and not PT_CLOSEFIGURE of
        PT_MOVETO :
          begin
            { start of new entity }
            TmpVector.Clear;
            TmpVector.Add(Grapher.PointToReal(APoints[I]));
          end;
        PT_LINETO :
          begin
            TmpVector.Add(Grapher.PointToReal(APoints[I]));
          end;
        end;

        { check if it is a closed figure }
        if (Types[I] and PT_CLOSEFIGURE) = PT_CLOSEFIGURE then
        begin
          { create a polygon entity }
          if TmpVector.Count > 2 then
          begin
            Entity := TEzPolygon.Create(TmpVector.Count);
            Entity.Points.Assign(TmpVector);
            if UseAngle <> 0 then
            begin
              Entity.SetTransformMatrix(Matrix);
              Entity.ApplyTransform;
            end;
            EntityList.Add(Entity);
          end;
        end;
      end;
      { draw the entity list }
      TmpCount := Pred(EntityList.Count);
      for I := 0 to TmpCount do
        EntityList[I].Draw(Grapher, Canvas, Clip, DrawMode, Data);
    finally
      TmpVector.Free;
      EntityList.Free;
      { free the memory used to store the points and vertex types }
      FreeMem(APoints);
      FreeMem(Types);
    end;
  finally
    AbortPath(Canvas.Handle);
  end;
end;

{ TEzAxis }

procedure TEzAxis.CreateAdditionalLines;
begin
  if FPoints.Count <> 2 then
    Exit;
  CreateFirstAddLine;
  CreateSecondAddLine;
  UpdateExtension;
end;

constructor TEzAxis.CreateEntity(const P1, P2: TEzPoint;
  const aName: String);
begin
  inherited CreateEntity([P1, P2], False);
  FName := aName;
  FShowNameAtTop := True;
  FShowNameAtBottom := True;
  PenTool.Color := clBackground;
  CreateAdditionalLines;
end;

procedure TEzAxis.CreateFirstAddLine;
var
  W, H, W1, H1: Double;
  A, B, P: TEzPoint;
  S: String;
begin
  W := Point1.x - Point2.x;
  H := Point1.y - Point2.y;
  A := Point2D(Point1.x + W / 10, Point1.y + H / 10);
  FreeAndNil(FAdd1);
  FAdd1 := TEzPolyline.CreateEntity([A, Point1], False);
//  FAdd1.PenTool.Assign(Self.PenTool);
  //
  FreeAndNil(FLabel1);
  if FName <> '' then
    S := FName
  else
    S := 'L';

  W1 := Dist2D(Point1, Point2) / 20;
  FLabel1 := TEzTrueTypeText.CreateEntity(A, S, W1, 0);
  //
  FreeAndNil(FCircle1);
//  W1 := W1 * 2;
//  B := Point2D(A.x + W / 10, A.y + H / 10);
//  FCircle1 := TEzEllipse.CreateEntity(Point2D(B.x - W1 / 2, B.y - W1 / 2), Point2D(B.x + W1 / 2, B.y + W1 / 2));
  //
//  FLabel1.Centroid(P.x, P.y);
//  FLabel1.MoveTo(P, B);
end;

procedure TEzAxis.CreateSecondAddLine;
var
  W, H, W1, H1: Double;
  A, B, P: TEzPoint;
  S: String;
begin
  W := Point1.x - Point2.x;
  H := Point1.y - Point2.y;
  A := Point2D(Point2.x - W / 10, Point2.y - H / 10);
  FreeAndNil(FAdd2);
  FAdd2 := TEzPolyline.CreateEntity([A, Point2], False);
//  FAdd2.PenTool.Assign(Self.PenTool);
  //
  FreeAndNil(FCircle2);
  W1 := Dist2D(Point1, Point2) / 20;
//  B := Point2D(A.x + W / 10, A.y + H / 10);
//  FCircle2 := TEzEllipse.CreateEntity(Point2D(B.x - W1 / 2, B.y - W1 / 2), Point2D(B.x + W1 / 2, B.y + W1 / 2));
  //
  FreeAndNil(FLabel2);
  if FName <> '' then
    S := FName
  else
    S := 'L';
  FLabel2 := TEzTrueTypeText.CreateEntity(A, S, W1, 0);
//  FLabel2.FontTool.Color := Self.PenTool.Color;
//  FLabel2.Centroid(P.x, P.y);
//  FLabel2.MoveTo(P, B);
end;

destructor TEzAxis.Destroy;
begin
  FreeAndNil(FAdd1);
  FreeAndNil(FAdd2);
  FreeAndNil(FCircle1);
  FreeAndNil(FCircle2);
  FreeAndNil(FLabel1);
  FreeAndNil(FLabel2);
  inherited;
end;

procedure TEzAxis.Draw(Grapher: TEzGrapher; Canvas: TCanvas;
  const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer);
begin
  inherited;
  if ShowNameAtTop then
  begin
    if Assigned(FAdd1) then
    begin
      FAdd1.PenTool.Assign(Self.PenTool);
      FAdd1.Draw(Grapher, Canvas, Clip, DrawMode, Data);
    end;
    if Assigned(FCircle1) then
    begin
      FCircle1.PenTool.Color := Self.PenTool.Color;
      FCircle1.Draw(Grapher, Canvas, Clip, DrawMode, Data);
    end;
    if Assigned(FLabel1) then
    begin
      if DrawMode = dmSelection then
        FLabel1.FontTool.Color := Ez_Preferences.SelectionPen.Color
      else
        FLabel1.FontTool.Color := Self.PenTool.Color;
      FLabel1.Draw(Grapher, Canvas, Clip, DrawMode, Data);
    end;
  end;
  if ShowNameAtBottom then
  begin
    if Assigned(FAdd2) then
    begin
      FAdd2.PenTool.Assign(Self.PenTool);
      FAdd2.Draw(Grapher, Canvas, Clip, DrawMode, Data);
    end;
    if Assigned(FCircle2) then
    begin
      FCircle2.PenTool.Color := Self.PenTool.Color;
      FCircle2.Draw(Grapher, Canvas, Clip, DrawMode, Data);
    end;
    if Assigned(FLabel2) then
    begin
      if DrawMode = dmSelection then
        FLabel2.FontTool.Color := Ez_Preferences.SelectionPen.Color
      else
        FLabel2.FontTool.Color := Self.PenTool.Color;
//      FLabel2.FontTool.Color := Self.PenTool.Color;
      FLabel2.Draw(Grapher, Canvas, Clip, DrawMode, Data);
    end;
  end;
end;

function TEzAxis.GetEntityID: TEzEntityID;
begin
  Result := idAxis;
end;

function TEzAxis.GetPoint1: TEzPoint;
begin
  Result := Self.Points[0];
end;

function TEzAxis.GetPoint2: TEzPoint;
begin
  Result := Self.Points[1];
end;

procedure TEzAxis.Initialize;
begin
  inherited;
  CreateAdditionalLines;
end;

procedure TEzAxis.LoadFromStream(Stream: TStream);
begin
  inherited;
  FName := EzReadStrFromStream(Stream);
  Stream.Read(FShowNameAtTop, SizeOf(FShowNameAtTop));
  Stream.Read(FShowNameAtBottom, SizeOf(FShowNameAtBottom));
  CreateAdditionalLines;
end;

function TEzAxis.PointCode(const Pt: TEzPoint; const Aperture: Double;
  var Distance: Double; SelectPickingInside,
  UseDrawPoints: Boolean): Integer;
var
  I: Integer;
begin
  Result := inherited PointCode(Pt, Aperture, Distance, SelectPickingInside, UseDrawPoints);
  if Result = PICKED_NONE then
  begin
    if Assigned(FAdd1) then
      Result := FAdd1.PointCode(Pt, Aperture, Distance, SelectPickingInside, UseDrawPoints);
    if Result = PICKED_NONE then
    begin
      if Assigned(FAdd2) then
        Result := FAdd2.PointCode(Pt, Aperture, Distance, SelectPickingInside, UseDrawPoints);
        if Result = PICKED_NONE then
        begin
          if Assigned(FLabel1) then
            Result := FLabel1.PointCode(Pt, Aperture, Distance, SelectPickingInside, UseDrawPoints);
          if Result = PICKED_NONE then
          begin
            if Assigned(FLabel2) then
              Result := FLabel2.PointCode(Pt, Aperture, Distance, SelectPickingInside, UseDrawPoints);
          end;
        end;
    end;
  end;     
end;

procedure TEzAxis.SaveToStream(Stream: TStream);
begin
  inherited;
  EzWriteStrToStream(FName, STream);
  Stream.Write(FShowNameAtTop, SizeOf(FShowNameAtTop));
  Stream.Write(FShowNameAtBottom, SizeOf(FShowNameAtBottom));
end;

procedure TEzAxis.SetName(const Value: String);
begin
  if FName <> Value then
  begin
    FName := Value;
    CreateAdditionalLines;
  end;
end;

procedure TEzAxis.SetPoint1(const Value: TEzPoint);
begin
  if not EqualPoint2D(Point1, Value) then
  begin
    FPoints[0] := Value;
    CreateAdditionalLines;
  end;
end;

procedure TEzAxis.SetPoint2(const Value: TEzPoint);
begin
  if not EqualPoint2D(Point2, Value) then
  begin
    FPoints[1] := Value;
    CreateAdditionalLines;
  end;
end;

procedure TEzAxis.UpdateExtension;
var
  I: Integer;
begin
  inherited UpdateExtension;
  with TEzEntityList.Create do
  try
    if Assigned(FAdd1) then
      Add(FAdd1);
    if Assigned(FAdd2) then
      Add(FAdd2);
    if Assigned(FLabel1) then
      Add(FLabel1);
    if Assigned(FLabel2) then
      Add(FLabel2);
    for I := 0 to Pred(Count) do
    begin
     Items[I].UpdateExtension;
     FBox.xmin := Min(Items[I].FBox.xmin, FBox.xmin);
     FBox.ymin := Min(Items[I].FBox.ymin, FBox.ymin);
     FBox.xmax := Max(Items[I].FBox.xmax, FBox.xmax);
     FBox.ymax := Max(Items[I].FBox.ymax, FBox.ymax);
    end;
  finally
    ExtractAll;
    Free;
  end;
end;

End.
