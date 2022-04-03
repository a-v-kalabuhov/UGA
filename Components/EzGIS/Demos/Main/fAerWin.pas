Unit fAerWin;

{$I EZ_FLAG.PAS}
Interface

Uses
  SysUtils, Classes, Forms, Controls, StdCtrls, EzLib, EzCmdline;

Type
  TfrmViewDesc = Class( TForm )
    OKBtn: TButton;
    Label1: TLabel;
    LblViewName: TLabel;
    GroupBox1: TGroupBox;
    LblFirst: TLabel;
    GroupBox2: TGroupBox;
    LblOther: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LblWidth: TLabel;
    LblHeight: TLabel;
    GroupBox3: TGroupBox;
    LblMid: TLabel;
  Private
    { Private declarations }
  Public
    { Public declarations }
    Function Enter( CmdLine: TEzCmdline; Const ViewName: String; Const ViewWin: TEzRect ): Word;
  End;

Implementation

{$R *.DFM}
Uses
  EzBaseGis, ezsystem;

Function TfrmViewDesc.Enter( CmdLine: TEzCmdline; Const ViewName: String; Const ViewWin: TEzRect ): Word;
Var
  TmpWidth, TmpHeight: Double;
  NumDec: Integer;
Begin
  LblViewName.Caption := ViewName;
  With ViewWin, CmdLine.ActiveDrawBox Do
  Begin
    LblFirst.Caption := CoordsToDisplaySuffix( Emin.X, Emin.Y );
    LblOther.Caption := CoordsToDisplaySuffix( Emax.X, Emax.Y );
    TmpWidth := Dist2d( Point2D( Emin.X, Emin.Y ), Point2D( Emax.X, Emin.Y ) );
    TmpHeight := Dist2d( Point2D( Emin.X, Emin.Y ), Point2D( Emin.X, Emax.Y ) );
    NumDec := 4;//Ez_Preferences.NumDecimals;
    LblWidth.Caption := Format( '%.*n', [NumDec, TmpWidth] );
    LblHeight.Caption := Format( '%.*n', [NumDec, TmpHeight] );
    LblMid.Caption := CoordsToDisplaySuffix( ( Emin.X + Emax.X ) / 2, ( Emin.Y + Emax.Y ) / 2 );
  End;
  Result := ShowModal;
End;

End.
