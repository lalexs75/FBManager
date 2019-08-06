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

unit PostgreSQLEngineUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, DB, SQLEngineAbstractUnit, contnrs, sqlObjects,
  SQLEngineCommonTypesUnit, fbmSqlParserUnit, ZConnection, ZDataset, ZSqlUpdate,
  ZSqlProcessor, ZDbcCachedResultSet, ZDbcCache, pgTypes,
  SQLEngineInternalToolsUnit, fbmToolsNV, SSHConnectionUnit;


const
  PostgreSQLDefTCPPort = 5432;

type
  TTriggersLists = array [0..5] of TList;

type
  TSQLEnginePostgre = class;
  TPGSchema = class;
  TPGLanguage = class;
  TPGFunction = class;
  TPGTable = class;
  TPGMatView = class;
  TPGIndex = class;
  TPGTableSpace = class;

  { Формальное определение тригера }
  TPGTrigerDef = record
    TriggerName:string;
    TriggerType:TTriggerTypes;
    Active:boolean;
    TriggerTable:TPGTable;
    TriggerProc:TPGFunction;
    TriggerWhen:string;
    TriggerUpdFields:string;
    TriggerDesc:string;
  end;

  { TPGACLItem }

  TPGACLItem = class(TACLItem)
  protected
    function ObjectTypeName:string; override;
    function ObjectName:string; override;
  end;

  { TPGACLList }

  TPGACLList = class(TACLListAbstract)
  private
    FACLStrings: TStringList;
    function OID:integer;
    procedure DoParseLine(AAclLine:string);
  protected
    function InternalCreateACLItem: TACLItem; override;
    function InternalCreateGrantObject: TSQLCommandGrant; override;
    function InternalCreateRevokeObject: TSQLCommandGrant; override;
  public
    constructor Create(ADBObject:TDBObject); override;
    destructor Destroy; override;
    procedure LoadUserAndGroups; override;
    procedure RefreshList; override;
    procedure ParseACLListStr(ACLStr:string);
  end;

  { TPGSchemasRoot }

  TPGSchemasRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    destructor Destroy; override;
    function SchemaByOID(AOID:integer):TPGSchema;
    function PublicSchema:TPGSchema;
  end;


  { TPGTableSpaceRoot }

  TPGTableSpaceRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    destructor Destroy; override;
    function TableSpaceByOID(AOID:integer):TPGTableSpace;
  end;


  { TPGEventTriggersRoot }

  TPGEventTriggersRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    destructor Destroy; override;
  end;

  { TPGExtensionsRoot }

  TPGExtensionsRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    destructor Destroy; override;
  end;

  { TPGDBRootObject }

  TPGDBRootObject = class(TDBRootObject)
  private
    function GetSchemaId: integer;
  protected
    FSchema:TPGSchema;
  public
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject); override;
    property SchemaId:integer read GetSchemaId;
    property Schema:TPGSchema read FSchema;
  end;

  { TPGLanguageRoot }

  TPGLanguageRoot = class(TDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    function LangByOID(AOID:integer):TPGLanguage;
  end;



  { TPGDomainsRoot }

  TPGDomainsRoot = class(TPGDBRootObject)
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;


  { TPGTablesRoot }

  TPGTablesRoot = class(TPGDBRootObject)
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    function PGTableByOID(ATableOID:integer):TPGTable;
  end;

  { TPGSequencesRoot }

  TPGSequencesRoot = class(TPGDBRootObject)
  private
    //
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;


  { TPGViewsRoot }

  TPGViewsRoot = class(TPGDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;


  { TPGMatViewsRoot }

  TPGMatViewsRoot = class(TPGDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    function PGMatViewByOID(ATableOID:integer):TPGMatView;
  end;

  { TPGRulesRoot }

  TPGRulesRoot = class(TPGDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TPGTriggersRoot }

  TPGTriggersRoot = class(TPGDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;


  { TPGFunctionsRoot }

  TPGFunctionsRoot = class(TPGDBRootObject)
  private
    FProcType:integer;
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function DropObject(AItem:TDBObject):boolean; override;
    function GetObjectType: string; override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TPGTriggerProcRoot }

  TPGTriggerProcRoot = class(TPGFunctionsRoot)
  public
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TPGIndexRoot }

  TPGIndexRoot = class(TPGDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    function IndexByOID(AOID:integer):TPGIndex;
  end;


  { TPGCollationRoot }

  TPGCollationRoot = class(TPGDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TPGSchema }

  TPGSchema = class(TDBRootObject)
  private
    FACLListStr: string;
    FOwnerName: String;
    FSchemaId: integer;
    FTablesRoot:TPGTablesRoot;
    FDomainsRoot:TPGDomainsRoot;
    FSequencesRoot:TPGSequencesRoot;
    FViews:TPGViewsRoot;
    FTriggers:TPGTriggersRoot;
    FIndexs:TPGIndexRoot;
    FProcedures:TPGFunctionsRoot;
    FTriggerProc:TPGTriggerProcRoot;
    FRulesRoot:TPGRulesRoot;
    FMatViews:TPGMatViewsRoot;
    FFTSRoot:TDBRootObject;
    FCollationRoot:TPGCollationRoot;
{
    Составные типы
    Исчисляемые типы
    Базовые типы
    Агрегаты
    Операторы
}
    procedure SetSchemaId(const AValue: integer);
  protected
    function InternalGetDDLCreate: string; override;
    procedure InternalRefreshStatistic; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject); override;
    destructor Destroy; override;

    procedure FillFieldList(List:TStrings; ACharCase:TCharCaseOptions; AFullNames:Boolean);override;

    function CreateSQLObject:TSQLCommandDDL;override;

    class function DBClassTitle:string; override;
    function GetObjectType: string; override;
    procedure RefreshGroup; override;
    procedure RefreshObject; override;

    function ObjByName(AName:string; ARefreshObject:boolean = true):TDBObject;override;
    procedure RefreshDependencies; override;
    procedure RefreshDependenciesField(Rec:TDependRecord); override;
    property SchemaId:integer read FSchemaId write SetSchemaId;
    property OwnerName:String read FOwnerName;
    //Объекты
    property DomainsRoot:TPGDomainsRoot read FDomainsRoot;
    property TablesRoot:TPGTablesRoot read FTablesRoot;
    property SequencesRoot:TPGSequencesRoot read FSequencesRoot;
    property Views:TPGViewsRoot read FViews;
    property MatViews:TPGMatViewsRoot read FMatViews;
    property Triggers:TPGTriggersRoot read FTriggers;
    property Indexs:TPGIndexRoot read FIndexs;
    property Procedures:TPGFunctionsRoot read FProcedures;
    property TriggerProc:TPGTriggerProcRoot read FTriggerProc;
    property RulesRoot:TPGRulesRoot read FRulesRoot;
    property ACLListStr:string read FACLListStr;
  end;


  { TPGDomain }

  TPGDomain = class(TDBDomain)
  private
    FSchema:TPGSchema;
    FOID:integer;
  protected
    function GetCaptionFullPatch:string; override;
    function InternalGetDDLCreate: string; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure RefreshDependencies; override;
    function CreateSQLObject:TSQLCommandDDL; override;
    procedure RefreshObject; override;
    procedure SetSqlAssistentData(const List: TStrings);override;
    property Schema:TPGSchema read FSchema;
  end;


  { TPGField }

  TPGField = class(TDBField)
  private
    FDomainID:integer;
    procedure LoadfromDB(DS:TDataSet);
  protected
    procedure SetFieldDescription(const AValue: string);override;
  public
    FieldTypeShceme:integer;
    function FieldDomainName:string;
    function DDLTypeStr:string; override;
  end;

  { TPGIndexItem }

  TPGIndexItem = class(TIndexItem)
  public
    OID:integer;
    TableSpaceID:integer;
    constructor CreateFromDB(AOwner:TDBDataSetObject; DS:TDataSet);
  end;

  { TPGIndexItems }

  TPGIndexItems = class(TIndexItems)
  public
    function IndexItemByOID(AOID:Integer):TPGIndexItem;
  end;

  TPGForeignKeyRecord = class(TForeignKeyRecord)
  public
    IndexOID:integer;
  end;

  TPGRule = class(TDBObject)
  private
    FRuleAction: TPGRuleAction;
    FRuleNothing: boolean;
    FRuleSQL: string;
    FRuleWhere: string;
    FRuleWork: TPGRuleWork;
    FSchema:TPGSchema;
    FOID:integer;
    FRelID:integer;
    function GetRelObject: TDBDataSetObject;
  protected
    function InternalGetDDLCreate: string; override;
    function GetCaptionFullPatch:string; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure RefreshObject; override;
    function CreateSQLObject:TSQLCommandDDL; override;
    property RuleAction:TPGRuleAction read FRuleAction;
    property RelID:integer read FRelID;
    property RelObject:TDBDataSetObject read GetRelObject;
    property Schema:TPGSchema read FSchema;
    property RuleSQL:string read FRuleSQL;
    property RuleWhere:string read FRuleWhere;
    property RuleNothing:boolean read FRuleNothing;
    property RuleWork:TPGRuleWork read FRuleWork;
  end;

  { TPGRuleList }

  TPGRuleList = class(TList)
  private
    FSchema:TPGSchema;
    FRelation: TDBDataSetObject;
    function RelOID:integer;
    function OwnerDB:TSQLEnginePostgre;
  public
    constructor Create(const ARelation:TDBDataSetObject);
    procedure RuleListRefresh;
    function RuleNew(ARuleAction:TPGRuleAction):TPGRule;
    function RuleDrop(ARule:TPGRule):boolean;
  end;

  { TPGAutovacuumOptions }

  TPGAutovacuumOptions = class
  private
    FIsToast: Boolean;
    //
    FAnalyzeScaleFactor: Double;
    FAnalyzeThreshold: Integer;
    FEnabled: boolean;
    FFreezeMaxAge: Int64;
    FFreezeMinAge: Int64;
    FFreezeTableAge: Int64;
    FVacuumCostDelay: Integer;
    FVacuumCostLimit: Integer;
    FVacuumScaleFactor: Double;
    FVacuumThreshold: Integer;
  public
    constructor Create(AIsToast:Boolean);
    procedure LoadStorageParameters(const AStorageParameters:TStrings);
    procedure SaveStorageParameters(const AStorageParameters:TStrings);
    procedure Clear;
    property Enabled:boolean read FEnabled write FEnabled; //autovacuum_enabled=true,
    property VacuumThreshold:Integer read FVacuumThreshold write FVacuumThreshold; //autovacuum_vacuum_threshold=51,
    property VacuumScaleFactor:Double read FVacuumScaleFactor write FVacuumScaleFactor;//autovacuum_vacuum_scale_factor=0.2,
    property AnalyzeThreshold:Integer read FAnalyzeThreshold write FAnalyzeThreshold; //autovacuum_analyze_threshold=51,
    property AnalyzeScaleFactor:Double read FAnalyzeScaleFactor write FAnalyzeScaleFactor; //autovacuum_analyze_scale_factor=0.1,
    property VacuumCostDelay:Integer read FVacuumCostDelay write FVacuumCostDelay; //autovacuum_vacuum_cost_delay=20,
    property VacuumCostLimit:Integer read FVacuumCostLimit write FVacuumCostLimit; //autovacuum_vacuum_cost_limit=200,
    property FreezeMinAge:Int64 read FFreezeMinAge write FFreezeMinAge; //autovacuum_freeze_min_age=50000000,
    property FreezeMaxAge:Int64 read FFreezeMaxAge write FFreezeMaxAge; //autovacuum_freeze_max_age=200000000,
    property FreezeTableAge:Int64 read FFreezeTableAge write FFreezeTableAge; //autovacuum_freeze_table_age=150000000
  end;

  { TPGTable }

  TPGTable = class(TDBTableObject)
  private
    FACLListStr: string;
    FAutovacuumOptions: TPGAutovacuumOptions;
    FRuleList: TPGRuleList;
    FSchema:TPGSchema;
    FOID:integer;
    FStorageParameters: TStrings;
    FTableHasOIDS: boolean;
    FTableTemp: boolean;
    FTableUnloged: boolean;
    FToastAutovacuumOptions: TPGAutovacuumOptions;
    FToastRelOID: Integer;
    FToastRelOptions: String;
    FTriggerList:TTriggersLists;
    FInhTables:TList;
    ZUpdateSQL:TZUpdateSQL;
    FOwnerID:integer;
    FTableSpaceID:integer;
    FCheckConstraints:TList;
    FTableNameCreate:string;
    FRelOptions: String;
    procedure InternalCreateDLL(var SQLLines: TStringList;
      const ATableName: string);
    procedure ZUpdateSQLBeforeInsertSQLStatement(const Sender: TObject;
      StatementIndex: Integer; out Execute: Boolean);
    function MakeSQLInsertFields(AParams:boolean):string;
  protected
    function GetCaptionFullPatch:string; override;

    function GetTrigger(ACat:integer; AItem: integer): TDBTriggerObject; override;
    function GetTriggersCategories(AItem: integer): string; override;
    function GetTriggersCategoriesType(AItem: integer): TTriggerTypes;override;
    function GetTriggersCategoriesCount: integer; override;
    function GetTriggersCount(AItem: integer): integer; override;
    function InternalGetDDLCreate: string;override;
    function GetRecordCount: integer; override;
    function GetDBFieldClass: TDBFieldClass; override;
    procedure NotyfiOnDestroy(ADBObject:TDBObject); override;
    procedure InternalRefreshStatistic; override;
    procedure IndexArrayCreate; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;

    function CreateSQLObject:TSQLCommandDDL; override;

    procedure OnCloseEditorWindow; override; {???}

    function RenameObject(ANewName:string):Boolean;override;
    procedure RefreshObject; override;
    procedure RefreshDependencies; override;
    procedure RefreshDependenciesField(Rec:TDependRecord); override;

    procedure RefreshInheritedTables;
    function InheritedTablesCount:integer;
    function InheritedTable(AIndex:integer):TPGTable;

    procedure BeforeCreateObject;override;
    function AfterCreateObject:boolean;override;

    procedure RefreshFieldList; override;
    procedure SetFieldsOrder(AFieldsList:TStrings); override;

    function IndexNew:string; override;
    function IndexEdit(const IndexName:string):boolean; override;
    function IndexDelete(const IndexName:string):boolean; override;
    procedure IndexListRefresh; override;

    procedure TriggersListRefresh; override;
    procedure RecompileTriggers; override;
    procedure AllTriggersSetActiveState(AState:boolean); override;
    function TriggerNew(TriggerTypes:TTriggerTypes):TDBTriggerObject;override;
    function TriggerDelete(const ATrigger:TDBTriggerObject):Boolean;override;

    procedure RefreshConstraintPrimaryKey;override;
    procedure RefreshConstraintForeignKey;override;
    procedure RefreshConstraintUnique; override;
    procedure RefreshConstraintCheck; override;

    function DataSet(ARecCountLimit:Integer):TDataSet;override;

    property Schema:TPGSchema read FSchema;
    property OwnerID:integer read FOwnerID write FOwnerID;
    property TableSpaceID:integer read FTableSpaceID;
    property OID:integer read FOID;
    property TableHasOIDS:boolean read FTableHasOIDS;
    property TableTemp:boolean read FTableTemp;
    property TableUnloged:boolean read FTableUnloged;
    property InhTables:TList read FInhTables;
    property RuleList:TPGRuleList read FRuleList;
    property RelOptions: String read FRelOptions;
    property ToastRelOptions: String read FToastRelOptions;
    property StorageParameters:TStrings read FStorageParameters;
    property AutovacuumOptions:TPGAutovacuumOptions read FAutovacuumOptions;
    property ToastAutovacuumOptions:TPGAutovacuumOptions read FToastAutovacuumOptions;
    property ToastRelOID:Integer read FToastRelOID;
    property ACLListStr:string read FACLListStr;
  end;


  { TPGView }

  TPGView = class(TDBViewObject)
  private
    FACLListStr: string;
    FRelOptions: String;
    FSchema:TPGSchema;
    FOID:integer;
    FRuleList:TPGRuleList;
    FStorageParameters: TStrings;
    FToastRelOID: Integer;
    FToastRelOptions: String;
  protected
    function GetDDLAlter : string; override;
    function InternalGetDDLCreate: string; override;
    function GetCaptionFullPatch:string; override;
    function GeTDBFieldClass: TDBFieldClass; override;
    procedure NotyfiOnDestroy(ADBObject:TDBObject);override;
    property ToastRelOID:Integer read FToastRelOID;
    property ToastRelOptions: String read FToastRelOptions;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure RefreshObject; override;
    procedure RefreshFieldList; override;
    procedure RefreshDependencies; override;
    procedure RefreshDependenciesField(Rec:TDependRecord); override;
    function CreateSQLObject:TSQLCommandDDL; override;
    function CompileSQLObject(ASqlObject:TSQLCommandDDL; ASqlExecParam:TSqlExecParams = [sepShowCompForm]):boolean;override;

    function TriggerNew(TriggerTypes:TTriggerTypes):TDBTriggerObject;override;
    procedure Commit;override;
    procedure RollBack;override;
    function DataSet(ARecCountLimit:Integer):TDataSet;override;
    property Schema:TPGSchema read FSchema;
    property RuleList:TPGRuleList read FRuleList;
    property OID:integer read FOID;
    property RelOptions: String read FRelOptions;
    property StorageParameters:TStrings read FStorageParameters;
    property ACLListStr:string read FACLListStr;
  end;

  TPGMatView = class(TPGView)
  private
    FAutovacuumOptions: TPGAutovacuumOptions;
    FToastAutovacuumOptions: TPGAutovacuumOptions;
  protected
    function GetDDLAlter : string; override;
    function InternalGetDDLCreate: string; override;
    procedure IndexArrayCreate; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    function CreateSQLObject:TSQLCommandDDL; override;
    function CompileSQLObject(ASqlObject:TSQLCommandDDL; ASqlExecParam:TSqlExecParams = [sepShowCompForm]):boolean;override;

    procedure RefreshObject; override;
    function IndexNew:string; override;
    function IndexEdit(const IndexName:string):boolean; override;
    function IndexDelete(const IndexName:string):boolean; override;
    procedure IndexListRefresh; override;
    property AutovacuumOptions:TPGAutovacuumOptions read FAutovacuumOptions;
    property ToastAutovacuumOptions:TPGAutovacuumOptions read FToastAutovacuumOptions;
    property ToastRelOID;
    property ToastRelOptions;
  end;

  { TPGSequence }

  TPGSequence = class(TDBObject)
  private
    FACLListStr: string;
    FCasheValue: Integer;
    FIncByValue: Int64;
    FIsCycled: boolean;
    FLastValue: Int64;
    FMaxValue: Int64;
    FMinValue: Int64;
    FSchema:TPGSchema;
    FOID:integer;
    FStartValue: Int64;
  protected
    function InternalGetDDLCreate: string; override;
    function GetCaptionFullPatch:string; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    class function DBClassTitle:string;override;
    procedure SetSqlAssistentData(const List: TStrings);override;

    function CreateSQLObject:TSQLCommandDDL; override;

    procedure RefreshObject;override;
    procedure RefreshDependencies; override;
    procedure RefreshDependenciesField(Rec:TDependRecord); override;

    property LastValue:Int64 read FLastValue;
    property StartValue:Int64 read FStartValue;
    property MinValue:Int64 read FMinValue;
    property MaxValue:Int64 read FMaxValue;
    property IncByValue:Int64 read FIncByValue;
    property CasheValue:Integer read FCasheValue;
    property IsCycled:boolean read FIsCycled;
    property Schema:TPGSchema read FSchema;
    property ACLListStr:string read FACLListStr;
  end;


  { TPGTrigger }

  TPGTrigger = class(TDBTriggerObject)
  private
    FSchema:TPGSchema;
    FOID:integer;
    FTriggerWhen: string;
    FTrigSPId:integer;
    FTrigTableId:integer;
    FTriggerSP:TPGFunction;
    FUpdateFieldsWhere: TStrings;
    function GetTriggerSP: TPGFunction;
    function GetTriggerSPName: string;
    procedure SetTriggerSPName(const AValue: string);
    procedure SetTriggerSPId(ASpId:integer);
    procedure SetTriggerTableId(ATableId:integer);
  protected
    function InternalGetDDLCreate: string;override;
    function GetTableName: string;override;
    procedure SetActive(const AValue: boolean); override;
    procedure InternalRefreshStatistic; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure SetSqlAssistentData(const List: TStrings);override;
    procedure RefreshObject; override;
    procedure RefreshDependencies; override;
    procedure RefreshDependenciesField(Rec:TDependRecord); override;

    function CreateSQLObject:TSQLCommandDDL; override;
    function CompileSQLObject(ASqlObject:TSQLCommandDDL; ASqlExecParam:TSqlExecParams = [sepShowCompForm]):boolean; override;
    property TriggerSPName:string read GetTriggerSPName write SetTriggerSPName;
    property TriggerSP:TPGFunction read  GetTriggerSP;
    property Schema:TPGSchema read FSchema;
    property TriggerWhen:string read FTriggerWhen;
    property UpdateFieldsWhere:TStrings read FUpdateFieldsWhere;
  end;


  { TPGEventTrigger }

  TPGEventTrigger = class(TDBTriggerObject)
  private
    FOID:integer;
    FTriggerEvent: string;
    FTriggerWhen: string;
    FTrigSPId:integer;
    FTriggerSP:TPGFunction;
    function GetTriggerSP: TPGFunction;
    function GetTriggerSPName: string;
    procedure SetTriggerSPName(const AValue: string);
    procedure SetTriggerSPId(ASpId:integer);
  protected
    function InternalGetDDLCreate: string;override;
    procedure SetActive(const AValue: boolean); override;
    procedure InternalRefreshStatistic; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    function CreateSQLObject:TSQLCommandDDL; override;
    function CompileSQLObject(ASqlObject:TSQLCommandDDL; ASqlExecParam:TSqlExecParams = [sepShowCompForm]):boolean; override;
    procedure SetSqlAssistentData(const List: TStrings);override;
    procedure RefreshObject; override;
    procedure RefreshDependencies; override;

    property TriggerWhen:string read FTriggerWhen;
    property TriggerEvent:string read FTriggerEvent;
    property TriggerSPName:string read GetTriggerSPName write SetTriggerSPName;
    property TriggerSP:TPGFunction read  GetTriggerSP;
  end;

  TPGFunction = class(TDBStoredProcObject)
  private
    FACLListStr: string;
    FAVGRows: integer;
    FAVGTime: integer;
    FisStrict: boolean;
    FisWindow: boolean;
    FLanguage: TPGLanguage;
    FLanguageOID: integer;
    FResultType: TDBField;
    FReturnSetType: boolean;
    FReturnTypeOID: integer;
    FSchema:TPGSchema;
    FOID:integer;
    FVolatilityCategories: TPGSPVolatCat;
    function GetNameWithParams:string;
    procedure DoInitInParams(AParamsArray:string);
  protected
    procedure InternalInitACLList; virtual;
    procedure InternalSetDescription(ACommentOn: TSQLCommentOn);override;
    function GetCaptionFullPatch:string; override;
    function InternalGetDDLCreate: string; override;
    function GetEnableRename: boolean; override;
    procedure InternalRefreshStatistic; override;
    function MakeChildList:TStrings; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    function RenameObject(ANewName:string):Boolean; override;
    class function DBClassTitle:string;override;
    procedure SetSqlAssistentData(const List: TStrings);override;
    function CompileProc(PrcName, PrcParams, aSql:string; ADropBeforCompile:boolean):boolean;
    procedure RefreshObject; override;
    procedure RefreshDependencies; override;
    procedure RefreshDependenciesField(Rec:TDependRecord); override;
    procedure FillFieldList(List:TStrings; ACharCase:TCharCaseOptions; AFullNames:Boolean);override;
    procedure MakeSQLStatementsList(AList:TStrings); override;

    function CompileSQLObject(ASqlObject:TSQLCommandDDL; ASqlExecParam:TSqlExecParams):boolean;override;
    function CreateSQLObject:TSQLCommandDDL; override;

    property VolatilityCategories:TPGSPVolatCat read FVolatilityCategories;
    property isWindow:boolean read FisWindow;
    property Language:TPGLanguage read FLanguage;
    property LanguageOID:integer read FLanguageOID;
    property ReturnTypeOID:integer read FReturnTypeOID;
    property isStrict:boolean read FisStrict;
    property ResultType:TDBField read FResultType;
    property AVGTime:integer read FAVGTime;
    property AVGRows:integer read FAVGRows;
    property Schema:TPGSchema read FSchema;
    property ReturnSetType:boolean read FReturnSetType; { TODO : В дальнейшем необходимо доработать вид возврата - таблица }
    property FieldsIN;
    property ACLListStr:string read FACLListStr;
  end;

  { TPGTriggerFunction }

  TPGTriggerFunction = class(TPGFunction)
  protected
    procedure InternalInitACLList; override;
  end;

  { TPGIndex }
  TPGIndex = class(TDBIndex)
  private
    FAccessMetod: string;
    FIndexCluster: boolean;
    FIndexExpression: string;
    FIndexUnique: boolean;
    FPGTableID: integer;
    FPGTableSpace: TPGTableSpace;
    FPGTableSpaceID: integer;
    FSchema:TPGSchema;
    FOID:integer;
    procedure SetPGTable(const AValue: TDBDataSetObject);
  protected
    function InternalGetDDLCreate: string; override;
    function GetCaptionFullPatch:string; override;
    procedure InternalRefreshStatistic; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure SetSqlAssistentData(const List: TStrings);override;
    procedure RefreshObject;override;
    procedure RefreshDependencies; override;
    procedure RefreshDependenciesField(Rec:TDependRecord); override;
    function CreateSQLObject:TSQLCommandDDL; override;

    property Schema:TPGSchema read FSchema;
    property PGTableID:integer read FPGTableID;
    property PGTableSpace:TPGTableSpace read FPGTableSpace;
    property PGTableSpaceID:integer read FPGTableSpaceID;
    property IndexUnique:boolean read FIndexUnique;
    property IndexCluster:boolean read FIndexCluster;
    property AccessMetod:string read FAccessMetod;
    property IndexExpression:string read FIndexExpression;
  end;

  TPGLanguage = class(TDBObject)
  private
    FACLListStr: string;
    FOID:integer;
  protected
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure RefreshObject;override;
    procedure SetSqlAssistentData(const List: TStrings);override;
    procedure RefreshDependencies; override;
    procedure RefreshDependenciesField(Rec:TDependRecord); override;
    property ACLListStr:string read FACLListStr;
  end;

  TPGTableSpace = class(TDBObject)
  private
    FACLListStr: string;
    FFolderName: string;
    FOID:integer;
    FOwnerID: integer;
    function GetOwnerUser: TDBObject;
    function GetOwnerUserName: string;
  protected
    function InternalGetDDLCreate: string; override;
    procedure InternalRefreshStatistic; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure SetSqlAssistentData(const List: TStrings);override;
    procedure RefreshObject; override;
    procedure RefreshDependencies; override;
    procedure RefreshDependenciesField(Rec:TDependRecord); override;
    function CreateSQLObject:TSQLCommandDDL; override;

    property OID:integer read FOID;
    property OwnerID:integer read FOwnerID;
    property OwnerUserName:string read GetOwnerUserName;
    property FolderName:string read FFolderName;
    property OwnerUser:TDBObject read GetOwnerUser;
    property ACLListStr:string read FACLListStr;
  end;

  TPGCollation = class(TDBObject)
  private
    FOID:integer;
  protected
    function InternalGetDDLCreate: string; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    function CreateSQLObject:TSQLCommandDDL; override;
    procedure RefreshObject; override;
    procedure RefreshDependencies; override;
    procedure RefreshDependenciesField(Rec:TDependRecord); override;
  end;


  TPGExtension = class(TDBObject)
  private
    FOID:integer;
    FSchemaID:integer;
    FVersion: string;
    function GetSchemaName: string;
  protected
    function InternalGetDDLCreate: string; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;

    function CreateSQLObject:TSQLCommandDDL; override;
    procedure RefreshObject; override;

    property Version:string read FVersion;
    property SchemaID:Integer read FSchemaID;
    property SchemaName:string read GetSchemaName;
  end;

  { TSQLEnginePostgre }

  TSQLEnginePostgre = class(TSQLEngineAbstract)
  private
    FPGConnection: TZConnection;
    FPGSysDB: TZConnection; //Connection to system 'postgres' database
    FServerVersion: TPGServerVersion;
    //FSSHConnectionPlugin: TSSHConnectionPlugin;
  private
    //Для ускорения работы
    FIDTypeTrigger:integer; //Переменная для привязки типа функции-тригера к данным в БД
    FIDTypeEventTrigger:integer; //Переменная для привязки типа функции-тригера к данным в БД
    FIDTypeFDWHandler:integer;
    FIDTypeLangHandler:integer;
    FAccessMethod: TStringList;
  private
    FSchemasRoot:TPGSchemasRoot;
    FSecurityRoot:TDBRootObject;//TPGSecurityRoot;
    FTableSpaceRoot:TPGTableSpaceRoot;
    FLanguageRoot:TPGLanguageRoot;
    FTasks:TDBRootObject;//TPGTaskRoot;
    FEventTriggers:TPGEventTriggersRoot;
    FExtensions:TPGExtensionsRoot;
    FForeignDataWR:TPGDBRootObject;
  private
    procedure DoInitPGEngine;
    procedure FillFieldTypeCodes;
    procedure ClearUserTypes;
    function IsTasksExists:boolean;
    procedure DoInitPGTasks;
    procedure UpdatePGProtocol;
    procedure RefreshAutovacuumOptions;
  protected
    function GetImageIndex: integer;override;

    //procedure SetConnected(const AValue: boolean);override;
    function InternalSetConnected(const AValue: boolean):boolean; override;
    procedure InitGroupsObjects;override;
    procedure DoneGroupsObjects;override;

    function GetCharSet: string;override;
    procedure SetCharSet(const AValue: string);override;
    //
    procedure InitKeywords;
    procedure RefreshDependencies(const ADBObject:TDBObject; AOID:integer);
    function GetServerInfoVersion : string; override;
  private
    FAutovacuumOptions: TPGAutovacuumOptions;
    FRealServerVersion: Integer;
    FRealServerVersionMajor: Integer;
    FRealServerVersionMinor: Integer;
    FUsePGShedule: Boolean;
    //
    FOnExecuteSqlScriptProcessEvent:TExecuteSqlScriptProcessEvent;
    function GetAutovacuumOptions: TPGAutovacuumOptions;
    function GetUsePGBouncer: Boolean;
    procedure OnSQLScriptDirective(Sender: TObject; Directive, Argument: AnsiString; var StopExecution: Boolean);
    procedure SetUsePGBouncer(AValue: Boolean);
    procedure ZSQLProcessorAfterExecute(Processor: TZSQLProcessor; StatementIndex: Integer);
  public
    constructor Create; override;
    destructor Destroy; override;
    function GetMetaSQLText(sqlId:integer):string;override;
    procedure Load(const AData: TDataSet);override;
    procedure Store(const AData: TDataSet);override;
    procedure RefreshObjectsBegin(const ASQLText:string);override;

    property ServerVersion:TPGServerVersion read FServerVersion write FServerVersion;
    property RealServerVersionMinor:Integer read FRealServerVersionMinor;
    property RealServerVersionMajor:Integer read FRealServerVersionMajor;
    property RealServerVersion:Integer read FRealServerVersion;

    function GetSQLQuery(ASql:string):TZQuery;
    function GetSQLSysQuery(ASql:string):TZQuery;
    function ExecuteSQLScript(const ASQL: string; OnExecuteSqlScriptProcessEvent:TExecuteSqlScriptProcessEvent):Boolean; override;
    procedure SetSqlAssistentData(const List: TStrings); override;
    procedure FillCharSetList(const List: TStrings); override;
    function OpenDataSet(Sql:string; AOwner:TComponent):TDataSet;override;
    function ExecSQL(const Sql:string;const ExecParams:TSqlExecParams):boolean;override;
    function ExecSysSQL(const Sql:string):boolean;
    function SQLPlan(aDataSet:TDataSet):string;override;
    function GetQueryControl:TSQLQueryControl;override;

    //Работа с типами полей и с доменами
    procedure FillDomainsList(const Items:TStrings; const ClearItems:boolean);override;
    function FindDomainByID(OID:integer):TPGDomain;
    function FindTableByID(OID:integer):TPGTable;
    function FindUserByID(OID:integer):TDBObject;
    function FindUsrGroupByID(OID:integer):TDBObject;
    function FindIndexByID(OID:integer):TPGIndex;
    function DBObjectByName(AName:string; ARefreshObject:boolean = true):TDBObject;override;

    procedure RefreshObjectsBeginFull;override;
    procedure RefreshObjectsEndFull;override;

(*    //Create connection dialog functions
    function ShowObjectItem:integer;override;
    procedure ShowObjectGetItem(Item:integer; out ItemName:string; out ItemValue:boolean);override;
    procedure ShowObjectSetItem(Item:integer; ItemValue:boolean);override;
*)
    procedure AccessMethodList(const AList:TStrings; ARefresh:Boolean = false);

    //
    class function GetEngineName: string; override;
    property PGConnection: TZConnection read FPGConnection;
    property PGSysDB: TZConnection read  FPGSysDB;
    property SchemasRoot:TPGSchemasRoot read FSchemasRoot;
    property LanguageRoot:TPGLanguageRoot read FLanguageRoot;
    property TableSpaceRoot:TPGTableSpaceRoot read FTableSpaceRoot;
    property SecurityRoot:TDBRootObject read FSecurityRoot;
    property UsePGShedule:Boolean read FUsePGShedule write FUsePGShedule;
    property EventTriggers:TPGEventTriggersRoot read FEventTriggers;
    property UsePGBouncer:Boolean read GetUsePGBouncer write SetUsePGBouncer;
    property AutovacuumOptions:TPGAutovacuumOptions read GetAutovacuumOptions;
    //property ServerVersion
    property IDTypeTrigger:integer read FIDTypeTrigger;           //Переменная для привязки типа функции-тригера к данным в БД
    property IDTypeEventTrigger:integer read FIDTypeEventTrigger; //Переменная для привязки типа функции-тригера к данным в БД
    property IDTypeFDWHandler:integer read FIDTypeFDWHandler;     //Переменная для привязки типа функции-обаботчика FDW (обёртки внешних данных) к данным в БД
    property IDTypeLangHandler:integer read FIDTypeLangHandler;   //Переменная для привязки типа функции-обаботчика языка к данным в БД
  end;

  { TPGQueryControl }

  TPGQueryControl = class(TSQLQueryControl)
  private
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
    constructor Create(AOwner:TSQLEngineAbstract); override;
    destructor Destroy; override;
    function IsEditable:boolean;override;
    procedure CommitTransaction;override;
    procedure RolbackTransaction;override;
    procedure FetchAll;override;
    procedure Prepare;override;
    procedure ExecSQL;override;
  end;

function FmtObjName(const ASch:TPGSchema; const AObj:TDBObject):string;
implementation
uses
  rxlogging, rxdbutils,
  fbmStrConstUnit, pg_sql_lines_unit, LazUTF8, fbmSQLTextCommonUnit, pgSQLEngineFDW,
  PGKeywordsUnit, pgSqlEngineSecurityUnit, pg_utils, strutils, pgSqlTextUnit, ZSysUtils,
  rxstrutils, pg_SqlParserUnit, pg_tasks, pgSQLEngineFTS;

function FmtObjName(const ASch:TPGSchema; const AObj:TDBObject):string;
begin
  if Assigned(ASch) then
    Result:=DoFormatName(ASch.Caption, false) + '.'+DoFormatName(AObj.Caption, false)
  else
    Result:=DoFormatName(AObj.Caption, false);
end;

function ExtractObjectName(const AName:string):string;
var
  L:integer;
begin
  L:=Pos('.', AName);
  if L>0 then
    Result:=Copy(AName, L+1, Length(AName))
  else
    Result:=AName;
end;

{ TPGIndexItems }

function TPGIndexItems.IndexItemByOID(AOID: Integer): TPGIndexItem;
var
  I: TIndexItem;
begin
  Result:=nil;
  for I in Self do
    if TPGIndexItem(I).OID = AOID then
      Exit(TPGIndexItem(I));
end;

{ TPGTriggerFunction }

procedure TPGTriggerFunction.InternalInitACLList;
begin
  //
end;

{ TPGAutovacuumOptions }

constructor TPGAutovacuumOptions.Create(AIsToast: Boolean);
begin
  inherited Create;
  FIsToast:=AIsToast;
  Clear;
end;

procedure TPGAutovacuumOptions.LoadStorageParameters(
  const AStorageParameters: TStrings);
begin
  FEnabled:=StrToBoolDef(AStorageParameters.Values['autovacuum_enabled'], false);
  FVacuumThreshold:=StrToIntDef(AStorageParameters.Values['autovacuum_vacuum_threshold'], -1);
  FVacuumScaleFactor:=StrToFloatExDef(AStorageParameters.Values['autovacuum_vacuum_scale_factor'], -1);
  if not FIsToast then
  begin
    FAnalyzeScaleFactor:=StrToFloatExDef(AStorageParameters.Values['autovacuum_analyze_scale_factor'], -1);
    FAnalyzeThreshold:=StrToIntDef(AStorageParameters.Values['autovacuum_analyze_threshold'], -1);
  end;

  FVacuumCostDelay:=StrToIntDef(AStorageParameters.Values['autovacuum_vacuum_cost_delay'], -1);
  FVacuumCostLimit:=StrToIntDef(AStorageParameters.Values['autovacuum_vacuum_cost_limit'], -1);
  FFreezeMinAge:=StrToInt64Def(AStorageParameters.Values['autovacuum_freeze_min_age'], -1);
  FFreezeMaxAge:=StrToInt64Def(AStorageParameters.Values['autovacuum_freeze_max_age'], -1);
  FFreezeTableAge:=StrToInt64Def(AStorageParameters.Values['autovacuum_freeze_table_age'], -1);
end;

procedure TPGAutovacuumOptions.SaveStorageParameters(
  const AStorageParameters: TStrings);
var
  SToast: String;
begin
  if FIsToast then
    SToast:='toast.'
  else
    SToast:='';

  AStorageParameters.Values[SToast + 'autovacuum_enabled']:=BoolToStr(FEnabled, true);
  if FVacuumThreshold > -1 then
    AStorageParameters.Values[SToast + 'autovacuum_vacuum_threshold']:=IntToStr(FVacuumThreshold);
  if FVacuumScaleFactor > -1 then
    AStorageParameters.Values[SToast + 'autovacuum_vacuum_scale_factor']:=FloatToStrEx(FVacuumScaleFactor);

  if not FIsToast then
  begin
    if FAnalyzeThreshold>-1 then
      AStorageParameters.Values['autovacuum_analyze_threshold']:=IntToStr(FAnalyzeThreshold);
    if FAnalyzeScaleFactor>-1 then
      AStorageParameters.Values['autovacuum_analyze_scale_factor']:=FloatToStrEx(FAnalyzeScaleFactor);
  end;

  if FVacuumCostDelay > -1 then
    AStorageParameters.Values[SToast + 'autovacuum_vacuum_cost_delay']:=IntToStr(FVacuumCostDelay);
  if FVacuumCostLimit > -1 then
    AStorageParameters.Values[SToast + 'autovacuum_vacuum_cost_limit']:=IntToStr(FVacuumCostLimit);
  if FFreezeMinAge > -1 then
    AStorageParameters.Values[SToast + 'autovacuum_freeze_min_age']:=IntToStr(FFreezeMinAge);
  if FFreezeMaxAge > -1 then
    AStorageParameters.Values[SToast + 'autovacuum_freeze_max_age']:=IntToStr(FFreezeMaxAge);
  if FFreezeTableAge > -1 then
    AStorageParameters.Values[SToast + 'autovacuum_freeze_table_age']:=IntToStr(FFreezeTableAge);
end;

procedure TPGAutovacuumOptions.Clear;
begin
  FEnabled:=false;
  FVacuumThreshold:=-1;
  FVacuumScaleFactor:=-1;
  FAnalyzeThreshold:=-1;
  FAnalyzeScaleFactor:=-1;
  FVacuumCostDelay:=-1;
  FVacuumCostLimit:=-1;
  FFreezeMinAge:=-1;
  FFreezeMaxAge:=-1;
  FFreezeTableAge:=-1;
end;

{ TPGCollation }

function TPGCollation.InternalGetDDLCreate: string;
begin
  Result:='';
end;

constructor TPGCollation.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
end;

destructor TPGCollation.Destroy;
begin
  inherited Destroy;
end;

class function TPGCollation.DBClassTitle: string;
begin
  Result:='Collation';
end;

function TPGCollation.CreateSQLObject: TSQLCommandDDL;
begin
  if State = sdboCreate then
    Result:=TPGSQLCreateCollation.Create(nil)
  else
    Result:=TPGSQLAlterCollation.Create(nil);
end;

procedure TPGCollation.RefreshObject;
begin
  inherited RefreshObject;
end;

procedure TPGCollation.RefreshDependencies;
begin
  inherited RefreshDependencies;
end;

procedure TPGCollation.RefreshDependenciesField(Rec: TDependRecord);
begin
  inherited RefreshDependenciesField(Rec);
end;

{ TPGCollationRoot }

function TPGCollationRoot.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.pgCollations.Strings.Text;
end;

function TPGCollationRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.SchemeID = SchemaId);
end;

function TPGCollationRoot.GetObjectType: string;
begin
  Result:='Collation';
end;

constructor TPGCollationRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okCollation;
  FDropCommandClass:=TPGSQLDropCollation;
end;


{ TPGExtension }

constructor TPGExtension.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
    FOID:=ADBItem.ObjId;
end;

destructor TPGExtension.Destroy;
begin
  inherited Destroy;
end;

class function TPGExtension.DBClassTitle: string;
begin
  Result:='Extension';
end;

function TPGExtension.CreateSQLObject: TSQLCommandDDL;
begin
  if State = sdboCreate then
    Result:=TPGSQLCreateExtension.Create(nil)
  else
    Result:=TPGSQLAlterExtension.Create(nil)
end;

procedure TPGExtension.RefreshObject;
var
  Q: TZQuery;
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;

  Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(pgSqlTextModule.pgExtension.Strings.Text);
  try
    Q.ParamByName('oid').AsInteger:=FOID;
    Q.Open;
    if Q.RecordCount>0 then
    begin
      FVersion:=Q.FieldByName('extversion').AsString;
      FSchemaID:=Q.FieldByName('extnamespace').AsInteger;
(*
      pg_extension.extname,
      pg_extension.extowner,
      pg_extension.extnamespace,
      pg_extension.extrelocatable,
      pg_extension.extversion,
      pg_extension.extconfig,
      pg_extension.extcondition
*)
      FDescription:=Q.FieldByName('description').AsString;
    end;
  finally
    Q.Free;
  end;
end;

function TPGExtension.GetSchemaName: string;
var
  Sc: TPGSchema;
begin
  Sc:=TSQLEnginePostgre(OwnerDB).SchemasRoot.SchemaByOID(FSchemaID);
  if Assigned(Sc) then
    Result:=Sc.Caption
  else
    Result:='';
end;

function TPGExtension.InternalGetDDLCreate: string;
var
  FCmd: TPGSQLCreateExtension;
begin
  FCmd:=TPGSQLCreateExtension.Create(nil);
  FCmd.Name:=Caption;
  FCmd.Options:=[ooIfNotExists];

  FCmd.ExistsWith:=true;
  FCmd.SchemaName:=SchemaName;
  FCmd.Version:='"'+FVersion+'"';
  FCmd.OldVersion:='';
  FCmd.Description:=Description;

  Result:=FCmd.AsSQL;
  FreeAndNil(FCmd);
end;

{ TPGExtensionsRoot }

function TPGExtensionsRoot.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.pgExtensions.Strings.Text;
end;

function TPGExtensionsRoot.GetObjectType: string;
begin
  Result:='Extensions';
end;

constructor TPGExtensionsRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okExtension;
  FDropCommandClass:=TPGSQLDropExtension;
end;

destructor TPGExtensionsRoot.Destroy;
begin
  inherited Destroy;
end;

{ TPGMatView }

function TPGMatView.GetDDLAlter: string;
var
  FCmd: TPGSQLCreateMaterializedView;
  F: TDBField;
begin
  if Fields.Count = 0 then RefreshFieldList;
  FCmd:=TPGSQLCreateMaterializedView.Create(nil);
  FCmd.Name:=Caption;
  FCmd.SchemaName:=FSchema.Caption;
  for F in Fields do
    FCmd.Fields.AddParam(F.FieldName);

  FCmd.SQLSelect:=SQLBody;
  Result:=FCmd.AsSQL;
  FCmd.Free;
end;

function TPGMatView.InternalGetDDLCreate: string;
var
  FCmd: TPGSQLCreateMaterializedView;
  F: TDBField;
  R: TSQLParserField;
  ACL: TStringList;
begin
  if Fields.Count = 0 then RefreshFieldList;
  FCmd:=TPGSQLCreateMaterializedView.Create(nil);
  FCmd.Name:=Caption;
  FCmd.SchemaName:=FSchema.Caption;
  for F in Fields do
  begin
    R:=FCmd.Fields.AddParam(F.FieldName);
    R.Description:=F.FieldDescription;
  end;

  FCmd.SQLSelect:=SQLBody;
  FCmd.Description:=Description;

  if FAutovacuumOptions.Enabled then
    AutovacuumOptions.SaveStorageParameters(FCmd.StorageParameters);
  if FToastAutovacuumOptions.Enabled then
    FToastAutovacuumOptions.SaveStorageParameters(FCmd.StorageParameters);

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

procedure TPGMatView.IndexArrayCreate;
begin
  FIndexItems:=TPGIndexItems.Create(TPGIndexItem);
end;

constructor TPGMatView.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject
  );
begin
  inherited Create(ADBItem, AOwnerRoot);
  FAutovacuumOptions:=TPGAutovacuumOptions.Create(false);
  FToastAutovacuumOptions:=TPGAutovacuumOptions.Create(false);
  UITableOptions:=[];
  //TPGSQLCreateMaterializedView
end;

destructor TPGMatView.Destroy;
begin
  FreeAndNil(FAutovacuumOptions);
  FreeAndNil(FToastAutovacuumOptions);
  inherited Destroy;
end;

class function TPGMatView.DBClassTitle: string;
begin
  Result:='Materialized View'
end;

function TPGMatView.CreateSQLObject: TSQLCommandDDL;
begin
  if State <> sdboCreate then
  begin
    Result:=TPGSQLAlterMaterializedView.Create(nil);
    TPGSQLCreateMaterializedView(Result).SchemaName:=FSchema.Caption;
  end
  else
  begin
    Result:=TPGSQLCreateMaterializedView.Create(nil);
    TPGSQLCreateMaterializedView(Result).SchemaName:=FSchema.Caption;
  end;
  Result.Name:=Caption;
end;

function TPGMatView.CompileSQLObject(ASqlObject: TSQLCommandDDL;
  ASqlExecParam: TSqlExecParams): boolean;
begin
  TPGSQLCreateMaterializedView(ASqlObject).SchemaName:=FSchema.Caption;
  Result:=inherited CompileSQLObject(ASqlObject, ASqlExecParam);
end;

procedure TPGMatView.RefreshObject;
var
  St: TStringList;
  S: String;
begin
  FAutovacuumOptions.Clear;
  inherited RefreshObject;
  if FStorageParameters.Count > 0 then
    FAutovacuumOptions.LoadStorageParameters(FStorageParameters);

  if ToastRelOptions <> '' then
  begin
    St:=TStringList.Create;
    try
      ParsePGArrayString(ToastRelOptions, St);
      FToastAutovacuumOptions.LoadStorageParameters(St);
      for S in St do
        FStorageParameters.Add('toast.' + S);
    finally
      St.Free;
    end;
  end;
end;

function TPGMatView.IndexNew: string;
var
  R: TDBObject;
begin
  Result:='';
  R:=OwnerDB.CreateObject(okIndex, FSchema.Indexs);
  if Assigned(R) and (R is TPGIndex) then
  begin
    TPGIndex(R).SetPGTable(Self);
    R.RefreshEditor;
  end;
end;

function TPGMatView.IndexEdit(const IndexName: string): boolean;
var
  P:TPGIndex;
begin
  Result:=false;
  P:=TPGIndex(Schema.Indexs.ObjByName(IndexName));
  if Assigned(P) then
    P.Edit;
end;

function TPGMatView.IndexDelete(const IndexName: string): boolean;
var
  Ind:TPGIndex;
begin
  Ind:=TPGIndex(FSchema.Indexs.ObjByName(IndexName));
  if Assigned(Ind) then
    Result:=FSchema.Indexs.DropObject(Ind)
  else
    Result:=false;
end;

procedure TPGMatView.IndexListRefresh;
var
  FQuery:TZQuery;
  Rec:TPGIndexItem;
begin
  IndexArrayClear;
  FQuery:=TSQLEnginePostgre(OwnerDB).GetSQLQuery( pgSqlTextModule.sqlIndexTable.Strings.Text);
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
  end;
  FIndexListLoaded:=true;
end;

{ TPGMatViewsRoot }

function TPGMatViewsRoot.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.sql_PG_ObjListAll.Strings.Text;
end;

function TPGMatViewsRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.ObjType = 'm') and (AItem.SchemeID = SchemaId);
end;

function TPGMatViewsRoot.GetObjectType: string;
begin
  Result:='Materialized View';
end;

constructor TPGMatViewsRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okMaterializedView;
  FDropCommandClass:=TPGSQLDropMaterializedView;
end;

function TPGMatViewsRoot.PGMatViewByOID(ATableOID: integer): TPGMatView;
var
  i: Integer;
begin
  Result:=nil;
  for i:=0 to FObjects.Count-1 do
  begin
    if TPGMatView(FObjects[i]).FOID = ATableOID then
    begin
      Result:=TPGMatView(FObjects[i]);
      exit;
    end;
  end;
end;

{ TPGDBRootObject }

function TPGDBRootObject.GetSchemaId: integer;
begin
  if Assigned(FSchema) then
    Result:=FSchema.FSchemaId
  else
    Result:=-1;
end;

constructor TPGDBRootObject.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  if Assigned(AOwnerRoot) and (AOwnerRoot is TPGSchema) then
    FSchema:=TPGSchema(AOwnerRoot);
end;

constructor TPGDBRootObject.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
end;

{ TPGEventTrigger }

function TPGEventTrigger.GetTriggerSP: TPGFunction;
begin
  if not Assigned(FTriggerSP) then
    RefreshObject;

  if Assigned(FTriggerSP) and not FTriggerSP.Loaded then
    FTriggerSP.RefreshObject;
  Result:=FTriggerSP;
end;

function TPGEventTrigger.GetTriggerSPName: string;
begin

end;

procedure TPGEventTrigger.SetTriggerSPName(const AValue: string);
begin

end;

procedure TPGEventTrigger.SetTriggerSPId(ASpId: integer);
var
  i,j:integer;
  Sc:TPGSchema;
begin
  if FTrigSPId = ASpId then exit;
  FTrigSPId:=ASpId;

  FTriggerSP:=nil;
  for j:=0 to TSQLEnginePostgre(OwnerDB).SchemasRoot.CountGroups - 1 do
  begin
    Sc:=TSQLEnginePostgre(OwnerDB).SchemasRoot.Groups[j] as TPGSchema;
    for i:=0 to Sc.FTriggerProc.CountObject - 1 do
    begin
      if TPGFunction(Sc.FTriggerProc.Items[i]).FOID = ASpId then
      begin
        FTriggerSP:=TPGFunction(Sc.FTriggerProc.Items[i]);
        exit;
      end;
    end;
  end;
end;

function TPGEventTrigger.InternalGetDDLCreate: string;
var
  FCmd: TPGSQLCreateEventTrigger;
begin
  FCmd:=TPGSQLCreateEventTrigger.Create(nil);
  FCmd.Name:=Caption;
  FCmd.Description:=Description;
  FCmd.EventName:=TriggerEvent;
  FCmd.TriggerWhen:=TriggerWhen;

  if Assigned(FTriggerSP) then
  begin
  {  FCmd.TriggerFunction:=TPGSQLCreateFunction.Create;
    FCmd.TriggerFunction.Name:=FTriggerSP.Caption;
    FCmd.TriggerFunction.SchemaName:=FTriggerSP.SchemaName;
    FCmd.TriggerFunction.CreateMode:=cmCreateOrAlter;
    FCmd.TriggerFunction.Language:=FTriggerSP.Language.Caption;
    FCmd.TriggerFunction.Output.AddParam('').TypeName:='trigger';
    FCmd.TriggerFunction.Body:=FTriggerSP.ProcedureBody;
    FCmd.ProcName:=FCmd.TriggerFunction.FullName;}
    FCmd.ProcName:=FTriggerSP.Caption;
    FCmd.ProcSchema:=FTriggerSP.SchemaName;
  end;

  Result:=FCmd.AsSQL;
  FCmd.Free;
end;

procedure TPGEventTrigger.SetActive(const AValue: boolean);
var
  FCmd: TPGSQLCreateEventTrigger;
begin
{  if (State = sdboCreate) then
    FActive:=AValue
  else
  begin
    FCmd:=TPGSQLCreateEventTrigger.Create(nil);
    FCmd.Name:=Caption;
    FCmd.TableName:=FTriggerTable.Caption;
    FCmd.SchemaName:=FTriggerTable.SchemaName;
    if AValue then
      FCmd.TriggerState:=ttsEnabled
    else
      FCmd.TriggerState:=ttsDisable;
    if CompileSQLObject(FCmd, [sepInTransaction]) then
      FActive:=AValue;
    FCmd.Free;
  end;}
end;

procedure TPGEventTrigger.InternalRefreshStatistic;
begin
  inherited InternalRefreshStatistic;
  Statistic.AddValue(sOID, IntToStr(FOID));
end;

constructor TPGEventTrigger.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
    FOID:=ADBItem.ObjId;
end;

destructor TPGEventTrigger.Destroy;
begin
  inherited Destroy;
end;

class function TPGEventTrigger.DBClassTitle: string;
begin
  Result:='Event Trigger';
end;

function TPGEventTrigger.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=TPGSQLCreateEventTrigger.Create(nil);
end;

function TPGEventTrigger.CompileSQLObject(ASqlObject: TSQLCommandDDL;
  ASqlExecParam: TSqlExecParams): boolean;
var
  P: TPGSQLCreateFunction;
  FProcSchma: TPGSchema;
  FOldState: TDBObjectState;
begin
  FOldState:=State;
  Result:=inherited CompileSQLObject(ASqlObject, ASqlExecParam);
  if (FOldState = sdboCreate) and Assigned((ASqlObject as TPGSQLCreateEventTrigger).TriggerFunction) then
  begin
    P:=(ASqlObject as TPGSQLCreateEventTrigger).TriggerFunction;
    FProcSchma:=TSQLEnginePostgre(OwnerDB).SchemasRoot.ObjByName(P.SchemaName) as TPGSchema;
    FTriggerSP:=FProcSchma.TriggerProc.NewDBObject as TPGFunction;
    FTriggerSP.Caption:=P.Name;
    FTriggerSP.State:=sdboEdit;
    FTriggerSP.RefreshObject;
  end
  else
  if (FOldState = sdboEdit) and Assigned((ASqlObject as TPGSQLCreateEventTrigger).TriggerFunction) then
    FTriggerSP.RefreshObject;
end;

procedure TPGEventTrigger.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
  List.Add(FDescription);
end;

procedure TPGEventTrigger.RefreshObject;
var
  Q: TZQuery;
begin
  TriggerType:=[];
  FActive:=true;

  inherited RefreshObject;
  if State <> sdboEdit then exit;

  Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(pgSqlTextModule.sqlEventTrigger.Strings.Text);
  try
    Q.ParamByName('evtname').AsString:=Caption;
    Q.Open;
    if Q.RecordCount>0 then
    begin
      FTriggerEvent:=Q.FieldByName('evtevent').AsString;
      FActive:=Q.FieldByName('evtenabled').AsString<>'D';
      SetTriggerSPId(Q.FieldByName('evtfoid').AsInteger);
      FDescription:=Q.FieldByName('description').AsString;
      FTriggerWhen:=Q.FieldByName('evttags').AsString;
    end;
  finally
    Q.Free;
  end;
end;

procedure TPGEventTrigger.RefreshDependencies;
begin
  TSQLEnginePostgre(OwnerDB).RefreshDependencies(Self, FOID);
end;

{ TPGEventTriggersRoot }
function TPGEventTriggersRoot.DBMSObjectsList: string;
begin
  if TSQLEnginePostgre(OwnerDB).ServerVersion >= pgVersion9_3 then
    Result:=pgSqlTextModule.sqlEventTriggers.Strings.Text
  else
    Result:='';
end;

function TPGEventTriggersRoot.GetObjectType: string;
begin
  Result:='EventTrigger';
end;

constructor TPGEventTriggersRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okEventTrigger;
  FDropCommandClass:=TPGSQLDropEventTrigger;
end;

destructor TPGEventTriggersRoot.Destroy;
begin
  inherited Destroy;
end;

{ TPGACLItem }

function TPGACLItem.ObjectTypeName: string;
begin
  if DBObject is TPGView then //Странное поведение для представлений
    Result:='TABLE'
  else
    Result:=DBObject.DBClassTitle;
end;

function TPGACLItem.ObjectName: string;
begin
  if Owner.FTempObjName <> '' then
    Result:=Owner.FTempObjName
  else
    Result:=DBObject.CaptionFullPatch;
end;

{ TPGRuleList }

function TPGRuleList.RelOID: integer;
begin
  if FRelation is TPGTable then
    Result:=TPGTable(FRelation).FOID
  else
  if FRelation is TPGView then
    Result:=TPGView(FRelation).FOID;
end;

function TPGRuleList.OwnerDB: TSQLEnginePostgre;
begin
  Result:=FRelation.OwnerDB as TSQLEnginePostgre;
end;

constructor TPGRuleList.Create(const ARelation: TDBDataSetObject);
begin
  inherited Create;
  FRelation:=ARelation;
  if FRelation is TPGTable then
    FSchema:=TPGTable(FRelation).FSchema
  else
  if FRelation is TPGView then
    FSchema:=TPGView(FRelation).FSchema;
end;

procedure TPGRuleList.RuleListRefresh;
var
  i:integer;
begin
  Clear;
  for i:=0 to FSchema.FRulesRoot.CountObject - 1 do
  begin
    if TPGRule(FSchema.FRulesRoot.Items[i]).FRelID = RelOID then
      Add(FSchema.FRulesRoot.Items[i]);
  end;
end;

function TPGRuleList.RuleNew(ARuleAction: TPGRuleAction): TPGRule;
var
  R: TDBObject;
begin
  Result:=nil;
  R:=OwnerDB.CreateObject(okRule, FSchema.FRulesRoot);
  if Assigned(R) and (R is TPGRule) then
  begin
    Result:=TPGRule(R);
    Result.FRelID:=RelOID;
    Result.FRuleAction:=ARuleAction;
  end;
end;

function TPGRuleList.RuleDrop(ARule: TPGRule): boolean;
begin
  Result:=FSchema.FRulesRoot.DropObject(ARule);
end;

{ TPGRule }

function TPGRule.GetRelObject: TDBDataSetObject;
var
  i:integer;
begin
  Result:=nil;
  for i:=0 to FSchema.TablesRoot.CountObject - 1 do
  begin
    if TPGTable(FSchema.TablesRoot[i]).FOID = FRelID then
    begin
      Result:=TPGTable(FSchema.TablesRoot[i]);
      exit;
    end;
  end;

  for i:=0 to FSchema.Views.CountObject - 1 do
  begin
    if TPGView(FSchema.Views[i]).FOID = FRelID then
    begin
      Result:=TPGView(FSchema.Views[i]);
      exit;
    end;
  end;
end;

function TPGRule.InternalGetDDLCreate: string;
var
  FCmd: TPGSQLCreateRule;
  FR: TDBDataSetObject;
begin
  FCmd:=TPGSQLCreateRule.Create(nil);
  FCmd.Name:=Caption;
  FCmd.Description:=Description;
  FR:=RelObject;
  if Assigned(FR) then
    FCmd.TableName:=FR.Caption;
  FCmd.RuleAction:=RuleAction;
  FCmd.RuleWork:=RuleWork;
  FCmd.SQLRuleWhere:=RuleWhere;
  FCmd.RuleSQL:=RuleSQL;
  Result:=FCmd.AsSQL;
  FCmd.Free;
end;

function TPGRule.GetCaptionFullPatch: string;
begin
  Result:=Caption;
end;

constructor TPGRule.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  FSchema:=TPGDBRootObject(AOwnerRoot).FSchema;
  SchemaName:=FSchema.Caption;
  if Assigned(ADBItem) then
    FOID:=ADBItem.ObjId;
end;

destructor TPGRule.Destroy;
begin
  inherited Destroy;
end;

class function TPGRule.DBClassTitle: string;
begin
  Result:='Rule';
end;

procedure TPGRule.RefreshObject;
var
  Q:TZQuery;
  PS:TPGSQLCreateRule;
  EV, SS:string;
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;
  Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(pgSqlTextModule.sql_Pg_Rule.Strings.Text);
  try
    Q.ParamByName('rulename').AsString:=Caption;
    Q.Open;
    if Q.RecordCount>0 then
    begin
      FDescription:=Q.FieldByName('description').AsString;
      FRuleSQL:=Q.FieldByName('sql_define').AsString;

      PS:=SQLParseCommand(FRuleSQL, TPGSQLCreateRule, OwnerDB) as TPGSQLCreateRule;
      FRuleAction:=PS.RuleAction;
      FRuleWhere:=PS.SQLRuleWhere;
      FRuleSQL:=PS.RuleSQL;
      FRuleNothing:=PS.RuleNothing;
      FRuleWork:=PS.RuleWork;
      PS.Free;
    end;
  finally
    Q.Free;
  end;
end;

function TPGRule.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=TPGSQLCreateRule.Create(nil);
end;


{ TPGRulesRoot }

function TPGRulesRoot.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.sql_Pg_Rules.Strings.Text;
end;

function TPGRulesRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.SchemeID = SchemaId);
end;

function TPGRulesRoot.GetObjectType: string;
begin
  Result:='Rule';
end;

constructor TPGRulesRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okRule;
  FDropCommandClass:=TPGSQLDropRule;
end;

{ TPGACLList }

procedure TPGACLList.LoadUserAndGroups;
var
  i:integer;
  P:TACLItem;
begin
  for i:=0 to  TPGSecurityRoot(TSQLEnginePostgre(SQLEngine).SecurityRoot).PGUsersRoot.CountObject - 1 do
  begin
    P:=Add;
    P.UserType:=1;
    P.UserName:=TPGSecurityRoot(TSQLEnginePostgre(SQLEngine).SecurityRoot).PGUsersRoot.Items[i].Caption;
  end;
  for i:=0 to  TPGSecurityRoot(TSQLEnginePostgre(SQLEngine).SecurityRoot).PGGroupsRoot.CountObject - 1 do
  begin
    P:=Add;
    P.UserType:=2;
    P.UserName:=TPGSecurityRoot(TSQLEnginePostgre(SQLEngine).SecurityRoot).PGGroupsRoot.Items[i].Caption;
  end;
end;

function TPGACLList.OID: integer;
begin
  Result:=-1;
  if DBObject is TPGTable then
    Result:=TPGTable(DBObject).FOID
  else
  if DBObject is TPGView then
    Result:=TPGView(DBObject).FOID
  else
  if DBObject is TPGSequence then
    Result:=TPGSequence(DBObject).FOID
  else
  if DBObject is TPGFunction then
    Result:=TPGFunction(DBObject).FOID
  else
  if DBObject is TPGLanguage then
    Result:=TPGLanguage(DBObject).FOID
  else
  if DBObject is TPGSchema then
    Result:=TPGSchema(DBObject).FSchemaId
  else
  if DBObject is TPGTableSpace then
    Result:=TPGTableSpace(DBObject).FOID;
end;

procedure TPGACLList.DoParseLine(AAclLine: string);
var
  P: TACLItem;
  GR: String;
  j: Integer;
begin
  //'adm_users=arwxt/postgres'
  P:=FindACLItem(strutils.Copy2SymbDel(AAclLine, '='));
  if Assigned(P) then
  begin
    GR:=strutils.Copy2SymbDel(AAclLine, '/');
    if P.UserName = '' then
      P.UserName:='public';
    P.GrantOwnUser:=AAclLine;

    for j:=1 to Length(GR) do
    begin
      case GR[j] of
        'r':P.Grants:=P.Grants + [ogSelect];      //r -- SELECT ("read")
        'w':P.Grants:=P.Grants + [ogUpdate];      //w -- UPDATE ("write")
        'a':P.Grants:=P.Grants + [ogInsert];      //a -- INSERT ("append")
        'd':P.Grants:=P.Grants + [ogDelete];      //d -- DELETE
        'D':P.Grants:=P.Grants + [ogTruncate];    //D -- TRUNCATE
        'R':P.Grants:=P.Grants + [ogRule];        //R -- RULE
        'x':P.Grants:=P.Grants + [ogReference];   //x -- REFERENCES
        't':P.Grants:=P.Grants + [ogTrigger];     //t -- TRIGGER
        'X':P.Grants:=P.Grants + [ogExecute];     //X -- EXECUTE
        'U':P.Grants:=P.Grants + [ogUsage];       //U -- USAGE
        'C':P.Grants:=P.Grants + [ogCreate];      //C -- CREATE
        'c':P.Grants:=P.Grants + [ogConnect];     //c -- CONNECT
        'T':P.Grants:=P.Grants + [ogTemporary];   //T -- TEMPORARY
        '*':P.Grants:=P.Grants + [ogWGO];         //* -- право передачи заданного права
      else
        raise Exception.Create('PG:uknow grant type: "' + GR[j] + '"');
      end;
    end;
    P.FillOldValues;
  end;
end;

function TPGACLList.InternalCreateACLItem: TACLItem;
begin
  Result:=TPGACLItem.Create(DBObject, Self);
end;

function TPGACLList.InternalCreateGrantObject: TSQLCommandGrant;
var
  SP:TPGFunction;
  T: TTableItem;
  F: TDBField;
  GF: TSQLParserField;
  D: TDBDomain;
begin
  Result:=TPGSQLGrant.Create(nil);

  if DBObject is TPGFunction then
  begin
    SP:=TPGFunction(DBObject);
    T:=Result.Tables.Add(SP.CaptionFullPatch);
    for F in SP.FieldsIN do
    begin
      GF:=T.Fields.AddParam(F.FieldName);
      GF.InReturn:=F.IOType;

      D:=F.FieldDomain;
      if Assigned(D) then
        GF.TypeName:=D.CaptionFullPatch
      else
        GF.TypeName:=F.FieldTypeName;
    end;
  end;
end;

function TPGACLList.InternalCreateRevokeObject: TSQLCommandGrant;
var
  SP: TPGFunction;
  T: TTableItem;
  F: TDBField;
  GF: TSQLParserField;
begin
  Result:=TPGSQLRevoke.Create(nil);
  if DBObject is TPGFunction then
  begin
    SP:=TPGFunction(DBObject);
    T:=Result.Tables.Add(SP.CaptionFullPatch);
    for F in SP.FieldsIN do
    begin
      GF:=T.Fields.AddParam(F.FieldName);
      GF.InReturn:=F.IOType;
      GF.TypeName:=F.FieldTypeName;
    end;
  end;
end;

constructor TPGACLList.Create(ADBObject: TDBObject);
begin
  inherited Create(ADBObject);
  FACLStrings:=TStringList.Create;
end;

destructor TPGACLList.Destroy;
begin
  FreeAndNil(FACLStrings);
  inherited Destroy;
end;

procedure TPGACLList.RefreshList;
begin
  Clear;
  if not Assigned(DBObject) then exit;

  if DBObject is TPGFunction then
    ParseACLListStr(TPGFunction(DBObject).ACLListStr)
  else
  if DBObject is TPGLanguage then
    ParseACLListStr(TPGLanguage(DBObject).ACLListStr)
  else
  if DBObject is TPGSchema then
    ParseACLListStr(TPGSchema(DBObject).ACLListStr)
  else
  if DBObject is TPGTableSpace then
    ParseACLListStr(TPGTableSpace(DBObject).ACLListStr)
  else
  if DBObject is TPGTable then
    ParseACLListStr(TPGTable(DBObject).ACLListStr)
  else
  if DBObject is TPGSequence then
    ParseACLListStr(TPGSequence(DBObject).ACLListStr)
  else
  if (DBObject is TPGView) or (DBObject is TPGMatView) then
    ParseACLListStr(TPGView(DBObject).ACLListStr)
  else
    raise Exception.CreateFmt('not defined grant manager %s', [DBObject.ClassName]);
end;

procedure TPGACLList.ParseACLListStr(ACLStr: string);
var
  S: String;
begin
  Clear;
  LoadUserAndGroups;
  FACLStrings.Clear;
  if ACLStr<>'' then
  begin
    ParsePGArrayString(ACLStr, FACLStrings);
    for S in FACLStrings do
      DoParseLine(S);
  end;
end;

{ TPGTriggerProcRoot }

constructor TPGTriggerProcRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FProcType:=TSQLEnginePostgre(OwnerDB).FIDTypeTrigger;
end;

{ TPGIndexItem }

constructor TPGIndexItem.CreateFromDB(AOwner: TDBDataSetObject; DS: TDataSet);
var
  P:TPGIndex;
  i:integer;
  Ind: TIndexField;
  F: TField;
  FSchema: TPGSchema;
begin
  inherited Create;
  OID:=DS.FieldByName('oid').AsInteger; //Код индекса
  IndexName:=DS.FieldByName('relname').AsString; //Наименование индекса
  Unique:=DS.FieldByName('indisunique').AsBoolean; //Признак уникальности индекса
  TableSpaceID:=DS.FieldByName('reltablespace').AsInteger; //Табличное пространство, содержащее индекс
  F:=DS.FindField('indisprimary');
  if Assigned(F) then
    IsPrimary:=F.AsBoolean;

//  IndexField:=DS.FieldByName('').As
//  pg_class.relam,            --
{
  pg_index.indexrelid,       -- Код индекса (pg_class.oid)
  pg_index.indrelid,         -- Код таблицы, к которой относится индекс
  pg_index.indnatts,         -- Кол-во полей, используемых для построения индекса
  pg_index.indisprimary,     -- Признак того, что индекс является превичным ключем таблицы
  pg_index.indisclustered,   -- Признак кластерного индекса
  pg_index.indisvalid,
  pg_index.indcheckxmin,
  pg_index.indisready,
  pg_index.indexprs,         -- Строка выражения индекса
  pg_index.indpred
}
{
select
  pg_class.oid,              -- Код индекса
  pg_class.relname,          -- Наименование индекса
--  pg_class.relam,            --
  pg_class.reltablespace,    -- Табличное пространство, содержащее индекс
--  pg_index.indexrelid,       -- Код индекса (pg_class.oid)
--  pg_index.indrelid,         -- Код таблицы, к которой относится индекс
--  pg_index.indnatts,         -- Кол-во полей, используемых для построения индекса
--  pg_index.indisunique,      -- Признак уникальности индекса
--  pg_index.indisprimary,     -- Признак того, что индекс является превичным ключем таблицы
--  pg_index.indisclustered,   -- Признак кластерного индекса
--  pg_index.indisvalid,
--  pg_index.indcheckxmin,
--  pg_index.indisready,
--  pg_index.indexprs,         -- Строка выражения индекса
--  pg_index.indpred
from
  pg_class
  inner join pg_index on (pg_index.indexrelid = pg_class.oid)
where
    pg_class.relkind = 'i'
  and
    pg_index.indrelid =  :indrelid
order by
  pg_class.relname
}
  IndexField:='';
  if AOwner is TPGTable then
    FSchema:=TPGTable(AOwner).Schema
  else
  if AOwner is TPGMatView then
    FSchema:=TPGMatView(AOwner).Schema
  else
    raise Exception.Create('not implementeted');

  P:=FSchema.Indexs.IndexByOID(OID);
  if Assigned(P) then
  begin
    if not P.Loaded then
      P.RefreshObject;
    IndexField:=P.IndexFields.AsString;
    if P.IndexFields.Count>0 then
      SortOrder:=P.IndexFields[0].SortOrder;
  end;
end;

{ TPGTableSpace }

function TPGTableSpace.GetOwnerUserName: string;
var
  FOwn: TDBObject;
begin
  FOwn:=GetOwnerUser;
  if Assigned(FOwn) then
    Result:=FOwn.Caption
  else
    Result:='';
end;

function TPGTableSpace.GetOwnerUser: TDBObject;
var
  i: Integer;
  U: TDBObject;
begin
  Result:=nil;

  if TPGSecurityRoot(TSQLEnginePostgre(OwnerDB).SecurityRoot).PGUsersRoot.CountObject = 0 then
    TPGSecurityRoot(TSQLEnginePostgre(OwnerDB).SecurityRoot).PGUsersRoot.RefreshGroup;

  for i:=0 to TPGSecurityRoot(TSQLEnginePostgre(OwnerDB).SecurityRoot).PGUsersRoot.CountObject-1 do
  begin
    U:=TPGSecurityRoot(TSQLEnginePostgre(OwnerDB).SecurityRoot).PGUsersRoot[i];
    if TPGUser(U).UserID = FOwnerID then
      Exit(U);
  end;
end;

function TPGTableSpace.InternalGetDDLCreate: string;
var
  R: TPGSQLCreateTablespace;
begin
  R:=TPGSQLCreateTablespace.Create(nil);
  R.Name:=Caption;
  R.OwnerName:=OwnerUserName;
  R.Directory:=FolderName;
  R.Description:=Description;
  Result:=R.AsSQL;
  R.Free;
end;

procedure TPGTableSpace.InternalRefreshStatistic;
var
  Q: TZQuery;
begin
  inherited InternalRefreshStatistic;
  Statistic.AddValue(sOID, IntToStr(FOID));
  Statistic.AddValue(sFileFolder, FFolderName);
  Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery('select pg_tablespace_size('+IntToStr(FOID)+') as TableSpaceSize');
  Q.Open;
  if Q.RecordCount>0 then
  begin
    Statistic.AddValue(sTableSpaceSize, RxPrettySizeName(Q.FieldByName('TableSpaceSize').AsLargeInt));
  end;
  Q.Free;
end;

constructor TPGTableSpace.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  FOID:=-1;
  if Assigned(ADBItem) then
  begin
    FOID:=ADBItem.ObjId;
    FACLListStr:=ADBItem.ObjACLList;
  end;

  FACLList:=TPGACLList.Create(Self);
  FACLList.ObjectGrants:=[ogCreate, ogWGO];
  if FACLListStr<>'' then
    TPGACLList(FACLList).ParseACLListStr(FACLListStr);
end;

destructor TPGTableSpace.Destroy;
begin
  inherited Destroy;
end;

class function TPGTableSpace.DBClassTitle: string;
begin
  Result:='TableSpace';
end;

procedure TPGTableSpace.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;

procedure TPGTableSpace.RefreshObject;
var
  Q:TZQuery;
  S: String;
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;
  if TSQLEnginePostgre(OwnerDB).FRealServerVersion < 9*1000 + 2 then
    S:=pgSqlTextModule.sqlTableSpaces.Text['sqlTableSpace_8']
  else
    S:=pgSqlTextModule.sqlTableSpaces.Text['sqlTableSpace_9'];

  Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(S);
  try
    if FOID <0 then
      Q.ParamByName('spcname').AsString:=Caption
    else
      Q.ParamByName('oid').AsInteger:=FOID;
    Q.Open;
    if Q.RecordCount>0 then
    begin
      if FOID<0 then FOID:=Q.FieldByName('OID').AsInteger
      else
        Caption:=Q.FieldByName('spcname').AsString;
      FOwnerID:=Q.FieldByName('spcowner').AsInteger;
      FFolderName:=Q.FieldByName('spclocation').AsString;
      FDescription:=Q.FieldByName('description').AsString;
      FACLListStr:=Q.FieldByName('spcacl').AsString;

    end;
  finally
    Q.Free;
  end;
end;

procedure TPGTableSpace.RefreshDependencies;
begin
  TSQLEnginePostgre(OwnerDB).RefreshDependencies(Self, FOID);
end;

procedure TPGTableSpace.RefreshDependenciesField(Rec: TDependRecord);
begin
  //inherited RefreshDependenciesField(Rec);
end;

function TPGTableSpace.CreateSQLObject: TSQLCommandDDL;
begin
  if State = sdboEdit then
  begin
    Result:=TPGSQLAlterTablespace.Create(nil);
    TPGSQLAlterTablespace(Result).Name:=Caption;
  end
  else
    Result:=TPGSQLCreateTablespace.Create(nil)
end;

{ TPGLanguage }
constructor TPGLanguage.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject
  );
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
  begin
    FOID:=ADBItem.ObjId;
    FACLListStr:=ADBItem.ObjACLList;
  end;

  FACLList:=TPGACLList.Create(Self);
  FACLList.ObjectGrants:=[ogUsage, ogWGO];
  if FACLListStr<>'' then
    TPGACLList(FACLList).ParseACLListStr(FACLListStr);
end;

destructor TPGLanguage.Destroy;
begin
  inherited Destroy;
end;

class function TPGLanguage.DBClassTitle: string;
begin
  Result:='Language';
end;

procedure TPGLanguage.RefreshObject;
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;
  { TODO : Необходимо реализовать чтение свойств языка }
end;

procedure TPGLanguage.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;

procedure TPGLanguage.RefreshDependencies;
begin
  TSQLEnginePostgre(OwnerDB).RefreshDependencies(Self, FOID);
end;

procedure TPGLanguage.RefreshDependenciesField(Rec: TDependRecord);
begin
  //inherited RefreshDependenciesField(Rec);
end;


{ TSQLEnginePostgre }

function TSQLEnginePostgre.GetMetaSQLText(sqlId: integer): string;
begin
  Result:='';
  case sqlId of
    0:if FServerVersion >= pgVersion9_4 then
        Result:=pgSqlTextModule.sql_PG_TriggerList_9_4.Strings.Text
      else
      if FServerVersion >= pgVersion9_0 then
        Result:=pgSqlTextModule.sql_PG_TriggerList_9_4.Strings.Text
      else
        Result:=sql_PG_TriggerList__8;
  end;
end;

procedure TSQLEnginePostgre.DoInitPGEngine;
begin
  FPGConnection:=TZConnection.Create(nil);
  FPGSysDB:=TZConnection.Create(nil);
  InitKeywords;

  RemotePort:=PostgreSQLDefTCPPort;
  FServerVersion:=pgVersion9_0;

  FUIParams:=[upSqlEditor, upUserName, upPassword, upLocal, upRemote];

  FillFieldTypes(FTypeList);
  MiscOptions.VarPrefix:='';

  FSQLEngineCapability:=[
                   okDomain,
                   okTable,
                   okView,
                   okTrigger,
                   okStoredProc,
                   okSequence,
                   okUDF,
                   okUser,
                   okScheme,
                   okGroup,
                   okIndex,
                   okTableSpace,
                   okLanguage,
                   okCheckConstraint,
                   okForeignKey,
                   okPrimaryKey,
                   okUniqueConstraint,
                   okTasks];

  MiscOptions.ObjectNamesCharCase:=ccoLowerCase;
end;

procedure TSQLEnginePostgre.FillFieldTypeCodes;
var
  Q:TZQuery;
  P:TDBMSFieldTypeRecord;
  FTypeCat, FTypeOID, FTypeTypName, FTypeTyp: TField;
  S1: String;
begin
  FIDTypeTrigger:=-1;
  FIDTypeEventTrigger:=-1;
  FIDTypeFDWHandler:=-1;
  FIDTypeLangHandler:=-1;
  Q:=GetSQLQuery(pgSqlTextModule.sqlTypesList.Strings.Text);
  try
    Q.Open;
    FTypeOID:=Q.FieldByName('oid');
    FTypeCat:=Q.FieldByName('typcategory');
    FTypeTypName:=Q.FieldByName('typname');
    FTypeTyp:=Q.FieldByName('typtype');

    while not Q.EOF do
    begin
      S1:=LowerCase(FTypeTypName.AsString);
(*      if S1 = '_aclitem' then
      begin
        S2:='1';
      end;
      if Q.FieldByName('typcategory').AsString = 'U' then
      begin
        //Дополним список пользовательскими типами
        P:=FTypeList.Add(Q.FieldByName('typname').AsString,
                                       Q.FieldByName('oid').AsInteger,
                                       false,
                                       false,
                                       ftUnknown,
                                       '',
                                       '',
                                       tgUserDefinedTypes);
      end
      else
      begin *)
      P:=FTypeList.FindType(S1);
      if Assigned(P) then
      begin
        P.TypeId:=FTypeOID.AsInteger;
        if (S1 = 'trigger') then
          FIDTypeTrigger:=P.TypeId
        else
        if (S1 = 'event_trigger') then
          FIDTypeEventTrigger:=P.TypeId
        else
        if S1 = 'fdw_handler' then
          FIDTypeFDWHandler:=P.TypeId
        else
        if S1 = 'language_handler' then
          FIDTypeLangHandler:=P.TypeId
        ;
      end
      else
      begin
        if FTypeTyp.AsString <> 'd' then
        begin
          if FTypeCat.AsString = 'A' then
          begin
            S1:=Copy(S1, 2, Length(S1)) + '[]';
            P:=FTypeList.Add(
              S1,
              FTypeOID.AsInteger,
              false,
              false,
              ftArray,
              '',
              '',
              tgUserDefinedTypes);
          end
          else
          P:=FTypeList.Add(
            FTypeTypName.AsString,
            FTypeOID.AsInteger,
            false,
            false,
            ftUnknown,
            '',
            '',
            tgUserDefinedTypes);

        end;
      end;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TSQLEnginePostgre.ClearUserTypes;
var
  i:integer;
  P:TDBMSFieldTypeRecord;
begin
  //Удалим из списка пользовательские типы данных
  for i:=FTypeList.Count - 1 downto 0 do
  begin
    P:=FTypeList[i];
    if P.TypesGroup = tgUserDefinedTypes then
      FTypeList.Remove(P);
  end;
end;

function TSQLEnginePostgre.IsTasksExists: boolean;
begin
  Result:=Assigned(FTasks);
end;

procedure TSQLEnginePostgre.DoInitPGTasks;
var
  Q:TZQuery;
  U:TPGSchema;
begin
  FTasks:=nil;

  if not FPGSysDB.Connected then exit;
  Q:=TZQuery.Create(nil);
  Q.Connection:=FPGSysDB;
  Q.SQL.Text:=pgTasksSchema;

  try
    Q.Open;
    Q.FetchAll;
    if Q.RecordCount>0 then
      AddObjectsGroup(FTasks, TPGTasksRoot, TPGTask, sTasks);
  finally
    Q.Free;
  end;
end;

procedure TSQLEnginePostgre.UpdatePGProtocol;
begin
  FPGConnection.Protocol:=pgServerVersionProtoStr[FServerVersion];
  FPGSysDB.Protocol:=FPGConnection.Protocol;
end;

procedure TSQLEnginePostgre.RefreshAutovacuumOptions;
var
  Q: TZQuery;
  S, SV: String;
begin
  Q:=GetSQLQuery(pgSqlTextModule.sPGStatistics['ServerSettings']);
  Q.Open;
  while not Q.EOF do
  begin
    //autovacuum	on		Starts the autovacuum subprocess.
    //autovacuum_max_workers	3		Sets the maximum number of simultaneously running autovacuum worker processes.
    //autovacuum_multixact_freeze_max_age	400000000		Multixact age at which to autovacuum a table to prevent multixact wraparound.
    //autovacuum_naptime	60	s	Time to sleep between autovacuum runs.
    S:=Q.FieldByName('name').AsString;
    SV:=Q.FieldByName('setting').AsString;
    if S = 'autovacuum_analyze_scale_factor' then //0.1 - Number of tuple inserts, updates, or deletes prior to analyze as a fraction of reltuples.
      FAutovacuumOptions.AnalyzeScaleFactor:=StrToFloatExDef(SV, -1)
    else
    if S = 'autovacuum_analyze_threshold' then //50 - Minimum number of tuple inserts, updates, or deletes prior to analyze.
      FAutovacuumOptions.AnalyzeThreshold:=StrToIntDef(SV, -1)
    else
    if S = 'autovacuum_freeze_max_age' then //200000000 - Age at which to autovacuum a table to prevent transaction ID wraparound.
      FAutovacuumOptions.FreezeMaxAge:=StrToInt64Def(SV, -1)
    else
    if S = 'autovacuum_vacuum_cost_delay' then //20 - ms - Vacuum cost delay in milliseconds, for autovacuum.
      FAutovacuumOptions.VacuumCostDelay:=StrToInt64Def(SV, -1)
    else
    if S = 'vacuum_cost_limit' then //-1 - Vacuum cost amount available before napping, for autovacuum.
      FAutovacuumOptions.VacuumCostLimit:=StrToInt64Def(SV, -1)
    else
    if S = 'autovacuum_vacuum_scale_factor' then //0.2 - Number of tuple updates or deletes prior to vacuum as a fraction of reltuples.
      FAutovacuumOptions.VacuumScaleFactor:=StrToFloatExDef(SV, -1)
    else
    if S = 'autovacuum_vacuum_threshold' then //50 - Minimum number of tuple updates or deletes prior to vacuum.
      FAutovacuumOptions.VacuumThreshold:=StrToIntDef(SV, -1)
    else
    if S = 'vacuum_freeze_table_age' then //150000000 - Age at which VACUUM should scan whole table to freeze tuples.
      FAutovacuumOptions.FreezeTableAge:=StrToInt64Def(SV, -1)
    else
    if S = 'vacuum_freeze_min_age' then //50000000 - Minimum age at which VACUUM should freeze a table row.
      FAutovacuumOptions.FreezeMinAge:=StrToInt64Def(SV, -1)
    else
    if S = 'vacuum_cost_limit' then //200 - Vacuum cost amount available before napping.	Resource Usage / Cost-Based Vacuum Delay
      FAutovacuumOptions.FreezeMinAge:=StrToInt64Def(SV, -1)
    ;
    Q.Next;
  end;
  Q.Free;
  FAutovacuumOptions.Enabled:=true;
end;

function TSQLEnginePostgre.GetSQLQuery(ASql: string): TZQuery;
begin
  Result:=TZQuery.Create(nil);
  Result.Connection:=FPGConnection;
  Result.SQL.Text:=ASql;
end;

function TSQLEnginePostgre.GetSQLSysQuery(ASql: string): TZQuery;
begin
  Result:=TZQuery.Create(nil);
  Result.Connection:=FPGSysDB;
  Result.SQL.Text:=ASql;
end;

function TSQLEnginePostgre.GetImageIndex: integer;
begin
  if Connected then
    Result:=23
  else
    Result:=24;
end;

function TSQLEnginePostgre.InternalSetConnected(const AValue: boolean): boolean;
var
  FSubVersion: Integer;
begin
  FAutovacuumOptions.Clear;

  if AValue then
  begin
    FPGConnection.Properties.Clear;
    FPGConnection.HostName:=ServerName;
    FPGConnection.Database:=DataBaseName;
    FPGConnection.User:=UserName;
    FPGConnection.Password:= Password;
{$IFNDEF WINDOWS}
    FPGConnection.Properties.Values['application_name']:=ExtractFileName(ParamStr(0));
{$ENDIF}
    if UsePGBouncer then
      FPGConnection.Properties.Values['EMULATE_PREPARES']:='True';

    FPGSysDB.HostName:=ServerName;
    FPGSysDB.Database:='postgres';
    FPGSysDB.User:=UserName;
    FPGSysDB.Password:= Password;
    {$IFNDEF WINDOWS}
    FPGSysDB.Properties.Values['application_name']:=ExtractFileName(ParamStr(0));
    {$ENDIF}
    if UsePGBouncer then
      FPGSysDB.Properties.Values['EMULATE_PREPARES']:='True';

    if RemotePort <> 0 then
    begin
      FPGConnection.Port:=RemotePort;
      FPGSysDB.Port:=RemotePort;
    end;

    UpdatePGProtocol;

    FPGConnection.Connected:=true;


    FillFieldTypeCodes;


    DecodeSQLVersioning(FPGConnection.ServerVersion,  FRealServerVersionMajor, FRealServerVersionMinor, FSubVersion);
    FRealServerVersion:=FRealServerVersionMajor * 1000 + FRealServerVersionMinor;
    //
    if FUsePGShedule then
    begin
      try
        FPGSysDB.Connected:=true;
        DoInitPGTasks;
      except
      end;
    end;
  end
  else
  begin
    try
      ClearUserTypes;
      if FPGConnection.InTransaction then
        FPGConnection.Rollback;
    finally
      FPGConnection.Connected:=false;
    end;
    FPGSysDB.Connected:=false;
    FRealServerVersionMinor:=0;
    FRealServerVersionMajor:=0;
    FRealServerVersion:=0;
  end;

  Result:=FPGConnection.Connected;
end;

procedure TSQLEnginePostgre.InitGroupsObjects;
begin
  AddObjectsGroup(FSchemasRoot, TPGSchemasRoot, TPGSchema, sSchemes);
  AddObjectsGroup(FSecurityRoot, TPGSecurityRoot, nil, sSecurity);
  AddObjectsGroup(FTableSpaceRoot, TPGTableSpaceRoot, TPGTableSpace, sTableSpace);
  AddObjectsGroup(FLanguageRoot, TPGLanguageRoot, TPGLanguage, sLanguage);

  if ServerVersion >= pgVersion9_3 then
  begin
    AddObjectsGroup(FEventTriggers, TPGEventTriggersRoot, TPGEventTrigger, sEventTriggers);
    AddObjectsGroup(FForeignDataWR, TPGForeignDataWrapperRoot, TPGForeignDataWrapper, sForeignDataWrapper);
  end;

  AddObjectsGroup(FExtensions, TPGExtensionsRoot, TPGExtension, sExtensions);
end;

procedure TSQLEnginePostgre.DoneGroupsObjects;
begin
  FTableSpaceRoot:=nil;
  FLanguageRoot:=nil;
  FSecurityRoot:=nil;
  FSchemasRoot:=nil;
  FEventTriggers:=nil;
  FForeignDataWR:=nil;
end;

function TSQLEnginePostgre.GetCharSet: string;
begin
  Result:='';
end;

procedure TSQLEnginePostgre.SetCharSet(const AValue: string);
begin
  //inherited SetCharSet(AValue);
end;

class function TSQLEnginePostgre.GetEngineName: string;
begin
  Result:='Postgree SQL Server';
end;

procedure TSQLEnginePostgre.RefreshObjectsBegin(const ASQLText:string);
var
  DBObj: TDBItems;
  FQuery: TZQuery;
  P: TDBItem;

  FDesc, FOwnData, FObjData, {FData,} FAclList: TField;
begin
  DBObj:=FCashedItems.AddTypes(ASQLText);
  if DBObj.CountUse = 1 then
  begin
    FQuery:=GetSQLQuery(ASQLText);
    FQuery.Open;

    FDesc:=FQuery.FindField('description');
    if not Assigned(FDesc) then
      if FQuery.Fields.Count > 4 then
        FDesc:=FQuery.Fields[4];
    FOwnData:=FQuery.FindField('own_data');
    FObjData:=FQuery.FindField('data');
//    FData:=FQuery.FindField('data');
    FAclList:=FQuery.FindField('acl_list');

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
(*      if Assigned(FData) then
        P.ObjData:=FData.AsString; *)

      if Assigned(FAclList) then
        P.ObjACLList:=FAclList.AsString;

      FQuery.Next;
    end;
    FQuery.Close;
    FreeAndNil(FQuery);
  end;
end;

procedure TSQLEnginePostgre.InitKeywords;
begin
  KeywordsList.Clear;
  FKeyFunctions:=CreatePGKeyFunctions;
  FKeywords:=CreatePGKeyWords;
  FKeyTypes:=CreatePGKeyTypes;

  KeywordsList.Add(FKeywords);
  KeywordsList.Add(FKeyFunctions);
  KeywordsList.Add(FKeyTypes);
end;

procedure TSQLEnginePostgre.RefreshDependencies(const ADBObject: TDBObject;
  AOID: integer);
var
  Q:TZQuery;

function DoFormatObjName(const AShemaField, AObjNameField:string):string;
var
  Sch:TPGSchema;
begin
  if AShemaField<>'' then
    Sch:=FSchemasRoot.SchemaByOID(Q.FieldByName(AShemaField).AsInteger)
  else
    Sch:=nil;
  if Assigned(Sch) then
    Result:='"' + Sch.Caption +'".'+Q.FieldByName(AObjNameField).AsString
  else
    Result:=Q.FieldByName(AObjNameField).AsString;
end;

var
  Rec:TDependRecord;
  S:string;
begin
  Q:=GetSQLQuery(pgSqlTextModule.sqlPgDepends.Strings.Text);
  try
    ADBObject.DependList.Clear;
    Q.ParamByName('objid').AsInteger:=AOID;
    Q.Open;
    while not Q.EOF do
    begin
      if Q.FieldByName('objid').AsInteger = AOID then
      begin
        Rec:=TDependRecord.Create;
        ADBObject.DependList.Add(Rec);
        Rec.DependType:=1;//1 - текущий от чего-то
        S:=Q.FieldByName('r_class_name').AsString;
        if S = 'pg_class' then
        begin
          Rec.ObjectKind:=PGClassTypeToDBObjectKind(Q.FieldByName('r_rel_kind').AsString);
          Rec.ObjectName:=DoFormatObjName('r_rel_name_spase', 'r_rel_name');
        end
        else
        if S = 'pg_trigger' then
        begin
          Rec.ObjectKind:=okTrigger;
          Rec.ObjectName:=Q.FieldByName('r_tgname').AsString;
        end
        else
        if S = 'pg_constraint' then
        begin
          Rec.ObjectKind:=PGConstraintTypeToDBObjectKind(Q.FieldByName('r_contype').AsString);
          Rec.ObjectName:=DoFormatObjName('r_connamespace', 'r_conname');
        end
        else
        if S = 'pg_type' then
        begin
          Rec.ObjectKind:=okDomain;
          Rec.ObjectName:=DoFormatObjName('r_typnamespace', 'r_typname');
        end
        else
        if S = 'pg_attrdef' then
        begin
          Rec.ObjectName:=Q.FieldByName('r_adsrc').AsString;
          Rec.ObjectKind:=okOther;
          { TODO : Необходимо отображать тип объекта во внутренний индекс }
        end
        else
        if S = 'pg_namespace' then
        begin
          Rec.ObjectKind:=okScheme;
          Rec.ObjectName:=Q.FieldByName('r_nspname').AsString;
        end
        else
        if S = 'pg_proc' then
        begin
          Rec.ObjectKind:=okStoredProc;
          Rec.ObjectName:=DoFormatObjName('r_pronamespace', 'r_proname');
        end
        else
          Rec.ObjectName:=S;
        {
        pg_conversion
        pg_language
        pg_rewrite
        pg_ts_config
        pg_ts_dict
        pg_ts_template
        }
      end;

      if Q.FieldByName('refobjid').AsInteger = AOID then
      begin
        Rec:=TDependRecord.Create;
        ADBObject.DependList.Add(Rec);
        Rec.DependType:=0;//0 - зависит от текущего
        S:=Q.FieldByName('d_class_name').AsString;
        if S = 'pg_class' then
        begin
          Rec.ObjectKind:=PGClassTypeToDBObjectKind(Q.FieldByName('d_rel_kind').AsString);
          Rec.ObjectName:=DoFormatObjName('d_rel_name_spase', 'd_rel_name');
        end
        else
        if S = 'pg_trigger' then
        begin
          Rec.ObjectKind:=okTrigger;
          Rec.ObjectName:=Q.FieldByName('d_tgname').AsString;
        end
        else
        if S = 'pg_constraint' then
        begin
          Rec.ObjectKind:=PGConstraintTypeToDBObjectKind(Q.FieldByName('d_contype').AsString);
          Rec.ObjectName:=DoFormatObjName('d_connamespace', 'd_conname');
        end
        else
        if S = 'pg_type' then
        begin
          Rec.ObjectKind:=okDomain;
          Rec.ObjectName:=DoFormatObjName('d_typnamespace', 'd_typname');
        end
        else
        if S = 'pg_attrdef' then
        begin
          Rec.ObjectName:=Q.FieldByName('d_adsrc').AsString;
          Rec.ObjectKind:=okOther;
          { TODO : Необходимо отображать тип объекта во внутренний индекс }
        end
        else
        if S = 'pg_namespace' then
        begin
          Rec.ObjectKind:=okScheme;
          Rec.ObjectName:=Q.FieldByName('d_nspname').AsString;
        end
        else
        if S = 'pg_proc' then
        begin
          Rec.ObjectKind:=okStoredProc;
          Rec.ObjectName:=DoFormatObjName('d_pronamespace', 'd_proname');
        end
        else
          Rec.ObjectName:=S;
        {
        pg_conversion
        pg_language
        pg_rewrite
        pg_ts_config
        pg_ts_dict
        pg_ts_template
        }
      end;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

function TSQLEnginePostgre.GetServerInfoVersion: string;
begin
  if FPGConnection.Connected then
    Result:=FPGConnection.ServerVersionStr
  else
    Result:='';
end;

procedure TSQLEnginePostgre.OnSQLScriptDirective(Sender: TObject; Directive,
  Argument: AnsiString; var StopExecution: Boolean);
begin
  if Assigned(FOnExecuteSqlScriptProcessEvent) then
    FOnExecuteSqlScriptProcessEvent(Argument, -1, SQLEngineCommonTypesUnit.stNone);
end;

procedure TSQLEnginePostgre.SetUsePGBouncer(AValue: Boolean);
begin
  Properties.Values['UsePGBouncer']:=BoolToStr(AValue, true);
end;

function TSQLEnginePostgre.GetAutovacuumOptions: TPGAutovacuumOptions;
begin
  if not FAutovacuumOptions.Enabled then
    RefreshAutovacuumOptions;
  Result:=FAutovacuumOptions;
end;

function TSQLEnginePostgre.GetUsePGBouncer: Boolean;
begin
  Result:=StrToBoolDef(Properties.Values['UsePGBouncer'], false);
end;

procedure TSQLEnginePostgre.ZSQLProcessorAfterExecute(
  Processor: TZSQLProcessor; StatementIndex: Integer);
begin
  if Assigned(FOnExecuteSqlScriptProcessEvent) then
    if not FOnExecuteSqlScriptProcessEvent(Processor.Statements[StatementIndex], StatementIndex, stNone) then
      abort;
end;

constructor TSQLEnginePostgre.Create;
var
  FSSHConnectionPlugin: TSSHConnectionPlugin;
begin
  inherited Create;
  FSQLEngileFeatures:=[feDescribeObject, feInheritedTables, feDescribeTableConstraint];
  FSQLCommentOnClass:=TPGSQLCommentOn;
  FSSHConnectionPlugin:=TSSHConnectionPlugin.Create(Self);
  FAutovacuumOptions:=TPGAutovacuumOptions.Create(false);
  DoInitPGEngine;
end;

destructor TSQLEnginePostgre.Destroy;
begin
  FreeAndNil(FAutovacuumOptions);
  FreeAndNil(FPGConnection);
  FreeAndNil(FPGSysDB);
  if Assigned(FAccessMethod) then
    FreeAndNil(FAccessMethod);
  inherited Destroy;
end;

procedure TSQLEnginePostgre.Load(const AData: TDataSet);
begin
  inherited Load(AData);
  FServerVersion:=TPGServerVersion(AData.FieldByName('db_database_server_version').AsInteger);
  FUsePGShedule:=AData.FieldByName('db_database_shedule').AsBoolean;
end;

procedure TSQLEnginePostgre.Store(const AData: TDataSet);
begin
  inherited Store(AData);
  AData.FieldByName('db_database_server_version').AsInteger:=Ord(FServerVersion);
  AData.FieldByName('db_database_shedule').AsBoolean:=FUsePGShedule;
end;

function TSQLEnginePostgre.ExecuteSQLScript(const ASQL: string;
  OnExecuteSqlScriptProcessEvent: TExecuteSqlScriptProcessEvent): Boolean;
var
  SQLScript: TZSQLProcessor;
begin
  Result:=true;
  SQLScript:=TZSQLProcessor.Create(nil);
  FOnExecuteSqlScriptProcessEvent:=OnExecuteSqlScriptProcessEvent;
  try
    SQLScript.ParamCheck:=false;
    SQLScript.Script.Text:=ASQL;
    SQLScript.AfterExecute:=@ZSQLProcessorAfterExecute;
    SQLScript.Connection:=FPGConnection;
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

procedure TSQLEnginePostgre.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;

procedure TSQLEnginePostgre.FillCharSetList(const List: TStrings);
begin
  inherited FillCharSetList(List);
end;

function TSQLEnginePostgre.OpenDataSet(Sql: string; AOwner: TComponent
  ): TDataSet;
begin
  Result:=inherited OpenDataSet(Sql, AOwner);
end;

function TSQLEnginePostgre.ExecSQL(const Sql:string;const ExecParams:TSqlExecParams):boolean;
begin
    try
      Result:=FPGConnection.ExecuteDirect(SQL);
    except
      on E:Exception do
      begin
        InternalError(E.Message);
        Result:=false;
      end;
    end;
end;

function TSQLEnginePostgre.ExecSysSQL(const Sql: string): boolean;
begin
  if FPGSysDB.Connected then
  begin
    try
      Result:=FPGSysDB.ExecuteDirect(SQL);
    except
      on E:Exception do
      begin
        InternalError(E.Message);
        Result:=false;
      end;
    end;
  end
  else
    Result:=false;
end;

function TSQLEnginePostgre.SQLPlan(aDataSet: TDataSet): string;
begin
  Result:=inherited SQLPlan(aDataSet);
end;

function TSQLEnginePostgre.GetQueryControl: TSQLQueryControl;
begin
  Result:=TPGQueryControl.Create(Self);
end;

procedure TSQLEnginePostgre.FillDomainsList(const Items: TStrings; const ClearItems:boolean);
var
  i, j, k:integer;
  P:TPGSchema;
begin
  if ClearItems then
    Items.Clear;
  for i:=0 to FSchemasRoot.CountGroups - 1 do
  begin
    P:=TPGSchema(FSchemasRoot.Groups[i]);
    for j:=0 to P.FDomainsRoot.CountObject -1 do
    begin
      K:=Items.Add(FmtObjName(P, P.FDomainsRoot.Items[j]));
      Items.Objects[k]:=P.FDomainsRoot.Items[j];
    end;
  end;
end;

function TSQLEnginePostgre.FindDomainByID(OID: integer): TPGDomain;
var
  i, j:integer;
  P:TPGSchema;
  D:TPGDomain;
begin
  Result:=nil;
  for i:=0 to FSchemasRoot.CountGroups - 1 do
  begin
    P:=TPGSchema(FSchemasRoot.Groups[i]);
    for j:=0 to P.FDomainsRoot.CountObject -1 do
    begin
      D:=TPGDomain(P.FDomainsRoot.Items[j]);
      if D.FOID = OID then
      begin
        Result:=D;
        exit;
      end;
    end;
  end;
end;

function TSQLEnginePostgre.FindTableByID(OID: integer): TPGTable;
var
  i, j:integer;
  P:TPGSchema;
  T:TPGTable;
begin
  Result:=nil;
  for i:=0 to FSchemasRoot.CountGroups - 1 do
  begin
    P:=TPGSchema(FSchemasRoot.Groups[i]);
    for j:=0 to P.FTablesRoot.CountObject -1 do
    begin
      T:=TPGTable(P.FTablesRoot.Items[j]);
      if T.FOID = OID then
      begin
        Result:=T;
        exit;
      end;
    end;
  end;
end;

function TSQLEnginePostgre.FindUserByID(OID: integer): TDBObject;
var
  i:integer;
begin
  Result:=nil;
  for i:=0 to TPGSecurityRoot(FSecurityRoot).PGUsersRoot.CountObject-1 do
  begin
    if TPGUser(TPGSecurityRoot(FSecurityRoot).PGUsersRoot.Items[i]).UserID = OID then
    begin
      Result:=TPGSecurityRoot(FSecurityRoot).PGUsersRoot.Items[i];
      exit;
    end;
  end;
end;

function TSQLEnginePostgre.FindUsrGroupByID(OID: integer): TDBObject;
var
  i:integer;
begin
  Result:=nil;
  for i:=0 to TPGSecurityRoot(FSecurityRoot).PGGroupsRoot.CountObject-1 do
  begin
    if TPGGroup(TPGSecurityRoot(FSecurityRoot).PGGroupsRoot.Items[i]).ObjID = OID then
    begin
      Result:=TPGSecurityRoot(FSecurityRoot).PGGroupsRoot.Items[i];
      exit;
    end;
  end;
end;

function TSQLEnginePostgre.FindIndexByID(OID: integer): TPGIndex;
var
  i, j: Integer;
  P: TPGSchema;
  Ind: TPGIndex;
begin
  Result:=nil;
  for i:=0 to FSchemasRoot.CountGroups - 1 do
  begin
    P:=TPGSchema(FSchemasRoot.Groups[i]);
    for j:=0 to P.FTablesRoot.CountObject -1 do
    begin
      Ind:=TPGIndex(P.FIndexs.Items[j]);
      if Ind.FOID = OID then
      begin
        Result:=Ind;
        exit;
      end;
    end;
  end;
end;

function TSQLEnginePostgre.DBObjectByName(AName: string; ARefreshObject:boolean = true): TDBObject;
var
  S:string;
  Sc:TPGSchema;
begin
  AName:=UpperCase(AName);
  if Pos('.', AName)>0 then
    Result:=FSchemasRoot.ObjByName(AName, ARefreshObject)
  else
    Result:=inherited DBObjectByName(AName, ARefreshObject);
end;

procedure TSQLEnginePostgre.RefreshObjectsBeginFull;
begin
  RefreshObjectsBegin(pgSqlTextModule.sql_Pg_Rules.Strings.Text);
  RefreshObjectsBegin(pgSqlTextModule.sql_PG_TypesListAll.Strings.Text);
  RefreshObjectsBegin(pgSqlTextModule.sql_PG_ObjListAll.Strings.Text);
  RefreshObjectsBegin(GetMetaSQLText(0));
  RefreshObjectsBegin(pgSqlTextModule.sqlPGFuntions['PGFuntionList']);
  RefreshObjectsBegin(pgSqlTextModule.sqlSchemasAll.Strings.Text);
  RefreshObjectsBegin(pgSqlTextModule.pgCollations.Strings.Text);
  RefreshObjectsBegin(pgSqlTextModule.pgFSUserMapping.Strings.Text);
  RefreshObjectsBegin(pgSqlTextModule.pgFServ.Strings.Text);
  RefreshObjectsBegin(pgSqlTextModule.pgFDW.Strings.Text);
  RefreshObjectsBegin(pgSqlTextModule.pgFtsConfigs.Strings.Text);
  RefreshObjectsBegin(pgSqlTextModule.pgFtsDicts.Strings.Text);
  RefreshObjectsBegin(pgSqlTextModule.pgFTsParsers.Strings.Text);
  RefreshObjectsBegin(pgSqlTextModule.pgFtsTempl.Strings.Text);
end;

procedure TSQLEnginePostgre.RefreshObjectsEndFull;
begin
  RefreshObjectsEnd(pgSqlTextModule.sql_PG_TypesListAll.Strings.Text);
  RefreshObjectsEnd(pgSqlTextModule.sql_PG_ObjListAll.Strings.Text);
  RefreshObjectsEnd(GetMetaSQLText(0));
  RefreshObjectsEnd(pgSqlTextModule.sqlPGFuntions['PGFuntionList']);
  RefreshObjectsEnd(pgSqlTextModule.sql_Pg_Rules.Strings.Text);
  RefreshObjectsEnd(pgSqlTextModule.sqlSchemasAll.Strings.Text);
  RefreshObjectsEnd(pgSqlTextModule.pgCollations.Strings.Text);
  RefreshObjectsEnd(pgSqlTextModule.pgFSUserMapping.Strings.Text);
  RefreshObjectsEnd(pgSqlTextModule.pgFServ.Strings.Text);
  RefreshObjectsEnd(pgSqlTextModule.pgFDW.Strings.Text);
  RefreshObjectsEnd(pgSqlTextModule.pgFtsConfigs.Strings.Text);
  RefreshObjectsEnd(pgSqlTextModule.pgFtsDicts.Strings.Text);
  RefreshObjectsEnd(pgSqlTextModule.pgFTsParsers.Strings.Text);
  RefreshObjectsEnd(pgSqlTextModule.pgFtsTempl.Strings.Text);
end;

(*
function TSQLEnginePostgre.ShowObjectItem: integer;
begin
  Result:=0; //7;
end;

procedure TSQLEnginePostgre.ShowObjectGetItem(Item: integer;
  out ItemName: string; out ItemValue: boolean);
begin

end;

procedure TSQLEnginePostgre.ShowObjectSetItem(Item: integer; ItemValue: boolean
  );
begin

end;
*)
procedure TSQLEnginePostgre.AccessMethodList(const AList: TStrings; ARefresh: Boolean = false);
var
  Q: TZQuery;
begin
  if not Assigned(FAccessMethod) then
    FAccessMethod:=TStringList.Create;

  if (FAccessMethod.Count = 0) or ARefresh then
  begin
    FAccessMethod.Clear;
    Q:=GetSQLQuery(pgSqlTextModule.sPGSystem['sPGAm']);
    Q.Open;
    FieldValueToStrings(Q, 'amname', FAccessMethod);
    Q.Free;
  end;

  AList.Assign(FAccessMethod);
end;

{ TPGQueryControl }

procedure TPGQueryControl.SetParamValues;
begin

end;

function TPGQueryControl.GetDataSet: TDataSet;
begin
  Result:=FSQLQuery;
end;

function TPGQueryControl.GetQueryPlan: string;
var
  Q: TZQuery;
begin
  Result:='';//inherited GetQueryPlan;
  Q:=TSQLEnginePostgre(Owner).GetSQLQuery('EXPLAIN ' + QuerySQL);
  try
    Q.Open;
    if Q.Fields.Count > 0 then
    begin
      while not Q.EOF do
      begin
        Result:=Result +  Q.Fields[0].AsString + LineEnding;
        Q.Next;
      end;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TPGQueryControl.GetQuerySQL: string;
begin
  Result:=FSQLQuery.SQL.Text;
end;

procedure TPGQueryControl.SetQuerySQL(const AValue: string);
begin
  FSQLQuery.Active:=false;
  FSQLQuery.SQL.Text:=AValue;
end;

function TPGQueryControl.GetParam(AIndex: integer): TParam;
begin
  Result:=FSQLQuery.Params[AIndex];
end;

function TPGQueryControl.GetParamCount: integer;
begin
  Result:=FSQLQuery.Params.Count;
end;

procedure TPGQueryControl.SetActive(const AValue: boolean);
begin
  SetParamValues;
  if AValue then
    FSQLQuery.SortedFields:='';
  inherited SetActive(AValue);
end;

constructor TPGQueryControl.Create(AOwner: TSQLEngineAbstract);
begin
  inherited Create(AOwner);
  FSQLQuery:=TZQuery.Create(nil);
  FSQLQuery.Connection:=TSQLEnginePostgre(AOwner).FPGConnection;
end;

destructor TPGQueryControl.Destroy;
begin
  FreeAndNil(FSQLQuery);
  inherited Destroy;
end;

function TPGQueryControl.IsEditable: boolean;
begin
  Result:=true;
end;

procedure TPGQueryControl.CommitTransaction;
begin
//  FTransaction.Commit;
end;

procedure TPGQueryControl.RolbackTransaction;
begin
//  FTransaction.Rollback;
end;

procedure TPGQueryControl.FetchAll;
begin
  FSQLQuery.FetchAll;
end;

procedure TPGQueryControl.Prepare;
begin
  FSQLQuery.Prepare;
end;

procedure TPGQueryControl.ExecSQL;
begin
  FSQLQuery.ExecSQL;
end;

{ TPGSchemasRoot }

function TPGSchemasRoot.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.sqlSchemasAll.Strings.Text;
end;

function TPGSchemasRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and ((ussSystemTable in OwnerDB.UIShowSysObjects) or ((AItem.ObjName <> 'information_schema') and (Copy(AItem.ObjName, 1, 3) <> 'pg_')));
end;

function TPGSchemasRoot.GetObjectType: string;
begin
  Result:='Schema';
end;

constructor TPGSchemasRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okScheme;
  FDropCommandClass:=TPGSQLDropSchema;
end;

destructor TPGSchemasRoot.Destroy;
begin
  inherited Destroy;
end;

function TPGSchemasRoot.SchemaByOID(AOID: integer): TPGSchema;
var
  P: TDBObject;
begin
  Result:=nil;
  for P in FGroupObjects do
  begin
    if TPGSchema(P).FSchemaId = AOID then
    begin
      Result:=TPGSchema(P);
      exit;
    end;
  end;
end;

function TPGSchemasRoot.PublicSchema: TPGSchema;
var
  P: TDBObject;
begin
  Result:=nil;
  for P in FGroupObjects do
    if P.Caption = 'public' then
      Exit(P as TPGSchema);
  raise Exception.Create('Public schema not found.');
end;

{ TPGSchema }

procedure TPGSchema.SetSchemaId(const AValue: integer);
begin
  FSchemaId:=AValue;
end;

function TPGSchema.InternalGetDDLCreate: string;
var
  ACL:TStringList;
  R: TPGSQLCreateSchema;
begin
  R:=TPGSQLCreateSchema.Create(nil);
  R.Name:=CaptionFullPatch;
  R.OwnerUserName:=OwnerName;
  R.Description:=Description;
  Result:=R.AsSQL;
  R.Free;

  ACL:=TStringList.Create;
  try
    FACLList.RefreshList;
    FACLList.MakeACLListSQL(nil, ACL, true);
    Result:=Result + LineEnding + LineEnding + ACL.Text;
  finally
    ACL.Free;
  end;
end;

procedure TPGSchema.InternalRefreshStatistic;
begin
  inherited InternalRefreshStatistic;
  Statistic.AddValue(sOID, IntToStr(FSchemaId));
{  if Assigned(FPGTableSpace) then
    Statistic.AddValue(sTableSpace, FPGTableSpace.Caption);}
end;

function TPGSchema.GetObjectType: string;
begin
  Result:='Schema';
end;

procedure TPGSchema.RefreshObject;
var
  Q:TZQuery;
begin
  inherited RefreshObject;
  FACLListStr:='';
  if State <> sdboEdit then exit;
  Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(pgSqlTextModule.sqlSchema.Strings.Text);
  try
    Q.ParamByName('nspname').AsString:=Caption;
    Q.Open;
    if Q.RecordCount > 0 then
    begin
      SchemaId:=Q.FieldByName('oid').AsInteger;
      FOwnerName:=Q.FieldByName('usename').AsString;
      FDescription:=Q.FieldByName('description').AsString;
      FACLListStr:=Q.FieldByName('acl_list').AsString;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

procedure TPGSchema.RefreshGroup;
begin
  //
end;

function TPGSchema.ObjByName(AName: string; ARefreshObject:boolean = true): TDBObject;
var
  S:string;
begin
  if Pos('.', AName)>0 then
  begin
    Result:=nil;
    S:=strutils.Copy2SymbDel(AName, '.');
    S:=ExtractQuotedString(S, '"');
    if UpperCase(S) = UpperCase(Caption) then
    begin
      Result:=inherited ObjByName(AName, ARefreshObject);
    end;
  end
  else
    Result:=inherited ObjByName(AName, ARefreshObject);
end;

procedure TPGSchema.RefreshDependencies;
begin
  TSQLEnginePostgre(OwnerDB).RefreshDependencies(Self, FSchemaId);
end;

procedure TPGSchema.RefreshDependenciesField(Rec: TDependRecord);
begin
  //inherited RefreshDependenciesField(Rec);
end;

constructor TPGSchema.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
  begin
    FSchemaId:=ADBItem.ObjId;
    FOwnerName:=ADBItem.ObjType;
    FACLListStr:=ADBItem.ObjACLList;
  end;

  FACLList:=TPGACLList.Create(Self);
  FACLList.ObjectGrants:=[ogCreate, ogUsage, ogWGO];
  if FACLListStr<>'' then
    TPGACLList(FACLList).ParseACLListStr(FACLListStr);

  FDBObjectKind:=okScheme;
  FDomainsRoot:=TPGDomainsRoot.Create(OwnerDB, TPGDomain, sDomains, Self);
  FTablesRoot:=TPGTablesRoot.Create(OwnerDB, TPGTable, sTables, Self);
  FSequencesRoot:=TPGSequencesRoot.Create(OwnerDB, TPGSequence, sSequences, Self);
  FViews:=TPGViewsRoot.Create(OwnerDB, TPGView, sViews, Self);
  FTriggers:=TPGTriggersRoot.Create(OwnerDB, TPGTrigger, sTriggers, Self);
  FIndexs:=TPGIndexRoot.Create(OwnerDB, TPGIndex, sIndexs, Self);

  FProcedures:=TPGFunctionsRoot.Create(OwnerDB, TPGFunction, sFunctions, Self);
  FProcedures.FProcType:=-1;
  FTriggerProc:=TPGTriggerProcRoot.Create(OwnerDB, TPGTriggerFunction, sTriggerProc, Self);
  FRulesRoot:=TPGRulesRoot.Create(OwnerDB, TPGRule, sRules, Self);

  FCollationRoot:=TPGCollationRoot.Create(OwnerDB, TPGCollation, sCollate, Self);

  if TSQLEnginePostgre(OwnerDB).ServerVersion >= pgVersion9_3 then
    FMatViews:=TPGMatViewsRoot.Create(OwnerDB, TPGMatView, sMaterializedViews, Self);

  if TSQLEnginePostgre(OwnerDB).ServerVersion >= pgVersion8_3 then
    FFTSRoot:=TPGFTSRoot.Create(OwnerDB, nil, 'FTS', Self);

  FDomainsRoot.FSchema:=Self;
  FTablesRoot.FSchema:=Self;
  FSequencesRoot.FSchema:=Self;
  FViews.FSchema:=Self;
  FTriggers.FSchema:=Self;
  FIndexs.FSchema:=Self;
  FProcedures.FSchema:=Self;
  FTriggerProc.FSchema:=Self;
  FRulesRoot.FSchema:=Self;
  if Assigned(FMatViews) then
    FMatViews.FSchema:=Self;

  FSystemObject:=(Caption = 'information_schema') or (Copy(Caption, 1, 3) = 'pg_');
  FObjectEditable:=not FSystemObject;
end;

procedure TPGSchema.FillFieldList(List: TStrings; ACharCase: TCharCaseOptions;
  AFullNames: Boolean);
begin
  FTablesRoot.FillListForNames(List, AFullNames);
  FDomainsRoot.FillListForNames(List, AFullNames);
  FSequencesRoot.FillListForNames(List, AFullNames);
  FViews.FillListForNames(List, AFullNames);
  FProcedures.FillListForNames(List, AFullNames);
end;

function TPGSchema.CreateSQLObject: TSQLCommandDDL;
begin
  if State = sdboCreate then
    Result:=TPGSQLCreateSchema.Create(nil)
  else
  begin
    Result:=TPGSQLAlterSchema.Create(nil);
    Result.Name:=Caption;
    TPGSQLAlterSchema(Result).OldDescription:=Description;
  end;
end;

class function TPGSchema.DBClassTitle: string;
begin
  Result:='Schema';
end;

destructor TPGSchema.Destroy;
begin
  FreeAndNil(FFTSRoot);
  if Assigned(FMatViews) then
    FreeAndNil(FMatViews);
  FreeAndNil(FTablesRoot);
  FreeAndNil(FDomainsRoot);
  FreeAndNil(FSequencesRoot);
  FreeAndNil(FProcedures);
  FreeAndNil(FViews);
  FreeAndNil(FTriggers);
  FreeAndNil(FRulesRoot);
  FreeAndNil(FIndexs);
  FreeAndNil(FCollationRoot);
  inherited Destroy;
end;

{ TPGTablesRoot }

function TPGTablesRoot.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.sql_PG_ObjListAll.Strings.Text;
end;

function TPGTablesRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.ObjType = 'r') and (AItem.SchemeID = SchemaId);
end;

function TPGTablesRoot.GetObjectType: string;
begin
  Result:='Table';
end;

constructor TPGTablesRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okTable;
  FDropCommandClass:=TPGSQLDropTable;
end;

function TPGTablesRoot.PGTableByOID(ATableOID: integer): TPGTable;
var
  i:integer;
begin
  Result:=nil;
  for i:=0 to FObjects.Count-1 do
  begin
    if TPGTable(FObjects[i]).FOID = ATableOID then
    begin
      Result:=TPGTable(FObjects[i]);
      exit;
    end;
  end;
end;

{ TPGTable }

procedure TPGTable.InternalCreateDLL(var SQLLines: TStringList;
  const ATableName: string);

procedure   DoMakeIndexList;
var
  i: integer;
  Pr:TPGIndexItem;
  P:TPGIndex;
  S: string;
begin
  S:='';
  for i:=0 to FIndexItems.Count - 1 do
  begin
    Pr:=TPGIndexItem(FIndexItems[i]);
    P:=TPGIndex(Schema.Indexs.ObjByName(Pr.IndexName));
    if Assigned(P) and not Pr.IsPrimary then
    begin
      S:=P.InternalGetDDLCreate;
      SQLLines.Add(S);
    end;
  end;
end;

var
  S, S1: string;
  PkRec, P:TPrimaryKeyRecord;
  FkRec:TForeignKeyRecord;
  ChkRec:TTableCheckConstraintRecord;
  UG:TDBObject;
  i, CntPK: Integer;
  F: TDBField;
  FCmd: TPGSQLCreateTable;
  C: TSQLConstraintItem;
  //ACL: TStringList;
begin
  if (State <> sdboCreate) and not Assigned(Fields) then
    RefreshObject;
  FCmd:=TPGSQLCreateTable.Create(nil);
  FCmd.Name:=Caption;
  FCmd.Description:=Description;
  FCmd.SchemaName:=SchemaName;

  if FTableHasOIDS then
    FCmd.PGOptions:=FCmd.PGOptions + [pgoWithOids]
  else
    FCmd.PGOptions:=FCmd.PGOptions + [pgoWithoutOids];

  if FOwnerID<>0 then
  begin
    UG:=TDBObject(TSQLEnginePostgre(OwnerDB).FindUserByID(FOwnerID));
    if not Assigned(UG) then
      UG:=TDBObject(TSQLEnginePostgre(OwnerDB).FindUsrGroupByID(FOwnerID));
    if Assigned(UG) then
      FCmd.Owner:=UG.Caption;
  end;

  Fields.SaveToSQLFields(FCmd.Fields);


  IndexListRefresh;
//  if FConstraintList.Count =0 then
  begin
    RefreshConstraintPrimaryKey;
    RefreshConstraintForeignKey;
  end;

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

  if FAutovacuumOptions.Enabled then
    AutovacuumOptions.SaveStorageParameters(FCmd.StorageParameters);
  if FToastAutovacuumOptions.Enabled then
    FToastAutovacuumOptions.SaveStorageParameters(FCmd.StorageParameters);

//  if ChkRec.Description<>'' then
//      SQLLines.Add(Format('COMMENT ON CONSTRAINT %s ON %s IS ''%s''', [ChkRec.Name, ATableName, ChkRec.Description]));

  SQLLines.Add(FCmd.AsSQL);

  FCmd.Free;

  DoMakeIndexList;
end;

type
  THackZQuery = class(TZQuery);
  THackZAbstractCachedResultSet = class(TZAbstractCachedResultSet);

procedure TPGTable.ZUpdateSQLBeforeInsertSQLStatement(const Sender: TObject;
  StatementIndex: Integer; out Execute: Boolean);
var
  ICRS: IZCachedResultSet;
  DCRS: TZAbstractCachedResultSet;
  RA: TZRowAccessor;
  quIns: TZQuery;
  S, S1, S2: String;
  F: TField;
  FD: TDBField;
  P: TParam;
begin
  RA:=nil;

  ICRS:=THackZQuery(FDataSet).CachedResultSet;
  if ICRS is TZAbstractCachedResultSet then
  begin
    DCRS:=ICRS as TZAbstractCachedResultSet;
    RA:=THackZAbstractCachedResultSet(DCRS).NewRowAccessor;
    if Assigned(RA) then
    begin
      S1:='';
      S2:='';
      for FD in Fields do
      begin
        F:=FDataSet.FieldByName(FD.FieldName);
        if not F.IsNull then
        begin
          if S1<>'' then
          begin
            S1:=S1+ ', ';
            S2:=S2+ ', ';
          end;
          S1:=S1 + FD.FieldName;
          S2:=S2 +':' + FD.FieldName;
        end;
      end;

      //S:='insert into ' + CaptionFullPatch + '(' + MakeSQLInsertFields(false) + ')'+ ' values('+MakeSQLInsertFields(true)+') returning '+MakeSQLInsertFields(false);
      S:='insert into ' + CaptionFullPatch + '(' + S1 + ')'+ ' values('+S2+') returning '+MakeSQLInsertFields(false);
      quIns:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(S);
      for F in FDataSet.Fields do
      begin
        P:=quIns.Params.FindParam(F.FieldName);
        if Assigned(P) then
          P.Assign(F);
      end;
      quIns.Open;

      for FD in Fields do
      begin
        if FD.FieldPK then
        begin
          F:=quIns.FieldByName(FD.FieldName);
          if F.DataType in IntegerDataTypes then
            RA.SetInt(F.Index+1, F.AsInteger)
          else
          if F.DataType in StringTypes then
            RA.SetString(F.Index+1, F.AsString)
          else
          if F.DataType = ftTime then
            RA.SetTime(F.Index+1, F.AsDateTime)
          else
          if F.DataType in [ftDateTime, ftTimeStamp] then
            RA.SetTimestamp(F.Index+1, F.AsDateTime)
          else
          if F.DataType = ftDate then
            RA.SetDate(F.Index+1, F.AsDateTime)
          else
            raise Exception.CreateFmt('Unknow data type for refresh : %s', [Fieldtypenames[F.DataType]]);
        end;
      end;
      quIns.Close;
      Execute:=false;
    end;
  end;
end;

function TPGTable.MakeSQLInsertFields(AParams: boolean): string;
var
  F: TDBField;
begin
  Result:='';
  for F in Fields do
    if AParams then
      Result:=Result + ' :' + F.FieldName + ','
    else
      Result:=Result + ' ' + DoFormatName(F.FieldName) + ',';
  if Result <> '' then
    Result:= Copy(Result, 1, Length(Result) - 1);
end;

function TPGTable.GetDBFieldClass: TDBFieldClass;
begin
  Result:=TPGField;
end;

procedure TPGTable.NotyfiOnDestroy(ADBObject: TDBObject);
var
  i: Integer;
begin
  inherited NotyfiOnDestroy(ADBObject);
  if ADBObject is TPGRule then
  begin
    i:=FRuleList.IndexOf(ADBObject);
    if i > -1 then
    begin
      FRuleList.Delete(i);
      RefreshEditor;
    end;
  end;
end;

procedure TPGTable.InternalRefreshStatistic;
var
  FQuery: TZQuery;
begin
  inherited InternalRefreshStatistic;
  Statistic.AddValue(sOID, IntToStr(FOID));
  Statistic.AddValue(sSchemaOID, IntToStr(FSchema.SchemaId));
  Statistic.AddValue(sToastOID, IntToStr(FToastRelOID));


  FQuery:=TSQLEnginePostgre(OwnerDB).GetSQLQuery( pgSqlTextModule.sPGStatistics['Stat1_Sizes']);
  FQuery.ParamByName('oid').AsInteger:=FOID;
  FQuery.Open;

  Statistic.AddValue(sTotalSize, RxPrettySizeName(FQuery.FieldByName('total').AsLargeInt));
  Statistic.AddValue(sIndexSize, RxPrettySizeName(FQuery.FieldByName('INDEX').AsLargeInt));
  Statistic.AddValue(sToastSize, RxPrettySizeName(FQuery.FieldByName('toast').AsLargeInt));
  Statistic.AddValue(sTableSize, RxPrettySizeName(FQuery.FieldByName('total').AsLargeInt - FQuery.FieldByName('INDEX').AsLargeInt - FQuery.FieldByName('toast').AsLargeInt));
  Statistic.AddValue(sStatRecordCount, FQuery.FieldByName('avg_rec_count').AsString);
  Statistic.AddValue(sStatPageCount, FQuery.FieldByName('relpages').AsString);

  if FAutovacuumOptions.Enabled then
  begin
    Statistic.AddValue(sAutovacuumEnabled, sYes);
    Statistic.AddValue(sVacuumThreshold, FloatToStr(FAutovacuumOptions.VacuumThreshold));
    Statistic.AddValue(sAnalyzeThreshold, IntToStr(FAutovacuumOptions.AnalyzeThreshold));
    Statistic.AddValue(sVacuumScaleFactor, FloatToStr(FAutovacuumOptions.VacuumScaleFactor));
    Statistic.AddValue(sAnalyzeScaleFactor, FloatToStr(FAutovacuumOptions.AnalyzeScaleFactor));
    Statistic.AddValue(sVacuumCostDelay, IntToStr(FAutovacuumOptions.VacuumCostDelay));
    Statistic.AddValue(sVacuumCostLimit, IntToStr(FAutovacuumOptions.VacuumCostLimit));
    Statistic.AddValue(sFreezeMinAge, IntToStr(FAutovacuumOptions.FreezeMinAge));
    Statistic.AddValue(sFreezeMaxAge, IntToStr(FAutovacuumOptions.FreezeMaxAge));
    Statistic.AddValue(sFreezeTableAge, IntToStr(FAutovacuumOptions.FreezeTableAge));
  end;

  if FToastAutovacuumOptions.Enabled then
  begin
    Statistic.AddValue(sToastAutovacuumEnabled, sYes);
    Statistic.AddValue(sToastVacuumThreshold, FloatToStr(FToastAutovacuumOptions.VacuumThreshold));
    Statistic.AddValue(sToastVacuumScaleFactor, FloatToStr(FToastAutovacuumOptions.VacuumScaleFactor));
    Statistic.AddValue(sToastVacuumCostDelay, IntToStr(FToastAutovacuumOptions.VacuumCostDelay));
    Statistic.AddValue(sToastVacuumCostLimit, IntToStr(FToastAutovacuumOptions.VacuumCostLimit));
    Statistic.AddValue(sToastFreezeMinAge, IntToStr(FToastAutovacuumOptions.FreezeMinAge));
    Statistic.AddValue(sToastFreezeMaxAge, IntToStr(FToastAutovacuumOptions.FreezeMaxAge));
    Statistic.AddValue(sToastFreezeTableAge, IntToStr(FToastAutovacuumOptions.FreezeTableAge));
  end;

  FQuery.Close;
  FQuery.Free;

end;

procedure TPGTable.IndexArrayCreate;
begin
  FIndexItems:=TPGIndexItems.Create(TPGIndexItem);
end;

function TPGTable.GetCaptionFullPatch: string;
begin
  Result:=FmtObjName(FSchema, Self);
end;

function TPGTable.GetTrigger(ACat: integer; AItem: integer): TDBTriggerObject;
begin
  if (ACat>=0) and (ACat<6) then
    Result:=TPGTrigger(FTriggerList[ACat].Items[AItem])
  else
    Result:=nil;
end;

function TPGTable.GetTriggersCategories(AItem: integer): string;
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

function TPGTable.GetTriggersCategoriesType(AItem: integer): TTriggerTypes;
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

function TPGTable.GetTriggersCategoriesCount: integer;
begin
  Result:=6;
  if FTriggerList[0].Count = 0 then
    TriggersListRefresh;
end;

function TPGTable.GetTriggersCount(AItem: integer): integer;
begin
  if (AItem >=0) and (AItem<6) then
    Result:=FTriggerList[AItem].Count
  else
    Result:=0;
end;

function TPGTable.InternalGetDDLCreate: string;
var
  SQLLines:TStringList;
  i:integer;
  Trig:TPGTrigger;
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

    for i:=0 to FSchema.FTriggers.CountObject - 1 do
    begin
      Trig:=TPGTrigger(FSchema.FTriggers.Items[i]);
      if (Trig.TriggerTable = Self) and (Trig.State = sdboEdit) then
        SQLLines.Add(Trig.DDLCreate);
    end;

    //Result:=SQLLines.Text;
    //SQLLines.Clear;
    FACLList.RefreshList;
    FACLList.MakeACLListSQL(nil, SQLLines, true);
    //Result:=Result + LineEnding + LineEnding + SQLLines.Text;

    Result:=SQLLines.Text;
  finally
    SQLLines.Free;
  end


end;

function TPGTable.GetRecordCount: integer;
var
  Q:TZQuery;
begin
  Result:=inherited GetRecordCount;
  Q:=TSQLEnginePostgre(OwnerDB).GetSqlQuery('select count(*) from '+CaptionFullPatch);
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


procedure TPGTable.RefreshFieldList;
var
  FQuery:TZQuery;
  R: TPGField;
begin
  if State <> sdboEdit then exit;
  Fields.Clear;

  FQuery:=TSQLEnginePostgre(OwnerDB).GetSQLQuery( pgSqlTextModule.sqlPGRelationFields.Strings.Text);
  try
    FQuery.ParamByName('attrelid').AsInteger:=FOID;
    FQuery.Open;
    while not FQuery.Eof do
    begin
      R:=Fields.Add('') as TPGField;
      R.LoadfromDB(FQuery);
      FQuery.Next;
    end;
  finally
    FQuery.Free;
  end;
  RefreshConstraintPrimaryKey;
  RefreshConstraintUnique;
end;

procedure TPGTable.SetFieldsOrder(AFieldsList: TStrings);
begin
  OwnerDB.InternalError('Not complete function');
  { TODO : Необходимо реализовать изменение порядка полей через прямые update-ы системной таблицы pg_attribute - может заработает?}
end;

function TPGTable.IndexNew: string;
var
  R: TDBObject;
begin
  Result:='';
  R:=OwnerDB.CreateObject(okIndex, FSchema.Indexs);
  if Assigned(R) and (R is TPGIndex) then
  begin
    TPGIndex(R).SetPGTable(Self);
    R.RefreshEditor;
  end;
end;

function TPGTable.IndexEdit(const IndexName: string): boolean;
var
  P:TPGIndex;
begin
  Result:=false;
  P:=TPGIndex(Schema.Indexs.ObjByName(IndexName));
  if Assigned(P) then
    P.Edit;
end;

function TPGTable.IndexDelete(const IndexName: string): boolean;
var
  Ind:TPGIndex;
begin
  Ind:=TPGIndex(FSchema.Indexs.ObjByName(IndexName));
  if Assigned(Ind) then
    Result:=FSchema.Indexs.DropObject(Ind)
  else
    Result:=false;
end;

procedure TPGTable.IndexListRefresh;
var
  FQuery:TZQuery;
  Rec:TPGIndexItem;
begin
  IndexArrayClear;
  FQuery:=TSQLEnginePostgre(OwnerDB).GetSQLQuery( pgSqlTextModule.sqlIndexTable.Strings.Text);
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
  end;
  FIndexListLoaded:=true;
end;

procedure TPGTable.TriggersListRefresh;
var
  i:integer;
  Trig:TPGTrigger;
begin
  FTriggerList[0].Clear;
  FTriggerList[1].Clear;
  FTriggerList[2].Clear;
  FTriggerList[3].Clear;
  FTriggerList[4].Clear;
  FTriggerList[5].Clear;

  for i:=0 to FSchema.FTriggers.CountObject - 1 do
  begin
    Trig:=TPGTrigger(FSchema.FTriggers.Items[i]);

    if not Assigned(Trig.FTriggerTable) then
      Trig.RefreshObject;

    if Trig.FTriggerTable = Self then
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

procedure TPGTable.RecompileTriggers;
begin
  //inherited RecompileTriggers;
end;

procedure TPGTable.AllTriggersSetActiveState(AState: boolean);
var
  i:integer;
  Trig:TPGTrigger;
begin
  for i:=0 to FSchema.FTriggers.CountObject - 1 do
  begin
    Trig:=TPGTrigger(FSchema.FTriggers.Items[i]);

    if not Assigned(Trig.FTriggerTable) then
      Trig.RefreshObject;

    if Trig.FTriggerTable = Self then
      Trig.Active:=AState;

  end;
end;

function TPGTable.TriggerNew(TriggerTypes: TTriggerTypes): TDBTriggerObject;
begin
  Result:=OwnerDB.NewObjectByKind(FSchema.Triggers, okTrigger) as TDBTriggerObject;
  if Assigned(Result) then
  begin
    Result.TriggerTable:=Self;
    Result.TriggerType:=TriggerTypes;
    Result.Active:=true;
    Result.RefreshEditor;
  end;
end;

function TPGTable.TriggerDelete(const ATrigger:TDBTriggerObject): Boolean;
begin
  Result:=FSchema.Triggers.DropObject(ATrigger);
end;

procedure TPGTable.RefreshConstraintPrimaryKey;
var
  I:integer;
  Q:TZQuery;
  Rec:TPrimaryKeyRecord;
  F: TDBField;
begin
  inherited RefreshConstraintPrimaryKey;

  Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(pgSqlTextModule.sqlPgConstPK.ExpandMacros);
  try
    Q.ParamByName('conrelid').AsInteger:=FOID;
    Q.Open;
    while not Q.Eof do
    begin
      Rec:=TPrimaryKeyRecord.Create;
      FConstraintList.Add(Rec);
      Rec.Name:=Q.FieldByName('conname').AsString;
      Rec.FieldList:=ConvertFieldList(Q.FieldByName('conkey').AsString, Self);
      Rec.Description:=ConvertFieldList(Q.FieldByName('description').AsString, Self);
      { TODO : Необходимо написать процедуру создания списка полей в PK }
      for i:=0 to Rec.CountFields-1 do
      begin
        F:=Fields.FieldByName(Rec.FieldByNum(i));
        if Assigned(F) then
          F.FieldPK:=true;
        Inc(FPKCount);
      end;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TPGTable.RefreshConstraintForeignKey;
var
  I:integer;
  Q:TZQuery;
  T:TPGTable;
  S:string;
  Rec:TPGForeignKeyRecord;
  Ind: TPGIndexItem;
begin
  inherited RefreshConstraintForeignKey;
  if not FIndexListLoaded then
    IndexListRefresh;

  Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(pgSqlTextModule.sqlPgConstFK.ExpandMacros);
  try
    Q.ParamByName('conrelid').AsInteger:=FOID;
    Q.Open;
    while not Q.Eof do
    begin
      { TODO : Необходимо читать описание ограничения }
      Rec:=TPGForeignKeyRecord.Create;
      FConstraintList.Add(Rec);
      Rec.Name:=Q.FieldByName('conname').AsString;
      Rec.IndexOID:=Q.FieldByName('conindid').AsInteger;
      S:=Q.FieldByName('conkey').AsString;
      Rec.FieldList:=ConvertFieldList(S, Self);
      Rec.Description:=Q.FieldByName('description').AsString;

      Rec.OnUpdateRule:=StrToForeignKeyRule(Q.FieldByName('UPD_RULE').AsString);
      Rec.OnDeleteRule:=StrToForeignKeyRule(Q.FieldByName('DEL_RULE').AsString);
//      Rec.IndexName:=Q.FieldByName('index_name').AsString;

      T:=TSQLEnginePostgre(OwnerDB).FindTableByID(Q.FieldByName('confrelid').AsInteger);
      if Assigned(T) then
      begin
        Rec.FKTableName:=T.CaptionFullPatch;
        S:=Q.FieldByName('confkey').AsString;
        Rec.FKFieldName:=ConvertFieldList(S, T);


        if Rec.IndexOID > 0 then
        begin
          if not T.FIndexListLoaded then
            T.IndexListRefresh;
          Ind:=TPGIndexItems(T.IndexItems).IndexItemByOID(Rec.IndexOID);
          if Assigned(Ind) then
          begin
            Rec.IndexName:=Ind.IndexName;
            Rec.Index:=Ind;
          end;
        end;
      end;

      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TPGTable.RefreshConstraintUnique;
var
  I:integer;
  Q:TZQuery;
  Rec:TUniqueRecord;
  F: TDBField;
begin
  inherited RefreshConstraintUnique;
  Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(pgSqlTextModule.sqlPgConstUNQ.ExpandMacros);
  try
    Q.ParamByName('conrelid').AsInteger:=FOID;
    Q.Open;
    while not Q.Eof do
    begin
      Rec:=TUniqueRecord.Create;
      FConstraintList.Add(Rec);
      Rec.Name:=Q.FieldByName('conname').AsString;
      Rec.FieldList:=ConvertFieldList(Q.FieldByName('conkey').AsString, Self);
      Rec.Description:=Q.FieldByName('description').AsString;

      { TODO : Необходимо написать процедуру создания списка полей в UNIQ }
      F:=Fields.FieldByName(Rec.FieldList);
      if Assigned(F) then
        F.FieldUNIC:=true;

      Q.Next;
    end;
  finally
    Q.Free;
  end;
//  TSQLEnginePostgre(OwnerDB).MetaTranCommit;
end;

procedure TPGTable.RefreshConstraintCheck;
var
  I:integer;
  Q:TZQuery;
  Rec:TTableCheckConstraintRecord;
begin
  inherited RefreshConstraintCheck;

  Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(pgSqlTextModule.sqlTableConstraint.Strings.Text);
  try
    Q.ParamByName('conrelid').AsInteger:=FOID;
    Q.Open;
    while not Q.Eof do
    begin
      Rec:=TTableCheckConstraintRecord.Create;
      FConstraintList.Add(Rec);
      Rec.Name:=Q.FieldByName('conname').AsString;
      Rec.SQLBody:=Q.FieldByName('consrc').AsString;
      Rec.Description:=Q.FieldByName('description').AsString;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;
(*
function TPGTable.TableCheckConstraintDrop(const AName: string): boolean;
var
  R:TPrimaryKeyRecord;
begin
  if State = sdboEdit then
  begin
    Result:=ExecSQLScript(Format(sql_PG_FKDrop, [CaptionFullPatch, AName]), [sepInTransaction, sepShowCompForm], OwnerDB);
    if Result then
      TableCheckConstraintRefresh;
  end
  else
  begin
    R:=ConstraintFind(AName);
    if Assigned(R) then
    begin
      FConstraintList.Remove(R);
      R.Free;
    end;
  end;
end;
*)

constructor TPGTable.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
  begin
    FOID:=ADBItem.ObjId;
    FACLListStr:=ADBItem.ObjACLList;
  end;

  FACLList:=TPGACLList.Create(Self);
  FACLList.ObjectGrants:=[ogSelect, ogInsert, ogUpdate, ogDelete, ogReference, ogTruncate, ogTrigger, ogWGO];
  if FACLListStr<>'' then
    TPGACLList(FACLList).ParseACLListStr(FACLListStr);
  FAutovacuumOptions:=TPGAutovacuumOptions.Create(false);
  FToastAutovacuumOptions:=TPGAutovacuumOptions.Create(true);
  FStorageParameters:=TStringList.Create;

  UITableOptions:=[utReorderFields, utRenameTable,
     utAddFields, utEditField, utDropFields,
     utAddFK, utEditFK, utDropFK,
     utAddUNQ, utDropUNQ,
     utAlterAddFieldInitialValue,
     utAlterAddFieldFK,
     utSetFKName];

  FSchema:=TPGTablesRoot(AOwnerRoot).FSchema;
  SchemaName:=FSchema.Caption;
  FSystemObject:=FSchema.SystemObject;
  FInhTables:=TList.Create;
  FRuleList:=TPGRuleList.Create(Self);
  FCheckConstraints:=TList.Create;


  FDataSet:=TZQuery.Create(nil);
  TZQuery(FDataSet).Connection:=TSQLEnginePostgre(OwnerDB).FPGConnection;
  FDataSet.AfterOpen:=@DataSetAfterOpen;
  ZUpdateSQL:=TZUpdateSQL.Create(nil);
  TZQuery(FDataSet).UpdateObject:=ZUpdateSQL;

  FTriggerList[0]:=TList.Create;  //before insert
  FTriggerList[1]:=TList.Create;  //after insert
  FTriggerList[2]:=TList.Create;  //before update
  FTriggerList[3]:=TList.Create;  //after update
  FTriggerList[4]:=TList.Create;  //before delete
  FTriggerList[5]:=TList.Create;  //after delete
end;

destructor TPGTable.Destroy;
begin
  FreeAndNil(FTriggerList[0]);  //before insert
  FreeAndNil(FTriggerList[1]);  //after insert
  FreeAndNil(FTriggerList[2]);  //before update
  FreeAndNil(FTriggerList[3]);  //after update
  FreeAndNil(FTriggerList[4]);  //before delete
  FreeAndNil(FTriggerList[5]);  //after delete

  FreeAndNil(ZUpdateSQL);
  FreeAndNil(FInhTables);
  FreeAndNil(FRuleList);
  FreeAndNil(FCheckConstraints);
  FreeAndNil(FStorageParameters);
  FreeAndNil(FAutovacuumOptions);
  FreeAndNil(FToastAutovacuumOptions);

  inherited Destroy;
end;

class function TPGTable.DBClassTitle: string;
begin
  Result:='Table';
end;

function TPGTable.CreateSQLObject: TSQLCommandDDL;
begin
  if State <> sdboCreate then
  begin
    Result:=TPGSQLAlterTable.Create(nil);
    Result.Name:=Caption;
    TPGSQLAlterTable(Result).SchemaName:=Schema.Caption;
  end
  else
  begin
    Result:=TPGSQLCreateTable.Create(nil);
    TPGSQLCreateTable(Result).SchemaName:=Schema.Caption;
    TPGSQLCreateTable(Result).StorageParameters.Assign(FStorageParameters);
  end;
end;

procedure TPGTable.OnCloseEditorWindow;
begin
  inherited OnCloseEditorWindow;
  if Assigned(FDataSet) and FDataSet.Active then
    FDataSet.Close;
end;

function TPGTable.RenameObject(ANewName: string): Boolean;
var
  FCmd: TPGSQLAlterTable;
  Op: TAlterTableOperator;
begin
  if (State = sdboCreate) then
  begin
    Caption:=ANewName;
    Result:=true;
  end
  else
  begin
    FCmd:=TPGSQLAlterTable.Create(nil);
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

procedure TPGTable.RefreshObject;
var
  Q:TZQuery;
  i: Integer;
begin
  inherited RefreshObject;
  FACLListStr:='';
  FStorageParameters.Clear;
  FAutovacuumOptions.Clear;
  FToastAutovacuumOptions.Clear;
  FToastRelOID:=0;
  if State = sdboEdit then
  begin
    Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(pgSqlTextModule.sqlPGRelation.Strings.Text);
    try
      Q.ParamByName('relname').AsString:=Caption;
      Q.ParamByName('relnamespace').AsInteger:=FSchema.SchemaId;
      Q.Open;
      if Q.RecordCount>0 then
      begin
        FDescription:=Q.FieldByName('description').AsString;
        FOID:=Q.FieldByName('oid').AsInteger;
        FOwnerID:=Q.FieldByName('relowner').AsInteger;
        FTableSpaceID:=Q.FieldByName('reltablespace').AsInteger;
        FTableTemp:=Q.FieldByName('relpersistence').AsString = 't';
        FTableUnloged:=Q.FieldByName('relpersistence').AsString = 'u';
        FTableHasOIDS:=Q.FieldByName('relhasoids').AsBoolean;
        FRelOptions:=Q.FieldByName('reloptions').AsString;
        FToastRelOID:=Q.FieldByName('reltoastrelid').AsInteger;
        FToastRelOptions:=Q.FieldByName('tst_reloptions').AsString;
        FACLListStr:=Q.FieldByName('relacl').AsString;
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

    RefreshFieldList;
    RefreshInheritedTables;
    FRuleList.RuleListRefresh;
  end;
end;

procedure TPGTable.RefreshDependencies;
begin
  TSQLEnginePostgre(OwnerDB).RefreshDependencies(Self, FOID);
end;

procedure TPGTable.RefreshDependenciesField(Rec: TDependRecord);
begin
  //
end;

procedure TPGTable.RefreshInheritedTables;
var
  FQuery:TZQuery;
  I, O:integer;
  Rec:TPGField;
  Sh:TPGSchema;
  Pgt:TPGTable;
begin
  if State = sdboCreate then exit;

  FInhTables.Clear;

  FQuery:=TSQLEnginePostgre(OwnerDB).GetSQLQuery( pgSqlTextModule.sqlPGTableInerited.Strings.Text);
  try
    FQuery.ParamByName('inhrelid').AsInteger:=FOID;
    FQuery.Open;
    while not FQuery.Eof do
    begin
      O:=FQuery.FieldByName('inhparent').AsInteger;

      for i:=0 to TSQLEnginePostgre(OwnerDB).SchemasRoot.CountGroups - 1 do
      begin
        Sh:=TSQLEnginePostgre(OwnerDB).SchemasRoot.Groups[i] as TPGSchema;
        Pgt:=Sh.TablesRoot.PGTableByOID(O);
        if Assigned(Pgt) then
        begin
          FInhTables.Add(Pgt);
          break;
        end;
      end;
      FQuery.Next;
    end;
  finally
    FQuery.Free;
  end;
end;

function TPGTable.InheritedTablesCount: integer;
begin
  Result:=FInhTables.Count;
end;

function TPGTable.InheritedTable(AIndex: integer): TPGTable;
begin
  Result:=TPGTable(FInhTables[AIndex]);
end;

procedure TPGTable.BeforeCreateObject;
begin
  inherited BeforeCreateObject;
end;

function TPGTable.AfterCreateObject: boolean;
var
  FTblName:string;
  SQLLines:TStringList;
begin
  Result:=false;
  if State = sdboCreate then
  begin
    SQLLines:=TStringList.Create;
    try
      FTblName:=FTableNameCreate;

      InternalCreateDLL(SQLLines, FTblName);
      Result:=ExecSQLScriptEx(SQLLines, [sepInTransaction, sepShowCompForm], OwnerDB);
      if Result then
      begin
        State:=sdboEdit;
        Caption:= ExtractObjectName(FTableNameCreate);
      end;
    finally
      SQLLines.Free;
    end;
    RefreshObject;
  end
end;

type
  TSQLParamState = (spsNormal, spsNew, spsOld);

function TPGTable.DataSet(ARecCountLimit: Integer): TDataSet;

function MakeSQLWhere(ASQLParamState:TSQLParamState):string;
var
  F: TDBField;
begin
  Result:='';
  for F in Fields do
    if F.FieldPK then
    begin
      if Result<>'' then
        Result:=Result + ' and ';
      case ASQLParamState of
        spsNew:Result:=Result + '('+DoFormatName(F.FieldName) + ' = :new_' + F.FieldName+')';
        spsOld:Result:=Result + '('+DoFormatName(F.FieldName) + ' = :old_' + F.FieldName+')';
      else
        //spsNormal
        Result:=Result + '('+DoFormatName(F.FieldName) + ' = :' + F.FieldName+')';
      end;
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
    Result:=Result + DoFormatName(F.FieldName) +' = :'+F.FieldName + ',';
  if Result <> '' then
    Result:= Copy(Result, 1, Length(Result) - 1);
end;

function MakeOrderBy:string;
var
  F: TDBField;
begin
  Result:='';
  for F in Fields do
    if F.FieldPK then
    begin
      if Result<>'' then
        Result:=Result + ', ';
      Result:=Result + DoFormatName(F.FieldName);
    end;
  //Условие добавляется если есть первичный ключ
  if Result<>'' then
    Result:=' order by '+Result;
end;

begin
  if not FDataSet.Active then
  begin
    RefreshConstraintPrimaryKey;
    TZQuery(FDataSet).SQL.Text:='select * from '+CaptionFullPatch+MakeOrderBy;

    if ARecCountLimit > -1 then
      TZQuery(FDataSet).SQL.Text:=TZQuery(FDataSet).SQL.Text+' limit '+IntToStr(ARecCountLimit);


    ZUpdateSQL.InsertSQL.Text:='insert into ' + CaptionFullPatch + '(' + MakeSQLInsertFields(false) + ')'+
                                  ' values('+MakeSQLInsertFields(true)+')';
    ZUpdateSQL.ModifySQL.Text:='update ' + CaptionFullPatch + ' set '+ MakeSQLEditFields + MakeSQLWhere(spsOld);
    ZUpdateSQL.DeleteSQL.Text:='delete from ' + CaptionFullPatch + MakeSQLWhere(spsOld);

    if FPKCount > 0 then
    begin
      ZUpdateSQL.RefreshSQL.Text:='select * from '+CaptionFullPatch + MakeSQLWhere(spsNew);
      ZUpdateSQL.BeforeInsertSQLStatement:=@ZUpdateSQLBeforeInsertSQLStatement;
    end
    else
    begin
      ZUpdateSQL.RefreshSQL.Clear;
      ZUpdateSQL.BeforeInsertSQLStatement:=nil;
    end;
  end;
  Result:=FDataSet;
end;

{ TPGDomainsRoot }

function TPGDomainsRoot.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.sql_PG_TypesListAll.Strings.Text;
end;

function TPGDomainsRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.ObjType = 'd') and (AItem.SchemeID = SchemaId);
end;

function TPGDomainsRoot.GetObjectType: string;
begin
  Result:='Domain';
end;

constructor TPGDomainsRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okDomain;
  FDropCommandClass:=TPGSQLDropDomain;
end;

{ TPGDomain }

function TPGDomain.GetCaptionFullPatch: string;
begin
  Result:=FmtObjName(FSchema, Self);
end;

function TPGDomain.InternalGetDDLCreate: string;
var
  R: TPGSQLCreateDomain;
begin
  R:=TPGSQLCreateDomain.Create(nil);
  R.Name:=Caption;
  R.SchemaName:=Schema.Caption;
  R.DomainType:=FieldType.TypeName;
  R.TypeLen:=FieldLength;
  R.TypePrec:=FieldDecimal;
  R.NotNull:=NotNull;
  R.CharSetName:=CharSetName;
  R.CollationName:=CollationName;
  R.CheckExpression:=CheckExpression;
  R.ConstraintName:=ConstraintName;
  R.DefaultValue:=DefaultValue;
  R.Description:=Description;
  Result:=R.AsSQL;
  R.Free;
end;

constructor TPGDomain.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
  begin
    FFieldType:=OwnerDB.TypeList.FindType(ADBItem.ObjName);
    FOID:=ADBItem.ObjId;
  end;
  FSchema:=TPGDomainsRoot(AOwnerRoot).FSchema;
  SchemaName:=FSchema.Caption;
end;

destructor TPGDomain.Destroy;
begin
  inherited Destroy;
end;

class function TPGDomain.DBClassTitle: string;
begin
  Result:='Domain';
end;

procedure TPGDomain.RefreshDependencies;
begin
  TSQLEnginePostgre(OwnerDB).RefreshDependencies(Self, FOID);
end;

function TPGDomain.CreateSQLObject: TSQLCommandDDL;
begin
  if State = sdboCreate then
    Result:=TPGSQLCreateDomain.Create(nil)
  else
  begin
    Result:=TPGSQLAlterDomain.Create(nil);
    Result.Name:=Caption;
{    TPGSQLAlterDomain(Result).OldNotNull:=NotNull;
    TPGSQLAlterDomain(Result).Old_DefaultValue:=DefaultValue;}
  end;
  TPGSQLCreateDomain(Result).SchemaName:=Schema.Caption;
end;

procedure TPGDomain.RefreshObject;
var
  FQuery:TZQuery;
begin
  inherited RefreshObject;

  if State = sdboCreate then exit;
  FQuery:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(pgSqlTextModule.sql_PG_DomainRefresh.Strings.Text);
  try
    FQuery.ParamByName('typname').AsString:=Caption;
    FQuery.ParamByName('nspname').AsString:=Schema.Caption;
    FQuery.Open;
    if FQuery.RecordCount>0 then
    begin
      FOID:=FQuery.FieldByName('oid').AsInteger;
      FNotNull:=FQuery.FieldByName('typnotnull').AsBoolean;
      FDescription:=FQuery.FieldByName('description').AsString;

      //pg_type.typname -- Это не нужно - уберём
      //pg_type.typisdefined, '+
      //pg_type.typlen, '+
      //pg_type.typowner, '+
      //pg_type.typelem, '+
      //pg_type.typdelim, '+
      //pg_type.typbasetype, '+
      FFieldType:=OwnerDB.TypeList.FindType(FQuery.FieldByName('base_type_name').AsString);
      if Assigned(FFieldType) then
      begin
        FFieldDecimal:=-1;
        FFieldLength:=-1;
        if FFieldType.VarDec then
        begin
          FFieldDecimal:=FQuery.FieldByName('typtypmod').AsInteger - 4;
          FFieldLength:=(FFieldDecimal and $FFFF0000) shr 16;
          FFieldDecimal:=FFieldDecimal and $FFFF;
        end
        else
        if FFieldType.VarLen then
        begin
          FFieldLength:=FQuery.FieldByName('typtypmod').AsInteger - 4;
        end;
      end;
      FDefaultValue:=FQuery.FieldByName('typdefault').AsString;
      ConstraintName:=FQuery.FieldByName('conname').AsString;
      CheckExpression:=FQuery.FieldByName('consrc').AsString;
    end;
    FQuery.Close;
  finally
    FQuery.Free;
  end;
end;

procedure TPGDomain.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
  if FDescription <> '' then
  begin
    List.Add(sDescription + ':');
    List.Add(FDescription);
  end;
end;


{ TPGSequencesRoot }

function TPGSequencesRoot.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.sql_PG_ObjListAll.Strings.Text;
end;

function TPGSequencesRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.ObjType = 'S') and (AItem.SchemeID = SchemaId);
end;

function TPGSequencesRoot.GetObjectType: string;
begin
  Result:='Sequence';
end;

constructor TPGSequencesRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okSequence;
  FDropCommandClass:=TPGSQLDropSequence;
end;

{ TPGSequence }

function TPGSequence.InternalGetDDLCreate: string;
var
  ACL:TStringList;
  FCmd: TPGSQLCreateSequence;
begin
  FCmd:=TPGSQLCreateSequence.Create(nil);
  FCmd.Name:=Caption;
  FCmd.SchemaName:=FSchema.Caption;
  FCmd.OwnedBy:='';
  FCmd.IncrementBy:=IncByValue;
  FCmd.CurrentValue:=LastValue;
  FCmd.MinValue:=MinValue;
  FCmd.MaxValue:=MaxValue;
  //FCmd.SequenceTemp:
  //FCmd.NoMinValue:
  //FCmd.NoMaxValue:
  FCmd.Start:=StartValue;
  //FCmd.Restart:=res
  FCmd.Cache:=CasheValue;
  FCmd.NoCycle:=not IsCycled;
  FCmd.Description:=Description;
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

function TPGSequence.GetCaptionFullPatch: string;
begin
  Result:=FmtObjName(FSchema, Self);
end;

constructor TPGSequence.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject
  );
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
  begin
    FOID:=ADBItem.ObjId;
    FACLListStr:=ADBItem.ObjACLList;
  end;

  FACLList:=TPGACLList.Create(Self);
  FACLList.ObjectGrants:=[ogSelect, ogUpdate, ogUsage];

  FSchema:=TPGTablesRoot(AOwnerRoot).FSchema;
  SchemaName:=FSchema.Caption;
  FIncByValue:=1;
  FMaxValue:=High(int64);
  FCasheValue:=1;
end;

class function TPGSequence.DBClassTitle: string;
begin
  Result:='Sequence';
end;

procedure TPGSequence.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
  List.Add(Caption);
  List.Add(sLastValue + ' : '+IntToStr(FLastValue));
  List.Add(sIncrement + ' : '+IntToStr(FIncByValue));
  List.Add(sMaxValue + ' : '+IntToStr(FMaxValue));
  List.Add(sMinValue + ' : '+IntToStr(FMinValue));
  List.Add(sStartValue + ' : '+IntToStr(FStartValue));
  List.Add(sIsCycled + ' : '+BoolToStr(FIsCycled));
  List.Add(sCache + ' : '+IntToStr(CasheValue));
  List.Add(sDescription + ' : '+FDescription);
end;

function TPGSequence.CreateSQLObject: TSQLCommandDDL;
begin
  if State = sdboCreate then
    Result:=TPGSQLCreateSequence.Create(nil)
  else
  begin
    Result:=TPGSQLAlterSequence.Create(nil);
    TPGSQLAlterSequence(Result).Name:=Caption;

    TPGSQLAlterSequence(Result).OwnedBy:='';
    TPGSQLAlterSequence(Result).SequenceOldOwner:='';

    TPGSQLAlterSequence(Result).SequenceOldName:=Caption;
    TPGSQLAlterSequence(Result).SequenceOldSchema:=Schema.Caption;
  end;
  TPGSQLCreateSequence(Result).SchemaName:=Schema.Caption;
end;

procedure TPGSequence.RefreshObject;
var
  FQuery:TZQuery;
  S, S1: String;
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;

  if TSQLEnginePostgre(OwnerDB).RealServerVersionMajor < 10 then
  begin
    S:=pgSqlTextModule.sqlSequence.Strings.Text;
    S1:=Format(S, [Caption, CaptionFullPatch, Caption, FSchema.SchemaId]);
  end
  else
  begin
    S:=pgSqlTextModule.sqlSequence_v10.Strings.Text;
    S1:=Format(S, [Caption, FSchema.SchemaId]);
  end;

  FQuery:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(S1);
  try
    FQuery.Open;
    if FQuery.RecordCount>0 then
    begin
      FOID:=FQuery.FieldByName('oid').AsInteger;
      FCasheValue:=FQuery.FieldByName('cache_value').AsInteger;
      FIncByValue:=FQuery.FieldByName('increment_by').AsLargeInt;
      FIsCycled:=FQuery.FieldByName('is_cycled').AsBoolean;
      FLastValue:=FQuery.FieldByName('last_value').AsLargeInt;
      FMaxValue:=FQuery.FieldByName('max_value').AsLargeInt;
      FMinValue:=FQuery.FieldByName('min_value').AsLargeInt;
      if TSQLEnginePostgre(OwnerDB).RealServerVersion > 008003 then
        FStartValue:=FQuery.FieldByName('start_value').AsLargeInt
      else
        FStartValue:=0;
      FDescription:=FQuery.FieldByName('description').AsString;
      FACLListStr:=FQuery.FieldByName('relacl').AsString;
    end;
    FQuery.Close;
  finally
    FQuery.Free;
  end;
end;

procedure TPGSequence.RefreshDependencies;
begin
  TSQLEnginePostgre(OwnerDB).RefreshDependencies(Self, FOID);
end;

procedure TPGSequence.RefreshDependenciesField(Rec: TDependRecord);
begin
  //inherited RefreshDependenciesField(Rec);
end;

{ TPGViewsRoot }

function TPGViewsRoot.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.sql_PG_ObjListAll.Strings.Text;
end;

function TPGViewsRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.ObjType = 'v') and (AItem.SchemeID = SchemaId);
end;

function TPGViewsRoot.GetObjectType: string;
begin
  Result:='View';
end;

constructor TPGViewsRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okView;
  FDropCommandClass:=TPGSQLDropView;
end;

{ TPGView }

function TPGView.GetDDLAlter: string;
var
  FCmd: TPGSQLCreateView;
  F: TDBField;
begin
  if Fields.Count = 0 then RefreshFieldList;
  FCmd:=TPGSQLCreateView.Create(nil);
  FCmd.Name:=Caption;
  FCmd.SchemaName:=FSchema.Caption;
  for F in Fields do
    FCmd.Fields.AddParam(F.FieldName);

  FCmd.SQLSelect:=SQLBody;
  Result:=FCmd.AsSQL;
  FCmd.Free;
end;

function TPGView.InternalGetDDLCreate: string;
var
  i:integer;
  S:string;
  ACL:TStringList;

  FCmd: TPGSQLCreateView;
  R: TSQLParserField;
  F: TDBField;
begin
  if Fields.Count = 0 then RefreshFieldList;
  FCmd:=TPGSQLCreateView.Create(nil);
  FCmd.Name:=Caption;
  FCmd.SchemaName:=FSchema.Caption;
  for F in Fields do
  begin
    R:=FCmd.Fields.AddParam(F.FieldName);
    R.Description:=F.FieldDescription;
  end;

  FCmd.SQLSelect:=SQLBody;
  FCmd.Description:=Description;

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

procedure TPGView.RefreshFieldList;
var
  FQuery:TZQuery;
  I:integer;
  Rec:TPGField;
begin
  if State <> sdboEdit then exit;
  Fields.Clear;
  FQuery:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(pgSqlTextModule.sqlPGRelationFields.Strings.Text); //sql_PG_RelationFields);
  try
    FQuery.ParamByName('attrelid').AsInteger:=FOID;
    FQuery.Open;
    while not FQuery.Eof do
    begin
      Rec:=Fields.Add('') as TPGField;
      Rec.LoadfromDB(FQuery);
      FQuery.Next;
    end;
  finally
    FQuery.Free;
  end;
//  TSQLEnginePostgre(OwnerDB).FPGTransaction.Commit;
end;

function TPGView.GetCaptionFullPatch: string;
begin
  Result:=FmtObjName(FSchema, Self);
end;

function TPGView.GeTDBFieldClass: TDBFieldClass;
begin
  Result:=TPGField;
end;

procedure TPGView.NotyfiOnDestroy(ADBObject: TDBObject);
var
  i: Integer;
begin
  inherited NotyfiOnDestroy(ADBObject);
  if ADBObject is TPGRule then
  begin
    i:=FRuleList.IndexOf(ADBObject);
    if i > -1 then
    begin
      FRuleList.Delete(i);
      RefreshEditor;
    end;
  end;
end;

constructor TPGView.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
  begin
    FOID:=ADBItem.ObjId;
    FACLListStr:=ADBItem.ObjACLList;
  end;

  UITableOptions:=[];
  FStorageParameters:=TStringList.Create;

  FSchema:=TPGDBRootObject(AOwnerRoot).FSchema;
  SchemaName:=FSchema.Caption;

  FACLList:=TPGACLList.Create(Self);
  FACLList.ObjectGrants:=[ogInsert, ogSelect, ogUpdate, ogDelete, ogReference, ogTrigger];
  if FACLListStr<>'' then
    TPGACLList(FACLList).ParseACLListStr(FACLListStr);

  FRuleList:=TPGRuleList.Create(Self);

  FDataSet:=TZQuery.Create(nil);
  TZQuery(FDataSet).Connection:=TSQLEnginePostgre(OwnerDB).FPGConnection;
  FDataSet.AfterOpen:=@DataSetAfterOpen;
end;

destructor TPGView.Destroy;
begin
  FreeAndNil(FRuleList);
  FreeAndNil(FStorageParameters);
  inherited Destroy;
end;

class function TPGView.DBClassTitle: string;
begin
  Result:='View';
end;

procedure TPGView.RefreshObject;
var
  Q:TZQuery;
begin
  inherited RefreshObject;
  FStorageParameters.Clear;
  FRelOptions:='';
  FToastRelOID:=0;
  FToastRelOptions:='';
  FACLListStr:='';

  if State <> sdboEdit then exit;
  Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(pgSqlTextModule.sql_PG_ViewRefresh.Strings.Text);
  try
    Q.ParamByName('relname').AsString:=Caption;
    Q.ParamByName('relnamespace').AsInteger:=FSchema.SchemaId;
    if Self is TPGMatView then
      Q.ParamByName('relkind').AsString:='m'
    else
      Q.ParamByName('relkind').AsString:='v';
    Q.Open;
    if Q.RecordCount>0 then
    begin
      FDescription:=Q.FieldByName('description').AsString;
      FOID:=Q.FieldByName('oid').AsInteger;
      FSQLBody:=Q.FieldByName('definition').AsString;
      FRelOptions:=Q.FieldByName('reloptions').AsString;

      FToastRelOID:=Q.FieldByName('reltoastrelid').AsInteger;
      FToastRelOptions:=Q.FieldByName('tst_reloptions').AsString;
      FACLListStr:=Q.FieldByName('relacl').AsString;
    end;
  finally
    Q.Free;
  end;
  if FRelOptions<>'' then
    ParsePGArrayString(FRelOptions, FStorageParameters);
  RefreshFieldList;
end;

procedure TPGView.RefreshDependencies;
begin
  TSQLEnginePostgre(OwnerDB).RefreshDependencies(Self, FOID);
end;

procedure TPGView.RefreshDependenciesField(Rec: TDependRecord);
begin
  //inherited RefreshDependenciesField(Rec);
end;

function TPGView.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=TPGSQLCreateView.Create(nil);
  TPGSQLCreateView(Result).SchemaName:=FSchema.Caption;
  Result.Name:=Caption;
end;

function TPGView.CompileSQLObject(ASqlObject: TSQLCommandDDL;
  ASqlExecParam: TSqlExecParams): boolean;
begin
  if ASqlObject is TPGSQLCreateView then
    TPGSQLCreateView(ASqlObject).SchemaName:=FSchema.Caption;

  Result:=inherited CompileSQLObject(ASqlObject, ASqlExecParam);
end;

function TPGView.TriggerNew(TriggerTypes: TTriggerTypes): TDBTriggerObject;
begin
  Result:=OwnerDB.NewObjectByKind(FSchema.Triggers, okTrigger) as TDBTriggerObject;
  if Assigned(Result) then
  begin
    Result.TriggerTable:=Self;
    Result.TriggerType:=TriggerTypes;
    Result.Active:=true;
    Result.RefreshEditor;
  end;
end;

procedure TPGView.Commit;
begin
  FDataSet.Active:=false;
end;

procedure TPGView.RollBack;
begin
  FDataSet.Active:=false;
end;

function TPGView.DataSet(ARecCountLimit: Integer): TDataSet;
begin
  if not FDataSet.Active then
  begin
    TZQuery(FDataSet).SQL.Text:='select * from '+CaptionFullPatch;//MakeSQLSelect(Caption, FBDataSet.DataBase);
    if ARecCountLimit > -1 then
      TZQuery(FDataSet).SQL.Text:=TZQuery(FDataSet).SQL.Text+' limit '+IntToStr(ARecCountLimit);

  end;
  Result:=FDataSet;
end;

{ TPGTriggersRoot }

function TPGTriggersRoot.DBMSObjectsList: string;
begin
  Result:=OwnerDB.GetMetaSQLText(0);
end;

function TPGTriggersRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.SchemeID = SchemaId);
end;


function TPGTriggersRoot.GetObjectType: string;
begin
  Result:='Trigger';
end;

constructor TPGTriggersRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okTrigger;
  FDropCommandClass:=TPGSQLDropTrigger;
end;

{ TPGTrigger }

function TPGTrigger.GetTriggerSPName: string;
var
  P:TPGFunction;
begin
  P:=GetTriggerSP;
  if Assigned(P) then
    Result:=P.CaptionFullPatch
  else
    Result:='';
end;

procedure TPGTrigger.SetTriggerSPName(const AValue: string);
begin
  //
end;

procedure TPGTrigger.SetTriggerSPId(ASpId: integer);
var
  i,j:integer;
  Sc:TPGSchema;
begin
  if FTrigSPId = ASpId then exit;
  FTrigSPId:=ASpId;

  FTriggerSP:=nil;
  for j:=0 to TSQLEnginePostgre(OwnerDB).SchemasRoot.CountGroups - 1 do
  begin
    Sc:=TSQLEnginePostgre(OwnerDB).SchemasRoot.Groups[j] as TPGSchema;
    for i:=0 to Sc.FTriggerProc.CountObject - 1 do
    begin
      if TPGFunction(Sc.FTriggerProc.Items[i]).FOID = ASpId then
      begin
        FTriggerSP:=TPGFunction(Sc.FTriggerProc.Items[i]);
        exit;
      end;
    end;
  end;
end;

procedure TPGTrigger.SetTriggerTableId(ATableId: integer);
var
  i:integer;
begin
  if (ATableId = FTrigTableId) and Assigned(FTriggerTable) then exit;
  FTrigTableId:=ATableId;

  FTriggerTable:=nil;
  for I:=0 to FSchema.TablesRoot.CountObject - 1 do
  begin
    if TPGTable(FSchema.TablesRoot.Items[i]).FOID = ATableId then
    begin
      FTriggerTable:=TPGTable(FSchema.TablesRoot.Items[i]);
      exit;
    end;
  end;
end;

function TPGTrigger.GetTriggerSP: TPGFunction;
begin
  if not Assigned(FTriggerSP) then
    RefreshObject;

  if Assigned(FTriggerSP) and not FTriggerSP.Loaded then
    FTriggerSP.RefreshObject;
  Result:=FTriggerSP;
end;

function TPGTrigger.InternalGetDDLCreate: string;
var
  TrRec:TPGTrigerDef;
  ACL:TStringList;
  i:integer;
  FCmd: TPGSQLCreateTrigger;
  S: String;
begin
  FCmd:=TPGSQLCreateTrigger.Create(nil);
  FCmd.Name:=Caption;
  FCmd.Description:=Description;
  FCmd.TriggerType:=TriggerType;
  if Active then
    FCmd.TriggerState:=ttsEnabled
  else
    FCmd.TriggerState:=ttsDisable;
  FCmd.TriggerWhen:=TriggerWhen;
  for S in UpdateFieldsWhere do
    FCmd.Params.AddParam(S);

  if Assigned(FTriggerTable) then
  begin
    FCmd.SchemaName:=FTriggerTable.SchemaName;
    FCmd.TableName:=FTriggerTable.Caption;
  end;

  if Assigned(FTriggerSP) then
  begin
    FCmd.ProcName:=FTriggerSP.Caption;
    FCmd.ProcSchema:=FTriggerSP.SchemaName;
  end;
  Result:=FCmd.AsSQL;
  FCmd.Free;
end;

function TPGTrigger.GetTableName: string;
begin
  if Assigned(FTriggerTable) then
    Result:=FTriggerTable.Caption
  else
    Result:='';;
end;

procedure TPGTrigger.SetActive(const AValue: boolean);
var
  FCmd: TPGSQLCreateTrigger;
begin
  if (State = sdboCreate) then
    FActive:=AValue
  else
  begin
    FCmd:=TPGSQLCreateTrigger.Create(nil);
    FCmd.Name:=Caption;
    FCmd.TableName:=FTriggerTable.Caption;
    FCmd.SchemaName:=FTriggerTable.SchemaName;
    if AValue then
      FCmd.TriggerState:=ttsEnabled
    else
      FCmd.TriggerState:=ttsDisable;
    if CompileSQLObject(FCmd, [sepInTransaction]) then
      FActive:=AValue;
    FCmd.Free;
  end;
end;

procedure TPGTrigger.InternalRefreshStatistic;
begin
  inherited InternalRefreshStatistic;
  Statistic.AddValue(sOID, IntToStr(FOID));
  Statistic.AddValue(sOIDFunction, IntToStr(FTrigSPId));
  if Assigned(FTriggerSP) then
    Statistic.AddValue(sFunctionName, FTriggerSP.CaptionFullPatch);
  Statistic.AddValue(sOIDTable, IntToStr(FTrigTableId));
  if Assigned(FTriggerTable) then
    Statistic.AddValue(sTableName, FTriggerTable.CaptionFullPatch);
end;

constructor TPGTrigger.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject
  );
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
  begin
    FOID:=ADBItem.ObjId;
  end;

  FUpdateFieldsWhere:=TStringList.Create;
  FSchema:=TPGTriggersRoot(AOwnerRoot).FSchema;
  SchemaName:=FSchema.Caption;
end;

destructor TPGTrigger.Destroy;
begin
  FreeAndNil(FUpdateFieldsWhere);
  inherited Destroy;
end;

class function TPGTrigger.DBClassTitle: string;
begin
  Result:='Trigger';
end;

procedure TPGTrigger.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
  List.Add(FDescription);
end;

procedure TPGTrigger.RefreshObject;
var
  Q:TZQuery;
  FTrTp:DWord;
  FSdef:string;
  PS:TPGSQLCreateTrigger;
  TT:TTriggerTypes;
begin
  TriggerType:=[];
  FActive:=true;

  inherited RefreshObject;
  if State <> sdboEdit then exit;

  Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(pgSqlTextModule.sqlTrigger.Strings.Text);
  try
    Q.ParamByName('tgname').AsString:=Caption;
    Q.ParamByName('relnamespace').AsInteger:=FSchema.SchemaId;
    Q.Open;
    if Q.RecordCount>0 then
    begin
      FSdef:=Q.FieldByName('s_tg_def').AsString;

      PS:=SQLParseCommand(FSdef, TPGSQLCreateTrigger, OwnerDB) as TPGSQLCreateTrigger;
      TT:=PS.TriggerType;
      FTriggerWhen:=PS.TriggerWhen;
      FUpdateFieldsWhere.Text:=PS.Params.AsText;
      PS.Free;

      FActive:=Q.FieldByName('tgenabled').AsString<>'D';
      FTrTp:=Q.FieldByName('tgtype').AsInteger;
      if FTrTp and $02 <> 0 then
        TriggerType:=TriggerType + [ttBefore]
      else
        TriggerType:=TriggerType + [ttAfter];

      if FTrTp and $01 <> 0 then
        TriggerType:=TriggerType + [ttRow]
      else
        TriggerType:=TriggerType + [ttStatement];

      if FTrTp and $04 <> 0 then
        TriggerType:=TriggerType + [ttInsert];

      if FTrTp and $08 <> 0 then
        TriggerType:=TriggerType + [ttDelete];

      if FTrTp and $10 <> 0 then
        TriggerType:=TriggerType + [ttUpdate];

      SetTriggerSPId(Q.FieldByName('tgfoid').AsInteger);
      SetTriggerTableId(Q.FieldByName('tgrelid').AsInteger);

      FDescription:=Q.FieldByName('description').AsString;

      { TODO : Временная проверка - надо убедиться что парсер правильно читает атрибуты триггера }
      if TT<>TriggerType then
        raise Exception.Create('Ошибка чтения парсером атрибутов триггера');
    end;
  finally
    Q.Free;
  end;
end;

procedure TPGTrigger.RefreshDependencies;
begin
  TSQLEnginePostgre(OwnerDB).RefreshDependencies(Self, FOID);
end;

procedure TPGTrigger.RefreshDependenciesField(Rec: TDependRecord);
begin
  //inherited RefreshDependenciesField(Rec);
end;

function TPGTrigger.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=TPGSQLCreateTrigger.Create(nil);
end;

function TPGTrigger.CompileSQLObject(ASqlObject: TSQLCommandDDL;
  ASqlExecParam: TSqlExecParams): boolean;
var
  P: TPGSQLCreateFunction;
  FProcSchma: TPGSchema;
  FOldState: TDBObjectState;
begin
  FOldState:=State;
  Result:=inherited CompileSQLObject(ASqlObject, ASqlExecParam);
  if (FOldState = sdboCreate) and Assigned((ASqlObject as TPGSQLCreateTrigger).TriggerFunction) then
  begin
    P:=(ASqlObject as TPGSQLCreateTrigger).TriggerFunction;
    FProcSchma:=TSQLEnginePostgre(OwnerDB).SchemasRoot.ObjByName(P.SchemaName) as TPGSchema;
    FTriggerSP:=FProcSchma.TriggerProc.NewDBObject as TPGFunction;
    FTriggerSP.Caption:=P.Name;
    FTriggerSP.State:=sdboEdit;
    FTriggerSP.RefreshObject;
    FTriggerTable.RefreshEditor;
  end
  else
  if (FOldState = sdboEdit) and Assigned((ASqlObject as TPGSQLCreateTrigger).TriggerFunction) then
  begin
    FTriggerSP.RefreshObject;
    FTriggerTable.RefreshEditor;
  end;
end;

{ TPGFunctionsRoot }

function TPGFunctionsRoot.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.sqlPGFuntions['PGFuntionList'];
end;

function TPGFunctionsRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.SchemeID = SchemaId) and
    (
      (
         (FProcType = -1)
       and
         (StrToIntDef(AItem.ObjType, -1)<>TSQLEnginePostgre(OwnerDB).FIDTypeTrigger)
       and
         (StrToIntDef(AItem.ObjType, -1)<>TSQLEnginePostgre(OwnerDB).FIDTypeEventTrigger)
      )
    or
      (
        (FProcType > -1)
       and
        (
          (TSQLEnginePostgre(OwnerDB).FIDTypeTrigger = StrToIntDef(AItem.ObjType, -2))
         or
          (TSQLEnginePostgre(OwnerDB).FIDTypeEventTrigger = StrToIntDef(AItem.ObjType, -2))
        )
      )
    );
end;

function TPGFunctionsRoot.DropObject(AItem: TDBObject): boolean;
var
  R: TPGSQLDropFunction;
  P: TDBField;
  P1: TSQLParserField;
begin
  Result:=false;
  R:=TPGSQLDropFunction.Create(nil);
  R.Name:=AItem.Caption;
  R.SchemaName:=AItem.SchemaName;
  R.BracketExists:=true;

  for P in (AItem as TPGFunction).FieldsIN do
  begin
    P1:=R.Params.AddParam('');
    P1.InReturn:=P.IOType;

    if P.FieldTypeDomain <> '' then
      P1.TypeName:=P.FieldTypeDomain
    else
      P1.TypeName:=P.FieldTypeName;
  end;

  Result:=ExecSQLScript(R.AsSQL, [sepInTransaction, sepShowCompForm], OwnerDB);

  R.Free;

  if Result then
  begin
    if Assigned(AItem.OwnerDB) then
      OwnerDB.NotyfiOnDestroy(AItem);
    FObjects.Delete(AItem);
  end;
end;

function TPGFunctionsRoot.GetObjectType: string;
begin
  //Result:='Procedure';
  Result:='Function';
end;

constructor TPGFunctionsRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okFunction;
  FDropCommandClass:=TPGSQLDropFunction;
end;

{ TPGIndexRoot }

function TPGIndexRoot.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.sql_PG_ObjListAll.Strings.Text;
end;

function TPGIndexRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.ObjType = 'i') and (AItem.SchemeID = SchemaId);
end;

function TPGIndexRoot.GetObjectType: string;
begin
  Result:='Index';
end;

constructor TPGIndexRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okIndex;
  FDropCommandClass:=TPGSQLDropIndex;
end;

function TPGIndexRoot.IndexByOID(AOID: integer): TPGIndex;
var
  i:integer;
begin
  Result:=nil;
  for i:=0 to FObjects.Count-1 do
  begin
    if TPGIndex(FObjects[i]).FOID = AOID then
    begin
      Result:=TPGIndex(FObjects[i]);
      exit;
    end;
  end;
end;

{ TPGIndex }

procedure TPGIndex.SetPGTable(const AValue: TDBDataSetObject);
begin
  if (Table=AValue) or (Table<>nil) then exit;
  Table:=AValue;
  if Table is TPGTable then
    FPGTableID:=(Table as TPGTable).FOID
  else
  if Table is TPGMatView then
    FPGTableID:=(Table as TPGMatView).FOID
  else
    raise Exception.Create('NOt implementeted')
  ;
end;

function TPGIndex.InternalGetDDLCreate: string;
var
  FCmd: TPGSQLCreateIndex;
  I: TIndexField;
  PI1: TSQLParserField;
begin
  if not Assigned(Table) then
    RefreshObject;
  FCmd:=TPGSQLCreateIndex.Create(nil);
  FCmd.Name:=Caption;
  FCmd.SchemaName:=SchemaName;
  FCmd.TableName:=Table.Caption;
  FCmd.Unique:=IndexUnique;
  FCmd.IndexMethod:=FAccessMetod;
  for I in IndexFields do
  begin
    PI1:=FCmd.Fields.AddParam(I.FieldName);
    if I.SortOrder = indDescending then
      PI1.IndexOptions.SortOrder:=I.SortOrder;
    PI1.IndexOptions.IndexNullPos:=I.NullPos;
    PI1.Collate:=I.CollateName;
  end;
  FCmd.Description:=Description;
  Result:=FCmd.AsSQL;
  FCmd.Free;
end;

function TPGIndex.GetCaptionFullPatch: string;
begin
  Result:=FmtObjName(FSchema, Self);
end;

procedure TPGIndex.InternalRefreshStatistic;
begin
  inherited InternalRefreshStatistic;
  Statistic.AddValue(sOID, IntToStr(FOID));
  if Assigned(FPGTableSpace) then
    Statistic.AddValue(sTableSpace, FPGTableSpace.Caption);
  //Проходов по индексу
  //Кортежей прочитано
  //Кортежей извлечено
  //Блоков прочитано
  //Блоков извлечено
  //Размер индекса
end;

constructor TPGIndex.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
    FOID:=ADBItem.ObjId;

  FSchema:=TPGDBRootObject(AOwnerRoot).FSchema;
  SchemaName:=FSchema.Caption;
end;

destructor TPGIndex.Destroy;
begin
  inherited Destroy;
end;


class function TPGIndex.DBClassTitle: string;
begin
  Result:='Index';
end;

procedure TPGIndex.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;

procedure TPGIndex.RefreshObject;

procedure RefreshIndexFields(AFieldCount:integer);
var
  Q:TZQuery;
  S:string;
  i:integer;
  PGIF: TIndexField;
  IOPT: LongWord;
  F: TField;
begin
  Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(pgSqlTextModule.sqlIndexFields.Strings.Text);
  Q.ParamByName('indexrelid').AsInteger:=FOID;
  try
    //Выберем индексные поля
    Q.Open;
    while not Q.EOF do
    begin

      F:=Q.FindField('coldef');
      if Q.FieldByName('coldef').AsString<>'' then
        PGIF:=IndexFields.Add(Q.FieldByName('coldef').AsString)
      else
        PGIF:=IndexFields.Add(Q.FieldByName('attname').AsString);


      S:='indoption';
      IOPT:=Q.FieldByName(S).AsInteger;
      if (IOPT and $01) <> 0 then
        PGIF.SortOrder:=indDescending
      else
        PGIF.SortOrder:= indDefault//indAscending
        ;

      if (IOPT and $02) <> 0 then
        PGIF.NullPos:=inpFirst
      else
        PGIF.NullPos:= inpDefault
        ;

      if Q.FieldByName('coll_name').AsString<>'' then
      begin;
        if Q.FieldByName('coll_nspname').AsString<>'' then
          PGIF.CollateName:=Q.FieldByName('coll_nspname').AsString + '.';
        PGIF.CollateName:=PGIF.CollateName + Q.FieldByName('coll_name').AsString;
      end;

      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

var
  Q:TZQuery;
  SSS: String;
begin
  FPGTableID:=0;
  Table:=nil;
  inherited RefreshObject;
  if State <> sdboEdit then exit;
  IndexFields.Clear;

  Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(pgSqlTextModule.sqlIndex.Strings.Text);
  try
    Q.ParamByName('index_name').AsString:=Caption;
    Q.ParamByName('schema_id').AsInteger:=FSchema.FSchemaId;
    Q.Open;
    if Q.RecordCount>0 then
    begin
      FOID:=Q.FieldByName('indexrelid').AsInteger;
      FPGTableID:=Q.FieldByName('indrelid').AsInteger;
      FIndexUnique:=Q.FieldByName('indisunique').AsBoolean;
      FIndexCluster:=Q.FieldByName('indisclustered').AsBoolean;
      Table:=FSchema.TablesRoot.PGTableByOID(FPGTableID);
      if not Assigned(Table) then
        Table:=FSchema.MatViews.PGMatViewByOID(FPGTableID);
      FDescription:=Q.FieldByName('description').AsString;
      FAccessMetod:=Q.FieldByName('amname').AsString;

      FPGTableSpaceID:=Q.FieldByName('reltablespace').AsInteger;
      FPGTableSpace:= TSQLEnginePostgre(OwnerDB).TableSpaceRoot.TableSpaceByOID(FPGTableSpaceID);
      { TODO : Необходимо доработать запрос на получение индексного выражения }
      //FIndexExpression:=Q.FieldByName('indexprs').AsString;
      SSS:=Q.FieldByName('indexprs').AsString;
      if Table.Fields.Count = 0 then
        Table.RefreshFieldList;
      RefreshIndexFields(Q.FieldByName('indnatts').AsInteger);
    end;
  finally
    Q.Free;
  end;
end;

procedure TPGIndex.RefreshDependencies;
begin
  TSQLEnginePostgre(OwnerDB).RefreshDependencies(Self, FOID);
end;

procedure TPGIndex.RefreshDependenciesField(Rec: TDependRecord);
begin
  //inherited RefreshDependenciesField(Rec);
end;

function TPGIndex.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=TPGSQLCreateIndex.Create(nil);
end;


{ TPGFunction }
procedure TPGFunction.InternalSetDescription(ACommentOn: TSQLCommentOn);
begin
  FieldsIN.SaveToSQLFields(ACommentOn.Params);
end;

function TPGFunction.GetCaptionFullPatch: string;
begin
  Result:=FmtObjName(FSchema, Self);
end;


function TPGFunction.GetNameWithParams: string;
var
  P: TDBField;
begin
  Result:='';
  for P in FieldsIN do
  begin
    if Result <> '' then Result:=Result + ',';
    Result:=Result + ' ' + PGVarTypeNames[P.IOType];
    if P.FieldTypeDomain <> '' then
      Result:=Result + ' ' + P.FieldTypeDomain
    else
      Result:=Result + ' ' + P.FieldTypeName;
  end;
  Result:=GetCaptionFullPatch+'('+Result+')';
end;

procedure TPGFunction.DoInitInParams(AParamsArray: string);
var
  S1, S2, S3: String;
  FItm: TStringList;
  i, FCnt1: Integer;
  F: TDBField;
  FModes: TCharArray;
begin
  //'{i,i,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o}|23 1043|{a_tb_client_id,a_macroquery,r_tb_client_sum_id,r_tb_client_sum_type,r_tb_client_sum_summa,r_tb_client_sum_date,r_tb_client_sum_owner_doc,r_tb_client_sum_status,r_tb_dogovor_id,r_tb_dogovor_date_start,r_tb_dogovor_number,r_tb_client_name,r_tb_client_adress,r_tb_client_kod,r_tb_client_summa_prc,r_tb_client_sum_number,r_bank_info_packet_doc_info,r_buh_prov_id,r_buh_account_number_deb,r_buh_account_number_cred,r_sum_sourse_name,r_nto_spr_peo
  S1:=Copy2SymbDel( AParamsArray, '|');
  S2:=Copy2SymbDel( AParamsArray, '|');
  S3:=AParamsArray;
  FCnt1:=ParsePGArrayChar(S1, FModes);

  FieldsIN.Clear;
  FItm:=TStringList.Create;
  ParsePGArrayString(S3, FItm);
  for i:=0 to FItm.Count-1 do
  begin
    F:=FieldsIN.Add(FItm[i]);
    if I<FCnt1 then
      case FModes[i] of
        'i':F.IOType:=spvtInput;
        'o':F.IOType:=spvtOutput;
        'b':F.IOType:=spvtInOut;
        'v':F.IOType:=spvtVariadic;
        't':F.IOType:=spvtTable;
      end
    else
      F.IOType:=spvtInput;
  end;
  FItm.Free;
end;

procedure TPGFunction.InternalInitACLList;
begin
  FACLList:=TPGACLList.Create(Self);
  FACLList.ObjectGrants:=[ogExecute, ogWGO];

  if FACLListStr<>'' then
    TPGACLList(FACLList).ParseACLListStr(FACLListStr);
end;

procedure TPGFunction.FillFieldList(List: TStrings;
  ACharCase: TCharCaseOptions; AFullNames: Boolean);
var
  F: TDBField;
  D: TDBDomain;
  LP: TLocalVariable;
begin
  if FieldsIN.Count = 0 then
    RefreshObject;

  for F in FieldsIN do
    if F.IOType in [spvtOutput, spvtInOut] then
    begin
      D:=F.FieldDomain;
      if Assigned(D) then
        LP:=TLocalVariable.Create(F.FieldName, D.CaptionFullPatch, F.FieldDescription, F.IOType)
      else
        LP:=TLocalVariable.Create(F.FieldName, F.FieldTypeRecord.TypeName, F.FieldDescription, F.IOType);
      List.AddObject(FormatStringCase(F.FieldName, ACharCase), LP);
    end;
end;

procedure TPGFunction.MakeSQLStatementsList(AList: TStrings);
begin
  AList.AddObject('DDL', TObject(Pointer(0)));
  if TSQLEnginePostgre(OwnerDB).FIDTypeTrigger <> ReturnTypeOID then
  begin;
    AList.AddObject('Fields/Parameters list', TObject(Pointer(1)));
    AList.AddObject('SELECT', TObject(Pointer(2)));
    AList.AddObject('SELECT INTO', TObject(Pointer(3)));
    AList.AddObject('FOR SELECT', TObject(Pointer(4)));
    AList.AddObject('DECLARE VARIABLE', TObject(Pointer(8)));
    AList.AddObject('Name + Type', TObject(Pointer(9)));
  end;
end;

function TPGFunction.CompileSQLObject(ASqlObject: TSQLCommandDDL;
  ASqlExecParam: TSqlExecParams): boolean;
var
//  St: TStringList;
  PGrantNew: TPGSQLGrant;
  P: TSQLParserField;
  T: TTableItem;
  A: TACLItem;
begin
  //St:=ASqlObject.SQLText;
  if ((ASqlObject is TPGSQLCreateFunction)) then
  begin
    if(ASqlObject as TPGSQLCreateFunction).IsDropFunction then
    begin
      for A in FACLList do
      begin
        if A.Grants <> [] then
        begin
          PGrantNew:=TPGSQLGrant.Create(nil);
          PGrantNew.ObjectKind:=DBObjectKind;
          PGrantNew.GrantTypes:=A.Grants;
          PGrantNew.Params.AddParam(A.UserName);
          ASqlObject.AddChild(PGrantNew);
          T:=PGrantNew.Tables.Add(CaptionFullPatch);
          for P in ASqlObject.Params do
            if P.InReturn = spvtInput then
              T.Fields.AddParam(P);
        end;
      end;
(*

      if DBObject is TPGFunction then
      begin
        SP:=TPGFunction(DBObject);
        T:=Result.Tables.Add(SP.CaptionFullPatch);
        for F in SP.FieldsIN do
        begin
          GF:=T.Fields.AddParam(F.FieldName);
          GF.InReturn:=F.IOType;

          D:=F.FieldDomain;
          if Assigned(D) then
            GF.TypeName:=D.CaptionFullPatch
          else
            GF.TypeName:=F.FieldTypeName;
        end;
      end;

      FACLList.FTempObjName:=(ASqlObject as TPGSQLCreateFunction).FunctionName;
      FACLList.MakeACLListSQL(nil, St, true);
      FACLList.FTempObjName:='';
*)
      FOID:=0;
    end;
  end;
  Result:=inherited CompileSQLObject(ASqlObject, ASqlExecParam);
end;

function TPGFunction.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=TPGSQLCreateFunction.Create(nil);
  TPGSQLCreateFunction(Result).SchemaName:=SchemaName;
  if State = sdboEdit then
  begin
    Result.Name:=Caption;
  end;
end;

function TPGFunction.InternalGetDDLCreate: string;
var
  ACL:TStringList;
  FCmd: TPGSQLCreateFunction;
  F: TDBField;
  FCntOutput: Integer;
  F1: TSQLParserField;
begin
  if not Assigned(Language) then
    RefreshObject;

  FCmd:=TPGSQLCreateFunction.Create(nil);
  FCmd.SchemaName:=SchemaName;
  FCmd.Name:=Caption;
  FCmd.SetOF:=FReturnSetType;
  FieldsIN.SaveToSQLFields(FCmd.Params);
  FCntOutput:=0;
  for F in FieldsIN do
    if F.IOType in [spvtOutput, spvtInOut] then Inc(FCntOutput);

  FCmd.Body:=ProcedureBody;
  FCmd.Description:=Description;
  if Assigned(Language) then
    FCmd.Language:=Language.Caption;
  FCmd.VolatilityCategories:=VolatilityCategories;
  FCmd.Cost:=AVGTime;

  if FCntOutput > 1 then
  begin
    F1:=FCmd.Output.AddParam('');
    F1.TypeName:='record';
  end
  else
  begin
    F1:=FCmd.Output.AddParam('');
    if ResultType.FieldTypeDomain <> '' then
      F1.TypeName:=ResultType.FieldTypeDomain
    else
      F1.TypeName:=ResultType.FieldTypeName;
  end;

  Result:=FCmd.AsSQL;
  FCmd.Free;

  if Assigned(FACLList) then
  begin
    ACL:=TStringList.Create;
    try
      FACLList.RefreshList;
      FACLList.MakeACLListSQL(nil, ACL, true);
      Result:=Result + LineEnding + LineEnding + ACL.Text;
    finally
      ACL.Free;
    end;
  end;
end;

function TPGFunction.GetEnableRename: boolean;
begin
  Result:=true;
end;

procedure TPGFunction.InternalRefreshStatistic;
var
  FQuery: TZQuery;
begin
  inherited InternalRefreshStatistic;
  Statistic.AddValue(sOID, IntToStr(FOID));

  FQuery:=TSQLEnginePostgre(OwnerDB).GetSQLQuery( pgSqlTextModule.sPGStatistics['Stat2_Functions']);
  FQuery.ParamByName('funcid').AsInteger:=FOID;
  try
    FQuery.Open;
    if FQuery.RecordCount>0 then
    begin;
      Statistic.AddValue(sStatsCallCount, RxPrettySizeName(FQuery.FieldByName('calls').AsLargeInt));
      Statistic.AddValue(sStatsFullTime, FQuery.FieldByName('total_time').AsString);
      Statistic.AddValue(sStatsFunctionTime, FQuery.FieldByName('self_time').AsString);
    end;

  finally
    FQuery.Close;
    FQuery.Free;
  end;
end;

function TPGFunction.MakeChildList: TStrings;
var
  F: TDBField;
  D: Integer;
begin
  Result:=nil;
  if (ussExpandObjectDetails in OwnerDB.UIShowSysObjects) then
  begin
    Result:=TStringList.Create;
    for F in FieldsIN do
    begin
      case F.IOType of
        spvtInput,
        spvtInOut,
        spvtVariadic:D:=85;
        spvtOutput,
        spvtTable:D:=86;
      else
        D:=-1;
      end;
      Result.AddObject(F.FieldName, TObject(Pointer(IntPtr(D))));
    end;
  end;
end;

constructor TPGFunction.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
  begin
    FOID:=ADBItem.ObjId;
    FReturnTypeOID:=StrToInt(ADBItem.ObjType);
    FACLListStr:=ADBItem.ObjACLList;
    if (ADBItem.ObjData<>'') and (ussExpandObjectDetails in OwnerDB.UIShowSysObjects) then
      DoInitInParams(ADBItem.ObjData);
  end;

  InternalInitACLList;
  FSchema:=TPGDBRootObject(AOwnerRoot).FSchema;
  SchemaName:=FSchema.Caption;

  FResultType:=TDBField.Create(Self);
end;

destructor TPGFunction.Destroy;
begin
  FreeAndNil(FResultType);
  inherited Destroy;
end;

function TPGFunction.RenameObject(ANewName: string): Boolean;
var
  FCmd: TPGSQLAlterFunction;
begin
  if (State = sdboCreate) then
  begin
    Caption:=ANewName;
    Result:=true;
  end
  else
  begin
    FCmd:=TPGSQLAlterFunction.Create(nil);
    FCmd.Name:=Caption;
    FCmd.SchemaName:=SchemaName;
    FCmd.NewName:=ANewName;
    FieldsIN.SaveToSQLFields(FCmd.Params);
    Result:=CompileSQLObject(FCmd, [sepInTransaction, sepShowCompForm, sepNotRefresh]);
    FCmd.Free;
    if Result then
    begin
      Caption:=ANewName;
      //RefreshObject;
    end;
  end;
end;

class function TPGFunction.DBClassTitle: string;
begin
  Result:='function';
end;

procedure TPGFunction.SetSqlAssistentData(const List: TStrings);
var
  S:string;
  F: TDBField;
begin
  inherited SetSqlAssistentData(List);
  if ProcedureBody = '' then
    RefreshObject;

  if FDescription<>'' then
    List.Add(FDescription);

  for F in FieldsIN do
  begin
    S:=PGVarTypeNames[F.IOType]+ ' ' + F.FieldName;
    if Assigned(F.FieldTypeRecord) then
      S:=S + ' : '+F.FieldTypeRecord.TypeName;

    if F.FieldDescription<>'' then
      S:=S+'; //'+F.FieldDescription;
    List.Add(S);
  end;
end;

function TPGFunction.CompileProc(PrcName, PrcParams, aSql: string;
  ADropBeforCompile: boolean): boolean;
var
  S:string;
  SL:TStringList;
begin
  Result:=false;
  SL:=TStringList.Create;

  if State = sdboCreate then
  begin
    //S:=FSchema.Caption + '.' + PrcName
    Caption:=PrcName;
    S:=CaptionFullPatch;
  end
  else
  begin
    if ADropBeforCompile then
    begin
      FACLList.RefreshList;
      //SL.Add( 'DROP FUNCTION '+GetNameWithParams);
      if TSQLEnginePostgre(OwnerDB).ServerVersion>=pgVersion9_1 then
        Result:=ExecSQLScript('DROP FUNCTION '+GetNameWithParams, [sepShowCompForm], OwnerDB)
      else
        SL.Add( 'DROP FUNCTION '+GetNameWithParams);
    end;
    S:=CaptionFullPatch;
  end;


  aSql:='CREATE OR REPLACE FUNCTION '+S+' '+PrcParams + ' ' + aSql;
  SL.Add(aSQL);

  if ADropBeforCompile  then
  begin
    //После пересоздания процедуры необходимо установить описание
    if FDescription<>'' then
      SL.Add(Format(ssqlDecribeObject, [ PGObjectNames[DBObjectKind], S+ ' '+PrcParams, FDescription]));
    //После пересоздания процедуры необходимо установить права доступа
    FACLList.FTempObjName:=S+ ' '+PrcParams;
    if State <> sdboCreate then
      FACLList.MakeACLListSQL(nil, SL, true);
    FACLList.FTempObjName:='';
  end;

    Result:=ExecSQLScriptEx(SL, [sepInTransaction, sepShowCompForm], OwnerDB);

  if Result and (State = sdboCreate) then
  begin
    Caption:=PrcName;
    State := sdboEdit;
  end;

  RefreshObject;
  SL.Free;
end;

procedure TPGFunction.RefreshObject;

procedure ParseParamList(CntArg:integer);
var
  aSQLPars:string;
  Q:TZQuery;
  F: TDBField;
  i: Integer;
  PT: LongInt;
  PTT: TDBMSFieldTypeRecord;
  D: TPGDomain;
begin
  aSQLPars:='select ';
  for i:=1 to CntArg do
  begin
    aSQLPars:=aSQLPars +
      Format(' pg_proc.proargtypes[%d] as t_%d,'+
             ' pg_proc.proallargtypes[%d] as ta_%d,'+
             ' cast(pg_proc.proargnames[%d] as varchar(60)) as nm_%d,'+
             ' cast(coalesce(pg_proc.proargmodes[%d], ''i'') as varchar(3)) as md_%d,',
             [i-1,i,i,i,i,i,i,i]);
  end;
  aSQLPars:=Copy(aSQLPars, 1, Length(aSQLPars) - 1) + ' from pg_proc where pg_proc.oid = '+IntToStr(FOID);

  //WriteLog(aSQLPars);

  Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(aSQLPars);
  Q.Open;
  if Q.RecordCount>0 then
  begin
    for i:=1 to CntArg do
    begin
      F:=FieldsIN.Add(Q.FieldByName('nm_'+IntToStr(i)).AsString);
      case Q.FieldByName('md_'+IntToStr(i)).AsString[1] of
        'i':F.IOType:=spvtInput;
        'o':F.IOType:=spvtOutput;
        'b':F.IOType:=spvtInOut;
        'v':F.IOType:=spvtVariadic;
        't':F.IOType:=spvtTable;
      end;

      if not Q.FieldByName('ta_'+IntToStr(i)).IsNull then
        PT:=Q.FieldByName('ta_'+IntToStr(i)).AsInteger
      else
        PT:=Q.FieldByName('t_'+IntToStr(i)).AsInteger;

      PTT:=OwnerDB.TypeList.FindTypeByID(PT);
      if Assigned(PTT) then
        F.FieldTypeName:=PTT.TypeName
      else
      begin
        D:=TSQLEnginePostgre(OwnerDB).FindDomainByID(PT);
        if Assigned(D) then
          F.FieldTypeDomain := D.CaptionFullPatch;
      end;
    end;
  end;

  Q.Free;
end;

procedure RefreshParamsDesc;
var
  aSql:TStringList;
  i:integer;
  S, S1:string;
  F: TDBField;
begin
  if FieldsIN.Count > 0 then
  begin
    aSql:=TStringList.Create;
    aSql.Text:=TrimLeft(FProcedureBody);

    i:=0;
    while (i<aSql.Count) do
    begin
      S:=aSql[i];
      if Copy(S, 1, 6) = '--$FBM' then
      begin
        Delete(S, 1, 7);
        S1:=Copy2SpaceDel(S);
        F:=FieldsIN.FieldByName(S1);
        if Assigned(F) then
          F.FieldDescription:=S
        else
          Break;
      end
      else
        Break;
      inc(i);
    end;

    if I > 0 then
      FProcedureBody:=aSql.Text;

    FreeAndNil(aSql);
  end;
end;

var
  Q:TZQuery;
  CntColums:integer;
  S:string;
  ResultPgDomain:TPGDomain;
  RP: TDBMSFieldTypeRecord;
begin
  FLanguage:=nil;
  FLanguageOID:=0;
  CntColums:=0;
  FieldsIN.Clear;
  inherited RefreshObject;
  if State = sdboEdit then
  begin
    Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(pgSqlTextModule.sqlPGFuntions['PGFuntion']);
    try
      if FOID = 0 then
        Q.ParamByName('proname').AsString:=Caption
      else
        Q.ParamByName('oid').AsInteger:=FOID;

      Q.ParamByName('pronamespace').AsInteger:=FSchema.SchemaId;
      Q.Open;
      if Q.RecordCount>0 then
      begin
        FDescription:= Q.FieldByName('description').AsString;

        if FOID = 0 then
          FOID:=Q.FieldByName('oid').AsInteger;
        FProcedureBody:=Trim(Q.FieldByName('prosrc').AsString);
        FVolatilityCategories:=StrToPGSPVolatCat(Q.FieldByName('provolatile').AsString);
        //FisWindow:=Q.FieldByName('proIsWindow').AsBoolean;

        FAVGTime:=trunc(Q.FieldByName('procost').AsFloat);
        FAVGRows:=trunc(Q.FieldByName('prorows').AsFloat);
        FACLListStr:=Q.FieldByName('proacl').AsString;

        FLanguageOID:=Q.FieldByName('prolang').AsInteger;
        FisStrict:=Q.FieldByName('proisstrict').AsBoolean;
        FReturnTypeOID:=Q.FieldByName('prorettype').AsInteger;
        { TODO : Доработать выборку результирующего типа }
        ResultPgDomain:=TSQLEnginePostgre(OwnerDB).FindDomainByID(Q.FieldByName('prorettype').AsInteger);

        if Assigned(ResultPgDomain) then
        begin
          if not ResultPgDomain.Loaded then ResultPgDomain.RefreshObject;

          ResultType.FieldTypeDomain:=ResultPgDomain.CaptionFullPatch;
//          if Assigned(ResultPgDomain.FieldType) then
          ResultType.FieldTypeName:=ResultPgDomain.FieldType.TypeName;
        end
        else
        begin
          ResultType.FieldTypeDomain:='';
          RP:=OwnerDB.TypeList.FindTypeByID(Q.FieldByName('prorettype').AsInteger);
          if Assigned(RP) then
            ResultType.FieldTypeName:=RP.TypeName
          else
            raise Exception.CreateFmt('not found type with OID = %d', [Q.FieldByName('prorettype').AsInteger]);
        end;
        FReturnSetType:=Q.FieldByName('proretset').AsBoolean;

        if Q.FieldByName('name_dims').AsString<>'' then
        begin
          { TODO : Необходимо обработать ситуацию только с колонками выходных параметров. Кол-во колонок в из запроса возвращается равным нулю! }
          S:=Q.FieldByName('name_dims').AsString;
          Delete(S, 1, Pos(':', S));
          S:=Copy(S, 1, Length(S)-1);
          if S<>'' then
            CntColums:=StrToIntDef(S, 0);
          if CntColums<=0 then
            CntColums:=Q.FieldByName('pronargs').AsInteger;

          ParseParamList(CntColums);
        end;
        RefreshParamsDesc;
      end;
    finally
      Q.Free;
    end;
  end;

  if FLanguageOID<>0 then
    FLanguage:=TSQLEnginePostgre(OwnerDB).LanguageRoot.LangByOID(FLanguageOID);

  if Assigned(FACLList) and (FACLListStr<>'') then
    TPGACLList(FACLList).ParseACLListStr(FACLListStr);
end;

procedure TPGFunction.RefreshDependencies;
begin
  TSQLEnginePostgre(OwnerDB).RefreshDependencies(Self, FOID);
end;

procedure TPGFunction.RefreshDependenciesField(Rec: TDependRecord);
begin
  //inherited RefreshDependenciesField(Rec);
end;

{ TPGField }

procedure TPGField.LoadfromDB(DS: TDataSet);
var
  D: LongInt;
  FIsArray: Boolean;
  S: String;
begin
  FieldName:=DS.FieldByName('attname').AsString;
  FieldNum:=DS.FieldByName('attnum').AsInteger;

  if DS.FieldByName('typtype').AsString = 'd' then
  begin
    FieldTypeDomain:=DS.FieldByName('typnamespace_name').AsString + '.' + DS.FieldByName('typname').AsString;
    FieldTypeName:=DS.FieldByName('base_type').AsString;
    FieldTypeShceme:=DS.FieldByName('typnamespace').AsInteger;
    FDomainID:=DS.FieldByName('atttypid').AsInteger;     //!!check!
    FieldNotNull:=false;
  end
  else
  begin
    FDomainID:=-1;
    { TODO : Пока не рализаеся тип char и "char" - надо исправить }
    //FieldTypeName:=DS.FieldByName('typname').AsString;
    S:=DS.FieldByName('typname').AsString;
    FIsArray:=false;
    if (S<>'') and (S[1]='_') then
    begin
      FIsArray:=true;
      S:=Copy(S, 2, Length(S));
    end;

    if S = 'bpchar' then
      S:='char';

    if FIsArray then
      S:=S + '[]';

    FieldTypeName:=S;
    FieldNotNull:=DS.FieldByName('attnotnull').AsBoolean;
  end;
  FieldNotNull:=DS.FieldByName('attnotnull').AsBoolean;

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
  FieldDefaultValue:=DS.FieldByName('adsrc').AsString;

  FFieldDescription:=DS.FieldByName('description').AsString;

  if not DS.FieldByName('attislocal').AsBoolean then
    IOType:=spvtInput; //not local
end;

procedure TPGField.SetFieldDescription(const AValue: string);
begin
  if AValue <> FFieldDescription then
  begin
    if Owner.State <> sdboCreate then
      ExecSQLScript(
        Format(ssqlDecribeObject, [ 'column',  Owner.CaptionFullPatch+'.'+FieldName, TrimRight(AValue)]), sysConfirmCompileDescEx + [sepInTransaction],
        Owner.OwnerDB);
    inherited SetFieldDescription(AValue);
  end;
end;

function TPGField.FieldDomainName: string;
var
  Dn:TPGDomain;
begin
  if FDomainID<>-1 then
  begin
    DN:=TSQLEnginePostgre(Owner.OwnerDB).FindDomainByID(FDomainID);
    if Assigned(DN) then
      Result:=DN.CaptionFullPatch
    else
      Result:='';
  end
  else
    Result:='';
end;

function TPGField.DDLTypeStr: string;
begin
  Result:=DoFormatName(FieldName) + DupeString(' ', 30 - Length(DoFormatName(FieldName)))+ ' ';
  if FieldTypeDomain<>'' then
    Result:=Result + FieldTypeDomain
  else
  begin
    if Assigned(FieldTypeRecord) then
      Result:=Result + FieldTypeRecord.GetFieldTypeStr(FieldSize, FieldPrec)
    else
    { TODO : Тут надо дописать обработку дополнительных типов данных }
      ;
    if FieldNotNull then
     Result:=Result + ' NOT NULL';

    if FieldDefaultValue <> '' then
       Result:=Result + ' DEFAULT '+FieldDefaultValue;
  end;
end;


{ TPGTableSpaceRoot }
function TPGTableSpaceRoot.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.sqlTableSpaces.Text['sqlTableSpace'];
end;

function TPGTableSpaceRoot.GetObjectType: string;
begin
  Result:='TableSpace';
end;

constructor TPGTableSpaceRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDropCommandClass:=TPGSQLDropTablespace;
  FDBObjectKind:=okTableSpace;
  State:=sdboVirtualObject;
end;

destructor TPGTableSpaceRoot.Destroy;
begin
  inherited Destroy;
end;

function TPGTableSpaceRoot.TableSpaceByOID(AOID: integer): TPGTableSpace;
var
  i:integer;
begin
  Result:=nil;
  for i:=0 to FObjects.Count - 1 do
  begin
    if TPGTableSpace(FObjects[i]).FOID = AOID then
    begin
      Result:=TPGTableSpace(FObjects[i]);
      exit;
    end;
  end;
end;

{ TPGLanguageRoot }

function TPGLanguageRoot.DBMSObjectsList: string;
begin
  if TSQLEnginePostgre(OwnerDB).FRealServerVersionMajor < 9 then
    Result:=pgSqlTextModule.sql_PG_LangList['sql_PG_LangList_v8']
  else
    Result:=pgSqlTextModule.sql_PG_LangList['sql_PG_LangList'];
end;

function TPGLanguageRoot.GetObjectType: string;
begin
  Result:='Language';
end;

constructor TPGLanguageRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okLanguage;
  FDropCommandClass:=TPGSQLDropLanguage;
end;

function TPGLanguageRoot.LangByOID(AOID: integer): TPGLanguage;
var
  i:integer;
begin
  Result:=nil;
  for i:=0 to FObjects.Count-1 do
  begin
    if TPGLanguage(FObjects[i]).FOID = AOID then
    begin
      Result:=TPGLanguage(FObjects[i]);
      exit;
    end;
  end;
end;

{ TPGDBRootObject }

initialization
  ///DML
  RegisterSQLStatment(TSQLEnginePostgre, TSqlCommandSelect, 'SELECT'); //SELECT — получить строки из таблицы или представления
                                                                       //SELECT INTO — создать таблицу из результатов запроса
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCommandInsert, 'INSERT INTO');
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCommandUpdate, 'UPDATE');   //UPDATE — изменить строки таблицы
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCommandDelete, 'DELETE FROM'); //DELETE — удалить записи таблицы

  RegisterSQLStatment(TSQLEnginePostgre, TPGSQL_DO, 'DO');  //DO — выполнить анонимный блок кода

{
ALTER GROUP — изменить имя роли или членство
ALTER POLICY — изменить определение политики защиты на уровне строк


}
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropAccessMethod, 'DROP ACCESS METHOD'); //DROP ACCESS METHOD — удалить метод доступа
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateAccessMethod, 'CREATE ACCESS METHOD'); //CREATE ACCESS METHOD — создать новый метод доступа

{
CREATE GROUP — создать роль в базе данных
CREATE POLICY — создать новую политику защиты на уровне строк для таблицы
CREATE ROLE — создать роль в базе данных
CREATE TRANSFORM — создать трансформацию
CREATE USER — создать роль в базе данных
}
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateUserMapping, 'CREATE USER MAPPING'); //CREATE USER MAPPING - создать сопоставление пользователя для стороннего сервера
{
DROP GROUP — удалить роль в базе данных
DROP POLICY — удалить политику защиты на уровне строк для таблицы
DROP ROLE — удалить роль в базе данных
DROP TRANSFORM — удалить трансформацию
DROP USER — удалить роль в базе данных
DROP USER MAPPING — удалить сопоставление пользователя для стороннего сервера


IMPORT FOREIGN SCHEMA — импортировать определения таблиц со стороннего сервера
INSERT — добавить строки в таблицу

}
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLVacum, 'VACUM');       //VACUUM — провести сборку мусора и, возможно, проанализировать базу данных
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLTruncate, 'TRUNCATE'); //TRUNCATE — опустошить таблицу или набор таблиц
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLStartTransaction, 'START TRANSACTION'); //START TRANSACTION — начать блок транзакции
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCommit, 'COMMIT');     //COMMIT — зафиксировать текущую транзакцию
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLEnd, 'END');           //END — зафиксировать текущую транзакцию
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLRollback, 'ROLLBACK'); //ROLLBACK — прервать текущую транзакцию
                                                                      //ROLLBACK PREPARED — отменить транзакцию, которая ранее была подготовлена для двухфазной фиксации
                                                                      //ROLLBACK TO SAVEPOINT — откатиться к точке сохранения
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAbort, 'ABORT');       //ABORT — прервать текущую транзакцию
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLBegin, 'BEGIN');       //BEGIN — начать блок транзакции
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLClose, 'CLOSE');       //CLOSE — закрыть курсор
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCheckpoint, 'CHECKPOINT'); //CHECKPOINT — записать контрольную точку в журнал транзакций
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLSet, 'SET');               //SET — изменить параметр времени выполнения
                                                                          //SET CONSTRAINTS — установить время проверки ограничений для текущей транзакции
                                                                          //SET ROLE — установить идентификатор текущего пользователя в рамках сеанса
                                                                          //SET SESSION AUTHORIZATION — установить идентификатор пользователя сеанса и идентификатор текущего пользователя в рамках сеанса
                                                                          //SET TRANSACTION — установить характеристики текущей транзакции
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLShow, 'SHOW');             //
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAnalyze, 'ANALYZE');       //ANALYZE — собрать статистику по базе данных
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCluster, 'CLUSTER');       //CLUSTER — кластеризовать таблицу согласно индексу
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCopy, 'COPY');             //COPY — копировать данные между файлом и таблицей
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDeallocate, 'DEALLOCATE'); //DEALLOCATE — освободить подготовленный оператор
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDiscard, 'DISCARD');       //DISCARD — очистить состояние сеанса
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDeclare, 'DECLARE');       //DECLARE — определить курсор
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLValues, 'VALUES');         //VALUES — вычислить набор строк
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLReindex, 'REINDEX');       //REINDEX — перестроить индексы
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLUnlisten, 'UNLISTEN');     //UNLISTEN — прекратить ожидание уведомления
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLExecute, 'EXECUTE');       //EXECUTE — выполнить подготовленный оператор
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLExplain, 'EXPLAIN');       //EXPLAIN — показать план выполнения оператора
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLFetch, 'FETCH');           //FETCH — получить результат запроса через курсор
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLListen, 'LISTEN');         //LISTEN — ожидать уведомления
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLLock, 'LOCK');             //LOCK — заблокировать таблицу
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLLoad, 'LOAD');             //LOAD — загрузить файл разделяемой библиотеки
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLMove, 'MOVE');             //MOVE — переместить курсор
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLNotify, 'NOTIFY');         //NOTIFY — сгенерировать уведомление
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLPrepare, 'PREPARE');       //PREPARE — подготовить оператор к выполнению
                                                                          //PREPARE TRANSACTION — подготовить текущую транзакцию для двухфазной фиксации
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLReassignOwned, 'REASSIGN OWNED'); //REASSIGN OWNED — сменить владельца объектов базы данных, принадлежащих заданной роли
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLReleaseSavepoint, 'RELEASE SAVEPOINT'); //RELEASE SAVEPOINT — высвободить ранее определённую точку сохранения
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLSavepoint, 'SAVEPOINT');   //SAVEPOINT — определить новую точку сохранения в текущей транзакции
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLReset, 'RESET');           //RESET — восстановить значение по умолчанию заданного параметра времени выполнения
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLSecurityLabel, 'SECURITY LABEL'); //SECURITY LABEL — определить или изменить метку безопасности, применённую к объекту
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLGrant, 'GRANT');           //GRANT — определить права доступа
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLRevoke, 'REVOKE');         //REVOKE — отозвать права доступа
  RegisterSQLStatment(TSQLEnginePostgre, TPGPLSQLReturn, 'RETURN');
  RegisterSQLStatment(TSQLEnginePostgre, TPGPLSQLRaise, 'RAISE');
  RegisterSQLStatment(TSQLEnginePostgre, TPGPLSQLPerform, 'PERFORM');

  ///DDL
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterDefaultPrivileges, 'ALTER DEFAULT PRIVILEGES'); //ALTER DEFAULT PRIVILEGES — определить права доступа по умолчанию
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterLargeObject, 'ALTER LARGE OBJECT');   //ALTER LARGE OBJECT — изменить определение большого объекта

  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateAggregate, 'CREATE AGGREGATE'); //CREATE AGGREGATE — создать агрегатную функцию
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterAggregate, 'ALTER AGGREGATE');   //ALTER AGGREGATE — изменить определение агрегатной функции
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropAggregate, 'DROP AGGREGATE');     //DROP AGGREGATE — удалить агрегатную функцию

  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateCast, 'CREATE CAST');     //CREATE CAST — создать приведение
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropCast, 'DROP CAST');         //DROP CAST — удалить приведение типа

  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropOwned, 'DROP OWNED');       //DROP OWNED — удалить объекты базы данных, принадлежащие роли

  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateCollation, 'CREATE COLLATION');  //CREATE COLLATION — создать правило сортировки
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterCollation, 'ALTER COLLATION');    //ALTER COLLATION — изменить определение правила сортировки
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropCollation, 'DROP COLLATION');      //DROP COLLATION — удалить правило сортировки

  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterConversion, 'ALTER CONVERSION');   //ALTER CONVERSION — изменить определение перекодировки
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateConversion, 'CREATE CONVERSION'); //CREATE CONVERSION — создать перекодировку
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropConversion, 'DROP CONVERSION');     //DROP CONVERSION — удалить преобразование

  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateDatabase, 'CREATE DATABASE');     //CREATE DATABASE — создать базу данных
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterDatabase, 'ALTER DATABASE');       //ALTER DATABASE — изменить атрибуты базы данных
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropDatabase, 'DROP DATABASE');         //DROP DATABASE — удалить базу данных

  //OPERATOR
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterOperator, 'ALTER OPERATOR');       //ALTER OPERATOR — изменить определение оператора
                                                                                       //ALTER OPERATOR CLASS — изменить определение класса операторов
                                                                                       //ALTER OPERATOR FAMILY — изменить определение семейства операторов
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateOperator, 'CREATE OPERATOR');     //CREATE OPERATOR — создать оператор
                                                                                       //CREATE OPERATOR CLASS — создать класс операторов
                                                                                       //CREATE OPERATOR FAMILY — создать семейство операторов
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropOperator, 'DROP OPERATOR');         //DROP OPERATOR — удалить оператор
                                                                                       //DROP OPERATOR CLASS — удалить класс операторов
                                                                                       //DROP OPERATOR FAMILY — удалить семейство операторов
  //TEXT SEARCH
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterTextSearch, 'ALTER TEXT SEARCH');  //ALTER TEXT SEARCH CONFIGURATION — изменить определение конфигурации текстового поиска
                                                                                       //ALTER TEXT SEARCH DICTIONARY — изменить определение словаря текстового поиска
                                                                                       //ALTER TEXT SEARCH PARSER — изменить определение анализатора текстового поиска
                                                                                       //ALTER TEXT SEARCH TEMPLATE — изменить определение шаблона текстового поиска

  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateTextSearchConfig, 'CREATE TEXT SEARCH CONFIGURATION');  //CREATE TEXT SEARCH CONFIGURATION — создать конфигурацию текстового поиска
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateTextSearchDictionary, 'CREATE TEXT SEARCH DICTIONARY'); //CREATE TEXT SEARCH DICTIONARY — создать словарь текстового поиска
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateTextSearchParser, 'CREATE TEXT SEARCH PARSER'); //CREATE TEXT SEARCH PARSER — создать анализатор текстового поиска
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateTextSearchTemplate, 'CREATE TEXT SEARCH TEMPLATE');//CREATE TEXT SEARCH TEMPLATE — создать шаблон текстового поиска

  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropTextSearch, 'DROP TEXT SEARCH');    //DROP TEXT SEARCH CONFIGURATION — удалить конфигурацию текстового поиска
                                                                                       //DROP TEXT SEARCH DICTIONARY — удалить словарь текстового поиска
                                                                                       //DROP TEXT SEARCH PARSER — удалить анализатор текстового поиска
                                                                                       //DROP TEXT SEARCH TEMPLATE — удалить шаблон текстового поиска
  //DOMAIN
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateDomain, 'CREATE DOMAIN');          //CREATE DOMAIN — создать домен
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterDomain, 'ALTER DOMAIN');            //ALTER DOMAIN — изменить определение домена
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropDomain, 'DROP DOMAIN');              //DROP DOMAIN — удалить домен

  //EXTENSION
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterExtension, 'ALTER EXTENSION');      //ALTER EXTENSION — изменить определение расширения
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateExtension, 'CREATE EXTENSION');    //CREATE EXTENSION — установить расширение
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropExtension, 'DROP EXTENSION');        //DROP EXTENSION — удалить расширение

  //FOREIGN TABLE
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterForeignTable, 'ALTER FOREIGN TABLE'); //ALTER FOREIGN TABLE — изменить определение сторонней таблицы
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateForeignTable, 'CREATE FOREIGN TABLE'); //CREATE FOREIGN TABLE — создать стороннюю таблицу
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropForeignTable, 'DROP FOREIGN TABLE'); //DROP FOREIGN TABLE — удалить стороннюю таблицу

  //FOREIGN DATA WRAPPER
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterForeignDataWrapper, 'ALTER FOREIGN DATA WRAPPER');   //ALTER FOREIGN DATA WRAPPER — изменить определение обёртки сторонних данных
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateForeignDataWrapper, 'CREATE FOREIGN DATA WRAPPER'); //CREATE FOREIGN DATA WRAPPER — создать новую обёртку сторонних данных
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropForeignDataWrapper, 'DROP FOREIGN DATA WRAPPER');     //DROP FOREIGN DATA WRAPPER — удалить обёртку сторонних данных

  //LANGUAGE
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterLanguage, 'ALTER LANGUAGE');        //ALTER LANGUAGE — изменить определение процедурного языка
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateLanguage, 'CREATE LANGUAGE');      //CREATE LANGUAGE — создать процедурный язык
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropLanguage, 'DROP LANGUAGE');          //DROP LANGUAGE — удалить процедурный язык

  //SERVER
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterServer, 'ALTER SERVER');            //ALTER SERVER — изменить определение стороннего сервера
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateServer, 'CREATE SERVER');          //CREATE SERVER — создать сторонний сервер
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropServer, 'DROP SERVER');              //DROP SERVER — удалить описание стороннего сервера

  //TYPE
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterType, 'ALTER TYPE');               //ALTER TYPE — изменить определение типа
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateType, 'CREATE TYPE');             //CREATE TYPE — создать новый тип данных
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropType, 'DROP TYPE');                 //DROP TYPE — удалить тип данных

  //TABLESPACE
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateTablespace, 'CREATE TABLESPACE'); //CREATE TABLESPACE — создать табличное пространство
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterTablespace, 'ALTER TABLESPACE');   //ALTER TABLESPACE — изменить определение табличного пространства
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropTablespace, 'DROP TABLESPACE');     //DROP TABLESPACE — удалить табличное пространство

  //VIEW
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateView, 'CREATE VIEW');             //CREATE VIEW — создать представление
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterView, 'ALTER VIEW');               //ALTER VIEW — изменить определение представления
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropView, 'DROP VIEW');                 //DROP VIEW — удалить представление

  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateMaterializedView, 'CREATE MATERIALIZED VIEW');  //CREATE MATERIALIZED VIEW — создать материализованное представление
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterMaterializedView, 'ALTER MATERIALIZED VIEW');    //ALTER MATERIALIZED VIEW — изменить определение материализованного представления
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropMaterializedView, 'DROP MATERIALIZED VIEW');      //DROP MATERIALIZED VIEW — удалить материализованное представление
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLRefreshMaterializedView, 'REFRESH MATERIALIZED VIEW'); //REFRESH MATERIALIZED VIEW — заменить содержимое материализованного представления

  //FUNCTION
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateFunction, 'CREATE FUNCTION');     //CREATE FUNCTION — создать функцию
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterFunction, 'ALTER FUNCTION');       //ALTER FUNCTION — изменить определение функции
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropFunction, 'DROP FUNCTION');         //DROP FUNCTION — удалить функцию

  //TRIGGER
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateTrigger, 'CREATE TRIGGER');       //CREATE TRIGGER — создать триггер
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterTrigger, 'ALTER TRIGGER');         //ALTER TRIGGER — изменить определение триггера
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropTrigger, 'DROP TRIGGER');           //DROP TRIGGER — удалить триггер

  //EVENT TRIGGER
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateEventTrigger, 'CREATE EVENT TRIGGER'); //CREATE EVENT TRIGGER — создать событийный триггер
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterEventTrigger, 'ALTER EVENT TRIGGER');   //ALTER EVENT TRIGGER — изменить определение событийного триггера
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropEventTrigger, 'DROP EVENT TRIGGER');     //DROP EVENT TRIGGER — удалить событийный триггер

  //TABLE
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateTable, 'CREATE TABLE');           //CREATE TABLE — создать таблицу
                                                                                       //CREATE TABLE AS — создать таблицу из результатов запроса
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterTable, 'ALTER TABLE');             //ALTER TABLE — изменить определение таблицы
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropTable, 'DROP TABLE');               //DROP TABLE — удалить таблицу

  //RULE
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateRule, 'CREATE RULE');             //CREATE RULE — создать правило перезаписи
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterRule, 'ALTER RULE');               //ALTER RULE — изменить определение правила
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropRule, 'DROP RULE');                 //DROP RULE — удалить правило перезаписи



  //INDEX
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateIndex, 'CREATE INDEX');           //CREATE INDEX — создать индекс
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterIndex, 'ALTER INDEX');             //ALTER INDEX — изменить определение индекса
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropIndex, 'DROP INDEX');               //DROP INDEX — удалить индекс

  //SCHEMA
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateSchema, 'CREATE SCHEMA');         //CREATE SCHEMA — создать схему
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterSchema, 'ALTER SCHEMA');           //ALTER SCHEMA — изменить определение схемы
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropSchema, 'DROP SCHEMA');             //DROP SCHEMA — удалить схему

  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateSequence, 'CREATE SEQUENCE');     //CREATE SEQUENCE — создать генератор последовательности
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterSequence, 'ALTER SEQUENCE');       //ALTER SEQUENCE — изменить определение генератора последовательности
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropSequence, 'DROP SEQUENCE');         //DROP SEQUENCE — удалить последовательность

  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateRole, 'CREATE GROUP'); //'CREATE ROLE' 'CREATE USER'
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterRole, 'ALTER ROLE');
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterGroup, 'ALTER GROUP'); //
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropGroup, 'DROP GROUP'); //'DROP ROLE' 'DROP USER'

  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCommentOn, 'COMMENT ON');        //COMMENT — задать или изменить комментарий объекта
  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLImportForeignSchema, 'IMPORT FOREIGN SCHEMA');

  RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterSystem, 'ALTER SYSTEM'); //изменить параметр конфигурации сервера

finalization
end.

{ TODO -oalexs -cPG : Не отображаются гранты на представления в скрипте }

//extensions - расширения
//CREATE FOREIGN DATA WRAPPER aa  VALIDATOR pg_catalog.postgresql_fdw_validator; ALTER FOREIGN DATA WRAPPER aa  OWNER TO postgres; COMMENT ON FOREIGN DATA WRAPPER aa IS 'aa';
//CREATE SERVER
//CREATE FOREIGN TABLE
//
//Collations - сопоставления
//FTS Configurations - Конфигурация FTS
//FTS Dictionares - Словари FTS
//FTS Parser - Парсеры FTS
//FTS Templates - Шаблоны FTS
//Foreign Tables
//Materialized Views
//Types

