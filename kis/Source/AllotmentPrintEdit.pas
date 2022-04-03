unit AllotmentPrintEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, DBCtrls;

type
  TAddEditForm = class(TForm)
    OkBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    dbeOwner: TDBEdit;
    dbeAddress: TDBEdit;
    Label6: TLabel;
    Label7: TLabel;
    dbePurpose: TDBEdit;
    dbeRegion: TDBEdit;
    dbePropForm: TDBEdit;
    dbmArea: TDBMemo;
    dbmDocs: TDBMemo;
  end;

function AllotmentPrintEditShow: Boolean;

implementation

uses Allotment;

{$R *.DFM}

function AllotmentPrintEditShow: Boolean;
begin
  with TAddEditForm.Create(Application) do
  try
    Result := ShowModal = mrOk;
  finally
    Free;
  end;
end;

end.
