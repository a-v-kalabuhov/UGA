unit uMStFTPConnection;

interface

uses
  SysUtils, Classes, IniFiles, IdBaseComponent, IdComponent, IdTCPConnection, IdIOHandlerStack,
  IdTCPClient, IdFTP, IdIOHandler, IdIOHandlerSocket, IdIntercept, IdFTPList, IdExplicitTLSClientServerBase,
  //
  uGC, uCommonUtils, uGeoUtils;

type
  TMStFTPFileTypes = (ftGISData, ftImage);

  TMStFTPConnection = class(TDataModule)
    FTP: TIdFTP;
    Intercept: TIdConnectionIntercept;
    IdIOHandlerStack1: TIdIOHandlerStack;
  private
    FUserIsAdministrator: Boolean;
    procedure SetUserData;
    procedure CheckPath(const Path: String);
  public
    function GetFile(FileType: TMStFTPFileTypes; const FileName: String): TStream;
    procedure SetFile(FileType: TMStFTPFileTypes; const FileName: String;
      Stream: TStream = nil);
    procedure DeleteFile(FileType: TMStFTPFileTypes; const FileName: String);
    function DeleteFiles(MapFiles: TStringList): Boolean;
    procedure Init(UserIsAdministrator: Boolean; Host: string; Port: Integer);
  end;

  function GetMapImageFileName(const Nomenclature: String): String;
  function GetMapImageFileName2(Nomenclature: String): String;

implementation

{$R *.dfm}

function GetMapImageFileName(const Nomenclature: String): String;
var
  L: TStringList;
begin
  L := TStringList.Create;
  L.Forget();
  TGeoUtils.GetNomenclatureParts(Nomenclature, L);
  Result := L[0] + '/' + L[0] + '-' + L[1] + '/' + Nomenclature + '.gfa';
end;

function GetMapImageFileName2(Nomenclature: String): String;
var
  N: TNomenclature;
begin
  Nomenclature := ChangeFileExt(Nomenclature, '');
  N.Init(Nomenclature, False);
  Result := N.Part1 + '/' + N.Part1 + '-' + N.Part2 + '/' + N.Nomenclature() + '.gfa';
end;

{ TMStFTPConnection }

procedure TMStFTPConnection.CheckPath(const Path: String);
var
  I: Integer;
  S: String;
begin
  with TStringList.Create do
  begin
    Forget();
    S := '';
    Delimiter := '/';
    StrictDelimiter := True;
    DelimitedText := Path;
    for I := 0 to Count - 1 do
    begin
      S := Strings[I];
      try
        FTP.ChangeDir(S);
      except
        FTP.MakeDir(S);
        FTP.ChangeDir(S);
      end;
    end;
  end;
end;

function TMStFTPConnection.DeleteFiles(MapFiles: TStringList): Boolean;
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
    for i := 0 to Pred(MapFiles.Count) do
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

procedure TMStFTPConnection.DeleteFile(FileType: TMStFTPFileTypes; const FileName: String);
var
  S: String;
begin
  SetUserData;
  FTP.Connect;
  try
    case FileType of
    ftImage :
        S := 'Planshet/' + GetMapImageFileName(FileName);
    else
      Exit;
    end;
    FTP.Delete(S);
  finally
    FTP.Disconnect;
  end;
end;

function TMStFTPConnection.GetFile(FileType: TMStFTPFileTypes; const FileName: String): TStream;
var
  S: String;
begin
  SetUserData;
//  FTP.Login;
  FTP.Connect;
  try
    Result := TMemoryStream.Create;
    case FileType of
    ftGISData :
        S := 'data/gisdata.zip';
    ftImage :
        S := 'Planshet/' + GetMapImageFileName(FileName);
    end;
    FTP.Get(S, Result);
  finally
    FTP.Disconnect;
  end;
end;

procedure TMStFTPConnection.Init(UserIsAdministrator: Boolean; Host: string;
  Port: Integer);
begin
  FUserIsAdministrator := UserIsAdministrator;
  FTP.Host := Host;
  FTP.Port := Port;
end;

procedure TMStFTPConnection.SetFile(FileType: TMStFTPFileTypes; const FileName: String; Stream: TStream);
var
  S, S1, Fn: String;
  I: Integer;
  OwnStream: Boolean;
begin
  SetUserData;
//  FTP.Login;
  FTP.Connect;
  try
    case FileType of
    ftGISData :
        S := 'data/gisdata.zip';
    ftImage :
        S := 'Planshet/' + GetMapImageFileName2(ExtractFileName(FileName));
    end;
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
    //
    OwnStream := not Assigned(Stream);
    if OwnStream then
      Stream := TFileStream.Create(FileName, fmOpenRead);
    try
      FTP.Put(Stream, Fn);
    finally
      if OwnStream then
        FreeAndNil(Stream);
    end;
  finally
    FTP.Disconnect;
  end;
end;

procedure TMStFTPConnection.SetUserData;
begin
  if FUserIsAdministrator then
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

end.
