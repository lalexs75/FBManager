{ Free DB Manager

  Copyright (C) 2005-2021 Lagunov Aleksey  alexs75 at yandex.ru

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
unit mssql_engine;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineAbstractUnit, DB, SQLEngineInternalToolsUnit,
  sqlObjects, ZDataset, ZConnection, fbmSqlParserUnit,
  mssql_ObjectsList, SQLEngineCommonTypesUnit;

type
  TMSSQLEngine = class;
  TMSSQLSSchema = class;

  { TMSSQLSSchemasRoot }

  TMSSQLSSchemasRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TMSSQLRootObject }

  TMSSQLRootObject = class(TDBRootObject)
  private
    function GetSchemaId: integer;
  protected
    FSchema:TMSSQLSSchema;
  public
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    property SchemaId:integer read GetSchemaId;
  end;

  { TMSSQLTablesRoot }

  TMSSQLTablesRoot = class(TMSSQLRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TMSSQLViewsRoot }

  TMSSQLViewsRoot = class(TMSSQLRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TMSSQLStoredProcRoot }

  TMSSQLStoredProcRoot = class(TDBRootObject)
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TMSSQLTriggerRoot }

  TMSSQLTriggerRoot = class(TMSSQLRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TMSSQLSequenceRoot }

  TMSSQLSequenceRoot = class(TMSSQLRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TMSSQLFunctionRoot }

  TMSSQLFunctionRoot = class(TMSSQLRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TMSSQLSSchema }

  TMSSQLSSchema = class(TDBRootObject)
  private
    FSchemaId: integer;
    FTablesRoot:TMSSQLTablesRoot;
    FStorepProc:TMSSQLStoredProcRoot;
    FViews:TMSSQLViewsRoot;
    FTriggers:TMSSQLTriggerRoot;
    FSequences:TMSSQLSequenceRoot;
    FFunctions:TMSSQLFunctionRoot;
    procedure SetSchemaId(const AValue: integer);
  protected
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject); override;
    destructor Destroy; override;

    function CreateSQLObject:TSQLCommandDDL;override;
    function GetObjectType: string;override;
    procedure RefreshGroup; override;
    procedure RefreshObject; override;
    property SchemaId:integer read FSchemaId write SetSchemaId;
  end;

  { TMSSQLField }

  TMSSQLField = class(TDBField)
  private
    procedure LoadfromDB(DS:TDataSet);
  protected
    procedure SetFieldDescription(const AValue: string);override;
  public
    function DDLTypeStr:string; override;
  end;

  {  TMSSQLTable  }
  TMSSQLTable = class(TDBTableObject)
  private
    FSchema:TMSSQLSSchema;
    FOID: Integer;
    procedure InternalCreateDLL(var SQLLines: TStringList; const ATableName: string);
  protected
    function GetDBFieldClass: TDBFieldClass; override;
    procedure InternalRefreshStatistic; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    function InternalGetDDLCreate: string;override;
    class function DBClassTitle:string;override;
    function CreateSQLObject:TSQLCommandDDL; override;
    procedure OnCloseEditorWindow; override; {???}
    function RenameObject(ANewName:string):Boolean;override;
    procedure RefreshObject; override;
    procedure RefreshFieldList; override;
    procedure IndexListRefresh; override;

    procedure Commit;override;
    procedure RollBack;override;
    function DataSet(ARecCountLimit:Integer):TDataSet;override;
    property Schema:TMSSQLSSchema read FSchema;
    property OID: Integer read FOID;
  end;

  {  TMSSQLView  }
  TMSSQLView = class(TDBViewObject)
  private
    FSchema:TMSSQLSSchema;
    FOID: Integer;
  protected
    function GetDDLAlter : string; override;
    function GetDBFieldClass: TDBFieldClass; override;
    procedure InternalRefreshStatistic; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure RefreshObject; override;
    procedure RefreshFieldList; override;

    function CreateSQLObject:TSQLCommandDDL; override;
    function CompileSQLObject(ASqlObject:TSQLCommandDDL; ASqlExecParam:TSqlExecParams = [sepShowCompForm]):boolean;override;

    procedure Commit;override;
    procedure RollBack;override;
    function DataSet(ARecCountLimit:Integer):TDataSet;override;
  end;

  {  TMSSQLStoredProcedure  }

  TMSSQLStoredProcedure = class(TDBTableObject)
  private
    FSchema:TMSSQLSSchema;
  protected
//    procedure InternalSetDescription;override;
    procedure SetState(const AValue: TDBObjectState); override;
//    procedure FieldListRefresh; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure RefreshObject; override;

    procedure Commit;override;
    procedure RollBack;override;
    function DataSet(ARecCountLimit:Integer):TDataSet;override;
  end;

  { TMSSQLTriger }

  TMSSQLTriger = class(TDBTriggerObject)
  private
    FSchema:TMSSQLSSchema;
  protected
//    procedure InternalSetDescription;override;
    procedure SetState(const AValue: TDBObjectState); override;
    procedure SetActive(const AValue: boolean); override;
    function GetTriggerBody: string;override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure RefreshObject; override;
  end;

  TMSSQLSequence = class(TDBObject)
  protected
    FSchema: TMSSQLSSchema;
  protected
    function GetCaptionFullPatch:string; override;
    function GetEnableRename: boolean; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    class function DBClassTitle:string;override;
    procedure SetSqlAssistentData(const List: TStrings);override;
    function InternalGetDDLCreate: string; override;

    function CreateSQLObject:TSQLCommandDDL; override;

    procedure RefreshObject;override;
    procedure RefreshDependencies; override;
    procedure RefreshDependenciesField(Rec:TDependRecord); override;
    function RenameObject(ANewName:string):Boolean;override;
  end;


  TMSSQLFunction = class(TDBStoredProcObject)
  protected
//    procedure InternalInitACLList; virtual;
    procedure InternalSetDescription(ACommentOn: TSQLCommentOn);override;
//    function GetCaptionFullPatch:string; override;
//    function GetEnableRename: boolean; override;
//    procedure InternalRefreshStatistic; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
//    function InternalGetDDLCreate: string; override;
//    function RenameObject(ANewName:string):Boolean; override;
//    function MakeChildList:TStrings; override;
    class function DBClassTitle:string;override;
//    procedure SetSqlAssistentData(const List: TStrings);override;
//    function CompileProc(PrcName, PrcParams, aSql:string; ADropBeforCompile:boolean):boolean;
    procedure RefreshObject; override;
//    procedure RefreshDependencies; override;
//    procedure RefreshDependenciesField(Rec:TDependRecord); override;
//    procedure FillFieldList(List:TStrings; ACharCase:TCharCaseOptions; AFullNames:Boolean);override;
//    procedure MakeSQLStatementsList(AList:TStrings); override;

//    function CompileSQLObject(ASqlObject:TSQLCommandDDL; ASqlExecParam:TSqlExecParams):boolean;override;
//    function CreateSQLObject:TSQLCommandDDL; override;
  end;
  { TMSSQLQueryControl }

  TMSSQLQueryControl = class(TSQLQueryControl)
  private
    FSQLQuery:TZQuery;
  protected
    function GetDataSet: TDataSet;override;
    function GetQueryPlan: string;override;
    function GetQuerySQL: string;override;
    procedure SetQuerySQL(const AValue: string);override;
    function GetParam(AIndex: integer): TParam;override;
    function GetParamCount: integer;override;
    procedure SetActive(const AValue: boolean);override;
  public
    constructor Create(AOwner:TSQLEngineAbstract);
    destructor Destroy; override;
    function LoadStatistic(out StatRec:TQueryStatRecord; const SQLCommand:TSQLCommandAbstract):boolean; override;
    procedure CommitTransaction;override;
    procedure RolbackTransaction;override;
    procedure FetchAll;override;
    procedure Prepare;override;
    procedure ExecSQL;override;
  end;

  { TMSSQLEngine }

  TMSSQLEngine = class(TSQLEngineAbstract)
  private
{    FAuthenticationType: TAuthenticationType; }
    FMSSQLConnection: TZConnection;
//    FServerVersion: TCTServerVersion;
    //
    FStorepProc:TMSSQLStoredProcRoot;
    FViews:TMSSQLViewsRoot;
    FSchemasRoot:TMSSQLSSchemasRoot;

    procedure InternalInitMSSQLEngine;
  private
    //
  protected
    function GetImageIndex: integer;override;
    function InternalSetConnected(const AValue: boolean):boolean; override;
    procedure InitGroupsObjects;override;
    procedure DoneGroupsObjects;override;

    procedure SetUIShowSysObjects(const AValue: TUIShowSysObjects);override;
    function GetSqlQuery(ASql:string):TZQuery;
    procedure InitKeywords;
  public
    constructor Create; override;
    destructor Destroy; override;
    class function GetEngineName: string; override;
    procedure Load(const AData: TDataSet);override;
    procedure Store(const AData: TDataSet);override;
    procedure SetSqlAssistentData(const List: TStrings); override;
    function ExecSQL(const Sql:string;const ExecParams:TSqlExecParams):boolean;override;
    function SQLPlan(aDataSet:TDataSet):string;override;
    function GetQueryControl:TSQLQueryControl;override;


    procedure RefreshObjectsBeginFull;override;
    procedure RefreshObjectsEndFull;override;

    procedure RefreshObjectsBegin(const ASQLText:string; ASystemQuery:Boolean);override;

    property MSSQLConnection: TZConnection read FMSSQLConnection;
//    property ServerVersion:TCTServerVersion read FServerVersion write FServerVersion;
//    property DomainsRoot:TDomainsRoot read FDomainsRoot;
{    property TrigersRoot:TTrigersRoot read FTrigersRoot;
    property GeneratorsRoot:TGeneratorsRoot read FGeneratorsRoot;}
    property StoredProcRoot:TMSSQLStoredProcRoot read FStorepProc;
    property SchemasRoot:TMSSQLSSchemasRoot read FSchemasRoot;
{    property ExceptionRoot:TExceptionRoot read FExceptionRoot;
    property UDFRoot:TUDFRoot read FUDFRoot;
    property RoleRoot:TRoleRoot read FRoleRoot;
    property ViewsRoot:TViewsRoot read FViewsRoot;}
  end;

implementation
uses fbmStrConstUnit, mssql_sql_lines_unit, mssql_sql_parser,
  fbmToolsUnit;

{ TMSSQLFunction }

procedure TMSSQLFunction.InternalSetDescription(ACommentOn: TSQLCommentOn);
begin
  inherited InternalSetDescription(ACommentOn);
end;

constructor TMSSQLFunction.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
end;

destructor TMSSQLFunction.Destroy;
begin
  inherited Destroy;
end;

class function TMSSQLFunction.DBClassTitle: string;
begin
  Result:='function';
end;

procedure TMSSQLFunction.RefreshObject;
begin
  inherited RefreshObject;
end;

{ TMSSQLFunctionRoot }

function TMSSQLFunctionRoot.DBMSObjectsList: string;
begin
  Result:=msSQLTexts.sSystemObjects['sObjListAll'];
end;

function TMSSQLFunctionRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=(AItem.ObjType = 'IF') and (AItem.SchemeID = SchemaId);
end;

function TMSSQLFunctionRoot.GetObjectType: string;
begin
  Result:='function';
end;

constructor TMSSQLFunctionRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okFunction;
  FDropCommandClass:=TMSSQLDropFunction;
end;

{ TMSSQLSequence }

function TMSSQLSequence.GetCaptionFullPatch: string;
begin
  Result:=inherited GetCaptionFullPatch;
  //Result:=FmtObjName(FSchema, Self);
end;

function TMSSQLSequence.GetEnableRename: boolean;
begin
  Result:=true;
end;

constructor TMSSQLSequence.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
(*
  if Assigned(ADBItem) then
  begin
    FOID:=ADBItem.ObjId;
    FACLListStr:=ADBItem.ObjACLList;
  end;

  FACLList:=TPGACLList.Create(Self);
  FACLList.ObjectGrants:=[ogSelect, ogUpdate, ogUsage];
*)
  FSchema:=TMSSQLSequenceRoot(AOwnerRoot).FSchema;
  SchemaName:=FSchema.Caption;
  //FIncByValue:=1;
  //FMaxValue:=High(int64);
  //FCasheValue:=1;
end;

class function TMSSQLSequence.DBClassTitle: string;
begin
  Result:='Sequence';
end;

procedure TMSSQLSequence.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;

function TMSSQLSequence.InternalGetDDLCreate: string;
begin
  Result:=inherited InternalGetDDLCreate;
end;

function TMSSQLSequence.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=inherited CreateSQLObject;
end;

procedure TMSSQLSequence.RefreshObject;
begin
  inherited RefreshObject;
end;

procedure TMSSQLSequence.RefreshDependencies;
begin
  inherited RefreshDependencies;
end;

procedure TMSSQLSequence.RefreshDependenciesField(Rec: TDependRecord);
begin
  inherited RefreshDependenciesField(Rec);
end;

function TMSSQLSequence.RenameObject(ANewName: string): Boolean;
begin
  Result:=inherited RenameObject(ANewName);
end;

{ TMSSQLSequenceRoot }

function TMSSQLSequenceRoot.DBMSObjectsList: string;
begin
  Result:=msSQLTexts.sSystemObjects['sObjListAll'];
end;

function TMSSQLSequenceRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=(AItem.ObjType = 'SO') and (AItem.SchemeID = SchemaId);
end;

function TMSSQLSequenceRoot.GetObjectType: string;
begin
  Result:='Sequence';
end;

constructor TMSSQLSequenceRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okSequence;
  FDropCommandClass:=TMSSQLDropSequence;
end;

{ TMSSQLField }

procedure TMSSQLField.LoadfromDB(DS: TDataSet);
var
  S: String;
begin
(*
  object_id,
  name,
  column_id,
  system_type_id,
  user_type_id,
  max_length,
  precision,
  scale,
  collation_name,
  is_nullable,
  is_ansi_padded,
  is_rowguidcol,
  is_identity,
  is_computed,
  is_filestream,
  is_replicated,
  is_non_sql_subscribed,
  is_merge_published,
  is_dts_replicated,
  is_xml_document,
  xml_collection_id,
  default_object_id,
  rule_object_id,
  is_sparse,
  is_column_set,
  generated_always_type,
  generated_always_type_desc,
  encryption_type,
  encryption_type_desc,
  encryption_algorithm_name,
  column_encryption_key_id,
  column_encryption_key_database_name,
  is_hidden,
  is_masked,
  graph_type,
  graph_type_desc,
  types_name,
  max_length_1
*)
  FieldName:=DS.FieldByName('name').AsString;
  FieldNum:=DS.FieldByName('column_id').AsInteger;
(*
  if DS.FieldByName('typtype').AsString = 'd' then
  begin
    FieldTypeDomain:=DS.FieldByName('typnamespace_name').AsString + '.' + DS.FieldByName('typname').AsString;
    FieldTypeName:=DS.FieldByName('base_type').AsString;
    FieldTypeShceme:=DS.FieldByName('typnamespace').AsInteger;
    FDomainID:=DS.FieldByName('atttypid').AsInteger;     //!!check!
    FieldNotNull:=false;
  end
  else
  begin *)
//    FDomainID:=-1;
    { TODO : Пока не рализаеся тип char и "char" - надо исправить }
    //FieldTypeName:=DS.FieldByName('typname').AsString;
    S:=DS.FieldByName('types_name').AsString;
(*    FIsArray:=false;
    if (S<>'') and (S[1]='_') then
    begin
      FIsArray:=true;
      S:=Copy(S, 2, Length(S));
    end;

    if S = 'bpchar' then
      S:='char';

    if FIsArray then
      S:=S + '[]'; *)

    FieldTypeName:=S;
//    FieldNotNull:=DS.FieldByName('attnotnull').AsBoolean;
//  end;
  FieldNotNull:=not DS.FieldByName('is_nullable').AsBoolean;
(*
  if DS.FieldByName('atttypmod').AsInteger<>-1 then
  begin
    if FieldTypeRecord.DBType = ftFloat then
    begin
      FieldSize:=(DS.FieldByName('atttypmod').AsInteger and $FFFF0000) shr 16;
      FieldPrec:=(DS.FieldByName('atttypmod').AsInteger and $FFFF) - 4;
    end
    else
      FieldSize:=(DS.FieldByName('atttypmod').AsInteger and $FFFF) - 4;
  end;

  if (DS.FieldByName('attcollation').AsInteger > 0) then
    FieldCollateName:=DS.FieldByName('collation_nspn').AsString +  '.' + DS.FieldByName('collation_name').AsString;


  FieldDefaultValue:=DS.FieldByName('adsrc').AsString;
*)
  FFieldDescription:=DS.FieldByName('description').AsString;
(*
  if not DS.FieldByName('attislocal').AsBoolean then
    IOType:=spvtInput; //not local
*)
end;

procedure TMSSQLField.SetFieldDescription(const AValue: string);
var
  C: TMSSQLCommentOn;
  L:TStringList;
begin
  if (AValue <> FFieldDescription) and (Owner.State <> sdboCreate) then
  begin
    L:=TStringList.Create;
    C:=TMSSQLCommentOn.Create(nil);
    C.ObjectKind:=okColumn;
    C.TableName:=Owner.Caption;
    C.Name:=FieldName;
    if Owner is TMSSQLTable then
    begin
      C.SchemaName:=TMSSQLTable(Owner).FSchema.Caption;
      C.ParentObjectKind:=okTable;
    end
    else
    if Owner is TMSSQLView then
    begin
      C.SchemaName:=TMSSQLView(Owner).FSchema.Caption;
      C.ParentObjectKind:=okView;
    end;

    if FFieldDescription<>'' then
    begin
      C.Description:='';
      L.Add(C.AsSQL);
    end;

    C.Clear;
    C.Description:=TrimRight(AValue);
    if C.Description<>'' then
      L.Add(C.AsSQL);

    C.Free;
    if L.Count>0 then
      ExecSQLScriptEx(L, sysConfirmCompileDescEx + [sepInTransaction], Owner.OwnerDB);
    L.Free;
  end;
  inherited SetFieldDescription(AValue);
end;

function TMSSQLField.DDLTypeStr: string;
begin
  Result:=inherited DDLTypeStr;
end;

{ TMSSQLRootObject }

function TMSSQLRootObject.GetSchemaId: integer;
begin
  if Assigned(FSchema) then
    Result:=FSchema.FSchemaId
  else
    Result:=-1;
end;

constructor TMSSQLRootObject.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  if Assigned(AOwnerRoot) and (AOwnerRoot is TMSSQLSSchema) then
    FSchema:=TMSSQLSSchema(AOwnerRoot);
end;

{ TMSSQLEngine }

procedure TMSSQLEngine.InternalInitMSSQLEngine;
begin
  InitKeywords;
  MsSQLFillFieldTypes(FTypeList);
  FMSSQLConnection:=TZConnection.Create(nil);
  FUIParams:=[upSqlEditor, upUserName, upPassword, upLocal, upRemote];
end;

procedure TMSSQLEngine.RefreshObjectsBegin(const ASQLText: string;
  ASystemQuery: Boolean);
var
  DBObj: TDBItems;
  FQuery: TZQuery;
  FDesc, FOwnData, FObjData, FAclList, FKind2: TField;
  P: TDBItem;
begin
  DBObj:=FCashedItems.AddTypes(ASQLText);
  if DBObj.CountUse = 1 then
  begin
{    if ASystemQuery then
      FQuery:=GetSQLSysQuery(ASQLText)
    else}
      FQuery:=GetSQLQuery(ASQLText);
    FQuery.Open;

    FDesc:=FQuery.FindField('description');
    if not Assigned(FDesc) then
      if FQuery.Fields.Count > 4 then
        FDesc:=FQuery.Fields[4];
    FOwnData:=FQuery.FindField('own_data');
    FObjData:=FQuery.FindField('data');
    FAclList:=FQuery.FindField('acl_list');
    FKind2:=FQuery.FindField('kind_2');

    while not FQuery.Eof do
    begin
      P:=DBObj.Add(FQuery.Fields[2].AsString);
      P.ObjId:=FQuery.Fields[0].AsInteger;    //sys.all_objects.object_id
      P.SchemeID:=FQuery.Fields[1].AsInteger; // sys.all_objects.schema_id
      P.ObjType:=Trim(FQuery.Fields[3].AsString);   //sys.all_objects.[type]

      if Assigned(FDesc) then
        P.ObjDesc:=Trim(FDesc.AsString);
      if Assigned(FOwnData) then
        P.ObjOwnData:=FOwnData.AsInteger;

      if Assigned(FObjData) then
        P.ObjData:=FObjData.AsString;

      if Assigned(FKind2) then
        P.Kind2:=FKind2.AsString;

      if Assigned(FAclList) then
        P.ObjACLList:=FAclList.AsString;

      FQuery.Next;
    end;
    FQuery.Close;
    FreeAndNil(FQuery);
  end;
end;

function TMSSQLEngine.GetImageIndex: integer;
begin
  if GetConnected then
    Result:=21
  else
    Result:=20;
end;

function TMSSQLEngine.InternalSetConnected(const AValue: boolean): boolean;
var
  S: String;
begin
  if AValue then
  begin
    FMSSQLConnection.Properties.Clear;

    S:='/usr/lib64/libsybdb.so';
    FMSSQLConnection.LibraryLocation:=S;

    FMSSQLConnection.Protocol:='FreeTDS_MsSQL>=2005';
    FMSSQLConnection.Database:=DataBaseName;
    FMSSQLConnection.User:=UserName;
    FMSSQLConnection.Password:=Password;
    //FMSSQLConnection.ServerVersion:=FServerVersion;
    FMSSQLConnection.HostName:=ServerName;

    FMSSQLConnection.Connected:=true;
  end
  else
  begin
    FMSSQLConnection.Connected:=false;
  end;
  Result:=FMSSQLConnection.Connected;
end;

procedure TMSSQLEngine.InitGroupsObjects;
begin
  AddObjectsGroup(FSchemasRoot, TMSSQLSSchemasRoot, TMSSQLSSchema, sSchemes);
  //AddObjectsGroup(FTablesRoot, TMSSQLTablesRoot, );
  //AddObjectsGroup(FStorepProc, TMSSQLStoredProcRoot.Create(Self);
  //AddObjectsGroup(FViews, TMSSQLViewsRoot.Create(Self);
end;

procedure TMSSQLEngine.DoneGroupsObjects;
begin
  FStorepProc:=nil;
  FViews:=nil;
  FSchemasRoot:=nil;
end;

class function TMSSQLEngine.GetEngineName: string;
begin
  Result:='MS SQL Server';
end;

procedure TMSSQLEngine.SetUIShowSysObjects(const AValue: TUIShowSysObjects);
begin
  inherited SetUIShowSysObjects(AValue);
end;

function TMSSQLEngine.GetSqlQuery(ASql: string): TZQuery;
begin
  Result:=TZQuery.Create(nil);
  Result.Connection:=FMSSQLConnection;
  Result.SQL.Text:=ASql;
end;

procedure TMSSQLEngine.InitKeywords;
begin
  KeywordsList.Clear;
  FKeywords:=CreateMSSQLKeyWords;
  KeywordsList.Add(FKeywords);

//  KeywordsList.Add(FKeyFunctions);
end;

constructor TMSSQLEngine.Create;
begin
  inherited Create;
  FSQLEngileFeatures:=[feDescribeObject];
  InternalInitMSSQLEngine;
end;

destructor TMSSQLEngine.Destroy;
begin
  FreeAndNil(FMSSQLConnection);
  inherited Destroy;
end;

procedure TMSSQLEngine.Load(const AData: TDataSet);
begin
  inherited;
//  FServerVersion:=TCTServerVersion(IniFile.ReadInteger(IniSection, 'Server version', 2));
end;

procedure TMSSQLEngine.Store(const AData: TDataSet);
begin
  inherited;
end;

procedure TMSSQLEngine.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;

function TMSSQLEngine.ExecSQL(const Sql: string;
  const ExecParams: TSqlExecParams): boolean;
begin
  if sepSystemExec in ExecParams then
//    Result:=ExecSysSQL(Sql)
  else
  begin
    try
      Result:=FMSSQLConnection.ExecuteDirect(SQL);
    except
      on E:Exception do
      begin
        { TODO : Необходимо передалать сообщение об ошибке компиляции - выводит дополнительную информацию }
        InternalError(E.Message);
        Result:=false;
      end;
    end;
  end;
end;

function TMSSQLEngine.SQLPlan(aDataSet: TDataSet): string;
begin
  Result:='';
end;

function TMSSQLEngine.GetQueryControl: TSQLQueryControl;
begin
  Result:=TMSSQLQueryControl.Create(Self);
end;

procedure TMSSQLEngine.RefreshObjectsBeginFull;
begin
  RefreshObjectsBegin(msSQLTexts.sSchemas['ShemasAll'], false);
  RefreshObjectsBegin(msSQLTexts.sSystemObjects['sObjListAll'], false);
end;

procedure TMSSQLEngine.RefreshObjectsEndFull;
begin
  RefreshObjectsEnd(msSQLTexts.sSchemas['ShemasAll']);
  RefreshObjectsEnd(msSQLTexts.sSystemObjects['sObjListAll']);
end;

{ TMSSQLTablesRoot }

function TMSSQLTablesRoot.DBMSObjectsList: string;
begin
  Result:=msSQLTexts.sSystemObjects['sObjListAll'];
end;

function TMSSQLTablesRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=(AItem.ObjType = 'U') and (AItem.SchemeID = SchemaId);
end;

function TMSSQLTablesRoot.GetObjectType: string;
begin
  Result:='Table';
end;

constructor TMSSQLTablesRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited;
  FDBObjectKind:=okTable;
//  FDropCommandClass:=TPGSQLDropTable;
end;

procedure TMSSQLTable.InternalCreateDLL(var SQLLines: TStringList;
  const ATableName: string);

procedure   DoMakeIndexList;
begin
(*  S:='';
  for i:=0 to FIndexItems.Count - 1 do
  begin
    Pr:=TPGIndexItem(FIndexItems[i]);
    P:=TPGIndex(Schema.Indexs.ObjByName(Pr.IndexName));
    if Assigned(P) and not Pr.IsPrimary then
    begin
      S:=P.InternalGetDDLCreate;
      SQLLines.Add(S);
    end;
  end; *)
end;

var
  FCmd: TMSSQLCreateTable;
  CntPK, i: Integer;
  P: TPrimaryKeyRecord;
  C: TSQLConstraintItem;
  FkRec: TForeignKeyRecord;
begin
  if (State <> sdboCreate) and not Assigned(Fields) then
    RefreshObject;
  FCmd:=TMSSQLCreateTable.Create(nil);
  FCmd.Name:=Caption;
  FCmd.Description:=Description;
  FCmd.SchemaName:=SchemaName;
(*
  if FOwnerID<>0 then
  begin
    UG:=TDBObject(TSQLEnginePostgre(OwnerDB).FindUserByID(FOwnerID));
    if not Assigned(UG) then
      UG:=TDBObject(TSQLEnginePostgre(OwnerDB).FindGroupByID(FOwnerID));
    if Assigned(UG) then
      FCmd.Owner:=UG.Caption;
  end;
*)
  Fields.SaveToSQLFields(FCmd.Fields);


  IndexListRefresh;
  RefreshConstraintPrimaryKey;
  RefreshConstraintForeignKey;

  CntPK:=0;
  for i:=0 to FConstraintList.Count - 1 do
  begin
    P:=TPrimaryKeyRecord(FConstraintList[i]);
    if (TPrimaryKeyRecord(FConstraintList[i]).ConstraintType = ctPrimaryKey) and (CntPK = 0) then
    begin
      C:=FCmd.SQLConstraints.Add(ctPrimaryKey, P.Name);
      C.ConstraintFields.CopyFrom(P.FieldListArr);
      Inc(CntPK);
      C.Description:=P.Description;
    end
    else
    if TPrimaryKeyRecord(FConstraintList[i]).ConstraintType = ctForeignKey then
    begin
      FkRec:=TForeignKeyRecord(FConstraintList[i]);
      C:=FCmd.SQLConstraints.Add(ctForeignKey, FkRec.Name);
      C.ConstraintFields.CopyFrom(FkRec.FieldListArr);
      C.ForeignTable:=FkRec.FKTableName;
      C.ForeignKeyRuleOnUpdate:=FkRec.OnUpdateRule;
      C.ForeignKeyRuleOnDelete:=FkRec.OnDeleteRule;
      C.ForeignFields.AsString:=FkRec.FKFieldName;
      C.Description:=P.Description;
    end;
  end;
(*
  if FAutovacuumOptions.Enabled then
    AutovacuumOptions.SaveStorageParameters(FCmd.StorageParameters);
  if FToastAutovacuumOptions.Enabled then
    FToastAutovacuumOptions.SaveStorageParameters(FCmd.StorageParameters);

  if PartitionedTable then
  begin
    FCmd.TablePartition.PartitionType:=FPartitionedType;
    S:=FPartitionedTypeName;
    Copy2SymbDel(S, '(');
    if (S<>'') and (S[Length(S)] = ')') then
      Delete(S, Length(S), 1);
    FCmd.TablePartition.Params.AddParam(S);

    for PT in PartitionList do
    begin
      FCmdPart:=TPGSQLCreateTable.Create(nil);
      FCmd.AddChild(FCmdPart);
      FCmdPart.Name:=PT.Name;
      FCmdPart.SchemaName:=PT.SchemaName;
      FCmdPart.PartitionOfData.PartitionTableName:=CaptionFullPatch;
      if PT.DataType = podtDefault then
        FCmdPart.PartitionOfData.PartType:=podtDefault
      else
      case FPartitionedType of
        ptRange:
          begin
            FCmdPart.PartitionOfData.PartType:=podtFromTo;
            FCmdPart.PartitionOfData.Params.AddParam(PT.FromExp);
            FCmdPart.PartitionOfData.Params.AddParam(PT.ToExp);
          end;
        ptList:
          begin
            FCmdPart.PartitionOfData.PartType:=podtIn;
            FCmdPart.PartitionOfData.Params.AddParam(PT.InExp);
          end;
        ptHash:FCmdPart.PartitionOfData.PartType:=podtWith;
      end;
    end;
  end;

*)
  SQLLines.Add(FCmd.AsSQL);

  FCmd.Free;

  DoMakeIndexList;
end;

function TMSSQLTable.GetDBFieldClass: TDBFieldClass;
begin
  Result:=TMSSQLField;
end;

procedure TMSSQLTable.InternalRefreshStatistic;
begin
  inherited InternalRefreshStatistic;
  Statistic.AddValue(sOID, IntToStr(FOID));
  Statistic.AddValue(sSchemaOID, IntToStr(FSchema.SchemaId));
end;

{ TMSSQLTable }

constructor TMSSQLTable.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject
  );
begin
  inherited;


//  FACLList:=TPGACLList.Create(Self);
//  FACLList.ObjectGrants:=[ogSelect, ogInsert, ogUpdate, ogDelete, ogReference, ogTruncate, ogTrigger, ogWGO];
  if Assigned(ADBItem) then
  begin
    FOID:=ADBItem.ObjId;
//    FACLListStr:=ADBItem.ObjACLList;
(*
    if ADBItem.ObjType = 'p' then
      FDBObjectKind:=okPartitionTable; *)
  end;
(*

  if FACLListStr<>'' then
    TPGACLList(FACLList).ParseACLListStr(FACLListStr);
  FAutovacuumOptions:=TPGAutovacuumOptions.Create(false);
  FToastAutovacuumOptions:=TPGAutovacuumOptions.Create(true);
  FStorageParameters:=TStringList.Create;
  FPartitionList:=TPGTablePartitionList.Create(Self);
*)
  UITableOptions:=[
//     utReorderFields,
     utRenameTable,
     utAddFields,
     utEditField,
     utDropFields,
     utAddFK,
     utEditFK,
     utDropFK,
     utAddUNQ,
     utDropUNQ,
     utAlterAddFieldInitialValue,
     utAlterAddFieldFK,
     utSetFKName
     ];

  FSchema:=TMSSQLTablesRoot(AOwnerRoot).FSchema;
  SchemaName:=FSchema.Caption;
(*  FSystemObject:=FSchema.SystemObject;
  FInhTables:=TList.Create;
  FRuleList:=TPGRuleList.Create(Self);
  FCheckConstraints:=TList.Create;
*)

  FDataSet:=TZQuery.Create(nil);
  TZQuery(FDataSet).Connection:=TMSSQLEngine(OwnerDB).FMSSQLConnection;
(*  FDataSet.AfterOpen:=@DataSetAfterOpen;
  ZUpdateSQL:=TZUpdateSQL.Create(nil);
  TZQuery(FDataSet).UpdateObject:=ZUpdateSQL;

  FTriggerList[0]:=TFPList.Create;  //before insert
  FTriggerList[1]:=TFPList.Create;  //after insert
  FTriggerList[2]:=TFPList.Create;  //before update
  FTriggerList[3]:=TFPList.Create;  //after update
  FTriggerList[4]:=TFPList.Create;  //before delete
  FTriggerList[5]:=TFPList.Create;  //after delete
*)
end;

destructor TMSSQLTable.Destroy;
begin
  inherited Destroy;
end;

function TMSSQLTable.InternalGetDDLCreate: string;
var
  SQLLines: TStringList;
  i: Integer;
  S: String;
begin
  SQLLines:=TStringList.Create;
  try
    InternalCreateDLL(SQLLines, CaptionFullPatch);

    for i:=0 to SQLLines.Count - 1 do
    begin
      S:=TrimRight(SQLLines[i]);
      if (S<>'') and (S[Length(S)] <> ';') then
      begin
        SQLLines[i]:=S + ';' + LineEnding;
      end
      else
        SQLLines[i]:=SQLLines[i]+LineEnding;
    end;

    SQLLines.Add(MakeRemarkBlock(sTriggersList));
(*
    for i:=0 to FSchema.FTriggers.CountObject - 1 do
    begin
      Trig:=TPGTrigger(FSchema.FTriggers.Items[i]);
      if (Trig.TriggerTable = Self) and (Trig.State = sdboEdit) then
        SQLLines.Add(Trig.DDLCreate);
    end;

    FACLList.RefreshList;
    FACLList.MakeACLListSQL(nil, SQLLines, true);
*)
    Result:=SQLLines.Text;
  finally
    SQLLines.Free;
  end
end;

class function TMSSQLTable.DBClassTitle: string;
begin
  Result:=sTable;
end;

function TMSSQLTable.CreateSQLObject: TSQLCommandDDL;
begin
  if State <> sdboCreate then
  begin
    Result:=TMSSQLAlterTable.Create(nil);
    Result.Name:=Caption;
    TMSSQLAlterTable(Result).SchemaName:=Schema.Caption;
  end
  else
  begin
    Result:=TMSSQLCreateTable.Create(nil);
    TMSSQLCreateTable(Result).SchemaName:=Schema.Caption;
//    TMSSQLCreateTable(Result).StorageParameters.Assign(FStorageParameters);
  end;

end;

procedure TMSSQLTable.OnCloseEditorWindow;
begin
  inherited OnCloseEditorWindow;
  if Assigned(FDataSet) and FDataSet.Active then
    FDataSet.Close;
end;

function TMSSQLTable.RenameObject(ANewName: string): Boolean;
var
  FCmd: TMSSQLAlterTable;
  Op: TAlterTableOperator;
begin
  if (State = sdboCreate) then
  begin
    Caption:=ANewName;
    Result:=true;
  end
  else
  begin
    FCmd:=TMSSQLAlterTable.Create(nil);
    FCmd.Name:=Caption;
    FCmd.SchemaName:=SchemaName;
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

procedure TMSSQLTable.RefreshObject;
begin
  inherited RefreshObject;
{  FACLListStr:='';
  FPartitionedTypeName:='';
  FPartitionedTable:=false;
  FStorageParameters.Clear;
  FAutovacuumOptions.Clear;
  FToastAutovacuumOptions.Clear;
  FPartitionedType:=ptNone;

  FToastRelOID:=0; }
  if State = sdboEdit then
  begin
(*    Q:=TMSSQLEngine(OwnerDB).GetSqlQuery(msSQLTexts.sTables['sTableCollumns']);
    try
      Q.ParamByName('object_id').AsInteger:=FOID;
      Q.Open;
      if Q.RecordCount>0 then
      begin
{        FDescription:=Q.FieldByName('description').AsString;
        FOID:=Q.FieldByName('oid').AsInteger;
        FOwnerID:=Q.FieldByName('relowner').AsInteger;
        FTableSpaceID:=Q.FieldByName('reltablespace').AsInteger;
        FTableTemp:=Q.FieldByName('relpersistence').AsString = 't';
        FTableUnloged:=Q.FieldByName('relpersistence').AsString = 'u';

        if TSQLEnginePostgre(OwnerDB).RealServerVersionMajor<12 then
          FTableHasOIDS:=Q.FieldByName('relhasoids').AsBoolean;

        FRelOptions:=Q.FieldByName('reloptions').AsString;
        FToastRelOID:=Q.FieldByName('reltoastrelid').AsInteger;
        FToastRelOptions:=Q.FieldByName('tst_reloptions').AsString;
        FACLListStr:=Q.FieldByName('relacl').AsString;

        if TSQLEnginePostgre(OwnerDB).RealServerVersionMajor >= 10 then
        begin
          FPartitionedTable:=Q.FieldByName('relkind').AsString = 'p';
          if FPartitionedTable then
          begin
            FPartitionedTypeName:=Trim(Q.FieldByName('partition_type').AsString);
            if Copy(FPartitionedTypeName, 1, 5) = 'RANGE' then
              FPartitionedType:=ptRange
            else
            if Copy(FPartitionedTypeName, 1, 4) = 'LIST' then
              FPartitionedType:=ptList
            else
            if Copy(FPartitionedTypeName, 1, 4) = 'HASH' then
              FPartitionedType:=ptHash
            else
              raise Exception.CreateFmt('Unknow partioton type - %s', [FPartitionedTypeName]);
            //RANGE
            //LIST (
            //HASH
          end;
        end;
      end;
    finally
      Q.Free;
    end;

    if FToastRelOptions<>'' then
    begin
      ParsePGArrayString(FToastRelOptions, FStorageParameters);
      ToastAutovacuumOptions.LoadStorageParameters(FStorageParameters);
      for i:=0 to FStorageParameters.Count-1 do
        FStorageParameters[i]:='toast.' + FStorageParameters[i];
    end;

    if FRelOptions<>'' then
    begin
      ParsePGArrayString(FRelOptions, FStorageParameters);
      AutovacuumOptions.LoadStorageParameters(FStorageParameters);
    end;
  *)
    RefreshFieldList;
{    RefreshInheritedTables;
    FRuleList.RuleListRefresh;

    if PartitionedTable then
      RefreshPartitionals; }
  end;
end;

procedure TMSSQLTable.RefreshFieldList;
var
  FQuery: TZQuery;
  R: TMSSQLField;
begin
  if State <> sdboEdit then exit;
  Fields.Clear;

  FQuery:=TMSSQLEngine(OwnerDB).GetSqlQuery(msSQLTexts.sTables['sTableCollumns']);
  try
    FQuery.ParamByName('object_id').AsInteger:=FOID;
    FQuery.Open;
    while not FQuery.Eof do
    begin
      R:=Fields.Add('') as TMSSQLField;
      R.FieldName:=FQuery.FieldByName('name').AsString;
      R.LoadfromDB(FQuery);
      FQuery.Next;
    end;
  finally
    FQuery.Free;
  end;
(*
  RefreshConstraintPrimaryKey;
  RefreshConstraintUnique;
*)
end;

procedure TMSSQLTable.IndexListRefresh;
begin
  IndexArrayClear;
(*  FQuery:=TSQLEnginePostgre(OwnerDB).GetSQLQuery( pgSqlTextModule.sPGIndex['sqlIndexTable']);
  try
    FQuery.ParamByName('indrelid').AsInteger:=FOID;
    FQuery.Open;
    while not FQuery.Eof do
    begin
      Rec:=FIndexItems.Add('') as TPGIndexItem;
      Rec.CreateFromDB(Self, FQuery);
      FQuery.Next;
    end;
  finally
    FQuery.Free;
  end; *)
  FIndexListLoaded:=true;
end;

procedure TMSSQLTable.Commit;
begin
  if TMSSQLEngine(OwnerDB).MSSQLConnection.InTransaction then
    TMSSQLEngine(OwnerDB).MSSQLConnection.Commit;
  inherited Commit;
end;

procedure TMSSQLTable.RollBack;
begin
  if TMSSQLEngine(OwnerDB).MSSQLConnection.InTransaction then
    TMSSQLEngine(OwnerDB).MSSQLConnection.Rollback;
  inherited RollBack;
end;

function TMSSQLTable.DataSet(ARecCountLimit: Integer): TDataSet;
var
  S: String;
begin
  if not FDataSet.Active then
  begin
    TZQuery(FDataSet).SQL.Text:='select * from '+FSchema.Caption+'.'+Caption;//MakeSQLSelect(Caption, FBDataSet.DataBase);
    S:=TZQuery(FDataSet).SQL.Text;
{    FDataSet.SQLEdit.Text:=MakeSQLEdit(Caption, FBDataSet.DataBase);
    FDataSet.SQLInsert.Text:=MakeSQLInsert(Caption, FBDataSet.DataBase);
    FDataSet.SQLDelete.Text:=MakeSQLDelete(Caption, FBDataSet.DataBase);
    FDataSet.SQLRefresh.Text:=MakeSQLRefresh(Caption, FBDataSet.DataBase);}

{    if FOwnerDB.DisplayDataOptions.FetchAllData then
      FDataSet.Option := FDataSet.Option + [poFetchAll]
    else
      FDataSet.Option := FDataSet.Option - [poFetchAll];}
  end;
//  FDataSet.Active:=true;
  Result:=FDataSet;
end;

{ TMSSQLStoredProcRoot }

function TMSSQLStoredProcRoot.DBMSObjectsList: string;
begin
  Result:=inherited DBMSObjectsList;
end;

function TMSSQLStoredProcRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=inherited DBMSValidObject(AItem);
end;

function TMSSQLStoredProcRoot.GetObjectType: string;
begin
  Result:='Stored procedure';
end;
(*
procedure TMSSQLStoredProcRoot.RefreshGroup;
//var
//  P:PDBSQLObject;
//  U:TMSSQLStoredProcedure;
begin
  (*FObjects.Clear;
  FOwnerDB.RefreshObjectsBegin('');
  P:=TMSSQLEngine(FOwnerDB).CashedItems['AllObjects'];
  while Assigned(P) do
  begin
    if (P^.ObjType = 'P') and (P^.SchemeID = FSchemaId) then
    begin
      U:=TMSSQLStoredProcedure.Create(P^.ObjName, Self);
      U.FSchema:=FSchema;
    end;
    P:=P^.NextObj;
  end;
  FOwnerDB.RefreshObjectsEnd('');
  *)
end;
*)
constructor TMSSQLStoredProcRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited;
  //FCaption:=sStoredProcedures;
  //FDBObjectKind:=okStoredProc;
  //FOwnerDB:=AMSSQLEngine;
end;

{ TMSSQLStoredProcedure }
(*
procedure TMSSQLStoredProcedure.InternalSetDescription;
begin
//  inherited InternalSetDescription;
end;
*)
procedure TMSSQLStoredProcedure.SetState(const AValue: TDBObjectState);
begin
  inherited SetState(AValue);
end;
(*
procedure TMSSQLStoredProcedure.FieldListRefresh;
begin
  if not Assigned(FFields) then
    FFields:=TFieldItems.Create;
  FFields.Clear;
end;
*)
constructor TMSSQLStoredProcedure.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited;
end;

destructor TMSSQLStoredProcedure.Destroy;
begin
  inherited Destroy;
end;

class function TMSSQLStoredProcedure.DBClassTitle: string;
begin
  Result:=sStoredProcedure;
end;

procedure TMSSQLStoredProcedure.RefreshObject;
begin
//  inherited Refresh;
end;

procedure TMSSQLStoredProcedure.Commit;
begin
//  inherited Commit;
end;

procedure TMSSQLStoredProcedure.RollBack;
begin
//  inherited RollBack;
end;

function TMSSQLStoredProcedure.DataSet(ARecCountLimit: Integer): TDataSet;
begin
  Result:=nil;
end;

{ TMSSQLViewsRoot }

function TMSSQLViewsRoot.DBMSObjectsList: string;
begin
  Result:=msSQLTexts.sSystemObjects['sObjListAll'];
end;

function TMSSQLViewsRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=(AItem.ObjType = 'V') and (AItem.SchemeID = SchemaId);
end;

function TMSSQLViewsRoot.GetObjectType: string;
begin
  Result:='View';
end;

constructor TMSSQLViewsRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited;
  FDBObjectKind:=okView;
  FDropCommandClass:=TMSSQLDropView;
end;

{ TMSSQLView }

function TMSSQLView.GetDDLAlter: string;
begin
  Result:=FSQLBody;
end;

function TMSSQLView.GetDBFieldClass: TDBFieldClass;
begin
  Result:=TMSSQLField;
end;

procedure TMSSQLView.InternalRefreshStatistic;
begin
  inherited InternalRefreshStatistic;
  Statistic.AddValue(sOID, IntToStr(FOID));
  Statistic.AddValue(sSchemaOID, IntToStr(FSchema.SchemaId));
end;

procedure TMSSQLView.RefreshFieldList;
var
  FQuery: TZQuery;
  R: TMSSQLField;
begin
  if State <> sdboEdit then exit;
  Fields.Clear;

  FQuery:=TMSSQLEngine(OwnerDB).GetSqlQuery(msSQLTexts.sTables['sTableCollumns']);
  try
    FQuery.ParamByName('object_id').AsInteger:=FOID;
    FQuery.Open;
    while not FQuery.Eof do
    begin
      R:=Fields.Add('') as TMSSQLField;
      R.FieldName:=FQuery.FieldByName('name').AsString;
      R.LoadfromDB(FQuery);
      FQuery.Next;
    end;
  finally
    FQuery.Free;
  end;
end;

function TMSSQLView.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=TMSSQLCreateView.Create(nil);
  TMSSQLCreateView(Result).SchemaName:=FSchema.Caption;
  Result.Name:=Caption;
end;

function TMSSQLView.CompileSQLObject(ASqlObject: TSQLCommandDDL;
  ASqlExecParam: TSqlExecParams): boolean;
begin
  if ASqlObject is TMSSQLCreateView then
    TMSSQLCreateView(ASqlObject).SchemaName:=FSchema.Caption;

  Result:=inherited CompileSQLObject(ASqlObject, ASqlExecParam);
end;

constructor TMSSQLView.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject
  );
begin
  inherited;
  if Assigned(ADBItem) then
  begin
    FOID:=ADBItem.ObjId;
  end;

  FDataSet:=TZQuery.Create(nil);
  TZQuery(FDataSet).Connection:=TMSSQLEngine(OwnerDB).FMSSQLConnection;

  UITableOptions:=[];
//  FStorageParameters:=TStringList.Create;

  FSchema:=TMSSQLViewsRoot(AOwnerRoot).FSchema;
  SchemaName:=FSchema.Caption;

//  FACLList:=TPGACLList.Create(Self);
//  FACLList.ObjectGrants:=[ogInsert, ogSelect, ogUpdate, ogDelete, ogReference, ogTrigger];
//  if FACLListStr<>'' then
//    TPGACLList(FACLList).ParseACLListStr(FACLListStr);

//  FRuleList:=TPGRuleList.Create(Self);

//  FSystemObject:=FSchema.SystemObject;
//  FDataSet.AfterOpen:=@DataSetAfterOpen;

end;

destructor TMSSQLView.Destroy;
begin
  inherited Destroy;
end;

class function TMSSQLView.DBClassTitle: string;
begin
  Result:='View';
end;

procedure TMSSQLView.RefreshObject;
var
  Q: TZQuery;
begin
  inherited RefreshObject;
//  FStorageParameters.Clear;
//  FRelOptions:='';
//  FToastRelOID:=0;
//  FToastRelOptions:='';
//  FACLListStr:='';

  if State <> sdboEdit then exit;
  Q:=TMSSQLEngine(OwnerDB).GetSqlQuery(msSQLTexts.sTables['sViewDefenition']);
  try
    Q.ParamByName('object_id').AsInteger:=FOID;
//    Q.ParamByName('relnamespace').AsInteger:=FSchema.SchemaId;
    //if Self is TPGMatView then
    //  Q.ParamByName('relkind').AsString:='m'
    //else
    //  Q.ParamByName('relkind').AsString:='v';
    Q.Open;
    if Q.RecordCount>0 then
    begin
//      FDescription:=Q.FieldByName('description').AsString;
      FOID:=Q.FieldByName('object_id').AsInteger;
//      S:=Q.FieldByName('object_name').AsString;
      FSQLBody:=Q.FieldByName('definition').AsString;
//      FRelOptions:=Q.FieldByName('reloptions').AsString;
//      FOwnerID:=Q.FieldByName('relowner').AsInteger;

//      FToastRelOID:=Q.FieldByName('reltoastrelid').AsInteger;
//      FToastRelOptions:=Q.FieldByName('tst_reloptions').AsString;
//      FACLListStr:=Q.FieldByName('relacl').AsString;
    end;
  finally
    Q.Free;
  end;
  RefreshFieldList;
end;

procedure TMSSQLView.Commit;
begin
  if TMSSQLEngine(OwnerDB).MSSQLConnection.InTransaction then
    TMSSQLEngine(OwnerDB).MSSQLConnection.Rollback;
  inherited Commit;
end;

procedure TMSSQLView.RollBack;
begin
  if TMSSQLEngine(OwnerDB).MSSQLConnection.InTransaction then
    TMSSQLEngine(OwnerDB).MSSQLConnection.Rollback;
  inherited RollBack;
end;

function TMSSQLView.DataSet(ARecCountLimit: Integer): TDataSet;
begin
  if not FDataSet.Active then
  begin
    TZQuery(FDataSet).SQL.Text:='select * from '+FSchema.Caption+'.'+Caption;//MakeSQLSelect(Caption, FBDataSet.DataBase);
{    FDataSet.SQLEdit.Text:=MakeSQLEdit(Caption, FBDataSet.DataBase);
    FDataSet.SQLInsert.Text:=MakeSQLInsert(Caption, FBDataSet.DataBase);
    FDataSet.SQLDelete.Text:=MakeSQLDelete(Caption, FBDataSet.DataBase);
    FDataSet.SQLRefresh.Text:=MakeSQLRefresh(Caption, FBDataSet.DataBase);}

{    if FOwnerDB.DisplayDataOptions.FetchAllData then
      FDataSet.Option := FDataSet.Option + [poFetchAll]
    else
      FDataSet.Option := FDataSet.Option - [poFetchAll];}
  end;
//  FDataSet.Active:=true;
  Result:=FDataSet;
end;

{ TMSSQLQueryControl }
(*
procedure TMSSQLQueryControl.SetParamValues;
var
  i:integer;
begin
  for i:=0 to FParams.Count-1 do
  begin
    case FParams[i].DataType of
      ftString   : FQuery.Params.ParamByName(FParams[i].Name).AsString:=FParams[i].AsString;
      ftInteger  : FQuery.Params.ParamByName(FParams[i].Name).AsInteger:=FParams[i].AsInteger;
      ftFloat    : FQuery.Params.ParamByName(FParams[i].Name).AsFloat:=FParams[i].AsInteger;
      ftDateTime : FQuery.Params.ParamByName(FParams[i].Name).AsDateTime:=FParams[i].AsDateTime;
      ftCurrency : FQuery.Params.ParamByName(FParams[i].Name).AsCurrency:=FParams[i].AsCurrency;
    end;
  end;
end;
*)
function TMSSQLQueryControl.GetDataSet: TDataSet;
begin
  Result:=FSQLQuery;
end;

function TMSSQLQueryControl.GetQueryPlan: string;
begin
{  FBQuery.QuerySelect.Prepare(true);
  Result:=FBQuery.QuerySelect.Plan;}
  Result:='';
end;

function TMSSQLQueryControl.GetQuerySQL: string;
begin
  Result:=FSQLQuery.SQL.Text;
end;

procedure TMSSQLQueryControl.SetQuerySQL(const AValue: string);
begin
  FSQLQuery.Active:=false;
  FSQLQuery.SQL.Text:=AValue;
end;

function TMSSQLQueryControl.GetParam(AIndex: integer): TParam;
begin
  Result:=FSQLQuery.Params[AIndex];
end;

function TMSSQLQueryControl.GetParamCount: integer;
begin
  Result:=FSQLQuery.Params.Count;
end;

procedure TMSSQLQueryControl.SetActive(const AValue: boolean);
begin
//  SetParamValues;
  if AValue then
    FSQLQuery.SortedFields:='';
  inherited SetActive(AValue);
end;

constructor TMSSQLQueryControl.Create(AOwner: TSQLEngineAbstract);
begin
  inherited Create(AOwner);
  FSQLQuery:=TZQuery.Create(nil);
  FSQLQuery.Connection:=TMSSQLEngine(Owner).FMSSQLConnection;
//  FQuery.Transaction:=FFBTransaction;
//  FParams:=TParams.Create(nil);
end;

destructor TMSSQLQueryControl.Destroy;
begin
//  FreeAndNil(FParams);
  FreeAndNil(FSQLQuery);
  inherited Destroy;
end;

function TMSSQLQueryControl.LoadStatistic(out StatRec: TQueryStatRecord;
  const SQLCommand: TSQLCommandAbstract): boolean;
begin
  Result:=inherited LoadStatistic(StatRec, SQLCommand);
  if SQLCommand is TSQLCommandUpdate then
    StatRec.UpdatedRows:=FSQLQuery.RowsAffected
  else
  if SQLCommand is TSQLCommandInsert then
    StatRec.InsertedRows:=FSQLQuery.RowsAffected
  else
  if SQLCommand is TSQLCommandDelete then
    StatRec.DeletedRows:=FSQLQuery.RowsAffected
  else
  if (SQLCommand is TSQLCommandAbstractSelect) and (TSQLCommandAbstractSelect(SQLCommand).Selectable) and (FSQLQuery.Active) then
    StatRec.SelectedRows:=FSQLQuery.RecordCount
  else
    Exit;
  Result:=true;
end;

procedure TMSSQLQueryControl.CommitTransaction;
begin
//  inherited CommitTransaction;
end;

procedure TMSSQLQueryControl.RolbackTransaction;
begin
//  inherited RolbackTransaction;
end;

procedure TMSSQLQueryControl.FetchAll;
begin
  FSQLQuery.FetchAll;
end;

procedure TMSSQLQueryControl.Prepare;
begin
  FSQLQuery.Prepare;
end;

procedure TMSSQLQueryControl.ExecSQL;
begin
  FSQLQuery.ExecSQL;
end;

{ TMSSQLSSchemasRoot }

function TMSSQLSSchemasRoot.DBMSObjectsList: string;
begin
  Result:=msSQLTexts.sSchemas['ShemasAll'];
end;

function TMSSQLSSchemasRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=true;
end;

function TMSSQLSSchemasRoot.GetObjectType: string;
begin
  Result:='Schema';
end;

constructor TMSSQLSSchemasRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited;
  FDBObjectKind:=okScheme;
  FDropCommandClass:=TMSSQLDropSchema;
end;

{ TMSSQLSSchema }

procedure TMSSQLSSchema.SetSchemaId(const AValue: integer);
begin
  FSchemaId:=AValue;
end;
(*
function TMSSQLSSchema.GetCountGrp: integer;
begin
  Result:=4;
end;

function TMSSQLSSchema.GetImageIndex: integer;
begin
  Result:=21;
end;
*)
function TMSSQLSSchema.GetObjectType: string;
begin
  Result:='Schema';
end;

procedure TMSSQLSSchema.RefreshGroup;
begin
(*  FTablesRoot.RefreshGroup;
  FStorepProc.RefreshGroup;
  FViews.RefreshGroup; *)
end;

procedure TMSSQLSSchema.RefreshObject;
begin
  inherited RefreshObject;
end;

constructor TMSSQLSSchema.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited;

  if Assigned(ADBItem) then
  begin
    FSchemaId:=ADBItem.ObjId;
    //FOwnerName:=ADBItem.ObjType;
    //FACLListStr:=ADBItem.ObjACLList;
  end;

  //FACLList:=TPGACLList.Create(Self);
  //FACLList.ObjectGrants:=[ogCreate, ogUsage, ogWGO];
  //if FACLListStr<>'' then
  //  TPGACLList(FACLList).ParseACLListStr(FACLListStr);

  FDBObjectKind:=okScheme;

  FTablesRoot:=TMSSQLTablesRoot.Create(OwnerDB, TMSSQLTable, sTables, Self);
  FViews:=TMSSQLViewsRoot.Create(OwnerDB, TMSSQLView, sViews, Self);
  //FStorepProc:=TMSSQLStoredProcRoot.Create(AMSSQLEngine);
  //FTriggers:=TMSSQLTriggerRoot.Create(AMSSQLEngine);
  FSequences:=TMSSQLSequenceRoot.Create(OwnerDB, TMSSQLSequence, sSequences, Self);
  FFunctions:=TMSSQLFunctionRoot.Create(OwnerDB, TMSSQLFunction, sFunction, Self);

end;

destructor TMSSQLSSchema.Destroy;
begin
  FreeAndNil(FTablesRoot);
  FreeAndNil(FStorepProc);
  FreeAndNil(FViews);
  FreeAndNil(FTriggers);
  inherited Destroy;
end;

function TMSSQLSSchema.CreateSQLObject: TSQLCommandDDL;
begin
  if State = sdboCreate then
    Result:=TMSSQLCreateSchema.Create(nil)
  else
  begin
    Result:=TMSSQLAlterSchema.Create(nil);
    Result.Name:=Caption;
    TMSSQLAlterSchema(Result).OldDescription:=Description;
  end;
end;

{ TMSSQLTriggerRoot }

function TMSSQLTriggerRoot.DBMSObjectsList: string;
begin
  Result:=inherited DBMSObjectsList;
end;

function TMSSQLTriggerRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=inherited DBMSValidObject(AItem);
end;

function TMSSQLTriggerRoot.GetObjectType: string;
begin
  Result:='Trigger';
end;
(*
procedure TMSSQLTriggerRoot.RefreshGroup;
//var
//  P:PDBSQLObject;
//  T:TMSSQLTriger;
begin
  FObjects.Clear;
(*  FOwnerDB.RefreshObjectsBegin('');
  P:=TMSSQLEngine(FOwnerDB).CashedItems['AllObjects'];
  while Assigned(P) do
  begin
    if (P^.ObjType = 'TR') and (P^.SchemeID = FSchemaId) then
    begin
      T:=TMSSQLTriger.Create(P^.ObjName, Self);
      T.FSchema:=FSchema;
    end;
    P:=P^.NextObj;
  end;
  FOwnerDB.RefreshObjectsEnd(''); *)
end;
*)
constructor TMSSQLTriggerRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited;
  //FCaption:=sTriggers;
  //FDBObjectKind:=okTrigger;
  //FOwnerDB:=AMSSQLEngine;
end;

{ TMSSQLTriger }
(*
procedure TMSSQLTriger.InternalSetDescription;
begin
//  inherited InternalSetDescription;
end;
*)
procedure TMSSQLTriger.SetState(const AValue: TDBObjectState);
begin
  inherited SetState(AValue);
end;

procedure TMSSQLTriger.SetActive(const AValue: boolean);
begin
//  inherited SetActive(AValue);
end;

function TMSSQLTriger.GetTriggerBody: string;
begin
  Result:='';//inherited GetTriggerBody;
end;

constructor TMSSQLTriger.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited;
end;

destructor TMSSQLTriger.Destroy;
begin
  inherited Destroy;
end;

class function TMSSQLTriger.DBClassTitle: string;
begin
  Result:=sTrigger;
end;

procedure TMSSQLTriger.RefreshObject;
begin
//  inherited Refresh;
end;

initialization
  //Register DML statments
  RegisterSQLStatment(TMSSQLEngine, TSqlCommandSelect, 'SELECT'); //SELECT — получить строки из таблицы или представления
  //Register DDL statments
  RegisterSQLStatment(TMSSQLEngine, TMSSQLCreateSchema, 'CREATE SCHEMA');         //CREATE SCHEMA — создать схему
  RegisterSQLStatment(TMSSQLEngine, TMSSQLAlterSchema, 'ALTER SCHEMA');           //ALTER SCHEMA — изменить определение схемы
  RegisterSQLStatment(TMSSQLEngine, TMSSQLDropSchema, 'DROP SCHEMA');             //DROP SCHEMA — удалить схему

  RegisterSQLStatment(TMSSQLEngine, TMSSQLCreateTable, 'CREATE TABLE');           //CREATE TABLE — создать таблицу
  RegisterSQLStatment(TMSSQLEngine, TMSSQLAlterTable, 'ALTER TABLE');             //ALTER TABLE — изменить определение таблицы
  RegisterSQLStatment(TMSSQLEngine, TMSSQLDropTable, 'DROP TABLE');               //DROP TABLE — удалить таблицу

  RegisterSQLStatment(TMSSQLEngine, TMSSQLCreateView, 'CREATE VIEW');             //CREATE VIEW — создать представление
  RegisterSQLStatment(TMSSQLEngine, TMSSQLAlterView, 'ALTER VIEW');               //ALTER VIEW — изменить определение представления
  RegisterSQLStatment(TMSSQLEngine, TMSSQLDropView, 'DROP VIEW');                 //DROP VIEW — удалить представление

  RegisterSQLStatment(TMSSQLEngine, TMSSQLCreateDatabase, 'CREATE DATABASE');
  RegisterSQLStatment(TMSSQLEngine, TMSSQLDropDatabase, 'DROP DATABASE');

  RegisterSQLStatment(TMSSQLEngine, TMSSQLCreateSequence, 'CREATE SEQUENCE');     //CREATE SEQUENCE — создать генератор последовательности
  RegisterSQLStatment(TMSSQLEngine, TMSSQLAlterSequence, 'ALTER SEQUENCE');       //ALTER SEQUENCE — изменить определение генератора последовательности
  RegisterSQLStatment(TMSSQLEngine, TMSSQLDropSequence, 'DROP SEQUENCE');         //DROP SEQUENCE — удалить последовательность

  RegisterSQLStatment(TMSSQLEngine, TMSSQLCreateFunction, 'CREATE FUNCTION');     //CREATE FUNCTION — создать функцию
  RegisterSQLStatment(TMSSQLEngine, TMSSQLAlterFunction, 'ALTER FUNCTION');       //ALTER FUNCTION — изменить определение функции
  RegisterSQLStatment(TMSSQLEngine, TMSSQLDropFunction, 'DROP FUNCTION');         //DROP FUNCTION — удалить функцию

  RegisterSQLStatment(TMSSQLEngine, TMSSQLCreateProcedure, 'CREATE PROCEDURE');
  RegisterSQLStatment(TMSSQLEngine, TMSSQLAlterProcedure, 'ALTER PROCEDURE');
  RegisterSQLStatment(TMSSQLEngine, TMSSQLDropProcedure, 'DROP PROCEDURE');

  RegisterSQLStatment(TMSSQLEngine, TMSSQLExec, 'EXEC'); //EXEC
  RegisterSQLStatment(TMSSQLEngine, TMSSQLGO, 'GO'); //GO
end.

