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

unit fdbmTableEditorPKListUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, SQLEngineAbstractUnit,
  fdmAbstractEditorUnit, rxdbgrid, rxmemds, RxDBGridPrintGrid, db, Menus,
  LR_DBSet, ActnList, LR_PGrid, DBGrids, SQLEngineCommonTypesUnit,
  fbmSqlParserUnit, Controls, IniFiles;

type

  { TfdbmTableEditorPKListFrame }

  TfdbmTableEditorPKListFrame = class(TEditorPage)
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    pkRefresh: TAction;
    pkPrint: TAction;
    pkNew: TAction;
    pkDrop: TAction;
    ActionList1: TActionList;
    dsPKList: TDatasource;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    PopupMenu1: TPopupMenu;
    RxDBGrid1: TRxDBGrid;
    RxDBGridPrint1: TRxDBGridPrint;
    rxPKList: TRxMemoryData;
    rxPKListIndex_Name: TStringField;
    rxPKListName: TStringField;
    rxPKListOnField: TStringField;
    rxPKListSortOrder: TStringField;
    procedure pkDropExecute(Sender: TObject);
    procedure pkNewExecute(Sender: TObject);
    procedure pkPrintExecute(Sender: TObject);
    procedure pkRefreshExecute(Sender: TObject);
    procedure rxPKListAfterClose(DataSet: TDataSet);
  private
    procedure NewPK;
    procedure DropPK;
    procedure RefreshPKList;
  public
    procedure Localize;override;
    function PageName:string;override;
    procedure Activate;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction: TEditorPageAction): boolean;override;
    procedure SaveState(const SectionName:string; const Ini:TIniFile);override;
    procedure RestoreState(const SectionName:string; const Ini:TIniFile);override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
  end;

implementation
uses fbmStrConstUnit, ibmanagertableeditorPkunit, fbmToolsUnit, sqlObjects;

{$R *.lfm}

{ TfdbmTableEditorPKListFrame }

procedure TfdbmTableEditorPKListFrame.pkNewExecute(Sender: TObject);
begin
  NewPK;
end;

procedure TfdbmTableEditorPKListFrame.pkPrintExecute(Sender: TObject);
begin
  RxDBGridPrint1.PreviewReport;
end;

procedure TfdbmTableEditorPKListFrame.pkDropExecute(Sender: TObject);
begin
  DropPK;
end;

procedure TfdbmTableEditorPKListFrame.pkRefreshExecute(Sender: TObject);
begin
  RefreshPKList;
end;

procedure TfdbmTableEditorPKListFrame.rxPKListAfterClose(DataSet: TDataSet);
begin
  pkDrop.Enabled:=rxPKList.Active and (rxPKList.RecordCount>0);
end;

procedure TfdbmTableEditorPKListFrame.NewPK;
var
  FCmd: TSQLAlterTable;
  OP: TAlterTableOperator;
  C: TSQLConstraintItem;
begin
  fbmTableEditorPkForm:=TfbmTableEditorPkForm.CreatePKEditForm(TDBTableObject(DBObject));
  if fbmTableEditorPkForm.ShowModal= mrOk then
  begin
    FCmd:=DBObject.CreateSQLObject as TSQLAlterTable;
    OP:=FCmd.AddOperator(ataAddTableConstraint);
    C:=OP.Constraints.Add(ctPrimaryKey, fbmTableEditorPkForm.PKName.Text);
    C.ConstraintFields.AsString:=fbmTableEditorPkForm.GetFieldNames;
    if DBObject.CompileSQLObject(FCmd, [sepShowCompForm]) then
      RefreshPKList;
    FCmd.Free;

{    if TDBTableObject(DBObject).PKNew(fbmTableEditorPkForm.PKName.Text, fbmTableEditorPkForm.GetFieldNames,
      '', indAscending) then
      RefreshPKList;}
  end;
  fbmTableEditorPkForm.Free;
end;

procedure TfdbmTableEditorPKListFrame.DropPK;
var
  FCmd: TSQLAlterTable;
  OP: TAlterTableOperator;
begin
  FCmd:=DBObject.CreateSQLObject as TSQLAlterTable;
  OP:=FCmd.AddOperator(ataDropConstraint);
  OP.Constraints.Add(ctPrimaryKey, rxPKListName.AsString);
  if DBObject.CompileSQLObject(FCmd, [sepShowCompForm]) then
    RefreshPKList;
  FCmd.Free;

{  if TDBTableObject(DBObject).PKDrop(rxPKListName.AsString) then
    RefreshPKList;}
end;

procedure TfdbmTableEditorPKListFrame.RefreshPKList;
var
  i:integer;
  P:TPrimaryKeyRecord;
begin
  TDBTableObject(DBObject).RefreshConstraintPrimaryKey;
  rxPKList.CloseOpen;
  rxPKList.DisableControls;
  for i:=0 to TDBTableObject(DBObject).ConstraintCount-1 do
  begin
    P:=TDBTableObject(DBObject).Constraint[i];
    if P.ConstraintType = ctPrimaryKey then
    begin
      rxPKList.Append;
      rxPKListName.AsString:=P.Name;
      rxPKListIndex_Name.AsString:=P.IndexName;
      if Assigned(P.Index) then
      begin
        rxPKListOnField.AsString:=P.Index.IndexField;
        rxPKListSortOrder.AsString:=IndexSortOrderStr(P.Index.SortOrder);
      end
      else
      begin
        rxPKListOnField.AsString:=P.FieldList;
      end;
      rxPKList.Post;
    end;
  end;
  rxPKList.First;
  rxPKList.EnableControls;
end;

procedure TfdbmTableEditorPKListFrame.Localize;
begin
  inherited Localize;
  pkNew.Caption:=sNewPK;
  pkNew.Hint:=sNewPKHint;
  pkDrop.Caption:=sDropPrimaryKey;
  pkDrop.Hint:=sDropPrimaryKeyHint;
  pkPrint.Caption:=sPrintList;
  pkPrint.Hint:=sPrintListOfPrimaryKeysHint;
  pkRefresh.Caption:=sRefresListPK;
  pkRefresh.Hint:=sRefresListPKHint;

  RxDBGrid1.ColumnByFieldName('Name').Title.Caption:=sPKName;
  RxDBGrid1.ColumnByFieldName('OnField').Title.Caption:=sOnField;
  RxDBGrid1.ColumnByFieldName('Index_Name').Title.Caption:=sIndexName;
  RxDBGrid1.ColumnByFieldName('SortOrder').Title.Caption:=sSorting;
end;

function TfdbmTableEditorPKListFrame.PageName: string;
begin
  Result:=sPrimaryKeys;
end;

procedure TfdbmTableEditorPKListFrame.Activate;
begin
  RefreshPKList;
end;

function TfdbmTableEditorPKListFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaAdd, epaEdit, epaDelete, epaExport, epaPrint, epaRefresh];
end;

function TfdbmTableEditorPKListFrame.DoMetod(PageAction:TEditorPageAction):boolean;
begin
  Result:=true;
  case PageAction of
    epaRefresh:RefreshPKList;
    epaPrint:pkPrintExecute(nil);
    epaAdd:NewPK;
//    epaEdit:EditIndex;
    epaDelete:DropPK;
  else
    exit;
  end;
end;

procedure TfdbmTableEditorPKListFrame.SaveState(const SectionName: string;
  const Ini: TIniFile);
begin
  SaveRxDBGridState(SectionName+'.PKListGrid', Ini, RxDBGrid1);
end;

procedure TfdbmTableEditorPKListFrame.RestoreState(const SectionName: string;
  const Ini: TIniFile);
begin
  RestoreRxDBGridState(SectionName+'.PKListGrid', Ini, RxDBGrid1);
end;

constructor TfdbmTableEditorPKListFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  rxPKList.Open;
end;

end.

