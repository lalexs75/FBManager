{ Free DB Manager

  Copyright (C) 2005-2025 Lagunov Aleksey  alexs75 at yandex.ru

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

unit mssql_EngineSecurityUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, contnrs, SQLEngineAbstractUnit, mssql_engine, sqlEngineTypes,
  SQLEngineCommonTypesUnit, SQLEngineInternalToolsUnit, fbmSqlParserUnit,
  ZDataset;

type
  TMSSQLRolesRoot = class;
  TMSSQLUsersRoot = class;
  TMSSQLLoginsRoot = class;

  { TMSSQLSecurityRoot }

  TMSSQLSecurityRoot = class(TDBRootObject)
  private
    FRolesRoot:TMSSQLRolesRoot;
    FUsersRoot:TMSSQLUsersRoot;
    FLoginsRoot:TMSSQLLoginsRoot;
  protected
  public
    function GetObjectType: string;override;
    procedure RefreshGroup; override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    destructor Destroy; override;
    procedure Clear;override;
    property RolesRoot:TMSSQLRolesRoot read FRolesRoot;
    property UsersRoot:TMSSQLUsersRoot read FUsersRoot;
    property LoginsRoot:TMSSQLLoginsRoot read FLoginsRoot;
  end;

  { TMSSQLRolesRoot }

  TMSSQLRolesRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TMSSQLUsersRoot }

  TMSSQLUsersRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TMSSQLLoginsRoot }

  TMSSQLLoginsRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TMSSQLRole }

  TMSSQLRole = class(TDBObject)
  private
    FOwnerName: string;
    FRoleID: Integer;
  protected
    procedure InternalRefreshStatistic; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot: TDBRootObject);override;
    destructor Destroy; override;
    procedure RefreshObject; override;
    class function DBClassTitle:string;override;
    function InternalGetDDLCreate: string; override;
    procedure SetSqlAssistentData(const List: TStrings);override;
    function CreateSQLObject:TSQLCommandDDL; override;
    property OwnerName:string read FOwnerName;
    property RoleID: Integer read FRoleID;
  end;

  { TMSSQLUser }

  TMSSQLUser = class(TDBObject)
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

  { TMSSQLLogin }

  TMSSQLLogin = class(TDBObject)
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
uses fbmStrConstUnit, sqlObjects, mssql_sql_parser, mssql_sql_lines_unit;

{ TMSSQLRole }

function TMSSQLRole.InternalGetDDLCreate: string;
var
  FCmd: TMSSQLCreateRole;
begin
  FCmd:=TMSSQLCreateRole.Create(nil);
  FCmd.Name:=Caption;
  //FCmd.OwnerName:=Caption;
  Result:=FCmd.AsSQL;
  FCmd.Free;
end;

procedure TMSSQLRole.InternalRefreshStatistic;
begin
  inherited InternalRefreshStatistic;
  Statistic.AddValue(sOID, IntToStr(FRoleID));
  Statistic.AddValue(sOwner, FOwnerName);
end;

constructor TMSSQLRole.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject
  );
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
    FRoleID:=ADBItem.ObjId;
end;

destructor TMSSQLRole.Destroy;
begin
  inherited Destroy;
end;

procedure TMSSQLRole.RefreshObject;
var
  Q: TZQuery;
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;
//  Q:=TMSSQLEngine(OwnerDB).GetSqlQuery(msSQLTexts.sTables['sTableCollumns']);
//  Q.Free;
end;

class function TMSSQLRole.DBClassTitle: string;
begin
  Result:='Role';
end;

procedure TMSSQLRole.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;

function TMSSQLRole.CreateSQLObject: TSQLCommandDDL;
begin
  if State = sdboCreate then
    Result:=TMSSQLCreateRole.Create(nil)
  else
  begin
    Result:=TMSSQLAlterRole.Create(nil);
    Result.Name:=Caption;
  end;
end;

{ TMSSQLUser }

function TMSSQLUser.InternalGetDDLCreate: string;
begin
  Result:=inherited InternalGetDDLCreate;
//  if Assigned(ADBItem) then
//    FUserID:=ADBItem.ObjId;
//  FUserOptions:=[puoInheritedRight, puoNeverExpired, puoLoginEnabled];
//  FConnectionsLimit:=-1;
end;

constructor TMSSQLUser.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject
  );
begin
  inherited Create(ADBItem, AOwnerRoot);
end;

destructor TMSSQLUser.Destroy;
begin
  inherited Destroy;
end;

procedure TMSSQLUser.RefreshObject;
begin
  inherited RefreshObject;
end;

class function TMSSQLUser.DBClassTitle: string;
begin
  Result:=inherited DBClassTitle;
end;

procedure TMSSQLUser.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;

function TMSSQLUser.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=inherited CreateSQLObject;
end;

{ TMSSQLLogin }

function TMSSQLLogin.InternalGetDDLCreate: string;
begin
  Result:=inherited InternalGetDDLCreate;
end;

constructor TMSSQLLogin.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject
  );
begin
  inherited Create(ADBItem, AOwnerRoot);
//  if Assigned(ADBItem) then
//    FUserID:=ADBItem.ObjId;
//  FUserOptions:=[puoInheritedRight, puoNeverExpired, puoLoginEnabled];
//  FConnectionsLimit:=-1;
end;

destructor TMSSQLLogin.Destroy;
begin
  inherited Destroy;
end;

procedure TMSSQLLogin.RefreshObject;
begin
  inherited RefreshObject;
end;

class function TMSSQLLogin.DBClassTitle: string;
begin
  Result:=inherited DBClassTitle;
end;

procedure TMSSQLLogin.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;

function TMSSQLLogin.CreateSQLObject: TSQLCommandDDL;
begin
  if State = sdboCreate then
  begin
    Result:=TMSSQLCreateLogin.Create(nil);
    Result.ObjectKind:=okLogin;
  end
  else
  begin
    Result:=TMSSQLAlterLogin.Create(nil);
    Result.ObjectKind:=okLogin;
    Result.Name:=Caption;
  end;
end;

{ TMSSQLLoginsRoot }

function TMSSQLLoginsRoot.DBMSObjectsList: string;
begin
  Result:=msSQLTexts.sSystemObjects['sLogins'];
end;

function TMSSQLLoginsRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=inherited DBMSValidObject(AItem);
end;

function TMSSQLLoginsRoot.GetObjectType: string;
begin
  Result:='Logins';
end;

constructor TMSSQLLoginsRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okLogin;
  FDropCommandClass:=TMSSQLDropLogin;
end;

{ TMSSQLUsersRoot }

function TMSSQLUsersRoot.DBMSObjectsList: string;
begin
  Result:=msSQLTexts.sSystemObjects['sUsers'];
end;

function TMSSQLUsersRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=(AItem.ObjType <> '') and (AItem.ObjType[1] = 'L');
end;

function TMSSQLUsersRoot.GetObjectType: string;
begin
  Result:='Users';
end;

constructor TMSSQLUsersRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okUser;
  FDropCommandClass:=TMSSQLDropUser;
end;

{ TMSSQLRolesRoot }

function TMSSQLRolesRoot.DBMSObjectsList: string;
begin
  Result:=msSQLTexts.sSystemObjects['sUsers'];
end;

function TMSSQLRolesRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=(Length(AItem.ObjType) > 1) and (AItem.ObjType[2] = 'R');
end;

function TMSSQLRolesRoot.GetObjectType: string;
begin
  Result:='Roles';
end;

constructor TMSSQLRolesRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okRole;
  FDropCommandClass:=TMSSQLDropRole;
end;

{ TMSSQLSecurityRoot }

function TMSSQLSecurityRoot.GetObjectType: string;
begin
  Result:='Security';
end;

procedure TMSSQLSecurityRoot.RefreshGroup;
begin
  inherited RefreshGroup;
end;

constructor TMSSQLSecurityRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okUser;

  FRolesRoot:=TMSSQLRolesRoot.Create(AOwnerDB, TMSSQLRole, sRoles, Self);
  FUsersRoot:=TMSSQLUsersRoot.Create(AOwnerDB, TMSSQLUser, sUsers, Self);
  FLoginsRoot:=TMSSQLLoginsRoot.Create(AOwnerDB, TMSSQLLogin, sLogins, Self);
end;

destructor TMSSQLSecurityRoot.Destroy;
begin
  FreeAndNil(FRolesRoot);
  FreeAndNil(FUsersRoot);
  FreeAndNil(FLoginsRoot);
  inherited Destroy;
end;

procedure TMSSQLSecurityRoot.Clear;
begin
  FRolesRoot.Clear;
  FUsersRoot.Clear;
  FLoginsRoot.Clear;
end;

end.

