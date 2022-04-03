object KisAppModule: TKisAppModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 319
  Width = 223
  object Database: TIBDatabase
    Params.Strings = (
      'lc_ctype=WIN1251'
      'password=masterkey'
      'user_name=SYSDBA')
    LoginPrompt = False
    TraceFlags = [tfQPrepare, tfQExecute, tfQFetch, tfError, tfStmt, tfConnect, tfTransact, tfBlob, tfService, tfMisc]
    AllowStreamedConnected = False
    Left = 16
    Top = 14
  end
  object ApplicationEvents: TApplicationEvents
    OnException = ApplicationEventsException
    Left = 91
    Top = 14
  end
  object DebugIBTran: TIBTransaction
    DefaultDatabase = DebugIBDB
    Left = 104
    Top = 248
  end
  object DebugIBDB: TIBDatabase
    DatabaseName = 'localhost:C:\Projects\Db\UGA_TEST.FDB'
    Params.Strings = (
      'user_name=SYSDBA'
      'password=masterkey')
    LoginPrompt = False
    DefaultTransaction = DebugIBTran
    Left = 24
    Top = 248
  end
end
