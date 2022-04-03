unit uKisMapsMngrView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ComCtrls, ToolWin, Grids, DBGrids, ExtCtrls,
  //
  uDBGrid, uLegend, uSplitter,
  //
  uKisMngrView;

type
  TKisMapsMngrView = class(TKisMngrView)
    gbGiving: TGroupBox;
    dbgGiving: TkaDBGrid;
    Splitter1: TSplitter;
    tbMassGiving: TToolBar;
  end;

implementation

{$R *.dfm}

end.
