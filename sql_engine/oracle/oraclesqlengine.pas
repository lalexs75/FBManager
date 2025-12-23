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

unit OracleSQLEngine;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineAbstractUnit, DB, SQLEngineInternalToolsUnit,
  SQLEngineCommonTypesUnit, OracleConnection, sqldb, sqlObjects;

type
  TSQLEngineOracle = class;
//Group's objects
  { TOraUsersRoot }

  TOraUsersRoot = class(TDBRootObject)
  private
  public
    function GetObjectType: string;override;
    procedure RefreshGroup; override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject);
  end;

  { TOraTablesRoot }

  TOraTablesRoot = class(TDBRootObject)
  private
  public
    function GetObjectType: string;override;
    procedure RefreshGroup; override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject);
  end;

  { TOraViewsRoot }

  TOraViewsRoot = class(TDBRootObject)
  private
  public
    function GetObjectType: string;override;
    procedure RefreshGroup; override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject);
  end;

  { TOraSequencesRoot }

  TOraSequencesRoot = class(TDBRootObject)
  private
  public
    function GetObjectType: string;override;
    procedure RefreshGroup; override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject);
  end;

  { TOraTriggersRoot }

  TOraTriggersRoot = class(TDBRootObject)
  private
  public
    function GetObjectType: string;override;
    procedure RefreshGroup; override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject);
  end;

//DB objects

  { TOraField }

  TOraField = class(TDBField)
  protected
    procedure SetFieldDescription(const AValue: string);override;
  end;

  {  TOraTable  }
  TOraTable = class(TDBTableObject)
  private
    FShemaName:string;
  protected
    function GetCaption: string;override;
    function GetDBFieldClass: TDBFieldClass; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure RefreshObject; override;

    procedure RefreshFieldList; override;

    procedure Commit;override;
    procedure RollBack;override;
    function DataSet(ARecCountLimit:Integer):TDataSet;override;
  end;


  TOraView = class(TDBViewObject)
  private
    FShemaName:string;
  protected
    function GetCaption: string;override;
    function GetDBFieldClass: TDBFieldClass; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure RefreshFieldList; override;
    procedure RefreshObject;override;

    procedure Commit;override;
    procedure RollBack;override;
    function DataSet(ARecCountLimit:Integer):TDataSet;override;
  end;

  {  TOraSequence  }
  TOraSequence = class(TDBObject)
  private
    FShemaName:string;
  protected
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure RefreshObject;override;
  end;

  {  TOraTrigger  }

  TOraTrigger = class(TDBObject)
  private
    FShemaName:string;
  protected
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure RefreshObject; override;
  end;

  {  TOraUser  }
  TOraUser = class(TDBObject)
  protected
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure RefreshObject; override;
  end;

//
  { TOracleQueryControl }

  TOracleQueryControl = class(TSQLQueryControl)
  private
    FSQLQuery: TSQLQuery;
//    FSQLTransaction: TSQLTransaction;
  protected
    procedure SetReadOnly(AValue: Boolean); override;
    function GetReadOnly: Boolean; override;
    function GetDataSet: TDataSet;override;
    function GetQueryPlan: string;override;
    function GetQuerySQL: string;override;
    procedure SetQuerySQL(const AValue: string);override;
    function GetParam(AIndex: integer): TParam;override;
    function GetParamCount: integer;override;
  public
    constructor Create(AOwner:TSQLEngineAbstract);
    destructor Destroy; override;
    procedure StartTransaction;override;
    procedure CommitTransaction;override;
    procedure RolbackTransaction;override;
    procedure FetchAll;override;
    procedure Prepare;override;
    procedure ExecSQL;override;
  end;

  { TSQLEngineOracle }

  TSQLEngineOracle = class(TSQLEngineAbstract)
  private
    FAuthenticationType: TAuthenticationType;
    FOracleConnection: TOracleConnection;
    FSQLTransaction: TSQLTransaction;
    //
    FOraUsers:TOraUsersRoot;
    FOraTables:TOraTablesRoot;
    FOraSequences:TOraSequencesRoot;
    FOraTriggers:TOraTriggersRoot;
    FOraViews:TOraViewsRoot;

    procedure InternalInitOracleEngine;
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
    function GetSqlQuery(ASql:string):TSQLQuery;
    procedure InitKeywords;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Load(const AData: TDataSet);override;
    procedure Store(const AData: TDataSet);override;
    procedure SetSqlAssistentData(const List: TStrings); override;
    procedure FillCharSetList(const List: TStrings); override;
    function OpenDataSet(Sql:string; AOwner:TComponent):TDataSet;override;
    function ExecSQL(const Sql:string;const ExecParams:TSqlExecParams):boolean;override;
    function SQLPlan(aDataSet:TDataSet):string;override;
    function GetQueryControl:TSQLQueryControl;override;


    property AuthenticationType:TAuthenticationType read FAuthenticationType write FAuthenticationType;
{    property RoleName:string read FRoleName write FRoleName;
    property CharSet:string read FCharSet write FCharSet;
//    property ServerType:integer read FServerType write FServerType;
    property ServerVersion:TServerVersion read FServerVersion write FServerVersion;
    property Protocol:TUIBProtocol read FProtocol write FProtocol;
    property BackupOptions:TFireBirdBackupOptions read FBackupOptions;
    property RestoreOptions:TFireBirdRestoreOptions read FRestoreOptions;

    property FBDatabase:TUIBDataBase read FFBDatabase;
    property FBTransaction: TUIBTransaction read FFBTransaction;
    property DomainsRoot:TDomainsRoot read FDomainsRoot;
    property TablesRoot:TTablesRoot read FTablesRoot;
    property TrigersRoot:TTrigersRoot read FTrigersRoot;
    property GeneratorsRoot:TGeneratorsRoot read FGeneratorsRoot;
    property StoredProcRoot:TStoredProcRoot read FStoredProcRoot;
    property ExceptionRoot:TExceptionRoot read FExceptionRoot;
    property UDFRoot:TUDFRoot read FUDFRoot;
    property RoleRoot:TRoleRoot read FRoleRoot;
    property ViewsRoot:TViewsRoot read FViewsRoot;}
  end;

implementation
uses fbmStrConstUnit, oracle_Sql_Lines_Unit, oracle_keywords
  ;

{ TSQLEngineOracle }

procedure TSQLEngineOracle.InternalInitOracleEngine;
begin
  FOracleConnection:=TOracleConnection.Create(nil);
  FSQLTransaction:=TSQLTransaction.Create(nil);
  FSQLTransaction.DataBase:=FOracleConnection;
  FOracleConnection.Transaction:=FSQLTransaction;
  FUIParams:=[upSqlEditor, upUserName, upPassword, upRemote];
end;

function TSQLEngineOracle.GetImageIndex: integer;
begin
  if Connected then
    Result:=19
  else
    Result:=18;
end;
(*
function TSQLEngineOracle.GetCountRootObject: integer;
begin
  Result:=5;
end;

function TSQLEngineOracle.GetRootObject(AIndex: integer): TDBRootObject;
begin
  case AIndex of
    0:Result:=FOraTables;
    1:Result:=FOraSequences;
    2:Result:=FOraViews;
    3:Result:=FOraTriggers;
    4:Result:=FOraUsers;
  else
    Result:=nil;
  end;
end;

function TSQLEngineOracle.GetConnected: boolean;
begin
  Result:=FOracleConnection.Connected;
end;
*)

function TSQLEngineOracle.InternalSetConnected(const AValue: boolean): boolean;
begin
  //inherited SetConnected(AValue);
  if AValue then
  begin
    FOracleConnection.DatabaseName:=DataBaseName;
    FOracleConnection.UserName:=UserName;
    FOracleConnection.Password:=Password;

    FOracleConnection.Connected:=true;
    FSQLTransaction.StartTransaction;
  end
  else
  begin
    FSQLTransaction.Commit;
    FOracleConnection.Connected:=false;
  end;
  Result:=FOracleConnection.Connected;
end;

procedure TSQLEngineOracle.InitGroupsObjects;
begin
  AddObjectsGroup(FOraUsers, TOraUsersRoot, TOraUser, sUsers);
  AddObjectsGroup(FOraTables,TOraTablesRoot, TOraTable, sTables);
  AddObjectsGroup(FOraSequences, TOraSequencesRoot, TOraSequence, sSequences);
  AddObjectsGroup(FOraViews, TOraViewsRoot, TOraView, sViews);
  AddObjectsGroup(FOraTriggers, TOraTriggersRoot, TOraTrigger, sTriggers);
end;

procedure TSQLEngineOracle.DoneGroupsObjects;
begin
  FOraUsers:=nil;
  FOraTables:=nil;
  FOraSequences:=nil;
  FOraViews:=nil;
  FOraTriggers:=nil;
end;

function TSQLEngineOracle.GetCharSet: string;
begin
  Result:='';
end;

procedure TSQLEngineOracle.SetCharSet(const AValue: string);
begin
//  inherited SetCharSet(AValue);
end;

class function TSQLEngineOracle.GetEngineName: string;
begin
  Result:='Oracle SQL Server';
end;

procedure TSQLEngineOracle.SetUIShowSysObjects(const AValue: TUIShowSysObjects
  );
begin
  inherited SetUIShowSysObjects(AValue);
end;

function TSQLEngineOracle.GetSqlQuery(ASql: string): TSQLQuery;
begin
  Result:=TSQLQuery.Create(nil);
  Result.DataBase:=FOracleConnection;
  Result.Transaction:=FSQLTransaction;
  Result.SQL.Text:=ASql;
end;

procedure TSQLEngineOracle.InitKeywords;
begin
  KeywordsList.Clear;
//  FKeyFunctions:=CreateFBKeyWords;
  FKeywords:=CreateOraKeyWords;

  KeywordsList.Add(FKeywords);
//  KeywordsList.Add(FKeyFunctions);
end;

constructor TSQLEngineOracle.Create;
begin
  inherited Create;
  FSQLEngileFeatures:=[feDescribeObject];
  InitKeywords;
  InternalInitOracleEngine;
end;

destructor TSQLEngineOracle.Destroy;
begin
  FreeAndNil(FSQLTransaction);
  FreeAndNil(FOracleConnection);
  inherited Destroy;
end;

procedure TSQLEngineOracle.Load(const AData: TDataSet);
begin
  inherited Load(AData);
//  FAuthenticationType:=TAuthenticationType(IniFile.ReadInteger(IniSection, 'AuthenticationType', ord(FAuthenticationType)));
end;

procedure TSQLEngineOracle.Store(const AData: TDataSet);
begin
  inherited Store(AData);
//  IniFile.WriteInteger(IniSection, 'AuthenticationType', ord(FAuthenticationType));
end;

procedure TSQLEngineOracle.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;

procedure TSQLEngineOracle.FillCharSetList(const List: TStrings);
begin
//  inherited FillCharSetList(List);
end;

function TSQLEngineOracle.OpenDataSet(Sql: string; AOwner: TComponent
  ): TDataSet;
begin
  Result:=nil;
end;

function TSQLEngineOracle.ExecSQL(const Sql:string;const ExecParams:TSqlExecParams):boolean;
begin
  Result:=false;
end;

function TSQLEngineOracle.SQLPlan(aDataSet: TDataSet): string;
begin
  Result:='';
end;

function TSQLEngineOracle.GetQueryControl: TSQLQueryControl;
begin
  Result:=TOracleQueryControl.Create(Self);
end;



{ TOracleQueryControl }

procedure TOracleQueryControl.SetReadOnly(AValue: Boolean);
begin
  FSQLQuery.ReadOnly:=AValue;
end;

function TOracleQueryControl.GetReadOnly: Boolean;
begin
  Result:=FSQLQuery.ReadOnly;
end;

function TOracleQueryControl.GetDataSet: TDataSet;
begin
  Result:=FSQLQuery;
end;

function TOracleQueryControl.GetQueryPlan: string;
begin
  Result:='';//FSQLQuery.;
end;

function TOracleQueryControl.GetQuerySQL: string;
begin
  Result:=FSQLQuery.SQL.Text;
end;

procedure TOracleQueryControl.SetQuerySQL(const AValue: string);
begin
  FSQLQuery.Active:=false;
  FSQLQuery.SQL.Text:=AValue;
end;

function TOracleQueryControl.GetParam(AIndex: integer): TParam;
begin
  Result:=FSQLQuery.Params[AIndex];
end;

function TOracleQueryControl.GetParamCount: integer;
begin
  Result:=FSQLQuery.Params.Count;
end;

constructor TOracleQueryControl.Create(AOwner: TSQLEngineAbstract);
begin
  inherited Create(AOwner);
{  FSQLTransaction:=TSQLTransaction.Create(nil);
  FSQLTransaction.DataBase:=TSQLEngineOracle(Owner).FOracleConnection;}

  FSQLQuery:=TSQLQuery.Create(nil);
  FSQLQuery.DataBase:=TSQLEngineOracle(Owner).FOracleConnection;
  FSQLQuery.Transaction:=TSQLEngineOracle(Owner).FSQLTransaction;//FSQLTransaction;
end;

destructor TOracleQueryControl.Destroy;
begin
  FreeAndNil(FSQLQuery);
//  FreeAndNil(FSQLTransaction);
  inherited Destroy;
end;

procedure TOracleQueryControl.StartTransaction;
begin
  if not TSQLEngineOracle(Owner).FSQLTransaction.Active then
    TSQLEngineOracle(Owner).FSQLTransaction.StartTransaction;
end;

procedure TOracleQueryControl.CommitTransaction;
begin
  TSQLEngineOracle(Owner).FSQLTransaction.Commit;
end;

procedure TOracleQueryControl.RolbackTransaction;
begin
  TSQLEngineOracle(Owner).FSQLTransaction.Rollback;
end;

procedure TOracleQueryControl.FetchAll;
begin
{  if FSQLQuery.Active then
    FSQLQuery.fe;
  inherited FetchAll;}
end;

procedure TOracleQueryControl.Prepare;
begin
  FSQLQuery.Prepare;
end;

procedure TOracleQueryControl.ExecSQL;
begin
  FSQLQuery.ExecSQL;
end;

{ TOraUserRoot }

function TOraUsersRoot.GetObjectType: string;
begin
  Result:='Users';
end;

procedure TOraUsersRoot.RefreshGroup;
var
  Q:TSQLQuery;
  U:TOraUser;
begin
{  FObjects.Clear;
  Q:=TSQLEngineOracle(OwnerDB).GetSqlQuery(sql_ora_UserList);
  try
    Q.Open;
    while not Q.Eof do
    begin
      U:=TOraUser.Create(Q.FieldByName('USERNAME').AsString, Self);
      Q.Next;
    end;
  finally
    Q.Free;
  end;}
end;

constructor TOraUsersRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okUser;
end;

{ TOraUser }

constructor TOraUser.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
end;

destructor TOraUser.Destroy;
begin
  inherited Destroy;
end;

class function TOraUser.DBClassTitle: string;
begin
  Result:=sUser;
end;

procedure TOraUser.RefreshObject;
begin
//  inherited Refresh;
end;


{ TOraTablesRoot }

function TOraTablesRoot.GetObjectType: string;
begin
  Result:='Table';
end;

procedure TOraTablesRoot.RefreshGroup;
var
  Q:TSQLQuery;
  U:TOraTable;
begin
{  FObjects.Clear;
  Q:=TSQLEngineOracle(OwnerDB).GetSqlQuery(sql_ora_TablesList);
  try
    Q.Open;
    while not Q.Eof do
    begin
      U:=TOraTable.Create(Q.FieldByName('TABLE_NAME').AsString, Self);
      U.FShemaName:=Q.FieldByName('OWNER').AsString;
      Q.Next;
    end;
  finally
    Q.Free;
  end;}
end;

constructor TOraTablesRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okTable;
end;

{ TOraTable }

function TOraTable.GetCaption: string;
begin
  Result:=FShemaName + '.' + inherited GetCaption;
end;

function TOraTable.GetDBFieldClass: TDBFieldClass;
begin
  Result:=TOraField;
end;

procedure TOraTable.RefreshFieldList;
var
  Q:TSQLQuery;
  F:TOraField;
begin
  if State <> sdboEdit then exit;
  Fields.Clear;

  Q:=TSQLEngineOracle(OwnerDB).GetSqlQuery(sql_ora_RelationFields);
  try
    Q.Params.ParamByName('OWNER').AsString:=FShemaName;
    Q.Params.ParamByName('TABLE_NAME').AsString:=Caption;
    Q.Open;
    while not Q.Eof do
    begin
      F:=Fields.Add(Q.FieldByName('COLUMN_NAME').AsString) as TOraField;
      F.FieldSize:=Q.FieldByName('DATA_LENGTH').AsInteger;
      F.FieldPrec:=Q.FieldByName('DATA_PRECISION').AsInteger;
//      F.FieldTypeName:=Q.FieldByName('DATA_PRECISION').AsInteger;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

constructor TOraTable.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  FDataSet:=TSQLQuery.Create(nil);
  TSQLQuery(FDataSet).DataBase:=TSQLEngineOracle(OwnerDB).FOracleConnection;
  TSQLQuery(FDataSet).Transaction:=TSQLEngineOracle(OwnerDB).FSQLTransaction;//FSQLTransaction;
end;

destructor TOraTable.Destroy;
begin
  inherited Destroy;
end;

class function TOraTable.DBClassTitle: string;
begin
  Result:=sTable;
end;

procedure TOraTable.RefreshObject;
begin
//  inherited Refresh;
end;

procedure TOraTable.Commit;
begin
//  inherited Commit;
end;

procedure TOraTable.RollBack;
begin
//  inherited RollBack;
end;

function TOraTable.DataSet(ARecCountLimit: Integer): TDataSet;
begin
  if not TSQLQuery(FDataSet).Active then
  begin
    TSQLQuery(FDataSet).SQL.Text:='select * from '+Caption;
{    FBDataSet.SQLSelect.Text:=MakeSQLSelect(Caption, FBDataSet.DataBase);
    FBDataSet.SQLEdit.Text:=MakeSQLEdit(Caption, FBDataSet.DataBase);
    FBDataSet.SQLInsert.Text:=MakeSQLInsert(Caption, FBDataSet.DataBase);
    FBDataSet.SQLDelete.Text:=MakeSQLDelete(Caption, FBDataSet.DataBase);
    FBDataSet.SQLRefresh.Text:=MakeSQLRefresh(Caption, FBDataSet.DataBase);}
  end;
  //FDataSet.Active:=true;
  Result:=FDataSet;
end;

{ TOraSequencesRoot }

function TOraSequencesRoot.GetObjectType: string;
begin
  Result:='Sequence';
end;

procedure TOraSequencesRoot.RefreshGroup;
var
  Q:TSQLQuery;
  U:TOraSequence;
begin
{  FObjects.Clear;
  Q:=TSQLEngineOracle(OwnerDB).GetSqlQuery(sql_ora_SequencesList);
  try
    Q.Open;
    while not Q.Eof do
    begin
      U:=TOraSequence.Create(Q.FieldByName('SEQUENCE_NAME').AsString, Self);
      U.FShemaName:=Q.FieldByName('SEQUENCE_OWNER').AsString;
      Q.Next;
    end;
  finally
    Q.Free;
  end;}
end;

constructor TOraSequencesRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okSequence;
end;

{ TOraSequence }

constructor TOraSequence.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
end;

destructor TOraSequence.Destroy;
begin
  inherited Destroy;
end;

class function TOraSequence.DBClassTitle: string;
begin
  Result:=sSequences;
end;

procedure TOraSequence.RefreshObject;
begin
//  inherited Refresh;
end;

{ TOraViewsRoot }

function TOraViewsRoot.GetObjectType: string;
begin
  Result:='View';
end;

procedure TOraViewsRoot.RefreshGroup;
var
  Q:TSQLQuery;
  U:TOraView;
begin
{  FObjects.Clear;
  Q:=TSQLEngineOracle(OwnerDB).GetSqlQuery(sql_ora_ViewsList);
  try
    Q.Open;
    while not Q.Eof do
    begin
      U:=TOraView.Create(Q.FieldByName('VIEW_NAME').AsString, Self);
      U.FShemaName:=Q.FieldByName('OWNER').AsString;
      Q.Next;
    end;
  finally
    Q.Free;
  end;}
end;

constructor TOraViewsRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okView;
end;

{ TOraView }

function TOraView.GetCaption: string;
begin
  Result:=FShemaName + '.' + inherited GetCaption;
end;

function TOraView.GetDBFieldClass: TDBFieldClass;
begin
  Result:=TOraField;
end;

procedure TOraView.RefreshFieldList;
var
  Q:TSQLQuery;
  F:TOraField;
begin
  if State <> sdboEdit then exit;
  Fields.Clear;

  Q:=TSQLEngineOracle(OwnerDB).GetSqlQuery(sql_ora_RelationFields);
  try
    Q.Params.ParamByName('OWNER').AsString:=FShemaName;
    Q.Params.ParamByName('TABLE_NAME').AsString:=Caption;
    Q.Open;
    while not Q.Eof do
    begin
      F:=Fields.Add(Q.FieldByName('COLUMN_NAME').AsString) as TOraField;
      F.FieldName:=Q.FieldByName('COLUMN_NAME').AsString;
      F.FieldSize:=Q.FieldByName('DATA_LENGTH').AsInteger;
      F.FieldPrec:=Q.FieldByName('DATA_PRECISION').AsInteger;
//      F.FieldTypeName:=Q.FieldByName('DATA_PRECISION').AsInteger;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

constructor TOraView.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  FDataSet:=TSQLQuery.Create(nil);
  TSQLQuery(FDataSet).DataBase:=TSQLEngineOracle(OwnerDB).FOracleConnection;
  TSQLQuery(FDataSet).Transaction:=TSQLEngineOracle(OwnerDB).FSQLTransaction;//FSQLTransaction;
end;

destructor TOraView.Destroy;
begin
  inherited Destroy;
end;

class function TOraView.DBClassTitle: string;
begin
  Result:=sView;
end;

procedure TOraView.RefreshObject;
begin
//  inherited Refresh;
end;


procedure TOraView.Commit;
begin
//  inherited Commit;
end;

procedure TOraView.RollBack;
begin
//  inherited RollBack;
end;

function TOraView.DataSet(ARecCountLimit: Integer): TDataSet;
begin
  if not FDataSet.Active then
  begin
    TSQLQuery(FDataSet).SQL.Text:='select * from '+Caption;
{    FBDataSet.SQLSelect.Text:=MakeSQLSelect(Caption, FBDataSet.DataBase);
    FBDataSet.SQLEdit.Text:=MakeSQLEdit(Caption, FBDataSet.DataBase);
    FBDataSet.SQLInsert.Text:=MakeSQLInsert(Caption, FBDataSet.DataBase);
    FBDataSet.SQLDelete.Text:=MakeSQLDelete(Caption, FBDataSet.DataBase);
    FBDataSet.SQLRefresh.Text:=MakeSQLRefresh(Caption, FBDataSet.DataBase);}
  end;
  Result:=FDataSet;
end;

{ TOraTriggersRoot }

function TOraTriggersRoot.GetObjectType: string;
begin
  Result:='Trigger';
end;

procedure TOraTriggersRoot.RefreshGroup;
var
  Q:TSQLQuery;
  U:TOraTrigger;
begin
{  FObjects.Clear;
  Q:=TSQLEngineOracle(OwnerDB).GetSqlQuery(sql_ora_TriggersList);
  try
    Q.Open;
    while not Q.Eof do
    begin
      U:=TOraTrigger.Create(Q.FieldByName('TRIGGER_NAME').AsString, Self);
      U.FShemaName:=Q.FieldByName('TABLE_NAME').AsString;
      Q.Next;
    end;
  finally
    Q.Free;
  end;}
end;

constructor TOraTriggersRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okTrigger;
end;

{ TOraTrigger }
constructor TOraTrigger.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject
  );
begin
  inherited Create(ADBItem, AOwnerRoot);
end;

destructor TOraTrigger.Destroy;
begin
  inherited Destroy;
end;

class function TOraTrigger.DBClassTitle: string;
begin
  Result:=sTrigger;
end;

procedure TOraTrigger.RefreshObject;
begin
//  inherited Refresh;
end;

{ TOraField }

procedure TOraField.SetFieldDescription(const AValue: string);
begin
  //inherited SetFieldDescription(AValue);
end;

initialization
end.

