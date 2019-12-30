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
{
  for detail information see:
  http://www.firebirdtest.com/file/documentation/reference_manuals/fblangref25-en/html/fblangref25-ddl.html
}
unit fb_SqlParserUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, fbmSqlParserUnit, SQLEngineCommonTypesUnit, sqlObjects, fb_utils;

const
  FBObjectNames : array [TDBObjectKind] of string =
    ('',            //okNone,
     'DOMAIN',      //okDomain
     'TABLE',       //okTable
     'VIEW',        //okView
     'TRIGGER',     //okTrigger
     'PROCEDURE',   //okStoredProc
     'SEQUENCE',    //okSequence
     'EXCEPTION',   //okException
     'UDF',         //okUDF
     'ROLE',        //okRole
     'USER',        //okUser
     '',            //okScheme,
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
     'PACKAGE',     //okPackage
     'PACKAGE BODY',  //okPackageBody
     '',              //okTransform
     '',              //okOperator
     '',              //okOperatorClass,
     '',              //okOperatorFamily
     '',              //okUserMapping
     '',              //okPartitionTable
     'PROCEDURE PARAMETER', //okProcedureParametr
     'FUNCTION PARAMETER'   //okFunctionParametr
     );

type
  TSetParam = (tsetSqlDialect, tsetTerm);
  TTempTableAction = (oncNone, oncDelete, oncPreserve);


  { TFBLocalVariableParser }
  TFBLocalVariableDescGenerator = (fbldLocal, fbldParams, fbldDescription);

  TFBLocalVariableParser = class(TSQLCommandAbstract)
  private
    FDescType: TFBLocalVariableDescGenerator;
    FCurField:TSQLParserField;
    //FFreeLP: Boolean;
    FOwnerName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure ParseLocalVars(ASQLParser:TSQLParser);
    function ParseLocalVarsEx(ASQL:string):integer;
    property DescType:TFBLocalVariableDescGenerator read FDescType write FDescType;
    property OwnerName:string read FOwnerName write FOwnerName;
  end;

  { TFBSQLCreateTrigger }

  TFBSQLCreateTrigger = class(TSQLCommandCreateProcedure)
  private
    FActive: boolean;
    FPosition: integer;
    FTriggerType: TTriggerTypes;
    procedure ParseLocalVariables(ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
  protected
    procedure SetBody(AValue: string); override;
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property TriggerType:TTriggerTypes read FTriggerType write FTriggerType;
    property Active:boolean read FActive write FActive;
    property Position:integer read FPosition write FPosition;
    property TableName;
  end;

  { TFBSQLAlterTrigger }

  TFBSQLAlterTrigger = class(TFBSQLCreateTrigger)
  protected
{    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;}
  public
  end;


  { TFBSQLDropTrigger }

  TFBSQLDropTrigger = class(TSQLDropTrigger)
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
  end;


  { TSQLCommandExecuteBlock }

  TSQLCommandExecuteBlock = class(TSQLCommandAbstractSelect)
  { TODO : Для парсера блока необходимо обработать ситуацию на возврат результирующего множества или не возврат }
  private
    FCurField: TSQLParserField;
    FSQLBody: string;
    procedure ParseLocalVariables(ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property SQLBody:string read FSQLBody write FSQLBody;
  end;

  { TFBSQLCommandSelect }

  TFBSQLCommandSelect = class(TSQLCommandAbstractSelect)
  private
    FDistinct: boolean;
    FFirstRec: Integer;
    FSkipRec: Integer;
    FCurField: TSQLParserField;
    FCurTable: TTableItem;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property FirstRec:Integer read FFirstRec write FFirstRec;
    property SkipRec:Integer read FSkipRec write FSkipRec;
    property Distinct:boolean read FDistinct write FDistinct;
  end;

  { TFBSQLCreateView }

  TFBSQLCreateView = class(TSQLCreateView)
  private
    FSQLCommandSelect: TSQLCommandAbstractSelect;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property SQLCommandSelect:TSQLCommandAbstractSelect read FSQLCommandSelect;
  end;

  { TFBSQLDropView }

  TFBSQLDropView = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    property SchemaName;
  end;

  { TFBSQLCreateProcedure }

  TFBSQLCreateProcedure = class(TSQLCommandCreateProcedure)
  private
    FCurParam: TSQLParserField;
    procedure ParseLocalVariables(ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string); override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
  end;

  { TFBSQLDropProcedure }

  TFBSQLDropProcedure = class(TSQLDropCommandAbstract)
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
  end;

  { TFBSQLCreateFunction }

  TFBSQLCreateFunction = class(TSQLCommandCreateProcedure)
  private
    FCurParam: TSQLParserField;
    FDeterministic: Boolean;
    FEngine: string;
    FExternalName: string;
    FReturnCollate: string;
    FReturnType: string;
    procedure ParseLocalVariables(ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string); override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property ReturnType:string read FReturnType write FReturnType;
    property Deterministic:Boolean read FDeterministic write FDeterministic;
    property ReturnCollate:string read FReturnCollate write FReturnCollate;
    property ExternalName:string read FExternalName write FExternalName;
    property Engine:string read FEngine write FEngine;
  end;

  { TFBSQLDropFunction }

  TFBSQLDropFunction = class(TSQLDropCommandAbstract)
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
  end;

  { TFBSQLCreateGenerator }
  TFBSQLSequenceStyle = (fbssSequence, fbssGenerator);
  TFBSQLCreateGenerator = class(TSQLCreateSequence)
  private
    FSequenceStyle: TFBSQLSequenceStyle;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property SequenceStyle:TFBSQLSequenceStyle read FSequenceStyle write FSequenceStyle;
  end;

  { TFBSQLAlterGenerator }
  TfbAlterGenCommand = (fbagAlter, fbagSetGenerator, fbagRecreate);
  TfbAlterGenParam = (fbagRestart, fbagRestartWith,
    fbagRestartIncrement, fbagRestartIncrementBy);
  TfbAlterGenParams = set of TfbAlterGenParam;

  TFBSQLAlterGenerator = class(TFBSQLCreateGenerator)
  private
    FCommand: TfbAlterGenCommand;
    FCommandParams: TfbAlterGenParams;
    FOldDescription: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property Command:TfbAlterGenCommand read FCommand write FCommand;
    property CommandParams:TfbAlterGenParams read FCommandParams write FCommandParams;
    property OldDescription: string read FOldDescription write FOldDescription;
  end;

  { TFBSQLDropGenerator }

  TFBSQLDropGenerator = class(TSQLDropCommandAbstract)
  private
    FOldStyle: boolean;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property OldStyle:boolean read FOldStyle write FOldStyle;
  end;

  TFBSQLDatabaseFilesEnumerator = class;
  TFileSizeUnit = (fsuDefault, fsuPage);

  { TFBSQLDatabaseFile }

  TFBSQLDatabaseFile = class
  private
    FFileName: string;
    FSize: integer;
    FSizeUnit: TFileSizeUnit;
    FStart: integer;
    FStartUnit: TFileSizeUnit;
  public
    procedure Assign(ASource:TFBSQLDatabaseFile);
    property FileName:string read FFileName write FFileName;
    property Size:integer read FSize write FSize;
    property Start:integer read FStart write FStart;
    property SizeUnit:TFileSizeUnit read FSizeUnit write FSizeUnit;
    property StartUnit:TFileSizeUnit read FStartUnit write FStartUnit;
  end;

  { TFBSQLDatabaseFiles }

  TFBSQLDatabaseFiles = class
  private
    FList:TFPList;
    function GetCount: integer;
    function GetItems(AIndex: Integer): TFBSQLDatabaseFile;
  public
    constructor Create;
    destructor Destroy;override;
    procedure Clear;
    procedure Assign(ASource:TFBSQLDatabaseFiles);
    property Items[AIndex:Integer]:TFBSQLDatabaseFile read GetItems; default;
    function Add(AFileName:string):TFBSQLDatabaseFile;
    function GetEnumerator: TFBSQLDatabaseFilesEnumerator;
    property Count:integer read GetCount;
  end;

  { TFBSQLDatabaseFilesEnumerator }

  TFBSQLDatabaseFilesEnumerator = class
  private
    FList: TFBSQLDatabaseFiles;
    FPosition: Integer;
  public
    constructor Create(AList: TFBSQLDatabaseFiles);
    function GetCurrent: TFBSQLDatabaseFile;
    function MoveNext: Boolean;
    property Current: TFBSQLDatabaseFile read GetCurrent;
  end;

  { TFBSQLCreateDatabase }

  TFBSQLCreateDatabase = class(TSQLCreateDatabase)
  private
    FCurParam: TSQLParserField;
    FCurFile: TFBSQLDatabaseFile;
    FFiles: TFBSQLDatabaseFiles;
  protected
    procedure SetName(AValue: string); override;
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    destructor Destroy;override;
    procedure Assign(ASource:TSQLObjectAbstract);override;
    property UserName;
    property RoleName;
    property Password;
    property Files:TFBSQLDatabaseFiles read FFiles;
  end;

  TFBSQLAlterDatabaseCommand  = (fbadaAddFile,
    fbadaAddDifferenceFile,
    fbadaDropDifferenceFile,
    fbadaBeginBackup,
    fbadaEndBackup,
    fbadaSetDefaultCharacter,
    fbadaSetLingerToSeconds,
    fbadaDropLinger,
    fbadaEncryptWithPlugin,
    fbadaDecrypt
  );

  { TFBSQLAlterDatabase }

  TFBSQLAlterDatabase = class(TSQLCreateDatabase)
  private
    FAlterCommand: TFBSQLAlterDatabaseCommand;
    FFiles: TFBSQLDatabaseFiles;
    FCurFile: TFBSQLDatabaseFile;
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    destructor Destroy;override;
    procedure Assign(ASource:TSQLObjectAbstract);override;
    property Files:TFBSQLDatabaseFiles read FFiles;
    property AlterCommand:TFBSQLAlterDatabaseCommand read FAlterCommand write FAlterCommand;
  end;

  { TFBSQLDropDatabase }

  TFBSQLDropDatabase = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
  end;

  { TFBSQLCreateShadow }
  TFBSQLCreateShadowMode = (cshmNone, cshmAuto, cshmManual);

  TFBSQLCreateShadow = class(TSQLCreateCommandAbstract)
  private
    FCreateMode: TFBSQLCreateShadowMode;
    //FShadowFileName: string;
    FShadowNum: Integer;
    FCurFile: TSQLParserField;
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property ShadowNum:Integer read FShadowNum write FShadowNum;
    property CreateMode:TFBSQLCreateShadowMode read FCreateMode write FCreateMode;
    //property ShadowFileName:string read FShadowFileName write FShadowFileName;
  end;

  { TFBSQLDropShadow }

  TFBSQLDropShadowType =  (dshtNone, dshtPreserve, dshtDelete);
  TFBSQLDropShadow = class(TSQLDropCommandAbstract)
  private
    FShadowNum: Integer;
    FShadowType: TFBSQLDropShadowType;
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property ShadowNum:Integer read FShadowNum write FShadowNum;
    property ShadowType:TFBSQLDropShadowType read FShadowType write FShadowType;
  end;

  //Domain
  { TFBSQLCreateDomain }

  TFBSQLCreateDomain = class(TSQLCreateDomain)
  private
    FArrayMax: integer;
    FArrayMin: integer;
    FComputedSrc: string;
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract);override;
    property ComputedSrc:string read FComputedSrc write FComputedSrc;
    property ArrayMin:integer read FArrayMin write FArrayMin;
    property ArrayMax:integer read FArrayMax write FArrayMax;
  end;

  { TFBSQLAlterDomain }

  TFBSQLAlterDomain = class(TSQLAlterDomain)
  private
    FCurOperator: TAlterDomainOperator;
    FCurField: TSQLParserField;
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
  end;

  { TFBSQLDropDomain }

  TFBSQLDropDomain = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
  end;

  { TFBAutoIncObject }

  TFBAutoIncObject = class(TAutoIncObject)
  public
    procedure MakeObjects;override;
  end;

  { TFBSQLCreateTable }

  TFBSQLCreateTable = class(TSQLCreateTable)
  private
    FFileName: string;
    FOnCommit: TTempTableAction;
    FCurField: TSQLParserField;
    FCurConst: TSQLConstraintItem;
    FCurFK:integer;
    FServerVersion: TFBServerVersion;
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    function GetAutoIncObject:TAutoIncObject; override;
    property FileName : string read FFileName write FFileName;
    property OnCommit:TTempTableAction read FOnCommit write FOnCommit;
    property ServerVersion:TFBServerVersion read FServerVersion write FServerVersion;
  end;

  { TFBSQLAlterTable }

  TFBSQLAlterTable = class(TSQLAlterTable)
  private
    FCurOperator : TAlterTableOperator;
    FCurConstr: TSQLConstraintItem;
    FCurFK: Integer;
    FServerVersion: TFBServerVersion;
    procedure AddCollumn(OP: TAlterTableOperator);
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property ServerVersion:TFBServerVersion read FServerVersion write FServerVersion;
  end;

  { TFBSQLDropTable }

  TFBSQLDropTable = class(TSQLDropCommandAbstract)
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
  end;

  { TFBSQLCreateException }

  TFBSQLCreateException = class(TSQLCreateCommandAbstract)
  private
    FMessage: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property Message:string read FMessage write FMessage;
  end;

  { TFBSQLAlterException }

  TFBSQLAlterException = class(TFBSQLCreateException)
  private
    FOldDescription: string;
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property OldDescription: string read FOldDescription write FOldDescription;
  end;

  { TFBSQLDropException }

  TFBSQLDropException = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
  end;


  { TFBSQLCreateRole }

  TFBSQLCreateRole = class(TSQLCreateCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
  end;

  { TFBSQLDropRole }

  TFBSQLDropRole = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
  end;

  { TFBSQLCommentOn }

  TFBSQLCommentOn = class(TSQLCommentOn)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    property TableName;
  end;

  { TFBSQLCreateUDF }

  TFBSQLCreateUDF = class(TSQLCreateCommandAbstract)
  private
    FCurParam: TSQLParserField;
    FEntryPoint: string;
    FLibraryName: string;
    FResultFreeIt: boolean;
    FResultParam: TSQLParserField;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    destructor Destroy;override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property ResultParam: TSQLParserField read FResultParam;
    property ResultFreeIt: boolean read FResultFreeIt write FResultFreeIt;
    property EntryPoint:string read FEntryPoint write FEntryPoint;
    property LibraryName:string read FLibraryName write FLibraryName;
  end;


  { TFBSQLAlterUDF }

  TFBSQLAlterUDF = class(TSQLCommandDDL)
  private
    FEntryPoint: string;
    FLibraryName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property EntryPoint:string read FEntryPoint write FEntryPoint;
    property LibraryName:string read FLibraryName write FLibraryName;
  end;

  { TFBSQLDropUDF }

  TFBSQLDropUDF = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
  end;

  { TFBSQLAlterCharset }

  TFBSQLAlterCharset = class(TSQLCommandDDL)
  private
    FCollation: string;
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property Collation:string read FCollation write FCollation;
  end;

  { TFBSQLCreateCollation }

  TFBSQLCreateCollation = class(TSQLCreateCommandAbstract)
  private
    FCharSet: string;
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property CharSet:string read FCharSet write FCharSet;
  end;

  { TFBSQLSet }

  TFBSQLSet = class(TSQLCommandDDL)
  private
    FSetParam: TSetParam;
    FValue: string;
    FValue2: string;
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property Value:string read FValue write FValue;
    property Value2:string read FValue2 write FValue2;
    property SetParam:TSetParam read FSetParam write FSetParam;
  end;

  { TFBSQLSetTransaction }

  TFBSQLSetTransaction = class(TSQLStartTransaction)
  private
    FIgnoreLimbo: boolean;
    FLockTimeout: integer;
    FNoAutoUndo: boolean;
    FTableStability: boolean;
    FUseIsolationLivel: boolean;
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property UseIsolationLivel:boolean read FUseIsolationLivel write FUseIsolationLivel;
    property NoAutoUndo:boolean read FNoAutoUndo write FNoAutoUndo;
    property LockTimeout:integer read FLockTimeout write FLockTimeout;
    property IgnoreLimbo:boolean read FIgnoreLimbo write FIgnoreLimbo;
    property TableStability:boolean read FTableStability write FTableStability;
  end;

  { TFBSQLCommit }
  TFBSQLCommitType = (cctNone, cctRetain, cctRetainSnaphot);

  TFBSQLCommit = class(TSQLCommit)
  private
    FCommitType: TFBSQLCommitType;
    FRelaseTran: boolean;
    FWorkTran: boolean;
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property WorkTran:boolean read FWorkTran write FWorkTran;
    property RelaseTran:boolean read FRelaseTran write FRelaseTran;
    property CommitType:TFBSQLCommitType read FCommitType write FCommitType;
  end;

  { TFBSQLRollback }
  TFBRollbackType = (rrtNone, rrtRetain, rrtRetainSnaphot, rrtToSavepoint);

  TFBSQLRollback = class(TSQLRollback)
  private
    FRelaseTran: boolean;
    FTranType: TFBRollbackType;
    FWorkTran: boolean;
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property RelaseTran:boolean read FRelaseTran write FRelaseTran;
    property WorkTran:boolean read FWorkTran write FWorkTran;
    property TranType:TFBRollbackType read FTranType write FTranType;
  end;

  { TFBSQLSavepoint }

  TFBSQLSavepoint = class(TSQLSavepoint)
  private
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
  end;

  { TFBSQLRelaseSavepoint }

  TFBSQLRelaseSavepoint = class(TSQLRelaseSavepoint)
  private
    FRelaseOnly: boolean;
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property RelaseOnly:boolean read FRelaseOnly write FRelaseOnly;
  end;

  { TFBSQLGrant }

  TFBSQLGrant = class(TSQLCommandGrant)
  private
    FUserGrantor: string;
    FCurTable: TTableItem;
    FCurGrantor: TSQLParserField;
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property UserGrantor:string read FUserGrantor write FUserGrantor;
  end;

  { TFBSQLRevoke }

  TFBSQLRevoke = class(TSQLCommandGrant)
  private
    //FCurParam: TSQLParserField;
    FCurTable: TTableItem;
    FUserGrantor: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property UserGrantor:string read FUserGrantor write FUserGrantor;
  end;


  { TFBSQLExecuteProcedure }

  TFBSQLExecuteProcedure = class(TSQLCommandAbstractSelect)
  private
    function GetProcName: string;
    procedure SetProcName(AValue: string);
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property ProcName:string read GetProcName write SetProcName;
  end;

  { TFBSQLCreateIndex }

  TFBSQLCreateIndex = class(TSQLCreateIndex)
  private
    FActive: boolean;
    FIndexExpression: string;
    FSortOrder: TIndexSortOrder;
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property SortOrder:TIndexSortOrder read FSortOrder write FSortOrder;
    property IndexExpression:string read FIndexExpression write FIndexExpression;
    property Active:boolean read FActive write FActive;
  end;

  { TFBSQLAlterIndex }

  TFBSQLAlterIndex = class(TSQLCreateIndex)
  private
    FActive: boolean;
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property Active:boolean read FActive write FActive;
  end;

  { TFBSQLDropIndex }

  TFBSQLDropIndex = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
  end;


  { TFBSQLCreatePackage }

  TFBSQLCreatePackage = class(TSQLCreateCommandAbstract)
  private
    FcurItem: TSQLParserField;
    FPackageText: string;
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property PackageText:string read FPackageText write FPackageText;
  end;

  { TFBSQLDropPackage }

  TFBSQLDropPackage = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
  end;

  { TFBSQLDeclareFilter }

  TFBSQLDeclareFilter = class(TSQLCreateCommandAbstract)
  private
    FEntryPoint: string;
    FInputType: string;
    FModuleName: string;
    FOutputType: string;
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property InputType:string read FInputType write FInputType;
    property OutputType:string read FOutputType write FOutputType;
    property EntryPoint:string read FEntryPoint write FEntryPoint;
    property ModuleName:string read FModuleName write FModuleName;
  end;

  { TFBSQLDropFilter }

  TFBSQLDropFilter = class(TSQLDropCommandAbstract)
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
  end;


implementation
uses rxstrutils, SQLEngineInternalToolsUnit;

type
  TTypeDefMode = (tdfDomain, tdfParams, tdfTypeOnly, tdfTableColDef);

{ TFBSQLCreateDomain }

procedure MakeTypeDefTree(ACmd:TSQLCommandAbstract;
  AFirstTokens: array of TSQLTokenRecord;
  AEndTokens : array of TSQLTokenRecord;
  AMode : TTypeDefMode;
  TagBase:integer);
var
  T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, TL, TP, TS, T12,
    T13, T14, T15, TS1, T16, T17_1, T18, T17, T19, TS2,
    TD, TD1, TD2, TD3, TD4, TNN, TCHK, TCO, TDomain1, TDomain2,
    TDomain3, TCollumn1, TCollumn2, TCollumn3, TCollumn4, T20,
    TCompBy1, TCompBy2, TCompBy3, TCompBy4, TCompBy5, TConst,
    TNN1, TCO1, TConst1, TConstPK, TConstPK1, TConstUNC,
    TConstRef, TConstRef1, TConstRef2, TConstRef3, TConstRef4,
    TConstRef5, TConstRef6, TConstRef7, TConstRef8, TConstRef9,
    TCHK1, TBlob1, TBlob, TBlob2, TBlob3, TBlob3_1, TCSet,
    TCSet1, TBlob4, TBlob4_1, TArr1, TArr2, TArr2_1, TArr1_1,
    TUseInd, TUseInd1, TUseInd2, TUseInd3, TUseInd4, TUseInd5,
    TUseInd6, TGenBy1, TGenBy2: TSQLTokenRecord;
  i: Integer;
begin
{Тэги
  2 - Тип
  3 - Продолжение типа
  4 - длинна
  5 - десятичная часть
  7 - charset_name
  8 - NOT NULL
  9 - CHECK (<dom_condition>)
  10 - COLLATE collation_name

  11 - BLOB SUB_TYPE subtype_num
  12 - BLOB SUB_TYPE subtype_name

  13 - DEFAULT
  14 - {COMPUTED [BY] | GENERATED ALWAYS AS} (<expression>)
  15 - CONSTRAINT constr_name
  16 - PRIMARY KEY
  17 - REFERENCES >other_table< [(colname)]
  18 - REFERENCES other_table [(>colname<)]
      //[ON DELETE {NO ACTION | CASCADE | SET DEFAULT | SET NULL}]
      //[ON UPDATE {NO ACTION | CASCADE | SET DEFAULT | SET NULL}]
  19 - ON UPDATE
  20 - ON DELETE
  21 - NO ACTION
  22 - CASCADE
  23 - SET DEFAULT
  24 - SET NULL
  25 - UNIQUE
  26 - Type of Collumn

  30 - BLOB SEGMENT SIZE seglen
  31 - ArrayDimStart
  32 - ArrayDimEnd

  33 - <using_index> ::= USING [>ASC[ENDING]< | DESC[ENDING]] INDEX indexname
  34 - <using_index> ::= USING [ASC[ENDING] | >DESC[ENDING]<] INDEX indexname
     35 - INDEX indexname

  36 - INTEGER GENERATED BY DEFAULT AS IDENTITY
  37 - [(START WITH startvalue )]
  302 - TypeOF


}
  if Length(AFirstTokens) = 0 then
    raise Exception.Create('procedure MakeTypeDefTree(AFirstToken, AEndToken:TSQLTokenRecord)');
  T2:=ACmd.AddSQLTokens(stStdKeyType, AFirstTokens[0], 'SMALLINT', [], 2 + TagBase);
  T3:=ACmd.AddSQLTokens(stStdKeyType, AFirstTokens[0], 'INTEGER', [], 2 + TagBase);
  T20:=ACmd.AddSQLTokens(stStdKeyType, AFirstTokens[0], 'INT', [], 2 + TagBase);
  T4:=ACmd.AddSQLTokens(stStdKeyType, AFirstTokens[0], 'BIGINT', [], 2 + TagBase);
  T5:=ACmd.AddSQLTokens(stStdKeyType, AFirstTokens[0], 'FLOAT', [], 2 + TagBase);
  T6:=ACmd.AddSQLTokens(stStdKeyType, AFirstTokens[0], 'DOUBLE', [], 2 + TagBase);
    T6:=ACmd.AddSQLTokens(stStdKeyType, T6, 'PRECISION', [], 3 + TagBase);
  T7:=ACmd.AddSQLTokens(stStdKeyType, AFirstTokens[0], 'DATE', [], 2 + TagBase);
  T8:=ACmd.AddSQLTokens(stStdKeyType, AFirstTokens[0], 'TIME', [], 2 + TagBase);
  T9:=ACmd.AddSQLTokens(stStdKeyType, AFirstTokens[0], 'TIMESTAMP', [], 2 + TagBase);

  T10:=ACmd.AddSQLTokens(stStdKeyType, AFirstTokens[0], 'DECIMAL', [], 2 + TagBase);
  T11:=ACmd.AddSQLTokens(stStdKeyType, AFirstTokens[0], 'NUMERIC', [], 2 + TagBase);
  TL:=ACmd.AddSQLTokens(stSymbol, T10, '(', [toOptional]);
    T11.AddChildToken(TL);
    TL:=ACmd.AddSQLTokens(stInteger, TL, '', [], 4 + TagBase);
    TP:=ACmd.AddSQLTokens(stSymbol, TL, ',', [toOptional]);
    TP:=ACmd.AddSQLTokens(stInteger, TP, '', [], 5 + TagBase);
    TS:=ACmd.AddSQLTokens(stSymbol, TP, ')', []);
      TL.AddChildToken(TS);

  T12:=ACmd.AddSQLTokens(stStdKeyType, AFirstTokens[0], 'CHAR', [], 2 + TagBase);
  T13:=ACmd.AddSQLTokens(stStdKeyType, AFirstTokens[0], 'CHARACTER', [], 2 + TagBase);
  T14:=ACmd.AddSQLTokens(stStdKeyType, AFirstTokens[0], 'VARCHAR', [], 2 + TagBase);
  T15:=ACmd.AddSQLTokens(stStdKeyType, AFirstTokens[0], 'CHARACTER', [], 2 + TagBase);
  T15:=ACmd.AddSQLTokens(stStdKeyType, T15, 'VARYING', [], 3 + TagBase);
    TL:=ACmd.AddSQLTokens(stSymbol, [T12, T13, T14, T15], '(', []);
    TL:=ACmd.AddSQLTokens(stInteger, TL, '', [], 4 + TagBase);
    TS1:=ACmd.AddSQLTokens(stSymbol, TL, ')', []);

  TCSet:=ACmd.AddSQLTokens(stKeyword, [TS1, T12, T13, T14, T15], 'CHARACTER', [toOptional]);

    TCSet1:=ACmd.AddSQLTokens(stKeyword, TCSet, 'SET', []);
    TCSet1:=ACmd.AddSQLTokens(stIdentificator, TCSet1, '', [], 7 + TagBase); //[CHARACTER SET charset_name]

  T16:=ACmd.AddSQLTokens(stStdKeyType, AFirstTokens[0], 'NCHAR', [], 2 + TagBase);  //NCHAR
  T17_1:=ACmd.AddSQLTokens(stStdKeyType, AFirstTokens[0], 'NATIONAL', [], 2);
  T18:=ACmd.AddSQLTokens(stStdKeyType, T17_1, 'CHARACTER', [], 3 + TagBase); //NATIONAL CHARACTER
  T17:=ACmd.AddSQLTokens(stStdKeyType, T7, 'CHAR', [], 3 + TagBase);       //NATIONAL CHAR
  T19:=ACmd.AddSQLTokens(stStdKeyType, T16, 'VARYING', [toOptional], 3 + TagBase);
    T17.AddChildToken(T19);
    T18.AddChildToken(T19);
  TL:=ACmd.AddSQLTokens(stSymbol, T16, '(', []);
      T17.AddChildToken(TL);
      T18.AddChildToken(TL);
      T19.AddChildToken(TL);
  TL:=ACmd.AddSQLTokens(stInteger, TL, '', [], 4 + TagBase);
  TS2:=ACmd.AddSQLTokens(stSymbol, TL, ')', []);

  //<array_dim> ::= [[m:]n [, [m:]n ...]]
  TArr1:=ACmd.AddSQLTokens(stSymbol, [T2, T3, T20, T4, T5, T6, T7, T8, T9, T10, T11, TS, T12, T13, T14, T15, TS1, T16, T18, T17, T19, TS2], '[', [toOptional]);
    TArr1_1:=ACmd.AddSQLTokens(stInteger, TArr1, '', [], 31 + TagBase);
    TArr2:=ACmd.AddSQLTokens(stSymbol, TArr1_1, ':', []);
    TArr2:=ACmd.AddSQLTokens(stInteger, TArr2, '', [], 32 + TagBase);
    TArr2_1:=ACmd.AddSQLTokens(stSymbol, [TArr1_1, TArr2], ',', []);
    TArr2_1.AddChildToken(TArr1_1);
    TArr2:=ACmd.AddSQLTokens(stSymbol, [TArr1_1, TArr2], ']', []);
  TArr2.AddChildToken(TCSet);

  (*
    | BLOB [SUB_TYPE {subtype_num | subtype_name}] [SEGMENT SIZE seglen] [CHARACTER SET charset_name]
    | BLOB [(seglen [, subtype_num])]
  *)
  TBlob:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'BLOB', [], 2 + TagBase);
    TBlob1:=ACmd.AddSQLTokens(stKeyword, TBlob, 'SUB_TYPE', []);
    TBlob2:=ACmd.AddSQLTokens(stInteger, TBlob1, '', [], 11 + TagBase); //subtype_num
    TBlob1:=ACmd.AddSQLTokens(stIdentificator, TBlob1, '', [], 12 + TagBase); //subtype_name
    TBlob3:=ACmd.AddSQLTokens(stKeyword, [TBlob, TBlob1, TBlob2], 'SEGMENT', []);
    TBlob3_1:=ACmd.AddSQLTokens(stKeyword, TBlob3, 'SIZE', []);
    TBlob3_1:=ACmd.AddSQLTokens(stInteger, TBlob3_1, '', [], 30 + TagBase); //SEGMENT SIZE seglen
    TBlob4:=ACmd.AddSQLTokens(stKeyword, TBlob, '(', []);
    TBlob4:=ACmd.AddSQLTokens(stInteger, TBlob4, '', [], 30 + TagBase);
    TBlob4_1:=ACmd.AddSQLTokens(stSymbol, TBlob4, ',', []);
    TBlob4_1:=ACmd.AddSQLTokens(stInteger, TBlob4_1, '', [], 11 + TagBase);
    TBlob4:=ACmd.AddSQLTokens(stSymbol, [TBlob4, TBlob4_1], ')', []);

  TBlob.AddChildToken(TCSet);
  TBlob1.AddChildToken(TCSet);
  TBlob2.AddChildToken(TCSet);
  TBlob3.AddChildToken(TBlob1);
  TBlob3_1.AddChildToken(TCSet);


  //Fill in first token - start of tree
  for i:=1 to Length(AFirstTokens)-1 do
  begin
    AFirstTokens[i].AddChildToken([T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17_1, T20, TBlob]);
  end;

  if AMode = tdfTypeOnly then
  begin
    for i:=0 to Length(AEndTokens)-1 do
    begin
      T2.AddChildToken(AEndTokens[i]);
      T3.AddChildToken(AEndTokens[i]);
      T4.AddChildToken(AEndTokens[i]);
      T5.AddChildToken(AEndTokens[i]);
      T6.AddChildToken(AEndTokens[i]);
      T7.AddChildToken(AEndTokens[i]);
      T8.AddChildToken(AEndTokens[i]);
      T9.AddChildToken(AEndTokens[i]);
      T10.AddChildToken(AEndTokens[i]);
      T11.AddChildToken(AEndTokens[i]);
      T12.AddChildToken(AEndTokens[i]);
      T13.AddChildToken(AEndTokens[i]);
      T14.AddChildToken(AEndTokens[i]);
      T15.AddChildToken(AEndTokens[i]);
      TS.AddChildToken(AEndTokens[i]);
      TS1.AddChildToken(AEndTokens[i]);
      T16.AddChildToken(AEndTokens[i]);
      T17.AddChildToken(AEndTokens[i]);
      T18.AddChildToken(AEndTokens[i]);
      T19.AddChildToken(AEndTokens[i]);
      T20.AddChildToken(AEndTokens[i]);
      TS2.AddChildToken(AEndTokens[i]);
      TBlob.AddChildToken(AEndTokens[i]);
      TBlob1.AddChildToken(AEndTokens[i]);
      TBlob2.AddChildToken(AEndTokens[i]);
      TBlob3_1.AddChildToken(AEndTokens[i]);
      TBlob3.AddChildToken(AEndTokens[i]);
      TBlob4.AddChildToken(AEndTokens[i]);
      TArr2.AddChildToken(AEndTokens[i]);
    end;
    exit;
  end;

  if AMode in [tdfParams, tdfTableColDef] then
  begin
    TDomain1:=ACmd.AddSQLTokens(stKeyword, AFirstTokens[0], 'TYPE', [], 2 + TagBase);
    TDomain2:=ACmd.AddSQLTokens(stKeyword, TDomain1, 'OF', [], 302 + TagBase);

    TCollumn1:=ACmd.AddSQLTokens(stKeyword, TDomain2, 'COLUMN', [], 3 + TagBase);
    TCollumn2:=ACmd.AddSQLTokens(stIdentificator, TCollumn1, '', [], 3 + TagBase);
    TCollumn3:=ACmd.AddSQLTokens(stSymbol, TCollumn2, '.', [], 26 + TagBase);
    TCollumn4:=ACmd.AddSQLTokens(stIdentificator, TCollumn3, '', [], 26 + TagBase);

    TDomain3:=ACmd.AddSQLTokens(stIdentificator, [AFirstTokens[0], TDomain2], '', [], 3 + TagBase);

    for i:=1 to Length(AFirstTokens)-1 do
      AFirstTokens[i].AddChildToken([TDomain1, TDomain3, TCollumn4]);

    TDomain3.AddChildToken(TArr1);
    TCollumn4.AddChildToken(TArr1);
  end;

  TD:=ACmd.AddSQLTokens(stKeyword, [TCSet1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13,
    T14, T15, TS, TS1, T16, T17, T18, T19, T20, TS2, TArr2,
    TBlob, TBlob1, TBlob2, TBlob3_1, TBlob3, TBlob4], 'DEFAULT', [toOptional]); //[DEFAULT {literal | NULL | <context_var>}]

    if AMode = tdfParams then
    begin
      TDomain3.AddChildToken(TD);
      TCollumn4.AddChildToken(TD);
    end;

  TD1:=ACmd.AddSQLTokens(stString, TD, '', [], 13 + TagBase);
  TD2:=ACmd.AddSQLTokens(stKeyword, TD, 'NULL', [], 13 + TagBase);
  TD3:=ACmd.AddSQLTokens(stIdentificator, TD, '', [], 13 + TagBase);
  TD4:=ACmd.AddSQLTokens(stInteger, TD, '', [], 13 + TagBase);


  TNN:=ACmd.AddSQLTokens(stKeyword,
      [TCSet1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T20,
       TS, TS1, T16, T17, T18, T19, TS2, TD1, TD2, TD3, TD4, TArr2,
    TBlob, TBlob1, TBlob2, TBlob3_1, TBlob3, TBlob4], 'NOT', [toOptional]);
  if AMode in [tdfParams, tdfTableColDef] then
     TDomain3.AddChildToken(TNN);

  TNN1:=ACmd.AddSQLTokens(stKeyword, TNN, 'NULL', [], 8 + TagBase); //[NOT NULL]
    TNN1.AddChildToken(TD);

  TCHK:=ACmd.AddSQLTokens(stKeyword, [TNN1, TCSet1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T20,
       TS, TS1, T16, T17, T18, T19, TS2, TD1, TD2, TD3, TD4,TArr2,
    TBlob, TBlob1, TBlob2, TBlob3_1, TBlob3, TBlob4], 'CHECK', [toOptional]); //[CHECK (<dom_condition>)]
    TCHK1:=ACmd.AddSQLTokens(stSymbol, TCHK, '(', [], 9 + TagBase);
  if AMode = tdfParams then
  begin
    TDomain3.AddChildToken(TCHK);
    TCollumn4.AddChildToken(TCHK);
  end;

  TCO:=ACmd.AddSQLTokens(stKeyword, [TCHK1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14,
      T15, TS, TS1, TCSet1, TNN1, T16, T17, T18, T19, T20, TS2, TD1, TD2, TD3, TD4,TArr2,
    TBlob, TBlob1, TBlob2, TBlob3_1, TBlob3, TBlob4], 'COLLATE', [toOptional]); //[COLLATE collation_name];
    TCO1:=ACmd.AddSQLTokens(stIdentificator, TCO, '', [], 10 + TagBase); //[COLLATE collation_name];

  if AMode = tdfParams then
  begin
    TDomain3.AddChildToken(TCO);
    TCollumn4.AddChildToken(TCO)
  end;

  if AMode = tdfTableColDef then
  begin
    //  {COMPUTED [BY] | GENERATED ALWAYS AS} (<expression>)
    TCompBy1:=ACmd.AddSQLTokens(stKeyword, [T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, TS, TS1, T16, T17, T18, T19, T20, TS2,
    TBlob, TBlob1, TBlob2, TBlob3_1, TBlob3, TBlob4],
      'COMPUTED', []);
    TCompBy2:=ACmd.AddSQLTokens(stKeyword, TCompBy1, 'BY', []);
    TCompBy3:=ACmd.AddSQLTokens(stKeyword, [T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, TS, TS1, T16, T17, T18, T19, T20, TS2,
    TBlob, TBlob1, TBlob2, TBlob3_1, TBlob3, TBlob4],
      'GENERATED', []);
    TCompBy4:=ACmd.AddSQLTokens(stKeyword, TCompBy3, 'ALWAYS', []);
    TCompBy4:=ACmd.AddSQLTokens(stKeyword, TCompBy4, 'AS', []);
    TCompBy5:=ACmd.AddSQLTokens(stSymbol, [TCompBy4, TCompBy2], '(', [], 14 + TagBase);

    for i:=0 to Length(AFirstTokens)-1 do
      AFirstTokens[i].AddChildToken([TCompBy1, TCompBy3]);

    //    NEW_FIELD INTEGER GENERATED BY DEFAULT AS IDENTITY [(START WITH startvalue )]
    TGenBy1:=ACmd.AddSQLTokens(stKeyword, TCompBy3, 'BY', []);
      TGenBy1:=ACmd.AddSQLTokens(stKeyword, TGenBy1, 'DEFAULT', []);
      TGenBy1:=ACmd.AddSQLTokens(stKeyword, TGenBy1, 'AS', []);
      TGenBy1:=ACmd.AddSQLTokens(stKeyword, TGenBy1, 'IDENTITY', [], 36);
      TGenBy2:=ACmd.AddSQLTokens(stSymbol, TGenBy1, '(', []);
      TGenBy2:=ACmd.AddSQLTokens(stKeyword, TGenBy2, 'START', []);
      TGenBy2:=ACmd.AddSQLTokens(stKeyword, TGenBy2, 'WITH', []);
      TGenBy2:=ACmd.AddSQLTokens(stInteger, TGenBy2, '', [], 37);
      TGenBy2:=ACmd.AddSQLTokens(stSymbol, TGenBy2, ')', []);

    //[CONSTRAINT constr_name]
    TConst:=ACmd.AddSQLTokens(stKeyword, [T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, TS,
         TS1, T16, T17, T18, T19, T20, TS2,
         TBlob, TBlob1, TBlob2, TBlob3_1, TBlob3, TBlob4,
         TCollumn4, TDomain3, TD1, TD2, TD3, TD4, TNN1, TCO1,
         TGenBy1, TGenBy2
         ],
      'CONSTRAINT', [toOptional]);
    TConst1:=ACmd.AddSQLTokens(stIdentificator, TConst, '', [], 15 + TagBase);
      TConst1.AddChildToken(TCHK);

    // PRIMARY KEY [<using_index>]
    TConstPK:=ACmd.AddSQLTokens(stKeyword, [T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, TS,
         TS1, T16, T17, T18, T19, T20, TS2,
         TBlob, TBlob1, TBlob2, TBlob3_1, TBlob3, TBlob4,TArr2,
         TCollumn4, TDomain3, TD1, TD2, TD3, TD4, TNN1, TCO1,
         TConst1
         ],
      'PRIMARY', [toOptional]);
    TConstPK1:=ACmd.AddSQLTokens(stIdentificator, TConstPK, 'KEY', [], 16 + TagBase);

    // UNIQUE      [<using_index>]
    TConstUNC:=ACmd.AddSQLTokens(stKeyword, [T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, TS,
         TS1, T16, T17, T18, T19, T20, TS2,
         TBlob, TBlob1, TBlob2, TBlob3_1, TBlob3, TBlob4,TArr2,
         TCollumn4, TDomain3, TD1, TD2, TD3, TD4, TNN1, TCO1,
         TConst1
         ], 'UNIQUE', [toOptional], 25 + TagBase);

    //REFERENCES other_table [(colname)] [<using_index>] [ON DELETE {NO ACTION | CASCADE | SET DEFAULT | SET NULL}] [ON UPDATE {NO ACTION | CASCADE | SET DEFAULT | SET NULL}]
    TConstRef:=ACmd.AddSQLTokens(stKeyword, [T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, TS,
         TS1, T16, T17, T18, T19, T20, TS2,
         TBlob, TBlob1, TBlob2, TBlob3_1, TBlob3, TBlob4,TArr2,
         TCollumn4, TDomain3, TD1, TD2, TD3, TD4, TNN1, TCO1,
         TConst1
         ], 'REFERENCES', [toOptional]);
    TConstRef1:=ACmd.AddSQLTokens(stIdentificator, TConstRef, '', [], 17 + TagBase);
      TConstRef2:=ACmd.AddSQLTokens(stSymbol, TConstRef1, '(', []);
      TConstRef2:=ACmd.AddSQLTokens(stIdentificator, TConstRef2, '', [], 18 + TagBase);
      TConstRef2:=ACmd.AddSQLTokens(stSymbol, TConstRef2, ')', []);
      //[<using_index>]
      //[ON DELETE {NO ACTION | CASCADE | SET DEFAULT | SET NULL}]
      //[ON UPDATE {NO ACTION | CASCADE | SET DEFAULT | SET NULL}]
      TConstRef3:=ACmd.AddSQLTokens(stKeyword, [TConstRef2, TConstRef1], 'ON', []);
        TConstRef4:=ACmd.AddSQLTokens(stKeyword, [TConstRef3, TConstRef1], 'UPDATE', [], 19 + TagBase);
        TConstRef5:=ACmd.AddSQLTokens(stKeyword, [TConstRef3, TConstRef1], 'DELETE', [], 20 + TagBase);

        TConstRef6:=ACmd.AddSQLTokens(stKeyword, [TConstRef4, TConstRef5], 'NO', []);
        TConstRef6:=ACmd.AddSQLTokens(stKeyword, TConstRef6, 'ACTION', [], 21 + TagBase);

        TConstRef7:=ACmd.AddSQLTokens(stKeyword, [TConstRef4, TConstRef5], 'CASCADE', [], 22 + TagBase);

        TConstRef8:=ACmd.AddSQLTokens(stKeyword, [TConstRef4, TConstRef5], 'SET', []);
          TConstRef9:=ACmd.AddSQLTokens(stKeyword, TConstRef8, 'NULL', [], 24 + TagBase);
          TConstRef8:=ACmd.AddSQLTokens(stKeyword, TConstRef8, 'DEFAULT', [], 23 + TagBase);

    TConstPK1.AddChildToken([TD, TNN, TCHK, TCO]);
    TConstUNC.AddChildToken([TD, TNN, TCHK, TCO]);
    TConstRef1.AddChildToken([TD, TNN, TCHK, TCO]);
    TConstRef2.AddChildToken([TD, TNN, TCHK, TCO]);

    TConstRef6.AddChildToken([TD, TNN, TCHK, TCO, TConstRef3]);
    TConstRef7.AddChildToken([TD, TNN, TCHK, TCO, TConstRef3]);
    TConstRef8.AddChildToken([TD, TNN, TCHK, TCO, TConstRef3]);
    TConstRef9.AddChildToken([TD, TNN, TCHK, TCO, TConstRef3]);

    //<using_index> ::= USING [ASC[ENDING] | DESC[ENDING]] INDEX indexname
    TUseInd:=ACmd.AddSQLTokens(stKeyword, [TConstPK1, TConstUNC, TConstRef1, TConstRef2], 'USING', []);
      TUseInd1:=ACmd.AddSQLTokens(stKeyword, TUseInd, 'ASC', [], 33);
      TUseInd2:=ACmd.AddSQLTokens(stKeyword, TUseInd, 'ASCENDING', [], 33);
      TUseInd3:=ACmd.AddSQLTokens(stKeyword, TUseInd, 'DESC', [], 34);
      TUseInd4:=ACmd.AddSQLTokens(stKeyword, TUseInd, 'DESCENDING', [], 34);
      TUseInd5:=ACmd.AddSQLTokens(stKeyword, [TUseInd, TUseInd1, TUseInd2, TUseInd3, TUseInd4], 'INDEX', []);
      TUseInd6:=ACmd.AddSQLTokens(stIdentificator, TUseInd5, '', [], 35);
        TUseInd6.AddChildToken([TConstRef3, TCO]);
  end;

  //fill in tree next token - end
  for i:=0 to Length(AEndTokens)-1 do
  begin
    T2.AddChildToken(AEndTokens[i]);
    T3.AddChildToken(AEndTokens[i]);
    T4.AddChildToken(AEndTokens[i]);
    T5.AddChildToken(AEndTokens[i]);
    T6.AddChildToken(AEndTokens[i]);
    T7.AddChildToken(AEndTokens[i]);
    T8.AddChildToken(AEndTokens[i]);
    T9.AddChildToken(AEndTokens[i]);
    T10.AddChildToken(AEndTokens[i]);
    T11.AddChildToken(AEndTokens[i]);
    T12.AddChildToken(AEndTokens[i]);
    T13.AddChildToken(AEndTokens[i]);
    T14.AddChildToken(AEndTokens[i]);
    T15.AddChildToken(AEndTokens[i]);
    TS.AddChildToken(AEndTokens[i]);
    TS1.AddChildToken(AEndTokens[i]);
    T16.AddChildToken(AEndTokens[i]);
    T17.AddChildToken(AEndTokens[i]);
    T18.AddChildToken(AEndTokens[i]);
    T19.AddChildToken(AEndTokens[i]);
    T20.AddChildToken(AEndTokens[i]);
    TS2.AddChildToken(AEndTokens[i]);
    TD1.AddChildToken(AEndTokens[i]);
    TD2.AddChildToken(AEndTokens[i]);
    TD3.AddChildToken(AEndTokens[i]);
    TD4.AddChildToken(AEndTokens[i]);
    TNN1.AddChildToken(AEndTokens[i]);
    TCO1.AddChildToken(AEndTokens[i]);
    TCHK1.AddChildToken(AEndTokens[i]);
    TBlob.AddChildToken(AEndTokens[i]);
    TBlob1.AddChildToken(AEndTokens[i]);
    TBlob2.AddChildToken(AEndTokens[i]);
    TBlob3_1.AddChildToken(AEndTokens[i]);
    TBlob3.AddChildToken(AEndTokens[i]);
    TBlob4.AddChildToken(AEndTokens[i]);
    TArr2.AddChildToken(AEndTokens[i]);
    //AFirstTokens[i].AddChildToken([TDomain1, TDomain3, TCollumn4]);

    if AMode in [tdfParams, tdfTableColDef] then
    begin
      TDomain3.AddChildToken(AEndTokens[i]);
      TCollumn4.AddChildToken(AEndTokens[i]);
    end;

    if AMode = tdfTableColDef then
    begin
      TCompBy5.AddChildToken(AEndTokens[i]);

      TGenBy1.AddChildToken(AEndTokens[i]);
      TGenBy2.AddChildToken(AEndTokens[i]);

      TConstPK1.AddChildToken(AEndTokens[i]);
      TConstUNC.AddChildToken(AEndTokens[i]);
      TConstRef1.AddChildToken(AEndTokens[i]);
      TConstRef2.AddChildToken(AEndTokens[i]);

      TConstRef6.AddChildToken(AEndTokens[i]);
      TConstRef7.AddChildToken(AEndTokens[i]);
      TConstRef8.AddChildToken(AEndTokens[i]);
      TConstRef9.AddChildToken(AEndTokens[i]);
      TUseInd6.AddChildToken(AEndTokens[i]);
    end;
  end;
end;

{ TFBSQLDropFilter }

procedure TFBSQLDropFilter.InitParserTree;
var
  FSQLTokens, T: TSQLTokenRecord;
begin
  //DROP FILTER filtername ;
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'FILTER', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
end;

procedure TFBSQLDropFilter.MakeSQL;
var
  S: String;
begin
  S:='DROP FILTER ' + Name;
  AddSQLCommand(S);
end;

procedure TFBSQLDropFilter.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
  end;
end;

{ TFBSQLDeclareFilter }

procedure TFBSQLDeclareFilter.InitParserTree;
var
  FSQLTokens, T, T1, T2: TSQLTokenRecord;
begin
  //DECLARE FILTER filtername
  //INPUT_TYPE <sub_type> OUTPUT_TYPE <sub_type>
  //ENTRY_POINT ' function_name ' MODULE_NAME ' library_name ';
  //<sub_type> ::= number | <mnemonic>
  //<mnemonic> ::= binary | text | blr | acl | ranges | summary | format | transaction_description | external_file_description | user_defined

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DECLARE', [toFirstToken]);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'FILTER', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, FSQLTokens, 'FILTER', [], 1);
  T:=AddSQLTokens(stKeyword, T, 'INPUT_TYPE', []);

  T1:=AddSQLTokens(stInteger, T, '', [], 2);
  T2:=AddSQLTokens(stIdentificator, T, '', [], 2);

  T:=AddSQLTokens(stKeyword, [T1, T2], 'OUTPUT_TYPE', []);
  T1:=AddSQLTokens(stInteger, T, '', [], 3);
  T2:=AddSQLTokens(stIdentificator, T, '', [], 3);

  T:=AddSQLTokens(stKeyword, [T1, T2], 'ENTRY_POINT', []);
  T1:=AddSQLTokens(stString, T, '', [], 4);

  T:=AddSQLTokens(stKeyword, T1, 'MODULE_NAME', []);
  T1:=AddSQLTokens(stString, T, '', [], 5);
end;

procedure TFBSQLDeclareFilter.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    2:InputType:=AWord;
    3:OutputType:=AWord;
    4:EntryPoint:=AWord;
    5:ModuleName:=AWord;
  end;
end;

procedure TFBSQLDeclareFilter.MakeSQL;
var
  S: String;
begin
  //DECLARE FILTER filtername
  //INPUT_TYPE <sub_type> OUTPUT_TYPE <sub_type>
  //ENTRY_POINT ' function_name ' MODULE_NAME ' library_name ';
  //<sub_type> ::= number | <mnemonic>
  //<mnemonic> ::= binary | text | blr | acl | ranges | summary | format | transaction_description | external_file_description | user_defined
  S:='DECLARE FILTER '+Name + ' INPUT_TYPE '+ InputType + ' OUTPUT_TYPE ' + OutputType + ' ENTRY_POINT ' + EntryPoint + ' MODULE_NAME ' + ModuleName;
  AddSQLCommand(S);
end;

constructor TFBSQLDeclareFilter.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
end;

procedure TFBSQLDeclareFilter.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLDeclareFilter then
  begin
    InputType:=TFBSQLDeclareFilter(ASource).InputType;
    OutputType:=TFBSQLDeclareFilter(ASource).OutputType;
    EntryPoint:=TFBSQLDeclareFilter(ASource).EntryPoint;
    ModuleName:=TFBSQLDeclareFilter(ASource).ModuleName;
  end;
  inherited Assign(ASource);
end;

{ TFBSQLDropShadow }

procedure TFBSQLDropShadow.InitParserTree;
var
  FSQLTokens, T, T2, T1: TSQLTokenRecord;
begin
  //DROP SHADOW number [{PRESERVE | DELETE} FILE];
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'SHADOW', [toFindWordLast]);
  T:=AddSQLTokens(stInteger, FSQLTokens, '', [], 1);
  T1:=AddSQLTokens(stKeyword, T, 'PRESERVE', [toOptional], 2);
  T2:=AddSQLTokens(stKeyword, T, 'DELETE', [toOptional], 3);
    AddSQLTokens(stKeyword, [T1, T2], 'FILE', [toOptional]);
end;

procedure TFBSQLDropShadow.MakeSQL;
var
  S: String;
begin
  S:='DROP SHADOW '+IntToStr(ShadowNum);
  case ShadowType of
    dshtPreserve:S:=S + ' PRESERVE FILE';
    dshtDelete:S:=S + ' DELETE FILE';
  end;
  AddSQLCommand(S);
end;

procedure TFBSQLDropShadow.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:ShadowNum:=StrToInt(AWord);
    2:ShadowType:=dshtPreserve;
    3:ShadowType:=dshtDelete;
  end;
end;

procedure TFBSQLDropShadow.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLDropShadow then
  begin
    ShadowNum:=TFBSQLDropShadow(ASource).ShadowNum;
    ShadowType:=TFBSQLDropShadow(ASource).ShadowType;
  end;
  inherited Assign(ASource);
end;

{ TFBSQLDropDatabase }

procedure TFBSQLDropDatabase.InitParserTree;
var
  FSQLTokens: TSQLTokenRecord;
begin
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'DATABASE', [toFindWordLast]);
end;

procedure TFBSQLDropDatabase.MakeSQL;
var
  S: String;
begin
  S:='DROP DATABASE';
  AddSQLCommand(S);
end;

procedure TFBSQLDropDatabase.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

{ TFBSQLCreateShadow }

procedure TFBSQLCreateShadow.InitParserTree;
var
  FSQLTokens, T, T1, T2, T3, T4, TLen, TLen1, TLen2_1, TLen2_2,
    TFile1: TSQLTokenRecord;
begin
  //CREATE SHADOW sh_num [AUTO | MANUAL] [CONDITIONAL]
  //' filepath ' [LENGTH [=] num [PAGE[S]]]
  //[ <secondary_file> ];
  //
  //<secondary_file> ::=
  //FILE ' filepath '
  //LENGTH [=] num [PAGE[S]] | STARTING [AT [PAGE]] pagenum

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'SHADOW', [toFindWordLast]);
  T:=AddSQLTokens(stInteger, T, '', [], 1);

  T1:=AddSQLTokens(stKeyword, T, 'AUTO', [], 2);
  T2:=AddSQLTokens(stKeyword, T, 'MANUAL', [], 3);

  T3:=AddSQLTokens(stKeyword, [T1, T2], 'CONDITIONAL', [], 4);
  T4:=AddSQLTokens(stString, [T, T1, T2, T3], '', [], 5);

  TLen:=AddSQLTokens(stKeyword, T4, 'LENGTH', [toOptional]);
    TLen1:=AddSQLTokens(stSymbol, TLen, '=', [], 6);
  TLen1:=AddSQLTokens(stInteger, [TLen, TLen1], '', [], 7);
  TLen2_1:=AddSQLTokens(stKeyword, TLen1, 'PAGE', [toOptional], 8);
  TLen2_2:=AddSQLTokens(stKeyword, TLen1, 'PAGES', [toOptional], 8);

  TFile1:=AddSQLTokens(stKeyword, [T4, TLen1, TLen2_1, TLen2_2], 'FILE', [toOptional]);
    TFile1.AddChildToken(T4);
end;

procedure TFBSQLCreateShadow.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:ShadowNum:=StrToInt(AWord);
    2:FCreateMode:=cshmAuto;
    3:FCreateMode:=cshmManual;
    5:FCurFile:=Params.AddParam(ExtractQuotedString(AWord, ''''));
    6:FCurFile.TypePrec:=1;
    7:FCurFile.TypeLen:=StrToInt(AWord);
    8:FCurFile.TypeName:=AWord;
  end;
end;

procedure TFBSQLCreateShadow.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLCreateShadow then
  begin
    ShadowNum:=TFBSQLCreateShadow(ASource).ShadowNum;
    CreateMode:=TFBSQLCreateShadow(ASource).CreateMode;
    //ShadowFileName:=TFBSQLCreateShadow(ASource).ShadowFileName;
  end;
  inherited Assign(ASource);
end;

procedure TFBSQLCreateShadow.MakeSQL;
var
  S: String;
  i: Integer;
begin
  //CREATE SHADOW sh_num [AUTO | MANUAL] [CONDITIONAL]
  //' filepath ' [LENGTH [=] num [PAGE[S]]]
  //[ <secondary_file> ];
  //
  //<secondary_file> ::=
  //FILE ' filepath '
  //LENGTH [=] num [PAGE[S]] | STARTING [AT [PAGE]] pagenum
  S:='CREATE SHADOW '+IntToStr(ShadowNum);

  case FCreateMode of
    cshmAuto:S:=S + ' AUTO';
    cshmManual:S:=S + ' MANUAL';
  end;

  if Params.Count>0 then
  begin
    FCurFile:=Params[0];
    S:=S + ' ' + AnsiQuotedStr(FCurFile.Caption, '''');
    if FCurFile.TypeLen>0 then
    begin
      S:=S + ' LENGTH ';
      if FCurFile.TypePrec > 0 then S:=S + '= ';
      S:=S + IntToStr(FCurFile.TypeLen);
      if FCurFile.TypeName<>'' then S:=S + ' '+FCurFile.TypeName;
    end;
  end;
  if Params.Count>1 then
    for i:=1 to Params.Count-1 do
    begin
      FCurFile:=Params[i];
      S:=S + ' FILE ' + AnsiQuotedStr(FCurFile.Caption, '''');
      if FCurFile.TypeLen>0 then
      begin
        S:=S + ' LENGTH ';
        if FCurFile.TypePrec > 0 then S:=S + '= ';
        S:=S + IntToStr(FCurFile.TypeLen);
        if FCurFile.TypeName<>'' then S:=S + ' '+FCurFile.TypeName;
      end;
    end;
  AddSQLCommand(S);
end;


{ TFBSQLRelaseSavepoint }

procedure TFBSQLRelaseSavepoint.InitParserTree;
var
  FSQLTokens: TSQLTokenRecord;
begin
  //RELEASE SAVEPOINT sp_name [ONLY]
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'RELEASE', [toFirstToken]);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'SAVEPOINT', [toFindWordLast]);
  FSQLTokens:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
    AddSQLTokens(stKeyword, FSQLTokens, 'ONLY', [toOptional], 2);
end;

procedure TFBSQLRelaseSavepoint.MakeSQL;
var
  S: String;
begin
  S:='RELEASE SAVEPOINT ' + Name;
  if RelaseOnly then
    S:=S + ' ONLY';
  AddSQLCommand(S);
end;

procedure TFBSQLRelaseSavepoint.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    2:RelaseOnly:=true;
  end;
end;

procedure TFBSQLRelaseSavepoint.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLRelaseSavepoint then
  begin
    FRelaseOnly:=TFBSQLRelaseSavepoint(ASource).FRelaseOnly;
  end;
  inherited Assign(ASource);
end;

{ TFBSQLSavepoint }

procedure TFBSQLSavepoint.InitParserTree;
var
  FSQLTokens: TSQLTokenRecord;
begin
  //SAVEPOINT sp_name
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'SAVEPOINT', [toFirstToken, toFindWordLast]);
    AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
end;

procedure TFBSQLSavepoint.MakeSQL;
var
  S: String;
begin
  S:='SAVEPOINT '+Name;
  AddSQLCommand(S);
end;

procedure TFBSQLSavepoint.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
  end;
end;

{ TFBSQLRollback }

procedure TFBSQLRollback.InitParserTree;
var
  FSQLTokens, T1, T2, T2_1, T3, T3_1, T4, T4_1, T5: TSQLTokenRecord;
begin
  //ROLLBACK [WORK] [TRANSACTION tr_name ]
  //[RETAIN [SNAPSHOT] | TO SAVEPOINT sp_name] [RELEASE];
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ROLLBACK', [toFirstToken, toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'WORK', [toOptional], 1);

  T2:=AddSQLTokens(stKeyword, FSQLTokens, 'TRANSACTION', [toOptional]);
    T2_1:=AddSQLTokens(stIdentificator, T2, '', [], 2);

  T3:=AddSQLTokens(stKeyword, FSQLTokens, 'RETAIN', [toOptional], 3);
    T3_1:=AddSQLTokens(stKeyword, T3, 'SNAPSHOT', [toOptional], 4);

  T4:=AddSQLTokens(stKeyword, [FSQLTokens, T1], 'TO', [toOptional]);
    T4_1:=AddSQLTokens(stKeyword, T4, 'SAVEPOINT', []);
    T4_1:=AddSQLTokens(stIdentificator, T4_1, '', [], 5);

  T5:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2_1, T3_1, T4_1], 'RELEASE', [toOptional], 6);
end;

procedure TFBSQLRollback.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:WorkTran:=true;
    2:Name:=AWord;
    3:FTranType:=rrtRetain;
    4:FTranType:=rrtRetainSnaphot;
    5:begin
        FTranType:=rrtToSavepoint;
        SavepointName:=AWord;
      end;
    6:RelaseTran:=true;
  end;
end;

procedure TFBSQLRollback.MakeSQL;
var
  S: String;
begin
  //ROLLBACK [WORK] [TRANSACTION tr_name ]
  //[RETAIN [SNAPSHOT] | TO SAVEPOINT sp_name] [RELEASE];
  S:='ROLLBACK';
  if WorkTran then
    S:=S + ' WORK';

  if Name <> '' then
    S:=S + ' TRANSACTION '+Name;

  if FTranType = rrtRetain then
    S:=S + ' RETAIN'
  else
  if FTranType = rrtRetainSnaphot then
    S:=S + ' RETAIN SNAPSHOT'
  else
  if (FTranType = rrtToSavepoint) and (SavepointName<>'') then
    S:=S + ' TO SAVEPOINT ' + SavepointName;


  if RelaseTran then
    S:=S + ' RELEASE';

  AddSQLCommand(S);
end;

procedure TFBSQLRollback.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLRollback then
  begin
    RelaseTran:=TFBSQLRollback(ASource).RelaseTran;
    WorkTran:=TFBSQLRollback(ASource).WorkTran;
    TranType:=TFBSQLRollback(ASource).TranType;
  end;
  inherited Assign(ASource);
end;

{ TFBSQLCommit }

procedure TFBSQLCommit.InitParserTree;
var
  FSQLTokens, T1, T2, T2_1, T3, T3_1, T4: TSQLTokenRecord;
begin
  //COMMIT [WORK] [TRANSACTION tr_name ]
  //[RELEASE] [RETAIN [SNAPSHOT]];
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'COMMIT', [toFirstToken, toFindWordLast]);
  T1:=AddSQLTokens(stKeyword, FSQLTokens, 'WORK', [toOptional], 1);

  T2:=AddSQLTokens(stKeyword, FSQLTokens, 'TRANSACTION', [toOptional]);
    T2_1:=AddSQLTokens(stIdentificator, T2, '', [], 2);

  T3:=AddSQLTokens(stKeyword, FSQLTokens, 'RETAIN', [toOptional], 3);
    T3_1:=AddSQLTokens(stKeyword, T3, 'SNAPSHOT', [toOptional], 4);

  T4:=AddSQLTokens(stKeyword, [T1, T2, T2_1, T3, T3_1], 'RELEASE', [toOptional], 5);
end;

procedure TFBSQLCommit.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:WorkTran:=true;
    2:Name:=AWord;
    3:CommitType:=cctRetain;
    4:CommitType:=cctRetainSnaphot;
    5:RelaseTran:=true;
  end;
end;

procedure TFBSQLCommit.MakeSQL;
var
  S: String;
begin
  S:='COMMIT';

  if WorkTran then
    S:=S + ' WORK';

  if Name <> '' then
    S:=S + ' TRANSACTION '+Name;

  if CommitType = cctRetain then
    S:=S + ' RETAIN'
  else
  if CommitType = cctRetainSnaphot then
    S:=S + ' RETAIN SNAPSHOT';


  if RelaseTran then
    S:=S + ' RELEASE';

  //COMMIT [WORK] [TRANSACTION tr_name ]
  //[RELEASE] [RETAIN [SNAPSHOT]];
  AddSQLCommand(S);
end;

procedure TFBSQLCommit.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLCommit then
  begin
    WorkTran:=TFBSQLCommit(ASource).WorkTran;
    CommitType:=TFBSQLCommit(ASource).CommitType;
    RelaseTran:=TFBSQLCommit(ASource).RelaseTran;
  end;
  inherited Assign(ASource);
end;

{ TFBSQLAlterDatabase }

procedure TFBSQLAlterDatabase.InitParserTree;
var
  FSQLTokens, TDB, TSCH, TFile1, TFile2, TFile2_3,
    TFile2_1, T, TFile2_2, TFile3, T1, TFile3_1, TAdd,
    TAddDiff: TSQLTokenRecord;
begin
  (*
  ALTER {DATABASE | SCHEMA}
  { <add_sec_clause> [ <add_sec_clausee> ...]}
  | {ADD DIFFERENCE FILE ' diff_file '
  | DROP DIFFERENCE FILE}
  | {{BEGIN | END} BACKUP}
  | {SET DEFAULT CHARACTER SET charset }
  | {SET LINGER TO seconds
  | DROP LINGER}
  | {ENCRYPT WITH plugin_name [KEY key_name ]
  | DECRYPT};

  <add_sec_clause> ::= ADD FILE <sec_file>
  <sec_file> ::= ' filepath '
  [STARTING [AT [PAGE]] pagenum ]
  [LENGTH [=] num [PAGE[S]]

  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken], 0, okDatabase);
    TDB:=AddSQLTokens(stKeyword, FSQLTokens, 'DATABASE', [toFindWordLast]);
    TSCH:=AddSQLTokens(stKeyword, FSQLTokens, 'SCHEMA', [toFindWordLast], 0, okScheme);

  TAdd:=AddSQLTokens(stKeyword, [TDB, TSCH], 'ADD', [toOptional]);
    TFile1:=AddSQLTokens(stString, TAdd, 'FILE', []);
    TFile1:=AddSQLTokens(stString, TFile1, '', [], 10);
      TFile1.AddChildToken(TAdd);
    TFile2:=AddSQLTokens(stKeyword, TFile1, 'LENGTH', [toOptional]);
    T:=AddSQLTokens(stSymbol, TFile2, '=', []);
    TFile2_3:=AddSQLTokens(stInteger, [TFile2, T], '', [], 11);
    TFile2_1:=AddSQLTokens(stKeyword, TFile2, 'PAGE', [], 12);
    TFile2_2:=AddSQLTokens(stKeyword, TFile2, 'PAGES', [], 12);

    TFile3:=AddSQLTokens(stKeyword, [TFile1, TFile2, TFile2_1, TFile2_2, TFile2_3], 'STARTING', [toOptional]);
      T:=AddSQLTokens(stKeyword, TFile3, 'AT', []);
      T1:=AddSQLTokens(stKeyword, [T, TFile3], 'PAGE', [], 13);
    TFile3_1:=AddSQLTokens(stInteger, [TFile3, T, T1], '', [], 14);
      TFile3_1.AddChildToken([TFile2, TAdd]);

      TFile2_3.AddChildToken([TAdd]);
      TFile2_1.AddChildToken([TAdd]);
      TFile2_2.AddChildToken([TAdd]);

    TAddDiff:=AddSQLTokens(stKeyword, TAdd, 'DIFFERENCE', []);
    TAddDiff:=AddSQLTokens(stKeyword, TAddDiff, 'FILE', []);
    TAddDiff:=AddSQLTokens(stString, TAddDiff, '', [], 21);

  T:=AddSQLTokens(stKeyword, [TDB, TSCH], 'DROP', []);
    T1:=AddSQLTokens(stKeyword, T, 'DIFFERENCE', []);
    T1:=AddSQLTokens(stKeyword, T1, 'FILE', [], 22);

    T1:=AddSQLTokens(stKeyword, T, 'LINGER', [], 28);

  T:=AddSQLTokens(stKeyword, [TDB, TSCH], 'BEGIN', []);
    T:=AddSQLTokens(stKeyword, T, 'BACKUP', [], 23);
  T:=AddSQLTokens(stKeyword, [TDB, TSCH], 'END', []);
    T:=AddSQLTokens(stKeyword, T, 'BACKUP', [], 24);

  T:=AddSQLTokens(stKeyword, [TDB, TSCH], 'DECRYPT', [], 25);

  T:=AddSQLTokens(stKeyword, [TDB, TSCH], 'SET', []);
    T1:=AddSQLTokens(stKeyword, T, 'DEFAULT', []);
    T1:=AddSQLTokens(stKeyword, T1, 'CHARACTER', []);
    T1:=AddSQLTokens(stKeyword, T1, 'SET', []);
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 26);

    T1:=AddSQLTokens(stKeyword, T, 'LINGER', []);
    T1:=AddSQLTokens(stKeyword, T1, 'TO', []);
    T1:=AddSQLTokens(stInteger, T1, '', [], 27);

  T:=AddSQLTokens(stKeyword, [TDB, TSCH], 'ENCRYPT', []);
    T1:=AddSQLTokens(stKeyword, T, 'WITH', []);
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 29);
    T1:=AddSQLTokens(stKeyword, T1, 'KEY', [toOptional]);
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 30);
end;

procedure TFBSQLAlterDatabase.MakeSQL;
var
  S: String;
  F: TFBSQLDatabaseFile;
begin
  S:='ALTER';
  if ObjectKind = okScheme then
    S:=S + ' SCHEMA'
  else
    S:=S + ' DATABASE';

  (*
  ALTER {DATABASE | SCHEMA}
  { <add_sec_clause> [ <add_sec_clausee> ...]}
  | {ADD DIFFERENCE FILE ' diff_file '
  | DROP DIFFERENCE FILE}
  | {{BEGIN | END} BACKUP}
  | {SET DEFAULT CHARACTER SET charset }
  | {SET LINGER TO seconds | DROP LINGER}
  | {ENCRYPT WITH plugin_name [KEY key_name ]
  | DECRYPT};

  <add_sec_clause> ::= ADD FILE <sec_file>
  <sec_file> ::= ' filepath '
  [STARTING [AT [PAGE]] pagenum ]
  [LENGTH [=] num [PAGE[S]]

  *)

  if FAlterCommand = fbadaAddFile then
  begin
    for F in Files do
    begin
      S:=S + LineEnding + '  ADD FILE ' + QuotedString(F.FileName, '''');
      if F.Size > 0 then
      begin
        S:=S + ' LENGTH ' + IntToStr(F.Size);
        if F.SizeUnit <> fsuDefault then
          S:=S+ ' PAGES';
      end;

      if F.Start > 0 then
      begin
        S:=S + ' STARTING';
        if F.StartUnit<>fsuDefault then
          S:=S + ' AT PAGE';
        S:=S+ ' ' + IntToStr(F.Start);
      end
    end;
  end
  else
  if (FAlterCommand = fbadaAddDifferenceFile) and (Files.Count>0) then
  begin
    S:=S + LineEnding + '  ADD DIFFERENCE FILE ' + QuotedString(Files[0].FileName, '''');
  end
  else
  if (FAlterCommand = fbadaDropDifferenceFile) then
    S:=S + LineEnding + '  DROP DIFFERENCE FILE'
  else
  if (FAlterCommand = fbadaBeginBackup) then
    S:=S + LineEnding + '  BEGIN BACKUP'
  else
  if (FAlterCommand = fbadaEndBackup) then
    S:=S + LineEnding + '  END BACKUP'
  else
  if (FAlterCommand = fbadaDecrypt) then
    S:=S + LineEnding + '  DECRYPT'
  else
  if (FAlterCommand = fbadaSetDefaultCharacter) then
    S:=S + LineEnding + '  SET DEFAULT CHARACTER SET '+Params[0].Caption
  else
  if (FAlterCommand = fbadaSetLingerToSeconds) then
    S:=S + LineEnding + '  SET LINGER TO '+Params[0].Caption
  else
  if (FAlterCommand = fbadaDropLinger) then
    S:=S + LineEnding + '  DROP LINGER'
  else
  if (FAlterCommand = fbadaEncryptWithPlugin) then
  begin
    S:=S + LineEnding + '  ENCRYPT WITH '+Params[0].Caption;
    if Params.Count>1 then
      S:=S + ' KEY '+Params[1].Caption;
  end
  ;

  AddSQLCommand(S);
end;

procedure TFBSQLAlterDatabase.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    10:begin
         FAlterCommand:=fbadaAddFile;
         FCurFile:=Files.Add(ExtractQuotedString(AWord, ''''));
       end;
    11:if Assigned(FCurFile) then
         FCurFile.Size:=StrToInt(AWord);
    12:if Assigned(FCurFile) then
         FCurFile.SizeUnit:=fsuPage;
    13:if Assigned(FCurFile) then
         FCurFile.StartUnit:=fsuPage;
    14:if Assigned(FCurFile) then
         FCurFile.Start:=StrToInt(AWord);
    21:begin
         FAlterCommand:=fbadaAddDifferenceFile;
         FCurFile:=Files.Add(ExtractQuotedString(AWord, ''''));
       end;
    22:FAlterCommand:=fbadaDropDifferenceFile;
    23:FAlterCommand:=fbadaBeginBackup;
    24:FAlterCommand:=fbadaEndBackup;
    25:FAlterCommand:=fbadaDecrypt;
    26:begin
         FAlterCommand:=fbadaSetDefaultCharacter;
         Params.AddParam(AWord);
       end;
    27:begin
         FAlterCommand:=fbadaSetLingerToSeconds;
         Params.AddParam(AWord);
       end;
    28:FAlterCommand:=fbadaDropLinger;
    29:begin
         FAlterCommand:=fbadaEncryptWithPlugin;
         Params.AddParam(AWord);
       end;
    30:Params.AddParam(AWord);
  end;
end;

constructor TFBSQLAlterDatabase.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FFiles:=TFBSQLDatabaseFiles.Create;
end;

destructor TFBSQLAlterDatabase.Destroy;
begin
  FreeAndNil(FFiles);
  inherited Destroy;
end;

procedure TFBSQLAlterDatabase.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLAlterDatabase then
  begin
    Files.Assign(TFBSQLAlterDatabase(ASource).Files);
    FAlterCommand:=TFBSQLAlterDatabase(ASource).FAlterCommand;
  end;
  inherited Assign(ASource);
end;

{ TFBSQLDatabaseFilesEnumerator }

constructor TFBSQLDatabaseFilesEnumerator.Create(AList: TFBSQLDatabaseFiles);
begin
  FList := AList;
  FPosition := -1;
end;

function TFBSQLDatabaseFilesEnumerator.GetCurrent: TFBSQLDatabaseFile;
begin
  Result := FList[FPosition];
end;

function TFBSQLDatabaseFilesEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TFBSQLDatabaseFiles }

function TFBSQLDatabaseFiles.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TFBSQLDatabaseFiles.GetItems(AIndex: Integer): TFBSQLDatabaseFile;
begin
  Result:=TFBSQLDatabaseFile(FList[AIndex]);
end;

constructor TFBSQLDatabaseFiles.Create;
begin
  inherited Create;
  FList:=TFPList.Create;
end;

destructor TFBSQLDatabaseFiles.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TFBSQLDatabaseFiles.Clear;
var
  i: Integer;
begin
  for i:=0 to FList.Count-1 do
    TFBSQLDatabaseFile(FList[i]).Free;
  FList.Clear;
end;

procedure TFBSQLDatabaseFiles.Assign(ASource: TFBSQLDatabaseFiles);
var
  F, F1: TFBSQLDatabaseFile;
begin
  if not Assigned(ASource) then Exit;
  Clear;
  for F in ASource do
  begin
    F1:=Add(F.FileName);
    F1.Assign(F);
  end;
end;

function TFBSQLDatabaseFiles.Add(AFileName: string): TFBSQLDatabaseFile;
begin
  Result:=TFBSQLDatabaseFile.Create;
  Result.FileName:=AFileName;
  FList.Add(Result);
end;

function TFBSQLDatabaseFiles.GetEnumerator: TFBSQLDatabaseFilesEnumerator;
begin
  Result:=TFBSQLDatabaseFilesEnumerator.Create(Self);
end;

{ TFBSQLDatabaseFile }

procedure TFBSQLDatabaseFile.Assign(ASource: TFBSQLDatabaseFile);
begin
  if not Assigned(ASource) then Exit;
  FileName:=ASource.FileName;
  Size:=ASource.Size;
  Start:=ASource.Start;
  SizeUnit:=ASource.SizeUnit;
  StartUnit:=ASource.StartUnit;
end;

{ TFBSQLCreateDatabase }

procedure TFBSQLCreateDatabase.SetName(AValue: string);
begin
  if FName = AValue then exit;
  FName:=AValue;
end;

procedure TFBSQLCreateDatabase.InitParserTree;
var
  FSQLTokens, T1, T2, TFN, TUN, TUN1, TRN, TRN1, TPWD, TPWD1,
    TUN2, TRN2, TDCS, TDCS1, TDCS2, TCll, TCll1, TPgSz, TPgSz1,
    TFile, TFile1, TFile2, T, TFile3, TFile2_3, TFile3_1,
    TFile2_1, TFile2_2, TDbLen, TDbLen1, TDbLen1_1, TDbLen1_2: TSQLTokenRecord;
begin
(*
CREATE {DATABASE | SCHEMA} ' <filespec> '
[USER username [PASSWORD ' password '] [ROLE rolename ]]
[PAGE_SIZE [=] size ]
[LENGTH [=] num [PAGE[S]]
[SET NAMES ' charset ']
[DEFAULT CHARACTER SET default_charset
[COLLATION collation ]]
[ <sec_file> [ <sec_file> ...]]
[DIFFERENCE FILE ' diff_file '];

<filespec> ::= [ <server_spec> ]{ filepath | db_alias }
<server_spec> ::=
host [\ port | service ]:
| \\ host [@ port | service ]\
| <protocol> ://[ host [: port | service ]/]
<protocol> = inet | inet4 | inet6 | wnet | xnet

<sec_file> ::= FILE ' filepath '
[LENGTH [=] num [PAGE[S]] [STARTING [AT [PAGE]] pagenum ]
*)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okDatabase);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'DATABASE', [toFindWordLast]);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'SCHEMA', [toFindWordLast], 0, okScheme);
  TFN:=AddSQLTokens(stString, [T1, T2], '', [], 1);
    TUN:=AddSQLTokens(stKeyword, [TFN], 'USER', [toOptional]);
      TUN1:=AddSQLTokens(stString, [TUN], '', [], 2);
      TUN2:=AddSQLTokens(stIdentificator, [TUN], '', [], 2);
    TRN:=AddSQLTokens(stKeyword, [TFN, TUN1, TUN2], 'ROLE', [toOptional]);
      TRN1:=AddSQLTokens(stString, [TRN], '', [], 3);
      TRN2:=AddSQLTokens(stIdentificator, [TRN], '', [], 3);
      TRN1.AddChildToken(TUN);
      TRN2.AddChildToken(TUN);
    TPWD:=AddSQLTokens(stKeyword, [TFN, TUN1, TUN2, TRN1, TRN2], 'PASSWORD', [toOptional]);
      TPWD1:=AddSQLTokens(stString, [TPWD], '', [], 4);
      TPWD1.AddChildToken([TUN, TRN]);

  TDCS:=AddSQLTokens(stKeyword, [TFN, TUN1, TUN2, TRN1, TRN2, TPWD1], 'DEFAULT', [toOptional]);
    TDCS1:=AddSQLTokens(stKeyword, [TDCS], 'CHARACTER', []);
    TDCS1:=AddSQLTokens(stKeyword, [TDCS1], 'SET', []);
    TDCS2:=AddSQLTokens(stIdentificator, [TDCS1], '', [], 5);
    TDCS1:=AddSQLTokens(stString, [TDCS1], '', [], 5);

    TDCS1.AddChildToken([TUN, TRN, TPWD]);
    TDCS2.AddChildToken([TUN, TRN, TPWD]);

  TCll:=AddSQLTokens(stKeyword, [TDCS1, TDCS2], 'COLLATION', [toOptional]);
    TCll1:=AddSQLTokens(stIdentificator, TCll, '', [], 6);

  TPgSz:=AddSQLTokens(stKeyword, [TDCS1, TDCS2, TCll1, TFN, TUN1, TUN2, TRN1, TRN2, TPWD1], 'PAGE_SIZE', [toOptional]);
    TPgSz1:=AddSQLTokens(stSymbol, TPgSz, '=', [], 7);
    TPgSz1:=AddSQLTokens(stInteger, [TPgSz, TPgSz1], '', [], 8);
    TPgSz1.AddChildToken([TUN, TRN, TPWD, TDCS, TCll]);

   // [LENGTH [=] num [PAGE[S]]
  TDbLen:=AddSQLTokens(stKeyword, [TDCS1, TDCS2, TCll1, TFN, TUN1, TUN2, TRN1, TRN2, TPWD1, TPgSz1], 'LENGTH', [toOptional]);
    TDbLen1:=AddSQLTokens(stSymbol, TDbLen, '=', [], 7);
    TDbLen1:=AddSQLTokens(stInteger, [TDbLen, TDbLen1], '', [], 9);
    TDbLen1_1:=AddSQLTokens(stKeyword, TDbLen1, 'PAGE', [], 29);
    TDbLen1_2:=AddSQLTokens(stKeyword, TDbLen1, 'PAGES', [], 29);
    TDbLen1.AddChildToken([TUN, TRN, TPWD, TDCS, TCll, TPgSz]);
    TDbLen1_1.AddChildToken([TUN, TRN, TPWD, TDCS, TCll, TPgSz]);
    TDbLen1_2.AddChildToken([TUN, TRN, TPWD, TDCS, TCll, TPgSz]);


  TFile:=AddSQLTokens(stKeyword, [TDCS1, TDCS2, TCll1, TFN, TUN1, TUN2, TRN1, TRN2, TPWD1, TPgSz1, TDbLen1, TDbLen1_1, TDbLen1_2], 'FILE', [toOptional]);
    TFile1:=AddSQLTokens(stString, TFile, '', [], 10);
      TFile1.AddChildToken(TFile);
    TFile2:=AddSQLTokens(stKeyword, TFile1, 'LENGTH', [toOptional]);
    T:=AddSQLTokens(stSymbol, TFile2, '=', []);
    TFile2_3:=AddSQLTokens(stInteger, [TFile2, T], '', [], 11);
    TFile2_1:=AddSQLTokens(stKeyword, TFile2, 'PAGE', [], 12);
    TFile2_2:=AddSQLTokens(stKeyword, TFile2, 'PAGES', [], 12);

    TFile3:=AddSQLTokens(stKeyword, [TFile1, TFile2, TFile2_1, TFile2_2, TFile2_3], 'STARTING', [toOptional]);
      T:=AddSQLTokens(stKeyword, TFile3, 'AT', []);
      T1:=AddSQLTokens(stKeyword, T, 'PAGE', [], 13);
    TFile3_1:=AddSQLTokens(stInteger, [TFile3, T, T1], '', [], 14);
      TFile3_1.AddChildToken([TFile2, TFile]);

      TFile2_3.AddChildToken([TFile]);
      TFile2_1.AddChildToken([TFile]);
      TFile2_2.AddChildToken([TFile]);

//  <sec_file> ::= FILE ' filepath '
//  [LENGTH [=] num [PAGE[S]] [STARTING [AT [PAGE]] pagenum ]

(*
    [SET NAMES ' charset ']


    [ <sec_file> [ <sec_file> ...]]
    [DIFFERENCE FILE ' diff_file '];
    <filespec> ::= [ <server_spec> ]{ filepath | db_alias }
    <server_spec> ::=
    host [\ port | service ]:
    | \\ host [@ port | service ]\
    | <protocol> ://[ host [: port | service ]/]
    <protocol> = inet | inet4 | inet6 | wnet | xnet
*)
end;

procedure TFBSQLCreateDatabase.MakeSQL;
var
  S: String;
  P: TSQLParserField;
  F: TFBSQLDatabaseFile;
begin
  S:='CREATE';
  if ObjectKind = okScheme then
    S:=S + ' SCHEMA'
  else
    S:=S + ' DATABASE';

  S:=S + ' ' +QuotedString(DatabaseName, '''');

  if UserName<>'' then
    S:=S + ' USER '+UserName;

  if Password<>'' then
    S:=S + ' PASSWORD ' + Password;
  if RoleName <> '' then
    S:=S +' ROLE ' + RoleName;

  for P in Params do
  begin
    S:=S + LineEnding + '  ' + P.Caption;
    if not P.IsLocal then S:=S + ' =';
    S:=S + ' ' + P.ParamValue;
    if P.Caption = 'LENGTH' then
      S:=S + ' ' + P.CharSetName;
  end;

  for F in Files do
  begin
    S:=S + LineEnding + '  FILE ' + QuotedString(F.FileName, '''');
    if F.Size > 0 then
    begin
      S:=S + ' LENGTH ' + IntToStr(F.Size);
      if F.SizeUnit <> fsuDefault then
        S:=S+ ' PAGES';
    end;

    if F.Start > 0 then
    begin
      S:=S + ' STARTING';
      if F.StartUnit<>fsuDefault then
        S:=S + ' AT PAGE';
      S:=S+ ' ' + IntToStr(F.Start);
    end
  end;
  AddSQLCommand(S);
end;

procedure TFBSQLCreateDatabase.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=ExtractQuotedString(AWord, '''');
    2:UserName:=AWord;
    3:RoleName:=AWord;
    4:Password:=AWord;
    5:Params.AddParam('DEFAULT CHARACTER SET').ParamValue:=AWord;
    6:Params.AddParam('COLLATION').ParamValue:=AWord;
    7:begin
        FCurParam:=Params.AddParam('');
        FCurParam.IsLocal:=false;
      end;
    8:begin
        if not Assigned(FCurParam) or (FCurParam.Caption<>'') then
          FCurParam:=Params.AddParam('PAGE_SIZE')
        else
          FCurParam.Caption:='PAGE_SIZE';
        FCurParam.ParamValue:=AWord;
        FCurParam:=nil;
      end;
    9:begin
        if not Assigned(FCurParam) or (FCurParam.Caption<>'') then
          FCurParam:=Params.AddParam('LENGTH')
        else
          FCurParam.Caption:='LENGTH';
        FCurParam.ParamValue:=AWord;
      end;
    29:if Assigned(FCurParam) then
          FCurParam.CharSetName:=AWord;
    10:FCurFile:=Files.Add(ExtractQuotedString(AWord, ''''));
    11:if Assigned(FCurFile) then
         FCurFile.Size:=StrToInt(AWord);
    12:if Assigned(FCurFile) then
         FCurFile.SizeUnit:=fsuPage;
    13:if Assigned(FCurFile) then
         FCurFile.StartUnit:=fsuPage;
    14:if Assigned(FCurFile) then
         FCurFile.Start:=StrToInt(AWord);
  end;
end;

constructor TFBSQLCreateDatabase.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FFiles:=TFBSQLDatabaseFiles.Create;
end;

destructor TFBSQLCreateDatabase.Destroy;
begin
  FreeAndNil(FFiles);
  inherited Destroy;
end;

procedure TFBSQLCreateDatabase.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLCreateDatabase then
  begin
    Files.Clear;
    Files.Assign(TFBSQLCreateDatabase(ASource).Files);
  end;
  inherited Assign(ASource);
end;

{ TFBAutoIncObject }

procedure TFBAutoIncObject.MakeObjects;
var
  G: TFBSQLCreateGenerator;
  T: TFBSQLCreateTrigger;
begin
  if SequenceName <> '' then
  begin
    G:=TFBSQLCreateGenerator.Create(OwnerTable.Parent);
    G.Name:=SequenceName;
    OwnerTable.AddChild(G);
  end;

  if (TriggerName <> '') and (TriggerBody <> '') then
  begin
    T:=TFBSQLCreateTrigger.Create(OwnerTable.Parent);
    T.Name:=TriggerName;
    T.Body:=TriggerBody;
    T.TriggerType:=[ttBefore, ttInsert];
    T.TableName:=OwnerTable.Name;
    T.Description:=TriggerDesc;
    OwnerTable.AddChild(T);
  end;
end;

{ TFBSQLDropFunction }

procedure TFBSQLDropFunction.InitParserTree;
var
  FSQLTokens, T: TSQLTokenRecord;
begin
  (*
  DROP FUNCTION funcname
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okStoredProc);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'FUNCTION', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
end;

procedure TFBSQLDropFunction.MakeSQL;
var
  S: String;
begin
  S:='DROP FUNCTION ' + FullName;
  AddSQLCommand(S);
end;

procedure TFBSQLDropFunction.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
  end;
end;

constructor TFBSQLDropFunction.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okFunction;
end;

{ TFBSQLCreateFunction }

procedure TFBSQLCreateFunction.ParseLocalVariables(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
var
  L: TFBLocalVariableParser;
begin
  L:=TFBLocalVariableParser.Create(nil);
  L.ParseLocalVars(ASQLParser);
  Params.CopyFrom(L.Params, []);
  L.Free;
end;

procedure TFBSQLCreateFunction.InitParserTree;
var
  FSQLTokens, FSQLTokens1, T, TName, TInS, TInSymb, TInS_N,
    TInE, TRet, TRetCol, TRetCol1, TRetDeterm, TExten, TAS: TSQLTokenRecord;
begin
  (*
CREATE FUNCTION funcname [( <inparam> [, <inparam> ...])]
  RETURNS <type> [COLLATE collation ] [DETERMINISTIC]
  { EXTERNAL NAME ' <extname> ' ENGINE <engine> } |
  { AS
  [ <declarations> ]
  BEGIN
   [ <PSQL_statements> ]
  END
  }
<inparam> ::= <param_decl> [{= | DEFAULT} <value> ]
<value> ::=
{ literal | NULL | context_var }
<param_decl> ::= paramname <type> [NOT NULL] [COLLATE collation ]
<extname> ::= ' <module name> ! <routine name> [! <misc info> ]'
<type> ::= <datatype> | [TYPE OF] domain | TYPE OF COLUMN rel . col
<datatype> ::=
{SMALLINT | INT[EGER] | BIGINT}
| BOOLEAN
| {FLOAT | DOUBLE PRECISION}
| {DATE | TIME | TIMESTAMP}
| {DECIMAL | NUMERIC} [( precision [, scale ])]
| {CHAR | CHARACTER | CHARACTER VARYING | VARCHAR} [( size )]
[CHARACTER SET charset ]
| {NCHAR | NATIONAL CHARACTER | NATIONAL CHAR} [VARYING] [( size )]
| BLOB [SUB_TYPE { subtype_num | subtype_name }]
[SEGMENT SIZE seglen ] [CHARACTER SET charset ]
| BLOB [( seglen [, subtype_num ])]
<declarations> ::= <declare_item> [ <declare_item> ...]
<declare_item> ::=
<declare_var> ; |
<declare_cursor> ; |
<declare_subfunc>

CREATE OR ALTER FUNCTION funcname [( <inparam> [, <inparam> ...])]
RETURNS <type> [COLLATE collation ] [DETERMINISTIC]
{ EXTERNAL NAME ' <extname> ' ENGINE <engine> } |
{ AS
[ <declarations> ]
BEGIN
[ <PSQL_statements> ]
END
}
*)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okStoredProc);
  FSQLTokens1:=AddSQLTokens(stKeyword, nil, 'RECREATE', [toFirstToken], 1, okStoredProc);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'OR', []);
    T:=AddSQLTokens(stKeyword, T, 'ALTER', [toFirstToken], -2);
  T:=AddSQLTokens(stKeyword, [FSQLTokens, T, FSQLTokens1], 'FUNCTION', [toFindWordLast]);


  TName:=AddSQLTokens(stIdentificator, T, '', [], 100);

  TInS:=AddSQLTokens(stSymbol, TName, '(', []);
  TInSymb:=AddSQLTokens(stSymbol, nil, ',', [], 103);
  TInS_N:=AddSQLTokens(stIdentificator, [TInS, TInSymb], '', [], 101);
  TInE:=AddSQLTokens(stSymbol, nil, ')', [], 104);
  MakeTypeDefTree(Self, [TInS_N], [TInE, TInSymb], tdfParams, 0);

  TRet:=AddSQLTokens(stKeyword, TInE, 'RETURNS', []);

  TRetCol:=AddSQLTokens(stKeyword, nil, 'COLLATE', []);
    TRetCol1:=AddSQLTokens(stIdentificator, TRetCol, '', [], 500);

  TRetDeterm:=AddSQLTokens(stKeyword, [TRetCol1], 'DETERMINISTIC', [], 501);
  TExten:=AddSQLTokens(stKeyword, [TRetCol1, TRetDeterm], 'EXTERNAL', []);
  TAS:=AddSQLTokens(stKeyword, [TRetCol1, TRetDeterm], 'AS', [], 200);

  MakeTypeDefTree(Self, [TRet], [TRetCol, TRetDeterm, TAS, TExten], tdfTypeOnly, 400);

  TExten:=AddSQLTokens(stKeyword, TExten, 'NAME', []);
  TExten:=AddSQLTokens(stString, TExten, '', [], 502);
  TExten:=AddSQLTokens(stKeyword, TExten, 'ENGINE', []);
  TExten:=AddSQLTokens(stIdentificator, TExten, '', [], 503);

  AddSQLTokens(stKeyword, TAS, 'BEGIN', [], 600);

end;

procedure TFBSQLCreateFunction.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
var
  S: String;
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
      //1:CreateMode:=cmCreateOrAlter;
    101:begin
          FCurParam:=Params.AddParam(AWord);
          FCurParam.InReturn:=spvtInput;
        end;
    102:begin
          FCurParam:=Params.AddParam(AWord);
          FCurParam.InReturn:=spvtOutput;
        end;
    103,
    104:FCurParam:=nil;
      2:if Assigned(FCurParam) then FCurParam.TypeName:=AWord;
      3:if Assigned(FCurParam) then FCurParam.TypeName:=FCurParam.TypeName + ' ' + AWord;
     26:if Assigned(FCurParam) then FCurParam.TypeName:=FCurParam.TypeName + AWord;
      4:if Assigned(FCurParam) then FCurParam.TypeLen:=StrToInt(AWord);
      5:if Assigned(FCurParam) then FCurParam.TypePrec:=StrToInt(AWord);
      7:if Assigned(FCurParam) then FCurParam.CharSetName:=AWord;
      8:if Assigned(FCurParam) then FCurParam.Params:=FCurParam.Params + [fpNotNull];
     13:if Assigned(FCurParam) then FCurParam.DefaultValue:=AWord;
     10:if Assigned(FCurParam) then FCurParam.Collate:=AWord;
      9:begin
          S:=ASQLParser.GetToBracket(')');
          if Assigned(FCurParam) then
            FCurParam.CheckExpr:=S;
        end;
    100:Name:=AWord;
    402:ReturnType:=AWord;
    403:ReturnType:=ReturnType + ' ' + AWord;
    426:ReturnType:=ReturnType + AWord;
    500:ReturnCollate:=AWord;
    501:Deterministic:=true;
    502:ExternalName:=AWord;
    503:Engine:=AWord;

    302:;
    200:ParseLocalVariables(ASQLParser, AChild, AWord);
    //600:DoParseBody(ASQLParser);
    600:begin
          ASQLParser.Position:=ASQLParser.WordPosition;
          Body:=GetToEndpSQL(ASQLParser);
        end;

  end;
end;

procedure TFBSQLCreateFunction.MakeSQL;
var
  S, FIn, FLocal: String;
  LP: TFBLocalVariableParser;
  i: Integer;
begin
  S:='CREATE ';
  if ooOrReplase in Options then
    S:=S + 'OR ALTER ';
  S:=S + 'FUNCTION ' + FullName;

  LP:=TFBLocalVariableParser.Create(nil);
  LP.OwnerName:=FullName;
  LP.Params.CopyFrom(Params, [spvtInput]);
  LP.DescType:=fbldParams;
  FIn:=LP.AsSQL;

  LP.Clear;
  LP.Params.CopyFrom(Params, [spvtLocal, spvtSubFunction, spvtSubProc]);
  LP.DescType:=fbldLocal;
  FLocal:=LP.AsSQL;

  if FIn <> '' then
    S:=S + '('+ LineEnding + FIn + ')';

  S:=S + LineEnding + 'RETURNS ' + ReturnType;
  if ReturnCollate <> '' then
    S:=S + ' COLLATE ' + ReturnCollate;
  if Deterministic then
    S:=S + ' DETERMINISTIC';

  if ExternalName <> '' then
    S:=S + LineEnding + 'EXTERNAL NAME '+ExternalName + ' ENGINE '+Engine
  else
  begin
    S:=S + LineEnding + 'AS'+LineEnding;

    if FLocal <> '' then
      S:=S + FLocal + LineEnding;

    S:=TrimRight(S + Body);

    if (S<>'') and (S[Length(S)]<>';') then
      S := S + ';';
  end;

  AddSQLCommand(S);

  if Description <> '' then
    DescribeObject;


  LP.Clear;
  LP.Params.CopyFrom(Params, [spvtInput]);
  LP.DescType:=fbldDescription;
  for i:=0 to LP.SQLText.Count-1 do AddSQLCommand(LP.SQLText[i]);

{  LP.Clear;
  LP.Params.CopyFrom(Params, [spvtOutput]);
  LP.DescType:=fbldDescription;
  for i:=0 to LP.SQLText.Count-1 do AddSQLCommand(LP.SQLText[i]);}
  LP.Free;
end;

constructor TFBSQLCreateFunction.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);

  FSQLCommentOnClass:=TFBSQLCommentOn;
  ObjectKind:=okFunction;
end;

procedure TFBSQLCreateFunction.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLCreateFunction then
  begin
    ReturnType:=TFBSQLCreateFunction(ASource).ReturnType;
    Deterministic:=TFBSQLCreateFunction(ASource).Deterministic;
    ReturnCollate:=TFBSQLCreateFunction(ASource).ReturnCollate;
    ExternalName:=TFBSQLCreateFunction(ASource).ExternalName;
    Engine:=TFBSQLCreateFunction(ASource).Engine;
  end;
  inherited Assign(ASource);
end;

{ TFBSQLCreatePackage }

procedure TFBSQLCreatePackage.InitParserTree;
var
  FSQLTokens, T1, TPkgBody, TPkgName, T, TFunc, TProc, TEnd: TSQLTokenRecord;
begin
  (*
  CREATE OR ALTER PACKAGE package_name
  AS
  BEGIN
  [ <package_item> ...]
  END
  <package_item> ::=
  <function_decl> ;
  | <procedure_decl> ;
  <function_decl> ::=
  FUNCTION func_name [( <in_params> )]
  RETURNS <type> [COLLATE collation ] [DETERMINISTIC]
  <procedure_decl> ::=
  PROCEDURE proc_name [( <in_params> )] [RETURNS ( <out_params> )]


  ALTER PACKAGE package_name
  AS
  BEGIN
    [ <package_item> ...]
  END
  *)

  (*

  CREATE PACKAGE BODY package_name
  AS
  BEGIN
  [ <package_item> ...]
  [ <package_body_item> ...]
  END
  <package_item> ::=
  <function_decl> ;
  | <procedure_decl> ;
  <function_decl> ::=
  FUNCTION func_name [( <in_params> )]
  RETURNS <type> [COLLATE collation ] [DETERMINISTIC]
  <procedure_decl> ::=
  PROCEDURE proc_name [( <in_params> )] [RETURNS ( <out_params> )]
  <package_body_item> ::=
  <function_impl>
  | <procedure_impl>
  <function_impl> ::=
  FUNCTION func_name [( <in_impl_params> )]
  RETURNS <type> [COLLATE collation ] [DETERMINISTIC]
  { EXTERNAL NAME ' <extname> ' ENGINE <engine> } |
  { AS
  [ <declarations> ]
  BEGIN
  [ <PSQL_statements> ]
  END
  }
  <procedure_impl> ::=
  PROCEDURE proc_name [( <in_impl_params> )] [RETURNS ( <out_params> )]
  { EXTERNAL NAME ' <extname> ' ENGINE <engine> } |
  { AS
  [ <declarations> ]
  BEGIN
  [ <PSQL_statements> ]
  END
  }
  <in_params> ::= <inparam> [, <inparam> ...]
  <inparam> ::= <param_decl> [{= | DEFAULT} <value> ]
  <in_impl_params> ::= <param_decl> [, <param_decl> ...]
  <value> ::=
  { literal | NULL | context_var }
  <out_params> ::= <outparam> [, <outparam> ...]


  <outparam>
::=
<param_decl>
<param_decl> ::= paramname <type> [NOT NULL] [COLLATE collation ]
<type> ::= <datatype> | [TYPE OF] domain | TYPE OF COLUMN rel . col
<datatype> ::=
{SMALLINT | INT[EGER] | BIGINT}
| BOOLEAN
| {FLOAT | DOUBLE PRECISION}
| {DATE | TIME | TIMESTAMP}
| {DECIMAL | NUMERIC} [( precision [, scale ])]
| {CHAR | CHARACTER | CHARACTER VARYING | VARCHAR} [( size )]
[CHARACTER SET charset ]
| {NCHAR | NATIONAL CHARACTER | NATIONAL CHAR} [VARYING] [( size )]
| BLOB [SUB_TYPE { subtype_num | subtype_name }]
[SEGMENT SIZE seglen ] [CHARACTER SET charset ]
| BLOB [( seglen [, subtype_num ])]
<extname> ::= ' <module name> ! <routine name> [! <misc info> ]'
<declarations> ::= <declare_item> [ <declare_item> ...]
<declare_item> ::=
<declare_var> ; |
<declare_cursor> ; |
<declare_subfunc> |
<declare_subproc>


  {ALTER | RECREATE} PACKAGE BODY package_name
  AS
  BEGIN
  [ <package_item> ...]
  [ <package_body_item> ...]
  END
  *)

  (*
  CREATE OR ALTER PACKAGE package_name
  AS
  BEGIN
  [ <package_item> ...]
  END
*)

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okPackage);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'OR', []);
    T1:=AddSQLTokens(stKeyword, T1, 'ALTER', [], -2);
  T1:=AddSQLTokens(stKeyword, [FSQLTokens, T1], 'PACKAGE', [toFindWordLast]);
    TPkgBody:=AddSQLTokens(stKeyword, T1, 'BODY', [], 2);
  //Разбор заголовка пакета (CREATE OR ALTER PACKAGE)
  TPkgName:=AddSQLTokens(stIdentificator, T1, '', [], 3);
  T:=AddSQLTokens(stKeyword, TPkgName, 'AS', []);
  T:=AddSQLTokens(stKeyword, T, 'BEGIN', []);

  TEnd:=AddSQLTokens(stKeyword, nil, 'END', []);

  TFunc:=AddSQLTokens(stKeyword, T, 'FUNCTION', [], 4);
    T1:=AddSQLTokens(stIdentificator, TFunc, '', [], 6);
    T1.AddChildToken([TEnd, TFunc]);

  TProc:=AddSQLTokens(stKeyword, [T, T1], 'PROCEDURE', [], 5);
    T1:=AddSQLTokens(stIdentificator, TFunc, '', [], 6);
    T1.AddChildToken([TFunc, TEnd, TProc]);

(*
  <procedure_decl> ::=
  PROCEDURE proc_name [( <in_params> )] [RETURNS ( <out_params> )]
*)
  //  END

  //Разбор тела пакета (CREATE OR ALTER PACKAGE BODY)
  TPkgName:=AddSQLTokens(stIdentificator, TPkgBody, '', [], 3);

end;

procedure TFBSQLCreatePackage.MakeSQL;
var
  S, S1: String;
  P: TSQLParserField;
begin
  S:='CREATE ';
  if ooOrReplase in Options then
    S:=S + 'OR ALTER';
  S:=S + ' PACKAGE';


  if ObjectKind = okPackageBody then
    S:=S + ' BODY';

  S:=S + ' ' + FullName + LineEnding + 'AS'+LineEnding;

  if PackageText <> '' then
    S:=S + PackageText
  else
  begin
    S:=S + 'BEGIN' + LineEnding;

    S1:='';
    for P in Params do
    begin
      S1:='  ';
      if P.InReturn = spvtSubFunction then S1:=S1 + 'FUNCTION'
      else
      if P.InReturn = spvtSubProc then S1:=S1 + 'PROCEDURE';

      S:=S + S1 + ' ' + DoFormatName(P.Caption) + P.CheckExpr + LineEnding;

    end;
    S:=S + 'END';
  end;
  AddSQLCommand(S);

  if Description <> '' then
    DescribeObject;
end;

procedure TFBSQLCreatePackage.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    //1:CreateMode:=cmCreateOrAlter;
    2:ObjectKind:=okPackageBody;
    3:Name:=AWord;
    4:begin
        FcurItem:=Params.AddParam('');
        FcurItem.InReturn:=spvtSubFunction;
      end;
    5:begin
        FcurItem:=Params.AddParam('');
        FcurItem.InReturn:=spvtSubProc;
      end;
    6:if Assigned(FcurItem) then
      begin
        FcurItem.Caption:=AWord;
        FcurItem.CheckExpr:=ASQLParser.GetToWord(';');
      end;
  end;
end;

constructor TFBSQLCreatePackage.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okPackage;
  FSQLCommentOnClass:=TFBSQLCommentOn;
end;

procedure TFBSQLCreatePackage.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLCreatePackage then
  begin
    PackageText:=TFBSQLCreatePackage(ASource).PackageText;
  end;
  inherited Assign(ASource);
end;

{ TFBSQLDropPackage }

procedure TFBSQLDropPackage.InitParserTree;
var
  FSQLTokens, T1: TSQLTokenRecord;
begin
  (* DROP PACKAGE package_name *)
  (* DROP PACKAGE BODY package_name *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'PACKAGE', [toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'BODY', [], 1);
  AddSQLTokens(stIdentificator, [FSQLTokens, T1], '', [], 2);
end;

procedure TFBSQLDropPackage.MakeSQL;
var
  S: String;
begin
  S:='DROP PACKAGE ';
  if ObjectKind = okPackageBody then
    S:=S + 'BODY ';
  S:=S + FullName;

  AddSQLCommand(S);
end;

procedure TFBSQLDropPackage.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:ObjectKind:=okPackageBody;
    2:Name:=AWord;
  end;
end;

constructor TFBSQLDropPackage.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okPackage;
end;


{ TFBSQLDropIndex }

procedure TFBSQLDropIndex.InitParserTree;
var
  FSQLTokens: TSQLTokenRecord;
begin
  (* DROP INDEX indexname; *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken]);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'INDEX', [toFindWordLast]);
  AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
end;

procedure TFBSQLDropIndex.MakeSQL;
var
  S: String;
begin
  S:='DROP INDEX ' + FullName;
  AddSQLCommand(S);
end;

procedure TFBSQLDropIndex.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
  end;
end;

constructor TFBSQLDropIndex.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okIndex;
end;

{ TFBSQLAlterIndex }

procedure TFBSQLAlterIndex.InitParserTree;
var
  FSQLTokens, T: TSQLTokenRecord;
begin
  (*
  ALTER INDEX indexname {ACTIVE | INACTIVE};
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken]);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'INDEX', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
  AddSQLTokens(stKeyword, T, 'ACTIVE', [], 2);
  AddSQLTokens(stKeyword, T, 'INACTIVE', [], 3);
end;

procedure TFBSQLAlterIndex.MakeSQL;
var
  S: String;
begin
  S:='ALTER INDEX '+FullName;
  if Active then
    S:=S +' ACTIVE'
  else
    S:=S +' INACTIVE';
  AddSQLCommand(S);

  if Description <> '' then
    DescribeObject;
end;

procedure TFBSQLAlterIndex.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    2:Active:=true;
    3:Active:=false;
  end;
end;

constructor TFBSQLAlterIndex.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FActive:=true;
  FSQLCommentOnClass:=TFBSQLCommentOn;
end;

procedure TFBSQLAlterIndex.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLAlterIndex then
  begin
    Active:=TFBSQLAlterIndex(ASource).Active;

  end;
  inherited Assign(ASource);
end;

{ TFBSQLCreateIndex }

procedure TFBSQLCreateIndex.InitParserTree;
var
  FSQLTokens, T, T1, T2, T3, T4, Tbl: TSQLTokenRecord;
begin
  (*
  CREATE [UNIQUE] [ASC[ENDING] | DESC[ENDING]]
  INDEX indexname ON tablename
  {(col [, col …]) | COMPUTED BY (<expression>)};
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken]);
  T:=AddSQLTokens(stIdentificator, FSQLTokens, 'UNIQUE', [], 1);

  T1:=AddSQLTokens(stIdentificator, [T, FSQLTokens], 'ASC', [], 2);
  T2:=AddSQLTokens(stIdentificator, [T, FSQLTokens], 'ASCENDING', [], 3);
  T3:=AddSQLTokens(stIdentificator, [T, FSQLTokens], 'DESC', [], 4);
  T4:=AddSQLTokens(stIdentificator, [T, FSQLTokens], 'DESCENDING', [], 5);
    T1.AddChildToken(T);
    T2.AddChildToken(T);
    T3.AddChildToken(T);
    T4.AddChildToken(T);

  FSQLTokens:=AddSQLTokens(stKeyword, [FSQLTokens, T, T1, T2, T3, T4], 'INDEX', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 10);
  T:=AddSQLTokens(stKeyword, T, 'ON', []);
  Tbl:=AddSQLTokens(stIdentificator, T, '', [], 11);

  T:=AddSQLTokens(stSymbol, Tbl, '(', []);
    T:=AddSQLTokens(stIdentificator, T, '', [], 12);
    T1:=AddSQLTokens(stSymbol, T, ',', []);
    T1.AddChildToken(T);
    T:=AddSQLTokens(stSymbol, T, ')', []);

  T:=AddSQLTokens(stKeyword, Tbl, 'COMPUTED', []);
  T:=AddSQLTokens(stKeyword, T, 'BY', []);
  T:=AddSQLTokens(stSymbol, T, '(', [], 20);
end;

procedure TFBSQLCreateIndex.MakeSQL;
var
  S: String;
  FCmd: TFBSQLAlterIndex;
begin
  (*
  CREATE [UNIQUE] [ASC[ENDING] | DESC[ENDING]]
  INDEX indexname ON tablename
  {(col [, col …]) | COMPUTED BY (<expression>)};
  *)
  S:='CREATE';
  if Unique then S:=S + ' UNIQUE';
  if SortOrder <> indDefault then S:=S + ' ' + IndexSortOrderNames[SortOrder];
  S:=S + ' INDEX '+FullName + ' ON '+DoFormatName(TableName);

  if IndexExpression <> '' then
    S:=S + ' COMPUTED BY ('+IndexExpression + ')'
  else
    S:=S + ' ('+Fields.AsString + ')';

  AddSQLCommand(S);

  if not FActive then
  begin
    FCmd:=TFBSQLAlterIndex.Create(nil);
    FCmd.Name:=Name;
    FCmd.Active:=Active;
    AddSQLCommand(FCmd.AsSQL);
    FCmd.Free;
  end;

  if Description <> '' then
    DescribeObject;
end;

procedure TFBSQLCreateIndex.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Unique:=true;
    2,3:SortOrder:=indAscending;
    4,5:SortOrder:=indDescending;
    10:Name:=AWord;
    11:TableName:=AWord;
    12:Fields.AddParam(AWord);
    20:IndexExpression:=ASQLParser.GetToBracket(')');
  end;
end;

constructor TFBSQLCreateIndex.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FActive:=true;
  FSQLCommentOnClass:=TFBSQLCommentOn;
end;

procedure TFBSQLCreateIndex.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLCreateIndex then
  begin
    SortOrder:=TFBSQLCreateIndex(ASource).SortOrder;
    IndexExpression:=TFBSQLCreateIndex(ASource).IndexExpression;
    Active:=TFBSQLCreateIndex(ASource).Active;
  end;
  inherited Assign(ASource);
end;

{ TFBSQLExecuteProcedure }

function TFBSQLExecuteProcedure.GetProcName: string;
begin
  if Tables.Count > 0 then
    Result:=Tables[0].Name
  else
    Result:='';
end;

procedure TFBSQLExecuteProcedure.SetProcName(AValue: string);
var
  T: TTableItem;
begin
  if Tables.Count = 0 then
    T:=Tables.Add(AValue)
  else
    T:=Tables[0];
  T.Name:=AValue;
end;

procedure TFBSQLExecuteProcedure.InitParserTree;
var
  FSQLTokens: TSQLTokenRecord;
begin
  (*
  EXECUTE PROCEDURE procname
     [<inparam> [, <inparam> ...]] | [(<inparam> [, <inparam> ...])]
     [RETURNING_VALUES <outvar> [, <outvar> ...] | (<outvar> [, <outvar> ...])]

  <outvar> ::= [:]varname
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'EXECUTE', [toFirstToken]);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'PROCEDURE', [toFindWordLast]);
  AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
end;

procedure TFBSQLExecuteProcedure.MakeSQL;
var
  S: String;
begin
  S:='EXECUTE PROCEDURE ' + DoFormatName(ProcName);
  AddSQLCommand(S);
end;

procedure TFBSQLExecuteProcedure.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:ProcName:=AWord;
  end;
end;

procedure TFBSQLExecuteProcedure.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLExecuteProcedure then
  begin
    ProcName:=TFBSQLExecuteProcedure(ASource).ProcName;

  end;
  inherited Assign(ASource);
end;

{ TFBSQLCommandSelect }

procedure TFBSQLCommandSelect.InitParserTree;
var
  FSQLTokens, TFst, TFst1, TSkp, TSkp1, TDist, TAll,
    TSep, TFrm, TCol0, TCol1, TCol1_C, TCol1_C1, TCol1_C2,
    TCol2, TCol3, TTbl, TTblAlias, TTblSymb, TWhere, TTblOn,
    TJoin1, TJoin2, TJoin3, TJoin4, TJoin2_5_O, TJoin6, TTbl1,
    TTblAlias1, TUnion, TUnion1, TUnion2, FSQLTokens1, T, T1,
    T2: TSQLTokenRecord;
begin
(*
[WITH [RECURSIVE] <cte> [, <cte> ...]]
SELECT
  [FIRST m] [SKIP n]
  [DISTINCT | ALL] <columns>
FROM
  source [[AS] alias]
  [<joins>]
[WHERE <condition>]
[GROUP BY <grouping-list>
[HAVING <aggregate-condition>]]
[PLAN <plan-expr>]
[UNION [DISTINCT | ALL] <other-select>]
[ORDER BY <ordering-list>]
[ROWS m [TO n]]
[FOR UPDATE [OF <columns>]]
[WITH LOCK]
[INTO <variables>]

<variables> ::= [:]varname [, [:]varname ...]


<output-column>     ::=  [qualifier.]*
                           | <value-expression> [COLLATE collation] [[AS] alias]

<value-expression>  ::=  [qualifier.]table-column
                           | [qualifier.]view-column
                           | [qualifier.]selectable-SP-outparm
                           | constant
                           | context-variable
                           | function-call
                           | single-value-subselect
                           | CASE-construct
                           | “any other expression returning a single
                                value of a Firebird data type or NULL”

qualifier           ::=  a relation name or alias
collation           ::=  a valid collation name (only for character type columns)


[<joins>]
[...]

<source>          ::=  {table
                       | view
                       | selectable-stored-procedure [(args)]
                       | derived-table
                       | common-table-expression}
                    [[AS] alias]

<joins>           ::=  <join> [<join> ...]

<join>            ::=  [<join-type>] JOIN <source> <join-condition>
                      | NATURAL [<join-type>] JOIN <source>
                      | {CROSS JOIN | ,} <source>

<join-type>       ::=  INNER | {LEFT | RIGHT | FULL} [OUTER]

<join-condition>  ::=  ON condition | USING (column-list)

*)

  FSQLTokens1:=AddSQLTokens(stKeyword, nil, 'WITH', [toFirstToken, toFindWordLast]);
    T:=AddSQLTokens(stKeyword, FSQLTokens1, 'RECURSIVE', []);
    T:=AddSQLTokens(stIdentificator, [FSQLTokens1, T], '', [], 80);

    T1:=AddSQLTokens(stSymbol, T, '(', []);
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 15);
      T2:=AddSQLTokens(stSymbol, T1, ',', []);
      T2.AddChildToken(T1);
    T1:=AddSQLTokens(stKeyword, T1, ')', []);

    T1:=AddSQLTokens(stKeyword, [T, T1], 'AS', []);
    T1:=AddSQLTokens(stSymbol, T1, '(', [], 81);

  FSQLTokens:=AddSQLTokens(stKeyword, T1, 'SELECT', [toFirstToken, toFindWordLast]);
    TFst:=AddSQLTokens(stKeyword, FSQLTokens, 'FIRST', []);
    TFst1:=AddSQLTokens(stInteger, TFst, '', [], 1);
    TSkp:=AddSQLTokens(stKeyword, [FSQLTokens, TFst1], 'SKIP', []);
    TSkp1:=AddSQLTokens(stInteger, TSkp, '', [], 2);
    TSkp1.AddChildToken([TFst]);
    TDist:=AddSQLTokens(stKeyword, [FSQLTokens, TFst1, TSkp1], 'DISTINCT', [], 3);
    TAll:=AddSQLTokens(stKeyword, [FSQLTokens, TFst1, TSkp1], 'ALL', [], 4);
    TDist.AddChildToken([TFst, TSkp]);
    TAll.AddChildToken([TFst, TSkp]);


  TCol0:=AddSQLTokens(stSymbol, [FSQLTokens, TFst1, TSkp1, TDist, TAll], '*', [], 5);
  TCol1:=AddSQLTokens(stIdentificator, [FSQLTokens, TFst1, TSkp1, TDist, TAll], '', [], 5);
  TCol1_C:=AddSQLTokens(stSymbol, TCol1, '.', [], 9);
  TCol1_C1:=AddSQLTokens(stSymbol, TCol1_C, '*', [], 6);
  TCol1_C2:=AddSQLTokens(stIdentificator, TCol1_C, '', [], 7);
  TCol2:=AddSQLTokens(stString, [FSQLTokens, TFst1, TSkp1, TDist, TAll], '', [], 8);
  TCol3:=AddSQLTokens(stInteger, [FSQLTokens, TFst1, TSkp1, TDist, TAll], '', [], 8);
  TSep:=AddSQLTokens(stSymbol, [TCol1, TCol2, TCol3, TCol1_C1, TCol1_C2], ',', [], 10);
    TSep.AddChildToken([TCol1, TCol2, TCol3]);

  TFrm:=AddSQLTokens(stKeyword, [TCol0, TCol1, TCol2, TCol3, TCol1_C1, TCol1_C2], 'FROM', [], 50);
  TTbl:=AddSQLTokens(stIdentificator, TFrm, '', [], 51);
  TTblAlias:=AddSQLTokens(stIdentificator, TTbl, '', [toOptional], 52);

  TJoin1:=AddSQLTokens(stKeyword, [TTbl, TTblAlias], 'INNER', [toOptional], 53);
  TJoin2:=AddSQLTokens(stKeyword, [TTbl, TTblAlias], 'LEFT', [toOptional], 54);
  TJoin3:=AddSQLTokens(stKeyword, [TTbl, TTblAlias], 'RIGHT', [toOptional], 55);
  TJoin4:=AddSQLTokens(stKeyword, [TTbl, TTblAlias], 'FULL', [toOptional], 56);
  TJoin2_5_O:=AddSQLTokens(stKeyword, [TJoin2, TJoin3, TJoin4], 'OUTER', [], 57);
  TJoin6:=AddSQLTokens(stKeyword, [TJoin1, TJoin2, TJoin3, TJoin4, TJoin2_5_O], 'JOIN', [], 58);

  TTbl1:=AddSQLTokens(stIdentificator, TJoin6, '', [], 51);
  TTblAlias1:=AddSQLTokens(stIdentificator, TTbl1, '', [], 52);
  TTblOn:=AddSQLTokens(stKeyword, [TTbl1, TTblAlias1], 'ON', [], 60);
    TTblOn.AddChildToken([TJoin1, TJoin2, TJoin3, TJoin4]);

  TTblSymb:=AddSQLTokens(stSymbol, [TTbl, TTblAlias, TTblOn], ',', [toOptional], 69);
    TTblSymb.AddChildToken([TTbl, TTbl1]);


  TWhere:=AddSQLTokens(stKeyword, [TTbl, TTblAlias, TTblOn], 'WHERE', [toOptional], 70);


  TUnion:=AddSQLTokens(stKeyword, [TTbl, TTblAlias, TTblOn, TWhere], 'UNION', [toOptional], 71);
    TUnion.AddChildToken(FSQLTokens);
  TUnion1:=AddSQLTokens(stKeyword, TUnion, 'DISTINCT', [], 72);
    TUnion1.AddChildToken(FSQLTokens);
  TUnion2:=AddSQLTokens(stKeyword, TUnion, 'ALL', [], 73);
    TUnion2.AddChildToken(FSQLTokens);
end;

procedure TFBSQLCommandSelect.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);

function CopyJoinExpression:string;
var
  Stop: Boolean;
  P: TParserPosition;
  S: String;
begin
  Stop:=false;
  Result:='';
  repeat
    P:=ASQLParser.Position;
    S:=ASQLParser.GetNextWord;
    if S = '(' then Result:=Result + ' ' + S + ASQLParser.GetToBracket(')') + ')'
    else
    if (S = ',') or (S = ';') or (UpperCase(S) = 'INNER') or (UpperCase(S) = 'LEFT') or (UpperCase(S) = 'RIGHT') or (UpperCase(S) = 'FULL') or (UpperCase(S) = 'WHERE') then
    begin
      Stop:=true;
      ASQLParser.Position:=P;
    end
    else
      Result:=Result + ' ' + S;
  until ASQLParser.Eof or Stop;
end;

begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FFirstRec:=StrToInt(AWord);
    2:FSkipRec:=StrToInt(AWord);
    3:FDistinct:=true;
    4:FDistinct:=false;
    5,
    8:FCurField:=Fields.AddParam(AWord);
    6, 7, 9:if Assigned(FCurField) then FCurField.Caption:=FCurField.Caption + AWord;
    10, 50:FCurField:=nil;
    51:FCurTable:=Tables.Add(AWord);
    52:if Assigned(FCurTable) then
      FCurTable.TableAlias:=AWord;
    53:FCurTable.JoinType:=jtInner;
    54:FCurTable.JoinType:=jtLeft;
    55:FCurTable.JoinType:=jtRight;
    56:FCurTable.JoinType:=jtFull;
    57:FCurTable.JoinOptions:=FCurTable.JoinOptions + [joOuter];
    60:FCurTable.JoinExpression:=CopyJoinExpression;
    69,
    70:FCurTable:=nil;
  end;
end;

constructor TFBSQLCommandSelect.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSelectable:=true;
  FDistinct:=false;
  FFirstRec:=-1;
  FSkipRec:=-1;
end;

procedure TFBSQLCommandSelect.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLCommandSelect then
  begin
    FirstRec:=TFBSQLCommandSelect(ASource).FirstRec;
    SkipRec:=TFBSQLCommandSelect(ASource).SkipRec;
    Distinct:=TFBSQLCommandSelect(ASource).Distinct;
  end;
  inherited Assign(ASource);
end;

procedure TFBSQLCommandSelect.MakeSQL;
var
  S, S1: String;
  T: TTableItem;
begin
  S:='SELECT';
  if FFirstRec > -1 then
    S:=S + ' FIRST '+IntToStr(FFirstRec);
  if FSkipRec > -1 then
    S:=S + ' SKIP '+IntToStr(FSkipRec);
  if FDistinct then
    S:=S + ' DISTINCT' + LineEnding
  else
    S:=S + ' ALL' + LineEnding;

  S:=S + Fields.AsList;

  S:=S + LineEnding + 'FROM' + LineEnding;

  S1:='';
  for T in Tables do
  begin
    if S1 <> '' then
    begin
      if T.JoinExpression <> '' then
      begin
        S1:=S1 + LineEnding + '  ';
        case T.JoinType of
          jtInner:S1:=S1 + 'INNER';
          jtLeft:S1:=S1 + 'LEFT';
          jtRight:S1:=S1 + 'RIGHT';
          jtFull:S1:=S1 + 'FULL';
        end;
        if joOuter in T.JoinOptions then
          S1:=S1 + ' OUTER';
        S1:=S1 + ' JOIN ';
      end
      else
        S1:=S1 + ',' + LineEnding + '  ';
    end
    else
      S1:=S1 + '  ';
    S1:=S1 + T.Name;
    if T.TableAlias <> '' then S1:=S1 + ' ' + T.TableAlias;
    if T.JoinExpression <> '' then
      S1:=S1 + ' ON '+T.JoinExpression;
  end;

  S:=S + S1;

  AddSQLCommand(S);
end;

{ TFBSQLAlterTrigger }
(*
procedure TFBSQLAlterTrigger.InitParserTree;
begin
  inherited InitParserTree;
end;

procedure TFBSQLAlterTrigger.MakeSQL;
begin
  inherited MakeSQL;
end;

procedure TFBSQLAlterTrigger.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;
*)
{ TFBSQLSetTransaction }

constructor TFBSQLSetTransaction.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  //IsolationLevel:=tilReadCommitted;
end;

procedure TFBSQLSetTransaction.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLSetTransaction then
  begin
    NoAutoUndo:=TFBSQLSetTransaction(ASource).NoAutoUndo;
    LockTimeout:=TFBSQLSetTransaction(ASource).LockTimeout;
    IgnoreLimbo:=TFBSQLSetTransaction(ASource).IgnoreLimbo;
    UseIsolationLivel:=TFBSQLSetTransaction(ASource).UseIsolationLivel;
    TableStability:=TFBSQLSetTransaction(ASource).TableStability;
  end;
  inherited Assign(ASource);
end;

procedure TFBSQLSetTransaction.InitParserTree;
var
  FSQLTokens, TName, TName1, Ttr, TR, TR1, TR2, TW, TW1,
    TW2, TNAU, TLT, TLT1, TTIL, TTIL1, TTIL2, TTIL2_1, TTIL3,
    TIL, TIL1, TTIL3_1, TIL4, TIL4_1: TSQLTokenRecord;
begin
(*
SET TRANSACTION
   [NAME tr_name]
   [READ WRITE | READ ONLY]
   [[ISOLATION LEVEL] {
       SNAPSHOT [TABLE STABILITY]
     | READ COMMITTED [[NO] RECORD_VERSION] }]
   [WAIT | NO WAIT]
   [LOCK TIMEOUT seconds]
   [NO AUTO UNDO]
   [IGNORE LIMBO]
   [RESTART REQUESTS]
   [RESERVING <tables> | USING <dbhandles>]

    <tables> ::= <table_spec> [, <table_spec> ...]

    <table_spec> ::= tablename [, tablename ...]
      [FOR [SHARED | PROTECTED] {READ | WRITE}]

    <dbhandles> ::= dbhandle [, dbhandle ...]
*)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'SET', [toFirstToken]);
    Ttr:=AddSQLTokens(stKeyword, FSQLTokens, 'TRANSACTION', [toFindWordLast]);
  TName:=AddSQLTokens(stKeyword, Ttr, 'NAME', [toOptional]);
    TName1:=AddSQLTokens(stIdentificator, TName, '', [], 1);
  TR:=AddSQLTokens(stKeyword, [Ttr, TName1], 'READ', [toOptional]);
    TR1:=AddSQLTokens(stKeyword, TR, 'WRITE', [], 2);
    TR2:=AddSQLTokens(stKeyword, TR, 'ONLY', [], 3);

  TW:=AddSQLTokens(stKeyword, [Ttr, TName1, TR1, TR2], 'WAIT', [toOptional], 4);
  TW1:=AddSQLTokens(stKeyword, [Ttr, TName1, TR1, TR2, TW], 'NO', [toOptional]);
    TW2:=AddSQLTokens(stKeyword, TW1, 'WAIT', [], 5);
    TNAU:=AddSQLTokens(stKeyword, TW1, 'AUTO', []);
    TNAU:=AddSQLTokens(stKeyword, TNAU, 'UNDO', [], 6);

  TLT:=AddSQLTokens(stKeyword, [Ttr, TName1, TR1, TR2, TW, TW2, TNAU], 'LOCK', [toOptional]);
    TLT1:=AddSQLTokens(stKeyword, TLT, 'TIMEOUT', []);
    TLT1:=AddSQLTokens(stInteger, TLT1, '', [], 7);

  TIL:=AddSQLTokens(stKeyword, [Ttr, TName1, TR1, TR2, TW, TW2, TNAU, TLT1], 'IGNORE', [toOptional]);
    TIL1:=AddSQLTokens(stKeyword, TIL, 'LIMBO', [toOptional], 8);

  TTIL:=AddSQLTokens(stKeyword, [Ttr, TName1, TR1, TR2, TW, TW2, TNAU, TLT1, TIL1], 'ISOLATION', [toOptional]);
    TTIL1:=AddSQLTokens(stKeyword, TTIL, 'LEVEL', [], 14);
  TTIL2:=AddSQLTokens(stKeyword, [Ttr, TName1, TR1, TR2, TW, TW2, TNAU, TLT1, TIL1, TTIL1], 'SNAPSHOT', [toOptional], 10);
    TTIL2_1:=AddSQLTokens(stKeyword, TTIL2, 'TABLE', [toOptional]);
    TTIL2_1:=AddSQLTokens(stKeyword, TTIL2_1, 'STABILITY', [], 15);
  TTIL3:=AddSQLTokens(stKeyword, [Ttr, TName1, TR1, TR2, TW, TW2, TNAU, TLT1, TIL1, TTIL1], 'READ', [toOptional]);
  TTIL3:=AddSQLTokens(stKeyword, [TTIL3, TR], 'COMMITTED', [], 11);
    TTIL3_1:=AddSQLTokens(stKeyword, [TTIL3, TR], 'NO', [toOptional], 12);
    TTIL3_1:=AddSQLTokens(stKeyword, [TTIL3, TTIL3_1], 'RECORD_VERSION', [toOptional], 13);

  TIL4:=AddSQLTokens(stKeyword, [Ttr, TName1, TR1, TR2, TW, TW2, TNAU, TLT1, TTIL2, TTIL2_1, TTIL3, TTIL3_1], 'RESTART', [toOptional]);
    TIL4_1:=AddSQLTokens(stKeyword, TIL4, 'REQUESTS', [toOptional], 16);

(*
[[ISOLATION LEVEL] {
    SNAPSHOT [TABLE STABILITY]
  | READ COMMITTED [[NO] RECORD_VERSION] }]
[RESERVING <tables> | USING <dbhandles>]

 <tables> ::= <table_spec> [, <table_spec> ...]

 <table_spec> ::= tablename [, tablename ...]
   [FOR [SHARED | PROTECTED] {READ | WRITE}]

 <dbhandles> ::= dbhandle [, dbhandle ...]

*)
  TR1.AddChildToken([TName]);
  TR2.AddChildToken([TName]);
  TW.AddChildToken([TR, TName]);
  TW2.AddChildToken([TR, TName, TW1]);
  TNAU.AddChildToken([TR, TName, TW, TW1]);
  TLT1.AddChildToken([TR, TName, TW, TW1]);
  TIL1.AddChildToken([TR, TName, TW, TW1, TLT]);

  TTIL2.AddChildToken([TR, TName, TW, TW1, TLT, TIL1]);
  TTIL2_1.AddChildToken([TR, TName, TW, TW1, TLT, TIL1]);
  TTIL3.AddChildToken([TR, TName, TW, TW1, TLT, TIL1]);
  TTIL3_1.AddChildToken([TR, TName, TW, TW1, TLT, TIL1]);
  TIL4_1.AddChildToken([TR, TName, TW, TW1, TLT, TIL1]);
end;

procedure TFBSQLSetTransaction.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:Name:=AWord;
    2:TransactionParam:=TransactionParam + [tilReadWrite];
    3:TransactionParam:=TransactionParam + [tilReadOnly];
    4:TransactionParam:=TransactionParam + [tilWait];
    5:TransactionParam:=TransactionParam + [tilNoWait];
    6:NoAutoUndo:=true;
    7:LockTimeout:=StrToInt(AWord);
    8:IgnoreLimbo:=true;
    10:IsolationLevel:=tilRepeatableRead;
    11:IsolationLevel:=tilReadCommitted;
    12:TransactionParam:=TransactionParam + [tilNoRecVersion];
    13:if not (tilNoRecVersion in TransactionParam) then TransactionParam:=TransactionParam + [tilRecVersion];
    14:UseIsolationLivel:=true;
    15:TableStability:=true;
    16:TransactionParam:=TransactionParam + [tilRestartRequests];
  end;
end;

procedure TFBSQLSetTransaction.MakeSQL;
var
  S: String;
begin
  (*
  SET TRANSACTION
     [NAME tr_name]
     [READ WRITE | READ ONLY]
     [[ISOLATION LEVEL] {
         SNAPSHOT [TABLE STABILITY]
       | READ COMMITTED [[NO] RECORD_VERSION] }]
     [WAIT | NO WAIT]
     [LOCK TIMEOUT seconds]
     [NO AUTO UNDO]
     [IGNORE LIMBO]
     [RESTART REQUESTS]
     [RESERVING <tables> | USING <dbhandles>]

      <tables> ::= <table_spec> [, <table_spec> ...]

      <table_spec> ::= tablename [, tablename ...]
        [FOR [SHARED | PROTECTED] {READ | WRITE}]

      <dbhandles> ::= dbhandle [, dbhandle ...]
  *)

  S:='SET TRANSACTION';
  if Name <> '' then
    S:=S + ' NAME ' + Name;

  if tilReadOnly in TransactionParam then
    S:=S + ' READ ONLY';
  if tilReadWrite in TransactionParam then
    S:=S + ' READ WRITE';

  if tilNoWait in TransactionParam then
    S:=S + ' NO WAIT';
  if tilWait in TransactionParam then
    S:=S + ' WAIT';

  if UseIsolationLivel then
    S:=S + ' ISOLATION LEVEL';
  case IsolationLevel of
    tilRepeatableRead:
      begin
        S:=S + ' SNAPSHOT';
        if TableStability then
          S:=S + ' TABLE STABILITY';
      end;
    tilReadCommitted:
      begin
        S:=S + ' READ COMMITTED';
        if tilNoRecVersion in TransactionParam then
          S:=S + ' NO RECORD_VERSION'
        else
        if tilRecVersion in TransactionParam then
          S:=S + ' RECORD_VERSION';
      end;
  end;

  if NoAutoUndo then
    S:=S + ' NO AUTO UNDO';

  if LockTimeout>0 then
    S:=S + ' LOCK TIMEOUT '+IntToStr(FLockTimeout);

  if IgnoreLimbo then
    S:=S + ' IGNORE LIMBO';

  if tilRestartRequests in TransactionParam then
    S:=S + ' RESTART REQUESTS';
  AddSQLCommand(S);
end;

{ TFBSQLRevoke }

procedure TFBSQLRevoke.InitParserTree;
var
  FSQLTokens, T, TWGO, TPriv1, TPriv2, TPriv3, TPriv4, TPriv5,
    TSymb, TSymb1, TOn, TName, TFrom: TSQLTokenRecord;
begin
  (*
  REVOKE [GRANT OPTION FOR] {
    <privileges> ON [TABLE] {tablename | viewname} |
    EXECUTE ON PROCEDURE procname }
  FROM <grantee_list>
  [{GRANTED BY | AS} [USER] grantor];

  REVOKE [ADMIN OPTION FOR] <role_granted>
  FROM {PUBLIC | <role_grantee_list>}
  [{GRANTED BY | AS} [USER] grantor];

  REVOKE ALL ON ALL FROM <grantee_list>

  <privileges> ::= ALL [PRIVILEGES] | <privilege_list>

  <privilege_list> ::= {<privilege> [, <privilege> [, … ] ] }

  <privilege> ::=
    SELECT |
    DELETE |
    INSERT |
    UPDATE [(col [, col [, col [,…] ] ] ) ] |
    REFERENCES (col [, col [, …] ] )

  <grantee_list> ::= {<grantee> [, <grantee> [, …] ]}

  <grantee>  ::=
    [USER] username | [ROLE] rolename |  GROUP Unix_group
    | PROCEDURE procname | TRIGGER trigname | VIEW viewname | PUBLIC

  <role_granted> ::= rolename [, rolename …]

  <role_grantee_list> ::= [USER] <role_grantee> [,[USER] <role_grantee> [, …]]

  <role_grantee> ::= {username | PUBLIC }
  *)

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'REVOKE', [toFirstToken, toFindWordLast]);
    TWGO:=AddSQLTokens(stKeyword, FSQLTokens, 'GRANT', []);
    TWGO:=AddSQLTokens(stKeyword, TWGO, 'OPTION', []);
    TWGO:=AddSQLTokens(stKeyword, TWGO, 'FOR', [], 1);

  TPriv1:=AddSQLTokens(stKeyword, [FSQLTokens, TWGO], 'SELECT', [], 2);
  TPriv2:=AddSQLTokens(stKeyword, [FSQLTokens, TWGO], 'DELETE', [], 3);
  TPriv3:=AddSQLTokens(stKeyword, [FSQLTokens, TWGO], 'INSERT', [], 4);
  TPriv4:=AddSQLTokens(stKeyword, [FSQLTokens, TWGO], 'UPDATE', [], 5);
    TSymb:=AddSQLTokens(stSymbol, TPriv4, '(', []);
    T:=AddSQLTokens(stIdentificator, TSymb, '', [], 7);
    TSymb:=AddSQLTokens(stSymbol, T, ',', [], 8);
      TSymb.AddChildToken(T);
    TSymb:=AddSQLTokens(stSymbol, T, ')', [], 9);
  TPriv5:=AddSQLTokens(stKeyword, [FSQLTokens, TWGO], 'REFERENCES', [], 6);
    TSymb1:=AddSQLTokens(stSymbol, TPriv5, '(', []);
    T:=AddSQLTokens(stIdentificator, TSymb1, '', [], 10);
    TSymb1:=AddSQLTokens(stSymbol, T, ',', [], 8);
      TSymb1.AddChildToken(T);
    TSymb1:=AddSQLTokens(stSymbol, T, ')', [], 9);
  T:=AddSQLTokens(stSymbol, [TPriv1, TPriv2, TPriv3, TPriv4, TPriv5, TSymb1, TSymb], ',', []);
    T.AddChildToken([TPriv1, TPriv2, TPriv3, TPriv4, TPriv5]);

  TOn:=AddSQLTokens(stKeyword, [TPriv1, TPriv2, TPriv3, TPriv4, TPriv5, TSymb, TSymb1], 'ON', []);
    T:=AddSQLTokens(stKeyword, TOn, 'TABLE', [], 11);
  TName:=AddSQLTokens(stIdentificator, [TOn, T], '', [], 12);
  TFrom:=AddSQLTokens(stKeyword, TName, 'FROM', []);
  TFrom:=AddSQLTokens(stIdentificator, TFrom, '', [], 13);
    T:=AddSQLTokens(stIdentificator, TFrom, ',', [toOptional]);
    T.AddChildToken(TFrom);

(*
<grantee>  ::=
  [USER] username | [ROLE] rolename |  GROUP Unix_group
  | PROCEDURE procname | TRIGGER trigname | VIEW viewname | PUBLIC
*)
end;

procedure TFBSQLRevoke.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
var
  F: TSQLParserField;
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:GrantTypes:=GrantTypes + [ogWGO];
    2:GrantTypes:=GrantTypes + [ogSelect];
    3:GrantTypes:=GrantTypes + [ogDelete];
    4:GrantTypes:=GrantTypes + [ogInsert];
    5:GrantTypes:=GrantTypes + [ogUpdate];
    6:GrantTypes:=GrantTypes + [ogReference];
    7, 10:begin
        if not Assigned(FCurTable) then
          FCurTable:=Tables.Add('');
        F:=FCurTable.Fields.AddParam(AWord);
        if AChild.Tag = 7 then
          F.TypeName:='UPDATE'
        else
          F.TypeName:='REFERENCES'
      end;
    11:begin
        if not Assigned(FCurTable) then
          FCurTable:=Tables.Add('');
        FCurTable.ObjectKind:=okTable;
       end;
    12:begin
        if not Assigned(FCurTable) then
          FCurTable:=Tables.Add(AWord)
        else
          FCurTable.Name:=AWord;
       end;
    13:Params.AddParam(AWord);
  end;
end;

procedure TFBSQLRevoke.MakeSQL;
var
  S, S1, SR, SU: String;
  G: TObjectGrant;
  F: TSQLParserField;
begin
  if Tables.Count = 0 then Exit;
  FCurTable:=Tables[0];

  S:='REVOKE ';
  if ogWGO in GrantTypes then
    S:=S + 'GRANT OPTION FOR ';


  SR:='';
  SU:='';
  for F in FCurTable.Fields do
  begin
    if F.TypeName = 'UPDATE' then
    begin
      if SU<>'' then SU:=SU + ', ';
      SU:=SU + DoFormatName(F.Caption);
    end
    else
    begin;
      if SR<>'' then SR:=SR + ', ';
      SR:=SR + DoFormatName(F.Caption);
    end
  end;
{  if ((GrantTypes * [ogSelect, ogInsert, ogUpdate, ogDelete, ogReference]) = [ogSelect, ogInsert, ogUpdate, ogDelete, ogReference]) and (FCurTable.Fields.Count = 0) then
    S:=S + 'ALL PRIVILEGES'
  else
  begin}
    S1:='';
    for G in GrantTypes do
    begin
      if G <> ogWGO then
      begin
        if S1<>'' then S1:=S1 + ', ';
        S1:=S1 + ObjectGrantNames[G];
        if (G = ogUpdate) and (SU <> '') then S1:=S1+'('+SU + ')'
        else
        if (G = ogReference) and (SR <> '') then S1:=S1+'('+SR + ')';
      end;
    end;
    S:=S + S1;
//  end;

  if not (FCurTable.ObjectKind in [okStoredProc, okFunction]) then
  begin
    S:=S + ' ON ';
    if FCurTable.ObjectKind = okTable then
      S:=S + 'TABLE ';
    S:=S+ DoFormatName2(FCurTable.Name) + ' FROM ' + Params.AsString
  end
  else
  begin
  end;

  AddSQLCommand(S);
end;

procedure TFBSQLRevoke.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLRevoke then
  begin
    UserGrantor:=TFBSQLRevoke(ASource).UserGrantor;
  end;
  inherited Assign(ASource);
end;

{ TFBSQLGrant }

procedure TFBSQLGrant.InitParserTree;
var
  FSQLTokens, TA, TS, TD, TI, TU, TR, T, TAP, TON, TSymb, T1,
    TProc, TSymb1, TTO, TTU, TTR, TTG, TTG1, TTP, TTU1, TTP1,
    TTT, TTT1, TTV, TTV1, TTPUB, TSymb2, TWAO, GB, TRole,
    TSymb3, TWAO1, TAS: TSQLTokenRecord;
begin
  (*
  GRANT {
    <privileges> ON [TABLE] {tablename | viewname}
    | EXECUTE ON PROCEDURE procname
        }
  TO <grantee_list>
    [WITH GRANT OPTION]} | [{GRANTED BY | AS} [USER] grantor];

  GRANT <role_granted>
  TO <role_grantee_list> [WITH ADMIN OPTION]
  [{GRANTED BY | AS} [USER] grantor]

  <privileges> ::= ALL [PRIVILEGES] | <privilege_list>

  <privilege_list> ::= {<privilege> [, <privilege> [, … ] ] }

  <privilege> ::=
    SELECT |
    DELETE |
    INSERT |
    UPDATE [(col [, col [, …] ] ) ] |
    REFERENCES (col [, …])

  <grantee_list> ::= {<grantee> [, <grantee> [, …] ]}

  <grantee>  ::=
    [USER] username | [ROLE] rolename |  GROUP Unix_group
    | PROCEDURE procname | TRIGGER trigname | VIEW viewname | PUBLIC

  <role_granted> ::= rolename [, rolename …]

  <role_grantee_list> ::= [USER] <role_grantee> [,[USER] <role_grantee> [, …]]

  <role_grantee> ::= {username | PUBLIC }
  *)

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'GRANT', [toFirstToken, toFindWordLast]);
    TA:=AddSQLTokens(stKeyword, FSQLTokens, 'ALL', [], 1);
      TAP:=AddSQLTokens(stKeyword, TA, 'PRIVILEGES', []);
    TS:=AddSQLTokens(stKeyword, FSQLTokens, 'SELECT', [], 2);
    TD:=AddSQLTokens(stKeyword, FSQLTokens, 'DELETE', [], 3);
    TI:=AddSQLTokens(stKeyword, FSQLTokens, 'INSERT', [], 4);
    TU:=AddSQLTokens(stKeyword, FSQLTokens, 'UPDATE', [], 5);
    TR:=AddSQLTokens(stKeyword, FSQLTokens, 'REFERENCES', [], 6);
    T:=AddSQLTokens(stSymbol, [TS, TD, TI, TU], ',', []);
      T.AddChildToken([TS, TD, TI, TU, TR]);

    TSymb:=AddSQLTokens(stSymbol, TU, '(', []);
      TSymb:=AddSQLTokens(stIdentificator, TSymb, '', [], 7);
      T1:=AddSQLTokens(stSymbol, TSymb, ',', []);
      T1.AddChildToken(TSymb);
    TSymb:=AddSQLTokens(stIdentificator, TSymb, ')', []);
      TSymb.AddChildToken(T);

    TSymb1:=AddSQLTokens(stSymbol, TR, '(', []);
      TSymb1:=AddSQLTokens(stIdentificator, TSymb1, '', [], 8);
      T1:=AddSQLTokens(stSymbol, TSymb1, ',', []);
      T1.AddChildToken(TSymb1);
    TSymb1:=AddSQLTokens(stIdentificator, TSymb1, ')', []);
      TSymb1.AddChildToken(T);


  T:=AddSQLTokens(stKeyword, FSQLTokens, 'EXECUTE', [], 9);
  T:=AddSQLTokens(stKeyword, T, 'ON', []);
  TProc:=AddSQLTokens(stKeyword, T, 'PROCEDURE', []);

  TON:=AddSQLTokens(stKeyword, [TA, TAP, TS, TD, TI, TU, TR, TSymb, TSymb1] , 'ON', []);
    T:=AddSQLTokens(stKeyword, TON, 'TABLE', [], 10);
  T:=AddSQLTokens(stIdentificator, [TON, T, TProc] , '', [], 11);

  TTO:=AddSQLTokens(stKeyword, T, 'TO', [], 19);
    TTU:=AddSQLTokens(stKeyword, TTO, 'USER', [], 21);
    TTR:=AddSQLTokens(stKeyword, TTO, 'ROLE', [], 22);
      TTU1:=AddSQLTokens(stIdentificator, [TTU, TTO, TTR], '', [], 24);

    TTG:=AddSQLTokens(stKeyword, TTO, 'GROUP', [], 23);
      TTG1:=AddSQLTokens(stIdentificator, TTG, '', [], 24);
    TTP:=AddSQLTokens(stKeyword, TTO, 'PROCEDURE', [], 25);
      TTP1:=AddSQLTokens(stIdentificator, TTP, '', [], 24);
    TTT:=AddSQLTokens(stKeyword, TTO, 'TRIGGER', [], 26);
      TTT1:=AddSQLTokens(stIdentificator, TTT, '', [], 24);
    TTV:=AddSQLTokens(stKeyword, TTO, 'VIEW', [], 27);
      TTV1:=AddSQLTokens(stIdentificator, TTT, '', [], 24);
    TTPUB:=AddSQLTokens(stKeyword, TTO, 'PUBLIC', [], 28);

  TSymb2:=AddSQLTokens(stSymbol, [TTG1, TTP1, TTU1, TTT1, TTPUB, TTV1], ',', [toOptional], 19);
    TSymb2.AddChildToken([TTU, TTR, TTG, TTP, TTU1, TTT, TTV, TTPUB]);

  TWAO:=AddSQLTokens(stKeyword, [TTG1, TTP1, TTU1, TTT1, TTPUB, TTV1], 'WITH', [toOptional]);
    TWAO1:=AddSQLTokens(stKeyword, TWAO, 'GRANT', []);
    TWAO1:=AddSQLTokens(stKeyword, TWAO1, 'OPTION', [], 30);

  GB:=AddSQLTokens(stKeyword, [TTG1, TTP1, TTU1, TTT1, TTPUB, TTV1, TWAO1], 'GRANTED', [toOptional]);
    GB:=AddSQLTokens(stKeyword, GB, 'BY', [toOptional]);
  TAS:=AddSQLTokens(stKeyword, [TTG1, TTP1, TTU1, TTT1, TTPUB, TTV1, TWAO1], 'AS', [toOptional]);
    T:=AddSQLTokens(stKeyword, [GB, TAS], 'USER', []);
  T:=AddSQLTokens(stIdentificator, [GB, TAS, T], '', [], 31);


  TRole:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 40);
  TSymb3:=AddSQLTokens(stSymbol, TRole, ',', []);
    TSymb3.AddChildToken(TRole);

  T:=AddSQLTokens(stKeyword, TRole, 'TO', []);
    T1:=AddSQLTokens(stKeyword, T, 'USER', [], 41);
    T:=AddSQLTokens(stIdentificator, [T, T1], '', [], 42);
    TSymb3:=AddSQLTokens(stSymbol, T, ',', [toOptional]);
      TSymb3.AddChildToken([T, T1]);

  T.AddChildToken([TWAO,TAS,GB]);
end;

procedure TFBSQLGrant.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:GrantTypes:=GrantTypes + [ogSelect, ogInsert, ogUpdate, ogDelete, ogExecute, ogReference, ogAll];
    2:GrantTypes:=GrantTypes + [ogSelect];
    3:GrantTypes:=GrantTypes + [ogDelete];
    4:GrantTypes:=GrantTypes + [ogInsert];
    5:GrantTypes:=GrantTypes + [ogUpdate];
    6:GrantTypes:=GrantTypes + [ogReference];
    7:begin
        if not Assigned(FCurTable) then
          FCurTable:=Tables.Add('');
        FCurTable.Fields.AddParamWithType(AWord, 'UPDATE');
      end;
    8:begin
        if not Assigned(FCurTable) then
          FCurTable:=Tables.Add('');
        FCurTable.Fields.AddParamWithType(AWord, 'REFERENCES');
      end;
    9:begin
        GrantTypes:=GrantTypes + [ogExecute];
        ObjectKind:=okStoredProc;
      end;
    10:if Assigned(FCurTable) then
         FCurTable.ObjectKind:=okTable
       else
         FCurTable:=Tables.Add('', okTable);
    11:if Assigned(FCurTable) then
         FCurTable.Name:=AWord
       else
         FCurTable:=Tables.Add(AWord);
    19:begin
         //FCurParam:=nil;
         FCurGrantor:=nil;
       end;
    21:FCurGrantor:=Params.AddParam('');
    22:begin
         FCurGrantor:=Params.AddParam('');
         FCurGrantor.ObjectKind:=okRole;
       end;
    23:begin
         FCurGrantor:=Params.AddParam('');
         FCurGrantor.ObjectKind:=okGroup;
       end;
    24:begin
         if not Assigned(FCurGrantor) then
           FCurGrantor:=Params.AddParam(AWord)
         else
           FCurGrantor.Caption:=AWord;
       end;
    25:begin
         FCurGrantor:=Params.AddParam('');
         FCurGrantor.ObjectKind:=okStoredProc
       end;
    26:begin
         FCurGrantor:=Params.AddParam('');
         FCurGrantor.ObjectKind:=okTrigger
       end;
    27:begin
         FCurGrantor:=Params.AddParam('');
         FCurGrantor.ObjectKind:=okView
       end;
    28:begin
         FCurGrantor:=Params.AddParam(AWord);
         FCurGrantor.ObjectKind:=okNone
       end;
    30:GrantTypes:=GrantTypes + [ogWGO];
    31:UserGrantor:=AWord;
    40:begin
         FCurTable:=Tables.Add(AWord);
         ObjectKind:=okRole;
       end;
    41:begin
         FCurGrantor:=Params.AddParam('');
         FCurGrantor.ObjectKind:=okUser;
       end;
    42:begin
         if not Assigned(FCurGrantor) then
           FCurGrantor:=Params.AddParam(AWord)
         else
           FCurGrantor.Caption:=AWord;
       end;
  end;
end;

procedure TFBSQLGrant.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLGrant then
  begin
    UserGrantor:=TFBSQLGrant(ASource).UserGrantor;
  end;
  inherited Assign(ASource);
end;

procedure TFBSQLGrant.MakeSQL;
var
  S, S1, SU, SR, SG: String;
  G: TObjectGrant;
  P, G1: TSQLParserField;
begin
  if Tables.Count < 0 then Exit;
  FCurTable:=Tables[0];
  S:='GRANT ';

  SG:='';
  for G1 in Params do
  begin
    if SG <> '' then SG:=SG + ', ';
    if G1.ObjectKind <> okNone then
      SG:=SG + FBObjectNames[G1.ObjectKind] + ' ';
    SG:=SG + DoFormatName(G1.Caption);
  end;

  if ObjectKind = okRole then
  begin
    S:=S + Params.AsString;
  end
  else
  begin
    SU:='';
    SR:='';
    for P in FCurTable.Fields do
    begin
      if P.TypeName ='UPDATE' then
      begin
        if SU<>'' then SU:=SU + ', ';
        SU:=SU+P.Caption
      end
      else
      if P.TypeName ='REFERENCES' then
      begin
        if SR<>'' then SR:=SR + ', ';
        SR:=SR+P.Caption
      end
    end;


    if ((GrantTypes * [ogSelect, ogInsert, ogUpdate, ogDelete, ogReference]) = [ogSelect, ogInsert, ogUpdate, ogDelete, ogReference]) and (FCurTable.Fields.Count = 0) then
      S:=S + 'ALL PRIVILEGES'
    else
    begin
      S1:='';
      for G in GrantTypes do
      begin
        if G <> ogWGO then
        begin
          if S1<>'' then S1:=S1 + ', ';
          S1:=S1 + ObjectGrantNames[G];
          if (G = ogUpdate) and (SU <> '') then S1:=S1+'('+SU + ')'
          else
          if (G = ogReference) and (SR <> '') then S1:=S1+'('+SR + ')';
        end;
      end;
      S:=S + S1;
    end;
    S:=S + ' ON';
    if ObjectKind=okTable then
      S:=S + ' TABLE'
    else
    if ObjectKind=okStoredProc then
      S:=S + ' PROCEDURE';
  end;

  S:=S + ' ' +DoFormatName2(FCurTable.Name) + ' TO '+SG;

  if ogWGO in GrantTypes then
    S:=S + ' WITH GRANT OPTION';

  if UserGrantor <> '' then
    S:=S + ' GRANTED BY USER '+UserGrantor;
  AddSQLCommand(S);
end;

{ TFBSQLSet }

procedure TFBSQLSet.InitParserTree;
var
  FSQLTokens, T, T1: TSQLTokenRecord;
begin
  (*
  1.
  SET SQL DIALECT 3;
  2.
  SET TERM ; ^
  3.
  SET STATISTICS indexname
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'SET', [toFirstToken]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'SQL', []);
    T:=AddSQLTokens(stKeyword, T, 'DIALECT', [toFindWordLast]);
    T:=AddSQLTokens(stInteger, T, '', [], 1);
  T1:=AddSQLTokens(stKeyword, FSQLTokens, 'TERM', [toFindWordLast]);
    T:=AddSQLTokens(stDelimiter, T1, ';', [], 2);
    T:=AddSQLTokens(stSymbol, T, '^', [], 3);

    T:=AddSQLTokens(stDelimiter, T1, '^', [], 2);
    T:=AddSQLTokens(stSymbol, T, ';', [], 3);
end;

procedure TFBSQLSet.MakeSQL;
var
  S: String;
begin
  S:='SET ';
  case FSetParam of
    tsetSqlDialect,
    tsetTerm:S:=S + Name + ' ' + Value + ' ' + Value2;
  end;
  AddSQLCommand(S);
end;

procedure TFBSQLSet.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:begin
        FSetParam:=tsetSqlDialect;
        Name:='SQL DIALECT';
        Value:=AWord;
      end;
    2:begin
        FSetParam:=tsetTerm;
        Name:='TERM';
        Value:=AWord;
      end;
    3:Value2:=AWord;
  end;
end;

procedure TFBSQLSet.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLSet then
  begin
    Value:=TFBSQLSet(ASource).Value;
    Value2:=TFBSQLSet(ASource).Value2;
    SetParam:=TFBSQLSet(ASource).SetParam;

  end;
  inherited Assign(ASource);
end;


{ TFBSQLCreateCollation }

procedure TFBSQLCreateCollation.InitParserTree;
var
  FSQLTokens, T, T1, T2: TSQLTokenRecord;
begin
  (*
  CREATE COLLATION collname
  FOR charset
  [FROM basecoll | FROM EXTERNAL ('extname')]
  [NO PAD | PAD SPACE]
  [CASE [IN]SENSITIVE]
  [ACCENT [IN]SENSITIVE]
  ['<specific-attributes>'];

  <specific-attributes> ::= <attribute> [; <attribute> ...]

  <attribute> ::= attrname=attrvalue
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okRole);
    FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'COLLATION', [toFindWordLast]);
  FSQLTokens:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'FOR', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 2);

  T1:=AddSQLTokens(stKeyword, T, 'FROM', []);
  T1:=AddSQLTokens(stIdentificator, T1, '', [], 3);

  T2:=AddSQLTokens(stSymbol, T1, '(', []);
  T2:=AddSQLTokens(stString, T2, '', [], 4);
  T2:=AddSQLTokens(stSymbol, T2, ')', []);

  //[NO PAD | PAD SPACE]
end;

procedure TFBSQLCreateCollation.MakeSQL;
var
  S: String;
begin
  S:='CREATE COLLATION '+Name+ ' FOR ' + CharSet;

  AddSQLCommand(S);
end;

procedure TFBSQLCreateCollation.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:Name:=AWord;
    2:CharSet:=AWord;
  end;
end;

constructor TFBSQLCreateCollation.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okCollation;
end;

procedure TFBSQLCreateCollation.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLCreateCollation then
  begin
    CharSet:=TFBSQLCreateCollation(ASource).CharSet;

  end;
  inherited Assign(ASource);
end;

{ TFBSQLAlterCharset }

procedure TFBSQLAlterCharset.InitParserTree;
var
  FSQLTokens: TSQLTokenRecord;
begin
  (*
  ALTER CHARACTER SET charset
  SET DEFAULT COLLATION collation;
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken], 0, okRole);
    FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'CHARACTER', []);
    FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'SET', [toFindWordLast]);
  FSQLTokens:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'SET', []);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'DEFAULT', []);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'COLLATION', []);
  FSQLTokens:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 2);
end;

procedure TFBSQLAlterCharset.MakeSQL;
begin
  AddSQLCommandEx('ALTER CHARACTER SET %s SET DEFAULT COLLATION %s', [Name, Collation]);
end;

procedure TFBSQLAlterCharset.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:Name:=AWord;
    2:Collation:=AWord;
  end;
end;

constructor TFBSQLAlterCharset.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okCharSet;
end;

procedure TFBSQLAlterCharset.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLAlterCharset then
  begin
    Collation:=TFBSQLAlterCharset(ASource).Collation;

  end;
  inherited Assign(ASource);
end;

{ TFBSQLDropUDF }

procedure TFBSQLDropUDF.InitParserTree;
var
  FSQLTokens: TSQLTokenRecord;
begin
  (*
  DROP EXTERNAL FUNCTION funcname
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okRole);
    FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'EXTERNAL', []);
    FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'FUNCTION', [toFindWordLast]);
  FSQLTokens:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
end;

procedure TFBSQLDropUDF.MakeSQL;
begin
  AddSQLCommand('DROP EXTERNAL FUNCTION ' + DoFormatName(Name));
end;

procedure TFBSQLDropUDF.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:Name:=AWord;
  end;
end;

constructor TFBSQLDropUDF.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okUDF;
end;

{ TFBSQLAlterUDF }

procedure TFBSQLAlterUDF.InitParserTree;
var
  FSQLTokens, TName, TEP, T, TLN: TSQLTokenRecord;
begin
  (*
  ALTER EXTERNAL FUNCTION funcname
  [ENTRY_POINT 'new_entry_point']
  [MODULE_NAME 'new_library_name'];
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken]);
    FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'EXTERNAL', []);
    FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'FUNCTION', [toFindWordLast]);
  TName:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);

  TEP:=AddSQLTokens(stKeyword, TName, 'ENTRY_POINT', [toOptional]);
    T:=AddSQLTokens(stString, TEP, '', [], 2);
  TLN:=AddSQLTokens(stKeyword, [T, TName], 'MODULE_NAME', [toOptional]);
    T:=AddSQLTokens(stString, TLN, '', [], 3);
    T.AddChildToken(TEP);
end;

procedure TFBSQLAlterUDF.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:Name:=AWord;
    2:EntryPoint:=AWord;
    3:LibraryName:=AWord;
  end;
end;

procedure TFBSQLAlterUDF.MakeSQL;
var
  S: String;
begin
  S:='ALTER EXTERNAL FUNCTION ' + Name;
  if EntryPoint <> '' then
    S:=S + ' ENTRY_POINT ' + EntryPoint;
  if LibraryName <> '' then
    S:=S + ' MODULE_NAME ' + LibraryName;
  AddSQLCommand(S);
  if Description <> '' then
    DescribeObject;
end;

constructor TFBSQLAlterUDF.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okUDF;
  FSQLCommentOnClass:=TFBSQLCommentOn;
end;

procedure TFBSQLAlterUDF.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLAlterUDF then
  begin
    EntryPoint:=TFBSQLAlterUDF(ASource).EntryPoint;
    LibraryName:=TFBSQLAlterUDF(ASource).LibraryName;
  end;
  inherited Assign(ASource);
end;

{ TFBSQLCreateUDF }

procedure TFBSQLCreateUDF.InitParserTree;
var
  FSQLTokens, T, TName, TSymb,  TP1, TS1, T2, T2_1,
    TNull, T2_2, T3, T4, T5, TRet: TSQLTokenRecord;
begin
(*
DECLARE EXTERNAL FUNCTION funcname
[<arg_type_decl> [, <arg_type_decl> ...]]
RETURNS {
  sqltype [BY {DESCRIPTOR | VALUE}] |
  CSTRING(length) |
  PARAMETER param_num }
[FREE_IT]
ENTRY_POINT 'entry_point' MODULE_NAME 'library_name';

<arg_type_decl> ::=
  sqltype [{BY DESCRIPTOR} | NULL] |
  CSTRING(length) [NULL]
*)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DECLARE', [toFirstToken]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'EXTERNAL', []);
    T:=AddSQLTokens(stKeyword, T, 'FUNCTION', [toFindWordLast]);
  TName:=AddSQLTokens(stIdentificator, T, '', [], 100);

    TP1:=AddSQLTokens(stKeyword, T, 'CSTRING', [], 2);
      TS1:=AddSQLTokens(stSymbol, TP1, '(', []);
      T:=AddSQLTokens(stInteger, TS1, '', [], 104);
      TS1:=AddSQLTokens(stSymbol, T, ')', []);
      TNull:=AddSQLTokens(stKeyword, TS1, 'NULL', [], 113);
      T2:=AddSQLTokens(stKeyword, TS1, 'BY', []);
      T2_1:=AddSQLTokens(stKeyword, T2, 'DESCRIPTOR', [], 113);

  TSymb:=AddSQLTokens(stSymbol, [TS1, TNull, T2_1], ',', [], 101);
    TSymb.AddChildToken(TP1);


  TRet:=AddSQLTokens(stKeyword, [TNull, T2_1, TS1], 'RETURNS', []);

  MakeTypeDefTree(Self, [TName, TSymb], [TSymb, TNull, T2, TRet], tdfTypeOnly, 100);

  TP1:=AddSQLTokens(stKeyword, TRet, 'CSTRING', [], 120);
    TS1:=AddSQLTokens(stSymbol, TP1, '(', []);
    T:=AddSQLTokens(stInteger, TS1, '', [], 121);
    TS1:=AddSQLTokens(stSymbol, T, ')', []);
  T2:=AddSQLTokens(stKeyword, TS1, 'BY', []);
    T2_1:=AddSQLTokens(stKeyword, T2, 'DESCRIPTOR', [], 122);
    T2_2:=AddSQLTokens(stKeyword, T2, 'VALUE', [], 123);
  T3:=AddSQLTokens(stKeyword, TRet, 'PARAMETER', [], 124);
    T3:=AddSQLTokens(stInteger, T3, '', [], 125);

  T4:=AddSQLTokens(stKeyword, [TP1, TS1, T3, T2_1, T2_2], 'FREE_IT', [], 126);
  T5:=AddSQLTokens(stKeyword, [T4, TP1, TS1, T3, T2_1, T2_2], 'ENTRY_POINT', []);
  MakeTypeDefTree(Self, [TRet], [T2, T4, T3, T5], tdfTypeOnly, 200);

  T5:=AddSQLTokens(stString, T5, '', [], 127);
  T5:=AddSQLTokens(stKeyword, T5, 'MODULE_NAME', []);
  T5:=AddSQLTokens(stString, T5, '', [], 128);


end;

procedure TFBSQLCreateUDF.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    100:Name:=AWord;
    101: FCurParam:=nil;
    102:FCurParam:=Params.AddParamWithType('', AWord);
    120,
    125,
    202:ResultParam.TypeName:=AWord;
    104:if Assigned(FCurParam) then FCurParam.TypeLen:=StrToInt(AWord);
    105:if Assigned(FCurParam) then FCurParam.TypePrec:=StrToInt(AWord);
    113:if Assigned(FCurParam) then FCurParam.DefaultValue:='BY DESCRIPTOR';
    121:ResultParam.TypeLen:=StrToInt(AWord);
    122:ResultParam.DefaultValue:='BY DESCRIPTOR';
    123:ResultParam.DefaultValue:='BY VALUE';
    124:ResultParam.Caption:=AWord;
    126:ResultFreeIt:=true;
    127:EntryPoint:=AWord;
    128:LibraryName:=AWord;
  end;
end;

procedure TFBSQLCreateUDF.MakeSQL;
var
  S, S1: String;
  P: TSQLParserField;
begin
  S:='DECLARE EXTERNAL FUNCTION '+Name;
(*[<arg_type_decl> [, <arg_type_decl> ...]]
RETURNS {
  sqltype [BY {DESCRIPTOR | VALUE}] |
  CSTRING(length) |
  PARAMETER param_num }
[FREE_IT]
ENTRY_POINT 'entry_point' MODULE_NAME 'library_name';

<arg_type_decl> ::=
  sqltype [{BY DESCRIPTOR} | NULL] |
  CSTRING(length) [NULL]
*)
  S1:='';
  for P in Params do
  begin
    if S1<>'' then S1:=S1 + ', ';
    S1 := S1 + P.TypeName;
    if P.TypeLen > 0 then
      S1:=S1+'('+IntToStr(P.TypeLen)+')';
    if P.DefaultValue <> '' then
      S1:=S1+' '+P.DefaultValue;
  end;

  if S1 <> '' then
    S:=S + LineEnding + S1;
  S:=S + LineEnding + 'RETURNS';

  if ResultParam.Caption <> '' then
    S:=S + ' ' + ResultParam.Caption;
  S:=S + ' ' + ResultParam.TypeName;
  if ResultParam.TypeLen > 0 then
    S:=S+'('+IntToStr(P.TypeLen)+')';

  if ResultParam.DefaultValue <> '' then
    S:=S+' '+ResultParam.DefaultValue;

  if ResultFreeIt then
    S:=S + ' FREE_IT';
  S:=S + LineEnding +'ENTRY_POINT '+EntryPoint + ' MODULE_NAME ' + LibraryName;

  AddSQLCommand(S);
  if Description <> '' then
    DescribeObject;
end;

constructor TFBSQLCreateUDF.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okUDF;
  FSQLCommentOnClass:=TFBSQLCommentOn;
  FResultParam:=TSQLParserField.Create;
end;

destructor TFBSQLCreateUDF.Destroy;
begin
  FreeAndNil(FResultParam);
  inherited Destroy;
end;

procedure TFBSQLCreateUDF.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLCreateUDF then
  begin
    ResultParam.Assign(TFBSQLCreateUDF(ASource).ResultParam);
    ResultFreeIt:=TFBSQLCreateUDF(ASource).ResultFreeIt;
    EntryPoint:=TFBSQLCreateUDF(ASource).EntryPoint;
    LibraryName:=TFBSQLCreateUDF(ASource).LibraryName;
  end;
  inherited Assign(ASource);
end;

{ TFBSQLCommentOn }

procedure TFBSQLCommentOn.InitParserTree;
var
  FSQLTokens, T, T10, T11, T13, T15, T15_1, T14, T16, T17, T18,
    T25, T24, T23, T22, T21, T20, T19, T25_1, TS, T26, T26_1,
    TName, T11_1, T12, T26_2, T27, TName1, T28: TSQLTokenRecord;
begin
  (*
  COMMENT ON <object> IS {'sometext' | NULL}

  <object> ::=
      DATABASE
    | <basic-type> objectname
    | COLUMN relationname.fieldname
    | PARAMETER procname.paramname

  <basic-type> ::=
    CHARACTER SET |
    COLLATION |
    DOMAIN |
    EXCEPTION |
    EXTERNAL FUNCTION |
    FILTER |
    GENERATOR |
    INDEX |
    PROCEDURE |
    ROLE |
    SEQUENCE |
    TABLE |
    TRIGGER |
    VIEW
  *)

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'COMMENT', [toFirstToken]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'ON', [toFindWordLast]);

  T10:=AddSQLTokens(stKeyword, T, 'DATABASE', [], 10);

  T11:=AddSQLTokens(stKeyword, T, 'CHARACTER', [], 11);
    T11_1:=AddSQLTokens(stKeyword, T11, 'SET', []);
  T12:=AddSQLTokens(stKeyword, T, 'COLLATION', [], 12);
  T13:=AddSQLTokens(stKeyword, T, 'DOMAIN', [], 13);
  T14:=AddSQLTokens(stKeyword, T, 'EXCEPTION', [], 14);
  T15:=AddSQLTokens(stKeyword, T, 'EXTERNAL', [], 15);
    T15_1:=AddSQLTokens(stKeyword, T15, 'FUNCTION', []);
  T16:=AddSQLTokens(stKeyword, T, 'FILTER', [], 16);
  T17:=AddSQLTokens(stKeyword, T, 'GENERATOR', [], 17);
  T18:=AddSQLTokens(stKeyword, T, 'INDEX', [], 18);
  T19:=AddSQLTokens(stKeyword, T, 'PROCEDURE', [], 19);
  T20:=AddSQLTokens(stKeyword, T, 'ROLE', [], 20);
  T21:=AddSQLTokens(stKeyword, T, 'SEQUENCE', [], 21);
  T22:=AddSQLTokens(stKeyword, T, 'TABLE', [], 22);
  T23:=AddSQLTokens(stKeyword, T, 'TRIGGER', [], 23);
  T24:=AddSQLTokens(stKeyword, T, 'VIEW', [], 24);
  T27:=AddSQLTokens(stKeyword, T, 'PACKAGE', [], 27);
  T28:=AddSQLTokens(stKeyword, T, 'FUNCTION', [], 28);

  TName:=AddSQLTokens(stIdentificator, [T11_1, T12, T13, T14, T15_1, T16, T17,
      T18, T19, T20, T21, T22, T23, T24, T27, T28], '', [], 1);
  TName1:=AddSQLTokens(stSymbol, TName, '.', []);
  TName1:=AddSQLTokens(stIdentificator, TName1, '', [], 3);

  T25:=AddSQLTokens(stKeyword, T, 'COLUMN', [], 25);        //COLUMN relationname.fieldname
    T25_1:=AddSQLTokens(stIdentificator, T25, '', [], 251);
    TS:=AddSQLTokens(stSymbol, T25_1, '.', []);
    T25_1:=AddSQLTokens(stIdentificator, TS, '', [], 252);
  T26:=AddSQLTokens(stKeyword, [T, T19, T28], 'PARAMETER', [], 26);     //PARAMETER procname.paramname
    T26_1:=AddSQLTokens(stIdentificator, T26, '', [], 261);
    TS:=AddSQLTokens(stSymbol, T26_1, '.', []);
    T26_1:=AddSQLTokens(stIdentificator, TS, '', [], 262);
    TS:=AddSQLTokens(stSymbol, T26_1, '.', []);
    T26_2:=AddSQLTokens(stIdentificator, TS, '', [], 263);

  T:=AddSQLTokens(stKeyword, [T10, TName, TName1, T25_1, T26_1, T26_2], 'IS', []);
     AddSQLTokens(stString, T, '', [], 2);
     AddSQLTokens(stKeyword, T, 'NULL', [], 2);
end;

procedure TFBSQLCommentOn.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
    2:Description:=ExtractQuotedString(AWord, '''');
    3:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
    10:ObjectKind:=okDatabase;
    11:ObjectKind:=okCharSet;
    12:ObjectKind:=okCollation;
    13:ObjectKind:=okDomain;
    14:ObjectKind:=okException;
    15:ObjectKind:=okUDF;
    16:ObjectKind:=okFilter;
    17:ObjectKind:=okSequence;
    18:ObjectKind:=okIndex;
    19:ObjectKind:=okStoredProc;
    20:ObjectKind:=okRole;
    21:ObjectKind:=okSequence;
    22:ObjectKind:=okTable;
    23:ObjectKind:=okTrigger;
    24:ObjectKind:=okView;
    25:ObjectKind:=okColumn;
    27:ObjectKind:=okPackage;
    28:ObjectKind:=okFunction;
    251:TableName:=AWord;
    252:Name:=AWord;
    26:begin
         if ObjectKind = okStoredProc then
           ObjectKind:=okProcedureParametr
         else
         if ObjectKind = okFunction then
           ObjectKind:=okFunctionParametr
         else
           ObjectKind:=okParameter;
       end;
    261:TableName:=AWord;
    262:Name:=AWord;
    263:begin
          SchemaName:=TableName;
          TableName:=Name;
          Name:=AWord;
        end;
  end;
end;

procedure TFBSQLCommentOn.MakeSQL;
var
  S, S1: String;
begin
  S:='COMMENT ON ' + FBObjectNames[ObjectKind];
  if ObjectKind in [okCharSet, okCollation, okDomain, okException,
    okUDF, okFilter, okSequence, okIndex, okStoredProc, okRole,
    okTable, okTrigger, okView, okFunction, okPackage] then
    S:=S + ' ' + FullName
  else
  if ObjectKind in [okColumn, okParameter, okProcedureParametr, okFunctionParametr] then
  begin
    if SchemaName<>'' then S1:=DoFormatName(SchemaName)+'.'
    else S1:='' ;
    S:=S + ' ' + S1 + DoFormatName(TableName) + '.' + DoFormatName(Name)
  end;


  S:=S + ' IS ' + QuotedString(TrimRight(Description), '''');
  AddSQLCommand(S);
end;

{ TFBSQLDropRole }

procedure TFBSQLDropRole.InitParserTree;
var
  FSQLTokens, T: TSQLTokenRecord;
begin
  //DROP EXCEPTION ROLE
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okRole);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'ROLE', [toFindWordLast]);
    T:=AddSQLTokens(stIdentificator, T, '', [], 1);
end;

procedure TFBSQLDropRole.MakeSQL;
begin
  AddSQLCommandEx('DROP ROLE %s', [FullName]);
end;

procedure TFBSQLDropRole.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
  end;
end;

constructor TFBSQLDropRole.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okRole;
end;

{ TFBSQLCreateRole }

procedure TFBSQLCreateRole.InitParserTree;
var
  FSQLTokens, T: TSQLTokenRecord;
begin
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okRole);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'ROLE', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
end;

procedure TFBSQLCreateRole.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
  end;
end;

procedure TFBSQLCreateRole.MakeSQL;
begin
  AddSQLCommandEx('CREATE ROLE %s', [FullName]);
  if Description <> '' then
    DescribeObject;
end;

constructor TFBSQLCreateRole.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okRole;
  FSQLCommentOnClass:=TFBSQLCommentOn;
end;

{ TFBSQLDropProcedure }

procedure TFBSQLDropProcedure.InitParserTree;
var
  FSQLTokens, T: TSQLTokenRecord;
begin
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okStoredProc);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'PROCEDURE', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
end;

procedure TFBSQLDropProcedure.MakeSQL;
begin
  AddSQLCommand('DROP PROCEDURE ' + FullName);
end;

procedure TFBSQLDropProcedure.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord
  end;
end;

constructor TFBSQLDropProcedure.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okStoredProc;
end;

{ TFBSQLDropTrigger }

procedure TFBSQLDropTrigger.InitParserTree;
var
  FSQLTokens, T: TSQLTokenRecord;
begin
  // DROP TRIGGER name
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okTable);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'TRIGGER', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
end;

procedure TFBSQLDropTrigger.MakeSQL;
begin
  AddSQLCommand('DROP TRIGGER ' + FullName);
end;

procedure TFBSQLDropTrigger.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord
  end;
end;

{ TFBSQLDropTable }

procedure TFBSQLDropTable.InitParserTree;
var
  FSQLTokens, T: TSQLTokenRecord;
begin
  (*
  DROP TABLE  name
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okTable);    //DROP TABLE
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'TABLE', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
end;

procedure TFBSQLDropTable.MakeSQL;
begin
  AddSQLCommand('DROP TABLE ' + FullName);
end;

procedure TFBSQLDropTable.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord
  end;
end;

{ TFBSQLDropView }

procedure TFBSQLDropView.InitParserTree;
var
  T, T1, FSQLTokens: TSQLTokenRecord;
begin
  (*
  DROP VIEW [ IF EXISTS ] [schema .] name
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okView);    //DROP VIEW
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'VIEW', [toFindWordLast]);
  T1:=AddSQLTokens(stKeyword, T, 'IF', []);
  T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', [], -1);
    AddSQLTokens(stIdentificator, [T, T1], '', [], 2);
end;

procedure TFBSQLDropView.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    2:Name:=AWord;
  end;
end;

procedure TFBSQLDropView.MakeSQL;
var
  S: String;
begin
  S:='DROP VIEW ';
  S:=S + FullName;
  AddSQLCommand(S);
end;

{ TFBSQLDropDomain }

procedure TFBSQLDropDomain.InitParserTree;
var
  FSQLTokens, T: TSQLTokenRecord;
begin
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okDomain);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'DOMAIN', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
end;

procedure TFBSQLDropDomain.MakeSQL;
begin
  AddSQLCommand('DROP DOMAIN '+FullName);
end;

procedure TFBSQLDropDomain.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  if AChild.Tag = 1 then
    Name:=AWord;
end;

{ TFBSQLAlterDomain }

procedure TFBSQLAlterDomain.InitParserTree;
var
  T1, FSQLTokens, T, T2, T1_1, TC1, TC1_1, TC2, T3, TD1, TD2,
    TD3, TD4: TSQLTokenRecord;
begin
  (*
  ALTER DOMAIN name
    [{TO new_name }]
    [{SET | DROP} NOT NULL]

    [{SET DEFAULT { literal | NULL | <context_var> } | DROP DEFAULT}]
    [{ADD [CONSTRAINT] CHECK ( <dom_condition> ) | DROP CONSTRAINT}]
    [{TYPE <datatype> }];

  <datatype> ::=
  {SMALLINT | INT[EGER] | BIGINT} [ <array_dim> ]
  | BOOLEAN [ <array_dim> ]
  | {FLOAT | DOUBLE PRECISION} [ <array_dim> ]
  | {DATE | TIME | TIMESTAMP} [ <array_dim> ]
  | {DECIMAL | NUMERIC} [( precision [, scale ])] [ <array_dim> ]
  | {CHAR | CHARACTER | CHARACTER VARYING | VARCHAR} [( size )]
  [ <array_dim> ] [CHARACTER SET charset ]
  | {NCHAR | NATIONAL CHARACTER | NATIONAL CHAR} [VARYING]
  [( size )] [ <array_dim> ]
  | BLOB [SUB_TYPE { subtype_num | subtype_name }]
  [SEGMENT SIZE seglen ] [CHARACTER SET charset ]
  | BLOB [( seglen [, subtype_num ])]
  <array_dim> ::= [ x : y [, x : y ...]]
  <dom_condition> ::= {
  <val> <operator> <val>
  | <val> [NOT] BETWEEN <val> AND <val>
  | <val> [NOT] IN ( <val> [, <val> ...] | <select_list> )
  | <val> IS [NOT] NULL
  | <val> IS [NOT] DISTINCT <val>
  | <val> [NOT] CONTAINING <val>
  | <val> [NOT] STARTING [WITH] <val>
  | <val> [NOT] LIKE <val> [ESCAPE <val> ]
  | <val> [NOT] SIMILAR TO <val> [ESCAPE <val> ]
  | <val> <operator> {ALL | SOME | ANY} ( <select_list> )
  | [NOT] EXISTS ( <select_expr> )
  | [NOT] SINGULAR ( <select_expr> )
  | ( <dom_condition> )
  | NOT <dom_condition>
  | <dom_condition> OR <dom_condition>
  | <dom_condition> AND <dom_condition>
  <operator> ::= {= | < | > | <= | >= | !< | !> | <> | !=}
  <val> ::= {
  VALUE
  | literal
  | <context_var>
  | <expression>
  | NULL
  | NEXT VALUE FOR genname
  | GEN_ID( genname , <val> )
  | CAST( <val> AS <datatype> )
  | ( <select_one> )
  | func( <val> [, <val> ...])
  }
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken], 0, okDomain);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'DOMAIN', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
    T1:=AddSQLTokens(stKeyword, T, 'TO', []);
    AddSQLTokens(stIdentificator, T1, '', [], 2);


  T1:=AddSQLTokens(stKeyword, T, 'SET', []);
  T1_1:=AddSQLTokens(stKeyword, T1, 'DEFAULT', []);
    AddSQLTokens(stString, T1_1, '', [], 10);
    AddSQLTokens(stInteger, T1_1, '', [], 10);
    AddSQLTokens(stIdentificator, T1_1, '', [], 10);
    AddSQLTokens(stKeyword, T1_1, 'NULL', [], 10);
    AddSQLTokens(stKeyword, T1_1, 'USER', [], 10);
    T2:=AddSQLTokens(stKeyword, T1, 'NOT', []);
    T2:=AddSQLTokens(stKeyword, T2, 'NULL', [], 41);

  TD1:=AddSQLTokens(stKeyword, T, 'DROP', [toOptional]);
    TD2:=AddSQLTokens(stKeyword, TD1, 'DEFAULT', [], 20);
    TD3:=AddSQLTokens(stKeyword, TD1, 'CONSTRAINT', [], 40);
    TD4:=AddSQLTokens(stKeyword, TD1, 'NOT', []);
    TD4:=AddSQLTokens(stKeyword, TD4, 'NULL', [], 42);

  TC1:=AddSQLTokens(stKeyword, [T, TD2, TD3, TD4], 'ADD', [toOptional]);     //[ADD [CONSTRAINT] CHECK (<dom_search_condition>)]
    TC1_1:=AddSQLTokens(stKeyword, TC1, 'CONSTRAINT', []);
  TC2:=AddSQLTokens(stKeyword, [TC1, TC1_1], 'CHECK', [], 30);

  T3:=AddSQLTokens(stKeyword, [T, TC2, TD2, TD3, TD4], 'TYPE', [toOptional], 50);
    MakeTypeDefTree(Self, T3, [TC1, TD1], tdfDomain, 50);
end;

procedure TFBSQLAlterDomain.MakeSQL;

function MakeTypeStr(AField: TSQLParserField):string;
begin
  Result:=AField.FullTypeName;
  if AField.ArrayDimension.Count>0 then
  begin
    AField.ArrayDimension.ArrayFormat:=fafFirebirdSQL;
    Result:=Result+AField.ArrayDimension.AsString;
  end;

  if AField.CharSetName <> '' then
    Result:=Result + ' CHARACTER SET ' + AField.CharSetName;

  if AField.Collate <> '' then
    Result:=Result + ' COLLATE ' + AField.Collate;

  if AField.DefaultValue <> '' then
    Result:=Result + ' DEFAULT '+AField.DefaultValue;

  if fpNotNull in AField.Params then
    Result:=Result + ' NOT NULL';

//  if F.ComputedSource <> '' then
//    S1:=S1 + ' COMPUTED BY (' + F.ComputedSource + ')'
end;

var
  S, S1: String;
  OP: TAlterDomainOperator;
begin
  S:='ALTER DOMAIN '+FullName;
  S1:='';
  for OP in Operators do
  begin
    case OP.AlterAction of
      adaRenameDomain: S1:=S1 + LineEnding + '  TO '+OP.ParamValue; //AddSQLCommand(S + ' TO '+OP.ParamValue);
      adaSetDefault:S1:=S1 + LineEnding + '  SET DEFAULT '+OP.ParamValue; //AddSQLCommand(S + ' SET DEFAULT '+OP.ParamValue);
      adaDropDefault:S1:=S1 + LineEnding + '  DROP DEFAULT';//AddSQLCommand(S + ' DROP DEFAULT');
      adaSetNotNull:S1:=S1 + LineEnding + '  SET NOT NULL';//AddSQLCommand(S + ' SET NOT NULL');
      adaDropNotNull:S1:=S1 + LineEnding + '  DROP NOT NULL';//AddSQLCommand(S + ' DROP NOT NULL');
      adaDropConstraint:S1:=S1 + LineEnding + '  DROP CONSTRAINT';//AddSQLCommand(S + ' DROP CONSTRAINT');
      adaAddConstraint:S1:=S1 + LineEnding + Format('  ADD CONSTRAINT CHECK (%s)', [OP.ParamValue]);//AddSQLCommandEx(S + ' ADD CONSTRAINT CHECK (%s)', [OP.ParamValue]);
      adaType:S1:=S1 + LineEnding + '  TYPE '+MakeTypeStr(OP.Params[0]);//AddSQLCommand(S + ' TYPE '+MakeTypeStr(OP.Params[0]));
    else
      raise Exception.CreateFmt('Uknow AlterDomain command : %s', [AlterDomainActionStr[OP.AlterAction]]);
    end;
  end;

  if S1<>'' then
    AddSQLCommand(S + S1);
  if Description<>'' then
    DescribeObject;
end;

procedure TFBSQLAlterDomain.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:Name:=AWord;
    2:Operators.AddItem(adaRenameDomain, AWord);
    10:Operators.AddItem(adaSetDefault, AWord);
    20:Operators.AddItem(adaDropDefault);
    30:begin
        if ASQLParser.GetNextWord<>'(' then
          SetError(ASQLParser, '(')
        else
          Operators.AddItem(adaAddConstraint, ASQLParser.GetToBracket(')'));
       end;
    40:Operators.AddItem(adaDropConstraint);
    41:Operators.AddItem(adaSetNotNull);
    42:Operators.AddItem(adaDropNotNull);

    50:begin
         FCurOperator:=Operators.AddItem(adaType);
         FCurField:=FCurOperator.Params.AddParam('');
       end;
    52:FCurField.TypeName:=AWord;
    53:FCurField.TypeName:='DOUBLE PRECISION';
    54:FCurField.TypeLen:=StrToInt(AWord);
    55:FCurField.TypePrec:=StrToInt(AWord);
    56:FCurField.TypeName:='CHARACTER VARYING';
    57:FCurField.CharSetName:=AWord;
    58:FCurField.NotNull:=true;
    59:FCurField.CheckExpr:=ASQLParser.GetToBracket(')');
    60:FCurField.Collate:=AWord;
    61:FCurField.TypeName:='NATIONAL CHARACTER';
    62:FCurField.TypeName:='NATIONAL CHAR';
    63:FCurField.DefaultValue:=AWord;
  end;
end;

constructor TFBSQLAlterDomain.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSQLCommentOnClass:=TFBSQLCommentOn;
end;

{ TFBSQLCreateDomain }

procedure TFBSQLCreateDomain.InitParserTree;
var
  FSQLTokens, T, T1: TSQLTokenRecord;
begin
  (*
  CREATE DOMAIN name [AS] <datatype>
  [DEFAULT {literal | NULL | <context_var>}]
  [NOT NULL] [CHECK (<dom_condition>)]
  [COLLATE collation_name];

  <datatype> ::=
      {SMALLINT | INTEGER | BIGINT} [<array_dim>]
    | {FLOAT | DOUBLE PRECISION} [<array_dim>]
    | {DATE | TIME | TIMESTAMP} [<array_dim>]
    | {DECIMAL | NUMERIC} [(precision [, scale])] [<array_dim>]
    | {CHAR | CHARACTER | CHARACTER VARYING | VARCHAR} [(size)]
      [<array_dim>] [CHARACTER SET charset_name]
    | {NCHAR | NATIONAL CHARACTER | NATIONAL CHAR} [VARYING]
      [(size)] [<array_dim>]
    | BLOB [SUB_TYPE {subtype_num | subtype_name}]
      [SEGMENT SIZE seglen] [CHARACTER SET charset_name]
    | BLOB [(seglen [, subtype_num])]

  <array_dim> ::= [[m:]n [,[m:]n ...]]

  <dom_condition> ::=
      <val> <operator> <val>
    | <val> [NOT] BETWEEN <val> AND <val>
    | <val> [NOT] IN (<val> [, <val> ...] | <select_list>)
    | <val> IS [NOT] NULL
    | <val> IS [NOT] DISTINCT FROM <val>
    | <val> [NOT] CONTAINING <val>
    | <val> [NOT] STARTING [WITH] <val>
    | <val> [NOT] LIKE <val> [ESCAPE <val>]
    | <val> [NOT] SIMILAR TO <val> [ESCAPE <val>]
    | <val> <operator> {ALL | SOME | ANY} (<select_list>)
    | [NOT] EXISTS (<select_expr>)
    | [NOT] SINGULAR (<select_expr>)
    | (<dom_condition>)
    | NOT <dom_condition>
    | <dom_condition> OR <dom_condition>
    | <dom_condition> AND <dom_condition>

  <operator> ::=
    <> | != | ^= | ~= | = | < | > | <= | >= | !< | ^< | ~< | !> | ^> | ~>

  <val> ::=
      VALUE
    | literal
    | <context_var>
    | <expression>
    | NULL
    | NEXT VALUE FOR genname
    | GEN_ID(genname, <val>)
    | CAST(<val> AS <datatype>)
    | (<select_one>)
    | func([<val> [, <val> ...]])
  *)

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okDomain);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'DOMAIN', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
    T1:=AddSQLTokens(stKeyword, T, 'AS', []);

  MakeTypeDefTree(Self, [T1, T], [], tdfDomain, 0);
end;

procedure TFBSQLCreateDomain.MakeSQL;
var
  S: String;
begin
  S:='CREATE DOMAIN ' + FullName + ' AS ' + DomainType;

  if TypeLen > 0 then
  begin
    S:=S+'('+IntToStr(TypeLen);
    if TypePrec > 0 then
      S:=S + ', ' + IntToStr(TypePrec);
    S:=S+')';
  end;

  if CharSetName <> '' then
    S:=S + ' CHARACTER SET ' + CharSetName;

  if DefaultValue<>'' then
    S:=S + ' DEFAULT '+DefaultValue;

  if NotNull then
    S:=S + ' NOT NULL';

  if CheckExpression <> '' then
    S:=S  + ' CHECK ('+CheckExpression+')';

  if CollationName<>'' then
    S:=S + ' COLLATE ' + CollationName;

  if ArrayMax > 0 then
  begin
    S:=S + ' [';
    if ArrayMin>0 then
      S:=S + IntToStr(ArrayMin)+':';
    S:=S + IntToStr(ArrayMax)+']';
  end;
  AddSQLCommand(S);

  if Description <> '' then
    DescribeObject;
end;

procedure TFBSQLCreateDomain.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:Name:=AWord;
    2:DomainType:=AWord;
    3:DomainType:='DOUBLE PRECISION';
    4:TypeLen:=StrToInt(AWord);
    5:TypePrec:=StrToInt(AWord);
    6:DomainType:='CHARACTER VARYING';
    7:CharSetName:=AWord;
    8:NotNull:=true;
    9:CheckExpression:=ASQLParser.GetToBracket(')');
    10:CollationName:=AWord;
    11:DomainType:='NATIONAL CHARACTER';
    12:DomainType:='NATIONAL CHAR';
    13:DefaultValue:=AWord;
    31:ArrayMax:=StrToInt(AWord);
    32:begin
         ArrayMin:=ArrayMax;
         ArrayMax:=StrToInt(AWord);
       end;
  end;
end;

constructor TFBSQLCreateDomain.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSQLCommentOnClass:=TFBSQLCommentOn;
  FArrayMin:=-1;
  FArrayMax:=-1;
end;

procedure TFBSQLCreateDomain.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLCreateDomain then
  begin
    ComputedSrc:=TFBSQLCreateDomain(ASource).ComputedSrc;
    ArrayMin:=TFBSQLCreateDomain(ASource).ArrayMin;
    ArrayMax:=TFBSQLCreateDomain(ASource).ArrayMax;
  end;
  inherited Assign(ASource);
end;

{ TFBSQLCreateTable }

procedure TFBSQLCreateTable.InitParserTree;
var
  FSQLTokens, T, T1, T2, TColName, TSymb, TSymbEnd, TConstrPK,
    TConstrPK1, TSymb2, TConstr, TConstr1, TSymb3, TConstrUNQ,
    TConstrUNQ1, TConstrCHK, TConstrCHK1, TConstrFK,
    TConstrFK1, TConstrFK2, TConstrFK3, TConstrFK4, TConstrFK5,
    TConstrFK6, TConstrFK7, TConstrFK8, TUseInd, TConstrFK1_1,
    TUseInd1, TUseInd2, TUseInd3, TUseInd4, TUseInd5, TUseInd6,
    TOnComm, TOnComm1, TOnComm2: TSQLTokenRecord;
begin
  (*
  RECREATE [GLOBAL TEMPORARY] TABLE tablename
  *)
  (*

  CREATE [GLOBAL TEMPORARY] TABLE tablename
  		[EXTERNAL [FILE] '<filespec>']
  	(<col_def> [, {<col_def> | <tconstraint>} ...])
  	[ON COMMIT {DELETE | PRESERVE} ROWS];

  <col_def> ::= <regular_col_def> | <computed_col_def>

  <regular_col_def> ::=
    colname {<datatype> | domainname}
    [DEFAULT {literal | NULL | <context_var>}]
    [NOT NULL]
    [<col_constraint>]
    [COLLATE collation_name]

  <computed_col_def> ::=
    colname [<datatype>]
    {COMPUTED [BY] | GENERATED ALWAYS AS} (<expression>)

  <datatype> ::=
      {SMALLINT | INTEGER | BIGINT} [<array_dim>]
    | {FLOAT | DOUBLE PRECISION} [<array_dim>]
    | {DATE | TIME | TIMESTAMP} [<array_dim>]
    | {DECIMAL | NUMERIC} [(precision [, scale])] [<array_dim>]
    | {CHAR | CHARACTER | CHARACTER VARYING | VARCHAR} [(size)]
      [<array_dim>] [CHARACTER SET charset_name]
    | {NCHAR | NATIONAL CHARACTER | NATIONAL CHAR} [VARYING]
      [(size)] [<array_dim>]
    | BLOB [SUB_TYPE {subtype_num | subtype_name}]
      [SEGMENT SIZE seglen] [CHARACTER SET charset_name]
    | BLOB [(seglen [, subtype_num])]

  <array_dim> ::= [[m:]n [, [m:]n ...]]

  <col_constraint> ::=
    [CONSTRAINT constr_name]
    {   PRIMARY KEY [<using_index>]
      | UNIQUE      [<using_index>]
      | REFERENCES other_table [(colname)] [<using_index>]
          [ON DELETE {NO ACTION | CASCADE | SET DEFAULT | SET NULL}]
          [ON UPDATE {NO ACTION | CASCADE | SET DEFAULT | SET NULL}]
      | CHECK (<check_condition>) }

  <tconstraint> ::=
    [CONSTRAINT constr_name]
    {   PRIMARY KEY (col_list) [<using_index>]
      | UNIQUE      (col_list) [<using_index>]
      | FOREIGN KEY (col_list)
          REFERENCES other_table [(col_list)]
          [ON DELETE {NO ACTION | CASCADE | SET DEFAULT | SET NULL}]
          [ON UPDATE {NO ACTION | CASCADE | SET DEFAULT | SET NULL}]
          [<using_index>]
      | CHECK (<check_condition>) }"

  <col_list> ::= colname [, colname ...]

  <using_index> ::= USING
    [ASC[ENDING] | DESC[ENDING]] INDEX indexname

  <check_condition> ::=
      <val> <operator> <val>
    | <val> [NOT] BETWEEN <val> AND <val>
    | <val> [NOT] IN (<val> [, <val> ...] | <select_list>)
    | <val> IS [NOT] NULL
    | <val> IS [NOT] DISTINCT FROM<val>
    | <val> [NOT] CONTAINING <val>
    | <val> [NOT] STARTING [WITH] <val>
    | <val> [NOT] LIKE <val> [ESCAPE <val>]
    | <val> [NOT] SIMILAR TO <val> [ESCAPE <val>]
    | <val> <operator> {ALL | SOME | ANY} (<select_list>)
    | [NOT] EXISTS (<select_expr>)
    | [NOT] SINGULAR (<select_expr>)
    | (<check_condition>)
    | NOT <check_condition>
    | <check_condition> OR <check_condition>
    | <check_condition> AND <check_condition>

  <operator> ::=
  <> | != | ^= | ~= | = | < | > | <= | >= | !< | ^< | ~< | !> | ^> | ~>

  <val> ::=
      colname [[<array_idx> [, <array_idx> ...]]]
    | literal
    | <context_var>
    | <expression>
    | NULL
    | NEXT VALUE FOR genname
    | GEN_ID(genname, <val>)
    | CAST(<val> AS <datatype>)
    | (<select_one>)
    | func([<val> [, <val> ...]])  *)

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okException);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'GLOBAL', []);
    T:=AddSQLTokens(stKeyword, T, 'TEMPORARY', [], 2);
  T:=AddSQLTokens(stKeyword, [FSQLTokens, T], 'TABLE', [toFindWordLast]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 1);
    T1:=AddSQLTokens(stKeyword, T, 'EXTERNAL', []);
    T2:=AddSQLTokens(stKeyword, T1, 'FILE', []);
    T1:=AddSQLTokens(stString, [T1, T2], '', [], 3);
  T:=AddSQLTokens(stSymbol, [T, T1], '(', []);
    TSymb:=AddSQLTokens(stSymbol, nil, ',', [], 4);
    TColName:=AddSQLTokens(stIdentificator, [T, TSymb], '', [], 10);
    TSymbEnd:=AddSQLTokens(stSymbol, nil, ')', []);

  MakeTypeDefTree(Self,  [TColName], [TSymb, TSymbEnd], tdfTableColDef, 100);

  //[CONSTRAINT constr_name]
  TConstr:=AddSQLTokens(stKeyword, TSymb, 'CONSTRAINT', []);
    TConstr1:=AddSQLTokens(stIdentificator, TConstr, '', [], 201);

  //PRIMARY KEY (col_list) [<using_index>]
  TConstrPK:=AddSQLTokens(stKeyword, [TSymb, TConstr1], 'PRIMARY', []);
    TConstrPK1:=AddSQLTokens(stKeyword, TConstrPK, 'KEY', []);
    TConstrPK1:=AddSQLTokens(stSymbol, TConstrPK1, '(', []);
    TConstrPK1:=AddSQLTokens(stIdentificator, TConstrPK1, '', [], 202);
    TSymb2:=AddSQLTokens(stSymbol, TConstrPK1, ',', []);
      TSymb2.AddChildToken(TConstrPK1);
    TConstrPK1:=AddSQLTokens(stSymbol, TConstrPK1, ')', []);

  //UNIQUE      (col_list) [<using_index>]
  TConstrUNQ:=AddSQLTokens(stKeyword, [TSymb, TConstr1], 'UNIQUE', []);
    TConstrUNQ1:=AddSQLTokens(stSymbol, TConstrUNQ, '(', []);
    TConstrUNQ1:=AddSQLTokens(stIdentificator, TConstrUNQ1, '', [], 203);
    TSymb2:=AddSQLTokens(stSymbol, TConstrUNQ1, ',', []);
    TSymb2.AddChildToken(TConstrUNQ1);
  TConstrUNQ1:=AddSQLTokens(stSymbol, TConstrUNQ1, ')', []);

  //CHECK (<check_condition>)
  TConstrCHK:=AddSQLTokens(stKeyword, [TSymb, TConstr1], 'CHECK', []);
    TConstrCHK1:=AddSQLTokens(stSymbol, TConstrCHK, '(', [], 204);


(*
  FOREIGN KEY (col_list)
    REFERENCES other_table [(col_list)]
    [ON DELETE {NO ACTION | CASCADE | SET DEFAULT | SET NULL}]
    [ON UPDATE {NO ACTION | CASCADE | SET DEFAULT | SET NULL}]
    [<using_index>]
*)
  TConstrFK:=AddSQLTokens(stKeyword, [TSymb, TConstr1], 'FOREIGN', []);
    TConstrFK1:=AddSQLTokens(stKeyword, TConstrFK, 'KEY', []);
    TConstrFK1:=AddSQLTokens(stSymbol, TConstrFK1, '(', []);
    TConstrFK1:=AddSQLTokens(stIdentificator, TConstrFK1, '', [], 205);
    TSymb2:=AddSQLTokens(stSymbol, TConstrFK1, ',', []);
    TSymb2.AddChildToken(TConstrFK1);
    TConstrFK1:=AddSQLTokens(stSymbol, TConstrFK1, ')', []);

    TConstrFK1:=AddSQLTokens(stKeyword, TConstrFK1, 'REFERENCES', []);
    TConstrFK1:=AddSQLTokens(stIdentificator, TConstrFK1, '', [], 206);
    TConstrFK1_1:=AddSQLTokens(stSymbol, TConstrFK1, '(', [toOptional]);
    TConstrFK1_1:=AddSQLTokens(stIdentificator, TConstrFK1_1, '', [], 207);
    TSymb2:=AddSQLTokens(stSymbol, TConstrFK1_1, ',', []);
    TSymb2.AddChildToken(TConstrFK1_1);
    TConstrFK1_1:=AddSQLTokens(stSymbol, TConstrFK1_1, ')', []);
      TConstrFK2:=AddSQLTokens(stKeyword, [TConstrFK1, TConstrFK1_1], 'ON', []);
      TConstrFK3:=AddSQLTokens(stKeyword, TConstrFK2, 'DELETE', [], 208);
      TConstrFK4:=AddSQLTokens(stKeyword, TConstrFK2, 'UPDATE', [], 209);
      TConstrFK5:=AddSQLTokens(stKeyword, [TConstrFK3, TConstrFK4], 'NO', []);
        TConstrFK5:=AddSQLTokens(stKeyword, TConstrFK5, 'ACTION', [], 210);
      TConstrFK6:=AddSQLTokens(stKeyword, [TConstrFK3, TConstrFK4], 'CASCADE', [], 211);
      TConstrFK7:=AddSQLTokens(stKeyword, [TConstrFK3, TConstrFK4], 'SET', []);
        TConstrFK8:=AddSQLTokens(stKeyword, TConstrFK7, 'NULL', [], 212);
        TConstrFK7:=AddSQLTokens(stKeyword, TConstrFK7, 'DEFAULT', [], 213);

  //<using_index> ::= USING [ASC[ENDING] | DESC[ENDING]] INDEX indexname
  TUseInd:=AddSQLTokens(stKeyword, [TConstrPK1, TConstrUNQ1, TConstrFK1, TConstrFK1_1], 'USING', []);
    TUseInd1:=AddSQLTokens(stKeyword, TUseInd, 'ASC', [], 233);
    TUseInd2:=AddSQLTokens(stKeyword, TUseInd, 'ASCENDING', [], 233);
    TUseInd3:=AddSQLTokens(stKeyword, TUseInd, 'DESC', [], 234);
    TUseInd4:=AddSQLTokens(stKeyword, TUseInd, 'DESCENDING', [], 234);
    TUseInd5:=AddSQLTokens(stKeyword, [TUseInd, TUseInd1, TUseInd2, TUseInd3, TUseInd4], 'INDEX', []);
    TUseInd6:=AddSQLTokens(stIdentificator, TUseInd5, '', [], 235);
      TUseInd6.AddChildToken([TSymbEnd]);


  TSymb3:=AddSQLTokens(stSymbol, [TConstrPK1, TConstrUNQ1, TConstrCHK1, TConstrFK1,
     TConstrFK5, TConstrFK6, TConstrFK7, TConstrFK8, TUseInd6], ',', [toOptional], 4);
  TSymb3.AddChildToken([TConstr, TConstrPK, TConstrUNQ, TConstrCHK, TConstrFK]);

  TConstrPK1.AddChildToken([TSymbEnd ]);
  TConstrCHK1.AddChildToken([TSymbEnd ]);
  TConstrUNQ1.AddChildToken([TSymbEnd ]);
  TConstrFK1.AddChildToken([TSymbEnd ]);
  TConstrFK5.AddChildToken([TSymbEnd, TConstrFK2 ]);
  TConstrFK6.AddChildToken([TSymbEnd, TConstrFK2 ]);
  TConstrFK7.AddChildToken([TSymbEnd, TConstrFK2 ]);
  TConstrFK8.AddChildToken([TSymbEnd, TConstrFK2 ]);

  TOnComm:=AddSQLTokens(stSymbol, TSymbEnd, 'ON', [toOptional]);
  TOnComm:=AddSQLTokens(stSymbol, TOnComm, 'COMMIT', []);
  TOnComm1:=AddSQLTokens(stSymbol, TOnComm, 'DELETE', [], 240);
  TOnComm2:=AddSQLTokens(stSymbol, TOnComm, 'PRESERVE', [], 241);
  TOnComm:=AddSQLTokens(stSymbol, [TOnComm1, TOnComm2], 'ROWS', []);
end;

procedure TFBSQLCreateTable.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:Name:=AWord;
    2:Options:=Options + [ooTemporary];
    3:FFileName:=AWord;
    4:begin
        FCurConst:=nil;
        FCurField:=nil;
        FCurFK:=0;
      end;
    10:begin
          FCurField:=Fields.AddParam(AWord);
          FCurConst:=nil;
          FCurFK:=0;
       end;
    102:if Assigned(FCurField) then FCurField.TypeName:=AWord;
    103:if Assigned(FCurField) then FCurField.TypeName:=FCurField.TypeName + ' ' + AWord;
    104:if Assigned(FCurField) then FCurField.TypeLen:=StrToInt(AWord);
    105:if Assigned(FCurField) then FCurField.TypePrec:=StrToInt(AWord);
    107:if Assigned(FCurField) then FCurField.CharSetName:=AWord;
    108:if Assigned(FCurField) then FCurField.Params:=FCurField.Params + [fpNotNull];
    109:begin
          if not Assigned(FCurConst) then
            FCurConst:=SQLConstraints.Find(ctTableCheck)
          else
            FCurConst.ConstraintType:=ctTableCheck;
          FCurConst.ConstraintExpression:=ASQLParser.GetToBracket(')');
        end;
    110:if Assigned(FCurField) then FCurField.Collate:=AWord;
    111,
    112:if Assigned(FCurField) then FCurField.TypeName:=FCurField.TypeName + ' SUB_TYPE ' + AWord;
    130:if Assigned(FCurField) then FCurField.TypeName:=FCurField.TypeName + ' SEGMENT SIZE ' + AWord;
    113:if Assigned(FCurField) then FCurField.DefaultValue:=AWord;
    114:if Assigned(FCurField) then FCurField.ComputedSource:=ASQLParser.GetToBracket(')');

    131:if Assigned(FCurField) then
        begin
          FCurField.ArrayDimension.Add(StrToInt(AWord));
//          if FCurField.TypeArrayDim <> '' then FCurField.TypeArrayDim:=FCurField.TypeArrayDim + ', ';
//          FCurField.TypeArrayDim:=FCurField.TypeArrayDim + AWord;
        end;
    132:if Assigned(FCurField) then
        begin
          if FCurField.ArrayDimension.Count>0 then
          begin
            FCurField.ArrayDimension[FCurField.ArrayDimension.Count-1].DimensionEnd:=StrToInt(AWord);
          end;
//          FCurField.ArrayDimension.Add(StrToInt(AWord));
//          FCurField.TypeArrayDim:=FCurField.TypeArrayDim + ':' + AWord;
        end;
    133,
    233:if Assigned(FCurConst) then FCurConst.IndexSortOrder:=indAscending;
    134,
    234:if Assigned(FCurConst) then FCurConst.IndexSortOrder:=indDescending;
    135,
    235:if Assigned(FCurConst) then FCurConst.IndexName:=AWord;
    36:if Assigned(FCurField) then
         FCurField.Params:=FCurField.Params + [fpAutoInc];
    37:if Assigned(FCurField) then
         FCurField.AutoIncInitValue:=StrToInt(AWord);
    115,
    201:FCurConst:=SQLConstraints.Add(ctNone, AWord);
    116:begin
          if not Assigned(FCurConst) then
            FCurConst:=SQLConstraints.Find(ctPrimaryKey)
          else
            FCurConst.ConstraintType:=ctPrimaryKey;
          if Assigned(FCurField) then
          begin
            FCurConst.ConstraintFields.AddParam(FCurField.Caption);
//            FCurField.PrimaryKey:=true;
          end;
        end;
    117:begin
          if Assigned(FCurConst) then
            FCurConst.ConstraintType:=ctForeignKey
          else
            FCurConst:=SQLConstraints.Add(ctForeignKey, '');
          FCurConst.ForeignTable:=AWord;
          if Assigned(FCurField) then
            FCurConst.ConstraintFields.AddParam(FCurField.Caption);
        end;
    118:if Assigned(FCurConst) and (FCurConst.ConstraintType = ctForeignKey) then FCurConst.ForeignFields.AddParam(AWord);
    119,
    209:FCurFK:=1; //'UPDATE', [], 19 + TagBase);
    120,
    208:FCurFK:=2; //'DELETE', [], 20 + TagBase);
    121,
    210:begin
          if Assigned(FCurConst) and (FCurConst.ConstraintType = ctForeignKey) then
            if FCurFK = 1 then
              FCurConst.ForeignKeyRuleOnUpdate:=fkrNone
            else
              FCurConst.ForeignKeyRuleOnDelete:=fkrNone;
        end;
    122,
    211:begin
          if Assigned(FCurConst) and (FCurConst.ConstraintType = ctForeignKey) then
            if FCurFK = 1 then
              FCurConst.ForeignKeyRuleOnUpdate:=fkrCascade
            else
              FCurConst.ForeignKeyRuleOnDelete:=fkrCascade;
        end;
    123,
    213:begin
          if Assigned(FCurConst) and (FCurConst.ConstraintType = ctForeignKey) then
            if FCurFK = 1 then
              FCurConst.ForeignKeyRuleOnUpdate:=fkrSetDefault
            else
              FCurConst.ForeignKeyRuleOnDelete:=fkrSetDefault;
        end;
    124,
    212:begin
          if Assigned(FCurConst) and (FCurConst.ConstraintType = ctForeignKey) then
            if FCurFK = 1 then
              FCurConst.ForeignKeyRuleOnUpdate:=fkrSetNull
            else
              FCurConst.ForeignKeyRuleOnDelete:=fkrSetNull;
        end;
    125:begin
          if Assigned(FCurConst) then
            FCurConst.ConstraintType:=ctUnique
          else
            FCurConst:=SQLConstraints.Add(ctUnique, '');
          if Assigned(FCurField) then
            FCurConst.ConstraintFields.AddParam(FCurField.Caption);
        end;
    202:begin
          if not Assigned(FCurConst) then
            FCurConst:=SQLConstraints.Add(ctPrimaryKey)
          else
            FCurConst.ConstraintType:=ctPrimaryKey;
          FCurConst.ConstraintFields.AddParam(AWord);
        end;
    203:begin
          if not Assigned(FCurConst) then
            FCurConst:=SQLConstraints.Add(ctUnique)
          else
            FCurConst.ConstraintType:=ctUnique;
          FCurConst.ConstraintFields.AddParam(AWord);
        end;
    204:begin
          if not Assigned(FCurConst) then
            FCurConst:=SQLConstraints.Add(ctTableCheck)
          else
            FCurConst.ConstraintType:=ctTableCheck;
          FCurConst.ConstraintExpression:=ASQLParser.GetToBracket(')');
        end;
    205:begin
          if not Assigned(FCurConst) then
            FCurConst:=SQLConstraints.Add(ctForeignKey)
          else
            FCurConst.ConstraintType:=ctForeignKey;
          FCurConst.ConstraintFields.AddParam(AWord);
        end;
    206:if Assigned(FCurConst) then
        FCurConst.ForeignTable:=AWord;
    207:if Assigned(FCurConst) then FCurConst.ForeignFields.AddParam(AWord);
    240:OnCommit:=oncDelete;
    241:OnCommit:=oncPreserve;
  end;
end;

procedure TFBSQLCreateTable.MakeSQL;
var
  S, S1, SPK, S_CONSTR: String;
  F: TSQLParserField;
  C: TSQLConstraintItem;
begin
  S:='CREATE';
  if FOnCommit <> oncNone then
    S:=S + ' GLOBAL TEMPORARY';
  S:=S + ' TABLE ' + FullName;
  if FFileName <> '' then
    S:=S + ' EXTERNAL FILE ' + QuotedStr(FFileName);

  S1:='';
  SPK:='';
  for F in Fields do
  begin
    if S1<>'' then
      S1:=S1 + ','+LineEnding;
    S1:=S1 + '  ' + DoFormatName(F.Caption) + ' ' + F.FullTypeName;
(*    if F.TypeArrayDim <> '' then
      S1:=S1 + '[' + F.TypeArrayDim + ']';*)
    if F.ArrayDimension.Count>0 then
    begin
      F.ArrayDimension.ArrayFormat:=fafFirebirdSQL;
      S1:=S1+F.ArrayDimension.AsString;
    end;
    if F.ComputedSource <> '' then
      S1:=S1 + ' COMPUTED BY (' + F.ComputedSource + ')'
    else
    begin
      if ServerVersion in [gds_verFirebird3_0] then
      begin
        if fpAutoInc in F.Params then
        begin
          S1:=S1 + ' GENERATED BY DEFAULT AS IDENTITY';
          if F.AutoIncInitValue <> 0 then
            S1:=S1 + ' (START WITH '+IntToStr(F.AutoIncInitValue)+')';
        end;
      end;
      if F.CharSetName <> '' then
        S1:=S1 + ' CHARACTER SET ' + F.CharSetName;

      if F.Collate <> '' then
        S1:=S1 + ' COLLATE ' + F.Collate;

      if F.DefaultValue <> '' then
        S1:=S1 + ' DEFAULT '+F.DefaultValue;

      if fpNotNull in F.Params then
        S1:=S1 + ' NOT NULL';
    end;

    if F.PrimaryKey then
    begin
      if SPK<>'' then SPK:=SPK + ',';
      SPK:=SPK + F.Caption;
    end;
  end;

  if S1 = '' then exit;


  S_CONSTR:='';
  for C in SQLConstraints do
  begin
    if S_CONSTR <> '' then
      S_CONSTR:=S_CONSTR + ',' + LineEnding;

    if ((SPK = '') or (C.ConstraintType<>ctPrimaryKey)) and (C.ConstraintName <> '') then
      S_CONSTR:=S_CONSTR + '  CONSTRAINT ' + C.ConstraintName;

    case C.ConstraintType of
      ctPrimaryKey:if SPK = '' then
        begin
          S_CONSTR:=S_CONSTR + '  PRIMARY KEY (' + C.ConstraintFields.AsString + ')';
          if C.IndexName <> '' then
            S_CONSTR:=S_CONSTR + '  USING ' + IndexSortOrderNames[C.IndexSortOrder]+ ' INDEX '+C.IndexName;
        end;
      ctForeignKey:
         begin
           S_CONSTR:=S_CONSTR + '  FOREIGN KEY ('+ C.ConstraintFields.AsString + ') REFERENCES ' + C.ForeignTable;
           if C.ForeignFields.Count > 0 then
             S_CONSTR:=S_CONSTR + ' (' + C.ForeignFields.AsString + ')';

           if C.ForeignKeyRuleOnUpdate<>fkrNone then S_CONSTR:=S_CONSTR+' ON UPDATE ' + ForeignKeyRuleNames[C.ForeignKeyRuleOnUpdate];
           if C.ForeignKeyRuleOnDelete<>fkrNone then S_CONSTR:=S_CONSTR+' ON DELETE ' + ForeignKeyRuleNames[C.ForeignKeyRuleOnDelete];

           if C.IndexName <> '' then
             S_CONSTR:=S_CONSTR + ' USING ' + IndexSortOrderNames[C.IndexSortOrder]+ ' INDEX '+C.IndexName;
         end;
      ctUnique:
         begin
           S_CONSTR:=S_CONSTR + '  UNIQUE ('+C.ConstraintFields.AsString + ')' ;
           if C.IndexName <> '' then
             S_CONSTR:=S_CONSTR + ' USING ' + IndexSortOrderNames[C.IndexSortOrder]+ ' INDEX '+C.IndexName;
         end;
      ctTableCheck:S_CONSTR:=S_CONSTR + '  CHECK ('+C.ConstraintExpression + ')';
    end;
  end;

  S:=S + '(' + LineEnding + S1;
  if SPK <> '' then
    S:=S +',' + LineEnding + '  PRIMARY KEY (' + SPK + ')';
  if S_CONSTR <> '' then
    S:=S +',' + LineEnding + S_CONSTR;

  S:=S + LineEnding + ')';

  if OnCommit = oncPreserve then
    S:=S + LineEnding + 'ON COMMIT PRESERVE ROWS'
  else
  if OnCommit = oncDelete then
    S:=S + LineEnding + 'ON COMMIT DELETE ROWS';

  AddSQLCommand(S);

  if Description <> '' then
    DescribeObject;

  for F in Fields do
    if F.Description <> '' then
      DescribeObjectEx(okColumn, F.Caption, Name, F.Description);
end;

constructor TFBSQLCreateTable.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSQLCommentOnClass:=TFBSQLCommentOn;
end;

procedure TFBSQLCreateTable.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLCreateTable then
  begin
    FileName:=TFBSQLCreateTable(ASource).FileName;
    OnCommit:=TFBSQLCreateTable(ASource).OnCommit;
    ServerVersion:=TFBSQLCreateTable(ASource).ServerVersion;
  end;
  inherited Assign(ASource);
end;

function TFBSQLCreateTable.GetAutoIncObject: TAutoIncObject;
begin
  Result:=TFBAutoIncObject.Create(Self);
end;

{ TFBSQLAlterTable }

procedure TFBSQLAlterTable.AddCollumn(OP: TAlterTableOperator);
var
  S, S_CONSTR: String;
  C: TSQLConstraintItem;
begin
  S:='';

  if OP.Field.CharSetName <> '' then
    S:=S + ' CHARACTER SET ' + OP.Field.CharSetName;

  if OP.Field.Collate <> '' then
    S:=S + ' COLLATE ' + OP.Field.Collate;

  if fpNotNull in OP.Field.Params then
    S:=S + ' NOT NULL';


  S_CONSTR:='';
  for C in OP.Constraints do
  begin
    if S_CONSTR <> '' then
      S_CONSTR:=S_CONSTR + ',' + LineEnding;

    if (C.ConstraintName <> '') then
      S_CONSTR:=S_CONSTR + ' CONSTRAINT ' + C.ConstraintName;

    case C.ConstraintType of
      ctPrimaryKey:
        begin
          S_CONSTR:=S_CONSTR + ' PRIMARY KEY (' + C.ConstraintFields.AsString + ')';
          if C.IndexName <> '' then
            S_CONSTR:=S_CONSTR + ' USING ' + IndexSortOrderNames[C.IndexSortOrder]+ ' INDEX '+C.IndexName;
        end;
      ctForeignKey:
         begin
           S_CONSTR:=S_CONSTR + ' REFERENCES ' + C.ForeignTable;
           if C.ForeignFields.Count > 0 then
             S_CONSTR:=S_CONSTR + ' (' + C.ForeignFields.AsString + ')';

           if C.ForeignKeyRuleOnUpdate<>fkrNone then S_CONSTR:=S_CONSTR+' ON UPDATE ' + ForeignKeyRuleNames[C.ForeignKeyRuleOnUpdate];
           if C.ForeignKeyRuleOnDelete<>fkrNone then S_CONSTR:=S_CONSTR+' ON DELETE ' + ForeignKeyRuleNames[C.ForeignKeyRuleOnDelete];

           if C.IndexName <> '' then
             S_CONSTR:=S_CONSTR + ' USING ' + IndexSortOrderNames[C.IndexSortOrder]+ ' INDEX '+C.IndexName;
         end;
      ctUnique:
         begin
           S_CONSTR:=S_CONSTR + ' UNIQUE ('+C.ConstraintFields.AsString + ')' ;
           if C.IndexName <> '' then
             S_CONSTR:=S_CONSTR + ' USING ' + IndexSortOrderNames[C.IndexSortOrder]+ ' INDEX '+C.IndexName;
         end;
      ctTableCheck:S_CONSTR:=S_CONSTR + ' CHECK ('+C.ConstraintExpression + ')';
    end;
  end;

  if S_CONSTR <> '' then S:=S + ' ' + S_CONSTR;

  AddSQLCommandEx('ALTER TABLE %s ADD %s %s', [Name, OP.Field.Caption, OP.Field.FullTypeName + S]);

  if OP.Field.DefaultValue <> '' then
    AddSQLCommandEx('ALTER TABLE %s ALTER COLUMN %s SET DEFAULT %s', [Name, OP.Field.Caption, OP.Field.DefaultValue]);

  if OP.InitialValue <> '' then
    AddSQLCommandEx('UPDATE %s SET %s = %s', [Name, OP.Field.Caption, OP.InitialValue]);

  if OP.Field.Description<>'' then
    DescribeObjectEx(okColumn, OP.Field.Caption, Name, OP.Field.Description);
end;

procedure TFBSQLAlterTable.InitParserTree;
var
  FSQLTokens, T, FTblName, TAlterOp, TAlterOpCol, FDefCol,
    FDefCol1, FDefCol2, FColName, FDefColDrop, FDefColPos,
    TDropOp, TDropOpConst, TAddOp, TAddOpConstr,
    TAddOpConstrPK, TAddOpField, TAddOpConstrFL_PK,
    TAddOpConstrFK, TAddOpConstrFK_U, TAddOpConstrFK_D,
    TConstRef6, TConstRef7, TConstRef8, TConstRef9,
    TAlterOpColRename, TDropField, TAlterOpColAlterType, T1: TSQLTokenRecord;
begin
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken], 0, okException);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'TABLE', [toFindWordLast]);
    FTblName:=AddSQLTokens(stIdentificator, T, '', [], 2);

  TAlterOp:=AddSQLTokens(stKeyword, FTblName, 'ALTER', []);
  TAlterOpCol:=AddSQLTokens(stKeyword, TAlterOp, 'COLUMN', []);
    FColName:=AddSQLTokens(stIdentificator, [TAlterOpCol, TAlterOp], '', [], 3);

    T:=AddSQLTokens(stKeyword, FColName, 'SET', []);             //SET DEFAULT
    FDefCol:=AddSQLTokens(stKeyword, T, 'DEFAULT', []);
      FDefCol1:=AddSQLTokens(stKeyword, FDefCol, 'null', [], 4);
      FDefCol2:=AddSQLTokens(stString, FDefCol, '', [], 4);

    FDefColDrop:=AddSQLTokens(stKeyword, FColName, 'DROP', []);  //DROP
      FDefColDrop:=AddSQLTokens(stKeyword, FDefColDrop, 'DEFAULT', [], 6);

    FDefColPos:=AddSQLTokens(stKeyword, FColName, 'POSITION', []);
      FDefColPos:=AddSQLTokens(stInteger, FDefColPos, '', [], 7);

    TAlterOpColRename:=AddSQLTokens(stKeyword, FColName, 'TO', []); //RENAME TO
      TAlterOpColRename:=AddSQLTokens(stIdentificator, TAlterOpColRename, '', [], 22);

    TAlterOpColAlterType:=AddSQLTokens(stKeyword, FColName, 'TYPE', [], 24); //TYPE TYPE_USER_DATE
      {TAlterOpColAlterType1:=}AddSQLTokens(stIdentificator, TAlterOpColAlterType, '', [], 25);

  TDropOp:=AddSQLTokens(stKeyword, FTblName, 'DROP', []);
    TDropField:=AddSQLTokens(stIdentificator, TDropOp, '', [], 23);
    TDropOpConst:=AddSQLTokens(stKeyword, TDropOp, 'CONSTRAINT', []);
    TDropOpConst:=AddSQLTokens(stIdentificator, TDropOpConst, '', [], 8);

  TAddOp:=AddSQLTokens(stKeyword, FTblName, 'ADD', []);
    TAddOpField:=AddSQLTokens(stIdentificator, TAddOp, '', [], 12);

  TAddOpConstr:=AddSQLTokens(stKeyword, TAddOp, 'CONSTRAINT', []);
    TAddOpConstr:=AddSQLTokens(stIdentificator, TAddOpConstr, '', [], 9);
    TAddOpConstrPK:=AddSQLTokens(stKeyword, [TAddOp, TAddOpConstr], 'PRIMARY', [], 10);
    TAddOpConstrPK:=AddSQLTokens(stKeyword, TAddOpConstrPK, 'KEY', []);

    T:=AddSQLTokens(stSymbol, TAddOpConstrPK, '(', []);
    T:=AddSQLTokens(stIdentificator, T, '', [], 11);
    T1:=AddSQLTokens(stSymbol, T, ',', []);
      T1.AddChildToken(T);
    TAddOpConstrFL_PK:=AddSQLTokens(stSymbol, T, ')', []);

    TAddOpConstrFK:=AddSQLTokens(stKeyword, [TAddOp, TAddOpConstr], 'FOREIGN', [], 13);
    TAddOpConstrFK:=AddSQLTokens(stKeyword, TAddOpConstrFK, 'KEY', []);
      T:=AddSQLTokens(stSymbol, TAddOpConstrFK, '(', []);
      T:=AddSQLTokens(stIdentificator, T, '', [], 11);
      T1:=AddSQLTokens(stSymbol, T, ',', []);
      TAddOpConstrFK:=AddSQLTokens(stSymbol, T, ')', []);
    TAddOpConstrFK:=AddSQLTokens(stKeyword, TAddOpConstrFK, 'REFERENCES', []);
    TAddOpConstrFK:=AddSQLTokens(stIdentificator, TAddOpConstrFK, '', [], 14);
      T:=AddSQLTokens(stSymbol, TAddOpConstrFK, '(', []);
      T:=AddSQLTokens(stIdentificator, T, '', [], 15);
      T1:=AddSQLTokens(stSymbol, T, ',', []);
    TAddOpConstrFK:=AddSQLTokens(stSymbol, T, ')', []);
    TAddOpConstrFK:=AddSQLTokens(stKeyword, TAddOpConstrFK, 'ON', [toOptional]);
      TAddOpConstrFK_U:=AddSQLTokens(stKeyword, TAddOpConstrFK, 'DELETE', [], 16);
      TAddOpConstrFK_D:=AddSQLTokens(stKeyword, TAddOpConstrFK, 'UPDATE', [], 17);

      TConstRef6:=AddSQLTokens(stKeyword, [TAddOpConstrFK_U, TAddOpConstrFK_D], 'NO', []);
      TConstRef6:=AddSQLTokens(stKeyword, TConstRef6, 'ACTION', [], 18);
      TConstRef7:=AddSQLTokens(stKeyword, [TAddOpConstrFK_U, TAddOpConstrFK_D], 'CASCADE', [], 19);
      TConstRef8:=AddSQLTokens(stKeyword, [TAddOpConstrFK_U, TAddOpConstrFK_D], 'SET', []);
        TConstRef9:=AddSQLTokens(stKeyword, TConstRef8, 'NULL', [], 20);
        TConstRef8:=AddSQLTokens(stKeyword, TConstRef8, 'DEFAULT', [], 21);
      TConstRef6.AddChildToken(TAddOpConstrFK);
      TConstRef7.AddChildToken(TAddOpConstrFK);
      TConstRef9.AddChildToken(TAddOpConstrFK);
      TConstRef8.AddChildToken(TAddOpConstrFK);



//     [<using_index>]
//ALTER TABLE DEL_TB_ATICLES_COST ADD delete_user_name TYPE_USER_NAME;
//ALTER TABLE DEL_TB_ATICLES_COST ADD CONSTRAINT fk_DEL_TB_ATICLES_COST_1 FOREIGN KEY (TB_DOC_ID) REFERENCES DEL_TB_DOC(TB_DOC_ID) ON UPDATE CASCADE ON DELETE CASCADE;
(*
    <tconstraint> ::=
      [CONSTRAINT constr_name]
      {   PRIMARY KEY (col_list) [<using_index>]
        | UNIQUE      (col_list) [<using_index>]
        | FOREIGN KEY (col_list)
            REFERENCES other_table [(col_list)] [<using_index>]
            [ON DELETE {NO ACTION | CASCADE | SET DEFAULT | SET NULL}]
            [ON UPDATE {NO ACTION | CASCADE | SET DEFAULT | SET NULL}]
        | CHECK (<check_condition>) }
*)
  T:=AddSQLTokens(stSymbol, [FDefCol1, FDefCol2, FDefColDrop, FDefColPos, TDropOpConst, TAddOpConstrFL_PK,
     TConstRef6, TConstRef7, TConstRef9, TConstRef8, TAlterOpColRename, TDropField], ',', [toOptional], 5);
    T.AddChildToken([TAlterOp, TDropOp, TAddOp]);

    MakeTypeDefTree(Self,  [TAddOpField], [T], tdfTableColDef, 100);
    MakeTypeDefTree(Self,  [TAlterOpColAlterType], [T], tdfTypeOnly, 100);


//    ALTER TABLE DEL_TB_DOC ADD CONSTRAINT PK_DEL_TB_DOC PRIMARY KEY (TB_DOC_ID);
//ALTER COLUMN SPR_FILIAL_NAME SET DEFAULT null;
//ALTER TABLE SPR_FILIAL ALTER COLUMN SPR_FILIAL_NAME DROP DEFAULT;
//alter table DEL_TB_DOC alter column TB_DOC_ID position 1;
//ALTER TABLE DEL_TB_PROV DROP CONSTRAINT FK_DEL_TB_PROV;
  (*

  ALTER TABLE tablename
  <operation> [, <operation> ...]

  <operation> ::= ADD <col_def>
                        ADD <tconstraint>
                        DROP colname
                        DROP CONSTRAINT constr_name
                        ALTER [COLUMN] colname <col_mod>

  <col_def> ::= <regular_col_def> | <computed_col_def>

  <regular_col_def> ::=
    colname {<datatype> | domainname}
    [DEFAULT {literal | NULL | <context_var>}]
    [NOT NULL]
    [<col_constraint>]
    [COLLATE collation_name]

  <computed_col_def> ::=
    colname [<datatype>]
    {COMPUTED [BY] | GENERATED ALWAYS AS} (<expression>)

  <col_mod> ::= <regular_col_mod> | <computed_col_mod>

  <regular_col_mod> ::=
      TO newname
    | POSITION newpos
    | TYPE {<datatype> | domainname}
    | SET DEFAULT {literal | NULL | <context_var>}
    | DROP DEFAULT

  <computed_col_mod> ::=
      TO newname
    | POSITION newpos
    | [TYPE <datatype>] {COMPUTED [BY] | GENERATED ALWAYS AS} (<expression>)

  <datatype> ::=
      {SMALLINT | INTEGER | BIGINT} [<array_dim>]
    | {FLOAT | DOUBLE PRECISION} [<array_dim>]
    | {DATE | TIME | TIMESTAMP} [<array_dim>]
    | {DECIMAL | NUMERIC} [(precision [, scale])] [<array_dim>]
    | {CHAR | CHARACTER | CHARACTER VARYING | VARCHAR} [(size)]
      [<array_dim>] [CHARACTER SET charset_name]
    | {NCHAR | NATIONAL CHARACTER | NATIONAL CHAR} [VARYING]
      [(size)] [<array_dim>]
    | BLOB [SUB_TYPE {subtype_num | subtype_name}]
      [SEGMENT SIZE seglen] [CHARACTER SET charset_name]
    | BLOB [(seglen [, subtype_num])]

  <array_dim> ::= [[m]:n [,[m]:n ...]]

  <col_constraint> ::=
    [CONSTRAINT constr_name]
    {   PRIMARY KEY [<using_index>]
      | UNIQUE      [<using_index>]
      | REFERENCES other_table [(colname)] [<using_index>]
          [ON DELETE {NO ACTION | CASCADE | SET DEFAULT | SET NULL}]
          [ON UPDATE {NO ACTION | CASCADE | SET DEFAULT | SET NULL}]
      | CHECK (<check_condition>) }

  <tconstraint> ::=
    [CONSTRAINT constr_name]
    {   PRIMARY KEY (col_list) [<using_index>]
      | UNIQUE      (col_list) [<using_index>]
      | FOREIGN KEY (col_list)
          REFERENCES other_table [(col_list)] [<using_index>]
          [ON DELETE {NO ACTION | CASCADE | SET DEFAULT | SET NULL}]
          [ON UPDATE {NO ACTION | CASCADE | SET DEFAULT | SET NULL}]
      | CHECK (<check_condition>) }

  <col_list> ::= colname [, colname ...]

  <using_index> ::= USING
  [ASC[ENDING] | DESC[ENDING]] INDEX indexname

  <check_condition> ::=
      <val> <operator> <val>
    | <val> [NOT] BETWEEN <val> AND <val>
    | <val> [NOT] IN (<val> [, <val> ...] | <select_list>)
    | <val> IS [NOT] NULL
    | <val> IS [NOT] DISTINCT FROM <val>
    | <val> [NOT] CONTAINING <val>
    | <val> [NOT] STARTING [WITH] <val>
    | <val> [NOT] LIKE <val> [ESCAPE <val>]
    | <val> [NOT] SIMILAR TO <val> [ESCAPE <val>]
    | <val> <operator> {ALL | SOME | ANY} (<select_list>)
    | [NOT] EXISTS (<select_expr>)
    | [NOT] SINGULAR (<select_expr>)
    | (<search_condition>)
    | NOT <search_condition>
    | <search_condition> OR <search_condition>
    | <search_condition> AND <search_condition>

  <operator> ::=
    <> | != | ^= | ~= | = | < | > | <= | >= | !< | ^< | ~< | !> | ^> | ~>

  <val> ::=
      colname [[<array_idx> [, <array_idx> ...]]]
    | literal
    | <context_var>
    | <expression>
    | NULL
    | NEXT VALUE FOR genname
    | GEN_ID(genname, <val>)
    | CAST(<val> AS <datatype>)
    | (<select_one>)
    | func([<val> [, <val> ...]])
  *)
end;

procedure TFBSQLAlterTable.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    2:Name:=AWord;
    3:begin
        FCurOperator:=Operators.AddItem(ataAlterCol);
        FCurOperator.Field.Caption:=AWord;
      end;
    4:if Assigned(FCurOperator) then
      begin
        FCurOperator.AlterAction:=ataAlterColumnSetDefaultExp;
        FCurOperator.Field.DefaultValue:=AWord;
      end;
    5:begin
        FCurOperator:=nil;
        FCurConstr:=nil;
      end;
    6:if Assigned(FCurOperator) then FCurOperator.AlterAction:=ataAlterColumnDropDefault;
    7:if Assigned(FCurOperator) then
      begin
        FCurOperator.AlterAction:=ataAlterColumnPosition;
        FCurOperator.Position:=StrToInt(AWord);
      end;
    8:begin
        FCurOperator:=Operators.AddItem(ataDropConstraint);
        FCurOperator.Constraints.Add(ctNone, AWord);
      end;
    9:begin
        FCurOperator:=Operators.AddItem(ataAddTableConstraint);
        FCurConstr:=FCurOperator.Constraints.Add(ctNone, AWord);
        FCurOperator.AlterAction:=ataAddTableConstraint;
      end;
    10:
      begin
        if not Assigned(FCurOperator) then
          FCurOperator:=Operators.AddItem(ataAddTableConstraint);

        if Assigned(FCurConstr) then
          FCurConstr.ConstraintType:=ctPrimaryKey
        else
          FCurConstr:=FCurOperator.Constraints.Add(ctPrimaryKey);
        FCurOperator.AlterAction:=ataAddTableConstraint;
      end;
    11:if Assigned(FCurOperator) and Assigned(FCurConstr) then
      FCurConstr.ConstraintFields.AddParam(AWord);
    12:begin
         FCurOperator:=Operators.AddItem(ataAddColumn);
         FCurOperator.Field.Caption:=AWord;
       end;
    13:begin
        if not Assigned(FCurConstr) then
        begin
          if not Assigned(FCurOperator) then
            FCurOperator:=Operators.AddItem(ataAddTableConstraint)
          else
            FCurOperator.AlterAction:=ataAddTableConstraint;
         FCurConstr:=FCurOperator.Constraints.Add(ctForeignKey);
        end
        else
          FCurConstr.ConstraintType:=ctForeignKey;
      end;
    14:if Assigned(FCurConstr) then FCurConstr.ForeignTable:=AWord;
    15:if Assigned(FCurConstr) then FCurConstr.ForeignFields.AddParam(AWord);
    16:FCurFK:=2; //'DELETE
    17:FCurFK:=1; //'UPDATE

    18:begin
          if Assigned(FCurConstr) and (FCurConstr.ConstraintType = ctForeignKey) then
            if FCurFK = 1 then
              FCurConstr.ForeignKeyRuleOnUpdate:=fkrNone
            else
              FCurConstr.ForeignKeyRuleOnDelete:=fkrNone;
        end;
    19:begin
          if Assigned(FCurConstr) and (FCurConstr.ConstraintType = ctForeignKey) then
            if FCurFK = 1 then
              FCurConstr.ForeignKeyRuleOnUpdate:=fkrCascade
            else
              FCurConstr.ForeignKeyRuleOnDelete:=fkrCascade;
        end;
    20:begin
          if Assigned(FCurConstr) and (FCurConstr.ConstraintType = ctForeignKey) then
            if FCurFK = 1 then
              FCurConstr.ForeignKeyRuleOnUpdate:=fkrSetNull
            else
              FCurConstr.ForeignKeyRuleOnDelete:=fkrSetNull;
        end;
    21:begin
          if Assigned(FCurConstr) and (FCurConstr.ConstraintType = ctForeignKey) then
            if FCurFK = 1 then
              FCurConstr.ForeignKeyRuleOnUpdate:=fkrSetDefault
            else
              FCurConstr.ForeignKeyRuleOnDelete:=fkrSetDefault;
        end;
    22:if Assigned(FCurOperator) then
      begin
        FCurOperator.AlterAction:=ataRenameColumn;
        FCurOperator.OldField.Caption:=FCurOperator.Field.Caption;
        FCurOperator.Field.Caption:=AWord;
      end;
    23:
      begin
        FCurOperator:=Operators.AddItem(ataDropColumn);
        FCurOperator.Field.Caption:=AWord;
      end;
    24:if Assigned(FCurOperator) then
        FCurOperator.AlterAction:=ataAlterColumnSetDataType;
    25:if Assigned(FCurOperator) then
        FCurOperator.Field.TypeName:=AWord;
    102:if Assigned(FCurOperator) then FCurOperator.Field.TypeName:=AWord;
    103:if Assigned(FCurOperator) then FCurOperator.Field.TypeName:=FCurOperator.Field.TypeName + ' ' + AWord;
    104:if Assigned(FCurOperator) then FCurOperator.Field.TypeLen:=StrToInt(AWord);
    105:if Assigned(FCurOperator) then FCurOperator.Field.TypePrec:=StrToInt(AWord);
    107:if Assigned(FCurOperator) then FCurOperator.Field.CharSetName:=AWord;
    108:if Assigned(FCurOperator) then FCurOperator.Field.Params:=FCurOperator.Field.Params + [fpNotNull];
    110:if Assigned(FCurOperator) then FCurOperator.Field.Collate:=AWord;
    111,
    112:if Assigned(FCurOperator) then FCurOperator.Field.TypeName:=FCurOperator.Field.TypeName + ' SUB_TYPE ' + AWord;
    130:if Assigned(FCurOperator) then FCurOperator.Field.TypeName:=FCurOperator.Field.TypeName + ' SEGMENT SIZE ' + AWord;
    113:if Assigned(FCurOperator) then FCurOperator.Field.DefaultValue:=AWord;
    114:if Assigned(FCurOperator) then FCurOperator.Field.ComputedSource:=ASQLParser.GetToBracket(')');
    131:if Assigned(FCurOperator) then
        begin
          FCurOperator.Field.ArrayDimension.Add(StrToInt(AWord));
//          if FCurOperator.Field.TypeArrayDim <> '' then FCurOperator.Field.TypeArrayDim:=FCurOperator.Field.TypeArrayDim + ', ';
//          FCurOperator.Field.TypeArrayDim:=FCurOperator.Field.TypeArrayDim + AWord;
        end;
    132:if Assigned(FCurOperator) then
          if FCurOperator.Field.ArrayDimension.Count>0 then
            FCurOperator.Field.ArrayDimension[FCurOperator.Field.ArrayDimension.Count-1].DimensionEnd:=StrToInt(AWord);
//          FCurOperator.Field.TypeArrayDim:=FCurOperator.Field.TypeArrayDim + ':' + AWord;
  end;
end;

constructor TFBSQLAlterTable.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSQLCommentOnClass:=TFBSQLCommentOn;
  FServerVersion:=gds_verFirebird1_0;
end;

procedure TFBSQLAlterTable.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLAlterTable then
  begin
    ServerVersion:=TFBSQLAlterTable(ASource).ServerVersion;

  end;
  inherited Assign(ASource);
end;

procedure TFBSQLAlterTable.MakeSQL;


procedure DoAddConstrint(OP: TAlterTableOperator);
var
  S: String;
  C: TSQLConstraintItem;
begin
  for C in OP.Constraints do
  begin
    S:='';
    if C.ConstraintType = ctPrimaryKey then
      S:=Format('ALTER TABLE %s ADD CONSTRAINT %s PRIMARY KEY(%s)', [FullName, DoFormatName(C.ConstraintName), C.ConstraintFields.AsString])
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
      S:=Format('ALTER TABLE %s ADD CONSTRAINT %s FOREIGN KEY (%s) REFERENCES %s(%s)%s', [FullName, DoFormatName(C.ConstraintName),
                                                                                                    C.ConstraintFields.AsString,
                                                                                                    DoFormatName(C.ForeignTable),
                                                                                                    C.ForeignFields.AsString,
                                                                                                    S
                                                                                                    ]);
    end
    else
    if C.ConstraintType = ctUnique then
      S:=Format('ALTER TABLE %s ADD CONSTRAINT %s UNIQUE(%s)', [FullName, DoFormatName(C.ConstraintName), C.ConstraintFields.AsString])
    else
    if C.ConstraintType = ctTableCheck then
      S:=Format('ALTER TABLE %s ADD CONSTRAINT %s CHECK (%s)', [FullName, DoFormatName(C.ConstraintName), C.ConstraintExpression]);
    if S<>'' then
      AddSQLCommand(S);
  end;

end;

procedure DoChangeType(OP: TAlterTableOperator);
begin
  if ServerVersion = gds_verFirebird3_0 then
    AddSQLCommandEx('ALTER TABLE %s ALTER COLUMN %s TYPE %s', [FullName, DoFormatName(OP.Field.Caption), OP.Field.FullTypeName])
  else
    AddSQLCommandEx('update RDB$RELATION_FIELDS set RDB$FIELD_SOURCE = ''%s'' where (RDB$FIELD_NAME = ''%s'') and (RDB$RELATION_NAME = ''%s'')',
     [OP.Field.TypeName, OP.Field.Caption, Name]);
end;

var
  OP: TAlterTableOperator;
  C: TSQLConstraintItem;
  S: String;
begin
  for OP in FOperators do
  begin
    case OP.AlterAction of
      ataAddColumn : AddCollumn(OP);
      ataRenameColumn :AddSQLCommandEx('ALTER TABLE %s ALTER %s TO %s', [FullName, DoFormatName(OP.OldField.Caption), DoFormatName(OP.Field.Caption)]);

      ataAlterColumnSetDataType : DoChangeType(OP);

      ataAlterColumnDropDefault : AddSQLCommandEx('ALTER TABLE %s ALTER COLUMN %s DROP DEFAULT', [FullName, DoFormatName(OP.Field.Caption)]);
      ataAlterColumnSetDefaultExp : AddSQLCommandEx('ALTER TABLE %s ALTER COLUMN %s SET DEFAULT %s', [FullName, DoFormatName(OP.Field.Caption), OP.Field.DefaultValue]);
      ataDropColumn:AddSQLCommandEx('ALTER TABLE %s DROP %s', [FullName, DoFormatName(OP.Field.Caption)]);
      ataAlterColumnSetNotNull,
      ataAlterColumnDropNotNull:
        begin
          if ServerVersion in [gds_verFirebird3_0] then
          begin
            if fpNotNull in OP.Field.Params then
              S:='SET'
            else
              S:='DROP';
            AddSQLCommandEx('ALTER TABLE %s ALTER COLUMN %s %s NOT NULL', [FullName, DoFormatName(OP.Field.Caption), S]);
            (*
            SET NOT NULL  |  DROP NOT NULL
            *)
          end
          else
            AddSQLCommandEx('update RDB$RELATION_FIELDS set RDB$NULL_FLAG = %d ' + ' where (RDB$FIELD_NAME = ''%s'') and (RDB$RELATION_NAME = ''%s'')',
            [Ord(fpNotNull in OP.Field.Params), DoFormatName(OP.Field.Caption), FullName]);

        end;

      ataAlterColumnDescription : DescribeObjectEx(okColumn, OP.Field.Caption, Name, OP.Field.Description);
      ataAddTableConstraint:DoAddConstrint(OP);
      ataDropConstraint:for C in OP.Constraints do
                          AddSQLCommandEx('ALTER TABLE %s DROP CONSTRAINT %s', [FullName, DoFormatName(C.ConstraintName)]);
      ataAlterColumnPosition : AddSQLCommandEx('ALTER TABLE %s ALTER COLUMN %s POSITION %d', [FullName, DoFormatName(OP.Field.Caption), OP.Position]);
    else
      raise Exception.CreateFmt('Unknow operator "%s"', [AlterTableActionStr[OP.AlterAction]]);
    end;
  end;
end;

{ TFBSQLDropException }

procedure TFBSQLDropException.InitParserTree;
var
  FSQLTokens, T: TSQLTokenRecord;
begin
  //DROP EXCEPTION exception_name
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okException);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'EXCEPTION', [toFindWordLast]);
    T:=AddSQLTokens(stIdentificator, T, '', [], 2);
end;

procedure TFBSQLDropException.MakeSQL;
begin
  AddSQLCommandEx('DROP EXCEPTION %s', [FullName]);
end;

procedure TFBSQLDropException.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  if AChild.Tag = 2 then
    Name:=AWord;
end;

constructor TFBSQLDropException.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okException;
end;

{ TFBSQLAlterException }

procedure TFBSQLAlterException.InitParserTree;
var
  FSQLTokens, T: TSQLTokenRecord;
begin
  //ALTER EXCEPTION exception_name 'message'
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken], 0, okException);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'EXCEPTION', [toFindWordLast]);
    T:=AddSQLTokens(stIdentificator, T, '', [], 2);
    T:=AddSQLTokens(stString, T, '', [], 3);
end;

procedure TFBSQLAlterException.MakeSQL;
begin
  AddSQLCommandEx('ALTER EXCEPTION %s %s', [FullName, QuotedStr(FMessage)]);

  if FOldDescription <> Description then
    AddSQLCommandEx('COMMENT ON EXCEPTION %s IS %s', [FullName, QuotedStr(Description)]);
end;

procedure TFBSQLAlterException.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLAlterException then
  begin
    OldDescription:=TFBSQLAlterException(ASource).OldDescription;
  end;
  inherited Assign(ASource);
end;

{ TFBSQLCreateException }

procedure TFBSQLCreateException.InitParserTree;
var
  FSQLTokens, T1, T: TSQLTokenRecord;
begin
  //CREATE EXCEPTION exception_name 'message'
  //CREATE OR ALTER EXCEPTION exception_name 'message'

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okException);
      T1:=AddSQLTokens(stKeyword, FSQLTokens, 'OR', []);
      T1:=AddSQLTokens(stKeyword, T1, 'ALTER', [], -2);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'EXCEPTION', [toFindWordLast]);
      T1.AddChildToken(T);
    T:=AddSQLTokens(stIdentificator, T, '', [], 2);
    T:=AddSQLTokens(stString, T, '', [], 3);

  //RECREATE EXCEPTION exception_name 'message'
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'RECREATE', [toFirstToken], 0, okException);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'EXCEPTION', [toFindWordLast]);
    T:=AddSQLTokens(stIdentificator, T, '', [], 2);
    T:=AddSQLTokens(stString, T, '', [], 3);
end;

procedure TFBSQLCreateException.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    //1:CreateMode:=cmCreateOrAlter;
    2:Name:=AWord;
    3:FMessage:=AnsiDequotedStr(AWord, '''');
    4:CreateMode:=cmRecreate;
  end;
end;

procedure TFBSQLCreateException.MakeSQL;
var
  S: String;
begin
  case CreateMode of
    cmCreate:
       begin
         S:='CREATE';
         if ooOrReplase in Options then S:=S+ ' OR ALTER';
        end;
    cmRecreate:S:='RECREATE';
  end;

  AddSQLCommandEx('%s EXCEPTION %s %s', [S, FullName, QuotedStr(FMessage)]);

  if Description <> '' then
    DescribeObject;
end;

constructor TFBSQLCreateException.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  ObjectKind:=okException;
  FSQLCommentOnClass:=TFBSQLCommentOn;
end;

procedure TFBSQLCreateException.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLCreateException then
  begin
    Message:=TFBSQLCreateException(ASource).Message;
  end;
  inherited Assign(ASource);
end;

{ TFBSQLDropGenerator }

procedure TFBSQLDropGenerator.InitParserTree;
var
  FSQLTokens, T1, T2, T: TSQLTokenRecord;
begin
  //DROP SEQUENCE GNID_SYS_CLIENT
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okSequence);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'SEQUENCE', [toFindWordLast]);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'GENERATOR', [toFindWordLast], 1);
  T:=AddSQLTokens(stIdentificator, T1, '', [], 2);
    T2.AddChildToken(T);
end;

procedure TFBSQLDropGenerator.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:FOldStyle:=true;
    2:Name:=AWord;
  end;
end;

procedure TFBSQLDropGenerator.MakeSQL;
var
  S: String;
begin
  if FOldStyle then
    S:='GENERATOR'
  else
    S:='SEQUENCE';

  AddSQLCommandEx('DROP %s %s', [S, FullName]);
end;

procedure TFBSQLDropGenerator.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLDropGenerator then
  begin
    OldStyle:=TFBSQLDropGenerator(ASource).OldStyle;

  end;
  inherited Assign(ASource);
end;

{ TFBSQLAlterGenerator }

procedure TFBSQLAlterGenerator.InitParserTree;
var
  FSQLTokens, T1, T2, T, T3, T4, T5, T5_1, T6, T7: TSQLTokenRecord;
begin
  //ALTER SEQUENCE GNID_SYS_CLIENT RESTART WITH 4139521
  //ALTER SEQUENCE EMP_NO_GEN RESTART WITH 145;
  //ALTER {SEQUENCE | GENERATOR} seq_name

  //[RESTART [WITH new_val ]]
  //[INCREMENT [BY] increment ];


  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken], 0, okSequence);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'SEQUENCE', [toFindWordLast]);
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 1);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'GENERATOR', [toFindWordLast]);
    T2:=AddSQLTokens(stIdentificator, T2, '', [], 2);

  T3:=AddSQLTokens(stKeyword, [T1, T2], 'RESTART', [], 3);
    T4:=AddSQLTokens(stKeyword, T3, 'WITH', [toOptional]);
    T4:=AddSQLTokens(stInteger, T4, '', [], 4);

  T5:=AddSQLTokens(stKeyword, [T1, T2, T3, T4], 'INCREMENT', [toOptional], 5);
    T:=AddSQLTokens(stKeyword, T5, 'BY', [], 6);
    T5_1:=AddSQLTokens(stInteger, [T5,T], '', [], 7);

  //RECREATE {SEQUENCE | GENERATOR} seq_name
  //[START WITH value ] [INCREMENT [BY] increment ];
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'RECREATE', [toFirstToken], 0, okSequence);
    T6:=AddSQLTokens(stKeyword, FSQLTokens, 'SEQUENCE', [toFindWordLast]);
    T6:=AddSQLTokens(stIdentificator, T6, '', [], 9);
    T7:=AddSQLTokens(stKeyword, FSQLTokens, 'GENERATOR', [toFindWordLast]);
    T7:=AddSQLTokens(stIdentificator, T7, '', [], 10);

  T3:=AddSQLTokens(stKeyword, [T6, T7], 'START', []);
    T4:=AddSQLTokens(stKeyword, T3, 'WITH', [toOptional]);
    T4:=AddSQLTokens(stInteger, T4, '', [], 4);

  T5:=AddSQLTokens(stKeyword, [T6, T7, T3, T4], 'INCREMENT', [toOptional], 5);
    T:=AddSQLTokens(stKeyword, T5, 'BY', [], 6);
    T5_1:=AddSQLTokens(stInteger, [T5,T], '', [], 7);

  //SET GENERATOR EMP_NO_GEN TO 145;
  //SET GENERATOR seq_name TO new_val ;
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'SET', [toFirstToken], 0, okSequence);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'GENERATOR', [toFindWordLast]);
  FSQLTokens:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 8);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'TO', []);
  FSQLTokens:=AddSQLTokens(stInteger, FSQLTokens, '', [], 4);
end;

procedure TFBSQLAlterGenerator.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:begin
        Command:=fbagAlter;
        SequenceStyle:=fbssSequence;
        Name:=AWord;
      end;
    2:begin
        Command:=fbagAlter;
        SequenceStyle:=fbssGenerator;
        Name:=AWord;
      end;
    3:CommandParams:=CommandParams + [fbagRestart];
    4:begin
        CommandParams:=CommandParams - [fbagRestart] + [fbagRestartWith];
        CurrentValue:=StrToInt(AWord);
      end;
    5:CommandParams:=CommandParams - [fbagRestartIncrementBy] + [fbagRestartIncrement];
    6:CommandParams:=CommandParams + [fbagRestartIncrementBy] - [fbagRestartIncrement];
    7:IncrementBy:=StrToInt(AWord);
    8:begin
        Command:=fbagSetGenerator;
        Name:=AWord;
      end;
    9:begin
        Command:=fbagRecreate;
        SequenceStyle:=fbssSequence;
        Name:=AWord;
      end;
    10:begin
        Command:=fbagRecreate;
        SequenceStyle:=fbssGenerator;
        Name:=AWord;
      end;
  end;
end;

procedure TFBSQLAlterGenerator.MakeSQL;
var
  S: String;
begin
  if Command = fbagSetGenerator then
  begin
    S:=Format('SET GENERATOR %s TO %d', [FullName, CurrentValue]);
  end
  else
  begin
    if SequenceStyle = fbssGenerator then
      S:='GENERATOR'
    else
      S:='SEQUENCE';


    if Command = fbagAlter then
    begin
      S:='ALTER '+S+' ' + FullName;
      if fbagRestart in CommandParams then
        S:=S + ' RESTART'
      else
      if fbagRestartWith in CommandParams then
        S:=S + ' RESTART WITH '+IntToStr(CurrentValue);
    end
    else
    if Command = fbagRecreate then
    begin
      S:='RECREATE '+S+' ' + FullName;
      if fbagRestartWith in CommandParams then
        S:=S + ' START WITH '+IntToStr(CurrentValue);
    end;

    if fbagRestartIncrement in CommandParams then
      S:=S + ' INCREMENT '+IntToStr(IncrementBy)
    else
    if fbagRestartIncrementBy in CommandParams  then
      S:=S + ' INCREMENT BY '+IntToStr(IncrementBy);

  end;

  AddSQLCommand(S);
  if Description <> FOldDescription then
    DescribeObject;


  //ALTER {SEQUENCE | GENERATOR} seq_name
  //[RESTART [WITH new_val ]]
  //[INCREMENT [BY] increment ];

  //RECREATE {SEQUENCE | GENERATOR} seq_name
  //[START WITH value ] [INCREMENT [BY] increment ];
end;

procedure TFBSQLAlterGenerator.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLAlterGenerator then
  begin
    OldDescription:=TFBSQLAlterGenerator(ASource).OldDescription;
    Command:=TFBSQLAlterGenerator(ASource).Command;
    CommandParams:=TFBSQLAlterGenerator(ASource).CommandParams;
  end;
  inherited Assign(ASource);
end;

{ TFBSQLCreateGenerator }

procedure TFBSQLCreateGenerator.InitParserTree;
var
  T1, T2, T, FSQLTokens: TSQLTokenRecord;
begin
  //CREATE {SEQUENCE | GENERATOR} seq_name
  //[START WITH value ] [INCREMENT [BY] increment ];

  //CREATE OR ALTER {SEQUENCE | GENERATOR} seq_name
  //[{START WITH value | RESTART}]
  //[INCREMENT [BY] increment ];


  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okSequence);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'SEQUENCE', [toFindWordLast]);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'GENERATOR', [toFindWordLast], 1);
  T:=AddSQLTokens(stIdentificator, T1, '', [], 2);
    T2.AddChildToken(T);
end;

procedure TFBSQLCreateGenerator.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:SequenceStyle:=fbssGenerator;
    2:Name:=AWord;
  end;
end;

procedure TFBSQLCreateGenerator.MakeSQL;
var
  S: String;
begin
  if SequenceStyle = fbssGenerator then
    S:='GENERATOR'
  else
    S:='SEQUENCE';

  AddSQLCommandEx('CREATE %s %s', [S, FullName]);

  if CurrentValue <> 0 then
    AddSQLCommandEx('ALTER %s %s RESTART WITH %d', [S, FullName, CurrentValue]);

  if Description <> '' then
    DescribeObject;
end;

constructor TFBSQLCreateGenerator.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSQLCommentOnClass:=TFBSQLCommentOn;
end;

procedure TFBSQLCreateGenerator.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLCreateGenerator then
  begin
    SequenceStyle:=TFBSQLCreateGenerator(ASource).SequenceStyle;
  end;
  inherited Assign(ASource);
end;

{ TFBLocalVariableParser }

procedure TFBLocalVariableParser.InitParserTree;
var
  T, FSQLTokens, T1, TE, T3, T2, T4, T5, T_7, T_8, TD1, TD2,
    TDV1, TDV2, TDV3, TCurs1, TDV4, T5_1, TFunc, TProc,
    TFuncName, TProcName: TSQLTokenRecord;
begin
(*
  DECLARE [VARIABLE] varname <var_spec>;
  <var_spec> ::= <type> [NOT NULL] [<coll>] [<default>] | CURSOR FOR (select-statement)

  <type> ::= sql_datatype | [TYPE OF] domain | TYPE OF COLUMN rel.col

  <coll> ::= COLLATE collation
  <default> ::= {= | DEFAULT} value

  declare variable f_delta numeric(18,2) = 0;
*)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DECLARE', [toFirstToken, toFindWordLast]);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'VARIABLE', []);
  T1:=AddSQLTokens(stIdentificator, [FSQLTokens, T], '', [], 1); //variable name

  TCurs1:=AddSQLTokens(stKeyword, T1, 'CURSOR', []); //variable name
  TCurs1:=AddSQLTokens(stKeyword, TCurs1, 'FOR', []); //variable name
  TCurs1:=AddSQLTokens(stSymbol, TCurs1, '(', [], 90); //variable name

  T5:=AddSQLTokens(stIdentificator, T1, '', [], 2);  //type name
    T5_1:=AddSQLTokens(stKeyword, T5, 'precision', [], 22);  //type name
    T:=AddSQLTokens(stSymbol, T5, '(', []);
    T_7:=AddSQLTokens(stInteger, T, '', [], 6);
    T:=AddSQLTokens(stSymbol, T_7, ',', []);
    T:=AddSQLTokens(stInteger, T, '', [], 7);
    T_8:=AddSQLTokens(stSymbol, T, ')', []);
      T_7.AddChildToken(T_8);

  T2:=AddSQLTokens(stKeyword, T1, 'TYPE', []);
  T2:=AddSQLTokens(stKeyword, T2, 'OF', []);

  T3:=AddSQLTokens(stIdentificator, T2, '', [], 3); //type of domain

  T4:=AddSQLTokens(stKeyword, T2, 'COLUMN', []);
    T4:=AddSQLTokens(stIdentificator, T4, '', [], 4);
    T4:=AddSQLTokens(stSymbol, T4, '.', []);
    T4:=AddSQLTokens(stIdentificator, T4, '', [], 5);

  TD1:=AddSQLTokens(stSymbol, [T5, T5_1, T_8], '=', []);
  TD2:=AddSQLTokens(stKeyword, [T5, T5_1, T_8], 'DEFAULT', []);
    TDV1:=AddSQLTokens(stString, [TD1, TD2], '', [], 99);
    TDV2:=AddSQLTokens(stIdentificator, [TD1, TD2], '', [], 99);
    TDV3:=AddSQLTokens(stKeyword, [TD1, TD2], 'null', [], 99);
    TDV4:=AddSQLTokens(stInteger, [TD1, TD2], '', [], 99);

//    T3.AddChildToken([TDV1, TDV2, TDV3]);
//    T4.AddChildToken([TDV1, TDV2, TDV3]);
//    T_8.AddChildToken([TDV1, TDV2, TDV3]);

  TE:=AddSQLTokens(stSymbol, [T3, T4, T5, T5_1, T_8, TDV1, TDV2, TDV3, TDV4, TCurs1], ';', [], 100);
    TE.AddChildToken(FSQLTokens);

  TFunc:=AddSQLTokens(stKeyword, FSQLTokens, 'FUNCTION', []);
    TFuncName:=AddSQLTokens(stIdentificator, TFunc, '', [], 200);
(*
DECLARE FUNCTION subfuncname [( <inparam> [, <inparam> ...])]
RETURNS <type> [COLLATE collation ] [DETERMINISTIC]
AS
[ <declarations> ]
BEGIN
[ <PSQL_statements> ]
END
*)

  TProc:=AddSQLTokens(stKeyword, FSQLTokens, 'PROCEDURE', []);
    TProcName:=AddSQLTokens(stIdentificator, TProc, '', [], 300);

  TFuncName.AddChildToken(FSQLTokens);
  TProcName.AddChildToken(FSQLTokens);
(*
DECLARE PROCEDURE subprocname [( <inparam> [, <inparam> ...])]
[RETURNS ( <outparam> [, <outparam> ...])]
AS
[ <declarations> ]
BEGIN
[ <PSQL_statements> ]
END
*)
end;

procedure TFBLocalVariableParser.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:begin
        FCurField:=Params.AddParam(AWord);
        FCurField.InReturn:=spvtLocal;
      end;
    2:if Assigned(FCurField) then FCurField.TypeName:=AWord; //обычный тип или домен
    22:if Assigned(FCurField) then FCurField.TypeName:=FCurField.TypeName + ' ' + AWord; //тип из 2 х слов
    3:if Assigned(FCurField) then
      begin
        FCurField.TypeName:=AWord; //домен TYPE OF
        FCurField.TypeOf:=true;
      end;
    4:if Assigned(FCurField) then FCurField.TypeName:=AWord; //обычный тип или домен
    5:if Assigned(FCurField) then FCurField.TypeName:=AWord; //обычный тип или домен
    6:if Assigned(FCurField) then FCurField.TypeLen:=StrToInt(AWord);
    7:if Assigned(FCurField) then FCurField.TypePrec:=StrToInt(AWord);
    90:if Assigned(FCurField) then FCurField.TypeName:='CURSOR FOR (' + ASQLParser.GetToBracket(')') + ')';
    99:if Assigned(FCurField) then FCurField.DefaultValue:=AWord;
    100:begin
        if Assigned(FCurField) then
          FCurField.Description:=Trim(ASQLParser.GetCommentForEOL);
        FCurField:=nil;
      end;
    200:begin
        FCurField:=Params.AddParam(AWord);
        FCurField.InReturn:=spvtSubFunction;
        FCurField.CheckExpr:=GetToEndpSQL(ASQLParser);
      end;
    300:begin
        FCurField:=Params.AddParam(AWord);
        FCurField.InReturn:=spvtSubProc;
        FCurField.CheckExpr:=GetToEndpSQL(ASQLParser);
      end;
  end;
end;

procedure TFBLocalVariableParser.MakeSQL;

function DoParamTypeStr(P: TSQLParserField):string;
begin
  Result:='';
  if P.TypeOf then
    Result:=Result + ' TYPE OF';
  Result:=Result + ' ' + P.TypeName;
  if P.TypeLen > 0 then
  begin
    Result:=Result +'('+IntToStr(P.TypeLen);
    if P.TypePrec > 0 then
      Result:=Result + ',' + IntToStr(P.TypePrec);
    Result:=Result+')';
  end;

  if P.CharSetName <> '' then
    Result:=Result + ' CHARACTER SET ' + P.CharSetName;

  if P.Collate <> '' then
    Result:=Result + ' COLLATE ' + P.Collate;

  if fpNotNull in P.Params then
    Result:=Result + ' NOT NULL';
  //COLLATE collation
  if P.DefaultValue <> '' then
    Result:=Result + ' = ' + P.DefaultValue;
end;

var
  P: TSQLParserField;
  S: String;
begin
  S:='';
  for P in Params do
  begin
    if FDescType = fbldDescription then
      AddSQLCommand(Format('COMMENT ON PARAMETER %s.%s IS %s;' + LineEnding, [DoFormatName2(FOwnerName), DoFormatName(P.Caption),  QuotedStr(P.Description)]))
    else
    begin
      if S <> '' then S:=S + LineEnding;
      if FDescType = fbldLocal then
      begin

        case P.InReturn of
          spvtSubFunction:S:=S + 'DECLARE FUNCTION ' + DoFormatName2(P.Caption) + P.CheckExpr;
          spvtSubProc:S:=S + 'DECLARE PROCEDURE ' + DoFormatName2(P.Caption) + P.CheckExpr;
          spvtLocal:begin
              S:=S + 'DECLARE VARIABLE ' + DoFormatName(P.Caption) + DoParamTypeStr(P);
              S:=S + ';';
              if (P.Description <> '') then
                S:=S + ' /* ' + P.Description + ' */';
            end;
        end;
      end
      else
      begin
        S:=S + '  ' + DoFormatName(P.Caption) + DoParamTypeStr(P) + ',';
      end
    end;
  end;

  if (not (FDescType in [fbldLocal, fbldDescription])) and (S<>'') then
    S:=Copy(S, 1, Length(S)-1);

  if S<> '' then AddSQLCommand(S, false);
end;


procedure TFBLocalVariableParser.ParseLocalVars(ASQLParser: TSQLParser);
begin
  FCurField:=nil;
  ParseSQL(ASQLParser);
  ASQLParser.Position:=ASQLParser.WordPosition;
end;

function TFBLocalVariableParser.ParseLocalVarsEx(ASQL: string): integer;
var
  FSQLParser: TSQLParser;
begin
  FSQLParser:=TSQLParser.Create(ASQL, nil);
  ParseLocalVars(FSQLParser);
  Result:=FSQLParser.WordPosition.Position;
  FSQLParser.Free;
end;

{ TFBSQLCreateProcedure }

procedure TFBSQLCreateProcedure.ParseLocalVariables(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
var
  L: TFBLocalVariableParser;
begin
  L:=TFBLocalVariableParser.Create(nil);
  L.ParseLocalVars(ASQLParser);
  Params.CopyFrom(L.Params, []);
  L.Free;
end;

procedure TFBSQLCreateProcedure.InitParserTree;
var
  FSQLTokens, T, TName, T2, TOParS, TOParS_N,
    TOParE, T4, {T5, T6,} TInS, TInS_N, TInE, TOParSymb, TInSymb,
    FSQLTokens1: TSQLTokenRecord;
begin
(*
CREATE PROCEDURE procname
[(<inparam> [, <inparam> ...])]
[RETURNS (<outparam> [, <outparam> ...])]
AS
[<declarations>]
BEGIN
[<PSQL_statements>]
END

	<inparam> ::= <param_decl> [{= | DEFAULT} <value>]

	<outparam> ::= <param_decl>

	<value> ::= {literal | NULL | context_var}

	<param_decl> ::= paramname <type> [NOT NULL]
	[COLLATE collation]

<type> ::=
  <datatype> |
  [TYPE OF] domain |
  TYPE OF COLUMN rel.col

<datatype> ::=
    {SMALLINT | INT[EGER] | BIGINT}
  | {FLOAT | DOUBLE PRECISION}
  | {DATE | TIME | TIMESTAMP}
  | {DECIMAL | NUMERIC} [(precision [, scale])]
  | {CHAR | CHARACTER | CHARACTER VARYING | VARCHAR} [(size)]
    [CHARACTER SET charset]
  | {NCHAR | NATIONAL CHARACTER | NATIONAL CHAR} [VARYING]
    [(size)]
  | BLOB [SUB_TYPE {subtype_num | subtype_name}]
    [SEGMENT SIZE seglen] [CHARACTER SET charset]
  | BLOB [(seglen [, subtype_num])]

<declarations> ::=
  {<declare_var> | <declare_cursor>};
    [{<declare_var> | <declare_cursor>}; …]

    CREATE OR ALTER PROCEDURE procname
    [(<inparam> [, <inparam> ...])]
    [RETURNS (<outparam> [, <outparam> ...])]
    AS
    [<declarations>]
    BEGIN
    [<PSQL_statements>]
    END
*)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okStoredProc);
  FSQLTokens1:=AddSQLTokens(stKeyword, nil, 'RECREATE', [toFirstToken], 1, okStoredProc);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'OR', []);
    T:=AddSQLTokens(stKeyword, T, 'ALTER', [toFirstToken], -2);
  T:=AddSQLTokens(stKeyword, [FSQLTokens, T, FSQLTokens1], 'PROCEDURE', [toFindWordLast]);


  TName:=AddSQLTokens(stIdentificator, T, '', [], 100);

  TInS:=AddSQLTokens(stSymbol, TName, '(', []);
  TInSymb:=AddSQLTokens(stSymbol, nil, ',', [], 103);
  TInS_N:=AddSQLTokens(stIdentificator, [TInS, TInSymb], '', [], 101);
  TInE:=AddSQLTokens(stSymbol, nil, ')', [], 104);
  MakeTypeDefTree(Self, [TInS_N], [TInE, TInSymb], tdfParams, 0);

  T2:=AddSQLTokens(stKeyword, [TName, TInE], 'RETURNS', []);
  TOParS:=AddSQLTokens(stSymbol, T2, '(', []);
  TOParSymb:=AddSQLTokens(stSymbol, nil, ',', [], 103);
  TOParS_N:=AddSQLTokens(stIdentificator, [TOParS, TOParSymb], '', [], 102);
  TOParE:=AddSQLTokens(stSymbol, nil, ')', [], 104);
  MakeTypeDefTree(Self, [TOParS_N], [TOParE, TOParSymb], tdfParams, 0);

  T4:=AddSQLTokens(stKeyword, [TName, TInE, TOParE], 'AS', [], 200);

  {T5:=}AddSQLTokens(stKeyword, T4, 'BEGIN', [], 600);
//  T6:=AddSQLTokens(stKeyword, T5, 'END', []);
end;

procedure TFBSQLCreateProcedure.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
var
  S: String;
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
      //1:CreateMode:=cmCreateOrAlter;
    101:begin
          FCurParam:=Params.AddParam(AWord);
          FCurParam.InReturn:=spvtInput;
        end;
    102:begin
          FCurParam:=Params.AddParam(AWord);
          FCurParam.InReturn:=spvtOutput;
        end;
    103,
    104:FCurParam:=nil;
      2:if Assigned(FCurParam) then FCurParam.TypeName:=AWord;
      3:if Assigned(FCurParam) then FCurParam.TypeName:=FCurParam.TypeName + ' ' + AWord;
     26:if Assigned(FCurParam) then FCurParam.TypeName:=FCurParam.TypeName + AWord;
      4:if Assigned(FCurParam) then FCurParam.TypeLen:=StrToInt(AWord);
      5:if Assigned(FCurParam) then FCurParam.TypePrec:=StrToInt(AWord);
      7:if Assigned(FCurParam) then FCurParam.CharSetName:=AWord;
      8:if Assigned(FCurParam) then FCurParam.Params:=FCurParam.Params + [fpNotNull];
     13:if Assigned(FCurParam) then FCurParam.DefaultValue:=AWord;
     10:if Assigned(FCurParam) then FCurParam.Collate:=AWord;
      9:begin
          S:=ASQLParser.GetToBracket(')');
          if Assigned(FCurParam) then
            FCurParam.CheckExpr:=S;
        end;
    100:Name:=AWord;
    302:;
    200:ParseLocalVariables(ASQLParser, AChild, AWord);
    //600:DoParseBody(ASQLParser);
    600:begin
          ASQLParser.Position:=ASQLParser.WordPosition;
          Body:=GetToEndpSQL(ASQLParser);
        end;
  end;
end;

constructor TFBSQLCreateProcedure.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSQLCommentOnClass:=TFBSQLCommentOn;
  ObjectKind:=okStoredProc;
end;

procedure TFBSQLCreateProcedure.MakeSQL;
var
  FIn, FOut, FLocal, S: String;
  i: Integer;
  LP: TFBLocalVariableParser;
begin
  FIn:='';
  FOut:='';
  FLocal:='';

  LP:=TFBLocalVariableParser.Create(nil);
  LP.OwnerName:=FullName;
  LP.Params.CopyFrom(Params, [spvtInput]);
  LP.DescType:=fbldParams;
  FIn:=LP.AsSQL;

  LP.Clear;
  LP.Params.CopyFrom(Params, [spvtOutput]);
  LP.DescType:=fbldParams;
  FOut:=LP.AsSQL;

  LP.Clear;
  LP.Params.CopyFrom(Params, [spvtLocal]);
  LP.DescType:=fbldLocal;
  FLocal:=LP.AsSQL;

  S:='CREATE ';
  if ooOrReplase in Options then
    S:=S + 'OR ALTER ';
  S:=S + 'PROCEDURE ' + FullName;


  if FIn <> '' then
    S:=S + '('+LineEnding + FIn + ')';
  S:=S + LineEnding ;

  if FOut <> '' then
    S:=S + 'RETURNS' + LineEnding + '('+LineEnding + FOut + ')' + LineEnding;

  S:=S + ' AS'+LineEnding;

  if FLocal <> '' then
    S:=S + FLocal + LineEnding;

  S:=TrimRight(S + Body);

  if (S<>'') and (S[Length(S)]<>';') then
    S := S + ';';

  AddSQLCommand(S);

  if Description <> '' then
    DescribeObject;


  LP.Clear;
  LP.Params.CopyFrom(Params, [spvtInput]);
  LP.DescType:=fbldDescription;
  for i:=0 to LP.SQLText.Count-1 do AddSQLCommand(LP.SQLText[i]);

  LP.Clear;
  LP.Params.CopyFrom(Params, [spvtOutput]);
  LP.DescType:=fbldDescription;
  for i:=0 to LP.SQLText.Count-1 do AddSQLCommand(LP.SQLText[i]);
  LP.Free;
end;

{ TFBSQLCreateView }

procedure TFBSQLCreateView.InitParserTree;
var
  FSQLTokens, FSQLTokens1, T, FTViewColumnName, T1, FTViewName,
    FSQLTokens2: TSQLTokenRecord;
begin
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okView);    //CREATE
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'OR', []);                  //OR
    T:=AddSQLTokens(stKeyword, T, 'ALTER', [], -2);                      //OR ALTER

  FSQLTokens1:=AddSQLTokens(stKeyword, nil, 'RECREATE', [toFirstToken], 2, okView);    //RECREATE
  FSQLTokens2:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken], 6, okView);    //RECREATE

  T:=AddSQLTokens(stKeyword, T, 'VIEW', [toFindWordLast]);                           //VIEW
    FSQLTokens.AddChildToken(T);
    FSQLTokens1.AddChildToken(T);
    FSQLTokens2.AddChildToken(T);


  FTViewName:=AddSQLTokens(stIdentificator, T, '', [], 3);                 //view name

  T:=AddSQLTokens(stSymbol, FTViewName, '(', []);

  FTViewColumnName:=AddSQLTokens(stIdentificator, T, '', [], 4);           //Column Name
  T1:=AddSQLTokens(stSymbol, FTViewColumnName, ',', []);
    T1.AddChildToken(FTViewColumnName);
  T1:=AddSQLTokens(stSymbol, FTViewColumnName, ')', []);

  T:=AddSQLTokens(stKeyword, T1, 'AS', [], 5);
    FTViewName.AddChildToken(T);
end;

procedure TFBSQLCreateView.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
var
  C: TParserPosition;
begin
  case AChild.Tag of
    //1:CreateMode:=cmCreateOrAlter;
    2:CreateMode:=cmRecreate;
    3:Name:=AWord;
    4:Fields.AddParam(AWord);
    5:begin
        C:=ASQLParser.Position;
        SQLSelect:=TrimLeft(ASQLParser.GetToCommandDelemiter);
        ASQLParser.Position:=C;
        FSQLCommandSelect:=TSQLCommandSelect.Create(nil);
        FSQLCommandSelect.ParseSQL(ASQLParser);
      end;
    6:CreateMode:=cmAlter;
  end;
end;

procedure TFBSQLCreateView.MakeSQL;
var
  S: String;
  F: TSQLParserField;
begin
  case CreateMode of
    cmCreate:
       begin
         S:='CREATE ' + FullName;
         if ooOrReplase in Options then S:=S + 'ALTER ';
         S:=S + 'VIEW ' + FullName;
       end;
    cmRecreate:S:='RECREATE VIEW ' + FullName;
    //cmCreateOrAlter:S:='CREATE OR ALTER VIEW ' + FullName;
    cmAlter:S:='ALTER VIEW ' + FullName;
  end;

  if Fields.Count > 0 then
    S:=S + '('+LineEnding + Fields.AsList + ')';

  if Assigned(FSQLCommandSelect) or (SQLSelect <> '') then
    S:=S + LineEnding + 'as'+LineEnding + SQLSelect; // FSQLCommandSelect.AsSQL;
  AddSQLCommand(S);

  if Description <> '' then
    DescribeObject;

  for F in Fields do
    if F.Description <> '' then
      DescribeObjectEx(okColumn, F.Caption, FullName, F.Description);
end;

constructor TFBSQLCreateView.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSQLCommentOnClass:=TFBSQLCommentOn;
end;

procedure TFBSQLCreateView.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLCreateView then
  begin
    SQLCommandSelect.Assign(TFBSQLCreateView(ASource).SQLCommandSelect);
  end;
  inherited Assign(ASource);
end;


{ TFBSQLCreateTrigger }

procedure TFBSQLCreateTrigger.ParseLocalVariables(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
var
  L: TFBLocalVariableParser;
begin
  L:=TFBLocalVariableParser.Create(nil);
  L.ParseLocalVars(ASQLParser);
  Params.CopyFrom(L.Params, []);
  L.Free;
end;

procedure TFBSQLCreateTrigger.SetBody(AValue: string);
var
  L: TFBLocalVariableParser;
  B: Integer;
begin
  AValue:=TrimLeft(AValue);
  if UpperCase(Copy(AValue, 1, 2)) = 'AS' then
    AValue:=TrimLeft(Copy(AValue, 3, Length(AValue)));

  L:=TFBLocalVariableParser.Create(nil);
  B:=L.ParseLocalVarsEx(AValue);
  Params.CopyFrom(L.Params);
  L.Free;

  AValue:=Copy(AValue, B, Length(AValue));

  inherited SetBody(AValue);
end;

procedure TFBSQLCreateTrigger.InitParserTree;
var
  FSQLTokens, Par1, State1, State2, Par2, Symb, State3,
    TrigName: TSQLTokenRecord;
begin
  inherited InitParserTree;
  (*
  CREATE TRIGGER trigname {
  <relation_trigger_legacy>
  | <relation_trigger_sql2003>
  | <database_trigger>
  | <ddl_trigger> }
  {EXTERNAL NAME ' <extname> ' ENGINE <engine> } |
  {
  AS
  [ <declarations> ]
  BEGIN
  [ <PSQL_statements> ]
  END
  }

  <relation_trigger_legacy> ::=
  FOR { tablename | viewname }
  [ACTIVE | INACTIVE]
  {BEFORE | AFTER} <mutation_list>
  [POSITION number ]


  <relation_trigger_sql2003> ::=
    [ACTIVE | INACTIVE]
    {BEFORE | AFTER} <mutation_list>
    [POSITION number]
    ON {tablename | viewname}

  <database_trigger> ::=
    [ACTIVE | INACTIVE] ON db_event [POSITION number]

  <ddl_trigger> ::=
    [ACTIVE | INACTIVE]
    {BEFORE | AFTER} <ddl_events>
    [POSITION number ]

  <mutation_list> ::=
    <mutation> [OR <mutation> [OR <mutation>]]

  <mutation> ::= { INSERT | UPDATE | DELETE }

  <db_event> ::= {
    CONNECT |
    DISCONNECT |
    TRANSACTION START |
    TRANSACTION COMMIT |
    TRANSACTION ROLLBACK
  }
  <ddl_events> ::= {
  ANY DDL STATEMENT
| <ddl_event_item> [{OR <ddl_event_item> } ...]

<ddl_event_item> ::=
CREATE TABLE | ALTER TABLE | DROP TABLE
| CREATE PROCEDURE | ALTER PROCEDURE | DROP PROCEDURE
| CREATE FUNCTION | ALTER FUNCTION | DROP FUNCTION
| CREATE TRIGGER | ALTER TRIGGER | DROP TRIGGER
| CREATE EXCEPTION | ALTER EXCEPTION | DROP EXCEPTION
| CREATE VIEW | ALTER VIEW | DROP VIEW
| CREATE DOMAIN | ALTER DOMAIN | DROP DOMAIN
| CREATE ROLE | ALTER ROLE | DROP ROLE
| CREATE SEQUENCE | ALTER SEQUENCE | DROP SEQUENCE
| CREATE USER | ALTER USER | DROP USER
| CREATE INDEX | ALTER INDEX | DROP INDEX
| CREATE COLLATION | DROP COLLATION
| ALTER CHARACTER SET
| CREATE PACKAGE | ALTER PACKAGE | DROP PACKAGE
| CREATE PACKAGE BODY | DROP PACKAGE BODY
| CREATE MAPPING | ALTER MAPPING | DROP MAPPING

  <declarations> ::= {<declare_var> | <declare_cursor>};
    [{<declare_var> | <declare_cursor>}; …]
*)

  //Строим дерево граматического разбора
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken]);    //CREATE TRIGGER
    Par1:=AddSQLTokens(stKeyword, FSQLTokens, 'OR', [], -2);
    Par1:=AddSQLTokens(stKeyword, Par1, 'ALTER', [toFirstToken], 1);
  FSQLTokens:=AddSQLTokens(stKeyword, [FSQLTokens, Par1], 'TRIGGER', [toFindWordLast]);    //CREATE TRIGGER

    TrigName:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 2);       //  trigger_name
    Par1:=AddSQLTokens(stKeyword, TrigName, 'FOR', []);              //FOR
    Par1:=AddSQLTokens(stIdentificator, Par1, '', [], 3);            //  table_name

    State1:=AddSQLTokens(stKeyword, [Par1, TrigName], 'ACTIVE', [], 4);         // |ACTIVE|
    State2:=AddSQLTokens(stKeyword, [Par1, TrigName], 'INACTIVE', [], 5);       // |INACTIVE|
    //Par1.AddChildToken(State2);

    Par1:=AddSQLTokens(stKeyword, State1, 'BEFORE', [toOptional], 6);         // |BEFORE|
    Par2:=AddSQLTokens(stKeyword, State1, 'AFTER', [toOptional], 7);          // |AFTER|
    State2.AddChildToken(Par1);
    State2.AddChildToken(Par2);

    State1:=AddSQLTokens(stKeyword, Par1, 'INSERT', [], 8);          // |INSERT|
    Symb:=AddSQLTokens(stKeyword, State1, 'OR', []);             //OR
    State2:=AddSQLTokens(stKeyword, Par1, 'UPDATE', [], 9);          // |UPDATE|
    Symb.AddChildToken(State2);
    Symb:=AddSQLTokens(stKeyword, State2, 'OR', []);             //OR
    State3:=AddSQLTokens(stKeyword, Par1, 'DELETE', [], 10);          // |DELETE|
    Symb.AddChildToken(State3);

    Par2.AddChildToken(State1);
    Par2.AddChildToken(State2);
    Par2.AddChildToken(State3);

    Par1:=AddSQLTokens(stKeyword, State1, 'POSITION', []);        //POSITION
    Par2:=AddSQLTokens(stInteger, Par1, '', [], 11);                    //  number
    State2.AddChildToken(Par1);
    State3.AddChildToken(Par1);

    Par1:=AddSQLTokens(stKeyword, Par2, 'AS', [], 20);                //AS

    Par1:=AddSQLTokens(stKeyword, Par1, 'begin', [], 21); //AS
end;

procedure TFBSQLCreateTrigger.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    //22:CreateMode:=cmCreateOrAlter;
    1:if not (ooOrReplase in Options) then CreateMode:=cmAlter;
    2:Name:=AWord;
    3:TableName:=AWord;
    4:FActive:=true;
    5:FActive:=false;
    6:FTriggerType:=FTriggerType + [ttBefore];
    7:FTriggerType:=FTriggerType + [ttAfter];
    8:FTriggerType:=FTriggerType + [ttInsert];
    9:FTriggerType:=FTriggerType + [ttUpdate];
    10:FTriggerType:=FTriggerType + [ttDelete];
    11:FPosition:=StrToInt(AWord);
    20:ParseLocalVariables(ASQLParser, AChild, AWord);
    21:begin
         ASQLParser.Position:=ASQLParser.WordPosition;
         Body:=GetToEndpSQL(ASQLParser);
       end;
  end;
end;

procedure TFBSQLCreateTrigger.MakeSQL;
var
  S, S1: String;
  L: TFBLocalVariableParser;
begin
  S:='';
  if CreateMode = cmAlter then
    S:=S+'ALTER'
  else
  begin
    S:='CREATE';
    if ooOrReplase in Options then
      S:=S+' OR ALTER';
  end;
  S:=S + ' TRIGGER ' + DoFormatName(Name);

  if TableName <> '' then
    S:=S + ' FOR ' + DoFormatName(TableName) + LineEnding;

  if FActive then
    S:=S + ' ACTIVE'
  else
    S:=S + ' INACTIVE';

  if ttBefore in FTriggerType then
    S:=S + ' BEFORE'
  else
  if ttAfter in FTriggerType then
    S:=S + ' AFTER';

  S1:='';
  if ttInsert in FTriggerType then
    S1:=S1 + 'INSERT';

  if ttUpdate in FTriggerType then
  begin
    if S1 <> '' then S1:=S1 + ' OR ';
    S1:=S1 + 'UPDATE';
  end;

  if ttDelete in FTriggerType then
  begin
    if S1 <> '' then S1:=S1 + ' OR ';
    S1:=S1 + 'DELETE';
  end;

  S:=S + ' ' +S1 + LineEnding;

  if FPosition > 0 then
    S:=S + '  POSITION '+ IntToStr(FPosition) + LineEnding;

  if (Body<>'') or (Params.Count > 0) then
  begin
    L:=TFBLocalVariableParser.Create(nil);
    L.Params.CopyFrom(Params);
    L.OwnerName:=Name;
    L.DescType:=fbldLocal;
    S:=S + 'AS' + LineEnding + L.AsSQL + Body;
    L.Free;
  end;

  AddSQLCommand(S);

  if Description <> '' then
    DescribeObject;
end;

constructor TFBSQLCreateTrigger.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FActive:=true;
  FTriggerType:=[];
  ObjectKind:=okTrigger;
  FSQLCommentOnClass:=TFBSQLCommentOn;
end;

procedure TFBSQLCreateTrigger.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TFBSQLCreateTrigger then
  begin
    TriggerType:=TFBSQLCreateTrigger(ASource).TriggerType;
    Active:=TFBSQLCreateTrigger(ASource).Active;
    Position:=TFBSQLCreateTrigger(ASource).Position;

  end;
  inherited Assign(ASource);
end;

{ TSQLCommandExecuteBlock }

procedure TSQLCommandExecuteBlock.ParseLocalVariables(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
var
  L: TFBLocalVariableParser;
begin
  L:=TFBLocalVariableParser.Create(nil);
  L.ParseLocalVars(ASQLParser);
  Params.CopyFrom(L.Params, []);
  L.Free;
end;

procedure TSQLCommandExecuteBlock.InitParserTree;
var
  FSQLTokens, SymbInPar, FInParName, FInSymbParam, Symb,
    SymbOutPar, FSymbOutParName, TAs,FInSymbParam2, TBegin: TSQLTokenRecord;
begin
(*
EXECUTE BLOCK [(<inparams>)]
     [RETURNS (<outparams>)]
AS
   [<declarations>]
BEGIN
   [<PSQL statements>]
END*)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'EXECUTE', [toFirstToken]);
  FSQLTokens:=AddSQLTokens(stKeyword, FSQLTokens, 'BLOCK', [toFindWordLast]);
    SymbInPar:=AddSQLTokens(stSymbol, FSQLTokens, '(', []);
      FInParName:=AddSQLTokens(stIdentificator, SymbInPar, '', [], 5);
      FInSymbParam:=AddSQLTokens(stSymbol, nil, '=', []);
    MakeTypeDefTree(Self, [FInParName], [FInSymbParam], tdfParams, 100);

    FInSymbParam2:=AddSQLTokens(stSymbol, FInSymbParam, '?', [], 6);
    FInSymbParam:=AddSQLTokens(stSymbol, FInSymbParam, ':', []);
    FInSymbParam:=AddSQLTokens(stIdentificator, FInSymbParam, '', [], 6);
    Symb:=AddSQLTokens(stIdentificator, [FInSymbParam, FInSymbParam2], ',', []);
    Symb.AddChildToken(FInParName);

    SymbInPar:=AddSQLTokens(stIdentificator, FInSymbParam, ')', []);

  SymbOutPar:=AddSQLTokens(stSymbol, [SymbInPar, FSQLTokens], 'returns', [], 10);
    SymbOutPar:=AddSQLTokens(stSymbol, SymbOutPar, '(', []);
    FSymbOutParName:=AddSQLTokens(stIdentificator, SymbOutPar, '', [], 11);
    Symb:=AddSQLTokens(stIdentificator, nil, ',', []);
      Symb.AddChildToken(FSymbOutParName);
    SymbOutPar:=AddSQLTokens(stIdentificator, nil, ')', []);
    MakeTypeDefTree(Self, [FSymbOutParName], [Symb, SymbOutPar], tdfParams, 100);

  TAs:=AddSQLTokens(stKeyword,[FSQLTokens, SymbInPar, SymbOutPar], 'as', [], 20);

{  TDeclare:=AddSQLTokens(stKeyword, TAs, 'declare', []);
    TDeclareVar:=AddSQLTokens(stKeyword, TDeclare, 'variable', []);
    FLocVarName:=AddSQLTokens(stIdentificator, [TDeclare, TDeclareVar], '', [], 20);
    FLocVarSymb:=AddSQLTokens(stSymbol, nil, ';', [], 22);
      FLocVarSymb.AddChildToken(TDeclare);
    FLocVarVal:=AddSQLTokens(stSymbol, nil, '=', []);

    MakeTypeDefTree(Self, [FLocVarName], [FLocVarSymb, FLocVarVal], tdfParams, 100);

    FLocVarVal1:=AddSQLTokens(stString, FLocVarVal, '', [], 21);
      FLocVarVal1.AddChildToken(FLocVarSymb);
    FLocVarVal1:=AddSQLTokens(stNumber, FLocVarVal, '', [], 21);
      FLocVarVal1.AddChildToken(FLocVarSymb);
      }
  {TBegin:=}AddSQLTokens(stKeyword, [TAs{, FLocVarSymb}], 'begin', [], 30); //AS
  //Пока только заголовок блока
end;

procedure TSQLCommandExecuteBlock.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    5:begin
         FCurField:=Params.AddParam(AWord);
         FCurField.InReturn:=spvtInput;
       end;

     6:if Assigned(FCurField) then
         FCurField.ComputedSource:=AWord;
    10:FSelectable:=true;
    11:begin
         FCurField:=Params.AddParam(AWord);
         FCurField.InReturn:=spvtOutput;
       end;
    20:ParseLocalVariables(ASQLParser, AChild, AWord);
{    20:begin
         FCurField:=Params.AddParam(AWord);
         FCurField.InReturn:=spvtLocal;
       end;
    21:if Assigned(FCurField) then
         FCurField.DefaultValue:=AWord;
    22:if Assigned(FCurField) then
         FCurField.Description:=Trim(ASQLParser.GetCommentForEOL);}


    102:if Assigned(FCurField) then
         FCurField.TypeName:=AWord;
    103:if Assigned(FCurField) then
         FCurField.TypeName:=FCurField.TypeName + ' ' + AWord;
    104:if Assigned(FCurField) then
         FCurField.TypeLen:=StrToInt(AWord);
    105:if Assigned(FCurField) then
         FCurField.TypePrec:=StrToInt(AWord);
    107:if Assigned(FCurField) then
         FCurField.CharSetName:=AWord;
    30:begin
         ASQLParser.Position:=ASQLParser.WordPosition;
         FSQLBody:=GetToEndpSQL(ASQLParser);
       end;

{    8 - NOT NULL
    9 - CHECK (<dom_condition>)
    10 - COLLATE collation_name

    11 - BLOB SUB_TYPE subtype_num
    12 - BLOB SUB_TYPE subtype_name}
  end;
end;

procedure TSQLCommandExecuteBlock.MakeSQL;
var
  ParInp, ParRet, S, ParLocal: String;
  F: TSQLParserField;
begin
  S:='EEXECUTE BLOCK' + LineEnding;

  ParInp:='';
  ParRet:='';
  ParLocal:='';
  for F in Params do
  begin
    case F.InReturn of
      spvtInput:begin
          if ParInp <> '' then
            ParInp:=ParInp + ','+LineEnding;
          ParInp:=ParInp + '  ' + F.Caption + ' ' + F.FullTypeName + ' = ';
          if F.ComputedSource = '?' then
            ParInp:=ParInp + F.ComputedSource
          else
            ParInp:=ParInp + ':' + F.ComputedSource;
        end;
      spvtOutput:begin
          if ParRet <> '' then
            ParRet:=ParRet + ','+LineEnding;
          ParRet:=ParRet + '  ' + F.Caption + ' ' + F.FullTypeName;
        end;
      spvtLocal:begin
          ParLocal:=ParLocal + 'DECLARE VARIABLE ' + F.Caption + ' ' + F.FullTypeName;
          if F.DefaultValue <> '' then
            ParLocal:=ParLocal + ' = '+F.DefaultValue;
          ParLocal:=ParLocal + ';';
          if F.Description <> '' then
            ParLocal:=ParLocal + '/* ' + F.Description + ' */';
          ParLocal:=ParLocal + LineEnding;
        end;
    end;
  end;
 { if //
  [(<inparams>)]
       [RETURNS (<outparams>)]
  AS
     [<declarations>]
  BEGIN
     [<PSQL statements>]
  END*)
}
  if ParInp <> '' then
    S:=S + '  (' + ParInp + ')' + LineEnding;

  if ParRet <> '' then
    S:=S + 'RETURNS (' + LineEnding +  ParRet + ')' + LineEnding;
  S:=S + 'AS' + LineEnding + ParLocal + FSQLBody + LineEnding;
  AddSQLCommand(S);
end;

procedure TSQLCommandExecuteBlock.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLCommandExecuteBlock then
  begin
    SQLBody:=TSQLCommandExecuteBlock(ASource).SQLBody;

  end;
  inherited Assign(ASource);
end;

end.

