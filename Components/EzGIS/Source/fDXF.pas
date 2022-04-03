unit fDXF;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
interface

uses
  SysUtils, Classes, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, EzDxfImport, ComCtrls, EzNumEd;

type
  TfrmDxfDlg = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    List1: TListBox;
    Bevel1: TBevel;
    OKBtn: TButton;
    CancelBtn: TButton;
    TabSheet2: TTabSheet;
    Label8: TLabel;
    Bevel2: TBevel;
    ListBlocks: TListBox;
    ChkAddBlocks: TCheckBox;
    Radio1: TRadioGroup;
    BtnSet: TSpeedButton;
    Label9: TLabel;
    NumEdit1: TEzNumEd;
    NumEdit2: TEzNumEd;
    NumEdit4: TEzNumEd;
    NumEdit3: TEzNumEd;
    procedure ChkAddBlocksClick(Sender: TObject);
    procedure BtnSetClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
    FDxfImport: TEzDxfImport;
  public
    { Public declarations }
    function Enter(DxfImport: TEzDxfImport): Word;
  end;

implementation

{$R *.DFM}

uses
  ezbasegis, ezsystem, EzEntities;

function TfrmDxfDlg.Enter(DxfImport: TEzDxfImport): Word;
var
  cnt, j: Integer;
  alayer: Dxf_layer;
  ent: Dxf_Entity;
begin
  FDxfImport:= DxfImport;

  Caption := Format(Caption, [ExtractFileName(DxfImport.FileName)]);

  with DxfImport.Dxf_Main do
    for cnt := 0 to layer_lists.count - 1 do
    begin
      alayer := Dxf_layer(layer_lists[cnt]);
      if AnsiCompareText(alayer.layer_name, 'Block_') = 0 then
      begin
        for j := 0 to alayer.entities.count - 1 do
        begin
          ent := Dxf_entity(alayer.entities[j]);
          if (ent.classType = Block_) and
            (AnsiCompareText('$MODEL_SPACE', Block_(ent).name) <> 0) and
            (AnsiCompareText('$PAPER_SPACE', Block_(ent).name) <> 0) then
            ListBlocks.Items.AddObject(Block_(ent).name, ent);
        end;
        Continue;
      end;
      List1.Items.AddObject(alayer.name, alayer);
    end;
  for cnt := 0 to List1.Items.Count - 1 do
    List1.Selected[cnt] := true;

  BtnSetClick(nil);

  Result := ShowModal;
end;

procedure TfrmDxfDlg.ChkAddBlocksClick(Sender: TObject);
begin
  Radio1.Enabled := ChkAddBlocks.Checked;
  ListBlocks.Enabled := ChkAddBlocks.Checked;
end;

procedure TfrmDxfDlg.BtnSetClick(Sender: TObject);
begin
  NumEdit1.NumericValue := FDxfImport.Dxf_Emin.x;
  NumEdit2.NumericValue := FDxfImport.Dxf_Emin.y;
  NumEdit3.NumericValue := FDxfImport.Dxf_Emin.x;
  NumEdit4.NumericValue := FDxfImport.Dxf_Emin.y;
end;

// Automatic layer creation...

procedure TfrmDxfDlg.OKBtnClick(Sender: TObject);
var
  ent: Dxf_entity;
  WereAdded: Boolean;
  i,j,index: integer;
  blk: Block_;
  Symbol: TEzSymbol;
begin
  with FDxfImport do
  begin
    DxfReferenceX := NumEdit1.NumericValue;
    DxfReferenceY := NumEdit2.NumericValue;
    DestReferenceX:= NumEdit3.NumericValue;
    DestReferenceY:= NumEdit4.NumericValue;
  end;
{$IFDEF FALSE}
    DxfReferenceX := FDxfImport.Dxf_Emin.x;
    DxfReferenceY := FDxfImport.Dxf_Emin.y;
    DestReferenceX:= FDxfImport.Dxf_Emin.x;
    DestReferenceY:= FDxfImport.Dxf_Emin.y;
{$ENDIF}
  { add the selected layers }
  FDxfImport.ImportLayerList.Clear;
  for i:= 0 to List1.Items.Count-1 do
    //if List1.Selected[i] then
      FDxfImport.ImportLayerList.AddObject(List1.Items[i], List1.Items.Objects[i]);
  if ChkAddBlocks.Checked then
  begin
      // dummy viewport symbol
      WereAdded := False;
         // add selected blocks to symbol table
      for i := 0 to ListBlocks.Items.Count - 1 do
        if ListBlocks.Selected[i] then
        begin
          blk := Block_(ListBlocks.Items.Objects[i]);
          if blk.entities.count=0 then Continue;
          Index := Ez_Symbols.IndexOfName(blk.name);
          Symbol := nil;
          if Index >= 0 then
          begin
            case Radio1.ItemIndex of
              0: // replace existing symbol
                begin
                  Symbol := Ez_Symbols[Index];
                  Symbol.Clear;
                end;
              1: ; // Skip the insertion (nothing to do)
              2: // duplicate the symbol
                begin
                  Symbol := TEzSymbol.Create(Ez_Symbols);
                  Ez_Symbols.Add(Symbol);
                end;
            end;
          end else
          begin
            Symbol := TEzSymbol.Create(Ez_Symbols); // add the unexisting block name
            Ez_Symbols.Add(Symbol);
          end;
          if Symbol<>nil then
          begin
            Symbol.Name := blk.name;
                  // now add the entities
            for j := 0 to blk.entities.count - 1 do
            begin
              ent := Dxf_entity(blk.entities[j]);
              // transform to EzGIS format
              ent.AddToGIS(FDxfImport, nil);
            end;
            Symbol.UpdateExtension;
            WereAdded := True;
          end;
        end;
      if WereAdded then
      begin
        // save the new symbols
        // Ez_Symbols.FileName:= Ez_Symbols.FileName;
        Ez_Symbols.Save;
      end;
  end;
end;

end.

