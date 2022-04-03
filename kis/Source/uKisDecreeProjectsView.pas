unit uKisDecreeProjectsView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ComCtrls, ToolWin, Grids, DBGrids, ExtCtrls,
  //
  uLegend, uDBGrid, uSplitter,
  //
  uKisMngrView;

type
  TKisDecreeProjectsView = class(TKisMngrView)
    dbgTemp: TkaDBGrid;
    Splitter1: TSplitter;
  end;

implementation

{$R *.dfm}

end.
