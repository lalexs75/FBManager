{ Free DB Manager

  Copyright (C) 2005-2018 Lagunov Aleksey  alexs75 at yandex.ru

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
    procedure otCopyListToClibrdExecute(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
  private
    procedure Localize;
  public
    EditorFrame:Tfdbm_SynEditorFrame;
    procedure AddDBObject(AObj:TDBObject);
    procedure ClearDBObjectsList;
  end;

var
  tlsSearchInMetatDataResultForm: TtlsSearchInMetatDataResultForm = nil;

procedure tlsShowSearchInMetatDataResultForm;

implementation

uses
  tlsSearchInMetatDataParamsUnit, IBManDataInspectorUnit, fbmStrConstUnit,
  IBManMainUnit, Clipbrd;

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

procedure TtlsSearchInMetatDataResultForm.TreeView1Click(Sender: TObject);
begin
  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) then
    EditorFrame.EditorText:=TDBObject(TreeView1.Selected.Data).DDLCreate;
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
  otCopyListToClibrd.Caption:=sCopylistToClipboard;
  otCopyListToClibrd.Hint:=sCopylistToClipboardHint;
end;

procedure TtlsSearchInMetatDataResultForm.AddDBObject(AObj: TDBObject);
var
  P:TTreeNode;
begin
  P:=TreeView1.Items.Add(nil, AObj.Caption);
  P.Data:=AObj;
end;

procedure TtlsSearchInMetatDataResultForm.ClearDBObjectsList;
begin
  TreeView1.Items.Clear;
  EditorFrame.EditorText:='';
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

