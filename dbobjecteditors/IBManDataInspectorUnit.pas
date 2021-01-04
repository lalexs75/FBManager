{ Free DB Manager

  Copyright (C) 2005-2021 Lagunov Aleksey  alexs75 at yandex.ru

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

unit IBManDataInspectorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, ComCtrls, ActnList,
  Menus, IBManagerTypesUnit, StdCtrls, ExtCtrls, LMessages, Buttons,
  TreeFilterEdit, RxIniPropStorage, fbmToolsUnit, SQLEngineAbstractUnit, fbmOIFoldersUnit;

type
  TfbManDataInpectorForm = class;
  TFBMDataBaseListEnumerator = class;

  { TFBMDataBaseList }

  TFBMDataBaseList = class
  private
    FList:TFPList;
    FOwner:TfbManDataInpectorForm;
    function GetCount: integer;
    function GetDBItem(AIndex: integer): TDataBaseRecord;
  public
    constructor Create(AOwner:TfbManDataInpectorForm);
    destructor Destroy; override;
    procedure Clear;
    procedure Add(AObject:TDataBaseRecord);
    procedure Delete(AObject:TDataBaseRecord);
    procedure Extract(AObject:TDataBaseRecord);
    function IndexOf(AObject:TDataBaseRecord):integer;
    function GetEnumerator: TFBMDataBaseListEnumerator;

    function FillDataBaseList(const AItems:TStrings):integer; overload;
    function FillDataBaseList(const AItems:TStrings; AClass:TSQLEngineAbstractClass):integer; overload;
    function FillServerList(const AItems:TStrings):integer; overload;
    function FillServerList(const AItems:TStrings; AClass:TSQLEngineAbstractClass):integer; overload;

    property Items[AIndex:integer]:TDataBaseRecord read GetDBItem; default;
    property Count:integer read GetCount;
  end;

  { TFBMDataBaseListEnumerator }

  TFBMDataBaseListEnumerator = class
  private
    FList: TFBMDataBaseList;
    FPosition: Integer;
  public
    constructor Create(AList: TFBMDataBaseList);
    function GetCurrent: TDataBaseRecord;
    function MoveNext: Boolean;
    property Current: TDataBaseRecord read GetCurrent;
  end;

  { TfbManDataInpectorForm }

  TfbManDataInpectorForm = class(TForm)
    MenuItem37: TMenuItem;
    objRename: TAction;
    fldCollapseAll: TAction;
    fldExpandAll: TAction;
    fldEdit: TAction;
    fldRemove: TAction;
    fldNew: TAction;
    Label1: TLabel;
    MenuItem1: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    MenuItem32: TMenuItem;
    MenuItem33: TMenuItem;
    MenuItem34: TMenuItem;
    MenuItem35: TMenuItem;
    MenuItem36: TMenuItem;
    MenuItem5: TMenuItem;
    Panel1: TPanel;
    PopupMenu2: TPopupMenu;
    RxIniPropStorage1: TRxIniPropStorage;
    saHideSQLAssistent: TAction;
    saCopyAllLines: TAction;
    saCopyLine: TAction;
    dbRegisterFromCopy: TAction;
    ListBox1: TListBox;
    miContextTools: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
    MenuItem29: TMenuItem;
    objGoDomains: TAction;
    objGoTables: TAction;
    objGoSP: TAction;
    objGoTriggers: TAction;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    objFind: TAction;
    objGoViews: TAction;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    miskShowAssitent: TAction;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    objRefresh: TAction;
    MenuItem14: TMenuItem;
    objDelete: TAction;
    MenuItem13: TMenuItem;
    objNew: TAction;
    editSQL: TAction;
    LB_SQLAssistent: TListBox;
    listWindows: TListBox;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem9: TMenuItem;
    objShow: TAction;
    dbDisconect: TAction;
    dbConnect: TAction;
    dbUnregister: TAction;
    dbRegitrationEdit: TAction;
    dbRegister: TAction;
    ActionList1: TActionList;
    miRegisterDB: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    miCreateDB: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    Pagecontrol1: TPAGECONTROL;
    PopupMenu1: TPopupMenu;
    Splitter1: TSplitter;
    Tabsheet1: TTABSHEET;
    Tabsheet2: TTABSHEET;
    TabSheet3: TTabSheet;
    TreeFilterEdit1: TTreeFilterEdit;
    TreeView1: TTreeView;
    procedure fldEditExecute(Sender: TObject);
    procedure fldExpandAllExecute(Sender: TObject);
    procedure fldNewExecute(Sender: TObject);
    procedure fldRemoveExecute(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure listWindowsClick(Sender: TObject);
    procedure miCreateDBClick(Sender: TObject);
    procedure objRenameExecute(Sender: TObject);
    procedure saCopyAllLinesExecute(Sender: TObject);
    procedure saCopyLineExecute(Sender: TObject);
    procedure saHideSQLAssistentExecute(Sender: TObject);
    function TreeFilterEdit1FilterNode(ItemNode: TTreeNode; out Done: Boolean
      ): Boolean;
    procedure TreeView1CustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure TreeView1Expanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure TreeView1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure dbDisconectExecute(Sender: TObject);
    procedure dbRegisterFromCopyExecute(Sender: TObject);
    procedure dbUnregisterExecute(Sender: TObject);
    procedure IBManDataInpectorFormClose(Sender: TObject;
      var CloseAction: TCloseAction);
    procedure IBManDataInpectorFormCreate(Sender: TObject);
    procedure IBManDataInpectorFormDestroy(Sender: TObject);
    procedure miskShowAssitentExecute(Sender: TObject);
    procedure objRefreshExecute(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure TreeView1Click(Sender: TObject);
    procedure dbConnectExecute(Sender: TObject);
    procedure dbCreateDatabaseExecute(Sender: TObject);
    procedure dbRegisterExecute(Sender: TObject);
    procedure dbRegitrationEditExecute(Sender: TObject);
    procedure editSQLExecute(Sender: TObject);
    procedure objDeleteExecute(Sender: TObject);
    procedure objNewExecute(Sender: TObject);
    procedure objShowExecute(Sender: TObject);
    procedure LMChangeParams(var message: TLMNoParams); message LM_EDITOR_CHANGE_PARMAS;
    procedure TreeView1SelectionChanged(Sender: TObject);
  private
    FDBList:TFBMDataBaseList;
    FFolders:TOIFolderList;
    procedure DoChangePrefParams;
    function DBNewRegistration(ASQLEngine, CopyFrom:TSQLEngineAbstract):TDataBaseRecord;
    procedure UpdateSQLAssitant(ARec:TDBInspectorRecord);
    procedure DoCreateRegisterMenu;
    procedure MakeContextMenu;
    procedure ShowSqlAssitent(AShow:boolean);
    procedure Localize;
  public
    procedure ReadAlialList;
    function CurrentDB:TDataBaseRecord;
    function DBByName(ANameDB:string):TDataBaseRecord;
    function DBBySQLEngine(SQLEngine:TSQLEngineAbstract):TDataBaseRecord;
    function CurrentObject:TDBInspectorRecord;
    function CurrentFolder:TOIFolder;
    procedure UpdateDBManagerState;
    procedure CloseAllDB;
    function RegisterNewDB(ASQLEngine: TSQLEngineAbstract):TDataBaseRecord;
    procedure CreateNewDB(ASqlEngineName:string);
    procedure EditObject(DBObject:TDBObject);
    procedure SelectObject(DBObject:TDBObject);
    procedure UpdateRecentObjects;
    function OIFolderByName(AFolderName:string):TOIFolder;
  public
    property DBList:TFBMDataBaseList read FDBList;
    property Folders:TOIFolderList read FFolders;
  end;

var
  fbManDataInpectorForm: TfbManDataInpectorForm;

procedure ShowFBManDataInpectorForm(AMainForm:TForm);
implementation
uses IBManMainUnit, fbmStrConstUnit, fbmConnectionEditUnit,
  fbmUserDataBaseUnit, LazUTF8, fbm_VisualEditorsAbstractUnit, Clipbrd,
  SQLEngineCommonTypesUnit, Dialogs, fbmDBObjectEditorUnit;

{$R *.lfm}

procedure ShowFBManDataInpectorForm(AMainForm:TForm);
begin
  if not Assigned(fbManDataInpectorForm) then
  begin
    fbManDataInpectorForm:=TfbManDataInpectorForm.Create(fbManagerMainForm.InspectorPanel);
    fbManDataInpectorForm.BorderStyle:=bsNone;
    fbManDataInpectorForm.Align:=alClient;
    fbManDataInpectorForm.Parent:=fbManagerMainForm.InspectorPanel;
    fbManDataInpectorForm.Visible:=true;
  end
end;

{ TFBMDataBaseListEnumerator }

constructor TFBMDataBaseListEnumerator.Create(AList: TFBMDataBaseList);
begin
  FList := AList;
  FPosition := -1;
end;

function TFBMDataBaseListEnumerator.GetCurrent: TDataBaseRecord;
begin
  Result := FList[FPosition];
end;

function TFBMDataBaseListEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TfbManDataInpectorForm }

procedure TfbManDataInpectorForm.IBManDataInpectorFormCreate(Sender: TObject);
var
  b:integer;
begin
  TreeView1.Items.Clear;
  Localize;
  Pagecontrol1.ActivePageIndex:=0;
  b:=30;
  Left:=0;
  Top:=fbManagerMainForm.Top + fbManagerMainForm.Height + b;
  Height:=Screen.Height - Top - b;

  FDBList:=TFBMDataBaseList.Create(Self);
  FFolders:=TOIFolderList.Create;
  DoChangePrefParams;

  DoCreateRegisterMenu;
end;

procedure TfbManDataInpectorForm.IBManDataInpectorFormDestroy(Sender: TObject);
begin
  fbManDataInpectorForm:=nil;
  FreeAndNil(FFolders);
  FreeAndNil(FDBList);
end;

procedure TfbManDataInpectorForm.IBManDataInpectorFormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caHide;
  fbManagerMainForm.BringToFront;
end;

procedure TfbManDataInpectorForm.dbUnregisterExecute(Sender: TObject);
var
  R:TDataBaseRecord;
  Itm:TTreeNode;
begin
  R:=CurrentDB;
  if Assigned(R) then
  begin
    if QuestionBox(sUnregisterDatabase) then
    begin
      if R.Connected then
        R.Connected:=false;
      UserDBModule.DeleteDataBase(R.SQLEngine.DatabaseID);
      Itm:=R.FOwner;
      Itm.Data:=nil;
      FDBList.Delete(R);
      TreeView1.Items.Delete(Itm);
      UpdateDBManagerState;
    end;
  end;
end;

procedure TfbManDataInpectorForm.dbDisconectExecute(Sender: TObject);
var
  Rec:TDataBaseRecord;
begin
  Rec:=CurrentDB;
  if Assigned(Rec) then
  begin
    Rec.Connected:=false;
    TreeView1.Selected:=Rec.FOwner;
  end;
  UpdateDBManagerState;
end;

procedure TfbManDataInpectorForm.TreeView1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  Rec:TDBInspectorRecord;
  Node:TTreeNode;
  S:TStringList;
  F: TOIFolder;
  SH: String;
begin
  if ConfigValues.ByNameAsBoolean('oiShowObjDescAsHint', true) then
  begin
    Node:=TreeView1.GetNodeAt(X, Y);
    if Assigned(Node) and Assigned(Node.Data) then
    begin
      //Application.CancelHint;

      if TObject(Node.Data) is TOIFolder then
      begin
        F:=TOIFolder(Node.Data);
        SH:=F.Description;
      end
      else
      begin
        Rec:=TDataBaseRecord(Node.Data);
        if Rec is TDataBaseRecord then
        begin
          S:=TStringList.Create;
          try
            Rec.SetSqlAssistentData(S);
            SH:=S.Text;
            if Rec.Description<>'' then
              SH:=SH + LineEnding + '----------------------------------------' + LineEnding + Rec.Description;
          finally
            S.Free;
          end;
        end
        else
          SH:=Rec.Description;
        if TreeView1.Hint <> SH then
        begin
          Application.CancelHint;
          TreeView1.Hint:=SH;
          Application.ActivateHint(Mouse.CursorPos, true);
        end;
      end;
    end
    else
      TreeView1.Hint:='';
  end;
end;

procedure TfbManDataInpectorForm.TreeView1CustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  DefaultDraw:=true;
  if Assigned(Node) and Assigned(Node.Data) and (TObject(Node.Data) is TDBInspectorRecord) then
    TreeView1.Font.Color:=TDBInspectorRecord(Node.Data).CaptionColor
  else
    TreeView1.Font.Color:=clWindowText;
end;

procedure TfbManDataInpectorForm.TreeView1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  ANode, N, FSelected: TTreeNode;
  SelectedDB: TDataBaseRecord;
  K, i, i1: Integer;
begin
  ANode:=TreeView1.GetNodeAt(X,Y);
  if Assigned(ANode) and Assigned(ANode.Data) and Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) then
  begin
    FSelected:=TreeView1.Selected;
    if (TObject(FSelected.Data) is TDataBaseRecord) then
    begin
      SelectedDB:=TDataBaseRecord(FSelected.Data);
      if (TObject(ANode.Data) is TOIFolder) then
      begin
        SelectedDB.OIFolder:=TOIFolder(ANode.Data);
        ANode.Expanded:=true;
        K:=ANode.Count;
      end
      else
      if (TObject(ANode.Data) is TDataBaseRecord) then
      begin
        SelectedDB.OIFolder := TDataBaseRecord(ANode.Data).OIFolder;
        K:=TDataBaseRecord(ANode.Data).SortOrder;
        if Assigned(ANode.Parent) then
        begin
          for i:=ANode.Parent.IndexOf(ANode) to ANode.Parent.Count-1 do
          begin;
            N:=ANode.Parent.Items[i];
            if Assigned(N) and Assigned(N.Data) then
            begin
              if (TObject(N.Data) is TDataBaseRecord) then
              begin
                TDataBaseRecord(N.Data).SortOrder:=TDataBaseRecord(N.Data).SortOrder + 1;
                TDataBaseRecord(N.Data).Save;
              end;
            end;
          end;
        end
        else
        begin
          i1:=ANode.Index;
          for i:=i1 to TreeView1.Items.Count - 1 do
          begin
            N:=TreeView1.Items[i];
            if not Assigned(N.Parent) then
            begin
              TDataBaseRecord(N.Data).SortOrder:=TDataBaseRecord(N.Data).SortOrder + 1;
              TDataBaseRecord(N.Data).Save;
            end;
          end;
        end;
        FSelected.MoveTo(ANode, naInsert)
      end;
      SelectedDB.SortOrder:=K;
      SelectedDB.Save;
    end
    else
    if (TObject(TreeView1.Selected.Data) is TOIFolder) and (TObject(ANode.Data) is TOIFolder) then
    begin
      K:=TOIFolder(ANode.Data).SortOrder;
      i1:=ANode.Index;
{      for i:=i1 to TreeView1.Items.Count - 1 do
      begin
        N:=TreeView1.Items[i];
        if not Assigned(N.Parent) and (TObject(N.Data) is TOIFolder) then
        begin
          TOIFolder(N.Data).SortOrder:=TOIFolder(N.Data).SortOrder + 1;
          TOIFolder(N.Data).Save;
        end;
      end;}
      for i:=i1 to TreeView1.Items.TopLvlCount - 1 do
      begin
        N:=TreeView1.Items.TopLvlItems[i];
        if not Assigned(N.Parent) and (TObject(N.Data) is TOIFolder) then
        begin
          TOIFolder(N.Data).SortOrder:=TOIFolder(N.Data).SortOrder + 1;
          TOIFolder(N.Data).Save;
        end;
      end;

      TOIFolder(TreeView1.Selected.Data).SortOrder:=K;
      TOIFolder(TreeView1.Selected.Data).Save;
      TreeView1.Selected.MoveTo(ANode, naInsert)
    end;
  end;
end;

procedure TfbManDataInpectorForm.listWindowsClick(Sender: TObject);
begin
{  if Assigned(WindowTabs) then
    if (listWindows.Items.Count>0) and (listWindows.ItemIndex>=0) and (listWindows.ItemIndex < listWindows.Items.Count) then
      WindowTabs.SelectWindow(listWindows.Items[listWindows.ItemIndex], listWindows);}
end;

procedure TfbManDataInpectorForm.miCreateDBClick(Sender: TObject);
begin
  fbManagerMainForm.dbCreate.Execute;
end;

procedure TfbManDataInpectorForm.objRenameExecute(Sender: TObject);
var
  S: String;
begin
  S:=CurrentObject.DBObject.Caption;
  if InputQuery(sRenameObject, Format(sRename, [CurrentObject.ObjectType, CurrentObject.DBObject.Caption]), S) then
    CurrentObject.RenameTo(S);
end;

procedure TfbManDataInpectorForm.saCopyAllLinesExecute(Sender: TObject);
var
  S:string;
  i:integer;
begin
  S:='';
  for i:=0 to LB_SQLAssistent.Items.Count-1 do
    S:=S + LB_SQLAssistent.Items[i] + LineEnding;
  if S<>'' then
  begin
    Clipboard.Open;
    Clipboard.AsText:=S;
    Clipboard.Close;
  end;
end;

procedure TfbManDataInpectorForm.saCopyLineExecute(Sender: TObject);
begin
  if (LB_SQLAssistent.Items.Count>0) and (LB_SQLAssistent.ItemIndex>=0) and (LB_SQLAssistent.Items.Count>LB_SQLAssistent.ItemIndex) then
  begin
    Clipboard.Open;
    Clipboard.AsText:=LB_SQLAssistent.Items[LB_SQLAssistent.ItemIndex];
    Clipboard.Close;
  end;
end;

procedure TfbManDataInpectorForm.saHideSQLAssistentExecute(Sender: TObject);
begin
  ShowSqlAssitent(false);
end;

function TfbManDataInpectorForm.TreeFilterEdit1FilterNode(ItemNode: TTreeNode;
  out Done: Boolean): Boolean;
var
  S1, S2: String;
begin
  if Assigned(ItemNode.Data) then
  begin
    Done:=false;
    S1:=UTF8UpperCase(TreeFilterEdit1.Text);
    S2:=UTF8UpperCase(ItemNode.Text);
    Result:=Pos(S1, S2)>0;
  end
  else
  begin
    S1:=UTF8UpperCase(TreeFilterEdit1.Text);
    S2:=UTF8UpperCase(ItemNode.Parent.Text);
    Result:=Pos(S1, S2)>0;
    Done:=true;
  end;
end;

procedure TfbManDataInpectorForm.ListBox1DblClick(Sender: TObject);
var
  R:TDataBaseRecord;
  S:string;
begin
  if (ListBox1.ItemIndex>=0) and (ListBox1.ItemIndex<ListBox1.Items.Count) then
  begin
    R:=TDataBaseRecord(ListBox1.Items.Objects[ListBox1.ItemIndex]);
    S:=ListBox1.Items[ListBox1.ItemIndex];
    Delete(S, 1, Pos('->', S)+1);
    S:=Copy(S, 1, Pos(' : ', S)-1);
    R.ObjectShowEditor(S);
  end;
end;

procedure TfbManDataInpectorForm.fldNewExecute(Sender: TObject);
var
  S: String;
begin
  S:='';
  if InputQuery(sCreateNewFolderText, sCreateNewFolderTitle, S) then
  begin
    FFolders.Add(TreeView1.Items.AddChild(nil, S)).Save;
  end;
end;

procedure TfbManDataInpectorForm.fldRemoveExecute(Sender: TObject);
var
  F: TOIFolder;
begin
  F:=CurrentFolder;
  if Assigned(F) and QuestionBox(sDeleteDBFolder) then
  begin
    F.Delete;
    F.Free;
  end;
end;

procedure TfbManDataInpectorForm.fldEditExecute(Sender: TObject);
var
  F: TOIFolder;
begin
  F:=CurrentFolder;
  if Assigned(F) then
    if F.Edit then
      F.Save;
end;

procedure TfbManDataInpectorForm.fldExpandAllExecute(Sender: TObject);
procedure DoExpand(ARoot:TTreeNode);
var
  N: TTreeNode;
  i: Integer;
begin
  for i:=0 to ARoot.Count-1 do
  begin
    N:=ARoot.Items[i];
    N.Expanded:=TComponent(Sender).Tag > 0;
    DoExpand(N);
  end;
end;
begin
  TreeView1.BeginUpdate;
  try
    DoExpand(TreeView1.Selected);
  finally
    TreeView1.EndUpdate;
  end;
end;

procedure TfbManDataInpectorForm.TreeView1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  Rec:TDataBaseRecord;
  ANode: TTreeNode;
begin
  Accept:=false;
  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) then
  begin
    if TObject(TreeView1.Selected.Data) is TDataBaseRecord then
    begin
      ANode:=TreeView1.GetNodeAt(X,Y);
      if Assigned(ANode) and Assigned(ANode.Data) and (TObject(ANode.Data) is TOIFolder) then
        Accept:=true
      else
      if Assigned(ANode) and Assigned(ANode.Data) and (TObject(ANode.Data) is TDataBaseRecord) then
        Accept:=true
      else
      begin
        Rec:=TDataBaseRecord(TreeView1.Selected.Data);
        if Assigned(Rec) and (Rec.ObjectType<>'') then
          Accept:=true;
      end;
    end
    else
    if TObject(TreeView1.Selected.Data) is TOIFolder then
    begin
      ANode:=TreeView1.GetNodeAt(X,Y);
      if Assigned(ANode) and Assigned(ANode.Data) and (TObject(ANode.Data) is TOIFolder) then
        Accept:=true
    end;
  end
end;

procedure TfbManDataInpectorForm.TreeView1Expanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
begin
  //
end;

procedure TfbManDataInpectorForm.dbRegisterFromCopyExecute(Sender: TObject);
var
  Rec:TDataBaseRecord;
begin
  Rec:=CurrentDB;
  if Assigned(Rec) then
    DBNewRegistration(CreateSQLEngine(Rec.SQLEngine.ClassName), Rec.SQLEngine);
end;

procedure TfbManDataInpectorForm.miskShowAssitentExecute(Sender: TObject);
begin
  ShowSqlAssitent(not miskShowAssitent.Checked);
end;

procedure TfbManDataInpectorForm.objRefreshExecute(Sender: TObject);
var
  FC: TDBInspectorRecord;
begin
  FC:=CurrentObject;
  if Assigned(FC) and FC.OwnerDB.Connected then
    FC.Refresh;
  UpdateDBManagerState;
end;

procedure TfbManDataInpectorForm.TreeView1Change(Sender: TObject;
  Node: TTreeNode);
var
  Rec:TDBInspectorRecord;
begin
{  Rec:=CurrentObject;
  if Assigned(Rec) then
  begin
    objNew.Enabled:=Rec.ObjectType<>'';
    if objNew.Enabled then
      objNew.Caption:=sNew+Rec.ObjectType;
    objDelete.Enabled:=Rec.EnableDropped;
    if objDelete.Enabled then
      objDelete.Caption:=sDrop + Rec.ObjectType;
  end
  else
  begin
    objNew.Enabled:=false;
    objDelete.Enabled:=false;
  end;
  if not objNew.Enabled then
    objNew.Caption:=sNewObject;
    
  if not objDelete.Enabled then
    objDelete.Caption:=sDropObject;
    
}
end;

procedure TfbManDataInpectorForm.TreeView1Click(Sender: TObject);
var
  Rec: TDBInspectorRecord;
begin
  UpdateDBManagerState;

  Rec:=CurrentObject;
  if Assigned(Rec) then
  begin
    objNew.Enabled:=(Rec.ObjectType<>'') and Assigned(Rec.DBObject) and (not Rec.DBObject.SystemObject);
    if objNew.Enabled then
      objNew.Caption:=sNew+Rec.ObjectType;

    objDelete.Enabled:=Rec.EnableDropped;
    objRename.Enabled:=Rec.EnableRename;

    if objDelete.Enabled then
      objDelete.Caption:=sDrop + Rec.ObjectType;

    if objRename.Enabled then
      objRename.Caption:=Format(sRenameObject, [Rec.ObjectType, Rec.CaptionFullPatch]);
  end
  else
  begin
    objNew.Enabled:=false;
    objDelete.Enabled:=false;
    objRename.Enabled:=false;
  end;

  if not objNew.Enabled then
    objNew.Caption:=sNewObject;

  if not objDelete.Enabled then
    objDelete.Caption:=sDropObject;

  if not objRename.Enabled then
    objRename.Caption:=sRenameObject;

  fbManagerMainForm.UpdateActionsToolbar;
end;

procedure TfbManDataInpectorForm.dbConnectExecute(Sender: TObject);
var
  Item:TDBInspectorRecord;
begin
  Item:=CurrentObject;
  if not Item.OwnerDB.Connected then
  begin
    TreeView1.Items.BeginUpdate;
    try
      Item.OwnerDB.Connected:=true;
    except
      on E:Exception do
        ErrorBoxExcpt(E);
    end;
    TreeView1.Items.EndUpdate;
  end;
  UpdateDBManagerState;
end;

procedure TfbManDataInpectorForm.dbCreateDatabaseExecute(Sender: TObject);
begin
  UpdateDBManagerState;
end;

procedure TfbManDataInpectorForm.dbRegisterExecute(Sender: TObject);
begin
  DBNewRegistration(SQLEngineAbstractClassArray[(Sender as TComponent).Tag].SQLEngineClass.Create, nil);
  UpdateDBManagerState;
end;

procedure TfbManDataInpectorForm.dbRegitrationEditExecute(Sender: TObject);
begin
  if Assigned(CurrentDB) then
    if CurrentDB.Edit then
      UpdateDBManagerState;
end;

procedure TfbManDataInpectorForm.editSQLExecute(Sender: TObject);
var
  Item:TDBInspectorRecord;
begin
  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) and (TObject(TreeView1.Selected.Data) is TDBInspectorRecord) then
  begin
    Item:=TDBInspectorRecord(TreeView1.Selected.Data);
    if Assigned(Item) then
       Item.ShowSQLEditor;
  end;
end;

procedure TfbManDataInpectorForm.objDeleteExecute(Sender: TObject);
var
  Rec:TDBInspectorRecord;
  Grp:TDBInspectorRecord;
begin
  Rec:=CurrentObject;
  if Assigned(Rec) and (Rec.ObjectType<>'') then
  begin
    Grp:=Rec.OwnerDB.ObjectGroup(Rec);
    if Assigned(Grp) then
    begin
      Grp.DropObject(Rec);
      TreeView1.Selected:=Grp.FOwner;
    end;
  end;
  UpdateDBManagerState;
end;

procedure TfbManDataInpectorForm.objNewExecute(Sender: TObject);
var
  Rec:TDBInspectorRecord;
begin
  Rec:=CurrentObject;
  if Assigned(Rec) and (Rec.ObjectType<>'') then
    Rec.NewObject;
  UpdateDBManagerState;
end;

procedure TfbManDataInpectorForm.objShowExecute(Sender: TObject);
var
  Item:TDBInspectorRecord;
  F: TOIFolder;
begin
  Item:=CurrentObject;
  if Assigned(Item) then
  begin
    if Item is TDataBaseRecord then
      dbConnect.Execute
    else
    begin
      Item.ShowObject;
      LB_SQLAssistent.Items.Clear;
      Item.SetSqlAssistentData(LB_SQLAssistent.Items);
    end;
  end
  else
  begin
    F:=CurrentFolder;
    if Assigned(F) then
      F.Edit;
  end;
end;


procedure TfbManDataInpectorForm.LMChangeParams(var message: TLMNoParams);
begin
  inherited;
  DoChangePrefParams;
end;

procedure TfbManDataInpectorForm.TreeView1SelectionChanged(Sender: TObject);
begin
//  UpdateDBManagerState;
  TreeView1Click(Sender);
end;

procedure TfbManDataInpectorForm.DoChangePrefParams;
begin
  if ConfigValues.ByNameAsBoolean('oiDisableResize', false) then
  begin
    Constraints.MaxHeight:=Height;
    Constraints.MaxWidth:=Width;
    Constraints.MinHeight:=Height;
    Constraints.MinWidth:=Width;
  end
  else
  begin
    Constraints.MaxHeight:=0;
    Constraints.MaxWidth:=0;
    Constraints.MinHeight:=0;
    Constraints.MinWidth:=0;
  end;
  TreeView1.HotTrack:=ConfigValues.ByNameAsBoolean('oiHotTrack', false);
end;


function TfbManDataInpectorForm.DBNewRegistration(ASQLEngine, CopyFrom:TSQLEngineAbstract):TDataBaseRecord;
var
  aNode:TTreeNode;
begin
  Result:=nil;
  fbmConnectionEditForm:=TfbmConnectionEditForm.Create(ASQLEngine);
  fbmConnectionEditForm.LoadParams(CopyFrom);
  if fbmConnectionEditForm.ShowModal = mrOk then
  begin
    aNode:=TreeView1.Items.AddChild(nil, '');
    Result:=TDataBaseRecord.Create(aNode, ASQLEngine);
    DBList.Add(Result);
    Result.Save;
  end
  else
    ASQLEngine.Free;
  fbmConnectionEditForm.Free;
end;

procedure TfbManDataInpectorForm.UpdateSQLAssitant(ARec:TDBInspectorRecord);
begin
  LB_SQLAssistent.Items.Clear;
  if Assigned(ARec) then
    ARec.SetSqlAssistentData(LB_SQLAssistent.Items);
end;

procedure TfbManDataInpectorForm.DoCreateRegisterMenu;
var
  i:integer;

procedure DoCreateMItem(const ACaption:string; AOwner:TMenu;
  AItem:TMenuItem; OnExec:TNotifyEvent);
var
  M: TMenuItem;
begin
  M:=TMenuItem.Create(AOwner);
  M.Caption:=ACaption + SQLEngineAbstractClassArray[i].SQLEngineClass.GetEngineName;
  M.Tag:=i;
  M.Hint:=ACaption + SQLEngineAbstractClassArray[i].Description;
  M.OnClick:=OnExec;
  if Assigned(AItem) then
    AItem.Add(M)
  else
    AOwner.Items.Add(M);
end;

begin
  for i:=0 to SQLEngineAbstractClassCount - 1 do
  begin
    DoCreateMItem(sRegister, PopupMenu1, miRegisterDB, @dbRegisterExecute);
    DoCreateMItem(sRegister, fbManagerMainForm.MainMenu1, fbManagerMainForm.miRegisterDB, @dbRegisterExecute);
    DoCreateMItem(sRegister, fbManagerMainForm.tmRegister, nil, @dbRegisterExecute);
  end;
end;

procedure TfbManDataInpectorForm.MakeContextMenu;

procedure DoMakeConextMenu(ADBVisualTools:TDBVisualToolsClass);
var
  i:integer;
  M:TMenuItem;
  R: TMenuItemRec;
begin
  if not Assigned(ADBVisualTools) then exit;
  for i:=0 to ADBVisualTools.GetMenuItemCount-1 do
  begin
    M:=TMenuItem.Create(PopupMenu1);
    R:=ADBVisualTools.GetMenuItems(i);
    M.Caption:=R.ItemName;
    M.Hint:=R.ItemHint;
    M.OnClick:=R.OnClick;
    M.ImageIndex:=R.ImageIndex;
    miContextTools.Add(M);
  end;
end;

var
  i:integer;
begin
  miContextTools.Clear;
  if not Assigned(CurrentDB) then exit;
  for i:=0 to SQLEngineAbstractClassCount-1 do
  begin
    if SQLEngineAbstractClassArray[i].SQLEngineClass = CurrentDB.SQLEngine.ClassType then
    begin
      DoMakeConextMenu(SQLEngineAbstractClassArray[i].VisualToolsClass);
      exit;
    end;
  end
end;

procedure TfbManDataInpectorForm.ShowSqlAssitent(AShow: boolean);
begin
  miskShowAssitent.Checked:=AShow;
  LB_SQLAssistent.Visible:=AShow;
  if AShow then
    Splitter1.Top:=LB_SQLAssistent.Top - Splitter1.Height;
end;

procedure TfbManDataInpectorForm.Localize;
begin
  Tabsheet1.Caption:=sOIDatabases;
  Tabsheet2.Caption:=sOIWindows;
  Tabsheet3.Caption:=sOIRecent;

  MenuItem21.Caption:=sOIGotoToObject;
  miCreateDB.Caption:=sMenuCreateDB;
  miRegisterDB.Caption:=sOIRegisterDB;
  miContextTools.Caption:=sMenuTools;

  dbRegister.Caption:=sMenuRegisterDB;
  dbRegister.Hint:=sMenuRegisterDBHint;

  dbRegitrationEdit.Caption:=sOIEditDBRegistration;
  dbRegitrationEdit.Hint:=sOIEditDBRegistrationHint;

  dbUnregister.Caption:=sMenuUnRegisterDB;
  dbUnregister.Hint:=sMenuUnRegisterDBHint;

  dbConnect.Caption:=sMenuConnectDB;
  dbConnect.Hint:=sMenuConnectDBHint;
  dbDisconect.Caption:=sMenuDisconnectDB;
  dbDisconect.Hint:=sMenuDisconnectDBHint;
  objRefresh.Caption:=sMenuRefresh;
  objRefresh.Hint:=sMenuRefreshHint;

  dbRegisterFromCopy.Caption:=sOICopyRegistration;
  dbRegisterFromCopy.Hint:=sOICopyRegistrationHint;
  editSQL.Caption:=sMenuSQLEditor;
  editSQL.Hint:=sMenuSQLEditorHint;

  miskShowAssitent.Caption:=sOIShowSQLAssistent;
  miskShowAssitent.Hint:=sOIShowSQLAssistentHint;
  objShow.Caption:=sOIShowObject;
  objShow.Hint:=sOIShowObjectHint;
  objGoDomains.Caption:=sOIGoToDomains;
  objGoDomains.Hint:=sOIGoToDomainsHint;
  objGoTables.Caption:=sOIGoToTables;
  objGoTables.Hint:=sOIGoToTablesHint;
  objGoViews.Caption:=sOIGoToViews;
  objGoViews.Hint:=sOIGoToViewsHint;
  objGoSP.Caption:=sOIGoToSP;
  objGoSP.Hint:=sOIGoToSPHint;
  objGoTriggers.Caption:=sOIGoToTriggers;
  objGoTriggers.Hint:=sOIGoToTriggersHint;
  objFind.Caption:=sOIFindObject;
  objFind.Hint:=sOIFindObjectHint;
  saCopyLine.Caption:=sOICopyLine;
  saCopyLine.Hint:=sOICopyLineHint;
  saCopyAllLines.Caption:=sOICopyAllLines;
  saCopyAllLines.Hint:=sOICopyAllLinesHint;
  saHideSQLAssistent.Caption:=sOIHideSQLAssistent;
  saHideSQLAssistent.Hint:=sOIHideSQLAssistentHint;
  fldNew.Caption:=sNewDBFolder;
  fldEdit.Caption:=sEditDBFolder;
  fldRemove.Caption:=sDelBFolder;

  Label1.Caption:=sFind;
  fldExpandAll.Caption:=sExpandAll;
  fldCollapseAll.Caption:=sCollapseAll;
end;

procedure TfbManDataInpectorForm.UpdateDBManagerState;
var
  Rec:TDBInspectorRecord;
  F: TOIFolder;
begin
  Rec:=CurrentObject;
  if Assigned(Rec) then
  begin
    dbConnect.Enabled:=not Rec.OwnerDB.Connected;
    dbDisconect.Enabled:=Rec.OwnerDB.Connected;
    objRefresh.Enabled:=Rec.OwnerDB.Connected;
    editSQL.Enabled:=Rec.OwnerDB.Connected;
    UpdateSQLAssitant(Rec);
  end
  else
  begin
    dbConnect.Enabled:=false;
    dbDisconect.Enabled:=false;
    objRefresh.Enabled:=false;
    editSQL.Enabled:=false;
    if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) and
       (TObject(TreeView1.Selected.Data) is TOIFolder) then
    begin
      LB_SQLAssistent.Items.Clear;
      LB_SQLAssistent.Items.Text:=TOIFolder(TreeView1.Selected.Data).Description;
    end
    else
      UpdateSQLAssitant(nil);
  end;

  F:=CurrentFolder;
  fldEdit.Enabled:=Assigned(F);
  fldRemove.Enabled:=Assigned(F);
  MakeContextMenu;
  if Assigned(fbManagerMainForm) then
    fbManagerMainForm.UpdateActionsToolbar;
end;

procedure TfbManDataInpectorForm.CloseAllDB;
var
  i:integer;
begin
  if Assigned(DBList) then
    for i:=0 to DBList.Count-1 do
      if (Assigned(DBList[i])) and  DBList[i].Connected then
        DBList[i].Connected:=false;
  FFolders.SaveAll;
end;

function TfbManDataInpectorForm.RegisterNewDB(ASQLEngine: TSQLEngineAbstract):TDataBaseRecord;
begin
  Result:=DBNewRegistration(ASQLEngine, nil);
  if Assigned(Result) then
  begin
    UpdateDBManagerState;
//    SaveAliasList;
  end;
end;

procedure TfbManDataInpectorForm.CreateNewDB(ASqlEngineName: string);
var
  i:integer;
  P:TSQLEngineCreateDBAbstractClass;
  SQLEngine:TSQLEngineAbstract;
  DB:TDataBaseRecord;
begin
  for i:=0 to SQLEngineAbstractClassCount - 1 do
  begin
    if SQLEngineAbstractClassArray[i].SQLEngineClass.ClassName = ASqlEngineName then
    begin
      P:=SQLEngineAbstractClassArray[i].VisualToolsClass.GetCreateObject;
      if Assigned(P) then
      begin
        if P.Execute and P.RegisterAfterCreate then
        begin
          SQLEngine:=P.CreateSQLEngine;
          if Assigned(SQLEngine) then
          begin
            DB:=fbManDataInpectorForm.RegisterNewDB(SQLEngine);
            if Assigned(DB) and P.LogMetadata and (P.CreateSQL<>'') then
              DB.WriteSQLFile(P.LogFileMetadata, P.CreateSQL);
          end;
        end;
        P.Free;
      end
      else
        NotImplemented;
      exit;
    end;
  end;
end;
{
procedure TfbManDataInpectorForm.FillServerList(const AList: TStrings);
var
  i:integer;
begin
  AList.Clear;
  for i:=0 to DBList.Count - 1 do
    if (DBList[i].SQLEngine.ServerName<>'') and (AList.IndexOf(DBList[i].SQLEngine.ServerName)<0) then
      AList.Add(DBList[i].SQLEngine.ServerName);
end;

function TfbManDataInpectorForm.FillServerListType(const AList: TStrings;
  AClass: TSQLEngineAbstractClass): integer;
var
  ACurrentDB, D:TDataBaseRecord;
  K: Integer;
begin
  AList.Clear;
  Result:=-1;
  ACurrentDB:=CurrentDB;
  for D in DBList do
  begin
    if ((D.SQLEngine.ClassType = AClass) or (AClass = nil)) and (D.SQLEngine.ServerName<>'') and (AList.IndexOf(D.SQLEngine.ServerName)<0) then
    begin
      K:=AList.AddObject(D.SQLEngine.AliasName, D.SQLEngine);
      if (Result=-1) and (ACurrentDB = D) then
        Result:=K;
    end;
  end;
end;
}
procedure TfbManDataInpectorForm.EditObject(DBObject: TDBObject);
var
  R:TDBInspectorRecord;
  D: TDataBaseRecord;
begin
  if Assigned(DBObject) then
  begin
    D:=DBBySQLEngine(DBObject.OwnerDB);
    if Assigned(D) then
    begin
      R:=D.FindDBObject(DBObject);
      if Assigned(R) then
        R.Edit;
    end;
  end
end;

procedure TfbManDataInpectorForm.SelectObject(DBObject: TDBObject);
var
  i:integer;
  P:TDBInspectorRecord;
begin
  for i:=0 to DBList.Count-1 do
  begin
    if DBList[i].SQLEngine = DBObject.OwnerDB then
    begin
      P:=DBList[i].FindDBObject(DBObject);
      if Assigned(P) then
        TreeView1.Selected:=P.FOwner;
      exit;
    end;
  end;
end;

procedure TfbManDataInpectorForm.UpdateRecentObjects;
var
  i,j, k:integer;
  R:TDataBaseRecord;

begin
  ListBox1.Items.BeginUpdate;
  ListBox1.Items.Clear;
  for j:=0 to DBList.Count-1 do
  begin
    R:=DBList[j];
    if R.Connected then
    begin
      for i:=0 to R.RecentDBItems.Count - 1 do
      begin
        K:=ListBox1.Items.Add(R.Caption+'->'+R.RecentDBItems[i] {+ ' : '+DateTimeToStr(R.RecentDBItems[i].FileDate)});
        ListBox1.Items.Objects[k]:=R;
      end;
    end;
  end;
  ListBox1.Items.EndUpdate;
end;

function TfbManDataInpectorForm.OIFolderByName(AFolderName: string): TOIFolder;
var
  i: Integer;
begin
  Result:=nil;
  for i:=0 to FFolders.Count-1 do
    if TOIFolder(FFolders[i]).Name = AFolderName then
    begin
      Result:=TOIFolder(FFolders[i]);
      exit;
    end;
end;

procedure TfbManDataInpectorForm.ReadAlialList;
var
  aNode:TTreeNode;
  PP:TDataBaseRecord;
  F: TOIFolder;
begin
  //Read folders
  UserDBModule.quFolders.Open;
  while not UserDBModule.quFolders.EOF do
  begin
    F:=FFolders.Add(TreeView1.Items.AddChild(nil, ''));
    F.Load;
    UserDBModule.quFolders.Next;
  end;
  UserDBModule.quFolders.Close;

  UserDBModule.quDatabases.Open;
  UserDBModule.quDBOptions.Open;
  while not UserDBModule.quDatabases.EOF do
  begin
    aNode:=TreeView1.Items.AddChild(nil, '');
    UserDBModule.quConnectionPlugins.ParamByName('db_database_id').AsInteger:=UserDBModule.quDatabasesdb_database_id.AsInteger;
    UserDBModule.quConnectionPlugins.Open;
    PP:=TDataBaseRecord.Load(aNode, UserDBModule.quDatabases, UserDBModule.quConnectionPlugins);
    UserDBModule.quConnectionPlugins.Close;
    DBList.Add(PP);
    UserDBModule.quDatabases.Next;
  end;
  UserDBModule.quDBOptions.Close;
  UserDBModule.quDatabases.Close;

  for F in Folders do F.AfterLoad;

  TreeView1Click(nil);
end;

function TfbManDataInpectorForm.CurrentDB: TDataBaseRecord;
var
  Item:TDBInspectorRecord;
begin
  Result:=nil;
  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) and (TObject(TreeView1.Selected.Data) is TDBInspectorRecord) then
  begin
    Item:=TDBInspectorRecord(TreeView1.Selected.Data);
    if Assigned(Item) then
      Result:=Item.OwnerDB;
  end;
end;

function TfbManDataInpectorForm.DBByName(ANameDB: string): TDataBaseRecord;
var
  i:integer;
begin
  Result:=nil;
  for i:=0 to FDBList.Count - 1 do
    if TDataBaseRecord(FDBList[i]).Caption = ANameDB then
    begin
      Result:=TDataBaseRecord(FDBList[i]);
      exit;
    end;
end;

function TfbManDataInpectorForm.DBBySQLEngine(SQLEngine: TSQLEngineAbstract
  ): TDataBaseRecord;
var
  i:integer;
begin
  Result:=nil;
  for i:=0 to FDBList.Count - 1 do
    if TDataBaseRecord(FDBList[i]).SQLEngine = SQLEngine then
    begin
      Result:=TDataBaseRecord(FDBList[i]);
      exit;
    end;
end;

function TfbManDataInpectorForm.CurrentObject: TDBInspectorRecord;
begin
  Result:=nil;
  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) and (TObject(TreeView1.Selected.Data) is TDBInspectorRecord) then
    Result:=TDBInspectorRecord(TreeView1.Selected.Data);
end;

function TfbManDataInpectorForm.CurrentFolder: TOIFolder;
begin
  Result:=nil;

  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) and (TObject(TreeView1.Selected.Data) is TOIFolder) then
    Result:=TOIFolder(TreeView1.Selected.Data);
end;

function TFBMDataBaseList.GetDBItem(AIndex: integer): TDataBaseRecord;
begin
  Result:=TDataBaseRecord(FList[AIndex]);
end;

constructor TFBMDataBaseList.Create(AOwner: TfbManDataInpectorForm);
begin
  inherited Create;
  FList:=TFPList.Create;
  FOwner:=AOwner;
end;

destructor TFBMDataBaseList.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TFBMDataBaseList.Clear;
var
  D: TDataBaseRecord;
begin
  for D in Self do
    D.Free;
  FList.Clear;
end;

procedure TFBMDataBaseList.Add(AObject: TDataBaseRecord);
begin
  FList.Add(AObject);
end;

procedure TFBMDataBaseList.Delete(AObject: TDataBaseRecord);
begin
  FList.Extract(AObject);
  AObject.Free;
end;

procedure TFBMDataBaseList.Extract(AObject: TDataBaseRecord);
begin
  FList.Extract(AObject);
end;

function TFBMDataBaseList.IndexOf(AObject: TDataBaseRecord): integer;
begin
  Result:=FList.IndexOf(AObject);
end;

function TFBMDataBaseList.GetEnumerator: TFBMDataBaseListEnumerator;
begin
  Result:=TFBMDataBaseListEnumerator.Create(Self);
end;

function TFBMDataBaseList.FillDataBaseList(const AItems: TStrings): integer;
begin
  Result:=FillDataBaseList(AItems, nil);;
end;

function TFBMDataBaseList.FillDataBaseList(const AItems: TStrings;
  AClass: TSQLEngineAbstractClass): integer;
var
  ACurrentDB, D:TDataBaseRecord;
  K: Integer;
begin
  AItems.Clear;
  Result:=-1;
  ACurrentDB:=FOwner.CurrentDB;
  for D in Self do
  begin
    if ((D.SQLEngine.ClassType = AClass) or (AClass = nil)) and (D.SQLEngine.AliasName<>'') then
    begin
      K:=AItems.AddObject(D.SQLEngine.AliasName, D.SQLEngine);
      if (Result=-1) and (ACurrentDB = D) then
        Result:=K;
    end;
  end;
end;

function TFBMDataBaseList.FillServerList(const AItems: TStrings): integer;
begin
  Result:=FillServerList(AItems, nil);
end;

function TFBMDataBaseList.FillServerList(const AItems: TStrings;
  AClass: TSQLEngineAbstractClass): integer;
var
  ACurrentDB, D:TDataBaseRecord;
  K: Integer;
begin
  AItems.Clear;
  Result:=-1;
  ACurrentDB:=FOwner.CurrentDB;
  for D in Self do
  begin
    if ((D.SQLEngine.ClassType = AClass) or (AClass = nil)) and (D.SQLEngine.ServerName<>'') and (AItems.IndexOf(D.SQLEngine.ServerName) < 0) then
    begin
      K:=AItems.AddObject(D.SQLEngine.ServerName, D.SQLEngine);
      if (Result=-1) and (ACurrentDB = D) then
        Result:=K;
    end;
  end;
end;

function TFBMDataBaseList.GetCount: integer;
begin
  Result:=FList.Count;
end;

initialization
  fbManDataInpectorForm:=nil;
end.

