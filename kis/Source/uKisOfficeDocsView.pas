unit uKisOfficeDocsView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uKisMngrView, uLegend, Menus, StdCtrls, ComCtrls, ToolWin, Grids,
  DBGrids, uDBGrid, ExtCtrls;

type
  TKisOfficeDocsView = class(TKisMngrView)
    tbOffices: TToolBar;
    Label5: TLabel;
    cbOffice: TComboBox;
  end;

implementation

{$R *.dfm}

end.
