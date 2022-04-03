unit GZxmlStorage;

{$DEFINE WITHOUT_SERVER}
{.$DEFINE WITH_SERVER}

interface

uses ObjectStorage,
{$IFDEF WITHOUT_SERVER}
     CommonServer,
{$ENDIF}
{$IFDEF WITH_SERVER}
  // Имена юнитов с описанием серверных классов,
{$ENDIF}
     CORBA, SysUtils, CorbaUtils;

type
{$IFDEF WITHOUT_SERVER}
  GZ_Server = class(TServer)
    class function Bind: GZ_Server; virtual; abstract;
  end;
{$ENDIF}

  TGeoZillaXMLStorage = class(TXMLStorage)
  private
    FGZ_Server: GZ_Server;
    procedure SetUserInformation;
  public
    function Init: Boolean; override;
  published
    constructor Create(XMLStorageName: String);
    destructor Destroy; override;
  end;

implementation

{ TGeodZillaXMLStorage }

constructor TGeoZillaXMLStorage.Create(XMLStorageName: String);
var
  name: String;
  i: Integer;
begin
  name := ExtractFileName(XMLStorageName);
  for i := Length(name) to 1 do
    if name[i] = '.' then
      SetLength(name, i - 1);
  inherited Create(name, ExtractFilePath(XMLStorageName));
  if not Init then exit;
end;

destructor TGeoZillaXMLStorage.Destroy;
begin
  FGZ_Server := nil;
  inherited;
end;

function TGeoZillaXMLStorage.Init: Boolean;
var
  copy: String;
begin
  result := False;
  // Получаем ссылку на серверный объект
  try
    FGZ_Server := GZ_Server.Bind;
  except
    on E: SystemException do
      begin
        CorbaUtils.HandleCorbaException(E);
        FGZ_Server := nil;
      end;
  end;
  if FGZ_Server = nil then
  begin
  end
  else
  begin
    // Логинимся
    SetUserInformation;
    if FGZ_Server.Login(FUser.UserName) then
    begin
      if FEmpty then
      begin
        // Запрашиваем копию базы с сервера
        copy := FGZ_Server.GetFullCopyAsXML;
        FXMLDocument.LoadXML(copy);
        StoreLocal;
      end
      else
      begin
        // Посылаем снэпшот, получаем изменения и претворяем их в жизнь :)
        copy := CreateSnapShot;
        copy := FGZ_Server.GetChanges(copy);
        Update(copy);
      end;
    end;
  end;
end;

procedure TGeoZillaXMLStorage.SetUserInformation;
begin
{$IFDEF WIN32}
  ;
{$ENDIF}
end;

initialization
  CorbaInitialize;

end.
