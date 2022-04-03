unit FormsUtils;


interface

uses ComCtrls;

  function GetNodeByCaption(tree: TTreeView; caption: String): TTreeNode;

implementation

function GetNodeByCaption(tree: TTreeView; caption: String): TTreeNode;
var
  i: Integer;
begin
  result := nil;
  for i := 0 to tree.Items.Count - 1 do
    if tree.Items[i].Text = caption then
    begin
      result := tree.Items[i];
      exit;
    end;
end;

end.
