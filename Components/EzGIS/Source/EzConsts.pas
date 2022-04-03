unit EzConsts;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
interface

const
  CrLf = #$D#$A;

resourcestring

{$IFDEF LANG_ENG}
{$I EZ_ENG.INC}
{$ENDIF}

{$IFDEF LANG_SPA}
{$I EZ_SPA.INC}
{$ENDIF}

  SEz_GisVersion = 'EzGIS Version 1.95 (Ene, 2003)';
  SEz_CADVersion = 'EzCAD Version 1.95 (Ene, 2003)';

{$IFDEF TRIAL_VERSION}
  SUnRegisteredCopy = 'EzGIS/CAD components (Unregistered)';
{$ENDIF}


  // not nationalized section

  { for generating script }
  sDataInfo= 'Data Info';
  sFieldValue= '%s : %s ';
  sPenInfo= 'Pen %d,$%.8x,%f';
  sBrushInfo= 'Brush %d,$%.8x,$%.8x';
  sSymbolInfo= 'Symbol %d,%f,%f';
  sTTFontInfo= 'Font "%s",%s,%s,%s,%s,$%.8x,%d';
  sVectorFontInfo= 'VectorFont "%s"';
  sNoneInfo= 'None';
  sPointInfo= 'Point %s';
  SPlaceInfo= 'Place %s,"%s"';
  sPolylineInfo= 'PLine %s';
  sPolygonInfo= 'Polygon %s';
  sRectangleInfo= 'Rectangle %s,%f';
  sArcInfo= 'Arc %s';
  sEllipseInfo= 'Ellipse %s,%f';
  sPicRefInfo= 'PictureRef %s,"%s",%d,%f';
  sBmpRefInfo= 'BitmapRef %s,%d,%f';
  sPersistBmpInfo= 'PersistBitmap %s,"%s"';
  sBandsBmpInfo= 'BandsBitmap %s,"%s",%d';
  sBandsTiffInfo= 'BandsTiff %s,"%s",%d';
  sCustomPicInfo= 'CustPict %s';
  sSplineInfo= 'Spline %s';
  sTTTextInfo= 'TrueTypeText (%f,%f),"%s",%d,%f,%f';
  sATTTextInfo= 'TrueTypeText (%f,%f),"%s",%d,%f,%f';
  sTableInfo= 'Table %s,%d,%d,%s,%s,%s,%d,$%.8x,%f,%f,$%.8x';
  sColumnInfo= 'Column {';
  sTableColumnInfo= '%f,%s,$%.8x,%d,%d,%f';
  sColumnTitleInfo= '"%s",%d,$%.8x,%s,%f';
  sRowDataInfo= '"%s"';
  sTitleCaption= 'Title ';
  sGroupCaption= 'Group {';
  sJustifTextInfo= 'JustifText (%f,%f),(%f,%f),"%s",%f,%f,$%.8x,%d,%d';
  sFittedTextInfo= 'FittedText (%f,%f),"%s",%f,%f,%f,$%.8x';
  sBlockInfo= 'Insert %s,"%s",%f,%f,%f,"%s"';
  sSplineTextInfo= 'SplineText %s,"%s",%s';
  sDimHorizInfo= 'DimHorizontal (%f,%f),(%f,%f),%f';
  sDimVertInfo= 'DimVertical (%f,%f),(%f,%f),%f';
  sDimParallelInfo= 'DimParallel (%f,%f),(%f,%f),%f';
  sPreviewInfo= 'Preview %s,%d,%f,%f,%s,%f,%f,%f,%f';
  sERMapperInfo= 'ERMapper %s,"%s",%d';

  SDefaultDateFormat = 'm/d/yyyy';
  SEntityField = '.ENT';
  SRecNoField = '.RECNO';
  SSelection = 'SELECTION';

  SUTMZone = 'UTM Zone ';
  SCartesianFormat = '###,###,###,##0.000000';
  SDegreesFormat = '###0.00000000000';

  SCmdMove = 'MOVE';
  SCmdScale = 'SCALE';
  SCmdRotate = 'ROTATE';
  SCmdReshape = 'RESHAPE';
  SCmdRotateText = 'ROTATETEXT';
  SCmdLine = 'LINE';
  SCmdPolyline = 'PLINE';
  SCmdPolygon = 'POLYGON';
  SCmdSketch= 'SKETCH';
  sCmdArc = 'ARC';
  SCmdEllipse = 'ELLIPSE';
  SCmdSpline = 'SPLINE';
  SCmdSplineText = 'SPLINETEXT';
  SCmdRectangle = 'RECTANGLE';
  SCmdSymbol = 'SYMBOL';
  SCmdTextSymbol = 'TEXTSYMBOL';
  SCmdText = 'TEXT';
  SCmdHorzGLine = 'HGLINE';
  SCmdVertGLine = 'VGLINE';
  SCmdMoveGLine = 'MOVEGLINE';
  SCmdHints = 'HINTS';
  SCmdPictRef = 'PICTUREREF';
  SCmdCustomPicture = 'CUSTOMPICTURE';
  SCmdGeorefBitmap = 'GEOREFBITMAP';
  SCmdBandsBitmap = 'BANDSBITMAP';
  SCmdPersistBitmap = 'PERSISTBITMAP';
  SCmdUndo = 'UNDO';
  SCmdPan = 'PAN';
  SCmdSelect = 'SELECT';
  SCmdSelPLine = 'SELPLINE';
  SCmdMeasures = 'MEASURES';
  SCmdOffset = 'OFFSET';
  SCmdInsertVertex = 'INSERTVERTEX';
  SCmdGridOrigin = 'GRIDORIGIN';
  SCmdEditDB = 'EDITDB';
  SCmdPolygonSelect = 'POLYGONSEL';
  SCmdCircleSelect = 'CIRCLESEL';
  SCmdZoomIn = 'ZOOMIN';
  SCmdZoomOut = 'ZOOMOUT';
  SCmdZoomWindow = 'ZOOMWIN';
  SCmdRealTimeZoom = 'REALTIMEZOOM';
  SCmdRealTimeZoomB = 'REALTIMEZOOMB';
  SCmdHandScroll = 'SCROLL';
  SCmdClipPoly = 'CLIP';
  SCmdSetClipPolyArea = 'CLIPPOLYAREA';
  SCmdClipPolyline = 'CLIPPLINE';
  SCmdDeleteVertex = 'DELVERTEX';
  SCmdSetClipArea = 'SETCLIPAREA';
  SCmdBreak = 'BREAK';
  SCmdTrim = 'TRIM';
  SCmdExtend = 'EXTEND';
  SCmdFillet = 'FILLET';
  SCmdAddMarker = 'MARKER';
  //SCmdScript= 'SCRIPT';
  SCmdPolygonBuffer = 'POLYGONBUFFER';
  SCmdTable = 'TABLE';
  SCmdCalloutText = 'CALLOUTTEXT';
  SCmdBulletLeader = 'BULLETLEADER';
  SCmdBannerText = 'BANNER';
  SCmdZoomAll = 'ZOOMALL';
  SCmdScaleX = 'SCALEX';
  SCmdScaleY = 'SCALEY';
  SCmdJustifText = 'JUSTIFTEXT';
  SCmdFittedText = 'FITTEDTEXT';
  SCmdPoint = 'POINT';
  SCmdDimHoriz = 'DIMHORZ';
  SCmdDimVert = 'DIMVERT';
  SCmdDimParall = 'DIMPARALL';
  SCmdCircle2P = 'CIRCLE2P';
  SCmdCircle3P = 'CIRCLE3P';
  SCmdCircleCR = 'CIRCLECR';
  SCmdRichText = 'RICHTEXT';
  SCmdInsert = 'INSERT';
  SCmdMirror = 'MIRROR';
  SCmdCustomClick = 'CUSTOMCLICK';
  SCmdDropSelection = 'DROP';
  SCmdDragDrop = 'DRAG&DROP';
  SCmdTracking = 'TRACKING';
  SCmdArcSE = 'ARCSE';
  SCmdArcFCS = 'ARCFCS';
  SCmdNode = 'NODE';
  SCmdNodeLink = 'NODELINK';
  SCmdText500 = 'TEXT500';

implementation

end.
