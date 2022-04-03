unit uKisMissingScansDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  uKisScanOrders, StdCtrls;

type
  TMissingScansResult = (msrNewOrder, msrAnnulOrder, msrCancel, msrNoReturn);

  TMissingScansForm = class(TForm)
    Label1: TLabel;
    ListBox1: TListBox;
    Label2: TLabel;
    ListBox2: TListBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    FResult: TMissingScansResult;
  public
    class function Execute(Order: TKisScanOrder; MapList: TStringList;
      ForView: Boolean = False): TMissingScansResult;
  end;

implementation

{$R *.dfm}

uses
  uKisConsts;

{ TMissingScansForm }

procedure TMissingScansForm.Button1Click(Sender: TObject);
begin
  FResult := msrNewOrder;
  Close;
end;

procedure TMissingScansForm.Button2Click(Sender: TObject);
begin
  FResult := msrAnnulOrder;
  Close;
end;

procedure TMissingScansForm.Button3Click(Sender: TObject);
begin
  FResult := msrCancel;
  Close;
end;

procedure TMissingScansForm.Button4Click(Sender: TObject);
begin
  FResult := msrNoReturn;
  Close;
end;

class function TMissingScansForm.Execute(Order: TKisScanOrder;
  MapList: TStringList; ForView: Boolean): TMissingScansResult;
var
  Frm: TMissingScansForm;
  R: Integer;
  S: string;
begin
  Frm := TMissingScansForm.Create(Application);
  try
    Frm.Label3.Caption := 'Заявка ' + Order.OrderNumber + ' от ' + Order.OrderDate;
    R := Order.Maps.RecNo;
    Order.Maps.First;
    while not Order.Maps.Eof do
    begin
      S := Order.Maps.FieldByName(SF_NOMENCLATURE).AsString;
      if MapList.IndexOf(S) < 0 then
        Frm.ListBox1.Items.Add(S)
      else
        Frm.ListBox2.Items.Add(S);
      Order.Maps.Next;
    end;
    Order.Maps.RecNo := R;
    Frm.Label4.Caption := Format('(%d/%d)', [Frm.ListBox1.Items.Count, Order.Maps.RecNo]);
    Frm.Label5.Caption := Format('(%d/%d)', [Frm.ListBox2.Items.Count, Order.Maps.RecNo]);
    //
    Frm.Button1.Visible := not ForView;
    Frm.Button2.Visible := not ForView;
    Frm.Button4.Visible := not ForView;
    //
    Frm.ShowModal;
    Result := Frm.FResult;
  finally
    FreeAndNil(Frm);
  end;
end;

procedure TMissingScansForm.FormCreate(Sender: TObject);
begin
  Label3.Font.Style := [fsBold];
  FResult := msrCancel;
end;

end.
