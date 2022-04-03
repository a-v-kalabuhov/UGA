object KisFTP: TKisFTP
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 137
  Width = 160
  object FTP: TIdFTP
    AutoLogin = True
    Host = 'srv-bd3.mup-uga.vrn.ru'
    Passive = True
    TransferTimeout = 1000
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    ReadTimeout = 1000
    Left = 32
    Top = 16
  end
  object Intercept: TIdConnectionIntercept
    Left = 88
    Top = 16
  end
end
