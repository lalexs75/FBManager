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

unit FBSQLEngineSecurityUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, contnrs, SQLEngineAbstractUnit, FBSQLEngineUnit,
  SQLEngineCommonTypesUnit, SQLEngineInternalToolsUnit, fbmSqlParserUnit;

type
  TFBRoleRoot = class;
  TFBUsersRoot = class;

  { TFBSecurityRoot }

  TFBSecurityRoot = class(TDBRootObject)
  private
    FFBRolesRoot: TFBRoleRoot;
    FFBUsersRoot: TFBUsersRoot;
  protected
  public
    function GetObjectType: string;override;
    procedure RefreshGroup; override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    destructor Destroy; override;
    procedure Clear;override;
    property FBRolesRoot:TFBRoleRoot read FFBRolesRoot;
    property FBUsersRoot:TFBUsersRoot read FFBUsersRoot;
  end;

  { TFBUsersRoot }

  TFBUsersRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TFBRoleRoot }

  TFBRoleRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TFireBirdRole }

  TFireBirdRole = class(TDBUsersGroup)
  private
    FOwnerUser: string;
  protected
    function InternalGetDDLCreate: string; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    class function DBClassTitle:string;override;
    procedure RefreshObject; override;
    procedure RefreshDependencies;override;
    function SetGrantUsers(AUserName:string; AGrant, WithGrantOpt:boolean):boolean;override;
    function SetGrantObjects(AObjectName:string; AddGrants, RemoveGrants:TObjectGrants):boolean;override;
    procedure GetUserList(const UserList:TStrings);override;
    procedure GetUserRight(GrantedList:TObjectList);override;

    function CreateSQLObject:TSQLCommandDDL;override;
    property OwnerUser:string read FOwnerUser write FOwnerUser;
  end;

  { TFireBirUser }

  TFireBirUser = class(TDBObject)
  private
  protected
    function InternalGetDDLCreate: string; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot: TDBRootObject);override;
    destructor Destroy; override;
    procedure RefreshObject; override;
    class function DBClassTitle:string;override;
    procedure SetSqlAssistentData(const List: TStrings);override;
    function CreateSQLObject:TSQLCommandDDL; override;
  end;

implementation
uses fb_SqlParserUnit, fbSqlTextUnit, uib, ibmsqltextsunit,
  fbmSQLTextCommonUnit, fbmStrConstUnit, sqlObjects;

{ TFBSecurityRoot }

function TFBSecurityRoot.GetObjectType: string;
begin

end;

procedure TFBSecurityRoot.RefreshGroup;
begin
  inherited RefreshGroup;
end;

constructor TFBSecurityRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okUser;
  FFBRolesRoot:=TFBRoleRoot.Create(AOwnerDB, TFireBirdRole, sRoles, Self);
  FFBUsersRoot:=TFBUsersRoot.Create(AOwnerDB, TFireBirUser, sUsers, Self);
end;

destructor TFBSecurityRoot.Destroy;
begin
  FreeAndNil(FFBRolesRoot);
  FreeAndNil(FFBUsersRoot);
  inherited Destroy;
end;

procedure TFBSecurityRoot.Clear;
begin
  FBRolesRoot.Clear;
  FBUsersRoot.Clear;
end;

{ TFBUsersRoot }

function TFBUsersRoot.DBMSObjectsList: string;
begin
  Result:=fbSqlModule.sUsers['FBUsers'];
end;

function TFBUsersRoot.GetObjectType: string;
begin
  Result:='User';
end;

constructor TFBUsersRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okUser;
  FDropCommandClass:=TFBSQLDropUser;
end;

{ TFBRoleRoot }

function TFBRoleRoot.DBMSObjectsList: string;
begin
  Result:=fbSqlModule.sUsers['FBRoles'];
end;

function TFBRoleRoot.GetObjectType: string;
begin
  Result:='Role';
end;

constructor TFBRoleRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okRole;
  FDropCommandClass:=TFBSQLDropRole;
end;

{ TFireBirdRole }

function TFireBirdRole.InternalGetDDLCreate: string;
var
  FCmd: TFBSQLCreateRole;
begin
  FCmd:=TFBSQLCreateRole.Create(nil);
  FCmd.Name:=Caption;
  FCmd.Description:=Description;
  Result:=FCmd.AsSQL;
  FCmd.Free;
end;

constructor TFireBirdRole.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
    FOwnerUser:=ADBItem.ObjData;
end;

procedure TFireBirdRole.RefreshObject;
var
  IBQ:TUIBQuery;
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;

  IBQ:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(ssqlRoleRefresh);
  IBQ.Params.ByNameAsString['role_name']:=Caption;
  try
    IBQ.Open;
    FDescription:=TSQLEngineFireBird(OwnerDB).ConvertString20(IBQ.Fields.ByNameAsString['rdb$description'], true);
  finally
    IBQ.Free;
  end;
end;

procedure TFireBirdRole.RefreshDependencies;
begin
  TSQLEngineFireBird(OwnerDB).RefreshDependencies(Self);
end;

function TFireBirdRole.SetGrantUsers(AUserName:string; AGrant, WithGrantOpt:boolean):boolean;
var
  S:string;
begin
  if AGrant then
  begin
    if WithGrantOpt then
      S:=Format(ssqlRoleGranrToUserWGR, [UpperCase(Caption), UpperCase(AUserName)])
    else
      S:=Format(ssqlRoleGranrToUser, [UpperCase(Caption), UpperCase(AUserName)])
  end
  else
    S:=Format(ssqlRoleGranrFromUser, [UpperCase(Caption), UpperCase(AUserName)]);

  Result:=SQLScriptsExec(S, []);
end;

function TFireBirdRole.SetGrantObjects(AObjectName: string; AddGrants,
  RemoveGrants: TObjectGrants): boolean;
begin
  Result:=true;
  { TODO : Заменить на вызов объекта }
  if (RemoveGrants <> []) then
  begin
    if ogExecute in RemoveGrants then
      Result:=SQLScriptsExec(Format(ssqlRoleGrantFromObjectProc,
           [ObjectGrantToStr(RemoveGrants, true), AObjectName, Caption]), [])
    else
      Result:=SQLScriptsExec(Format(ssqlRoleGrantFromObject,
           [ObjectGrantToStr(RemoveGrants, true), AObjectName, Caption]), []);
  end;

  if Result and (AddGrants<>[]) then
  begin
    if ogExecute in AddGrants then
      Result:=SQLScriptsExec(Format(ssqlRoleGrantToObjectProc,
           [ObjectGrantToStr(AddGrants, true), AObjectName, Caption]), [])
    else
      Result:=SQLScriptsExec(Format(ssqlRoleGrantToObject,
           [ObjectGrantToStr(AddGrants, true), AObjectName, Caption]), []);
  end;
end;

procedure TFireBirdRole.GetUserList(const UserList: TStrings);
var
  i:integer;
  UIBSecurity1:TUIBSecurity;
begin
  UIBSecurity1:=TUIBSecurity.Create(nil);
  UIBSecurity1.LibraryName:=TSQLEngineFireBird(OwnerDB).FBDatabase.LibraryName;
  UIBSecurity1.UserName:=OwnerDB.UserName;
  UIBSecurity1.PassWord:=OwnerDB.Password;
  UIBSecurity1.Host:=OwnerDB.ServerName;
  UIBSecurity1.Protocol:=TSQLEngineFireBird(OwnerDB).Protocol;
  UserList.Clear;
  try
    UIBSecurity1.DisplayUsers;
    for i:=0 to UIBSecurity1.UserInfoCount -1 do
      UserList.Add(UIBSecurity1.UserInfo[i].UserName);
  finally
    UIBSecurity1.Free;
  end;
end;

procedure TFireBirdRole.GetUserRight(GrantedList:TObjectList);
var
  Q:TUIBQuery;
  R:TUserRoleGrant;
begin
  Q:=TSQLEngineFireBird(OwnerDB).GetUIBQuery( fbSqlModule.sSqlGrantForObj.ExpandMacros);
  Q.Params.ByNameAsString['obj_name']:=Caption;
  Q.Open;
  while not Q.Eof do
  begin
    R:=TUserRoleGrant.Create;
    GrantedList.Add(R);
    R.UserName:=Trim(Q.Fields.ByNameAsString['RDB$USER']);
    R.WithAdmOpt:=Q.Fields.ByNameAsInteger['RDB$GRANT_OPTION'] <> 0;
    Q.Next;
  end;
  Q.Free;
end;

function TFireBirdRole.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=TFBSQLCreateRole.Create(nil);
  Result.Name:=Caption;
end;

class function TFireBirdRole.DBClassTitle: string;
begin
  Result:='ROLE';
end;

{ TFireBirUser }

function TFireBirUser.InternalGetDDLCreate: string;
begin
  Result:=inherited InternalGetDDLCreate;
end;

constructor TFireBirUser.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
end;

destructor TFireBirUser.Destroy;
begin
  inherited Destroy;
end;

procedure TFireBirUser.RefreshObject;
begin
  inherited RefreshObject;
end;

class function TFireBirUser.DBClassTitle: string;
begin
  Result:=inherited DBClassTitle;
end;

procedure TFireBirUser.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;

function TFireBirUser.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=inherited CreateSQLObject;
end;

end.
