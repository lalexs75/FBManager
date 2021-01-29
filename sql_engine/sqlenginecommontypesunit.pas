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

unit SQLEngineCommonTypesUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, db, contnrs, fbmStrConstUnit, sqlObjects;

type
  TTransactionIsolationLevel = (tilNone, tilReadUncommitted, tilReadCommitted, tilSerializable, tilRepeatableRead);
  TTransactionParam = (tilReadWrite, tilReadOnly, tilWait, tilNoWait, tilRecVersion, tilNoRecVersion, tilRestartRequests);
  TTransactionParams = set of TTransactionParam;

  TDBMSTypesGroup = (tgUnknow, tgNumericTypes, tgMonetaryTypes, tgCharacterTypes,
        tgBinaryDataTypes, tgDateTimeTypes, tgBooleanTypes,
        tgEnumeratedTypes, tgGeometricTypes, tgNetworkAddressTypes,
        tgBitStringTypes, tgTextSearchTypes, tgUUIDTypes, tgXMLTypes,
        tgArrays, tgCompositeTypes, tgObjectTypes, tgPseudoTypes,
        tgUserDefinedTypes);

  //type of action for foreign keys
  TAuthenticationType = (atOS, atServer);

  TTriggerType = (ttNone, ttBefore, ttAfter, ttInsert, ttUpdate, ttDelete, ttTruncate,
          ttRow, ttStatement, ttInsteadOf);
  TTriggerTypes = set of TTriggerType;

  TObjectGrant = (ogSelect,
                  ogInsert,
                  ogUpdate,
                  ogDelete,
                  ogExecute,
                  ogReference,
                  ogCreate,
                   ogRule,
                   ogTemporary,
                   ogTruncate,
                   ogTrigger,
                   ogUsage,
                   ogWGO,
                   ogConnect,
                   ogAll,

                   ogAlter,
                   ogAlterRoutine,
                   ogCreateRoutine,
                   ogCreateTablespace,
                   ogCreateUser,
                   ogCreateView,
                   ogDrop,
                   ogEvent,
                   ogFile,
                   ogIndex,
                   ogLockTables,
                   ogProcess,
                   ogProxy,
                   ogReload,
                   ogReplicationClient,
                   ogReplicationSlave,
                   ogShowDatabases,
                   ogShowView,
                   ogShutdown,
                   ogSuper,
                   ogMembership
                   );

  TObjectGrants = set of TObjectGrant;

  TDDLMode = (dmCreate, dmAlter); //Типы генерируемого DDL


  TSQLToken = (stNone,
               stIdentificator, stKeyword, stSymbol, stInteger, stTerminator, stFloat,
               stString, stDelimiter, stStdKeyType);

  TSQLTokens = set of TSQLToken;

  TExecuteSqlScriptProcessEvent = function(const AMsg:string; ALineNum:integer; SQLToken:TSQLToken):boolean of object;

  TSqlExecParam = (sepInTransaction, //Выполнять запрос в контексте транзакции (не для всех серверов)
                   sepShowCompForm,  //При выполнении запроса отобразить окно подтверждения компиляции
                   sepNotRefresh,     //Не рефрешить после компиляции
                   sepSystemExec
                   );
  TSqlExecParams = set of TSqlExecParam;

  TCharCaseOptions = (ccoUpperCase, ccoLowerCase, ccoNameCase,
      ccoFirstLetterCase, ccoNoneCase, ccoChangeCase);

  TTableCashedStateFlag = (csfLoadedPK, csfLoadedFK, csfLoadedUNQ, csfLoadedCHK);
  TTableCashedStateFlags = set of TTableCashedStateFlag;

const
(*
    okTasks : Result:=;
  *)

  DBObjectKindNames : array [TDBObjectKind] of string =
     (sOther,                 //okNone
      sDomain,                //okDomain
      sTable,                 //okTable
      sView,                  //okView
      sTrigger,               //okTrigger
      sStoredProcedure,       //okStoredProc
      sSequence,              //okSequence
      sException,             //okException
      sUDF,                   //okUDF
      sRole,                  //okRole
      sUser,                  //okUser
      sLogin,                 //okLogin
      sScheme,                //okScheme
      sGroup,                 //okGroup
      sIndex,                 //okIndex
      sTableSpace,            //okTableSpace
      sLanguage,              //okLanguage
      sCheckConstraint,       //okCheckConstraint
      sForeignKey,            //okForeignKey
      sPrimaryKey,            //okPrimaryKey
      sUniqueConstraint,      //okUniqueConstraint
      sField,                 //okAutoIncFields
      sRule,                  //okRule
      sOther,                 //okOther
      sTask,                  //okTasks
      sConversion,            //okConversion
      sDatabase,              //okDatabase
      sType,                  //okType
      sServer,                //okServer
      sColumn,                //okColumn
      sCharSet,               //okCharSet
      sCollation,             //okCollation
      sFilter,                //okFilter
      sParameter,             //okParameter
      sAccessMethod,          //okAccessMethod
      sAggregate,             //okAggregate
      sMaterializedView,      //okMaterializedView
      sCast,                  //okCast
      sConstraint,            //okConstraint
      sExtension,             //okExtension
      sForeignTable,          //okForeignTable
      sForeignDataWrapper,    //okForeignDataWrapper
      sForeignServer,         //okForeignServer
      sLargeObject,           //okLargeObject
      sPolicy,                //okPolicy
      sFunction,              //okFunction
      sEventTrigger,          //okEventTrigger
      sAutoIncFields,         //okAutoIncFields
      sFTSConfig,             //okFTSConfig
      sFTSDictionary,         //okFTSDictionary
      sFTSParser,             //okFTSParser
      sFTSTemplate,           //okFTSTemplate
      sPackage,               //okPackage
      sPackageBody,           //okPackageBody
      sTransform,             //okTransform
      sOperator,              //okOperator
      sOperatorClass,         //okOperatorClass
      sOperatorFamily,        //okOperatorFamily
      sUserMapping,           //okUserMapping
      sPartitionTable,        //okPartitionTable
      '',                     //okProcedureParametr
      ''                      //okFunctionParametr
      );

  DBObjectKindImages: array [TDBObjectKind] of integer =
     (-1, //okNone
       2, //okDomain
       3, //okTable
       4, //okView
       5, //okTrigger
       6, //okStoredProc
       7, //okSequence
       8, //okException
       9, //okUDF
       49, //okRole
       48, //okUser
       48, //okLogin
       12, //okScheme
       13, //okGroup
       14, //okIndex
       15, //okTableSpace
       33, //okLanguage
       17, //okCheckConstraint
       18, //okForeignKey
       19, //okPrimaryKey
       20, //okUniqueConstraint
       21, //okField
       59, //okRule
       22, //okOther
       62, //okTasks
       -1, //okConversion
       -1, //okDatabase
       -1, //okType
       82, //okServer
       -1, //okColumn
       -1, //okCharSet
       80, //okCollation
       -1, //okFilter
       -1, //okParameter
       -1, //okAccessMethod
       -1, //okAggregate
       54, //okMaterializedView
       -1, //okCast
       -1, //okConstraint,
       78, //okExtension
       87, //okForeignTable
       81, //okForeignDataWrapper
       84, //okForeignServer
       -1, //okLargeObject
       -1, //okPolicy
       13, //okFunction
       67, //okEventTrigger
       -1, //okAutoIncFields
       73, //okFTSConfig,
       74, //okFTSDictionary,
       75, //okFTSParser,
       76, //okFTSTemplate
       83, //okPackage
       -1, //okPackageBody
       -1, //okTransform
       -1, //okOperator
       -1, //okOperatorClass,
       -1, //okOperatorFamily,
       49, //okUserMapping
       88, //okPartitionTable
       -1, //okProcedureParametr
       -1  //okFunctionParametr
     );

  DBObjectKindFolderImages: array [TDBObjectKind] of integer =
     (-1, //okNone,
       2, //okDomain,
       3, //okTable,
       4, //okView,
       5, //okTrigger,
       6, //okStoredProc,
       7, //okSequence,
       8, //okException,
       9, //okUDF,
       49, //okRole,
       50, ///okUser,
       50, //okLogin
       21, //okScheme,
       49, //okGroup,
       14, //okIndex,
       15, //okTableSpace,
       34, //okLanguage,
       17, //okCheckConstraint,
       18, //okForeignKey
       19, //okPrimaryKey
       20, //okUniqueConstraint
       21, //okField
       60, //okRule
       22, //okOther
       61, //okTasks
       -1, //okConversion
       -1, //okDatabase
       -1, //okType
       82, //okServer
       -1, //okColumn
       -1, //okCharSet
       79, //okCollation
       -1, //okFilter
       -1, //okParameter
       -1, //okAccessMethod
       -1, //okAggregate
       54, //okMaterializedView
       -1, //okCast
       -1, //okConstraint
       77, //okExtension
       87, //okForeignTable
       81, //okForeignDataWrapper
       84, //okForeignServer
       -1, //okLargeObject
       -1, //okPolicy
       29, //okFunction
       67, //okEventTrigger
       -1, //okAutoIncFields
       69, //okFTSConfig,
       70, //okFTSDictionary,
       71, //okFTSParser,
       72, //okFTSTemplate
       83, //okPackage
       -1, //okPackageBody
       -1, //okTransform
       -1, //okOperator
       -1, //okOperatorClass,
       -1, //okOperatorFamily
       49, //okUserMapping
       3,  //okPartitionTable
       -1, //okProcedureParametr
       -1  //okFunctionParametr
       );


  SQLTokenStr : array [TSQLToken] of string =
     ('stNone',          //stNone,
      'stIdentificator', //stIdentificator
      'stKeywords',      //stKeyword
      'stSymbol',        //stSymbol
      'stInteger',       //stInteger
      'stTerminator',    //stTerminator
      'stFloat',         //stFloat
      'stString',        //stString
      'stDelimiter',     //stDelimiter
      'stStdKeyType'     //stStdKeyType
      );


type
  TSQLEngineMiscOptions = record
    VarPrefix:string;
    ObjectNamesCharCase:TCharCaseOptions;    //Приведение имён объектов к регистру (верхнему/нижнему)
  end;

  TQueryStatRecord = record
    SelectedRows: Cardinal;
    InsertedRows: Cardinal;
    UpdatedRows: Cardinal;
    DeletedRows: Cardinal;
  end;

type

  { TSQLEngineLogOptions }

  TSQLEngineLogOptions = class
  private
    FHistoryCountSQLEditor: integer;
    FLogFileCodePage: string;
    FLogFileMetadata: string;
    FLogFileSQLEditor: string;
    FLogFileSQLScript: string;
    FLogMetadata: boolean;
    FLogMetadataCustomCP: boolean;
    FLogMetadataSheduler: boolean;
    FLogSQLEditor: boolean;
    FLogSQLScript: boolean;
    FLogTimestamp: boolean;
  public
    constructor Create;
    procedure Store(AData:TDataSet);
    procedure Load(AData:TDataSet);

    property LogMetadataSheduler:boolean read FLogMetadataSheduler write FLogMetadataSheduler;
    property LogTimestamp:boolean read FLogTimestamp write FLogTimestamp;
    property LogMetadata:boolean read FLogMetadata write FLogMetadata;
    property LogMetadataCustomCP:boolean read FLogMetadataCustomCP write FLogMetadataCustomCP;
    property LogSQLEditor:boolean read FLogSQLEditor write FLogSQLEditor;
    property LogSQLScript:boolean read FLogSQLScript write FLogSQLScript;
    property LogFileMetadata:string read FLogFileMetadata write FLogFileMetadata;
    property LogFileSQLEditor:string read FLogFileSQLEditor write FLogFileSQLEditor;
    property LogFileSQLScript:string read FLogFileSQLScript write FLogFileSQLScript;
    property HistoryCountSQLEditor:integer read FHistoryCountSQLEditor write FHistoryCountSQLEditor;
    property LogFileCodePage:string read FLogFileCodePage write FLogFileCodePage;
  end;

  { TSQLEngineDisplayDataOptions }

  TSQLEngineDisplayDataOptions = class
  public
    FetchAllData:boolean;
  public
    procedure AssignFrom(ADataOptions:TSQLEngineDisplayDataOptions);
    procedure Store(AData:TDataSet);
    procedure Load(AData:TDataSet);
  end;

type
  TIndexFieldsEnumerator = class;
  TIndexItemsEnumerator = class;

  TIndexItem = class
    IndexName:string;
    IndexExpression:string;
    IndexField:string;
    Unique:boolean;
    Active:boolean;
    SortOrder:TIndexSortOrder;
    IsPrimary:boolean;
  end;
  TIndexItemClass = class of TIndexItem;

  { TIndexItems }

  TIndexItems = class
  private
    FIndexItemClass:TIndexItemClass;
    FList:TFPList;
    function GetCount: integer;
    function GetItems(AIndex: integer): TIndexItem;
  public
    constructor Create(AIndexItemClass:TIndexItemClass);
    destructor Destroy; override;
    procedure Clear;
    function Add(AIndexName:string):TIndexItem;
    function GetEnumerator: TIndexItemsEnumerator;
    property Items[AIndex:integer]:TIndexItem read GetItems; default;
    property Count:integer read GetCount;
  end;

  { TIndexItemsEnumerator }

  TIndexItemsEnumerator = class
  private
    FList: TIndexItems;
    FPosition: Integer;
  public
    constructor Create(AList: TIndexItems);
    function GetCurrent: TIndexItem;
    function MoveNext: Boolean;
    property Current: TIndexItem read GetCurrent;
  end;

  { TIndexField }

  TIndexField = class
    FieldName:string;
    SortOrder:TIndexSortOrder;
    NullPos:TIndexNullPos;
    CollateName:string;
    procedure Assign(Source: TIndexField);
    procedure LoadFromSQLFieldItem(SQLField:TSQLParserField);
  end;

  { TIndexFields }

  TIndexFields = class
  private
    FList:TObjectList;
    function GetAsString: string;
    function GetCount: integer;
    function GetItems(AIndex: integer): TIndexField;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Add(AFieldName:string):TIndexField;
    function GetEnumerator: TIndexFieldsEnumerator;
    property Items[AIndex:integer]:TIndexField read GetItems; default;
    property Count:integer read GetCount;
    property AsString:string read GetAsString;
  end;

  { TIndexFieldsEnumerator }

  TIndexFieldsEnumerator = class
  private
    FList: TIndexFields;
    FPosition: Integer;
  public
    constructor Create(AList: TIndexFields);
    function GetCurrent: TIndexField;
    function MoveNext: Boolean;
    property Current: TIndexField read GetCurrent;
  end;

  { TPrimaryKeyRecord }

  TPrimaryKeyRecord = class
  private
    FFieldList: string;
    FFieldListArr: TSQLFields;
    procedure SetFieldList(AValue: string);
  public
    Name:string;
    IndexName:string;
    Index:TIndexItem;
    ConstraintType:TConstraintType;
    Description:string;
    constructor Create;
    destructor Destroy; override;
    function CountFields:integer;
    function FieldByNum(ANum:integer):string;
    property FieldList:string read FFieldList write SetFieldList;
    property FieldListArr: TSQLFields read FFieldListArr;
  end;

  { TForeignKeyRecord }

  TForeignKeyRecord = class(TPrimaryKeyRecord)
    FKTableName:string;
    FKFieldName:string;
    OnUpdateRule:TForeignKeyRule;
    OnDeleteRule:TForeignKeyRule;
    constructor Create;
  end;

  { TUniqueRecord }

  TUniqueRecord = class(TPrimaryKeyRecord)
    constructor Create;
  end;

  { TTableCheckConstraintRecord }

  TTableCheckConstraintRecord = class(TPrimaryKeyRecord)
    SQLBody:string;
    constructor Create;
  end;

type
  //Элемент зависимости

  { TDependRecord }

  TDependRecord = class
    FieldList:TStringList;
    DependType:integer; //0 - зависит от текущего, 1 - текущий от чего-то
    //ObjectType:integer;
    ObjectName:string;
    ObjectKind:TDBObjectKind;
    constructor Create;
    destructor Destroy; override;
  end;

  { TDependRecordList }

  TDependRecordList = class(TObjectList)
    function FindDepend(ADependName:string):TDependRecord;
  end;

type
  TUserRoleGrant = class
    UserName:string;
    WithAdmOpt:boolean;
    GrantUserName:string;
  end;

type
  TKeywordType = (ktNone, ktKeyword, ktFunction, ktStdTypes);

type
  TKeyWordRecord = record
    Key:string;
    SQLToken:TSQLToken;
    Desc:string;
  end;

  { TKeywordList }

  TKeywordList = class
  private
    FKeywordType:TKeywordType;
    WordList:TStringList;
    function GetCaption: string;
    function GetCount: integer;
    function GetKeyWord(Index: integer): string;
  public
    constructor Create(AKeywordType:TKeywordType);
    destructor Destroy; override;
    procedure Add(AKeyWord:string; SQLToken:TSQLToken);
    function Find(const S:string):boolean;
    property Caption:string read GetCaption;
    property Count:integer read GetCount;
    property KeywordType:TKeywordType read FKeywordType;
    property KeyWord[Index:integer]:string read GetKeyWord; default;
  end;

type

  { TDBMSFieldTypeRecord }

  TDBMSFieldTypeRecord = class
  private
    FDescription: string;
  public
    TypeName:string;
    TypeId:integer;
    VarLen:boolean;
    VarDec:boolean;
    DBType:TFieldType;

    AltNames:TStringList;
    TypesGroup:TDBMSTypesGroup;
    { TODO : Необходимо ввести константы максимальной длинны и макс. длинно дробной части }
    constructor Create(const ATypeName:string; ATypeId:integer; AVarLen, AVarDec:boolean;
       ADBType:TFieldType; const AAltNames, ADesc:string; ATypesGroup:TDBMSTypesGroup);
    destructor Destroy; override;
    function GetFieldTypeStr(ALen, ADec:integer):string;
    property Description:string read FDescription write FDescription;
  end;

  { TDBMSFieldTypeList }
  TDBMSFieldTypeListEnumerator = class;

  TDBMSFieldTypeList = class
  private
    FList:TFPList;
    function GetCount: integer;
    function GetItems(AItem: integer): TDBMSFieldTypeRecord;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function FindType(const ATypeName:string):TDBMSFieldTypeRecord;
    function FindTypeByID(const ATypeID:integer):TDBMSFieldTypeRecord;
    procedure FillForTypes(const AItems:TStrings; const ClearItems:boolean);
    function GetEnumerator: TDBMSFieldTypeListEnumerator;
    function Add(const ATypeName:string; ATypeId:integer; AVarLen, AVarDec:boolean; ADBType:TFieldType; const AAltNames, ADesc:string; ATypesGroup:TDBMSTypesGroup):TDBMSFieldTypeRecord;
    procedure Remove(AItem:TDBMSFieldTypeRecord);
    property Items[AItem:integer]:TDBMSFieldTypeRecord read GetItems; default;
    property Count:integer read GetCount;
  end;

  { TDBMSFieldTypeListEnumerator }

  TDBMSFieldTypeListEnumerator = class
  private
    FList: TDBMSFieldTypeList;
    FPosition: Integer;
  public
    constructor Create(AList: TDBMSFieldTypeList);
    function GetCurrent: TDBMSFieldTypeRecord;
    function MoveNext: Boolean;
    property Current: TDBMSFieldTypeRecord read GetCurrent;
  end;


  { TLocalVariable }

  TLocalVariable = class(TObject)
  private
    FDesc: string;
    FSPVarType: TSPVarType;
    FTypeName: string;
    FVarName: string;
  public
    constructor Create(const AVarName, ATypeName, ADesc:string; ASPVarType:TSPVarType);
    constructor CreateFrom(const AParam:TSQLParserField);
    destructor Destroy; override;
    function SPVarTypeStr:string;
  public
    property VarName:string read FVarName write FVarName;
    property TypeName:string read FTypeName write FTypeName;
    property Desc:string read FDesc write FDesc;
    property SPVarType:TSPVarType read FSPVarType write FSPVarType;
  end;

const
  ForeignKeyRuleNames : array [TForeignKeyRule] of string =
    ('NONE', 'CASCADE', 'SET NULL', 'SET DEFAULT', 'RESTRICT');

  IndexSortOrderNames : array [TIndexSortOrder] of string =
    ('', 'ASCENDING', 'DESCENDING');

const
  ObjectGrantNames  : array [TObjectGrant] of string =
   ('SELECT',          //ogSelect,
    'INSERT',          //ogInsert,
    'UPDATE',          //ogUpdate,
    'DELETE',          //ogDelete,
    'EXECUTE',         //ogExecute,
    'REFERENCES',      //ogReference,
    'CREATE',          //ogCreate,
    'RULE',            //ogRule,
    'TEMPORARY',       //ogTemporary,
    'TRUNCATE',        //ogTruncate,
    'TRIGGER',         //ogTrigger,
    'USAGE',           //ogUsage,
    '',           //ogWgr,
    'CONNECT',         //ogConnect,
    'ALL',             //ogAll,
    '',                //ogAlter,
    '',                //ogAlterRoutine
    '',                //ogCreateRoutine
    '',                //ogCreateTablespace
    '',                //ogCreateUser
    '',                //ogCreateView
    '',                //ogDrop
    '',                //ogEvent
    '',                //ogFile
    '',                //ogIndex
    '',                //ogLockTables
    '',                //ogProcess
    '',                //ogProxy
    '',                //ogReload
    '',                //ogReplicationClient
    '',                //ogReplicationSlave
    '',                //ogShowDatabases
    '',                //ogShowView
    '',                //ogShutdown
    '',                //ogSuper
    ''                 //ogMembership
    );

  ObjectGrantAll = [ogSelect, ogInsert, ogUpdate, ogDelete, ogReference];

  ObjectGrantNamesReal  : array [TObjectGrant] of string =
   ('ogSelect',
    'ogInsert',
    'ogUpdate',
    'ogDelete',
    'ogExecute',
    'ogReference',
    'ogCreate',
    'ogRule',
    'ogTemporary',
    'ogTruncate',
    'ogTrigger',
    'ogUsage',
    'ogWGO',
    'ogConnect',
    'ogAll',
    'ogAlter',
    'ogAlterRoutine',
    'ogCreateRoutine',
    'ogCreateTablespace',
    'ogCreateUser',
    'ogCreateView',
    'ogDrop',
    'ogEvent',
    'ogFile',
    'ogIndex',
    'ogLockTables',
    'ogProcess',
    'ogProxy',
    'ogReload',
    'ogReplicationClient',
    'ogReplicationSlave',
    'ogShowDatabases',
    'ogShowView',
    'ogShutdown',
    'ogSuper',
    'ogMembership'
    );
const

  IntegerDataTypes = [ftSmallint, ftInteger, ftWord, ftLargeint, ftAutoInc];

  NumericDataTypes = IntegerDataTypes + [ftFloat, ftCurrency, ftBCD];

  DataTimeTypes = [ftTime, ftDateTime, ftTimeStamp, ftDate];

  StringTypes = [ftString, {ftMemo,} ftFixedChar, ftWideString, ftFixedWideChar, ftWideMemo];

  dbFieldTypesCharacter : set of TFieldType =
       [ftString, ftMemo, ftFmtMemo, ftFixedChar, ftWideString,
        ftFixedWideChar, ftWideMemo];
  DDLRemarkLineLength     = 80;

function StrToForeignKeyRule(RuleName:string):TForeignKeyRule;
function ObjectGrantToStr(AGrant:TObjectGrants; AllPrivilegesShortForm:boolean):string;

procedure FillObjKindToImagesIndex(List:TStrings);
function ObjectKindToStr(ADBObjectKind:TDBObjectKind):string; inline;
function ParamTypeFuncToStr(AType:TSPVarType):string;

function ObjectGrantNameToValue(AValue:string):TObjectGrant;
implementation
uses
  math, strutils;

function StrToForeignKeyRule(RuleName: string): TForeignKeyRule;
begin
  RuleName:=UpperCase(RuleName);
  for Result in TForeignKeyRule do
    if UpperCase(RuleName) = ForeignKeyRuleNames[Result] then
      exit;
  Result:=fkrNone;
end;

function ObjectGrantToStr(AGrant: TObjectGrants; AllPrivilegesShortForm: boolean): string;
var
  i:TObjectGrant;
begin
  if (AGrant = ObjectGrantAll) or (ogAll in AGrant) then
  begin
    Result := 'ALL';
    if not AllPrivilegesShortForm then
      Result:=Result + ' PRIVILEGES';
  end
  else
  begin
    Result:='';
    for i:=low(TObjectGrant) to High(TObjectGrant) do
      if (i in AGrant) and (i<>ogWGO) then
        Result:=Result + ObjectGrantNames[i] + ', ';
    Result:=Copy(Result, 1, Length(Result)-2);
  end;
end;

procedure FillObjKindToImagesIndex(List: TStrings);

procedure DoAdd(AObjKind:TDBObjectKind; Index:integer);
begin
  List.Add(IntToStr(Ord(AObjKind)) + '=' + IntToStr(Index));
end;

var
  P: TDBObjectKind;
begin
  List.Clear;
  for P in TDBObjectKind do
    DoAdd(P, DBObjectKindImages[P]);
(*
  DoAdd(okDomain, 2);
  DoAdd(okTable, 3);
  DoAdd(okPartitionTable, 3);
  DoAdd(okView, 4);
  DoAdd(okTrigger, 5);
  DoAdd(okStoredProc, 6);
  DoAdd(okSequence, 7);
  DoAdd(okException, 8);
  DoAdd(okUDF, 9);
  DoAdd(okRole, 10);
  DoAdd(okUser, 48);
  DoAdd(okScheme, 22);
  DoAdd(okGroup, 50);
  DoAdd(okIndex, 54);
  DoAdd(okTableSpace, 15);
  DoAdd(okLanguage, -1);
  DoAdd(okCheckConstraint, 52);
  DoAdd(okForeignKey, 53);
  DoAdd(okPrimaryKey, 55);
  DoAdd(okUniqueConstraint, 56);
  DoAdd(okOther, -1); *)
end;

function ObjectKindToStr(ADBObjectKind: TDBObjectKind): string;
begin
  Result:=DBObjectKindNames[ADBObjectKind]
end;

function ParamTypeFuncToStr(AType: TSPVarType): string;
begin
  case AType of
    spvtLocal:Result:='VARIADIC';
    spvtInput:Result:='IN';
    spvtOutput:Result:='OUT';
    spvtInOut:Result:='INOUT';
//    ioTable:Result:='TABLE';
    spvtVariadic:Result:='VARIADIC';
    spvtTable:Result:='TABLE';
  else
    Result:='';
  end;
end;

function ObjectGrantNameToValue(AValue: string): TObjectGrant;
var
  G: TObjectGrant;
begin
  AValue:=UpperCase(AValue);
  for G in TObjectGrant do
    if UpperCase(ObjectGrantNamesReal[G]) = AValue then
      Exit(G);
  raise Exception.CreateFmt('Not found grant type "%s".', [AValue]);
end;

{ TIndexItemsEnumerator }

constructor TIndexItemsEnumerator.Create(AList: TIndexItems);
begin
  FList := AList;
  FPosition := -1;
end;

function TIndexItemsEnumerator.GetCurrent: TIndexItem;
begin
  Result := FList[FPosition];
end;

function TIndexItemsEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TIndexItems }

function TIndexItems.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TIndexItems.GetItems(AIndex: integer): TIndexItem;
begin
  Result:=TIndexItem(FList[AIndex]);
end;

constructor TIndexItems.Create(AIndexItemClass: TIndexItemClass);
begin
  inherited Create;
  FIndexItemClass:=AIndexItemClass;
  FList:=TFPList.Create;
end;

destructor TIndexItems.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TIndexItems.Clear;
var
  i: Integer;
begin
  for i:=0 to FList.Count-1 do
    TIndexItem(FList[i]).Free;
  FList.Clear;
end;

function TIndexItems.Add(AIndexName: string): TIndexItem;
begin
  Result:=FIndexItemClass.Create;
  Result.IndexName:=AIndexName;
  FList.Add(Result);
end;

function TIndexItems.GetEnumerator: TIndexItemsEnumerator;
begin
  Result:=TIndexItemsEnumerator.Create(Self);
end;

{ TDBMSFieldTypeListEnumerator }

constructor TDBMSFieldTypeListEnumerator.Create(AList: TDBMSFieldTypeList);
begin
  FList := AList;
  FPosition := -1;
end;

function TDBMSFieldTypeListEnumerator.GetCurrent: TDBMSFieldTypeRecord;
begin
  Result := FList[FPosition];
end;

function TDBMSFieldTypeListEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TIndexField }

procedure TIndexField.Assign(Source: TIndexField);
begin
  if not Assigned(Source) then exit;
  FieldName:=Source.FieldName;
  SortOrder:=Source.SortOrder;
  NullPos:=Source.NullPos;
end;

procedure TIndexField.LoadFromSQLFieldItem(SQLField: TSQLParserField);
begin
//  SortOrder:TIndexSortOrder;
//  NullPos:TIndexNullPos;
//  CollateName:string;
end;

{ TIndexFieldsEnumerator }

constructor TIndexFieldsEnumerator.Create(AList: TIndexFields);
begin
  FList := AList;
  FPosition := -1;
end;

function TIndexFieldsEnumerator.GetCurrent: TIndexField;
begin
  Result := FList[FPosition];
end;

function TIndexFieldsEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TIndexFields }

function TIndexFields.GetItems(AIndex: integer): TIndexField;
begin
  Result:=TIndexField(FList[AIndex])
end;

function TIndexFields.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TIndexFields.GetAsString: string;
var
  I: TIndexField;
begin
  Result:='';
  for I in Self do
  begin
    if Result<>'' then Result:=Result + ',';
    Result:=Result + I.FieldName;
  end;
end;

constructor TIndexFields.Create;
begin
  inherited Create;
  FList:=TObjectList.Create;
end;

destructor TIndexFields.Destroy;
begin
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TIndexFields.Clear;
begin
  FList.Clear;
end;

function TIndexFields.Add(AFieldName: string): TIndexField;
begin
  Result:=TIndexField.Create;
  FList.Add(Result);
  Result.FieldName:=AFieldName;
end;

function TIndexFields.GetEnumerator: TIndexFieldsEnumerator;
begin
  Result:=TIndexFieldsEnumerator.Create(Self);
end;


{ TTableCheckConstraintRecord }

constructor TTableCheckConstraintRecord.Create;
begin
  inherited Create;
  ConstraintType:=ctTableCheck;
end;

{ TLocalVariable }

constructor TLocalVariable.Create(const AVarName, ATypeName, ADesc: string;
  ASPVarType: TSPVarType);
begin
  inherited Create;
  FDesc:=ADesc;
  FSPVarType:=ASPVarType;
  FTypeName:=ATypeName;
  FVarName:=AVarName;
end;

constructor TLocalVariable.CreateFrom(const AParam: TSQLParserField);
begin
  inherited Create;
  FDesc:=AParam.Description;
  FSPVarType:=AParam.InReturn;
  FVarName:=AParam.RealName;
  FTypeName:=AParam.TypeName;
  if AParam.TypeLen>0 then
  begin
    if AParam.TypePrec>0 then
      FTypeName:=Format(FTypeName + '(%d, %d)', [AParam.TypeLen, AParam.TypePrec])
    else
      FTypeName:=Format(FTypeName + '(%d)', [AParam.TypeLen]);
  end;
end;

destructor TLocalVariable.Destroy;
begin
  inherited Destroy;
end;

function TLocalVariable.SPVarTypeStr: string;
begin
  case FSPVarType of
    spvtLocal:Result:='local';
    spvtInput:Result:='input';
    spvtOutput:Result:='output';
    spvtInOut:Result:='inout';
  else
    Result:='';
  end;
end;

{ TSQLEngineLogOptions }

constructor TSQLEngineLogOptions.Create;
begin
  inherited Create;
  HistoryCountSQLEditor:=100;
end;

procedure TSQLEngineLogOptions.Store(AData: TDataSet);
begin
  AData.FieldByName('db_database_use_log_write_timestamp').AsBoolean:=LogTimestamp;
  AData.FieldByName('db_database_use_log_meta').AsBoolean:=LogMetadata;
  AData.FieldByName('db_database_use_log_editor').AsBoolean:=LogSQLEditor;
  AData.FieldByName('db_database_log_meta_filename').AsString:=LogFileMetadata;
  AData.FieldByName('db_database_log_editor_filename').AsString:=LogFileSQLEditor;
  //HistoryCountSQLEditor:=IniFile.ReadInteger(IniSection, 'HistoryCountSQLEditor', HistoryCountSQLEditor);
  AData.FieldByName('db_database_use_log_meta_custom_charset').AsBoolean:=LogMetadataCustomCP;
  AData.FieldByName('db_database_log_meta_custom_charset').AsString:=LogFileCodePage;

  AData.FieldByName('db_database_use_log_script_exec').AsBoolean:=LogSQLScript;
  AData.FieldByName('db_database_log_script_exec_filename').AsString:=LogFileSQLScript;
end;

procedure TSQLEngineLogOptions.Load(AData: TDataSet);
begin
  LogTimestamp:=AData.FieldByName('db_database_use_log_write_timestamp').AsBoolean;
  LogMetadata:=AData.FieldByName('db_database_use_log_meta').AsBoolean;
  LogSQLEditor:=AData.FieldByName('db_database_use_log_editor').AsBoolean;
  LogFileMetadata:=AData.FieldByName('db_database_log_meta_filename').AsString;
  LogFileSQLEditor:=AData.FieldByName('db_database_log_editor_filename').AsString;
  //HistoryCountSQLEditor:=IniFile.ReadInteger(IniSection, 'HistoryCountSQLEditor', HistoryCountSQLEditor);
  LogMetadataCustomCP:=AData.FieldByName('db_database_use_log_meta_custom_charset').AsBoolean;
  LogFileCodePage:=AData.FieldByName('db_database_log_meta_custom_charset').AsString;
  LogSQLScript:=AData.FieldByName('db_database_use_log_script_exec').AsBoolean;
  LogFileSQLScript:=AData.FieldByName('db_database_log_script_exec_filename').AsString;
end;

{ TPrimaryKeyRecord }

procedure TPrimaryKeyRecord.SetFieldList(AValue: string);
var
  C:integer;
begin
  FFieldList:=AValue;
  FFieldListArr.Clear;
  if Pos(',', AValue) > 0 then
  begin
    C:=Pos(',', AValue);
    while C>0 do
    begin
      FFieldListArr.AddParam(Copy2SymbDel(AValue, ','));
      C:=Pos(',', AValue);
    end;
  end;
  if AValue <> '' then
    FFieldListArr.AddParam(AValue);
end;

constructor TPrimaryKeyRecord.Create;
begin
  inherited Create;
  ConstraintType:=ctPrimaryKey;
  //FFieldListArr:=TStringList.Create;
  FFieldListArr:=TSQLFields.Create;
end;

destructor TPrimaryKeyRecord.Destroy;
begin
  FreeAndNil(FFieldListArr);
  inherited Destroy;
end;

function TPrimaryKeyRecord.CountFields: integer;
begin
  Result:=Max(1, FFieldListArr.Count);
end;

function TPrimaryKeyRecord.FieldByNum(ANum: integer): string;
begin
  if ANum > CountFields - 1 then
    raise Exception.CreateFmt('Ошибка поиска поля по номеру %d', [ANum])
  else
  if FFieldListArr.Count = 0 then
    Result:=FFieldList
  else
    Result:=FFieldListArr[ANum].Caption;
end;

{ TForeignKeyRecord }

constructor TForeignKeyRecord.Create;
begin
  inherited Create;
  ConstraintType:=ctForeignKey;
end;

{ TDependRecord }

constructor TDependRecord.Create;
begin
  inherited Create;
  FieldList:=TStringList.Create;
end;

destructor TDependRecord.Destroy;
begin
  FreeAndNil(FieldList);
  inherited Destroy;
end;

{ TDependRecordList }

function TDependRecordList.FindDepend(ADependName: string): TDependRecord;
var
  i:integer;

begin
  Result:=nil;
  for i:=0 to Count - 1 do
  begin
    if TDependRecord(Items[i]).ObjectName = ADependName then
    begin
      Result:=TDependRecord(Items[i]);
      exit;
    end;
  end;
end;

{ TSQLEngineDisplayDataOptions }

procedure TSQLEngineDisplayDataOptions.AssignFrom(
  ADataOptions: TSQLEngineDisplayDataOptions);
begin
  if not Assigned(ADataOptions) then exit;
  FetchAllData:=ADataOptions.FetchAllData;
end;

procedure TSQLEngineDisplayDataOptions.Store(AData: TDataSet);
begin
  //IniFile.WriteBool(IniSection, 'FetchAllData', FetchAllData);
end;

procedure TSQLEngineDisplayDataOptions.Load(AData: TDataSet);
begin
  //FetchAllData:=IniFile.ReadBool(IniSection, 'FetchAllData', FetchAllData);
end;

{ TKeywordList }

function TKeywordList.GetCaption: string;
begin
  case KeywordType of
    ktKeyword:Result:=sKeyWord;
    ktFunction:Result:=sKeyFunction;
    ktStdTypes:Result:=sKeyTypes;
  else
    result:='other'
  end;
end;

function TKeywordList.GetCount: integer;
begin
  Result:=WordList.Count;
end;

function TKeywordList.GetKeyWord(Index: integer): string;
begin
  Result:=WordList[Index];
end;

constructor TKeywordList.Create(AKeywordType:TKeywordType);
begin
  WordList:=TStringList.Create;
  WordList.Sorted:=true;
  WordList.CaseSensitive:=false;
  FKeywordType:=AKeywordType;
end;

destructor TKeywordList.Destroy;
begin
  WordList.Clear;
  FreeAndNil(WordList);
  inherited Destroy;
end;

procedure TKeywordList.Add(AKeyWord: string; SQLToken: TSQLToken);
var
  K:integer;
begin
  K:=WordList.Add(AKeyWord);
  WordList.Objects[k]:=TObject(IntPtr(ord(SQLToken)));
end;

function TKeywordList.Find(const S: string): boolean;
var
  i:integer;
begin
  Result:=WordList.Find(S, i);
end;

{ TDBMSFieldTypeList }

function TDBMSFieldTypeList.GetItems(AItem: integer): TDBMSFieldTypeRecord;
begin
  Result:=TDBMSFieldTypeRecord(FList[AItem]);
end;

constructor TDBMSFieldTypeList.Create;
begin
  inherited Create;
  FList:=TFPList.Create;
end;

destructor TDBMSFieldTypeList.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TDBMSFieldTypeList.Clear;
var
  P: TDBMSFieldTypeRecord;
begin
  for P in Self do P.Free;
  FList.Clear;
end;

function TDBMSFieldTypeList.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TDBMSFieldTypeList.FindType(const ATypeName: string
  ): TDBMSFieldTypeRecord;
var
  T: TDBMSFieldTypeRecord;
begin
  for T in Self do
    if (UpperCase(T.TypeName) = UpperCase(ATypeName)) or (T.AltNames.IndexOf(ATypeName)>-1) then
      Exit(T);
  Result:=nil;
end;

function TDBMSFieldTypeList.FindTypeByID(const ATypeID: integer
  ): TDBMSFieldTypeRecord;
var
  T: TDBMSFieldTypeRecord;
begin
  for T in Self do
    if (T.TypeId = ATypeID) then
      Exit(T);
  Result:=nil;
end;

procedure TDBMSFieldTypeList.FillForTypes(const AItems: TStrings; const ClearItems:boolean);
var
  P:TDBMSFieldTypeRecord;
begin
  if ClearItems then AItems.Clear;
  for P in Self do
    AItems.AddObject(P.TypeName, P);
end;

function TDBMSFieldTypeList.GetEnumerator: TDBMSFieldTypeListEnumerator;
begin
  Result:=TDBMSFieldTypeListEnumerator.Create(Self);
end;

function TDBMSFieldTypeList.Add(const ATypeName: string; ATypeId: integer;
  AVarLen, AVarDec: boolean; ADBType: TFieldType; const AAltNames,
  ADesc: string; ATypesGroup: TDBMSTypesGroup): TDBMSFieldTypeRecord;
begin
  Result:=TDBMSFieldTypeRecord.Create(ATypeName, ATypeId, AVarLen, AVarDec, ADBType, AAltNames, ADesc, ATypesGroup);
  FList.Add(Result);
end;

procedure TDBMSFieldTypeList.Remove(AItem: TDBMSFieldTypeRecord);
begin
  FList.Remove(AItem);
  AItem.Free;
end;

{ TDBMSFieldTypeRecord }

constructor TDBMSFieldTypeRecord.Create(const ATypeName: string;
  ATypeId: integer; AVarLen, AVarDec: boolean; ADBType: TFieldType;
  const AAltNames, ADesc: string; ATypesGroup: TDBMSTypesGroup);
begin
  inherited Create;
  TypeName:=ATypeName;
  TypeId:=ATypeId;
  VarLen:=AVarLen;
  VarDec:=AVarDec;
  DBType:=ADBType;
  FDescription:=ADesc;
  AltNames:=TStringList.Create;
  AltNames.Sorted:=true;
  AltNames.Text:=AAltNames;
  TypesGroup:=ATypesGroup;
end;

destructor TDBMSFieldTypeRecord.Destroy;
begin
  FreeAndNil(AltNames);
  inherited Destroy;
end;

function TDBMSFieldTypeRecord.GetFieldTypeStr(ALen, ADec: integer): string;
begin
  if VarLen and VarDec then
    Result:=Format('%s(%d,%d)', [TypeName, ALen, ADec])
  else
  if VarLen then
    Result:=Format('%s(%d)', [TypeName, ALen])
  else
    Result:=TypeName;
end;

{ TUniqueRecord }

constructor TUniqueRecord.Create;
begin
  inherited Create;
  ConstraintType:=ctUnique;
end;

end.

