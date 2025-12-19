{ Free DB Manager

  Copyright (C) 2005-2024 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fdbmTableEditorForeignKeyUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, RxDBGridExportPdf, RxDBGridExportSpreadSheet, SysUtils, FileUtil, LResources, Forms, SQLEngineAbstractUnit,
  fbmSqlParserUnit, fdmAbstractEditorUnit, rxdbgrid, ActnList, rxmemds,
  RxDBGridPrintGrid, db, LR_PGrid, Menus, DBGrids, Controls, ExtCtrls, DBCtrls,
  IniFiles, sqlObjects;

const
  defFKName = '';

type

  { TfdbmTableEditorForeignKeyFrame }

  TfdbmTableEditorForeignKeyFrame = class(TEditorPage)
    actRefresh: TAction;
    actNewFK: TAction;
    actDropFK: TAction;
    actPrintList: TAction;
    ActionList1: TActionList;
    DBMemo1: TDBMemo;
    dsFKList: TDatasource;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    RxDBGridExportPDF1 : TRxDBGridExportPDF;
    RxDBGridExportSpreadSheet1 : TRxDBGridExportSpreadSheet;
    RxDBGridPrint1: TRxDBGridPrint;
    rxFKList: TRxMemoryData;
    PopupMenu1: TPopupMenu;
    RxDBGrid1: TRxDBGrid;
    rxFKListDesc: TMemoField;
    rxFKListField: TStringField;
    rxFKListFK_Field: TStringField;
    rxFKListFK_Table: TStringField;
    rxFKListIndexName: TStringField;
    rxFKListIndexSortOrder: TStringField;
    rxFKListName: TStringField;
    rxFKListOnDelete: TStringField;
    rxFKListOnUpdate: TStringField;
    Splitter1: TSplitter;
    procedure actDropFKExecute(Sender: TObject);
    procedure actNewFKExecute(Sender: TObject);
    procedure actPrintListExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure RxDBGridExportSpreadSheet1BeforeExecute(Sender : TObject);
    procedure rxFKListAfterPost(DataSet: TDataSet);
  private
    procedure NewFK;
    procedure DropFK;
    procedure RefreshFKList;
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
  fbmManagerTableEditorFKUnit, fbmToolsUnit;

{$R *.lfm}

{ TfdbmTableEditorForeignKeyFrame }

procedure TfdbmTableEditorForeignKeyFrame.actNewFKExecute(Sender: TObject);
begin
  NewFK;
end;

procedure TfdbmTableEditorForeignKeyFrame.actPrintListExecute(Sender: TObject);
begin
  RxDBGridPrint1.PreviewReport;
end;

procedure TfdbmTableEditorForeignKeyFrame.actRefreshExecute(Sender: TObject);
begin
  RefreshFKList;
end;

procedure TfdbmTableEditorForeignKeyFrame.RxDBGridExportSpreadSheet1BeforeExecute(Sender : TObject);
begin
  RxDBGridExportSpreadSheet1.PageName:=DBObject.Caption;
  RxDBGridExportSpreadSheet1.FileName:=DBObject.Caption+'FK.ods';
end;

procedure TfdbmTableEditorForeignKeyFrame.rxFKListAfterPost(DataSet: TDataSet);
begin
  actDropFK.Enabled:=rxFKList.Active and (rxFKList.RecordCount>0);
end;

procedure TfdbmTableEditorForeignKeyFrame.actDropFKExecute(Sender: TObject);
begin
  DropFK;
end;

procedure TfdbmTableEditorForeignKeyFrame.NewFK;
var
  OP: TAlterTableOperator;
  P: TSQLCommandDDL;
  C: TSQLConstraintItem;
begin
  fbmManagerTableEditorFKForm:=TfbmManagerTableEditorFKForm.Create(TDBTableObject(DBObject));
  if fbmManagerTableEditorFKForm.ShowModal = mrOk then
  begin
    if DBObject.State <> sdboCreate then
    begin
      P:=DBObject.CreateSQLObject;
      if Assigned(P) then
      begin
        if not (P is TSQLAlterTable) then raise Exception.Create('TfdbmTableEditorForeignKeyFrame.NewFK; - TSQLAlterTable');
        OP:=TSQLAlterTable(P).AddOperator(ataAddTableConstraint);
        C:=OP.Constraints.Add(ctForeignKey, fbmManagerTableEditorFKForm.edtFKName.Text);
        //C.ConstraintFields.AddParam(fbmManagerTableEditorFKForm.FKFields);
        C.ConstraintFields.AsString:=fbmManagerTableEditorFKForm.FKFields;
        C.ForeignKeyRuleOnUpdate:=fbmManagerTableEditorFKForm.ForeignKeyRuleOnUpdate;
        C.ForeignKeyRuleOnDelete:=fbmManagerTableEditorFKForm.ForeignKeyRuleOnDelete;
        C.ForeignTable:=fbmManagerTableEditorFKForm.RefTable;
        //C.ForeignFields.AddParam(fbmManagerTableEditorFKForm.RefFields);
        C.ForeignFields.AsString:=fbmManagerTableEditorFKForm.RefFields;
        C.IndexName:=fbmManagerTableEditorFKForm.FKIndexName;
        C.Description:=TrimRight(fbmManagerTableEditorFKForm.Memo1.Text);
        if DBObject.CompileSQLObject(P, [sepShowCompForm]) then
          RefreshFKList;
        P.Free;
      end
      else
        raise Exception.Create('TfdbmTableEditorForeignKeyFrame.NewFK; - DBObject.CreateSQLObject;');
    end
    else
    begin
      rxFKList.Append;
      rxFKListName.AsString:=fbmManagerTableEditorFKForm.edtFKName.Text;
      rxFKListField.AsString:=fbmManagerTableEditorFKForm.FKFields;
      rxFKListIndexName.AsString:=fbmManagerTableEditorFKForm.FKIndexName;
      rxFKListOnDelete.AsString:=ForeignKeyRuleNames[fbmManagerTableEditorFKForm.ForeignKeyRuleOnDelete];
      rxFKListOnUpdate.AsString:=ForeignKeyRuleNames[fbmManagerTableEditorFKForm.ForeignKeyRuleOnUpdate];
      rxFKListFK_Table.AsString:=fbmManagerTableEditorFKForm.RefTable;
      rxFKListFK_Field.AsString:=fbmManagerTableEditorFKForm.RefFields;

{      if Assigned(P.Index) then
        rxFKListIndexSort.AsBoolean:=P.Index.Descending;}

      rxFKList.Post;
    end;
  end;
  fbmManagerTableEditorFKForm.Free;
end;

procedure TfdbmTableEditorForeignKeyFrame.DropFK;
var
  P: TSQLCommandDDL;
  OP: TAlterTableOperator;
  C: TSQLConstraintItem;
begin
  if DBObject.State <> sdboCreate then
  begin
    P:=DBObject.CreateSQLObject;
    if Assigned(P) then
    begin
      if not (P is TSQLAlterTable) then raise Exception.Create('TfdbmTableEditorForeignKeyFrame.DropFK; - TSQLAlterTable');
      OP:=TSQLAlterTable(P).AddOperator(ataDropConstraint);
      C:=OP.Constraints.Add(ctForeignKey, rxFKListName.AsString);
      if DBObject.CompileSQLObject(P, [sepShowCompForm]) then
        RefreshFKList;
      P.Free;
    end
    else
     raise Exception.Create('TfdbmTableEditorForeignKeyFrame.DropFK; - DBObject.CreateSQLObject;');
  end
  else
  begin
    if QuestionBox(sDropForeignKey) then
      rxFKList.Delete;
  end;
end;

procedure TfdbmTableEditorForeignKeyFrame.RefreshFKList;
var
  i:integer;
  P:TForeignKeyRecord;
begin
  TDBTableObject(DBObject).RefreshConstraintForeignKey;
  rxFKList.CloseOpen;
  rxFKList.DisableControls;
  for i:=0 to TDBTableObject(DBObject).ConstraintCount-1 do
  begin
    P:=TForeignKeyRecord(TDBTableObject(DBObject).Constraint[i]);
    if P.ConstraintType = ctForeignKey then
    begin
      rxFKList.Append;
      rxFKListName.AsString:=P.Name;
      rxFKListDesc.AsString:=P.Description;
      rxFKListField.AsString:=P.FieldList;
      rxFKListIndexName.AsString:=P.IndexName;
      rxFKListOnDelete.AsString:=ForeignKeyRuleNames[P.OnDeleteRule];
      rxFKListOnUpdate.AsString:=ForeignKeyRuleNames[P.OnUpdateRule];

      rxFKListFK_Table.AsString:=P.FKTableName;
      rxFKListFK_Field.AsString:=P.FKFieldName;

      if Assigned(P.Index) then
        rxFKListIndexSortOrder.AsString:=IndexSortOrderStr(P.Index.SortOrder);

      rxFKList.Post;
    end;
  end;
  rxFKList.First;
  rxFKList.EnableControls;
end;

procedure TfdbmTableEditorForeignKeyFrame.UpdateActions;
begin
  actNewFK.Enabled:=(utAddFK in TDBTableObject(DBObject).UITableOptions);
  actDropFK.Enabled:=(utDropFK in TDBTableObject(DBObject).UITableOptions) and rxFKList.Active and (rxFKList.RecordCount > 0);
end;

procedure TfdbmTableEditorForeignKeyFrame.Localize;
begin
  inherited Localize;
  RxDBGrid1.Columns[0].Title.Caption:=sConstraintName;
  RxDBGrid1.Columns[1].Title.Caption:=sOnField;
  RxDBGrid1.Columns[2].Title.Caption:=sExtrenalTable;
  RxDBGrid1.Columns[3].Title.Caption:=sExtrenalField;
  RxDBGrid1.Columns[4].Title.Caption:=sUpdateRule;
  RxDBGrid1.Columns[5].Title.Caption:=sDeleteRule;
  RxDBGrid1.Columns[6].Title.Caption:=sIndexName;
  RxDBGrid1.ColumnByFieldName('IndexSortOrder').Title.Caption:=sSortOrder;

  actRefresh.Caption:=sDBNavHintRefresh;
  actNewFK.Caption:=sNewForeignKey;
  actDropFK.Caption:=sDropForeignKey;
  actPrintList.Caption:=sPrintFKList;
end;

function TfdbmTableEditorForeignKeyFrame.PageName: string;
begin
  Result:=sForeignKeys;
end;

procedure TfdbmTableEditorForeignKeyFrame.Activate;
begin
  RefreshFKList;
end;

function TfdbmTableEditorForeignKeyFrame.DoMetod(PageAction:TEditorPageAction):boolean;
begin
  Result:=true;
  case PageAction of
    epaRefresh:RefreshFKList;
    epaPrint:actPrintList.Execute;
    epaAdd:NewFK;
    epaDelete:DropFK;
  else
    exit;
  end;
end;

function TfdbmTableEditorForeignKeyFrame.ActionEnabled(
  PageAction: TEditorPageAction): boolean;
begin
  case PageAction of
    epaAdd:Result:=(utAddFK in TDBTableObject(DBObject).UITableOptions);
    epaDelete:Result:=(utDropFK in TDBTableObject(DBObject).UITableOptions);
    epaCompile:Result:=(DBObject.State = sdboCreate) and (not (DBObject is TDBViewObject))
  else
    Result:=PageAction in [epaPrint, epaRefresh];
  end;
  UpdateActions;
end;

procedure TfdbmTableEditorForeignKeyFrame.SaveState(const SectionName: string;
  const Ini: TIniFile);
begin
  SaveRxDBGridState(SectionName+'.FKListGrid', Ini, RxDBGrid1);
end;

procedure TfdbmTableEditorForeignKeyFrame.RestoreState(
  const SectionName: string; const Ini: TIniFile);
begin
  RestoreRxDBGridState(SectionName+'.FKListGrid', Ini, RxDBGrid1);
end;

constructor TfdbmTableEditorForeignKeyFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  rxFKList.Open;

  if Assigned(ADBObject) and Assigned(ADBObject.OwnerDB) then
    DBMemo1.Visible:=(feDescribeTableConstraint in ADBObject.OwnerDB.SQLEngileFeatures)
  else
    DBMemo1.Visible:=false;
  Splitter1.Visible:=DBMemo1.Visible;
end;

function TfdbmTableEditorForeignKeyFrame.SetupSQLObject(
  ASQLObject: TSQLCommandDDL): boolean;
var
  C: TSQLConstraintItem;
begin
  if (DBObject.State = sdboCreate) and (ASQLObject is TSQLCreateTable) then
  begin
    rxFKList.First;
    while not rxFKList.EOF do
    begin
      C:=TSQLCreateTable(ASQLObject).SQLConstraints.Add(ctForeignKey);
      C.ConstraintName:=rxFKListName.AsString;
      C.ConstraintFields.AddParam(rxFKListField.AsString);
      C.IndexName:=rxFKListIndexName.AsString;
      C.ForeignTable:=rxFKListFK_Table.AsString;
      C.ForeignFields.AddParam(rxFKListFK_Field.AsString);
      C.ForeignKeyRuleOnUpdate:=StrToForeignKeyRule(rxFKListOnUpdate.AsString);
      C.ForeignKeyRuleOnDelete:=StrToForeignKeyRule(rxFKListOnDelete.AsString);
      //C.Description:=TrimRight(rxFUnqListDescription.AsString);
      //rxUnqListIndexSort.AsBoolean:=P.Index.Descending;
      rxFKList.Next;
    end;
    rxFKList.First;
  end;
  Result:=true;
end;

end.

