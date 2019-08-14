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

unit SQLEngineAbstractUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, DB, SQLEngineCommonTypesUnit, contnrs,
  SQLEngineInternalToolsUnit, sqlObjects, fbmSqlParserUnit;

type
  ESQLEngineException = class(Exception);

type
  TDBObjectState = (sdboCreate, //Объект находится в стадии создания
                    sdboEdit,   //ОБъект находится в стадии редактирования (нормальное состояние)
                    sdboVirtualObject //Виртуальный объект - обычно содержит в себе настоящие объекты (например - список схем)
                    );

type
  TUIShowSysObject = (ussSystemTable, ussSystemDomain, ussSystemView, ussExpandObjectDetails);
  TUIShowSysObjects = set of TUIShowSysObject;

  TUIParam = (upSqlEditor, upUserName, upPassword, upLocal, upRemote);

  TUIParams = set of TUIParam;

  TUITableOption = (
             utRenameTable,     //Можно переименовывать таблицу
             utReorderFields,   //Можно переупорядочивать поля
             utAddFields,       //Можно добавлять поля
             utEditField,       //Можно редактировать поля
             utDropFields,      //Можно удалять поля
             utAddFK,           //Можно добавлять FK
             utEditFK,          //Можно редактировать FK
             utDropFK,          //Можно удалять FK
             utAddUNQ,          //Можно добавлять уникальность
             utEditUNQ,         //Можно изменять уникальность
             utDropUNQ,         //Можно удалять уникальность
             utAlterAddFieldInitialValue, //Изменять поле - устанавливать начальное значение
             utAlterAddFieldFK,           //Изменять поле - добавлять FK
             utSetFKName,                 //Можно устанавливать имя индекса для FK
             utAddPrimaryKey,   //Можно добавлять PK
             utDropPrimaryKey   //Можно удалять PK
             );
  
  TUITableOptions = set of TUITableOption;

  TSQLEngileFeature = (
    feDescribeObject,
    fePKAutoName,
    feComputedTableFields,
    feInheritedTables,
    feFieldDepsList,
    feDescribeTableConstraint);

  TSQLEngileFeatures = set of TSQLEngileFeature;

  TDBFieldOption = (foNotNull, foLocal, foPrimaryKey, foSystemFiled,
     foAutoInc, foComputed);

  TDBFieldOptions = set of TDBFieldOption;
type
  TSQLEngineAbstract = class;
  TACLListAbstract = class;
  TDBObject = class;
  TDBRootObject = class;
  TDBObjectClass = class of TDBObject;
  TDBRootObjectClass = class of TDBRootObject;

  TDBDataSetObject = class;
  TDBTableObject = class;
  TDBTriggerObject = class;
  TDBDomain = class;
  TDBObjectsList = class;
  TDBObjectsListEnumerator = class;

  TDBFieldsEnumerator = class;

  TExecSQLScriptEvent = function (List: TStrings; const ExecParams: TSqlExecParams; const ASQLEngine:TSQLEngineAbstract) : boolean;
  TObjectByKind = function(AOwnerRoot: TDBRootObject; ADBObjectKind: TDBObjectKind):TDBObject of object;
  TDBObjectEvent = function(ADBObject:TDBObject):boolean of object;
  TCreateObject = function(ADBObjectKind: TDBObjectKind; AOwnerObject:TDBObject):TDBObject of object;
  TInternalError = procedure(const S:string) of object;

  { TDBObjectsList }

  TDBObjectsList = class
  private
    FList:TFPList;
    FFreeObjects:boolean;
    function GetCount: integer;
    function GetItems(AIndex: integer): TDBObject;
  public
    constructor Create(AFreeObjects:boolean);
    destructor Destroy; override;
    procedure Clear;
    procedure Add(AObject:TDBObject);
    function GetEnumerator: TDBObjectsListEnumerator;
    procedure Delete(AObject:TDBObject); overload;
    procedure Delete(AIndex:integer); overload;
    procedure Extract(AObject:TDBObject);
    function IndexOf(AObject:TDBObject):integer;
    property Count:integer read GetCount;
    property Items[AIndex:integer]:TDBObject read GetItems; default;
  end;

  { TDBObjectsListEnumerator }

  TDBObjectsListEnumerator = class
  private
    FList: TDBObjectsList;
    FPosition: Integer;
  public
    constructor Create(AList: TDBObjectsList);
    function GetCurrent: TDBObject;
    function MoveNext: Boolean;
    property Current: TDBObject read GetCurrent;
  end;


  { TSQLEngineCreateDBAbstractClass }

  TSQLEngineCreateDBAbstractClass = class
  protected
    FRegisterAfterCreate: boolean;
    FUserName:string;
    FPassword:string;
    FServerName:string;
    FDataBaseName:string;
    FLogMetadata:boolean;
    FLogFileMetadata:string;
    FPort:integer;
    FCreateSQL:string;
    FReportManagerFolder: string;
  public
    constructor Create;virtual;
    function Execute:boolean;virtual;abstract;
    function CreateSQLEngine:TSQLEngineAbstract;virtual;abstract;
    property RegisterAfterCreate:boolean read FRegisterAfterCreate;
    property UserName:string read FUserName;
    property Password:string read FPassword;
    property ServerName:string read FServerName;
    property DataBaseName:string read FDataBaseName;
    property LogMetadata:boolean read FLogMetadata;
    property LogFileMetadata:string read FLogFileMetadata;
    property Port:integer read FPort;
    property CreateSQL:string read FCreateSQL;
    property ReportManagerFolder : string read FReportManagerFolder;
  end;


  { TACLItem }

  TACLItem = class
  private
    FDBObject:TDBObject;
    FGrants: TObjectGrants;
    FGrantsOld: TObjectGrants;
    FOwner:TACLListAbstract;
  protected
    function ObjectTypeName:string; virtual;
    function ObjectName:string; virtual;
  public
    UserName:string;
    UserType:integer; //1 - user;2 - group
    GrantOwnUser:string; //Пользователь, выдавший права
    procedure FillOldValues;
    function MakeGrantStr(ForScript: boolean): string;
    function MakeRevokeStr:string;
    function NewGrants:TObjectGrants;
    function NewRevoke:TObjectGrants;
    constructor Create(ADBObject:TDBObject; AOwner:TACLListAbstract);
    property DBObject:TDBObject read FDBObject;
    property Owner:TACLListAbstract read FOwner;
    property Grants:TObjectGrants read FGrants write FGrants;
    property GrantsOld:TObjectGrants read FGrantsOld write FGrantsOld;
  end;


  { TACLListAbstract }
  TACLListEnumerator = class;
  TACLListAbstract = class
  private
    FList:TFPList;
    FDBObject:TDBObject;
    FObjectGrants: TObjectGrants;
    FSQLEngine:TSQLEngineAbstract;
    function GetACLItem(Index: integer): TACLItem;
    function GetCount: integer;
    procedure SetDBObject(AValue: TDBObject);
    procedure SetSQLEngine(AValue: TSQLEngineAbstract);
  protected
    function InternalCreateACLItem: TACLItem; virtual;
    function InternalCreateGrantObject: TSQLCommandGrant; virtual;
    function InternalCreateRevokeObject: TSQLCommandGrant; virtual;
  public
    FTempObjName:string;
  public
    constructor Create(ADBObject:TDBObject); virtual;
    destructor Destroy; override;
    procedure Clear;

    function FindACLItem(UserName:string):TACLItem;
    property ACLItem[Index:integer]:TACLItem read GetACLItem; default;
    function Add: TACLItem;

    procedure LoadUserAndGroups; virtual;
    procedure RefreshList; virtual;

    procedure MakeACLListSQL(P:TACLItem; ASQL:TStrings; ForScrip:boolean);
    function ApplyACLList(P:TACLItem):boolean;

    property DBObject:TDBObject read FDBObject write SetDBObject;
    property SQLEngine:TSQLEngineAbstract read FSQLEngine write SetSQLEngine;
    property ObjectGrants:TObjectGrants read FObjectGrants write FObjectGrants;
    property Count:integer read GetCount;

    function GetEnumerator: TACLListEnumerator;
  end;

  { TACLListEnumerator }

  TACLListEnumerator = class
  private
    FList: TACLListAbstract;
    FPosition: Integer;
  public
    constructor Create(AList: TACLListAbstract);
    function GetCurrent: TACLItem;
    function MoveNext: Boolean;
    property Current: TACLItem read GetCurrent;
  end;

  { TDBTableStatistic }

  TDBTableStatistic = class
  private
    FOwner:TDBObject;
    FStatData: TDataSet;
    function GetCount: Integer;
    procedure CreateStatData;
  public
    constructor Create(AOwner:TDBObject);
    destructor Destroy; override;
    procedure Clear;
    procedure Refresh;
    procedure AddValue(AName, AValue:string);
    procedure AddParamValue(AParam:string);
    property Count:Integer read GetCount;
    property StatData:TDataSet read FStatData;
  end;

  { TDBObject }

  TDBObject = class
  private
    FOwnerDB : TSQLEngineAbstract;
    FCaption: string;
    FLoaded: boolean;
    FOwnerRoot:TDBRootObject;
    FSchemaName: string;
    FState:TDBObjectState;
    FSQLScriptsLock:integer;
    FStatistic: TDBTableStatistic;
    function GetDDLCreateSimple: string;
    procedure SetCaption(AValue: string);
    function GetDDLCreate: string;
    procedure SetOwnerRoot(AValue: TDBRootObject);
    function GetEnableDropped: boolean;
  protected
    FACLList: TACLListAbstract;
    FDescription: string;
    FSystemObject: boolean;
    FDBObjectKind: TDBObjectKind;
    FSqlStrings:TStringList;
    FObjectEditable:boolean;
    function GetDDLAlter: string; virtual; abstract;
    procedure SetState(const AValue: TDBObjectState);virtual;
    procedure InternalSetDescription(ACommentOn: TSQLCommentOn); virtual;
    procedure SetDescription(const AValue: string); virtual;
    function GetCaption: string;virtual;
    function GetCaptionFullPatch: string;virtual;
    { TODO : Необходимо вызовы скрипта компиляции метаданных оформить через этот метод }
    function SQLScriptsExec(const S:string; const ExecParams:TSqlExecParams):boolean;
    function MakeRemarkBlock(S:string):string;
    function GetEnableRename: boolean; virtual;
    procedure NotyfiOnDestroy(ADBObject:TDBObject);virtual;
    procedure InternalPrepareDropCmd(R: TSQLDropCommandAbstract); virtual;
    procedure InternalRefreshStatistic; virtual;
  public
    DependList:TDependRecordList;
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);virtual;
    destructor Destroy; override;
    procedure Edit;
    procedure RefreshEditor;
    procedure OnCloseEditorWindow;virtual;
    function CreateSQLObject:TSQLCommandDDL;virtual; deprecated;
    function GetDDLSQLObject(ACommandType:TDDLCommandType):TSQLCommandDDL;virtual;
    function CompileSQLObject(ASqlObject:TSQLCommandDDL; ASqlExecParam:TSqlExecParams):boolean;virtual;

    class function DBClassTitle:string; virtual;
    function InternalGetDDLCreate: string; virtual;
    procedure SQLScriptsBegin;
    procedure SQLScriptsEnd;
    function SQLScriptsApply:boolean;

    procedure MakeSQLStatementsList(AList:TStrings); virtual;
    function MakeChildList:TStrings; virtual;

    procedure BeforeCreateObject;virtual;
    function AfterCreateObject:boolean;virtual;

    procedure FillFieldList(List:TStrings; ACharCase:TCharCaseOptions; AFullNames:Boolean);virtual;
    procedure SetSqlAssistentData(const List: TStrings); virtual;
    procedure RefreshObject;virtual;
    procedure RefreshDependencies;virtual;
    procedure RefreshDependenciesField(Rec:TDependRecord);virtual;
    procedure ResincObject(const ADBItem:TDBItem);virtual;
    function RenameObject(ANewName:string):Boolean;virtual;
    property EnableDropped:boolean read GetEnableDropped;
    property EnableRename:boolean read GetEnableRename;
    property SchemaName:string read FSchemaName write FSchemaName;
    property Caption:string read GetCaption write SetCaption;
    property CaptionFullPatch:string read GetCaptionFullPatch; //Наименование объекта с полным путём (с именем схемы)
    property DBObjectKind:TDBObjectKind read FDBObjectKind;
    property DDLCreate:string read GetDDLCreate; //script for DDL page
    property DDLAlter:string read GetDDLAlter;   //Script for edit - now only for VIEW object!
    property DDLCreateSimple:string read GetDDLCreateSimple;
    property Description:string read FDescription write SetDescription;
    property SystemObject:boolean read FSystemObject;
    property OwnerDB:TSQLEngineAbstract read FOwnerDB;
    property OwnerRoot:TDBRootObject read FOwnerRoot write SetOwnerRoot;
    property State:TDBObjectState read FState write SetState;

    property SqlStrings:TStringList read FSqlStrings;
    property ObjectEditable:boolean read FObjectEditable;
    property ACLList:TACLListAbstract read FACLList;
    property Loaded:boolean read FLoaded write FLoaded;
    property Statistic:TDBTableStatistic read FStatistic;
  end;


  { TDBRootObject }
  TDBRootObject = class(TDBObject)
  private
    function GetCountGroups: integer;
    function GetGroups(AIndex: integer): TDBRootObject;
    function GetItems(AIndex: integer): TDBObject;
    function GetCountObject: integer;
  protected
    FObjects:TDBObjectsList;
    FGroupObjects:TDBObjectsList;
    FDropCommandClass:TSQLDropCommandAbstractClass;
    FDBObjectClass:TDBObjectClass;
    function GetObjName(AIndex: integer): string;
    function GetDDLAlter: string; override;
    //
    function DBMSObjectsList:string; virtual;
    function DBMSValidObject(AItem:TDBItem):boolean; virtual;
  public
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); virtual;
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject); override;
    destructor Destroy; override;
    procedure Clear;virtual;
    procedure RefreshGroup;virtual;
    function GetObjectType: string;virtual; abstract; //метод возвращает наименование объекта для построения меню в инспекторе объектов
    procedure FillListForNames(Items:TStrings; AFullNames: Boolean);
    function NewDBObject:TDBObject;virtual;
    function DropObject(AItem:TDBObject):boolean;virtual;
    function ObjByName(AName:string; ARefreshObject:boolean = true):TDBObject;virtual;

    property CountObject:integer read GetCountObject;
    property Items[AIndex:integer]:TDBObject read GetItems; default;
    property ObjName[AIndex:integer]:string read GetObjName;
    property DBObjectClass:TDBObjectClass read FDBObjectClass;

    property Groups[AIndex:integer]:TDBRootObject read GetGroups;
    property CountGroups:integer read GetCountGroups;
    property Objects:TDBObjectsList read FObjects;
  end;

  { TDBField }

  TDBField = class
  private
    FFieldAutoInc: boolean;
    FFieldAutoIncInitialValue: integer;
    FFieldCharSetName: string;
    FFieldCollateName: string;
    FFieldComputedSource: string;
    FFieldDefaultValue: string;
    FFieldName: string;
    FFieldNotNull: boolean;
    FFieldNum: integer;
    FFieldOptions: TDBFieldOptions;
    FFieldPK: boolean;
    FFieldPrec: integer;
    FFieldSize: integer;
    FFieldSQLSubTypeInt: integer;
    FFieldSQLTypeInt: integer;
    FFieldTypeDomain: string;
    FFieldTypeName: string;
    FFieldTypeRecord: TDBMSFieldTypeRecord;
    FFieldUNIC: boolean;
    FIOType: TSPVarType;
    FOwner:TDBObject;
    FSystemField: boolean;
    function GetFieldDomain: TDBDomain;
    function GetFieldIsLocal: boolean;
    function GetFieldTypeDB: TFieldType;
    procedure SetFieldComputedSource(AValue: string);
    procedure SetFieldOptions(AValue: TDBFieldOptions);
    procedure SetFieldTypeName(const AValue: string);
  protected
    FFieldDescription: string;
    procedure SetFieldDescription(const AValue: string);virtual;
  public
    property FieldDescription:string read FFieldDescription write SetFieldDescription;
    property Owner:TDBObject read FOwner;
    constructor Create(AOwner:TDBObject); virtual;
    function DDLTypeStr:string; virtual;
    procedure LoadFromSQLFieldItem(SQLField:TSQLParserField);
    procedure SaveToSQLFieldItem(SQLField:TSQLParserField);
    function RefreshDependenciesFromField:TStringList; virtual;
    procedure Clear;

    property FieldName:string read FFieldName write FFieldName;

    property FieldSQLSubTypeInt:integer read FFieldSQLSubTypeInt write FFieldSQLSubTypeInt;
    property FieldTypeDomain:string read FFieldTypeDomain write FFieldTypeDomain;
    property FieldSize:integer read FFieldSize write FFieldSize;
    property FieldPrec:integer read FFieldPrec write FFieldPrec;
    property FieldUNIC:boolean read FFieldUNIC write FFieldUNIC;
    property FieldPK:boolean read FFieldPK write FFieldPK;
    property FieldNotNull:boolean read FFieldNotNull write FFieldNotNull;
    property SystemField:boolean read FSystemField write FSystemField;
    property FieldNum:integer read FFieldNum write FFieldNum;
    property FieldDefaultValue:string read FFieldDefaultValue write FFieldDefaultValue;
    property FieldAutoInc:boolean read FFieldAutoInc write FFieldAutoInc;
    property FieldSQLTypeInt:integer read FFieldSQLTypeInt write FFieldSQLTypeInt;
    property FieldTypeRecord:TDBMSFieldTypeRecord read FFieldTypeRecord;
    property FieldTypeName:string read FFieldTypeName write SetFieldTypeName;
    property FieldCollateName:string read FFieldCollateName write FFieldCollateName;
    property FieldCharSetName:string read FFieldCharSetName write FFieldCharSetName;
    property FieldComputedSource:string read FFieldComputedSource write SetFieldComputedSource;
    property FieldOptions:TDBFieldOptions read FFieldOptions write SetFieldOptions;
    property IOType : TSPVarType read FIOType write FIOType;
    property FieldIsLocal:boolean read GetFieldIsLocal;
    property FieldDomain:TDBDomain read GetFieldDomain;
    property FieldTypeDB:TFieldType read GetFieldTypeDB;
    property FieldAutoIncInitialValue:integer read FFieldAutoIncInitialValue write FFieldAutoIncInitialValue;
  end;

  TDBFieldClass = class of TDBField;

  { TDBFields }

  TDBFields = class
  private
    FFieldClass:TDBFieldClass;
    FList:TObjectList;
    FOwner:TDBObject;
    function GetAsString: string;
    function GetCount: integer;
    function GetItem(AIndex: Integer): TDBField;
    function IndexOf(AItem:TDBField):Integer;
  public
    constructor Create(AOwner:TDBObject; AFieldClass:TDBFieldClass);
    destructor Destroy; override;
    function FieldByName(AName:string):TDBField;
    function Add(AFieldName:string):TDBField;
    procedure Clear;
    procedure DeleteField(const AName:string);
    function GetEnumerator: TDBFieldsEnumerator;
    procedure SaveToSQLFields(ASQLFields:TSQLFields);
    property Count:integer read GetCount;
    property Items[AIndex:Integer]:TDBField read GetItem;default;
    property AsString:string read GetAsString;
  end;

  { TDBFieldsEnumerator }

  TDBFieldsEnumerator = class
  private
    FList: TDBFields;
    FPosition: Integer;
  public
    constructor Create(AList: TDBFields);
    function GetCurrent: TDBField;
    function MoveNext: Boolean;
    property Current: TDBField read GetCurrent;
  end;

  { TDBDataSetObject }

  TDBDataSetObject = class(TDBObject)
  private
    FFields: TDBFields;
    FUITableOptions: TUITableOptions;
    function GetIndexCount: integer;
    function GetIndexItem(AItem: integer): TIndexItem;
  protected
    FIndexItems:TIndexItems;
    FIndexListLoaded:boolean;
    FDataSet:TDataSet;
    function GetFields: TDBFields;
    function GetTrigger(ACat:integer; AItem: integer): TDBTriggerObject; virtual; abstract;
    function GetTriggersCategories(AItem: integer): string; virtual; abstract;
    function GetTriggersCategoriesType(AItem: integer): TTriggerTypes;virtual; abstract;
    function GetTriggersCategoriesCount: integer; virtual;
    function GetTriggersCount(AItem: integer): integer; virtual;
    function GetRecordCount: integer; virtual;
    procedure DataSetAfterOpen(DataSet: TDataSet);virtual;
    function GetDBFieldClass: TDBFieldClass; virtual;
    procedure NotyfiOnDestroy(ADBObject:TDBObject);override;
    function GetEnableRename: boolean; override;
    procedure IndexArrayClear; virtual;
    procedure IndexArrayCreate; virtual;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    procedure Commit;virtual;
    procedure RollBack;virtual;
    function DataSet(ARecCountLimit:Integer):TDataSet;virtual;abstract;
    procedure SetSqlAssistentData(const List: TStrings); override;
    function MakeChildList:TStrings; override;
    procedure RefreshFieldList; virtual; abstract;

    procedure TriggersListRefresh; virtual; abstract;
    procedure RecompileTriggers;virtual;
    procedure AllTriggersSetActiveState(AState:boolean);virtual;
    procedure FillFieldList(List:TStrings; ACharCase:TCharCaseOptions; AFullNames:Boolean);override;
    function TriggerNew(TriggerTypes:TTriggerTypes):TDBTriggerObject;virtual;
    function TriggerDelete(const ATrigger:TDBTriggerObject):boolean;virtual;

    function IndexNew:string;virtual; abstract;
    function IndexEdit(const IndexName:string):boolean;virtual; abstract;
    function IndexDelete(const IndexName:string):boolean;virtual; abstract;
    function IndexFind(IndexName:string):TIndexItem;
    procedure IndexListRefresh; virtual; abstract;
    property IndexCount:integer read GetIndexCount;
    property IndexItem[AItem:integer]:TIndexItem read GetIndexItem;

    property RecordCount:integer read GetRecordCount;
    property TriggersCategoriesCount:integer read GetTriggersCategoriesCount;
    property TriggersCategories[AItem:integer]:string read GetTriggersCategories;
    property TriggersCategoriesType[AItem:integer]:TTriggerTypes read GetTriggersCategoriesType;

    property TriggersCount[AItem:integer]:integer read GetTriggersCount;
    property Trigger[ACat:integer; AItem:integer]:TDBTriggerObject read GetTrigger;

    property UITableOptions:TUITableOptions read FUITableOptions write FUITableOptions;
    property Fields:TDBFields read GetFields;
    property IndexItems:TIndexItems read FIndexItems; //index metatdata info
  end;

  { TDBIndex }

  TDBIndex = class(TDBObject)
  private
    FIndexFields: TIndexFields;
    FTable: TDBDataSetObject;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    property IndexFields:TIndexFields read FIndexFields;
    property Table:TDBDataSetObject read FTable write FTable;
  end;

  { TDBTableObject }

  TDBTableObject = class(TDBDataSetObject)
  private
    function GetConstraint(AItem: integer): TPrimaryKeyRecord;
    function GetConstraintCount: integer;
  protected
    FFKListLoaded:boolean;
    FPKListLoaded:boolean;
    FPKCount:integer;
    FConstraintList:TList;
    FCashedState:TTableCashedStateFlags;

    function GetIndexFields(const AIndexName:string; const AForce:boolean):string; virtual;

    procedure ClearConstraintList(AConstraintType:TConstraintType);
    procedure NotyfiOnDestroy(ADBObject:TDBObject); override;
    procedure IndexArrayClear; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    function CompileSQLObject(ASqlObject:TSQLCommandDDL; ASqlExecParam:TSqlExecParams):boolean; override;

    procedure SetFieldsOrder(AFieldsList:TStrings);virtual; abstract;


    function ConstraintFind(ConstraintName:string):TPrimaryKeyRecord;
    procedure MakeSQLStatementsList(AList:TStrings); override;

    procedure RefreshConstraintPrimaryKey; virtual;
    procedure RefreshConstraintForeignKey; virtual;
    procedure RefreshConstraintUnique; virtual;
    procedure RefreshConstraintCheck; virtual;



    property ConstraintCount:integer read GetConstraintCount;
    property Constraint[AItem:integer]:TPrimaryKeyRecord read GetConstraint;
  end;

  { TDBTriggerObject }

  TDBTriggerObject = class(TDBObject)
  private
    FTableName:string;
    FTriggerType:TTriggerTypes;
    function GetTriggerTable: TDBDataSetObject;
  protected
    FActive: boolean;
    FSequence:integer;
    FTriggerTable:TDBDataSetObject;
    procedure SetActive(const AValue: boolean); virtual;
    function GetTriggerBody: string;virtual; abstract;
    function GetTableName: string;virtual;
    function GetTriggerType: TTriggerTypes;virtual;
    procedure SetTriggerType(AValue: TTriggerTypes);virtual;
    procedure SetTableName(AValue: string);virtual;
    procedure InternalSetDescription(ACommentOn: TSQLCommentOn); override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    property Active:boolean read FActive write SetActive;
    property TableName:string read GetTableName write SetTableName;
    property Sequence:integer read FSequence;
    property TriggerType:TTriggerTypes read GetTriggerType write SetTriggerType;
    property TriggerBody:string read GetTriggerBody;
    property TriggerTable:TDBDataSetObject read GetTriggerTable write FTriggerTable;
  end;

  { TDBStoredProcObject }

  TDBStoredProcObject = class(TDBObject)
  private
    function GetProcedureBody: string;
  protected
    FProcedureBody: string;
    FFieldsIN: TDBFields;
    FFieldsOut: TDBFields;
    procedure RefreshParams;virtual;
    property FieldsIN: TDBFields read FFieldsIN;
    property FieldsOut: TDBFields read FFieldsOut;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    procedure SetSqlAssistentData(const List: TStrings);override;
    function MakeChildList:TStrings; override;
    property ProcedureBody:string read GetProcedureBody;
    procedure FillFieldList(List:TStrings; ACharCase:TCharCaseOptions; AFullNames:Boolean);override;
  end;

  { TDBViewObject }

  TDBViewObject = class(TDBDataSetObject)
  private
    function GetSQLBody: string;
  protected
    FSQLBody:string;
  public
    procedure MakeSQLStatementsList(AList:TStrings); override;
    function CompileSQLObject(ASqlObject:TSQLCommandDDL; ASqlExecParam:TSqlExecParams):boolean; override;
    property SQLBody:string read GetSQLBody;
  end;


  { TDBUsersGroup }

  TDBUsersGroup = class(TDBObject)
  public
    function SetGrantUsers(AUserName:string; AGrant, WithGrantOpt:boolean):boolean;virtual;abstract;
    function SetGrantObjects(AObjectName:string; AddGrants, RemoveGrants:TObjectGrants):boolean;virtual;abstract;
    procedure GetUserList(const UserList:TStrings);virtual;abstract;
    procedure GetUserRight(GrantedList:TObjectList);virtual;abstract;
  end;

  { TDBDomain }

  TDBDomain = class(TDBObject)
  private
    FCharSetName: string;
    FCollationName: string;
    FConstraintName: string;
    FCheckExpression: string;
  protected
    FComputedSrc: string;
    FDefaultValue: string;
    FFieldDecimal: integer;
    FFieldLength: integer;
    FFieldType: TDBMSFieldTypeRecord;
    FNotNull: boolean;
  public
    property DefaultValue:string read FDefaultValue;
    property ConstraintName:string read FConstraintName write FConstraintName;
    property CheckExpression:string read FCheckExpression write FCheckExpression;
    property ComputedSrc:string read FComputedSrc;

    property FieldLength:integer read FFieldLength;
    property FieldDecimal:integer read FFieldDecimal;

    property FieldType:TDBMSFieldTypeRecord read FFieldType;
    property NotNull:boolean read FNotNull;
    property CollationName:string read FCollationName write FCollationName;
    property CharSetName:string read FCharSetName write FCharSetName;
  end;

  { TSQLQueryControl }

  TSQLQueryControl = class
  private
    FOwner:TSQLEngineAbstract;
    function GetActive: boolean;
  protected
    procedure SetActive(const AValue: boolean);virtual;
    function GetDataSet: TDataSet;virtual; abstract;
    function GetQueryPlan: string;virtual; abstract;
    function GetQuerySQL: string;virtual; abstract;
    procedure SetQuerySQL(const AValue: string);virtual; abstract;
    function GetParam(AIndex: integer): TParam;virtual; abstract;
    function GetParamCount: integer;virtual; abstract;
  public
    constructor Create(AOwner:TSQLEngineAbstract); virtual;
    destructor Destroy; override;
    function IsEditable:boolean;virtual;
    procedure StartTransaction;virtual;
    procedure CommitTransaction;virtual; abstract;
    procedure RolbackTransaction;virtual; abstract;
    procedure FetchAll;virtual; abstract;
    procedure Prepare;virtual; abstract;
    procedure ExecSQL;virtual; abstract;
    function ParseException(E:Exception; out X, Y:integer; out AMsg:string):boolean;virtual;
    function LoadStatistic(out StatRec:TQueryStatRecord):boolean;virtual;

    property DataSet:TDataSet read GetDataSet;
    property Owner:TSQLEngineAbstract read FOwner;
    property Active:boolean read GetActive write SetActive;
    property QueryPlan:string read GetQueryPlan;
    property QuerySQL:string read GetQuerySQL write SetQuerySQL;
    property ParamCount:integer read GetParamCount;
    property Param[AIndex:integer]:TParam read GetParam;
  end;

  { TSQLEngineConnectionPlugin }

  TSQLEngineConnectionPlugin = class
  private
    FEnabled: boolean;
    FOwner:TSQLEngineAbstract;
    FDS:TDataSet;
  protected
    function GetConnected: boolean; virtual;
    procedure SetConnected(AValue: boolean); virtual;
    procedure InternalLoad; virtual;
    procedure InternalSave; virtual;
    function LoadVariable(AVariableName, ADefValue:string):string;
    procedure SaveVariable(AVariableName, AValue:string);
    function LoadVariableInt(AVariableName:string; AValue:Integer):Integer;
    procedure SaveVariableInt(AVariableName:string; AValue:Integer);
    function LoadVariableBool(AVariableName:string; AValue:Boolean):Boolean;
    procedure SaveVariableBool(AVariableName:string; AValue:Boolean);
  public
    constructor Create(AOwner:TSQLEngineAbstract); virtual;
    destructor Destroy; override;
    property Connected:boolean read GetConnected write SetConnected;
    property Owner:TSQLEngineAbstract read FOwner;
    property Enabled:boolean read FEnabled write FEnabled;
  end;
  TSQLEngineConnectionPluginClass = class of TSQLEngineConnectionPlugin;

  { TSQLEngineConnectionPlugins }

  TSQLEngineConnectionPlugins = class
  private
    FList:TFPList;
    procedure Clear;
    function GetCount: Integer;
    function GetItem(AIndex: Integer): TSQLEngineConnectionPlugin;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Load(AData:TDataSet);
    procedure Save(AData:TDataSet);
    function FindPlugin(AClass:TSQLEngineConnectionPluginClass):TSQLEngineConnectionPlugin;
    property Count:Integer read GetCount;
    property Item[AIndex:Integer]:TSQLEngineConnectionPlugin read GetItem; default;
  end;

  { TSQLEngineAbstract }

  TSQLEngineAbstract = class
  private
    FConnected: Boolean;
    FAliasName: string;
    FConnectionPlugins: TSQLEngineConnectionPlugins;
    FDatabaseID: integer;
    FDataBaseName: string;
    FDescription: string;
    FOnInternalError: TInternalError;
    FPassword: string;
    FProperties: TStrings;
    FReportManagerFolder: string;
    FServerName: string;
    FSPEditLazzyMode: boolean;
    FTriggerEditLazzyMode: boolean;
    FUIShowSysObjects: TUIShowSysObjects;
    FUserName: string;
    FRemotePort: integer;
    FQueryControlList:TList;
    FSQLEngineLogOptions:TSQLEngineLogOptions;
    FDisplayDataOptions:TSQLEngineDisplayDataOptions;
    FCountSQLHistory:integer;
    FKeywordsList:TObjectList;
    //
    FOnNewObjectByKind:TObjectByKind;
    FOnEditObject:TDBObjectEvent;
    FOnRefreshObject:TDBObjectEvent;
    FOnCreateObject:TCreateObject;
    FOnDestroyObject:TDBObjectEvent;

    FGroups:TDBObjectsList;

    procedure ClearQueryControlList;
    procedure SetConnected(const AValue: boolean);
  protected
    FSQLCommentOnClass:TSQLCommentOnClass;
    FSQLEngileFeatures: TSQLEngileFeatures;
    FSQLEngineCapability: TDBObjectKinds;
    FTypeList: TDBMSFieldTypeList;
    FTablesRoot:TDBRootObject;
    FUIParams: TUIParams;
    FKeyFunctions: TKeywordList;
    FKeyTypes: TKeywordList;
    FKeyWords: TKeywordList;
    FCashedItems:TDBObjectsItems;
    procedure InternalInitEngine;
    function GetImageIndex: integer;virtual;
    procedure SetDataBaseName(const AValue: string);virtual;
    procedure SetPassword(const AValue: string);virtual;
    procedure SetServerName(const AValue: string);virtual;
    procedure SetUserName(const AValue: string);virtual;
    function GetConnected: boolean;virtual;
    function InternalSetConnected(const AValue: boolean):boolean; virtual;
    procedure InitGroupsObjects;virtual; abstract;
    procedure DoneGroupsObjects;virtual; abstract;

    function GetCharSet: string;virtual; abstract;
    procedure SetCharSet(const AValue: string);virtual; abstract;
    procedure SetUIShowSysObjects(const AValue: TUIShowSysObjects);virtual;
    function GetServerInfoVersion : string; virtual;
    procedure AddObjectsGroup(var AItem; AGroupClass:TDBRootObjectClass; ADBObjectClass:TDBObjectClass; const ACaption:string);
    procedure DoBeforeDisconnect; virtual;
    procedure DoBeforeConnect; virtual;
    procedure DoAfterDisconnect; virtual;
    procedure DoAfterConnect; virtual;
  public
    MiscOptions:TSQLEngineMiscOptions;
    procedure NotyfiOnDestroy(ADBObject:TDBObject);
    function GetMetaSQLText(sqlId:integer):string;virtual; abstract;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Load(const AData: TDataSet); virtual;
    procedure Store(const AData: TDataSet); virtual;

    procedure SetSqlAssistentData(const List: TStrings); virtual;
    procedure FillCharSetList(const List: TStrings); virtual;
    procedure FillCollationList(const ACharSet:string; const List: TStrings); virtual;
    function ExecuteSQLScript(const ASQL: string; OnExecuteSqlScriptProcessEvent:TExecuteSqlScriptProcessEvent):boolean; virtual;
    procedure RefreshObjectsBegin(const ASQLText:string);virtual;
    procedure RefreshObjectsEnd(const ASQLText:string);virtual;

    procedure RefreshObjectsBeginFull;virtual;
    procedure RefreshObjectsEndFull;virtual;

    function OpenDataSet(Sql:string; AOwner:TComponent):TDataSet;virtual;
    function ExecSQL(const Sql:string;const ExecParams:TSqlExecParams):boolean;virtual;
    function SQLPlan(aDataSet:TDataSet):string;virtual;
    function GetQueryControl:TSQLQueryControl;virtual; abstract;
    function DBObjectByName(AName:string; ARefreshObject:boolean = true):TDBObject;virtual;
    procedure FillListForNames(Items:TStrings; ObjectKinds:TDBObjectKinds);
    procedure InternalError(AErrorMessage:string);
    procedure InternalErrorEx(AErrorMessage:string; AParams : array of const);

    //Работа с типами полей и с доменами
    procedure FillDomainsList(const Items:TStrings; const ClearItems:boolean);virtual;
    procedure FillStdTypesList(const Items:TStrings);

    //function ShowObjectItem:integer;virtual;
    //procedure ShowObjectGetItem(Item:integer; out ItemName:string; out ItemValue:boolean);virtual;abstract;
    //procedure ShowObjectSetItem(Item:integer; ItemValue:boolean);virtual;abstract;

    function NewObjectByKind(AOwnerRoot:TDBRootObject; ADBObjectKind: TDBObjectKind):TDBObject;
    function EditObject(ADBObject:TDBObject):boolean;
    function RefreshEditor(ADBObject:TDBObject):boolean;
    function CreateObject(ADBObjectKind: TDBObjectKind; AOwnerObject:TDBObject):TDBObject;


    class function GetEngineName: string; virtual; abstract;

    property Groups:TDBObjectsList read FGroups;

//    property CountRootObject:integer read GetCountRootObject;
//    property RootObject[AIndex:integer]:TDBRootObject read GetRootObject;
    property CashedItems:TDBObjectsItems read FCashedItems;

    property TypeList:TDBMSFieldTypeList read FTypeList;

    property ServerName:string read FServerName write SetServerName;
    property DataBaseName:string read FDataBaseName write SetDataBaseName;
    property AliasName:string read FAliasName write FAliasName;
    property UserName:string read FUserName write SetUserName;
    property Password:string read FPassword write SetPassword;
    property RemotePort:integer read FRemotePort write FRemotePort;

    property Connected:boolean read GetConnected write SetConnected;
    property ServerInfoVersion:string read GetServerInfoVersion;

    property UIParams:TUIParams read FUIParams;
    property UIShowSysObjects:TUIShowSysObjects read FUIShowSysObjects write SetUIShowSysObjects;
    property CharSet:string read GetCharSet write SetCharSet;
    property SQLEngineLogOptions:TSQLEngineLogOptions read FSQLEngineLogOptions;
    property SQLEngineCapability:TDBObjectKinds read FSQLEngineCapability;                     //Торетически все возможные типы объектов, которые поддерживает данный движок - надо изменить метод обработки свойств - может новый тип завести?
    property DisplayDataOptions:TSQLEngineDisplayDataOptions read FDisplayDataOptions;
    property ReportManagerFolder:string read FReportManagerFolder write FReportManagerFolder;
    property SPEditLazzyMode:boolean read FSPEditLazzyMode write FSPEditLazzyMode;
    property TriggerEditLazzyMode:boolean read FTriggerEditLazzyMode write FTriggerEditLazzyMode;
    property DatabaseID:integer read FDatabaseID write FDatabaseID;
    property Description:string read FDescription write FDescription;

    property TablesRoot:TDBRootObject read FTablesRoot;
    property KeywordsList:TObjectList read FKeywordsList;
    property KeyWords:TKeywordList read FKeyWords;
    property KeyFunctions:TKeywordList read FKeyFunctions;
    property KeyTypes:TKeywordList read FKeyTypes;
    property ImageIndex:integer read GetImageIndex;
    property SQLEngileFeatures:TSQLEngileFeatures read FSQLEngileFeatures;
    property ConnectionPlugins:TSQLEngineConnectionPlugins read FConnectionPlugins;
    property Properties:TStrings read FProperties;
    //
    property OnNewObjectByKind:TObjectByKind read FOnNewObjectByKind write FOnNewObjectByKind;
    property OnEditObject:TDBObjectEvent read FOnEditObject write FOnEditObject;
    property OnRefreshObject:TDBObjectEvent read FOnRefreshObject write FOnRefreshObject;
    property OnCreateObject:TCreateObject read FOnCreateObject write FOnCreateObject;
    property OnDestroyObject:TDBObjectEvent read FOnDestroyObject write FOnDestroyObject;
    property OnInternalError:TInternalError read FOnInternalError write FOnInternalError;
  end;

  TSQLEngineAbstractClass = class of TSQLEngineAbstract;


var
  FExecSQLScriptEvent:TExecSQLScriptEvent = nil;

function ExecSQLScript(Line:string; const ExecParams:TSqlExecParams; const ASQLEngine:TSQLEngineAbstract):boolean;
function ExecSQLScriptEx(List:TStrings; const ExecParams:TSqlExecParams; const ASQLEngine:TSQLEngineAbstract):boolean;
implementation
uses fbmStrConstUnit, fbmToolsUnit, strutils, LazUTF8, rxAppUtils, rxlogging, rxmemds, Variants;


function ExecSQLScript(Line: string; const ExecParams: TSqlExecParams;
  const ASQLEngine: TSQLEngineAbstract): boolean;
var
  List:TStringList;
begin
  Result:=false;
  List:=TStringList.Create;
  try
    List.Add(Line);
    Result:=ExecSQLScriptEx(List, ExecParams, ASQLEngine);
  finally
    List.Free;
  end;
end;

function ExecSQLScriptEx(List: TStrings; const ExecParams: TSqlExecParams;
  const ASQLEngine: TSQLEngineAbstract): boolean;
begin
  if Assigned(FExecSQLScriptEvent) then
    Result:=FExecSQLScriptEvent(List, ExecParams, ASQLEngine)
  else
  begin
    Result:=false;
    raise Exception.Create('ExecSQLScriptEx');
  end;
end;

{ TSQLEngineConnectionPlugins }

procedure TSQLEngineConnectionPlugins.Clear;
var
  P: TSQLEngineConnectionPlugin;
begin
  while FList.Count>0 do
  begin
    P:=TSQLEngineConnectionPlugin(FList[0]);
    P.Free;
  end;
end;

function TSQLEngineConnectionPlugins.GetCount: Integer;
begin
  Result:=FList.Count;
end;

function TSQLEngineConnectionPlugins.GetItem(AIndex: Integer
  ): TSQLEngineConnectionPlugin;
begin
  Result:=TSQLEngineConnectionPlugin(FList[AIndex]);
end;

constructor TSQLEngineConnectionPlugins.Create;
begin
  inherited Create;
  FList:=TFPList.Create;
end;

destructor TSQLEngineConnectionPlugins.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TSQLEngineConnectionPlugins.Load(AData: TDataSet);
var
  P: TSQLEngineConnectionPlugin;
  i: Integer;
begin
  for i:=0 to FList.Count-1 do
  begin
    P:=TSQLEngineConnectionPlugin(FList[0]);
    P.FDS:=AData;
    P.InternalLoad;
    P.FDS:=nil;
  end;
end;

procedure TSQLEngineConnectionPlugins.Save(AData: TDataSet);
var
  P: TSQLEngineConnectionPlugin;
  i: Integer;
begin
  for i:=0 to FList.Count-1 do
  begin
    P:=TSQLEngineConnectionPlugin(FList[0]);
    P.FDS:=AData;
    P.InternalSave;
    P.FDS:=nil;
  end;
end;

function TSQLEngineConnectionPlugins.FindPlugin(
  AClass: TSQLEngineConnectionPluginClass): TSQLEngineConnectionPlugin;
var
  P: TSQLEngineConnectionPlugin;
  i: Integer;
begin
  Result:=nil;
  for i:=0 to FList.Count-1 do
  begin
    P:=TSQLEngineConnectionPlugin(FList[0]);
    if AClass = P.ClassType then
      Exit(P);
  end;
end;

{ TSQLEngineConnectionPlugin }

function TSQLEngineConnectionPlugin.GetConnected: boolean;
begin
  Result:=false;
end;

procedure TSQLEngineConnectionPlugin.SetConnected(AValue: boolean);
begin

end;

procedure TSQLEngineConnectionPlugin.InternalLoad;
begin
  FEnabled:=LoadVariable('Enabled', '0') = '1';
end;

procedure TSQLEngineConnectionPlugin.InternalSave;
begin
  SaveVariable('Enabled', IntToStr(Ord(FEnabled)));
end;

function TSQLEngineConnectionPlugin.LoadVariable(AVariableName,
  ADefValue: string): string;
begin
  Result:=ADefValue;
  if not Assigned(FDS) then Exit;
  if FDS.Locate('db_database_id;db_connection_plugin_data_class_type;db_connection_plugin_data_variable_name', VarArrayOf([Owner.DatabaseID, ClassName, AVariableName]), []) then
    Result:=FDS.FieldByName('db_connection_plugin_data_variable_value').AsString;
end;

procedure TSQLEngineConnectionPlugin.SaveVariable(AVariableName, AValue: string
  );
begin
  if not Assigned(FDS) then Exit;
  if not FDS.Locate('db_database_id;db_connection_plugin_data_class_type;db_connection_plugin_data_variable_name', VarArrayOf([Owner.DatabaseID, ClassName, AVariableName]), []) then
  begin
    FDS.Append;
    FDS.FieldByName('db_database_id').AsInteger:=Owner.DatabaseID;
    FDS.FieldByName('db_connection_plugin_data_class_type').AsString:=ClassName;
    FDS.FieldByName('db_connection_plugin_data_variable_name').AsString:=AVariableName;
  end
  else
    FDS.Edit;
  FDS.FieldByName('db_connection_plugin_data_variable_value').AsString:=AValue;
  FDS.Post;
end;

function TSQLEngineConnectionPlugin.LoadVariableInt(AVariableName: string;
  AValue: Integer): Integer;
begin
  Result:=StrToInt64Def(LoadVariable(AVariableName, ''), AValue);
end;

procedure TSQLEngineConnectionPlugin.SaveVariableInt(AVariableName: string;
  AValue: Integer);
begin
  SaveVariable(AVariableName, IntToStr(AValue));
end;

function TSQLEngineConnectionPlugin.LoadVariableBool(AVariableName: string;
  AValue: Boolean): Boolean;
begin
  Result:=LoadVariable(AVariableName, BoolToStr(AValue, true)) = BoolToStr(AValue, true);
end;

procedure TSQLEngineConnectionPlugin.SaveVariableBool(AVariableName: string;
  AValue: Boolean);
begin
  SaveVariable(AVariableName, BoolToStr(AValue, true));
end;

constructor TSQLEngineConnectionPlugin.Create(AOwner: TSQLEngineAbstract);
begin
  inherited Create;
  FOwner:=AOwner;
  if Assigned(FOwner) then
    FOwner.FConnectionPlugins.FList.Add(Self);
end;

destructor TSQLEngineConnectionPlugin.Destroy;
begin
  if Assigned(FOwner) then
    FOwner.FConnectionPlugins.FList.Remove(Self);
  inherited Destroy;
end;

{ TDBTableStatistic }

function TDBTableStatistic.GetCount: Integer;
begin

end;

procedure TDBTableStatistic.CreateStatData;
begin
  FStatData.FieldDefs.BeginUpdate;
  FStatData.FieldDefs.Add('Caption', ftString, 200);
  FStatData.FieldDefs.Add('Value', ftString, 500);
  FStatData.FieldDefs.EndUpdate;
end;

constructor TDBTableStatistic.Create(AOwner: TDBObject);
begin
  inherited Create;
  FStatData:=TRxMemoryData.Create(nil);
  CreateStatData;
  FStatData.Open;
  FOwner:=AOwner;
end;

destructor TDBTableStatistic.Destroy;
begin
  Clear;
  FreeAndNil(FStatData);
  inherited Destroy;
end;

procedure TDBTableStatistic.Clear;
begin
  FStatData.Close;
  FStatData.Open;
end;

procedure TDBTableStatistic.Refresh;
begin
  Clear;
  FOwner.InternalRefreshStatistic;
  FStatData.First;
end;

procedure TDBTableStatistic.AddValue(AName, AValue: string);
begin
  FStatData.Append;
  FStatData.FieldByName('Caption').AsString:=AName;
  FStatData.FieldByName('Value').AsString:=AValue;
  FStatData.Post;
end;

procedure TDBTableStatistic.AddParamValue(AParam: string);
var
  S: String;
begin
  S:=Copy2SymbDel(AParam, '=');
  AddValue(S, AParam);
end;

{ TACLListEnumerator }

constructor TACLListEnumerator.Create(AList: TACLListAbstract);
begin
  FList := AList;
  FPosition := -1;
end;

function TACLListEnumerator.GetCurrent: TACLItem;
begin
  Result := FList[FPosition];
end;

function TACLListEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TDBObjectsListEnumerator }

constructor TDBObjectsListEnumerator.Create(AList: TDBObjectsList);
begin
  FList := AList;
  FPosition := -1;
end;

function TDBObjectsListEnumerator.GetCurrent: TDBObject;
begin
  Result := FList[FPosition];
end;

function TDBObjectsListEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TDBObjectsList }

function TDBObjectsList.GetCount: integer;
begin
  Result:=FList.Count;
end;

procedure TDBObjectsList.Clear;
var
  P: TDBObject;
  i: Integer;
begin
  for i:=FList.Count-1 downto 0 do
  begin
    P:=TDBObject(FList[i]);
    FList.Remove(P);
    if FFreeObjects then
      P.Free;
  end;
  FList.Clear;
end;

function TDBObjectsList.GetItems(AIndex: integer): TDBObject;
begin
  Result:=TDBObject(FList[AIndex]);
end;

constructor TDBObjectsList.Create(AFreeObjects: boolean);
begin
  inherited Create;
  FFreeObjects:=AFreeObjects;
  FList:=TFPList.Create;
end;

destructor TDBObjectsList.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TDBObjectsList.Add(AObject: TDBObject);
begin
  if Assigned(AObject) and (FList.IndexOf(AObject) < 0) then
    FList.Add(AObject);
end;

function TDBObjectsList.GetEnumerator: TDBObjectsListEnumerator;
begin
  Result:=TDBObjectsListEnumerator.Create(Self);
end;

procedure TDBObjectsList.Delete(AObject: TDBObject);
begin
  FList.Remove(AObject);
  if FFreeObjects then
    AObject.Free;
end;

procedure TDBObjectsList.Delete(AIndex: integer);
var
  AObject: TDBObject;
begin
  AObject:=TDBObject(FList[AIndex]);
  FList.Delete(AIndex);
  if FFreeObjects then
    AObject.Free;
end;

procedure TDBObjectsList.Extract(AObject: TDBObject);
begin
  FList.Extract(AObject);
end;

function TDBObjectsList.IndexOf(AObject: TDBObject): integer;
begin
  Result:=FList.IndexOf(AObject);
end;

{ TDBIndex }

constructor TDBIndex.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  FIndexFields:=TIndexFields.Create;
end;

destructor TDBIndex.Destroy;
begin
  FreeAndNil(FIndexFields);
  inherited Destroy;
end;

{ TDBFieldsEnumerator }

constructor TDBFieldsEnumerator.Create(AList: TDBFields);
begin
  FList := AList;
  FPosition := -1;
end;

function TDBFieldsEnumerator.GetCurrent: TDBField;
begin
  Result := FList[FPosition];
end;

function TDBFieldsEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TSQLEngineCreateDBAbstractClass }

constructor TSQLEngineCreateDBAbstractClass.Create;
begin
  inherited Create;
end;

{ TACLItem }

function TACLItem.ObjectTypeName: string;
begin
  Result:=FDBObject.DBClassTitle;
end;

function TACLItem.ObjectName: string;
begin
  if FOwner.FTempObjName <> '' then
    Result:=FOwner.FTempObjName
  else
    Result:=FDBObject.CaptionFullPatch;
end;

procedure TACLItem.FillOldValues;
begin
  GrantsOld:=Grants;
end;

function TACLItem.MakeGrantStr(ForScript:boolean): string;
var
  FGObg: TSQLCommandGrant;
begin
  Result:='';
  FGObg:=Owner.InternalCreateGrantObject;
  if not Assigned(FGObg) then raise Exception.CreateFmt('%s.%s - not defined grant object', [Owner.DBObject.ClassName, ClassName]);
  if FGObg.Tables.Count = 0 then
    FGObg.Tables.Add(ObjectName, Owner.DBObject.DBObjectKind);
  FGObg.Params.AddParamEx(UserName, '');
  FGObg.ObjectKind:=DBObject.DBObjectKind;
  if ForScript then
    FGObg.GrantTypes:=Grants
  else
    FGObg.GrantTypes:=NewGrants;

  if FGObg.GrantTypes <> [] then
    Result:=TrimRight(FGObg.AsSQL);
  FGObg.Free;
end;

function TACLItem.MakeRevokeStr: string;
var
  FGObg: TSQLCommandGrant;
begin
  Result:='';
  FGObg:=Owner.InternalCreateRevokeObject;
  if not Assigned(FGObg) then raise Exception.CreateFmt('%s.%s - not defined revoke object', [Owner.DBObject.ClassName, ClassName]);
  if FGObg.Tables.Count = 0 then
    FGObg.Tables.Add(ObjectName, Owner.DBObject.DBObjectKind);
  FGObg.Params.AddParamEx(UserName, '');
  FGObg.ObjectKind:=DBObject.DBObjectKind;
  FGObg.GrantTypes:=NewRevoke;
  if FGObg.GrantTypes <> [] then
    Result:=TrimRight(FGObg.AsSQL)
  else
    Result:='';
  FGObg.Free;
end;

function TACLItem.NewGrants: TObjectGrants;
var
  G: TObjectGrant;
begin
  Result:=[];
  for G in Grants do
    if not (G in GrantsOld) then
      Result:=Result + [G];
end;

function TACLItem.NewRevoke: TObjectGrants;
var
  G: TObjectGrant;
begin
  Result:=[];
  for G in GrantsOld do
    if not (G in Grants) then
      Result:=Result + [G];
end;

constructor TACLItem.Create(ADBObject: TDBObject; AOwner: TACLListAbstract);
begin
  inherited Create;
  FDBObject:=ADBObject;
  FOwner:=AOwner;
end;

{ TACLListAbstract }

function TACLListAbstract.GetACLItem(Index: integer): TACLItem;
begin
  Result:=TACLItem(FList.Items[Index]);
end;

function TACLListAbstract.GetCount: integer;
begin
  Result:=FList.Count;
end;

procedure TACLListAbstract.SetDBObject(AValue: TDBObject);
var
  i: Integer;
begin
  if FDBObject=AValue then Exit;
  FDBObject:=AValue;
  for i:=0 to FList.Count - 1 do
    ACLItem[i].FDBObject:=FDBObject;
end;

procedure TACLListAbstract.SetSQLEngine(AValue: TSQLEngineAbstract);
begin
  if FSQLEngine=AValue then Exit;
  FSQLEngine:=AValue;
  RefreshList;
end;

function TACLListAbstract.InternalCreateACLItem: TACLItem;
begin
  Result:=TACLItem.Create(FDBObject, Self);
end;

function TACLListAbstract.InternalCreateGrantObject: TSQLCommandGrant;
begin
  Result:=nil;
end;

function TACLListAbstract.InternalCreateRevokeObject: TSQLCommandGrant;
begin
  Result:=nil;
end;

constructor TACLListAbstract.Create(ADBObject: TDBObject);
begin
  inherited Create;
  FList:=TFPList.Create;
  FDBObject:=ADBObject;
  if Assigned(ADBObject) then
    FSQLEngine:=ADBObject.FOwnerDB;
end;

destructor TACLListAbstract.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TACLListAbstract.Clear;
var
  i: Integer;
  P: TACLItem;
begin
  for i:=0 to FList.Count-1 do
  begin
    P:=TACLItem(FList[I]);
    P.Free;
  end;
  FList.Clear;
end;

function TACLListAbstract.FindACLItem(UserName: string): TACLItem;
var
  i:integer;
begin
  Result:=nil;
  for i:=0 to FList.Count - 1 do
  begin
    if ACLItem[i].UserName = UserName then
    begin
      Result:=ACLItem[i];
      exit;
    end;
  end;
end;

function TACLListAbstract.Add: TACLItem;
begin
  Result:=InternalCreateACLItem;
  FList.Add(Result);
end;

procedure TACLListAbstract.LoadUserAndGroups;
begin

end;

procedure TACLListAbstract.RefreshList;
begin

end;

procedure TACLListAbstract.MakeACLListSQL(P: TACLItem; ASQL: TStrings;
  ForScrip: boolean);
procedure DoAddStr(FP: TACLItem);
var
  S: String;
begin
  if ForScrip then
  begin
    if FP.Grants <> [] then
    begin
      S:=FP.MakeGrantStr(true);
      if S<>'' then
        ASQL.Add(S)
    end;
  end
  else
  begin
    if FP.NewGrants <> [] then
    begin
      S:=FP.MakeGrantStr(false);
      if S<>'' then
        ASQL.Add(S);
    end;
    if FP.NewRevoke <> [] then
    begin
      S:=FP.MakeRevokeStr;
      if S<>'' then
        ASQL.Add(S);
    end;
  end;
  FP.FGrantsOld:=FP.FGrants;
end;
var
  i:integer;
begin
  if Assigned(P) then
    DoAddStr(P)
  else
  begin
    for i:=0 to FList.Count - 1 do
      DoAddStr(GetACLItem(I));
  end;
end;

function TACLListAbstract.ApplyACLList(P: TACLItem): boolean;
var
  LS:TStringList;
begin
  LS:=TStringList.Create;
  MakeACLListSQL(P, LS, false);
  if LS.Count > 0 then
    Result:=ExecSQLScriptEx(LS, sysConfirmCompileGrantsEx + [sepInTransaction], SQLEngine);
  LS.Free;
end;

function TACLListAbstract.GetEnumerator: TACLListEnumerator;
begin
  Result:=TACLListEnumerator.Create(Self);
end;

{ TDBTriggerObject }

function TDBTriggerObject.GetTriggerTable: TDBDataSetObject;
begin
  if not Assigned(FTriggerTable) then
    RefreshObject;
  Result:=FTriggerTable;
end;

procedure TDBTriggerObject.SetActive(const AValue: boolean);
begin

end;

function TDBTriggerObject.GetTriggerType: TTriggerTypes;
begin
  Result:=FTriggerType;
end;

procedure TDBTriggerObject.SetTriggerType(AValue: TTriggerTypes);
begin
  FTriggerType:=AValue;
end;

procedure TDBTriggerObject.SetTableName(AValue: string);
begin
  FTableName:=AValue;
end;

type
  THackComment = class(TSQLCommandDDL);

procedure TDBTriggerObject.InternalSetDescription(ACommentOn: TSQLCommentOn);
begin
  THackComment(ACommentOn).TableName:=TableName;
end;

function TDBTriggerObject.GetTableName: string;
begin
  Result:=FTableName;
end;

constructor TDBTriggerObject.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  FActive:=true;
end;

{ TSQLEngineAbstract }

procedure TSQLEngineAbstract.SetPassword(const AValue: string);
begin
  if FPassword=AValue then exit;
  FPassword:=AValue;
end;

procedure TSQLEngineAbstract.ClearQueryControlList;
var
  i:integer;
begin
  for i:=0 to FQueryControlList.Count - 1 do
    TSQLQueryControl(FQueryControlList[i]).Free;
end;

function TSQLEngineAbstract.GetServerInfoVersion: string;
begin
  Result:='';
end;

procedure TSQLEngineAbstract.AddObjectsGroup(var AItem;
  AGroupClass: TDBRootObjectClass; ADBObjectClass: TDBObjectClass;
  const ACaption: string);
var
  G:TDBRootObject absolute AItem;
begin
  G:=AGroupClass.Create(self, ADBObjectClass, ACaption, nil);
  if Assigned(G) then
    FGroups.Add(G);
end;

procedure TSQLEngineAbstract.DoBeforeDisconnect;
begin

end;

procedure TSQLEngineAbstract.DoBeforeConnect;
var
  i: Integer;
begin
  for i:=0 to FConnectionPlugins.Count-1 do
    if FConnectionPlugins[i].Enabled then
      FConnectionPlugins[i].Connected:=true;
end;

procedure TSQLEngineAbstract.DoAfterDisconnect;
var
  i: Integer;
begin
  for i:=0 to FConnectionPlugins.Count-1 do
    if FConnectionPlugins[i].Connected then
      FConnectionPlugins[i].Connected:=false;
end;

procedure TSQLEngineAbstract.DoAfterConnect;
begin

end;

procedure TSQLEngineAbstract.NotyfiOnDestroy(ADBObject: TDBObject);

procedure DoNotify(R: TDBRootObject);
var
  i: Integer;
begin
  if not Assigned(R) then exit;

  for i:=0 to R.CountGroups - 1 do
    DoNotify(R.Groups[i]);

  for i:=0 to R.CountObject-1 do
    R[i].NotyfiOnDestroy(ADBObject);

  R.NotyfiOnDestroy(ADBObject);
end;

var
//  i: Integer;
  G: TDBObject;

begin
{  for i:=0 to CountRootObject-1 do
    DoNotify(RootObject[i]);}
  for G in Groups do
    DoNotify(G as TDBRootObject);

  if Assigned(FOnDestroyObject) then
    FOnDestroyObject(ADBObject);
end;

function TSQLEngineAbstract.GetImageIndex: integer;
begin
  if FConnected then
    Result:=0
  else
    Result:=1;
end;

procedure TSQLEngineAbstract.SetUIShowSysObjects(const AValue: TUIShowSysObjects
  );
begin
  if FUIShowSysObjects = AValue then exit;
  FUIShowSysObjects:=AValue;
end;

procedure TSQLEngineAbstract.SetDataBaseName(const AValue: string);
begin
  if FDataBaseName=AValue then exit;
  FDataBaseName:=AValue;
end;

procedure TSQLEngineAbstract.InternalInitEngine;
begin
  MiscOptions.VarPrefix:=':';
  MiscOptions.ObjectNamesCharCase:=ccoNoneCase;
  FKeywordsList:=TObjectList.Create;
  FQueryControlList:=TList.Create;
  FSQLEngineLogOptions:=TSQLEngineLogOptions.Create;
  FDisplayDataOptions:=TSQLEngineDisplayDataOptions.Create;
  FTypeList:=TDBMSFieldTypeList.Create;
  FSQLEngineCapability:=[];
  FCashedItems:=TDBObjectsItems.Create;
end;

procedure TSQLEngineAbstract.SetServerName(const AValue: string);
begin
  if FServerName=AValue then exit;
  FServerName:=AValue;
end;

procedure TSQLEngineAbstract.SetUserName(const AValue: string);
begin
  if FUserName=AValue then exit;
  FUserName:=AValue;
end;

function TSQLEngineAbstract.GetConnected: boolean;
begin
  Result:=FConnected;
end;

function TSQLEngineAbstract.InternalSetConnected(const AValue: boolean
  ): boolean;
begin
  Result:=false;
end;

procedure TSQLEngineAbstract.SetConnected(const AValue: boolean);
var
  i: Integer;
  G: TDBObject;
  SErrorMsg:string;
begin
  if FConnected = AValue then exit;

  if AValue then
    DoBeforeConnect
  else
    DoBeforeDisconnect;

  SErrorMsg:='';
  try
    FConnected:=InternalSetConnected(AValue);
  except
    on E:Exception do
    begin
      FConnected:=false;
      SErrorMsg:=E.Message;
    end;
  end;

  if FConnected then
  begin
    DoAfterConnect;
    InitGroupsObjects
  end
  else
  begin
    for G in Groups do
      TDBRootObject(G).Clear;
    Groups.Clear;
    DoneGroupsObjects;
    DoAfterDisconnect;
  end;

  if SErrorMsg <> '' then
    raise Exception.Create(SErrorMsg);
end;

constructor TSQLEngineAbstract.Create;
begin
  inherited Create;
  FProperties:=TStringList.Create;
  FGroups:=TDBObjectsList.Create(true);
  FConnectionPlugins:=TSQLEngineConnectionPlugins.Create;
  InternalInitEngine;
end;

destructor TSQLEngineAbstract.Destroy;
begin
  ClearQueryControlList;
  FConnectionPlugins.Clear;
  FreeAndNil(FConnectionPlugins);
  FreeAndNil(FSQLEngineLogOptions);
  FreeAndNil(FQueryControlList);
  FreeAndNil(FKeywordsList);
  FreeAndNil(FCashedItems);
  FreeAndNil(FTypeList);
  FreeAndNil(FGroups);
  FreeAndNil(FProperties);
  inherited Destroy;
end;

procedure TSQLEngineAbstract.Load(const AData: TDataSet);
begin
  //Show system objects
  if AData.FieldByName('show_system_domains').AsBoolean then
    UIShowSysObjects:=UIShowSysObjects + [ussSystemDomain];
  if AData.FieldByName('show_system_tables').AsBoolean then
    UIShowSysObjects:=UIShowSysObjects + [ussSystemTable];
  if AData.FieldByName('show_system_views').AsBoolean then
    UIShowSysObjects:=UIShowSysObjects + [ussSystemView];

  if AData.FieldByName('show_child_objects').AsBoolean then
    UIShowSysObjects:=UIShowSysObjects + [ussExpandObjectDetails];

  FDatabaseID:=AData.FieldByName('db_database_id').AsInteger;
  FDataBaseName:=AData.FieldByName('db_database_database_name').AsString;
  FUserName:=AData.FieldByName('db_database_username').AsString;
  FPassword:=AData.FieldByName('db_database_password').AsString;
  FAliasName:=AData.FieldByName('db_database_caption').AsString;
  FServerName:=AData.FieldByName('db_database_server_name').AsString;
  FReportManagerFolder:=AData.FieldByName('report_manager_folder').AsString;
  FDescription:=AData.FieldByName('db_database_description').AsString;

  FSQLEngineLogOptions.Load(AData);
  FDisplayDataOptions.Load(AData);

  FSPEditLazzyMode:=AData.FieldByName('sp_editor_lazzy_mode').AsBoolean;
  FTriggerEditLazzyMode:=AData.FieldByName('trg_editor_lazzy_mode').AsBoolean;
  FRemotePort:=AData.FieldByName('db_database_remote_port').AsInteger;
end;

procedure TSQLEngineAbstract.Store(const AData: TDataSet);
begin
  AData.FieldByName('show_system_domains').AsBoolean:=ussSystemDomain in FUIShowSysObjects;
  AData.FieldByName('show_system_tables').AsBoolean:=ussSystemTable in FUIShowSysObjects;
  AData.FieldByName('show_system_views').AsBoolean:=ussSystemView in FUIShowSysObjects;
  AData.FieldByName('show_child_objects').AsBoolean:=ussExpandObjectDetails in FUIShowSysObjects;
  AData.FieldByName('db_database_database_name').AsString:=FDataBaseName;
  AData.FieldByName('db_database_username').AsString:=FUserName;
  AData.FieldByName('db_database_password').AsString:=FPassword;
  AData.FieldByName('db_database_caption').AsString:=FAliasName;
  AData.FieldByName('db_database_server_name').AsString:=FServerName;
  AData.FieldByName('report_manager_folder').AsString:=FReportManagerFolder;
  AData.FieldByName('db_database_description').AsString:=FDescription;

  FSQLEngineLogOptions.Store(AData);
  FDisplayDataOptions.Store(AData);

  AData.FieldByName('sp_editor_lazzy_mode').AsBoolean:=FSPEditLazzyMode;
  AData.FieldByName('trg_editor_lazzy_mode').AsBoolean:=FTriggerEditLazzyMode;
  AData.FieldByName('db_database_remote_port').AsInteger:=FRemotePort;
end;

procedure TSQLEngineAbstract.SetSqlAssistentData(const List: TStrings);
var
  S: String;
begin
  List.Add(ClassName + ' : ' + AliasName);
  S:=GetServerInfoVersion;
  if S <> '' then
    List.Add(sServerVersion + S);

  if upRemote in UIParams then
    List.Add(sServerName + ServerName);
  List.Add(sDatabaseName + DataBaseName);
  if upUserName in UIParams then
    List.Add(sUserName + UserName);
end;

procedure TSQLEngineAbstract.FillCharSetList(const List: TStrings);
begin

end;

procedure TSQLEngineAbstract.FillCollationList(const ACharSet: string;
  const List: TStrings);
begin

end;

function TSQLEngineAbstract.ExecuteSQLScript(const ASQL: string;
  OnExecuteSqlScriptProcessEvent: TExecuteSqlScriptProcessEvent): boolean;
begin
  Result:=false;
end;

procedure TSQLEngineAbstract.RefreshObjectsBegin(const ASQLText:string);
begin

end;

procedure TSQLEngineAbstract.RefreshObjectsEnd(const ASQLText:string);
begin
  FCashedItems.RelaseTypes(ASQLText);
end;

procedure TSQLEngineAbstract.RefreshObjectsBeginFull;
begin
  {$IFDEF DEBUG}
  raise Exception.CreateFmt('For %s not writed metod "%s.RefreshObjectsBeginFull"', [GetEngineName, ClassName]);
  {$ENDIF}
end;

procedure TSQLEngineAbstract.RefreshObjectsEndFull;
begin
  {$IFDEF DEBUG}
  raise Exception.CreateFmt('For %s not writed metod "%s.RefreshObjectsEndFull"', [GetEngineName, ClassName]);
  {$ENDIF}
end;

function TSQLEngineAbstract.OpenDataSet(Sql: string; AOwner:TComponent): TDataSet;
begin
  Result:=nil;
end;

function TSQLEngineAbstract.ExecSQL(const Sql:string;const ExecParams:TSqlExecParams): boolean;
begin
end;

function TSQLEngineAbstract.SQLPlan(aDataSet: TDataSet): string;
begin
  Result:='';
end;

function TSQLEngineAbstract.DBObjectByName(AName: string; ARefreshObject:boolean = true): TDBObject;
var
  P: TDBObject;
begin
  Result:=nil;
  if AName = '' then exit;
  AName := UpperCase(AName);
  for P in Groups do
  begin
    Result:=TDBRootObject(P).ObjByName(AName, ARefreshObject);
    if Assigned(Result) then
      exit;
  end;
end;

procedure TSQLEngineAbstract.FillListForNames(Items: TStrings;
  ObjectKinds: TDBObjectKinds);

procedure DoFill(AItem:TDBRootObject);
var
  G: TDBObject;
begin
  if Assigned(AItem) then
  begin
    for G in AItem.FGroupObjects do
      DoFill(TDBRootObject(G));

    if AItem.DBObjectKind in ObjectKinds then
      AItem.FillListForNames(Items, true);
  end;
end;

var
  P: TDBObject;
begin
  for P in Groups do
    DoFill(TDBRootObject(P));
end;

procedure TSQLEngineAbstract.InternalError(AErrorMessage: string);
begin
  if Assigned(FOnInternalError) then
    FOnInternalError(AErrorMessage);
end;

procedure TSQLEngineAbstract.InternalErrorEx(AErrorMessage: string;
  AParams: array of const);
begin
  InternalError(Format(AErrorMessage, AParams));
end;

procedure TSQLEngineAbstract.FillDomainsList(const Items: TStrings; const ClearItems:boolean);
begin
  FillListForNames(Items, [okDomain]);
end;

procedure TSQLEngineAbstract.FillStdTypesList(const Items: TStrings);
var
  i:integer;
begin
  Items.Clear;
  for i:=0 to FTypeList.Count - 1 do
    Items.Add(FTypeList[i].TypeName);
end;
(*
function TSQLEngineAbstract.ShowObjectItem: integer;
begin
  Result:=0;
end;
*)
function TSQLEngineAbstract.NewObjectByKind(AOwnerRoot: TDBRootObject;
  ADBObjectKind: TDBObjectKind): TDBObject;
begin
  if Assigned(FOnNewObjectByKind) then
    Result:=FOnNewObjectByKind(AOwnerRoot, ADBObjectKind)
  else
    Result:=nil;
end;

function TSQLEngineAbstract.EditObject(ADBObject: TDBObject): boolean;
begin
  if Assigned(FOnEditObject) then
    Result:=OnEditObject(ADBObject)
  else
    Result:=false;
end;

function TSQLEngineAbstract.RefreshEditor(ADBObject: TDBObject): boolean;
begin
  if Assigned(FOnEditObject) then
    Result:=OnRefreshObject(ADBObject)
  else
    Result:=false;
end;

function TSQLEngineAbstract.CreateObject(ADBObjectKind: TDBObjectKind;
  AOwnerObject: TDBObject): TDBObject;
begin
  if Assigned(FOnCreateObject) then
    Result:=FOnCreateObject(ADBObjectKind, AOwnerObject)
  else
    Result:=nil;
end;


{ TDBRootObject }

function TDBRootObject.GetCountObject: integer;
begin
  Result:=FObjects.Count;
end;

function TDBRootObject.GetDDLAlter: string;
begin
  Result:='';
end;

function TDBRootObject.DBMSObjectsList: string;
begin
  Result:='';
end;

function TDBRootObject.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem);
end;

function TDBRootObject.GetItems(AIndex: integer): TDBObject;
begin
  Result:=FObjects[AIndex];
end;

function TDBRootObject.GetGroups(AIndex: integer): TDBRootObject;
begin
  Result:=TDBRootObject(FGroupObjects.FList[AIndex]);
end;

function TDBRootObject.GetCountGroups: integer;
begin
  Result:=FGroupObjects.Count;
end;

function TDBRootObject.GetObjName(AIndex: integer): string;
begin
  Result:=TDBObject(FObjects[AIndex]).FCaption;
end;

constructor TDBRootObject.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(nil, AOwnerRoot);
  FObjects:=TDBObjectsList.Create(true);
  FGroupObjects:=TDBObjectsList.Create(true);
  FCaption:=ACaption;
  FOwnerDB:=AOwnerDB;
  FDBObjectClass:=ADBObjectClass;
  FObjectEditable:=false;
  State:=sdboVirtualObject;
end;

constructor TDBRootObject.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  FObjects:=TDBObjectsList.Create(true);
  FGroupObjects:=TDBObjectsList.Create(true);
  FOwnerDB:=AOwnerRoot.OwnerDB;
  FDBObjectClass:=AOwnerRoot.DBObjectClass;
  FObjectEditable:=true;
  State:=sdboEdit;
end;

destructor TDBRootObject.Destroy;
begin
  FObjects.Clear;
  FreeAndNil(FObjects);
  FreeAndNil(FGroupObjects);
  inherited Destroy;
end;

procedure TDBRootObject.Clear;
begin
  FObjects.Clear;
end;

procedure TDBRootObject.RefreshGroup;
var
  FOldObject: TStringList;
  S: String;
  I: Integer;
  DL: TDBItems;
  P: TDBItem;
  D: TObject;
begin
  FOldObject:=TStringList.Create;
  FOldObject.Sorted:=true;
  try
    FillListForNames(FOldObject, false);

    S:=DBMSObjectsList;
    if S<>'' then
    begin
      OwnerDB.RefreshObjectsBegin(S);
      DL:=OwnerDB.CashedItems[S];

      if Assigned(DL) then
      begin
        for P in DL do
        begin
          if DBMSValidObject(P) then
          begin
            I:=FOldObject.IndexOf(P.ObjName);
            if I < 0 then
              DBObjectClass.Create(P, Self)
            else
            begin
              D:=TObject( FOldObject.Objects[i]);
              if Assigned(D) and (D is TDBObject) then
                TDBObject(D).ResincObject(P);
              FOldObject.Delete(i);
            end;
          end
        end;
      end;

      OwnerDB.RefreshObjectsEnd(S);
    end;
    for i:=FObjects.Count-1 downto 0 do
      if FOldObject.IndexOf(FObjects[i].Caption) >= 0 then
        FObjects.Delete(i);

  finally
    FOldObject.Free;
  end;
end;

procedure TDBRootObject.FillListForNames(Items: TStrings; AFullNames: Boolean);
var
  P: TDBObject;
begin
  for P in FGroupObjects do
  begin
    if P.State = sdboEdit then
    begin
      if AFullNames then
        Items.AddObject(P.CaptionFullPatch, P)
      else
        Items.AddObject(P.Caption, P);
    end;
  end;

  for P in FObjects do
  begin
    if P.State = sdboEdit then
    begin
      if AFullNames then
        Items.AddObject(P.CaptionFullPatch, P)
      else
        Items.AddObject(P.Caption, P);
    end;
  end;
end;

function TDBRootObject.NewDBObject: TDBObject;
begin
  if Assigned(FDBObjectClass) then
  begin
    Result:=TDBObjectClass(FDBObjectClass).Create(nil, Self);
    Result.State:=sdboCreate;
    Result.FOwnerRoot:=Self;
  end;
end;

function TDBRootObject.DropObject(AItem: TDBObject): boolean;
var
  R: TSQLDropCommandAbstract;
begin
  Result:=false;
  if Assigned(FDropCommandClass) then
  begin
    R:=FDropCommandClass.Create(nil);
    AItem.InternalPrepareDropCmd(R);
    R.Name:=AItem.Caption;
    R.SchemaName:=AItem.SchemaName;
    R.ObjectKind:=DBObjectKind;
    if (R is TSQLDropTrigger) and (AItem is TDBTriggerObject) then
      TSQLDropTrigger(R).TableName:=TDBTriggerObject(AItem).TableName;

    Result:=ExecSQLScript(R.AsSQL, [sepInTransaction, sepShowCompForm], OwnerDB);
    R.Free;

    if Result then
    begin
      if Assigned(AItem.FOwnerDB) then
        FOwnerDB.NotyfiOnDestroy(AItem);
      FObjects.Delete(AItem);
    end;
  end;
end;

function TDBRootObject.ObjByName(AName: string; ARefreshObject:boolean = true): TDBObject;
var
  i, P:integer;
  S1, S2:string;
begin
  Result:=nil;
  AName:=UpperCase(AName);

  S2:=AName;
  if UpperCase(Caption) = S2 then
  begin
    Result:=Self;
    exit;
  end;

  for i:=0 to CountGroups - 1 do
  begin
    Result:=Groups[i].ObjByName(S2, ARefreshObject);
    if Assigned(Result) then
      break;
  end;

  if not Assigned(Result) then
    for i:=0 to FObjects.Count-1 do
    begin
      if UpperCase(TDBObject(FObjects.Items[i]).Caption) = S2 then
      begin
        Result:=TDBObject(FObjects.Items[i]);
        break;
      end;
    end;

  if ARefreshObject and Assigned(Result) and not Result.Loaded then
    Result.RefreshObject;
end;

{ TDBObject }

procedure TDBObject.SetDescription(const AValue: string);
var
  FCommentOn: TSQLCommentOn;
  S: String;
begin
  FDescription:= TrimRight(AValue);
  if Assigned(OwnerDB) and (feDescribeObject in OwnerDB.SQLEngileFeatures) and (State <> sdboCreate) then
  begin
    if Assigned(OwnerDB.FSQLCommentOnClass) then
    begin
      FCommentOn:=OwnerDB.FSQLCommentOnClass.Create(nil);
      FCommentOn.Name:=Caption;
      THackComment(FCommentOn).SchemaName:=SchemaName;
      FCommentOn.ObjectKind:=DBObjectKind;
      FCommentOn.Description:=Description;
      InternalSetDescription(FCommentOn);
      S:=FCommentOn.AsSQL;
      if S<>'' then
        ExecSQLScript(S, sysConfirmCompileDescEx + [sepInTransaction], OwnerDB);
      FCommentOn.Free;
    end
    else
      raise Exception.CreateFmt('Object %:%s - not defined COMMENT ON class', [CaptionFullPatch, ClassName]);
  end;
end;

function TDBObject.GetDDLCreateSimple: string;
begin
  if not FLoaded then
    RefreshObject;
  Result:=InternalGetDDLCreate + LineEnding;
end;

function TDBObject.GetEnableRename: boolean;
begin
  Result:=false;
end;

procedure TDBObject.SetCaption(AValue: string);
begin
{  if Assigned(OwnerDB) then
    FCaption:=FormatStringCase(AValue, OwnerDB.MiscOptions.ObjectNamesCharCase)
  else }
    FCaption:=AValue;
end;

function TDBObject.GetEnableDropped: boolean;
begin
  Result:=Assigned(OwnerRoot) and Assigned(OwnerRoot.FDropCommandClass) and (not FSystemObject);
end;

procedure TDBObject.NotyfiOnDestroy(ADBObject: TDBObject);
begin
  //
end;

procedure TDBObject.InternalPrepareDropCmd(R: TSQLDropCommandAbstract);
begin
  //
end;

procedure TDBObject.InternalRefreshStatistic;
begin
  Statistic.AddValue(sCaption, CaptionFullPatch);
end;

function TDBObject.GetCaptionFullPatch: string;
begin
  Result:=DoFormatName(FCaption);
end;

function TDBObject.GetCaption: string;
begin
  Result:=FCaption;
end;

function TDBObject.SQLScriptsExec(const S: string;
  const ExecParams: TSqlExecParams): boolean;
begin
  if Assigned(FSqlStrings) then
  begin
    FSqlStrings.Add(S);
    Result:=true;
  end
  else
    Result:=ExecSQLScript(S, ExecParams, FOwnerDB);
end;

function TDBObject.MakeRemarkBlock(S: string): string;
var
  b1, b2, ls:integer;
  S1:string;
begin
  Result:='/'+DupeString('*', DDLRemarkLineLength - 2)+'/' + LineEnding;
  while (S<>'') do
  begin
    S1:=strutils.Copy2SymbDel(S, '|');
    ls:=UTF8Length(S1);
    b1:= (DDLRemarkLineLength - 6 - ls) div 2;
    b2:=DDLRemarkLineLength  - b1 - 6 - ls;
    S1:='/**'+DupeString(' ', b1)+ S1 + DupeString(' ', b2)+'**/';
    Result:=Result + S1 + LineEnding;

  end;
  Result:=Result + '/'+DupeString('*', DDLRemarkLineLength - 2)+'/' + LineEnding;
end;

procedure TDBObject.SetState(const AValue: TDBObjectState);
begin
  FState:=AValue;
end;

procedure TDBObject.InternalSetDescription(ACommentOn: TSQLCommentOn);
begin
  //
end;

function TDBObject.InternalGetDDLCreate: string;
begin
  Result:='';
end;

function TDBObject.GetDDLCreate: string;
var
  S: String;
begin
  if not FLoaded then
    RefreshObject;
  S:=DateTimeToStr(Now);
  if Assigned(OwnerDB) then
    S:=S + '|' + OwnerDB.UserName + ' ' + OwnerDB.DataBaseName;
  Result:=MakeRemarkBlock(S)
    + InternalGetDDLCreate;
end;

procedure TDBObject.SetOwnerRoot(AValue: TDBRootObject);
begin
  if FOwnerRoot=AValue then Exit;

  if Self is TDBRootObject then
  begin
    if Assigned(FOwnerRoot) then
    begin
      if Assigned(FOwnerRoot.FGroupObjects) and (FOwnerRoot.FGroupObjects.IndexOf(Self) >= 0) then
        FOwnerRoot.FGroupObjects.Extract(Self);
    end;
    FOwnerRoot:=AValue;
    if Assigned(FOwnerRoot) and (FOwnerRoot.FGroupObjects.IndexOf(Self) < 0) then
      FOwnerRoot.FGroupObjects.Add(Self);
  end
  else
  begin
    if Assigned(FOwnerRoot) then
    begin
      if Assigned(FOwnerRoot.FObjects) and (FOwnerRoot.FObjects.IndexOf(Self) >= 0) then
        FOwnerRoot.FObjects.Extract(Self);
    end;
    FOwnerRoot:=AValue;
    if Assigned(FOwnerRoot) and (FOwnerRoot.FObjects.IndexOf(Self)<0) then
      FOwnerRoot.FObjects.Add(Self);
  end;

  if Assigned(FOwnerRoot) then
    FSystemObject:=FOwnerRoot.SystemObject
  else
    FSystemObject:=false;
end;

constructor TDBObject.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject);
begin
  inherited Create;
  FStatistic:=TDBTableStatistic.Create(Self);
  FLoaded:=false;
  OwnerRoot:=AOwnerRoot;

  if Assigned(FOwnerRoot) then
  begin
    FOwnerDB:=FOwnerRoot.FOwnerDB;
    FDBObjectKind:=FOwnerRoot.FDBObjectKind;
  end;

  if Assigned(ADBItem) then
  begin
    FCaption:=ADBItem.ObjName;
    FDescription:=ADBItem.ObjDesc;
  end;

  State:=sdboEdit;
  DependList:=TDependRecordList.Create;
  FObjectEditable:=true;
end;

destructor TDBObject.Destroy;
begin
  FreeAndNil(DependList);
  if Assigned(FACLList) then
    FreeAndNil(FACLList);
  FreeAndNil(FStatistic);
  OwnerRoot:=nil;
  inherited Destroy;
end;

procedure TDBObject.Edit;
begin
  if Assigned(OwnerDB) then
    OwnerDB.EditObject(Self);
end;

procedure TDBObject.RefreshEditor;
begin
  if Assigned(OwnerDB) then
    OwnerDB.RefreshEditor(Self);
end;

procedure TDBObject.OnCloseEditorWindow;
begin
  //Событие возникает при закрытии окна редактора
end;

function TDBObject.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=nil;
end;

function TDBObject.GetDDLSQLObject(ACommandType: TDDLCommandType
  ): TSQLCommandDDL;
begin
  Result:=nil;
end;

function TDBObject.CompileSQLObject(ASqlObject: TSQLCommandDDL;
  ASqlExecParam: TSqlExecParams): boolean;
begin
  if OwnerDB.MiscOptions.ObjectNamesCharCase = ccoUpperCase then
    ASqlObject.Name:=UTF8UpperString(ASqlObject.Name)
  else
  if OwnerDB.MiscOptions.ObjectNamesCharCase = ccoLowerCase then
    ASqlObject.Name:=UTF8LowerCase(ASqlObject.Name);

  Result:=ExecSQLScriptEx(ASqlObject.SQLText, ASqlExecParam, FOwnerDB);
  if Result then
  begin
    if (State = sdboCreate) then
    begin
      State:=sdboEdit;
      Caption:=ASqlObject.Name;
    end;

    if not (sepNotRefresh in ASqlExecParam) then
      RefreshObject;
  end;
end;

class function TDBObject.DBClassTitle: string;
begin
  Result:=ClassName;
end;

procedure TDBObject.SQLScriptsBegin;
begin
  inc(FSQLScriptsLock);
  if not Assigned(FSqlStrings) then
    FSqlStrings:=TStringList.Create;
end;

procedure TDBObject.SQLScriptsEnd;
begin
  if Assigned(FSqlStrings) then
    FreeAndNil(FSqlStrings);
  FSQLScriptsLock:=0;
end;

function TDBObject.SQLScriptsApply:boolean;
begin
  if not Assigned(FSqlStrings) then
  begin
    Result:=false;
    exit;
  end;

  Dec(FSQLScriptsLock);

  if FSQLScriptsLock>0 then
    Result:=true
  else
  if Assigned(FSqlStrings) then
  begin
    if FSqlStrings.Count > 0 then
      Result:=ExecSQLScriptEx(FSqlStrings, [sepShowCompForm], FOwnerDB);
    SQLScriptsEnd;
  end;
end;

procedure TDBObject.MakeSQLStatementsList(AList: TStrings);
begin
  AList.AddObject('DDL', TObject(Pointer(0)));
end;

function TDBObject.MakeChildList: TStrings;
begin
  Result:=nil;
end;

procedure TDBObject.BeforeCreateObject;
begin

end;

function TDBObject.AfterCreateObject: boolean;
begin
  Result:=true;
end;

procedure TDBObject.FillFieldList(List: TStrings; ACharCase: TCharCaseOptions;
  AFullNames: Boolean);
begin

end;

procedure TDBObject.SetSqlAssistentData(const List: TStrings);
begin
  if not FLoaded then
    RefreshObject;
  List.Add(DBClassTitle + ' ' + Caption);
end;

procedure TDBObject.RefreshObject;
begin
  FLoaded:=true;
end;

procedure TDBObject.RefreshDependencies;
begin

end;

procedure TDBObject.RefreshDependenciesField(Rec: TDependRecord);
begin

end;

procedure TDBObject.ResincObject(const ADBItem: TDBItem);
begin
  if FDescription <> ADBItem.ObjDesc then
    FDescription:=ADBItem.ObjDesc;
end;

function TDBObject.RenameObject(ANewName: string): Boolean;
begin
  Result:=false;
end;

{ TDBTableObject }
function TDBTableObject.GetIndexFields(const AIndexName: string;
  const AForce: boolean): string;
var
  i:integer;
begin
  Result:='';

  if not AForce then
  begin
    for i:=0 to FIndexItems.Count-1 do
    begin
      if TIndexItem(FIndexItems[i]).IndexName = AIndexName then
      begin
        Result:=TIndexItem(FIndexItems[i]).IndexField;
        exit;
      end;
    end;
  end;
end;

function TDBTableObject.GetConstraint(AItem: integer): TPrimaryKeyRecord;
begin
  Result:=TPrimaryKeyRecord(FConstraintList[AItem]);
end;

function TDBTableObject.GetConstraintCount: integer;
begin
  Result:=FConstraintList.Count;
end;

procedure TDBTableObject.ClearConstraintList(AConstraintType: TConstraintType);
var
  I:integer;
  P:TPrimaryKeyRecord;
begin
  for i:=FConstraintList.Count - 1 downto 0 do
  begin
    P:=TPrimaryKeyRecord(FConstraintList[i]);
    if (AConstraintType = ctNone) or (P.ConstraintType = AConstraintType) then
    begin
      FConstraintList.Delete(i);
      P.Free;
    end;
  end;

  if AConstraintType in [ctNone, ctForeignKey] then
    FFKListLoaded:=false;
  if AConstraintType in [ctNone, ctPrimaryKey] then
    FPKListLoaded:=false;

  if AConstraintType = ctPrimaryKey then
    FPKCount:=0;
end;

procedure TDBTableObject.NotyfiOnDestroy(ADBObject: TDBObject);
begin
  inherited NotyfiOnDestroy(ADBObject);
  if ADBObject is TDBIndex then
  //;
end;

procedure TDBTableObject.IndexArrayClear;
var
  i: Integer;
begin
  inherited IndexArrayClear;
  for i:=FConstraintList.Count - 1 downto 0 do
    TPrimaryKeyRecord(FConstraintList[i]).Index:=nil;
end;

constructor TDBTableObject.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  FConstraintList:=TList.Create;
  FFKListLoaded:=false;
  FPKListLoaded:=false;
end;

destructor TDBTableObject.Destroy;
begin
  ClearConstraintList(ctNone);

  FreeAndNil(FConstraintList);
  inherited Destroy;
end;

function TDBTableObject.CompileSQLObject(ASqlObject: TSQLCommandDDL;
  ASqlExecParam: TSqlExecParams): boolean;
var
  C: TAlterTableOperator;
  FFlags: TTableCashedStateFlags;
begin
  if ASqlObject is TSQLAlterTable then
    if TSQLAlterTable(ASqlObject).Operators.Count = 0 then
      Exit(false);
  Result:=inherited CompileSQLObject(ASqlObject, ASqlExecParam);
  FFlags:=[];
  if ASqlObject is TSQLAlterTable then
  begin
    for C in TSQLAlterTable(ASqlObject).Operators do
      case C.AlterAction of
        ataAddTableConstraint,
        ataAddTableConstraintUsingIndex,
        ataAlterColumnConstraint,
        ataDropColumn,
        ataDropConstraint:FFlags:=FFlags + [csfLoadedPK, csfLoadedFK,  csfLoadedCHK,  csfLoadedUNQ];
        ataAddColumn:if C.Constraints.Count > 0 then
            FFlags:=FFlags + [csfLoadedPK, csfLoadedFK,  csfLoadedCHK,  csfLoadedUNQ];
      end;
  end;
  FCashedState := FCashedState - FFlags;
  if [csfLoadedPK, csfLoadedFK] * FFlags <> [] then
    IndexArrayClear;

  if csfLoadedPK in FFlags then
    RefreshConstraintPrimaryKey;

  if csfLoadedFK in FFlags then
    RefreshConstraintForeignKey;
end;

function TDBTableObject.ConstraintFind(ConstraintName: string): TPrimaryKeyRecord;
var
  i:integer;
begin
  if (FCashedState * [csfLoadedPK, csfLoadedFK, csfLoadedUNQ, csfLoadedCHK]) <> [csfLoadedPK, csfLoadedFK, csfLoadedUNQ, csfLoadedCHK] then
  begin
    if not (csfLoadedPK in FCashedState) then
      RefreshConstraintPrimaryKey;
    if not (csfLoadedFK in FCashedState) then
      RefreshConstraintForeignKey;
    if not (csfLoadedUNQ in FCashedState) then
      RefreshConstraintUnique;
  end;

  ConstraintName:=UpperCase(ConstraintName);
  Result:=nil;
  for i:=0 to FConstraintList.Count-1 do
  begin
    if UpperCase(TPrimaryKeyRecord(FConstraintList[i]).Name) = ConstraintName then
    begin
      Result:=TPrimaryKeyRecord(FConstraintList[i]);
      exit;
    end;
  end;
end;

procedure TDBTableObject.MakeSQLStatementsList(AList: TStrings);
begin
  inherited MakeSQLStatementsList(AList);
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

procedure TDBTableObject.RefreshConstraintPrimaryKey;
var
  F: TDBField;
begin
  ClearConstraintList(ctPrimaryKey);
  for F in Fields do F.FieldPK:=false;
  FCashedState:=FCashedState + [csfLoadedPK]
end;

procedure TDBTableObject.RefreshConstraintForeignKey;
begin
  FCashedState:=FCashedState + [csfLoadedFK];
  ClearConstraintList(ctForeignKey);
end;

procedure TDBTableObject.RefreshConstraintUnique;
var
  F: TDBField;
begin
  FCashedState:=FCashedState + [csfLoadedUNQ];
  ClearConstraintList(ctUnique);
  for F in Fields do F.FieldUNIC:=false;
end;

procedure TDBTableObject.RefreshConstraintCheck;
begin
  FCashedState:=FCashedState + [csfLoadedCHK];
  ClearConstraintList(ctTableCheck);
end;

{ TSQLQueryControl }

function TSQLQueryControl.GetActive: boolean;
begin
  Result:=DataSet.Active;
end;

procedure TSQLQueryControl.SetActive(const AValue: boolean);
begin
  if AValue then
    StartTransaction;
  DataSet.Active:=AValue;
  FBDataSetAfterOpen(DataSet);
end;

constructor TSQLQueryControl.Create(AOwner: TSQLEngineAbstract);
begin
  inherited Create;
  FOwner:=AOwner;
  FOwner.FQueryControlList.Add(Self);
end;

destructor TSQLQueryControl.Destroy;
begin
  FOwner.FQueryControlList.Remove(Self);
  inherited Destroy;
end;

function TSQLQueryControl.IsEditable: boolean;
begin
  Result:=false;
end;

procedure TSQLQueryControl.StartTransaction;
begin

end;

function TSQLQueryControl.ParseException(E: Exception; out X, Y: integer; out
  AMsg: string): boolean;
begin
  Result:=false;
end;

function TSQLQueryControl.LoadStatistic(out StatRec: TQueryStatRecord): boolean;
begin
  Result:=false;
  FillChar(StatRec, SizeOf(TQueryStatRecord), 0);
end;

{ TDBDataSetObject }

function TDBDataSetObject.GetRecordCount: integer;
begin
  if Assigned(DataSet(-1)) then
    Result:=DataSet(-1).RecordCount
  else
    Result:=0;
end;

procedure TDBDataSetObject.DataSetAfterOpen(DataSet: TDataSet);
begin
  FBDataSetAfterOpen(DataSet);
end;

function TDBDataSetObject.GetDBFieldClass: TDBFieldClass;
begin
  Result:=TDBField;
end;

procedure TDBDataSetObject.NotyfiOnDestroy(ADBObject: TDBObject);
var
  i, j: Integer;
begin
  inherited NotyfiOnDestroy(ADBObject);
  if ADBObject is TDBTriggerObject then
  begin
{
    FTriggerList[0].Clear;
    FTriggerList[1].Clear;
    FTriggerList[2].Clear;
    FTriggerList[3].Clear;
    FTriggerList[4].Clear;
    FTriggerList[5].Clear;
}
    for i:=0 to GetTriggersCategoriesCount-1 do
      for j:=0 to GetTriggersCount(i)-1 do
      begin
        if GetTrigger(i, j) = TDBTriggerObject(ADBObject) then
        begin
          TriggersListRefresh;
          RefreshEditor;
          Exit;
        end;
      end;
  end;
end;

function TDBDataSetObject.GetEnableRename: boolean;
begin
  Result:=utRenameTable in UITableOptions;
end;

procedure TDBDataSetObject.IndexArrayClear;
begin
  FIndexItems.Clear;
  FIndexListLoaded:=false;
end;

procedure TDBDataSetObject.IndexArrayCreate;
begin
  FIndexItems:=TIndexItems.Create(TIndexItem);
end;

function TDBDataSetObject.GetIndexCount: integer;
begin
  Result:=FIndexItems.Count;
end;

function TDBDataSetObject.GetIndexItem(AItem: integer): TIndexItem;
begin
  Result:=TIndexItem(FIndexItems[AItem]);
end;

function TDBDataSetObject.GetFields: TDBFields;
begin
{  if (State <> sdboCreate) and (FFields.Count = 0) then
    FieldListRefresh;}
  Result:=FFields;
end;

function TDBDataSetObject.GetTriggersCategoriesCount: integer;
begin
  Result:=0;
end;

function TDBDataSetObject.GetTriggersCount(AItem: integer): integer;
begin
  Result:=0;
end;

constructor TDBDataSetObject.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  FFields:=TDBFields.Create(Self, GetDBFieldClass);
  IndexArrayCreate;
end;

destructor TDBDataSetObject.Destroy;
begin
  if Assigned(FDataSet) then
    FreeAndNil(FDataSet);
  FreeAndNil(FFields);
  FreeAndNil(FIndexItems);
  inherited Destroy;
end;

procedure TDBDataSetObject.Commit;
begin
  if Assigned(FDataSet) then
    FDataSet.Active:=false;
end;

procedure TDBDataSetObject.RollBack;
begin
  if Assigned(FDataSet) then
    FDataSet.Active:=false;
end;

procedure TDBDataSetObject.SetSqlAssistentData(const List: TStrings);
var
  i:integer;
begin
  inherited SetSqlAssistentData(List);
  for i:=0 to Fields.Count - 1 do
    List.Add(Fields[i].FieldName+' : '+Fields[i].FieldTypeName);
end;

function TDBDataSetObject.MakeChildList: TStrings;
var
  F: TDBField;
begin
  Result:=nil;
  exit;
  if (ussExpandObjectDetails in OwnerDB.UIShowSysObjects) then
  begin
    if not Loaded then
      RefreshObject;
    Result:=TStringList.Create;
    for F in Fields do
      Result.AddObject(F.FieldName, TObject(Pointer(IntPtr(66))));
  end;
end;

procedure TDBDataSetObject.RecompileTriggers;
begin

end;

procedure TDBDataSetObject.AllTriggersSetActiveState(AState: boolean);
begin

end;

procedure TDBDataSetObject.FillFieldList(List: TStrings;
  ACharCase: TCharCaseOptions; AFullNames: Boolean);
var
  K:integer;
  F: TDBField;
begin
  if Fields.Count = 0 then RefreshFieldList;
  for F in Fields do
  begin
    if AFullNames then
      K:=List.Add(FormatStringCase(CaptionFullPatch + '.' + DoFormatName(F.FieldName), ACharCase))
    else
      K:=List.Add(FormatStringCase(DoFormatName(F.FieldName), ACharCase));
    List.Objects[K]:=F;
  end;
end;

{ TODO -oalexs : Доработать создание нового тригера - необходимо отслеживать имя таблицы и порядок срабатывания }
function TDBDataSetObject.TriggerNew(TriggerTypes:TTriggerTypes):TDBTriggerObject;
begin
  Result:=FOwnerDB.NewObjectByKind(OwnerRoot, okTrigger) as TDBTriggerObject;
  if Assigned(Result) then
  begin
    Result.TableName:=Caption;
    Result.TriggerType:=TriggerTypes;
    Result.Active:=true;
    Result.RefreshEditor;
  end;
end;

function TDBDataSetObject.TriggerDelete(const ATrigger:TDBTriggerObject): boolean;
begin
  OwnerDB.InternalError('Not complete function');
  Result:=false;
end;

function TDBDataSetObject.IndexFind(IndexName: string): TIndexItem;
var
  i:integer;
begin
  if not FIndexListLoaded then
    IndexListRefresh;

  IndexName:=UpperCase(IndexName);

  Result:=nil;
  for i:=0 to IndexCount-1 do
  begin
    if UpperCase(TIndexItem(FIndexItems[i]).IndexName) = IndexName then
    begin
      Result:=IndexItem[i];
      exit;
    end;
  end;
end;

{ TDBViewObject }

function TDBViewObject.GetSQLBody: string;
begin
  if FSQLBody = '' then
    RefreshObject;
  Result:=FSQLBody;
end;

procedure TDBViewObject.MakeSQLStatementsList(AList: TStrings);
begin
  inherited MakeSQLStatementsList(AList);
  AList.AddObject('Fields/Parameters list', TObject(Pointer(1)));
  AList.AddObject('SELECT', TObject(Pointer(2)));
  AList.AddObject('SELECT INTO', TObject(Pointer(3)));
  AList.AddObject('FOR SELECT', TObject(Pointer(4)));
  AList.AddObject('Name + Type', TObject(Pointer(9)));
end;

function TDBViewObject.CompileSQLObject(ASqlObject: TSQLCommandDDL;
  ASqlExecParam: TSqlExecParams): boolean;
var
  VSql: TSQLCreateView;
  F: TSQLParserField;
begin
  if (OwnerDB.MiscOptions.ObjectNamesCharCase in  [ccoUpperCase, ccoLowerCase]) then
  begin
    if ASqlObject is TSQLCreateView then
    begin
      VSql:=ASqlObject as TSQLCreateView;
      for F in VSql.Fields do
      begin;
        if OwnerDB.MiscOptions.ObjectNamesCharCase = ccoUpperCase then
          F.Caption:=UTF8UpperString(F.Caption)
        else
        if OwnerDB.MiscOptions.ObjectNamesCharCase = ccoLowerCase then
          F.Caption:=UTF8LowerCase(F.Caption);
      end;
    end;
  end;
  Result:=inherited CompileSQLObject(ASqlObject, ASqlExecParam);
end;

{ TDBFields }

function TDBFields.GetItem(AIndex: Integer): TDBField;
begin
  Result:=TDBField(FList[AIndex]);
end;

function TDBFields.IndexOf(AItem: TDBField): Integer;
begin
  Result:=FList.IndexOf(AItem);
end;

function TDBFields.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TDBFields.GetAsString: string;
var
  F: TDBField;
begin
  Result:='';
  for F in Self do
    Result:=Result + F.FieldName + ', ';
  Result:=Copy(Result, 1, Length(Result) - 2);
end;

constructor TDBFields.Create(AOwner: TDBObject; AFieldClass: TDBFieldClass);
begin
  inherited Create;
  FFieldClass:=AFieldClass;
  FList:=TObjectList.Create;
  FOwner:=AOwner;
end;

destructor TDBFields.Destroy;
begin
  FreeAndNil(FList);
  inherited Destroy;
end;

function TDBFields.FieldByName(AName: string): TDBField;
var
  i:integer;
begin
  AName:=UpperCase(AName);
  Result:=nil;
  for i:=0 to FList.Count - 1 do
  begin
    if UpperCase(Items[i].FieldName) = AName then
    begin
      Result:=Items[i];
      exit;
    end;
  end;
end;

function TDBFields.Add(AFieldName: string): TDBField;
begin
  Result:=FFieldClass.Create(FOwner);
  Result.FieldName:=AFieldName;
  FList.Add(Result);
end;

procedure TDBFields.Clear;
begin
  FList.Clear;
end;

procedure TDBFields.DeleteField(const AName: string);
var
  Rec:TDBField;
begin
  Rec:=FieldByName(AName);
  FList.Remove(Rec);
end;

function TDBFields.GetEnumerator: TDBFieldsEnumerator;
begin
  Result:=TDBFieldsEnumerator.Create(Self);
end;

procedure TDBFields.SaveToSQLFields(ASQLFields: TSQLFields);
var
  F: TDBField;
begin
  for F in Self do
  begin
    F.SaveToSQLFieldItem(ASQLFields.AddParam(F.FieldName));
  end;
end;

{ TFieldItem }

procedure TDBField.SetFieldTypeName(const AValue: string);
begin
  if FFieldTypeName=AValue then exit;
  FFieldTypeName:=AValue;
  FFieldTypeRecord := FOwner.OwnerDB.TypeList.FindType(FFieldTypeName);
end;

procedure TDBField.SetFieldOptions(AValue: TDBFieldOptions);
begin
  if FFieldOptions=AValue then Exit;
  FFieldOptions:=AValue;
end;

procedure TDBField.SetFieldComputedSource(AValue: string);
begin
  if FFieldComputedSource=AValue then Exit;
  FFieldComputedSource:=AValue;
  if AValue <> '' then
    FFieldOptions:=FFieldOptions + [foComputed]
  else
    FFieldOptions:=FFieldOptions - [foComputed];
end;

function TDBField.GetFieldIsLocal: boolean;
begin
  Result:=FIOType = spvtLocal;
end;

function TDBField.GetFieldTypeDB: TFieldType;
begin
  if Assigned(FFieldTypeRecord) then
    Result:=FFieldTypeRecord.DBType
  else
    Result:=ftUnknown;
end;

function TDBField.GetFieldDomain: TDBDomain;
begin
  if FieldTypeDomain <> '' then
    Result:=FOwner.OwnerDB.DBObjectByName(FieldTypeDomain, true) as TDBDomain
  else
    Result:=nil;
end;

procedure TDBField.SetFieldDescription(const AValue: string);
begin
  if FFieldDescription=AValue then exit;
  FFieldDescription:=TrimRight(AValue);
end;

constructor TDBField.Create(AOwner: TDBObject);
begin
  inherited Create;
  FOwner:=AOwner;
  FIOType:=spvtLocal;
end;

function TDBField.DDLTypeStr: string;
begin
  Result:=DoFormatName(FieldName) + DupeString(' ', 30 - Length(DoFormatName(FieldName)))+ ' ';
  if FieldTypeDomain<>'' then
    Result:=Result + FieldTypeDomain
  else
  begin
    if Assigned(FFieldTypeRecord) then
      Result:=Result + FFieldTypeRecord.GetFieldTypeStr(FieldSize, FieldPrec)
    else
    { TODO : Тут надо дописать обработку дополнительных типов данных }
      ;
  end;
  if FieldNotNull then
   Result:=Result + ' NOT NULL';

  if FieldDefaultValue <> '' then
     Result:=Result + ' DEFAULT '+FieldDefaultValue;
end;

procedure TDBField.LoadFromSQLFieldItem(SQLField: TSQLParserField);
begin
  if Assigned(SQLField) then
  begin
    FieldName:=SQLField.Caption;
    FieldTypeName:=SQLField.TypeName;
    //FieldTypeDB:TFieldType;
    //FieldSQLTypeInt:integer;
    //FieldSQLSubTypeInt:integer;
    //FieldTypeDomain:string;
    FieldSize:=SQLField.TypeLen;
    FieldPrec:=SQLField.TypePrec;
    //FieldUNIC:=
    FieldPK:=SQLField.PrimaryKey;
    FieldNotNull:=fpNotNull in SQLField.Params;
    //SystemField:boolean;
    //FieldNum:integer;
    FieldDefaultValue:=SQLField.DefaultValue;
    FieldAutoInc:=fpAutoInc in SQLField.Params;
    FFieldDescription:=SQLField.Description;
    //FieldIsLocal:boolean;
    FFieldCollateName:=SQLField.Collate;
    FieldComputedSource:=SQLField.ComputedSource;
    FIOType:=SQLField.InReturn;
  end;
end;

procedure TDBField.SaveToSQLFieldItem(SQLField: TSQLParserField);
begin
  if Assigned(SQLField) then
  begin
    SQLField.Caption      := FieldName;
    if Assigned(FieldDomain) then
      SQLField.TypeName     := FieldTypeDomain
    else
    begin
      SQLField.TypeName     := FieldTypeName;
      SQLField.TypeLen      := FieldSize;
      SQLField.TypePrec     := FieldPrec;
    end;
    //FieldUNIC
    SQLField.PrimaryKey     := FieldPK;
    //SystemField:boolean;
    //FieldNum:integer;
    SQLField.DefaultValue   := FieldDefaultValue;
    SQLField.Description    := FFieldDescription;
    SQLField.IsLocal        := FieldIsLocal;
    SQLField.Collate        := FFieldCollateName;
    SQLField.ComputedSource :=FieldComputedSource;
    SQLField.InReturn       :=FIOType;

    if FieldNotNull then
      SQLField.Params:=SQLField.Params + [fpNotNull]
    else
      SQLField.Params:=SQLField.Params - [fpNotNull];

    if FieldAutoInc then
    begin
      SQLField.Params:=SQLField.Params + [fpAutoInc];
      if FieldAutoIncInitialValue <> 0 then
        SQLField.AutoIncInitValue:=FieldAutoIncInitialValue;
    end
    else
      SQLField.Params:=SQLField.Params - [fpAutoInc];
  end;
end;

function TDBField.RefreshDependenciesFromField: TStringList;
begin
  //Result:=TDBObjectsList.Create(true);;
  Result:=nil;
end;

procedure TDBField.Clear;
begin
  FFieldSQLSubTypeInt:=0;
  FFieldTypeDomain:='';
  FFieldSize:=0;
  FFieldPrec:=0;
  FFieldUNIC:=false;
  FFieldPK:=false;
  FFieldNotNull:=false;
  FSystemField:=false;
  FFieldNum:=0;
  FFieldDefaultValue:='';
  FFieldAutoInc:=false;
  FFieldName:='';
  FFieldSQLTypeInt:=0;
  FFieldTypeRecord:=nil;
  FFieldTypeName:='';
  FFieldCollateName:='';
  FFieldCharSetName:='';
  FFieldComputedSource:='';
  FFieldOptions:=[];
  FIOType:=spvtLocal;
  FFieldAutoIncInitialValue:=0;
end;


{ TDBStoredProcObject }

constructor TDBStoredProcObject.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  FFieldsIN:=TDBFields.Create(Self, TDBField);
  FFieldsOut:=TDBFields.Create(Self, TDBField);
end;

destructor TDBStoredProcObject.Destroy;
begin
  FreeAndNil(FFieldsIN);
  FreeAndNil(FFieldsOut);
  inherited Destroy;
end;

procedure TDBStoredProcObject.SetSqlAssistentData(const List: TStrings);
var
  i:integer;
begin
  inherited SetSqlAssistentData(List);
  for i:=0 to FFieldsIN.Count-1 do
    List.Add(sInput + ' ' + FFieldsIN[i].FieldName);

  for i:=0 to FFieldsOut.Count-1 do
    List.Add(sOutput + ' ' + FFieldsOut[i].FieldName);
end;

function TDBStoredProcObject.MakeChildList: TStrings;
var
  F: TDBField;
  D: Integer;
begin
  Result:=nil;
  exit;
  if (ussExpandObjectDetails in OwnerDB.UIShowSysObjects) then
  begin
    if not Loaded then
      RefreshObject;
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

    for F in FFieldsOut do
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

procedure TDBStoredProcObject.FillFieldList(List: TStrings;
  ACharCase: TCharCaseOptions; AFullNames: Boolean);
var
  i:integer;
begin
  for i:=0 to FFieldsOut.Count - 1 do
    List.Add(FormatStringCase(FFieldsOut[i].FieldName, ACharCase));
end;

function TDBStoredProcObject.GetProcedureBody: string;
begin
  if not FLoaded then
    RefreshObject;
  Result:=FProcedureBody;
end;

procedure TDBStoredProcObject.RefreshParams;
begin
  FFieldsIN.Clear;
  FFieldsOut.Clear;
end;

end.


