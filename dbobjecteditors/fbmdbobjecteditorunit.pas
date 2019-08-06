{ Free DB Manager

  Copyright (C) 2005-2019 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fbmDBObjectEditorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, rxtoolbar,
  ComCtrls, ActnList, LMessages, fbmToolsUnit, SynEdit, DB,
  RxIniPropStorage, ExtCtrls, fdmAbstractEditorUnit, ibmanagertypesunit,
  Menus, StdCtrls, SQLEngineAbstractUnit, sqlObjects, IniFiles, fbm_VisualEditorsAbstractUnit;

type

  { TfbmDBObjectEditorForm }

  TfbmDBObjectEditorForm = class(TForm)
    edtComment: TAction;
    edtUncomment: TAction;
    edtRun: TAction;
    RxIniPropStorage1: TRxIniPropStorage;
    dtRefresh: TAction;
    edtAdd: TAction;
    edtEdit: TAction;
    edtDel: TAction;
    edtPrint: TAction;
    actCommitAndClose: TAction;
    actRollbackAndClose: TAction;
    actCommit: TAction;
    actRollback: TAction;
    Edit1: TEdit;
    Label1: TLabel;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Panel1: TPanel;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    ToolPanel1: TToolPanel;
    dtExport: TAction;
    edtCompile: TAction;
    ActionList1: TActionList;
    ListBox1: TListBox;
    Panel2: TPanel;
    Splitter1: TSplitter;
    MenuItem1: TMenuItem;
    PopupMenu1: TPopupMenu;
    procedure actCommitAndCloseExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actRolbackExecute(Sender: TObject);
    procedure actRollbackAndCloseExecute(Sender: TObject);
    procedure dtExportExecute(Sender: TObject);
    procedure dtRefreshExecute(Sender: TObject);
    procedure edtAddExecute(Sender: TObject);
    procedure edtCommentExecute(Sender: TObject);
    procedure edtCompileExecute(Sender: TObject);
    procedure edtDelExecute(Sender: TObject);
    procedure edtEditExecute(Sender: TObject);
    procedure edtPrintExecute(Sender: TObject);
    procedure edtRunExecute(Sender: TObject);
    procedure edtUncommentExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure ListBox1Click(Sender: TObject);
  private
    FCurEditor:TEditorPage;
    FInspectorRecord: TDBInspectorRecord;
    procedure AddPage(P:TEditorPage);
    procedure DoSetEnvOptions;
    procedure LMEditorChangeParams(var message: TLMNoParams); message LM_EDITOR_CHANGE_PARMAS;
    procedure LMNotyfyDelObject(var Message: TLMessage); message LM_NOTIFY_OBJECT_DELETE;

    procedure RecreatePages;
    procedure MakeWindowIcon;
    procedure Localize;
    procedure SetInspectorRecord(AValue: TDBInspectorRecord);
    procedure OnUpdateModified(Sender: TObject);
    procedure SetObjectCaption(AModified:boolean);
  public
    OnCreateNewDBObject:TOnCreateNewDBObject;
    constructor CreateObjectEditor(ADataBaseRecord: TDBInspectorRecord);
    procedure SetPageNum(APageNum:integer);
    procedure SendCmd(PageAction:TEditorPageAction);
    procedure CtrlUpdateActions;
    procedure RefreshPages;

    procedure SaveState(const ObjName:string; const Ini:TIniFile);
    procedure RestoreState(const ObjName:string; const Ini:TIniFile);

    property InspectorRecord:TDBInspectorRecord read FInspectorRecord write SetInspectorRecord;
  end;

implementation
uses IBManMainUnit, fbmStrConstUnit, fbmSqlParserUnit, GraphType, ImgList,
  SQLEngineCommonTypesUnit, IBManDataInspectorUnit;

{$R *.lfm}

{ TfbmDBObjectEditorForm }

procedure TfbmDBObjectEditorForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
  if Assigned(FInspectorRecord) then
  begin
    if FInspectorRecord.DBObject.State = sdboCreate then
    begin
      FInspectorRecord.ObjectEditor:=nil;
      FInspectorRecord.DBObject.Free;
      FInspectorRecord.DBObject:=nil;
      FInspectorRecord:=nil;
    end
    else
    begin
      FInspectorRecord.DBObject.OnCloseEditorWindow;
      FInspectorRecord.ObjectEditor:=nil;
    end;
  end;
end;

procedure TfbmDBObjectEditorForm.ListBox1Click(Sender: TObject);
var
  OldEditor:TEditorPage;
begin
  //При щелчке по элементу списка страниц необходимо отобразить соответсвующую страницу
  if (ListBox1.ItemIndex>-1) and (ListBox1.ItemIndex<ListBox1.Items.Count) then
  begin
    OldEditor:=FCurEditor;

    FCurEditor:=ListBox1.Items.Objects[ListBox1.ItemIndex] as TEditorPage;
    if Assigned(FCurEditor) then
    begin
      if Assigned(OldEditor) then
      begin
        OldEditor.DeActivate;
        OldEditor.Visible:=false;
      end;
//      FCurEditor.BringToFront;
      FCurEditor.Visible:=true;
      FCurEditor.Activate;
    end;
    //update action state after change page in editor
    CtrlUpdateActions;
  end;
end;

procedure TfbmDBObjectEditorForm.dtExportExecute(Sender: TObject);
begin
  if Assigned(FCurEditor) then
    FCurEditor.DoMetod(epaExport);
end;

procedure TfbmDBObjectEditorForm.dtRefreshExecute(Sender: TObject);
begin
  if Assigned(FCurEditor) then
    FCurEditor.DoMetod(epaRefresh);
end;

procedure TfbmDBObjectEditorForm.edtAddExecute(Sender: TObject);
begin
  if Assigned(FCurEditor) then
    FCurEditor.DoMetod(epaAdd);
end;

procedure TfbmDBObjectEditorForm.edtCommentExecute(Sender: TObject);
begin
  if Assigned(FCurEditor) then
    FCurEditor.DoMetod(epaComment);
end;

procedure TfbmDBObjectEditorForm.edtCompileExecute(Sender: TObject);
var
  ErrorPage, i:integer;
  OldState:TDBObjectState;
  SqlCmd: TSQLCommandDDL;
  EditorPage: TEditorPage;
begin
  OldState:=FInspectorRecord.DBObject.State;
  SqlCmd:=FInspectorRecord.DBObject.CreateSQLObject;
  ErrorPage:=-1;
  if Assigned(SqlCmd) then
  begin

    for i:=0 to ListBox1.Items.Count - 1 do
    begin
      if Assigned(ListBox1.Items.Objects[i]) then
      begin
        EditorPage:=ListBox1.Items.Objects[i] as TEditorPage;
        if not EditorPage.SetupSQLObject(SqlCmd) then
        begin
          ErrorPage:=i;
          break;
        end;
      end;
    end;
    if ErrorPage<0 then
    begin
      if FInspectorRecord.DBObject.CompileSQLObject(SqlCmd, [sepShowCompForm]) then
      begin
        if OldState <> FInspectorRecord.DBObject.State then
          RecreatePages
        else
          RefreshPages;
        SetPageNum(0);
        if Assigned(OnCreateNewDBObject) then
            OnCreateNewDBObject(Self, FInspectorRecord.DBObject);
        fbManagerMainForm.RxMDIPanel1.ChildWindowsUpdateCaption(Self);
      end;
    end
    else
      SetPageNum(ErrorPage);
    SqlCmd.Free;
  end
  else
  begin
    ErrorPage:=0;
    if OldState = sdboCreate then
    begin
      FInspectorRecord.DBObject.BeforeCreateObject;
      if ProcessEditorPageAction(ListBox1.Items, epaCompile, ErrorPage) and FInspectorRecord.DBObject.AfterCreateObject then
      begin
        RecreatePages;
        SetPageNum(0);
        if Assigned(OnCreateNewDBObject) then
            OnCreateNewDBObject(Self, FInspectorRecord.DBObject);
        fbManagerMainForm.RxMDIPanel1.ChildWindowsUpdateCaption(Self);
      end
      else
        SetPageNum(ErrorPage);
    end
    else
      FCurEditor.DoMetod(epaCompile);
  end;
end;

procedure TfbmDBObjectEditorForm.edtDelExecute(Sender: TObject);
begin
  if Assigned(FCurEditor) then
    FCurEditor.DoMetod(epaDelete);
end;

procedure TfbmDBObjectEditorForm.edtEditExecute(Sender: TObject);
begin
  if Assigned(FCurEditor) then
    FCurEditor.DoMetod(epaEdit);
end;

procedure TfbmDBObjectEditorForm.edtPrintExecute(Sender: TObject);
begin
  if Assigned(FCurEditor) then
    FCurEditor.DoMetod(epaPrint);
end;

procedure TfbmDBObjectEditorForm.edtRunExecute(Sender: TObject);
begin
  if Assigned(FCurEditor) then
    FCurEditor.DoMetod(epaRun);
end;

procedure TfbmDBObjectEditorForm.edtUncommentExecute(Sender: TObject);
begin
  if Assigned(FCurEditor) then
    FCurEditor.DoMetod(epaUnComment);
end;

procedure TfbmDBObjectEditorForm.actCommitExecute(Sender: TObject);
begin
  if Assigned(FCurEditor) then
  begin
    FCurEditor.DoMetod(epaCommit);
    FCurEditor.Activate;
  end;
end;

procedure TfbmDBObjectEditorForm.actCommitAndCloseExecute(Sender: TObject);
begin
  if Assigned(FCurEditor) then
    FCurEditor.DoMetod(epaCommit);
  SetPageNum(0);
end;

procedure TfbmDBObjectEditorForm.actRolbackExecute(Sender: TObject);
begin
  if Assigned(FCurEditor) then
  begin
    FCurEditor.DoMetod(epaRolback);
    FCurEditor.Activate;
  end;
end;

procedure TfbmDBObjectEditorForm.actRollbackAndCloseExecute(Sender: TObject);
begin
  if Assigned(FCurEditor) then
    FCurEditor.DoMetod(epaRolback);
  SetPageNum(0);
end;

procedure TfbmDBObjectEditorForm.AddPage(P: TEditorPage);
begin
  //Метод добавляет новую страницу в окно редактора
  if Assigned(P) then
  begin
    ListBox1.Items.AddObject(P.PageName, P);
    P.Parent:=Panel2;
    P.Align:=alClient;

    P.Visible:=false;
    P.FModifiedEvent:=@OnUpdateModified;
  end;
end;

procedure TfbmDBObjectEditorForm.DoSetEnvOptions;
var
  EditorPage:TEditorPage;
  i:integer;
begin
  for i:=0 to ListBox1.Items.Count - 1 do
  begin
    EditorPage:=TEditorPage(ListBox1.Items.Objects[i]);
    if Assigned(EditorPage) then
      EditorPage.UpdateEnvOptions;
  end;
end;

procedure TfbmDBObjectEditorForm.LMEditorChangeParams(var message: TLMNoParams);
begin
  inherited;
  DoSetEnvOptions;
end;

procedure TfbmDBObjectEditorForm.LMNotyfyDelObject(var Message: TLMessage);
var
  i: Integer;
  EditorPage: TEditorPage;
  D: Pointer;
begin
  inherited;
  D:=Pointer(IntPtr(Message.WParam));

  for i:=0 to ListBox1.Items.Count - 1 do
  begin
    if Assigned(ListBox1.Items.Objects[i]) then
    begin
      EditorPage:=ListBox1.Items.Objects[i] as TEditorPage;
      EditorPage.NotyfiDeleted(TDBObject(D));
    end;
  end;

end;

procedure TfbmDBObjectEditorForm.RecreatePages;
var
  i:integer;
  P:TEditorPage;
begin
  for i:=ListBox1.Items.Count - 1 downto 0 do
  begin
    P:=ListBox1.Items.Objects[i] as TEditorPage;
    ListBox1.Items.Objects[i]:=nil;
    if Assigned(P) then
      FreeAndNil(P)
  end;
  ListBox1.Items.Clear;
  FCurEditor:=nil;

  for i:=0 to FInspectorRecord.OwnerDB.DBVisualTools.EditPageCount(FInspectorRecord.DBObject) - 1 do
    AddPage(TEditorPage(FInspectorRecord.OwnerDB.DBVisualTools.EditPage(FInspectorRecord.DBObject, Self, i)));


  SetObjectCaption(false);
end;

procedure TfbmDBObjectEditorForm.RefreshPages;
var
  P: TEditorPage;
  i: Integer;
begin
  for i:=ListBox1.Items.Count - 1 downto 0 do
  begin
    P:=ListBox1.Items.Objects[i] as TEditorPage;
    if Assigned(P) then
      P.DoMetod(epaRefresh);
  end;
  SetObjectCaption(false);
end;

procedure TfbmDBObjectEditorForm.MakeWindowIcon;
var
  ImgInd:integer;
  Bmp:TBitmap;
begin
  ImgInd:=DBObjectKindImages[FInspectorRecord.DBObject.DBObjectKind];
  Bmp:=TBitmap.Create;
  try
    Bmp.Width:=18;
    Bmp.Height:=18;
    Bmp.Canvas.Brush.Color:=clBtnFace;
    Bmp.Canvas.FillRect(0, 0, 18, 18);
    fbManagerMainForm.ImageList2.Draw(Bmp.Canvas, 0, 0, ImgInd, dsTransparent, itImage, true);
    Icon.Assign(Bmp);
  finally
    Bmp.Free;
  end;
end;

procedure TfbmDBObjectEditorForm.Localize;
begin
  dtExport.Caption:=sExportData;
  dtExport.Hint:=sExportDataHint;
  actCommit.Caption:=sCommit;
  actCommit.Hint:=sCommitHint;
  actRollback.Caption:=sRolback;
  actRollback.Hint:=sRolbackHint;
  actCommitAndClose.Caption:=sCommitAndClose;
  actCommitAndClose.Hint:=sCommitAndCloseHint;
  actRollbackAndClose.Caption:=sRolbackAndClose;
  actRollbackAndClose.Caption:=sRolbackAndCloseHint;
  dtRefresh.Caption:=sRefresh;
  dtRefresh.Hint:=sRefreshDataHint;
  edtCompile.Caption:=sCompile;
  edtCompile.Hint:=sCompile;
  edtPrint.Caption:=sPrint;
  edtPrint.Hint:=sPrintHint;
  edtAdd.Caption:=sAdd;
  edtAdd.Hint:=sAddHint;
  edtEdit.Caption:=sEdit;
  edtEdit.Hint:=sEditHint;
  edtDel.Caption:=sDelete;
  edtDel.Hint:=sDeleteHint;
  edtRun.Caption:=sRun;
  edtRun.Hint:=sRunHint;
end;

procedure TfbmDBObjectEditorForm.SetInspectorRecord(AValue: TDBInspectorRecord);
var
  P: TEditorPage;
  i: Integer;
begin
  if FInspectorRecord=AValue then Exit;
  FInspectorRecord:=AValue;

  for i:=ListBox1.Items.Count - 1 downto 0 do
  begin
    P:=ListBox1.Items.Objects[i] as TEditorPage;
    if Assigned(FInspectorRecord) then
      P.DBObject:=AValue.DBObject
    else
      P.DBObject:=nil;
  end;
end;

procedure TfbmDBObjectEditorForm.OnUpdateModified(Sender: TObject);
var
  P: TEditorPage;
  i: Integer;
  F: Boolean;
begin
  F:=false;
  for i:=ListBox1.Items.Count - 1 downto 0 do
  begin
    P:=ListBox1.Items.Objects[i] as TEditorPage;
    if Assigned(P) then
      if P.Modified then
        F:=true;
  end;
  SetObjectCaption(F)
end;

procedure TfbmDBObjectEditorForm.SetObjectCaption(AModified: boolean);
var
  S: String;
begin
  S:=FInspectorRecord.DBObject.DBClassTitle + ' ' + FInspectorRecord.DBObject.CaptionFullPatch;
  if AModified then
    S:=S + ' (*)';
  Caption:=S;
  Edit1.Text:=FInspectorRecord.DBObject.CaptionFullPatch;
  fbManagerMainForm.RxMDIPanel1.ChildWindowsUpdateCaption(Self);
end;

constructor TfbmDBObjectEditorForm.CreateObjectEditor(
  ADataBaseRecord: TDBInspectorRecord);
begin
  inherited Create(Application);
  Localize;
  FInspectorRecord:=ADataBaseRecord;

  Label1.Caption:=ObjectKindToStr(FInspectorRecord.DBObject.DBObjectKind);

  Panel2.Align:=alClient;

  RecreatePages;

  DoSetEnvOptions;
  SetPageNum(0);

  Panel1.Visible:=ConfigValues.ByNameAsBoolean('defShowObjCaption', true);

  MakeWindowIcon;
end;

procedure TfbmDBObjectEditorForm.SetPageNum(APageNum: integer);
begin
  ListBox1.ItemIndex:=APageNum;
  ListBox1Click(nil);
end;

procedure TfbmDBObjectEditorForm.SendCmd(PageAction: TEditorPageAction);
var
  ErrorPage:integer;
begin
  ProcessEditorPageAction(ListBox1.Items, PageAction, ErrorPage);
end;

procedure TfbmDBObjectEditorForm.CtrlUpdateActions;
begin
  actCommit.Enabled:=Assigned(FCurEditor) and FCurEditor.ActionEnabled(epaCommit);
  actRollback.Enabled:=Assigned(FCurEditor) and FCurEditor.ActionEnabled(epaCommit);
  actCommitAndClose.Enabled:=Assigned(FCurEditor) and FCurEditor.ActionEnabled(epaRolback);
  actRollbackAndClose.Enabled:=Assigned(FCurEditor) and FCurEditor.ActionEnabled(epaRolback);
  dtExport.Enabled:=Assigned(FCurEditor) and FCurEditor.ActionEnabled(epaExport);
  edtCompile.Enabled:=Assigned(FCurEditor) and FCurEditor.ActionEnabled(epaCompile);
  edtPrint.Enabled:=Assigned(FCurEditor) and FCurEditor.ActionEnabled(epaPrint);
  edtAdd.Enabled:=Assigned(FCurEditor) and FCurEditor.ActionEnabled(epaAdd);
  edtEdit.Enabled:=Assigned(FCurEditor) and FCurEditor.ActionEnabled(epaEdit);
  edtDel.Enabled:=Assigned(FCurEditor) and FCurEditor.ActionEnabled(epaDelete);
  dtRefresh.Enabled:=Assigned(FCurEditor) and FCurEditor.ActionEnabled(epaRefresh);
  edtRun.Enabled:=Assigned(FCurEditor) and FCurEditor.ActionEnabled(epaRun);

  edtComment.Enabled:=Assigned(FCurEditor) and FCurEditor.ActionEnabled(epaComment);
  edtUncomment.Enabled:=Assigned(FCurEditor) and FCurEditor.ActionEnabled(epaUnComment);
end;

procedure TfbmDBObjectEditorForm.SaveState(const ObjName:string; const Ini: TIniFile);
var
  i:integer;
  P:TEditorPage;
begin
  Ini.WriteInteger(ObjName, 'DBObjectEditor.ListBox1.Width', ListBox1.Width);
  for i:=0 to ListBox1.Items.Count-1 do
  begin
    P:=TEditorPage(ListBox1.Items.Objects[i]);
    if Assigned(P) then
      P.SaveState(ObjName+'.'+P.PageName, Ini);
  end;
end;

procedure TfbmDBObjectEditorForm.RestoreState(const ObjName:string; const Ini: TIniFile);
var
  i:integer;
  P:TEditorPage;
begin
  ListBox1.Width:=Ini.ReadInteger(ObjName, 'DBObjectEditor.ListBox1.Width', ListBox1.Width);
  for i:=0 to ListBox1.Items.Count-1 do
  begin
    P:=TEditorPage(ListBox1.Items.Objects[i]);
    if Assigned(P) then
      P.RestoreState(ObjName+'.'+P.PageName, Ini);
  end;
end;

end.

