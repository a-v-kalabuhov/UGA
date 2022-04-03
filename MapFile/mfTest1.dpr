// JCL_DEBUG_EXPERT_INSERTJDBG OFF
program mfTest1;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes,
  uMfClasses in 'Source\uMfClasses.pas';

var
  FileName: String;
  F: TMapFile;
  Stream: TFileStream;
begin
  FileName := ParamStr(1);
  if FileExists(FileName) then
  begin
    Stream := TFileStream.Create(FileName, fmOpenRead);
    F := TMapFile.Create;
    try
      F.LoadFromStream(Stream);
    finally
      F.Free;
      Stream.Free;
    end;
  end;
end.
