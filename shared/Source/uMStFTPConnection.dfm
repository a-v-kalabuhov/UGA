object MStFTPConnection: TMStFTPConnection
  OldCreateOrder = False
  Height = 252
  Width = 168
  object FTP: TIdFTP
    IOHandler = IdIOHandlerStack1
    AutoLogin = True
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    ReadTimeout = 10
    Left = 32
    Top = 16
  end
  object Intercept: TIdConnectionIntercept
    Left = 88
    Top = 16
  end
  object IdIOHandlerStack1: TIdIOHandlerStack
    Destination = ':21'
    MaxLineAction = maException
    Port = 21
    DefaultPort = 0
    ReadTimeout = 10
    Left = 104
    Top = 152
  end
end
