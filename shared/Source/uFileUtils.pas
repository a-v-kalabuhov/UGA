unit uFileUtils;

interface

uses
  Windows, SysUtils, Classes, ActiveX;

type
  ECopyFile = class(Exception)
  private
    FDestination: string;
    FSource: string;
    procedure ProcessFileNames;
  public
    constructor Create(const aMessage, aDest, aSource: string);
    property Destination: string read FDestination write FDestination;
    property Source: string read FSource write FSource;
  end;

  EFile = class(Exception)
  private
    FFileName: string;
  public
    constructor Create(const aMessage, aFileName: string);
    property FileName: string read FFileName write FFileName;
  end;

  TFileUtils = class
  private type
    TFileCopyThread = class(TThread)
    private
      FSource, FTarget: String;
      FStatus: Boolean;
        FOverwrite: Boolean;
    protected
      procedure Execute; override;
    public
      property Overwrite: Boolean read FOverwrite write FOverwrite;
      property Source: String read FSource write FSource;
      property Target: String read FTarget write FTarget;
      property Status: Boolean read FStatus;
    end;
  private
    class function NewTempFile(DoCreateFile: Boolean; Dir: string = ''; Prefix: string = '~'): string;
  public
    class var DontRaiseExceptions: Boolean;
    /// <summary>
    ///   Удаляет все файлы и вложенные папки в папке.
    /// </summary>
    class function ClearDirectory(Path: string; Mask: string = '*'; SubDirectories: Boolean = True): Boolean;
    class function CopyFile(const SourceFile, DestFile: string;
      const OverWrite: Boolean = True; const Async: Boolean = False): Boolean; overload;
    class function CopyFile(const SourceFile, DestFile: string;
      const OverWrite: Boolean; out ErrorMessage: string): Boolean; overload;
    class function CreateTempFile(Dir: string = ''; Prefix: string = '~'): string;
    class function GenerateTempFileName(Dir: string = ''; Prefix: string = '~'): string;
    class function DeleteDirectory(const aDirectory: String; const FailIfDontExists: Boolean = False): Boolean;
    class function DeleteFile(const FileName: String; const FailIfDontExists: Boolean = False): Boolean;
    class function DirUp(const Path: String): String;
    class function GetTempPath: string;
    class function RenameFile(const OldName, NewName: string): Boolean;
    class function ReadFile(const FileName: string): String; 
    class function LoadFile(const FileName: string): TStrings;
    class function WriteFile(const FileName, Data: string): Boolean;
    /// <summary>
    ///   Ищет первый файл, подходящий к маске.
    /// </summary>
    class procedure FindFile(const aMask: string; var aFileName: String);
    /// <summary>
    ///   Ищет файлы, подходящие по маске.
    /// </summary>
    class procedure FindFiles(const aMask: string; Files: TStrings);
    class function GetSpecialFolderLocation(const Folder: Integer; const FolderNew: TGUID): string;
  public type
    TPackFileOption = (packRemoveSource, packOverwrite, packConvertFilenamesToOEM);
    TPackFileOptions = set of TPackFileOption;
  public
    /// <summary>
    ///
    /// </summary>
    class function PackFile(const aFile: string; aZipFile: string = '';
      const Options: TPackFileOptions = []): Boolean;
    class procedure PackDirectory(const Tgt, ZipFiles: string; const ConvertFilenamesToOEM: Boolean);
    class function UnpackFile(const aZipFile: string; const ConvertFilenamesToOEM: Boolean; aDirectory: string = ''): Boolean;
    class function UnpackSingleFile(const aZipFile: string; const ConvertFilenamesToOEM: Boolean; aDirectory: string = ''): String;
    class function UnpackSpecificFile(const aZipFile, aName, aDestinationFileName: string; const ConvertFilenamesToOEM: Boolean): Boolean;
    class function UnpackGetFileList(const aZipFile: string; Files: TStrings; const ConvertFilenamesToOEM: Boolean): Boolean;
  end;

  IPath = interface
    ['{584CC7C3-FFDF-4B77-A76A-ECA86C71C93C}']
    function Finish(const FileName, FileExt: string): IPath; overload;
    function Finish(const FileName: string): IPath; overload;
    function Combine(const aPath: string): IPath;
    function Path(): string;
  end;

  TPath = class
  private type
    TPathImpl = class(TInterfacedObject, IPath)
    private
      FPath: string;
    private
      constructor Create(const aPath: string);
      function Finish(const FileName: string): IPath; overload;
      function Finish(const FileName, FileExt: string): IPath; overload;
      function Combine(const aPath: string): IPath;
      function Path(): string;
    end;
  public
    class function Build(const Path1, Path2: string): IPath; 
    class function Combine(const Path1, Path2: string): string;
    class function Finish(Path1, FileName: string): string; overload;
    class function Finish(Path1, FileName, FileExt: string): string; overload;
  end;

  TFilePath = class
  public
    class function AddPostfix(const aFullFileName, aPostfix: string): string;
    class function FileIsJPEG(const aFileName: string): Boolean;
    class function ReplacePath(const aFullFileName, aNewPath: string): string;
  end;

const
  CSIDL_DESKTOP = $0000;
  CSIDL_INTERNET = $0001;
  CSIDL_PROGRAMS = $0002;
  CSIDL_CONTROLS = $0003;
  CSIDL_PRINTERS = $0004;
  CSIDL_PERSONAL = $0005;
  CSIDL_FAVORITES = $0006;
  CSIDL_STARTUP = $0007;
  CSIDL_RECENT = $0008;
  CSIDL_SENDTO = $0009;
  CSIDL_BITBUCKET = $000a;
  CSIDL_STARTMENU = $000b;
  CSIDL_MYDOCUMENTS = CSIDL_PERSONAL;
  CSIDL_MYMUSIC = $000d;
  CSIDL_MYVIDEO = $000e;
  CSIDL_DESKTOPDIRECTORY = $0010;
  CSIDL_DRIVES = $0011;
  CSIDL_NETWORK = $0012;
  CSIDL_NETHOOD = $0013;
  CSIDL_FONTS = $0014;
  CSIDL_TEMPLATES = $0015;
  CSIDL_COMMON_STARTMENU = $0016;
  CSIDL_COMMON_PROGRAMS = $0017;
  CSIDL_COMMON_STARTUP = $0018;
  CSIDL_COMMON_DESKTOPDIRECTORY = $0019;
  CSIDL_APPDATA = $001a;
  CSIDL_PRINTHOOD = $001b;
  CSIDL_LOCAL_APPDATA = $001c;
  CSIDL_ALTSTARTUP = $001d;
  CSIDL_COMMON_ALTSTARTUP = $001e;
  CSIDL_COMMON_FAVORITES = $001f;
  CSIDL_INTERNET_CACHE = $0020;
  CSIDL_COOKIES = $0021;
  CSIDL_HISTORY = $0022;
  CSIDL_COMMON_APPDATA = $0023;
  CSIDL_WINDOWS = $0024;
  CSIDL_SYSTEM = $0025;
  CSIDL_PROGRAM_FILES = $0026;
  CSIDL_MYPICTURES = $0027;
  CSIDL_PROFILE = $0028;
  CSIDL_SYSTEMX86 = $0029;
  CSIDL_PROGRAM_FILESX86 = $002a;
  CSIDL_PROGRAM_FILES_COMMON = $002b;
  CSIDL_PROGRAM_FILES_COMMONX86 = $002c;
  CSIDL_COMMON_TEMPLATES = $002d;
  CSIDL_COMMON_DOCUMENTS = $002e;
  CSIDL_COMMON_ADMINTOOLS = $002f;
  CSIDL_ADMINTOOLS = $0030;
  CSIDL_CONNECTIONS = $0031;
  CSIDL_COMMON_MUSIC = $0035;
  CSIDL_COMMON_PICTURES = $0036;
  CSIDL_COMMON_VIDEO = $0037;
  CSIDL_RESOURCES = $0038;
  CSIDL_RESOURCES_LOCALIZED = $0039;
  CSIDL_COMMON_OEM_LINKS = $003a;
  CSIDL_CDBURN_AREA = $003b;
  CSIDL_COMPUTERSNEARME = $003d;
  CSIDL_PROFILES = $003e;
  FOLDERID_AddNewPrograms: TGUID = '{DE61D971-5EBC-4F02-A3A9-6C82895E5C04}';
  FOLDERID_AdminTools: TGUID = '{724EF170-A42D-4FEF-9F26-B60E846FBA4F}';
  FOLDERID_AppUpdates: TGUID = '{A305CE99-F527-492B-8B1A-7E76FA98D6E4}';
  FOLDERID_CDBurning: TGUID = '{9E52AB10-F80D-49DF-ACB8-4330F5687855}';
  FOLDERID_ChangeRemovePrograms: TGUID = '{DF7266AC-9274-4867-8D55-3BD661DE872D}';
  FOLDERID_CommonAdminTools: TGUID = '{D0384E7D-BAC3-4797-8F14-CBA229B392B5}';
  FOLDERID_CommonOEMLinks: TGUID = '{C1BAE2D0-10DF-4334-BEDD-7AA20B227A9D}';
  FOLDERID_CommonPrograms: TGUID = '{0139D44E-6AFE-49F2-8690-3DAFCAE6FFB8}';
  FOLDERID_CommonStartMenu: TGUID = '{A4115719-D62E-491D-AA7C-E74B8BE3B067}';
  FOLDERID_CommonStartup: TGUID = '{82A5EA35-D9CD-47C5-9629-E15D2F714E6E}';
  FOLDERID_CommonTemplates: TGUID = '{B94237E7-57AC-4347-9151-B08C6C32D1F7}';
  FOLDERID_ComputerFolder: TGUID = '{0AC0837C-BBF8-452A-850D-79D08E667CA7}';
  FOLDERID_ConflictFolder: TGUID = '{4BFEFB45-347D-4006-A5BE-AC0CB0567192}';
  FOLDERID_ConnectionsFolder: TGUID = '{6F0CD92B-2E97-45D1-88FF-B0D186B8DEDD}';
  FOLDERID_Contacts: TGUID = '{56784854-C6CB-462B-8169-88E350ACB882}';
  FOLDERID_ControlPanelFolder: TGUID = '{82A74AEB-AEB4-465C-A014-D097EE346D63}';
  FOLDERID_Cookies: TGUID = '{2B0F765D-C0E9-4171-908E-08A611B84FF6}';
  FOLDERID_Desktop: TGUID = '{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}';
  FOLDERID_DeviceMetadataStore: TGUID = '{5CE4A5E9-E4EB-479D-B89F-130C02886155}';
  FOLDERID_Documents: TGUID = '{FDD39AD0-238F-46AF-ADB4-6C85480369C7}';
  FOLDERID_DocumentsLibrary: TGUID = '{7B0DB17D-9CD2-4A93-9733-46CC89022E7C}';
  FOLDERID_Downloads: TGUID = '{374DE290-123F-4565-9164-39C4925E467B}';
  FOLDERID_Favorites: TGUID = '{1777F761-68AD-4D8A-87BD-30B759FA33DD}';
  FOLDERID_Fonts: TGUID = '{FD228CB7-AE11-4AE3-864C-16F3910AB8FE}';
  FOLDERID_Games: TGUID = '{CAC52C1A-B53D-4EDC-92D7-6B2E8AC19434}';
  FOLDERID_GameTasks: TGUID = '{054FAE61-4DD8-4787-80B6-090220C4B700}';
  FOLDERID_History: TGUID = '{D9DC8A3B-B784-432E-A781-5A1130A75963}';
  FOLDERID_HomeGroup: TGUID = '{52528A6B-B9E3-4ADD-B60D-588C2DBA842D}';
  FOLDERID_ImplicitAppShortcuts: TGUID = '{BCB5256F-79F6-4CEE-B725-DC34E402FD46}';
  FOLDERID_InternetCache: TGUID = '{352481E8-33BE-4251-BA85-6007CAEDCF9D}';
  FOLDERID_InternetFolder: TGUID = '{4D9F7874-4E0C-4904-967B-40B0D20C3E4B}';
  FOLDERID_Libraries: TGUID = '{1B3EA5DC-B587-4786-B4EF-BD1DC332AEAE}';
  FOLDERID_Links: TGUID = '{BFB9D5E0-C6A9-404C-B2B2-AE6DB6AF4968}';
  FOLDERID_LocalAppData: TGUID = '{F1B32785-6FBA-4FCF-9D55-7B8E7F157091}';
  FOLDERID_LocalAppDataLow: TGUID = '{A520A1A4-1780-4FF6-BD18-167343C5AF16}';
  FOLDERID_LocalizedResourcesDir: TGUID = '{2A00375E-224C-49DE-B8D1-440DF7EF3DDC}';
  FOLDERID_Music: TGUID = '{4BD8D571-6D19-48D3-BE97-422220080E43}';
  FOLDERID_MusicLibrary: TGUID = '{2112AB0A-C86A-4FFE-A368-0DE96E47012E}';
  FOLDERID_NetHood: TGUID = '{C5ABBF53-E17F-4121-8900-86626FC2C973}';
  FOLDERID_NetworkFolder: TGUID = '{D20BEEC4-5CA8-4905-AE3B-BF251EA09B53}';
  FOLDERID_OriginalImages: TGUID = '{2C36C0AA-5812-4B87-BFD0-4CD0DFB19B39}';
  FOLDERID_PhotoAlbums: TGUID = '{69D2CF90-FC33-4FB7-9A0C-EBB0F0FCB43C}';
  FOLDERID_Pictures: TGUID = '{33E28130-4E1E-4676-835A-98395C3BC3BB}';
  FOLDERID_PicturesLibrary: TGUID = '{A990AE9F-A03B-4E80-94BC-9912D7504104}';
  FOLDERID_Playlists: TGUID = '{DE92C1C7-837F-4F69-A3BB-86E631204A23}';
  FOLDERID_PrintersFolder: TGUID = '{76FC4E2D-D6AD-4519-A663-37BD56068185}';
  FOLDERID_PrintHood: TGUID = '{9274BD8D-CFD1-41C3-B35E-B13F55A758F4}';
  FOLDERID_Profile: TGUID = '{5E6C858F-0E22-4760-9AFE-EA3317B67173}';
  FOLDERID_ProgramData: TGUID = '{62AB5D82-FDC1-4DC3-A9DD-070D1D495D97}';
  FOLDERID_ProgramFiles: TGUID = '{905E63B6-C1BF-494E-B29C-65B732D3D21A}';
  FOLDERID_ProgramFilesCommon: TGUID = '{F7F1ED05-9F6D-47A2-AAAE-29D317C6F066}';
  FOLDERID_ProgramFilesCommonX64: TGUID = '{6365D5A7-0F0D-45E5-87F6-0DA56B6A4F7D}';
  FOLDERID_ProgramFilesCommonX86: TGUID = '{DE974D24-D9C6-4D3E-BF91-F4455120B917}';
  FOLDERID_ProgramFilesX64: TGUID = '{6D809377-6AF0-444B-8957-A3773F02200E}';
  FOLDERID_ProgramFilesX86: TGUID = '{7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}';
  FOLDERID_Programs: TGUID = '{A77F5D77-2E2B-44C3-A6A2-ABA601054A51}';
  FOLDERID_Public: TGUID = '{DFDF76A2-C82A-4D63-906A-5644AC457385}';
  FOLDERID_PublicDesktop: TGUID = '{C4AA340D-F20F-4863-AFEF-F87EF2E6BA25}';
  FOLDERID_PublicDocuments: TGUID = '{ED4824AF-DCE4-45A8-81E2-FC7965083634}';
  FOLDERID_PublicDownloads: TGUID = '{3D644C9B-1FB8-4F30-9B45-F670235F79C0}';
  FOLDERID_PublicGameTasks: TGUID = '{DEBF2536-E1A8-4C59-B6A2-414586476AEA}';
  FOLDERID_PublicLibraries: TGUID = '{48daf80b-e6cf-4f4e-b800-0e69d84ee384}';
  FOLDERID_PublicMusic: TGUID = '{3214FAB5-9757-4298-BB61-92A9DEAA44FF}';
  FOLDERID_PublicPictures: TGUID = '{B6EBFB86-6907-413C-9AF7-4FC2ABF07CC5}';
  FOLDERID_PublicRingtones: TGUID = '{E555AB60-153B-4D17-9F04-A5FE99FC15EC}';
  FOLDERID_PublicVideos: TGUID = '{2400183A-6185-49FB-A2D8-4A392A602BA3}';
  FOLDERID_QuickLaunch: TGUID = '{52A4F021-7B75-48A9-9F6B-4B87A210BC8F}';
  FOLDERID_Recent: TGUID = '{AE50C081-EBD2-438A-8655-8A092E34987A}';
  FOLDERID_RecordedTVLibrary: TGUID = '{1A6FDBA2-F42D-4358-A798-B74D745926C5}';
  FOLDERID_RecycleBinFolder: TGUID = '{B7534046-3ECB-4C18-BE4E-64CD4CB7D6AC}';
  FOLDERID_ResourceDir: TGUID = '{8AD10C31-2ADB-4296-A8F7-E4701232C972}';
  FOLDERID_Ringtones: TGUID = '{C870044B-F49E-4126-A9C3-B52A1FF411E8}';
  FOLDERID_RoamingAppData: TGUID = '{3EB685DB-65F9-4CF6-A03A-E3EF65729F3D}';
  FOLDERID_SampleMusic: TGUID = '{B250C668-F57D-4EE1-A63C-290EE7D1AA1F}';
  FOLDERID_SamplePictures: TGUID = '{C4900540-2379-4C75-844B-64E6FAF8716B}';
  FOLDERID_SamplePlaylists: TGUID = '{15CA69B3-30EE-49C1-ACE1-6B5EC372AFB5}';
  FOLDERID_SampleVideos: TGUID = '{859EAD94-2E85-48AD-A71A-0969CB56A6CD}';
  FOLDERID_SavedGames: TGUID = '{4C5C32FF-BB9D-43B0-B5B4-2D72E54EAAA4}';
  FOLDERID_SavedSearches: TGUID = '{7D1D3A04-DEBB-4115-95CF-2F29DA2920DA}';
  FOLDERID_SEARCH_CSC: TGUID = '{EE32E446-31CA-4ABA-814F-A5EBD2FD6D5E}';
  FOLDERID_SEARCH_MAPI: TGUID = '{98EC0E18-2098-4D44-8644-66979315A281}';
  FOLDERID_SearchHome: TGUID = '{190337D1-B8CA-4121-A639-6D472D16972A}';
  FOLDERID_SendTo: TGUID = '{8983036C-27C0-404B-8F08-102D10DCFD74}';
  FOLDERID_SidebarDefaultParts: TGUID = '{7B396E54-9EC5-4300-BE0A-2482EBAE1A26}';
  FOLDERID_SidebarParts: TGUID = '{A75D362E-50FC-4FB7-AC2C-A8BEAA314493}';
  FOLDERID_StartMenu: TGUID = '{625B53C3-AB48-4EC1-BA1F-A1EF4146FC19}';
  FOLDERID_Startup: TGUID = '{B97D20BB-F46A-4C97-BA10-5E3608430854}';
  FOLDERID_SyncManagerFolder: TGUID = '{43668BF8-C14E-49B2-97C9-747784D784B7}';
  FOLDERID_SyncResultsFolder: TGUID = '{289A9A43-BE44-4057-A41B-587A76D7E7F9}';
  FOLDERID_SyncSetupFolder: TGUID = '{0F214138-B1D3-4A90-BBA9-27CBC0C5389A}';
  FOLDERID_System: TGUID = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}';
  FOLDERID_SystemX86: TGUID = '{D65231B0-B2F1-4857-A4CE-A8E7C6EA7D27}';
  FOLDERID_Templates: TGUID = '{A63293E8-664E-48DB-A079-DF759E0509F7}';
  FOLDERID_UserPinned: TGUID = '{9E3995AB-1F9C-4F13-B827-48B24B6C7174}';
  FOLDERID_UserProfiles: TGUID = '{0762D272-C50A-4BB0-A382-697DCD729B80}';
  FOLDERID_UserProgramFiles: TGUID = '{5CD7AEE2-2219-4A67-B85D-6C9CE15660CB}';
  FOLDERID_UserProgramFilesCommon: TGUID = '{BCBD3057-CA5C-4622-B42D-BC56DB0AE516}';
  FOLDERID_UsersFiles: TGUID = '{F3CE0F7C-4901-4ACC-8648-D5D44B04EF8F}';
  FOLDERID_UsersLibraries: TGUID = '{A302545D-DEFF-464B-ABE8-61C8648D939B}';
  FOLDERID_Videos: TGUID = '{18989B1D-99B5-455B-841C-AB7C74E4DDFC}';
  FOLDERID_VideosLibrary: TGUID = '{491E922F-5643-4AF4-A7EB-4E7A138D8174}';
  FOLDERID_Windows: TGUID = '{F38BF404-1D43-42F2-9305-67DE0B28FC23}';

implementation

uses
  SciZipFile;

{ TFileUtils }

class function TFileUtils.ClearDirectory(Path: string; Mask: string = '*'; SubDirectories: Boolean = True): Boolean;
var
  F: TSearchRec;
  I, C: Integer;
begin
  Result := False;
  C := 0;
  Path := IncludeTrailingPathDelimiter(Path);
  I := FindFirst(Path + Mask, faAnyFile, F);
  while I = 0 do
  begin
    if (F.Name <> '..') and (F.Name <> '.') then
    begin
      if DirectoryExists(Path + F.Name) then
      begin
        Inc(C);
        if SubDirectories then
        begin
          if ClearDirectory(Path + F.Name) then
          begin
            if DeleteDirectory(Path + F.Name, False) then
            begin
              if (C = 1) then
                Result := True;
            end
            else
              Result := False;
          end
          else
          begin
            Result := False;
          end;
        end;
      end
      else
      begin
        if DeleteFile(Path + F.Name, False) then
        begin
          if (C = 1) then
            Result := True;
        end
        else
          Result := False;
      end;
    end;
    I := FindNext(F);
  end;
  FindClose(F);
  //
  if (not Result) and (C = 0) then
    Result := True;
end;

class function TFileUtils.CopyFile(const SourceFile, DestFile: string;
  const OverWrite: Boolean; const Async: Boolean): Boolean;
var
  LastError: Cardinal;
  Thrd: TFileCopyThread;
begin
  if Async then
  begin
    Thrd := TFileCopyThread.Create(True);
    Thrd.FreeOnTerminate := True;
    Thrd.Source := SourceFile;
    Thrd.Target := DestFile;
    Thrd.Overwrite := OverWrite;
    Thrd.Resume;
    Result := True;
  end
  else
  begin
    Result := Windows.CopyFile(PChar(SourceFile), PChar(DestFile), not OverWrite);
    if not Result then
    begin
      if not DontRaiseExceptions then
      begin
        LastError := GetLastError;
        if LastError <> 0 then
          raise ECopyFile.Create('Системный сбой. Код '
            + IntToStr(LastError) + '.' + sLineBreak + SysErrorMessage(LastError),
            DestFile, SourceFile)
        else
          RaiseLastOSError(LastError);
      end;
    end;
  end;
end;

class function TFileUtils.CopyFile(const SourceFile, DestFile: string; const OverWrite: Boolean;
  out ErrorMessage: string): Boolean;
var
  LastError: Cardinal;
begin
  ErrorMessage := '';
  Result := Windows.CopyFile(PChar(SourceFile), PChar(DestFile), not OverWrite);
  if not Result then
  begin
    LastError := GetLastError;
      ErrorMessage :=
        'Системный сбой. Код ' + IntToStr(LastError) + '.' + sLineBreak;
    if LastError <> 0 then
      ErrorMessage := ErrorMessage + SysErrorMessage(LastError)
    else
      ErrorMessage := ErrorMessage + 'Неизвестная ошибка!';
    if not DontRaiseExceptions then
    begin
      if LastError <> 0 then
        raise ECopyFile.Create('Системный сбой. Код '
          + IntToStr(LastError) + '.' + sLineBreak + SysErrorMessage(LastError),
          DestFile, SourceFile)
      else
        RaiseLastOSError(LastError);
    end;
  end;
end;

class function TFileUtils.CreateTempFile(Dir, Prefix: string): string;
var
  LastError: Cardinal;
  Tmp: string;
begin
  Result := NewTempFile(True, Dir, Prefix);
  Exit;
  if Trim(Dir) = '' then
    Dir := GetTempPath;
  SetLength(Tmp, MAX_PATH);
  if Windows.GetTempFileName(PChar(Dir), PChar(Prefix), 0, PChar(Tmp)) = 0 then
  if not DontRaiseExceptions then
  begin
    LastError := GetLastError;
    if LastError <> 0 then
      raise EFile.Create('Системный сбой. Код '
        + IntToStr(LastError) + '.' + sLineBreak + SysErrorMessage(LastError)
        + sLineBreak + 'Невозможно создать временный файл в каталоге:'
        + sLineBreak + Dir,
        Dir)
    else
      RaiseLastOSError(LastError);
  end;
  Result := StrPas(PChar(Tmp));
end;

class function TFileUtils.DeleteDirectory(const aDirectory: String; const FailIfDontExists: Boolean): Boolean;
var
  LastError: Cardinal;
begin
  if not DirectoryExists(aDirectory) then
  begin
    if FailIfDontExists then
    begin
      raise EFile.Create('Папка не существует!', aDirectory);
    end
    else
      Result := True;
    Exit;
  end;
  ClearDirectory(aDirectory);
  Result := RemoveDirectory(PChar(aDirectory));
  if not Result then
  begin
    if not DontRaiseExceptions then
    begin
      LastError := GetLastError;
      if LastError <> 0 then
        raise EFile.Create('Системный сбой. Код '
          + IntToStr(LastError) + '.' + sLineBreak + SysErrorMessage(LastError)
          + sLineBreak + 'Невозможно удалить каталог.',
          '')
      else
        RaiseLastOSError(LastError);
    end;
  end;
end;

class function TFileUtils.DeleteFile(const FileName: string; const FailIfDontExists: Boolean = False): Boolean;
var
  LastError: Cardinal;
begin
  if FileExists(FileName) then
  begin
    Result := Windows.DeleteFile(PChar(FileName));
    if not Result then
    if not DontRaiseExceptions then
    begin
      LastError := GetLastError;
      if LastError <> 0 then
        raise EFile.Create('Системный сбой. Код '
          + IntToStr(LastError) + '.' + sLineBreak + SysErrorMessage(LastError)
          + sLineBreak + 'Невозможно удалить файл.',
          '')
      else
        RaiseLastOSError(LastError);
    end;
  end
  else
    if FailIfDontExists then
    begin
//      Result := False;
      raise EFile.Create('Файл не существует!', FileName);
    end
    else
      Result := True;
end;

class function TFileUtils.DirUp(const Path: String): String;
var
  I, L: Integer;
begin
  if Path[Length(Path)] = PathDelim then
    L := Pred(Length(Path))
  else
    L := Length(Path);
  for I := L downto 1 do
  if Path[I] = PathDelim then
  begin
    Result := Copy(Path, 1, I);
    Break;
  end;
end;

class procedure TFileUtils.FindFile(const aMask: string; var aFileName: String);
var
  F: TSearchRec;
begin
  if FindFirst(aMask, faAnyFile, F) = 0 then
    aFileName := F.Name            
  else
    aFileName := '';
  FindClose(F);
end;

class procedure TFileUtils.FindFiles(const aMask: string; Files: TStrings);
var
  F: TSearchRec;
  I: Integer;
begin
  I := FindFirst(aMask, faAnyFile, F);
  while I = 0 do
  begin
    Files.Add(F.Name);
    I := FindNext(F);
  end;
  FindClose(F);
end;

class function TFileUtils.GenerateTempFileName(Dir, Prefix: string): string;
var
  LastError: Cardinal;
  Tmp: string;
begin
  Result := NewTempFile(False, Dir, Prefix);
  Exit;
  if Trim(Dir) = '' then
    Dir := GetTempPath;
  SetLength(Tmp, MAX_PATH);
  if Windows.GetTempFileName(PChar(Dir), PChar(Prefix), 1, PChar(Tmp)) = 0 then
  if not DontRaiseExceptions then
  begin
    LastError := GetLastError;
    if LastError <> 0 then
      raise EFile.Create('Системный сбой. Код '
        + IntToStr(LastError) + '.' + sLineBreak + SysErrorMessage(LastError)
        + sLineBreak + 'Невозможно создать временный файл в каталоге:'
        + sLineBreak + Dir,
        Dir)
    else
      RaiseLastOSError(LastError);
  end;
  Result := StrPas(PChar(Tmp));
end;

class function TFileUtils.GetSpecialFolderLocation(const Folder: Integer;
  const FolderNew: TGUID): string;
const
  KF_FLAG_DONT_VERIFY = $00004000;
var
  FolderPath: PWideChar;
  SHGetFolderPath: function(hwnd: HWND; csidl: Integer; hToken: THandle; dwFlags: DWORD; pszPath: PWideChar): HResult; stdcall;
  SHGetKnownFolderPath: function(const rfid: TIID; dwFlags: DWORD; hToken: THandle; var ppszPath: PWideChar): HRESULT; stdcall;
begin
  Result := '';

  if not CompareMem(@FolderNew, @GUID_NULL, SizeOf(TGUID)) then
  begin
    SHGetKnownFolderPath := GetProcAddress(GetModuleHandle('Shell32.dll'), 'SHGetKnownFolderPath');
    if Assigned(SHGetKnownFolderPath) then
    begin
      FolderPath := nil;
      SetLastError(Cardinal(SHGetKnownFolderPath(FolderNew, KF_FLAG_DONT_VERIFY, 0, FolderPath)));
      if Succeeded(HRESULT(GetLastError)) then
      begin
        Result := FolderPath;
        CoTaskMemFree(FolderPath);
      end;
    end;
  end;

  if (Result = '') and (Folder >= 0) then
  begin
    SHGetFolderPath := GetProcAddress(GetModuleHandle('Shell32.dll'), 'SHGetFolderPathW');
    if Assigned(SHGetFolderPath) then
    begin
      FolderPath := AllocMem((MAX_PATH + 1) * SizeOf(WideChar));
      SetLastError(Cardinal(SHGetFolderPath(0, Folder, 0, 0, FolderPath)));
      if Succeeded(HRESULT(GetLastError)) then
        Result := FolderPath;
      FreeMem(FolderPath);
    end;
  end;

  if Result <> '' then
    Result := IncludeTrailingPathDelimiter(Result);
end;

class function TFileUtils.GetTempPath: string;
var
  LastError: Cardinal;
  Tmp: string;
begin
  SetLength(Tmp, MAX_PATH);
  if Windows.GetTempPath(MAX_PATH, PChar(Tmp)) = 0 then
  if not DontRaiseExceptions then
  begin
    LastError := GetLastError;
    if LastError <> 0 then
      raise EFile.Create('Системный сбой. Код '
        + IntToStr(LastError) + '.' + sLineBreak + SysErrorMessage(LastError)
        + sLineBreak + 'Невозможно получить ссылку на временный каталог.',
        '')
    else
      RaiseLastOSError(LastError);
  end;
  Result := PChar(Tmp);
  Result := IncludeTrailingPathDelimiter(Result);
end;

class procedure TFileUtils.PackDirectory(const Tgt, ZipFiles: string; const ConvertFilenamesToOEM: Boolean);
var
  S, Buffer: string;
  Files: TStringList;
  Zip: TZipFile;
  I, J: Integer;
  FileStream: TFileStream; 
begin
  S := TPath.Finish(ZipFiles, '*');
  Files := TStringList.Create;
  try
    FindFiles(S, Files);
    Zip := TZipFile.Create;
    try
      for I := 0 to Files.Count - 1 do
      begin
        if (Files[I] <> '.') and (Files[I] <> '..') then
        begin
          S := TPath.Finish(ZipFiles, Files[I]);
          Zip.AddFile(Files[I]);
          //
          FileStream := TFileStream.Create(S, fmOpenRead);
          try
            if FileStream.Size > 0 then
            begin
              SetLength(Buffer, FileStream.Size);
              FileStream.Read(Buffer[1], FileStream.Size);
            end;
          finally
            FileStream.Free;
          end;
          J := Zip.IndexOfName(Files[I]);
          Zip.Uncompressed[J] := Buffer;
        end;
      end;
      Zip.SaveToFile(Tgt, ConvertFilenamesToOEM);
    finally
      Zip.Free;
    end;
  finally
    Files.Free;
  end;
end;

class function TFileUtils.PackFile(const aFile: string; aZipFile: string; const Options: TPackFileOptions): Boolean;
begin
  Result := False;
  if FileExists(aFile) then
  begin
    if aZipFile = '' then
      aZipFile := ChangeFileExt(aFile, '.zip');
    if packOverwrite in Options then
      if FileExists(aZipFile) then
        DeleteFile(aZipFile);
    SciZipFile.ZipFile(aFile, packConvertFilenamesToOEM in Options, aZipFile);
//    SciZipFile.ZipFile(aFile, aZipFile);
    if packRemoveSource in Options then
      DeleteFile(aFile);
    Result := True;
  end;
end;

class function TFileUtils.ReadFile(const FileName: string): String;
var
  FileStr: TFileStream;
  DataStr: TStringStream;
begin
  Result := '';
  try
    FileStr := TFileStream.Create(FileName, fmOpenRead);
    DataStr := TStringStream.Create(Result);
    try
      DataStr.CopyFrom(FileStr, 0);
      Result := DataStr.DataString;
    finally
      FreeAndNil(DataStr);
      FreeAndNil(FileStr);
    end;
  except
    if not DontRaiseExceptions then
      raise;
  end;
end;

class function TFileUtils.LoadFile(const FileName: string): TStrings;
begin
  Result := TStringList.Create;
  try
    Result.LoadFromFile(FileName);
  except
    Result.Free;
    raise;
  end;
end;

class function TFileUtils.NewTempFile(DoCreateFile: Boolean; Dir, Prefix: string): string;
var
  LastError: Cardinal;
  Tmp: string;
  Unique: Cardinal;
begin
  if Trim(Dir) = '' then
    Dir := GetTempPath;
  SetLength(Tmp, MAX_PATH);
  if DoCreateFile then
    Unique := 0
  else
    Unique := 1;
  if Windows.GetTempFileName(PChar(Dir), PChar(Prefix), Unique, PChar(Tmp)) = 0 then
  if not DontRaiseExceptions then
  begin
    LastError := GetLastError;
    if LastError <> 0 then
      raise EFile.Create('Системный сбой. Код '
        + IntToStr(LastError) + '.' + sLineBreak + SysErrorMessage(LastError)
        + sLineBreak + 'Невозможно создать временный файл в каталоге:'
        + sLineBreak + Dir,
        Dir)
    else
      RaiseLastOSError(LastError);
  end;
  Result := StrPas(PChar(Tmp));
end;

class function TFileUtils.RenameFile(const OldName, NewName: string): Boolean;
var
  LastError: Cardinal;
begin
  Result := Windows.MoveFile(PChar(OldName), PChar(NewName));
  if not Result then
  if not DontRaiseExceptions then
  begin
    LastError := GetLastError;
    if LastError <> 0 then
      raise ECopyFile.Create('Системный сбой. Код '
        + IntToStr(LastError) + '.' + sLineBreak + SysErrorMessage(LastError),
        OldName, NewName)
    else
      RaiseLastOSError(LastError);
  end;
end;

class function TFileUtils.UnpackFile(const aZipFile: string; const ConvertFilenamesToOEM: Boolean; aDirectory: string = ''): Boolean;
begin
  if aDirectory = '' then
    aDirectory := ExtractFilePath(aZipFile);
  aDirectory := IncludeTrailingPathDelimiter(aDirectory);
  SciZipFile.UnzipFile(aZipFile, aDirectory, ConvertFilenamesToOEM);
  Result := True;
end;

class function TFileUtils.UnpackGetFileList(const aZipFile: string; Files: TStrings; const ConvertFilenamesToOEM: Boolean): Boolean;
var
  aZip: TZipFile;
  I: Integer;
begin
  Result := False;
  if not Assigned(Files) then
    Exit;
  aZip := TZipFile.Create;
  try
    aZip.LoadFromFile(aZipFile, ConvertFilenamesToOEM);
    for I := 0 to aZip.Count - 1 do
      Files.Add(aZip.Name[I]);
    Result := True;
  finally
    aZip.Free;
  end;
end;

class function TFileUtils.UnpackSingleFile(const aZipFile: string; const ConvertFilenamesToOEM: Boolean; aDirectory: string): String;
var
  S: String;
begin
  Result := '';
  if aDirectory = '' then
    aDirectory := ExtractFilePath(aZipFile);
  aDirectory := IncludeTrailingPathDelimiter(aDirectory);
  with TZipFile.Create do
  try
    LoadFromFile(aZipFile, ConvertFilenamesToOEM);
    if Count > 0 then
    begin
      Result := aDirectory + Name[0];
      with TFileStream.Create(aDirectory + Name[0], fmCreate) do
      try
        S := Uncompressed[0];
        if Length(S) > 0 then
          Write(S[1], Length(S));
      finally
        Free;
      end;
    end;
  finally
    Free;
  end;
end;

class function TFileUtils.UnpackSpecificFile(const aZipFile, aName, aDestinationFileName: string; const ConvertFilenamesToOEM: Boolean): Boolean;
var
  aZip: TZipFile;
  I: Integer;
  S: string;
begin
  aZip := TZipFile.Create;
  try
    aZip.LoadFromFile(aZipFile, ConvertFilenamesToOEM);
    I := aZip.IndexOfName(aName);
    if I >= 0 then
    begin
      with TFileStream.Create(aDestinationFileName, fmCreate) do
      try
        S := aZip.Uncompressed[I];
        Write(S[1], Length(S));
      finally
        Free;
      end;
    end;
    Result := True;
  finally
    aZip.Free;
  end;
end;

class function TFileUtils.WriteFile(const FileName, Data: string): Boolean;
var
  FileStr, DataStr: TStream;
begin
  try
    FileStr := TFileStream.Create(FileName, fmCreate);
    DataStr := TStringStream.Create(Data);
    try
      FileStr.CopyFrom(DataStr, 0);
      Result := True;
    finally
      FreeAndNil(DataStr);
      FreeAndNil(FileStr);
    end;
  except
    if DontRaiseExceptions then
      Result := False
    else
      raise;
  end;
end;

{ ECopyFile }

constructor ECopyFile.Create(const aMessage, aDest, aSource: string);
begin
  inherited Create(aMessage);
  FDestination := aDest;
  FSource := aSource;
  ProcessFileNames;
end;

procedure ECopyFile.ProcessFileNames;
begin
  if FDestination <> '' then
    Message := Message + sLineBreak + 'Копирование файла:' + sLineBreak + ' из '
    + FSource + sLineBreak + ' в ' + FDestination;
end;

{ EFile }

constructor EFile.Create(const aMessage, aFileName: string);
begin
  inherited Create(aMessage + sLineBreak + aFileName);
  FFileName := aFileName;
end;

{ TFileUtils.TFileCopyThread }

procedure TFileUtils.TFileCopyThread.Execute;
begin
  inherited;
  FStatus := Windows.CopyFile(PChar(FSource), PChar(FTarget), not FOverwrite);
end;

{ TPath }

class function TPath.Build(const Path1, Path2: string): IPath;
begin
  Result := TPathImpl.Create(TPath.Combine(Path1, Path2));
end;

class function TPath.Combine(const Path1, Path2: string): string;
begin
  Result := IncludeTrailingPathDelimiter(Path1) + Path2;
  Result := IncludeTrailingPathDelimiter(Result);
end;

class function TPath.Finish(Path1, FileName: string): string;
begin
  if FileName = '' then
    EFile.Create('Пустое имя файла!', Path1);
  Result := Path1;
  if Result <> '' then
    Result := IncludeTrailingPathDelimiter(Result);
  Result := Result + FileName;
end;

class function TPath.Finish(Path1, FileName, FileExt: string): string;
var
  DotExt, DotFile: Boolean;
begin
  if FileName = '' then
    EFile.Create('Пустое имя файла!', Path1);
  Result := FileName; 
  if FileExt <> '' then
  begin
    DotExt := FileExt[1] = '.';
    DotFile := FileName[Length(FileName)] = '.';
    if DotExt and DotFile then
      Delete(FileExt, 1, 1);
    if not (DotExt or DotFile) then
      Result := Result + '.';
    Result := Result + FileExt;
  end;
  Result := TPath.Finish(Path1, Result);
end;

{ TPath.TPathImpl }

constructor TPath.TPathImpl.Create(const aPath: string);
begin
  FPath := aPath;
end;

function TPath.TPathImpl.Finish(const FileName: string): IPath;
begin
  Result := TPath.TPathImpl.Create(TPath.Finish(FPath, FileName));
end;

function TPath.TPathImpl.Finish(const FileName, FileExt: string): IPath;
begin
  Result := TPath.TPathImpl.Create(TPath.Finish(FPath, FileName, FileExt));
end;

function TPath.TPathImpl.Path: string;
begin
  Result := FPath;
end;

function TPath.TPathImpl.Combine(const aPath: string): IPath;
begin
  Result := TPath.TPathImpl.Create(TPath.Combine(FPath, aPath));
end;

{ TFilePath }

class function TFilePath.AddPostfix(const aFullFileName, aPostfix: string): string;
var
  FPath: string;
  FName: string;
  FExt: string;
begin
  Result := aFullFileName;
  FPath := ExtractFilePath(aFullFileName);
  FName := ExtractFileName(aFullFileName);
  FExt := ExtractFileExt(aFullFileName);
  if FExt <> '' then
    SetLength(FName, Length(FName) - Length(FExt));
  FName := FName + aPostfix + FExt;
  if FPath <> '' then
    Result := TPath.Finish(FPath, FName)
  else
    Result := FName;
end;

class function TFilePath.FileIsJPEG(const aFileName: string): Boolean;
var
  Ext: string;
begin
  Ext := AnsiUpperCase(ExtractFileExt(aFileName));
  Result := (Ext = '.JPG') or (Ext = '.JPEG') or (Ext = '.JPE');  
end;

class function TFilePath.ReplacePath(const aFullFileName, aNewPath: string): string;
begin
  Result := TPath.Finish(aNewPath, ExtractFileName(aFullFileName));
end;

end.
