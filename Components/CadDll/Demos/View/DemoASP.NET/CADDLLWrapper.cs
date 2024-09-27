using System;
using System.Runtime.InteropServices;
using System.Text;

namespace CADDLLWrapper
{
    /// <summary>
    /// C# wrapper for cad.dll
    /// </summary>
    public static class CADImage
    {
        private const string dllName = "cad.dll";

        #region Properties

        private static bool _bUseSHXFonts = true;
        private static string _strLastError;

        public static bool UseShxFonts
        {
            get { return _bUseSHXFonts; }
            set { _bUseSHXFonts = value; }
        }

        public static string LastErrorString
        {
            get { return _strLastError; }
        }

        #endregion

        #region CADImage.dll import section

        [StructLayout(LayoutKind.Sequential, Pack = 1)]
        public struct CadExportParams
        {
            [MarshalAs(UnmanagedType.R8)]
            public double XScale;

            [MarshalAs(UnmanagedType.I1)]
            public byte Units;

            [MarshalAs(UnmanagedType.FunctionPtr)]
            public OnProgressChange ProgressFunc;
        }

        public delegate Int32 OnProgressChange([MarshalAs(UnmanagedType.I1)] byte percentDone);

        /// <summary>Create a new CADImage object and loads it from the specified file.</summary>
        /// 
        /// <param name="hWindow">Identifies the window that will get system messages during the 
        /// loading of file. Usually it is the main window of client application. 
        /// If no file is specified, hWindow can be NULL.</param>
        /// <param name="lpFileName">Specifies the CAD file name.</param>
        /// 
        /// <returns>If the function succeeds, the return value is a handle of new CADImage object. 
        /// If the function fails, the return value is NULL.</returns>
        /// 
        [DllImport(dllName, EntryPoint = "CreateCAD", CharSet = CharSet.Ansi)]
        private static extern IntPtr CreateCAD(
            IntPtr hWindow,
            [MarshalAs(UnmanagedType.LPWStr)] string lpFileName // multibyte
            );

        /// <summary>Create a new CADImage object and loads it from the specified file.</summary>
        /// 
        /// <param name="hWindow">Identifies the window that will get system messages during the 
        /// loading of file. Usually it is the main window of client application. 
        /// If no file is specified, hWindow can be NULL.</param>
        /// <param name="hMem">Specifies the CAD file name or contans a pointer to loaded data.</param>
        /// <param name="lpExt">Points to a null-terminated string that specifies an extension for CAD file name to be loaded.</param>
        /// 
        /// <returns>If the function succeeds, the return value is a handle of new CADImage object. 
        /// If the function fails, the return value is NULL. </returns>
        /// 
        [DllImport(dllName, EntryPoint = "CreateCADEx", CharSet = CharSet.Ansi)]
        private static extern IntPtr CreateCADEx(
            IntPtr hWindow,
            IntPtr hMem,
            [MarshalAs(UnmanagedType.LPWStr)] string lpExt // multibyte
            );

        /// <summary>Close an open CADImage object handle.</summary>
        /// 
        /// <param name="hObject">Identifies an opened CADImage object handle.</param>
        /// 
        /// <returns>If the function succeeds, the return value is nonzero.
        /// If the function fails, the return value is zero. </returns>
        /// 
        [DllImport(dllName, EntryPoint = "CloseCAD", CharSet = CharSet.Ansi)]
        private static extern Int32 CloseCAD(
                IntPtr hObject
            );

        /// <summary>Export CADImage object to disk.</summary>
        /// 
        /// <param name="hObject">Identifies an opened CADImage object handle</param>
        /// <param name="ceParams">Export settings.</param>
        /// <param name="strFileName">Specifies the CAD file name.</param>
        /// 
        /// <returns>If the function succeeds, the return value is nonzero.
        /// If the function fails, the return value is zero. </returns>
        /// 
        [DllImport(dllName, EntryPoint = "SaveCADtoCAD", CharSet = CharSet.Ansi)]
        private static extern int SaveCADtoCAD(
            IntPtr hObject,
            ref CadExportParams ceParams,
            [MarshalAs(UnmanagedType.LPWStr)] string strFileName // multibyte
            );

        /// <summary>Returns the last error code and error message.</summary>
        /// 
        /// <param name="lpBuff">Points to the buffer for error message. If this parameter is NULL, no error message is retrieved.</param>
        /// <param name="nSize">Specifies a size of the buffer for an error message.</param>
        /// 
        /// <returns>The return value is one of following error-codes: 
        /// ERROR_CAD_GENERAL 
        /// ERROR_CAD_INVALID_HANDLE 
        /// ERROR_CAD_INVALID_INDEX
        /// ERROR_CAD_FILE_NOT_FOUND 
        /// ERROR_CAD_INVALID_CADDRAW 
        /// ERROR_CAD_FILE_READ
        /// ERROR_CAD_UNSUPFORMAT_FILE
        /// ERROR_CAD_OUTOFRESOURCES
        /// If lpBuf is not NULL, the specified buffer contains responding error message as null-terminated string.</returns>
        /// 
        [DllImport(dllName, EntryPoint = "GetLastErrorCAD", CharSet = CharSet.Ansi)]
        private static extern int GetLastErrorCAD(
            StringBuilder lpBuff,  // multibyte
            [MarshalAs(UnmanagedType.U4)] Int32 nSize
            );

        /// <summary>Set SHX font options for drawing CAD Image</summary>
        /// 
        /// <param name="strSearchSHXPaths">Specifies the full paths to SHX font files.</param>
        /// <param name="strDefaultSHXPath">Specifies the default path to SHX font files.</param>
        /// <param name="strDefaultSHXFont">Specifies the default SHX font.</param>
        /// <param name="bUseSHXFonts">If this parameter is true, SHX font will be used for rendering.
        /// If the parameter is false, the TrueType fonts will be used.</param>
        /// <param name="bUseACADPaths">If this parameter is true, DLL will search for AutoCAD settings.</param>
        /// 
        /// <returns>If the function succeeds, the return value is nonzero.
        /// If the function fails, the return value is zero. </returns>
        /// 
        [DllImport(dllName, EntryPoint = "CADSetSHXOptions", CharSet = CharSet.Ansi)]
        private static extern int CADSetSHXOptions(
            [MarshalAs(UnmanagedType.LPWStr)] string strSearchSHXPaths, // multibyte
            [MarshalAs(UnmanagedType.LPWStr)] string strDefaultSHXPath, // multibyte
            [MarshalAs(UnmanagedType.LPWStr)] string strDefaultSHXFont, // multibyte
            [MarshalAs(UnmanagedType.Bool)] bool bUseSHXFonts,
            [MarshalAs(UnmanagedType.Bool)] bool bUseACADPaths
            );

        /// <summary>DLL Registration.</summary>
        /// 
        /// <param name="strUserName">User name.</param>
        /// <param name="strEmail">User email</param>
        /// <param name="strLicenseCode">License code.</param>
        /// 
        /// <returns>Return values:
        /// 0 - Not registered (invalid name/email/license code)
        /// 1 - Registration is successful.
        /// 2 - Dll was already registered before.
        /// </returns>
        [DllImport(dllName, EntryPoint = "StRg", CharSet = CharSet.Ansi)]
        public static extern int Registration(
            [MarshalAs(UnmanagedType.LPWStr)] string strUserName,
            [MarshalAs(UnmanagedType.LPWStr)] string strEmail,
            [MarshalAs(UnmanagedType.LPWStr)] string strLicenseCode
            );

        #endregion

        #region Error codes defintion

        /// <summary>
        /// Converter results
        /// </summary>
        public enum ConverterResult
        {
            Success,
            GeneralError,
            InvalidHandle,
            InvalidIndex,
            FileNotFound,
            FileReadError,
            InvalidCadDraw,
            UnsupportedFormat,
            OutOfResources,
            InvalidSourceFile
        }

        /// CadImage.dll error codes
        private const int ERROR_CAD_UNSUPPORTED_SAVE_FORMAT = -1;
        private const int ERROR_CAD_FAILURE = 0;
        private const int ERROR_CAD_SUCCESS = 1;

        private const int ERROR_CAD_GENERAL = 1000;
        private const int ERROR_CAD_INVALID_HANDLE = ERROR_CAD_GENERAL + 1;
        private const int ERROR_CAD_INVALID_INDEX = ERROR_CAD_GENERAL + 2;
        private const int ERROR_CAD_FILE_NOT_FOUND = ERROR_CAD_GENERAL + 3;
        private const int ERROR_CAD_FILE_READ = ERROR_CAD_GENERAL + 4;
        private const int ERROR_CAD_INVALID_CADDRAW = ERROR_CAD_GENERAL + 5;
        private const int ERROR_CAD_UNSUPFORMAT_FILE = ERROR_CAD_GENERAL + 6;
        private const int ERROR_CAD_OUTOFRESOURCES = ERROR_CAD_GENERAL + 7;

        #endregion

        #region Private service functions

        /// <summary>Creates a new CADImage object and loads it from the memory.</summary>
        /// 
        /// <param name="bufSource">CAD file buffer.</param>
        /// <param name="strFileExt">An extension for CAD file to be loaded.</param>
        /// 
        /// <returns>A handle of new CADImage object.</returns>
        private static IntPtr CreateCADEx(byte[] bufSource, string strFileExt)
        {
            IntPtr ptrData = IntPtr.Zero;
            IntPtr ptrCADImage = IntPtr.Zero;
            string strFileName = "memory" + strFileExt;
            try
            {
                ptrData = Marshal.AllocHGlobal(bufSource.Length);
                Marshal.Copy(bufSource, 0, ptrData, bufSource.Length);
                ptrCADImage = CreateCADEx(IntPtr.Zero, ptrData, strFileName);
            }
            finally
            {
                if (ptrData != IntPtr.Zero) { Marshal.FreeHGlobal(ptrData); }
            }

            return ptrCADImage;
        }

        /// <summary>Get ConverterResult value by CadImage.dll error code.</summary>
        /// 
        /// <param name="nCode">Error code</param>
        /// 
        /// <returns>A ConverterResult value.</returns>
        private static ConverterResult GetErrorByCode(int nCode)
        {
            switch (nCode)
            {
                case ERROR_CAD_SUCCESS:
                    return ConverterResult.Success;

                case ERROR_CAD_UNSUPPORTED_SAVE_FORMAT:
                    return ConverterResult.InvalidSourceFile;

                case ERROR_CAD_INVALID_HANDLE:
                    return ConverterResult.InvalidHandle;

                case ERROR_CAD_INVALID_INDEX:
                    return ConverterResult.InvalidIndex;

                case ERROR_CAD_FILE_NOT_FOUND:
                    return ConverterResult.FileNotFound;

                case ERROR_CAD_FILE_READ:
                    return ConverterResult.FileReadError;

                case ERROR_CAD_INVALID_CADDRAW:
                    return ConverterResult.InvalidCadDraw;

                case ERROR_CAD_UNSUPFORMAT_FILE:
                    return ConverterResult.UnsupportedFormat;

                case ERROR_CAD_OUTOFRESOURCES:
                    return ConverterResult.OutOfResources;

                default:
                    return ConverterResult.GeneralError;
            }
        }

        #endregion

        /// <summary>Convert a CAD file into flash (swf).</summary>
        /// 
        /// <param name="bufFileContent">CAD source data.</param>
        /// <param name="strFileExt">An extension for CAD file to be loaded.</param>
        /// <param name="strDestFile">Name (with full path) of flash(swf) file to save results.</param>
        /// <param name="fnProgressMeter">Delegate. Updates the current convertor progress (0-100%).</param>
        /// 
        /// <returns>A ConverterResult value.</returns>
        public static ConverterResult ConvertCADFromMemory(ref byte[] bufFileContent, string strFileExt, string strDestFile, string strFontFolder, OnProgressChange fnProgressMeter)
        {
            ConverterResult retResult = ConverterResult.GeneralError;
            IntPtr hCadToConvert = IntPtr.Zero;

            try
            {
                int nResult = 0;
                _strLastError = String.Empty;

                nResult = CADImage.CADSetSHXOptions(strFontFolder, strFontFolder, "", CADImage._bUseSHXFonts, false);
                if (nResult != ERROR_CAD_SUCCESS) { return CADImage.GetErrorByCode(nResult); }

                hCadToConvert = CADImage.CreateCADEx(bufFileContent, strFileExt);
                if (hCadToConvert == IntPtr.Zero)
                {
                    StringBuilder sb = new StringBuilder(255 + 1);
                    nResult = CADImage.GetLastErrorCAD(sb, sb.Capacity);
                    _strLastError = sb.ToString();
                    return CADImage.GetErrorByCode(nResult);
                }

                CadExportParams sParams = new CadExportParams();
                sParams.ProgressFunc += new CADImage.OnProgressChange(fnProgressMeter);
                sParams.Units = 0;
                sParams.XScale = 1.0f;
                if (CADImage.SaveCADtoCAD(hCadToConvert, ref sParams, strDestFile) != 1)
                {
                    StringBuilder sb = new StringBuilder(255 + 1);
                    nResult = CADImage.GetLastErrorCAD(sb, sb.Capacity);
                    _strLastError = sb.ToString();
                    retResult = CADImage.GetErrorByCode(nResult);
                }
                else
                {
                    retResult = ConverterResult.Success;
                }
            }
            finally
            {
                if (hCadToConvert != IntPtr.Zero) { CADImage.CloseCAD(hCadToConvert); }
            }

            return retResult;
        }

    } // public class CadImage

} // namespace CADImageDllWrapper