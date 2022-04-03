Unit fNewViw;

{$I EZ_FLAG.PAS}
Interface

Uses Windows, Classes, Forms, Controls, StdCtrls, EzBaseGis;

Type
  TfrmDefineNew = Class( TForm )
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    LblFirst: TLabel;
    GroupBox2: TGroupBox;
    LblOther: TLabel;
    Procedure OKBtnClick( Sender: TObject );
  Private
    { Private declarations }
  Public
    { Public declarations }
    Function Enter( Viewport: TEzBaseDrawBox; Const FirstX, FirstY,
      OtherX, OtherY: Double ): Word;
  End;

Implementation

{$R *.DFM}

Uses
  EzConsts, EzSystem;

Resourcestring
  SViewNameNotDefined = 'Name for new view is empty !';

  {TfrmDefineNew - class implementation}

Function TfrmDefineNew.Enter( Viewport: TEzBaseDrawBox; Const FirstX, FirstY,
  OtherX, OtherY: Double ): Word;
Begin
  With Viewport Do
  Begin
    LblFirst.Caption := CoordsToDisplaySuffix( FirstX, FirstY );
    LblOther.Caption := CoordsToDisplaySuffix( OtherX, OtherY );
  End;
  Result := ShowModal;
End;

Procedure TfrmDefineNew.OKBtnClick( Sender: TObject );
Begin
  If Length( Edit1.Text ) = 0 Then
  Begin
    MessageToUser( SViewNameNotDefined, smsgerror, MB_ICONERROR );
    ModalResult := mrNone;
  End;
End;

End.
