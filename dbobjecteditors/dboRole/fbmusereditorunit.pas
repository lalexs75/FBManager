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

unit fbmUserEditorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  pgTypes,
  ExtCtrls, Spin, rxtooledit, RxTimeEdit, fdmAbstractEditorUnit, SQLEngineAbstractUnit,
  PostgreSQLEngineUnit, IniFiles, fbmSqlParserUnit, pgSqlEngineSecurityUnit, pg_SqlParserUnit;

type

  { TfbmUserEditorForm }

  TfbmUserEditorForm = class(TEditorPage)
    CheckBox1: TCheckBox;
    cbPwdNewer: TCheckBox;
    cgUserRigth: TCheckGroup;
    edtUserName: TEdit;
    edtObjID: TEdit;
    edtPwd: TEdit;
    edtPwdConfirm: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtPwdDate: TRxDateEdit;
    edtPwdTime: TRxTimeEdit;
    SpinEdit1: TSpinEdit;
    procedure cbPwdNewerChange(Sender: TObject);
    procedure cgUserRigthItemClick(Sender: TObject; Index: integer);
  private
    SQLEngine:TSQLEnginePostgre;
    procedure LoadUserData;
//    function CompileUser:boolean;
    procedure PrintUserCard;
    function UserOptions:TPGUserOptions;
  public
    function PageName:string;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    procedure SaveState(const SectionName:string; const Ini:TIniFile);override;
    procedure RestoreState(const SectionName:string; const Ini:TIniFile);override;
    procedure Localize;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses fbmToolsUnit, fbmStrConstUnit;

{$R *.lfm}

{ TfbmUserEditorForm }

procedure TfbmUserEditorForm.cbPwdNewerChange(Sender: TObject);
begin
  edtPwdDate.Enabled:=not cbPwdNewer.Checked;
  edtPwdTime.Enabled:=not cbPwdNewer.Checked;
end;

procedure TfbmUserEditorForm.cgUserRigthItemClick(Sender: TObject;
  Index: integer);
begin
  if (Index = 1) and cgUserRigth.Checked[1] then
    cgUserRigth.Checked[4]:=true;
end;

procedure TfbmUserEditorForm.LoadUserData;
begin

  DBObject.RefreshObject;

  edtUserName.Text:=DBObject.Caption;
  edtObjID.Text:=IntToStr(TPGUser(DBObject).UserID);

  CheckBox1.Checked:=puoLoginEnabled in TPGUser(DBObject).UserOptions;

  cgUserRigth.Checked[0]:=puoInheritedRight in TPGUser(DBObject).UserOptions;
  cgUserRigth.Checked[1]:=puoSuperuser in TPGUser(DBObject).UserOptions;
  cgUserRigth.Checked[2]:=puoCreateDatabaseObjects in TPGUser(DBObject).UserOptions;
  cgUserRigth.Checked[3]:=puoCreateRoles in TPGUser(DBObject).UserOptions;
  cgUserRigth.Checked[4]:=puoChangeSystemCatalog in TPGUser(DBObject).UserOptions;
  cgUserRigth.Checked[5]:=puoReplication in TPGUser(DBObject).UserOptions;

  cbPwdNewer.Checked:=puoNeverExpired in TPGUser(DBObject).UserOptions;
  if not cbPwdNewer.Checked then
  begin
    edtPwdDate.Date:=TPGUser(DBObject).PwdValidDate;
    edtPwdTime.Time:=TPGUser(DBObject).PwdValidDate;
  end;
  SpinEdit1.Value:=TPGUser(DBObject).ConnectionsLimit;
end;
(*
function TfbmUserEditorForm.CompileUser:boolean;
var
  AUserOptions:TPGUserOptions;
begin
  AUserOptions:=[puoLoginEnabled];

  if cgUserRigth.Checked[0] then
    AUserOptions:=AUserOptions + [puoInheritedRight];
  if cgUserRigth.Checked[1] then
    AUserOptions:=AUserOptions + [puoSuperuser];
  if cgUserRigth.Checked[2] then
    AUserOptions:=AUserOptions + [puoCreateDatabaseObjects];
  if cgUserRigth.Checked[3] then
    AUserOptions:=AUserOptions + [puoCreateRoles];
  if cgUserRigth.Checked[4] then
    AUserOptions:=AUserOptions + [puoChangeSystemCatalog];
  if cgUserRigth.Checked[5] then
    AUserOptions:=AUserOptions + [puoCreateReplications];

  if cbPwdNewer.Checked then
    AUserOptions:=AUserOptions + [puoNeverExpired];

  Result:=false;
  if (edtPwd.Text<>'') and (edtPwd.Text <> edtPwdConfirm.Text) then
  begin
    ErrorBox(sPasswordMismath);
    exit;
  end;
  Result:=TPGUser(DBObject).CompileUser(edtUserName.Text, edtPwd.Text, AUserOptions, edtPwdDate.Date, SpinEdit1.Value);
end;
*)
procedure TfbmUserEditorForm.PrintUserCard;
begin
  { TODO : Необходимо реализовать печать карточки оператора Postgre }
  NotCompleteFunction;
end;

function TfbmUserEditorForm.UserOptions: TPGUserOptions;
begin
    Result:=[puoLoginEnabled];

  if cgUserRigth.Checked[0] then
    Result:=Result + [puoInheritedRight];
  if cgUserRigth.Checked[1] then
    Result:=Result + [puoSuperuser];
  if cgUserRigth.Checked[2] then
    Result:=Result + [puoCreateDatabaseObjects];
  if cgUserRigth.Checked[3] then
    Result:=Result + [puoCreateRoles];
  if cgUserRigth.Checked[4] then
    Result:=Result + [puoChangeSystemCatalog];
  if cgUserRigth.Checked[5] then
    Result:=Result + [puoReplication];

  if cbPwdNewer.Checked then
    Result:=Result + [puoNeverExpired];

end;

function TfbmUserEditorForm.PageName: string;
begin
  Result:='User name';
end;

function TfbmUserEditorForm.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:PrintUserCard;
    epaRefresh:LoadUserData;
    //epaCompile:Result:=CompileUser;
  end;
end;

function TfbmUserEditorForm.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaPrint, epaRefresh, epaCompile];
end;

procedure TfbmUserEditorForm.SaveState(const SectionName: string;
  const Ini: TIniFile);
begin
  inherited SaveState(SectionName, Ini);
end;

procedure TfbmUserEditorForm.RestoreState(const SectionName: string;
  const Ini: TIniFile);
begin
  inherited RestoreState(SectionName, Ini);
end;

procedure TfbmUserEditorForm.Localize;
begin
  Label1.Caption:=sPGUSerName;
  Label2.Caption:=sObjectID;
  Label5.Caption:=sPGValidUntil;
  Label6.Caption:=sPGMaxConnection;
  cbPwdNewer.Caption:=sPGNeverExpired;
  Label3.Caption:=sPGPassword;
  Label4.Caption:=sPGConfirmPassword;
  cgUserRigth.Caption:=sPGRolePrivilege;
  cgUserRigth.Items.BeginUpdate;
  cgUserRigth.Items.Clear;
  cgUserRigth.Items.Add(sPGInheritedRight);
  cgUserRigth.Items.Add(sPGSuperuser);
  cgUserRigth.Items.Add(sPGAllowCreateDBObjects);
  cgUserRigth.Items.Add(sPGAllowCreateRoles);
  cgUserRigth.Items.Add(sPGAllowChangeSystemCatalog);
  cgUserRigth.Items.Add(sPGAllowCreateReplications);
  cgUserRigth.Items.EndUpdate;
end;

constructor TfbmUserEditorForm.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  cbPwdNewer.Checked:=true;
  SQLEngine:=TSQLEnginePostgre(ADBObject.OwnerDB);
  LoadUserData;
  cgUserRigth.CheckEnabled[4]:=SQLEngine.ServerVersion < pgVersion9_6;
end;

function TfbmUserEditorForm.SetupSQLObject(ASQLObject: TSQLCommandDDL): boolean;
var
  CU: TPGSQLCreateRole;
begin
  if DBObject.State = sdboEdit then
  begin;
    if not (ASQLObject is TPGSQLAlterUser) then Exit;

  end
  else
  if DBObject.State = sdboCreate then
  begin
    if not (ASQLObject is TPGSQLCreateRole) then Exit;
    CU:=TPGSQLCreateRole(ASQLObject);
    CU.Name:=edtUserName.Text;
    CU.UserOptions:=UserOptions;
    CU.Password:=edtPwd.Text;
    CU.ConnectionLimit:=SpinEdit1.Value;
    Result:=True;
  end;
end;

end.

