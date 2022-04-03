object MStIBXMapMngr: TMStIBXMapMngr
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 215
  object dbKis: TIBDatabase
    DatabaseName = 'localhost:C:\Projects\\kis\environment\db\UGA.FDB'
    Params.Strings = (
      'user_name=SYSDBA')
    BeforeConnect = dbKisBeforeConnect
    OnLogin = OnLogin
    Left = 24
    Top = 16
  end
  object dbGeo: TIBDatabase
    BeforeConnect = dbGeoBeforeConnect
    OnLogin = OnLogin
    Left = 128
    Top = 16
  end
end
