Imports System.Text
Imports System.Xml.Serialization
Imports System.IO

<Serializable()> Public Class ExportParams

    <XmlAttribute()> Public Version As String = "1.0"
    Public FileName As String
    Public Ext As String
    Public CADParametrs As CADParams = New CADParams()
    Public GraphicParametrs As GraphicParams = New GraphicParams()

    Public Overrides Function ToString() As String
        Dim rez As String = ""
        Dim sb As StringBuilder = New StringBuilder()
        Try
            Dim wr As TextWriter = New StringWriter(sb)
            Try
                Dim serializer As XmlSerializer = New XmlSerializer(GetType(ExportParams))
                Try
                    serializer.Serialize(wr, Me)
                Finally
                    serializer = Nothing
                End Try
            Finally
                wr.Close()
                wr = Nothing
            End Try
            rez = sb.ToString()
        Finally
            sb = Nothing
        End Try
        Return rez
    End Function

    <Serializable()> Public Class CADParams
        Public BackgroundColor As Integer = ColorTranslator.ToWin32(Color.White)
        Public DefaultColor As Integer = ColorTranslator.ToWin32(Color.Black)
        Public XScale As Double = 1.0

        <XmlIgnore()> Public Property ColorBackground() As Color
            Get
                Return ColorTranslator.FromWin32(BackgroundColor)
            End Get
            Set(ByVal value As Color)
                BackgroundColor = ColorTranslator.ToWin32(value)
            End Set
        End Property

        <XmlIgnore()> Public Property ColorDefault() As Color
            Get
                Return ColorTranslator.FromWin32(DefaultColor)
            End Get
            Set(ByVal value As Color)
                DefaultColor = ColorTranslator.ToWin32(value)
            End Set
        End Property
    End Class

    <Serializable()> Public Class GraphicParams
        Public PixelFormat As Integer = 6
        Public Width As Integer = 800
        Public Height As Integer = 600
        Public DrawMode As Integer = 0
        Public DrawRect As Rect = New Rect()
    End Class
End Class
