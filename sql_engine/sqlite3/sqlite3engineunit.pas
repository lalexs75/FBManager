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

unit SQLite3EngineUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineAbstractUnit, DB, ZConnection, ZDataset,
  SQLEngineCommonTypesUnit, fbmSqlParserUnit, sqlObjects, ZSqlUpdate,
  sqlite3_SqlParserUnit, ZSqlProcessor, contnrs, SQLEngineInternalToolsUnit;

type
  TSQLEngineSQLite3 = class;

  { TTablesRoot }

  TTablesRoot = class(TDBRootObject)
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TSystemTablesRoot }

  TSystemTablesRoot = class(TTablesRoot)
  protected
  public
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TViewsRoot }

  TViewsRoot = class(TDBRootObject)
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;


  { TTriggersRoot }

  TTriggersRoot = class(TDBRootObject)
  private
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TIndexRoot }

  TIndexRoot = class(TDBRootObject)
  private
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TSQLite3Table }

  TSQLite3Table = class(TDBTableObject)
  private
    ZUpdateSQL:TZUpdateSQL;
    FTriggerList:TObjectList;
    FInternalSQL:string;
    FCmdCreateTable:TSQLite3SQLCreateTable;
    procedure InternalCreateDLL(var SQLLines: TStringList; const ATableName: string);
    procedure SetIntSQL(ASql:string);
  protected
    procedure SetState(const AValue: TDBObjectState);override;
    function InternalGetDDLCreate: string; override;

    function GetTrigger(ACat:integer; AItem: integer): TDBTriggerObject; override;
    function GetTriggersCategories(AItem: integer): string; override;
    function GetTriggersCategoriesCount: integer; override;
    function GetTriggersCount(AItem: integer): integer; override;
    function GetIndexFields(const AIndexName:string; const AForce:boolean):string;override;
    function GetTriggersCategoriesType(AItem: integer): TTriggerTypes;override;
    function GetRecordCount: integer; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;

    procedure RefreshObject;override;

    procedure RefreshDependencies;override;
    procedure RefreshDependenciesField(Rec:TDependRecord);override;
    procedure MakeSQLStatementsList(AList:TStrings); override;
    function CreateSQLObject:TSQLCommandDDL; override;

    procedure RefreshFieldList; override;
    procedure SetFieldsOrder(AFieldsList:TStrings); override;

    function IndexNew:string; override;
    function IndexEdit(const IndexName:string):boolean; override;
    function IndexDelete(const IndexName:string):boolean; override;
    procedure IndexListRefresh; override;

    procedure RefreshConstraintPrimaryKey; override;
    procedure RefreshConstraintForeignKey; override;
    procedure RefreshConstraintUnique; override;
    procedure RefreshConstraintCheck; override;

    function DataSet(ARecCountLimit:Integer):TDataSet;override;

    procedure TriggersListRefresh; override;
    function TriggerDelete(const ATrigger:TDBTriggerObject):Boolean;override;
    function TriggerNew(TriggerTypes:TTriggerTypes):TDBTriggerObject;override;
    procedure RecompileTriggers;override;
    procedure AllTriggersSetActiveState(AState:boolean);override;
  end;

  { TSQLite3View }

  TSQLite3View = class(TDBViewObject)
  private
    FInternalSQL:string;
    FCmdCreateView:TSQLite3SQLCreateView;
    FTriggerList: TObjectList;
    procedure SetIntSQL(ASql:string);
  protected
    function InternalGetDDLCreate: string; override;
    function GetDDLAlter: string; override;

    function GetTrigger(ACat:integer; AItem: integer): TDBTriggerObject; override;
    function GetTriggersCategories(AItem: integer): string; override;
    function GetTriggersCategoriesCount: integer; override;
    function GetTriggersCount(AItem: integer): integer; override;
    function GetTriggersCategoriesType(AItem: integer): TTriggerTypes;override;

    function GetRecordCount: integer; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    procedure RefreshObject; override;
    class function DBClassTitle:string;override;
    function DataSet(ARecCountLimit:Integer):TDataSet;override;
    procedure RefreshFieldList; override;
    procedure RefreshDependencies;override;
    function CreateSQLObject:TSQLCommandDDL; override;

    procedure TriggersListRefresh; override;
    function TriggerNew(TriggerTypes:TTriggerTypes):TDBTriggerObject;override;
    function TriggerDelete(const ATrigger:TDBTriggerObject):Boolean;override;
    procedure RecompileTriggers;override;
    procedure AllTriggersSetActiveState(AState:boolean);override;
  end;

  { TSQLite3Triger }

  TSQLite3Triger = class(TDBTriggerObject)
  private
    FInternalSQL: String;
    FCmdCreateTrigger:TSQLite3SQLCreateTrigger;
    FTriggerWhen: string;
    FUpdateFields: TStrings;
    procedure SetIntSQL(ASql:string);
  protected
    function InternalGetDDLCreate: string; override;
    procedure SetActive(const AValue: boolean); override;

    function GetTriggerBody: string; override;
    function GetTableName: string; override;
    function GetTriggerType: TTriggerTypes;override;
    procedure SetTriggerType(AValue: TTriggerTypes);override;
    procedure SetTableName(AValue: string);override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure RefreshDependencies;override;

    function CreateSQLObject:TSQLCommandDDL;override;
    function CompileSQLObject(ASqlObject:TSQLCommandDDL; ASqlExecParam:TSqlExecParams = [sepShowCompForm]):boolean;override;

    procedure RefreshObject; override;
    property UpdateFields:TStrings read FUpdateFields;
    property TriggerWhen:string read FTriggerWhen;
  end;

  { TSQLite3Index }

  TSQLite3Index = class(TDBIndex)
  private
    FInternalSQL: String;
    FCmdCreateIndex: TSQLite3SQLCreateIndex;
    FIndexUnique: boolean;
    FTable: TSQLite3Table;
    FWhereExpression: String;
    procedure SetIntSQL(ASql:string);
    procedure SetTable(const AValue: TSQLite3Table);
    procedure RefreshIndexFields;
  protected
    function InternalGetDDLCreate: string; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure RefreshObject;override;
    function CreateSQLObject:TSQLCommandDDL;override;
    property Table:TSQLite3Table read FTable;
    property IndexUnique:boolean read FIndexUnique;
    property WhereExpression: String read FWhereExpression write FWhereExpression;
  end;

  { TSQLite3QueryControl }

  TSQLite3QueryControl = class(TSQLQueryControl)
    FSQLQuery: TZQuery;
    FParams:TParams;
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
    function IsEditable:boolean;override;
    procedure CommitTransaction;override;
    procedure RolbackTransaction;override;
    procedure FetchAll;override;
    procedure Prepare;override;
    procedure ExecSQL;override;
  end;

  { TSQLEngineSQLite3 }

  TSQLEngineSQLite3 = class(TSQLEngineAbstract)
  private
    FConnection: TZConnection;
    FClientLibVersion:string;
    procedure DoInitSqlEngine;
    procedure LoadDBParams;
    function QueryValue(ASQLText:string; ColNum:integer = 0):string;
  private
    FIndexRoot: TIndexRoot;
    FTriggersRoot: TTriggersRoot;
    FViewsRoot: TViewsRoot;
    FSystemTablesRoot:TSystemTablesRoot;
    FOnExecuteSqlScriptProcessEvent:TExecuteSqlScriptProcessEvent;
    procedure ZSQLProcessorAfterExecute(Processor: TZSQLProcessor; StatementIndex: Integer);
  protected
    function GetImageIndex: integer;override;

    //procedure SetConnected(const AValue: boolean);override;
    function InternalSetConnected(const AValue: boolean):boolean; override;
    procedure InitGroupsObjects;override;
    procedure DoneGroupsObjects;override;

    class function GetEngineName: string; override;
    procedure InitKeywords;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Load(const AData: TDataSet);override;
    procedure Store(const AData: TDataSet);override;

    procedure RefreshObjectsBegin(const ASQLText:string);override;
    procedure RefreshObjectsBeginFull;override;
    procedure RefreshObjectsEndFull;override;

    function ExecuteSQLScript(const ASQL: string; OnExecuteSqlScriptProcessEvent:TExecuteSqlScriptProcessEvent):Boolean; override;
    procedure SetSqlAssistentData(const List: TStrings); override;
    procedure FillCharSetList(const List: TStrings); override;
    function OpenDataSet(Sql:string; AOwner:TComponent):TDataSet;override;
    function ExecSQL(const Sql:string;const ExecParams:TSqlExecParams):boolean;override;
    function SQLPlan(aDataSet:TDataSet):string;override;
    function GetQueryControl:TSQLQueryControl;override;

    //Работа с типами полей и с доменами
    procedure FillDomainsList(const Items:TStrings; const ClearItems:boolean);override;
    property Connection: TZConnection read FConnection;
    property TablesRoot:TDBRootObject read FTablesRoot;
    property SystemTablesRoot:TSystemTablesRoot read FSystemTablesRoot;
    property TriggersRoot:TTriggersRoot read FTriggersRoot;
    property ViewsRoot:TViewsRoot read FViewsRoot;
    property IndexRoot:TIndexRoot read FIndexRoot;
  end;

implementation
uses fbmStrConstUnit, sqlite3_keywords, sqlite3_SQLTextUnit;

{ TSystemTablesRoot }

constructor TSystemTablesRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FSystemObject:=true;
end;

{ TSQLite3Index }

procedure TSQLite3Index.SetIntSQL(ASql: string);
var
  SQLParser: TSQLParser;
begin
  ASql:=Trim(ASql);
  if (ASql<>'') and (ASql[Length(ASql)] <> ';') then
    ASql:=ASql + ';';
  FInternalSQL:=ASql;
  IndexFields.Clear;

  if Assigned(FCmdCreateIndex) then
    FreeAndNil(FCmdCreateIndex);

  SQLParser:=TSQLParser.Create(FInternalSQL, OwnerDB);
  FCmdCreateIndex:=TSQLite3SQLCreateIndex.Create(nil);
  try
    FCmdCreateIndex.ParseSQL(SQLParser);
  finally
    SQLParser.Free;
  end;
  if FCmdCreateIndex.State = cmsError then
    raise Exception.Create(FCmdCreateIndex.ErrorMessage + '(' + FInternalSQL + ')');

  Description:=FCmdCreateIndex.Description;
  FIndexUnique:=FCmdCreateIndex.Unique;
  WhereExpression:=FCmdCreateIndex.WhereExpression;

  SetTable(OwnerDB.DBObjectByName(FCmdCreateIndex.TableName) as TSQLite3Table);
end;

procedure TSQLite3Index.SetTable(const AValue: TSQLite3Table);
begin
  FTable:=AValue;
  RefreshIndexFields;
end;

procedure TSQLite3Index.RefreshIndexFields;
var
  R: TSQLParserField;
  F: TDBField;
begin
  IndexFields.Clear;
  if not Assigned(FTable) then exit;

  if FTable.Fields.Count = 0 then
      FTable.RefreshFieldList;

  if Assigned(FCmdCreateIndex) then
    for R in FCmdCreateIndex.Fields do
    begin
      F:=FTable.Fields.FieldByName(R.Caption);
      if Assigned(F) then
        IndexFields.Add(F.FieldName);
    end;
end;

function TSQLite3Index.InternalGetDDLCreate: string;
begin
  Result:=FCmdCreateIndex.AsSQL;
end;

constructor TSQLite3Index.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
  begin
    SetIntSQL(ADBItem.ObjData)
  end;
end;

destructor TSQLite3Index.Destroy;
begin
  if Assigned(FCmdCreateIndex) then
    FreeAndNil(FCmdCreateIndex);
  inherited Destroy;
end;

class function TSQLite3Index.DBClassTitle: string;
begin
  Result:='Index';
end;

procedure TSQLite3Index.RefreshObject;
var
  IBQ: TDataSet;
begin
  if State <> sdboEdit then exit;
  inherited RefreshObject;

  IBQ:=OwnerDB.OpenDataSet(
    'select * from sqlite_master where sqlite_master.type = ''index'' and sqlite_master.name='''+CaptionFullPatch +'''', nil);
  try
    IBQ.Open;
    if IBQ.RecordCount > 0 then
      SetIntSQL(IBQ.FieldByName('sql').AsString);
    IBQ.Close;
  finally
    IBQ.Free;
  end;
end;

function TSQLite3Index.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=TSQLite3SQLCreateIndex.Create(nil);
  if State = sdboEdit then
    TSQLite3SQLCreateIndex(Result).CreateMode:=cmCreateOrAlter;
end;

{ TIndexRoot }

function TIndexRoot.DBMSObjectsList: string;
begin
  Result:=sqlite3Text.sqlTables.Strings.Text;
end;

function TIndexRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.ObjType = 'index');
end;

function TIndexRoot.GetObjectType: string;
begin
  Result:='Index';
end;

constructor TIndexRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDropCommandClass:=TSQLite3SQLDropIndex;
  FDBObjectKind:=okIndex;
end;

{ TSQLite3Triger }

procedure TSQLite3Triger.SetIntSQL(ASql: string);
var
  SQLParser: TSQLParser;
begin
  ASql:=Trim(ASql);
  if (ASql<>'') and (ASql[Length(ASql)] <> ';') then
    ASql:=ASql + ';';
  FInternalSQL:=ASql;

  if Assigned(FCmdCreateTrigger) then
    FreeAndNil(FCmdCreateTrigger);

  SQLParser:=TSQLParser.Create(FInternalSQL, OwnerDB);
  FCmdCreateTrigger:=TSQLite3SQLCreateTrigger.Create(nil);
  try
    FCmdCreateTrigger.ParseSQL(SQLParser);
  finally
    SQLParser.Free;
  end;
  if FCmdCreateTrigger.State = cmsError then
    raise Exception.Create(FCmdCreateTrigger.ErrorMessage + '(' + FInternalSQL + ')');

  FActive:=true;
  Description:=FCmdCreateTrigger.Description;
end;

function TSQLite3Triger.InternalGetDDLCreate: string;
begin
  if Assigned(FCmdCreateTrigger) then
    Result:=FCmdCreateTrigger.AsSQL
  else
    Result:='';
end;

procedure TSQLite3Triger.SetActive(const AValue: boolean);
begin

end;

function TSQLite3Triger.GetTriggerBody: string;
begin
  if Assigned(FCmdCreateTrigger) then
    Result:=FCmdCreateTrigger.TriggerBody
  else
    Result:=''
end;

function TSQLite3Triger.GetTableName: string;
begin
  if Assigned(FCmdCreateTrigger) then
    Result:=FCmdCreateTrigger.TableName
  else
    Result:=inherited GetTableName;
end;

function TSQLite3Triger.GetTriggerType: TTriggerTypes;
begin
  if Assigned(FCmdCreateTrigger) then
    Result:=FCmdCreateTrigger.TriggerType
  else
    Result:=inherited GetTriggerType;
end;

procedure TSQLite3Triger.SetTriggerType(AValue: TTriggerTypes);
begin
  if Assigned(FCmdCreateTrigger) then
    FCmdCreateTrigger.TriggerType:=AValue
  else
    inherited SetTriggerType(AValue);
end;

procedure TSQLite3Triger.SetTableName(AValue: string);
begin
  if Assigned(FCmdCreateTrigger) then
    FCmdCreateTrigger.TableName:=AValue
  else
    inherited SetTableName(AValue);
end;

constructor TSQLite3Triger.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
var
  TT1, TT: TTriggerTypes;
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
  begin
    SetIntSQL(ADBItem.ObjData);
    TT1:=TriggerType;
    TT:=TriggerType * [ttBefore, ttAfter, ttInsteadOf];
    if TT = [] then
      TriggerType:=TriggerType + [ttBefore];
  end;

  FUpdateFields:=TStringList.Create;
  FActive:=true;
end;

destructor TSQLite3Triger.Destroy;
begin
  FreeAndNil(FUpdateFields);
  if Assigned(FCmdCreateTrigger) then
    FreeAndNil(FCmdCreateTrigger);
  inherited Destroy;
end;

class function TSQLite3Triger.DBClassTitle: string;
begin
  Result:='Trigger';
end;

procedure TSQLite3Triger.RefreshDependencies;
begin
  inherited RefreshDependencies;
end;

function TSQLite3Triger.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=TSQLite3SQLCreateTrigger.Create(nil);
  if State <> sdboCreate then
    Result.Name:=Caption;
end;

function TSQLite3Triger.CompileSQLObject(ASqlObject: TSQLCommandDDL;
  ASqlExecParam: TSqlExecParams): boolean;
var
  S: string;
  ADBTable: TDBObject;
begin
  Result:=inherited CompileSQLObject(ASqlObject, [sepShowCompForm]);
  if Result then
  begin
    S:=(ASqlObject as TSQLite3SQLCreateTrigger).TableName;
    ADBTable:=OwnerDB.DBObjectByName(S);
    if Assigned(ADBTable) and (ADBTable is TDBDataSetObject) then
      ADBTable.RefreshEditor;
  end
end;

procedure TSQLite3Triger.RefreshObject;
var
  IBQ: TDataSet;
begin
  if State <> sdboEdit then exit;
  inherited RefreshObject;

  IBQ:=TSQLEngineSQLite3(OwnerDB).OpenDataSet(
    'select * from sqlite_master where sqlite_master.type = ''trigger'' and sqlite_master.name='''+CaptionFullPatch +'''', nil);
  try
    IBQ.Open;
    if IBQ.RecordCount > 0 then
      SetIntSQL(IBQ.FieldByName('sql').AsString);
    IBQ.Close;
  finally
    IBQ.Free;
  end;
end;

{ TTriggersRoot }

function TTriggersRoot.DBMSObjectsList: string;
begin
  Result:=sqlite3Text.sqlTables.Strings.Text;
end;

function TTriggersRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.ObjType = 'trigger');
end;

function TTriggersRoot.GetObjectType: string;
begin
  Result:='Trigger';
end;

constructor TTriggersRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDropCommandClass:=TSQLite3SQLDropTrigger;
  FDBObjectKind:=okTrigger;
end;

{ TSQLite3View }

procedure TSQLite3View.SetIntSQL(ASql: string);
var
  SQLParser: TSQLParser;
begin
  ASql:=Trim(ASql);
  if (ASql<>'') and (ASql[Length(ASql)] <> ';') then
    ASql:=ASql + ';';
  FInternalSQL:=ASql;

  if Assigned(FCmdCreateView) then
    FreeAndNil(FCmdCreateView);

  SQLParser:=TSQLParser.Create(FInternalSQL, OwnerDB);
  FCmdCreateView:=TSQLite3SQLCreateView.Create(nil);
  try
    FCmdCreateView.ParseSQL(SQLParser);
  finally
    SQLParser.Free;
  end;
  if FCmdCreateView.State = cmsError then
    raise Exception.Create(FCmdCreateView.ErrorMessage + '(' + FInternalSQL + ')');
  FSQLBody:=FCmdCreateView.SQLSelect;
  Description:=FCmdCreateView.Description;
end;

function TSQLite3View.InternalGetDDLCreate: string;
begin
  if Assigned(FCmdCreateView) then
    Result:=FCmdCreateView.AsSQL
  else
    Result:=''
end;

function TSQLite3View.GetDDLAlter: string;
var
  FCmd: TSQLite3SQLCreateView;
  F: TDBField;
begin
  FCmd:=TSQLite3SQLCreateView.Create(nil);
  FCmd.Name:=Caption;
  for F in Fields do
    FCmd.Fields.AddParam(F.FieldName);
  FCmd.SQLSelect:=SQLBody;
  Result:=FCmd.AsSQL;
  FCmd.Free;
end;

function TSQLite3View.GetTrigger(ACat: integer; AItem: integer
  ): TDBTriggerObject;
begin
  if (ACat>=0) and (ACat < FTriggerList.Count) then
    Result:=TSQLite3Triger(TList(FTriggerList[ACat]).Items[AItem])
  else
    Result:=nil;
end;

function TSQLite3View.GetTriggersCategories(AItem: integer): string;
begin
  case AItem of
    0:Result:='Insert';
    1:Result:='Update';
    2:Result:='InsteadOf';
  else
    Result:='';
  end;
end;

function TSQLite3View.GetTriggersCategoriesCount: integer;
begin
  Result:=FTriggerList.Count;
  if TList(FTriggerList[0]).Count = 0 then
    TriggersListRefresh;
end;

function TSQLite3View.GetTriggersCount(AItem: integer): integer;
begin
  if (AItem >=0) and (AItem<FTriggerList.Count) then
    Result:=TList(FTriggerList[AItem]).Count
  else
    Result:=0;
end;

function TSQLite3View.GetTriggersCategoriesType(AItem: integer): TTriggerTypes;
begin
  case AItem of
    0:Result:=[ttInsteadOf, ttInsert];
    1:Result:=[ttInsteadOf, ttUpdate];
    2:Result:=[ttInsteadOf, ttDelete];
  else
    Result:=[];
  end;
end;

function TSQLite3View.GetRecordCount: integer;
var
  Q: TDataSet;
begin
  Q:=TSQLEngineSQLite3(OwnerDB).OpenDataSet('select count(*) from ' +CaptionFullPatch, nil);
  try
    Q.Open;
    Result:=Q.Fields[0].AsInteger;
    Q.Close;
  finally
    Q.Free;
  end;
end;

constructor TSQLite3View.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);

  if Assigned(ADBItem) then
  begin
    SetIntSQL(ADBItem.ObjData)
  end;

  FDataSet:=TZQuery.Create(nil);
  TZQuery(FDataSet).Connection:=TSQLEngineSQLite3(OwnerDB).Connection;
  FDataSet.AfterOpen:=@DataSetAfterOpen;

  FTriggerList:=TObjectList.Create;
  FTriggerList.Add(TList.Create);  //instead of insert
  FTriggerList.Add(TList.Create);  //instead of update
  FTriggerList.Add(TList.Create);  //instead of delete
end;

destructor TSQLite3View.Destroy;
begin
  FTriggerList.Free;
  if Assigned(FCmdCreateView) then
    FreeAndNil(FCmdCreateView);
  inherited Destroy;
end;

procedure TSQLite3View.RefreshObject;
var
  IBQ: TDataSet;
begin
  if State <> sdboEdit then exit;
  inherited RefreshObject;

  IBQ:=TSQLEngineSQLite3(OwnerDB).OpenDataSet(
    'select * from sqlite_master where sqlite_master.type = ''view'' and sqlite_master.name='''+CaptionFullPatch +'''', nil);
  try
    IBQ.Open;
    if IBQ.RecordCount > 0 then
      SetIntSQL(IBQ.FieldByName('sql').AsString);
    IBQ.Close;
  finally
    IBQ.Free;
  end;
  RefreshFieldList;
end;

class function TSQLite3View.DBClassTitle: string;
begin
  Result:='View';
end;

function TSQLite3View.DataSet(ARecCountLimit: Integer): TDataSet;
begin
  if not FDataSet.Active then
    TZQuery(FDataSet).SQL.Text:='select * from '+CaptionFullPatch;
  Result:=FDataSet;
end;

procedure TSQLite3View.RefreshFieldList;
var
  IBQ: TDataSet;
  S, S1, S2: String;
  L, Sz, Pz: SizeInt;
  FS: TSQLParserField;
  F: TDBField;
begin
  if State <> sdboEdit then exit;
  Fields.Clear;

  IBQ:=OwnerDB.OpenDataSet('PRAGMA table_info(' + Caption+ ')', nil);
  try
    IBQ.Open;
    while not IBQ.Eof do
    begin
      SZ:=0;
      PZ:=0;
      F:=Fields.Add(IBQ.FieldByName('name').AsString);

      S:=IBQ.FieldByName('type').AsString;
      L:=Pos('(', S);
      if L>0 then
      begin
        S1:=Trim(Copy(S, L + 1, Length(S)));
        S:=Trim(Copy(S, 1, L - 1));
        L:=Pos(')', S1);
        if L > 0 then
          Delete(S1, L, Length(S1));

        L:=Pos(',', S1);
        if L > 0 then
        begin
          S2:=Trim(Copy(S1, L+1, Length(S1)));
          Pz:=StrToInt(S2);
          Delete(S1, L, Length(S1));
        end;
        Sz:=StrToInt(Trim(S1));
      end;
      F.FieldTypeName:=S;
      if SZ > 0 then
      begin
        F.FieldSize:=SZ;
        if PZ>0 then
          F.FieldPrec:=PZ;
      end;

      FS:=FCmdCreateView.Fields.FindParam(F.FieldName);
      if Assigned(FS) then
        F.FieldDescription:=FS.Description;
      IBQ.Next;
    end;
    IBQ.Close;
  finally
    IBQ.Free;
  end;
end;

procedure TSQLite3View.RefreshDependencies;
begin
  inherited RefreshDependencies;
end;


function TSQLite3View.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=TSQLite3SQLCreateView.Create(nil);
end;

procedure TSQLite3View.TriggersListRefresh;
var
  i:integer;
  Trig:TSQLite3Triger;
  P: Pointer;
begin
  for P in FTriggerList do
    TList(P).Clear;

  for i:=0 to TSQLEngineSQLite3(OwnerDB).TriggersRoot.CountObject - 1 do
  begin
    Trig:=TSQLite3Triger(TSQLEngineSQLite3(OwnerDB).TriggersRoot.Items[i]);
    if Trig.TableName = Caption then
    begin
      if ttInsteadOf in Trig.TriggerType then
      begin
        if ttInsert in Trig.TriggerType then
          TList(FTriggerList[0]).Add(Trig);
        if ttUpdate in Trig.TriggerType then
          TList(FTriggerList[1]).Add(Trig);
        if ttDelete in Trig.TriggerType then
          TList(FTriggerList[2]).Add(Trig);
      end;
    end;
  end;
end;

function TSQLite3View.TriggerNew(TriggerTypes: TTriggerTypes): TDBTriggerObject;
begin
  Result:=OwnerDB.NewObjectByKind(TSQLEngineSQLite3(OwnerDB).TriggersRoot, okTrigger) as TDBTriggerObject;
  if Assigned(Result) then
  begin
    Result.TableName:=Caption;
    Result.TriggerType:=TriggerTypes;
    Result.Active:=true;
    Result.RefreshEditor;
  end;
end;

function TSQLite3View.TriggerDelete(const ATrigger: TDBTriggerObject): Boolean;
begin
  Result:=inherited TriggerDelete(ATrigger);
end;

procedure TSQLite3View.RecompileTriggers;
begin
  inherited RecompileTriggers;
end;

procedure TSQLite3View.AllTriggersSetActiveState(AState: boolean);
begin
  inherited AllTriggersSetActiveState(AState);
end;

{ TViewsRoot }

function TViewsRoot.DBMSObjectsList: string;
begin
  Result:=sqlite3Text.sqlTables.Strings.Text;
end;

function TViewsRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.ObjType = 'view');
end;

function TViewsRoot.GetObjectType: string;
begin
  Result:='View';
end;

constructor TViewsRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDropCommandClass:=TSQLite3SQLDropView;
  FDBObjectKind:=okView;
end;

{ TSQLite3Table }

procedure TSQLite3Table.InternalCreateDLL(var SQLLines: TStringList;
  const ATableName: string);
begin

end;

procedure TSQLite3Table.SetIntSQL(ASql: string);
var
  SQLParser: TSQLParser;
begin
  ASql:=Trim(ASql);
  if (ASql<>'') and (ASql[Length(ASql)] <> ';') then
    ASql:=ASql + ';';
  FInternalSQL:=ASql;

  if Assigned(FCmdCreateTable) then
    FreeAndNil(FCmdCreateTable);

  SQLParser:=TSQLParser.Create(FInternalSQL, OwnerDB);
  FCmdCreateTable:=TSQLite3SQLCreateTable.Create(nil);
  try
    FCmdCreateTable.ParseSQL(SQLParser);
  finally
    SQLParser.Free;
  end;
  if FCmdCreateTable.State = cmsError then
    raise Exception.Create(FCmdCreateTable.ErrorMessage + '(' + FInternalSQL + ')');
end;

procedure TSQLite3Table.SetState(const AValue: TDBObjectState);
begin
  inherited SetState(AValue);
  case AValue of
    sdboCreate:UITableOptions:=[utRenameTable,
               utAddFields, utEditField, utDropFields,
               utAddFK, utEditFK, utDropFK,
              utAddUNQ, utEditUNQ, utDropUNQ];
    sdboEdit:UITableOptions:=[utRenameTable, utAddFields];
  end;
end;

function TSQLite3Table.InternalGetDDLCreate: string;
begin
  if Assigned(FCmdCreateTable) then
    Result:=FCmdCreateTable.AsSQL
  else
    Result:=''
end;

function TSQLite3Table.GetTrigger(ACat: integer; AItem: integer
  ): TDBTriggerObject;
begin
  if (ACat>=0) and (ACat < FTriggerList.Count) then
    Result:=TSQLite3Triger(TList(FTriggerList[ACat]).Items[AItem])
  else
    Result:=nil;
end;

function TSQLite3Table.GetTriggersCategories(AItem: integer): string;
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

function TSQLite3Table.GetTriggersCategoriesCount: integer;
begin
  Result:=FTriggerList.Count;
  if TList(FTriggerList[0]).Count = 0 then
    TriggersListRefresh;
end;

function TSQLite3Table.GetTriggersCount(AItem: integer): integer;
begin
  if (AItem >=0) and (AItem<FTriggerList.Count) then
    Result:=TList(FTriggerList[AItem]).Count
  else
    Result:=0;
end;

function TSQLite3Table.GetIndexFields(const AIndexName: string;
  const AForce: boolean): string;
begin
  Result:='';
end;

function TSQLite3Table.GetTriggersCategoriesType(AItem: integer): TTriggerTypes;
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

function TSQLite3Table.GetRecordCount: integer;
var
  Q: TDataSet;
begin
  Q:=TSQLEngineSQLite3(OwnerDB).OpenDataSet('select count(*) from ' +CaptionFullPatch, nil);
  try
    Q.Open;
    Result:=Q.Fields[0].AsInteger;
    Q.Close;
  finally
    Q.Free;
  end;
end;

constructor TSQLite3Table.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);

  UITableOptions:=[//utReorderFields, utRenameTable,
     utAddFields, //utEditField, utDropFields,
     utAddFK, utEditFK, utDropFK,
     utAddUNQ, utDropUNQ,
     //utAlterAddFieldInitialValue,
     utAlterAddFieldFK];

  if Assigned(ADBItem) then
  begin
    SetIntSQL(ADBItem.ObjData)
  end;

  FDataSet:=TZQuery.Create(nil);
  TZQuery(FDataSet).Connection:=TSQLEngineSQLite3(OwnerDB).Connection;
  FDataSet.AfterOpen:=@DataSetAfterOpen;

  ZUpdateSQL:=TZUpdateSQL.Create(nil);
  TZQuery(FDataSet).UpdateObject:=ZUpdateSQL;

  FTriggerList:=TObjectList.Create;
  FTriggerList.Add(TList.Create);  //before insert
  FTriggerList.Add(TList.Create);  //after insert
  FTriggerList.Add(TList.Create);  //before update
  FTriggerList.Add(TList.Create);  //after update
  FTriggerList.Add(TList.Create);  //before delete
  FTriggerList.Add(TList.Create);  //after delete
end;

destructor TSQLite3Table.Destroy;
begin
  FreeAndNil(ZUpdateSQL);
  FreeAndNil(FTriggerList);
  if Assigned(FCmdCreateTable) then
    FreeAndNil(FCmdCreateTable);
  inherited Destroy;
end;

class function TSQLite3Table.DBClassTitle: string;
begin
  Result:='Table';
end;

procedure TSQLite3Table.RefreshObject;
var
  IBQ: TDataSet;
begin
  if State <> sdboEdit then exit;
  inherited RefreshObject;
  IBQ:=TSQLEngineSQLite3(OwnerDB).OpenDataSet(
    'select * from sqlite_master where sqlite_master.type = ''table'' and sqlite_master.name='''+Caption +'''', nil);
  try
    IBQ.Open;
    if IBQ.RecordCount > 0 then
      SetIntSQL(IBQ.FieldByName('sql').AsString);
    IBQ.Close;
  finally
    IBQ.Free;
  end;
  RefreshFieldList;

  IndexListRefresh;
  RefreshConstraintPrimaryKey;
end;

procedure TSQLite3Table.RefreshDependencies;
begin
  inherited RefreshDependencies;
end;

procedure TSQLite3Table.RefreshDependenciesField(Rec: TDependRecord);
begin
  inherited RefreshDependenciesField(Rec);
end;

procedure TSQLite3Table.MakeSQLStatementsList(AList: TStrings);
begin
  inherited MakeSQLStatementsList(AList);
end;

function TSQLite3Table.CreateSQLObject: TSQLCommandDDL;
begin
  if State <> sdboCreate then
  begin
    Result:=TSQLite3SQLAlterTable.Create(nil);
    Result.Name:=Caption;
  end
  else
    Result:=TSQLite3SQLCreateTable.Create(nil);
end;

procedure TSQLite3Table.RefreshFieldList;
var
  F: TSQLParserField;
  Rec: TDBField;
begin
  if State <> sdboEdit then exit;
  Fields.Clear;

  if Assigned(FCmdCreateTable) then
  begin
    for F in FCmdCreateTable.Fields do
    begin
      Rec:=Fields.Add(F.Caption);
      Rec.LoadFromSQLFieldItem(F);
    end;

    RefreshConstraintPrimaryKey;
  end;
end;

procedure TSQLite3Table.SetFieldsOrder(AFieldsList: TStrings);
begin

end;

function TSQLite3Table.IndexNew: string;
var
  R: TDBObject;
begin
  Result:='';
  R:=OwnerDB.CreateObject(okIndex, TSQLEngineSQLite3(OwnerDB).IndexRoot);
  if Assigned(R) and (R is TSQLite3Index) then
  begin
    TSQLite3Index(R).SetTable(Self);
    R.RefreshEditor;
  end;
end;

function TSQLite3Table.IndexEdit(const IndexName: string): boolean;
var
  P:TSQLite3Index;
begin
  Result:=false;
  P:=TSQLite3Index(TSQLEngineSQLite3(OwnerDB).IndexRoot.ObjByName(IndexName));
  if Assigned(P) then
    P.Edit;
end;

function TSQLite3Table.IndexDelete(const IndexName: string): boolean;
var
  Ind:TSQLite3Index;
begin
  Ind:=TSQLite3Index(TSQLEngineSQLite3(OwnerDB).IndexRoot.ObjByName(IndexName));
  if Assigned(Ind) then
    Result:=TSQLEngineSQLite3(OwnerDB).IndexRoot.DropObject(Ind)
  else
    Result:=false;//inherited IndexDelete(IndexName);
end;

procedure TSQLite3Table.IndexListRefresh;
var
  QIndex: TDataSet;
  Rec: TIndexItem;
  Ind: TSQLite3Index;
  F: TIndexField;
begin
  IndexArrayClear;
  QIndex:=OwnerDB.OpenDataSet('pragma index_list('+CaptionFullPatch+')', nil);
  try
    while not QIndex.Eof do
    begin
      Rec:=FIndexItems.Add(Trim(QIndex.FieldByName('name').AsString));
      Rec.Unique:=QIndex.FieldByName('unique').AsInteger <> 0;
      Rec.Active:=true;

      Ind:=TSQLite3Index(TSQLEngineSQLite3(OwnerDB).IndexRoot.ObjByName(Rec.IndexName));
      if Assigned(Ind) then
      begin
        for F in Ind.IndexFields do
        begin
          if Rec.IndexField <> '' then Rec.IndexField:=Rec.IndexField + ', ';
          Rec.IndexField:=Rec.IndexField + F.FieldName;
        end;
      end;
      QIndex.Next;
    end;
  finally
    QIndex.Free;
  end;
  FIndexListLoaded:=true;
end;
{
function TSQLite3Table.PKNew(const Name, FieldsList, IndexName: string;
  const IndexSortOrder: TIndexSortOrder): boolean;
begin

end;

function TSQLite3Table.PKDrop(const PKName: string): boolean;
begin

end;
}
procedure TSQLite3Table.RefreshConstraintPrimaryKey;
var
  C: TSQLConstraintItem;
  CF: TSQLParserField;
  F: TDBField;
begin
  if not Assigned(FCmdCreateTable) then Exit;
  for C in FCmdCreateTable.SQLConstraints do
  begin
    if C.ConstraintType = ctPrimaryKey then
    begin
      for CF in C.ConstraintFields do
      begin
        F:=Fields.FieldByName(CF.Caption);
        if Assigned(F) then
          F.FieldPK:=true;
      end;
    end;
  end;

end;

procedure TSQLite3Table.RefreshConstraintForeignKey;
var
  C: TSQLConstraintItem;
  Rec: TForeignKeyRecord;
begin
  inherited RefreshConstraintForeignKey;

  if Assigned(FCmdCreateTable) then
  for C in FCmdCreateTable.SQLConstraints do
    if C.ConstraintType = ctForeignKey then
    begin
      Rec:=TForeignKeyRecord.Create;
      FConstraintList.Add(Rec);
      Rec.Name:=C.ConstraintName;
      Rec.FieldList:=C.ConstraintFields.AsString;
      Rec.OnUpdateRule:=C.ForeignKeyRuleOnUpdate;
      Rec.OnDeleteRule:=C.ForeignKeyRuleOnDelete;
      Rec.FKTableName:=C.ForeignTable;
      Rec.FKFieldName:=C.ForeignFields.AsString;
    end;
end;

procedure TSQLite3Table.RefreshConstraintUnique;
var
  Rec:TUniqueRecord;
  C: TSQLConstraintItem;
begin
  inherited RefreshConstraintUnique;

  if Assigned(FCmdCreateTable) then
    for C in FCmdCreateTable.SQLConstraints do
      if C.ConstraintType = ctUnique then
      begin
        Rec:=TUniqueRecord.Create;
        FConstraintList.Add(Rec);
        Rec.Name:=C.ConstraintName;
        Rec.FieldList:=C.ConstraintFields.AsString;
      end;
end;

procedure TSQLite3Table.RefreshConstraintCheck;
var
  Rec: TTableCheckConstraintRecord;
  C: TSQLConstraintItem;
begin
  inherited RefreshConstraintCheck;

  if Assigned(FCmdCreateTable) then
    for C in FCmdCreateTable.SQLConstraints do
      if C.ConstraintType = ctTableCheck then
      begin
        Rec:=TTableCheckConstraintRecord.Create;
        FConstraintList.Add(Rec);
        Rec.Name:=C.ConstraintName;
        Rec.SQLBody:=C.ConstraintExpression;
      end;
end;

function TSQLite3Table.DataSet(ARecCountLimit: Integer): TDataSet;

function MakeSQLWhere:string;
var
  F: TDBField;
begin
  Result:='';
  for F in Fields do
    if F.FieldPK then
    begin
      if Result<>'' then
        Result:=Result + ' and ';
      Result:=Result + '('+F.FieldName + ' = :old_' + F.FieldName+')';
    end;
  if Result <> '' then
    Result:= ' where '+Result;
end;

function MakeSQLEditFields:string;
var
  F: TDBField;
begin
  Result:='';
  for F in Fields do
    Result:=Result + F.FieldName +' = :'+F.FieldName + ',';
  if Result <> '' then
    Result:= Copy(Result, 1, Length(Result) - 1);
end;

function MakeSQLInsertFields(AParams:boolean):string;
var
  F: TDBField;
begin
  Result:='';
  for F in Fields do
    if AParams then
      Result:=Result + ' :' + F.FieldName + ','
    else
      Result:=Result + ' ' + F.FieldName + ',';
  if Result <> '' then
    Result:= Copy(Result, 1, Length(Result) - 1);
end;

begin
  if not FDataSet.Active then
  begin
    RefreshConstraintPrimaryKey;
    TZQuery(FDataSet).SQL.Text:='select * from '+DoFormatName(Caption) {+MakeOrderBy};
{
    if ARecCountLimit > -1 then
      FDataSet.SQL.Text:=FDataSet.SQL.Text+' limit '+IntToStr(ARecCountLimit);
}
    ZUpdateSQL.InsertSQL.Text:='insert into ' + CaptionFullPatch + '(' + MakeSQLInsertFields(false) + ') values('+MakeSQLInsertFields(true)+')';
    ZUpdateSQL.ModifySQL.Text:='update ' + CaptionFullPatch + ' set '+ MakeSQLEditFields + MakeSQLWhere;
    ZUpdateSQL.DeleteSQL.Text:='delete from ' + CaptionFullPatch + MakeSQLWhere;
    ZUpdateSQL.RefreshSQL.Text:='select * from '+CaptionFullPatch + MakeSQLWhere;
  end;
  Result:=FDataSet;
end;

procedure TSQLite3Table.TriggersListRefresh;
var
  i:integer;
  Trig:TSQLite3Triger;
  P: Pointer;
begin
  for P in FTriggerList do
    TList(P).Clear;

  for i:=0 to TSQLEngineSQLite3(OwnerDB).TriggersRoot.CountObject - 1 do
  begin
    Trig:=TSQLite3Triger(TSQLEngineSQLite3(OwnerDB).TriggersRoot.Items[i]);
    if Trig.TableName = Caption then
    begin
      if ttBefore in Trig.TriggerType then
      begin
        if ttInsert in Trig.TriggerType then
          TList(FTriggerList[0]).Add(Trig);
        if ttUpdate in Trig.TriggerType then
          TList(FTriggerList[2]).Add(Trig);
        if ttDelete in Trig.TriggerType then
          TList(FTriggerList[4]).Add(Trig);
      end;

      if ttAfter in Trig.TriggerType then
      begin
        if ttInsert in Trig.TriggerType then
          TList(FTriggerList[1]).Add(Trig);
        if ttUpdate in Trig.TriggerType then
          TList(FTriggerList[3]).Add(Trig);
        if ttDelete in Trig.TriggerType then
          TList(FTriggerList[5]).Add(Trig);
      end;
    end;
  end;
end;

function TSQLite3Table.TriggerDelete(const ATrigger: TDBTriggerObject): Boolean;
begin
  Result:=TSQLEngineSQLite3(OwnerDB).TriggersRoot.DropObject(ATrigger);
end;

function TSQLite3Table.TriggerNew(TriggerTypes: TTriggerTypes
  ): TDBTriggerObject;
begin
  Result:=OwnerDB.NewObjectByKind(TSQLEngineSQLite3(OwnerDB).TriggersRoot, okTrigger) as TDBTriggerObject;
  if Assigned(Result) then
  begin
    Result.TableName:=Caption;
    Result.TriggerType:=TriggerTypes;
    Result.Active:=true;
    Result.RefreshEditor;
  end;
end;

procedure TSQLite3Table.RecompileTriggers;
begin
  inherited RecompileTriggers;
end;

procedure TSQLite3Table.AllTriggersSetActiveState(AState: boolean);
begin
  inherited AllTriggersSetActiveState(AState);
end;


{ TTablesRoot }

function TTablesRoot.DBMSObjectsList: string;
begin
  Result:=sqlite3Text.sqlTables.Strings.Text;
end;

function TTablesRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.ObjType = 'table') and (AItem.ObjType2 = Ord(FSystemObject));
end;

function TTablesRoot.GetObjectType: string;
begin
  Result:='Table';
end;
constructor TTablesRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okTable;
  FDropCommandClass:=TSQLite3SQLDropTable;
end;

{ TSQLEngineSQLite3 }

procedure TSQLEngineSQLite3.DoInitSqlEngine;
begin
  InitKeywords;

  FConnection:=TZConnection.Create(nil);
  FConnection.Protocol:='sqlite-3';

  FUIParams:=[upSqlEditor, upLocal];
  FSQLEngineCapability:=[
                   okTable,
                   okView,
                   okTrigger,
                   okIndex,
                   okCheckConstraint,
                   okForeignKey,
                   okPrimaryKey,
                   okUniqueConstraint,
                   okAutoIncFields
                   ];

end;

procedure TSQLEngineSQLite3.LoadDBParams;
begin
  FClientLibVersion:=QueryValue('select sqlite_version()');
end;

function TSQLEngineSQLite3.QueryValue(ASQLText: string; ColNum: integer
  ): string;
var
  Q: TDataSet;
begin
  Result:='';
  Q:=OpenDataSet(ASQLText, nil);
  Q.Open;
  while not Q.EOF do
  begin
    if Result <> '' then
      Result:=Result + ', ';
    Result:=Result + Q.Fields[ColNum].AsString;
    Q.Next;
  end;
  Q.Close;
  Q.Free;
end;

procedure TSQLEngineSQLite3.ZSQLProcessorAfterExecute(
  Processor: TZSQLProcessor; StatementIndex: Integer);
begin
  if Assigned(FOnExecuteSqlScriptProcessEvent) then
    if not FOnExecuteSqlScriptProcessEvent(Processor.Statements[StatementIndex], StatementIndex, stNone) then
      abort;
end;

function TSQLEngineSQLite3.GetImageIndex: integer;
begin
  if Connected then
    Result:=64
  else
    Result:=65;
end;
(*
function TSQLEngineSQLite3.GetCountRootObject: integer;
begin
  Result:=4 + ord(ussSystemTable in UIShowSysObjects);
end;

function TSQLEngineSQLite3.GetRootObject(AIndex: integer): TDBRootObject;
begin
  case AIndex of
    0:Result:=FTablesRoot;
    1:Result:=FViewsRoot;
    2:Result:=FTriggersRoot;
    3:Result:=FIndexRoot;
    4:Result:=FSystemTablesRoot;
  else
    raise Exception.CreateFmt('Invalid index %d', [AIndex]);
  end;
end;
*)
function TSQLEngineSQLite3.InternalSetConnected(const AValue: boolean): boolean;
begin
  //inherited SetConnected(AValue);
  if AValue then
  begin
    Connection.Database:=DataBaseName;
    Connection.Connected:=true;

    LoadDBParams;
  end
  else
  begin
    try
      if Connection.InTransaction then
        Connection.Rollback;
    finally
      Connection.Connected:=false;
    end;
  end;
  Result:=Connection.Connected;
end;

procedure TSQLEngineSQLite3.InitGroupsObjects;
begin
  AddObjectsGroup(FTablesRoot, TTablesRoot, TSQLite3Table, sTables);
  AddObjectsGroup(FViewsRoot, TViewsRoot, TSQLite3View, sViews);
  AddObjectsGroup(FTriggersRoot, TTriggersRoot, TSQLite3Triger, sTriggers);
  AddObjectsGroup(FIndexRoot, TIndexRoot, TSQLite3Index, sIndexs);
  if UIShowSysObjects<>[] then
    AddObjectsGroup(FSystemTablesRoot, TSystemTablesRoot, TSQLite3Table, sSystemTables);
end;

procedure TSQLEngineSQLite3.DoneGroupsObjects;
begin
  FViewsRoot:=nil;
  FTriggersRoot:=nil;
  FIndexRoot:=nil;
  FSystemTablesRoot:=nil;
end;

class function TSQLEngineSQLite3.GetEngineName: string;
begin
  Result:='SQLite3 Engine';
end;

procedure TSQLEngineSQLite3.InitKeywords;
begin
  FillFieldTypes(FTypeList);
  KeywordsList.Clear;
  FKeywords:=CreateSQLite3KeyWords;
  FKeyFunctions:=CreateSQLiteKeyFunctions;
  KeywordsList.Add(FKeywords);
  KeywordsList.Add(FKeyFunctions);
end;

constructor TSQLEngineSQLite3.Create;
begin
  inherited Create;
  DoInitSqlEngine;
end;

destructor TSQLEngineSQLite3.Destroy;
begin
  FreeAndNil(FConnection);
  inherited Destroy;
end;

procedure TSQLEngineSQLite3.Load(const AData: TDataSet);
begin
  inherited Load(AData);
end;

procedure TSQLEngineSQLite3.Store(const AData: TDataSet);
begin
  inherited Store(AData);
end;

procedure TSQLEngineSQLite3.RefreshObjectsBegin(const ASQLText: string);
var
  DBObj: TDBItems;
  P: TDBItem;
  FQuery: TDataSet;
begin
  DBObj:=FCashedItems.AddTypes(ASQLText);
  if DBObj.CountUse = 1 then
  begin
    FQuery:=OpenDataSet(ASQLText, nil);
    FQuery.Open;
    while not FQuery.Eof do
    begin
      P:=DBObj.Add(FQuery.FieldByName('name').AsString);
      P.ObjType:=LowerCase(FQuery.FieldByName('type').AsString);
      P.ObjRelName:=FQuery.FieldByName('tbl_name').AsString;
      P.ObjData:=FQuery.FieldByName('sql').AsString;
      P.ObjType2:=FQuery.FieldByName('system_type').AsInteger;
      FQuery.Next;
    end;
    FQuery.Close;
    FreeAndNil(FQuery);
  end;
end;

procedure TSQLEngineSQLite3.RefreshObjectsBeginFull;
begin
  RefreshObjectsBegin(sqlite3Text.sqlTables.Strings.Text);
end;

procedure TSQLEngineSQLite3.RefreshObjectsEndFull;
begin
  RefreshObjectsEnd(sqlite3Text.sqlTables.Strings.Text);
end;

function TSQLEngineSQLite3.ExecuteSQLScript(const ASQL: string;
  OnExecuteSqlScriptProcessEvent: TExecuteSqlScriptProcessEvent): Boolean;
var
  SQLScript: TZSQLProcessor;
begin
  Result:=true;
  SQLScript:=TZSQLProcessor.Create(nil);
  FOnExecuteSqlScriptProcessEvent:=OnExecuteSqlScriptProcessEvent;
  try
    SQLScript.Script.Text:=ASQL;
    SQLScript.AfterExecute:=@ZSQLProcessorAfterExecute;
    SQLScript.Connection:=FConnection;
    SQLScript.Execute;
  except
    on E:Exception do
    begin
      InternalError(E.Message);
      Result:=false;
    end;
  end;
  FOnExecuteSqlScriptProcessEvent:=nil;
  SQLScript.Free;
end;

procedure TSQLEngineSQLite3.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);

  if Connection.Connected then
    List.Add(sServerVersion1 + ' : ' + FClientLibVersion);
end;

procedure TSQLEngineSQLite3.FillCharSetList(const List: TStrings);
begin
  inherited FillCharSetList(List);
end;

function TSQLEngineSQLite3.OpenDataSet(Sql: string; AOwner: TComponent
  ): TDataSet;
begin
  Result:=TZQuery.Create(AOwner);
  TZQuery(Result).Connection:=Connection;
  TZQuery(Result).SQL.Text:=Sql;
  Result.Active:=true;
end;

function TSQLEngineSQLite3.ExecSQL(const Sql: string;
  const ExecParams: TSqlExecParams): boolean;
begin
  try
    Result:=Connection.ExecuteDirect(SQL);
  except
    on E:Exception do
    begin
      InternalError(E.Message);
      Result:=false;
    end;
  end;
end;

function TSQLEngineSQLite3.SQLPlan(aDataSet: TDataSet): string;
begin
  Result:=''; //inherited SQLPlan(aDataSet);
end;

function TSQLEngineSQLite3.GetQueryControl: TSQLQueryControl;
begin
  Result:=TSQLite3QueryControl.Create(Self);
end;

procedure TSQLEngineSQLite3.FillDomainsList(const Items: TStrings;
  const ClearItems: boolean);
begin
  //inherited FillDomainsList(Items, ClearItems);
end;

{ TSQLite3QueryControl }

procedure TSQLite3QueryControl.SetParamValues;
begin

end;

function TSQLite3QueryControl.GetDataSet: TDataSet;
begin
  Result:=FSQLQuery;
end;

function TSQLite3QueryControl.GetQueryPlan: string;
begin
  Result:='';//inherited GetQueryPlan;
end;

function TSQLite3QueryControl.GetQuerySQL: string;
begin
  Result:=FSQLQuery.SQL.Text;
end;

procedure TSQLite3QueryControl.SetQuerySQL(const AValue: string);
begin
  FSQLQuery.Active:=false;
  FSQLQuery.SQL.Text:=AValue;
end;

function TSQLite3QueryControl.GetParam(AIndex: integer): TParam;
begin
  Result:=FSQLQuery.Params[AIndex];
end;

function TSQLite3QueryControl.GetParamCount: integer;
begin
  Result:=FSQLQuery.Params.Count;
end;

procedure TSQLite3QueryControl.SetActive(const AValue: boolean);
begin
  SetParamValues;
  if AValue then
    FSQLQuery.SortedFields:='';
  inherited SetActive(AValue);
end;

constructor TSQLite3QueryControl.Create(AOwner: TSQLEngineAbstract);
begin
  inherited Create(AOwner);
  FSQLQuery:=TZQuery.Create(nil);
  FSQLQuery.Connection:=TSQLEngineSQLite3(AOwner).Connection;
end;

destructor TSQLite3QueryControl.Destroy;
begin
  FreeAndNil(FSQLQuery);
  inherited Destroy;
end;

function TSQLite3QueryControl.IsEditable: boolean;
begin
  Result:=true;
end;

procedure TSQLite3QueryControl.CommitTransaction;
begin

end;

procedure TSQLite3QueryControl.RolbackTransaction;
begin

end;

procedure TSQLite3QueryControl.FetchAll;
begin
  FSQLQuery.FetchAll;
end;

procedure TSQLite3QueryControl.Prepare;
begin
  FSQLQuery.Prepare;
end;

procedure TSQLite3QueryControl.ExecSQL;
begin
  FSQLQuery.ExecSQL;
end;

initialization
  ///DML
  RegisterSQLStatment(TSQLEngineSQLite3, TSqlCommandSelect, 'SELECT');
  RegisterSQLStatment(TSQLEngineSQLite3, TSQLCommandInsert, 'INSERT INTO');
  RegisterSQLStatment(TSQLEngineSQLite3, TSQLCommandUpdate, 'UPDATE');
  RegisterSQLStatment(TSQLEngineSQLite3, TSQLCommandDelete, 'DELETE FROM');
  RegisterSQLStatment(TSQLEngineSQLite3, TSQLite3SQLPRAGMA, 'PRAGMA');

  //Tables
  RegisterSQLStatment(TSQLEngineSQLite3, TSQLite3SQLCreateTable, 'CREATE TABLE');
  RegisterSQLStatment(TSQLEngineSQLite3, TSQLite3SQLAlterTable, 'ALTER TABLE');
  RegisterSQLStatment(TSQLEngineSQLite3, TSQLite3SQLDropTable, 'DROP TABLE');

  //View
  RegisterSQLStatment(TSQLEngineSQLite3, TSQLite3SQLCreateView, 'CREATE VIEW');
  RegisterSQLStatment(TSQLEngineSQLite3, TSQLite3SQLDropView, 'DROP VIEW');

  //Trigger
  RegisterSQLStatment(TSQLEngineSQLite3, TSQLite3SQLCreateTrigger, 'CREATE TRIGGER');
  RegisterSQLStatment(TSQLEngineSQLite3, TSQLite3SQLDropTrigger, 'DROP TRIGGER');

  //Index
  RegisterSQLStatment(TSQLEngineSQLite3, TSQLite3SQLCreateIndex, 'CREATE INDEX');
  RegisterSQLStatment(TSQLEngineSQLite3, TSQLite3SQLDropIndex, 'DROP INDEX');
end.

