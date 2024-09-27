object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Process XML test'
  ClientHeight = 442
  ClientWidth = 667
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    667
    442)
  PixelsPerInch = 96
  TextHeight = 13
  object edInputXML: TMemo
    Left = 8
    Top = 8
    Width = 649
    Height = 258
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      '<?xml version="1.0" encoding="UTF-8"?>'
      '<cadsofttools version="2">'
      '  <!-- Saves using XML export parametrs -->'
      '  <!-- Saves as GCode -->'
      '  <save>'
      
        '      <ExportParams FileName="%SGDRAWINGSPATH%\ImageGCode" Forma' +
        't=".nc">'
      
        '         <!--MachineType: 0: milling machine; 1: cutting machine' +
        '; -->'
      '         <MachineTypeID>0</MachineTypeID>   '
      '   <!--PassesDirectionID: 0: 1: -->'
      '   <PassesDirectionID>0</PassesDirectionID>'
      '         <Precision>2</Precision>'
      '         <FeedOnZ>2000</FeedOnZ>'
      '         <FeedMillOnXY>100</FeedMillOnXY>'
      '         <FeedCutOnXY>0</FeedCutOnXY>     '
      '         <SpindleSpeed>2000</SpindleSpeed>'
      '         <DepthOnZ>-2</DepthOnZ>'
      '         <DepthPass>2</DepthPass> '
      '         <NumbOfPasses>1</NumbOfPasses> '
      '         <DepartureOnZ>5</DepartureOnZ>'
      
        '         <!--WorkpieceZeroPointID: 0: origin; 1: top left; 2: to' +
        'p right; 3: bottom left; 4: bottom right; -->'
      '         <WorkpieceZeroPointID>0</WorkpieceZeroPointID>'
      '         <ZeroPointOffset>50,10</ZeroPointOffset>'
      '         <LaserOnCommand>M3</LaserOnCommand>'
      '         <LaserOffCommand>M5</LaserOffCommand>'
      '         <UseLaserPower>False</UseLaserPower>   '
      '         <LaserPower>128</LaserPower>      '
      '         <Delay>500</Delay>'
      
        '   <!--UnitsID: 0: Millimetre; 1: Centimetre; 2: Metre; 3: Inch;' +
        ' -->'
      '         <MachineUnitsID>0</MachineUnitsID>          '
      '         <DrawingUnitsID>0</DrawingUnitsID>      '
      '         <AddLabelOfProgam>False</AddLabelOfProgam>   '
      '         <LabelOfProgram>001</LabelOfProgram>'
      '         <AddNumbering>False</AddNumbering>'
      '         <ShowComments>True</ShowComments>'
      '         <ShowPercent>True</ShowPercent>   '
      '         <StartNumber>5</StartNumber>   '
      '         <StepOfNumbering>5</StepOfNumbering> '
      '      </ExportParams>'
      '  </save>'
      '</cadsofttools>')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object edOutputXML: TMemo
    Left = 8
    Top = 272
    Width = 649
    Height = 138
    Anchors = [akLeft, akRight, akBottom]
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object btnOpen: TButton
    Left = 8
    Top = 416
    Width = 75
    Height = 23
    Anchors = [akLeft, akBottom]
    Caption = 'Open'
    TabOrder = 2
    OnClick = btnOpenClick
  end
  object btnProcessXML: TButton
    Left = 170
    Top = 416
    Width = 75
    Height = 23
    Anchors = [akLeft, akBottom]
    Caption = 'Run'
    TabOrder = 4
    OnClick = btnProcessXMLClick
  end
  object btnNew: TButton
    Left = 89
    Top = 416
    Width = 75
    Height = 23
    Anchors = [akLeft, akBottom]
    Caption = 'New'
    TabOrder = 3
    OnClick = btnNewClick
  end
  object OpenDialog: TOpenDialog
    Filter = 'CAD files|*.dwg;*.dxf'
    Left = 32
    Top = 24
  end
end
