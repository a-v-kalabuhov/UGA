Imports System.Reflection
Imports System.Reflection.Emit
Imports System.Runtime.InteropServices
Imports System.Xml.Serialization

Public Delegate Function ProgressProcDelegate(ByVal PercentDone As Byte) As Integer

Class CADImageLib
    Private Const CADImageLibName As String = "cad.dll"

#If USE_UNICODE_SGDLL Then
    Private Const sgStrType As UnmanagedType = UnmanagedType.LPWStr
#Else
    Private Const sgStrType As UnmanagedType = UnmanagedType.LPTStr
#End If

    Public Shared Function sgStringToString(ByVal Ptr As IntPtr) As String
#If USE_UNICODE_SGDLL Then
        sgStringToString = Marshal.PtrToStringUni(Ptr)
#Else
        sgStringToString = Marshal.PtrToStringAnsi(Ptr)
#End If
    End Function

    <DllImport(CADImageLibName, _
    SetLastError:=True, _
    CharSet:=CharSet.Ansi, ExactSpelling:=True, _
    CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function CreateCAD(ByVal hWindow As IntPtr, <MarshalAs(sgStrType)> ByVal lpFileName As String) As IntPtr
    End Function
    <DllImport(CADImageLibName, _
    SetLastError:=True, CharSet:=CharSet.Ansi, _
    ExactSpelling:=True, _
    CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function SetDefaultColor(ByVal hObject As IntPtr, ByVal ADefaultColor As Integer) As Integer
    End Function
    <DllImport(CADImageLibName, _
    SetLastError:=True, CharSet:=CharSet.Ansi, _
    ExactSpelling:=True, _
    CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function CloseCAD(ByVal hObject As IntPtr) As Integer
    End Function
    <DllImport(CADImageLibName, _
    SetLastError:=True, CharSet:=CharSet.Ansi, _
    ExactSpelling:=True, _
    CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function CurrentLayoutCAD(ByVal hObject As IntPtr, ByVal Index As Integer, ByVal DoChange As Boolean) As IntPtr
    End Function
    <DllImport(CADImageLibName,
    SetLastError:=True, CharSet:=CharSet.Ansi,
    ExactSpelling:=True,
    CallingConvention:=CallingConvention.StdCall)>
    Public Shared Function DrawCAD(ByVal hObject As IntPtr, ByVal hDC As IntPtr, ByRef lprc As Rect) As Integer
    End Function
    <DllImport(CADImageLibName,
    SetLastError:=True, CharSet:=CharSet.Ansi,
    ExactSpelling:=True,
    CallingConvention:=CallingConvention.StdCall)>
    Public Shared Function DrawCADEx(ByVal hObject As IntPtr, ByRef lpcd As CADDRAW) As Integer
    End Function
    <DllImport(CADImageLibName, _
    SetLastError:=True, CharSet:=CharSet.Ansi, _
    ExactSpelling:=True, _
    CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function GetExtentsCAD(ByVal handle As IntPtr, ByRef fRect As Rect) As Integer
    End Function
    <DllImport(CADImageLibName, _
    SetLastError:=True, CharSet:=CharSet.Ansi, _
    ExactSpelling:=True, _
    CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function CADLayerCount(ByVal hObject As IntPtr) As Integer
    End Function
    <DllImport(CADImageLibName, _
    SetLastError:=True, CharSet:=CharSet.Ansi, _
    ExactSpelling:=True, _
    CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function CADLayer(ByVal hObject As IntPtr, ByVal nIndex As Integer, ByRef lpData As CADData) As IntPtr
    End Function
    <DllImport(CADImageLibName, _
    SetLastError:=True, CharSet:=CharSet.Ansi, _
    ExactSpelling:=True, _
    CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function CADVisible(ByVal hObject As IntPtr, <MarshalAs(sgStrType)> ByVal LayerName As String) As IntPtr
    End Function
    <DllImport(CADImageLibName, _
    SetLastError:=True, CharSet:=CharSet.Ansi, _
    ExactSpelling:=True, _
    CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function GetLastErrorCAD(<MarshalAs(sgStrType)> ByVal lbBuf As String, ByVal Size As Integer) As Integer
    End Function
    <DllImport(CADImageLibName, _
    SetLastError:=True, CharSet:=CharSet.Ansi, _
    ExactSpelling:=True, _
    CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function GetBoxCAD(ByVal Handle As IntPtr, ByRef AbsWidth As Single, ByRef AbsHeight As Single) As Long
    End Function
    <DllImport(CADImageLibName, _
    SetLastError:=True, CharSet:=CharSet.Ansi, _
    ExactSpelling:=True, _
    CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DrawCADtoBitmap(ByVal hObject As IntPtr, ByRef lpcd As CADDRAW) As Long
    End Function
    <DllImport(CADImageLibName, _
    SetLastError:=True, CharSet:=CharSet.Ansi, _
    ExactSpelling:=True, _
    CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DrawCADtoJpeg(ByVal Handle As IntPtr, ByVal CdDraw As CADDRAW) As IntPtr
    End Function
    <DllImport(CADImageLibName, _
    SetLastError:=True, CharSet:=CharSet.Ansi, _
    ExactSpelling:=True, _
    CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function CADLayoutsCount(ByVal Handle As IntPtr) As Integer
    End Function
    <DllImport(CADImageLibName, _
    SetLastError:=True, CharSet:=CharSet.Ansi, _
    ExactSpelling:=True, _
    CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function SaveCADtoBitmap(ByVal Handle As IntPtr, ByRef cADDraw As CADDRAW, <MarshalAs(sgStrType)> ByVal FileName As String) As Integer
    End Function
    <DllImport(CADImageLibName, _
    SetLastError:=True, CharSet:=CharSet.Ansi, _
    ExactSpelling:=True, _
    CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function SaveCADtoJpeg(ByVal Handle As IntPtr, ByRef cADDraw As CADDRAW, <MarshalAs(sgStrType)> ByVal FileName As String) As Integer
    End Function
    <DllImport(CADImageLibName, _
    SetLastError:=True, CharSet:=CharSet.Ansi, _
    ExactSpelling:=True, _
    CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function CADLayerVisible(ByVal Handle As IntPtr, ByVal Visible As Integer) As Integer
    End Function
    <DllImport(CADImageLibName, _
    SetLastError:=True, CharSet:=CharSet.Ansi, _
    ExactSpelling:=True, _
    CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function CADLayoutName(ByVal Handle As IntPtr, ByVal Index As Integer, <MarshalAs(sgStrType)> ByVal Name As String, ByVal nSize As Integer) As Integer
    End Function
    <DllImport(CADImageLibName, _
    SetLastError:=True, CharSet:=CharSet.Ansi, _
    ExactSpelling:=True, _
    CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DefaultLayoutIndex(ByVal Handle As IntPtr) As Integer
    End Function

    <DllImport(CADImageLibName, _
    SetLastError:=True, CharSet:=CharSet.Ansi, _
    ExactSpelling:=True, _
    CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function SaveCADtoFileWithXMLParams(ByVal Handle As IntPtr, <MarshalAs(sgStrType)> ByVal AParam As String, ByVal ProgressProc As ProgressProcDelegate) As Integer
    End Function

    <DllImport(CADImageLibName, _
    SetLastError:=True, _
    CharSet:=CharSet.Ansi, ExactSpelling:=True, _
    CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function SetProgressProc(ByVal ProgressProc As ProgressProcDelegate) As Integer
    End Function

    <DllImport(CADImageLibName, _
    SetLastError:=True, CharSet:=CharSet.Ansi, _
    ExactSpelling:=True, _
    CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function CADSetSHXOptions(<MarshalAs(sgStrType)> ByVal searchSHXPaths As String, _
                                            <MarshalAs(sgStrType)> ByVal defaultSHXPath As String, _
                                            <MarshalAs(sgStrType)> ByVal defaultSHXFont As String, _
                                            ByVal useSHXFonts As Boolean, ByVal useACADPaths As Boolean) As Integer
    End Function

End Class

Public Class CADImageEventsArgs
    Inherits System.EventArgs

    Private _PercentDone As Byte = 0
    Private _Result As Integer = 0

    Sub New(ByVal PercentDone As Byte)
        MyBase.New()
        _PercentDone = PercentDone
    End Sub

    Public Property PercentDone() As Byte
        Get
            Return _PercentDone
        End Get
        Set(ByVal value As Byte)
            _PercentDone = value
        End Set
    End Property

    Public Property Result() As Byte
        Get
            Return _Result
        End Get
        Set(ByVal value As Byte)
            _Result = value
        End Set
    End Property
End Class

Public Delegate Sub CADProgressDelegate(ByVal sender As System.Object, ByVal e As CADImageEventsArgs)

Public Class CADImage
    Implements IDisposable

    Public Event Progress As CADProgressDelegate
    Private CADImageLibProgressProc As ProgressProcDelegate = New ProgressProcDelegate(AddressOf CADImageLibProgressProcHandler)
    Private e As CADImageEventsArgs = New CADImageEventsArgs(0)
    Private CADHandle As IntPtr = IntPtr.Zero

    Public Sub New()
        MyBase.New()
        CADImageLib.SetProgressProc(CADImageLibProgressProc)
    End Sub

    Public Sub New(ByVal FileName As String)
        MyBase.New()
        Load(FileName)
    End Sub

    Public Sub New(ByVal Window As IntPtr, ByVal FileName As String)
        MyBase.New()
        Load(Window, FileName)
    End Sub

    Public ReadOnly Property Empty() As Boolean
        Get
            Return CADHandle.Equals(IntPtr.Zero)
        End Get
    End Property

    Public Sub Load(ByVal FileName As String)
        Load(IntPtr.Zero, FileName)
    End Sub

    Public Sub Load(ByVal Window As IntPtr, ByVal FileName As String)
        CADHandle = CADImageLib.CreateCAD(Window, FileName)
    End Sub

    Public Sub Close()
        If Not Empty Then
            CADImageLib.CloseCAD(CADHandle)
        End If
        CADHandle = IntPtr.Zero
    End Sub

    Public ReadOnly Property Handle() As IntPtr
        Get
            Return CADHandle
        End Get
    End Property

    Public ReadOnly Property LayersCount() As Integer
        Get
            If Not Empty() Then
                Return CADImageLib.CADLayerCount(CADHandle)
            Else
                Return 0
            End If
        End Get
    End Property

    Public ReadOnly Property Layer(ByVal Index As Integer) As IntPtr
        Get
            If Not Empty() Then
                Return CADImageLib.CADLayer(CADHandle, Index, Nothing)
            Else
                Return IntPtr.Zero
            End If
        End Get
    End Property

    Public ReadOnly Property LayerName(ByVal Index As Integer) As String
        Get
            If Not Empty() Then
                Dim CADData As CADData = New CADData
                CADImageLib.CADLayer(CADHandle, Index, CADData)
                Dim result As String = CADImageLib.sgStringToString(CADData.Text)
                CADData = Nothing
                Return result
            Else
                Return Nothing
            End If
        End Get
    End Property

    Public ReadOnly Property LayoutsCount() As Integer
        Get
            If Not Empty() Then
                Return CADImageLib.CADLayoutsCount(CADHandle)
            Else
                Return 0
            End If
        End Get
    End Property

    Public ReadOnly Property LayoutName(ByVal Index As Integer) As String
        Get
            If Not Empty() Then
                Dim S As String = New String(" ", 256)
                CADImageLib.CADLayoutName(CADHandle, Index, S, Len(S))
                Return S
            Else
                Return Nothing
            End If
        End Get
    End Property

    Public ReadOnly Property Box() As RectangleF
        Get
            If Not Empty() Then
                Dim width As Single
                Dim height As Single
                CADImageLib.GetBoxCAD(CADHandle, width, height)
                Return New RectangleF(0, 0, width, height)
            Else
                Return Nothing
            End If
        End Get
    End Property

    Public ReadOnly Property DefaultLayoutIndex() As Integer
        Get
            If Not Empty() Then
                Return CADImageLib.DefaultLayoutIndex(CADHandle)
            Else
                Return -1
            End If
        End Get
    End Property

    Public ReadOnly Property CurrentLayout() As IntPtr
        Get
            If Not Empty() Then
                Return CADImageLib.CurrentLayoutCAD(CADHandle, -1, False)
            Else
                Return IntPtr.Zero
            End If
        End Get
    End Property

    Public Function SetCurrentLayout(ByVal Index As Integer) As IntPtr
        If Not Empty Then
            Return CADImageLib.CurrentLayoutCAD(CADHandle, Index, True)
        Else
            Return IntPtr.Zero
        End If
    End Function

    Public Sub Draw(ByVal Gr As Graphics, ByVal Rect As Rectangle)
        If Not Empty Then
            Dim r As Rect = New Rect(Rect)
            CADImageLib.DrawCAD(CADHandle, Gr.GetHdc(), r)
            r = Nothing
        End If
    End Sub

    Public Sub DrawCADEx(ByVal Gr As Graphics, ByVal Rect As Rectangle, ByVal Mode As Byte)
        If Not Empty Then
            Dim r As CADDRAW = New CADDRAW()
            r.Size = Marshal.SizeOf(r)
            r.DrawMode = Mode
            r.R = New Rect(Rect)
            r.DC = Gr.GetHdc()
            Dim rez As Integer = CADImageLib.DrawCADEx(CADHandle, r)
            Gr.ReleaseHdc()
            r = Nothing
        End If
    End Sub

    Public Sub SaveCADtoJpeg(ByVal CADDraw As CADDRAW, ByVal FileName As String)
        If Not Empty Then
            CADImageLib.SaveCADtoJpeg(CADHandle, CADDraw, FileName)
        End If
    End Sub

    Public Sub SaveCADtoBitmap(ByVal CADDraw As CADDRAW, ByVal FileName As String)
        If Not Empty Then
            CADImageLib.SaveCADtoBitmap(CADHandle, CADDraw, FileName)
        End If
    End Sub

    Public Sub SetDefaultColor(ByVal Color As Color)
        If Not Empty Then
            CADImageLib.SetDefaultColor(CADHandle, ColorTranslator.ToWin32(Color))
        End If
    End Sub

    Private Function CADImageLibProgressProcHandler(ByVal PercentDone As Byte) As Integer
        e.Result = 0
        e.PercentDone = PercentDone
        RaiseEvent Progress(Me, e)
        Return e.Result
    End Function

    Public Function SaveToFileWithXMLParams(ByVal XmlExportParams As String) As Integer
        Dim result As Integer = 0
        If Not Empty Then
            result = CADImageLib.SaveCADtoFileWithXMLParams(CADHandle, XmlExportParams, CADImageLibProgressProc)
        End If
        Return result
    End Function

    Public ReadOnly Property Err() As String
        Get
            If Not Empty Then
                Dim result As String = New String(" ", 256)
                CADImageLib.GetLastErrorCAD(result, 256)
                Return result
            Else
                Return Nothing
            End If
        End Get
    End Property

    Public Function IsLayerVisible(ByVal LayerName As String) As Boolean
        If Not Empty Then
            Return CADImageLib.CADVisible(CADHandle, LayerName) = 1
        Else
            Return True
        End If
    End Function

    Private disposedValue As Boolean = False        ' To detect redundant calls

    ' IDisposable
    Protected Overridable Sub Dispose(ByVal disposing As Boolean)
        If Not Me.disposedValue Then
            If disposing Then
                Close()
                e = Nothing
                CADImageLibProgressProc = Nothing
            End If

            ' TODO: free shared unmanaged resources
        End If
        Me.disposedValue = True
    End Sub

#Region " IDisposable Support "
    ' This code added by Visual Basic to correctly implement the disposable pattern.
    Public Sub Dispose() Implements IDisposable.Dispose
        ' Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
        Dispose(True)
        GC.SuppressFinalize(Me)
    End Sub
#End Region

End Class

Public Structure Rect
    <XmlAttribute()> Public Left, Top, Right, Bottom As Integer
    Public Sub New(ByVal val As Rectangle)
        Left = val.Left
        Top = val.Top
        Right = val.Right
        Bottom = val.Bottom
    End Sub
End Structure

Public Structure CADDRAW
    Public Size As Integer
    Public DC As IntPtr
    Public R As Rect
    Public DrawMode As Byte
End Structure

Public Structure CADPOINT
    Public X As Double
    Public Y As Double
    Public Z As Double

    Public Sub New(ByVal aX As Double, ByVal aY As Double, ByVal aZ As Double)
        X = aX
        Y = aY
        Z = aZ
    End Sub

    Public Sub New(ByVal aX As Double, ByVal aY As Double)
        X = aX
        Y = aY
        Z = 0
    End Sub
End Structure

<StructLayout(LayoutKind.Explicit)> _
Public Structure CADData
#If WIN64 = 1 Then
    <FieldOffset(0)> Public Tag As Short
    <FieldOffset(2)> Public Count As Short
    <FieldOffset(4)> Public TickCount As Short
    <FieldOffset(6)> Public Flags As Byte
    <FieldOffset(7)> Public Style As Byte
    <FieldOffset(8)> Public Dimension As Integer
    <FieldOffset(12)> Public DashDots As IntPtr
    <FieldOffset(20)> Public DashDotsCount As Integer
    <FieldOffset(24)> Public Color As Integer
    <FieldOffset(28)> Public Ticks As IntPtr
    <FieldOffset(36)> Public Thickness As Double
    <FieldOffset(44)> Public Rotation As Double
    <FieldOffset(52)> Public Layer As IntPtr
    <FieldOffset(60)> Public Text As IntPtr
    <FieldOffset(68)> Public FontName As IntPtr
    <FieldOffset(76)> Public Handle As IntPtr
    <FieldOffset(84)> Public Undefined1 As Integer
    <FieldOffset(88)> Public Undefined2 As Double
    <FieldOffset(96)> Public Undefined3 As Double
    <FieldOffset(104)> Public CADExtendedData As IntPtr
    <FieldOffset(112)> Public Point As CADPOINT
    <FieldOffset(136)> Public Point1 As CADPOINT
    <FieldOffset(160)> Public Point2 As CADPOINT
    <FieldOffset(184)> Public Point3 As CADPOINT
    ' for arcs (NOT in DXFEnum)
    <FieldOffset(208)> Public Radius As Double
    <FieldOffset(216)> Public StartAngle As Double
    <FieldOffset(224)> Public EndAngle As Double
    <FieldOffset(232)> Public Ratio As Double
    <FieldOffset(240)> Public EntityType As Byte
    
    ' for Inserts (NOT in DXFEnum)
    <FieldOffset(208)> Public Block As IntPtr
    <FieldOffset(216)> Public Scale As CADPOINT
    ' for Text
    <FieldOffset(208)> Public FHeight As Double
    <FieldOffset(216)> Public FScale As Double
    <FieldOffset(224)> Public RWidth As Double
    <FieldOffset(232)> Public RHeight As Double
    <FieldOffset(240)> Public HAlign As Byte
    <FieldOffset(241)> Public VAlign As Byte
    'for polylines (in DXFEnum)
    <FieldOffset(208)> Public Points As IntPtr
    <FieldOffset(216)> Public CountPointOfSegments As Integer
#Else
    <FieldOffset(0)> Public Tag As Short
    <FieldOffset(2)> Public Count As Short
    <FieldOffset(4)> Public TickCount As Short
    <FieldOffset(6)> Public Flags As Byte
    <FieldOffset(7)> Public Style As Byte
    <FieldOffset(8)> Public Dimension As Integer
    <FieldOffset(12)> Public DashDots As IntPtr
    <FieldOffset(16)> Public DashDotsCount As Integer
    <FieldOffset(20)> Public Color As Integer
    <FieldOffset(24)> Public Ticks As IntPtr
    <FieldOffset(28)> Public Thickness As Double
    <FieldOffset(36)> Public Rotation As Double
    <FieldOffset(44)> Public Layer As IntPtr
    <FieldOffset(48)> Public Text As IntPtr
    <FieldOffset(52)> Public FontName As IntPtr
    <FieldOffset(56)> Public Handle As IntPtr
    <FieldOffset(60)> Public Undefined1 As Integer
    <FieldOffset(64)> Public Undefined2 As Double
    <FieldOffset(72)> Public Undefined3 As Double
    <FieldOffset(80)> Public CADExtendedData As IntPtr
    <FieldOffset(84)> Public Point As CADPOINT
    <FieldOffset(108)> Public Point1 As CADPOINT
    <FieldOffset(132)> Public Point2 As CADPOINT
    <FieldOffset(156)> Public Point3 As CADPOINT
    ' for arcs (NOT in DXFEnum)
    <FieldOffset(180)> Public Radius, StartAngle, EndAngle, Ratio As Double
    <FieldOffset(212)> Public EntityType As Byte
    ' for Inserts (NOT in DXFEnum)
    <FieldOffset(180)> Public Block As IntPtr
    <FieldOffset(184)> Public Scale As CADPOINT
    ' for Text
    <FieldOffset(180)> Public FHeight, FScale, RWidth, RHeight As Double
    <FieldOffset(212)> Public HAlign, VAlign As Byte
    'for polylines (in DXFEnum)
    <FieldOffset(180)> Public Points As IntPtr
    <FieldOffset(184)> Public CountPointOfSegments As Integer
#End If
End Structure