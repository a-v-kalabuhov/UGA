unit ShowHintsU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  EzCtrls, ExtCtrls, StdCtrls, ComCtrls, EzBaseGis,
  ezsystem,EzBaseexpr, EzCmdLine, Buttons, EzBasicCtrls, EzExpressions;

type
  TForm1 = class(TForm)
    Gis1: TEzGis;
    Panel1: TPanel;
    DrawBox1: TEzDrawBox;
    Button1: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    CmdLine1: TEzCmdLine;
    AerialView1: TEzAerialView;
    Label2: TLabel;
    Memo2: TMemo;
    Button2: TButton;
    ZoomAll: TSpeedButton;
    ZoomIn: TSpeedButton;
    ZoomOut: TSpeedButton;
    PriorViewBtn: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    BtnHand: TSpeedButton;
    ZoomWBtn: TSpeedButton;
    Button3: TButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DrawBox1ZoomChange(Sender: TObject; const Scale: Double);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DrawBox1ShowHint(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; var Hint: String; var ShowHint: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure ZoomAllClick(Sender: TObject);
    procedure ZoomInClick(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);
    procedure PriorViewBtnClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure BtnHandClick(Sender: TObject);
    procedure ZoomWBtnClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    FHintExpression: TEzMainExpr;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses
  fExpress, ezconsts,ezbase, ezlib, fqueryres;

procedure TForm1.FormCreate(Sender: TObject);
var
  Path: string;
begin
  Path:= AddSlash(ExtractFilePath(ExpandFilename('..\..\data\txt.fnt')));
  if not FileExists(Path+'txt.fnt') then
  begin
    ShowMessage('No font files found !');
  end;
  Ez_VectorFonts.AddFontFile(Path+'complex.fnt');
  Ez_VectorFonts.AddFontFile(Path+'txt.fnt');

  { ALWAYS load the symbols after the vectorial fonts
    because the symbols can include vectorial fonts entities and
    if the vector font is not found, then the entity will be configured
    with another font }
  if FileExists(Path + 'symbols.ezs') then
  begin
    Ez_Symbols.FileName:= Path + 'symbols.ezs';
    Ez_Symbols.Open;
  end;

  // load line types
  if FileExists(Path + 'Linetypes.ezl') then
  begin
    Ez_LineTypes.FileName:=Path + 'Linetypes.ezl';
    Ez_LineTypes.Open;
  end;

  Ez_Preferences.CommonSubDir:= Path;

  Gis1.FileName:= Path + 'SampleMap.Ezm';
  Gis1.Open;
  DrawBox1.ZoomToExtension;
  Aerialview1.ZoomToExtension;

  FHintExpression:= TEzMainExpr.create(Gis1, Gis1.Layers.LayerByName('STATES_'));

end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Layer: TEzBaseLayer;
begin
  { clear any hints defined to avoid conflicts }
  Layer:= Gis1.Layers.LayerByName('STATES_');
  if Layer=nil then Exit;
  // parse the expression in order to start evaluating it in event OnShowHint
  // to evaluate an expression you use something like this:
  // x:= FHintExpression.Expression.AsString (or AsFloat, AsInteger, AsBoolean)
  FHintExpression.ParseExpression(Memo2.Text);
  CmdLine1.Clear;
  CmdLine1.DoCommand('HINTS','');     
  DrawBox1.SetFocus;
end;

procedure TForm1.DrawBox1ZoomChange(Sender: TObject; const Scale: Double);
begin
  if Gis1.Layers.Count=0 then exit;
  AerialView1.Refresh;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FHintExpression.free;
end;

procedure TForm1.DrawBox1ShowHint(Sender: TObject; Layer: TEzBaseLayer;
  Recno: Integer; var Hint: String; var ShowHint: Boolean);
begin
  if AnsiCompareText(Layer.Name,'STATES_')<>0 then exit;
  Layer.DBTable.Recno:= Recno;
  Hint:= FHintExpression.Expression.AsString;
  ShowHint:= true;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  with TfrmExprDlg.create(Nil) do
    try
      if Enter(Self.Memo2.Text,Gis1,Gis1.Layers.LayerByName('STATES_'))=mrOk then
        Self.Memo2.Text:= Memo1.Text;
    finally
      free;
    end;
end;

procedure TForm1.ZoomAllClick(Sender: TObject);
begin
  DrawBox1.ZoomToExtension;
end;

procedure TForm1.ZoomInClick(Sender: TObject);
begin
  DrawBox1.ZoomIn(85);
end;

procedure TForm1.ZoomOutClick(Sender: TObject);
begin
  DrawBox1.ZoomOut(85);
end;

procedure TForm1.PriorViewBtnClick(Sender: TObject);
begin
  DrawBox1.ZoomPrevious;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  showmessage(
    'This demo shows you how to code event'+crlf+
    'TEzDrawBox.OnShowHint. In this demo you will define an'+crlf+
    'expression on the memo to the left, then that expression will be'+crlf+
    'evaluated and used in event OnShowHint.'+crlf+
    ''+crlf+
    'For activating the hints you need'+crlf+
    'to call to method TEzCmdLine.DoCommand(''HINTS'', '''')'+crlf+
    ''+crlf+
    'Check event DrawBox1.OnShowHint for the implementation.'+crlf
  );
end;

procedure TForm1.BtnHandClick(Sender: TObject);
begin
  CmdLine1.DoCommand('SCROLL','');
end;

procedure TForm1.ZoomWBtnClick(Sender: TObject);
begin
  CmdLine1.DoCommand('ZOOMWIN','');
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  Layer: TEzBaseLayer;
  Reslt: string;
begin
  { IMPORTANT:
    Please do not use this functions on a hint expression.
    It's primary use is to filter a layer spatially and not for return an
    explicit value.

  }

{

New in 1.50 !

The following functions were changed: QUERY_VECTOR, QUERY_LAYER, QUERY_SCOPE. Now, expressions are used instead of this functions. Now it is more easy to build expressions. See below for details.

In EzGis some special functions or expressions are used for doing spatial queries.

What are spatial queries ?

With spatial queries you can ask to the database something like:

Which entities are inside this polygon? or

Which cities are inside "Oklahoma" state ?

Which cities that start with the "A" letter are inside Washington staye ?

etc.

In EzGis you can do that kind of expressions with some special syntax that we will analize in depth shortly.

SPATIAL EXPRESSIONS

These are very powerful expressions used in EzGis components. These expressions will allow you to do spatially queries to the database. With these expressions you can combine the use of different layers on the same expression. Example, you can return all the CITIES that are inside a given STATE on your map.

Next, we will explain the three kind of expressions used for spatially query to some layer.

***** SCOPE expression *****

Actually, this is not a spatial query function, but can be used in order to combine to other spatial expressions. 

The expression has the following syntax:

(LAYER).ENT SCOPE ( standard_expression )

where :

	(LAYER) is any layer on your map, like STATES_.
	.ENT is a special identifier virtual FIELD for the layer. This field actually is a reference to the graphical information of the entity on the map (saved on .EZD and .EZX files).
	standard_expression is an expression used to filter the given layer

Example:

Suppose you have a layer named STATES_, consisting of polygons only. Also, you have a layer named CITIES_, consisting only of symbols on the map.

This expression will return all the records on layer STATES_ whose STATE_NAME field have the values "Washington", and "Oklahoma"

Example of usage:

STATES_.ENT SCOPE ( STATES_.STATE_NAME IN ("Oklahoma", "Washington")

Another example:

STATES_.ENT SCOPE ( STATES_.RECNO IN (100,200,300) )

This last will return the states whose physical record number is 100, 200 or 300. The .RECNO field is a virtual field for every layer (as same as .ENT field) and actually returns the physical record number of the entity on the database.

***** VECTOR expression *****

The syntax for this expression is:

(LAYER).ENT graphic_operator vector_function

where:

	(LAYER) is any layer on your map, like STATES_.
	.ENT is a special identifier virtual FIELD for the layer. This field actually is a reference to the graphical information of the
	graphic_operator can be any of the following reserved words:

    WITHIN

    ENTIRELY WITHIN

    CONTAINS

    CONTAINS ENTIRE

    INTERSECTS

	vector_function is a special function used for passing as a parameter for this function. This function is used for building internally a vector of coordinate pairs in floating point. The vector function is defined as follows:

VECTOR( [(x1,y1),(x2,y2),(x3y3)...] )   
	Example:
	VECTOR( [(10.35,10.20),(20.21,20.15),(30.15,30.15),(10.35,10.20)] )
	NOTE: the list of coordinate pairs must be enclosed in square brackets for to pass to this function and does not indicate optionally parameters. It is mandatory.

NOTE: an r-tree index is used for optimizing the speed of execution of this function.

Example of usage:
The following funcion will return all the states that are completely inside the given polygon:

CITIES_.ENT ENTIRELY WITHIN 
VECTOR ( [ (-122.55, 49.56), (-125.27, 49.22), (-125.32, 46.86), (-125.09, 45.23), (-124.20, 44.12), (-122.49, 44.48),
  (-122.11, 45.30), (-120.41, 45.70), (-118.88, 45.99), (-120.70, 47.46), (-119.34, 48.00), (-120.35, 49.07), 
  (-121.89, 49.15), (-122.55, 49.56)  ] )


NOTE: You also can filter with another filter expression. The following example will return the states that are inside the defined polygon and from that states, will return only the states that starts with an "A".

STATES_.ENT ENTIRELY WITHIN VECTOR( [(10.35,10.20),(20.21,20.15),(30.15,30.15),(10.35,10.20)] ) ) AND
  STATES_.STATE_NAME >= "C"



***** LAYER expression *****

From the spatial query expression, this is the most powerful. This expression is used for spatially querying from one layer and based on another layer. Example, suppose you have some entities on layer CITIES_ that are related in some way (example, the cities that are inside a given state) to other layer, STATES_.

This expression has several syntax:

First syntax:

Specific records included

(LAYER).ENT graphic_operator (BASE_LAYER).ENT RECORDS ( record_list )



	(LAYER) is any layer on your map, like CITIES_.
	.ENT is a special identifier virtual FIELD for the layer. This field actually is a reference to the graphical information of the
	graphic_operator can be any of the following reserved words:

    WITHIN

    ENTIRELY WITHIN

    CONTAINS

    CONTAINS ENTIRE

    INTERSECTS

	(BASE_LAYER) is the layer used as a reference to the (LAYER), example all the entities on (LAYER) that are inside (BASE_LAYER)
	record_list.- You define here explicitly, a list of records of the entities
         on (BASE_LAYER) used for query to (LAYER). This is an integer comma
         separated list (1, 2, 3,...etc.).

NOTE: an r-tree index is used for optimizing the speed of execution of this function.

Example.

The following example, will list all the cities that are fully inside the states whose record numbers on the database are 100,200 and 300

CITIES_.ENT ENTIRELY WITHIN STATES_.ENT RECORDS (100, 200, 300)

Second syntax:

The second syntax is almost similar to the first one, with the exception that no record numbers are proportioned and the reserved word ALL is added. This last means that all the record numbers in base layer are used:

NOTE: an r-tree index is used for optimizing the speed of execution of this function.

Example:

CITIES_.ENT ENTIRELY WITHIN STATES_.ENT ALL RECORDS

Third syntax:

(LAYER).ENT graphic_operator spatial_expression

(LAYER) is any layer on your map, like CITIES_.
.ENT is a special identifier virtual FIELD for the layer. This field actually is a reference to the graphical information of the entity.
graphic_operator can be any of the following reserved words:

    WITHIN

    ENTIRELY WITHIN

    CONTAINS

    CONTAINS ENTIRE

    INTERSECTS

spatial_expression.- You can include here any of the previous spatial expression or a combination. This will give much more power to the spatial query.

NOTE: an r-tree index is used for optimizing the speed of execution of this function.

Example

The following expression will return all the cities that are inside Oklahoma and Washington states. Additionaly, from the resulting cities, only the cities whose name is greater than "C" will be returned.

CITIES_.ENT ENTIRELY WITHIN STATES_.ENT SCOPE (STATES_.STATE_NAME IN ("Oklahoma", "Washington") ) AND CITIES_.CITY_NAME > 'C'"

Other examples:

Query states inside a given fixed vector:

Sample 1

CITIES_.ENT ENTIRELY WITHIN 

STATES_.ENT ENTIRELY WITHIN VECTOR ( [

  (-122.55, 49.56), (-125.27, 49.22), (-125.32, 46.86), (-125.09, 45.23), (-124.20, 44.12), (-122.49, 44.48),

  (-122.11, 45.30), (-120.41, 45.70), (-118.88, 45.99), (-120.70, 47.46), (-119.34, 48.00), (-120.35, 49.07),

  (-121.89, 49.15) , (-122.55, 49.56)    ] )

Sample 2

CITIES_.ENT ENTIRELY WITHIN STATES_.ENT SCOPE ( STATES_.STATE_NAME LIKE "A%" )

Note: Parenthesis around the scope expressions are mandatory.

Sample 3

CITIES_.ENT ENTIRELY WITHIN STATES_.ENT SCOPE ( STATES_.STATE_NAME IN ('Washington','Montana','Wyoming') )

Sample 4

CITIES_.ENT ENTIRELY WITHIN STATES_.ENT SCOPE ( STATES_.STATE_NAME = "Washington")

CITIES_.ENT ENTIRELY WITHIN STATES_.ENT RECORDS (1,2,3)

Sample 5

CITIES_.ENT ENTIRELY WITHIN STATES_.ENT SCOPE (

  STATES_.ENT ENTIRELY WITHIN

  VECTOR ( [ (-122.55, 49.56), (-125.27, 49.22), (-125.32, 46.86), (-125.09, 45.23),

             (-124.20, 44.12), (-122.49, 44.48), (-122.11, 45.30), (-120.41, 45.70),

             (-118.88, 45.99), (-120.70, 47.46), (-119.34, 48.00), (-120.35, 49.07),

             (-121.89, 49.15), (-122.55, 49.56) ] )

  AND STATES_.STATE_NAME > "A"

 )

As you can see from the expression above, the SCOPE syntax can involve more complex expressions.

You may think, why cannot be done the following way ?:

CITIES_.ENT ENTIRELY WITHIN  STATES_.ENT ENTIRELY WITHIN

  VECTOR ( [ (-122.55, 49.56), (-125.27, 49.22), (-125.32, 46.86), (-125.09, 45.23),

             (-124.20, 44.12), (-122.49, 44.48), (-122.11, 45.30), (-120.41, 45.70),

             (-118.88, 45.99), (-120.70, 47.46), (-119.34, 48.00), (-120.35, 49.07),

             (-121.89, 49.15), (-122.55, 49.56) ] )

  AND STATES_.STATE_NAME > "A"

The problem with this syntax is that there are two iterations internally, the iteration will be done first on all the states that are inside the given vector, and next, the iteration will be done for all the cities inside that vector and optionally will check if the STATES_ expression is true for every city, which is not a logical evaluation for the expression.

With the first syntax, the STATES_ expression ' AND STATES_.STATE_NAME > "A" ', is forced to evaluate inside the STATES_ iteration.



}


  Layer:= Gis1.Layers.LayerByName('ROADS_');
  if Layer=nil then exit;
  Screen.Cursor:= crHourglass;
  Layer.DefineScope(' ROADS_.ENT INTERSECTS STATES_.ENT RECORDS( 10, 20, 30 ) ');
  { this last means that we will find on entity ROADS_ all the entities
      (POLYLINES) that intersects to the layer STATES_ (polygons) on the records
      10,20,30 of layer STATES_
    note: for every record on layer ROADS_, three tests are done against layer STATES_
  }
  Reslt:= '';
  Layer.First;
  while not Layer.Eof do
  begin
    try
      Layer.DBTable.Recno:= Layer.recno;
      Reslt:= Reslt + Layer.DBTable.StringGet('ROUTE') + #13#10 ;
    finally
      Layer.Next;
    end;
  end;
  Screen.Cursor:= crDefault;
  with TfrmQueryResults.create(Nil) do
    try
      memo1.Lines.Text:= Reslt;
      label1.caption:= 'The entities in layer ROADS_ that intersects to states whose records number in [10, 20, 30] are:';
      showmodal;
    finally
      free;
    end;


  { this query will return all the entities on layer CITIES_ that are inside
    states whose name is "Washington", "Oklahoma"
    Also it is filtered later with the cities starting with an "A"
  }
  Layer:= Gis1.Layers.LayerByName('CITIES_');
  if Layer=nil then exit;
  Screen.Cursor:= crHourglass;
  Layer.DefineScope(
    'CITIES_.ENT ENTIRELY WITHIN ' +
      ' STATES_.ENT SCOPE ( STATES_.STATE_NAME IN ("Oklahoma", "Washington") ) ' +
      ' AND CITIES_.CITY_NAME LIKE "A%"' );

  Reslt:= '';
  Layer.First;
  while not Layer.Eof do
  begin
    try
      Layer.DBTable.Recno:= Layer.recno;
      Reslt:= Reslt + Layer.DBTable.StringGet('CITY_NAME') + #13#10 ;
    finally
      Layer.Next;
    end;
  end;
  Screen.Cursor:= crDefault;
  with TfrmQueryResults.create(Nil) do
    try
      memo1.Lines.Text:= Reslt;
      label1.caption:= 'The entities in layer CITIES_ that are inside layer ' +
                       'STATES_ whose name is "Washington" or "Oklahoma" are:';
      showmodal;
    finally
      free;
    end;



  { with a more complex expression in the third parameter for the function,
    a fourth parameter must be proportioned, given the layer name involved
    See Developer's guide for more information.

    This is just an example:
  }
  Layer:= Gis1.Layers.LayerByName('CITIES_');
  if Layer=nil then exit;
  Screen.Cursor:= crHourglass;
  Layer.DefineScope(
    ' CITIES_.ENT ENTIRELY WITHIN STATES_.ENT SCOPE ( ( STATES_.RECNO BETWEEN 1 AND 5000 ) ' +
    '   AND ( STATES_.STATE_NAME LIKE "A%" ) )' );
  Reslt:= '';
  Layer.First;
  while not Layer.Eof do
  begin
    try
      Layer.DBTable.Recno:= Layer.recno;
      Reslt:= Reslt + Layer.DBTable.StringGet('CITY_NAME') + #13#10 ;
    finally
      Layer.Next;
    end;
  end;
  Screen.Cursor:= crDefault;
  with TfrmQueryResults.create(Nil) do
    try
      memo1.Lines.Text:= Reslt;
      label1.caption:= 'The entities obtained in a more complex expression are :';
      showmodal;
    finally
      free;
    end;





  { this expression will select all the entities on layer CITIES_ that are
    inside a given polygon. The polygon is given by the following points :

    (-99.46, 44.46),
    (-110.09, 44.51),
    (-110.74, 35.75),
    (-106.73, 30.35),
    (-98.33, 29.26),
    (-88.18, 29.09),
    (-85.09, 35.45),
    (-85.79, 41.94),
    (-91.54, 42.85),
    (-93.63, 44.59)
    (-99.46, 44.46)   // closes the polygon

  }
  Layer:= Gis1.Layers.LayerByName('CITIES_');
  if Layer=nil then exit;
  Screen.Cursor:= crHourglass;
  Layer.DefineScope(
    'CITIES_.ENT ENTIRELY WITHIN POLYGON ([ ' +
    ' (-99.46, 44.46),(-110.09, 44.51),(-110.74, 35.75),(-106.73, 30.35),' +
    ' (-98.33, 29.26),(-88.18, 29.09), (-85.09, 35.45), (-85.79, 41.94), ' +
    ' (-91.54, 42.85),(-93.63, 44.59), (-99.46, 44.46) ])' );

  Reslt:= '';
  Layer.First;
  while not Layer.Eof do
  begin
    try
      Layer.DBTable.Recno:= Layer.recno;
      Reslt:= Reslt + Layer.DBTable.StringGet('CITY_NAME') + #13#10 ;
    finally
      Layer.Next;
    end;
  end;
  Screen.Cursor:= crDefault;
  with TfrmQueryResults.create(Nil) do
    try
      memo1.Lines.Text:= Reslt;
      label1.caption:= 'The entities in layer CITIES_ that are inside some entities on layer STATES_ that are inside a given vector are:';
      showmodal;
    finally
      free;
    end;

end;

end.
