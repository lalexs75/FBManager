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

unit fbmExtractUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ButtonPanel, StdCtrls, ExtCtrls, IBManDataInspectorUnit, ibmanagertypesunit,
  fbmsqlscript;

type

  { TfbmExtractForm }

  TfbmExtractForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ButtonPanel1: TButtonPanel;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Label1: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TreeView1: TTreeView;
    TreeView2: TTreeView;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    procedure TreeView2DblClick(Sender: TObject);
  private
    FCurDB:TDataBaseRecord;
    procedure FillDBList;
    procedure SetCurDB(AValue: TDataBaseRecord);
    procedure DoLoadItems;
    procedure Localize;
  public
    property CurDB:TDataBaseRecord read FCurDB write SetCurDB;
  end;

var
  fbmExtractForm: TfbmExtractForm;

procedure ShowExtractForm;
implementation
uses SQLEngineAbstractUnit, IBManMainUnit, fbmStrConstUnit, fbmToolsUnit,
  rxAppUtils;

procedure ShowExtractForm;
begin
  fbmExtractForm:=TfbmExtractForm.Create(Application);
  fbmExtractForm.ShowModal;
  fbmExtractForm.Free;
end;

{$R *.lfm}

{ TfbmExtractForm }

procedure TfbmExtractForm.ComboBox1Change(Sender: TObject);
begin
  if (ComboBox1.Items.Count>0) and (ComboBox1.ItemIndex>-1) then
    CurDB:=TDataBaseRecord(ComboBox1.Items.Objects[ComboBox1.ItemIndex])
  else
    CurDB:=nil;
end;

procedure TfbmExtractForm.Button2Click(Sender: TObject);
begin
  if Assigned(TreeView2.Selected) then
  begin
    TreeView2.Items.Delete(TreeView2.Selected);
    TreeView2.Selected:=nil;
  end;
end;

procedure TfbmExtractForm.Button3Click(Sender: TObject);

function DoGetMetaSQL(D:TDBObject):string;
begin
  Result:='';
  if not Assigned(D) then exit;
  RxWriteLog(etDebug, D.CaptionFullPatch);
  Result:=D.DDLCreateSimple;
end;

var
  St:string;
  N: TTreeNode;
  D: TDBInspectorRecord;
  i: Integer;
begin
  St:='';
  for i:=0 to TreeView2.Items.Count-1 do
  begin
    N:=TreeView2.Items[i];
    if Assigned(N.Data) then
    begin
      D:=TDBInspectorRecord(N.Data);
      if Assigned(D) then
        ST:=ST + DoGetMetaSQL(D.DBObject);
    end;
  end;
  if ST <> '' then
  begin
    fbManagerMainForm.tlsSqlScript.Execute;
    FBMSqlScripForm.SetSQLText(ST);
  end;
  Close;
end;

procedure TfbmExtractForm.Button1Click(Sender: TObject);

procedure DoAddItem(AOwnerNode, ANode:TTreeNode);
var
  N: TTreeNode;
  i: Integer;
begin
  if not Assigned(ANode) then exit;
  N:=TreeView2.Items.AddChild(AOwnerNode, ANode.Text);
  N.ImageIndex:=ANode.ImageIndex;
  N.SelectedIndex:=ANode.SelectedIndex;
  N.StateIndex:=ANode.StateIndex;
  N.Data:=ANode.Data;
  for i:=0 to ANode.Count-1 do
    DoAddItem(N, ANode.Items[i]);
end;

begin
  if Assigned(TreeView1.Selected) then
  begin
    DoAddItem(nil, TreeView1.Selected);
  end;
end;

procedure TfbmExtractForm.FormCreate(Sender: TObject);
begin
  Localize;
  PageControl1.ActivePageIndex:=0;
  FillDBList;
end;

procedure TfbmExtractForm.PageControl1Change(Sender: TObject);
begin
  if (PageControl1.ActivePage = TabSheet2) and (TreeView1.Items.Count = 0) then
    DoLoadItems;
end;

procedure TfbmExtractForm.TreeView1DblClick(Sender: TObject);
begin
  Button1.Click;
end;

procedure TfbmExtractForm.TreeView2DblClick(Sender: TObject);
begin
  Button2.Click;
end;

procedure TfbmExtractForm.FillDBList;
var
  i: Integer;
begin
  ComboBox1.Items.Clear;
  for i:=0 to fbManDataInpectorForm.DBList.Count-1 do
    if fbManDataInpectorForm.DBList[i].Connected then
    begin
      ComboBox1.Items.Add(fbManDataInpectorForm.DBList[i].Caption);
      ComboBox1.Items.Objects[ComboBox1.Items.Count-1]:=fbManDataInpectorForm.DBList[i];
    end;
  if ComboBox1.Items.Count>0 then
    ComboBox1.ItemIndex:=0;
  ComboBox1Change(nil);
end;

procedure TfbmExtractForm.SetCurDB(AValue: TDataBaseRecord);
begin
  if FCurDB=AValue then Exit;
  TreeView1.Items.Clear;
  TreeView2.Items.Clear;
  FCurDB:=AValue;
end;

procedure TfbmExtractForm.DoLoadItems;

procedure DoCreateItem(AOwnerNode, ANode:TTreeNode);
var
  N: TTreeNode;
  i: Integer;
begin
  if not Assigned(ANode) then exit;
  N:=TreeView1.Items.AddChild(AOwnerNode, ANode.Text);
  N.ImageIndex:=ANode.ImageIndex;
  N.SelectedIndex:=ANode.SelectedIndex;
  N.StateIndex:=ANode.StateIndex;
  N.Data:=ANode.Data;
  for i:=0 to ANode.Count-1 do
    DoCreateItem(N, ANode.Items[i]);
end;

var
  i: Integer;
begin
  if not Assigned(FCurDB) then exit;
  for i:=0 to FCurDB.FOwner.Count -1 do
    DoCreateItem(nil, FCurDB.FOwner.Items[i]);

end;

procedure TfbmExtractForm.Localize;
begin
  Caption:=sExtractMetaForm;
  TabSheet1.Caption:=sDatabase;
  TabSheet2.Caption:=sObjects;
  TabSheet3.Caption:=sProgres;
  Label1.Caption:=sSelectDatabase;
  CheckBox1.Caption:=sExtractAll;
  Button1.Caption:=sAdd;
  Button2.Caption:=sRemove;
end;

end.

