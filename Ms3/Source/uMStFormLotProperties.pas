unit uMStFormLotProperties;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Mask, DBCtrls, Grids, DBGrids, Buttons, Math,
  ImgList, Db, Menus, ActnList, ToolWin, ExtCtrls, ShellAPI,
  // EzGIS library
  EzBaseGIS, EzCtrls, EzBasicCtrls,
  // Common
  uCommonUtils,
  // Project
  uMStKernelClasses,
  uMStClassesLots,
  uMStModuleMapMngrIBX;

type
  TmstLotPropertiesForm = class(TForm)
    PageControl: TPageControl;
    tshData: TTabSheet;
    btnOk: TButton;
    Label1: TLabel;
    dbeAddress: TDBEdit;
    Label2: TLabel;
    dbeArea: TDBEdit;
    Label3: TLabel;
    tshInfo: TTabSheet;
    dbmLandscape: TDBMemo;
    Label16: TLabel;
    dbeCancelledInfo: TDBEdit;
    Label12: TLabel;
    dbeDocDate: TDBEdit;
    Label4: TLabel;
    dbmRealty: TDBMemo;
    Label5: TLabel;
    dbmMonument: TDBMemo;
    Label8: TLabel;
    dbmMinerals: TDBMemo;
    Label9: TLabel;
    dbmFlora: TDBMemo;
    Label13: TLabel;
    dbmInformation: TDBMemo;
    dsOwners: TDataSource;
    gbOwners: TGroupBox;
    gbDecrees: TGroupBox;
    dbgOwners: TDBGrid;
    btnOwnerEdit: TButton;
    dbgDocs: TDBGrid;
    dsDocs: TDataSource;
    dbchChecked: TDBCheckBox;
    dbchCancelled: TDBCheckBox;
    btnDecreeDetail: TButton;
    ImageList: TImageList;
    PopupMenu: TPopupMenu;
    ActionList: TActionList;
    actNew: TAction;
    actDel: TAction;
    actEdit: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Label33: TLabel;
    dbeExecutor: TDBEdit;
    dbeDocuments: TDBEdit;
    Label6: TLabel;
    Label11: TLabel;
    dbeDocNumber: TDBEdit;
    dbeParentNumber: TDBEdit;
    Label10: TLabel;
    dbeChildNumber: TDBEdit;
    Label15: TLabel;
    Label19: TLabel;
    dbeDecreePrepared: TDBEdit;
    Label20: TLabel;
    dbeAnnulDate: TDBEdit;
    dbeNewNumber: TDBEdit;
    Label21: TLabel;
    tshOther: TTabSheet;
    Label23: TLabel;
    dbmNeighbours: TDBMemo;
    Label22: TLabel;
    dbeNomenclatura: TDBEdit;
    dbmPZ: TDBMemo;
    Label24: TLabel;
    dbmDescr: TDBMemo;
    Label25: TLabel;
    dbeRegion: TDBEdit;
    dsLot: TDataSource;
    Label32: TLabel;
    DBEdit1: TDBEdit;
    btnOpenLinkConsultant: TButton;
    procedure btnOpenLinkConsultantClick(Sender: TObject);
  private
    FLot: TmstLot;
  public
    property Lot: TmstLot read FLot write FLot;
  end;

implementation

{$R *.DFM}

procedure JumpToURL(const url: string);
begin
  ShellExecute(Application.Handle, nil, PChar(url), nil, nil, SW_SHOW);
end;

procedure TmstLotPropertiesForm.btnOpenLinkConsultantClick(Sender: TObject);
begin
  if Trim(DBEdit1.Text) <> '' then  
    JumpToURL(DBEdit1.Text);
end;

end.
