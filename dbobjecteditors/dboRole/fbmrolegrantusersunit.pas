{ Free DB Manager

  Copyright (C) 2005-2018 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fbmRoleGrantUsersUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, db, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, Menus, ActnList, rxdbgrid, rxmemds, RxDBGridPrintGrid, LR_PGrid,
  DBGrids, LMessages, fdmAbstractEditorUnit, SQLEngineAbstractUnit,
  fbmToolsUnit, LR_Class, IniFiles;

type

  { TfbmRoleGrantUsersFrame }

  TfbmRoleGrantUsersFrame = class(TEditorPage)
    edtPrint: TAction;
    edtCompile: TAction;
    edtRefresh: TAction;
    ActionList1: TActionList;
    dsUsersTable: TDatasource;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    PopupMenu1: TPopupMenu;
    RxDBGrid2: TRxDBGrid;
    RxDBGridPrint1: TRxDBGridPrint;
    rxUsersTable: TRxMemoryData;
    rxUsersTableGRANT: TBooleanField;
    rxUsersTableGRANT_USER_NAME: TStringField;
    rxUsersTableG_A: TBooleanField;
    rxUsersTableOLD_G: TBooleanField;
    rxUsersTableOLD_G_A: TBooleanField;
    rxUsersTableUSER_NAME: TStringField;
    procedure edtPrintExecute(Sender: TObject);
    procedure edtRefreshExecute(Sender: TObject);
    procedure rxUsersTableAfterInsert(DataSet: TDataSet);
    procedure rxUsersTableAfterPost(DataSet: TDataSet);
  private
    SQLEngine:TSQLEngineAbstract;
    procedure DoCreateUserGrTable;
    procedure LMEditorChangeParams(var message: TLMNoParams); message LM_EDITOR_CHANGE_PARMAS;
    function CompileGrants:boolean;
    procedure FillUserGrants;
    procedure SetGrant(AGrant:boolean);
  public
    procedure Localize;override;
    function PageName:string;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    procedure SaveState(const SectionName:string; const Ini:TIniFile);override;
    procedure RestoreState(const SectionName:string; const Ini:TIniFile);override;
    procedure Activate;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
  end;

var
  fbmRoleGrantUsersFrame: TfbmRoleGrantUsersFrame;

implementation
uses fbmStrConstUnit, fb_utils, ibmsqltextsunit, contnrs, SQLEngineCommonTypesUnit;

{$R *.lfm}

{ TfbmRoleGrantUsersFrame }

procedure TfbmRoleGrantUsersFrame.rxUsersTableAfterInsert(DataSet: TDataSet);
begin
  rxUsersTableGRANT.AsBoolean:=false;
  rxUsersTableG_A.AsBoolean:=false;
end;

procedure TfbmRoleGrantUsersFrame.rxUsersTableAfterPost(DataSet: TDataSet);
begin
  if (rxUsersTableGRANT.AsBoolean<>rxUsersTableOLD_G.AsBoolean) or (rxUsersTableG_A.AsBoolean<>rxUsersTableOLD_G_A.AsBoolean) then
    TDBUsersGroup(DBObject).SetGrantUsers(rxUsersTableUSER_NAME.AsString, rxUsersTableGRANT.AsBoolean, rxUsersTableG_A.AsBoolean);
end;

procedure TfbmRoleGrantUsersFrame.edtPrintExecute(Sender: TObject);
begin
  RxDBGridPrint1.PreviewReport;
end;

procedure TfbmRoleGrantUsersFrame.edtRefreshExecute(Sender: TObject);
begin
  DoCreateUserGrTable;
end;

procedure TfbmRoleGrantUsersFrame.DoCreateUserGrTable;
var
  i:integer;
  Items:TStringList;
begin
  Items:=TStringList.Create;
  TDBUsersGroup(DBObject).GetUserList(Items);

  rxUsersTable.AfterPost:=nil;
  rxUsersTable.CloseOpen;
  try
    for i:=0 to Items.Count -1 do
    begin
      rxUsersTable.Append;
      rxUsersTableUSER_NAME.AsString:=Items[i];
      rxUsersTable.Post;
    end;
    FillUserGrants;
  finally
    Items.Free;
  end;
  rxUsersTable.First;
  rxUsersTable.AfterPost:=@rxUsersTableAfterPost;
end;

procedure TfbmRoleGrantUsersFrame.LMEditorChangeParams(var message: TLMNoParams
  );
begin
  inherited;
  SetRxDBGridOptions(RxDBGrid2);
end;

function TfbmRoleGrantUsersFrame.CompileGrants:boolean;
begin
  Result:=true;
  DBObject.SQLScriptsBegin;
  rxUsersTable.First;
  while not rxUsersTable.EOF do
  begin
    if rxUsersTableGRANT.AsBoolean<>rxUsersTableOLD_G.AsBoolean then
      TDBUsersGroup(DBObject).SetGrantUsers(rxUsersTableUSER_NAME.AsString, rxUsersTableGRANT.AsBoolean, rxUsersTableG_A.AsBoolean);
    rxUsersTable.Next;
  end;
  Result:=DBObject.SQLScriptsApply;
  DoCreateUserGrTable;
end;

procedure TfbmRoleGrantUsersFrame.FillUserGrants;
var
  GrantedList:TObjectList;
  i:integer;
  M:TUserRoleGrant;
begin
  GrantedList:=TObjectList.Create;
  try
    rxUsersTable.DisableControls;
    TDBUsersGroup(DBObject).GetUserRight(GrantedList);
    for i:=0 to GrantedList.Count -1 do
    begin
      M:=TUserRoleGrant(GrantedList[i]);
      if rxUsersTable.Locate('USER_NAME', M.UserName, []) then
      begin
        rxUsersTable.Edit;
        rxUsersTableGRANT.AsBoolean:=true;
        rxUsersTableOLD_G.AsBoolean:=true;
        rxUsersTableGRANT_USER_NAME.AsString:=M.GrantUserName;
        rxUsersTableG_A.AsBoolean:=M.WithAdmOpt;
        rxUsersTable.Post;
      end;
    end;
  finally
    rxUsersTable.First;
    rxUsersTable.EnableControls;
    GrantedList.Free;
  end;
end;

procedure TfbmRoleGrantUsersFrame.SetGrant(AGrant: boolean);
begin
  if rxUsersTable.RecordCount = 0 then exit;
  rxUsersTable.Edit;
  rxUsersTableGRANT.AsBoolean:=AGrant;
  rxUsersTable.Post;
end;

procedure TfbmRoleGrantUsersFrame.Localize;
begin
  inherited Localize;
  edtCompile.Caption:=sCompile;
  edtRefresh.Caption:=sRefresh;
  edtPrint.Caption:=sPrint;

  RxDBGrid2.ColumnByFieldName('USER_NAME').Title.Caption:=sUserName1;
  RxDBGrid2.ColumnByFieldName('GRANT').Title.Caption:=sGrant;
  RxDBGrid2.ColumnByFieldName('G_A').Title.Caption:=sWithGrantOptions;
  RxDBGrid2.ColumnByFieldName('GRANT_USER_NAME').Title.Caption:=sGrantor;
end;

function TfbmRoleGrantUsersFrame.PageName: string;
begin
  Result:=sRoleGrantForUser;
end;

function TfbmRoleGrantUsersFrame.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:edtPrint.Execute;
    epaRefresh:DoCreateUserGrTable;
    epaAdd:SetGrant(true);
    epaDelete:SetGrant(false);
  end;
end;

function TfbmRoleGrantUsersFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaPrint, epaRefresh, epaAdd, epaDelete];
end;

procedure TfbmRoleGrantUsersFrame.SaveState(const SectionName: string;
  const Ini: TIniFile);
begin
  SaveRxDBGridState(SectionName+'.UserGrants', Ini, RxDBGrid2);
end;

procedure TfbmRoleGrantUsersFrame.RestoreState(const SectionName: string;
  const Ini: TIniFile);
begin
  RestoreRxDBGridState(SectionName+'.UserGrants', Ini, RxDBGrid2);
end;

procedure TfbmRoleGrantUsersFrame.Activate;
begin
  DoCreateUserGrTable;
end;

constructor TfbmRoleGrantUsersFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  SQLEngine:=ADBObject.OwnerDB;
end;

end.

