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

unit fbmpgTableCheckConstaintUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, rxdbgrid, rxmemds, RxDBGridPrintGrid, LR_PGrid,
  Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, ActnList, Menus, db,
  fdmAbstractEditorUnit, fdbm_SynEditorUnit, SQLEngineAbstractUnit, fbmSqlParserUnit,
  {PostgreSQLEngineUnit, }LR_Class;

type

  { TfbmpgTableCheckConstaintPage }

  TfbmpgTableCheckConstaintPage = class(TEditorPage)
    actEdit: TAction;
    actDelete: TAction;
    actPrint: TAction;
    actNew: TAction;
    ActionList1: TActionList;
    dsData: TDatasource;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    PopupMenu1: TPopupMenu;
    RxDBGrid1: TRxDBGrid;
    rxData: TRxMemoryData;
    rxDataCHECK_BODY: TStringField;
    rxDataCHECK_DESK: TStringField;
    rxDataCHECK_NAME: TStringField;
    RxDBGridPrint1: TRxDBGridPrint;
    procedure actDeleteExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actNewExecute(Sender: TObject);
    procedure actPrintExecute(Sender: TObject);
    procedure RxDBGrid1DblClick(Sender: TObject);
  private
    procedure UpdateEnvOptions;override;
    procedure RefreshCheckList;
  protected
  public
    function PageName:string; override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Activate;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation

uses fbmStrConstUnit, fbmToolsUnit, SQLEngineCommonTypesUnit,
  fbmpgTableCheckConstaint_EditUnit, sqlObjects;

{$R *.lfm}

{ TfbmpgTableCheckConstaintPage }

procedure TfbmpgTableCheckConstaintPage.RxDBGrid1DblClick(Sender: TObject);
begin
  actEdit.Execute;
end;

procedure TfbmpgTableCheckConstaintPage.actEditExecute(Sender: TObject);
var
  CheckName:string;
  P: TSQLCommandDDL;
  OP: TAlterTableOperator;
  C: TSQLConstraintItem;
begin
  fbmpgTableCheckConstaint_EditForm:=TfbmpgTableCheckConstaint_EditForm.CreateEditForm(TDBTableObject(DBObject), true);

  fbmpgTableCheckConstaint_EditForm.edtName.Text:=rxDataCHECK_NAME.AsString;
  fbmpgTableCheckConstaint_EditForm.edtName.Enabled:=false;
  fbmpgTableCheckConstaint_EditForm.EditorFrame.EditorText:=rxDataCHECK_BODY.AsString;
  fbmpgTableCheckConstaint_EditForm.edtDescr.Text:=rxDataCHECK_DESK.AsString;

  if fbmpgTableCheckConstaint_EditForm.ShowModal = mrOk then
  begin
    if DBObject.State <> sdboCreate then
    begin
      P:=DBObject.CreateSQLObject;
      if Assigned(P) then
      begin
        if not (P is TSQLAlterTable) then raise Exception.Create('TfdbmTableEditorForeignKeyFrame.NewCheck - TSQLAlterTable');
        OP:=TSQLAlterTable(P).AddOperator(ataDropConstraint);
        C:=OP.Constraints.Add(ctTableCheck, fbmpgTableCheckConstaint_EditForm.edtName.Text);

        OP:=TSQLAlterTable(P).AddOperator(ataAddTableConstraint);
        C:=OP.Constraints.Add(ctTableCheck, fbmpgTableCheckConstaint_EditForm.edtName.Text);
        C.ConstraintExpression:=TrimRight(fbmpgTableCheckConstaint_EditForm.EditorFrame.EditorText);
        C.Description:=fbmpgTableCheckConstaint_EditForm.edtDescr.Text;

        if DBObject.CompileSQLObject(P, [sepShowCompForm]) then
          RefreshCheckList;
        P.Free;
      end
      else
        raise Exception.Create('TfdbmTableEditorForeignKeyFrame.NewFK; - DBObject.CreateSQLObject;');
    end
    else
    begin
      rxData.Append;
      rxDataCHECK_NAME.AsString:=TrimRight(fbmpgTableCheckConstaint_EditForm.edtName.Text);
      rxDataCHECK_BODY.AsString:=TrimRight(fbmpgTableCheckConstaint_EditForm.EditorFrame.EditorText);
      rxDataCHECK_DESK.AsString:=TrimRight(fbmpgTableCheckConstaint_EditForm.edtDescr.Text);
      rxData.Post;
    end;
  end;
  fbmpgTableCheckConstaint_EditForm.Free;
end;

procedure TfbmpgTableCheckConstaintPage.actDeleteExecute(Sender: TObject);
var
  P: TSQLCommandDDL;
  OP: TAlterTableOperator;
  C: TSQLConstraintItem;
begin
  if QuestionBox(sDeleteCheckQst) then
  begin
    //if TDBTableObject(DBObject).TableCheckConstraintDrop(rxDataCHECK_NAME.AsString) then
    if DBObject.State <> sdboCreate then
    begin
      P:=DBObject.CreateSQLObject;
      if Assigned(P) then
      begin
        OP:=TSQLAlterTable(P).AddOperator(ataDropConstraint);
        C:=OP.Constraints.Add(ctTableCheck, fbmpgTableCheckConstaint_EditForm.edtName.Text);

        if DBObject.CompileSQLObject(P, [sepShowCompForm]) then
          RefreshCheckList;
        P.Free;
      end
      else
        raise Exception.Create('TfdbmTableEditorForeignKeyFrame.NewFK; - DBObject.CreateSQLObject;');
    end
    else
    begin
      if rxData.RecordCount > 0 then
        rxData.Delete;
    end;
  end;
end;

procedure TfbmpgTableCheckConstaintPage.actNewExecute(Sender: TObject);
var
  P: TSQLCommandDDL;
  OP: TAlterTableOperator;
  C: TSQLConstraintItem;
begin
  fbmpgTableCheckConstaint_EditForm:=TfbmpgTableCheckConstaint_EditForm.CreateEditForm(TDBTableObject(DBObject), true);
  if fbmpgTableCheckConstaint_EditForm.ShowModal = mrOk then
  begin
    if DBObject.State <> sdboCreate then
    begin
      P:=DBObject.CreateSQLObject;
      if Assigned(P) then
      begin
        if not (P is TSQLAlterTable) then raise Exception.Create('TfdbmTableEditorForeignKeyFrame.NewCheck - TSQLAlterTable');
        OP:=TSQLAlterTable(P).AddOperator(ataAddTableConstraint);
        C:=OP.Constraints.Add(ctTableCheck, fbmpgTableCheckConstaint_EditForm.edtName.Text);
        C.ConstraintExpression:=TrimRight(fbmpgTableCheckConstaint_EditForm.EditorFrame.EditorText);
        C.Description:=fbmpgTableCheckConstaint_EditForm.edtDescr.Text;

        if DBObject.CompileSQLObject(P, [sepShowCompForm]) then
          RefreshCheckList;
        P.Free;
      end
      else
        raise Exception.Create('TfdbmTableEditorForeignKeyFrame.NewFK; - DBObject.CreateSQLObject;');
    end
    else
    begin
      rxData.Append;
      rxDataCHECK_NAME.AsString:=TrimRight(fbmpgTableCheckConstaint_EditForm.edtName.Text);
      rxDataCHECK_BODY.AsString:=TrimRight(fbmpgTableCheckConstaint_EditForm.EditorFrame.EditorText);
      rxDataCHECK_DESK.AsString:=TrimRight(fbmpgTableCheckConstaint_EditForm.edtDescr.Text);
      rxData.Post;
    end;
  end;
  fbmpgTableCheckConstaint_EditForm.Free;
end;

procedure TfbmpgTableCheckConstaintPage.actPrintExecute(Sender: TObject);
begin
  RxDBGridPrint1.PreviewReport;
end;

procedure TfbmpgTableCheckConstaintPage.UpdateEnvOptions;
begin
  inherited UpdateEnvOptions;
end;

procedure TfbmpgTableCheckConstaintPage.RefreshCheckList;
var
  i:integer;
  P:TTableCheckConstraintRecord;
begin
  if DBObject.State = sdboEdit then
  begin
    rxData.CloseOpen;
    TDBTableObject(DBObject).RefreshConstraintCheck;
    rxData.DisableControls;
    for i:=0 to TDBTableObject(DBObject).ConstraintCount-1 do
    begin
      P:=TTableCheckConstraintRecord(TDBTableObject(DBObject).Constraint[i]);
      if P.ConstraintType = ctTableCheck then
      begin
        rxData.Append;
        rxDataCHECK_NAME.AsString:=P.Name;
        rxDataCHECK_BODY.AsString:=P.SQLBody;
        rxDataCHECK_DESK.AsString:=P.Description;
        rxData.Post;
      end;
    end;
    rxData.First;
    rxData.EnableControls;
  end
  else
    rxData.Active:=true;
end;

function TfbmpgTableCheckConstaintPage.PageName: string;
begin
  Result:= sCheckConstraint;
end;


function TfbmpgTableCheckConstaintPage.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaRefresh:RefreshCheckList;
    epaPrint:actPrint.Execute;
    epaAdd:actNew.Execute;
    epaEdit:actEdit.Execute;
    epaDelete:actDelete.Execute;
  else
    exit;
  end;
end;

procedure TfbmpgTableCheckConstaintPage.Activate;
begin
  RefreshCheckList;
end;

function TfbmpgTableCheckConstaintPage.ActionEnabled(
  PageAction: TEditorPageAction): boolean;
begin
  Result:=PageAction in [epaPrint, epaRefresh, epaAdd, epaDelete, epaEdit, epaCompile];
end;

constructor TfbmpgTableCheckConstaintPage.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  RefreshCheckList;

  if Assigned(ADBObject) and Assigned(ADBObject.OwnerDB) then
  RxDBGrid1.ColumnByFieldName('CHECK_DESK').Visible:=feDescribeTableConstraint in ADBObject.OwnerDB.SQLEngileFeatures;
end;

procedure TfbmpgTableCheckConstaintPage.Localize;
begin
  inherited Localize;
  RxDBGrid1.ColumnByFieldName('CHECK_NAME').Title.Caption:=sCheckName;
  RxDBGrid1.ColumnByFieldName('CHECK_BODY').Title.Caption:=sCheckBody;
  RxDBGrid1.ColumnByFieldName('CHECK_DESK').Title.Caption:=sDescription;

  actNew.Caption:=sConstraintNew;
  actEdit.Caption:=sConstraintEdit;
  actDelete.Caption:=sConstraintDelete;
end;

function TfbmpgTableCheckConstaintPage.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  OP: TAlterTableOperator;
  C: TSQLConstraintItem;
begin
  Result:=false;
  if (ASQLObject is TSQLCreateTable) and (DBObject.State = sdboCreate) then
  begin
    rxData.First;
    while not rxData.EOF do
    begin
      C:=TSQLCreateTable(ASQLObject).SQLConstraints.Add(ctTableCheck, rxDataCHECK_NAME.AsString);
      C.ConstraintExpression:=TrimRight(rxDataCHECK_BODY.AsString);
      C.Description:=rxDataCHECK_DESK.AsString;
      rxData.Next;
    end;
    Result:=true;
  end;
end;

end.

