unit uMStFTPConnection;

interface

uses
  SysUtils, Classes, IniFiles, IdBaseComponent, IdComponent, IdTCPConnection, IdIOHandlerStack,
  IdTCPClient, IdFTP, IdIOHandler, IdIOHandlerSocket, IdIntercept, IdFTPList, IdExplicitTLSClientServerBase,
  //
  uGC, uCommonUtils, uGeoUtils;

type
  TftpFileTypes = (ftGISData, ftImage);
  TftpImageExt = (ftpGFA, ftpBMP, ftpJPEG);

  TMStFTPConnection = class(TDataModule)
    FTP: TIdFTP;
    Intercept: TIdConnectionIntercept;
    IdIOHandlerStack1: TIdIOHandlerStack;
  private
    FUserIsAdministrator: Boolean;
    procedure SetUserData;
    procedure CheckPath(const Path: String);
    function IntGetFile(const FileName: String; FileData: TStream; const RaiseError: Boolean): Boolean;
  public
    function GetDataFile(const FileName: String): TStream;
    function GetImgFile(const FileName: String; out ImageExt: TftpImageExt): TStream;
    procedure SetFile(FileType: TftpFileTypes; const FileName: String;
      Stream: TStream = nil);
    procedure DeleteFile(FileType: TftpFileTypes; const FileName: String);
    function DeleteFiles(MapFiles: TStringList): Boolean;
    procedure Init(UserIsAdministrator: Boolean; Host: string; Port: Integer);
  end;

  function GetMapImageFileName(const Nomenclature: String; Ext: string = 'gfa'): String;
  function GetMapImageFileName2(Nomenclature: String; Ext: string = 'gfa'): String;

implementation

{$R *.dfm}

function GetMapImageFileName(const Nomenclature: String; Ext: string = 'gfa'): String;
var
  L: TStringList;
begin
  L := TStringList.Create;
  L.Forget();
  TGeoUtils.GetNomenclatureParts(Nomenclature, L);
  if Ext = '' then
    Ext := 'gfa';
  Result := L[0] + '/' + L[0] + '-' + L[1] + '/' + Nomenclature + '.' + Ext;
end;

function GetMapImageFileName2(Nomenclature: String; Ext: string): String;
var
  N: TNomenclature;
begin
  Nomenclature := ChangeFileExt(Nomenclature, '');
  N.Init(Nomenclature, False);
  if Ext = '' then
    Ext := 'gfa';
  Result := N.Part1 + '/' + N.Part1 + '-' + N.Part2 + '/' + N.Nomenclature() + '.' + Ext;
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

procedure TMStFTPConnection.DeleteFile(FileType: TftpFileTypes; const FileName: String);
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

function TMStFTPConnection.GetDataFile(const FileName: String): TStream;
var
  S: String;
begin
  S := 'data/gisdata.zip';
  Result := TMemoryStream.Create;
  try
    IntGetFile(S, Result, True);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

function TMStFTPConnection.GetImgFile(const FileName: String; out ImageExt: TftpImageExt): TStream;
var
  S: String;
begin
  Result := TMemoryStream.Create;
  try
    S := 'Planshet/' + GetMapImageFileName(FileName);
    if IntGetFile(S, Result, False) then
    begin
      ImageExt := ftpGFA;
      Exit;
    end;
    S := 'Planshet/' + GetMapImageFileName(FileName, 'bmp');
    if IntGetFile(S, Result, False) then
    begin
      ImageExt := ftpBMP;
      Exit;
    end;
    S := 'Planshet/' + GetMapImageFileName(FileName, 'jpg');
    if IntGetFile(S, Result, False) then
    begin
      ImageExt := ftpJPEG;
      Exit;
    end;
    S := 'Planshet/' + GetMapImageFileName(FileName, 'jpeg');
    if IntGetFile(S, Result, True) then
    begin
      ImageExt := ftpJPEG;
      Exit;
    end;
  except
    FreeAndNil(Result);
    raise;
  end;
end;

procedure TMStFTPConnection.Init(UserIsAdministrator: Boolean; Host: string;
  Port: Integer);
begin
  FUserIsAdministrator := UserIsAdministrator;
  FTP.Host := Host;
  FTP.Port := Port;
end;

function TMStFTPConnection.IntGetFile(const FileName: String; FileData: TStream; const RaiseError: Boolean): Boolean;
begin
  SetUserData;
  //  FTP.Login;
  try
    FTP.Connect;
    try
      FTP.Get(FileName, FileData, False);
      Result := True;
    finally
      FTP.Disconnect;
    end;
  except
    Result := False;
    if RaiseError then
      raise;
  end;
end;

procedure TMStFTPConnection.SetFile(FileType: TftpFileTypes; const FileName: String; Stream: TStream);
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
