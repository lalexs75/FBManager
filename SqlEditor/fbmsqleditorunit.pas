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
{ TODO : После окончания выполнения в статусной строке отобразить информацию о успеном завершении запроса }
unit fbmSQLEditorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  fbmSQLEditorClassesUnit, LMessages, ActnList, StdCtrls, DB, LCLType, SynEdit,
  SynHighlighterSQL, DBGrids, IBManagerTypesUnit, SynCompletion, LR_PGrid,
  Menus, sqlEngineTypes, fdbm_SynEditorUnit, ExtCtrls, Buttons, DBCtrls, RxDBGrid, rxtoolbar,
  RxIniPropStorage, RxDBGridExportSpreadSheet, RxDBGridPrintGrid, sqlObjects,
  SQLEngineCommonTypesUnit, RxDBGridFooterTools, RxDBGridExportPdf,
  rxdbverticalgrid, LCLIntf, EditBtn, fpdataexporter, ZMacroQuery,
  ZDataset, SQLEngineAbstractUnit, fbmToolsUnit, IniFiles,
  fbmSqlParserUnit;

const
  itFolderNode = 43;
  itEditorNode = 31; //8;

type

  { TfbmSQLEditorForm }

  TfbmSQLEditorForm = class(TForm)
    Panel6: TPanel;
    resAutoFillCollumnWidth: TAction;
    edtCopy: TAction;
    edtUndo: TAction;
    edtCut: TAction;
    edtPaste: TAction;
    rgExportAsInsert: TAction;
    CheckBox3: TCheckBox;
    Edit1: TEdit;
    Label3: TLabel;
    Memo2: TMemo;
    PageControl2: TPageControl;
    InfoPageControl: TPageControl;
    RxDBVerticalGrid1: TRxDBVerticalGrid;
    shlBottom: TShape;
    shlLeft: TShape;
    shlRight: TShape;
    shlTop: TShape;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    statFunct: TAction;
    statFilter: TAction;
    fsCopyTextToClip: TAction;
    fsTextToSQLEditor: TAction;
    CheckBox2: TCheckBox;
    dsFindQuery: TDataSource;
    fsFindQuery: TAction;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    EditButton1: TEditButton;
    Label2: TLabel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    PopupMenu5: TPopupMenu;
    quFindQuerydb_database_caption: TStringField;
    quFindQuerydb_database_id: TLargeintField;
    quFindQuerydb_database_sql_engine: TStringField;
    quFindQuerysql_editors_body: TMemoField;
    quFindQuerysql_editors_caption: TStringField;
    quFindQuerysql_editors_history_date: TMemoField;
    quFindQuerysql_editors_id: TLargeintField;
    rgCopyTitle: TAction;
    rgExportToPDF: TAction;
    rgExportToSpreadsheet: TAction;
    RxDBGrid2: TRxDBGrid;
    RxDBGridExportPDF1: TRxDBGridExportPDF;
    Splitter4: TSplitter;
    Splitter5: TSplitter;
    Splitter6: TSplitter;
    statRecordCount: TAction;
    edtNewQuerySet: TAction;
    Label1: TLabel;
    lblTimeInfo: TLabel;
    MenuItem100: TMenuItem;
    MenuItem101: TMenuItem;
    MenuItem87: TMenuItem;
    MenuItem88: TMenuItem;
    RxDBGridExportSpreadSheet1: TRxDBGridExportSpreadSheet;
    RxDBGridFooterTools1: TRxDBGridFooterTools;
    RxDBGridPrint1: TRxDBGridPrint;
    RxIniPropStorage1: TRxIniPropStorage;
    SpeedButton2: TSpeedButton;
    tabFindResult: TTabSheet;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    tabMessages: TTabSheet;
    tabQueryFields: TTabSheet;
    TreeView1: TTreeView;
    histCopyAll: TAction;
    histCopyClip: TAction;
    histDelete: TAction;
    histOpen: TAction;
    histClear: TAction;
    MenuItem89: TMenuItem;
    MenuItem90: TMenuItem;
    MenuItem91: TMenuItem;
    MenuItem92: TMenuItem;
    MenuItem93: TMenuItem;
    MenuItem94: TMenuItem;
    MenuItem95: TMenuItem;
    MenuItem96: TMenuItem;
    MenuItem97: TMenuItem;
    MenuItem98: TMenuItem;
    MenuItem99: TMenuItem;
    PopupMenu4: TPopupMenu;
    DBMemo1: TDBMemo;
    dsHistory: TDatasource;
    edtRedo: TAction;
    edtReplace: TAction;
    edtFind: TAction;
    edtFindNext: TAction;
    edtClearCurrent: TAction;
    MenuItem65: TMenuItem;
    MenuItem70: TMenuItem;
    MenuItem71: TMenuItem;
    MenuItem72: TMenuItem;
    MenuItem73: TMenuItem;
    MenuItem74: TMenuItem;
    MenuItem75: TMenuItem;
    MenuItem76: TMenuItem;
    MenuItem77: TMenuItem;
    MenuItem78: TMenuItem;
    MenuItem79: TMenuItem;
    MenuItem80: TMenuItem;
    MenuItem84: TMenuItem;
    MenuItem85: TMenuItem;
    MenuItem86: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    rgExport: TAction;
    FPDataExporter1: TFPDataExporter;
    MenuItem63: TMenuItem;
    MenuItem64: TMenuItem;
    rgCopyValue: TAction;
    edtOpen: TAction;
    edtSave: TAction;
    DBNavigator1: TDBNavigator;
    Memo1: TMemo;
    MenuItem26: TMenuItem;
    resPrint: TAction;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    resCommit: TAction;
    resRolback: TAction;
    editShowPlan: TAction;
    editExecQueryFetchAll: TAction;
    editExecQury: TAction;
    ctrlCreateView: TAction;
    ctrlCreateSP: TAction;
    edtRenameTab: TAction;
    edtDeleteAll: TAction;
    edtDelete: TAction;
    edtNewPage: TAction;
    ActionList1: TActionList;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    PopupMenu1: TPopupMenu;
    Datasource1: TDatasource;
    PageControl1: TPageControl;
    PopupMenu2: TPopupMenu;
    RxDBGrid1: TRxDBGrid;
    dbGrid1: TRxDBGrid;
    SpeedButton1: TSpeedButton;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    tabHistory: TTabSheet;
    TabStatistic: TTabSheet;
    TabSqlEdit: TTabSheet;
    tabResult: TTabSheet;
    ToolPanel2: TToolPanel;
    TreeView2: TTreeView;
    quFindQuery: TZMacroQuery;
    ZReadOnlyQuery1: TZReadOnlyQuery;
    procedure CheckBox3Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure dbGrid1DblClick(Sender: TObject);
    procedure dbGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure Edit1Change(Sender: TObject);
    procedure edtClearCurrentExecute(Sender: TObject);
    procedure edtCopyExecute(Sender: TObject);
    procedure edtCutExecute(Sender: TObject);
    procedure edtFindExecute(Sender: TObject);
    procedure edtFindNextExecute(Sender: TObject);
    procedure edtNewQuerySetExecute(Sender: TObject);
    procedure edtPasteExecute(Sender: TObject);
    procedure edtRedoExecute(Sender: TObject);
    procedure edtSaveExecute(Sender: TObject);
    procedure edtUndoExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure fsCopyTextToClipExecute(Sender: TObject);
    procedure fsFindQueryExecute(Sender: TObject);
    procedure fsTextToSQLEditorExecute(Sender: TObject);
    procedure histClearExecute(Sender: TObject);
    procedure histCopyAllExecute(Sender: TObject);
    procedure histCopyClipExecute(Sender: TObject);
    procedure histDeleteExecute(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure quFindQueryAfterScroll(DataSet: TDataSet);
    procedure quFindQuerysql_editors_history_dateGetText(Sender: TField;
      var aText: string; DisplayText: Boolean);
    procedure resAutoFillCollumnWidthExecute(Sender: TObject);
    procedure rgCopyTitleExecute(Sender: TObject);
    procedure rgCopyValueExecute(Sender: TObject);
    procedure rgExportAsInsertExecute(Sender: TObject);
    procedure rgExportExecute(Sender: TObject);
    procedure rgExportToPDFExecute(Sender: TObject);
    procedure rgExportToSpreadsheetExecute(Sender: TObject);
    procedure RxDBGrid1DblClick(Sender: TObject);
    procedure edtOpenExecute(Sender: TObject);
    procedure IBManagerSQLFormClose(Sender: TObject;
      var CloseAction: TCloseAction);
    procedure ctrlCreateSPExecute(Sender: TObject);
    procedure ctrlCreateViewExecute(Sender: TObject);
    procedure editExecQueryFetchAllExecute(Sender: TObject);
    procedure editExecQuryExecute(Sender: TObject);
    procedure editShowPlanExecute(Sender: TObject);
    procedure edtDeleteAllExecute(Sender: TObject);
    procedure edtDeleteExecute(Sender: TObject);
    procedure edtNewPageExecute(Sender: TObject);
    procedure edtRenameTabExecute(Sender: TObject);
    procedure resCloseQueryExecute(Sender: TObject);
    procedure resPrintExecute(Sender: TObject);
    procedure RxDBGrid1GetCellProps(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor);
    procedure RxDBGrid2DblClick(Sender: TObject);
    procedure SearchFind1Accept(Sender: TObject);
    procedure statFilterExecute(Sender: TObject);
    procedure statFunctExecute(Sender: TObject);
    procedure statRecordCountExecute(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
  private
    FColor1:TColor;
    FColor2:TColor;
    FColor3:TColor;
    FColor4:TColor;

    FStartTime:TDateTime;
    FEndTime:TDateTime;
    EditorFrame:Tfdbm_SynEditorFrame;
    FFindResultText:Tfdbm_SynEditorFrame;

    FOwnerRec:TDataBaseRecord;
    FSqlEditorTextCur:TSqlEditorPage;
    QueryControl:TSQLQueryControl;
    FSQLEngine:TSQLEngineAbstract;

    procedure LoadEditorTabs(ATreeView: TTreeView; ADBRecord: TDataBaseRecord);
    procedure SaveCurrent;
    procedure LoadCurrent;

    function FindTreeRoot(AItems:TTreeNodes; const RootName:string):TTreeNode;
    function AddTreeRoot(AItems: TTreeNodes; RootName: string): TTreeNode;


    procedure ChangeVisualParams;
    procedure LMEditorChangeParams(var message: TLMNoParams); message LM_EDITOR_CHANGE_PARMAS;
    procedure LMNotyfyDelObject(var Message: TLMessage); message LM_NOTIFY_OBJECT_DELETE;
    procedure ShowResultTab(AShow:boolean);
    procedure LoadStatistic(const SQLCommand:TSQLCommandAbstract);

    procedure DataSetAfterScrollRecord(Sender: TDataSet);
    function SynEditAcceptDrag(const Source: TObject): TControl;
    procedure TextEditorChange(Sender: TObject);
    procedure SaveSQLEdiorsDesktop;
    procedure EditorFrameGetFieldsList(Sender:Tfdbm_SynEditorFrame; const DBObjName:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);
    procedure EditorFrameGetKeyWordList(Sender:Tfdbm_SynEditorFrame; const KeyStartWord:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);
    function EditorFrameOnGetDBObjectByAlias(Sender:Tfdbm_SynEditorFrame; const ATableAlias:string; out DBObjName:string):TDBObject;
    procedure Localize;
    procedure UpdateExecTimeInfo;
    procedure SetRecordCountCaption(const S:string);
    procedure FillCommonDBList;

    procedure UpdateInfoPageControlState;
    procedure ShowQueryFields;
    procedure HideQueryFields;

    procedure ShowInfoMessages(S:string);
    procedure HideInfoMessages;

    procedure DoStartExecQuery;
    procedure DoStopExecQuery;
    procedure OnEditorChangeStatus(Sender: TObject);
    procedure OnBeforeSaveFileEdit(Sender:Tfdbm_SynEditorFrame; const TextEditor: TSynEdit;var AFileName:string);
    procedure UpdateColorDBMarking;
  public
    constructor CreateSqlEditor(AOwnerRec:TDataBaseRecord);
    procedure SaveState(const ObjName:string; const Ini:TIniFile);
    procedure RestoreState(const ObjName:string; const Ini:TIniFile);
    property OwnerRec:TDataBaseRecord read FOwnerRec;
  end;

{ TODO -cдоработка : Необходимо создать инструмент создания представления по текущему запросу }
{ TODO -oalexs : Необходимо сохранять положение сплитера между список запросов и редактором текста запроса }
implementation
uses IBManDataInspectorUnit, Clipbrd, rxdconst, rxFileUtils,
  SynEditSearch, fbmSQLEditor_ShowMemoUnit, LCLProc, LazUTF8,
  fbmfillqueryparamsunit, SQLEngineInternalToolsUnit,
  fbmStrConstUnit, fbmMakeSQLFromDataSetUnit, fbKeywordsUnit;

{$R *.lfm}

{ TfbmSQLEditorForm }

procedure TfbmSQLEditorForm.IBManagerSQLFormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  { TODO : Временный фикс - надо исправлять код в RxDBGrid-е. Там бАГИ! }
  FOwnerRec.SQLEditorHistory.OnDeleteError:=nil;
  FOwnerRec.SQLEditorHistory.OnPostError:=nil;
  FOwnerRec.SQLEditorHistory.OnFilterRecord := nil;
  FOwnerRec.SQLEditorHistory.BeforeDelete := nil;
  FOwnerRec.SQLEditorHistory.BeforePost:=nil;


  TreeView1.OnClick:=nil;
  SaveCurrent;
  CloseAction:=caFree;
  FreeAndNil(QueryControl);
  FOwnerRec.FSQLEditorForm:=nil;
end;

procedure TfbmSQLEditorForm.edtOpenExecute(Sender: TObject);
begin
  EditorFrame.edtOpen.Execute;
end;

procedure TfbmSQLEditorForm.rgCopyValueExecute(Sender: TObject);
begin
  if QueryControl.Active and (QueryControl.DataSet.RecordCount>0) then
  begin
    Clipboard.Open;
    Clipboard.AsText:=dbGrid1.SelectedColumn.Field.AsString;
    Clipboard.Close;
  end;
end;

procedure TfbmSQLEditorForm.rgExportAsInsertExecute(Sender: TObject);
var
  S: String;
begin
  if Assigned(QueryControl) and QueryControl.Active and (QueryControl.DataSet.RecordCount > 0) then
  begin
    S:='NEW_TABLE';
    if InputQuery(sCopySelectedRecordAsInsert,  sEnterTableName, S) then
    begin
      Clipboard.Open;
      Clipboard.AsText:=MakeSQLInsert(QueryControl.DataSet, S, dbGrid1.SelectedRows);
      Clipboard.Close;
    end;
  end;
end;

procedure TfbmSQLEditorForm.edtClearCurrentExecute(Sender: TObject);
begin
  EditorFrame.TextEditor.Text:='';
end;

procedure TfbmSQLEditorForm.edtCopyExecute(Sender: TObject);
begin
  EditorFrame.edtCopy.Execute;
end;

procedure TfbmSQLEditorForm.edtCutExecute(Sender: TObject);
begin
  EditorFrame.edtCut.Execute;
end;

procedure TfbmSQLEditorForm.edtFindExecute(Sender: TObject);
begin
//  EditorFrame.edtFind.Execute;
end;

procedure TfbmSQLEditorForm.edtFindNextExecute(Sender: TObject);
begin
  EditorFrame.edtFindNext.Execute;
end;

procedure TfbmSQLEditorForm.edtNewQuerySetExecute(Sender: TObject);
var
  S:string;
  Page:TSqlEditorPage;
  R, N:TTreeNode;
  F: TSQLEditorFolder;
begin
  S:='';
  if InputQuery( sEnterQuerySetName, sQuerySetName, S) then
  begin
    R:=AddTreeRoot(TreeView1.Items, S);

    F:=FOwnerRec.SqlEditors.AddFolder(S);
    F.Save;
    Page:=FOwnerRec.SqlEditors.Add(sPage + IntToStr(R.Count + 1), S);
    Page.SaveNew;

    N:=TreeView1.Items.AddChild(R, Page.Name);
    N.Data:=Page;
    N.ImageIndex:=itEditorNode;
    N.SelectedIndex:=itEditorNode;
    N.StateIndex:=itEditorNode;

    TreeView1.Selected:=N;
    TreeView1Click(TreeView1);
  end;
end;

procedure TfbmSQLEditorForm.edtPasteExecute(Sender: TObject);
begin
  EditorFrame.edtPaste.Execute;
end;

procedure TfbmSQLEditorForm.edtRedoExecute(Sender: TObject);
begin
  EditorFrame.edtRedo.Execute;
end;

procedure TfbmSQLEditorForm.edtSaveExecute(Sender: TObject);
begin
  EditorFrame.edtSave.Execute;
end;

procedure TfbmSQLEditorForm.edtUndoExecute(Sender: TObject);
begin
  EditorFrame.edtUndo.Execute;
end;

procedure TfbmSQLEditorForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

procedure SelectPage(ANext:boolean);
var
  N: TTreeNode;
begin
  if ANext then
    N:=TreeView1.Selected.GetNext
  else
    N:=TreeView1.Selected.GetPrev;

  if Assigned(N) and Assigned(N.Data) and (TObject(N.Data) is TSqlEditorPage) then
  begin
    TreeView1.Selected:=N;
    TreeView1Click(nil);
  end;
end;

begin
  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) then
  begin
    if TObject(TreeView1.Selected.Data) is TSqlEditorPage then
      if ssCtrl in Shift then
      begin
        if Key = VK_PRIOR then SelectPage(false)
        else
        if Key = VK_NEXT then  SelectPage(true)
      end;
  end;
end;

procedure TfbmSQLEditorForm.fsCopyTextToClipExecute(Sender: TObject);
begin
  if quFindQuery.Active and (quFindQuery.RecordCount > 0) then
  begin
    Clipboard.Open;
    Clipboard.AsText:=quFindQuerysql_editors_body.AsString;
    Clipboard.Close;
  end;
end;

procedure TfbmSQLEditorForm.fsFindQueryExecute(Sender: TObject);
var
  S: String;
begin
  quFindQuery.Active:=false;
  S:='';
  if CheckBox1.Checked then
    AddMacro(S, 'upper(sql_editors.sql_editors_body) like ''%'+ValueString(UTF8UpperCase(EditButton1.Text))+'%''')
  else
    AddMacro(S, 'sql_editors.sql_editors_body like ''%'+ValueString(EditButton1.Text)+'%''');

  if not CheckBox2.Checked then
    AddMacro(S, 'db_database.db_database_sql_engine = '''+FSQLEngine.ClassName+'''');
  quFindQuery.MacroByName('Macro1').AsString:=S;
  quFindQuery.Open;
end;

procedure TfbmSQLEditorForm.fsTextToSQLEditorExecute(Sender: TObject);
begin
  if quFindQuery.Active and (quFindQuery.RecordCount > 0) then
  begin
    EditorFrame.TextEditor.Lines.Text:=quFindQuerysql_editors_body.AsString;
    PageControl1.ActivePageIndex:=0;
  end;
end;

procedure TfbmSQLEditorForm.histClearExecute(Sender: TObject);
begin
  while not FOwnerRec.SQLEditorHistory.RecordCount > 0 do
    FOwnerRec.SQLEditorHistory.Delete;
end;

procedure TfbmSQLEditorForm.histCopyAllExecute(Sender: TObject);
var
  S:string;
begin
  FOwnerRec.SQLEditorHistory.DisableControls;
  try
    S:='';
    FOwnerRec.SQLEditorHistory.First;
    while not FOwnerRec.SQLEditorHistory.EOF do
    begin
      S:=S+FOwnerRec.SQLEditorHistory.FieldByName('sql_editors_history_sql_text').AsString+LineEnding;
      FOwnerRec.SQLEditorHistory.Next;
    end;
  finally
    FOwnerRec.SQLEditorHistory.First;
    FOwnerRec.SQLEditorHistory.EnableControls;
  end;

  Clipboard.Open;
  Clipboard.AsText:=S;
  Clipboard.Close;
end;

procedure TfbmSQLEditorForm.histCopyClipExecute(Sender: TObject);
begin
  if FOwnerRec.SQLEditorHistory.RecordCount>0 then
  begin
    Clipboard.Open;
    Clipboard.AsText:=FOwnerRec.SQLEditorHistory.FieldByName('sql_editors_history_sql_text').AsString;
    Clipboard.Close;
  end;
end;

procedure TfbmSQLEditorForm.histDeleteExecute(Sender: TObject);
begin
  if FOwnerRec.SQLEditorHistory.RecordCount>0 then
    FOwnerRec.SQLEditorHistory.Delete;
end;

procedure TfbmSQLEditorForm.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePageIndex = 0 then
  begin
    Application.MainForm.ActiveControl:=EditorFrame.TextEditor;
//    InfoPageControl.SetFocus;
//    EditorFrame.TextEditor.SetFocus;
  end
  else
  if PageControl1.ActivePageIndex = 0 then
    Application.MainForm.ActiveControl:=dbGrid1
  else
    ActiveControl:=nil;

end;

procedure TfbmSQLEditorForm.quFindQueryAfterScroll(DataSet: TDataSet);
begin
  if Assigned(FFindResultText) then
    FFindResultText.EditorText:=quFindQuerysql_editors_body.AsString;
end;

procedure TfbmSQLEditorForm.quFindQuerysql_editors_history_dateGetText(
  Sender: TField; var aText: string; DisplayText: Boolean);
begin
  aText:=quFindQuerysql_editors_history_date.AsString;
end;

procedure TfbmSQLEditorForm.resAutoFillCollumnWidthExecute(Sender: TObject);
begin
  dbGrid1.OptimizeColumnsWidthAll;
end;

procedure TfbmSQLEditorForm.rgCopyTitleExecute(Sender: TObject);
begin
  if QueryControl.Active and (QueryControl.DataSet.RecordCount>0) then
  begin
    Clipboard.Open;
    Clipboard.AsText:=dbGrid1.SelectedColumn.Field.FieldName;
    Clipboard.Close;
  end;
end;

procedure TfbmSQLEditorForm.dbGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssCtrl in Shift then
  begin
    if QueryControl.DataSet.Active and (PageControl1.ActivePage = tabResult) then
    begin
      if Key = VK_ADD then
      begin
        dbGrid1.AutoFillColumns:=false;
        dbGrid1.OptimizeColumnsWidthAll;
      end
      else
      if Key = VK_SUBTRACT then
        dbGrid1.AutoFillColumns:=true;
    end;
  end;
end;

procedure TfbmSQLEditorForm.Edit1Change(Sender: TObject);
begin
  ShowQueryFields;
end;

procedure TfbmSQLEditorForm.dbGrid1DblClick(Sender: TObject);
var
  DF: TFieldType;
begin
  DF:=dbGrid1.SelectedColumn.Field.DataType;
  if QueryControl.Active and (QueryControl.DataSet.RecordCount>0) and (dbGrid1.SelectedColumn.Field.DataType in [ftMemo, ftBlob] ) then
  begin
    fbmSQLEditor_ShowMemoForm:=TfbmSQLEditor_ShowMemoForm.Create(Application);
    fbmSQLEditor_ShowMemoForm.Datasource1.DataSet:=dbGrid1.DataSource.DataSet;
    fbmSQLEditor_ShowMemoForm.DBMemo1.DataField:=dbGrid1.SelectedColumn.Field.FieldName;
    fbmSQLEditor_ShowMemoForm.ShowModal;
    fbmSQLEditor_ShowMemoForm.Free;
  end;
end;

procedure TfbmSQLEditorForm.ComboBox1Change(Sender: TObject);
var
  D: TDataBaseRecord;
begin
  if (ComboBox1.Items.Count > 1) and (ComboBox1.ItemIndex > 0) then
  begin
    TreeView2.BeginUpdate;
    TreeView2.Items.Clear;
    D:=TDataBaseRecord(ComboBox1.Items.Objects[ComboBox1.ItemIndex]);
    LoadEditorTabs(TreeView2, D);
    TreeView2.EndUpdate;
  end;
end;

procedure TfbmSQLEditorForm.CheckBox3Click(Sender: TObject);
begin
  ShowQueryFields;
end;

procedure TfbmSQLEditorForm.rgExportExecute(Sender: TObject);
begin
  FPDataExporter1.Execute;
end;

procedure TfbmSQLEditorForm.rgExportToPDFExecute(Sender: TObject);
begin
  RxDBGridExportPDF1.Execute;
end;

procedure TfbmSQLEditorForm.rgExportToSpreadsheetExecute(Sender: TObject);
begin
  RxDBGridExportSpreadSheet1.Execute;
end;

procedure TfbmSQLEditorForm.RxDBGrid1DblClick(Sender: TObject);
begin
  if FOwnerRec.SQLEditorHistory.Active and (FOwnerRec.SQLEditorHistory.RecordCount>0) then
  begin
    EditorFrame.TextEditor.Lines.Text:=FOwnerRec.SQLEditorHistory.FieldByName('sql_editors_history_sql_text').AsString;
    PageControl1.ActivePageIndex:=0;
  end;
end;

procedure TfbmSQLEditorForm.ctrlCreateSPExecute(Sender: TObject);
begin
  //
end;

procedure TfbmSQLEditorForm.ctrlCreateViewExecute(Sender: TObject);
begin
  //
end;

procedure TfbmSQLEditorForm.editExecQueryFetchAllExecute(Sender: TObject);
begin
  editExecQuryExecute(Sender);
  if QueryControl.Active then
    QueryControl.FetchAll;
end;

procedure TfbmSQLEditorForm.editExecQuryExecute(Sender: TObject);
var
  F:boolean;
  SQLCommand:TSQLCommandAbstract;
  S,S1, ErrMsg:string;
  i, ErrX, ErrY:integer;
  T: TTableItem;

begin
  SaveCurrent;
  SaveSQLEdiorsDesktop;

  S:=EditorFrame.TextEditor.SelText;
  if S = '' then
    S:=EditorFrame.TextEditor.Text;

  SQLCommand:=GetNextSQLCommand(S, FSQLEngine);
  if Assigned(SQLCommand) then
  begin
    try
      QueryControl.QuerySQL:=S;
      if QueryControl.ParamCount>0 then
      begin

        if SQLCommand.ParamsCount>0 then
        begin
          S1:='';
          for i:=0 to SQLCommand.ParamsCount-1 do
            S1:=S1+', '+SQLCommand.Params[i].RealName;
          ShowMessage(S1);
        end;

        F:=FillParamsList(QueryControl, FOwnerRec, SQLCommand)

      end
      else
        f:=true;
      DoStartExecQuery;
      if F then
      begin
        if (not (SQLCommand is TSQLCommandDDL)) and (SQLCommand is TSQLCommandAbstractSelect) and TSQLCommandAbstractSelect(SQLCommand).Selectable then
        begin;
          QueryControl.Active:=true;
          { #todo -oalexs : Переработать - вынести в QueryControl }
          if TSQLCommandAbstractSelect(SQLCommand).Tables.Count = 1 then
          begin
            T:=TSQLCommandAbstractSelect(SQLCommand).Tables[0];
            if T.TableType = stitTable then
            begin
              QueryControl.ReadOnly:=false;
              dbGrid1.Options:=dbGrid1.Options + [dgEditing];
              dbGrid1.ReadOnly:=false;
            end
            else
            begin
              QueryControl.ReadOnly:=true;
              dbGrid1.Options:=dbGrid1.Options - [dgEditing];
              dbGrid1.ReadOnly:=true;
            end;
          end
          else
          begin
            QueryControl.ReadOnly:=true;
            dbGrid1.Options:=dbGrid1.Options - [dgEditing];
            dbGrid1.ReadOnly:=true;
          end;

          LoadStatistic(SQLCommand);
          if SQLCommand.PlanEnabled and ConfigValues.ByNameAsBoolean('SQLEditor/Show query plan', true) then
            ShowInfoMessages(QueryControl.QueryPlan)
          else
            HideInfoMessages;

          if ConfigValues.ByNameAsBoolean('seFetchAll', false) then
            QueryControl.FetchAll;

          ShowResultTab(true);
          if ConfigValues.ByNameAsBoolean('seGoToResult', true) then
          begin
            if not ConfigValues.ByNameAsBoolean('Show result grid on first page', false) then
            begin
              PageControl1.ActivePage:=tabResult;
              PageControl2.ActivePageIndex:=0;
            end;
            dbGrid1.SetFocus;
          end;
          ShowQueryFields;
        end
        else
        begin
          HideQueryFields;
          QueryControl.Prepare;

          if SQLCommand.PlanEnabled and ConfigValues.ByNameAsBoolean('SQLEditor/Show query plan', true) then
            ShowInfoMessages(QueryControl.QueryPlan)
          else
            HideInfoMessages;
          QueryControl.ExecSQL;
          ShowResultTab(false);

          if SQLCommand is TSQLDropCommandAbstract then
            FOwnerRec.DropObject(TSQLDropCommandAbstract(SQLCommand).FullName);
          LoadStatistic(SQLCommand);
        end;
        FEndTime:=Now;
        FOwnerRec.ExecSQLEditor(S, Memo1.Text, FEndTime - FStartTime, SQLCommand, FSqlEditorTextCur.Name);
      end;
    except
      on E:Exception do
      begin
        if QueryControl.ParseException(E, ErrX, ErrY, ErrMsg) then
        begin
          EditorFrame.TextEditor.CaretX:=ErrX;
          EditorFrame.TextEditor.CaretY:=ErrY;
          ShowInfoMessages(ErrMsg);
        end
        else
          ShowInfoMessages(E.Message);
      end;
    end;
    SQLCommand.Free;
    DoStopExecQuery;
  end
  else
    ShowInfoMessages(sSQLParseError);
end;

procedure TfbmSQLEditorForm.editShowPlanExecute(Sender: TObject);
var
  S: String;
begin
//  if SQLCommand.PlanEnabled then
  begin
    SaveCurrent;
    SaveSQLEdiorsDesktop;
    DoStartExecQuery;
    S:=EditorFrame.TextEditor.SelText;
    if S = '' then
      S:=EditorFrame.TextEditor.Text;

    QueryControl.QuerySQL:=S;
    try
      QueryControl.Prepare;
      ShowInfoMessages(QueryControl.QueryPlan);
    except
      on E:Exception do
        ShowInfoMessages(E.Message);
    end;
    DoStopExecQuery;
  end;
end;

procedure TfbmSQLEditorForm.edtDeleteAllExecute(Sender: TObject);
begin
  //
end;

procedure TfbmSQLEditorForm.edtDeleteExecute(Sender: TObject);
var
  P: TSqlEditorPage;
  F: TSQLEditorFolder;
  RootNode: TTreeNode;
begin
  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) then
  begin
    RootNode:=TreeView1.Selected.Parent;
    if TObject(TreeView1.Selected.Data) is TSqlEditorPage then
    begin
      if QuestionBox(sDeleteQuery) then
      begin
        P:=TSqlEditorPage(TreeView1.Selected.Data);
        if RootNode.Count > 1 then
        begin
          //Удаляем запрос
          FOwnerRec.SqlEditors.DeletePage(P);
          TreeView1.Items.Delete(TreeView1.Selected);
          FSqlEditorTextCur:=nil;
          TreeView1.Selected:=RootNode.Items[RootNode.Count - 1];
          TreeView1Click(TreeView1);
        end
        else
        begin
          //Последнйи запрос в узле - просто очистим
          P.Clear;
          LoadCurrent;
        end;
      end;
    end
    else
    if TObject(TreeView1.Selected.Data) is TSQLEditorFolder then
    begin
      //Удаляем папку запросов
      F:=TSQLEditorFolder(TreeView1.Selected.Data);
      if QuestionBox(sDeleteQuerySet) then

    end;
  end
{    else
    begin
      //Удаляем узел
      RootNode:=TreeView1.Selected;
      if QuestionBox(sDeleteQuerySet) then
      begin
        for i:=0 to RootNode.Count-1 do
        begin
          P:=TSqlEditorText(RootNode.Items[i].Data);
          FOwnerRec.FSqlEditors.Remove(P);
        end;
        TreeView1.Items.Delete(RootNode);

        TreeView1.Selected:=TreeView1.Items[0].Items[0];
        FSqlEditorTextCur:=nil;
        TreeView1Click(nil);
      end;
    end;
  end;}
end;

procedure TfbmSQLEditorForm.edtNewPageExecute(Sender: TObject);

function MaxPageOrder:integer;
var
  RootNode: TTreeNode;
  i: Integer;
begin
  Result:=1;
  RootNode:=nil;
  if Assigned(TreeView1.Selected) then
  begin
    if TObject(TreeView1.Selected.Data) is TSqlEditorPage then
      RootNode:=TreeView1.Selected.Parent
    else
    if TObject(TreeView1.Selected.Data) is TSQLEditorFolder then
      RootNode:=TreeView1.Selected
  end
  else
    RootNode:=TreeView1.Items[0];

  if not Assigned(RootNode) then exit;

  for i:=0 to RootNode.Count - 1 do
    if TSqlEditorPage(RootNode.Items[i].Data).SortOrder > Result then
      Result:=TSqlEditorPage(RootNode.Items[i].Data).SortOrder + 1;
end;

var
  Page:TSqlEditorPage;
  RootNode, Node:TTreeNode;
  S:string;
begin
  S:='';
  if not Assigned(TreeView1.Selected) then
  begin
    if TreeView1.Items.Count = 0 then
      RootNode:=AddTreeRoot(TreeView1.Items, '')
    else
      RootNode:=TreeView1.Items[0]
  end
  else
  begin
    if Assigned(TreeView1.Selected.Data) then
      RootNode:=TreeView1.Selected.Parent
    else
      RootNode:=TreeView1.Selected;

    if RootNode<>TreeView1.Items[0] then
      S:=RootNode.Text;
  end;

  Page:=FOwnerRec.SqlEditors.Add(sPage + IntToStr(RootNode.Count+1), S);
  Page.SortOrder:=MaxPageOrder;
  Page.SaveNew;

  Node:=TreeView1.Items.AddChild(RootNode, Page.Name);
  Node.ImageIndex:=itEditorNode;
  Node.SelectedIndex:=itEditorNode;
  Node.StateIndex:=itEditorNode;
  Node.Data:=Page;

  TreeView1.Selected:=Node;
  TreeView1Click(TreeView1);
  PageControl1.ActivePageIndex:=0;
end;

procedure TfbmSQLEditorForm.edtRenameTabExecute(Sender: TObject);
var
  S:string;
  P:TSqlEditorPage;
  RootNode:TTreeNode;
  i:integer;
  F: TSQLEditorFolder;
begin
  if Assigned(TreeView1.Selected) then
  begin
    P:=TSqlEditorPage(TreeView1.Selected.Data);
    if Assigned(P) then
    begin
      S:=TreeView1.Selected.Text;
      if InputQuery(sEnterName, sSQLPageName, S) then
      begin
        TreeView1.Selected.Text:=S;
        P.Name:=S;
        P.Save;
      end;
    end
    else
    begin
      S:=TreeView1.Selected.Text;
      F:=FOwnerRec.SqlEditors.FolderByName(S);
      if InputQuery(sEnterName, sSQLPageName, S) then
      begin
        F.FolderName:=S;
        F.Save;
        RootNode:=TreeView1.Selected;
        RootNode.Text:=S;
      end;
    end
  end
end;

procedure TfbmSQLEditorForm.resCloseQueryExecute(Sender: TObject);
begin
  QueryControl.Active:=false;
  if (Sender as TComponent).Tag = 1 then
    QueryControl.CommitTransaction
  else
    QueryControl.RolbackTransaction;

  PageControl1.ActivePage:=TabSqlEdit;
  ShowResultTab(false);
  HideInfoMessages;
  SetRecordCountCaption('');
end;

procedure TfbmSQLEditorForm.resPrintExecute(Sender: TObject);
begin
  if Assigned(FSqlEditorTextCur) then
    RxDBGridPrint1.ReportTitle:=FSqlEditorTextCur.Name;
  RxDBGridPrint1.PreviewReport;
end;

procedure TfbmSQLEditorForm.RxDBGrid1GetCellProps(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor);
begin
  //Тип запросов: 0 - select, 1 - ins, 2 - upd, 3 - del
  case FOwnerRec.SQLEditorHistory.FieldByName('sql_editors_history_sql_type').AsInteger of
    0:Background:=FColor1;
    1:Background:=FColor2;
    2:Background:=FColor3;
    3:Background:=FColor4
  end;
end;

procedure TfbmSQLEditorForm.RxDBGrid2DblClick(Sender: TObject);
begin
  fsTextToSQLEditor.Execute;
end;

procedure TfbmSQLEditorForm.SearchFind1Accept(Sender: TObject);
begin
  //
end;

procedure TfbmSQLEditorForm.statFilterExecute(Sender: TObject);
begin
  if rdgFilter in dbGrid1.OptionsRx then
    dbGrid1.OptionsRx:=dbGrid1.OptionsRx - [rdgFilter]
  else
    dbGrid1.OptionsRx:=dbGrid1.OptionsRx + [rdgFilter];
end;

procedure TfbmSQLEditorForm.statFunctExecute(Sender: TObject);
begin
  RxDBGridFooterTools1.Execute;
end;

procedure TfbmSQLEditorForm.statRecordCountExecute(Sender: TObject);
var
  Cnt:integer;
begin
  if QueryControl.Active then
    Cnt:=QueryControl.DataSet.RecordCount
  else
    Cnt:=0;
  SetRecordCountCaption(Format(sRecordCountInTable, [Cnt]));
end;

procedure TfbmSQLEditorForm.TreeView1Click(Sender: TObject);
var
  P:TSqlEditorPage;
  TV: TTreeView;
begin
  TV:=TTreeView(Sender);
  if Assigned(TV) and Assigned(TV.Selected) then
    if Assigned(TV.Selected.Data) then
    begin
      if TObject(TV.Selected.Data) is TSqlEditorPage then
      begin
        P:=TSqlEditorPage(TV.Selected.Data);
        if Assigned(P) then
        begin
          SaveCurrent;
          FSqlEditorTextCur:=P;
          LoadCurrent;
          EditorFrame.UpdateStatusBar;
          PageControl1.ActivePageIndex:=0;
          if Visible then
            EditorFrame.TextEditor.SetFocus;
        end;
      end
      else
      if TObject(TV.Selected.Data) is TSQLEditorFolder then
      begin
      end;
    end;
end;

procedure TfbmSQLEditorForm.TreeView1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  Control :TControl;
  P, P1:TSqlEditorPage;

  N, R:TTreeNode;
  i1, K, i: Integer;
begin
  Control:=SynEditAcceptDrag(Source);
  if (Control = TreeView1) and Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) then
  begin
    P:=TSqlEditorPage(TreeView1.Selected.Data);

    N:=TreeView1.GetNodeAt(X, Y);
    if Assigned(N) then
    begin
      if Assigned(N.Data) then
        R:=N
      else
        R:=N.Items[0];
      P1:=TSqlEditorPage(R.Data);
      if P1 = P then
         exit;

      i1:=P1.SortOrder;
      K:=R.Parent.IndexOf(R);
      for i:=k to R.Parent.Count-1 do
      begin
        N:=R.Parent.Items[i];
        if Assigned(N) and Assigned(N.Data) then
        begin
          if (TObject(N.Data) is TSqlEditorPage) then
            TSqlEditorPage(N.Data).SortOrder:=TSqlEditorPage(N.Data).SortOrder + 1;
        end;
      end;

      TreeView1.Selected.MoveTo(R, naInsert);
      P.Folder:=P1.Folder;
      P.SortOrder:=i1;
    end
  end
end;

procedure TfbmSQLEditorForm.TreeView1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept:=Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data);
end;

procedure TfbmSQLEditorForm.LMEditorChangeParams(var message: TLMNoParams);
begin
  inherited;
  ChangeVisualParams;
end;

procedure TfbmSQLEditorForm.LMNotyfyDelObject(var Message: TLMessage);
begin
  inherited;
  EditorFrame.CompletionListClear;
end;

procedure TfbmSQLEditorForm.ShowResultTab(AShow: boolean);
var
  R: TRxColumn;
begin
  {Отображаем или прячем информацию об ошибках/планах и т.д. }

  if ConfigValues.ByNameAsBoolean('Show result grid on first page', false) then
  begin
    tabResult.TabVisible:=false;
    if AShow and (Panel5.Parent <> TabSqlEdit) then
    begin
      Panel5.Visible:=true;
      Panel5.Height:=TabSqlEdit.Height div 3;
      Panel5.Parent:=TabSqlEdit;
      Panel5.Align:=alBottom;
      Splitter5.Visible:=true;
      Splitter5.Top:=Panel5.Height - Splitter5.Height;
    end
{    else
    begin

    end;}
  end
  else
  begin
    tabResult.TabVisible:=AShow;
    if AShow and (Panel5.Parent <> tabResult) then
    begin
      Panel5.Parent:=tabResult;
      Panel5.Align:=alClient;
      Splitter5.Visible:=false;
    end;
  end;

  TabStatistic.TabVisible:=AShow;
  if AShow then
    for R in dbGrid1.Columns do
      R.Filter.Style:=TRxFilterStyle(ConfigValues.ByNameAsInteger('Grid filter style', 0));
end;

procedure TfbmSQLEditorForm.LoadStatistic(const SQLCommand: TSQLCommandAbstract
  );

procedure AddValue(AValue:integer; ACaption:string; var AStr:string);
begin
  if AValue <> 0 then
  begin
    if AStr <> '' then
      AStr:=AStr + LineEnding;
    AStr:=Format(ACaption, [AValue]);
  end;
end;

var
  StatRec: TQueryStatRecord;
  S: String;
begin
  if Memo1.Visible and QueryControl.LoadStatistic(StatRec, SQLCommand) then
  begin
    S:='';
    AddValue(StatRec.SelectedRows, sSelectedRowsInfo, S);
    AddValue(StatRec.InsertedRows, sInsertedRowsInfo, S);
    AddValue(StatRec.UpdatedRows, sUpdatedRowsInfo, S);
    AddValue(StatRec.DeletedRows, sDeletedRowsInfo, S);
    if S<>'' then
      ShowInfoMessages(S);
      //Memo1.Lines.Text:=Memo1.Lines.Text + LineEnding + S;
  end;
end;

procedure TfbmSQLEditorForm.ShowInfoMessages(S: string);
begin
  tabMessages.TabVisible:=true;
  InfoPageControl.ActivePage:=tabMessages;
  UpdateInfoPageControlState;
//  if Memo1.Lines.Count>0 then
  Memo1.Lines.Add(S);{:=Memo1.Lines.Text + S;
  else
    S:=LineEnding + S;
  Memo1.Lines.Text:=Memo1.Lines.Text + S;}
end;

procedure TfbmSQLEditorForm.DataSetAfterScrollRecord(Sender: TDataSet);
begin
  if dbGrid1.SelectedRows.Count > 1 then
    Label1.Caption:=Format(sRecordFetchedWithSelected, [QueryControl.DataSet.RecordCount, dbGrid1.SelectedRows.Count])
  else
    Label1.Caption:=Format(sRecordFetched, [QueryControl.DataSet.RecordCount]);
end;

function TfbmSQLEditorForm.SynEditAcceptDrag(const Source: TObject): TControl;
begin
  if Source is TControl then
    Result:=Source as TControl
  else
  if Source is TDragControlObject then
    Result:=(Source as TDragControlObject).Control
  else
    Result:=nil;
end;

procedure TfbmSQLEditorForm.TextEditorChange(Sender: TObject);
begin
  if Assigned(FSqlEditorTextCur) then
    FSqlEditorTextCur.Modified:=EditorFrame.Modified;
  EditorFrame.UpdateStatusBar;
end;

procedure TfbmSQLEditorForm.EditorFrameGetFieldsList(
  Sender: Tfdbm_SynEditorFrame; const DBObjName: string;
  const Items: TSynCompletionObjList; ACharCase: TCharCaseOptions);
var
  SQLCommand, SQLCommand2:TSQLCommandAbstract;
  S:string;
  DBObj:TDBObject;
  T: TTableItem;
  F: TSQLParserField;
  C: TSQLCommandSelectCTE;

begin
  S:=EditorFrame.TextEditor.Text;

  SQLCommand:=GetNextSQLCommand(S, FSQLEngine, true);
  if Assigned(SQLCommand) then
  begin
    if (SQLCommand is TSQLCommandSelect) then
    begin
      C:=TSQLCommandSelect(SQLCommand).CTE.FindItem(DBObjName);
      if Assigned(C) then
      begin
        for F in C.Fields do
          Items.Add(scotField, F.Caption, '', Format(sFieldFromCTE, [C.Name]));
      end
      else
      for T in TSQLCommandAbstractSelect(SQLCommand).Tables do
      begin
        if T.TableType = stitVirtualTable then
        begin
          if T.Fields.Count > 0 then
            for F in T.Fields do Items.Add(scotField, F.Caption, '', Format(sFieldFromNamedSelect, [T.TableAlias]))
          else
          begin
            SQLCommand2:=GetNextSQLCommand(T.TableExpression, FSQLEngine);
            if Assigned(SQLCommand2) then
            begin
              if (SQLCommand is TSQLCommandAbstractSelect) then
              begin
                for F in TSQLCommandAbstractSelect(SQLCommand2).Fields do
                  if F.RealName <> '' then
                    Items.Add(scotField, F.RealName, '', Format(sFieldFromNamedSelect, [T.TableAlias]))
                  else
                  if F.Caption <> '' then
                    Items.Add(scotField, F.Caption, '', Format(sFieldFromNamedSelect, [T.TableAlias]));
              end;
              SQLCommand2.Free;
            end;
          end;
          Break;
        end
        else
        if CompareText(T.TableAlias, DBObjName) = 0  then
        begin
          DBObj:=FOwnerRec.GetDBObject(T.Name);
          if Assigned(DBObj) then
          begin
            Items.FillFieldList(DBObj);
            Break;
          end;
        end;
      end;
    end;
    SQLCommand.Free;
  end;
end;

procedure TfbmSQLEditorForm.EditorFrameGetKeyWordList(
  Sender: Tfdbm_SynEditorFrame; const KeyStartWord: string;
  const Items: TSynCompletionObjList; ACharCase: TCharCaseOptions);
var
  SQLCommand:TSQLCommandAbstract;
  T: TTableItem;
  P: TSQLParserField;
  C: TSQLCommandSelectCTE;
  DBObj: TDBObject;
  F: TDBField;
begin
  SQLCommand:=GetNextSQLCommand(EditorFrame.TextEditor.Text, FSQLEngine, true);
  if Assigned(SQLCommand) then
  begin
    if (SQLCommand is TSQLCommandAbstractSelect) then
    begin
      if KeyStartWord = ':' then
        for P in TSQLCommandAbstractSelect(SQLCommand).Params do
          Items.Add(P)
      else
      begin
        for C in TSQLCommandSelect(SQLCommand).CTE do
        begin
          if CompareText(C.Name, KeyStartWord) = 0 then
            Items.Add(scotDBObject, C.Name, '', 'CTE');
        end;
        //for
        //for T in TSQLCommandAbstractSelect(SQLCommand).Tables do
        //   Items.FillFieldList(FOwnerRec.GetDBObject(T.Name));
        for T in TSQLCommandAbstractSelect(SQLCommand).Tables do
          if T.TableType = stitVirtualTable then
            Items.Add(T)
          else
          if SQLCommand is TSQLCommandDML then
          begin
            DBObj:=FSQLEngine.DBObjectByName(T.FullName);
            if Assigned(DBObj) then
              if (DBObj.DBObjectKind in [okTable, okView, okMaterializedView]) and (DBObj is TDBDataSetObject) then
                for F in TDBDataSetObject(DBObj).Fields do
                  if CompareText(F.FieldName, KeyStartWord) = 0 then
                    Items.Add(F);
          end;

      end;
    end
    else
    if (SQLCommand is TSQLCommandDDL) then
    begin
      for T in TSQLCommandDDL(SQLCommand).Tables do
        Items.FillFieldList(FOwnerRec.GetDBObject(T.Name));
      for T in TSQLCommandDDL(SQLCommand).Tables do
        Items.Add(T);
    end;

    SQLCommand.Free;
  end;
end;

function TfbmSQLEditorForm.EditorFrameOnGetDBObjectByAlias(
  Sender: Tfdbm_SynEditorFrame; const ATableAlias: string; out DBObjName: string
  ): TDBObject;
var
  SQLCommand:TSQLCommandAbstract;
  S:string;
  i:integer;
begin
  Result:=nil;
  S:=EditorFrame.TextEditor.Text;
  DBObjName:='';

  SQLCommand:=GetNextSQLCommand(S, FSQLEngine);
  if Assigned(SQLCommand) then
  begin
    if (SQLCommand is TSQLCommandAbstractSelect) then
    begin
      for i:=0 to TSQLCommandAbstractSelect(SQLCommand).Tables.Count - 1 do
      begin
        if CompareText(TSQLCommandAbstractSelect(SQLCommand).Tables[i].TableAlias, ATableAlias) = 0 then
        begin
          Result:=FOwnerRec.GetDBObject(TSQLCommandAbstractSelect(SQLCommand).Tables[i].Name);
          if Assigned(Result) then
          begin
            DBObjName:=Result.Caption;
            break;
          end;
        end;
      end;
    end;
    SQLCommand.Free;
  end;
end;

procedure TfbmSQLEditorForm.Localize;
begin
  Caption:=sSQLEditor;
  ctrlCreateView.Caption:=sCreateView;
  ctrlCreateView.Hint:=sCreateViewHint;
  ctrlCreateSP.Caption:=sCreateSP;
  ctrlCreateSP.Hint:=sCreateSPHint;
  editExecQury.Caption:=sExecuteQuery;
  editExecQury.Hint:=sExecuteQueryHint;
  editExecQueryFetchAll.Caption:=sExecuteQueryFetchAll;
  editExecQueryFetchAll.Hint:=sExecuteQueryFetchAllHint;
  editShowPlan.Caption:=sShowQueryPlan;
  editShowPlan.Hint:=sShowQueryPlan;
  edtOpen.Caption:=sOpen;
  edtOpen.Hint:=sOpenFile;
  edtSave.Caption:=sSave;
  edtSave.Hint:=sSaveFile;
  edtCut.Caption:=sCut;
  edtCut.Hint:=sCutHint;
  edtCopy.Caption:=sCopy;
  edtCopy.Hint:=sCopyHint;
  edtPaste.Caption:=sPaste;
  edtPaste.Hint:=sPasteHint;
  edtFind.Caption:=sFind;
  edtFindNext.Caption:=sFindNext;
  edtReplace.Caption:=sReplace;
  edtRedo.Caption:=sRedo;
  edtRedo.Hint:=sRedoHint;
  edtUndo.Caption:=sUndo;
  edtUndo.Hint:=sUndoHint;


  edtClearCurrent.Caption:=sClearCurrentQuery;
  edtNewPage.Caption:=sNewQuery;
  edtDelete.Caption:=sDelete;
  edtDeleteAll.Caption:=sDeleteAll;
  edtRenameTab.Caption:=sRenameTab;
  edtRenameTab.Hint:=sRenameTabHint;
  edtNewQuerySet.Caption:=sNewQuerySet;
  edtNewQuerySet.Hint:=sNewQuerySetHint;
  histClear.Caption:=sClear;
  histOpen.Caption:=sOpenInEditor;
  histOpen.Hint:=sOpenInEditorHint;
  histDelete.Caption:=sDeleteStatement;
  histDelete.Hint:=sDeleteStatementHint;
  histCopyClip.Caption:=sCopyToClipboard;
  histCopyClip.Hint:=sCopyToClipboardHint;
  histCopyAll.Caption:=sCopyAllStatementToClip;
  histCopyAll.Hint:=sCopyAllStatementToClipHint;
  resCommit.Caption:=sCommit;
  resCommit.Hint:=sCommitHint;
  resRolback.Caption:=sRolback;
  resRolback.Hint:=sRolbackHint;
  resPrint.Caption:=sPrint;
  resPrint.Hint:=sPrintQueryResult;

  rgCopyValue.Caption:=sCopyCellValue;
  rgCopyTitle.Caption:=sCopyCollumnFieldTitle;
  rgExport.Caption:=sExportData;
  rgExportToPDF.Caption:=sExportDataToPDF;
  rgExportToSpreadsheet.Caption:=sExportDataToSpreadsheet;
  rgExportAsInsert.Caption:=sCopySelectedRecordAsInsert;

  TabSqlEdit.Caption:=sEditor;
  tabResult.Caption:=sResult;
  TabStatistic.Caption:=sStatistic;
  tabHistory.Caption:=sHistory;

  RxDBGrid1.ColumnByFieldName('sql_editors_history_sql_page_name').Title.Caption:=sSrcPageName;

  tabFindResult.Caption:=sFindQuery;
  tabMessages.Caption:=sMessages;
  tabQueryFields.Caption:=sQueryFields;
  TabSheet1.Caption:=sResultGrid;
  TabSheet2.Caption:=sResultForm;

  Label2.Caption:=sFindText;
  CheckBox1.Caption:=sCaseSensetive;

  statFilter.Caption:=sFilterInTable;
  statFilter.Hint:=sFilterInTableHint;
  statFunct.Caption:=sSummaryLine;
  statFunct.Hint:=sSummaryLineHint;

  CheckBox3.Caption:=sWithDataType;
  Label3.Caption:=sSeparator;

  resAutoFillCollumnWidth.Caption:=sAutoFillCollumnWidth;
  resAutoFillCollumnWidth.Hint:=sAutoFillCollumnWidthHint;

  SetRecordCountCaption('');
  SetDBNavigatorHint(DBNavigator1);
end;

procedure TfbmSQLEditorForm.UpdateExecTimeInfo;
var
  D:TDateTime;
  TF: TFormatSettings;
begin
  D:=FEndTime - FStartTime;

  TF:=DefaultFormatSettings;
  TF.LongTimeFormat:='hh:nn:ss:zzz';
  lblTimeInfo.Caption:=sExecTime + ' ' + TimeToStr(D, TF);

  if D > SecsPerDay * 60 then
    ShowMessage(sExecComplete + ' ' +lblTimeInfo.Caption+'.');
end;

procedure TfbmSQLEditorForm.SetRecordCountCaption(const S: string);
begin
  if S<>'' then
    statRecordCount.Caption:=S
  else
    statRecordCount.Caption:=sRecordCountGet;
  SpeedButton1.Width:=16 + SpeedButton1.Glyph.Width + SpeedButton1.Canvas.TextWidth(statRecordCount.Caption);
end;

procedure TfbmSQLEditorForm.FillCommonDBList;
var
  D: TDataBaseRecord;
begin
  ComboBox1.Items.Clear;
  ComboBox1.Items.Add(sCommonQuery);

  if Assigned(fbManDataInpectorForm) then
    for D in fbManDataInpectorForm.DBList do
      ComboBox1.Items.AddObject(D.Caption, D);

  ComboBox1.ItemIndex:=0
end;

procedure TfbmSQLEditorForm.UpdateInfoPageControlState;
begin
  InfoPageControl.Visible:=tabMessages.TabVisible or tabQueryFields.TabVisible;
  if InfoPageControl.Visible then
    Splitter2.Top:=InfoPageControl.Top - Splitter2.Height;
end;

procedure TfbmSQLEditorForm.ShowQueryFields;
var
  F: TField;
  S: String;
begin
  tabQueryFields.TabVisible:=true;
  UpdateInfoPageControlState;
  Memo2.Lines.Clear;
  if not QueryControl.DataSet.Active then exit;
  S:='';
  for F in QueryControl.DataSet.Fields do
  begin
    if S<>'' then S:=S + Edit1.Text + LineEnding;
    S:=S + F.FieldName;
    if CheckBox3.Checked then
      S:=S + ' : ' + Fieldtypenames[F.DataType];
  end;
  S:=Format(sFieldCount + LineEnding, [QueryControl.DataSet.FieldCount]) + S;
  Memo2.Text:=S;
end;

procedure TfbmSQLEditorForm.HideQueryFields;
begin
  tabQueryFields.TabVisible:=false;
  UpdateInfoPageControlState;
end;

procedure TfbmSQLEditorForm.HideInfoMessages;
begin
  tabMessages.TabVisible:=false;
  UpdateInfoPageControlState;
end;

procedure TfbmSQLEditorForm.DoStartExecQuery;
begin
  FStartTime:=Now;
  Memo1.Lines.Clear;
  Screen.Cursor:=crHourGlass;
  editExecQury.Enabled:=false;
  editExecQueryFetchAll.Enabled:=false;
  Application.ProcessMessages;
end;

procedure TfbmSQLEditorForm.DoStopExecQuery;
begin
  FEndTime:=Now;
  editExecQury.Enabled:=true;
  editExecQueryFetchAll.Enabled:=true;
  Screen.Cursor:=crDefault;
  UpdateExecTimeInfo;
end;

procedure TfbmSQLEditorForm.OnEditorChangeStatus(Sender: TObject);
begin
  edtCopy.Enabled:=EditorFrame.edtCopy.Enabled;
  edtCut.Enabled:=EditorFrame.edtCut.Enabled;
  edtPaste.Enabled:=EditorFrame.edtPaste.Enabled;
  edtUndo.Enabled:=EditorFrame.edtUndo.Enabled;
  edtRedo.Enabled:=EditorFrame.edtRedo.Enabled;
end;

procedure TfbmSQLEditorForm.OnBeforeSaveFileEdit(Sender: Tfdbm_SynEditorFrame;
  const TextEditor: TSynEdit; var AFileName: string);
begin
  if (AFileName <> '') or (not Assigned(FSqlEditorTextCur)) then Exit;
  AFileName:=NormalizeFileName(FSqlEditorTextCur.Name);
end;

procedure TfbmSQLEditorForm.UpdateColorDBMarking;
begin
  if Assigned(FOwnerRec) and (FOwnerRec.FcmAllowColorsMarking) then
  begin
    shlTop.Visible :=FOwnerRec.FcmWindowTop;
    shlLeft.Visible :=FOwnerRec.FcmWindowLeft;
    shlRight.Visible :=FOwnerRec.FcmWindowRight;
    shlBottom.Visible :=FOwnerRec.FcmWindowBottom;
    shlTop.Color :=FOwnerRec.FcmLineColor;
    shlLeft.Color :=FOwnerRec.FcmLineColor;
    shlRight.Color :=FOwnerRec.FcmLineColor;
    shlBottom.Color :=FOwnerRec.FcmLineColor;
  end
  else
  begin
    shlTop.Visible :=false;
    shlLeft.Visible :=false;
    shlRight.Visible :=false;
    shlBottom.Visible :=false;
  end;
end;

procedure TfbmSQLEditorForm.SaveSQLEdiorsDesktop;
begin
//  FOwnerRec.SaveSQLEditor(nil);
end;

procedure TfbmSQLEditorForm.LoadEditorTabs(ATreeView: TTreeView;
  ADBRecord: TDataBaseRecord);
var
  RootNode:TTreeNode;
  SqlItem, F:TTreeNode;
  P: TSqlEditorPage;
  FSaveClick: TNotifyEvent;
begin
  FSaveClick:=ATreeView.OnClick;
  ATreeView.OnClick:=nil;
  ATreeView.Items.Clear;
  FSqlEditorTextCur:=nil;
  F:=nil;

  if Assigned(ADBRecord) then
  begin
    if ADBRecord.SqlEditors.Count>0 then
    begin
      for P in ADBRecord.SqlEditors do
      begin
        RootNode:=AddTreeRoot(ATreeView.Items, P.FolderName);
        SqlItem:=ATreeView.Items.AddChildObject(RootNode, P.Name, P);
        SqlItem.ImageIndex:=itEditorNode;
        SqlItem.SelectedIndex:=itEditorNode;
        SqlItem.StateIndex:=itEditorNode;
        if (P.FolderName = '') and (F = nil) then F:=SqlItem;
      end;

      if TreeView1 = ATreeView then
      begin
        PageControl1.ActivePageIndex:=0;
        TreeView1.Selected:=F;
        TreeView1Click(TreeView1);
      end;
    end
    else
    if TreeView1 = ATreeView then
      edtNewPageExecute(nil);
  end;
  ATreeView.OnClick:=FSaveClick;
end;

procedure TfbmSQLEditorForm.SaveCurrent;
begin
  if Assigned(FSqlEditorTextCur) then
  begin
    FSqlEditorTextCur.Text:=EditorFrame.TextEditor.Lines.Text;
    FSqlEditorTextCur.CarretPos:=EditorFrame.TextEditor.CaretXY;
    FSqlEditorTextCur.SelStart:=EditorFrame.TextEditor.SelStart;
    FSqlEditorTextCur.SelEnd:=EditorFrame.TextEditor.SelEnd;
    FSqlEditorTextCur.Save;
  end;
end;

procedure TfbmSQLEditorForm.LoadCurrent;
begin
  if Assigned(FSqlEditorTextCur) then
  begin
    if FSqlEditorTextCur.Text<>'' then
    begin
      EditorFrame.TextEditor.Text:=FSqlEditorTextCur.Text;
      EditorFrame.TextEditor.CaretXY:=FSqlEditorTextCur.CarretPos;
      EditorFrame.TextEditor.SelStart:=FSqlEditorTextCur.SelStart;
      EditorFrame.TextEditor.SelEnd:=FSqlEditorTextCur.SelEnd;
    end
    else
      EditorFrame.TextEditor.ClearAll;
  end
  else
  begin
    EditorFrame.TextEditor.CaretX:=1;
    EditorFrame.TextEditor.CaretY:=1;
    EditorFrame.TextEditor.Lines.Clear;
  end;
  EditorFrame.TextEditor.Modified:=false;
end;

function TfbmSQLEditorForm.FindTreeRoot(AItems: TTreeNodes;
  const RootName: string): TTreeNode;
var
  i:integer;
begin
  Result:=nil;
  for I:=0 to AItems.TopLvlCount-1 do
    if AItems.TopLvlItems[i].Text = RootName then
    begin
      Result:=AItems.TopLvlItems[i];
      exit;
    end;
end;

function TfbmSQLEditorForm.AddTreeRoot(AItems:TTreeNodes; RootName: string): TTreeNode;
begin
  if RootName = '' then
    RootName:=sDefaultQuerySet;

  Result:=FindTreeRoot(AItems, RootName);
  if not Assigned(Result) then
  begin
    Result:=AItems.Add(nil, RootName);
    Result.ImageIndex:=itFolderNode;
    Result.SelectedIndex:=itFolderNode;
    Result.StateIndex:=itFolderNode
  end;
end;

procedure TfbmSQLEditorForm.ChangeVisualParams;
begin
  if QueryControl.Active then
      FBDataSetAfterOpen(QueryControl.DataSet);
  SetRxDBGridOptions(dbGrid1);
  SetRxDBGridOptions(RxDBGrid1);
  EditorFrame.ChangeVisualParams;
  Caption:=sSQLEditor + ' ('+FOwnerRec.Caption+')';
  FColor1:=ConfigValues.ByNameAsInteger('SQLHistory-SELECT_Color', clWindow);
  FColor2:=ConfigValues.ByNameAsInteger('SQLHistory-INSERT_Color', clSkyBlue);
  FColor3:=ConfigValues.ByNameAsInteger('SQLHistory-UPDATE_Color', clMoneyGreen);
  FColor4:=ConfigValues.ByNameAsInteger('SQLHistory-DELETE_Color', clGreen);
end;

constructor TfbmSQLEditorForm.CreateSqlEditor(AOwnerRec: TDataBaseRecord);
begin
  inherited Create(Application);
  Localize;
  HideInfoMessages;
  HideQueryFields;
  RxDBGridFooterTools1.Caption:=sRxDBGridToolsCaption;
  RxDBGridExportSpreadSheet1.Caption:=sToolsExportSpeadSheet;

  FOwnerRec:=AOwnerRec;
  FSQLEngine:=FOwnerRec.SQLEngine;
  QueryControl:=FOwnerRec.SQLEngine.GetQueryControl;

  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Name:='EditorFrame';
  EditorFrame.Parent:=TabSqlEdit;
  EditorFrame.SQLEngine:=FSQLEngine;
  EditorFrame.OnGetFieldsList:=@EditorFrameGetFieldsList;
  EditorFrame.OnGetKeyWordList:=@EditorFrameGetKeyWordList;
  EditorFrame.OnGetDBObjectByAlias:=@EditorFrameOnGetDBObjectByAlias;
  EditorFrame.TextEditor.OnChange:=@TextEditorChange;
  EditorFrame.OnEditorChangeStatus:=@OnEditorChangeStatus;
  EditorFrame.OnBeforeSaveFile:=@OnBeforeSaveFileEdit;

  FFindResultText:=Tfdbm_SynEditorFrame.Create(Self);
  FFindResultText.Name:='FFindResultText';
  FFindResultText.Parent:=tabFindResult;
  FFindResultText.ReadOnly:=true;
  FFindResultText.Align:=alBottom;
  FFindResultText.Height:=tabFindResult.Height div 3;
  Splitter6.Top:=FFindResultText.Top - Splitter6.Height;

  PageControl1.OnChange:=nil;
  PageControl1.ActivePageIndex:=0;

  ChangeVisualParams;
  LoadEditorTabs(TreeView1, AOwnerRec);

  ShowResultTab(false);
  Datasource1.DataSet:=QueryControl.DataSet;
  FPDataExporter1.Dataset:=QueryControl.DataSet;
  QueryControl.DataSet.AfterScroll:=@DataSetAfterScrollRecord;
  QueryControl.DataSet.AfterOpen:=@DataSetAfterScrollRecord;
  dsHistory.DataSet:=FOwnerRec.SQLEditorHistory;

  PageControl1.OnChange:=@PageControl1Change;
  lblTimeInfo.Caption:='';

  if QueryControl.IsEditable then
    DBNavigator1.VisibleButtons:=[nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbEdit, nbPost, nbCancel, nbRefresh]
  else
    DBNavigator1.VisibleButtons:=[nbFirst, nbPrior, nbNext, nbLast];

  UpdateColorDBMarking;
  FillCommonDBList;
end;

procedure TfbmSQLEditorForm.SaveState(const ObjName: string; const Ini: TIniFile
  );
begin
  Ini.WriteInteger(ObjName, 'fbmSQLEditorForm.TreeView1.Width', TreeView1.Width);
end;

procedure TfbmSQLEditorForm.RestoreState(const ObjName: string;
  const Ini: TIniFile);
begin
  TreeView1.Width:=Ini.ReadInteger(ObjName, 'fbmSQLEditorForm.TreeView1.Width', TreeView1.Width);
end;

end.
{ TODO : Необходимо форму отображения плана запроса сделать в виде панельки с кнопкой закрытия }
