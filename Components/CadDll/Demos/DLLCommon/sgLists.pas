{************************************************************}
{                 Delphi VCL Extensions                      }
{                                                            }
{            Common   list classes implementation            }
{                                                            }
{      Copyright (c) 2011-2014 SoftGold software company     }
{                                                            }
{************************************************************}

unit sgLists;
{$INCLUDE SGDXF.inc}

{$IFDEF SG_INLINE}
  {$DEFINE USE_INLINE}
{$ENDIF}

{$DEFINE SG_XML_LISTVALUES_AS_ATTRIBUTE}

interface

uses
  {$IFDEF SGFPC}
  LCLIntf, LCLType, Types, cwstring,
  {$ENDIF}
  Classes, SysUtils, sgConsts, sgComparer
  {$IFNDEF SG_NON_WIN_PLATFORM}
  , ActiveX{$IFNDEF SGDEL_6}, Windows{$ENDIF}
  {$ENDIF}
  {$IFDEF SGDEL_XE2}
  ,System.Types, System.UITypes
  {$ENDIF}
  ;

const
  DefaultCountToUseSimpleSort = 13;
  cnstDefaultCapacity = 4;

type
  TsgInterfacedObject = class(TObject, IInterface)
  protected
    //this function implements IInterface
    function _AddRef: Integer; {$IFNDEF SG_NON_WIN_PLATFORM}stdcall;{$ELSE}cdecl;{$ENDIF}
    function _Release: Integer; {$IFNDEF SG_NON_WIN_PLATFORM}stdcall;{$ELSE}cdecl;{$ENDIF}
    {$IFDEF SGFPC}
    function QueryInterface({$IFDEF FPC_HAS_CONSTREF}constref{$ELSE}const{$ENDIF} iid : tguid;out obj) : longint;{$IFDEF SG_NON_WIN_PLATFORM}cdecl{$ELSE}stdcall{$ENDIF};
    {$ELSE}
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    {$ENDIF}
  end;

  TsgThreadContainerList = class
  private
    FList: {$IFDEF SG_OPENING_IN_THEADS} TThreadList {$ELSE} TList {$ENDIF};
  public
    constructor Create;
    destructor Destroy; override;
    function LockList: TList;
    procedure UnlockList;
  end;

  TsgBaseList = class(TsgInterfacedObject, IsgCollectionBase, IsgCollectionBaseSort)
  private
    FSortSmallerFunc: TsgObjProcCompare;
    FSorted: Boolean;
    FDuplicates: TDuplicates;
    FCount: Integer;
    FCapacity: Integer;
    FItemSize: Integer;
    FRawData: Pointer;
    procedure ChangeCount(CountChange: Integer);
    procedure IncCount;
    procedure SetCapacity(const Value: Integer);
  protected
    function AddBase(const AItem: Pointer): Integer;{$IFDEF USE_INLINE}inline;{$ENDIF}
    procedure AppendArrayBase(NewItems: Pointer; NewItemsAddCount: Integer);
    procedure Attach(const AData: Pointer; const ACount: Integer);
    function ComparePointers(const A, B: Pointer): Integer; virtual;
    function FindBase(const AItem: Pointer; var AIndex: Integer): Boolean;{$IFDEF USE_INLINE}inline;{$ENDIF}
    procedure FixOldVersion; virtual;
    function GetCount: Integer;
    function GetDuplicates: TDuplicates;
    function GetItemBase(const AIndex: Integer): Pointer;{$IFDEF USE_INLINE}inline;{$ENDIF}
    function GetItemSize: Integer;
    function GetListType: TsgListType; virtual;
    function GetNearestIndexBase(const AItem: Pointer;
      const ANearestValue: TsgObjProcNearestCompare): Integer;{$IFDEF USE_INLINE}inline;{$ENDIF}
    function GetProcCompare: TsgObjProcCompare;
    function GetSorted: Boolean;
    function IndexOfBase(const AItem: Pointer): Integer;{$IFDEF USE_INLINE}inline;{$ENDIF}
    procedure InsertBase(const AIndex:Integer; const AItem: Pointer);{$IFDEF USE_INLINE}inline;{$ENDIF}
    function RemoveBase(const AItem: Pointer): Integer;{$IFDEF USE_INLINE}inline;{$ENDIF}
    procedure SetCount(NewCount: Integer); virtual;
    procedure SetCountNoInitFini(NewCount: Integer);
    procedure SetDefaultCompareProc(var AProc: sgConsts.TsgObjProcCompare); virtual;
    procedure SetDuplicates(const Value: TDuplicates);
    procedure SetProcCompare(const AValue: TsgObjProcCompare);
    procedure SetSorted(const Value: Boolean); virtual;
  public
    constructor Create; overload; virtual;
    constructor Create(const Source: TsgBaseList); overload;
    constructor Create(const InitialCount: Integer;
      const Capacity: Integer = cnstDefaultCapacity); overload;
    destructor Destroy; override;
    procedure AppendDynArray(Arr: TsgBaseList); overload;
    procedure AppendDynArray(Arr: TsgBaseList; Index, ACount: Integer); overload;
    procedure Assign(Source: TsgBaseList); virtual;
    procedure Clear(ClearCapacity: Boolean = False); virtual;
    function CopyFrom(const AList: TList;
      const AMode: TsgCopyMode = cmCopy): Boolean; virtual;
    function CopyTo(const AList: TList;
      const AMode: TsgCopyMode = cmCopy): Boolean; virtual;
    procedure Delete(const AIndex: Integer); overload; virtual;
    procedure Delete(const Index: Integer; DelCount: Integer); overload; virtual;
    procedure FillChar(FillValue: byte);
    procedure Flip;
    procedure CyclicShiftLeft(const AValue: Integer);
    procedure CyclicShiftRight(const AValue: Integer);
    function High: Integer;
    function IsEqual(const AList: TsgBaseList; Compare: TsgObjProcCompare = nil): Boolean;
    function IsItemsUnique: Boolean;
    procedure Sort(CountToUseSimpleSort: Integer = DefaultCountToUseSimpleSort); overload;
    procedure Sort(FirstIndex, LastIndex: Integer;
      CountToUseSimpleSort: Integer = DefaultCountToUseSimpleSort); overload; virtual;
    procedure SwapItems(Index1, Index2: Integer; const ASwapItemsBuf: Pointer = nil);
//xml serialization
{$IFNDEF SG_CADIMPORTERDLLDEMO}
    function FromXML(const ANode: TObject): Boolean;
    function ToXML(const ANode: TObject; AItemName: string = ''): Boolean;
{$ENDIF}
    function ToStr: string;
    function FromStr(const AValue: string): Integer;
//
    property Capacity: Integer read FCapacity write SetCapacity;
    property Count: Integer read FCount write SetCount;
    property Duplicates: TDuplicates read GetDuplicates write SetDuplicates;
    property ListType: TsgListType read GetListType;
    property ProcCompare: TsgObjProcCompare read GetProcCompare write
      SetProcCompare;
    property Sorted: Boolean read GetSorted write SetSorted;
  end;

  TsgBaseListClass = class of TsgBaseList;

  TsgSingleArray = array[0..MaxInt div SizeOf(Single) - 1] of Single;
  PsgSingleArray = ^TsgSingleArray;

  TsgSingleList = class(TsgBaseList, IsgCollectionSingle)
  private
    function GetFirst: Single;
    function GetLast: Single;
    function GetList: PsgSingleArray;
    function GetItem(const AIndex: Integer): Single;{$IFDEF USE_INLINE}inline;{$ENDIF}
    procedure SetFirst(const Value: Single);
    procedure SetLast(const Value: Single);
    procedure SetItem(const AIndex: Integer; const Item: Single);{$IFDEF USE_INLINE}inline;{$ENDIF}
  protected
    function GetListType: TsgListType; override;
    procedure SetDefaultCompareProc(var AProc: TsgObjProcCompare); override;
  public
    function Add(const Item: Single): Integer;
    procedure AppendArray(const NewItems: array of Single); overload;
    procedure AppendArray(const NewItems: array of Single; NewItemsAddCount: Integer); overload;
    procedure AppendConst(ACount: Integer; AValue: Single);
    procedure AssignArray(const NewItems: array of Single);
    function IndexOf(const Item: Single): Integer;
    procedure Insert(Index: Integer; const Item: Single);
    property First: Single read GetFirst write SetFirst;
    property Items[const AIndex: Integer]: Single read GetItem
      write SetItem; default;
    property Last : Single read GetLast  write SetLast;
    property List: PsgSingleArray read GetList;
  end;

  TsgDoubleArray = array[0..MaxInt div SizeOf(Double) - 1] of Double;
  PsgDoubleArray = ^TsgDoubleArray;

  TsgDoubleList = class(TsgBaseList, IsgCollectionDouble)
  private
    function GetFirst: Double;
    function GetLast: Double;
    function GetList: PsgDoubleArray;
    function GetItem(const AIndex: Integer): Double;{$IFDEF USE_INLINE}inline;{$ENDIF}
    procedure SetFirst(const Value: Double);
    procedure SetLast(const Value: Double);
    procedure SetItem(const AIndex: Integer; const Item: Double);{$IFDEF USE_INLINE}inline;{$ENDIF}
  protected
    function GetListType: TsgListType; override;
    procedure SetDefaultCompareProc(var AProc: TsgObjProcCompare); override;
  public
    function Add(const Item: Double): Integer;
    procedure AppendArray(const NewItems: array of Double); overload;
    procedure AppendArray(const NewItems: array of Double; NewItemsAddCount: Integer); overload;
    procedure AppendConst(ACount: Integer; AValue: Double);
    procedure AssignArray(const NewItems: array of Double);
    procedure Insert(Index: Integer; const Item: Double);
    function GetNearestIndex(const AValue: Double): Integer;
    property First: Double read GetFirst write SetFirst;
    property Items[const AIndex: Integer]: Double
      read GetItem write SetItem; default;
    property Last : Double read GetLast  write SetLast ;
    property List: PsgDoubleArray read GetList;
  end;

  TsgFloatArray = array[0..MaxInt div SizeOf(Double) - 1] of TsgFloat;
  PsgFloatArray = ^TsgFloatArray;

  TsgFloatList = class(TsgBaseList, IsgCollectionFloat)
  private
    function GetFirst: TsgFloat;
    function GetLast: TsgFloat;
    function GetList: PsgFloatArray;
    function GetItem(const AIndex: Integer): TsgFloat;{$IFDEF USE_INLINE}inline;{$ENDIF}
    procedure SetFirst(const Value: TsgFloat);
    procedure SetLast(const Value: TsgFloat);
    procedure SetItem(const AIndex: Integer; const Item: TsgFloat);{$IFDEF USE_INLINE}inline;{$ENDIF}
  protected
    function GetListType: TsgListType; override;
    procedure SetDefaultCompareProc(var AProc: TsgObjProcCompare); override;
  public
    function Add(const Item: TsgFloat): Integer;
    procedure AppendArray(const NewItems: array of TsgFloat); overload;
    procedure AppendArray(const NewItems: array of TsgFloat; NewItemsAddCount: Integer); overload;
    procedure AssignArray(const NewItems: array of TsgFloat);
    procedure Insert(Index: Integer; const Item: TsgFloat);
    property First: TsgFloat read GetFirst write SetFirst;
    property Items[const AIndex: Integer]: TsgFloat
      read GetItem write SetItem; default;
    property Last : TsgFloat read GetLast  write SetLast ;
    property List: PsgFloatArray read GetList;
  end;

  TsgInt64Array = array[0..MaxInt div SizeOf(Int64) - 1] of Int64;
  PsgInt64Array = ^TsgInt64Array;

  TsgInt64List = class(TsgBaseList, IsgCollectionInt64)
  private
    function GetFirst: Int64;
    function GetLast: Int64;
    function GetList: PsgInt64Array;
    function GetItem(const AIndex: Integer): Int64;{$IFDEF USE_INLINE}inline;{$ENDIF}
    procedure SetFirst(const Value: Int64);
    procedure SetLast(const Value: Int64);
    procedure SetItem(const AIndex: Integer; const Item: Int64);{$IFDEF USE_INLINE}inline;{$ENDIF}
  protected
    procedure FixOldVersion; override;
    function GetListType: TsgListType; override;
    procedure SetDefaultCompareProc(var AProc: TsgObjProcCompare); override;
  public
    function Add(const Item: Int64): Integer;
    procedure AppendArray(const NewItems: array of Int64); overload;
    procedure AppendArray(const NewItems: array of Int64; NewItemsAddCount: Integer); overload;
    procedure AssignArray(const NewItems: array of Int64);
    function IndexOf(const Item: Int64): Integer;
    procedure Insert(Index: Integer; const Item: Int64);
    function Remove(const AItem: Int64): Integer;
    property First: Int64 read GetFirst write SetFirst;
    property Items[const AIndex: Integer]: Int64
      read GetItem write SetItem; default;
    property Last : Int64 read GetLast  write SetLast ;
    property List: PsgInt64Array read GetList;
  end;

  TsgIntegerArray = array[0..MaxInt div SizeOf(Integer) - 1] of Integer;
  PsgIntegerArray = ^TsgIntegerArray;

  TsgIntegerList = class(TsgBaseList, IsgCollectionInt)
  private
    function GetFirst: Integer;
    function GetLast: Integer;
    function GetList: PsgIntegerArray;
    function GetItem(const AIndex: Integer): Integer;{$IFDEF USE_INLINE}inline;{$ENDIF}
    procedure SetFirst(const Value: Integer);
    procedure SetLast(const Value: Integer);
    procedure SetItem(const AIndex: Integer; const Item: Integer);{$IFDEF USE_INLINE}inline;{$ENDIF}
  protected
    function GetListType: TsgListType; override;
    procedure SetDefaultCompareProc(var AProc: TsgObjProcCompare); override;
  public
    function Add(const Item: Integer): Integer;
    procedure AppendConst(ACount, AValue: Integer);
    procedure AppendArray(const NewItems: array of Integer); overload;
    procedure AppendArray(const NewItems: array of Integer; NewItemsAddCount: Integer); overload;
    procedure AssignArray(const NewItems: array of Integer);
    function IndexOf(const Item: Integer): Integer;
    procedure Insert(Index: Integer; const Item: Integer);
    function Remove(const Item: Integer): Integer;
    procedure SetAll(const Item: Integer);
    property First: Integer read GetFirst write SetFirst;
    property Items[const AIndex: Integer]: Integer
      read GetItem write SetItem; default;
    property Last : Integer read GetLast  write SetLast ;
    property List: PsgIntegerArray read GetList;
  end;

  TsgBasePointList = class(TsgBaseList)
  public
    function GetBox: TFRect; virtual;
  end;

  TFPointArray = array[0..MaxInt div SizeOf(TFPoint) - 1] of TFPoint;
  PFPointArray = ^TFPointArray;

  TFPointList = class(TsgBasePointList, IsgCollectionFPoint, IsgArrayFPoint)
  private
    function GetFirst: TFPoint;
    function GetLast: TFPoint;
    function GetList: PFPointArray;
    function GetItem(const AIndex: Integer): TFPoint;{$IFDEF USE_INLINE}inline;{$ENDIF}
    procedure SetFirst(const Value: TFPoint);
    procedure SetLast(const Value: TFPoint);
    procedure SetItem(const AIndex: Integer; const Item: TFPoint);{$IFDEF USE_INLINE}inline;{$ENDIF}
  protected
    function GetFPoint(const AIndex: Integer): TFPoint;
    function GetFPointCount: Integer;
    function GetListType: TsgListType; override;
    procedure SetDefaultCompareProc(var AProc: TsgObjProcCompare); override;
  public
    function Add(const Item: TFPoint): Integer;
    procedure AppendArray(NewItems: IsgArrayFPoint;
      const AFiFo: Boolean = True); overload;
    procedure AppendArray(const NewItems: array of TFPoint); overload;
    procedure AppendArray(const NewItems: array of TFPoint; NewItemsAddCount: Integer); overload;
    procedure AssignArray(const NewItems: array of TFPoint);
    function IndexOf(const AValue: TFPoint): Integer;
    procedure Insert(Index: Integer; const Item: TFPoint);
    function GetNearestIndex(const AValue: TFPoint): Integer;
    function GetBox: TFRect; override;
    procedure GetExtents(var min, max: TFPoint);
    procedure CombineItem(const AIndex: Integer; const AVector: TFPoint;
      const ALen: Double);
    procedure Transform(const AMatrix: TFMatrix);
    procedure SortOnAngle(const ACenter: TFPoint; const AAngle: Double);
    procedure SortOnVector(const AVector: TFPoint);
    property First: TFPoint read GetFirst write SetFirst;
    property Items[const AIndex: Integer]: TFPoint
      read GetItem write SetItem; default;
    property Last : TFPoint read GetLast  write SetLast ;
    property List: PFPointArray read GetList;
  end;

  TF2DPointArray = array[0..MaxInt div SizeOf(TF2DPoint) - 1] of TF2DPoint;
  PF2DPointArray = ^TF2DPointArray;

  TF2DPointList = class(TsgBasePointList, IsgCollectionF2DPoint, IsgArrayFPoint)
  private
    function GetFirst: TF2DPoint;
    function GetLast: TF2DPoint;
    function GetList: PF2DPointArray;
    function GetItem(const AIndex: Integer): TF2DPoint;{$IFDEF USE_INLINE}inline;{$ENDIF}
    procedure SetFirst(const Value: TF2DPoint);
    procedure SetLast(const Value: TF2DPoint);
    procedure SetItem(const AIndex: Integer; const Item: TF2DPoint);{$IFDEF USE_INLINE}inline;{$ENDIF}
  protected
    function GetFPoint(const AIndex: Integer): TFPoint;
    function GetFPointCount: Integer;
    function GetListType: TsgListType; override;
    procedure SetDefaultCompareProc(var AProc: TsgObjProcCompare); override;
  public
    function Add(const Item: TF2DPoint): Integer;
    procedure AppendArray(const NewItems: array of TF2DPoint); overload;
    procedure AppendArray(const NewItems: array of TF2DPoint; NewItemsAddCount: Integer); overload;
    procedure AppendArray(NewItems: IsgArrayFPoint;
      const AFiFo: Boolean = True); overload;
    procedure AssignArray(const NewItems: array of TF2DPoint);
    function IndexOf(const Item: TF2DPoint): Integer;
    procedure Insert(Index: Integer; const Item: TF2DPoint);
    function GetBox: TFRect; override;
    property First: TF2DPoint read GetFirst write SetFirst;
    property Items[const AIndex: Integer]: TF2DPoint
      read GetItem write SetItem; default;
    property Last : TF2DPoint read GetLast  write SetLast ;
    property List: PF2DPointArray read GetList;
  end;

  TF4DPointArray = array[0..MaxInt div SizeOf(TF4DPoint) - 1] of TF4DPoint;
  PF4DPointArray = ^TF4DPointArray;

  TF4DPointList = class(TsgBasePointList, IsgCollectionF4DPoint, IsgArrayFPoint)
  private
    function GetFirst: TF4DPoint;
    function GetLast: TF4DPoint;
    function GetList: PF4DPointArray;
    function GetItem(const AIndex: Integer): TF4DPoint;{$IFDEF USE_INLINE}inline;{$ENDIF}
    procedure SetFirst(const Value: TF4DPoint);
    procedure SetLast(const Value: TF4DPoint);
    procedure SetItem(const AIndex: Integer; const Item: TF4DPoint);{$IFDEF USE_INLINE}inline;{$ENDIF}
  protected
    function GetFPoint(const AIndex: Integer): TFPoint;
    function GetFPointCount: Integer;
    function GetListType: TsgListType; override;
    procedure SetDefaultCompareProc(var AProc: TsgObjProcCompare); override;
  public
    function Add(const Item: TF4DPoint): Integer;
    procedure AppendArray(const NewItems: array of TF4DPoint); overload;
    procedure AppendArray(const NewItems: array of TF4DPoint; NewItemsAddCount: Integer); overload;
    procedure AppendArray(NewItems: IsgArrayFPoint;
      const AFiFo: Boolean = True); overload;
    procedure AssignArray(const NewItems: array of TF4DPoint);
    function IndexOf(const Item: TF4DPoint): Integer;
    procedure Insert(Index: Integer; const Item: TF4DPoint);
    function GetBox: TFRect; override;

    property First: TF4DPoint read GetFirst write SetFirst;
    property Items[const AIndex: Integer]: TF4DPoint read GetItem write SetItem; default;
    property Last : TF4DPoint read GetLast  write SetLast ;
    property List: PF4DPointArray read GetList;
  end;

  TPointerArray = array[0..MaxInt div SizeOf(Pointer) - 1] of Pointer;
  PPointerArray = ^TPointerArray;

  TsgPointerTypeValue = (ptvValue, ptvRecord, ptvObject);

  TsgPointerList = class(TsgBaseList, IsgCollectionPointer, IsgArrayFPoint)
  private
    FFPointProc: TsgObjProcGetFPoint;
    function GetFirst: Pointer;
    function GetFPointProc: TsgObjProcGetFPoint;
    function GetLast: Pointer;
    function GetItem(const AIndex: Integer): Pointer;{$IFDEF USE_INLINE}inline;{$ENDIF}
    procedure SetFirst(const Value: Pointer);
    procedure SetFPointProc(const Value: TsgObjProcGetFPoint);
    procedure SetLast(const Value: Pointer);
    procedure SetItem(const AIndex: Integer; const Item: Pointer);{$IFDEF USE_INLINE}inline;{$ENDIF}
  protected
    function GetFPoint(const AIndex: Integer): TFPoint;
    function GetFPointCount: Integer;
    function GetListType: TsgListType; override;
    procedure SetDefaultCompareProc(var AProc: TsgObjProcCompare); override;
  public
    function Add(const Item: Pointer): Integer;
    procedure AppendArray(const AList: TList);
    procedure ClearTypeList(const ATypeValue: TsgPointerTypeValue;
      const AClearCapacity: Boolean = False; ACallClear: Boolean = True);
    function IndexOf(const Item: Pointer): Integer; virtual;
    procedure Insert(Index: Integer; const Item: Pointer);
    function Remove(const Item: Pointer): Integer; virtual;
    procedure Sort(FirstIndex, LastIndex: Integer;
      CountToUseSimpleSort: Integer = DefaultCountToUseSimpleSort); override;
    property First: Pointer read GetFirst write SetFirst;
    property Items[const AIndex: Integer]: Pointer
      read GetItem write SetItem; default;
    property Last : Pointer read GetLast write SetLast;
    property FPointProc: TsgObjProcGetFPoint read GetFPointProc write SetFPointProc;
  end;

  TsgList = class(TsgPointerList)
  protected
    function ComparePointers(const A, B: Pointer): Integer; override;
    procedure SetDefaultCompareProc(var AProc: TsgObjProcCompare); override;
  public
    constructor Create; override;
  end;

  TsgObjProcListNotify = procedure(Ptr: Pointer; Action: TListNotification) of object;

  TListNotify = class(TsgNotificationList)
  private
    FOnNotify: TsgObjProcListNotify;
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    class function CreateList(const AProc: TsgObjProcListNotify): TList;
    property OnNotify: TsgObjProcListNotify read FOnNotify write FOnNotify;
  end;

  TsgHashItemsArray =  array[0..MaxInt div SizeOf(TsgHashItem) - 1] of TsgHashItem;
  PsgHashItemsArray = ^TsgHashItemsArray;

  TsgCollection = class(TsgBaseList)
  private
    function GetFirst: TsgHashItem;
    function GetLast: TsgHashItem;
    function GetItem(const AIndex: Integer): TsgHashItem;{$IFDEF USE_INLINE}inline;{$ENDIF}
    function GetList: PsgHashItemsArray;{$IFDEF USE_INLINE}inline;{$ENDIF}
  protected
    function GetListType: TsgListType; override;
    procedure SetDefaultCompareProc(var AProc: TsgObjProcCompare); override;
    procedure SetSorted(const Value: Boolean); override;
  public
    constructor Create; override;
    function Add(const Item: TsgHashItem): Integer; overload;
    function Add(const AHashCode: UInt64; const AData: Pointer): Integer; overload;
    class function CalcHash(const AStr: string): UInt64;
    procedure ClearTypeList(const ATypeValue: TsgPointerTypeValue;
      const AClearCapacity: Boolean = False);
    function IndexOf(const AHashCode: UInt64): Integer;
    property First: TsgHashItem read GetFirst;
    property Items[const AIndex: Integer]: TsgHashItem read GetItem; default;
    property Last : TsgHashItem read GetLast;
    property List: PsgHashItemsArray read GetList;
  end;

  TsgHashList = class(TsgInterfacedObject, IsgCollectionPointer)
  private
    FHash: TsgList;
    FObjects: TsgPointerList;
    function AddToHash(const AItem: Pointer; const AIndex: Integer): Boolean;
    procedure RemoveFromHash(const AItem: Pointer);{$IFDEF USE_INLINE}inline;{$ENDIF}
  protected
    function CompareHashs(const A, B: Pointer): Integer;
    function GetCount: Integer;
    function GetDuplicates: TDuplicates;
    function GetFPointProc: TsgObjProcGetFPoint;
    function GetSorted: Boolean;
    function GetItem(const AIndex: Integer): Pointer;
    procedure SetItem(const AIndex: Integer; const Item: Pointer);
    procedure SetDuplicates(const Value: TDuplicates);
    procedure SetFPointProc(const Value: TsgObjProcGetFPoint);
    procedure SetProcCompare(const AValue: TsgObjProcCompare);
    procedure SetSorted(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const Item: Pointer): Integer;
    procedure Clear(ClearCapacity: Boolean = False);
    function CopyFrom(const AList: TObject;
      const AMode: TsgCopyMode = cmCopy): Boolean;
    function CopyTo(const AList: TObject;
      const AMode: TsgCopyMode = cmCopy): Boolean;
    procedure Delete(const AIndex: Integer);
    function Remove(const AValue: Pointer): Integer;
    function IndexOf(const Item: Pointer): Integer;
    property Items[const AIndex: Integer]: Pointer read GetItem; default;
    property Count: Integer read GetCount;
  end;

  PsgUInt64Pair = ^TsgUInt64Pair;
  TsgUInt64Pair = record
    First: UInt64;
    Second: UInt64;
  end;

  TsgActivePairValue = (apFirst, apSecond);

  TsgUInt64Pairs = class
  private
    FPairs: TsgList;
    FActivePairValue: TsgActivePairValue;
    function GetFirst(AIndex: Integer): UInt64;
    function GetSecond(AIndex: Integer): UInt64;
    procedure SetActivePairValue(const Value: TsgActivePairValue);
  protected
    function ComparePairs(const Pair1, Pair2: Pointer): Integer;
    function GetCount: Integer;
    function GetPair(AIndex: Integer): TsgUInt64Pair;
  public
    constructor Create;
    destructor Destroy; override;
    function AddPair(const AFirt, ASecond: UInt64): Integer;
    procedure Clear;
    function IndexOf(const Value: UInt64): Integer;
    property ActivePairValue: TsgActivePairValue read FActivePairValue
      write SetActivePairValue;
    property Count: Integer read GetCount;
    property Pair[AIndex: Integer]: TsgUInt64Pair read GetPair; default;
    property First[AIndex: Integer]: UInt64 read GetFirst;
    property Second[AIndex: Integer]: UInt64 read GetSecond;
  end;

  //This classes is used only as a user interface
  TsgReferenceBase = class(TInterfacedObject, IsgCollectionBase)
  private
    FList: TsgBaseList;
  protected
    procedure Delete(const AIndex: Integer);
    function GetCount: Integer;
  public
    destructor Destroy; override;
  end;

  TsgReferenceSort = class(TsgReferenceBase, IsgCollectionBaseSort)
  protected
    function GetDuplicates: TDuplicates;
    function GetSorted: Boolean;
    procedure SetDuplicates(const Value: TDuplicates);
    procedure SetProcCompare(const AValue: TsgObjProcCompare);
    procedure SetSorted(const Value: Boolean);
  end;

  TsgReferenceList = class(TsgReferenceSort, IsgCollectionPointer, IsgArrayFPoint)
  protected
    function Add(const AValue: Pointer): Integer;
    function GetFPoint(const AIndex: Integer): TFPoint;
    function GetFPointCount: Integer;
    function GetFPointProc: TsgObjProcGetFPoint;
    function GetItem(const AIndex: Integer): Pointer;
    function IndexOf(const AValue: Pointer): Integer;
    function Remove(const AValue: Pointer): Integer;
    procedure SetFPointProc(const Value: TsgObjProcGetFPoint);
    procedure SetItem(const AIndex: Integer; const AValue: Pointer);
  public
    constructor Create;
  end;

  TsgListInterface = class(TInterfacedObject, IsgArrayFPoint)
  private
    FList: TList;
    FProc: TsgProcOfPointerGetPoint;
    FProcObj: TsgObjProcGetFPoint;
    function GetFPointProc(const APointer: Pointer): TFPoint;
  protected
    function GetFPoint(const AIndex: Integer): TFPoint;
    function GetFPointCount: Integer;
  public
    constructor Create(const AList: TList; const AProc: TsgObjProcGetFPoint); overload;
    constructor Create(const AList: TList; const AProc: TsgProcOfPointerGetPoint); overload;
    class function DereferenceType(const AType: Integer): TsgObjProcGetFPoint;
    class function DereferenceToPFPoint(const AValue: Pointer): TFPoint;
    class function DereferenceToPFPoint2D(const AValue: Pointer): TFPoint;
    class function DereferenceToPF2DPoint(const AValue: Pointer): TFPoint;
    class function DereferenceToPPoint(const AValue: Pointer): TFPoint;
  end;

  TsgVariablesMap = class
  private
    FIdents: TStringList;
    FValues: TStringList;
    function GetCaseSensitive: Boolean;
    function GetValue(const AIdent: string): string;
    procedure SetCaseSensitive(const Value: Boolean);
    procedure SetValue(const AIdent: string; const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const AVarName, AValueString: string): Integer;
    function AddObject(const AVarName, AValueString: string; AObject: TObject): Integer;
    procedure Clear(DoFreeObject: Boolean = False);
    property CaseSensitive: Boolean read GetCaseSensitive write SetCaseSensitive;
    property Value[const AIdent: string]: string read GetValue write SetValue;
  end;

  PsgPointFArray = ^TsgPointFArray;
  TsgPointFArray =  array[0 .. MaxInt div SizeOf(TPointF) - 1] of TPointF;

  TsgPointFList = class(TsgBasePointList)
  private
    function GetFirst: TPointF;
    function GetLast: TPointF;
    function GetList: PsgPointFArray;{$IFDEF USE_INLINE}inline;{$ENDIF}
    function GetItem(const AIndex: Integer): TPointF;{$IFDEF USE_INLINE}inline;{$ENDIF}
    procedure SetFirst(const Value: TPointF);
    procedure SetLast(const Value: TPointF);
    procedure SetItem(const AIndex: Integer; const Item: TPointF);{$IFDEF USE_INLINE}inline;{$ENDIF}
  protected
    function GetFPoint(const AIndex: Integer): TFPoint;
    function GetFPointCount: Integer;
    function GetListType: TsgListType; override;
    procedure SetDefaultCompareProc(var AProc: TsgObjProcCompare); override;
  public
    function Add(const Item: TPointF): Integer; overload;
    function Add(X, Y: Single): Integer; overload;
    procedure AppendArray(const NewItems: array of TPointF); overload;
    procedure AppendArray(const NewItems: array of TPointF; NewItemsAddCount: Integer); overload;
    procedure AppendArray(NewItems: IsgArrayFPoint;
      const AFiFo: Boolean = True); overload;
    procedure AssignArray(const NewItems: array of TPointF);
    function IndexOf(const Item: TPointF): Integer;
    procedure Insert(Index: Integer; const Item: TPointF);
    function GetBox: TFRect; override;
    property First: TPointF read GetFirst write SetFirst;
    property Items[const AIndex: Integer]: TPointF
      read GetItem write SetItem; default;
    property Last : TPointF read GetLast  write SetLast;
    property List: PsgPointFArray read GetList;
  end;


function ConverBaseListToList(ASource: IsgArrayFPoint; const ADest: TList;
  const AType: TsgListType): Boolean;
procedure CopyObjList(const ADest: TList; const ASource: TObject);
procedure FreePointerList(var AList; const ATypeValue: TsgPointerTypeValue = ptvValue);
function GetObjListCount(const AObj: TObject): Integer;
function SetObjLists(const AObj: TObject; var AList: TList;
  var APointerList: TsgList): Integer;
procedure ClearCollectionObjectData(ACollection: TsgCollection);
function CreateTsgList: TsgList;
procedure ClearsgList(const AList: TsgList; ClearCapacity: Boolean = True);
procedure FreesgList(var AList: TsgList);

function FPointToStrInternal(const APoint: TFPoint): string;{$IFDEF SG_INLINE}inline;{$ENDIF}

function MakeHashItem(const AHashCode:  Uint64; const AData: Pointer): TsgHashItem;

implementation

uses
{$IFNDEF SG_CADIMPORTERDLLDEMO}
  sgXMLParser,
{$ENDIF}
  sgFunction;

const
  cnstItemSizes: array [TsgListType] of Integer = (SizeOf(Pointer),
    SizeOf(TObject), SizeOf(TFPoint), SizeOf(TF2DPoint), SizeOf(TF4DPoint), SizeOf(Double),
    SizeOf(Single), SizeOf(TsgFloat), SizeOf(Int64), SizeOf(Integer),
    SizeOf(Pointer), SizeOf(TsgHashItem), SizeOf(TPointF));


  cnstXMLListCount = 'Count';
  cnstXMLListItem = 'Item';
  cnstXMLListType = 'Type';
  cnstXMLListTypesName: array[TsgListType] of string =
    ('', '', 'FPoint', 'F2DPoint', 'F4DPoint', 'Double', 'Single',
     'Float', 'Int64', 'Int', 'Pointer', '', 'PointF');

type
  {$IFDEF SGFPC}
  PsgPoint = Types.Point;
  {$ELSE}
  PsgPoint = ^TsgPoint;
  TsgPoint = record
    X: Longint;
    Y: Longint;
  end;
  {$ENDIF}

function ValToStrInternal(const AValue: Double): string;{$IFDEF SG_INLINE}inline;{$ENDIF}
begin
{$IFDEF SG_CADIMPORTERDLLDEMO}
  Result := DoubleToStr(AValue, cnstPoint);
{$ELSE}
  Result := sgXMLParser.ValToStr(AValue);
{$ENDIF}
end;

function FPointToStrInternal(const APoint: TFPoint): string;{$IFDEF SG_INLINE}inline;{$ENDIF}
begin
{$IFDEF SG_CADIMPORTERDLLDEMO}
  Result := FPointToStr(APoint);
{$ELSE}
  Result := sgXMLParser.FPointToStr(APoint);
{$ENDIF}
end;

function StrToValInternal(const AStr: string): Double;{$IFDEF SG_INLINE}inline;{$ENDIF}
{$IFDEF SG_CADIMPORTERDLLDEMO}
var
  vDs: Char;
begin
  vDs := SetDecimalSeparator(cnstPoint);
  try
    Result := StrToFloatDef(AStr, 0);
  finally
    SetDecimalSeparator(vDs);
  end;
{$ELSE}
begin
  Result := sgXMLParser.StrToVal(AStr);
{$ENDIF}
end;

function StrToFPointInternal(const AStr: string): TFPoint;{$IFDEF SG_INLINE}inline;{$ENDIF}
{$IFDEF SG_CADIMPORTERDLLDEMO}
var
  Spliter: TsgStringList;
begin
  Result := cnstFPointZero;
  Spliter := TsgStringList.Create;
  try
  StrToStrings(AStr, cnstComma, Spliter);
  if Spliter.Count > 0 then
  begin
    Result.X := StrToValInternal(Spliter[0]);
    if Spliter.Count > 1 then
    begin
      Result.Y := StrToValInternal(Spliter[1]);
      if Spliter.Count > 2 then
        Result.Z := StrToValInternal(Spliter[2]);
    end;
  end;
  finally
    Spliter.Free;
  end;
{$ELSE}
begin
  Result := sgXMLParser.StrToFPoint(AStr);
{$ENDIF}
end;

function MakeHashItem(const AHashCode:  Uint64; const AData: Pointer): TsgHashItem;
begin
  Result.HashCode := AHashCode;
  Result.Data := AData;
end;

function ConverBaseListToList(ASource: IsgArrayFPoint; const ADest: TList;
  const AType: TsgListType): Boolean;
var
  vPoint2D: PF2DPoint;
  vPoint3D: PFPoint;
  I: Integer;
begin
  Result := False;
  if not (AType in [ltFPoint, ltF2DPoint]) then
    Exit;
  if ASource.GetFPointCount > 0 then
  begin
    Result := True;
    ADest.Count := 0;
    for I := 0 to ASource.GetFPointCount -1 do
    begin
      case AType of
        ltFPoint:
          begin
            New(vPoint3D);
            vPoint3D^ := ASource.FPoints[I];
            ADest.Add(vPoint3D);
          end;
        ltF2DPoint:
          begin
            New(vPoint2D);
            vPoint2D^.X := ASource.FPoints[I].X;
            vPoint2D^.Y := ASource.FPoints[I].Y;
            ADest.Add(vPoint2D);
          end;
      end;
    end;
  end;
end;

procedure CopyObjList(const ADest: TList; const ASource: TObject);
var
  vList: TList;
  vPointerList: TsgList;
begin
  case SetObjLists(ASource, vList, vPointerList) of
    1:  CopyLists(ADest, vList);
    2:  vPointerList.CopyTo(ADest);
  end;
end;

function CreateTsgList: TsgList;
begin
  Result := TsgList.Create;
  Result.Sorted := False;
  Result.Duplicates := dupIgnore;
end;

procedure ClearsgList(const AList: TsgList; ClearCapacity: Boolean = True);
var
  I: Integer;
begin
  if AList = nil then
    Exit;
  for I := 0 to AList.Count - 1 do
    TObject(PPointerArray(AList.FRawData)[I]).Free;
  if ClearCapacity then
    AList.Clear
  else
    AList.Count := 0;
end;

procedure FreesgList(var AList: TsgList);
begin
  if AList <> nil then
  begin
    ClearsgList(AList);
    FreeAndNil(AList)
  end;
end;

procedure FreePointerList(var AList;
  const ATypeValue: TsgPointerTypeValue = ptvValue);
var
  vList: TsgPointerList absolute AList;
begin
  if vList <> nil then
  begin
    vList.ClearTypeList(ATypeValue, True);
    vList.Free;
    vList := nil;
  end;
end;

function GetObjListCount(const AObj: TObject): Integer;
begin
  if AObj is TList then
    Result := TList(AObj).Count
  else
    if AObj is TsgBaseList  then
      Result := TsgBaseList(AObj).Count
    else
      Result := 0;
end;

function SetObjLists(const AObj: TObject; var AList: TList;
  var APointerList: TsgList): Integer;
begin
  Result := 0;
  AList := nil;
  APointerList := nil;
  if AObj is TList then
  begin
    AList := TList(AObj);
    Result := 1;
  end
  else
    if AObj is TsgList then
    begin
      APointerList := TsgList(AObj);
      Result := 2;
    end;
end;

function GetMem(Size: Integer): Pointer;
begin
{$IFDEF _FIXINSIGHT_}
  FillChar(Result, SizeOf(Result), 0);
{$ENDIF}
  System.GetMem(Result, Size)
end;

function ItemToStr(const AType: TsgListType; const AItem: Pointer): string;
var
  vValue: PPointer absolute AItem;
  vFPoint: PFPoint absolute vValue;
  vF2DPoint: PF2DPoint absolute vValue;
  vDouble: PDouble absolute vValue;
  vSingle: PSingle absolute vValue;
  vFloat: PsgFloat absolute vValue;
  vInt64: PInt64 absolute vValue;
  vInteger: PInteger absolute vValue;
begin
  case AType of
    ltFPoint:    Result := FPointToStrInternal(vFPoint^); //FPointToStr(vFPoint^);
    ltF2DPoint:  Result := FPointToStrInternal(MakeFPointFrom2D(vF2DPoint^));
    ltDouble:    Result := ValToStrInternal(vDouble^);
    ltSingle:    Result := ValToStrInternal(vSingle^);
    ltFloat:     Result := ValToStrInternal(vFloat^);
    ltInt64:     Result := IntToStr(vInt64^);
    ltInteger:   Result := IntToStr(vInteger^);
  else
    Result := IntToHex({$IFDEF SG_CPUX64}Int64{$ELSE}Integer{$ENDIF}(vValue^), 0);
  end;
end;

procedure ItemFromStr(const AType: TsgListType; const AItem: Pointer;
  const AStr: string);
var
  vValue: PPointer absolute AItem;
  vFPoint: PFPoint absolute vValue;
  vF2DPoint: PF2DPoint absolute vValue;
  vDouble: PDouble absolute vValue;
  vSingle: PSingle absolute vValue;
  vFloat: PsgFloat absolute vValue;
  vInt64: PInt64 absolute vValue;
  vInteger: PInteger absolute vValue;
begin
  case AType of
    ltFPoint:    vFPoint^ := StrToFPointInternal(AStr);
    ltF2DPoint:  vF2DPoint^ := MakeF2DPointFrom3D(StrToFPointInternal(AStr));
    ltDouble:    vDouble^ := StrToValInternal(AStr);
    ltSingle:    vSingle^ := StrToValInternal(AStr);
    ltFloat:     vFloat^ := StrToValInternal(AStr);
    ltInt64:     vInt64^ := StrToInt64Def(AStr, 0);
    ltInteger:   vInteger^ := StrToIntDef(AStr, 0);
  else
    vValue^ := Pointer({$IFDEF SG_CPUX64}StrToInt64Def{$ELSE}
      StrToIntDef{$ENDIF}('$' + AStr, 0));
  end;
end;

procedure MinToFirstArgument(var A: Int64; const B: Int64); overload;
begin
  if B < A then A := B;
end;

procedure MinToFirstArgument(var A: Integer; const B: Integer); overload;
begin
  if B < A then A := B;
end;

procedure MinToFirstArgument(var A: Cardinal; const B: Cardinal); overload;
begin
  if B < A then A := B;
end;

procedure MinToFirstArgument(var A: Single; const B: Single); overload;
begin
  if B < A then A := B;
end;

procedure MinToFirstArgument(var A: Double; const B: Double); overload;
begin
  if B < A then A := B;
end;

function PointerAdd(APointer: Pointer; Add: Integer): Pointer;{$IFDEF USE_INLINE}inline;{$ENDIF}
begin
  Result := Pointer(TsgNativePointer(APointer) + TsgNativePointer(Add));
end;

procedure SortByObject(Arr: Pointer; ArrRecordSize: Cardinal; ArrStride: Integer;
  IsSmallerFunc: TsgObjProcCompare; FirstIndex, LastIndex: Integer;
  CountToUseSimpleSort: Integer);

  procedure SimpleSort(L: Pointer; LIndex: Integer; R: Pointer; RIndex: Integer);
  var
    NowIndex: Integer;
    MinPtr, NowPtr, Temp: Pointer;
    NowPtrInt: TsgNativePointer absolute NowPtr;
    LInt: TsgNativePointer absolute L;
  begin
    Temp := GetMem(ArrRecordSize);
    try
      while LIndex < RIndex do
      begin
         MinPtr := L;
         NowPtr := L;
         NowIndex := LIndex + 1;
         while NowIndex <= RIndex do
         begin
           NowPtrInt := NowPtrInt + ArrStride;
           if IsSmallerFunc(NowPtr, MinPtr) < 0 then
             MinPtr := NowPtr;
           Inc(NowIndex);
         end;

         Move(L^, Temp^, ArrRecordSize);
         Move(MinPtr^, L^, ArrRecordSize);
         Move(Temp^, MinPtr^, ArrRecordSize);

         LInt := LInt + ArrStride;
         Inc(LIndex);
      end;
    finally
      FreeMem(Temp)
    end;
  end;

  procedure InternalSort(L: Pointer; LIndex: Integer; R: Pointer; RIndex: Integer);
  var
    I, J: Pointer;
    IInt: TsgNativePointer absolute I;
    JInt: TsgNativePointer absolute J;
    IIndex, JIndex: Integer;
    Temp, Middle: Pointer;
  begin
    if LIndex >= RIndex then Exit;

    if RIndex - LIndex <= CountToUseSimpleSort - 1 then
    begin
      SimpleSort(L, LIndex, R, RIndex);
      Exit;
    end;

    I := L;
    IIndex := LIndex;
    J := R;
    JIndex := RIndex;

    Middle := nil;
    Temp := nil;
    try
      Middle := GetMem(ArrRecordSize);
      Move(PointerAdd(Arr, ((LIndex + RIndex) div 2) * ArrStride)^,
        Middle^, ArrRecordSize);
      Temp := GetMem(ArrRecordSize);
      repeat
        while IsSmallerFunc(I, Middle) < 0 do
        begin
          IInt := IInt + ArrStride;
          Inc(IIndex);
        end;

        while IsSmallerFunc(Middle, J) < 0 do
        begin
          JInt := JInt - ArrStride;
          Dec(JIndex);
        end;

        if IIndex <= JIndex then
        begin
          Move(I^, Temp^, ArrRecordSize);
          Move(J^, I^, ArrRecordSize);
          Move(Temp^, J^, ArrRecordSize);

          IInt := IInt + ArrStride;
          Inc(IIndex);

          JInt := JInt - ArrStride;
          Dec(JIndex);
        end;
      until IIndex > JIndex;

    finally
      FreeMem(Temp);
      FreeMem(Middle);
    end;

    InternalSort(L, LIndex, J, JIndex);
    InternalSort(I, IIndex, R, RIndex);
  end;
begin
  InternalSort(PointerAdd(Arr, FirstIndex * ArrStride), FirstIndex,
    PointerAdd(Arr, LastIndex  * ArrStride), LastIndex);
end;

procedure ClearCollectionObjectData(ACollection: TsgCollection);
var
  I: Integer;
begin
  if Assigned(ACollection) then
  begin
    I := ACollection.High;
    while I >= 0 do
    begin
      FreeAndNil(TObject(ACollection.List^[I].Data));
      ACollection.Delete(I);
      Dec(I);
    end;
  end;
end;

{ TsgInterfacedObject }
{$IFDEF SGFPC}
function TsgInterfacedObject.QueryInterface({$IFDEF FPC_HAS_CONSTREF}constref{$ELSE}const{$ENDIF} iid : tguid;out obj) : longint;{$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
{$ELSE}
function TsgInterfacedObject.QueryInterface(const IID: TGUID; out Obj): HResult;
{$ENDIF}
const
  E_NOINTERFACE = HResult($80004002);
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TsgInterfacedObject._AddRef: Integer;
begin
  Result := -1;
end;

function TsgInterfacedObject._Release: Integer;
begin
  Result := -1;
end;

{TsgContainerList}
constructor TsgThreadContainerList.Create;
begin
{$IFDEF SG_OPENING_IN_THEADS}
  FList := TThreadList.Create;
{$ELSE}
  FList := TList.Create;
{$ENDIF};
end;

destructor TsgThreadContainerList.Destroy;
begin
  FList.Clear;
  FList.Free;
  inherited;
end;

function TsgThreadContainerList.LockList: TList;
begin
{$IFDEF SG_OPENING_IN_THEADS}
  Result := FList.LockList;
{$ELSE}
  Result := FList;
{$ENDIF}
end;

procedure TsgThreadContainerList.UnlockList;
begin
{$IFDEF SG_OPENING_IN_THEADS}
  FList.UnLockList;
{$ELSE}
{$IFDEF _FIXINSIGHT_}
  sgNOP;
{$ENDIF}
{$ENDIF}
end;

{TsgBaseList}

procedure TsgBaseList.Attach(const AData: Pointer; const ACount: Integer);
begin
  FRawData := AData;
  FCount := ACount;
end;

procedure TsgBaseList.Clear(ClearCapacity: Boolean = False);
begin
  Count := 0;
  if ClearCapacity then
    Capacity := 0;
end;

constructor TsgBaseList.Create(const Source: TsgBaseList);
begin
  Create;
  Assign(Source);
end;

constructor TsgBaseList.Create(const InitialCount: Integer;
  const Capacity: Integer = cnstDefaultCapacity);
  function Max(const AValue1, AValue2: Integer): Integer;
  begin
    if AValue1 > AValue2 then
      Result := AValue1
    else
      Result := AValue2;
  end;
begin
  Create;
  SetCapacity(Max(InitialCount, Capacity));
  SetCount(InitialCount);
  FixOldVersion;
end;

procedure TsgBaseList.CyclicShiftLeft(const AValue: Integer);
var
  vTempRawData: Pointer;
  vCount: Integer;
  P1: PPointer;
begin
  vCount := AValue mod Count;
  if AValue < 0 then
    Exit;
  vTempRawData := nil;
  ReallocMem(vTempRawData, vCount * FItemSize);
  P1 := GetItemBase(Count - vCount);
  System.Move(P1^, PPointer(vTempRawData)^, vCount * FItemSize);
  P1 := GetItemBase(vCount);
  System.Move(PPointer(FRawData)^, P1^, (Count  - vCount) * FItemSize);
  System.Move(PPointer(vTempRawData)^, PPointer(FRawData)^,  vCount * FItemSize);
  FreeMemAndNil(vTempRawData);
end;

procedure TsgBaseList.CyclicShiftRight(const AValue: Integer);
begin
  CyclicShiftLeft(Count - AValue);
end;

constructor TsgBaseList.Create;
begin
  inherited Create;
  FDuplicates := dupAccept;
  FItemSize := GetItemSize;
  SetDefaultCompareProc(FSortSmallerFunc);
end;

procedure TsgBaseList.Delete(const AIndex: Integer);
begin
  Delete(AIndex, 1);
end;

procedure TsgBaseList.Delete(const Index: Integer; DelCount: Integer);
var
  I: Integer;
  P1, P2: PPointer;
begin
  if Index >= Count then
    Exit;
  MinToFirstArgument(DelCount, Count - Index);
  for I := Index to Count - 1 - DelCount do
  begin
    P1 := GetItemBase(I + DelCount);
    P2 := GetItemBase(I);
    System.Move(P1^, P2^, FItemSize);
  end;
  SetCountNoInitFini(Count - DelCount);
end;

destructor TsgBaseList.Destroy;
begin
  SetCount(0);
  FreeMemAndNil(FRawData);
  inherited Destroy;
end;

function TsgBaseList.High: Integer;
begin
  Result := FCount - 1;
end;

procedure TsgBaseList.SetCountNoInitFini(NewCount: Integer);
var
  vDelta: Integer;
begin
  if NewCount > Count then
  begin
    if NewCount > FCapacity then
    begin
      if NewCount > 64 then
        vDelta := NewCount div 4
      else
        if NewCount > 8 then
          vDelta := 16
        else
          vDelta := 4;
      SetCapacity(NewCount + vDelta);
    end;
  end;
  FCount := NewCount;
end;

procedure TsgBaseList.SetDefaultCompareProc(var AProc: sgConsts.TsgObjProcCompare);
begin
  AProc := TsgTypeComparer.CmpPointer;
end;

procedure TsgBaseList.SetDuplicates(const Value: TDuplicates);
begin
  FDuplicates := Value;
end;

procedure TsgBaseList.SetProcCompare(const AValue: sgConsts.TsgObjProcCompare);
begin
  if Assigned(AValue) then
    FSortSmallerFunc := AValue
  else
    SetDefaultCompareProc(FSortSmallerFunc);
end;

procedure TsgBaseList.SetSorted(const Value: Boolean);
begin
  if FSorted <> Value then
  begin
    if Value then
      Sort;
    FSorted := Value;
  end;
end;

procedure TsgBaseList.Sort(CountToUseSimpleSort: Integer);
begin
  Sort(0, High, CountToUseSimpleSort);
end;

procedure TsgBaseList.Sort(FirstIndex, LastIndex,
  CountToUseSimpleSort: Integer);
begin
  SortByObject(FRawData, FItemSize, FItemSize, ComparePointers,
    FirstIndex, LastIndex, CountToUseSimpleSort);
end;

procedure TsgBaseList.SetCount(NewCount: Integer);
begin
  SetCountNoInitFini(NewCount);
end;

procedure TsgBaseList.IncCount;
begin
  ChangeCount(1)
end;

function TsgBaseList.IndexOfBase(const AItem: Pointer): Integer;
begin
  if not FindBase(AItem, Result) then
    Result := -1;
end;

procedure TsgBaseList.InsertBase(const AIndex: Integer;
  const AItem: Pointer);
var
  I: Integer;
  P1, P2: PPointer;
begin
  FSorted := False;
  IncCount;
  for I := High downto AIndex + 1 do
  begin
    P1 := GetItemBase(I);
    P2 := GetItemBase(I - 1);
    System.Move(P2^, P1^, FItemSize);
  end;
  P1 := GetItemBase(AIndex);
  System.Move(PPointer(AItem)^, P1^, FItemSize);
end;

function TsgBaseList.IsEqual(const AList: TsgBaseList;
  Compare: sgConsts.TsgObjProcCompare = nil): Boolean;
var
  I: Integer;
begin
  Result := False;
  if (AList <> nil) and (Count = AList.Count) and (ListType = AList.ListType) then
  begin
    if not Assigned(Compare) then
      Compare := ComparePointers;
    I := 0;
    while (I < Count) and (Compare(GetItemBase(I), AList.GetItemBase(I)) <> 0) do
      Inc(I);
    Result := I = Count;
  end
end;

function TsgBaseList.IsItemsUnique: Boolean;
var
  I, J: Integer;
  P1, P2: Pointer;
begin
  Result := True;
  for I := 0 to Count - 2 do
  begin
    P1 := GetItemBase(I);
    for J := I + 1 to Count - 1 do
    begin
      P2 := GetItemBase(J);
      if not CompareMem(P1, P2, FItemSize) then
      begin
        Result := False;
        Break;
      end;
    end;
    if not Result then
      Break;
  end;
end;

function TsgBaseList.RemoveBase(const AItem: Pointer): Integer;
begin
  if FindBase(AItem, Result) then
    Delete(Result)
  else
    Result := -1;
end;

procedure TsgBaseList.SetCapacity(const Value: Integer);
begin
  ReallocMem(FRawData, Value * FItemSize);
  if FCapacity < Value then
     System.FillChar(PByte(TsgNativeUInt(FRawData)+ TsgNativeUInt(FItemSize * FCapacity))^,
       FItemSize * (Value - FCapacity), 0);
  FCapacity := Value;
  if FCount > Capacity then
    FCount := Value;
end;

function TsgBaseList.AddBase(const AItem: Pointer): Integer;
var
  P: PPointer;
begin
  if Sorted then
  begin
    if FindBase(AItem, Result) then
    begin
      case Duplicates of
        dupIgnore: Exit;
        dupError:  Exit;//Error(@SDuplicateItem, 0);
      end;
    end;
    InsertBase(Result, AItem);
    FSorted := True;
  end
  else
  begin
    if (Duplicates <> dupIgnore) or (IndexOfBase(AItem) < 0) then
    begin
      Result := Count;
      IncCount;
      P := GetItemBase(Result);
      System.Move(PPointer(AItem)^, P^, FItemSize);
    end
    else
      Result := -1;
  end;
end;

procedure TsgBaseList.AppendArrayBase(NewItems: Pointer;
  NewItemsAddCount: Integer);
var
  OldCount: Integer;
  P1: PPointer;
begin
  if Sorted then Exit;
  OldCount := Count;
  SetCount(Count + NewItemsAddCount);
  P1 := GetItemBase(OldCount);
  System.Move(PPointer(NewItems)^, P1^, NewItemsAddCount * FItemSize);
end;

procedure TsgBaseList.AppendDynArray(Arr: TsgBaseList);
begin
  if ListType = Arr.ListType then
    AppendArrayBase(Arr.FRawData, Arr.Count);
end;

procedure TsgBaseList.AppendDynArray(Arr: TsgBaseList; Index, ACount: Integer);
begin
  if ListType = Arr.ListType then
    AppendArrayBase(Arr.GetItemBase(Index), ACount);
end;

procedure TsgBaseList.Assign(Source: TsgBaseList);
begin
  if ListType = Source.ListType then
  begin
    Count := Source.Count;
    Sorted := Source.Sorted;
    Duplicates := Source.Duplicates;
    System.Move(PPointer(Source.FRawData)^, PPointer(FRawData)^, Count * FItemSize);
  end;
end;

procedure TsgBaseList.ChangeCount(CountChange: Integer);
begin
  SetCount(Count + CountChange)
end;

function TsgBaseList.ComparePointers(const A, B: Pointer): Integer;
begin
  Result := FSortSmallerFunc(A, B);
end;

function TsgBaseList.CopyFrom(const AList: TList;
  const AMode: TsgCopyMode): Boolean;
var
  vCount: Integer;
  vDetination: PPointer;
begin
  Result := False;
  if FItemSize <> SizeOf(Pointer) then
    Exit;
  case AMode of
    cmAppend:
      begin
        vCount := Count;
        Count := Count + AList.Count;
        vDetination := GetItemBase(vCount);
      end
  else
    Count := AList.Count;
    vDetination := FRawData;
  end;
  if (FRawData <> nil) and (AList.Count > 0) then
  begin
    System.Move(AList.List[0], vDetination^, AList.Count * FItemSize);
    Result := True;
    if Sorted then
      Sort;
  end;
end;

function TsgBaseList.CopyTo(const AList: TList;
  const AMode: TsgCopyMode): Boolean;
var
  vIndex: Integer;
begin
  Result := False;
  if FItemSize <> SizeOf(Pointer) then
    Exit;
  case AMode of
    cmAppend:
      begin
        vIndex := AList.Count;
        AList.Count := AList.Count + Count;
      end
  else
    vIndex := 0;
    AList.Count := Count;
  end;
  if (FRawData <> nil) and (Count > 0) then
  begin
    System.Move(PPointer(FRawData)^, AList.List[vIndex], Count * FItemSize);
    Result := True;
  end;
end;

procedure TsgBaseList.SwapItems(Index1, Index2: Integer;
  const ASwapItemsBuf: Pointer = nil);
var
  P1, P2: PByte;
  vSwapItemsBuf: Pointer;
begin
  vSwapItemsBuf := ASwapItemsBuf;
  if vSwapItemsBuf = nil then
    vSwapItemsBuf := GetMem(FItemSize);
  try
    P1 := PByte(TsgNativeUInt(FRawData) + TsgNativeUInt(Index1 * FItemSize));
    P2 := PByte(TsgNativeUInt(FRawData) + TsgNativeUInt(Index2 * FItemSize));
    Move(p1^, vSwapItemsBuf^, FItemSize);
    Move(p2^, p1^, FItemSize);
    Move(vSwapItemsBuf^, p2^, FItemSize);
  finally
    if vSwapItemsBuf <> ASwapItemsBuf then
      FreeMemAndNil(vSwapItemsBuf);
  end;
end;

procedure TsgBaseList.FillChar(FillValue: Byte);
begin
 System.FillChar(FRawData^, FItemSize * Count, FillValue);
end;

function TsgBaseList.FindBase(const AItem: Pointer; var AIndex: Integer): Boolean;
var
  L, H, I, C: Integer;
begin
  Result := False;
  H := Count - 1;
  if FSorted then
  begin
    L := 0;
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := ComparePointers(GetItemBase(I), AItem);
      if C < 0 then
        L := I + 1
      else
      begin
        H := I - 1;
        if C = 0 then
        begin
          Result := True;
          if Duplicates <> dupAccept then
            L := I;
        end;
      end;
    end;
    AIndex := L;
  end
  else
  begin
    AIndex := 0;
    while (AIndex <= H) and (ComparePointers(GetItemBase(AIndex), AItem) <> 0) do
      Inc(AIndex);
    if AIndex <= H  then
      Result := True;
  end;
end;

procedure TsgBaseList.FixOldVersion;
begin
end;

procedure TsgBaseList.Flip;
var
  I: Integer;
  vSwapItemsBuf: Pointer;
begin
 if Count = 0 then
   Exit;
  vSwapItemsBuf := GetMem(FItemSize);
  try
    for I := 0 to (Count - 1) div 2 do
      SwapItems(I, Count - 1 - I, vSwapItemsBuf);
  finally
    FreeMemAndNil(vSwapItemsBuf);
  end;
end;

function TsgBaseList.FromStr(const AValue: string): Integer;
var
  I: Integer;
  vListType: TsgListType;
  vValues: TsgStringList;
begin
  Result := 0;
  vListType := ListType;
  vValues := TsgStringList.Create;
  try
    vValues.LineBreak := cnstXMLValuesSeparator;
    vValues.Text := AValue;
    Count := vValues.Count;
    for I := 0 to vValues.Count - 1 do
    begin
      ItemFromStr(vListType, GetItemBase(I), vValues[I]);
      Inc(Result);//check exception
    end;
  finally
    vValues.Free;
  end;
end;

{$IFNDEF SG_CADIMPORTERDLLDEMO}
function TsgBaseList.FromXML(const ANode: TObject): Boolean;
var
  vNode: TsgNodeSample absolute ANode;
  vNodeListType, vNodeCount, vNodeItem, vNodeValues: TsgNodeSample;
  vListType: TsgListType;
  I: Integer;
  vValue: Pointer;
  vFPoint: TFPoint absolute vValue;
  vF2DPoint: TF2DPoint absolute vValue;
  vDouble: Double absolute vValue;
  vSingle: Single absolute vValue;
  vFloat: TsgFloat absolute vValue;
  vInt64: Int64 absolute vValue;
  vInteger: Integer absolute vValue;
begin
  Result := False;
  vListType := ListType;
  if (cnstXMLListTypesName[vListType] <> '') and (ANode is TsgNodeSample) then
  begin
    vNodeListType := vNode.GetAttributeByName(cnstXMLListType);
    if Assigned(vNodeListType) then
      Result := SameText(vNodeListType.ValueAsStr, cnstXMLListTypesName[vListType])
    else
      Result := True;
    if Result then
    begin
      Count := 0;
      vNodeCount := vNode.GetAttributeByName(cnstXMLListCount);
      if Assigned(vNodeCount) then
        Capacity := vNodeCount.ValueAsInt
      else
        Capacity := vNode.ChildNodesCount;
      vNodeValues := vNode.GetAttributeByName(cnstXMLValues);
      if Assigned(vNodeValues) then
        FromStr(vNodeValues.ValueAsStr);
      for I := 0 to vNode.ChildNodesCount - 1 do
      begin
        vNodeItem := vNode.ChildNodes[I].AttributeNodes[0];
        case vListType of
          ltFPoint:    vFPoint := vNodeItem.ValueAsFPoint;
          ltF2DPoint:  vF2DPoint := vNodeItem.ValueData.ValueAsF2DPoint;
          ltDouble:    vDouble := vNodeItem.ValueAsDouble;
          ltSingle:    vSingle := vNodeItem.ValueData.ValueAsSingle;
          ltFloat:     vFloat := vNodeItem.ValueAsDouble;
          ltInt64:     vInt64 := vNodeItem.ValueAsInt64;
          ltInteger:   vInteger := vNodeItem.ValueAsInt;
        else
          vValue := vNodeItem.ValueAsPointer;
        end;
        AddBase(@vValue);
      end;
    end;
  end;
end;

function TsgBaseList.ToXML(const ANode: TObject; AItemName: string = ''): Boolean;
var
  vNode: TsgNode absolute ANode;
  vListType: TsgListType;
{$IFNDEF SG_XML_LISTVALUES_AS_ATTRIBUTE}
  vNodeItem: TsgNodeSample;
  I: Integer;
  vValue: PPointer;
  vFPoint: PFPoint absolute vValue;
  vF2DPoint: PF2DPoint absolute vValue;
  vDouble: PDouble absolute vValue;
  vSingle: PSingle absolute vValue;
  vFloat: PsgFloat absolute vValue;
  vInt64: PInt64 absolute vValue;
  vInteger: PInteger absolute vValue;
{$ENDIF}
begin
  Result := False;
  vListType := ListType;
  if (cnstXMLListTypesName[vListType] <> '') and (ANode is TsgNode) then
  begin
    if Length(AItemName) < 1 then
      AItemName := cnstXMLListItem;
    vNode.AddAttribNV(cnstXMLListType).ValueAsStr := cnstXMLListTypesName[vListType];
    vNode.AddAttribNV(cnstXMLListCount).ValueAsInt := Count;
{$IFDEF SG_XML_LISTVALUES_AS_ATTRIBUTE}
    vNode.AddAttribNV(cnstXMLValues).ValueAsStr := ToStr;
{$ELSE}
    for I := 0 to Count - 1 do
    begin
      vNodeItem := vNode.AddChildNV(AItemName).AddAttribNV(cnstXMLValue);
      vValue := GetItemBase(I);
      case vListType of
        ltFPoint:    vNodeItem.ValueAsFPoint := vFPoint^;
        ltF2DPoint:  vNodeItem.ValueData.ValueAsF2DPoint := vF2DPoint^;
        ltDouble:    vNodeItem.ValueAsDouble := vDouble^;
        ltSingle:    vNodeItem.ValueData.ValueAsSingle := vSingle^;
        ltFloat:     vNodeItem.ValueAsDouble := vFloat^;
        ltInt64:     vNodeItem.ValueAsInt64 := vInt64^;
        ltInteger:   vNodeItem.ValueAsInt := vInteger^;
      else
        vNodeItem.ValueAsPointer := vValue^;
      end;
    end;
{$ENDIF}
    Result := True;
  end;
end;
{$ENDIF}

function TsgBaseList.ToStr: string;
var
  I: Integer;
  vItem: string;
  vListType: TsgListType;
begin
  Result := '';
  vListType := ListType;
  if Count > 0 then
  begin
    Result := ItemToStr(vListType, GetItemBase(0));
    for I := 1 to Count - 1 do
    begin
      vItem := cnstXMLValuesSeparator + ItemToStr(vListType, GetItemBase(I));
      Result := Result + vItem;
    end;
  end;
end;

function TsgBaseList.GetListType: TsgListType;
begin
  Result := ltNil;
end;

function TsgBaseList.GetNearestIndexBase(const AItem: Pointer;
  const ANearestValue: TsgObjProcNearestCompare): Integer;
var
  L, H, I: Integer;
  vDistance, vDistance2, vDistanceMin: Extended;
begin
  Result := -1;
  H := Count - 1;
  if (H < 0) or not Assigned(ANearestValue) then
    Exit;
  Result := 0;
  vDistanceMin := ANearestValue(GetItemBase(0), AItem);
  if vDistanceMin = 0 then
    Exit
  else
  begin
    if vDistanceMin < 0 then
    begin
      Result := -1;
      Exit;
    end;
  end;
  if FSorted then
  begin
    L := 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      vDistance := ANearestValue(GetItemBase(I), AItem);
      vDistance2 := ANearestValue(GetItemBase(I-1), AItem);
      if vDistance > vDistanceMin then
        H := I - 1
      else
      begin
        if vDistance2 < vDistance then
          H := I - 1
        else
        begin
          Result := I;
          if vDistance = vDistanceMin then
            Break
          else
          begin
            vDistanceMin := vDistance;
            L := I + 1;
          end;
        end;
      end;
    end;
  end
  else
  begin
    for I := 1 to H do
    begin
      vDistance := ANearestValue(GetItemBase(I), AItem);
      if vDistanceMin > vDistance then
      begin
        vDistanceMin := vDistance;
        Result := I;
        if vDistanceMin = 0 then
          Break;
      end;
    end;
  end;
end;

function TsgBaseList.GetProcCompare: sgConsts.TsgObjProcCompare;
begin
  Result := FSortSmallerFunc;
end;

function TsgBaseList.GetSorted: Boolean;
begin
  Result := FSorted;
end;

function TsgBaseList.GetCount: Integer;
begin
  Result := FCount;
end;

function TsgBaseList.GetDuplicates: TDuplicates;
begin
  Result := FDuplicates;
end;

function TsgBaseList.GetItemBase(const AIndex: Integer): Pointer;
begin
  Result := PointerAdd(FRawData, FItemSize * AIndex);
end;

function TsgBaseList.GetItemSize: Integer;
begin
  Result := cnstItemSizes[GetListType];
end;

{TsgSingleList}

function TsgSingleList.Add(const Item: Single): Integer;
begin
  Result := AddBase(@Item);
end;

procedure TsgSingleList.AppendArray(const NewItems: array of Single;
  NewItemsAddCount: Integer);
begin
  AppendArrayBase(@NewItems[0], NewItemsAddCount);
end;

procedure TsgSingleList.AppendConst(ACount: Integer; AValue: Single);
begin
  while ACount > 0 do
  begin
    Add(AValue);
    Dec(ACount);
  end;
end;

function TsgSingleList.GetItem(const AIndex: Integer): Single;
begin
  Result := PsgSingleArray(FRawData)[AIndex];
end;

procedure TsgSingleList.SetItem(const AIndex: Integer; const Item: Single);
begin
  if Sorted then Exit;
  PsgSingleArray(FRawData)[AIndex] := Item;
end;

procedure TsgSingleList.AppendArray(const NewItems: array of Single);
begin
  AppendArray(NewItems, System.High(NewItems)+1);
end;

procedure TsgSingleList.AssignArray(const NewItems: array of Single);
begin
  Count := 0;
  AppendArray(NewItems);
end;

procedure TsgSingleList.Insert(Index: Integer; const Item: Single);
begin
  InsertBase(Index, @Item);
end;

function TsgSingleList.GetFirst: Single;
begin
  Result := GetItem(0);
end;

function TsgSingleList.GetLast: Single;
begin
  Result := GetItem(Count - 1);
end;

function TsgSingleList.GetList: PsgSingleArray;
begin
  Result := PsgSingleArray(FRawData);
end;

function TsgSingleList.GetListType: TsgListType;
begin
  Result := ltSingle;
end;

procedure TsgSingleList.SetDefaultCompareProc(
  var AProc: sgConsts.TsgObjProcCompare);
begin
  AProc := TsgPointerTypeComparer.CmpSingle;
end;

procedure TsgSingleList.SetFirst(const Value: Single);
begin
  if Sorted then Exit;
  SetItem(0, Value);
end;

procedure TsgSingleList.SetLast(const Value: Single);
begin
  if Sorted then Exit;
  SetItem(Count - 1, Value);
end;

function TsgSingleList.IndexOf(const Item: Single): Integer;
begin
  Result := IndexOfBase(@Item);
end;

{TsgDoubleList}

function TsgDoubleList.GetItem(const AIndex: Integer): Double;
begin
  Result := PsgDoubleArray(FRawData)[AIndex];
end;

procedure TsgDoubleList.SetItem(const AIndex: Integer; const Item: Double);
begin
  if Sorted then Exit;
  PsgDoubleArray(FRawData)[AIndex] := Item;
end;

function TsgDoubleList.Add(const Item: Double): Integer;
begin
  Result := AddBase(@Item);
end;

procedure TsgDoubleList.AppendArray(const NewItems: array of Double;
  NewItemsAddCount: Integer);
begin
  AppendArrayBase(@NewItems[0], NewItemsAddCount);
end;

procedure TsgDoubleList.AppendConst(ACount: Integer; AValue: Double);
begin
  while ACount > 0 do
  begin
    Add(AValue);
    Dec(ACount);
  end;
end;

procedure TsgDoubleList.AppendArray(const NewItems: array of Double);
begin
  AppendArray(NewItems, System.High(NewItems)+1);
end;

procedure TsgDoubleList.AssignArray(const NewItems: array of Double);
begin
  Count := 0;
  AppendArray(NewItems);
end;

procedure TsgDoubleList.Insert(Index: Integer; const Item: Double);
begin
  InsertBase(Index, @Item);
end;

function TsgDoubleList.GetFirst: Double;
begin
  Result := GetItem(0);
end;

function TsgDoubleList.GetLast: Double;
begin
  Result := GetItem(Count - 1);
end;

function TsgDoubleList.GetList: PsgDoubleArray;
begin
  Result := PsgDoubleArray(FRawData);
end;

function TsgDoubleList.GetListType: TsgListType;
begin
  Result := ltDouble;
end;

function TsgDoubleList.GetNearestIndex(const AValue: Double): Integer;
begin
  Result := GetNearestIndexBase(@AValue, TsgPointerTypeComparer.NearestDouble);
end;

procedure TsgDoubleList.SetDefaultCompareProc(
  var AProc: sgConsts.TsgObjProcCompare);
begin
  AProc := TsgPointerTypeComparer.CmpDouble;
end;

procedure TsgDoubleList.SetFirst(const Value: Double);
begin
  if Sorted then Exit;
  SetItem(0, Value);
end;

procedure TsgDoubleList.SetLast(const Value: Double);
begin
  if Sorted then Exit;
  SetItem(Count - 1, Value);
end;

{TsgFloatList}

function TsgFloatList.GetItem(const AIndex: Integer): TsgFloat;
begin
  Result := PsgFloatArray(FRawData)[AIndex];
end;

procedure TsgFloatList.SetItem(const AIndex: Integer; const Item: TsgFloat);
begin
  if Sorted then Exit;
  PsgFloatArray(FRawData)[AIndex] := Item;
end;

function TsgFloatList.Add(const Item: TsgFloat): Integer;
begin
  Result := AddBase(@Item);
end;

procedure TsgFloatList.AppendArray(const NewItems: array of TsgFloat;
  NewItemsAddCount: Integer);
begin
  AppendArrayBase(@NewItems[0], NewItemsAddCount);
end;

procedure TsgFloatList.AppendArray(const NewItems: array of TsgFloat);
begin
  AppendArray(NewItems, System.High(NewItems)+1);
end;

procedure TsgFloatList.AssignArray(const NewItems: array of TsgFloat);
begin
  Count := 0;
  AppendArray(NewItems);
end;

procedure TsgFloatList.Insert(Index: Integer; const Item: TsgFloat);
begin
  InsertBase(Index, @Item);
end;

function TsgFloatList.GetFirst: TsgFloat;
begin
  Result := GetItem(0);
end;

function TsgFloatList.GetLast: TsgFloat;
begin
  Result := GetItem(Count - 1);
end;

function TsgFloatList.GetList: PsgFloatArray;
begin
  Result := PsgFloatArray(FRawData);
end;

function TsgFloatList.GetListType: TsgListType;
begin
  Result := ltFloat;
end;

procedure TsgFloatList.SetDefaultCompareProc(var AProc: sgConsts.TsgObjProcCompare);
begin
  AProc := TsgPointerTypeComparer.CmpFloat;
end;

procedure TsgFloatList.SetFirst(const Value: TsgFloat);
begin
  if Sorted then Exit;
  SetItem(0, Value);
end;

procedure TsgFloatList.SetLast(const Value: TsgFloat);
begin
  if Sorted then Exit;
  SetItem(Count - 1, Value);
end;

{TsgInt64List}

function TsgInt64List.GetItem(const AIndex: Integer): Int64;
begin
  Result := PsgInt64Array(FRawData)[AIndex];
end;

procedure TsgInt64List.SetItem(const AIndex: Integer; const Item: Int64);
begin
  if Sorted then Exit;
  PsgInt64Array(FRawData)[AIndex] := Item;
end;

function TsgInt64List.Add(const Item: Int64): Integer;
begin
  Result := AddBase(@Item);
end;

procedure TsgInt64List.AppendArray(const NewItems: array of Int64;
  NewItemsAddCount: Integer);
begin
  AppendArrayBase(@NewItems[0], NewItemsAddCount);
end;

procedure TsgInt64List.AppendArray(const NewItems: array of Int64);
begin
  AppendArray(NewItems, System.High(NewItems)+1);
end;

procedure TsgInt64List.AssignArray(const NewItems: array of Int64);
begin
  Count := 0;
  AppendArray(NewItems);
end;

procedure TsgInt64List.Insert(Index: Integer; const Item: Int64);
begin
  InsertBase(Index, @Item);
end;

function TsgInt64List.Remove(const AItem: Int64): Integer;
begin
  Result := RemoveBase(@AItem);
end;

function TsgInt64List.GetFirst: Int64;
begin
  Result := GetItem(0);
end;

function TsgInt64List.GetLast: Int64;
begin
  Result := GetItem(Count - 1);
end;

function TsgInt64List.GetList: PsgInt64Array;
begin
  Result := PsgInt64Array(FRawData);
end;

function TsgInt64List.GetListType: TsgListType;
begin
  Result := ltInt64;
end;

procedure TsgInt64List.SetDefaultCompareProc(var AProc: sgConsts.TsgObjProcCompare);
begin
  AProc := TsgPointerTypeComparer.CmpInt64;
end;

procedure TsgInt64List.SetFirst(const Value: Int64);
begin
  if Sorted then Exit;
  SetItem(0, Value);
end;

procedure TsgInt64List.SetLast(const Value: Int64);
begin
  if Sorted then Exit;
  SetItem(Count - 1, Value);
end;

function TsgInt64List.IndexOf(const Item: Int64): Integer;
begin
  Result := IndexOfBase(@Item);
end;

procedure TsgInt64List.FixOldVersion;
begin
  SetCapacity(1); //
  System.FillChar(FRawData^, FItemSize * Capacity, 0);
end;

{TsgIntegerList}

function TsgIntegerList.GetItem(const AIndex: Integer): Integer;
begin
  Result := PInteger(GetItemBase(AIndex))^;
end;

procedure TsgIntegerList.SetItem(const AIndex: Integer; const Item: Integer);
begin
  if Sorted then Exit;
  PInteger(GetItemBase(AIndex))^ := Item;
end;

function TsgIntegerList.Add(const Item: Integer): Integer;
begin
  Result := AddBase(@Item);
end;

procedure TsgIntegerList.AppendArray(const NewItems: array of Integer;
  NewItemsAddCount: Integer);
begin
  AppendArrayBase(@NewItems[0], NewItemsAddCount);
end;

procedure TsgIntegerList.AppendArray(const NewItems: array of Integer);
begin
  AppendArray(NewItems, System.High(NewItems)+1);
end;

procedure TsgIntegerList.AssignArray(const NewItems: array of Integer);
begin
  Count := 0;
  AppendArray(NewItems);
end;

procedure TsgIntegerList.AppendConst(ACount, AValue: Integer);
begin
  while ACount > 0 do
  begin
    Add(AValue);
    Dec(ACount);
  end;
end;

procedure TsgIntegerList.Insert(Index: Integer; const Item: Integer);
begin
  InsertBase(Index, @Item);
end;

function TsgIntegerList.Remove(const Item: Integer): Integer;
begin
  Result := RemoveBase(@Item);
end;

procedure TsgIntegerList.SetAll(const Item: Integer);
var
  I: Integer;
begin
 for I := 0 to Count - 1 do
   Items[I] := Item;
end;

procedure TsgIntegerList.SetDefaultCompareProc(
  var AProc: sgConsts.TsgObjProcCompare);
begin
  AProc := TsgPointerTypeComparer.CmpInteger;
end;

function TsgIntegerList.GetFirst: Integer;
begin
  Result := GetItem(0);
end;

function TsgIntegerList.GetLast: Integer;
begin
  Result := GetItem(Count - 1);
end;

function TsgIntegerList.GetList: PsgIntegerArray;
begin
  Result := PsgIntegerArray(FRawData);
end;

function TsgIntegerList.GetListType: TsgListType;
begin
  Result := ltInteger;
end;

procedure TsgIntegerList.SetFirst(const Value: Integer);
begin
  if Sorted then Exit;
  SetItem(0, Value);
end;

procedure TsgIntegerList.SetLast(const Value: Integer);
begin
  if Sorted then Exit;
  SetItem(Count - 1, Value);
end;

function TsgIntegerList.IndexOf(const Item: Integer): Integer;
begin
  Result := IndexOfBase(@Item);
end;

{TFPointList}


function TFPointList.GetItem(const AIndex: Integer): TFPoint;

begin
  Result := PFPointArray(FRawData)[AIndex];
end;

procedure TFPointList.SetItem(const AIndex: Integer; const Item: TFPoint);
begin
  if Sorted then Exit;
  PFPointArray(FRawData)[AIndex] := Item;
end;

function TFPointList.Add(const Item: TFPoint): Integer;
begin
  Result := AddBase(@Item);
end;

procedure TFPointList.AppendArray(const NewItems: array of TFPoint;
  NewItemsAddCount: Integer);
begin
  AppendArrayBase(@NewItems[0], NewItemsAddCount);
end;

procedure TFPointList.AppendArray(const NewItems: array of TFPoint);
begin
  AppendArray(NewItems, System.High(NewItems)+1);
end;

procedure TFPointList.AppendArray(NewItems: IsgArrayFPoint;
  const AFiFo: Boolean = True);
var
  I: Integer;
begin
  if AFiFo then
  begin
    for I := 0 to NewItems.FPointCount - 1 do
      Add(NewItems.FPoints[I]);
  end
  else
  begin
    for I := NewItems.FPointCount - 1 downto 0 do
      Add(NewItems.FPoints[I]);
  end;
end;

procedure TFPointList.AssignArray(const NewItems: array of TFPoint);
begin
  Count := 0;
  AppendArray(NewItems);
end;

procedure TFPointList.CombineItem(const AIndex: Integer; const AVector: TFPoint;
  const ALen: Double);
begin
  PFPointArray(FRawData)[AIndex] :=
    AddFPoint(PFPointArray(FRawData)[AIndex], PtXScalar(AVector, ALen));
end;

procedure TFPointList.Insert(Index: Integer; const Item: TFPoint);
begin
  InsertBase(Index, @Item);
end;

function TFPointList.IndexOf(const AValue: TFPoint): Integer;
begin
  Result := IndexOfBase(@AValue);
end;

function TFPointList.GetBox: TFRect;
begin
{$IFDEF _FIXINSIGHT_}
  FillChar(Result, SizeOf(Result), 0);
{$ENDIF}
  GetExtents(Result.TopLeft, Result.BottomRight);
  SwapDoubles(Result.Top, Result.Bottom);
end;

procedure TFPointList.GetExtents(var min, max: TFPoint);
var
  I, K: Integer;
  f:    Double;
  ref:  TFPoint;
const
  cBigValue: Single   = 1E50;
  cSmallValue: Single = -1E50;
begin
  min := MakeFPoint(cBigValue, cBigValue, cBigValue);
  max := MakeFPoint(cSmallValue, cSmallValue, cSmallValue);
  for I := 0 to Count - 1 do
  begin
    ref := GetItem(I);
    for K := 0 to 2 do
    begin
      f := ref.V[K];
      if f < min.V[K] then
        min.V[K] := f;
      if f > max.V[K] then
        max.V[K] := f;
    end;
  end;
end;

function TFPointList.GetFirst: TFPoint;
begin
  Result := GetItem(0);
end;

function TFPointList.GetFPoint(const AIndex: Integer): TFPoint;
begin
  Result := GetItem(AIndex);
end;

function TFPointList.GetFPointCount: Integer;
begin
  Result := GetCount;
end;

function TFPointList.GetLast: TFPoint;
begin
  Result := GetItem(Count - 1);
end;

function TFPointList.GetList: PFPointArray;
begin
  Result := PFPointArray(FRawData);
end;

function TFPointList.GetListType: TsgListType;
begin
  Result := ltFPoint;
end;

function TFPointList.GetNearestIndex(const AValue: TFPoint): Integer;
begin
  Result := GetNearestIndexBase(@AValue, TsgPointerTypeComparer.NearestFPoint);
end;

procedure TFPointList.SetDefaultCompareProc(var AProc: sgConsts.TsgObjProcCompare);
begin
  AProc := TsgPointerTypeComparer.CmpFPoint;
end;

procedure TFPointList.SetFirst(const Value: TFPoint);
begin
  if Sorted then Exit;
  SetItem(0, Value);
end;

procedure TFPointList.SetLast(const Value: TFPoint);
begin
  if Sorted then Exit;
  SetItem(Count - 1, Value);
end;

procedure TFPointList.SortOnAngle(const ACenter: TFPoint; const AAngle: Double);
var
  I, J: Integer;
  vAngle: Double;
  vAngles: TsgDoubleList;
  vPoint: TFPoint;
begin
  if Count < 1 then Exit;
  vAngles := TsgDoubleList.Create;
  try
    vAngles.Count := Count;
    for I := 0 to Count - 1 do
    begin
      vAngle := sgAngleByPoints(ACenter, GetItem(I), False);
      vAngles[I] := vAngle;
    end;
    for I := 0 to Count - 2 do
    begin
      for J := I + 1 to Count - 1 do
      begin
        if vAngles[I] > vAngles[J] then
        begin
          vAngle := vAngles[I];
          vAngles[I] := vAngles[J];
          vAngles[J] := vAngle;
          vPoint := Items[I];
          Items[I] := Items[J];
          Items[J] := vPoint;
        end;
      end;
    end;
    if AAngle <> 0 then
    begin
      J := -1;
      for I := 0 to vAngles.Count - 1 do
      begin
        if (AAngle <= vAngles[I]) or sgConsts.IsEqual(AAngle, vAngles[I]) then
          Break
        else
          J := I;
      end;
      if J > -1 then
      begin
        I := 0;
        while I <= J do
        begin
          Add(Items[0]);
          Delete(0);
          Inc(I);
        end;
      end;
    end;
  finally
    vAngles.Free;
  end;
end;

procedure TFPointList.SortOnVector(const AVector: TFPoint);
var
  vPrevSortProc, vProc: TsgObjProcCompare;

begin
  vProc := sgComparer.TsgPointerTypeComparer.CmpFPoint;
  if sgSignZ(AVector.X) = 1 then
  begin
    if sgSignZ(AVector.Y) <> 1 then
      vProc := sgComparer.TsgPointerTypeComparer.CmpFPoint2DXYneg;
  end
  else
  begin
    if sgSignZ(AVector.Y) = 1 then
      vProc := sgComparer.TsgPointerTypeComparer.CmpFPoint2DXnegY
    else
      vProc := sgComparer.TsgPointerTypeComparer.CmpFPoint2DXnegYneg;
  end;
  vPrevSortProc := ProcCompare;
  try
    ProcCompare := vProc;
    Sort;
  finally
    ProcCompare := vPrevSortProc;
  end;
end;

procedure TFPointList.Transform(const AMatrix: TFMatrix);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    PFPointArray(FRawData)[I] :=
      FPointXMat(PFPointArray(FRawData)[I], AMatrix);
  end;
end;

{TF2DPointList}

function TF2DPointList.GetItem(const AIndex: Integer): TF2DPoint;
begin
  Result := PF2DPointArray(FRawData)[AIndex];
end;

procedure TF2DPointList.SetItem(const AIndex: Integer; const Item: TF2DPoint);
begin
  if Sorted then Exit;
  PF2DPointArray(FRawData)[AIndex] := Item;
end;

function TF2DPointList.Add(const Item: TF2DPoint): Integer;
begin
  Result := AddBase(@Item);
end;

procedure TF2DPointList.AppendArray(const NewItems: array of TF2DPoint;
  NewItemsAddCount: Integer);
begin
  AppendArrayBase(@NewItems[0], NewItemsAddCount);
end;

procedure TF2DPointList.AppendArray(const NewItems: array of TF2DPoint);
begin
  AppendArray(NewItems, System.High(NewItems) + 1);
end;

procedure TF2DPointList.AppendArray(NewItems: IsgArrayFPoint;
  const AFiFo: Boolean = True);
var
  vPoint: TFPoint;
  vPoint2D: TF2DPoint;
  I, vCnt: Integer;
begin
  vCnt := NewItems.FPointCount - 1;
  for I := 0 to vCnt do
  begin
    if AFiFo then
      vPoint := NewItems.FPoints[I]
    else
      vPoint := NewItems.FPoints[vCnt - I];
    vPoint2D.X := vPoint.X;
    vPoint2D.Y := vPoint.Y;
    Add(vPoint2D);
  end;
end;

procedure TF2DPointList.AssignArray(const NewItems: array of TF2DPoint);
begin
  Count := 0;
  AppendArray(NewItems);
end;

function TF2DPointList.IndexOf(const Item: TF2DPoint): Integer;
begin
  if not FindBase(@Item, Result) then
    Result := -1;
end;

procedure TF2DPointList.Insert(Index: Integer; const Item: TF2DPoint);
begin
  InsertBase(Index, @Item);
end;

function TF2DPointList.GetBox: TFRect;
var
  I: Integer;
  vPoint: PF2DPoint;
begin
  Result := inherited GetBox;
  if Count > 0 then
  begin
    Result.Z1 := 0;
    Result.Z2 := 0;
    for I := 0 to Count - 1 do
    begin
      vPoint := @PF2DPointArray(FRawData)[I];
      ExpandFRect2D(Result, vPoint^);
    end;
  end;
end;

function TF2DPointList.GetFirst: TF2DPoint;
begin
  Result := GetItem(0);
end;

function TF2DPointList.GetFPoint(const AIndex: Integer): TFPoint;
var
  vPoint: PF2DPoint;
begin
  vPoint := @PF2DPointArray(FRawData)[AIndex];
  Result.X := vPoint^.X;
  Result.Y := vPoint^.Y;
  Result.Z := 0;
end;

function TF2DPointList.GetFPointCount: Integer;
begin
  Result := GetCount;
end;

function TF2DPointList.GetLast: TF2DPoint;
begin
  Result := GetItem(Count - 1);
end;

function TF2DPointList.GetList: PF2DPointArray;
begin
  Result := PF2DPointArray(FRawData);
end;

function TF2DPointList.GetListType: TsgListType;
begin
  Result := ltF2DPoint;
end;

procedure TF2DPointList.SetDefaultCompareProc(
  var AProc: sgConsts.TsgObjProcCompare);
begin
  AProc := TsgPointerTypeComparer.CmpF2DPoint;
end;

procedure TF2DPointList.SetFirst(const Value: TF2DPoint);
begin
  if Sorted then Exit;
  SetItem(0, Value);
end;

procedure TF2DPointList.SetLast(const Value: TF2DPoint);
begin
  if Sorted then Exit;
  SetItem(Count - 1, Value);
end;

{TF4DPointList}

function TF4DPointList.GetItem(const AIndex: Integer): TF4DPoint;
begin
  Result := PF4DPointArray(FRawData)^[AIndex];
end;

procedure TF4DPointList.SetItem(const AIndex: Integer; const Item: TF4DPoint);
begin
  if Sorted then Exit;
  PF4DPointArray(FRawData)^[AIndex] := Item;
end;

function TF4DPointList.Add(const Item: TF4DPoint): Integer;
begin
  Result := AddBase(@Item);
end;

procedure TF4DPointList.AppendArray(const NewItems: array of TF4DPoint;
  NewItemsAddCount: Integer);
begin
  AppendArrayBase(@NewItems[0], NewItemsAddCount);
end;

procedure TF4DPointList.AppendArray(const NewItems: array of TF4DPoint);
begin
  AppendArray(NewItems, System.High(NewItems) + 1);
end;

procedure TF4DPointList.AppendArray(NewItems: IsgArrayFPoint;
  const AFiFo: Boolean = True);
var
  vPoint: TFPoint;
  vPoint4D: TF4DPoint;
  I, vCnt: Integer;
begin
  vCnt := NewItems.FPointCount - 1;
  for I := 0 to vCnt do
  begin
    if AFiFo then
      vPoint := NewItems.FPoints[I]
    else
      vPoint := NewItems.FPoints[vCnt - I];
    vPoint4D.X := vPoint.X;
    vPoint4D.Y := vPoint.Y;
    vPoint4D.Z := vPoint.Z;
    vPoint4D.W := 1;
    Add(vPoint4D);
  end;
end;

procedure TF4DPointList.AssignArray(const NewItems: array of TF4DPoint);
begin
  Count := 0;
  AppendArray(NewItems);
end;

function TF4DPointList.IndexOf(const Item: TF4DPoint): Integer;
begin
  if not FindBase(@Item, Result) then
    Result := -1;
end;

procedure TF4DPointList.Insert(Index: Integer; const Item: TF4DPoint);
begin
  InsertBase(Index, @Item);
end;

function TF4DPointList.GetBox: TFRect;
var
  I: Integer;
  vPoint: PFPoint;
begin
  Result := inherited GetBox;
  for I := 0 to Count - 1 do
  begin
    vPoint := @PF4DPointArray(FRawData)[I];
    ExpandFRect(Result, vPoint^);
  end;
end;

function TF4DPointList.GetFirst: TF4DPoint;
begin
  Result := GetItem(0);
end;

function TF4DPointList.GetFPoint(const AIndex: Integer): TFPoint;
var
  vPoint: PF4DPoint;
begin
  vPoint := @PF4DPointArray(FRawData)[AIndex];
  Result.X := vPoint^.X;
  Result.Y := vPoint^.Y;
  Result.Z := vPoint^.Z;
end;

function TF4DPointList.GetFPointCount: Integer;
begin
  Result := GetCount;
end;

function TF4DPointList.GetLast: TF4DPoint;
begin
  Result := GetItem(Count - 1);
end;

function TF4DPointList.GetList: PF4DPointArray;
begin
  Result := PF4DPointArray(FRawData);
end;

function TF4DPointList.GetListType: TsgListType;
begin
  Result := ltF4DPoint;
end;

procedure TF4DPointList.SetDefaultCompareProc(var AProc: sgConsts.TsgObjProcCompare);
begin
{$IFDEF SGFPC}
  TMethod(AProc) := MKMETHOD(Pointer(TsgPointerTypeComparer), @TsgPointerTypeComparer.CmpFPoint);
{$ELSE}
  AProc := TsgPointerTypeComparer.CmpFPoint;
{$ENDIF}
end;

procedure TF4DPointList.SetFirst(const Value: TF4DPoint);
begin
  if Sorted then Exit;
  SetItem(0, Value);
end;

procedure TF4DPointList.SetLast(const Value: TF4DPoint);
begin
  if Sorted then Exit;
  SetItem(Count - 1, Value);
end;

{ TsgList }

function TsgPointerList.Add(const Item: Pointer): Integer;
begin
  Result := AddBase(@Item);
end;

procedure TsgPointerList.AppendArray(const AList: TList);
begin
  CopyFrom(AList);
end;

procedure TsgPointerList.ClearTypeList(const ATypeValue: TsgPointerTypeValue;
  const AClearCapacity: Boolean = False; ACallClear: Boolean = True);
var
  I: Integer;
begin
  case ATypeValue of
    ptvRecord:
      for I := 0 to High do
        Dispose(GetItem(I));
    ptvObject:
      for I := 0 to High do
        TObject(GetItem(I)).Free;
  end;
  if ACallClear then
    Clear(AClearCapacity);
end;

function TsgPointerList.GetFirst: Pointer;
begin
  Result := GetItem(0);
end;

function TsgPointerList.GetFPoint(const AIndex: Integer): TFPoint;
begin
  Result := FFPointProc(GetItem(AIndex));
end;

function TsgPointerList.GetFPointCount: Integer;
begin
  Result := 0;
  if Assigned(FFPointProc) then
    Result := GetCount;
end;

function TsgPointerList.GetFPointProc: TsgObjProcGetFPoint;
begin
  Result := FFPointProc;
end;

function TsgPointerList.GetItem(const AIndex: Integer): Pointer;
begin
  Result := PPointerArray(FRawData)[AIndex];
end;

function TsgPointerList.GetLast: Pointer;
begin
  Result := GetItem(Count - 1);
end;

function TsgPointerList.GetListType: TsgListType;
begin
  Result := ltPointer;
end;

function TsgPointerList.IndexOf(const Item: Pointer): Integer;
begin
  if not FindBase(@Item, Result) then
    Result := -1;
end;

procedure TsgPointerList.Insert(Index: Integer; const Item: Pointer);
begin
  InsertBase(Index, @Item);
end;

function TsgPointerList.Remove(const Item: Pointer): Integer;
begin
  Result := RemoveBase(@Item);
end;

procedure TsgPointerList.SetDefaultCompareProc(var AProc: sgConsts.TsgObjProcCompare);
begin
  AProc := TsgPointerTypeComparer.CmpPointer;
end;

procedure TsgPointerList.SetFirst(const Value: Pointer);
begin
  SetItem(0, Value);
end;

procedure TsgPointerList.SetFPointProc(const Value: TsgObjProcGetFPoint);
begin
  FFPointProc := Value;
end;

procedure TsgPointerList.SetItem(const AIndex: Integer; const Item: Pointer);
begin
  FSorted := False;
  PPointerArray(FRawData)[AIndex] := Item;
end;

procedure TsgPointerList.SetLast(const Value: Pointer);
begin
  SetItem(Count - 1, Value);
end;

procedure TsgPointerList.Sort(FirstIndex, LastIndex,
  CountToUseSimpleSort: Integer);
begin
  FSorted := True;
  inherited Sort(FirstIndex, LastIndex, CountToUseSimpleSort);
end;

procedure TsgList.SetDefaultCompareProc(var AProc: sgConsts.TsgObjProcCompare);
begin
  AProc := TsgTypeComparer.CmpPointer;
end;

{ TsgList }

//This function compares the values of pointer
function TsgList.ComparePointers(const A, B: Pointer): Integer;
begin
  Result := FSortSmallerFunc(PPointer(A)^, PPointer(B)^);
end;

constructor TsgList.Create;
begin
  inherited Create;
  Sorted := False;
  Duplicates := dupAccept;
  SetCapacity(cnstDefaultCapacity);
end;

{ TsgHashCollection }

function TsgCollection.Add(const Item: TsgHashItem): Integer;
begin
  Result := AddBase(@Item);
end;

function TsgCollection.Add(const AHashCode: UInt64;
  const AData: Pointer): Integer;
var
  vHashItem: TsgHashItem;
begin
  vHashItem.HashCode := AHashCode;
  vHashItem.Data := AData;
  Result := Add(vHashItem);
end;

class function TsgCollection.CalcHash(const AStr: string): UInt64;
begin
  Result := sgComparer.GetHashCodeStr(AStr);
end;

procedure TsgCollection.ClearTypeList(const ATypeValue: TsgPointerTypeValue;
  const AClearCapacity: Boolean);
var
  I: Integer;
begin
  case ATypeValue of
    ptvRecord:
      for I := 0 to High do
        Dispose(GetItem(I).Data);
    ptvObject:
      for I := 0 to High do
        TObject(GetItem(I).Data).Free;
  end;
  Clear(AClearCapacity);
end;

constructor TsgCollection.Create;
begin
  inherited Create;
  inherited SetSorted(True);
end;

function TsgCollection.GetFirst: TsgHashItem;
begin
  Result := GetItem(0);
end;

function TsgCollection.GetItem(const AIndex: Integer): TsgHashItem;
begin
  Result := PsgHashItemsArray(FRawData)[AIndex];
end;

function TsgCollection.GetLast: TsgHashItem;
begin
  Result := GetItem(Count - 1);
end;

function TsgCollection.GetList: PsgHashItemsArray;
begin
  Result := PsgHashItemsArray(FRawData);
end;

function TsgCollection.GetListType: TsgListType;
begin
  Result := ltHashItem;
end;

function TsgCollection.IndexOf(const AHashCode: UInt64): Integer;
var
  vHashItem: TsgHashItem;
begin
  vHashItem.HashCode := AHashCode;
  vHashItem.Data := nil;
  Result := IndexOfBase(@vHashItem);
end;

procedure TsgCollection.SetDefaultCompareProc(var AProc: sgConsts.TsgObjProcCompare);
begin
  AProc := TsgPointerTypeComparer.CmpHashItem;
end;

procedure TsgCollection.SetSorted(const Value: Boolean);
begin
{$IFDEF _FIXINSIGHT_}
  sgNOP;
{$ENDIF}
end;

{ TsgHashList }

function TsgHashList.Add(const Item: Pointer): Integer;
begin
  if AddToHash(Item, FObjects.Count) then
    Result := FObjects.Add(Item)
  else
    Result := -1;
end;

function TsgHashList.AddToHash(const AItem: Pointer; const AIndex: Integer): Boolean;
var
  vHash: PsgHashLnk;
  vCount: Integer;
begin
  vCount := FHash.Count;
  New(vHash);
  vHash^.Data := AItem;
  vHash^.Index := AIndex;
  FHash.Add(vHash);
  Result := FHash.Count <> vCount;
  if not Result then
    Dispose(vHash);
end;

procedure TsgHashList.Clear(ClearCapacity: Boolean);
begin
  FHash.ClearTypeList(ptvRecord, ClearCapacity);
  FObjects.Clear(ClearCapacity);
end;

function TsgHashList.CompareHashs(const A, B: Pointer): Integer;
begin
  Result := TsgTypeComparer.CmpPointer(PsgHashLnk(A).Data, PsgHashLnk(B).Data);
end;

function TsgHashList.CopyFrom(const AList: TObject;
  const AMode: TsgCopyMode): Boolean;
var
  I: Integer;
  vList: TList;
  vPointerList: TsgList;
begin
  Result := False;
  if AMode = cmCopy then
    Clear(True);
  case SetObjLists(AList, vList, vPointerList) of
    1:
      begin
        for I := 0 to vList.Count - 1 do
          Add(vList.List[I]);
          Result := True;
      end;
    2:
      begin
        for I := 0 to vPointerList.Count - 1 do
          Add(vPointerList[I]);
        Result := True;
      end;
  end;
end;

function TsgHashList.CopyTo(const AList: TObject;
  const AMode: TsgCopyMode): Boolean;
var
  vList: TList;
  vPointerList: TsgList;
begin
  case SetObjLists(AList, vList, vPointerList) of
    1:  Result := FObjects.CopyTo(vList, AMode);
    2:
      begin
        Result := True;
        if AMode = cmCopy then
          vPointerList.Clear(False);
        vPointerList.AppendDynArray(FObjects);
      end;
  else
    Result := False;
  end;
end;

constructor TsgHashList.Create;
begin
  inherited Create;
  FHash := TsgList.Create;
  FHash.Sorted := true;
  FHash.Duplicates := dupIgnore;
  FHash.ProcCompare := CompareHashs;
  FObjects := TsgPointerList.Create;
end;

procedure TsgHashList.Delete(const AIndex: Integer);
begin
  RemoveFromHash(FObjects[AIndex]);
  FObjects.Delete(AIndex);
end;

destructor TsgHashList.Destroy;
begin
  Clear(True);
  FHash.Free;
  FObjects.Free;
  inherited Destroy;
end;

function TsgHashList.GetCount: Integer;
begin
  Result := FObjects.Count;
end;

function TsgHashList.GetDuplicates: TDuplicates;
begin
  Result := FHash.Duplicates;
end;

function TsgHashList.GetFPointProc: TsgObjProcGetFPoint;
begin
  Result := FHash.FPointProc;
end;

function TsgHashList.GetItem(const AIndex: Integer): Pointer;
begin
  Result := FObjects[AIndex];
end;

function TsgHashList.GetSorted: Boolean;
begin
  Result := False;
end;

function TsgHashList.IndexOf(const Item: Pointer): Integer;
var
  vHash: TsgHashLnk;
begin
  vHash.Data := Item;
  Result := FHash.IndexOf(@vHash);
  if Result > -1 then
    Result := PsgHashLnk(FHash[Result])^.Index;
end;

function TsgHashList.Remove(const AValue: Pointer): Integer;
begin
  Result := IndexOf(AValue);
  if Result > -1 then
    Delete(Result);
end;

procedure TsgHashList.RemoveFromHash(const AItem: Pointer);
var
  vIndex: Integer;
  vHash: TsgHashLnk;
begin
  vHash.Data := AItem;
  vIndex := FHash.IndexOf(@vHash);
  if vIndex > -1 then
  begin
    Dispose(FHash[vIndex]);
    FHash.Delete(vIndex);
  end;
end;

procedure TsgHashList.SetDuplicates(const Value: TDuplicates);
begin
{$IFDEF _FIXINSIGHT_}
  sgNOP;
{$ENDIF}
end;

procedure TsgHashList.SetFPointProc(const Value: TsgObjProcGetFPoint);
begin
  FHash.FPointProc := Value;
end;

procedure TsgHashList.SetItem(const AIndex: Integer; const Item: Pointer);
begin
{$IFDEF _FIXINSIGHT_}
  sgNOP;
{$ENDIF}
end;

procedure TsgHashList.SetProcCompare(const AValue: sgConsts.TsgObjProcCompare);
begin
{$IFDEF _FIXINSIGHT_}
  sgNOP;
{$ENDIF}
end;

procedure TsgHashList.SetSorted(const Value: Boolean);
begin
{$IFDEF _FIXINSIGHT_}
  sgNOP;
{$ENDIF}
end;

{ TsgUInt64Pairs }

function TsgUInt64Pairs.AddPair(const AFirt, ASecond: UInt64): Integer;
var
  vPair: PsgUInt64Pair;
begin
  New(vPair);
  vPair^.First := AFirt;
  vPair^.Second := ASecond;
  Result := FPairs.Add(vPair);
end;

procedure TsgUInt64Pairs.Clear;
begin
  FPairs.ClearTypeList(ptvRecord);
end;

function TsgUInt64Pairs.ComparePairs(const Pair1, Pair2: Pointer): Integer;
var
  vPair1, vPair2: TsgUInt64Pair;
  vVal1, vVal2: UInt64;
begin
  vPair1 := PsgUInt64Pair(Pair1)^;
  vPair2 := PsgUInt64Pair(Pair2)^;

  if FActivePairValue = apFirst then
  begin
    vVal1 := vPair1.First;
    vVal2 := vPair2.First;
  end
  else
  begin
    vVal1 := vPair1.Second;
    vVal2 := vPair2.Second;
  end;

  Result := TsgTypeComparer.CmpUInt64(vVal1, vVal2);
end;

constructor TsgUInt64Pairs.Create;
begin
  inherited Create;
  FActivePairValue := apFirst;
  FPairs := TsgList.Create;
  FPairs.Duplicates := dupIgnore;
  FPairs.Sorted := True;
  FPairs.Capacity := 1024;
  FPairs.ProcCompare := ComparePairs;
end;

destructor TsgUInt64Pairs.Destroy;
begin
  Clear;
  FPairs.Free;
  inherited Destroy;
end;

function TsgUInt64Pairs.GetCount: Integer;
begin
  Result := FPairs.Count;
end;

function TsgUInt64Pairs.GetFirst(AIndex: Integer): UInt64;
begin
  Result := PsgUInt64Pair(FPairs[AIndex])^.First;
end;

function TsgUInt64Pairs.GetPair(AIndex: Integer): TsgUInt64Pair;
begin
  Result := PsgUInt64Pair(FPairs[AIndex])^
end;

function TsgUInt64Pairs.GetSecond(AIndex: Integer): UInt64;
begin
  Result := PsgUInt64Pair(FPairs[AIndex])^.Second;
end;

function TsgUInt64Pairs.IndexOf(const Value: UInt64): Integer;
var
  vElem: TsgUInt64Pair;
begin
  vElem.First := Value;
  vElem.Second := Value;
  Result := FPairs.IndexOf(@vElem);
end;

procedure TsgUInt64Pairs.SetActivePairValue(const Value: TsgActivePairValue);
begin
  if Value <> FActivePairValue then
  begin
    FActivePairValue := Value;
    if FPairs.Sorted then
      FPairs.Sort{$IFNDEF SGDEL_5}(0, FPairs.Count - 1){$ENDIF};
  end;
end;

{ TsgReferenceBase }

procedure TsgReferenceBase.Delete(const AIndex: Integer);
begin
  FList.Delete(AIndex);
end;

destructor TsgReferenceBase.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

function TsgReferenceBase.GetCount: Integer;
begin
  Result := FList.GetCount;
end;

{ TsgReference }

function TsgReferenceSort.GetDuplicates: TDuplicates;
begin
  Result := FList.GetDuplicates;
end;

function TsgReferenceSort.GetSorted: Boolean;
begin
  Result := FList.GetSorted;
end;

procedure TsgReferenceSort.SetDuplicates(const Value: TDuplicates);
begin
  TsgBaseList(FList).SetDuplicates(Value);
end;

procedure TsgReferenceSort.SetProcCompare(const AValue: sgConsts.TsgObjProcCompare);
begin
  TsgBaseList(FList).SetProcCompare(AValue);
end;

procedure TsgReferenceSort.SetSorted(const Value: Boolean);
begin
  TsgBaseList(FList).SetSorted(Value);
end;

{ TsgReferenceList }

function TsgReferenceList.Add(const AValue: Pointer): Integer;
begin
  Result := TsgList(FList).Add(AValue);
end;

constructor TsgReferenceList.Create;
begin
  inherited Create;
  FList := TsgList.Create;
end;

function TsgReferenceList.GetFPoint(const AIndex: Integer): TFPoint;
begin
  Result := TsgList(FList).GetFPoint(AIndex);
end;

function TsgReferenceList.GetFPointCount: Integer;
begin
  Result := TsgList(FList).GetFPointCount;
end;

function TsgReferenceList.GetFPointProc: TsgObjProcGetFPoint;
begin
  Result := TsgList(FList).FPointProc;
end;

function TsgReferenceList.GetItem(const AIndex: Integer): Pointer;
begin
  Result := TsgList(FList).GetItem(AIndex);
end;

function TsgReferenceList.IndexOf(const AValue: Pointer): Integer;
begin
  Result := TsgList(FList).IndexOf(AValue);
end;

function TsgReferenceList.Remove(const AValue: Pointer): Integer;
begin
  Result := TsgList(FList).Remove(AValue);
end;

procedure TsgReferenceList.SetFPointProc(const Value: TsgObjProcGetFPoint);
begin
  TsgList(FList).FPointProc := Value;
end;

procedure TsgReferenceList.SetItem(const AIndex: Integer;
  const AValue: Pointer);
begin
  TsgList(FList).SetItem(AIndex, AValue);
end;

{ TsgVariablesMap }

function TsgVariablesMap.Add(const AVarName, AValueString: string): Integer;
begin
  Result := AddObject(AVarName, AValueString, nil);
end;

function TsgVariablesMap.AddObject(const AVarName, AValueString: string;
  AObject: TObject): Integer;
begin
  Result := FValues.AddObject(AValueString, AObject);
  FIdents.AddObject(AVarName, TObject(Result));
end;

procedure TsgVariablesMap.Clear(DoFreeObject: Boolean);
begin
  FIdents.Clear;
  ClearObjects(FValues, True);
end;

constructor TsgVariablesMap.Create;
begin
  inherited Create;
  FIdents := TStringList.Create;
  FIdents.Sorted := True;
  FIdents.Duplicates := dupIgnore;
  FValues := TStringList.Create;
end;

destructor TsgVariablesMap.Destroy;
begin
  FIdents.Free;
  FValues.Free;
  inherited;
end;

function TsgVariablesMap.GetCaseSensitive: Boolean;
begin
  Result := {$IFNDEF SGDEL6}False{$ELSE}FIdents.CaseSensitive{$ENDIF};
end;

function TsgVariablesMap.GetValue(const AIdent: string): string;
var
  vIndex: Integer;
  vValueIndex: Integer;
begin
  Result := '';
  vIndex := FIdents.IndexOf(AIdent);
  if vIndex > -1 then
  begin
    vValueIndex := Integer(FIdents.Objects[vIndex]);
    Result := FValues.Strings[vValueIndex];
  end;
end;

procedure TsgVariablesMap.SetCaseSensitive(const Value: Boolean);
begin
  {$IFDEF SGDEL6}FIdents.CaseSensitive := Value{$ENDIF};
end;

procedure TsgVariablesMap.SetValue(const AIdent: string; const Value: string);
var
  vIndex: Integer;
  vValueIndex: Integer;
begin
  vIndex := FIdents.IndexOf(AIdent);
  if vIndex > -1 then
  begin
    vValueIndex := Integer(FIdents.Objects[vIndex]);
    FValues.Strings[vValueIndex] := Value;
  end
  else
  begin
    Add(AIdent, Value);
  end;
end;


{ TsgListInterface }

constructor TsgListInterface.Create(const AList: TList;
  const AProc: TsgObjProcGetFPoint);
begin
  inherited Create;
  FProcObj := AProc;
end;

constructor TsgListInterface.Create(const AList: TList;
  const AProc: sgConsts.TsgProcOfPointerGetPoint);
begin
  inherited Create;
  FProc := AProc;
  FProcObj := GetFPointProc;
end;

function TsgListInterface.GetFPoint(const AIndex: Integer): TFPoint;
begin
  Result := FProcObj(FList.List[AIndex]);
end;

class function TsgListInterface.DereferenceToPF2DPoint(
  const AValue: Pointer): TFPoint;
begin
  Result.X := PF2DPoint(AValue)^.X;
  Result.Y := PF2DPoint(AValue)^.Y;
  Result.Z := 0;
end;

class function TsgListInterface.DereferenceToPFPoint(
  const AValue: Pointer): TFPoint;
begin
  Result := PFPoint(AValue)^;
end;

class function TsgListInterface.DereferenceToPFPoint2D(
  const AValue: Pointer): TFPoint;
begin
  Result := PFPoint(AValue)^;
  Result.Z := 0;
end;

class function TsgListInterface.DereferenceToPPoint(
  const AValue: Pointer): TFPoint;
begin
  Result.X := PsgPoint(AValue)^.X;
  Result.Y := PsgPoint(AValue)^.Y;
  Result.Z := 0;
end;

class function TsgListInterface.DereferenceType(
  const AType: Integer): TsgObjProcGetFPoint;
begin
  case AType of
    0:  Result := DereferenceToPPoint;
    1:  Result := DereferenceToPFPoint2D;
    2:  Result := DereferenceToPF2DPoint;
  else
    Result := DereferenceToPFPoint;
  end;
end;

function TsgListInterface.GetFPointCount: Integer;
begin
  Result := FList.Count;
end;

function TsgListInterface.GetFPointProc(const APointer: Pointer): TFPoint;
begin
  Result := FProc(APointer);
end;

{ TListNotify }

class function TListNotify.CreateList(const AProc: TsgObjProcListNotify): TList;
begin
  Result := TList(NewInstance);
  Result.Create;
  TListNotify(Result).OnNotify := AProc;
end;

procedure TListNotify.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if Assigned(FOnNotify) then
    FOnNotify(Ptr, Action);
end;

{ TsgBasePointList }

function TsgBasePointList.GetBox: TFRect;
begin
  Result := cnstBadRect;
end;

{ TsgPointFList }

function TsgPointFList.GetItem(const AIndex: Integer): TPointF;
begin
  Result := PsgPointFArray(FRawData)^[AIndex];
end;

procedure TsgPointFList.SetItem(const AIndex: Integer; const Item: TPointF);
begin
  if Sorted then Exit;
  PsgPointFArray(FRawData)^[AIndex] := Item;
end;

function TsgPointFList.Add(const Item: TPointF): Integer;
begin
  Result := AddBase(@Item);
end;

procedure TsgPointFList.AppendArray(const NewItems: array of TPointF;
  NewItemsAddCount: Integer);
begin
  AppendArrayBase(@NewItems[0], NewItemsAddCount);
end;

procedure TsgPointFList.AppendArray(const NewItems: array of TPointF);
begin
  AppendArray(NewItems, System.High(NewItems) + 1);
end;

function TsgPointFList.Add(X, Y: Single): Integer;
var
  P: TPointF;
begin
  P.X := X;
  P.Y := Y;
  Result := Add(P);
end;

procedure TsgPointFList.AppendArray(NewItems: IsgArrayFPoint;
  const AFiFo: Boolean = True);
var
  vPoint: TFPoint;
  vPointF: TPointF;
  I, vCnt: Integer;
begin
  vCnt := NewItems.FPointCount - 1;
  for I := 0 to vCnt do
  begin
    if AFiFo then
      vPoint := NewItems.FPoints[I]
    else
      vPoint := NewItems.FPoints[vCnt - I];
    vPointF.X := vPoint.X;
    vPointF.Y := vPoint.Y;
    Add(vPointF);
  end;
end;

procedure TsgPointFList.AssignArray(const NewItems: array of TPointF);
begin
  Count := 0;
  AppendArray(NewItems);
end;

function TsgPointFList.IndexOf(const Item: TPointF): Integer;
begin
  if not FindBase(@Item, Result) then
    Result := -1;
end;

procedure TsgPointFList.Insert(Index: Integer; const Item: TPointF);
begin
  InsertBase(Index, @Item);
end;

function TsgPointFList.GetBox: TFRect;
var
  I: Integer;
  vPoint: PPointF;
begin
  Result := inherited GetBox;
  if Count > 0 then
  begin
    Result.Z1 := 0;
    Result.Z2 := 0;
    for I := 0 to Count - 1 do
    begin
      vPoint := PPointF(@PsgPointFArray(FRawData)^[I]);
      ExpandFRect2D(Result, MakeF2DPoint(vPoint^.X, vPoint^.Y));
    end;
  end;
end;

function TsgPointFList.GetFirst: TPointF;
begin
  Result := GetItem(0);
end;

function TsgPointFList.GetFPoint(const AIndex: Integer): TFPoint;
var
  vPoint: PPointF;
begin
  vPoint := PPointF(@PsgPointFArray(FRawData)^[AIndex]);
  Result.X := vPoint^.X;
  Result.Y := vPoint^.Y;
  Result.Z := 0;
end;

function TsgPointFList.GetFPointCount: Integer;
begin
  Result := GetCount;
end;

function TsgPointFList.GetLast: TPointF;
begin
  Result := GetItem(Count - 1);
end;

function TsgPointFList.GetList: PsgPointFArray;
begin
  Result := PsgPointFArray(FRawData);
end;

function TsgPointFList.GetListType: TsgListType;
begin
  Result := ltPointF;
end;

procedure TsgPointFList.SetDefaultCompareProc(
  var AProc: sgConsts.TsgObjProcCompare);
begin
  AProc := TsgPointerTypeComparer.CmpPointF;
end;

procedure TsgPointFList.SetFirst(const Value: TPointF);
begin
  if Sorted then Exit;
  SetItem(0, Value);
end;

procedure TsgPointFList.SetLast(const Value: TPointF);
begin
  if Sorted then Exit;
  SetItem(Count - 1, Value);
end;

end.
