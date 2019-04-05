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


unit mysql_engine;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineAbstractUnit, mysql_types, ZConnection, ZDataset,
  DB, contnrs, SQLEngineCommonTypesUnit, SQLEngineInternalToolsUnit, ZSqlProcessor,
  fbmSqlParserUnit, sqlObjects, mysql_SqlParserUnit;

const
  defMySQLPort = 3306;
type
  TTriggersLists = array [0..5] of TList;
type
  TSQLEngineMySQL = class;

  { TMySQLTablesRoot }

  TMySQLTablesRoot = class(TDBRootObject)
  protected
    function DBMSObjectsList:string; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TMySQLViewsRoot }

  TMySQLViewsRoot = class(TDBRootObject)
  protected
    function DBMSObjectsList:string; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TMySQLTriggersRoot }

  TMySQLTriggersRoot = class(TDBRootObject)
  protected
    function DBMSObjectsList:string; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TMySQLProceduresRoot }

  TMySQLProceduresRoot = class(TDBRootObject)
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TMySQLFunctionsRoot }

  TMySQLFunctionsRoot = class(TDBRootObject)
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TMySQLUsersRoot }

  TMySQLUsersRoot = class(TDBRootObject)
  protected
    function DBMSObjectsList:string; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TMySQLACLItem }

  TMySQLACLItem = class(TACLItem)
  protected
  end;

  { TMySQLACLList }

  TMySQLACLList = class(TACLListAbstract)
  private
  protected
    function InternalCreateACLItem: TACLItem; override;
    function InternalCreateGrantObject: TSQLCommandGrant; override;
    function InternalCreateRevokeObject: TSQLCommandGrant; override;
  public
    procedure LoadUserAndGroups; override;
    procedure RefreshList; override;
  end;

  { TMySQLField }

  TMySQLField = class(TDBField)
  private
    procedure LoadfromDB(DS:TDataSet);
    function FieldTypeStr:string;
    function GenDDL(AMode:TDDLMode):string;
    function FieldAtribs:string;
  protected
    procedure SetFieldDescription(const AValue: string);override;
    function AlterAddDDL:string;
  public
  end;

  { TMySQLTable }
  TMySQLTable = class(TDBTableObject)
  private
    FEngine: string;

    FTriggerList:TTriggersLists;
    procedure SetEngine(AValue: string);
  protected
    function InternalGetDDLCreate: string; override;

    function GetTrigger(ACat:integer; AItem: integer): TDBTriggerObject; override;
    function GetTriggersCategories(AItem: integer): string; override;
    function GetTriggersCategoriesCount: integer; override;
    function GetTriggersCount(AItem: integer): integer; override;
    function GetTriggersCategoriesType(AItem: integer): TTriggerTypes;override;
    function GetRecordCount: integer; override;
    function GetDBFieldClass: TDBFieldClass; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    procedure RefreshObject;override;
    class function DBClassTitle:string;override;
    procedure RefreshFieldList; override;
    function RenameObject(ANewName:string):Boolean;override;
    procedure SetFieldsOrder(AFieldsList:TStrings); override;
    function CreateSQLObject:TSQLCommandDDL;override;

    function IndexDelete(const IndexName:string):boolean; override;
    procedure IndexListRefresh; override;

    procedure RefreshConstraintPrimaryKey;override;
    procedure RefreshConstraintForeignKey;override;

    function DataSet(ARecCountLimit:Integer):TDataSet;override;

    procedure TriggersListRefresh; override;
    function TriggerNew(TriggerTypes:TTriggerTypes):TDBTriggerObject;override;
    function TriggerDelete(const ATrigger:TDBTriggerObject):Boolean;override;
    property Engine:string read FEngine write SetEngine;
  end;


  { TMySQLIndexItem }

  TMySQLIndexItem = class(TIndexItem)
  public
    constructor CreateFromDB(AOwner:TMySQLTable; DS:TDataSet);
  end;

  TMySQLView = class(TDBViewObject)
  private
  protected
    function InternalGetDDLCreate: string; override;
    function GetDDLAlter: string; override;
    function GetRecordCount: integer; override;
    function GetDBFieldClass: TDBFieldClass; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    function CreateSQLObject:TSQLCommandDDL;override;
    procedure RefreshObject; override;
    procedure RefreshFieldList; override;
    procedure Commit;override;
    procedure RollBack;override;
    function DataSet(ARecCountLimit:integer):TDataSet;override;
    procedure TriggersListRefresh; override;
    procedure RefreshDependencies;override;

  end;

  { TMySQLTriger }

  TMySQLTriger = class(TDBTriggerObject)
  private
    FDefiner: string;
    FTriggerBody:string;
    FTriggerOrder: TTriggerType;
    FTriggerOrderName: string;
  protected
    function InternalGetDDLCreate: string; override;
    function GetTriggerBody: string;override;
    procedure SetTriggerBody(AValue:string);
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    class function DBClassTitle:string;override;
    function CreateSQLObject:TSQLCommandDDL;override;
    procedure RefreshDependencies;override;
    procedure RefreshObject; override;
    property Definer:string read FDefiner write FDefiner;
    property TriggerOrder:TTriggerType read FTriggerOrder write FTriggerOrder;
    property TriggerOrderName:string read FTriggerOrderName write FTriggerOrderName;
  end;

  { TMySQLProcedure }

  TMySQLProcedure = class(TDBStoredProcObject)
  private
    FDefiner: string;
    FDetermType: TProcDeterministicType;
    FParams:TObjectList;
    FResultType: TDBField;
    FSecurity: TProcSecurity;
    FSqlAccess: TProcSqlAccess;
  protected
    function InternalGetDDLCreate: string; override;
    procedure RefreshParams;override;
    property ResultType:TDBField read FResultType;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    function CreateSQLObject:TSQLCommandDDL;override;
    procedure RefreshObject;override;
    property DetermType:TProcDeterministicType read FDetermType write FDetermType;
    property SqlAccess:TProcSqlAccess read FSqlAccess write FSqlAccess;
    property Security:TProcSecurity read FSecurity write FSecurity;
    property Definer:string read FDefiner write FDefiner;
    property FieldsIN;
  end;

  TMySQLFunction = class(TMySQLProcedure)
  protected
    //function InternalGetDDLCreate: string; override;
  public
    property ResultType;
  end;


  TMySQLUser = class(TDBObject)
  private
    FAuthenticationPlugin: string;
    FHostName: string;
    FMaxConnectionsPerHour: integer;
    FMaxQueriesPerHour: integer;
    FMaxUpdatePerHour: integer;
    FMaxUserConnections: integer;
    FPassword: string;
    FUserName: string;
    FUserOptions: TMySQLUserOptions;
    procedure SetHostName(AValue: string);
    procedure SetUserName(AValue: string);
  protected
    function InternalGetDDLCreate: string; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot: TDBRootObject);override;
    destructor Destroy; override;
    procedure RefreshObject; override;
    class function DBClassTitle:string;override;
    procedure SetSqlAssistentData(const List: TStrings);override;
    function CreateSQLObject:TSQLCommandDDL;override;

    property UserName:string read FUserName write SetUserName;
    property HostName:string read FHostName write SetHostName;
    property Password:string read FPassword write FPassword;

    property AuthenticationPlugin:string read FAuthenticationPlugin write FAuthenticationPlugin;

    property UserOptions:TMySQLUserOptions read FUserOptions write FUserOptions;
    property MaxQueriesPerHour:integer read FMaxQueriesPerHour write FMaxQueriesPerHour;
    property MaxUpdatePerHour:integer read FMaxUpdatePerHour write FMaxUpdatePerHour;
    property MaxConnectionsPerHour:integer read FMaxConnectionsPerHour write FMaxConnectionsPerHour;
    property MaxUserConnections:integer read FMaxUserConnections write FMaxUserConnections;
    //
(*    ssl_type ENUM(9) COLLATE UTF8_GENERAL_CI NOT NULL,
    ssl_cipher BLOB(65535) NOT NULL,
    x509_issuer BLOB(65535) NOT NULL,
    x509_subject BLOB(65535) NOT NULL,
    authentication_string TEXT(65535) COLLATE UTF8_BIN NOT NULL, *)
  end;

  { TSQLEngineMySQL }

  TSQLEngineMySQL = class(TSQLEngineAbstract)
  private
    FConnection: TZConnection;
    FRoleName: string;
    FServerVersion: TMySQLServerVersion;

    FViewsRoot:TMySQLViewsRoot;
    FTriggersRoot:TMySQLTriggersRoot;
    FProceduresRoot:TMySQLProceduresRoot;
    FFunctionsRoot:TMySQLFunctionsRoot;
    FUsersRoot:TMySQLUsersRoot;
    FOnExecuteSqlScriptProcessEvent:TExecuteSqlScriptProcessEvent;

    procedure InternalInitSQLEngineMySQL;
    procedure ZSQLProcessorAfterExecute(Processor: TZSQLProcessor; StatementIndex: Integer);
  private
    //
  protected
    function GetImageIndex: integer;override;
    //procedure SetConnected(const AValue: boolean);override;
    function InternalSetConnected(const AValue: boolean):boolean; override;
    procedure InitGroupsObjects;override;
    procedure DoneGroupsObjects;override;

    function GetCharSet: string;override;
    procedure SetCharSet(const AValue: string);override;
    class function GetEngineName: string; override;
    procedure SetUIShowSysObjects(const AValue: TUIShowSysObjects);override;
    function GetSqlQuery(ASql:string):TZQuery;
    procedure InitKeywords;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Load(const AData: TDataSet);override;
    procedure Store(const AData: TDataSet);override;
    procedure SetSqlAssistentData(const List: TStrings); override;
    procedure FillCharSetList(const List: TStrings); override;
    procedure FillCollationList(const ACharSet:string; const List: TStrings); override;
    function OpenDataSet(Sql:string; AOwner:TComponent):TDataSet;override;
    function ExecSQL(const Sql:string;const ExecParams:TSqlExecParams):boolean;override;
    function SQLPlan(aDataSet:TDataSet):string;override;
    function GetQueryControl:TSQLQueryControl;override;
    procedure ExecuteSQLScript(const ASQL: string; OnExecuteSqlScriptProcessEvent:TExecuteSqlScriptProcessEvent); override;


    //Create connection dialog functions
    procedure RefreshObjectsBegin(const ASQLText:string);override;

    property ServerVersion:TMySQLServerVersion read FServerVersion write FServerVersion;
    property TriggersRoot:TMySQLTriggersRoot read FTriggersRoot;
    property UsersRoot:TMySQLUsersRoot read FUsersRoot;
  end;

  { TMySQLQueryControl }

  TMySQLQueryControl = class(TSQLQueryControl)
  private
    FSQLQuery: TZQuery;
    procedure SetParamValues;
  protected
    function GetDataSet: TDataSet;override;
    function GetQueryPlan: string;override;
    function GetQuerySQL: string;override;
    procedure SetQuerySQL(const AValue: string);override;
    function GetParam(AIndex: integer): TParam;override;
    function GetParamCount: integer;override;
    procedure SetActive(const AValue: boolean);override;
  public
    constructor Create(AOwner:TSQLEngineAbstract);override;
    destructor Destroy; override;
    procedure CommitTransaction;override;
    procedure RolbackTransaction;override;
    procedure FetchAll;override;
    procedure Prepare;override;
    procedure ExecSQL;override;
  end;

implementation

uses fbmStrConstUnit, fbmToolsUnit, MySQLKeywords, mysqlDataModuleUnit, rxlogging,
  rxdbutils, StrUtils, rxstrutils, rxAppUtils;

(*
{ TMySQLACLItem }

function TMySQLACLItem.MakeGrantStr(ForScript: boolean): string;
var
  FGObg: TMySQLGrant;
begin
  FGObg:=TMySQLGrant.Create(nil);
  FGObg.GrantObjects.Add(ObjectName, okNone);
  FGObg.Params.AddParamEx(UserName, '');
  if ForScript then
    FGObg.GrantTypes:=Grants
  else
    FGObg.GrantTypes:=NewGrants;

  if FGObg.GrantTypes <> [] then
    Result:=TrimRight(FGObg.AsSQL)
  else
    Result:='';
  FGObg.Free;
end;

function TMySQLACLItem.MakeRevokeStr: string;
var
  FGObg: TMySQLRevoke;
begin
  FGObg:=TMySQLRevoke.Create(nil);
  FGObg.GrantObjects.Add(ObjectName, okNone);
  FGObg.Params.AddParamEx(UserName, '');
  FGObg.GrantTypes:=NewRevoke;
  if FGObg.GrantTypes <> [] then
    Result:=TrimRight(FGObg.AsSQL)
  else
    Result:='';
  FGObg.Free;
end;
*)
{ TMySQLACLList }

function TMySQLACLList.InternalCreateACLItem: TACLItem;
begin
  Result:=TMySQLACLItem.Create(DBObject, Self);
end;

function TMySQLACLList.InternalCreateGrantObject: TSQLCommandGrant;
begin
  Result:=TMySQLGrant.Create(nil);
end;

function TMySQLACLList.InternalCreateRevokeObject: TSQLCommandGrant;
begin
  Result:=TMySQLRevoke.Create(nil);
end;

procedure TMySQLACLList.LoadUserAndGroups;
var
  i:integer;
  P:TACLItem;
  U: TMySQLUser;
begin
  for i:=0 to  TSQLEngineMySQL(SQLEngine).FUsersRoot.CountObject - 1 do
  begin
    P:=Add;
    P.UserType:=1;
    U:=TSQLEngineMySQL(SQLEngine).FUsersRoot.Items[i] as TMySQLUser;
    P.UserName:=QuotedString(U.UserName,'''')+'@'+QuotedString(U.HostName,'''');
  end;
end;

procedure TMySQLACLList.RefreshList;
var
  Q:TZQuery;
  S, S1:string;
  P: TACLItem;
  OG:TObjectGrants;

begin
  Clear;

  LoadUserAndGroups;
  if not Assigned(DBObject) then exit;

  if DBObject is TMySQLTable then
  begin
    Q:=TSQLEngineMySQL(SQLEngine).GetSQLQuery(MySqlModule.sqlTableGrants.ExpandMacros);
    Q.ParamByName('TABLE_NAME').AsString:=DBObject.Caption;
    Q.ParamByName('TABLE_SCHEMA').AsString:=DBObject.OwnerDB.DataBaseName;
    Q.Open;
    while not Q.EOF do
    begin
      P:=FindACLItem(Q.FieldByName('GRANTEE').AsString);
      if Assigned(P) then
      begin
        OG:=P.Grants;
        S:=Q.FieldByName('IS_GRANTABLE').AsString;
        S:=Q.FieldByName('PRIVILEGE_TYPE').AsString;
        if Q.FieldByName('IS_GRANTABLE').AsString = 'YES' then OG:=OG + [ogWGO];
        if Q.FieldByName('PRIVILEGE_TYPE').AsString = 'SELECT' then OG:=OG + [ogSelect] else
        if Q.FieldByName('PRIVILEGE_TYPE').AsString = 'INSERT' then OG:=OG + [ogInsert] else
        if Q.FieldByName('PRIVILEGE_TYPE').AsString = 'ALTER' then OG:=OG + [ogAlter] else
        if Q.FieldByName('PRIVILEGE_TYPE').AsString = 'CREATE' then OG:=OG + [ogCreate] else
        if Q.FieldByName('PRIVILEGE_TYPE').AsString = 'CREATE VIEW' then OG:=OG + [ogCreateView] else
        if Q.FieldByName('PRIVILEGE_TYPE').AsString = 'DELETE' then OG:=OG + [ogDelete] else
        if Q.FieldByName('PRIVILEGE_TYPE').AsString = 'DROP' then OG:=OG + [ogDrop] else
        if Q.FieldByName('PRIVILEGE_TYPE').AsString = 'INDEX' then OG:=OG + [ogIndex] else
        if Q.FieldByName('PRIVILEGE_TYPE').AsString = 'REFERENCES' then OG:=OG + [ogReference] else
        if Q.FieldByName('PRIVILEGE_TYPE').AsString = 'SHOW VIEW' then OG:=OG + [ogShowView] else
        if Q.FieldByName('PRIVILEGE_TYPE').AsString = 'TRIGGER' then OG:=OG + [ogTrigger] else
        if Q.FieldByName('PRIVILEGE_TYPE').AsString = 'UPDATE' then OG:=OG + [ogUpdate];

        P.Grants:=OG;
      end;
      Q.Next;
    end;
    Q.Close;
    Q.Free;
  end
  else
  if (DBObject is TMySQLProcedure) or (DBObject is TMySQLFunction) then
  begin
    Q:=TSQLEngineMySQL(SQLEngine).GetSQLQuery(MySqlModule.sqlProcFuncGrants.ExpandMacros);
    if DBObject is TMySQLFunction then
      Q.ParamByName('Routine_type').AsString:='FUNCTION'
    else
      Q.ParamByName('Routine_type').AsString:='PROCEDURE';
    Q.ParamByName('Db').AsString:=DBObject.OwnerDB.DataBaseName;
    Q.ParamByName('Routine_name').AsString:=DBObject.Caption;
    Q.Open;
    while not Q.EOF do
    begin
      S:=QuotedString(Q.FieldByName('User').AsString, '''') + '@';
      if Q.FieldByName('Host').AsString = '' then
        S:=S + '''%'''
      else
        S:=S + QuotedString(Q.FieldByName('Host').AsString, '''');

      P:=FindACLItem(S);
      if Assigned(P) then
      begin
        OG:=[];
        S:=UpperCase(Q.FieldByName('Proc_priv').AsString);
        while S<>'' do
        begin
          S1:=Copy2SymbDel(S, ',');
          if S1 = 'EXECUTE' then OG:=OG + [ogExecute]
          else
          if S1 = 'ALTER ROUTINE' then OG:=OG + [ogAlterRoutine];
        end;
        //Execute,Alter Routine
(*
Host,
Db,
User,
Routine_name,
Routine_type,
Grantor,
Proc_priv,
Timestamp
*)

        P.Grants:=OG;
      end;
      Q.Next;
    end;
    Q.Close;
    Q.Free;
  end;
(*  else
  if DBObject is TPGSchema then
    Q:=TSQLEnginePostgre(SQLEngine).GetSQLQuery(sql_PG_ACLShemas)
  else
  if DBObject is TPGTableSpace then
    Q:=TSQLEnginePostgre(SQLEngine).GetSQLQuery(sql_PG_ACLTableSpace)
  else
    Q:=TSQLEnginePostgre(SQLEngine).GetSQLQuery(sql_PG_ACLTables) *)

  for P in Self do
    P.FillOldValues;
end;

{ TMySQLUser }

procedure TMySQLUser.SetHostName(AValue: string);
begin
  if FHostName=AValue then Exit;
  FHostName:=AValue;
end;

procedure TMySQLUser.SetUserName(AValue: string);
begin
  if FUserName=AValue then Exit;
  FUserName:=AValue;
end;

function TMySQLUser.InternalGetDDLCreate: string;
var
  FObj: TMySQLCreateUser;
  FFlush: TMySQLFlush;
  FGO: TObjectGrants;
  FGnt: TMySQLGrant;
begin
  FObj:=TMySQLCreateUser.Create(nil);
  FObj.Name:=FUserName;
  FObj.HostName:=FHostName;
  FObj.Password:=Password;
  FObj.UserOptions:=UserOptions;

  FObj.AuthenticationPlugin:=AuthenticationPlugin;
  FObj.MaxQueriesPerHour:=MaxQueriesPerHour;
  FObj.MaxUpdatePerHour:=MaxUpdatePerHour;
  FObj.MaxConnectionsPerHour:=MaxConnectionsPerHour;
  FObj.MaxUserConnections:=MaxUserConnections;





  FGO:=[];
{  if CheckBox1.Checked then
    FGO:=[ogAll]
  else
  begin}
    if msuoSelectPriv in UserOptions then FGO:=FGO + [ogSelect];
    if msuoInsertPriv in UserOptions then FGO:=FGO + [ogInsert];
    if msuoUpdatePriv in UserOptions then FGO:=FGO + [ogUpdate];
    if msuoDeletePriv in UserOptions then FGO:=FGO + [ogDelete];
    if msuoCreatePriv in UserOptions then FGO:=FGO + [ogCreate];
    if msuoDropPriv in UserOptions then FGO:=FGO + [ogDrop];
    if msuoReloadPriv in UserOptions then FGO:=FGO + [ogReload];
    if msuoShutdownPriv in UserOptions then FGO:=FGO + [ogShutdown];
    if msuoProcessPriv in UserOptions then FGO:=FGO + [ogProcess];
    if msuoFilePriv in UserOptions then FGO:=FGO + [ogFile];
    if msuoGrantPriv in UserOptions then FGO:=FGO + [ogWGO];
    if msuoReferencesPriv in UserOptions then FGO:=FGO + [ogReference];
    if msuoIndexPriv in UserOptions then FGO:=FGO + [ogIndex];
    if msuoAlterPriv in UserOptions then FGO:=FGO + [ogAlter];
    if msuoShowDBPriv in UserOptions then FGO:=FGO + [ogShowDatabases];
    if msuoSuperPriv in UserOptions then FGO:=FGO + [ogSuper];
    if msuoCreateTmpTablePriv in UserOptions then FGO:=FGO + [ogTemporary];
    if msuoLockTablesPriv in UserOptions then FGO:=FGO + [ogLockTables];
    if msuoExecutePriv in UserOptions then FGO:=FGO + [ogExecute];
    if msuoReplSlavePriv in UserOptions then FGO:=FGO + [ogReplicationSlave];
    if msuoReplClientPriv in UserOptions then FGO:=FGO + [ogReplicationClient];
    if msuoCreateViewPriv in UserOptions then FGO:=FGO + [ogCreateView];
    if msuoShowViewPriv in UserOptions then FGO:=FGO + [ogShowView];
    if msuoCreateRoutinePriv in UserOptions then FGO:=FGO + [ogCreateRoutine];
    if msuoAlterRoutinePriv in UserOptions then FGO:=FGO + [ogAlterRoutine];
    if msuoCreateUserPriv in UserOptions then FGO:=FGO + [ogCreateUser];
    if msuoEventPriv in UserOptions then FGO:=FGO + [ogEvent];
    if msuoTriggerPriv in UserOptions then FGO:=FGO + [ogTrigger];
    if msuoCreateTablespacePriv in UserOptions then FGO:=FGO + [ogCreateTablespace];
  //end;

  if FGO <> [] then
  begin
    FGnt:=TMySQLGrant.Create(FObj);
    FGnt.GrantTypes:=FGO;
    FGnt.Tables.Add('*.*', okNone);
    FObj.AddChild(FGnt);
  end;

  FFlush:=TMySQLFlush.Create(FObj);
  FFlush.Params.AddParam('PRIVILEGES');
  FObj.AddChild(FFlush);

  Result:=FObj.AsSQL;
  FObj.Free;
end;

constructor TMySQLUser.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject
  );
begin
  if Assigned(ADBItem) then
    ADBItem.ObjName:=Trim(ADBItem.ObjName);
  inherited Create(ADBItem, AOwnerRoot);
  RxWriteLog(etDebug, 'TMySQLUser.Caption'+ Caption);
  FHostName:=Caption;
  FUserName:=Copy2SymbDel(FHostName, '@');
end;

destructor TMySQLUser.Destroy;
begin
  inherited Destroy;
end;

procedure TMySQLUser.RefreshObject;
var
  Q: TZQuery;
//  S, S1: String;
  C: LongInt;
begin
  if State <> sdboEdit then exit;
  inherited RefreshObject;
  FUserOptions:=[];

//  S:=MySqlModule.sqlUser.ExpandMacros;
  Q:=TSQLEngineMySQL(OwnerDB).GetSqlQuery(MySqlModule.sqlUser.ExpandMacros);
  Q.ParamByName('Host').AsString:=FHostName;
  Q.ParamByName('User').AsString:=FUserName;
(*
 S1:='select * from mysql.user as u1 where u1.Host = '''+FHostName+''' and u1.User = '''+FUserName+'''';
  S:='select * from mysql.user as u1 where u1.Host = ''%'' and u1.User = ''amarokuser''';
 WriteLog(S1);
 WriteLog(S);

  Q:=TSQLEngineMySQL(OwnerDB).GetSqlQuery(S);
*)

  try
    Q.Open;
    if Q.RecordCount > 0 then
    begin
      FAuthenticationPlugin:=Q.FieldByName('plugin').AsString;
      FPassword:=TrimRight(Q.FieldByName('Password').AsString);

      FMaxConnectionsPerHour:=Q.FieldByName('max_connections').AsInteger;
      FMaxQueriesPerHour:=Q.FieldByName('max_questions').AsInteger;
      FMaxUpdatePerHour:=Q.FieldByName('max_updates').AsInteger;
      FMaxUserConnections:=Q.FieldByName('max_user_connections').AsInteger;

      if Q.FieldByName('Select_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoSelectPriv];
      if Q.FieldByName('Insert_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoInsertPriv];
      if Q.FieldByName('Update_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoUpdatePriv];
      if Q.FieldByName('Delete_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoDeletePriv];
      if Q.FieldByName('Create_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoCreatePriv];
      if Q.FieldByName('Drop_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoDropPriv];
      if Q.FieldByName('Reload_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoReloadPriv];
      if Q.FieldByName('Shutdown_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoShutdownPriv];
      if Q.FieldByName('Process_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoProcessPriv];
      if Q.FieldByName('File_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoFilePriv];
      if Q.FieldByName('Grant_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoGrantPriv];
      if Q.FieldByName('References_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoReferencesPriv];
      if Q.FieldByName('Index_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoIndexPriv];
      if Q.FieldByName('Alter_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoAlterPriv];
      if Q.FieldByName('Super_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoSuperPriv];
      if Q.FieldByName('Create_tmp_table_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoCreateTmpTablePriv];
      if Q.FieldByName('Lock_tables_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoLockTablesPriv];
      if Q.FieldByName('Execute_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoExecutePriv];
      if Q.FieldByName('Repl_slave_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoReplSlavePriv];
      if Q.FieldByName('Repl_client_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoReplClientPriv];
      if Q.FieldByName('Create_view_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoCreateViewPriv];
      if Q.FieldByName('Show_view_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoShowViewPriv];
      if Q.FieldByName('Create_routine_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoCreateRoutinePriv];
      if Q.FieldByName('Alter_routine_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoAlterRoutinePriv];
      if Q.FieldByName('Create_user_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoCreateUserPriv];
      if Q.FieldByName('Event_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoEventPriv];
      if Q.FieldByName('Trigger_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoTriggerPriv];
      if Q.FieldByName('Create_tablespace_priv').AsInteger <> 0 then
        FUserOptions:=FUserOptions + [msuoCreateTablespacePriv];

      (*
        ssl_type ENUM(9) COLLATE UTF8_GENERAL_CI NOT NULL,
        ssl_cipher BLOB(65535) NOT NULL,
        x509_issuer BLOB(65535) NOT NULL,
        x509_subject BLOB(65535) NOT NULL,
        authentication_string TEXT(65535) COLLATE UTF8_BIN NOT NULL,
      *)

    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

class function TMySQLUser.DBClassTitle: string;
begin
  Result:=sUser;
end;

procedure TMySQLUser.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;

function TMySQLUser.CreateSQLObject: TSQLCommandDDL;
begin
  if State = sdboCreate then
    Result:=TMySQLCreateUser.Create(nil)
  else
  begin
    Result:=TMySQLAlterUser.Create(nil);
  end;
end;

{ TMySQLUsersRoot }

function TMySQLUsersRoot.GetObjectType: string;
begin
  Result:='Users'
end;

function TMySQLUsersRoot.DBMSObjectsList: string;
begin
  Result:=MySqlModule.sqlUsers.ExpandMacros;
end;

constructor TMySQLUsersRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okUser;
  FDropCommandClass:=TMySQLDropUser;
end;

{ TMySQLFunctionsRoot }

function TMySQLFunctionsRoot.DBMSObjectsList: string;
begin
  MySqlModule.sqlProcedures.MacroByName('schema').Value:='''' + TSQLEngineMySQL(OwnerDB).DataBaseName + '''';
  Result:=MySqlModule.sqlProcedures.ExpandMacros;
end;

function TMySQLFunctionsRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.ObjType = 'FUNCTION');
end;

function TMySQLFunctionsRoot.GetObjectType: string;
begin
  Result:='Function'
end;

constructor TMySQLFunctionsRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okFunction;
  FDropCommandClass:=TMySQLDropFunction;
end;

{ TMySQLIndexItem }

constructor TMySQLIndexItem.CreateFromDB(AOwner: TMySQLTable; DS: TDataSet);
var
  S:string;
begin
  inherited Create;
  IndexName:=DS.FieldByName('KEY_NAME').AsString;
  Descending:=DS.FieldByName('COLLATION').AsString<>'A';

  S:='';
  while (not DS.EOF) and (IndexName = DS.FieldByName('KEY_NAME').AsString) do
  begin
    if S<>'' then
      S:=S+',';
    S:=S+DS.FieldByName('KEY_NAME').AsString;
    DS.Next;
  end;

  if IndexName <> DS.FieldByName('KEY_NAME').AsString then
    DS.Prior;

  IndexField:=S;
end;

{ TMySQLProceduresRoot }

function TMySQLProceduresRoot.DBMSObjectsList: string;
begin
  MySqlModule.sqlProcedures.MacroByName('schema').Value:='''' + TSQLEngineMySQL(OwnerDB).DataBaseName + '''';
  Result:=MySqlModule.sqlProcedures.ExpandMacros;
end;

function TMySQLProceduresRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.ObjType = 'PROCEDURE');
end;

function TMySQLProceduresRoot.GetObjectType: string;
begin
  Result:='Procedure';
end;

constructor TMySQLProceduresRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okStoredProc;
  FDropCommandClass:=TMySQLDropFunction;
end;

{ TMySQLProcedure }

function TMySQLProcedure.InternalGetDDLCreate: string;
var
  FCmd: TMySQLCreateFunction;
begin
  FCmd:=TMySQLCreateFunction.Create(nil);
  FCmd.ObjectKind:=DBObjectKind;
  FCmd.Name:=Caption;
  FCmd.Body:=ProcedureBody;
  FCmd.DetermType:=DetermType;
  FCmd.Description:=Description;
  FCmd.Definer:=Definer;

  FieldsIN.SaveToSQLFields(FCmd.Fields);

  Result:=FCmd.AsSQL;
  FCmd.Free;
end;

procedure TMySQLProcedure.RefreshParams;
var
  Q: TZQuery;
  F: TDBField;
  S: String;
begin
  inherited RefreshParams;
  FResultType.Clear;

  Q:=TSQLEngineMySQL(OwnerDB).GetSqlQuery(MySqlModule.sqlProcedureParams.ExpandMacros);
  Q.ParamByName('SPECIFIC_SCHEMA').AsString:=OwnerDB.DataBaseName;
  Q.ParamByName('SPECIFIC_NAME').AsString:=Caption;
  try
    Q.Open;
    while not Q.EOF do
    begin
      if Q.FieldByName('ORDINAL_POSITION').AsInteger = 0 then
        F:=FResultType
      else
      begin
        F:=FieldsIN.Add(Q.FieldByName('PARAMETER_NAME').AsString);
        F.FieldNum:=Q.FieldByName('ORDINAL_POSITION').AsInteger;
      end;

      S:=Q.FieldByName('PARAMETER_MODE').AsString;
      if S = 'IN' then
        F.IOType:=spvtInput
      else
      if S = 'OUT' then
        F.IOType:=spvtOutput
        ;
      F.FieldCharSetName:=Q.FieldByName('CHARACTER_SET_NAME').AsString;
      F.FieldSize:=Q.FieldByName('NUMERIC_SCALE').AsInteger;
      F.FieldPrec:=Q.FieldByName('NUMERIC_PRECISION').AsInteger;
      F.FieldCollateName:=Q.FieldByName('COLLATION_NAME').AsString;
      F.FieldComputedSource:=Q.FieldByName('DTD_IDENTIFIER').AsString;
      F.FieldTypeName:=Q.FieldByName('DATA_TYPE').AsString;

      //CHARACTER_MAXIMUM_LENGTH,
      //CHARACTER_OCTET_LENGTH,
      //DATETIME_PRECISION,
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

constructor TMySQLProcedure.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  FACLList:=TMySQLACLList.Create(Self);
  FACLList.ObjectGrants:=[ogExecute, ogAlterRoutine];
  FResultType:=TDBField.Create(Self);

  FParams:=TObjectList.Create;
end;

destructor TMySQLProcedure.Destroy;
begin
  if Assigned(FResultType) then
    FreeAndNil(FResultType);
  inherited Destroy;
end;

class function TMySQLProcedure.DBClassTitle: string;
begin
  Result:=sProcedure;
end;

function TMySQLProcedure.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=TMySQLCreateFunction.Create(nil);
  TMySQLCreateFunction(Result).ObjectKind:=DBObjectKind;
end;


procedure TMySQLProcedure.RefreshObject;
var
  Q:TZQuery;
begin
  if State <> sdboEdit then exit;
  inherited RefreshObject;

  Q:=TSQLEngineMySQL(OwnerDB).GetSqlQuery(MySqlModule.sqlProcedure.ExpandMacros);
  Q.ParamByName('ROUTINE_SCHEMA').AsString:=OwnerDB.DataBaseName;
  Q.ParamByName('ROUTINE_NAME').AsString:=Caption;
  try
    Q.Open;
    FProcedureBody:=Q.FieldByName('ROUTINE_DEFINITION').AsString;
    FDescription:= Q.FieldByName('ROUTINE_COMMENT').AsString;
    if Q.FieldByName('SECURITY_TYPE').AsString = 'DEFINER' then
      Security:=psDefiner
    else
    if Q.FieldByName('SECURITY_TYPE').AsString = 'INVOKER' then
      Security:=psInvoker;

    if Q.FieldByName('IS_DETERMINISTIC').AsString = 'NO' then
      DetermType:=ptNotDeterministic
    else
    if Q.FieldByName('IS_DETERMINISTIC').AsString = 'YES' then
      DetermType:=ptDeterministic
    else
      DetermType:=ptUnknow;

    FDefiner:=Q.FieldByName('DEFINER').AsString;

    if Q.FieldByName('SQL_DATA_ACCESS').AsString = 'CONTAINS SQL' then
      SqlAccess:=saContainsSql
    else
    if Q.FieldByName('SQL_DATA_ACCESS').AsString = 'NO SQL' then
      SqlAccess:=saNoSql
    else
    if Q.FieldByName('SQL_DATA_ACCESS').AsString = 'READS SQL DATA' then
      SqlAccess:=saReadsSqlData
    else
    //if Q.FieldByName('SQL_DATA_ACCESS').AsString = 'MODIFIES SQL DATA' then
      SqlAccess:=saModifiesSqlData;


    //SPECIFIC_NAME,
    //ROUTINE_CATALOG,
    //ROUTINE_SCHEMA,
    //ROUTINE_NAME,
    //ROUTINE_TYPE,
    //DATA_TYPE,
    //CHARACTER_MAXIMUM_LENGTH,
    //CHARACTER_OCTET_LENGTH,
    //NUMERIC_PRECISION,
    //NUMERIC_SCALE,
    //DATETIME_PRECISION,
    //CHARACTER_SET_NAME,
    //COLLATION_NAME,
    //DTD_IDENTIFIER,
    //ROUTINE_BODY,
    //ROUTINE_DEFINITION,
    //EXTERNAL_NAME,
    //EXTERNAL_LANGUAGE,
    //PARAMETER_STYLE,
    //SQL_PATH,
    //CREATED,
    //LAST_ALTERED,
    //SQL_MODE,
    //CHARACTER_SET_CLIENT,
    //COLLATION_CONNECTION,
    //DATABASE_COLLATION

    Q.Close;

    RefreshParams;
  finally
    Q.Free;
  end;
end;

{ TMySQLView }

function TMySQLView.InternalGetDDLCreate: string;
var
  FCmd: TMySQLCreateView;
begin
  FCmd:=TMySQLCreateView.Create(nil);
  FCmd.Name:=Caption;
  Fields.SaveToSQLFields(FCmd.Fields);
  FCmd.SQLSelect:=SQLBody;
  Result:=FCmd.AsSQL;
  FCmd.Free;
end;

function TMySQLView.GetDDLAlter: string;
begin
  GetDDLAlter:=InternalGetDDLCreate;
end;

procedure TMySQLView.RefreshObject;
var
  Q:TZQuery;
begin
  if State <> sdboEdit then exit;
  inherited RefreshObject;

  Q:=TSQLEngineMySQL(OwnerDB).GetSqlQuery(MySqlModule.sqlView1.ExpandMacros);
  Q.ParamByName('name').AsString:=Caption;
  Q.ParamByName('schema').AsString:=TSQLEngineMySQL(OwnerDB).DataBaseName;
  try
    Q.Open;
    FSQLBody:=Q.FieldByName('view_definition').AsString;
  finally
    Q.Free;
  end;
  RefreshFieldList;
end;

procedure TMySQLView.RefreshFieldList;
var
  QFields: TZQuery;
  Rec: TMySQLField;
begin
  if State <> sdboEdit then exit;
  Fields.Clear;

  QFields:=TSQLEngineMySQL(OwnerDB).GetSqlQuery(MySqlModule.sqlCollumns.ExpandMacros);
  try
    QFields.ParamByName('schema').AsString:=OwnerDB.DataBaseName;
    QFields.ParamByName('table_name').AsString:=Caption;
    QFields.Open;
    while not QFields.Eof do
    begin
      Rec:=Fields.Add('') as TMySQLField;
      Rec.LoadfromDB(QFields);
      QFields.Next;
    end;
  finally
    QFields.Free;
  end;
end;

function TMySQLView.GetRecordCount: integer;
var
  Q:TZQuery;
begin
  Q:=TSQLEngineMySQL(OwnerDB).GetSqlQuery('select count(*) as count_record from ' + Caption);
  try
    Q.Open;
    Result:=Q.FieldByName('count_record').AsInteger;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TMySQLView.GetDBFieldClass: TDBFieldClass;
begin
  Result:=TMySQLField;
end;

constructor TMySQLView.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject
  );
begin
  inherited Create(ADBItem, AOwnerRoot);
  FDataSet:=TZQuery.Create(nil);
  FDataSet.AfterOpen:=@DataSetAfterOpen;
  TZQuery(FDataSet).Connection:=TSQLEngineMySQL(OwnerDB).FConnection;
end;

destructor TMySQLView.Destroy;
begin
  inherited Destroy;
end;

class function TMySQLView.DBClassTitle: string;
begin
  Result:=sView;
end;

function TMySQLView.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=TMySQLCreateView.Create(nil);
end;

procedure TMySQLView.Commit;
begin
  inherited Commit;
end;

procedure TMySQLView.RollBack;
begin
  inherited RollBack;
end;

function TMySQLView.DataSet(ARecCountLimit: integer): TDataSet;
begin
  if not FDataSet.Active then
  begin
    TZQuery(FDataSet).SQL.Text:='select * from '+Caption;
  end;
  FDataSet.Active:=true;
  Result:=FDataSet;
end;

procedure TMySQLView.TriggersListRefresh;
begin

end;

procedure TMySQLView.RefreshDependencies;
begin
  //inherited RefreshDependencies;
end;


{ TMySQLViewsRoot }

function TMySQLViewsRoot.DBMSObjectsList: string;
begin
  MySqlModule.sqlViews.MacroByName('schema').Value:='''' + TSQLEngineMySQL(OwnerDB).DataBaseName + '''';
  Result:=MySqlModule.sqlViews.ExpandMacros;
end;

function TMySQLViewsRoot.GetObjectType: string;
begin
  Result:='View';
end;

constructor TMySQLViewsRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okView;
  FDropCommandClass:=TMySQLDropView;
end;

{ TMySQLField }

procedure TMySQLField.LoadfromDB(DS: TDataSet);
var
  s_extra:string;
begin
  SystemField:=false;
  FieldNum:=DS.FieldByName('ORDINAL_POSITION').AsInteger;
  FieldName:=Trim(DS.FieldByName('COLUMN_NAME').AsString);
  FieldTypeName:=UpperCase(DS.FieldByName('data_type').AsString);
  FieldCharSetName:=UpperCase(DS.FieldByName('CHARACTER_SET_NAME').AsString);
  FieldCollateName:=UpperCase(DS.FieldByName('COLLATION_NAME').AsString);
  FieldNotNull:=DS.FieldByName('IS_NULLABLE').AsString <> 'YES';

  if DS.FieldByName('CHARACTER_MAXIMUM_LENGTH').AsString <> '' then
    FieldSize:=StrToIntDef(DS.FieldByName('CHARACTER_MAXIMUM_LENGTH').AsString, 0)
  else
  if DS.FieldByName('NUMERIC_PRECISION').AsString <> '' then
  begin
    FieldSize:=DS.FieldByName('NUMERIC_PRECISION').AsInteger+1;
    FieldPrec:=DS.FieldByName('NUMERIC_SCALE').AsInteger
  end
  else
    ;

  FFieldDescription:=Trim(DS.FieldByName('COLUMN_COMMENT').AsString);
  s_extra:=DS.FieldByName('EXTRA').AsString;

  FieldAutoInc:=Pos('auto_increment', s_extra)>0;

  {
  //    FieldUNIC:boolean;
  }
(*


FieldDefaultValue:=DS.FieldByName('adsrc').AsString;
{
FieldUNIC:boolean;
FieldPK:boolean;
}

//Result.FieldSQLTypeInt:=QFields.Fields.ByNameAsInteger['rdb$field_type'];
//FieldSQLSubTypeInt:integer;
//Result.FieldSQLSubTypeInt:=QFields.Fields.ByNameAsInteger['rdb$field_sub_type'];

//SystemField:boolean; //always false

{
//    FieldTypeDB:TFieldType;
//    FieldUNIC:boolean;
//    FieldPK:boolean;
*)
end;

function TMySQLField.FieldTypeStr: string;
begin
  Result:='';
  if Assigned(FieldTypeRecord) then
      Result:=Result + FieldTypeRecord.GetFieldTypeStr(FieldSize, FieldPrec)
  else
    { TODO : Тут надо дописать обработку дополнительных типов данных }
      ;
end;

function TMySQLField.GenDDL(AMode: TDDLMode): string;
begin
  Result:='ALTER TABLE '+Owner.Caption;
    if AMode = dmCreate then
      Result:=Result + ' ADD COLUMN '
    else
      Result:=Result + ' MODIFY COLUMN ';
    Result:=Result + FieldName;

    Result:=Result + FieldAtribs;
end;

function TMySQLField.FieldAtribs: string;
begin
  Result:=' ' + FieldTypeStr;
  if FieldNotNull then
    Result:=Result+' NOT NULL';

  if FieldAutoInc then
    Result:=Result+' AUTO_INCREMENT';

  if FFieldDescription <> '' then
    Result:=Result+' COMMENT '''+FFieldDescription+'''';
end;

function TMySQLField.AlterAddDDL: string;
begin
  Result:=GenDDL(dmCreate);
end;

procedure TMySQLField.SetFieldDescription(const AValue: string);
begin
  if AValue <> FFieldDescription then
  begin
    inherited SetFieldDescription(AValue);
    if Owner.State <> sdboCreate then
      ExecSQLScript(GenDDL(dmAlter), sysConfirmCompileDescEx, Owner.OwnerDB);
  end;
end;

{ TMySQLTriger }

function TMySQLTriger.InternalGetDDLCreate: string;
var
  FCmd: TMySQLCreateTrigger;
begin
  FCmd:=TMySQLCreateTrigger.Create(nil);
  FCmd.Name:=Caption;
  FCmd.TableName:=TableName;
  FCmd.Body:=TriggerBody;
  FCmd.TriggerType:=TriggerType;
  Result:=FCmd.AsSQL;
  FCmd.Free;
end;

function TMySQLTriger.GetTriggerBody: string;
begin
  Result:=FTriggerBody;
end;

procedure TMySQLTriger.SetTriggerBody(AValue: string);
var
  S: String;
  C: SizeInt;
begin
  S:=TrimRight(AValue);
  if Copy(S, 1, 2) = '/*' then
  begin
    C:=Pos('*/', S);
    if C>0 then
    begin
      FDescription:=Trim(Copy(S, 3, C-3));
      FTriggerBody:=TrimRight(Copy(S, C+2, Length(S)));
    end;
  end
  else
    FTriggerBody:=AValue;
end;

constructor TMySQLTriger.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
  begin
    TableName:=ADBItem.ObjRelName;
  end;
end;

class function TMySQLTriger.DBClassTitle: string;
begin
  Result:=sTrigger;
end;

function TMySQLTriger.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=TMySQLCreateTrigger.Create(nil);
end;

procedure TMySQLTriger.RefreshDependencies;
begin
  //TSQLEngineFireBird(OwnerDB).RefreshDependencies(Self);
end;

procedure TMySQLTriger.RefreshObject;
var
  Q:TZQuery;
begin
  if State <> sdboEdit then exit;

  inherited RefreshObject;

  FActive:=true;
  Q:=TSQLEngineMySQL(OwnerDB).GetSqlQuery(MySqlModule.sqlTriggerParam.ExpandMacros);
  Q.ParamByName('TRIGGER_NAME').AsString:=Caption;
  try
    Q.Open;
    TableName:=Trim(Q.FieldByName('EVENT_OBJECT_TABLE').AsString);
    TriggerType:=[];

    if Q.FieldByName('ACTION_TIMING').AsString = 'BEFORE' then
      TriggerType:=TriggerType + [ttBefore]
    else
      TriggerType:=TriggerType + [ttAfter];  //'AFTER'

    if Q.FieldByName('EVENT_MANIPULATION').AsString = 'INSERT' then
      TriggerType:=TriggerType + [ttInsert]
    else
    if Q.FieldByName('EVENT_MANIPULATION').AsString = 'UPDATE' then
      TriggerType:=TriggerType + [ttUpdate]
    else
    if Q.FieldByName('EVENT_MANIPULATION').AsString = 'DELETE' then
      TriggerType:=TriggerType + [ttDelete];

    SetTriggerBody(Q.FieldByName('ACTION_STATEMENT').AsString);
    Q.Close;
  finally
    Q.Free;
  end;
  FTriggerTable:=TSQLEngineMySQL(OwnerDB).TablesRoot.ObjByName(TableName) as TDBDataSetObject;
end;

{ TMySQLTriggersRoot }

function TMySQLTriggersRoot.GetObjectType: string;
begin
  Result:='Trigger';
end;

function TMySQLTriggersRoot.DBMSObjectsList: string;
begin
  MySqlModule.sqlTriggers.MacroByName('schema').Value:='''' + TSQLEngineMySQL(OwnerDB).DataBaseName + '''';
  Result:=MySqlModule.sqlTriggers.ExpandMacros;
end;

constructor TMySQLTriggersRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okTrigger;
  FDropCommandClass:=TMySQLDropTrigger;
end;

{ TMySQLTable }
procedure TMySQLTable.SetEngine(AValue: string);
begin
  if FEngine=AValue then Exit;
  FEngine:=AValue;
end;

function TMySQLTable.InternalGetDDLCreate: string;
var
  FCmd: TMySQLCreateTable;
  P: TPrimaryKeyRecord;
  C: TSQLConstraintItem;
  FkRec: TForeignKeyRecord;
  i: Integer;
  ACL: TStringList;
begin
  FCmd:=TMySQLCreateTable.Create(nil);
  FCmd.Name:=Caption;
  Fields.SaveToSQLFields(FCmd.Fields);
  FCmd.EngineName:=Engine;

  for i:=0 to FConstraintList.Count - 1 do
  begin
    P:=TPrimaryKeyRecord(FConstraintList[i]);
    if TPrimaryKeyRecord(FConstraintList[i]).ConstraintType = ctPrimaryKey then
    begin
      C:=FCmd.SQLConstraints.Add(ctPrimaryKey, P.Name);
      C.ConstraintFields.CopyFrom(P.FieldListArr);
      break;
    end;
  end;

  for i:=0 to FConstraintList.Count - 1 do
  begin
    if TPrimaryKeyRecord(FConstraintList[i]).ConstraintType = ctForeignKey then
    begin
      FkRec:=TForeignKeyRecord(FConstraintList[i]);
      C:=FCmd.SQLConstraints.Add(ctForeignKey, FkRec.Name);
      C.ConstraintFields.CopyFrom(FkRec.FieldListArr);
      C.ForeignTable:=FkRec.FKTableName;
      C.ForeignKeyRuleOnUpdate:=FkRec.OnUpdateRule;
      C.ForeignKeyRuleOnDelete:=FkRec.OnDeleteRule;
      C.ForeignFields.AsString:=FkRec.FKFieldName;
    end;
  end;

  Result:=FCmd.AsSQL;
  FCmd.Free;

  ACL:=TStringList.Create;
  try
    FACLList.RefreshList;
    FACLList.MakeACLListSQL(nil, ACL, true);
    Result:=Result + LineEnding + LineEnding + ACL.Text;
  finally
    ACL.Free;
  end;

end;

function TMySQLTable.GetTrigger(ACat: integer; AItem: integer): TDBTriggerObject;
begin
  if (ACat>=0) and (ACat<6) then
    Result:=TMySQLTriger(FTriggerList[ACat].Items[AItem])
  else
    Result:=nil;
end;

function TMySQLTable.GetTriggersCategories(AItem: integer): string;
begin
  case AItem of
    0:Result:=sBeforeInsert;
    1:Result:=sAfterInsert;
    2:Result:=sBeforeUpdate;
    3:Result:=sAfterUpdate;
    4:Result:=sBeforeDelete;
    5:Result:=sAfterDelete;
  else
    Result:='';
  end;
end;

function TMySQLTable.GetTriggersCategoriesCount: integer;
begin
  Result:=6;
  if FTriggerList[0].Count = 0 then
    TriggersListRefresh;
end;

function TMySQLTable.GetTriggersCount(AItem: integer): integer;
begin
  if (AItem >=0) and (AItem<6) then
    Result:=FTriggerList[AItem].Count
  else
    Result:=0;
end;

function TMySQLTable.GetTriggersCategoriesType(AItem: integer): TTriggerTypes;
begin
  case AItem of
    0:Result:=[ttBefore, ttInsert];
    1:Result:=[ttAfter, ttInsert];
    2:Result:=[ttBefore, ttUpdate];
    3:Result:=[ttAfter, ttUpdate];
    4:Result:=[ttBefore, ttDelete];
    5:Result:=[ttAfter, ttDelete];
  else
    Result:=[];
  end;
end;

function TMySQLTable.GetRecordCount: integer;
var
  Q:TZQuery;
begin
  Result:=inherited GetRecordCount;
  Q:=TSQLEngineMySQL(OwnerDB).GetSqlQuery('select count(*) from '+CaptionFullPatch);
  try
    Q.Open;
    if Q.RecordCount>0 then
      Result:=Q.Fields[0].AsInteger
    else
      Result:=0;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TMySQLTable.GetDBFieldClass: TDBFieldClass;
begin
  Result:=TMySQLField;
end;

constructor TMySQLTable.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject
  );
begin
  inherited Create(ADBItem, AOwnerRoot);

  FACLList:=TMySQLACLList.Create(Self);
  FACLList.ObjectGrants:=[ogSelect, ogInsert, ogUpdate, ogDelete, ogReference, ogTrigger,
     ogCreate, ogDrop, ogIndex, ogAlter, ogCreateView, ogShowView];

  FEngine:='InnoDB';
  UITableOptions:=[utReorderFields,
      utAddFields, utEditField, utDropFields,
      utAddFK, utDropFK,
      utAddUNQ, utDropUNQ,
      utAlterAddFieldInitialValue];

  FDataSet:=TZQuery.Create(nil);
  TZQuery(FDataSet).Connection:=TSQLEngineMySQL(OwnerDB).FConnection;
  FDataSet.AfterOpen:=@DataSetAfterOpen;
  FSystemObject:=AOwnerRoot.SystemObject;



  FTriggerList[0]:=TList.Create;  //before insert
  FTriggerList[1]:=TList.Create;  //after insert
  FTriggerList[2]:=TList.Create;  //before update
  FTriggerList[3]:=TList.Create;  //after update
  FTriggerList[4]:=TList.Create;  //before delete
  FTriggerList[5]:=TList.Create;  //after delete
end;

destructor TMySQLTable.Destroy;
begin
  FreeAndNil(FTriggerList[0]);  //before insert
  FreeAndNil(FTriggerList[1]);  //after insert
  FreeAndNil(FTriggerList[2]);  //before update
  FreeAndNil(FTriggerList[3]);  //after update
  FreeAndNil(FTriggerList[4]);  //before delete
  FreeAndNil(FTriggerList[5]);  //after delete
  inherited Destroy;
end;

procedure TMySQLTable.RefreshObject;
var
  Q:TZQuery;
begin
  if State <> sdboEdit then exit;
  inherited RefreshObject;

  Q:=TSQLEngineMySQL(OwnerDB).GetSqlQuery(MySqlModule.sqlTable.ExpandMacros);
  Q.ParamByName('name').AsString:=Caption;
  Q.ParamByName('schema').AsString:=TSQLEngineMySQL(OwnerDB).DataBaseName;
  try
    Q.Open;
    FEngine:=Q.FieldByName('engine').AsString;
  finally
    Q.Free;
  end;
  RefreshFieldList;
end;


class function TMySQLTable.DBClassTitle: string;
begin
  Result:=sTable;
end;

(*
function TMySQLTable.CreateTable(ATableName: string): boolean;
begin
  if State = sdboCreate then
    FCaption:=ATableName;
  Result:=true;
end;

procedure TMySQLTable.FieldEdit(const FieldName: string);
var
  Rec:TMySQLField;
begin
  Rec:=FFields.FieldByName(FieldName) as TMySQLField;
  fbmTableFieldEditorForm:=TfbmTableFieldEditorForm.CreateFieldEditor(Self);

  fbmTableFieldEditorForm.edtFieldName.Text := Rec.FieldName;
  fbmTableFieldEditorForm.cbNotNull.Checked := Rec.FieldNotNull;

{  if Rec.FieldTypeDomain<>'' then
    fbmTableFieldEditorForm.cbDomains.Text:=Rec.FieldTypeDomain
  else
  begin}
    fbmTableFieldEditorForm.edtSize.Value         := Rec.FieldSize;
    fbmTableFieldEditorForm.edtScale.Value        := Rec.FieldPrec;
    //fbmTableFieldEditorForm.cbFieldType.ItemIndex := ord(Rec.FieldType)-1;
{  end;}

  fbmTableFieldEditorForm.edtDescription1.Text   := Rec.FFieldDescription;
  fbmTableFieldEditorForm.cbPrimaryKey.Checked  := Rec.FieldPK;

  fbmTableFieldEditorForm.cbDomainCheck.Checked:=Rec.FieldTypeDomain<>'';
  fbmTableFieldEditorForm.cbCustomTypeCheck.Checked:=Rec.FieldTypeDomain='';
  fbmTableFieldEditorForm.cbAutoIncField.Checked:=Rec.FieldAutoInc;

  if fbmTableFieldEditorForm.ShowModal = mrOk then
  begin
(*    if State = sdboEdit then
    begin
      S:='';
      if Rec.FieldName <> fbmTableFieldEditorForm.edtFieldName.Text then
      begin
        S:=Format('ALTER TABLE %s ALTER %s TO %s', [CaptionFullPatch, Rec.FieldName, fbmTableFieldEditorForm.edtFieldName.Text]);
      end;
      if S<>'' then
        FOwnerDB.ExecSQL(S, [sepShowCompForm]);


{      S:=fbmTableFieldEditorForm.sqlFieldAdd;
      if TDataBaseRecord(FOwnerDB.InspectorRecord).ExecSQLScript(S) then
        FieldListRefresh;}
    end
    else
    begin*)
      Rec.FieldName:=fbmTableFieldEditorForm.edtFieldName.Text;
      Rec.FieldNotNull:=fbmTableFieldEditorForm.cbNotNull.Checked;
{      if fbmTableFieldEditorForm.cbDomainCheck.Checked then
        Rec.FieldTypeDomain:=fbmTableFieldEditorForm.cbDomains.Text
      else
      begin}
        Rec.FieldTypeName:=fbmTableFieldEditorForm.cbFieldType.Text;
        Rec.FieldSQLTypeInt:=fbmTableFieldEditorForm.cbFieldType.ItemIndex;
        Rec.FieldSize:=fbmTableFieldEditorForm.edtSize.Value;
        Rec.FieldPrec:=fbmTableFieldEditorForm.edtScale.Value;
//      end;
      Rec.FFieldDescription:=fbmTableFieldEditorForm.edtDescription1.Text;
      Rec.FieldPK:=fbmTableFieldEditorForm.cbPrimaryKey.Checked;
      Rec.FieldAutoInc:=fbmTableFieldEditorForm.cbAutoIncField.Checked;
      //Rec.FieldType:=TdbmsFieldType(fbmTableFieldEditorForm.cbFieldType.ItemIndex+1);
{    end;}
    if State = sdboEdit then
    begin
      SQLScriptsBegin;
      SQLScriptsExec(Rec.GenDDL(dmAlter), []);
      SQLScriptsApply;
      SQLScriptsEnd;
      FieldListRefresh;
    end;
  end;
  fbmTableFieldEditorForm.Free;
end;

function TMySQLTable.FieldNew: string;
var
  Rec:TMySQLField;
begin
  fbmTableFieldEditorForm:=TfbmTableFieldEditorForm.CreateFieldEditor(Self);
  if fbmTableFieldEditorForm.ShowModal = mrOk then
  begin
    Rec:=TMySQLField.Create(Self);
    FFields.Add(Rec);
    Rec.FieldName:=fbmTableFieldEditorForm.edtFieldName.Text;
    Rec.FieldNotNull:=fbmTableFieldEditorForm.cbNotNull.Checked;
    if fbmTableFieldEditorForm.cbDomainCheck.Checked then
      Rec.FieldTypeDomain:=fbmTableFieldEditorForm.cbDomains.Text
    else
    begin
      Rec.FieldTypeName:=fbmTableFieldEditorForm.cbFieldType.Text;
      Rec.FieldSQLTypeInt:=fbmTableFieldEditorForm.cbFieldType.ItemIndex;
      Rec.FieldSize:=fbmTableFieldEditorForm.edtSize.Value;
      Rec.FieldPrec:=fbmTableFieldEditorForm.edtScale.Value;
    end;
    Rec.FFieldDescription:=fbmTableFieldEditorForm.edtDescription1.Text;
    Rec.FieldAutoInc:=fbmTableFieldEditorForm.cbAutoIncField.Checked;
    Rec.SystemField:=false;
    Rec.FieldPK:=fbmTableFieldEditorForm.cbPrimaryKey.Checked;

    //  FieldUNIC:boolean;
    Result:=Rec.FieldName;
    if State = sdboEdit then
    begin
      SQLScriptsBegin;
      SQLScriptsExec(Rec.AlterAddDDL, []);
      SQLScriptsApply;
      SQLScriptsEnd;
      FieldListRefresh;
    end;
  end;
  fbmTableFieldEditorForm.Free;
end;

procedure TMySQLTable.FieldDelete(const FieldName: string);
var
  Rec:TMySQLField;
begin
  if State = sdboEdit then
  begin
    Rec:=FFields.FieldByName(FieldName) as TMySQLField;
    if Assigned(Rec) then
      ExecSQLScript(
        Rec.GenDDL(dmDrop), [sepInTransaction, sepShowCompForm], OwnerDB);
    IndexListRefresh;
  end
  else
    FFields.DeleteField(FieldName);
end;
*)

procedure TMySQLTable.RefreshFieldList;
var
  QFields:TZQuery;
  Rec:TMySQLField;
begin
  if State <> sdboEdit then exit;
  Fields.Clear;

  QFields:=TSQLEngineMySQL(OwnerDB).GetSqlQuery(MySqlModule.sqlCollumns.ExpandMacros);
  try
    QFields.ParamByName('schema').AsString:=OwnerDB.DataBaseName;
    QFields.ParamByName('table_name').AsString:=Caption;
    QFields.Open;
    while not QFields.Eof do
    begin
      Rec:=Fields.Add('') as TMySQLField;
      Rec.LoadfromDB(QFields);
      QFields.Next;
    end;
  finally
    QFields.Free;
  end;

  RefreshConstraintPrimaryKey;
end;

function TMySQLTable.RenameObject(ANewName: string): Boolean;
var
  FCmd: TMySQLAlterTable;
  Op: TAlterTableOperator;
begin
  if (State = sdboCreate) then
  begin
    Caption:=ANewName;
    Result:=true;
  end
  else
  begin
    FCmd:=TMySQLAlterTable.Create(nil);
    FCmd.Name:=Caption;
    Op:=FCmd.AddOperator(ataRenameTable);
    Op.ParamValue:=ANewName;
    Result:=CompileSQLObject(FCmd, [sepInTransaction, sepShowCompForm, sepNotRefresh]);
    FCmd.Free;
    if Result then
    begin
      Caption:=ANewName;
      RefreshObject;
    end;
  end;
end;

procedure TMySQLTable.SetFieldsOrder(AFieldsList: TStrings);
var
  ASql:TStringList;
  FCmd:TMySQLAlterTable;
  FOper: TAlterTableOperator;
  i: Integer;
  F: TDBField;
begin
  ASql:=TStringList.Create;
  FCmd:=TMySQLAlterTable.Create(nil);
  FCmd.Name:=CaptionFullPatch;
  FOper:=FCmd.AddOperator(ataAlterCol);
  for i:=0 to AFieldsList.Count-1 do
  begin
    FCmd.Clear;
    FOper.Field.Caption:=AFieldsList[i];
    F:=Fields.FieldByName(FOper.Field.Caption);

    if Assigned(F) then
    begin
      FOper.Field.Params:=[];
      FOper.Field.TypeName:=F.FieldTypeName;
      FOper.Field.Description:=F.FieldDescription;
      FOper.Field.TypeLen:=F.FieldSize;
      FOper.Field.TypePrec:=F.FieldPrec;

      if F.FieldAutoInc then
        FOper.Field.Params:=FOper.Field.Params + [fpAutoInc];

      if F.FieldNotNull then
        FOper.Field.Params:=FOper.Field.Params + [fpNotNull];
{      fpBinary, fpUnsigned, fpZeroFill, fpNull,
    fpPrimaryKey, fpVirtual, fpStored;}
    end;

    if i = 0 then
      FOper.Field.FieldPosition:='FIRST'
    else
      FOper.Field.FieldPosition:='AFTER '+AFieldsList[i-1];

    ASql.Add(FCmd.AsSQL);
  end;
  ExecSQLScriptEx(ASql, [sepShowCompForm], OwnerDB);
  ASql.Free;
  FCmd.Free;
  //Установим первое поле
  //ALTER TABLE `spr_goods` MODIFY COLUMN `spr_goods_id` INTEGER(11) NOT NULL AUTO_INCREMENT FIRST
  //ALTER TABLE `spr_goods_group` MODIFY COLUMN `spr_goods_group_name` VARCHAR(200) COLLATE latin1_swedish_ci DEFAULT NULL AFTER `spr_goods_group_id`
end;

function TMySQLTable.IndexDelete(const IndexName: string): boolean;
begin
  Result:=ExecSQLScript(Format(ssql_My_IndDrop, [Caption, IndexName]), [sepInTransaction, sepShowCompForm], OwnerDB);
  if Result then
  begin
    IndexArrayClear;
    RefreshConstraintForeignKey;
  end;
end;

procedure TMySQLTable.IndexListRefresh;
var
  FQuery:TZQuery;
  Rec:TMySQLIndexItem;
begin
  IndexArrayClear;
  FQuery:=TSQLEngineMySQL(OwnerDB).GetSQLQuery( MySqlModule.sqlTableIndex.ExpandMacros+' ' + Caption);
  try
    FQuery.Open;
    while not FQuery.Eof do
    begin
      Rec:=TMySQLIndexItem.CreateFromDB(Self, FQuery);
      FIndexItems.Add(Rec);
      FQuery.Next;
    end;
  finally
    FQuery.Free;
  end;
  FIndexListLoaded:=true;
end;

function TMySQLTable.CreateSQLObject: TSQLCommandDDL;
begin
  if State <> sdboCreate then
  begin
    Result:=TMySQLAlterTable.Create(nil);
    Result.Name:=Caption;
  end
  else
    Result:=TMySQLCreateTable.Create(nil);
end;

procedure TMySQLTable.RefreshConstraintPrimaryKey;
var
  I:integer;
  Q, Q1:TZQuery;
  Rec:TPrimaryKeyRecord;
  S_FldList:string;
  F: TDBField;
begin
  inherited RefreshConstraintPrimaryKey;

  Q:=TSQLEngineMySQL(OwnerDB).GetSqlQuery(MySqlModule.sqlTableConstrName.ExpandMacros);
  Q1:=TSQLEngineMySQL(OwnerDB).GetSqlQuery(MySqlModule.sqlKeyFields.ExpandMacros);
  try
    Q.ParamByName('TABLE_SCHEMA').AsString:=OwnerDB.DataBaseName;
    Q.ParamByName('TABLE_NAME').AsString:=Caption;
    Q.ParamByName('CONSTRAINT_TYPE').AsString:='PRIMARY KEY';

    Q1.ParamByName('TABLE_SCHEMA').AsString:=OwnerDB.DataBaseName;
    Q1.ParamByName('TABLE_NAME').AsString:=Caption;

    Q.Open;
    while not Q.Eof do
    begin
      Rec:=TPrimaryKeyRecord.Create;
      FConstraintList.Add(Rec);
      Rec.Name:=Q.FieldByName('CONSTRAINT_NAME').AsString;

      S_FldList:='';
      Q1.ParamByName('CONSTRAINT_NAME').AsString:=Rec.Name;
      Q1.Open;
      while not Q1.EOF do
      begin
        if S_FldList<>'' then
          S_FldList:=S_FldList + ',';
        S_FldList:=S_FldList + Q1.FieldByName('COLUMN_NAME').AsString;

        F:=Fields.FieldByName(Q1.FieldByName('COLUMN_NAME').AsString);
        if Assigned(F) then
          F.FieldPK:=true;

        Q1.Next;
      end;
      Q1.Close;

      Rec.FieldList:=S_FldList;

      Q.Next;
    end;
  finally
    Q.Free;
    Q1.Free;
  end;
end;
(*
function TMySQLTable.FKNew(const Name, FieldsList, RefTable, RefFields,
  IndexName: string; const OnUpdateRule, OnDeleteRule: TForeignKeyRule;
  const IndexSortOrder: TIndexSortOrder): boolean;
var
  S:string;
begin
  //ALTER TABLE `tb_client_acc` ADD CONSTRAINT `tb_client_acc_fk1` FOREIGN KEY (`tb_client_id`) REFERENCES `tb_client` (`tb_client_id`) ON DELETE CASCADE ON UPDATE CASCADE;
  S:=Format(ssql_My_FKNew, [Caption, Name, FieldsList, RefTable, RefFields]);


  if OnUpdateRule<>fkrNone then
    S:=S+' on update '+ForeignKeyRuleNames[OnUpdateRule];

  if OnDeleteRule<>fkrNone then
    S:=S+' on delete '+ForeignKeyRuleNames[OnDeleteRule];

{  if IndexName<>'' then
    S:=S + ' using index ' + IndexName;}

  Result:=ExecSQLScript(S, [sepInTransaction, sepShowCompForm], OwnerDB);
  if Result then
  begin
    IndexArrayClear;
    FKListRefresh;
  end;
end;

function TMySQLTable.FKDrop(const FKName: string): boolean;
begin
  Result:=ExecSQLScript(Format(ssql_My_FKDrop, [Caption, FKName]), [sepInTransaction, sepShowCompForm], OwnerDB);
  if Result then
  begin
    IndexArrayClear;
    FKListRefresh;
  end;
end;
*)
procedure TMySQLTable.RefreshConstraintForeignKey;
var
  Q:TZQuery;
  T:TMySQLTable;
  Rec:TForeignKeyRecord;
begin
  inherited RefreshConstraintForeignKey;
  Q:=TSQLEngineMySQL(OwnerDB).GetSqlQuery(MySqlModule.sqlFKList.ExpandMacros);
  try
    Q.ParamByName('TABLE_SCHEMA').AsString:=OwnerDB.DataBaseName;
    Q.ParamByName('TABLE_NAME').AsString:=Caption;

    Q.Open;
    while not Q.Eof do
    begin
      Rec:=TForeignKeyRecord.Create;
      FConstraintList.Add(Rec);
      Rec.Name:=Q.FieldByName('CONSTRAINT_NAME').AsString;
      Rec.FieldList:=Q.FieldByName('COLUMN_NAME').AsString;

      Rec.OnUpdateRule:=StrToForeignKeyRule(Q.FieldByName('UPDATE_RULE').AsString);
      Rec.OnDeleteRule:=StrToForeignKeyRule(Q.FieldByName('DELETE_RULE').AsString);

      T:=TSQLEngineMySQL(OwnerDB).TablesRoot.ObjByName(Q.FieldByName('REFERENCED_TABLE_NAME').AsString) as TMySQLTable;
      if Assigned(T) then
      begin
        Rec.FKTableName:=T.CaptionFullPatch;
        Rec.FKFieldName:=Q.FieldByName('REFERENCED_COLUMN_NAME').AsString;
      end;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;


function TMySQLTable.DataSet(ARecCountLimit: Integer): TDataSet;
begin
  if not FDataSet.Active then
  begin
    TZQuery(FDataSet).SQL.Text:='select * from '+Caption;
{    FDataSet.SQL.Text:=MakeSQLSelect(Caption, FDataSet.DataBase);
    FDataSet.SQLEdit.Text:=MakeSQLEdit(Caption, FDataSet.DataBase);
    FDataSet.SQLInsert.Text:=MakeSQLInsert(Caption, FDataSet.DataBase);
    FDataSet.SQLDelete.Text:=MakeSQLDelete(Caption, FDataSet.DataBase);
    FDataSet.SQLRefresh.Text:=MakeSQLRefresh(Caption, FDataSet.DataBase);

    if FOwnerDB.DisplayDataOptions.FetchAllData then
      FDataSet.Option := FDataSet.Option + [poFetchAll]
    else
      FDataSet.Option := FDataSet.Option - [poFetchAll];}
  end;
  FDataSet.Active:=true;
  Result:=FDataSet;
end;

procedure TMySQLTable.TriggersListRefresh;
var
  i, Cat:integer;
  Trig:TMySQLTriger;
begin
  FTriggerList[0].Clear;
  FTriggerList[1].Clear;
  FTriggerList[2].Clear;
  FTriggerList[3].Clear;
  FTriggerList[4].Clear;
  FTriggerList[5].Clear;

  for i:=0 to TSQLEngineMySQL(OwnerDB).TriggersRoot.CountObject - 1 do
  begin
    Trig:=TMySQLTriger(TSQLEngineMySQL(OwnerDB).TriggersRoot.Items[i]);
    if Trig.TableName = Caption then
    begin
      if not Trig.Loaded then
        Trig.RefreshObject;

      if ttBefore in Trig.TriggerType then
      begin
        if ttInsert in Trig.TriggerType then
          FTriggerList[0].Add(Trig);
        if ttUpdate in Trig.TriggerType then
          FTriggerList[2].Add(Trig);
        if ttDelete in Trig.TriggerType then
          FTriggerList[4].Add(Trig);
      end;

      if ttAfter in Trig.TriggerType then
      begin
        if ttInsert in Trig.TriggerType then
          FTriggerList[1].Add(Trig);
        if ttUpdate in Trig.TriggerType then
          FTriggerList[3].Add(Trig);
        if ttDelete in Trig.TriggerType then
          FTriggerList[5].Add(Trig);
      end;
    end;
  end;
end;

function TMySQLTable.TriggerNew(TriggerTypes: TTriggerTypes): TDBTriggerObject;
begin
  Result:=OwnerDB.NewObjectByKind(TSQLEngineMySQL(OwnerDB).TriggersRoot, okTrigger) as TDBTriggerObject;
  if Assigned(Result) then
  begin
    Result.TableName:=Caption;
    Result.TriggerType:=TriggerTypes;
    Result.Active:=true;
    Result.RefreshEditor;
  end;
end;

function TMySQLTable.TriggerDelete(const ATrigger: TDBTriggerObject): Boolean;
begin
  Result:=TSQLEngineMySQL(OwnerDB).FTriggersRoot.DropObject(ATrigger);
end;

{ TMySQLTablesRoot }

function TMySQLTablesRoot.DBMSObjectsList: string;
begin
  MySqlModule.sqlTables.MacroByName('schema').Value:='''' + TSQLEngineMySQL(OwnerDB).DataBaseName + '''';
  Result:=MySqlModule.sqlTables.ExpandMacros;
end;

function TMySQLTablesRoot.GetObjectType: string;
begin
  Result:='Table';
end;
(*
function TMySQLTablesRoot.DropObject(AItem: TDBObject): boolean;
var
  i:integer;
begin
  Result:=ExecSQLScript(Format(ssql_My_TableDrop, [AItem.Caption]), [sepShowCompForm], OwnerDB);
  if Result then
    FObjects.Delete(AItem);
end;
*)
constructor TMySQLTablesRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okTable;
  FDropCommandClass:=TMySQLDropTable;
end;

{ TMySQLQueryControl }

procedure TMySQLQueryControl.SetParamValues;
begin

end;

function TMySQLQueryControl.GetDataSet: TDataSet;
begin
  Result:=FSQLQuery;
end;

function TMySQLQueryControl.GetQueryPlan: string;
begin
  Result:='';
end;

function TMySQLQueryControl.GetQuerySQL: string;
begin
  Result:=FSQLQuery.SQL.Text;
end;

procedure TMySQLQueryControl.SetQuerySQL(const AValue: string);
begin
  FSQLQuery.Active:=false;
  FSQLQuery.SQL.Text:=AValue;
end;

function TMySQLQueryControl.GetParam(AIndex: integer): TParam;
begin
  Result:=FSQLQuery.Params[AIndex];
end;

function TMySQLQueryControl.GetParamCount: integer;
begin
  Result:=FSQLQuery.Params.Count;
end;

procedure TMySQLQueryControl.SetActive(const AValue: boolean);
begin
  SetParamValues;
  inherited SetActive(AValue);
end;

constructor TMySQLQueryControl.Create(AOwner: TSQLEngineAbstract);
begin
  inherited Create(AOwner);
  FSQLQuery:=TZQuery.Create(nil);
  FSQLQuery.Connection:=TSQLEngineMySQL(AOwner).FConnection;
end;

destructor TMySQLQueryControl.Destroy;
begin
  FreeAndNil(FSQLQuery);
  inherited Destroy;
end;

procedure TMySQLQueryControl.CommitTransaction;
begin

end;

procedure TMySQLQueryControl.RolbackTransaction;
begin

end;

procedure TMySQLQueryControl.FetchAll;
begin
  FSQLQuery.FetchAll;
end;

procedure TMySQLQueryControl.Prepare;
begin
  FSQLQuery.Prepare;
end;

procedure TMySQLQueryControl.ExecSQL;
begin
  FSQLQuery.ExecSQL;
end;

{ TSQLEngineMySQL }

procedure TSQLEngineMySQL.InternalInitSQLEngineMySQL;
begin
  FConnection:=TZConnection.Create(nil);
  FConnection.Protocol:='mysql-5';
  FConnection.ClientCodepage:='utf8';

  FUIParams:=[upSqlEditor, upUserName, upPassword, upLocal, upRemote];

  FillMyFieldTypes(FTypeList);
  MiscOptions.VarPrefix:='';

  FSQLEngineCapability:=[okTable, okView, okTrigger, okStoredProc, okUDF, okUser,
                     okGroup, okIndex, okTableSpace, okCheckConstraint, okForeignKey,
                     okPrimaryKey, okUniqueConstraint, okAutoIncFields, okFunction];
end;

function TSQLEngineMySQL.GetImageIndex: integer;
begin
  if Connected then
    Result:=58
  else
    Result:=57;
end;

function TSQLEngineMySQL.InternalSetConnected(const AValue: boolean): boolean;
var
  HostName: String;
begin
  //inherited SetConnected(AValue);
  if AValue then
  begin
    FConnection.HostName:=ServerName;
    FConnection.Database:=DataBaseName;
    FConnection.User:=UserName;
    FConnection.Password:= Password;

    if RemotePort <> 0 then
      FConnection.Port:=RemotePort;

    FConnection.Connected:=true;

    InitKeywords;
  end
  else
  begin
    try
      if FConnection.InTransaction then
        FConnection.Rollback;
    finally
      FConnection.Connected:=false;
    end;
  end;
  Result:=FConnection.Connected;
end;

procedure TSQLEngineMySQL.InitGroupsObjects;
begin
  AddObjectsGroup(FTablesRoot, TMySQLTablesRoot, TMySQLTable, sTables);
  AddObjectsGroup(FViewsRoot, TMySQLViewsRoot, TMySQLView, sViews);
  AddObjectsGroup(FTriggersRoot, TMySQLTriggersRoot, TMySQLTriger, sTriggers);
  AddObjectsGroup(FProceduresRoot, TMySQLProceduresRoot, TMySQLProcedure, sProcedures);
  AddObjectsGroup(FFunctionsRoot, TMySQLFunctionsRoot, TMySQLFunction, sFunctions);
  AddObjectsGroup(FUsersRoot, TMySQLUsersRoot, TMySQLUser, sUsers);
end;

procedure TSQLEngineMySQL.DoneGroupsObjects;
begin
  FViewsRoot:=nil;
  FProceduresRoot:=nil;
  FTriggersRoot:=nil;
  FFunctionsRoot:=nil;
  FUsersRoot:=nil;
end;

function TSQLEngineMySQL.GetCharSet: string;
begin
  Result:='';
end;

procedure TSQLEngineMySQL.SetCharSet(const AValue: string);
begin
  //inherited SetCharSet(AValue);
end;

class function TSQLEngineMySQL.GetEngineName: string;
begin
  Result:='MySQL Server';
end;

procedure TSQLEngineMySQL.SetUIShowSysObjects(const AValue: TUIShowSysObjects);
begin
  inherited SetUIShowSysObjects(AValue);
end;

function TSQLEngineMySQL.GetSqlQuery(ASql: string): TZQuery;
begin
  Result:=TZQuery.Create(nil);
  Result.Connection:=FConnection;
  Result.SQL.Text:=ASql;
end;

procedure TSQLEngineMySQL.InitKeywords;
begin
  KeywordsList.Clear;
  FKeyFunctions:=CreateMyKeyFunctions;
  FKeywords:=CreateMyKeyWords;
  FKeyTypes:=CreateMyKeyTypes;

  KeywordsList.Add(FKeywords);
  KeywordsList.Add(FKeyFunctions);
  KeywordsList.Add(FKeyTypes);
end;

procedure TSQLEngineMySQL.ZSQLProcessorAfterExecute(Processor: TZSQLProcessor;
  StatementIndex: Integer);
begin
  if Assigned(FOnExecuteSqlScriptProcessEvent) then
    if not FOnExecuteSqlScriptProcessEvent(Processor.Statements[StatementIndex], StatementIndex, stNone) then
      abort;
end;


constructor TSQLEngineMySQL.Create;
begin
  inherited Create;
  RemotePort:=defMySQLPort;
  FSQLEngileFeatures:=[feDescribeObject];
  FSQLCommentOnClass:=TMySQLCommentOn;
  InternalIniTSQLEngineMySQL;
end;

destructor TSQLEngineMySQL.Destroy;
begin
  FreeAndNil(FConnection);
  inherited Destroy;
end;

procedure TSQLEngineMySQL.Load(const AData: TDataSet);
begin
  inherited Load(AData);
  FRoleName :=AData.FieldByName('db_database_user_role').AsString;
  FServerVersion:=MySQLStrToVersion(AData.FieldByName('db_database_server_version').AsString);
end;

procedure TSQLEngineMySQL.Store(const AData: TDataSet);
begin
  inherited Store(AData);
  AData.FieldByName('db_database_user_role').AsString:=FRoleName;
  AData.FieldByName('db_database_server_version').AsString:=MySQLVersionToStr(FServerVersion);
end;

procedure TSQLEngineMySQL.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;

procedure TSQLEngineMySQL.FillCharSetList(const List: TStrings);
var
  Q: TZQuery;
begin
  Q:=GetSqlQuery(MySqlModule.sqlCharSets.ExpandMacros);
  if Assigned(Q) then
  begin
    Q.Open;
    FieldValueToStrings(Q, 'CHARACTER_SET_NAME', List);
    Q.Close;
    Q.Free;
  end;
end;

procedure TSQLEngineMySQL.FillCollationList(const ACharSet: string;
  const List: TStrings);
var
  Q: TZQuery;
begin
  Q:=GetSqlQuery(MySqlModule.sqlCollations.ExpandMacros);
  if Assigned(Q) then
  begin
    Q.ParamByName('CHARACTER_SET_NAME').AsString:=ACharSet;
    Q.Open;
    FieldValueToStrings(Q, 'COLLATION_NAME', List);
    Q.Close;
    Q.Free;
  end;
end;

function TSQLEngineMySQL.OpenDataSet(Sql: string; AOwner: TComponent): TDataSet;
begin
  Result:=GetSqlQuery(SQL);
end;

function TSQLEngineMySQL.ExecSQL(const Sql: string;
  const ExecParams: TSqlExecParams): boolean;
begin
  try
    Result:=FConnection.ExecuteDirect(SQL);
  except
    on E:Exception do
    begin
      InternalError(E.Message);
      Result:=false;
    end;
  end;
end;

function TSQLEngineMySQL.SQLPlan(aDataSet: TDataSet): string;
begin
  Result:=inherited SQLPlan(aDataSet);
end;

function TSQLEngineMySQL.GetQueryControl: TSQLQueryControl;
begin
  Result:=TMySQLQueryControl.Create(Self);
end;

procedure TSQLEngineMySQL.ExecuteSQLScript(const ASQL: string;
  OnExecuteSqlScriptProcessEvent: TExecuteSqlScriptProcessEvent);
var
  SQLScript: TZSQLProcessor;
begin
  SQLScript:=TZSQLProcessor.Create(nil);
  FOnExecuteSqlScriptProcessEvent:=OnExecuteSqlScriptProcessEvent;
  try
    SQLScript.Script.Text:=ASQL;
    SQLScript.AfterExecute:=@ZSQLProcessorAfterExecute;
    SQLScript.Connection:=FConnection;
    SQLScript.Execute;
  except
    on E:Exception do
      InternalError(E.Message);
  end;
  FOnExecuteSqlScriptProcessEvent:=nil;
  SQLScript.Free;
end;

procedure TSQLEngineMySQL.RefreshObjectsBegin(const ASQLText: string);
var
  DBObj: TDBItems;
  FQuery: TZQuery;
  P: TDBItem;
begin
  DBObj:=FCashedItems.AddTypes(ASQLText);
  if DBObj.CountUse = 1 then
  begin
    FQuery:=GetSqlQuery(ASQLText);
    FQuery.Open;
    while not FQuery.Eof do
    begin
      P:=DBObj.Add(FQuery.FieldByName('name').AsString);
      if Assigned(FQuery.FindField('description')) then
        P.ObjDesc:=Trim(FQuery.FieldByName('description').AsString);
      if Assigned(FQuery.FindField('table_name')) then
        P.ObjRelName:=Trim(FQuery.FieldByName('table_name').AsString);

      if Assigned(FQuery.FindField('obj_type')) then
        P.ObjType:=FQuery.FieldByName('obj_type').AsString;
      FQuery.Next;
    end;
    FQuery.Close;
    FreeAndNil(FQuery);
  end;
end;

initialization
  RegisterSQLStatment(TSQLEngineMySQL, TSqlCommandSelect, 'SELECT');
  RegisterSQLStatment(TSQLEngineMySQL, TSQLCommandInsert, 'INSERT INTO');
  RegisterSQLStatment(TSQLEngineMySQL, TSQLCommandUpdate, 'UPDATE');
  RegisterSQLStatment(TSQLEngineMySQL, TSQLCommandDelete, 'DELETE FROM');
{
//14.2 Data Manipulation Statements
14.2.1 CALL Syntax
14.2.2 DELETE Syntax
14.2.3 DO Syntax
14.2.4 HANDLER Syntax
14.2.5 INSERT Syntax
14.2.6 LOAD DATA INFILE Syntax
14.2.7 LOAD XML Syntax
14.2.8 REPLACE Syntax
14.2.9 SELECT Syntax
14.2.10 Subquery Syntax
14.2.11 UPDATE Syntax
}
{
//14.3 Transactional and Locking Statements
14.3.1 START TRANSACTION, COMMIT, and ROLLBACK Syntax
14.3.2 Statements That Cannot Be Rolled Back
14.3.3 Statements That Cause an Implicit Commit
14.3.4 SAVEPOINT, ROLLBACK TO SAVEPOINT, and RELEASE SAVEPOINT Syntax
14.3.5 LOCK TABLES and UNLOCK TABLES Syntax
14.3.6 SET TRANSACTION Syntax
14.3.7 XA Transactions
}
{
//14.4 Replication Statements
14.4.1 SQL Statements for Controlling Master Servers
14.4.2 SQL Statements for Controlling Slave Servers
14.4.3 SQL Statements for Controlling Group Replication
}
{
//14.5 Prepared SQL Statement Syntax
14.5.1 PREPARE Syntax
14.5.2 EXECUTE Syntax
14.5.3 DEALLOCATE PREPARE Syntax
}
{
//14.1 Data Definition Statements
14.1.2 ALTER EVENT Syntax
14.1.4 ALTER INSTANCE Syntax
14.1.5 ALTER LOGFILE GROUP Syntax

14.1.12 CREATE EVENT Syntax
14.1.14 CREATE INDEX Syntax
14.1.15 CREATE LOGFILE GROUP Syntax

14.1.23 DROP EVENT Syntax
14.1.25 DROP INDEX Syntax
14.1.26 DROP LOGFILE GROUP Syntax

}
{
//
14.6 Compound-Statement Syntax

14.6.1 BEGIN ... END Compound-Statement Syntax
14.6.2 Statement Label Syntax
14.6.3 DECLARE Syntax
14.6.4 Variables in Stored Programs
14.6.5 Flow Control Statements
14.6.6 Cursors
14.6.7 Condition Handling
}
{
//14.7 Database Administration Statements
14.7.1 Account Management Statements
14.7.2 Table Maintenance Statements
14.7.3 Plugin and User-Defined Function Statements
14.7.5 SHOW Syntax
14.7.6 Other Administrative Statements
}
{
//14.8 Utility Statements
14.8.1 DESCRIBE Syntax
14.8.2 EXPLAIN Syntax
14.8.3 HELP Syntax
14.8.4 USE Syntax
}
  //DATABASE
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLCreateDatabase, 'CREATE DATABASE'); //14.1.11 CREATE DATABASE Syntax
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLAlterDatabase, 'ALTER DATABASE'); //14.1.1 ALTER DATABASE Syntax
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLDropDatabase, 'DROP DATABASE'); //14.1.22 DROP DATABASE Syntax

  //TABLE
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLCreateTable, 'CREATE TABLE');  //14.1.18 CREATE TABLE Syntax
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLAlterTable, 'ALTER TABLE');    //14.1.8 ALTER TABLE Syntax
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLDropTable, 'DROP TABLE');      //14.1.29 DROP TABLE Syntax
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLRenameTable, 'RENAME TABLE');  //14.1.33 RENAME TABLE Syntax
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLTruncateTable, 'TRUNCATE TABLE'); //14.1.34 TRUNCATE TABLE Syntax

  //VIEW
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLCreateView, 'CREATE VIEW');    //14.1.21 CREATE VIEW Syntax //14.1.10 ALTER VIEW Syntax
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLDropView, 'DROP VIEW');    //14.1.32 DROP VIEW Syntax

  //TRIGGER
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLCreateTrigger, 'CREATE TRIGGER'); //14.1.20 CREATE TRIGGER Syntax
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLDropTrigger, 'DROP TRIGGER');     //14.1.31 DROP TRIGGER Syntax

  //FUNCTION
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLCreateFunction, 'CREATE FUNCTION'); //14.1.13 CREATE FUNCTION Syntax 14.1.16 CREATE PROCEDURE and CREATE FUNCTION Syntax
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLAlterFunction, 'ALTER FUNCTION'); //14.1.3 ALTER FUNCTION Syntax //14.1.6 ALTER PROCEDURE Syntax
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLDropFunction, 'DROP FUNCTION'); //14.1.24 DROP FUNCTION Syntax //14.1.27 DROP PROCEDURE and DROP FUNCTION Syntax

  //TABLESPACE
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLCreateTablespace, 'CREATE TABLESPACE'); //14.1.19 CREATE TABLESPACE Syntax
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLAlterTablespace, 'ALTER TABLESPACE'); //14.1.9 ALTER TABLESPACE Syntax
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLDropTablespace, 'DROP TABLESPACE'); //14.1.30 DROP TABLESPACE Syntax

  //SERVER
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLCreateServer, 'CREATE SERVER'); //14.1.17 CREATE SERVER Syntax
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLAlterServer, 'ALTER SERVER'); //14.1.7 ALTER SERVER Syntax
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLDropServer, 'DROP SERVER'); //14.1.28 DROP SERVER Syntax

  //USERS
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLCreateUser, 'CREATE USER'); //
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLAlterUser, 'ALTER USER'); //
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLDropUser, 'CREATE USER'); //
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLSET, 'SET'); //14.7.4 SET Syntax
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLSHOW, 'SHOW'); //SHOW
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLFlush, 'FLUSH');
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLGrant, 'GRANT');
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLRevoke, 'REVOKE');
  RegisterSQLStatment(TSQLEngineMySQL, TMySQLRename, 'RENAME');

end.

