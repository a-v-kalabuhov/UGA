unit uEcwFuncs;

interface

const
  MAX_PATH = 260;
  ECW_MAX_DATUM_LEN	=	16;
  ECW_MAX_PROJECTION_LEN = 16;
  NCSEcw = 'NCSEcw.DLL';
  NCSEcwC = 'NCSEcwC.dll';
  NCSUtil = 'NCSUtil.dll';
  NCS_SUCCESS = 0;

type
  IEEE4 = Single;
  UINT16 = Word;
  UINT32 = Integer;
  UINT64 = Int64;
  IEEE8 = Double;
  PIEEE4 = ^IEEE4;
  TInputArray = array of IEEE4;
  TppInputArray = array of TInputArray;
  TNCSError = Integer;
  {$MINENUMSIZE 4}
  NCSFileColorSpace = (NCSCS_NONE, NCSCS_GREYSCALE, NCSCS_YUV, NCSCS_MULTIBAND, NCSCS_sRGB, NCSCS_YCbCr);

  CompressFormat = (
    COMPRESS_NONE	= Ord(NCSCS_NONE),
    COMPRESS_UINT8 = Ord(NCSCS_GREYSCALE),
    COMPRESS_YUV = Ord(NCSCS_YUV),
    COMPRESS_MULTI = Ord(NCSCS_MULTIBAND),
    COMPRESS_RGB = Ord(NCSCS_sRGB)
  );
  CompressHint = (
    COMPRESS_HINT_NONE = 0,
    COMPRESS_HINT_FAST = 1,
    COMPRESS_HINT_BEST = 2,
    COMPRESS_HINT_INTERNET = 3
  );
  CellSizeUnits = (
    ECW_CELL_UNITS_INVALID = 0,
    ECW_CELL_UNITS_METERS	=	1,
    ECW_CELL_UNITS_DEGREES = 2,
    ECW_CELL_UNITS_FEET	=	3,
    ECW_CELL_UNITS_UNKNOWN = 4
  );
  PNCSEcwCompressClient = ^TNCSEcwCompressClient;
  TReadCallback = function (pClient: pNCSEcwCompressClient; nNextLine: UINT32; ppInputArray: TppInputArray): Boolean; cdecl;
  TStatusCallback = procedure (pClient: pNCSEcwCompressClient; nCurrentLine: UINT32); cdecl;
  TCancelCallback = function (pClient: pNCSEcwCompressClient): Boolean; cdecl;
  PEcwCompressionTask = ^_EcwCompressionTask;

  _EcwCompressionTask = record
    m_pECWCompressionTask: Pointer;
  end;

  ReadInfo = record
    nPercent: Byte;
  end;

  TNCSEcwCompressClient = record
		szInputFilename: array[0..MAX_PATH - 1] of char;
	  szOutputFilename: array[0..MAX_PATH - 1] of char;
    fTargetCompression: IEEE4;
 		eCompressFormat: CompressFormat;
		eCompressHint: CompressHint;
  	nBlockSizeX: UINT32;
		nBlockSizeY: UINT32;
		nInOutSizeX: UINT32;
		nInOutSizeY: UINT32;
		nInputBands: UINT32;
		nOutputBands: UINT32;
		nInputSize: UINT64;
		fCellIncrementX: IEEE8;
		fCellIncrementY: IEEE8;
		fOriginX: IEEE8;
		fOriginY: IEEE8;
    eCellSizeUnits: CellSizeUnits;
    szDatum: array[0..ECW_MAX_DATUM_LEN - 1] of Char;
    szProjection: array[0..ECW_MAX_PROJECTION_LEN - 1] of Char;
    pReadCallback: TReadCallback;
    pStatusCallback: TStatusCallback;
    pCancelCallback: TCancelCallback;
    pClientData: Pointer;
    pTask: PEcwCompressionTask;
		fActualCompression: IEEE4;
		fCompressionSeconds: IEEE8;
		fCompressionMBSec: IEEE8;
		nOutputSize: UINT64;
  end;
  // common
  procedure NCSecwInit(); cdecl; external NCSEcw;
  procedure NCSecwShutdown(); cdecl; external NCSEcw;
  function NCSGetErrorText(eError: TNCSError): PChar; cdecl; external NCSUtil;
  // compression
  function NCSEcwCompressAllocClient: PNCSEcwCompressClient; cdecl; external NCSEcwC;
  procedure NCSEcwCompressFreeClient(pInfo: PNCSEcwCompressClient); cdecl; external NCSEcwC;
  function NCSEcwCompressOpen(pInfo: PNCSEcwCompressClient; bCalculateSizesOnly: Boolean): TNCSError; cdecl; external NCSEcwC;
  function NCSEcwCompress(pInfo: PNCSEcwCompressClient): TNCSError; cdecl; external NCSEcwC;
  procedure NCSEcwCompressClose(pInfo: PNCSEcwCompressClient); cdecl; external NCSEcwC;
  // decompression
type
  PNCSFileView = Pointer;
  TNCSFileViewFileInfo = record
    nSizeX: UINT32;
    nSizeY: UINT32;
    nBands: UINT16;
    nCompressionRate: UINT16;
    eCellSizeUnits: CellSizeUnits;
    fCellIncrementX: IEEE8;
    fCellIncrementY: IEEE8;
    fOriginX: IEEE8;
    fOriginY: IEEE8;
    szDatum: PChar;
    szProjection: PChar;
  end;
  PNCSFileViewFileInfo = ^TNCSFileViewFileInfo;
  TBandList = array[0..2] of UINT32;
  PBandList = ^TBandList;
  TNCSEcwReadStatus = (
    (** Successful read *)
    NCSECW_READ_OK = 0,
    (** Read failed due to an error *)
    NCSECW_READ_FAILED = 1,
    (** Read was cancelled, either because a new SetView arrived or a
        library shutdown is in progress *)
    NCSECW_READ_CANCELLED	= 2
  );
  PRGBTriplets = ^Byte;

  function NCScbmOpenFileView(szUrlPath: PChar; var NCSFileView: PNCSFileView;
    Callback: Pointer): TNCSError; cdecl; external NCSEcw;
  function NCScbmGetViewFileInfo(NCSFileView: PNCSFileView;
    var NCSFileViewFileInfo: PNCSFileViewFileInfo): TNCSError; cdecl; external NCSEcw;
  function NCScbmSetFileView(NCSFileView: PNCSFileView;
    nBands: UINT32; BandList: Pointer;
    nTLX, nTLY, nBRX, nBRY, nSizeX, nSizeY: UINT32): TNCSError; cdecl; external NCSEcw;
  function NCScbmReadViewLineBGR(NCSFileView: PNCSFileView;
    RGBTriplets: PRGBTriplets): TNCSEcwReadStatus; cdecl; external NCSEcw;
  function NCScbmCloseFileView(NCSFileView: PNCSFileView): TNCSError; cdecl; external NCSEcw;

implementation

end.
