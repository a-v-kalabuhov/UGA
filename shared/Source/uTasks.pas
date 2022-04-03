unit uTasks;

interface

uses
  SysUtils, SyncObjs, Contnrs, Classes;

type
  TTask = class
  protected
    procedure Execute(); virtual; abstract;
  end;

  TTaskExecutor = class
  private type
    TThreadCounter = class
    private
      FEvent: TEvent;
      FGuard: TCriticalSection;
      FValue: Integer;
      function GetValue: Integer;
      procedure SetValue(const Value: Integer);
    public
      constructor Create(const aValue: Integer = 0);
      destructor Destroy; override;
      //
      procedure DecCounter;
      //
      property Event: TEvent read FEvent;
      property Value: Integer read GetValue write SetValue;
    end;
    TTaskThread = class(TThread)
    private
      FTask: TTask;
      FCounter: TThreadCounter;
    protected
      procedure Execute(); override;
    public
      constructor Create(aTask: TTask; aCounter: TThreadCounter);
    end;
  private
    FCounter: TThreadCounter;
    FThreads: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure AddTask(aTask: TTask);
    procedure Execute(const aTaskName: String; const TimeOut: Cardinal);
  end;

implementation

{ TThreadCountr }

constructor TTaskExecutor.TThreadCounter.Create(const aValue: Integer);
begin
  inherited Create;
  FGuard := TCriticalSection.Create;
  FEvent := TEvent.Create;
  FEvent.ResetEvent;
  FValue := aValue;
end;

procedure TTaskExecutor.TThreadCounter.DecCounter;
begin
  FGuard.Acquire; { obtain a lock on the counter }
  Dec(FValue);   { decrement the global counter variable }
  if FValue = 0 then
    FEvent.SetEvent;
  FGuard.Release;
end;

destructor TTaskExecutor.TThreadCounter.Destroy;
begin
  FreeAndNil(FGuard);
  inherited;
end;

function TTaskExecutor.TThreadCounter.GetValue: Integer;
begin
  FGuard.Acquire; { obtain a lock on the counter }
  Result := FValue;   { decrement the global counter variable }
  FGuard.Release;
end;

procedure TTaskExecutor.TThreadCounter.SetValue(const Value: Integer);
begin
  FGuard.Acquire; 
  FValue := Value;
  FGuard.Release;
end;

{ TTaskThread }

constructor TTaskExecutor.TTaskThread.Create;
begin
  inherited Create(True);
  FTask := aTask;
  FCounter := aCounter;
end;

procedure TTaskExecutor.TTaskThread.Execute;
begin
  FTask.Execute;
  FCounter.DecCounter;
end;

{ TTaskExecutor }

procedure TTaskExecutor.AddTask(aTask: TTask);
var
  Thrd: TTaskThread;
begin
  Thrd := TTaskThread.Create(aTask, FCounter);
  FThreads.Add(Thrd);
end;

constructor TTaskExecutor.Create;
begin
  inherited;
  FCounter := TThreadCounter.Create;
  FThreads := TObjectList.Create;
end;

destructor TTaskExecutor.Destroy;
begin
  FreeAndNil(FThreads);
  FreeAndNil(FCounter);
  inherited;
end;

procedure TTaskExecutor.Execute(const aTaskName: String; const TimeOut: Cardinal);
var
  I: Integer;
  Thrd: TThread;
  ErrText: string;
begin
  FCounter.Value := FThreads.Count;
  FCounter.Event.ResetEvent; { clear the event before launching the threads }
  for I := 0 to FThreads.Count - 1 do
  begin
    Thrd := FThreads[I] as TThread;
    Thrd.Resume;
  end;
  //
  if FCounter.Event.WaitFor(TimeOut) <> wrSignaled then
  begin
    ErrText := 'Ошибка выполнения операции:' + sLineBreak + aTaskName;
    raise Exception.Create(ErrText);
  end;
end;

end.
