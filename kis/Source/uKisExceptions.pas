unit uKisExceptions;

interface

uses
  SysUtils;

type
  EKisException = class(Exception)
  private
    function GetMe: Exception;
  protected
    function GetObjectInfo: String; virtual;
  public
    NativeClassName: String;
    NativeMessage: String;
    constructor Create(E: Exception); overload;
    constructor Create(const Msg: String); overload;
    property Me: Exception read GetMe;
    property ObjectInfo: String read GetObjectInfo;
  end;

  EKisExtException = class(EKisException)
  protected
    FExeVersion: String;
    FObjectInfoText: String;
    function GetObjectInfo: String; override;
  public
    constructor Create(E: Exception; const ObjInfo: String); overload;
    constructor Create(const Msg, ObjInfo: String); overload;
  end;

  EAllotmentException = class(EKisExtException)
  protected
    function GetObjectInfo: String; override;
  public
    Id: Integer;
  end;

  ESQLException = class(EKisExtException)
  protected
    function GetObjectInfo: String; override;
  public
    SQL: String;
  end;

  EKisDeveloperException = class(EKisExtException)
  end;

  function GetVersionInfo(const aFileName: String): String;

implementation

uses
  Windows, Forms,
  uKisConsts;

function GetVersionInfo(const aFileName: String): String;
var
  n, Len: DWORD;
  Buf: PChar;
  info: ^VS_FIXEDFILEINFO;
begin
  //except нет, так используется в uExceptions
  n := GetFileVersionInfoSize(PChar(aFileName), n);
  if n > 0 then
  begin
    Buf := AllocMem(n);
    try
      GetFileVersionInfo(PChar(aFileName), 0, n, Buf);
      VerQueryValue(Buf, '\', Pointer(info), Len);
      Result :=
        IntToStr(info^.dwProductVersionMS shr $10) + '.' +
        IntToStr(info^.dwProductVersionMS and $ffff) + '.' +
        IntToStr(info^.dwProductVersionLS shr $10) + '.' +
        IntToStr(info^.dwProductVersionLS and $ffff);
    finally
      FreeMem(Buf, n);
    end;
  end;
  //
  if Result = '' then
    Result := 'no version information ...';
end;

{ EKisException }

constructor EKisException.Create(E: Exception);
begin
  inherited Create('');
  if Assigned(E) then
  begin
    if E is EKisException then
    begin
      Message := E.Message;
      NativeClassName := EKisException(E).NativeClassName;
      NativeMessage := EKisException(E).NativeMessage;
    end
    else
    begin
      Message := E.Message;
      NativeClassName := E.ClassName;
      NativeMessage := E.Message;
    end;
  end;
end;

constructor EKisException.Create(const Msg: String);
begin
  inherited Create(Msg);
end;

function EKisException.GetMe: Exception;
begin
  Result := Self;
end;

function EKisException.GetObjectInfo: String;
begin
  Result := '';
end;

{ EAllotmentException }

function EAllotmentException.GetObjectInfo: String;
begin
  Result := 'AllotmentId = ' + IntToStr(Id) + #13#10 + inherited GetObjectInfo;
end;

{ ESQLException }

function ESQLException.GetObjectInfo: String;
begin
  Result := SQL  + #13#10 + inherited GetObjectInfo;
end;

{ EKisExtException }

constructor EKisExtException.Create(E: Exception; const ObjInfo: String);
begin
  inherited Create(E);
  FObjectInfoText := ObjInfo;
end;

constructor EKisExtException.Create(const Msg, ObjInfo: String);
begin
  inherited Create(Msg);
  FObjectInfoText := ObjInfo;
end;

function EKisExtException.GetObjectInfo: String;
begin
  Result := FObjectInfoText;
  if Trim(Result) <> '' then
    Result := Result + #13#10;
  Result := Result + 'Exe version: ' + GetVersionInfo(Application.ExeName);
end;

end.
