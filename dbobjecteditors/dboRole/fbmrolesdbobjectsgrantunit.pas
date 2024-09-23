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

unit fbmRolesDBObjectsGrantUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, db, FileUtil, LResources, Forms, Controls, Graphics, uib,
  Dialogs, ExtCtrls, StdCtrls, Menus, rxdbgrid, rxmemds, rxtoolbar,
  sqlEngineTypes, RxDBGridPrintGrid, LR_PGrid, DBGrids, ActnList, ComCtrls,
  fdmAbstractEditorUnit, SQLEngineAbstractUnit, SQLEngineCommonTypesUnit,
  FBSQLEngineUnit, IniFiles;

type

  { TfbmRolesDBObjectsGrantForm }

  TfbmRolesDBObjectsGrantForm = class(TEditorPage)
    MenuItem10: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    revL: TAction;
    revH: TAction;
    revAll: TAction;
    grnAll: TAction;
    grnHL: TAction;
    grnH: TAction;
    grnL: TAction;
    grnHA: TAction;
    edtPrint: TAction;
    ActionList1: TActionList;
    ComboBox1: TComboBox;
    dsGrantsTable: TDatasource;
    Label2: TLabel;
    MenuItem1: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    PopupMenu1: TPopupMenu;
    RxDBGrid1: TRxDBGrid;
    RxDBGridPrint1: TRxDBGridPrint;
    rxGrantsTable: TRxMemoryData;
    rxGrantsTableDBObjectName: TStringField;
    rxGrantsTableDelete: TBooleanField;
    rxGrantsTableDescription: TStringField;
    rxGrantsTableExecute: TBooleanField;
    rxGrantsTableInsert: TBooleanField;
    rxGrantsTableO_Del: TBooleanField;
    rxGrantsTableO_Exec: TBooleanField;
    rxGrantsTableO_Ins: TBooleanField;
    rxGrantsTableO_Ref: TBooleanField;
    rxGrantsTableO_Sel: TBooleanField;
    rxGrantsTableO_Upd: TBooleanField;
    rxGrantsTableReference: TBooleanField;
    rxGrantsTableSelect: TBooleanField;
    rxGrantsTableType: TLongintField;
    rxGrantsTableUpdate: TBooleanField;
    ToolPanel1: TToolPanel;
    procedure ComboBox1Change(Sender: TObject);
    procedure edtPrintExecute(Sender: TObject);
    procedure grnHExecute(Sender: TObject);
    procedure grnLExecute(Sender: TObject);
    procedure revAllExecute(Sender: TObject);
    procedure RxDBGrid1GetCellProps(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor);
    procedure rxGrantsTableAfterInsert(DataSet: TDataSet);
    procedure rxGrantsTableAfterPost(DataSet: TDataSet);
    procedure rxGrantsTableFilterRecordEx(DataSet: TDataSet; var Accept: Boolean
      );
  private
    SQLEngine:TSQLEngineFireBird;
    procedure LoadRoleData;
    procedure GrantAll(E:boolean);
    procedure GrantForCollumn(E:boolean);
    procedure GrantLine(E:boolean);
    function CompileGrants:boolean;
    procedure SetGrant(E:boolean);
  public
    procedure Localize;override;
    function PageName:string;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    procedure SaveState(const SectionName:string; const Ini:TIniFile);override;
    procedure RestoreState(const SectionName:string; const Ini:TIniFile);override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
  end;

implementation
uses fbmStrConstUnit, ibmsqltextsunit, fbmToolsUnit, sqlObjects;

{$R *.lfm}

//const

{ TfbmRolesDBObjectsGrantForm }

procedure TfbmRolesDBObjectsGrantForm.rxGrantsTableAfterInsert(DataSet: TDataSet
  );
begin
  rxGrantsTableDelete.AsBoolean:=false;
  rxGrantsTableExecute.AsBoolean:=false;
  rxGrantsTableInsert.AsBoolean:=false;
  rxGrantsTableReference.AsBoolean:=false;
  rxGrantsTableSelect.AsBoolean:=false;
  rxGrantsTableUpdate.AsBoolean:=false;
  //Эти поля нужны для хранения "старого" состояния прав - чтобы не генерить лишние команды
  rxGrantsTableO_Del.AsBoolean:=false;
  rxGrantsTableO_Exec.AsBoolean:=false;
  rxGrantsTableO_Ins.AsBoolean:=false;
  rxGrantsTableO_Ref.AsBoolean:=false;
  rxGrantsTableO_Upd.AsBoolean:=false;
  rxGrantsTableO_Sel.AsBoolean:=false;
end;

procedure TfbmRolesDBObjectsGrantForm.rxGrantsTableAfterPost(DataSet: TDataSet);
begin
  CompileGrants;
end;

procedure TfbmRolesDBObjectsGrantForm.rxGrantsTableFilterRecordEx(
  DataSet: TDataSet; var Accept: Boolean);
begin
  Accept:=rxGrantsTableType.AsInteger=ComboBox1.ItemIndex;
end;

procedure TfbmRolesDBObjectsGrantForm.RxDBGrid1GetCellProps(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor);
begin
  if Assigned(Field) then
  begin
    if (Field.Tag = 2) and (rxGrantsTableType.AsInteger = 3) then
      Background:=clSilver
    else
    if (Field.Tag = 1) and (rxGrantsTableType.AsInteger in [1,2]) then
      Background:=clSilver;
  end;
end;

procedure TfbmRolesDBObjectsGrantForm.edtPrintExecute(Sender: TObject);
begin
  RxDBGridPrint1.PreviewReport;
end;

procedure TfbmRolesDBObjectsGrantForm.ComboBox1Change(Sender: TObject);
begin
  rxGrantsTable.Filtered:=ComboBox1.ItemIndex>0;
  rxGrantsTable.First;
end;

procedure TfbmRolesDBObjectsGrantForm.grnHExecute(Sender: TObject);
begin
  GrantForCollumn(TComponent(Sender).Tag = 1);
end;

procedure TfbmRolesDBObjectsGrantForm.grnLExecute(Sender: TObject);
begin
  GrantLine(TComponent(Sender).Tag = 1);
end;

procedure TfbmRolesDBObjectsGrantForm.revAllExecute(Sender: TObject);
begin
  GrantAll(TComponent(Sender).Tag = 1);
end;

procedure TfbmRolesDBObjectsGrantForm.LoadRoleData;

  procedure DoFill(P:TDBRootObject);
  var
    j: Integer;
  begin
    if Assigned(P) then
    begin
      for j:=0 to P.CountGroups - 1 do
          DoFill(P.Groups[j]);
      if (P.DBObjectKind in {ObjectKinds} [okPartitionTable, okTable, okView, okStoredProc]) and (not P.SystemObject) then
      begin
        for j:=0 to P.CountObject-1 do
        begin
          rxGrantsTable.Append;
          rxGrantsTableType.AsInteger:=ord(P.DBObjectKind);
          rxGrantsTableDBObjectName.AsString:=P.Items[j].CaptionFullPatch;
          rxGrantsTableDescription.AsString:=P.Items[j].Description;
          rxGrantsTable.Post;
        end;
      end;
    end;
  end;

var
  Qu:TUIBQuery;
  S:string;
  P: TDBObject;
  i: Integer;
begin
  rxGrantsTable.AfterPost:=nil;
  rxGrantsTable.CloseOpen;

  //SQLEngine.FillListForNames();
  for P in SQLEngine.Groups do
    DoFill(P as TDBRootObject);
{
  for i:=0 to SQLEngine.TablesRoot.CountObject-1 do
  begin
    rxGrantsTable.Append;
    rxGrantsTableType.AsInteger:=1;
    rxGrantsTableDBObjectName.AsString:=SQLEngine.TablesRoot.ObjName[i];
    rxGrantsTableDescription.AsString:=SQLEngine.TablesRoot.Items[i].Description;
    rxGrantsTable.Post;
  end;
  for i:=0 to SQLEngine.ViewsRoot.CountObject - 1 do
  begin
    rxGrantsTable.Append;
    rxGrantsTableType.AsInteger:=2;
    rxGrantsTableDBObjectName.AsString:=SQLEngine.ViewsRoot.ObjName[i];
    rxGrantsTableDescription.AsString:=SQLEngine.ViewsRoot.Items[i].Description;
    rxGrantsTable.Post;
  end;

  for i:=0 to SQLEngine.StoredProcRoot.CountObject - 1 do
  begin
    rxGrantsTable.Append;
    rxGrantsTableType.AsInteger:=3;
    rxGrantsTableDBObjectName.AsString:=SQLEngine.StoredProcRoot.ObjName[i];
    rxGrantsTableDescription.AsString:=SQLEngine.StoredProcRoot.Items[i].Description;
    rxGrantsTable.Post;
  end;
}
//  RxDBGrid1.OptimizeColumnsWidth('Object');

  Qu:=SQLEngine.GetUIBQuery(ssqlRoleGrantDBObjects);
  Qu.Params.ByNameAsString['role_name']:=DBObject.Caption;
  Qu.Open;
  while not Qu.Eof do
  begin
    if rxGrantsTable.Locate('DBObjectName', trim(Qu.Fields.ByNameAsString['rdb$relation_name']), []) then
    begin
      rxGrantsTable.Edit;
      S:=trim(Qu.Fields.ByNameAsString['rdb$privilege']);
      if S = 'D' then
      begin
        rxGrantsTableDelete.AsBoolean:=true;
        rxGrantsTableO_Del.AsBoolean:=true;
      end
      else
      if S = 'S' then
      begin
        rxGrantsTableSelect.AsBoolean:=true;
        rxGrantsTableO_Sel.AsBoolean:=true;
      end
      else
      if S = 'U' then
      begin
        rxGrantsTableUpdate.AsBoolean:=true;
        rxGrantsTableO_Upd.AsBoolean:=true;
      end
      else
      if S = 'I' then
      begin
        rxGrantsTableInsert.AsBoolean:=true;
        rxGrantsTableO_Ins.AsBoolean:=true;
      end
      else
      if S = 'R' then
      begin
        rxGrantsTableReference.AsBoolean:=true;
        rxGrantsTableO_Ref.AsBoolean:=true;
      end
      else
      if S = 'X' then
      begin
        rxGrantsTableExecute.AsBoolean:=true;
        rxGrantsTableO_Exec.AsBoolean:=true;
      end;

//  rxGrantsTableO_Ref.AsBoolean:=false;
//    rxGrantsTableReference.AsBoolean:=false;

      rxGrantsTable.Post;
    end;

    Qu.Next;
  end;
  Qu.Close;

  rxGrantsTable.AfterPost:=@rxGrantsTableAfterPost;
end;

procedure TfbmRolesDBObjectsGrantForm.GrantAll(E: boolean);
begin
  rxGrantsTable.First;
  while not rxGrantsTable.EOF do
  begin
    GrantLine(E);
    rxGrantsTable.Next;
  end;
end;

procedure TfbmRolesDBObjectsGrantForm.GrantForCollumn(E: boolean);
var
  F:TField;
begin
  F:=RxDBGrid1.SelectedField;
  if Assigned(F) and (F.DataType = ftBoolean) then
  begin
    rxGrantsTable.First;
    while not rxGrantsTable.EOF do
    begin
      rxGrantsTable.Edit;

      if F = rxGrantsTableExecute then
      begin
        if rxGrantsTableType.AsInteger = 3 then
          F.AsBoolean:=E
      end
      else
        F.AsBoolean:=E;

      rxGrantsTable.Post;
      rxGrantsTable.Next;
    end;
  end;
end;

procedure TfbmRolesDBObjectsGrantForm.GrantLine(E: boolean);
begin
  rxGrantsTable.Edit;
  if rxGrantsTableType.AsInteger = 3 then
    rxGrantsTableExecute.AsBoolean:=E
  else
  begin
    rxGrantsTableDelete.AsBoolean:=E;
    rxGrantsTableInsert.AsBoolean:=E;
    rxGrantsTableReference.AsBoolean:=E;
    rxGrantsTableSelect.AsBoolean:=E;
    rxGrantsTableUpdate.AsBoolean:=E;
  end;
  rxGrantsTable.Post;
end;

function TfbmRolesDBObjectsGrantForm.CompileGrants: boolean;
var
  GrantRole, RevokeRole:TObjectGrants;
begin
  DBObject.SQLScriptsBegin;
  rxGrantsTable.First;
  while (not rxGrantsTable.EOF) and Result do
  begin
    GrantRole:=[];
    RevokeRole:=[];
    if rxGrantsTableType.AsInteger = 3 then
    begin
      //Раздача прав на исполнение процедуры
      if rxGrantsTableExecute.AsBoolean <> rxGrantsTableO_Exec.AsBoolean then
        if rxGrantsTableExecute.AsBoolean then
          GrantRole:=[ogExecute]
        else
          RevokeRole:=[ogExecute];
    end
    else
    begin
      //раздача прав на выбор из множества
      if rxGrantsTableSelect.AsBoolean <> rxGrantsTableO_Sel.AsBoolean then
      begin
        if rxGrantsTableSelect.AsBoolean then
          GrantRole:=GrantRole + [ogSelect]
        else
          RevokeRole:=RevokeRole + [ogSelect];
      end;

      //раздача прав на вставку в множество
      if rxGrantsTableInsert.AsBoolean <> rxGrantsTableO_Ins.AsBoolean then
      begin
        if rxGrantsTableInsert.AsBoolean then
          GrantRole:=GrantRole + [ogInsert]
        else
          RevokeRole:=RevokeRole + [ogInsert];
      end;

      //раздача прав на удаление из множества
      if rxGrantsTableDelete.AsBoolean <> rxGrantsTableO_Del.AsBoolean then
      begin
        if rxGrantsTableDelete.AsBoolean then
          GrantRole:=GrantRole + [ogDelete]
        else
          RevokeRole:=RevokeRole + [ogDelete];
      end;

      //раздача прав на обновление множества
      if rxGrantsTableUpdate.AsBoolean <> rxGrantsTableO_Upd.AsBoolean then
      begin
        if rxGrantsTableUpdate.AsBoolean then
          GrantRole:=GrantRole + [ogUpdate]
        else
          RevokeRole:=RevokeRole + [ogUpdate];
      end;

      //раздача прав на ссылочную целостность в множество
      if rxGrantsTableReference.AsBoolean <> rxGrantsTableO_Ref.AsBoolean then
      begin
        if rxGrantsTableReference.AsBoolean then
          GrantRole:=GrantRole + [ogReference]
        else
          RevokeRole:=RevokeRole + [ogReference];
      end;
    end;
(*
    TFireBirdRole(DBObject).SetGrantObjects(rxGrantsTableDBObjectName.AsString, GrantRole, RevokeRole);
*)
    rxGrantsTable.Next;
  end;
  Result:=DBObject.SQLScriptsApply;
  if Result then
    LoadRoleData;
end;

procedure TfbmRolesDBObjectsGrantForm.SetGrant(E: boolean);
var
  F:TField;
begin
  F:=RxDBGrid1.SelectedField;
  if (F.DataType = ftBoolean) and (rxGrantsTable.RecordCount>0) then
  begin
    rxGrantsTable.Edit;
    F.AsBoolean:=E;
    rxGrantsTable.Post;
  end;
end;

procedure TfbmRolesDBObjectsGrantForm.Localize;
begin
  inherited Localize;
  edtPrint.Caption:=sPrint;
  grnH.Caption:=sGrantForAll;
  grnL.Caption:=sGrantAll;
  grnHA.Caption:=sGrantForAllGO;
  grnHL.Caption:=sGrantAllGO;
  grnAll.Caption:=sGrantAlltoAll;
  revH.Caption:=sRevokeFromAll;
  revL.Caption:=sRevokeAll;
  revAll.Caption:=sRevokeAllFromAll;
  Label2.Caption:=sObjects;

  ComboBox1.Items.Clear;
  ComboBox1.Items.Add(sAllOobjects);
  ComboBox1.Items.Add(sTables);
  ComboBox1.Items.Add(sViews);
  ComboBox1.Items.Add(sStoredProcedures);
end;

function TfbmRolesDBObjectsGrantForm.PageName: string;
begin
  Result:=sRoleGrantForObjects;
end;

function TfbmRolesDBObjectsGrantForm.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:edtPrint.Execute;
    epaRefresh:LoadRoleData;
    epaCompile:Result:=CompileGrants;
    epaAdd:SetGrant(true);
    epaDelete:SetGrant(false);
  end;
end;

function TfbmRolesDBObjectsGrantForm.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaPrint, epaRefresh, epaCompile, epaAdd, epaDelete];
end;

procedure TfbmRolesDBObjectsGrantForm.SaveState(const SectionName: string;
  const Ini: TIniFile);
begin
  SaveRxDBGridState(SectionName+'.ObjListGrid', Ini, RxDBGrid1);
end;

procedure TfbmRolesDBObjectsGrantForm.RestoreState(const SectionName: string;
  const Ini: TIniFile);
begin
  RestoreRxDBGridState(SectionName+'.ObjListGrid', Ini, RxDBGrid1);
end;

constructor TfbmRolesDBObjectsGrantForm.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  SQLEngine:=TSQLEngineFireBird(ADBObject.OwnerDB);
  LoadRoleData;
end;

end.

