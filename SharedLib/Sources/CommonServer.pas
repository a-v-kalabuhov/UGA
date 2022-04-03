Unit CommonServer;

interface

type
  TServer = class
    function Login(userinfo: Variant): Boolean;
    procedure Logout(userinfo: Variant);
    function Bind: TServer;
    function GetChanges(snapshot: String): String;
    function GetFullCopyAsXML: String; 
  end;

  TMapStorage2 = class
    class function Bind: TMapStorage2;
    function Login(user_name: String): Boolean;
    function GetAllMapsData: String;
    function GetOrgsData: String;
    function GetMapsHistoryData(nomenclature: String): String;
    function GetEmployeesData: String;
  end;


implementation

{ TServer }

function TServer.Bind: TServer;
begin
  result := TServer.Create;
end;

function TServer.GetChanges(snapshot: String): String;
begin
  result := '';
end;

function TServer.GetFullCopyAsXML: String;
begin
  result := '';
end;

function TServer.Login(userinfo: Variant): Boolean;
begin
  result := True;
end;

procedure TServer.Logout(userinfo: Variant);
begin

end;

{ IMapStorage }

class function TMapStorage2.Bind: TMapStorage2;
begin
  result := nil;
end;

function TMapStorage2.GetAllMapsData: String;
begin
  result := '';
end;

function TMapStorage2.GetEmployeesData: String;
begin
  result := '';
end;

function TMapStorage2.GetMapsHistoryData(nomenclature: String): String;
begin
  result := '';
end;

function TMapStorage2.GetOrgsData: String;
begin
  result := '';
end;

function TMapStorage2.Login(user_name: String): Boolean;
begin
  result := True;
end;

end.
