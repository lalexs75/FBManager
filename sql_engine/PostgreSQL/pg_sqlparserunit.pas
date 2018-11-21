{ Free DB Manager

  Copyright (C) 2005-2018 Lagunov Aleksey  alexs75 at yandex.ru

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

unit pg_SqlParserUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, sqlObjects, fbmSqlParserUnit, SQLEngineCommonTypesUnit,
  pgTypes;

const
  PGObjectNames : array [TDBObjectKind] of string =
    ('',                             //okNone,
     'DOMAIN',                       //okDomain,
     'TABLE',                        //okTable,
     'VIEW',                         //okView,
     'TRIGGER',                      //okTrigger,
     'FUNCTION',                     //okStoredProc,
     'SEQUENCE',                     //okSequence,
     'EXCEPTION',                    //okException,
     'UDF',                          //okUDF,
     'ROLE',                         //okRole,
     'USER',                         //okUser,
     'SCHEMA',                       //okScheme,
     'GROUP',                        //okGroup,
     'INDEX',                        //okIndex,
     'TABLESPACE',                   //okTableSpace,
     'LANGUAGE',                     //okLanguage,
     '',                             //okCheckConstraint,
     '',                             //okForeignKey,
     '',                             //okPrimaryKey,
     '',                             //okUniqueConstraint,
     '',                             //okAutoIncFields,
     'RULE',                         //okRule,
     '',                             //okOther,
     '',                             //okTasks,
     'CONVERSION',                   //okConversion,
     'DATABASE',                     //okDatabase,
     'TYPE',                         //okType,
     'SERVER',                       //okServer,
     'COLUMN',                       //okColumn,
     '',                             //okCharSet,
     'COLLATION',                    //okCollation,
     '',                             //okFilter,
     '',                             //okParameter
     'ACCESS METHOD',                //okAccessMethod
     'AGGREGATE',                    //okAggregate
     'MATERIALIZED VIEW',            //okMaterializedView
     'CAST',                         //okCast
     'CONSTRAINT',                   //okConstraint
     'EXTENSION',                    //okExtension
     'FOREIGN TABLE',                //okForeignTable
     'FOREIGN DATA WRAPPER',         //okForeignDataWrapper
     'LARGE OBJECT',                 //okLargeObject
     'POLICY',                       //okPolicy
     'FUNCTION',                     //okFunction
     'EVENT TRIGGER',                //okEventTrigger
     '',                             //okAutoIncFields
     'TEXT SEARCH CONFIGURATION',    //okFTSConfig,
     'TEXT SEARCH DICTIONARY',       //okFTSDictionary,
     'TEXT SEARCH PARSER',           //okFTSParser,
     'TEXT SEARCH TEMPLATE',         //okFTSTemplate
     '',                             //okPackage
     '',                             //okPackageBody
     'TRANSFORM',                    //okTransform
     'OPERATOR',                     //okOperator,
     'OPERATOR CLASS',               //okOperatorClass,
     'OPERATOR FAMILY'               //okOperatorFamily
    );

  PGVarTypeNames : array [TSPVarType] of string =
    ('',           //spvtLocal,
     'IN',         //spvtInput,
     'OUT',        //spvtOutput,
     'INOUT',      //spvtInOut,
     'VARIADIC',   //spvtVariadic
     'TABLE',      //spvtTable
     '',           //spvtSubFunction
     ''            //spvtSubProc
    );

type
  TDiscardType = (dtAll, dtPlans, dtTemporary, dtSequences);

  //TReindexType = (riIndex, riTable, riDatabase, riSystem);

  TAlterType = (aoNone, aoModify, aoRename, aoSet, aoReset, aoSetTablespace);

  TDDLOperatorType = (dotSimple, dotClass, dotFamily);

  TUserMapingOperation = (umoUserName, umoUSER, umoCURRENT_USER, umoPUBLIC);

  //TTextSearchType = (tsoConfiguration, tsoDictionary, tsoParser, tsoTemplate);

  //TRoleType = (rtRole, rtGroup, rtUser);

  TAlterGroupOperator = (agoADD, agoDROP, agoRENAME);

  TransactionIsolationLevel = (ilNone, ilSerializable, ilRepeatableRead, ilReadCommitted, ilReadUncommitted ); //ISOLATION LEVEL

  TSetScope = (ssNone, ssSession, ssLocal);

  TTimeScope = (tsNone, tsDeferred, tsImmediate);

  TFetchType = (fetNone, fetNext, fetPrior, fetFirst, fetLast, fetAbsolute, fetRelative,
       fetCount, fetAll, fetForward, fetForwardAll, fetBackward, fetBackwardAll);

  TCopyType = (cptTo, cptFrom);
  TAbortType = (atNone, atWork, atTransaction);
  TReadWriteMode = (rwmNone, rwmReadOnly, rwmReadWrite);

  TExceptionLevel = (elDEBUG, elLOG, elINFO, elNOTICE, elWARNING, elEXCEPTION);
  TEventTriggerState = (etNone, etDisable, etEnable, etReplica, etAlways);
  TTriggerState = (ttsUnknow, ttsEnabled, ttsDisable);

  TPGOption = (pgoWithOids, pgoWithoutOids);
  TPGOptions = set of TPGOption;
  TPGSQLSetVariableType = (svtNone, svtReset, svtSet, svtSetTO);
type
//Postgre DML command

  { TPGSQLCommandUpdate }

  TPGSQLCommandUpdate = class(TSQLCommandUpdate)
  protected
    function AllowFieldAlias:boolean;override;
  public
  end;

//Postgre DDL command

  { TPGSQL_DO }

  TPGSQL_DO = class(TSQLCommandAbstract)
  private
    FBody: string;
    FLanguage: string;
    procedure DoParseDeclare(ASQLParser: TSQLParser);
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property Language:string read FLanguage write FLanguage;
    property Body:string read FBody write FBody;
  end;

  { TPGSQLCreateView }

  TPGSQLCreateView = class(TSQLCreateView)
  private
    FRecursive: boolean;
    FSQLCommandSelect: TSQLCommandAbstractSelect;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    destructor Destroy;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property SQLCommandSelect:TSQLCommandAbstractSelect read FSQLCommandSelect;
    property SchemaName;
    property Recursive:boolean read FRecursive write FRecursive;
    property SQLSelect;
  end;

  { TPGSQLAlterView }

  TPGSQLAlterView = class(TSQLCommandDDL)
  private
    FAction: TAlterTableAction;
    FColumnName: string;
    FDefaultExpression: string;
    FDropDefault: boolean;
    FNewName: string;
    FNewOwner: string;
    FNewSchema: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property Action:TAlterTableAction read FAction write FAction;
    property ColumnName:string read FColumnName write FColumnName;
    property DefaultExpression:string read FDefaultExpression write FDefaultExpression;
    property DropDefault:boolean read FDropDefault write FDropDefault;
    property NewOwner:string read FNewOwner write FNewOwner;
    property NewName:string read FNewName write FNewName;
    property NewSchema:string read FNewSchema write FNewSchema;
  end;

  { TPGSQLDropView }

  TPGSQLDropView = class(TSQLDropCommandAbstract)
  private
    FCurTable: TTableItem;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    property SchemaName;
  end;

  { TPGSQLCreateMaterializedView }

  TPGSQLCreateMaterializedView = class(TSQLCreateView)
  private
    FSQLCommandSelect: TSQLCommandAbstractSelect;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    destructor Destroy;override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property SQLCommandSelect:TSQLCommandAbstractSelect read FSQLCommandSelect;
    property SchemaName;
    property SQLSelect;
  end;

  { TPGSQLAlterMaterializedView }

  TPGSQLAlterMaterializedView = class(TSQLCommandDDL)
  private
    FAction: TAlterTableAction;
    FColumnName: string;
    FDefaultExpression: string;
    FDropDefault: boolean;
    FNewName: string;
    FNewOwner: string;
    FNewSchema: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property Action:TAlterTableAction read FAction write FAction;
    property ColumnName:string read FColumnName write FColumnName;
    property DefaultExpression:string read FDefaultExpression write FDefaultExpression;
    property DropDefault:boolean read FDropDefault write FDropDefault;
    property NewOwner:string read FNewOwner write FNewOwner;
    property NewName:string read FNewName write FNewName;
    property NewSchema:string read FNewSchema write FNewSchema;
  end;

  { TPGSQLRefreshMaterializedView }

  TRefreshMaterializedViewType = (rmvNone, rmvWithNoData, rmvWithData);
  TPGSQLRefreshMaterializedView = class(TSQLCommandDDL)
  private
    FConcurrently: boolean;
    FRefreshType: TRefreshMaterializedViewType;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property Concurrently:boolean read FConcurrently write FConcurrently;
    property RefreshType:TRefreshMaterializedViewType read FRefreshType write FRefreshType;
  end;

  { TPGSQLDropMaterializedView }

  TPGSQLDropMaterializedView = class(TSQLDropCommandAbstract)
  private
    FCurTable: TTableItem;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    property SchemaName;
  end;


  { TPGSQLDropFunction }

  TPGSQLDropFunction = class(TSQLDropCommandAbstract)
  private
    FCurParam: TSQLParserField;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    property SchemaName;
  end;

  { TPGSQLCreateFunction }

  TPGSQLCreateFunction = class(TSQLCommandCreateProcedure)
  private
    FAVGRows: integer;
    FCost: integer;
    FisWindow: boolean;
    FLanguage: string;
    FPGSQLDropFunction: TPGSQLDropFunction;
    FRetParam: TSQLParserField;
    FCurParam: TSQLParserField;
    FOutput:TSQLFields;
    FSetOF: boolean;
    FStrict: boolean;
    FVolatilityCategories: TPGSPVolatCat;
    //
    FTLanguage: TSQLTokenRecord;
    FTAS: TSQLTokenRecord;
    function GetFunctionName: string;
    function GetIsDropFunction: boolean;
    function GetOutput: TSQLFields;
    procedure DoInit;
    function GetPGSQLDropFunction: TPGSQLDropFunction;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string); override;
    procedure MakeSQL; override;
    procedure SetBody(AValue: string); override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    destructor Destroy;override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property SchemaName;
    property Output:TSQLFields read GetOutput;
    property Language:string read FLanguage write FLanguage;
    property Cost:integer read FCost write FCost;
//    property AVGTime:integer read FAVGTime;
    property AVGRows:integer read FAVGRows write FAVGRows;
    property VolatilityCategories:TPGSPVolatCat read FVolatilityCategories write FVolatilityCategories;
    property isWindow:boolean read FisWindow write FisWindow;
    property Strict:boolean read FStrict write FStrict;
    property SetOF:boolean read FSetOF write FSetOF;
    property PGSQLDropFunction:TPGSQLDropFunction read GetPGSQLDropFunction;
    property FunctionName:string read GetFunctionName;
    property IsDropFunction:boolean read GetIsDropFunction;
  end;

  { TPGSQLAlterFunction }

  TPGSQLAlterFunction = class(TSQLCommandDDL)
  private
    FCurParam: TSQLParserField;
    FNewName: string;
    FNewOwner: string;
    FNewSchema: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL; override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property SchemaName;
    property NewName: string read FNewName write FNewName;
    property NewOwner: string read FNewOwner write FNewOwner;
    property NewSchema: string read FNewSchema write FNewSchema;
  end;

  { TPGSQLCreateRule }

  TPGSQLCreateRule = class(TSQLCreateCommandAbstract)
  private
    FRelationName: string;
    //FSQLCommandRulle: TSQLCommandAbstract;
    FRuleSQL: string;
    FSQLRuleWhere: string;
  private
    FOrReplase: boolean;
    FRuleAction: TPGRuleAction;
    FRuleNothing: boolean;
    FRuleWork: TPGRuleWork;
    procedure ParseWhere(SQLParser:TSQLParser);
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property OrReplase:boolean read FOrReplase write FOrReplase;
    property RelationName:string read FRelationName write FRelationName;
    property SchemaName;
    property RuleSQL:string read FRuleSQL write FRuleSQL;
    property SQLRuleWhere:string read FSQLRuleWhere write FSQLRuleWhere;
    //property SQLCommandRulle:TSQLCommandAbstract read FSQLCommandRulle;
    property RuleAction:TPGRuleAction read FRuleAction write FRuleAction;
    property RuleNothing:boolean read FRuleNothing write FRuleNothing;
    property RuleWork:TPGRuleWork read FRuleWork write FRuleWork;
  end;

  { TPGSQLDropRule }

  TPGSQLDropRule = class(TSQLDropCommandAbstract)
  private
    FTableName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property SchemaName;
    property TableName:string read FTableName write FTableName;
  end;

  { TPGSQLCreateSchema }

  TPGSQLCreateSchema = class(TSQLCreateCommandAbstract)
  private
    FOwnerUserName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property OwnerUserName:string read FOwnerUserName write FOwnerUserName;
  end;

  { TPGSQLAlterSchema }

  TPGSQLAlterSchema = class(TSQLCommandDDL)
  private
    FOldDescription: string;
    FSchemaNewName: string;
    FSchemaNewOwner: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property SchemaNewName:string read FSchemaNewName write FSchemaNewName;
    property SchemaNewOwner:string read FSchemaNewOwner write FSchemaNewOwner;
    property OldDescription:string read FOldDescription write FOldDescription;
  end;

  { TPGSQLDropSchema }

  TPGSQLDropSchema = class(TSQLDropCommandAbstract)
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TPGSQLCreateSequence }

  TPGSQLCreateSequence = class(TSQLCreateSequence)
  private
    FCache: Int64;
    FIncrementBy: Int64;
    FNoCycle: boolean;
    FNoMaxValue: boolean;
    FNoMinValue: boolean;
    FOwnedBy: string;
    FRestart: Int64;
    FStart: Int64;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property OwnedBy:string read FOwnedBy write FOwnedBy;
    property NoMinValue:boolean read FNoMinValue write FNoMinValue;
    property NoMaxValue:boolean read FNoMaxValue write FNoMaxValue;
    property Start:Int64 read FStart write FStart;
    property Restart:Int64 read FRestart write FRestart;
    property Cache:Int64 read FCache write FCache;
    property NoCycle:boolean read FNoCycle write FNoCycle;
    property SchemaName;
  end;

  { TPGSQLAlterSequence }

  TPGSQLAlterSequence = class(TPGSQLCreateSequence)
  private
    FOldValue: Int64;
    FSequenceOldName: string;
    FSequenceOldOwner: string;
    FSequenceOldSchema: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property SequenceOldOwner:string read FSequenceOldOwner write FSequenceOldOwner ;
    property SequenceOldName:string read FSequenceOldName write FSequenceOldName;
    property SequenceOldSchema:string read FSequenceOldSchema write FSequenceOldSchema;
    property OldValue:Int64 read FOldValue write FOldValue;
  end;

  { TPGSQLDropSequence }

  TPGSQLDropSequence = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    property SchemaName;
  end;

  { TPGSQLCreateTrigger }

  TPGSQLCreateTrigger = class(TSQLCreateTrigger)
  private
    FProcName: string;
    FProcSchema: string;
    FTriggerFunction: TPGSQLCreateFunction;
    FTriggerState: TTriggerState;
    FTriggerType: TTriggerTypes;
    FTriggerWhen: string;
    procedure ParseWhen(SQLParser:TSQLParser);
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    destructor Destroy;override;
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property SchemaName;
    property TableName;
    property TriggerWhen:string read FTriggerWhen write FTriggerWhen;
    property TriggerType:TTriggerTypes read FTriggerType write FTriggerType;
    property ProcName:string read FProcName write FProcName;
    property ProcSchema:string read FProcSchema write FProcSchema;
    property TriggerState:TTriggerState read FTriggerState write FTriggerState;
    property TriggerFunction:TPGSQLCreateFunction read FTriggerFunction write FTriggerFunction;
  end;

  { TPGSQLAlterTrigger }

  TPGSQLAlterTrigger = class(TSQLCommandDDL)
  private
    FDependsName: string;
    FTriggerNewName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property TableName;
    property SchemaName;
    property TriggerNewName:string read FTriggerNewName write FTriggerNewName;
    property DependsName:string read FDependsName write FDependsName;
  end;

  { TPGSQLDropTrigger }

  TPGSQLDropTrigger = class(TSQLDropTrigger)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    property SchemaName;
  end;

  { TPGSQLCreateEventTrigger }

  TPGSQLCreateEventTrigger = class(TSQLCreateTrigger)
  private
    FEventName: string;
    FProcName: string;
    FProcSchema: string;
    FTriggerFunction: TPGSQLCreateFunction;
    FTriggerState: TTriggerState;
    FTriggerWhen: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property EventName:string read FEventName write FEventName;
    property TriggerWhen:string read FTriggerWhen write FTriggerWhen;
    property ProcName:string read FProcName write FProcName;
    property ProcSchema:string read FProcSchema write FProcSchema;
    property TriggerState:TTriggerState read FTriggerState write FTriggerState;
    property TriggerFunction:TPGSQLCreateFunction read FTriggerFunction write FTriggerFunction;
  end;

  { TPGSQLAlterEventTrigger }

  TPGSQLAlterEventTrigger = class(TSQLCommandDDL)
  private
    FNewName: string;
    FNewOwner: string;
    FState: TEventTriggerState;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property NewName:string read FNewName write FNewName;
    property NewOwner:string read FNewOwner write FNewOwner;
    property State:TEventTriggerState read FState write FState;
  end;

  { TPGSQLDropEventTrigger }

  TPGSQLDropEventTrigger = class(TSQLDropCommandAbstract)
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TPGAutoIncObject }

  TPGAutoIncObject = class(TAutoIncObject)
  public
    procedure Assign(Source:TAutoIncObject); override;
    procedure MakeObjects; override;
  end;

  { TPGSQLCreateTablePartition }

  TPGSQLPartitionType = (ptNone, ptRange, ptList);

  TPGSQLCreateTablePartition = class
  private
    FParams: TSQLFields;
    FPartitionType: TPGSQLPartitionType;
  public
    constructor Create;
    destructor Destroy;override;
    procedure Clear;
    procedure Assign(ASource:TPGSQLCreateTablePartition);
    property Params:TSQLFields read FParams;
    property PartitionType:TPGSQLPartitionType read FPartitionType write FPartitionType;
  end;

  { TPGSQLCreateTable }

  TPGSQLCreateTable = class(TSQLCreateTable)
  private
    FInheritsTables: TSQLTables;
    FOnCommitAction: TOnCommitAction;
    FOwner: string;
    FPGOptions: TPGOptions;
    FStorageParameters: TStrings;
    FTablePartition: TPGSQLCreateTablePartition;
    FTableSpace: string;
    FTableTypeName: string;
    FUnlogged: boolean;
    FVisibleType: TVisibleType;
    FCurField: TSQLParserField;
    FCurConst: TSQLConstraintItem;
    FCurTable: TTableItem;
    FCurParam: TSQLParserField;
    FUpDel: Integer;
    function GetDefaultValue(ASQLParser:TSQLParser):string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    destructor Destroy;override;
    function GetAutoIncObject:TAutoIncObject; override;
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property VisibleType:TVisibleType read FVisibleType write FVisibleType;
    property Unlogged:boolean read FUnlogged  write FUnlogged;
    property SchemaName;
    property InheritsTables:TSQLTables read FInheritsTables;
    property TableSpace:string read FTableSpace write FTableSpace;
    property OnCommitAction:TOnCommitAction read FOnCommitAction write FOnCommitAction;
    property StorageParameters:TStrings read FStorageParameters;
    property PGOptions:TPGOptions read FPGOptions write FPGOptions;
    property Owner:string read FOwner write FOwner;
    property TableTypeName:string read FTableTypeName write FTableTypeName;
    property TablePartition:TPGSQLCreateTablePartition read FTablePartition;
  end;

  { TPGSQLAlterTable }

  TPGSQLAlterTable = class(TSQLAlterTable)
  private
    FCurConstr: TSQLConstraintItem;
    FCurOperator: TAlterTableOperator;
    FOnly: boolean;
    FEnableState:TTriggerState;
    FUpDel: Integer;
    procedure AddCollumn(OP:TAlterTableOperator);
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property SchemaName;
    property Only:boolean read FOnly write FOnly;
  end;

  { TPGSQLDropTable }

  TPGSQLDropTable = class(TSQLDropCommandAbstract)
  private
    FCurTable: TTableItem;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  end;

  { TPGSQLCreateRole }

  TPGSQLCreateRole = class(TSQLCreateCommandAbstract)
  private
    FConnectionLimit: Integer;
    FPassword: string;
    FPasswordEncripted: boolean;
    //FReplication: boolean;
    FServerVersion: TPGServerVersion;
    FSysId: string;
    FUserOptions: TPGUserOptions;
    FValidUntil: String;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property Password:string read FPassword write FPassword;
    property ValidUntil:String read FValidUntil write FValidUntil;
    //property Replication:boolean read FReplication write FReplication;
{  | in role role_name [, ...]
  | in group role_name [, ...]
  | role role_name [, ...]
  | admin role_name [, ...]
  | user role_name [, ...] }
    property SysId:string read FSysId write FSysId;
    property ConnectionLimit:Integer read FConnectionLimit write FConnectionLimit;
    property UserOptions:TPGUserOptions read FUserOptions write FUserOptions;
    property ServerVersion:TPGServerVersion read FServerVersion write FServerVersion;
  end;

  { TPGSQLAlterGroup }

  TPGSQLAlterGroup = class(TSQLCommandDDL)
  private
    FGroupName: string;
    FGroupOperator: TAlterGroupOperator;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property GroupName:string read FGroupName write FGroupName;
    property GroupOperator:TAlterGroupOperator read FGroupOperator write FGroupOperator;
  end;

  { TPGSQLDropGroup }

  TPGSQLDropGroup = class(TSQLDropCommandAbstract)
  private
    //FGroupName: string;
    //FRoleType: TRoleType;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    //property GroupName:string read FGroupName write FGroupName;
    //property RoleType:TRoleType read FRoleType write FRoleType;
  end;

  { TPGSQLAlterRole }
  TPGAlterRoleType = (artModyfi, artRename, artSet, artSetFromCurrent, artReset, artResetAll);

  TPGSQLAlterRole = class(TSQLCommandDDL)
  private
    FConnectionLimit: Integer;
    FDataBaseName: string;
    FIsWith: boolean;
    FPassword: string;
    FRoleNewName: string;
    FRoleOperator: TPGAlterRoleType;
    FRoleOptions: TPGUserOptions;
    FValidUntil: string;
    FCurParam: TSQLParserField;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property RoleNewName:string read FRoleNewName write FRoleNewName;
    property RoleOperator:TPGAlterRoleType read FRoleOperator write FRoleOperator;
    property ConnectionLimit:Integer read FConnectionLimit write FConnectionLimit;
    property RoleOptions:TPGUserOptions read FRoleOptions write FRoleOptions;
    property Password:string read FPassword write FPassword;
    property IsWith:boolean read FIsWith write FIsWith;
    property ValidUntil:string read FValidUntil write FValidUntil;
    property DataBaseName:string read FDataBaseName write FDataBaseName;
  end;


  { TPGSQLCluster }

  TPGSQLCluster = class(TSQLCommandAbstract)
  private
    FIndexName: string;
    FTableName: string;
    FVerbose: boolean;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property Verbose:boolean read FVerbose write FVerbose;
    property TableName:string read FTableName write FTableName;
    property IndexName:string read FIndexName write FIndexName;
  end;

  { TPGSQLVacum }

  TPGSQLVacum = class(TSQLCommandDML)
  private
    FAnalyze: boolean;
    FCommandFormat: boolean;
    FFreeze: boolean;
    FFull: boolean;
    FVerbose: boolean;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property Full:boolean read FFull write FFull;
    property Freeze:boolean read FFreeze write FFreeze;
    property Verbose:boolean read FVerbose write FVerbose;
    property Analyze:boolean read FAnalyze write FAnalyze;
    property CommandFormat:boolean read FCommandFormat write FCommandFormat;
  end;

  { TPGSQLTruncate }

  TPGSQLTruncate = class(TSQLCommandAbstract)
  private
    FContinueIdentity: boolean;
    FDropRule: TDropRule;
    FIsOnly: boolean;
    FRestartIdentity: boolean;
    FTableName: string;
    FTTableName: TSQLTokenRecord;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property TableName: string read FTableName write FTableName;
    property DropRule:TDropRule read FDropRule write FDropRule;
    property RestartIdentity:boolean read FRestartIdentity write FRestartIdentity;
    property ContinueIdentity:boolean read FContinueIdentity write FContinueIdentity;
    property IsOnly:boolean read FIsOnly write FIsOnly;
  end;

  { TPGSQLStartTransaction }

  TPGSQLStartTransaction = class(TSQLStartTransaction)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract); override;
  end;

  { TPGSQLCommit }

  TPGSQLCommit = class(TSQLCommandAbstract)
  private
    FCommitType: TAbortType;
    FTransactionId: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property CommitType:TAbortType read FCommitType write FCommitType;
    property TransactionId:string read FTransactionId write FTransactionId;
  end;

  { TPGSQLEnd }

  TPGSQLEnd = class(TSQLCommandAbstract)
  private
    FEndType: TAbortType;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property EndType:TAbortType read FEndType write FEndType;
  end;

  { TPGSQLRollback }

  TPGSQLRollback = class(TSQLCommandAbstract)
  private
    FRollbackType: TAbortType;
    FSavepointName: string;
    FTransactionId: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property RollbackType:TAbortType read FRollbackType write FRollbackType;
    property TransactionId:string read FTransactionId write FTransactionId;
    property SavepointName:string read FSavepointName write FSavepointName;
  end;

  { TPGSQLAbort }

  TPGSQLAbort = class(TSQLCommandAbstract)
  private
    FAbortType: TAbortType;
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    property AbortType:TAbortType read FAbortType write FAbortType;
  end;

  { TPGSQLBegin }

  TPGSQLBegin = class(TSQLCommandAbstract)
  private
    FBeginType: TAbortType;
    FIsolationLevel: TransactionIsolationLevel;
    FNotDeferrable: boolean;
    FReadWriteMode: TReadWriteMode;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property BeginType:TAbortType read FBeginType write FBeginType;
    property ReadWriteMode:TReadWriteMode read FReadWriteMode write FReadWriteMode;
    property IsolationLevel:TransactionIsolationLevel read FIsolationLevel write FIsolationLevel;
    property NotDeferrable:boolean read FNotDeferrable write FNotDeferrable;
  end;

  { TPGSQLCheckpoint }

  TPGSQLCheckpoint = class(TSQLCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
  public
  end;

  { TPGSQLSet }

  TPGSQLSet = class(TSQLCommandAbstract)
  private
    FConfigurationParameter: string;
    FConfigurationParameterValue: string;
    FIsConstraints: boolean;
    FIsolationLevel: TransactionIsolationLevel;
    FNotDeferrable: boolean;
    FReadOnly: boolean;
    FRoleName: string;
    FSessionAuthorizationUserName: string;
    FSessionTransaction: boolean;
    FSetScope: TSetScope;
    FSetVarType: TPGSQLSetVariableType;
    FTimeScope: TTimeScope;
    FTimeZone: string;
    FTransaction: boolean;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property SetScope:TSetScope read FSetScope write FSetScope;
    property ConfigurationParameter:string read FConfigurationParameter write FConfigurationParameter;
    property ConfigurationParameterValue:string read FConfigurationParameterValue write FConfigurationParameterValue;
    property SetVarType:TPGSQLSetVariableType read FSetVarType write FSetVarType;
    property TimeZone:string read FTimeZone write FTimeZone;
    property TimeScope:TTimeScope read FTimeScope write FTimeScope;
    property IsConstraints:boolean read FIsConstraints write FIsConstraints;
    property RoleName:string read FRoleName write FRoleName;
    property SessionAuthorizationUserName:string read FSessionAuthorizationUserName write FSessionAuthorizationUserName;

    property Transaction:boolean read FTransaction write FTransaction;
    property SessionTransaction:boolean read FSessionTransaction write FSessionTransaction;
    property ReadOnly:boolean read FReadOnly write FReadOnly;
    property IsolationLevel:TransactionIsolationLevel read FIsolationLevel write FIsolationLevel;
    property NotDeferrable:boolean read FNotDeferrable write FNotDeferrable;

  end;

  { TPGSQLShow }

  TPGSQLShow = class(TSQLCommandAbstract)
  private
    FParamName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property ParamName: string read FParamName write FParamName;
  end;

  { TPGSQLClose }

  TPGSQLClose = class(TSQLCommandAbstract)
  private
    FCursorName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
 public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property CursorName: string read FCursorName write FCursorName;
  end;

  { TPGSQLAnalyze }

  TPGSQLAnalyze = class(TSQLCommandDDL)
  private
    FVerbose: boolean;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property Verbose:boolean read FVerbose write FVerbose;
    property SchemaName;
    property TableName;
  end;

  { TPGSQLCreateTablespace }

  TPGSQLCreateTablespace = class(TSQLCreateCommandAbstract)
  private
    FDirectory: string;
    FOwnerName: string;
    FTablespaceName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property TablespaceName:string read FTablespaceName write FTablespaceName;
    property OwnerName:string read FOwnerName write FOwnerName;
    property Directory:string read FDirectory write FDirectory;
  end;

  { TPGSQLAlterTablespace }

  TPGSQLAlterTablespace = class(TSQLCommandDDL)
  private
    FOwnerNameNew: string;
    FTablespaceName: string;
    FTablespaceNameNew: string;
    FTTableSpaceName: TSQLTokenRecord;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property TablespaceName:string read FTablespaceName write FTablespaceName;
    property TablespaceNameNew:string read FTablespaceNameNew write FTablespaceNameNew;
    property OwnerNameNew:string read FOwnerNameNew write FOwnerNameNew;
  end;

  { TPGSQLDropTablespace }

  TPGSQLDropTablespace = class(TSQLDropCommandAbstract)
  private
    FTablespaceName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property TablespaceName:string read FTablespaceName write FTablespaceName;
  end;

  { TPGSQLCopy }

  TPGSQLCopy = class(TSQLCommandDML)
  private
    FCopyType: TCopyType;
    FDelimiter: string;
    FEncodingName: string;
    FEscapeCharacter: string;
    FFileName: string;
    FFormatName: string;
    FHeader: boolean;
    FIsProgramm: boolean;
    FNotNullColumn: TSQLFields;
    FNullString: string;
    FOIDS: boolean;
    FQuoteCharacter: string;
    FQuoteColumns: TSQLFields;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    destructor Destroy;override;
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property FileName:string read FFileName write FFileName;
    property FormatName:string read FFormatName write FFormatName;
    property CopyType:TCopyType read FCopyType write FCopyType;
    property OIDS:boolean read FOIDS write FOIDS;
    property Delimiter:string read FDelimiter write FDelimiter;
    property NullString:string read FNullString write FNullString;
    property Header:boolean read FHeader write FHeader;
    property QuoteCharacter:string read FQuoteCharacter write FQuoteCharacter;
    property EscapeCharacter:string read FEscapeCharacter write FEscapeCharacter;
    property EncodingName:string read FEncodingName write FEncodingName;
    property IsProgramm:boolean read FIsProgramm write FIsProgramm;

    property QuoteColumns:TSQLFields read FQuoteColumns;
    property NotNullColumn:TSQLFields read FNotNullColumn;
  end;


  { TPGSQLDeallocate }

  TPGSQLDeallocate = class(TSQLCommandAbstract)
  private
    FStatementName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property StatementName:string read FStatementName write FStatementName;
  end;

  { TPGSQLDiscard }

  TPGSQLDiscard = class(TSQLCommandAbstract)
  private
    FDiscardType: TDiscardType;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property DiscardType:TDiscardType read FDiscardType write FDiscardType;
  end;

  { TPGSQLDeclare }
  TPGSQLDeclareOption = (doBinary, doInsensitive, doNoScroll, doScroll,
      doWith, doWithout, doHold);
  TPGSQLDeclareOptions = set of TPGSQLDeclareOption;

  TPGSQLDeclare = class(TSQLCommandAbstract)
  private
    FOptions: TPGSQLDeclareOptions;
    FQueryText: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property Options:TPGSQLDeclareOptions read FOptions write FOptions;
    property QueryText:string read FQueryText write FQueryText;
  end;

  { TPGSQLValues }

  TPGSQLValues = class(TSQLCommandDML)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
  end;

  { TPGSQLReindex }

  TPGSQLReindex = class(TSQLCommandDDL)
  private
    FForce: boolean;
    //FObjName: string;
    //FReindexType: TReindexType;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    //property ObjName:string read FObjName write FObjName;
    //property ReindexType:TReindexType read FReindexType write FReindexType;
    property Force:boolean read FForce write FForce;
  end;

  { TPGSQLUnlisten }

  TPGSQLUnlisten = class(TSQLCommandAbstract)
  private
    FChannel: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property Channel:string read FChannel write FChannel;
  end;

  { TPGSQLListen }

  TPGSQLListen = class(TSQLCommandAbstract)
  private
    FChannel: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property Channel:string read FChannel write FChannel;
  end;

  { TPGSQLLock }

  TPGSQLLockOption = (pgloTable, pgloOnly, pgloNoWait,
    pgloAccessShare, pgloRowShare, pgloRowExclusive, pgloShareUpdateExclusive,
    pgloShare, pgloShareRowExclusive, pgloExclusive, pgloAccessExclusive);
  TPGSQLLockOptions = set of TPGSQLLockOption;

  TPGSQLLock = class(TSQLCommandDML)
  private
    FCurTable: TTableItem;
    FOptions: TPGSQLLockOptions;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property Options:TPGSQLLockOptions read FOptions write FOptions;
  end;

  { TPGSQLLoad }

  TPGSQLLoad = class(TSQLCommandAbstract)
  private
    FFileName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property FileName:string read FFileName write FFileName;
  end;

  { TPGSQLMove }
  TPGSQLMoveDirection = (mdNone, mdNext, mdPrior, mdFirst, mdLast, mdAbsolute, mdRelative, mdAll,
      mdForward, mdForwardAll, mdBackward, mdBackwardAll);

  TPGSQLMoveOption = (moNone, moFrom, moIn);

  TPGSQLMove = class(TSQLCommandAbstract)
  private
    FMoveCount: integer;
    FMoveDirection: TPGSQLMoveDirection;
    FOption: TPGSQLMoveOption;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property MoveCount:integer read FMoveCount write FMoveCount;
    property MoveDirection:TPGSQLMoveDirection read FMoveDirection write FMoveDirection;
    property Option:TPGSQLMoveOption read FOption write FOption;
  end;

  { TPGSQLPrepare }

  TPGSQLPrepare = class(TSQLCommandAbstract)
  private
    FTransactionExp: string;
    FTransactionId: string;
    FTransactionName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property TransactionId:string read FTransactionId write FTransactionId;
    property TransactionName:string read FTransactionName write FTransactionName;
    property TransactionExp:string read FTransactionExp write FTransactionExp;
  end;

  { TPGSQLReassignOwned }

  TPGSQLReassignOwned = class(TSQLCommandDDL)
  private
    FNewRole: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property NewRole:string read FNewRole write FNewRole;
  end;

  { TPGSQLSecurityLabel }

  TPGSQLSecurityLabel = class(TSQLCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TPGSQLGrant }

  TPGSQLGrant = class(TSQLCommandGrant)
  private
    FAllPrivilegesShortForm: boolean;
    FGrantAllTables: boolean;
    FCurTable: TTableItem;
    FCurParam: TSQLParserField;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property GrantAllTables:boolean read FGrantAllTables write FGrantAllTables;
    property AllPrivilegesShortForm:boolean read FAllPrivilegesShortForm write FAllPrivilegesShortForm;
  end;

  { TPGSQLRevoke }

  TPGSQLRevoke = class(TSQLCommandGrant)
  private
    FCurField: TSQLParserField;
    FCurTable: TTableItem;
    FCurUSr: TSQLParserField;
    FGrantAllTables: boolean;
    FCurOpt:TObjectGrant;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property GrantAllTables:boolean read FGrantAllTables write FGrantAllTables;
  end;

  { TPGSQLAlterDefaultPrivileges }

  TPGSQLAlterDefaultPrivileges = class(TSQLCommandDDL)
  private
    FCurParam: TSQLParserField;
    FSchemas: TSQLFields;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    destructor Destroy;override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property Schemas:TSQLFields read FSchemas;
  end;

  { TPGSQLAlterLargeObject }

  TPGSQLAlterLargeObject = class(TSQLCommandDDL)
  private
    FLargeObjectOID: string;
    FNewOwner: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property LargeObjectOID:string read FLargeObjectOID write FLargeObjectOID;
    property NewOwner:string read FNewOwner write FNewOwner;
  end;


  { TPGSQLAlterAggregate }

  TPGSQLAlterAggregate = class(TSQLCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TPGSQLCreateAggregate }

  TPGSQLCreateAggregate = class(TSQLCreateCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TPGSQLDropAggregate }

  TPGSQLDropAggregate = class(TSQLDropCommandAbstract)
  private
    FAggregateName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property AggregateName:string read FAggregateName write FAggregateName;
  end;

  { TPGSQLCreateCast }

  TPGSQLCreateCast = class(TSQLCreateCommandAbstract)
  private
    FSourceType: string;
    FTargetType: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property SourceType:string read FSourceType write FSourceType;
    property TargetType:string read FTargetType write FTargetType;
  end;

  { TPGSQLDropCast }

  TPGSQLDropCast = class(TSQLDropCommandAbstract)
  private
    FSourceType: string;
    FTargetType: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property SourceType:string read FSourceType write FSourceType;
    property TargetType:string read FTargetType write FTargetType;
  end;

  { TPGSQLDropOwned }

  TPGSQLDropOwned = class(TSQLDropCommandAbstract)
  private
    FOwnedName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property OwnedName:string read FOwnedName write FOwnedName;
  end;


  { TPGSQLCreateCollation }

  TPGSQLCreateCollation = class(TSQLCreateCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TPGSQLAlterCollation }

  TPGSQLAlterCollation = class(TSQLCommandDDL)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TPGSQLDropCollation }

  TPGSQLDropCollation = class(TSQLDropCommandAbstract)
  private
    FCollationName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property CollationName:string read FCollationName write FCollationName;
  end;

  { TPGSQLAlterConversion }

  TPGSQLAlterConversion = class(TSQLCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TPGSQLCreateConversion }

  TPGSQLCreateConversion = class(TSQLCreateCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TPGSQLDropConversion }

  TPGSQLDropConversion = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TPGSQLAlterDatabase }

  TPGSQLAlterDatabase = class(TSQLCommandAbstract)
  private
    FAlterType: TAlterType;
    FConnectionLimit: integer;
    FDatabaseName: string;
    FDatabaseNewName: string;
    FDatabaseNewOwner: string;
    FDatabaseNewTablespace: string;
    FResetAll: boolean;
    FCurPar: TSQLParserField;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property AlterType:TAlterType read FAlterType write FAlterType;
    property DatabaseName:string read FDatabaseName write FDatabaseName;
    property ConnectionLimit:integer read FConnectionLimit write FConnectionLimit;
    property DatabaseNewName:string read FDatabaseNewName write FDatabaseNewName;
    property DatabaseNewOwner:string read FDatabaseNewOwner write FDatabaseNewOwner;
    property DatabaseNewTablespace:string read FDatabaseNewTablespace write FDatabaseNewTablespace;
    property ResetAll:boolean read FResetAll write FResetAll;
  end;

  { TPGSQLCreateDatabase }

  TPGSQLCreateDatabase = class(TSQLCreateDatabase)
  private
    FCurParam: TSQLParserField;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
  end;

  { TPGSQLDropDatabase }

  TPGSQLDropDatabase = class(TSQLDropCommandAbstract)
  private
    FDatabaseName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property DatabaseName:string read FDatabaseName write FDatabaseName;
  end;

  { TPGSQLAlterOperator }

  TPGSQLAlterOperator = class(TSQLCommandAbstract)
  private
    FOperatorType: TDDLOperatorType;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property OperatorType:TDDLOperatorType read FOperatorType write FOperatorType;
  end;

  { TPGSQLCreateOperator }

  TPGSQLCreateOperator = class(TSQLCreateCommandAbstract)
  private
    FOperatorType: TDDLOperatorType;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property OperatorType:TDDLOperatorType read FOperatorType write FOperatorType;
  end;

  { TPGSQLDropOperator }

  TPGSQLDropOperator = class(TSQLDropCommandAbstract)
  private
    FLeftType: string;
    FOperatorType: TDDLOperatorType;
    FRightType: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property OperatorType:TDDLOperatorType read FOperatorType write FOperatorType;
    property LeftType:string read FLeftType write FLeftType;
    property RightType:string read FRightType write FRightType;
  end;

  { TPGSQLAlterUser }

  TPGSQLAlterUser = class(TSQLCommandDDL)
  private
    FIsMapping: boolean;
    FServerName: string;
    FUserMapingOperation: TUserMapingOperation;
    FUserName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property IsMapping:boolean read FIsMapping write FIsMapping;
    property UserName:string read FUserName write FUserName;
    property ServerName:string read FServerName write FServerName;
    property UserMapingOperation:TUserMapingOperation read FUserMapingOperation write FUserMapingOperation;
  end;

  { TPGSQLDropUser }

  TPGSQLDropUser = class(TSQLDropCommandAbstract)
  private
    FIsMapping: boolean;
    FServerName: string;
    FUserMapingOperation: TUserMapingOperation;
    FUserName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property IsMapping:boolean read FIsMapping write FIsMapping;
    property UserName:string read FUserName write FUserName;
    property ServerName:string read FServerName write FServerName;
    property UserMapingOperation:TUserMapingOperation read FUserMapingOperation write FUserMapingOperation;
  end;

  { TPGSQLAlterTextSearch }

  TPGSQLAlterTextSearch = class(TSQLCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TPGSQLCreateTextSearchConfig }

  TPGSQLCreateTextSearchConfig = class(TSQLCreateCommandAbstract)
  private
    FCurParam: TSQLParserField;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure MakeSQL;override;
    property SchemaName;
    //PARSER = parser_name |
    //COPY = source_config
  end;

  { TPGSQLCreateTextSearchDictionary }

  TPGSQLCreateTextSearchDictionary = class(TPGSQLCreateTextSearchConfig)
  private
  protected
    procedure InitParserTree;override;
  public
    //TEMPLATE = template
  end;

  { TPGSQLCreateTextSearchParser }

  TPGSQLCreateTextSearchParser = class(TPGSQLCreateTextSearchConfig)
  private
  protected
    procedure InitParserTree;override;
  public
    //START = start_function ,
    //GETTOKEN = gettoken_function ,
    //END = end_function ,
    //LEXTYPES = lextypes_function
    //[, HEADLINE = headline_function ]
  end;

  { TPGSQLCreateTextSearchTemplate }

  TPGSQLCreateTextSearchTemplate = class(TPGSQLCreateTextSearchConfig)
  private
  protected
    procedure InitParserTree;override;
  public
    //[ INIT = init_function , ]
    //LEXIZE = lexize_function
  end;
  { TPGSQLDropTextSearch }

  TPGSQLDropTextSearch = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    procedure MakeSQL;override;
    property SchemaName;
  end;


  { TPGSQLAlterDomain }

  TPGSQLAlterDomain = class(TSQLAlterDomain)
  private
    FCurParam: TSQLParserField;
    FCurOp: TAlterDomainOperator;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    property SchemaName;
  end;

  { TPGSQLCreateDomain }

  TPGSQLCreateDomain = class(TSQLCreateDomain)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
   constructor Create(AParent:TSQLCommandAbstract);override;
   property SchemaName;
  end;

  { TPGSQLDropDomain }

  TPGSQLDropDomain = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TPGSQLAlterExtension }

  TPGSQLAlterExtension = class(TSQLCommandDDL)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TPGSQLCreateExtension }

  TPGSQLCreateExtension = class(TSQLCreateCommandAbstract)
  private
    FExistsWith: boolean;
    FOldVersion: string;
    FSchemaName: string;
    FVersion: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property ExistsWith:boolean read FExistsWith write FExistsWith;
    property SchemaName:string read FSchemaName write FSchemaName;
    property Version:string read FVersion write FVersion;
    property OldVersion:string read FOldVersion write FOldVersion;
  end;

  { TPGSQLDropExtension }

  TPGSQLDropExtension = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TPGSQLAlterForeignTable }

  TPGSQLAlterForeignTable = class(TSQLCommandDDL)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    procedure MakeSQL;override;
  end;

  { TPGSQLCreateForeignTable }

  TPGSQLCreateForeignTable = class(TSQLCreateCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    procedure MakeSQL;override;
  end;

  { TPGSQLDropForeignTable }

  TPGSQLDropForeignTable = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    procedure MakeSQL;override;
  end;

  { TPGSQLCreateForeignDataWrapper }

  TPGSQLCreateForeignDataWrapper = class(TSQLCreateCommandAbstract)
  private
    FHandler: string;
    FNoHandler: boolean;
    FNoValidator: boolean;
    FValidator: string;
    FCurParam: TSQLParserField;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    procedure MakeSQL;override;
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property Handler:string read FHandler write FHandler;
    property Validator:string read FValidator write FValidator;
    property NoHandler:boolean read FNoHandler write FNoHandler;
    property NoValidator:boolean read FNoValidator write FNoValidator;
  end;

  { TPGSQLAlterForeignDataWrapper }

  TPGSQLAlterForeignDataWrapper = class(TSQLCommandDDL)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    procedure MakeSQL;override;
  end;

  { TPGSQLDropForeignDataWrapper }

  TPGSQLDropForeignDataWrapper  = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    procedure MakeSQL;override;
    property SchemaName;
  end;

  { TPGSQLAlterLanguage }

  TPGSQLAlterLanguage = class(TSQLCommandAbstract)
  private
    FLanguageName: string;
    FLanguageNewName: string;
    FLanguageNewOwner: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property LanguageName:string read FLanguageName write FLanguageName;
    property LanguageNewName:string read FLanguageNewName write FLanguageNewName;
    property LanguageNewOwner:string read FLanguageNewOwner write FLanguageNewOwner;
  end;

  { TPGSQLCreateLanguage }

  TPGSQLCreateLanguage = class(TSQLCreateCommandAbstract)
  private
    FCallHandler: string;
    FInlineHandler: string;
    FLanguageName: string;
    FOrReplace: boolean;
    FTrusted: boolean;
    FValFunction: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property LanguageName:string read FLanguageName write FLanguageName;
    property Trusted:boolean read FTrusted write FTrusted;
    property OrReplace:boolean read FOrReplace write FOrReplace;
    property CallHandler:string read FCallHandler write FCallHandler;
    property InlineHandler:string read FInlineHandler write FInlineHandler;
    property ValFunction:string read FValFunction write FValFunction;
  end;

  { TPGSQLDropLanguage }

  TPGSQLDropLanguage = class(TSQLDropCommandAbstract)
  private
    FLanguageName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property LanguageName:string read FLanguageName write FLanguageName;
  end;

  { TPGSQLAlterServer }

  TPGSQLAlterServer = class(TSQLCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TPGSQLCreateServer }

  TPGSQLCreateServer = class(TSQLCreateCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TPGSQLDropServer }

  TPGSQLDropServer = class(TSQLDropCommandAbstract)
  private
    FServerName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property ServerName:string read FServerName write FServerName;
  end;

  { TPGSQLAlterType }

  TPGSQLAlterType = class(TSQLCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TPGSQLCreateType }

  TPGSQLCreateType = class(TSQLCreateCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TPGSQLDropType }

  TPGSQLDropType = class(TSQLDropCommandAbstract)
  private
    FTypeName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property TypeName:string read FTypeName write FTypeName;
  end;


  { TPGSQLReleaseSavepoint }

  TPGSQLReleaseSavepoint = class(TSQLCommandAbstract)
  private
    FSavepointName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property SavepointName:string read FSavepointName write FSavepointName;
  end;

  { TPGSQLSavepoint }

  TPGSQLSavepoint = class(TSQLCommandAbstract)
  private
    FSavepointName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property SavepointName:string read FSavepointName write FSavepointName;
  end;

  { TPGSQLReset }

  TPGSQLReset = class(TSQLCommandAbstract)
  private
    FConfigurationParameter: string;
    FResetRole: boolean;
    FResetSession: boolean;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property ConfigurationParameter:string read FConfigurationParameter write FConfigurationParameter;
    property ResetRole:boolean read FResetRole write FResetRole;
    property ResetSession:boolean read FResetSession write FResetSession;
  end;

  { TPGSQLNotify }

  TPGSQLNotify = class(TSQLCommandAbstract)
  private
    FChannel: string;
    FPayload: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property Channel:string read FChannel write FChannel;
    property Payload:string read FPayload write FPayload;
  end;

  { TPGSQLExecute }

  TPGSQLExecute = class(TSQLCommandDML)
  private
    FStatementParams: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property StatementParams:string read FStatementParams write FStatementParams;
  end;

  { TPGSQLExplain }

  TPGSQLExplain = class(TSQLCommandAbstractSelect)
  private
    FSQLCommandText: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL; override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property SQLCommandText:string read FSQLCommandText;
  end;

  { TPGSQLFetch }

  TPGSQLFetch = class(TSQLCommandAbstract)
  private
    FCount: string;
    FCursorName: string;
    FFetchType: TFetchType;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property FetchType:TFetchType read FFetchType write FFetchType;
    property Count:string read FCount write FCount;
    property CursorName:string read FCursorName write FCursorName;
  end;

  { TPGSQLCreateIndex }

  TPGSQLCreateIndex = class(TSQLCreateIndex)
  private
    FConcurrently: boolean;
    FIndexMethod: string;
    FTableSpace: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property IndexMethod:string read FIndexMethod write FIndexMethod;
    property Concurrently:boolean read FConcurrently write FConcurrently;
    property SchemaName;
    property TableSpace:string read FTableSpace write FTableSpace;
  end;

  { TPGSQLAlterIndex }

  TPGSQLAlterIndex = class(TSQLCommandDDL)
  private
    FAlterIndexCmd: TAlterType;
    FIndexName: string;
    FIndexNewName: string;
    FTablespaceName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property AlterIndexCmd:TAlterType read FAlterIndexCmd write FAlterIndexCmd;
    property IndexName:string read FIndexName write FIndexName;
    property IndexNewName:string read FIndexNewName write FIndexNewName;
    property TablespaceName:string read FTablespaceName write FTablespaceName;
  end;

  { TPGSQLDropIndex }

  TPGSQLDropIndex = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TPGPLSQLReturn }

  TPGPLSQLReturn = class(TSQLCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TPGPLSQLRaise }

  TPGPLSQLRaise = class(TSQLCommandAbstract)
  private
    FCaptionFormat: string;
    FExceptionLevel: TExceptionLevel;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property ExceptionLevel:TExceptionLevel read FExceptionLevel write FExceptionLevel;
    property CaptionFormat:string read FCaptionFormat write FCaptionFormat;
  end;

  { TPGPLSQLPerform }

  TPGPLSQLPerform = class(TSQLCommandAbstract)
  private
    FSQLQuery: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property SQLQuery:string read FSQLQuery write FSQLQuery;
  end;

  { TPGSQLDeclareLocalVar }
(*
  TPGSQLDeclareLocalVar = class(TSQLCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    function AsSQL:string;override;
  end;
*)

  { TPGSQLDeclareLocalVarInt }

  TPGSQLDeclareLocalVarInt = class(TSQLDeclareLocalVarParser)
  private
  public
    procedure ParseString(ASqlLine:string); override;
    procedure ParseDeclare(ASQLParser: TSQLParser); override;
  end;


  { TPGSQLCommentOn }

  TPGSQLCommentOn = class(TSQLCommentOn)
  private
    FAggregateParams: string;
    FIsNull: boolean;
    FLObID: integer;
    FCurParam:TSQLParserField;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    property TableName;
    property SchemaName;
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property LObID:integer read FLObID write FLObID;
    property IsNull:boolean read FIsNull write FIsNull;
    property AggregateParams:string read FAggregateParams write FAggregateParams;
  end;

  { TPGSQLImportForeignSchema }
  TPGSQLImportForeignSchemaOption = (ifsoNone, ifsoLimitTo, ifsoExcept);

  TPGSQLImportForeignSchema = class(TSQLCommandDDL)
  private
    FOption: TPGSQLImportForeignSchemaOption;
    FServerName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property ServerName:string read FServerName write FServerName;
    property SchemaName;
    property Option:TPGSQLImportForeignSchemaOption read FOption write FOption;
  end;


  { TPGSQLAlterSystem }

  TPGSQLAlterSystem = class(TSQLCommandDDL)
  private
    FAlterSystemType: TPGSQLSetVariableType;
    FParamValue: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property AlterSystemType:TPGSQLSetVariableType read FAlterSystemType write FAlterSystemType;
    property ParamValue:string read FParamValue write FParamValue;
  end;

implementation
uses strutils, rxstrutils;

procedure CreateInParamsTree(Owner:TSQLCommandDDL; InToken:TSQLTokenRecord; OutToken:TSQLTokenRecord);
var
  FT10_1, FT10_2, FT10_3, FT10_4, FT10_5, FT10_6, TSymb,
    FT10_7, FT10_8, FT10_9: TSQLTokenRecord;
begin
  FT10_1:=Owner.AddSQLTokens(stKeyword, InToken, 'IN', [], 101);
  FT10_2:=Owner.AddSQLTokens(stKeyword, InToken, 'OUT', [], 102);
  FT10_3:=Owner.AddSQLTokens(stKeyword, InToken, 'INOUT', [], 103);
  FT10_4:=Owner.AddSQLTokens(stKeyword, InToken, 'VARIADIC', [], 104);
  FT10_5:=Owner.AddSQLTokens(stIdentificator, [InToken, FT10_1, FT10_2, FT10_3, FT10_4], '', [], 105);
  FT10_6:=Owner.AddSQLTokens(stIdentificator, FT10_5, '', [], 106);
  FT10_7:=Owner.AddSQLTokens(stSymbol, FT10_6, '.', [], 107);
  FT10_7:=Owner.AddSQLTokens(stIdentificator, [FT10_7, FT10_6], '', [], 108);
  FT10_8:=Owner.AddSQLTokens(stIdentificator, FT10_7, '', [], 108);
  FT10_9:=Owner.AddSQLTokens(stIdentificator, FT10_8, '', [], 108);

  TSymb:=Owner.AddSQLTokens(stSymbol, [FT10_1, FT10_2, FT10_3, FT10_4, FT10_5, FT10_6, FT10_7, FT10_8, FT10_9], ',', [], 109);
    TSymb.AddChildToken([FT10_1, FT10_2, FT10_3, FT10_4, FT10_5, FT10_7, FT10_8, FT10_9]);
  FT10_5.AddChildToken(OutToken);
  FT10_6.AddChildToken(OutToken);
  FT10_7.AddChildToken(OutToken);
  FT10_8.AddChildToken(OutToken);
  FT10_9.AddChildToken(OutToken);
end;


type
  TTypeDefMode = (tdfDomain, tdfParams, tdfTypeOnly, tdfTableColDef);

// 2 - Type name
// 3 - add type name
// 4 - Type len
// 5 - Type prec
// 6 - constraint name
// 7 - NOT NULL
// 8 - NULL
// 9 - Check
// 10 - PK
// 11 - UNICUE
// 12 - REF SCHEMA.TABLE
// 13 - REF COLLUMN
// 14 - COLLATE
// 15 - REF TABLE
// 16 - REF MATCH FULL
// 17 - REF MATCH PARTIAL
// 18 - REF MATCH SIMPLE
// 19 - REF ON DELETE
// 20 - REF ON UPDATE
// 21 - REF ON .. NO ACTION
// 22 - REF ON .. RESTRICT
// 23 - REF ON .. CASCADE
// 24 - REF ON .. SET NULL
// 25 - REF ON .. SET DEFAULT
// 26 - Domain type name (after dot)
// 27 - DEFAULT
// 28 - GENERATED
// 29 - ALWAYS
// 30 - BY DEFAULT
// 31 - Array
// 32 - Array dimension

procedure MakeTypeDefTree(ACmd:TSQLCommandAbstract;
  AFirstTokens: array of TSQLTokenRecord;
  AEndTokens : array of TSQLTokenRecord;
  AMode : TTypeDefMode;
  TagBase:integer);
var
  TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10, TD11,
    TD12, TD13, TD13_1, TD14, TD15, TD16, TD17, TD18, TD19,
    TD20, TD21, TD22, TD23, TD24, TD25, TD26, TD27, TD28, TD29,
    TD30, TD31, TD32, TD33, TD34, TD35, TD36, TD37, TD38, TD39,
    TD40, TD41, TD42, TD43, TD44, TD45, TD45_1, TD46, TD46_1,
    TD47, TD48, TSymb, TD49, TSymb1, TConst, TConst1, TNN,
    TNN1, TNULL, TCheck, TCheck1, TPK, TPK1, TUNQ, TRef, TRef1,
    TRef2, TColat, TColat1, TRef1_2, TRef2_1, TRef3, TRef3_1,
    TRef3_2, TRef3_3, TRef4, TRef4_1, TRef4_2, TRef4_3,
    TRef4_4, TRef4_5, TRef4_6, TRef4_7, TDD1, TDD2, TDefault,
    TD50, TD50_1, TD50_2, TD51, TD51_1, TD51_1_1, TD51_2,
    TD51_3, TD51_3_1, TD51_3_11, TD51_3_12, TD51_3_13, TD51_4,
    TD51_4_1, TD51_4_11, TD51_4_12, TD51_5, TD51_5_1, TD51_6,
    TGenerated, TGenerated1, TGenerated2, TGenerated3,
    TD_Array1, TD_Array2{, TDefault1}: TSQLTokenRecord;
  i: Integer;
begin
  if Length(AFirstTokens) = 0 then
    raise Exception.Create('procedure MakeTypeDefTree(AFirstToken, AEndToken:TSQLTokenRecord)');
  TD1:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'BIGINT', [], 2 + TagBase);
  TD2:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'INT8', [], 2 + TagBase);
  TD3:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'BIGSERIAL', [], 2 + TagBase);
  TD4:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'SERIAL8', [], 2 + TagBase);
  TD5:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'VARBIT', [], 2 + TagBase);
  TD6:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'BOOLEAN', [], 2 + TagBase);
  TD7:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'BOOL', [], 2 + TagBase);
  TD8:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'BOX', [], 2 + TagBase);
  TD9:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'BYTEA', [], 2 + TagBase);
  TD10:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'CIDR', [], 2 + TagBase);
  TD11:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'CIRCLE', [], 2 + TagBase);
  TD12:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'DATE', [], 2 + TagBase);
  TD13:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'DOUBLE', [], 2 + TagBase);
    TD13_1:=ACmd.AddSQLTokens(stKeyword, TD13, 'PRECISION', [], 3 + TagBase);
  TD14:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'FLOAT8', [], 2 + TagBase);
  TD15:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'INET', [], 2 + TagBase);
  TD16:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'INTEGER', [], 2 + TagBase);
  TD17:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'INT', [], 2 + TagBase);
  TD18:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'INT4', [], 2 + TagBase);
  TD19:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'JSON', [], 2 + TagBase);
  TD20:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'JSONB', [], 2 + TagBase);
  TD21:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'LINE', [], 2 + TagBase);
  TD22:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'LSEG', [], 2 + TagBase);
  TD23:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'MACADDR', [], 2 + TagBase);
  TD24:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'MONEY', [], 2 + TagBase);
  TD25:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'PATH', [], 2 + TagBase);
  TD26:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'PG_LSN', [], 2 + TagBase);
  TD27:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'POINT', [], 2 + TagBase);
  TD28:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'POLYGON', [], 2 + TagBase);
  TD29:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'REAL', [], 2 + TagBase);
  TD30:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'FLOAT4', [], 2 + TagBase);
  TD31:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'SMALLINT', [], 2 + TagBase);
  TD32:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'INT2', [], 2 + TagBase);
  TD33:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'SMALLSERIAL', [], 2 + TagBase);
  TD34:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'SERIAL2', [], 2 + TagBase);
  TD35:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'SERIAL', [], 2 + TagBase);
  TD36:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'SERIAL4', [], 2 + TagBase);
  TD37:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'TEXT', [], 2 + TagBase);
  TD39:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'TSQUERY', [], 2 + TagBase);
  TD40:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'TSVECTOR', [], 2 + TagBase);
  TD41:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'TXID_SNAPSHOT', [], 2 + TagBase);
  TD42:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'UUID', [], 2 + TagBase);
  TD43:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'XML', [], 2 + TagBase);

  TD38:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'TIMESTAMPTZ', [], 2 + TagBase);
  TD44:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'TIMETZ', [], 2 + TagBase);

  TD50:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'TIMESTAMP', [], 2 + TagBase);
    TD50_1:=ACmd.AddSQLTokens(stKeyword, TD50, 'WITHOUT', [], 3 + TagBase);
    TD50_2:=ACmd.AddSQLTokens(stKeyword, TD50, 'WITH', [], 3 + TagBase);
    TD50_1:=ACmd.AddSQLTokens(stKeyword, [TD50_1, TD50_2], 'TIME', [], 3 + TagBase);
    TD50_1:=ACmd.AddSQLTokens(stKeyword, TD50_1, 'ZONE', [], 3 + TagBase);

  TD45:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'BIT', [], 2 + TagBase);
    TD45_1:=ACmd.AddSQLTokens(stKeyword, TD45, 'VARYING', [], 3 + TagBase);
  TD46:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'CHARACTER', [], 2 + TagBase);
    TD46_1:=ACmd.AddSQLTokens(stKeyword, TD46, 'VARYING', [], 3 + TagBase);
  TD47:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'CHAR', [], 2 + TagBase);
  TD48:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'VARCHAR', [], 2 + TagBase);

  TSymb:=ACmd.AddSQLTokens(stSymbol, [TD45, TD45_1, TD46, TD46_1, TD47, TD48], '(', [toOptional]);
  TSymb:=ACmd.AddSQLTokens(stInteger, TSymb, '', [], 4 + TagBase);
  TSymb:=ACmd.AddSQLTokens(stSymbol, TSymb, ')', []);

  TD49:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'NUMERIC', [], 2 + TagBase);
    TSymb1:=ACmd.AddSQLTokens(stSymbol, TD49, '(', [toOptional]);
    TSymb1:=ACmd.AddSQLTokens(stInteger, TSymb1, '', [], 4 + TagBase);
    TSymb1:=ACmd.AddSQLTokens(stSymbol, TSymb1, ',', []);
    TSymb1:=ACmd.AddSQLTokens(stInteger, TSymb1, '', [], 5 + TagBase);
    TSymb1:=ACmd.AddSQLTokens(stSymbol, TSymb1, ')', []);

  TD51:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'INTERVAL', [], 2 + TagBase);
    TD51_1:=ACmd.AddSQLTokens(stKeyword, TD51, 'YEAR', [], 3 + TagBase);
      TD51_1_1:=ACmd.AddSQLTokens(stKeyword, TD51_1, 'TO', [], 3 + TagBase);
      TD51_1_1:=ACmd.AddSQLTokens(stKeyword, TD51_1_1, 'MONTH', [], 3 + TagBase);
    TD51_2:=ACmd.AddSQLTokens(stKeyword, TD51, 'MONTH', [], 3 + TagBase);
    TD51_3:=ACmd.AddSQLTokens(stKeyword, TD51, 'DAY', [], 3 + TagBase);
      TD51_3_1:=ACmd.AddSQLTokens(stKeyword, TD51_3, 'TO', [], 3 + TagBase);
      TD51_3_11:=ACmd.AddSQLTokens(stKeyword, TD51_3_1, 'HOUR', [], 3 + TagBase);
      TD51_3_12:=ACmd.AddSQLTokens(stKeyword, TD51_3_1, 'MINUTE', [], 3 + TagBase);
      TD51_3_13:=ACmd.AddSQLTokens(stKeyword, TD51_3_1, 'SECOND', [], 3 + TagBase);

    TD51_4:=ACmd.AddSQLTokens(stKeyword, TD51, 'HOUR', [], 3 + TagBase);
      TD51_4_1:=ACmd.AddSQLTokens(stKeyword, TD51_4, 'TO', [], 3 + TagBase);
      TD51_4_11:=ACmd.AddSQLTokens(stKeyword, TD51_4_1, 'MINUTE', [], 3 + TagBase);
      TD51_4_12:=ACmd.AddSQLTokens(stKeyword, TD51_4_1, 'SECOND', [], 3 + TagBase);

    TD51_5:=ACmd.AddSQLTokens(stKeyword, TD51, 'MINUTE', [], 3 + TagBase);
      TD51_5_1:=ACmd.AddSQLTokens(stKeyword, TD51_5, 'TO', [], 3 + TagBase);
      TD51_5_1:=ACmd.AddSQLTokens(stKeyword, TD51_5, 'SECOND', [], 3 + TagBase);
    TD51_6:=ACmd.AddSQLTokens(stKeyword, TD51, 'SECOND', [], 3 + TagBase);

  TD_Array1:=ACmd.AddSQLTokens(stSymbol,
    [TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10, TD11, TD12, TD13_1, TD14, TD15,
     TD16, TD17, TD18, TD19, TD20, TD21, TD22, TD23, TD24, TD25, TD26, TD27, TD28, TD29,
     TD30, TD31, TD32, TD33, TD34, TD35, TD36, TD37, TD39, TD40, TD41, TD42, TD43, TD38,
     TD44, TD50, TD50_1, TD45, TD45_1, TD46, TD46_1, TD47, TD48, TSymb, TD49, TSymb1, TD51], '[', [], 31 + TagBase);
    TD_Array2:=ACmd.AddSQLTokens(stInteger, TD_Array1, '', [], 32 + TagBase);
    TD_Array2:=ACmd.AddSQLTokens(stSymbol, [TD_Array1, TD_Array2], ']', []);
      TD_Array2.AddChildToken([TD_Array1]);

{
  INTERVAL [ ПОЛЯ ] [ (P) ]	 	//ИНТЕРВАЛ ВРЕМЕНИ
  DECIMAL [ (P, S) ]
  TIME [ (P) ] [ WITHOUT TIME ZONE ]
  TIME [ (P) ] WITH TIME ZONE
  TIMESTAMP [ (P) ] [ WITHOUT TIME ZONE ]
  TIMESTAMP [ (P) ] WITH TIME ZONE
 }

  //domain type def

  if AMode in [tdfParams, tdfTableColDef] then
  begin
    TDD1:=ACmd.AddSQLTokens(stIdentificator, AFirstTokens[0], '', [], 2 + TagBase);
      TDD2:=ACmd.AddSQLTokens(stSymbol, TDD1, '.', [], 26 + TagBase);
    TDD2:=ACmd.AddSQLTokens(stIdentificator, TDD2, '', [], 26 + TagBase);
  end;


  for i:=1 to High(AFirstTokens) do
    AFirstTokens[i].CopyChildTokens(AFirstTokens[0]);


  if AMode in [tdfTableColDef, tdfDomain] then
  begin
    TColat:=ACmd.AddSQLTokens(stKeyword, [TD1, TD2, TD3, TD4, TD5, TD6, TD7,
      TD8, TD9, TD10, TD11, TD12, TD13_1, TD14, TD15, TD16, TD17, TD18, TD19,
      TD20, TD21, TD22, TD23, TD24, TD25, TD26, TD27, TD28, TD29, TD30, TD31,
      TD32, TD33, TD34, TD35, TD36, TD37, TD38, TD39, TD40, TD41, TD42, TD43,
      TD44, TD45, TD45_1, TD46, TD46_1, TD47, TD48, TD49, TD50, TD50_1,

      TD51, TD51_1,
      TD51_2, TD51_3, TD51_3_11, TD51_3_12, TD51_3_13,

      TD51_4, TD51_4_11, TD51_4_12,

      TD51_5, TD51_5_1,
      TD51_6,

      TD_Array2, TSymb, TSymb1], 'COLLATE', [toOptional]);
    TColat1:=ACmd.AddSQLTokens(stIdentificator, TColat, '', [], 14 + TagBase);

////    [ COLLATE collation ]

    TConst:=ACmd.AddSQLTokens(stKeyword, [TD1, TD2, TD3, TD4, TD5, TD6, TD7,
      TD8, TD9, TD10, TD11, TD12, TD13_1, TD14, TD15, TD16, TD17, TD18, TD19,
      TD20, TD21, TD22, TD23, TD24, TD25, TD26, TD27, TD28, TD29, TD30, TD31,
      TD32, TD33, TD34, TD35, TD36, TD37, TD38, TD39, TD40, TD41, TD42, TD43,
      TD44, TD45, TD45_1, TD46, TD46_1, TD47, TD48, TD49, TD50, TD50_1,
      TD_Array2, TSymb, TSymb1,
      TColat1], 'CONSTRAINT', [toOptional]);
    TConst1:=ACmd.AddSQLTokens(stIdentificator, TConst, '', [], 6 + TagBase);

    TNN:=ACmd.AddSQLTokens(stKeyword, [TD1, TD2, TD3, TD4, TD5, TD6, TD7,
      TD8, TD9, TD10, TD11, TD12, TD13_1, TD14, TD15, TD16, TD17, TD18, TD19,
      TD20, TD21, TD22, TD23, TD24, TD25, TD26, TD27, TD28, TD29, TD30, TD31,
      TD32, TD33, TD34, TD35, TD36, TD37, TD38, TD39, TD40, TD41, TD42, TD43,
      TD44, TD45, TD45_1, TD46, TD46_1, TD47, TD48, TD49, TD50, TD50_1,

      TD51, TD51_1,
      TD51_2, TD51_3, TD51_3_11, TD51_3_12, TD51_3_13,

      TD51_4, TD51_4_11, TD51_4_12,

      TD51_5, TD51_5_1,
      TD51_6,

      TD_Array2, TSymb, TSymb1,
      TConst1, TColat1], 'NOT', [toOptional]);
      TNN1:=ACmd.AddSQLTokens(stKeyword, TNN, 'NULL', [], 7 + TagBase);
    TNULL:=ACmd.AddSQLTokens(stKeyword, [TD1, TD2, TD3, TD4, TD5, TD6, TD7,
      TD8, TD9, TD10, TD11, TD12, TD13_1, TD14, TD15, TD16, TD17, TD18, TD19,
      TD20, TD21, TD22, TD23, TD24, TD25, TD26, TD27, TD28, TD29, TD30, TD31,
      TD32, TD33, TD34, TD35, TD36, TD37, TD38, TD39, TD40, TD41, TD42, TD43,
      TD44, TD45, TD45_1, TD46, TD46_1, TD47, TD48, TD49, TD50, TD50_1,

      TD51, TD51_1,
      TD51_2, TD51_3, TD51_3_11, TD51_3_12, TD51_3_13,

      TD51_4, TD51_4_11, TD51_4_12,

      TD51_5, TD51_5_1,
      TD51_6,

      TD_Array2, TSymb, TSymb1,
      TConst1, TColat1], 'NULL', [toOptional], 8 + TagBase);

    TCheck:=ACmd.AddSQLTokens(stKeyword, [TD1, TD2, TD3, TD4, TD5, TD6, TD7,
      TD8, TD9, TD10, TD11, TD12, TD13_1, TD14, TD15, TD16, TD17, TD18, TD19,
      TD20, TD21, TD22, TD23, TD24, TD25, TD26, TD27, TD28, TD29, TD30, TD31,
      TD32, TD33, TD34, TD35, TD36, TD37, TD38, TD39, TD40, TD41, TD42, TD43,
      TD44, TD45, TD45_1, TD46, TD46_1, TD47, TD48, TD49, TD50, TD50_1,

      TD51, TD51_1,
      TD51_2, TD51_3, TD51_3_11, TD51_3_12, TD51_3_13,

      TD51_4, TD51_4_11, TD51_4_12,

      TD51_5, TD51_5_1,
      TD51_6,

      TD_Array2, TSymb, TSymb1,
      TConst1, TColat1, TNN1], 'CHECK', [toOptional]);
      TCheck1:=ACmd.AddSQLTokens(stSymbol, TCheck, '(', [], 9 + TagBase);

    TDefault:=ACmd.AddSQLTokens(stKeyword, [TD1, TD2, TD3, TD4, TD5, TD6, TD7,
      TD8, TD9, TD10, TD11, TD12, TD13_1, TD14, TD15, TD16, TD17, TD18, TD19,
      TD20, TD21, TD22, TD23, TD24, TD25, TD26, TD27, TD28, TD29, TD30, TD31,
      TD32, TD33, TD34, TD35, TD36, TD37, TD38, TD39, TD40, TD41, TD42, TD43,
      TD44, TD45, TD45_1, TD46, TD46_1, TD47, TD48, TD49, TD50, TD50_1,

      TD51, TD51_1,
      TD51_2, TD51_3, TD51_3_11, TD51_3_12, TD51_3_13,

      TD51_4, TD51_4_11, TD51_4_12,

      TD51_5, TD51_5_1,
      TD51_6,

      TD_Array2, TSymb, TSymb1,
      TConst1, TColat1, TCheck1, TNN1], 'DEFAULT', [toOptional], 27 + TagBase);
      //TDefault1:=ACmd.AddSQLTokens(stString, TDefault, '', [], 33 + TagBase);

//    TColat1.AddChildToken([TNN, TNULL,
    TNN1.AddChildToken([TColat]);
    TNULL.AddChildToken([TColat]);
    TCheck1.AddChildToken([TColat]);
    TDefault.AddChildToken([TColat, TNN, TNULL, TCheck]);

    if AMode = tdfTableColDef then
    begin
      TPK:=ACmd.AddSQLTokens(stKeyword, [TD1, TD2, TD3, TD4, TD5, TD6, TD7,
        TD8, TD9, TD10, TD11, TD12, TD13_1, TD14, TD15, TD16, TD17, TD18, TD19,
        TD20, TD21, TD22, TD23, TD24, TD25, TD26, TD27, TD28, TD29, TD30, TD31,
        TD32, TD33, TD34, TD35, TD36, TD37, TD38, TD39, TD40, TD41, TD42, TD43,
        TD44, TD45, TD45_1, TD46, TD46_1, TD47, TD48, TD49, TD50, TD50_1,

        TD51, TD51_1,
        TD51_2, TD51_3, TD51_3_11, TD51_3_12, TD51_3_13,

        TD51_4, TD51_4_11, TD51_4_12,

        TD51_5, TD51_5_1,
        TD51_6,

        TD_Array2, TSymb, TSymb1,
        TNN1, TNULL, TCheck1, TDefault,
        TConst1, TColat1, TDD1, TDD2], 'PRIMARY', [toOptional]);
        TPK1:=ACmd.AddSQLTokens(stSymbol, TPK, 'KEY', [], 10 + TagBase);

      TUNQ:=ACmd.AddSQLTokens(stKeyword, [TD1, TD2, TD3, TD4, TD5, TD6, TD7,
        TD8, TD9, TD10, TD11, TD12, TD13_1, TD14, TD15, TD16, TD17, TD18, TD19,
        TD20, TD21, TD22, TD23, TD24, TD25, TD26, TD27, TD28, TD29, TD30, TD31,
        TD32, TD33, TD34, TD35, TD36, TD37, TD38, TD39, TD40, TD41, TD42, TD43,
        TD44, TD45, TD45_1, TD46, TD46_1, TD47, TD48, TD49, TD50, TD50_1,

        TD51, TD51_1,
        TD51_2, TD51_3, TD51_3_11, TD51_3_12, TD51_3_13,

        TD51_4, TD51_4_11, TD51_4_12,

        TD51_5, TD51_5_1,
        TD51_6,

        TD_Array2, TSymb, TSymb1,
        TNN1, TNULL, TCheck1, TDefault,
        TConst1, TColat1, TDD1, TDD2], 'UNIQUE', [toOptional], 11 + TagBase);

      TRef:=ACmd.AddSQLTokens(stKeyword, [TD1, TD2, TD3, TD4, TD5, TD6, TD7,
        TD8, TD9, TD10, TD11, TD12, TD13_1, TD14, TD15, TD16, TD17, TD18, TD19,
        TD20, TD21, TD22, TD23, TD24, TD25, TD26, TD27, TD28, TD29, TD30, TD31,
        TD32, TD33, TD34, TD35, TD36, TD37, TD38, TD39, TD40, TD41, TD42, TD43,
        TD44, TD45, TD45_1, TD46, TD46_1, TD47, TD48, TD49, TD50, TD50_1,

        TD51, TD51_1,
        TD51_2, TD51_3, TD51_3_11, TD51_3_12, TD51_3_13,

        TD51_4, TD51_4_11, TD51_4_12,

        TD51_5, TD51_5_1,
        TD51_6,

        TD_Array2, TSymb, TSymb1,
        TConst1, TColat1, TPK1, TUNQ, TDefault,
        TNN1, TNULL, TCheck1, TDD1, TDD2], 'REFERENCES', [toOptional]);
        TRef1:=ACmd.AddSQLTokens(stIdentificator, TRef, '', [], 12 + TagBase);
        TRef1_2:=ACmd.AddSQLTokens(stSymbol, TRef1, '.', []);
        TRef1_2:=ACmd.AddSQLTokens(stIdentificator, TRef1_2, '', [], 15 + TagBase);
        TRef2:=ACmd.AddSQLTokens(stSymbol, [TRef1, TRef1_2], '(', []);
        TRef2:=ACmd.AddSQLTokens(stIdentificator, TRef2, '', [], 13 + TagBase);
        TRef2_1:=ACmd.AddSQLTokens(stSymbol, TRef2, ',', []);
        TRef2_1.AddChildToken(TRef2);
        TRef2:=ACmd.AddSQLTokens(stSymbol, TRef2, ')', []);

        TRef3:=ACmd.AddSQLTokens(stSymbol, [TRef1, TRef1_2, TRef2], 'MATCH', []);
          TRef3_1:=ACmd.AddSQLTokens(stSymbol, TRef3, 'FULL', [], 16 + TagBase);
          TRef3_2:=ACmd.AddSQLTokens(stSymbol, TRef3, 'PARTIAL', [], 17 + TagBase);
          TRef3_3:=ACmd.AddSQLTokens(stSymbol, TRef3, 'SIMPLE', [], 18 + TagBase);
        TRef4:=ACmd.AddSQLTokens(stSymbol, [TRef1, TRef1_2, TRef2, TRef3_1, TRef3_2, TRef3_3], 'ON', []);
          TRef4_1:=ACmd.AddSQLTokens(stSymbol, TRef4, 'DELETE', [], 19 + TagBase);
          TRef4_2:=ACmd.AddSQLTokens(stSymbol, TRef4, 'UPDATE', [], 20 + TagBase);
          TRef4_3:=ACmd.AddSQLTokens(stSymbol, [TRef4_1, TRef4_2], 'NO', []);
          TRef4_3:=ACmd.AddSQLTokens(stSymbol, TRef4_3, 'ACTION', [], 21 + TagBase);
          TRef4_4:=ACmd.AddSQLTokens(stSymbol, [TRef4_1, TRef4_2], 'RESTRICT', [], 22 + TagBase);
          TRef4_5:=ACmd.AddSQLTokens(stSymbol, [TRef4_1, TRef4_2], 'CASCADE', [], 23 + TagBase);
          TRef4_6:=ACmd.AddSQLTokens(stSymbol, [TRef4_1, TRef4_2], 'SET', []);
          TRef4_7:=ACmd.AddSQLTokens(stSymbol, TRef4_6, 'NULL', [], 24 + TagBase);
          TRef4_6:=ACmd.AddSQLTokens(stSymbol, TRef4_6, 'DEFAULT', [], 25);

  (*
        DEFAULT default_expr |
        REFERENCES reftable [ ( refcolumn ) ]
          [ MATCH FULL | MATCH PARTIAL | MATCH SIMPLE ]
          [ ON DELETE action ] [ ON UPDATE action ] }

      [ DEFERRABLE | NOT DEFERRABLE ] [ INITIALLY DEFERRED | INITIALLY IMMEDIATE ]
  *)
  (*
    TRef3_1.AddChildToken([TSymb2, TSymbEnd]);
    TRef3_2.AddChildToken([TSymb2, TSymbEnd]);
    TRef3_3.AddChildToken([TSymb2, TSymbEnd]);
    TRef4_3.AddChildToken([TSymb2, TSymbEnd, TRef4]);
    TRef4_4.AddChildToken([TSymb2, TSymbEnd, TRef4]);
    TRef4_5.AddChildToken([TSymb2, TSymbEnd, TRef4]);
    TRef4_6.AddChildToken([TSymb2, TSymbEnd, TRef4]);
    TRef4_7.AddChildToken([TSymb2, TSymbEnd, TRef4]);
  *)


    TGenerated:=ACmd.AddSQLTokens(stKeyword, [TD1, TD2, TD3, TD4, TD5, TD6, TD7,
      TD8, TD9, TD10, TD11, TD12, TD13_1, TD14, TD15, TD16, TD17, TD18, TD19,
      TD20, TD21, TD22, TD23, TD24, TD25, TD26, TD27, TD28, TD29, TD30, TD31,
      TD32, TD33, TD34, TD35, TD36, TD37, TD38, TD39, TD40, TD41, TD42, TD43,
      TD44, TD45, TD45_1, TD46, TD46_1, TD47, TD48, TD49, TD50, TD50_1,

      TD51, TD51_1,
      TD51_2, TD51_3, TD51_3_11, TD51_3_12, TD51_3_13,

      TD51_4, TD51_4_11, TD51_4_12,

      TD51_5, TD51_5_1,
      TD51_6,

      TSymb, TSymb1,
      TNN1, TNULL, TCheck1, TDefault, TPK1, TUNQ,
      TConst1, TColat1, TDD1, TDD2], 'GENERATED', [toOptional], 28 + TagBase);
        TGenerated1:=ACmd.AddSQLTokens(stKeyword, TGenerated, 'ALWAYS', [], 29 + TagBase);
        TGenerated2:=ACmd.AddSQLTokens(stKeyword, TGenerated, 'BY', []);
        TGenerated2:=ACmd.AddSQLTokens(stKeyword, TGenerated2, 'DEFAULT', [], 30 + TagBase);
        TGenerated3:=ACmd.AddSQLTokens(stKeyword, [TGenerated1, TGenerated2], 'AS', []);
        TGenerated3:=ACmd.AddSQLTokens(stKeyword, TGenerated3, 'IDENTITY', []);
        //{ ALWAYS | BY DEFAULT } AS IDENTITY [ ( параметры_последовательности ) ]
    end;
  end;
  //Fill next token of command
  TD1.AddChildToken(AEndTokens);
  TD2.AddChildToken(AEndTokens);
  TD3.AddChildToken(AEndTokens);
  TD4.AddChildToken(AEndTokens);
  TD5.AddChildToken(AEndTokens);
  TD6.AddChildToken(AEndTokens);
  TD7.AddChildToken(AEndTokens);
  TD8.AddChildToken(AEndTokens);
  TD9.AddChildToken(AEndTokens);
  TD10.AddChildToken(AEndTokens);
  TD11.AddChildToken(AEndTokens);
  TD12.AddChildToken(AEndTokens);
  TD13_1.AddChildToken(AEndTokens);
  TD14.AddChildToken(AEndTokens);
  TD15.AddChildToken(AEndTokens);
  TD16.AddChildToken(AEndTokens);
  TD17.AddChildToken(AEndTokens);
  TD18.AddChildToken(AEndTokens);
  TD19.AddChildToken(AEndTokens);
  TD20.AddChildToken(AEndTokens);
  TD21.AddChildToken(AEndTokens);
  TD22.AddChildToken(AEndTokens);
  TD23.AddChildToken(AEndTokens);
  TD24.AddChildToken(AEndTokens);
  TD25.AddChildToken(AEndTokens);
  TD26.AddChildToken(AEndTokens);
  TD27.AddChildToken(AEndTokens);
  TD28.AddChildToken(AEndTokens);
  TD29.AddChildToken(AEndTokens);
  TD30.AddChildToken(AEndTokens);
  TD31.AddChildToken(AEndTokens);
  TD32.AddChildToken(AEndTokens);
  TD33.AddChildToken(AEndTokens);
  TD34.AddChildToken(AEndTokens);
  TD35.AddChildToken(AEndTokens);
  TD36.AddChildToken(AEndTokens);
  TD37.AddChildToken(AEndTokens);
  TD38.AddChildToken(AEndTokens);
  TD39.AddChildToken(AEndTokens);
  TD40.AddChildToken(AEndTokens);
  TD41.AddChildToken(AEndTokens);
  TD42.AddChildToken(AEndTokens);
  TD43.AddChildToken(AEndTokens);
  TD44.AddChildToken(AEndTokens);
  TD45.AddChildToken(AEndTokens);
  TD45_1.AddChildToken(AEndTokens);
  TD46.AddChildToken(AEndTokens);
  TD46_1.AddChildToken(AEndTokens);
  TD47.AddChildToken(AEndTokens);
  TD48.AddChildToken(AEndTokens);
  TD49.AddChildToken(AEndTokens);
  TD50.AddChildToken(AEndTokens);
  TD50_1.AddChildToken(AEndTokens);

  TD51.AddChildToken(AEndTokens);
  TD51_1.AddChildToken(AEndTokens);
  TD51_2.AddChildToken(AEndTokens);
  TD51_3.AddChildToken(AEndTokens);
  TD51_3_11.AddChildToken(AEndTokens);
  TD51_3_12.AddChildToken(AEndTokens);
  TD51_3_13.AddChildToken(AEndTokens);
  TD51_4.AddChildToken(AEndTokens);
  TD51_4_11.AddChildToken(AEndTokens);
  TD51_4_12.AddChildToken(AEndTokens);
  TD51_5.AddChildToken(AEndTokens);
  TD51_5_1.AddChildToken(AEndTokens);
  TD51_6.AddChildToken(AEndTokens);

  TSymb.AddChildToken(AEndTokens);
  TSymb1.AddChildToken(AEndTokens);
  TNN1.AddChildToken(AEndTokens);

  if AMode in [tdfTableColDef, tdfDomain] then
  begin
    TNULL.AddChildToken(AEndTokens);
    TCheck1.AddChildToken(AEndTokens);
    TColat1.AddChildToken(AEndTokens);
    TDefault.AddChildToken(AEndTokens);
  end;


  if AMode = tdfTableColDef then
  begin
    TPK1.AddChildToken(AEndTokens);
    TUNQ.AddChildToken(AEndTokens);
    TRef1.AddChildToken(AEndTokens);
    TRef1_2.AddChildToken(AEndTokens);
    TRef2.AddChildToken(AEndTokens);
    TRef3_1.AddChildToken(AEndTokens);
    TRef3_2.AddChildToken(AEndTokens);
    TRef3_3.AddChildToken(AEndTokens);
    TRef4_3.AddChildToken(AEndTokens);
    TRef4_4.AddChildToken(AEndTokens);
    TRef4_5.AddChildToken(AEndTokens);
    TRef4_6.AddChildToken(AEndTokens);
    TRef4_7.AddChildToken(AEndTokens);
    TGenerated3.AddChildToken(AEndTokens);
    TD_Array2.AddChildToken(AEndTokens);
  end;


  if AMode in [tdfParams, tdfTableColDef] then
  begin
    TDD1.AddChildToken(AEndTokens);
    TDD2.AddChildToken(AEndTokens);
    TDD1.AddChildToken([TDefault, TNN, TNULL, TColat, TConst, TCheck]);
    TDD2.AddChildToken([TDefault, TNN, TNULL, TColat, TConst, TCheck]);
  end;
end;

{ TPGSQLRefreshMaterializedView }

procedure TPGSQLRefreshMaterializedView.InitParserTree;
var
  FSQLTokens, T, T1: TSQLTokenRecord;
begin
  (*
  REFRESH MATERIALIZED VIEW [ CONCURRENTLY ] имя
      [ WITH [ NO ] DATA ]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'REFRESH', [toFirstToken]);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'MATERIALIZED', []);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'VIEW', [toFindWordLast]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'CONCURRENTLY', [], 1);
  T:=AddSQLTokens(stIdentificator, [T, FSQLTokens], '', [], 2);
  T:=AddSQLTokens(stKeyword, T, 'WITH', [toOptional], 3);
  T1:=AddSQLTokens(stKeyword, T, 'NO', [], 4);
  T:=AddSQLTokens(stKeyword, [T, T1], 'DATA', []);
end;

procedure TPGSQLRefreshMaterializedView.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Concurrently:=true;
    2:Name:=AWord;
    3:RefreshType:=rmvWithData;
    4:RefreshType:=rmvWithNoData;

  end;
end;

procedure TPGSQLRefreshMaterializedView.MakeSQL;
var
  S: String;
begin
  (*
  REFRESH MATERIALIZED VIEW [ CONCURRENTLY ] имя
      [ WITH [ NO ] DATA ]
  *)
  S:='REFRESH MATERIALIZED VIEW ';
  if Concurrently then
    S:=S + 'CONCURRENTLY ';
  S:=S + Name;
  case RefreshType of
    rmvWithData:S:=S + ' WITH DATA';
    rmvWithNoData:S:=S + ' WITH NO DATA';
  end;
  AddSQLCommand(S);
end;

procedure TPGSQLRefreshMaterializedView.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLRefreshMaterializedView then
  begin
    Concurrently:=TPGSQLRefreshMaterializedView(ASource).Concurrently;
    RefreshType:=TPGSQLRefreshMaterializedView(ASource).RefreshType;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLAlterSystem }

procedure TPGSQLAlterSystem.InitParserTree;
var
  FSQLTokens, T, T1, T2: TSQLTokenRecord;
begin
(*
ALTER SYSTEM SET параметр_конфигурации { TO | = } { значение | 'значение' | DEFAULT }

ALTER SYSTEM RESET параметр_конфигурации
ALTER SYSTEM RESET ALL
*)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken]);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'SYSTEM', [toFindWordLast]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'RESET', [], 1);
    AddSQLTokens(stKeyword, T, 'ALL', [], 1);
    AddSQLTokens(stIdentificator, T, '', [], 1);

  T:=AddSQLTokens(stKeyword, FSQLTokens, 'SET', [], 2);
  T:=AddSQLTokens(stIdentificator, T, '', [], 3);
  T1:=AddSQLTokens(stKeyword, T, 'TO', [], 4);
  T2:=AddSQLTokens(stSymbol, T, '=', [], 5);
    AddSQLTokens(stInteger, [T1, T2], '', [], 6);
    AddSQLTokens(stIdentificator, [T1, T2], '', [], 6);
    AddSQLTokens(stString, [T1, T2], '', [], 6);
    AddSQLTokens(stKeyword, [T1, T2], 'DEFAULT', [], 6);
end;

procedure TPGSQLAlterSystem.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:begin
        AlterSystemType:=svtReset;
        Name:=AWord;
      end;
    3:Name:=AWord;
    4:AlterSystemType:=svtSetTO;
    5:AlterSystemType:=svtSet;
    6:ParamValue:=AWord;
  end;
end;

procedure TPGSQLAlterSystem.MakeSQL;
var
  S: String;
begin
  (*
  ALTER SYSTEM SET параметр_конфигурации { TO | = } { значение | 'значение' | DEFAULT }

  ALTER SYSTEM RESET параметр_конфигурации
  ALTER SYSTEM RESET ALL
  *)
  S:='ALTER SYSTEM';
  if AlterSystemType = svtReset then
    S:=S + ' RESET '+Name
  else
  if AlterSystemType in [svtSet, svtSetTO] then
  begin
    S:=S + ' SET ' + Name;
    if AlterSystemType = svtSet then
      S:=S + ' = '
    else
      S:=S + ' TO ';
    S:=S+ParamValue;
  end;
  AddSQLCommand(S);
end;

procedure TPGSQLAlterSystem.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLAlterSystem then
  begin
    AlterSystemType:=TPGSQLAlterSystem(ASource).AlterSystemType;
    ParamValue:=TPGSQLAlterSystem(ASource).ParamValue;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLCreateTablePartition }

constructor TPGSQLCreateTablePartition.Create;
begin
  inherited Create;
  FParams:=TSQLFields.Create;
end;

destructor TPGSQLCreateTablePartition.Destroy;
begin
  FreeAndNil(FParams);
  inherited Destroy;
end;

procedure TPGSQLCreateTablePartition.Clear;
begin
  Params.Clear;
  FPartitionType:=ptNone;
end;

procedure TPGSQLCreateTablePartition.Assign(ASource: TPGSQLCreateTablePartition
  );
begin
  if not Assigned(ASource) then Exit;
  FParams.Assign(ASource.Params);
  PartitionType:=ASource.PartitionType;
end;

{ TPGSQLImportForeignSchema }

procedure TPGSQLImportForeignSchema.InitParserTree;
var
  FSQLTokens, T, T1, T2, T3, TSymb: TSQLTokenRecord;
begin
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'IMPORT', [toFirstToken]);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'FOREIGN', []);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'SCHEMA', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
    T1:=AddSQLTokens(stIdentificator, T, 'LIMIT', [], 2);
    T1:=AddSQLTokens(stIdentificator, T1, 'TO', []);
    T2:=AddSQLTokens(stIdentificator, T, 'EXCEPT', [], 3);
    T3:=AddSQLTokens(stSymbol, [T1, T2], '(', []);
    T3:=AddSQLTokens(stIdentificator, T3, '', [], 4);
    TSymb:=AddSQLTokens(stSymbol, T3, ',', [], 5);
      TSymb.AddChildToken(T3);
    T3:=AddSQLTokens(stSymbol, T3, ')', []);
  T:=AddSQLTokens(stKeyword, [T, T3], 'FROM', []);
  T:=AddSQLTokens(stKeyword, T, 'SERVER', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 6);
  T:=AddSQLTokens(stKeyword, T, 'INTO', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 7);


  (*
  IMPORT FOREIGN SCHEMA удалённая_схема
      [ { LIMIT TO | EXCEPT } ( имя_таблицы [, ...] ) ]
      FROM SERVER имя_сервера
      INTO локальная_схема
      [ OPTIONS ( параметр 'значение' [, ... ] ) ]
  *)
end;

procedure TPGSQLImportForeignSchema.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    2:Option:=ifsoLimitTo;
    3:Option:=ifsoExcept;
    4:Tables.Add(AWord);
    6:ServerName:=AWord;
    7:SchemaName:=AWord;
  end;
end;

procedure TPGSQLImportForeignSchema.MakeSQL;
var
  S: String;
begin
  S:='IMPORT FOREIGN SCHEMA '+Name;

  if Tables.Count > 0 then
  begin
    //S:=S + ' ';
    if Option = ifsoExcept then
      S:=S + ' EXCEPT'
    else
    if Option = ifsoLimitTo then
      S:=S + ' LIMIT TO'
    ;
    S:=S + ' ('+Tables.AsString+ ')';
  end;
  S:=S + ' FROM SERVER ' + ServerName + ' INTO '+SchemaName;

  (*
  IMPORT FOREIGN SCHEMA удалённая_схема
      [ { LIMIT TO | EXCEPT } ( имя_таблицы [, ...] ) ]
      FROM SERVER имя_сервера
      INTO локальная_схема
      [ OPTIONS ( параметр 'значение' [, ... ] ) ]
  *)
  AddSQLCommand(S);
end;

procedure TPGSQLImportForeignSchema.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLImportForeignSchema then
  begin
    ServerName:=TPGSQLImportForeignSchema(ASource).ServerName;
    Option:=TPGSQLImportForeignSchema(ASource).Option;
  end;
  inherited Assign(ASource);
end;

{ TPGAutoIncObject }

procedure TPGAutoIncObject.Assign(Source: TAutoIncObject);
begin
  if Source is TPGAutoIncObject then
  begin

  end;
  inherited Assign(Source);
end;

procedure TPGAutoIncObject.MakeObjects;
var
  G: TPGSQLCreateSequence;
  T: TPGSQLCreateTrigger;
  F: TSQLParserField;
begin
  if SequenceName <> '' then
  begin
    G:=TPGSQLCreateSequence.Create(OwnerTable.Parent);
    G.Name:=SequenceName;
    OwnerTable.AddChild(G);
  end;

  if (TriggerName <> '') and (TriggerBody<>'') then
  begin
    T:=TPGSQLCreateTrigger.Create(OwnerTable.Parent);
    T.SchemaName:=TPGSQLCreateTable(OwnerTable).SchemaName;
    T.TableName:=TPGSQLCreateTable(OwnerTable).Name;
    T.Name:=TriggerName;
    T.TriggerType:=[ttBefore, ttInsert, ttRow];
    T.Description:=TriggerDesc;

    T.TriggerFunction:=TPGSQLCreateFunction.Create(OwnerTable.Parent);
    T.TriggerFunction.SchemaName:=TPGSQLCreateTable(OwnerTable).SchemaName;
    T.TriggerFunction.Name:='trp_'+OwnerTable.Name + '_bi0';
    T.TriggerFunction.Body:=TriggerBody;
    T.TriggerFunction.Description:=TriggerDesc;
    T.TriggerFunction.Language:='PLPGSQL';

    F:=T.TriggerFunction.Output.AddParam('');
    F.TypeName:='trigger';
    T.ProcName:=T.TriggerFunction.Name;
    T.ProcSchema:=T.TriggerFunction.SchemaName;

    OwnerTable.AddChild(T);
  end;
end;

{ TPGSQLCreateForeignDataWrapper }
{ TODO : Реализовать CREATE FOREIGN DATA WRAPPER }
procedure TPGSQLCreateForeignDataWrapper.InitParserTree;
var
  FSQLTokens, T, TName, TH, TV, TVN, TVN1, TH1, THN, THN1, TV1,
    TOpt, T1, T2: TSQLTokenRecord;
begin
  (*
  CREATE FOREIGN DATA WRAPPER имя
      [ HANDLER функция_обработчик | NO HANDLER ]
      [ VALIDATOR функция_проверки | NO VALIDATOR ]
      [ OPTIONS ( параметр 'значение' [, ... ] ) ]
  *)

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okForeignDataWrapper);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'FOREIGN', []);
  T:=AddSQLTokens(stKeyword, T, 'DATA', []);
  T:=AddSQLTokens(stKeyword, T, 'WRAPPER', [toFindWordLast]);
  TName:=AddSQLTokens(stIdentificator, T, '', [], 1);

  TH:=AddSQLTokens(stKeyword, TName, 'HANDLER', [toOptional]);
    TH1:=AddSQLTokens(stIdentificator, TH, '', [], 2);

  THN:=AddSQLTokens(stKeyword, TName, 'NO', [toOptional]);
    THN1:=AddSQLTokens(stKeyword, THN, 'HANDLER', [], 3);

  TV:=AddSQLTokens(stKeyword, [TName, TH1, THN1], 'VALIDATOR', [toOptional]);
    TV1:=AddSQLTokens(stIdentificator, TV, '', [], 4);

  TVN:=AddSQLTokens(stKeyword, [TName, TH1, THN1], 'NO', [toOptional]);
    TVN1:=AddSQLTokens(stKeyword, TVN, 'VALIDATOR', [], 5);

  TVN1.AddChildToken([TH, THN]);
  TV1.AddChildToken([TH, THN]);

  TOpt:=AddSQLTokens(stKeyword, [TName, TH1, THN1, TV1, TVN1], 'OPTIONS', [toOptional]);
    T:=AddSQLTokens(stSymbol, TOpt, '(', []);
     T1:=AddSQLTokens(stIdentificator, T, '', [], 10);
     T2:=AddSQLTokens(stString, T1, '', [], 11);
     T:=AddSQLTokens(stSymbol, T2, ',', [], 12);
       T.AddChildToken(T1);
    T:=AddSQLTokens(stSymbol, T2, ')', [], 12);

  T.AddChildToken([TH, THN, TV, TVN]);
end;

procedure TPGSQLCreateForeignDataWrapper.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    2:FHandler:=AWord;
    3:FNoHandler:=true;
    4:FValidator:=AWord;
    5:FNoValidator:=true;
    10:FCurParam:=Params.AddParam(AWord);
    11:if Assigned(FCurParam) then
      FCurParam.ParamValue:=AWord;
    12:FCurParam:=nil;
  end;
end;

procedure TPGSQLCreateForeignDataWrapper.MakeSQL;
var
  S, S1: String;
  P: TSQLParserField;
begin
  S:='CREATE FOREIGN DATA WRAPPER ' +Name;

  if NoHandler then
    S:=S + ' NO HANDLER'
  else
  if FHandler <> '' then
    S:=S + ' HANDLER ' + FHandler;

  if FNoValidator then
    S:=S + ' NO VALIDATOR'
  else
  if FValidator <> '' then
    S:=S + ' VALIDATOR ' + FValidator;

  S1:='';

  for P in Params do
  begin
    if S1<>'' then S1:=S1 + ',' + LineEnding;
    S1:=S1 + '  ' + P.Caption + ' ' + P.ParamValue;
  end;

  if S1<>'' then
    S:=S + LineEnding + 'OPTIONS ('+LineEnding + S1 + LineEnding + ')';

  AddSQLCommand(S);
end;

procedure TPGSQLCreateForeignDataWrapper.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLCreateForeignDataWrapper then
  begin
    Handler:=TPGSQLCreateForeignDataWrapper(ASource).Handler;
    Validator:=TPGSQLCreateForeignDataWrapper(ASource).Validator;
    NoHandler:=TPGSQLCreateForeignDataWrapper(ASource).NoHandler;
    NoValidator:=TPGSQLCreateForeignDataWrapper(ASource).NoValidator;

  end;
  inherited Assign(ASource);
end;

{ TPGSQLAlterForeignDataWrapper }

{ TODO : Реализовать ALTER FOREIGN DATA WRAPPER }
procedure TPGSQLAlterForeignDataWrapper.InitParserTree;
begin
  (*
  ALTER FOREIGN DATA WRAPPER имя
      [ HANDLER функция_обработчик | NO HANDLER ]
      [ VALIDATOR функция_проверки | NO VALIDATOR ]
      [ OPTIONS ( [ ADD | SET | DROP ] параметр ['значение'] [, ... ]) ]
  ALTER FOREIGN DATA WRAPPER имя OWNER TO { новый_владелец | CURRENT_USER | SESSION_USER }
  ALTER FOREIGN DATA WRAPPER имя RENAME TO новое_имя
  *)
end;

procedure TPGSQLAlterForeignDataWrapper.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TPGSQLAlterForeignDataWrapper.MakeSQL;
begin
  inherited MakeSQL;
end;

{ TPGSQLDropForeignDataWrapper }
{ TODO : РЕализовать DROP FOREIGN DATA WRAPPER }
procedure TPGSQLDropForeignDataWrapper.InitParserTree;
var
  FSQLTokens, T, T1: TSQLTokenRecord;
begin
  (*
  DROP FOREIGN DATA WRAPPER [ IF EXISTS ] имя [ CASCADE | RESTRICT ]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okForeignDataWrapper);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'FOREIGN', []);
  T:=AddSQLTokens(stKeyword, T, 'DATA', []);
  T:=AddSQLTokens(stKeyword, T, 'WRAPPER', [toFindWordLast]);

  T1:=AddSQLTokens(stKeyword, T, 'IF', []);
  T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', [], -1);

  T:=AddSQLTokens(stIdentificator, [T, T1], '', [], 2);

  AddSQLTokens(stKeyword, T, 'CASCADE', [toOptional], -2);
  AddSQLTokens(stKeyword, T, 'RESTRICT', [toOptional], -3);
end;

procedure TPGSQLDropForeignDataWrapper.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    2:Name:=AWord;
  end;
end;

procedure TPGSQLDropForeignDataWrapper.MakeSQL;
var
  S: String;
begin
  S:='DROP FOREIGN DATA WRAPPER ';
  if ooIfExists in Options then
    S:=S + 'IF EXISTS ';
  S:=S + Name;

  case DropRule of
    drCascade:S:=S +  ' CASCADE';
    drRestrict:S:=S + ' RESTRICT';
  end;

  AddSQLCommand(S);
end;

{ TPGSQLCreateTextSearchTemplate }

procedure TPGSQLCreateTextSearchTemplate.InitParserTree;
var
  FSQLTokens, T, T1, TSymb, T2: TSQLTokenRecord;
begin
  (*
  CREATE TEXT SEARCH TEMPLATE name (
    [ INIT = init_function , ]
    LEXIZE = lexize_function
    )
  *)

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0 , okFTSTemplate);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'TEXT', []);
  T:=AddSQLTokens(stKeyword, T, 'SEARCH', []);
  T:=AddSQLTokens(stKeyword, T, 'TEMPLATE', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
    T1:=AddSQLTokens(stSymbol, T, '.', []);
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 2);
  T:=AddSQLTokens(stSymbol, [T, T1], '(', []);

  TSymb:=AddSQLTokens(stSymbol, nil, ',', [], 5);

  T1:=AddSQLTokens(stKeyword, [T, TSymb], 'INIT', [], 3);
  T1:=AddSQLTokens(stSymbol, T1, '=', []);
  T1:=AddSQLTokens(stIdentificator, T1, '', [], 4);
    T1.AddChildToken(TSymb);

  T2:=AddSQLTokens(stKeyword, [T, TSymb], 'LEXIZE', [], 3);
  T2:=AddSQLTokens(stSymbol, T2, '=', []);
  T2:=AddSQLTokens(stIdentificator, T2, '', [], 4);
    T2.AddChildToken(TSymb);

  T:=AddSQLTokens(stSymbol, [T1, T2], ')', []);
end;

{ TPGSQLCreateTextSearchParser }

procedure TPGSQLCreateTextSearchParser.InitParserTree;
var
  FSQLTokens, T, T1, TSymb, T2, T3, T4, T5: TSQLTokenRecord;
begin
  (*
  CREATE TEXT SEARCH PARSER name (
    START = start_function ,
    GETTOKEN = gettoken_function ,
    END = end_function ,
    LEXTYPES = lextypes_function
    [, HEADLINE = headline_function ]
    )
  *)

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0 , okFTSParser);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'TEXT', []);
  T:=AddSQLTokens(stKeyword, T, 'SEARCH', []);
  T:=AddSQLTokens(stKeyword, T, 'PARSER', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
    T1:=AddSQLTokens(stSymbol, T, '.', []);
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 2);
  T:=AddSQLTokens(stSymbol, [T, T1], '(', []);

  T1:=AddSQLTokens(stKeyword, T, 'START', [], 3);
  T1:=AddSQLTokens(stSymbol, T1, '=', []);
  T1:=AddSQLTokens(stIdentificator, T1, '', [], 4);

  TSymb:=AddSQLTokens(stSymbol, T1, ',', [], 5);
    T2:=AddSQLTokens(stKeyword, TSymb, 'GETTOKEN', [], 3);
    T2:=AddSQLTokens(stSymbol, T2, '=', []);
    T2:=AddSQLTokens(stIdentificator, T2, '', [], 4);

  TSymb:=AddSQLTokens(stSymbol, T2, ',', [], 5);
    T3:=AddSQLTokens(stKeyword, TSymb, 'END', [], 3);
    T3:=AddSQLTokens(stSymbol, T3, '=', []);
    T3:=AddSQLTokens(stIdentificator, T3, '', [], 4);

  TSymb:=AddSQLTokens(stSymbol, T3, ',', [], 5);
    T4:=AddSQLTokens(stKeyword, TSymb, 'LEXTYPES', [], 3);
    T4:=AddSQLTokens(stSymbol, T4, '=', []);
    T4:=AddSQLTokens(stIdentificator, T4, '', [], 4);

  TSymb:=AddSQLTokens(stSymbol, T4, ',', [], 5);
    T5:=AddSQLTokens(stKeyword, TSymb, 'HEADLINE', [], 3);
    T5:=AddSQLTokens(stSymbol, T5, '=', []);
    T5:=AddSQLTokens(stIdentificator, T5, '', [], 4);

  T:=AddSQLTokens(stSymbol, [T4, T5], ')', []);
end;

{ TPGSQLCreateTextSearchDictionary }

procedure TPGSQLCreateTextSearchDictionary.InitParserTree;
var
  FSQLTokens, T, T1, T2, TSymb, T21, T22, T23, T24: TSQLTokenRecord;
begin
  (*
  CREATE TEXT SEARCH DICTIONARY name (
    TEMPLATE = template
    [, option = value [, ... ]]
    )
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0 , okFTSDictionary);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'TEXT', []);
  T:=AddSQLTokens(stKeyword, T, 'SEARCH', []);
  T:=AddSQLTokens(stKeyword, T, 'DICTIONARY', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
    T1:=AddSQLTokens(stSymbol, T, '.', []);
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 2);

  T:=AddSQLTokens(stSymbol, [T, T1], '(', []);

  T1:=AddSQLTokens(stKeyword, T, 'TEMPLATE', [], 3);
  T1:=AddSQLTokens(stSymbol, T1, '=', []);
  T1:=AddSQLTokens(stIdentificator, T1, '', [], 4);

  TSymb:=AddSQLTokens(stSymbol, T1, ',', [], 5);
    T2:=AddSQLTokens(stIdentificator, TSymb, '', [], 3);
    T2:=AddSQLTokens(stSymbol, T2, '=', []);
    T21:=AddSQLTokens(stIdentificator, T2, '', [], 4);
    T22:=AddSQLTokens(stString, T2, '', [], 4);
    T23:=AddSQLTokens(stInteger, T2, '', [], 4);
    T24:=AddSQLTokens(stFloat, T2, '', [], 4);
    T21.AddChildToken(TSymb);
    T22.AddChildToken(TSymb);
    T23.AddChildToken(TSymb);
    T24.AddChildToken(TSymb);

  T:=AddSQLTokens(stSymbol, [T1, T21, T22, T23, T24], ')', []);
end;

{ TPGSQLDropMaterializedView }

procedure TPGSQLDropMaterializedView.InitParserTree;
var
  FSQLTokens, T, FTViewName, T1, TSymb: TSQLTokenRecord;
begin
  //DROP MATERIALIZED VIEW [ IF EXISTS ] имя [, ...] [ CASCADE | RESTRICT ]
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okView);    //DROP MATERIALIZED VIEW
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'MATERIALIZED', []);
  T:=AddSQLTokens(stKeyword, T, 'VIEW', [toFindWordLast]);
  T1:=AddSQLTokens(stKeyword, T, 'IF', []);
  T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', [], -1);
  FTViewName:=AddSQLTokens(stIdentificator, [T, T1], '', [], 2);
    T:=AddSQLTokens(stSymbol, FTViewName, '.', [toOptional]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 3);
  TSymb:=AddSQLTokens(stSymbol, [T, FTViewName], ',', [toOptional], 4);
    TSymb.AddChildToken(FTViewName);

  AddSQLTokens(stKeyword, [T, FTViewName], 'CASCADE', [toOptional], 5);
  AddSQLTokens(stKeyword, [T, FTViewName], 'RESTRICT', [toOptional], 6);
end;

procedure TPGSQLDropMaterializedView.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    2:begin
        FCurTable:=Tables.Add(AWord);
        if Name = '' then
          Name:=AWord;
      end;
    3:if Assigned(FCurTable) then
      begin
        FCurTable.SchemaName:=FCurTable.Name;
        FCurTable.Name:=AWord;
        if SchemaName = '' then
        begin
          SchemaName:=Name;
          Name:=AWord;
        end;
      end;
    4:FCurTable:=nil;
    5:DropRule:=drCascade;
    6:DropRule:=drRestrict;
  end;
end;

procedure TPGSQLDropMaterializedView.MakeSQL;
var
  S: String;
begin
  S:='DROP MATERIALIZED VIEW ';
  if ooIfExists in Options then
    S:=S + 'IF EXISTS ';

  if Tables.Count > 1 then
    S:=S + Tables.AsString
  else
    S:=S + FullName;

  if DropRule = drCascade then
    S:=S + ' CASCADE'
  else
  if DropRule = drRestrict then
    S:=S + ' RESTRICT';

  AddSQLCommand(S);
end;

{ TPGSQLAlterMaterializedView }

procedure TPGSQLAlterMaterializedView.InitParserTree;
begin
  (*
  ALTER MATERIALIZED VIEW [ IF EXISTS ] имя
      действие [, ... ]
  ALTER MATERIALIZED VIEW имя
      DEPENDS ON EXTENSION имя_расширения
  ALTER MATERIALIZED VIEW [ IF EXISTS ] имя
      RENAME [ COLUMN ] имя_столбца TO новое_имя_столбца
  ALTER MATERIALIZED VIEW [ IF EXISTS ] имя
      RENAME TO новое_имя
  ALTER MATERIALIZED VIEW [ IF EXISTS ] имя
      SET SCHEMA новая_схема
  ALTER MATERIALIZED VIEW ALL IN TABLESPACE имя [ OWNED BY имя_роли [, ... ] ]
      SET TABLESPACE новое_табл_пространство [ NOWAIT ]

  Где действие может быть следующим:

      ALTER [ COLUMN ] имя_столбца SET STATISTICS integer
      ALTER [ COLUMN ] имя_столбца SET ( атрибут = значение [, ... ] )
      ALTER [ COLUMN ] имя_столбца RESET ( атрибут [, ... ] )
      ALTER [ COLUMN ] имя_столбца SET STORAGE { PLAIN | EXTERNAL | EXTENDED | MAIN }
      CLUSTER ON имя_индекса
      SET WITHOUT CLUSTER
      SET ( параметр_хранения = значение [, ... ] )
      RESET ( параметр_хранения [, ... ] )
      OWNER TO { новый_владелец | CURRENT_USER | SESSION_USER }
  *)
end;

procedure TPGSQLAlterMaterializedView.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TPGSQLAlterMaterializedView.MakeSQL;
begin
  inherited MakeSQL;
end;

constructor TPGSQLAlterMaterializedView.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
end;

procedure TPGSQLAlterMaterializedView.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLAlterMaterializedView then
  begin
    Action:=TPGSQLAlterMaterializedView(ASource).Action;
    ColumnName:=TPGSQLAlterMaterializedView(ASource).ColumnName;
    DefaultExpression:=TPGSQLAlterMaterializedView(ASource).DefaultExpression;
    DropDefault:=TPGSQLAlterMaterializedView(ASource).DropDefault;
    NewOwner:=TPGSQLAlterMaterializedView(ASource).NewOwner;
    NewName:=TPGSQLAlterMaterializedView(ASource).NewName;
    NewSchema:=TPGSQLAlterMaterializedView(ASource).NewSchema;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLCreateMaterializedView }

procedure TPGSQLCreateMaterializedView.InitParserTree;
var
  FSQLTokens, T, T1, TSymb, T2: TSQLTokenRecord;
begin
(*
  CREATE MATERIALIZED VIEW [ IF NOT EXISTS ] имя_таблицы
    [ (имя_столбца [, ...] ) ]
    [ WITH ( параметр_хранения [= значение] [, ... ] ) ]
    [ TABLESPACE табл_пространство ]
    AS запрос
    [ WITH [ NO ] DATA ]
*)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okView);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'MATERIALIZED', []);
    T:=AddSQLTokens(stKeyword, T, 'VIEW', [toFindWordLast]);
      T1:=AddSQLTokens(stKeyword, T, 'IF', []);
      T1:=AddSQLTokens(stKeyword, T1, 'NOT', []);
      T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', [], 1);

  T2:=AddSQLTokens(stIdentificator, [T, T1], '', [], 3);                //view schema
    T1:=AddSQLTokens(stSymbol, T2, '.', []);
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 4);                 //view name

  T:=AddSQLTokens(stSymbol, [T1, T2], '(', []);
    T:=AddSQLTokens(stIdentificator, T, '', [], 5);           //Column Name
    TSymb:=AddSQLTokens(stSymbol, T, ',', []);
    TSymb.AddChildToken(T);
  T:=AddSQLTokens(stSymbol, T, ')', []);
  T:=AddSQLTokens(stKeyword, [T, T1, T2], 'AS', [], 6);
end;

procedure TPGSQLCreateMaterializedView.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
var
  C: TParserPosition;
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:CreateMode:=cmCreateOrAlter;
    2:Options:=Options + [ooTemporary];
    3:Name:=AWord;
    4:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
    5:Fields.AddParam(AWord);
    6:begin
        C:=ASQLParser.Position;
        SQLSelect:=ASQLParser.GetToCommandDelemiter;
        ASQLParser.Position:=C;
        FSQLCommandSelect:=TSQLCommandSelect.Create(nil);
        FSQLCommandSelect.ParseSQL(ASQLParser);
      end;
  end;
end;

destructor TPGSQLCreateMaterializedView.Destroy;
begin
  if Assigned(FSQLCommandSelect) then
    FreeAndNil(FSQLCommandSelect);
  inherited Destroy;
end;

procedure TPGSQLCreateMaterializedView.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLCreateMaterializedView then
  begin
    SQLCommandSelect.Assign(TPGSQLCreateMaterializedView(ASource).SQLCommandSelect);
  end;
  inherited Assign(ASource);
end;

procedure TPGSQLCreateMaterializedView.MakeSQL;
var
  S: String;
  F: TSQLParserField;
begin
  S:='CREATE MATERIALIZED VIEW ';

  if ooIfNotExists in Options then
    S:=S + 'IF NOT EXISTS ';


  S:=S + LineEnding + '  ' + FullName;

  if Fields.Count > 0 then
    S:=S + '('+LineEnding + Fields.AsList + ')';

  S:=S + LineEnding +  'AS'+LineEnding + SQLSelect;
  AddSQLCommand(S);

  if Description <> '' then
    DescribeObject;

  for F in Fields do
    if F.Description <> '' then
      DescribeObjectEx(okColumn, F.Caption, FullName, F.Description);
end;

constructor TPGSQLCreateMaterializedView.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FObjectKind:=okMaterializedView;
  FSQLCommentOnClass:=TPGSQLCommentOn;
end;

{ TPGSQLDropEventTrigger }

procedure TPGSQLDropEventTrigger.InitParserTree;
var
  FSQLTokens, T: TSQLTokenRecord;
begin
  (*
  DROP EVENT TRIGGER [ IF EXISTS ] имя [ CASCADE | RESTRICT ]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okEventTrigger);
    FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'EVENT', []);
    FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'TRIGGER', [toFindWordLast]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'IF', []);
    T:=AddSQLTokens(stKeyword, T, 'EXISTS', [], -1);
  T:=AddSQLTokens(stIdentificator, [T, FSQLTokens], '', [], 1);
    AddSQLTokens(stKeyword, T, 'CASCADE', [toOptional], -2);
    AddSQLTokens(stKeyword, T, 'RESTRICT', [toOptional], -3);
end;

procedure TPGSQLDropEventTrigger.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
  end;
end;

procedure TPGSQLDropEventTrigger.MakeSQL;
var
  S: String;
begin
  S:='DROP EVENT TRIGGER ';//[ IF EXISTS ] имя [ CASCADE | RESTRICT ]
  if ooIfExists in Options then
    S:=S + 'IF EXISTS ';
  S:=S + Name;
  if DropRule = drCascade then
    S:=S + ' CASCADE'
  else
  if DropRule = drRestrict then
    S:=S + ' RESTRICT';
  AddSQLCommand(S);
end;

{ TPGSQLAlterEventTrigger }

procedure TPGSQLAlterEventTrigger.InitParserTree;
var
  FSQLTokens, TRen, TDis, TEnab, TOwn: TSQLTokenRecord;
begin
  (*
  ALTER EVENT TRIGGER имя DISABLE
  ALTER EVENT TRIGGER имя ENABLE [ REPLICA | ALWAYS ]
  ALTER EVENT TRIGGER имя OWNER TO { новый_владелец | CURRENT_USER | SESSION_USER }
  ALTER EVENT TRIGGER имя RENAME TO новое_имя
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken], 0, okEventTrigger);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'EVENT', []);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'TRIGGER', [toFindWordLast]);
  FSQLTokens:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);

  TRen:=AddSQLTokens(stKeyword, FSQLTokens, 'RENAME', []);
  TRen:=AddSQLTokens(stKeyword, TRen, 'TO', []);
  TRen:=AddSQLTokens(stIdentificator, TRen, '', [], 2);

  TOwn:=AddSQLTokens(stKeyword, FSQLTokens, 'OWNER', []);
  TOwn:=AddSQLTokens(stKeyword, TOwn, 'TO', []);
  TOwn:=AddSQLTokens(stIdentificator, TOwn, '', [], 3);

  TDis:=AddSQLTokens(stKeyword, FSQLTokens, 'DISABLE', [], 4);

  TEnab:=AddSQLTokens(stKeyword, FSQLTokens, 'ENABLE', [], 5);
    AddSQLTokens(stKeyword, TEnab, 'REPLICA', [toOptional], 6);
    AddSQLTokens(stKeyword, TEnab, 'ALWAYS', [toOptional], 7);
end;


procedure TPGSQLAlterEventTrigger.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:Name:=AWord;
    2:NewName:=AWord;
    3:NewOwner:=AWord;
    4:State:=etDisable;
    5:State:=etEnable;
    6:State:=etReplica;
    7:State:=etAlways;
  end;
end;

procedure TPGSQLAlterEventTrigger.MakeSQL;
var
  S: String;
begin
  S:='ALTER EVENT TRIGGER ' + FullName;

  if NewOwner <> '' then
    AddSQLCommand(S + ' OWNER TO '+NewOwner);

  if NewName <> '' then
    AddSQLCommand(S + ' RENAME TO '+NewName);

  case State of
    etDisable:AddSQLCommand(S + ' DISABLE');
    etEnable:AddSQLCommand(S + ' ENABLE');
    etReplica:AddSQLCommand(S + ' ENABLE REPLICA');
    etAlways:AddSQLCommand(S + ' ENABLE ALWAYS');
  end;
end;

procedure TPGSQLAlterEventTrigger.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLAlterEventTrigger then
  begin
    NewName:=TPGSQLAlterEventTrigger(ASource).NewName;
    NewOwner:=TPGSQLAlterEventTrigger(ASource).NewOwner;
    State:=TPGSQLAlterEventTrigger(ASource).State;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLCreateEventTrigger }

procedure TPGSQLCreateEventTrigger.InitParserTree;
var
  FSQLTokens, T2, T, T14, T15: TSQLTokenRecord;
begin
  (*
  CREATE EVENT TRIGGER имя
      ON событие
      [ WHEN переменная_фильтра IN (filter_value [, ... ]) [ AND ... ] ]
      EXECUTE PROCEDURE имя_функции()
  событие:
      ddl_command_start, ddl_command_end, table_rewrite и sql_drop
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken]);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'EVENT', []);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'TRIGGER', [toFindWordLast]);
  FSQLTokens:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'ON', []);
  T2:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 2);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'WHEN', []);
    T:=AddSQLTokens(stIdentificator, T, '', [], 3);

  T2:=AddSQLTokens(stKeyword, [T2, T], 'EXECUTE', []);
  T2:=AddSQLTokens(stKeyword, T2, 'PROCEDURE', []);

  T14:=AddSQLTokens(stIdentificator, T2, '', [], 14);
    T:=AddSQLTokens(stSymbol, T14, '.', []);
  T15:=AddSQLTokens(stIdentificator, T, '', [], 15);
  T:=AddSQLTokens(stSymbol, [T14, T15], '(', []);
  T:=AddSQLTokens(stSymbol, T, ')', []);
//      имя_функции()
end;

procedure TPGSQLCreateEventTrigger.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    2:EventName:=AWord;
//    3:;
    14:ProcName:=AWord;
    15:begin
         ProcSchema:=ProcName;
         ProcName:=AWord;
       end;
  end;
end;

procedure TPGSQLCreateEventTrigger.MakeSQL;
var
  S: String;
  FCmdDrop: TPGSQLDropEventTrigger;
begin
  if Assigned(TriggerFunction) then
    for S in TriggerFunction.SQLText do
      AddSQLCommand(S);

  if CreateMode = cmCreateOrAlter then
  begin
    FCmdDrop:=TPGSQLDropEventTrigger.Create(nil);
    FCmdDrop.Name:=Name;
    AddSQLCommand(FCmdDrop.AsSQL);
    FCmdDrop.Free;
  end;


  if EventName <> '' then
  begin
    S:='CREATE EVENT TRIGGER ' + FullName + ' ON ' + EventName;
    if FTriggerWhen <> '' then
      S:=S + LineEnding + 'WHEN ' + TriggerWhen;

    S:=S + LineEnding + 'EXECUTE PROCEDURE '; //имя_функции()

    if FProcSchema<>'' then
      S:=S + FProcSchema +'.';
    S:=S + FProcName + '(' + ')';

    AddSQLCommand(S);
  end;

  if FTriggerState <> ttsUnknow then
  begin
    S:='ALTER EVENT TRIGGER ' + FullName;
    if FTriggerState = ttsEnabled then
      S:=S + ' ENABLE'
    else
      S:=S + ' DISABLE';
    AddSQLCommand(S);
  end;
end;

constructor TPGSQLCreateEventTrigger.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okEventTrigger;
  FSQLCommentOnClass:=TPGSQLCommentOn;
end;

procedure TPGSQLCreateEventTrigger.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLCreateEventTrigger then
  begin
    EventName:=TPGSQLCreateEventTrigger(ASource).EventName;
    TriggerWhen:=TPGSQLCreateEventTrigger(ASource).TriggerWhen;
    ProcName:=TPGSQLCreateEventTrigger(ASource).ProcName;
    ProcSchema:=TPGSQLCreateEventTrigger(ASource).ProcSchema;
    TriggerState:=TPGSQLCreateEventTrigger(ASource).TriggerState;

    FTriggerFunction.Assign(TPGSQLCreateEventTrigger(ASource).FTriggerFunction);

  end;
  inherited Assign(ASource);
end;

{ TPGSQLCommentOn }

procedure TPGSQLCommentOn.InitParserTree;
var
  FSQLTokens, FT1, FT44, FObjName, FT2, FT3, FT4, FT4_1, FT4_2,
    FT6, FT7, FT12, FT11, FT10, TSymb, {FT10_1, FT10_2, FT10_3,
    FT10_4, FT10_5, FT10_6, }FT46, FT17, FT18, FT19, FT20, FT21,
    FT22, FT23, FT24, FT25, FT29, FT26, FT27, FT28, FT47, FT30,
    FT30_1, FT31, FT32, FT43, FT8, FT9, FT45, F10_1, FT13,
    FT14, FT15, FT16, T, FT3_1, FT3_2, FT48, FT48_1, FT20_1,
    FObjSchema, FSymb: TSQLTokenRecord;
begin
  (*
  COMMENT ON
  {
    ACCESS METHOD имя_объекта |
    AGGREGATE имя_агрегатной_функции ( сигнатура_агр_функции ) |
    CAST (исходный_тип AS целевой_тип) |
    COLLATION имя_объекта |
    COLUMN имя_отношения.имя_столбца |
    CONSTRAINT имя_ограничения ON имя_таблицы |
    CONSTRAINT имя_ограничения ON DOMAIN имя_домена |
    CONVERSION имя_объекта |
    DATABASE имя_объекта |
    DOMAIN имя_объекта |
    EXTENSION имя_объекта |
    EVENT TRIGGER имя_объекта |
    FOREIGN DATA WRAPPER имя_объекта |
    FOREIGN TABLE имя_объекта |
    FUNCTION имя_функции ( [ [ режим_аргумента ] [ имя_аргумента ] тип_аргумента [, ...] ] ) |
    INDEX имя_объекта |
    LARGE OBJECT oid_большого_объекта |
    MATERIALIZED VIEW имя_объекта |
    OPERATOR имя_оператора (тип_слева, тип_справа) |
    OPERATOR CLASS имя_объекта USING метод_индекса |
    OPERATOR FAMILY имя_объекта USING метод_индекса |
    POLICY имя_политики ON имя_таблицы |
    [ PROCEDURAL ] LANGUAGE имя_объекта |
    ROLE имя_объекта |
    RULE имя_правила ON имя_таблицы |
    SCHEMA имя_объекта |
    SEQUENCE имя_объекта |
    SERVER имя_объекта |
    TABLE имя_объекта |
    TABLESPACE имя_объекта |
    TEXT SEARCH CONFIGURATION имя_объекта |
    TEXT SEARCH DICTIONARY имя_объекта |
    TEXT SEARCH PARSER имя_объекта |
    TEXT SEARCH TEMPLATE имя_объекта |
    TRANSFORM FOR имя_типа LANGUAGE имя_языка |
    TRIGGER имя_триггера ON имя_таблицы |
    TYPE имя_объекта |
    VIEW имя_объекта
  } IS 'текст'

  Здесь сигнатура_агр_функции:

  * |
  [ режим_аргумента ] [ имя_аргумента ] тип_аргумента [ , ... ] |
  [ [ режим_аргумента ] [ имя_аргумента ] тип_аргумента [ , ... ] ] ORDER BY [ режим_аргумента ] [ имя_аргумента ] тип_аргумента [ , ... ]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'COMMENT', [toFirstToken]);         // COMMENT ON
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'ON', [toFindWordLast]);

  FT43:=AddSQLTokens(stIdentificator, FSQLTokens, 'ACCESS', []);                     //ACCESS METHOD имя_объекта |
     FT43:=AddSQLTokens(stKeyword, FT43, 'METHOD', [], 43);

  FT1:=AddSQLTokens(stKeyword, FSQLTokens, 'AGGREGATE',  [], 1);               //AGGREGATE имя_агрегатной_функции ( сигнатура_агр_функции ) |
    FT1:=AddSQLTokens(stIdentificator, FT1, '',  [], 30);
    FT1:=AddSQLTokens(stSymbol, FT1, '(',  [], 111);
  FT44:=AddSQLTokens(stKeyword, FSQLTokens, 'CAST',  [], 44);                  //CAST (исходный_тип AS целевой_тип) |
    FT44:=AddSQLTokens(stKeyword, FT44, '(', []);
      T:=AddSQLTokens(stKeyword, FT44, 'TEXT', [], 441);
    FT44:=AddSQLTokens(stIdentificator, FT44, '', [], 441);
    FT44:=AddSQLTokens(stKeyword, [FT44, T], 'AS', []);
    FT44:=AddSQLTokens(stIdentificator, FT44, '', [], 442);
    FT44:=AddSQLTokens(stIdentificator, FT44, ')', []);

  FT2:=AddSQLTokens(stKeyword, FSQLTokens, 'COLLATION',  [], 2);               //COLLATION имя_объекта |
  FT3:=AddSQLTokens(stKeyword, FSQLTokens, 'COLUMN', [], 3);                   //COLUMN имя_отношения.имя_столбца |
    FT3:=AddSQLTokens(stIdentificator, FT3, '', [], 37);
    FT3_1:=AddSQLTokens(stSymbol, FT3, '.', []);
    FT3_1:=AddSQLTokens(stIdentificator, FT3_1, '', [], 371);
    FT3_2:=AddSQLTokens(stSymbol, FT3_1, '.', []);
    FT3_2:=AddSQLTokens(stIdentificator, FT3_2, '', [], 372);

  FT4:=AddSQLTokens(stKeyword, FSQLTokens, 'CONSTRAINT', [], 4);               //CONSTRAINT имя_ограничения ON имя_таблицы |
    FT4:=AddSQLTokens(stIdentificator, FT4, '', [], 30);
    FT4:=AddSQLTokens(stKeyword, FT4, 'ON', []);
    FT4_1:=AddSQLTokens(stIdentificator, FT4, '', [], 36);
    FT4_2:=AddSQLTokens(stKeyword, FT4, 'DOMAIN', []);                         //CONSTRAINT имя_ограничения ON DOMAIN имя_домена |
    FT4_2:=AddSQLTokens(stIdentificator, FT4_2, '', [], 361);

  FT6:=AddSQLTokens(stKeyword, FSQLTokens, 'CONVERSION', [], 6);               //CONVERSION имя_объекта |
  FT7:=AddSQLTokens(stKeyword, FSQLTokens, 'DATABASE', [], 7);                 //DATABASE имя_объекта |
  FT8:=AddSQLTokens(stKeyword, FSQLTokens, 'DOMAIN', [], 8);                   //DOMAIN имя_объекта |
  FT9:=AddSQLTokens(stKeyword, FSQLTokens, 'EXTENSION', [], 9);                //EXTENSION имя_объекта |

  FT45:=AddSQLTokens(stKeyword, FSQLTokens, 'EVENT', [], 45);                  //EVENT TRIGGER имя_объекта |
    FT45:=AddSQLTokens(stKeyword, FT45, 'TRIGGER', []);

  FT12:=AddSQLTokens(stKeyword, FSQLTokens, 'FOREIGN', []);
    FT11:=AddSQLTokens(stKeyword, FT12, 'TABLE', [], 11);                      //FOREIGN TABLE имя_объекта |
    FT12:=AddSQLTokens(stKeyword, FT12, 'DATA', [], 12);                       //FOREIGN DATA WRAPPER имя_объекта |
    FT12:=AddSQLTokens(stKeyword, FT12, 'WRAPPER', []);

  FT10:=AddSQLTokens(stKeyword, FSQLTokens, 'FUNCTION', [], 10);               //FUNCTION имя_функции ( [ [ режим_аргумента ] [ имя_аргумента ] тип_аргумента [, ...] ] ) |
    F10_1:=AddSQLTokens(stIdentificator, FT10, '', [], 30);
    TSymb:=AddSQLTokens(stSymbol, F10_1, '.', []);
    FT10:=AddSQLTokens(stIdentificator, TSymb, '', [], 40);
  TSymb:=AddSQLTokens(stSymbol, [FT10, F10_1], '(', []);
  FT10:=AddSQLTokens(stSymbol, TSymb , ')', [], 110);
  CreateInParamsTree(Self, TSymb, FT10);

  FT13:=AddSQLTokens(stKeyword, FSQLTokens, 'INDEX', [], 13);                  //INDEX имя_объекта |
  FT14:=AddSQLTokens(stKeyword, FSQLTokens, 'LARGE', [], 14);                  //LARGE OBJECT oid_большого_объекта |
    FT14:=AddSQLTokens(stKeyword, FT14, 'OBJECT', []);
    FT14:=AddSQLTokens(stInteger, FT14, '', [], 30);

  FT46:=AddSQLTokens(stKeyword, FSQLTokens, 'MATERIALIZED', [], 46);           //MATERIALIZED VIEW имя_объекта |
    FT46:=AddSQLTokens(stKeyword, FT46, 'VIEW', []);

  FT17:=AddSQLTokens(stKeyword, FSQLTokens, 'OPERATOR', []);
    FT15:=AddSQLTokens(stIdentificator, FT17, '', [], 15);                      //OPERATOR имя_оператора (тип_слева, тип_справа) |
    FT15:=AddSQLTokens(stSymbol, FT15, '(', []);
    FT15:=AddSQLTokens(stIdentificator, FT15, '', [], 151);
    FT15:=AddSQLTokens(stSymbol, FT15, ',', []);
    FT15:=AddSQLTokens(stIdentificator, FT15, '', [], 152);
    FT15:=AddSQLTokens(stSymbol, FT15, ')', []);

    FT16:=AddSQLTokens(stKeyword, FT17, 'CLASS', [], 16);                      //OPERATOR CLASS имя_объекта USING метод_индекса |
    FT16:=AddSQLTokens(stIdentificator, FT16, '', [], 161);
    FT16:=AddSQLTokens(stKeyword, FT16, 'USING', []);
    FT16:=AddSQLTokens(stIdentificator, FT16, '', [], 162);

    FT17:=AddSQLTokens(stKeyword, FT17, 'FAMILY', [], 17);                     //OPERATOR FAMILY имя_объекта USING метод_индекса |
    FT17:=AddSQLTokens(stIdentificator, FT17, '', [], 171);
    FT17:=AddSQLTokens(stKeyword, FT17, 'USING', []);
    FT17:=AddSQLTokens(stIdentificator, FT17, '', [], 172);



  FT18:=AddSQLTokens(stKeyword, FSQLTokens, 'PROCEDURAL', [], 18);             //[ PROCEDURAL ] LANGUAGE имя_объекта |
    FT18:=AddSQLTokens(stKeyword, [FSQLTokens, FT18], 'LANGUAGE', [], 18);
  FT19:=AddSQLTokens(stKeyword, FSQLTokens, 'ROLE', [], 19);                   //ROLE имя_объекта |

  FT20:=AddSQLTokens(stKeyword, FSQLTokens, 'RULE', [], 20);                   //RULE имя_правила ON имя_таблицы |
    FT20:=AddSQLTokens(stIdentificator, FT20, '', [], 30);
    FT20:=AddSQLTokens(stKeyword, FT20, 'ON', []);
    FT20:=AddSQLTokens(stIdentificator, FT20, '', [], 302);
    FT20_1:=AddSQLTokens(stSymbol, FT20, '.', []);
    FT20_1:=AddSQLTokens(stIdentificator, FT20_1, '', [], 303);

  FT21:=AddSQLTokens(stKeyword, FSQLTokens, 'SCHEMA', [], 21);                 //SCHEMA имя_объекта |
  FT22:=AddSQLTokens(stKeyword, FSQLTokens, 'SEQUENCE', [], 22);               //SEQUENCE имя_объекта |
  FT23:=AddSQLTokens(stKeyword, FSQLTokens, 'SERVER', [], 23);                 //SERVER имя_объекта |
  FT24:=AddSQLTokens(stKeyword, FSQLTokens, 'TABLE', [], 24);                  //TABLE имя_объекта |
  FT25:=AddSQLTokens(stKeyword, FSQLTokens, 'TABLESPACE', [], 25);             //TABLESPACE имя_объекта |

  FT29:=AddSQLTokens(stKeyword, FSQLTokens, 'TEXT', []);
    FT29:=AddSQLTokens(stKeyword, FT29, 'SEARCH', []);
    FT26:=AddSQLTokens(stKeyword, FT29, 'CONFIGURATION', [], 26);              //TEXT SEARCH CONFIGURATION object_name |
    FT27:=AddSQLTokens(stKeyword, FT29, 'DICTIONARY', [], 27);                 //TEXT SEARCH DICTIONARY object_name |
    FT28:=AddSQLTokens(stKeyword, FT29, 'PARSER', [], 28);                     //TEXT SEARCH PARSER object_name |
    FT29:=AddSQLTokens(stKeyword, FT29, 'TEMPLATE', [], 29);                   //TEXT SEARCH TEMPLATE object_name |}

  FT47:=AddSQLTokens(stKeyword, FSQLTokens, 'TRANSFORM', [], 47);              //TRANSFORM FOR имя_типа LANGUAGE имя_языка |
    FT47:=AddSQLTokens(stKeyword, FT47, 'FOR', []);
    FT47:=AddSQLTokens(stIdentificator, FT47, '', [], 371);
    FT47:=AddSQLTokens(stKeyword, FT47, 'LANGUAGE', []);
    FT47:=AddSQLTokens(stIdentificator, FT47, '', [], 37);

  FT30:=AddSQLTokens(stKeyword, FSQLTokens, 'TRIGGER', [], 301);  //TRIGGER имя_триггера ON имя_таблицы |
    FT30:=AddSQLTokens(stIdentificator, FT30, '', [], 30);
    FT30:=AddSQLTokens(stKeyword, FT30, 'ON', []);
    FT30:=AddSQLTokens(stIdentificator, FT30, '', [], 302);
    FT30_1:=AddSQLTokens(stSymbol, FT30, '.', []);
    FT30_1:=AddSQLTokens(stIdentificator, FT30_1, '', [], 303);

  FT31:=AddSQLTokens(stKeyword, FSQLTokens, 'TYPE', [], 31); //TYPE имя_объекта |
  FT32:=AddSQLTokens(stKeyword, FSQLTokens, 'VIEW', [], 32); //VIEW имя_объекта

  FT48:=AddSQLTokens(stKeyword, FSQLTokens, 'POLICY', [], 48); //POLICY имя_политики ON имя_таблицы |
    FT48:=AddSQLTokens(stIdentificator, FT48, '', [], 30);
    FT48:=AddSQLTokens(stKeyword, FT48, 'ON', []);
    FT48:=AddSQLTokens(stIdentificator, FT48, '', [], 302);
    FT48_1:=AddSQLTokens(stSymbol, FT48, '.', []);
    FT48_1:=AddSQLTokens(stIdentificator, FT48_1, '', [], 303);



  FObjSchema:=AddSQLTokens(stIdentificator, [FT43, FT2, FT6, FT7, FT8, FT9, FT45, FT11, FT12, FT13, FT46, FT18, FT19,
    FT22, FT24, FT26, FT27, FT28, FT29, FT31, FT32], '', [], 30);                                   //object_name

    FSymb:=AddSQLTokens(stSymbol, FObjSchema, '.', []);
  FObjName:=AddSQLTokens(stIdentificator, [FSymb, FT21, FT23, FT25], '', [], 40);                                   //object_name


  T:=AddSQLTokens(stKeyword, [FObjSchema, FObjName, FT3_2, FT3_1, FT1, FT44, FT4_1, FT4_2, FT10, FT14, FT15, FT16, FT17,
     FT20, FT20_1, FT30, FT30_1, FT47, FT48, FT48_1], 'IS', []);                      //IS
  AddSQLTokens(stString, T, '', [], 100);                       //'text'
  AddSQLTokens(stKeyword, T, 'NULL', [], 50);                 //NULL
end;

procedure TPGSQLCommentOn.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
      1:ObjectKind:=okAggregate;
    111:FAggregateParams:=ASQLParser.GetToBracket(')');
     43:ObjectKind:=okAccessMethod;
     44:ObjectKind:=okCast;
    441:FCurParam:=Params.AddParam(AWord);
    442:if Assigned(FCurParam) then
        FCurParam.TypeName:=AWord;
      2:ObjectKind:=okCollation;
      3:ObjectKind:=okColumn;
     37:TableName:=AWord;
    171,
    161,
    371:Name:=AWord;
    372:begin
          SchemaName:=TableName;
          TableName:=Name;
          Name:=AWord;
        end;
      4:ObjectKind:=okConstraint;
     36:TableName:=AWord;
    361:Params.AddParam(AWord);

      6:ObjectKind:=okConversion;
      7:ObjectKind:=okDatabase;
      8:ObjectKind:=okDomain;
      9:ObjectKind:=okExtension;
     11:ObjectKind:=okForeignTable;
     12:ObjectKind:=okForeignDataWrapper;
{
  FT45:=AddSQLTokens(stKeyword, FSQLTokens, 'EVENT', [], 45);                  //EVENT TRIGGER имя_объекта |
    FT45:=AddSQLTokens(stKeyword, FT45, 'TRIGGER', []);

}
     10:ObjectKind:=okStoredProc;
     40:begin
          SchemaName:=Name;
          Name:=AWord;
        end;
    101,
    102,
    103,
    104:begin
           FCurParam:=Params.AddParam('');
           case AChild.Tag of
             101:FCurParam.InReturn:=spvtInput;
             102:FCurParam.InReturn:=spvtOutput;
             103:FCurParam.InReturn:=spvtInOut;
             104:FCurParam.InReturn:=spvtVariadic;
           end;
         end;
    105:begin
          if not Assigned(FCurParam) then
            FCurParam:=Params.AddParam('');
          FCurParam.TypeName:=AWord;
        end;
    106: if Assigned(FCurParam) then
         begin
           if FCurParam.Caption = '' then
           begin
             FCurParam.Caption:=FCurParam.TypeName;
             FCurParam.TypeName:=AWord;
           end
           else
             FCurParam.TypeName:=FCurParam.TypeName + AWord;
         end;
    107:if Assigned(FCurParam) then FCurParam.TypeName:=FCurParam.TypeName + AWord;
    108:if Assigned(FCurParam) then FCurParam.TypeName:=FCurParam.TypeName + ' ' + AWord;
    109,
    110:FCurParam:=nil;
    13:ObjectKind:=okIndex;
    14:ObjectKind:=okLargeObject;
    46:ObjectKind:=okMaterializedView;
    16:ObjectKind:=okOperatorClass;
    17:ObjectKind:=okOperatorFamily;
    162,
    172:Params.AddParam(AWord);

{
  FT17:=AddSQLTokens(stKeyword, FSQLTokens, 'OPERATOR', []);
    FT15:=AddSQLTokens(stIdentificator, FT17, '', [], 15);                      //OPERATOR имя_оператора (тип_слева, тип_справа) |
    FT15:=AddSQLTokens(stSymbol, FT15, '(', []);
    FT15:=AddSQLTokens(stIdentificator, FT15, '', [], 151);
    FT15:=AddSQLTokens(stSymbol, FT15, ',', []);
    FT15:=AddSQLTokens(stIdentificator, FT15, '', [], 152);
    FT15:=AddSQLTokens(stSymbol, FT15, ')', []);

    FT16:=AddSQLTokens(stKeyword, FT17, 'CLASS', [], 16);                      //OPERATOR CLASS имя_объекта USING метод_индекса |
    FT16:=AddSQLTokens(stIdentificator, FT16, '', [], 161);
    FT16:=AddSQLTokens(stKeyword, FT16, 'USING', []);
    FT16:=AddSQLTokens(stIdentificator, FT16, '', [], 162);
}

    18:ObjectKind:=okLanguage;
    19:ObjectKind:=okRole;
    20:ObjectKind:=okRule;
    21:ObjectKind:=okScheme;
    22:ObjectKind:=okSequence;
    23:ObjectKind:=okServer;
    24:ObjectKind:=okTable;
    25:ObjectKind:=okTableSpace;
    26:ObjectKind:=okFTSConfig;
    27:ObjectKind:=okFTSDictionary;
    28:ObjectKind:=okFTSParser;
    29:ObjectKind:=okFTSTemplate;
    47:ObjectKind:=okTransform;

{
  FT47:=AddSQLTokens(stKeyword, FSQLTokens, 'TRANSFORM', [], 47);              //TRANSFORM FOR имя_типа LANGUAGE имя_языка |
    FT47:=AddSQLTokens(stKeyword, FT47, 'FOR', []);
    FT47:=AddSQLTokens(stIdentificator, FT47, '', [], 471);
    FT47:=AddSQLTokens(stKeyword, FT47, 'LANGUAGE', []);
    FT47:=AddSQLTokens(stIdentificator, FT47, '', [], 472);
}
    31:ObjectKind:=okType;
    32:ObjectKind:=okView;
    48:ObjectKind:=okPolicy;
   301:ObjectKind:=okTrigger;
   302:TableName:=AWord;
   303:begin
         SchemaName:=TableName;
         TableName:=AWord;
       end;
    30:Name:=AWord;
   100:Description:=AnsiDequotedStr(AWord, '''');
    50:IsNull:=true;
  end;
end;

procedure TPGSQLCommentOn.MakeSQL;
var
  S, S1: String;
  F: TSQLParserField;
begin
  S:='COMMENT ON ';
  (*
  COMMENT ON
  {
    EVENT TRIGGER имя_объекта |
    OPERATOR имя_оператора (тип_слева, тип_справа) |
    OPERATOR CLASS имя_объекта USING метод_индекса |
    OPERATOR FAMILY имя_объекта USING метод_индекса |
    RULE имя_правила ON имя_таблицы |
    TEXT SEARCH CONFIGURATION имя_объекта |
    TEXT SEARCH DICTIONARY имя_объекта |
    TEXT SEARCH PARSER имя_объекта |
    TEXT SEARCH TEMPLATE имя_объекта |
    TRANSFORM FOR имя_типа LANGUAGE имя_языка |
    TRIGGER имя_триггера ON имя_таблицы |
  } IS 'текст'
  *)
  case ObjectKind of
    okCast:if Params.Count>0 then S:=S + 'CAST ('+Params[0].Caption+' AS '+Params[0].TypeName + ')';
    okAggregate:S:=S + PGObjectNames[ObjectKind] + ' ' + Name + '(' + AggregateParams + ')';
    okColumn:begin
               S:=S + PGObjectNames[ObjectKind] + ' ';
               if SchemaName <> '' then
                 S:=S + SchemaName + '.';
                S:=S + TableName+'.'+Name;
             end;

    okCheckConstraint,
    okConstraint:if Params.Count > 0 then
                   S:=S + 'CONSTRAINT ' + Name + ' ON DOMAIN ' + Params[0].Caption
                 else
                 if TableName <> '' then
                   S:=S + 'CONSTRAINT ' + Name + ' ON ' + TableName;
    okType, okView, okConversion,
    okExtension, okCollation, okLargeObject,
    okDatabase, okDomain, okIndex,

    okLanguage, okScheme,
    okSequence, okServer, okTable,
    okAccessMethod, okMaterializedView,
    okForeignTable, okForeignDataWrapper,
    okEventTrigger,
    okFTSTemplate, okFTSParser, okFTSDictionary, okFTSConfig,
    okTableSpace:S:=S + PGObjectNames[ObjectKind] + ' ' + FullName;
    okRole,
    okUser,
    okGroup:S:=S + PGObjectNames[okRole] + ' ' + FullName;
    okFunction,
    okStoredProc:begin
                   S:=S + PGObjectNames[ObjectKind] + ' ' + FullName;
                   S1:='';
                   for F in Params do
                   begin
                     if S1<>'' then S1:=S1 + ',' + LineEnding;
                     if PGVarTypeNames[F.InReturn]<>'' then
                       S1:=S1 + '  ' + PGVarTypeNames[F.InReturn];

                     if F.Caption<>'' then
                       S1:=S1+ ' ' + F.Caption;
                     S1:=S1 + ' ' +F.FullTypeName;
                   end;
                   S:=S + '(' + S1 + ')';
                 end;
    okPolicy,
    okTrigger,
    okRule:
      begin
        S:=S + PGObjectNames[ObjectKind] + ' ' + Name + ' ON ';
        if SchemaName <> '' then
          S:=S + SchemaName + '.';
        S:=S + TableName;
      end;
    okTransform:
      begin
        S:=S + PGObjectNames[ObjectKind] + ' FOR ' + NAME + ' LANGUAGE ' + TableName; //TRANSFORM FOR имя_типа LANGUAGE имя_языка |
      end;
    okOperatorClass,
    okOperatorFamily:
        S:=S + PGObjectNames[ObjectKind] + ' ' + Name + ' USING ' + Params.AsString;                     //OPERATOR FAMILY имя_объекта USING метод_индекса |
  end;
  if IsNull then
    S:=S + ' IS NULL'
  else
    S:=S + ' IS ' + QuotedStr(Description);
  AddSQLCommand(S);
end;

procedure TPGSQLCommentOn.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLCommentOn then
  begin
    LObID:=TPGSQLCommentOn(ASource).LObID;
    AggregateParams:=TPGSQLCommentOn(ASource).AggregateParams;
    IsNull:=TPGSQLCommentOn(ASource).IsNull;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLDropTable }

procedure TPGSQLDropTable.InitParserTree;
var
  T, T1, FSQLTokens, TSymb: TSQLTokenRecord;
begin
  (*
  DROP TABLE [ IF EXISTS ] name [, ...] [ CASCADE | RESTRICT ]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okTable);    //DROP TABLE
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'TABLE', [toFindWordLast]);
  T1:=AddSQLTokens(stKeyword, T, 'IF', [], -1);
  T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);
  T:=AddSQLTokens(stIdentificator, [T, T1], '', [], 1);
    T1:=AddSQLTokens(stSymbol, T, '.', [toOptional]);
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 2);
    TSymb:=AddSQLTokens(stSymbol, [T, T1], ',', [toOptional], 3);
      TSymb.AddChildToken(T);
end;

procedure TPGSQLDropTable.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:begin
        Name:=AWord;
        FCurTable:=Tables.Add(AWord);
      end;
    2:begin
        SchemaName:=Name;
        Name:=AWord;
        if Assigned(FCurTable) then
        begin
          FCurTable.SchemaName:=SchemaName;
          FCurTable.Name:=Name;
        end;
      end;
  end;
end;

procedure TPGSQLDropTable.MakeSQL;
var
  S: String;
begin
  S:='DROP TABLE ';
  if ooIfExists in Options then
    S:=S + 'IF EXISTS ';

  if Tables.Count > 1 then
    S:=S + Tables.AsString
  else
    S:=S + FullName;
  AddSQLCommand(S);
end;

{ TPGSQLDropView }

procedure TPGSQLDropView.InitParserTree;
var
  T, T1, FSQLTokens, FTViewName, TSymb: TSQLTokenRecord;
begin
  (*
  DROP VIEW [ IF EXISTS ] name [, ...] [ CASCADE | RESTRICT ]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okView);    //DROP VIEW
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'VIEW', [toFindWordLast]);
  T1:=AddSQLTokens(stKeyword, T, 'IF', []);
  T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', [], -1);
  FTViewName:=AddSQLTokens(stIdentificator, [T, T1], '', [], 2);
    T:=AddSQLTokens(stSymbol, FTViewName, '.', [toOptional]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 3);
  TSymb:=AddSQLTokens(stSymbol, [T, FTViewName], ',', [toOptional], 4);
    TSymb.AddChildToken(FTViewName);

  AddSQLTokens(stKeyword, [T, FTViewName], 'CASCADE', [toOptional], 5);
  AddSQLTokens(stKeyword, [T, FTViewName], 'RESTRICT', [toOptional], 6);
end;

procedure TPGSQLDropView.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    2:begin
        FCurTable:=Tables.Add(AWord);
        if Name = '' then
          Name:=AWord;
      end;
    3:if Assigned(FCurTable) then
      begin
        FCurTable.SchemaName:=FCurTable.Name;
        FCurTable.Name:=AWord;
        if SchemaName = '' then
        begin
          SchemaName:=Name;
          Name:=AWord;
        end;
      end;
    4:FCurTable:=nil;
    5:DropRule:=drCascade;
    6:DropRule:=drRestrict;
  end;
end;

procedure TPGSQLDropView.MakeSQL;
var
  S: String;
begin
  S:='DROP VIEW ';
  if ooIfExists in Options then
    S:=S + 'IF EXISTS ';

  if Tables.Count > 1 then
    S:=S + Tables.AsString
  else
    S:=S + FullName;

  if DropRule = drCascade then
    S:=S + ' CASCADE'
  else
  if DropRule = drRestrict then
    S:=S + ' RESTRICT';

  AddSQLCommand(S);
end;

{ TPGSQLCreateIndex }

procedure TPGSQLCreateIndex.InitParserTree;
var
  T, T1, FSQLTokens, T2, T3, TSchema, TName, TCol, TExp, TSymb: TSQLTokenRecord;
begin
  inherited InitParserTree;
(*
  CREATE [ UNIQUE ] INDEX [ CONCURRENTLY ] [ name ] ON table [ USING method ]
      ( { column | ( expression ) } [ COLLATE collation ] [ opclass ] [ ASC | DESC ] [ NULLS { FIRST | LAST } ] [, ...] )
      [ WITH ( storage_parameter = value [, ... ] ) ]
      [ TABLESPACE tablespace ]
      [ WHERE predicate ]
*)

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okIndex); // CREATE [ UNIQUE ] INDEX
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'UNIQUE', [], 1);      //[ UNIQUE ]
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'INDEX', [toFindWordLast]);                       // INDEX
    T1.AddChildToken(T);
  T1:=AddSQLTokens(stKeyword, T, 'CONCURRENTLY', [], 2);              //CONCURRENTLY
  T2:=AddSQLTokens(stIdentificator, [T, T1], '', [], 3);                  //[ name ]
  T:=AddSQLTokens(stKeyword, [T, T1, T2], 'ON', []);                    //ON

  TSchema:=AddSQLTokens(stIdentificator, T, '', [], 4);            // table
  TName:=AddSQLTokens(stSymbol, TSchema, '.', []);
  TName:=AddSQLTokens(stIdentificator, TName, '', [], 4);              // table

  T1:=AddSQLTokens(stKeyword, [TName, TSchema], 'USING', []);                    //USING
  T1:=AddSQLTokens(stIdentificator, T1, '', [], 6);                // method

  T:=AddSQLTokens(stSymbol, [TSchema, TName, T1], '(', []);

  TCol:=AddSQLTokens(stIdentificator, T, '', [], 7);
  TExp:=AddSQLTokens(stSymbol, T, '(', [], 8);

  //[ COLLATE collation ] [ opclass ] [ ASC | DESC ] [ NULLS { FIRST | LAST } ]
  T3:=AddSQLTokens(stSymbol, [TCol, TExp], ',', []);
    T3.AddChildToken([TCol, TExp]);

  TSymb:=AddSQLTokens(stSymbol, [TCol, TExp], ')', []);
    T1:=AddSQLTokens(stKeyword, TSymb, 'TABLESPACE', [toOptional]);
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 10);

//  [ WHERE predicate ]

end;

procedure TPGSQLCreateIndex.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
var
  S: String;
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Unique:=true;
    2:Concurrently:=true;
    3:Name:=AWord;
    4:begin
        if TableName <>'' then
          SchemaName:=TableName;
        TableName:=AWord;
      end;
    6:FIndexMethod:=AWord;
    7:Fields.AddParam(AWord);
    8:begin
        S:='(' + ASQLParser.GetToBracket(')') + ')';
        Fields.AddParam(S);
      end;
    10:TableSpace:=AWord;
  end;
end;

procedure TPGSQLCreateIndex.MakeSQL;
var
  S: String;
  FDropCmd: TPGSQLDropIndex;
begin
  if CreateMode = cmDropAndCreate then
  begin
    FDropCmd:=TPGSQLDropIndex.Create(NIL);
    FDropCmd.Name:=Name;
    FDropCmd.SchemaName:=SchemaName;
    AddSQLCommand(FDropCmd.AsSQL);
    FDropCmd.Free;
  end;
  {
  CREATE [ UNIQUE ] INDEX [ CONCURRENTLY ] [ name ] ON table [ USING method ]
      ( { column | ( expression ) } [ COLLATE collation ] [ opclass ] [ ASC | DESC ] [ NULLS { FIRST | LAST } ] [, ...] )
      [ WITH ( storage_parameter = value [, ... ] ) ]
      [ TABLESPACE tablespace ]
      [ WHERE predicate ]
  }
  S:='CREATE';
  if Unique then
    S := S + ' UNIQUE';
  S := S + ' INDEX';
  if Concurrently then
    S:=S + ' CONCURRENTLY';

  if Name<>'' then
    S:=S + ' ' + Name;
  S:=S + ' ON ';

  if SchemaName <> '' then
    S:=S + SchemaName + '.';
  S:=S + TableName;

  if FIndexMethod<>'' then
    S:=S + ' USING ' +IndexMethod;

  S:=S + ' (' + Fields.AsString + ')';

  if TableSpace <> '' then
    S:=S + ' TABLESPACE '+TableSpace;
  AddSQLCommand(S);
  if Description <> '' then
    DescribeObject;
end;

constructor TPGSQLCreateIndex.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSQLCommentOnClass:=TPGSQLCommentOn;
end;

procedure TPGSQLCreateIndex.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLCreateIndex then
  begin
    IndexMethod:=TPGSQLCreateIndex(ASource).IndexMethod;
    Concurrently:=TPGSQLCreateIndex(ASource).Concurrently;
    TableSpace:=TPGSQLCreateIndex(ASource).TableSpace;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLCreateView }

procedure TPGSQLCreateView.InitParserTree;
var
  T, T1, T2, FSQLTokens , TSymb, T3: TSQLTokenRecord;
begin
(*
CREATE [ OR REPLACE ] [ TEMP | TEMPORARY ] [ RECURSIVE ] VIEW имя [ ( имя_столбца [, ...] ) ]
    [ WITH ( имя_параметра_представления [= значение_параметра_представления] [, ... ] ) ]
    AS запрос
    [ WITH [ CASCADED | LOCAL ] CHECK OPTION ]
*)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okView);    //CREATE
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'OR', []);                  //OR
    T:=AddSQLTokens(stKeyword, T, 'REPLACE', [], 1);                      //OR REPLACE

    T1:=AddSQLTokens(stKeyword, [FSQLTokens, T], 'TEMP', [], 2);                        //TEMP
    T2:=AddSQLTokens(stKeyword, [FSQLTokens, T], 'TEMPORARY', [], 2);                   //TEMPORARY

    T3:=AddSQLTokens(stKeyword, [FSQLTokens, T, T1, T2], 'RECURSIVE', [], 7);
    T3.AddChildToken([T1, T2]);

  T:=AddSQLTokens(stKeyword, [FSQLTokens, T, T1, T2, T3], 'VIEW', [toFindWordLast]);                           //VIEW


  T1:=AddSQLTokens(stIdentificator, T, '', [], 3);                //view schema
    T:=AddSQLTokens(stSymbol, T1, '.', []);
  T2:=AddSQLTokens(stIdentificator, T, '', [], 4);                 //view name

  T:=AddSQLTokens(stSymbol, [T1, T2], '(', []);
    T:=AddSQLTokens(stIdentificator, T, '', [], 5);           //Column Name
    TSymb:=AddSQLTokens(stSymbol, T, ',', []);
    TSymb.AddChildToken(T);
  T:=AddSQLTokens(stSymbol, T, ')', []);
  T:=AddSQLTokens(stKeyword, [T, T1, T2], 'AS', [], 6);
end;

procedure TPGSQLCreateView.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
var
  F: TSQLParserField;
  C: TParserPosition;
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:CreateMode:=cmCreateOrAlter;
    2:Options:=Options + [ooTemporary];
    3:Name:=AWord;
    4:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
    5:Fields.AddParam(AWord);
    6:begin
        C:=ASQLParser.Position;
        SQLSelect:=ASQLParser.GetToCommandDelemiter;
        ASQLParser.Position:=C;
        FSQLCommandSelect:=TSQLCommandSelect.Create(nil);
        FSQLCommandSelect.ParseSQL(ASQLParser);
      end;
  end;
end;

destructor TPGSQLCreateView.Destroy;
begin
  if Assigned(FSQLCommandSelect) then
    FreeAndNil(FSQLCommandSelect);
  inherited Destroy;
end;

procedure TPGSQLCreateView.MakeSQL;
var
  S, S1: String;
  F: TSQLParserField;
  i: Integer;
begin
  S:='CREATE';
  if CreateMode in [cmCreateOrAlter, cmRecreate] then
    S:=S + ' OR REPLACE';

  if ooTemporary in Options then
    S:=S + ' TEMPORARY';

  if Recursive then
    S:=S + ' RECURSIVE';

  S:=S + ' VIEW ' + FullName;

  if Fields.Count > 0 then
    S:=S + '('+LineEnding + Fields.AsList + ')';
(*
  S1:='';
  for i:=0 to Fields.Count-1 do
  begin
    F:=TSQLParserField(Fields[i]);
    S1:=S1 + '  ' + F.Caption;
    if I<Fields.Count-1 then
      S1:=S1 + ',';
    S1:=S1 + LineEnding;
  end;

  if S1<>'' then
    S:=S + '(' + LineEnding + S1 + ')';
*)
  S:=S + LineEnding +  'AS';
  if (SQLSelect<>'') and (Copy(SQLSelect, 1, Length(LineEnding)) <> LineEnding) then
    S:=S + LineEnding;
  S:=S + SQLSelect;
  AddSQLCommand(S);

  if Description <> '' then
    DescribeObject;

  for F in Fields do
    if F.Description <> '' then
      DescribeObjectEx(okColumn, F.Caption, FullName, F.Description);
end;

constructor TPGSQLCreateView.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSQLCommentOnClass:=TPGSQLCommentOn;
end;

procedure TPGSQLCreateView.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLCreateView then
  begin
    Recursive:=TPGSQLCreateView(ASource).Recursive;
    if Assigned(TPGSQLCreateView(ASource).SQLCommandSelect) then
    begin
      FSQLCommandSelect:=TSQLCommandSelect.Create(nil);
      SQLCommandSelect.Assign(TPGSQLCreateView(ASource).SQLCommandSelect);

    end;
  end;
  inherited Assign(ASource);
end;


{ TPGSQLCommandUpdate }

function TPGSQLCommandUpdate.AllowFieldAlias: boolean;
begin
  Result:=false;
end;

{ TPGPLSQLPerform }

procedure TPGPLSQLPerform.InitParserTree;
begin
  //PERFORM query;
  AddSQLTokens(stKeyword, nil, 'PERFORM', [toFindWordLast, toFirstToken], 1);
end;

procedure TPGPLSQLPerform.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  if AChild.Tag = 1 then
    FSQLQuery:=ASQLParser.GetToCommandDelemiter;
end;

procedure TPGPLSQLPerform.MakeSQL;
var
  Result: String;
begin
  Result:='PERFORM '+FSQLQuery + ';';
  AddSQLCommand(Result);
end;

procedure TPGPLSQLPerform.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGPLSQLPerform then
  begin
    SQLQuery:=TPGPLSQLPerform(ASource).SQLQuery;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLDeclareLocalVarInt }

procedure TPGSQLDeclareLocalVarInt.ParseString(ASqlLine: string);
var
  S, VarName, VarType, VarDesc, VarDefValue: String;
  DefPos, k: Integer;
  P: TSQLParserField;
begin
  FSqlLine:=ASqlLine;
  if FSqlLine = '' then exit;
  FCurPos:=1;
  FStop:=false;

  SkipSpace;
  S:=GetWord;

  if LowerCase(S) <> 'declare' then
  begin
    FCurPos:=1;
    exit;
  end;

  repeat
    VarName:='';
    VarType:='';
    VarDesc:='';
    VarDefValue:='';

    SkipSpace;

    K:=FCurPos;
    VarName:=GetWord;
    if (VarName = '') or (LowerCase(VarName) = 'begin') then
    begin
      FCurPos:=K;
      break;
    end;

    SkipSpace;
    VarType:=GetWordToSymb(';');


    //DefPos:=0;
    DefPos:=Pos(':=',VarType);
    if DefPos = 0 then
      DefPos:=Pos('DEFAULT', UpperCase(VarType));

    if DefPos > 0 then
    begin
      if VarType[DefPos] = ':' then
        VarDefValue:=Trim(Copy(VarType, DefPos + Length(':='), Length(VarType)))
      else
        VarDefValue:=Trim(Copy(VarType, DefPos + Length('DEFAULT')+1, Length(VarType)));
      VarType:=TrimRight(Copy(VarType, 1, DefPos-1));
    end;

    SkipSpace;
    k:=FCurPos;
    S:=GetWordEx;
    if Copy(S, 1, 2) = '--' then
    begin
      VarDesc:=TrimLeft(Copy(S, 3, Length(S))) + GetToEOL;
      SkipSpace;
{      S:=GetWord;
      UnGetWord(S);}
    end
    else
      FCurPos:=k;
//      UnGetWord(S);

    P:=FParams.AddParam(VarName);
    P.TypeName:=VarType;
    P.Description:=VarDesc;
    P.DefaultValue:=VarDefValue;
    P.InReturn:=spvtLocal;

  until LowerCase(S) = 'begin';

  //Result:=S + SqlLine;
end;

procedure TPGSQLDeclareLocalVarInt.ParseDeclare(ASQLParser: TSQLParser);
var
  S, VarName, VarType, VarDesc, VarDefValue: String;
  DefPos, k: Integer;
  P: TSQLParserField;
begin
  if ASQLParser.Eof then exit;
(*
  ASQLParser.SkipSpace;
  S:=ASQLParser.GetNextWord;

  if LowerCase(S) <> 'declare' then
  begin
    ASQLParser.UnGetWord(S);
    exit;
  end;

  repeat
    VarName:='';
    VarType:='';
    VarDesc:='';
    VarDefValue:='';

    ASQLParser.SkipSpace;

    VarName:=ASQLParser.GetNextWord;
    if (VarName = '') or (LowerCase(VarName) = 'begin') then
    begin
      ASQLParser.UnGetWord(VarName);
      break;
    end;

    ASQLParser.SkipSpace;
    VarType:=ASQLParser.GetWordToSymb(';');


    //DefPos:=0;
    DefPos:=Pos(':=',VarType);
    if DefPos = 0 then
      DefPos:=Pos('DEFAULT', UpperCase(VarType));

    if DefPos > 0 then
    begin
      if VarType[DefPos] = ':' then
        VarDefValue:=Trim(Copy(VarType, DefPos + Length(':='), Length(VarType)))
      else
        VarDefValue:=Trim(Copy(VarType, DefPos + Length('DEFAULT')+1, Length(VarType)));
      VarType:=TrimRight(Copy(VarType, 1, DefPos-1));
    end;

    SkipSpace;
    k:=FCurPos;
    S:=GetWordEx;
    if Copy(S, 1, 2) = '--' then
    begin
      VarDesc:=TrimLeft(Copy(S, 3, Length(S))) + GetToEOL;
      SkipSpace;
    end
    else
      FCurPos:=k;
//      UnGetWord(S);

    P:=FParams.AddParam(VarName);
    P.TypeName:=VarType;
    P.Description:=VarDesc;
    P.DefValue:=VarDefValue;
    P.InReturn:=spvtLocal;

  until LowerCase(S) = 'begin';
*)
  //Result:=S + SqlLine;
end;

(*
{ TPGSQLDeclareLocalVar }

procedure TPGSQLDeclareLocalVar.InitParserTree;
var
  FSQLTokens, T1, T2: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать парсер локальных переменных }

   DECLARE
     name [ CONSTANT ] type [ COLLATE collation_name ] [ NOT NULL ] [ { DEFAULT | := } expression ];
     ...

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DECLARE', [toFindWordLast, toFirstToken]);
    T1:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
    T2:=AddSQLTokens(stKeyword, T1, 'CONSTANT', [], 2);
end;

procedure TPGSQLDeclareLocalVar.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

function TPGSQLDeclareLocalVar.AsSQL: string;
begin
  Result:=inherited AsSQL;
end;
*)

{ TPGPLSQLRaise }

procedure TPGPLSQLRaise.InitParserTree;
var
  FSQLTokens, T2, T1, T3, T4: TSQLTokenRecord;
begin
  FExceptionLevel:=elEXCEPTION;
  (*
  RAISE [ level ] 'format' [, expression [, ... ]] [ USING option = expression [, ... ] ];
  RAISE [ level ] condition_name [ USING option = expression [, ... ] ];
  RAISE [ level ] SQLSTATE 'sqlstate' [ USING option = expression [, ... ] ];
  RAISE [ level ] USING option = expression [, ... ];
  RAISE ;

  The level option specifies the error severity. Allowed levels are DEBUG, LOG, INFO, NOTICE, WARNING, and EXCEPTION, with EXCEPTION being the default.
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'RAISE', [toFindWordLast, toFirstToken]);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'DEBUG', [], 1);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'EXCEPTION', [], 2);

{    T5:=AddSQLTokens(stKeyword, FSQLTokens, 'INFO', [], 6);
    T6:=AddSQLTokens(stKeyword, FSQLTokens, 'NOTICE', [], 7);
    T7:=AddSQLTokens(stKeyword, FSQLTokens, 'WARNING', [], 8);
    T8:=AddSQLTokens(stKeyword, FSQLTokens, 'LOG', [], 5);}

    T3:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 3);

  T4:=AddSQLTokens(stString, FSQLTokens, '', [], 4);
    T1.AddChildToken(T4);
    T2.AddChildToken(T4);
    T3.AddChildToken(T4);

end;

procedure TPGPLSQLRaise.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FExceptionLevel:=elDEBUG;
    2:FExceptionLevel:=elEXCEPTION;
    3:begin
        if UpperCase(AWord) = 'LOG' then
          FExceptionLevel:=elLOG
        else
        if UpperCase(AWord) = 'INFO' then
          FExceptionLevel:=elINFO
        else
        if UpperCase(AWord) = 'NOTICE' then
          FExceptionLevel:=elNOTICE
        else
        if UpperCase(AWord) = 'WARNING' then
          FExceptionLevel:=elWARNING
        else
          ;
      end;
    4:FCaptionFormat:=AWord;
  end;
end;

procedure TPGPLSQLRaise.MakeSQL;
var
  Result: String;
begin
  Result:='RAISE ';
  case FExceptionLevel of
    elDEBUG:Result:=Result  + 'DEBUG';
    elLOG:Result:=Result  + 'LOG';
    elINFO:Result:=Result  + 'INFO';
    elNOTICE:Result:=Result  + 'NOTICE';
    elWARNING:Result:=Result  + 'WARNING';
    elEXCEPTION:Result:=Result  + 'EXCEPTION';
  end;

  if FCaptionFormat <> '' then
    Result:=Result + ' ' +FCaptionFormat;
  AddSQLCommand(Result);
end;

procedure TPGPLSQLRaise.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGPLSQLRaise then
  begin
    ExceptionLevel:=TPGPLSQLRaise(ASource).ExceptionLevel;
    CaptionFormat:=TPGPLSQLRaise(ASource).CaptionFormat;

  end;
  inherited Assign(ASource);
end;

{ TPGSQLAlterRole }

procedure TPGSQLAlterRole.InitParserTree;
var
  TRT, FSQLTokens, TUT, TRN, T, T1, T20, T21, T22, T23, T24,
    T25, T26, T27, T28, T29, T30, T31, T32, T33, T34, T34_1,
    T35, T36, T37, T37_1, T38, T38_1, T37_2, TSet, T_IN, TSet1,
    TFrom, TReset, TRN1, TSet2, TSet3: TSQLTokenRecord;
begin
  (*
  ALTER ROLE name [ [ WITH ] option [ ... ] ]

  where option can be:

        SUPERUSER | NOSUPERUSER
      | CREATEDB | NOCREATEDB
      | CREATEROLE | NOCREATEROLE
      | CREATEUSER | NOCREATEUSER
      | INHERIT | NOINHERIT
      | LOGIN | NOLOGIN
      | REPLICATION | NOREPLICATION
      | CONNECTION LIMIT connlimit
      | [ ENCRYPTED | UNENCRYPTED ] PASSWORD 'password'
      | VALID UNTIL 'timestamp'

  ALTER ROLE name RENAME TO new_name

  ALTER ROLE name [ IN DATABASE database_name ] SET configuration_parameter { TO | = } { value | DEFAULT }
  ALTER ROLE name [ IN DATABASE database_name ] SET configuration_parameter FROM CURRENT
  ALTER ROLE name [ IN DATABASE database_name ] RESET configuration_parameter
  ALTER ROLE name [ IN DATABASE database_name ] RESET ALL
  *)

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken]);
    TRT:=AddSQLTokens(stKeyword, FSQLTokens, 'ROLE', [toFindWordLast], 100);
    TUT:=AddSQLTokens(stKeyword, FSQLTokens, 'USER', [toFindWordLast], 101);

  TRN:=AddSQLTokens(stIdentificator, TRT, '', [], 1);
  TRN1:=AddSQLTokens(stKeyword, TRT, 'ALL', [], 1);
    T1:=AddSQLTokens(stKeyword, TRN, 'WITH', [], 10);
    T20:=AddSQLTokens(stKeyword, [TRN, TRN1, T1], 'SUPERUSER', [toOptional], 20);
    T21:=AddSQLTokens(stKeyword, [TRN, TRN1, T1], 'NOSUPERUSER', [toOptional], 21);
    T22:=AddSQLTokens(stKeyword, [TRN, TRN1, T1], 'CREATEDB', [toOptional], 22);
    T23:=AddSQLTokens(stKeyword, [TRN, TRN1, T1], 'NOCREATEDB', [toOptional], 23);
    T24:=AddSQLTokens(stKeyword, [TRN, TRN1, T1], 'CREATEROLE', [toOptional], 24);
    T25:=AddSQLTokens(stKeyword, [TRN, TRN1, T1], 'NOCREATEROLE', [toOptional], 25);
    T26:=AddSQLTokens(stKeyword, [TRN, TRN1, T1], 'CREATEUSER', [toOptional], 26);
    T27:=AddSQLTokens(stKeyword, [TRN, TRN1, T1], 'NOCREATEUSER', [toOptional], 27);
    T28:=AddSQLTokens(stKeyword, [TRN, TRN1, T1], 'INHERIT', [toOptional], 28);
    T29:=AddSQLTokens(stKeyword, [TRN, TRN1, T1], 'NOINHERIT', [toOptional], 29);
    T30:=AddSQLTokens(stKeyword, [TRN, TRN1, T1], 'LOGIN', [toOptional], 30);
    T31:=AddSQLTokens(stKeyword, [TRN, TRN1, T1], 'NOLOGIN', [toOptional], 31);
    T32:=AddSQLTokens(stKeyword, [TRN, TRN1, T1], 'REPLICATION', [toOptional], 32);
    T33:=AddSQLTokens(stKeyword, [TRN, TRN1, T1], 'NOREPLICATION', [toOptional], 33);
    T34:=AddSQLTokens(stKeyword, [TRN, TRN1, T1], 'CONNECTION', [toOptional]);
      T34_1:=AddSQLTokens(stKeyword, T34, 'LIMIT', []);
      T34_1:=AddSQLTokens(stInteger, T34_1, '', [], 34);
    T35:=AddSQLTokens(stKeyword, [TRN, TRN1, T1], 'ENCRYPTED', [toOptional], 35);
    T36:=AddSQLTokens(stKeyword, [TRN, TRN1, T1], 'UNENCRYPTED', [toOptional], 36);
      T37:=AddSQLTokens(stKeyword, [TRN, TRN1, T1, T35, T36], 'PASSWORD', [toOptional]);
      T37_1:=AddSQLTokens(stString, T37, '', [], 37);
      T37_2:=AddSQLTokens(stKeyword, T37, 'NULL', [], 39);
    T38:=AddSQLTokens(stKeyword, [TRN, TRN1, T1], 'VALID', [toOptional]);
      T38_1:=AddSQLTokens(stKeyword, T38, 'UNTIL', []);
      T38_1:=AddSQLTokens(stString, T38_1, '', [], 38);

    T20.AddChildToken([T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31, T32, T33, T34, T35, T36, T37]);
    T21.AddChildToken([T20, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31, T32, T33, T34, T35, T36, T37]);
    T22.AddChildToken([T20, T21, T23, T24, T25, T26, T27, T28, T29, T30, T31, T32, T33, T34, T35, T36, T37]);
    T23.AddChildToken([T20, T21, T22, T24, T25, T26, T27, T28, T29, T30, T31, T32, T33, T34, T35, T36, T37]);
    T24.AddChildToken([T20, T21, T22, T23, T25, T26, T27, T28, T29, T30, T31, T32, T33, T34, T35, T36, T37]);
    T25.AddChildToken([T20, T21, T22, T23, T24, T26, T27, T28, T29, T30, T31, T32, T33, T34, T35, T36, T37]);
    T26.AddChildToken([T20, T21, T22, T23, T24, T25, T27, T28, T29, T30, T31, T32, T33, T34, T35, T36, T37]);
    T27.AddChildToken([T20, T21, T22, T23, T24, T25, T26, T28, T29, T30, T31, T32, T33, T34, T35, T36, T37]);
    T28.AddChildToken([T20, T21, T22, T23, T24, T25, T26, T27, T29, T30, T31, T32, T33, T34, T35, T36, T37]);
    T29.AddChildToken([T20, T21, T22, T23, T24, T25, T26, T27, T28, T30, T31, T32, T33, T34, T35, T36, T37]);
    T30.AddChildToken([T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T31, T32, T33, T34, T35, T36, T37]);
    T31.AddChildToken([T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T32, T33, T34, T35, T36, T37]);
    T32.AddChildToken([T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31, T33, T34, T35, T36, T37]);
    T33.AddChildToken([T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31, T32, T34, T35, T36, T37]);
    T34_1.AddChildToken([T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31, T32, T33, T35, T36, T37]);
    T37_1.AddChildToken([T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31, T32, T33, T34, T38]);
    T37_2.AddChildToken([T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31, T32, T33, T34, T38]);
    T38_1.AddChildToken([T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31, T32, T33, T34, T35, T36, T37]);

  T:=AddSQLTokens(stKeyword, [TRN, TRN1], 'RENAME', [], 2);
  T:=AddSQLTokens(stKeyword, T, 'TO', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 3);


  T_IN:=AddSQLTokens(stKeyword, [TRN, TRN1], 'IN', []);
    T_IN:=AddSQLTokens(stKeyword, T_IN, 'DATABASE', []);
    T_IN:=AddSQLTokens(stIdentificator, T_IN, '', [], 4);

  TSet:=AddSQLTokens(stKeyword, [TRN, TRN1, T_IN], 'SET', []);
    TSet1:=AddSQLTokens(stIdentificator, TSet, '', [], 5);
    //  ALTER ROLE name [ IN DATABASE database_name ] SET configuration_parameter { TO | = } { value | DEFAULT }
    TSet2:=AddSQLTokens(stSymbol, TSet1, '=', [], 8);
    TSet3:=AddSQLTokens(stKeyword, TSet1, 'TO', [], 8);
      AddSQLTokens(stIdentificator, [TSet3, TSet2], '', [], 9);
      AddSQLTokens(stInteger, [TSet3, TSet2], '', [], 9);
      AddSQLTokens(stKeyword, [TSet3, TSet2], 'DEFAULT', [], 9);

  //ALTER ROLE name [ IN DATABASE database_name ] SET configuration_parameter FROM CURRENT
  TFrom:=AddSQLTokens(stKeyword, TSet1, 'FROM', [], 6);
  TFrom:=AddSQLTokens(stKeyword, TFrom, 'CURRENT', []);


  //  ALTER ROLE name [ IN DATABASE database_name ] RESET configuration_parameter
  //  ALTER ROLE name [ IN DATABASE database_name ] RESET ALL
  TReset:=AddSQLTokens(stKeyword, [TRN, TRN1, T_IN], 'RESET', []);
    AddSQLTokens(stKeyword, TReset, 'ALL', [], 7);
    AddSQLTokens(stIdentificator, TReset, '', [], 5);

  TUT.CopyChildTokens(TRT);
end;

procedure TPGSQLAlterRole.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    2:FRoleOperator:=artRename;
    3:FRoleNewName:=AWord;
    4:DataBaseName:=AWord;
    5:FCurParam:=Params.AddParam(AWord);
    6:FRoleOperator:=artSetFromCurrent;
    7:FRoleOperator:=artResetAll;
    8:if Assigned(FCurParam) then
      begin
        FRoleOperator:=artSet;
        FCurParam.CheckExpr:=AWord;
      end;
    9:if Assigned(FCurParam) then
        FCurParam.ParamValue:=AWord;
    10:FIsWith:=true;
    20:FRoleOptions:=FRoleOptions + [puoSuperUser];
    21:FRoleOptions:=FRoleOptions + [puoNoSuperUser];
    22:FRoleOptions:=FRoleOptions + [puoCreateDatabaseObjects];
    23:FRoleOptions:=FRoleOptions + [puoNoCreateDatabaseObjects];
    24:FRoleOptions:=FRoleOptions + [puoCreateRoles];
    25:FRoleOptions:=FRoleOptions + [puoNoCreateRoles];
    26:FRoleOptions:=FRoleOptions + [puoCreateUser];
    27:FRoleOptions:=FRoleOptions + [puoNoCreateUser];
    28:FRoleOptions:=FRoleOptions + [puoInheritedRight];
    29:FRoleOptions:=FRoleOptions + [puoNoInheritedRight];
    30:FRoleOptions:=FRoleOptions + [puoLoginEnabled];
    31:FRoleOptions:=FRoleOptions + [puoNoLoginEnabled];
    32:FRoleOptions:=FRoleOptions + [puoReplication];
    33:FRoleOptions:=FRoleOptions + [puoNoReplication];
    34:ConnectionLimit:=StrToInt(AWord);
    35:FRoleOptions:=FRoleOptions + [puoPasswordEncrypted];
    36:FRoleOptions:=FRoleOptions + [puoPasswordUnencrypted];
    37:Password:=ExtractQuotedString(AWord, '''');
    38:ValidUntil:=ExtractQuotedString(AWord, '''');
    39:FRoleOptions:=FRoleOptions + [puoNullPassword];
    100:ObjectKind:=okRole;
    101:ObjectKind:=okUser;
  end;
end;

constructor TPGSQLAlterRole.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okRole;
  FSQLCommentOnClass:=TPGSQLCommentOn;
end;

procedure TPGSQLAlterRole.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLAlterRole then
  begin
    RoleNewName:=TPGSQLAlterRole(ASource).RoleNewName;
    RoleOperator:=TPGSQLAlterRole(ASource).RoleOperator;

    ConnectionLimit:=TPGSQLAlterRole(ASource).ConnectionLimit;
    RoleOptions:=TPGSQLAlterRole(ASource).RoleOptions;
    Password:=TPGSQLAlterRole(ASource).Password;
    IsWith:=TPGSQLAlterRole(ASource).IsWith;
    ValidUntil:=TPGSQLAlterRole(ASource).ValidUntil;
    DataBaseName:=TPGSQLAlterRole(ASource).DataBaseName;
  end;
  inherited Assign(ASource);
end;

procedure TPGSQLAlterRole.MakeSQL;
var
  S, S1: String;
  RO: TPGUserOption;
begin
  //ALTER ROLE name [ IN DATABASE database_name ] SET configuration_parameter { TO | = } { value | DEFAULT }
  //ALTER ROLE name [ IN DATABASE database_name ] RESET configuration_parameter
  //ALTER ROLE name [ IN DATABASE database_name ] RESET ALL

  S:=Format('ALTER %s %s', [PGObjectNames[ObjectKind], Name]);

  //artSet,
  if FRoleOperator = artRename then
    S:=S + ' RENAME TO ' +FRoleNewName
  else
  if FRoleOperator = artResetAll then
  begin
    if DataBaseName <> '' then
      S:=S + ' IN DATABASE ' +DataBaseName;
    S:=S + ' RESET ALL';
  end
  else
  if (FRoleOperator = artReset) and (Params.Count>0) then
  begin
    if DataBaseName <> '' then
      S:=S + ' IN DATABASE ' +DataBaseName;
    S:=S + ' RESET ' + Params[0].Caption;
  end
  else
  if (FRoleOperator = artSetFromCurrent) and (Params.Count>0) then
  begin
    if DataBaseName <> '' then
      S:=S + ' IN DATABASE ' +DataBaseName;
    S:=S + ' SET ' + Params[0].Caption + ' FROM CURRENT';
  end
  else
  if (FRoleOperator = artSet) and (Params.Count>0) then
  begin
    if DataBaseName <> '' then
      S:=S + ' IN DATABASE ' +DataBaseName;
    S:=S + ' SET ' + Params[0].Caption + ' ' + Params[0].CheckExpr + ' ' + Params[0].ParamValue;
  end
  else
  begin
    if FIsWith then S:=S + ' WITH';

    for RO in RoleOptions do
      if PGUserOptionStr[RO]<>'' then
        S:=S + ' ' + PGUserOptionStr[RO];

    S1:='';
    if puoNullPassword in RoleOptions then
      S1:='NULL'
    else
    if Password <>'' then
      S1:=QuotedString(Password,  '''');

    if S1 <> '' then
    begin
      if puoPasswordEncrypted in FRoleOptions then
        S:=S + ' ENCRYPTED'
      else
      if puoPasswordUnencrypted in FRoleOptions then
        S:=S + ' UNENCRYPTED';
      S:=S + ' PASSWORD ' + S1;
    end;

    if ValidUntil <> '' then
      S:=S + ' VALID UNTIL ' + QuotedString(ValidUntil, '''');
  end;
  AddSQLCommand(S);
end;

{ TPGPLSQLReturn }

procedure TPGPLSQLReturn.InitParserTree;
begin
  { TODO : Необходимо реализовать дерево парсера для RETURN }
  (* RETURN expresion *)
  AddSQLTokens(stKeyword, nil, 'RETURN', [toFindWordLast, toFirstToken], 1);
end;

procedure TPGPLSQLReturn.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TPGPLSQLReturn.MakeSQL;
var
  Result: String;
begin
  Result:='RETURN';
  AddSQLCommand(Result);
end;


{ TPGSQLDropType }

procedure TPGSQLDropType.InitParserTree;
var
  T, T1, FSQLTokens: TSQLTokenRecord;
begin
  (* DROP TYPE [ IF EXISTS ] name [, ...] [ CASCADE | RESTRICT ] *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'TYPE', [toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, T, 'IF', [], -1);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
  T1.AddChildToken(T);
  T1:=AddSQLTokens(stKeyword, T, 'CASCADE', [], -2);
  T1:=AddSQLTokens(stKeyword, T, 'RESTRICT', [], -3);
end;

procedure TPGSQLDropType.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  if AChild.Tag = 1 then
    FTypeName:=AWord;
end;

procedure TPGSQLDropType.MakeSQL;
var
  Result: String;
begin
  Result:='DROP TYPE';
  if ooIfExists in Options then
    Result:=Result + ' IF EXISTS';

  Result:=Result + FTypeName;

  if DropRule = drCascade then
    Result:=Result + ' CASCADE'
  else
  if DropRule = drRestrict then
    Result:=Result + ' RESTRICT';
  AddSQLCommand(Result);
end;

procedure TPGSQLDropType.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLDropType then
  begin
    TypeName:=TPGSQLDropType(ASource).TypeName;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLCreateType }

procedure TPGSQLCreateType.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для CREATE TYPE }
  (*
  CREATE TYPE name AS
      ( [ attribute_name data_type [ COLLATE collation ] [, ... ] ] )

  CREATE TYPE name AS ENUM
      ( [ 'label' [, ... ] ] )

  CREATE TYPE name (
      INPUT = input_function,
      OUTPUT = output_function
      [ , RECEIVE = receive_function ]
      [ , SEND = send_function ]
      [ , TYPMOD_IN = type_modifier_input_function ]
      [ , TYPMOD_OUT = type_modifier_output_function ]
      [ , ANALYZE = analyze_function ]
      [ , INTERNALLENGTH = { internallength | VARIABLE } ]
      [ , PASSEDBYVALUE ]
      [ , ALIGNMENT = alignment ]
      [ , STORAGE = storage ]
      [ , LIKE = like_type ]
      [ , CATEGORY = category ]
      [ , PREFERRED = preferred ]
      [ , DEFAULT = default ]
      [ , ELEMENT = element ]
      [ , DELIMITER = delimiter ]
      [ , COLLATABLE = collatable ]
  )

  CREATE TYPE name
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'TYPE', [toFindWordLast]);
end;

procedure TPGSQLCreateType.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TPGSQLCreateType.MakeSQL;
var
  Result: String;
begin
  Result:='CREATE TYPE';
  AddSQLCommand(Result);
end;

{ TPGSQLAlterType }

procedure TPGSQLAlterType.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для ALTER TYPE }
  (*
  ALTER TYPE name action [, ... ]
  ALTER TYPE name OWNER TO new_owner
  ALTER TYPE name RENAME ATTRIBUTE attribute_name TO new_attribute_name
  ALTER TYPE name RENAME TO new_name [ CASCADE | RESTRICT ]
  ALTER TYPE name SET SCHEMA new_schema
  ALTER TYPE name ADD VALUE new_enum_value [ { BEFORE | AFTER } existing_enum_value ]

  where action is one of:

      ADD ATTRIBUTE attribute_name data_type [ COLLATE collation ] [ CASCADE | RESTRICT ]
      DROP ATTRIBUTE [ IF EXISTS ] attribute_name [ CASCADE | RESTRICT ]
      ALTER ATTRIBUTE attribute_name [ SET DATA ] TYPE data_type [ COLLATE collation ] [ CASCADE | RESTRICT ]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'TYPE', [toFindWordLast]);
end;

procedure TPGSQLAlterType.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TPGSQLAlterType.MakeSQL;
var
  Result: String;
begin
  Result:='ALTER TYPE';
  AddSQLCommand(Result);
end;

{ TPGSQLAlterView }

procedure TPGSQLAlterView.InitParserTree;
var
  T, T1, T2, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Реализовать парсер ALTER VIEW }

  (*
  ALTER VIEW [ IF EXISTS ] имя ALTER [ COLUMN ] имя_столбца SET DEFAULT выражение
  ALTER VIEW [ IF EXISTS ] имя ALTER [ COLUMN ] имя_столбца DROP DEFAULT
  ALTER VIEW [ IF EXISTS ] имя OWNER TO { новый_владелец | CURRENT_USER | SESSION_USER }
  ALTER VIEW [ IF EXISTS ] имя RENAME TO новое_имя
  ALTER VIEW [ IF EXISTS ] имя SET SCHEMA новая_схема
  ALTER VIEW [ IF EXISTS ] имя SET ( имя_параметра_представления [= значение_параметра_представления] [, ... ] )
  ALTER VIEW [ IF EXISTS ] имя RESET ( имя_параметра_представления [, ... ] )
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'VIEW', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);

  T1:=AddSQLTokens(stKeyword, T, 'ALTER', []);
  T2:=AddSQLTokens(stKeyword, T1, 'COLUMN', []);
  T2:=AddSQLTokens(stIdentificator, T2, '', [], 2);
    T1.AddChildToken(T2);
  T1:=AddSQLTokens(stKeyword, T2, 'SET', []);
  T1:=AddSQLTokens(stKeyword, T1, 'DEFAULT', [], 3);

  T1:=AddSQLTokens(stKeyword, T2, 'DROP', []);
  T1:=AddSQLTokens(stKeyword, T1, 'DEFAULT', [], 4);

  T1:=AddSQLTokens(stKeyword, T, 'OWNER', []);
  T1:=AddSQLTokens(stKeyword, T1, 'TO', []);
  T1:=AddSQLTokens(stIdentificator, T1, '', [], 5);

  T1:=AddSQLTokens(stKeyword, T, 'RENAME', []);
  T1:=AddSQLTokens(stKeyword, T1, 'TO', []);
  T1:=AddSQLTokens(stIdentificator, T1, '', [], 6);

  T1:=AddSQLTokens(stKeyword, T, 'SET', []);
  T1:=AddSQLTokens(stKeyword, T1, 'SCHEMA', []);
  T1:=AddSQLTokens(stIdentificator, T1, '', [], 7);
end;

procedure TPGSQLAlterView.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:Name:=AWord;
    2:FColumnName:=AWord;
    3:begin
        Action:=ataAlterColumnSetDefaultExp;
        FDefaultExpression:=ASQLParser.GetToCommandDelemiter; //parse default
      end;
    4:FDropDefault:=true;
    5:begin
        Action:=ataOwnerTo;
        FNewOwner:=AWord;
      end;
    6:begin
        Action:=ataRenameTable;
        FNewName:=AWord;
      end;
    7:begin
        Action:=ataSetSchema;
        FNewSchema:=AWord;
      end;
  end;
end;

procedure TPGSQLAlterView.MakeSQL;
var
  S: String;
begin
  S:='ALTER VIEW ' + FullName;

  case Action of
    ataAlterColumnDropDefault,
    ataAlterColumnSetNotNull,
    ataOwnerTo:S:=S + ' OWNER TO '+FNewOwner;
    ataRenameTable:S:=S + ' RENAME TO '+FNewName;
    ataSetSchema:S:=S + ' SET SCHEMA  '+FNewSchema;
    ataAlterColumnSetDefaultExp:S:=S + ' ALTER COLUMN '+FColumnName+' SET DEFAULT' +FDefaultExpression;
  else
    raise Exception.CreateFmt('Unknow action %s', [AlterTableActionStr[Action]]);
  end;
{
  ataAddColumn,
  ataAlterColumnConstraint,
  ataDropColumn,
  ataDropConstraint,
  ataAlterCol ,
  ataAlterColumnSetDataType,
  ataAlterColumnSetDefaultExp,
  ataAlterColumnDropNotNull,
  ataAlterColumnSetStatistics,
  ataAlterColumnSet,
  ataAlterColumnReset,
  ataAlterColumnSetStorage,
  ataAlterColumnPosition,
  ataRenameColumn,
  ataAlterColumnDescription,
  ataAddTableConstraint,
  ataAddTableConstraintUsingIndex,
  ataValidateConstraint,
  ataDisableTrigger,
  ataEnableTrigger,
  ataEnableReplica,
  ataEnablAalways,
  ataDisableRule,
  ataEnableRule,
  ataEnableReplicaRule,
  ataEnableAlwaysRule,
  ataCluster,
  ataReset,
  ataInherit,
  ataNoInherit,
  ataOfTypeName,
  ataNotOf,
  ataSetTablespace,
  ataAddIndex
}
  AddSQLCommand(S);
end;

constructor TPGSQLAlterView.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSQLCommentOnClass:=TPGSQLCommentOn;
end;

procedure TPGSQLAlterView.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLAlterView then
  begin
    Action:=TPGSQLAlterView(ASource).Action;
    ColumnName:=TPGSQLAlterView(ASource).ColumnName;
    DefaultExpression:=TPGSQLAlterView(ASource).DefaultExpression;
    DropDefault:=TPGSQLAlterView(ASource).DropDefault;
    NewOwner:=TPGSQLAlterView(ASource).NewOwner;
    NewName:=TPGSQLAlterView(ASource).NewName;
    NewSchema:=TPGSQLAlterView(ASource).NewSchema;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLDropTrigger }

procedure TPGSQLDropTrigger.InitParserTree;
var
  T, T1, T2, FSQLTokens: TSQLTokenRecord;
begin
  (* DROP TRIGGER [ IF EXISTS ] name ON table [ CASCADE | RESTRICT ] *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'TRIGGER', [toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, T, 'IF', [], -1);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
  T:=AddSQLTokens(stKeyword, T, 'ON', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 2);
  T2:=AddSQLTokens(stSymbol, T, '.', []);
  T2:=AddSQLTokens(stIdentificator, T2, '', [], 3);

  T1:=AddSQLTokens(stKeyword, T, 'CASCADE', [], -2);
  T2.AddChildToken(T1);
  T1:=AddSQLTokens(stKeyword, T, 'RESTRICT', [], -3);
  T2.AddChildToken(T1);
end;

procedure TPGSQLDropTrigger.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    2:TableName:=AWord;
    3:begin
        SchemaName:=TableName;
        TableName:=AWord;
      end;
  end;
end;

procedure TPGSQLDropTrigger.MakeSQL;
var
  S: String;
begin
  S:='DROP TRIGGER';
  if ooIfExists in Options then
    S:=S +' IF EXISTS';
  S:=S +' ' + Name + ' ON ';
  if SchemaName <> '' then
    S:=S + SchemaName + '.';
  S := S + TableName;

  if DropRule = drCascade then
    S:=S + ' CASCADE'
  else
  if DropRule = drRestrict then
    S:=S + ' RESTRICT';

  AddSQLCommand(S);
end;


{ TPGSQLDropOwned }

procedure TPGSQLDropOwned.InitParserTree;
var
  T, T1, FSQLTokens: TSQLTokenRecord;
begin
  (* DROP OWNED BY name [, ...] [ CASCADE | RESTRICT ] *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'OWNED', [toFindWordLast]);

  T1:=AddSQLTokens(stKeyword, T, 'IF', [], -1);
  T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
  T1:=AddSQLTokens(stKeyword, T, 'CASCADE', [], -2);
  T1:=AddSQLTokens(stKeyword, T, 'RESTRICT', [], -3);
end;

procedure TPGSQLDropOwned.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  if AChild.Tag = 1 then
    FOwnedName:=AWord;
end;

procedure TPGSQLDropOwned.MakeSQL;
var
  Result: String;
begin
  Result:='DROP OWNED BY';

  if ooIfExists in Options then
    Result := Result +' IF EXISTS';

  Result := Result + ' ' + FOwnedName;
  if DropRule = drCascade then
    Result:=Result + ' CASCADE'
  else
  if DropRule = drRestrict then
    Result:=Result + ' RESTRICT';
  AddSQLCommand(Result);
end;

procedure TPGSQLDropOwned.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLDropOwned then
  begin
    OwnedName:=TPGSQLDropOwned(ASource).OwnedName;

  end;
  inherited Assign(ASource);
end;

{ TPGSQLDropServer }

procedure TPGSQLDropServer.InitParserTree;
var
  T, T1, FSQLTokens: TSQLTokenRecord;
begin
  (* DROP SERVER [ IF EXISTS ] server_name [ CASCADE | RESTRICT ] *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'SERVER', [toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, T, 'IF', [], -1);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
  T1.AddChildToken(T);
  T1:=AddSQLTokens(stKeyword, T, 'CASCADE', [], -2);
  T1:=AddSQLTokens(stKeyword, T, 'RESTRICT', [], -3);
end;

procedure TPGSQLDropServer.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  if AChild.Tag = 1 then
    FServerName:=AWord;
end;

procedure TPGSQLDropServer.MakeSQL;
var
  Result: String;
begin
  Result:='DROP SERVER';
  if ooIfExists in Options then
    Result:=Result + ' IF EXISTS';

  Result:=Result + FServerName;

  if DropRule = drCascade then
    Result:=Result + ' CASCADE';
  AddSQLCommand(Result);
end;

procedure TPGSQLDropServer.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLDropServer then
  begin
    ServerName:=TPGSQLDropServer(ASource).ServerName;

  end;
  inherited Assign(ASource);
end;

{ TPGSQLCreateServer }

procedure TPGSQLCreateServer.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для CREATE SERVER }
  (*
  CREATE SERVER server_name [ TYPE 'server_type' ] [ VERSION 'server_version' ]
      FOREIGN DATA WRAPPER fdw_name
      [ OPTIONS ( option 'value' [, ... ] ) ]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'SERVER', [toFindWordLast]);
end;

procedure TPGSQLCreateServer.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TPGSQLCreateServer.MakeSQL;
var
  Result: String;
begin
  Result:='CREATE SERVER';
  AddSQLCommand(Result);
end;

{ TPGSQLAlterServer }

procedure TPGSQLAlterServer.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для ALTER SERVER }
  (*
  ALTER SERVER server_name [ VERSION 'new_version' ]
      [ OPTIONS ( [ ADD | SET | DROP ] option ['value'] [, ... ] ) ]
  ALTER SERVER server_name OWNER TO new_owner
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'SERVER', [toFindWordLast]);
end;

procedure TPGSQLAlterServer.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TPGSQLAlterServer.MakeSQL;
var
  Result: String;
begin
  Result:='ALTER SERVER server_name';
  AddSQLCommand(Result);
end;

{ TPGSQLDropSchema }

procedure TPGSQLDropSchema.InitParserTree;
var
  T, T1, FSQLTokens: TSQLTokenRecord;
begin
  (* DROP SCHEMA [ IF EXISTS ] name [, ...] [ CASCADE | RESTRICT ] *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'SCHEMA', [toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, T, 'IF', [], -1);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
  T1:=AddSQLTokens(stKeyword, T, 'CASCADE', [], -2);
  T1:=AddSQLTokens(stKeyword, T, 'RESTRICT', [], -3);

end;

procedure TPGSQLDropSchema.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  if AChild.Tag = 1 then
    Name:=AWord;
end;

procedure TPGSQLDropSchema.MakeSQL;
var
  S: String;
begin
  S:='DROP SCHEMA ';
  if ooIfExists in Options then
    S:=S + 'IF EXISTS ';
  S:=S + Name;

  if DropRule = drCascade then
    S:=S + ' CASCADE'
  else
  if DropRule = drRestrict then
    S:=S + ' RESTRICT'
  ;

  AddSQLCommand(S);
end;

{ TPGSQLAlterSchema }

procedure TPGSQLAlterSchema.InitParserTree;
var
  T, T1, FSQLTokens: TSQLTokenRecord;
begin
  (* ALTER SCHEMA name RENAME TO new_name *)
  (* ALTER SCHEMA name OWNER TO new_owner *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'SCHEMA', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);

  T1:=AddSQLTokens(stKeyword, T, 'RENAME', [], 2);
  T1:=AddSQLTokens(stKeyword, T1, 'TO', []);
  T1:=AddSQLTokens(stIdentificator, T1, '', [], 3);

  T1:=AddSQLTokens(stKeyword, T, 'OWNER', [], 4);
  T1:=AddSQLTokens(stKeyword, T1, 'TO', []);
  T1:=AddSQLTokens(stIdentificator, T1, '', [], 5);
end;

procedure TPGSQLAlterSchema.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    3:FSchemaNewName:=AWord;
    5:FSchemaNewOwner:=AWord;
  end;
end;

procedure TPGSQLAlterSchema.MakeSQL;
begin
  if (FSchemaNewName <> '') and (FSchemaNewName <> Name) then
    AddSQLCommandEx('ALTER SCHEMA %s RENAME TO %s', [Name, FSchemaNewName]);

  if FSchemaNewOwner <> '' then
    AddSQLCommandEx('ALTER SCHEMA %s OWNER TO %s', [Name, FSchemaNewOwner]);

  if Description <> FOldDescription then
    AddSQLCommandEx('COMMENT ON SCHEMA %s IS %s', [Name, QuotedStr(Description)]);
end;

constructor TPGSQLAlterSchema.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okScheme;
  FSQLCommentOnClass:=TPGSQLCommentOn;
end;

procedure TPGSQLAlterSchema.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLAlterSchema then
  begin
    SchemaNewName:=TPGSQLAlterSchema(ASource).SchemaNewName;
    SchemaNewOwner:=TPGSQLAlterSchema(ASource).SchemaNewOwner;
    OldDescription:=TPGSQLAlterSchema(ASource).OldDescription;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLAlterLargeObject }

procedure TPGSQLAlterLargeObject.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  (* ALTER LARGE OBJECT large_object_oid OWNER TO new_owner *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'LARGE', []);
  T:=AddSQLTokens(stKeyword, T, 'OBJECT', [toFindWordLast]);
  T:=AddSQLTokens(stInteger, T, '', [], 1);
  T:=AddSQLTokens(stKeyword, T, 'OWNER', []);
  T:=AddSQLTokens(stKeyword, T, 'TO', []);
  T:=AddSQLTokens(stIdentificator, T, '', [toFindWordLast], 2);
end;

procedure TPGSQLAlterLargeObject.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FLargeObjectOID:=AWord;
    2:FNewOwner:=AWord;
  end;
end;

procedure TPGSQLAlterLargeObject.MakeSQL;
var
  Result: String;
begin
  Result:='ALTER LARGE OBJECT ' + FLargeObjectOID + ' OWNER TO ' + FNewOwner;
  AddSQLCommand(Result);
end;

procedure TPGSQLAlterLargeObject.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLAlterLargeObject then
  begin
    LargeObjectOID:=TPGSQLAlterLargeObject(ASource).LargeObjectOID;
    NewOwner:=TPGSQLAlterLargeObject(ASource).NewOwner;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLDropLanguage }

procedure TPGSQLDropLanguage.InitParserTree;
var
  T, T1, FSQLTokens: TSQLTokenRecord;
begin
  (* DROP [ PROCEDURAL ] LANGUAGE [ IF EXISTS ] name [ CASCADE | RESTRICT ] *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'PROCEDURAL', []);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'LANGUAGE', [toFindWordLast]);
    T1.AddChildToken(T);

    T1:=AddSQLTokens(stKeyword, T, 'IF', [], -1);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);

  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
  T1.AddChildToken(T);

  T1:=AddSQLTokens(stKeyword, T, 'CASCADE', [], -2);
  T1:=AddSQLTokens(stKeyword, T, 'RESTRICT', [], -3);

end;

procedure TPGSQLDropLanguage.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  if AChild.Tag = 1 then
    FLanguageName:=AWord;
end;

procedure TPGSQLDropLanguage.MakeSQL;
var
  Result: String;
begin
  Result:='DROP PROCEDURAL LANGUAGE';
  if ooIfExists in Options then
    Result:=Result + ' IF EXISTS';

  Result:=Result + FLanguageName;

  if DropRule = drCascade then
    Result:=Result + ' CASCADE'
  else
  if DropRule = drRestrict then
    Result:=Result + ' RESTRICT';
  AddSQLCommand(Result);
end;

procedure TPGSQLDropLanguage.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLDropLanguage then
  begin
    LanguageName:=TPGSQLDropLanguage(ASource).LanguageName;

  end;
  inherited Assign(ASource);
end;

{ TPGSQLCreateLanguage }

procedure TPGSQLCreateLanguage.InitParserTree;
var
  T, T1, T2, T3, FSQLTokens: TSQLTokenRecord;
begin
  (* CREATE [ OR REPLACE ] [ PROCEDURAL ] LANGUAGE name *)
  (* CREATE [ OR REPLACE ] [ TRUSTED ] [ PROCEDURAL ] LANGUAGE name HANDLER call_handler [ INLINE inline_handler ] [ VALIDATOR valfunction ] *)

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken]);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'OR', [],6);
    T1:=AddSQLTokens(stKeyword, T1, 'REPLACE', []);

    T3:=AddSQLTokens(stKeyword, FSQLTokens, 'TRUSTED', [], 1);
      T1.AddChildToken(T3);

    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'PROCEDURAL', []);
      T3.AddChildToken(T2);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'LANGUAGE', [toFindWordLast]);
    T1.AddChildToken(T);
    T2.AddChildToken(T);
    T3.AddChildToken(T);

  T:=AddSQLTokens(stIdentificator, T, '', [], 2);
  T:=AddSQLTokens(stKeyword, T, 'HANDLER', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 3);
  T:=AddSQLTokens(stKeyword, T, 'INLINE', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 4);
  T:=AddSQLTokens(stKeyword, T, 'VALIDATOR', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 5);
end;

procedure TPGSQLCreateLanguage.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FTrusted:=true;
    2:FLanguageName:=AWord;
    3:FCallHandler:=AWord;
    4:FInlineHandler:=AWord;
    5:FValFunction:=AWord;
    6:FOrReplace:=true
  end;
end;

procedure TPGSQLCreateLanguage.MakeSQL;
var
  Result: String;
begin
  Result:='CREATE';
  if FOrReplace then
    Result:=Result + ' OR REPLACE';

  if FTrusted then
    Result:=Result + ' TRUSTED';

  Result:=Result + ' PROCEDURAL LANGUAGE '+FLanguageName;

  if FCallHandler<>'' then
    Result:=Result + ' HANDLER '+FCallHandler;

  if FInlineHandler<>'' then
    Result:=Result + ' INLINE '+FInlineHandler;

  if FValFunction<>'' then
    Result:=Result + ' VALIDATOR '+FValFunction;
  AddSQLCommand(Result);
end;

procedure TPGSQLCreateLanguage.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLCreateLanguage then
  begin
    LanguageName:=TPGSQLCreateLanguage(ASource).LanguageName;
    Trusted:=TPGSQLCreateLanguage(ASource).Trusted;
    OrReplace:=TPGSQLCreateLanguage(ASource).OrReplace;
    CallHandler:=TPGSQLCreateLanguage(ASource).CallHandler;
    InlineHandler:=TPGSQLCreateLanguage(ASource).InlineHandler;
    ValFunction:=TPGSQLCreateLanguage(ASource).ValFunction;

  end;
  inherited Assign(ASource);
end;

{ TPGSQLAlterLanguage }

procedure TPGSQLAlterLanguage.InitParserTree;
var
  T, T1, FSQLTokens: TSQLTokenRecord;
begin
  (* ALTER [ PROCEDURAL ] LANGUAGE name RENAME TO new_name *)
  (* ALTER [ PROCEDURAL ] LANGUAGE name OWNER TO new_owner *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken]);
  T1:=AddSQLTokens(stKeyword, FSQLTokens, 'PROCEDURAL', []);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'LANGUAGE', [toFindWordLast]);
  T1.AddChildToken(T);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);

  T1:=AddSQLTokens(stKeyword, T, 'RENAME', [], 2);
  T1:=AddSQLTokens(stKeyword, T1, 'TO', []);
  T1:=AddSQLTokens(stIdentificator, T1, '', [], 3);

  T1:=AddSQLTokens(stKeyword, T, 'OWNER', [], 4);
  T1:=AddSQLTokens(stKeyword, T1, 'TO', []);
  T1:=AddSQLTokens(stIdentificator, T1, '', [], 5);
end;

procedure TPGSQLAlterLanguage.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FLanguageName:=AWord;
    3:FLanguageNewName:=AWord;
    5:FLanguageNewOwner:=AWord;
  end;
end;

procedure TPGSQLAlterLanguage.MakeSQL;
var
  Result: String;
begin
  Result:='ALTER PROCEDURAL LANGUAGE '+FLanguageName;

  if FLanguageNewName <> '' then
    Result:=' RENAME TO '+FLanguageNewName
  else
  if FLanguageNewOwner <> '' then
    Result:=' OWNER TO '+FLanguageNewOwner
  ;
  AddSQLCommand(Result);
end;

procedure TPGSQLAlterLanguage.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLAlterLanguage then
  begin
    LanguageName:=TPGSQLAlterLanguage(ASource).LanguageName;
    LanguageNewName:=TPGSQLAlterLanguage(ASource).LanguageNewName;
    LanguageNewOwner:=TPGSQLAlterLanguage(ASource).LanguageNewOwner;

  end;
  inherited Assign(ASource);
end;

{ TPGSQLDropIndex }

procedure TPGSQLDropIndex.InitParserTree;
var
  T, T1, FSQLTokens, TSchema, TName: TSQLTokenRecord;
begin
  (* DROP INDEX [ IF EXISTS ] name [, ...] [ CASCADE | RESTRICT ] *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'INDEX', [toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, T, 'IF', [], -1);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);

  TSchema:=AddSQLTokens(stIdentificator, [T, T1], '', [],  1);
    T:=AddSQLTokens(stSymbol, TSchema, '.', []);
  TName:=AddSQLTokens(stIdentificator, T, '', [],  2);

  T1:=AddSQLTokens(stKeyword, [TSchema, TName], 'CASCADE', [], -2);
  T1:=AddSQLTokens(stKeyword, [TSchema, TName], 'RESTRICT', [],-3);
end;

procedure TPGSQLDropIndex.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    2:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
  end;
end;

procedure TPGSQLDropIndex.MakeSQL;
var
  S: String;
begin
  S:='DROP INDEX ';
  if ooIfExists in Options then
    S:=S + 'IF EXISTS ';

  S:=S + FullName;

  if DropRule = drCascade then
    S:=S + ' CASCADE'
  else
  if DropRule = drRestrict then
    S:=S + ' RESTRICT';

  AddSQLCommand(S);
end;

{ TPGSQLAlterIndex }

procedure TPGSQLAlterIndex.InitParserTree;
var
  T, T1, T2, T3, T4, FSQLTokens: TSQLTokenRecord;
begin
  (* ALTER INDEX name RENAME TO new_name *)
  (* ALTER INDEX name SET TABLESPACE tablespace_name *)
  (* ALTER INDEX name SET ( storage_parameter = value [, ... ] ) *)
  (* ALTER INDEX name RESET ( storage_parameter [, ... ] ) *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken], 0, okIndex);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'INDEX', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);

  T1:=AddSQLTokens(stKeyword, T, 'RENAME', [], 2);
  T1:=AddSQLTokens(stKeyword, T1, 'TO', []);
  T1:=AddSQLTokens(stIdentificator, T1, '', [], 3);

  T1:=AddSQLTokens(stKeyword, T, 'SET', []);
    T2:=AddSQLTokens(stKeyword, T1, 'TABLESPACE', [], 4);
    T2:=AddSQLTokens(stIdentificator, T2, '', [],  5);

    T2:=AddSQLTokens(stSymbol, T1, '(', [],  6);
    T2:=AddSQLTokens(stIdentificator, T2, '', [], 7);
    T3:=AddSQLTokens(stSymbol, T2, '=', []);
    T3:=AddSQLTokens(stIdentificator, T3, '', [], 8);
    T4:=AddSQLTokens(stSymbol, T3, ')', []);
    T4:=AddSQLTokens(stSymbol, T3, ',', []);
    T4.AddChildToken(T2);

  T1:=AddSQLTokens(stKeyword, T, 'RESET', [], 9);
    T2:=AddSQLTokens(stSymbol, T1, '(', []);
    T2:=AddSQLTokens(stIdentificator, T2, '', [], 10);
    T3:=AddSQLTokens(stSymbol, T2, ')', []);
    T3:=AddSQLTokens(stSymbol, T2, ',', []);
      T3.AddChildToken(T2);
end;

procedure TPGSQLAlterIndex.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FIndexName:=AWord;
    2:FAlterIndexCmd:=aoRename;
    3:FIndexNewName:=AWord;
    4:FAlterIndexCmd:=aoSetTablespace;
    5:FTablespaceName:=AWord;
    6:FAlterIndexCmd:=aoSet;
    7:Params.AddParam(AWord);
    8:begin
        if Params.Count>0 then
          Params[Params.Count-1].RealName:=AWord;
      end;
    9:FAlterIndexCmd:=aoReset;
    10:Params.AddParam(AWord);
  end;
end;

constructor TPGSQLAlterIndex.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okIndex;
  FSQLCommentOnClass:=TPGSQLCommentOn;
end;

procedure TPGSQLAlterIndex.MakeSQL;
var
  S, Result: String;
  i: Integer;
begin
  Result:='ALTER INDEX ' + FIndexName;
  case FAlterIndexCmd of
    aoRename:Result:=Result + ' RENAME TO '+FIndexNewName;
    aoSetTablespace:Result:=Result + ' SET TABLESPACE ' + FTablespaceName;
    aoSet:begin
             S:='';
             for i:=0 to Params.Count-1 do
             begin
               if S<>'' then
                 S:=S + ', ';
               S:=S + Params[i].Caption + ' = ' + Params[i].RealName;
             end;
             Result:=Result + ' SET (' + S + ')';
           end;
    aoReset:Result:=Result + ' RESET (' + Params.AsString + ')';
  end;
  AddSQLCommand(Result);
end;

procedure TPGSQLAlterIndex.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLAlterIndex then
  begin
    AlterIndexCmd:=TPGSQLAlterIndex(ASource).AlterIndexCmd;
    IndexName:=TPGSQLAlterIndex(ASource).IndexName;
    IndexNewName:=TPGSQLAlterIndex(ASource).IndexNewName;
    TablespaceName:=TPGSQLAlterIndex(ASource).TablespaceName;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLDropForeign }

procedure TPGSQLDropForeignTable.InitParserTree;
var
  T, T10, T1, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для DROP FOREIGN TABLE}
  (* DROP FOREIGN DATA WRAPPER [ IF EXISTS ] name [ CASCADE | RESTRICT ] *)
  (* DROP FOREIGN TABLE [ IF EXISTS ] name [, ...] [ CASCADE | RESTRICT ] *)
end;

procedure TPGSQLDropForeignTable.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TPGSQLDropForeignTable.MakeSQL;
begin
  inherited MakeSQL;
end;


{ TPGSQLCreateForeign }

procedure TPGSQLCreateForeignTable.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для CREATE FOREIGN  }
  (*
  CREATE FOREIGN TABLE [ IF NOT EXISTS ] table_name ( [
    { column_name data_type [ NULL | NOT NULL ] }
      [, ... ]
  ] )
    SERVER server_name
  [ OPTIONS ( option 'value' [, ... ] ) ]

  *)
end;

procedure TPGSQLCreateForeignTable.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TPGSQLCreateForeignTable.MakeSQL;
begin
  inherited MakeSQL;
end;

{ TPGSQLAlterForeign }

procedure TPGSQLAlterForeignTable.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для ALTER FOREIGN  }
  (*
  ALTER FOREIGN TABLE name
      action [, ... ]
  ALTER FOREIGN TABLE name
      RENAME [ COLUMN ] column TO new_column
  ALTER FOREIGN TABLE name
      RENAME TO new_name
  ALTER FOREIGN TABLE name
      SET SCHEMA new_schema

  where action is one of:

      ADD [ COLUMN ] column type [ NULL | NOT NULL ]
      DROP [ COLUMN ] [ IF EXISTS ] column [ RESTRICT | CASCADE ]
      ALTER [ COLUMN ] column [ SET DATA ] TYPE type
      ALTER [ COLUMN ] column { SET | DROP } NOT NULL
      OWNER TO new_owner
      OPTIONS ( [ ADD | SET | DROP ] option ['value'] [, ... ])
  *)
end;

procedure TPGSQLAlterForeignTable.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TPGSQLAlterForeignTable.MakeSQL;
begin
  inherited MakeSQL;
end;

{ TPGSQLDropExtension }

procedure TPGSQLDropExtension.InitParserTree;
var
  T, T1, FSQLTokens: TSQLTokenRecord;
begin
  (* DROP EXTENSION [ IF EXISTS ] extension_name [, ...] [ CASCADE | RESTRICT ] *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'EXTENSION', [toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, T, 'IF', [], -1);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
  T1.AddChildToken(T);
  T1:=AddSQLTokens(stKeyword, T, 'CASCADE', [], -2);
  T1:=AddSQLTokens(stKeyword, T, 'RESTRICT', [], -3);
end;

procedure TPGSQLDropExtension.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
  end;
end;

procedure TPGSQLDropExtension.MakeSQL;
var
  S: String;
begin
  S:='DROP EXTENSION ';
  if ooIfExists in Options then
    S:=S + 'IF EXISTS ';

  S:=S + Name;

  if DropRule = drCascade then
    S:=S + ' CASCADE'
  else
  if DropRule = drRestrict then
    S:=S + ' RESTRICT';

  AddSQLCommand(S);
end;

{ TPGSQLCreateExtension }

procedure TPGSQLCreateExtension.InitParserTree;
var
  T, FSQLTokens, T1, T2, T2_1, T3_1, T3, T4, T4_1, T3_2: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для CREATE EXTENSION }
  (*
  CREATE EXTENSION [ IF NOT EXISTS ] extension_name
      [ WITH ] [ SCHEMA schema ]
               [ VERSION version ]
               [ FROM old_version ]
*)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okExtension);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'EXTENSION', [toFindWordLast]);

  T1:=AddSQLTokens(stKeyword, T, 'IF', [toOptional], 5);
  T1:=AddSQLTokens(stKeyword, T1, 'NOT', []);
  T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);

  T:=AddSQLTokens(stIdentificator, [T, T1], '', [], 6);
    T1:=AddSQLTokens(stKeyword, T, 'WITH', [toOptional], 7);

  T2:=AddSQLTokens(stKeyword, [T, T1], 'SCHEMA', [toOptional]);
    T2_1:=AddSQLTokens(stIdentificator, T2, '', [], 8);
  T3:=AddSQLTokens(stKeyword, [T, T1], 'VERSION', [toOptional]);
    T3_1:=AddSQLTokens(stIdentificator, T3, '', [], 9);
    T3_2:=AddSQLTokens(stString, T3, '', [], 9);
  T4:=AddSQLTokens(stKeyword, [T, T1], 'FROM', [toOptional]);
    T4_1:=AddSQLTokens(stIdentificator, T4, '', [], 10);

  T2_1.AddChildToken([T3, T4]);
  T3_1.AddChildToken([T2, T4]);
  T3_2.AddChildToken([T2, T4]);
  T4_1.AddChildToken([T2, T3]);
//             [ VERSION version ]
//             [ FROM old_version ]
end;

procedure TPGSQLCreateExtension.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    5:Options:=Options + [ooIfNotExists];
    6:Name:=AWord;
    7:ExistsWith:=true;
    8:SchemaName:=AWord;
    9:Version:=AWord;
    10:OldVersion:=AWord;
  end;
end;

procedure TPGSQLCreateExtension.MakeSQL;
var
  S: String;
begin
  S:='CREATE EXTENSION';
  if ooIfNotExists in Options then
    S:=S + ' IF NOT EXISTS';
  S:=S + ' ' + Name;

  if FExistsWith then
    S:=S + ' WITH';

  if SchemaName <> '' then
    S:=S + ' SCHEMA '+SchemaName;

  if Version <> '' then
    S:=S + ' VERSION '+Version;

  if OldVersion <> '' then
    S:=S + ' FROM '+OldVersion;

  AddSQLCommand(S);

  if Description <> '' then
    DescribeObject;
end;

constructor TPGSQLCreateExtension.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okExtension;
  FSQLCommentOnClass:=TPGSQLCommentOn;
end;

procedure TPGSQLCreateExtension.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLCreateExtension then
  begin
    ExistsWith:=TPGSQLCreateExtension(ASource).ExistsWith;
    SchemaName:=TPGSQLCreateExtension(ASource).SchemaName;
    Version:=TPGSQLCreateExtension(ASource).Version;
    OldVersion:=TPGSQLCreateExtension(ASource).OldVersion;

  end;
  inherited Assign(ASource);
end;


{ TPGSQLAlterExtension }

procedure TPGSQLAlterExtension.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для ALTER EXTENSION }
  (*
  ALTER EXTENSION extension_name UPDATE [ TO new_version ]
  ALTER EXTENSION extension_name SET SCHEMA new_schema
  ALTER EXTENSION extension_name ADD member_object
  ALTER EXTENSION extension_name DROP member_object

  where member_object is:

    AGGREGATE agg_name (agg_type [, ...] ) |
    CAST (source_type AS target_type) |
    COLLATION object_name |
    CONVERSION object_name |
    DOMAIN object_name |
    FOREIGN DATA WRAPPER object_name |
    FOREIGN TABLE object_name |
    FUNCTION function_name ( [ [ argmode ] [ argname ] argtype [, ...] ] ) |
    OPERATOR operator_name (left_type, right_type) |
    OPERATOR CLASS object_name USING index_method |
    OPERATOR FAMILY object_name USING index_method |
    [ PROCEDURAL ] LANGUAGE object_name |
    SCHEMA object_name |
    SEQUENCE object_name |
    SERVER object_name |
    TABLE object_name |
    TEXT SEARCH CONFIGURATION object_name |
    TEXT SEARCH DICTIONARY object_name |
    TEXT SEARCH PARSER object_name |
    TEXT SEARCH TEMPLATE object_name |
    TYPE object_name |
    VIEW object_name
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'EXTENSION', [toFindWordLast]);
end;

procedure TPGSQLAlterExtension.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TPGSQLAlterExtension.MakeSQL;
var
  Result: String;
begin
  Result:='ALTER EXTENSION';
  AddSQLCommand(Result);
end;

{ TPGSQLDropDomain }

procedure TPGSQLDropDomain.InitParserTree;
var
  T, T1, FSQLTokens, TSchema, TSymb, TName: TSQLTokenRecord;
begin
  (* DROP DOMAIN [ IF EXISTS ] name [, ...] [ CASCADE | RESTRICT ] *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'DOMAIN', [toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, T, 'IF', [], -1);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);

  TSchema:=AddSQLTokens(stIdentificator, [T, T1], '', [], 1);
  TSymb:=AddSQLTokens(stSymbol, TSchema, '.', [toOptional]);
  TName:=AddSQLTokens(stIdentificator, TSymb, '', [], 2);
  TSymb:=AddSQLTokens(stSymbol, [TSchema, TName], ',', [toOptional], 3);
    TSymb.AddChildToken(TSchema);

  T1:=AddSQLTokens(stKeyword, [TSchema, TName], 'CASCADE', [toOptional], -2);
  T1:=AddSQLTokens(stKeyword, [TSchema, TName], 'RESTRICT', [toOptional], -3);
end;

procedure TPGSQLDropDomain.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:begin
        Name:=AWord;
        Tables.Add(AWord);
      end;
    2:begin
        SchemaName:=Name;
        Name:=AWord;
        Tables.Item[Tables.Count-1].SchemaName:=SchemaName;
        Tables.Item[Tables.Count-1].Name:=Name;
      end;
  end;
end;

procedure TPGSQLDropDomain.MakeSQL;
var
  S: String;
begin
  S:='DROP DOMAIN ';
  if ooIfExists in Options then
    S:=S + 'IF EXISTS ';

  if Tables.Count > 1 then
    S:=S + Tables.AsString
  else
    S:=S + FullName;

  if DropRule = drCascade then
    S:=S + ' CASCADE'
  else
  if DropRule = drRestrict then
    S:=S + ' RESTRICT';

  AddSQLCommand(S);
end;

{ TPGSQLCreateDomain }

procedure TPGSQLCreateDomain.InitParserTree;
var
  T, FSQLTokens, TSchema, T1, TName, TAS: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для CREATE DOMAIN }
  (*
  CREATE DOMAIN имя [ AS ] тип_данных
      [ COLLATE правило_сортировки ]
      [ DEFAULT выражение ]
      [ ограничение [ ... ] ]

  Здесь ограничение:

  [ CONSTRAINT имя_ограничения ]
  { NOT NULL | NULL | CHECK (выражение) }
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'DOMAIN', [toFindWordLast]);
  TSchema:=AddSQLTokens(stIdentificator, T, '', [], 1);
    T1:=AddSQLTokens(stSymbol, TSchema, '.', []);
  TName:=AddSQLTokens(stIdentificator, T1, '', [], 2);

  TAS:=AddSQLTokens(stKeyword, [TSchema, TName], 'AS', []);

  MakeTypeDefTree(Self, [TSchema, TName, TAS], [], tdfDomain, 100);
end;

procedure TPGSQLCreateDomain.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:Name:=AWord;
    2:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
    102:DomainType:=AWord;
    103:DomainType:=DomainType + ' ' + AWord;
    104:TypeLen:=StrToInt(AWord);
    105:TypePrec:=StrToInt(AWord);
    106:ConstraintName:=AWord;
    107:NotNull:=true;
    108:IsNull:=true;
    109:CheckExpression:=ASQLParser.GetToBracket(')');
    114:CollationName:=AWord;
    127:DefaultValue:=GetToNextToken(ASQLParser, AChild);
  end;
end;

procedure TPGSQLCreateDomain.MakeSQL;
var
  S: String;
begin

  S:='CREATE DOMAIN ' + FullName + ' AS ' + DomainType;

  if TypeLen > 0 then
  begin
    S:=S + '('+IntToStr(TypeLen);
    if TypePrec > 0 then
      S:=S + ',' + IntToStr(TypePrec);
    S:=S + ')';
  end;

  if CollationName <> '' then
    S:=S + ' COLLATE ' + CollationName;

  if DefaultValue <> '' then
    S:=S + ' DEFAULT '+DefaultValue;


  if ConstraintName <> '' then
    S:=S+ ' CONSTRAINT '+ConstraintName;

  if NotNull then
    S:=S + ' NOT NULL'
  else
  if IsNull then
    S:=S + ' NULL';

  if CheckExpression <> '' then
    S:=S+' CHECK ('+CheckExpression+')';

  AddSQLCommand(S);

  if Description <> '' then
    DescribeObject;
end;

constructor TPGSQLCreateDomain.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSQLCommentOnClass:=TPGSQLCommentOn;
end;

{ TPGSQLAlterDomain }

procedure TPGSQLAlterDomain.InitParserTree;
var
  T, FSQLTokens, TSchema, T1, TSet, TDrop, TName, T2: TSQLTokenRecord;
begin
(*
ALTER DOMAIN имя
    { SET DEFAULT выражение | DROP DEFAULT }
ALTER DOMAIN имя
    { SET | DROP } NOT NULL
ALTER DOMAIN имя
    ADD ограничение_домена [ NOT VALID ]
ALTER DOMAIN имя
    DROP CONSTRAINT [ IF EXISTS ] имя_ограничения [ RESTRICT | CASCADE ]
ALTER DOMAIN имя
     RENAME CONSTRAINT имя_ограничения TO имя_нового_ограничения
ALTER DOMAIN имя
    VALIDATE CONSTRAINT имя_ограничения
ALTER DOMAIN имя
    OWNER TO { новый_владелец | CURRENT_USER | SESSION_USER }
ALTER DOMAIN имя
    RENAME TO новое_имя
ALTER DOMAIN имя
    SET SCHEMA новая_схема
*)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'DOMAIN', [toFindWordLast]);
  TSchema:=AddSQLTokens(stIdentificator, T, '', [], 1);
    T1:=AddSQLTokens(stSymbol, TSchema, '.', []);
  TName:=AddSQLTokens(stIdentificator, T1, '', [], 2);

  TSet:=AddSQLTokens(stKeyword, [TSchema, TName], 'SET', []);
    T1:=AddSQLTokens(stKeyword, TSet, 'NOT', []);                //ALTER DOMAIN name SET NOT NULL
    T1:=AddSQLTokens(stKeyword, T1, 'NULL', [], 3);

  T1:=AddSQLTokens(stKeyword, TSet, 'SCHEMA', []);
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 7);             //ALTER DOMAIN name SET SCHEMA new_schema

  T1:=AddSQLTokens(stKeyword, TSet, 'DEFAULT', [], 5);           //ALTER DOMAIN name SET DEFAULT expression

  TDrop:=AddSQLTokens(stKeyword, [TSchema, TName], 'DROP', []);
      T1:=AddSQLTokens(stKeyword, TDrop, 'NOT', []);             //ALTER DOMAIN name DROP NOT NULL
      T1:=AddSQLTokens(stKeyword, T1, 'NULL', [], 4);
  T1:=AddSQLTokens(stKeyword, TDrop, 'DEFAULT', [], 6);          //ALTER DOMAIN name DROP DEFAULT

  T1:=AddSQLTokens(stKeyword, TDrop, 'CONSTRAINT', []);          //ALTER DOMAIN имя DROP CONSTRAINT [ IF EXISTS ] имя_ограничения [ RESTRICT | CASCADE ]
    T2:=AddSQLTokens(stKeyword, T1, 'IF', []);
    T2:=AddSQLTokens(stKeyword, T2, 'EXISTS', [], 12);
  T:=AddSQLTokens(stIdentificator, [T1, T2], '', [], 13);
    T2:=AddSQLTokens(stKeyword, T, 'RESTRICT', [toOptional], 14);
    T2:=AddSQLTokens(stKeyword, T, 'CASCADE', [toOptional], 15);

  T:=AddSQLTokens(stKeyword, [TSchema, TName], 'OWNER', []);
  T:=AddSQLTokens(stKeyword, T, 'TO', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 8);                 //ALTER DOMAIN name OWNER TO { new_owner | CURRENT_USER | SESSION_USER }

  T1:=AddSQLTokens(stKeyword, [TSchema, TName], 'RENAME', []);
  T:=AddSQLTokens(stKeyword, T1, 'TO', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 99);                 //ALTER DOMAIN имя RENAME TO новое_имя

  T:=AddSQLTokens(stKeyword, T1, 'CONSTRAINT', []);               //ALTER DOMAIN имя RENAME CONSTRAINT имя_ограничения TO имя_нового_ограничения
  T:=AddSQLTokens(stIdentificator, T, '', [], 16);
  T:=AddSQLTokens(stKeyword, T, 'TO', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 17);



  T:=AddSQLTokens(stKeyword, [TSchema, TName], 'VALIDATE', []);
  T:=AddSQLTokens(stKeyword, T, 'CONSTRAINT', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 9);                 //ALTER DOMAIN имя VALIDATE CONSTRAINT имя_ограничения

  T:=AddSQLTokens(stKeyword, [TSchema, TName], 'ADD', []);
    T1:=AddSQLTokens(stKeyword, T, 'CONSTRAINT', []);
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 10);                 //ALTER DOMAIN имя ADD ограничение_домена [ NOT VALID ]
  T:=AddSQLTokens(stKeyword, T1, 'CHECK', []);
  T:=AddSQLTokens(stSymbol, T, '(', [], 18);
  T:=AddSQLTokens(stKeyword, T, 'NOT', [toOptional]);
  T:=AddSQLTokens(stKeyword, T, 'VALID', [], 11);

  //ALTER DOMAIN system.type_boolean ADD CONSTRAINT dd CHECK (value>0) NOT VALID;
  //ALTER DOMAIN system.type_boolean ADD CHECK (value>1);

end;

procedure TPGSQLAlterDomain.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    2:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
    3:Operators.AddItem(adaSetNotNull);
    4:Operators.AddItem(adaDropNotNull);
    5:Operators.AddItem(adaSetDefault, TrimLeft(ASQLParser.GetToCommandDelemiter));
    6:Operators.AddItem(adaDropDefault);
    7:Operators.AddItem(adaSetSchema, AWord);
    8:Operators.AddItem(adaSetOwner, AWord);
    9:Operators.AddItem(adaValidateConstraint, AWord);
    10:FCurOp:=Operators.AddItem(adaAddConstraint, AWord);
    16:FCurOp:=Operators.AddItem(adaRenameConstraint, AWord);
    17:if Assigned(FCurOp) then
       begin
         FCurOp.Params.AddParam(AWord);
         FCurOp:=nil;
       end;
    18:if Assigned(FCurOp) then
       begin
         FCurParam:=FCurOp.Params.AddParam(ASQLParser.GetToBracket(')'));
       end;
    11:if Assigned(FCurParam) then
         FCurParam.NotNull:=True;
    12:begin
         FCurOp:=Operators.AddItem(adaDropConstraint, '');
         FCurOp.IfExists:=true;
       end;
    13:begin
         if not Assigned(FCurOp) then
           FCurOp:=Operators.AddItem(adaDropConstraint, AWord)
         else
           FCurOp.ParamValue:=AWord;
       end;
    14:if Assigned(FCurOp) then
         FCurOp.DropRule:=drRestrict;
    15:if Assigned(FCurOp) then
         FCurOp.DropRule:=drCascade;
    99:Operators.AddItem(adaRenameDomain, AWord);
  end;
end;

procedure TPGSQLAlterDomain.MakeSQL;
var
  OP: TAlterDomainOperator;
  S1, S2: String;
begin
  for OP in Operators do
  begin
    case OP.AlterAction of
      adaRenameDomain:AddSQLCommandEx('ALTER DOMAIN %s RENAME TO %s', [FullName, OP.ParamValue]);
      adaSetDefault:AddSQLCommandEx('ALTER DOMAIN %s SET DEFAULT %s', [FullName, OP.ParamValue]);
      adaDropDefault:AddSQLCommandEx('ALTER DOMAIN %s DROP DEFAULT', [FullName]);
      adaSetNotNull:AddSQLCommandEx('ALTER DOMAIN %s SET NOT NULL', [FullName]);
      adaDropNotNull:AddSQLCommandEx('ALTER DOMAIN %s DROP NOT NULL', [FullName]);
      adaSetSchema:AddSQLCommandEx('ALTER DOMAIN %s SET SCHEMA %s', [FullName, OP.ParamValue]);
      adaSetOwner:AddSQLCommandEx('ALTER DOMAIN %s OWNER TO %s', [FullName, OP.ParamValue]);
      adaRenameConstraint:AddSQLCommandEx('ALTER DOMAIN %s RENAME CONSTRAINT %s TO %s', [FullName, OP.ParamValue, OP.Params.AsString]);
      adaAddConstraint:begin
            if (OP.Params.Count>0) and (OP.Params[0].NotNull) then
              S1:=' NOT VALID'
            else
              S1:='';
            AddSQLCommandEx('ALTER DOMAIN %s ADD CONSTRAINT %s CHECK (%s)%s', [FullName, OP.ParamValue, OP.Params.AsString, S1]);
          end;
      adaDropConstraint:begin
        if OP.IfExists then
          S1:='IF EXISTS '
        else
          S1:='';
        case OP.DropRule of
          drRestrict:S2:=' RESTRICT';
          drCascade:S2:=' CASCADE';
        else
          S2:='';
        end;
        AddSQLCommandEx('ALTER DOMAIN %s DROP CONSTRAINT %s%s%s', [FullName, S1, OP.ParamValue, S2]);
      end;
      adaValidateConstraint:AddSQLCommandEx('ALTER DOMAIN %s VALIDATE CONSTRAINT %s', [FullName, OP.ParamValue]);
    end;
  end;
end;

constructor TPGSQLAlterDomain.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSQLCommentOnClass:=TPGSQLCommentOn;
end;


{ TPGSQLAlterDefaultPrivileges }

procedure TPGSQLAlterDefaultPrivileges.InitParserTree;
var
  T, FSQLTokens, TUsr, TUsr1, TUsr2, TSchema, TSchema1, TGrant,
    TRevoke: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для ALTER DEFAULT PRIVILEGES}
  (*
  ALTER DEFAULT PRIVILEGES
      [ FOR { ROLE | USER } target_role [, ...] ]
      [ IN SCHEMA schema_name [, ...] ]
      abbreviated_grant_or_revoke

  where abbreviated_grant_or_revoke is one of:

  GRANT { { SELECT | INSERT | UPDATE | DELETE | TRUNCATE | REFERENCES | TRIGGER }
      [, ...] | ALL [ PRIVILEGES ] }
      ON TABLES
      TO { [ GROUP ] role_name | PUBLIC } [, ...] [ WITH GRANT OPTION ]

  GRANT { { USAGE | SELECT | UPDATE }
      [, ...] | ALL [ PRIVILEGES ] }
      ON SEQUENCES
      TO { [ GROUP ] role_name | PUBLIC } [, ...] [ WITH GRANT OPTION ]

  GRANT { EXECUTE | ALL [ PRIVILEGES ] }
      ON FUNCTIONS
      TO { [ GROUP ] role_name | PUBLIC } [, ...] [ WITH GRANT OPTION ]

  REVOKE [ GRANT OPTION FOR ]
      { { SELECT | INSERT | UPDATE | DELETE | TRUNCATE | REFERENCES | TRIGGER }
      [, ...] | ALL [ PRIVILEGES ] }
      ON TABLES
      FROM { [ GROUP ] role_name | PUBLIC } [, ...]
      [ CASCADE | RESTRICT ]

  REVOKE [ GRANT OPTION FOR ]
      { { USAGE | SELECT | UPDATE }
      [, ...] | ALL [ PRIVILEGES ] }
      ON SEQUENCES
      FROM { [ GROUP ] role_name | PUBLIC } [, ...]
      [ CASCADE | RESTRICT ]

  REVOKE [ GRANT OPTION FOR ]
      { EXECUTE | ALL [ PRIVILEGES ] }
      ON FUNCTIONS
      FROM { [ GROUP ] role_name | PUBLIC } [, ...]
      [ CASCADE | RESTRICT ]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken]);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'DEFAULT', []);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'PRIVILEGES', [toFindWordLast]);
    TUsr:=AddSQLTokens(stKeyword, FSQLTokens, 'FOR', []);
    TUsr1:=AddSQLTokens(stKeyword, TUsr, 'ROLE', [], 1);
    TUsr2:=AddSQLTokens(stKeyword, TUsr, 'USER', [], 2);
    TUsr1:=AddSQLTokens(stIdentificator, [TUsr1, TUsr2], 'USER', [], 3);
      T:=AddSQLTokens(stSymbol, TUsr1, ',', []);
      T.AddChildToken(TUsr1);

    TSchema:=AddSQLTokens(stKeyword, [FSQLTokens, TUsr1], 'IN', []);
    TSchema1:=AddSQLTokens(stKeyword, TSchema, 'SCHEMA', []);
    TSchema1:=AddSQLTokens(stIdentificator, TSchema1, '', [], 4);
      T:=AddSQLTokens(stSymbol, TSchema1, ',', []);
      T.AddChildToken(TSchema1);
    TSchema1.AddChildToken(TUsr);

  TGrant:=AddSQLTokens(stKeyword, [FSQLTokens, TUsr1, TSchema1], 'GRANT', [], 10);
  TRevoke:=AddSQLTokens(stKeyword, [FSQLTokens, TUsr1, TSchema1], 'REVOKE', [], 11);
end;

procedure TPGSQLAlterDefaultPrivileges.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:begin
        FCurParam:=Params.AddParam('');
        FCurParam.ObjectKind:=okRole;
      end;
    2:begin
        FCurParam:=Params.AddParam('');
        FCurParam.ObjectKind:=okUser;
      end;
    3:if Assigned(FCurParam) then FCurParam.Caption:=AWord;
    4:Schemas.AddParam(AWord);
  end;
end;

procedure TPGSQLAlterDefaultPrivileges.MakeSQL;
var
  S: String;
begin
  S:='ALTER DEFAULT PRIVILEGES';
  if Params.Count>0 then
  begin
    if Params[0].ObjectKind = okUser then S:=S + ' USER'
    else S:=S + ' ROLE';
    S:=S + Params.AsString;
  end;

  if Schemas.Count > 0 then
    S:=S + ' IN SCHEMA '+Schemas.AsString;

  AddSQLCommand(S);
end;

constructor TPGSQLAlterDefaultPrivileges.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSchemas:=TSQLFields.Create;
end;

destructor TPGSQLAlterDefaultPrivileges.Destroy;
begin
  FreeAndNil(FSchemas);
  inherited Destroy;
end;

procedure TPGSQLAlterDefaultPrivileges.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLAlterDefaultPrivileges then
  begin
    FSchemas.Assign(TPGSQLAlterDefaultPrivileges(ASource).FSchemas);
  end;
  inherited Assign(ASource);
end;

{ TPGSQLDropTextSearch }

procedure TPGSQLDropTextSearch.InitParserTree;
var
  FSQLTokens, T, T1, T2, T3, T4: TSQLTokenRecord;
begin
  (* DROP TEXT SEARCH CONFIGURATION [ IF EXISTS ] name [ CASCADE | RESTRICT ] *)
  (* DROP TEXT SEARCH DICTIONARY [ IF EXISTS ] name [ CASCADE | RESTRICT ] *)
  (* DROP TEXT SEARCH PARSER [ IF EXISTS ] name [ CASCADE | RESTRICT ] *)
  (* DROP TEXT SEARCH TEMPLATE [ IF EXISTS ] name [ CASCADE | RESTRICT ] *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'TEXT', []);
  T:=AddSQLTokens(stKeyword, T, 'SEARCH', []);

  T1:=AddSQLTokens(stKeyword, T, 'CONFIGURATION', [toFindWordLast], 10);
  T2:=AddSQLTokens(stKeyword, T, 'DICTIONARY', [toFindWordLast], 11);
  T3:=AddSQLTokens(stKeyword, T, 'PARSER', [toFindWordLast], 12);
  T4:=AddSQLTokens(stKeyword, T, 'TEMPLATE', [toFindWordLast],  13);

  T:=AddSQLTokens(stKeyword, [T1, T2, T3, T4], 'IF', [], -1);
  T:=AddSQLTokens(stKeyword, T, 'EXISTS', [],  -1);

  T:=AddSQLTokens(stIdentificator, [T, T1, T2, T3, T4], '', [],  1);
    T1:=AddSQLTokens(stSymbol, T, '.', [],  1);
    T1:=AddSQLTokens(stIdentificator, T1, '', [],  2);

  T1:=AddSQLTokens(stKeyword, T, 'CASCADE', [], -2);
  T1:=AddSQLTokens(stKeyword, T, 'RESTRICT', [], -3);
end;

procedure TPGSQLDropTextSearch.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:TableName:=AWord;
    2:begin
        SchemaName:=TableName;
        TableName:=AWord;
      end;
    10:ObjectKind:=okFTSConfig;
    11:ObjectKind:=okFTSDictionary;
    12:ObjectKind:=okFTSParser;
    13:ObjectKind:=okFTSTemplate;
  end;
end;

procedure TPGSQLDropTextSearch.MakeSQL;
var
  S: String;
begin
  S:='DROP TEXT SEARCH';

  case ObjectKind of
    okFTSConfig:S:=S + ' CONFIGURATION';
    okFTSDictionary:S:=S +  ' DICTIONARY';
    okFTSParser:S:=S + ' PARSER';
    okFTSTemplate:S:=S + ' TEMPLATE';
  end;

  if ooIfExists in Options then
    S:=S + ' IF EXISTS';

  S:=S + ' ' + FullName;

  if DropRule = drCascade then
    S:=S + ' CASCADE'
  else
  if DropRule = drRestrict then
    S:=S + ' RESTRICT'
  ;

  AddSQLCommand(S);
end;

{ TPGSQLCreateTextSearch }

procedure TPGSQLCreateTextSearchConfig.InitParserTree;
var
  FSQLTokens, T, T1, T2: TSQLTokenRecord;
begin
  (*
  CREATE TEXT SEARCH CONFIGURATION name (
    PARSER = parser_name |
    COPY = source_config
    )
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okFTSConfig);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'TEXT', []);
  T:=AddSQLTokens(stKeyword, T, 'SEARCH', []);
  T:=AddSQLTokens(stKeyword, T, 'CONFIGURATION', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
    T1:=AddSQLTokens(stSymbol, T, '.', []);
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 2);
  T:=AddSQLTokens(stSymbol, [T, T1], '(', []);

  T1:=AddSQLTokens(stKeyword, T, 'PARSER', [], 3);
  T1:=AddSQLTokens(stSymbol, T1, '=', []);
  T1:=AddSQLTokens(stIdentificator, T1, '', [], 4);

  T2:=AddSQLTokens(stKeyword, T, 'COPY', [], 3);
  T2:=AddSQLTokens(stSymbol, T2, '=', []);
  T2:=AddSQLTokens(stIdentificator, T2, '', [], 4);

  T:=AddSQLTokens(stSymbol, [T1, T2], '(', []);
end;

procedure TPGSQLCreateTextSearchConfig.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    2:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
    3:FCurParam:=Params.AddParam(AWord);
    4:if Assigned(FCurParam) then
      FCurParam.RealName:=AWord;
    5:FCurParam:=nil;
  end;
end;

constructor TPGSQLCreateTextSearchConfig.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FObjectKind:=okFTSConfig;
  FSQLCommentOnClass:=TPGSQLCommentOn;
end;

procedure TPGSQLCreateTextSearchConfig.MakeSQL;
var
  S, S1: String;
  P: TSQLParserField;
begin
  //S:='CREATE TEXT SEARCH CONFIGURATION ' + FullName + '(' + LineEnding;
  S:='CREATE ' + PGObjectNames[ObjectKind] + FullName + '(' + LineEnding;
  S1:='';
  for P in Params do
  begin
    if S1<>'' then S1:=S1 + ','+LineEnding;
    S1:=S1 + '  ' + P.Caption + ' = '+ P.RealName;
  end;
  S:=S + S1 + LineEnding +')';
  AddSQLCommand(S);

  if Description <> '' then
    DescribeObject;
end;

{ TPGSQLAlterTextSearch }

procedure TPGSQLAlterTextSearch.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для ALTER TEXT SEARCH }
  (*
  ALTER TEXT SEARCH CONFIGURATION name
      ADD MAPPING FOR token_type [, ... ] WITH dictionary_name [, ... ]
  ALTER TEXT SEARCH CONFIGURATION name
      ALTER MAPPING FOR token_type [, ... ] WITH dictionary_name [, ... ]
  ALTER TEXT SEARCH CONFIGURATION name
      ALTER MAPPING REPLACE old_dictionary WITH new_dictionary
  ALTER TEXT SEARCH CONFIGURATION name
      ALTER MAPPING FOR token_type [, ... ] REPLACE old_dictionary WITH new_dictionary
  ALTER TEXT SEARCH CONFIGURATION name
      DROP MAPPING [ IF EXISTS ] FOR token_type [, ... ]
  ALTER TEXT SEARCH CONFIGURATION name RENAME TO new_name
  ALTER TEXT SEARCH CONFIGURATION name OWNER TO new_owner
  ALTER TEXT SEARCH CONFIGURATION name SET SCHEMA new_schema
  *)
  (*
  ALTER TEXT SEARCH DICTIONARY name (
      option [ = value ] [, ... ]
  )
  ALTER TEXT SEARCH DICTIONARY name RENAME TO new_name
  ALTER TEXT SEARCH DICTIONARY name OWNER TO new_owner
  ALTER TEXT SEARCH DICTIONARY name SET SCHEMA new_schema
  *)
  (*
  ALTER TEXT SEARCH PARSER name RENAME TO new_name
  ALTER TEXT SEARCH PARSER name SET SCHEMA new_schema
  *)

  (*
  ALTER TEXT SEARCH TEMPLATE name RENAME TO new_name
  ALTER TEXT SEARCH TEMPLATE name SET SCHEMA new_schema
  *)

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'TEXT', []);
  T:=AddSQLTokens(stKeyword, T, 'SEARCH', [toFindWordLast]);
end;

procedure TPGSQLAlterTextSearch.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TPGSQLAlterTextSearch.MakeSQL;
var
  Result: String;
begin
  Result:='ALTER TEXT SEARCH';
  AddSQLCommand(Result);
end;

{ TPGSQLDropUser }

procedure TPGSQLDropUser.InitParserTree;
var
  T, T10, T1, T20, T3, T4, T6, T5, FSQLTokens: TSQLTokenRecord;
begin
  (* DROP USER [ IF EXISTS ] name [, ...] *)
  (* DROP USER MAPPING [ IF EXISTS ] FOR { user_name | USER | CURRENT_USER | PUBLIC } SERVER server_name *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  T10:=AddSQLTokens(stKeyword, FSQLTokens, 'USER', [toFindWordLast]);

  T1:=AddSQLTokens(stKeyword, T10, 'IF', [], -1);
  T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);
  T1:=AddSQLTokens(stIdentificator, T1, '', [],  1);
  T10.AddChildToken(T1);
  T:=AddSQLTokens(stSymbol, T1, ',', []);
  T.AddChildToken(T1);

  T20:=AddSQLTokens(stKeyword, T10, 'MAPPING', [], 2);
  T1:=AddSQLTokens(stKeyword, T20, 'IF', [],  -1);
  T1:=AddSQLTokens(stKeyword, T1, 'FOR', []);
  T20:=AddSQLTokens(stKeyword, T20, 'FOR', []);
  T1.AddChildToken(T20);
  T3:=AddSQLTokens(stIdentificator, T20, '', [],  3);
  T4:=AddSQLTokens(stKeyword, T20, 'USER', [],  4);
  T5:=AddSQLTokens(stKeyword, T20, 'CURRENT_USER', [],  5);
  T6:=AddSQLTokens(stKeyword, T20, 'PUBLIC', [],  6);

  T20:=AddSQLTokens(stKeyword, T3, 'SERVER', []);
  T4.AddChildToken(T20);
  T5.AddChildToken(T20);
  T6.AddChildToken(T20);
  T20:=AddSQLTokens(stIdentificator, T20, '', [], 7);
end;

procedure TPGSQLDropUser.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  if AChild.Tag = 1 then
  begin
    FIsMapping:=false;
    FUserName:=AWord;
  end
  else
  begin
    case AChild.Tag of
      2:FIsMapping:=true;
      3:begin
          FUserMapingOperation:=umoUserName;
          FUserName:=AWord;
        end;
      4:FUserMapingOperation:=umoUSER;
      5:FUserMapingOperation:=umoCURRENT_USER;
      6:FUserMapingOperation:=umoPUBLIC;
      7:FServerName:=AWord;
    end;
  end
end;

procedure TPGSQLDropUser.MakeSQL;
var
  Result: String;
begin
  Result:='DROP USER';

  if FIsMapping then
  begin
    (* DROP USER MAPPING [ IF EXISTS ] FOR { user_name | USER | CURRENT_USER | PUBLIC } SERVER server_name *)
    Result:=Result + ' MAPPING';
    if ooIfExists in Options then
      Result:=Result + ' IF EXISTS';
    Result:=Result + ' FOR';
    case FUserMapingOperation of
      umoUserName:Result:=Result + ' ' + FUserName;
      umoUSER:Result:=Result + ' USER';
      umoCURRENT_USER:Result:=Result + ' CURRENT_USER';
      umoPUBLIC:Result:=Result + ' PUBLIC';
    end;
    Result:=Result + ' SERVER ' + FServerName;
  end
  else
  begin
    (* DROP USER [ IF EXISTS ] name [, ...] *)
    if ooIfExists in Options then
      Result:=Result + ' IF EXISTS';
    Result:=Result + ' ' + FUserName;
  end;
  AddSQLCommand(Result);
end;

procedure TPGSQLDropUser.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLDropUser then
  begin
    IsMapping:=TPGSQLDropUser(ASource).IsMapping;
    UserName:=TPGSQLDropUser(ASource).UserName;
    ServerName:=TPGSQLDropUser(ASource).ServerName;
    UserMapingOperation:=TPGSQLDropUser(ASource).UserMapingOperation;
  end;
  inherited Assign(ASource);
end;
(*
{ TPGSQLCreateUser }

procedure TPGSQLCreateUser.InitParserTree;
var
  T, FSQLTokens, T1, TWith, T2, T4, T5, T6, T7, T8, T9, T10,
    T11, T12, T13, T14, T15, T16, T17: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для CREATE USER }
  (*
  CREATE USER name [ [ WITH ] option [ ... ] ]

where option can be:

      SUPERUSER | NOSUPERUSER
    | CREATEDB | NOCREATEDB
    | CREATEROLE | NOCREATEROLE
    | CREATEUSER | NOCREATEUSER
    | INHERIT | NOINHERIT
    | LOGIN | NOLOGIN
    | REPLICATION | NOREPLICATION
    | BYPASSRLS | NOBYPASSRLS
    | CONNECTION LIMIT connlimit
    | [ ENCRYPTED | UNENCRYPTED ] PASSWORD 'password'
    | VALID UNTIL 'timestamp'
    | IN ROLE role_name [, ...]
    | IN GROUP role_name [, ...]
    | ROLE role_name [, ...]
    | ADMIN role_name [, ...]
    | USER role_name [, ...]
    | SYSID uid
  *)
  (*
  CREATE USER MAPPING FOR { user_name | USER | CURRENT_USER | PUBLIC }
    SERVER server_name
    [ OPTIONS ( option 'value' [ , ... ] ) ]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'USER', [toFindWordLast]);
    T1:=AddSQLTokens(stIdentificator, T, '', [], 1);
    T2:=AddSQLTokens(stString, T, '', [], 1);
  TWith:=AddSQLTokens(stKeyword, [T1, T2], 'WITH', []);
    T1:=AddSQLTokens(stKeyword, TWith, 'SUPERUSER', [], 2);
    T2:=AddSQLTokens(stKeyword, TWith, 'NOSUPERUSER', [], 3);

    T4:=AddSQLTokens(stKeyword, TWith, 'CREATEDB', [], 4);
    T5:=AddSQLTokens(stKeyword, TWith, 'NOCREATEDB', [], 5);

    T6:=AddSQLTokens(stKeyword, TWith, 'CREATEUSER', [], 6);
    T7:=AddSQLTokens(stKeyword, TWith, 'NOCREATEUSER', [], 7);

    T8:=AddSQLTokens(stKeyword, TWith, 'CREATEROLE', [], 8);
    T9:=AddSQLTokens(stKeyword, TWith, 'NOCREATEROLE', [], 9);

    T10:=AddSQLTokens(stKeyword, TWith, 'INHERIT', [], 10);
    T11:=AddSQLTokens(stKeyword, TWith, 'NOINHERIT', [], 11);

    T12:=AddSQLTokens(stKeyword, TWith, 'LOGIN', [], 12);
    T13:=AddSQLTokens(stKeyword, TWith, 'NOLOGIN', [], 13);

    T14:=AddSQLTokens(stKeyword, TWith, 'REPLICATION', [], 14);
    T15:=AddSQLTokens(stKeyword, TWith, 'NOREPLICATION', [], 15);

    T16:=AddSQLTokens(stKeyword, TWith, 'BYPASSRLS', [], 16);
    T17:=AddSQLTokens(stKeyword, TWith, 'NOBYPASSRLS', [], 17);

  T1.AddChildToken([T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17]);
  T2.AddChildToken([T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17]);

  T4.AddChildToken([T1, T2, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17]);
  T5.AddChildToken([T1, T2, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17]);

  T6.AddChildToken([T1, T2, T4, T5, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17]);
  T7.AddChildToken([T1, T2, T4, T5, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17]);

  T8.AddChildToken([T1, T2, T4, T5, T5, T6, T10, T11, T12, T13, T14, T15, T16, T17]);
  T9.AddChildToken([T1, T2, T4, T5, T5, T6, T10, T11, T12, T13, T14, T15, T16, T17]);

  T10.AddChildToken([T1, T2, T4, T5, T6, T7, T8, T9, T12, T13, T14, T15, T16, T17]);
  T11.AddChildToken([T1, T2, T4, T5, T6, T7, T8, T9, T12, T13, T14, T15, T16, T17]);

  T12.AddChildToken([T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17]);
  T13.AddChildToken([T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17]);

  T14.AddChildToken([T1, T2, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T16, T17]);
  T15.AddChildToken([T1, T2, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T16, T17]);

  T16.AddChildToken([T1, T2, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15]);
  T17.AddChildToken([T1, T2, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15]);

(*

|  |
|  |
|  |
|  |
| CONNECTION LIMIT connlimit
| [ ENCRYPTED | UNENCRYPTED ] PASSWORD 'password'
| VALID UNTIL 'timestamp'
| IN ROLE role_name [, ...]
| IN GROUP role_name [, ...]
| ROLE role_name [, ...]
| ADMIN role_name [, ...]
| USER role_name [, ...]
| SYSID uid
*)
end;

procedure TPGSQLCreateUser.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    2:FUserOptions:=FUserOptions + [puoSuperuser];
    3:FUserOptions:=FUserOptions - [puoSuperuser];
    4:FUserOptions:=FUserOptions + [puoCreateDatabaseObjects];
    5:FUserOptions:=FUserOptions - [puoCreateDatabaseObjects];
    6:FUserOptions:=FUserOptions + [puoCreateUser];
    7:FUserOptions:=FUserOptions - [puoCreateUser];
    8:FUserOptions:=FUserOptions + [puoCreateRoles];
    9:FUserOptions:=FUserOptions - [puoCreateRoles];
    10:FUserOptions:=FUserOptions + [puoInheritedRight];
    11:FUserOptions:=FUserOptions - [puoInheritedRight];
    12:FUserOptions:=FUserOptions + [puoLoginEnabled];
    13:FUserOptions:=FUserOptions - [puoLoginEnabled];
    14:FUserOptions:=FUserOptions + [puoCreateReplications];
    15:FUserOptions:=FUserOptions - [puoCreateReplications];
    16:FUserOptions:=FUserOptions + [puoByPassRLS];
    17:FUserOptions:=FUserOptions - [puoByPassRLS];
  end;
end;

procedure TPGSQLCreateUser.MakeSQL;
var
  S: String;
  UO: TPGUserOption;
begin
  S:='CREATE USER ' + Name;

  for UO in TPGUserOption do
  begin
    if UO in FUserOptions then
      S:=S + ' ' + PGUserOptionStrEnabled[UO]
    else
      S:=S + ' ' + PGUserOptionStrDisables[UO];
  end;

(*  [ [ WITH ] option [ ... ] ]
end;

where option can be:

      SUPERUSER | NOSUPERUSER
    | CREATEDB | NOCREATEDB
    | CREATEROLE | NOCREATEROLE
    | CREATEUSER | NOCREATEUSER
    | INHERIT | NOINHERIT
    | LOGIN | NOLOGIN
    | REPLICATION | NOREPLICATION
    | CONNECTION LIMIT connlimit
    | [ ENCRYPTED | UNENCRYPTED ] PASSWORD 'password'
    | VALID UNTIL 'timestamp'
    | IN ROLE role_name [, ...]
    | IN GROUP role_name [, ...]
    | ROLE role_name [, ...]
    | ADMIN role_name [, ...]
    | USER role_name [, ...]
    | SYSID uid
*)
  AddSQLCommand(S);
  if Description <> '' then
    DescribeObjectEx(ObjectKind, Name, '', Description);
end;

constructor TPGSQLCreateUser.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FUserOptions:=FUserOptions + [puoLoginEnabled];
  FServerVersion:=pgVersion9_0;
end;

procedure TPGSQLCreateUser.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLCreateUser then
  begin
    UserMapingOperation:=TPGSQLCreateUser(ASource).UserMapingOperation;

  end;
  inherited Assign(ASource);
end;
*)
{ TPGSQLAlterUser }

procedure TPGSQLAlterUser.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для ALTER USER }
  (*
  ALTER USER name [ [ WITH ] option [ ... ] ]

  where option can be:

        SUPERUSER | NOSUPERUSER
      | CREATEDB | NOCREATEDB
      | CREATEROLE | NOCREATEROLE
      | CREATEUSER | NOCREATEUSER
      | INHERIT | NOINHERIT
      | LOGIN | NOLOGIN
      | REPLICATION | NOREPLICATION
      | CONNECTION LIMIT connlimit
      | [ ENCRYPTED | UNENCRYPTED ] PASSWORD 'password'
      | VALID UNTIL 'timestamp'

  ALTER USER name RENAME TO new_name

  ALTER USER name SET configuration_parameter { TO | = } { value | DEFAULT }
  ALTER USER name SET configuration_parameter FROM CURRENT
  ALTER USER name RESET configuration_parameter
  ALTER USER name RESET ALL
  *)
  (*
  ALTER USER MAPPING FOR { user_name | USER | CURRENT_USER | PUBLIC }
    SERVER server_name
    OPTIONS ( [ ADD | SET | DROP ] option ['value'] [, ... ] )
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'USER', [toFindWordLast]);
end;

procedure TPGSQLAlterUser.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TPGSQLAlterUser.MakeSQL;
var
  Result: String;
begin
  Result:='ALTER USER';
  AddSQLCommand(Result);
end;

procedure TPGSQLAlterUser.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLAlterUser then
  begin
    IsMapping:=TPGSQLAlterUser(ASource).IsMapping;
    UserName:=TPGSQLAlterUser(ASource).UserName;
    ServerName:=TPGSQLAlterUser(ASource).ServerName;
    UserMapingOperation:=TPGSQLAlterUser(ASource).UserMapingOperation;

  end;
  inherited Assign(ASource);
end;

{ TPGSQLDropOperator }

procedure TPGSQLDropOperator.InitParserTree;
var
  T, T2, T3, T1, T10, FSQLTokens: TSQLTokenRecord;
begin
  (*
  DROP OPERATOR [ IF EXISTS ] name ( { left_type | NONE } , { right_type | NONE } ) [ CASCADE | RESTRICT ]
  *)
  (*
  DROP OPERATOR CLASS [ IF EXISTS ] name USING index_method [ CASCADE | RESTRICT ]
  *)
  (*
  DROP OPERATOR FAMILY [ IF EXISTS ] name USING index_method [ CASCADE | RESTRICT ]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  T10:=AddSQLTokens(stKeyword, FSQLTokens, 'OPERATOR', [toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, T10, 'IF', [], -1);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);

    T:=AddSQLTokens(stSymbol, T10, '(', []);


  T2:=AddSQLTokens(stKeyword, T10, 'CLASS', [],  1);
    T1:=AddSQLTokens(stKeyword, T2, 'IF', [], -1);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);

  T3:=AddSQLTokens(stKeyword, T10, 'FAMILY', [],  2);
    T1:=AddSQLTokens(stKeyword, T3, 'IF', [], -1);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);

  { TODO : Реализовать оператор DROP OPERATOR  }
end;

procedure TPGSQLDropOperator.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FOperatorType:=dotClass;
    2:FOperatorType:=dotFamily;
  end;
end;

constructor TPGSQLDropOperator.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FOperatorType:=dotSimple;
end;

procedure TPGSQLDropOperator.MakeSQL;
var
  Result: String;
begin
  Result:='DROP OPERATOR';
  AddSQLCommand(Result);
end;

procedure TPGSQLDropOperator.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLDropOperator then
  begin
    OperatorType:=TPGSQLDropOperator(ASource).OperatorType;
    LeftType:=TPGSQLDropOperator(ASource).LeftType;
    RightType:=TPGSQLDropOperator(ASource).RightType;

  end;
  inherited Assign(ASource);
end;

{ TPGSQLCreateOperator }

procedure TPGSQLCreateOperator.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для CREATE OPERATOR }
  (*
  CREATE OPERATOR name (
    PROCEDURE = function_name
    [, LEFTARG = left_type ] [, RIGHTARG = right_type ]
    [, COMMUTATOR = com_op ] [, NEGATOR = neg_op ]
    [, RESTRICT = res_proc ] [, JOIN = join_proc ]
    [, HASHES ] [, MERGES ]
)
  *)
  (*
  CREATE OPERATOR CLASS name [ DEFAULT ] FOR TYPE data_type
  USING index_method [ FAMILY family_name ] AS
  {  OPERATOR strategy_number operator_name [ ( op_type, op_type ) ] [ FOR SEARCH | FOR ORDER BY sort_family_name ]
   | FUNCTION support_number [ ( op_type [ , op_type ] ) ] function_name ( argument_type [, ...] )
   | STORAGE storage_type
  } [, ... ]
  *)
  (*
  CREATE OPERATOR FAMILY name USING index_method
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'OPERATOR', [toFindWordLast]);
end;

procedure TPGSQLCreateOperator.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

constructor TPGSQLCreateOperator.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FOperatorType:=dotSimple;
end;

procedure TPGSQLCreateOperator.MakeSQL;
var
  Result: String;
begin
  Result:='CREATE OPERATOR';
  AddSQLCommand(Result);
end;

procedure TPGSQLCreateOperator.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLCreateOperator then
  begin
    OperatorType:=TPGSQLCreateOperator(ASource).OperatorType;

  end;
  inherited Assign(ASource);
end;

{ TPGSQLAlterOperator }

procedure TPGSQLAlterOperator.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для ALTER OPERATOR }
  (*
  ALTER OPERATOR FAMILY name USING index_method ADD
    {  OPERATOR strategy_number operator_name ( op_type, op_type ) [ FOR SEARCH | FOR ORDER BY sort_family_name ]
     | FUNCTION support_number [ ( op_type [ , op_type ] ) ] function_name ( argument_type [, ...] )
    } [, ... ]
  ALTER OPERATOR FAMILY name USING index_method DROP
    {  OPERATOR strategy_number ( op_type [ , op_type ] )
     | FUNCTION support_number ( op_type [ , op_type ] )
    } [, ... ]
  ALTER OPERATOR FAMILY name USING index_method RENAME TO new_name
  ALTER OPERATOR FAMILY name USING index_method OWNER TO new_owner
  ALTER OPERATOR FAMILY name USING index_method SET SCHEMA new_schema
  *)
  (*
  ALTER OPERATOR CLASS name USING index_method RENAME TO new_name
  ALTER OPERATOR CLASS name USING index_method OWNER TO new_owner
  ALTER OPERATOR CLASS name USING index_method SET SCHEMA new_schema
  *)
  (*
  ALTER OPERATOR name ( { left_type | NONE } , { right_type | NONE } ) OWNER TO new_owner
  ALTER OPERATOR name ( { left_type | NONE } , { right_type | NONE } ) SET SCHEMA new_schema
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'OPERATOR', [toFindWordLast]);
end;

procedure TPGSQLAlterOperator.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

constructor TPGSQLAlterOperator.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FOperatorType:=dotSimple;
end;

procedure TPGSQLAlterOperator.MakeSQL;
var
  Result: String;
begin
  Result:='ALTER OPERATOR';
  AddSQLCommand(Result);
end;

procedure TPGSQLAlterOperator.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLAlterOperator then
  begin
    OperatorType:=TPGSQLAlterOperator(ASource).OperatorType;

  end;
  inherited Assign(ASource);
end;

{ TPGSQLDropDatabase }

procedure TPGSQLDropDatabase.InitParserTree;
var
  T, T1, FSQLTokens: TSQLTokenRecord;
begin
  (* DROP DATABASE [ IF EXISTS ] name *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'DATABASE', [toFindWordLast]);
  T1:=AddSQLTokens(stKeyword, T, 'IF', [], -1);
  T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);
  T:=AddSQLTokens(stIdentificator, T, '', [],  1);
  T1.AddChildToken(T);
end;

procedure TPGSQLDropDatabase.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  if AChild.Tag = 1 then
    FDatabaseName:=AWord;
end;

procedure TPGSQLDropDatabase.MakeSQL;
var
  Result: String;
begin
  Result:='DROP DATABASE';
  if ooIfExists in Options then
    Result:=Result + ' IF EXISTS';

  Result:=Result + ' ' + FDatabaseName;
  AddSQLCommand(Result);
end;

procedure TPGSQLDropDatabase.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLDropDatabase then
  begin
    DatabaseName:=TPGSQLDropDatabase(ASource).DatabaseName;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLCreateDatabase }

procedure TPGSQLCreateDatabase.InitParserTree;
var
  T, FSQLTokens, TN, TW, T2_1, T2, T3, T3_1, T4, T4_1: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для CREATE DATABASE }
  (*
  CREATE DATABASE name
      [ [ WITH ] [ OWNER [=] user_name ]
             [ TEMPLATE [=] template ]
             [ ENCODING [=] encoding ]
             [ LC_COLLATE [=] lc_collate ]
             [ LC_CTYPE [=] lc_ctype ]
             [ TABLESPACE [=] tablespace ]
             [ CONNECTION LIMIT [=] connlimit ] ]
*)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'DATABASE', [toFindWordLast]);
  TN:=AddSQLTokens(stIdentificator, T, '', [],  1);
  TW:=AddSQLTokens(stKeyword, TN, 'WITH', []);

  T2:=AddSQLTokens(stKeyword, TN, 'OWNER', [],  2);
  T:=AddSQLTokens(stSymbol, T2, '=', []);
  T2_1:=AddSQLTokens(stIdentificator, T2, '', [], 3);
  T.AddChildToken(T2_1);

  T3:=AddSQLTokens(stKeyword, TN, 'TEMPLATE', [],2);
  T:=AddSQLTokens(stSymbol, T3, '=', []);
  T3_1:=AddSQLTokens(stIdentificator, T3, '', [], 3);
  T.AddChildToken(T3_1);

  T4:=AddSQLTokens(stKeyword, TN, 'ENCODING', [], 2);
  T:=AddSQLTokens(stSymbol, T4, '=', []);
  T4_1:=AddSQLTokens(stString, T3, '', [], 3);
  T.AddChildToken(T4_1);

  TW.CopyChildTokens(TN);
  T2_1.AddChildToken([{T2, } T3, T4]);
  T3_1.AddChildToken([T2, { T3,} T4]);
  T4_1.AddChildToken([T2,  T3{, T4}]);
end;

procedure TPGSQLCreateDatabase.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:DatabaseName:=AWord;
    2:FCurParam:=Params.AddParam(AWord);
    3:if Assigned(FCurParam) then
      begin
        FCurParam.RealName:=AWord;
        FCurParam:=nil;
      end;
  end;
end;

procedure TPGSQLCreateDatabase.MakeSQL;
var
  S: String;
  P: TSQLParserField;
begin
  S:='CREATE DATABASE ' + DatabaseName;
  for P in Params do
    S:=S + LineEnding + ' ' + P.Caption + ' = '+P.RealName;
  AddSQLCommand(S);
end;

procedure TPGSQLCreateDatabase.Assign(ASource: TSQLObjectAbstract);
begin
  inherited Assign(ASource);
end;

{ TPGSQLAlterDatabase }

procedure TPGSQLAlterDatabase.InitParserTree;
var
  T, FSQLTokens, DN, T0, TS, T1, T2, T3, TR: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для ALTER DATABASE }
  (*
  ALTER DATABASE name [ [ WITH ] option [ ... ] ]

  where option can be:

      CONNECTION LIMIT connlimit

  ALTER DATABASE name RENAME TO new_name

  ALTER DATABASE name OWNER TO new_owner

  ALTER DATABASE name SET TABLESPACE new_tablespace

  ALTER DATABASE name SET configuration_parameter { TO | = } { value | DEFAULT }
  ALTER DATABASE name SET configuration_parameter FROM CURRENT
  ALTER DATABASE name RESET configuration_parameter
  ALTER DATABASE name RESET ALL
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'DATABASE', [toFindWordLast]);
  DN:=AddSQLTokens(stIdentificator, T, '', [], 1);

  T:=AddSQLTokens(stKeyword, DN, 'WITH', []);
  T:=AddSQLTokens(stKeyword, T, 'CONNECTION', []);
  T:=AddSQLTokens(stKeyword, T, 'LIMIT', []);
  T0:=AddSQLTokens(stSymbol, T, '=', []);
  T:=AddSQLTokens(stInteger, T, '', [], 2);
  T0.AddChildToken(T);

  T:=AddSQLTokens(stKeyword, DN, 'RENAME', []);
  T:=AddSQLTokens(stKeyword, T, 'TO', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 3);

  T:=AddSQLTokens(stKeyword, DN, 'OWNER', []);
  T:=AddSQLTokens(stKeyword, T, 'TO', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 4);

  TS:=AddSQLTokens(stKeyword, DN, 'SET', [], 10);
  T:=AddSQLTokens(stKeyword, TS, 'TABLESPACE', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 5);

  T:=AddSQLTokens(stIdentificator, TS, '', [], 6);
  T1:=AddSQLTokens(stKeyword, T, 'TO', []);
  T2:=AddSQLTokens(stSymbol, T, '=', []);
  T3:=AddSQLTokens(stString, T1, '', [], 7);
  T2.AddChildToken(T3);
  T3:=AddSQLTokens(stKeyword, T1, 'DEFAULT', [], 8);
  T2.AddChildToken(T3);

  T1:=AddSQLTokens(stKeyword, T, 'FROM', []);
  T1:=AddSQLTokens(stKeyword, T1, 'CURRENT', [], 9);

  TR:=AddSQLTokens(stKeyword, DN, 'RESET', [], 11);
  T:=AddSQLTokens(stKeyword, TR, 'ALL', [], 12);
  T:=AddSQLTokens(stIdentificator, TR, '', [], 13);
end;

procedure TPGSQLAlterDatabase.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FDatabaseName:=AWord;
    2:FConnectionLimit:=StrToIntDef(AWord, 0);
    3:FDatabaseNewName:=AWord;
    4:FDatabaseNewOwner:=AWord;
    5:FDatabaseNewTablespace:=AWord;
    6, 13:FCurPar:=Params.AddParam(AWord);
    7, 8, 9:if Assigned(FCurPar) then
        FCurPar.RealName:=AWord;
    10:FAlterType:=aoSet;
    11:FAlterType:=aoReset;
    12:FResetAll:=true;
  end;
end;

procedure TPGSQLAlterDatabase.MakeSQL;
var
  Result: String;
begin
  Result:='ALTER DATABASE ' +FDatabaseName;

  if FConnectionLimit <> 0 then
    Result:=Result + ' CONNECTION LIMIT = '+IntToStr(FConnectionLimit)
  else
  if FDatabaseNewName <> '' then
    Result:=Result + ' RENAME TO '+FDatabaseNewName
  else
  if FDatabaseNewOwner <> '' then
    Result:=Result + ' OWNER TO '+FDatabaseNewOwner
  else
  if FDatabaseNewTablespace <> '' then
    Result:=Result + ' SET TABLESPACE '+FDatabaseNewTablespace
  else
  if FAlterType = aoSet then
  begin
    if Params.Count>0 then
      if UpperCase(Params[0].RealName)<> 'CURRENT' then
      Result:=Result + ' SET '+Params[0].Caption + ' = '+Params[0].RealName
    else
      Result:=Result + ' SET '+Params[0].Caption + ' FROM CURRENT';
  end
  else
  if FAlterType = aoReset then
  begin
    if FResetAll then
      Result:=Result + ' RESET ALL'
    else
    if Params.Count>0 then
      Result:=Result + ' RESET '+Params[0].Caption;
  end;

  AddSQLCommand(Result);
end;

procedure TPGSQLAlterDatabase.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLAlterDatabase then
  begin
    AlterType:=TPGSQLAlterDatabase(ASource).AlterType;
    DatabaseName:=TPGSQLAlterDatabase(ASource).DatabaseName;
    ConnectionLimit:=TPGSQLAlterDatabase(ASource).ConnectionLimit;
    DatabaseNewName:=TPGSQLAlterDatabase(ASource).DatabaseNewName;
    DatabaseNewOwner:=TPGSQLAlterDatabase(ASource).DatabaseNewOwner;
    DatabaseNewTablespace:=TPGSQLAlterDatabase(ASource).DatabaseNewTablespace;
    ResetAll:=TPGSQLAlterDatabase(ASource).ResetAll;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLAlterConversion }

procedure TPGSQLAlterConversion.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для ALTER CONVERSION }
  (*
ALTER CONVERSION name RENAME TO new_name
ALTER CONVERSION name OWNER TO new_owner
ALTER CONVERSION name SET SCHEMA new_schema
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'CONVERSION', [toFindWordLast]);
end;

procedure TPGSQLAlterConversion.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TPGSQLAlterConversion.MakeSQL;
var
  Result: String;
begin
  Result:='ALTER CONVERSION name ';
  AddSQLCommand(Result);
end;

{ TPGSQLCreateConversion }

procedure TPGSQLCreateConversion.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для CREATE CONVERSION }
  (*
  CREATE [ DEFAULT ] CONVERSION name
    FOR source_encoding TO dest_encoding FROM function_name
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'CONVERSION', [toFindWordLast]);
end;

procedure TPGSQLCreateConversion.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TPGSQLCreateConversion.MakeSQL;
var
  Result: String;
begin
  Result:='CREATE [ DEFAULT ] CONVERSION name';
  AddSQLCommand(Result);
end;

{ TPGSQLDropConversion }

procedure TPGSQLDropConversion.InitParserTree;
var
  T, T1, FSQLTokens: TSQLTokenRecord;
begin
  (*
  DROP CONVERSION [ IF EXISTS ] name [ CASCADE | RESTRICT ]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'CONVERSION', [toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, T, 'IF', [], -1);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
  T1:=AddSQLTokens(stKeyword, T, 'CASCADE', [], -2);
  T1:=AddSQLTokens(stKeyword, T, 'RESTRICT', [], -3);
end;

procedure TPGSQLDropConversion.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
  end;
end;

procedure TPGSQLDropConversion.MakeSQL;
var
  Result: String;
begin
  Result:='DROP CONVERSION ';
  if ooIfExists in Options then
    Result:=Result + ' IF EXISTS ';

  Result:=Result + Name;

  if DropRule = drCascade then
    Result:=Result + ' CASCADE'
  else
  if DropRule = drRestrict then
    Result:=Result + ' RESTRICT';
  AddSQLCommand(Result);
end;

{ TPGSQLDropCollation }

procedure TPGSQLDropCollation.InitParserTree;
var
  T, T1, FSQLTokens: TSQLTokenRecord;
begin
  (* DROP COLLATION [ IF EXISTS ] name [ CASCADE | RESTRICT *)

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'COLLATION', [toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, T, 'IF', [], -1);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
  T1:=AddSQLTokens(stKeyword, T, 'CASCADE', [], -2);
  T1:=AddSQLTokens(stKeyword, T, 'RESTRICT', [], -3);
end;

procedure TPGSQLDropCollation.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  if AChild.Tag = 1 then
    FCollationName:=AWord;
end;

procedure TPGSQLDropCollation.MakeSQL;
var
  Result: String;
begin
  Result:='DROP COLLATION';
  if ooIfExists in Options then
    Result:=Result + ' IF EXISTS';

  Result:=Result + FCollationName;

  if DropRule = drCascade then
    Result:=Result + ' CASCADE'
  else
  if DropRule = drRestrict then
    Result:=Result + ' RESTRICT';
  AddSQLCommand(Result);
end;

procedure TPGSQLDropCollation.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLDropCollation then
  begin
    CollationName:=TPGSQLDropCollation(ASource).CollationName;

  end;
  inherited Assign(ASource);
end;

{ TPGSQLAlterCollation }

procedure TPGSQLAlterCollation.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для ALTER COLLATION }
  (*
  ALTER COLLATION name RENAME TO new_name
  ALTER COLLATION name OWNER TO new_owner
  ALTER COLLATION name SET SCHEMA new_schema
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'COLLATION', [toFindWordLast]);
end;

procedure TPGSQLAlterCollation.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TPGSQLAlterCollation.MakeSQL;
var
  Result: String;
begin
  Result:='ALTER COLLATION';
  AddSQLCommand(Result);
end;

{ TPGSQLCreateCollation }

procedure TPGSQLCreateCollation.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для CREATE COLLATION }
  (*
  CREATE COLLATION name (
      [ LOCALE = locale, ]
      [ LC_COLLATE = lc_collate, ]
      [ LC_CTYPE = lc_ctype ]
  )
  CREATE COLLATION name FROM existing_collation
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'COLLATION', [toFindWordLast]);
end;

procedure TPGSQLCreateCollation.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TPGSQLCreateCollation.MakeSQL;
var
  Result: String;
begin
  Result:='CREATE COLLATION';
  AddSQLCommand(Result);
end;

{ TPGSQLCreateCast }

procedure TPGSQLCreateCast.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для CREATE CAST }
  (*
  CREATE CAST (source_type AS target_type)
      WITH FUNCTION function_name (argument_type [, ...])
      [ AS ASSIGNMENT | AS IMPLICIT ]

  CREATE CAST (source_type AS target_type)
      WITHOUT FUNCTION
      [ AS ASSIGNMENT | AS IMPLICIT ]

  CREATE CAST (source_type AS target_type)
      WITH INOUT
      [ AS ASSIGNMENT | AS IMPLICIT ]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'CAST', [toFindWordLast]);
  { TODO : Реализовать парсер CREATE CAST }
end;

procedure TPGSQLCreateCast.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TPGSQLCreateCast.MakeSQL;
var
  Result: String;
begin
  Result:='CREATE CAST';
  AddSQLCommand(Result);
end;

procedure TPGSQLCreateCast.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLCreateCast then
  begin
    SourceType:=TPGSQLCreateCast(ASource).SourceType;
    TargetType:=TPGSQLCreateCast(ASource).TargetType;

  end;
  inherited Assign(ASource);
end;

{ TPGSQLDropCast }

procedure TPGSQLDropCast.InitParserTree;
var
  T, T1, FSQLTokens: TSQLTokenRecord;
begin
  (* DROP CAST [ IF EXISTS ] (source_type AS target_type) [ CASCADE | RESTRICT ] *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'CAST', [toFindWordLast]);
  T1:=AddSQLTokens(stKeyword, T, 'IF', [], -1);
  T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);
  T:=AddSQLTokens(stSymbol, T, '(', []);
  T1.AddChildToken(T);
  T:=AddSQLTokens(stIdentificator, T, '', [],  1);
  T:=AddSQLTokens(stKeyword, T, 'AS', []);
  T:=AddSQLTokens(stIdentificator, T, '', [],  2);
  T:=AddSQLTokens(stSymbol, T, ')', []);
  T1:=AddSQLTokens(stKeyword, T, 'CASCADE', [], -2);
  T1:=AddSQLTokens(stKeyword, T, 'RESTRICT', [], -3);
end;

procedure TPGSQLDropCast.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FSourceType:=AWord;
    2:FTargetType:=AWord;
  end;
end;

procedure TPGSQLDropCast.MakeSQL;
var
  Result: String;
begin
  Result:='DROP CAST';

  if ooIfExists in Options then
    Result := Result +' IF EXISTS';

  Result := Result + ' (' + FSourceType + ' AS '+FTargetType + ')';
  if DropRule = drCascade then
    Result:=Result + ' CASCADE'
  else
  if DropRule = drRestrict then
    Result:=Result + ' RESTRICT';
  AddSQLCommand(Result);
end;

procedure TPGSQLDropCast.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLDropCast then
  begin
    SourceType:=TPGSQLDropCast(ASource).SourceType;
    TargetType:=TPGSQLDropCast(ASource).TargetType;

  end;
  inherited Assign(ASource);
end;

{ TPGSQLCreateAggregate }

procedure TPGSQLCreateAggregate.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для CREATE AGGREGATE }
  (*
  CREATE AGGREGATE name ( input_data_type [ , ... ] ) (
    SFUNC = sfunc,
    STYPE = state_data_type
    [ , FINALFUNC = ffunc ]
    [ , INITCOND = initial_condition ]
    [ , SORTOP = sort_operator ]
)

or the old syntax

CREATE AGGREGATE name (
    BASETYPE = base_type,
    SFUNC = sfunc,
    STYPE = state_data_type
    [ , FINALFUNC = ffunc ]
    [ , INITCOND = initial_condition ]
    [ , SORTOP = sort_operator ]
)
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'AGGREGATE', [toFindWordLast]);
end;

procedure TPGSQLCreateAggregate.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TPGSQLCreateAggregate.MakeSQL;
var
  Result: String;
begin
  Result:='CREATE AGGREGATE';
  AddSQLCommand(Result);
end;

{ TPGSQLDropAggregate }

procedure TPGSQLDropAggregate.InitParserTree;
var
  T, T1, FSQLTokens: TSQLTokenRecord;
begin
  (* DROP AGGREGATE [ IF EXISTS ] name ( type [ , ... ] ) [ CASCADE | RESTRICT ] *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'AGGREGATE', [toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, T, 'IF', [], -1);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);
  T:=AddSQLTokens(stIdentificator, T, '', [],  1);
  T:=AddSQLTokens(stSymbol, T, '(', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 2);
    T1:=AddSQLTokens(stSymbol, T, ',', []);
    T1.AddChildToken(T);
  T:=AddSQLTokens(stSymbol, T, ')', []);
  T1:=AddSQLTokens(stKeyword, T, 'CASCADE', [], -2);
  T1:=AddSQLTokens(stKeyword, T, 'RESTRICT', [], -3);
end;

procedure TPGSQLDropAggregate.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FAggregateName:=AWord;
    2:Params.AddParam(AWord);
  end;
end;

procedure TPGSQLDropAggregate.MakeSQL;
var
  i: Integer;
  Result: String;
begin
  Result:='DROP AGGREGATE';
  if ooIfExists in Options then
    Result := Result +' IF EXISTS';

  Result := Result + ' ' + FAggregateName + ' (' + Params.AsString + ')';

  if DropRule = drCascade then
    Result:=Result + ' CASCADE'
  else
  if DropRule = drRestrict then
    Result:=Result + ' RESTRICT';
  AddSQLCommand(Result);
end;

procedure TPGSQLDropAggregate.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLDropAggregate then
  begin
    AggregateName:=TPGSQLDropAggregate(ASource).AggregateName;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLAlterAggregate }

procedure TPGSQLAlterAggregate.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для ALTER AGGREGATE}
  (*
  ALTER AGGREGATE name ( type [ , ... ] ) RENAME TO new_name
  ALTER AGGREGATE name ( type [ , ... ] ) OWNER TO new_owner
  ALTER AGGREGATE name ( type [ , ... ] ) SET SCHEMA new_schema
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'AGGREGATE', [toFindWordLast]);
end;

procedure TPGSQLAlterAggregate.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TPGSQLAlterAggregate.MakeSQL;
var
  Result: String;
begin
  Result:='ALTER AGGREGATE';
  AddSQLCommand(Result);
end;

{ TPGSQLRevoke }

procedure TPGSQLRevoke.InitParserTree;
var
  FSQLTokens, TOpt, TOp2, TOp3, TOp4, TOp6, TOp7, TOp8, TOp9,
    TOp91, TOp5, TOn, TObjKind, TTblName, TSymb, TFrom,
    TTblAll, TFromGrp, TUsrGrp, TCasc, TRestr, TTblSchema,
    TSymb2, TTblCol, TTblAll1, TOp10, TSeqSchema, TSeqName,
    TSeqAll, TObjSchema, TOp11, TFuncName, TOpExec, TOnF,
    TFuncSchema, TSymb1, TOpt1: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для REVOKE }
  (*
+  REVOKE [ GRANT OPTION FOR ]
+      { { SELECT | INSERT | UPDATE | DELETE | TRUNCATE | REFERENCES | TRIGGER }
+      [, ...] | ALL [ PRIVILEGES ] }
+      ON { [ TABLE ] table_name [, ...]
+           | ALL TABLES IN SCHEMA schema_name [, ...] }
+      FROM { [ GROUP ] role_name | PUBLIC } [, ...]
++      [ CASCADE | RESTRICT ]

+  REVOKE [ GRANT OPTION FOR ]
+      { { SELECT | INSERT | UPDATE | REFERENCES } ( column [, ...] )
+      [, ...] | ALL [ PRIVILEGES ] ( column [, ...] ) }
+      ON [ TABLE ] table_name [, ...]
+      FROM { [ GROUP ] role_name | PUBLIC } [, ...]
+      [ CASCADE | RESTRICT ]

+  REVOKE [ GRANT OPTION FOR ]
+      { { USAGE | SELECT | UPDATE }
+      [, ...] | ALL [ PRIVILEGES ] }
+      ON { SEQUENCE sequence_name [, ...]
+           | ALL SEQUENCES IN SCHEMA schema_name [, ...] }
+      FROM { [ GROUP ] role_name | PUBLIC } [, ...]
+      [ CASCADE | RESTRICT ]

  REVOKE [ GRANT OPTION FOR ]
      { { CREATE | CONNECT | TEMPORARY | TEMP } [, ...] | ALL [ PRIVILEGES ] }
      ON DATABASE database_name [, ...]
      FROM { [ GROUP ] role_name | PUBLIC } [, ...]
      [ CASCADE | RESTRICT ]

  REVOKE [ GRANT OPTION FOR ]
      { USAGE | ALL [ PRIVILEGES ] }
      ON FOREIGN DATA WRAPPER fdw_name [, ...]
      FROM { [ GROUP ] role_name | PUBLIC } [, ...]
      [ CASCADE | RESTRICT ]

  REVOKE [ GRANT OPTION FOR ]
      { USAGE | ALL [ PRIVILEGES ] }
      ON FOREIGN SERVER server_name [, ...]
      FROM { [ GROUP ] role_name | PUBLIC } [, ...]
      [ CASCADE | RESTRICT ]

  REVOKE [ GRANT OPTION FOR ]
      { EXECUTE | ALL [ PRIVILEGES ] }
      ON { FUNCTION function_name ( [ [ argmode ] [ arg_name ] arg_type [, ...] ] ) [, ...]
           | ALL FUNCTIONS IN SCHEMA schema_name [, ...] }
      FROM { [ GROUP ] role_name | PUBLIC } [, ...]
      [ CASCADE | RESTRICT ]

  REVOKE [ GRANT OPTION FOR ]
      { USAGE | ALL [ PRIVILEGES ] }
      ON LANGUAGE lang_name [, ...]
      FROM { [ GROUP ] role_name | PUBLIC } [, ...]
      [ CASCADE | RESTRICT ]

  REVOKE [ GRANT OPTION FOR ]
      { { SELECT | UPDATE } [, ...] | ALL [ PRIVILEGES ] }
      ON LARGE OBJECT loid [, ...]
      FROM { [ GROUP ] role_name | PUBLIC } [, ...]
      [ CASCADE | RESTRICT ]

+  REVOKE [ GRANT OPTION FOR ]
+      { { CREATE | USAGE } [, ...] | ALL [ PRIVILEGES ] }
+      ON SCHEMA schema_name [, ...]
+      FROM { [ GROUP ] role_name | PUBLIC } [, ...]
+      [ CASCADE | RESTRICT ]

  REVOKE [ GRANT OPTION FOR ]
      { CREATE | ALL [ PRIVILEGES ] }
      ON TABLESPACE tablespace_name [, ...]
      FROM { [ GROUP ] role_name | PUBLIC } [, ...]
      [ CASCADE | RESTRICT ]

  REVOKE [ ADMIN OPTION FOR ]
      role_name [, ...] FROM role_name [, ...]
      [ CASCADE | RESTRICT ]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'REVOKE', [toFindWordLast, toFirstToken]);
    TOpt1:=AddSQLTokens(stKeyword, FSQLTokens, 'ADMIN', [], 50);
    TOpt:=AddSQLTokens(stKeyword, FSQLTokens, 'GRANT', [], 1);
    TOpt:=AddSQLTokens(stKeyword, [TOpt, TOpt1], 'OPTION', []);
    TOpt:=AddSQLTokens(stKeyword, TOpt, 'FOR', []);

  TOp2:=AddSQLTokens(stKeyword, [FSQLTokens, TOpt], 'SELECT', [], 2);
  TOp3:=AddSQLTokens(stKeyword, [FSQLTokens, TOpt], 'INSERT', [], 3);
  TOp4:=AddSQLTokens(stKeyword, [FSQLTokens, TOpt], 'UPDATE', [], 4);
  TOp5:=AddSQLTokens(stKeyword, [FSQLTokens, TOpt], 'DELETE', [], 5);
  TOp6:=AddSQLTokens(stKeyword, [FSQLTokens, TOpt], 'TRUNCATE', [], 6);
  TOp7:=AddSQLTokens(stKeyword, [FSQLTokens, TOpt], 'REFERENCES', [], 7);
  TOp8:=AddSQLTokens(stKeyword, [FSQLTokens, TOpt], 'TRIGGER', [], 8);
  TOp10:=AddSQLTokens(stKeyword, [FSQLTokens, TOpt], 'USAGE', [], 19);
  TOp11:=AddSQLTokens(stKeyword, [FSQLTokens, TOpt], 'CREATE', [], 23);

    TSymb:=AddSQLTokens(stSymbol, [TOp2, TOp3, TOp4, TOp5, TOp6, TOp7, TOp8, TOp10, TOp11], ',', []);
    TSymb.AddChildToken([TOp2, TOp3, TOp4, TOp5, TOp6, TOp7, TOp8, TOp10, TOp11]);

  TOp9:=AddSQLTokens(stKeyword, [FSQLTokens, TOpt], 'ALL', [], 9);
    TOp91:=AddSQLTokens(stKeyword, TOp9, 'PRIVILEGES', [toOptional]);
//table
  TSymb2:=AddSQLTokens(stSymbol, [TOp2, TOp3, TOp4, TOp7, TOp9, TOp91], '(', []);
  TTblCol:=AddSQLTokens(stIdentificator, TSymb2, '', [], 18);
    TSymb2:=AddSQLTokens(stSymbol, TTblCol, ',', []);
    TSymb2.AddChildToken(TTblCol);
  TSymb2:=AddSQLTokens(stSymbol, TTblCol, ')', []);
    TSymb2.AddChildToken(TSymb);

  TOn:=AddSQLTokens(stKeyword, [TOp2, TOp3, TOp4, TOp5, TOp6, TOp7, TOp8, TOp9, TOp91, TSymb2], 'ON', []);
    TObjKind:=AddSQLTokens(stKeyword, TOn, 'TABLE', [], 10);
      TTblSchema:=AddSQLTokens(stIdentificator, [TOn, TObjKind, TOpt], '', [], 11);
      TSymb:=AddSQLTokens(stSymbol, TTblSchema, '.', []);
      TTblName:=AddSQLTokens(stIdentificator, TSymb, '', [], 17);
      TSymb:=AddSQLTokens(stSymbol, [TTblSchema, TTblName], ',', []);
      TSymb.AddChildToken(TTblSchema);

    TTblAll1:=AddSQLTokens(stKeyword, TOn, 'ALL', []);
    TTblAll:=AddSQLTokens(stKeyword, TTblAll1, 'TABLES', []);
    TTblAll:=AddSQLTokens(stKeyword, TTblAll, 'IN', []);
    TTblAll:=AddSQLTokens(stKeyword, TTblAll, 'SCHEMA', []);
    TTblAll:=AddSQLTokens(stIdentificator, TTblAll, '', [], 12);
    TSymb:=AddSQLTokens(stSymbol, TTblAll, ',', []);
    TSymb.AddChildToken(TTblAll);

//SEQUENCE
  TObjKind:=AddSQLTokens(stKeyword, TOn, 'SEQUENCE', []);
    TSeqSchema:=AddSQLTokens(stIdentificator, TObjKind, '', [], 20);
    TSymb:=AddSQLTokens(stSymbol, TSeqSchema, '.', []);
    TSeqName:=AddSQLTokens(stIdentificator, TSymb, '', [], 21);
    TSymb:=AddSQLTokens(stSymbol, [TSeqSchema, TSeqName], ',', []);
    TSymb.AddChildToken(TSeqSchema);

  TSeqAll:=AddSQLTokens(stKeyword, TTblAll1, 'SEQUENCES', []);
  TSeqAll:=AddSQLTokens(stKeyword, TSeqAll, 'IN', []);
  TSeqAll:=AddSQLTokens(stKeyword, TSeqAll, 'SCHEMA', []);
  TSeqAll:=AddSQLTokens(stIdentificator, TSeqAll, '', [], 22);
  TSymb:=AddSQLTokens(stSymbol, TSeqAll, ',', []);
  TSymb.AddChildToken(TSeqAll);

//SCHEMA
  TObjKind:=AddSQLTokens(stKeyword, TOn, 'SCHEMA', []);
    TObjSchema:=AddSQLTokens(stIdentificator, TObjKind, '', [], 24);
    TSymb:=AddSQLTokens(stSymbol, TObjSchema, ',', []);
    TSymb.AddChildToken(TObjSchema);

//FUNCTION
(*
REVOKE [ GRANT OPTION FOR ]
    { EXECUTE | ALL [ PRIVILEGES ] }
    ON { FUNCTION function_name ( [ [ argmode ] [ arg_name ] arg_type [, ...] ] ) [, ...]
         | ALL FUNCTIONS IN SCHEMA schema_name [, ...] }
    FROM { [ GROUP ] role_name | PUBLIC } [, ...]
    [ CASCADE | RESTRICT ]
*)
  TOpExec:=AddSQLTokens(stKeyword, [FSQLTokens, TOpt], 'EXECUTE', [], 30);
    TOnF:=AddSQLTokens(stKeyword, [TOpExec], 'ON', []);
    TOnF:=AddSQLTokens(stKeyword, [TOnF, TOn], 'FUNCTION', []);
    TFuncSchema:=AddSQLTokens(stIdentificator, TOnF, '', [], 31);
    TSymb:=AddSQLTokens(stSymbol, TTblSchema, '.', []);
    TFuncName:=AddSQLTokens(stIdentificator, TSymb, '', [], 32);

    TSymb:=AddSQLTokens(stSymbol, [TFuncSchema, TFuncName], '(', []);

    TSymb1:=AddSQLTokens(stSymbol, TSymb, ')', [], 33);
    CreateInParamsTree(Self, TSymb, TSymb1);

    TSymb:=AddSQLTokens(stSymbol, TSymb1, ',', [], 34);
      TSymb.AddChildToken(TFuncSchema);


(*
    REVOKE [ GRANT OPTION FOR ]
        { EXECUTE | ALL [ PRIVILEGES ] }
        ON { FUNCTION function_name ( [ [ argmode ] [ arg_name ] arg_type [, ...] ] ) [, ...]
             | ALL FUNCTIONS IN SCHEMA schema_name [, ...] }
        FROM { [ GROUP ] role_name | PUBLIC } [, ...]
        [ CASCADE | RESTRICT ]
*)

//role_name
(*
REVOKE [ ADMIN OPTION FOR ]
    role_name [, ...] FROM role_name [, ...]
    [ CASCADE | RESTRICT ]
  TOpt:=AddSQLTokens(stKeyword, FSQLTokens, 'ADMIN', [], 1);
    TOpt:=AddSQLTokens(stKeyword, TOpt, 'OPTION', []);
    TOpt:=AddSQLTokens(stKeyword, TOpt, 'FOR', []);
    *)

//---
  TFrom:=AddSQLTokens(stKeyword, [TTblSchema, TTblName, TTblAll, TSeqSchema, TSeqName, TSeqAll, TObjSchema, TSymb1], 'FROM', []);
    TFromGrp:=AddSQLTokens(stKeyword, TFrom, 'GROUP', [], 13);
  TUsrGrp:=AddSQLTokens(stIdentificator, [TFrom, TFromGrp], '', [], 14);
    TSymb:=AddSQLTokens(stSymbol, TUsrGrp, ',', [toOptional]);
    TSymb.AddChildToken(TUsrGrp);

  TCasc:=AddSQLTokens(stKeyword, TUsrGrp, 'CASCADE', [toOptional], 15);
  TRestr:=AddSQLTokens(stKeyword, TUsrGrp, 'RESTRICT', [toOptional], 16);
end;

procedure TPGSQLRevoke.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:begin
        GrantTypes:=GrantTypes + [ogWGO];
        FCurOpt:=ogWGO;
      end;
    2:begin
        GrantTypes:=GrantTypes + [ogSelect];
        FCurOpt:=ogSelect;
      end;
    3:begin
        GrantTypes:=GrantTypes + [ogInsert];
        FCurOpt:=ogInsert;
      end;
    4:begin
        GrantTypes:=GrantTypes + [ogUpdate];
        FCurOpt:=ogUpdate;
      end;
    5:begin
        GrantTypes:=GrantTypes + [ogDelete];
        FCurOpt:=ogDelete;
      end;
    6:begin
        GrantTypes:=GrantTypes + [ogTruncate];
        FCurOpt:=ogTruncate;
      end;
    7:begin
        GrantTypes:=GrantTypes + [ogReference];
        FCurOpt:=ogReference;
      end;
    8:begin
        GrantTypes:=GrantTypes + [ogTrigger];
        FCurOpt:=ogTrigger;
      end;
    9:begin
        GrantTypes:=GrantTypes + [ogAll];
        FCurOpt:=ogAll;
      end;
    19:begin
        GrantTypes:=GrantTypes + [ogUsage];
        FCurOpt:=ogUsage;
      end;
    23:begin
        GrantTypes:=GrantTypes + [ogCreate];
        FCurOpt:=ogCreate;
      end;
    30:begin
        GrantTypes:=GrantTypes + [ogExecute];
        FCurOpt:=ogExecute;
      end;
    10:ObjectKind:=okTable;
    11:begin
         if ObjectKind = okNone then
         begin
           if GrantTypes = [] then
             ObjectKind:=okRole
           else
             ObjectKind:=okTable;
         end;
         FCurTable:=Tables.Add(AWord);
       end;
    17:begin
         if Assigned(FCurTable) then
         begin
           FCurTable.SchemaName:=FCurTable.Name;
           FCurTable.Name:=AWord;
         end
         else
           Tables.Add(AWord);
         FCurTable:=nil;
       end;
    12:begin
         ObjectKind:=okTable;
         GrantAllTables:=True;
         Tables.Add(AWord);
       end;
    13:begin
        FCurUSr:=Params.AddParam('');
        FCurUSr.TypeName:='GROUP';
      end;
    14:begin
         if Assigned(FCurUSr) then FCurUSr.Caption:=AWord
         else
           Params.AddParam(AWord);
         FCurUSr:=nil;
       end;
    15:CascadeRule:=drCascade;
    16:CascadeRule:=drRestrict;
    18:Fields.AddParam(AWord).TypeName:=ObjectGrantNames[FCurOpt];
    20:begin
         FCurTable:=Tables.Add(AWord);
         ObjectKind:=okSequence;
       end;
    21:begin
         if Assigned(FCurTable) then
         begin
           FCurTable.SchemaName:=FCurTable.Name;
           FCurTable.Name:=AWord;
         end
         else
           Tables.Add(AWord);
         FCurTable:=nil;
       end;
    22:begin
         ObjectKind:=okSequence;
         GrantAllTables:=True;
         Tables.Add(AWord);
       end;
    24:begin
         FCurTable:=Tables.Add(AWord);
         ObjectKind:=okScheme;
       end;
    31:begin
         FCurTable:=Tables.Add(AWord);
         ObjectKind:=okFunction;
       end;
    32:if Assigned(FCurTable) then
       begin
         FCurTable.SchemaName:=FCurTable.Name;
         FCurTable.Name:=AWord;
       end;
    33,
    34:begin
         FCurTable:=nil;
         FCurField:=nil;
       end;
    50:begin
        ObjectKind:=okRole;
        GrantTypes:=GrantTypes + [ogWGO];
      end;
    101,
    102,
    103,
    104:if Assigned(FCurTable) then
       begin
         FCurField:=FCurTable.Fields.AddParam('');
         case AChild.Tag of
           101:FCurField.InReturn:=spvtInput;
           102:FCurField.InReturn:=spvtOutput;
           103:FCurField.InReturn:=spvtInOut;
           104:FCurField.InReturn:=spvtVariadic;
         end;
       end;

    105:begin
          if not Assigned(FCurField) then
            FCurField:=FCurTable.Fields.AddParam('');
          FCurField.TypeName:=AWord;
        end;
    106: if Assigned(FCurField) then
         begin
           if FCurField.Caption = '' then
           begin
             FCurField.Caption:=FCurField.TypeName;
             FCurField.TypeName:=AWord;
           end
           else
             FCurField.TypeName:=FCurField.TypeName + AWord;
         end;
    107:if Assigned(FCurField) then FCurField.TypeName:=FCurField.TypeName + AWord;
    108:if Assigned(FCurField) then
        begin
          if (FCurField.TypeName<>'') and (FCurField.TypeName[Length(FCurField.TypeName)] = '.') then
            FCurField.TypeName:=FCurField.TypeName + AWord
          else
            FCurField.TypeName:=FCurField.TypeName + ' ' + AWord;
        end;
    109,
    110:FCurField:=nil;

(*

FT10_1:=Owner.AddSQLTokens(stKeyword, InToken, 'IN', [], 101);
FT10_2:=Owner.AddSQLTokens(stKeyword, InToken, 'OUT', [], 102);
FT10_3:=Owner.AddSQLTokens(stKeyword, InToken, 'INOUT', [], 103);
FT10_4:=Owner.AddSQLTokens(stKeyword, InToken, 'VARIADIC', [], 104);
FT10_5:=Owner.AddSQLTokens(stIdentificator, [InToken, FT10_1, FT10_2, FT10_3, FT10_4], '', [], 105);
FT10_6:=Owner.AddSQLTokens(stIdentificator, FT10_5, '', [], 106);
FT10_7:=Owner.AddSQLTokens(stSymbol, FT10_6, '.', [], 107);
FT10_7:=Owner.AddSQLTokens(stIdentificator, [FT10_7, FT10_6], '', [], 108);
FT10_8:=Owner.AddSQLTokens(stIdentificator, FT10_7, '', [], 108);
FT10_9:=Owner.AddSQLTokens(stIdentificator, FT10_8, '', [], 108);

TSymb:=Owner.AddSQLTokens(stSymbol, [FT10_1, FT10_2, FT10_3, FT10_4, FT10_5, FT10_6, FT10_7, FT10_8, FT10_9], ',', [], 109);
  TSymb.AddChildToken([FT10_1, FT10_2, FT10_3, FT10_4, FT10_5, FT10_7, FT10_8, FT10_9]);
*)
  end;
end;

procedure TPGSQLRevoke.MakeSQL;
var
  S, S1, S2: String;
  F: TSQLParserField;
  T: TTableItem;
  C: Integer;
  i: TObjectGrant;
begin
  (*
    REVOKE [ GRANT OPTION FOR ]
        { { CREATE | USAGE } [, ...] | ALL [ PRIVILEGES ] }
        ON SCHEMA schema_name [, ...]
        FROM { [ GROUP ] role_name | PUBLIC } [, ...]
        [ CASCADE | RESTRICT ]
  *)

  (*
  REVOKE [ ADMIN OPTION FOR ]
      role_name [, ...] FROM role_name [, ...]
      [ CASCADE | RESTRICT ]

  *)
  S:='REVOKE ';
  if ogWGO in GrantTypes then
    if ObjectKind = okRole then
      S:=S + 'ADMIN OPTION FOR '
    else
      S:=S + 'GRANT OPTION FOR ';

  C:=0;
  if ObjectKind <> okRole then
  begin
    if Fields.Count > 0 then
    begin
      for i:=low(TObjectGrant) to High(TObjectGrant) do
        if (i in GrantTypes) and (i<>ogWGO) then
        begin
          if C>0 then S:=S + ', ';
          S:=S + ObjectGrantNames[i];
          S1:='';
          for F in Fields do
          begin
            if F.TypeName = ObjectGrantNames[i] then
            begin
              if S1<>'' then S1:=S1+ ', ';
              S1:=S1 + F.Caption;
            end;
          end;
          if S1<>'' then S:=S+'('+S1+')';
          Inc(C);
        end;
    end
    else
    begin
      S:=S + ObjectGrantToStr(GrantTypes, true);
    end;
    S:=S + ' ON';
  end;

  case ObjectKind of
    okRole:S:=S + ' ' + Tables.AsString;
    okTable:begin
        if FGrantAllTables and (Fields.Count = 0) then
          S:=S + ' ALL TABLES IN SCHEMA '+ Tables.AsString
        else
          S:=S + ' TABLE ' + Tables.AsString;
      end;
    okSequence:
      begin
        if FGrantAllTables then
          S:=S + ' ALL SEQUENCES IN SCHEMA '+ Tables.AsString
        else
          S:=S + ' SEQUENCE ' + Tables.AsString;
      end;
    okScheme:S:=S + ' SCHEMA ' + Tables.AsString;
    okFunction:
      begin
        S1:='';
        for T in Tables do
        begin
          if S1<>'' then S1:=S1 + ',' + LineEnding + ' ';
          S1:=S1 + ' FUNCTION ' + T.FullName;

          S2:='';
          for F in T.Fields do
          begin
            if S2<>'' then S2:=S2 + ','; // + LineEnding;
            S2:=S2 + ' ' + PGVarTypeNames[F.InReturn] + ' ' + F.Caption + ' ' +F.FullTypeName;
          end;
          S1:=S1 + '(' + S2 + ')';

          (*
    REVOKE [ GRANT OPTION FOR ]
        { EXECUTE | ALL [ PRIVILEGES ] }
        ON { FUNCTION function_name ( [ [ argmode ] [ arg_name ] arg_type [, ...] ] ) [, ...]
             | ALL FUNCTIONS IN SCHEMA schema_name [, ...] }
        FROM { [ GROUP ] role_name | PUBLIC } [, ...]
        [ CASCADE | RESTRICT ]
*)      end;
        if S1<>'' then
          S:=S + S1;
      end;
  else
    S:=S + ' ' + Tables.AsString;
  end;


  S:=S + ' FROM';
  S1:='';
  for F in Params do
  begin
    if S1<> '' then S1:=S1 + ',';
    if F.TypeName <> '' then
      S1:=S1 + ' ' + F.TypeName;
    S1:=S1 + ' ' + F.Caption;
  end;
  S:=S + S1;

  if CascadeRule = drCascade then
    S:=S + ' CASCADE'
  else
  if CascadeRule = drRestrict then
    S:=S + ' RESTRICT';
  AddSQLCommand(S);
end;

procedure TPGSQLRevoke.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLRevoke then
  begin
    GrantAllTables:=TPGSQLRevoke(ASource).GrantAllTables;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLGrant }

procedure TPGSQLGrant.InitParserTree;
var
  FSQLTokens, T1, T, T2, T3, T4, T5, T6, T7, T9, T10, T11,
    T13, T12, T14, TTo, TToInd, TToGrp, T20, T21, TSymb, TAll,
    TAllPriv, T9_1, TS1, TSeq, T40, T40_On, T41, T42, T43,
    TSymb2: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для GRANT }
  (*
  GRANT { { SELECT | INSERT | UPDATE | DELETE | TRUNCATE | REFERENCES | TRIGGER }
    [, ...] | ALL [ PRIVILEGES ] }
    ON { [ TABLE ] table_name [, ...]
         | ALL TABLES IN SCHEMA schema_name [, ...] }
    TO { [ GROUP ] role_name | PUBLIC } [, ...] [ WITH GRANT OPTION ]

GRANT { { SELECT | INSERT | UPDATE | REFERENCES } ( column [, ...] )
    [, ...] | ALL [ PRIVILEGES ] ( column [, ...] ) }
    ON [ TABLE ] table_name [, ...]
    TO { [ GROUP ] role_name | PUBLIC } [, ...] [ WITH GRANT OPTION ]

GRANT { { CREATE | CONNECT | TEMPORARY | TEMP } [, ...] | ALL [ PRIVILEGES ] }
    ON DATABASE database_name [, ...]
    TO { [ GROUP ] role_name | PUBLIC } [, ...] [ WITH GRANT OPTION ]

GRANT { USAGE | ALL [ PRIVILEGES ] }
    ON FOREIGN DATA WRAPPER fdw_name [, ...]
    TO { [ GROUP ] role_name | PUBLIC } [, ...] [ WITH GRANT OPTION ]

GRANT { USAGE | ALL [ PRIVILEGES ] }
    ON FOREIGN SERVER server_name [, ...]
    TO { [ GROUP ] role_name | PUBLIC } [, ...] [ WITH GRANT OPTION ]

GRANT { EXECUTE | ALL [ PRIVILEGES ] }
    ON { FUNCTION function_name ( [ [ argmode ] [ arg_name ] arg_type [, ...] ] ) [, ...]
         | ALL FUNCTIONS IN SCHEMA schema_name [, ...] }
    TO { [ GROUP ] role_name | PUBLIC } [, ...] [ WITH GRANT OPTION ]

GRANT { USAGE | ALL [ PRIVILEGES ] }
    ON LANGUAGE lang_name [, ...]
    TO { [ GROUP ] role_name | PUBLIC } [, ...] [ WITH GRANT OPTION ]

GRANT { { SELECT | UPDATE } [, ...] | ALL [ PRIVILEGES ] }
    ON LARGE OBJECT loid [, ...]
    TO { [ GROUP ] role_name | PUBLIC } [, ...] [ WITH GRANT OPTION ]

GRANT { CREATE | ALL [ PRIVILEGES ] }
    ON TABLESPACE tablespace_name [, ...]
    TO { [ GROUP ] role_name | PUBLIC } [, ...] [ WITH GRANT OPTION ]

  GRANT role_name [, ...] TO role_name [, ...] [ WITH ADMIN OPTION ]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'GRANT', [toFindWordLast, toFirstToken]);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'SELECT', [], 1);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'INSERT', [], 2);
    T3:=AddSQLTokens(stKeyword, FSQLTokens, 'UPDATE', [], 3);
    T4:=AddSQLTokens(stKeyword, FSQLTokens, 'DELETE', [], 4);
    T5:=AddSQLTokens(stKeyword, FSQLTokens, 'TRUNCATE', [], 5);
    T6:=AddSQLTokens(stKeyword, FSQLTokens, 'REFERENCES', [], 6);
    T7:=AddSQLTokens(stKeyword, FSQLTokens, 'TRIGGER', [], 7);
    T21:=AddSQLTokens(stKeyword, FSQLTokens, 'USAGE', [], 21);

    T:=AddSQLTokens(stSymbol, T1, ',', []);
      T.AddChildToken([T1, T2, T3, T4, T5, T6, T7, T21]);
    T2.AddChildToken(T);
    T3.AddChildToken(T);
    T4.AddChildToken(T);
    T5.AddChildToken(T);
    T6.AddChildToken(T);
    T7.AddChildToken(T);
    T21.AddChildToken(T);

    TAll:=AddSQLTokens(stKeyword, FSQLTokens, 'ALL', [], 8);
    TAllPriv:=AddSQLTokens(stKeyword, TAll, 'PRIVILEGES', [], 18);
    T9:=AddSQLTokens(stKeyword, [T1, T2, T3, T4, T5, T6, T7, TAll, TAllPriv], 'ON', []);

    T10:=AddSQLTokens(stKeyword, T9, 'TABLE', [], 10);
    TSeq:=AddSQLTokens(stKeyword, T9, 'SEQUENCE', [], 30);

    T11:=AddSQLTokens(stIdentificator, [T9, T10, TSeq, FSQLTokens], '', [], 11);
      T:=AddSQLTokens(stSymbol, T11, '.', []);
      T14:=AddSQLTokens(stIdentificator, T, '', [],14);
      T:=AddSQLTokens(stSymbol, [T11, T14], ',', []);
      T.AddChildToken(T11);


    T12:=AddSQLTokens(stKeyword, T9, 'ALL', [], 12);
      T:=AddSQLTokens(stKeyword, T12, 'TABLES', [], 10);
      TS1:=AddSQLTokens(stKeyword, T12, 'SEQUENCES', []);
      T:=AddSQLTokens(stKeyword, [T, TS1], 'IN', []);
      T:=AddSQLTokens(stKeyword, T, 'SCHEMA', []);
    T13:=AddSQLTokens(stIdentificator, T, '', [], 13);

//GRANT role_name [, ...] TO role_name [, ...] [ WITH ADMIN OPTION ]

  TTo:=AddSQLTokens(stKeyword, [T11, T14, T13], 'TO', []);
    TToGrp:=AddSQLTokens(stKeyword, T12, 'GROUP', [], 15);
    TToInd:=AddSQLTokens(stIdentificator, [TTo, TToGrp] , '', [], 16);
      T:=AddSQLTokens(stSymbol, TToInd, ',', [toOptional]);
      T.AddChildToken([TToInd, TToGrp]);

  T:=AddSQLTokens(stKeyword, TToInd, 'WITH', [toOptional]);
  T1:=AddSQLTokens(stKeyword, T, 'ADMIN', []);
  T:=AddSQLTokens(stKeyword, T, 'GRANT', []);
  T:=AddSQLTokens(stKeyword, [T, T1], 'OPTION', [], 17);


(*
  GRANT { { CREATE | USAGE } [, ...] | ALL [ PRIVILEGES ] }
      ON SCHEMA schema_name [, ...]
      TO { [ GROUP ] role_name | PUBLIC } [, ...] [ WITH GRANT OPTION ]
*)
  T20:=AddSQLTokens(stKeyword, FSQLTokens, 'CREATE', [], 20);

  TSymb:=AddSQLTokens(stSymbol, [T20, T21], ',', []);
    TSymb.AddChildToken([T20, T21]);
  T9_1:=AddSQLTokens(stKeyword, [T20, T21], 'ON', []);
  T:=AddSQLTokens(stKeyword, [T9, T9_1], 'SCHEMA', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 29);
  TSymb:=AddSQLTokens(stSymbol, T, ',', [toOptional]);
    TSymb.AddChildToken(T);
  T.AddChildToken(TTo);


  {
  ON { [ TABLE ] table_name [, ...]
       | ALL TABLES IN SCHEMA schema_name [, ...] }
  TO { [ GROUP ] role_name | PUBLIC } [, ...] [ WITH GRANT OPTION ]
}

(*
GRANT { EXECUTE | ALL [ PRIVILEGES ] }
    ON { FUNCTION function_name ( [ [ argmode ] [ arg_name ] arg_type [, ...] ] ) [, ...]
         | ALL FUNCTIONS IN SCHEMA schema_name [, ...] }
    TO { [ GROUP ] role_name | PUBLIC } [, ...] [ WITH GRANT OPTION ]
*)
  T40:=AddSQLTokens(stKeyword, FSQLTokens, 'EXECUTE', [], 40);
    T40_On:=AddSQLTokens(stKeyword, [T40], 'ON', []);
  T41:=AddSQLTokens(stKeyword, [T40_On, T9], 'FUNCTION', [], 41);
    T42:=AddSQLTokens(stIdentificator, T41, '', [], 42);
    TSymb:=AddSQLTokens(stSymbol, T42, '.', []);
    T43:=AddSQLTokens(stIdentificator, TSymb, '', [], 43);
    TSymb:=AddSQLTokens(stSymbol, [T42, T43], '(', []);
    TSymb2:=AddSQLTokens(stSymbol, TSymb, ')', [], 44);

    CreateInParamsTree(Self, TSymb, TSymb2);

    TSymb:=AddSQLTokens(stSymbol, TSymb2, ',', []);
      TSymb.AddChildToken(T42);
    TSymb2.AddChildToken(TTo);
end;

procedure TPGSQLGrant.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    17:GrantTypes:=GrantTypes + [ogWGO];
    1:GrantTypes:=GrantTypes + [ogSelect];
    2:GrantTypes:=GrantTypes + [ogInsert];
    3:GrantTypes:=GrantTypes + [ogUpdate];
    4:GrantTypes:=GrantTypes + [ogDelete];
    5:GrantTypes:=GrantTypes + [ogTruncate];
    6:GrantTypes:=GrantTypes + [ogReference];
    7:GrantTypes:=GrantTypes + [ogTrigger];
    8:GrantTypes:=GrantTypes + [ogAll];
    18:AllPrivilegesShortForm:=false;
    20:GrantTypes:=GrantTypes + [ogCreate];
    21:GrantTypes:=GrantTypes + [ogUsage];
    40:GrantTypes:=GrantTypes + [ogExecute];
    10:begin
         ObjectKind:=okTable;
         TableShortForm:=false;
       end;
    41:ObjectKind:=okFunction;
    11:begin
         if ObjectKind = okNone then
           if (GrantTypes = []) then
             ObjectKind:=okRole
           else
             ObjectKind:=okTable;
         FCurTable:=Tables.Add(AWord);
       end;
    42:begin
         if ObjectKind = okNone then
           ObjectKind:=okTable;
         FCurTable:=Tables.Add(AWord);
       end;
    12:FGrantAllTables:=true;
    13:Tables.Add(AWord);
    14, 43:if Assigned(FCurTable) then
       begin
         FCurTable.SchemaName:=FCurTable.Name;
         FCurTable.Name:=AWord;
         if AChild.Tag <> 43 then
           FCurTable:=nil;
       end;
    15:FCurParam:=Params.AddParamEx('', AWord);
    16:if Assigned(FCurParam) then
       begin
         FCurParam.Caption:=AWord;
         FCurParam:=nil;
       end
       else
         Params.AddParam(AWord);
    29:begin
         ObjectKind:=okScheme;
         FCurTable:=Tables.Add(AWord);
       end;
    30:begin
         ObjectKind:=okSequence;
         //FCurTable:=Tables.Add(AWord);
       end;

    101,
    102,
    103,
    104:begin
           FCurParam:=FCurTable.Fields.AddParam('');
           case AChild.Tag of
             101:FCurParam.InReturn:=spvtInput;
             102:FCurParam.InReturn:=spvtOutput;
             103:FCurParam.InReturn:=spvtInOut;
             104:FCurParam.InReturn:=spvtVariadic;
           end;
         end;
    105:begin
          if not Assigned(FCurParam) then
            FCurParam:=FCurTable.Fields.AddParamWithType('', AWord)
          else
            FCurParam.TypeName:=AWord;
        end;
    106:if Assigned(FCurParam) then
        begin
           if FCurParam.Caption = '' then
           begin
             FCurParam.Caption:=FCurParam.TypeName;
             FCurParam.TypeName:=AWord;
           end
           else
             FCurParam.TypeName:=FCurParam.TypeName + AWord;
        end;
    107:if Assigned(FCurParam) then FCurParam.TypeName:=FCurParam.TypeName + AWord;
    108:if Assigned(FCurParam) then FCurParam.TypeName:=FCurParam.TypeName + ' ' + AWord;
    44,
    109,
    110:FCurParam:=nil;

  end;
end;

procedure TPGSQLGrant.MakeSQL;
var
  S, S1: String;
  P: TSQLParserField;
  T: TTableItem;
begin
  S:='GRANT ';
  if ObjectKind <> okRole then
    S:=S + ObjectGrantToStr(GrantTypes, AllPrivilegesShortForm);

  case ObjectKind of
    okTable:begin
              S1:='';
              if FGrantAllTables then
              begin
                S:=S + ' ALL TABLES IN SCHEMA  ' + Tables.AsString
              end
              else
              begin
                if TableShortForm then
                  S:=S + ' ON ' + Tables.AsString
                else
                  S:=S + ' ON TABLE ' + Tables.AsString;
              end;
            end;
    okScheme:S:=S + ' ON SCHEMA ' + Tables.AsString;
    okSequence:begin

             if FGrantAllTables then
               S:=S + ' ALL SEQUENCES IN SCHEMA  ' + Tables.AsString
             else
               S:=S + ' ON SEQUENCE ' + Tables.AsString;
      end;
    okFunction:begin
                 S:=S + ' ON FUNCTION ';
                 for T in Tables do
                 begin
                   S:=S + T.FullName;

                   S1:='';
                   for P in T.Fields do
                   begin
                     if S1<> '' then S1:=S1 + ','; //+ LineEnding;
                     if P.InReturn = spvtInput then
                        S1:=S1 + ' IN'
                     else
                     if P.InReturn = spvtOutput then
                       S1:=S1 + ' OUT'
                     else
                     if P.InReturn = spvtInOut then
                       S1:=S1 + ' INOUT';

                     if P.Caption <> P.TypeName then
                       S1:=S1 + ' ' + P.Caption;

                     S1:=S1 + ' ' + P.TypeName;
                   end;

                   S:=S + '(' + S1 + '),';
                 end;
                 S:=Copy(S, 1, Length(S)-1)
               end;
    okRole:
      begin
      S:=S + Tables.AsString
      end;
  else
    S:=S + ' ON  ' + Tables.AsString;
  end;
  S:=S + ' TO';

  S1:='';
  for P in Params do
  begin
    if S1<>'' then S1:=S1 + ',';
    if (P.RealName <> P.Caption) and (P.RealName<>'') then
      S1:=S1 + ' ' + P.RealName;
    S1:=S1 + ' ' + P.Caption;
  end;
  S:=S + S1;

  if ogWGO in GrantTypes then
  begin
    if ObjectKind = okRole then
      S:=S + ' WITH ADMIN OPTION'
    else
      S:=S + ' WITH GRANT OPTION';
  end;

  AddSQLCommand(S);
end;

constructor TPGSQLGrant.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  AllPrivilegesShortForm:=true;
end;

procedure TPGSQLGrant.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLGrant then
  begin
    AllPrivilegesShortForm:=TPGSQLGrant(ASource).AllPrivilegesShortForm;
    GrantAllTables:=TPGSQLGrant(ASource).GrantAllTables;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLSecurityLabel }

procedure TPGSQLSecurityLabel.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для SECURITY LABEL [ FOR provider ] ON }
  (*
SECURITY LABEL [ FOR provider ] ON
{
  TABLE object_name |
  COLUMN table_name.column_name |
  AGGREGATE agg_name (agg_type [, ...] ) |
  DOMAIN object_name |
  FOREIGN TABLE object_name
  FUNCTION function_name ( [ [ argmode ] [ argname ] argtype [, ...] ] ) |
  LARGE OBJECT large_object_oid |
  [ PROCEDURAL ] LANGUAGE object_name |
  SCHEMA object_name |
  SEQUENCE object_name |
  TYPE object_name |
  VIEW object_name
} IS 'label'
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'SECURITY', [toFirstToken]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'LABEL', [toFindWordLast]);
end;

procedure TPGSQLSecurityLabel.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
end;

procedure TPGSQLSecurityLabel.MakeSQL;
var
  Result: String;
begin
  Result:='SECURITY LABEL';
  AddSQLCommand(Result);
end;

{ TPGSQLSavepoint }

procedure TPGSQLSavepoint.InitParserTree;
var
  FSQLTokens: TSQLTokenRecord;
begin
  (*
  SAVEPOINT savepoint_name
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'SAVEPOINT', [toFindWordLast, toFirstToken]);
    AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
end;

procedure TPGSQLSavepoint.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  if AChild.Tag = 1 then
    FSavepointName:=AWord;
end;

procedure TPGSQLSavepoint.MakeSQL;
var
  Result: String;
begin
  Result:='SAVEPOINT '+FSavepointName;
  AddSQLCommand(Result);
end;

procedure TPGSQLSavepoint.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLSavepoint then
  begin
    SavepointName:=TPGSQLSavepoint(ASource).SavepointName;

  end;
  inherited Assign(ASource);
end;

{ TPGSQLReset }

procedure TPGSQLReset.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  (*
  RESET configuration_parameter
  RESET ALL

  RESET ROLE
  RESET SESSION AUTHORIZATION
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'RESET', [toFindWordLast, toFirstToken]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'ALL', []);
    T:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'ROLE', [], 2);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'SESSION', [], 3);
    T:=AddSQLTokens(stKeyword, T, 'AUTHORIZATION', []);

end;

procedure TPGSQLReset.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:FConfigurationParameter:=AWord;
    2:FResetRole:=true;
    3:FResetSession:=true;
  end;
end;

procedure TPGSQLReset.MakeSQL;
var
  Result: String;
begin
  if FResetRole then
    Result:='RESET ROLE'
  else
  if FResetSession then
    Result:='RESET SESSION AUTHORIZATION'
  else
  if FConfigurationParameter <> '' then
    Result:='RESET '+FConfigurationParameter
  else
    Result:='RESET ALL';
  AddSQLCommand(Result);
end;

procedure TPGSQLReset.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLReset then
  begin
    ConfigurationParameter:=TPGSQLReset(ASource).ConfigurationParameter;
    ResetRole:=TPGSQLReset(ASource).ResetRole;
    ResetSession:=TPGSQLReset(ASource).ResetSession;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLReleaseSavepoint }

procedure TPGSQLReleaseSavepoint.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  (*
  RELEASE [ SAVEPOINT ] savepoint_name
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'RELEASE', [toFindWordLast, toFirstToken]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'SAVEPOINT', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
    FSQLTokens.AddChildToken(T);
end;

procedure TPGSQLReleaseSavepoint.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  if AChild.Tag = 1 then
    FSavepointName:=AWord;
end;

procedure TPGSQLReleaseSavepoint.MakeSQL;
var
  Result: String;
begin
  Result:='RELEASE SAVEPOINT '+FSavepointName;
  AddSQLCommand(Result);
end;

procedure TPGSQLReleaseSavepoint.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLReleaseSavepoint then
  begin
    SavepointName:=TPGSQLReleaseSavepoint(ASource).SavepointName;

  end;
  inherited Assign(ASource);
end;

{ TPGSQLReassignOwned }

procedure TPGSQLReassignOwned.InitParserTree;
var
  T, FSQLTokens, T1: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для REASSIGN OWNED BY  }
  (*
  REASSIGN OWNED BY old_role [, ...] TO new_role
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'REASSIGN', [toFirstToken]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'OWNED', []);
    T:=AddSQLTokens(stKeyword, T, 'BY', [toFindWordLast]);
    T:=AddSQLTokens(stIdentificator, T, '', [], 1);
      T1:=AddSQLTokens(stSymbol, T, ',', []);
      T1.AddChildToken(T);
    T:=AddSQLTokens(stKeyword, T, 'TO', []);
    T:=AddSQLTokens(stIdentificator, T, '', [], 2);
end;

procedure TPGSQLReassignOwned.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Params.AddParam(AWord);
    2:NewRole:=AWord;
  end;
end;

procedure TPGSQLReassignOwned.MakeSQL;
var
  S: String;
begin
  S:='REASSIGN OWNED BY ' + Params.AsString + ' TO ' + NewRole;
  AddSQLCommand(S);
end;

procedure TPGSQLReassignOwned.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLReassignOwned then
  begin
    FNewRole:=TPGSQLReassignOwned(ASource).NewRole;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLPrepare }

procedure TPGSQLPrepare.InitParserTree;
var
  FSQLTokens, T: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для PREPARE  }
  (*
  PREPARE TRANSACTION transaction_id

  PREPARE name [ ( data_type [, ...] ) ] AS statement
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'PREPARE', [toFindWordLast, toFirstToken]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'TRANSACTION', []);
    T:=AddSQLTokens(stInteger, T, '', [], 1);
  T:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 2);
end;

procedure TPGSQLPrepare.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:TransactionId:=AWord;
    2:begin
        TransactionName:=AWord;
        TransactionExp:=ASQLParser.GetToCommandDelemiter;
      end;
  end;
end;

procedure TPGSQLPrepare.MakeSQL;
var
  S, S1: String;
begin
  S:='PREPARE';

  if TransactionId <> '' then
  begin
    S:=S + ' TRANSACTION '+TransactionId;
  end
  else
  begin
    S1:=TransactionExp;
    if (S1<>'') and (S1[1]<>' ') then S1:=' ' + S1;
    S:=S + ' ' + TransactionName + S1;
  end;
  AddSQLCommand(S);
end;

procedure TPGSQLPrepare.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLPrepare then
  begin
    TransactionId:=TPGSQLPrepare(ASource).TransactionId;
    TransactionName:=TPGSQLPrepare(ASource).TransactionName;
    TransactionExp:=TPGSQLPrepare(ASource).TransactionExp;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLNotify }

procedure TPGSQLNotify.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  (*
  NOTIFY channel [ , payload ]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'NOTIFY', [toFindWordLast, toFirstToken]);
    T:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
    T:=AddSQLTokens(stSymbol, T, ',', [toOptional]);
    T:=AddSQLTokens(stString, T, '', [], 2);
end;

procedure TPGSQLNotify.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:FChannel:=AWord;
    2:FPayload:=AWord;
  end;
end;

procedure TPGSQLNotify.MakeSQL;
var
  Result: String;
begin
  Result:='NOTIFY '+FChannel;
  if FPayload <> '' then
    Result:=Result + ', '+FPayload;
  AddSQLCommand(Result);
end;

procedure TPGSQLNotify.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLNotify then
  begin
    Channel:=TPGSQLNotify(ASource).Channel;
    Payload:=TPGSQLNotify(ASource).Payload;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLMove }

procedure TPGSQLMove.InitParserTree;
var
  FSQLTokens, T1, T2, T3, T4, T5, T5_1, T6, T6_1, T7, T8, T9,
    T9_1, T9_2, T10, T10_1, T10_2, T20, T21, T30: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для MOVE }
  (*
  MOVE [ direction [ FROM | IN ] ] cursor_name

where direction can be empty or one of:

    NEXT
    PRIOR
    FIRST
    LAST
    ABSOLUTE count
    RELATIVE count
    count
    ALL
    FORWARD
    FORWARD count
    FORWARD ALL
    BACKWARD
    BACKWARD count
    BACKWARD ALL
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'MOVE', [toFindWordLast, toFirstToken]);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'NEXT', [], 1);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'PRIOR', [], 2);
    T3:=AddSQLTokens(stKeyword, FSQLTokens, 'FIRST', [], 3);
    T4:=AddSQLTokens(stKeyword, FSQLTokens, 'LAST', [], 4);
    T5:=AddSQLTokens(stKeyword, FSQLTokens, 'ABSOLUTE', [], 5);
      T5_1:=AddSQLTokens(stInteger, T5, '', [], 50);
    T6:=AddSQLTokens(stKeyword, FSQLTokens, 'RELATIVE', [], 6);
      T6_1:=AddSQLTokens(stInteger, T6, '', [], 50);
    T7:=AddSQLTokens(stInteger, FSQLTokens, '', [], 50);
    T8:=AddSQLTokens(stKeyword, FSQLTokens, 'ALL', [], 8);
    T9:=AddSQLTokens(stKeyword, FSQLTokens, 'FORWARD', [], 9);
      T9_1:=AddSQLTokens(stInteger, T9, '', [], 50);
      T9_2:=AddSQLTokens(stKeyword, T9, 'ALL', [], 51);
    T10:=AddSQLTokens(stKeyword, FSQLTokens, 'BACKWARD', [], 10);
      T10_1:=AddSQLTokens(stInteger, T10, '', [], 50);
      T10_2:=AddSQLTokens(stKeyword, T10, 'ALL', [], 51);

  T20:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2, T3, T4, T5_1, T6_1, T7, T8, T9, T9_1, T9_2, T10, T10_1, T10_2], 'FROM', [], 20);
  T21:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2, T3, T4, T5_1, T6_1, T7, T8, T9, T9_1, T9_2, T10, T10_1, T10_2], 'IN', [], 21);

  T30:=AddSQLTokens(stIdentificator, [FSQLTokens, T1, T2, T3, T4, T5_1, T6_1, T7, T8, T9, T9_1, T9_2, T10, T10_1, T10_2, T20, T21], '', [], 30);
end;

procedure TPGSQLMove.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:MoveDirection:=mdNext;
    2:MoveDirection:=mdPrior;
    3:MoveDirection:=mdFirst;
    4:MoveDirection:=mdLast;
    5:MoveDirection:=mdAbsolute;
    6:MoveDirection:=mdRelative;
    8:MoveDirection:=mdAll;
    9:MoveDirection:=mdForward;
    10:MoveDirection:=mdBackward;
    20:Option:=moFrom;
    21:Option:=moIn;
    30:Name:=AWord;
    50:MoveCount:=StrToInt(AWord);
    51:begin
         if MoveDirection = mdForward then
           MoveDirection:=mdForwardAll
         else
         if MoveDirection = mdBackward then
           MoveDirection:=mdBackwardAll;
       end;
  end;
end;

procedure TPGSQLMove.MakeSQL;
var
  S: String;
begin
  S:='MOVE ';
  case MoveDirection of
    mdNext:S:=S + 'NEXT ';
    mdPrior:S:=S + 'PRIOR ';
    mdFirst:S:=S + 'FIRST ';
    mdLast:S:=S + 'LAST ';
    mdAbsolute:S:=S + Format('ABSOLUTE %d ', [MoveCount]);
    mdRelative:S:=S + Format('RELATIVE %d ', [MoveCount]);
    mdAll:S:=S + 'ALL ';
    mdForward:
      begin
        S:=S + 'FORWARD ';
        if MoveCount > 0 then
          S:=S + IntToStr(MoveCount) + ' ';
      end;
    mdForwardAll:S:=S + 'FORWARD ALL ';
    mdBackward:
      begin
        S:=S + 'BACKWARD ';
        if MoveCount > 0 then
          S:=S + IntToStr(MoveCount) + ' ';
      end;
    mdBackwardAll:S:=S + 'BACKWARD ALL ';
  else
    if MoveCount > 0 then
      S:=S + IntToStr(MoveCount) + ' ';
  end;

  if Option = moFrom then
    S:=S + 'FROM '
  else
  if Option = moIn then
    S:=S + 'IN ';

  S:=S + Name;
  AddSQLCommand(S);
end;

procedure TPGSQLMove.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLMove then
  begin
    MoveCount:=TPGSQLMove(ASource).MoveCount;
    MoveDirection:=TPGSQLMove(ASource).MoveDirection;
    Option:=TPGSQLMove(ASource).Option;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLLoad }

procedure TPGSQLLoad.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  (* LOAD 'filename' *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'LOAD', [toFindWordLast, toFirstToken]);
    T:=AddSQLTokens(stString, FSQLTokens, '', [], 1);
end;

procedure TPGSQLLoad.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  if AChild.Tag = 1 then
    FFileName:=AWord;
end;

procedure TPGSQLLoad.MakeSQL;
var
  Result: String;
begin
  Result:='LOAD '+FFileName;
  AddSQLCommand(Result);
end;

procedure TPGSQLLoad.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLLoad then
  begin
    FileName:=TPGSQLLoad(ASource).FileName;

  end;
  inherited Assign(ASource);
end;

{ TPGSQLLock }

procedure TPGSQLLock.InitParserTree;
var
  FSQLTokens, T1, T2, T, TSymb, T3, T3_1, T3_11, T3_12, T3_2,
    T3_21, T3_22, T32, T3_3, T3_31, T3_32, T3_4, T4: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для LOCK }
  (*
  LOCK [ TABLE ] [ ONLY ] name [, ...] [ IN lockmode MODE ] [ NOWAIT ]

  where lockmode is one of:

      ACCESS SHARE |
      ACCESS EXCLUSIVE |
      ROW SHARE |
      ROW EXCLUSIVE |
      SHARE UPDATE EXCLUSIVE |
      SHARE |
      SHARE ROW EXCLUSIVE |
      EXCLUSIVE |
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'LOCK', [toFindWordLast, toFirstToken]);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'TABLE', [], 3);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'ONLY', [], 4);
    T1.AddChildToken(T2);
    T2.AddChildToken(T1);
  T:=AddSQLTokens(stIdentificator, [FSQLTokens, T1, T2], '', [], 1);
    T1:=AddSQLTokens(stSymbol, T, '.', [toOptional]);
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 2);
    TSymb:=AddSQLTokens(stSymbol, [T1, T], ',', []);
      TSymb.AddChildToken(T);

  T3:=AddSQLTokens(stKeyword, [T, T1], 'IN', []);
    T3_1:=AddSQLTokens(stKeyword, T3, 'ACCESS', []);
    T3_11:=AddSQLTokens(stKeyword, T3_1, 'SHARE', [], 11);
    T3_12:=AddSQLTokens(stKeyword, T3_1, 'EXCLUSIVE', [], 12);

    T3_2:=AddSQLTokens(stKeyword, T3, 'ROW', []);
    T3_21:=AddSQLTokens(stKeyword, T3_2, 'SHARE', [], 21);
    T3_22:=AddSQLTokens(stKeyword, T3_2, 'EXCLUSIVE', [], 22);

    T3_3:=AddSQLTokens(stKeyword, T3, 'SHARE', [], 31);
    T3_31:=AddSQLTokens(stKeyword, T3_3, 'UPDATE', []);
    T3_31:=AddSQLTokens(stKeyword, T3_31, 'EXCLUSIVE', [], 32);
    T3_32:=AddSQLTokens(stKeyword, T3_3, 'ROW', []);
    T3_32:=AddSQLTokens(stKeyword, T3_32, 'EXCLUSIVE', [], 33);

    T3_4:=AddSQLTokens(stKeyword, T3, 'EXCLUSIVE', [], 41);

  T32:=AddSQLTokens(stKeyword, [T3_11, T3_12, T3_21, T3_22, T3_3, T3_31, T3_32, T3_4], 'MODE', []);

  T4:=AddSQLTokens(stKeyword, [T, T1, T32], 'NOWAIT', [toOptional], 5);
    T4.AddChildToken(T3);
end;

procedure TPGSQLLock.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FCurTable:=Tables.Add(AWord);
    2:if Assigned(FCurTable) then
      begin
        FCurTable.SchemaName:=FCurTable.Name;
        FCurTable.Name:=AWord;
        FCurTable:=nil;
      end;
    3:Options:=Options + [pgloTable];
    4:Options:=Options + [pgloOnly];
    5:Options:=Options + [pgloNoWait];
    11:Options:=Options + [pgloAccessShare];
    12:Options:=Options + [pgloAccessExclusive];
    21:Options:=Options + [pgloRowShare];
    22:Options:=Options + [pgloRowExclusive];
    31:Options:=Options + [pgloShare];
    32:Options:=Options - [pgloShare] + [pgloShareUpdateExclusive];
    33:Options:=Options - [pgloShare] + [pgloShareRowExclusive];
    41:Options:=Options + [pgloExclusive];
  end;
end;

procedure TPGSQLLock.MakeSQL;
var
  S, S1: String;
begin
  S:='LOCK';
  if pgloTable in Options then
    S:=S + ' TABLE';
  if pgloOnly in Options then
    S:=S + ' ONLY';
  S:=S + ' ' + Tables.AsString;


  S1:='';
  if pgloAccessShare in Options then
    S1:='ACCESS SHARE'
  else
  if pgloRowShare in Options then
    S1:='ROW SHARE'
  else
  if pgloRowExclusive in Options then
    S1:='ROW EXCLUSIVE'
  else
  if pgloShareUpdateExclusive in Options then
    S1:='SHARE UPDATE EXCLUSIVE'
  else
  if pgloShareRowExclusive in Options then
    S1:='SHARE ROW EXCLUSIVE'
  else
  if pgloShare in Options then
    S1:='SHARE'
  else
  if pgloExclusive in Options then
    S1:='EXCLUSIVE'
  else
  if pgloAccessExclusive in Options then
    S1:='ACCESS EXCLUSIVE';

  if S1<>'' then
    S:=S + ' IN '+S1+' MODE';

  if pgloNoWait in Options then
    S:=S + ' NOWAIT';
  AddSQLCommand(S);
end;

procedure TPGSQLLock.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLLock then
  begin
    Options:=TPGSQLLock(ASource).Options;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLListen }

procedure TPGSQLListen.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  (* LISTEN channel *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'LISTEN', [toFindWordLast, toFirstToken]);
    T:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
end;

procedure TPGSQLListen.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  if AChild.Tag = 1 then
    FChannel:=AWord;
end;

procedure TPGSQLListen.MakeSQL;
var
  S: String;
begin
  S:='LISTEN '+FChannel;
  AddSQLCommand(S);
end;

procedure TPGSQLListen.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLListen then
  begin
    Channel:=TPGSQLListen(ASource).Channel;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLFetch }

procedure TPGSQLFetch.InitParserTree;
var
  FSQLTokens, T9, T8, T7, T1, T2, T3, T4, T5, T6, TT1, TT2,
    T11, T9_1, T9_2, T8_1, T8_2, T: TSQLTokenRecord;
begin
  (*
  FETCH [ direction [ FROM | IN ] ] cursor_name

  where direction can be empty or one of:

      NEXT
      PRIOR
      FIRST
      LAST
      ABSOLUTE count
      RELATIVE count
      count
      ALL
      FORWARD
      FORWARD count
      FORWARD ALL
      BACKWARD
      BACKWARD count
      BACKWARD ALL
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'FETCH', [toFindWordLast, toFirstToken]);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'NEXT', [], 1);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'PRIOR', [], 2);
    T3:=AddSQLTokens(stKeyword, FSQLTokens, 'FIRST', [], 3);
    T4:=AddSQLTokens(stKeyword, FSQLTokens, 'LAST', [], 4);
    T5:=AddSQLTokens(stKeyword, FSQLTokens, 'ABSOLUTE', [], 5);
      T5:=AddSQLTokens(stInteger, T5, '', [], 11);
    T6:=AddSQLTokens(stKeyword, FSQLTokens, 'RELATIVE', [], 6);
      T6:=AddSQLTokens(stInteger, T6, '', [], 11);
    T7:=AddSQLTokens(stKeyword, FSQLTokens, 'ALL', [], 7);

  T8:=AddSQLTokens(stKeyword, FSQLTokens, 'FORWARD', [], 8);
    T8_1:=AddSQLTokens(stInteger, T8, '', [], 11);
    T8_2:=AddSQLTokens(stKeyword, T8, 'ALL', [], 82);

  T9:=AddSQLTokens(stKeyword, FSQLTokens, 'BACKWARD', [], 9);
    T9_1:=AddSQLTokens(stInteger, T9, '', [], 11);
    T9_2:=AddSQLTokens(stKeyword, T9, 'ALL', [], 92);

  T11:=AddSQLTokens(stInteger, FSQLTokens, '', [], 11);

  TT1:=AddSQLTokens(stKeyword, T1, 'FROM', []);
  TT2:=AddSQLTokens(stKeyword, T1, 'IN', []);
  T2.AddChildToken([TT1, TT2]);
  T3.AddChildToken([TT1, TT2]);
  T4.AddChildToken([TT1, TT2]);
  T5.AddChildToken([TT1, TT2]);
  T6.AddChildToken([TT1, TT2]);
  T7.AddChildToken([TT1, TT2]);
  T8.AddChildToken([TT1, TT2]);
  T8_1.AddChildToken([TT1, TT2]);
  T8_2.AddChildToken([TT1, TT2]);
  T9.AddChildToken([TT1, TT2]);
  T9_1.AddChildToken([TT1, TT2]);
  T9_2.AddChildToken([TT1, TT2]);
  T11.AddChildToken([TT1, TT2]);

  T:=AddSQLTokens(stIdentificator, T1, '', [], 10);
  TT1.AddChildToken(T);
  TT2.AddChildToken(T);
  T2.AddChildToken(T);
  T3.AddChildToken(T);
  T4.AddChildToken(T);
  T5.AddChildToken(T);

  T7.AddChildToken(T);
  T8.AddChildToken(T);
  T8_1.AddChildToken(T);
  T8_2.AddChildToken(T);
  T9.AddChildToken(T);
  T9_1.AddChildToken(T);
  T9_2.AddChildToken(T);

  T11.AddChildToken(T);

end;

procedure TPGSQLFetch.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FFetchType:=fetNext;
    2:FFetchType:=fetPrior;
    3:FFetchType:=fetFirst;
    4:FFetchType:=fetLast;
    5:FFetchType:=fetAbsolute;
    7:FFetchType:=fetAll;
    8:FFetchType:=fetForward;
    9:FFetchType:=fetBackward;

    10:FCursorName:=AWord;
    11:FCount:=AWord;
    82:FFetchType:=fetForwardAll;
    92:FFetchType:=fetBackward;
  end;
end;

procedure TPGSQLFetch.MakeSQL;
var
  Result: String;
begin
  Result:='FETCH ';
  case FFetchType of
    fetNext:Result:=Result + 'NEXT';
    fetPrior:Result:=Result + 'PRIOR';
    fetFirst:Result:=Result + 'FIRST';
    fetLast:Result:=Result + 'LAST';
    fetAbsolute:Result:=Result + 'ABSOLUTE';
    fetRelative:Result:=Result + 'RELATIVE';
    fetAll:Result:=Result + 'ALL';
    fetForward:Result:=Result + 'FORWARD';
    fetForwardAll:Result:=Result + 'FORWARD ALL';
    fetBackward:Result:=Result + 'BACKWARD';
    fetBackwardAll:Result:=Result + 'BACKWARD ALL';
  end;
  (*
  FETCH [ direction [ FROM | IN ] ] cursor_name
  *)
  if FCount <> '' then
    Result:=Result + ' ' + FCount;

  Result:=Result + ' FROM ' + FCursorName;
  AddSQLCommand(Result);
end;

procedure TPGSQLFetch.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLFetch then
  begin
    FetchType:=TPGSQLFetch(ASource).FetchType;
    Count:=TPGSQLFetch(ASource).Count;
    CursorName:=TPGSQLFetch(ASource).CursorName;

  end;
  inherited Assign(ASource);
end;

{ TPGSQLExplain }

procedure TPGSQLExplain.InitParserTree;
var
  FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для EXPLAIN }
  (*
EXPLAIN [ ( option [, ...] ) ] statement
EXPLAIN [ ANALYZE ] [ VERBOSE ] statement

where option can be one of:

    ANALYZE [ boolean ]
    VERBOSE [ boolean ]
    COSTS [ boolean ]
    BUFFERS [ boolean ]
    FORMAT { TEXT | XML | JSON | YAML }
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'EXPLAIN', [toFindWordLast, toFirstToken], 1);
end;

procedure TPGSQLExplain.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FSQLCommandText:=ASQLParser.GetToCommandDelemiter;
  end;
end;

procedure TPGSQLExplain.MakeSQL;
var
  S: String;
begin
  S:='EXPLAIN' + FSQLCommandText;
  AddSQLCommand(S);
end;

constructor TPGSQLExplain.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSelectable:=true;
  PlanEnabled:=false;
end;

procedure TPGSQLExplain.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLExplain  then
  begin
    FSQLCommandText:=TPGSQLExplain(ASource).FSQLCommandText;

  end;
  inherited Assign(ASource);
end;

{ TPGSQLExecute }

procedure TPGSQLExecute.InitParserTree;
var
  T, FSQLTokens, T1: TSQLTokenRecord;
begin
  (*
  EXECUTE name [ ( parameter [, ...] ) ]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'EXECUTE', [toFindWordLast, toFirstToken]);
    T:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
      T1:=AddSQLTokens(stSymbol, T, '.', []);
      T1:=AddSQLTokens(stIdentificator, T1, '', [], 2);
    T:=AddSQLTokens(stSymbol, [T, T1], '(', [toOptional], 3);
end;

procedure TPGSQLExecute.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    2:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
    3:StatementParams:=ASQLParser.GetToBracket(')');
  end;
end;

procedure TPGSQLExecute.MakeSQL;
var
  S: String;
begin
  if SchemaName <> '' then
    S:=SchemaName + '.' + Name
  else
    S:=Name;
  S:='EXECUTE '+S;

  if StatementParams <> '' then
    S:=S + '(' + StatementParams+')';
  AddSQLCommand(S);
end;

procedure TPGSQLExecute.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLExecute then
  begin
    StatementParams:=TPGSQLExecute(ASource).StatementParams;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLUnlisten }

procedure TPGSQLUnlisten.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  (* UNLISTEN { channel | * }  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'UNLISTEN', [toFindWordLast, toFirstToken]);
    T:=AddSQLTokens(stSymbol, FSQLTokens, '*', [], 2);
    T:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
end;

procedure TPGSQLUnlisten.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  if AChild.Tag = 1 then
    FChannel:=AWord;
end;

procedure TPGSQLUnlisten.MakeSQL;
var
  S: String;
begin
  S:='UNLISTEN ';
  if FChannel <> '' then
    S:=S+FChannel
  else
    S:=S + '*';
  AddSQLCommand(S);
end;

procedure TPGSQLUnlisten.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLUnlisten then
  begin
    Channel:=TPGSQLUnlisten(ASource).Channel;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLReindex }

procedure TPGSQLReindex.InitParserTree;
var
  T1, T2, T3, T4, T, FSQLTokens: TSQLTokenRecord;
begin
  (* REINDEX { INDEX | TABLE | DATABASE | SYSTEM } name [ FORCE ] *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'REINDEX', [toFirstToken]);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'INDEX', [toFindWordLast], 1);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'TABLE', [toFindWordLast], 2);
    T3:=AddSQLTokens(stKeyword, FSQLTokens, 'DATABASE', [toFindWordLast], 3);
    T4:=AddSQLTokens(stKeyword, FSQLTokens, 'SYSTEM', [toFindWordLast], 4);
  T:=AddSQLTokens(stIdentificator, [T1,T2, T3, T4], '', [], 5);
  T:=AddSQLTokens(stKeyword, T, 'FORCE', [toOptional], 6);
end;

procedure TPGSQLReindex.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:ObjectKind:=okIndex;
    2:ObjectKind:=okTable;
    3:ObjectKind:=okDatabase;
    4:ObjectKind:=okServer;
    5:Name:=AWord;
    6:Force:=true;
  end;
end;

procedure TPGSQLReindex.MakeSQL;
var
  Result: String;
begin
  Result:='REINDEX ';
  case ObjectKind of
    okIndex:Result:=Result + 'INDEX ';
    okTable:Result:=Result + 'TABLE ';
    okDatabase:Result:=Result + 'DATABASE ';
    okServer:Result:=Result + 'SYSTEM ';
  end;
  Result:=Result + Name;

  if FForce then
    Result:=Result + ' FORCE';
  AddSQLCommand(Result);
end;

procedure TPGSQLReindex.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLReindex then
  begin
    Force:=TPGSQLReindex(ASource).Force;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLValues }

procedure TPGSQLValues.InitParserTree;
var
  FSQLTokens, T, T1: TSQLTokenRecord;
begin
  (*
  VALUES ( expression [, ...] ) [, ...]
      [ ORDER BY sort_expression [ ASC | DESC | USING operator ] [, ...] ]
      [ LIMIT { count | ALL } ]
      [ OFFSET start [ ROW | ROWS ] ]
      [ FETCH { FIRST | NEXT } [ count ] { ROW | ROWS } ONLY ]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'VALUES', [toFindWordLast, toFirstToken]);
    T:=AddSQLTokens(stSymbol, FSQLTokens, '(', [], 1);
    //T:=AddSQLTokens(stSymbol, T, ')', []);
    T1:=AddSQLTokens(stSymbol, T, ',', [toOptional], 2);
      T1.AddChildToken(T);
end;

procedure TPGSQLValues.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
var
  FCurRec: TSQLParserField;
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FCurRec:=Params.AddParam(ASQLParser.GetToBracket(')'));
  end;
end;

procedure TPGSQLValues.MakeSQL;
var
  S, S1: String;
  P: TSQLParserField;
begin
  S:='VALUES';

  S1:='';
  for P in Params do
  begin
    if S1<>'' then S1:=S1 + ',' + LineEnding;
    S1:=S1 + '  (' + P.Caption + ')';
  end;
  S:=S + LineEnding + S1;
  AddSQLCommand(S);
end;

constructor TPGSQLValues.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSelectable:=true;
end;

{ TPGSQLDiscard }

procedure TPGSQLDiscard.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  (* DISCARD { ALL | PLANS | SEQUENCES | TEMPORARY | TEMP } *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DISCARD', [toFindWordLast, toFirstToken]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'ALL', [], 1);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'PLANS', [], 2);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'TEMPORARY', [], 3);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'TEMP', [], 3);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'SEQUENCES', [], 4);
end;

procedure TPGSQLDiscard.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:FDiscardType:=dtAll;
    2:FDiscardType:=dtPlans;
    3:FDiscardType:=dtTemporary;
    4:FDiscardType:=dtSequences;
  end;
end;

procedure TPGSQLDiscard.MakeSQL;
var
  S: String;
begin
  S:='DISCARD';
  case FDiscardType of
    dtAll:S:=S + ' ALL';
    dtPlans:S:=S + ' PLANS';
    dtTemporary:S:=S + ' TEMPORARY';
    dtSequences:S:=S + ' SEQUENCES';
  end;
  AddSQLCommand(S);
end;

procedure TPGSQLDiscard.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLDiscard then
  begin
    DiscardType:=TPGSQLDiscard(ASource).DiscardType;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLDeclare }

procedure TPGSQLDeclare.InitParserTree;
var
  T, FSQLTokens, T2, T3, T4, T5, T6, T7, TT: TSQLTokenRecord;
begin
  { TODO : Доработать парсер курсора }
  (*
  DECLARE name [ BINARY ] [ INSENSITIVE ] [ [ NO ] SCROLL ]
    CURSOR [ { WITH | WITHOUT } HOLD ] FOR query
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DECLARE', [toFindWordLast, toFirstToken]);
    T:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);

  T2:=AddSQLTokens(stKeyword, T, 'BINARY', [], 2);
  T3:=AddSQLTokens(stKeyword, T, 'INSENSITIVE', [], 3);
  T4:=AddSQLTokens(stKeyword, T, 'NO', [], 4);
  T5:=AddSQLTokens(stKeyword, [T, T4], 'SCROLL', [], 5);
    T2.AddChildToken([T3, T4, T5]);
    T3.AddChildToken([T2, T4, T5]);
    T5.AddChildToken([T2, T3, T4]);

  T:=AddSQLTokens(stKeyword, [T, T2, T3, T5], 'CURSOR', []);

  T6:=AddSQLTokens(stKeyword, T, 'WITH', [], 6);
  T7:=AddSQLTokens(stKeyword, T, 'WITHOUT', [], 7);
  TT:=AddSQLTokens(stKeyword, T6, 'HOLD', [], 9);
  T7.AddChildToken(TT);
  T:=AddSQLTokens(stKeyword, T, 'FOR', [], 8);
  TT.AddChildToken(T);
end;

procedure TPGSQLDeclare.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    2:FOptions:=FOptions + [doBinary];
    3:FOptions:=FOptions + [doInsensitive];
    4:FOptions:=FOptions + [doNoScroll];
    5:if not (doNoScroll in FOptions) then
        FOptions:=FOptions + [doScroll];
    6:FOptions:=FOptions + [doWith];
    7:FOptions:=FOptions + [doWithout];
    9:FOptions:=FOptions + [doHold];
    8:FQueryText:=ASQLParser.GetToCommandDelemiter;
  end;
end;

procedure TPGSQLDeclare.MakeSQL;
var
  S: String;
begin
  S:='DECLARE '+Name;
  if doBinary in FOptions then
    S:=S + ' BINARY';

  if doInsensitive in FOptions then
    S:=S + ' INSENSITIVE';

  if doNoScroll in FOptions then
    S:=S + ' NO SCROLL'
  else
  if doScroll in FOptions then
    S:=S + ' SCROLL';

  S:=S + ' CURSOR';

  if doWith in Options then
    S:=S + ' WITH';
  if doWithout in Options then
    S:=S + ' WITHOUT';
  if doHold in Options then
    S:=S + ' HOLD';

  S:=S + ' FOR';
  if (FQueryText<>'') and (TrimLeft(FQueryText) = FQueryText) then
    S:=S+' ';
  S:=S + FQueryText;
  AddSQLCommand(S);
end;

constructor TPGSQLDeclare.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FOptions:=[];
end;

procedure TPGSQLDeclare.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLDeclare then
  begin
    Options:=TPGSQLDeclare(ASource).Options;
    QueryText:=TPGSQLDeclare(ASource).QueryText;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLDeallocate }

procedure TPGSQLDeallocate.InitParserTree;
var
  T, T1, FSQLTokens: TSQLTokenRecord;
begin
  (* DEALLOCATE [ PREPARE ] { name | ALL } *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DEALLOCATE', [toFindWordLast, toFirstToken]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'PREPARE', []);
  T1:=AddSQLTokens(stKeyword, T, 'ALL', []);
  T1:=AddSQLTokens(stIdentificator, T, '', [], 1);
end;

procedure TPGSQLDeallocate.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  if AChild.Tag = 1 then
    FStatementName:=AWord;
end;

procedure TPGSQLDeallocate.MakeSQL;
var
  Result: String;
begin
  Result:='DEALLOCATE PREPARE ';
  if FStatementName <> '' then
    Result:=Result + FStatementName
  else
    Result:=Result + 'ALL';
  AddSQLCommand(Result);
end;

procedure TPGSQLDeallocate.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLDeallocate then
  begin
    StatementName:=TPGSQLDeallocate(ASource).StatementName;

  end;
  inherited Assign(ASource);
end;

{ TPGSQLCopy }

procedure TPGSQLCopy.InitParserTree;
var
  FSQLTokens, T1, T2, T, T4, T5, T6, T7_1, T3, T7, T8, T9, T10,
    T10_1, T11, T11_1, T12_1, T12, T14, T13, T13_1, T14_1, T15,
    T15_1, T16, T16_1, TT, T20, T21, T21_1, T17, T17_1, T21_2: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать команду COPY - разбор SELECT и VALUES}

  (*
  COPY имя_таблицы [ ( имя_столбца [, ...] ) ]
      FROM { 'имя_файла' | PROGRAM 'команда' | STDIN }
      [ [ WITH ] ( параметр [, ...] ) ]

  COPY { имя_таблицы [ ( имя_столбца [, ...] ) ] | ( запрос ) }
      TO { 'имя_файла' | PROGRAM 'команда' | STDOUT }
      [ [ WITH ] ( параметр [, ...] ) ]

  Здесь допускается параметр:

      FORMAT имя_формата
      OIDS [ boolean ]
      FREEZE [ boolean ]
      DELIMITER 'символ_разделитель'
      NULL 'маркер_NULL'
      HEADER [ boolean ]
      QUOTE 'символ_кавычек'
      ESCAPE 'символ_экранирования'
      FORCE_QUOTE { ( имя_столбца [, ...] ) | * }
      FORCE_NOT_NULL ( имя_столбца [, ...] )
      FORCE_NULL ( имя_столбца [, ...] )
      ENCODING 'имя_кодировки'
*)

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'COPY', [toFindWordLast, toFirstToken]);
  T1:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
  T:=AddSQLTokens(stSymbol, T1, '.', []);
  T2:=AddSQLTokens(stIdentificator, T, '', [], 2);
  T:=AddSQLTokens(stSymbol, T1, '(', []);
  T2.AddChildToken(T);
  T3:=AddSQLTokens(stIdentificator, T, '', [], 3);
  T:=AddSQLTokens(stSymbol, T3, ',', []);
  T.AddChildToken(T3);
  T:=AddSQLTokens(stSymbol, T3, ')', []);

  T20:=AddSQLTokens(stKeyword, T, 'TO', []);
  T1.AddChildToken(T20);
  T2.AddChildToken(T20);
  T21:=AddSQLTokens(stString, T20, '', [], 21);
  T21_1:=AddSQLTokens(stKeyword, T20, 'STDOUT', [],  21);
  T21_2:=AddSQLTokens(stKeyword, T20, 'PROGRAM', [],  22);
  T21_2:=AddSQLTokens(stString, T21_2, '', [],  21);

  T:=AddSQLTokens(stKeyword, T, 'FROM', []);
  T1.AddChildToken(T);
  T2.AddChildToken(T);


  T4:=AddSQLTokens(stString, T, '', [], 4);
  T5:=AddSQLTokens(stKeyword, T, 'STDIN', [], 4);
  T:=AddSQLTokens(stKeyword, T4, 'WITH', []);
  T5.AddChildToken(T);
  T21.AddChildToken(T);
  T21_1.AddChildToken(T);

  T6:=AddSQLTokens(stSymbol, T, '(', []);
  T4.AddChildToken(T6);
  T5.AddChildToken(T6);
  T21.AddChildToken(T6);
  T21_1.AddChildToken(T6);

  T7:=AddSQLTokens(stKeyword, T6, 'FORMAT', []);
  T7_1:=AddSQLTokens(stIdentificator, T7, '', [], 7);
//  T:=AddSQLTokens(stSymbol, T7_1, ',', []);

  T8:=AddSQLTokens(stKeyword, T6, 'OIDS', [], 8);
  T9:=AddSQLTokens(stIdentificator, T, '', [], 9);

  T10:=AddSQLTokens(stKeyword, T6, 'DELIMITER', []);
  T10_1:=AddSQLTokens(stString, T10, '', [], 10);

  T11:=AddSQLTokens(stKeyword, T6, 'NULL', []);
  T11_1:=AddSQLTokens(stString, T11, '', [], 11);

  T12:=AddSQLTokens(stKeyword, T6, 'HEADER', []);
  T12_1:=AddSQLTokens(stString, T12, '', [], 12);

  T13:=AddSQLTokens(stKeyword, T6, 'QUOTE', []);
  T13_1:=AddSQLTokens(stString, T13, '', [], 13);

  T14:=AddSQLTokens(stKeyword, T6, 'ESCAPE', []);
  T14_1:=AddSQLTokens(stString, T14, '', [], 14);

  T15:=AddSQLTokens(stKeyword, T6, 'ENCODING', []);
  T15_1:=AddSQLTokens(stString, T15, '', [],  15);

  T16:=AddSQLTokens(stKeyword, T6, 'FORCE_QUOTE', []);
  T16_1:=AddSQLTokens(stSymbol, T16, '*', [], 16);
  T16_1:=AddSQLTokens(stSymbol, T16, '(', []);
  T16_1:=AddSQLTokens(stIdentificator, T16_1, '', [], 16);
  TT:=AddSQLTokens(stSymbol, T16_1, ',', []);
  TT.AddChildToken(T16_1);
  T16_1:=AddSQLTokens(stSymbol, T16_1, ')', []);

  T17:=AddSQLTokens(stKeyword, T6, 'FORCE_NOT_NULL', []);
  T17_1:=AddSQLTokens(stSymbol, T17, '(', []);
  T17_1:=AddSQLTokens(stIdentificator, T17_1, '', [], 17);
  TT:=AddSQLTokens(stSymbol, T17_1, ',', []);
  TT.AddChildToken(T17_1);
  T17_1:=AddSQLTokens(stSymbol, T17_1, ')', []);


  T7_1.AddChildToken(T);
  T8.AddChildToken(T);
  T10_1.AddChildToken(T);
  T11_1.AddChildToken(T);
  T12_1.AddChildToken(T);
  T13_1.AddChildToken(T);
  T14_1.AddChildToken(T);
  T15_1.AddChildToken(T);
  T.AddChildToken([T7, T8, T10, T11, T12, T13, T14, T15, T16]);

  T:=AddSQLTokens(stSymbol, T7_1, ')', []);
//  T7_1.AddChildToken(T);
  T8.AddChildToken(T);
  T10_1.AddChildToken(T);
  T11_1.AddChildToken(T);
  T12_1.AddChildToken(T);
  T13_1.AddChildToken(T);
  T14_1.AddChildToken(T);
  T15_1.AddChildToken(T);
  T16_1.AddChildToken(T);


  T9.CopyChildTokens(T8);
//  T10_1.AddChildToken(T);
end;

procedure TPGSQLCopy.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:TableName:=AWord;
    2:begin
        SchemaName:=TableName;
        TableName:=AWord;
      end;
    3:Params.AddParam(AWord);
    4:begin
        FFileName:=AWord;
        FCopyType:=cptFrom;
      end;
    7:FFormatName:=AWord;
    8:FOIDS:=true;
    9:FOIDS:=StrToBool(AWord);
    10:FDelimiter:=AWord;
    11:FNullString:=AWord;
    12:FHeader:=StrToBool(AWord);
    13:FQuoteCharacter:=AWord;
    14:FEscapeCharacter:=AWord;
    15:FEncodingName:=AWord;
    16:QuoteColumns.AddParam(AWord);
    17:NotNullColumn.AddParam(AWord);
    21:begin
        FFileName:=AWord;
        FCopyType:=cptTo;
      end;
    22:FIsProgramm:=true;
  end;
end;

constructor TPGSQLCopy.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FQuoteColumns:=TSQLFields.Create;
  FNotNullColumn:=TSQLFields.Create;
end;

destructor TPGSQLCopy.Destroy;
begin
  FreeAndNil(FQuoteColumns);
  FreeAndNil(FNotNullColumn);
  inherited Destroy;
end;

procedure TPGSQLCopy.MakeSQL;
var
  S, Result: String;
begin
  Result:='COPY ';

  if FCopyType = cptFrom then
  begin
    Result:=Result  + TableName;
    if Params.Count>0 then
      Result:=Result  + ' ('+Params.AsString + ')';
    Result:=Result + ' FROM '+FFileName;

  end
  else
  if FCopyType = cptTo then
  begin
    Result:=Result  + TableName;
    if Params.Count>0 then
      Result:=Result  + ' ('+Params.AsString + ')';
    Result:=Result + ' TO ';

    if FIsProgramm then
      Result:=Result + 'PROGRAM ';

    Result:=Result + FFileName;
  end;


  S:='';

  if FOIDS then
    S:=S + ', OIDS';

  if FDelimiter <> '' then
    S:=S + ', DELIMITER ' + FDelimiter;

  if FHeader then
    S:=S + ', HEADER ' + BoolToStr(FHeader);

  if FNullString <> '' then
    S:=S + ', NULL ' + FNullString;

  if FQuoteCharacter <> '' then
    S:=S + ', QUOTE ' + FQuoteCharacter;

  if FEscapeCharacter <> '' then
    S:=S + ', ESCAPE ' + FEscapeCharacter;

  if FEncodingName <> '' then
    S:=S + ', ENCODING ' + FEncodingName;


  if FQuoteColumns.Count > 0 then
  begin
    if FQuoteColumns.AsString = '*' then
      S:=S + ', FORCE_QUOTE ' + FQuoteColumns.AsString
    else
      S:=S + ', FORCE_QUOTE (' + FQuoteColumns.AsString + ')';
  end;

  if FNotNullColumn.Count > 0 then
      S:=S + ', FORCE_NOT_NULL (' + FQuoteColumns.AsString + ')';

  if S<>'' then
    Result:=Result + ' WITH (' + Copy(S, 3, Length(S)) + ')';

  AddSQLCommand(Result);
end;

procedure TPGSQLCopy.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLCopy then
  begin
    FileName:=TPGSQLCopy(ASource).FileName;
    FormatName:=TPGSQLCopy(ASource).FormatName;
    CopyType:=TPGSQLCopy(ASource).CopyType;
    OIDS:=TPGSQLCopy(ASource).OIDS;
    Delimiter:=TPGSQLCopy(ASource).Delimiter;
    NullString:=TPGSQLCopy(ASource).NullString;
    Header:=TPGSQLCopy(ASource).Header;
    QuoteCharacter:=TPGSQLCopy(ASource).QuoteCharacter;
    EscapeCharacter:=TPGSQLCopy(ASource).EscapeCharacter;
    EncodingName:=TPGSQLCopy(ASource).EncodingName;

    QuoteColumns.Assign(TPGSQLCopy(ASource).QuoteColumns);
    NotNullColumn.Assign(TPGSQLCopy(ASource).NotNullColumn);
  end;
  inherited Assign(ASource);
end;

{ TPGSQLCluster }

procedure TPGSQLCluster.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  (*
  CLUSTER [VERBOSE] table_name [ USING index_name ]
  CLUSTER [VERBOSE]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CLUSTER', [toFindWordLast, toFirstToken]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'VERBOSE', [toOptional], 3);

  T:=AddSQLTokens(stIdentificator, T, '', [toOptional], 1);
  FSQLTokens.AddChildToken(T);
  T:=AddSQLTokens(stKeyword, T, 'USING', [toOptional]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 2);
end;

procedure TPGSQLCluster.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:FTableName:=AWord;
    2:FIndexName:=AWord;
    3:FVerbose:=true;
  end;
end;

procedure TPGSQLCluster.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLCluster then
  begin
    Verbose:=TPGSQLCluster(ASource).Verbose;
    TableName:=TPGSQLCluster(ASource).TableName;
    IndexName:=TPGSQLCluster(ASource).IndexName;
  end;
  inherited Assign(ASource);
end;

procedure TPGSQLCluster.MakeSQL;
var
  Result: String;
begin
  Result:='CLUSTER';
  if FVerbose then
    Result:=Result + ' VERBOSE';

  if FTableName <> '' then
    Result:=Result + ' ' + FTableName;

  if FIndexName <> '' then
    Result:=Result + ' USING ' + FIndexName;
  AddSQLCommand(Result);
end;

{ TPGSQLClose }

procedure TPGSQLClose.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  (* CLOSE { name | ALL } *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CLOSE', [toFindWordLast, toFirstToken]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'ALL', []);
    T:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
end;

procedure TPGSQLClose.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  if AChild.Tag = 1 then
    FCursorName:=AWord;
end;

procedure TPGSQLClose.MakeSQL;
var
  S: String;
begin
  if FCursorName <> '' then
    S:='CLOSE ' + FCursorName
  else
    S:='CLOSE ALL';
  AddSQLCommand(S);
end;

procedure TPGSQLClose.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLClose then
  begin
    CursorName:=TPGSQLClose(ASource).CursorName;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLCheckpoint }

procedure TPGSQLCheckpoint.InitParserTree;
var
  FSQLTokens: TSQLTokenRecord;
begin
  (* CHECKPOINT *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CHECKPOINT', [toFindWordLast, toFirstToken]);
end;

procedure TPGSQLCheckpoint.MakeSQL;
begin
  AddSQLCommand('CHECKPOINT');
end;

{ TPGSQLShow }

procedure TPGSQLShow.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  (* SHOW name *)
  (* SHOW ALL *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'SHOW', [toFindWordLast, toFirstToken]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'ALL', []);
    T:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
end;

procedure TPGSQLShow.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  if AChild.Tag = 1 then
    FParamName:=AWord;
end;

procedure TPGSQLShow.MakeSQL;
var
  S: String;
begin
  if FParamName <> '' then
    S:='SHOW ' + FParamName
  else
    S:='SHOW ALL';
  AddSQLCommand(S);
end;

procedure TPGSQLShow.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLShow then
  begin
    ParamName:=TPGSQLShow(ASource).ParamName;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLEnd }

procedure TPGSQLEnd.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  (*
  END [ WORK | TRANSACTION ]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'END', [toFindWordLast, toFirstToken]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'WORK', [], 1);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'TRANSACTION', [], 2);
end;

procedure TPGSQLEnd.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FEndType:=atWork;
    2:FEndType:=atTransaction;
  end;
end;

procedure TPGSQLEnd.MakeSQL;
var
  S: String;
begin
  S:='END';
  case FEndType of
    atWork:S:=S + ' WORK';
    atTransaction:S:=S + ' TRANSACTION';
  end;
  AddSQLCommand(S);
end;

procedure TPGSQLEnd.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLEnd then
  begin
    FEndType:=TPGSQLEnd(ASource).EndType;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLDropTablespace }

procedure TPGSQLDropTablespace.InitParserTree;
var
  T, T1, FSQLTokens: TSQLTokenRecord;
begin
  (* DROP TABLESPACE [ IF EXISTS ] tablespace_name *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okTableSpace);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'TABLESPACE', [toFindWordLast]);   //
  T1:=AddSQLTokens(stKeyword, T, 'IF', [],  -1);
  T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);
  T:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 2);   //
    T1.AddChildToken(T);
end;

procedure TPGSQLDropTablespace.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  if AChild.Tag = 2 then
    FTablespaceName:=AWord;
end;

procedure TPGSQLDropTablespace.MakeSQL;
var
  Result: String;
begin
  Result:='DROP TABLESPACE ';
  if ooIfExists in Options  then
    Result:=Result + 'IF EXISTS ';
  Result:=Result + FTablespaceName;
  AddSQLCommand(Result);
end;

procedure TPGSQLDropTablespace.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLDropTablespace then
  begin
    TablespaceName:=TPGSQLDropTablespace(ASource).TablespaceName;

  end;
  inherited Assign(ASource);
end;

{ TPGSQLAlterTablespace }

procedure TPGSQLAlterTablespace.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  (*
  ALTER TABLESPACE name RENAME TO new_name
  ALTER TABLESPACE name OWNER TO new_owner
  ALTER TABLESPACE name SET ( tablespace_option = value [, ... ] )
  ALTER TABLESPACE name RESET ( tablespace_option [, ... ] )
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken], 0, okTableSpace);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'TABLESPACE', [toFindWordLast]);
  FTTableSpaceName:=AddSQLTokens(stIdentificator, T, '', []);

  T:=AddSQLTokens(stKeyword, FTTableSpaceName, 'RENAME', []);
  T:=AddSQLTokens(stKeyword, T, 'TO', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);

  T:=AddSQLTokens(stKeyword, FTTableSpaceName, 'OWNER', []);
  T:=AddSQLTokens(stKeyword, T, 'TO', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 2);
  { TODO : Необходимо доработать парсер ALTER TABLESPACE name SET ( tablespace_option = value [, ... ] )
ALTER TABLESPACE name RESET ( tablespace_option [, ... ] ) }
end;

procedure TPGSQLAlterTablespace.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  if AChild = FTTableSpaceName then
    FTableSpaceName:=AWord
  else
  if AChild.Tag = 1 then
    FTablespaceNameNew:=AWord
  else
  if AChild.Tag = 2 then
    FOwnerNameNew:=AWord
  ;
end;

constructor TPGSQLAlterTablespace.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okTableSpace;
  FSQLCommentOnClass:=TPGSQLCommentOn;
end;

procedure TPGSQLAlterTablespace.MakeSQL;
var
  Result: String;
begin
  Result:='ALTER TABLESPACE '+FTablespaceName;

  if FTablespaceNameNew <> '' then
    Result:=Result + ' RENAME TO '+FTablespaceNameNew
  else
  if FOwnerNameNew <> '' then;
    Result:=Result + ' OWNER TO '+FTablespaceNameNew;
  AddSQLCommand(Result);
end;

procedure TPGSQLAlterTablespace.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLAlterTablespace then
  begin
    TablespaceName:=TPGSQLAlterTablespace(ASource).TablespaceName;
    TablespaceNameNew:=TPGSQLAlterTablespace(ASource).TablespaceNameNew;
    OwnerNameNew:=TPGSQLAlterTablespace(ASource).OwnerNameNew;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLCreateTablespace }

procedure TPGSQLCreateTablespace.InitParserTree;
var
  T, T1, FSQLTokens: TSQLTokenRecord;
begin
  (* CREATE TABLESPACE tablespace_name [ OWNER user_name ] LOCATION 'directory' *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okTableSpace);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'TABLESPACE', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
    T1:=AddSQLTokens(stKeyword, T, 'OWNER', []);
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 2);
  T:=AddSQLTokens(stKeyword, T, 'LOCATION', []);
    T1.AddChildToken(T);
  T:=AddSQLTokens(stString, T, '', [], 3);
end;

procedure TPGSQLCreateTablespace.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FTablespaceName:=AWord;
    2:FOwnerName:=AWord;
    3:FDirectory:=AWord;
  end;
end;

constructor TPGSQLCreateTablespace.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okTableSpace;
  FSQLCommentOnClass:=TPGSQLCommentOn;
end;

procedure TPGSQLCreateTablespace.MakeSQL;
var
  Result: String;
begin
  Result:='CREATE TABLESPACE ' + FTablespaceName;

  if FOwnerName <> '' then
    Result:=Result + ' OWNER '+FOwnerName;
  Result:=Result + ' LOCATION ' + FDirectory;
  AddSQLCommand(Result);
end;

procedure TPGSQLCreateTablespace.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLCreateTablespace then
  begin
    TablespaceName:=TPGSQLCreateTablespace(ASource).TablespaceName;
    OwnerName:=TPGSQLCreateTablespace(ASource).OwnerName;
    Directory:=TPGSQLCreateTablespace(ASource).Directory;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLAnalyze }

procedure TPGSQLAnalyze.InitParserTree;
var
  T1, T, FSQLTokens, TSymb: TSQLTokenRecord;
begin
  (* ANALYZE [ VERBOSE ] [ table [ ( column [, ...] ) ] ] *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ANALYZE', [toFindWordLast, toFirstToken]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'VERBOSE', [], 1);
  T:=AddSQLTokens(stIdentificator, [FSQLTokens, T], '', [], 2);
    TSymb:=AddSQLTokens(stSymbol, T, '.', []);
    T1:=AddSQLTokens(stIdentificator, TSymb, '', [], 4);

  T1:=AddSQLTokens(stSymbol, [T, T1], '(', [toOptional]);
  T1:=AddSQLTokens(stIdentificator, T, '', [], 3);
  T:=AddSQLTokens(stSymbol, T1, ',', []);
    T.AddChildToken(T1);

  T:=AddSQLTokens(stSymbol, T1, ')', [], 3);

end;

procedure TPGSQLAnalyze.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FVerbose:=true;
    2:Name:=AWord;
    3:Params.AddParam(AWord);
    4:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
  end;
end;

procedure TPGSQLAnalyze.MakeSQL;
var
  Result: String;
begin
  Result:='ANALYZE';
  if FVerbose then
    Result:=Result + ' VERBOSE';

  if FullName <> '' then
  begin
    Result:=Result + ' ' + FullName;
    if Params.Count > 0 then
      Result:=Result + ' (' +Params.AsString+')';
  end;
  AddSQLCommand(Result);
end;

procedure TPGSQLAnalyze.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLAnalyze then
  begin
    Verbose:=TPGSQLAnalyze(ASource).Verbose;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLSet }

procedure TPGSQLSet.InitParserTree;
var
  FSQLTokens, T1, T2, T, TV, T8, T8_1, T11, T12, T16, T15,
    T21, T22, T23, T24, T25, T7, T27, T16_1, T29, T13, T26,
    TSymb: TSQLTokenRecord;
begin
  (*
  SET [ SESSION | LOCAL ] configuration_parameter { TO | = } { value | 'value' | DEFAULT }
  SET [ SESSION | LOCAL ] TIME ZONE { timezone | LOCAL | DEFAULT }

  SET CONSTRAINTS { ALL | name [, ...] } { DEFERRED | IMMEDIATE }

  SET [ SESSION | LOCAL ] ROLE role_name
  SET [ SESSION | LOCAL ] ROLE NONE

  SET [ SESSION | LOCAL ] SESSION AUTHORIZATION user_name
  SET [ SESSION | LOCAL ] SESSION AUTHORIZATION DEFAULT

  SET TRANSACTION transaction_mode [, ...]
  SET SESSION CHARACTERISTICS AS TRANSACTION transaction_mode [, ...]

where transaction_mode is one of:

    ISOLATION LEVEL { SERIALIZABLE | REPEATABLE READ | READ COMMITTED | READ UNCOMMITTED }
    READ WRITE | READ ONLY
    [ NOT ] DEFERRABLE
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'SET', [toFindWordLast, toFirstToken]);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'SESSION', [], 1);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'LOCAL', [], 2);
    T:=AddSQLTokens(stIdentificator, [FSQLTokens, T1, T2], '', [], 3);

    T1:=AddSQLTokens(stSymbol, T, '=', [], 17);
    T2:=AddSQLTokens(stKeyword, T, 'TO', [], 18);

    TSymb:=AddSQLTokens(stSymbol, T, ',', [toOptional], 99);
      AddSQLTokens(stIdentificator, [T, T1, T2, TSymb], '', [], 4).AddChildToken(TSymb);
      AddSQLTokens(stString, [T, T1, T2, TSymb], '', [], 4).AddChildToken(TSymb);
      AddSQLTokens(stInteger, [T, T1, T2, TSymb], '', [], 4).AddChildToken(TSymb);

    AddSQLTokens(stKeyword, [T, T1, T2], 'DEFAULT', [], 4);
    AddSQLTokens(stKeyword, [T, T1, T2], 'OFF', [], 4);
    AddSQLTokens(stKeyword, [T, T1, T2], 'ON', [], 4);
    AddSQLTokens(stKeyword, [T, T1, T2], 'TRUE', [], 4);
    AddSQLTokens(stKeyword, [T, T1, T2], 'FALSE', [], 4);

    T:=AddSQLTokens(stKeyword, FSQLTokens, 'TIME', [], 5);
    T1.AddChildToken(T);
    T2.AddChildToken(T);
    T:=AddSQLTokens(stKeyword, T, 'ZONE', []);
    AddSQLTokens(stIdentificator, T, '', [], 6);
    AddSQLTokens(stString, T, '', [],  6);
    AddSQLTokens(stKeyword, T, 'LOCAL', [], 6);
    AddSQLTokens(stKeyword, T, 'DEFAULT', [], 6);

    T:=AddSQLTokens(stKeyword, FSQLTokens, 'CONSTRAINTS', [], 7);
    T8:=AddSQLTokens(stKeyword, T, 'ALL', [], 8);
    T8_1:=AddSQLTokens(stIdentificator, T, '', [], 8);

    TSymb:=AddSQLTokens(stSymbol, T8_1, ',', []);
      TSymb.AddChildToken(T8_1);

    T8_1.AddChildToken(AddSQLTokens(stKeyword, T8, 'DEFERRED', [], 9));
    T8_1.AddChildToken(AddSQLTokens(stKeyword, T8, 'IMMEDIATE', [], 10));

    T11:=AddSQLTokens(stKeyword, FSQLTokens, 'ROLE', [],  11);
    AddSQLTokens(stIdentificator, T11, '', [], 12);
    AddSQLTokens(stString, T11, '', [], 12);
    AddSQLTokens(stKeyword, T11, 'NONE', [], 12);

    T1.AddChildToken(T11);

    T13:=AddSQLTokens(stKeyword, FSQLTokens, 'SESSION', [], 13);
    T1.AddChildToken(T13);
    T13:=AddSQLTokens(stKeyword, T13, 'AUTHORIZATION', []);
    AddSQLTokens(stKeyword, T13, 'DEFAULT', [], 14);
    AddSQLTokens(stIdentificator, T13, '', [], 14);

    T15:=AddSQLTokens(stKeyword, FSQLTokens, 'TRANSACTION', [], 15);
    T1.AddChildToken(T15);

    T16:=AddSQLTokens(stKeyword, T13, 'CHARACTERISTICS', [], 16);
    T16_1:=AddSQLTokens(stKeyword, T16, 'AS', []);
    T16_1:=AddSQLTokens(stKeyword, T16_1, 'TRANSACTION', []);


    T:=AddSQLTokens(stKeyword, T16_1, 'ISOLATION', []);
      T15.AddChildToken(T);
    T:=AddSQLTokens(stKeyword, T, 'LEVEL', []);
    T21:=AddSQLTokens(stKeyword, T, 'SERIALIZABLE', [], 21);
    T22:=AddSQLTokens(stKeyword, T, 'REPEATABLE', []);
    T22:=AddSQLTokens(stKeyword, T22, 'READ', [], 22);

    T23:=AddSQLTokens(stKeyword, T, 'READ', []);
    T24:=AddSQLTokens(stKeyword, T23, 'COMMITTED', [], 24);
    T25:=AddSQLTokens(stKeyword, T23, 'UNCOMMITTED', [], 25);

    T:=AddSQLTokens(stKeyword, T16_1, 'READ', []);
    T15.AddChildToken(T);
    T26:=AddSQLTokens(stKeyword, T, 'WRITE', [],  26);
    T27:=AddSQLTokens(stKeyword, T, 'ONLY', [], 27);

    T:=AddSQLTokens(stKeyword, T16_1, 'NOT', [], 28);
    T15.AddChildToken(T);
    T29:=AddSQLTokens(stKeyword, FSQLTokens, 'DEFERRABLE', [], 29);
    T.AddChildToken(T29);

    T2.CopyChildTokens(T1);
end;

procedure TPGSQLSet.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FSetScope:=ssSession;
    2:FSetScope:=ssLocal;
    3:FConfigurationParameter:=AWord;
    4:begin
        FConfigurationParameterValue:=AWord;
        Params.AddParam(AWord);
      end;
    6:FTimeZone:=AWord;
    7:FIsConstraints:=true;
    8:Params.AddParam(AWord);
    9:FTimeScope:=tsDeferred;
    10:FTimeScope:=tsImmediate;
    12:FRoleName:=AWord;
    14:FSessionAuthorizationUserName:=AWord;
    15:FTransaction:=true;
    16:FSessionTransaction:=true;
    17:SetVarType:=svtSet;
    18:SetVarType:=svtSetTO;
    21:FIsolationLevel:=ilSerializable;
    22:FIsolationLevel:=ilRepeatableRead;
    24:FIsolationLevel:=ilReadCommitted;
    25:FIsolationLevel:=ilReadUncommitted;
    26:FReadOnly:=false;
    27:FReadOnly:=true;
    28:FNotDeferrable:=true;
  end;
end;

procedure TPGSQLSet.MakeSQL;
var
  Result, S1: String;
begin
  Result:='SET';
  if FSetScope = ssSession then
    Result:=Result + ' SESSION'
  else
  if FSetScope = ssSession then
    Result:=Result + ' LOCAL';

  if FConfigurationParameter <> '' then
  begin
    if SetVarType = svtSetTO then
      S1:=' TO '
    else
      S1:=' = ';

    if Params.Count > 1 then
      Result:=Result + ' ' + FConfigurationParameter + S1 + Params.AsString
    else
      Result:=Result + ' ' + FConfigurationParameter + S1 + FConfigurationParameterValue
  end
  else
  if FTimeZone <> '' then
    Result:=Result + ' TIME ZONE ' + FTimeZone
  else
  if FIsConstraints then
  begin
    Result:=Result + ' CONSTRAINTS ' + Params.AsString;
    if FTimeScope = tsImmediate then
      Result:=Result + ' IMMEDIATE'
    else
    if FTimeScope = tsDeferred then
      Result:=Result + ' DEFERRED'
      ;
  end
  else
  if FRoleName <> '' then
    Result:=Result + ' ROLE '+FRoleName
  else
  if FSessionAuthorizationUserName <> '' then
    Result:=Result + ' SESSION AUTHORIZATION '+FSessionAuthorizationUserName
  else
  if FTransaction or FSessionTransaction then
  begin
    if FTransaction then
      Result:=Result + ' SET TRANSACTION '
    else
      Result:=Result + ' SET SESSION CHARACTERISTICS AS TRANSACTION ';

    if FIsolationLevel <> ilNone then
    begin
      case FIsolationLevel of
        ilSerializable:Result:=Result + ' ISOLATION LEVEL SERIALIZABLE';
        ilRepeatableRead:Result:=Result + ' ISOLATION LEVEL REPEATABLE READ';
        ilReadCommitted:Result:=Result + ' ISOLATION LEVEL READ COMMITTED';
        ilReadUncommitted:Result:=Result + ' ISOLATION LEVEL READ UNCOMMITTED';
      end;
    end
    else
    if FReadOnly then
      Result:=Result + ' READ ONLY'
    else
      Result:=Result + ' READ WRITE'
    ;

    if FNotDeferrable then
      Result:=Result + ' NOT DEFERRABLE'
  end;
  AddSQLCommand(Result);
end;

procedure TPGSQLSet.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLSet then
  begin
    SetScope:=TPGSQLSet(ASource).SetScope;
    ConfigurationParameter:=TPGSQLSet(ASource).ConfigurationParameter;
    ConfigurationParameterValue:=TPGSQLSet(ASource).ConfigurationParameterValue;
    TimeZone:=TPGSQLSet(ASource).TimeZone;
    TimeScope:=TPGSQLSet(ASource).TimeScope;
    IsConstraints:=TPGSQLSet(ASource).IsConstraints;
    RoleName:=TPGSQLSet(ASource).RoleName;
    SessionAuthorizationUserName:=TPGSQLSet(ASource).SessionAuthorizationUserName;
    Transaction:=TPGSQLSet(ASource).Transaction;
    SessionTransaction:=TPGSQLSet(ASource).SessionTransaction;
    ReadOnly:=TPGSQLSet(ASource).ReadOnly;
    IsolationLevel:=TPGSQLSet(ASource).IsolationLevel;
    NotDeferrable:=TPGSQLSet(ASource).NotDeferrable;
    SetVarType:=TPGSQLSet(ASource).SetVarType;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLBegin }

procedure TPGSQLBegin.InitParserTree;
var
  T, FSQLTokens, T1, T2, T3, T5, T5_1, T7, T8, T9, T4: TSQLTokenRecord;
begin
  (*
  BEGIN [ WORK | TRANSACTION ] [ transaction_mode [, ...] ]

where transaction_mode is one of:

    ISOLATION LEVEL { SERIALIZABLE | REPEATABLE READ | READ COMMITTED | READ UNCOMMITTED }
    READ WRITE | READ ONLY
    [ NOT ] DEFERRABLE
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'BEGIN', [toFindWordLast, toFirstToken]);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'WORK', [toOptional], 21);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'TRANSACTION', [toOptional], 22);

  T:=AddSQLTokens(stKeyword, FSQLTokens, 'ISOLATION', [toOptional]);
  T1.AddChildToken(T);
  T:=AddSQLTokens(stKeyword, T, 'LEVEL', []);
  T3:=AddSQLTokens(stKeyword, T, 'SERIALIZABLE', [],  3);
  T4:=AddSQLTokens(stKeyword, T, 'REPEATABLE', []);
  T4:=AddSQLTokens(stKeyword, T4, 'READ', [], 4);

  T5:=AddSQLTokens(stKeyword, T, 'READ', []);
  T5_1:=AddSQLTokens(stKeyword, T5, 'COMMITTED', [], 5);
  T5_1:=AddSQLTokens(stKeyword, T5, 'UNCOMMITTED', [], 6);

  T:=AddSQLTokens(stKeyword, FSQLTokens, 'READ', [toOptional]);
  T7:=AddSQLTokens(stKeyword, T, 'WRITE', [], 7);
  T8:=AddSQLTokens(stKeyword, T, 'ONLY', [], 8);

  T:=AddSQLTokens(stKeyword, FSQLTokens, 'NOT', [toOptional], 10);
  T9:=AddSQLTokens(stKeyword, FSQLTokens, 'DEFERRABLE', [toOptional], 9);
  T.AddChildToken(T9);

  T2.CopyChildTokens(T1);
end;

procedure TPGSQLBegin.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    3:FIsolationLevel:=ilSerializable;
    4:FIsolationLevel:=ilRepeatableRead;
    5:FIsolationLevel:=ilReadCommitted;
    6:FIsolationLevel:=ilReadUncommitted;
    7:FReadWriteMode:=rwmReadWrite;
    8:FReadWriteMode:=rwmReadOnly;
    10:FNotDeferrable:=true;
    21:FBeginType:=atWork;
    22:FBeginType:=atTransaction;
  end;
end;

procedure TPGSQLBegin.MakeSQL;
var
  S: String;
begin
  S:='BEGIN';

  case FBeginType of
    atWork:S:=S+' WORK';
    atTransaction:S:=S+' TRANSACTION';
  end;

  if FIsolationLevel <> ilNone then
  begin
    case FIsolationLevel of
      ilSerializable:S:=S + ' ISOLATION LEVEL SERIALIZABLE';
      ilRepeatableRead:S:=S + ' ISOLATION LEVEL REPEATABLE READ';
      ilReadCommitted:S:=S + ' ISOLATION LEVEL READ COMMITTED';
      ilReadUncommitted:S:=S + ' ISOLATION LEVEL READ UNCOMMITTED';
    end;
  end;

  case FReadWriteMode of
    rwmReadOnly:S:=S + ' READ ONLY';
    rwmReadWrite:S:=S + ' READ WRITE';
  end;

  if FNotDeferrable then
    S:=S + ' NOT DEFERRABLE';

  AddSQLCommand(S);
end;

procedure TPGSQLBegin.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLBegin then
  begin
    FReadWriteMode:=TPGSQLBegin(ASource).FReadWriteMode;
    IsolationLevel:=TPGSQLBegin(ASource).IsolationLevel;
    NotDeferrable:=TPGSQLBegin(ASource).NotDeferrable;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLAbort }

procedure TPGSQLAbort.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  (* ABORT [ WORK | TRANSACTION ] *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ABORT', [toFindWordLast, toFirstToken]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'WORK', [toOptional], 1);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'TRANSACTION', [toOptional], 2);
end;

procedure TPGSQLAbort.MakeSQL;
var
  S: String;
begin
  S:='ABORT';
  case FAbortType of
    atWork:S:=S + ' WORK';
    atTransaction:S:=S + ' TRANSACTION';
  end;
  AddSQLCommand(S);
end;

procedure TPGSQLAbort.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FAbortType:=atWork;
    2:FAbortType:=atTransaction;
  end;
end;

{ TPGSQLRollback }

procedure TPGSQLRollback.InitParserTree;
var
  FSQLTokens, T1, T, T2, TT: TSQLTokenRecord;
begin
  (*
  ROLLBACK [ WORK | TRANSACTION ]
  ROLLBACK PREPARED transaction_id
  ROLLBACK [ WORK | TRANSACTION ] TO [ SAVEPOINT ] savepoint_name
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ROLLBACK', [toFindWordLast, toFirstToken]);
  T1:=AddSQLTokens(stKeyword, FSQLTokens, 'WORK', [toOptional], 3);
  T2:=AddSQLTokens(stKeyword, FSQLTokens, 'TRANSACTION', [toOptional], 4);

  T:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'TO', [toOptional]);

  TT:=AddSQLTokens(stKeyword, T, 'SAVEPOINT', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
  TT.AddChildToken(T);

  T:=AddSQLTokens(stKeyword, FSQLTokens, 'PREPARED', [toOptional]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 2);
end;

procedure TPGSQLRollback.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FSavepointName:=AWord;
    2:TransactionId:=AWord;
    3:RollbackType:=atWork;
    4:RollbackType:=atTransaction;
  end;
end;

procedure TPGSQLRollback.MakeSQL;
var
  S: String;
begin
  S:='ROLLBACK';
  if FTransactionId <> '' then
    S:=S + ' PREPARED ' + FTransactionId
  else
  begin
    case RollbackType of
      atWork:S:=S + ' WORK';
      atTransaction:S:=S + ' TRANSACTION';
    end;
    if FSavepointName <> '' then
      S:=S + ' TO SAVEPOINT ' + FSavepointName
  end;
  AddSQLCommand(S);
end;

procedure TPGSQLRollback.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLRollback then
  begin
    TransactionId:=TPGSQLRollback(ASource).TransactionId;
    SavepointName:=TPGSQLRollback(ASource).SavepointName;
    FRollbackType:=TPGSQLRollback(ASource).FRollbackType;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLCommit }

procedure TPGSQLCommit.InitParserTree;
var
  T, FSQLTokens: TSQLTokenRecord;
begin
  (*
  COMMIT [ WORK | TRANSACTION ]
  COMMIT PREPARED transaction_id
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'COMMIT', [toFindWordLast, toFirstToken]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'WORK', [toOptional], 2);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'TRANSACTION', [toOptional], 3);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'PREPARED', [toOptional]);
    AddSQLTokens(stIdentificator, T, '', [], 1);
    AddSQLTokens(stString, T, '', [], 1);
end;

procedure TPGSQLCommit.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:FTransactionId:=AWord;
    2:FCommitType:=atWork;
    3:FCommitType:=atTransaction;
  end;
end;

procedure TPGSQLCommit.MakeSQL;
var
  S: String;
begin
  S:='COMMIT';
  if FTransactionId <> '' then
    S:=S + ' PREPARED '+FTransactionId
  else
  begin
    case FCommitType of
      atWork:S:=S + ' WORK';
      atTransaction:S:=S + ' TRANSACTION';
    end;
  end;
  AddSQLCommand(S);
end;

procedure TPGSQLCommit.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLCommit then
  begin
    TransactionId:=TPGSQLCommit(ASource).TransactionId;
    FCommitType:=TPGSQLCommit(ASource).CommitType;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLStartTransaction }

procedure TPGSQLStartTransaction.InitParserTree;
var
  T, T1, T2, T3, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для START TRANSACTION }
  (*
  START TRANSACTION [ transaction_mode [, ...] ]

  where transaction_mode is one of:

      ISOLATION LEVEL { SERIALIZABLE | REPEATABLE READ | READ COMMITTED | READ UNCOMMITTED }
      READ WRITE | READ ONLY
      [ NOT ] DEFERRABLE
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'START', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'TRANSACTION', [toFindWordLast]);     //TRANSACTION
    T1:=AddSQLTokens(stKeyword, T, 'ISOLATION', []);
    T1:=AddSQLTokens(stKeyword, T1, 'LEVEL', []);
      T2:=AddSQLTokens(stKeyword, T1, 'SERIALIZABLE', [], 1);
      T2:=AddSQLTokens(stKeyword, T1, 'REPEATABLE', [], 2);
        T2:=AddSQLTokens(stKeyword, T2, 'READ', []);
      T2:=AddSQLTokens(stKeyword, T1, 'READ', []);
        T3:=AddSQLTokens(stKeyword, T2, 'COMMITTED', [], 3);
        T3:=AddSQLTokens(stKeyword, T2, 'UNCOMMITTED', [], 4);
end;

procedure TPGSQLStartTransaction.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TPGSQLStartTransaction.MakeSQL;
var
  S: String;
begin
  S:='START TRANSACTION';
  AddSQLCommand(S);
end;

constructor TPGSQLStartTransaction.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  IsolationLevel:=tilReadCommitted;
end;

{ TPGSQLTruncate }

procedure TPGSQLTruncate.InitParserTree;
var
  T, T1, T2, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Необходимо реализовать дерево парсера для TRUNCATE }
  (*
  TRUNCATE [ TABLE ] [ ONLY ] name [, ... ]
    [ RESTART IDENTITY | CONTINUE IDENTITY ] [ CASCADE | RESTRICT ]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'TRUNCATE', [toFindWordLast, toFirstToken]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'TABLE', []);
    T1:=AddSQLTokens(stKeyword, T, 'ONLY', [], 1);
    FSQLTokens.AddChildToken(T1);

  FTTableName:=AddSQLTokens(stIdentificator, FSQLTokens, '', []);
    T.AddChildToken(FTTableName);
    T1.AddChildToken(FTTableName);
  T:=AddSQLTokens(stKeyword, FTTableName, 'RESTART', [], 2);
  T:=AddSQLTokens(stKeyword, T, 'IDENTITY', []);

  T1:=AddSQLTokens(stKeyword, FTTableName, 'CONTINUE', [], 3);
  T1:=AddSQLTokens(stKeyword, T1, 'IDENTITY', []);

  T2:=AddSQLTokens(stKeyword, T, 'CASCADE', [], 3);
    FTTableName.AddChildToken(T2);
    T1.AddChildToken(T2);

  T2:=AddSQLTokens(stKeyword, T, 'RESTRICT', [], 4);
    FTTableName.AddChildToken(T2);
    T1.AddChildToken(T2);
end;

procedure TPGSQLTruncate.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  if AChild = FTTableName then
    FTableName:=AWord
  else
  if AChild.Tag = 3 then
    FDropRule:=drCascade
  else
  if AChild.Tag = 4 then
    FDropRule:=drRestrict
  else
  if AChild.Tag = 1 then
    FIsOnly:=true
  else
  if AChild.Tag = 2 then
    FRestartIdentity:=true
  else
  if AChild.Tag = 3 then
    FContinueIdentity:=true
  ;
end;

procedure TPGSQLTruncate.MakeSQL;
var
  Result: String;
begin
  Result:= 'TRUNCATE TABLE ONLY ' + FTableName;

  if FRestartIdentity then
    Result:= Result + ' RESTART IDENTITY'
  else
  if FContinueIdentity then
    Result:= Result + ' CONTINUE IDENTITY';

  if FDropRule = drCascade then
    Result:= Result + ' CASCADE'
  else
  if FDropRule = drCascade then
    Result:= Result + ' RESTRICT';
  AddSQLCommand(Result);
end;

procedure TPGSQLTruncate.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLTruncate then
  begin
    TableName:=TPGSQLTruncate(ASource).TableName;
    DropRule:=TPGSQLTruncate(ASource).DropRule;
    RestartIdentity:=TPGSQLTruncate(ASource).RestartIdentity;
    ContinueIdentity:=TPGSQLTruncate(ASource).ContinueIdentity;
    IsOnly:=TPGSQLTruncate(ASource).IsOnly;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLCreateTable }

function TPGSQLCreateTable.GetDefaultValue(ASQLParser: TSQLParser): string;
var
  FCurPos: TParserPosition;
  FStop: Boolean;
  S: String;
begin
  FCurPos:=ASQLParser.Position;
  FStop:=false;
  while not FStop do
  begin
    S:=ASQLParser.GetNextWord;
    if S = '(' then
      ASQLParser.GetToBracket(')')
    else
    if (S = ')') or (S = ',') or ASQLParser.Eof then
      FStop:=true;
  end;
  if not ASQLParser.Eof then
    ASQLParser.Position:=ASQLParser.WordPosition;
  Result:=Copy(ASQLParser.SQL, FCurPos.Position, ASQLParser.Position.Position - FCurPos.Position);
end;

procedure TPGSQLCreateTable.InitParserTree;
var
  T, T1, T2, T3, T4, T5, FSQLTokens, FTSchemaName, FTTableName,
    TColName, TSymb2, TSymbEnd, TInher, TInher1, TInher2,
    TTblS, TTblS1, TOnCom, TOnCom1, TOnCom2, TOnCom3, TWitO,
    TWit, TWit1, TWit2, TWit3, TWit4, TWit5, TWit6, TWitO1,
    TConstr, TConstr1, TCheck, TCheck1, TUnq, TUnq1, TPK, TPK1,
    TFK, TFK1, TFK2, TFK3, TFK3_1, TFK3_2, TFK3_3, TFK4,
    TFK4_1, TFK4_2, TFK4_3, TFK4_4, TFK4_5, TFK4_6, TFK4_7,
    TIndParams1, TIndParams1_1, TTableTypeOf, TTableField,
    TTableStart, TPartition, TPartition1: TSQLTokenRecord;
begin
  { TODO : Реализовать парсер CREATE TABLE }
  (*
  CREATE [ [ GLOBAL | LOCAL ] { TEMPORARY | TEMP } | UNLOGGED ] TABLE [ IF NOT EXISTS ] table_name ( [
    { column_name data_type [ COLLATE collation ] [ column_constraint [ ... ] ]
      | table_constraint
      | LIKE parent_table [ like_option ... ] }
      [, ... ]
  ] )
  [ INHERITS ( parent_table [, ... ] ) ]
  [ PARTITION BY { RANGE | LIST } ( { имя_столбца | ( выражение ) } [ COLLATE правило_сортировки ] [ класс_операторов ] [, ... ] ) ]
  [ WITH ( storage_parameter [= value] [, ... ] ) | WITH OIDS | WITHOUT OIDS ]
  [ ON COMMIT { PRESERVE ROWS | DELETE ROWS | DROP } ]
  [ TABLESPACE tablespace ]

  CREATE [ [ GLOBAL | LOCAL ] { TEMPORARY | TEMP } | UNLOGGED ] TABLE [ IF NOT EXISTS ] table_name
      OF type_name [ (
    { column_name WITH OPTIONS [ column_constraint [ ... ] ]
      | table_constraint }
      [, ... ]
  ) ]
  [ WITH ( storage_parameter [= value] [, ... ] ) | WITH OIDS | WITHOUT OIDS ]
  [ ON COMMIT { PRESERVE ROWS | DELETE ROWS | DROP } ]
  [ TABLESPACE tablespace ]

  where column_constraint is:

  [ CONSTRAINT constraint_name ]
  { NOT NULL |
    NULL |
    CHECK ( expression ) |
    DEFAULT default_expr |
    UNIQUE index_parameters |
    PRIMARY KEY index_parameters |
    REFERENCES reftable [ ( refcolumn ) ] [ MATCH FULL | MATCH PARTIAL | MATCH SIMPLE ]
      [ ON DELETE action ] [ ON UPDATE action ] }
  [ DEFERRABLE | NOT DEFERRABLE ] [ INITIALLY DEFERRED | INITIALLY IMMEDIATE ]

  and table_constraint is:

  [ CONSTRAINT constraint_name ]
  { CHECK ( expression ) |
    UNIQUE ( column_name [, ... ] ) index_parameters |
    PRIMARY KEY ( column_name [, ... ] ) index_parameters |
    EXCLUDE [ USING index_method ] ( exclude_element WITH operator [, ... ] ) index_parameters [ WHERE ( predicate ) ] |
    FOREIGN KEY ( column_name [, ... ] ) REFERENCES reftable [ ( refcolumn [, ... ] ) ]
      [ MATCH FULL | MATCH PARTIAL | MATCH SIMPLE ] [ ON DELETE action ] [ ON UPDATE action ] }
  [ DEFERRABLE | NOT DEFERRABLE ] [ INITIALLY DEFERRED | INITIALLY IMMEDIATE ]

  and like_option is:

  { INCLUDING | EXCLUDING } { DEFAULTS | CONSTRAINTS | INDEXES | STORAGE | COMMENTS | ALL }

  index_parameters in UNIQUE, PRIMARY KEY, and EXCLUDE constraints are:

  [ WITH ( storage_parameter [= value] [, ... ] ) ]
  [ USING INDEX TABLESPACE tablespace ]

  exclude_element in an EXCLUDE constraint is:

  { column | ( expression ) } [ opclass ] [ ASC | DESC ] [ NULLS { FIRST | LAST } ]
---
  CREATE [ [ GLOBAL | LOCAL ] { TEMPORARY | TEMP } | UNLOGGED ] TABLE table_name
      [ (column_name [, ...] ) ]
      [ WITH ( storage_parameter [= value] [, ... ] ) | WITH OIDS | WITHOUT OIDS ]
      [ ON COMMIT { PRESERVE ROWS | DELETE ROWS | DROP } ]
      [ TABLESPACE tablespace ]
      AS query
      [ WITH [ NO ] DATA ]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okTable);    //CREATE [ [ GLOBAL | LOCAL ] { TEMPORARY | TEMP } | UNLOGGED ] TABLE
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'GLOBAL', [], 1);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'LOCAL', [], 2);
    T3:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'TEMPORARY', [], 3);
    T4:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'TEMP', [], 3);
    T5:=AddSQLTokens(stKeyword, FSQLTokens, 'UNLOGGED', [], 4);

  T:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2, T3, T4, T5], 'TABLE', [toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, T, 'IF', [], 5);
    T1:=AddSQLTokens(stKeyword, T1, 'NOT', []);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);
  FTSchemaName:=AddSQLTokens(stIdentificator, [T, T1], '', [], 6);
    T:=AddSQLTokens(stSymbol, FTSchemaName, '.', []);
  FTTableName:=AddSQLTokens(stIdentificator, T, '', [], 7);

  TTableTypeOf:=AddSQLTokens(stKeyword, [FTSchemaName, FTTableName], 'OF', []);
    TTableTypeOf:=AddSQLTokens(stIdentificator, TTableTypeOf, '', [], 60);

  TTableStart:=AddSQLTokens(stSymbol, [FTSchemaName, FTTableName, TTableTypeOf], '(', []);
  TColName:=AddSQLTokens(stIdentificator, TTableStart, '', [], 10);
  TSymb2:=AddSQLTokens(stSymbol, nil, ',', [], 11);
    TSymb2.AddChildToken(TColName);
  TSymbEnd:=AddSQLTokens(stSymbol, nil, ')', []);

  MakeTypeDefTree(Self, [TColName], [TSymb2, TSymbEnd], tdfTableColDef, 100);

  TConstr:=AddSQLTokens(stKeyword, TSymb2, 'CONSTRAINT', []);
    TConstr1:=AddSQLTokens(stIdentificator, TConstr, '', [], 57);
  TCheck:=AddSQLTokens(stKeyword, [TSymb2, TConstr1], 'CHECK', []);
    TCheck1:=AddSQLTokens(stSymbol, TCheck, '(', [], 56);
    TCheck1.AddChildToken([TSymb2, TSymbEnd]);

  TUnq:=AddSQLTokens(stKeyword, [TSymb2, TConstr1], 'UNIQUE', [], 42);
    TUnq1:=AddSQLTokens(stSymbol, TUnq, '(', []);
    TUnq1:=AddSQLTokens(stIdentificator, TUnq1, '', [], 40);
    T:=AddSQLTokens(stSymbol, TUnq1, ',', []);
    T.AddChildToken(TUnq1);
    TUnq1:=AddSQLTokens(stSymbol, TUnq1, ')', []);
    TUnq1.AddChildToken([TSymb2, TSymbEnd]);

  TPK:=AddSQLTokens(stKeyword, [TTableStart, TSymb2, TConstr1], 'PRIMARY', [], 43);
    TPK1:=AddSQLTokens(stSymbol, TPK, 'KEY', []);
    TPK1:=AddSQLTokens(stSymbol, TPK1, '(', []);
    TPK1:=AddSQLTokens(stIdentificator, TPK1, '', [], 40);
    T:=AddSQLTokens(stSymbol, TPK1, ',', []);
    T.AddChildToken(TPK1);
    TPK1:=AddSQLTokens(stSymbol, TPK1, ')', []);
    TPK1.AddChildToken([TSymb2, TSymbEnd]);

    TIndParams1 := AddSQLTokens(stKeyword, [TUnq1, TPK1], 'WITH', []);
      TIndParams1_1:=AddSQLTokens(stKeyword, TIndParams1, '(', []);
      TIndParams1_1:=AddSQLTokens(stIdentificator, TIndParams1_1, '', [], 58);
        T1:=AddSQLTokens(stSymbol, TIndParams1_1, '=', []);
        T2:=AddSQLTokens(stInteger, T1, '', [], 59);
        T3:=AddSQLTokens(stString, T1, '', [], 59);
        T1:=AddSQLTokens(stIdentificator, T1, '', [], 59);
      T:=AddSQLTokens(stSymbol, [TIndParams1_1, T1, T2, T3], ',', []);
        T.AddChildToken(TIndParams1_1);
    TIndParams1_1:=AddSQLTokens(stSymbol, [TIndParams1_1, T1, T2, T3], ')', []);
    TIndParams1_1.AddChildToken([TSymb2, TSymbEnd]);


//    [ WITH ( параметр_хранения [= значение] [, ... ] ) ]
//    [ INCLUDE ( имя_столбца [, ... ] ) ]
//    [ USING INDEX TABLESPACE табл_пространство ]

  TFK:=AddSQLTokens(stKeyword, [TSymb2, TConstr1], 'FOREIGN', [], 41);
    TFK1:=AddSQLTokens(stSymbol, TFK, 'KEY', []);
    TFK1:=AddSQLTokens(stSymbol, TFK1, '(', []);
    TFK1:=AddSQLTokens(stIdentificator, TFK1, '', [], 40);
    T:=AddSQLTokens(stSymbol, TFK1, ',', []);
    T.AddChildToken(TFK1);
    TFK1:=AddSQLTokens(stSymbol, TFK1, ')', []);
    TFK1:=AddSQLTokens(stKeyword, TFK1, 'REFERENCES', []);
    TFK1:=AddSQLTokens(stIdentificator, TFK1, '', [], 44);
      T:=AddSQLTokens(stSymbol, TFK1, '.', [], 44);
      T:=AddSQLTokens(stIdentificator, T, '', [], 44);
    TFK1.AddChildToken([TSymb2, TSymbEnd]);
    T.AddChildToken([TSymb2, TSymbEnd]);
    TFK2:=AddSQLTokens(stSymbol, [TFK1, T], '(', []);
    TFK2:=AddSQLTokens(stIdentificator, TFK2, '', [], 45);
    T:=AddSQLTokens(stSymbol, TFK2, ',', []);
    T.AddChildToken(TFK2);
    TFK2:=AddSQLTokens(stSymbol, TFK2, ')', []);
    TFK2.AddChildToken([TSymb2, TSymbEnd]);
    TFK3:=AddSQLTokens(stSymbol, [TFK1, TFK2], 'MATCH', []);
      TFK3_1:=AddSQLTokens(stSymbol, TFK3, 'FULL', [], 46);
      TFK3_2:=AddSQLTokens(stSymbol, TFK3, 'PARTIAL', [], 47);
      TFK3_3:=AddSQLTokens(stSymbol, TFK3, 'SIMPLE', [], 48);
      TFK3_1.AddChildToken([TSymb2, TSymbEnd]);
      TFK3_2.AddChildToken([TSymb2, TSymbEnd]);
      TFK3_3.AddChildToken([TSymb2, TSymbEnd]);
    TFK4:=AddSQLTokens(stSymbol, [TFK1, TFK2, TFK3_1, TFK3_2, TFK3_3], 'ON', []);
      TFK4_1:=AddSQLTokens(stSymbol, TFK4, 'DELETE', [], 49);
      TFK4_2:=AddSQLTokens(stSymbol, TFK4, 'UPDATE', [], 50);
      TFK4_3:=AddSQLTokens(stSymbol, [TFK4_1, TFK4_2], 'NO', []);
      TFK4_3:=AddSQLTokens(stSymbol, TFK4_3, 'ACTION', [], 51);
      TFK4_4:=AddSQLTokens(stSymbol, [TFK4_1, TFK4_2], 'RESTRICT', [], 52);
      TFK4_5:=AddSQLTokens(stSymbol, [TFK4_1, TFK4_2], 'CASCADE', [], 53);
      TFK4_6:=AddSQLTokens(stSymbol, [TFK4_1, TFK4_2], 'SET', []);
      TFK4_7:=AddSQLTokens(stSymbol, TFK4_6, 'NULL', [], 54);
      TFK4_6:=AddSQLTokens(stSymbol, TFK4_6, 'DEFAULT', [], 55);
      TFK4_3.AddChildToken([TSymb2, TSymbEnd, TFK4]);
      TFK4_4.AddChildToken([TSymb2, TSymbEnd, TFK4]);
      TFK4_5.AddChildToken([TSymb2, TSymbEnd, TFK4]);
      TFK4_6.AddChildToken([TSymb2, TSymbEnd, TFK4]);
      TFK4_7.AddChildToken([TSymb2, TSymbEnd, TFK4]);

(*
  [ CONSTRAINT constraint_name ]
  {
    CHECK ( expression ) |
    UNIQUE ( column_name [, ... ] ) index_parameters |
    PRIMARY KEY ( column_name [, ... ] ) index_parameters |
    EXCLUDE [ USING index_method ] ( exclude_element WITH operator [, ... ] ) index_parameters [ WHERE ( predicate ) ] |
    FOREIGN KEY ( column_name [, ... ] ) REFERENCES reftable [ ( refcolumn [, ... ] ) ]
      [ MATCH FULL | MATCH PARTIAL | MATCH SIMPLE ]
      [ ON DELETE action ] [ ON UPDATE action ]
  }
  [ DEFERRABLE | NOT DEFERRABLE ] [ INITIALLY DEFERRED | INITIALLY IMMEDIATE ]
*)

  TInher:=AddSQLTokens(stKeyword, TSymbEnd, 'INHERITS', [toOptional]);
    TInher1:=AddSQLTokens(stSymbol, TInher, '(', []);
    TInher1:=AddSQLTokens(stIdentificator, TInher1, '', [], 20);
    TInher2:=AddSQLTokens(stSymbol, TInher1, '.', []);
    TInher2:=AddSQLTokens(stIdentificator, TInher2, '', [], 21);
    T:=AddSQLTokens(stSymbol, [TInher1, TInher2], ',', [], 22);
      T.AddChildToken(TInher1);
    TInher1:=AddSQLTokens(stSymbol, [TInher1, TInher2], ')', [], 22);

  TTblS:=AddSQLTokens(stKeyword, [TSymbEnd, TInher1], 'TABLESPACE', [toOptional]);
    TTblS1:=AddSQLTokens(stIdentificator, TTblS, '', [], 23);
    TTblS1.AddChildToken(TInher);

  TOnCom:=AddSQLTokens(stKeyword, [TSymbEnd, TInher1, TTblS1], 'ON', [toOptional]);
    TOnCom1:=AddSQLTokens(stKeyword, TOnCom, 'COMMIT', []);
    TOnCom2:=AddSQLTokens(stKeyword, TOnCom1, 'PRESERVE', []);
    TOnCom2:=AddSQLTokens(stKeyword, TOnCom2, 'ROWS', [], 24);
    TOnCom3:=AddSQLTokens(stKeyword, TOnCom1, 'DELETE', []);
    TOnCom3:=AddSQLTokens(stKeyword, TOnCom3, 'ROWS', [], 25);
    TOnCom1:=AddSQLTokens(stKeyword, TOnCom1, 'DROP', [], 26);
    TOnCom1.AddChildToken([TInher, TTblS]);
    TOnCom2.AddChildToken([TInher, TTblS]);
    TOnCom3.AddChildToken([TInher, TTblS]);

  TWitO:=AddSQLTokens(stKeyword, [TSymbEnd, TInher1, TTblS1, TOnCom1, TOnCom2, TOnCom3], 'WITHOUT', [toOptional]);
    TWitO1:=AddSQLTokens(stIdentificator, TWitO, 'OIDS', [], 27);
    TWitO1.AddChildToken([TInher, TTblS, TOnCom]);
  TWit:=AddSQLTokens(stKeyword, [TSymbEnd, TInher1, TTblS1, TOnCom1, TOnCom2, TOnCom3], 'WITH', [toOptional]);
    TWit1:=AddSQLTokens(stIdentificator, TWit, 'OIDS', [], 28);
    TWit2:=AddSQLTokens(stSymbol, TWit, '(', []);
    TWit2:=AddSQLTokens(stIdentificator, TWit2, '', [], 29);
    TWit3:=AddSQLTokens(stSymbol, TWit2, '=', []);
    TWit4:=AddSQLTokens(stIdentificator, TWit3, '', [], 30);
    TWit5:=AddSQLTokens(stString, TWit3, '', [], 30);
    TWit6:=AddSQLTokens(stInteger, TWit3, '', [], 30);
    T:=AddSQLTokens(stInteger, [TWit2, TWit4, TWit5, TWit6], ',', [], 31);
    T.AddChildToken(TWit2);
    TWit2:=AddSQLTokens(stInteger, [TWit2, TWit4, TWit5, TWit6], ')', []);
    TWit1.AddChildToken([TInher, TTblS, TOnCom]);
    TWit2.AddChildToken([TInher, TTblS, TOnCom, TWitO, TWit]);

  TPartition:=AddSQLTokens(stKeyword, [TSymbEnd, TInher1, TTblS1, TOnCom1, TOnCom2, TOnCom3], 'PARTITION', [toOptional]);
    TPartition1:=AddSQLTokens(stKeyword, TPartition, 'BY', []);
    T1:=AddSQLTokens(stKeyword, TPartition1, 'RANGE', [], 61);
    T2:=AddSQLTokens(stKeyword, TPartition1, 'LIST', [], 62);
    T:=AddSQLTokens(stSymbol, [T1, T2], '(', []);
      T1:=AddSQLTokens(stIdentificator, T, '', [], 63);
      T:=AddSQLTokens(stSymbol, T1, ',', []);
      T.AddChildToken(T1);
    T:=AddSQLTokens(stSymbol, T1, ')', []);

  T.AddChildToken([TInher, TTblS, TOnCom, TWitO, TWit])
//    [ PARTITION BY { RANGE | LIST } ( { имя_столбца | ( выражение ) } [ COLLATE правило_сортировки ] [ класс_операторов ] [, ... ] ) ]

  { TODO : Необходимо реализовать дерево парсера для CREATE TABLE }
end;

procedure TPGSQLCreateTable.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
var
  FN: String;
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FVisibleType:=vtGlobal;
    2:FVisibleType:=vtLocal;
    3:Options:=Options + [ooTemporary];
    4:FUnlogged:=true;
    5:Options:=Options + [ooIfNotExists];
    6:Name:=AWord;
    7:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
    10:FCurField:=Fields.AddParam(AWord);
    11:begin
         FCurField:=nil;
         FCurConst:=nil;
       end;
    20:FCurTable:=InheritsTables.Add(AWord);
    21:if Assigned(FCurTable) then
       begin
         FCurTable.SchemaName:=FCurTable.Name;
         FCurTable.Name:=AWord;
       end;
    22:FCurTable:=nil;
    23:TableSpace:=AWord;
    24:OnCommitAction:=caPreserveRows;
    25:OnCommitAction:=caDeleteRows;
    26:OnCommitAction:=caDrop;
    27:PGOptions:=PGOptions + [pgoWithoutOids];
    28:PGOptions:=PGOptions + [pgoWithOids];
    29:StorageParameters.Add(AWord);
    30:if StorageParameters.Count > 0 then
       begin
         FN:=StorageParameters[StorageParameters.Count - 1];
         StorageParameters[StorageParameters.Count - 1]:=FN+'='+AWord;
       end;
    40:if Assigned(FCurConst) then FCurConst.ConstraintFields.AddParam(AWord);
    41:if not Assigned(FCurConst) then FCurConst:=SQLConstraints.Add(ctForeignKey) else FCurConst.ConstraintType:=ctForeignKey;
    42:if not Assigned(FCurConst) then FCurConst:=SQLConstraints.Add(ctUnique) else FCurConst.ConstraintType:=ctUnique;
    43:if not Assigned(FCurConst) then FCurConst:=SQLConstraints.Add(ctPrimaryKey) else FCurConst.ConstraintType:=ctPrimaryKey;
    44:if Assigned(FCurConst) then FCurConst.ForeignTable:=FCurConst.ForeignTable + AWord;
    45:if Assigned(FCurConst) then FCurConst.ForeignFields.AddParam(AWord);
    46:if Assigned(FCurConst) then FCurConst.Match:=maFull;
    47:if Assigned(FCurConst) then FCurConst.Match:=maPartial;
    48:if Assigned(FCurConst) then FCurConst.Match:=maSimple;
    49:FUpDel:=1;
    50:FUpDel:=2;
    51:if Assigned(FCurConst) then if FUpDel = 1 then FCurConst.ForeignKeyRuleOnDelete:=fkrNone else FCurConst.ForeignKeyRuleOnUpdate:=fkrNone;
    52:if Assigned(FCurConst) then if FUpDel = 1 then FCurConst.ForeignKeyRuleOnDelete:=fkrRestrict else FCurConst.ForeignKeyRuleOnUpdate:=fkrRestrict;
    53:if Assigned(FCurConst) then if FUpDel = 1 then FCurConst.ForeignKeyRuleOnDelete:=fkrCascade else FCurConst.ForeignKeyRuleOnUpdate:=fkrCascade;
    54:if Assigned(FCurConst) then if FUpDel = 1 then FCurConst.ForeignKeyRuleOnDelete:=fkrSetNull else FCurConst.ForeignKeyRuleOnUpdate:=fkrSetNull;
    55:if Assigned(FCurConst) then if FUpDel = 1 then FCurConst.ForeignKeyRuleOnDelete:=fkrSetDefault else FCurConst.ForeignKeyRuleOnUpdate:=fkrSetDefault;
    56:begin
          if not Assigned(FCurConst) then
            FCurConst:=SQLConstraints.Add(ctTableCheck)
          else
           FCurConst.ConstraintType:=ctTableCheck;
          FCurConst.ConstraintExpression:=ASQLParser.GetToBracket(')');
        end;
    57:FCurConst:=SQLConstraints.Add(ctNone, AWord);
    58:if Assigned(FCurConst) then
          FCurParam:=FCurConst.Params.AddParam(AWord);
    59:if Assigned(FCurConst) and Assigned(FCurParam) then
          FCurParam.ParamValue:=AWord;
    60:TableTypeName:=AWord;
    61:FTablePartition.PartitionType:=ptRange;
    62:FTablePartition.PartitionType:=ptList;
    63:FTablePartition.Params.AddParam(AWord);
   102:if Assigned(FCurField) then FCurField.TypeName:=AWord;
   103:if Assigned(FCurField) then FCurField.TypeName:=FCurField.TypeName + ' ' + AWord;
   126:if Assigned(FCurField) then FCurField.TypeName:=FCurField.TypeName + AWord;
   104:if Assigned(FCurField) then FCurField.TypeLen:=StrToInt(AWord);
   105:if Assigned(FCurField) then FCurField.TypePrec:=StrToInt(AWord);
   106:if Assigned(FCurField) then FCurField.ConstraintName:=AWord;
   107:if Assigned(FCurField) then FCurField.Params:=FCurField.Params + [fpNotNull];
   108:if Assigned(FCurField) then FCurField.Params:=FCurField.Params + [fpNull];
   109:if Assigned(FCurField) then FCurField.CheckExpr:=ASQLParser.GetToBracket(')');
   110:if Assigned(FCurField) then FCurField.PrimaryKey:=true;
   111:if Assigned(FCurField) then FCurField.Params:= FCurField.Params + [fpUnique];
   112:if Assigned(FCurField) then
       begin
         if Assigned(FCurConst) then
           FCurConst.ConstraintType:=ctForeignKey
         else
           FCurConst:=SQLConstraints.Add(ctForeignKey);
         FCurConst.ConstraintFields.AddParam(FCurField.Caption);
         FCurConst.ForeignTable:=AWord;
       end;
   113:if Assigned(FCurField) and Assigned(FCurConst) then
         FCurConst.ForeignFields.AddParam(AWord);
   115:if Assigned(FCurConst) then
       FCurConst.ForeignTable:=FCurConst.ForeignTable + '.' + AWord;
   127:if Assigned(FCurField) then
          FCurField.DefaultValue:=GetDefaultValue(ASQLParser);
   128:if Assigned(FCurField) then
       begin
         // 28 - GENERATED
         //FCurField.AutoIncInitValue:=true;
       end;
   129:if Assigned(FCurField) then FCurField.AutoIncType:=faioGeneratedAlways;
   130:if Assigned(FCurField) then FCurField.AutoIncType:=faioGeneratedByDefault;
   131:if Assigned(FCurField) then FCurField.ArrayDimension.Add(0); // 31 - Array
   132:if Assigned(FCurField) and (FCurField.ArrayDimension.Count>0) then FCurField.ArrayDimension[FCurField.ArrayDimension.Count-1].Dimension:=StrToInt(AWord); // 32 - Array dimension
  end;
end;

procedure TPGSQLCreateTable.MakeSQL;
var
  F, P: TSQLParserField;
  SF, SPK, S, S_CON, S1, S2: String;
  C: TSQLConstraintItem;
  FCmdAlter: TPGSQLAlterTable;
  OP: TAlterTableOperator;
  FCntPK: Integer;
begin
  SF:='';
  SPK:='';

  FCntPK:=0;
  for F in Fields do
    if F.PrimaryKey then
      Inc(FCntPK);

  for F in Fields do
  begin
    if F.IsLocal then
    begin
      if SF<>'' then SF:=SF + ','+ LineEnding;
      SF:=SF + '  ' +F.Caption + ' ' + F.FullTypeName;
      if F.ArrayDimension.Count>0 then
      begin
        F.ArrayDimension.ArrayFormat:=fafPostgreSQL;
        SF:=SF + F.ArrayDimension.AsString;
      end;

      if F.ConstraintName <> '' then
        SF:=SF + ' CONSTRAINT '+F.ConstraintName;

      if fpNotNull in F.Params then
        SF:=SF + ' NOT NULL'
      else
      if fpNull in F.Params then
        SF:=SF + ' NULL'
      ;

      if fpUnique in F.Params then
        SF:=SF + ' UNIQUE';

      if F.PrimaryKey then
      begin
        if FCntPK > 1 then
        begin
          if SPK<>'' then SPK:=SPK + ', ';
          SPK:=SPK + F.Caption;
        end
        else
          SF:=SF + ' PRIMARY KEY';
      end;

      if F.AutoIncType = faioGeneratedAlways then
        SF:=SF + ' GENERATED ALWAYS AS IDENTITY'
      else
      if F.AutoIncType = faioGeneratedByDefault then
        SF:=SF + ' GENERATED BY DEFAULT AS IDENTITY';

      if TrimRight(F.DefaultValue) <> '' then
        SF:=SF + ' DEFAULT' + TrimRight(F.DefaultValue);

      if F.CheckExpr <> '' then
        SF:=SF + ' CHECK ('+F.CheckExpr+')';
    end;
  end;

  if (SF = '') and (TableTypeName='') then exit;

  S_CON:='';
  for C in SQLConstraints do
  begin
    case C.ConstraintType of
      ctPrimaryKey:if SPK = '' then
        begin
          if S_CON <> '' then S_CON:=S_CON + ','+LineEnding;

          if C.ConstraintName <> '' then
            S_CON:=S_CON + '  CONSTRAINT ' + C.ConstraintName
          else
            S_CON:=S_CON + ' ';

          S_CON:=S_CON + ' PRIMARY KEY (' + C.ConstraintFields.AsString + ')';
          if C.Params.Count>0 then
          begin
            S_CON:=S_CON + ' WITH (';
            S2:='';
            for P in C.Params do
            begin
              if S2<>'' then S2:=S2 + ',';
              S2:=S2 + P.Caption;
              if P.ParamValue<>'' then
                S2:=S2 + ' = '+P.ParamValue
            end;
            S_CON:=S_CON + S2 + ')';
          end;
        end;
      ctTableCheck:
        begin
          if S_CON <> '' then S_CON:=S_CON + ','+LineEnding;

          if C.ConstraintName <> '' then
            S_CON:=S_CON + '  CONSTRAINT ' + C.ConstraintName
          else
            S_CON:=S_CON + ' ';
          S_CON:=S_CON + ' CHECK (' + C.ConstraintExpression + ')';
        end;
      ctForeignKey:
        begin
          if S_CON <> '' then S_CON:=S_CON + ','+LineEnding;
          if C.ConstraintName <> '' then
            S_CON:=S_CON + '  CONSTRAINT ' + C.ConstraintName
          else
            S_CON:=S_CON + ' ';

          S_CON:=S_CON + ' FOREIGN KEY ('+C.ConstraintFields.AsString+') REFERENCES ' + C.ForeignTable;
          if C.ForeignFields.Count>0 then
            S_CON:=S_CON + ' ('+C.ForeignFields.AsString+')';
          case C.Match of
            maFull:S_CON:=S_CON + ' MATCH FULL';
            maPartial:S_CON:=S_CON + ' MATCH PARTIAL';
            maSimple:S_CON:=S_CON + ' MATCH SIMPLE';
          end;
          if C.ForeignKeyRuleOnUpdate<>fkrNone then S_CON:=S_CON+' ON UPDATE ' + ForeignKeyRuleNames[C.ForeignKeyRuleOnUpdate];
          if C.ForeignKeyRuleOnDelete<>fkrNone then S_CON:=S_CON+' ON DELETE ' + ForeignKeyRuleNames[C.ForeignKeyRuleOnDelete];
        end;
      ctUnique:
        begin
          if S_CON <> '' then S_CON:=S_CON + ','+LineEnding;
          if C.ConstraintName <> '' then
            S_CON:=S_CON + '  CONSTRAINT ' + C.ConstraintName
          else
            S_CON:=S_CON + ' ';

          S_CON:=S_CON + ' UNIQUE (' + C.ConstraintFields.AsString + ')';
          if C.Params.Count>0 then
          begin
            S_CON:=S_CON + ' WITH (';
            S2:='';
            for P in C.Params do
            begin
              if S2<>'' then S2:=S2 + ',';
              S2:=S2 + P.Caption;
              if P.ParamValue<>'' then
                S2:=S2 + ' = '+P.ParamValue
            end;
            S_CON:=S_CON + S2 + ')';
          end;
        end;
    end;
  end;

  S:='CREATE';

  if ooTemporary in Options then
  begin
    if FVisibleType = vtGlobal then
      S:=S + ' GLOBAL'
    else
    if FVisibleType = vtLocal then
      S:=S + ' LOCAL';
    S:=S + ' TEMPORARY';
  end
  else
  if FUnlogged then
    S:=S + ' UNLOGGED';

  S:=S + ' TABLE';

  if ooIfNotExists in Options then
    S:=S + ' IF NOT EXISTS';

  S:=S + ' ' + FullName;
  if TableTypeName<>'' then
    S:=S+' OF '+TableTypeName+' ';

  S:=S+ '('+LineEnding + SF;

  if SPK<>'' then
    S:=S + ',' + LineEnding + '  PRIMARY KEY (' + SPK + ')';

  if S_CON <> '' then
    S:=S + ',' + LineEnding + S_CON;

  S:=S+LineEnding+')';

  if InheritsTables.Count > 0 then
    S:= S + LineEnding + 'INHERITS (' + InheritsTables.AsString + ')';

  if TableSpace <> '' then
    S:=S + LineEnding + 'TABLESPACE ' + TableSpace;

  case OnCommitAction of
    caPreserveRows:S:=S + LineEnding + 'ON COMMIT PRESERVE ROWS';
    caDeleteRows:S:=S + LineEnding + 'ON COMMIT DELETE ROWS';
    caDrop:S:=S + LineEnding + 'ON COMMIT DROP';
  end;

  S1:='';
  for S2 in StorageParameters do
  begin
    if S1<>'' then S1:=S1 + ',' + LineEnding;
    S1:=S1+S2;
  end;

  if S1<>'' then
    S:=S + LineEnding + 'WITH ('+S1+')';

  if pgoWithOids in PGOptions then
    S:=S + LineEnding + 'WITH OIDS'
  else
  if pgoWithoutOids in PGOptions then
    S:=S + LineEnding + 'WITHOUT OIDS'
  ;

  if FTablePartition.PartitionType <> ptNone then
  begin
    S:=S + LineEnding + 'PARTITION BY ';
    if FTablePartition.PartitionType=ptRange then
      S:=S +'RANGE '
    else
    if FTablePartition.PartitionType=ptList then
      S:=S +'LIST ';
    S:=S + '(' + FTablePartition.Params.AsString + ')';
  end;
  //    [ PARTITION BY { RANGE | LIST } ( { имя_столбца | ( выражение ) } [ COLLATE правило_сортировки ] [ класс_операторов ] [, ... ] ) ]

  AddSQLCommand(S);

  if Owner <> '' then
  begin
    FCmdAlter:=TPGSQLAlterTable.Create(nil);
    FCmdAlter.SchemaName:=SchemaName;
    FCmdAlter.Name:=Name;
    OP:=FCmdAlter.AddOperator(ataOwnerTo);
    OP.ParamValue:=Owner;
    AddSQLCommand(FCmdAlter.AsSQL);
    FCmdAlter.Free;
  end;

  if Description <> '' then
    DescribeObject;

  for F in Fields do
    if F.Description <> '' then
      DescribeObjectEx(okColumn, F.Caption, FullName, F.Description);

  for C in SQLConstraints do
    if C.Description <> '' then
      DescribeObjectEx(okConstraint, C.ConstraintName, FullName, C.Description);
end;

constructor TPGSQLCreateTable.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSQLCommentOnClass:=TPGSQLCommentOn;
  FInheritsTables:=TSQLTables.Create;
  FStorageParameters:=TStringList.Create;
  FTablePartition:=TPGSQLCreateTablePartition.Create;
end;

destructor TPGSQLCreateTable.Destroy;
begin
  FreeAndNil(FInheritsTables);
  FreeAndNil(FStorageParameters);
  FreeAndNil(FTablePartition);
  inherited Destroy;
end;

function TPGSQLCreateTable.GetAutoIncObject: TAutoIncObject;
begin
  Result:=TPGAutoIncObject.Create(Self);
end;

procedure TPGSQLCreateTable.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLCreateTable then
  begin
    VisibleType:=TPGSQLCreateTable(ASource).VisibleType;
    Unlogged:=TPGSQLCreateTable(ASource).Unlogged;
    InheritsTables.Assign(TPGSQLCreateTable(ASource).InheritsTables);
    TableSpace:=TPGSQLCreateTable(ASource).TableSpace;
    OnCommitAction:=TPGSQLCreateTable(ASource).OnCommitAction;
    StorageParameters.Assign(TPGSQLCreateTable(ASource).StorageParameters);
    PGOptions:=TPGSQLCreateTable(ASource).PGOptions;
    Owner:=TPGSQLCreateTable(ASource).Owner;
    TablePartition.Assign(TPGSQLCreateTable(ASource).TablePartition);
  end;
  inherited Assign(ASource);
end;

{ TPGSQLVacum }

procedure TPGSQLVacum.InitParserTree;
var
  T1, T2, T3, T4, FSQLTokens, TSym1, T_1, T_2, T_3, T_4,
    FTTableName: TSQLTokenRecord;
begin
  (*
VACUUM [ ( { FULL | FREEZE | VERBOSE | ANALYZE } [, ...] ) ] [ table [ (column [, ...] ) ] ]
VACUUM [ FULL ] [ FREEZE ] [ VERBOSE ] [ table ]
VACUUM [ FULL ] [ FREEZE ] [ VERBOSE ] ANALYZE [ table [ (column [, ...] ) ] ]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'VACUUM', [toFindWordLast, toFirstToken]);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'FULL', [], 1);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'FREEZE', [], 2);
    T3:=AddSQLTokens(stKeyword, FSQLTokens, 'VERBOSE', [], 3);
    T4:=AddSQLTokens(stKeyword, FSQLTokens, 'ANALYZE', [], 4);
    T1.AddChildToken([T2, T3, T4]);
    T2.AddChildToken([T1, T3, T4]);
    T3.AddChildToken([T1, T2, T4]);

  TSym1:=AddSQLTokens(stSymbol, FSQLTokens, '(', [], 10);
    T_1:=AddSQLTokens(stSymbol, TSym1, 'FULL', [], 1);
    T_2:=AddSQLTokens(stSymbol, TSym1, 'FREEZE', [], 2);
    T_3:=AddSQLTokens(stSymbol, TSym1, 'VERBOSE', [], 3);
    T_4:=AddSQLTokens(stSymbol, TSym1, 'ANALYZE', [], 4);
    TSym1:=AddSQLTokens(stSymbol, [T_1, T_2, T_3, T_4], ',', []);
      TSym1.AddChildToken([T_1, T_2, T_3, T_4]);
  TSym1:=AddSQLTokens(stSymbol, [T_1, T_2, T_3, T_4], ')', []);


  FTTableName:=AddSQLTokens(stIdentificator, [T1, T2, T3, T4, TSym1], '', [], 11);

  { TODO : Необходимо реализовать дерево парсера для VACUUM - по колонкам}
end;

procedure TPGSQLVacum.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    11:TableName:=AWord;
    1:FFull:=true;
    2:FFreeze:=true;
    3:FVerbose:=true;
    4:FAnalyze:=true;
    10:FCommandFormat:=true;
  end;
end;

procedure TPGSQLVacum.MakeSQL;
var
  S, S1: String;
begin
  S:='VACUUM';

  if CommandFormat then
  begin
    S1:='';
    if FFull then
    begin
      if S1<>'' then S1:=S1+', ';
      S1:=S1 + 'FULL';
    end;

    if FFreeze then
    begin
      if S1<>'' then S1:=S1+', ';
      S1:=S1 + 'FREEZE';
    end;
    if FVerbose then
    begin
      if S1<>'' then S1:=S1+', ';
      S1:=S1 + 'VERBOSE';
    end;
    if FAnalyze then
    begin
      if S1<>'' then S1:=S1+', ';
      S1:=S1 + 'ANALYZE';
    end;

    S:=S + ' ('+S1+')';
  end
  else
  begin
    if FFull then
      S:=S + ' FULL';
    if FFreeze then
        S:=S + ' FREEZE';
    if FVerbose then
      S:=S + ' VERBOSE';
    if FAnalyze then
      S:=S + ' ANALYZE';
  end;
  if TableName <> '' then
    S:=S + ' ' + TableName;
  AddSQLCommand(S);
end;

procedure TPGSQLVacum.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLVacum then
  begin
    Full:=TPGSQLVacum(ASource).Full;
    Freeze:=TPGSQLVacum(ASource).Freeze;
    Verbose:=TPGSQLVacum(ASource).Verbose;
    Analyze:=TPGSQLVacum(ASource).Analyze;
    FCommandFormat:=TPGSQLVacum(ASource).FCommandFormat;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLDropGroup }

procedure TPGSQLDropGroup.InitParserTree;
var
  FSQLTokens, T1, T2, T3, T: TSQLTokenRecord;
begin
  (* DROP GROUP [ IF EXISTS ] name [, ...] *)
  (* DROP ROLE [ IF EXISTS ] name [, ...] *)

  (* DROP USER [ IF EXISTS ] name [, ...] *)
  (* DROP USER MAPPING [ IF EXISTS ] FOR { user_name | USER | CURRENT_USER | PUBLIC } SERVER server_name *)

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okNone);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'GROUP', [toFindWordLast], 100, okGroup);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'ROLE', [toFindWordLast], 101, okRole);
    T3:=AddSQLTokens(stKeyword, FSQLTokens, 'USER', [toFindWordLast], 102, okUser);

    T:=AddSQLTokens(stKeyword, [T1, T2, T3], 'IF', [], -1);
    T:=AddSQLTokens(stKeyword, T, 'EXISTS', []);
  T:=AddSQLTokens(stIdentificator, [T, T1, T2, T3], '', [],  1);
  T1:=AddSQLTokens(stSymbol, T, ',', [toOptional]);
    T1.AddChildToken(T);
end;

procedure TPGSQLDropGroup.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Params.AddParam(AWord);
    100:ObjectKind:=okGroup;
    101:ObjectKind:=okRole;
    102:ObjectKind:=okUser;
  end;
end;

procedure TPGSQLDropGroup.MakeSQL;
var
  S1, S2: String;
begin
  S1:='';
  if ooIfExists in Options then S1:=' IF EXISTS';
  if Params.Count > 0 then S2:=Params.AsString
  else S2:=Name;

  AddSQLCommandEx('DROP %s%s %s', [PGObjectNames[ObjectKind], S1, S2]);
end;

procedure TPGSQLDropGroup.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLDropGroup then
  begin
    //GroupName:=TPGSQLDropGroup(ASource).GroupName;
    //RoleType:=TPGSQLDropGroup(ASource).RoleType;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLAlterGroup }

procedure TPGSQLAlterGroup.InitParserTree;
var
  T, FSQLTokens, FSQLTokens1, FTGroupName, T1: TSQLTokenRecord;
begin
  (* ALTER GROUP group_name ADD USER user_name [, ... ] *)
  (* ALTER GROUP group_name DROP USER user_name [, ... ] *)
  (* ALTER GROUP group_name RENAME TO new_name *)

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken], 0, okGroup);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'GROUP', [toFindWordLast]);

  FTGroupName:=AddSQLTokens(stIdentificator, T, '', [], 1);

  T:=AddSQLTokens(stKeyword, FTGroupName, 'ADD', []);
  T:=AddSQLTokens(stKeyword, T, 'USER', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 2);
  T1:=AddSQLTokens(stSymbol, T, ',', []);
  T1.AddChildToken(T);

  T:=AddSQLTokens(stKeyword, FTGroupName, 'DROP', []);
  T:=AddSQLTokens(stKeyword, T, 'USER', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 3);
  T1:=AddSQLTokens(stSymbol, T, ',', []);
  T1.AddChildToken(T);

  T:=AddSQLTokens(stKeyword, FTGroupName, 'RENAME', []);
  T:=AddSQLTokens(stKeyword, T, 'TO', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 4);
end;

procedure TPGSQLAlterGroup.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FGroupName:=AWord;
    2:begin
        Params.AddParam(AWord);
        FGroupOperator:=agoADD;
      end;
    3:begin
        Params.AddParam(AWord);
        FGroupOperator:=agoDROP;
      end;
    4:begin
        Params.AddParam(AWord);
        FGroupOperator:=agoRENAME;
      end;
  end;
end;

constructor TPGSQLAlterGroup.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okGroup;
  FSQLCommentOnClass:=TPGSQLCommentOn;
end;

procedure TPGSQLAlterGroup.MakeSQL;
var
  S: String;
begin
  S:='ALTER GROUP '+FGroupName;
  case FGroupOperator of
    agoADD:S:=S + ' ADD USER ';
    agoDROP:S:=S + ' DROP USER ';
    agoRENAME:S:=S + ' RENAME TO ';
  end;
  S:=S + Params.AsString;
  AddSQLCommand(S);
end;

procedure TPGSQLAlterGroup.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLAlterGroup then
  begin;
    GroupName:=TPGSQLAlterGroup(ASource).GroupName;
    GroupOperator:=TPGSQLAlterGroup(ASource).GroupOperator;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLCreateRole }

procedure TPGSQLCreateRole.InitParserTree;
var
  T, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T16,
    TP, T19_1, T12, T14, T13, T15, T19, T20, T20_1, T17,
    FSQLTokens, FSQLTokens1, T21, T21_1, TRN, FSQLTokens2,
    TOpt51, TOpt52, TPWD, T_GROUP, T_ROLE, T_USER: TSQLTokenRecord;
begin
(*
CREATE GROUP name [ [ WITH ] option [ ... ] ]

where option can be:

      SUPERUSER | NOSUPERUSER
    | CREATEDB | NOCREATEDB
    | CREATEROLE | NOCREATEROLE
    | CREATEUSER | NOCREATEUSER
    | REPLICATION | NOREPLICATION
    | INHERIT | NOINHERIT
    | LOGIN | NOLOGIN
    | [ ENCRYPTED | UNENCRYPTED ] PASSWORD 'password'
    | VALID UNTIL 'timestamp'
    | IN ROLE role_name [, ...]
    | IN GROUP role_name [, ...]
    | ROLE role_name [, ...]
    | ADMIN role_name [, ...]
    | USER role_name [, ...]
    | SYSID uid
    |CONNECTION LIMIT 12


CREATE USER имя [ [ WITH ] параметр [ ... ] ]

    Здесь параметр:

          SUPERUSER | NOSUPERUSER
        | CREATEDB | NOCREATEDB
        | CREATEROLE | NOCREATEROLE
        | INHERIT | NOINHERIT
        | LOGIN | NOLOGIN
        | REPLICATION | NOREPLICATION
        | BYPASSRLS | NOBYPASSRLS
        | CONNECTION LIMIT предел_подключений
        | [ ENCRYPTED | UNENCRYPTED ] PASSWORD 'пароль'
        | VALID UNTIL 'дата_время'
        | IN ROLE имя_роли [, ...]
        | IN GROUP имя_роли [, ...]
        | ROLE имя_роли [, ...]
        | ADMIN имя_роли [, ...]
        | USER имя_роли [, ...]
        | SYSID uid

CREATE ROLE имя [ [ WITH ] параметр [ ... ] ]

Здесь параметр:

      SUPERUSER | NOSUPERUSER
    | CREATEDB | NOCREATEDB
    | CREATEROLE | NOCREATEROLE
    | INHERIT | NOINHERIT
    | LOGIN | NOLOGIN
    | REPLICATION | NOREPLICATION
    | BYPASSRLS | NOBYPASSRLS
    | CONNECTION LIMIT предел_подключений
    | [ ENCRYPTED ] PASSWORD 'пароль'
    | VALID UNTIL 'дата_время'
    | IN ROLE имя_роли [, ...]
    | IN GROUP имя_роли [, ...]
    | ROLE имя_роли [, ...]
    | ADMIN имя_роли [, ...]
    | USER имя_роли [, ...]
    | SYSID uid
*)
  { TODO : Тут надо уйти от нескольких корней }

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okRole);
    T_GROUP:=AddSQLTokens(stKeyword, FSQLTokens, 'GROUP', [toFindWordLast], 100);
    T_ROLE :=AddSQLTokens(stKeyword, FSQLTokens, 'ROLE', [toFindWordLast], 101);
    T_USER :=AddSQLTokens(stKeyword, FSQLTokens, 'USER', [toFindWordLast], 102);

  TRN:=AddSQLTokens(stIdentificator, [T_GROUP, T_ROLE, T_USER], '', [], 1);

  T:=AddSQLTokens(stKeyword, TRN, 'WITH', [toOptional]);

  T2:=AddSQLTokens(stKeyword, [TRN, T], 'SUPERUSER', [toOptional], 2);
  T3:=AddSQLTokens(stKeyword, [TRN, T], 'NOSUPERUSER', [toOptional], 3);

  T4:=AddSQLTokens(stKeyword, [TRN, T], 'CREATEDB', [toOptional], 4);
  T5:=AddSQLTokens(stKeyword, [TRN, T], 'NOCREATEDB', [toOptional], 5);

  T6:=AddSQLTokens(stKeyword, [TRN, T], 'CREATEROLE', [toOptional], 6);
  T7:=AddSQLTokens(stKeyword, [TRN, T], 'NOCREATEROLE', [toOptional], 7);

  T8:=AddSQLTokens(stKeyword, [TRN, T], 'REPLICATION', [toOptional], 8);
  T9:=AddSQLTokens(stKeyword, [TRN, T], 'NOREPLICATION', [toOptional], 9);

  T10:=AddSQLTokens(stKeyword, [TRN, T], 'CREATEUSER', [toOptional], 10);
  T11:=AddSQLTokens(stKeyword, [TRN, T], 'NOCREATEUSER', [toOptional], 11);

  T12:=AddSQLTokens(stKeyword, [TRN, T], 'INHERIT', [toOptional], 12);
  T13:=AddSQLTokens(stKeyword, [TRN, T], 'NOINHERIT', [toOptional], 13);

  T14:=AddSQLTokens(stKeyword, [TRN, T], 'LOGIN', [toOptional], 14);
  T15:=AddSQLTokens(stKeyword, [TRN, T], 'NOLOGIN', [toOptional], 15);

  TOpt51:=AddSQLTokens(stKeyword, [TRN, T], 'BYPASSRLS', [toOptional], 51);
  TOpt52:=AddSQLTokens(stKeyword, [TRN, T], 'NOBYPASSRLS', [toOptional], 52);


  T16:=AddSQLTokens(stKeyword, [TRN, T], 'ENCRYPTED', [toOptional], 16);
  T17:=AddSQLTokens(stKeyword, [TRN, T], 'UNENCRYPTED', [toOptional], 17);
  TP:=AddSQLTokens(stKeyword, [TRN, T, T16, T17], 'PASSWORD', [toOptional]);
    TPWD:=AddSQLTokens(stString, TP, '', [], 18);

  T19:=AddSQLTokens(stKeyword, [TRN, T], 'VALID', [toOptional]);
  T19_1:=AddSQLTokens(stKeyword, T19, 'UNTIL', []);
  T19_1:=AddSQLTokens(stString, T19_1, '', [], 19);

  T20:=AddSQLTokens(stKeyword, [TRN, T], 'SYSID', [toOptional]);
    T20_1:=AddSQLTokens(stIdentificator, T, '', [], 20); //uid

  T21:=AddSQLTokens(stKeyword, [TRN, T], 'CONNECTION', [toOptional]);
    T21_1:=AddSQLTokens(stKeyword, T21, 'LIMIT', []);
    T21_1:=AddSQLTokens(stInteger, T21_1, '', [], 21);


  T2.AddChildToken([{T2, T3, } T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, TP, T19, T20, T21, TOpt51, TOpt52]);
  T3.CopyChildTokens(T2);

  T4.AddChildToken([T2, T3, {T4, T5, }T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, TP, T19, T20, T21, TOpt51, TOpt52]);
  T5.CopyChildTokens(T4);

  T6.AddChildToken([T2, T3, T4, T5, {T6, T7, }T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, TP, T19, T20, T21, TOpt51, TOpt52]);
  T7.CopyChildTokens(T6);

  T8.AddChildToken([T2, T3, T4, T5, T6, T7,{ T8, T9, }T10, T11, T12, T13, T14, T15, T16, T17, TP, T19, T20, T21, TOpt51, TOpt52]);
  T9.CopyChildTokens(T8);

  T10.AddChildToken([T2, T3, T4, T5, T6, T7, T8, T9, {T10, T11, }T12, T13, T14, T15, T16, T17, TP, T19, T20, T21, TOpt51, TOpt52]);
  T11.CopyChildTokens(T10);

  T12.AddChildToken([T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, {T12, T13, }T14, T15, T16, T17, TP, T19, T20, T21, TOpt51, TOpt52]);
  T13.CopyChildTokens(T10);

  T14.AddChildToken([T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, {T14, T15, }T16, T17, TP, T19, T20, T21, TOpt51, TOpt52]);
  T15.CopyChildTokens(T10);

  TOpt51.AddChildToken([T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, TP, T19, T20, T21{, TOpt51, TOpt52}]);
  TOpt52.CopyChildTokens(TOpt51);

  TPWD.AddChildToken([T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T17, TP, {T16, }T19, T20, T21, TOpt51, TOpt52]);
  T19_1.AddChildToken([T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16{, T19}, T20, T21, TOpt51, TOpt52]);

  T20_1.AddChildToken([T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, TP, T19{, T20}, T21, TOpt51, TOpt52]);
  T21_1.AddChildToken([T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, TP, T19, T20{, T21}, TOpt51, TOpt52]);

//  TRN.CopyChildTokens(T);

  {
| IN ROLE role_name [, ...]
| IN GROUP role_name [, ...]
| ROLE role_name [, ...]
| ADMIN role_name [, ...]
| USER role_name [, ...]
}
  { TODO : Необходимо реализовать дерево парсера для CREATE GROUP }
end;

procedure TPGSQLCreateRole.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    2:FUserOptions:=FUserOptions + [puoSuperUser];
    3:FUserOptions:=FUserOptions + [puoNoSuperUser];
    4:FUserOptions:=FUserOptions + [puoCreateDatabaseObjects];
    5:FUserOptions:=FUserOptions + [puoNoCreateDatabaseObjects];
    6:FUserOptions:=FUserOptions + [puoCreateRoles];
    7:FUserOptions:=FUserOptions + [puoNoCreateRoles];
    8:FUserOptions:=FUserOptions + [puoReplication];
    9:FUserOptions:=FUserOptions + [puoNoReplication];
    10:FUserOptions:=FUserOptions + [puoCreateUser];
    11:FUserOptions:=FUserOptions + [puoNoCreateUser];
    12:FUserOptions:=FUserOptions + [puoInheritedRight];
    13:FUserOptions:=FUserOptions + [puoNoInheritedRight];
    14:FUserOptions:=FUserOptions + [puoLoginEnabled];
    15:FUserOptions:=FUserOptions + [puoNoLoginEnabled];
    51:FUserOptions:=FUserOptions - [puoByPassRLS];
    52:FUserOptions:=FUserOptions - [puoByPassRLS];
    16:FPasswordEncripted:=true;
    17:FPasswordEncripted:=false;
    18:FPassword:=ExtractQuotedString(AWord, '''');
    19:FValidUntil:=ExtractQuotedString(AWord, '''');
    20:FSysId:=AWord;
    21:FConnectionLimit:=StrToInt(AWord);
    100:begin
           ObjectKind:=okGroup;
           //FUserOptions:=FUserOptions - [puoLoginEnabled];
        end;
    101:ObjectKind:=okRole;
    102:begin
          ObjectKind:=okUser;
          //FUserOptions:=FUserOptions + [puoLoginEnabled];
        end;
  end;

(*  puoChangeSystemCatalog,
                        puoNeverExpired,
                        puoByPassRLS)    *)
end;

constructor TPGSQLCreateRole.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSQLCommentOnClass:=TPGSQLCommentOn;
  ObjectKind:=okGroup;
  FServerVersion:=pgVersion9_0;
end;

procedure TPGSQLCreateRole.MakeSQL;
var
  S: String;
  G: TPGUserOption;
begin
  S:=Format('CREATE %s %s', [PGObjectNames[ObjectKind], Name]);

  for G in TPGUserOption do
  begin
    if (G = puoByPassRLS) and (ServerVersion < pgVersion9_6) then Continue;
    if (ObjectKind = okUser) and (G in [puoCreateUser]) then Continue;
    if G in FUserOptions then
    begin
      if PGUserOptionStr[G] <> '' then
        S:=S + ' ' + PGUserOptionStr[G];
    end
  end;


  if FPassword <> '' then
  begin
    if FPasswordEncripted then
      S:=S+ ' ENCRYPTED' {
    else
      S:=S+ ' UNENCRYPTED'};

    S:=S+ ' PASSWORD '+QuotedString(FPassword, '''');
  end;

  if FValidUntil<>'' then
      S:=S+ ' VALID UNTIL '+QuotedString(FValidUntil, '''');

  if FSysId <> '' then
    S:=S+ ' SYSID '''+FSysId + '''';

  if (FConnectionLimit <> 0) then
    S:=S+ ' CONNECTION LIMIT '+IntToStr(FConnectionLimit);

{
      | IN ROLE role_name [, ...]
      | IN GROUP role_name [, ...]
      | ROLE role_name [, ...]
      | ADMIN role_name [, ...]
      | USER role_name [, ...]
}
{  if S <> '' then
    Result:=Result + ' WITH '+S;}
  AddSQLCommand(S);

  if Description <> '' then
    DescribeObjectEx(ObjectKind, Name, '', Description);
end;

procedure TPGSQLCreateRole.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLCreateRole then
  begin
    UserOptions:=TPGSQLCreateRole(ASource).UserOptions;
    Password:=TPGSQLCreateRole(ASource).Password;
    ValidUntil:=TPGSQLCreateRole(ASource).ValidUntil;
    SysId:=TPGSQLCreateRole(ASource).SysId;
    ConnectionLimit:=TPGSQLCreateRole(ASource).ConnectionLimit;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLDropRule }

procedure TPGSQLDropRule.InitParserTree;
var
  T, T1, FSQLTokens: TSQLTokenRecord;
begin
  (* DROP RULE [ IF EXISTS ] name ON table [ CASCADE | RESTRICT ] *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okRule);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'RULE', [toFindWordLast]);

  T1:=AddSQLTokens(stKeyword, T, 'IF', [], -1);
  T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);

  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
  T1.AddChildToken(T);

  T:=AddSQLTokens(stKeyword, T, 'ON', []);

  T:=AddSQLTokens(stIdentificator, T, '', [], 2);
    T1:=AddSQLTokens(stSymbol, T, '.', []);
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 3);

  T1.AddChildToken(AddSQLTokens(stKeyword, T, 'CASCADE', [],  -2));
  T1.AddChildToken(AddSQLTokens(stKeyword, T, 'RESTRICT', [], -3));
end;

procedure TPGSQLDropRule.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    2:FTableName:=AWord;
    3:begin
        SchemaName:=FTableName;
        FTableName:=AWord;
      end;
  end;
end;

procedure TPGSQLDropRule.MakeSQL;
var
  Result: String;
begin
  Result:='DROP RULE';
  if ooIfExists in Options then
    Result:=Result + ' IF EXISTS';
  Result:=Result + ' ' + Name + ' ON ';

  if SchemaName <> '' then
    Result:=Result + SchemaName+'.';

  Result:=Result + FTableName;

  if DropRule = drCascade then
    Result:=Result + ' CASCADE'
  else
  if DropRule = drRestrict then
    Result:=Result + ' RESTRICT';
  AddSQLCommand(Result);
end;

procedure TPGSQLDropRule.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLDropRule then
  begin
    TableName:=TPGSQLDropRule(ASource).TableName;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLDropFunction }

procedure TPGSQLDropFunction.InitParserTree;
var
  T1, T, T2, T3, T4, T5, FSQLTokens, TSymb, TSymb2: TSQLTokenRecord;
begin
  (* DROP FUNCTION [ IF EXISTS ] name ( [ [ argmode ] [ argname ] argtype [, ...] ] ) [ CASCADE | RESTRICT ] *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okStoredProc);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'FUNCTION', [toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, T, 'IF', [], -1);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
    T2:=AddSQLTokens(stSymbol, T, '.', []);
    T2:=AddSQLTokens(stIdentificator, T2, '', [], 7);
  T1.AddChildToken(T);

  TSymb:=AddSQLTokens(stSymbol, [T, T2], '(', []);
  TSymb2:=AddSQLTokens(stSymbol, nil, ')', [], 5);

  CreateInParamsTree(Self, TSymb, TSymb2);


  AddSQLTokens(stKeyword, TSymb2, 'CASCADE', [toOptional], -2);
  AddSQLTokens(stKeyword, TSymb2, 'RESTRICT', [toOptional], -3);
end;

procedure TPGSQLDropFunction.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    101..104:begin
        FCurParam:=Params.AddParam('');
        case AChild.Tag of
          101:FCurParam.InReturn:=spvtInput;
          102:FCurParam.InReturn:=spvtOutput;
          103:FCurParam.InReturn:=spvtInOut;
          104:FCurParam.InReturn:=spvtVariadic;
        end;
      end;
    105:begin
          if not Assigned(FCurParam) then
            FCurParam:=Params.AddParamWithType('', AWord)
          else
            FCurParam.TypeName:=AWord;
        end;
    106:if Assigned(FCurParam) then
        begin
           if FCurParam.Caption = '' then
           begin
             FCurParam.Caption:=FCurParam.TypeName;
             FCurParam.TypeName:=AWord;
           end
           else
             FCurParam.TypeName:=FCurParam.TypeName + AWord;
        end;
    107:if Assigned(FCurParam) then FCurParam.TypeName:=FCurParam.TypeName + AWord;
    108:if Assigned(FCurParam) then FCurParam.TypeName:=FCurParam.TypeName + ' ' + AWord;
    109,
    110:FCurParam:=nil;

    7:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
  end;


end;

procedure TPGSQLDropFunction.MakeSQL;
var
  S, S1: String;
  R: TSQLParserField;
begin
  S:='DROP FUNCTION';
  if ooIfExists in Options then S:=S + ' IF EXISTS';
  S:=S + ' ' + FullName + '(';

  S1:='';
  for R in Params do
  begin
    if S1<>'' then S1:=S1 + ',';
    S1:=S1 + ' ' +PGVarTypeNames[R.InReturn];
    if R.Caption<>'' then S1:=S1+' '+R.Caption;
    S1:=S1+' '+R.TypeName;
  end;
  S:=S + S1 + ')';

  if DropRule = drCascade then S:=S + ' CASCADE'
  else
  if DropRule = drRestrict then S:=S + ' RESTRICT';

  AddSQLCommand(S);
end;


{ TPGSQLAlterFunction }

procedure TPGSQLAlterFunction.InitParserTree;
var
  FSQLTokens, TSymb, TSymb2, T, T2: TSQLTokenRecord;
begin
  { TODO : Реализовать парсер ALTER FUNCTION }
  (*
  ALTER FUNCTION name ( [ [ argmode ] [ argname ] argtype [, ...] ] ) action [ ... ] [ RESTRICT ]
  ALTER FUNCTION name ( [ [ argmode ] [ argname ] argtype [, ...] ] ) RENAME TO new_name
  ALTER FUNCTION name ( [ [ argmode ] [ argname ] argtype [, ...] ] ) OWNER TO new_owner
  ALTER FUNCTION name ( [ [ argmode ] [ argname ] argtype [, ...] ] ) SET SCHEMA new_schema

  where action is one of:

      CALLED ON NULL INPUT | RETURNS NULL ON NULL INPUT | STRICT
      IMMUTABLE | STABLE | VOLATILE
      [ EXTERNAL ] SECURITY INVOKER | [ EXTERNAL ] SECURITY DEFINER
      COST execution_cost
      ROWS result_rows
      SET configuration_parameter { TO | = } { value | DEFAULT }
      SET configuration_parameter FROM CURRENT
      RESET configuration_parameter
      RESET ALL
  *)
  { TODO : Необходимо реализовать парсер ALTER FUNCTION }
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken], 0, okStoredProc);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'FUNCTION', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, T, '', [],  1);
    T2:=AddSQLTokens(stSymbol, T, '.', []);
    T2:=AddSQLTokens(stIdentificator, T2, '', [], 7);

  TSymb:=AddSQLTokens(stSymbol, [T,T2], '(', []);
  TSymb2:=AddSQLTokens(stSymbol, TSymb, ')', [], 5);

  CreateInParamsTree(Self, TSymb, TSymb2);

  T:=AddSQLTokens(stKeyword, TSymb2, 'RENAME', [], 10);
  T:=AddSQLTokens(stKeyword, T, 'TO', []);
  AddSQLTokens(stIdentificator, T, '', [], 11);

  T:=AddSQLTokens(stKeyword, TSymb2, 'OWNER', [],  12);
  T:=AddSQLTokens(stKeyword, T, 'TO', []);
  AddSQLTokens(stIdentificator, T, '', [], 13);

  T:=AddSQLTokens(stKeyword, TSymb2, 'SET', [], 14);
  T:=AddSQLTokens(stKeyword, T, 'SCHEMA', []);
  AddSQLTokens(stIdentificator, T, '', [], 15);

end;

procedure TPGSQLAlterFunction.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:Name:=AWord;

    101..104:begin
        FCurParam:=Params.AddParam('');
        case AChild.Tag of
          101:FCurParam.InReturn:=spvtInput;
          102:FCurParam.InReturn:=spvtOutput;
          103:FCurParam.InReturn:=spvtInOut;
          104:FCurParam.InReturn:=spvtVariadic;
        end;
      end;
    105:begin
          if not Assigned(FCurParam) then
            FCurParam:=Params.AddParamWithType('', AWord)
          else
            FCurParam.TypeName:=AWord;
        end;
    106:if Assigned(FCurParam) then
        begin
           if FCurParam.Caption = '' then
           begin
             FCurParam.Caption:=FCurParam.TypeName;
             FCurParam.TypeName:=AWord;
           end
           else
             FCurParam.TypeName:=FCurParam.TypeName + AWord;
        end;
    107:if Assigned(FCurParam) then FCurParam.TypeName:=FCurParam.TypeName + AWord;
    108:if Assigned(FCurParam) then FCurParam.TypeName:=FCurParam.TypeName + ' ' + AWord;
    109,
    110:FCurParam:=nil;

    7:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
    11:FNewName:=AWord;
    13:FNewOwner:=AWord;
    15:FNewSchema:=AWord;
  end;
end;

procedure TPGSQLAlterFunction.MakeSQL;
var
  S, S1: String;
  R: TSQLParserField;
begin
  S:='ALTER FUNCTION ';

  if SchemaName<>'' then
    S:=S + SchemaName + '.' + Name + '('
  else
    S:=S + Name + '(';

  S1:='';

  for R in Params do
  begin
    if S1<>'' then S1:=S1 + ',';
    S1:=S1 + ' ' +PGVarTypeNames[R.InReturn];
    if R.Caption<>'' then S1:=S1+' '+R.Caption;
    S1:=S1+' '+R.TypeName;
  end;

  S:=S + S1 + ')';

  if FNewName <> '' then
    S:=S + ' RENAME TO '+FNewName
  else
  if FNewOwner <> '' then
    S:=S + ' OWNER TO '+FNewOwner
  else
  if FNewSchema <> '' then
    S:=S + ' SET SCHEMA '+FNewSchema
  ;
  AddSQLCommand(S)
end;

constructor TPGSQLAlterFunction.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okStoredProc;
  FSQLCommentOnClass:=TPGSQLCommentOn;
end;

procedure TPGSQLAlterFunction.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLAlterFunction then
  begin
    NewName:=TPGSQLAlterFunction(ASource).NewName;
    NewOwner:=TPGSQLAlterFunction(ASource).NewOwner;
    NewSchema:=TPGSQLAlterFunction(ASource).NewSchema;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLAlterSequence }

procedure TPGSQLAlterSequence.InitParserTree;
var
  T1, T, T10, T11, T12, T13, T9, T8, T7, T6, T5, T4, T3, T14,
    T15, T16, T17, T18, T19, T3_1, T4_1, T5_1, T9_1, T15_1,
    T14_1, T20, T2, FSQLTokens: TSQLTokenRecord;
begin
  (*
  ALTER SEQUENCE name [ INCREMENT [ BY ] increment ]
      [ MINVALUE minvalue | NO MINVALUE ] [ MAXVALUE maxvalue | NO MAXVALUE ]
      [ START [ WITH ] start ]
      [ RESTART [ [ WITH ] restart ] ]
      [ CACHE cache ] [ [ NO ] CYCLE ]
      [ OWNED BY { table.column | NONE } ]
  ALTER SEQUENCE name OWNER TO new_owner
  ALTER SEQUENCE name RENAME TO new_name
  ALTER SEQUENCE name SET SCHEMA new_schema
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken], 0 , okSequence);
    T10:=AddSQLTokens(stKeyword, FSQLTokens, 'SEQUENCE', [toFindWordLast]);
  T2:=AddSQLTokens(stIdentificator, T10, '', [], 1);
  T10:=AddSQLTokens(stSymbol, T2, '.', []);
  T:=AddSQLTokens(stIdentificator, T10, '', [], 2);

  T3:=AddSQLTokens(stKeyword, T, 'INCREMENT', []);
  T1:=AddSQLTokens(stKeyword, T3, 'BY', []);
  T3_1:=AddSQLTokens(stInteger, T1, '', [], 3);
    T3.AddChildToken(T3_1);

  T4:=AddSQLTokens(stKeyword, T, 'MINVALUE', []);
  T4_1:=AddSQLTokens(stInteger, T4, '', [], 4);

  T5:=AddSQLTokens(stKeyword, T, 'MAXVALUE', []);
  T5_1:=AddSQLTokens(stInteger, T5, '', [], 5);

  T6:=AddSQLTokens(stKeyword, T, 'NO', []);
  T7:=AddSQLTokens(stKeyword, T6, 'MINVALUE', [], 7);
  T8:=AddSQLTokens(stKeyword, T6, 'MAXVALUE', [], 8);
  T10:=AddSQLTokens(stKeyword, T6, 'CYCLE', [], 10);

  T9:=AddSQLTokens(stKeyword, T, 'START', []);
    T1:=AddSQLTokens(stKeyword, T9, 'WITH', []);
    T9_1:=AddSQLTokens(stInteger, T1, '', [], 9);
    T9.AddChildToken(T9_1);

  T14:=AddSQLTokens(stKeyword, T, 'RESTART', []);
    T1:=AddSQLTokens(stKeyword, T9, 'WITH', []);
    T14_1:=AddSQLTokens(stInteger, T1, '', [], 14);
    T14.AddChildToken(T14_1);

  T15:=AddSQLTokens(stKeyword, T, 'CACHE', []);
    T15_1:=AddSQLTokens(stInteger, T15, '', [], 15);

  T16:=AddSQLTokens(stKeyword, T, 'OWNED', []);
    T17:=AddSQLTokens(stKeyword, T16, 'BY', []);
    T17:=AddSQLTokens(stIdentificator, T17, '', [], 17);
    T1:=AddSQLTokens(stSymbol, T17, '.', []);
    T18:=AddSQLTokens(stIdentificator, T1, '', [], 18);
    T1:=AddSQLTokens(stSymbol, T18, '.', []);
    T19:=AddSQLTokens(stIdentificator, T1, '', [], 19);
    T20:=AddSQLTokens(stKeyword, T16, 'NONE', [], 20);

  T11:=AddSQLTokens(stKeyword, T, 'OWNER', []);
  T1:=AddSQLTokens(stKeyword, T11, 'TO', []);
  T1:=AddSQLTokens(stIdentificator, T1, '', [], 11);

  T12:=AddSQLTokens(stKeyword, T, 'RENAME', []);
  T1:=AddSQLTokens(stKeyword, T12, 'TO', []);
  T1:=AddSQLTokens(stIdentificator, T1, '', [], 12);

  T13:=AddSQLTokens(stKeyword, T, 'SET', []);
  T1:=AddSQLTokens(stKeyword, T13, 'SCHEMA', []);
  T1:=AddSQLTokens(stIdentificator, T1, '', [], 13);

  T2.CopyChildTokens(T);

  T3_1.AddChildToken([{T3, }T4, T5, T6, T9, T14, T15, T16]);
  T4_1.AddChildToken([T3, {T4,} T5, T6, T9, T14, T15, T16]);
  T5_1.AddChildToken([T3, T4, { T5,} T6, T9, T14, T15, T16]);
  T7.AddChildToken([T3, T4, { T5,} T6, T9, T14, T15, T16]);
  T8.AddChildToken([T3, T4, { T5,} T6, T9, T14, T15, T16]);
  T10.AddChildToken([T3, T4, T5, {T6, }T9, T14, T15, T16]);
  T9_1.AddChildToken([T3, T4, T5, T6, {T9,} T14, T15, T16]);
  T14_1.AddChildToken([T3, T4, T5, T6, T9, {T14,} T15, T16]);
  T15_1.AddChildToken([T3, T4, T5, T6, T9, T14, {T15,} T16]);
  T19.AddChildToken([T3, T4, T5, T6, T9, T14, T15 {,T16}]);
  T20.AddChildToken([T3, T4, T5, T6, T9, T14, T15 {,T16}]);
end;

procedure TPGSQLAlterSequence.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    2:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
    3:FIncrementBy:=StrToInt64(AWord);
    4:MinValue:=StrToInt64(AWord);
    5:MaxValue:=StrToInt64(AWord);
    7:NoMinValue:=true;
    8:NoMaxValue:=true;
    9:Start:=StrToInt64(AWord);
    10:NoCycle:=true;
{    11:FSequenceNewOwner:=AWord;
    12:FSequenceNewName:=AWord;
    13:FSequenceNewSchema:=AWord;}
    14:Restart:=StrToInt64(AWord);
    15:Cache:=StrToInt64(AWord);
    17, 20:FOwnedBy:=AWord;
    18, 19:FOwnedBy:=FOwnedBy + '.'+AWord;
  end;
end;

procedure TPGSQLAlterSequence.MakeSQL;
var
  S: String;
begin
  S:='ALTER SEQUENCE ' + FullName;

  if (FSequenceOldName <> '') and (Name <> FSequenceOldName) then
    AddSQLCommand(S + ' RENAME TO ' + Name);

  if (OldValue <> CurrentValue) then
    AddSQLCommand('SELECT setval('''+FullName+''', '+IntToStr(CurrentValue)+', true)');
(*
  if FSequenceNewOwner <> '' then
    Result:=Result + ' OWNER TO ' + FSequenceNewOwner
  else
  if FSequenceNewSchema <> '' then
    Result:=Result + ' SET SCHEMA ' + FSequenceNewSchema
  else
  begin

    if FIncrementBy <> 0 then
      Result:=Result + ' INCREMENT BY ' + IntToStr(FIncrementBy);

    if FNoMinValue then
      Result:=Result + ' NO MINVALUE'
    else
    if FMinValue <> 0 then
      Result:=Result + ' MINVALUE ' + IntToStr(FMinValue);

    if FNoMaxValue then
      Result:=Result + ' NO MAXVALUE'
    else
    if FMaxValue <> 0 then
      Result:=Result + ' MAXVALUE ' + IntToStr(FMaxValue);

    if FStart <> 0 then
      Result:=Result + ' START WITH ' + IntToStr(FStart);

    if FRestart <> 0 then
      { TODO : Доработать парсер RESTART [ [ WITH }
      Result:=Result + ' RESTART WITH ' + IntToStr(FRestart);

    if FCache <> 0 then
      Result:=Result + ' CACHE ' + IntToStr(FCache);

    if FNoCycle then
      { TODO : Доработать парсер NO ] CYCLE }
      Result:=Result + ' NO CYCLE ';

    if FOwnedBy <> '' then
      Result:=Result + ' OWNED BY ' + FOwnedBy;
  end;
*)

end;

procedure TPGSQLAlterSequence.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLAlterSequence then
  begin
    SequenceOldOwner:=TPGSQLAlterSequence(ASource).SequenceOldOwner ;
    SequenceOldName:=TPGSQLAlterSequence(ASource).SequenceOldName;
    SequenceOldSchema:=TPGSQLAlterSequence(ASource).SequenceOldSchema;
    OldValue:=TPGSQLAlterSequence(ASource).OldValue;
  end;
  inherited Assign(ASource);
end;


{ TPGSQLDropSequence }

procedure TPGSQLDropSequence.InitParserTree;
var
  T1, T, T2, FSQLTokens: TSQLTokenRecord;
begin
  (* DROP SEQUENCE [ IF EXISTS ] name [, ...] [ CASCADE | RESTRICT ] *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okSequence);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'SEQUENCE', [toFindWordLast]);
    T:=AddSQLTokens(stKeyword, T1, 'IF', [], -1);
    T:=AddSQLTokens(stKeyword, T, 'EXISTS', []);

  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
    T1.AddChildToken(T);

  T2:=AddSQLTokens(stSymbol, T, '.', []);
  T2:=AddSQLTokens(stIdentificator, T2, '', [], 7);

  T1:=AddSQLTokens(stKeyword, T, 'CASCADE', [], -2);
    T2.AddChildToken(T1);
  T1:=AddSQLTokens(stKeyword, T, 'RESTRICT', [], -3);
end;

procedure TPGSQLDropSequence.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    7:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
  end;
end;

procedure TPGSQLDropSequence.MakeSQL;
var
  S: String;
begin
  S:='DROP SEQUENCE';
  if ooIfExists in Options then
    S:=S +' IF EXISTS';

  S:=S +' ' + FullName;

  if DropRule = drCascade then
    S:=S +' CASCADE'
  else
  if DropRule = drRestrict then
    S:=S +' RESTRICT';
  AddSQLCommand(S);
end;


{ TPGSQLCreateSequence }

procedure TPGSQLCreateSequence.InitParserTree;
var
  FTSequenceShema, FTSequenceName, T1, T2, T, T2_1, T3_1, T3,
    T4, T4_1, T_NO, T5_1, T6_1, T7_1, T20, T19, T18, T17, T16,
    T9_1, T9, T8_1, T8, FSQLTokens: TSQLTokenRecord;
begin
(*
CREATE [ TEMPORARY | TEMP ] SEQUENCE name [ INCREMENT [ BY ] increment ]
    [ MINVALUE minvalue | NO MINVALUE ] [ MAXVALUE maxvalue | NO MAXVALUE ]
    [ START [ WITH ] start ] [ CACHE cache ] [ [ NO ] CYCLE ]
    [ OWNED BY { table.column | NONE } ]
*)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okSequence);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'TEMPORARY', [], 1);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'TEMP', [], 1);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'SEQUENCE', [toFindWordLast]);          //SEQUENCE
    T1.AddChildToken(T);
    T2.AddChildToken(T);

  FTSequenceShema:=AddSQLTokens(stIdentificator, T, '', [], 100);
  T:=AddSQLTokens(stSymbol, FTSequenceShema, '.', []);
  FTSequenceName:=AddSQLTokens(stIdentificator, T, '', [], 101);

  T2:=AddSQLTokens(stKeyword, FTSequenceName, 'INCREMENT', []);
    T2_1:=AddSQLTokens(stKeyword, T2, 'BY', [toOptional]);
    T2_1:=AddSQLTokens(stInteger, T2_1, '', [], 2);
    T2.AddChildToken(T2_1);

  T3:=AddSQLTokens(stKeyword, FTSequenceName, 'MINVALUE', []);
    T3_1:=AddSQLTokens(stInteger, T3, '', [], 3);

  T4:=AddSQLTokens(stKeyword, FTSequenceName, 'MAXVALUE', []);
    T4_1:=AddSQLTokens(stInteger, T4, '', [], 4);

  T_NO:=AddSQLTokens(stKeyword, FTSequenceName, 'NO', []);
    T5_1:=AddSQLTokens(stKeyword, T_NO, 'MINVALUE', [], 5);
    T6_1:=AddSQLTokens(stKeyword, T_NO, 'MAXVALUE', [], 6);
    T7_1:=AddSQLTokens(stKeyword, T_NO, 'CYCLE', [], 7);

  T8:=AddSQLTokens(stKeyword, FTSequenceName, 'START', []);
    T:=AddSQLTokens(stKeyword, T8, 'WITH', [toOptional]);
    T8_1:=AddSQLTokens(stInteger, T1, '', [], 8);
    T8.AddChildToken(T8_1);

  T9:=AddSQLTokens(stKeyword, FTSequenceName, 'CACHE', []);
    T9_1:=AddSQLTokens(stInteger, T9, '', [], 9);

  T16:=AddSQLTokens(stKeyword, FTSequenceName, 'OWNED', []);
    T17:=AddSQLTokens(stKeyword, T16, 'BY', []);
    T17:=AddSQLTokens(stIdentificator, T17, '', [], 17);
    T1:=AddSQLTokens(stSymbol, T17, '.', []);
    T18:=AddSQLTokens(stIdentificator, T1, '', [], 18);
    T1:=AddSQLTokens(stSymbol, T18, '.', []);
    T19:=AddSQLTokens(stIdentificator, T1, '', [], 19);
    T20:=AddSQLTokens(stKeyword, T16, 'NONE', [], 20);

  FTSequenceShema.CopyChildTokens(FTSequenceName);
  T2_1.AddChildToken([T2,  T3, T4, T_NO, T8, T9, T16]);
  T3_1.CopyChildTokens(T2_1);
  T4_1.CopyChildTokens(T2_1);
  T5_1.CopyChildTokens(T2_1);
  T6_1.CopyChildTokens(T2_1);
  T7_1.CopyChildTokens(T2_1);
  T8_1.CopyChildTokens(T2_1);
  T9_1.CopyChildTokens(T2_1);
  T18.CopyChildTokens(T2_1);
  T19.CopyChildTokens(T2_1);
  T20.CopyChildTokens(T2_1);
end;

procedure TPGSQLCreateSequence.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Options:=Options + [ooTemporary];
    2:IncrementBy:=StrToInt64(AWord);
    3:MinValue:=StrToInt64(AWord);
    4:MaxValue:=StrToInt64(AWord);
    5:NoMinValue:=true;
    6:NoMaxValue:=true;
    7:NoCycle:=true;
    8:Start:=StrToInt64(AWord);
    9:Cache:=StrToInt64(AWord);
    17, 20:FOwnedBy:=AWord;
    18, 19:FOwnedBy:=FOwnedBy + '.'+AWord;
    100:Name:=AWord;
    101:begin
          SchemaName:=Name;
          Name:=AWord;
        end;
  end;
end;

procedure TPGSQLCreateSequence.MakeSQL;
var
  S: String;
begin
  S:='CREATE';
  if ooTemporary in Options then
    S:=S + ' TEMPORARY';
  S:=S + ' SEQUENCE ' + FullName;

  if IncrementBy <> 0 then
    S:=S + ' INCREMENT BY '+IntToStr(IncrementBy);

  if FNoMinValue then
    S:=S + ' NO MINVALUE '
  else
  if MinValue<>0 then
    S:=S + ' MINVALUE ' +IntToStr(MinValue);

  if NoMaxValue then
    S:=S + ' NO MAXVALUE '
  else
  if MaxValue<>0 then
    S:=S + ' MAXVALUE ' +IntToStr(MaxValue);

  if Start <> 0 then
    S:=S + ' START WITH ' +IntToStr(Start);

  if Cache <> 0 then
    S:=S + ' CACHE ' +IntToStr(Cache);

  if NoCycle then
    S:=S + ' NO CYCLE';

  if OwnedBy <> '' then
    S:=S + ' OWNED BY '+OwnedBy;

  AddSQLCommand(S);

  if CurrentValue <> 0 then
    AddSQLCommand('SELECT setval('''+FullName+''', '+IntToStr(CurrentValue)+', true)');

  if Description <> '' then
    DescribeObject;
end;

constructor TPGSQLCreateSequence.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSQLCommentOnClass:=TPGSQLCommentOn;
end;

procedure TPGSQLCreateSequence.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLCreateSequence then
  begin
    OwnedBy:=TPGSQLCreateSequence(ASource).OwnedBy;
    NoMinValue:=TPGSQLCreateSequence(ASource).NoMinValue;
    NoMaxValue:=TPGSQLCreateSequence(ASource).NoMaxValue;
    Start:=TPGSQLCreateSequence(ASource).Start;
    Restart:=TPGSQLCreateSequence(ASource).Restart;
    Cache:=TPGSQLCreateSequence(ASource).Cache;
    NoCycle:=TPGSQLCreateSequence(ASource).NoCycle;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLCreateSchema }

procedure TPGSQLCreateSchema.InitParserTree;
var
  T, T1, FSQLTokens: TSQLTokenRecord;
begin
  { TODO : Реализовать парсер schema_element }
(* CREATE SCHEMA schema_name [ AUTHORIZATION user_name ] [ schema_element [ ... ] ] *)
(*  CREATE SCHEMA AUTHORIZATION user_name [ schema_element [ ... ] ] *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okScheme);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'SCHEMA', [toFindWordLast]);

  T1:=AddSQLTokens(stIdentificator, T, '', [], 1);

  T:=AddSQLTokens(stKeyword, T, 'AUTHORIZATION', []);
    T1.AddChildToken(T);
  T:=AddSQLTokens(stIdentificator, T, '', [], 2);
end;

procedure TPGSQLCreateSchema.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    2:FOwnerUserName:=AWord;
  end;
end;

procedure TPGSQLCreateSchema.MakeSQL;
var
  S: String;
begin
  if Name = '' then
    S:='CREATE SCHEMA'
  else
    S:='CREATE SCHEMA ' + Name;

  if FOwnerUserName <> '' then
    S:=S + ' AUTHORIZATION ' +FOwnerUserName;

  AddSQLCommand(S);

  if Description <> '' then
    AddSQLCommandEx('COMMENT ON SCHEMA %s IS %s', [Name, QuotedStr(Description)]);
end;

constructor TPGSQLCreateSchema.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okScheme;
  FSQLCommentOnClass:=TPGSQLCommentOn;
end;

procedure TPGSQLCreateSchema.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLCreateSchema then
  begin
    OwnerUserName:=TPGSQLCreateSchema(ASource).OwnerUserName;
  end;
  inherited Assign(ASource);
end;

{ TPGSQLAlterTable }

procedure TPGSQLAlterTable.AddCollumn(OP: TAlterTableOperator);
var
  S, S1: String;
  C: TSQLConstraintItem;
  CI: TPGSQLCreateIndex;
begin
  S:='';
  if ooIfNotExists in OP.Options then
    S1:='IF NOT EXISTS '
  else
    S1:='';

  if OP.InitialValue <> '' then
  begin

    AddSQLCommandEx('ALTER TABLE %s ADD COLUMN %s%s %s', [FullName, S1, OP.Field.Caption, OP.DBMSTypeName]);
    AddSQLCommandEx('UPDATE %s SET %s  = %s', [FullName, OP.Field.Caption, OP.InitialValue]);
    S:=OP.Field.FullTypeName;
    if OP.Field.Collate <> '' then S:=S + ' COLLATE '+OP.Field.Collate;
    AddSQLCommandEx('ALTER TABLE %s ALTER COLUMN %s SET DATA TYPE %s', [FullName, OP.Field.Caption, S]);

    if OP.Field.DefaultValue <> '' then
      AddSQLCommandEx('ALTER TABLE %s ALTER COLUMN %s SET DEFAULT %s', [FullName, OP.Field.Caption, OP.Field.DefaultValue]);
    if fpNotNull in OP.Field.Params then
      AddSQLCommandEx('ALTER TABLE %s ALTER COLUMN %s SET NOT NULL', [FullName, OP.Field.Caption]);
//      ALTER TABLE public.aaaa ADD CONSTRAINT aaaa_aa_check CHECK ((aa <> 0));
  end
  else
  begin
    for C in OP.Constraints do
    begin
      if C.ConstraintName <> '' then
        S:=' CONSTRAINT '+C.ConstraintName;
      case C.ConstraintType of
        ctPrimaryKey:if not OP.Field.PrimaryKey then S:=S + ' PRIMARY KEY';
        ctForeignKey:begin
                       S:=S + ' REFERENCES ' + C.ForeignTable;
                       if C.ForeignFields.Count > 0 then
                         S:=S+'('+C.ForeignFields.AsString+')';
                       if C.ForeignKeyRuleOnUpdate<>fkrNone then S:=S+' ON UPDATE ' + ForeignKeyRuleNames[C.ForeignKeyRuleOnUpdate];
                       if C.ForeignKeyRuleOnDelete<>fkrNone then S:=S+' ON DELETE ' + ForeignKeyRuleNames[C.ForeignKeyRuleOnDelete];
                     end;
        ctUnique:S:=S + ' UNIQUE';
      end;

      if C.IndexName <> '' then
      begin
        CI:=TPGSQLCreateIndex.Create(Self);
        AddChild(CI);
        //CI.IndexMethod:=C.IndexSortOrder;
        CI.Name:=C.IndexName;
        CI.TableName:=FullName;
        CI.Fields.AddParam(OP.Field);
{        //CI.
        AddSQLCommand(CI.AsSQL);
        CI.Free;}
      end;
    end;
    if OP.Field.PrimaryKey then S:=S + ' PRIMARY KEY';
    if OP.Field.CheckExpr <> '' then S:=S + ' CHECK(' + OP.Field.CheckExpr + ')';
    if OP.Field.DefaultValue <> '' then S:=S + ' DEFAULT '+OP.Field.DefaultValue;

    AddSQLCommandEx('ALTER TABLE %s ADD COLUMN %s%s %s%s', [FullName, S1, OP.Field.Caption, OP.Field.FullTypeName, S]);
  end;

  if OP.Field.Description<>'' then
    DescribeObjectEx(okColumn, OP.Field.Caption, FullName, OP.Field.Description);
end;

procedure TPGSQLAlterTable.InitParserTree;
var
  T1, T, T2, FSQLTokens, FTShemaName, FTTableName,
    FTTableNameNew, TR, T7, TSymb2, TAdd, TColName, TDrop,
    TColName1, TConstrName1, TOwnTo, TOwnTo1, TEnableT,
    TDisableT, T3, TTrigName, TTrigNameAll, TTrigNameUser,
    TAltCol, TAltCol1, TColName2, TTrig, TConst, TConstName,
    TConstCheck, TSymb, TConstUnique, TConstPK, TConstFK,
    TConstFKTbl, TConstFKTbl1, TConstFKFld, TConstFKMatch,
    TConstFKMatch1, TConstFKMatch2, TConstFKMatch3, TConstFKOn,
    TConstFKOn1, TConstFKOn2, TConstFKOn10, TConstFKOn11,
    TConstFKOn12, TConstFKOn13, TConstFKOn14: TSQLTokenRecord;
begin
  { TODO : Реализовать парсер ALTER TABLE }
  (* ALTER TABLE name SET SCHEMA new_schema *)
  (* ALTER TABLE name SET TABLESPACE new_tablespace *)
  (* ALTER TABLE name RENAME TO new_name *)
(*
ALTER TABLE [ ONLY ] name [ * ]
    action [, ... ]
ALTER TABLE [ ONLY ] name [ * ]
    RENAME [ COLUMN ] column TO new_column

where action is one of:

    ADD [ COLUMN ] [ IF NOT EXISTS ] column data_type [ COLLATE collation ] [ column_constraint [ ... ] ]
    DROP [ COLUMN ] [ IF EXISTS ] column [ RESTRICT | CASCADE ]
    ALTER [ COLUMN ] column SET DEFAULT expression
    ALTER [ COLUMN ] column DROP DEFAULT
    ALTER [ COLUMN ] column { SET | DROP } NOT NULL
    ALTER [ COLUMN ] column SET STATISTICS integer
    ALTER [ COLUMN ] column SET ( attribute_option = value [, ... ] )
    ALTER [ COLUMN ] column RESET ( attribute_option [, ... ] )
    ALTER [ COLUMN ] column SET STORAGE { PLAIN | EXTERNAL | EXTENDED | MAIN }
    ADD table_constraint [ NOT VALID ]
    ADD table_constraint_using_index
    VALIDATE CONSTRAINT constraint_name
    DROP CONSTRAINT [ IF EXISTS ]  constraint_name [ RESTRICT | CASCADE ]
+    DISABLE TRIGGER [ trigger_name | ALL | USER ]
+    ENABLE TRIGGER [ trigger_name | ALL | USER ]
    ENABLE REPLICA TRIGGER trigger_name
    ENABLE ALWAYS TRIGGER trigger_name
    DISABLE RULE rewrite_rule_name
    ENABLE RULE rewrite_rule_name
    ENABLE REPLICA RULE rewrite_rule_name
    ENABLE ALWAYS RULE rewrite_rule_name
    CLUSTER ON index_name

    RESET ( storage_parameter [, ... ] )
    INHERIT parent_table
    NO INHERIT parent_table
    OF type_name
    NOT OF
    OWNER TO new_owner


and table_constraint_using_index is:

    [ CONSTRAINT constraint_name ]
    { UNIQUE | PRIMARY KEY } USING INDEX index_name
    [ DEFERRABLE | NOT DEFERRABLE ] [ INITIALLY DEFERRED | INITIALLY IMMEDIATE ]
*)

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken], 0, okTable);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'TABLE', [toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, T, 'ONLY', [], 1);
  FTShemaName:=AddSQLTokens(stIdentificator, [T1, T], '', [], 2);
  T:=AddSQLTokens(stSymbol, FTShemaName, '.', []);
  FTTableName:=AddSQLTokens(stIdentificator, T, '', [], 3);

  T:=AddSQLTokens(stKeyword, [FTTableName, FTShemaName], 'SET', []);
    T1:=AddSQLTokens(stKeyword, T, 'SCHEMA', []);
      T2:=AddSQLTokens(stIdentificator, T1, '', [], 4);

    T1:=AddSQLTokens(stKeyword, T, 'TABLESPACE', []);
      T2:=AddSQLTokens(stKeyword, T1, '', [], 5);

  TR:=AddSQLTokens(stKeyword, [FTTableName, FTShemaName], 'RENAME', []);                  //ALTER TABLE name RENAME TO new_name
    T:=AddSQLTokens(stKeyword, TR, 'TO', []);
    FTTableNameNew:=AddSQLTokens(stIdentificator, T, '', [], 6);

  T7:=AddSQLTokens(stKeyword, TR, 'COLUMN', []);                                          //ALTER TABLE [ ONLY ] name [ * ] RENAME [ COLUMN ] column TO new_column
  T7:=AddSQLTokens(stIdentificator, T7, '', [], 7);
    TR.AddChildToken(T7);
  T:=AddSQLTokens(stKeyword, T7, 'TO', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 8);

(*
  ALTER TABLE [ ONLY ] name [ * ]
      RENAME [ COLUMN ] column TO new_column
}

{    T1:=AddSQLTokens(stKeyword, T, 'WITHOUT CLUSTER                           //SET
    T1:=AddSQLTokens(stKeyword, T, 'WITH OIDS                                 //SET
    T1:=AddSQLTokens(stKeyword, T, 'WITHOUT OIDS                              //SET
    T1:=AddSQLTokens(stKeyword, T, '( storage_parameter = value [, ... ] )    //SET
}


{
  ALTER TABLE [ ONLY ] name [ * ]
      action [, ... ]

      + ALTER TABLE [ ONLY ] name [ * ] RENAME [ COLUMN ] column TO new_column
}

{
Здесь ограничение_столбца:

[ CONSTRAINT имя_ограничения ]
{ NOT NULL |
  NULL |
  CHECK ( выражение ) [ NO INHERIT ] |
  DEFAULT выражение_по_умолчанию |
  UNIQUE параметры_индекса |
  PRIMARY KEY параметры_индекса |
  REFERENCES целевая_таблица [ ( целевой_столбец ) ] [ MATCH FULL | MATCH PARTIAL | MATCH SIMPLE ]
    [ ON DELETE действие ] [ ON UPDATE действие ] }
[ DEFERRABLE | NOT DEFERRABLE ] [ INITIALLY DEFERRED | INITIALLY IMMEDIATE ]
*)

//ADD [ COLUMN ] column data_type [ COLLATE collation ] [ column_constraint [ ... ] ]
  TSymb2:=AddSQLTokens(stSymbol, nil, ',', [toOptional], 11);
  //add
  TAdd:=AddSQLTokens(stKeyword, [FTShemaName, FTTableName], 'ADD', []);
    T:=AddSQLTokens(stKeyword, TAdd, 'COLUMN', []);
      T1:=AddSQLTokens(stKeyword, T, 'IF', []);
      T1:=AddSQLTokens(stKeyword, T1, 'NOT', []);
      T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', [], 22);
    TColName:=AddSQLTokens(stIdentificator, [TAdd,T, T1], '', [], 10);
  MakeTypeDefTree(Self, [TColName], [TSymb2], tdfTableColDef, 100);

(*  30+
ADD ограничение_таблицы [ NOT VALID ]

[ CONSTRAINT имя_ограничения ]
{ CHECK ( выражение ) [ NO INHERIT ] |
  UNIQUE ( имя_столбца [, ... ] ) параметры_индекса |
  PRIMARY KEY ( имя_столбца [, ... ] ) параметры_индекса |
  EXCLUDE [ USING метод_индекса ] ( элемент_исключения WITH оператор [, ... ] ) параметры_индекса [ WHERE ( предикат ) ] |
  FOREIGN KEY ( имя_столбца [, ... ] ) REFERENCES целевая_таблица [ ( целевой_столбец [, ... ] ) ]
    [ MATCH FULL | MATCH PARTIAL | MATCH SIMPLE ] [ ON DELETE действие ] [ ON UPDATE действие ] }
[ DEFERRABLE | NOT DEFERRABLE ] [ INITIALLY DEFERRED | INITIALLY IMMEDIATE ]

*)
    TConst:=AddSQLTokens(stKeyword, TAdd, 'CONSTRAINT', [], 30);
      TConstName:=AddSQLTokens(stIdentificator, TConst, '', [], 31);
    TConstCheck:=AddSQLTokens(stKeyword, [TAdd, TConstName], 'CHECK', [], 32);
      T:=AddSQLTokens(stSymbol, TConstCheck, '(', [], 33);
        T.AddChildToken(TSymb2);
      T:=AddSQLTokens(stKeyword, T, 'NO', [toOptional]);
      T:=AddSQLTokens(stKeyword, T, 'INHERIT', [], 34);
        T.AddChildToken(TSymb2);

    TConstUnique:=AddSQLTokens(stKeyword, [TAdd, TConstName], 'UNIQUE', [], 36);

    TConstPK:=AddSQLTokens(stKeyword, [TAdd, TConstName], 'PRIMARY', [], 38);
    TConstPK:=AddSQLTokens(stKeyword, TConstPK, 'KEY', []);

      T:=AddSQLTokens(stSymbol, [TConstUnique, TConstPK], '(', []);
      T:=AddSQLTokens(stIdentificator, T, '', [], 37);
        TSymb:=AddSQLTokens(stSymbol, T, ',', []);
        TSymb.AddChildToken(T);
      T:=AddSQLTokens(stSymbol, T, ')', []);
        T.AddChildToken(TSymb2);
        //TODO: параметры_индекса

    TConstFK:=AddSQLTokens(stKeyword, [TAdd, TConstName], 'FOREIGN', [], 39);
      TConstFK:=AddSQLTokens(stKeyword, TConstFK, 'KEY', []);
      T:=AddSQLTokens(stSymbol, TConstFK, '(', []);
      T:=AddSQLTokens(stIdentificator, T, '', [], 37);
        TSymb:=AddSQLTokens(stSymbol, T, ',', []);
        TSymb.AddChildToken(T);
      T:=AddSQLTokens(stSymbol, T, ')', []);
      T:=AddSQLTokens(stKeyword, T, 'REFERENCES', []);
      TConstFKTbl:=AddSQLTokens(stIdentificator, T, '', [], 40);
        T1:=AddSQLTokens(stSymbol, TConstFKTbl, '.', [], 40);
        TConstFKTbl1:=AddSQLTokens(stIdentificator, T1, '', [], 40);
        TConstFKTbl.AddChildToken(TSymb2);
        TConstFKTbl1.AddChildToken(TSymb2);
      T:=AddSQLTokens(stSymbol, [TConstFKTbl, TConstFKTbl1], '(', [toOptional]);
      T:=AddSQLTokens(stIdentificator, T, '', [], 41);
        TSymb:=AddSQLTokens(stSymbol, T, ',', []);
        TSymb.AddChildToken(T);
      TConstFKFld:=AddSQLTokens(stSymbol, T, ')', []);
        TConstFKFld.AddChildToken(TSymb2);

      TConstFKMatch:=AddSQLTokens(stKeyword, [TConstFKTbl, TConstFKTbl1, TConstFKFld], 'MATCH', [toOptional]);
        TConstFKMatch1:=AddSQLTokens(stKeyword, TConstFKMatch, 'FULL', [], 42);
        TConstFKMatch2:=AddSQLTokens(stKeyword, TConstFKMatch, 'PARTIAL', [], 43);
        TConstFKMatch3:=AddSQLTokens(stKeyword, TConstFKMatch, 'SIMPLE', [], 44);
          TConstFKMatch1.AddChildToken(TSymb2);
          TConstFKMatch2.AddChildToken(TSymb2);
          TConstFKMatch3.AddChildToken(TSymb2);

      TConstFKOn:=AddSQLTokens(stKeyword, [TConstFKTbl, TConstFKTbl1, TConstFKFld, TConstFKMatch1, TConstFKMatch2, TConstFKMatch3], 'ON', [toOptional]);
        TConstFKOn1:=AddSQLTokens(stKeyword, TConstFKOn, 'DELETE', [], 45);
        TConstFKOn2:=AddSQLTokens(stKeyword, TConstFKOn, 'UPDATE', [], 46);
          TConstFKOn10:=AddSQLTokens(stKeyword, [TConstFKOn1, TConstFKOn2], 'NO', []);
            TConstFKOn10:=AddSQLTokens(stKeyword, TConstFKOn10, 'ACTION', [], 47);
          TConstFKOn11:=AddSQLTokens(stKeyword, [TConstFKOn1, TConstFKOn2], 'RESTRICT', [], 48);
          TConstFKOn12:=AddSQLTokens(stKeyword, [TConstFKOn1, TConstFKOn2], 'CASCADE', [], 49);
          TConstFKOn13:=AddSQLTokens(stKeyword, [TConstFKOn1, TConstFKOn2], 'SET', []);
            TConstFKOn14:=AddSQLTokens(stKeyword, TConstFKOn13, 'NULL', [], 50);
            TConstFKOn13:=AddSQLTokens(stKeyword, TConstFKOn13, 'DEFAULT', [], 51);

      TConstFKOn10.AddChildToken([TConstFKOn, TConstFKMatch, TSymb2]);
      TConstFKOn11.AddChildToken([TConstFKOn, TConstFKMatch, TSymb2]);
      TConstFKOn12.AddChildToken([TConstFKOn, TConstFKMatch, TSymb2]);
      TConstFKOn13.AddChildToken([TConstFKOn, TConstFKMatch, TSymb2]);
      TConstFKOn14.AddChildToken([TConstFKOn, TConstFKMatch, TSymb2]);

(*
параметры_индекса в ограничениях UNIQUE, PRIMARY KEY и EXCLUDE:

[ WITH ( параметр_хранения [= значение] [, ... ] ) ]
[ USING INDEX TABLESPACE табл_пространство ]

*)

//      EXCLUDE [ USING метод_индекса ] ( элемент_исключения WITH оператор [, ... ] ) параметры_индекса [ WHERE ( предикат ) ] |
//      FOREIGN KEY ( имя_столбца [, ... ] ) REFERENCES целевая_таблица [ ( целевой_столбец [, ... ] ) ] [ MATCH FULL | MATCH PARTIAL | MATCH SIMPLE ] [ ON DELETE действие ] [ ON UPDATE действие ] }


  //drop
  TDrop:=AddSQLTokens(stKeyword, [FTShemaName, FTTableName], 'DROP', [], -5);
    T:=AddSQLTokens(stKeyword, TDrop, 'COLUMN', []);
    T1:=AddSQLTokens(stKeyword, [TDrop, T], 'IF', []);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', [], 12);
    TColName1:=AddSQLTokens(stIdentificator, [TDrop, T, T1], '', [], 13);
    T1:=AddSQLTokens(stKeyword, TColName1, 'RESTRICT', [toOptional], 14);
    T2:=AddSQLTokens(stKeyword, TColName1, 'CASCADE', [toOptional], 15);
    TColName1.AddChildToken(TSymb2);
    T1.AddChildToken(TSymb2);
    T2.AddChildToken(TSymb2);
  //drop constraint
    T:=AddSQLTokens(stKeyword, TDrop, 'CONSTRAINT', []);
      T1:=AddSQLTokens(stKeyword, T, 'IF', []);
      T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', [], 12);
      TConstrName1:=AddSQLTokens(stIdentificator, [T, T1], '', [], 16);
      T1:=AddSQLTokens(stKeyword, TConstrName1, 'RESTRICT', [toOptional], 14);
      T2:=AddSQLTokens(stKeyword, TConstrName1, 'CASCADE', [toOptional], 15);
      TConstrName1.AddChildToken(TSymb2);
      T1.AddChildToken(TSymb2);
      T2.AddChildToken(TSymb2);

  TOwnTo:=AddSQLTokens(stKeyword, [FTShemaName, FTTableName], 'OWNER', []);
    TOwnTo1:=AddSQLTokens(stKeyword, TOwnTo, 'TO', []);
    TOwnTo1:=AddSQLTokens(stIdentificator, TOwnTo1, '', [], 17);
    TOwnTo1.AddChildToken(TSymb2);

(*
    ALTER [ COLUMN ] column SET DEFAULT expression
    ALTER [ COLUMN ] column DROP DEFAULT
    ALTER [ COLUMN ] column { SET | DROP } NOT NULL
    ALTER [ COLUMN ] column SET STATISTICS integer
    ALTER [ COLUMN ] column SET ( attribute_option = value [, ... ] )
    ALTER [ COLUMN ] column RESET ( attribute_option [, ... ] )
    ALTER [ COLUMN ] column SET STORAGE { PLAIN | EXTERNAL | EXTENDED | MAIN }
    ADD table_constraint [ NOT VALID ]
    ADD table_constraint_using_index
    VALIDATE CONSTRAINT constraint_name

    ENABLE RULE rewrite_rule_name
    ENABLE REPLICA RULE rewrite_rule_name
    ENABLE REPLICA TRIGGER trigger_name
    ENABLE ALWAYS TRIGGER trigger_name
    ENABLE ALWAYS RULE rewrite_rule_name

    DISABLE RULE rewrite_rule_name
    CLUSTER ON index_name

    RESET ( storage_parameter [, ... ] )
    INHERIT parent_table
    NO INHERIT parent_table
    OF type_name
    NOT OF
    OWNER TO new_owner
*)
  TEnableT:=AddSQLTokens(stKeyword, [FTShemaName, FTTableName], 'ENABLE', [], 18);
  TDisableT:=AddSQLTokens(stKeyword, [FTShemaName, FTTableName], 'DISABLE', [], 19);
    TTrig:=AddSQLTokens(stKeyword, [TEnableT, TDisableT], 'TRIGGER', []);
    TTrigName:=AddSQLTokens(stIdentificator, TTrig, '', [], 20);
    TTrigNameAll:=AddSQLTokens(stKeyword, TTrig, 'ALL', [], 20);
    TTrigNameUser:=AddSQLTokens(stKeyword, TTrig, 'USER', [], 20);


  TAltCol:=AddSQLTokens(stKeyword, [FTShemaName, FTTableName], 'ALTER', []);  //  ALTER [ COLUMN ] column [ SET DATA ] TYPE data_type [ COLLATE collation ] [ USING expression ]
    TAltCol1:=AddSQLTokens(stKeyword, TAltCol, 'COLUMN', []);
    TColName2:=AddSQLTokens(stIdentificator, [TAltCol, TAltCol1], '', [], 21);
      T:=AddSQLTokens(stKeyword, TColName2, 'SET', []);
      T:=AddSQLTokens(stKeyword, T, 'DATA', []);
    T:=AddSQLTokens(stKeyword, [TColName2, T], 'TYPE', []);
  MakeTypeDefTree(Self, [T], [TSymb2], tdfTableColDef, 100);



(*
  DISABLE TRIGGER [ trigger_name | ALL | USER ]
  ENABLE TRIGGER [ trigger_name | ALL | USER ]
*)
  TSymb2.AddChildToken([TAdd, TDrop, TOwnTo, T1, TDisableT, TAltCol]);
end;

procedure TPGSQLAlterTable.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    -5:;
    1:FOnly:=true;
    2:Name:=AWord;
    3:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
    4:FCurOperator:=FOperators.AddItem(ataSetSchema, AWord);
    5:FCurOperator:=FOperators.AddItem(ataSetTablespace, AWord);
    6:FCurOperator:=FOperators.AddItem(ataRenameTable, AWord);
    7:begin
        FCurOperator:=FOperators.AddItem(ataRenameColumn, AWord);
        FCurOperator.OldField.Caption:=AWord;
      end;
    8:if Assigned(FCurOperator) then FCurOperator.Field.Caption:=AWord;
    10:begin
         if not Assigned(FCurOperator) then
           FCurOperator:=FOperators.AddItem(ataAddColumn)
         else
           FCurOperator.AlterAction:=ataAddColumn;
         FCurOperator.Field.Caption:=AWord;
       end;
    11:begin
         FCurOperator:=nil;
         FCurConstr:=nil;
         FUpDel:=0;
       end;
    12:begin
         if not Assigned(FCurOperator) then
           FCurOperator:=FOperators.AddItem(ataNone);
         FCurOperator.Options:=FCurOperator.Options + [ooIfExists];
       end;
    13:begin
         if not Assigned(FCurOperator) then
           FCurOperator:=FOperators.AddItem(ataDropColumn)
         else
           FCurOperator.AlterAction:=ataDropColumn;
         FCurOperator.Field.Caption:=AWord;
       end;
    16:begin
         if not Assigned(FCurOperator) then
         begin
           FCurOperator:=FOperators.AddItem(ataDropConstraint, AWord);
           FCurOperator.Constraints.Add(ctNone, AWord);
         end
         else
         begin
           FCurOperator.AlterAction:=ataDropConstraint;
           FCurOperator.Name:=AWord;
           FCurOperator.Constraints.Add(ctNone, AWord);
         end;
       end;
    14:if Assigned(FCurOperator) then FCurOperator.DropRule:=drRestrict;
    15:if Assigned(FCurOperator) then FCurOperator.DropRule:=drCascade;
    17:FCurOperator:=FOperators.AddItem(ataOwnerTo, AWord);
    18:FEnableState:=ttsEnabled;
    19:FEnableState:=ttsDisable;
    20:begin
         if FEnableState = ttsEnabled then
           FCurOperator:=FOperators.AddItem(ataEnableTrigger, AWord)
         else
         if FEnableState = ttsDisable then
           FCurOperator:=FOperators.AddItem(ataDisableTrigger, AWord)
       end;
    21:begin
         FCurOperator:=FOperators.AddItem(ataAlterColumnSetDataType);
         FCurOperator.Field.Caption:=AWord;
       end;
    22:begin
         if not Assigned(FCurOperator) then
           FCurOperator:=FOperators.AddItem(ataNone);
         FCurOperator.Options:=FCurOperator.Options + [ooIfNotExists];
       end;
    102:if Assigned(FCurOperator) then FCurOperator.Field.TypeName:=AWord;
    103:if Assigned(FCurOperator) then
          FCurOperator.Field.TypeName:=FCurOperator.Field.TypeName + ' ' + AWord;
    104:if Assigned(FCurOperator) then
          FCurOperator.Field.TypeLen:=StrToInt(AWord);
    126:if Assigned(FCurOperator) then
          FCurOperator.Field.TypeName:=FCurOperator.Field.TypeName + AWord;
    127:if Assigned(FCurOperator) then
          FCurOperator.Field.DefaultValue:=GetToNextToken(ASQLParser, AChild);
    30:begin
         FCurOperator:=FOperators.AddItem(ataAddTableConstraint);
         FCurConstr:=FCurOperator.Constraints.Add(ctNone);
       end;
    31:if Assigned(FCurConstr) then
        FCurConstr.ConstraintName:=AWord;
    32:begin
         if not Assigned(FCurConstr) then
         begin
           FCurOperator:=FOperators.AddItem(ataAddTableConstraint);
           FCurConstr:=FCurOperator.Constraints.Add(ctTableCheck);
         end
         else
           FCurConstr.ConstraintType:=ctTableCheck;
       end;
    33:if Assigned(FCurConstr) then
        FCurConstr.ConstraintExpression:=ASQLParser.GetToBracket(')');
    34:if Assigned(FCurConstr) then
        FCurConstr.NoInherit:=true;
    36:begin
         if not Assigned(FCurConstr) then
         begin
           FCurOperator:=FOperators.AddItem(ataAddTableConstraint);
           FCurConstr:=FCurOperator.Constraints.Add(ctUnique);
         end
         else
           FCurConstr.ConstraintType:=ctUnique;
       end;
    38:begin
         if not Assigned(FCurConstr) then
         begin
           FCurOperator:=FOperators.AddItem(ataAddTableConstraint);
           FCurConstr:=FCurOperator.Constraints.Add(ctPrimaryKey);
         end
         else
           FCurConstr.ConstraintType:=ctPrimaryKey;
       end;
    37:if Assigned(FCurConstr) then
        FCurConstr.ConstraintFields.AddParam(AWord);
    39:begin
         if not Assigned(FCurConstr) then
         begin
           FCurOperator:=FOperators.AddItem(ataAddTableConstraint);
           FCurConstr:=FCurOperator.Constraints.Add(ctForeignKey);
         end
         else
           FCurConstr.ConstraintType:=ctForeignKey;
       end;
    40:if Assigned(FCurConstr) then
        FCurConstr.ForeignTable:=FCurConstr.ForeignTable + AWord;
    41:if Assigned(FCurConstr) then
        FCurConstr.ForeignFields.AddParam(AWord);
    42:if Assigned(FCurConstr) then FCurConstr.Match:=maFull;
    43:if Assigned(FCurConstr) then FCurConstr.Match:=maPartial;
    44:if Assigned(FCurConstr) then FCurConstr.Match:=maSimple;

    45:FUpDel:=2;
    46:FUpDel:=1;
    47:if Assigned(FCurConstr) then
         if FUpDel = 1 then FCurConstr.ForeignKeyRuleOnUpdate:=fkrNone
         else FCurConstr.ForeignKeyRuleOnDelete:=fkrNone;
    48:if Assigned(FCurConstr) then
         if FUpDel = 1 then FCurConstr.ForeignKeyRuleOnUpdate:=fkrRestrict
         else FCurConstr.ForeignKeyRuleOnDelete:=fkrRestrict;
    49:if Assigned(FCurConstr) then
         if FUpDel = 1 then FCurConstr.ForeignKeyRuleOnUpdate:=fkrCascade
         else FCurConstr.ForeignKeyRuleOnDelete:=fkrCascade;
    50:if Assigned(FCurConstr) then
         if FUpDel = 1 then FCurConstr.ForeignKeyRuleOnUpdate:=fkrSetNull
         else FCurConstr.ForeignKeyRuleOnDelete:=fkrSetNull;
    51:if Assigned(FCurConstr) then
         if FUpDel = 1 then FCurConstr.ForeignKeyRuleOnUpdate:=fkrSetDefault
         else FCurConstr.ForeignKeyRuleOnDelete:=fkrSetDefault;
  end;
end;

procedure TPGSQLAlterTable.MakeSQL;

procedure DoAddConstrint(OP: TAlterTableOperator);
var
  S: String;
  C: TSQLConstraintItem;
begin
  S:='';
  for C in OP.Constraints do
  begin
    S:='ALTER TABLE ' + FullName + ' ADD';
    if C.ConstraintName <> '' then S:=S + ' CONSTRAINT ' + C.ConstraintName;

    if C.ConstraintType = ctPrimaryKey then
      S:=S + ' PRIMARY KEY ('+C.ConstraintFields.AsString + ')'
    else
    if C.ConstraintType = ctForeignKey then
    begin
      S:=S + ' FOREIGN KEY ('+C.ConstraintFields.AsString + ') REFERENCES '+C.ForeignTable +'(' +C.ForeignFields.AsString + ')';

      if C.Match = maFull then S:=S + ' MATCH FULL'
      else
      if C.Match = maPartial then S:=S + ' MATCH PARTIAL'
      else
      if C.Match = maSimple then S:=S + ' MATCH SIMPLE';

      if C.ForeignKeyRuleOnUpdate<>fkrNone then S:=S+' ON UPDATE '+ForeignKeyRuleNames[C.ForeignKeyRuleOnUpdate];
      if C.ForeignKeyRuleOnDelete<>fkrNone then S:=S+' ON DELETE '+ForeignKeyRuleNames[C.ForeignKeyRuleOnDelete];
    end
    else
    if C.ConstraintType = ctUnique then
      S:=S + ' UNIQUE('+C.ConstraintFields.AsString+')'
    else
    if C.ConstraintType = ctTableCheck then
    begin
      S:=S + ' CHECK ('+C.ConstraintExpression+')';
      if C.NoInherit then
        S:=S + ' NO INHERIT';
    end;

    if S<>'' then
      AddSQLCommand(S);

    if C.IndexName <> '' then
      AddSQLCommandEx('CREATE INDEX %s ON %s (%s)', [C.IndexName, FullName, C.ConstraintFields.AsString]);

    if C.Description <> '' then
      DescribeObjectEx(okCheckConstraint, C.ConstraintName, FullName, C.Description);
  end;
end;

procedure DoDropCollumn(OP: TAlterTableOperator);
var
  S: String;
begin
  S:='ALTER TABLE '+FullName + ' DROP COLUMN ';
  if ooIfExists in OP.Options then
    S:=S + 'IF EXISTS ';
  S:=S + OP.Field.Caption;
  if OP.DropRule = drCascade then S:=S + ' CASCADE'
  else
  if OP.DropRule = drRestrict then S:=S + ' RESTRICT';
  AddSQLCommand(S);
end;

procedure DoDropConstraint(OP: TAlterTableOperator);
var
  S, S1: String;
  C: TSQLConstraintItem;
begin
  S:='ALTER TABLE '+FullName + ' DROP CONSTRAINT ';
  if ooIfExists in OP.Options then
    S:=S + 'IF EXISTS ';

  S1:='';
  for C in OP.Constraints do
  begin
    if S1<>'' then S1:=S1+', ';
    S1:=S1 + C.ConstraintName;
  end;

  S:=S + S1;

  if OP.DropRule = drCascade then S:=S + ' CASCADE'
  else
  if OP.DropRule = drRestrict then S:=S + ' RESTRICT';
  AddSQLCommand(S);
end;

var
  OP: TAlterTableOperator;
begin
  for OP in FOperators do
  begin
    case OP.AlterAction of
      ataAddColumn : AddCollumn(OP);
      ataRenameColumn : AddSQLCommandEx('ALTER TABLE %s RENAME COLUMN %s TO %s', [FullName, OP.OldField.Caption, OP.Field.Caption]);
      ataAlterColumnSetDataType : AddSQLCommandEx('ALTER TABLE %s ALTER COLUMN %s SET DATA TYPE %s', [FullName, OP.Field.Caption, OP.Field.FullTypeName]);
      ataAlterColumnDropDefault : AddSQLCommandEx('ALTER TABLE %s ALTER COLUMN %s DROP DEFAULT', [FullName, OP.Field.Caption]);
      ataAlterColumnSetDefaultExp : AddSQLCommandEx('ALTER TABLE %s ALTER COLUMN %s SET DEFAULT %s', [FullName, OP.Field.Caption, OP.Field.DefaultValue]);
      ataAlterColumnSetNotNull,
      ataAlterColumnDropNotNull:AddSQLCommandEx('ALTER TABLE %s ALTER COLUMN %s %s NOT NULL', [ FullName, OP.Field.Caption, IfThen(OP.AlterAction = ataAlterColumnSetNotNull, 'SET', 'DROP')]);
      ataAlterColumnDescription : DescribeObjectEx(okColumn, OP.Field.Caption, FullName, OP.Field.Description);
      ataAddTableConstraint:DoAddConstrint(OP);
      ataDropColumn:DoDropCollumn(OP);
      ataDropConstraint:DoDropConstraint(OP);
      ataEnableTrigger:AddSQLCommandEx('ALTER TABLE %s ENABLE TRIGGER %s', [FullName, OP.ParamValue]);
      ataDisableTrigger:AddSQLCommandEx('ALTER TABLE %s DISABLE TRIGGER %s', [FullName, OP.ParamValue]);
      ataOwnerTo:AddSQLCommandEx('ALTER TABLE %s OWNER TO %s', [FullName, OP.ParamValue]);
      ataRenameTable:AddSQLCommandEx('ALTER TABLE %s RENAME TO %s', [FullName, OP.ParamValue]);
    else
      raise Exception.CreateFmt('Unknow operator "%s"', [AlterTableActionStr[OP.AlterAction]]);
    end;
  end;
{  case FAlterAction of
    ataSetTablespace:Result := Result + ' SET TABLESPACE ' + FSchemaNameNew;
    ataSetSchema:Result := Result + ' SET SCHEMA ' + FSchemaNameNew;
    ataRenameColumn:Result := Result + ' RENAME COLUMN '+FColumnNameOld+' TO ' + FColumnNameNew;
  end;}
end;

constructor TPGSQLAlterTable.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSQLCommentOnClass:=TPGSQLCommentOn;
end;

procedure TPGSQLAlterTable.Assign(ASource: TSQLObjectAbstract);
begin
  inherited Assign(ASource);
  if ASource is TPGSQLAlterTable then
  begin
    FOnly:=TPGSQLAlterTable(ASource).FOnly;
  end;
end;

{ TPGSQLAlterTrigger }

procedure TPGSQLAlterTrigger.InitParserTree;
var
  T, T1, FSQLTokens, TSchema, TName, TRen, TDeps: TSQLTokenRecord;
begin
  (* ALTER TRIGGER name ON table RENAME TO new_name *)
  (* ALTER TRIGGER имя ON имя_таблицы DEPENDS ON EXTENSION имя_расширения *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken], 0, okTrigger);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'TRIGGER', [toFindWordLast]);                   //TRIGGER
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);                      //name

  T:=AddSQLTokens(stKeyword, T, 'ON', []);                            //ON

  TSchema:=AddSQLTokens(stIdentificator, T, '', [], 2);
    T1:=AddSQLTokens(stSymbol, TSchema, '.', []);
  TName:=AddSQLTokens(stIdentificator, T1, '', [], 3);                 //table name

  TRen:=AddSQLTokens(stKeyword, [TSchema, TName], 'RENAME', []);      //RENAME

  T:=AddSQLTokens(stKeyword, TRen, 'TO', []);                         //TO

  T:=AddSQLTokens(stIdentificator, T, '', [], 4);                      //new_name

  TDeps:=AddSQLTokens(stKeyword, [TSchema, TName], 'DEPENDS', []);    //DEPENDS
  TDeps:=AddSQLTokens(stKeyword, TDeps, 'ON', []);                    //ON
  TDeps:=AddSQLTokens(stKeyword, TDeps, 'EXTENSION', []);             //EXTENSION
  T:=AddSQLTokens(stIdentificator, TDeps, '', [], 5);                  //имя_расширения

end;

procedure TPGSQLAlterTrigger.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    2:TableName:=AWord;
    3:begin
        SchemaName:=TableName;
        TableName:=AWord;
      end;
    4:TriggerNewName:=AWord;
    5:DependsName:=AWord;
  end;
end;

procedure TPGSQLAlterTrigger.MakeSQL;
var
  s: String;
begin
  s:='ALTER TRIGGER '+Name+' ON ';
  if SchemaName<>'' then
    S:=S + SchemaName +'.';
  S:=S + TableName;
  if TriggerNewName <> '' then
    S:=S + ' RENAME TO '+TriggerNewName
  else
  if DependsName <> '' then
    S:=S + ' DEPENDS ON EXTENSION ' + DependsName;
  AddSQLCommand(S);
end;

constructor TPGSQLAlterTrigger.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okTrigger;
  FSQLCommentOnClass:=TPGSQLCommentOn;
end;

procedure TPGSQLAlterTrigger.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLAlterTrigger then
  begin
    TriggerNewName:=TPGSQLAlterTrigger(ASource).TriggerNewName;
    DependsName:=TPGSQLAlterTrigger(ASource).DependsName;
  end;
  inherited Assign(ASource);
end;


{ TPGSQLCreateRule }

procedure TPGSQLCreateRule.ParseWhere(SQLParser: TSQLParser);
var
  S:string;
  i:integer;
begin
  FSQLRuleWhere:=SQLParser.GetToWord('DO');
  S:=Copy(SQLParser.SQL, SQLParser.Position.Position, Length(SQLParser.SQL));
  i:=Pos('DO', UpperCase(S))-1;
  if i>0 then
  begin
    { TODO : Необходим нормальный парсер выражений }
(*
    FSQLRuleWhere:=Trim(Copy(S, 1, i));
    SQLParser.CurPos:=SQLParser.CurPos + i;
    if (FSQLRuleWhere<>'') and (FSQLRuleWhere[1]='(') and (FSQLRuleWhere[Length(FSQLRuleWhere)]=')') then
      FSQLRuleWhere:=Copy(FSQLRuleWhere, 2, Length(FSQLRuleWhere)-2);
*)
  end;
end;

constructor TPGSQLCreateRule.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSQLCommentOnClass:=TPGSQLCommentOn;
  ObjectKind:=okRule;
end;

procedure TPGSQLCreateRule.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLCreateRule then
  begin
    OrReplase:=TPGSQLCreateRule(ASource).OrReplase;
    RelationName:=TPGSQLCreateRule(ASource).RelationName;
    RuleSQL:=TPGSQLCreateRule(ASource).RuleSQL;
    SQLRuleWhere:=TPGSQLCreateRule(ASource).SQLRuleWhere;
    //SQLCommandRulle:TSQLCommandAbstract read FSQLCommandRulle;
    RuleAction:=TPGSQLCreateRule(ASource).RuleAction;
    RuleNothing:=TPGSQLCreateRule(ASource).RuleNothing;
    RuleWork:=TPGSQLCreateRule(ASource).RuleWork;
  end;
  inherited Assign(ASource);
end;

procedure TPGSQLCreateRule.InitParserTree;
var
  T, T1, FSQLTokens, T2, T3, T20, T21, T22, T23, T24, T25, T26: TSQLTokenRecord;
begin
(*
  CREATE [ OR REPLACE ] RULE имя AS ON событие
      TO имя_таблицы [ WHERE условие ]
      DO [ ALSO | INSTEAD ] { NOTHING | команда | ( команда ; команда ... ) }

  Здесь допускается событие:
      SELECT | INSERT | UPDATE | DELETE
*)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken]);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'OR', []);            //OR
    T1:=AddSQLTokens(stKeyword, T1, 'REPLACE', [], 1);             //REPLACE
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'RULE', [toFindWordLast]);          //RULE
    T1.AddChildToken(T);
  T:=AddSQLTokens(stIdentificator, T, '', [], 2);         //rule name
  T:=AddSQLTokens(stKeyword, T, 'AS', []);          //AS
  T:=AddSQLTokens(stKeyword, T, 'ON', []);                  //ON

  T:=AddSQLTokens(stKeyword, T, 'SELECT', [], 3);           //event name
  T1:=AddSQLTokens(stKeyword, T, 'INSERT', [], 4);           //event name
  T2:=AddSQLTokens(stKeyword, T, 'UPDATE', [], 5);           //event name
  T3:=AddSQLTokens(stKeyword, T, 'DELETE', [], 6);           //event name

  T:=AddSQLTokens(stKeyword, T, 'TO', []);            //TO
    T1.AddChildToken(T);
    T2.AddChildToken(T);
    T3.AddChildToken(T);

  T:=AddSQLTokens(stIdentificator, T, '', [], 7);          //table or schema name
    T1:=AddSQLTokens(stSymbol, T, '.', []);              //  .
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 8);        //table_name

  T2:=AddSQLTokens(stKeyword, T, 'WHERE', [], 9);        //WHERE
    T1.AddChildToken(T2);

  T:=AddSQLTokens(stKeyword, T, 'DO', []);             //DO
    T1.AddChildToken(T);
    T2.AddChildToken(T);

  T1:=AddSQLTokens(stKeyword, T, 'ALSO', [], 10);                 //ALSODO
  T2:=AddSQLTokens(stKeyword, T, 'INSTEAD', [], 11);           //INSTEAD

  T20:=AddSQLTokens(stKeyword, T, 'NOTHING', [], 20);           //NOTHING
  T21:=AddSQLTokens(stKeyword, T, 'SELECT', [], 21);
  T22:=AddSQLTokens(stKeyword, T, 'INSERT', [], 22);
  T23:=AddSQLTokens(stKeyword, T, 'UPDATE', [], 23);
  T24:=AddSQLTokens(stKeyword, T, 'DELETE', [], 24);
  T25:=AddSQLTokens(stKeyword, T, 'NOTIFY', [], 25);
  T26:=AddSQLTokens(stKeyword, T, '(', [], 26);
    T1.AddChildToken([T20, T21, T22, T23, T24, T25, T26]);
    T2.AddChildToken([T20, T21, T22, T23, T24, T25, T26]);
end;

procedure TPGSQLCreateRule.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:FOrReplase:=true;
    2:Name:=AWord;
    3:FRuleAction:=raSelect;
    4:FRuleAction:=raInsert;
    5:FRuleAction:=raUpdate;
    6:FRuleAction:=raDelete;
    7:FRelationName:=AWord;
    8:begin
        SchemaName:=FRelationName;
        FRelationName:=AWord;
      end;
    9:FSQLRuleWhere:=ASQLParser.GetToWord('DO'); //ParseWhere(ASQLParser);
    10:FRuleWork:=rwALSO;
    11:FRuleWork:=rwINSTEAD;
    20:FRuleNothing:=true;
    21..24:FRuleSQL:=ASQLParser.GetToCommandDelemiter;
    25:FRuleSQL:=AWord;
    26:FRuleSQL:='(' + ASQLParser.GetToBracket(')') + ')';
  end;
end;

procedure TPGSQLCreateRule.MakeSQL;
var
  S: String;
begin
  (*
    CREATE [ OR REPLACE ] RULE имя AS ON событие
        TO имя_таблицы [ WHERE условие ]
        DO [ ALSO | INSTEAD ] { NOTHING | команда | ( команда ; команда ... ) }

    Здесь допускается событие:
        SELECT | INSERT | UPDATE | DELETE
  *)
  S:='CREATE';
  if FOrReplase then
    S:=S + ' OR REPLACE';
  S:=S +' RULE ' + Name + ' AS ON ' + RuleActionStr[FRuleAction] + LineEnding;

  AddSQLCommand(S);
end;


{ TPGSQLCreateTrigger }

procedure TPGSQLCreateTrigger.ParseWhen(SQLParser: TSQLParser);
begin
{  S:=Copy(SQLParser.SQL, SQLParser.CurPos, Length(SQLParser.SQL));
  i:=Pos('EXECUTE', UpperCase(S))-1;
  if i>0 then
  begin
    { TODO : Необходим нормальный парсер выражений }
    FTriggerWhen:=Trim(Copy(S, 1, i));
    SQLParser.CurPos:=SQLParser.CurPos + i;
    if (FTriggerWhen<>'') and (FTriggerWhen[1]='(') and (FTriggerWhen[Length(FTriggerWhen)]=')') then
      FTriggerWhen:=Copy(FTriggerWhen, 2, Length(FTriggerWhen)-2);
  end;}
  FTriggerWhen:=SQLParser.GetToBracket(')');
end;

procedure TPGSQLCreateTrigger.InitParserTree;
var
  T, T1, T2, T4, T5, T6, T7, T4_1, T5_1, T6_1, TT, TS, TN, T15,
    T11, T12, T13, T14, FSQLTokens, T_OF, T7_1, T3: TSQLTokenRecord;
begin
  (*

  CREATE [ CONSTRAINT ] TRIGGER имя { BEFORE | AFTER | INSTEAD OF } { событие [ OR ... ] }
      ON имя_таблицы
      [ FROM ссылающаяся_таблица ]
      [ NOT DEFERRABLE | [ DEFERRABLE ] [ INITIALLY IMMEDIATE | INITIALLY DEFERRED ] ]
      [ FOR [ EACH ] { ROW | STATEMENT } ]
      [ WHEN ( условие ) ]
      EXECUTE PROCEDURE имя_функции ( аргументы )

  Здесь допускается событие:

      INSERT
      UPDATE [ OF имя_столбца [, ... ] ]
      DELETE
      TRUNCATE
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okTrigger);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'TRIGGER', [toFindWordLast]);
    T:=AddSQLTokens(stIdentificator, T, '', [], 1);

    T1:=AddSQLTokens(stKeyword, T, 'BEFORE', [], 2);
    T2:=AddSQLTokens(stKeyword, T, 'AFTER', [], 3);
    T3:=AddSQLTokens(stKeyword, T, 'INSTEAD', []);
    T3:=AddSQLTokens(stKeyword, T3, 'OF', [], 31);


    T4:=AddSQLTokens(stKeyword, [T1, T2, T3], 'INSERT', [], 4);
      T4_1:=AddSQLTokens(stKeyword, T4, 'OR', []);
    T5:=AddSQLTokens(stKeyword, [T1, T2, T3, T4_1], 'UPDATE', [], 5);
      T5_1:=AddSQLTokens(stKeyword, T5, 'OR', []);
    T6:=AddSQLTokens(stKeyword, [T1, T2, T3, T4_1, T5_1], 'DELETE', [], 6);
      T6_1:=AddSQLTokens(stKeyword, T6, 'OR', []);
    T7:=AddSQLTokens(stKeyword, [T1, T2, T3, T4_1, T5_1, T6_1], 'TRUNCATE', [], 7);
      T7_1:=AddSQLTokens(stKeyword, T7, 'OR', []);
      T5_1.AddChildToken(T4);
      T6_1.AddChildToken([T4, T5]);
      T7_1.AddChildToken([T4, T5, T6]);


    T:=AddSQLTokens(stKeyword, T5, 'OF', []);
      T_OF:=AddSQLTokens(stIdentificator, T, '', [], 8);       //update field name
      TT:=AddSQLTokens(stSymbol, T_OF, ',', []);
      TT.AddChildToken(T_OF);
    T_OF.AddChildToken(T5_1);


    T:=AddSQLTokens(stKeyword, [T4, T5, T6, T7, T_OF], 'ON', []);


    TS:=AddSQLTokens(stIdentificator, T, '', [], 9);          //table or schema name
      TT:=AddSQLTokens(stSymbol, TS, '.', []);
      TN:=AddSQLTokens(stIdentificator, TT, '', [], 10);        //table

    T:=AddSQLTokens(stKeyword, [TS, TN], 'FOR', []);
      TT:=AddSQLTokens(stKeyword, T, 'EACH', []);

    T11:=AddSQLTokens(stKeyword, [T, TT], 'ROW', [], 11);
    T12:=AddSQLTokens(stKeyword, [T, TT], 'STATEMENT', [], 12);

    T13:=AddSQLTokens(stKeyword, [T11, T12, TS, TN] , 'WHEN', []);
    T13:=AddSQLTokens(stSymbol, T13 , '(', [], 13);

    T:=AddSQLTokens(stKeyword, [TN, TS, T11, T12, T13], 'EXECUTE', []);          //EXECUTE

    T:=AddSQLTokens(stKeyword, T, 'PROCEDURE', []);

    T14:=AddSQLTokens(stIdentificator, T, '', [], 14);
      T:=AddSQLTokens(stSymbol, T14, '.', []);
    T15:=AddSQLTokens(stIdentificator, T, '', [], 15);
    T:=AddSQLTokens(stSymbol, [T14, T15], '(', []);
    T:=AddSQLTokens(stSymbol, T, ')', []);

{
++EXECUTE PROCEDURE function_name ( arguments )
}
end;

procedure TPGSQLCreateTrigger.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    2:FTriggerType:=FTriggerType + [ttBefore];
    3:FTriggerType:=FTriggerType + [ttAfter];
    4:FTriggerType:=FTriggerType + [ttInsert];
    5:FTriggerType:=FTriggerType + [ttUpdate];
    6:FTriggerType:=FTriggerType + [ttDelete];
    7:FTriggerType:=FTriggerType + [ttTruncate];
    31:FTriggerType:=FTriggerType + [ttInsteadOf];
    8:Params.AddParam(AWord);
    9:TableName:=AWord;
    10:begin
         SchemaName:=TableName;
         TableName:=AWord;
       end;
    11:FTriggerType:=FTriggerType + [ttRow];
    12:FTriggerType:=FTriggerType + [ttStatement];
    13:ParseWhen(ASQLParser);
    14:FProcName:=AWord;
    15:begin
         FProcSchema:=FProcName;
         FProcName:=AWord;
       end;
  end;
end;

procedure TPGSQLCreateTrigger.MakeSQL;
var
  S, S1, FT: String;
  FCmdDrop: TPGSQLDropTrigger;
begin
  if SchemaName<>'' then
    FT:=SchemaName +'.' + TableName
  else
    FT:=TableName;

  if Assigned(TriggerFunction) then
    for S in TriggerFunction.SQLText do
      AddSQLCommand(S);

  if TriggerType <> [] then
  begin
    if CreateMode = cmCreateOrAlter then
    begin
      FCmdDrop:=TPGSQLDropTrigger.Create(nil);
      FCmdDrop.Name:=Name;
      FCmdDrop.TableName:=TableName;
      FCmdDrop.SchemaName:=SchemaName;
      AddSQLCommand(FCmdDrop.AsSQL);
      FCmdDrop.Free;
    end;

    S:='CREATE TRIGGER ' + Name;

    if ttBefore in FTriggerType then
      S:=S + ' BEFORE'
    else
    if ttAfter in FTriggerType then
      S:=S + ' AFTER'
    else
    if ttInsteadOf in FTriggerType then
      S:=S + ' INSTEAD OF';

    S1:='';
    if ttInsert in FTriggerType then S1:=S1 + ' INSERT';

    if ttUpdate in FTriggerType then
    begin
      if S1<>'' then S1:=S1 + ' OR';
      S1:=S1 + ' UPDATE';
      if Params.Count>0 then
        S1:=S1 + ' OF ' + Params.AsString;
    end;

    if ttDelete in FTriggerType then
    begin
      if S1<>'' then S1:=S1 + ' OR';
      S1:=S1 + ' DELETE';
    end;

    if ttTruncate in FTriggerType then
    begin
      if S1<>'' then S1:=S1 + ' OR';
      S1:=S1 + ' TRUNCATE';
    end;

    if S<>'' then
      S:=S + S1;

    S:=S + ' ON '+FT;

    S:=S + ' FOR EACH';
    if ttRow in FTriggerType then
      S:=S + ' ROW'
    else
    if ttStatement in FTriggerType then
      S:=S + ' STATEMENT';

    if FTriggerWhen<>'' then
      S:=S +LineEnding + '  WHEN (' + FTriggerWhen + ')';

    S:=S + LineEnding + '  EXECUTE PROCEDURE ';

    if FProcSchema<>'' then
      S:=S + FProcSchema +'.';
    S:=S + FProcName + '(' + ')';
    AddSQLCommand(S);
  end;

  if FTriggerState <> ttsUnknow then
  begin
    S:='ALTER TABLE ' + FT;
    if FTriggerState = ttsEnabled then
      S:=S + ' ENABLE'
    else
      S:=S + ' DISABLE';
    S:=S + ' TRIGGER ' + Name;
    AddSQLCommand(S);
  end;

  if Description <> '' then
    DescribeObjectEx(ObjectKind, Name, FT, Description);
end;

constructor TPGSQLCreateTrigger.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okTrigger;
  FSQLCommentOnClass:=TPGSQLCommentOn;
end;

destructor TPGSQLCreateTrigger.Destroy;
begin
  if Assigned(FTriggerFunction) then
    FreeAndNil(FTriggerFunction);
  inherited Destroy;
end;

procedure TPGSQLCreateTrigger.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLCreateTrigger then
  begin
    TriggerWhen:=TPGSQLCreateTrigger(ASource).TriggerWhen;
    TriggerType:=TPGSQLCreateTrigger(ASource).TriggerType;
    ProcName:=TPGSQLCreateTrigger(ASource).ProcName;
    ProcSchema:=TPGSQLCreateTrigger(ASource).ProcSchema;
    TriggerState:=TPGSQLCreateTrigger(ASource).TriggerState;
    TriggerFunction.Assign(TPGSQLCreateTrigger(ASource).FTriggerFunction);
  end;
  inherited Assign(ASource);
end;


{ TODO : Необходимо реализовать разбор блока DO }
{ TPGSQL_DO }

procedure TPGSQL_DO.DoParseDeclare(ASQLParser: TSQLParser);
var
  PD: TPGSQLDeclareLocalVarInt;
  i: Integer;
begin
  PD:=TPGSQLDeclareLocalVarInt.Create;
  PD.ParseString(Copy(ASQLParser.SQL, ASQLParser.Position.Position, Length(ASQLParser.SQL)));
  for i:=0 to PD.Params.Count-1 do
    Params.AddParam(PD.Params[i]);
  PD.Free;
end;

procedure TPGSQL_DO.InitParserTree;
var
  FSQLTokens, FTLangName: TSQLTokenRecord;
begin
(*
DO [ LANGUAGE lang_name ] code

DO $$DECLARE r record;
BEGIN
    FOR r IN SELECT table_schema, table_name FROM information_schema.tables
             WHERE table_type = 'VIEW' AND table_schema = 'public'
    LOOP
        EXECUTE 'GRANT ALL ON ' || quote_ident(r.table_schema) || '.' || quote_ident(r.table_name) || ' TO webuser';
    END LOOP;
END$$;
*)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DO', [toFirstToken, toFindWordLast]);
    FTLangName:=AddSQLTokens(stKeyword, FSQLTokens, 'LANGUAGE', []);         //LANGUAGE
    FTLangName:=AddSQLTokens(stIdentificator, FTLangName, '', [], 1);            //lang_name

  AddSQLTokens(stString, [FSQLTokens, FTLangName], '', [], 2);            //code
end;

procedure TPGSQL_DO.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FLanguage:=AWord;
    2:FBody:=ExtractQuotedString(AWord, '''');
  end;
end;

procedure TPGSQL_DO.MakeSQL;
var
  S: String;
begin
  S:='DO';
  if FLanguage <> '' then
    S:=S + ' LANGUAGE ' + FLanguage;
  S:=S + LineEnding + '$$'+ FBody + '$$';
  AddSQLCommand(S);
end;

procedure TPGSQL_DO.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQL_DO then
  begin
    Language:=TPGSQL_DO(ASource).Language;
    Body:=TPGSQL_DO(ASource).Body;
  end;
  inherited Assign(ASource);
end;


{ TPGSQLCreateFunction }

function TPGSQLCreateFunction.GetOutput: TSQLFields;
begin
  Result:=FOutput;
end;

function TPGSQLCreateFunction.GetFunctionName: string;
var
  S1: String;
  P: TSQLParserField;
begin
  Result:= FullName + '(';

  S1:='';
  for P in Params do
  begin
    if S1<> '' then S1:=S1 + ',' + LineEnding;
    if P.InReturn = spvtInput then
      S1:=S1 + ' IN'
    else
    if P.InReturn = spvtOutput then
      S1:=S1 + ' OUT'
    else
    if P.InReturn = spvtInOut then
      S1:=S1 + ' INOUT';

    if P.Caption <> P.TypeName then
      S1:=S1 + ' ' + P.Caption;

    S1:=S1 + ' ' + P.TypeName;
  end;

  if S1<>'' then
    Result:=Result + S1;

  Result:=Result + ')'
end;

function TPGSQLCreateFunction.GetIsDropFunction: boolean;
begin
  Result:=Assigned(FPGSQLDropFunction);
end;

procedure TPGSQLCreateFunction.DoInit;
begin
  FTLanguage.Options:=FTLanguage.Options - [toOptional];
  FTAS.Options:=FTAS.Options - [toOptional];
end;

function TPGSQLCreateFunction.GetPGSQLDropFunction: TPGSQLDropFunction;
begin
  if not Assigned(FPGSQLDropFunction) then
    FPGSQLDropFunction:=TPGSQLDropFunction.Create(nil);
  Result:=FPGSQLDropFunction;
end;

procedure TPGSQLCreateFunction.InitParserTree;
var
  Par1, Par2, T, FSQLTokens,
    T17, T17_1, T18, T19,
    T20, TSymb, TSymb2, TSymbOut, T200_1, T201_1,
    T202_1, T202, T203, T203_1, T204, T205, T206, T207, T208,
    T208_1, T209, T210, T210_1, Par1_RetSet: TSQLTokenRecord;
begin
  (*
  CREATE [ OR REPLACE ] FUNCTION
      имя ( [ [ режим_аргумента ] [ имя_аргумента ] тип_аргумента [ { DEFAULT | = } выражение_по_умолчанию ] [, ...] ] )
      [ RETURNS тип_результата
        | RETURNS TABLE ( имя_столбца тип_столбца [, ...] ) ]
    { LANGUAGE имя_языка
      | TRANSFORM { FOR TYPE имя_типа } [, ... ]
      | WINDOW
      | IMMUTABLE | STABLE | VOLATILE | [ NOT ] LEAKPROOF
      | CALLED ON NULL INPUT | RETURNS NULL ON NULL INPUT | STRICT
      | [ EXTERNAL ] SECURITY INVOKER | [ EXTERNAL ] SECURITY DEFINER
      | PARALLEL { UNSAFE | RESTRICTED | SAFE }
      | COST стоимость_выполнения
      | ROWS строк_в_результате
      | SET параметр_конфигурации { TO значение | = значение | FROM CURRENT }
      | AS 'определение'
      | AS 'объектный_файл', 'объектный_символ'
    } ...
      [ WITH ( атрибут [, ...] ) ]
*)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okStoredProc);
      Par1:=AddSQLTokens(stKeyword, FSQLTokens, 'OR', []);
      Par1:=AddSQLTokens(stKeyword, Par1, 'REPLACE', [], 6);
  Par1:=AddSQLTokens(stKeyword, [FSQLTokens, Par1], 'FUNCTION', [toFindWordLast]);
    Par1:=AddSQLTokens(stIdentificator, Par1, '', [], 7);
    Par2:=AddSQLTokens(stSymbol, Par1, '.', []);
    Par2:=AddSQLTokens(stIdentificator, Par2, '', [], 8);

  TSymb:=AddSQLTokens(stSymbol, [Par1, Par2], '(', []);
  TSymb2:=AddSQLTokens(stSymbol, TSymb, ')', [], 110);
  CreateInParamsTree(Self, TSymb, TSymb2);


  Par1:=AddSQLTokens(stKeyword, TSymb2, 'RETURNS', []);               //   RETURNS
    Par1_RetSet:=AddSQLTokens(stKeyword, Par1, 'SETOF', [], 21);
    T17:=AddSQLTokens(stKeyword, [Par1, Par1_RetSet], 'TRIGGER', [], 17);
    T17_1:=AddSQLTokens(stIdentificator, [Par1, Par1_RetSet], '', [], 17);
    T18:=AddSQLTokens(stKeyword, [Par1, Par1_RetSet], 'TABLE', [], 18);
      T:=AddSQLTokens(stSymbol, T18, '(', []);
      T19:=AddSQLTokens(stIdentificator, T, '', [], 19);
      T:=AddSQLTokens(stSymbol, T19, ',', []);
      T20:=AddSQLTokens(stIdentificator, T, '', [], 20);
  TSymbOut:=AddSQLTokens(stSymbol, [T19, T20], ')', []);

  FTLanguage:=AddSQLTokens(stKeyword, [TSymb2, T17, T17_1, TSymbOut], 'LANGUAGE', []);
    T200_1:=AddSQLTokens(stIdentificator, FTLanguage, '', [], 200);

  FTAS:=AddSQLTokens(stKeyword, [TSymb2, T17, T17_1, TSymbOut, T200_1], 'AS', []);
    T201_1:=AddSQLTokens(stString, FTAS, '', [], 201);
    T201_1.AddChildToken(FTLanguage);

  T202:=AddSQLTokens(stKeyword, [TSymb2, T17, T17_1, TSymbOut, T200_1, T201_1], 'COST', [toOptional]);
    T202_1:=AddSQLTokens(stInteger, T202, '', [], 202);
    T202_1.AddChildToken([FTLanguage, FTAS]);

  T203:=AddSQLTokens(stKeyword, [TSymb2, T17, T17_1, TSymbOut, T200_1, T201_1, T202_1], 'ROWS', [toOptional]);
    T203_1:=AddSQLTokens(stInteger, T202, '', [], 203);
    T203_1.AddChildToken([T202]);

  T204:=AddSQLTokens(stKeyword, [TSymb2, T17, T17_1, TSymbOut, T200_1, T201_1, T202_1, T203_1], 'WINDOW', [toOptional], 204);
    T204.AddChildToken([T202, T203]);

  T205:=AddSQLTokens(stKeyword, [TSymb2, T17, T17_1, TSymbOut, T200_1, T201_1, T202_1, T203_1, T204], 'IMMUTABLE', [toOptional], 205);
    T205.AddChildToken([T202, T203, T204]);
  T206:=AddSQLTokens(stKeyword, [TSymb2, T17, T17_1, TSymbOut, T200_1, T201_1, T202_1, T203_1, T204], 'STABLE', [toOptional], 206);
    T206.AddChildToken([T202, T203, T204]);
  T207:=AddSQLTokens(stKeyword, [TSymb2, T17, T17_1, TSymbOut, T200_1, T201_1, T202_1, T203_1, T204], 'VOLATILE', [toOptional], 207);
    T207.AddChildToken([T202, T203, T204]);

  T208:=AddSQLTokens(stKeyword, [TSymb2, T17, T17_1, TSymbOut, T200_1, T201_1, T202_1, T203_1, T204,
      T205, T206, T207], 'CALLED', [toOptional]);
    T208_1:=AddSQLTokens(stKeyword, T208, 'ON', []);
    T208_1:=AddSQLTokens(stKeyword, T208_1, 'NULL', []);
    T208_1:=AddSQLTokens(stKeyword, T208_1, 'INPUT', [], 208);
    T208_1.AddChildToken([T202, T203, T204, T205, T206, T207]);

  T209:=AddSQLTokens(stKeyword, [TSymb2, T17, T17_1, TSymbOut, T200_1, T201_1, T202_1, T203_1, T204,
      T205, T206, T207], 'STRICT', [toOptional], 209);
    T209.AddChildToken([T202, T203, T204, T205, T206, T207]);

  T210:=AddSQLTokens(stKeyword, [TSymb2, T17, T17_1, TSymbOut, T200_1, T201_1, T202_1, T203_1, T204,
      T205, T206, T207], 'RETURNS', [toOptional]);
    T210_1:=AddSQLTokens(stKeyword, T210, 'NULL', []);
    T210_1:=AddSQLTokens(stKeyword, T210_1, 'ON', []);
    T210_1:=AddSQLTokens(stKeyword, T210_1, 'NULL', []);
    T210_1:=AddSQLTokens(stKeyword, T210_1, 'INPUT', [], 209);
    T210_1.AddChildToken([T202, T203, T204, T205, T206, T207]);

//    | TRANSFORM { FOR TYPE имя_типа } [, ... ]
//| [ NOT ] LEAKPROOF
//| [ EXTERNAL ] SECURITY INVOKER | [ EXTERNAL ] SECURITY DEFINER
//| PARALLEL { UNSAFE | RESTRICTED | SAFE }
//| SET параметр_конфигурации { TO значение | = значение | FROM CURRENT }
//| AS 'определение'
//| AS 'объектный_файл', 'объектный_символ'
//[ WITH ( атрибут [, ...] ) ]

end;

procedure TPGSQLCreateFunction.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    6:CreateMode:=cmCreateOrAlter;
    7:Name:=AWord;
    8:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
    101,
    102,
    103,
    104:begin
           FCurParam:=Params.AddParam('');
           case AChild.Tag of
             101:FCurParam.InReturn:=spvtInput;
             102:FCurParam.InReturn:=spvtOutput;
             103:FCurParam.InReturn:=spvtInOut;
             104:FCurParam.InReturn:=spvtVariadic;
           end;
         end;
    105:begin
          if not Assigned(FCurParam) then
            FCurParam:=Params.AddParamWithType('', AWord)
          else
            FCurParam.TypeName:=AWord;
        end;
    106:if Assigned(FCurParam) then
        begin
           if FCurParam.Caption = '' then
           begin
             FCurParam.Caption:=FCurParam.TypeName;
             FCurParam.TypeName:=AWord;
           end
           else
             FCurParam.TypeName:=FCurParam.TypeName + AWord;
        end;
    107:if Assigned(FCurParam) then FCurParam.TypeName:=FCurParam.TypeName + AWord;
    108:if Assigned(FCurParam) then FCurParam.TypeName:=FCurParam.TypeName + ' ' + AWord;
    109,
    110:FCurParam:=nil;
     17:FRetParam:=Output.AddParamWithType('', AWord);
     19:FRetParam:=Output.AddParam(AWord);
     20:if Assigned(FRetParam) then FRetParam.TypeName:=AWord;
     21:FSetOF:=true;
    200:begin
          Language:=AWord;
          FTLanguage.Options:=FTLanguage.Options + [toOptional];
        end;
    201:begin
          Body := AnsiDequotedStr(AWord, '''');
          FTAS.Options:=FTAS.Options + [toOptional];
        end;
    202:Cost := StrToInt(AWord);
    203:AVGRows:=StrToInt(AWord);
    204:isWindow:=true;
    207:VolatilityCategories:=pgvcVOLATILE;
    206:VolatilityCategories:=pgvcSTABLE;
    205:VolatilityCategories:=pgvcIMMUTABLE;
    208:Strict:=false;
    209:Strict:=true;
  end;
end;

procedure TPGSQLCreateFunction.MakeSQL;

function DoQuotedBody(S:string):string;
var
  i: Integer;
  S1: String;
  P: TSQLParserField;
begin
  {$IFDEF PG_PARAMS_DESCRIPTION_IN_BODY}
  S1:='';
  for P in Params do
    if (P.Caption <> '') and (P.Description <> '') then
      S1:=S1 + '--$FBM '+P.Caption + ' ' + P.Description + LineEnding;

  if S1<>'' then
    S:=S1 + S;
  {$ENDIF}
  if (Pos('''', S) > 0) or (Pos(#13, S) > 0) or (Pos(#10, S) > 0) then
  begin
    S1:='$BODY$';
    if Pos(S1, S) > 0 then
    begin
      i:=0;
      repeat
        inc(i);
        S1:=Format('$BODY%d$', [i]);
      until Pos(S1, S) = 0;
    end;
    if (S<>'') and (not (S[1] in [#13, #10])) then
      S:=LineEnding + S;
    Result:=S1 + S + S1;
  end
  else
    Result:=QuotedStr(S);
end;

var
  S, S1: String;
  P: TSQLParserField;
begin
  if Assigned(FPGSQLDropFunction) then
    AddSQLCommand(FPGSQLDropFunction.AsSQL);

  S:='CREATE';
  if CreateMode = cmCreateOrAlter then S:=S + ' OR REPLACE';
(*  S:=S + ' FUNCTION ' + FullName + '(';

  S1:='';
  for P in Params do
  begin
    if S1<> '' then S1:=S1 + ',' + LineEnding;
    if P.InReturn = spvtInput then
        S1:=S1 + ' IN'
    else
    if P.InReturn = spvtOutput then
        S1:=S1 + ' OUT'
    else
    if P.InReturn = spvtInOut then
        S1:=S1 + ' INOUT';

    if P.Caption <> P.TypeName then
      S1:=S1 + ' ' + P.Caption;

    S1:=S1 + ' ' + P.TypeName;
  end;

  if S1<>'' then
    S:=S + S1;

  S:=S + ')' + LineEnding;
*)
  S:=S + ' FUNCTION ' + FunctionName + LineEnding;

  if Output.Count = 1 then
  begin

    S:=S + 'RETURNS ';
    if FSetOF then S:=S + 'SETOF ';
    S:=S + Output[0].TypeName + LineEnding
  end
  else
  if Output.Count > 1 then
  begin
    S:=S + 'RETURNS TABLE (';
    S1:='';
    for P in Params do
    begin
      if S1<> '' then S1:=S1 + ',' + LineEnding;
{      if P.Caption <> P.TypeName then
        S1:=S1 + ' ' + P.Caption;}
      S1:=S1 + '  ' + P.Caption + ' ' + P.TypeName;
    end;
    S:=S + S1 + ')' + LineEnding;
  end;

  if Body <> '' then
    S:=S + 'AS' + LineEnding + DoQuotedBody(Body) + LineEnding;
  if Language <> '' then
    S:=S + 'LANGUAGE ' + Language + LineEnding;
  if Cost <> 0 then
    S:=S + 'COST ' + IntToStr(Cost) + LineEnding;
  if AVGRows <> 0 then
    S:=S + 'ROWS ' + IntToStr(AVGRows) + LineEnding;
  if isWindow then
    S:=S + ' WINDOW';
  S:=S + ' ' + PGSPVolatCatNames[VolatilityCategories];

  if Strict then
    S:=S + ' STRICT';
(*
  | TRANSFORM { FOR TYPE имя_типа } [, ... ]
  | [ NOT ] LEAKPROOF
  | CALLED ON NULL INPUT | RETURNS NULL ON NULL INPUT | STRICT
  | [ EXTERNAL ] SECURITY INVOKER | [ EXTERNAL ] SECURITY DEFINER
  | PARALLEL { UNSAFE | RESTRICTED | SAFE }
  | SET параметр_конфигурации { TO значение | = значение | FROM CURRENT }
  | AS 'определение'
  | AS 'объектный_файл', 'объектный_символ'
} ...
  [ WITH ( атрибут [, ...] ) ]

*)
  AddSQLCommand(S);

  if Description <> '' then
    DescribeObject;
end;

procedure TPGSQLCreateFunction.SetBody(AValue: string);
{$IFDEF PG_PARAMS_DESCRIPTION_IN_BODY}
var
  P: TSQLParserField;
  ProcBody: TStringList;
  S, S1: String;
{$ENDIF}
begin
  {$IFDEF PG_PARAMS_DESCRIPTION_IN_BODY}
  ProcBody:=TStringList.Create;
  ProcBody.Text:=TrimLeft(AValue);
  while ProcBody.Count > 0 do
  begin
    S:=ProcBody[0];
    if Copy(S, 1, 6) = '--$FBM' then
    begin
      Delete(S, 1, 7);
      S1:=Copy2SpaceDel(S);
      P:=Params.FindParam(S1);
      if Assigned(P) then
      begin
        P.Description:=S;
        ProcBody.Delete(0);
      end
      else
        Break;
    end
    else
      Break;
  end;
  inherited SetBody(ProcBody.Text);
  ProcBody.Free;
  {$ELSE}
  inherited SetBody(AValue);
  {$ENDIF}
end;

constructor TPGSQLCreateFunction.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okStoredProc;
  FSQLCommentOnClass:=TPGSQLCommentOn;
  FOutput:=TSQLFields.Create;
end;

destructor TPGSQLCreateFunction.Destroy;
begin
  FreeAndNil(FOutput);
  if Assigned(FPGSQLDropFunction) then
    FreeAndNil(FPGSQLDropFunction);
  inherited Destroy;
end;

procedure TPGSQLCreateFunction.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLCreateFunction then
  begin
    Output.Assign(TPGSQLCreateFunction(ASource).Output);
    if Assigned(FPGSQLDropFunction) then
      FPGSQLDropFunction.Assign(TPGSQLCreateFunction(ASource).FPGSQLDropFunction);

    Language:=TPGSQLCreateFunction(ASource).Language;
    Cost:=TPGSQLCreateFunction(ASource).Cost;
    AVGRows:=TPGSQLCreateFunction(ASource).AVGRows;
    VolatilityCategories:=TPGSQLCreateFunction(ASource).VolatilityCategories;
    isWindow:=TPGSQLCreateFunction(ASource).isWindow;
    Strict:=TPGSQLCreateFunction(ASource).Strict;
    SetOF:=TPGSQLCreateFunction(ASource).SetOF;
  end;
  inherited Assign(ASource);
end;

end.

