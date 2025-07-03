unit uMStKernelStackUtils;

interface

uses
  SysUtils, ComCtrls, Math,
  uVCLUtils,
  uMStKernelConsts, uMStKernelClasses,
  uMStClassesLots, uMStClassesProjects, uMStClassesProjectsMP;

  procedure ContoursToListView(ListView: TListView; Contours: TmstLotContours);
  procedure PointsToListView(ListView: TListView; aPoints: TmstLotPoints);
  procedure ProjectToListView(ListView: TListView; Prj: TmstProject);
  procedure MPObjectToListView(ListView: TListView; Obj: TmstMPObject);

implementation

procedure ContoursToListView(ListView: TListView; Contours: TmstLotContours);
var
  I: Integer;
  Item: TListItem;
begin
  if not Assigned(ListView) then
    Exit;
  ListView.Items.BeginUpdate;
  try
    ListView.Clear;
    ListView.Columns.Clear;
    with ListView.Columns.Add do
    begin
      Caption := 'Имя контура';
      AutoSize := False;
    end;
    with ListView.Columns.Add do
    begin
      Caption := 'Включен';
      AutoSize := False;
    end;
    with ListView.Columns.Add do
    begin
      Caption := '+/-';
      AutoSize := False;
    end;
    with ListView.Columns.Add do
    begin
      Caption := 'Площадь';
      AutoSize := False;
    end;
    //
    if Assigned(Contours) then
    begin
      for I := 0 to Pred(Contours.Count) do
      begin
        Item := ListView.Items.Add;
        Item.Caption := Contours[I].AsText;
        if Contours[I].Enabled then
        begin
          Item.ImageIndex := IMAGE_CONTOUR_ENABLED;
          Item.SubItems.Add('Да');
        end
        else
        begin
          Item.ImageIndex := IMAGE_CONTOUR_DISABLED;
          Item.SubItems.Add('Нет');
        end;
        if Contours[I].Positive then
        begin
          Item.ImageIndex := IMAGE_CONTOUR_ENABLED;
          Item.SubItems.Add('+');
        end
        else
        begin
          Item.ImageIndex := IMAGE_CONTOUR_DISABLED;
          Item.SubItems.Add('-');
        end;
        Item.SubItems.Add(Contours[I].AreaStr);
      end;
      AutoSelectListViewColumnWidth(ListView, 16);
    end;
  finally
    ListView.Items.EndUpdate;
  end;
end;

procedure PointsToListView(ListView: TListView; aPoints: TmstLotPoints);
var
  I: Integer;
  Item: TListItem;
  Corner: Double;
begin
  if not Assigned(ListView) then
    Exit;
  ListView.Items.BeginUpdate;
  try
    ListView.Clear;
    ListView.Columns.Clear;
    with ListView.Columns.Add do
    begin
      Caption := 'Точка';
      AutoSize := False;
    end;
    with ListView.Columns.Add do
    begin
      Caption := 'X';
      AutoSize := False;
    end;
    with ListView.Columns.Add do
    begin
      Caption := 'Y';
      AutoSize := False;
    end;
    with ListView.Columns.Add do
    begin
      Caption := 'Длина';
      AutoSize := False;
    end;
    with ListView.Columns.Add do
    begin
      Caption := 'Азимут';
      AutoSize := False;
    end;
    //
    if Assigned(aPoints) then
    begin
      for I := 0 to Pred(aPoints.Count) do
      begin
        Item := ListView.Items.Add;
        Item.ImageIndex := IMAGE_POINT;
        Item.Caption := aPoints[I].Name;
        Item.SubItems.Add(Format('%8.2f', [aPoints[I].X]));
        Item.SubItems.Add(Format('%8.2f', [aPoints[I].Y]));
        Item.SubItems.Add(Format('%8.2f', [aPoints.Length[I]]));
        Corner := RadToDeg(aPoints.Azimuth[I]);
        Item.SubItems.Add(Format('%3d° %3.1f'+#39,[Trunc(Corner),60*Frac(Corner)]));
      end;
      AutoSelectListViewColumnWidth(ListView);
  //    ListView.Columns[0].Width := ListView.Columns[0].Width + 16;
    end;
  finally
    ListView.Items.EndUpdate;
  end;
end;

procedure ProjectToListView(ListView: TListView; Prj: TmstProject);
var
  Item: TListItem;
  S: string;
begin
  if not Assigned(ListView) then
    Exit;
  ListView.Items.BeginUpdate;
  try
    ListView.Clear;
    ListView.Columns.Clear;
    with ListView.Columns.Add do
    begin
      Caption := 'Поле';
      AutoSize := False;
    end;
    with ListView.Columns.Add do
    begin
      Caption := 'Данные';
      AutoSize := False;
    end;
    //
    if Assigned(Prj) then
    begin
      Item := ListView.Items.Add;
      Item.Caption := 'Адрес';
      Item.SubItems.Add(Prj.Address);
      //
      Item := ListView.Items.Add;
      Item.Caption := 'Номер';
      Item.SubItems.Add(Prj.DocNumber);
      //
      Item := ListView.Items.Add;
      Item.Caption := 'Дата';
      if Prj.DocDate = 0 then
        S := ''
      else
        S := DateToStr(Prj.DocDate);
      Item.SubItems.Add(S);
      //
      Item := ListView.Items.Add;
      Item.Caption := 'Проверен';
      if Prj.Confirmed then
        S := 'Да'
      else
        S := 'Нет';
      Item.SubItems.Add(S);
    end;
    AutoSelectListViewColumnWidth(ListView);
  finally
    ListView.Items.EndUpdate;
  end;
end;

procedure MPObjectToListView(ListView: TListView; Obj: TmstMPObject);
var
  Item: TListItem;
  S: string;
begin
  if not Assigned(ListView) then
    Exit;
  ListView.Items.BeginUpdate;
  try
    ListView.Clear;
    ListView.Columns.Clear;
    with ListView.Columns.Add do
    begin
      Caption := 'Поле';
      AutoSize := False;
    end;
    with ListView.Columns.Add do
    begin
      Caption := 'Данные';
      AutoSize := False;
    end;
    //
    if Assigned(Obj) then
    begin
      Item := ListView.Items.Add;
      Item.Caption := 'Адрес';
      Item.SubItems.Add(Obj.Address);
      //
      Item := ListView.Items.Add;
      Item.Caption := 'Номер';
      Item.SubItems.Add(Obj.DocNumber);
      //
      Item := ListView.Items.Add;
      Item.Caption := 'Дата';
      if Obj.DocDate = 0 then
        S := ''
      else
        S := DateToStr(Obj.DocDate);
      Item.SubItems.Add(S);
      //
      Item := ListView.Items.Add;
      Item.Caption := 'Проверен';
      if Obj.Confirmed then
        S := 'Да'
      else
        S := 'Нет';
      Item.SubItems.Add(S);
    end;
    AutoSelectListViewColumnWidth(ListView);
  finally
    ListView.Items.EndUpdate;
  end;
end;

end.
