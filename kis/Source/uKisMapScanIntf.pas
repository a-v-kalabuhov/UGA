unit uKisMapScanIntf;

interface

uses
  Classes, Types,
  uKisIntf, uMapScanFiles, uKisTakeBackFiles;

type
  IKisImageCompareViewer = interface
    ['{89DC1A11-1550-4058-B535-26F9EC7035CD}']
    procedure CompareFiles(const MapScan: TMapScanFile);
    function CompareScanFiles(aFileList: TStrings; var Scans: TMapScanArray): Boolean;
    // инструмент для просмотра планшета от заказчика и сравнения его с исходным планшетом
    function CompareTakeBackFile(const aFile: TTakeBackFileInfo): Boolean;
  end;

  IKisTakeBackFileCompareEditor = interface
    ['{AF62A466-421A-428C-9982-C090EB2D66AC}']
    // инструмент для просмотра планшета от заказчика и сравнения его с исходным планшетом
    function Execute(Folders: IKisFolders; var aFile: TTakeBackFileInfo): Boolean;
  end;

implementation

end.
