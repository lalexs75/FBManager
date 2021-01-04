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

unit dsDesignerUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, db, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, Menus, ExtCtrls, StdCtrls, CheckLst, dsObjectsUnit, Buttons,
  ComCtrls, ActnList, DbCtrls, SynCompletion, SynEdit, SynHighlighterSQL,
  rxtoolbar, rxdbgrid, rxmemds, RxDBGridFooterTools, RxDBGridExportPdf,
  RxIniPropStorage, RxDBGridExportSpreadSheet, RxDBGridPrintGrid,
  fdbm_SynEditorUnit, SQLEngineCommonTypesUnit, SQLEngineAbstractUnit,
  LMessages, sqlObjects, fbmToolsUnit, ibmanagertypesunit;

type

  { TSQLBuilderForm }

  TSQLBuilderForm = class(TForm)
    actClear: TAction;
    actGoToSQLEditor: TAction;
    PopupMenu2: TPopupMenu;
    RxDBGridExportPDF1: TRxDBGridExportPDF;
    RxDBGridExportSpreadSheet1: TRxDBGridExportSpreadSheet;
    RxDBGridFooterTools1: TRxDBGridFooterTools;
    RxDBGridPrint1: TRxDBGridPrint;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    statFunct: TAction;
    statFilter: TAction;
    wDel: TAction;
    wAdd: TAction;
    actSchemeLoad: TAction;
    actSchemeSave: TAction;
    actRun: TAction;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    dsWhere: TDataSource;
    dsSortOrder: TDatasource;
    dsFields: TDatasource;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Panel3: TPanel;
    RxDBGrid3: TRxDBGrid;
    RxDBGrid4: TRxDBGrid;
    RxDBGrid5: TRxDBGrid;
    rxFieldsAgregateFunction: TLongintField;
    rxFieldsFieldName: TStringField;
    rxFieldsSrcField: TStringField;
    RxIniPropStorage1: TRxIniPropStorage;
    rxWhere: TRxMemoryData;
    rxSortOrder: TRxMemoryData;
    rxFields: TRxMemoryData;
    rxSortOrderSortField: TStringField;
    rxSortOrderSortOrder: TLongintField;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    dsHistory: TDatasource;
    dsResult: TDatasource;
    DBNavigator1: TDBNavigator;
    Label2: TLabel;
    rxWhereCONNECTOR: TStringField;
    rxWhereFIELD1_NAME: TStringField;
    rxWhereFIELD2_NAME: TStringField;
    rxWhereWHERE_COND: TStringField;
    SortList: TListBox;
    Panel2: TPanel;
    RxDBGrid1: TRxDBGrid;
    RxDBGrid2: TRxDBGrid;
    RxMemoryData1: TRxMemoryData;
    ActionList1: TActionList;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Label1: TLabel;
    ListBox3: TListBox;
    MenuItem1: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    PageControl2: TPageControl;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    SaveDialog1: TSaveDialog;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    tabSQL: TTabSheet;
    tabResult: TTabSheet;
    TabSheet7: TTabSheet;
    ToolPanel1: TToolPanel;
    procedure actClearExecute(Sender: TObject);
    procedure actGoToSQLEditorExecute(Sender: TObject);
    procedure actRunExecute(Sender: TObject);
    procedure actSchemeLoadExecute(Sender: TObject);
    procedure actSchemeSaveExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PageControl2PageChanged(Sender: TObject);
    procedure RxDBGrid1DblClick(Sender: TObject);
    procedure statFilterExecute(Sender: TObject);
    procedure statFunctExecute(Sender: TObject);
    procedure wAddExecute(Sender: TObject);
    procedure wDelExecute(Sender: TObject);
  private
    QueryControl:TSQLQueryControl;
    DrawPanel:TDrawPanel;
    EditorFrame:Tfdbm_SynEditorFrame;
    FOwnerRec:TDataBaseRecord;
    procedure Localize;
    procedure GenTextClick(Sender: TObject);
    procedure UpdateSortFields;
    procedure UpdateSelectFields;
    procedure OpenFile(const AFileName:string);
    procedure SaveFile(const AFileName:string);
    procedure ChangeVisualParams;
    procedure LMEditorChangeParams(var message: TLMNoParams); message LM_EDITOR_CHANGE_PARMAS;
    procedure SaveState;
    procedure LoadState;
    procedure UpdateWhereFields;
    procedure DataSetAfterScrollRecord(Sender: TDataSet);
  public
    procedure GenerateSql;
  end;

var
  SQLBuilderForm: TSQLBuilderForm = nil;

implementation
uses IBManDataInspectorUnit, {DOM, XMLWrite, XMLRead,} fbmStrConstUnit,
  fbmSqlParserUnit, fbmSQLEditor_ShowMemoUnit, LCLType;

{$R *.lfm}

{ TSQLBuilderForm }

procedure TSQLBuilderForm.FormCreate(Sender: TObject);
var
  i:integer;
begin
  Localize;
  PageControl2.ActivePageIndex:=0;

  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=tabSQL;
//  EditorFrame.OnGetFieldsList:=@EditorFrameGetFieldsList;


  DrawPanel:=TDrawPanel.Create(Self);
  DrawPanel.Parent:=TabSheet4;
  DrawPanel.Align:=alClient;
  DrawPanel.GenText:=@GenTextClick;
  rxSortOrder.Open;
  rxFields.Open;
  rxWhere.Open;

  I:=fbManDataInpectorForm.DBList.FillDataBaseList(ComboBox1.Items);
  if i>-1 then
  begin
    ComboBox1.ItemIndex:=i;
    ComboBox1Change(nil);
  end;

  ChangeVisualParams;

  ListBox3.Width:=0;
end;

procedure TSQLBuilderForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssCtrl in Shift then
  begin
    if QueryControl.DataSet.Active and (PageControl1.ActivePage = tabResult) then
    begin
      if Key = VK_ADD then
      begin
        RxDBGrid1.AutoFillColumns:=false;
        RxDBGrid1.OptimizeColumnsWidthAll;
      end
      else
      if Key = VK_SUBTRACT then
        RxDBGrid1.AutoFillColumns:=true;
    end;
  end;
end;

procedure TSQLBuilderForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  SQLBuilderForm:= nil;
  SaveState;

  if Assigned(QueryControl) then
    FreeAndNil(QueryControl);

  CloseAction:=caFree;
end;

procedure TSQLBuilderForm.ComboBox1Change(Sender: TObject);
var
  SQLE:TSQLEngineAbstract;
  i:integer;
begin
  dsResult.DataSet:=nil;
  dsHistory.DataSet:=nil;
  if Assigned(QueryControl) then
    FreeAndNil(QueryControl);
  FOwnerRec:=nil;

  SaveState;

  SQLE:=TSQLEngineAbstract(ComboBox1.Items.Objects[ComboBox1.ItemIndex]);
  FOwnerRec:=fbManDataInpectorForm.DBBySQLEngine(SQLE);
  if Assigned(SQLE) then
  begin
    ListBox3.Items.Clear;
    SQLE.FillListForNames(ListBox3.Items, [okPartitionTable, okTable, okView, okMaterializedView, okStoredProc]);
    for i:=0 to ListBox3.Items.Count - 1 do
      ListBox3.Items[i]:= TDBObject(ListBox3.Items.Objects[i]).CaptionFullPatch;

    EditorFrame.SQLEngine:=SQLE;
    DrawPanel.SQLEngine:=SQLE;
    QueryControl:=SQLE.GetQueryControl;
    QueryControl.DataSet.AfterScroll:=@DataSetAfterScrollRecord;
    dsResult.DataSet:=QueryControl.DataSet;
    dsHistory.DataSet:=FOwnerRec.SQLEditorHistory;
    LoadState;
  end;
  GenerateSql;
end;

procedure TSQLBuilderForm.actRunExecute(Sender: TObject);
var
  S:string;
  FStartTime, FEndTime: TDateTime;
begin
  if not Assigned(QueryControl) then exit;
  if PageControl2.ActivePage <> tabSQL then
    GenerateSql;

  FStartTime:=Now;

  QueryControl.Active:=false;

  S:=EditorFrame.TextEditor.SelText;
  if S = '' then
    S:=EditorFrame.TextEditor.Text;

  QueryControl.QuerySQL:=S;

  QueryControl.Active:=true;
  PageControl2.ActivePage := tabResult;
  //
{  if SQLCommand.PlanEnabled then
    ShowPlanInfo(QueryControl.QueryPlan);
  if seFetchAll then
    QueryControl.FetchAll;}
  FEndTime:=Now;
  FOwnerRec.ExecSQLEditor(S, EditorFrame.EditorText, FEndTime - FStartTime, nil, Caption);

end;

procedure TSQLBuilderForm.actClearExecute(Sender: TObject);
begin
  rxSortOrder.EmptyTable;
  DrawPanel.Clear;
end;

procedure TSQLBuilderForm.actGoToSQLEditorExecute(Sender: TObject);
begin
  //
end;

procedure TSQLBuilderForm.actSchemeLoadExecute(Sender: TObject);
begin
  if OpenDialog1.Execute then
    OpenFile(OpenDialog1.FileName);
end;

procedure TSQLBuilderForm.actSchemeSaveExecute(Sender: TObject);
begin
  if SaveDialog1.Execute then
    SaveFile(SaveDialog1.FileName);
end;

procedure TSQLBuilderForm.Button1Click(Sender: TObject);
var
  S:string;
begin
  if (SortList.Items.Count>0) and (SortList.ItemIndex>=0) and (SortList.ItemIndex < SortList.Items.Count) then
  begin
    S:=SortList.Items[SortList.ItemIndex];
    SortList.Items.Delete(SortList.ItemIndex);
    rxSortOrder.AppendRecord([S, 0]);
    if SortList.Items.Count > 0 then
      SortList.ItemIndex:=0;
  end;
end;

procedure TSQLBuilderForm.Button2Click(Sender: TObject);
begin
  if rxSortOrder.RecordCount>0 then
  begin
    SortList.Items.Add(rxSortOrderSortField.AsString);
    rxSortOrder.Delete;
  end;
end;


procedure TSQLBuilderForm.Button5Click(Sender: TObject);
begin
  if rxSortOrder.RecordCount>0 then
  begin
    rxSortOrder.Edit;
    rxSortOrderSortOrder.AsInteger:=1 - rxSortOrderSortOrder.AsInteger;
    rxSortOrder.Post;
  end;
end;

procedure TSQLBuilderForm.PageControl2PageChanged(Sender: TObject);
begin
  if PageControl2.ActivePage = tabSQL then
      GenerateSql;
end;

procedure TSQLBuilderForm.RxDBGrid1DblClick(Sender: TObject);
begin
  if QueryControl.Active and (QueryControl.DataSet.RecordCount>0) and (RxDBGrid1.SelectedColumn.Field.DataType in [ftMemo] ) then
  begin
    fbmSQLEditor_ShowMemoForm:=TfbmSQLEditor_ShowMemoForm.Create(Application);
    fbmSQLEditor_ShowMemoForm.Datasource1.DataSet:=RxDBGrid1.DataSource.DataSet;
    fbmSQLEditor_ShowMemoForm.DBMemo1.DataField:=RxDBGrid1.SelectedColumn.Field.FieldName;
    fbmSQLEditor_ShowMemoForm.ShowModal;
    fbmSQLEditor_ShowMemoForm.Free;
  end;
end;

procedure TSQLBuilderForm.statFilterExecute(Sender: TObject);
begin
  if rdgFilter in RxDBGrid1.OptionsRx then
    RxDBGrid1.OptionsRx:=RxDBGrid1.OptionsRx - [rdgFilter]
  else
    RxDBGrid1.OptionsRx:=RxDBGrid1.OptionsRx + [rdgFilter];
end;

procedure TSQLBuilderForm.statFunctExecute(Sender: TObject);
begin
  RxDBGridFooterTools1.Execute;
end;

procedure TSQLBuilderForm.wAddExecute(Sender: TObject);
begin
  rxWhere.Append;
end;

procedure TSQLBuilderForm.wDelExecute(Sender: TObject);
begin
  rxWhere.Delete;
end;

procedure TSQLBuilderForm.Localize;
begin
  Caption:=sSQLBuilder;
  Label1.Caption:=sDatabase;
  actRun.Caption:=sRun;
  actSchemeSave.Caption:=sSave;
  actSchemeLoad.Caption:=sOpen;
  actClear.Caption:=sClear;
  actGoToSQLEditor.Caption:=sTextToSQLEditor;

  TabSheet1.Caption:=sCriteria;
  TabSheet2.Caption:=sSelections;
  TabSheet3.Caption:=sSorting;
  TabSheet4.Caption:=sBuilder;
  tabSQL.Caption:=sSQL;
  tabResult.Caption:=sResult;
  TabSheet7.Caption:=sHistory;

  statFilter.Caption:=sFilterInTable;
  statFilter.Hint:=sFilterInTableHint;
  statFunct.Caption:=sSummaryLine;
  statFunct.Hint:=sSummaryLineHint;
end;

procedure TSQLBuilderForm.GenTextClick(Sender: TObject);
begin
  UpdateSelectFields;
  UpdateSortFields;
  UpdateWhereFields;
end;

procedure TSQLBuilderForm.UpdateSortFields;
var
  L: TStringList;
  P: TQBObject;
  j, i: Integer;
  S: String;
begin
  SortList.Items.BeginUpdate;
  L:=TStringList.Create;
  for P in DrawPanel.ObjectList do
  begin
    for j:=0 to P.List.Items.Count - 1 do
    if P.List.Checked[j] then
    begin
      S:=P.ObjName+'.'+P.List.Items[j];
      L.Add(S);
      if SortList.Items.IndexOf(S)<0 then
        if not rxSortOrder.Locate('SortField', S, []) then
          SortList.Items.Add(S);
    end;
  end;

  for i:=SortList.Items.Count-1 downto 0 do
  begin
    if L.IndexOf(SortList.Items[i])<0 then
        SortList.Items.Delete(i);
  end;
  L.Free;
  SortList.Items.EndUpdate;
end;

procedure TSQLBuilderForm.UpdateSelectFields;
var
  S:string;
  P:TQBObject;
  L:TStringList;
  j: Integer;
begin
  rxFields.DisableControls;
  L:=TStringList.Create;


  for P in DrawPanel.ObjectList do
  begin
    for j:=0 to P.List.Items.Count - 1 do
    if P.List.Checked[j] then
    begin
      S:=P.ObjName+'.'+P.List.Items[j];
      L.Add(S);
      if not rxFields.Locate('SrcField', S, []) then
      begin
        rxFields.Append;
        rxFieldsSrcField.AsString:=S;
        rxFieldsFieldName.AsString:=P.List.Items[j];
        rxFields.Post;
      end;
    end;
  end;

  rxFields.First;
  while not rxFields.EOF do
  begin
    if L.IndexOf(rxFieldsSrcField.AsString)<0 then
      rxFields.Delete
    else
      rxFields.Next;

  end;
  L.Free;
  rxFields.EnableControls;
end;

procedure TSQLBuilderForm.OpenFile(const AFileName: string);
(*var
  Doc:TXMLDocument;
  Root:TDOMElement;

procedure ReadSortList;
var
  Node, Node1:TDOMElement;
  i, Cnt:integer;
begin
  rxSortOrder.EmptyTable;
  Node:=TDOMElement(Root.FindNode('SortOrders'));
  if Assigned(Node) then
  begin
    Cnt:=StrToIntDef(Node.GetAttribute('Count'), 0);
    for i:=0 to Cnt-1 do
    begin
      Node1:=TDOMElement(Node.FindNode('SortItem_'+IntToStr(i)));
      if Assigned(Node1) then
      begin
        rxSortOrder.Append;
        rxSortOrderSortField.AsString:=Node1.GetAttribute('FieldName');
        rxSortOrderSortOrder.AsInteger:=StrToIntDef(Node1.GetAttribute('SortOrder'), 0);
        rxSortOrder.Post;
      end;
    end;
  end;
end;

procedure LoadWhere;
var
  Node:TDOMElement;
  Cnt: LongInt;
  i: Integer;
  Node1: TDOMElement;
begin
  rxWhere.EmptyTable;
  Node:=TDOMElement(Root.FindNode('Where'));
  if Assigned(Node) then
  begin
    Cnt:=StrToIntDef(Node.GetAttribute('Count'), 0);
    for i:=0 to Cnt-1 do
    begin
      Node1:=Doc.CreateElement('WhereItem_'+IntToStr(rxSortOrder.RecNo-1));
      if Assigned(Node1) then
      begin
        rxWhere.Append;
        rxWhereFIELD1_NAME.AsString:=Node1.GetAttribute('Field1');
        rxWhereFIELD2_NAME.AsString:=Node1.GetAttribute('Field2');
        rxWhereWHERE_COND.AsString:=Node1.GetAttribute('WhereCond');
        rxWhereCONNECTOR.AsString:=Node1.GetAttribute('Connector');
        rxWhere.Post;
      end;
    end;
  end;
end;
*)
begin
(*  if FileExists(AFileName) then
  begin
    ReadXMLFile(Doc, AFileName);
    try
      Root:=Doc.FindNode(sDesigner) as TDOMElement;
      DrawPanel.OpenFile(Doc);
      ReadSortList;
      LoadWhere;
    finally
      Doc.Free;
    end;
  end;
  GenTextClick(nil); *)
end;

procedure TSQLBuilderForm.SaveFile(const AFileName: string);
(*var
  Doc:TXMLDocument;
  Root:TDOMElement;

procedure WriteSortList;
var
  Node, Node1:TDOMElement;
begin
  Node:=Doc.CreateElement('SortOrders');
  Root.AppendChild(Node);
  Node.SetAttribute('Count', IntToStr(rxSortOrder.RecordCount));
  rxSortOrder.First;
  while not rxSortOrder.EOF do
  begin
    Node1:=Doc.CreateElement('SortItem_'+IntToStr(rxSortOrder.RecNo-1));
    Node.AppendChild(Node1);
    Node1.SetAttribute('FieldName', rxSortOrderSortField.AsString);
    Node1.SetAttribute('SortOrder', rxSortOrderSortOrder.AsString);
    rxSortOrder.Next;
  end;
end;

procedure WriteWhere;
var
  Node, Node1:TDOMElement;
begin
  Node:=Doc.CreateElement('Where');
  Root.AppendChild(Node);
  Node.SetAttribute('Count', IntToStr(rxWhere.RecordCount));
  rxWhere.First;
  while not rxWhere.EOF do
  begin
    Node1:=Doc.CreateElement('WhereItem_'+IntToStr(rxWhere.RecNo-1));
    Node.AppendChild(Node1);
    Node1.SetAttribute('Field1', rxWhereFIELD1_NAME.AsString);
    Node1.SetAttribute('Field2', rxWhereFIELD2_NAME.AsString);
    Node1.SetAttribute('WhereCond', rxWhereWHERE_COND.AsString);
    Node1.SetAttribute('Connector', rxWhereCONNECTOR.AsString);
    rxWhere.Next;
  end;
end;
*)
begin
(*  Doc := TXMLDocument.Create;
  try
    Root:=Doc.CreateElement(sDesigner);
    Doc.AppendChild(Root);
    DrawPanel.SaveFile(Doc);
    WriteSortList;
    WriteWhere;
    WriteXML(Doc, AFileName);
  finally
    Doc.Free;
  end; *)
end;

procedure TSQLBuilderForm.ChangeVisualParams;
begin
  SetRxDBGridOptions(RxDBGrid1);
  SetRxDBGridOptions(RxDBGrid2);
  EditorFrame.ChangeVisualParams;
end;

procedure TSQLBuilderForm.LMEditorChangeParams(var message: TLMNoParams);
begin
  inherited;
  ChangeVisualParams;
end;

procedure TSQLBuilderForm.SaveState;
var
  aFileName:string;
  P:TDataBaseRecord;
begin
  if not Assigned(DrawPanel.SQLEngine) then
    exit;
{  P:=TDataBaseRecord(DrawPanel.SQLE.InspectorRecord);
  aFileName:=P.SavedHistDir + 'sql_builder.scm';
  SaveFile(aFileName);}
//  raise Exception.Create('TSQLBuilderForm.SaveState;');
end;

procedure TSQLBuilderForm.LoadState;
var
  aFileName:string;
  P:TDataBaseRecord;
begin
{  if not Assigned(DrawPanel.SQLE) then exit;
  P:=TDataBaseRecord(DrawPanel.SQLE.InspectorRecord);
  aFileName:=P.SavedHistDir + 'sql_builder.scm';
  if FileExists(aFileName) then
    OpenFile(aFileName)
  else
    DrawPanel.Clear;}
//  raise Exception.Create('TSQLBuilderForm.LoadState;');
end;

procedure TSQLBuilderForm.UpdateWhereFields;
var
  i: Integer;
  P: TQBObject;
  St1: TStringList;
  St2: TStringList;
  j: Integer;
begin
  St1:=TStringList.Create;
  St2:=TStringList.Create;
  try
    for i:=0 to DrawPanel.ObjectList.Count - 1 do
    begin
      P:=DrawPanel.ObjectList[i];
      if Assigned(P) and Assigned(P.DBObject) then
      begin
        P.DBObject.FillFieldList(St1, ccoNoneCase, true);

        for j:=0 to St1.Count-1 do
          St2.Add(St1[j]);
      end;
    end;
    RxDBGrid5.ColumnByFieldName('FIELD1_NAME').PickList.Assign(St2);
    RxDBGrid5.ColumnByFieldName('FIELD2_NAME').PickList.Assign(St2);
  finally
    St1.Free;
    St2.Free;
  end;
end;

procedure TSQLBuilderForm.DataSetAfterScrollRecord(Sender: TDataSet);
begin
  Label2.Caption:=Format(sRecordFetched, [QueryControl.DataSet.RecordCount]);
end;

procedure TSQLBuilderForm.GenerateSql;
var
  L:TQBObjectLink;
  FSQLCmd: TSQLCommandSelect;

procedure DoFillFields;
var
  BS: TBookMark;
  F: TSQLParserField;
begin
  rxFields.DisableControls;
  BS:=rxFields.Bookmark;
  rxFields.First;
  while not rxFields.EOF do
  begin
    F:=FSQLCmd.Fields.AddParam(rxFieldsSrcField.AsString);
    F.RealName:=rxFieldsFieldName.AsString;
    rxFields.Next;
  end;
  rxFields.Bookmark:=BS;
  rxFields.EnableControls;
end;

procedure DoFillTables;
var
  T: TTableItem;
  FTblLst: TStringList;
  P: TQBObject;
begin
  FTblLst:=TStringList.Create;
  FTblLst.Sorted:=true;

  for P in DrawPanel.ObjectList do
    FTblLst.Add(P.ObjCaption);

  //first step - add tables without links
  for P in DrawPanel.ObjectList do
    if P.Links.Count = 0 then
    begin
      T:=FSQLCmd.Tables.Add(P.ObjName);
      if P.ObjCaption <> P.ObjName then
        T.TableAlias:=P.ObjCaption;
      FTblLst.Delete(FTblLst.IndexOf(P.ObjCaption));
    end;

  for P in DrawPanel.ObjectList do
    if FTblLst.IndexOf(P.ObjCaption) >= 0 then
    begin
      T:=FSQLCmd.Tables.Add(P.ObjName);
      if P.ObjCaption <> P.ObjName then
        T.TableAlias:=P.ObjCaption;


      for L in P.Links do
        if L.Src = P then
        begin
          if L.LinkType = ltEq then
            T.JoinType:=jtInner
          else
            T.JoinType:=jtLeft;

          if T.JoinExpression <> '' then
            T.JoinExpression:=T.JoinExpression + ' and ';
          T.JoinExpression:=T.JoinExpression + '(' + L.Src.ObjCaption + '.'+L.SrcField + ' = '+ L.Dst.ObjCaption+'.'+L.DstField+')';
        end;
      FTblLst.Delete(FTblLst.IndexOf(P.ObjCaption));
    end;

  FTblLst.Free;
end;

procedure DoFillWhere;
var
  SWhere, SW: String;
begin
  SWhere:='';
  if rxWhere.RecordCount > 0 then
  begin
    SW:='';
    rxWhere.First;
    while not rxWhere.EOF do
    begin
      SW:=SW + '    ' + rxWhereFIELD1_NAME.AsString + ' ' + rxWhereWHERE_COND.AsString + ' ' + rxWhereFIELD2_NAME.AsString;
      if rxWhere.RecNo < rxWhere.RecordCount then
        Sw := Sw + LineEnding + '  ' + rxWhereCONNECTOR.AsString + ' '+LineEnding;
      rxWhere.Next;
    end;
    rxWhere.First;
    SWhere:=SWhere + SW;
  end;
  if SWhere <> '' then
  FSQLCmd.WhereExpression:=LineEnding + SWhere;
end;

procedure DoFillSortOrder;
var
  F: TSQLParserField;
begin
  rxSortOrder.First;
  while not rxSortOrder.EOF do
  begin
    F:=FSQLCmd.OrderByFields.AddParam(rxSortOrderSortField.AsString);
    if rxSortOrderSortOrder.AsInteger = 1 then
      F.IndexOptions.SortOrder:=indDescending;
    rxSortOrder.Next;
  end;
  rxSortOrder.First;
end;

begin
  FSQLCmd:=TSQLCommandSelect.Create(nil);
  try
    DoFillTables;
    DoFillFields;
    DoFillWhere;
    DoFillSortOrder;

    EditorFrame.EditorText:=FSQLCmd.AsSQL;
  finally
    FSQLCmd.Free;
  end;
end;


end.

