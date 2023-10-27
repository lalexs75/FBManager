{ Free DB Manager

  Copyright (C) 2005-2023 Lagunov Aleksey  alexs75 at yandex.ru

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

unit pgIndexEditorFrameUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, ActnList, Menus, ComCtrls, db, rxdbgrid, rxmemds,
  SQLEngineAbstractUnit, fbmSqlParserUnit, fdmAbstractEditorUnit, sqlObjects,
  PostgreSQLEngineUnit, fdbm_SynEditorUnit;

type

  { TpgIndexEditorPage }

  TpgIndexEditorPage = class(TEditorPage)
    ifAddAll: TAction;
    ifRemove: TAction;
    ifRemoveAll: TAction;
    ifAdd: TAction;
    lbFieldList1: TListBox;
    lbFieldList2: TListBox;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    npFirst: TAction;
    npLast: TAction;
    npNone: TAction;
    PageControl1: TPageControl;
    Panel3: TPanel;
    PopupMenu3: TPopupMenu;
    PopupMenu4: TPopupMenu;
    rxIndexFieldsNullsPos: TStringField;
    rxIndexFieldsSortOrder: TStringField;
    soAsc: TAction;
    soDesc: TAction;
    soNone: TAction;
    dsIndexFields: TDatasource;
    fldAdd: TAction;
    fldAddAll: TAction;
    fldRemove: TAction;
    fldRemoveAll: TAction;
    ActionList1: TActionList;
    CheckGroup1: TCheckGroup;
    cbTableSpaces: TComboBox;
    cbAcessMetod: TComboBox;
    cbTables: TComboBox;
    edtIndexName: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lbFieldList: TListBox;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    RxDBGrid1: TRxDBGrid;
    rxIndexFields: TRxMemoryData;
    rxIndexFieldsFieldName: TStringField;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    Splitter1: TSplitter;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure cbTablesChange(Sender: TObject);
    procedure fldAddAllExecute(Sender: TObject);
    procedure fldAddExecute(Sender: TObject);
    procedure fldRemoveAllExecute(Sender: TObject);
    procedure fldRemoveExecute(Sender: TObject);
    procedure ifAddAllExecute(Sender: TObject);
    procedure ifAddExecute(Sender: TObject);
    procedure ifRemoveAllExecute(Sender: TObject);
    procedure ifRemoveExecute(Sender: TObject);
    procedure lbFieldList1DblClick(Sender: TObject);
    procedure lbFieldList2DblClick(Sender: TObject);
    procedure lbFieldListDblClick(Sender: TObject);
    procedure npNoneExecute(Sender: TObject);
    procedure rxIndexFieldsAfterScroll(DataSet: TDataSet);
    procedure soNoneExecute(Sender: TObject);
  private
    FWhereFrame:Tfdbm_SynEditorFrame;
    procedure PrintPage;
    procedure RefreshObject;
    function TableName:string;
    procedure DoGenIndexName;
  public
    procedure Activate;override;
    function PageName:string;override;
    procedure UpdateEnvOptions;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean;override;
  end;

implementation
uses fbmStrConstUnit, fbmToolsUnit, pgTypes, SQLEngineCommonTypesUnit, pg_SqlParserUnit, rxboxprocs;

{$R *.lfm}

{ TpgIndexEditorPage }

procedure TpgIndexEditorPage.cbTablesChange(Sender: TObject);
var
  T:TPGTable;
begin
  lbFieldList.Clear;
  if (cbTables.ItemIndex>-1) and (cbTables.ItemIndex < cbTables.Items.Count) then
  begin
    T:=TPGTable(cbTables.Items.Objects[cbTables.ItemIndex]);
    if Assigned(T) then
    begin
      T.FillFieldList(lbFieldList.Items, ccoNoneCase, False);
      T.FillFieldList(lbFieldList1.Items, ccoNoneCase, False);
    end;
  end;

  if DBObject.State = sdboCreate then
    DoGenIndexName;
end;

procedure TpgIndexEditorPage.fldAddAllExecute(Sender: TObject);
begin
  while (lbFieldList.Items.Count>0) do
  begin
    lbFieldList.ItemIndex:=lbFieldList.Items.Count-1;
    fldAddExecute(nil);
  end;
end;

procedure TpgIndexEditorPage.fldAddExecute(Sender: TObject);
var
  S:string;
begin
  if (lbFieldList.ItemIndex>-1) and (lbFieldList.ItemIndex<lbFieldList.Items.Count) then
  begin
    S:=lbFieldList.Items[lbFieldList.ItemIndex];
    rxIndexFields.Append;
    rxIndexFieldsFieldName.AsString:=S;
    ///rxIndexFieldsSortOrder.AsString:=;
    rxIndexFields.Post;
    lbFieldList.Items.Delete(lbFieldList.ItemIndex);
    if lbFieldList.Items.Count>0 then
      lbFieldList.ItemIndex:=0;
  end;
end;

procedure TpgIndexEditorPage.fldRemoveAllExecute(Sender: TObject);
begin
  while (rxIndexFields.RecordCount>0) do
    fldRemoveExecute(nil);
end;

procedure TpgIndexEditorPage.fldRemoveExecute(Sender: TObject);
begin
  if rxIndexFields.RecordCount>0 then
  begin
    lbFieldList.ItemIndex:=lbFieldList.Items.Add(rxIndexFieldsFieldName.AsString);
    rxIndexFields.Delete;
  end;
end;

procedure TpgIndexEditorPage.ifAddAllExecute(Sender: TObject);
begin
  BoxMoveAllItems(lbFieldList1, lbFieldList2);
end;

procedure TpgIndexEditorPage.ifAddExecute(Sender: TObject);
begin
  BoxMoveSelectedItems(lbFieldList1, lbFieldList2);
end;

procedure TpgIndexEditorPage.ifRemoveAllExecute(Sender: TObject);
begin
  BoxMoveAllItems(lbFieldList2, lbFieldList1);
end;

procedure TpgIndexEditorPage.ifRemoveExecute(Sender: TObject);
begin
  BoxMoveSelectedItems(lbFieldList2, lbFieldList1);
end;

procedure TpgIndexEditorPage.lbFieldList1DblClick(Sender: TObject);
begin
  ifAdd.Execute;
end;

procedure TpgIndexEditorPage.lbFieldList2DblClick(Sender: TObject);
begin
  ifRemove.Execute;
end;

procedure TpgIndexEditorPage.lbFieldListDblClick(Sender: TObject);
begin
  fldAdd.Execute;
end;

procedure TpgIndexEditorPage.npNoneExecute(Sender: TObject);
begin
  if rxIndexFields.Active and (rxIndexFields.RecordCount>0) then
  begin
    rxIndexFields.Edit;
    rxIndexFieldsNullsPos.AsString:=IndexNullPosStr(TIndexNullPos((Sender as TComponent).Tag));
    rxIndexFields.Post;
  end;
end;

procedure TpgIndexEditorPage.rxIndexFieldsAfterScroll(DataSet: TDataSet);
begin
//  soNone.Checked:=;
end;

procedure TpgIndexEditorPage.soNoneExecute(Sender: TObject);
begin
  if rxIndexFields.Active and (rxIndexFields.RecordCount>0) then
  begin
    rxIndexFields.Edit;
    rxIndexFieldsSortOrder.AsString:=IndexSortOrderStr(TIndexSortOrder((Sender as TComponent).Tag));
    rxIndexFields.Post;
  end;
end;

procedure TpgIndexEditorPage.PrintPage;
begin

end;

procedure TpgIndexEditorPage.UpdateEnvOptions;
begin
  //inherited UpdateEnvOptions;
end;

procedure TpgIndexEditorPage.RefreshObject;
var
  PGIF: TIndexField;
  S: String;
  I: Integer;
begin
  rxIndexFields.CloseOpen;

  TSQLEnginePostgre(DBObject.OwnerDB).AccessMethodList(cbAcessMetod.Items);

  edtIndexName.Enabled:=DBObject.State = sdboCreate;

  if DBObject.State = sdboEdit then
  begin
    DBObject.RefreshObject;
    edtIndexName.Text:=DBObject.Caption;
    FWhereFrame.EditorText:=TPGIndex(DBObject).WhereExpression;
  end;

  cbTables.Enabled:=DBObject.State = sdboCreate;
  cbAcessMetod.Text:=TPGIndex(DBObject).AccessMetod;

  cbTables.Items.Clear;
  TPGIndex(DBObject).Schema.TablesRoot.FillListForNames(cbTables.Items, true);
  if Assigned(TPGIndex(DBObject).Schema.MatViews) then
    TPGIndex(DBObject).Schema.MatViews.FillListForNames(cbTables.Items, true);
  if Assigned(TPGIndex(DBObject).Table) then
    cbTables.Text:=TPGIndex(DBObject).Table.CaptionFullPatch;
  cbTablesChange(nil);

  cbTableSpaces.Items.Clear;
  TSQLEnginePostgre(TPGIndex(DBObject).OwnerDB).TableSpaceRoot.FillListForNames(cbTableSpaces.Items, true);
  if Assigned(TPGIndex(DBObject).PGTableSpace) then
    cbTableSpaces.Text:=TPGIndex(DBObject).PGTableSpace.Caption;

  CheckGroup1.Checked[0]:=TPGIndex(DBObject).IndexUnique;
  CheckGroup1.Checked[1]:=TPGIndex(DBObject).IndexCluster;

  Memo1.Text:=TPGIndex(DBObject).IndexExpression;

  if DBObject.State <> sdboCreate then
  begin
    for PGIF in TPGIndex(DBObject).IndexFields do
    begin
      rxIndexFields.Append;
      rxIndexFieldsFieldName.AsString:=PGIF.FieldName;
      rxIndexFieldsSortOrder.AsString:=IndexSortOrderStr(PGIF.SortOrder);
      rxIndexFieldsNullsPos.AsString:=IndexNullPosStr(PGIF.NullPos);
      rxIndexFields.Post;

      I:=lbFieldList.Items.IndexOf(PGIF.FieldName);
      if I>=0 then
        lbFieldList.Items.Delete(I);
    end;
    rxIndexFields.First;

    if TabSheet3.TabVisible then
    begin
      lbFieldList2.Items.Assign(TPGIndex(DBObject).IncludeFields);
      for S in lbFieldList2.Items do
      begin
        I:=lbFieldList1.Items.IndexOf(S);
        if I>=0 then
          lbFieldList1.Items.Delete(I);
      end;
    end;
  end;
end;

function TpgIndexEditorPage.TableName: string;
var
  P: TDBDataSetObject;
begin
  Result:='';
  if (cbTables.ItemIndex > -1) and (cbTables.ItemIndex < cbTables.Items.Count) then
  begin
    P:=TDBObject(cbTables.Items.Objects[cbTables.ItemIndex]) as TDBDataSetObject;
    if Assigned(P) then
      Result:=P.Caption;
  end;
end;

procedure TpgIndexEditorPage.DoGenIndexName;
var
  I: Integer;
  S1, S: String;
begin
  if DBObject.State = sdboEdit then exit;;
  S1:=TableName;
  if S1<>'' then
  begin
    I:=0;
    repeat
      inc(i);
      S:='idx_'+S1+'_'+IntToStr(i);
    until not Assigned(DBObject.OwnerRoot.ObjByName(S));
    edtIndexName.Text:=S;
  end;
end;

procedure TpgIndexEditorPage.Activate;
begin
  //RefreshObject;
end;

function TpgIndexEditorPage.PageName: string;
begin
  Result:=sIndexs;
end;

constructor TpgIndexEditorPage.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
var
  C: TRxColumn;
begin
  inherited CreatePage(TheOwner, ADBObject);
  PageControl1.ActivePageIndex:=0;

  FWhereFrame:=Tfdbm_SynEditorFrame.Create(Self);
  FWhereFrame.Parent:=TabSheet2;
  FWhereFrame.SQLEngine:=DBObject.OwnerDB;
  //FWhereFrame.OnGetFieldsList:=@OnGetFieldsList;
  FWhereFrame.Name:='edtWhenFrame';

  TabSheet3.TabVisible:=TSQLEnginePostgre(DBObject.OwnerDB).ServerVersion > pgVersion10_0;

  C:=RxDBGrid1.ColumnByFieldName('SortOrder');
  C.PickList.Clear;
  C.PickList.Add('');
  C.PickList.Add(IndexSortOrderStr(indAscending));
  C.PickList.Add(IndexSortOrderStr(indDescending));

  C:=RxDBGrid1.ColumnByFieldName('NullsPos');
  C.PickList.Clear;
  C.PickList.Add('');
  C.PickList.Add(IndexNullPosStr(inpFirst));
  C.PickList.Add(IndexNullPosStr(inpLast));

  RefreshObject;
end;

function TpgIndexEditorPage.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaCompile, epaRefresh, epaPrint];
end;

function TpgIndexEditorPage.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  Result:=true;
  case PageAction of
    epaRefresh:RefreshObject;
    epaPrint:PrintPage;
  else
    Result:=false;
  end;
end;

procedure TpgIndexEditorPage.Localize;
begin
  TabSheet1.Caption:=sFields;
  TabSheet2.Caption:=sPartialIndex;
  TabSheet3.Caption:=sIncludeFields;

  Label1.Caption:=sIndexName;
  Label2.Caption:=sTableSpace;
  Label3.Caption:=sAccessMetod;
  Label4.Caption:=sForTable;
  Label5.Caption:=sFillfactor;
  Label6.Caption:=sConditionForPartialIndex;

  fldAdd.Caption:=sAddField;
  fldAddAll.Caption:=sAddAllFields;
  fldRemove.Caption:=sRemoveField;
  fldRemoveAll.Caption:=sRemoveAllFields;

  fldAdd.Hint:=sAddField;
  fldAddAll.Hint:=sAddAllFields;
  fldRemove.Hint:=sRemoveField;
  fldRemoveAll.Hint:=sRemoveAllFields;

  ifAdd.Caption:=sAddField;
  ifAddAll.Caption:=sAddAllFields;
  ifRemove.Caption:=sRemoveField;
  ifRemoveAll.Caption:=sRemoveAllFields;

  ifAdd.Hint:=sAddField;
  ifAddAll.Hint:=sAddAllFields;
  ifRemove.Hint:=sRemoveField;
  ifRemoveAll.Hint:=sRemoveAllFields;

  CheckGroup1.Items[0]:=sUnique;
  CheckGroup1.Items[1]:=sSeparatedPpages;
  CheckGroup1.Items[2]:=sDontLockOnCreation;

  RxDBGrid1.ColumnByFieldName('FieldName').Title.Caption:=sFieldName;
  RxDBGrid1.ColumnByFieldName('SortOrder').Title.Caption:=sSortOrder;
  RxDBGrid1.ColumnByFieldName('NullsPos').Title.Caption:=sNullsPos;
end;

function TpgIndexEditorPage.SetupSQLObject(ASQLObject: TSQLCommandDDL): boolean;
var
  F: TSQLParserField;
  S: String;
begin
  Result:=false;
  if ASQLObject is TPGSQLCreateIndex then
  begin
    ASQLObject.Name:=edtIndexName.Text;
    TPGSQLCreateIndex(ASQLObject).SchemaName:=TPGIndex(DBObject).SchemaName;
    TPGSQLCreateIndex(ASQLObject).TableName:=TableName;
    TPGSQLCreateIndex(ASQLObject).Unique:=CheckGroup1.Checked[0];
//    TPGSQLCreateIndex(ASQLObject).Cloncurrently:=CheckGroup1.Checked[2];
    TPGSQLCreateIndex(ASQLObject).Concurrently:=CheckGroup1.Checked[2];
//    CheckGroup1.Checked[1]:=TPGIndex(DBObject).IndexCluster;
    TPGSQLCreateIndex(ASQLObject).IndexMethod:=cbAcessMetod.Text;
    TPGSQLCreateIndex(ASQLObject).WhereCondition:=FWhereFrame.EditorText;

    rxIndexFields.First;
    while not rxIndexFields.EOF do
    begin
      F:=TPGSQLCreateIndex(ASQLObject).Fields.AddParam(rxIndexFieldsFieldName.AsString);
      F.IndexOptions.SortOrder:=StrToIndexSortOrder(rxIndexFieldsSortOrder.AsString);
      F.IndexOptions.IndexNullPos:=StrToIndexNullPos(rxIndexFieldsNullsPos.AsString);
      rxIndexFields.Next;
    end;
    rxIndexFields.First;

    if TabSheet3.TabVisible then
      for S in lbFieldList2.Items do
        TPGSQLCreateIndex(ASQLObject).IncludeFields.AddParam(S);
    Result:=true;
  end;
end;

end.

