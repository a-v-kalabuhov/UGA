unit ObjectStorage;

interface

uses
  SimpleXML, Utils, SysUtils, Classes;

type
  TUserInformation = record
    UserName: ShortString;
    Password: ShortString;
  end;

  TVarObject = class
  private
    FValue: Variant;
    procedure SetValue(const Value: Variant);
  public
    property Value: Variant read FValue write SetValue;
  end;

  TXMLStorage = class
  private
    procedure CreateNewStorageFile;
    function GetNewObjectId: Integer;
    function CreateEmptyObject(ObjTypeName: String; id: Integer): IXMLNode;
    function IsNativeType(TypeName: String): Boolean;
    function CopyNode(NewName: TXmlString; From: IXMLNode): IXMLNode;
    function ObjectByID(LayerName: String; id: Integer): IXMLNode;
    function ObjectTypeByName(ObjTypeName: String): IXMLNode;
    function LayerByName(LayerName: String): IXMLNode;
    procedure SetParamFromList(node: IXMLNode; list: TStringList);
    function SnapShotForNode(node: IXMLNode): IXMLNode;
    procedure SetUserInformation; virtual; abstract;
  protected
    FName: String;
    FDir: String;
    FXMLDocument: IXMLDocument;
    FSnapShot: IXMLDocument;
    FUpdates: IXMLDocument;
    FUser: TUserInformation;
    FEmpty: Boolean;
    function CreateSnapShot: String;
  public
    // Common
    property Name: String read FName;
    function Init: Boolean; virtual; abstract;
    // BasicTypes
    // ObjectTypes
    // Objects
    function AddObject(LayerName, ObjTypeName: String): Integer;
    function DeleteObject(id: Integer; LayerName: String = ''): Integer;
    function EditObject(LayerName: String; id: Integer; ParamName: String; Value: Variant): Integer; overload;
    function EditObject(LayerName: String; id: Integer; ArrayOrStructParamName: String; Value: TSTringList): Integer; overload;
    function RDeleteObject(id: Integer): Boolean;
    function RSaveObject(id: Integer): Boolean;
    function ObjectsCount(LayerName: String): Integer;
    function StoreLocal: Boolean;
    function RestoreLocal: Boolean;
    function Update(changes: String): Boolean;
  published
    constructor Create(Name, dir: String);
    destructor Destroy; override;
  end;

implementation

{ TObjectStorage }

function TXMLStorage.AddObject(LayerName, ObjTypeName: String): Integer;
var
  Layer, Node: IXMLNode;
begin
  result := -1;
  // Добавляем объект
  Layer := LayerByName(LayerName);
  if Layer <> nil then
    try
      // Получаем от сервера новое ID
      result := GetNewObjectId;
      // Добавляем объект
      Node := CreateEmptyObject(ObjTypeName, result);
      if Node = nil then raise EAbort.Create('Неверный тип ноды!');
      Layer.AppendChild(Node);
    except
    end;
end;

function TXMLStorage.CopyNode(NewName: TXmlString;
  From: IXMLNode): IXMLNode;
var
  i: Integer;
begin
  result := FXMLDocument.CreateElement(NewName);
  for i := 0 to From.AttrCount - 1 do
    result.SetVarAttr(From.Get_AttrName(i), From.GetVarAttr(From.Get_AttrName(i), 0));
  if From.ChildNodes.Count = 0 then
  begin
    result.Set_TypedValue(From.TypedValue);
  end
  else
    for i := 0 to From.ChildNodes.Count - 1 do
      result.AppendChild(CopyNode(From.ChildNodes.Item[i].NodeName, From.ChildNodes.Item[i]));
end;

constructor TXMLStorage.Create(Name, dir: String);
begin
  FName := Name;
  if dir[Length(dir)] <> '\' then dir := dir + '\';
  FDir := dir;
  if not FileExists(Fdir + FName) then
    CreateNewStorageFile
  else
  begin
    FXMLDocument := SimpleXML.CreateXmlDocument(FName);
    RestoreLocal;
    FEmpty := False;
  end;
  FSnapShot := SimpleXML.CreateXmlDocument('SNAPSHOT');
  SetUserInformation;
end;

function TXMLStorage.CreateEmptyObject(ObjTypeName: String; id: Integer): IXMLNode;
var
  TypeDef, TypeDefs, Param, ParamName, ParamType, DefVal, Node: IXMLNode;
  Params: IXMLNodeList;
  i, j, c: Integer;
  s: String;
begin
  // Ищщем описание типа
  TypeDefs := FXMLDocument.DocumentElement.SelectSingleNode('ObjectTypes');
  TypeDef := TypeDefs.SelectSingleNode(ObjTypeName);
  if TypeDef <> nil then
  begin
    // Создаем объект
    result := FXMLDocument.CreateElement('object');
    result.SetIntAttr('ID', id);
    result.SetAttr('ObjType', ObjTypeName);
    // Создаем параметры объекта
    c := TypeDef.GetIntAttr('Count');
    Params := TypeDef.ChildNodes;
    for i := 0 to c - 1 do
    begin
      Param := TypeDef.ChildNodes.Item[i];
      ParamName := Param.SelectSingleNode('ParamName');
      ParamType := Param.SelectSingleNode('ParamType');
      DefVal := Param.SelectSingleNode('DefValue');
      s := ParamType.Get_Text;
      Node := result.AppendElement(ParamName.Get_Text);
      if IsNativeType(s) then
      begin
        Node.TypedValue := DefVal.TypedValue;
      end
      else
        for j := 0 to DefVal.ChildNodes.Count - 1 do
        begin
          Node.AppendChild(CopyNode(ParamName.Get_Text, DefVal));
        end;
    end;
  end
  else
    result := nil;
end;

procedure TXMLStorage.CreateNewStorageFile;
var
  Header, DocType, Elem, SubElem: IXMLElement;
  Node: IXMLNode;
begin
  FEmpty := True;
  FXMLDocument := SimpleXML.CreateXmlDocument('MAP', '1.0', 'windows-1251', nil);
  // Создаем заголовок
  Header := FXMLDocument.DocumentElement.AppendElement('Header');
  DocType := Header.AppendElement('DocType');
  Node := FXMLDocument.CreateText('Data'); //SnapData, Data, UpdateData
  DocType.AppendChild(Node);
  // Тело
  SubElem := FXMLDocument.DocumentElement.AppendElement('ObjectTypes');
  SubElem.SetIntAttr('ObjectTypesCount', 0);
  SubElem := FXMLDocument.DocumentElement.AppendElement('Layers');
  SubElem.SetIntAttr('LayersCount', 0);
  StoreLocal;
end;

function TXMLStorage.CreateSnapShot: String;
var
  i: Integer;
begin
  result := '';
  for i := 0 to FXMLDocument.DocumentElement.ChildNodes.Count - 1 do
  begin
    FSnapShot.DocumentElement.AppendChild(SnapShotForNode(FXMLDocument.DocumentElement.ChildNodes.Item[i]));
  end;
  result := FSnapShot.XML;
end;

function TXMLStorage.DeleteObject(id: Integer; LayerName: String = ''): Integer;
var
  ParentNode, Obj: IXMLNode;
begin
  result := -1;
  Obj := ObjectByID(LayerName, id);
  ParentNode := Obj.ParentNode;
  if ParentNode <> nil then
  begin
    if RDeleteObject(id) then
       ParentNode.RemoveChild(Obj);
    result := 0;
  end;
end;

destructor TXMLStorage.Destroy;
begin
  FXMLDocument._Release;
  FSnapShot._Release;
  inherited;
end;

function TXMLStorage.EditObject(LayerName: String; id: Integer; ParamName: String;
  Value: Variant): Integer;
var
  Obj, ObjType, Param, Kind: IXMLNode;
  ObjectTypeName: String;
begin
  result := -1;
  Obj := ObjectByID(LayerName, id);
  if Obj <> nil then
  begin
    ObjectTypeName := Obj.GetAttr('ObjType');
    if ObjectTypeName <> '' then
    begin
      ObjType := ObjectTypeByName(ObjectTypeName);
      if ObjType <> nil then
      begin
        Param := ObjType.SelectSingleNode(ParamName);
        Kind := Param.SelectSingleNode('Kind');
        if Kind <> nil then
        begin
          if Kind.Text = 'SET' then
          begin
            Obj.SelectSingleNode(ParamName).Text := Value;
            result := 0;
          end;
        end
        else
          try
            Obj.SelectSingleNode(ParamName).TypedValue := Value;
            result := 0;
          except
          end;
      end;
    end;
  end;
end;

function TXMLStorage.EditObject(LayerName: String; id: Integer; ArrayOrStructParamName: String;
  Value: TStringList): Integer;
var
  Obj, ObjType, Param, Kind, SubParam: IXMLNode;
  ObjectTypeName: String;
  i: Integer;
begin
  result := -1;
  Obj := ObjectByID(LayerName, id);
  if Obj <> nil then
  begin
    ObjectTypeName := Obj.GetAttr('ObjType');
    if ObjectTypeName <> '' then
    begin
      ObjType := ObjectTypeByName(ObjectTypeName);
      if ObjType <> nil then
      begin
        Param := ObjType.SelectSingleNode(ArrayOrStructParamName);
        Kind := Param.SelectSingleNode('Kind');
        if Kind <> nil then
        begin
          if Kind.Text = 'ARRAY' then
          begin
            Param.RemoveAllChilds;
            for i := 0 to Value.Count - 1 do
            begin
              SubParam := Param.AppendElement(Value.Strings[i]);
              if Value.Objects[i] is TStringList then
                SetParamFromList(SubParam, Value.Objects[i] as TSTringList)
              else
                if Value.Objects[i] is TVarObject then
                  SubParam.TypedValue := TVarObject(Value.Objects[i]).Value;
            end;
            result := 0;
          end
          else
          if Kind.Text = 'STRUCTURE' then
          begin
            Param.RemoveAllChilds;
            SetParamFromList(Param, Value);
            result := 0;
          end
          else
            result := -1;
        end
        else
          result := -1;
      end;
    end;
  end;
end;

function TXMLStorage.GetNewObjectId: Integer;
begin
  result := -1;
  // Взять ID с сервера
end;

function TXMLStorage.IsNativeType(TypeName: String): Boolean;
begin
   result := (TypeName = 'INTEGER') or (TypeName = 'STRING') or
             (TypeName = 'FLOAT') or (TypeName = 'BOOL');
end;

function TXMLStorage.LayerByName(LayerName: String): IXMLNode;
var
  Layers: IXMLNode;
begin
  result := nil;
  if LayerName <> '' then
  begin
    Layers := FXMLDocument.DocumentElement.SelectSingleNode('Layers');
    result := Layers.SelectSingleNode(LayerName);
  end;
end;

function TXMLStorage.ObjectByID(LayerName: String; id: Integer): IXMLNode;
var
  LayerNode: IXMLNode;
begin
  result := nil;
  LayerNode := LayerByName(LayerName);
  if LayerNode <> nil then
    result := LayerNode.FindElement('object', 'id', id);
end;

function TXMLStorage.ObjectsCount(LayerName: String): Integer;
var
  Layer: IXMLNode;
begin
  Layer := LayerByname(LayerName);
  if Layer <> nil then
    result := Layer.ChildNodes.Count
  else
    result := -1;
end;

function TXMLStorage.ObjectTypeByName(ObjTypeName: String): IXMLNode;
var
  TypesNode: IXMLNode;
begin
  result := nil;
  TypesNode := FXMLDocument.DocumentElement.SelectSingleNode('ObjectTypes');
  if TypesNode <> nil then
    result := TypesNode.SelectSingleNode(ObjTypeName);
end;

function TXMLStorage.RDeleteObject(id: Integer): Boolean;
begin
  result := False;
end;

function TXMLStorage.RestoreLocal: Boolean;
begin
  result := True;
end;

function TXMLStorage.RSaveObject(id: Integer): Boolean;
begin
  result := False;
end;

procedure TXMLStorage.SetParamFromList(node: IXMLNode;
  list: TStringList);
var
  i: Integer;
  child: IXMLNode;
begin
  for i := 0 to list.Count - 1 do
  begin
    child := node.SelectSingleNode(list.Strings[i]);
    if list.Objects[i] is TStringList then
      SetParamFromList(child, list.Objects[i] as TStringList)
    else
    if list.Objects[i] is TVarObject then
      child.TypedValue := TVarObject(list.Objects[i]).Value;
  end;
end;

function TXMLStorage.SnapShotForNode(node: IXMLNode): IXMLNode;
var
  i, ver, id: Integer;
begin
  result := nil;
  ver := node.GetIntAttr('version');
  id := node.GetIntAttr('id');
  if (id * ver) = 0 then
  begin
    result := FSnapShot.CreateElement(node.NodeName);
    result.SetIntAttr('id', id);
    result.SetIntAttr('version', ver);
    for i := 0 to node.ChildNodes.Count - 1 do
      result.AppendChild(SnapShotForNode(node.ChildNodes.Item[i]));
  end;
end;

function TXMLStorage.StoreLocal: Boolean;
begin
  result := True;
end;

function TXMLStorage.Update(changes: String): Boolean;
begin
  result := False;
  if FUpdates = nil then FUpdates := SimpleXML.CreateXmlDocument('UPDATE');
  FUpdates.LoadXML(changes);
  
  FUPdates._Release;
end;

{
<?xml version="1.0" encoding="windows-1251"?>
  <MAP>
    <Header>
      <DocType>Data</DocType>
    </Header>

    <BasicTypes>
      <Point id="1" version="1">
        <Kind>STRUCTURE</Kind>
        <X>FLOAT</X>
        <Y>FLOAT</Y>
      </Point>
      <Coord id="2" version="1">
        <Kind>ARRAY</Kind>
        <OfType>Point</Kind>
      </Coord>
    </BasicTypes>

    <ObjectTypes>
      <ADDRESS id="1" version="1">
        <ParamName>Building</ParamName>
        <ParamType>STRING</ParamType>
        <DefValue>""</DefValue>

        <ParamName>Street</ParamName>
        <ParamType>STRING</ParamType>
        <DefValue>""</DefValue>

        <ParamName>StreetId</ParamName>
        <ParamType>INTEGER</ParamType>
        <DefValue>"0"</DefValue>
        
        <ParamName>Coord</ParamName>
        <ParamType>Coord</ParamType>
        <DefValue>
            <point>
              <X>0</X>
              <Y>0</Y>
            </point>
        </DefValue>
      </ADDRESS>
    </ObjectTypes>

    <Layers LayersCount="1">
      <ADDRESS_PLAN ObjectsCount="1" VisibleName="Адресный план">
        <object id="108" ext_id="1297" version="1" ObjType="ADDRESS">
          <Building>
            10
          </Building>
          <Street>
            Чебышева
          </Street>
          <StreetId>
            1345
          </StreetId>
          <Coord>
            <point>
              <X>123,76</X>
              <Y>-10567,59</Y>
            </point>
          </Coord>
        </object>
      </ADDRESS>
    </Layers>
  </MAP>
}

{ TVarObject }

procedure TVarObject.SetValue(const Value: Variant);
begin
  FValue := Value;
end;

end.
