{ Free DB Manager

  Copyright (C) 2005-2020 Lagunov Aleksey  alexs75 at yandex.ru

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
  Classes, SysUtils, FileUtil, RxIniPropStorage, rxpagemngr, Forms, Controls,
  Graphics, Dialogs, ComCtrls, ButtonPanel, StdCtrls, ExtCtrls, EditBtn,
  Buttons, ActnList, IBManDataInspectorUnit, ibmanagertypesunit, fbmsqlscript;

type

  { TfbmExtractForm }

  TfbmExtractForm = class(TForm)
    actAdd: TAction;
    actRemove: TAction;
    ActionList1: TActionList;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    ButtonPanel1: TButtonPanel;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    DirectoryEdit1: TDirectoryEdit;
    FileNameEdit1: TFileNameEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    PageControl1: TPageControl;
    PageManager1: TPageManager;
    Panel1: TPanel;
    Panel2: TPanel;
    RadioGroup1: TRadioGroup;
    RxIniPropStorage1: TRxIniPropStorage;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TreeView1: TTreeView;
    TreeView2: TTreeView;
    procedure actAddExecute(Sender: TObject);
    procedure actRemoveExecute(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    procedure TreeView2DblClick(Sender: TObject);
  private
    FCurDB:TDataBaseRecord;
    procedure FillDBList;
    procedure SetCurDB(AValue: TDataBaseRecord);
    procedure DoLoadItems;
    procedure Localize;

    function DoMakeScript:string;
    procedure DoExportFile;
    procedure DoExportClipboard;
    procedure DoExportScript;
    procedure DoExportSepFiles;

    procedure DoUpdateControls;
  public
    property CurDB:TDataBaseRecord read FCurDB write SetCurDB;

    procedure DoExport;
  end;

var
  fbmExtractForm: TfbmExtractForm;

procedure ShowExtractForm;
implementation
uses SQLEngineAbstractUnit, IBManMainUnit, fbmStrConstUnit, fbmToolsUnit, Clipbrd,
  LazFileUtils, rxAppUtils;

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

procedure TfbmExtractForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if ModalResult = mrOk then
    DoExport;
end;

procedure TfbmExtractForm.CheckBox1Change(Sender: TObject);
begin
  TreeView1.Enabled:=not CheckBox1.Checked;
  TreeView2.Enabled:=not CheckBox1.Checked;
  DoUpdateControls;
end;

procedure TfbmExtractForm.actAddExecute(Sender: TObject);
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
    DoAddItem(nil, TreeView1.Selected);

  DoUpdateControls;
end;

procedure TfbmExtractForm.actRemoveExecute(Sender: TObject);
begin
  if Assigned(TreeView2.Selected) then
  begin
    TreeView2.Items.Delete(TreeView2.Selected);
    TreeView2.Selected:=nil;
  end;
  DoUpdateControls;
end;

procedure TfbmExtractForm.FormCreate(Sender: TObject);
begin
  {$IFDEF WINDOWS}
  BitBtn2.AnchorSide[akRight].Control:=ButtonPanel1.OKButton;
  {$ELSE}
  BitBtn2.AnchorSide[akRight].Control:=ButtonPanel1.CancelButton;
  {$ENDIF}

  BitBtn2.AnchorSide[akTop].Control:=ButtonPanel1.CancelButton;
  BitBtn2.AnchorSide[akBottom].Control:=ButtonPanel1.CancelButton;

  //BitBtn1.AnchorSide[akRight].Control:=ButtonPanel1.CancelButton;
  BitBtn1.AnchorSide[akTop].Control:=ButtonPanel1.CancelButton;
  BitBtn1.AnchorSide[akBottom].Control:=ButtonPanel1.CancelButton;


  Localize;
  PageControl1.ActivePageIndex:=0;
  RadioGroup1.ItemIndex:=0;
  FillDBList;
  RadioGroup1Click(nil);
end;

procedure TfbmExtractForm.PageControl1Change(Sender: TObject);
begin
  if (PageControl1.ActivePage = TabSheet2) and (TreeView1.Items.Count = 0) then
    DoLoadItems;

  DoUpdateControls;
end;

procedure TfbmExtractForm.RadioGroup1Click(Sender: TObject);
begin
  Label2.Enabled:=RadioGroup1.ItemIndex = 0;
  FileNameEdit1.Enabled:=RadioGroup1.ItemIndex = 0;

  Label3.Enabled:=RadioGroup1.ItemIndex = 3;
  DirectoryEdit1.Enabled:=RadioGroup1.ItemIndex = 3;
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

  actAdd.Caption:=sAdd;
  actRemove.Caption:=sRemove;

  RadioGroup1.Caption:=sExtractTo;
  RadioGroup1.Items[0]:=sFile;
  RadioGroup1.Items[1]:=sClipboard;
  RadioGroup1.Items[2]:=sMenuSqlScript;
  RadioGroup1.Items[3]:=sSeparetedFiles;

  Label2.Caption:=sFileName;
  Label3.Caption:=sExportFolder;

  BitBtn1.Caption:=sPrior;
  BitBtn2.Caption:=sNext;
end;

function TfbmExtractForm.DoMakeScript: string;

function DoGetMetaSQL(D:TDBObject):string;
begin
  if Assigned(D) then
    Result:=D.DDLCreateSimple
  else
    Result:='';
end;

var
  St:string;
  N: TTreeNode;
  D: TDBInspectorRecord;
  i: Integer;
  FTr: TTreeView;
begin
  Result:='';
  if CheckBox1.Checked then
    FTr:=TreeView1
  else
    FTr:=TreeView2;

  for i:=0 to FTr.Items.Count-1 do
  begin
    N:=FTr.Items[i];
    if Assigned(N.Data) then
    begin
      D:=TDBInspectorRecord(N.Data);
      if Assigned(D) then
        Result:=Result + DoGetMetaSQL(D.DBObject);
    end;
  end;
end;

procedure TfbmExtractForm.DoExportFile;
var
  S: String;
begin
  S:=DoMakeScript;
  if S <> '' then
  begin
    //if FileNameEdit1.FileName;
    SaveTextFile(S, FileNameEdit1.FileName);
  end;
end;

procedure TfbmExtractForm.DoExportClipboard;
var
  S: String;
begin
  S:=DoMakeScript;
  if S<>'' then
  begin
    Clipboard.Open;
    Clipboard.AsText:=S;
    Clipboard.Close;
  end;
end;

procedure TfbmExtractForm.DoExportScript;
var
  S: String;
begin
  S:=DoMakeScript;
  if S <> '' then
  begin
    fbManagerMainForm.tlsSqlScript.Execute;
    FBMSqlScripForm.SetSQLText(S);
  end;
end;

procedure TfbmExtractForm.DoExportSepFiles;
var
  D: TDBInspectorRecord;
  i: Integer;
  N: TTreeNode;
  FName: String;
  FTr: TTreeView;
begin
  if CheckBox1.Checked then
    FTr:=TreeView1
  else
    FTr:=TreeView2;

  for i:=0 to FTr.Items.Count-1 do
  begin
    N:=FTr.Items[i];
    if Assigned(N.Data) then
    begin
      D:=TDBInspectorRecord(N.Data);
      if Assigned(D.DBObject) and (D.DBObject.State <> sdboVirtualObject) then
      begin
        FName:=AppendPathDelim(DirectoryEdit1.Directory) + D.DBObject.CaptionFullPatch + '.' + D.DBObject.DBClassTitle;
        SaveTextFile(D.DBObject.DDLCreateSimple, FName);
      end;
    end;
  end;
end;

procedure TfbmExtractForm.DoUpdateControls;
begin
  actAdd.Enabled:=not CheckBox1.Checked;
  actRemove.Enabled:=not CheckBox1.Checked;

  ButtonPanel1.OKButton.Enabled:=PageControl1.ActivePageIndex = 2;
end;

procedure TfbmExtractForm.DoExport;
begin
  case RadioGroup1.ItemIndex of
    0:DoExportFile;
    1:DoExportClipboard;
    2:DoExportScript;
    3:DoExportSepFiles;
  else
  end;
end;

end.

