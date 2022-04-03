unit AFile6;

interface

uses Windows, SysUtils, AProc6, ShellAPI, Forms;

const
  //названия протоколов
  pnNone='';
  pnTCP='TCP/IP';
  pnNetBEUI='NetBEUI';
  pnSPX='SPX';

procedure CopyFile(const SourceFile, DestFile: string; OverWrite: Boolean = True);
procedure CopyDir(SourceDir, DestDir: string; OverWrite: Boolean = True);
function GetTempFileName(Dir: string = ''; Prefix: string = '~'): string;
function GetTempPath: string;
procedure ExecuteFile(FileName: string; Params: string=''; DefaultDir: string='');
function FileExecuteWait(FileName: string; Params: string=''; StartDir: string='';
  ShowFlag: Integer=SW_SHOWNORMAL): Integer;
function NetExtractProtocol(FileName: string): string;
function NetExtractServer(FileName: string): string;
function NetExtractFileName(FileName: string): string;
function NetGetFileName(Protocol, Server, FileName: string): string;

implementation

uses AString6;

procedure CopyFile(const SourceFile, DestFile: string; OverWrite: Boolean = True);
begin
  if Integer(Windows.CopyFile(PChar(SourceFile),PChar(DestFile), not OverWrite)) = 0 then
    RaiseLastWin32Error;
end;

procedure CopyDir(SourceDir, DestDir: string; OverWrite: Boolean = True);
begin

end;

function GetTempPath: string;
begin
  SetLength(Result,MAX_PATH);
  if Windows.GetTempPath(MAX_PATH,PChar(Result))=0 then
    RaiseLastWin32Error;
  RealizeLength(Result);
end;

function GetTempFileName(Dir: string = ''; Prefix: string = '~'): string;
begin
  SetLength(Result,MAX_PATH);
  if Trim(Dir) = '' then
    Dir := GetTempPath;
  if Windows.GetTempFileName(PChar(Dir), PChar(Prefix), 0, PChar(Result)) = 0 then
    RaiseLastWin32Error;
  RealizeLength(Result);
end;

procedure ExecuteFile(FileName: string; Params: string=''; DefaultDir: string='');
begin
  ShellExecute(Application.MainForm.Handle, nil,
    PChar(FileName), PChar(Params), PChar(DefaultDir), SW_SHOWDEFAULT);
end;

//по полному имени файла определяется используемый протокол
function NetExtractProtocol(FileName: string): string;
begin
  if Pos('\\',FileName)>0 then Result:=pnNetBEUI
  else if Pos('@',FileName)>0 then Result:=pnSPX
  else if NetExtractServer(FileName)<>'' then Result:=pnTCP
  else Result:=pnNone;
end;

//по полному имени файла определяется сервер
function NetExtractServer(FileName: string): string;
var
  I1,I2,I3,M: Integer;
begin
  I1:=Pos('\\',FileName);
  if I1>0 then FileName:=Copy(FileName,I1+2,Length(FileName));
  I1:=Pos(':',FileName);
  I2:=Pos('\',FileName);
  I3:=Pos('@',FileName);
  M:=MinNotZero(I1,I2); M:=MinNotZero(M,I3);
  Result:=Trim(Copy(FileName,1,M-1));
  if Length(Result)=1 then Result:='';
end;

//по полному имени файла определяется краткое
function NetExtractFileName(FileName: string): string;
begin
  Result:=Copy(FileName,RPos(':',FileName)-1,Length(FileName));
  //Result:=ExtractFilePath(FileName)+ExtractFileName(FileName);
end;

//по именам сервера, протокола и файла определяется полное сетевое имя
function NetGetFileName(Protocol, Server, FileName: string): string;
begin
  if Protocol=pnTCP then Result:=Server+':'+FileName
  else if Protocol=pnNetBEUI then Result:='\\'+Server+'\'+FileName
  else if Protocol=pnSPX then Result:=Server+'@'+FileName
  else Result:=FileName;
end;

function FileExecuteWait(FileName: string; Params: string=''; StartDir: string='';
  ShowFlag: Integer=SW_SHOWNORMAL): Integer;
var
  Info: TShellExecuteInfo;
  ExitCode: DWORD;
begin
  FillChar(Info, SizeOf(Info), 0);
  Info.cbSize := SizeOf(TShellExecuteInfo);
  with Info do begin
    fMask := SEE_MASK_NOCLOSEPROCESS;
    Wnd := Application.Handle;
    lpFile := PChar(FileName);
    lpParameters := PChar(Params);
    lpDirectory := PChar(StartDir);
    nShow := ShowFlag; //SW_SHOWNORMAL, SW_MINIMIZE, SW_SHOWMAXIMIZED, SW_HIDE
  end;
  Win32Check(ShellExecuteEx(@Info));
  repeat
    Application.ProcessMessages;
    GetExitCodeProcess(Info.hProcess, ExitCode);
  until (ExitCode <> STILL_ACTIVE) or Application.Terminated;
  Result:=ExitCode;
end;

end.
