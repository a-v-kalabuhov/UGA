unit uKisDecrees;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ImgList, ActnList,
  uKisSQLClasses, uKisClasses, uKisConsts;

type
  TKisDecree = class(TKisEntity)
  private
    FDecreeType: String;
    FIntNumber: String;
    FDecreeDate: String;
    FHeader: String;
    FNumber: String;
    FContent: String;
    FIntDate: String;
    procedure SetContent(const Value: String);
    procedure SetDecreeDate(const Value: String);
    procedure SetDecreeType(const Value: String);
    procedure SetHeader(const Value: String);
    procedure SetIntDate(const Value: String);
    procedure SetIntNumber(const Value: String);
    procedure SetNumber(const Value: String);
  public
    function IsEmpty: Boolean; override;
    class function EntityName: String; override;
    procedure Copy(Source: TKisEntity); override;
    procedure Load(DataSet: TDataSet); override;
    function Equals(Entity: TKisEntity): Boolean; override;

    property DecreeType: String read FDecreeType write SetDecreeType;
    property DecreeDate: String read FDecreeDate write SetDecreeDate;
    property Number: String read FNumber write SetNumber;
    property IntDate: String read FIntDate write SetIntDate;
    property IntNumber: String read FIntNumber write SetIntNumber;
    property Header: String read FHeader write SetHeader;
    property Content: String read FContent write SetContent;
  end;

  TKisDecreeMngr = class(TKisSQLMngr)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  KisDecreeMngr: TKisDecreeMngr;

implementation

{$R *.dfm}

{ TKisDecree }

procedure TKisDecree.Copy(Source: TKisEntity);
begin
  inherited;

end;

class function TKisDecree.EntityName: String;
begin

end;

function TKisDecree.Equals(Entity: TKisEntity): Boolean;
begin
  Result := inherited Equals(Entity);
end;

function TKisDecree.IsEmpty: Boolean;
begin
  Result :=
    (FDecreeType = '')
    and (FIntNumber = '')
    and (FDecreeDate = '')
    and (FHeader = '')
    and (FNumber = '')
    and (FContent = '')
    and (FIntDate = '');

end;

procedure TKisDecree.Load(DataSet: TDataSet);
begin
  inherited;
  //SELECT A.ID, A.DOC_NUMBER, A.DOC_DATE, A.INT_NUMBER, A.INT_DATE, A.HEADER,
  //       A.CHECKED, A.CONTENT, A.YEAR_NUMBER, A.DECREE_TYPES_ID, B.NAME AS DECREE_TYPES_NAME
  //FROM DECREES A LEFT JOIN DECREE_TYPES B ON A.DECREE_TYPES_ID=B.ID
  ID := DataSet.FieldByName(SF_ID).AsInteger;
  FContent := DataSet.FieldByName(SF_CONTENT).AsString;
  FDecreeDate := DataSet.FieldByName(SF_DOC_DATE).AsString;
  FDecreeType := DataSet.FieldByName('DECREE_TYPES_NAME').AsString;
  FHeader := DataSet.FieldByName(SF_HEADER).AsString;
  FIntDate := DataSet.FieldByName('INT_DATE').AsString;
  FIntNumber := DataSet.FieldByName('INT_NUMBER').AsString;
  FNumber := DataSet.FieldByName(SF_DOC_NUMBER).AsString;
end;

procedure TKisDecree.SetContent(const Value: String);
begin
  if FContent <> Value then
  begin
    FContent := Value;
    Modified := True;
  end;
end;

procedure TKisDecree.SetDecreeDate(const Value: String);
begin
  if FDecreeDate <> Value then
  begin
    FDecreeDate := Value;
    Modified := True;
  end;
end;

procedure TKisDecree.SetDecreeType(const Value: String);
begin
  if FDecreeType <> Value then
  begin
    FDecreeType := Value;
    Modified := True;
  end;
end;

procedure TKisDecree.SetHeader(const Value: String);
begin
  if FHeader <> Value then
  begin
    FHeader := Value;
    Modified := True;
  end;
end;

procedure TKisDecree.SetIntDate(const Value: String);
begin
  if FIntDate <> Value then
  begin
    FIntDate := Value;
    Modified := True;
  end;
end;

procedure TKisDecree.SetIntNumber(const Value: String);
begin
  if FIntNumber <> Value then
  begin
    FIntNumber := Value;
    Modified := True;
  end;
end;

procedure TKisDecree.SetNumber(const Value: String);
begin
  if FNumber <> Value then
  begin
    FNumber := Value;
    Modified := True;
  end;
end;

end.
