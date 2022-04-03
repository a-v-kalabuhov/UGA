object frmClipboard: TfrmClipboard
  Left = 368
  Top = 251
  Caption = 'Clipboard Contents'
  ClientHeight = 217
  ClientWidth = 204
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DrawBox1: TEzDrawBox
    Left = 0
    Top = 0
    Width = 204
    Height = 197
    UseThread = False
    Align = alClient
    TabOrder = 0
    SnapToGuidelinesDist = 1.000000000000000000
    ScreenGrid.Step.X = 1.000000000000000000
    ScreenGrid.Step.Y = 1.000000000000000000
    ShowMapExtents = False
    ShowLayerExtents = False
    GridInfo.Grid.X = 1.000000000000000000
    GridInfo.Grid.Y = 1.000000000000000000
    GridInfo.GridColor = clMaroon
    GridInfo.DrawAsCross = True
    GridInfo.GridSnap.X = 0.500000000000000000
    GridInfo.GridSnap.Y = 0.500000000000000000
    RubberPen.Color = clRed
    RubberPen.Mode = pmXor
    ScrollBars = ssNone
    FlatScrollBar = False
  end
  object CmdLine1: TEzCmdLine
    Left = 0
    Top = 197
    Width = 204
    Height = 20
    DrawBoxList = <
      item
        DrawBox = DrawBox1
        Current = True
      end>
    DynamicUpdate = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    Color = clWhite
    Align = alBottom
    TabOrder = 1
    TabStop = False
    Visible = False
  end
  object Launcher1: TEzActionLauncher
    CanDoOsnap = True
    CanDoAccuDraw = True
    MouseDrawElements = [mdCursorFrame, mdFullViewCursor]
    OnMouseDown = Launcher1MouseDown
    OnMouseMove = Launcher1MouseMove
    OnPaint = Launcher1Paint
    OnKeyPress = Launcher1KeyPress
    OnSuspendOperation = Launcher1SuspendOperation
    OnContinueOperation = Launcher1ContinueOperation
    OnFinished = Launcher1Finished
    Left = 100
    Top = 120
  end
end
