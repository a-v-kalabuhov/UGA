unit uKisOrdersImport1CView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons, Contnrs;

type
  TOrderImport1CForm = class(TForm)
    Memo1: TMemo;
    btnClose: TButton;
    lProgress: TLabel;
    Label2: TLabel;
    edFile: TEdit;
    btnOpen: TButton;
    OpenDialog2: TOpenDialog;
    ProgressBar1: TProgressBar;
    Bevel1: TBevel;
    btnImport: TBitBtn;
    btnSave: TButton;
    Label3: TLabel;
    procedure btnImportClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private type
    TOrderInfo = class
    private
      FRowNumber: Integer;
      FIntDocNumber: Integer;
      FDocNumber: String;
      FDocDate: TDateTime;
      FPayDate: TDateTime;
      FSum: String;
      FActDate: TDateTime;
      FActSum: String;
      function GetDocInfo(const Data: String; var ErrorMsg: String): Boolean;
    public
      constructor Create;
      //
      procedure Join(anInfo: TOrderInfo);
    end;
  private
    FInUpdate: Boolean;
  end;

implementation

{$R *.dfm}

uses
  uKisClasses, uKisAppModule, uKisOrders;

procedure TOrderImport1CForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TOrderImport1CForm.btnImportClick(Sender: TObject);
var
  OrderMngr: TKisOrderMngr;
  Order: TKisOrder;
  Lst: TStringList;
  I, J: Integer;
  SuccessCount, ErrorCount, SavedCount: Integer;
  IsSuccess, IsSaved: Boolean;
  ErrorMsg{, DocDate, PayDate, ActDate, DocSum, ActSum}: String;
  OldDs: Char;
  OrderInfos: TObjectList;
  OrdInfo: TOrderInfo;
  Report: TStringList;
begin
  FInUpdate := True;
  btnClose.Enabled := not FInUpdate;
  btnOpen.Enabled := not FInUpdate;
  btnImport.Enabled := not FInUpdate;
  OldDs := DecimalSeparator;
  OrderInfos := TObjectList.Create;
  try
    DecimalSeparator := '.';
    if FileExists(edFile.Text) then
    begin
      OrderMngr := AppModule[kmOrders] as TKisOrderMngr;
      SuccessCount := 0;
      SavedCount := 0;
      ErrorCount := 0;
      Lst := TStringList.Create;
      Report := TStringList.Create;
      try
        Lst.LoadFromFile(edFile.Text);
        if Lst.Count = 0 then
        begin
          Memo1.Lines.Add('');
          Memo1.Lines.Add('Файл "' + edFile.Text + '" пуст.');
          Memo1.CaretPos := Point(0, Memo1.Lines.Count - 1);
        end
        else
        begin
          Memo1.Lines.Add('');
          Memo1.Lines.Add('Импорт начат ' + FormatDateTime('yyyy.mm.dd hh:nn:ss', Now));
          Memo1.Lines.Add('================================');
          Memo1.CaretPos := Point(0, Memo1.Lines.Count - 1);
          ProgressBar1.Min := 0;
          ProgressBar1.Max := Lst.Count;
          lProgress.Caption := 'Читаем из файла...';
          lProgress.Visible := True;
          ProgressBar1.Position := 0;
          Application.ProcessMessages;
          for I := 0 to Lst.Count - 1 do
          begin
            IsSuccess := False;
            ErrorMsg := '';
            OrdInfo := TOrderInfo.Create;
            if OrdInfo.GetDocInfo(Trim(Lst[I]), ErrorMsg) then
            begin
              for J := 0 to OrderInfos.Count - 1 do
              begin
                if OrdInfo.FDocNumber = TOrderInfo(OrderInfos[J]).FDocNumber then
                if OrdInfo.FDocDate = TOrderInfo(OrderInfos[J]).FDocDate then
                begin
                  TOrderInfo(OrderInfos[J]).Join(OrdInfo);
                  IsSuccess := True;
                  FreeAndNil(OrdInfo);
                  Break;
                end;
              end;
              if Assigned(OrdInfo) then
              begin
                OrderInfos.Add(OrdInfo);
                OrdInfo.FRowNumber := I;
                IsSuccess := True;
              end;
            end;
            if not IsSuccess then
            begin
              Inc(ErrorCount);
              if ErrorMsg = '' then
                ErrorMsg := 'Неизвестная ошибка';
              ErrorMsg := 'Строка ' + IntToStr(Succ(I)) + #13#10 + ErrorMsg;// + #13#10;
              Report.Add(ErrorMsg);
//              Memo1.Lines.Add(ErrorMsg);
//              Memo1.CaretPos := Point(0, Memo1.Lines.Count - 1);
            end;
            ProgressBar1.Position := I;
            Application.ProcessMessages;
          end;
          //
          ProgressBar1.Min := 0;
          ProgressBar1.Max := Lst.Count;
          lProgress.Caption := 'Запись в БД...';
          lProgress.Visible := True;
          ProgressBar1.Position := 0;
          Application.ProcessMessages;
          for I := 0 to OrderInfos.Count - 1 do
          begin
            ErrorMsg := '';
            IsSuccess := False;
            IsSaved := False;
            OrdInfo := TOrderInfo(OrderInfos[I]);
            Order := nil;
            try
              Order := OrderMngr.FindOrder(IntToStr(OrdInfo.FIntDocNumber),
                OrdInfo.FDocDate);
            except
              on E: Exception do
              begin
                Order := nil;
                ErrorMsg := E.Message;
              end;
            end;
            if Assigned(Order) then
            begin
              if OrdInfo.FPayDate = 0 then
                Order.PayDate := ''
              else
                Order.PayDate := DateToStr(OrdInfo.FPayDate);
              if OrdInfo.FActDate = 0 then
                Order.ActDate := ''
              else
                Order.ActDate := DateToStr(OrdInfo.FActDate);
              if OrdInfo.FPayDate > 0 then
                Order.Checked := True;
              if Order.Modified then
              begin
                OrderMngr.SaveEntity(Order);
                IsSaved := True;
              end;
              IsSuccess := True;
            end
            else
            begin
              if ErrorMsg <> '' then
                ErrorMsg := ErrorMsg + #13#10;
              ErrorMsg := ErrorMsg + 'Заказ не найден! [Счёт №' + OrdInfo.FDocNumber + ' от ' + DateToStr(OrdInfo.FDocDate) + ']';
            end;
            //
            if IsSaved then
              Inc(SavedCount);
            if IsSuccess then
            begin
              Inc(SuccessCount);
            end
            else
            begin
              Inc(ErrorCount);
              if ErrorMsg = '' then
                ErrorMsg := 'Неизвестная ошибка';
              ErrorMsg := 'Строка ' + IntToStr(Succ(OrdInfo.FRowNumber)) + #13#10 + ErrorMsg;// + #13#10;
              Report.Add(ErrorMsg);
//              Memo1.Lines.Add(ErrorMsg);
//              Memo1.CaretPos := Point(0, Memo1.Lines.Count - 1);
            end;
            if Assigned(Order) then
              FreeAndNil(Order);
            
            ProgressBar1.Position := I;
            Application.ProcessMessages;
          end;
          //
          Memo1.Lines.AddStrings(Report);
          Memo1.Lines.Add('================================');
          Memo1.Lines.Add('Импорт закончен ' + FormatDateTime('yyyy.mm.dd hh:nn:ss', Now));
          Memo1.Lines.Add('Успешно обработано заказов: ' + IntToStr(SuccessCount));
          Memo1.Lines.Add('Обновлено заказов: ' + IntToStr(SavedCount));
          Memo1.Lines.Add('Ошибок: ' + IntToStr(ErrorCount));
          Memo1.Lines.Add('');
          Memo1.CaretPos := Point(0, Memo1.Lines.Count - 1);
          ProgressBar1.Position := 0;
          btnSave.Enabled := True;
        end;
      finally
        FreeAndNil(Report);
        FreeAndNil(Lst);
      end;
    end
    else
    begin
      Memo1.Lines.Add('');
      Memo1.Lines.Add('Файл "' + edFile.Text + '" не существует.');
      Memo1.CaretPos := Point(0, Memo1.Lines.Count - 1);
    end;
  finally
    DecimalSeparator := OldDs;
    FInUpdate := False;
    lProgress.Visible := False;
    btnClose.Enabled := not FInUpdate;
    btnOpen.Enabled := not FInUpdate;
    btnImport.Enabled := not FInUpdate;
    FreeAndNil(OrderInfos);
  end;
end;

procedure TOrderImport1CForm.btnOpenClick(Sender: TObject);
begin
  if OpenDialog2.Execute then
  begin
    edFile.Text := OpenDialog2.FileName;
    btnImport.Enabled := FileExists(edFile.Text);
  end;
end;

procedure TOrderImport1CForm.btnSaveClick(Sender: TObject);
var
  OrderMngr: TKisOrderMngr;
begin
  OrderMngr := AppModule[kmOrders] as TKisOrderMngr;
  if Assigned(OrderMngr.DefaultTransaction) then
  if OrderMngr.DefaultTransaction.Active then
    OrderMngr.DefaultTransaction.CommitRetaining;
  btnSave.Enabled := False;
end;

procedure TOrderImport1CForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  Answ: Integer;
  OrderMngr: TKisOrderMngr;
begin
  CanClose := False;
  if btnSave.Enabled then
  begin
    Answ := MessageBox(Handle, 'Закрыть без сохранения?', 'Подтверждение', MB_ICONQUESTION + MB_YESNO);
    case Answ of
    ID_YES:
      begin
        OrderMngr := AppModule[kmOrders] as TKisOrderMngr;
        if Assigned(OrderMngr.DefaultTransaction) then
        if OrderMngr.DefaultTransaction.Active then
        begin
          OrderMngr.DefaultTransaction.RollbackRetaining;
          CanClose := True;
        end;
      end;
//    ID_NO:
    else
      Abort;
    end;
  end
  else
    CanClose := True;
end;

{ TOrderImport1CForm.TOrderInfo }

constructor TOrderImport1CForm.TOrderInfo.Create;
begin
  inherited;
  FIntDocNumber := -1;
  FRowNumber := -1;
  FDocDate := 0;
  FPayDate := 0;
  FActDate := 0;
end;

function TOrderImport1CForm.TOrderInfo.GetDocInfo(const Data: String;
  var ErrorMsg: String): Boolean;
var
  Tmp: TStringList;
  aDate: TDateTime;
  D: Double;
  S: String;
  J: Integer;
begin
  Result := False;
  ErrorMsg := '';
  Tmp := TStringList.Create;
  try
    Tmp.StrictDelimiter := True;
    Tmp.Delimiter := ',';
    Tmp.DelimitedText := Data;
    if Tmp.Count >= 6 then
    begin
      FDocNumber := Trim(Tmp[0]);
      if TryStrToDate(Trim(Tmp[1]), aDate) then
      begin
        FDocDate := aDate;
        //
        if TryStrToDate(Trim(Tmp[2]), aDate) then
          FPayDate := aDate
        else
          if Trim(Tmp[2]) = '' then
            FPayDate := 0
          else
            ErrorMsg := ErrorMsg + #13#10 + 'Неверный формат даты оплаты! Значение поля: [' + Tmp[2] + ']';
        //
        FSum := Tmp[3];
        //
        if TryStrToDate(Trim(Tmp[4]), aDate) then
          FActDate := aDate
        else
          if Trim(Tmp[4]) = '' then
            FActDate := 0
          else
            ErrorMsg := ErrorMsg + #13#10 + 'Неверный формат даты оплаты! Значение поля: [' + Tmp[4] + ']';
        //
        FActSum := Tmp[5];
        //
        if (FSum <> '') and (not TryStrToFloat(FSum, D)) then
          ErrorMsg := ErrorMsg + #13#10 + 'Неверный формат суммы счёта! Значение поля: [' + FSum + ']';
        if (FActSum <> '') and (not TryStrToFloat(FActSum, D)) then
          ErrorMsg := ErrorMsg + #13#10 + 'Неверный формат суммы реализации! Значение поля: [' + FActSum + ']';
        Result := True;
      end
      else
        ErrorMsg := 'Неверный формат даты счёта! Значение поля: [' + Tmp[1] + ']';
      //
      S := FDocNumber;
      Delete(S, 1, 5);
      if TryStrToInt(S, J) then
        FIntDocNumber := J
      else
        FIntDocNumber := -1;
    end
    else
      ErrorMsg := 'Недостаточно данных!';
  finally
    FreeAndNil(Tmp);
  end;
end;

procedure TOrderImport1CForm.TOrderInfo.Join(anInfo: TOrderInfo);
begin
  if Assigned(anInfo) then
  begin
    if FIntDocNumber < 1 then
      if anInfo.FIntDocNumber > 0 then
        FIntDocNumber := anInfo.FIntDocNumber;
    if FDocNumber = '' then
      if anInfo.FDocNumber <> '' then
        FDocNumber := anInfo.FDocNumber;
    if FSum = '' then
      if anInfo.FSum <> '' then
        FSum := anInfo.FSum;
    if FActSum = '' then
      if anInfo.FActSum <> '' then
        FActSum := anInfo.FActSum;
    if FDocDate = 0 then
      if anInfo.FDocDate <> 0 then
        FDocDate := anInfo.FDocDate;
    if FPayDate = 0 then
      if anInfo.FPayDate <> 0 then
        FPayDate := anInfo.FPayDate;
    if FActDate = 0 then
      if anInfo.FActDate <> 0 then
        FActDate := anInfo.FActDate;
  end;
end;

end.
