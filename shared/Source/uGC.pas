{*******************************************************}
{                                                       }
{                                                       }
{       Сборщик мусора :)                               }
{                                                       }
{       Copyright (c) 2003-2005, Калабухов А.В.         }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание:
  Имя модуля: GarbageCollector
  Версия: 0.2
  Дата последнего изменения: 25.04.2005
  Цель: содержит классы и функции для реализации некоторого подобия сборки мусора.
  Используется:
  Использует:
  Исключения:
  Вывод в БД:
  Вывод:
  До вызова:
  После вызова:   }

{ 0.2              25.04.2005
    - добавлен IStringList
    
  0.1              20.01.2003
    - начальная версия
}

unit uGC;

interface

uses
  SysUtils, Classes, Contnrs, Clipbrd;

type
  IBox = interface
    ['{AAC9B0EF-C271-4878-AA2A-239B74EFA91E}']
    procedure Clear;
    function Content: TObject;
    function Persistent: TPersistent;
  end;

  TBox = class(TInterfacedObject, IBox)
  strict private
    FContent: TObject;
  protected
    procedure Clear;
    function Content: TObject;
    function Persistent: TPersistent;
  public
    constructor Create(aContent: TObject);
    destructor Destroy; override;
  end;

  TBoxedObject = class helper for TObject
  public
    function Forget(): IBox;
  end;

  IAutoObject = interface
    function GetObject: TObject;
    property AObject: TObject read GetObject;
  end;

  TAutoObject = class(TInterfacedObject, IAutoObject)
  private
    FObj: TObject;
  public
    constructor Create(Object_: TObject); virtual;
    destructor Destroy; override;
    function GetObject: TObject;
  end;

  IAutoStrings = interface(IAutoObject)
    function GetStrings: TStrings;
    property Strings: TStrings read GetStrings;
  end;

  IAutoStringList = interface(IAutoObject)
    function GetStringList: TStringList;
    property StringList: TStringList read GetStringList;
  end;

  IAutoObjectList = interface
    function ObjectList: TObjectList;
  end;

  function IObject(anObject: TObject): IAutoObject;
  function IStrings(aList: TStrings): IAutoStrings;
  function IStringList(aList: TStringList): IAutoStringList;

implementation

type
  TAutoStringList = class(TAutoObject, IAutoStringList)
    function GetStringList: TStringList;
  end;

  TAutoObjectList = class(TAutoObject, IAutoObjectList)
  protected
    function ObjectList: TObjectList;
  end;

  TAutoStrings = class(TAutoObject, IAutoStrings)
  protected
    function GetStrings: TStrings;
  end;

function IObject(anObject: TObject): IAutoObject;
begin
  Result := TAutoObject.Create(anObject);
end;

function IStrings(aList: TStrings): IAutoStrings;
begin
  Result := TAutoStrings.Create(aList);
end;

function IStringList(aList: TStringList): IAutoStringList;
begin
  Result := TAutoStringList.Create(aList);
end;

{ TAutoObject }

constructor TAutoObject.Create(Object_: TObject);
begin
  FObj := Object_;
end;

destructor TAutoObject.Destroy;
begin
  if FObj <> nil then
    FObj.Free;
  inherited;
end;

function TAutoObject.GetObject: TObject;
begin
  Result := FObj;
end;

{ TAutoStringList }

function TAutoStringList.GetStringList: TStringList;
begin
  Result := TStringList(FObj);
end;

{ TAutoObjectList }

function TAutoObjectList.ObjectList: TObjectList;
begin
  Result := TObjectList(FObj);
end;

{ TAutoStrings }

function TAutoStrings.GetStrings: TStrings;
begin
  Result := inherited GetObject as TStrings;
end;

{ TBox }

procedure TBox.Clear;
begin
  FreeAndNil(FContent);
end;

function TBox.Content: TObject;
begin
  Result := FContent;
end;

constructor TBox.Create(aContent: TObject);
begin
  inherited Create;
  FContent := aContent;
end;

destructor TBox.Destroy;
begin
  FreeAndNil(FContent);
  inherited;
end;

function TBox.Persistent: TPersistent;
begin
  Result := Content as TPersistent;
end;

{ TBoxedObject }

function TBoxedObject.Forget: IBox;
begin
  Result := TBox.Create(Self);
end;

end.
