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

unit sqlite3_SqlParserUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, fbmSqlParserUnit, SQLEngineCommonTypesUnit, sqlObjects;

type
  //PRAGMA

  { TSQLite3SQLPRAGMA }

  TSQLite3SQLPRAGMA = class(TSQLCommandAbstractSelect)
  private
    FPragmaValue: string;
    FSchemaName: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    function GetFullName: string; override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property SchemaName:string read FSchemaName write FSchemaName;
    property PragmaValue:string read FPragmaValue write FPragmaValue;
  end;

  //Tables

  { TSQLite3SQLCreateTable }

  TSQLite3SQLCreateTable = class(TSQLCreateTable)
  private
    FTempTable: boolean;
    FCurFiled: TSQLParserField;
    FCurConstraint:TSQLConstraintItem;
    FWithoutRowID: boolean;
    procedure OnProcessComment1(Sender:TSQLParser; AComment:string);
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property TempTable : boolean read FTempTable write FTempTable;
    property WithoutRowID:boolean read FWithoutRowID write FWithoutRowID;
    property SchemaName;
  end;

  { TSQLite3SQLAlterTable }

  TSQLite3SQLAlterTable = class(TSQLAlterTable)
  private
    FCurOperator : TAlterTableOperator;
    FCurConstraint: TSQLConstraintItem;
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  public
    property SchemaName;
  end;

  { TSQLite3SQLDropTable }

  TSQLite3SQLDropTable = class(TSQLDropCommandAbstract)
  protected
    procedure InitParserTree;override;
    procedure MakeSQL;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
  end;

  { TSQLite3SQLCreateView }

  TSQLite3SQLCreateView = class(TSQLCreateView)
  private
    FSQLCommandSelect: TSQLCommandAbstractSelect;
    FTempView: boolean;
    FCurField: TSQLParserField;
    procedure OnProcessComment1(Sender:TSQLParser; AComment:string);
    procedure OnProcessComment2(Sender:TSQLParser; AComment:string);
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property TempView : boolean read FTempView write FTempView;
    property SQLCommandSelect:TSQLCommandAbstractSelect read FSQLCommandSelect;
    property SchemaName;
  end;

  { TSQLite3SQLDropView }

  TSQLite3SQLDropView = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    property SchemaName;
  end;

  { TSQLite3SQLCreateTrigger }

  TSQLite3SQLCreateTrigger = class(TSQLCreateTrigger)
  private
    FTableName: string;
    FTemp: boolean;
    FTriggerBody: string;
    FTriggerType: TTriggerTypes;
    FTriggerWhen: string;
    procedure OnProcessComment(Sender:TSQLParser; AComment:string);
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property Temp : boolean read FTemp write FTemp;
    property TableName:string read FTableName write FTableName;
    property TriggerType:TTriggerTypes read FTriggerType write FTriggerType;
    property TriggerWhen:string read FTriggerWhen write FTriggerWhen;
    property TriggerBody:string read FTriggerBody write FTriggerBody;
  end;

  { TSQLite3SQLDropTrigger }

  TSQLite3SQLDropTrigger = class(TSQLDropTrigger)
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TSQLite3SQLCreateIndex }

  TSQLite3SQLCreateIndex = class(TSQLCreateIndex)
  private
    FWhereExpression: string;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property WhereExpression:string read FWhereExpression write FWhereExpression;
    property SchemaName;
  end;

  { TSQLite3SQLDropIndex }

  TSQLite3SQLDropIndex = class(TSQLDropCommandAbstract)
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    property SchemaName;
  end;

  { TSQLite3BeginTransaction }

  TSQLite3TransactionType = (sqlitettNone, sqlitettDeferred, sqlitettImmediate, sqlitettExclusive);

  TSQLite3BeginTransaction = class(TSQLStartTransaction)
  private
    FTransactionType: TSQLite3TransactionType;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract); override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property TransactionType:TSQLite3TransactionType read FTransactionType write FTransactionType;
  end;

  { TSQLite3Commit }
  TSQLite3CommitType = (sqlitectEnd, sqlitectCommit);

  TSQLite3Commit = class(TSQLCommit)
  private
    FCommitType: TSQLite3CommitType;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property CommitType:TSQLite3CommitType read FCommitType write FCommitType;
  end;

  { TSQLite3Rollback }

  TSQLite3Rollback = class(TSQLRollback)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    //procedure Assign(ASource:TSQLObjectAbstract); override;
    //
    //property RollbackType:TAbortType read FRollbackType write FRollbackType;
    //property TransactionId:string read FTransactionId write FTransactionId;
    //property SavepointName:string read FSavepointName write FSavepointName;
  end;
implementation

uses SQLEngineInternalToolsUnit;

{
  out tag
  10 - Field name
  11 - data type
  12 - data len);
  13 - data precession
  17 - constraint name
  16 - PRIMARY KEY
  18 - INDEX ASC
  19 - INDEX DESC
  20 - AUTOINCREMENT
  21 - ON CONFLICT ROLLBACK
  22 - ON CONFLICT ABORT
  22 - ON CONFLICT FAIL
  23 - ON CONFLICT IGNORE
  24 - ON CONFLICT REPLACE
  26 - NOT NULL
  27 - UNIQUE
  28 - CHECK
  29 - COLLATE
  30 - DEFAULT VALUE
  31 - FK Table
}
procedure CreateColDef(Sender: TSQLCommandDDL; AStart:TSQLTokenRecord;
  AEnds:array of TSQLTokenRecord; AForCreate:boolean);

procedure DoFillEndTags(AParent:array of TSQLTokenRecord);
var
  E, P: TSQLTokenRecord;
begin
  if (Length(AEnds) <> 0) and (Length(AParent) <> 0) then
  begin
    for E in AEnds do
      for P in AParent do
        P.AddChildToken(E);
  end;
end;

var
  TF, TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10, TD11,
    TD12, TD13, TD14, TD15, TD16, TD17, TD18, TD19, TD20, TD21,
    TD22, TD22_1, TD23, TD24, TD25, TD26, TD27, TD28, TD29, T1,
    T2, TSymb3, TC, T, TCofA, TCofR, TCofF, TCofI, TCofRe,
    TInc, T3, T4, TC_NN, TERN, TC_NN1, TC_PK, TC_Def, TCofR1,
    TCofA1, TCofF1, TCofI1, TCofRe1, TC_UN, TCFK, TSymb4, T3_1,
    T3_2, T5, T6, T_FU, T_FD, TC_PK1, TC_CHK, TC_COLL,
    TC_COLL1, TC_CHK1, TF2, TD_MS, TD_MU, TD_MSmallInt,
    TCFK_TBL, TCFK_TBLs: TSQLTokenRecord;
begin
  with Sender do
  begin
    TF:=AddSQLTokens(stIdentificator, AStart, '', [], 10);
    TF2:=AddSQLTokens(stString, AStart, '', [], 10);

    TD1:=AddSQLTokens(stIdentificator, [TF, TF2], 'CHAR', [], 11);       //CHAR()
    TD2:=AddSQLTokens(stIdentificator, [TF, TF2], 'VARCHAR', [], 11);    //VARCHAR()
    TD3:=AddSQLTokens(stIdentificator, [TF, TF2], 'TINYTEXT', [], 11);   //TINYTEXT()
    TD4:=AddSQLTokens(stIdentificator, [TF, TF2], 'TEXT', [], 11);       //TEXT()
    TD5:=AddSQLTokens(stIdentificator, [TF, TF2], 'MEDIUMTEXT', [], 11); //MEDIUMTEXT()
    TD6:=AddSQLTokens(stIdentificator, [TF, TF2], 'LONGTEXT', [], 11);   //LONGTEXT()
    TD7:=AddSQLTokens(stIdentificator, [TF, TF2], 'NCHAR', [], 11);      //NCHAR()
    TD8:=AddSQLTokens(stIdentificator, [TF, TF2], 'NVARCHAR', [], 11);   //NVARCHAR()
    TD9:=AddSQLTokens(stIdentificator, [TF, TF2], 'CLOB', [], 11);       //CLOB()

    //Numeric Datatypes
    TD_MS:=AddSQLTokens(stIdentificator, [TF, TF2], 'SIGNED', [], 11);       //signed data
    TD_MU:=AddSQLTokens(stIdentificator, [TF, TF2], 'UNSIGNED', [], 11);       //unsigned data

    TD10:=AddSQLTokens(stIdentificator, [TF, TF2, TD_MS, TD_MU], 'TINYINT', [toOptional], 11);

    TD11:=AddSQLTokens(stIdentificator, [TF, TF2, TD_MS, TD_MU], 'SMALLINT', [toOptional], 11);
    TD12:=AddSQLTokens(stIdentificator, [TF, TF2, TD_MS, TD_MU], 'MEDIUMINT', [toOptional], 11);

    TD_MSmallInt:=AddSQLTokens(stIdentificator, [TF, TF2, TD_MS, TD_MU], 'SMALL', [], 11);       //signed data

    TD13:=AddSQLTokens(stIdentificator, [TF, TF2, TD_MS, TD_MU, TD_MSmallInt], 'INT', [], 11);
    TD14:=AddSQLTokens(stIdentificator, [TF, TF2, TD_MS, TD_MU], 'INTEGER', [toOptional], 11);
    TD15:=AddSQLTokens(stIdentificator, [TF, TF2, TD_MS, TD_MU], 'BIGINT', [toOptional], 11);
    TD16:=AddSQLTokens(stIdentificator, [TF, TF2, TD_MS, TD_MU], 'INT2', [toOptional], 11);
    TD17:=AddSQLTokens(stIdentificator, [TF, TF2, TD_MS, TD_MU], 'INT4', [toOptional], 11);
    TD18:=AddSQLTokens(stIdentificator, [TF, TF2, TD_MS, TD_MU], 'INT8', [toOptional], 11);

    TD19:=AddSQLTokens(stIdentificator, [TF, TF2], 'NUMERIC', [toOptional], 11);   //NUMERIC()
    TD20:=AddSQLTokens(stIdentificator, [TF, TF2], 'DECIMAL', [toOptional], 11);   //DECIMAL()
    TD21:=AddSQLTokens(stIdentificator, [TF, TF2], 'REAL', [toOptional], 11);
    TD22:=AddSQLTokens(stIdentificator, [TF, TF2], 'DOUBLE', [toOptional], 11);
    TD22_1:=AddSQLTokens(stIdentificator, [TD22], 'PRECISION', [toOptional], 11);
    TD23:=AddSQLTokens(stIdentificator, [TF, TF2], 'FLOAT', [toOptional], 11);
    TD24:=AddSQLTokens(stIdentificator, [TF, TF2], 'BOOLEAN', [toOptional], 11);

    //Date/Time Datatypes
    TD25:=AddSQLTokens(stIdentificator, [TF, TF2], 'DATE', [toOptional], 11);
    TD26:=AddSQLTokens(stIdentificator, [TF, TF2], 'DATETIME', [toOptional], 11);
    TD27:=AddSQLTokens(stIdentificator, [TF, TF2], 'TIMESTAMP', [toOptional], 11);
    TD28:=AddSQLTokens(stIdentificator, [TF, TF2], 'TIME', [toOptional], 11);
    //Large Object (LOB) Datatypes
    TD29:=AddSQLTokens(stIdentificator, [TF, TF2], 'BLOB', [toOptional], 11);

    T1:=AddSQLTokens(stSymbol, [TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9,
        TD10, TD11, TD12, TD13, TD14, TD15, TD16, TD17, TD18,
        TD19, TD20,
        TD_MS, TD_MU], '(', []);
      T1:=AddSQLTokens(stInteger, T1, '', [], 12);
      T2:=AddSQLTokens(stSymbol, T1, ',', []);
      T2:=AddSQLTokens(stInteger, T2, '', [], 13);
      TSymb3:=AddSQLTokens(stSymbol, T2, ')', []);
        T1.AddChildToken(TSymb3);

    DoFillEndTags(TSymb3);

    TC:=AddSQLTokens(stKeyword, [TSymb3, TF, TF2, TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10,
                                         TD11, TD12, TD13, TD14, TD15, TD16, TD17, TD18, TD19, TD20,
                                         TD21, TD22, TD22_1, TD23, TD24, TD25, TD26, TD27, TD28, TD29,
        TD_MS, TD_MU], 'CONSTRAINT', [toOptional]);
    TC:=AddSQLTokens(stIdentificator, TC, '', [], 17);

    //PRIMARY KEY - only for CREATE TABLE
    if AForCreate then
    begin
      TC_PK:=AddSQLTokens(stKeyword, [TC, TSymb3, TF, TF2, TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10,
                                     TD11, TD12, TD13, TD14, TD15, TD16, TD17, TD18, TD19, TD20,
                                     TD21, TD22, TD22_1, TD23, TD24, TD25, TD26, TD27, TD28, TD29,
        TD_MS, TD_MU], 'PRIMARY', [], 16);
      TC_PK1:=AddSQLTokens(stIdentificator, TC_PK, 'KEY', []);
        T1:=AddSQLTokens(stKeyword, TC_PK1, 'ASC', [], 18);
        T2:=AddSQLTokens(stKeyword, TC_PK1, 'DESC', [], 19);
          T:=AddSQLTokens(stKeyword, [T1, T2], 'ON', []);
          T:=AddSQLTokens(stKeyword, T, 'CONFLICT', []);
            TCofR:=AddSQLTokens(stKeyword, T, 'ROLLBACK', [], 21);
            TCofA:=AddSQLTokens(stKeyword, T, 'ABORT', [], 22);
            TCofF:=AddSQLTokens(stKeyword, T, 'FAIL', [], 23);
            TCofI:=AddSQLTokens(stKeyword, T, 'IGNORE', [], 24);
            TCofRe:=AddSQLTokens(stKeyword, T, 'REPLACE', [], 25);

        TInc:=AddSQLTokens(stKeyword, [T1, T2, TC_PK1, TCofR, TCofA, TCofF, TCofI, TCofRe] , 'AUTOINCREMENT', [], 20);

      DoFillEndTags([TF, TF2, TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10,
                     TD11, TD12, TD13, TD14, TD15, TD16, TD17, TD18, TD19, TD20,
                     TD21, TD22, TD22_1, TD23, TD24, TD25, TD26, TD27, TD28, TD29,
                     TC_PK1, TCofR, TCofA, TCofF, TCofI, TCofRe, T1, T2, TInc]);
    end;

    //NOT NULL
    TC_NN:=AddSQLTokens(stKeyword, [TC, TSymb3, TF, TF2, TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10,
                                       TD11, TD12, TD13, TD14, TD15, TD16, TD17, TD18, TD19, TD20,
                                       TD21, TD22, TD22_1, TD23, TD24, TD25, TD26, TD27, TD28, TD29,
        TD_MS, TD_MU], 'NOT', [toOptional], 26);
    TC_NN1:=AddSQLTokens(stKeyword, TC_NN, 'NULL', []);
      T:=AddSQLTokens(stKeyword, TC_NN1, 'ON', []);
      T:=AddSQLTokens(stKeyword, T, 'CONFLICT', []);
        TCofR:=AddSQLTokens(stKeyword, T, 'ROLLBACK', [], 91);
        TCofA:=AddSQLTokens(stKeyword, T, 'ABORT', [], 92);
        TCofF:=AddSQLTokens(stKeyword, T, 'FAIL', [], 93);
        TCofI:=AddSQLTokens(stKeyword, T, 'IGNORE', [], 94);
        TCofRe:=AddSQLTokens(stKeyword, T, 'REPLACE', [], 95);
    DoFillEndTags([TC_NN1, TCofR, TCofA, TCofF, TCofI, TCofRe]);

    //UNIQUE
    TC_UN:=AddSQLTokens(stKeyword, [TC, TSymb3, TF, TF2, TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10,
                                       TD11, TD12, TD13, TD14, TD15, TD16, TD17, TD18, TD19, TD20,
                                       TD21, TD22, TD22_1,  TD23, TD24, TD25, TD26, TD27, TD28, TD29,
        TCofR, TCofA, TCofF, TCofI, TCofRe, TC_NN1,
        TD_MS, TD_MU], 'UNIQUE', [toOptional], 27);
      TC_UN.AddChildToken(TC_NN);
      T:=AddSQLTokens(stKeyword, TC_UN, 'ON', []);
      T:=AddSQLTokens(stKeyword, T, 'CONFLICT', []);
        TCofR1:=AddSQLTokens(stKeyword, T, 'ROLLBACK', [], 21);
        TCofA1:=AddSQLTokens(stKeyword, T, 'ABORT', [], 22);
        TCofF1:=AddSQLTokens(stKeyword, T, 'FAIL', [], 23);
        TCofI1:=AddSQLTokens(stKeyword, T, 'IGNORE', [], 24);
        TCofRe1:=AddSQLTokens(stKeyword, T, 'REPLACE', [], 25);
    DoFillEndTags([TC_UN, TCofR1, TCofA1, TCofF1, TCofI1, TCofRe1]);

    TCofR1.AddChildToken(TC_NN);
    TCofA1.CopyChildTokens(TCofR1);
    TCofF1.CopyChildTokens(TCofR1);
    TCofI1.CopyChildTokens(TCofR1);
    TCofRe1.CopyChildTokens(TCofR1);

    //CHECK
    TC_CHK:=AddSQLTokens(stKeyword, [TC_UN, TC_NN1, TSymb3, TF, TF2, TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10,
                                       TD11, TD12, TD13, TD14, TD15, TD16, TD17, TD18, TD19, TD20,
                                       TD21, TD22, TD22_1,  TD23, TD24, TD25, TD26, TD27, TD28, TD29,
        TCofR1, TCofA1, TCofF1, TCofI1, TCofRe1,
        TD_MS, TD_MU], 'CHECK', [toOptional]);
    TC_CHK1:=AddSQLTokens(stSymbol, TC_CHK, '(', [], 28);
    DoFillEndTags([TC_CHK1]);

    //COLLATE
    TC_COLL:=AddSQLTokens(stKeyword, [TC, TC_NN1, TSymb3, TF, TF2, TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10,
                                       TD11, TD12, TD13, TD14, TD15, TD16, TD17, TD18, TD19, TD20,
                                       TD21, TD22, TD22_1, TD23, TD24, TD25, TD26, TD27, TD28, TD29,
        TD_MS, TD_MU], 'COLLATE', [toOptional ]);
    TC_COLL1:=AddSQLTokens(stIdentificator, TC_COLL, '', [], 29);
    TC_COLL1.AddChildToken([TC_UN, TC_NN1]);
    DoFillEndTags([TC_COLL1]);
    //DEFAULT
    TC_Def:=AddSQLTokens(stKeyword, [TC, TC_NN1, TSymb3, TC_COLL1, TF, TF2, TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10,
                                       TD11, TD12, TD13, TD14, TD15, TD16, TD17, TD18, TD19, TD20,
                                       TD21, TD22, TD22_1, TD23, TD24, TD25, TD26, TD27, TD28, TD29,
        TD_MS, TD_MU], 'DEFAULT', [toOptional]);

    T1:=AddSQLTokens(stInteger, TC_Def, '', [], 30);
    T2:=AddSQLTokens(stIdentificator, TC_Def, '', [], 30);
    T3:=AddSQLTokens(stString, TC_Def, '', [], 30);
    T4:=AddSQLTokens(stKeyword, TC_Def, 'NULL', [], 30);

    T1.AddChildToken(TC_NN);
    DoFillEndTags([T1]);
    T2.CopyChildTokens(T1);
    T3.CopyChildTokens(T1);
    T4.CopyChildTokens(T1);


    //{DEFAULT} NULL
    TERN:=AddSQLTokens(stKeyword, [T1, T2, T3, T4, TC_NN1, TC_COLL1,
                                     TSymb3, TF, TF2, TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10,
                                     TD11, TD12, TD13, TD14, TD15, TD16, TD17, TD18, TD19, TD20,
                                     TD21, TD22, TD22_1, TD23, TD24, TD25, TD26, TD27, TD28, TD29,
        TD_MS, TD_MU], 'NULL', [toOptional]);
    DoFillEndTags([TERN]);

    TCFK:=AddSQLTokens(stKeyword, [TC, TC_NN1, TSymb3, TC_COLL1, TC_UN, TC_CHK1,
              TF, TF2, TD1, TD2, TD3, TD4, TD5, TD6, TD7, TD8, TD9, TD10,
                                       TD11, TD12, TD13, TD14, TD15, TD16, TD17, TD18, TD19, TD20,
                                       TD21, TD22, TD22_1, TD23, TD24, TD25, TD26, TD27, TD28, TD29,
                                       T1, T2, T3, T4,
        TD_MS, TD_MU], 'REFERENCES', [toOptional]);
    TCFK_TBL:=AddSQLTokens(stIdentificator, TCFK, '', [], 31);
    TCFK_TBLs:=AddSQLTokens(stString, TCFK, '', [], 31);
    T:=AddSQLTokens(stSymbol, [TCFK_TBL, TCFK_TBLs], '(', []);
      T1:=AddSQLTokens(stIdentificator, T, '', [], 32);
      T:=AddSQLTokens(stSymbol, T1, ',', []);
      T.AddChildToken(T1);
      TSymb4:=AddSQLTokens(stSymbol, T1, ')', []);
      TSymb4.AddChildToken([TC_NN]);

    DoFillEndTags([TSymb4, TCFK_TBL, TCFK_TBLs]);

    T1:=AddSQLTokens(stKeyword, [TSymb4, TCFK_TBL, TCFK_TBLs], 'ON', []);
      T_FU:=AddSQLTokens(stKeyword, T1, 'UPDATE', []);
         T3:=AddSQLTokens(stKeyword, T_FU, 'SET', []);
           T3_1:=AddSQLTokens(stKeyword, T3, 'NULL', [], 33);
           T3_2:=AddSQLTokens(stKeyword, T3, 'DEFAULT', [], 34);
         T4:=AddSQLTokens(stKeyword, T_FU, 'CASCADE', [], 35);
         T5:=AddSQLTokens(stKeyword, T_FU, 'RESTRICT', [], 36);
         T6:=AddSQLTokens(stKeyword, T_FU, 'NO', []);
         T6:=AddSQLTokens(stIdentificator, T6, 'ACTION', [], 36);
    DoFillEndTags([T3_1, T3_2, T4, T5, T6]);
      T3_1.AddChildToken([T1, TC_NN]);
      T3_2.AddChildToken([T1, TC_NN]);
      T4.AddChildToken([T1, TC_NN]);
      T5.AddChildToken([T1, TC_NN]);
      T6.AddChildToken([T1, TC_NN]);

//    T_FD:=AddSQLTokens(stKeyword, [TSymb4, T3_1, T3_2, T4, T5, T6], 'ON', []);
      T_FD:=AddSQLTokens(stKeyword, T1, 'DELETE', []);
        T3:=AddSQLTokens(stKeyword, T_FD, 'SET', []);
          T3_1:=AddSQLTokens(stKeyword, T3, 'NULL', [], 80);
          T3_2:=AddSQLTokens(stKeyword, T3, 'DEFAULT', [], 81);
        T4:=AddSQLTokens(stKeyword, T_FD, 'CASCADE', [], 82);
        T5:=AddSQLTokens(stKeyword, T_FD, 'RESTRICT', [], 83);
        T6:=AddSQLTokens(stKeyword, T_FD, 'NO', []);
        T6:=AddSQLTokens(stIdentificator, T6, 'ACTION', [], 83);
    DoFillEndTags([T3_1, T3_2, T4, T5, T6]);
      T3_1.AddChildToken([T1, TC_NN]);
      T3_2.AddChildToken([T1, TC_NN]);
      T4.AddChildToken([T1, TC_NN]);
      T5.AddChildToken([T1, TC_NN]);
      T6.AddChildToken([T1, TC_NN]);


    if AForCreate then
    begin
      TInc.AddChildToken([TC_NN, TC_UN, TC_CHK, TC_COLL, TC_Def, TCFK, TERN]);

      TC_NN1.AddChildToken(TC_PK);
      TCofR.AddChildToken(TC_PK);
      TCofA.AddChildToken(TC_PK);
      TCofF.AddChildToken(TC_PK);
      TCofI.AddChildToken(TC_PK);
      TCofRe.AddChildToken(TC_PK);

      TC_UN.AddChildToken(TC_PK);
      TCofR1.AddChildToken(TC_PK);
      TCofA1.AddChildToken(TC_PK);
      TCofF1.AddChildToken(TC_PK);
      TCofI1.AddChildToken(TC_PK);
      TCofRe1.AddChildToken(TC_PK);

      TC_PK1.AddChildToken([TC_UN, TC_CHK, TC_COLL, TC_Def, TCFK, TERN, TC_NN]);
      TC_UN.AddChildToken(TC_PK1);
      TC_CHK1.AddChildToken(TC_PK1);
      TC_COLL1.AddChildToken(TC_PK1);
    end;
  end;
end;

{ TSQLite3Rollback }

procedure TSQLite3Rollback.InitParserTree;
begin
  inherited InitParserTree;
end;

procedure TSQLite3Rollback.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TSQLite3Rollback.MakeSQL;
var
  S: String;
begin
  S:='ROLLBACK TRANSACTION';
  AddSQLCommand(S);
end;

{ TSQLite3Commit }

procedure TSQLite3Commit.InitParserTree;
var
  FSQLTokens1, FSQLTokens2: TSQLTokenRecord;
begin
  //END TRANSACTION;
  //COMMIT TRANSACTION;
  FSQLTokens1:=AddSQLTokens(stKeyword, nil, 'END', [toFirstToken], 1, okNone);
  FSQLTokens2:=AddSQLTokens(stKeyword, nil, 'COMMIT', [toFirstToken], 2, okNone);
  AddSQLTokens(stKeyword, [FSQLTokens1, FSQLTokens2], 'TRANSACTION', [toFindWordLast]);
end;

procedure TSQLite3Commit.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FCommitType:=sqlitectEnd;
    2:FCommitType:=sqlitectCommit;
  end;
end;

procedure TSQLite3Commit.MakeSQL;
var
  S: String;
begin
  if FCommitType = sqlitectEnd then
    S:='END TRANSACTION'
  else
    S:='COMMIT TRANSACTION';
  AddSQLCommand(S);
end;

procedure TSQLite3Commit.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLite3Commit then
    FCommitType:=TSQLite3Commit(ASource).FCommitType;
  inherited Assign(ASource);
end;

{ TSQLite3BeginTransaction }

procedure TSQLite3BeginTransaction.InitParserTree;
var
  FSQLTokens, T1, T2, T3: TSQLTokenRecord;
begin
  //BEGIN TRANSACTION;
  //BEGIN DEFERRED TRANSACTION;
  //BEGIN IMMEDIATE TRANSACTION;
  //BEGIN EXCLUSIVE TRANSACTION;
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'BEGIN', [toFirstToken], 0, okNone);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'DEFERRED', [], 1);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'IMMEDIATE', [], 2);
    T3:=AddSQLTokens(stKeyword, FSQLTokens, 'EXCLUSIVE', [], 3);
   AddSQLTokens(stKeyword, [FSQLTokens, T1, T2, T3], 'TRANSACTION', [toFindWordLast]);
end;

procedure TSQLite3BeginTransaction.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:FTransactionType:=sqlitettDeferred;
    2:FTransactionType:=sqlitettImmediate;
    3:FTransactionType:=sqlitettExclusive;
  end;
end;

procedure TSQLite3BeginTransaction.MakeSQL;
var
  S: String;
begin
  //BEGIN TRANSACTION;
  //BEGIN DEFERRED TRANSACTION;
  //BEGIN IMMEDIATE TRANSACTION;
  //BEGIN EXCLUSIVE TRANSACTION;
  S:='BEGIN';
  case FTransactionType of
    sqlitettDeferred:S:=S + ' DEFERRED';
    sqlitettImmediate:S:=S + ' IMMEDIATE';
    sqlitettExclusive:S:=S + ' EXCLUSIVE';
  end;
  S:=S + ' TRANSACTION';
  AddSQLCommand(S);
end;

constructor TSQLite3BeginTransaction.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
end;

procedure TSQLite3BeginTransaction.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLite3BeginTransaction then
    FTransactionType:=TSQLite3BeginTransaction(ASource).FTransactionType;
  inherited Assign(ASource);
end;

{ TSQLite3SQLDropTable }

procedure TSQLite3SQLDropTable.InitParserTree;
var
  T, T1, FSQLTokens: TSQLTokenRecord;
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
end;

procedure TSQLite3SQLDropTable.MakeSQL;
var
  S: String;
begin
  S:='DROP TABLE ';
  if ooIfExists in Options then
    S:=S + 'IF EXISTS ';
  AddSQLCommand(S + FullName);
end;

procedure TSQLite3SQLDropTable.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
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

{ TSQLite3SQLDropView }

procedure TSQLite3SQLDropView.InitParserTree;
var
  T, T1, FSQLTokens, FTViewName: TSQLTokenRecord;
begin
  (*
  DROP VIEW [ IF EXISTS ] [schema .] name
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okView);    //DROP VIEW
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'VIEW', [toFindWordLast]);
  T1:=AddSQLTokens(stKeyword, T, 'IF', []);
  T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', [], -1);
  FTViewName:=AddSQLTokens(stIdentificator, [T, T1], '', [], 2);
    T:=AddSQLTokens(stSymbol, FTViewName, '.', [toOptional]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 3);
end;

procedure TSQLite3SQLDropView.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    2:Name:=AWord;
    3:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
  end;
end;

procedure TSQLite3SQLDropView.MakeSQL;
var
  S: String;
begin
  S:='DROP VIEW ';
  if ooIfExists in Options then
    S:=S + 'IF EXISTS ';
  S:=S + FullName;
  AddSQLCommand(S);
end;

{ TSQLite3SQLDropIndex }

procedure TSQLite3SQLDropIndex.InitParserTree;
var
  FSQLTokens, T, T1: TSQLTokenRecord;
begin
  {
  DROP INDEX [ IF EXISTS ] [ schema . ] name
  }
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okIndex);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'INDEX', [toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, T, 'IF', [], 1);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);
  T:=AddSQLTokens(stIdentificator, [T, T1], '', [], 2);
    T1:=AddSQLTokens(stSymbol, T, '.', []);
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 3);
end;

procedure TSQLite3SQLDropIndex.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:Options := Options + [ooIfExists];
    2:Name:=AWord;
    3:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
  end;
end;

procedure TSQLite3SQLDropIndex.MakeSQL;
var
  S: String;
begin
  {
  DROP INDEX [ IF EXISTS ] [ schema . ] name
  }
  S:='DROP INDEX ';
  if ooIfExists in Options then
    S:=S + 'IF EXISTS ';
  S:=S + FullName;
  AddSQLCommand(S);
end;

{ TSQLite3SQLCreateIndex }

procedure TSQLite3SQLCreateIndex.InitParserTree;
var
  FSQLTokens, T, T1, T2, T3: TSQLTokenRecord;
begin
  {
  CREATE [ UNIQUE ] INDEX [ IF NOT EXISTS ] [ schema . ] name ON table
      (  column [, ...] )
      [ WHERE expression ]
  }
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okIndex);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'UNIQUE', [], 1);
  T3:=AddSQLTokens(stKeyword, [FSQLTokens, T], 'INDEX', [toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, T3, 'IF', [], 2);
    T1:=AddSQLTokens(stKeyword, T1, 'NOT', []);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);

  T:=AddSQLTokens(stIdentificator, [T3, T1], '', [], 3);
  T1:=AddSQLTokens(stString, [T3, T1], '', [], 3);

    T2:=AddSQLTokens(stSymbol, [T, T1], '.', []);
    T2:=AddSQLTokens(stIdentificator, T2, '', [], 4);
    T3:=AddSQLTokens(stString, T2, '', [], 4);

  T:=AddSQLTokens(stKeyword, [T, T1, T2, T3], 'ON', []);

  T1:=AddSQLTokens(stIdentificator, T, '', [], 5);
  T2:=AddSQLTokens(stString, T, '', [], 5);

  T:=AddSQLTokens(stSymbol, [T1, T2], '(', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 6);
  T1:=AddSQLTokens(stSymbol, T, ',', []);
    T1.AddChildToken(T);
  T:=AddSQLTokens(stSymbol, T, ')', []);
  T:=AddSQLTokens(stKeyword, T, 'WHERE', [toOptional], 7);
end;

procedure TSQLite3SQLCreateIndex.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:Unique:=true;
    2:Options:=Options + [ooIfNotExists];
    3:Name:=AWord;
    4:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
    5:TableName:=AWord;
    6:Fields.AddParam(AWord);
    7:WhereExpression:=ASQLParser.GetToCommandDelemiter;
  end;
end;

procedure TSQLite3SQLCreateIndex.MakeSQL;
var
  S: String;
  P: TSQLite3SQLDropIndex;
begin
  if CreateMode in [cmCreateOrAlter, cmRecreate, cmDropAndCreate, cmAlter] then
  begin
    P:=TSQLite3SQLDropIndex.Create(nil);
    P.Name:=Name;
    P.SchemaName:=SchemaName;
    AddSQLCommand(P.AsSQL);
    P.Free;
  end;
  {
  CREATE [ UNIQUE ] INDEX [ IF NOT EXISTS ] [ schema . ] name ON table
      (  column [, ...] )
      [ WHERE expression ]
  }
  S:='CREATE';
  if Unique then
    S:=S + ' UNIQUE';
  S:=S + ' INDEX';
  if ooIfNotExists in Options then
    S:=' IF NOT EXISTS';
  S:=S + ' ' + FullName + ' ON ' + DoFormatName2(TableName) + '('+Fields.AsString + ')';
  if WhereExpression <> '' then
    S:=S + ' WHERE ' + WhereExpression;

  AddSQLCommand(S);
end;

procedure TSQLite3SQLCreateIndex.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLite3SQLCreateIndex then
  begin
    WhereExpression:=TSQLite3SQLCreateIndex(ASource).WhereExpression;

  end;
  inherited Assign(ASource);
end;

{ TSQLite3SQLDropTrigger }

procedure TSQLite3SQLDropTrigger.InitParserTree;
var
  FSQLTokens, T, T1: TSQLTokenRecord;
begin
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'DROP', [toFirstToken], 0, okTrigger);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'TRIGGER', [toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, T, 'IF', []);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', [], -1);
  T:=AddSQLTokens(stIdentificator, [T, T1], '', [], 2);
    T1:=AddSQLTokens(stSymbol, T, '.', [toOptional]);
  T:=AddSQLTokens(stIdentificator, T1, '', [], 3);
end;

procedure TSQLite3SQLDropTrigger.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    2:Name:=AWord;
    3:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
  end;
end;

procedure TSQLite3SQLDropTrigger.MakeSQL;
var
  S: String;
begin
  S:='DROP TRIGGER';
  if ooIfExists in Options then
    S:=S + ' IF EXISTS';
  S:=S + ' ' + FullName;
  AddSQLCommand(S);
end;

{ TSQLite3SQLCreateTrigger }

procedure TSQLite3SQLCreateTrigger.OnProcessComment(Sender: TSQLParser;
  AComment: string);
begin
  Description:=Trim(AComment);
end;

procedure TSQLite3SQLCreateTrigger.InitParserTree;
var
  FSQLTokens, T1, T2, T, TSchemaName, TRB, TRA, TRI,
    TTriggerName, TTI, TTD, TTU: TSQLTokenRecord;
begin
  (*
    CREATE [TEMP|TEMPORARY]  TRIGGER [IF NOT EXISTS] [{schema-name} .]  name
      { BEFORE | AFTER | INSTEAD OF} { INSERT | UPDATE | UPDATE OF column_name1 [, column_name2 ... ] | DELETE}
        ON table [ FOR EACH ROW ]
        [ WHEN condition ]
        BEGIN
          exp;
        END
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okTrigger);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'TEMP', [], 1);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'TEMPORARY', [], 1);
  T:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'TRIGGER', [toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, T, 'IF', [], 2);
    T1:=AddSQLTokens(stKeyword, T1, 'NOT', []);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);
  TSchemaName:=AddSQLTokens(stIdentificator, [T, T1], '', [], 3);
    T1:=AddSQLTokens(stSymbol, TSchemaName, '.', []);
  TTriggerName:=AddSQLTokens(stIdentificator, [T1], '', [], 4);

  TRB:=AddSQLTokens(stKeyword, [TSchemaName, TTriggerName], 'BEFORE', [], 5);
  TRA:=AddSQLTokens(stKeyword, [TSchemaName, TTriggerName], 'AFTER', [], 6);
  TRI:=AddSQLTokens(stKeyword, [TSchemaName, TTriggerName], 'INSTEAD', []);
    TRI:=AddSQLTokens(stKeyword, TRI, 'OF', [], 7);

  TTI:=AddSQLTokens(stKeyword, [TRB, TRA, TRI, TSchemaName, TTriggerName], 'INSERT', [], 8);
  TTD:=AddSQLTokens(stKeyword, [TRB, TRA, TRI, TSchemaName, TTriggerName], 'DELETE', [], 9);
  TTU:=AddSQLTokens(stKeyword, [TRB, TRA, TRI, TSchemaName, TTriggerName], 'UPDATE', [], 10);
    T1:=AddSQLTokens(stKeyword, TTU, 'OF', []);
    T1:=AddSQLTokens(stIdentificator, T1, '', [], 12);
    T2:=AddSQLTokens(stSymbol, T1, ',', [], 12);
      T2.AddChildToken(T1);
  T:=AddSQLTokens(stKeyword, [TTI, TTD, TTU, T1], 'ON', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 11);
    T1:=AddSQLTokens(stKeyword, T, 'FOR', []);
    T1:=AddSQLTokens(stKeyword, T1, 'EACH', []);
    T1:=AddSQLTokens(stKeyword, T1, 'ROW', [], 13);

  T2:=AddSQLTokens(stKeyword, [T, T1], 'WHEN', [], 14);
  T:=AddSQLTokens(stKeyword, [T,T1, T2], 'BEGIN', [], 15);
  T:=AddSQLTokens(stKeyword, T, 'END', []);
end;

procedure TSQLite3SQLCreateTrigger.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
var
  S: String;
  P, C: TParserPosition;
begin
  case AChild.Tag of
    1:Temp:=true;
    2:Options:=Options + [ooIfNotExists];
    3:begin
        Name:=AWord;
        ASQLParser.OnProcessComment:=@OnProcessComment;
      end;
    4:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
    5:TriggerType:=TriggerType + [ttBefore];
    6:TriggerType:=TriggerType + [ttAfter];
    7:TriggerType:=TriggerType + [ttInsteadOf];
    8:TriggerType:=TriggerType + [ttInsert];
    9:TriggerType:=TriggerType + [ttDelete];
   10:TriggerType:=TriggerType + [ttUpdate];
   11:TableName:=AWord;
   12:Fields.AddParam(AWord);
   13:TriggerType:=TriggerType + [ttRow];
   14:begin
       TriggerWhen:=ASQLParser.GetToWord('BEGIN');// Copy(ASQLParser.SQL, ASQLParser.CurPos, Length(ASQLParser.SQL));
       ASQLParser.Position:=ASQLParser.WordPosition;
      end;
   15:begin
        ASQLParser.OnProcessComment:=nil;
        TriggerBody:=AWord;
        P:=ASQLParser.Position;
        while not ASQLParser.Eof do
        begin
          S:=ASQLParser.GetToCommandDelemiter;
          C:=ASQLParser.Position;
          S:=UpperCase(ASQLParser.GetNextWord);
          if S = 'END' then
          begin
            TriggerBody:=AWord + Copy(ASQLParser.SQL, P.Position, ASQLParser.Position.Position - P.Position);
            ASQLParser.Position:=C;
            Break;
          end
          else
          begin
            ASQLParser.Position:=C;
          end;
        end;
      end;
  end;
end;

procedure TSQLite3SQLCreateTrigger.MakeSQL;
var
  S: String;
  D: TSQLite3SQLDropTrigger;
begin
  if CreateMode in [cmCreateOrAlter, cmRecreate, cmDropAndCreate, cmAlter] then
  begin
    D:=TSQLite3SQLDropTrigger.Create(nil);
    D.Name:=Name;
    D.SchemaName:=SchemaName;
    D.Options:=D.Options + [ooIfExists];
    AddSQLCommand(D.AsSQL);
    D.Free;
  end;

  S:='CREATE';
  if Temp then
    S:=S + ' TEMPORARY';
  S:=S + ' TRIGGER';
  if ooIfNotExists in Options then
    S:=S + ' IF NOT EXISTS';

  S:=S + ' ' + FullName;

  if ttBefore in TriggerType then
    S:=S + ' BEFORE'
  else
  if ttAfter in TriggerType then
    S:=S + ' AFTER'
  else
  if ttInsteadOf in TriggerType then
    S:=S + ' INSTEAD OF';

  if ttInsert in TriggerType then
    S:=S + ' INSERT'
  else
  if ttDelete in TriggerType then
    S:=S + ' DELETE'
  else
  if ttUpdate in TriggerType then
  begin
    S:=S + ' UPDATE';
    if Fields.Count > 0 then
      S:=S + ' OF ' + Fields.AsString;
  end;

  S:= S + ' ON ' + DoFormatName2(TableName);
  if ttRow in TriggerType then
    S:=S + ' FOR EACH ROW';
  S:=S + LineEnding;

  if TriggerWhen <> '' then
    S:=S + '  WHEN ' + TriggerWhen + LineEnding;

  if TriggerBody <> '' then
  begin
    if Description <> '' then
      S:=S + '/* ' + Description + ' */' + LineEnding;
    S:=S + TriggerBody;
  end;
  AddSQLCommand(S);
end;

procedure TSQLite3SQLCreateTrigger.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLite3SQLCreateTrigger then
  begin
    Temp:=TSQLite3SQLCreateTrigger(ASource).Temp;
    TableName:=TSQLite3SQLCreateTrigger(ASource).TableName;
    TriggerType:=TSQLite3SQLCreateTrigger(ASource).TriggerType;
    TriggerWhen:=TSQLite3SQLCreateTrigger(ASource).TriggerWhen;
    TriggerBody:=TSQLite3SQLCreateTrigger(ASource).TriggerBody;
  end;
  inherited Assign(ASource);
end;


{ TSQLite3SQLCreateView }

procedure TSQLite3SQLCreateView.OnProcessComment1(Sender: TSQLParser;
  AComment: string);
begin
  if Assigned(FCurField) then
    FCurField.Description:=Trim(AComment);
end;

procedure TSQLite3SQLCreateView.OnProcessComment2(Sender: TSQLParser;
  AComment: string);
begin
  Description:=Trim(AComment);
end;

procedure TSQLite3SQLCreateView.InitParserTree;
var
  FSQLTokens, T1, T2, T, FTSchemaName, FTViewName,
    FTViewColumnName: TSQLTokenRecord;
begin
(*
CREATE [TEMP|TEMPORARY] VIEW [IF NOT EXISTS] [{schema-name} .]  viewname
*)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okView);    //CREATE
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'TEMP', [], 1);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'TEMPORARY', [], 1);


  T:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'VIEW', [toFindWordLast]);                           //VIEW
    T1:=AddSQLTokens(stKeyword, T, 'IF', []);
    T1:=AddSQLTokens(stKeyword, T1, 'NOT', []);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', [], 6);

  FTSchemaName:=AddSQLTokens(stIdentificator, [T, T1], '', [], 2);                 //view name
    T1:=AddSQLTokens(stSymbol, FTSchemaName, '.', []);                 //view name
  FTViewName:=AddSQLTokens(stIdentificator, [T, T1], '', [], 3);                 //view name

  T:=AddSQLTokens(stSymbol, [FTViewName, FTSchemaName], '(', [], 31);

  FTViewColumnName:=AddSQLTokens(stIdentificator, T, '', [], 4);           //Column Name
  T1:=AddSQLTokens(stSymbol, FTViewColumnName, ',', [], 34);
    T1.AddChildToken(FTViewColumnName);
  T1:=AddSQLTokens(stSymbol, FTViewColumnName, ')', [], 32);

  T:=AddSQLTokens(stKeyword, [T1, FTSchemaName, FTViewName], 'AS', [], 33);

  T:=AddSQLTokens( stKeyword, T, 'SELECT', [], 5);
end;

procedure TSQLite3SQLCreateView.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
var
//  C, X, Y: Integer;
  S: String;
  C: TParserPosition;
begin
  case AChild.Tag of
    1:FTempView:=true;
    2:Name:=AWord;
    3:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
    4:FCurField:=Fields.AddParam(AWord);
    5:begin
        ASQLParser.OnProcessComment:=nil;
        C:=ASQLParser.Position;
        ASQLParser.Position:=ASQLParser.WordPosition;
        SQLSelect:=ASQLParser.GetToCommandDelemiter;
        ASQLParser.Position:=C;
        FSQLCommandSelect:=TSQLCommandSelect.Create(nil);
        FSQLCommandSelect.ParseSQL(ASQLParser);
      end;
    6:Options:=Options + [ooIfNotExists];
    31:ASQLParser.OnProcessComment:=@OnProcessComment1;
    32:begin
         ASQLParser.OnProcessComment:=nil;
         FCurField:=nil;
       end;
    33:ASQLParser.OnProcessComment:=@OnProcessComment2;
  end;
end;

procedure TSQLite3SQLCreateView.MakeSQL;
var
  S, S1: String;
  D: TSQLite3SQLDropView;
  F: TSQLParserField;
  i: Integer;
begin
  if CreateMode in [cmCreateOrAlter, cmRecreate, cmDropAndCreate, cmAlter] then
  begin
    D:=TSQLite3SQLDropView.Create(nil);
    D.Name:=FullName;
    D.Options:=D.Options + [ooIfExists];
    AddSQLCommand(D.AsSQL);
    D.Free;
  end;

  S:='CREATE';
  if TempView then
    S:=S + ' TEMPORARY';

  S:=S + ' VIEW';
  if ooIfNotExists in Options then
    S:=S + ' IF NOT EXISTS';

  S:=S +' '+ FullName;

  if Fields.Count > 0 then
    S:=S + '('+LineEnding + Fields.AsList + ')';

  if (SQLSelect<>'') then
  begin
    S:=S + LineEnding + 'AS' + LineEnding;
    S:=S + SQLSelect;  // FSQLCommandSelect.AsSQL;
  end;
  AddSQLCommand(S);
end;

procedure TSQLite3SQLCreateView.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLite3SQLCreateView then
  begin
    TempView:=TSQLite3SQLCreateView(ASource).TempView;
    if not Assigned(SQLCommandSelect) then
      FSQLCommandSelect:=TSQLCommandSelect.Create(nil);
(*    begin
            ASQLParser.OnProcessComment:=nil;
            C:=ASQLParser.Position;
            SQLSelect:=ASQLParser.GetToCommandDelemiter;
            ASQLParser.Position:=C;
            FSQLCommandSelect.ParseSQL(ASQLParser);
          end;*)
    SQLCommandSelect.Assign(TSQLite3SQLCreateView(ASource).SQLCommandSelect);
  end;
  inherited Assign(ASource);
end;

{ TSQLite3SQLPRAGMA }

procedure TSQLite3SQLPRAGMA.InitParserTree;
var
  FSQLTokens, TSchema, T1, TName, T: TSQLTokenRecord;
begin
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'PRAGMA', [toFirstToken, toFindWordLast], 0, okOther);
  TSchema:=AddSQLTokens(stIdentificator, FSQLTokens, '', [], 1);
    T1:=AddSQLTokens(stSymbol, TSchema, '.', []);
  TName:=AddSQLTokens(stIdentificator, T1, '', [], 3);

  T1:=AddSQLTokens(stSymbol, [TSchema, TName], '=', [toOptional], 4);
    T:=AddSQLTokens(stIdentificator, T1, '', [], 5);
    T:=AddSQLTokens(stInteger, T1, '', [], 5);
    T:=AddSQLTokens(stString, T1, '', [], 5);

  T1:=AddSQLTokens(stSymbol, [TSchema, TName], '(', [toOptional], 10);
    T:=AddSQLTokens(stIdentificator, T1, '', [], 11);
    T1:=AddSQLTokens(stSymbol, T, ',', []);
      T1.AddChildToken(T);
  T:=AddSQLTokens(stSymbol, T, ')', []);
end;

procedure TSQLite3SQLPRAGMA.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:Name:=AWord;
    3:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
    4:FSelectable:=false;
    5:FPragmaValue:=AWord;
    10:FSelectable:=true;
    11:Fields.AddParam(AWord);
  end;
end;

function TSQLite3SQLPRAGMA.GetFullName: string;
begin
  if FSchemaName <> '' then
    Result:=FSchemaName +'.'+Name
  else
    Result:=Name;
end;

constructor TSQLite3SQLPRAGMA.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FSelectable:=true;
end;

procedure TSQLite3SQLPRAGMA.MakeSQL;
var
  S1, Result: String;
begin
  Result:='PRAGMA ' + FullName;
  if FSelectable then
  begin
    S1:=Fields.AsString;
    if S1<>'' then
      Result:=Result + '(' + S1 + ')';
  end
  else
    Result:=Result + ' = ' + PragmaValue;
  AddSQLCommand(Result);
end;

procedure TSQLite3SQLPRAGMA.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLite3SQLPRAGMA then
  begin
    SchemaName:=TSQLite3SQLPRAGMA(ASource).SchemaName;
    PragmaValue:=TSQLite3SQLPRAGMA(ASource).PragmaValue;

  end;
  inherited Assign(ASource);
end;

{ TSQLite3SQLAlterTable }

procedure TSQLite3SQLAlterTable.InitParserTree;
var
  FSQLTokens, T, TSchema, T1, TName: TSQLTokenRecord;
begin
(*
ALTER TABLE [database-name .] table-name alteration
alteration ::=
  RENAME TO new-table-name
alteration ::=
  ADD [COLUMN] column-def
*)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'ALTER', [toFirstToken], 0, okTable);
    T:=AddSQLTokens(stKeyword, FSQLTokens, 'TABLE', [toFindWordLast]);
  TSchema:=AddSQLTokens(stIdentificator, T, '', [], 1);
    T1:=AddSQLTokens(stSymbol, TSchema, '.', []);
  TName:=AddSQLTokens(stIdentificator, [T, T1], '', [], 3);

  //RENAME TO new-table-name
  T:=AddSQLTokens(stKeyword, [TSchema, TName], 'RENAME', []);
  T:=AddSQLTokens(stKeyword, T, 'TO', []);
  T:=AddSQLTokens(stIdentificator, T, '', [], 4);

  //ADD [COLUMN] column-def
  T:=AddSQLTokens(stKeyword, [TSchema, TName], 'ADD', []);
  T1:=AddSQLTokens(stKeyword, T, 'COLUMN', []);

  CreateColDef(Self, T, [], false);
  T1.CopyChildTokens(T);
end;

procedure TSQLite3SQLAlterTable.MakeSQL;
var
  Op: TAlterTableOperator;
  S: String;
  C: TSQLConstraintItem;
begin
  for Op in FOperators do
  begin
    case Op.AlterAction of
      ataRenameTable:AddSQLCommandEx('ALTER TABLE %s RENAME TO %s', [DoFormatName2(OP.OldName), DoFormatName2(Op.Name)]);
      ataAddColumn:begin
          S:=DoFormatName(OP.Field.Caption);
          if OP.Field.TypeName <> '' then
            S:=S + ' ' + OP.Field.FullTypeName;
          if fpNotNull in OP.Field.Params then
            S:=S + ' NOT NULL';
          if OP.Field.DefaultValue <> '' then
            S:=S + ' DEFAULT ' + OP.Field.DefaultValue;

          for C in OP.Constraints do
          begin
            if C.ConstraintType = ctForeignKey then
            begin
              if C.ConstraintName <> '' then
                S:=S + ' CONSTRAINT ' + C.ConstraintName;

              S:=S + ' REFERENCES ' + C.ForeignTable + '(' + C.ForeignFields.AsString + ')';
              if C.ForeignKeyRuleOnUpdate <> fkrNone then
                S:=S + ' ON UPDATE ' + ForeignKeyRuleNames[C.ForeignKeyRuleOnUpdate];
              if C.ForeignKeyRuleOnDelete <> fkrNone then
                S:=S + ' ON DELETE ' + ForeignKeyRuleNames[C.ForeignKeyRuleOnDelete];
            end;
          end;

          if OP.Field.Description <> '' then S:=S + ' /* '+ OP.Field.Description +' */';
          AddSQLCommandEx('ALTER TABLE %s ADD COLUMN %s', [FullName, S]);
        end
    else
      raise Exception.CreateFmt('Unknow operator "%s"', [AlterTableActionStr[OP.AlterAction]]);
    end;
  end;
end;

procedure TSQLite3SQLAlterTable.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:Name:=AWord;
    3:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
    4:begin
        FCurOperator:=AddOperator(ataRenameTable);
        FCurOperator.OldName:=GetFullName;
        FCurOperator.Name:=AWord;
        FCurConstraint:=nil;
      end;

    10:begin
        FCurOperator:=AddOperator(ataAddColumn);
        FCurOperator.Field.Caption:=AWord;
        FCurConstraint:=FCurOperator.Constraints.Add(ctNone);
      end;
    11:if Assigned(FCurOperator) then FCurOperator.Field.TypeName:=AWord;
    12:if Assigned(FCurOperator) then FCurOperator.Field.TypeLen:=StrToInt(AWord);
    13:if Assigned(FCurOperator) then FCurOperator.Field.TypePrec:=StrToInt(AWord);
    14, 15 :begin
              FCurOperator:=nil;
              FCurConstraint:=nil;
            end;
    21:if Assigned(FCurConstraint) then FCurConstraint.OnConflict:=ceRollback;
    22:if Assigned(FCurConstraint) then FCurConstraint.OnConflict:=ceAbort;
    23:if Assigned(FCurConstraint) then FCurConstraint.OnConflict:=ceFail;
    24:if Assigned(FCurConstraint) then FCurConstraint.OnConflict:=ceIgnore;
    25:if Assigned(FCurConstraint) then FCurConstraint.OnConflict:=ceReplace;
    26:if Assigned(FCurOperator) then FCurOperator.Field.Params:=FCurOperator.Field.Params + [fpNotNull];
    27:if Assigned(FCurOperator) then
       begin
         FCurConstraint:=FCurOperator.Constraints.Add(ctUnique);
         FCurConstraint.ConstraintFields.AddParam(FCurOperator.Field.Caption);
       end;
    30:if Assigned(FCurOperator) then FCurOperator.Field.DefaultValue:=AWord;

    {   11 - data type
  12 - data len);
  13 - data precession
  17 - constraint name
  16 - PRIMARY KEY
  18 - INDEX ASC
  19 - INDEX DESC
  20 - AUTOINCREMENT
  21 - ON CONFLICT ROLLBACK
  22 - ON CONFLICT ABORT
  22 - ON CONFLICT FAIL
  23 - ON CONFLICT IGNORE
  24 - ON CONFLICT REPLACE
  26 - NOT NULL
  27 - UNIQUE
  28 - CHECK
  29 - COLLATE
  30 - DEFAULT VALUE
}
  end;
end;

{ TSQLite3SQLCreateTable }

procedure TSQLite3SQLCreateTable.OnProcessComment1(Sender: TSQLParser;
  AComment: string);
begin
  if Assigned(FCurFiled) then
    FCurFiled.Description:=Trim(AComment)
  else
    Description:=Trim(AComment)
end;

procedure TSQLite3SQLCreateTable.InitParserTree;
var
  FSQLTokens, T, T1, T2, TName, TSchema, TSymb, TSymb2, TCN,
    TC, TCPK, TCPK1, TSymb3, TSymb4, TCFK, TSymb5,
    TSymb6, TCU, TCFKT, TCofR, TCofA, TCofF, TCofI, TCofRe,
    TSymb_cne, TSchema1, TName1, TRef, TRef1, TRef1_1, TRef1_2,
    TRef1_3, TRef1_4, TRef1_5, TRef2, TRef2_2, TRef2_1,
    TRef2_3, TRef2_4, TRef2_5, TCC, TCC1, TCPK_ASC, TCPK_DESC: TSQLTokenRecord;
begin
(*
  CREATE [TEMP|TEMPORARY] TABLE [IF NOT EXISTS] [{schema-name} .]  tablename
  	(<col_def> [, {<col_def> | <tconstraint>} ...])
  	[WITHOUT ROWID];
*)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okTable);
    T1:=AddSQLTokens(stKeyword, FSQLTokens, 'TEMPORARY', [], 2);
    T2:=AddSQLTokens(stKeyword, FSQLTokens, 'TEMP', [], 2);
  T:=AddSQLTokens(stKeyword, [FSQLTokens, T1, T2], 'TABLE', [toFindWordLast]);
    T1:=AddSQLTokens(stKeyword, T, 'IF', [], 4);
    T1:=AddSQLTokens(stKeyword, T1, 'NOT', []);
    T1:=AddSQLTokens(stKeyword, T1, 'EXISTS', []);

  TSchema:=AddSQLTokens(stIdentificator, [T, T1], '', [], 1);
  TSchema1:=AddSQLTokens(stString, [T, T1], '', [], 1);
   T:=AddSQLTokens(stSymbol, [TSchema, TSchema1], '.', []);
   TName:=AddSQLTokens(stIdentificator, T, '', [], 3);
   TName1:=AddSQLTokens(stString, T, '', [], 3);


  T:=AddSQLTokens(stSymbol, [TSchema,TSchema1, TName, TName1], '(', [], 67);

  TSymb:=AddSQLTokens(stSymbol, nil, ',', [], 14);
  TSymb2:=AddSQLTokens(stSymbol, nil, ')', [], 15);
  //TC:=AddSQLTokens(stKeyword, nil, 'CONSTRAINT', []);
  CreateColDef(Self, T, [TSymb, TSymb2], true);
  TSymb.CopyChildTokens(T);

  TC:=AddSQLTokens(stKeyword, TSymb, 'CONSTRAINT', [], 14);
  //TSymb.AddChildToken(TC);

  TCN:=AddSQLTokens(stIdentificator, TC, '', [], 40);

  TCPK:=AddSQLTokens(stIdentificator, [TSymb, TCN], 'PRIMARY', []);
  TCPK1:=AddSQLTokens(stIdentificator, [TCPK], 'KEY', [], 41);


  TCU:=AddSQLTokens(stKeyword, [TSymb, TCN], 'UNIQUE', [], 42);

  TSymb3:=AddSQLTokens(stSymbol, [TCPK1, TCU], '(', []);
  T:=AddSQLTokens(stIdentificator, TSymb3, '', [], 44);
    TCPK_ASC:=AddSQLTokens(stKeyword, [T], 'ASC', [], 18);
    TCPK_DESC:=AddSQLTokens(stKeyword, [T], 'DESC', [], 19);
  T1:=AddSQLTokens(stSymbol, [T, TCPK_ASC, TCPK_DESC], ',', []);
    T1.AddChildToken(T);
  TSymb4:=AddSQLTokens(stSymbol, [T, TCPK_ASC, TCPK_DESC], ')', []);
    TSymb4.AddChildToken([TSymb2, TC]);

  T:=AddSQLTokens(stKeyword, TSymb4, 'ON', []);
    T:=AddSQLTokens(stKeyword, T, 'CONFLICT', []);
      TCofR:=AddSQLTokens(stKeyword, T, 'ROLLBACK', [], 21);
      TCofA:=AddSQLTokens(stKeyword, T, 'ABORT', [], 22);
      TCofF:=AddSQLTokens(stKeyword, T, 'FAIL', [], 23);
      TCofI:=AddSQLTokens(stKeyword, T, 'IGNORE', [], 24);
      TCofRe:=AddSQLTokens(stKeyword, T, 'REPLACE', [], 25);


  TCFK:=AddSQLTokens(stKeyword, [TSymb, TCN], 'FOREIGN', []);
  T:=AddSQLTokens(stIdentificator, TCFK, 'KEY', [], 45);
  TSymb5:=AddSQLTokens(stSymbol, T, '(', []);
  T:=AddSQLTokens(stIdentificator, TSymb5, '', [], 44);
  T1:=AddSQLTokens(stSymbol, T, ',', []);
    T1.AddChildToken(T);
  T:=AddSQLTokens(stSymbol, T, ')', []);
  T:=AddSQLTokens(stKeyword, T, 'REFERENCES', []);
  TCFKT:=AddSQLTokens(stIdentificator, T, '', [], 46);

  TSymb5:=AddSQLTokens(stSymbol, TCFKT, '(', []);
  T:=AddSQLTokens(stIdentificator, TSymb5, '', [], 47);
  T1:=AddSQLTokens(stSymbol, T, ',', []);
    T1.AddChildToken(T);
  TSymb6:=AddSQLTokens(stSymbol, T, ')', []);
  TSymb6.AddChildToken(TSymb2);

  TRef:=AddSQLTokens(stKeyword, [TSymb6, TCFKT], 'ON', []);
    TRef1:=AddSQLTokens(stKeyword, TRef, 'UPDATE', []);
       TRef1_2:=AddSQLTokens(stKeyword, TRef1, 'SET', []);
         TRef1_1:=AddSQLTokens(stKeyword, TRef1_2, 'NULL', [], 33);
         TRef1_2:=AddSQLTokens(stKeyword, TRef1_2, 'DEFAULT', [], 34);
       TRef1_3:=AddSQLTokens(stKeyword, TRef1, 'CASCADE', [], 35);
       TRef1_4:=AddSQLTokens(stKeyword, TRef1, 'RESTRICT', [], 36);
       TRef1_5:=AddSQLTokens(stKeyword, TRef1, 'NO', []);
       TRef1_5:=AddSQLTokens(stIdentificator, TRef1_5, 'ACTION', [], 36);
    TRef2:=AddSQLTokens(stKeyword, TRef, 'DELETE', []);
      TRef2_2:=AddSQLTokens(stKeyword, TRef2, 'SET', []);
        TRef2_1:=AddSQLTokens(stKeyword, TRef2_2, 'NULL', [], 80);
        TRef2_2:=AddSQLTokens(stKeyword, TRef2_2, 'DEFAULT', [], 81);
      TRef2_3:=AddSQLTokens(stKeyword, TRef2, 'CASCADE', [], 82);
      TRef2_4:=AddSQLTokens(stKeyword, TRef2, 'RESTRICT', [], 83);
      TRef2_5:=AddSQLTokens(stKeyword, TRef2, 'NO', []);
      TRef2_5:=AddSQLTokens(stIdentificator, TRef2_5, 'ACTION', [], 83);

  TRef1_1.AddChildToken([TRef, TSymb2]);
  TRef1_2.AddChildToken([TRef, TSymb2]);
  TRef1_3.AddChildToken([TRef, TSymb2]);
  TRef1_4.AddChildToken([TRef, TSymb2]);
  TRef1_5.AddChildToken([TRef, TSymb2]);
  TRef2_1.AddChildToken([TRef, TSymb2]);
  TRef2_2.AddChildToken([TRef, TSymb2]);
  TRef2_3.AddChildToken([TRef, TSymb2]);
  TRef2_4.AddChildToken([TRef, TSymb2]);
  TRef2_5.AddChildToken([TRef, TSymb2]);


  TCC:=AddSQLTokens(stKeyword, [TSymb, TCN], 'check', [], 50);

  TCC1:=AddSQLTokens(stSymbol, TCC, '(', [], 51);
//  TCC1:=AddSQLTokens(stSymbol, TCC1, ')', []);
  TCC1.AddChildToken(TSymb2);

  TSymb_cne:=AddSQLTokens(stSymbol, [TSymb6, TSymb4, TRef1_1, TRef1_2, TRef1_3, TRef1_4, TRef1_5,
    TRef2_1, TRef2_2, TRef2_3, TRef2_4, TRef2_5, TCC1], ',', [], 14);
    TSymb_cne.AddChildToken([TCPK, TCU, TCFK, TC, TCC]);

    TRef1_1.AddChildToken(TC);
    TRef1_2.AddChildToken(TC);
    TRef1_3.AddChildToken(TC);
    TRef1_4.AddChildToken(TC);
    TRef1_5.AddChildToken(TC);
    TRef2_1.AddChildToken(TC);
    TRef2_2.AddChildToken(TC);
    TRef2_3.AddChildToken(TC);
    TRef2_4.AddChildToken(TC);
    TRef2_5.AddChildToken(TC);


  TCofR.AddChildToken([TSymb2]);
  TCofA.AddChildToken([TSymb2]);
  TCofF.AddChildToken([TSymb2]);
  TCofI.AddChildToken([TSymb2]);
  TCofRe.AddChildToken([TSymb2]);

  T:=AddSQLTokens(stKeyword, TSymb2, 'WITHOUT', [toOptional]);
  T:=AddSQLTokens(stIdentificator, T, '', [], 66);

  T:=AddSQLTokens(stKeyword, TSymb2, 'AS', [toOptional]);
end;

procedure TSQLite3SQLCreateTable.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  case AChild.Tag of
    1:begin
        Name:=AWord;
        ASQLParser.OnProcessComment:=@OnProcessComment1;
      end;
    2:TempTable:=true;
    3:begin
        SchemaName:=Name;
        Name:=AWord;
      end;
    4:Options:=Options + [ooIfNotExists];
    10:FCurFiled:=Fields.AddParam(AWord);
    11:if Assigned(FCurFiled) then
       begin
         if FCurFiled.TypeName <> '' then
           FCurFiled.TypeName:=FCurFiled.TypeName + ' ';
         FCurFiled.TypeName:=FCurFiled.TypeName + AWord;
       end;
    12:if Assigned(FCurFiled) then FCurFiled.TypeLen:=StrToInt(AWord);
    13:if Assigned(FCurFiled) then FCurFiled.TypePrec:=StrToInt(AWord);
    14, 15:
      begin
         FCurFiled:=nil;
         FCurConstraint:=nil;
         if AChild.Tag = 15 then
           ASQLParser.OnProcessComment:=nil;
      end;
    16:begin
         FCurConstraint:=SQLConstraints.Add(ctPrimaryKey);
         if Assigned(FCurFiled) then
         begin
           FCurFiled.PrimaryKey:=true;
           FCurConstraint.ConstraintFields.AddParam(FCurFiled.Caption);
         end;
       end;
    20:if Assigned(FCurFiled) then FCurFiled.Params:=FCurFiled.Params + [fpAutoInc];
    21:if Assigned(FCurConstraint) then FCurConstraint.OnConflict:=ceRollback;
    22:if Assigned(FCurConstraint) then FCurConstraint.OnConflict:=ceAbort;
    23:if Assigned(FCurConstraint) then FCurConstraint.OnConflict:=ceFail;
    24:if Assigned(FCurConstraint) then FCurConstraint.OnConflict:=ceIgnore;
    25:if Assigned(FCurConstraint) then FCurConstraint.OnConflict:=ceReplace;
    91:if Assigned(FCurFiled) then FCurFiled.NotNullConflictRule:=ceRollback;
    92:if Assigned(FCurFiled) then FCurFiled.NotNullConflictRule:=ceAbort;
    93:if Assigned(FCurFiled) then FCurFiled.NotNullConflictRule:=ceFail;
    94:if Assigned(FCurFiled) then FCurFiled.NotNullConflictRule:=ceIgnore;
    95:if Assigned(FCurFiled) then FCurFiled.NotNullConflictRule:=ceReplace;
    26:if Assigned(FCurFiled) then FCurFiled.Params:=FCurFiled.Params + [fpNotNull];
    27:begin
         FCurConstraint:=SQLConstraints.Add(ctUnique);
         if Assigned(FCurFiled) then
           FCurConstraint.ConstraintFields.AddParam(FCurFiled.Caption);
       end;
    29:if Assigned(FCurFiled) then FCurFiled.Collate:=AWord;
    30:if Assigned(FCurFiled) then FCurFiled.DefaultValue:=AWord;
    31:if Assigned(FCurFiled) then
       begin
         FCurConstraint:=SQLConstraints.Add(ctForeignKey);
         FCurConstraint.ConstraintFields.AddParam(FCurFiled.Caption);
         FCurConstraint.ForeignTable:=AWord;
       end;
    32:if Assigned(FCurConstraint) then FCurConstraint.ForeignFields.AddParam(AWord);
    33:if Assigned(FCurConstraint) then FCurConstraint.ForeignKeyRuleOnUpdate:=fkrSetNull;
    34:if Assigned(FCurConstraint) then FCurConstraint.ForeignKeyRuleOnUpdate:=fkrSetDefault;
    35:if Assigned(FCurConstraint) then FCurConstraint.ForeignKeyRuleOnUpdate:=fkrCascade;
    36:if Assigned(FCurConstraint) then FCurConstraint.ForeignKeyRuleOnUpdate:=fkrNone;
    80:if Assigned(FCurConstraint) then FCurConstraint.ForeignKeyRuleOnDelete:=fkrSetNull;
    81:if Assigned(FCurConstraint) then FCurConstraint.ForeignKeyRuleOnDelete:=fkrSetDefault;
    82:if Assigned(FCurConstraint) then FCurConstraint.ForeignKeyRuleOnDelete:=fkrCascade;
    83:if Assigned(FCurConstraint) then FCurConstraint.ForeignKeyRuleOnDelete:=fkrSetDefault;
    40:FCurConstraint:=SQLConstraints.Add(ctNone, AWord);
    41:if not Assigned(FCurConstraint) then
         FCurConstraint:=SQLConstraints.Add(ctPrimaryKey)
       else
         FCurConstraint.ConstraintType:=ctPrimaryKey;
    18:if Assigned(FCurConstraint) then
         FCurConstraint.IndexSortOrder:=indAscending;
    19:if Assigned(FCurConstraint) then
         FCurConstraint.IndexSortOrder:=indDescending;
    42:if not Assigned(FCurConstraint) then
         FCurConstraint:=SQLConstraints.Add(ctUnique)
       else
         FCurConstraint.ConstraintType:=ctUnique;
    44:if Assigned(FCurConstraint) then FCurConstraint.ConstraintFields.AddParam(AWord);
    45:if not Assigned(FCurConstraint) then
           FCurConstraint:=SQLConstraints.Add(ctForeignKey)
       else
          FCurConstraint.ConstraintType:=ctForeignKey;
    46:if Assigned(FCurConstraint) then FCurConstraint.ForeignTable:=AWord;
    47:if Assigned(FCurConstraint) then FCurConstraint.ForeignFields.AddParam(AWord);

    50:if not Assigned(FCurConstraint) then
         FCurConstraint:=SQLConstraints.Add(ctTableCheck)
       else
         FCurConstraint.ConstraintType:=ctTableCheck;

    51:if Assigned(FCurConstraint) then FCurConstraint.ConstraintExpression:=ASQLParser.GetToBracket(')');
    66:FWithoutRowID:=UpperCase(AWord) = 'ROWID';
  end;
end;

procedure TSQLite3SQLCreateTable.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TSQLite3SQLCreateTable then
  begin
    TempTable:=TSQLite3SQLCreateTable(ASource).TempTable;
    WithoutRowID:=TSQLite3SQLCreateTable(ASource).WithoutRowID;

  end;
  inherited Assign(ASource);
end;

procedure TSQLite3SQLCreateTable.MakeSQL;
var
  S1, S, S2, SPK: String;
  F: TSQLParserField;
  C: TSQLConstraintItem;
  FCountPK: Integer;
begin
  S:='CREATE ';
  if TempTable then
    S:=S + 'GLOBAL TEMPORARY ';
  S:=S+'TABLE ';
  if ooIfNotExists in Options then
    S:=S + 'IF NOT EXISTS ';
  S:=S + FullName;
  //Проверим есть ли несколько полей PK
  FCountPK:=0;
  for F in Fields do
  begin
    if F.PrimaryKey then Inc(FCountPK);
  end;

  S1:='';
  SPK:='';
  for F in Fields do
  begin
    S1:=S1 + '  ' + DoFormatName(F.Caption);
    if F.TypeName <> '' then
       S1:=S1 + ' ' + F.FullTypeName;

    if fpNotNull in F.Params then
    begin
       S1:=S1 + ' NOT NULL';
       case F.NotNullConflictRule of
         ceRollback:S1:=S1+' ON CONFLICT ROLLBACK';
         ceAbort:S1:=S1 + ' ON CONFLICT ABORT';
         ceFail:S1:=S1 + ' ON CONFLICT FAIL';
         ceIgnore:S1:=S1+' ON CONFLICT IGNORE';
         ceReplace:S1:=S1+' ON CONFLICT REPLACE';
       end;
    end;

    if F.PrimaryKey then
    begin
      if FCountPK < 2 then
      begin
        S1:=S1 + ' PRIMARY KEY';
        C:=SQLConstraints.Find(ctPrimaryKey);
        if Assigned(C) then
        begin
          if C.IndexSortOrder = indAscending then
            S1:=S1 + ' ASC'
          else
          if C.IndexSortOrder = indDescending then
            S1:=S1 + ' DESC'
        end;
      end
      else
        SPK:=SPK + F.Caption + ', ';
    end;

    if fpAutoInc in F.Params then
       S1:=S1 + ' AUTOINCREMENT';

    if F.Collate <> '' then
        S1:=S1 + ' COLLATE ' + F.Collate;

    if F.DefaultValue <> '' then
       S1:=S1 + ' DEFAULT ' + F.DefaultValue;

    if F.Description <> '' then
         S1:=S1 + ' /* ' + F.Description + ' */';

    S1:=S1 +',' + LineEnding;
  end;

  S2:='';
  if SPK <> '' then
    S2:=S2 + ' PRIMARY KEY ('+copy(SPK, 1, Length(SPK)-2) + ')' (* + LineEnding *);

  for C in SQLConstraints do
  begin
    if (S2 <> '') then
    begin
      if (C.ConstraintType = ctPrimaryKey) then
      begin
        if  (FCountPK = 0) then
          S2:= S2 +',' + LineEnding;
      end
      else
        S2:= S2 +',' + LineEnding;
//      S2:= S2 + LineEnding;
    end;

    if C.ConstraintName <> '' then
      S2:=S2 + ' CONSTRAINT ' + DoFormatName(C.ConstraintName);

    if (C.ConstraintType = ctPrimaryKey) and (FCountPK = 0) then
    begin
      S2:=S2 + ' PRIMARY KEY ('+C.ConstraintFields.AsString;
      if C.IndexSortOrder = indAscending then
        S2:=S2 + ' ASC'
      else
      if C.IndexSortOrder = indDescending then
        S2:=S2 + ' DESC';
      S2:=S2 + ')'
    end
    else
    if C.ConstraintType = ctUnique then
      S2:=S2 + ' UNIQUE ('+C.ConstraintFields.AsString + ')'
    else
    if C.ConstraintType = ctTableCheck then
      S2:=S2 + ' CHECK ('+C.ConstraintExpression + ')'
    else
    if C.ConstraintType = ctForeignKey then
    begin
      S2:=S2 + ' FOREIGN KEY ('+C.ConstraintFields.AsString +
        ') REFERENCES ' + DoFormatName(C.ForeignTable);
      if C.ForeignFields.Count > 0 then
        S2:=S2 + ' (' + C.ForeignFields.AsString + ')';
      if C.ForeignKeyRuleOnUpdate <> fkrNone then
         S2:=S2 + ' ON UPDATE ' + ForeignKeyRuleNames[C.ForeignKeyRuleOnUpdate];
      if C.ForeignKeyRuleOnDelete <> fkrNone then
         S2:=S2 + ' ON DELETE ' + ForeignKeyRuleNames[C.ForeignKeyRuleOnDelete];
    end;


    case C.OnConflict of
      ceRollback:S2:=S2+' ON CONFLICT ROLLBACK';
      ceAbort:S2:=S2 + ' ON CONFLICT ABORT';
      ceFail:S2:=S2 + ' ON CONFLICT FAIL';
      ceIgnore:S2:=S2+' ON CONFLICT IGNORE';
      ceReplace:S2:=S2+' ON CONFLICT REPLACE';
    end;

  end;

  if (S1<>'') or (S2<>'') then
  begin
    S:=S+'('+LineEnding;
    if S1<>'' then
    begin
      if Description <> '' then
         S:=S + '/* '+Description+' */' + LineEnding;

      S:=S + Copy(S1, 1, Length(S1) - Length(',' + LineEnding));
      if S2<>'' then
        S:=S+',';
      S:=S + LineEnding ;
    end;
    if S2<>'' then S:=S + S2 +LineEnding ;
    S:=S +')';
  end;

  if FWithoutRowID then
    S:=S + LineEnding + 'WITHOUT ROWID';
  AddSQLCommand(S);
end;

end.
