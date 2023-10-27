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

unit pgFunctionConfigUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ActnList, Menus, DB,
  rxmemds, rxdbgrid, RxDBGridPrintGrid, fdmAbstractEditorUnit,
  SQLEngineAbstractUnit, PostgreSQLEngineUnit, pgTypes, fbmSqlParserUnit,
  sqlObjects;

type

  { TpgFunctionConfigFrame }

  TpgFunctionConfigFrame = class(TEditorPage)
    actNew: TAction;
    actEdit: TAction;
    actDel: TAction;
    actPrint: TAction;
    actRefresh: TAction;
    ActionList1: TActionList;
    dsData: TDataSource;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    PopupMenu1: TPopupMenu;
    rxDataNAME: TStringField;
    rxDataVALUE: TStringField;
    RxDBGrid1: TRxDBGrid;
    rxData: TRxMemoryData;
    RxDBGridPrint1: TRxDBGridPrint;
    procedure actDelExecute(Sender: TObject);
    procedure actNewExecute(Sender: TObject);
    procedure actPrintExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure RxDBGrid1DblClick(Sender: TObject);
  private
    procedure RefreshPage;
  public
    procedure Localize;override;
    function PageName:string;override;
    procedure Activate;override;
    function DoMetod(PageAction: TEditorPageAction): boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean;override;
  end;

implementation
uses StrUtils, rxstrutils, fbmStrConstUnit, pg_SqlParserUnit, SQLEngineCommonTypesUnit,
  pgFunctionConfig_EditUnit;

{$R *.lfm}

{ TpgFunctionConfigFrame }

procedure TpgFunctionConfigFrame.actRefreshExecute(Sender: TObject);
begin
  RefreshPage;
end;

procedure TpgFunctionConfigFrame.RxDBGrid1DblClick(Sender: TObject);
begin
  actEdit.Execute;
end;

procedure TpgFunctionConfigFrame.actPrintExecute(Sender: TObject);
begin
  RxDBGridPrint1.Execute;
end;

procedure TpgFunctionConfigFrame.actDelExecute(Sender: TObject);
var
  FSqlObj: TPGSQLAlterFunction;
begin
  if not (rxData.Active and (rxData.RecordCount > 0)) then Exit;
  FSqlObj:=TPGSQLAlterFunction.Create(nil);
  try
    FSqlObj.SchemaName:=DBObject.SchemaName;
    FSqlObj.Name:=DBObject.Caption;
    TPGFunction(DBObject).FieldsIN.SaveToSQLFields(FSqlObj.Params);
    FSqlObj.AlterOperator:=pgafoReset;
    //FSqlObj.ConfigParams.AddParam(rxDataNAME.AsString);
    FSqlObj.OperatorArgumnet:=rxDataNAME.AsString;
    if DBObject.CompileSQLObject(FSqlObj, [sepShowCompForm]) then
      RefreshPage;
  finally
    FSqlObj.Free;
  end;
end;

procedure TpgFunctionConfigFrame.actNewExecute(Sender: TObject);
var
  FSqlObj: TPGSQLAlterFunction;
  P: TSQLParserField;
begin
  pgFunctionConfig_EditForm:=TpgFunctionConfig_EditForm.CreateEditForm(DBObject as TPGFunction);
  if (Sender as TComponent).Tag = 0 then
  begin
    pgFunctionConfig_EditForm.CurParam:=TSQLEnginePostgre(DBObject.OwnerDB).PGSettingParams.FindParam(rxDataNAME.AsString);
    pgFunctionConfig_EditForm.ParamValue:=rxDataVALUE.AsString;
  end;
  if pgFunctionConfig_EditForm.ShowModal = mrOk then
  begin
    FSqlObj:=TPGSQLAlterFunction.Create(nil);
    try
      FSqlObj.SchemaName:=DBObject.SchemaName;
      FSqlObj.Name:=DBObject.Caption;
      TPGFunction(DBObject).FieldsIN.SaveToSQLFields(FSqlObj.Params);
      FSqlObj.AlterOperator:=pgafoSet1;
      P:=FSqlObj.ConfigParams.AddParam(pgFunctionConfig_EditForm.CurParam.ParamName);
      P.ParamValue:=QuotedString(pgFunctionConfig_EditForm.ParamValue, '''');
      if DBObject.CompileSQLObject(FSqlObj, [sepShowCompForm]) then
        RefreshPage;
    finally
      FSqlObj.Free;
    end;
  end;
  pgFunctionConfig_EditForm.Free;
end;

procedure TpgFunctionConfigFrame.RefreshPage;
var
  S: String;
  I: Integer;
begin
  if (DBObject.State <> sdboEdit) or (not (DBObject is TPGFunction)) then Exit;

  rxData.DisableControls;
  rxData.EmptyTable;
  for I:=0 to TPGFunction(DBObject).FunctionConfig.Count-1 do
  begin
    S:=TPGFunction(DBObject).FunctionConfig[i];
    rxData.Append;
    rxDataNAME.AsString:=Copy2SymbDel(S, '=');
    rxDataVALUE.AsString:=S;
    rxData.Post;
  end;

  rxData.First;
  rxData.EnableControls;
end;

procedure TpgFunctionConfigFrame.Localize;
begin
  RxDBGrid1.ColumnByFieldName('NAME').Title.Caption:=sParamName;
  RxDBGrid1.ColumnByFieldName('VALUE').Title.Caption:=sParamValue;

  actNew.Caption:=sAddParam;
  actEdit.Caption:=sEditParam;
  actDel.Caption:=sDeleteParam;
  actRefresh.Caption:=sRefresh;
  actPrint.Caption:=sPrint;
end;

function TpgFunctionConfigFrame.PageName: string;
begin
  Result:=sConfiguration;
end;

procedure TpgFunctionConfigFrame.Activate;
begin
  inherited Activate;
end;

function TpgFunctionConfigFrame.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  Result:=true;
  case PageAction of
    epaRefresh:RefreshPage;
    epaPrint:RxDBGridPrint1.Execute;
    epaAdd:actNew.Execute;
    epaEdit:actEdit.Execute;
    epaDelete:actDel.Execute;
  else
    Result:=false;
  end;
end;

function TpgFunctionConfigFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaRefresh, epaPrint, epaAdd, epaEdit, epaDelete];
end;

constructor TpgFunctionConfigFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  rxData.Open;
  RefreshPage;
end;

function TpgFunctionConfigFrame.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
begin
  Result:=inherited SetupSQLObject(ASQLObject);
end;

end.

