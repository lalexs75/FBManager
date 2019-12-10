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

unit FBSQLEngineUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineAbstractUnit, db, uib, FBCustomDataSet, SQLEngineInternalToolsUnit,
  contnrs, fb_utils, SQLEngineCommonTypesUnit, fbmisc,
  fb_SqlParserUnit, uibsqlparser, fbKeywordsUnit, fbmSqlParserUnit,
  sqlObjects;

const
  FireBirdDefTCPPort = 3050;

type
  TTriggersLists = array [0..5] of TList;

type

  { TFireBirdBackupOptions }

  TFireBirdBackupOptions = class
    //Backup info
    bkSingleFileName:string;
    bkVerboseToScreen:boolean;
    bkVerboseToFile:boolean;
    bkVerboseFileName:string;
  end;

  { TFireBirdRestoreOptions }

  TFireBirdRestoreOptions = class
    //Restore info
    roSingleFileName:string;
    roVerboseToScreen:boolean;
    roVerboseToFile:boolean;
    roVerboseFileName:string;
    roPageSize:Cardinal;
    roRestoreOption: TRestoreOptions;
  end;


type

  TSQLEngineFireBird = class;
  TSystemDomainsRoot  = class;
  TSystemTablesRoot = class;
  TFireBirdSystemIndexRoot = class;

  { TFBACLItem }

  TFBACLItem = class(TACLItem)
  protected
    function ObjectTypeName:string; override;
  end;

  { TFBACLList }

  TFBACLList = class(TACLListAbstract)
  protected
    function InternalCreateACLItem: TACLItem; override;
    function InternalCreateGrantObject: TSQLCommandGrant; override;
    function InternalCreateRevokeObject: TSQLCommandGrant; override;
  public
    procedure LoadUserAndGroups; override;
    procedure RefreshList; override;
  end;

  { TFBSystemCatalog }

  TFBSystemCatalog = class(TDBRootObject)
  private
    FSystemDomainsRoot:TSystemDomainsRoot;
    FSystemTablesRoot:TSystemTablesRoot;
    FSystemIndexRoot: TFireBirdSystemIndexRoot;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  //list of root objets
  { TDomainsRoot }

  TDomainsRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TSystemDomainsRoot }

  TSystemDomainsRoot = class(TDomainsRoot)
  public
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TTablesRoot }

  TTablesRoot = class(TDBRootObject)
  protected
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string; override;
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
  private
  protected
    function DBMSObjectsList:string; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TTriggersRoot }

  TTriggersRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TGeneratorsRoot }

  TGeneratorsRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TStoredProcRoot }

  TStoredProcRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TExceptionRoot }

  TExceptionRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;


  { TFireBirdIndexRoot }

  TFireBirdIndexRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TFireBirdSystemIndexRoot }

  TFireBirdSystemIndexRoot = class(TFireBirdIndexRoot)
  public
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TUDFRoot }

  TUDFRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TRoleRoot }

  TRoleRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TPackagesRoot }

  TPackagesRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TFunctionsRoot }

  TFunctionsRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  //List of FB objects

  { TFireBirdDomain }

  TFireBirdDomain = class(TDBDomain)
  private
    FCharSetID: integer;
    FCollationID: integer;
    FSqlFieldType: integer;
    FSqlFieldSubType: integer;
  protected
    function InternalGetDDLCreate: string; override;
    procedure InternalSetDescription(ACommentOn: TSQLCommentOn); override;
    function GetEnableRename: boolean; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    function RenameObject(ANewName:string):Boolean; override;
    procedure RefreshDependencies;override;
    procedure RefreshObject; override;
    class function DBClassTitle:string;override;
    function CreateSQLObject:TSQLCommandDDL; override;
    procedure SetSqlAssistentData(const List: TStrings); override;
    property CharSetID:integer read FCharSetID;
    property CollationID:integer read FCollationID;
  end;

  //Table object

  { TFirebirdField }

  TFirebirdField = class(TDBField)
  protected
    procedure SetFieldDescription(const AValue: string);override;
  public
    function RefreshDependenciesFromField:TStringList;override;
  end;

  { TFireBirdTable }

  TFireBirdTable = class(TDBTableObject)
  private
    FExternalFile: string;
    FTempTableAction: TTempTableAction;
    FTransaction:TUIBTransaction;
    FTriggerList:TTriggersLists;
    procedure DSUpdateRecord(ADataSet: TDataSet; AUpdateKind: DB.TUpdateKind; var AUpdateAction: fbmisc.TUpdateAction);
  protected
    procedure InternalSetDescription(ACommentOn: TSQLCommentOn); override;
    function InternalGetDDLCreate: string; override;

    function GetTrigger(ACat:integer; AItem: integer): TDBTriggerObject; override;
    function GetTriggersCategories(AItem: integer): string; override;
    function GetTriggersCategoriesCount: integer; override;
    function GetTriggersCount(AItem: integer): integer; override;
    function GetIndexFields(const AIndexName:string; const AForce:boolean):string;override;
    function GetTriggersCategoriesType(AItem: integer): TTriggerTypes;override;
    function GetRecordCount: integer; override;
    function GetDBFieldClass: TDBFieldClass; override;
    procedure InternalRefreshStatistic; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;

    procedure Commit;override;
    procedure RollBack;override;
    procedure RefreshObject;override;

    procedure RefreshDependencies;override;
    procedure RefreshDependenciesField(Rec:TDependRecord);override;
    function CreateSQLObject:TSQLCommandDDL; override;
    function GetDDLSQLObject(ACommandType:TDDLCommandType):TSQLCommandDDL; override;

    //function RenameObject(ANewName:string):Boolean;override;
    procedure RefreshFieldList; override;
    procedure SetFieldsOrder(AFieldsList:TStrings); override;

    procedure IndexListRefresh; override;
    function IndexNew:string; override;
    function IndexEdit(const IndexName:string):boolean; override;
    function IndexDelete(const IndexName:string):boolean; override;

    procedure RefreshConstraintPrimaryKey;override;
    procedure RefreshConstraintForeignKey;override;
    procedure RefreshConstraintUnique; override;
    procedure RefreshConstraintCheck; override;

    function DataSet(ARecCountLimit:Integer):TDataSet;override;

    procedure TriggersListRefresh; override;
    function TriggerNew(TriggerTypes:TTriggerTypes):TDBTriggerObject;override;
    function TriggerDelete(const ATrigger:TDBTriggerObject):Boolean;override;
    procedure RecompileTriggers;override;
    procedure AllTriggersSetActiveState(AState:boolean);override;
    property ExternalFile:string read FExternalFile;
    property TempTableAction:TTempTableAction read FTempTableAction;
  end;

  { TFireBirdView }

  TFireBirdView = class(TDBViewObject)
  private
    FTransaction:TUIBTransaction;
    FTriggerList:TTriggersLists;
  protected
    function InternalGetDDLCreate: string; override;
    function GetDDLAlter: string; override;
    function GetTrigger(ACat:integer; AItem: integer): TDBTriggerObject; override;
    function GetTriggersCategories(AItem: integer): string; override;
    function GetTriggersCategoriesCount: integer; override;
    function GetTriggersCount(AItem: integer): integer; override;
    function GetTriggersCategoriesType(AItem: integer): TTriggerTypes;override;
    procedure InternalSetDescription(ACommentOn: TSQLCommentOn);override;
    function GetRecordCount: integer; override;
    function GetDBFieldClass: TDBFieldClass; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    procedure RefreshObject; override;
    class function DBClassTitle:string;override;
    function CreateSQLObject:TSQLCommandDDL; override;
    procedure Commit;override;
    procedure RollBack;override;
    function DataSet(ARecCountLimit:Integer):TDataSet;override;
    function TriggerNew(TriggerTypes:TTriggerTypes):TDBTriggerObject;override;
    procedure TriggersListRefresh; override;
    procedure RefreshFieldList; override;
    procedure RefreshDependencies;override;
    procedure MakeSQLStatementsList(AList:TStrings); override;
  end;

  { TFireBirdTriger }

  TFireBirdTriger = class(TDBTriggerObject)
  private
    FTriggerBody:string;
  protected
    procedure InternalSetDescription(ACommentOn: TSQLCommentOn);override;
    function InternalGetDDLCreate: string; override;
    procedure SetActive(const AValue: boolean); override;
    function GetTriggerBody: string;override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    class function DBClassTitle:string;override;
    procedure RefreshDependencies;override;

    function CreateSQLObject:TSQLCommandDDL;override;
    function CompileSQLObject(ASqlObject:TSQLCommandDDL; ASqlExecParam:TSqlExecParams = [sepShowCompForm]):boolean;override;

    procedure RefreshObject; override;
  end;

  { TFireBirdGenerator }

  TFireBirdGenerator = class(TDBObject)
  private
    FGeneratorValue: integer;
  protected
    function InternalGetDDLCreate: string; override;
    procedure InternalSetDescription(ACommentOn: TSQLCommentOn);override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    class function DBClassTitle:string;override;

    function CreateSQLObject:TSQLCommandDDL;override;

    procedure RefreshObject; override;
    procedure RefreshDependencies;override;
    property GeneratorValue:integer read FGeneratorValue;
  end;

  { TFireBirdStoredProc }

  TFireBirdStoredProc = class(TDBStoredProcObject)
  protected
    function InternalGetDDLCreate: string; override;
    procedure RefreshParams; override;
    procedure MakeAutoGrantObject;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;

    function CreateSQLObject:TSQLCommandDDL;override;
    class function DBClassTitle:string;override;
    procedure RefreshObject; override;
    procedure RefreshDependencies;override;
    property FieldsIN;
    property FieldsOut;
  end;

  { TFireBirdException }

  TFireBirdException = class(TDBObject)
  private
    FExceptionMsg:string;
  protected
    function InternalGetDDLCreate: string; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    class function DBClassTitle:string;override;

    function CreateSQLObject:TSQLCommandDDL;override;

    procedure RefreshObject; override;
    property ExceptionMsg:string read FExceptionMsg write FExceptionMsg;
    procedure RefreshDependencies;override;
  end;

  TFireBirdIndex = class(TDBIndex)
  private
    FIndexActive: boolean;
    FIndexExpression: string;
    FIndexSortOrder: TIndexSortOrder;
    FIndexUnique: boolean;
    FIndexID:integer;
  protected
    function InternalGetDDLCreate: string; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure SetSqlAssistentData(const List: TStrings);override;
    procedure RefreshObject;override;
    procedure RefreshDependencies; override;
    procedure RefreshDependenciesField(Rec:TDependRecord); override;
    function CreateSQLObject:TSQLCommandDDL; override;

    property IndexUnique:boolean read FIndexUnique;
    property IndexExpression:string read FIndexExpression;
    property IndexActive:boolean read FIndexActive;
    property IndexSortOrder:TIndexSortOrder read FIndexSortOrder;
  end;

  { TFireBirdUDF }

  TFireBirdUDF = class(TDBObject)
  private
    FCountArgs: integer;
    FEntryPoint: string;
    FFunctionType: integer;
    FLibName: string;
    FReturnArg: integer;
    FSysFlag: integer;
    FUDFParams:PUDFParamsArray;
    FUDFParamCount:integer;
    procedure ClearUdfParams;
    function GetUDFParams(AItem: integer): TUDFParamsRecord;
    procedure InitUdfParams(ACnt:integer);
  protected
    procedure InternalSetDescription(ACommentOn: TSQLCommentOn);override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    procedure RefreshDependencies;override;
    procedure RefreshObject; override;
    class function DBClassTitle:string;override;
    procedure SetSqlAssistentData(const List: TStrings); override;
    function CompileUDF(const AUDFName, ALibName, AEntryPoint:string;
                              AResultType, AFuncType:integer):boolean;

    function UDFParamByPosition(APosition:integer):TUDFParamsRecord;
    property LibName:string read FLibName;
    property EntryPoint:string read FEntryPoint;
    property FunctionType:integer read FFunctionType;
    property ReturnArg:integer read FReturnArg;
    property SysFlag:integer read FSysFlag;
    property CountArgs:integer read FCountArgs;

    property UDFParamCount:integer read FUDFParamCount;
    property UDFParams[AItem:integer]:TUDFParamsRecord read GetUDFParams;
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

  { TFireBirdPackage }

  TFireBirdPackage = class(TDBObject)
  private
    FPackageBody: string;
    FPackageHeader: string;
    FValidBody: boolean;
  protected
    function InternalGetDDLCreate: string; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    class function DBClassTitle:string;override;

    function CreateSQLObject:TSQLCommandDDL;override;

    procedure RefreshObject; override;
    procedure RefreshDependencies;override;

    property PackageHeader:string read FPackageHeader write FPackageHeader;
    property PackageBody:string read FPackageBody write FPackageBody;
    property ValidBody:boolean read FValidBody;
  end;

  { TFireBirdFunction }

  TFireBirdFunction = class(TDBStoredProcObject)
  private
    FDeterministic: Boolean;
    FEngine: string;
    FExternalName: string;
    function GetRetunValue: TDBField;
  protected
    function InternalGetDDLCreate: string; override;
    procedure RefreshParams; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    class function DBClassTitle:string;override;

    function CreateSQLObject:TSQLCommandDDL;override;

    procedure RefreshObject; override;
    procedure RefreshDependencies;override;
    property FieldsIN;
    property RetunValue:TDBField read GetRetunValue;
    property Deterministic:Boolean read FDeterministic write FDeterministic;
    property ExternalName:string read FExternalName write FExternalName;
    property Engine:string read FEngine write FEngine;
  end;

  { TFBQueryControl }

  TFBQueryControl = class(TSQLQueryControl)
  private
    FBQuery:TFBDataSet;
    FFBTransaction: TUIBTransaction;
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
    constructor Create(AOwner:TSQLEngineAbstract); override;
    destructor Destroy; override;
    procedure CommitTransaction;override;
    procedure RolbackTransaction;override;
    procedure FetchAll;override;
    procedure Prepare;override;
    procedure ExecSQL;override;
    function ParseException(E:Exception; out X, Y:integer; out AMsg:string):boolean; override;
    function LoadStatistic(out StatRec:TQueryStatRecord; const SQLCommand:TSQLCommandAbstract):boolean; override;
  end;

  { TSQLEngineFireBird }

  TSQLEngineFireBird = class(TSQLEngineAbstract)
  private
    FAutoGrantObject: boolean;
    FBackupOptions: TFireBirdBackupOptions;
    FCharSet: string;
//    FCharSetList:TCharSetList;
    FDBCharSet: string;
    //Объявление груп объектов
    FDomainsRoot:TDomainsRoot;
    FIndexRoot: TFireBirdIndexRoot;
    FProtocol: TUIBProtocol;
    FRoleName: string;
    FRestoreOptions: TFireBirdRestoreOptions;
    FServerVersion: TFBServerVersion;
    FViewsRoot:TViewsRoot;
    FTriggersRoot:TTriggersRoot;
    FGeneratorsRoot:TGeneratorsRoot;
    FStoredProcRoot:TStoredProcRoot;
    FExceptionRoot:TExceptionRoot;
    FRoleRoot:TRoleRoot;

    FSystemCatalog:TFBSystemCatalog;
    //FB 3.0
    FPackagesRoot:TPackagesRoot;
    FFunctionsRoot:TFunctionsRoot;
    //
    FFBDatabase:TUIBDataBase;
    FFBTransaction: TUIBTransaction;
    FTranParamData:integer;
    FTranParamMetaData:integer;
    //
    FOnExecuteSqlScriptProcessEvent:TExecuteSqlScriptProcessEvent;
    procedure DoInitFBSqlEngine;
    function GetLiBraryName: TFileName;
    procedure LoadDBParams;
    procedure OnUIBSqlParse(Sender: TObject; NodeType: TSQLStatement; const Statement: string);
    //procedure SetLibraryName(AValue: TFileName);
  protected
    function GetImageIndex: integer;override;

    //procedure SetConnected(const AValue: boolean);override;
    function InternalSetConnected(const AValue: boolean):boolean; override;
    procedure InitGroupsObjects;override;
    procedure DoneGroupsObjects;override;

    function GetCharSet: string;override;
    procedure SetCharSet(const AValue: string);override;
    class function GetEngineName: string; override;
    procedure RefreshDependencies(const ADBObject:TDBObject);
    procedure InitKeywords;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Load(const AData: TDataSet);override;
    procedure Store(const AData: TDataSet);override;

    procedure RefreshObjectsBeginFull;override;
    procedure RefreshObjectsEndFull;override;
    procedure RefreshObjectsBegin(const ASQLText:string);override;

    function ExecuteSQLScript(const ASQL: string; OnExecuteSqlScriptProcessEvent:TExecuteSqlScriptProcessEvent):Boolean; override;
    procedure SetSqlAssistentData(const List: TStrings); override;
    procedure FillCharSetList(const List: TStrings); override;
    procedure FillCollationList(const ACharSet:string; const List: TStrings); override;
    function OpenDataSet(Sql:string; AOwner:TComponent):TDataSet;override;
    function ExecSQL(const Sql:string;const ExecParams:TSqlExecParams):boolean;override;
    procedure AssignDataBase(Query: TUIBQuery);
    function GetUIBQuery(aSQL:string):TUIBQuery;
    function SQLPlan(aDataSet:TDataSet):string;override;
    function GetQueryControl:TSQLQueryControl;override;
    function ConvertString20(AStr:string; ToLcl:boolean):string;

    //Работа с типами полей и с доменами
    procedure FillDomainsList(const Items:TStrings; const ClearItems:boolean);override;

//    property CharSetList:TCharSetList read FCharSetList;
    property RoleName:string read FRoleName write FRoleName;
    property CharSet:string read FCharSet write FCharSet;
    property ServerVersion:TFBServerVersion read FServerVersion write FServerVersion;
    property Protocol:TUIBProtocol read FProtocol write FProtocol;
    property BackupOptions:TFireBirdBackupOptions read FBackupOptions;
    property RestoreOptions:TFireBirdRestoreOptions read FRestoreOptions;
    property TranParamData:integer read FTranParamData write FTranParamData;
    property TranParamMetaData:integer read FTranParamMetaData write FTranParamMetaData;
    property AutoGrantObject:boolean read FAutoGrantObject write FAutoGrantObject;
    property LibraryName: TFileName read GetLiBraryName{ write SetLibraryName};

    property FBDatabase:TUIBDataBase read FFBDatabase;
    property FBTransaction: TUIBTransaction read FFBTransaction;
    property DomainsRoot:TDomainsRoot read FDomainsRoot;
    property TriggersRoot:TTriggersRoot read FTriggersRoot;
    property GeneratorsRoot:TGeneratorsRoot read FGeneratorsRoot;
    property StoredProcRoot:TStoredProcRoot read FStoredProcRoot;
    property ExceptionRoot:TExceptionRoot read FExceptionRoot;

    property RoleRoot:TRoleRoot read FRoleRoot;
    property ViewsRoot:TViewsRoot read FViewsRoot;
    property IndexRoot:TFireBirdIndexRoot read FIndexRoot;
  end;
  
implementation
uses ibmsqltextsunit, ibmSqlUtilsUnit, uiblib, rxdbutils, Controls, fbmStrConstUnit, LazUTF8, strutils,
  fbSqlTextUnit,
  fbmSQLTextCommonUnit         //Общие запросы для всех SQL серверов
  ;

function FBTrigTypeToTriggerType(AFBType:word):TTriggerTypes;
begin
  if (AFBType and $01) = 1 then Result:=[ttBefore]
  else Result := [ttAfter];

  if AFBType in [1, 17, 25, 113, 2, 18, 26, 114] then
    Result := Result + [ttInsert];

  if AFBType in [3, 17, 27, 113, 4, 18, 28, 114] then
    Result := Result + [ttUpdate];

  if AFBType in [5, 25, 27, 113, 6, 26, 28, 114] then
    Result := Result + [ttDelete];
end;

{ TFBSystemCatalog }

function TFBSystemCatalog.GetObjectType: string;
begin
  Result:='System catalog';
end;

constructor TFBSystemCatalog.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okScheme;
  State:=sdboVirtualObject;
  FSystemObject:=true;

  FSystemDomainsRoot := TSystemDomainsRoot.Create(AOwnerDB, TFireBirdDomain, sSystemDomains, Self);
  FSystemTablesRoot := TSystemTablesRoot.Create(AOwnerDB, TFireBirdTable, sSystemTables, Self);
  FSystemIndexRoot := TFireBirdSystemIndexRoot.Create(AOwnerDB, TFireBirdIndex, sSystemIndex, Self);
end;

{ TSystemDomainsRoot }

constructor TSystemDomainsRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  //FSystemObject:=true;
  //Caption:=sSystemDomains;
  //FDropCommandClass:=nil;
end;

{ TFireBirdFunction }

function TFireBirdFunction.GetRetunValue: TDBField;
begin
  if FFieldsOut.Count > 0 then
    Result:=FFieldsOut[0]
  else
    Result:=nil
end;

function TFireBirdFunction.InternalGetDDLCreate: string;
var
  FCmd: TFBSQLCreateFunction;
  F: TDBField;
  P: TSQLParserField;
begin
  FCmd:=TFBSQLCreateFunction.Create(nil);
  FCmd.Name:=Caption;
  FCmd.Body:=ProcedureBody;
  for F in FieldsIN do
  begin
    P:=FCmd.Params.AddParam('');
    F.SaveToSQLFieldItem(P);
    P.InReturn:=spvtInput;
  end;

  F:=RetunValue;
  if Assigned(F) then
  begin
    FCmd.ReturnType:=F.FieldTypeName;
    FCmd.ReturnCollate:=F.FieldCollateName;
  end;

  FCmd.ExternalName:=ExternalName;
  FCmd.Engine:=Engine;

  FCmd.Deterministic:=Deterministic;
  FCmd.Description:=Description;
  Result:=FCmd.AsSQL;
  FCmd.Free;
end;

procedure TFireBirdFunction.RefreshParams;
var
  IBQ: TUIBQuery;
  Item: TDBField;
begin
  inherited RefreshParams;
  FFieldsIN.Clear;
  FFieldsOut.Clear;

  IBQ:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(fbSqlModule.sFunctionArgs.Strings.Text);
  IBQ.Params.ByNameAsString['FUNCTION_NAME']:=Caption;
  try
    IBQ.Open;
    while not IBQ.Eof do
    begin
      if IBQ.Fields.ByNameAsInteger['RDB$ARGUMENT_POSITION'] > 0 then
      begin
        Item:=FieldsIN.Add(Trim(IBQ.Fields.ByNameAsString['RDB$ARGUMENT_NAME']));
        Item.IOType:=spvtInput;
      end
      else
      begin
        Item:=FieldsOut.Add(Trim(IBQ.Fields.ByNameAsString['RDB$ARGUMENT_NAME']));
        Item.IOType:=spvtOutput;
      end;

      Item.FieldDescription:=IBQ.Fields.ByNameAsString['RDB$DESCRIPTION'];
      Item.FieldTypeDomain:=Trim(IBQ.Fields.ByNameAsString['RDB$FIELD_SOURCE']);
      Item.FieldSQLTypeInt:=IBQ.Fields.ByNameAsInteger['RDB$FIELD_TYPE'];
      Item.FieldSQLSubTypeInt:=IBQ.Fields.ByNameAsInteger['RDB$FIELD_SUB_TYPE'];
      Item.FieldTypeName:=FB_SqlTypesToString(Item.FieldSQLTypeInt,  Item.FieldSQLSubTypeInt);
      Item.FieldSize:=IBQ.Fields.ByNameAsInteger['RDB$FIELD_PRECISION'];
      Item.FieldPrec:= - IBQ.Fields.ByNameAsInteger['RDB$FIELD_SCALE'];

      if Item.FieldTypeRecord.VarLen and (IBQ.Fields.ByNameAsInteger['RDB$CHARACTER_LENGTH'] > 1) then
        Item.FieldSize:=IBQ.Fields.ByNameAsInteger['RDB$CHARACTER_LENGTH'];
      IBQ.Next;
    end;

  finally
    IBQ.Free;
  end;
end;

constructor TFireBirdFunction.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);

  FACLList:=TFBACLList.Create(Self);
  FACLList.ObjectGrants:=[ogExecute];
end;

class function TFireBirdFunction.DBClassTitle: string;
begin
  Result:='FUNCTION';
end;

function TFireBirdFunction.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=TFBSQLCreateFunction.Create(nil);
  Result.Name:=Caption;
  if State = sdboEdit then
    TFBSQLCreateFunction(Result).CreateMode:=cmCreateOrAlter;
end;

procedure TFireBirdFunction.RefreshObject;
var
  IBQ: TUIBQuery;
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;

  IBQ:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(fbSqlModule.sFunction.Strings.Text);
  IBQ.Params.ByNameAsString['FUNCTION_NAME']:=Caption;
  try
    IBQ.Open;
    //RDB$PACKAGES.RDB$PACKAGE_NAME,
    FDescription:=IBQ.Fields.ByNameAsString['RDB$DESCRIPTION'];
    FProcedureBody:=IBQ.Fields.ByNameAsString['RDB$FUNCTION_SOURCE'];
    FDeterministic:=IBQ.Fields.ByNameAsInteger['RDB$DETERMINISTIC_FLAG']<>0;
    FExternalName:=IBQ.Fields.ByNameAsString['RDB$MODULE_NAME'];
    FEngine:=IBQ.Fields.ByNameAsString['RDB$ENGINE_NAME'];
    (*
    RDB$FUNCTIONS.RDB$FUNCTION_NAME,
    RDB$FUNCTIONS.RDB$FUNCTION_TYPE,
    RDB$FUNCTIONS.RDB$QUERY_NAME,
    RDB$FUNCTIONS.RDB$MODULE_NAME,
    RDB$FUNCTIONS.RDB$ENTRYPOINT,
    RDB$FUNCTIONS.RDB$RETURN_ARGUMENT,
    RDB$FUNCTIONS.RDB$SYSTEM_FLAG,
    RDB$FUNCTIONS.RDB$PACKAGE_NAME,
    RDB$FUNCTIONS.RDB$PRIVATE_FLAG,
    RDB$FUNCTIONS.RDB$FUNCTION_SOURCE,
    RDB$FUNCTIONS.RDB$FUNCTION_ID,
    RDB$FUNCTIONS.RDB$FUNCTION_BLR,
    RDB$FUNCTIONS.RDB$VALID_BLR,
    RDB$FUNCTIONS.RDB$DEBUG_INFO,
    RDB$FUNCTIONS.RDB$SECURITY_CLASS,
    RDB$FUNCTIONS.RDB$OWNER_NAME,
    RDB$FUNCTIONS.RDB$LEGACY_FLAG, *)

  finally
    IBQ.Free;
  end;
  RefreshParams;
end;

procedure TFireBirdFunction.RefreshDependencies;
begin
  TSQLEngineFireBird(OwnerDB).RefreshDependencies(Self);
end;

{ TFireBirdPackage }

function TFireBirdPackage.InternalGetDDLCreate: string;
var
  FCmd, FCmd1: TFBSQLCreatePackage;
begin
  FCmd:=TFBSQLCreatePackage.Create(nil);
  FCmd.CreateMode:=cmCreateOrAlter;
  FCmd.Description:=Description;
  FCmd.Name:=Caption;
  FCmd.PackageText:=PackageHeader;
  FCmd1:=TFBSQLCreatePackage.Create(nil);
  FCmd.AddChild(FCmd1);
  FCmd1.CreateMode:=cmCreateOrAlter;
  FCmd1.Name:=Caption;
  FCmd1.ObjectKind:=okPackageBody;
  FCmd1.PackageText:=PackageBody;
  Result:=FCmd.AsSQL;
  FCmd.Free;
end;

constructor TFireBirdPackage.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);

  FACLList:=TFBACLList.Create(Self);
  FACLList.ObjectGrants:=[ogExecute];
end;

class function TFireBirdPackage.DBClassTitle: string;
begin
  Result:='PACKAGE';
end;

function TFireBirdPackage.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=TFBSQLCreatePackage.Create(nil);
  Result.Name:=Caption;

  if State <> sdboCreate then
     TFBSQLCreatePackage(Result).CreateMode:=cmCreateOrAlter;
end;

procedure TFireBirdPackage.RefreshObject;

procedure FillProcList;
begin

end;

var
  IBQ: TUIBQuery;
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;

  IBQ:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(fbSqlModule.sPackage.Strings.Text);
  IBQ.Params.ByNameAsString['PACKAGE_NAME']:=Caption;
  try
    IBQ.Open;
    //RDB$PACKAGES.RDB$PACKAGE_NAME,
    FDescription:=IBQ.Fields.ByNameAsString['RDB$DESCRIPTION'];
    FPackageHeader:=IBQ.Fields.ByNameAsString['RDB$PACKAGE_HEADER_SOURCE'];
    FPackageBody:=IBQ.Fields.ByNameAsString['RDB$PACKAGE_BODY_SOURCE'];
    FValidBody:=IBQ.Fields.ByNameAsInteger['RDB$VALID_BODY_FLAG'] = 1;
(*
  RDB$PACKAGES.RDB$SECURITY_CLASS,
  RDB$PACKAGES.RDB$OWNER_NAME,
  RDB$PACKAGES.RDB$SYSTEM_FLAG, *)
  finally
    IBQ.Free;
  end;

  if FPackageHeader<>'' then
    FillProcList;
end;

procedure TFireBirdPackage.RefreshDependencies;
begin
  TSQLEngineFireBird(OwnerDB).RefreshDependencies(Self);
end;

{ TFunctionsRoot }

function TFunctionsRoot.DBMSObjectsList: string;
begin
  Result:=fbSqlModule.sFunctions.Strings.Text;
end;

function TFunctionsRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.ObjType2 = 2);
end;

function TFunctionsRoot.GetObjectType: string;
begin
  Result:='Functions';
end;

constructor TFunctionsRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okFunction;
  FDropCommandClass:=TFBSQLDropFunction;
end;

{ TPackagesRoot }

function TPackagesRoot.DBMSObjectsList: string;
begin
  Result:=fbSqlModule.sPackages.Strings.Text;
end;

function TPackagesRoot.GetObjectType: string;
begin
  Result:='PACKAGE';
end;

constructor TPackagesRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okPackage;
  FDropCommandClass:=TFBSQLDropPackage;
end;

{ TFireBirdSystemIndexRoot }

constructor TFireBirdSystemIndexRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  //FSystemObject:=true;
  //FDropCommandClass:=nil;
end;

{ TFireBirdIndex }

function TFireBirdIndex.InternalGetDDLCreate: string;
var
  FCmd: TFBSQLCreateIndex;
  ifld: TIndexField;
begin
  FCmd:=TFBSQLCreateIndex.Create(nil);
  FCmd.Name:=Caption;
  FCmd.Active:=IndexActive;
  FCmd.Unique:=IndexUnique;
{
  if RadioGroup1.ItemIndex = 0 then
    TFBSQLCreateIndex(ASQLObject).SortOrder:=indAscending
  else
    TFBSQLCreateIndex(ASQLObject).SortOrder:=indDescending;}
  if Assigned(Table) then
    FCmd.TableName:=Table.Caption;
  if IndexExpression <> '' then
    FCmd.IndexExpression:=IndexExpression
  else
  begin
    for ifld in IndexFields do
      FCmd.Fields.AddParam(ifld.FieldName);
  end;
  Result:=FCmd.AsSQL;
  FCmd.Free;
end;

constructor TFireBirdIndex.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
    FIndexID:=ADBItem.ObjId;
end;

destructor TFireBirdIndex.Destroy;
begin
  inherited Destroy;
end;

class function TFireBirdIndex.DBClassTitle: string;
begin
  Result:='INDEX';
end;

procedure TFireBirdIndex.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;

procedure TFireBirdIndex.RefreshObject;

procedure RefreshIndexFields;
var
  IBQ: TUIBQuery;
  PGIF: TIndexField;
begin
  IBQ:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(fbSqlModule.sFBIndexSegs.ExpandMacros);
  IBQ.Params.ByNameAsString['INDEX_NAME']:=Caption;
  try
    IBQ.Open;
    while not IBQ.Eof do
    begin
      PGIF:=IndexFields.Add(TrimRight(IBQ.Fields['RDB$FIELD_NAME']));
      IBQ.Next;
    end;
  finally
    IBQ.Free;
  end;
end;

var
  IBQ: TUIBQuery;
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;
  IndexFields.Clear;

  IBQ:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(fbSqlModule.sFBIndex.ExpandMacros);
  IBQ.Params.ByNameAsString['index_name']:=Caption;
  try
    IBQ.Open;
    Table:=OwnerDB.TablesRoot.ObjByName(Trim(IBQ.Fields.ByNameAsString['RDB$RELATION_NAME'])) as TDBTableObject;
    FIndexID:=IBQ.Fields.ByNameAsInteger['RDB$INDEX_ID'];
    FDescription:=TrimRight(IBQ.Fields.ByNameAsString['RDB$DESCRIPTION']);
    FIndexUnique:=IBQ.Fields.ByNameAsInteger['RDB$UNIQUE_FLAG'] <> 0;
    FIndexActive:=IBQ.Fields.ByNameAsInteger['RDB$INDEX_INACTIVE'] = 0;

    if IBQ.Fields.ByNameAsInteger['RDB$INDEX_TYPE'] = 1 then
      FIndexSortOrder:=indDescending
    else
      FIndexSortOrder:=indAscending;
    FIndexExpression:=IBQ.Fields.ByNameAsString['RDB$EXPRESSION_SOURCE'];

{
  RDB$INDICES.RDB$SEGMENT_COUNT,
    RDB$INDICES.RDB$FOREIGN_KEY,
    RDB$INDICES.RDB$SYSTEM_FLAG,
    RDB$INDICES.RDB$STATISTICS
}
  finally
    IBQ.Free;
  end;

  RefreshIndexFields;
end;

procedure TFireBirdIndex.RefreshDependencies;
begin
  inherited RefreshDependencies;
end;

procedure TFireBirdIndex.RefreshDependenciesField(Rec: TDependRecord);
begin
  inherited RefreshDependenciesField(Rec);
end;

function TFireBirdIndex.CreateSQLObject: TSQLCommandDDL;
begin
  if State = sdboCreate then
    Result:=TFBSQLCreateIndex.Create(nil)
  else
    Result:=TFBSQLAlterIndex.Create(nil);
end;

{ TFireBirdIndexRoot }

function TFireBirdIndexRoot.DBMSObjectsList: string;
begin
  Result:=fbSqlModule.sFBIndexs.Strings.Text;
end;

function TFireBirdIndexRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.ObjType2 = Ord(FSystemObject));
end;

function TFireBirdIndexRoot.GetObjectType: string;
begin
  if FSystemObject then
    Result:='System Index'
  else
    Result:='Index';
end;

constructor TFireBirdIndexRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okIndex;
  FDropCommandClass:=TFBSQLDropIndex;
end;

{ TFBACLItem }

function TFBACLItem.ObjectTypeName: string;
begin
  case Owner.DBObject.DBObjectKind of
    okStoredProc:Result:='PROCEDURE';
    okSequence:Result:='SEQUENCE';
    okView:Result:='';
//    okFunction:Result:='FUNCTION';
  else
    //Result:='';
    Result:= inherited ObjectTypeName;
  end;
end;

{ TFBACLList }

function TFBACLList.InternalCreateACLItem: TACLItem;
begin
  Result:=TFBACLItem.Create(DBObject, Self);
end;

function TFBACLList.InternalCreateGrantObject: TSQLCommandGrant;
begin
  Result:=TFBSQLGrant.Create(nil);
end;

function TFBACLList.InternalCreateRevokeObject: TSQLCommandGrant;
begin
  Result:=TFBSQLRevoke.Create(nil);
end;

procedure TFBACLList.LoadUserAndGroups;
var
  i:integer;
  UIBSec:TUIBSecurity;
  P: TACLItem;
begin
  //Fill roles list
  for i:=0 to  TSQLEngineFireBird(SQLEngine).RoleRoot.CountObject - 1 do
  begin
    P:=Add;
    P.UserType:=2;
    P.UserName:=TSQLEngineFireBird(SQLEngine).RoleRoot.Items[i].Caption;
  end;

  //Fill users list
  UIBSec:=TUIBSecurity.Create(nil);
  try
    UIBSec.Protocol:=proTCPIP; //!!! //TSQLEngineFireBird(SQLEngine).FFBDatabase.Proptocol;
    UIBSec.UserName:=TSQLEngineFireBird(SQLEngine).UserName;
    UIBSec.PassWord:=TSQLEngineFireBird(SQLEngine).Password;
    UIBSec.Host:=TSQLEngineFireBird(SQLEngine).ServerName;
    UIBSec.DisplayUsers;
    for i:=0 to UIBSec.UserInfoCount-1 do
    begin
      P:=Add;
      P.UserType:=1;
      P.UserName:=UIBSec.UserInfo[i].UserName;
    end;
  finally
    UIBSec.Free;
  end;
end;

procedure TFBACLList.RefreshList;
var
  IBQ:TUIBQuery;
  S: String;
  P: TACLItem;
begin
  Clear;
  LoadUserAndGroups;

  IBQ:=TSQLEngineFireBird(SQLEngine).GetUIBQuery(fbSqlModule.sSqlGrantForObj.ExpandMacros);
  IBQ.Params.ByNameAsString['obj_name']:=DBObject.Caption;
  try
    IBQ.Open;
    while not IBQ.Eof do
    begin
      S:=Trim(IBQ.Fields.ByNameAsString['rdb$user']);
      P:=FindACLItem(S);
      if not Assigned(P) then
      begin
        P:=Add;
        P.UserType:=1;
        P.UserName:=IBQ.Fields.ByNameAsString['rdb$user'];
      end;

      S:=Trim(IBQ.Fields.ByNameAsString['rdb$privilege']);
      if S<>'' then
      begin
        case S[1] of
          'S':P.Grants:=P.Grants + [ogSelect];      //SELECT ("read")
          'U':P.Grants:=P.Grants + [ogUpdate];      //UPDATE ("write")
          'I':P.Grants:=P.Grants + [ogInsert];      //INSERT ("append")
          'D':P.Grants:=P.Grants + [ogDelete];      //DELETE
          'R':P.Grants:=P.Grants + [ogReference];  //REFERENCES
          'X':P.Grants:=P.Grants + [ogExecute];     //X -- EXECUTE
          'G':P.Grants:=P.Grants + [ogUsage];       //G – usage (использование);
          'M':P.Grants:=P.Grants + [ogMembership];       //M – membership (членство).
        else
          raise Exception.CreateFmt('Неизвестный тип права %s', [S]);
        end;

        if IBQ.Fields.ByNameAsInteger['RDB$GRANT_OPTION'] = 1 then
          P.Grants:=P.Grants + [ogWGO];
      end;
      IBQ.Next;
    end;
    IBQ.Close;
  finally
    IBQ.Free;
  end;

  for P in Self do
    P.FillOldValues;
end;

{ TSQLEngineFireBird }

function TSQLEngineFireBird.GetUIBQuery(aSQL: string): TUIBQuery;
begin
  Result:=TUIBQuery.Create(nil);
  Result.FetchBlobs:=true;
  Result.CachedFetch:=true;
  Result.Database:=FBDatabase;
  Result.Transaction:=FBTransaction;
  Result.Sql.Text:=aSQL;
end;

procedure TSQLEngineFireBird.DoInitFBSqlEngine;
begin
  InitKeywords;

  //Создадим объекты группы
  FRestoreOptions:=TFireBirdRestoreOptions.Create;
  FBackupOptions:=TFireBirdBackupOptions.Create;

  FFBDatabase:=TUIBDataBase.Create(nil);
{$IFDEF WINDOWS}
  FFBDatabase.LibraryName:=GetDefaultFB3Lib;
{$ENDIF}
  FFBTransaction:=TUIBTransaction.Create(nil);
  FFBTransaction.DataBase:=FBDatabase;
  FBTransaction.Options:=IndexToTransaction(FTranParamMetaData);

  FUIParams:=[upSqlEditor, upUserName, upPassword, upLocal, upRemote];

  FillFieldTypes(FTypeList);
  FSQLEngineCapability:=[okDomain, okTable, okView, okTrigger, okStoredProc,
                   okSequence, okException, okUDF, okUser, okRole, okIndex,
                   okCheckConstraint, okForeignKey, okPrimaryKey,
                   okUniqueConstraint];
  MiscOptions.ObjectNamesCharCase:=ccoUpperCase;
  RemotePort:=FireBirdDefTCPPort;
end;

function TSQLEngineFireBird.GetLiBraryName: TFileName;
begin
  Result:=FBDatabase.LibraryName;
end;

procedure TSQLEngineFireBird.LoadDBParams;
var
  IBQ:TUIBQuery;

  function DBCharSetToIncov(ACharSet: string):string;
  begin
    Result:='';
    if Length(ACharSet)>3 then
    begin
      if (Copy(ACharSet, 1, 3) = 'WIN') and (ACharSet[4] in ['0'..'9']) then
        Result:='WINDOWS-' + Copy(ACharSet, 4, Length(ACharSet))
      else
        Result:=ACharSet;
    end;
  end;

begin
  IBQ:=GetUIBQuery(ssqlDBSelectParams);
  try
    IBQ.Open;
    FDBCharSet:=Trim(IBQ.Fields.ByNameAsString['rdb$character_set_name']);
  finally
    IBQ.Free;
  end;
  FDBCharSet:=DBCharSetToIncov(FDBCharSet);
end;

procedure TSQLEngineFireBird.OnUIBSqlParse(Sender: TObject;
  NodeType: TSQLStatement; const Statement: string);
begin
  if Assigned(FOnExecuteSqlScriptProcessEvent) then
    if not FOnExecuteSqlScriptProcessEvent(Statement, -1, stNone) then
      abort;
end;

(*
procedure TSQLEngineFireBird.SetLibraryName(AValue: TFileName);
begin
  if (AValue <> '') and (FBDatabase.LibraryName <> AValue) then
    FBDatabase.LibraryName:=AValue;
end;
*)
function TSQLEngineFireBird.GetImageIndex: integer;
begin
  if Connected then
    Result:=17
  else
    Result:=16;
end;

function TSQLEngineFireBird.InternalSetConnected(const AValue: boolean
  ): boolean;
var
  S: String;
begin
  if AValue then
  begin
    S:=ServerName;
    if RemotePort <> FireBirdDefTCPPort then
      S:=S + '/'+IntToStr(RemotePort);
    S:=S +':'+DataBaseName;
    FBDatabase.DatabaseName:=S;
    FBDatabase.UserName:=UserName;
    FBDatabase.PassWord:=Password;
    FBDatabase.Role:=FRoleName;

    if FServerVersion < gds_verFirebird2_0 then
      FBDatabase.CharacterSet:=csUNICODE_FSS
    else
      FBDatabase.CharacterSet:=csUTF8 ;

    FBDatabase.Connected:=true;
    FBTransaction.Options:=IndexToTransaction(FTranParamMetaData);
    FBTransaction.StartTransaction;
//    FCharSetList:=BuildCharSetList(GetUIBQuery(''));
    LoadDBParams;
    //InitKeywords;
  end;

  //inherited SetConnected(AValue);

  if not AValue then
  begin
    FBTransaction.Commit;
    FBDatabase.Connected:=false;
//    FreeAndNil(FCharSetList);
  end;
  Result:=FBDatabase.Connected;
end;

procedure TSQLEngineFireBird.InitGroupsObjects;
var
  G:TDBRootObject;
begin
  AddObjectsGroup(FDomainsRoot, TDomainsRoot, TFireBirdDomain, sDomains);
  AddObjectsGroup(FTablesRoot, TTablesRoot, TFireBirdTable, sTables);
  AddObjectsGroup(FViewsRoot, TViewsRoot, TFireBirdView, sViews);
  AddObjectsGroup(FTriggersRoot, TTriggersRoot, TFireBirdTriger, sTriggers);
  AddObjectsGroup(FGeneratorsRoot,TGeneratorsRoot, TFireBirdGenerator, sGenerators);
  AddObjectsGroup(FStoredProcRoot, TStoredProcRoot, TFireBirdStoredProc, sStoredProcedures);
  AddObjectsGroup(FExceptionRoot, TExceptionRoot, TFireBirdException, sExceptions);
  AddObjectsGroup(G, TUDFRoot, TFireBirdUDF, sUDFs);
  AddObjectsGroup(FRoleRoot, TRoleRoot, TFireBirdRole, sRoles);
  AddObjectsGroup(FIndexRoot, TFireBirdIndexRoot, TFireBirdIndex, sIndexs);

  if FServerVersion in [gds_verFirebird3_0] then
  begin
    AddObjectsGroup(FPackagesRoot, TPackagesRoot, TFireBirdPackage, sPackages);
    AddObjectsGroup(FFunctionsRoot, TFunctionsRoot, TFireBirdFunction, sFunctions);
  end;

  if ussSystemTable in UIShowSysObjects then
    AddObjectsGroup(FSystemCatalog, TFBSystemCatalog, nil, sSystemCatalog);
end;

procedure TSQLEngineFireBird.DoneGroupsObjects;
begin
  FViewsRoot:=nil;
  FRoleRoot:=nil;
  FExceptionRoot:=nil;
  FStoredProcRoot:=nil;
  FGeneratorsRoot:=nil;
  FTriggersRoot:=nil;
  FTablesRoot:=nil;
  FDomainsRoot:=nil;
  FIndexRoot:=nil;
  FPackagesRoot:=nil;
  FFunctionsRoot:=nil;

  FSystemCatalog:=nil;
end;

function TSQLEngineFireBird.GetCharSet: string;
begin
  Result:=FCharSet; //CharacterSetStr[FBDatabase.CharacterSet];
end;

procedure TSQLEngineFireBird.SetCharSet(const AValue: string);
begin
  FCharSet:=AValue;
end;

class function TSQLEngineFireBird.GetEngineName: string;
begin
  Result:='FireBird SQL Server';
end;

procedure TSQLEngineFireBird.RefreshDependencies(const ADBObject: TDBObject);
var
  IBQ:TUIBQuery;
  Rec:TDependRecord;
begin
  ADBObject.DependList.Clear;
  if ADBObject.State = sdboEdit then
  begin
    IBQ:=GetUIBQuery(ssqlSelectDependencies);
    IBQ.Params.ByNameAsAnsiString['DEPENDED_ON_NAME']:=ADBObject.Caption;
    try
      IBQ.Open;
      while not IBQ.Eof do
      begin
        Rec:=TDependRecord.Create;
        ADBObject.DependList.Add(Rec);
//        Rec.FieldList:TStringList;
        Rec.DependType:=0;//0 - зависит от текущего, 1 - текущий от чего-то
        { TODO : Тут необходимо правильно мапировать тип объекта }
//        Rec.ObjectKind:=IBQ.Fields.ByNameAsInteger['RDB$DEPENDENT_TYPE'];
        Rec.ObjectName:=Trim(IBQ.Fields.ByNameAsString['RDB$DEPENDENT_NAME']);
        IBQ.Next;
      end;
    finally
      IBQ.Free;
    end;

    IBQ:=GetUIBQuery(ssqlSelectDependenciesOn);
    IBQ.Params.ByNameAsAnsiString['DEPENDED_ON_NAME']:=ADBObject.Caption;
    try
      IBQ.Open;
      while not IBQ.Eof do
      begin
        Rec:=TDependRecord.Create;
        ADBObject.DependList.Add(Rec);
        Rec.DependType:=1;//0 - зависит от текущего, 1 - текущий от чего-то
        { TODO : Тут необходимо правильно мапировать тип объекта }
//        Rec.ObjectKind:=IBQ.Fields.ByNameAsInteger['RDB$DEPENDED_ON_TYPE'];
        Rec.ObjectName:=Trim(IBQ.Fields.ByNameAsString['RDB$DEPENDED_ON_NAME']);
        IBQ.Next;
      end;
    finally
      IBQ.Free;
    end;
  end;
end;

procedure TSQLEngineFireBird.InitKeywords;
begin
  KeywordsList.Clear;
  FKeyFunctions:=CreateFBKeyFunctions;
  FKeywords:=CreateFBKeyWords;
  FKeyTypes:=CreateFBKeyTypes;

  KeywordsList.Add(FKeywords);
  KeywordsList.Add(FKeyFunctions);
  KeywordsList.Add(FKeyTypes);
end;

constructor TSQLEngineFireBird.Create;
begin
  inherited Create;
  FSQLCommentOnClass:=TFBSQLCommentOn;
  FSQLEngileFeatures:=[feDescribeObject, fePKAutoName, feComputedTableFields, feFieldDepsList, feArrayFields];

  DoInitFBSqlEngine;
end;

destructor TSQLEngineFireBird.Destroy;
begin
  FreeAndNil(FFBDatabase);
  FreeAndNil(FFBTransaction);
  FreeAndNil(FRestoreOptions);
  FreeAndNil(FBackupOptions);
  inherited Destroy;
end;

procedure TSQLEngineFireBird.Load(const AData: TDataSet);
begin
  inherited Load(AData);
  FRoleName:=AData.FieldByName('db_database_user_role').AsString;
  FCharSet:=AData.FieldByName('db_database_connected_charset').AsString;
  FServerVersion:=TFBServerVersion(AData.FieldByName('db_database_server_version').AsInteger);
  FAutoGrantObject:=AData.FieldByName('db_database_auto_grant').AsBoolean;
  //LibraryName:=AData.FieldByName('db_database_library_name').AsString;
  FProtocol:= StrToUIBProtocol(AData.FieldByName('db_database_authentication_type').AsString);

  FTranParamData:=1;
  FTranParamMetaData:=1;

end;

procedure TSQLEngineFireBird.Store(const AData: TDataSet);
begin
  inherited Store(AData);
  AData.FieldByName('db_database_user_role').AsString:=FRoleName;
  AData.FieldByName('db_database_connected_charset').AsString:=FCharSet;
  AData.FieldByName('db_database_server_version').AsInteger:=Ord(FServerVersion);
  AData.FieldByName('db_database_auto_grant').AsBoolean:=FAutoGrantObject;
  //AData.FieldByName('db_database_library_name').AsString:=LibraryName;
  AData.FieldByName('db_database_authentication_type').AsString:=UIBProtocolToStr(FProtocol);
end;

procedure TSQLEngineFireBird.RefreshObjectsBeginFull;
begin
  RefreshObjectsBegin(fbSqlModule.sqlDomains.Strings.Text);
  RefreshObjectsBegin(fbSqlModule.ssqlSelectTables.Strings.Text);
  if ServerVersion in [gds_verFirebird3_0] then
  begin
    RefreshObjectsBegin(fbSqlModule.sFunctions.Strings.Text);
  end;
end;

procedure TSQLEngineFireBird.RefreshObjectsEndFull;
begin
  RefreshObjectsEnd(fbSqlModule.sqlDomains.Strings.Text);
  RefreshObjectsEnd(fbSqlModule.ssqlSelectTables.Strings.Text);
  if ServerVersion in [gds_verFirebird3_0] then
  begin
    RefreshObjectsEnd(fbSqlModule.sFunctions.Strings.Text);
  end;
end;

procedure TSQLEngineFireBird.RefreshObjectsBegin(const ASQLText: string);
var
  DBObj: TDBItems;
  FQuery: TUIBQuery;
  P: TDBItem;
  i: Word;
begin
  DBObj:=FCashedItems.AddTypes(ASQLText);
  if DBObj.CountUse = 1 then
  begin
    FQuery:=GetUIBQuery(ASQLText);
    FQuery.Open;
    while not FQuery.Eof do
    begin
      P:=DBObj.Add(Trim(FQuery.Fields.AsString[0]));

      if FQuery.Fields.FieldCount > 1 then
        P.ObjDesc:=TrimRight(FQuery.Fields.AsString[1]);

      if FQuery.Fields.TryGetFieldIndex('relation_name', i) then
        P.ObjRelName:=Trim(FQuery.Fields.AsString[i]);
      if FQuery.Fields.TryGetFieldIndex('data', i) then
        P.ObjData:=Trim(FQuery.Fields.AsString[i]);
      if FQuery.Fields.TryGetFieldIndex('SYSTEM_FLAG', i) then
        P.ObjType2:=FQuery.Fields.AsInteger[i]
      else
      if FQuery.Fields.TryGetFieldIndex('type', i) then
        P.ObjType2:=FQuery.Fields.AsInteger[i]
      else
      if FQuery.Fields.TryGetFieldIndex('object_id', i) then
        P.ObjId:=FQuery.Fields.AsInteger[i];
      FQuery.Next;
    end;
    FQuery.Close;
    FreeAndNil(FQuery);
  end;
end;

function TSQLEngineFireBird.ExecuteSQLScript(const ASQL: string;
  OnExecuteSqlScriptProcessEvent: TExecuteSqlScriptProcessEvent): Boolean;
var
  USql:TUIBScript;
  SqlTran:TUIBTransaction;
begin
  Result:=true;
  FOnExecuteSqlScriptProcessEvent:=OnExecuteSqlScriptProcessEvent;
  SqlTran:=TUIBTransaction.Create(nil);
  SqlTran.DataBase:=FFBDatabase;
  USql:=TUIBScript.Create(nil);
  try
    USql.Script.Text:=ASQL;
    USql.OnParse:=@OnUIBSqlParse;
    USql.Database:=FFBDatabase;
    USql.Transaction:=SqlTran;
    SqlTran.StartTransaction;
    USql.ExecuteScript;

    if SqlTran.InTransaction then
      SqlTran.Commit;
  except
    on E:Exception do
    begin
      InternalError(E.Message);
      if SqlTran.InTransaction then
        SqlTran.RollBack;
      Result:=false;
    end;
  end;
  USql.Free;
  SqlTran.Free;
  FOnExecuteSqlScriptProcessEvent:=nil;
end;

procedure TSQLEngineFireBird.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
  List.Add(sClientLib + FBDatabase.LibraryName);
  List.Add(sRoleName + FRoleName);
  if Connected then
  begin
    try
      List.Add('-------------------------');
      List.Add(sDialect + IntToStr(FBDatabase.SQLDialect));
      List.Add(sServerVersion + FBDatabase.InfoVersion);
      List.Add(sDBCharset     + FDBCharSet);
      List.Add(sODSVersion + IntToStr(FBDatabase.InfoOdsVersion)+'.'+IntToStr(FBDatabase.InfoOdsMinorVersion));

      List.Add(sPageSize + IntToStr(FBDatabase.InfoPageSize));
      List.Add(sPageCount + IntToStr(FBDatabase.InfoDbSizeInPages));
      List.Add(sDBFileSize);
    finally
    end;
  end
end;

procedure TSQLEngineFireBird.FillCharSetList(const List: TStrings);
var
  IBQ: TUIBQuery;
begin
  if not FBDatabase.Connected then exit;
  IBQ:=GetUIBQuery(fbSqlModule.ssqlCharSetList.ExpandMacros);
  IBQ.Open;
  while not IBQ.Eof do
  begin
    List.Add(Trim(IBQ.Fields.ByNameAsString['RDB$CHARACTER_SET_NAME']));
    IBQ.Next;
  end;
  IBQ.Close;
  IBQ.Free;
end;

procedure TSQLEngineFireBird.FillCollationList(const ACharSet: string;
  const List: TStrings);
var
  IBQ: TUIBQuery;
begin
  IBQ:=GetUIBQuery(fbSqlModule.ssqlCollationsList.ExpandMacros);
  IBQ.Params.ByNameAsString['CHARACTER_SET_NAME']:=ACharSet;
  IBQ.Open;
  while not IBQ.Eof do
  begin
    List.Add(Trim(IBQ.Fields.ByNameAsString['RDB$COLLATION_NAME']));
    IBQ.Next;
  end;
  IBQ.Close;
  IBQ.Free;
end;

function TSQLEngineFireBird.OpenDataSet(Sql: string; AOwner:TComponent): TDataSet;
begin
  Result:=TFBDataSet.Create(AOwner);
  TFBDataSet(Result).DataBase:=FBDatabase;
  TFBDataSet(Result).Transaction:=FBTransaction;
  TFBDataSet(Result).SQLSelect.Text:=Sql;
  Result.Active:=true;
end;

function TSQLEngineFireBird.ExecSQL(const Sql:string;const ExecParams:TSqlExecParams):boolean;
var
  MetaTransaction:TUIBTransaction;
  Qry:TUIBQuery;
begin
  Result:=true;
  MetaTransaction:=TUIBTransaction.Create(nil);
  Qry:=TUIBQuery.Create(nil);
  MetaTransaction.DataBase:=FFBDatabase;
  Qry.DataBase:=FFBDatabase;
  Qry.Transaction:=MetaTransaction;
  MetaTransaction.StartTransaction;
  try
    Qry.Sql.Text:=SQL;
    Qry.ExecSQL;
    MetaTransaction.Commit;
  except
    on E:Exception do
    begin
      MetaTransaction.RollBack;
      InternalError(E.Message);
      Result:=false;
    end;
  end;
  Qry.Free;
  MetaTransaction.Free;
end;

procedure TSQLEngineFireBird.AssignDataBase(Query: TUIBQuery);
begin
  Query.DataBase:=FBDatabase;
  Query.Transaction:=FBTransaction;
end;

function TSQLEngineFireBird.SQLPlan(aDataSet: TDataSet): string;
begin
  if Assigned(aDataSet) then
    (aDataSet as TFBDataSet).QuerySelect.Plan
  else
    Result:='';
end;

function TSQLEngineFireBird.GetQueryControl: TSQLQueryControl;
begin
  Result:=TFBQueryControl.Create(Self);
end;

function TSQLEngineFireBird.ConvertString20(AStr:string; ToLcl: boolean): string;
begin
//  if ServerVersion in [gds_verFirebird2_1, gds_verFirebird2_5] then
    Result:=AStr
(*  else
  begin
    if ToLcl then
      Result:=DBCharsetToUtf8(AStr, FDBCharSet)
    else
      Result:=DBCharsetFromUtf8(AStr, FDBCharSet);
  end; *)
end;

procedure TSQLEngineFireBird.FillDomainsList(const Items: TStrings; const ClearItems:boolean);
begin
  DomainsRoot.FillListForNames(Items, false);
end;


{ TTablesRoot }

function TTablesRoot.DBMSObjectsList: string;
begin
  Result:=fbSqlModule.ssqlSelectTables.Strings.Text;
end;

function TTablesRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.ObjType2 = Ord(FSystemObject));
end;

function TTablesRoot.GetObjectType: string;
begin
  if FSystemObject then
    Result:='System table'
  else
    Result:='Table';
end;

constructor TTablesRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okTable;
  FDropCommandClass:=TFBSQLDropTable;
end;

{ TDomainsRoot }

function TDomainsRoot.GetObjectType: string;
begin
  Result:='Domain';
end;

function TDomainsRoot.DBMSObjectsList: string;
begin
  Result:=fbSqlModule.sqlDomains.Strings.Text;
end;

function TDomainsRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.ObjType2 = Ord(FSystemObject));
end;

constructor TDomainsRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okDomain;
  FDropCommandClass:=TFBSQLDropDomain;
end;


  { TFireBirdTable }

procedure TFireBirdTable.DSUpdateRecord(ADataSet: TDataSet;
  AUpdateKind: DB.TUpdateKind; var AUpdateAction: fbmisc.TUpdateAction);
var
  F: TDBField;
  F1: TField;
  S1, S2, S3, S: String;
  i: Integer;
begin
  if AUpdateKind = ukInsert then
  begin
    S1:='';
    S2:='';
    S3:='';
    for F in Fields do
    begin
      if not FDataSet.FieldByName(F.FieldName).IsNull then
      begin
        if S1<>'' then
        begin
          S1:=S1 + ', ';
          S2:=S2 + ', ';
        end;
        S1:=S1 + DoFormatName(F.FieldName);
        S2:=S2 + ':' + DoFormatName(F.FieldName);
      end;

      if F.FieldPK then
      begin
        if S3 <> '' then S3 := S3 + ', ';
        S3 := S3 + DoFormatName(F.FieldName);
      end;
    end;

    if (S1='') or (S2='') then Abort;

    TFBDataSet(FDataSet).QueryInsert.SQL.Text:='insert into ' + DoFormatName(Caption) + '('+S1+') values (' + S2+ ') RETURNING ('+S3+')';

    for F in Fields do
    begin
      F1:=FDataSet.FieldByName(F.FieldName);
      if not F1.IsNull then
      begin
        if F1.DataType in IntegerDataTypes then
          TFBDataSet(FDataSet).QueryInsert.Params.ByNameAsInteger[F.FieldName]:=F1.AsInteger
        else
        if F1.DataType in NumericDataTypes then
          TFBDataSet(FDataSet).QueryInsert.Params.ByNameAsDouble[F.FieldName]:=F1.AsFloat
        else
        if F1.DataType in StringTypes then
          TFBDataSet(FDataSet).QueryInsert.Params.ByNameAsString[F.FieldName]:=F1.AsString
        else
        if F1.DataType = ftTime then
          TFBDataSet(FDataSet).QueryInsert.Params.ByNameAsDateTime[F.FieldName]:=F1.AsDateTime
        else
        if F1.DataType in [ftDateTime, ftTimeStamp] then
          TFBDataSet(FDataSet).QueryInsert.Params.ByNameAsDateTime[F.FieldName]:=F1.AsDateTime
        else
        if F1.DataType = ftDate then
          TFBDataSet(FDataSet).QueryInsert.Params.ByNameAsDateTime[F.FieldName]:=F1.AsDateTime
        else
          raise Exception.CreateFmt('Unknow data type for refresh : %s', [Fieldtypenames[F1.DataType]]);
      end;
    end;

    TFBDataSet(FDataSet).QueryInsert.Execute;
    for i:=0 to TFBDataSet(FDataSet).QueryInsert.Fields.FieldCount-1 do
    begin
      S:=TFBDataSet(FDataSet).QueryInsert.Fields.SqlName[i];
      F1:=FDataSet.FieldByName(S);

      if F1.DataType in IntegerDataTypes then
        F1.AsInteger:=TFBDataSet(FDataSet).QueryInsert.Fields.ByNameAsInteger[S]
      else
      if F1.DataType in StringTypes then
        F1.AsString:=TFBDataSet(FDataSet).QueryInsert.Fields.ByNameAsString[S]
      else
      if F1.DataType = ftTime then
        F1.AsDateTime:=TFBDataSet(FDataSet).QueryInsert.Fields.ByNameAsDateTime[S]
      else
      if F1.DataType in [ftDateTime, ftTimeStamp] then
        F1.AsDateTime:=TFBDataSet(FDataSet).QueryInsert.Fields.ByNameAsDateTime[S]
      else
      if F1.DataType = ftDate then
        F1.AsDateTime:=TFBDataSet(FDataSet).QueryInsert.Fields.ByNameAsDateTime[S]
      else
        raise Exception.CreateFmt('Unknow data type for refresh : %s', [Fieldtypenames[F1.DataType]]);
    end;
    TFBDataSet(FDataSet).QueryInsert.Close;
    AUpdateAction:=uaApplied;
  end;
end;

procedure TFireBirdTable.InternalSetDescription(ACommentOn: TSQLCommentOn);
begin
  ACommentOn.Description:=TSQLEngineFireBird(OwnerDB).ConvertString20(FDescription, false);
end;

function TFireBirdTable.InternalGetDDLCreate: string;
var
  SQLLines:TStringList;
  FCmd: TFBSQLCreateTable;
  Trig: TFireBirdTriger;
  i: Integer;
  F: TDBField;
  C: TPrimaryKeyRecord;
  CC: TSQLConstraintItem;
begin
  FCmd:=TFBSQLCreateTable.Create(nil);
  FCmd.ServerVersion:=TSQLEngineFireBird(OwnerDB).ServerVersion;

  SQLLines:=TStringList.Create;

  FCmd.Name:=Caption;
  FCmd.Description:=Description;

  for F in Fields do
    F.SaveToSQLFieldItem(FCmd.Fields.AddParam(F.FieldName));

  if ExternalFile <> '' then
    FCmd.FileName:=ExternalFile
  else
    FCmd.OnCommit:=TempTableAction;

  { TODO : Необходимо список ограничений формировать }
  RefreshConstraintForeignKey;
  for i:=0 to ConstraintCount-1 do
  begin
    C:=Constraint[I];
    case C.ConstraintType of
      //ctPrimaryKey,
      ctForeignKey:begin
          CC:=FCmd.SQLConstraints.Add(ctForeignKey);
          CC.ConstraintName:=C.Name;
          CC.ConstraintFields.AddParam(C.FieldList);
          CC.ForeignKeyRuleOnDelete:=TForeignKeyRecord(C).OnDeleteRule;
          CC.ForeignKeyRuleOnUpdate:=TForeignKeyRecord(C).OnUpdateRule;
          CC.ForeignTable:=TForeignKeyRecord(C).FKTableName;
          CC.ForeignFields.AddParam(TForeignKeyRecord(C).FKFieldName);
        end;
      //ctUnique,
      //ctTableCheck);
    end;
  end;

  try
    FACLList.RefreshList;
    FACLList.MakeACLListSQL(nil, SQLLines, true);

    Result:=FCmd.AsSQL + LineEnding + LineEnding + SQLLines.Text;

  finally
    SQLLines.Free;
  end;

  for i:=0 to TSQLEngineFireBird(OwnerDB).TriggersRoot.CountObject - 1 do
  begin
    Trig:=TFireBirdTriger(TSQLEngineFireBird(OwnerDB).TriggersRoot.Items[i]);
    if Trig.TriggerTable = Self then
      Result:=Result + LineEnding + LineEnding + Trig.DDLCreate;
  end;
  FCmd.Free;
end;

function TFireBirdTable.GetTrigger(ACat:integer; AItem: integer): TDBTriggerObject;
begin
  if (ACat>=0) and (ACat<6) then
    Result:=TFireBirdTriger(FTriggerList[ACat].Items[AItem])
  else
    Result:=nil;
end;

function TFireBirdTable.GetTriggersCategories(AItem: integer): string;
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

function TFireBirdTable.GetTriggersCategoriesCount: integer;
begin
  Result:=6;
  if FTriggerList[0].Count = 0 then
    TriggersListRefresh;
end;

function TFireBirdTable.GetTriggersCount(AItem: integer): integer;
begin
  if (AItem >=0) and (AItem<6) then
    Result:=FTriggerList[AItem].Count
  else
    Result:=0;
end;

{function GetIndexFields return list of fields< used in index IndexName}
function TFireBirdTable.GetIndexFields(const AIndexName: string;
  const AForce: boolean): string;
var
  QFields:TUIBQuery;
begin
  Result:='';
  if not AForce then
    Result:=inherited GetIndexFields(AIndexName, AForce);

  if Result<>'' then exit;

  QFields:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(ssqlSelectIndexSegments);
  try
    QFields.Params.ByNameAsString['index_name']:=AIndexName;
    QFields.Open;
    QFields.First;
    Result:='';
    while not QFields.Eof do
    begin
      Result:=Result+Trim(QFields.Fields.ByNameAsString['rdb$field_name'])+',';
      QFields.Next;
    end;
    QFields.Close;
  finally
    QFields.Free;
  end;
  Result:=Copy(Result, 1, Length(Result)-1);
end;

function TFireBirdTable.GetTriggersCategoriesType(AItem: integer
  ): TTriggerTypes;
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


function TFireBirdTable.GetRecordCount: integer;
var
  Q:TUIBQuery;
begin
  Q:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(ssqlCountRecord + DoFormatName(Caption));
  try
    Q.Open;
    Result:=Q.Fields.ByNameAsInteger['count_record'];
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TFireBirdTable.GetDBFieldClass: TDBFieldClass;
begin
  Result:=TFirebirdField;
end;

procedure TFireBirdTable.InternalRefreshStatistic;
var
  Q: TUIBQuery;
begin
  inherited InternalRefreshStatistic;

  Q:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(fbSqlModule.sFBStatistic['Stat1Format']);
  Q.Params.ByNameAsString['RELATION_NAME']:=Caption;
  Q.Open;
  Statistic.AddValue(sChangeCount, IntToStr(256 - Q.Fields.ByNameAsInteger['RDB$FORMAT']));
  Q.Close;
  Q.Free;
end;

procedure TFireBirdTable.IndexListRefresh;
var
  I:integer;
  QIndex:TUIBQuery;
  Rec: TIndexItem;
begin
  IndexArrayClear;
  QIndex:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(ssqlIndexList);
  try
    QIndex.Params.ByNameAsString['relation_name']:=Caption;
    QIndex.Open;
    while not QIndex.Eof do
    begin
      Rec:=IndexItems.Add(Trim(QIndex.Fields.ByNameAsString['rdb$index_name']));
      Rec.Unique:=QIndex.Fields.ByNameAsInteger['rdb$unique_flag']<>0;
      Rec.Active:=QIndex.Fields.ByNameAsInteger['rdb$index_inactive']<>0;

      if QIndex.Fields.ByNameAsInteger['RDB$INDEX_TYPE'] = 1 then
        Rec.SortOrder:=indDescending
      else
        Rec.SortOrder:=indAscending;
      //Rec.Descending:=QIndex.Fields.ByNameAsInteger['RDB$INDEX_TYPE'] = 1;
      Rec.IndexField:=GetIndexFields(Rec.IndexName, false);
      QIndex.Next;
    end;
  finally
    QIndex.Free;
  end;
  FIndexListLoaded:=true;
end;

function TFireBirdTable.IndexNew: string;
var
  R: TDBObject;
begin
  Result:='';
  R:=OwnerDB.CreateObject(okIndex, TSQLEngineFireBird(OwnerDB).IndexRoot);
  if Assigned(R) and (R is TFireBirdIndex) then
  begin
    TFireBirdIndex(R).Table:=Self;
    R.RefreshEditor;
  end;
end;

function TFireBirdTable.IndexEdit(const IndexName: string): boolean;
var
  P: TFireBirdIndex;
begin
  Result:=false;
  P:=TFireBirdIndex(TSQLEngineFireBird(OwnerDB).IndexRoot.ObjByName(IndexName));
  if Assigned(P) then
    P.Edit;
end;

procedure TFireBirdTable.RefreshFieldList;
var
  QFields, QGen:TUIBQuery;
  I:integer;
  Rec:TFirebirdField;
  S:string;
begin
  if State <> sdboEdit then exit;
  Fields.Clear;
  QGen:=nil;

  QFields:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(fbSqlModule.sqlSelectAllFields.Strings.Text);
  try
    QFields.Params.ByNameAsString['relation_name']:=Caption;
    QFields.Open;
    while not QFields.Eof do
    begin
      Rec:=Fields.Add(Trim(QFields.Fields.ByNameAsString['rdb$field_name'])) as TFirebirdField;

      S:=Trim(QFields.Fields.ByNameAsString['RDB$FIELD_SOURCE']);
      if LowerCase(copy(S,1, 4))<>'rdb$' then
        Rec.FieldTypeDomain:=S;

      S:=QFields.Fields.ByNameAsString['RDB$DEFAULT_SOURCE'];
      if UpperCase(Copy(S, 1, 7)) = 'DEFAULT' then
        S:=Trim(Copy(S, 8, Length(S)));
      Rec.FieldDefaultValue:=S;

      Rec.FieldSQLTypeInt:=QFields.Fields.ByNameAsInteger['rdb$field_type'];
      Rec.FieldSQLSubTypeInt:=QFields.Fields.ByNameAsInteger['rdb$field_sub_type'];
      Rec.FieldTypeName:=FB_SqlTypesToString(Rec.FieldSQLTypeInt,  Rec.FieldSQLSubTypeInt);
      Rec.FieldNotNull:=QFields.Fields.ByNameAsInteger['RDB$NULL_FLAG'] = 1;

      if not Assigned(Rec.FieldTypeRecord) then
        raise Exception.CreateFmt('Not found field type for %d', [Rec.FieldSQLTypeInt]);

      if Rec.FieldTypeRecord.DBType in NumericDataTypes - IntegerDataTypes then
      begin
        Rec.FieldSize:=QFields.Fields.ByNameAsInteger['RDB$FIELD_PRECISION'];
        Rec.FieldPrec:=-QFields.Fields.ByNameAsInteger['RDB$FIELD_SCALE'];
      end
      else
      if Rec.FieldTypeRecord.DBType in StringTypes then
      begin
        Rec.FieldSize:=QFields.Fields.ByNameAsInteger['RDB$CHARACTER_LENGTH'];
        Rec.FieldPrec:=0;
      end
      else
      begin
        if Rec.FieldTypeRecord.VarLen then
          Rec.FieldSize:=QFields.Fields.ByNameAsInteger['RDB$FIELD_LENGTH'];
        Rec.FieldPrec:=0;
      end;

//      Rec.FieldSize:=QFields.Fields.ByNameAsInteger['rdb$field_length'];
//      Rec.FieldPrec:=QFields.Fields.ByNameAsInteger['rdb$field_precision'];
      Rec.FFieldDescription:=TSQLEngineFireBird(OwnerDB).ConvertString20(Trim(QFields.Fields.ByNameAsString['rdb$description']), true);

      if not FSystemObject then
        Rec.SystemField:=Copy(Rec.FieldName, 1, 4) = 'RDB$';

      if not QFields.Fields.ByNameIsNull['RDB$COMPUTED_SOURCE'] then
        Rec.FieldComputedSource:=QFields.Fields.ByNameAsString['RDB$COMPUTED_SOURCE'];

//      if (Rec.FieldTypeRecord.DBType in [ftString]) and Rec.FieldTypeRecord.VarLen and (QFields.Fields.ByNameAsInteger['RDB$CHARACTER_LENGTH'] > 1) then
//        Rec.FieldSize:=QFields.Fields.ByNameAsInteger['RDB$CHARACTER_LENGTH'];

//    FieldTypeDB:TFieldType;
//    FieldUNIC:boolean;
//    FieldPK:boolean;
      if TSQLEngineFireBird(OwnerDB).ServerVersion in [gds_verFirebird3_0] then
      begin
        if QFields.Fields.ByNameAsString['RDB$GENERATOR_NAME'] <> '' then
        begin
          Rec.FieldAutoInc:=true;
          if not Assigned(QGen) then
            QGen:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(fbSqlModule.sGenerators['sGenerator']);
          QGen.Params.ByNameAsString['GENERATOR_NAME']:=QFields.Fields.ByNameAsString['RDB$GENERATOR_NAME'];
          QGen.Open;
          if QGen.Fields.RecordCount > 0 then
          begin
            Rec.FieldAutoIncInitialValue:=QGen.Fields.ByNameAsInteger['RDB$INITIAL_VALUE'];
          end;
          QGen.Close;
          //'RDB$IDENTITY_TYPE'
        end;
      end;
      QFields.Next;
    end;
  finally
    QFields.Free;
    if Assigned(QGen) then
      QGen.Free;
  end;
  IndexListRefresh;
  RefreshConstraintPrimaryKey;
end;

procedure TFireBirdTable.SetFieldsOrder(AFieldsList: TStrings);
var
  i:integer;
  SS:TStringList;
begin
  SS:=TStringList.Create;
  try
    for i:=0 to AFieldsList.Count-1 do
      SS.Add(Format(ssqlSetFieldPosition,[ Caption, AFieldsList[i], i+1]));
    if SS.Count>0 then
      ExecSQLScriptEx(SS, [sepShowCompForm], OwnerDB);
  finally
    SS.Free;
  end
end;

procedure TFireBirdTable.TriggersListRefresh;
var
  i, Cat:integer;
  Trig:TFireBirdTriger;
begin
  FTriggerList[0].Clear;
  FTriggerList[1].Clear;
  FTriggerList[2].Clear;
  FTriggerList[3].Clear;
  FTriggerList[4].Clear;
  FTriggerList[5].Clear;

  for i:=0 to TSQLEngineFireBird(OwnerDB).TriggersRoot.CountObject - 1 do
  begin
    Trig:=TFireBirdTriger(TSQLEngineFireBird(OwnerDB).TriggersRoot.Items[i]);
    if Trig.TableName = Caption then
    begin
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

function TFireBirdTable.TriggerNew(TriggerTypes: TTriggerTypes
  ): TDBTriggerObject;
begin
  Result:=OwnerDB.NewObjectByKind(TSQLEngineFireBird(OwnerDB).TriggersRoot, okTrigger) as TDBTriggerObject;
  if Assigned(Result) then
  begin
    Result.TableName:=Caption;
    Result.TriggerType:=TriggerTypes;
    Result.Active:=true;
    Result.RefreshEditor;
  end;
end;

function TFireBirdTable.TriggerDelete(const ATrigger: TDBTriggerObject): Boolean;
begin
  Result:=TSQLEngineFireBird(OwnerDB).FTriggersRoot.DropObject(ATrigger);
end;

procedure TFireBirdTable.RecompileTriggers;
begin
  inherited RecompileTriggers;
end;

procedure TFireBirdTable.AllTriggersSetActiveState(AState: boolean);
var
  Scr:TStringList;
  i,j:integer;
  S:string;
begin
  if AState then
    S:=ssqlAlterTriggerActive
  else
    S:=ssqlAlterTriggerInActive;

  Scr:=TStringList.Create;
  try
    for i:=0 to 5 do
      for j:=0 to FTriggerList[i].Count-1 do
        Scr.Add(Format(S, [TFireBirdTriger(FTriggerList[i].Items[j]).Caption]));
    ExecSQLScriptEx(Scr, [sepShowCompForm], OwnerDB);
  finally
    Scr.Free;
  end;

  for i:=0 to 5 do
    for j:=0 to FTriggerList[i].Count-1 do
      TFireBirdTriger(FTriggerList[i].Items[j]).RefreshObject;
end;



constructor TFireBirdTable.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  FACLList:=TFBACLList.Create(Self);
  FACLList.ObjectGrants:=[ogSelect, ogInsert, ogUpdate, ogDelete, ogReference, ogWGO];

  UITableOptions:=[utReorderFields, utRenameTable,
     utAddFields, utEditField, utDropFields,
     utAddFK, utEditFK, utDropFK,
     utAddUNQ, utDropUNQ,
     utAlterAddFieldInitialValue,
     utAlterAddFieldFK];

  FTransaction:=TUIBTransaction.Create(nil);
  FTransaction.DataBase:=TSQLEngineFireBird(OwnerDB).FBDatabase;
  FTransaction.Options:=IndexToTransaction(TSQLEngineFireBird(OwnerDB).FTranParamData);

  FDataSet:=TFBDataSet.Create(nil);
  TFBDataSet(FDataSet).DataBase:=TSQLEngineFireBird(OwnerDB).FBDatabase;
  TFBDataSet(FDataSet).Transaction:=FTransaction;
  FDataSet.AfterOpen:=@DataSetAfterOpen;
  FSystemObject:=AOwnerRoot.SystemObject;

  FTriggerList[0]:=TList.Create;  //before insert
  FTriggerList[1]:=TList.Create;  //after insert
  FTriggerList[2]:=TList.Create;  //before update
  FTriggerList[3]:=TList.Create;  //after update
  FTriggerList[4]:=TList.Create;  //before delete
  FTriggerList[5]:=TList.Create;  //after delete
end;

function TFireBirdTable.DataSet(ARecCountLimit: Integer): TDataSet;

function MakeSQLSelect:string;
var
  F: TDBField;
begin
  Result:='';
  for F in Fields do
    if F.FieldPK then
    begin
      Result:=' order by ' + DoFormatName(F.FieldName);
      break;
    end;
  Result:=' select * from ' + DoFormatName(Caption) + Result;
end;

function WherePK:string;
var
  F: TDBField;
begin
  Result:='';
  for F in Fields do
    if F.FieldPK then
    begin
      if Result <> '' then Result := Result + ' and ';
      Result:=Result + '(' + DoFormatName(F.FieldName) + ' = :' + DoFormatName(F.FieldName) + ')';
    end;

  if Result = '' then
  begin
    if Result <> '' then Result := Result + ' and ';
    Result:=Result + '(' + DoFormatName(F.FieldName) + ' = :' + DoFormatName(F.FieldName) + ')';
  end;
end;

function MakeSQLEdit:string;
var
  S: String;
  F: TDBField;
begin
  Result:='update ' +  DoFormatName(Caption) + ' set ';
  S:='';
  for F in Fields do
  begin
    if S<> '' then S:=S + ',';
    S:=S + DoFormatName(F.FieldName) + ' = :' + DoFormatName(F.FieldName);
  end;
  Result:=Result + S + ' where ' + WherePK;
end;

function MakeSQLInsert:string;
var
  S, S1: String;
  F: TDBField;
begin
  if TSQLEngineFireBird(OwnerDB).ServerVersion in [gds_verFirebird2_5, gds_verFirebird3_0] then
  begin
    TFBDataSet(FDataSet).OnUpdateRecord:=@DSUpdateRecord;
    Result:='1'
  end
  else
  begin
    Result:='insert into ' + DoFormatName(Caption) + '(';
    S:='';
    for F in Fields do
    begin
      if S<> '' then
      begin
        S:=S + ',';
        Result:=Result + ',';
      end;
      Result := Result + DoFormatName(F.FieldName);
      S:=S + ' :' + DoFormatName(F.FieldName);
    end;
    Result:=Result + ') values (' + S+ ')';
  end;
end;

var
  S: String;
begin
  if not FDataSet.Active then
  begin
    if not Loaded then
      RefreshObject;
    TFBDataSet(FDataSet).SQLSelect.Text:=MakeSQLSelect;
    TFBDataSet(FDataSet).SQLEdit.Text:=MakeSQLEdit;
    TFBDataSet(FDataSet).SQLInsert.Text:=MakeSQLInsert;
    S:='delete from '+DoFormatName(Caption) + ' where '+WherePK;
    TFBDataSet(FDataSet).SQLDelete.Text:=S;
    TFBDataSet(FDataSet).SQLRefresh.Text:='select * from '+DoFormatName(Caption) + ' where '+WherePK;

    if OwnerDB.DisplayDataOptions.FetchAllData then
      TFBDataSet(FDataSet).Option := TFBDataSet(FDataSet).Option + [poFetchAll]
    else
      TFBDataSet(FDataSet).Option := TFBDataSet(FDataSet).Option - [poFetchAll];
  end;
  Result:=FDataSet;
end;

destructor TFireBirdTable.Destroy;
begin
  FreeAndNil(FTriggerList[0]);  //before insert
  FreeAndNil(FTriggerList[1]);  //after insert
  FreeAndNil(FTriggerList[2]);  //before update
  FreeAndNil(FTriggerList[3]);  //after update
  FreeAndNil(FTriggerList[4]);  //before delete
  FreeAndNil(FTriggerList[5]);  //after delete

  FreeAndNil(FTransaction);
  inherited Destroy;
end;

procedure TFireBirdTable.Commit;
begin
  inherited Commit;
  FTransaction.Commit;
end;

procedure TFireBirdTable.RollBack;
begin
  inherited RollBack;
  FTransaction.RollBack;
end;

procedure TFireBirdTable.RefreshObject;
var
  IBQ:TUIBQuery;
  D:TFireBirdView;
  i: Word;
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;

  IBQ:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(ssqlView);
  IBQ.Params.ByNameAsAnsiString['RELATION_NAME']:=Caption;
  try
    IBQ.Open;
    FDescription:=TSQLEngineFireBird(OwnerDB).ConvertString20(Trim(IBQ.Fields.ByNameAsAnsiString['RDB$DESCRIPTION']), true);
    if IBQ.Fields.TryGetFieldIndex('RDB$EXTERNAL_FILE', i) then
      FExternalFile:=Trim(IBQ.Fields.ByNameAsAnsiString['RDB$EXTERNAL_FILE'])
    else
      FExternalFile:='';

    if IBQ.Fields.TryGetFieldIndex('RDB$RELATION_TYPE', i) then
      case IBQ.Fields.ByNameAsInteger['RDB$RELATION_TYPE'] of
        4:FTempTableAction:=oncPreserve; //rel_global_temp_preserve =
        5:FTempTableAction:=oncDelete; //rel_global_temp_delete
      else
        FTempTableAction:=oncNone;
      end
    else
      FTempTableAction:=oncNone;


{                '   RDB$RELATIONS.RDB$RELATION_NAME, '+
                '   RDB$RELATIONS.RDB$FORMAT, '+
                '   RDB$RELATIONS.RDB$EXTERNAL_FILE, '+
                '   RDB$RELATIONS.RDB$OWNER_NAME, '+
                '   RDB$RELATIONS.RDB$FLAGS, '+
                '   RDB$RELATIONS.RDB$RELATION_TYPE '+}
  finally
    IBQ.Free;
  end;
  RefreshFieldList;
end;

class function TFireBirdTable.DBClassTitle: string;
begin
  Result:='TABLE';
end;

procedure TFireBirdTable.RefreshDependencies;
begin
  TSQLEngineFireBird(OwnerDB).RefreshDependencies(Self);
end;

procedure TFireBirdTable.RefreshDependenciesField(Rec: TDependRecord);
var
  IBQ:TUIBQuery;
begin
  if (State = sdboEdit) and (Rec.FieldList.Count = 0) then
  begin
    IBQ:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(ssqlSelectDependenciesField);
    IBQ.Params.ByNameAsAnsiString['DEPENDED_ON_NAME']:=Caption;
    IBQ.Params.ByNameAsAnsiString['DEPENDENT_NAME']:=Rec.ObjectName;
    try
      IBQ.Open;
      while not IBQ.Eof do
      begin
        Rec.FieldList.Add(IBQ.Fields.ByNameAsString['RDB$FIELD_NAME']);
        IBQ.Next;
      end;
    finally
      IBQ.Free;
    end;
  end;
end;

function TFireBirdTable.CreateSQLObject: TSQLCommandDDL;
begin
  if State <> sdboCreate then
  begin
    Result:=TFBSQLAlterTable.Create(nil);
    Result.Name:=Caption;
    TFBSQLAlterTable(Result).ServerVersion:=TSQLEngineFireBird(OwnerDB).ServerVersion;
  end
  else
  begin
    Result:=TFBSQLCreateTable.Create(nil);
    TFBSQLCreateTable(Result).ServerVersion:=TSQLEngineFireBird(OwnerDB).ServerVersion;
  end;
end;

function TFireBirdTable.GetDDLSQLObject(ACommandType: TDDLCommandType
  ): TSQLCommandDDL;
begin
  case ACommandType of
    ddlctCrate:
      begin
        Result:=TFBSQLCreateTable.Create(nil);
        TFBSQLCreateTable(Result).ServerVersion:=TSQLEngineFireBird(OwnerDB).ServerVersion;
      end;
    ddlctAlter:
      begin
        Result:=TFBSQLAlterTable.Create(nil);
        Result.Name:=Caption;
        TFBSQLAlterTable(Result).ServerVersion:=TSQLEngineFireBird(OwnerDB).ServerVersion;
      end;
    ddlctDrop:
      begin
        Result:=TFBSQLDropTable.Create(nil);
        Result.Name:=Caption;
        TFBSQLAlterTable(Result).ServerVersion:=TSQLEngineFireBird(OwnerDB).ServerVersion;
      end;
  end;
end;
(*
function TFireBirdTable.RenameObject(ANewName: string): Boolean;
var
  FCmd: TFBSQLAlterTable;
  Op: TAlterTableOperator;
begin
  if (State = sdboCreate) then
  begin
    Caption:=ANewName;
    Result:=true;
  end
  else
  begin
    FCmd:=TFBSQLAlterTable.Create(nil);
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
*)
function TFireBirdTable.IndexDelete(const IndexName: string): boolean;
var
  Ind:TFireBirdIndex;
begin
  Ind:=TFireBirdIndex(TSQLEngineFireBird(OwnerDB).IndexRoot.ObjByName(IndexName));
  if Assigned(Ind) then
    Result:=TSQLEngineFireBird(OwnerDB).IndexRoot.DropObject(Ind)
  else
    Result:=false;
end;

procedure TFireBirdTable.RefreshConstraintPrimaryKey;
var
  I:integer;
  QPKList:TUIBQuery;
  Rec:TPrimaryKeyRecord;
  F: TDBField;
begin
  inherited RefreshConstraintPrimaryKey;

  QPKList:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(ssqlSelectPkList);
  try
    QPKList.Params.ByNameAsString['relation_name']:=Caption;
    QPKList.Open;
    while not QPKList.Eof do
    begin
      Rec:=TPrimaryKeyRecord.Create;
      FConstraintList.Add(Rec);
      Rec.Name:=Trim(QPKList.Fields.ByNameAsString['rdb$constraint_name']);
      Rec.IndexName:=Trim(QPKList.Fields.ByNameAsString['rdb$index_name']);
      Rec.Index:=IndexFind(Rec.IndexName);
      if Assigned(Rec.Index) then
      begin
        Rec.FieldList:=Rec.Index.IndexField;
        for i:=0 to Rec.CountFields-1 do
        begin
          F:=Fields.FieldByName(Rec.FieldByNum(i));
          if Assigned(F) then
            F.FieldPK:=true;
        end;
      end;
      QPKList.Next;
    end;
  finally
    QPKList.Free;
  end;
end;

procedure TFireBirdTable.RefreshConstraintForeignKey;
var
  I:integer;
  QFKList:TUIBQuery;
  Rec:TForeignKeyRecord;
begin
  inherited RefreshConstraintForeignKey;
  QFKList:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(fbSqlModule.ssqlSelectFKList.ExpandMacros);
  try
    QFKList.Params.ByNameAsString['relation_name']:=Caption;
    QFKList.Open;
    while not QFKList.Eof do
    begin
      Rec:=TForeignKeyRecord.Create;
      FConstraintList.Add(Rec);
      Rec.Name:=Trim(QFKList.Fields.ByNameAsString['rdb$constraint_name']);
      Rec.IndexName:=Trim(QFKList.Fields.ByNameAsString['rdb$index_name']);
      Rec.Index:=IndexFind(Rec.IndexName);
      Rec.FieldList:=Rec.Index.IndexField;
      Rec.OnUpdateRule:=StrToForeignKeyRule(Trim(QFKList.Fields.ByNameAsString['rdb$update_rule']));
      Rec.OnDeleteRule:=StrToForeignKeyRule(Trim(QFKList.Fields.ByNameAsString['rdb$delete_rule']));
      Rec.FKTableName:=Trim(QFKList.Fields.ByNameAsString['FK_Table']);
      Rec.FKFieldName:=Trim(QFKList.Fields.ByNameAsString['FK_Field']);
      QFKList.Next;
    end;
  finally
    QFKList.Free;
  end;
end;

procedure TFireBirdTable.RefreshConstraintUnique;
var
  I:integer;
  Q:TUIBQuery;
  Rec:TUniqueRecord;
begin
  inherited RefreshConstraintUnique;
  Q:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(ssqlSelectUNQList);
  try
    Q.Params.ByNameAsString['relation_name']:=Caption;
    Q.Open;
    while not Q.Eof do
    begin
      Rec:=TUniqueRecord.Create;
      FConstraintList.Add(Rec);
      Rec.Name:=Trim(Q.Fields.ByNameAsString['rdb$constraint_name']);
      Rec.IndexName:=Trim(Q.Fields.ByNameAsString['rdb$index_name']);
      Rec.Index:=IndexFind(Rec.IndexName);
      Rec.FieldList:=Rec.Index.IndexField;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TFireBirdTable.RefreshConstraintCheck;
var
  Q: TUIBQuery;
  Rec: TTableCheckConstraintRecord;
  S: String;
begin
  inherited RefreshConstraintCheck;
  Q:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(fbSqlModule.sTabcleCheck.ExpandMacros);
  try
    Q.Params.ByNameAsString['relation_name']:=Caption;
    Q.Open;
    while not Q.Eof do
    begin
      Rec:=TTableCheckConstraintRecord.Create;
      FConstraintList.Add(Rec);
      Rec.Name:=Trim(Q.Fields.ByNameAsString['RDB$CONSTRAINT_NAME']);
      S:=Q.Fields.ByNameAsString['RDB$TRIGGER_SOURCE'];
      if Copy(S, 1, 6) = 'CHECK ' then
        Delete(S, 1, 6);
      Rec.SQLBody:=S;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

{ TTriggersRoot }

function TTriggersRoot.DBMSObjectsList: string;
begin
  Result:=fbSqlModule.sFbTriggers.Strings.Text;
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
  FDBObjectKind:=okTrigger;
  FDropCommandClass:=TFBSQLDropTrigger;
end;

{ TGeneratorsRoot }

function TGeneratorsRoot.DBMSObjectsList: string;
begin
  Result:=fbSqlModule.sFBGenerators.Strings.Text;
end;

function TGeneratorsRoot.GetObjectType: string;
begin
  Result:='Generator';
end;

constructor TGeneratorsRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okSequence;
  FDropCommandClass:=TFBSQLDropGenerator;
end;

{ TStoredProcRoot }

function TStoredProcRoot.DBMSObjectsList: string;
begin
  Result:=fbSqlModule.sFBStoredProc.Strings.Text;
end;

function TStoredProcRoot.GetObjectType: string;
begin
  Result:='Stored proc';
end;

constructor TStoredProcRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okStoredProc;
  FDropCommandClass:=TFBSQLDropProcedure;
end;

{ TExceptionRoot }

function TExceptionRoot.DBMSObjectsList: string;
begin
  Result:=fbSqlModule.sFBExceptions.Strings.Text;
end;

function TExceptionRoot.GetObjectType: string;
begin
  Result:='Exception';
end;

constructor TExceptionRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okException;
  FDropCommandClass:=TFBSQLDropException;
end;

{ TUDFRoot }

function TUDFRoot.DBMSObjectsList: string;
begin
  if TSQLEngineFireBird(OwnerDB).ServerVersion in [gds_verFirebird3_0] then
    Result:=fbSqlModule.sFunctions.Strings.Text
  else
    Result:=fbSqlModule.sFBUDF.Strings.Text;
end;

function TUDFRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  if TSQLEngineFireBird(OwnerDB).ServerVersion in [gds_verFirebird3_0] then
    Result:=Assigned(AItem) and (AItem.ObjType2 = 1)
  else
    Result:=true;
end;

function TUDFRoot.GetObjectType: string;
begin
  Result:='UDF';
end;

constructor TUDFRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okUDF;
  FDropCommandClass:=TFBSQLDropUDF;
end;

{ TRoleRoot }

function TRoleRoot.DBMSObjectsList: string;
begin
  Result:=fbSqlModule.sFBRoles.Strings.Text;
end;

function TRoleRoot.GetObjectType: string;
begin
  Result:='Role';
end;

constructor TRoleRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okRole;
  FDropCommandClass:=TFBSQLDropRole;
end;

{ TViewsRoot }

function TViewsRoot.DBMSObjectsList: string;
begin
  Result:=fbSqlModule.ssqlSelectViews.Strings.Text;
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
  FDBObjectKind:=okView;
  FDropCommandClass:=TFBSQLDropView;
end;

{ TFireBirdTriger }

procedure TFireBirdTriger.InternalSetDescription(ACommentOn: TSQLCommentOn);
begin
  ACommentOn.Description:=TSQLEngineFireBird(OwnerDB).ConvertString20(FDescription, false);
end;

function TFireBirdTriger.InternalGetDDLCreate: string;
var
  Rec: TFBSQLCreateTrigger;
begin
  Rec:=TFBSQLCreateTrigger.Create(nil);
  Rec.Name:=CaptionFullPatch;
  Rec.TableName:=TableName;
  Rec.CreateMode:=cmCreateOrAlter;
  Rec.Active:=Active;
  Rec.Position:=Sequence;
  Rec.TriggerType:=TriggerType;
  Rec.Body:=TriggerBody;
  Result:=Rec.AsSQL;
  Rec.Free;
end;

procedure TFireBirdTriger.SetActive(const AValue: boolean);
var
  S:string;
begin
  if (State = sdboCreate) then
    FActive:=AValue
  else
  begin
    if AValue then
      S:=ssqlAlterTriggerActive
    else
      S:=ssqlAlterTriggerInActive;

    ExecSQLScript(Format(S, [Caption]), [sepShowCompForm], OwnerDB);
    RefreshObject;
  end;
end;


function TFireBirdTriger.GetTriggerBody: string;
begin
  Result:=FTriggerBody;
end;

function TFireBirdTriger.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=TFBSQLCreateTrigger.Create(nil);
  if State = sdboEdit then
    TFBSQLCreateTrigger(Result).CreateMode := cmCreateOrAlter;
end;

function TFireBirdTriger.CompileSQLObject(ASqlObject: TSQLCommandDDL;
  ASqlExecParam: TSqlExecParams): boolean;
var
  ADBTable: TDBDataSetObject;
  S: string;
begin
  Result:=inherited CompileSQLObject(ASqlObject, ASqlExecParam);
  if Result then
  begin
    S:=(ASqlObject as TFBSQLCreateTrigger).TableName;
    ADBTable:=TSQLEngineFireBird(OwnerDB).TablesRoot.ObjByName(S) as TDBDataSetObject;
    ADBTable.RefreshEditor;
  end
end;

procedure TFireBirdTriger.RefreshObject;
var
  IBQ:TUIBQuery;
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;

  IBQ:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(ssqlSelectCurTriger);
  IBQ.Params.ByNameAsString['trigger_name']:=Caption;
  try
    IBQ.Open;
    FDescription:=TSQLEngineFireBird(OwnerDB).ConvertString20(IBQ.Fields.ByNameAsAnsiString['rdb$description'], true);
    FActive:=IBQ.Fields.ByNameAsInteger['rdb$trigger_inactive']=0;
    TableName:=Trim(IBQ.Fields.ByNameAsAnsiString['rdb$relation_name']);
    FSequence:=IBQ.Fields.ByNameAsInteger['rdb$trigger_sequence'];
    TriggerType:=FBTrigTypeToTriggerType(IBQ.Fields.ByNameAsInteger['rdb$trigger_type']);
    FTriggerBody:=TSQLEngineFireBird(OwnerDB).ConvertString20(IBQ.Fields.ByNameAsString['rdb$trigger_source'], true);
    IBQ.Close;
  finally
    IBQ.Free;
  end;
  FTriggerTable:=TSQLEngineFireBird(OwnerDB).FTablesRoot.ObjByName(TableName) as TDBDataSetObject;
end;

constructor TFireBirdTriger.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
  begin
    TableName:=ADBItem.ObjRelName;
    TriggerType:=FBTrigTypeToTriggerType(ADBItem.ObjType2);
//    D.FActive:=IBQ.Fields.ByNameAsInteger['rdb$trigger_inactive']=0;
//    D.FSequence:=IBQ.Fields.ByNameAsInteger['rdb$trigger_sequence'];
  end
  else
  begin
    FActive:=true;
  end;
end;

class function TFireBirdTriger.DBClassTitle: string;
begin
  Result:='TRIGGER';
end;

procedure TFireBirdTriger.RefreshDependencies;
begin
  TSQLEngineFireBird(OwnerDB).RefreshDependencies(Self);
end;


{ TFireBirdView }

procedure TFireBirdView.InternalSetDescription(ACommentOn: TSQLCommentOn);
begin
  ACommentOn.Description:=TSQLEngineFireBird(OwnerDB).ConvertString20(FDescription, false);
end;

function TFireBirdView.GetRecordCount: integer;
var
  Q:TUIBQuery;
begin
  Q:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(ssqlCountRecord + DoFormatName(Caption));
  try
    Q.Open;
    Result:=Q.Fields.ByNameAsInteger['count_record'];
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TFireBirdView.GetDBFieldClass: TDBFieldClass;
begin
  Result:=TFirebirdField;
end;

function TFireBirdView.InternalGetDDLCreate: string;
var
  V: TFBSQLCreateView;
  F: TDBField;
  ACL: TStringList;
  F1: TSQLParserField;
begin
  V:=TFBSQLCreateView.Create(nil);
  try
    V.Name:=Caption;
    V.CreateMode:=cmCreateOrAlter;
    for F in Fields do
    begin
      F1:=V.Fields.AddParam(F.FieldName);
      F1.Description:=F.FieldDescription;
    end;
    V.SQLSelect:=FSQLBody;
    V.Description:=Description;
    Result:=V.AsSQL;
  finally
    V.Free;
  end;

  ACL:=TStringList.Create;
  try
    FACLList.RefreshList;
    FACLList.MakeACLListSQL(nil, ACL, true);
    Result:=Result + LineEnding + LineEnding + ACL.Text;
  finally
    ACL.Free;
  end;
end;

function TFireBirdView.GetDDLAlter: string;
var
  FCmd: TFBSQLCreateView;
  F: TDBField;
begin
  //GetDDLAlter:=InternalGetDDLCreate;
  if Fields.Count = 0 then RefreshFieldList;
  FCmd:=TFBSQLCreateView.Create(nil);
  FCmd.Name:=Caption;
  for F in Fields do
    FCmd.Fields.AddParam(F.FieldName);

  FCmd.SQLSelect:=SQLBody;
  Result:=FCmd.AsSQL;
  FCmd.Free;
end;

function TFireBirdView.GetTrigger(ACat: integer; AItem: integer
  ): TDBTriggerObject;
begin
  if (ACat>=0) and (ACat<6) then
    Result:=TFireBirdTriger(FTriggerList[ACat].Items[AItem])
  else
    Result:=nil;
end;

function TFireBirdView.GetTriggersCategories(AItem: integer): string;
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

function TFireBirdView.GetTriggersCategoriesCount: integer;
begin
  Result:=6;
  if FTriggerList[0].Count = 0 then
    TriggersListRefresh;
end;

function TFireBirdView.GetTriggersCount(AItem: integer): integer;
begin
  if (AItem >=0) and (AItem<6) then
    Result:=FTriggerList[AItem].Count
  else
    Result:=0;
end;

function TFireBirdView.GetTriggersCategoriesType(AItem: integer): TTriggerTypes;
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

procedure TFireBirdView.RefreshObject;
var
  IBQ:TUIBQuery;
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;

  IBQ:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(ssqlView);
  IBQ.Params.ByNameAsAnsiString['RELATION_NAME']:=Caption;;
  try
    IBQ.Open;
    FDescription:=TSQLEngineFireBird(OwnerDB).ConvertString20(Trim(IBQ.Fields.ByNameAsAnsiString['RDB$DESCRIPTION']), true);
    FSQLBody:=TSQLEngineFireBird(OwnerDB).ConvertString20(Trim(IBQ.Fields.ByNameAsAnsiString['RDB$VIEW_SOURCE']), true);
{                '   RDB$RELATIONS.RDB$RELATION_NAME, '+
                '   RDB$RELATIONS.RDB$FORMAT, '+
                '   RDB$RELATIONS.RDB$EXTERNAL_FILE, '+
                '   RDB$RELATIONS.RDB$OWNER_NAME, '+
                '   RDB$RELATIONS.RDB$FLAGS, '+
                '   RDB$RELATIONS.RDB$RELATION_TYPE '+}
  finally
    IBQ.Free;
  end;
  RefreshFieldList;
end;

procedure TFireBirdView.RefreshFieldList;
var
  QFields:TUIBQuery;
  Rec:TFirebirdField;
begin
  if State <> sdboEdit then exit;
  Fields.Clear;

  QFields:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(fbSqlModule.sqlSelectAllFields.Strings.Text);
  try
    QFields.Params.ByNameAsString['relation_name']:=Caption;
    QFields.Open;
    QFields.First;
    while not QFields.Eof do
    begin
      Rec:=Fields.Add(Trim(QFields.Fields.ByNameAsString['rdb$field_name'])) as TFirebirdField;

      Rec.FieldTypeDomain:=Trim(QFields.Fields.ByNameAsString['RDB$FIELD_SOURCE']);
      Rec.FieldSQLTypeInt:=QFields.Fields.ByNameAsInteger['rdb$field_type'];
      Rec.FieldSQLSubTypeInt:=QFields.Fields.ByNameAsInteger['rdb$field_sub_type'];
      Rec.FieldNotNull:=QFields.Fields.ByNameAsInteger['RDB$NULL_FLAG'] = 1;
      Rec.FieldSize:=QFields.Fields.ByNameAsInteger['rdb$field_length'];
      Rec.FieldPrec:=QFields.Fields.ByNameAsInteger['rdb$field_precision'];
      Rec.FFieldDescription:=QFields.Fields.ByNameAsString['rdb$description'];

      Rec.SystemField:=Copy(Rec.FieldName, 1, 4) = 'RDB$';

      Rec.FieldTypeName:=FB_SqlTypesToString(Rec.FieldSQLTypeInt,  Rec.FieldSQLSubTypeInt);
//    FieldTypeDB:TFieldType;
//    FieldUNIC:boolean;
//    FieldPK:boolean;

      QFields.Next;
    end;
  finally
    QFields.Free;
  end;
end;

constructor TFireBirdView.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  FACLList:=TFBACLList.Create(Self);
  FACLList.ObjectGrants:=[ogSelect, ogInsert, ogUpdate, ogDelete, ogReference];

  FTransaction:=TUIBTransaction.Create(nil);
  FTransaction.DataBase:=TSQLEngineFireBird(OwnerDB).FBDatabase;
  FTransaction.Options:=IndexToTransaction(TSQLEngineFireBird(OwnerDB).FTranParamData);
  FDataSet:=TFBDataSet.Create(nil);
  TFBDataSet(FDataSet).DataBase:=TSQLEngineFireBird(OwnerDB).FBDatabase;
  TFBDataSet(FDataSet).Transaction:=FTransaction;
  FDataSet.AfterOpen:=@DataSetAfterOpen;
  FSystemObject:=AOwnerRoot.SystemObject;

  FTriggerList[0]:=TList.Create;  //before insert
  FTriggerList[1]:=TList.Create;  //after insert
  FTriggerList[2]:=TList.Create;  //before update
  FTriggerList[3]:=TList.Create;  //after update
  FTriggerList[4]:=TList.Create;  //before delete
  FTriggerList[5]:=TList.Create;  //after delete
end;

destructor TFireBirdView.Destroy;
begin
  FreeAndNil(FTriggerList[0]);  //before insert
  FreeAndNil(FTriggerList[1]);  //after insert
  FreeAndNil(FTriggerList[2]);  //before update
  FreeAndNil(FTriggerList[3]);  //after update
  FreeAndNil(FTriggerList[4]);  //before delete
  FreeAndNil(FTriggerList[5]);  //after delete

  FreeAndNil(FTransaction);
  inherited Destroy;
end;

class function TFireBirdView.DBClassTitle: string;
begin
  Result:='VIEW';
end;

function TFireBirdView.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=TFBSQLCreateView.Create(nil);
  Result.Name:=Caption;
end;

procedure TFireBirdView.Commit;
begin
  inherited Commit;
  FTransaction.Commit;
end;

procedure TFireBirdView.RollBack;
begin
  inherited RollBack;
  FTransaction.RollBack;
end;

function TFireBirdView.DataSet(ARecCountLimit: Integer): TDataSet;
begin
  if not FDataSet.Active then
  begin
    TFBDataSet(FDataSet).SQLSelect.Text:='select * from ' + DoFormatName( Caption);

    if OwnerDB.DisplayDataOptions.FetchAllData then
      TFBDataSet(FDataSet).Option := TFBDataSet(FDataSet).Option + [poFetchAll]
    else
      TFBDataSet(FDataSet).Option := TFBDataSet(FDataSet).Option - [poFetchAll];
  end;
  Result:=FDataSet;
end;

function TFireBirdView.TriggerNew(TriggerTypes: TTriggerTypes
  ): TDBTriggerObject;
begin
  Result:=OwnerDB.NewObjectByKind(TSQLEngineFireBird(OwnerDB).TriggersRoot, okTrigger) as TDBTriggerObject;
  if Assigned(Result) then
  begin
    Result.TableName:=Caption;
    Result.TriggerType:=TriggerTypes;
    Result.Active:=true;
    Result.RefreshEditor;
  end;
end;

procedure TFireBirdView.TriggersListRefresh;
var
  i, Cat:integer;
  Trig:TFireBirdTriger;
begin
  FTriggerList[0].Clear;
  FTriggerList[1].Clear;
  FTriggerList[2].Clear;
  FTriggerList[3].Clear;
  FTriggerList[4].Clear;
  FTriggerList[5].Clear;

  for i:=0 to TSQLEngineFireBird(OwnerDB).TriggersRoot.CountObject - 1 do
  begin
    Trig:=TFireBirdTriger(TSQLEngineFireBird(OwnerDB).TriggersRoot.Items[i]);
    if Trig.TableName = Caption then
    begin
      if ttBefore in Trig.TriggerType then
      begin
        if ttInsert in Trig.TriggerType then
          FTriggerList[0].Add(Trig);
        if ttUpdate in Trig.TriggerType then
          FTriggerList[2].Add(Trig);
        if ttDelete in Trig.TriggerType then
          FTriggerList[4].Add(Trig);
      end;

      if ttBefore in Trig.TriggerType then
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

procedure TFireBirdView.RefreshDependencies;
begin
  TSQLEngineFireBird(OwnerDB).RefreshDependencies(Self);
end;

procedure TFireBirdView.MakeSQLStatementsList(AList: TStrings);
begin
  AList.AddObject('DDL', TObject(Pointer(0)));
  AList.AddObject('Fields/Parameters list', TObject(Pointer(1)));
  AList.AddObject('SELECT', TObject(Pointer(2)));
  AList.AddObject('SELECT INTO', TObject(Pointer(3)));
  AList.AddObject('FOR SELECT', TObject(Pointer(4)));
  AList.AddObject('INSERT INTO', TObject(Pointer(5)));
  AList.AddObject('UPDATE', TObject(Pointer(6)));
  AList.AddObject('DELETE FROM', TObject(Pointer(7)));
  AList.AddObject('DECLARE VARIABLE', TObject(Pointer(8)));
  AList.AddObject('Name + Type', TObject(Pointer(9)));
end;

{ TFBQueryControl }

procedure TFBQueryControl.SetParamValues;
var
  i:integer;
begin
  for i:=0 to FParams.Count-1 do
    if FParams[i].IsNull then
      FBQuery.Params.ByNameIsNull[FParams[i].Name]:=true
    else
      FBQuery.Params.ByNameAsVariant[FParams[i].Name]:=FParams[i].Value;
end;

function TFBQueryControl.GetDataSet: TDataSet;
begin
  Result:=FBQuery;
end;

function TFBQueryControl.GetQueryPlan: string;
begin
  FBQuery.QuerySelect.Prepare(true);
  Result:=FBQuery.QuerySelect.Plan;
end;

function TFBQueryControl.GetQuerySQL: string;
begin
  Result:=FBQuery.SQLSelect.Text;
end;

procedure TFBQueryControl.SetQuerySQL(const AValue: string);
var
  P:TParam;
  I:integer;
  S: String;
begin
  FBQuery.SQLSelect.Text:=AValue;
  FParams.Clear;
  for i:=0 to FBQuery.Params.FieldCount-1 do
  begin
    S:=FBQuery.Params.FieldName[i];
    if not Assigned(FParams.FindParam(S)) then
    begin
      P:=TParam.Create(FParams);
      P.Name:=S;
      case FBQuery.Params.FieldType[i] of
        uftQuad, uftFloat, uftDoublePrecision, uftNumeric : P.DataType:=ftFloat;
        uftSmallint, uftInteger, uftInt64 : P.DataType:=ftInteger;
        uftChar, uftVarchar, uftCstring : P.DataType:=ftString;
        uftTimestamp, uftDate, uftTime : P.DataType:=ftDateTime;
      end;
    end;
  end;
end;

function TFBQueryControl.GetParam(AIndex: integer): TParam;
begin
  Result:=FParams[AIndex];
end;

function TFBQueryControl.GetParamCount: integer;
begin
  Result:=FParams.Count;
end;

procedure TFBQueryControl.SetActive(const AValue: boolean);
begin
  SetParamValues;
  inherited SetActive(AValue);
end;

constructor TFBQueryControl.Create(AOwner: TSQLEngineAbstract);
begin
  inherited Create(AOwner);
  FFBTransaction:=TUIBTransaction.Create(nil);
  FFBTransaction.DataBase:=TSQLEngineFireBird(Owner).FBDatabase;
  FFBTransaction.Options:=IndexToTransaction(TSQLEngineFireBird(Owner).FTranParamData);

  FBQuery:=TFBDataSet.Create(nil);
  FBQuery.DataBase:=TSQLEngineFireBird(Owner).FBDatabase;
  FBQuery.Transaction:=FFBTransaction;

  FParams:=TParams.Create(nil);
end;

destructor TFBQueryControl.Destroy;
begin
  FreeAndNil(FParams);
  FreeAndNil(FFBTransaction);
  FreeAndNil(FBQuery);
  inherited Destroy;
end;

procedure TFBQueryControl.CommitTransaction;
begin
  FFBTransaction.Commit;
end;

procedure TFBQueryControl.RolbackTransaction;
begin
  FFBTransaction.RollBack;
end;

procedure TFBQueryControl.FetchAll;
begin
  FBQuery.FetchAll;
end;

procedure TFBQueryControl.Prepare;
begin
  FBQuery.QuerySelect.Prepare;
end;

procedure TFBQueryControl.ExecSQL;
begin
  SetParamValues;
  FBQuery.QuerySelect.ExecSQL;
end;

function TFBQueryControl.ParseException(E: Exception; out X, Y: integer; out
  AMsg: string): boolean;
var
  St: TStringList;
  S: String;
  C: SizeInt;
begin
  Result:=false;
  if E is EUIBError then
  begin
    AMsg:='';
    X:=0;
    Y:=0;
    St:=TStringList.Create;
    St.Text:=E.Message;
    for S in St do
    begin
      if Copy(S, 1, 7) = 'At line' then
      begin
        C:=Pos(',', S);
        if C>0 then
        begin
          Y:=StrToIntDef(Trim(Copy(S, 9, C - 9)), 0);
          X:=StrToIntDef(Trim(Copy(S, C + 8, Length(S))), 0);
        end;
      end
      else
      if Copy(S, 1, 13) = 'Token unknown' then
      begin
        C:=Pos(',', S);
        if C>0 then
        begin
          Y:=StrToIntDef(Trim(Copy(S, 22, C - 22)), 0);
          X:=StrToIntDef(Trim(Copy(S, C + 8, Length(S))), 0);
        end;
        if AMsg<>'' then AMsg:=AMsg + LineEnding;
        AMsg:=AMsg + S;
      end
      else
      if (S<>'') and (S <> 'Dynamic SQL Error') and (Copy(S, 1, 14) <> 'SQL error code') then
      begin
        if AMsg<>'' then AMsg:=AMsg + LineEnding;
        AMsg:=AMsg + S;
      end;
    end;
    St.Free;
    Result:=AMsg<>'';
    if Result then
      AMsg:=AMsg + LineEnding + DupeString('-', 80) + LineEnding + E.Message;
  end;
end;

function TFBQueryControl.LoadStatistic(out StatRec: TQueryStatRecord;
  const SQLCommand: TSQLCommandAbstract): boolean;
begin
  inherited LoadStatistic(StatRec, SQLCommand);
  FBQuery.QuerySelect.AffectedRows(StatRec.SelectedRows, StatRec.InsertedRows, StatRec.UpdatedRows, StatRec.DeletedRows);
  Result:=true;
end;

{ TSystemTablesRoot }

constructor TSystemTablesRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  //FSystemObject:=true;
  //Caption:=sSystemTables;
  //FDropCommandClass:=nil;
end;

{ TFireBirdStoredProc }

function TFireBirdStoredProc.InternalGetDDLCreate: string;
procedure AssignParams(P:TSQLParserField; F:TDBField; AVarType : TSPVarType);
begin
  { TODO : Переписать! }
  P.Caption:=F.FieldName;
  if F.FieldNotNull then
    P.Params:=P.Params + [fpNotNull]
  else
    P.Params:=P.Params - [fpNotNull]
  ;
  P.Description:=F.FieldDescription;
  P.DefaultValue:=F.FieldDefaultValue;
  P.InReturn:=AVarType;
  if Assigned(F.FieldDomain) then
    P.TypeName:=F.FieldTypeDomain
  else
  begin
    P.TypeName:=F.FieldTypeName;
    P.TypeLen:=F.FieldSize;
    P.TypePrec:=F.FieldPrec;
  end;
//  P.TypeOf:=F.DomainTypeOf;
end;

var
  FCmd: TFBSQLCreateProcedure;
  ACL: TStringList;
  F: TDBField;
begin
  FCmd:=TFBSQLCreateProcedure.Create(nil);
  FCmd.Name:=CaptionFullPatch;
  FCmd.Body:=FProcedureBody;

  for F in FieldsIN do
    AssignParams(FCmd.Params.AddParam(F.FieldName), F, spvtInput);

  for F in FieldsOut do
    AssignParams(FCmd.Params.AddParam(F.FieldName), F, spvtOutput);

  FCmd.Description:=Description;

  Result:=FCmd.AsSQL;

  ACL:=TStringList.Create;
  try
    FACLList.RefreshList;
    FACLList.MakeACLListSQL(nil, ACL, true);
    Result:=Result + LineEnding + LineEnding + ACL.Text;
  finally
    ACL.Free;
  end;
  FCmd.Free;
end;

procedure TFireBirdStoredProc.RefreshParams;
var
  IBQ:TUIBQuery;
  ServerVersion:TFBServerVersion;
  S:string;
  Item: TDBField;
begin
  inherited RefreshParams;
  ServerVersion:=TSQLEngineFireBird(OwnerDB).FServerVersion;
  FFieldsIN.Clear;
  FFieldsOut.Clear;

{  S:=ssqlStoredProcParams1;
  if ServerVersion in [ gds_verFirebird2_1, gds_verFirebird2_5] then
    S:=S+', '+ssqlStoredProcParams2;
  S:=S+' '+ssqlStoredProcParamsTbl;
}
  IBQ:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(fbSqlModule.ssqlStoredProcParams.ExpandMacros);
  IBQ.Params.ByNameAsString['PROCEDURE_NAME']:=Caption;
  try
    IBQ.Open;
    while not IBQ.Eof do
    begin
      if IBQ.Fields.ByNameAsInteger['RDB$PARAMETER_TYPE'] = 0 then
      begin
        Item:=FieldsIN.Add(Trim(IBQ.Fields.ByNameAsString['RDB$PARAMETER_NAME'])); //0 - Входящий параметр
        Item.IOType:=spvtInput;
      end
      else
      begin
        Item:=FieldsOut.Add(Trim(IBQ.Fields.ByNameAsString['RDB$PARAMETER_NAME'])); //1 - Исходящий параметр
        Item.IOType:=spvtOutput;
      end;

      Item.FieldDescription:=IBQ.Fields.ByNameAsString['RDB$DESCRIPTION'];

      Item.FieldTypeDomain:=Trim(IBQ.Fields.ByNameAsString['RDB$FIELD_SOURCE']);
      Item.FieldSQLTypeInt:=IBQ.Fields.ByNameAsInteger['RDB$FIELD_TYPE'];
      Item.FieldSQLSubTypeInt:=IBQ.Fields.ByNameAsInteger['RDB$FIELD_SUB_TYPE'];

      Item.FieldTypeName:=FB_SqlTypesToString(Item.FieldSQLTypeInt,  Item.FieldSQLSubTypeInt);

      Item.FieldSize:=IBQ.Fields.ByNameAsInteger['RDB$FIELD_PRECISION'];
      Item.FieldPrec:= - IBQ.Fields.ByNameAsInteger['RDB$FIELD_SCALE'];

      if Item.FieldTypeRecord.VarLen and (IBQ.Fields.ByNameAsInteger['RDB$CHARACTER_LENGTH'] > 1) then
        Item.FieldSize:=IBQ.Fields.ByNameAsInteger['RDB$CHARACTER_LENGTH'];
(*
      if ServerVersion in [ gds_verFirebird2_1, gds_verFirebird2_5] then
      begin
        Item.FieldNotNull:=IBQ.Fields.ByNameAsInteger['RDB$NULL_FLAG'] = 1;
        Item.FDomainTypeOf:=IBQ.Fields.ByNameAsInteger['RDB$PARAMETER_MECHANISM'] = 1;
      end;
*)
      IBQ.Next;
    end;

  finally
    IBQ.Free;
  end;

end;

procedure TFireBirdStoredProc.MakeAutoGrantObject;
begin

end;

function TFireBirdStoredProc.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=TFBSQLCreateProcedure.Create(nil);
end;

constructor TFireBirdStoredProc.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  FACLList:=TFBACLList.Create(Self);
  FACLList.ObjectGrants:=[ogExecute];
end;

class function TFireBirdStoredProc.DBClassTitle: string;
begin
  Result:='StoredProcedure';
end;

procedure TFireBirdStoredProc.RefreshObject;
var
  IBQ:TUIBQuery;
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;

  IBQ:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(ssqlStoredProcRefresh);
  IBQ.Params.ByNameAsString['PROCEDURE_NAME']:=Caption;
  try
    IBQ.Open;
    FDescription:=TSQLEngineFireBird(OwnerDB).ConvertString20(IBQ.Fields.ByNameAsString['RDB$DESCRIPTION'], true);
    FProcedureBody:=TSQLEngineFireBird(OwnerDB).ConvertString20(IBQ.Fields.ByNameAsString['RDB$PROCEDURE_SOURCE'], true);
{
                '  RDB$PROCEDURES.RDB$PROCEDURE_NAME, '+
                '  RDB$PROCEDURES.RDB$PROCEDURE_ID, '+
                '  RDB$PROCEDURES.RDB$PROCEDURE_INPUTS, '+
                '  RDB$PROCEDURES.RDB$PROCEDURE_OUTPUTS, '+
                '  RDB$PROCEDURES.RDB$OWNER_NAME, '+
                '  RDB$PROCEDURES.RDB$SYSTEM_FLAG, '+
                '  RDB$PROCEDURES.RDB$PROCEDURE_TYPE, '+
                '  RDB$PROCEDURES.RDB$DEBUG_INFO '+
}
  finally
    IBQ.Free;
  end;
  RefreshParams;
end;

procedure TFireBirdStoredProc.RefreshDependencies;
begin
  TSQLEngineFireBird(OwnerDB).RefreshDependencies(Self);
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

{ TFireBirdUDF }

procedure TFireBirdUDF.ClearUdfParams;
begin
  if FUDFParamCount>0 then
    FreeMem(FUDFParams, SizeOf(TUDFParamsRecord) * FUDFParamCount);
  FUDFParamCount:=0;
  FUDFParams:=nil;
end;

function TFireBirdUDF.GetUDFParams(AItem: integer): TUDFParamsRecord;
begin
  if (AItem>=0) and (AItem<FUDFParamCount) then
    Result:=FUDFParams^[AItem]
  else
    raise Exception.Create('Arrya index error!');
end;

procedure TFireBirdUDF.InitUdfParams(ACnt: integer);
begin
  if ACnt <> FUDFParamCount then
    ClearUdfParams;
  FUDFParamCount:=ACnt;
  if ACnt>0 then
  begin
    GetMem(FUDFParams, SizeOf(TUDFParamsRecord) * FUDFParamCount);
    FillChar(FUDFParams^, SizeOf(TUDFParamsRecord) * FUDFParamCount, 0);
  end;
end;

procedure TFireBirdUDF.InternalSetDescription(ACommentOn: TSQLCommentOn);
begin
  ACommentOn.Description:=TSQLEngineFireBird(OwnerDB).ConvertString20(FDescription, false);
end;

constructor TFireBirdUDF.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  FUDFParams:=nil;
  FUDFParamCount:=0;
end;

destructor TFireBirdUDF.Destroy;
begin
  ClearUdfParams;
  inherited Destroy;
end;

procedure TFireBirdUDF.RefreshDependencies;
begin
  TSQLEngineFireBird(OwnerDB).RefreshDependencies(Self);
end;

procedure TFireBirdUDF.RefreshObject;
var
  IBQ:TUIBQuery;
  i:integer;
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;

  IBQ:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(ssqlUDFRefresh);
  IBQ.Params.ByNameAsString['function_name']:=Caption;
  IBQ.First;
  try
    IBQ.Open;
    FDescription:=TSQLEngineFireBird(OwnerDB).ConvertString20(IBQ.Fields.ByNameAsString['rdb$description'], true);
    FEntryPoint:=IBQ.Fields.ByNameAsString['RDB$ENTRYPOINT'];
    FFunctionType:=IBQ.Fields.ByNameAsInteger['RDB$FUNCTION_TYPE'];
//    FLibName:=IBQ.Fields.ByNameAsString['RDB$QUERY_NAME'];
    FLibName:=IBQ.Fields.ByNameAsString['RDB$MODULE_NAME'];
    FReturnArg:=IBQ.Fields.ByNameAsInteger['RDB$RETURN_ARGUMENT'];
    FSysFlag:=IBQ.Fields.ByNameAsInteger['RDB$SYSTEM_FLAG'];
  finally
    IBQ.Free;
  end;

  IBQ:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(ssqlUDFArgList);
  IBQ.Params.ByNameAsString['function_name']:=Caption;
  try
    IBQ.Open;
    IBQ.FetchAll;
    IBQ.First;
    InitUdfParams(IBQ.Fields.RecordCount);
    i:=0;
    while not IBQ.Eof do
    begin
      FUDFParams^[i].ArgPosition:=IBQ.Fields.ByNameAsInteger['RDB$ARGUMENT_POSITION'];
      FUDFParams^[i].CharSetId:=IBQ.Fields.ByNameAsInteger['RDB$CHARACTER_SET_ID'];
      FUDFParams^[i].Mechanism:=IBQ.Fields.ByNameAsInteger['RDB$MECHANISM'];
      FUDFParams^[i].FieldType:=IBQ.Fields.ByNameAsInteger['RDB$FIELD_TYPE'];
      FUDFParams^[i].FieldScale:=IBQ.Fields.ByNameAsInteger['RDB$FIELD_SCALE'];
      FUDFParams^[i].FieldLength:=IBQ.Fields.ByNameAsInteger['RDB$FIELD_LENGTH'];
      FUDFParams^[i].FieldSubType:=IBQ.Fields.ByNameAsInteger['RDB$FIELD_SUB_TYPE'];
      FUDFParams^[i].Precision:=IBQ.Fields.ByNameAsInteger['RDB$FIELD_PRECISION'];
      FUDFParams^[i].CharSetLength:=IBQ.Fields.ByNameAsInteger['RDB$CHARACTER_LENGTH'];
      inc(i);
      IBQ.Next;
    end;
  finally
    IBQ.Free;
  end;
end;


class function TFireBirdUDF.DBClassTitle: string;
begin
  Result:='UDF';
end;

procedure TFireBirdUDF.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);

end;

function TFireBirdUDF.CompileUDF(const AUDFName, ALibName, AEntryPoint: string;
  AResultType, AFuncType: integer): boolean;
begin
  { TODO : Необходимо реализовать компиляцию UDF для FireBird }
  Result:=false;
end;

function TFireBirdUDF.UDFParamByPosition(APosition: integer): TUDFParamsRecord;
var
  i:integer;
begin
  FillChar(Result, SizeOf(TUDFParamsRecord), 0);
  for i:=0 to FUDFParamCount - 1 do
  begin
    if FUDFParams^[i].ArgPosition = APosition then
    begin
      Result:=FUDFParams^[i];
      exit;
    end;
  end;
end;

{ TFireBirdException }

function TFireBirdException.InternalGetDDLCreate: string;
var
  R: TFBSQLCreateException;
begin
  R:=TFBSQLCreateException.Create(nil);
  R.Name:=Caption;
  R.Message:=ExceptionMsg;
  R.Description:=Description;
  Result:=R.AsSQL;
  R.Free;
end;

constructor TFireBirdException.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
  begin
    FExceptionMsg:=ADBItem.ObjData;
  end;
end;

procedure TFireBirdException.RefreshObject;
var
  IBQ:TUIBQuery;
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;

  IBQ:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(ssqlException);
  IBQ.Params.ByNameAsString['exception_name']:=Caption;
  try
    IBQ.Open;
    FExceptionMsg:=IBQ.Fields.ByNameAsString['rdb$message'];
(*    if TSQLEngineFireBird(OwnerDB).FDBCharSet <> 'UTF8' then
       FExceptionMsg:=DBCharsetToUtf8(FExceptionMsg, TSQLEngineFireBird(OwnerDB).FDBCharSet); *)
    FDescription:=TSQLEngineFireBird(OwnerDB).ConvertString20(IBQ.Fields.ByNameAsString['rdb$description'], true);
  finally
    IBQ.Free;
  end;
end;


procedure TFireBirdException.RefreshDependencies;
begin
  TSQLEngineFireBird(OwnerDB).RefreshDependencies(Self);
end;

class function TFireBirdException.DBClassTitle: string;
begin
  Result:='EXCEPTION';
end;

function TFireBirdException.CreateSQLObject: TSQLCommandDDL;
begin
  if State = sdboCreate then
    Result:=TFBSQLCreateException.Create(nil)
  else
    Result:=TFBSQLAlterException.Create(nil)
end;

{ TFireBirdGenerator }

function TFireBirdGenerator.InternalGetDDLCreate: string;
var
  R: TFBSQLCreateGenerator;
  SQLLines: TStringList;
begin
  R:=TFBSQLCreateGenerator.Create(nil);
  R.Name:=Caption;
  R.CurrentValue:=GeneratorValue;
  R.Description:=Description;

  Result:=R.AsSQL;

  if TSQLEngineFireBird(OwnerDB).ServerVersion in [gds_verFirebird3_0] then
  begin
    SQLLines:=TStringList.Create;
    try
      FACLList.RefreshList;
      FACLList.MakeACLListSQL(nil, SQLLines, true);
      Result := Result + LineEnding + LineEnding + SQLLines.Text;
    finally
      SQLLines.Free;
    end;
  end;

  R.Free;
end;

procedure TFireBirdGenerator.InternalSetDescription(ACommentOn: TSQLCommentOn);
begin
  ACommentOn.Description:=TSQLEngineFireBird(OwnerDB).ConvertString20(FDescription, false);
end;

constructor TFireBirdGenerator.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  FACLList:=TFBACLList.Create(Self);
  FACLList.ObjectGrants:=[{ ogSelect, ogUpdate,} ogUsage];
end;

procedure TFireBirdGenerator.RefreshObject;
var
  IBQ:TUIBQuery;
begin
  if State = sdboEdit then
  begin
    IBQ:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(Format(fbSqlModule.sGenerators['sGeneratorRefresh'], [DoFormatName(Caption)]));
    try
      IBQ.Open;
      FGeneratorValue:=IBQ.Fields.ByNameAsInteger['gen_value'];
      IBQ.Close;
      IBQ.SQL.Text:=fbSqlModule.sGenerators['sGeneratorDesk'];
      IBQ.Params.ByNameAsAnsiString['gen_name']:=Caption;
      IBQ.Open;
      FDescription:=TSQLEngineFireBird(OwnerDB).ConvertString20(IBQ.Fields.ByNameAsAnsiString['RDB$DESCRIPTION'], true);
      IBQ.Close;
    finally
      IBQ.Free;
    end;
  end;
  inherited RefreshObject;
end;

procedure TFireBirdGenerator.RefreshDependencies;
begin
  TSQLEngineFireBird(OwnerDB).RefreshDependencies(Self);
end;

class function TFireBirdGenerator.DBClassTitle: string;
begin
  Result:='GENERATOR';
end;

function TFireBirdGenerator.CreateSQLObject: TSQLCommandDDL;
begin
  if State = sdboCreate then
    Result:=TFBSQLCreateGenerator.Create(nil)
  else
  begin
    Result:=TFBSQLAlterGenerator.Create(nil);
    TFBSQLAlterGenerator(Result).OldDescription:=Description;
  end;
end;

{ TFireBirdDomain }

function TFireBirdDomain.InternalGetDDLCreate: string;
var
  R: TFBSQLCreateDomain;
begin
  R:=TFBSQLCreateDomain.Create(nil);
  R.Name:=Caption;
  R.DomainType:=FieldType.TypeName;
  R.TypeLen:=FieldLength;
  R.TypePrec:=FieldDecimal;
  R.NotNull:=FNotNull;
  R.CollationName:=CollationName;
  R.CheckExpression:=CheckExpression;
  R.ConstraintName:=ConstraintName;
  R.DefaultValue:=FDefaultValue;
  R.ComputedSrc:=FComputedSrc;
  //R.IsNull:=
  R.CharSetName:=CharSetName;
  R.Description:=Description;
  Result:=R.AsSQL;
  R.Free;
end;

procedure TFireBirdDomain.InternalSetDescription(ACommentOn: TSQLCommentOn);
begin
  ACommentOn.Description:=TSQLEngineFireBird(OwnerDB).ConvertString20(FDescription, false);
end;

function TFireBirdDomain.GetEnableRename: boolean;
begin
  Result:=true;
end;

function TFireBirdDomain.RenameObject(ANewName: string): Boolean;
var
  FCmd: TFBSQLAlterDomain;
  Op: TAlterDomainOperator;
begin
  if (State = sdboCreate) then
  begin
    Caption:=ANewName;
    Result:=true;
  end
  else
  begin
    FCmd:=TFBSQLAlterDomain.Create(nil);
    FCmd.Name:=Caption;
    Op:=FCmd.AddOperator(adaRenameDomain);
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

constructor TFireBirdDomain.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
end;

procedure TFireBirdDomain.RefreshDependencies;
begin
  TSQLEngineFireBird(OwnerDB).RefreshDependencies(Self);
end;

procedure TFireBirdDomain.RefreshObject;
var
  IBQ:TUIBQuery;
  S: String;
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;

  IBQ:=TSQLEngineFireBird(OwnerDB).GetUIBQuery(fbSqlModule.sqlRefreshDomain.ExpandMacros);
  IBQ.Params.ByNameAsString['FIELD_NAME']:=Caption;
  try
    IBQ.Open;
    FDescription:=TSQLEngineFireBird(OwnerDB).ConvertString20(IBQ.Fields.ByNameAsAnsiString['RDB$DESCRIPTION'], true);

    S:=Trim(TSQLEngineFireBird(OwnerDB).ConvertString20(IBQ.Fields.ByNameAsAnsiString['RDB$DEFAULT_SOURCE'], true));
    if UpperCase(Copy(S, 1, 7)) = 'DEFAULT' then
      S:=Trim(Copy(S, 8, Length(S)));
    FDefaultValue:=S;

    FComputedSrc:=TSQLEngineFireBird(OwnerDB).ConvertString20(IBQ.Fields.ByNameAsString['RDB$COMPUTED_SOURCE'], true);
    S:=Trim(TSQLEngineFireBird(OwnerDB).ConvertString20(IBQ.Fields.ByNameAsString['RDB$VALIDATION_SOURCE'], true));

    if UpperCase(Copy(S, 1, 5)) = 'CHECK' then
    begin
      S:=Trim(Copy(S, 6, Length(S)));
      if (Length(S)>2) and (S[1] = '(') and (S[Length(S)] = ')') then
        S:=Trim(Copy(S, 2, Length(S)-2));
    end;
    CheckExpression:=S;

    FSqlFieldType:=IBQ.Fields.ByNameAsInteger['RDB$FIELD_TYPE'];
    FSqlFieldSubType:=IBQ.Fields.ByNameAsInteger['RDB$FIELD_SUB_TYPE'];


    FNotNull:=IBQ.Fields.ByNameAsInteger['RDB$NULL_FLAG'] = 1;

    FFieldType:=OwnerDB.TypeList.FindTypeByID(FSqlFieldType);

    if not Assigned(FFieldType) then
      raise Exception.CreateFmt('Not found field type for %d', [FSqlFieldType]);

    if FFieldType.DBType in NumericDataTypes - IntegerDataTypes then
    begin
      FFieldLength:=IBQ.Fields.ByNameAsInteger['RDB$FIELD_PRECISION'];
      FFieldDecimal:=-IBQ.Fields.ByNameAsInteger['RDB$FIELD_SCALE'];
    end
    else
    if FFieldType.DBType in StringTypes then
    begin
      FFieldLength:=IBQ.Fields.ByNameAsInteger['RDB$CHARACTER_LENGTH'];
      FFieldDecimal:=0;
    end
    else
    begin
      if FFieldType.VarLen then
        FFieldLength:=IBQ.Fields.ByNameAsInteger['RDB$FIELD_LENGTH'];
      FFieldDecimal:=0;
    end;

    FCharSetID:=IBQ.Fields.ByNameAsInteger['RDB$CHARACTER_SET_ID'];
    FCollationID:=IBQ.Fields.ByNameAsInteger['RDB$COLLATION_ID'];

    IBQ.Close;
{    fftSmallint,
    fftInteger, fftQuad, fftFloat, fftDoublePrecision, fftTimestamp, fftBlob, fftBlobId,
    fftDate, fftTime, fftInt64, fftArray, fftBoolean}
{
                  '  RDB$FIELDS.RDB$QUERY_NAME, '+
                  '  RDB$FIELDS.RDB$MISSING_VALUE, '+
                  '  RDB$FIELDS.RDB$MISSING_SOURCE, '+

                  '  RDB$FIELDS.RDB$SYSTEM_FLAG, '+
                  '  RDB$FIELDS.RDB$QUERY_HEADER, '+
                  '  RDB$FIELDS.RDB$SEGMENT_LENGTH, '+
                  '  RDB$FIELDS.RDB$EDIT_STRING, '+
                  '  RDB$FIELDS.RDB$DIMENSIONS, '+
                  '  RDB$FIELDS., '+
                  '  RDB$FIELDS.RDB$COLLATION_ID, '+
                  '  RDB$FIELDS.RDB$CHARACTER_SET_ID, '+
}
  finally
    IBQ.Free;
  end;

end;

class function TFireBirdDomain.DBClassTitle: string;
begin
  Result:='DOMAIN';
end;

function TFireBirdDomain.CreateSQLObject: TSQLCommandDDL;
begin
  if State <> sdboCreate then
  begin
    Result:=TFBSQLAlterDomain.Create(nil);
    TFBSQLAlterDomain(Result).Name:=Caption;
  end
  else
    Result:=TFBSQLCreateDomain.Create(nil);
end;

procedure TFireBirdDomain.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
  if FDescription <> '' then
  begin
    List.Add(sDescription + ':');
    List.Add(FDescription);
  end;
end;

{ TFirebirdField }

procedure TFirebirdField.SetFieldDescription(const AValue: string);
var
  FCmd: TFBSQLCommentOn;
begin
  if AValue <> FFieldDescription then
  begin
    if Owner.State <> sdboCreate then
    begin
      FCmd:=TFBSQLCommentOn.Create(nil);
      FCmd.ObjectKind:=okColumn;
      FCmd.TableName:=Owner.Caption;
      FCmd.Name:=FieldName;
      FCmd.Description:=AValue;
      ExecSQLScript(FCmd.AsSQL, sysConfirmCompileDescEx, Owner.OwnerDB);
      FCmd.Free;
//      ExecSQLScript( Format(ssqlDecribeObject, [ 'COLUMN', Owner.Caption+'.'+FieldName, AValue]), sysConfirmCompileDescEx, Owner.OwnerDB);
    end;
    inherited SetFieldDescription(AValue);
  end;
end;

function TFirebirdField.RefreshDependenciesFromField: TStringList;
var
  IBQ: TUIBQuery;
  S: String;
begin
  IBQ:=TSQLEngineFireBird(Owner.OwnerDB).GetUIBQuery(fbSqlModule.ssqlDependOnField.ExpandMacros);
  IBQ.Params.ByNameAsAnsiString['TABLE_NAME']:=Owner.Caption;
  IBQ.Params.ByNameAsAnsiString['FIELD_NAME']:=FieldName;
  Result:=TStringList.Create;
  try
    IBQ.Open;
    while not IBQ.Eof do
    begin
      S:=Trim(IBQ.Fields.ByNameAsString['RDB$DEPENDENT_NAME']);
      Result.AddObject(S, Owner.OwnerDB.DBObjectByName(S, false));
      IBQ.Next;
    end;
  finally
    IBQ.Free;
  end;
end;

initialization

    RegisterSQLStatment(TSQLEngineFireBird, TFBSQLCreateDatabase, 'CREATE DATABASE');
    RegisterSQLStatment(TSQLEngineFireBird, TFBSQLAlterDatabase, 'ALTER DATABASE');
{
    DROP DATABASE
}
  {
SHADOW
    CREATE SHADOW
    DROP SHADOW

INDEX
    CREATE INDEX
    ALTER INDEX
    DROP INDEX
    SET STATISTICS

FILTER
    DECLARE FILTER
    DROP FILTER

}
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLCommandSelect, 'SELECT');
  RegisterSQLStatment(TSQLEngineFireBird, TSQLCommandExecuteBlock, 'EXECUTE BLOCK');
  RegisterSQLStatment(TSQLEngineFireBird, TSQLCommandInsert, 'INSERT INTO');
  RegisterSQLStatment(TSQLEngineFireBird, TSQLCommandUpdate, 'UPDATE');
  RegisterSQLStatment(TSQLEngineFireBird, TSQLCommandDelete, 'DELETE FROM');

  //DOMAIN
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLCreateDomain, 'CREATE DOMAIN'); //CREATE DOMAIN
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLAlterDomain, 'ALTER DOMAIN'); //ALTER DOMAIN
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLDropDomain, 'DROP DOMAIN'); //DROP DOMAIN

  //TABLE
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLCreateTable, 'CREATE TABLE'); //--CREATE TABLE || RECREATE TABLE
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLAlterTable, 'ALTER TABLE'); //--ALTER TABLE
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLDropTable, 'DROP TABLE');     //DROP TABLE

  //VIEW
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLCreateView, 'CREATE VIEW'); //CREATE VIEW //CREATE OR ALTER VIEW
     //ALTER VIEW
     //RECREATE VIEW
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLDropView, 'DROP VIEW'); //DROP VIEW

  //TRIGGER
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLCreateTrigger, 'CREATE TRIGGER'); //CREATE TRIGGER //CREATE OR ALTER TRIGGER
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLAlterTrigger, 'ALTER TRIGGER'); //RECREATE TRIGGER
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLDropTrigger, 'DROP TRIGGER');

  //PROCEDURE
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLCreateProcedure, 'CREATE PROCEDURE'); //CREATE PROCEDURE //CREATE OR ALTER PROCEDURE //ALTER PROCEDURE //RECREATE PROCEDURE
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLDropProcedure, 'DROP PROCEDURE'); //DROP PROCEDURE

  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLCreateFunction, 'CREATE FUNCTION'); //CREATE FUNCTION //CREATE OR ALTER FUNCTION //ALTER FUNCTION //RECREATE FUNCTION
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLDropFunction, 'DROP FUNCTION'); //DROP PROCEDURE

  //SEQUENCE (GENERATOR)
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLCreateGenerator, 'CREATE GENERATOR'); //CREATE SEQUENCE
  //SET GENERATOR
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLAlterGenerator, 'ALTER GENERATOR');   //ALTER SEQUENCE
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLDropGenerator, 'DROP GENERATOR');     //DROP SEQUENCE

  //EXCEPTION
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLCreateException, 'CREATE EXCEPTION'); //CREATE EXCEPTION //CREATE OR ALTER EXCEPTION
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLAlterException, 'ALTER EXCEPTION');   //ALTER EXCEPTION
    //RECREATE EXCEPTION
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLDropException, 'DROP EXCEPTION');     //DROP EXCEPTION

  //ROLE
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLCreateRole, 'CREATE ROLE');           //CREATE ROLE
  //ALTER ROLE
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLDropRole, 'DROP ROLE');               //DROP ROLE

  //EXTERNAL FUNCTION
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLCreateUDF, 'DECLARE EXTERNAL FUNCTION');   //DECLARE EXTERNAL FUNCTION
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLAlterUDF, 'ALTER EXTERNAL FUNCTION');      //ALTER EXTERNAL FUNCTION
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLDropUDF, 'DROP EXTERNAL FUNCTION');        //DROP EXTERNAL FUNCTION

  //CHARACTER SET
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLAlterCharset, 'ALTER CHARACTER SET');      //ALTER CHARACTER SET

  //COLLATION
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLCreateCollation, 'CREATE COLLATION');      //CREATE COLLATION
  //DROP COLLATION

  //COMMENTS
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLCommentOn, 'COMMENT ON');                  //COMMENT ON
  //GRANT
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLGrant, 'GRANT');                           //GRANT
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLRevoke, 'REVOKE');                         //REVOKE
  //SET TRANSACTION
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLSetTransaction, 'SET TRANSACTION');        //SET TRANSACTION
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLExecuteProcedure, 'EXECUTE PROCEDURE');

  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLCreateIndex, 'CREATE INDEX');
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLAlterIndex, 'ALTER INDEX');
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLDropIndex, 'DROP INDEX');

  //Package
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLCreatePackage, 'CREATE PACKAGE');
  //RegisterSQLStatment(TSQLEngineFireBird, TFBSQLAlterIndex, 'ALTER INDEX');
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLDropPackage, 'DROP PACKAGE'); //DROP PACKAGE package_name, DROP PACKAGE BODY package_name
  //SET
  RegisterSQLStatment(TSQLEngineFireBird, TFBSQLSet, 'SET');                               //SET SQL DIALECT 3;
finalization
end.


{ TODO -oalexs -cFB : Для представлений не верно отображается в автодополнении тип поля }

{
-не работает отображение калькулируемого поля в таблице
}

(*
CREATE USER username [ options_list ] [ TAGS ( tag [, tag [, tag ...]] ) ]
ALTER USER username [ SET ] [ options_list ] [ TAGS ( tag [, tag [, tag ...]] ) ]
ALTER CURRENT USER [ SET ] [ options_list ] [ TAGS ( tag [, tag [, tag ...]] ) ]
CREATE OR ALTER USER username [ SET ] [ options ] [ TAGS ( tag [, tag [, tag ...]] ) ]
DROP USER username [ USING PLUGIN plugin_name ]

CREATE [OR ALTER] | ALTER | RECREATE } PACKAGE
CREATE | RECREATE } PACKAGE BODY <name>


<database-trigger> ::=
		{CREATE | RECREATE | CREATE OR ALTER}
			TRIGGER <name>
			[ACTIVE | INACTIVE]
			{BEFORE | AFTER} <ddl event>
			[POSITION <n>]


{CREATE [OR ALTER] | ALTER | RECREATE} FUNCTION <name>
  [(param1 [, ...])]
  RETURNS <type>
  AS
  BEGIN
    ...
  END
*)
