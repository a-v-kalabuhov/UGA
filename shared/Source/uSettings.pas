unit uSettings;

interface

uses
  SysUtils, Classes, xmldom, XMLIntf, XMLDoc, msxmldom, uSettingsBase;

type
  TkaXMLSettings = class(TkaVCLSettings)
  private
    FXMLDoc: TXMLDocument;
    function FindNode(nodeList: IXMLNodeList; NodeName: String; NameAttr: String):
          IXMLNode;
  protected
    function GetFileName: String; override;
    procedure SetFileName(const Value: String); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CreateNewFile(const AFileName: String); override;
    function GetValue(const SectionName, KeyName: String): Variant; override;
    procedure SetValue(const SectionName, KeyName: String;
      const Value: Variant); override;
  end;

implementation

const
  SA_NAME = 'name';
  SN_KEY = 'key';
  SN_SECTION = 'section';
  S_BAD_SETTINGS_FILE = 'Файл настройки %s недоступен или содержит ошибку!';
  S_SETTINGS_FILE_NOT_FOUND = 'Файл настройки %s не найден!';

constructor TkaXMLSettings.Create(AOwner: TComponent);
begin
  inherited;
  FXMLDoc := TXMLDocument.Create(Self);
end;

procedure TkaXMLSettings.CreateNewFile(const AFileName: String);
begin
  inherited;
  FXMLDoc.SaveToFile(AFileName);
  FileName := AFileName;
end;

function TkaXMLSettings.FindNode(nodeList: IXMLNodeList; NodeName,
  NameAttr: String): IXMLNode;
var
  currentNode: IXMLNode;
begin
  Result := nil;
  if nodeList = nil then exit;
  currentNode := nodeList.First;
  while currentNode <> nil do
  begin
    if currentNode.NodeName = NodeName then
    if currentNode.Attributes[SA_NAME] = NameAttr then
    begin
      result := currentNode;
      BREAK;
    end;
    currentNode := currentNode.NextSibling;
  end;
end;

function TkaXMLSettings.GetFileName: String;
begin
  Result := FXMLDoc.FileName;
end;

function TkaXMLSettings.GetValue(const SectionName, KeyName: String): Variant;
var
  node: IXMLNode;
  list: IXMLNodeList;
begin
  list := FXMLDoc.DocumentElement.ChildNodes;
  node := FindNode(list, SN_SECTION, SectionName);
  if node <> nil then
  begin
    list := node.ChildNodes;
    node := FindNode(list, SN_KEY, KeyName);
  end;
  if node <> nil then result := node.NodeValue;
end;

procedure TkaXMLSettings.SetFileName(const Value: String);
begin
  if FileExists(Value) then
  begin
    FXMLDoc.Filename := Value;
    try
      FXMLDoc.Active := True;
    except
      raise EFOpenError.CreateFmt(S_BAD_SETTINGS_FILE, [Value]);
    end;
  end
  else
    raise EFOpenError.CreateFmt(S_SETTINGS_FILE_NOT_FOUND, [Value]);
end;

procedure TkaXMLSettings.SetValue(const SectionName, KeyName: String;
  const Value: Variant);
var
  section, key: IXMLNode;
  list: IXMLNodeList;
begin
  list := FXMLDoc.DocumentElement.ChildNodes;
  section := FindNode(list, SN_SECTION, SectionName);
  if section = nil then
  begin
    section := FXMLDoc.CreateNode(SN_SECTION);
    section.Attributes[SA_NAME] := SectionName;
    list.Add(section);
  end;
  list := section.ChildNodes;
  key := FindNode(list, SN_KEY, KeyName);
  if key = nil then
  begin
    key := FXMLDoc.CreateNode(SN_KEY);
    key.Attributes[SA_NAME] := KeyName;
    list.Add(key);
  end;
  key.NodeValue := Value;
  FXMLDoc.SaveToFile(FXMLDoc.FileName);
end;

end.
