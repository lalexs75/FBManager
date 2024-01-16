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
  Classes, SysUtils, contnrs, sqlEngineTypes, SQLEngineAbstractUnit, FBSQLEngineUnit, fb_utils,
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
    FSystemPrivileges: TFBSystemPrivilegesSet;
  protected
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    class function DBClassTitle:string;override;
    procedure RefreshObject; override;
    procedure RefreshDependencies;override;
    function SetGrantUsers(AUserName:string; AGrant, WithGrantOpt:boolean):boolean;override;
    function SetGrantObjects(AObjectName:string; AddGrants, RemoveGrants:TObjectGrants):boolean;override;
    procedure GetUserList(const UserList:TStrings);override;
    procedure GetUserRight(GrantedList:TObjectList);override;

    function InternalGetDDLCreate: string; override;
    function CreateSQLObject:TSQLCommandDDL;override;
    property OwnerUser:string read FOwnerUser write FOwnerUser;
    property SystemPrivileges:TFBSystemPrivilegesSet read FSystemPrivileges write FSystemPrivileges;
  end;

  { TFireBirUser }

  TFireBirUser = class(TDBObject)
  private
    FActive: Boolean;
    FFirstName: string;
    FIsAdmin: Boolean;
    FLastName: string;
    FMiddleName: string;
    FParams: TStringList;
    FPlugin: string;
  protected
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot: TDBRootObject);override;
    destructor Destroy; override;
    procedure RefreshObject; override;
    class function DBClassTitle:string;override;
    procedure SetSqlAssistentData(const List: TStrings);override;
    function InternalGetDDLCreate: string; override;
    function CreateSQLObject:TSQLCommandDDL; override;

    property FirstName:string read FFirstName write FFirstName;
    property MiddleName:string read FMiddleName write FMiddleName;
    property LastName:string read FLastName write FLastName;
    property Active:Boolean read FActive write FActive;
    property IsAdmin:Boolean read FIsAdmin write FIsAdmin;
    property Plugin:string read FPlugin write FPlugin;
    property Params:TStringList read FParams;
  end;

implementation
uses fb_SqlParserUnit, fbSqlTextUnit, uib, ibmsqltextsunit,
  fbmSQLTextCommonUnit, fbmStrConstUnit, sqlObjects;

{ TFBSecurityRoot }

function TFBSecurityRoot.GetObjectType: string;
begin
  Result:='';
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
  iSysPRiv: Word;
  S: String;
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;

  IBQ:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(fbSqlModule.sUsers['ssqlRoleRefresh']);
  IBQ.Params.ByNameAsString['role_name']:=Caption;
  try
    IBQ.Open;
    FDescription:=TSQLEngineFireBird(OwnerDB).ConvertString20(IBQ.Fields.ByNameAsString['rdb$description'], true);
    if IBQ.Fields.TryGetFieldIndex('RDB$SYSTEM_PRIVILEGES', iSysPRiv) then
    begin
      S:=IBQ.Fields.AsRawByteString[iSysPRiv];
    end;
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
var
  FCmd: TFBSQLCreateUser;
  i: Integer;
begin
  FCmd:=TFBSQLCreateUser.Create(nil);
  FCmd.Name:=Caption;
  FCmd.FirstName:=FFirstName;
  FCmd.MiddleName:=FMiddleName;
  FCmd.LastName:=FLastName;
  if Active then
    FCmd.State:=trsActive
  else
    FCmd.State:=trsInactive;
  FCmd.PluginName:=FPlugin;
  if IsAdmin then
    FCmd.GrantOptions:=goGrant;
  FCmd.Description:=Description;

  for i:=0 to FParams.Count-1 do
    FCmd.Params.AddParamEx(FParams.Names[i], FParams.ValueFromIndex[i]);
  Result:=FCmd.AsSQL;
  FreeAndNil(FCmd);
end;

constructor TFireBirUser.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  FParams:=TStringList.Create;
end;

destructor TFireBirUser.Destroy;
begin
  FreeAndNil(FParams);
  inherited Destroy;
end;

procedure TFireBirUser.RefreshObject;
var
  IBQ, IBQ1: TUIBQuery;
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;
  FParams.Clear;

  IBQ:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(fbSqlModule.sUsers['FBUserDetails']);
  IBQ.Params.ByNameAsString['USER_NAME']:=Caption;

  IBQ1:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(fbSqlModule.sUsers['FBUserDetailAtribs']);
  try
    IBQ.Open;
    FActive:=IBQ.Fields.ByNameAsBoolean['SEC$ACTIVE'];
    FFirstName:=TrimRight(IBQ.Fields.ByNameAsString['SEC$FIRST_NAME']);
    FIsAdmin:=IBQ.Fields.ByNameAsBoolean['SEC$ADMIN'];
    FLastName:=TrimRight(IBQ.Fields.ByNameAsString['SEC$LAST_NAME']);
    FMiddleName:=TrimRight(IBQ.Fields.ByNameAsString['SEC$MIDDLE_NAME']);
    FPlugin:=TrimRight(IBQ.Fields.ByNameAsString['SEC$PLUGIN']);
    FDescription:=TSQLEngineFireBird(OwnerDB).ConvertString20(TrimRight(IBQ.Fields.ByNameAsString['SEC$DESCRIPTION']), true);

    IBQ1.Params.ByNameAsString['USER_NAME']:=Caption;
    IBQ1.Params.ByNameAsString['PLUGIN']:=FPlugin;
    IBQ1.Open;
    while not IBQ1.Fields.Eof do
    begin
      FParams.AddPair(TrimRight(IBQ1.Fields.ByNameAsString['SEC$KEY']), TrimRight(IBQ1.Fields.ByNameAsString['SEC$VALUE']));
      //SEC$USER_NAME,
      //SEC$PLUGIN
      IBQ1.Next;
    end;
    IBQ1.Close;

  finally
    IBQ1.Free;
    IBQ.Free;
  end;
end;

class function TFireBirUser.DBClassTitle: string;
begin
  Result:='User';
end;

procedure TFireBirUser.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;

function TFireBirUser.CreateSQLObject: TSQLCommandDDL;
begin
  if State = sdboCreate then
    Result:=TFBSQLCreateUser.Create(nil)
  else
    Result:=TFBSQLAlterUser.Create(nil);
  Result.Name:=Caption;
end;

end.

