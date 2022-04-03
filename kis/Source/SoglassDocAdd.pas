unit SoglassDocAdd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  StdCtrls, Buttons, DB, Mask, DBCtrls;

type
  TSoglassDocAddForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    BitBtn1: TBitBtn;
    dbeNAME: TDBEdit;
    dbePLOSH: TDBEdit;
    dbeZHPLOSH: TDBEdit;
    dbeOBPLOSH: TDBEdit;
    dbeOBEM: TDBEdit;
    procedure BitBtn2Click(Sender: TObject);
    function INITFunction: boolean;
    procedure INIT;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SoglassDocAddForm: TSoglassDocAddForm;

implementation

uses Soglass, SoglassDoc;

{$R *.DFM}


procedure TSoglassDocAddForm.BitBtn2Click(Sender: TObject);
begin
  ModalResult:=mrCancel;
  Close;
end;

function TSoglassDocAddForm.INITfunction: boolean;
begin

   with TSoglassDocAddForm.Create(Application) do
   begin

   end;
   result:=(ShowModal=mrOk)
end;

procedure TSoglassDocAddForm.Init;
begin
{модально}
  { if not Assigned(SoglassDocAddForm) then
       SoglassDocAddForm:=TSoglassDocAddForm.Create(Application);
   SoglassDocAddForm.Show }
{немодально}

   SoglassDocAddForm:=TSoglassDocAddForm.Create(Application);
   try
     if (SoglassDocAddForm.ShowModal = mrOk) then
     begin
     end;
   finally
     SoglassDocAddForm.Free;
     SoglassDocAddForm:=nil;
   end;
end;

procedure TSoglassDocAddForm.BitBtn1Click(Sender: TObject);
begin
  ModalResult:=mrOk;
  Close;
end;

procedure TSoglassDocAddForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TSoglassDocAddForm.FormDestroy(Sender: TObject);
begin
  SoglassDocAddForm:=nil;
end;

end.
