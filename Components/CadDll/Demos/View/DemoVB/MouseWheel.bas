Attribute VB_Name = "MouseWheel"
Option Explicit
'
#If Win32 Then
'Public Type POINTAPI
'X As Long
'Y As Long
'End Type
'
Public Type MSG
hWnd As Long
message As Long
wParam As Long
lParam As Long
time As Long
pt As POINTAPI
End Type
'
Public Declare Function CallNextHookEx& Lib "user32" (ByVal hHook As Long, _
ByVal nCode As Long, ByVal wParam As Integer, lParam As Any)
Public Declare Function GetCurrentThreadId Lib "kernel32" () As Long
Public Declare Function SetWindowsHookEx& Lib "user32" Alias _
"SetWindowsHookExA" (ByVal idHook As Long, ByVal lpfn As Long, _
ByVal hmod As Long, ByVal dwThreadId As Long)
Public Declare Function UnhookWindowsHookEx& Lib "user32" _
(ByVal hHook As Long)
'
#End If 'WIN32 declares and types
'
Public Const WH_GETMESSAGE = 3
Private Const WM_MOUSEWHEEL As Long = &H20A
Private Const HC_ACTION As Long = 0
'
Public HWND_HOOK As Long

Public Declare Function ScreenToClient Lib "user32.dll" (ByVal hWnd As Long, ByRef lpPoint As POINTAPI) As Boolean

Public Function IMWheel(ByVal nCode As Long, ByVal wParam As Long, lParam As MSG) As Long
'
  If nCode = HC_ACTION Then
    If lParam.message = WM_MOUSEWHEEL Then
      Dim p As POINTAPI
      p = lParam.pt
      ScreenToClient Form1.hWnd, p
      Form1.WheelMoved lParam.wParam, p.x, p.y
    End If
  End If
  IMWheel = CallNextHookEx(HWND_HOOK, nCode, wParam, lParam)
End Function

Public Function IMWheel_Hook() As Long
  If HWND_HOOK = 0 Then
    HWND_HOOK = SetWindowsHookEx(WH_GETMESSAGE, AddressOf IMWheel, 0, GetCurrentThreadId)
  End If
End Function

Public Sub IMWheel_Unhook()
  If HWND_HOOK <> 0 Then
    UnhookWindowsHookEx HWND_HOOK
    HWND_HOOK = 0
  End If
End Sub
