using System;
using System.Runtime.InteropServices;
using System.Drawing;
using System.Xml;
using System.Xml.Serialization;
using System.IO;
using System.Diagnostics;

namespace CADDLL
{
    public static class sgUtils
    {
        public static void InitSHX()
        {
            string shx_path = Process.GetCurrentProcess().MainModule.FileName;
            shx_path = Path.GetDirectoryName(shx_path) + "\\..\\..\\..\\SHX\\";
            DLLWin32Import.CADSetSHXOptions(shx_path, shx_path, "simplex.shx", true, false);
        }

        public static bool IsRasterFormat(string ext)
        {
            if (ext.ToUpper() == ".BMP")
                return true;
            if (ext.ToUpper() == ".JPG")
                return true;
            if (ext.ToUpper() == ".PNG")
                return true;
            if (ext.ToUpper() == ".GIF")
                return true;
            if (ext.ToUpper() == ".JPEG")
                return true;
            return false;
        }

    }

    public delegate void CADEnumProc(ref CADData EntData, IntPtr Param);
    public delegate int ProgressProc(byte PercentDone);

    public class DLLWin32Import
    {
        const string CADImage = "cad.dll";

        public const int CAD_SEC_TABLES = 0;
        public const int CAD_SEC_BLOCKS = 1;
        public const int CAD_SEC_ENTITIES = 2;
        public const int CAD_SEC_LTYPE = 3;
        public const int CAD_SEC_LAYERS = 4;

        public const int CAD_UNKNOWN = 0;
        public const int CAD_TABLE = 1;
        public const int CAD_BLOCK = 2;
        public const int CAD_LTYPE = 3;
        public const int CAD_LAYER = 4;
        public const int CAD_VERTEX = 5;
        public const int CAD_LINE = 6;
        public const int CAD_SOLID = 7;
        public const int CAD_CIRCLE = 8;
        public const int CAD_ARC = 9;
        public const int CAD_POLYLINE = 10;
        public const int CAD_LWPOLYLINE = 11;
        public const int CAD_SPLINE = 12;
        public const int CAD_INSERT = 13;
        public const int CAD_DIMENSION = 14;
        public const int CAD_TEXT = 15;
        public const int CAD_MTEXT = 16;
        public const int CAD_ATTDEF = 17;
        public const int CAD_ELLIPSE = 18;
        public const int CAD_POINT = 19;
        public const int CAD_3DFACE = 20;
        public const int CAD_HATCH = 21;
        public const int CAD_IMAGE_ENT = 22;
        public const int CAD_ATTRIB = 23;
        public const int CAD_BEGIN_POLYLINE = 100;
        public const int CAD_END_POLYLINE = 101;
        public const int CAD_BEGIN_INSERT = 102;
        public const int CAD_END_INSERT = 103;
        public const int CAD_BEGIN_VIEWPORT = 104;
        public const int CAD_END_VIEWPORT = 105;

        public const int CADERR_GENERAL = 1000;
        public const int CADERR_INVALID_HANDLE = (CADERR_GENERAL + 1);
        public const int CADERR_INVALID_INDEX = (CADERR_GENERAL + 2);
        public const int CADERR_FILE_NOT_FOUND = (CADERR_GENERAL + 3);
        public const int CADERR_FILE_READ = (CADERR_GENERAL + 4);

#if USE_UNICODE_SGDLL
        const UnmanagedType sgStrType = UnmanagedType.LPWStr;
#else
        const UnmanagedType sgStrType = UnmanagedType.LPStr;
#endif

        //public static float fAbsWidth, fAbsHeight;
        //public static int fLayoutsCount;
        [DllImport(CADImage)]
        public static extern IntPtr CreateCAD(IntPtr hWindow, [MarshalAs(UnmanagedType.LPWStr)] string lpFileName);

        [DllImport(CADImage)]
        public static extern int CloseCAD(IntPtr hObject);

        [DllImport(CADImage)]
        public static extern IntPtr CurrentLayoutCAD(IntPtr hObject, int nIndex, bool doChange);

        [DllImport(CADImage)]
        public static extern int DefaultLayoutIndex(IntPtr hObject);

        [DllImport(CADImage)]
        public static extern int CADLayoutName(IntPtr hObject, int nIndex, [MarshalAs(UnmanagedType.LPWStr)]string name, int nSize);

        [DllImport(CADImage)]
        public static extern int CADLayoutsCount(IntPtr hObject);

        [DllImport(CADImage)]
        public static extern int DrawCAD(IntPtr hObject, IntPtr hDC, ref Rect lprc);

        [DllImport(CADImage)]
        public static extern int GetExtentsCAD(IntPtr handle, ref FRect fRect);

        [DllImport(CADImage)]
        public static extern int CADLayerCount(IntPtr hObject);

        [DllImport(CADImage)]
        public static extern int CADLayer(IntPtr hObject, int nIndex, ref CADData lpData);

        [DllImport(CADImage)]
        public static extern int GetLastErrorCAD([MarshalAs(UnmanagedType.LPWStr)]string lbBuf, UInt32 size);

        [DllImport(CADImage)]
        public static extern int DrawCADEx(IntPtr hObject, ref CADDraw lpcd);

        [DllImport(CADImage)]
        public static extern int CADLayerVisible(int Handle, int Visible);

        [DllImport(CADImage)]
        public static extern int CADSetSHXOptions(
            [MarshalAs(UnmanagedType.LPWStr)] string searchSHXPaths, // multibyte
            [MarshalAs(UnmanagedType.LPWStr)] string defaultSHXPath, // multibyte
            [MarshalAs(UnmanagedType.LPWStr)] string defaultSHXFont, // multibyte
            [MarshalAs(UnmanagedType.Bool)] bool useSHXFonts,
            [MarshalAs(UnmanagedType.Bool)] bool useACADPaths
            );

        [DllImport(CADImage)]
        public static extern int CADVisible(IntPtr hObject, [MarshalAs(UnmanagedType.LPWStr)] string lpLayerName);

        [DllImport(CADImage)]
        public static extern IntPtr DrawCADtoBitmap(IntPtr hObject, ref CADDraw lpcd);

        [DllImport(CADImage)]
        public static extern IntPtr DrawCADtoGif(IntPtr hObject, ref CADDraw lpcd);

        [DllImport(CADImage)]
        public static extern IntPtr DrawCADtoJpeg(IntPtr hObject, ref CADDraw lpcd);

        [DllImport(CADImage)]
        public static extern int GetBoxCAD(IntPtr Handle, ref float AbsWidth, ref float AbsHeight);

        [DllImport(CADImage)]
        public static extern int GetCADBorderType(IntPtr Handle, ref int ABorderType);

        [DllImport(CADImage)]
        public static extern int GetCADBorderSize(IntPtr Handle, ref float ABorderSize);

        [DllImport(CADImage)]
        public static extern int SetCADBorderType(IntPtr Handle, int ABorderType);

        [DllImport(CADImage)]
        public static extern int SetCADBorderSize(IntPtr Handle, double ABorderSize);

        [DllImport(CADImage)]
        public static extern int SetProcessMessagesCAD(IntPtr hObject, int AIsProcess);

        [DllImport(CADImage)]
        public static extern int SaveCADtoBitmap(IntPtr Handle, ref CADDraw cADDraw, [MarshalAs(UnmanagedType.LPWStr)] string FileName);

        [DllImport(CADImage)]
        public static extern int SaveCADtoJpeg(IntPtr Handle, ref CADDraw cADDraw, [MarshalAs(UnmanagedType.LPWStr)] string FileName);

        [DllImport(CADImage)]
        public static extern int SaveCADtoFileWithXMLParams(IntPtr Handle, [MarshalAs(UnmanagedType.LPWStr)] string XmlExportParams, ProgressProc ProgressProc);

        [DllImport(CADImage)]
        public static extern int SetBlackWhite(IntPtr hObject, int cMode);

        [DllImport(CADImage)]
        public static extern int SetDefaultColor(IntPtr hObject, int defaultColor);

        [DllImport(CADImage)]
        public static extern IntPtr CADCreate(IntPtr hWindow, [MarshalAs(sgStrType)] string lpFileName);

        [DllImport(CADImage)]
        public static extern int CADClose(IntPtr hObject);

        [DllImport(CADImage)]
        public static extern int CADDraw(IntPtr hObject, IntPtr hDC, ref Rect lprc);

        [DllImport(CADImage)]
        public static extern int CADEnum(IntPtr hObject, int EnumAll, CADEnumProc Proc, IntPtr Param);

        [DllImport(CADImage)]
        public static extern int CADGetBox(IntPtr hObject, ref double ALeft, ref double ARight, ref double ATop, ref double ABottom);

        [DllImport(CADImage)]
        public static extern int CADGetLastError([MarshalAs(sgStrType)] string lbBuf);

        [DllImport(CADImage)]
        public static extern int CADLayoutCount(IntPtr hObject);

        [DllImport(CADImage)]
        public static extern IntPtr CADLayoutCurrent(IntPtr hObject, ref int nIndex, bool doChange);

        [DllImport(CADImage)]
        public static extern int CADProhibitCurvesAsPoly(IntPtr hObject, int nCheckNumber);

        [DllImport(CADImage)]
        public static extern int CADtoDXFExport(IntPtr hObject, [MarshalAs(sgStrType)] string fileName);

        [DllImport(CADImage)]
        public static extern int CADSetMeshQuality(IntPtr Handle, ref double NewValue, ref double OldValue);

        [DllImport("kernel32.dll")]
        public static extern long WriteFile(long hFile, long lpBuffer,
                                               long nNumberOfBytesToWrite, long lpNumberOfBytesWritten, int lpOverlapped);
        [DllImport("kernel32.dll")]
        public static extern long CreateFile(string lpFileName, long dwDesiredAccess, long dwShareMode, IntPtr SecurityAttributes, long
                                               dwCreationDisposition, long dwFlagsAndAttributes, long hTemplateFile);
        [DllImport("kernel32.dll")]
        public static extern long CloseHandle(long hObject);
        [DllImport("kernel32.dll")]
        public static extern long GlobalAlloc(long wFlags, long dwBytes);
        [DllImport("kernel32.dll")]
        public static extern long GlobalFree(long hMem);
        [DllImport("kernel32.dll")]
        public static extern long GlobalLock(long hMem);
        [DllImport("kernel32.dll")]
        public static extern long GlobalUnlock(long hMem);
        [DllImport("kernel32.dll")]
        public static extern long GlobalSize(long hMem);
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    public struct FRect
    {
        public double Left, Top, Z1, Right, Bottom, Z2;
        public FPoint TopLeft, BottomRight;
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    public struct FPoint
    {
        public double X, Y, Z;
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    public struct RPoint
    {
        public float X, Y;
        public RPoint(float x, float y)
        {
            X = x;
            Y = y;
        }
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    public struct CADDraw
    {
        public int Size;
        public IntPtr DC;
        public Rect R;
        public drawMode DrawMode;
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    public struct Rect
    {
        [XmlAttribute]
        public int Left, Top, Right, Bottom;

        public Rect(Rectangle val)
        {
            Left = val.Left;
            Top = val.Top;
            Right = val.Right;
            Bottom = val.Bottom;
        }
    }

    public enum drawMode
    {
        dmNormal = 0,
        dmBlack = 1,
        dmGray = 2,
    };

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    public struct CADPoint
    {
        public double X;
        public double Y;
        public double Z;

        public CADPoint(double aX, double aY, double aZ)
        {
            X = aX;
            Y = aY;
            Z = aZ;
        }

        public CADPoint(IntPtr Ptr, int Index)
        {
#if _WIN64
            IntPtr ptr1 = (IntPtr)(Ptr.ToInt64() + Index * Marshal.SizeOf(typeof(CADPoint)));
#else
            IntPtr ptr1 = (IntPtr)(Ptr.ToInt32() + Index * Marshal.SizeOf(typeof(CADPoint)));
#endif
            this = (CADPoint)Marshal.PtrToStructure(ptr1, typeof(CADPoint));
        }
    }

#if _WIN64
    [StructLayout(LayoutKind.Explicit)]
    public struct CADData
    {
        [FieldOffset(0)] public ushort Tag;
        [FieldOffset(2)] public ushort Count;
        [FieldOffset(4)] public ushort TickCount;
        [FieldOffset(6)] public byte Flags;
        [FieldOffset(7)] public byte Style;
        [FieldOffset(8)] public int Dimension;
        [FieldOffset(12)] public IntPtr DashDots;           // Pointer to CADPoint
        [FieldOffset(20)] public int DashDotsCount;
        [FieldOffset(24)] public int Color;
        [FieldOffset(28)] public IntPtr Ticks;              // Pointer
        [FieldOffset(36)] public double Thickness;          // For future versions
        [FieldOffset(44)] public double Rotation;           // Text or block rotation angle
        [FieldOffset(52)] public IntPtr Layer;              // Layer name (only one layer for element)
        [FieldOffset(60)] public IntPtr Text;               // Pointer to text string
        [FieldOffset(68)] public IntPtr FontName;
        [FieldOffset(76)] public IntPtr Handle;
        [FieldOffset(84)] public int Undefined1;
        [FieldOffset(88)] public double Undefined2;
        [FieldOffset(96)] public double Undefined3;
        [FieldOffset(104)] public IntPtr CADExtendedData;   // Pointer
        [FieldOffset(112)] public CADPoint Point;           // Coordinates of the first point
        [FieldOffset(136)] public CADPoint Point1;          // Coordinates of the second point
        [FieldOffset(160)] public CADPoint Point2;          // Coordinates of the third point
        [FieldOffset(184)] public CADPoint Point3;          // Coordinates of the fourth point
        
        [FieldOffset(208)] public double Radius;
        [FieldOffset(216)] public double StartAngle;
        [FieldOffset(224)] public double EndAngle;
        [FieldOffset(232)] public double Ratio;
        [FieldOffset(240)] public byte EntityType;          // For Arcs (NOT in CADEnum)   

        [FieldOffset(208)] public IntPtr Block;                // Handle
        [FieldOffset(216)] public CADPoint Scale;           // For Inserts (NOT in CADEnum)
        
        [FieldOffset(208)] public double FHeight;
        [FieldOffset(216)] public double FScale;
        [FieldOffset(224)] public double RWidth;
        [FieldOffset(232)] public double RHeight;
        [FieldOffset(240)] public byte HAlign;      
        [FieldOffset(241)] public byte VAlign;              // For Text

        [FieldOffset(208)] public IntPtr Points;            // For Polylines (in CADEnum), pointer to CADPoint
        [FieldOffset(216)] public int CountPointOfSegments;
    }
#else
    [StructLayout(LayoutKind.Explicit)]
    public struct CADData
    {
        [FieldOffset(0)]
        public ushort Tag;
        [FieldOffset(2)]
        public ushort Count;
        [FieldOffset(4)]
        public ushort TickCount;
        [FieldOffset(6)]
        public byte Flags;
        [FieldOffset(7)]
        public byte Style;
        [FieldOffset(8)]
        public int Dimension;
        [FieldOffset(12)]
        public IntPtr DashDots;         // Pointer to CADPoint
        [FieldOffset(16)]
        public int DashDotsCount;
        [FieldOffset(20)]
        public int Color;
        [FieldOffset(24)]
        public IntPtr Ticks;            // Pointer
        [FieldOffset(28)]
        public double Thickness;        // For future versions
        [FieldOffset(36)]
        public double Rotation;         // Text or block rotation angle
        [FieldOffset(44)]
        public IntPtr Layer;            // Layer name (only one layer for element)
        [FieldOffset(48)]
        public IntPtr Text;             // Pointer to text string
        [FieldOffset(52)]
        public IntPtr FontName;
        [FieldOffset(56)]
        public IntPtr Handle;
        [FieldOffset(58)]
        public int Undefined1;
        [FieldOffset(62)]
        public double Undefined2;
        [FieldOffset(70)]
        public double Undefined3;
        [FieldOffset(80)]
        public int CADExtendedData;     // Pointer
        [FieldOffset(84)]
        public CADPoint Point;          // Coordinates of the first point
        [FieldOffset(108)]
        public CADPoint Point1;        // Coordinates of the second point
        [FieldOffset(132)]
        public CADPoint Point2;        // Coordinates of the third point
        [FieldOffset(156)]
        public CADPoint Point3;        // Coordinates of the fourth point

        [FieldOffset(180)]
        public double Radius;
        [FieldOffset(188)]
        public double StartAngle;
        [FieldOffset(196)]
        public double EndAngle;
        [FieldOffset(204)]
        public double Ratio;
        [FieldOffset(212)]
        public byte EntityType;         // For arcs (NOT in CADEnum)

        [FieldOffset(180)]
        public IntPtr Block;            // Handle
        [FieldOffset(184)]
        public CADPoint Scale;          // For Inserts (NOT in CADEnum)

        [FieldOffset(180)]
        public double FHeight;
        [FieldOffset(188)]
        public double FScale;
        [FieldOffset(196)]
        public double RWidth;
        [FieldOffset(204)]
        public double RHeight;
        [FieldOffset(212)]
        public byte HAlign;
        [FieldOffset(213)]
        public byte VAlign;             // For Text

        [FieldOffset(180)]
        public IntPtr Points;           // For polylines (in CADEnum), pointer to CADPoint
        [FieldOffset(184)]
        public int CountPointOfSegments;
    }
#endif
}