object MStClientAppModule: TMStClientAppModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 150
  Width = 215
  object GIS: TEzGIS
    Active = False
    LayersSubdir = 'C:\Program Files\Borland\Delphi7\Bin\'
    OnBeforePaintEntity = GISBeforePaintEntity
    OnAfterPaintEntity = GISAfterPaintEntity
    OnCurrentLayerChange = GISCurrentLayerChange
    Left = 136
    Top = 8
  end
  object ApplicationEvents: TApplicationEvents
    OnException = ApplicationEventsException
    Left = 48
    Top = 8
  end
end
