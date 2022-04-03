unit ExportToText;

interface

  procedure ExportAllotmentsToFile;

implementation

uses
  // System
  SysUtils, IBDatabase, IBQuery, Forms, Dialogs,
  //Common
  uGC, uIBXUtils,
  //Project
  uKisAppModule, uKisConsts, uKisIntf;

procedure ExportAllotmentsToFile;
var
  F: TextFile;
  a_id, c_id: Integer;
begin
  with TIBQuery.Create(nil) do
  try
    Forget;
//    BufferChunks := 10;
    Transaction := AppModule.Pool.Get;
    Transaction.Init();
    Transaction.StartTransaction;
    SQL.Add('SELECT A.ID, A.ADDRESS, B.ID, C.ID AS P_ID, C.X, C.Y');
    SQL.Add('FROM ALLOTMENTS A, ALLOTMENT_CONTOURS B, ALLOTMENT_POINTS C');
    SQL.Add('WHERE A.ID=B.ALLOTMENTS_ID AND B.ALLOTMENTS_ID=C.ALLOTMENTS_ID AND B.ID=C.CONTOURS_ID AND B.ENABLED=1');
    SQL.Add('ORDER BY A.ID, B.ID, C.ID');
    with TSaveDialog.Create(nil) do
    begin
      Forget;
      Open;
      FetchAll;
      if Execute then
        AssignFile(F, FileName)
      else
        raise EAbort.Create(S_FILENAME_MISSED);
    end;
    Rewrite(F);
    if not IsEmpty then
    begin
      a_id := -1;
      c_id := -1;
      while not Eof do
      begin
        if a_id <> Fields[0].AsInteger then
        begin
          a_id := Fields[0].AsInteger;
          c_id := -1;
          Writeln(F, a_id);
          Writeln(F, Fields[1].AsString);
        end;
        if c_id <> Fields[2].AsInteger then
        begin
          c_id := Fields[2].AsInteger;
          Writeln(F, 'contour ' + IntToStr(c_id));
        end;
        Writeln(F, Format('%2f', [Fields[4].AsFloat]) +
                     ';' + Format('%2f', [Fields[5].AsFloat]));
        Next;
        Application.ProcessMessages;
        if Application.Terminated then
          Last;
      end;
    end;
    Close;
    CloseFile(F);
  finally
    Transaction.Commit;
    AppModule.Pool.Back(Transaction);
  end;
end;

end.
