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

unit pgSqlEngineSecurityUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, contnrs, sqlEngineTypes, SQLEngineAbstractUnit, PostgreSQLEngineUnit,
  SQLEngineCommonTypesUnit, SQLEngineInternalToolsUnit, fbmSqlParserUnit,
  pgTypes;

type
  TPGGroupsRoot = class;
  TPGUsersRoot = class;

  { TPGSecurityRoot }

  TPGSecurityRoot = class(TDBRootObject)
  private
    FPGGroupsRoot:TPGGroupsRoot;
    FPGUsersRoot:TPGUsersRoot;
  protected
  public
    function GetObjectType: string;override;
    procedure RefreshGroup; override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    destructor Destroy; override;
    procedure Clear;override;
    property PGGroupsRoot:TPGGroupsRoot read FPGGroupsRoot;
    property PGUsersRoot:TPGUsersRoot read FPGUsersRoot;
  end;

  { TPGUsersRoot }

  TPGUsersRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TPGGroupsRoot }

  TPGGroupsRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TPGUser }

  TPGUser = class(TDBObject)
  private
    FConnectionsLimit: integer;
    FSecurityRoot:TPGUsersRoot;
    FPwdValidDate:TDateTime;   //Password expired date
    FUserID:integer;
    FUserOptions:TPGUserOptions;
  protected
    function InternalGetDDLCreate: string; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot: TDBRootObject);override;
    destructor Destroy; override;
    procedure RefreshObject; override;
    class function DBClassTitle:string;override;
    procedure SetSqlAssistentData(const List: TStrings);override;
    function CreateSQLObject:TSQLCommandDDL; override;

    property SecurityRoot:TPGUsersRoot read FSecurityRoot;
    property PwdValidDate:TDateTime read FPwdValidDate write FPwdValidDate;           //Password expired date
    property UserID:integer read FUserID;
    property UserOptions:TPGUserOptions read FUserOptions;
    property ConnectionsLimit:integer read FConnectionsLimit;
  end;

  { TPGGroup }

  TPGGroup = class(TDBUsersGroup)
  private
    FConnectionsLimit: integer;
    FPwdValidDate: TDateTime;
    FSecurityRoot:TPGGroupsRoot;
    FOID:integer;
    FUserOptions: TPGUserOptions;
  protected
    function InternalGetDDLCreate: string; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot: TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure RefreshObject; override;

    function CreateSQLObject:TSQLCommandDDL; override;

    function SetGrantUsers(AUserName:string; AGrant, WithGrantOpt:boolean):boolean;override;
    function SetGrantObjects(AObjectName:string; AddGrants, RemoveGrants:TObjectGrants):boolean;override;
    procedure GetUserList(const UserList:TStrings);override;
    procedure GetUserRight(GrantedList:TObjectList);override;

    procedure SetSqlAssistentData(const List: TStrings);override;
    property SecurityRoot:TPGGroupsRoot read FSecurityRoot;
    property ObjID:integer read FOID;
    property UserOptions:TPGUserOptions read FUserOptions;
    property PwdValidDate:TDateTime read FPwdValidDate write FPwdValidDate;           //Password expired date
    property ConnectionsLimit:integer read FConnectionsLimit;
  end;

implementation
uses fbmStrConstUnit, ZDataset, pgSqlTextUnit, sqlObjects, Math,
  fbmSQLTextCommonUnit, pg_SqlParserUnit, pg_utils;
(*

function PGUserOptionsToStr(const AUserOptions: TPGUserOptions;
  const ExpDate:TDateTime; AConnectionsLimit:integer; const ARoleName, ARolePwd:string): string;
begin
  Result:='';

  if ARolePwd<>'' then
    Result:=Result + ' WITH PASSWORD '''+ARolePwd+'''';

  if puoLoginEnabled in AUserOptions then
    Result:=Result + ' LOGIN'
  else
    Result:=Result + ' NOLOGIN';


  if puoInheritedRight in AUserOptions then
    Result:=Result + ' INHERIT'
  else
    Result:=Result + ' NOINHERIT';

  if puoSuperuser in AUserOptions then
    Result:=Result + ' SUPERUSER'
  else
    Result:=Result + ' NOSUPERUSER';

  if puoCreateDatabaseObjects in AUserOptions then
    Result:=Result + ' CREATEDB'
  else
    Result:=Result + ' NOCREATEDB'
    ;

  if puoCreateRoles in AUserOptions then
    Result:=Result + ' CREATEROLE'
  else
    Result:=Result + ' NOCREATEROLE';

  if puoCreateReplications in AUserOptions then
    Result:=Result + ' REPLICATION'
  else
    Result:=Result + ' NOREPLICATION';

  if puoNeverExpired in AUserOptions then
    Result:=Result + ' VALID UNTIL ''infinity'''
  else
    Result:=Result + ' VALID UNTIL '''+DateTimeToStr(ExpDate)+'''';

  Result:=Result + ' CONNECTION LIMIT '+IntToStr(AConnectionsLimit);

  Result:=Result + ';' + LineEnding+LineEnding;

  if (not (puoChangeSystemCatalog in AUserOptions)) or (not (puoSuperuser in AUserOptions)) then
    Result:=Result  +  'UPDATE pg_authid SET rolcatupdate=false WHERE rolname='''+ARoleName+''';'
  else
  if (puoChangeSystemCatalog in AUserOptions) then
    Result:=Result + 'UPDATE pg_authid SET rolcatupdate=true WHERE rolname='''+ARoleName+''';'
end;
*)
{ TPGSecurityRoot }

function TPGSecurityRoot.GetObjectType: string;
begin
  Result:='Security';
end;

procedure TPGSecurityRoot.RefreshGroup;
begin

end;

constructor TPGSecurityRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okUser;
  FPGGroupsRoot:=TPGGroupsRoot.Create(AOwnerDB, TPGGroup, sGroups, Self);
  FPGUsersRoot:=TPGUsersRoot.Create(AOwnerDB, TPGUser, sUsers, Self);
end;

destructor TPGSecurityRoot.Destroy;
begin
  FreeAndNil(FPGGroupsRoot);
  FreeAndNil(FPGUsersRoot);
  inherited Destroy;
end;

procedure TPGSecurityRoot.Clear;
begin
  FPGGroupsRoot.Clear;
  FPGUsersRoot.Clear;
end;

{ TPGUser }
function TPGUser.InternalGetDDLCreate: string;
var
  FCmd: TPGSQLCreateRole;
begin
  FCmd:=TPGSQLCreateRole.Create(nil);
  FCmd.ObjectKind:=DBObjectKind;
  FCmd.Name:=Caption;
  FCmd.UserOptions:=FUserOptions;
  FCmd.ConnectionLimit:=FConnectionsLimit;
  //FCmd.Password:=;
  //FCmd.PasswordEncripted:=;
  if not (puoNeverExpired in FUserOptions) then
    FCmd.ValidUntil:=DateToStr(FPwdValidDate);
  FCmd.Description:=Description;
  Result:=FCmd.AsSQL;
  FreeAndNil(FCmd);
end;

constructor TPGUser.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
    FUserID:=ADBItem.ObjId;
  FUserOptions:=[puoInheritedRight, puoNeverExpired, puoLoginEnabled];
  FConnectionsLimit:=-1;
end;

destructor TPGUser.Destroy;
begin
  inherited Destroy;
end;

procedure TPGUser.RefreshObject;
var
  Q:TZQuery;
begin
  if State <> sdboEdit then exit;
  inherited RefreshObject;

  Q:=TSQLEnginePostgre(OwnerDB).GetSqlQuery(pgSqlTextModule.sRoleAndUser['sPGRoleParams']);
  try
    Q.ParamByName('rolname').AsString:=Caption;
    Q.Open;
    if Q.RecordCount>0 then
    begin
      FDescription:=Q.FieldByName('description').AsString;
      FUserOptions:=[puoLoginEnabled];

      if (Q.FieldByName('rolvaliduntil').IsNull) or (Q.FieldByName('rolvaliduntil').AsDateTime > EncodeDate(9999,12,31)) or
        (Q.FieldByName('validuntilinfinity').AsBoolean) then
      begin
        FPwdValidDate:=0;
        FUserOptions:=FUserOptions + [puoNeverExpired]
      end
      else
        FPwdValidDate:=Q.FieldByName('rolvaliduntil').AsDateTime;
      if Q.FieldByName('rolsuper').AsBoolean then
        FUserOptions:=FUserOptions + [puoSuperuser];

      if Q.FieldByName('rolinherit').AsBoolean then
        FUserOptions:=FUserOptions + [puoInheritedRight];

      if Q.FieldByName('rolcreatedb').AsBoolean then
        FUserOptions:=FUserOptions + [puoCreateDatabaseObjects];

      if Q.FieldByName('rolcreaterole').AsBoolean then
        FUserOptions:=FUserOptions + [puoCreateRoles];

      if Q.FieldByName('rolcreaterole').AsBoolean then
        FUserOptions:=FUserOptions + [puoCreateRoles];

      if TSQLEnginePostgre(OwnerDB).RealServerVersion < 0009006 then
      begin
        if Q.FieldByName('rolcatupdate').AsBoolean then
          FUserOptions:=FUserOptions + [puoChangeSystemCatalog];
      end;

      if Q.FieldByName('rolreplication').AsBoolean then
        FUserOptions:=FUserOptions + [puoReplication];

      FConnectionsLimit:=Q.FieldByName('rolconnlimit').AsInteger;
    end;
  finally
    Q.Free;
  end;
end;

class function TPGUser.DBClassTitle: string;
begin
  Result:='User';
end;


procedure TPGUser.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;


function TPGUser.CreateSQLObject: TSQLCommandDDL;
begin
  if State = sdboCreate then
  begin
    Result:=TPGSQLCreateRole.Create(nil);
    Result.ObjectKind:=okUser;
  end
  else
  begin
    Result:=TPGSQLAlterRole.Create(nil);
    Result.ObjectKind:=okUser;
    Result.Name:=Caption;
  end;
end;

{ TPGUsersRoot }

function TPGUsersRoot.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.sRoleAndUser['sPGUsers'];
end;

function TPGUsersRoot.GetObjectType: string;
begin
  Result:='Users';
end;

constructor TPGUsersRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okUser;
  FDropCommandClass:=TPGSQLDropGroup;
end;


{ TPGGroupsRoot }

function TPGGroupsRoot.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.sRoleAndUser['sPGGroups'];
end;

function TPGGroupsRoot.GetObjectType: string;
begin
  Result:='Groups';
end;

constructor TPGGroupsRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okGroup;
  FDropCommandClass:=TPGSQLDropGroup;
end;

{ TPGGroup }

function TPGGroup.InternalGetDDLCreate: string;
var
  FCmd: TPGSQLCreateRole;
  G1: TPGSQLGrant;
  GrantedList: TObjectList;
  i: Integer;
  M: TUserRoleGrant;
begin
  //Result:=GenGroupSQL(CaptionFullPatch, ObjID, UserOptions, PwdValidDate, FConnectionsLimit, FDescription, dmCreate);
  FCmd:=TPGSQLCreateRole.Create(nil);
  FCmd.ObjectKind:=okGroup;
  FCmd.Name:=Caption;
  FCmd.Description:=Description;
  FCmd.UserOptions:=UserOptions;
  FCmd.ConnectionLimit:=ConnectionsLimit;
  //FCmd.Password:=F;
  //FCmd.ValidUntil:=passwo
  G1:=TPGSQLGrant.Create(nil);
  G1.ObjectKind:=okRole; //DBObjectKind;
  G1.Tables.Add(Caption);

  GrantedList:=TObjectList.Create;
  GetUserRight(GrantedList);
  for i:=0 to GrantedList.Count -1 do
  begin
    M:=TUserRoleGrant(GrantedList[i]);
    G1.Params.AddParam(M.UserName);
  end;
  GrantedList.Free;

  FCmd.AddChild(G1);
  Result:=FCmd.AsSQL;
  FCmd.Free;
end;

constructor TPGGroup.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
    FOID:=ADBItem.ObjId;
  FUserOptions:=[puoInheritedRight, puoNeverExpired];
  FConnectionsLimit:=-1;
end;

destructor TPGGroup.Destroy;
begin
  inherited Destroy;
end;

class function TPGGroup.DBClassTitle: string;
begin
  Result:='Group';
end;

procedure TPGGroup.RefreshObject;
var
  Q:TZQuery;
begin
  if State <> sdboEdit then exit;
  inherited RefreshObject;
  Q:=TSQLEnginePostgre(OwnerDB).GetSqlQuery(pgSqlTextModule.sRoleAndUser['sPGRoleParams']);
  try
    Q.ParamByName('rolname').AsString:=Caption;
    Q.Open;
    if Q.RecordCount>0 then
    begin
      FDescription:=Q.FieldByName('description').AsString;
      FUserOptions:=[];
      if (Q.FieldByName('rolvaliduntil').IsNull) or (Q.FieldByName('rolvaliduntil').AsDateTime > EncodeDate(9999,12,31)) then
      begin
        FPwdValidDate:=0;
        FUserOptions:=FUserOptions + [puoNeverExpired]
      end
      else
        FPwdValidDate:=Q.FieldByName('rolvaliduntil').AsDateTime;
      if Q.FieldByName('rolsuper').AsBoolean then
        FUserOptions:=FUserOptions + [puoSuperuser];

      if Q.FieldByName('rolinherit').AsBoolean then
        FUserOptions:=FUserOptions + [puoInheritedRight];

      if Q.FieldByName('rolcreatedb').AsBoolean then
        FUserOptions:=FUserOptions + [puoCreateDatabaseObjects];

      if Q.FieldByName('rolcreaterole').AsBoolean then
        FUserOptions:=FUserOptions + [puoCreateRoles];

      if Q.FieldByName('rolcreaterole').AsBoolean then
        FUserOptions:=FUserOptions + [puoCreateRoles];

      //if TSQLEnginePostgre(OwnerDB).ServerVersion < pgVersion9_6 then
      if TSQLEnginePostgre(OwnerDB).RealServerVersion < 9006 then
      begin
        if Q.FieldByName('rolcatupdate').AsBoolean then
          FUserOptions:=FUserOptions + [puoChangeSystemCatalog];
      end;

      if Q.FieldByName('rolreplication').AsBoolean then
        FUserOptions:=FUserOptions + [puoReplication];

      FConnectionsLimit:=Q.FieldByName('rolconnlimit').AsInteger;
    end;
  finally
    Q.Free;
  end;
end;


function TPGGroup.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=nil;
  if State = sdboCreate then
  begin
    Result:=TPGSQLCreateRole.Create(nil);
    Result.ObjectKind:=okGroup;
  end
  else
  if State = sdboCreate then
  begin
    Result:=TPGSQLAlterGroup.Create(nil);
    Result.Name:=Caption;
  end;
end;

function TPGGroup.SetGrantUsers(AUserName: string; AGrant, WithGrantOpt: boolean): boolean;
var
  R: TSQLCommandGrant;
begin
  if AGrant then
    R:=TPGSQLGrant.Create(nil)
  else
    R:=TPGSQLRevoke.Create(nil);

  if WithGrantOpt then
    R.GrantTypes:=R.GrantTypes + [ogWGO];
  R.ObjectKind:=okRole;
  if IsValidIdent(Caption) then
    R.Tables.Add(Caption)
  else
    R.Tables.Add('"'+Caption+'"');

  if IsValidIdent(AUserName) then
    R.Params.AddParam(AUserName)
  else
    R.Params.AddParam('"'+AUserName+'"');

  if Assigned(FSqlStrings) then
    FSqlStrings.AddStrings(R.SQLText)
  else
    SQLScriptsExec(Trim(R.AsSQL), []);
  R.Free;
end;

function TPGGroup.SetGrantObjects(AObjectName: string; AddGrants,
  RemoveGrants: TObjectGrants): boolean;
begin
  Result:=false;
end;

procedure TPGGroup.GetUserList(const UserList: TStrings);
var
  U:TPGUser;
  Q:TZQuery;
  S: String;
  UG: TPGUsersRoot;
  FUsrs: TStringList;
  i, j: Integer;
begin
  UserList.Clear;
{  FUsrs:=TStringList.Create;
  FUsrs.Sorted:=true;
  Q:=TSQLEnginePostgre(OwnerDB).GetSqlQuery(pgSqlTextModule.sPGGroups1.Strings.Text);
  try
    Q.ParamByName('groname').AsString:=Caption;
    Q.Open;
    if Q.RecordCount > 0 then
    begin
      ParsePGArrayString(Q.FieldByName('grolist').AsString, FUsrs);
      for S in FUsrs do
      begin
        UG:=TPGSecurityRoot(TSQLEnginePostgre(OwnerDB).SecurityRoot).PGUsersRoot;
        for j:=0 to UG.CountObject-1 do
        begin
          U:=UG[j] as TPGUser;
          if FUsrs.Find(IntToStr(U.UserID), i) then
            UserList.Add(U.Caption);
        end;
      end;
      Q.Next;
    end;
  finally
    Q.Free;
    FUsrs.Free;
  end;}
  UG:=TPGSecurityRoot(TSQLEnginePostgre(OwnerDB).SecurityRoot).PGUsersRoot;
  if UG.CountObject = 0 then UG.RefreshGroup;
  for j:=0 to UG.CountObject-1 do
  begin
    U:=UG[j] as TPGUser;
    UserList.Add(U.Caption);
  end;
end;

procedure TPGGroup.GetUserRight(GrantedList:TObjectList);
var
  Q:TZQuery;
  M:TUserRoleGrant;
begin
  Q:=TSQLEnginePostgre(OwnerDB).GetSqlQuery(pgSqlTextModule.sRoleAndUser['sqlPGUserGroupGrants']);
  try
    Q.ParamByName('roleid').AsInteger:=FOID;
    Q.Open;
    while not Q.Eof do
    begin
      M:=TUserRoleGrant.Create;
      GrantedList.Add(M);
      M.UserName:=Q.FieldByName('user_member').AsString;
      M.GrantUserName:=Q.FieldByName('user_grantor').AsString;
      M.WithAdmOpt:=Q.FieldByName('admin_option').AsBoolean;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TPGGroup.SetSqlAssistentData(const List: TStrings);
var
  Q:TZQuery;
begin
  inherited SetSqlAssistentData(List);
  List.Add(sMembers);
  Q:=TSQLEnginePostgre(OwnerDB).GetSqlQuery(pgSqlTextModule.sRoleAndUser['sqlPGUserGroupGrants']);
  try
    Q.ParamByName('roleid').AsInteger:=FOID;
    Q.Open;
    while not Q.Eof do
    begin
      if Q.FieldByName('admin_option').AsBoolean then
        List.Add(Q.FieldByName('user_member').AsString+' WITH ADMIN OPTION')
      else
        List.Add(Q.FieldByName('user_member').AsString);
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

end.

