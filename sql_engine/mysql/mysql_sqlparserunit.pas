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
{
  for detail information see:
  http://dev.mysql.com/doc/refman/5.7/en/sql-syntax-data-definition.html
}

unit mysql_SqlParserUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, fbmSqlParserUnit, SQLEngineCommonTypesUnit, sqlObjects;

const
  MySQLObjectNames : array [TDBObjectKind] of string =
    ('',            //okNone,
     '',      //okDomain
     'TABLE',       //okTable
     'VIEW',        //okView
     'TRIGGER',     //okTrigger
     'PROCEDURE',   //okStoredProc
     'SEQUENCE',    //okSequence
     'EXCEPTION',   //okException
     'UDF',         //okUDF
     'ROLE',        //okRole
     'USER',        //okUser
     '',            //okLogin
     'SCHEMA',      //okScheme,
     '',            //okGroup
     'INDEX',       //okIndex,
     '',            //okTableSpace
     '',            //okLanguage
     '',            //okCheckConstraint,
     'FOREIGN KEY', //okForeignKey,
     'PRIMARY KEY', //okPrimaryKey,
     '',            //okUniqueConstraint
     '',            //okAutoIncFields,
     '',            //okRule,
     '',            //okOther,
     '',            //okTasks,
     '',            //okConversion,
     'DATABASE',    //okDatabase,
     '',            //okType,
     '',            //okServer
     'COLUMN',      //okColumn,
     'CHARCTER SET',//okCharSet,
     'COLLATION',   //okCollation,
     'FILTER',      //okFilter,
     'PARAMETER',   //okParameter
     '',            //okAccessMethod
     '',            //okAggregate
     '',            //okMaterializedView
     '',            //okCast
     '',            //okConstraint
     '',            //okExtension
     '',            //okForeignTable
     '',            //okForeignDataWrapper
     '',            //okForeignServer
     '',            //okLargeObject
     '',            //okPolicy
     'FUNCTION',    //okFunction
     '',            //okEventTrigger
     '',            //okAutoIncFields
     '',            //okFTSConfig,
     '',            //okFTSDictionary,
     '',            //okFTSParser,
     '',            //okFTSTemplate
     '',            //okPackage
     '',            //okPackageBody
     '',            //okTransform
     '',            //okOperator
     '',            //okOperatorClass,
     '',            //okOperatorFamily
     '',            //okUserMapping
     '',            //okPartitionTable
     '',            //okProcedureParametr
     ''             //okFunctionParametr
     );

type
  TViewAlgorithm = (vaUndefined, vaMerge, vaTemptable);
  TProcDeterministicType = (ptUnknow, ptNotDeterministic, ptDeterministic);
  TProcSqlAccess = (saContainsSql, saNoSql, saReadsSqlData, saModifiesSqlData);
  TProcSecurity = (psDefiner, psInvoker);

  TMySetScope = (mssNone, mssGlobal, mssSession);

  TMySQLShowCommand = (
      myShowAuthors,
      myShowCollumnsFromTable,
      myShowContributors,
      myShowCreateDatabase,
      myShowCreateEvent,
      myShowCreateProcedure,
      myShowCreateTable,
      myShowCreateTrigger,
      myShowCreateView,
      myShowDatabases,
      myShowEngine,
(*
    SHOW [STORAGE] ENGINES
    SHOW ERRORS [LIMIT [offset,] row_count]
    SHOW [FULL] EVENTS
    SHOW FUNCTION CODE func_name
    SHOW FUNCTION STATUS [like_or_where]
*)
      myShowGrantsForUser,
    myShowIndex,
    (*    SHOW INNODB STATUS
    SHOW OPEN TABLES [FROM db_name] [like_or_where] *)
    myShowPlugins,
(*    SHOW PROCEDURE CODE proc_name
    SHOW PROCEDURE STATUS [like_or_where] *)
      myShowPrivileges,
      myShowProcesslist,
//    SHOW PROFILE [types] [FOR QUERY n] [OFFSET n] [LIMIT n]
    myShowProfiles,
    myShowStatus,
    myShowTableStatus, //SHOW TABLE STATUS [FROM db_name] [like_or_where]

//    SHOW TABLES [FROM db_name] [like_or_where]
    myShowTriggers,
    myShowVariables,
(*
    SHOW WARNINGS [LIMIT [offset,] row_count]
*)
    myShowCharacterSET,
    myShowCollation
(*
    SHOW COLUMNS
    SHOW DATABASES
    SHOW FUNCTION STATUS
    SHOW INDEX
    SHOW OPEN TABLES
    SHOW PROCEDURE STATUS
    SHOW STATUS
    SHOW TABLE STATUS
    SHOW TABLES
    SHOW TRIGGERS
    SHOW VARIABLES
    *));
type

  { TMySQLCreateDatabase }

  TMySQLCreateDatabase = class(TSQLCreateDatabase)
  private
    FCharsetName: string;
    FCollationName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property CharsetName:string read FCharsetName write FCharsetName;
    property CollationName:string read FCollationName write FCollationName;
  end;

  { TMySQLAlterDatabase }

  TMySQLAlterDatabase = class(TSQLCommandDDL)
  private
    FCharsetName: string;
    FCollationName: string;
    FUpgradeDataDirectory: boolean;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property CharsetName:string read FCharsetName write FCharsetName;
    property CollationName:string read FCollationName write FCollationName;
    property UpgradeDataDirectory:boolean read FUpgradeDataDirectory write FUpgradeDataDirectory;
  end;

  { TMySQLDropDatabase }

  TMySQLDropDatabase = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
  end;

  { TMySQLCreateTable }

  TMySQLCreateTable = class(TSQLCreateTable)
  private
    FCurField: TSQLParserField;
    FCurConstr: TSQLConstraintItem;
    FCurFK:integer;
    FEngineName: string;
    FTableParams: TStrings;
    FCurPar: String;
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure InternalFormatsInit; override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    destructor Destroy;override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property EngineName:string read FEngineName write FEngineName;
    property TableParams:TStrings read FTableParams;
  end;

  { TMySQLAlterTable }

  TMySQLAlterTable = class(TSQLAlterTable)
  private
    FCurField: TSQLParserField;
    FCurConstr: TSQLConstraintItem;
    FCurFK:integer;
    FCurOper: TAlterTableOperator;
    function ColDataType(Field:TSQLParserField):string;
    procedure AddCollumn(OP: TAlterTableOperator);
    procedure ModifyCollumn(OP: TAlterTableOperator);
    procedure AddConstrint(STbl:string; AOper:TAlterTableOperator);
  protected
    procedure InternalFormatsInit; override;
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
  end;


  { TMySQLDropTable }

  TMySQLDropTable = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InternalFormatsInit; override;
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    property Tables;
  end;

  { TMySQLCreateView }

  TMySQLCreateView = class(TSQLCreateView)
  private
    FOwnerUser: string;
    FSQLCommandSelect: TSQLCommandAbstractSelect;
    FCurField: TSQLParserField;
    FSqlSecurity: string;
    FViewAlgorithm: TViewAlgorithm;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property SQLCommandSelect:TSQLCommandAbstractSelect read FSQLCommandSelect;
    property ViewAlgorithm:TViewAlgorithm read FViewAlgorithm write FViewAlgorithm;
    property OwnerUser:string read FOwnerUser write FOwnerUser;
    property SqlSecurity:string read FSqlSecurity write FSqlSecurity;
    property SchemaName;
  end;

  { TMySQLDropView }

  TMySQLDropView = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    property Tables;
  end;

  { TMySQLCreateTrigger }

  TMySQLCreateTrigger = class(TSQLCreateTrigger)
  private
    FDefiner: string;
    FTriggerOrder: TTriggerType;
    FTriggerOrderName: string;
    procedure OnProcessComment(Sender:TSQLParser; AComment:string);
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property Definer:string read FDefiner write FDefiner;
    property TriggerOrder:TTriggerType read FTriggerOrder write FTriggerOrder;
    property TriggerOrderName:string read FTriggerOrderName write FTriggerOrderName;
    property TableName;
  end;

  { TMySQLDropTrigger }

  TMySQLDropTrigger = class(TSQLDropTrigger)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TMySQLCreateFunction }

  TMySQLCreateFunction = class(TSQLCommandCreateProcedure)
  private
    FDefiner: string;
    FCurField: TSQLParserField;
    FDetermType: TProcDeterministicType;
    FReturnType: TSQLParserField;
    FSecurity: TProcSecurity;
    FSqlAccess: TProcSqlAccess;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    destructor Destroy;override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property Definer:string read FDefiner write FDefiner;
    property DetermType:TProcDeterministicType read FDetermType write FDetermType;
    property SqlAccess:TProcSqlAccess read FSqlAccess write FSqlAccess;
    property Security:TProcSecurity read FSecurity write FSecurity;
    property ReturnType: TSQLParserField read FReturnType write FReturnType;
  end;

  { TMySQLAlterFunction }

  TMySQLAlterFunction = class(TSQLCommandDDL)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TMySQLDropFunction }

  TMySQLDropFunction = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
  end;

  { TMySQLRenameTable }

  TMySQLRenameTable = class(TSQLCommandDDL)
  private
    FCurTable: TSQLParserField;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TMySQLTruncateTable }

  TMySQLTruncateTable= class(TSQLCommandDDL)
  private
    FIsTable: boolean;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property IsTable:boolean read FIsTable write FIsTable;
  end;

  { TMySQLSET }

  TMySQLSET = class(TSQLCommandDDL)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TMySQLRepairTable }

  TMySQLRepairTable = class(TSQLCommandDDL)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TMySQLSHOW }

  TMySQLSHOW = class(TSQLCommandDML)
  private
    FFull: boolean;
    FSetScope: TMySetScope;
    FShowCommand:TMySQLShowCommand;
    FLikeStr:string;
    FWhere:string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property LikeStr:string read FLikeStr write FLikeStr;
    property Where:string read FWhere write FWhere;
    property Full:boolean read FFull write FFull;
    property ShowCommand:TMySQLShowCommand read FShowCommand write FShowCommand;
    property SetScope:TMySetScope read FSetScope write FSetScope;
  end;

  { TMySQLCreateTablespace }

  TMySQLCreateTablespace = class(TSQLCreateCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TMySQLAlterTablespace }

  TMySQLAlterTablespace = class(TSQLCommandDDL)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TMySQLDropTablespace }

  TMySQLDropTablespace = class(TSQLDropCommandAbstract)
  private
    FEngine: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
    property Engine:string read FEngine write FEngine;
  end;


  { TMySQLCreateServer }

  TMySQLCreateServer = class(TSQLCreateCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TMySQLAlterServer }

  TMySQLAlterServer = class(TSQLCommandDDL)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TMySQLDropServer }

  TMySQLDropServer = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TMySQLCreateUser }
  TMySQLIdentType = (
    msitIdentifiedByAuthString,                  //IDENTIFIED BY 'authentication_string'
    msitIdentifiedByPwd,                         //IDENTIFIED BY PASSWORD 'hash_string'
    msitIdentifiedViaAuthPlugin,                 //IDENTIFIED {VIA|WITH} authentication_plugin
    msitIdentifiedWithAuthPlugin,                //IDENTIFIED {VIA|WITH} authentication_plugin
    msitIdentifiedViaAuthPluginByStr,            //IDENTIFIED {VIA|WITH} authentication_plugin BY 'authentication_string'
    msitIdentifiedWithAuthPluginByStr,           //IDENTIFIED {VIA|WITH} authentication_plugin BY 'authentication_string'
    msitIdentifiedViaAuthPluginUsingHashStr,     //IDENTIFIED {VIA|WITH} authentication_plugin {USING|AS} 'hash_string'
    msitIdentifiedWithAuthPluginUsingHashStr    //IDENTIFIED {VIA|WITH} authentication_plugin {USING|AS} 'hash_string'
  );

  { TODO : В дальнейшем заменить на  TObjectGrant}
  TMySQLUserOption  = (
    msuoSelectPriv, msuoInsertPriv, msuoUpdatePriv, msuoDeletePriv,
    msuoCreatePriv, msuoDropPriv, msuoReloadPriv, msuoShutdownPriv,
    msuoProcessPriv, msuoFilePriv, msuoGrantPriv, msuoReferencesPriv,
    msuoIndexPriv, msuoAlterPriv, msuoShowDBPriv, msuoSuperPriv,
    msuoCreateTmpTablePriv, msuoLockTablesPriv, msuoExecutePriv,
    msuoReplSlavePriv, msuoReplClientPriv, msuoCreateViewPriv,
    msuoShowViewPriv, msuoCreateRoutinePriv, msuoAlterRoutinePriv,
    msuoCreateUserPriv, msuoEventPriv, msuoTriggerPriv, msuoCreateTablespacePriv);
  TMySQLUserOptions = set of TMySQLUserOption;

  TMySQLCreateUser = class(TSQLCreateLogin)
  private
    FAuthenticationPlugin: string;
    FHostName: string;
    FIdentType: TMySQLIdentType;
    FMaxConnectionsPerHour: integer;
    FMaxQueriesPerHour: integer;
    FMaxUpdatePerHour: integer;
    FMaxUserConnections: integer;
    FUserOptions: TMySQLUserOptions;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property IdentType:TMySQLIdentType read FIdentType write FIdentType;
    property HostName:string read FHostName write FHostName;
    property AuthenticationPlugin:string read FAuthenticationPlugin write FAuthenticationPlugin;

    property UserOptions:TMySQLUserOptions read FUserOptions write FUserOptions;

    property MaxQueriesPerHour:integer read FMaxQueriesPerHour write FMaxQueriesPerHour;
    property MaxUpdatePerHour:integer read FMaxUpdatePerHour write FMaxUpdatePerHour;
    property MaxConnectionsPerHour:integer read FMaxConnectionsPerHour write FMaxConnectionsPerHour;
    property MaxUserConnections:integer read FMaxUserConnections write FMaxUserConnections;

  end;

  { TMySQLAlterUser }

  TMySQLAlterUser = class(TSQLAlterLogin)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TMySQLDropUser }

  TMySQLDropUser = class(TSQLDropLogin)
  private
    FCurItem: TSQLParserField;
  protected
    procedure SetName(AValue: string); override;
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TMySQLGrant }

  TMySQLGrant = class(TSQLCommandGrant)
  private
    FCurOG: TObjectGrant;
    FCurObj: TTableItem;
    FCurUsr: TSQLParserField;
  protected
    FSQLTokens: TSQLTokenRecord;
    TTo: TSQLTokenRecord;
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TMySQLRevoke }

  TMySQLRevoke = class(TMySQLGrant)
  private
  protected
    procedure InitParserTree;override;
    //procedure MakeSQL;override;
  public
  end;

  TMySQLRename = class(TSQLCommandDDL)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TMySQLCommentOn }

  TMySQLCommentOn = class(TSQLCommentOn)
  private
  protected
    procedure MakeSQL;override;
  public
  end;


  { TMySQLFlush }
  TFlushLogMode = (mysqlflmNone, mysqlflmNO_WRITE_TO_BINLOG, mysqlflmLOCAL);
  TMySQLFlush = class(TSQLCommandDDL)
  private
    FFlushLogMode: TFlushLogMode;
    FCurItem: TSQLParserField;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord;const AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property FlushLogMode:TFlushLogMode read FFlushLogMode write FFlushLogMode;
  end;

implementation
uses StrUtils, rxstrutils, sqlParserConsts;

const
  MySQLObjectGrantNames  : array [TObjectGrant] of string =
   ('SELECT',                 //ogSelect,            --SELECT 	Enable use of SELECT. Levels: Global, database, table, column.
    'INSERT',                 //ogInsert,            --INSERT 	Enable use of INSERT. Levels: Global, database, table, column.
    'UPDATE',                 //ogUpdate,            --UPDATE 	Enable use of UPDATE. Levels: Global, database, table, column.
    'DELETE',                 //ogDelete,            --DELETE 	Enable use of DELETE. Level: Global, database, table.
    'EXECUTE',                //ogExecute,           --EXECUTE 	Enable the user to execute stored routines. Levels: Global, database, routine.
    'REFERENCES',             //ogReference,         --REFERENCES Enable foreign key creation. Levels: Global, database, table, column.
    'CREATE',                 //ogCreate,            --CREATE 	Enable database and table creation. Levels: Global, database, table.
    '',                       //ogRule,
    'TEMPORARY TABLES',       //ogTemporary,         --CREATE TEMPORARY TABLES 	Enable use of CREATE TEMPORARY TABLE. Levels: Global, database.
    '',                       //ogTruncate,
    'TRIGGER',                //ogTrigger,           --TRIGGER 	Enable trigger operations. Levels: Global, database, table.
    'USAGE',                  //ogUsage,             --USAGE 	Synonym for “no privileges”
    '',                       //ogWGO,               --GRANT OPTION 	Enable privileges to be granted to or removed from other accounts. Levels: Global, database, table, routine, proxy.
    '',                       //ogConnect,
    'ALL PRIVILEGES',         //ogAll                --ALL [PRIVILEGES] 	Grant all privileges at specified access level except GRANT OPTION and PROXY.
    'ALTER',                  //ogAlter,             --Enable use of ALTER TABLE. Levels: Global, database, table.
    'ALTER ROUTINE',          //ogAlterRoutine       --Enable stored routines to be altered or dropped. Levels: Global, database, routine.
    'CREATE ROUTINE',         //ogCreateRoutine      --Enable stored routine creation. Levels: Global, database.
    'CREATE TABLESPACE',      //ogCreateTablespace   --Enable tablespaces and log file groups to be created, altered, or dropped. Level: Global.
    'CREATE USER',            //ogCreateUser         --Enable use of CREATE USER, DROP USER, RENAME USER, and REVOKE ALL PRIVILEGES. Level: Global.
    'CREATE VIEW',            //ogCreateView         --Enable views to be created or altered. Levels: Global, database, table.
    'DROP',                   //ogDrop               --Enable databases, tables, and views to be dropped. Levels: Global, database, table.
    'EVENT',                  //ogEvent              --Enable use of events for the Event Scheduler. Levels: Global, database.
    'FILE',                   //ogFile               --Enable the user to cause the server to read or write files. Level: Global.
    'INDEX',                  //ogIndex              --Enable indexes to be created or dropped. Levels: Global, database, table.
    'LOCK TABLES',            //ogLockTables         --Enable use of LOCK TABLES on tables for which you have the SELECT privilege. Levels: Global, database.
    'PROCESS',                //ogProcess            --Enable the user to see all processes with SHOW PROCESSLIST. Level: Global.
    'PROXY',                  //ogProxy              --Enable user proxying. Level: From user to user.
    'RELOAD',                 //ogReload             --Enable use of FLUSH operations. Level: Global.
    'REPLICATION CLIENT',     //ogReplicationClient  --Enable the user to ask where master or slave servers are. Level: Global.
    'REPLICATION SLAVE',      //ogReplicationSlave   --Enable replication slaves to read binary log events from the master. Level: Global.
    'SHOW DATABASES',         //ogShowDatabases      --Enable SHOW DATABASES to show all databases. Level: Global.
    'SHOW VIEW',              //ogShowView           --Enable use of SHOW CREATE VIEW. Levels: Global, database, table.
    'SHUTDOWN',               //ogShutdown           --Enable use of mysqladmin shutdown. Level: Global.
    'SUPER',                  //ogSuper              --Enable use of other administrative operations such as CHANGE MASTER TO, KILL, PURGE BINARY LOGS, SET GLOBAL, and mysqladmin debug command. Level: Global.
    ''                        //ogMembership
    );

type
  TTypeDefMode = (tdfTypeOnly, tdfTableColDef);

procedure MakeTypeDefTree(ACmd:TSQLCommandAbstract;
  AFirstTokens: array of TSQLTokenRecord;
  AEndTokens : array of TSQLTokenRecord;
  AMode : TTypeDefMode;
  TagBase:integer);
var
  TD1, TDLen1, TDLen1_1, TDLen1_2, TD2, TDLen2, TDLen2_1,
    TDLen2_2, TD3, TD8, TD9, TD10, TDLen3, TDLen3_1, TDLen3_2,
    TDLen3_3, TUnsigned, TZerofill, TD26, TD27, TD28, TD29,
    TD30, TD31, TD32, TD33, TD4, TD5, TD6, TD7, TDLen4,
    TDLen4_1, TDLen4_2, TDLen4_3, TD11, TD12, TD18, TDLen5,
    TDLen5_1, TDLen5_2, TD19, TBin, TCharSet1, TCollat,
    TCollat1, TD20, TD21, TD22, TD23, TD13, TD14, TD15, TD16,
    TD17, TChSet, TD24, TD25, TD24_1, TD24_2, TD24_3, TD24_4,
    TSymb, TD24_5, TNull, TNotNull, TNotNull1, TAutoInc, TUniq,
    TUniq1, TPK, TPK1, TDesc, TDesc1, TDef, TDef1, TColForm,
    TColForm1, TColForm2, TColForm3, TColStorage, TColStorage1,
    TColStorage2, TColStorage3, TGA, TVirt1, TVirt2, TAS,
    TSymbAs, TUniq2, TUniq3, TDesc2, TDesc3, TPK2, TPK3,
    TNull1, TNotNull2, TNotNull3, TRef, TRef1, TRefSymb, TRef2,
    TRef2_1, TRef2_2, TRef2_3, TRef3, TRef3_1, TRef3_2,
    TRef3_3, TRef3_4, TRef3_5, TRef3_6, TDef2: TSQLTokenRecord;
  i: Integer;
begin
  if Length(AFirstTokens) < 1 then
    raise Exception.Create('procedure MakeTypeDefTree');

  TD1:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'BIT', [], 2 + TagBase);
  TD2:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'TINYINT', [], 2 + TagBase);
  TD3:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'SMALLINT', [], 2 + TagBase);
  TD4:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'MEDIUMINT', [], 2 + TagBase);
  TD5:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'INT', [], 2 + TagBase);
  TD6:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'INTEGER', [], 2 + TagBase);
  TD7:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'BIGINT', [], 2 + TagBase);

  TD8:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'REAL', [], 2 + TagBase);
  TD9:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'DOUBLE', [], 2 + TagBase);
  TD10:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'FLOAT', [], 2 + TagBase);

  TD11:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'DECIMAL', [], 2 + TagBase);
  TD12:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'NUMERIC', [], 2 + TagBase);

  TD13:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'TIME', [], 2 + TagBase);
  TD14:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'TIMESTAMP', [], 2 + TagBase);
  TD15:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'DATETIME', [], 2 + TagBase);
  TD16:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'BINARY', [], 2 + TagBase);
  TD17:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'VARBINARY', [], 2 + TagBase);

  TDLen1:=ACmd.AddSQLTokens(stSymbol, [TD1, TD13, TD14, TD15, TD16, TD17], '(', [toOptional]);
    TDLen1_1:=ACmd.AddSQLTokens(stInteger, TDLen1, '', [], 4 + TagBase);
    TDLen1_2:=ACmd.AddSQLTokens(stSymbol, [TDLen1_1], ')', []);

  TDLen2:=ACmd.AddSQLTokens(stSymbol, [TD2, TD3, TD4, TD5, TD6, TD7], '(', [toOptional]);
    TDLen2_1:=ACmd.AddSQLTokens(stInteger, TDLen2, '', [], 4 + TagBase);
    TDLen2_2:=ACmd.AddSQLTokens(stSymbol, TDLen2_1, ')', []);

  TDLen3:=ACmd.AddSQLTokens(stSymbol, [TD8, TD9, TD10], '(', [toOptional]);
    TDLen3_1:=ACmd.AddSQLTokens(stInteger, TDLen3, '', [], 4 + TagBase);
    TDLen3_2:=ACmd.AddSQLTokens(stSymbol, TDLen3_1, ',', []);
    TDLen3_3:=ACmd.AddSQLTokens(stInteger, TDLen3_2, '', [], 5 + TagBase);
    TDLen3_3:=ACmd.AddSQLTokens(stSymbol, TDLen3_3, ')', []);

  TDLen4:=ACmd.AddSQLTokens(stSymbol, [TD11, TD12], '(', [toOptional]);
    TDLen4_1:=ACmd.AddSQLTokens(stInteger, TDLen4, '', [], 4 + TagBase);
    TDLen4_2:=ACmd.AddSQLTokens(stSymbol, TDLen4_1, ',', []);
    TDLen4_3:=ACmd.AddSQLTokens(stInteger, TDLen4_2, '', [], 5 + TagBase);
    TDLen4_3:=ACmd.AddSQLTokens(stSymbol, [TDLen4_3, TDLen4_1], ')', []);

    TUnsigned:=ACmd.AddSQLTokens(stKeyword, [TDLen2_2, TDLen3_3, TDLen4_3, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10], 'UNSIGNED', [toOptional], 6 + TagBase);
    TZerofill:=ACmd.AddSQLTokens(stKeyword, [TUnsigned, TDLen2_2, TDLen3_3, TDLen4_3, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10], 'ZEROFILL', [toOptional], 7 + TagBase);
      TZerofill.AddChildToken(TUnsigned);


  TD18:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'CHAR', [], 2 + TagBase);
  TD19:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'VARCHAR', [], 2 + TagBase);

  TDLen5:=ACmd.AddSQLTokens(stSymbol, [TD18, TD19], '(', [toOptional]);
    TDLen5_1:=ACmd.AddSQLTokens(stInteger, TDLen5, '', [], 4 + TagBase);
    TDLen5_2:=ACmd.AddSQLTokens(stSymbol, [TDLen5_1], ')', []);

  TD20:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'TINYTEXT', [], 2 + TagBase);
  TD21:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'TEXT', [], 2 + TagBase);
  TD22:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'MEDIUMTEXT', [], 2 + TagBase);
  TD23:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'LONGTEXT', [], 2 + TagBase);

  TBin:=ACmd.AddSQLTokens(stKeyword, [TDLen5_2, TD18, TD19, TD20, TD21, TD22, TD23], 'BINARY', [toOptional], 8 + TagBase);

  TD24:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'ENUM', [], 2 + TagBase);
  TD25:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'SET', [], 2 + TagBase);
    TD24_1:=ACmd.AddSQLTokens(stSymbol, [TD24, TD25], '(', [], 3 + TagBase);
    TD24_2:=ACmd.AddSQLTokens(stIdentificator, TD24_1, '', [], 3 + TagBase);
    TD24_3:=ACmd.AddSQLTokens(stString, TD24_1, '', [], 3 + TagBase);
    TD24_4:=ACmd.AddSQLTokens(stInteger, TD24_1, '', [], 3 + TagBase);
      TSymb:=ACmd.AddSQLTokens(stSymbol, [TD24_2, TD24_3, TD24_4], ',', [], 3 + TagBase);
      TSymb.AddChildToken([TD24_2, TD24_3, TD24_4]);
    TD24_5:=ACmd.AddSQLTokens(stSymbol, [TD24_2, TD24_3, TD24_4], ')', [], 3 + TagBase);

  TChSet:=ACmd.AddSQLTokens(stKeyword, [TDLen5_2, TBin, TD18, TD19, TD20, TD21, TD22, TD23, TD24_5], 'CHARACTER', [toOptional]);
    TCharSet1:=ACmd.AddSQLTokens(stKeyword, TChSet, 'SET', []);
    TCharSet1:=ACmd.AddSQLTokens(stIdentificator, TCharSet1, '', [], 9 + TagBase);
    TCharSet1.AddChildToken(TBin);

  TCollat:=ACmd.AddSQLTokens(stKeyword, [TDLen5_2, TBin, TCharSet1, TD18, TD19, TD20, TD21, TD22, TD23, TD24_5], 'COLLATE', [toOptional]);
    TCollat1:=ACmd.AddSQLTokens(stIdentificator, TCollat, '', [], 10 + TagBase);
    TCollat1.AddChildToken(TChSet);


  TD26:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'DATE', [], 2 + TagBase);
  TD27:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'YEAR', [], 2 + TagBase);
  TD28:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'TINYBLOB', [], 2 + TagBase);
  TD29:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'BLOB', [], 2 + TagBase);
  TD30:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'MEDIUMBLOB', [], 2 + TagBase);
  TD31:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'LONGBLOB', [], 2 + TagBase);
  TD32:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'JSON', [], 2 + TagBase);
  TD33:=ACmd.AddSQLTokens(stIdentificator, AFirstTokens[0], '', [], 2 + TagBase);

  for i:=1 to Length(AFirstTokens) - 1 do
    AFirstTokens[i].AddChildToken([TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10, TD11, TD12,
       TD13, TD14, TD15, TD16, TD17,
       TD18, TD19, TD20, TD21, TD22, TD23, TD24, TD25,
       TD26, TD27, TD28, TD29, TD30, TD31, TD32, TD33]);

  if AMode = tdfTableColDef then
  begin
    TNull:=ACmd.AddSQLTokens(stKeyword, [
        TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10, TD11, TD12, TD13, TD14,
        TD15, TD16, TD17, TD18, TD19, TD20, TD21, TD22, TD23, TD26, TD27, TD28,
        TD29, TD30, TD31, TD32, TD33, TD24_5, TDLen1_2, TDLen2_2, TDLen3_3, TDLen4_3,
        TDLen5_2, TUnsigned, TZerofill, TBin, TCharSet1, TCollat1], 'NULL', [toOptional], 11 + TagBase);

    TNotNull:=ACmd.AddSQLTokens(stKeyword, [
        TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10, TD11, TD12, TD13, TD14,
        TD15, TD16, TD17, TD18, TD19, TD20, TD21, TD22, TD23, TD26, TD27, TD28,
        TD29, TD30, TD31, TD32, TD33, TD24_5, TDLen1_2, TDLen2_2, TDLen3_3, TDLen4_3,
        TDLen5_2, TUnsigned, TZerofill, TBin, TCharSet1, TCollat1], 'NOT', [toOptional]);
      TNotNull1:=ACmd.AddSQLTokens(stKeyword, TNotNull, 'NULL', [], 12 + TagBase);

    TAutoInc:=ACmd.AddSQLTokens(stKeyword, [
        TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10, TD11, TD12, TD13, TD14,
        TD15, TD16, TD17, TD18, TD19, TD20, TD21, TD22, TD23, TD26, TD27, TD28,
        TD29, TD30, TD31, TD32, TD33, TD24_5, TDLen1_2, TDLen2_2, TDLen3_3, TDLen4_3,
        TDLen5_2, TUnsigned, TZerofill, TBin, TCharSet1, TCollat1,
        TNull, TNotNull1], 'AUTO_INCREMENT', [toOptional], 13 + TagBase);
        TAutoInc.AddChildToken([TNull, TNotNull]);

    TUniq:=ACmd.AddSQLTokens(stKeyword, [
        TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10, TD11, TD12, TD13, TD14,
        TD15, TD16, TD17, TD18, TD19, TD20, TD21, TD22, TD23, TD26, TD27, TD28,
        TD29, TD30, TD31, TD32, TD33, TD24_5, TDLen1_2, TDLen2_2, TDLen3_3, TDLen4_3,
        TDLen5_2, TUnsigned, TZerofill, TBin, TCharSet1, TCollat1,
        TNull, TNotNull1, TAutoInc], 'UNIQUE', [toOptional], 14 + TagBase);
        TUniq.AddChildToken([TNull, TNotNull, TAutoInc]);
      TUniq1:=ACmd.AddSQLTokens(stKeyword, TUniq, 'KEY', []);
        TUniq1.AddChildToken([TNull, TNotNull, TAutoInc]);

    TPK:=ACmd.AddSQLTokens(stKeyword, [
        TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10, TD11, TD12, TD13, TD14,
        TD15, TD16, TD17, TD18, TD19, TD20, TD21, TD22, TD23, TD26, TD27, TD28,
        TD29, TD30, TD31, TD32, TD33, TD24_5, TDLen1_2, TDLen2_2, TDLen3_3, TDLen4_3,
        TDLen5_2, TUnsigned, TZerofill, TBin, TCharSet1, TCollat1,
        TNull, TNotNull1, TAutoInc, TUniq1], 'PRIMARY', [toOptional], 15 + TagBase);
    TPK1:=ACmd.AddSQLTokens(stKeyword, [
        TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10, TD11, TD12, TD13, TD14,
        TD15, TD16, TD17, TD18, TD19, TD20, TD21, TD22, TD23, TD26, TD27, TD28,
        TD29, TD30, TD31, TD32, TD33, TD24_5, TDLen1_2, TDLen2_2, TDLen3_3, TDLen4_3,
        TDLen5_2, TUnsigned, TZerofill, TBin, TCharSet1, TCollat1,
        TNull, TNotNull1, TAutoInc, TUniq1, TPK], 'KEY', [toOptional], 15 + TagBase);
        TPK1.AddChildToken([TNull, TNotNull, TAutoInc, TUniq]);

    TDesc:=ACmd.AddSQLTokens(stKeyword, [
        TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10, TD11, TD12, TD13, TD14,
        TD15, TD16, TD17, TD18, TD19, TD20, TD21, TD22, TD23, TD26, TD27, TD28,
        TD29, TD30, TD31, TD32, TD33, TD24_5, TDLen1_2, TDLen2_2, TDLen3_3, TDLen4_3,
        TDLen5_2, TUnsigned, TZerofill, TBin, TCharSet1, TCollat1,
        TNull, TNotNull1, TAutoInc, TUniq1, TPK1], 'COMMENT', [toOptional]);
    TDesc1:=ACmd.AddSQLTokens(stString, TDesc, '', [], 16 + TagBase);
      TDesc1.AddChildToken([TNull, TNotNull, TAutoInc, TUniq, TPK, TPK1]);

    TDef:=ACmd.AddSQLTokens(stKeyword, [
        TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10, TD11, TD12, TD13, TD14,
        TD15, TD16, TD17, TD18, TD19, TD20, TD21, TD22, TD23, TD26, TD27, TD28,
        TD29, TD30, TD31, TD32, TD33, TD24_5, TDLen1_2, TDLen2_2, TDLen3_3, TDLen4_3,
        TDLen5_2, TUnsigned, TZerofill, TBin, TCharSet1, TCollat1,
        TNull, TNotNull1, TAutoInc, TUniq1, TPK1, TDesc1], 'DEFAULT', [toOptional]);
    TDef1:=ACmd.AddSQLTokens(stString, TDef, '', [], 17 + TagBase);
      TDef1.AddChildToken([TNull, TNotNull, TAutoInc, TUniq, TPK, TPK1, TDesc]);
    TDef2:=ACmd.AddSQLTokens(stKeyword, TDef, 'NULL', [], 17 + TagBase);
      TDef2.AddChildToken([TNull, TNotNull, TAutoInc, TUniq, TPK, TPK1, TDesc]);

    TColForm:=ACmd.AddSQLTokens(stKeyword, [
        TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10, TD11, TD12, TD13, TD14,
        TD15, TD16, TD17, TD18, TD19, TD20, TD21, TD22, TD23, TD26, TD27, TD28,
        TD29, TD30, TD31, TD32, TD33, TD24_5, TDLen1_2, TDLen2_2, TDLen3_3, TDLen4_3,
        TDLen5_2, TUnsigned, TZerofill, TBin, TCharSet1, TCollat1,
        TNull, TNotNull1, TAutoInc, TUniq1, TPK1, TDesc1, TDef1, TDef2], 'COLUMN_FORMAT', [toOptional]);
      TColForm1:=ACmd.AddSQLTokens(stKeyword, TColForm, 'FIXED', [], 18 + TagBase);
      TColForm2:=ACmd.AddSQLTokens(stKeyword, TColForm, 'DYNAMIC', [], 19 + TagBase);
      TColForm3:=ACmd.AddSQLTokens(stKeyword, TColForm, 'DEFAULT', [], 20 + TagBase);
        TColForm1.AddChildToken([TNull, TNotNull, TAutoInc, TUniq, TPK, TPK1, TDesc, TDef]);
        TColForm2.AddChildToken([TNull, TNotNull, TAutoInc, TUniq, TPK, TPK1, TDesc, TDef]);
        TColForm3.AddChildToken([TNull, TNotNull, TAutoInc, TUniq, TPK, TPK1, TDesc, TDef]);

    TColStorage:=ACmd.AddSQLTokens(stKeyword, [
        TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10, TD11, TD12, TD13, TD14,
        TD15, TD16, TD17, TD18, TD19, TD20, TD21, TD22, TD23, TD26, TD27, TD28,
        TD29, TD30, TD31, TD32, TD33, TD24_5, TDLen1_2, TDLen2_2, TDLen3_3, TDLen4_3,
        TDLen5_2, TUnsigned, TZerofill, TBin, TCharSet1, TCollat1,
        TNull, TNotNull1, TAutoInc, TUniq1, TPK1, TDesc1, TDef1, TDef2, TColForm1, TColForm2, TColForm3], 'STORAGE', [toOptional]);
      TColStorage1:=ACmd.AddSQLTokens(stKeyword, TColStorage, 'DISK', [], 21 + TagBase);
      TColStorage2:=ACmd.AddSQLTokens(stKeyword, TColStorage, 'MEMORY', [], 22 + TagBase);
      TColStorage3:=ACmd.AddSQLTokens(stKeyword, TColStorage, 'DEFAULT', [], 23 + TagBase);
        TColStorage1.AddChildToken([TNull, TNotNull, TAutoInc, TUniq, TPK, TPK1, TDesc, TDef, TColForm]);
        TColStorage2.AddChildToken([TNull, TNotNull, TAutoInc, TUniq, TPK, TPK1, TDesc, TDef, TColForm]);
        TColStorage3.AddChildToken([TNull, TNotNull, TAutoInc, TUniq, TPK, TPK1, TDesc, TDef, TColForm]);
    ///---

    TGA:=ACmd.AddSQLTokens(stKeyword, [
        TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10, TD11, TD12, TD13, TD14,
        TD15, TD16, TD17, TD18, TD19, TD20, TD21, TD22, TD23, TD26, TD27, TD28,
        TD29, TD30, TD31, TD32, TD33, TD24_5, TDLen1_2, TDLen2_2, TDLen3_3, TDLen4_3,
        TDLen5_2], 'GENERATED', [toOptional]);

    TGA:=ACmd.AddSQLTokens(stKeyword, TGA, 'ALWAYS', [toOptional]);

    TAS:=ACmd.AddSQLTokens(stKeyword, [TGA,
        TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10, TD11, TD12, TD13, TD14,
        TD15, TD16, TD17, TD18, TD19, TD20, TD21, TD22, TD23, TD26, TD27, TD28,
        TD29, TD30, TD31, TD32, TD33, TD24_5, TDLen1_2, TDLen2_2, TDLen3_3, TDLen4_3,
        TDLen5_2], 'AS', [toOptional]);
    TSymbAs:=ACmd.AddSQLTokens(stSymbol, TAS, '(', [], 24 + TagBase);
    TVirt1:=ACmd.AddSQLTokens(stKeyword, TSymbAs, 'VIRTUAL', [], 25 + TagBase);
    TVirt2:=ACmd.AddSQLTokens(stKeyword, TSymbAs, 'STORED', [], 26 + TagBase);

    TUniq2:=ACmd.AddSQLTokens(stKeyword, [TSymbAs, TVirt1, TVirt2], 'UNIQUE', [toOptional], 14 + TagBase);
        TUniq2.AddChildToken([TVirt1, TVirt2]);
      TUniq3:=ACmd.AddSQLTokens(stKeyword, TUniq2, 'KEY', []);
        TUniq3.AddChildToken([TVirt1, TVirt2]);

    TDesc2:=ACmd.AddSQLTokens(stKeyword, [TSymbAs, TVirt1, TVirt2, TUniq2, TUniq3], 'COMMENT', [toOptional]);
    TDesc3:=ACmd.AddSQLTokens(stString, TDesc2, '', [], 16 + TagBase);
      TDesc3.AddChildToken([TVirt1, TVirt2, TUniq2, TUniq3]);

    TPK2:=ACmd.AddSQLTokens(stKeyword, [TSymbAs, TVirt1, TVirt2, TUniq2, TUniq3,
        TDesc3], 'PRIMARY', [toOptional], 15 + TagBase);
    TPK3:=ACmd.AddSQLTokens(stKeyword, [TSymbAs, TVirt1, TVirt2, TUniq2, TUniq3,
        TDesc3, TPK2], 'KEY', [toOptional], 15 + TagBase);
        TPK3.AddChildToken([TVirt1, TVirt2, TUniq2, TUniq, TDesc2]);

    TNull1:=ACmd.AddSQLTokens(stKeyword, [TSymbAs, TVirt1, TVirt2, TUniq2, TUniq3,
        TDesc3, TPK3], 'NULL', [toOptional], 11 + TagBase);
      TNull1.AddChildToken([TVirt1, TVirt2, TUniq2, TUniq, TDesc2, TPK2]);

    TNotNull2:=ACmd.AddSQLTokens(stKeyword, [TSymbAs, TVirt1, TVirt2, TUniq2, TUniq3,
        TDesc3, TPK3], 'NOT', [toOptional]);
      TNotNull3:=ACmd.AddSQLTokens(stKeyword, TNotNull2, 'NULL', [], 12 + TagBase);
      TNotNull3.AddChildToken([TVirt1, TVirt2, TUniq2, TUniq, TDesc2, TPK2]);

    TRef:=ACmd.AddSQLTokens(stKeyword, [
          TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10, TD11, TD12, TD13, TD14,
          TD15, TD16, TD17, TD18, TD19, TD20, TD21, TD22, TD23, TD26, TD27, TD28,
          TD29, TD30, TD31, TD32, TD33, TD24_5, TDLen1_2, TDLen2_2, TDLen3_3, TDLen4_3,
          TDLen5_2, TUnsigned, TZerofill, TBin, TCharSet1, TCollat1,
          TNull, TNotNull1, TAutoInc, TUniq1, TPK1, TDesc1, TDef1, TDef2, TColForm1, TColForm2, TColForm3,
          TColStorage1, TColStorage2, TColStorage3], 'REFERENCES', [toOptional]);
    TRef1:=ACmd.AddSQLTokens(stIdentificator, TRef, '', [], 27 + TagBase);
    TRef1:=ACmd.AddSQLTokens(stSymbol, TRef1, '(', [], 132 + TagBase);
    TRef1:=ACmd.AddSQLTokens(stIdentificator, TRef1, '', [], 28 + TagBase);
      TRefSymb:=ACmd.AddSQLTokens(stSymbol, TRef1, ',', [], 6 + TagBase);
         TRefSymb.AddChildToken(TRef1);
    TRef1:=ACmd.AddSQLTokens(stSymbol, TRef1, ')', [], 32 + TagBase);
      TRef2:=ACmd.AddSQLTokens(stKeyword, TRef1, 'MATCH', []);
      TRef2_1:=ACmd.AddSQLTokens(stKeyword, TRef2, 'FULL', [], 29 + TagBase);
      TRef2_2:=ACmd.AddSQLTokens(stKeyword, TRef2, 'PARTIAL', [], 30 + TagBase);
      TRef2_3:=ACmd.AddSQLTokens(stKeyword, TRef2, 'SIMPLE', [], 31 + TagBase);
    TRef3:=ACmd.AddSQLTokens(stSymbol, [TRef1, TRef2_1, TRef2_2, TRef2_3], 'ON', []);
      TRef3_1:=ACmd.AddSQLTokens(stSymbol, TRef3, 'DELETE', [], 37 + TagBase);
      TRef3_2:=ACmd.AddSQLTokens(stSymbol, TRef3, 'UPDATE', [], 38 + TagBase);

      TRef3_3:=ACmd.AddSQLTokens(stSymbol, [TRef3_1, TRef3_2], 'RESTRICT', [], 33 + TagBase);
      TRef3_4:=ACmd.AddSQLTokens(stSymbol, [TRef3_1, TRef3_2], 'CASCADE', [], 34 + TagBase);
      TRef3_5:=ACmd.AddSQLTokens(stSymbol, [TRef3_1, TRef3_2], 'SET', []);
      TRef3_5:=ACmd.AddSQLTokens(stSymbol, TRef3_5, 'NULL', [], 35 + TagBase);
      TRef3_6:=ACmd.AddSQLTokens(stSymbol, [TRef3_1, TRef3_2], 'NO', []);
      TRef3_6:=ACmd.AddSQLTokens(stSymbol, TRef3_6, 'ACTION', [], 36 + TagBase);
      TRef3_3.AddChildToken(TRef2);
      TRef3_4.AddChildToken(TRef2);
      TRef3_5.AddChildToken(TRef2);
      TRef3_6.AddChildToken(TRef2);
  end;
  for i:=0 to Length(AEndTokens)-1 do
  begin
    TD1.AddChildToken(AEndTokens[i]);
    TD2.AddChildToken(AEndTokens[i]);
    TD3.AddChildToken(AEndTokens[i]);
    TD4.AddChildToken(AEndTokens[i]);
    TD5.AddChildToken(AEndTokens[i]);
    TD6.AddChildToken(AEndTokens[i]);
    TD7.AddChildToken(AEndTokens[i]);
    TD8.AddChildToken(AEndTokens[i]);
    TD9.AddChildToken(AEndTokens[i]);
    TD10.AddChildToken(AEndTokens[i]);
    TD11.AddChildToken(AEndTokens[i]);
    TD12.AddChildToken(AEndTokens[i]);
    TD13.AddChildToken(AEndTokens[i]);
    TD14.AddChildToken(AEndTokens[i]);
    TD15.AddChildToken(AEndTokens[i]);
    TD16.AddChildToken(AEndTokens[i]);
    TD17.AddChildToken(AEndTokens[i]);
    TD18.AddChildToken(AEndTokens[i]);
    TD19.AddChildToken(AEndTokens[i]);
    TD20.AddChildToken(AEndTokens[i]);
    TD21.AddChildToken(AEndTokens[i]);
    TD22.AddChildToken(AEndTokens[i]);
    TD23.AddChildToken(AEndTokens[i]);

    TD26.AddChildToken(AEndTokens[i]);
    TD27.AddChildToken(AEndTokens[i]);
    TD28.AddChildToken(AEndTokens[i]);
    TD29.AddChildToken(AEndTokens[i]);
    TD30.AddChildToken(AEndTokens[i]);
    TD31.AddChildToken(AEndTokens[i]);
    TD32.AddChildToken(AEndTokens[i]);
    TD33.AddChildToken(AEndTokens[i]);

    TD24_5.AddChildToken(AEndTokens[i]);
    TDLen1_2.AddChildToken(AEndTokens[i]);
    TDLen2_2.AddChildToken(AEndTokens[i]);
    TDLen3_3.AddChildToken(AEndTokens[i]);
    TDLen4_3.AddChildToken(AEndTokens[i]);
    TDLen5_2.AddChildToken(AEndTokens[i]);
    TUnsigned.AddChildToken(AEndTokens[i]);
    TZerofill.AddChildToken(AEndTokens[i]);
    TBin.AddChildToken(AEndTokens[i]);
    TCharSet1.AddChildToken(AEndTokens[i]);

    if AMode = tdfTableColDef then
    begin
      TCollat1.AddChildToken(AEndTokens[i]);
      TNull.AddChildToken(AEndTokens[i]);
      TNotNull1.AddChildToken(AEndTokens[i]);
      TAutoInc.AddChildToken(AEndTokens[i]);
      TUniq.AddChildToken(AEndTokens[i]);
      TUniq1.AddChildToken(AEndTokens[i]);
      TPK1.AddChildToken(AEndTokens[i]);
      TDesc1.AddChildToken(AEndTokens[i]);
      TDef1.AddChildToken(AEndTokens[i]);
      TDef2.AddChildToken(AEndTokens[i]);
      TColForm1.AddChildToken(AEndTokens[i]);
      TColForm2.AddChildToken(AEndTokens[i]);
      TColForm3.AddChildToken(AEndTokens[i]);
      TColStorage1.AddChildToken(AEndTokens[i]);
      TColStorage2.AddChildToken(AEndTokens[i]);
      TColStorage3.AddChildToken(AEndTokens[i]);
      TSymbAs.AddChildToken(AEndTokens[i]);
      TVirt1.AddChildToken(AEndTokens[i]);
      TVirt2.AddChildToken(AEndTokens[i]);
      TUniq2.AddChildToken(AEndTokens[i]);
      TUniq3.AddChildToken(AEndTokens[i]);
      TDesc3.AddChildToken(AEndTokens[i]);
      TPK3.AddChildToken(AEndTokens[i]);
      TNull1.AddChildToken(AEndTokens[i]);
      TNotNull3.AddChildToken(AEndTokens[i]);
      TRef1.AddChildToken(AEndTokens[i]);
      TRef2_1.AddChildToken(AEndTokens[i]);
      TRef2_2.AddChildToken(AEndTokens[i]);
      TRef2_3.AddChildToken(AEndTokens[i]);
      TRef3_3.AddChildToken(AEndTokens[i]);
      TRef3_4.AddChildToken(AEndTokens[i]);
      TRef3_5.AddChildToken(AEndTokens[i]);
      TRef3_6.AddChildToken(AEndTokens[i]);
    end;
  end;
end;

{ TMySQLRepairTable }

procedure TMySQLRepairTable.InitParserTree;
var
  FSQLTokens, T1, T2, TSymb: TSQLTokenRecord;
begin
  //REPAIR [NO_WRITE_TO_BINLOG | LOCAL]
  //  TABLE tbl_name [, tbl_name] ...
  //  [QUICK] [EXTENDED] [USE_FRM]
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'REPAIR', [toFirstToken]);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'NO_WRITE_TO_BINLOG', [toOptional], 1);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'LOCAL', [toOptional], 2);
  T1:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'TABLE', [toFindWordLast]);
  T2:=AddSQLTokens(stIdentificator, T1, '', [], 3);
  T1:=AddSQLTokens(stString, T1, '', [], 3);
    TSymb:=AddSQLTokens(stSymbol, [T1, T2], ',', []);
    TSymb.AddChildToken([T1, T2]);
  AddSQLTokens(stKeyword, [T1, T2], 'QUICK', [toOptional], 4);
  AddSQLTokens(stKeyword, [T1, T2], 'EXTENDED', [toOptional], 4);
  AddSQLTokens(stKeyword, [T1, T2], 'USE_FRM', [toOptional], 4);

    //  [QUICK] [EXTENDED] [USE_FRM]

end;

procedure TMySQLRepairTable.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    //1
    //2
    3:Tables.Add(AWord);
    4:Params.AddParam(AWord);
  end;
end;

procedure TMySQLRepairTable.MakeSQL;
var
  S: String;
begin
  S:='REPAIR '; //[NO_WRITE_TO_BINLOG | LOCAL]
  S:=S + 'TABLE ' + Tables.AsString;
  if Params.Count>0 then S:=S + ' ' + Params.AsString;
  AddSQLCommand(S);
end;

{ TMySQLRename }

procedure TMySQLRename.InitParserTree;
begin
  (*
  RENAME USER old_user TO new_user
      [, old_user TO new_user] ...
  *)

  (*
  RENAME TABLE
      tbl_name TO new_tbl_name
      [, tbl_name2 TO new_tbl_name2] ...
  *)
end;

procedure TMySQLRename.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TMySQLRename.MakeSQL;
begin
  inherited MakeSQL;
end;

{ TMySQLRevoke }

procedure TMySQLRevoke.InitParserTree;
begin
  (*
  REVOKE
      priv_type [(column_list)]
        [, priv_type [(column_list)]] ...
      ON [object_type] priv_level
      FROM user [, user] ...

  REVOKE ALL [PRIVILEGES], GRANT OPTION
      FROM user [, user] ...

  REVOKE PROXY ON user
      FROM user [, user] ...

      object_type: {
          TABLE
        | FUNCTION
        | PROCEDURE
      }

      priv_level: {
          *
        | *.*
        | db_name.*
        | db_name.tbl_name
        | tbl_name
        | db_name.routine_name
      }

      user:
          (see Section 6.2.3, “Specifying Account Names”)


  *)
  inherited InitParserTree;
  FSQLTokens.SQLCommand:='REVOKE';
  TTo.SQLCommand:='FROM';
end;

(*procedure TMySQLRevoke.MakeSQL;
begin
  S:='REVOKE'
end;*)

{ TMySQLGrant }

procedure TMySQLGrant.InitParserTree;
var
  T1, T1_1, T2, T2_1, T3, T3_1, T3_2, TSymb,
    T3_3, T3_4, T3_5, T4, T5, T6, T7, T8, T9, T10, T11, T11_1,
    T12, T13, T14, T15, T16, T16_1, T17, T17_1, T18, T19,
    T19_1, T21, T22, T23, T24, T25, T19_2, TOT1, TOT2, TOT3,
    TOT4, TOT4_1, TOT5, TOT5_1, TUser, TUser1, THost,
    THost1, TOn: TSQLTokenRecord;
begin
  (*
  GRANT
      priv_type [(column_list)]
        [, priv_type [(column_list)]] ...
      ON [object_type] priv_level
      TO user [auth_option] [, user [auth_option]] ...
      [REQUIRE {NONE | tls_option [[AND] tls_option] ...}]
      [WITH {GRANT OPTION | resource_option} ...]

  GRANT PROXY ON user
      TO user [, user] ...
      [WITH GRANT OPTION]

  object_type: {
      TABLE
    | FUNCTION
    | PROCEDURE
  }

  priv_level: {
      *
    | *.*
    | db_name.*
    | db_name.tbl_name
    | tbl_name
    | db_name.routine_name
  }

  user:
      (see Section 6.2.3, “Specifying Account Names”)

  auth_option: {
      IDENTIFIED BY 'auth_string'
    | IDENTIFIED WITH auth_plugin
    | IDENTIFIED WITH auth_plugin BY 'auth_string'
    | IDENTIFIED WITH auth_plugin AS 'hash_string'
    | IDENTIFIED BY PASSWORD 'hash_string'
  }

  tls_option: {
      SSL
    | X509
    | CIPHER 'cipher'
    | ISSUER 'issuer'
    | SUBJECT 'subject'
  }

  resource_option: {
    | MAX_QUERIES_PER_HOUR count
    | MAX_UPDATES_PER_HOUR count
    | MAX_CONNECTIONS_PER_HOUR count
    | MAX_USER_CONNECTIONS count
  }

  GRANT DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE VIEW, SHOW VIEW, TRIGGER ON TABLE `test23`.`test1` TO ''@'alexs.opt';
  *)

  (*
  ALL [PRIVILEGES] 	Grant all privileges at specified access level except GRANT OPTION and PROXY.
  ALTER 	Enable use of ALTER TABLE. Levels: Global, database, table.
  ALTER ROUTINE 	Enable stored routines to be altered or dropped. Levels: Global, database, routine.
  CREATE 	Enable database and table creation. Levels: Global, database, table.
  CREATE ROUTINE 	Enable stored routine creation. Levels: Global, database.
  CREATE TABLESPACE 	Enable tablespaces and log file groups to be created, altered, or dropped. Level: Global.
  CREATE TEMPORARY TABLES 	Enable use of CREATE TEMPORARY TABLE. Levels: Global, database.
  CREATE USER 	Enable use of CREATE USER, DROP USER, RENAME USER, and REVOKE ALL PRIVILEGES. Level: Global.
  CREATE VIEW 	Enable views to be created or altered. Levels: Global, database, table.
  DELETE 	Enable use of DELETE. Level: Global, database, table.
  DROP 	Enable databases, tables, and views to be dropped. Levels: Global, database, table.
  EVENT 	Enable use of events for the Event Scheduler. Levels: Global, database.
  EXECUTE 	Enable the user to execute stored routines. Levels: Global, database, routine.
  FILE 	Enable the user to cause the server to read or write files. Level: Global.
  GRANT OPTION 	Enable privileges to be granted to or removed from other accounts. Levels: Global, database, table, routine, proxy.
  INDEX 	Enable indexes to be created or dropped. Levels: Global, database, table.
  INSERT 	Enable use of INSERT. Levels: Global, database, table, column.
  LOCK TABLES 	Enable use of LOCK TABLES on tables for which you have the SELECT privilege. Levels: Global, database.
  PROCESS 	Enable the user to see all processes with SHOW PROCESSLIST. Level: Global.
  PROXY 	Enable user proxying. Level: From user to user.
  REFERENCES 	Enable foreign key creation. Levels: Global, database, table, column.
  RELOAD 	Enable use of FLUSH operations. Level: Global.
  REPLICATION CLIENT 	Enable the user to ask where master or slave servers are. Level: Global.
  REPLICATION SLAVE 	Enable replication slaves to read binary log events from the master. Level: Global.
  SELECT 	Enable use of SELECT. Levels: Global, database, table, column.
  SHOW DATABASES 	Enable SHOW DATABASES to show all databases. Level: Global.
  SHOW VIEW 	Enable use of SHOW CREATE VIEW. Levels: Global, database, table.
  SHUTDOWN 	Enable use of mysqladmin shutdown. Level: Global.
  SUPER 	Enable use of other administrative operations such as CHANGE MASTER TO, KILL, PURGE BINARY LOGS, SET GLOBAL, and mysqladmin debug command. Level: Global.
  TRIGGER 	Enable trigger operations. Levels: Global, database, table.
  UPDATE 	Enable use of UPDATE. Levels: Global, database, table, column.
  USAGE 	Synonym for “no privileges”  *)

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'GRANT', [toFirstToken, toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'ALL', [], 1);            //ALL [PRIVILEGES] 	 Grant all privileges at specified access level except GRANT OPTION and PROXY.
      T1_1:=AddSQLTokens(stKeyword, T1, 'PRIVILEGES', []);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'ALTER', [], 2);          //ALTER                    Enable use of ALTER TABLE. Levels: Global, database, table.
      T2_1:=AddSQLTokens(stKeyword, T2, 'ROUTINE', [], 3);            //ALTER ROUTINE            Enable stored routines to be altered or dropped. Levels: Global, database, routine.
    T3:=AddSQLTokens(stKeyword, FSQLTokens, 'CREATE', [], 4);         //CREATE                   Enable database and table creation. Levels: Global, database, table.
      T3_1:=AddSQLTokens(stKeyword, T3, 'ROUTINE', [], 5);            //CREATE ROUTINE           Enable stored routine creation. Levels: Global, database.
      T3_2:=AddSQLTokens(stKeyword, T3, 'TABLESPACE', [], 6);         //CREATE TABLESPACE        Enable tablespaces and log file groups to be created, altered, or dropped. Level: Global.
      T3_3:=AddSQLTokens(stKeyword, T3, 'TEMPORARY', []); 	      //CREATE TEMPORARY TABLES  Enable use of CREATE TEMPORARY TABLE. Levels: Global, database.
        T3_3:=AddSQLTokens(stKeyword, T3, 'TABLES', [], 7);
      T3_4:=AddSQLTokens(stKeyword, T3, 'USER', [], 8);               //CREATE USER              Enable use of CREATE USER, DROP USER, RENAME USER, and REVOKE ALL PRIVILEGES. Level: Global.
      T3_5:=AddSQLTokens(stKeyword, T3, 'VIEW', [], 9);               //CREATE VIEW              Enable views to be created or altered. Levels: Global, database, table.
    T4:=AddSQLTokens(stKeyword, FSQLTokens, 'DELETE', [], 10);        //DELETE                   Enable use of DELETE. Level: Global, database, table.
    T5:=AddSQLTokens(stKeyword, FSQLTokens, 'DROP', [], 11);          //DROP                     Enable databases, tables, and views to be dropped. Levels: Global, database, table.
    T6:=AddSQLTokens(stKeyword, FSQLTokens, 'EVENT', [], 12);         //EVENT                    Enable use of events for the Event Scheduler. Levels: Global, database.
    T7:=AddSQLTokens(stKeyword, FSQLTokens, 'EXECUTE', [], 13);       //EXECUTE                  Enable the user to execute stored routines. Levels: Global, database, routine.
    T8:=AddSQLTokens(stKeyword, FSQLTokens, 'FILE', [], 14);          //FILE                     Enable the user to cause the server to read or write files. Level: Global.

    T9:=AddSQLTokens(stKeyword, FSQLTokens, 'INDEX', [], 15);          //INDEX                   Enable indexes to be created or dropped. Levels: Global, database, table.
    T10:=AddSQLTokens(stKeyword, FSQLTokens, 'INSERT', [], 16);        //INSERT                  Enable use of INSERT. Levels: Global, database, table, column.
    T11:=AddSQLTokens(stKeyword, FSQLTokens, 'LOCK', []);              //LOCK TABLES             Enable use of LOCK TABLES on tables for which you have the SELECT privilege. Levels: Global, database.
      T11_1:=AddSQLTokens(stKeyword, T11, 'TABLES', [], 17);
    T12:=AddSQLTokens(stKeyword, FSQLTokens, 'PROCESS', [], 18);       //PROCESS                 Enable the user to see all processes with SHOW PROCESSLIST. Level: Global.
    T13:=AddSQLTokens(stKeyword, FSQLTokens, 'PROXY', [], 19);         //PROXY                   Enable user proxying. Level: From user to user.
    T14:=AddSQLTokens(stKeyword, FSQLTokens, 'REFERENCES', [], 20);    //REFERENCES              Enable foreign key creation. Levels: Global, database, table, column.
    T15:=AddSQLTokens(stKeyword, FSQLTokens, 'RELOAD', [], 21);        //RELOAD                  Enable use of FLUSH operations. Level: Global.
    T16:=AddSQLTokens(stKeyword, FSQLTokens, 'REPLICATION', []);       //REPLICATION CLIENT      Enable the user to ask where master or slave servers are. Level: Global.
      T16_1:=AddSQLTokens(stKeyword, T16, 'CLIENT', [], 22);
    T17:=AddSQLTokens(stKeyword, FSQLTokens, 'REPLICATION', []);       //REPLICATION SLAVE       Enable replication slaves to read binary log events from the master. Level: Global.
      T17_1:=AddSQLTokens(stKeyword, T17, 'SLAVE', [], 23);
    T18:=AddSQLTokens(stKeyword, FSQLTokens, 'SELECT', [], 24);        //SELECT                  Enable use of SELECT. Levels: Global, database, table, column.
    T19:=AddSQLTokens(stKeyword, FSQLTokens, 'SHOW', []);              //SHOW DATABASES          Enable SHOW DATABASES to show all databases. Level: Global.
      T19_1:=AddSQLTokens(stKeyword, T19, 'DATABASES', [], 25);
      T19_2:=AddSQLTokens(stKeyword, T19, 'VIEW', [], 26);
    T21:=AddSQLTokens(stKeyword, FSQLTokens, 'SHUTDOWN', [], 27);      //SHUTDOWN                Enable use of mysqladmin shutdown. Level: Global.
    T22:=AddSQLTokens(stKeyword, FSQLTokens, 'SUPER', [], 28);         //SUPER                   Enable use of other administrative operations such as CHANGE MASTER TO, KILL, PURGE BINARY LOGS, hiSET GLOBAL, and mysqladmin debug command. Level: Global.
    T23:=AddSQLTokens(stKeyword, FSQLTokens, 'TRIGGER', [], 29);       //TRIGGER                 Enable trigger operations. Levels: Global, database, table.
    T24:=AddSQLTokens(stKeyword, FSQLTokens, 'UPDATE', [], 30);        //UPDATE                  Enable use of UPDATE. Levels: Global, database, table, column.
    T25:=AddSQLTokens(stKeyword, FSQLTokens, 'USAGE', [], 31);         //USAGE                   Synonym for “no privileges”

  TSymb:=AddSQLTokens(stSymbol, [T1, T1_1, T2, T3, T3_1, T3_2, T3_4, T3_5, T4, T5, T6, T7, T8, T9, T10, T11, T11_1, T12,
     T13, T14, T15, T16, T16_1, T17, T17_1, T18, T19, T19_1, T19_2, T21, T22, T23, T24, T25], ',', [], 99);
    TSymb.AddChildToken([T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19,
      T21, T22, T23, T24, T25]);

  TOn:=AddSQLTokens(stKeyword, [T1, T1_1, T2, T3, T3_1, T3_2, T3_4, T3_5, T4, T5, T6, T7, T8, T9, T10, T11, T11_1, T12,
     T13, T14, T15, T16, T16_1, T17, T17_1, T18, T19, T19_1, T19_2, T21, T22, T23, T24, T25], 'ON', [], 98);

  TOT1:=AddSQLTokens(stKeyword, TOn, 'TABLE', [], 97);
  TOT2:=AddSQLTokens(stKeyword, TOn, 'FUNCTION', [], 96);
  TOT3:=AddSQLTokens(stKeyword, TOn, 'PROCEDURE', [], 95);

  TOT4:=AddSQLTokens(stSymbol, [TOn, TOT1, TOT2, TOT3], '*', [], 94);
  TOT4_1:=AddSQLTokens(stIdentificator, [TOn, TOT1, TOT2, TOT3], '', [], 94);
  TSymb:=AddSQLTokens(stSymbol, [TOT4, TOT4_1], '.', [], 93);
  TOT5:=AddSQLTokens(stSymbol, TSymb, '*', [], 92);
  TOT5_1:=AddSQLTokens(stIdentificator, TSymb, '', [], 92);

  TTo:=AddSQLTokens(stKeyword, [TOT4, TOT4_1, TOT5, TOT5_1], 'TO', [], 91);

  TUser:=AddSQLTokens(stIdentificator, TTo, '', [], 90);
  TUser1:=AddSQLTokens(stString, TTo, '', [], 90);
    TSymb:=AddSQLTokens(stSymbol, [TUser, TUser1], '@', [], 88);
  THost:=AddSQLTokens(stIdentificator, TSymb, '', [], 87);
  THost1:=AddSQLTokens(stString, TSymb, '', [], 87);

  TSymb:=AddSQLTokens(stSymbol, [TUser, TUser1, THost, THost1], ',', [toOptional], 85);
    TSymb.AddChildToken([TUser, TUser1]);

(*
  TO user [auth_option] [, user [auth_option]] ...
  [REQUIRE {NONE | tls_option [[AND] tls_option] ...}]
  [WITH {GRANT OPTION | resource_option} ...]

  priv_level: {
      *
    | *.*
    | db_name.*
    | db_name.tbl_name
    | tbl_name
    | db_name.routine_name
  }

  GRANT OPTION 	Enable privileges to be granted to or removed from other accounts. Levels: Global, database, table, routine, proxy.
  *)

end;

procedure TMySQLGrant.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FCurOG:=ogAll;
    2:FCurOG:=ogAlter;
    3:FCurOG:=ogAlterRoutine;
    4:FCurOG:=ogCreate;
    5:FCurOG:=ogCreateRoutine;
    6:FCurOG:=ogCreateTablespace;
    7:FCurOG:=ogTemporary;
    8:FCurOG:=ogCreateUser;
    9:FCurOG:=ogCreateView;
    10:FCurOG:=ogDelete;
    11:FCurOG:=ogDrop;
    12:FCurOG:=ogEvent;
    13:FCurOG:=ogExecute;
    14:FCurOG:=ogFile;
    15:FCurOG:=ogIndex;
    16:FCurOG:=ogInsert;
    17:FCurOG:=ogLockTables;
    18:FCurOG:=ogProcess;
    19:FCurOG:=ogProxy;
    20:FCurOG:=ogReference;
    21:FCurOG:=ogReload;
    22:FCurOG:=ogReplicationClient;
    23:FCurOG:=ogReplicationSlave;
    24:FCurOG:=ogSelect;
    25:FCurOG:=ogShowDatabases;
    26:FCurOG:=ogShowView;
    27:FCurOG:=ogShutdown;
    28:FCurOG:=ogSuper;
    29:FCurOG:=ogTrigger;
    30:FCurOG:=ogUpdate;
    31:FCurOG:=ogUsage;

    99,
    98:GrantTypes:=GrantTypes + [FCurOG];
    97:FCurObj:=Tables.Add('', okTable);
    96:FCurObj:=Tables.Add('', okFunction);
    95:FCurObj:=Tables.Add('', okStoredProc);
    94:begin
         if not Assigned(FCurObj) then
           FCurObj:=Tables.Add(AWord, okNone)
         else
           FCurObj.Name:=AWord;
      end;
    92:if Assigned(FCurObj) then
       FCurObj.Name:=FCurObj.Name + '.'+AWord;

    90:FCurUsr:=Params.AddParamEx(AWord, '');
    87:if Assigned(FCurUsr) then
        FCurUsr.ParamValue:=AWord;
  end;
end;

procedure TMySQLGrant.MakeSQL;
var
  S, S1: String;
  G: TObjectGrant;
  P: TSQLParserField;
  GO: TTableItem;
begin
  S:=FSQLTokens.SQLCommand + ' ';

  S1:='';
  if ogAll in GrantTypes then
    S1:=MySQLObjectGrantNames[ogAll]
  else
  for G in GrantTypes do
  begin
    if not (G in [ogWGO, ogAll]) then
    begin
      if S1<>'' then S1:=S1+ ', ';
      S1:=S1 + MySQLObjectGrantNames[G];
    end;
  end;
  S:=S+S1 + ' ON ';

  S1:='';
  for GO in Tables do
  begin
    if S1<>'' then S1:=S1 +', ';
    case GO.ObjectKind of
      okTable:S1:=S1 + 'TABLE ';
      okFunction:S1:=S1 + 'FUNCTION ';
      okStoredProc:S1:=S1 + 'PROCEDURE ';
    end;
    S1:=S1+Go.Name;
  end;

  S:=S+S1 + ' '+TTo.SQLCommand+' ';

  S1:='';
  for P in Params do
  begin
    if S1<>'' then S1:=S1 + ', ';
    S1:=S1 + P.Caption;
    if P.ParamValue <> '' then
      S1:=S1 + '@' + P.ParamValue;
  end;
  S:=S + S1;
  AddSQLCommand(S);
end;

{ TMySQLFlush }

procedure TMySQLFlush.InitParserTree;
var
  FSQLTokens, T1, T2, TF1, TF1_1, TF2, TF3, TF3_1, TF4, TF4_1,
    TF5, TF5_1, TF6, TF7, TF8, TF9, TF10, TF10_1, TF11, TF11_1,
    TF11_2, TF12, TF12_1, TF13, TF14, TSymb: TSQLTokenRecord;
begin
  (*
  FLUSH [NO_WRITE_TO_BINLOG | LOCAL] {
      flush_option [, flush_option] ...
    | tables_option
  }

  flush_option: {
      BINARY LOGS
    | DES_KEY_FILE
    | ENGINE LOGS
    | ERROR LOGS
    | GENERAL LOGS
    | HOSTS
    | LOGS
    | PRIVILEGES
    | OPTIMIZER_COSTS
    | QUERY CACHE
    | RELAY LOGS [FOR CHANNEL channel]
    | SLOW LOGS
    | STATUS
    | USER_RESOURCES
  }

  tables_option: {
      TABLES
    | TABLES tbl_name [, tbl_name] ...
    | TABLES WITH READ LOCK
    | TABLES tbl_name [, tbl_name] ... WITH READ LOCK
    | TABLES tbl_name [, tbl_name] ... FOR EXPORT
  }
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'FLUSH', [toFirstToken, toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'NO_WRITE_TO_BINLOG', [], 1);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'LOCAL', [], 2);

  TF1:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'BINARY', [], 10);
    TF1_1:=AddSQLTokens(stKeyword, TF1, 'LOGS', []);
  TF2:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'DES_KEY_FILE', [], 10);
  TF3:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'ENGINE', [], 11);
    TF3_1:=AddSQLTokens(stKeyword, TF3, 'LOGS', []);
  TF4:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'ERROR', [], 12);
    TF4_1:=AddSQLTokens(stKeyword, TF4, 'LOGS', []);
  TF5:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'GENERAL', [], 13);
    TF5_1:=AddSQLTokens(stKeyword, TF5, 'LOGS', []);
  TF6:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'HOSTS', [], 14);
  TF7:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'LOGS', [], 15);
  TF8:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'PRIVILEGES', [], 16);
  TF9:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'OPTIMIZER_COSTS', [], 17);
  TF10:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'QUERY', [], 18);
    TF10_1:=AddSQLTokens(stKeyword, TF10, 'CACHE', []);
  TF11:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'RELAY', [], 19);
    TF11_1:=AddSQLTokens(stKeyword, TF11, 'LOGS', []);
      TF11_2:=AddSQLTokens(stKeyword, TF11_1, 'FOR', []);
      TF11_2:=AddSQLTokens(stKeyword, TF11_2, 'CHANNEL', []);
      TF11_2:=AddSQLTokens(stIdentificator, TF11_2, '', [], 20);
  TF12:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'SLOW', [], 21);
    TF12_1:=AddSQLTokens(stKeyword, TF12, 'LOGS', []);
  TF13:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'STATUS', [], 22);
  TF14:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'USER_RESOURCES', [], 23);

  TSymb:=AddSQLTokens(stSymbol, [TF1_1, TF2, TF3_1, TF4_1, TF5_1, TF6, TF7, TF8, TF9, TF10_1, TF11_1, TF11_2, TF12_1, TF13, TF14], ',', [toOptional], 30);
    TSymb.AddChildToken([TF1, TF2, TF3, TF4, TF5, TF6, TF7, TF8, TF9, TF10, TF11, TF12, TF13, TF14]);
end;

procedure TMySQLFlush.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FlushLogMode:=mysqlflmNO_WRITE_TO_BINLOG;
    2:FlushLogMode:=mysqlflmLOCAL;
    10:FCurItem:=Params.AddParam('BINARY LOGS');
    16:FCurItem:=Params.AddParam('PRIVILEGES');
    30:FCurItem:=nil;
  end;
(*

| DES_KEY_FILE
| ENGINE LOGS
| ERROR LOGS
| GENERAL LOGS
| HOSTS
| LOGS
|
| OPTIMIZER_COSTS
| QUERY CACHE
| RELAY LOGS [FOR CHANNEL channel]
| SLOW LOGS
| STATUS
| USER_RESOURCES
*)
end;

procedure TMySQLFlush.MakeSQL;
var
  S, S1: String;
begin
  S:='FLUSH ';

  case FlushLogMode of
    mysqlflmNO_WRITE_TO_BINLOG:S:=S + 'NO_WRITE_TO_BINLOG ';
    mysqlflmLOCAL:S:=S+'LOCAL ';
  end;

  S1:=Params.AsString;

  (*
  FLUSH [NO_WRITE_TO_BINLOG | LOCAL] {
      flush_option [, flush_option] ...
    | tables_option
  }

  flush_option: {
      BINARY LOGS
    | DES_KEY_FILE
    | ENGINE LOGS
    | ERROR LOGS
    | GENERAL LOGS
    | HOSTS
    | LOGS
    | PRIVILEGES
    | OPTIMIZER_COSTS
    | QUERY CACHE
    | RELAY LOGS [FOR CHANNEL channel]
    | SLOW LOGS
    | STATUS
    | USER_RESOURCES
  }

  tables_option: {
      TABLES
    | TABLES tbl_name [, tbl_name] ...
    | TABLES WITH READ LOCK
    | TABLES tbl_name [, tbl_name] ... WITH READ LOCK
    | TABLES tbl_name [, tbl_name] ... FOR EXPORT
  }
  *)
  AddSQLCommand(S + S1);
end;

procedure TMySQLFlush.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TMySQLFlush then
  begin
    FlushLogMode:=TMySQLFlush(ASource).FlushLogMode;

  end;
  inherited Assign(ASource);
end;

{ TMySQLSHOW }

constructor TMySQLSHOW.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSelectable:=true;
end;

procedure TMySQLSHOW.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TMySQLSHOW then
  begin
    LikeStr:=TMySQLSHOW(ASource).LikeStr;
    Where:=TMySQLSHOW(ASource).Where;
    Full:=TMySQLSHOW(ASource).Full;
    ShowCommand:=TMySQLSHOW(ASource).ShowCommand;
    SetScope:=TMySQLSHOW(ASource).SetScope;
  end;
  inherited Assign(ASource);
end;

procedure TMySQLSHOW.InitParserTree;
var
  FSQLTokens, T1, T2, TLike, TWhere, T3, TFull, T2_1, T2_2, TG,
    TS: TSQLTokenRecord;
begin
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'SHOW', [toFirstToken]);

  TLike:=AddSQLTokens(stKeyword, nil, 'LIKE', [toOptional]);
    T1:=AddSQLTokens(stString, TLike, '', [], 200);
  TWhere:=AddSQLTokens(stKeyword, nil, 'WHERE', [toOptional], 201);

  TFull:=AddSQLTokens(stKeyword, FSQLTokens, 'FULL', [], 17);

  T1:=AddSQLTokens(stKeyword, FSQLTokens, 'AUTHORS', [toFindWordLast], 1);
  T1:=AddSQLTokens(stKeyword, FSQLTokens, 'CONTRIBUTORS', [toFindWordLast], 2);

  T1:=AddSQLTokens(stKeyword, FSQLTokens, 'CREATE', []);
    T2:=AddSQLTokens(stKeyword, T1, 'TABLE', [toFindWordLast], 3);
      T3:=AddSQLTokens(stIdentificator, T2, '', [], 4);
    T2:=AddSQLTokens(stKeyword, T1, 'DATABASE', [toFindWordLast], 7);
      T3.AddChildToken(T2);
    T2:=AddSQLTokens(stKeyword, [T1, TFull], 'EVENT', [toFindWordLast], 8);
      T3.AddChildToken(T2);
    T2:=AddSQLTokens(stKeyword, T1, 'PROCEDURE', [toFindWordLast], 9);
      T3.AddChildToken(T2);
    T2:=AddSQLTokens(stKeyword, T1, 'TRIGGER', [toFindWordLast], 10);
      T3.AddChildToken(T2);
    T2:=AddSQLTokens(stKeyword, T1, 'VIEW', [toFindWordLast], 11);
      T3.AddChildToken(T2);



  T1:=AddSQLTokens(stKeyword, [FSQLTokens, TFull], 'COLUMNS', [toFindWordLast], 18);  //SHOW [FULL] COLUMNS FROM tbl_name [FROM db_name] [like_or_where]
    T1:=AddSQLTokens(stKeyword, T1, 'FROM', []);  //SHOW [FULL] COLUMNS FROM tbl_name [FROM db_name] [like_or_where]
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 4);  //SHOW [FULL] COLUMNS FROM tbl_name [FROM db_name] [like_or_where]

  T1:=AddSQLTokens(stKeyword, FSQLTokens, 'DATABASES', [toFindWordLast], 16);  //SHOW DATABASES [like_or_where]

  T1:=AddSQLTokens(stKeyword, FSQLTokens, 'ENGINE', [toFindWordLast]);  //SHOW ENGINE engine_name {STATUS | MUTEX}
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 20);
    AddSQLTokens(stKeyword, T1, 'STATUS', [toOptional], 21);
    AddSQLTokens(stKeyword, T1, 'MUTEX', [toOptional], 21);

  (*
    SHOW [STORAGE] ENGINES
    SHOW ERRORS [LIMIT [offset,] row_count]
    SHOW [FULL] EVENTS
    SHOW FUNCTION CODE func_name
    SHOW FUNCTION STATUS [like_or_where]
*)

    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'GRANTS', [toFindWordLast]);  //SHOW GRANTS FOR user
    T1:=AddSQLTokens(stKeyword, T1, 'FOR', []);
      T2_1:=AddSQLTokens(stIdentificator, T1, '', [], 19);
      T2_2:=AddSQLTokens(stString, T1, '', [], 19);
      T3:=AddSQLTokens(stSymbol, [T2_1, T2_2], '@', [], 19);
        AddSQLTokens(stIdentificator, T3, '', [], 19);
        AddSQLTokens(stString, T3, '', [], 19);
(*
    SHOW INNODB STATUS
    SHOW OPEN TABLES [FROM db_name] [like_or_where]
    SHOW PROCEDURE CODE proc_name
    SHOW PROCEDURE STATUS [like_or_where] *)
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'FULL', [], 12);
    T1:=AddSQLTokens(stKeyword, [T1, FSQLTokens], 'PROCESSLIST', [toFindWordLast], 13);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'PRIVILEGES', [toFindWordLast], 14);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'PLUGINS', [toFindWordLast], 15);

(*    SHOW PROFILE [types] [FOR QUERY n] [OFFSET n] [LIMIT n]
    SHOW PROFILES
    SHOW WARNINGS [LIMIT [offset,] row_count]
*)
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'CHARACTER', []);
    T1:=AddSQLTokens(stKeyword, T1, 'SET', [toFindWordLast], 5);
      T1.AddChildToken([TLike, TWhere]);

    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'COLLATION', [toFindWordLast], 6);
      T1.AddChildToken([TLike, TWhere]);

    TG:=AddSQLTokens(stKeyword, FSQLTokens, 'GLOBAL', [], 22);
    TS:=AddSQLTokens(stKeyword, FSQLTokens, 'SESSION', [], 23);

    T1:=AddSQLTokens(stKeyword, [FSQLTokens, TG, TS], 'STATUS', [toFindWordLast], 24); //SHOW [GLOBAL | SESSION] STATUS [like_or_where]
    T1:=AddSQLTokens(stKeyword, [FSQLTokens, TG, TS], 'VARIABLES', [toFindWordLast], 25); //SHOW [GLOBAL | SESSION] VARIABLES [like_or_where]


  T1:=AddSQLTokens(stKeyword, FSQLTokens, 'TABLE', [toFindWordLast]); //SHOW TABLE STATUS [FROM db_name] [like_or_where]
  T1:=AddSQLTokens(stKeyword, T1, 'STATUS', [], 26);
  T1:=AddSQLTokens(stKeyword, T1, 'WHERE', [toOptional], 27);

  T1:=AddSQLTokens(stKeyword, FSQLTokens, 'INDEX', [toFindWordLast]); //SHOW INDEX FROM tbl_name [FROM db_name]
  T1:=AddSQLTokens(stKeyword, T1, 'FROM', []);
  T1:=AddSQLTokens(stIdentificator, T1, '', [], 28);
  T1:=AddSQLTokens(stKeyword, T1, 'FROM', [toOptional]);
  T1:=AddSQLTokens(stIdentificator, T1, '', [], 29);

  T1:=AddSQLTokens(stKeyword, FSQLTokens, 'TRIGGERS', [toFindWordLast], 30); //SHOW TRIGGERS [FROM db_name] [like_or_where]
    T2:=AddSQLTokens(stKeyword, T1, 'FROM', [toOptional]);
    T2:=AddSQLTokens(stIdentificator, T2, '', [], 29);

    T3:=AddSQLTokens(stKeyword, [T1, T2], 'WHERE', [toOptional], 27);

(*
    SHOW COLUMNS
    SHOW DATABASES
    SHOW FUNCTION STATUS
    SHOW INDEX
    SHOW OPEN TABLES
    SHOW PROCEDURE STATUS
    SHOW STATUS
    SHOW TABLES
    SHOW TRIGGERS
    SHOW VARIABLES

    like_or_where:
        LIKE 'pattern'
      | WHERE expr



         SHOW AUTHORS
         SHOW CHARACTER SET [like_or_where]
         SHOW COLLATION [like_or_where]
         SHOW [FULL] COLUMNS FROM tbl_name [FROM db_name] [like_or_where]
         SHOW CONTRIBUTORS
          SHOW CREATE DATABASE db_name
          SHOW CREATE EVENT event_name
          SHOW CREATE PROCEDURE proc_name
          SHOW CREATE TABLE tbl_name
          SHOW CREATE TRIGGER trigger_name
          SHOW CREATE VIEW view_name
          SHOW DATABASES [like_or_where]
          SHOW ENGINE engine_name {STATUS | MUTEX}
          SHOW [STORAGE] ENGINES
          SHOW ERRORS [LIMIT [offset,] row_count]
          SHOW [FULL] EVENTS
          SHOW FUNCTION CODE func_name
          SHOW FUNCTION STATUS [like_or_where]
          SHOW GRANTS FOR user
          SHOW INNODB STATUS
          SHOW OPEN TABLES [FROM db_name] [like_or_where]
          SHOW PLUGINS
          SHOW PROCEDURE CODE proc_name
          SHOW PROCEDURE STATUS [like_or_where]
          SHOW PRIVILEGES
          SHOW [FULL] PROCESSLIST
          SHOW PROFILE [types] [FOR QUERY n] [OFFSET n] [LIMIT n]
          SHOW PROFILES
          SHOW [GLOBAL | SESSION] STATUS [like_or_where]
          SHOW TABLES [FROM db_name] [like_or_where]
          SHOW [GLOBAL | SESSION] VARIABLES [like_or_where]
          SHOW WARNINGS [LIMIT [offset,] row_count]

          SHOW CHARACTER SET
          SHOW COLLATION
          SHOW COLUMNS
          SHOW DATABASES
          SHOW FUNCTION STATUS
          SHOW INDEX
          SHOW OPEN TABLES
          SHOW PROCEDURE STATUS
          SHOW STATUS
          SHOW TABLES
          SHOW VARIABLES

    *)
end;

procedure TMySQLSHOW.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
var
  S: String;
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FShowCommand:=myShowAuthors;
    2:FShowCommand:=myShowContributors;
    3:FShowCommand:=myShowCreateTable;
    4:TableName:=AWord;
    5:FShowCommand:=myShowCharacterSET;
    6:FShowCommand:=myShowCollation;
    7:FShowCommand:=myShowCreateDatabase;
    8:FShowCommand:=myShowCreateEvent;
    9:FShowCommand:=myShowCreateProcedure;
    10:FShowCommand:=myShowCreateTrigger;
    11:FShowCommand:=myShowCreateView;
//    12:
    13:FShowCommand:=myShowProcesslist;
    14:FShowCommand:=myShowPrivileges;
    15:FShowCommand:=myShowPlugins;
    16:FShowCommand:=myShowDatabases;
    17:FFull:=true;
    18:FShowCommand:=myShowCollumnsFromTable;
    19:begin
         FShowCommand:=myShowGrantsForUser;
         if Params.Count = 0 then
           Params.AddParam(AWord)
         else
           Params[0].Caption:=Params[0].Caption + AWord;
       end;
    20:begin
         FShowCommand:=myShowEngine;
         Params.AddParam(AWord)
       end;
    21:Params.AddParam(AWord);
    22:FSetScope:=mssGlobal;
    23:FSetScope:=mssSession;
    24:begin
         FShowCommand:=myShowStatus;
         S:=ASQLParser.GetToCommandDelemiter;
         if S<>'' then
           Params.AddParam(S);
       end;
    25:begin
         FShowCommand:=myShowVariables;
         S:=ASQLParser.GetToCommandDelemiter;
         if S<>'' then
           Params.AddParam(S);
       end;
    26:FShowCommand:=myShowTableStatus;
    27:FWhere:=TrimLeft(ASQLParser.GetToCommandDelemiter);
    28:begin
         FShowCommand:=myShowIndex;
         TableName:=AWord;
       end;
    29:SchemaName:=AWord;
    30:FShowCommand:=myShowTriggers;
  end;
end;

procedure TMySQLSHOW.MakeSQL;

function DoLikeOrWhere:string;
begin
  if FLikeStr<>'' then Result:=' LIKE '+QuotedString(FLikeStr, '''')
  else
  if FWhere<>'' then Result:=' WHERE '+FWhere
  else
    Result:='';
end;

var
  S: String;
begin
  S:='';
  case FShowCommand of
    myShowAuthors:S:='SHOW AUTHORS';
    myShowContributors:S:='SHOW CONTRIBUTORS';
    myShowCreateTable:S:='SHOW CREATE TABLE '+TableName;
    myShowCreateDatabase:S:='SHOW DATABASE TABLE '+TableName;
    myShowCreateEvent:S:='SHOW CREATE EVENT '+TableName;
    myShowCreateProcedure:S:='SHOW CREATE PROCEDURE '+TableName;
    myShowCreateTrigger:S:='SHOW CREATE TRIGGER '+TableName;
    myShowCreateView:S:='SHOW CREATE VIEW '+TableName;
    myShowCharacterSET:S:='SHOW CHARACTER SET'+DoLikeOrWhere;
    myShowCollation:S:='SHOW COLLATION'+DoLikeOrWhere;
    myShowProcesslist:S:='SHOW PROCESSLIST'; //SHOW [FULL] PROCESSLIST
    myShowPrivileges:S:='SHOW PRIVILEGES';
    myShowPlugins:S:='SHOW PLUGINS';
    myShowDatabases:S:='SHOW DATABASES'; //SHOW DATABASES [like_or_where]
    myShowCollumnsFromTable:S:='SHOW FULL COLUMNS FROM '+TableName + DoLikeOrWhere;// [FROM db_name] [like_or_where]
    myShowGrantsForUser:if Params.Count>0 then S:='SHOW GRANTS FOR '+Params[0].Caption;
    myShowEngine:
      if Params.Count>0 then
      begin
        S:='SHOW ENGINE '+Params[0].Caption;
        if Params.Count>1 then S:=S + ' ' + Params[1].Caption;
      end;
    myShowStatus:
      begin
        S:='SHOW ';
        if FSetScope = mssSession then S:=S + 'SESSION '
        else
        if FSetScope = mssGlobal then S:=S + 'GLOBAL ';
        S:=S + 'STATUS';
        if Params.Count>0 then S:=S + Params[0].Caption
      end;
    myShowVariables:
      begin
        S:='SHOW ';
        if FSetScope = mssSession then S:=S + 'SESSION '
        else
        if FSetScope = mssGlobal then S:=S + 'GLOBAL ';
        S:=S + 'VARIABLES';
        if Params.Count>0 then S:=S + Params[0].Caption
      end;
    myShowTableStatus:S:='SHOW TABLE STATUS' + DoLikeOrWhere; // [FROM db_name] [like_or_where]';
    myShowIndex:begin
        S:='SHOW INDEX FROM '+TableName;
        if SchemaName <> '' then S:=S + ' FROM '+SchemaName;
      end;
    myShowTriggers:begin
        S:='SHOW TRIGGERS';
        if SchemaName <> '' then S:=S + ' FROM '+SchemaName;
        S:=S + DoLikeOrWhere;
      end;
  end;
  if S<>'' then
    AddSQLCommand(S);
  (*

      SHOW [STORAGE] ENGINES
      SHOW ERRORS [LIMIT [offset,] row_count]
      SHOW [FULL] EVENTS
      SHOW FUNCTION CODE func_name
      SHOW FUNCTION STATUS [like_or_where]
      SHOW GRANTS FOR user
      SHOW INNODB STATUS
      SHOW OPEN TABLES [FROM db_name] [like_or_where]
      SHOW PROCEDURE CODE proc_name
      SHOW PROCEDURE STATUS [like_or_where]


      SHOW PROFILE [types] [FOR QUERY n] [OFFSET n] [LIMIT n]
      SHOW PROFILES

      SHOW TABLES [FROM db_name] [like_or_where]
      SHOW WARNINGS [LIMIT [offset,] row_count]


      SHOW COLUMNS
      SHOW DATABASES
      SHOW FUNCTION STATUS

      SHOW OPEN TABLES
      SHOW PROCEDURE STATUS
      SHOW STATUS
      SHOW TABLE STATUS
      SHOW TABLES
      SHOW VARIABLES
      *)
end;

{ TMySQLDropUser }

procedure TMySQLDropUser.SetName(AValue: string);
begin
  inherited SetName(AValue);
  FName:=Copy2SymbDel(AValue, '@');
  Params.AddParamEx(FName, AValue);
end;

procedure TMySQLDropUser.InitParserTree;
var
  FSQLTokens, T, T1, T2, TSymb1, T3, T4, TSymb2: TSQLTokenRecord;
begin
  (*
  DROP USER user_name [, user_name] ...
  DROP USER [IF EXISTS] user_name [, user_name] ...
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'USER', [toFindWordLast]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'IF', []);
    T:=AddSQLTokens(stKeyword, T, 'EXISTS', [], -1);
  T1:=AddSQLTokens(stIdentificator, [FSQLTokens, T], '', [], 3);
  T2:=AddSQLTokens(stString, [FSQLTokens, T], '', [], 4);
  TSymb1:=AddSQLTokens(stSymbol, [T1, T2], '@', [toOptional]);
  T3:=AddSQLTokens(stIdentificator, TSymb1, '', [], 5);
  T4:=AddSQLTokens(stString, TSymb1, '', [], 6);

  TSymb2:=AddSQLTokens(stSymbol, [T1, T2, T3, T4], ',', [toOptional], 7);
    TSymb2.AddChildToken([T1, T2]);
end;

procedure TMySQLDropUser.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    3:FCurItem:=Params.AddParamEx(AWord, '');
    4:FCurItem:=Params.AddParamEx(ExtractQuotedString(AWord, ''''), '');
    5:if Assigned(FCurItem) then
      FCurItem.ParamValue:=AWord;
    6:if Assigned(FCurItem) then
      FCurItem.ParamValue:=ExtractQuotedString(AWord, '''');
    7:FCurItem:=nil;
  end;
end;

procedure TMySQLDropUser.MakeSQL;
var
  S, S1: String;
  P: TSQLParserField;
begin
  S:='DROP USER';
  if ooIfExists in Options then
    S:=S + ' IF EXISTS';

  S1:='';
  for P in Params do
  begin
    if S1<>'' then S1:=S1+','+LineEnding;
    S1:=S1 + ' ' + QuotedString(P.Caption, '''');
    if P.ParamValue <>'' then
      S1:=S1+'@' + QuotedString(P.ParamValue, '''');
  end;
  AddSQLCommand(S+S1);
end;

{ TMySQLAlterUser }

procedure TMySQLAlterUser.InitParserTree;
begin
  (*
  ALTER USER [IF EXISTS]
   user_specification [,user_specification] ...
    [REQUIRE {NONE | tls_option [[AND] tls_option] ...}]
    [WITH resource_option [resource_option] ...]

  user_specification:
    username [authentication_option]

  authentication_option
    IDENTIFIED BY 'authentication_string'
    | IDENTIFIED BY PASSWORD 'hash_string'
    | IDENTIFIED {VIA|WITH} authentication_plugin
    | IDENTIFIED {VIA|WITH} authentication_plugin BY 'authentication_string'
    | IDENTIFIED {VIA|WITH} authentication_plugin {USING|AS} 'hash_string'

  tls_option
    SSL
    | X509
    | CIPHER 'cipher'
    | ISSUER 'issuer'
    | SUBJECT 'subject'

  resource_option
    MAX_QUERIES_PER_HOUR count
    | MAX_UPDATES_PER_HOUR count
    | MAX_CONNECTIONS_PER_HOUR count
    | MAX_USER_CONNECTIONS count
  *)
end;

procedure TMySQLAlterUser.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TMySQLAlterUser.MakeSQL;
begin
  inherited MakeSQL;
end;

{ TMySQLCreateUser }

procedure TMySQLCreateUser.InitParserTree;
var
  FSQLTokens, T, TUser1, TUser2, THost2, THost1, TIdent,
    TIdentBy, TPwd, TSymb, TWith, TWith1, TWith1C, TWith2,
    TWith2C, TWith3, TWith3C, TWith4, TWith4C, TIdentVIA,
    TIdentWITH, TIdentAuthPlugin, TIdentAuthPluginBy: TSQLTokenRecord;
begin
  (*
  CREATE [OR REPLACE] USER [IF NOT EXISTS]
   user_specification [,user_specification] ...
    [REQUIRE {NONE | tls_option [[AND] tls_option] ...}]
    [WITH resource_option [resource_option] ...]

  user_specification:
    username [authentication_option]

  authentication_option:
    IDENTIFIED BY 'authentication_string'
    | IDENTIFIED BY PASSWORD 'hash_string'
    | IDENTIFIED {VIA|WITH} authentication_plugin
    | IDENTIFIED {VIA|WITH} authentication_plugin BY 'authentication_string'
    | IDENTIFIED {VIA|WITH} authentication_plugin {USING|AS} 'hash_string'

  tls_option:
    SSL
    | X509
    | CIPHER 'cipher'
    | ISSUER 'issuer'
    | SUBJECT 'subject'

  resource_option:
    MAX_QUERIES_PER_HOUR count
    | MAX_UPDATE_PER_HOUR count
    | MAX_CONNECTIONS_PER_HOUR count
    | MAX_USER_CONNECTIONS count
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'OR', []);
    T:=AddSQLTokens(stKeyword, T, 'REPLACE', [], -2);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'USER', [toFindWordLast]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'IF', []);
    T:=AddSQLTokens(stKeyword, T, 'NOT', []);
    T:=AddSQLTokens(stKeyword, T, 'EXISTS', [], 2);

  TUser1:=AddSQLTokens(stString, [FSQLTokens, T], '', [], 3);
  TUser2:=AddSQLTokens(stIdentificator, [FSQLTokens, T], '', [], 3);
    T:=AddSQLTokens(stSymbol, [TUser1, TUser2], '@', []);
    THost1:=AddSQLTokens(stString, T, '', [], 4);
    THost2:=AddSQLTokens(stIdentificator, T, '', [], 4);

  TIdent:=AddSQLTokens(stKeyword, [TUser1, TUser2, THost1, THost2], 'IDENTIFIED', []);
    TIdentBy:=AddSQLTokens(stKeyword, TIdent, 'BY', []);
      T:=AddSQLTokens(stKeyword, TIdentBy, 'PASSWORD', [], 5);

    TIdentVIA:=AddSQLTokens(stKeyword, TIdent, 'VIA', [], 7);
    TIdentWITH:=AddSQLTokens(stKeyword, TIdent, 'WITH', [], 8);

    TIdentAuthPlugin:=AddSQLTokens(stIdentificator, [TIdentVIA, TIdentWITH], '', [], 9);
      TIdentAuthPluginBy:=AddSQLTokens(stKeyword, TIdentAuthPlugin, 'BY', [], 10);

    (*
    | IDENTIFIED {VIA|WITH} authentication_plugin
    | IDENTIFIED {VIA|WITH} authentication_plugin BY 'authentication_string'
    | IDENTIFIED {VIA|WITH} authentication_plugin {USING|AS} 'hash_string'
*)

  TPwd:=AddSQLTokens(stString, [TIdentBy, T, TIdentAuthPluginBy], '', [], 6);

  TSymb:=AddSQLTokens(stSymbol, [TPwd, TIdentAuthPlugin], ',', [toOptional]);
    TSymb.AddChildToken([TUser1, TUser2]);

(*
      IDENTIFIED BY 'authentication_string'
    | IDENTIFIED BY PASSWORD 'hash_string'
    | IDENTIFIED {VIA|WITH} authentication_plugin
    | IDENTIFIED {VIA|WITH} authentication_plugin BY 'authentication_string'
    | IDENTIFIED {VIA|WITH} authentication_plugin {USING|AS} 'hash_string'
*)


  TWith:=AddSQLTokens(stKeyword, [TPwd, TIdentAuthPlugin], 'WITH', [toOptional]);

  TWith1:=AddSQLTokens(stKeyword, TWith, 'MAX_QUERIES_PER_HOUR', [toOptional]);
  TWith1C:=AddSQLTokens(stInteger, TWith1, '', [], 30);

  TWith2:=AddSQLTokens(stKeyword, TWith, 'MAX_UPDATE_PER_HOUR', [toOptional]);
  TWith2C:=AddSQLTokens(stInteger, TWith2, '', [], 31);

  TWith3:=AddSQLTokens(stKeyword, TWith, 'MAX_CONNECTIONS_PER_HOUR', [toOptional]);
  TWith3C:=AddSQLTokens(stInteger, TWith3, '', [], 32);

  TWith4:=AddSQLTokens(stKeyword, TWith, 'MAX_USER_CONNECTIONS', [toOptional]);
  TWith4C:=AddSQLTokens(stInteger, TWith4, '', [], 33);

  TWith1C.AddChildToken([TWith2, TWith3, TWith4]);
  TWith2C.AddChildToken([TWith1, TWith3, TWith4]);
  TWith3C.AddChildToken([TWith1, TWith2, TWith4]);
  TWith4C.AddChildToken([TWith1, TWith2, TWith3]);
end;

procedure TMySQLCreateUser.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    //1:CreateMode:=cmCreateOrAlter;
    2:Options:=Options + [ooIfNotExists];
    3:Name:=AWord;
    4:HostName:=AWord;
    5:IdentType:=msitIdentifiedByPwd;
    6:Password:=ExtractQuotedString(AWord, '''');

    7:IdentType:=msitIdentifiedViaAuthPlugin;
    8:IdentType:=msitIdentifiedWithAuthPlugin;
    9:AuthenticationPlugin:=AWord;
    10:
     begin
       if IdentType = msitIdentifiedViaAuthPlugin then
          IdentType:=msitIdentifiedViaAuthPluginByStr
       else
       if IdentType = msitIdentifiedWithAuthPlugin then
          IdentType:=msitIdentifiedWithAuthPluginByStr
     end;

    30:MaxQueriesPerHour:=StrToInt(AWord);
    31:MaxUpdatePerHour:=StrToInt(AWord);
    32:MaxConnectionsPerHour:=StrToInt(AWord);
    33:MaxUserConnections:=StrToInt(AWord);
  end;
end;

procedure TMySQLCreateUser.MakeSQL;
var
  S, S1: String;
begin
  inherited MakeSQL;
  (*
  CREATE [OR REPLACE] USER [IF NOT EXISTS]
   user_specification [,user_specification] ...
    [REQUIRE {NONE | tls_option [[AND] tls_option] ...}]
    [WITH resource_option [resource_option] ...]

  user_specification:
    username [authentication_option]

  authentication_option:
    IDENTIFIED BY 'authentication_string'
    | IDENTIFIED BY PASSWORD 'hash_string'
    | IDENTIFIED {VIA|WITH} authentication_plugin
    | IDENTIFIED {VIA|WITH} authentication_plugin BY 'authentication_string'
    | IDENTIFIED {VIA|WITH} authentication_plugin {USING|AS} 'hash_string'

  tls_option:
    SSL
    | X509
    | CIPHER 'cipher'
    | ISSUER 'issuer'
    | SUBJECT 'subject'

  resource_option:
    MAX_QUERIES_PER_HOUR count
    | MAX_UPDATE_PER_HOUR count
    | MAX_CONNECTIONS_PER_HOUR count
    | MAX_USER_CONNECTIONS count
  *)
  S:='CREATE ';
  if ooOrReplase in Options then
    S:=S + 'OR REPLACE ';
  S:=S + 'USER ' + Name;

  if FHostName <>'' then
    S:=S + '@'+HostName;

  S:=S + ' ';

  if ooIfNotExists in Options then
    S:=S + 'IF NOT EXISTS ';

  case IdentType of
    msitIdentifiedByAuthString:S:=S + 'IDENTIFIED BY '+QuotedString(Password, '''');
    msitIdentifiedByPwd:S:=S + 'IDENTIFIED BY PASSWORD ' + QuotedString(Password, '''');
    msitIdentifiedViaAuthPlugin:S:=S + 'IDENTIFIED VIA ' + AuthenticationPlugin;
    msitIdentifiedWithAuthPlugin:S:=S + 'IDENTIFIED WITH ' + AuthenticationPlugin;
    msitIdentifiedViaAuthPluginByStr:S:=S + 'IDENTIFIED VIA ' +AuthenticationPlugin + ' BY '+QuotedString(Password, '''');
    msitIdentifiedWithAuthPluginByStr:S:=S + 'IDENTIFIED WITH ' + AuthenticationPlugin + ' BY ' + QuotedString(Password, '''');
    msitIdentifiedViaAuthPluginUsingHashStr:S:=S + 'IDENTIFIED VIA ' + AuthenticationPlugin + ' USING ' + QuotedString(Password, '''');
    msitIdentifiedWithAuthPluginUsingHashStr:S:=S + 'IDENTIFIED WITH ' + AuthenticationPlugin + ' USING ' + QuotedString(Password, '''');
  end;

  S1:='';
  if MaxQueriesPerHour>0 then
    S1:=LineEnding + '  MAX_QUERIES_PER_HOUR ' + IntToStr(MaxQueriesPerHour);

  if MaxUpdatePerHour>0 then
    S1:=S1 + LineEnding + '  MAX_UPDATE_PER_HOUR ' + IntToStr(MaxUpdatePerHour);

  if MaxConnectionsPerHour > 0 then
    S1:=S1 + LineEnding + '  MAX_CONNECTIONS_PER_HOUR ' + IntToStr(MaxConnectionsPerHour);

  if MaxUserConnections > 0 then
    S1:=S1 + LineEnding + '  MAX_USER_CONNECTIONS ' + IntToStr(MaxUserConnections);

  if S1<>'' then
    S:=S + LineEnding + 'WITH' + S1;

  AddSQLCommand(S);
end;

procedure TMySQLCreateUser.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TMySQLCreateUser then
  begin
    IdentType:=TMySQLCreateUser(ASource).IdentType;
    HostName:=TMySQLCreateUser(ASource).HostName;
    AuthenticationPlugin:=TMySQLCreateUser(ASource).AuthenticationPlugin;
    UserOptions:=TMySQLCreateUser(ASource).UserOptions;
    MaxQueriesPerHour:=TMySQLCreateUser(ASource).MaxQueriesPerHour;
    MaxUpdatePerHour:=TMySQLCreateUser(ASource).MaxUpdatePerHour;
    MaxConnectionsPerHour:=TMySQLCreateUser(ASource).MaxConnectionsPerHour;
    MaxUserConnections:=TMySQLCreateUser(ASource).MaxUserConnections;
  end;
  inherited Assign(ASource);
end;

{ TMySQLDropServer }

procedure TMySQLDropServer.InitParserTree;
var
  FSQLTokens, T: TSQLTokenRecord;
begin
  (*
  DROP SERVER [ IF EXISTS ] server_name
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'SERVER', [toFindWordLast]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'IF', []);
    T:=AddSQLTokens(stKeyword, T, 'EXISTS', [], -1);
  T:=AddSQLTokens(stIdentificator, [FSQLTokens, T], '', [], 1);
end;

procedure TMySQLDropServer.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
  end;
end;

procedure TMySQLDropServer.MakeSQL;
var
  S: String;
begin
  S:='DROP SERVER ';
  if ooIfExists in Options then
    S:=S + 'IF EXISTS ';
  S:=S + FullName;
  AddSQLCommand(S);
end;

{ TMySQLAlterServer }

procedure TMySQLAlterServer.InitParserTree;
begin
  (*
  ALTER SERVER  server_name
      OPTIONS (option [, option] ...)
  *)
end;

procedure TMySQLAlterServer.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TMySQLAlterServer.MakeSQL;
begin
  inherited MakeSQL;
end;

{ TMySQLCreateServer }

procedure TMySQLCreateServer.InitParserTree;
begin
  (*
  CREATE SERVER server_name
      FOREIGN DATA WRAPPER wrapper_name
      OPTIONS (option [, option] ...)

  option:
    { HOST character-literal
    | DATABASE character-literal
    | USER character-literal
    | PASSWORD character-literal
    | SOCKET character-literal
    | OWNER character-literal
    | PORT numeric-literal }
  *)
end;

procedure TMySQLCreateServer.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TMySQLCreateServer.MakeSQL;
begin
  inherited MakeSQL;
end;

{ TMySQLCreateTablespace }

procedure TMySQLCreateTablespace.InitParserTree;
begin
  { TODO : Реализовать парсер CREATE Tablespace }
  (*
  CREATE TABLESPACE tablespace_name

    InnoDB and NDB:
      ADD DATAFILE 'file_name'

    InnoDB only:
      [FILE_BLOCK_SIZE = value]

    NDB only:
      USE LOGFILE GROUP logfile_group
      [EXTENT_SIZE [=] extent_size]
      [INITIAL_SIZE [=] initial_size]
      [AUTOEXTEND_SIZE [=] autoextend_size]
      [MAX_SIZE [=] max_size]
      [NODEGROUP [=] nodegroup_id]
      [WAIT]
      [COMMENT [=] comment_text]

    InnoDB and NDB:
      [ENGINE [=] engine_name]
  *)
end;

procedure TMySQLCreateTablespace.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; const AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TMySQLCreateTablespace.MakeSQL;
begin
  inherited MakeSQL;
end;

{ TMySQLAlterTablespace }

procedure TMySQLAlterTablespace.InitParserTree;
begin
  { TODO : Реализовать парсер Alter Tablespace }
  (*
  ALTER TABLESPACE tablespace_name
      {ADD|DROP} DATAFILE 'file_name'
      [INITIAL_SIZE [=] size]
      [WAIT]
      ENGINE [=] engine_name
  *)
end;

procedure TMySQLAlterTablespace.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; const AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TMySQLAlterTablespace.MakeSQL;
begin
  inherited MakeSQL;
end;

{ TMySQLDropTablespace }

procedure TMySQLDropTablespace.InitParserTree;
var
  FSQLTokens, T: TSQLTokenRecord;
begin
  (*
  DROP TABLESPACE tablespace_name
      [ENGINE [=] engine_name]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'TABLESPACE', [toFindWordLast]);
  FSQLTokens:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'ENGINE', [toOptional]);
    T:=AddSQLTokens(stSymbol, FSQLTokens, '=', []);
  FSQLTokens:=AddSQLTokens(stIdentificator, [T, FSQLTokens], '', [], 2);
end;

procedure TMySQLDropTablespace.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; const AWord: string);
begin
  case AChild.Tag of
    1:Name:=AWord;
    2:Engine:=AWord;
  end;
end;

procedure TMySQLDropTablespace.MakeSQL;
var
  S: String;
begin
  S:='DROP TABLESPACE '+FullName;
  if Engine <> '' then
    S:=S + ' ENGINE = '+Engine;
  AddSQLCommand(S);
end;

{ TMySQLSET }

procedure TMySQLSET.InitParserTree;
var
  FSQLTokens: TSQLTokenRecord;
begin
  (*
  SET {CHARACTER SET | CHARSET} {charset_name | DEFAULT}
  --
  SET variable_assignment [, variable_assignment] ...

  variable_assignment:
        user_var_name = expr
      | param_name = expr
      | local_var_name = expr
      | [GLOBAL | SESSION]
          system_var_name = expr
      | [@@global. | @@session. | @@]
          system_var_name = expr
  --
  SET NAMES {'charset_name' [COLLATE 'collation_name'] | DEFAULT}
  --
  SET PASSWORD syntax for MySQL 5.7.6 and higher:

 SET PASSWORD [FOR user] = password_option

 password_option: {
     PASSWORD('auth_string')
   | 'auth_string'
 }

 SET PASSWORD syntax before MySQL 5.7.6:

 SET PASSWORD [FOR user] = password_option

 password_option: {
     PASSWORD('auth_string')
   | OLD_PASSWORD('auth_string')
   | 'hash_string'
 }

  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'SET', [toFirstToken, toFindWordLast]);
end;

procedure TMySQLSET.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TMySQLSET.MakeSQL;
var
  S: String;
begin
  S:='SET';
  AddSQLCommand(S);
end;

{ TMySQLCreateTrigger }

procedure TMySQLCreateTrigger.OnProcessComment(Sender: TSQLParser;
  AComment: string);
begin
  Description:=Trim(AComment);
end;

procedure TMySQLCreateTrigger.InitParserTree;
var
  FSQLTokens, T1, T2, TT1, TName, TT2, T, TT3, TT4, TT5: TSQLTokenRecord;
begin
  (*
  CREATE
      [DEFINER = { user | CURRENT_USER }]
      TRIGGER trigger_name
      trigger_time trigger_event
      ON tbl_name FOR EACH ROW
      [trigger_order]
      trigger_body

  trigger_time: { BEFORE | AFTER }

  trigger_event: { INSERT | UPDATE | DELETE }

  trigger_order: { FOLLOWS | PRECEDES } other_trigger_name
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken]);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'DEFINER', []);
    T1:=AddSQLTokens(stSymbol, T1, '=', []);
    T2:=AddSQLTokens(stKeyword, T1, 'CURRENT_USER', [], 1);
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 1);
  T:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'TRIGGER', [toFindWordLast]);
  TName:=AddSQLTokens(stIdentificator, T, '', [], 2);
    TT1:=AddSQLTokens(stKeyword, TName, 'BEFORE', [], 3);
    TT2:=AddSQLTokens(stKeyword, TName, 'AFTER', [], 4);
    TT3:=AddSQLTokens(stKeyword, [TT1, TT2], 'INSERT', [], 5);
    TT4:=AddSQLTokens(stKeyword, [TT1, TT2], 'UPDATE', [], 6);
    TT5:=AddSQLTokens(stKeyword, [TT1, TT2], 'DELETE', [], 7);
  T:=AddSQLTokens(stKeyword, [TT3, TT4, TT5], 'ON', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 8);
  T:=AddSQLTokens(stKeyword, T, 'FOR', []);
  T:=AddSQLTokens(stKeyword, T, 'EACH', []);
  T:=AddSQLTokens(stKeyword, T, 'ROW', [], 12);
    T1:=AddSQLTokens(stKeyword, T, 'FOLLOWS', [toOptional], 9);
    T2:=AddSQLTokens(stKeyword, T, 'PRECEDES', [toOptional], 10);
    T1:=AddSQLTokens(stIdentificator, [T1, T2], '', [], 11);
(*
  ON tbl_name FOR EACH ROW
  [trigger_order]
  trigger_body

trigger_order: { FOLLOWS | PRECEDES } other_trigger_name
*)
end;

procedure TMySQLCreateTrigger.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);

function GetTriggerBody:string;
var
  S: String;
  V: TSQLCommandAbstract;
  C: Integer;
  CP, CP1: TParserPosition;
begin
  CP:=ASQLParser.Position;
  S:=ASQLParser.GetNextWord;
  if UpperCase(S ) = 'BEGIN' then
  begin
    C:=1;
    while not ASQLParser.Eof do
    begin
      CP1:=ASQLParser.Position;
      S:=UpperCase(ASQLParser.GetNextWord);
      if S = '(' then ASQLParser.GetToBracket(')')
      else
      if (S = 'BEGIN') or (S = 'CASE') or (S = 'IF') or (S = 'LOOP') or (S = 'REPEAT') or (S = 'WHILE') then Inc(c)
      else
      if (S = 'END') then
      begin
        Dec(C);
        CP1:=ASQLParser.Position;
        S:=UpperCase(ASQLParser.GetNextWord);
        if (S = 'CASE') and (S<>'IF') and (S = 'LOOP') and (S = 'REPEAT') and (S = 'WHILE') then
        begin
          ASQLParser.Position:=CP1;
        end;
      end;
      if C = 0 then
      begin
        ASQLParser.Position:=CP1;
        Break;
      end;
    end;
    Result:=Copy(ASQLParser.SQL, CP.Position, ASQLParser.Position.Position - CP.Position);
  end
  else
  begin
    ASQLParser.Position:=CP;
    Result:=ASQLParser.GetToCommandDelemiter;
    V:=GetNextSQLCommand(Result, ASQLParser.Owner);
    if not Assigned(V) then
    begin
      ASQLParser.Position:=CP;
      S:=ASQLParser.GetNextWord;
      SetError(ASQLParser, Format(sSqlParserUnknowCommand, [S]));
    end
    else
    begin
      V.Free;
      State:=cmsEndOfCmd;
    end;
  end;
  ASQLParser.OnProcessComment:=nil;
end;

var
  S: String;
  CP: TParserPosition;
begin
  case AChild.Tag of
    1:Definer:=AWord;
    2:Name:=AWord;
    3:TriggerType:=TriggerType + [ttBefore];
    4:TriggerType:=TriggerType + [ttAfter];
    5:TriggerType:=TriggerType + [ttInsert];
    6:TriggerType:=TriggerType + [ttUpdate];
    7:TriggerType:=TriggerType + [ttDelete];
    8:TableName:=AWord;
    9:TriggerOrder:=ttAfter;
    10:TriggerOrder:=ttBefore;
    11:begin
         TriggerOrderName:=AWord;
         ASQLParser.OnProcessComment:=@OnProcessComment;
         Body:=Trim(GetTriggerBody);
       end;
    12:begin
         CP:=ASQLParser.Position;
         S:=ASQLParser.GetNextWord;
         ASQLParser.Position:=CP;
         ASQLParser.OnProcessComment:=@OnProcessComment;
         if (CompareText(S, 'FOLLOWS')<>0) and (CompareText(S, 'PRECEDES')<>0) then
           Body:=Trim(GetTriggerBody)
       end;
  end;
end;

procedure TMySQLCreateTrigger.MakeSQL;
var
  S: String;
  FCmd: TMySQLDropTrigger;
begin
  if ooOrReplase in Options then
  begin
    FCmd:=TMySQLDropTrigger.Create(nil);
    FCmd.TableName:=TableName;
    FCmd.Name:=Name;
    AddSQLCommand(FCmd.AsSQL);
    FCmd.Free;
  end;

  S:='CREATE';
  if Definer <> '' then
    S:=S + ' DEFINER = ' + Definer;
  S:=S + ' TRIGGER '+FullName + LineEnding;
  if ttAfter in TriggerType then
    S:=S + ' AFTER'
  else
  if ttBefore in TriggerType then
    S:=S + ' BEFORE';

  if ttInsert in TriggerType then
    S:=S + ' INSERT'
  else
  if ttUpdate in TriggerType then
    S:=S + ' UPDATE'
  else
  if ttDelete in TriggerType then
    S:=S + ' DELETE';
  S:=S + ' ON ' + TableName + ' FOR EACH ROW ' + LineEnding;

  if TriggerOrder = ttBefore then
    S:=S + 'PRECEDES ' + TriggerOrderName + LineEnding
  else
  if TriggerOrder = ttAfter then
    S:=S + 'FOLLOWS ' + TriggerOrderName + LineEnding;

  if Description <> '' then
    S:=S + '/* '+Description+' */';
  S:=S + Body;

  AddSQLCommand(S);
end;

constructor TMySQLCreateTrigger.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okTrigger;
end;

procedure TMySQLCreateTrigger.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TMySQLCreateTrigger then
  begin
    Definer:=TMySQLCreateTrigger(ASource).Definer;
    TriggerOrder:=TMySQLCreateTrigger(ASource).TriggerOrder;
    TriggerOrderName:=TMySQLCreateTrigger(ASource).TriggerOrderName;

  end;
  inherited Assign(ASource);
end;

{ TMySQLDropTrigger }

procedure TMySQLDropTrigger.InitParserTree;
var
  FSQLTokens, T, T1: TSQLTokenRecord;
begin
  (*
  DROP TRIGGER [IF EXISTS] [schema_name.]trigger_name
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'TRIGGER', [toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, T, 'IF', []);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', [], -1);
  T:=AddSQLTokens(stIdentificator, [T, T1], '', [], 1);
  T:=AddSQLTokens(stSymbol, T, '.', [toOptional]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 2);
end;

procedure TMySQLDropTrigger.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
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

procedure TMySQLDropTrigger.MakeSQL;
var
  S: String;
begin
  S:='DROP TRIGGER';
  if ooIfExists in Options then
    S:=S + ' IF EXISTS';
  S:=S + ' ' + FullName;
  AddSQLCommand(S);
end;

{ TMySQLTruncateTable }

procedure TMySQLTruncateTable.InitParserTree;
var
  FSQLTokens, T: TSQLTokenRecord;
begin
  (*
  TRUNCATE [TABLE] tbl_name
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'TRUNCATE', [toFirstToken, toFindWordLast], 0);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'TABLE', [], 2);
  T:=AddSQLTokens(stIdentificator, [T, FSQLTokens], '', [], 1);
end;

procedure TMySQLTruncateTable.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    2:FIsTable:=true;
  end;
end;

procedure TMySQLTruncateTable.MakeSQL;
var
  S: String;
begin
  S:='TRUNCATE ';
  if FIsTable then S:=S + 'TABLE ';
  S:=S + FullName;
  AddSQLCommand(S);
end;

procedure TMySQLTruncateTable.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TMySQLTruncateTable then
    IsTable:=TMySQLTruncateTable(ASource).IsTable;
  inherited Assign(ASource);
end;

{ TMySQLRenameTable }

procedure TMySQLRenameTable.InitParserTree;
var
  FSQLTokens, T, TOldName, TNewName, TSymb, TOldName1,
    TNewName1: TSQLTokenRecord;
begin
  (*
  RENAME TABLE tbl_name TO new_tbl_name
      [, tbl_name2 TO new_tbl_name2] ...
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'RENAME', [toFirstToken], 0);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'TABLE', [toFindWordLast]);

  TOldName:=AddSQLTokens(stIdentificator, T, '', [], 1);
    TSymb:=AddSQLTokens(stSymbol, TOldName, '.', []);
  TOldName1:=AddSQLTokens(stIdentificator, TSymb, '', [], 4);

  T:=AddSQLTokens(stKeyword, [TOldName, TOldName1], 'TO', []);

  TNewName:=AddSQLTokens(stIdentificator, T, '', [], 2);
    TSymb:=AddSQLTokens(stSymbol, TNewName, '.', [toOptional]);
  TNewName1:=AddSQLTokens(stIdentificator, TSymb, '', [], 5);

  TSymb:=AddSQLTokens(stSymbol, [TNewName, TNewName1], ',', [toOptional], 3);
    TSymb.AddChildToken(TOldName);
end;

procedure TMySQLRenameTable.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
begin
  case AChild.Tag of
    1:FCurTable:=Params.AddParam(AWord);
    2:if Assigned(FCurTable) then FCurTable.TableName:=AWord;
    3:FCurTable:=nil;
    4:if Assigned(FCurTable) then
      FCurTable.Caption:=FCurTable.Caption + '.' + AWord;
    5:if Assigned(FCurTable) then
      FCurTable.TableName:=FCurTable.TableName + '.' + AWord;
  end;
end;

procedure TMySQLRenameTable.MakeSQL;
var
  P: TSQLParserField;
  S: String;
begin
  S:='';
  for P in Params do
  begin
    if S<>'' then S:=S + ',' + LineEnding;
    S:=S + '  ' + P.Caption + ' TO ' + P.TableName;
  end;

  AddSQLCommand('RENAME TABLE' + LineEnding + S);
end;

{ TMySQLDropView }

procedure TMySQLDropView.InitParserTree;
var
  FSQLTokens, T2, T, TName: TSQLTokenRecord;
begin
  (*
  DROP VIEW [IF EXISTS]
      view_name [, view_name] ...
      [RESTRICT | CASCADE]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0);
  T2:=AddSQLTokens(stKeyword, FSQLTokens, 'VIEW', [toFindWordLast]);
    T:=AddSQLTokens(stKeyword, T2, 'IF', []);
    T:=AddSQLTokens(stKeyword, T, 'EXISTS', [], -1);
  TName:=AddSQLTokens(stIdentificator, [T, T2], '', [], 3);
    T:=AddSQLTokens(stSymbol, TName, ',', []);
    T.AddChildToken(TName);
  AddSQLTokens(stKeyword, TName, 'RESTRICT', [], -3);
  AddSQLTokens(stKeyword, TName, 'CASCADE', [], -2);
end;

procedure TMySQLDropView.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    3:begin
        Tables.Add(AWord);
        Name:=AWord;
      end;
  end;
end;

procedure TMySQLDropView.MakeSQL;
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

constructor TMySQLDropView.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okView;
end;

{ TMySQLDropTable }

procedure TMySQLDropTable.InternalFormatsInit;
begin
  inherited InternalFormatsInit;
  FQuteIdentificatorChar:='`';
end;

procedure TMySQLDropTable.InitParserTree;
var
  FSQLTokens, T, T2, TName: TSQLTokenRecord;
begin
  (*
  DROP [TEMPORARY] TABLE [IF EXISTS]
      tbl_name [, tbl_name] ...
      [RESTRICT | CASCADE]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'TEMPORARY', [], 1);
  T2:=AddSQLTokens(stKeyword, [FSQLTokens, T], 'TABLE', [toFindWordLast]);
    T:=AddSQLTokens(stKeyword, T2, 'IF', []);
    T:=AddSQLTokens(stKeyword, T, 'EXISTS', [], -1);
  TName:=AddSQLTokens(stIdentificator, [T, T2], '', [], 3);
    T:=AddSQLTokens(stSymbol, TName, ',', []);
    T.AddChildToken(TName);
  AddSQLTokens(stKeyword, TName, 'RESTRICT', [], -3);
  AddSQLTokens(stKeyword, TName, 'CASCADE', [], -2);
end;

procedure TMySQLDropTable.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Options:=Options + [ooTemporary];
    3:begin
        Tables.Add(AWord);
        Name:=AWord;
      end;
  end;
end;

procedure TMySQLDropTable.MakeSQL;
var
  S: String;
begin
  S:='DROP ';
  if ooTemporary in Options then
    S:=S + 'TEMPORARY ';
  S:=S + 'TABLE ';
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

constructor TMySQLDropTable.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okTable;
end;

{ TMySQLAlterTable }

function TMySQLAlterTable.ColDataType(Field: TSQLParserField): string;
begin
  Result:=Field.FullTypeName;

  if fpUnsigned in Field.Params then
    Result:=Result + ' UNSIGNED';

  if fpBinary in Field.Params then
    Result:=Result + ' BINARY';

  if Field.CharSetName <> '' then
    Result:=Result + ' CHARACTER SET ' + Field.CharSetName;

  if Field.Collate <> '' then
    Result:=Result + ' COLLATE ' + Field.Collate;

  if fpNotNull in Field.Params then
    Result:=Result + ' NOT NULL'
  else
  if fpNull in Field.Params then
    Result:=Result + ' NULL';
  if Field.DefaultValue <> '' then
    Result:=Result + ' DEFAULT ' + Field.DefaultValue;
  if fpAutoInc in Field.Params then
    Result:=Result + ' AUTO_INCREMENT';
  if Field.Description<>'' then
    Result:=Result + ' COMMENT '+QuotedString(Field.Description, '''');

(*
  [AUTO_INCREMENT] [UNIQUE [KEY] | [PRIMARY] KEY]
  [COMMENT 'string']
  [COLUMN_FORMAT {FIXED|DYNAMIC|DEFAULT}]
  [STORAGE {DISK|MEMORY|DEFAULT}]
  [reference_definition]
*)
end;

procedure TMySQLAlterTable.AddCollumn(OP: TAlterTableOperator);
var
  SDesc, S, SK, S_IFN, S_POS: String;
  FConstr: TSQLConstraintItem;
begin
  S:='ALTER';
  if ooOrReplase in Options then S:=S + ' IGNORE';
  S:=S + ' TABLE ' + FullName;
  if OP.Field.Description<>'' then SDesc:=' COMMENT '+QuotedString(OP.Field.Description, '''');

  if Trim(OP.Field.ComputedSource) <> '' then
  begin
(*
| data_type [GENERATED ALWAYS] AS (expression)    [VIRTUAL | STORED] [UNIQUE [KEY]] [COMMENT comment]    [NOT NULL | NULL] [[PRIMARY] KEY]*)
    SK:='';
    if OP.Field.DefaultValue <> '' then
      SK:=SK + ' DEFAULT ' + OP.Field.DefaultValue;
    if fpAutoInc in OP.Field.Params then
      SK:=SK + ' AUTO_INCREMENT';
    AddSQLCommandEx('%s ADD COLUMN %s %s GENERATED ALWAYS AS (%s)%s', [S, OP.Field.Caption, OP.Field.FullTypeName, OP.Field.ComputedSource, SDesc]);
  end
  else
  begin

    if ooIfNotExists in OP.Options then
      S_IFN:='IF NOT EXISTS '
    else
      S_IFN:='';

    if OP.Field.FieldPosition <> '' then
      S_POS:=' ' + OP.Field.FieldPosition
    else
      S_POS:='';

    if OP.AlterAction = ataAddColumn then
    begin
      AddSQLCommandEx('%s ADD COLUMN %s %s', [S, S_IFN + OP.Field.Caption, ColDataType(OP.Field)+S_POS]);

      if OP.Constraints.Count>0 then
        AddConstrint(S, OP);
    end
    else
    if OP.AlterAction = ataRenameColumn then
      AddSQLCommandEx('%s CHANGE COLUMN %s %s %s', [S, S_IFN + OP.OldField.Caption, OP.Field.Caption, ColDataType(OP.Field)])
    else
      AddSQLCommandEx('%s MODIFY COLUMN %s %s', [S, OP.Field.Caption, ColDataType(OP.Field) + S_POS]);


    if OP.InitialValue <> '' then
      AddSQLCommandEx('UPDATE %s SET %s = %s', [FullName, OP.Field.Caption, OP.InitialValue]);
  end;
end;

procedure TMySQLAlterTable.ModifyCollumn(OP: TAlterTableOperator);
var
  S: String;
begin
  S:='ALTER';
  if ooOrReplase in Options then S:=S + ' IGNORE';
  S:=S + ' TABLE ' + FullName;
  AddSQLCommandEx('%s MODIFY COLUMN %s %s', [S, OP.Field.Caption, ColDataType(OP.Field)]);
end;

procedure TMySQLAlterTable.AddConstrint(STbl: string; AOper: TAlterTableOperator
  );
var
  S: String;
  C: TSQLConstraintItem;
begin
  for C in AOper.Constraints do
  begin
    S:='';
    if C.ConstraintType = ctPrimaryKey then
    begin
      S:=STbl + ' ADD ';
      if C.ConstraintName <> '' then S:=S + 'CONSTRAINT '+C.ConstraintName + ' ';
      S:=S + 'PRIMARY KEY (' + C.ConstraintFields.AsString + ')';
    end
    else
    if C.ConstraintType = ctForeignKey then
    begin
      S:='';
      if C.ForeignKeyRuleOnUpdate<>fkrNone then
        S:=S+' ON UPDATE '+ForeignKeyRuleNames[C.ForeignKeyRuleOnUpdate];
      if C.ForeignKeyRuleOnDelete<>fkrNone then
        S:=S+' ON DELETE '+ForeignKeyRuleNames[C.ForeignKeyRuleOnDelete];
      if C.IndexName <> '' then
        S:=S + ' USING INDEX ' + C.IndexName;
      S:=Format('ALTER TABLE %s ADD CONSTRAINT %s FOREIGN KEY (%s) REFERENCES %s(%s)%s', [Name, C.ConstraintName,
                                                                                                    C.ConstraintFields.AsString,
                                                                                                    C.ForeignTable,
                                                                                                    C.ForeignFields.AsString,
                                                                                                    S
                                                                                                    ]);
    end
{    else
    if C.ConstraintType = ctUnique then
      S:=Format('ALTER TABLE %s ADD CONSTRAINT %s UNIQUE(%s)', [Name, C.ConstraintName, C.ConstraintFields.AsString])}
    else
    if C.ConstraintType = ctTableCheck then
    begin
      S:=STbl + ' ADD CONSTRAINT ';
      if C.ConstraintName <> '' then S:=S + C.ConstraintName + ' ';
      S:=S + 'CHECK(' + C.ConstraintExpression + ')';
    end;
    if S<>'' then
      AddSQLCommand(S);
  end;

end;

procedure TMySQLAlterTable.InternalFormatsInit;
begin
  inherited InternalFormatsInit;
  FQuteIdentificatorChar:='`';
end;

procedure TMySQLAlterTable.InitParserTree;
var
  FSQLTokens, T, T2, TName, TAdd, TAddCol, TAddColName,
    TAddColFirst, TAddColAfter, TSymb1, TSymb2, TSymbEnd,
    TIndex1, TIndex2, TIndexName, TIndexSymb, TIndexCol,
    TDropCol1, TDropCmd, TDropFK, T1, TDropPK, TDropInd,
    TDropInd1, TAddConst, TAddConstName, TAddFK, TAddFKName,
    TAddCheck, TAddCheck1, TModify, TAddColName1, TAddColIFNE1,
    TDropConstraint, TChange, TChangeCol, TChangeON, TChangeNN,
    TRef2, TAddFKRef, TAddFKRefTblName, TRef2_1, TRef2_2,
    TRef2_3, TRef3, TRef3_1, TRef3_2, TRef3_3, TRef3_4,
    TRef3_5, TRef3_6, TCommentCmd, TCommentCmd1: TSQLTokenRecord;
begin
  (*
  ALTER [ONLINE] [IGNORE] TABLE tbl_name
      [alter_specification [, alter_specification] ...]
      [partition_options]

  alter_specification:
      table_options
    | ADD [COLUMN] col_name column_definition [FIRST | AFTER col_name ]
    | ADD [COLUMN] (col_name column_definition,...)
    | ADD {INDEX|KEY} [index_name] [index_type] (index_col_name,...) [index_option] ...
    | ADD [CONSTRAINT [symbol]] PRIMARY KEY [index_type] (index_col_name,...) [index_option] ...
    | ADD [CONSTRAINT [symbol]] UNIQUE [INDEX|KEY] [index_name] [index_type] (index_col_name,...) [index_option] ...
    | ADD FULLTEXT [INDEX|KEY] [index_name] (index_col_name,...) [index_option] ...
    | ADD SPATIAL [INDEX|KEY] [index_name] (index_col_name,...) [index_option] ...
    | ADD [CONSTRAINT [symbol]]  FOREIGN KEY [index_name] (index_col_name,...) reference_definition
    | ALGORITHM [=] {DEFAULT|INPLACE|COPY}
    | ALTER [COLUMN] col_name {SET DEFAULT literal | DROP DEFAULT}
    | CHANGE [COLUMN] old_col_name new_col_name column_definition [FIRST|AFTER col_name]
    | LOCK [=] {DEFAULT|NONE|SHARED|EXCLUSIVE}
    | DROP [COLUMN] col_name
    | DROP PRIMARY KEY
    | DROP {INDEX|KEY} index_name
    | DROP FOREIGN KEY fk_symbol
    | DISABLE KEYS
    | ENABLE KEYS
    | RENAME [TO|AS] new_tbl_name
    | RENAME {INDEX|KEY} old_index_name TO new_index_name
    | ORDER BY col_name [, col_name] ...
    | CONVERT TO CHARACTER SET charset_name [COLLATE collation_name]
    | [DEFAULT] CHARACTER SET [=] charset_name [COLLATE [=] collation_name]
    | DISCARD TABLESPACE
    | IMPORT TABLESPACE
    | FORCE
    | {WITHOUT|WITH} VALIDATION
    | ADD PARTITION (partition_definition)
    | DROP PARTITION partition_names
    | DISCARD PARTITION {partition_names | ALL} TABLESPACE
    | IMPORT PARTITION {partition_names | ALL} TABLESPACE
    | TRUNCATE PARTITION {partition_names | ALL}
    | COALESCE PARTITION number
    | REORGANIZE PARTITION partition_names INTO (partition_definitions)
    | EXCHANGE PARTITION partition_name WITH TABLE tbl_name [{WITH|WITHOUT} VALIDATION]
    | ANALYZE PARTITION {partition_names | ALL}
    | CHECK PARTITION {partition_names | ALL}
    | OPTIMIZE PARTITION {partition_names | ALL}
    | REBUILD PARTITION {partition_names | ALL}
    | REPAIR PARTITION {partition_names | ALL}
    | REMOVE PARTITIONING
    | UPGRADE PARTITIONING

  index_col_name:
      col_name [(length)] [ASC | DESC]

  index_type:
      USING {BTREE | HASH}

  index_option:
      KEY_BLOCK_SIZE [=] value
    | index_type
    | WITH PARSER parser_name
    | COMMENT 'string'

  table_options:
      table_option [[,] table_option] ...  (see CREATE TABLE options)

  partition_options:
      (see CREATE TABLE options)
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken], 0);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'ONLINE', [], 11);
    T:=AddSQLTokens(stKeyword, [FSQLTokens, T1], 'IGNORE', [], -2);
  T:=AddSQLTokens(stKeyword, [T, T1, FSQLTokens], 'TABLE', [toFindWordLast]);
  TName:=AddSQLTokens(stIdentificator, T, '', [], 2);
  TAdd:=AddSQLTokens(stKeyword, TName, 'ADD', []);
  TSymbEnd:=AddSQLTokens(stSymbol, nil, ',', [toOptional], 6);
    TSymbEnd.AddChildToken(TAdd);

    TAddCol:=AddSQLTokens(stKeyword, TAdd, 'COLUMN', [], 13);
      TAddColIFNE1:=AddSQLTokens(stKeyword, [TAdd, TAddCol], 'IF', []);
      TAddColIFNE1:=AddSQLTokens(stKeyword, TAddColIFNE1, 'NOT', []);
      TAddColIFNE1:=AddSQLTokens(stKeyword, TAddColIFNE1, 'EXISTS', [], 12);

  TAddColName:=AddSQLTokens(stIdentificator, [TAdd, TAddCol, TAddColIFNE1], '', [], 3);

  TAddColFirst:=AddSQLTokens(stKeyword, nil, 'FIRST', [toOptional], 4);
  TAddColAfter:=AddSQLTokens(stKeyword, nil, 'AFTER', [toOptional]);
  TSymbEnd.AddChildToken([TAddColFirst, TAddColAfter]);

  TChange:=AddSQLTokens(stKeyword, [TName, TSymbEnd], 'CHANGE', [], 40); //| CHANGE [COLUMN] old_col_name new_col_name column_definition [FIRST|AFTER col_name]
    TChangeCol:=AddSQLTokens(stKeyword, TChange, 'COLUMN', []);
  TChangeON:=AddSQLTokens(stIdentificator, [TChange, TChangeCol], '', [], 41);
  TChangeNN:=AddSQLTokens(stIdentificator, TChangeON, '', [], 42);

  MakeTypeDefTree(Self, [TAddColName, TChangeNN], [TAddColFirst, TAddColAfter, TSymbEnd], tdfTableColDef, 100);
  TAddColName1:=AddSQLTokens(stIdentificator, TAddColAfter, '', [], 5);

  TModify:=AddSQLTokens(stKeyword, [TName, TSymbEnd], 'MODIFY', [], 10);
    TModify.AddChildToken([TAddCol, TAddColName]);


  TSymb1:=AddSQLTokens(stSymbol, [TAdd, TAddCol], '(', []);
  TAddColName:=AddSQLTokens(stIdentificator, TSymb1, '', [], 3);
  TSymb1:=AddSQLTokens(stSymbol, nil, ',', [], 6);
    TSymb1.AddChildToken(TAddColName);
  TSymb2:=AddSQLTokens(stSymbol, nil, ')', [], 6);
    TSymb2.AddChildToken(TSymbEnd);
  MakeTypeDefTree(Self, TAddColName, [TSymb1, TSymb2, TSymbEnd], tdfTableColDef, 100);

  TIndex1:=AddSQLTokens(stSymbol, TAdd, 'INDEX', [], 7);   //ADD {INDEX|KEY} [index_name] [index_type] (index_col_name,...) [index_option] ...
  TIndex2:=AddSQLTokens(stSymbol, TAdd, 'KEY', [], 7);
  TIndexName:=AddSQLTokens(stIdentificator, [TIndex1, TIndex2], '', [], 8);
   TIndexSymb:=AddSQLTokens(stSymbol, [TIndex1, TIndex2, TIndexName], '(', []);
   TIndexCol:=AddSQLTokens(stIdentificator, TIndexSymb, '', [], 9);
   TIndexSymb:=AddSQLTokens(stSymbol, TIndexCol, ',', []);
   TIndexSymb.AddChildToken(TIndexCol);
   TIndexSymb:=AddSQLTokens(stSymbol, TIndexCol, ')', []);
   TIndexSymb.AddChildToken(TSymbEnd);

  TAddConst:=AddSQLTokens(stKeyword, TAdd, 'CONSTRAINT', [], 24); //ADD [CONSTRAINT [symbol]]  FOREIGN KEY [index_name] (index_col_name,...) reference_definition
    TAddConstName:=AddSQLTokens(stIdentificator, TAddConst, '', [], 26);
    TAddFK:=AddSQLTokens(stKeyword, [TAdd, TAddConst, TAddConstName], 'FOREIGN', []);
      TAddFK:=AddSQLTokens(stKeyword, TAddFK, 'KEY', [], 25);
      TAddFKName:=AddSQLTokens(stIdentificator, TAddFK, '', [], 27);

      TIndexSymb:=AddSQLTokens(stSymbol, [TAddFK, TAddFKName], '(', []);
      TIndexCol:=AddSQLTokens(stIdentificator, TIndexSymb, '', [], 128);
      TIndexSymb:=AddSQLTokens(stSymbol, TIndexCol, ',', []);
      TIndexSymb.AddChildToken(TIndexCol);
      TIndexSymb:=AddSQLTokens(stSymbol, TIndexCol, ')', []); //TIndexSymb:=AddSQLTokens(stSymbol, TIndexCol, ')', [], 132);

      TAddFKRef:=AddSQLTokens(stKeyword, TIndexSymb, 'REFERENCES', []);
        TAddFKRefTblName:=AddSQLTokens(stIdentificator, TAddFKRef, '', [], 139);

        TIndexSymb:=AddSQLTokens(stSymbol, TAddFKRefTblName, '(', []);
        TIndexCol:=AddSQLTokens(stIdentificator, TIndexSymb, '', [], 140);
        TIndexSymb:=AddSQLTokens(stSymbol, TIndexCol, ',', []);
        TIndexSymb.AddChildToken(TIndexCol);
        TIndexSymb:=AddSQLTokens(stSymbol, TIndexCol, ')', []);

        TRef2:=AddSQLTokens(stKeyword, TIndexSymb, 'MATCH', [toOptional]);
        TRef2_1:=AddSQLTokens(stKeyword, TRef2, 'FULL', [], 142);
        TRef2_2:=AddSQLTokens(stKeyword, TRef2, 'PARTIAL', [], 143);
        TRef2_3:=AddSQLTokens(stKeyword, TRef2, 'SIMPLE', [], 144);

        TRef3:=AddSQLTokens(stSymbol, [TIndexSymb, TRef2_1, TRef2_2, TRef2_3], 'ON', [toOptional]);
        TRef3_1:=AddSQLTokens(stSymbol, TRef3, 'DELETE', [], 137);
        TRef3_2:=AddSQLTokens(stSymbol, TRef3, 'UPDATE', [], 138);
        TRef3_3:=AddSQLTokens(stSymbol, [TRef3_1, TRef3_2], 'RESTRICT', [], 147);
        TRef3_4:=AddSQLTokens(stSymbol, [TRef3_1, TRef3_2], 'CASCADE', [], 134);
        TRef3_5:=AddSQLTokens(stSymbol, [TRef3_1, TRef3_2], 'SET', []);
        TRef3_5:=AddSQLTokens(stSymbol, TRef3_5, 'NULL', [], 135);
        TRef3_6:=AddSQLTokens(stSymbol, [TRef3_1, TRef3_2], 'NO', []);
        TRef3_6:=AddSQLTokens(stSymbol, TRef3_6, 'ACTION', [], 133);
        TRef3_3.AddChildToken([TRef3, TRef2]);
        TRef3_4.AddChildToken([TRef3, TRef2]);
        TRef3_5.AddChildToken([TRef3, TRef2]);
        TRef3_6.AddChildToken([TRef3, TRef2]);

        TIndexSymb.AddChildToken(TSymbEnd);
        TRef2_1.AddChildToken(TSymbEnd);
        TRef2_2.AddChildToken(TSymbEnd);
        TRef2_3.AddChildToken(TSymbEnd);
        TRef3_3.AddChildToken(TSymbEnd);
        TRef3_4.AddChildToken(TSymbEnd);
        TRef3_5.AddChildToken(TSymbEnd);
        TRef3_6.AddChildToken(TSymbEnd);

      {
      REFERENCES tbl_name (index_col_name,...)
        [MATCH FULL | MATCH PARTIAL | MATCH SIMPLE]
        [ON DELETE reference_option]
        [ON UPDATE reference_option]
        reference_option:
            RESTRICT | CASCADE | SET NULL | NO ACTION
       }
    TAddCheck:=AddSQLTokens(stKeyword, [TAdd, TAddConst, TAddConstName], 'CHECK', []); //CHECK (check_constraints)
      TAddCheck1:=AddSQLTokens(stSymbol, TAddCheck, '(', [], 30);
      //TAddCheck1:=AddSQLTokens(stSymbol, TAddCheck1, ')', []);
      TAddCheck1.AddChildToken(TSymbEnd);



  TDropCmd:=AddSQLTokens(stSymbol, [TName, TSymbEnd], 'DROP', []);
    TDropCol1:=AddSQLTokens(stSymbol, TDropCmd, 'COLUMN', []);
  TDropCol1:=AddSQLTokens(stIdentificator, [TDropCmd, TDropCol1], '', [], 20);
    TDropCol1.AddChildToken(TSymbEnd);
  TDropFK:=AddSQLTokens(stKeyword, TDropCmd, 'FOREIGN', []);     //DROP FOREIGN KEY fk_symbol
    TDropFK:=AddSQLTokens(stKeyword, TDropFK, 'KEY', []);
    TDropFK:=AddSQLTokens(stIdentificator, TDropFK, '', [], 21);
    TDropFK.AddChildToken(TSymbEnd);
  TDropPK:=AddSQLTokens(stKeyword, TDropCmd, 'PRIMARY', []);     //DROP PRIMARY KEY
    TDropPK:=AddSQLTokens(stKeyword, TDropPK, 'KEY', [], 22);
    TDropPK.AddChildToken(TSymbEnd);
  TDropInd:=AddSQLTokens(stKeyword, TDropCmd, 'INDEX', []);     //DROP {INDEX|KEY} index_name
  TDropInd1:=AddSQLTokens(stKeyword, TDropCmd, 'KEY', []);
    TDropInd:=AddSQLTokens(stIdentificator, [TDropInd, TDropInd1], '', [], 23);
    TDropInd.AddChildToken(TSymbEnd);
  TDropConstraint:=AddSQLTokens(stKeyword, TDropCmd, 'CONSTRAINT', []);     //DROP PRIMARY KEY
    TDropConstraint:=AddSQLTokens(stIdentificator, TDropConstraint, '', [], 28);
    TDropConstraint.AddChildToken(TSymbEnd);

  TCommentCmd:=AddSQLTokens(stKeyword, [TName, TSymbEnd], 'COMMENT', []);
      TCommentCmd1:=AddSQLTokens(stSymbol, TCommentCmd, '=', []);
      TCommentCmd1:=AddSQLTokens(stString, [TCommentCmd, TCommentCmd1], '', [], 43);
      TCommentCmd1.AddChildToken(TSymbEnd);

(*
| ADD [CONSTRAINT [symbol]] PRIMARY KEY [index_type] (index_col_name,...) [index_option] ...
| ADD [CONSTRAINT [symbol]] UNIQUE [INDEX|KEY] [index_name] [index_type] (index_col_name,...) [index_option] ...
| ADD FULLTEXT [INDEX|KEY] [index_name] (index_col_name,...) [index_option] ...
| ADD SPATIAL [INDEX|KEY] [index_name] (index_col_name,...) [index_option] ...
| ADD [CONSTRAINT [symbol]]  FOREIGN KEY [index_name] (index_col_name,...) reference_definition
| ALGORITHM [=] {DEFAULT|INPLACE|COPY}
| ALTER [COLUMN] col_name {SET DEFAULT literal | DROP DEFAULT}
| LOCK [=] {DEFAULT|NONE|SHARED|EXCLUSIVE}
| DISABLE KEYS
| ENABLE KEYS
| RENAME [TO|AS] new_tbl_name
| RENAME {INDEX|KEY} old_index_name TO new_index_name
| ORDER BY col_name [, col_name] ...
| CONVERT TO CHARACTER SET charset_name [COLLATE collation_name]
| [DEFAULT] CHARACTER SET [=] charset_name [COLLATE [=] collation_name]
| DISCARD TABLESPACE
| IMPORT TABLESPACE
| FORCE
| {WITHOUT|WITH} VALIDATION
| ADD PARTITION (partition_definition)
| DROP PARTITION partition_names
| DISCARD PARTITION {partition_names | ALL} TABLESPACE
| IMPORT PARTITION {partition_names | ALL} TABLESPACE
| TRUNCATE PARTITION {partition_names | ALL}
| COALESCE PARTITION number
| REORGANIZE PARTITION partition_names INTO (partition_definitions)
| EXCHANGE PARTITION partition_name WITH TABLE tbl_name [{WITH|WITHOUT} VALIDATION]
| ANALYZE PARTITION {partition_names | ALL}
| CHECK PARTITION {partition_names | ALL}
| OPTIMIZE PARTITION {partition_names | ALL}
| REBUILD PARTITION {partition_names | ALL}
| REPAIR PARTITION {partition_names | ALL}
| REMOVE PARTITIONING
| UPGRADE PARTITIONING

*)
end;

procedure TMySQLAlterTable.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
begin
  case AChild.Tag of
    //1:CreateMode:=cmCreateOrAlter;
    2:Name:=AWord;
    3:begin
        if not Assigned(FCurOper) then
          FCurOper:=AddOperator(ataAddColumn);
        FCurField:=FCurOper.Field;
        FCurOper.Field.Caption:=AWord;
      end;
    4:if Assigned(FCurField) then
        FCurField.FieldPosition:='FIRST';
    5:if Assigned(FCurField) then
        FCurField.FieldPosition:='AFTER '+AWord;
    6:begin
        FCurOper:=nil;
        FCurField:=nil;
        FCurConstr:=nil;
      end;
    7:begin
        FCurOper:=AddOperator(ataAddIndex);
        FCurField:=nil;
      end;
    8:if Assigned(FCurOper) and (FCurOper.AlterAction = ataAddIndex) then FCurOper.Name:=AWord;
    9:if Assigned(FCurOper) and (FCurOper.AlterAction = ataAddIndex) then FCurOper.Params.AddParam(AWord);
    10:begin
        FCurOper:=AddOperator(ataAlterCol);
        FCurField:=nil;
      end;
    12:if Assigned(FCurOper) then
      FCurOper.Options:=FCurOper.Options + [ooIfNotExists];
    13:begin
        if not Assigned(FCurOper) then
          FCurOper:=AddOperator(ataAddColumn);
        FCurField:=nil;
       end;
    20:begin
         FCurOper:=AddOperator(ataDropColumn);
         FCurOper.Field.Caption:=AWord;
       end;
    21:begin
         FCurOper:=AddOperator(ataDropConstraint);
         FCurOper.Constraints.Add(ctForeignKey, AWord);
       end;
    22:begin
         FCurOper:=AddOperator(ataDropConstraint);
         FCurOper.Constraints.Add(ctPrimaryKey);
       end;
    23:begin
         FCurOper:=AddOperator(ataDropIndex);
         FCurOper.Name:=AWord;
       end;
    24:begin
         FCurOper:=AddOperator(ataAddTableConstraint);
         FCurConstr:=FCurOper.Constraints.Add(ctNone);
       end;
    25:if Assigned(FCurOper) then
       begin
         if not Assigned(FCurConstr) then
           FCurConstr:=FCurOper.Constraints.Add(ctForeignKey);
         FCurConstr.ConstraintType:=ctForeignKey;
       end;
    26:begin
         if Assigned(FCurConstr) then
           FCurConstr.ConstraintName:=AWord;
       end;
    27:if Assigned(FCurConstr) then
        FCurConstr.IndexName:=AWord;
    28:begin
         FCurOper:=AddOperator(ataDropConstraint);
         FCurOper.Constraints.Add(ctNone, AWord);
       end;
    30:if Assigned(FCurOper) then
       begin
         if not Assigned(FCurConstr) then
           FCurConstr:=FCurOper.Constraints.Add(ctTableCheck);
         FCurConstr.ConstraintType:=ctTableCheck;
         FCurConstr.ConstraintExpression:=ASQLParser.GetToBracket(')');
       end;

    40:FCurOper:=AddOperator(ataRenameColumn);
    41:if Assigned(FCurOper) then
         FCurOper.OldField.Caption:=AWord;
    42:if Assigned(FCurOper) then
       begin
         FCurField:=FCurOper.Field;
         FCurField.Caption:=AWord;
       end;
    43:begin
         FCurOper:=AddOperator(ataCommentTable);
         FCurOper.Name:=ExtractQuotedString(AWord, '''');
       end;

    102:if Assigned(FCurField) then FCurField.TypeName:=AWord;
    103:if Assigned(FCurField) then FCurField.TypeName:=FCurField.TypeName + ' ' + AWord;
    104:if Assigned(FCurField) then FCurField.TypeLen:=StrToInt(AWord);
    105:if Assigned(FCurField) then FCurField.TypePrec:=StrToInt(AWord);
    106:if Assigned(FCurField) then FCurField.Params:=FCurField.Params + [fpUnsigned];
    107:if Assigned(FCurField) then FCurField.Params:=FCurField.Params + [fpZeroFill];
    108:if Assigned(FCurField) then FCurField.Params:=FCurField.Params + [fpBinary];
    109:if Assigned(FCurField) then FCurField.CharSetName:=AWord;
    110:if Assigned(FCurField) then FCurField.Collate:=AWord;
    111:if Assigned(FCurField) then FCurField.Params:=FCurField.Params + [fpNull];
    112:if Assigned(FCurField) then FCurField.Params:=FCurField.Params + [fpNotNull];
    113:if Assigned(FCurField) then FCurField.Params:=FCurField.Params + [fpAutoInc];
    114:if Assigned(FCurField) then
        begin
           FCurConstr:=FCurOper.Constraints.Add(ctUnique);
           FCurConstr.ConstraintFields.AddParam(FCurField.Caption);
        end;
    115:if Assigned(FCurField) then FCurField.PrimaryKey:=true;
    116:if Assigned(FCurField) then FCurField.Description:=ExtractQuotedString(AWord, '''');
    117:if Assigned(FCurField) then FCurField.DefaultValue:=ExtractQuotedString(AWord, '''');
    118:if Assigned(FCurField) then FCurField.FieldFormat:=ffFixed;
    119:if Assigned(FCurField) then FCurField.FieldFormat:=ffDynamic;
    120:if Assigned(FCurField) then FCurField.FieldFormat:=ffDefault;
    121:if Assigned(FCurField) then FCurField.FieldStorage:=fsDisk;
    122:if Assigned(FCurField) then FCurField.FieldStorage:=fsMemory;
    123:if Assigned(FCurField) then FCurField.FieldStorage:=fsDefault;
    124:if Assigned(FCurField) then FCurField.ComputedSource:=ASQLParser.GetToBracket(')');
    125:if Assigned(FCurField) then FCurField.Params:=FCurField.Params + [fpVirtual];
    126:if Assigned(FCurField) then FCurField.Params:=FCurField.Params + [fpStored];
    127:if Assigned(FCurField) then
         begin
           FCurConstr:=FCurOper.Constraints.Add(ctForeignKey);
           FCurConstr.ForeignTable:=AWord;
           FCurConstr.ConstraintFields.AddParam(FCurField.Caption);
         end;

    128:if Assigned(FCurConstr) then FCurConstr.ConstraintFields.AddParam(AWord);
    129:if Assigned(FCurConstr) then FCurConstr.Match:=maFull;
    130:if Assigned(FCurConstr) then FCurConstr.Match:=maPartial;
    131:if Assigned(FCurConstr) then FCurConstr.Match:=maSimple;
    133:if Assigned(FCurConstr) then
         begin
           if FCurFK = 1 then
             FCurConstr.ForeignKeyRuleOnDelete:=fkrNone
           else
             FCurConstr.ForeignKeyRuleOnUpdate:=fkrNone;
         end;
    134:if Assigned(FCurConstr) then
         begin
           if FCurFK = 1 then
             FCurConstr.ForeignKeyRuleOnDelete:=fkrCascade
           else
             FCurConstr.ForeignKeyRuleOnUpdate:=fkrCascade;
         end;
    135:if Assigned(FCurConstr) then
         begin
           if FCurFK = 1 then
             FCurConstr.ForeignKeyRuleOnDelete:=fkrSetNull
           else
             FCurConstr.ForeignKeyRuleOnUpdate:=fkrSetNull;
         end;
    136:if Assigned(FCurConstr) then
         begin
           if FCurFK = 1 then
             FCurConstr.ForeignKeyRuleOnDelete:=fkrSetDefault
           else
             FCurConstr.ForeignKeyRuleOnUpdate:=fkrSetDefault;
         end;
    147:if Assigned(FCurConstr) then
         begin
           if FCurFK = 1 then
             FCurConstr.ForeignKeyRuleOnDelete:=fkrRestrict
           else
             FCurConstr.ForeignKeyRuleOnUpdate:=fkrRestrict;
         end;
    137:FCurFK:=1;
    138:FCurFK:=2;
    139:if Assigned(FCurConstr) then FCurConstr.ForeignTable:=AWord;
    140:if Assigned(FCurConstr) then FCurConstr.ForeignFields.AddParam(AWord);
  end;
end;

procedure TMySQLAlterTable.MakeSQL;

procedure DropConstraint(S:string; AOper:TAlterTableOperator);
var
  C: TSQLConstraintItem;
begin
  for C in AOper.Constraints do
    case C.ConstraintType of
      ctPrimaryKey:AddSQLCommandEx('%s DROP PRIMARY KEY', [S]);
      ctForeignKey:AddSQLCommandEx('%s DROP FOREIGN KEY %s', [S, C.ConstraintName]);
    else
      AddSQLCommandEx('%s DROP CONSTRAINT %s', [S, C.ConstraintName]);
    end;
end;
var
  S, SDesc, S1: String;
  Op: TAlterTableOperator;
begin
  S:='ALTER';
  if ooOrReplase in Options then
    S:=S + ' IGNORE';
  S:=S + ' TABLE ' + FullName;
  for Op in FOperators do
  begin
    SDesc:='';
    case OP.AlterAction of
      ataAddColumn,
      ataRenameColumn,
      ataAlterCol: AddCollumn(OP);
      ataDropColumn : AddSQLCommandEx('%s DROP COLUMN %s', [S, OP.Field.Caption]);
      ataAddIndex:
        begin
          S1:=S + ' ADD INDEX';
          if OP.Name <> '' then S1:=S1 + ' ' +Name;
          S1:=S1 + '(' +OP.Params.AsString+')';
          AddSQLCommand(S1);
        end;
      ataAlterColumnDropNotNull,
      ataAlterColumnSetNotNull,
      ataAlterColumnSetDataType,
      ataAlterColumnDropDefault,
      ataAlterColumnSetDefaultExp,
      ataAlterColumnDescription : ModifyCollumn(OP);
      ataAddTableConstraint:AddConstrint(S, OP);
      ataDropConstraint:DropConstraint(S, OP);
      ataDropIndex:AddSQLCommandEx(S + ' DROP INDEX %s', [OP.Name]);
      ataCommentTable:begin
          Description:=OP.Name;
          DescribeObject;
        end
    else
      raise Exception.CreateFmt('Unknow operator "%s"', [AlterTableActionStr[OP.AlterAction]]);
    end;
  end;
end;

constructor TMySQLAlterTable.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okTable;
  FSQLCommentOnClass:=TMySQLCommentOn;
end;

{ TMySQLDropFunction }

procedure TMySQLDropFunction.InitParserTree;
var
  FSQLTokens, T1, T2, T, TName: TSQLTokenRecord;
begin
  (*
  DROP {PROCEDURE | FUNCTION} [IF EXISTS] sp_name
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0);
  T1:=AddSQLTokens(stKeyword, FSQLTokens, 'PROCEDURE', [toFindWordLast], 1, okStoredProc);
  T2:=AddSQLTokens(stKeyword, FSQLTokens, 'FUNCTION', [toFindWordLast], 2, okFunction);
    T:=AddSQLTokens(stKeyword, [T1, T2], 'IF', []);
    T:=AddSQLTokens(stKeyword, T, 'EXISTS', [], -1);
  TName:=AddSQLTokens(stIdentificator, [T, T1, T2], '', [], 3);
end;

procedure TMySQLDropFunction.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:ObjectKind:=okStoredProc;
    2:ObjectKind:=okStoredProc;
    3:Name:=AWord;
  end;
end;

procedure TMySQLDropFunction.MakeSQL;
var
  S: String;
begin
  //  DROP {PROCEDURE | FUNCTION} [IF EXISTS] sp_name
  if ObjectKind = okFunction then
    S:='DROP FUNCTION '
  else
    S:='DROP PROCEDURE ';
  if ooIfExists in Options then
    S:=S + 'IF EXISTS ';
  S:=S + FullName;
  AddSQLCommand(S);
end;

constructor TMySQLDropFunction.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okStoredProc;
end;

{ TMySQLAlterFunction }

procedure TMySQLAlterFunction.InitParserTree;
begin
  (*
  ALTER PROCEDURE proc_name [characteristic ...]

  characteristic:
      COMMENT 'string'
    | LANGUAGE SQL
    | { CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA }
    | SQL SECURITY { DEFINER | INVOKER }
  *)

(*
  ALTER FUNCTION func_name [characteristic ...]

  characteristic:
      COMMENT 'string'
    | LANGUAGE SQL
    | { CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA }
    | SQL SECURITY { DEFINER | INVOKER }
*)
end;

procedure TMySQLAlterFunction.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TMySQLAlterFunction.MakeSQL;
begin
  inherited MakeSQL;
end;


{ TMySQLCreateFunction }

procedure TMySQLCreateFunction.InitParserTree;
var
  FSQLTokens, T, T1, T2, TProc, TFunc, TName, T3, T4, TSymb1,
    TSymb2, TDesc, TDesc1, TLang, TLang1, TNotDet, TDeter, TS1,
    TS1_1, TS2, TS2_1, TS3, TS3_1, TSS, TSS1, TSS2, TSS3, TS4,
    TS4_1, TBegin, TSymb3, TRet, T5: TSQLTokenRecord;
begin
(*
CREATE
    [DEFINER = { user | CURRENT_USER }]
    PROCEDURE sp_name ([proc_parameter[,...]])
    [characteristic ...] routine_body

CREATE
    [DEFINER = { user | CURRENT_USER }]
    FUNCTION sp_name ([func_parameter[,...]])
    RETURNS type
    [characteristic ...] routine_body

proc_parameter:
    [ IN | OUT | INOUT ] param_name type

func_parameter:
    param_name type

type:
    Any valid MySQL data type

characteristic:
    COMMENT 'string'
  | LANGUAGE SQL
  | [NOT] DETERMINISTIC
  | { CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA }
  | SQL SECURITY { DEFINER | INVOKER }

routine_body:
    Valid SQL routine statement
*)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'DEFINER', []);
    T:=AddSQLTokens(stSymbol, T, '=', []);
    T1:=AddSQLTokens(stKeyword, T, 'CURRENT_USER', [], 1);
    T5:=AddSQLTokens(stString, T, '', [], 21);
    T5:=AddSQLTokens(stSymbol, T5, '@', [], 21);
    T5:=AddSQLTokens(stString, T5, '', [], 21);

  TProc:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T5], 'PROCEDURE', [toFindWordLast], 2);
    TName:=AddSQLTokens(stIdentificator, TProc, '', [toFindWordLast], 4);
  T:=AddSQLTokens(stIdentificator, TName, '(', []);
    T1:=AddSQLTokens(stKeyword, T, 'IN', [], 5);
    T2:=AddSQLTokens(stKeyword, T, 'OUT', [], 6);
    T3:=AddSQLTokens(stKeyword, T, 'INOUT', [], 7);
    T4:=AddSQLTokens(stIdentificator, [T, T1, T2, T3], '', [], 8);
    TSymb1:=AddSQLTokens(stSymbol, nil, ',', [], 9);
      TSymb1.AddChildToken([T1, T2, T3, T4]);
    TSymb2:=AddSQLTokens(stSymbol, T, ')', [], 9);

    MakeTypeDefTree(Self, [T4], [TSymb1, TSymb2], tdfTypeOnly, 100);

  TFunc:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T5], 'FUNCTION', [toFindWordLast], 3);
    TName:=AddSQLTokens(stIdentificator, TFunc, '', [toFindWordLast], 4);
    T:=AddSQLTokens(stIdentificator, TName, '(', []);
      T4:=AddSQLTokens(stIdentificator, [T], '', [], 8);
      TSymb1:=AddSQLTokens(stSymbol, nil, ',', [], 9);
        TSymb1.AddChildToken([T1, T2, T3, T4]);
      TSymb3:=AddSQLTokens(stSymbol, T, ')', [], 9);
      MakeTypeDefTree(Self, [T4], [TSymb1, TSymb3], tdfTypeOnly, 100);
  TRet:=AddSQLTokens(stSymbol, TSymb3, 'RETURNS', []);

  TDesc:=AddSQLTokens(stIdentificator, TSymb2, 'COMMENT', []);
    TDesc1:=AddSQLTokens(stString, TDesc, '', [], 10);
  TLang:=AddSQLTokens(stIdentificator, [TSymb2, TDesc1], 'LANGUAGE', []);
    TLang1:=AddSQLTokens(stIdentificator, TLang, 'SQL', []);

  TNotDet:=AddSQLTokens(stIdentificator, [TSymb2, TDesc1, TLang1], 'NOT', [], 11);
    TDeter:=AddSQLTokens(stIdentificator, [TSymb2, TDesc1, TLang1, TNotDet], 'DETERMINISTIC', [], 12);

  TS1:=AddSQLTokens(stIdentificator, [TSymb2, TDesc1, TLang1, TDeter], 'CONTAINS', []);
    TS1_1:=AddSQLTokens(stIdentificator, TS1, 'SQL', [], 13);

  TS2:=AddSQLTokens(stIdentificator, [TSymb2, TDesc1, TLang1, TDeter], 'NO', []);
    TS2_1:=AddSQLTokens(stIdentificator, TS2, 'SQL', [], 14);

  TS3:=AddSQLTokens(stIdentificator, [TSymb2, TDesc1, TLang1, TDeter], 'READS', []);
    TS3_1:=AddSQLTokens(stIdentificator, TS3, 'SQL', []);
    TS3_1:=AddSQLTokens(stIdentificator, TS1, 'DATA', [], 15);

  TS4:=AddSQLTokens(stIdentificator, [TSymb2, TDesc1, TLang1, TDeter], 'MODIFIES', []);
    TS4_1:=AddSQLTokens(stIdentificator, TS4, 'SQL', []);
    TS4_1:=AddSQLTokens(stIdentificator, TS4_1, 'DATA', [], 16);

  TSS:=AddSQLTokens(stIdentificator, [TSymb2, TDesc1, TLang1, TDeter,TS1_1, TS2_1, TS3_1, TS4_1], 'SQL', []);
    TSS1:=AddSQLTokens(stIdentificator, TSS, 'SECURITY', []);
    TSS2:=AddSQLTokens(stIdentificator, TSS1, 'DEFINER', [], 17);
    TSS3:=AddSQLTokens(stIdentificator, TSS1, 'INVOKER', [], 18);

  MakeTypeDefTree(Self, [TRet], [TDesc, TLang, TNotDet, TDeter, TS1, TS2, TS3, TS4, TSS], tdfTypeOnly, 200);

  TSS2.AddChildToken([TDesc, TLang, TNotDet, TS1, TS2, TS3, TS4]);
  TSS3.AddChildToken([TDesc, TLang, TNotDet, TS1, TS2, TS3, TS4]);
  TS4_1.AddChildToken([TDesc, TLang, TNotDet]);
  TS3_1.AddChildToken([TDesc, TLang, TNotDet]);
  TS2_1.AddChildToken([TDesc, TLang, TNotDet]);
  TS1_1.AddChildToken([TDesc, TLang, TNotDet]);
  TDeter.AddChildToken([TDesc, TLang]);
  TLang1.AddChildToken([TDesc]);

  TBegin:=AddSQLTokens(stIdentificator, [TSymb2, TDesc1, TLang1, TDeter,TS1_1, TS2_1, TS3_1,
    TS4_1, TSS2, TSS3], 'BEGIN', [], 20);
(*
COMMENT 'string'
| LANGUAGE SQL
| [NOT] DETERMINISTIC
| { CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA }
| SQL SECURITY { DEFINER | INVOKER }

*)
end;

procedure TMySQLCreateFunction.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; const AWord: string);

function GetProcBody:string;
var
  S: String;
  V: TSQLCommandAbstract;
  C: Integer;
  CP, CP1: TParserPosition;
begin
  ASQLParser.Position:=ASQLParser.WordPosition;
  CP:=ASQLParser.Position;
  S:=ASQLParser.GetNextWord;
    C:=1;
    while not ASQLParser.Eof do
    begin
      CP1:=ASQLParser.Position;
      S:=UpperCase(ASQLParser.GetNextWord);
      if S = '(' then ASQLParser.GetToBracket(')')
      else
      if (S = 'BEGIN') or (S = 'CASE') or (S = 'IF') or (S = 'LOOP') or (S = 'REPEAT') or (S = 'WHILE') then Inc(c)
      else
      if (S = 'END') then
      begin
        Dec(C);
        CP1:=ASQLParser.Position;
        S:=UpperCase(ASQLParser.GetNextWord);
        if (S = 'CASE') and (S<>'IF') and (S = 'LOOP') and (S = 'REPEAT') and (S = 'WHILE') then
        begin
          ASQLParser.Position:=CP1;
        end;
      end;
      if C = 0 then
      begin
        ASQLParser.Position:=CP1;
        Break;
      end;
    end;
    Result:=Copy(ASQLParser.SQL, CP.Position, ASQLParser.Position.Position - CP.Position);
end;

begin
  case AChild.Tag of
    1:Definer:=AWord;
    2:ObjectKind:=okStoredProc;
    3:ObjectKind:=okFunction;
    4:Name:=AWord;
    5:begin
        FCurField:=Params.AddParam('');
        FCurField.InReturn:=spvtInput;
      end;
    6:begin
        FCurField:=Params.AddParam('');
        FCurField.InReturn:=spvtOutput;
      end;
    7:begin
        FCurField:=Params.AddParam('');
        FCurField.InReturn:=spvtInOut;
      end;
    8:begin
        if not Assigned(FCurField) then
        begin
          FCurField:=Params.AddParam(AWord);
          FCurField.InReturn:=spvtInput;
        end
        else
          FCurField.Caption:=AWord;
      end;
    9:FCurField:=nil;
    10:Description:=ExtractQuotedString(AWord, '''');
    11:DetermType:=ptNotDeterministic;
    12:if DetermType = ptUnknow then DetermType:=ptDeterministic;
    13:SqlAccess:=saContainsSql;
    14:SqlAccess:=saNoSql;
    15:SqlAccess:=saReadsSqlData;
    16:SqlAccess:=saModifiesSqlData;
    17:Security:=psDefiner;
    18:Security:=psInvoker;
    20:Body:=GetProcBody;
    21:Definer:=Definer + AWord;
    102:if Assigned(FCurField) then FCurField.TypeName:=AWord;
    103:if Assigned(FCurField) then FCurField.TypeName:=FCurField.TypeName + ' ' + AWord;
    104:if Assigned(FCurField) then FCurField.TypeLen:=StrToInt(AWord);
    105:if Assigned(FCurField) then FCurField.TypePrec:=StrToInt(AWord);
    106:if Assigned(FCurField) then FCurField.Params:=FCurField.Params + [fpUnsigned];
    107:if Assigned(FCurField) then FCurField.Params:=FCurField.Params + [fpZeroFill];
    108:if Assigned(FCurField) then FCurField.Params:=FCurField.Params + [fpBinary];
    109:if Assigned(FCurField) then FCurField.CharSetName:=AWord;
    110:if Assigned(FCurField) then FCurField.Collate:=AWord;

    202:FReturnType.TypeName:=AWord;
    203:FReturnType.TypeName:=FCurField.TypeName + ' ' + AWord;
    204:FReturnType.TypeLen:=StrToInt(AWord);
    205:FReturnType.TypePrec:=StrToInt(AWord);
    206:FReturnType.Params:=FCurField.Params + [fpUnsigned];
    207:FReturnType.Params:=FCurField.Params + [fpZeroFill];
    208:FReturnType.Params:=FCurField.Params + [fpBinary];
    209:FReturnType.CharSetName:=AWord;
    210:FReturnType.Collate:=AWord;
  end;
end;

procedure TMySQLCreateFunction.MakeSQL;
var
  S, S1: String;
  P: TSQLParserField;
begin
  S:='CREATE';
  if Definer <> '' then
    S:=S + ' DEFINER = ' + Definer;
  S:=S + ' ' + MySQLObjectNames[ObjectKind] + ' ' + FullName + '(';

  S1:='';
  for P in Params do
  begin
    if S1<>'' then S1:=S1 + ',' + LineEnding;
    S1:=S1 + '  ';
    if ObjectKind = okStoredProc then
    begin
      case P.InReturn of
        spvtInput:S1:=S1 + 'IN ';
        spvtOutput:S1:=S1 + 'OUT ';
        spvtInOut:S1:=S1 + 'INOUT ';
      end;
    end;
    S1:=S1 + P.Caption + ' ' + P.FullTypeName;
    if P.CharSetName <> '' then
      S1:=S1 + ' CHARACTER SET ' + P.CharSetName;
  end;
(*

  CREATE
      [DEFINER = { user | CURRENT_USER }]
      FUNCTION sp_name ([func_parameter[,...]])
      RETURNS type
      [characteristic ...] routine_body
*)
  if S1 <> '' then
    S:=S + LineEnding + S1;
  S:=S + ')' + LineEnding;

  if ObjectKind = okFunction then
    S:=S + 'RETURNS ' + ReturnType.FullTypeName + LineEnding;

  if Description <> '' then
    S:=S + 'COMMENT '+QuotedString(Description, '''') + LineEnding;
  S:=S + 'LANGUAGE SQL' + LineEnding;

  if DetermType = ptNotDeterministic then
    S:=S + 'NOT DETERMINISTIC' + LineEnding
  else
  if DetermType = ptDeterministic then
    S:=S + 'DETERMINISTIC' + LineEnding;

  case SqlAccess of
    saContainsSql:S:=S + 'CONTAINS SQL' + LineEnding;
    saNoSql:S:=S + 'NO SQL' + LineEnding;
    saReadsSqlData:S:=S + 'READS SQL DATA' + LineEnding;
    saModifiesSqlData:S:=S + 'MODIFIES SQL DATA' + LineEnding;
  end;

  case Security of
    psDefiner:S:=S + 'SQL SECURITY DEFINER' + LineEnding;
    psInvoker:S:=S + 'SQL SECURITY INVOKER' + LineEnding;
  end;

  S:=S + Body;
  AddSQLCommand(S)
end;

constructor TMySQLCreateFunction.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSQLCommentOnClass:=TMySQLCommentOn;
  DetermType:=ptUnknow;
  FReturnType:=TSQLParserField.Create;
end;

destructor TMySQLCreateFunction.Destroy;
begin
  FreeAndNil(FReturnType);
  inherited Destroy;
end;

procedure TMySQLCreateFunction.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TMySQLCreateFunction then
  begin
    Definer:=TMySQLCreateFunction(ASource).Definer;
    DetermType:=TMySQLCreateFunction(ASource).DetermType;
    SqlAccess:=TMySQLCreateFunction(ASource).SqlAccess;
    Security:=TMySQLCreateFunction(ASource).Security;
    ReturnType.Assign(TMySQLCreateFunction(ASource).ReturnType);
  end;
  inherited Assign(ASource);
end;

{ TMySQLDropDatabase }

procedure TMySQLDropDatabase.InitParserTree;
var
  FSQLTokens, T1, T, T2, TName: TSQLTokenRecord;
begin
  (*
  DROP {DATABASE | SCHEMA} [IF EXISTS] db_name
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0);
  T1:=AddSQLTokens(stKeyword, FSQLTokens, 'DATABASE', [toFindWordLast], 1);
  T2:=AddSQLTokens(stKeyword, FSQLTokens, 'SCHEMA', [toFindWordLast], 2);
    T:=AddSQLTokens(stKeyword, [T1, T2], 'IF', []);
    T:=AddSQLTokens(stKeyword, T, 'EXISTS', [], -1);
  TName:=AddSQLTokens(stIdentificator, [T, T1, T2], '', [], 3);
end;

procedure TMySQLDropDatabase.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:ObjectKind:=okDatabase;
    2:ObjectKind:=okScheme;
    3:Name:=AWord;
  end;
end;

procedure TMySQLDropDatabase.MakeSQL;
var
  S: String;
begin
  S:='DROP ' + MySQLObjectNames[ObjectKind];
  if ooIfExists in Options then
    S:=S + ' IF EXISTS';
  S:=S + ' ' + Name;
  AddSQLCommand(S);
end;

constructor TMySQLDropDatabase.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okDatabase;
end;

{ TMySQLAlterDatabase }

procedure TMySQLAlterDatabase.InitParserTree;
var
  FSQLTokens, T1, T2, TName, TUpg, T, TDef, TChar, TSymb,
    TColl: TSQLTokenRecord;
begin
  (*
  ALTER {DATABASE | SCHEMA} [db_name]
      alter_specification ...
  ALTER {DATABASE | SCHEMA} db_name
      UPGRADE DATA DIRECTORY NAME

  alter_specification:
      [DEFAULT] CHARACTER SET [=] charset_name
    | [DEFAULT] COLLATE [=] collation_name
  *)

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken], 0);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'DATABASE', [toFindWordLast], 1);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'SCHEMA', [toFindWordLast], 2);
  TName:=AddSQLTokens(stIdentificator, [T1, T2], '', [], 3);
    TUpg:=AddSQLTokens(stKeyword, TName, 'UPGRADE', []);
      T:=AddSQLTokens(stKeyword, TUpg, 'DATA', []);
      T:=AddSQLTokens(stKeyword, T, 'DIRECTORY', []);
      T:=AddSQLTokens(stKeyword, T, 'NAME', [], 4);

  TDef:=AddSQLTokens(stKeyword, [TName, T1, T2], 'DEFAULT', [toOptional]);
  TChar:=AddSQLTokens(stKeyword, [TName, TDef], 'CHARACTER', [toOptional]);
    T:=AddSQLTokens(stKeyword, TChar, 'SET', []);
    TSymb:=AddSQLTokens(stSymbol, T, '=', []);
    T:=AddSQLTokens(stIdentificator, [T, TSymb], '', [], 5);
    T.AddChildToken(TDef);

  TColl:=AddSQLTokens(stKeyword, [TName, TDef, T1, T2], 'COLLATE', [toOptional]);
    TSymb:=AddSQLTokens(stSymbol, TColl, '=', []);
    T:=AddSQLTokens(stIdentificator, [TColl, TSymb], '', [], 6);
    T.AddChildToken([TDef, TChar]);
end;

procedure TMySQLAlterDatabase.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:ObjectKind:=okDatabase;
    2:ObjectKind:=okScheme;
    3:Name:=AWord;
    4:FUpgradeDataDirectory:=true;
    5:CharsetName:=AWord;
    6:CollationName:=AWord;
  end;
end;

procedure TMySQLAlterDatabase.MakeSQL;
var
  S: String;
begin
  S:='ALTER ' + MySQLObjectNames[ObjectKind] + ' ' + Name;
  if UpgradeDataDirectory then
    S:=S + ' UPGRADE DATA DIRECTORY NAME'
  else
  begin
    if CharsetName <> '' then
      S:=S + ' DEFAULT CHARACTER SET = ' + CharsetName;

    if CollationName <> '' then
      S:=S + ' DEFAULT COLLATE = ' + CollationName;
  end;
  AddSQLCommand(S);
end;

constructor TMySQLAlterDatabase.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okDatabase;
end;

procedure TMySQLAlterDatabase.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TMySQLAlterDatabase then
  begin
    CharsetName:=TMySQLAlterDatabase(ASource).CharsetName;
    CollationName:=TMySQLAlterDatabase(ASource).CollationName;
    UpgradeDataDirectory:=TMySQLAlterDatabase(ASource).UpgradeDataDirectory;

  end;
  inherited Assign(ASource);
end;

{ TMySQLCreateDatabase }

procedure TMySQLCreateDatabase.InitParserTree;
var
  FSQLTokens, T1, T2, T, TName, TChar, TDef, TColl: TSQLTokenRecord;
begin
  (*
  CREATE {DATABASE | SCHEMA} [IF NOT EXISTS] db_name
      [create_specification] ...

  create_specification:
      [DEFAULT] CHARACTER SET [=] charset_name
    | [DEFAULT] COLLATE [=] collation_name
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0);    //CREATE
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'DATABASE', [toFindWordLast], 1);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'SCHEMA', [toFindWordLast], 2);
    T:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'IF', []);
    T:=AddSQLTokens(stKeyword, T, 'NOT', []);
    T:=AddSQLTokens(stKeyword, T, 'EXISTS', [], 3);

  TName:=AddSQLTokens(stIdentificator, [T, T1, T2], '', [], 4);
  TDef:=AddSQLTokens(stKeyword, TName, 'DEFAULT', [toOptional]);
  TChar:=AddSQLTokens(stKeyword, [TName, TDef], 'CHARACTER', [toOptional]);
    T:=AddSQLTokens(stKeyword, TChar, 'SET', []);
    T1:=AddSQLTokens(stSymbol, T, '=', []);
    T:=AddSQLTokens(stIdentificator, [T, T1], '', [], 5);
    T.AddChildToken(TDef);

  TColl:=AddSQLTokens(stKeyword, [TName, TDef, T], 'COLLATE', [toOptional]);
    T1:=AddSQLTokens(stSymbol, TColl, '=', []);
    T:=AddSQLTokens(stIdentificator, [TColl, T1], '', [], 6);
    T.AddChildToken([TDef, TChar]);
end;

procedure TMySQLCreateDatabase.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; const AWord: string);
begin
  case AChild.Tag of
    1:ObjectKind:=okDatabase;
    2:ObjectKind:=okScheme;
    3:Options:=Options + [ooIfNotExists];
    4:Name:=AWord;
    5:CharsetName:=AWord;
    6:CollationName:=AWord;
  end;
end;

procedure TMySQLCreateDatabase.MakeSQL;
var
  S: String;
begin
  S:='CREATE ' + MySQLObjectNames[ObjectKind];
  if ooIfNotExists in Options then
    S:=S + ' IF NOT EXISTS';

  S:=S + ' ' + Name;

  if CharsetName <> '' then
    S:=S + ' DEFAULT CHARACTER SET = ' + CharsetName;

  if CollationName <> '' then
    S:=S + ' DEFAULT COLLATE = ' + CollationName;

  AddSQLCommand(S);
end;

constructor TMySQLCreateDatabase.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okDatabase;
end;

procedure TMySQLCreateDatabase.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TMySQLCreateDatabase then
  begin
    CharsetName:=TMySQLCreateDatabase(ASource).CharsetName;
    CollationName:=TMySQLCreateDatabase(ASource).CollationName;

  end;
  inherited Assign(ASource);
end;

{ TMySQLCreateView }

procedure TMySQLCreateView.InitParserTree;
var
  FSQLTokens, T1, TOwner, TAlg, T, TAlg1, TAlg2, TAlg3,
    TOwner1, TOwner2, TSeq, TSeq1, TSeq2, TSchema, TName, TAs,
    FSQLTokens1: TSQLTokenRecord;
begin
  (*
  CREATE
      [OR REPLACE]
      [ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}]
      [DEFINER = { user | CURRENT_USER }]
      [SQL SECURITY { DEFINER | INVOKER }]
      VIEW view_name [(column_list)]
      AS select_statement
      [WITH [CASCADED | LOCAL] CHECK OPTION]
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okView);    //CREATE
  FSQLTokens1:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken], 0, okView);    //CREATE
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'OR', []);
    T1:=AddSQLTokens(stKeyword, T1, 'REPLACE', [], -2);

    TAlg:=AddSQLTokens(stKeyword, [FSQLTokens, T1, FSQLTokens1], 'ALGORITHM', []);
      T:=AddSQLTokens(stSymbol, TAlg, '=', []);
      TAlg1:=AddSQLTokens(stKeyword, T, 'UNDEFINED', [], 4);
      TAlg2:=AddSQLTokens(stKeyword, T, 'MERGE', [], 5);
      TAlg3:=AddSQLTokens(stKeyword, T, 'TEMPTABLE', [], 6);

    TOwner:=AddSQLTokens(stKeyword, [FSQLTokens, FSQLTokens1, T1, TAlg1, TAlg2, TAlg3], 'DEFINER', []);
      T:=AddSQLTokens(stSymbol, TOwner, '=', []);
      TOwner1:=AddSQLTokens(stKeyword, T, 'CURRENT_USER', [], 7);
      TOwner2:=AddSQLTokens(stIdentificator, T, '', [], 7);
      TOwner1.AddChildToken(TAlg);
      TOwner2.AddChildToken(TAlg);


    TSeq:=AddSQLTokens(stKeyword, [FSQLTokens, FSQLTokens1, T1, TAlg1, TAlg2, TAlg3, TOwner1, TOwner2], 'SQL', []);
      T:=AddSQLTokens(stKeyword, TSeq, 'SECURITY', []);
      TSeq1:=AddSQLTokens(stKeyword, T, 'DEFINER', [], 8);
      TSeq2:=AddSQLTokens(stKeyword, T, 'INVOKER', [], 8);
      TSeq1.AddChildToken([TAlg, TOwner]);
      TSeq2.AddChildToken([TAlg, TOwner]);

  T:=AddSQLTokens(stKeyword, [FSQLTokens, FSQLTokens1, T1, TAlg1, TAlg2, TAlg3, TOwner1, TOwner2, TSeq1, TSeq2], 'VIEW', [toFindWordLast]);
  TSchema:=AddSQLTokens(stIdentificator, T, '', [], 2);
  T:=AddSQLTokens(stSymbol, TSchema, '.', []);
  TName:=AddSQLTokens(stIdentificator, T, '', [], 3);

  T:=AddSQLTokens(stSymbol, [TSchema, TName], '(', []);
    T:=AddSQLTokens(stIdentificator, T, '', [], 10);
    T1:=AddSQLTokens(stSymbol, T, ',', []);
    T1.AddChildToken(T);
  T:=AddSQLTokens(stSymbol, T, ')', []);

  TAs:=AddSQLTokens(stKeyword, [TSchema, TName, T], 'AS', [], 11);
end;

procedure TMySQLCreateView.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
var
  CP: TParserPosition;
begin
  case AChild.Tag of
    //1:CreateMode:=cmCreateOrAlter;
    2:Name:=AWord;
    3:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
    4:ViewAlgorithm:=vaUndefined;
    5:ViewAlgorithm:=vaMerge;
    6:ViewAlgorithm:=vaTemptable;
    7:OwnerUser:=AWord;
    8:SqlSecurity:=AWord;
    10:Fields.AddParam(AWord);
    11:begin
         CP:=ASQLParser.Position;
         SQLSelect:=ASQLParser.GetToCommandDelemiter;// Copy(ASQLParser.SQL, ASQLParser.CurPos, Length(ASQLParser.SQL));
         ASQLParser.Position:=CP;
         FSQLCommandSelect:=TSQLCommandSelect.Create(nil);
         FSQLCommandSelect.ParseSQL(ASQLParser);
       end;
  end;
end;

procedure TMySQLCreateView.MakeSQL;
var
  S: String;
begin
  S:='CREATE';
  if ooOrReplase in Options then
    S:=S + ' OR REPLACE';

  case ViewAlgorithm of
//    vaUndefined:S:=S + ' ALGORITHM = UNDEFINED';
    vaMerge:S:=S + ' ALGORITHM = MERGE';
    vaTemptable:S:=S + ' ALGORITHM = TEMPTABLE';
  end;

  if OwnerUser <> '' then
    S:=S + ' DEFINER = '+OwnerUser;

  if SqlSecurity <> '' then
    S:=S + ' SQL SECURITY '+SqlSecurity;

  (*
  CREATE
      [OR REPLACE]
      [ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}]
      [DEFINER = { user | CURRENT_USER }]
      [SQL SECURITY { DEFINER | INVOKER }]
      VIEW view_name [(column_list)]
      AS select_statement
      [WITH [CASCADED | LOCAL] CHECK OPTION]
  *)
  S:=S + ' VIEW ' + FullName;

  if Fields.Count > 0 then
    S:=S + '('+LineEnding + Fields.AsList + ')';

  S:=S  + LineEnding + 'AS'+LineEnding;
  S:=S + SQLSelect;
  AddSQLCommand(S);
end;

procedure TMySQLCreateView.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TMySQLCreateView then
  begin
    SQLCommandSelect.Assign(TMySQLCreateView(ASource));
    ViewAlgorithm:=TMySQLCreateView(ASource).ViewAlgorithm;
    OwnerUser:=TMySQLCreateView(ASource).OwnerUser;
    SqlSecurity:=TMySQLCreateView(ASource).SqlSecurity;

  end;
  inherited Assign(ASource);
end;

{ TMySQLCommentOn }

procedure TMySQLCommentOn.MakeSQL;
var
  S: String;
begin
  case ObjectKind of
    okTable:S:=Format('ALTER TABLE %s COMMENT = %s;', [Name, QuotedString(TrimRight(Description), '''')]);
    okStoredProc:S:=Format('ALTER PROCEDURE %s COMMENT = %s;', [Name, QuotedString(TrimRight(Description), '''')]);
  else
    S:='';
  end;
  AddSQLCommand(S);
end;

{ TMySQLCreateTable }

procedure TMySQLCreateTable.InitParserTree;
var
  FSQLTokens, T, TName, T1, TSchema, TSymb, TSymb2, TColName,
    TConst, TConst1, TPK, TPK1, TSymb3, TUNQ, TUNQ1, TUNQ2,
    TPK2, TRef, TRef1, TRef2, TRef3, TRef2_1, TRef2_2, TRef2_3,
    TRef3_1, TRef3_2, TRef3_3, TRef3_4, TRef3_5, TRef3_6, TCHK,
    TCHK1, TEngineName, TEngineName1, TPar, TPar1, TValIndent,
    TPar2, TDesc, TDesc1, TPar3, TPar4,
    TPar5, TPar6, TPar7, TPar8, TValNum, TValStr, TPar9,
    TPar9_1, TPar10, TPar11, TPar12, TSymbIndent, TIndOptUse,
    TIndOptUseBtree, TIndOptUseHash, TIndOptUseRTree, TUNQName: TSQLTokenRecord;
begin
  (*
  CREATE [TEMPORARY] TABLE [IF NOT EXISTS] tbl_name
      (create_definition,...)
      [table_options]
      [partition_options]

  CREATE [TEMPORARY] TABLE [IF NOT EXISTS] tbl_name
      [(create_definition,...)]
      [table_options]
      [partition_options]
      [IGNORE | REPLACE]
      [AS] query_expression

  CREATE [TEMPORARY] TABLE [IF NOT EXISTS] tbl_name
      { LIKE old_tbl_name | (LIKE old_tbl_name) }

  create_definition:
      col_name column_definition
    | [CONSTRAINT [symbol]] PRIMARY KEY [index_type] (index_col_name,...)
        [index_option] ...
    | {INDEX|KEY} [index_name] [index_type] (index_col_name,...)
        [index_option] ...
    | [CONSTRAINT [symbol]] UNIQUE [INDEX|KEY]
        [index_name] [index_type] (index_col_name,...)
        [index_option] ...
    | {FULLTEXT|SPATIAL} [INDEX|KEY] [index_name] (index_col_name,...)
        [index_option] ...
    | [CONSTRAINT [symbol]] FOREIGN KEY
        [index_name] (index_col_name,...) reference_definition
    | CHECK (expr)

  column_definition:
      data_type [NOT NULL | NULL] [DEFAULT default_value]
        [AUTO_INCREMENT] [UNIQUE [KEY] | [PRIMARY] KEY]
        [COMMENT 'string']
        [COLUMN_FORMAT {FIXED|DYNAMIC|DEFAULT}]
        [STORAGE {DISK|MEMORY|DEFAULT}]
        [reference_definition]
    | data_type [GENERATED ALWAYS] AS (expression)
        [VIRTUAL | STORED] [UNIQUE [KEY]] [COMMENT comment]
        [NOT NULL | NULL] [[PRIMARY] KEY]

  data_type:
      BIT[(length)]
    | TINYINT[(length)] [UNSIGNED] [ZEROFILL]
    | SMALLINT[(length)] [UNSIGNED] [ZEROFILL]
    | MEDIUMINT[(length)] [UNSIGNED] [ZEROFILL]
    | INT[(length)] [UNSIGNED] [ZEROFILL]
    | INTEGER[(length)] [UNSIGNED] [ZEROFILL]
    | BIGINT[(length)] [UNSIGNED] [ZEROFILL]
    | REAL[(length,decimals)] [UNSIGNED] [ZEROFILL]
    | DOUBLE[(length,decimals)] [UNSIGNED] [ZEROFILL]
    | FLOAT[(length,decimals)] [UNSIGNED] [ZEROFILL]
    | DECIMAL[(length[,decimals])] [UNSIGNED] [ZEROFILL]
    | NUMERIC[(length[,decimals])] [UNSIGNED] [ZEROFILL]
    | DATE
    | TIME[(fsp)]
    | TIMESTAMP[(fsp)]
    | DATETIME[(fsp)]
    | YEAR
    | CHAR[(length)] [BINARY]
        [CHARACTER SET charset_name] [COLLATE collation_name]
    | VARCHAR(length) [BINARY]
        [CHARACTER SET charset_name] [COLLATE collation_name]
    | BINARY[(length)]
    | VARBINARY(length)
    | TINYBLOB
    | BLOB
    | MEDIUMBLOB
    | LONGBLOB
    | TINYTEXT [BINARY]
        [CHARACTER SET charset_name] [COLLATE collation_name]
    | TEXT [BINARY]
        [CHARACTER SET charset_name] [COLLATE collation_name]
    | MEDIUMTEXT [BINARY]
        [CHARACTER SET charset_name] [COLLATE collation_name]
    | LONGTEXT [BINARY]
        [CHARACTER SET charset_name] [COLLATE collation_name]
    | ENUM(value1,value2,value3,...)
        [CHARACTER SET charset_name] [COLLATE collation_name]
    | SET(value1,value2,value3,...)
        [CHARACTER SET charset_name] [COLLATE collation_name]
    | JSON
    | spatial_type

  index_col_name:
      col_name [(length)] [ASC | DESC]

  index_type:
      USING {BTREE | HASH}

  index_option:
      KEY_BLOCK_SIZE [=] value
    | index_type
    | WITH PARSER parser_name
    | COMMENT 'string'

  reference_definition:
      REFERENCES tbl_name (index_col_name,...)
        [MATCH FULL | MATCH PARTIAL | MATCH SIMPLE]
        [ON DELETE reference_option]
        [ON UPDATE reference_option]

  reference_option:
      RESTRICT | CASCADE | SET NULL | NO ACTION

  table_options:
      table_option [[,] table_option] ...

  table_option:
      ENGINE [=] engine_name
    | AUTO_INCREMENT [=] value
    | AVG_ROW_LENGTH [=] value
    | [DEFAULT] CHARACTER SET [=] charset_name
    | CHECKSUM [=] {0 | 1}
    | [DEFAULT] COLLATE [=] collation_name
    | COMMENT [=] 'string'
    | COMPRESSION [=] {'ZLIB'|'LZ4'|'NONE'}
    | CONNECTION [=] 'connect_string'
    | DATA DIRECTORY [=] 'absolute path to directory'
    | DELAY_KEY_WRITE [=] {0 | 1}
    | ENCRYPTION [=] {'Y' | 'N'}
    | INDEX DIRECTORY [=] 'absolute path to directory'
    | INSERT_METHOD [=] { NO | FIRST | LAST }
    | KEY_BLOCK_SIZE [=] value
    | MAX_ROWS [=] value
    | MIN_ROWS [=] value
    | PACK_KEYS [=] {0 | 1 | DEFAULT}
    | PASSWORD [=] 'string'
    | ROW_FORMAT [=] {DEFAULT|DYNAMIC|FIXED|COMPRESSED|REDUNDANT|COMPACT}
    | STATS_AUTO_RECALC [=] {DEFAULT|0|1}
    | STATS_PERSISTENT [=] {DEFAULT|0|1}
    | STATS_SAMPLE_PAGES [=] value
    | TABLESPACE tablespace_name [STORAGE {DISK|MEMORY|DEFAULT}]
    | UNION [=] (tbl_name[,tbl_name]...)

  partition_options:
      PARTITION BY
          { [LINEAR] HASH(expr)
          | [LINEAR] KEY [ALGORITHM={1|2}] (column_list)
          | RANGE{(expr) | COLUMNS(column_list)}
          | LIST{(expr) | COLUMNS(column_list)} }
      [PARTITIONS num]
      [SUBPARTITION BY
          { [LINEAR] HASH(expr)
          | [LINEAR] KEY [ALGORITHM={1|2}] (column_list) }
        [SUBPARTITIONS num]
      ]
      [(partition_definition [, partition_definition] ...)]

  partition_definition:
      PARTITION partition_name
          [VALUES
              {LESS THAN {(expr | value_list) | MAXVALUE}
              |
              IN (value_list)}]
          [[STORAGE] ENGINE [=] engine_name]
          [COMMENT [=] 'comment_text' ]
          [DATA DIRECTORY [=] 'data_dir']
          [INDEX DIRECTORY [=] 'index_dir']
          [MAX_ROWS [=] max_number_of_rows]
          [MIN_ROWS [=] min_number_of_rows]
          [TABLESPACE [=] tablespace_name]
          [(subpartition_definition [, subpartition_definition] ...)]

  subpartition_definition:
      SUBPARTITION logical_name
          [[STORAGE] ENGINE [=] engine_name]
          [COMMENT [=] 'comment_text' ]
          [DATA DIRECTORY [=] 'data_dir']
          [INDEX DIRECTORY [=] 'index_dir']
          [MAX_ROWS [=] max_number_of_rows]
          [MIN_ROWS [=] min_number_of_rows]
          [TABLESPACE [=] tablespace_name]

  query_expression:
      SELECT ...   (Some valid select or union statement)
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okTable);    //CREATE
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'TEMPORARY', [], 1);    //CREATE
  T1:=AddSQLTokens(stKeyword, [FSQLTokens, T], 'TABLE', [toFindWordLast]);
    T:=AddSQLTokens(stKeyword, T1, 'IF', []);
    T:=AddSQLTokens(stKeyword, T, 'NOT', []);
    T:=AddSQLTokens(stKeyword, T, 'EXISTS', [], 2);
  TSchema:=AddSQLTokens(stIdentificator, [T, T1], '', [], 3);
    T:=AddSQLTokens(stSymbol, TSchema, '.', []);
  TName:=AddSQLTokens(stIdentificator, [T, T1], '', [], 4);
    T:=AddSQLTokens(stSymbol, [TSchema, TName], '(', []);

  TColName:=AddSQLTokens(stIdentificator, T, '', [], 5);
  TSymb:=AddSQLTokens(stSymbol, nil, ',', [], 6);
    TSymb.AddChildToken(TColName);
  TSymb2:=AddSQLTokens(stSymbol, nil, ')', [], 6);

  MakeTypeDefTree(Self, [TColName], [TSymb, TSymb2], tdfTableColDef, 100);

  TConst:=AddSQLTokens(stKeyword, TSymb, 'CONSTRAINT', []);
    TConst1:=AddSQLTokens(stIdentificator, TConst, '', [], 7);

  TPK:=AddSQLTokens(stKeyword, [TSymb, TConst, TConst1], 'PRIMARY', [], 8);
    TPK1:=AddSQLTokens(stKeyword, TPK, 'KEY', []);
    TPK1:=AddSQLTokens(stSymbol, TPK1, '(', []);
    TPK2:=AddSQLTokens(stIdentificator, TPK1, '', [], 9);
    TSymb3:=AddSQLTokens(stSymbol, TPK2, ',', []);
    TSymb3.AddChildToken(TPK2);
    TPK2:=AddSQLTokens(stSymbol, TPK2, ')', []);
    TPK2.AddChildToken([TSymb, TSymb2 {, TConst}]);

    TIndOptUse:=AddSQLTokens(stKeyword, TPK2, 'USING', [toOptional]);
      TIndOptUseBTree:=AddSQLTokens(stKeyword, TIndOptUse, 'BTREE', [], 20);
      TIndOptUseHash:=AddSQLTokens(stKeyword, TIndOptUse, 'HASH', [], 20);
      TIndOptUseRTree:=AddSQLTokens(stKeyword, TIndOptUse, 'RTREE', [], 20);

      TIndOptUseBtree.AddChildToken([TSymb, TSymb2]);
      TIndOptUseHash.AddChildToken([TSymb, TSymb2]);
      TIndOptUseRTree.AddChildToken([TSymb, TSymb2]);

  //| [CONSTRAINT [symbol]] UNIQUE [INDEX|KEY] [index_name] [index_type] (index_col_name,...) [index_option] ...
  TUNQ:=AddSQLTokens(stKeyword, [TSymb, TConst, TConst1, TPK2], 'UNIQUE', [], 10);
    TUNQ1:=AddSQLTokens(stKeyword, TUNQ, 'INDEX', []);
    TUNQ2:=AddSQLTokens(stKeyword, TUNQ, 'KEY', []);
    TUNQName:=AddSQLTokens(stIdentificator, [TUNQ, TUNQ1, TUNQ2], '', [], 21);
    TIndOptUse:=AddSQLTokens(stKeyword, [TUNQ, TUNQ1, TUNQ2, TUNQName], 'USING', [toOptional]);
      TIndOptUseBTree:=AddSQLTokens(stKeyword, TIndOptUse, 'BTREE', [], 20);
      TIndOptUseHash:=AddSQLTokens(stKeyword, TIndOptUse, 'HASH', [], 20);
      TIndOptUseRTree:=AddSQLTokens(stKeyword, TIndOptUse, 'RTREE', [], 20);

      TUNQ:=AddSQLTokens(stSymbol, [TUNQ, TUNQ1, TUNQ2, TUNQName, TIndOptUseBTree, TIndOptUseHash, TIndOptUseRTree], '(', []);
      TUNQ:=AddSQLTokens(stIdentificator, TUNQ, '', [], 9);
      TUNQ1:=AddSQLTokens(stSymbol, TPK2, ',', []);
      TUNQ1.AddChildToken(TUNQ);
      TUNQ:=AddSQLTokens(stSymbol, TUNQ, ')', []);

      TIndOptUse:=AddSQLTokens(stKeyword, TUNQ, 'USING', [toOptional]);
        TIndOptUseBTree:=AddSQLTokens(stKeyword, TIndOptUse, 'BTREE', [], 20);
        TIndOptUseHash:=AddSQLTokens(stKeyword, TIndOptUse, 'HASH', [], 20);
        TIndOptUseRTree:=AddSQLTokens(stKeyword, TIndOptUse, 'RTREE', [], 20);

      TUNQ.AddChildToken([TSymb, TSymb2, TIndOptUseHash, TIndOptUseBTree, TIndOptUseRTree]);


{      TUNQ.AddChildToken([TSymb, TSymb2, TPK1, TConst]);
      TUNQ1.AddChildToken([TSymb, TSymb2, TPK1, TConst]);
      TUNQ2.AddChildToken([TSymb, TSymb2, TPK1, TConst]);}

  TRef:=AddSQLTokens(stKeyword, [TSymb, TConst, TConst1, TPK2, TUNQ, TUNQ1, TUNQ2], 'FOREIGN', [], 11);
    TRef1:=AddSQLTokens(stKeyword, TRef, 'KEY', []);
    TRef1:=AddSQLTokens(stSymbol, TRef1, '(', []);
    TRef1:=AddSQLTokens(stIdentificator, TRef1, '', [], 9);
    TSymb3:=AddSQLTokens(stSymbol, TRef1, ',', []);
    TSymb3.AddChildToken(TRef1);
    TRef1:=AddSQLTokens(stSymbol, TRef1, ')', []);
    TRef1:=AddSQLTokens(stKeyword, TRef1, 'REFERENCES', []);
    TRef1:=AddSQLTokens(stIdentificator, TRef1, '', [], 12);
    TRef1:=AddSQLTokens(stSymbol, TRef1, '(', []);
    TRef1:=AddSQLTokens(stIdentificator, TRef1, '', [], 128);
    TSymb3:=AddSQLTokens(stSymbol, TRef1, ',', []);
    TSymb3.AddChildToken(TRef1);
    TRef1:=AddSQLTokens(stSymbol, TRef1, ')', []);

    TRef2:=AddSQLTokens(stKeyword, TRef1, 'MATCH', []);
    TRef2_1:=AddSQLTokens(stKeyword, TRef2, 'FULL', [], 129);
    TRef2_2:=AddSQLTokens(stKeyword, TRef2, 'PARTIAL', [], 130);
    TRef2_3:=AddSQLTokens(stKeyword, TRef2, 'SIMPLE', [], 131);
  TRef3:=AddSQLTokens(stSymbol, [TRef1, TRef2_1, TRef2_2, TRef2_3], 'ON', []);
    TRef3_1:=AddSQLTokens(stSymbol, TRef3, 'DELETE', [], 137);
    TRef3_2:=AddSQLTokens(stSymbol, TRef3, 'UPDATE', [], 138);
    TRef3_3:=AddSQLTokens(stSymbol, [TRef3_1, TRef3_2], 'RESTRICT', [], 133);
    TRef3_4:=AddSQLTokens(stSymbol, [TRef3_1, TRef3_2], 'CASCADE', [], 134);
    TRef3_5:=AddSQLTokens(stSymbol, [TRef3_1, TRef3_2], 'SET', []);
    TRef3_5:=AddSQLTokens(stSymbol, TRef3_5, 'NULL', [], 135);
    TRef3_6:=AddSQLTokens(stSymbol, [TRef3_1, TRef3_2], 'NO', []);
    TRef3_6:=AddSQLTokens(stSymbol, TRef3_6, 'ACTION', [], 136);
    TRef3_3.AddChildToken([TRef3, TRef2]);
    TRef3_4.AddChildToken([TRef3, TRef2]);
    TRef3_5.AddChildToken([TRef3, TRef2]);
    TRef3_6.AddChildToken([TRef3, TRef2]);
  TRef1.AddChildToken([TUNQ, TPK1, TUNQ1, TUNQ2]);
  TRef2_1.AddChildToken([TSymb, TSymb2, TUNQ, TPK, TConst]);
  TRef2_2.AddChildToken([TSymb, TSymb2, TUNQ, TPK, TConst]);
  TRef2_3.AddChildToken([TSymb, TSymb2, TUNQ, TPK, TConst]);
  TRef3_3.AddChildToken([TSymb, TSymb2, TUNQ, TPK, TConst]);
  TRef3_4.AddChildToken([TSymb, TSymb2, TUNQ, TPK, TConst]);
  TRef3_5.AddChildToken([TSymb, TSymb2, TUNQ, TPK, TConst]);
  TRef3_6.AddChildToken([TSymb, TSymb2, TUNQ, TPK, TConst]);

  TCHK:=AddSQLTokens(stKeyword, [TSymb, TConst, TConst1, TPK2, TRef2_1, TRef2_2,
     TRef2_3, TRef3_3, TRef3_4, TRef3_5, TRef3_6], 'CHECK', []);
    TCHK1:=AddSQLTokens(stSymbol, TCHK, '(', [], 13);
  TCHK1.AddChildToken([TSymb, TSymb2, TUNQ, TPK, TRef, TConst]);

(*
--  | [CONSTRAINT [symbol]] PRIMARY KEY [index_type] (index_col_name,...) [index_option] ...
  | {INDEX|KEY} [index_name] [index_type] (index_col_name,...) [index_option] ...
--  | [CONSTRAINT [symbol]] UNIQUE [INDEX|KEY] [index_name] [index_type] (index_col_name,...) [index_option] ...
  | {FULLTEXT|SPATIAL} [INDEX|KEY] [index_name] (index_col_name,...) [index_option] ...
--  | [CONSTRAINT [symbol]] FOREIGN KEY [index_name] (index_col_name,...) reference_definition
*)
///  CREATE [TEMPORARY] TABLE [IF NOT EXISTS] tbl_name
//      (create_definition,...)
//      [table_options]
//      [partition_options]

  TEngineName:=AddSQLTokens(stKeyword, TSymb2, 'ENGINE', [toOptional]);
    TSymb3:=AddSQLTokens(stSymbol, TEngineName, '=', []);
    TEngineName1:=AddSQLTokens(stIdentificator, [TEngineName, TSymb3], '', [], 14);

  TDesc:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2], 'COMMENT', [toOptional]);
    TSymb3:=AddSQLTokens(stSymbol, TDesc, '=', []);
    TDesc1:=AddSQLTokens(stString, [TDesc, TSymb3], '', [], 17);
    TDesc1.AddChildToken([TEngineName]);

  TPar1:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TDesc1], 'AUTO_INCREMENT', [toOptional], 15);
      TSymbIndent:=AddSQLTokens(stSymbol, TPar1, '=', []);
    TValIndent:=AddSQLTokens(stIdentificator, [TPar1, TSymbIndent], '', [], 16);
    TValIndent.AddChildToken([TEngineName, TDesc]);

  TPar3:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TValIndent, TDesc1], 'CHECKSUM', [toOptional], 15);
    TSymb3:=AddSQLTokens(stSymbol, TPar3, '=', []);
    TValNum:=AddSQLTokens(stInteger, [TPar3, TSymb3], '', [], 16);
    TValNum.AddChildToken([TEngineName, TDesc, TPar1]);

  TPar2:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TDesc1, TValIndent, TValNum], 'AVG_ROW_LENGTH', [toOptional], 15);
    TSymb3:=AddSQLTokens(stSymbol, TPar2, '=', []);
    TPar2.AddChildToken(TValNum);
    TSymb3.AddChildToken(TValNum);

  TPar4:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TDesc1, TValIndent, TValNum], 'DELAY_KEY_WRITE', [toOptional], 15);
    TSymb3:=AddSQLTokens(stSymbol, TPar4, '=', []);
    TPar4.AddChildToken(TValNum);
    TSymb3.AddChildToken(TValNum);

  TPar5:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TDesc1, TValIndent, TValNum], 'PASSWORD', [toOptional], 15);
    TSymb3:=AddSQLTokens(stSymbol, TPar5, '=', []);
    TValStr:=AddSQLTokens(stString, [TPar5, TSymb3], '', [], 16);
    TValStr.AddChildToken([TEngineName, TDesc, TPar1, TPar2, TPar3, TPar4]);

  TPar6:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TDesc1, TValIndent, TValNum, TValStr], 'CONNECTION', [toOptional], 15);
    TSymb3:=AddSQLTokens(stSymbol, TPar6, '=', []);
    TPar6.AddChildToken(TValStr);
    TSymb3.AddChildToken(TValStr);

  TPar7:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TDesc1, TValIndent, TValNum, TValStr], 'ENCRYPTION', [toOptional], 15);
    TPar7.AddChildToken(TSymb3);
    TPar7.AddChildToken(TValStr);

  TPar8:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TDesc1, TValIndent, TValNum, TValStr], 'COMPRESSION', [toOptional], 15);
    TPar8.AddChildToken(TSymb3);
    TPar8.AddChildToken(TValStr);

  TPar9:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TDesc1, TValIndent, TValNum, TValStr], 'DATA', [toOptional], 15);
    TPar9_1:=AddSQLTokens(stKeyword, TPar9, 'DIRECTORY', [toOptional], 15);
    TPar9_1.AddChildToken(TSymb3);
    TPar9_1.AddChildToken(TValStr);

  TPar10:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TDesc1, TValIndent, TValNum, TValStr], 'INDEX', [toOptional], 15);
    TPar10.AddChildToken(TPar9_1);

  TPar11:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TDesc1, TValIndent, TValNum, TValStr], 'PACK_KEYS', [toOptional], 15);
    TSymb3:=AddSQLTokens(stSymbol, TPar11, '=', []);
    TPar11.AddChildToken([TValNum, TValIndent]);
    TSymb3.AddChildToken([TValNum, TValIndent]);
  TPar12:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TDesc1, TValIndent, TValNum, TValStr], 'STATS_AUTO_RECALC', [toOptional], 15);
    TPar12.AddChildToken([TSymb3, TValNum, TValIndent]);
  TPar12:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TDesc1, TValIndent, TValNum, TValStr], 'STATS_PERSISTENT', [toOptional], 15);
    TPar12.AddChildToken([TSymb3, TValNum, TValIndent]);

  TPar1:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TDesc1, TValIndent, TValNum, TValStr], 'INSERT_METHOD', [toOptional], 15);
  TPar1.AddChildToken([TSymbIndent, TValIndent]);

  TPar1:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TDesc1, TValIndent, TValNum, TValStr], 'KEY_BLOCK_SIZE', [toOptional], 15);
  TPar1.AddChildToken([TSymbIndent, TValIndent]);

  TPar1:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TDesc1, TValIndent, TValNum, TValStr], 'MAX_ROWS', [toOptional], 15);
  TPar1.AddChildToken([TSymbIndent, TValIndent]);
  TPar1:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TDesc1, TValIndent, TValNum, TValStr], 'MIN_ROWS', [toOptional], 15);
  TPar1.AddChildToken([TSymbIndent, TValIndent]);
  TPar1:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TDesc1, TValIndent, TValNum, TValStr], 'ROW_FORMAT', [toOptional], 15);
  TPar1.AddChildToken([TSymbIndent, TValIndent]);
  TPar1:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TDesc1, TValIndent, TValNum, TValStr], 'STATS_SAMPLE_PAGES', [toOptional], 15);
  TPar1.AddChildToken([TSymbIndent, TValIndent]);

  TPar1:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TDesc1, TValIndent, TValNum, TValStr], 'DEFAULT', [toOptional], 15);
    TPar2:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TDesc1, TValIndent, TValNum, TValStr, TPar1], 'CHARACTER', [toOptional], 15);
    TPar2:=AddSQLTokens(stKeyword, TPar2, 'SET', [toOptional], 15);
    TPar2.AddChildToken([TSymbIndent, TValIndent]);

    TPar2:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TDesc1, TValIndent, TValNum, TValStr, TPar1], 'COLLATE', [toOptional], 15);
    TPar2.AddChildToken([TSymbIndent, TValIndent]);

    TPar2:=AddSQLTokens(stKeyword, [TEngineName1, TSymb2, TDesc1, TValIndent, TValNum, TValStr, TPar1], 'CHARSET', [toOptional], 15);
    TPar2.AddChildToken([TSymbIndent, TValIndent]);


(*
| TABLESPACE tablespace_name [STORAGE {DISK|MEMORY|DEFAULT}]
| UNION [=] (tbl_name[,tbl_name]...)
*)
end;

procedure TMySQLCreateTable.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; const AWord: string);
begin
  case AChild.Tag of
    1:Options:=Options + [ooTemporary];
    2:Options:=Options + [ooIfNotExists];
    3:Name:=AWord;
    4:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
    5:FCurField:=Fields.AddParam(AWord);
    6:begin
        FCurField:=nil;
        FCurConstr:=nil;
      end;
    7:FCurConstr:=SQLConstraints.Add(ctNone, AWord);
    8:begin
        if not Assigned(FCurConstr) then
          FCurConstr:=SQLConstraints.Add(ctPrimaryKey);
        FCurConstr.ConstraintType:=ctPrimaryKey;
      end;
    9:if Assigned(FCurConstr) then FCurConstr.ConstraintFields.AddParam(AWord);
   10:begin
        if not Assigned(FCurConstr) then
          FCurConstr:=SQLConstraints.Add(ctUnique);
        FCurConstr.ConstraintType:=ctUnique;
      end;
   11:begin
        if not Assigned(FCurConstr) then
          FCurConstr:=SQLConstraints.Add(ctForeignKey);
        FCurConstr.ConstraintType:=ctForeignKey;
      end;
   12:if Assigned(FCurConstr) then FCurConstr.ForeignTable:=AWord;
   13:begin
        if not Assigned(FCurConstr) then
          FCurConstr:=SQLConstraints.Add(ctTableCheck);
        FCurConstr.ConstraintType:=ctTableCheck;
        FCurConstr.ConstraintExpression:=ASQLParser.GetToBracket(')');
      end;
    14:FEngineName:=AWord;
    15:begin
         if FCurPar<>'' then FCurPar:=FCurPar + ' ';
         FCurPar:=FCurPar + AWord;
       end;
    16:if FCurPar <> '' then
       begin
         TableParams.Values[FCurPar]:=AWord;
         FCurPar:='';
       end;
    17:Description:=ExtractQuotedString(AWord, '''');
    20:if Assigned(FCurConstr) then
        FCurConstr.IndexType:=AWord;

   102:if Assigned(FCurField) then FCurField.TypeName:=AWord;
   103:if Assigned(FCurField) then FCurField.TypeName:=FCurField.TypeName + ' ' + AWord;
   104:if Assigned(FCurField) then FCurField.TypeLen:=StrToInt(AWord);
   105:if Assigned(FCurField) then FCurField.TypePrec:=StrToInt(AWord);
   106:if Assigned(FCurField) then FCurField.Params:=FCurField.Params + [fpUnsigned];
   107:if Assigned(FCurField) then FCurField.Params:=FCurField.Params + [fpZeroFill];
   108:if Assigned(FCurField) then FCurField.Params:=FCurField.Params + [fpBinary];
   109:if Assigned(FCurField) then FCurField.CharSetName:=AWord;
   110:if Assigned(FCurField) then FCurField.Collate:=AWord;
   111:if Assigned(FCurField) then FCurField.Params:=FCurField.Params + [fpNull];
   112:if Assigned(FCurField) then FCurField.Params:=FCurField.Params + [fpNotNull];
   113:if Assigned(FCurField) then FCurField.Params:=FCurField.Params + [fpAutoInc];
   114:if Assigned(FCurField) then
       begin
          FCurConstr:=SQLConstraints.Add(ctUnique);
          FCurConstr.ConstraintFields.AddParam(FCurField.Caption);
       end;
   115:if Assigned(FCurField) then FCurField.PrimaryKey:=true;
    116:if Assigned(FCurField) then FCurField.Description:=ExtractQuotedString(AWord, '''');
    117:if Assigned(FCurField) then FCurField.DefaultValue:=AWord; // GetToNextToken(ASQLParser, AChild); //ExtractQuotedString(AWord, '''');
    118:if Assigned(FCurField) then FCurField.FieldFormat:=ffFixed;
    119:if Assigned(FCurField) then FCurField.FieldFormat:=ffDynamic;
    120:if Assigned(FCurField) then FCurField.FieldFormat:=ffDefault;
    121:if Assigned(FCurField) then FCurField.FieldStorage:=fsDisk;
    122:if Assigned(FCurField) then FCurField.FieldStorage:=fsMemory;
    123:if Assigned(FCurField) then FCurField.FieldStorage:=fsDefault;
    124:if Assigned(FCurField) then FCurField.ComputedSource:=ASQLParser.GetToBracket(')');
    125:if Assigned(FCurField) then FCurField.Params:=FCurField.Params + [fpVirtual];
    126:if Assigned(FCurField) then FCurField.Params:=FCurField.Params + [fpStored];
    127:if Assigned(FCurField) then
        begin
          FCurConstr:=SQLConstraints.Add(ctForeignKey);
          FCurConstr.ForeignTable:=AWord;
          FCurConstr.ConstraintFields.AddParam(FCurField.Caption);
        end;
    128:if Assigned(FCurConstr) then FCurConstr.ForeignFields.AddParam(AWord);
    129:if Assigned(FCurConstr) then FCurConstr.Match:=maFull;
    130:if Assigned(FCurConstr) then FCurConstr.Match:=maPartial;
    131:if Assigned(FCurConstr) then FCurConstr.Match:=maSimple;
    132:FCurConstr:=nil;
    133:if Assigned(FCurConstr) then
        begin
          if FCurFK = 1 then
            FCurConstr.ForeignKeyRuleOnDelete:=fkrNone
          else
            FCurConstr.ForeignKeyRuleOnUpdate:=fkrNone;
        end;
    134:if Assigned(FCurConstr) then
        begin
          if FCurFK = 1 then
            FCurConstr.ForeignKeyRuleOnDelete:=fkrCascade
          else
            FCurConstr.ForeignKeyRuleOnUpdate:=fkrCascade;
        end;
    135:if Assigned(FCurConstr) then
        begin
          if FCurFK = 1 then
            FCurConstr.ForeignKeyRuleOnDelete:=fkrSetNull
          else
            FCurConstr.ForeignKeyRuleOnUpdate:=fkrSetNull;
        end;
    136:if Assigned(FCurConstr) then
        begin
          if FCurFK = 1 then
            FCurConstr.ForeignKeyRuleOnDelete:=fkrSetDefault
          else
            FCurConstr.ForeignKeyRuleOnUpdate:=fkrSetDefault;
        end;
    137:FCurFK:=1;
    138:FCurFK:=2;
  end;
end;

procedure TMySQLCreateTable.InternalFormatsInit;
begin
  FQuteIdentificatorChar:='`';
end;

procedure TMySQLCreateTable.MakeSQL;
var
  S, S1, S_CONSTR, SPK: String;
  F: TSQLParserField;
  C: TSQLConstraintItem;
begin
  S:='CREATE ';
  if ooTemporary in Options then
    S:=S + 'TEMPORARY ';
  S:=S + 'TABLE ';
  if ooIfExists in Options then
    S:=S + 'IF NOT EXISTS ';
  S:=S + FullName + '(';

  S1:='';
  SPK:='';
  for F in Fields do
  begin
    if S1<>'' then S1:=S1 + ','+LineEnding;
    S1:=S1 + '  ' + F.Caption + ' ' + F.FullTypeName;

    if F.ComputedSource  = '' then
    begin
      if fpUnsigned in F.Params then
        S1:=S1 + ' UNSIGNED';
      if fpZeroFill in F.Params then
        S1:=S1 + ' ZEROFILL';
      if fpBinary in F.Params then
        S1:=S1 + ' BINARY';

      if F.CharSetName <> '' then
        S1:=S1 + ' CHARACTER SET '+ F.CharSetName;
      if F.Collate <> '' then
        S1:=S1 + ' COLLATE '+ F.Collate;

      if fpAutoInc in F.Params then
        S1:=S1 + ' AUTO_INCREMENT';

      case F.FieldFormat of
        //ffDefault:S1:=S1 + ' COLUMN_FORMAT  DEFAULT;
        ffFixed:S1:=S1 + ' COLUMN_FORMAT FIXED';
        ffDynamic:S1:=S1 + ' COLUMN_FORMAT DYNAMIC';
      end;

      case F.FieldStorage of
        //fsDefault:S:=S + ' STORAGE DEFAULT';
        fsDisk:S1:=S1 + ' STORAGE DISK';
        fsMemory:S1:=S1 + ' STORAGE MEMORY';
      end;

      if F.DefaultValue <> '' then
        S1:=S1 + ' DEFAULT ' + F.DefaultValue; //QuotedString(F.DefaultValue, '''');

    end
    else
    begin
      S1:=S1 + ' GENERATED ALWAYS AS ('+F.ComputedSource+')';

      if fpVirtual in F.Params then
        S1:=S1 + ' VIRTUAL'
      else
      if fpVirtual in F.Params then
        S1:=S1 + ' STORED';
    end;

    if fpPrimaryKey in F.Params then
    begin
      if SPK<>'' then SPK:=SPK + ',';
      SPK:=SPK + F.Caption;
    end;

    if fpNull in F.Params then
      S1:=S1 + ' NULL';
    if fpNotNull in F.Params then
      S1:=S1 + ' NOT NULL';

    if F.Description <> '' then
      S1:=S1 + ' COMMENT ' + QuotedString(F.Description, '''');
  end;

  S_CONSTR:='';
  for C in SQLConstraints do
  begin
    if S_CONSTR <> '' then
      S_CONSTR:=S_CONSTR + ',' + LineEnding;

    if ((SPK = '') or (C.ConstraintType<>ctPrimaryKey)) and (C.ConstraintName <> '') then
      S_CONSTR:=S_CONSTR + ' CONSTRAINT ' + C.ConstraintName;

    case C.ConstraintType of
      ctPrimaryKey:if SPK = '' then
        begin
          S_CONSTR:=S_CONSTR + '  PRIMARY KEY (' + C.ConstraintFields.AsString + ')';
          if C.IndexName <> '' then
            S_CONSTR:=S_CONSTR + ' USING ' + IndexSortOrderNames[C.IndexSortOrder]+ ' INDEX '+C.IndexName;
          if C.IndexType <> '' then
            S_CONSTR:=S_CONSTR + ' USING ' + C.IndexType;
        end;
      ctForeignKey:
         begin
           S_CONSTR:=S_CONSTR + '  FOREIGN KEY ('+ C.ConstraintFields.AsString + ') REFERENCES ' + C.ForeignTable;
           if C.ForeignFields.Count > 0 then
             S_CONSTR:=S_CONSTR + ' (' + C.ForeignFields.AsString + ')';

           if C.IndexName <> '' then
             S_CONSTR:=S_CONSTR + ' USING ' + IndexSortOrderNames[C.IndexSortOrder]+ ' INDEX '+C.IndexName;

           if C.ForeignKeyRuleOnUpdate<>fkrNone then S_CONSTR:=S_CONSTR+' ON UPDATE ' + ForeignKeyRuleNames[C.ForeignKeyRuleOnUpdate];
           if C.ForeignKeyRuleOnDelete<>fkrNone then S_CONSTR:=S_CONSTR+' ON DELETE ' + ForeignKeyRuleNames[C.ForeignKeyRuleOnDelete];
         end;
      ctUnique:
         begin
           S_CONSTR:=S_CONSTR + '  UNIQUE KEY';
           if C.IndexName <> '' then
             S_CONSTR:=S_CONSTR + ' '+C.IndexName;
           S_CONSTR:=S_CONSTR + ' ('+C.ConstraintFields.AsString + ')' ;
           if C.IndexType <> '' then
             S_CONSTR:=S_CONSTR + ' USING ' + C.IndexType;
{           if C.IndexName <> '' then
             S_CONSTR:=S_CONSTR + ' USING ' + IndexSortOrderNames[C.IndexSortOrder]+ ' INDEX '+C.IndexName;}
         end;
      ctTableCheck:S_CONSTR:=S_CONSTR + '  CHECK ('+C.ConstraintExpression + ')';
    end;
  end;

  S:=S + LineEnding +  S1;
  if SPK <> '' then
    S:=S +',' + LineEnding + '  PRIMARY KEY (' + SPK + ')';
  if S_CONSTR <> '' then
    S:=S + ','  + LineEnding + LineEnding + S_CONSTR;
  S:=S + LineEnding + ')';

  if EngineName <> '' then
    S:=S + LineEnding + 'ENGINE = ' + EngineName;

  if Description <> '' then
    S:=S + LineEnding + 'COMMENT = ' + QuotedString(Description, '''');

  for S1 in TableParams do
    S:=S + LineEnding + S1;
//      [partition_options]
  AddSQLCommand(S);
end;


constructor TMySQLCreateTable.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okTable;
  FSQLCommentOnClass:=TMySQLCommentOn;
  FTableParams:=TStringList.Create;
end;

destructor TMySQLCreateTable.Destroy;
begin
  FreeAndNil(FTableParams);
  inherited Destroy;
end;

procedure TMySQLCreateTable.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TMySQLCreateTable then
  begin
    EngineName:=TMySQLCreateTable(ASource).EngineName;
    TableParams.Assign(TMySQLCreateTable(ASource).TableParams);

  end;
  inherited Assign(ASource);
end;

end.


