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

unit fdbmTableEditorUniqueUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ActnList,
  Menus, db, rxdbgrid, rxmemds, RxDBGridPrintGrid, LR_PGrid, sqlObjects,
  fdmAbstractEditorUnit, SQLEngineAbstractUnit, fbmSqlParserUnit, IniFiles,
  DBGrids;

type

  { TfdbmTableEditorUniqueFrame }

  TfdbmTableEditorUniqueFrame = class(TEditorPage)
    actDropUNQ: TAction;
    ActionList1: TActionList;
    actNewUNQ: TAction;
    actPrintList: TAction;
    actRefresh: TAction;
    dsUnqList: TDatasource;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    PopupMenu1: TPopupMenu;
    RxDBGrid1: TRxDBGrid;
    RxDBGridPrint1: TRxDBGridPrint;
    rxUnqList: TRxMemoryData;
    rxUnqListDescription: TStringField;
    rxUnqListField: TStringField;
    rxUnqListIndexName: TStringField;
    rxUnqListIndexSort: TBooleanField;
    rxUnqListName: TStringField;
    procedure actDropUNQExecute(Sender: TObject);
    procedure actNewUNQExecute(Sender: TObject);
    procedure actPrintListExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure rxUnqListAfterOpen(DataSet: TDataSet);
  private
    procedure NewUNQ;
    procedure DropUNQ;
    procedure RefreshUNQList;
    procedure UpdateActions;
  public
    procedure Localize;override;
    function PageName:string;override;
    procedure Activate;override;
    function DoMetod(PageAction: TEditorPageAction): boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    procedure SaveState(const SectionName:string; const Ini:TIniFile);override;
    procedure RestoreState(const SectionName:string; const Ini:TIniFile);override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses fbmStrConstUnit, SQLEngineCommonTypesUnit,
  ibmanagertableeditorPkunit, fbmToolsUnit;

{$R *.lfm}

{ TfdbmTableEditorUniqueFrame }

procedure TfdbmTableEditorUniqueFrame.actRefreshExecute(Sender: TObject);
begin
  RefreshUNQList;
end;

procedure TfdbmTableEditorUniqueFrame.rxUnqListAfterOpen(DataSet: TDataSet);
begin
  UpdateActions;
end;

procedure TfdbmTableEditorUniqueFrame.actPrintListExecute(Sender: TObject);
begin
  RxDBGridPrint1.PreviewReport;
end;

procedure TfdbmTableEditorUniqueFrame.actDropUNQExecute(Sender: TObject);
begin
  DropUNQ;
end;

procedure TfdbmTableEditorUniqueFrame.actNewUNQExecute(Sender: TObject);
begin
  NewUNQ;
end;

procedure TfdbmTableEditorUniqueFrame.NewUNQ;
var
  P: TSQLCommandDDL;
  OP: TAlterTableOperator;
  C: TSQLConstraintItem;
begin
  fbmTableEditorPkForm:=TfbmTableEditorPkForm.CreateUNQEditForm(TDBTableObject(DBObject));
  if fbmTableEditorPkForm.ShowModal= mrOk then
  begin
    if DBObject.State <> sdboCreate then
    begin
      P:=DBObject.CreateSQLObject;
      OP:=TSQLAlterTable(P).AddOperator(ataAddTableConstraint);
      C:=OP.Constraints.Add(ctUnique, fbmTableEditorPkForm.PKName.Text);
      C.ConstraintFields.AddParam(fbmTableEditorPkForm.GetFieldNames);
      C.IndexName:=fbmTableEditorPkForm.EditIndexName.Text;
      C.Description:=TrimRight(fbmTableEditorPkForm.Memo1.Text);
      if DBObject.CompileSQLObject(P, [sepShowCompForm]) then
        RefreshUNQList;
      P.Free;
    end
    else
    begin
      rxUnqList.Append;
      rxUnqListName.AsString:=fbmTableEditorPkForm.PKName.Text;
      rxUnqListField.AsString:=fbmTableEditorPkForm.GetFieldNames;
      rxUnqListIndexName.AsString:=fbmTableEditorPkForm.EditIndexName.Text;
      rxUnqListDescription.AsString:=TrimRight(fbmTableEditorPkForm.Memo1.Text);
      //rxUnqListIndexSort.AsBoolean:=P.Index.Descending;
      rxUnqList.Post;
    end;
  end;
  fbmTableEditorPkForm.Free;
end;

procedure TfdbmTableEditorUniqueFrame.DropUNQ;
var
  P: TSQLCommandDDL;
  OP: TAlterTableOperator;
begin
  if DBObject.State <> sdboCreate then
  begin
    P:=DBObject.CreateSQLObject;
    OP:=TSQLAlterTable(P).AddOperator(ataDropConstraint);
    OP.Constraints.Add(ctNone, rxUnqListName.AsString);
    if DBObject.CompileSQLObject(P, [sepShowCompForm]) then
      RefreshUNQList;
    P.Free;
  end
  else
  if QuestionBox(sDropUniqueConstraint+ '?') then
    rxUnqList.Delete;
end;

procedure TfdbmTableEditorUniqueFrame.RefreshUNQList;
var
  i:integer;
  P:TUniqueRecord;
begin
  TDBTableObject(DBObject).RefreshConstraintUnique;
  rxUnqList.CloseOpen;
  rxUnqList.DisableControls;
  for i:=0 to TDBTableObject(DBObject).ConstraintCount-1 do
  begin
    P:=TUniqueRecord(TDBTableObject(DBObject).Constraint[i]);
    if P.ConstraintType = ctUnique then
    begin
      rxUnqList.Append;
      rxUnqListName.AsString:=P.Name;
      rxUnqListIndexName.AsString:=P.IndexName;
      if Assigned(P.Index) then
      begin
        rxUnqListField.AsString:=P.Index.IndexField;
        rxUnqListIndexSort.AsBoolean:=P.Index.Descending;
      end
      else
        rxUnqListField.AsString:=P.FieldList;
      rxUnqListDescription.AsString:=P.Description;
      rxUnqList.Post;
    end;
  end;
  rxUnqList.First;
  rxUnqList.EnableControls;
end;

procedure TfdbmTableEditorUniqueFrame.UpdateActions;
begin
  actNewUNQ.Enabled:=(utAddUNQ in TDBTableObject(DBObject).UITableOptions);
  actDropUNQ.Enabled:=(utDropUNQ in TDBTableObject(DBObject).UITableOptions) and rxUnqList.Active and (rxUnqList.RecordCount > 0);
end;

procedure TfdbmTableEditorUniqueFrame.Localize;
begin
  inherited Localize;
  actNewUNQ.Caption:=sNewUniqueConstraint;
  actDropUNQ.Caption:=sDropUniqueConstraint;
  actPrintList.Caption:=sPrintUNQlist;
  actRefresh.Caption:=sRefresh;

  RxDBGrid1.ColumnByFieldName('Name').Title.Caption:=sName;
  RxDBGrid1.ColumnByFieldName('Field').Title.Caption:=sFieldName;
  RxDBGrid1.ColumnByFieldName('IndexName').Title.Caption:=sIndexName;
  RxDBGrid1.ColumnByFieldName('IndexSort').Title.Caption:=sIndexSort;
  RxDBGrid1.ColumnByFieldName('Description').Title.Caption:=sDescription;
end;

function TfdbmTableEditorUniqueFrame.PageName: string;
begin
  Result:=sUnique;
end;

procedure TfdbmTableEditorUniqueFrame.Activate;
begin
  if DBObject.State <> sdboCreate then
    RefreshUNQList;
end;

function TfdbmTableEditorUniqueFrame.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaRefresh:RefreshUNQList;
    epaPrint:actPrintListExecute(nil);
    epaAdd:NewUNQ;
    epaDelete:DropUNQ;
  else
    exit;
  end;
end;

function TfdbmTableEditorUniqueFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  case PageAction of
    epaAdd:Result:=(utAddUNQ in TDBTableObject(DBObject).UITableOptions);
    epaDelete:Result:=(utDropUNQ in TDBTableObject(DBObject).UITableOptions);
    epaCompile:Result:=(DBObject.State = sdboCreate) and (not (DBObject is TDBViewObject))
  else
    Result:=PageAction in [epaPrint, epaRefresh];
  end;
  UpdateActions;
end;

procedure TfdbmTableEditorUniqueFrame.SaveState(const SectionName: string;
  const Ini: TIniFile);
begin
  SaveRxDBGridState(SectionName+'.UNQListGrid', Ini, RxDBGrid1);
end;

procedure TfdbmTableEditorUniqueFrame.RestoreState(const SectionName: string;
  const Ini: TIniFile);
begin
  RestoreRxDBGridState(SectionName+'.UNQListGrid', Ini, RxDBGrid1);
end;

constructor TfdbmTableEditorUniqueFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  rxUnqList.Open;
end;

function TfdbmTableEditorUniqueFrame.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  C: TSQLConstraintItem;
begin
  if (DBObject.State = sdboCreate) and (ASQLObject is TSQLCreateTable) then
  begin
    rxUnqList.First;
    while not rxUnqList.EOF do
    begin
      C:=TSQLCreateTable(ASQLObject).SQLConstraints.Add(ctUnique);
      C.ConstraintName:=rxUnqListName.AsString;
      C.ConstraintFields.AddParam(rxUnqListField.AsString);
      C.IndexName:=rxUnqListIndexName.AsString;
      C.Description:=TrimRight(rxUnqListDescription.AsString);
      //rxUnqListIndexSort.AsBoolean:=P.Index.Descending;
      rxUnqList.Next;
    end;
    rxUnqList.First;
  end;
  Result:=true;
end;

end.

