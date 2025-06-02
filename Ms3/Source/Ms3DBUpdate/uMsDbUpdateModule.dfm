object MsDbUpdateModule: TMsDbUpdateModule
  OldCreateOrder = False
  Height = 150
  Width = 215
  object dbKis: TIBDatabase
    DatabaseName = 'localhost:C:\Projects\kis\Environment\db\UGA.FDB'
    Params.Strings = (
      'user_name=SYSDBA'
      'lc_ctype=WIN1251'
      'password=masterkey')
    LoginPrompt = False
    Left = 24
    Top = 16
  end
  object dbGeo: TIBDatabase
    DatabaseName = 'localhost:C:\Projects\kis\Environment\db\geodata.FDB'
    Params.Strings = (
      'lc_ctype=WIN1251'
      'user_name=SYSDBA'
      'password=masterkey')
    LoginPrompt = False
    Left = 128
    Top = 16
  end
  object trKis: TIBTransaction
    Left = 24
    Top = 72
  end
  object trGeo: TIBTransaction
    Left = 128
    Top = 72
  end
end
