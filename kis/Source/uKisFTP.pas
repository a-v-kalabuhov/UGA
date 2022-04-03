unit uKisFTP;

interface

uses
  SysUtils, Classes, IniFiles, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdFTP, IdIOHandler, IdIOHandlerSocket, IdIntercept,
  IdExplicitTLSClientServerBase, IdIOHandlerStack;

type
  TKisFTP = class(TDataModule)
    FTP: TIdFTP;
    Intercept: TIdConnectionIntercept;
    procedure DataModuleCreate(Sender: TObject);
  private
    FUserIsAdmin: Boolean;
    procedure SetUserData;
    procedure SetUserIsAdmin(const Value: Boolean);
    function GetMapImageFileName(const Nomenclature: String): String;
    procedure CheckPath(const Path: String);
  public
    procedure DeleteFile(const FileName: String);
    function  DeleteFiles(MapFiles: TStringList): Boolean;
    function  GetFile(const FileName: String): TStream;
    procedure Init(const HostName: String; Port: Integer);
    procedure SetFile(const FileName: String; Stream: TStream);
    //
    property UserIsAdmin: Boolean read FUserIsAdmin write SetUserIsAdmin;
  end;

var
  KisFTP: TKisFTP;

implementation

{$R *.dfm}

uses
  uGC, uCommonUtils,
  uKisAppModule, uKisConsts;

{ TKisFTP }

procedure TKisFTP.CheckPath(const Path: String);
var
  I: Integer;
  S, S1: String;
begin
  with IStringList(TStringList.Create).StringList do
  begin
    S := '';
    Delimiter := '/';
    DelimitedText := Path;
    I := 0;
    while I < Count do
    begin
      try
        FTP.ChangeDir(Strings[I]);
      except
      end;
      S := S + '/';
      S := S + Strings[I];
      S1 := FTP.RetrieveCurrentDir;
      if S1 <> S then
        FTP.MakeDir(Strings[I])
      else
        Inc(I);
    end;
  end;
end;

function TKisFTP.DeleteFiles(MapFiles: TStringList): Boolean;
var
  S: String;
  i: Integer;
begin
  Result := False;
  if not Assigned(MapFiles) then
    Exit;
  SetUserData;
  FTP.Connect;
  try
    for i:=0 to Pred(MapFiles.Count) do
    begin
      S := 'Planshet/' + GetMapImageFileName(MapFiles[i]);
      try
        FTP.Delete(S);
      except
      end;
    end;
  finally
    FTP.Disconnect;
  end;
  Result := True;
end;

procedure TKisFTP.DataModuleCreate(Sender: TObject);
var
  Hostname: String;
  Port: Integer;
begin
  HostName := AppModule.ReadAppParam(S_CONNECTION_SECTION, PARAM_FTPHOST, varString);
  Port := AppModule.ReadAppParam(S_CONNECTION_SECTION, PARAM_FTPPORT, varInteger);
  Init(Hostname, Port);
end;

procedure TKisFTP.DeleteFile(const FileName: String);
var
  S: String;
begin
  SetUserData;
  FTP.Connect;
  try
    S := 'Planshet/' + GetMapImageFileName(FileName);
    FTP.Delete(S);
  finally
    FTP.Disconnect;
  end;
end;

function TKisFTP.GetFile(const FileName: String): TStream;
var
  S: String;
begin
  SetUserData;
//  FTP.Login;
  FTP.Connect;
  try
    Result := TMemoryStream.Create;
    S := 'Planshet/' + GetMapImageFileName(FileName);
    FTP.Get(S, Result);
  finally
    FTP.Disconnect;
  end;
end;

function TKisFTP.GetMapImageFileName(
  const Nomenclature: String): String;
var
  L: TStringList;
begin
  L := IStringList(TSTringList.Create).StringList;
  GetNomenclatureParts(Nomenclature, L);
  Result := L[0] + '/' + L[0] + '-' + L[1] + '/' + Nomenclature + '.gfa';
end;

procedure TKisFTP.Init(const HostName: String; Port: Integer);
begin
  FTP.Host := HostName;
  FTP.Port := Port;
end;

procedure TKisFTP.SetFile(const FileName: String; Stream: TStream);
var
  S, S1, Fn: String;
  I: Integer;
begin
  SetUserData;
//  FTP.Login;
  FTP.Connect;
  try
    S := 'Planshet/' + GetMapImageFileName(FileName);
    try
      S1 := S;
      for I := Length(S) downto 1 do
        if S[I] = '/' then
        begin
          Fn := Copy(S, I + 1, Length(S) - 2);
          SetLength(S, Pred(I));
          Break;
        end;
      CheckPath(S);
    except
    end;
    FTP.Put(Stream, Fn);
  finally
    FTP.Disconnect;
  end;
end;

procedure TKisFTP.SetUserData;
begin
  if FUserIsAdmin then
  begin
    FTP.Username := 'PlanshetAdmin';
    FTP.Password := 'mupPlanshetAdminFTP01';
  end
  else
  begin
    FTP.Username := 'PlanshetUser';
    FTP.Password := 'mupPlanshetUserFTP01';
  end;
end;

procedure TKisFTP.SetUserIsAdmin(const Value: Boolean);
begin
  FUserIsAdmin := Value;
end;

end.
