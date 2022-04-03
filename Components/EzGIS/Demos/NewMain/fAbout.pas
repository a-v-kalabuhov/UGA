unit fAbout;

{$R CURES.RES}
interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

const
  crEarthCur = 20;

type
  TfrmAbout = class(TForm)
    OKBtn: TButton;
    Label1: TLabel;
    Image1: TImage;
    Image2: TImage;
    LblVersion: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  EzConsts;

{$R *.DFM}

procedure LoadAniCursor;
var
  lpTempDir, lpTempFileName : string;
  nBufferLength : DWORD;
begin
  // GET THE TEMP DIRECTORY OF WINDOWS
  SetLength(lpTempDir, 255);
  nBufferLength := GetTempPath(255, @lpTempDir[1]);
  SetLength(lpTempDir, nBufferLength);

  // GET A TEMPORARY FILE NAME
  SetLength(lpTempFileName, 255);
  GetTempFileName(PChar(lpTempDir), PChar('RES'), 0, @lpTempFileName[1]);

  // define correctly the file extension
  // of the animated cursor
  lpTempFileName := ChangeFileExt(lpTempFileName, '.ani');

{ load the animated cursors from the application.
  we use here the same name of the resource for the temp file }

  // First we read the cursor from the application resources
  // next, the resource is saved to a temp file
  // Now, we load the resource on the array of cursors, object Screen
  with TResourceStream.Create(HInstance, 'EARTHCUR', RT_RCDATA) do
    try
      SaveToFile( lpTempFileName );
    finally
      Free;
    end;
  // use LoadCursorFromFile Win API function
  Screen.Cursors[crEarthCur] := LoadCursorFromFile( PChar(lpTempFileName));

  // delete the temporary file
  SysUtils.DeleteFile(lpTempFileName);
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
    Cursor:= crEarthCur;
    LblVersion.Caption:= EzConsts.SEz_GisVersion;
end;

initialization
  LoadAniCursor;

finalization
  Screen.Cursors[crEarthCur] := 0;

end.
