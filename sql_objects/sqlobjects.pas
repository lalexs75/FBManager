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

unit sqlObjects;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, contnrs;

type
  TDDLCommandType = (ddlctCrate, ddlctAlter, ddlctDrop);

  TDBObjectKind = (okNone,
                   okDomain, okTable, okView, okTrigger, okStoredProc,
                   okSequence, okException, okUDF, okRole,
                   okUser, okScheme,
                   okGroup, okIndex, okTableSpace, okLanguage, okCheckConstraint,
                   okForeignKey, okPrimaryKey, okUniqueConstraint, okField,
                   okRule, okOther, okTasks,

                   okConversion, okDatabase, okType, okServer, okColumn,
                   okCharSet, okCollation, okFilter, okParameter,
                   okAccessMethod, okAggregate, okMaterializedView,
                   okCast,
                   okConstraint,
                   okExtension,

                   okForeignTable,
                   okForeignDataWrapper,
                   okForeignServer,

                   okLargeObject,
                   okPolicy,
                   okFunction, okEventTrigger,

                   okAutoIncFields, //-????
                   okFTSConfig,
                   okFTSDictionary,
                   okFTSParser,
                   okFTSTemplate,

                   okPackage,
                   okPackageBody,
                   okTransform,
                   okOperator,
                   okOperatorClass,
                   okOperatorFamily,
                   okUserMapping
                   );
  TDBObjectKinds = set of TDBObjectKind;

  TOnConflictEvent = (ceNone, ceRollback, ceAbort, ceFail, ceIgnore, ceReplace);

  TSPVarType = (spvtLocal, spvtInput, spvtOutput, spvtInOut, spvtVariadic,
    spvtTable, spvtSubFunction, spvtSubProc);

  TSPVarTypes = set of TSPVarType;

  TAlterTableAction =
    (ataNone,
     ataAddColumn,
     ataAlterColumnConstraint,

     ataDropColumn,
     ataDropConstraint,
     ataDropIndex,

     ataRenameTable,
     ataSetSchema,

     ataAlterCol ,
     ataAlterColumnSetDataType,
     ataAlterColumnSetDefaultExp,
     ataAlterColumnDropDefault,
     ataAlterColumnSetNotNull,
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
     ataOwnerTo,
     ataSetTablespace,
     ataAddIndex,
     ataSetParams,
     ataReSetParams
    );


  TAlterDomainAction = (adaRenameDomain, adaSetDefault, adaDropDefault,
    adaSetNotNull, adaDropNotNull,
    adaAddConstraint, adaDropConstraint, adaRenameConstraint,
    adaSetCheckExpression, adaDropCheckExpression,
    adaType,
    adaSetSchema, adaSetOwner, adaValidateConstraint);

  TForeignKeyRule = (fkrNone, fkrCascade, fkrSetNull, fkrSetDefault, fkrRestrict);
  TConstraintType = (ctNone, ctPrimaryKey, ctForeignKey, ctUnique, ctTableCheck);

  //type of index sort orders
  TIndexSortOrder = (indDefault, indAscending, indDescending);
  TIndexNullPos   = (inpDefault, inpFirst, inpLast);   //Положение null-значений (первые/последние)

  TFieldParam = (fpBinary, fpUnsigned, fpZeroFill, fpNotNull, fpNull, fpAutoInc, fpPrimaryKey, fpVirtual, fpStored, fpLocal,
    fpUnique);
  TFieldParams = set of TFieldParam;

  TFieldFormat = (ffDefault, ffFixed, ffDynamic);
  TFieldStorage = (fsDefault, fsDisk, fsMemory);

  TMatchParam = (maNone, maFull, maPartial, maSimple);

  TSQLObjectOption = (ooTemporary, ooIfNotExists, ooIfExists);
  TSQLObjectOptions = set of TSQLObjectOption;
  TDropRule = (drNone, drCascade, drRestrict);
  TCascadeRule = TDropRule;

  TJoinType = (jtInner, jtLeft, jtRight, jtFull);
  TJoinOption = (joNatural, joOuter, joCrossJoin);
  TJoinOptions = set of TJoinOption;

  TOnCommitAction = (caNone, caPreserveRows, caDeleteRows, caDrop);
  TSQLTableItemType = (stitTable, stitVirtualTable);
  TFieldAutoIncType = (faioNone, faioGeneratedAlways, faioGeneratedByDefault);
  TArrayFormat = (fafPostgreSQL, fafFirebirdSQL);

type
  TSQLFieldsEnumerator = class;
  TAlterTableOperatorsEnumerator = class;
  TSQLConstraintsEnumerator = class;
//  TGrantObjectsEnumerator = class;
  TSQLTablesEnumerator = class;
  TAlterDomainOperatorsEnumerator = class;
  TSQLParserFieldArraysEnumerator = class;

  { TIndexOptions }

  TIndexOptions = class
  private
    FIndexNullPos: TIndexNullPos;
    FSortOrder: TIndexSortOrder;
  public
    procedure Assign(ASource:TIndexOptions);
    procedure Clear;

    property SortOrder:TIndexSortOrder read FSortOrder write FSortOrder;
    property IndexNullPos:TIndexNullPos read FIndexNullPos write FIndexNullPos;
  end;

  { TSQLParserFieldArray }

  TSQLParserFieldArray = class
  private
    FDimension: integer;
    FDimensionEnd: integer;
  public
    procedure Assign(ASource:TSQLParserFieldArray);
    function AsString:string;
    property Dimension:integer read FDimension write FDimension;
    property DimensionEnd:integer read FDimensionEnd write FDimensionEnd;
  end;

  { TSQLParserFieldArrays }

  TSQLParserFieldArrays = class
  private
    FArrayFormat: TArrayFormat;
    FList:TFPList;
    function GetAsString: string;
    function GetCount: integer;
    function GetFields(AIndex: integer): TSQLParserFieldArray;
  public
    constructor Create;
    destructor Destroy;override;
    procedure Clear;
    procedure Assign(ASource:TSQLParserFieldArrays);
    function Add(ADimension:integer):TSQLParserFieldArray;
    function GetEnumerator: TSQLParserFieldArraysEnumerator;
    property Items[AIndex:integer]:TSQLParserFieldArray read GetFields; default;
    property Count:integer read GetCount;
    property AsString:string read GetAsString;
    property ArrayFormat:TArrayFormat read FArrayFormat write FArrayFormat;
  end;

  { TSQLParserFieldArraysEnumerator }

  TSQLParserFieldArraysEnumerator = class
  private
    FList: TSQLParserFieldArrays;
    FPosition: Integer;
  public
    constructor Create(AList: TSQLParserFieldArrays);
    function GetCurrent: TSQLParserFieldArray;
    function MoveNext: Boolean;
    property Current: TSQLParserFieldArray read GetCurrent;
  end;

  { TSQLParserField }

  TSQLParserField = class
  private
    FAutoIncInitValue: integer;
    FAutoIncType: TFieldAutoIncType;
    FCaption: string;
    FCharSetName: string;
    FCheckExpr: string;
    FCollate: string;
    FComputedSource: string;
    FConstraintName: string;
    FDefaultValue: string;
    FDescription: string;
    FFieldFormat: TFieldFormat;
    FFieldPosition: string;
    FFieldStorage: TFieldStorage;
    FIndexOptions: TIndexOptions;
    FInReturn: TSPVarType;
    FNotNullConflictRule: TOnConflictEvent;
    FObjectKind: TDBObjectKind;
    FParams: TFieldParams;
    FRealName: string;
    FTableName: string;
    //FTypeArrayDim: string;
    FTypeLen: integer;
    FTypeName: string;
    FTypeOf: boolean;
    FTypePrec: integer;
    FArrayDimension:TSQLParserFieldArrays;
    function GetIsLocal: boolean;
    function GetNotNull: boolean;
    function GetPrimaryKey: boolean;
    procedure SetIsLocal(AValue: boolean);
    procedure SetNotNull(AValue: boolean);
    procedure SetPrimaryKey(AValue: boolean);
  public
    constructor Create;
    destructor Destroy;override;
    function FullTypeName:string;
    procedure Assign(AItem:TSQLParserField);
    procedure Clear;

    property Caption:string read FCaption write FCaption;
    property ComputedSource:string read FComputedSource write FComputedSource;
    property PrimaryKey:boolean read GetPrimaryKey write SetPrimaryKey;
    property Params:TFieldParams read FParams write FParams;
    property FieldFormat:TFieldFormat read FFieldFormat write FFieldFormat;
    property FieldStorage:TFieldStorage read FFieldStorage write FFieldStorage;
    property FieldPosition:string read FFieldPosition write FFieldPosition;
    property ParamValue:string read FRealName write FRealName;
    property AutoIncInitValue:integer  read FAutoIncInitValue write FAutoIncInitValue;
    property AutoIncType:TFieldAutoIncType  read FAutoIncType write FAutoIncType;
    property ObjectKind:TDBObjectKind read FObjectKind write FObjectKind;
    property CheckExpr:string read FCheckExpr write FCheckExpr;
    property Collate:string read FCollate write FCollate;
    property CharSetName:string read FCharSetName write FCharSetName;
    property IsLocal:boolean read GetIsLocal write SetIsLocal;
    property NotNull:boolean read GetNotNull write SetNotNull;

    property RealName:string read FRealName write FRealName;
    property TableName:string read FTableName write FTableName;
    property Description:string read FDescription write FDescription;
    property DefaultValue:string read FDefaultValue write FDefaultValue;
    property InReturn:TSPVarType read FInReturn write FInReturn;
    property TypeName:string read FTypeName write FTypeName;
    property TypeLen:integer read FTypeLen write FTypeLen;
    property TypePrec:integer read FTypePrec write FTypePrec;
    property TypeOf:boolean read FTypeOf write FTypeOf;
    property NotNullConflictRule:TOnConflictEvent read FNotNullConflictRule write FNotNullConflictRule;
    property ArrayDimension:TSQLParserFieldArrays read FArrayDimension;
    property ConstraintName:string read FConstraintName write FConstraintName;
    property IndexOptions:TIndexOptions read FIndexOptions;
  end;


  { TSQLFields }

  TSQLFields = class
  private
    FList:TObjectList;
    function GetAsList: string;
    function GetAsString: string;
    function GetAsText: string;
    function GetCount: integer;
    function GetFields(AIndex: integer): TSQLParserField;
    procedure SetAsString(AValue: string);
  public
    constructor Create;
    destructor Destroy;override;
    procedure Clear;
    procedure Assign(ASource:TSQLFields);
    function AddParam(AName:string):TSQLParserField; overload;
    function AddParam(AItem:TSQLParserField):TSQLParserField; overload;
    function AddParamEx(AName, AValue:string):TSQLParserField;
    function AddParamWithType(AName, ATypeName: string): TSQLParserField;
    procedure CopyFrom(Src:TSQLFields; AParTypes:TSPVarTypes = []);
    function GetEnumerator: TSQLFieldsEnumerator;
    function FindParam(AName:string):TSQLParserField;
    property Fields[AIndex:integer]:TSQLParserField read GetFields; default;
    property Count:integer read GetCount;
    property AsString:string read GetAsString write SetAsString;
    property AsList:string read GetAsList;
    property AsText:string read GetAsText;
  end;

  { TSQLFieldsEnumerator }

  TSQLFieldsEnumerator = class
  private
    FList: TSQLFields;
    FPosition: Integer;
  public
    constructor Create(AList: TSQLFields);
    function GetCurrent: TSQLParserField;
    function MoveNext: Boolean;
    property Current: TSQLParserField read GetCurrent;
  end;

  { TTableItem }

  TTableItem = class
  private
    FFields:TSQLFields;
    FJoinExpression: string;
    FJoinOptions: TJoinOptions;
    FJoinType: TJoinType;
    FName: string;
    FObjectKind: TDBObjectKind;
    FSchemaName: string;
    FTableAlias: string;
    FTableExpression: string;
    FTableType: TSQLTableItemType;
    function GetFullName: string;
    procedure SetName(AValue: string);
  public
    constructor Create;
    destructor Destroy;override;
    procedure Assign(ASource:TTableItem);
    property FullName:string read GetFullName;
    property SchemaName:string read FSchemaName write FSchemaName;
    property Name:string read FName write SetName;
    property TableAlias:string read FTableAlias write FTableAlias;
    property JoinExpression:string read FJoinExpression write FJoinExpression;
    property JoinType:TJoinType read FJoinType write FJoinType;
    property JoinOptions:TJoinOptions read FJoinOptions write FJoinOptions;
    property TableType:TSQLTableItemType read FTableType write FTableType;
    property TableExpression:string read FTableExpression write FTableExpression;
    property Fields:TSQLFields read FFields;
    property ObjectKind:TDBObjectKind read FObjectKind write FObjectKind;
  end;

  { TSQLTables }

  TSQLTables = class
  private
    FList:TFPList;
    function GetAsString: string;
    function GetCount: integer;
    function GetItem(AIndex: integer): TTableItem;
  public
    constructor Create;
    destructor Destroy;override;
    function Add(ACaption:string):TTableItem;
    function Add(ACaption: string; AObjectKind: TDBObjectKind): TTableItem;
    procedure Clear;
    procedure Assign(ASource:TSQLTables);
    function GetEnumerator: TSQLTablesEnumerator;
    property Item[AIndex:integer]:TTableItem read GetItem; default;
    property Count:integer read GetCount;
    property AsString:string read GetAsString;
  end;

  { TSQLTablesEnumerator }

  TSQLTablesEnumerator = class
  private
    FList: TSQLTables;
    FPosition: Integer;
  public
    constructor Create(AList: TSQLTables);
    function GetCurrent: TTableItem;
    function MoveNext: Boolean;
    property Current: TTableItem read GetCurrent;
  end;

  { TSQLObjectAbstract }

  TSQLObjectAbstract = class
  private
    FChildList:TFPList;
    FSQLText:TStringList;
    function GetSQLText: TStringList;
    procedure DoMakeSQL;
  protected
    FName: string;
    FGenBeforeMainObj:boolean;
    procedure MakeSQL;virtual;
    procedure AddSQLCommand(ASQL:string; AddSeparator : boolean = true);
    procedure AddSQLCommandEx(ASQL:string; AParms : array of const);
    function GetFullName: string; virtual;
    procedure ClearChildList;
    procedure SetName(AValue: string); virtual;
  public
    constructor Create;
    destructor Destroy;override;
    procedure Clear; virtual;
    procedure AddChild(AChild:TSQLObjectAbstract);
    procedure Assign(ASource:TSQLObjectAbstract); virtual;

    function AsSQL:string; //virtual;
    property SQLText:TStringList read GetSQLText;
    property Name: string read FName write SetName;
    property FullName: string read GetFullName;
  end;

  { TSQLConstraintItem }

  TSQLConstraintItem = class
  private
    FConstraintExpression: string;
    FConstraintFields: TSQLFields;
    FConstraintName: string;
    FConstraintType: TConstraintType;
    FDescription: string;
    FForeignFields: TSQLFields;
    FForeignKeyRuleOnDelete: TForeignKeyRule;
    FForeignKeyRuleOnUpdate: TForeignKeyRule;
    FForeignTable: string;
    FIndexName: string;
    FIndexSortOrder: TIndexSortOrder;
    FIndexType: string;
    FMatch: TMatchParam;
    FNoInherit: boolean;
    FOnConflict: TOnConflictEvent;
    FParams: TSQLFields;
  public
    constructor Create;
    destructor Destroy;override;
    procedure Assign(ASource:TSQLConstraintItem);
    property ForeignFields:TSQLFields read FForeignFields;
    property ConstraintFields:TSQLFields read FConstraintFields;
    property IndexSortOrder:TIndexSortOrder read FIndexSortOrder write FIndexSortOrder;
    property IndexName:string read FIndexName write FIndexName;
    property IndexType:string read FIndexType write FIndexType;
    property Match:TMatchParam read FMatch write FMatch;
    property NoInherit:boolean read FNoInherit write FNoInherit;
    property ConstraintType:TConstraintType read FConstraintType write FConstraintType;
    property ConstraintName:string read FConstraintName write FConstraintName;
    property ConstraintExpression:string read FConstraintExpression write FConstraintExpression;
    property ForeignKeyRuleOnUpdate:TForeignKeyRule read FForeignKeyRuleOnUpdate write FForeignKeyRuleOnUpdate;
    property ForeignKeyRuleOnDelete:TForeignKeyRule read FForeignKeyRuleOnDelete write FForeignKeyRuleOnDelete;
    property ForeignTable:string read FForeignTable write FForeignTable;
    property Description:string read FDescription write FDescription;
    property OnConflict:TOnConflictEvent read FOnConflict write FOnConflict;
    property Params:TSQLFields read FParams;
  end;

  { TSQLConstraints }

  TSQLConstraints = class
  private
    FList:TObjectList;
    function GetConstraint(AIndex: integer): TSQLConstraintItem;
    function GetCount: integer;
  public
    constructor Create;
    destructor Destroy;override;
    function GetEnumerator: TSQLConstraintsEnumerator;
    function Add(AConstraintType:TConstraintType):TSQLConstraintItem;overload;
    function Add(AConstraintType:TConstraintType;AConstraintName:string):TSQLConstraintItem;overload;
    function Find(AConstraintType:TConstraintType; AutoCreate:Boolean = true):TSQLConstraintItem;
    function FindConstraint(AConstraintName:string):TSQLConstraintItem;
    procedure Clear;
    procedure CopyFrom(ASource:TSQLConstraints);
    property Constraint[AIndex:integer]:TSQLConstraintItem read GetConstraint; default;
    property Count:integer read GetCount;
  end;


  { TSQLConstraintsEnumerator }

  TSQLConstraintsEnumerator = class
  private
    FList: TSQLConstraints;
    FPosition: Integer;
  public
    constructor Create(AList: TSQLConstraints);
    function GetCurrent: TSQLConstraintItem;
    function MoveNext: Boolean;
    property Current: TSQLConstraintItem read GetCurrent;
  end;

  { TAlterTableOperator }

  TAlterTableOperator = class
  private
    FAlterAction: TAlterTableAction;
    FConstraints: TSQLConstraints;
    FDBMSTypeName: string;
    FDropRule: TDropRule;
    FField: TSQLParserField;
    FInitialValue: string;
    FName: string;
    FOldField: TSQLParserField;
    FOldName: string;
    FOptions: TSQLObjectOptions;
    FParams: TSQLFields;
    FParamValue: string;
    FPosition: integer;
  public
    constructor Create;
    destructor Destroy;override;
    procedure Assign(Source: TAlterTableOperator);
    property AlterAction:TAlterTableAction read FAlterAction write FAlterAction;
    property Field:TSQLParserField read FField;
    property OldField:TSQLParserField read FOldField;
    property Constraints:TSQLConstraints read FConstraints;
    property OldName:string read FOldName write FOldName;
    property Name:string read FName write FName;
    property Params:TSQLFields read FParams;
    property InitialValue:string read FInitialValue write FInitialValue;
    property DBMSTypeName:string read FDBMSTypeName write FDBMSTypeName;
    property ParamValue:string read FParamValue write FParamValue;
    property DropRule:TDropRule read FDropRule write FDropRule;
    property Options:TSQLObjectOptions read FOptions write FOptions;
    property Position:integer read FPosition write FPosition;
  end;


  { TAlterTableOperators }

  TAlterTableOperators = class
  private
    FList:TObjectList;
    function GetCount: integer;
    function GetItems(Index: integer): TAlterTableOperator;
  public
    constructor Create;
    destructor Destroy;override;
    function GetEnumerator: TAlterTableOperatorsEnumerator;
    procedure Clear;
    procedure Assign(ASource:TAlterTableOperators);
    function AddItem(AlterAction:TAlterTableAction):TAlterTableOperator;
    function AddItem(AlterAction:TAlterTableAction; AParamValue:string):TAlterTableOperator; overload;

    property Count:integer read GetCount;
    property Items[Index:integer]:TAlterTableOperator read GetItems;default;
  end;

  { TAlterTableOperatorsEnumerator }

  TAlterTableOperatorsEnumerator = class
  private
    FList: TAlterTableOperators;
    FPosition: Integer;
  public
    constructor Create(AList: TAlterTableOperators);
    function GetCurrent: TAlterTableOperator;
    function MoveNext: Boolean;
    property Current: TAlterTableOperator read GetCurrent;
  end;

  { TAlterDomainOperator }

  TAlterDomainOperator = class
  private
    FAlterAction: TAlterDomainAction;
    FDropRule: TDropRule;
    FIfExists: boolean;
    FParams: TSQLFields;
    FParamValue: string;
  public
    constructor Create(AAlterAction:TAlterDomainAction);
    destructor Destroy;override;
    procedure Clear;
    procedure Assign(ASource:TAlterDomainOperator); virtual;
  published
    property AlterAction:TAlterDomainAction read FAlterAction write FAlterAction;
    property Params:TSQLFields read FParams;
    property ParamValue:string read FParamValue write FParamValue;
    property IfExists:boolean read FIfExists write FIfExists;
    property DropRule:TDropRule read FDropRule write FDropRule;
  end;

  { TAlterDomainOperators }

  TAlterDomainOperators = class
  private
    FList:TObjectList;
    function GetCount: integer;
    function GetItems(Index: integer): TAlterDomainOperator;
  public
    constructor Create;
    destructor Destroy;override;
    procedure Assign(ASource:TAlterDomainOperators);
    function GetEnumerator: TAlterDomainOperatorsEnumerator;
    procedure Clear;
    function AddItem(AlterAction:TAlterDomainAction):TAlterDomainOperator;
    function AddItem(AlterAction:TAlterDomainAction; AParamValue:string):TAlterDomainOperator; overload;

    property Count:integer read GetCount;
    property Items[Index:integer]:TAlterDomainOperator read GetItems;default;
  end;

  { TAlterDomainOperatorsEnumerator }

  TAlterDomainOperatorsEnumerator = class
  private
    FList: TAlterDomainOperators;
    FPosition: Integer;
  public
    constructor Create(AList: TAlterDomainOperators);
    function GetCurrent: TAlterDomainOperator;
    function MoveNext: Boolean;
    property Current: TAlterDomainOperator read GetCurrent;
  end;

const
  AlterTableActionStr : array [TAlterTableAction] of string = (
    'ataNone',
    'ataAddColumn',
    'ataAlterColumnConstraint',
    'ataDropColumn',
    'ataDropConstraint',
    'ataDropIndex',
    'ataRenameTable',
    'ataSetSchema',
    'ataAlterCol ',
    'ataAlterColumnSetDataType',
    'ataAlterColumnSetDefaultExp',
    'ataAlterColumnDropDefault',
    'ataAlterColumnSetNotNull',
    'ataAlterColumnDropNotNull',
    'ataAlterColumnSetStatistics',
    'ataAlterColumnSet',
    'ataAlterColumnReset',
    'ataAlterColumnSetStorage',
    'ataAlterColumnPosition',
    'ataRenameColumn',
    'ataAlterColumnDescription',
    'ataAddTableConstraint',
    'ataAddTableConstraintUsingIndex',
    'ataValidateConstraint',
    'ataDisableTrigger',
    'ataEnableTrigger',
    'ataEnableReplica',
    'ataEnablAalways',
    'ataDisableRule',
    'ataEnableRule',
    'ataEnableReplicaRule',
    'ataEnableAlwaysRule',
    'ataCluster',
    'ataReset',
    'ataInherit',
    'ataNoInherit',
    'ataOfTypeName',
    'ataNotOf',
    'ataOwnerTo',
    'ataSetTablespace',
    'ataAddIndex',
    'ataSetParams',
    'ataReSetParams'
    );

function IndexSortOrderStr(AValue:TIndexSortOrder):string;
function StrToIndexSortOrder(AValue:string):TIndexSortOrder;
function IndexNullPosStr(AValue:TIndexNullPos):string;
function StrToIndexNullPos(AValue:string):TIndexNullPos;
implementation
uses sqlParserConsts, fbmStrConstUnit, strutils, LazUTF8;

function IndexSortOrderStr(AValue: TIndexSortOrder): string;
begin
  case AValue of
    indAscending:Result:=sAscending;
    indDescending:Result:=sDescending;
  else
    Result:='';
  end;
  //TIndexSortOrder = (indDefault, indAscending, indDescending);
end;

function StrToIndexSortOrder(AValue: string): TIndexSortOrder;
begin
  AValue:=UTF8UpperCase(AValue);
  if AValue = UTF8UpperCase(sAscending) then
    Result:=indAscending
  else
  if AValue = UTF8UpperCase(sDescending) then
    Result:=indDescending
  else
    Result:=indDefault;
end;

function IndexNullPosStr(AValue: TIndexNullPos): string;
begin
  case AValue of
    inpFirst:Result:=sNullsFirst;
    inpLast:Result:=sNullsLast;
  else
    Result:='';
  end;
  // TIndexNullPos   = (inpDefault, inpFirst, inpLast);   //Положение null-значений (первые/последние)
end;

function StrToIndexNullPos(AValue: string): TIndexNullPos;
begin
  AValue:=UTF8UpperCase(AValue);
  if AValue = UTF8UpperCase(sNullsFirst) then
    Result:=inpFirst
  else
  if AValue = UTF8UpperCase(sNullsLast) then
    Result:=inpLast
  else
    Result:=inpDefault;
end;

{ TIndexOptions }

procedure TIndexOptions.Assign(ASource: TIndexOptions);
begin
  if not Assigned(ASource) then Exit;
  FIndexNullPos:=ASource.FIndexNullPos;
  FSortOrder:=ASource.FSortOrder;
end;

procedure TIndexOptions.Clear;
begin
  FIndexNullPos:=inpDefault;
  FSortOrder:=indDefault;
end;

{ TSQLParserFieldArraysEnumerator }

constructor TSQLParserFieldArraysEnumerator.Create(AList: TSQLParserFieldArrays
  );
begin
  FList := AList;
  FPosition := -1;
end;

function TSQLParserFieldArraysEnumerator.GetCurrent: TSQLParserFieldArray;
begin
  Result := FList[FPosition];
end;

function TSQLParserFieldArraysEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TSQLParserFieldArrays }

function TSQLParserFieldArrays.GetAsString: string;
var
  F: TSQLParserFieldArray;
begin
  Result:='';
  if ArrayFormat = fafPostgreSQL then
  begin
    for F in Self do
      Result:=Result + F.AsString ;
  end
  else
  begin
    Result:='';
    for F in Self do
    begin
      if Result<>'' then Result:=Result + ', ';
      Result:=Result + IntToStr(F.Dimension);
      if F.DimensionEnd > 0 then
        Result:=Result + ':' + IntToStr(F.DimensionEnd);
    end;
    Result:='[' + Result + ']';
  end;
end;

function TSQLParserFieldArrays.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TSQLParserFieldArrays.GetFields(AIndex: integer): TSQLParserFieldArray;
begin
  Result:=TSQLParserFieldArray(FList[AIndex]);
end;

constructor TSQLParserFieldArrays.Create;
begin
  inherited Create;
  FList:=TFPList.Create;
end;

destructor TSQLParserFieldArrays.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TSQLParserFieldArrays.Clear;
var
  i: Integer;
begin
  for i:=0 to FList.Count-1 do
    TSQLParserFieldArray(FList[i]).Free;
  FList.Clear;
end;

procedure TSQLParserFieldArrays.Assign(ASource: TSQLParserFieldArrays);
var
  F, F1: TSQLParserFieldArray;
begin
  if not Assigned(ASource) then Exit;
  for F in ASource do
  begin
    F1:=Add(F.Dimension);
    F1.Assign(F);
  end;
  FArrayFormat:=ASource.FArrayFormat;
end;

function TSQLParserFieldArrays.Add(ADimension: integer): TSQLParserFieldArray;
begin
  Result:=TSQLParserFieldArray.Create;
  FList.Add(Result);
  Result.Dimension:=ADimension;
end;

function TSQLParserFieldArrays.GetEnumerator: TSQLParserFieldArraysEnumerator;
begin
  Result:=TSQLParserFieldArraysEnumerator.Create(Self);
end;

{ TSQLParserFieldArray }

procedure TSQLParserFieldArray.Assign(ASource: TSQLParserFieldArray);
begin
  if not Assigned(ASource) then Exit;
  FDimension:=ASource.FDimension;
  FDimensionEnd:=ASource.FDimensionEnd;
end;

function TSQLParserFieldArray.AsString: string;
begin
  if FDimension > 0 then
    Result:='['+IntToStr(FDimension)+']'
  else
    Result:='[]';
end;

{ TAlterDomainOperator }

constructor TAlterDomainOperator.Create(AAlterAction: TAlterDomainAction);
begin
  inherited Create;
  FParams:=TSQLFields.Create;
  FAlterAction:=AAlterAction;
end;

destructor TAlterDomainOperator.Destroy;
begin
  Clear;
  FreeAndNil(FParams);
  inherited Destroy;
end;

procedure TAlterDomainOperator.Clear;
begin
  FParams.Clear;
end;

procedure TAlterDomainOperator.Assign(ASource: TAlterDomainOperator);
begin
  if not Assigned(ASource) then Exit;
  AlterAction:=ASource.AlterAction;
  ParamValue:=ASource.ParamValue;
  FParams.Assign(ASource.Params);
  IfExists:=ASource.IfExists;
  DropRule:=ASource.DropRule;
end;

{ TAlterDomainOperators }

function TAlterDomainOperators.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TAlterDomainOperators.GetItems(Index: integer): TAlterDomainOperator;
begin
  Result:=TAlterDomainOperator(FList[Index]);
end;

constructor TAlterDomainOperators.Create;
begin
  inherited Create;
  FList:=TObjectList.Create;
end;

destructor TAlterDomainOperators.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TAlterDomainOperators.Assign(ASource: TAlterDomainOperators);
var
  R, R1: TAlterDomainOperator;
begin
  if not Assigned(ASource) then Exit;
  for R in ASource do
  begin
    R1:=AddItem(R.AlterAction);
    R1.Assign(R);
  end;
end;

function TAlterDomainOperators.GetEnumerator: TAlterDomainOperatorsEnumerator;
begin
  Result:=TAlterDomainOperatorsEnumerator.Create(Self);
end;

procedure TAlterDomainOperators.Clear;
begin
  FList.Clear;
end;

function TAlterDomainOperators.AddItem(AlterAction: TAlterDomainAction
  ): TAlterDomainOperator;
begin
  Result:=TAlterDomainOperator.Create(AlterAction);
  FList.Add(Result);
end;

function TAlterDomainOperators.AddItem(AlterAction: TAlterDomainAction;
  AParamValue: string): TAlterDomainOperator;
begin
  Result:=AddItem(AlterAction);
  Result.ParamValue:=AParamValue;
end;

{ TAlterDomainOperatorsEnumerator }

constructor TAlterDomainOperatorsEnumerator.Create(AList: TAlterDomainOperators
  );
begin
  FList := AList;
  FPosition := -1;
end;

function TAlterDomainOperatorsEnumerator.GetCurrent: TAlterDomainOperator;
begin
  Result := FList[FPosition];
end;

function TAlterDomainOperatorsEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TTableItem }

function TTableItem.GetFullName: string;
begin
  if FSchemaName<>'' then
    Result:=FSchemaName + '.'+FName
  else
    Result:=FName;
end;

procedure TTableItem.SetName(AValue: string);
begin
  if FName = AValue then exit;
  if Pos('.', AValue) > 0 then
    FSchemaName:=Copy2SymbDel(AValue, '.');
  FName:=AValue;
end;

constructor TTableItem.Create;
begin
  inherited Create;
  FFields:=TSQLFields.Create;
  FTableType:=stitTable;
end;

destructor TTableItem.Destroy;
begin
  FreeAndNil(FFields);
  inherited Destroy;
end;

procedure TTableItem.Assign(ASource: TTableItem);
begin
  if not Assigned(ASource) then Exit;
  SchemaName:=ASource.SchemaName;
  FName:=ASource.FName;
  TableAlias:=ASource.TableAlias;
  JoinExpression:=ASource.JoinExpression;
  JoinType:=ASource.JoinType;
  JoinOptions:=ASource.JoinOptions;
  TableType:=ASource.TableType;
  TableExpression:=ASource.TableExpression;
  ObjectKind:=ASource.ObjectKind;
  Fields.Assign(ASource.Fields);
end;

{ TSQLTablesEnumerator }

constructor TSQLTablesEnumerator.Create(AList: TSQLTables);
begin
  FList := AList;
  FPosition := -1;
end;

function TSQLTablesEnumerator.GetCurrent: TTableItem;
begin
  Result := FList[FPosition];
end;

function TSQLTablesEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TSQLTables }

function TSQLTables.GetItem(AIndex: integer): TTableItem;
begin
  Result:=TTableItem(FList[AIndex]);
end;

function TSQLTables.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TSQLTables.GetAsString: string;
var
  T: TTableItem;
begin
  Result:='';
  for T in Self do
    Result:=Result +  T.FullName + ', ';
  Result:=Copy(Result, 1, Length(Result)-2);
end;

constructor TSQLTables.Create;
begin
  inherited Create;
  FList:=TFPList.Create;
end;

destructor TSQLTables.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

function TSQLTables.Add(ACaption: string): TTableItem;
begin
  Result:=Add(ACaption, okNone);
end;

function TSQLTables.Add(ACaption: string; AObjectKind: TDBObjectKind): TTableItem;
begin
  Result:=TTableItem.Create;
  Result.Name:=ACaption;
  Result.ObjectKind:=AObjectKind;
  FList.Add(Result);
end;

procedure TSQLTables.Clear;
var
  P: Pointer;
begin
  for P in FList do
    TTableItem(P).Free;
  FList.Clear;
end;

procedure TSQLTables.Assign(ASource: TSQLTables);
var
  T, T1: TTableItem;
begin
  if not Assigned(ASource) then Exit;

  for T in ASource do
  begin
    T1:=Add(T.Name);
    T1.Assign(T);
  end;
end;

function TSQLTables.GetEnumerator: TSQLTablesEnumerator;
begin
  Result:=TSQLTablesEnumerator.Create(Self);
end;

{ TSQLConstraintItem }

constructor TSQLConstraintItem.Create;
begin
  inherited Create;
  FForeignFields:=TSQLFields.Create;
  FConstraintFields:=TSQLFields.Create;
  FParams:=TSQLFields.Create;
end;

destructor TSQLConstraintItem.Destroy;
begin
  FForeignFields.Free;
  FConstraintFields.Free;
  FParams.Free;
  inherited Destroy;
end;

procedure TSQLConstraintItem.Assign(ASource: TSQLConstraintItem);
begin
  if not Assigned(ASource) then Exit;
  ForeignFields.Assign(ASource.ForeignFields);
  ConstraintFields.Assign(ASource.ConstraintFields);

  IndexSortOrder:=ASource.IndexSortOrder;
  IndexName:=ASource.IndexName;
  IndexType:=ASource.IndexType;
  Match:=ASource.Match;
  NoInherit:=ASource.NoInherit;
  ConstraintType:=ASource.ConstraintType;
  ConstraintName:=ASource.ConstraintName;
  ConstraintExpression:=ASource.ConstraintExpression;
  ForeignKeyRuleOnUpdate:=ASource.ForeignKeyRuleOnUpdate;
  ForeignKeyRuleOnDelete:=ASource.ForeignKeyRuleOnDelete;
  ForeignTable:=ASource.ForeignTable;
  Description:=ASource.Description;
  OnConflict:=ASource.OnConflict;
  Params.Assign(ASource.Params);
end;

{ TSQLConstraintsEnumerator }

constructor TSQLConstraintsEnumerator.Create(AList: TSQLConstraints);
begin
  FList := AList;
  FPosition := -1;
end;

function TSQLConstraintsEnumerator.GetCurrent: TSQLConstraintItem;
begin
  Result := FList[FPosition];
end;

function TSQLConstraintsEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TSQLConstraints }

function TSQLConstraints.GetConstraint(AIndex: integer): TSQLConstraintItem;
begin
  Result:=TSQLConstraintItem(FList[AIndex]);
end;

function TSQLConstraints.GetCount: integer;
begin
  Result:=FList.Count;
end;

constructor TSQLConstraints.Create;
begin
  inherited Create;
  FList:=TObjectList.Create;
end;

destructor TSQLConstraints.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TSQLConstraints.GetEnumerator: TSQLConstraintsEnumerator;
begin
  Result := TSQLConstraintsEnumerator.Create(Self);
end;

function TSQLConstraints.Add(AConstraintType: TConstraintType
  ): TSQLConstraintItem;
begin
  Result:=TSQLConstraintItem.Create;
  FList.Add(Result);
  Result.ConstraintType:=AConstraintType;
end;

function TSQLConstraints.Add(AConstraintType: TConstraintType;
  AConstraintName: string): TSQLConstraintItem;
begin
  Result:=Add(AConstraintType);
  Result.ConstraintName:=AConstraintName;
end;

function TSQLConstraints.Find(AConstraintType: TConstraintType; AutoCreate:Boolean = true): TSQLConstraintItem;
var
  C: TSQLConstraintItem;
begin
  Result:=nil;
  for C in Self do
    if C.ConstraintType = AConstraintType then
    begin
      Result:=C;
      exit;
    end;
  if AutoCreate then
    Result:=Add(AConstraintType);
end;

function TSQLConstraints.FindConstraint(AConstraintName: string
  ): TSQLConstraintItem;
var
  C: TSQLConstraintItem;
begin
  AConstraintName:=UpperCase(AConstraintName);
  Result:=nil;
  for C in Self do
    if UpperCase(C.ConstraintName) = AConstraintName then
    begin
      Result:=C;
      exit;
    end;
end;

procedure TSQLConstraints.Clear;
begin
  FList.Clear;
end;

procedure TSQLConstraints.CopyFrom(ASource: TSQLConstraints);
var
  C, C1: TSQLConstraintItem;
begin
  if not Assigned(ASource) then Exit;
  for C in ASource do
  begin
    C1:=Add(C.ConstraintType);
    C1.Assign(C);
  end;
end;

{
function TSQLConstraints.FindByFieldName(AFieldName: string
  ): TSQLConstraintItem;
var
  i: Integer;
begin
  Result:=nil;
  for i:=0 to FList.Count-1 do
  begin
    if UpperCase(AFieldName) = UpperCase(TSQLConstraintItem(FList[i]).ConstraintExpression) then
    begin
      Result:=TSQLConstraintItem(FList[i]);
      exit;
    end;
  end;
end;
}
{ TAlterTableOperatorsEnumerator }

constructor TAlterTableOperatorsEnumerator.Create(AList: TAlterTableOperators);
begin
  FList := AList;
  FPosition := -1;
end;

function TAlterTableOperatorsEnumerator.GetCurrent: TAlterTableOperator;
begin
  Result := FList[FPosition];
end;

function TAlterTableOperatorsEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TSQLConstraints }

function TAlterTableOperators.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TAlterTableOperators.GetItems(Index: integer): TAlterTableOperator;
begin
  Result:=TAlterTableOperator(FList[Index]);
end;

constructor TAlterTableOperators.Create;
begin
  inherited Create;
  FList:=TObjectList.Create;
end;

destructor TAlterTableOperators.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

function TAlterTableOperators.GetEnumerator: TAlterTableOperatorsEnumerator;
begin
  Result := TAlterTableOperatorsEnumerator.Create(Self);
end;

procedure TAlterTableOperators.Clear;
begin
  FList.Clear;
end;

procedure TAlterTableOperators.Assign(ASource: TAlterTableOperators);
var
  R, R1: TAlterTableOperator;
begin
  if not Assigned(ASource) then Exit;

  for R in ASource do
  begin
    R1:=AddItem(R.AlterAction);
    R1.Assign(R);
  end;
end;

function TAlterTableOperators.AddItem(AlterAction: TAlterTableAction
  ): TAlterTableOperator;
begin
  Result:=AddItem(AlterAction, '');
end;

function TAlterTableOperators.AddItem(AlterAction: TAlterTableAction;
  AParamValue: string): TAlterTableOperator;
begin
  Result:=TAlterTableOperator.Create;
  FList.Add(Result);
  Result.AlterAction:=AlterAction;
  Result.ParamValue:=AParamValue;
end;

{ TAlterTableOperator }

constructor TAlterTableOperator.Create;
begin
  inherited Create;
  FField:=TSQLParserField.Create;
  FOldField:=TSQLParserField.Create;
  FConstraints:=TSQLConstraints.Create;
  FParams:=TSQLFields.Create;
end;

destructor TAlterTableOperator.Destroy;
begin
  FreeAndNil(FConstraints);
  FreeAndNil(FField);
  FreeAndNil(FOldField);
  FreeAndNil(FParams);
  inherited Destroy;
end;

procedure TAlterTableOperator.Assign(Source: TAlterTableOperator);
begin
  if Source is TAlterTableOperator then
  begin
    AlterAction:=TAlterTableOperator(Source).AlterAction;
    DBMSTypeName:=TAlterTableOperator(Source).DBMSTypeName;
    DropRule:=TAlterTableOperator(Source).DropRule;
    InitialValue:=TAlterTableOperator(Source).InitialValue;
    Name:=TAlterTableOperator(Source).Name;
    OldName:=TAlterTableOperator(Source).OldName;
    Options:=TAlterTableOperator(Source).Options;
    ParamValue:=TAlterTableOperator(Source).ParamValue;
    Position:=TAlterTableOperator(Source).Position;

    Field.Assign(TAlterTableOperator(Source).Field);
    OldField.Assign(TAlterTableOperator(Source).OldField);
    Params.Assign(TAlterTableOperator(Source).Params);
    Constraints.CopyFrom(TAlterTableOperator(Source).Constraints);
  end;
end;

{ TSQLParserField }

function TSQLParserField.GetPrimaryKey: boolean;
begin
  Result:=fpPrimaryKey in FParams;
end;

function TSQLParserField.GetIsLocal: boolean;
begin
  Result:=fpLocal in FParams;
end;

function TSQLParserField.GetNotNull: boolean;
begin
  Result:=fpNotNull in FParams;
end;

procedure TSQLParserField.SetIsLocal(AValue: boolean);
begin
  if AValue then
    FParams:=FParams + [fpLocal]
  else
    FParams:=FParams - [fpLocal];
end;

procedure TSQLParserField.SetNotNull(AValue: boolean);
begin
  if AValue then
    FParams:=FParams + [fpNotNull]
  else
    FParams:=FParams - [fpNotNull];
end;

procedure TSQLParserField.SetPrimaryKey(AValue: boolean);
begin
  if AValue then
    FParams:=FParams + [fpPrimaryKey]
  else
    FParams:=FParams - [fpPrimaryKey];
end;

constructor TSQLParserField.Create;
begin
  inherited Create;
  FArrayDimension:=TSQLParserFieldArrays.Create;
  FIndexOptions:=TIndexOptions.Create;
  FParams:=[fpLocal];
end;

destructor TSQLParserField.Destroy;
begin
  FArrayDimension.Clear;
  FreeAndNil(FIndexOptions);
  FreeAndNil(FArrayDimension);
  inherited Destroy;
end;

function TSQLParserField.FullTypeName: string;
begin
  Result:=TypeName;
  if TypeLen > 0 then
  begin
    Result:=Result + '(' + IntToStr(TypeLen);
    if TypePrec > 0 then
      Result:=Result + ', ' + IntToStr(TypePrec);
    Result:=Result + ')';
  end;
end;

procedure TSQLParserField.Assign(AItem: TSQLParserField);
begin
  if not Assigned(AItem) then Exit;
  Caption:=AItem.Caption;
  RealName:=AItem.RealName;
  TableName:=AItem.TableName;
  Description:=AItem.Description;
  DefaultValue:=AItem.DefaultValue;
  InReturn:=AItem.InReturn;
  TypeName:=AItem.TypeName;
  TypeLen:=AItem.TypeLen;
  TypePrec:=AItem.TypePrec;
  TypeOf:=AItem.TypeOf;
  NotNullConflictRule:=AItem.NotNullConflictRule;
  CheckExpr:=AItem.CheckExpr;
  Collate:=AItem.Collate;
  CharSetName:=AItem.CharSetName;
  FComputedSource:=AItem.FComputedSource;
  //FTypeArrayDim:=AItem.FTypeArrayDim;
  FParams:=AItem.FParams;
  FFieldFormat:=AItem.FFieldFormat;
  FFieldStorage:=AItem.FFieldStorage;
  FAutoIncType:=AItem.FAutoIncType;
  FConstraintName:=AItem.FConstraintName;
  FArrayDimension.Assign(AItem.FArrayDimension);
  FIndexOptions.Assign(AItem.IndexOptions);
end;

procedure TSQLParserField.Clear;
begin
  FArrayDimension.Clear;
  FIndexOptions.Clear;
  Caption:='';
  RealName:='';
  TableName:='';
  Description:='';
  DefaultValue:='';
  InReturn:=spvtLocal;
  TypeName:='';
  TypeLen:=0;
  TypePrec:=0;
  TypeOf:=false;
  NotNullConflictRule:=ceNone;
  CheckExpr:='';
  Collate:='';
  CharSetName:='';
  FComputedSource:='';
  //FTypeArrayDim:=AItem.FTypeArrayDim;
  FParams:=[];
  FFieldFormat:=ffDefault;
  FFieldStorage:=fsDefault;
  FAutoIncType:=faioNone;
  FConstraintName:='';
end;

{ TSQLObjectAbstract }

function TSQLObjectAbstract.GetSQLText: TStringList;
begin
  if FSQLText.Count = 0 then
    DoMakeSQL;
  Result:=FSQLText;
end;

procedure TSQLObjectAbstract.DoMakeSQL;
var
  i: Integer;
  C: TSQLObjectAbstract;
  S: String;
begin
  if Assigned(FChildList) then
    for i:=0 to FChildList.Count-1 do
    begin
      C:=TSQLObjectAbstract(FChildList[i]);
      if C.FGenBeforeMainObj then
      begin
        if C.FSQLText.Count = 0 then
          C.DoMakeSQL;
        for S in C.FSQLText do
          FSQLText.Add(S);
      end;
    end;

  MakeSQL;

  if Assigned(FChildList) then
    for i:=0 to FChildList.Count-1 do
    begin
      C:=TSQLObjectAbstract(FChildList[i]);
      if not C.FGenBeforeMainObj then
      begin
        if C.FSQLText.Count = 0 then
          C.DoMakeSQL;
        for S in C.FSQLText do
          FSQLText.Add(S);
      end;
    end;
end;

procedure TSQLObjectAbstract.SetName(AValue: string);
begin
  if FName=AValue then Exit;
  FName:=AValue;
end;

function TSQLObjectAbstract.GetFullName: string;
begin
  Result:=Name;
end;

procedure TSQLObjectAbstract.ClearChildList;
var
  i: Integer;
begin
  for i:=0 to FChildList.Count-1 do
    TSQLObjectAbstract(FChildList[i]).Free;
  FChildList.Clear;
end;

procedure TSQLObjectAbstract.AddChild(AChild: TSQLObjectAbstract);
begin
  if not Assigned(FChildList) then
    FChildList:=TFPList.Create;
  FChildList.Add(AChild);
end;

procedure TSQLObjectAbstract.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource = nil then Exit;
  raise Exception.CreateFmt('Can cot assign %s to %s.', [ASource.ClassName, ClassName]);
end;

procedure TSQLObjectAbstract.MakeSQL;
begin
  //
end;

procedure TSQLObjectAbstract.AddSQLCommand(ASQL: string; AddSeparator: boolean = true);
begin
  ASQL:=TrimRight(ASQL);
  if (ASQL<>'') then
  begin
    if AddSeparator and (ASQL[Length(ASQL)] <> ';') then
      ASQL:=ASQL + ';';
    FSQLText.Add(ASQL);
  end;
end;

procedure TSQLObjectAbstract.AddSQLCommandEx(ASQL: string;
  AParms: array of const);
begin
  AddSQLCommand(Format(ASQL, AParms));
end;

constructor TSQLObjectAbstract.Create;
begin
  FSQLText:=TStringList.Create;
  FGenBeforeMainObj:=false;
end;

destructor TSQLObjectAbstract.Destroy;
begin
  FreeAndNil(FSQLText);

  if Assigned(FChildList) then
  begin
    ClearChildList;
    FreeAndNil(FChildList);
  end;

  inherited Destroy;
end;

procedure TSQLObjectAbstract.Clear;
begin
  FSQLText.Clear;
end;

function TSQLObjectAbstract.AsSQL: string;
begin
  if FSQLText.Count = 0 then
    DoMakeSQL;
  Result:=FSQLText.Text;
end;
(*
{ TGrantObjects }

function TGrantObjects.GetItems(AIndex: integer): TGrantObject;
begin
  Result:=TGrantObject(FList[AIndex]);
end;

function TGrantObjects.GetCount: integer;
begin
  Result:=FList.Count;
end;

constructor TGrantObjects.Create;
begin
  inherited Create;
  FList:=TFPList.Create;
end;

destructor TGrantObjects.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TGrantObjects.Clear;
var
  P: Pointer;
begin
  for P in FList do
    TGrantObject(P).Free;
end;

function TGrantObjects.Add(AName: string; AObjectType: TDBObjectKind
  ): TGrantObject;
begin
  Result:=TGrantObject.Create;
  Result.Name:=AName;
  Result.ObjectType:=AObjectType;
  FList.Add(Result);
end;

function TGrantObjects.GetEnumerator: TGrantObjectsEnumerator;
begin
  Result:=TGrantObjectsEnumerator.Create(Self);
end;
*)
{ TSQLFieldsEnumerator }

constructor TSQLFieldsEnumerator.Create(AList: TSQLFields);
begin
  FList := AList;
  FPosition := -1;
end;

function TSQLFieldsEnumerator.GetCurrent: TSQLParserField;
begin
  Result := FList[FPosition];
end;

function TSQLFieldsEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TSQLFields }

function TSQLFields.GetFields(AIndex: integer): TSQLParserField;
begin
  Result:=TSQLParserField(FList[AIndex]);
end;

procedure TSQLFields.SetAsString(AValue: string);
var
  C: SizeInt;
begin
  Clear;
  if Pos(',', AValue) > 0 then
  begin
    C:=Pos(',', AValue);
    while C>0 do
    begin
      AddParam(Copy2SymbDel(AValue, ','));
      C:=Pos(',', AValue);
    end;
  end;
  if AValue <> '' then
    AddParam(AValue);
end;

constructor TSQLFields.Create;
begin
  inherited Create;
  FList:=TObjectList.Create;
end;

destructor TSQLFields.Destroy;
begin
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TSQLFields.Clear;
begin
  FList.Clear;
end;

procedure TSQLFields.Assign(ASource: TSQLFields);
begin
  CopyFrom(ASource, []);
end;

function TSQLFields.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TSQLFields.GetAsString: string;
var
  F: TSQLParserField;
begin
  Result:='';
  for F in Self do
    Result:=Result +  F.Caption + ', ';
  Result:=Copy(Result, 1, Length(Result)-2);
end;

function TSQLFields.GetAsText: string;
var
  F: TSQLParserField;
begin
  Result:='';
  for F in Self do
    Result:=Result + F.Caption + LineEnding;
end;

function TSQLFields.GetAsList: string;
var
  F: TSQLParserField;
begin
  Result:='';
  for F in Self do
    Result:=Result + '  ' + F.Caption + ','+LineEnding;
  Result:=Copy(Result, 1, Length(Result)-Length(','+LineEnding));
end;

function TSQLFields.AddParam(AName: string): TSQLParserField;
begin
  Result:=AddParamEx(AName, AName);
end;

function TSQLFields.AddParam(AItem: TSQLParserField): TSQLParserField;
begin
  Result:=TSQLParserField.Create;
  FList.Add(Result);
  Result.Assign(AItem);
end;

function TSQLFields.AddParamEx(AName, AValue: string): TSQLParserField;
begin
  Result:=TSQLParserField.Create;
  FList.Add(Result);
  Result.Caption:=AName;
  Result.ParamValue:=AValue;
  Result.InReturn:=spvtLocal;
end;

function TSQLFields.AddParamWithType(AName, ATypeName: string): TSQLParserField;
begin
  Result:=AddParam(AName);
  Result.TypeName:=ATypeName;
end;

procedure TSQLFields.CopyFrom(Src: TSQLFields; AParTypes: TSPVarTypes);
var
  P: TSQLParserField;
begin
  for P in Src do
    if (AParTypes = []) or (P.InReturn in AParTypes) then
      AddParam(P)
end;

function TSQLFields.GetEnumerator: TSQLFieldsEnumerator;
begin
  Result := TSQLFieldsEnumerator.Create(Self);
end;

function TSQLFields.FindParam(AName: string): TSQLParserField;
var
  F: TSQLParserField;
begin
  Result:=nil;
  for F in Self do
    if UpperCase(AName) = UpperCase(F.Caption) then Exit(F)
end;

end.

