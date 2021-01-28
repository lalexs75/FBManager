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

unit fbmSqlParserUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineCommonTypesUnit, sqlObjects;

const
  CharDelimiters = [',',':','}','{',';', '(', ')', '.', '[', ']', '=', '@'];

type
  TSQLParserSintax = (siGlobal, siPostgreSQL, siFirebird);
  TCreateMode = (cmCreate, cmAlter, {cmCreateOrAlter, }cmRecreate, cmDropAndCreate);

  TVisibleType = (vtNone, vtGlobal, vtLocal);

  TCMDState = (cmsNormal, cmsError, cmsEndOfCmd);

  TSQLTokenOption = (toFindWordLast,    //Элемент используется для идентификации SQL запроса в спискедоступных
                     toFirstToken,       //Корень дерева разбора
                     toOptional
                    );
  TSQLTokenOptions = set of TSQLTokenOption;

  TParserPosition = record
    Position:integer;
    X:integer;
    Y:integer;
  end;

  TParserSelectState = (pssNone, pssFields, pssFrom, pssWhere, pssGroupBy, pssHaving, pssOrderBy);
type
  TSQLTokenList = class;
  TSQLTokenListEnumerator = class;
  TSQLCommandSelectCTEListEnumerator = class;
  TSQLStatmentRecordEnumerator = class;
  TSQLCommentOn = class;
  TSQLCommentOnClass = class of TSQLCommentOn;
  TSQLCreateTable = class;
  { TSQLTokenRecord }

  TSQLTokenRecord = class
  private
    FChild:TSQLTokenList;
    FDBObjectKind: TDBObjectKind;
    FOptions: TSQLTokenOptions;
    FSQLCommand: string;
    FCountRef:integer;
    FTag: integer;
    FToken: TSQLToken;
  public
    constructor Create;
    destructor Destroy;override;
    function Equal(S:string):boolean;
    function ChildByName(S:string):TSQLTokenRecord;
    function ChildByType(AToken:TSQLToken; AWord:string = ''):TSQLTokenRecord;
    procedure AddChildToken(AToken:TSQLTokenRecord);
    procedure AddChildToken(ATokens:array of TSQLTokenRecord);overload;
    procedure CopyChildTokens(ASQLToken:TSQLTokenRecord);

    property Child:TSQLTokenList read FChild;
    property SQLCommand:string read FSQLCommand write FSQLCommand;
    property Options:TSQLTokenOptions read FOptions write FOptions;
    property Token:TSQLToken read FToken write FToken;
    property DBObjectKind:TDBObjectKind read FDBObjectKind write FDBObjectKind;
    property Tag:integer read FTag write FTag;
  end;

  { TSQLTokenList }

  TSQLTokenList = class
  private
    FList:TFPList;
    function GetCount: integer;
    function GetItem(AIndex: integer): TSQLTokenRecord;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy;override;
    function GetEnumerator: TSQLTokenListEnumerator;
    procedure Add(AItem:TSQLTokenRecord);
    function IndexOf(AItem:TSQLTokenRecord):integer;
    property Item[AIndex:integer]:TSQLTokenRecord read GetItem; default;
    property Count:integer read GetCount;
  end;

  { TSQLTokenListEnumerator }

  TSQLTokenListEnumerator = class
  private
    FList: TSQLTokenList;
    FPosition: Integer;
  public
    constructor Create(AList: TSQLTokenList);
    function GetCurrent: TSQLTokenRecord;
    function MoveNext: Boolean;
    property Current: TSQLTokenRecord read GetCurrent;
  end;


type
  TSQLParser = class;
  TSQLCommandAbstract = class;
  TSQLCommandAbstractClass = class of TSQLCommandAbstract;

  TSQLProcessComment = procedure (Sender:TSQLParser; AComment:string) of object;

  { TODO : Лишний объект }
  { TSQLDeclareLocalVarParser }

  TSQLDeclareLocalVarParser = class
  protected
    FParams:TSQLFields;
    FCurPos:integer;
    FStop: Boolean;
    FSqlLine:string;
    procedure SkipSpace;
    function GetWord:string;
    function GetWordToSymb(Symb:string):string;
    function GetWordEx:string;
    function GetToEOL:string;
  public
    constructor Create;
    destructor Destroy;override;
    procedure ParseString(ASqlLine:string); virtual;
    procedure ParseDeclare(ASQLParser: TSQLParser); virtual;
    property Params:TSQLFields read FParams;
    property CurPos:integer read FCurPos;
  end;

  { TSQLCommandAbstract }

  TSQLCommandAbstract = class(TSQLObjectAbstract)
  private
    FErrorPos: TParserPosition;
    FSQLTokensList:TSQLTokenList;
    FStartTokens:TSQLTokenList;
    FParent:TSQLCommandAbstract;
    FKeyWordList:TStringList;
    //
    FErrorMessage: string;
    FPlanEnabled: boolean;
    FState: TCMDState;
    FParams: TSQLFields;
    function GetParamsCount: integer;
    procedure SetState(const AValue: TCMDState);
    function DoCheckCommand(FSQLTokens:TSQLTokenRecord; ASQLParser:TSQLParser):boolean;
    function CheckCommand(ASQLParser:TSQLParser):boolean;
    function FindKeyWord(AWord:string):boolean;
  protected
    function GetParams: TSQLFields;virtual;
    procedure SetError(ASQLParser:TSQLParser;const AErrorMessage:string);
    function GetToNextToken(ASQLParser: TSQLParser; AChild: TSQLTokenRecord):string;
    function InternalProcessError(ASQLParser: TSQLParser; var AChild: TSQLTokenRecord):boolean; virtual;

    procedure InitParserTree;virtual;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);virtual;
  public
    constructor Create(AParent:TSQLCommandAbstract);virtual;
    destructor Destroy;override;
    function ErrorPosition:TPoint;
    procedure ParseSQL(SQLParser:TSQLParser);
    procedure Assign(ASource:TSQLObjectAbstract); override;

    function AddSQLTokens(AToken:TSQLToken; const Parent:TSQLTokenRecord; const SQLCommand:string; AOptions:TSQLTokenOptions; ATag:integer = 0; ADBObjectKind:TDBObjectKind = okOther; ACaption:string = ''):TSQLTokenRecord;
    function AddSQLTokens(AToken:TSQLToken; const Parents:array of TSQLTokenRecord; const ASQLCommand:string; AOptions:TSQLTokenOptions; ATag:integer = 0; ADBObjectKind:TDBObjectKind = okOther; ACaption:string = ''):TSQLTokenRecord;overload;
    function SQLToken:TSQLToken;
    procedure Clear;override;


    property PlanEnabled:boolean read FPlanEnabled write FPlanEnabled;
    property Params:TSQLFields read GetParams;
    property ParamsCount:integer read GetParamsCount;

    property State:TCMDState read FState write SetState;
    property ErrorMessage:string read FErrorMessage;
    property ErrorPos:TParserPosition read FErrorPos;
    property SQLTokensList:TSQLTokenList read FSQLTokensList;
    property Parent:TSQLCommandAbstract read FParent;
  end;

  { TSQLCommandDDL }

  TSQLCommandDDL = class(TSQLCommandAbstract)
  private
    FFields: TSQLFields;
    FTables:TSQLTables;
    FDescription: string;
    FOptions: TSQLObjectOptions;
    FSchemaName: string;
    FTableName: string;
    procedure SetDescription(AValue: string);
  protected
    FObjectKind:TDBObjectKind;
    FSQLCommentOnClass:TSQLCommentOnClass;
    procedure DescribeObjectEx(AObjectKind:TDBObjectKind; AName, ATableName:string; ADescription:string);
    procedure DescribeObject;
    function GetFullName: string; override;
    property SchemaName:string read FSchemaName write FSchemaName;
    property TableName:string read FTableName write FTableName;
    procedure SetName(AValue: string); override;
  public
    constructor Create(AParent:TSQLCommandAbstract); override;
    destructor Destroy;override;
    procedure Clear;override;
    function CompareWith(SQLCommandDDL:TSQLCommandDDL):TSQLCommandDDL; virtual;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property Fields:TSQLFields read FFields;
    property Description:string read FDescription write SetDescription;
    property ObjectKind:TDBObjectKind read FObjectKind write FObjectKind;
    property Options:TSQLObjectOptions read FOptions write FOptions;
    property Tables:TSQLTables read FTables;
  end;

  TSQLCommandAbstractSelect = class;

  { TSQLDropCommandAbstract }

  TSQLDropCommandAbstract = class(TSQLCommandDDL)
  private
    FDropRule: TDropRule;
  protected
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    procedure Clear;override;
    property DropRule:TDropRule read FDropRule write FDropRule;
    property SchemaName;
  end;
  TSQLDropCommandAbstractClass = class of TSQLDropCommandAbstract;

  { TSQLCreateCommandAbstract }

  TSQLCreateCommandAbstract = class(TSQLCommandDDL)
  private
    FCreateMode: TCreateMode;
  protected
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract); override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property CreateMode:TCreateMode read FCreateMode write FCreateMode;
  end;


  { TSQLCreateSchema }

  TSQLCreateSchema = class(TSQLCreateCommandAbstract)
  private
    FChildCmd: string;
    FOwnerUserName: string;
  protected
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract); override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property OwnerUserName:string read FOwnerUserName write FOwnerUserName;
    property ChildCmd:string read FChildCmd write FChildCmd;
  end;

  { TSQLAlterSchema }

  TSQLAlterSchema = class(TSQLCommandDDL)
  private
    FOldDescription: string;
    FSchemaNewName: string;
    FSchemaNewOwner: string;
  protected
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property SchemaNewName:string read FSchemaNewName write FSchemaNewName;
    property SchemaNewOwner:string read FSchemaNewOwner write FSchemaNewOwner;
    property OldDescription:string read FOldDescription write FOldDescription;
  end;

  TTriggerState = (trsNone, trsActive, trsInactive);

  { TSQLCreateTrigger }

  TSQLCreateTrigger = class(TSQLCreateCommandAbstract)
  private
    FTriggerState: TTriggerState;
    FTriggerType: TTriggerTypes;
    FBody: string;
  protected
    procedure SetBody(AValue: string); virtual;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property Body:string read FBody write SetBody;
    property TriggerType:TTriggerTypes read FTriggerType write FTriggerType;
    property TriggerState:TTriggerState read FTriggerState write FTriggerState;
  end;

  { TSQLAlterTrigger }

  TSQLAlterTrigger = class(TSQLCommandDDL)
  private
    FTriggerState: TTriggerState;
    FTriggerType: TTriggerTypes;
  protected
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property TriggerType:TTriggerTypes read FTriggerType write FTriggerType;
    property TriggerState:TTriggerState read FTriggerState write FTriggerState;
  end;

  TSQLDropTrigger = class(TSQLDropCommandAbstract)
  public
    property TableName;
  end;

  { TSQLCreateDatabase }

  TSQLCreateDatabase = class(TSQLCreateCommandAbstract)
  private
    FPassword: string;
    FRoleName: string;
    FUserName: string;
  protected
    property UserName:string read FUserName write FUserName;
    property RoleName:string read FRoleName write FRoleName;
    property Password:string read FPassword write FPassword;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property DatabaseName:string read FName write FName;
  end;

  { TSQLCreateDomain }

  TSQLCreateDomain = class(TSQLCreateCommandAbstract)
  private
    FCharSetName: string;
    FCheckExpression: string;
    FCollationName: string;
    FConstraintName: string;
    FDefaultValue: string;
    FDomainType: string;
    FIsNull: boolean;
    FNotNull: boolean;
    FTypeLen: integer;
    FTypePrec: integer;
  protected
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract);override;
    property DomainType:string read FDomainType write FDomainType;
    property TypeLen:integer read FTypeLen write FTypeLen;
    property TypePrec:integer read FTypePrec write FTypePrec;
    property NotNull:boolean read FNotNull write FNotNull;
    property CharSetName:string read FCharSetName write FCharSetName;
    property CollationName:string read FCollationName write FCollationName;
    property CheckExpression:string read FCheckExpression write FCheckExpression;
    property ConstraintName:string read FConstraintName write FConstraintName;
    property DefaultValue:string read FDefaultValue write FDefaultValue;
    property IsNull:boolean read FIsNull write FIsNull;
  end;

  { TSQLAlterDomain }

  TSQLAlterDomain = class(TSQLCommandDDL)
  private
    FOperators: TAlterDomainOperators;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    destructor Destroy;override;
    procedure Assign(ASource:TSQLObjectAbstract);override;
    function AddOperator(AlterAction: TAlterDomainAction): TAlterDomainOperator;
    property Operators:TAlterDomainOperators read FOperators;
  end;

  { TAutoIncObject }

  { TODO : Необходимо реализовать коллекцию автоинкрементов }
  TAutoIncObject = class
  private
    FOwnerTable: TSQLCreateTable;
    FSequenceName: string;
    FTriggerBody: string;
    FTriggerDesc: string;
    FTriggerName: string;
  public
    constructor Create(AOwnerTable:TSQLCreateTable);
    destructor Destroy;override;
    procedure MakeObjects;virtual;
    procedure Clear;
    procedure Assign(Source:TAutoIncObject); virtual;
    property SequenceName:string read FSequenceName write FSequenceName;
    property TriggerName:string read FTriggerName write FTriggerName;
    property TriggerBody:string read FTriggerBody write FTriggerBody;
    property TriggerDesc:string read FTriggerDesc write FTriggerDesc;
    property OwnerTable:TSQLCreateTable read FOwnerTable;
  end;

  { TAutoIncObjects }

  TAutoIncObjectsEnumerator = class;
  TAutoIncObjects = class
  private
    FList:TFPList;
    FParent: TSQLCreateTable;
    function GetCount: integer;
    function GetItems(AIndex: Integer): TAutoIncObject;
    procedure Add(AAutoIncObject:TAutoIncObject);
    procedure Remove(AAutoIncObject:TAutoIncObject);
  public
    constructor Create(AParent:TSQLCreateTable);
    destructor Destroy; override;
    procedure Assign(ASource:TAutoIncObjects);
    procedure Clear;
    property Count:integer read GetCount;
    property Items[AIndex:Integer]:TAutoIncObject read GetItems; default;
    function GetEnumerator: TAutoIncObjectsEnumerator;
  end;

  { TAutoIncObjectsEnumerator }

  TAutoIncObjectsEnumerator = class
  private
    FList: TAutoIncObjects;
    FPosition: Integer;
  public
    constructor Create(AList: TAutoIncObjects);
    function GetCurrent: TAutoIncObject;
    function MoveNext: Boolean;
    property Current: TAutoIncObject read GetCurrent;
  end;

  { TSQLCreateTable }

  TSQLCreateTable = class(TSQLCreateCommandAbstract)
  private
    FSQLConstraints: TSQLConstraints;
    FAutoIncObjects:TAutoIncObjects;
  protected
  public
    constructor Create(AParent:TSQLCommandAbstract); override;
    destructor Destroy; override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property SQLConstraints:TSQLConstraints read FSQLConstraints;
    function GetAutoIncObject:TAutoIncObject; virtual;
  end;

  { TSQLAlterTable }

  TSQLAlterTable = class(TSQLCommandDDL)
  private
    FCreateMode: TCreateMode;
    function GetCountOperators: integer;
  protected
    FOperators:TAlterTableOperators;
  public
    constructor Create(AParent:TSQLCommandAbstract); override;
    destructor Destroy; override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    function AddOperator(AlterAction: TAlterTableAction): TAlterTableOperator;
    procedure ClearOperators;
    property CreateMode:TCreateMode read FCreateMode write FCreateMode;
    property CountOperators:integer read GetCountOperators;
    property Operators:TAlterTableOperators read FOperators;
  end;

  { TSQLCreateView }

  TSQLCreateView = class(TSQLCreateCommandAbstract)
  private
    FSQLSelect: string;
  protected
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property SQLSelect:string read FSQLSelect write FSQLSelect;
  end;

  { TSQLCreateSequence }

  TSQLCreateSequence = class(TSQLCreateCommandAbstract)
  private
    FCurrentValue: Int64;
    FIncrementBy: Int64;
    FMaxValue: Int64;
    FMinValue: Int64;
  protected
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property IncrementBy:Int64 read FIncrementBy write FIncrementBy;
    property CurrentValue:Int64 read FCurrentValue write FCurrentValue;
    property MinValue:Int64 read FMinValue write FMinValue;
    property MaxValue:Int64 read FMaxValue write FMaxValue;
  end;

  { TSQLAlterSequence }

  TAlterSequenceCommand = (ascAlter, ascMinValue, ascMaxValue, ascSetStart, ascRestart,
    ascOwnedBy, ascRename, ascOwnerTo, ascSetSchema);
  TSQLAlterSequence = class(TSQLCreateCommandAbstract)
  protected
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
  end;

  { TSQLCommandCreateUDF }

  TSQLCommandCreateUDF = class(TSQLCommandDDL)
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
  end;

  { TSQLCommandCreateProcedure }

  TSQLCommandCreateProcedure = class(TSQLCreateCommandAbstract)
  private
    FBody: string;
  protected
    procedure SetBody(AValue: string); virtual;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    destructor Destroy;override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property Body:string read FBody write SetBody;
  end;

  { TSQLCreateIndex }

  TSQLCreateIndex = class(TSQLCreateCommandAbstract)
  private
    FUnique: boolean;
  protected
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property TableName;
    property Unique:boolean read FUnique write FUnique;
  end;

  { TSQLStartTransaction }

  TSQLStartTransaction = class(TSQLCommandDDL)
  private
    FIsolationLevel: TTransactionIsolationLevel;
    FTransactionParam: TTransactionParams;
  protected
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property TransactionParam:TTransactionParams read FTransactionParam write FTransactionParam;
    property IsolationLevel:TTransactionIsolationLevel read FIsolationLevel write FIsolationLevel;
  end;

  TSQLCommit = class(TSQLCommandDDL)
  private
  protected
  public
  end;


  { TSQLRollback }

  TSQLRollback = class(TSQLCommandDDL)
  private
    FSavepointName: string;
  protected
  public
    property SavepointName:string read FSavepointName write FSavepointName;
    procedure Assign(ASource:TSQLObjectAbstract); override;
  end;

  { TSQLSavepoint }

  TSQLSavepoint = class(TSQLCommandDDL)
  private
  protected
  public
  end;

  { TSQLRelaseSavepoint }

  TSQLRelaseSavepoint = class(TSQLCommandDDL)
  private
  protected
  public
  end;

  { TSQLCreateLogin }

  TSQLCreateLogin = class(TSQLCreateCommandAbstract)
  private
    FPassword: string;
  protected
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property Password:string read FPassword write FPassword;
  end;

  { TSQLCommandSelectCTE }
  TCTEMaterializedFlag = (ctemfDefault, ctemfMaterialized, ctemfNotMaterialized);

  TSQLCommandSelectCTE = class
  private
    FFields: TSQLFields;
    FMaterializedFlag: TCTEMaterializedFlag;
    FName: string;
    FSQL: string;
  public
    constructor Create;
    destructor Destroy;override;
    procedure Assign(ASource:TSQLCommandSelectCTE);
    property Name:string read FName write FName;
    property Fields:TSQLFields read FFields;
    property SQL:string read FSQL write FSQL;
    property MaterializedFlag:TCTEMaterializedFlag read FMaterializedFlag write FMaterializedFlag;
  end;

  { TSQLCommandSelectCTEList }

  TSQLCommandSelectCTEList = class
  private
    FList:TFPList;
    FRecursive: Boolean;
    function GetCount: integer;
    function GetItem(AIndex: integer): TSQLCommandSelectCTE;
  public
    constructor Create;
    destructor Destroy;override;
    function Add(AName:string):TSQLCommandSelectCTE;
    procedure Clear;
    procedure Assign(ASource:TSQLCommandSelectCTEList);
    function GetEnumerator: TSQLCommandSelectCTEListEnumerator;
    function FindItem(AName:string):TSQLCommandSelectCTE;
    property Item[AIndex:integer]:TSQLCommandSelectCTE read GetItem; default;
    property Count:integer read GetCount;
    property Recursive:Boolean read FRecursive write FRecursive;
  end;

  { TSQLCommandSelectCTEListEnumerator }

  TSQLCommandSelectCTEListEnumerator = class
  private
    FList: TSQLCommandSelectCTEList;
    FPosition: Integer;
  public
    constructor Create(AList: TSQLCommandSelectCTEList);
    function GetCurrent: TSQLCommandSelectCTE;
    function MoveNext: Boolean;
    property Current: TSQLCommandSelectCTE read GetCurrent;
  end;

  { TSQLCommandAbstractSelect }

  TSQLCommandAbstractSelect = class(TSQLCommandAbstract)
  private
    FCTE: TSQLCommandSelectCTEList;
    FOrderByFields: TSQLFields;
    FTables:TSQLTables;
    FFields:TSQLFields;
  protected
    FSelectable: boolean;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    destructor Destroy;override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property Tables:TSQLTables read FTables;
    property Fields:TSQLFields read FFields;
    property Selectable:boolean read FSelectable;
    property OrderByFields:TSQLFields read FOrderByFields;
    property CTE:TSQLCommandSelectCTEList read FCTE;
  end;

  { TSQLCommandSelect }

  TSQLCommandSelect = class(TSQLCommandAbstractSelect)
  private
    FTokenFrom:TSQLTokenRecord;
    //
    FAllRec: boolean;
    FCurField: TSQLParserField;
    FCurTable: TTableItem;
    FParserState:TParserSelectState;
    FWhereExpression: string;
    FCurCTE: TSQLCommandSelectCTE;
    FCurOrderByField: TSQLParserField;
    procedure ParseJoinOn(ASQLParser: TSQLParser);
    procedure ParseFieldExp(ASQLParser: TSQLParser; AWord:string; AChild: TSQLTokenRecord);
  protected
    function InternalProcessError(ASQLParser: TSQLParser; var AChild: TSQLTokenRecord):boolean; override;

    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL; override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    destructor Destroy;override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property AllRec:boolean read FAllRec write FAllRec;
    property WhereExpression:string read FWhereExpression write FWhereExpression;
  end;

  { TSQLCommandDML }

  TSQLCommandDML =class(TSQLCommandAbstractSelect)
  private
    function GetSchemaName: string;
    function GetTableName: string;
    procedure SetSchemaName(AValue: string);
    procedure SetTableName(AValue: string);
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    property TableName:string read GetTableName write SetTableName;
    property SchemaName:string read GetSchemaName write SetSchemaName;
  end;

  { TSQLCommandUpdate }

  TSQLCommandUpdate = class(TSQLCommandDML)
  private
    FCurField: TSQLParserField;
    FWhereExpression: string;
    function GetUpdateExpression(ASQLParser:TSQLParser):string;
    function GetWhereExpression(ASQLParser:TSQLParser):string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    function AllowFieldAlias:boolean;virtual;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property WhereExpression:string read FWhereExpression write FWhereExpression;
  end;

  { TSQLCommandDelete }

  TSQLCommandDelete = class(TSQLCommandDML)
  private
    FWhereStr: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property WhereStr:string read FWhereStr write FWhereStr;
  end;

  { TSQLCommandInsert }
  TSQLInsertType = (sitValues, sitDefaultValues, sitSelect);

  TSQLCommandInsert = class(TSQLCommandDML)
  private
    FCurField: TSQLParserField;
    FInsertType: TSQLInsertType;
    FSelectCmd: TSQLCommandSelect;
    FCurParam: TSQLParserField;
  protected
    function GetParams: TSQLFields; override;

    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    destructor Destroy;override;
    procedure Assign(ASource:TSQLObjectAbstract); override;

    property SelectCmd:TSQLCommandSelect read FSelectCmd;
    property Fields:TSQLFields read FFields;
    property InsertType:TSQLInsertType read FInsertType write FInsertType;
  end;

  {  TSQLCommentOn  }

  TSQLCommentOn = class(TSQLCommandDDL)
  private
    FParentObjectKind: TDBObjectKind;
  protected
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property ParentObjectKind:TDBObjectKind read FParentObjectKind write FParentObjectKind;
  end;

  { TSQLCommandGrant }

  TSQLCommandGrant = class(TSQLCommandDDL)
  private
    FCascadeRule: TCascadeRule;
    FGrantTypes: TObjectGrants;
    FTableShortForm: boolean;
  protected
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    destructor Destroy;override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property GrantTypes:TObjectGrants read FGrantTypes write FGrantTypes;
    property CascadeRule:TCascadeRule read FCascadeRule write FCascadeRule;
    property TableShortForm:boolean read FTableShortForm write FTableShortForm;
  end;

  { TSQLTextStatement }

  TSQLTextStatement = class
  private
    FParser:TSQLParser;
    FPosEnd: TPoint;
    FPosStart: TPoint;
    FSQLCommand:TSQLCommandAbstract;
    FText: string;
    function GetSQLCommand: TSQLCommandAbstract;
  public
    constructor Create(AParser:TSQLParser);
    destructor Destroy;override;
    property SQLCommand: TSQLCommandAbstract read GetSQLCommand;
    property Text:string read FText;
    property PosStart:TPoint read FPosStart;
    property PosEnd:TPoint read FPosEnd;
  end;

  { TSQLParser }

  TSQLParser = class
  private
    FCommandDelemiter: string;
    FCurrentStringDelemiter: string;
    FIgnoreError: boolean;
    FOnProcessComment: TSQLProcessComment;
    FParserSintax: TSQLParserSintax;
    FOwner: TObject;
    FPosition: TParserPosition;
    FStatementList:TFPList;
    FSql:string;
    FWordPosition: TParserPosition;
    function GetStatement(Index: Integer): TSQLTextStatement;
    function GetStatementCount: Integer;
    procedure SkipComment1;
    procedure SkipComment2;
    procedure ClearStatementList;
    procedure DoTestLineEnd;
  public
    constructor Create(const ASql:string; const AOwner:TObject);
    destructor Destroy;override;
    procedure SetSQL(ASQL:string);
    function GetNextWord2:string;
    function GetNextWord1(AExcludeChar:TSysCharSet):string;
    property SQL:string read FSQL;
   public
    //global functions
    function Eof:boolean;
    class function WordType(Sender:TSQLTokenRecord; AWord:string; ACmd:TSQLCommandAbstract):TSQLToken;

    function GetNextWord:string;
    procedure SkipSpace;
    function WaitWord(AWord:string):boolean;
    function GetToWord(AWord:string):string;
    function GetToCommandDelemiter:string;
    function GetToBracket(Bracket:string):string;
    procedure InsertText(AText:string);
    procedure DeleteText(ATextLen:integer);

    function GetCommentForEOL:string;
    procedure IncPos( ACountChar:Integer = 1);


    property CurrentStringDelemiter:string read FCurrentStringDelemiter;
    property Position:TParserPosition read FPosition write FPosition;
    property WordPosition:TParserPosition read FWordPosition write FWordPosition;
    property Owner:TObject read FOwner write FOwner;
    property CommandDelemiter:string read FCommandDelemiter write FCommandDelemiter;
  public
    //script functions
    procedure ParseScript(AFromBegin:boolean = true);
    function StatementAtXY(X, Y:integer): TSQLTextStatement;
    property StatementCount: Integer read GetStatementCount;
    property Statements[Index: Integer]: TSQLTextStatement read GetStatement;
    property OnProcessComment : TSQLProcessComment read FOnProcessComment write FOnProcessComment;
    property ParserSintax:TSQLParserSintax read FParserSintax write FParserSintax;
    property IgnoreError:boolean read FIgnoreError write FIgnoreError;
  end;

function GetNextSQLCommand(const Sql:string; const AOwner:TObject; const AIgnoreError:boolean = false):TSQLCommandAbstract;
function GetToEndpSQL(ASQLParser:TSQLParser):string;

{ TODO : Необходимо реализовать передачу в парсер списка доспустимых команд - разборщиков }
function SQLParseCommand(const Sql:string; SQLParserClass:TSQLCommandAbstractClass; const AOwner:TObject):TSQLCommandAbstract;


function SQLStatamentAtXY(const ALines:TStrings; X, Y:Integer):string;

procedure RegisterSQLStatment(ASQLEngineClass:TClass; ACmd:TSQLCommandAbstractClass; ASignature:string);
function FindSQLStatment(ASQLEngineClass:TClass; ACmd:TSQLCommandAbstractClass):TSQLCommandAbstractClass;

type

  { TSQLStatmentRecord }

  TSQLStatmentRecord = class(TObject)
  private
    FItem:TSQLCommandAbstract;
  public
    SQLEngineClass:TClass;
    Cmd:TSQLCommandAbstractClass;
    Signature:string;
    destructor Destroy; override;
    property Item:TSQLCommandAbstract read FItem;
  end;

  { TSQLStatmentRecords }

  TSQLStatmentRecords = class(TFPList)
  private
    function GetItems(AIndex: integer): TSQLStatmentRecord;
  public
    destructor Destroy; override;
    function GetEnumerator: TSQLStatmentRecordEnumerator;
    property Items[AIndex:integer]:TSQLStatmentRecord read GetItems; default;
  end;

  { TSQLStatmentRecordEnumerator }

  TSQLStatmentRecordEnumerator = class
  private
    FList: TSQLStatmentRecords;
    FPosition: Integer;
  public
    constructor Create(AList: TSQLStatmentRecords);
    function GetCurrent: TSQLStatmentRecord;
    function MoveNext: Boolean;
    property Current: TSQLStatmentRecord read GetCurrent;
  end;

var
  SQLStatmentRecordArray : TSQLStatmentRecords = nil;
  SQLValidChars : set of char = ['a'..'z','A'..'Z','0'..'9', '_', '$'];

implementation
uses StrUtils, rxstrutils, sqlParserConsts, fbmStrConstUnit, LazUTF8, typinfo, SQLEngineInternalToolsUnit;



function GetNextSQLCommand(const Sql: string; const AOwner:TObject; const AIgnoreError:boolean = false): TSQLCommandAbstract;
var
  SQLParser:TSQLParser;

  function GetNextSQLCommand1: TSQLCommandAbstract;
  var
    i: Integer;
    SavePos: TParserPosition;
  begin
    Result:=nil;
    SavePos:=SQLParser.Position;
    for i:=0 to SQLStatmentRecordArray.Count-1 do
    begin
      SQLParser.Position:=SavePos;
      if ((not Assigned(AOwner)) or (AOwner.ClassType = SQLStatmentRecordArray.Items[i].SQLEngineClass))
        and SQLStatmentRecordArray.Items[i].FItem.CheckCommand(SQLParser) then
      begin
        Result:=SQLStatmentRecordArray.Items[i].Cmd.Create(SQLStatmentRecordArray.Items[i].Item);
        SQLParser.Position:=SavePos;
        Result.ParseSql(SQLParser);
        exit;
      end;
    end;
  end;

begin
  SQLParser:=TSQLParser.Create(Sql, AOwner);
  SQLParser.IgnoreError:=AIgnoreError;
  try
    Result:=GetNextSQLCommand1;
  finally
    SQLParser.Free;
  end;
end;

function GetToEndpSQL(ASQLParser: TSQLParser): string;
var
  FStartPos, FCntBeg: Integer;
  FStop: Boolean;
  S: String;
begin
  Result:='';
  FStartPos:=ASQLParser.Position.Position;
  FStop:=false;
  FCntBeg:=0;
  while not (ASQLParser.Eof or FStop) do
  begin
    S:=UpperCase(ASQLParser.GetNextWord);

    if (S = 'END') then
    begin
      Dec(FCntBeg);
      if FCntBeg = 0 then
        FStop:=true
    end
    else
    if S = 'BEGIN' then
      Inc(FCntBeg)
    else
    if S = '(' then
      ASQLParser.GetToBracket(')')
  end;
  Result:=Copy(ASQLParser.SQL, FStartPos, ASQLParser.Position.Position - FStartPos);
end;

function SQLParseCommand(const Sql: string;
  SQLParserClass: TSQLCommandAbstractClass; const AOwner: TObject
  ): TSQLCommandAbstract;
var
  SQLParser:TSQLParser;
begin
  if Sql = '' then
    Result:=nil
  else
  begin
    Result:=SQLParserClass.Create(nil);
    SQLParser:=TSQLParser.Create(Sql, AOwner);
    try
      Result.ParseSQL(SQLParser);
    finally
      SQLParser.Free;
    end;
  end;
end;

function SQLStatamentAtXY(const ALines: TStrings; X, Y: Integer): string;
var
  S: String;
  i, L: Integer;
  PriorPos:TPoint;
  P: TSQLTextStatement;
begin
end;

procedure RegisterSQLStatment(ASQLEngineClass: TClass;
  ACmd: TSQLCommandAbstractClass; ASignature: string);
var
  Item: TSQLStatmentRecord;
begin
  Item:=TSQLStatmentRecord.Create;
  SQLStatmentRecordArray.Add(Item);
  Item.Cmd:=ACmd;
  Item.Signature:=ReplaceStr(ASignature, ' ',  '_');
  Item.SQLEngineClass:=ASQLEngineClass;
  Item.FItem:=ACmd.Create(nil);
end;

function FindSQLStatment(ASQLEngineClass: TClass; ACmd: TSQLCommandAbstractClass
  ): TSQLCommandAbstractClass;
var
  P: TSQLStatmentRecord;
begin
  Result:=nil;
  for P in SQLStatmentRecordArray do
    if P.SQLEngineClass = ASQLEngineClass then
      if P.FItem is ACmd then
        Result:=P.Cmd;
end;

{ TSQLCreateLogin }

procedure TSQLCreateLogin.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLCreateLogin then
  begin
    Password:=TSQLCreateLogin(ASource).Password;
  end;
  inherited Assign(ASource);
end;

{ TSQLAlterSchema }

procedure TSQLAlterSchema.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

constructor TSQLAlterSchema.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
end;

procedure TSQLAlterSchema.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLAlterSchema then
  begin
    SchemaNewName:=TSQLAlterSchema(ASource).SchemaNewName;
    SchemaNewOwner:=TSQLAlterSchema(ASource).SchemaNewOwner;
    OldDescription:=TSQLAlterSchema(ASource).OldDescription;
  end;
  inherited Assign(ASource);
end;

{ TSQLCreateSchema }

procedure TSQLCreateSchema.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

constructor TSQLCreateSchema.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
end;

procedure TSQLCreateSchema.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLCreateSchema then
  begin
    OwnerUserName:=TSQLCreateSchema(ASource).OwnerUserName;
    ChildCmd:=TSQLCreateSchema(ASource).ChildCmd;
  end;
  inherited Assign(ASource);
end;

{ TSQLCommentOn }

procedure TSQLCommentOn.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLCommentOn then
  begin
    FParentObjectKind:=TSQLCommentOn(ASource).ParentObjectKind;
  end;
  inherited Assign(ASource);
end;

{ TSQLAlterTrigger }

procedure TSQLAlterTrigger.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLAlterTrigger then
  begin
    FTriggerType:=TSQLAlterTrigger(ASource).FTriggerType;
    FTriggerState:=TSQLAlterTrigger(ASource).FTriggerState;
    //FBody:=TSQLCreateTrigger(ASource).FBody;
  end;
  inherited Assign(ASource);
end;

{ TSQLAlterSequence }

constructor TSQLAlterSequence.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
end;

procedure TSQLAlterSequence.Assign(ASource: TSQLObjectAbstract);
begin
  inherited Assign(ASource);
end;

{ TSQLCreateTrigger }

procedure TSQLCreateTrigger.SetBody(AValue: string);
begin
  if FBody = AValue then Exit;
  FBody:=AValue;
end;

procedure TSQLCreateTrigger.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    -4:TriggerState:=trsActive;
    -5:TriggerState:=trsInactive;
  end;
end;

procedure TSQLCreateTrigger.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLCreateTrigger then
  begin
    FTriggerType:=TSQLCreateTrigger(ASource).FTriggerType;
    FTriggerState:=TSQLCreateTrigger(ASource).FTriggerState;
    FBody:=TSQLCreateTrigger(ASource).FBody;
  end;
  inherited Assign(ASource);
end;

{ TSQLRollback }

procedure TSQLRollback.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLRollback then
  begin
    FSavepointName:=TSQLRollback(ASource).FSavepointName;
  end;
  inherited Assign(ASource);
end;

{ TSQLStatmentRecordEnumerator }

constructor TSQLStatmentRecordEnumerator.Create(AList: TSQLStatmentRecords);
begin
  FList := AList;
  FPosition := -1;
end;

function TSQLStatmentRecordEnumerator.GetCurrent: TSQLStatmentRecord;
begin
  Result := FList[FPosition];
end;

function TSQLStatmentRecordEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TSQLCommandSelectCTEListEnumerator }

constructor TSQLCommandSelectCTEListEnumerator.Create(
  AList: TSQLCommandSelectCTEList);
begin
  FList := AList;
  FPosition := -1;
end;

function TSQLCommandSelectCTEListEnumerator.GetCurrent: TSQLCommandSelectCTE;
begin
  Result := FList[FPosition];
end;

function TSQLCommandSelectCTEListEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TSQLCommandSelectCTE }

constructor TSQLCommandSelectCTE.Create;
begin
  inherited Create;
  FFields:=TSQLFields.Create;
end;

destructor TSQLCommandSelectCTE.Destroy;
begin
  FreeAndNil(FFields);
  inherited Destroy;
end;

procedure TSQLCommandSelectCTE.Assign(ASource: TSQLCommandSelectCTE);
begin
  if not Assigned(ASource) then Exit;
  FName:=ASource.FName;
  FFields.Assign(ASource.FFields);
  FSQL:=ASource.FSQL;
  FMaterializedFlag:=ASource.FMaterializedFlag;
end;

{ TSQLCommandSelectCTEList }

function TSQLCommandSelectCTEList.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TSQLCommandSelectCTEList.GetItem(AIndex: integer
  ): TSQLCommandSelectCTE;
begin
  Result:=TSQLCommandSelectCTE(FList[AIndex]);
end;

constructor TSQLCommandSelectCTEList.Create;
begin
  inherited Create;
  FList:=TFPList.Create;
end;

destructor TSQLCommandSelectCTEList.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

function TSQLCommandSelectCTEList.Add(AName: string): TSQLCommandSelectCTE;
begin
  Result:=TSQLCommandSelectCTE.Create;
  FList.Add(Result);
  Result.Name:=AName;
end;

procedure TSQLCommandSelectCTEList.Clear;
var
  i: Integer;
begin
  for i:=0 to FList.Count-1 do
    TSQLCommandSelectCTE(FList[i]).Free;
  FList.Clear;
end;

procedure TSQLCommandSelectCTEList.Assign(ASource: TSQLCommandSelectCTEList);
var
  P: TSQLCommandSelectCTE;
begin
  Clear;
  if not Assigned(ASource) then Exit;
  FRecursive:=ASource.FRecursive;
  for P in ASource do
    Add(P.Name).Assign(P);
end;

function TSQLCommandSelectCTEList.GetEnumerator: TSQLCommandSelectCTEListEnumerator;
begin
  Result:=TSQLCommandSelectCTEListEnumerator.Create(Self);
end;

function TSQLCommandSelectCTEList.FindItem(AName: string): TSQLCommandSelectCTE;
var
  I: Integer;
begin
  Result:=nil;
  AName:=UpperCase(AName);
  for I:=0 to FList.Count-1 do
    if UpperCase(TSQLCommandSelectCTE(FList[I]).FName) = AName then
      Exit(TSQLCommandSelectCTE(FList[I]));
end;

{ TSQLCreateCommandAbstract }

procedure TSQLCreateCommandAbstract.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  //-1 - if not exists
  //-2 - Or Replase
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    -1:Options:=Options + [ooIfNotExists];
    -2:Options:=Options + [ooOrReplase];
  end;
end;

constructor TSQLCreateCommandAbstract.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FCreateMode:=cmCreate;
end;

procedure TSQLCreateCommandAbstract.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLCreateCommandAbstract then
  begin
    CreateMode:=TSQLCreateCommandAbstract(ASource).CreateMode;
  end;
  inherited Assign(ASource);
end;

{ TSQLCreateDatabase }

procedure TSQLCreateDatabase.Assign(ASource: TSQLObjectAbstract);
begin
  inherited Assign(ASource);
  if ASource is TSQLCreateDatabase then
  begin
    UserName:=TSQLCreateDatabase(ASource).UserName;
    RoleName:=TSQLCreateDatabase(ASource).RoleName;
    Password:=TSQLCreateDatabase(ASource).Password;
  end;
end;

{ TSQLStartTransaction }

procedure TSQLStartTransaction.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLStartTransaction then
  begin
    TransactionParam:=TSQLStartTransaction(ASource).TransactionParam;
    IsolationLevel:=TSQLStartTransaction(ASource).IsolationLevel;
  end;
  inherited Assign(ASource);
end;

{ TAutoIncObjectsEnumerator }

constructor TAutoIncObjectsEnumerator.Create(AList: TAutoIncObjects);
begin
  FList := AList;
  FPosition := -1;
end;

function TAutoIncObjectsEnumerator.GetCurrent: TAutoIncObject;
begin
  Result := FList[FPosition];
end;

function TAutoIncObjectsEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TAutoIncObjects }

function TAutoIncObjects.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TAutoIncObjects.GetItems(AIndex: Integer): TAutoIncObject;
begin
  Result:=TAutoIncObject(FList[AIndex]);
end;

procedure TAutoIncObjects.Add(AAutoIncObject: TAutoIncObject);
begin
  if Assigned(AAutoIncObject) then
    FList.Add(AAutoIncObject);
end;

procedure TAutoIncObjects.Remove(AAutoIncObject: TAutoIncObject);
begin
  if Assigned(AAutoIncObject) then
    FList.Remove(AAutoIncObject);
end;

constructor TAutoIncObjects.Create(AParent: TSQLCreateTable);
begin
  inherited Create;
  FParent:=AParent;
  FList:=TFPList.Create;
end;

destructor TAutoIncObjects.Destroy;
begin
  Clear;
  if Assigned(FList) then
    FreeAndNil(FList);
  inherited Destroy;
end;

procedure TAutoIncObjects.Assign(ASource: TAutoIncObjects);
var
  AO, AO1: TAutoIncObject;
begin
  if not Assigned(ASource) then Exit;
  for AO in ASource do
  begin
    AO1:=FParent.GetAutoIncObject;
    AO1.Assign(AO);
  end;
end;

procedure TAutoIncObjects.Clear;
var
  i: Integer;
begin
  for i:=0 to FList.Count - 1 do
    TAutoIncObject(FList[i]).Free;
  FList.Clear;
end;

function TAutoIncObjects.GetEnumerator: TAutoIncObjectsEnumerator;
begin
  Result:=TAutoIncObjectsEnumerator.Create(Self);
end;


{ TSQLAlterDomain }

constructor TSQLAlterDomain.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FOperators:=TAlterDomainOperators.Create;
end;

destructor TSQLAlterDomain.Destroy;
begin
  FreeAndNil(FOperators);
  inherited Destroy;
end;

procedure TSQLAlterDomain.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLAlterDomain then
  begin
    Operators.Assign(TSQLAlterDomain(ASource).Operators);
  end;
  inherited Assign(ASource);
end;

function TSQLAlterDomain.AddOperator(AlterAction: TAlterDomainAction
  ): TAlterDomainOperator;
begin
  Result:=FOperators.AddItem(AlterAction);
end;

{ TAutoIncObject }

constructor TAutoIncObject.Create(AOwnerTable: TSQLCreateTable);
begin
  inherited Create;
  FOwnerTable:=AOwnerTable;
  if Assigned(FOwnerTable) then
    FOwnerTable.FAutoIncObjects.Add(Self);
end;

destructor TAutoIncObject.Destroy;
begin
  if Assigned(FOwnerTable) and Assigned(FOwnerTable.FAutoIncObjects) then
    FOwnerTable.FAutoIncObjects.Remove(Self);
  inherited Destroy;
end;

procedure TAutoIncObject.MakeObjects;
begin
  //
end;

procedure TAutoIncObject.Clear;
begin
  FSequenceName:='';
  FTriggerBody:='';
  FTriggerName:='';
end;

procedure TAutoIncObject.Assign(Source: TAutoIncObject);
begin
  if not Assigned(Source) then Exit;
  SequenceName:=Source.SequenceName;
  TriggerName:=Source.TriggerName;
  TriggerBody:=Source.TriggerBody;
  TriggerDesc:=Source.TriggerDesc;
end;

{ TSQLCommandGrant }

constructor TSQLCommandGrant.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FTableShortForm:=true;
end;

destructor TSQLCommandGrant.Destroy;
begin
  inherited Destroy;
end;

procedure TSQLCommandGrant.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLCommandGrant then
  begin
    GrantTypes:=TSQLCommandGrant(ASource).GrantTypes;
    CascadeRule:=TSQLCommandGrant(ASource).CascadeRule;
    TableShortForm:=TSQLCommandGrant(ASource).TableShortForm
  end;
  inherited Assign(ASource);
end;

{ TSQLCreateIndex }

constructor TSQLCreateIndex.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FObjectKind:=okIndex;
end;

procedure TSQLCreateIndex.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLCreateIndex then
  begin
    Unique:=TSQLCreateIndex(ASource).Unique;
  end;
  inherited Assign(ASource);
end;

{ TSQLCommandCreateUDF }

constructor TSQLCommandCreateUDF.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FObjectKind:=okUDF;
end;

{ TSQLCreateDomain }

constructor TSQLCreateDomain.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FObjectKind:=okDomain;
end;

procedure TSQLCreateDomain.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLCreateDomain then
  begin
    DomainType:=TSQLCreateDomain(ASource).DomainType;
    TypeLen:=TSQLCreateDomain(ASource).TypeLen;
    TypePrec:=TSQLCreateDomain(ASource).TypePrec;
    NotNull:=TSQLCreateDomain(ASource).NotNull;
    CharSetName:=TSQLCreateDomain(ASource).CharSetName;
    CollationName:=TSQLCreateDomain(ASource).CollationName;
    CheckExpression:=TSQLCreateDomain(ASource).CheckExpression;
    ConstraintName:=TSQLCreateDomain(ASource).ConstraintName;
    DefaultValue:=TSQLCreateDomain(ASource).DefaultValue;
    IsNull:=TSQLCreateDomain(ASource).IsNull;
  end;
  inherited Assign(ASource);
end;

{ TSQLTokenListEnumerator }

constructor TSQLTokenListEnumerator.Create(AList: TSQLTokenList);
begin
  FList := AList;
  FPosition := -1;
end;

function TSQLTokenListEnumerator.GetCurrent: TSQLTokenRecord;
begin
  Result := FList[FPosition];
end;

function TSQLTokenListEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TSQLTokenList }

function TSQLTokenList.GetItem(AIndex: integer): TSQLTokenRecord;
begin
  Result:=TSQLTokenRecord(FList[AIndex]);
end;

function TSQLTokenList.GetCount: integer;
begin
  Result:=FList.Count;
end;

procedure TSQLTokenList.Add(AItem: TSQLTokenRecord);
begin
  FList.Add(AItem);
end;

function TSQLTokenList.IndexOf(AItem: TSQLTokenRecord): integer;
begin
  Result:=FList.IndexOf(AItem);
end;

procedure TSQLTokenList.Clear;
var
  I: Integer;
begin
  for I:=0 to FList.Count - 1 do
    TSQLTokenRecord(FList[i]).Free;
  FList.Clear;
end;

constructor TSQLTokenList.Create;
begin
  inherited Create;
  FList:=TFPList.Create;
end;

destructor TSQLTokenList.Destroy;
begin
  FreeAndNil(FList);
  inherited Destroy;
end;

function TSQLTokenList.GetEnumerator: TSQLTokenListEnumerator;
begin
  Result := TSQLTokenListEnumerator.Create(Self);
end;

{ TSQLDropCommandAbstract }

procedure TSQLDropCommandAbstract.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  { В дереве разбора значения общих тегов:}
  { [ IF EXISTS ] = -1                    }
  {   [ CASCADE | = -2                    }
  {    RESTRICT ] = -3                    }

  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    -1:Options:=Options + [ooIfExists];
    -2:FDropRule:=drCascade;
    -3:FDropRule:=drRestrict;
  end;
end;

procedure TSQLDropCommandAbstract.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLDropCommandAbstract then
  begin
    DropRule:=TSQLDropCommandAbstract(ASource).DropRule;
  end;
  inherited Assign(ASource);
end;

procedure TSQLDropCommandAbstract.Clear;
begin
  inherited Clear;
  FDropRule:=drNone;
end;

{ TSQLCreateView }

constructor TSQLCreateView.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FObjectKind:=okView;
end;

procedure TSQLCreateView.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLCreateView then
  begin
    SQLSelect:=TSQLCreateView(ASource).SQLSelect;
  end;
  inherited Assign(ASource);
end;

{ TSQLCreateSequence }

constructor TSQLCreateSequence.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FObjectKind:=okSequence;
  FGenBeforeMainObj:=true;
end;

procedure TSQLCreateSequence.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLCreateSequence then
  begin
    IncrementBy:=TSQLCreateSequence(ASource).IncrementBy;
    CurrentValue:=TSQLCreateSequence(ASource).CurrentValue;
    MinValue:=TSQLCreateSequence(ASource).MinValue;
    MaxValue:=TSQLCreateSequence(ASource).MaxValue;
  end;
  inherited Assign(ASource);
end;

{ TSQLCreateTable }

constructor TSQLCreateTable.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FObjectKind:=okTable;
  FSQLConstraints:=TSQLConstraints.Create;
  FAutoIncObjects:=TAutoIncObjects.Create(Self);
end;

destructor TSQLCreateTable.Destroy;
begin
  if Assigned(FSQLConstraints) then
    FreeAndNil(FSQLConstraints);
  if Assigned(FAutoIncObjects) then
    FreeAndNil(FAutoIncObjects);
  inherited Destroy;
end;

procedure TSQLCreateTable.Assign(ASource: TSQLObjectAbstract);
begin
  inherited Assign(ASource);
  if ASource is TSQLCreateTable then
  begin
    SQLConstraints.CopyFrom(TSQLCreateTable(ASource).SQLConstraints);
    FAutoIncObjects.Assign(TSQLCreateTable(ASource).FAutoIncObjects);
  end;
end;

function TSQLCreateTable.GetAutoIncObject: TAutoIncObject;
begin
  Result:=nil;
end;

{ TSQLAlterTable }

function TSQLAlterTable.AddOperator(AlterAction:TAlterTableAction): TAlterTableOperator;
begin
  Result:=FOperators.AddItem(AlterAction);
end;

procedure TSQLAlterTable.ClearOperators;
begin
  FOperators.Clear;
end;

function TSQLAlterTable.GetCountOperators: integer;
begin
  Result:=FOperators.Count;
end;

constructor TSQLAlterTable.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FOperators:=TAlterTableOperators.Create;
  FObjectKind:=okTable;
end;

destructor TSQLAlterTable.Destroy;
begin
  FreeAndNil(FOperators);
  inherited Destroy;
end;

procedure TSQLAlterTable.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLAlterTable then
  begin
    Operators.Assign(TSQLAlterTable(ASource).Operators);
    CreateMode:=TSQLAlterTable(ASource).CreateMode;
  end;
  inherited Assign(ASource);
end;

{ TSQLCommandCreateProcedure }
procedure TSQLCommandCreateProcedure.SetBody(AValue: string);
begin
  if FBody = AValue then exit;
  FBody:=AValue;
end;

constructor TSQLCommandCreateProcedure.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FObjectKind:=okStoredProc;
end;

destructor TSQLCommandCreateProcedure.Destroy;
begin
  inherited Destroy;
end;

procedure TSQLCommandCreateProcedure.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLCommandCreateProcedure then
  begin
    Body:=TSQLCommandCreateProcedure(ASource).Body;

  end;
  inherited Assign(ASource);
end;


{ TSQLCommandDDL }

procedure TSQLCommandDDL.SetDescription(AValue: string);
begin
  if FDescription = TrimRight(AValue) then Exit;
  FDescription:= TrimRight(AValue);
end;

procedure TSQLCommandDDL.DescribeObjectEx(AObjectKind: TDBObjectKind; AName,
  ATableName: string; ADescription: string);
var
  PC: TSQLCommentOn;
begin
  if Assigned(FSQLCommentOnClass) then
  begin
    PC:=FSQLCommentOnClass.Create(nil);
    PC.Name:=AName;
    PC.TableName:=ATableName;
    PC.ObjectKind:=AObjectKind;
    PC.Description:=ADescription;
    PC.Params.CopyFrom(Params);
    AddChild(PC);
  end
  else
    raise Exception.Create('Not assigned FSQLCommentOnClass');
end;

procedure TSQLCommandDDL.DescribeObject;
begin
  if FObjectKind = okNone then
    raise Exception.CreateFmt(sObjectKindNotDefined, [ClassName, FullName]);
  DescribeObjectEx(FObjectKind, FullName, TableName, Description);
end;

function TSQLCommandDDL.GetFullName: string;
begin
  if FSchemaName <> '' then
    Result:=DoFormatName(FSchemaName) +'.'+DoFormatName(Name)
  else
    Result:=DoFormatName(Name);
end;

procedure TSQLCommandDDL.SetName(AValue: string);
var
  I: SizeInt;
begin
  I:=Pos('.', AValue);
  if (I>0) then
    FSchemaName:=Copy2SymbDel(AValue, '.');
  inherited SetName(AValue);
end;

constructor TSQLCommandDDL.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FFields:=TSQLFields.Create;
  FTables:=TSQLTables.Create;
end;

destructor TSQLCommandDDL.Destroy;
begin
  FreeAndNil(FFields);
  FreeAndNil(FTables);
  inherited Destroy;
end;

procedure TSQLCommandDDL.Clear;
begin
  inherited Clear;
  FFields.Clear;
  FTables.Clear;
end;

function TSQLCommandDDL.CompareWith(SQLCommandDDL: TSQLCommandDDL
  ): TSQLCommandDDL;
begin
  Result:=nil;
  if Assigned(SQLCommandDDL) then
    raise Exception.CreateFmt('Unknow command: %s', [SQLCommandDDL.ClassName])
  else
    raise Exception.Create('Unknow command')
end;

procedure TSQLCommandDDL.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLCommandDDL then
  begin
    Name:=TSQLCreateTable(ASource).Name;
    Fields.CopyFrom(TSQLCreateTable(ASource).Fields);
    Description:=TSQLCreateTable(ASource).Description;
    ObjectKind:=TSQLCreateTable(ASource).ObjectKind;
    Options:=TSQLCreateTable(ASource).Options;
    Tables.Assign(TSQLCreateTable(ASource).Tables);
    FSchemaName:=TSQLCreateTable(ASource).FSchemaName;
    FTableName:=TSQLCreateTable(ASource).FTableName;
  end;
  Inherited Assign(ASource);
end;

{ TSQLDeclareLocalVarParser }

procedure TSQLDeclareLocalVarParser.SkipSpace;
begin
  while (FCurPos<=Length(FSqlLine)) and (FSqlLine[FCurPos] <= ' ') do Inc(FCurPos);
  FStop:=FCurPos > Length(FSqlLine);
end;

function TSQLDeclareLocalVarParser.GetWord: string;
var
  StartPos: Integer;
begin
  StartPos:=FCurPos;
  if FCurPos < Length(FSqlLine) then
  begin
    while (FCurPos<=Length(FSqlLine)) and ((FSqlLine[FCurPos] in ['0'..'9']) or (FSqlLine[FCurPos]>='A')) do Inc(FCurPos);
    Result:=Copy(FSqlLine, StartPos, CurPos - StartPos);
  end
  else
  begin
    Result:='';
    FStop:=true;
  end;
end;

function TSQLDeclareLocalVarParser.GetWordToSymb(Symb: string): string;
var
  i:integer;
begin
  if FCurPos < Length(FSqlLine) then
  begin
    i:=FCurPos;
    while (Copy(FSqlLine, FCurPos, Length(Symb)) <> Symb) and (FCurPos < Length(FSqlLine) - Length(Symb)) do Inc(FCurPos);
    if (Copy(FSqlLine, FCurPos, Length(Symb)) = Symb) then
    begin
      Result:=Trim(Copy(FSqlLine, i, FCurPos - i));
      Inc(FCurPos, Length(Symb));
    end
    else
    begin
      Result:='';
      FStop:=true;
    end;
  end
  else
  begin
    Result:='';
    FStop:=true;
  end;
end;

function TSQLDeclareLocalVarParser.GetWordEx: string;
var
  i:integer;
begin
  if FCurPos < Length(FSqlLine) then
  begin
    i:=FCurPos;
    while (FCurPos <= Length(FSqlLine)) and ((FSqlLine[FCurPos] >' ')) do Inc(FCurPos);
    Result:=Copy(FSqlLine, i, FCurPos - i);
  end
  else
  begin
    Result:='';
    FStop:=true;
  end;
end;

function TSQLDeclareLocalVarParser.GetToEOL: string;
var
  i:integer;
begin
  if FCurPos< Length(FSqlLine) then
  begin
    i:=FCurPos;
    while (FCurPos<=Length(FSqlLine)) and (not (FSqlLine[FCurPos] in [#13,#10])) do Inc(FCurPos);
    Result:=TrimRight(Copy(FSqlLine, i, FCurPos - i));
  end
  else
  begin
    Result:='';
    FStop:=true;
  end;
end;

constructor TSQLDeclareLocalVarParser.Create;
begin
  inherited Create;
  FParams:=TSQLFields.Create;
end;

destructor TSQLDeclareLocalVarParser.Destroy;
begin
  FreeAndNil(FParams);
  inherited Destroy;
end;

procedure TSQLDeclareLocalVarParser.ParseString(ASqlLine: string);
begin

end;

procedure TSQLDeclareLocalVarParser.ParseDeclare(ASQLParser: TSQLParser);
begin

end;

{ TSQLStatmentRecords }

destructor TSQLStatmentRecord.Destroy;
begin
  if Assigned(FItem) then
    FItem.Free;
  inherited Destroy;
end;

function TSQLStatmentRecords.GetItems(AIndex: integer): TSQLStatmentRecord;
begin
  Result:=TSQLStatmentRecord(Get(AIndex));
end;

destructor TSQLStatmentRecords.Destroy;
var
  i: Integer;
begin
  for i:=0 to Count - 1 do
    TSQLStatmentRecord(Get(i)).Free;
  inherited Destroy;
end;

function TSQLStatmentRecords.GetEnumerator: TSQLStatmentRecordEnumerator;
begin
  Result:=TSQLStatmentRecordEnumerator.Create(Self);
end;

{ TSQLCommandDML }

function TSQLCommandDML.GetSchemaName: string;
begin
  if FTables.Count > 0 then
    Result:=FTables[0].SchemaName
  else
    Result:='';
end;

function TSQLCommandDML.GetTableName: string;
begin
  if FTables.Count > 0 then
    Result:=FTables[0].Name
  else
    Result:='';
end;

procedure TSQLCommandDML.SetSchemaName(AValue: string);
var
  T: TTableItem;
begin
  if FTables.Count = 0 then
    T:=FTables.Add('')
  else
    T:=FTables[0];
  T.SchemaName:=AValue;
end;

procedure TSQLCommandDML.SetTableName(AValue: string);
var
  T: TTableItem;
begin
  if FTables.Count = 0 then
    T:=FTables.Add(AValue)
  else
    T:=FTables[0];
  T.Name:=AValue;
end;

constructor TSQLCommandDML.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSelectable:=false;
end;

{ TSQLTextStatement }

function TSQLTextStatement.GetSQLCommand: TSQLCommandAbstract;
begin
  if not Assigned(FSQLCommand) then
    FSQLCommand:=GetNextSQLCommand(FText, FParser.FOwner);
  Result:=FSQLCommand;
end;

constructor TSQLTextStatement.Create(AParser: TSQLParser);
begin
  inherited Create;
  FParser:=AParser;
  FParser.FStatementList.Add(Self);
end;

destructor TSQLTextStatement.Destroy;
begin
  if Assigned(FSQLCommand) then
    FreeAndNil(FSQLCommand);
  inherited Destroy;
end;


{ TSQLCommandSelect }

procedure TSQLCommandSelect.ParseJoinOn(ASQLParser: TSQLParser);
var
  P, PS: TParserPosition;
  FStop: Boolean;
  S: String;
begin
  FStop:=false;
  PS:=ASQLParser.Position;
  repeat
    P:=ASQLParser.Position;
    S:=UpperCase(ASQLParser.GetNextWord);
    if S = ASQLParser.CommandDelemiter then
    begin
      ASQLParser.Position:=P;
      FStop:=true;
    end
    else
    if S = '(' then
      ASQLParser.GetToBracket(')')
    else
    if (S = 'INNER') or (S = 'LEFT') or (S = 'RIGHT') or (S = 'FULL') or (S = 'WHERE') or (S = 'ORDER') or (S = 'UNION') or (S = 'GROUP') or (S=',') then
    begin
      ASQLParser.Position:=P;
      FStop:=true;
    end
  until FStop or ASQLParser.Eof;

  if Assigned(FCurTable) then
  begin
    FCurTable.JoinExpression:=Trim(Copy(ASQLParser.SQL, PS.Position, P.Position - PS.Position));
    if (FCurTable.JoinExpression<>'') and (FCurTable.JoinExpression[1] = '(') and (FCurTable.JoinExpression[Length(FCurTable.JoinExpression)] = ')') then
      FCurTable.JoinExpression:=Trim(Copy(FCurTable.JoinExpression, 2, Length(FCurTable.JoinExpression)-2));
  end;
end;

procedure TSQLCommandSelect.ParseFieldExp(ASQLParser: TSQLParser;
  AWord: string; AChild: TSQLTokenRecord);
var
  FStop, FNeedSign: Boolean;
  PS, PS1: TParserPosition;
  S, R: String;
begin
  if AWord <> '' then
  begin
    FNeedSign:=false;
  end;

  FStop:=false;
  PS1:=ASQLParser.Position;
  repeat
    PS:=ASQLParser.Position;
    S:=ASQLParser.GetNextWord;
    if S = '(' then
    begin
      ASQLParser.GetToBracket(')');
      FNeedSign:=true;
    end
    else
    if (S = '+') or (S = '-') or (S = '*') or (S = '\') or (S = '||') then
    begin
      FNeedSign:=false;
    end
    else
    if (ASQLParser.WordType(AChild, S, Self) in [stIdentificator, stInteger, stString, stFloat]) and not FNeedSign then
      FNeedSign:=true
    else
    begin
      ASQLParser.Position:=PS;
      FStop:=true
    end;
  until FStop or ASQLParser.Eof;

  R:=R + AWord;
  if PS1.Position <> PS.Position then
    R:=R + Copy(ASQLParser.SQL, PS1.Position, PS.Position - PS1.Position);

  if (R<>'') and Assigned(FCurField) then
  begin
    if FCurField.TableName<>'' then
      FCurField.ComputedSource:=FCurField.ComputedSource + FCurField.TableName + '.';
    FCurField.ComputedSource:=FCurField.Caption + R;
    FCurField.TableName:='';
    FCurField.Caption:='';
  end;
end;

procedure TSQLCommandSelect.InitParserTree;
var
  Par1, FSQLTokens, Par2, T, TSymb, TTbl1, TTbl2, TJI,
    TJL, TJR, TJF, TJ, TOn, T1, TTbl_AS, TTbl_ALIAS, T_AS,
    T_AL, T2, T3, T4, T5, T6, T7, T1_Symb, TBLV1, TBLV1_AS,
    TBLV1_ALIAS, TAS_FA, TSymbTbl, T6_1, FSQLTokens1, TWhere,
    TOrderBy, TTbl3, TTbl4, TOrderBy_1, TOrderBy1, TOrderBy1_1,
    TOrderBy_2, TOrderBy2: TSQLTokenRecord;
begin
(*
Синтаксис PG 12
[ WITH [ RECURSIVE ] запрос_WITH [, ...] ]
SELECT [ ALL | DISTINCT [ ON ( выражение [, ...] ) ] ]
    [ * | выражение [ [ AS ] имя_результата ] [, ...] ]
    [ FROM элемент_FROM [, ...] ]
    [ WHERE условие ]
    [ GROUP BY элемент_группирования [, ...] ]
    [ HAVING условие [, ...] ]
    [ WINDOW имя_окна AS ( определение_окна ) [, ...] ]
    [ { UNION | INTERSECT | EXCEPT } [ ALL | DISTINCT ] выборка ]
    [ ORDER BY выражение [ ASC | DESC | USING оператор ] [ NULLS { FIRST | LAST } ] [, ...] ]
    [ LIMIT { число | ALL } ]
    [ OFFSET начало [ ROW | ROWS ] ]
    [ FETCH { FIRST | NEXT } [ число ] { ROW | ROWS } ONLY ]
    [ FOR { UPDATE | NO KEY UPDATE | SHARE | KEY SHARE } [ OF имя_таблицы [, ...] ] [ NOWAIT | SKIP LOCKED ] [...] ]

Здесь допускается элемент_FROM:

    [ ONLY ] имя_таблицы [ * ] [ [ AS ] псевдоним [ ( псевдоним_столбца [, ...] ) ] ]
                [ TABLESAMPLE метод_выборки ( аргумент [, ...] ) [ REPEATABLE ( затравка ) ] ]
    [ LATERAL ] ( выборка ) [ AS ] псевдоним [ ( псевдоним_столбца [, ...] ) ]
    имя_запроса_WITH [ [ AS ] псевдоним [ ( псевдоним_столбца [, ...] ) ] ]
    [ LATERAL ] имя_функции ( [ аргумент [, ...] ] )
                [ WITH ORDINALITY ] [ [ AS ] псевдоним [ ( псевдоним_столбца [, ...] ) ] ]
    [ LATERAL ] имя_функции ( [ аргумент [, ...] ] ) [ AS ] псевдоним ( определение_столбца [, ...] )
    [ LATERAL ] имя_функции ( [ аргумент [, ...] ] ) AS ( определение_столбца [, ...] )
    [ LATERAL ] ROWS FROM( имя_функции ( [ аргумент [, ...] ] ) [ AS ( определение_столбца [, ...] ) ] [, ...] )
                [ WITH ORDINALITY ] [ [ AS ] псевдоним [ ( псевдоним_столбца [, ...] ) ] ]
    элемент_FROM [ NATURAL ] тип_соединения элемент_FROM [ ON условие_соединения | USING ( столбец_соединения [, ...] ) ]

и элемент_группирования может быть следующим:

    ( )
    выражение
    ( выражение [, ...] )
    ROLLUP ( { выражение | ( выражение [, ...] ) } [, ...] )
    CUBE ( { выражение | ( выражение [, ...] ) } [, ...] )
    GROUPING SETS ( элемент_группирования [, ...] )

и запрос_WITH:

    имя_запроса_WITH [ ( имя_столбца [, ...] ) ] AS [ [ NOT ] MATERIALIZED ] ( выборка | values | insert | update | delete )

TABLE [ ONLY ] имя_таблицы [ * ]

*)

  //Для запросов с CTE (common table expression)
  FSQLTokens1:=AddSQLTokens(stKeyword, nil, 'WITH', [toFirstToken, toFindWordLast]);
    T:=AddSQLTokens(stKeyword, FSQLTokens1, 'RECURSIVE', [], 82);
    T:=AddSQLTokens(stIdentificator, [FSQLTokens1, T], '', [], 80);

    T1:=AddSQLTokens(stSymbol, T, '(', []);
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 83);
      T2:=AddSQLTokens(stSymbol, T1, ',', []);
      T2.AddChildToken(T1);
    T1:=AddSQLTokens(stKeyword, T1, ')', []);

    T1:=AddSQLTokens(stKeyword, [T, T1], 'AS', []);
      T2:=AddSQLTokens(stKeyword, T1, 'NOT', [], 84);
      T3:=AddSQLTokens(stKeyword, [T1, T2], 'MATERIALIZED', [], 85);
    T1:=AddSQLTokens(stSymbol, [T1, T2, T3], '(', [], 81);
      T2:=AddSQLTokens(stSymbol, T1, ',', []);
      T2.AddChildToken([T]);

  //Разбор основного текста SQL SELECT
  FSQLTokens:=AddSQLTokens(stKeyword, T1, 'SELECT', [toFirstToken, toFindWordLast]);
    Par1:=AddSQLTokens(stKeyword, FSQLTokens, 'ALL', [], 41);
    Par2:=AddSQLTokens(stKeyword, FSQLTokens, 'DISTINCT', [], 42);
  T:=AddSQLTokens(stIdentificator, [FSQLTokens, Par1, Par2], '', [], 50);
    T1_Symb:=AddSQLTokens(stSymbol, T, '.', []);
    T1:=AddSQLTokens(stIdentificator, T1_Symb, '', [], 51);

    T_AS:=AddSQLTokens(stKeyword, [T, T1], 'AS', []);
    T_AL:=AddSQLTokens(stIdentificator, [T, T1, T_AS], '', [], 70);

    T2:=AddSQLTokens(stSymbol, [FSQLTokens, Par1, Par2, T1_Symb], '*', [], 53);
    T3:=AddSQLTokens(stSymbol, [FSQLTokens, Par1, Par2], '+', [], 52);
    T4:=AddSQLTokens(stSymbol, [FSQLTokens, Par1, Par2], '-', [], 52);
    T5:=AddSQLTokens(stSymbol, [FSQLTokens, Par1, Par2], '(', [], 54);
    T6:=AddSQLTokens(stInteger, [FSQLTokens, Par1, Par2], '', [], 52);
    T6_1:=AddSQLTokens(stFloat, [FSQLTokens, Par1, Par2], '', [], 52);
    T7:=AddSQLTokens(stString, [FSQLTokens, Par1, Par2], '', [], 52);
      T3.AddChildToken([T_AS, T_AL]);
      T4.AddChildToken([T_AS, T_AL]);
      T5.AddChildToken([T_AS, T_AL]);
      T6.AddChildToken([T_AS, T_AL]);
      T6_1.AddChildToken([T_AS, T_AL]);
      T7.AddChildToken([T_AS, T_AL]);

  TSymb:=AddSQLTokens(stSymbol, [T, T1, T2, T3, T4, T5, T6, T6_1, T7, T_AL], ',', [], 2);
    TSymb.AddChildToken([T, T2, T3, T4, T5, T6, T6_1, T7]);

  FTokenFrom:=AddSQLTokens(stKeyword, [T, T1, T2, T5, T6, T6_1, T7, T_AL], 'FROM', [], 9);
  TTbl1:=AddSQLTokens(stIdentificator, FTokenFrom, '', [], 3);
    TTbl2:=AddSQLTokens(stIdentificator, TTbl1, '.', [toOptional]);
    TTbl2:=AddSQLTokens(stIdentificator, TTbl2, '', [], 4);

    TTbl_AS:=AddSQLTokens(stKeyword, [TTbl1, TTbl2], 'AS', [toOptional]);
    TTbl_ALIAS:=AddSQLTokens(stIdentificator, [TTbl1, TTbl2, TTbl_AS], '', [toOptional], 5);

    TBLV1:=AddSQLTokens(stIdentificator, FTokenFrom, '(', [], 30);
      TBLV1_AS:=AddSQLTokens(stKeyword, TBLV1, 'AS', []);
      TBLV1_ALIAS:=AddSQLTokens(stIdentificator, [TBLV1, TBLV1_AS], '', [], 5);

    TAS_FA:=AddSQLTokens(stSymbol, [TTbl_ALIAS, TBLV1_ALIAS], '(', [toOptional]);
      TAS_FA:=AddSQLTokens(stIdentificator, TAS_FA, '', [], 15);
      TSymb:=AddSQLTokens(stSymbol, TAS_FA, ',', [], 16);
        TSymb.AddChildToken(TAS_FA);
    TAS_FA:=AddSQLTokens(stKeyword, TAS_FA, ')', [], 16);

    TSymbTbl:=AddSQLTokens(stIdentificator, [TTbl1, TTbl2, TTbl_ALIAS, TBLV1_ALIAS, TAS_FA], ',', [toOptional], 6);
    TSymbTbl.AddChildToken([TTbl1, TBLV1]);

  TWhere:=AddSQLTokens(stKeyword, [TTbl1, TTbl2, TTbl_ALIAS, TAS_FA], 'WHERE', [toOptional], 21);


  TJI:=AddSQLTokens(stKeyword, [TTbl1, TTbl2, TBLV1_ALIAS, TTbl_AS, TTbl_ALIAS], 'INNER', [toOptional], 10);
  TJL:=AddSQLTokens(stKeyword, [TTbl1, TTbl2, TBLV1_ALIAS, TTbl_AS, TTbl_ALIAS], 'LEFT', [toOptional], 11);
  TJR:=AddSQLTokens(stKeyword, [TTbl1, TTbl2, TBLV1_ALIAS, TTbl_AS, TTbl_ALIAS], 'RIGTH', [toOptional], 12);
  TJF:=AddSQLTokens(stKeyword, [TTbl1, TTbl2, TBLV1_ALIAS, TTbl_AS, TTbl_ALIAS], 'FULL', [toOptional], 13);
  TJ:=AddSQLTokens(stKeyword, [TTbl1, TTbl2, TJI, TJL, TJR, TJF, TBLV1_ALIAS, TTbl_AS, TTbl_ALIAS], 'JOIN', [toOptional], 14);
    TTbl3:=AddSQLTokens(stIdentificator, TJ, '', [], 3);
      TTbl3.AddChildToken(TWhere);
      TTbl4:=AddSQLTokens(stIdentificator, TTbl3, '.', []);
      TTbl4:=AddSQLTokens(stIdentificator, TTbl4, '', [], 4);
      TBLV1:=AddSQLTokens(stIdentificator, TJ, '(', [], 30);
      TTbl4.AddChildToken(TWhere);
      TTbl_AS:=AddSQLTokens(stKeyword, [TTbl3, TTbl4, TBLV1], 'AS', []);
      TTbl_ALIAS:=AddSQLTokens(stIdentificator, [TTbl3, TTbl4, TTbl_AS, TBLV1], '', [], 5);
      TTbl_ALIAS.AddChildToken(TWhere);

      TAS_FA:=AddSQLTokens(stSymbol, TTbl_ALIAS, '(', [toOptional]);
        TAS_FA:=AddSQLTokens(stIdentificator, TAS_FA, '', [], 15);
        TSymb:=AddSQLTokens(stSymbol, TAS_FA, ',', [], 16);
          TSymb.AddChildToken(TAS_FA);
          TAS_FA:=AddSQLTokens(stKeyword, TAS_FA, ')', [], 16);
          TAS_FA.AddChildToken(TWhere);

    TOn:=AddSQLTokens(stKeyword, [TTbl3, TTbl4, TTbl_ALIAS, TAS_FA], 'ON', [], 20);
    TOn.AddChildToken([TJI, TJL, TJR, TJF, TJ, TSymbTbl, TWhere]);

  //[ ORDER BY выражение [ ASC | DESC | USING оператор ] [ NULLS { FIRST | LAST } ] [, ...] ]
  TOrderBy:=AddSQLTokens(stKeyword, [TOn, TTbl1, TTbl2, TTbl3, TTbl4, TTbl_ALIAS], 'ORDER', []);
  TOrderBy_1:=AddSQLTokens(stKeyword, TOrderBy, 'BY', []);
    TOrderBy1:=AddSQLTokens(stIdentificator, TOrderBy_1, '', [], 201);
    TOrderBy1_1:=AddSQLTokens(stSymbol, TOrderBy1, '.', [toOptional], 201);
    TOrderBy1_1:=AddSQLTokens(stIdentificator, TOrderBy1_1, '.', [], 201);

    TOrderBy_2:=AddSQLTokens(stSymbol, [TOrderBy1, TOrderBy1_1], ',', [toOptional], 202);

    TOrderBy2:=AddSQLTokens(stInteger, [TOrderBy_1, TOrderBy_2], '', [], 201);
    TOrderBy2.AddChildToken(TOrderBy_2);

  TOrderBy_2.AddChildToken([TOrderBy1])
end;

procedure TSQLCommandSelect.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
var
  S: String;
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    41:FAllRec:=true;
    42:FAllRec:=false;
    50:begin
         FParserState:=pssFields;
         FCurField:=Fields.AddParamEx(AWord, '');
         FCurField.InReturn:=spvtLocal;
         ParseFieldExp(ASQLParser, '', AChild);
       end;
    51:if Assigned(FCurField) then
       begin
         FCurField.TableName:=FCurField.Caption;
         FCurField.InReturn:=spvtLocal;
         FCurField.Caption:=AWord;
       end;
    52:begin
         FParserState:=pssFields;
         FCurField:=Fields.AddParamEx('', '');
         FCurField.InReturn:=spvtLocal;
         ParseFieldExp(ASQLParser, AWord, AChild);
       end;
    54:begin
         FParserState:=pssFields;
         FCurField:=Fields.AddParamEx('', '');
         FCurField.InReturn:=spvtLocal;
         S:=ASQLParser.GetToBracket(')');
         FCurField.Caption:='(' + S + ')';
         //ParseFieldExp(ASQLParser, AWord, AChild);
       end;
    53:if Assigned(FCurField) then
       begin
         FCurField.TableName:=FCurField.Caption;
         FCurField.Caption:=AWord;
         FCurField.InReturn:=spvtLocal;
         FCurField:=nil;
       end
       else
       begin
         FParserState:=pssFields;
         Fields.AddParamEx(AWord, '');
       end;
    70:if Assigned(FCurField) then
         FCurField.RealName:=AWord;
    2:FCurField:=nil;
    3:if not Assigned(FCurTable) then
        FCurTable:=Tables.Add(AWord)
      else
        FCurTable.Name:=AWord;
    4:if Assigned(FCurTable) then
      begin
        FCurTable.SchemaName:=FCurTable.Name;
        FCurTable.Name:=AWord;
      end;
    5:if Assigned(FCurTable) then
        FCurTable.TableAlias:=AWord;
    6:FCurTable:=nil;
    10:begin
         FCurTable:=Tables.Add('');
         FCurTable.JoinType:=jtInner;
       end;
    11:begin
         FCurTable:=Tables.Add('');
         FCurTable.JoinType:=jtLeft;
       end;
    12:begin
         FCurTable:=Tables.Add('');
         FCurTable.JoinType:=jtRight;
       end;
    13:begin
         FCurTable:=Tables.Add('');
         FCurTable.JoinType:=jtFull;
       end;
    14:if (FCurTable.Name <> '') or (FCurTable.TableAlias<>'') then
       FCurTable:=Tables.Add('');

    9:FParserState:=pssFrom;
    20:begin
         ParseJoinOn(ASQLParser);
         FCurTable:=nil;
       end;
    30:begin
         if not Assigned(FCurTable) then
           FCurTable:=Tables.Add('');
         FCurTable.TableType:=stitVirtualTable;
         FCurTable.TableExpression:=ASQLParser.GetToBracket(')');
       end;
    15:if Assigned(FCurTable) then
         FCurTable.Fields.AddParam(AWord);
    80:FCurCTE:=CTE.Add(AWord);
    81:if Assigned(FCurCTE) then
        FCurCTE.SQL := ASQLParser.GetToBracket(')');
    82:FCTE.Recursive:=true;
    84:if Assigned(FCurCTE) then
        FCurCTE.MaterializedFlag:=ctemfNotMaterialized;
    85:if Assigned(FCurCTE) then
        if FCurCTE.MaterializedFlag = ctemfDefault then
        FCurCTE.MaterializedFlag:=ctemfMaterialized;
    83:if Assigned(FCurCTE) then
        FCurCTE.Fields.AddParam(AWord);
    21:FWhereExpression:=ASQLParser.GetToCommandDelemiter;

    201:begin
          if not Assigned(FCurOrderByField) then
            FCurOrderByField:=OrderByFields.AddParam('');
          FCurOrderByField.Caption:=FCurOrderByField.Caption + AWord;
        end;
    202:FCurOrderByField:=nil;
  end;
end;

procedure TSQLCommandSelect.MakeSQL;
var
  F: TSQLParserField;
  S, S1: String;
  T: TTableItem;
  CT: TSQLCommandSelectCTE;
begin
  S:='';

  if FCTE.Count > 0 then
  begin
    S:=S + 'WITH';
    if FCTE.Recursive then S:=S + ' RECURSIVE';
    S:=S + LineEnding;
    S1:='';
    for CT in FCTE do
    begin
      if S1<>'' then S1:=S1 + ',' + LineEnding;
      S1:=S1 + '  ' + CT.Name;
      if CT.Fields.Count>0 then S1:=S1 + '(' + CT.Fields.AsString + ')';


      S1:=S1 + ' AS';
      case CT.MaterializedFlag of
        ctemfMaterialized:S1:=S1 + ' MATERIALIZED';
        ctemfNotMaterialized:S1:=S1 + ' NOT MATERIALIZED';
      end;
      S1:=S1 + LineEnding + '(' + CT.SQL + ')';
    end;
    S:=S + S1 + LineEnding;
  end;

  S:=S + 'SELECT';
  if not FAllRec then S:=S + 'DISTINCT';

  S1:='';
  for F in Fields do
  begin
    if S1<>'' then S1:=S1 + ',' + LineEnding;
    S1:=S1 + '  ';

    if F.ComputedSource <> '' then
      S1:=S1 + F.ComputedSource
    else
    begin
      if F.TableName <> '' then
        S1:=S1 + F.TableName + '.';
      S1:=S1 + F.Caption;
    end;

    if F.RealName <> '' then
      S1:=S1 + ' AS '+F.RealName;
  end;

  if S1 <> '' then S:=S + LineEnding + S1;

  S1:='';
  for T in Tables do
  begin
    if S1<>'' then
    begin
      if T.JoinExpression <> '' then
      begin
        S1:=S1 + LineEnding;
        case T.JoinType of
          jtInner:S1:=S1 + '  INNER JOIN ';
          jtLeft:S1:=S1 + '  LEFT JOIN ';
          jtRight:S1:=S1 + '  RIGHT JOIN ';
          jtFull:S1:=S1 + '  FULL JOIN ';
        end;
      end
      else
        S1:=S1 + ',' + LineEnding + '  ';
    end
    else S1:=S1 + '  ';

    if T.TableType = stitVirtualTable then
      S1:=S1 + '(' + T.TableExpression + ')'
    else
    begin
      if T.SchemaName <> '' then
        S1:=S1 + T.SchemaName + '.';
      S1:=S1 + T.Name;
    end;

    if T.TableAlias <> '' then
      S1:=S1 + ' AS ' + T.TableAlias;

    if T.Fields.Count > 0 then
      S1:=S1 + ' (' + T.Fields.AsString + ')';

    if T.JoinExpression <> '' then
      S1:=S1 + ' ON ('+T.JoinExpression+')';
  end;

  if S1 <> '' then S:=S + LineEnding + 'FROM' + LineEnding + S1;

  if WhereExpression <> '' then
    S:=S + LineEnding + 'WHERE' + ' ' + WhereExpression;

  if FOrderByFields.Count>0 then
  begin
    S:=S + LineEnding + 'ORDER BY'+LineEnding;
    S1:='';
    for F in OrderByFields do
    begin
      if S1<>'' then S1:=S1 + ',' + LineEnding;
      S1:=S1 + '  ' + F.Caption;
      if F.IndexOptions.SortOrder = indDescending then
        S1:=S1 + ' DESC'
      else
      if F.IndexOptions.SortOrder = indAscending then
        S1:=S1 + ' ASC';
    end;
    S:=S + S1;
  end;
  AddSQLCommand(S);
end;

function TSQLCommandSelect.InternalProcessError(ASQLParser: TSQLParser;
  var AChild: TSQLTokenRecord): boolean;
begin
  if FParserState = pssFields then
  begin
    ASQLParser.Position:=ASQLParser.WordPosition;
    ASQLParser.WaitWord('FROM');
    AChild:=FTokenFrom;
    FParserState:=pssFrom;
    Result:=true;
  end
  else
    Result:=false;
end;

constructor TSQLCommandSelect.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSelectable:=true;
  FAllRec:=true;
  FParserState:=pssNone;
end;

destructor TSQLCommandSelect.Destroy;
begin
  inherited Destroy;
end;

procedure TSQLCommandSelect.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLCommandSelect then
  begin
    AllRec:=TSQLCommandSelect(ASource).AllRec;
    WhereExpression:=TSQLCommandSelect(ASource).WhereExpression;
    CTE.Assign(TSQLCommandSelect(ASource).CTE);
  end;
  inherited Assign(ASource);
end;

{ TSQLCommandSelect }

constructor TSQLCommandAbstractSelect.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FTables:=TSQLTables.Create;
  FFields:=TSQLFields.Create;
  FOrderByFields:=TSQLFields.Create;
  FPlanEnabled:=true;
  FCTE:=TSQLCommandSelectCTEList.Create;
end;

destructor TSQLCommandAbstractSelect.Destroy;
begin
  FreeAndNil(FCTE);
  FreeAndNil(FTables);
  FreeAndNil(FFields);
  FreeAndNil(FOrderByFields);
  inherited Destroy;
end;

procedure TSQLCommandAbstractSelect.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLCommandAbstractSelect then
  begin
    Tables.Assign(TSQLCommandAbstractSelect(ASource).Tables);
    Fields.Assign(TSQLCommandAbstractSelect(ASource).Fields);
    FSelectable:=TSQLCommandAbstractSelect(ASource).Selectable;
    FOrderByFields.Assign(TSQLCommandAbstractSelect(ASource).FOrderByFields);
  end;
  inherited Assign(ASource);
end;

{ TSQLCommandUpdate }

function TSQLCommandUpdate.GetUpdateExpression(ASQLParser: TSQLParser): string;
var
  S: String;
  FCP, C: TParserPosition;
begin
  FCP:=ASQLParser.Position;
  while not ASQLParser.Eof do
  begin
    C:=ASQLParser.Position;
    S:=ASQLParser.GetNextWord;
    if S = '(' then
      ASQLParser.GetToBracket(')')
    else
    if S = ')' then
      SetError(ASQLParser, sSqlParserErrorBracket)
    else
    if (S = ',') or (UpperCase(S) = 'WHERE') then
    begin
      ASQLParser.Position:=C;
      break;
    end;
  end;
  Result:=Trim( Copy(ASQLParser.FSql, FCP.Position, C.Position - FCP.Position));
end;

function TSQLCommandUpdate.GetWhereExpression(ASQLParser: TSQLParser): string;
var
  S: String;
  FCP, C: TParserPosition;
begin
  FCP:=ASQLParser.Position;
  while not ASQLParser.Eof do
  begin
    C:=ASQLParser.Position;
    S:=ASQLParser.GetNextWord;
    if S = '(' then
      ASQLParser.GetToBracket(')')
    else
    if (S = ';') or (UpperCase(S) = 'RETURNING') or (UpperCase(S) = 'INTO') then
    begin
      ASQLParser.Position:=C;
      break;
    end;
  end;
  Result:=Copy(ASQLParser.FSql, FCP.Position, C.Position - FCP.Position);
end;

procedure TSQLCommandUpdate.InitParserTree;
var
  TN, TSymb, TA, T, FSQLTokens, T1, T2: TSQLTokenRecord;
begin
  inherited InitParserTree;
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'update', [toFirstToken, toFindWordLast]);

    TN:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1); //
    TSymb:=AddSQLTokens(stSymbol, TN, '.', []);    //если есть - то было имя схемы
        TA:=AddSQLTokens(stIdentificator, TSymb, '', [], 2);  //Если была схема - то имя таблицы

    T:=AddSQLTokens(stKeyword , TN, 'set', []);
      TA.AddChildToken(T); //обработаем заодно и алиас

  TN:=AddSQLTokens(stIdentificator, T, '', [], 3); //Имя поля или Алиас таблицы //aaa.aaaa

  if AllowFieldAlias then
  begin
    TSymb:=AddSQLTokens(stSymbol, TN, '.', []);    //если есть - то был алиас
    TA:=AddSQLTokens(stIdentificator, TSymb, '', [], 4);  //Алиас таблицы
  end;

  T:=AddSQLTokens(stSymbol, TN, '=', [], 5);
  if AllowFieldAlias then
    TA.AddChildToken(T);

  TSymb:=AddSQLTokens(stSymbol, T, ',', [], 6);  //Алиас таблицы
     TSymb.AddChildToken(TN);                //Рекурсия на новое поле

  T:=AddSQLTokens(stKeyword, T, 'where', [toOptional], 7);
  T1:=AddSQLTokens(stKeyword, T, 'returning', [toOptional], 8);
  T2:=AddSQLTokens(stKeyword, T, 'into', [toOptional], 9);
    T1.AddChildToken(T2);

    (*
[ WITH [ RECURSIVE ] with_query [, ...] ]
UPDATE [ ONLY ] table [ [ AS ] alias ]
    SET { column = { expression | DEFAULT } |
          ( column [, ...] ) = ( { expression | DEFAULT } [, ...] ) } [, ...]
    [ FROM from_list ]
    [ WHERE condition | WHERE CURRENT OF cursor_name ]
    [ RETURNING * | output_expression [ [ AS ] output_name ] [, ...] ]
*)
end;

procedure TSQLCommandUpdate.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:begin
        TableName:=AWord;
        FSelectable:=Pos('RETURNING', UpperCase(ASQLParser.SQL)) > 0;
      end;
    2:begin
        SchemaName:=TableName;
        TableName:=AWord;
      end;
    3:FCurField:=Fields.AddParam(AWord);
    4:if Assigned(FCurField) then
      begin
        FCurField.TableName:=FCurField.Caption;
        FCurField.Caption:=AWord;
      end;
    5:if Assigned(FCurField) then
        FCurField.DefaultValue:=GetUpdateExpression(ASQLParser);
    6:FCurField:=nil;
    7:WhereExpression:=GetWhereExpression(ASQLParser);
  end;
end;

function TSQLCommandUpdate.AllowFieldAlias: boolean;
begin
  Result:=true;
end;

procedure TSQLCommandUpdate.MakeSQL;
var
  S1, Result: String;
  F: TSQLParserField;
begin
  Result:='update'+LineEnding+'  ';
  if SchemaName <> '' then
    Result:=Result + SchemaName + '.';
  Result:=Result + TableName +  LineEnding + 'set' + LineEnding;

  S1:='';
  for F in Fields do
  begin
    if S1<>'' then S1:=S1 + ',' + LineEnding;
    S1:=S1 + '  ';
    if F.TableName <> '' then
      S1:=S1 + F.TableName + '.';
    S1:=S1 + F.Caption + ' = ' + F.DefaultValue;
  end;

  Result:=Result + S1;

  if WhereExpression <> '' then
    Result:=Result + LineEnding + 'where' + LineEnding + WhereExpression;
  AddSQLCommand(Result);
end;

procedure TSQLCommandUpdate.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLCommandUpdate then
  begin
    WhereExpression:=TSQLCommandUpdate(ASource).WhereExpression;

  end;
  inherited Assign(ASource);
end;

{ TSQLCommandAbstract }

procedure TSQLCommandAbstract.SetState(const AValue: TCMDState);
begin
  if FState=AValue then exit;
  FState:=AValue;
end;

function TSQLCommandAbstract.DoCheckCommand(FSQLTokens: TSQLTokenRecord;
  ASQLParser: TSQLParser): boolean;
var
  Stop: Boolean;
  T, Child: TSQLTokenRecord;
  S: String;
  AToken: TSQLToken;
begin
  Result:=false;

  Stop:=false;
  T:=FSQLTokens;
  if not Assigned(T) then
    raise Exception.Create('Не инициализирован SQLTokens - ' + ClassName);

  S:=ASQLParser.GetNextWord;
  if not T.Equal(S) then exit;

  if (toFindWordLast in T.Options) then
  begin
    Result:=true;
    exit;
  end;

  repeat
    S:=ASQLParser.GetNextWord;
    AToken:=ASQLParser.WordType(T, S, Self);

    case AToken of
      stString,
      stInteger,
      stFloat,
      stIdentificator:Child:=T.ChildByType(AToken, S);
      stSymbol,
      stTerminator,
      stStdKeyType,
      stKeyword:Child:=T.ChildByName(S);
    else
      Result:=false;
      Stop:=true;
      break;
    end;

    if not Assigned(Child) then
    begin
      Result:=false;
      Stop:=true;
    end
    else
    if (toFindWordLast in Child.Options) then
    begin
      Result:=true;
      exit;
    end;

    T:=Child;
  until Stop;
end;

function TSQLCommandAbstract.AddSQLTokens(AToken: TSQLToken;
  const Parent: TSQLTokenRecord; const SQLCommand: string;
  AOptions: TSQLTokenOptions; ATag: integer; ADBObjectKind: TDBObjectKind;
  ACaption: string): TSQLTokenRecord;

begin
  Result:=TSQLTokenRecord.Create;
  FSQLTokensList.Add(Result);

  Result.Token:=AToken;
  Result.SQLCommand:=UpperCase(SQLCommand);
  Result.Options:=AOptions;
  Result.Tag:=ATag;
  Result.DBObjectKind:=ADBObjectKind;

  if Assigned(Parent) then
    Parent.Child.Add(Result);

  if toFirstToken in AOptions then
    FStartTokens.Add(Result);

(*  if (ObjectKind = okNone) and (ADBObjectKind <> okNone) then
    ObjectKind:=ADBObjectKind; *)
end;

function TSQLCommandAbstract.AddSQLTokens(AToken: TSQLToken;
  const Parents: array of TSQLTokenRecord; const ASQLCommand: string;
  AOptions: TSQLTokenOptions; ATag: integer; ADBObjectKind: TDBObjectKind;
  ACaption: string): TSQLTokenRecord;
var
  P: TSQLTokenRecord;
begin
  Result:=nil;
  if Length(Parents) = 0 then
    raise Exception.Create('TSQLCommandAbstract.AddSQLTokens: Count parents = 0');

  Result:=AddSQLTokens(AToken, nil, ASQLCommand, AOptions, ATag, ADBObjectKind, ACaption);
  for P in Parents do
    P.AddChildToken(Result);
end;

procedure TSQLCommandAbstract.InitParserTree;
begin

end;

function TSQLCommandAbstract.GetParamsCount: integer;
begin
  if Assigned(Params) then
    Result:=Params.Count
  else
    Result:=0;
end;


function TSQLCommandAbstract.GetParams: TSQLFields;
begin
  Result:=FParams;
end;

procedure TSQLCommandAbstract.SetError(ASQLParser: TSQLParser;
  const AErrorMessage: string);
begin
  FState:=cmsError;
  FErrorMessage:=Format('(%d, %d) %s', [ASQLParser.Position.X, ASQLParser.Position.Y, AErrorMessage]);
  FErrorPos.X:=ASQLParser.WordPosition.X;
  FErrorPos.Y:=ASQLParser.WordPosition.Y;
  FErrorPos.Position:=ASQLParser.Position.Position;
end;

function TSQLCommandAbstract.GetToNextToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord): string;
var
  FCP: TParserPosition;
  FStop: Boolean;
  FStart: Integer;
  S: String;
begin
  FStop:=false;
  FStart:=ASQLParser.Position.Position;
  repeat
    FCP:=ASQLParser.Position;
    FStop:=ASQLParser.Eof;
    if not FStop then
    begin
      S:=ASQLParser.GetNextWord;
      if S = ASQLParser.CommandDelemiter then
        FStop:=true
      else
      if S = '(' then
        ASQLParser.GetToBracket(')')
      else
      if Assigned(AChild.ChildByType(stKeyword, S)) then
        FStop:=true;
    end;
    if FStop then
      ASQLParser.Position:=FCP;
  until FStop;
  Result:=Copy(ASQLParser.SQL, FStart, ASQLParser.Position.Position - FStart);
end;

function TSQLCommandAbstract.InternalProcessError(ASQLParser: TSQLParser;
  var AChild: TSQLTokenRecord): boolean;
begin
  Result:=false;
end;


procedure TSQLCommandAbstract.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin

end;

function TSQLCommandAbstract.CheckCommand(ASQLParser: TSQLParser): boolean;
var
  SavePos: TParserPosition;
  i: Integer;
begin
  SavePos:=ASQLParser.Position;
  Result:=false;
  for i:=0 to FStartTokens.Count-1 do
  begin
    ASQLParser.Position := SavePos;
    if DoCheckCommand(TSQLTokenRecord(FStartTokens[i]), ASQLParser) then
      Exit(true);
  end;
end;

function TSQLCommandAbstract.FindKeyWord(AWord: string): boolean;

procedure DoFillKeyWords;
var
  T: TSQLTokenRecord;
  i: Integer;
begin
  FKeyWordList:=TStringList.Create;
  FKeyWordList.Sorted:=true;

  for T in FSQLTokensList do
    if T.FToken = stKeyword then
      if not FKeyWordList.Find(T.SQLCommand, i) then
        FKeyWordList.Add(UpperCase(T.SQLCommand));
end;

var
  I: Integer;
begin
  if Assigned(FParent) then
    Result:=FParent.FindKeyWord(AWord)
  else
  begin
    if not Assigned(FKeyWordList) then DoFillKeyWords;
    Result:=FKeyWordList.Find(AWord, I);
  end;
end;

constructor TSQLCommandAbstract.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create;
  FParent:=AParent;

  FSQLTokensList:=TSQLTokenList.Create;
  FStartTokens:=TSQLTokenList.Create;

  FPlanEnabled:=false;
  FParams:=TSQLFields.Create;
  InitParserTree;
end;

destructor TSQLCommandAbstract.Destroy;
begin
  FreeAndNil(FParams);
  FreeAndNil(FStartTokens);
  FSQLTokensList.Clear;
  FreeAndNil(FSQLTokensList);
  if Assigned(FKeyWordList) then
    FreeAndNil(FKeyWordList);
  inherited Destroy;
end;

function TSQLCommandAbstract.ErrorPosition: TPoint;
begin
  Result.x:=ErrorPos.X;
  Result.Y:=ErrorPos.Y;
end;

procedure TSQLCommandAbstract.ParseSQL(SQLParser:TSQLParser);

procedure DoParseSQL(FSQLTokens:TSQLTokenRecord);
var
  S:string;
  Stop:boolean;
  T, Child, CE:TSQLTokenRecord;
  AToken:TSQLToken;
  i: Integer;
begin
  FState:=cmsNormal;
  Stop:=false;
  T:=FSQLTokens;
  S:=SQLParser.GetNextWord;
  if not T.Equal(S) then exit;
  InternalProcessChildToken(SQLParser, T, S);

  repeat
    S:=SQLParser.GetNextWord;
    AToken:=SQLParser.WordType(T, S, Self);

    case AToken of
      stString,
      stInteger,
      stFloat,
      stIdentificator:Child:=T.ChildByType(AToken, S);
      stSymbol,
      stTerminator,
      stStdKeyType,
      stKeyword:Child:=T.ChildByName(S);
    else
      Child:=nil;
    end;


    if Assigned(Child) then
      InternalProcessChildToken(SQLParser, Child, S)
    else
    begin
      if (not SQLParser.IgnoreError) or (not InternalProcessError(SQLParser, Child)) then
      begin
        Stop:=true;
        if T.Child.Count > 0 then
        begin
          FErrorMessage:='';
          FErrorPos.X:=0;
          FErrorPos.Y:=0;
          for i:=0 to T.Child.Count-1 do
          begin
            CE:=TSQLTokenRecord(T.Child[i]);
            if (not (toOptional in CE.Options)) or ((S <> SQLParser.CommandDelemiter) and (S <> '')) then
            begin
              if FErrorMessage <> '' then FErrorMessage:=FErrorMessage + ', ';

              if CE.Token in [stSymbol, stTerminator, stStdKeyType, stKeyword] then
                FErrorMessage:=FErrorMessage + CE.SQLCommand
              else
              if CE.Token = stString then
                FErrorMessage:=FErrorMessage + sSqlParserString
              else
              if CE.Token in [stInteger, stFloat] then
                FErrorMessage:=FErrorMessage + sSqlParserNumber
              else
              if CE.Token = stIdentificator then
              begin
                FErrorMessage:=FErrorMessage + sSqlParserIdentificator;
                if CE.SQLCommand <> '' then
                  FErrorMessage:=FErrorMessage + ' (' + CE.SQLCommand + ')';
              end;
            end;
          end;
          if FErrorMessage <> '' then
            SetError(SQLParser, sSqlParserExpected + FErrorMessage);
        end;
      end;
    end;
    T:=Child;
  until Stop or (FState in [cmsError, cmsEndOfCmd]);
end;

var
  i: Integer;
  P: TSQLTokenRecord;
  SavePos: TParserPosition;
begin
  SavePos:=SQLParser.Position;
  for i:=0 to FStartTokens.Count-1 do
  begin
    P:=TSQLTokenRecord(FStartTokens[i]);
    SQLParser.Position:=SavePos;
    if DoCheckCommand(P, SQLParser) then
    begin
      SQLParser.Position:=SavePos;
      DoParseSQL(P);
      Exit;
    end;
  end;
end;

procedure TSQLCommandAbstract.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLCommandAbstract then
  begin
    PlanEnabled:=TSQLCommandAbstract(ASource).PlanEnabled;
    Params.Assign(TSQLCommandAbstract(ASource).Params);
    Name:=TSQLCommandAbstract(ASource).Name;
  end
  else
  inherited Assign(ASource);
end;

function TSQLCommandAbstract.SQLToken: TSQLToken;
begin
  if Assigned(FStartTokens) and (FStartTokens.Count>0) then
    Result:=TSQLTokenRecord(FStartTokens[0]).Token
  else
    Result:=stNone;
end;

procedure TSQLCommandAbstract.Clear;
begin
  inherited Clear;
  FParams.Clear;
end;

{ TSQLParser }

function TSQLParser.GetNextWord1(AExcludeChar: TSysCharSet): string;
procedure DoProcessString(ACh:Char);
begin
  while (Position.Position < Length(FSql)) do
  begin
    DoTestLineEnd;
    IncPos;

    if (ACh <> '$') and (FPosition.Position < Length(FSql)-1) and (FSql[FPosition.Position] = ACh) and (FSql[FPosition.Position+1] = ACh) then
    begin
      DoTestLineEnd;
      IncPos;
    end
    else
    if (ACh = '$') and (FPosition.Position < Length(FSql)) and (FSql[FPosition.Position] = CommandDelemiter) then
    begin
      DoTestLineEnd;
      exit;
    end
    else
    if (ACh = '$') and (FPosition.Position < Length(FSql)) and ((FSql[FPosition.Position] = ACh) or (FSql[FPosition.Position] <= ' ') or (FSql[FPosition.Position] = CommandDelemiter)) then
      break
    else
    if (FPosition.Position < Length(FSql)) and (FSql[FPosition.Position] = ACh) then
      break;


  end;
  DoTestLineEnd;
  IncPos;
end;

var
  StartPos: TParserPosition;
  FNum: Boolean;
  i: Integer;
begin
  Result:='';
  if FPosition.Position > Length(FSql) then exit;

  while (FPosition.Position<=Length(FSql)) and (FSql[FPosition.Position] <= ' ') do
  begin
    DoTestLineEnd;
    IncPos;
  end;
  if Eof then exit;

  StartPos:=Position;

  if FSql[FPosition.Position]='/' then
  begin
    IncPos;

    if (FPosition.Position < Length(FSql)) and (FSql[FPosition.Position]='*') then
    begin
      Result:='/*';
      IncPos;
      exit;
    end;
  end;

  if FSql[FPosition.Position]='*' then
  begin
    IncPos;

    if (FPosition.Position < Length(FSql)) and (FSql[FPosition.Position] = '/') then
    begin
      Result:='*/';
      IncPos;
      exit;
    end
    else
      Result:='*';
  end;

  if (FSql[FPosition.Position] = '-') and (FPosition.Position < Length(FSql)) and (FSql[FPosition.Position + 1] = '-') then
  begin
    Result:='--';
    IncPos;
    IncPos;
  end
  else
  if (FSql[FPosition.Position] = '|') and (FPosition.Position < Length(FSql)) and (FSql[FPosition.Position + 1] = '|') then
  begin
    Result:='||';
    IncPos;
    IncPos;
  end;

  if Result = '' then
  begin
    if (FSql[FPosition.Position]='''') and (AExcludeChar = []) then DoProcessString('''')
    else
    if (FSql[FPosition.Position]='"') and (AExcludeChar = [])  then DoProcessString('"')
    else
    if (FSql[FPosition.Position]='`') and (AExcludeChar = [])  then DoProcessString('`')
    else
    if (FSql[FPosition.Position] = '$') then DoProcessString('$')
    else
    if FSql[FPosition.Position] in CharDelimiters then IncPos
    else
    begin
      repeat
        DoTestLineEnd;
        IncPos;
      until (FPosition.Position >= Length(FSql)) or (FSql[FPosition.Position] < #33) or (not (FSql[FPosition.Position] in ({['a'..'z','A'..'Z','0'..'9', '_', '$']} SQLValidChars - AExcludeChar)));

      if (FPosition.Position < Length(FSql)) and (FSql[FPosition.Position] = '.') then
      begin
        //test for float
        FNum:=true;
        for i:=FPosition.Position-1 downto StartPos.Position do
          if not (FSql[i] in ['0'..'9']) then
          begin
            FNum:=false;
            Break;
          end;
        if FNum then
          repeat
            DoTestLineEnd;
            IncPos;
          until (FPosition.Position >= Length(FSql)) or (FSql[FPosition.Position] < #33) or (not (FSql[FPosition.Position] in ['0'..'9']));
      end

    end;
    SetLength(Result, FPosition.Position - StartPos.Position);
    Move(FSql[StartPos.Position], Result[1], Position.Position - StartPos.Position);
  end;
end;

function TSQLParser.GetStatement(Index: Integer): TSQLTextStatement;
begin
  Result:=TSQLTextStatement(FStatementList[Index]);
end;

function TSQLParser.GetStatementCount: Integer;
begin
  Result:=FStatementList.Count;
end;

function TSQLParser.GetNextWord: string;
var
  Stop:boolean;
  S, S1: String;
  FC: TParserPosition;
  ACS: TSysCharSet;
begin
  FCurrentStringDelemiter:='';
  Stop:=false;
  SkipSpace;
  repeat
    WordPosition:=Position;
    Result:=GetNextWord1([]);
    if Copy(Result, 1, 2) = '--' then
      SkipComment1
    else
    if Result='/*' then
      SkipComment2
    else
    if WordType(nil, Result, nil) = stTerminator then
    begin
      FC:=Position;
      S:=Result;
      if (Length(S)>1) and (S[1]='$') and (S[Length(S)]='$') then
      begin
        FCurrentStringDelemiter:=S;
        ACS:=['$']
      end
      else
        ACS:=[];

      while not Eof do
      begin
        if GetNextWord1(ACS) = S then
          break;
      end;
      S1:=Copy(FSql, FC.Position, Position.Position - FC.Position);
      Result:=QuotedString(Copy(FSql, FC.Position, Position.Position - Length(S) - FC.Position ), '''');
      Stop:=true;
    end
    else
    begin
      Stop:=true;
    end;
  until Stop or (Position.Position >= Length(FSql));
end;

procedure TSQLParser.SkipSpace;
begin
  while (Position.Position <= Length(FSql)) and (FSql[Position.Position] < #33) do
  begin
    DoTestLineEnd;
    IncPos;
  end;
end;

function TSQLParser.WaitWord(AWord: string): boolean;
var
  S:string;
begin
  Result:=false;
  AWord:=LowerCase(AWord);
  while not Eof do
  begin
    SkipSpace;
    S:=GetNextWord2; //GetNextWord1([]);
    if LowerCase(S) = AWord then
      Exit(true);
  end;
end;

function TSQLParser.GetToWord(AWord: string): string;
var
  S: String;
  P: TParserPosition;
begin
  P:=Position;
  Result:='';
  while not Eof do
  begin
    SkipSpace;
    S:=GetNextWord;
    if LowerCase(S)=LowerCase(AWord) then
    begin
      Result:=Copy(SQL, P.Position, Position.Position - P.Position);
      Exit;
    end;
  end;
end;

function TSQLParser.GetToCommandDelemiter: string;
var
  CP: Integer;
begin
  CP:=Position.Position;
  Result:=GetToWord(CommandDelemiter);
  if Result = '' then
    Result:=Copy(FSql, CP, Length(FSql))
end;

function TSQLParser.GetToBracket(Bracket: string): string;
var
  S:string;
  L:integer;
  fStart: Char;
  StartPos: TParserPosition;
begin
  Result:='';
  if Bracket = ')' then fStart:='('
  else
  if Bracket = ']' then
    fStart:='['
  else
    exit;

  L:=0;
  StartPos:=Position;
  while (Position.Position < Length(FSql)) do
  begin
    SkipSpace;
    WordPosition:=Position;
    S:=GetNextWord1([]);
    if S = fStart then
      Inc(L)
    else
    if S=Bracket then
    begin
      if L > 0 then
        Dec(L)
      else
      begin
        Result:=Copy(FSql, StartPos.Position, WordPosition.Position - StartPos.Position);
        break;
      end;
    end;
  end;
end;

//Пропуск коментария типа : --
procedure TSQLParser.SkipComment1;
var
  P: TParserPosition;
begin
  P:=Position;
  while (Position.Position < Length(FSql)) do
  begin
    if (FSql[Position.Position]=#13) or (FSql[Position.Position]=#10) then
    begin
      SkipSpace;
      if Assigned(FOnProcessComment) then
        FOnProcessComment(Self, Copy(FSql, P.Position, Position.Position - P.Position));
      break;
    end
    else
      IncPos;
  end;
end;

procedure TSQLParser.SkipComment2;
var
  P: TParserPosition;
begin
  P:=Position;
  WaitWord('*/');
  if Assigned(FOnProcessComment) then
    FOnProcessComment(Self, Copy(FSql, P.Position, Position.Position - P.Position - Length('*/') ));
  SkipSpace;
end;

procedure TSQLParser.ClearStatementList;
var
  i: Integer;
begin
  for i:=0 to FStatementList.Count-1 do
    TSQLTextStatement(FStatementList[i]).Free;
  FStatementList.Clear;
end;

procedure TSQLParser.DoTestLineEnd;
begin
  if FSql[Position.Position] <> LineEnding then exit;
  Inc(FPosition.Y);
  FPosition.X:=0;
end;

procedure TSQLParser.IncPos( ACountChar:Integer = 1);
var
  i: Integer;
begin
  if ACountChar > 0 then
  begin
    for i:=1 to ACountChar do
      FPosition.Position:=FPosition.Position + UTF8CharacterLength( @FSql[FPosition.Position]);
  end
  else
    Inc(FPosition.Position, ACountChar); //Плохое решение - будем думать!
  Inc(FPosition.X, ACountChar);
end;

constructor TSQLParser.Create(const ASql: string; const AOwner: TObject);
begin
  inherited Create;
  FIgnoreError:=false;
  FOwner:=AOwner;
  FStatementList:=TFPList.Create;
  FCommandDelemiter:=';';
  FCurrentStringDelemiter:='';
  SetSQL(ASql);
end;

destructor TSQLParser.Destroy;
begin
  ClearStatementList;
  FreeAndNil(FStatementList);
  inherited Destroy;
end;

procedure TSQLParser.SetSQL(ASQL: string);
begin
  FSql:=ASql;
  FPosition.Position:=1;
  FPosition.Y:=1;
  FPosition.X:=1;
end;

function TSQLParser.GetNextWord2: string;
var
  StartPos: TParserPosition;
begin
  Result:='';
  while (not Eof) and (FSql[FPosition.Position] <= ' ') do
  begin
    DoTestLineEnd;
    IncPos;
  end;
  if Eof then exit;

  StartPos:=Position;

  if FSql[FPosition.Position]='/' then
  begin
    IncPos;
    if (not Eof) and (FSql[FPosition.Position]='*') then
    begin
      Result:='/*';
      IncPos;
      exit;
    end;
  end;

  if FSql[FPosition.Position]='*' then
  begin
    IncPos;
    if (not Eof) and (FSql[FPosition.Position] = '/') then
    begin
      Result:='*/';
      IncPos;
    end
    else
      Result:='*';
    exit;
  end;

  if (FSql[FPosition.Position] = '-') and (FPosition.Position < Length(FSql)) and (FSql[FPosition.Position + 1] = '-') then
  begin
    Result:='--';
    IncPos;
    IncPos;
  end;

  if (FSql[FPosition.Position] in (['''', '"', '`'] + CharDelimiters)) then
    IncPos
  else
  begin
    repeat
      DoTestLineEnd;
      IncPos;
    until (FPosition.Position >= Length(FSql)) or (FSql[FPosition.Position] < #33) or (not (FSql[FPosition.Position] in {(['a'..'z','A'..'Z','0'..'9', '_', '$']) }SQLValidChars));
  end;
  SetLength(Result, FPosition.Position - StartPos.Position);
  Move(FSql[StartPos.Position], Result[1], Position.Position - StartPos.Position);
end;

procedure TSQLParser.ParseScript(AFromBegin: boolean = true);
var
  P: TSQLTextStatement;
  StartX: Integer;
  StartY: Integer;
  S, S1: String;
  L: Integer;
  FNewComman: Boolean;
  sPos: TParserPosition;
begin
  ClearStatementList;
  if FSql = '' then exit;

  if AFromBegin then
  begin
    FPosition.Position:=1;
    FPosition.X:=1;
    FPosition.Y:=1;
  end;

  StartX:=FPosition.X;
  StartY:=FPosition.Y;
  L:=FPosition.Position;

  while not Eof do
  begin
    S:=UpperCase(GetNextWord);
    if FNewComman then
    begin
      StartX:=WordPosition.X;
      StartY:=WordPosition.Y;
      FNewComman:=false;
    end;

    if ParserSintax = siFirebird then
    begin
      if (S = 'CREATE') or (S = 'ALTER') or (S = 'EXECUTE') then
      begin
        sPos:=Position;
        S1:=UpperCase(GetNextWord);
        if (((S = 'CREATE') or (S = 'ALTER')) and ((S1 = 'PROCEDURE') or (S1 = 'TRIGGER'))) or ((S = 'EXECUTE') and (S1 = 'BLOCK')) then
          GetToEndpSQL(Self)
        else
          Position:=sPos;
      end;
    end;

    if (S = CommandDelemiter) or (S = 'ELSE') or (S='BEGIN') or (S='THEN') or (S='ELSEIF') or (S='LOOP') then
    begin
      P:=TSQLTextStatement.Create(Self);
      P.FPosStart.X:=StartX;
      P.FPosStart.Y:=StartY;
      P.FPosEnd.X:=FPosition.X;
      P.FPosEnd.Y:=FPosition.Y;
      P.FText:=Copy(FSql, L, FPosition.Position - L);
      L:=FPosition.Position;
      FNewComman:=true;
    end
    else
    if (Length(S)>2) and (S[1]='$') and (S[Length(S)] = '$') then
    begin
      WaitWord(S);
    end;

  end;

  if L < FPosition.Position then
  begin
    P:=TSQLTextStatement.Create(Self);
    P.FPosStart.X:=StartX;
    P.FPosStart.Y:=StartY;
    P.FPosEnd.X:=FPosition.X;
    P.FPosEnd.Y:=FPosition.Y;
    if FSql[FPosition.Position - L] = ';' then
      P.FText:=Copy(FSql, L, FPosition.Position - L)
    else
      P.FText:=Copy(FSql, L, FPosition.Position - L + 1);
    L:=FPosition.Position;
    StartX:=FPosition.X+1;
    StartY:=FPosition.Y;
  end;
end;

procedure TSQLParser.InsertText(AText: string);
begin
  FSql:=Copy(FSql, 1, FPosition.Position-1) + AText + Copy(FSql, FPosition.Position, Length(FSql));
  Inc(FPosition.Position, Length(AText));
  Inc(FPosition.X, UTF8Length(AText));
end;

procedure TSQLParser.DeleteText(ATextLen: integer);
begin
  Delete(FSql, FPosition.Position, ATextLen);
end;

class function TSQLParser.WordType(Sender: TSQLTokenRecord; AWord: string;
  ACmd: TSQLCommandAbstract): TSQLToken;

function IsValidIdent1(S:string):boolean;
var
  S1, S2:string;
  i:integer;
begin
  i:=Pos('.', S);
  if i>0 then
  begin
    S1:=Copy(S, 1, i-1);
    S2:=Copy(S, i+1, Length(S));
    Result:=DBIsValidIdent(S1) and DBIsValidIdent(S2);
  end
  else
    Result:=DBIsValidIdent(S);
end;

var
  I, C:Integer;
  R:Double;
  P: TSQLTokenRecord;
begin
  if IsValidIdent1(AWord) then
  begin
    if Assigned(Sender) then
      for i:=0 to Sender.Child.Count-1 do
      begin
        P:=TSQLTokenRecord(Sender.Child[i]);
        if P.SQLCommand = UpperCase(AWord) then
        begin
          Result:=P.Token;
          exit;
        end;
      end;
    if Assigned(ACmd) then
      if ACmd.FindKeyWord(UpperCase(AWord)) then
      begin
        Result:=stKeyword;
        Exit;
      end;
    Result:=stIdentificator
  end
  else
  if ((Length(AWord) = 1) and (AWord[1] in (CharDelimiters + ['=', '<', '>', '+', '-', '^', '[', ']', ':', '\', '*', '@']))) then
    Result:=stSymbol
  else
  if (Length(AWord)>1) and (AWord[1]='$') and (AWord[Length(AWord)]='$') then
    Result:=stTerminator
  else
  if (AWord = ';') then
    Result:=stDelimiter
  else
  if (Length(AWord)>1) and (AWord[1]='''') and (AWord[Length(AWord)]='''') then
    Result:=stString
  else
  if (Length(AWord)>1) and (AWord[1]='"') and (AWord[Length(AWord)]='"') then
    Result:=stIdentificator
  else
  if (Length(AWord)>1) and (AWord[1]='`') and (AWord[Length(AWord)]='`') then
    Result:=stIdentificator
  else
  begin
    Val(AWord, I, C);
    if C = 0 then
      Result:=stInteger
    else
    begin
      Val(AWord, R, C);
      if C = 0 then
        Result:=stFloat
      else
        Result:=stNone;
    end;
  end
end;

function TSQLParser.GetCommentForEOL: string;
var
  FStop:boolean;
  K, L:integer;
begin
  { TODO : Необходимо реализовать процедуру - выбирает из текущий строки коментарии с текущего места и до конца линиии }
  Result:='';

  FStop:=false;
  K:=FPosition.Position;
  while (K < Length(FSql)) and not FStop do
  begin
    if (FSql[K]=#13) or (FSql[K]=#10) then
      FStop:=true
    else
    if (FSql[K]='-') and (FSql[K + 1]='-') then
    begin
      FStop:=true;
      L:=K+2;
      while (L<=Length(FSql)) and (not (FSql[L] in [#10, #13])) do
        inc(L);
      Result:=Trim(Copy(FSql, K+2, L - K - 2));
    end
    else
    if (FSql[K]='/') and (FSql[K+1]='*') then
    begin
      FStop:=true;
      L:=K + 2;
      while (L<=Length(FSql)) and (not (FSql[L] in [#10, #13])) do
      begin
        if L<=Length(FSql)-1 then
        begin
          if (FSql[L] = '*') and (FSql[L+1] = '/') then
            break;
        end
        else
          break;
        inc(L);
      end;
      Result:=Copy(FSql, K+2, L - K-2);
    end
    else
      Inc(K);
  end;
end;

function TSQLParser.Eof: boolean;
begin
  Result:=(Position.Position > Length(FSql));
end;

function TSQLParser.StatementAtXY(X, Y: integer): TSQLTextStatement;
var
  i: Integer;
begin
  { TODO : Доработать ситуацию нескольких запросов в одной строке }
  Result:=nil;
  for i:=0 to StatementCount - 1 do
  begin
    if (Y >= Statements[i].PosStart.Y) and (Y <= Statements[i].PosEnd.Y) then
    begin
      Result:=Statements[i];
      exit;
    end;
  end;
end;

{ TSQLCommandInsert }

function TSQLCommandInsert.GetParams: TSQLFields;
begin
  if Assigned(FSelectCmd) then
    Result:=FSelectCmd.Params
  else
    Result:=inherited GetParams;
end;

procedure TSQLCommandInsert.InitParserTree;
var
  TSymb, TExp, TA, T, TN, FSQLTokens, FShemName, FSubSelect,
    FTblName, FTblInsField, TDEF, T1, T2, T2_1, T2_2: TSQLTokenRecord;
begin
  inherited InitParserTree;
  FPlanEnabled:=false;
  FFields:=TSQLFields.Create;
  FParams:=TSQLFields.Create;

  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'insert', [toFirstToken]);
    TN:=AddSQLTokens(stKeyword, FSQLTokens, 'into', [toFindWordLast]); //

  FShemName:=AddSQLTokens(stIdentificator, TN, '', [], 1); //
    TSymb:=AddSQLTokens(stSymbol, FShemName, '.', []);    //если есть - то было имя схемы
    FTblName:=AddSQLTokens(stIdentificator, TSymb, '', [], 2);  //Если была схема - то имя таблицы

  TSymb:=AddSQLTokens(stSymbol, FShemName, '(', []); //
    FTblName.AddChildToken(TSymb);
  FTblInsField:=AddSQLTokens(stIdentificator , TSymb, '', [], 3);
    TSymb:=AddSQLTokens( stSymbol, FTblInsField, ',', [], 4);
    TSymb.AddChildToken(FTblInsField);
  TSymb:=AddSQLTokens( stSymbol, FTblInsField, ')', [], 5);

  T:=AddSQLTokens(stKeyword, TSymb, 'default', []);
    FShemName.AddChildToken(T);
  TDEF:=AddSQLTokens(stKeyword, T, 'values', [], 7);


  FSubSelect:=AddSQLTokens( stKeyword, TSymb, 'select', [], 6);
    FShemName.AddChildToken(FSubSelect);

  T:=AddSQLTokens(stKeyword , TSymb, 'values', [], 8);
    FShemName.AddChildToken(T);


  TSymb:=AddSQLTokens( stSymbol, T, '(', []);
    TA:=AddSQLTokens( stSymbol, TSymb, ':', [], 9);
    T:=AddSQLTokens( stIdentificator, [TSymb, TA], '', [], 10);
    T1:=AddSQLTokens( stString, TSymb, '', [], 10);
    T2:=AddSQLTokens( stInteger, TSymb, '', [], 10);
    T2_1:=AddSQLTokens( stFloat, TSymb, '', [], 10);
    T2_2:=AddSQLTokens(stKeyword, TSymb, 'DEFAULT', [], 10);


    TExp:=AddSQLTokens( stSymbol, [T, T1, T2, T2_1, T2_2], ',', [], 11);
      TExp.AddChildToken([TA, T, T1, T2, T2_1, T2_2]);

    TSymb:=AddSQLTokens( stSymbol, [T, T1, T2, T2_1, T2_2], ')', [], 12);

  T:=AddSQLTokens(stKeyword, [TDEF, TSymb, FSubSelect], 'RETURNING', [toOptional], 13);
  T:=AddSQLTokens(stKeyword, T, 'INTO', [toOptional], 14);
(*
[ WITH [ RECURSIVE ] with_query [, ...] ]
INSERT INTO table [ ( column [, ...] ) ]
    { DEFAULT VALUES | VALUES ( { expression | DEFAULT } [, ...] ) [, ...] | query }
    [ RETURNING * | output_expression [ [ AS ] output_name ] [, ...] ]
*)
end;

procedure TSQLCommandInsert.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:begin
         TableName:=AWord;
         FSelectable:=Pos('RETURNING', UpperCase(ASQLParser.SQL)) > 0;
      end;
    2:begin
        SchemaName:=TableName;
        TableName:=AWord;
      end;
    3:FCurField:=Fields.AddParam(AWord);
    4, 5:FCurField:=nil;
    6:FInsertType:=sitSelect;
    7:FInsertType:=sitDefaultValues;
    8:FInsertType:=sitValues;
    9:begin
        FCurParam:=Params.AddParam(AWord);
        FCurParam.InReturn:=spvtInput;
      end;
    10:begin
        if not Assigned(FCurParam) then
          FCurParam:=Params.AddParam(AWord);
        FCurParam.Caption:=AWord;
      end;
    11,12:FCurParam:=nil;
  end;
(*
if T.Token = stParamInsert then
begin
  F:=TSQLParserField.Create;
  F.Caption:=S;
  FParams.Add(F);
end
else
else
if (Child = FTblInsField) then
  F:=FFields.AddParam(S)
else
if Child = FSubSelect then
begin
  Stop:=true;
  FSelectCmd:=TSQLCommandSelect.Create(FSQLEngine);
  SQLParser.UnGetWord(S);
  FSelectCmd.ParseSQL(SQLParser);
end;
*)
end;

destructor TSQLCommandInsert.Destroy;
begin
  if Assigned(FSelectCmd) then
    FreeAndNil(FSelectCmd);
  inherited Destroy;
end;

procedure TSQLCommandInsert.MakeSQL;
var
  i: Integer;
  Result, S: String;
  P: TSQLParserField;
begin
  Result:='INSERT INTO ';
  if SchemaName <> '' then
    Result:=Result + SchemaName + '.';
  Result:=Result + TableName;

  if Fields.Count > 0 then
    Result:=Result + ' (' + Fields.AsString + ')';

  if InsertType = sitSelect then
  begin
    if Assigned(SelectCmd) then
      Result:=Result + SelectCmd.AsSQL
  end
  else
  if InsertType = sitDefaultValues then
    Result:=Result + 'DEFAULT VALUES'
  else
  if InsertType = sitValues then
  begin
    S:='';
    for P in Params do
    begin
      if S<>'' then S:=S + ', ';
      S:=S + P.Caption;
    end;
    Result:=Result + ' VALUES (' + {Params.AsString} S + ')';

(*    {  | VALUES ( { expression | DEFAULT } [, ...] ) [, ...] | query }
    [ RETURNING * | output_expression [ [ AS ] output_name ] [, ...] ]
*)
  end;
  AddSQLCommand(Result);
end;

procedure TSQLCommandInsert.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLCommandInsert then
  begin
    if Assigned(TSQLCommandInsert(ASource).FSelectCmd) then
    begin
      if not Assigned(FSelectCmd) then
      begin
        FSelectCmd:=TSQLCommandSelect(TSQLCommandInsert(ASource).SelectCmd.ClassType.Create);
        FSelectCmd.Create(Self);
      end;
      SelectCmd.Assign(TSQLCommandInsert(ASource).SelectCmd);
    end
    else
    if Assigned(FSelectCmd) then
      FreeAndNil(FSelectCmd);
    InsertType:=TSQLCommandInsert(ASource).InsertType;
  end;
  inherited Assign(ASource);
end;

{ TSQLCommandDelete }

procedure TSQLCommandDelete.InitParserTree;
var
  T, FSQLTokens, FShemaName, FTableName: TSQLTokenRecord;
begin
  inherited InitParserTree;
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'delete', [toFirstToken, toFindWordLast]);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'from', []);

  FShemaName:=AddSQLTokens(stIdentificator, T, '', [], 1);  //Имя таблицы
    T:=AddSQLTokens(stSymbol, FShemaName, '.', []);    //если есть - то было имя схемы
    FTableName:=AddSQLTokens(stIdentificator, T, '', [], 2);  //Если была схема - то имя таблицы

  T:=AddSQLTokens(stKeyword, [FShemaName, FTableName], 'where', [toOptional], 3);
end;

procedure TSQLCommandDelete.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:TableName:=AWord;
    2:begin
        SchemaName:=TableName;
        TableName:=AWord
      end;
    3:WhereStr:=ASQLParser.GetToCommandDelemiter;
  end;
end;

procedure TSQLCommandDelete.MakeSQL;
var
  S: String;
begin
  S:='DELETE' + LineEnding + 'FROM' + LineEnding + '  ';
  if SchemaName<>'' then
    S:=S + SchemaName + '.';
  S:=S + TableName;

  if WhereStr<>'' then
  begin
    S:=S + LineEnding + 'WHERE';
    if WhereStr[1] in SQLValidChars then S:=S + LineEnding + '  ';
    S:=S + WhereStr;
  end;
  AddSQLCommand(S);
end;

procedure TSQLCommandDelete.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLCommandDelete then
  begin
    FWhereStr:=TSQLCommandDelete(ASource).FWhereStr;
  end;
  inherited Assign(ASource);
end;

{ TSQLTokenRecord }

constructor TSQLTokenRecord.Create;
begin
  inherited Create;
  FChild:=TSQLTokenList.Create;
  DBObjectKind:=okOther;
  FCountRef:=0;
end;

destructor TSQLTokenRecord.Destroy;
begin
  FreeAndNil(FChild);
  inherited Destroy;
end;

function TSQLTokenRecord.Equal(S: string): boolean;
begin
  Result:=UpperCase(S) = SQLCommand;
end;

function TSQLTokenRecord.ChildByName(S: string): TSQLTokenRecord;
var
  i:integer;
begin
  S:=UpperCase(S);
  Result:=nil;
  for i:=0 to Child.Count - 1 do
    if Child[i].SQLCommand = S then
    begin
      Result:=Child[i];
      exit;
    end;
end;

function TSQLTokenRecord.ChildByType(AToken: TSQLToken; AWord: string = ''): TSQLTokenRecord;
var
  P: TSQLTokenRecord;
begin
  Result:=nil;
  for P in Child do
  begin
    if (P.Token = AToken) then
    begin
      if not Assigned(Result) and (AToken <> stKeyword) then Result:=P;
      if (AWord <> '') and (P.SQLCommand = UpperCase(AWord)) then
      begin
        Result:=P;
        exit;
      end;
    end
  end;
end;

procedure TSQLTokenRecord.CopyChildTokens(ASQLToken: TSQLTokenRecord);
var
  P: TSQLTokenRecord;
begin
  if not Assigned(ASQLToken) then exit;
  for P in ASQLToken.Child do
    Child.Add(P);
end;

procedure TSQLTokenRecord.AddChildToken(AToken: TSQLTokenRecord);
var
  S: String;
begin
  if Assigned(AToken) then
  begin
    if (Child.IndexOf(AToken)<0) then
    begin
      Inc(AToken.FCountRef);
      Child.Add(AToken);
    end
    else
    begin
      S:=Format('(%s, (%s).%d) - AToken already in Childs (%s, (%s).%d)', [SQLTokenStr[Token], SQLCommand, Tag, SQLTokenStr[AToken.Token], AToken.SQLCommand, AToken.Tag]);
      raise Exception.Create(S);
    end;
  end
  else
    raise Exception.Create('AToken = nil');
end;

procedure TSQLTokenRecord.AddChildToken(ATokens: array of TSQLTokenRecord);
var
  T: TSQLTokenRecord;
begin
  for T in ATokens do
    AddChildToken(T);
end;

initialization
  SQLStatmentRecordArray:=TSQLStatmentRecords.Create;
finalization
  SQLStatmentRecordArray.Free;
end.

