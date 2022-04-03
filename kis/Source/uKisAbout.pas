unit uKisAbout;

interface

{$I KisFlags.pas}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  StdCtrls, ExtCtrls;

type
  TAboutForm = class(TForm)
    OkBtn: TButton;
    Image1: TImage;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
  end;

implementation

{$R *.DFM}

end.
