{ Free DB Manager

  Copyright (C) 2005-2025 Lagunov Aleksey  alexs75 at yandex.ru

  This source is free software; you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free
  Software Foundation; either version 2 of the License, or (at your option)
  any later version.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web
  at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
  to the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
  MA 02111-1307, USA.
}



unit tlsSearchInMetatDataResultUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, rxtoolbar, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ExtCtrls, ActnList, Menus, fdbm_SynEditorUnit,
  SQLEngineAbstractUnit;

type

  { TtlsSearchInMetatDataResultForm }

  TtlsSearchInMetatDataResultForm = class(TForm)
    actFind: TAction;
    MenuItem6: TMenuItem;
    otRemoveRow: TAction;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    otClearResult: TAction;
    MenuItem1: TMenuItem;
    otCopyListToClibrd: TAction;
    ActionList1: TActionList;
    PopupMenu1: TPopupMenu;
    Splitter1: TSplitter;
    ToolPanel1: TToolPanel;
    TreeView1: TTreeView;
    procedure actFindExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure otClearResultExecute(Sender: TObject);
    procedure otCopyListToClibrdExecute(Sender: TObject);
    procedure otRemoveRowExecute(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
  private
    FRootNode:TTreeNode;
    FRootNodeText:string;
    procedure Localize;
    procedure UpdateRootNodeText;
  public
    EditorFrame:Tfdbm_SynEditorFrame;
    procedure AddDBObject(AObj:TDBObject);
    procedure ClearDBObjectsList;
    procedure AddRootNode(ATextToSearch:string);
  end;

var
  tlsSearchInMetatDataResultForm: TtlsSearchInMetatDataResultForm = nil;

procedure tlsShowSearchInMetatDataResultForm;

implementation

uses
  tlsSearchInMetatDataParamsUnit, IBManDataInspectorUnit, fbmStrConstUnit,
  IBManMainUnit, SQLEngineCommonTypesUnit, Clipbrd;

procedure tlsShowSearchInMetatDataResultForm;
begin
  fbManagerMainForm.RxMDIPanel1.ChildWindowsCreate(tlsSearchInMetatDataResultForm, TtlsSearchInMetatDataResultForm)
end;

{$R *.lfm}

{ TtlsSearchInMetatDataResultForm }

procedure TtlsSearchInMetatDataResultForm.FormCreate(Sender: TObject);
begin
  Localize;
  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=Self;
  EditorFrame.Align:=alClient;
  EditorFrame.ReadOnly:=true;
end;

procedure TtlsSearchInMetatDataResultForm.otClearResultExecute(Sender: TObject);
begin
  ClearDBObjectsList;
end;

procedure TtlsSearchInMetatDataResultForm.otCopyListToClibrdExecute(
  Sender: TObject);
var
  P: TDBObject;
  S: String;
  i: Integer;
begin
  S:='';
  for i:=0 to TreeView1.Items.Count - 1 do
  begin
    P:=TDBObject(TreeView1.Items[i].Data);
    if Assigned(P) then
    begin
      if S<>'' then
        S:=S + LineEnding;
      S:=S + P.CaptionFullPatch;
    end;
  end;

  if S<> '' then
  begin
    Clipboard.Open;
    Clipboard.AsText:=S;
    Clipboard.Close;
  end;
end;

procedure TtlsSearchInMetatDataResultForm.otRemoveRowExecute(Sender: TObject);
var
  D, D1: TTreeNode;
begin
  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) then
  begin
    D:=TreeView1.Selected;
    D1:=D.GetNext;
    if not Assigned(D1) then
      D1:=D.GetPrev;
    TreeView1.Items.Delete(D);
    TreeView1.Selected:=D1;
    TreeView1Click(nil);
  end;
end;

procedure TtlsSearchInMetatDataResultForm.TreeView1Click(Sender: TObject);
begin
  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) then
    EditorFrame.EditorText:=TDBObject(TreeView1.Selected.Data).DDLCreate
  else
    EditorFrame.EditorText:='';
end;

procedure TtlsSearchInMetatDataResultForm.TreeView1DblClick(Sender: TObject);
begin
  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) then
    fbManDataInpectorForm.EditObject(TDBObject(TreeView1.Selected.Data));
end;

procedure TtlsSearchInMetatDataResultForm.Localize;
begin
  Caption:=sFindInMetatadaResult;
  actFind.Caption:=sFindInMetatada;
  otClearResult.Caption:=sClearSearchResult;
  otRemoveRow.Caption:=sRemoveLine;
  otCopyListToClibrd.Caption:=sCopylistToClipboard;
  otCopyListToClibrd.Hint:=sCopylistToClipboardHint;
end;

procedure TtlsSearchInMetatDataResultForm.UpdateRootNodeText;
begin
  if not Assigned(FRootNode) then Exit;

  if FRootNode.Count>0 then
    FRootNode.Text:=Format('%s : %s (%d)', [sTextToSearch, FRootNodeText, FRootNode.Count])
  else
    FRootNode.Text:=Format('%s : %s', [sTextToSearch, FRootNodeText])
end;

procedure TtlsSearchInMetatDataResultForm.AddDBObject(AObj: TDBObject);
var
  P:TTreeNode;
begin
  if not Assigned(AObj) then Exit;
  if Assigned(FRootNode) then
    FRootNode.Expanded:=true;
  P:=TreeView1.Items.AddChild(FRootNode, AObj.Caption);
  P.Data:=AObj;

  P.ImageIndex:=DBObjectKindImages[AObj.DBObjectKind];
  P.SelectedIndex:=DBObjectKindImages[AObj.DBObjectKind];

  UpdateRootNodeText;
end;

procedure TtlsSearchInMetatDataResultForm.ClearDBObjectsList;
begin
  TreeView1.Items.Clear;
  EditorFrame.EditorText:='';
  FRootNode:=nil;
end;

procedure TtlsSearchInMetatDataResultForm.AddRootNode(ATextToSearch: string);
begin
  FRootNodeText:=ATextToSearch;
  FRootNode:=TreeView1.Items.AddFirst(FRootNode, '');
  UpdateRootNodeText;
//  FRootNode.ImageIndex:=22;
//  FRootNode.SelectedIndex:=22;
  FRootNode.Expanded:=true;
end;

procedure TtlsSearchInMetatDataResultForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
  tlsSearchInMetatDataResultForm:=nil;
end;

procedure TtlsSearchInMetatDataResultForm.actFindExecute(Sender: TObject);
begin
  ShowSearchInMetatDataParamsForm;
end;

end.

