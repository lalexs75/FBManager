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
//from https://docs.microsoft.com/ru-ru/sql/t-sql/statements/statements?view=sql-server-ver15
unit mssql_sql_parser;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, fbmSqlParserUnit, sqlObjects;

{
Общее
    BULK INSERT
    DELETE
    DISABLE TRIGGER
    ENABLE TRIGGER
    INSERT
    INSERT (граф SQL)
    UPDATE
    MERGE
    TRUNCATE TABLE
    UPDATE STATISTICS
ALTER
    APPLICATION ROLE
    ASSEMBLY
    ASYMMETRIC KEY
    AUTHORIZATION
    AVAILABILITY GROUP
    BROKER PRIORITY
    CERTIFICATE
    COLUMN ENCRYPTION KEY
    CREDENTIAL
    CRYPTOGRAPHIC PROVIDER
    DATABASE
    DATABASE AUDIT SPECIFICATION
    Уровень совместимости DATABASE
    Зеркальное отображение базы данных DATABASE
    DATABASE ENCRYPTION KEY
    Параметры файлов и файловых групп DATABASE
    DATABASE HADR
    DATABASE SCOPED CONFIGURATION
    Параметры DATABASE SET
    ENDPOINT
    EVENT SESSION
    EXTERNAL DATA SOURCE
    EXTERNAL LIBRARY
    EXTERNAL RESOURCE POOL
    FULLTEXT CATALOG
    FULLTEXT INDEX
    FULLTEXT STOPLIST
    FUNCTION
    INDEX
    INDEX (выборочные XML-индексы)
    Имя_для_входа
    MASTER KEY
    MESSAGE TYPE
    PARTITION FUNCTION
    PARTITION SCHEME
    PROCEDURE
    QUEUE
    REMOTE SERVICE BINDING
    RESOURCE GOVERNOR
    RESOURCE POOL
    ROLE
    ROUTE
    SEARCH PROPERTY LIST
    SECURITY POLICY
    SEQUENCE
    SERVER AUDIT
    SERVER AUDIT SPECIFICATION
    КОНФИГУРАЦИЯ СЕРВЕРА
    SERVER ROLE
    SERVICE
    SERVICE MASTER KEY
    SYMMETRIC KEY
    TRIGGER
    Пользователь
    VIEW
    WORKLOAD GROUP
    XML SCHEMA COLLECTION
Резервное копирование
    BACKUP
    BACKUP CERTIFICATE
    BACKUP MASTER KEY
    BACKUP SERVICE MASTER KEY
    RESTORE
    RESTORE (инструкции)
    RESTORE, аргументы
    RESTORE FILELISTONLY
    инструкция RESTORE HEADERONLY
    RESTORE LABELONLY
    RESTORE MASTER KEY
    RESTORE SERVICE MASTER KEY
    RESTORE REWINDONLY
    RESTORE VERIFYONLY
CREATE
    AGGREGATE
    APPLICATION ROLE
    ASSEMBLY
    ASYMMETRIC KEY
    AVAILABILITY GROUP
    BROKER PRIORITY
    CERTIFICATE
    COLUMNSTORE INDEX
    COLUMN ENCRYPTION KEY
    COLUMN MASTER KEY
    CONTRACT
    CREDENTIAL
    CRYPTOGRAPHIC PROVIDER
    DATABASE
    DATABASE AUDIT SPECIFICATION
    DATABASE ENCRYPTION KEY
    DATABASE SCOPED CREDENTIAL
    DEFAULT
    ENDPOINT
    EVENT NOTIFICATION
    EVENT SESSION
    EXTERNAL DATA SOURCE
    EXTERNAL LIBRARY
    EXTERNAL FILE FORMAT
    EXTERNAL RESOURCE POOL
    EXTERNAL TABLE
    FULLTEXT CATALOG
    FULLTEXT INDEX
    FULLTEXT STOPLIST
    FUNCTION
    INDEX
    Имя_для_входа
    MASTER KEY
    MESSAGE TYPE
    PARTITION FUNCTION
    PARTITION SCHEME
    PROCEDURE
    QUEUE
    REMOTE SERVICE BINDING
    RESOURCE POOL
    ROLE
    ROUTE
    RULE
    SEARCH PROPERTY LIST
    SECURITY POLICY
    SELECTIVE XML INDEX
    SEQUENCE
    SERVER AUDIT
    SERVER AUDIT SPECIFICATION
    SERVER ROLE
    SERVICE
    SPATIAL INDEX
    STATISTICS
    SYMMETRIC KEY
    SYNONYM
    TRIGGER
    TYPE
    Пользователь
    VIEW
    WORKLOAD GROUP
    XML INDEX
    XML INDEX (выборочные XML-индексы)
    XML SCHEMA COLLECTION
DROP
    AGGREGATE
    APPLICATION ROLE
    ASSEMBLY
    ASYMMETRIC KEY
    AVAILABILITY GROUP
    BROKER PRIORITY
    CERTIFICATE
    COLUMN ENCRYPTION KEY
    COLUMN MASTER KEY
    CONTRACT
    CREDENTIAL
    CRYPTOGRAPHIC PROVIDER
    DATABASE
    DATABASE AUDIT SPECIFICATION
    DATABASE ENCRYPTION KEY
    DEFAULT
    ENDPOINT
    EXTERNAL DATA SOURCE
    EXTERNAL FILE FORMAT
    EXTERNAL LIBRARY
    EXTERNAL RESOURCE POOL
    EXTERNAL TABLE
    EVENT NOTIFICATION
    EVENT SESSION
    FULLTEXT CATALOG
    FULLTEXT INDEX
    FULLTEXT STOPLIST
    FUNCTION
    INDEX
    INDEX (выборочные XML-индексы)
    Имя_для_входа
    MASTER KEY
    MESSAGE TYPE
    PARTITION FUNCTION
    PARTITION SCHEME
    PROCEDURE
    QUEUE
    REMOTE SERVICE BINDING
    RESOURCE POOL
    ROLE
    ROUTE
    RULE
    SEARCH PROPERTY LIST
    SECURITY POLICY
    SEQUENCE
    SERVER AUDIT
    SERVER AUDIT SPECIFICATION
    SERVER ROLE
    SERVICE
    SIGNATURE
    STATISTICS
    SYMMETRIC KEY
    SYNONYM
    TRIGGER
    TYPE
    Пользователь
    VIEW
    WORKLOAD GROUP
    XML SCHEMA COLLECTION
Оазрешения
    ADD SIGNATURE
    CLOSE MASTER KEY
    CLOSE SYMMETRIC KEY
    DENY
    DENY (разрешения на сборку)
    DENY (разрешения на асимметричный ключ)
    DENY (разрешения на группу доступности)
    DENY (разрешения на сертификат)
    DENY (разрешения на базу данных)
    DENY (разрешения на субъект базы данных)
    DENY (учетные данные для базы данных)
    DENY (разрешения на конечную точку)
    DENY (разрешения на полнотекстовые объекты)
    DENY (разрешения на объекты)
    DENY (разрешения на схему)
    DENY (разрешения на список свойств поиска)
    DENY (разрешения на сервер)
    DENY (разрешения на субъект сервера)
    DENY (разрешения Service Broker)
    DENY (разрешения на симметричный ключ)
    DENY (разрешения на системные объекты)
    DENY (разрешения на тип)
    DENY (разрешения на коллекцию XML-схем)
    EXECUTE AS
    Предложение EXECUTE AS
    GRANT
    GRANT (разрешения на сборку)
    GRANT (разрешения на асимметричный ключ)
    GRANT (разрешения на группу доступности)
    GRANT (разрешения на сертификат)
    GRANT (разрешения на базу данных)
    GRANT (разрешения на субъект базы данных)
    GRANT (учетные данные для базы данных)
    GRANT (разрешения на конечную точку)
    GRANT (разрешения на полнотекстовые объекты)
    GRANT (разрешения на объекты)
    GRANT (разрешения на схему)
    GRANT (разрешения на список свойств поиска)
    GRANT (разрешения на сервер)
    GRANT (разрешения на субъект сервера)
    GRANT (разрешения Service Broker)
    GRANT (разрешения на симметричный ключ)
    GRANT (разрешения на системные объекты)
    GRANT (разрешения на тип)
    GRANT (разрешения на коллекцию XML-схем)
    OPEN MASTER KEY
    OPEN SYMMETRIC KEY
    REVERT
    REVOKE
    REVOKE (разрешения на сборку)
    REVOKE (разрешения на асимметричный ключ)
    REVOKE (разрешения на группу доступности)
    REVOKE (разрешения на сертификат)
    REVOKE (разрешения на базу данных)
    REVOKE (разрешения на субъект базы данных)
    REVOKE (учетные данные для базы данных)
    REVOKE (разрешения на конечную точку)
    REVOKE (разрешения на полнотекстовые объекты)
    REVOKE (разрешения на объекты)
    REVOKE (разрешения на схему)
    REVOKE (разрешения на список свойств поиска)
    REVOKE (разрешения на сервер)
    REVOKE (разрешения на субъект сервера)
    REVOKE (разрешения Service Broker)
    REVOKE (разрешения на симметричный ключ)
    REVOKE (разрешения на системные объекты)
    REVOKE (разрешения на тип)
    REVOKE (разрешения на коллекцию XML-схем)
    SETUSER

    SET
    ANSI_DEFAULTS
    ANSI_NULL_DFLT_OFF
    ANSI_NULL_DFLT_ON
    ANSI_NULLS
    ANSI_PADDING
    ANSI_WARNINGS
    ARITHABORT
    ARITHIGNORE
    CONCAT_NULL_YIELDS_NULL
    CONTEXT_INFO
    CURSOR_CLOSE_ON_COMMIT
    DATEFIRST
    DATEFORMAT
    DEADLOCK_PRIORITY
    FIPS_FLAGGER
    FMTONLY
    FORCEPLAN
    IDENTITY_INSERT
    IMPLICIT_TRANSACTIONS
    LANGUAGE
    LOCK_TIMEOUT
    NOCOUNT
    NOEXEC
    NUMERIC_ROUNDABORT
    OFFSETS
    PARSEONLY
    QUERY_GOVERNOR_COST_LIMIT
    QUOTED_IDENTIFIER
    REMOTE_PROC_TRANSACTIONS
    ROWCOUNT
    SHOWPLAN_ALL
    SHOWPLAN_TEXT
    SHOWPLAN_XML
    STATISTICS IO
    STATISTICS PROFILE
    STATISTICS TIME
    STATISTICS XML
    TEXTSIZE
    TRANSACTION ISOLATION LEVEL
    XACT_ABORT



    BULK INSERT (Transact-SQL)

    SELECT (Transact-SQL)

    DELETE (Transact-SQL)

    UPDATE (Transact-SQL)

    INSERT (Transact-SQL)

    UPDATETEXT (Transact-SQL)

    MERGE (Transact-SQL)

    WRITETEXT (Transact-SQL)

    READTEXT (Transact-SQL)
}
type

  { TMSSQLCreateSchema }

  TMSSQLCreateSchema = class(TSQLCreateCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
  end;

  { TMSSQLAlterSchema }

  TMSSQLAlterSchema = class(TSQLCommandDDL)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
  end;

  { TMSSQLDropSchema }

  TMSSQLDropSchema = class(TSQLDropCommandAbstract)
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
  end;

  { TMSSQLCreateTable }

  TMSSQLCreateTable = class(TSQLCreateTable)
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    destructor Destroy;override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property SchemaName;
  end;

  { TMSSQLAlterTable }

  TMSSQLAlterTable = class(TSQLAlterTable)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    destructor Destroy;override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
    property SchemaName;
  end;

  { TMSSQLDropTable }

  TMSSQLDropTable = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  end;

  { TMSSQLCreateView }

  TMSSQLCreateView = class(TSQLCreateView)
  private
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
  end;

  { TMSSQLAlterView }

  TMSSQLAlterView = class(TSQLCommandDDL)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
  end;

  { TMSSQLDropView }

  TMSSQLDropView = class(TSQLDropCommandAbstract)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    property SchemaName;
  end;

  { TMSSQLExec }

  TMSSQLExec = class(TSQLCommandDDL)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
  end;

  { TMSSQLGO }

  TMSSQLGO = class(TSQLCommandDDL)
  private
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    constructor Create(AParent:TSQLCommandAbstract);override;
    procedure Assign(ASource:TSQLObjectAbstract); override;
  end;

  { TMSSQLCommentOn }

  TMSSQLCommentOn = class(TSQLCommentOn)
  protected
    procedure MakeSQL;override;
  public
    property TableName;
    property SchemaName;
  end;

  { TMSSQLCreateDatabase }

  TMSSQLCreateDatabase = class(TSQLCreateDatabase)
  private
    FCurParam: TSQLParserField;
  protected
    procedure InitParserTree;override;
    procedure InternalProcessChildToken(ASQLParser:TSQLParser; AChild:TSQLTokenRecord; AWord:string);override;
    procedure MakeSQL;override;
  public
    procedure Assign(ASource:TSQLObjectAbstract); override;
  end;

  { TMSSQLDropDatabase }

  TMSSQLDropDatabase = class(TSQLDropCommandAbstract)
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

implementation

uses SQLEngineCommonTypesUnit;

{ TMSSQLDropDatabase }

procedure TMSSQLDropDatabase.InitParserTree;
begin
  (*
  DROP DATABASE [ IF EXISTS ] { database_name | database_snapshot_name } [ ,...n ] [;]
  *)
end;

procedure TMSSQLDropDatabase.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TMSSQLDropDatabase.MakeSQL;
begin
  inherited MakeSQL;
end;

procedure TMSSQLDropDatabase.Assign(ASource: TSQLObjectAbstract);
begin
  inherited Assign(ASource);
end;

{ TMSSQLCreateDatabase }

procedure TMSSQLCreateDatabase.InitParserTree;
var
  FSQLTokens, T: TSQLTokenRecord;
begin
  (*
  CREATE DATABASE database_name
  [ CONTAINMENT = { NONE | PARTIAL } ]
  [ ON
        [ PRIMARY ] <filespec> [ ,...n ]
        [ , <filegroup> [ ,...n ] ]
        [ LOG ON <filespec> [ ,...n ] ]
  ]
  [ COLLATE collation_name ]
  [ WITH <option> [,...n ] ]
  [;]

  <option> ::=
  {
        FILESTREAM ( <filestream_option> [,...n ] )
      | DEFAULT_FULLTEXT_LANGUAGE = { lcid | language_name | language_alias }
      | DEFAULT_LANGUAGE = { lcid | language_name | language_alias }
      | NESTED_TRIGGERS = { OFF | ON }
      | TRANSFORM_NOISE_WORDS = { OFF | ON}
      | TWO_DIGIT_YEAR_CUTOFF = <two_digit_year_cutoff>
      | DB_CHAINING { OFF | ON }
      | TRUSTWORTHY { OFF | ON }
      | PERSISTENT_LOG_BUFFER=ON ( DIRECTORY_NAME='<Filepath to folder on DAX formatted volume>' )
  }

  <filestream_option> ::=
  {
        NON_TRANSACTED_ACCESS = { OFF | READ_ONLY | FULL }
      | DIRECTORY_NAME = 'directory_name'
  }

  <filespec> ::=
  {
  (
      NAME = logical_file_name ,
      FILENAME = { 'os_file_name' | 'filestream_path' }
      [ , SIZE = size [ KB | MB | GB | TB ] ]
      [ , MAXSIZE = { max_size [ KB | MB | GB | TB ] | UNLIMITED } ]
      [ , FILEGROWTH = growth_increment [ KB | MB | GB | TB | % ] ]
  )
  }

  <filegroup> ::=
  {
  FILEGROUP filegroup name [ [ CONTAINS FILESTREAM ] [ DEFAULT ] | CONTAINS MEMORY_OPTIMIZED_DATA ]
      <filespec> [ ,...n ]
  }

  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0);
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'DATABASE', [toFindWordLast], 0);
  T:=AddSQLTokens(stIdentificator, T, 'DATABASE', [], 1);
end;

procedure TMSSQLCreateDatabase.InternalProcessChildToken(
  ASQLParser: TSQLParser; AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
  case AChild.Tag of
    1:Name:=AWord;
  end;
end;

procedure TMSSQLCreateDatabase.MakeSQL;
var
  S: String;
begin
  S:='CREATE DATABASE ' + Name;
  AddSQLCommand(S);
end;

procedure TMSSQLCreateDatabase.Assign(ASource: TSQLObjectAbstract);
begin
  inherited Assign(ASource);
end;

{ TMSSQLCommentOn }

procedure TMSSQLCommentOn.MakeSQL;
var
  S: String;
begin
  case ObjectKind of
    okTable:
      begin
        if Description = '' then
          AddSQLCommandEx('EXEC sp_dropextendedproperty ''MS_Description'', N''schema'', N''%s'', N''table'', N''%s''', [SchemaName, TableName])
        else
          AddSQLCommandEx('EXEC sp_addextendedproperty ''MS_Description'', N%s, N''schema'', N''%s'', N''table'', N''%s''', [QuotedStr(Description), SchemaName, TableName]);
      end;
    okView:
      begin
        if Description = '' then
          AddSQLCommandEx('EXEC sp_dropextendedproperty ''MS_Description'', N''schema'', N''%s'', N''view'', N''%s''', [SchemaName, TableName])
        else
          AddSQLCommandEx('EXEC sp_addextendedproperty ''MS_Description'', N%s, N''schema'', N''%s'', N''view'', N''%s''', [QuotedStr(Description), SchemaName, TableName]);
      end;
    okColumn:
      begin
        if ParentObjectKind = okTable then
          S:='table'
        else
        if ParentObjectKind = okView then
          S:='view'
        else
          S:='';
        if Description = '' then
          AddSQLCommandEx('EXEC sp_dropextendedproperty ''MS_Description'', N''schema'', N''%s'', N''%s'', N''%s'', N''column'', N''%s''', [SchemaName, S, TableName, Name])
        else
          AddSQLCommandEx('EXEC sp_addextendedproperty ''MS_Description'', N%s, N''schema'', N''%s'', N''%s'', N''%s'', N''column'', N''%s''', [QuotedStr(Description), SchemaName, S, TableName, Name]);
      end;
  end;
end;


{ TMSSQLGO }

procedure TMSSQLGO.InitParserTree;
var
  FSQLTokens1: TSQLTokenRecord;
begin
  (*
  GO [count]
  *)
  FSQLTokens1:=AddSQLTokens(stKeyword, nil, 'GO', [toFirstToken, toFindWordLast], 0);
end;

procedure TMSSQLGO.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TMSSQLGO.MakeSQL;
begin
  inherited MakeSQL;
end;

constructor TMSSQLGO.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
end;

procedure TMSSQLGO.Assign(ASource: TSQLObjectAbstract);
begin
  inherited Assign(ASource);
end;

{ TMSSQLExec }

procedure TMSSQLExec.InitParserTree;
var
  FSQLTokens1, FSQLTokens2: TSQLTokenRecord;
begin
  (*
  -- In-Memory OLTP

  Execute a natively compiled, scalar user-defined function
  [ { EXEC | EXECUTE } ]
      {
        [ @return_status = ]
        { module_name | @module_name_var }
          [ [ @parameter = ] { value
                             | @variable
                             | [ DEFAULT ]
                             }
          ]
        [ ,...n ]
        [ WITH <execute_option> [ ,...n ] ]
      }
  <execute_option>::=
  {
      | { RESULT SETS UNDEFINED }
      | { RESULT SETS NONE }
      | { RESULT SETS ( <result_sets_definition> [,...n ] ) }
  }
  *)

  FSQLTokens1:=AddSQLTokens(stKeyword, nil, 'EXEC', [toFirstToken, toFindWordLast], 0);
  FSQLTokens2:=AddSQLTokens(stKeyword, nil, 'EXECUTE', [toFirstToken, toFindWordLast], 0);
end;

procedure TMSSQLExec.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TMSSQLExec.MakeSQL;
begin
  inherited MakeSQL;
end;

constructor TMSSQLExec.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
end;

procedure TMSSQLExec.Assign(ASource: TSQLObjectAbstract);
begin
  inherited Assign(ASource);
end;

{ TMSSQLDropView }

procedure TMSSQLDropView.InitParserTree;
begin
  (*
  -- Syntax for SQL Server, Azure SQL Database, and Azure Synapse Analytics

  DROP VIEW [ IF EXISTS ] [ schema_name . ] view_name [ ...,n ] [ ; ]
  *)
end;

procedure TMSSQLDropView.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TMSSQLDropView.MakeSQL;
begin
  inherited MakeSQL;
end;

{ TMSSQLAlterView }

procedure TMSSQLAlterView.InitParserTree;
begin
  (*
  ALTER VIEW [ schema_name . ] view_name [ ( column [ ,...n ] ) ]
  [ WITH <view_attribute> [ ,...n ] ]
  AS select_statement
  [ WITH CHECK OPTION ] [ ; ]

  <view_attribute> ::=
  {
      [ ENCRYPTION ]
      [ SCHEMABINDING ]
      [ VIEW_METADATA ]
  }
  *)
end;

procedure TMSSQLAlterView.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TMSSQLAlterView.MakeSQL;
begin
  inherited MakeSQL;
end;

constructor TMSSQLAlterView.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
end;

procedure TMSSQLAlterView.Assign(ASource: TSQLObjectAbstract);
begin
  inherited Assign(ASource);
end;

{ TMSSQLCreateView }

procedure TMSSQLCreateView.InitParserTree;
var
  FSQLTokens, T: TSQLTokenRecord;
begin
  (*
  -- Syntax for SQL Server and Azure SQL Database

  CREATE [ OR ALTER ] VIEW [ schema_name . ] view_name [ (column [ ,...n ] ) ]
  [ WITH <view_attribute> [ ,...n ] ]
  AS select_statement
  [ WITH CHECK OPTION ]
  [ ; ]

  <view_attribute> ::=
  {
      [ ENCRYPTION ]
      [ SCHEMABINDING ]
      [ VIEW_METADATA ]
  }
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okView);    //CREATE VIEW
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'VIEW', [toFindWordLast], 0);
end;

procedure TMSSQLCreateView.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TMSSQLCreateView.MakeSQL;
begin
  inherited MakeSQL;
end;

destructor TMSSQLCreateView.Destroy;
begin
  inherited Destroy;
end;

constructor TMSSQLCreateView.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
end;

procedure TMSSQLCreateView.Assign(ASource: TSQLObjectAbstract);
begin
  inherited Assign(ASource);
end;

{ TMSSQLDropTable }

procedure TMSSQLDropTable.InitParserTree;
begin
  (*
  -- Syntax for SQL Server and Azure SQL Database

  DROP TABLE [ IF EXISTS ] { database_name.schema_name.table_name | schema_name.table_name | table_name } [ ,...n ]
  [ ; ]
  *)
end;

procedure TMSSQLDropTable.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TMSSQLDropTable.MakeSQL;
begin
  inherited MakeSQL;
end;

{ TMSSQLAlterTable }

procedure TMSSQLAlterTable.InitParserTree;
begin
  (*
  ALTER TABLE { database_name.schema_name.table_name | schema_name.table_name | table_name }
  {
      ALTER COLUMN column_name
      {
          [ type_schema_name. ] type_name
              [ (
                  {
                     precision [ , scale ]
                   | max
                   | xml_schema_collection
                  }
              ) ]
          [ COLLATE collation_name ]
          [ NULL | NOT NULL ] [ SPARSE ]
        | { ADD | DROP }
            { ROWGUIDCOL | PERSISTED | NOT FOR REPLICATION | SPARSE | HIDDEN }
        | { ADD | DROP } MASKED [ WITH ( FUNCTION = ' mask_function ') ]
      }
      [ WITH ( ONLINE = ON | OFF ) ]
      | [ WITH { CHECK | NOCHECK } ]

      | ADD
      {
          <column_definition>
        | <computed_column_definition>
        | <table_constraint>
        | <column_set_definition>
      } [ ,...n ]
        | [ system_start_time_column_name datetime2 GENERATED ALWAYS AS ROW START
                  [ HIDDEN ] [ NOT NULL ] [ CONSTRAINT constraint_name ]
              DEFAULT constant_expression [WITH VALUES] ,
                  system_end_time_column_name datetime2 GENERATED ALWAYS AS ROW END
                     [ HIDDEN ] [ NOT NULL ][ CONSTRAINT constraint_name ]
              DEFAULT constant_expression [WITH VALUES] ,
          ]
         PERIOD FOR SYSTEM_TIME ( system_start_time_column_name, system_end_time_column_name )
      | DROP
       [ {
           [ CONSTRAINT ][ IF EXISTS ]
           {
                constraint_name
                [ WITH
                 ( <drop_clustered_constraint_option> [ ,...n ] )
                ]
            } [ ,...n ]
            | COLUMN [ IF EXISTS ]
            {
                column_name
            } [ ,...n ]
            | PERIOD FOR SYSTEM_TIME
       } [ ,...n ]
      | [ WITH { CHECK | NOCHECK } ] { CHECK | NOCHECK } CONSTRAINT
          { ALL | constraint_name [ ,...n ] }

      | { ENABLE | DISABLE } TRIGGER
          { ALL | trigger_name [ ,...n ] }

      | { ENABLE | DISABLE } CHANGE_TRACKING
          [ WITH ( TRACK_COLUMNS_UPDATED = { ON | OFF } ) ]

      | SWITCH [ PARTITION source_partition_number_expression ]
          TO target_table
          [ PARTITION target_partition_number_expression ]
          [ WITH ( <low_priority_lock_wait> ) ]

      | SET
          (
              [ FILESTREAM_ON =
                  { partition_scheme_name | filegroup | "default" | "NULL" } ]
              | SYSTEM_VERSIONING =
                    {
                        OFF
                    | ON
                        [ ( HISTORY_TABLE = schema_name . history_table_name
                            [, DATA_CONSISTENCY_CHECK = { ON | OFF } ]
                            [, HISTORY_RETENTION_PERIOD =
                            {
                                INFINITE | number {DAY | DAYS | WEEK | WEEKS
                    | MONTH | MONTHS | YEAR | YEARS }
                            }
                            ]
                          )
                        ]
                    }
              | DATA_DELETION =
                  {
                        OFF
                      | ON
                          [(  [ FILTER_COLUMN = column_name ]
                              [, RETENTION_PERIOD = { INFINITE | number {DAY | DAYS | WEEK | WEEKS
                                      | MONTH | MONTHS | YEAR | YEARS }}]
                          )]
                     }
      | REBUILD
        [ [PARTITION = ALL]
          [ WITH ( <rebuild_option> [ ,...n ] ) ]
        | [ PARTITION = partition_number
             [ WITH ( <single_partition_rebuild_option> [ ,...n ] ) ]
          ]
        ]

      | <table_option>
      | <filetable_option>
      | <stretch_configuration>
  }
  [ ; ]

  -- ALTER TABLE options

  <column_set_definition> ::=
      column_set_name XML COLUMN_SET FOR ALL_SPARSE_COLUMNS

  <drop_clustered_constraint_option> ::=
      {
          MAXDOP = max_degree_of_parallelism
        | ONLINE = { ON | OFF }
        | MOVE TO
           { partition_scheme_name ( column_name ) | filegroup | "default" }
      }
  <table_option> ::=
      {
          SET ( LOCK_ESCALATION = { AUTO | TABLE | DISABLE } )
      }

  <filetable_option> ::=
      {
         [ { ENABLE | DISABLE } FILETABLE_NAMESPACE ]
         [ SET ( FILETABLE_DIRECTORY = directory_name ) ]
      }

  <stretch_configuration> ::=
      {
        SET (
          REMOTE_DATA_ARCHIVE
          {
              = ON (<table_stretch_options>)
            | = OFF_WITHOUT_DATA_RECOVERY ( MIGRATION_STATE = PAUSED )
            | ( <table_stretch_options> [, ...n] )
          }
              )
      }

  <table_stretch_options> ::=
      {
       [ FILTER_PREDICATE = { null | table_predicate_function } , ]
         MIGRATION_STATE = { OUTBOUND | INBOUND | PAUSED }
      }

  <single_partition_rebuild__option> ::=
  {
        SORT_IN_TEMPDB = { ON | OFF }
      | MAXDOP = max_degree_of_parallelism
      | DATA_COMPRESSION = { NONE | ROW | PAGE | COLUMNSTORE | COLUMNSTORE_ARCHIVE} }
      | ONLINE = { ON [( <low_priority_lock_wait> ) ] | OFF }
  }

  <low_priority_lock_wait>::=
  {
      WAIT_AT_LOW_PRIORITY ( MAX_DURATION = <time> [ MINUTES ],
          ABORT_AFTER_WAIT = { NONE | SELF | BLOCKERS } )
  }
  *)
end;

procedure TMSSQLAlterTable.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TMSSQLAlterTable.MakeSQL;
begin
  inherited MakeSQL;
end;

constructor TMSSQLAlterTable.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
end;

destructor TMSSQLAlterTable.Destroy;
begin
  inherited Destroy;
end;

procedure TMSSQLAlterTable.Assign(ASource: TSQLObjectAbstract);
begin
  inherited Assign(ASource);
end;

{ TMSSQLCreateTable }

procedure TMSSQLCreateTable.InitParserTree;
var
  FSQLTokens, T: TSQLTokenRecord;
begin
  (*
  -- Disk-Based CREATE TABLE Syntax
  CREATE TABLE
      { database_name.schema_name.table_name | schema_name.table_name | table_name }
      [ AS FileTable ]
      ( {   <column_definition>
          | <computed_column_definition>
          | <column_set_definition>
          | [ <table_constraint> ] [ ,... n ]
          | [ <table_index> ] }
            [ ,...n ]
            [ PERIOD FOR SYSTEM_TIME ( system_start_time_column_name
               , system_end_time_column_name ) ]
        )
      [ ON { partition_scheme_name ( partition_column_name )
             | filegroup
             | "default" } ]
      [ TEXTIMAGE_ON { filegroup | "default" } ]
      [ FILESTREAM_ON { partition_scheme_name
             | filegroup
             | "default" } ]
      [ WITH ( <table_option> [ ,...n ] ) ]
  [ ; ]

  <column_definition> ::=
  column_name <data_type>
      [ FILESTREAM ]
      [ COLLATE collation_name ]
      [ SPARSE ]
      [ MASKED WITH ( FUNCTION = ' mask_function ') ]
      [ [ CONSTRAINT constraint_name ] DEFAULT constant_expression ]
      [ IDENTITY [ ( seed,increment ) ]
      [ NOT FOR REPLICATION ]
      [ GENERATED ALWAYS AS ROW { START | END } [ HIDDEN ] ]
      [ NULL | NOT NULL ]
      [ ROWGUIDCOL ]
      [ ENCRYPTED WITH
          ( COLUMN_ENCRYPTION_KEY = key_name ,
            ENCRYPTION_TYPE = { DETERMINISTIC | RANDOMIZED } ,
            ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256'
          ) ]
      [ <column_constraint> [, ...n ] ]
      [ <column_index> ]

  <data_type> ::=
  [ type_schema_name . ] type_name
      [ ( precision [ , scale ] | max |
          [ { CONTENT | DOCUMENT } ] xml_schema_collection ) ]

  <column_constraint> ::=
  [ CONSTRAINT constraint_name ]
  {     { PRIMARY KEY | UNIQUE }
          [ CLUSTERED | NONCLUSTERED ]
          [
              WITH FILLFACTOR = fillfactor
            | WITH ( < index_option > [ , ...n ] )
          ]
          [ ON { partition_scheme_name ( partition_column_name )
              | filegroup | "default" } ]

    | [ FOREIGN KEY ]
          REFERENCES [ schema_name . ] referenced_table_name [ ( ref_column ) ]
          [ ON DELETE { NO ACTION | CASCADE | SET NULL | SET DEFAULT } ]
          [ ON UPDATE { NO ACTION | CASCADE | SET NULL | SET DEFAULT } ]
          [ NOT FOR REPLICATION ]

    | CHECK [ NOT FOR REPLICATION ] ( logical_expression )
  }

  <column_index> ::=
   INDEX index_name [ CLUSTERED | NONCLUSTERED ]
      [ WITH ( <index_option> [ ,... n ] ) ]
      [ ON { partition_scheme_name (column_name )
           | filegroup_name
           | default
           }
      ]
      [ FILESTREAM_ON { filestream_filegroup_name | partition_scheme_name | "NULL" } ]

  <computed_column_definition> ::=
  column_name AS computed_column_expression
  [ PERSISTED [ NOT NULL ] ]
  [
      [ CONSTRAINT constraint_name ]
      { PRIMARY KEY | UNIQUE }
          [ CLUSTERED | NONCLUSTERED ]
          [
              WITH FILLFACTOR = fillfactor
            | WITH ( <index_option> [ , ...n ] )
          ]
          [ ON { partition_scheme_name ( partition_column_name )
          | filegroup | "default" } ]

      | [ FOREIGN KEY ]
          REFERENCES referenced_table_name [ ( ref_column ) ]
          [ ON DELETE { NO ACTION | CASCADE } ]
          [ ON UPDATE { NO ACTION } ]
          [ NOT FOR REPLICATION ]

      | CHECK [ NOT FOR REPLICATION ] ( logical_expression )
  ]

  <column_set_definition> ::=
  column_set_name XML COLUMN_SET FOR ALL_SPARSE_COLUMNS

  < table_constraint > ::=
  [ CONSTRAINT constraint_name ]
  {
      { PRIMARY KEY | UNIQUE }
          [ CLUSTERED | NONCLUSTERED ]
          (column [ ASC | DESC ] [ ,...n ] )
          [
              WITH FILLFACTOR = fillfactor
             |WITH ( <index_option> [ , ...n ] )
          ]
          [ ON { partition_scheme_name (partition_column_name)
              | filegroup | "default" } ]
      | FOREIGN KEY
          ( column [ ,...n ] )
          REFERENCES referenced_table_name [ ( ref_column [ ,...n ] ) ]
          [ ON DELETE { NO ACTION | CASCADE | SET NULL | SET DEFAULT } ]
          [ ON UPDATE { NO ACTION | CASCADE | SET NULL | SET DEFAULT } ]
          [ NOT FOR REPLICATION ]
      | CHECK [ NOT FOR REPLICATION ] ( logical_expression )

  < table_index > ::=
  {
      {
        INDEX index_name  [ UNIQUE ] [ CLUSTERED | NONCLUSTERED ]
           (column_name [ ASC | DESC ] [ ,... n ] )
      | INDEX index_name CLUSTERED COLUMNSTORE
      | INDEX index_name [ NONCLUSTERED ] COLUMNSTORE (column_name [ ,... n ] )
      }
      [ WITH ( <index_option> [ ,... n ] ) ]
      [ ON { partition_scheme_name (column_name )
           | filegroup_name
           | default
           }
      ]
      [ FILESTREAM_ON { filestream_filegroup_name | partition_scheme_name | "NULL" } ]

  }

  <table_option> ::=
  {
      [DATA_COMPRESSION = { NONE | ROW | PAGE }
        [ ON PARTITIONS ( { <partition_number_expression> | <range> }
        [ , ...n ] ) ]]
      [ FILETABLE_DIRECTORY = <directory_name> ]
      [ FILETABLE_COLLATE_FILENAME = { <collation_name> | database_default } ]
      [ FILETABLE_PRIMARY_KEY_CONSTRAINT_NAME = <constraint_name> ]
      [ FILETABLE_STREAMID_UNIQUE_CONSTRAINT_NAME = <constraint_name> ]
      [ FILETABLE_FULLPATH_UNIQUE_CONSTRAINT_NAME = <constraint_name> ]
      [ SYSTEM_VERSIONING = ON [ ( HISTORY_TABLE = schema_name . history_table_name
          [, DATA_CONSISTENCY_CHECK = { ON | OFF } ] ) ] ]
      [ REMOTE_DATA_ARCHIVE =
        {
            ON [ ( <table_stretch_options> [,...n] ) ]
          | OFF ( MIGRATION_STATE = PAUSED )
        }
      ]
      [ DATA_DELETION = ON
            {(
               FILTER_COLUMN = column_name,
               RETENTION_PERIOD = { INFINITE | number {DAY | DAYS | WEEK | WEEKS
                                | MONTH | MONTHS | YEAR | YEARS }
          )}
       ]
  }

  <table_stretch_options> ::=
  {
      [ FILTER_PREDICATE = { null | table_predicate_function } , ]
        MIGRATION_STATE = { OUTBOUND | INBOUND | PAUSED }
   }

  <index_option> ::=
  {
      PAD_INDEX = { ON | OFF }
    | FILLFACTOR = fillfactor
    | IGNORE_DUP_KEY = { ON | OFF }
    | STATISTICS_NORECOMPUTE = { ON | OFF }
    | STATISTICS_INCREMENTAL = { ON | OFF }
    | ALLOW_ROW_LOCKS = { ON | OFF }
    | ALLOW_PAGE_LOCKS = { ON | OFF }
    | OPTIMIZE_FOR_SEQUENTIAL_KEY = { ON | OFF }
    | COMPRESSION_DELAY= {0 | delay [Minutes]}
    | DATA_COMPRESSION = { NONE | ROW | PAGE | COLUMNSTORE | COLUMNSTORE_ARCHIVE }
         [ ON PARTITIONS ( { <partition_number_expression> | <range> }
         [ , ...n ] ) ]
  }
  <range> ::=
  <partition_number_expression> TO <partition_number_expression>
  *)
  FSQLTokens:=AddSQLTokens(stKeyword, nil, 'CREATE', [toFirstToken], 0, okTable);    //CREATE TABLE
  T:=AddSQLTokens(stKeyword, FSQLTokens, 'TABLE', [toFindWordLast], 0);

end;

procedure TMSSQLCreateTable.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TMSSQLCreateTable.MakeSQL;
begin
  inherited MakeSQL;
end;

constructor TMSSQLCreateTable.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
end;

destructor TMSSQLCreateTable.Destroy;
begin
  inherited Destroy;
end;

procedure TMSSQLCreateTable.Assign(ASource: TSQLObjectAbstract);
begin
  inherited Assign(ASource);
end;

{ TPGSQLDropSchema }

procedure TMSSQLDropSchema.InitParserTree;
begin
  (*
  -- Syntax for SQL Server and Azure SQL Database

  DROP SCHEMA  [ IF EXISTS ] schema_name
  *)
end;

procedure TMSSQLDropSchema.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TMSSQLDropSchema.MakeSQL;
begin
  inherited MakeSQL;
end;

{ TMSSQLAlterSchema }

procedure TMSSQLAlterSchema.InitParserTree;
begin
  (*
  -- Syntax for SQL Server and Azure SQL Database

  ALTER SCHEMA schema_name
     TRANSFER [ <entity_type> :: ] securable_name
  [;]

  <entity_type> ::=
      {
      Object | Type | XML Schema Collection
      }

  *)
end;

procedure TMSSQLAlterSchema.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TMSSQLAlterSchema.MakeSQL;
begin
  inherited MakeSQL;
end;

constructor TMSSQLAlterSchema.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
end;

procedure TMSSQLAlterSchema.Assign(ASource: TSQLObjectAbstract);
begin
  inherited Assign(ASource);
end;

{ TMSSQLCreateSchema }

procedure TMSSQLCreateSchema.InitParserTree;
begin
  (*
  -- Syntax for SQL Server and Azure SQL Database

  CREATE SCHEMA schema_name_clause [ <schema_element> [ ...n ] ]

  <schema_name_clause> ::=
      {
      schema_name
      | AUTHORIZATION owner_name
      | schema_name AUTHORIZATION owner_name
      }

  <schema_element> ::=
      {
          table_definition | view_definition | grant_statement |
          revoke_statement | deny_statement
      }
  *)
end;

procedure TMSSQLCreateSchema.InternalProcessChildToken(ASQLParser: TSQLParser;
  AChild: TSQLTokenRecord; AWord: string);
begin
  inherited InternalProcessChildToken(ASQLParser, AChild, AWord);
end;

procedure TMSSQLCreateSchema.MakeSQL;
begin
  inherited MakeSQL;
end;

constructor TMSSQLCreateSchema.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
end;

procedure TMSSQLCreateSchema.Assign(ASource: TSQLObjectAbstract);
begin
  inherited Assign(ASource);
end;

end.


(*
ADD SENSITIVITY CLASSIFICATION TO
    <object_name> [, ...n ]
    WITH ( <sensitivity_option> [, ...n ] )

<object_name> ::=
{
    [schema_name.]table_name.column_name
}

<sensitivity_option> ::=
{
    LABEL = string |
    LABEL_ID = guidOrString |
    INFORMATION_TYPE = string |
    INFORMATION_TYPE_ID = guidOrString |
    RANK = NONE | LOW | MEDIUM | HIGH | CRITICAL
}
----------------------------------------
BULK INSERT
   { database_name.schema_name.table_or_view_name | schema_name.table_or_view_name | table_or_view_name }
      FROM 'data_file'
     [ WITH
    (
   [ [ , ] BATCHSIZE = batch_size ]
   [ [ , ] CHECK_CONSTRAINTS ]
   [ [ , ] CODEPAGE = { 'ACP' | 'OEM' | 'RAW' | 'code_page' } ]
   [ [ , ] DATAFILETYPE =
      { 'char' | 'native'| 'widechar' | 'widenative' } ]
   [ [ , ] DATA_SOURCE = 'data_source_name' ]
   [ [ , ] ERRORFILE = 'file_name' ]
   [ [ , ] ERRORFILE_DATA_SOURCE = 'data_source_name' ]
   [ [ , ] FIRSTROW = first_row ]
   [ [ , ] FIRE_TRIGGERS ]
   [ [ , ] FORMATFILE_DATA_SOURCE = 'data_source_name' ]
   [ [ , ] KEEPIDENTITY ]
   [ [ , ] KEEPNULLS ]
   [ [ , ] KILOBYTES_PER_BATCH = kilobytes_per_batch ]
   [ [ , ] LASTROW = last_row ]
   [ [ , ] MAXERRORS = max_errors ]
   [ [ , ] ORDER ( { column [ ASC | DESC ] } [ ,...n ] ) ]
   [ [ , ] ROWS_PER_BATCH = rows_per_batch ]
   [ [ , ] ROWTERMINATOR = 'row_terminator' ]
   [ [ , ] TABLOCK ]

   -- input file format options
   [ [ , ] FORMAT = 'CSV' ]
   [ [ , ] FIELDQUOTE = 'quote_characters']
   [ [ , ] FORMATFILE = 'format_file_path' ]
   [ [ , ] FIELDTERMINATOR = 'field_terminator' ]
   [ [ , ] ROWTERMINATOR = 'row_terminator' ]
    )]

----------------------------------------
-- Syntax for SQL Server and Azure SQL Database

[ WITH <common_table_expression> [ ,...n ] ]
DELETE
    [ TOP ( expression ) [ PERCENT ] ]
    [ FROM ]
    { { table_alias
      | <object>
      | rowset_function_limited
      [ WITH ( table_hint_limited [ ...n ] ) ] }
      | @table_variable
    }
    [ <OUTPUT Clause> ]
    [ FROM table_source [ ,...n ] ]
    [ WHERE { <search_condition>
            | { [ CURRENT OF
                   { { [ GLOBAL ] cursor_name }
                       | cursor_variable_name
                   }
                ]
              }
            }
    ]
    [ OPTION ( <Query Hint> [ ,...n ] ) ]
[; ]

<object> ::=
{
    [ server_name.database_name.schema_name.
      | database_name. [ schema_name ] .
      | schema_name.
    ]
    table_or_view_name
}

----------------------------------------
DISABLE TRIGGER { [ schema_name . ] trigger_name [ ,...n ] | ALL }
ON { object_name | DATABASE | ALL SERVER } [ ; ]
----------------------------------------
ENABLE TRIGGER { [ schema_name . ] trigger_name [ ,...n ] | ALL }
ON { object_name | DATABASE | ALL SERVER } [ ; ]
----------------------------------------

-- Syntax for SQL Server and Azure SQL Database

[ WITH <common_table_expression> [ ,...n ] ]
INSERT
{
        [ TOP ( expression ) [ PERCENT ] ]
        [ INTO ]
        { <object> | rowset_function_limited
          [ WITH ( <Table_Hint_Limited> [ ...n ] ) ]
        }
    {
        [ ( column_list ) ]
        [ <OUTPUT Clause> ]
        { VALUES ( { DEFAULT | NULL | expression } [ ,...n ] ) [ ,...n     ]
        | derived_table
        | execute_statement
        | <dml_table_source>
        | DEFAULT VALUES
        }
    }
}
[;]

<object> ::=
{
    [ server_name . database_name . schema_name .
      | database_name .[ schema_name ] .
      | schema_name .
    ]
  table_or_view_name
}

<dml_table_source> ::=
    SELECT <select_list>
    FROM ( <dml_statement_with_output_clause> )
      [AS] table_alias [ ( column_alias [ ,...n ] ) ]
    [ WHERE <search_condition> ]
        [ OPTION ( <query_hint> [ ,...n ] ) ]
----------------------------------------

-- Syntax for SQL Server and Azure SQL Database

[ WITH <common_table_expression> [...n] ]
UPDATE
    [ TOP ( expression ) [ PERCENT ] ]
    { { table_alias | <object> | rowset_function_limited
         [ WITH ( <Table_Hint_Limited> [ ...n ] ) ]
      }
      | @table_variable
    }
    SET
        { column_name = { expression | DEFAULT | NULL }
          | { udt_column_name.{ { property_name = expression
                                | field_name = expression }
                                | method_name ( argument [ ,...n ] )
                              }
          }
          | column_name { .WRITE ( expression , @Offset , @Length ) }
          | @variable = expression
          | @variable = column = expression
          | column_name { += | -= | *= | /= | %= | &= | ^= | |= } expression
          | @variable { += | -= | *= | /= | %= | &= | ^= | |= } expression
          | @variable = column { += | -= | *= | /= | %= | &= | ^= | |= } expression
        } [ ,...n ]

    [ <OUTPUT Clause> ]
    [ FROM{ <table_source> } [ ,...n ] ]
    [ WHERE { <search_condition>
            | { [ CURRENT OF
                  { { [ GLOBAL ] cursor_name }
                      | cursor_variable_name
                  }
                ]
              }
            }
    ]
    [ OPTION ( <query_hint> [ ,...n ] ) ]
[ ; ]

<object> ::=
{
    [ server_name . database_name . schema_name .
    | database_name .[ schema_name ] .
    | schema_name .
    ]
    table_or_view_name}
----------------------------------------

-- SQL Server and Azure SQL Database
[ WITH <common_table_expression> [,...n] ]
MERGE
    [ TOP ( expression ) [ PERCENT ] ]
    [ INTO ] <target_table> [ WITH ( <merge_hint> ) ] [ [ AS ] table_alias ]
    USING <table_source> [ [ AS ] table_alias ]
    ON <merge_search_condition>
    [ WHEN MATCHED [ AND <clause_search_condition> ]
        THEN <merge_matched> ] [ ...n ]
    [ WHEN NOT MATCHED [ BY TARGET ] [ AND <clause_search_condition> ]
        THEN <merge_not_matched> ]
    [ WHEN NOT MATCHED BY SOURCE [ AND <clause_search_condition> ]
        THEN <merge_matched> ] [ ...n ]
    [ <output_clause> ]
    [ OPTION ( <query_hint> [ ,...n ] ) ]
;

<target_table> ::=
{
    [ database_name . schema_name . | schema_name . ]
  target_table
}

<merge_hint>::=
{
    { [ <table_hint_limited> [ ,...n ] ]
    [ [ , ] INDEX ( index_val [ ,...n ] ) ] }
}

<merge_search_condition> ::=
    <search_condition>

<merge_matched>::=
    { UPDATE SET <set_clause> | DELETE }

<merge_not_matched>::=
{
    INSERT [ ( column_list ) ]
        { VALUES ( values_list )
        | DEFAULT VALUES }
}

<clause_search_condition> ::=
    <search_condition>


----------------------------------------

-- Syntax for SQL Server and Azure SQL Database

TRUNCATE TABLE
    { database_name.schema_name.table_name | schema_name.table_name | table_name }
    [ WITH ( PARTITIONS ( { <partition_number_expression> | <range> }
    [ , ...n ] ) ) ]
[ ; ]

<range> ::=
<partition_number_expression> TO <partition_number_expression>
----------------------------------------
-- Syntax for SQL Server and Azure SQL Database

UPDATE STATISTICS table_or_indexed_view_name
    [
        {
            { index_or_statistics__name }
          | ( { index_or_statistics_name } [ ,...n ] )
                }
    ]
    [    WITH
        [
            FULLSCAN
              [ [ , ] PERSIST_SAMPLE_PERCENT = { ON | OFF } ]
            | SAMPLE number { PERCENT | ROWS }
              [ [ , ] PERSIST_SAMPLE_PERCENT = { ON | OFF } ]
            | RESAMPLE
              [ ON PARTITIONS ( { <partition_number> | <range> } [, ...n] ) ]
            | <update_stats_stream_option> [ ,...n ]
        ]
        [ [ , ] [ ALL | COLUMNS | INDEX ]
        [ [ , ] NORECOMPUTE ]
        [ [ , ] INCREMENTAL = { ON | OFF } ]
        [ [ , ] MAXDOP = max_degree_of_parallelism ]
    ] ;

<update_stats_stream_option> ::=
    [ STATS_STREAM = stats_stream ]
    [ ROWCOUNT = numeric_constant ]
    [ PAGECOUNT = numeric_contant ]
----------------------------------------
ALTER APPLICATION ROLE application_role_name
    WITH <set_item> [ ,...n ]

<set_item> ::=
    NAME = new_application_role_name
    | PASSWORD = 'password'
    | DEFAULT_SCHEMA = schema_name

----------------------------------------
ALTER ASSEMBLY assembly_name
    [ FROM <client_assembly_specifier> | <assembly_bits> ]
    [ WITH <assembly_option> [ ,...n ] ]
    [ DROP FILE { file_name [ ,...n ] | ALL } ]
    [ ADD FILE FROM
    {
        client_file_specifier [ AS file_name ]
      | file_bits AS file_name
    } [,...n ]
    ] [ ; ]
<client_assembly_specifier> :: =
    '\\computer_name\share-name\[path\]manifest_file_name'
  | '[local_path\]manifest_file_name'

<assembly_bits> :: =
    { varbinary_literal | varbinary_expression }

<assembly_option> :: =
    PERMISSION_SET = { SAFE | EXTERNAL_ACCESS | UNSAFE }
  | VISIBILITY = { ON | OFF }
  | UNCHECKED DATA
----------------------------------------
ALTER ASYMMETRIC KEY Asym_Key_Name <alter_option>

<alter_option> ::=
      <password_change_option>
    | REMOVE PRIVATE KEY

<password_change_option> ::=
    WITH PRIVATE KEY ( <password_option> [ , <password_option> ] )

<password_option> ::=
      ENCRYPTION BY PASSWORD = 'strongPassword'
    | DECRYPTION BY PASSWORD = 'oldPassword'
----------------------------------------
-- Syntax for SQL Server
ALTER AUTHORIZATION
   ON [ <class_type>:: ] entity_name
   TO { principal_name | SCHEMA OWNER }
[;]

<class_type> ::=
    {
        OBJECT | ASSEMBLY | ASYMMETRIC KEY | AVAILABILITY GROUP | CERTIFICATE
      | CONTRACT | TYPE | DATABASE | ENDPOINT | FULLTEXT CATALOG
      | FULLTEXT STOPLIST | MESSAGE TYPE | REMOTE SERVICE BINDING
      | ROLE | ROUTE | SCHEMA | SEARCH PROPERTY LIST | SERVER ROLE
      | SERVICE | SYMMETRIC KEY | XML SCHEMA COLLECTION
    }

----------------------------------------
ALTER AVAILABILITY GROUP group_name
  {
     SET ( <set_option_spec> )
   | ADD DATABASE database_name
   | REMOVE DATABASE database_name
   | ADD REPLICA ON <add_replica_spec>
   | MODIFY REPLICA ON <modify_replica_spec>
   | REMOVE REPLICA ON <server_instance>
   | JOIN
   | JOIN AVAILABILITY GROUP ON <add_availability_group_spec> [ ,...2 ]
   | MODIFY AVAILABILITY GROUP ON <modify_availability_group_spec> [ ,...2 ]
   | GRANT CREATE ANY DATABASE
   | DENY CREATE ANY DATABASE
   | FAILOVER
   | FORCE_FAILOVER_ALLOW_DATA_LOSS
   | ADD LISTENER 'dns_name' ( <add_listener_option> )
   | MODIFY LISTENER 'dns_name' ( <modify_listener_option> )
   | RESTART LISTENER 'dns_name'
   | REMOVE LISTENER 'dns_name'
   | OFFLINE
  }
[ ; ]

<set_option_spec> ::=
    AUTOMATED_BACKUP_PREFERENCE = { PRIMARY | SECONDARY_ONLY| SECONDARY | NONE }
  | FAILURE_CONDITION_LEVEL  = { 1 | 2 | 3 | 4 | 5 }
  | HEALTH_CHECK_TIMEOUT = milliseconds
  | DB_FAILOVER  = { ON | OFF }
  | DTC_SUPPORT  = { PER_DB | NONE }
  | REQUIRED_SYNCHRONIZED_SECONDARIES_TO_COMMIT = { integer }

<server_instance> ::=
 { 'system_name[\instance_name]' | 'FCI_network_name[\instance_name]' }

<add_replica_spec>::=
  <server_instance> WITH
    (
       ENDPOINT_URL = 'TCP://system-address:port',
       AVAILABILITY_MODE = { SYNCHRONOUS_COMMIT | ASYNCHRONOUS_COMMIT | CONFIGURATION_ONLY },
       FAILOVER_MODE = { AUTOMATIC | MANUAL }
       [ , <add_replica_option> [ ,...n ] ]
    )

  <add_replica_option>::=
       SEEDING_MODE = { AUTOMATIC | MANUAL }
     | BACKUP_PRIORITY = n
     | SECONDARY_ROLE ( {
            [ ALLOW_CONNECTIONS = { NO | READ_ONLY | ALL } ]
        [,] [ READ_ONLY_ROUTING_URL = 'TCP://system-address:port' ]
     } )
     | PRIMARY_ROLE ( {
            [ ALLOW_CONNECTIONS = { READ_WRITE | ALL } ]
        [,] [ READ_ONLY_ROUTING_LIST = { ( '<server_instance>' [ ,...n ] ) | NONE } ]
        [,] [ READ_WRITE_ROUTING_URL = { ( '<server_instance>' ) ]
     } )
     | SESSION_TIMEOUT = integer

<modify_replica_spec>::=
  <server_instance> WITH
    (
       ENDPOINT_URL = 'TCP://system-address:port'
     | AVAILABILITY_MODE = { SYNCHRONOUS_COMMIT | ASYNCHRONOUS_COMMIT }
     | FAILOVER_MODE = { AUTOMATIC | MANUAL }
     | SEEDING_MODE = { AUTOMATIC | MANUAL }
     | BACKUP_PRIORITY = n
     | SECONDARY_ROLE ( {
          ALLOW_CONNECTIONS = { NO | READ_ONLY | ALL }
        | READ_ONLY_ROUTING_URL = 'TCP://system-address:port'
          } )
     | PRIMARY_ROLE ( {
          ALLOW_CONNECTIONS = { READ_WRITE | ALL }
        | READ_ONLY_ROUTING_LIST = { ( '<server_instance>' [ ,...n ] ) | NONE }
          } )
     | SESSION_TIMEOUT = seconds
    )

<add_availability_group_spec>::=
 <ag_name> WITH
    (
       LISTENER_URL = 'TCP://system-address:port',
       AVAILABILITY_MODE = { SYNCHRONOUS_COMMIT | ASYNCHRONOUS_COMMIT },
       FAILOVER_MODE = MANUAL,
       SEEDING_MODE = { AUTOMATIC | MANUAL }
    )

<modify_availability_group_spec>::=
 <ag_name> WITH
    (
       LISTENER = 'TCP://system-address:port'
       | AVAILABILITY_MODE = { SYNCHRONOUS_COMMIT | ASYNCHRONOUS_COMMIT }
       | SEEDING_MODE = { AUTOMATIC | MANUAL }
    )

<add_listener_option> ::=
   {
      WITH DHCP [ ON ( <network_subnet_option> ) ]
    | WITH IP ( { ( <ip_address_option> ) } [ , ...n ] ) [ , PORT = listener_port ]
   }

  <network_subnet_option> ::=
     'ipv4_address', 'ipv4_mask'

  <ip_address_option> ::=
     {
        'four_part_ipv4_address', 'four_part_ipv4_mask'
      | 'ipv6_address'
     }

<modify_listener_option>::=
    {
       ADD IP ( <ip_address_option> )
     | PORT = listener_port
    }
----------------------------------------
ALTER BROKER PRIORITY ConversationPriorityName
FOR CONVERSATION
{ SET ( [ CONTRACT_NAME = {ContractName | ANY } ]
        [ [ , ] LOCAL_SERVICE_NAME = {LocalServiceName | ANY } ]
        [ [ , ] REMOTE_SERVICE_NAME = {'RemoteServiceName' | ANY } ]
        [ [ , ] PRIORITY_LEVEL = { PriorityValue | DEFAULT } ]
              )
}
[;]
----------------------------------------
-- Syntax for SQL Server and Azure SQL Database

ALTER CERTIFICATE certificate_name
      REMOVE PRIVATE KEY
    | WITH PRIVATE KEY ( <private_key_spec> )
    | WITH ACTIVE FOR BEGIN_DIALOG = { ON | OFF }

<private_key_spec> ::=
      {
        { FILE = 'path_to_private_key' | BINARY = private_key_bits }
         [ , DECRYPTION BY PASSWORD = 'current_password' ]
         [ , ENCRYPTION BY PASSWORD = 'new_password' ]
      }
    |
      {
         [ DECRYPTION BY PASSWORD = 'current_password' ]
         [ [ , ] ENCRYPTION BY PASSWORD = 'new_password' ]
      }
----------------------------------------
ALTER COLUMN ENCRYPTION KEY key_name
    [ ADD | DROP ] VALUE
    (
        COLUMN_MASTER_KEY = column_master_key_name
        [, ALGORITHM = 'algorithm_name' , ENCRYPTED_VALUE =  varbinary_literal ]
    ) [;]

----------------------------------------
ALTER CREDENTIAL credential_name WITH IDENTITY = 'identity_name'
    [ , SECRET = 'secret' ]
----------------------------------------

ALTER CRYPTOGRAPHIC PROVIDER provider_name
    [ FROM FILE = path_of_DLL ]
    ENABLE | DISABLE
----------------------------------------

-- SQL Server Syntax
ALTER DATABASE { database_name | CURRENT }
{
    MODIFY NAME = new_database_name
  | COLLATE collation_name
  | <file_and_filegroup_options>
  | SET <option_spec> [ ,...n ] [ WITH <termination> ]
}
[;]

<file_and_filegroup_options>::=
  <add_or_modify_files>::=
  <filespec>::=
  <add_or_modify_filegroups>::=
  <filegroup_updatability_option>::=

<option_spec>::=
{
  | <auto_option>
  | <change_tracking_option>
  | <cursor_option>
  | <database_mirroring_option>
  | <date_correlation_optimization_option>
  | <db_encryption_option>
  | <db_state_option>
  | <db_update_option>
  | <db_user_access_option><delayed_durability_option>
  | <external_access_option>
  | <FILESTREAM_options>
  | <HADR_options>
  | <parameterization_option>
  | <query_store_options>
  | <recovery_option>
  | <service_broker_option>
  | <snapshot_option>
  | <sql_option>
  | <termination>
  | <temporal_history_retention>
  | <data_retention_policy>
  | <compatibility_level>
      { 150 | 140 | 130 | 120 | 110 | 100 | 90 }
}
----------------------------------------

ALTER DATABASE AUDIT SPECIFICATION audit_specification_name
{
    [ FOR SERVER AUDIT audit_name ]
    [ { { ADD | DROP } (
           { <audit_action_specification> | audit_action_group_name }
                )
      } [, ...n] ]
    [ WITH ( STATE = { ON | OFF } ) ]
}
[ ; ]
<audit_action_specification>::=
{
      <action_specification>[ ,...n ] ON [ class :: ] securable
     BY principal [ ,...n ]
}
----------------------------------------
ALTER DATABASE database_name
SET COMPATIBILITY_LEVEL = { 150 | 140 | 130 | 120 | 110 | 100 | 90 }
----------------------------------------
ALTER DATABASE database_name
SET { <partner_option> | <witness_option> }
  <partner_option> ::=
    PARTNER { = 'partner_server'
            | FAILOVER
            | FORCE_SERVICE_ALLOW_DATA_LOSS
            | OFF
            | RESUME
            | SAFETY { FULL | OFF }
            | SUSPEND
            | TIMEOUT integer
            }
  <witness_option> ::=
    WITNESS { = 'witness_server'
            | OFF
            }
----------------------------------------
-- Syntax for SQL Server

ALTER DATABASE ENCRYPTION KEY
      REGENERATE WITH ALGORITHM = { AES_128 | AES_192 | AES_256 | TRIPLE_DES_3KEY }
   |
   ENCRYPTION BY SERVER
    {
        CERTIFICATE Encryptor_Name |
        ASYMMETRIC KEY Encryptor_Name
    }
[ ; ]
----------------------------------------
ALTER DATABASE database_name
{
    <add_or_modify_files>
  | <add_or_modify_filegroups>
}

<add_or_modify_files>::=
{
    ADD FILE <filespec> [ ,...n ]
        [ TO FILEGROUP { filegroup_name } ]
  | ADD LOG FILE <filespec> [ ,...n ]
  | REMOVE FILE logical_file_name
  | MODIFY FILE <filespec>
}

<filespec>::=
(
    NAME = logical_file_name
    [ , NEWNAME = new_logical_name ]
    [ , FILENAME = {'os_file_name' | 'filestream_path' | 'memory_optimized_data_path' } ]
    [ , SIZE = size [ KB | MB | GB | TB ] ]
    [ , MAXSIZE = { max_size [ KB | MB | GB | TB ] | UNLIMITED } ]
    [ , FILEGROWTH = growth_increment [ KB | MB | GB | TB| % ] ]
    [ , OFFLINE ]
)

<add_or_modify_filegroups>::=
{
    | ADD FILEGROUP filegroup_name
        [ CONTAINS FILESTREAM | CONTAINS MEMORY_OPTIMIZED_DATA ]
    | REMOVE FILEGROUP filegroup_name
    | MODIFY FILEGROUP filegroup_name
        { <filegroup_updatability_option>
        | DEFAULT
        | NAME = new_filegroup_name
        | { AUTOGROW_SINGLE_FILE | AUTOGROW_ALL_FILES }
        }
}
<filegroup_updatability_option>::=
{
    { READONLY | READWRITE }
    | { READ_ONLY | READ_WRITE }
}
----------------------------------------
ALTER DATABASE database_name
   SET HADR
   {
        { AVAILABILITY GROUP = group_name | OFF }
   | { SUSPEND | RESUME }
   }
[;]
----------------------------------------
-- Syntax for SQL Server and Azure SQL Database

ALTER DATABASE SCOPED CONFIGURATION
{
    { [ FOR SECONDARY] SET <set_options>}
}
| CLEAR PROCEDURE_CACHE [plan_handle]
| SET < set_options >
[;]

< set_options > ::=
{
    MAXDOP = { <value> | PRIMARY}
    | LEGACY_CARDINALITY_ESTIMATION = { ON | OFF | PRIMARY}
    | PARAMETER_SNIFFING = { ON | OFF | PRIMARY}
    | QUERY_OPTIMIZER_HOTFIXES = { ON | OFF | PRIMARY}
    | IDENTITY_CACHE = { ON | OFF }
    | INTERLEAVED_EXECUTION_TVF = { ON | OFF }
    | BATCH_MODE_MEMORY_GRANT_FEEDBACK = { ON | OFF }
    | BATCH_MODE_ADAPTIVE_JOINS = { ON | OFF }
    | TSQL_SCALAR_UDF_INLINING = { ON | OFF }
    | ELEVATE_ONLINE = { OFF | WHEN_SUPPORTED | FAIL_UNSUPPORTED }
    | ELEVATE_RESUMABLE = { OFF | WHEN_SUPPORTED | FAIL_UNSUPPORTED }
    | OPTIMIZE_FOR_AD_HOC_WORKLOADS = { ON | OFF }
    | XTP_PROCEDURE_EXECUTION_STATISTICS = { ON | OFF }
    | XTP_QUERY_EXECUTION_STATISTICS = { ON | OFF }
    | ROW_MODE_MEMORY_GRANT_FEEDBACK = { ON | OFF }
    | BATCH_MODE_ON_ROWSTORE = { ON | OFF }
    | DEFERRED_COMPILATION_TV = { ON | OFF }
    | ACCELERATED_PLAN_FORCING = { ON | OFF }
    | GLOBAL_TEMPORARY_TABLE_AUTO_DROP = { ON | OFF }
    | LIGHTWEIGHT_QUERY_PROFILING = { ON | OFF }
    | VERBOSE_TRUNCATION_WARNINGS = { ON | OFF }
    | LAST_QUERY_PLAN_STATS = { ON | OFF }
    | PAUSED_RESUMABLE_INDEX_ABORT_DURATION_MINUTES = <time>
    | ISOLATE_SECURITY_POLICY_CARDINALITY  = { ON | OFF }
    | ASYNC_STATS_UPDATE_WAIT_AT_LOW_PRIORITY = { ON | OFF }
}
----------------------------------------
ALTER DATABASE { database_name | CURRENT }
SET
{
    <option_spec> [ ,...n ] [ WITH <termination> ]
}

<option_spec> ::=
{
    <accelerated_database_recovery>
  | <auto_option>
  | <automatic_tuning_option>
  | <change_tracking_option>
  | <containment_option>
  | <cursor_option>
  | <database_mirroring_option>
  | <date_correlation_optimization_option>
  | <db_encryption_option>
  | <db_state_option>
  | <db_update_option>
  | <db_user_access_option>
  | <delayed_durability_option>
  | <external_access_option>
  | FILESTREAM ( <FILESTREAM_option> )
  | <HADR_options>
  | <mixed_page_allocation_option>
  | <parameterization_option>
  | <query_store_options>
  | <recovery_option>
  | <remote_data_archive_option>
  | <service_broker_option>
  | <snapshot_option>
  | <sql_option>
  | <target_recovery_time_option>
  | <termination>
  | <temporal_history_retention>
  | <data_retention_policy>
}
;

<accelerated_database_recovery> ::=
{
    ACCELERATED_DATABASE_RECOVERY = { ON | OFF }
     [ ( PERSISTENT_VERSION_STORE_FILEGROUP = { filegroup name } ) ];
}

<auto_option> ::=
{
    AUTO_CLOSE { ON | OFF }
  | AUTO_CREATE_STATISTICS { OFF | ON [ ( INCREMENTAL = { ON | OFF } ) ] }
  | AUTO_SHRINK { ON | OFF }
  | AUTO_UPDATE_STATISTICS { ON | OFF }
  | AUTO_UPDATE_STATISTICS_ASYNC { ON | OFF }
}

<automatic_tuning_option> ::=
{
    AUTOMATIC_TUNING ( FORCE_LAST_GOOD_PLAN = { ON | OFF } )
}

<change_tracking_option> ::=
{
    CHANGE_TRACKING
   {
       = OFF
     | = ON [ ( <change_tracking_option_list > [,...n] ) ]
     | ( <change_tracking_option_list> [,...n] )
   }
}

<change_tracking_option_list> ::=
{
   AUTO_CLEANUP = { ON | OFF }
 | CHANGE_RETENTION = retention_period { DAYS | HOURS | MINUTES }
}

<containment_option> ::=
   CONTAINMENT = { NONE | PARTIAL }

<cursor_option> ::=
{
    CURSOR_CLOSE_ON_COMMIT { ON | OFF }
  | CURSOR_DEFAULT { LOCAL | GLOBAL }
}

<database_mirroring_option>
  ALTER DATABASE Database Mirroring

<date_correlation_optimization_option> ::=
    DATE_CORRELATION_OPTIMIZATION { ON | OFF }

<db_encryption_option> ::=
    ENCRYPTION { ON | OFF | SUSPEND | RESUME }

<db_state_option> ::=
    { ONLINE | OFFLINE | EMERGENCY }

<db_update_option> ::=
    { READ_ONLY | READ_WRITE }

<db_user_access_option> ::=
    { SINGLE_USER | RESTRICTED_USER | MULTI_USER }

<delayed_durability_option> ::=
    DELAYED_DURABILITY = { DISABLED | ALLOWED | FORCED }

<external_access_option> ::=
{
    DB_CHAINING { ON | OFF }
  | TRUSTWORTHY { ON | OFF }
  | DEFAULT_FULLTEXT_LANGUAGE = { <lcid> | <language name> | <language alias> }
  | DEFAULT_LANGUAGE = { <lcid> | <language name> | <language alias> }
  | NESTED_TRIGGERS = { OFF | ON }
  | TRANSFORM_NOISE_WORDS = { OFF | ON }
  | TWO_DIGIT_YEAR_CUTOFF = { 1753, ..., 2049, ..., 9999 }
}

<FILESTREAM_option> ::=
{
    NON_TRANSACTED_ACCESS = { OFF | READ_ONLY | FULL
  | DIRECTORY_NAME = <directory_name>
}

<HADR_options> ::=
    ALTER DATABASE SET HADR

<mixed_page_allocation_option> ::=
    MIXED_PAGE_ALLOCATION { OFF | ON }

<parameterization_option> ::=
    PARAMETERIZATION { SIMPLE | FORCED }

<query_store_options> ::=
{
    QUERY_STORE
    {
          = OFF [ ( FORCED ) ]
        | = ON [ ( <query_store_option_list> [,...n] ) ]
        | ( < query_store_option_list> [,...n] )
        | CLEAR [ ALL ]
    }
}

<query_store_option_list> ::=
{
      OPERATION_MODE = { READ_WRITE | READ_ONLY }
    | CLEANUP_POLICY = ( STALE_QUERY_THRESHOLD_DAYS = number )
    | DATA_FLUSH_INTERVAL_SECONDS = number
    | MAX_STORAGE_SIZE_MB = number
    | INTERVAL_LENGTH_MINUTES = number
    | SIZE_BASED_CLEANUP_MODE = { AUTO | OFF }
    | QUERY_CAPTURE_MODE = { ALL | AUTO | CUSTOM | NONE }
    | MAX_PLANS_PER_QUERY = number
    | WAIT_STATS_CAPTURE_MODE = { ON | OFF }
    | QUERY_CAPTURE_POLICY = ( <query_capture_policy_option_list> [,...n] )
}

<query_capture_policy_option_list> :: =
{
      STALE_CAPTURE_POLICY_THRESHOLD = number { DAYS | HOURS }
    | EXECUTION_COUNT = number
    | TOTAL_COMPILE_CPU_TIME_MS = number
    | TOTAL_EXECUTION_CPU_TIME_MS = number
}

<recovery_option> ::=
{
    RECOVERY { FULL | BULK_LOGGED | SIMPLE }
  | TORN_PAGE_DETECTION { ON | OFF }
  | PAGE_VERIFY { CHECKSUM | TORN_PAGE_DETECTION | NONE }
}

<remote_data_archive_option> ::=
{
    REMOTE_DATA_ARCHIVE =
    {
        ON ( SERVER = <server_name> ,
             {
                  CREDENTIAL = <db_scoped_credential_name>
                  | FEDERATED_SERVICE_ACCOUNT = ON | OFF
             }
        )
        | OFF
    }
}

<service_broker_option> ::=
{
    ENABLE_BROKER
  | DISABLE_BROKER
  | NEW_BROKER
  | ERROR_BROKER_CONVERSATIONS
  | HONOR_BROKER_PRIORITY { ON | OFF}
}

<snapshot_option> ::=
{
    ALLOW_SNAPSHOT_ISOLATION { ON | OFF }
  | READ_COMMITTED_SNAPSHOT { ON | OFF }
  | MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = { ON | OFF }
}
<sql_option> ::=
{
    ANSI_NULL_DEFAULT { ON | OFF }
  | ANSI_NULLS { ON | OFF }
  | ANSI_PADDING { ON | OFF }
  | ANSI_WARNINGS { ON | OFF }
  | ARITHABORT { ON | OFF }
  | COMPATIBILITY_LEVEL = { 150 | 140 | 130 | 120 | 110 | 100 }
  | CONCAT_NULL_YIELDS_NULL { ON | OFF }
  | NUMERIC_ROUNDABORT { ON | OFF }
  | QUOTED_IDENTIFIER { ON | OFF }
  | RECURSIVE_TRIGGERS { ON | OFF }
}

<target_recovery_time_option> ::=
    TARGET_RECOVERY_TIME = target_recovery_time { SECONDS | MINUTES }

<termination>::=
{
    ROLLBACK AFTER number [ SECONDS ]
  | ROLLBACK IMMEDIATE
  | NO_WAIT
}

<temporal_history_retention> ::=
    TEMPORAL_HISTORY_RETENTION { ON | OFF }

<data_retention_policy> ::=
    DATA_RETENTION { ON | OFF }
----------------------------------------
ALTER ENDPOINT endPointName [ AUTHORIZATION login ]
[ STATE = { STARTED | STOPPED | DISABLED } ]
[ AS { TCP } ( <protocol_specific_items> ) ]
[ FOR { TSQL | SERVICE_BROKER | DATABASE_MIRRORING } (
   <language_specific_items>
        ) ]

<AS TCP_protocol_specific_arguments> ::=
AS TCP (
  LISTENER_PORT = listenerPort
  [ [ , ] LISTENER_IP = ALL | ( 4-part-ip ) | ( "ip_address_v6" ) ]
)
<FOR SERVICE_BROKER_language_specific_arguments> ::=
FOR SERVICE_BROKER (
   [ AUTHENTICATION = {
      WINDOWS [ { NTLM | KERBEROS | NEGOTIATE } ]
      | CERTIFICATE certificate_name
      | WINDOWS [ { NTLM | KERBEROS | NEGOTIATE } ] CERTIFICATE certificate_name
      | CERTIFICATE certificate_name WINDOWS [ { NTLM | KERBEROS | NEGOTIATE } ]
    } ]
   [ , ENCRYPTION = { DISABLED
       |
         {{SUPPORTED | REQUIRED }
       [ ALGORITHM { RC4 | AES | AES RC4 | RC4 AES } ] }
   ]

  [ , MESSAGE_FORWARDING = {ENABLED | DISABLED} ]
  [ , MESSAGE_FORWARD_SIZE = forwardSize
)

<FOR DATABASE_MIRRORING_language_specific_arguments> ::=
FOR DATABASE_MIRRORING (
   [ AUTHENTICATION = {
      WINDOWS [ { NTLM | KERBEROS | NEGOTIATE } ]
      | CERTIFICATE certificate_name
      | WINDOWS [ { NTLM | KERBEROS | NEGOTIATE } ] CERTIFICATE certificate_name
      | CERTIFICATE certificate_name WINDOWS [ { NTLM | KERBEROS | NEGOTIATE } ]
    } ]
   [ , ENCRYPTION = { DISABLED
       |
         {{SUPPORTED | REQUIRED }
       [ ALGORITHM { RC4 | AES | AES RC4 | RC4 AES } ] }
    ]
   [ , ] ROLE = { WITNESS | PARTNER | ALL }
)
----------------------------------------
ALTER EVENT SESSION event_session_name
ON SERVER
{
    [ [ {  <add_drop_event> [ ,...n] }
       | { <add_drop_event_target> [ ,...n ] } ]
    [ WITH ( <event_session_options> [ ,...n ] ) ]
    ]
    | [ STATE = { START | STOP } ]
}

<add_drop_event>::=
{
    [ ADD EVENT <event_specifier>
         [ ( {
                 [ SET { event_customizable_attribute = <value> [ ,...n ] } ]
                 [ ACTION ( { [event_module_guid].event_package_name.action_name [ ,...n ] } ) ]
                 [ WHERE <predicate_expression> ]
        } ) ]
   ]
   | DROP EVENT <event_specifier> }

<event_specifier> ::=
{
[event_module_guid].event_package_name.event_name
}

<predicate_expression> ::=
{
    [ NOT ] <predicate_factor> | {( <predicate_expression> ) }
    [ { AND | OR } [ NOT ] { <predicate_factor> | ( <predicate_expression> ) } ]
    [ ,...n ]
}

<predicate_factor>::=
{
    <predicate_leaf> | ( <predicate_expression> )
}

<predicate_leaf>::=
{
      <predicate_source_declaration> { = | < > | ! = | > | > = | < | < = } <value>
    | [event_module_guid].event_package_name.predicate_compare_name ( <predicate_source_declaration>, <value> )
}

<predicate_source_declaration>::=
{
    event_field_name | ( [event_module_guid].event_package_name.predicate_source_name )
}

<value>::=
{
    number | 'string'
}

<add_drop_event_target>::=
{
    ADD TARGET <event_target_specifier>
        [ ( SET { target_parameter_name = <value> [ ,...n] } ) ]
    | DROP TARGET <event_target_specifier>
}

<event_target_specifier>::=
{
    [event_module_guid].event_package_name.target_name
}

<event_session_options>::=
{
    [    MAX_MEMORY = size [ KB | MB] ]
    [ [,] EVENT_RETENTION_MODE = { ALLOW_SINGLE_EVENT_LOSS | ALLOW_MULTIPLE_EVENT_LOSS | NO_EVENT_LOSS } ]
    [ [,] MAX_DISPATCH_LATENCY = { seconds SECONDS | INFINITE } ]
    [ [,] MAX_EVENT_SIZE = size [ KB | MB ] ]
    [ [,] MEMORY_PARTITION_MODE = { NONE | PER_NODE | PER_CPU } ]
    [ [,] TRACK_CAUSALITY = { ON | OFF } ]
    [ [,] STARTUP_STATE = { ON | OFF } ]
}
----------------------------------------
-- Modify an external data source
-- Applies to: SQL Server (2016 or later) and APS
ALTER EXTERNAL DATA SOURCE data_source_name SET
    {
        LOCATION = '<prefix>://<path>[:<port>]' [,] |
        RESOURCE_MANAGER_LOCATION = <'IP address;Port'> [,] |
        CREDENTIAL = credential_name
    }
    [;]

-- Modify an external data source pointing to Azure Blob storage
-- Applies to: SQL Server (starting with 2017)
ALTER EXTERNAL DATA SOURCE data_source_name
    SET
        LOCATION = 'https://storage_account_name.blob.core.windows.net'
        [, CREDENTIAL = credential_name ]

-- Modify an external data source pointing to Azure Blob storage or Azure Data Lake storage
-- Applies to: Azure Synapse Analytics
ALTER EXTERNAL DATA SOURCE data_source_name
    SET
        [LOCATION = '<location prefix>://<location path>']
        [, CREDENTIAL = credential_name ]
----------------------------------------
ALTER EXTERNAL LANGUAGE language_name
[ AUTHORIZATION owner_name ]
{
    SET <file_spec>
    | ADD <file_spec>
    | REMOVE <file_spec>
}
[ ; ]

<file_spec> ::=
{
    ( CONTENT = {<external_lang_specifier> | <content_bits>,
    FILE_NAME = <external_lang_file_name>
    [, PLATFORM = <platform> ]
    [, PARAMETERS = <external_lang_parameters> ]
    [, ENVIRONMENT_VARIABLES = <external_lang_env_variables> ] )
}

<external_lang_specifier> :: =
{
    '[file_path\]os_file_name'
}

<content_bits> :: =
{
    varbinary_literal
   | varbinary_expression
}

<external_lang_file_name> :: =
'extension_file_name'

<platform> :: =
{
   WINDOWS
  | LINUX
}

< external_lang_parameters > :: =
'extension_specific_parameters'
----------------------------------------
ALTER EXTERNAL LIBRARY library_name
[ AUTHORIZATION owner_name ]
SET <file_spec>
WITH ( LANGUAGE = <language> )
[ ; ]

<file_spec> ::=
{
    (CONTENT = { <client_library_specifier> | <library_bits> | NONE}
    [, PLATFORM = <platform> )
}

<client_library_specifier> :: =
{
      '[\\computer_name\]share_name\[path\]manifest_file_name'
    | '[local_path\]manifest_file_name'
    | '<relative_path_in_external_data_source>'
}

<library_bits> :: =
{
      varbinary_literal
    | varbinary_expression
}

<platform> :: =
{
      WINDOWS
    | LINUX
}

<language> :: =
{
      'R'
    | 'Python'
    | <external_language>
}
----------------------------------------
ALTER EXTERNAL RESOURCE POOL { pool_name | "default" }
[ WITH (
    [ MAX_CPU_PERCENT = value ]
    [ [ , ] MAX_MEMORY_PERCENT = value ]
    [ [ , ] MAX_PROCESSES = value ]
    )
]
[ ; ]

<CPU_range_spec> ::=
{ CPU_ID | CPU_ID  TO CPU_ID } [ ,...n ]
----------------------------------------

ALTER FULLTEXT CATALOG catalog_name
{ REBUILD [ WITH ACCENT_SENSITIVITY = { ON | OFF } ]
| REORGANIZE
| AS DEFAULT
}
----------------------------------------
ALTER FULLTEXT INDEX ON table_name
   { ENABLE
   | DISABLE
   | SET CHANGE_TRACKING [ = ] { MANUAL | AUTO | OFF }
   | ADD ( column_name
           [ TYPE COLUMN type_column_name ]
           [ LANGUAGE language_term ]
           [ STATISTICAL_SEMANTICS ]
           [,...n]
         )
     [ WITH NO POPULATION ]
   | ALTER COLUMN column_name
     { ADD | DROP } STATISTICAL_SEMANTICS
     [ WITH NO POPULATION ]
   | DROP ( column_name [,...n] )
     [ WITH NO POPULATION ]
   | START { FULL | INCREMENTAL | UPDATE } POPULATION
   | {STOP | PAUSE | RESUME } POPULATION
   | SET STOPLIST [ = ] { OFF| SYSTEM | stoplist_name }
     [ WITH NO POPULATION ]
   | SET SEARCH PROPERTY LIST [ = ] { OFF | property_list_name }
     [ WITH NO POPULATION ]
   }
[;]
----------------------------------------

ALTER FULLTEXT STOPLIST stoplist_name
{
        ADD [N] 'stopword' LANGUAGE language_term
  | DROP
    {
        'stopword' LANGUAGE language_term
      | ALL LANGUAGE language_term
      | ALL
     }
;

----------------------------------------
-- Transact-SQL Scalar Function Syntax
ALTER FUNCTION [ schema_name. ] function_name
( [ { @parameter_name [ AS ][ type_schema_name. ] parameter_data_type
    [ = default ] }
    [ ,...n ]
  ]
)
RETURNS return_data_type
    [ WITH <function_option> [ ,...n ] ]
    [ AS ]
    BEGIN
        function_body
        RETURN scalar_expression
    END
[ ; ]
----------------------------------------

-- Syntax for SQL Server and Azure SQL Database

ALTER INDEX { index_name | ALL } ON <object>
{
      REBUILD {
            [ PARTITION = ALL ] [ WITH ( <rebuild_index_option> [ ,...n ] ) ]
          | [ PARTITION = partition_number [ WITH ( <single_partition_rebuild_index_option> ) [ ,...n ] ]
      }
    | DISABLE
    | REORGANIZE  [ PARTITION = partition_number ] [ WITH ( <reorganize_option>  ) ]
    | SET ( <set_index_option> [ ,...n ] )
    | RESUME [WITH (<resumable_index_options>,[...n])]
    | PAUSE
    | ABORT
}
[ ; ]

<object> ::=
{
    { database_name.schema_name.table_or_view_name | schema_name.table_or_view_name | table_or_view_name }
}

<rebuild_index_option > ::=
{
      PAD_INDEX = { ON | OFF }
    | FILLFACTOR = fillfactor
    | SORT_IN_TEMPDB = { ON | OFF }
    | IGNORE_DUP_KEY = { ON | OFF }
    | STATISTICS_NORECOMPUTE = { ON | OFF }
    | STATISTICS_INCREMENTAL = { ON | OFF }
    | ONLINE = {
          ON [ ( <low_priority_lock_wait> ) ]
        | OFF }
    | RESUMABLE = { ON | OFF }
    | MAX_DURATION = <time> [MINUTES}
    | ALLOW_ROW_LOCKS = { ON | OFF }
    | ALLOW_PAGE_LOCKS = { ON | OFF }
    | MAXDOP = max_degree_of_parallelism
    | DATA_COMPRESSION = { NONE | ROW | PAGE | COLUMNSTORE | COLUMNSTORE_ARCHIVE }
        [ ON PARTITIONS ( {<partition_number> [ TO <partition_number>] } [ , ...n ] ) ]
}

<single_partition_rebuild_index_option> ::=
{
      SORT_IN_TEMPDB = { ON | OFF }
    | MAXDOP = max_degree_of_parallelism
    | RESUMABLE = { ON | OFF }
    | MAX_DURATION = <time> [MINUTES}
    | DATA_COMPRESSION = { NONE | ROW | PAGE | COLUMNSTORE | COLUMNSTORE_ARCHIVE } }
    | ONLINE = { ON [ ( <low_priority_lock_wait> ) ] | OFF }
}

<reorganize_option>::=
{
       LOB_COMPACTION = { ON | OFF }
    |  COMPRESS_ALL_ROW_GROUPS =  { ON | OFF}
}

<set_index_option>::=
{
      ALLOW_ROW_LOCKS = { ON | OFF }
    | ALLOW_PAGE_LOCKS = { ON | OFF }
    | OPTIMIZE_FOR_SEQUENTIAL_KEY = { ON | OFF }
    | IGNORE_DUP_KEY = { ON | OFF }
    | STATISTICS_NORECOMPUTE = { ON | OFF }
    | COMPRESSION_DELAY= { 0 | delay [Minutes] }
}

<resumable_index_option> ::=
 {
    MAXDOP = max_degree_of_parallelism
    | MAX_DURATION =<time> [MINUTES]
    | <low_priority_lock_wait>
 }

<low_priority_lock_wait>::=
{
    WAIT_AT_LOW_PRIORITY ( MAX_DURATION = <time> [ MINUTES ] ,
                          ABORT_AFTER_WAIT = { NONE | SELF | BLOCKERS } )
}


----------------------------------------

ALTER INDEX index_name
    ON <table_object>
    [WITH XMLNAMESPACES ( <xmlnamespace_list> )]
    FOR ( <promoted_node_path_action_list> )
    [WITH ( <index_options> )]

<table_object> ::=
{ database_name.schema_name.table_name | schema_name.table_name | table_name }
<promoted_node_path_action_list> ::=
<promoted_node_path_action_item> [, <promoted_node_path_action_list>]

<promoted_node_path_action_item>::=
<add_node_path_item_action> | <remove_node_path_item_action>

<add_node_path_item_action> ::=
ADD <path_name> = <promoted_node_path_item>

<promoted_node_path_item>::=
<xquery_node_path_item> | <sql_values_node_path_item>

<remove_node_path_item_action> ::= REMOVE <path_name>

<path_name_or_typed_node_path>::=
<path_name> | <typed_node_path>

<typed_node_path> ::=
<node_path> [[AS XQUERY <xsd_type_ext>] | [AS SQL <sql_type>]]

<xquery_node_path_item> ::=
<node_path> [AS XQUERY <xsd_type_or_node_hint>] [SINGLETON]

<xsd_type_or_node_hint> ::=
[<xsd_type>] [MAXLENGTH(x)] | 'node()'

<sql_values_node_path_item> ::=
<node_path> AS SQL <sql_type> [SINGLETON]

<node_path> ::=
character_string_literal

<xsd_type_ext> ::=
character_string_literal

<sql_type> ::=
identifier

<path_name> ::=
identifier

<xmlnamespace_list> ::=
<xmlnamespace_item> [, <xmlnamespace_list>]

<xmlnamespace_item> ::=
<xmlnamespace_uri> AS <xmlnamespace_prefix>

<xml_namespace_uri> ::= character_string_literal
<xml_namespace_prefix> ::= identifier

<index_options> ::=
(
  | PAD_INDEX  = { ON | OFF }
  | FILLFACTOR = fillfactor
  | SORT_IN_TEMPDB = { ON | OFF }
  | IGNORE_DUP_KEY =OFF
  | DROP_EXISTING = { ON | OFF }
  | ONLINE =OFF
  | ALLOW_ROW_LOCKS = { ON | OFF }
  | ALLOW_PAGE_LOCKS = { ON | OFF }
  | MAXDOP = max_degree_of_parallelism
)
----------------------------------------
-- Syntax for SQL Server

ALTER LOGIN login_name
    {
    <status_option>
    | WITH <set_option> [ ,... ]
    | <cryptographic_credential_option>
    }
[;]

<status_option> ::=
        ENABLE | DISABLE

<set_option> ::=
    PASSWORD = 'password' | hashed_password HASHED
    [
      OLD_PASSWORD = 'oldpassword'
      | <password_option> [<password_option> ]
    ]
    | DEFAULT_DATABASE = database
    | DEFAULT_LANGUAGE = language
    | NAME = login_name
    | CHECK_POLICY = { ON | OFF }
    | CHECK_EXPIRATION = { ON | OFF }
    | CREDENTIAL = credential_name
    | NO CREDENTIAL

<password_option> ::=
    MUST_CHANGE | UNLOCK

<cryptographic_credentials_option> ::=
    ADD CREDENTIAL credential_name
  | DROP CREDENTIAL credential_name
----------------------------------------
-- Syntax for SQL Server

ALTER MASTER KEY <alter_option>

<alter_option> ::=
    <regenerate_option> | <encryption_option>

<regenerate_option> ::=
    [ FORCE ] REGENERATE WITH ENCRYPTION BY PASSWORD = 'password'

<encryption_option> ::=
    ADD ENCRYPTION BY { SERVICE MASTER KEY | PASSWORD = 'password' }
    |
    DROP ENCRYPTION BY { SERVICE MASTER KEY | PASSWORD = 'password' }
----------------------------------------
ALTER MESSAGE TYPE message_type_name
   VALIDATION =
    {  NONE
     | EMPTY
     | WELL_FORMED_XML
     | VALID_XML WITH SCHEMA COLLECTION schema_collection_name }
[ ; ]
----------------------------------------
ALTER PARTITION FUNCTION partition_function_name()
{
    SPLIT RANGE ( boundary_value )
  | MERGE RANGE ( boundary_value )
} [ ; ]
----------------------------------------
ALTER PARTITION SCHEME partition_scheme_name
NEXT USED [ filegroup_name ] [ ; ]
----------------------------------------
-- Syntax for SQL Server and Azure SQL Database

ALTER { PROC | PROCEDURE } [schema_name.] procedure_name [ ; number ]
    [ { @parameter [ type_schema_name. ] data_type }
        [ VARYING ] [ = default ] [ OUT | OUTPUT ] [READONLY]
    ] [ ,...n ]
[ WITH <procedure_option> [ ,...n ] ]
[ FOR REPLICATION ]
AS { [ BEGIN ] sql_statement [;] [ ...n ] [ END ] }
[;]

<procedure_option> ::=
    [ ENCRYPTION ]
    [ RECOMPILE ]
    [ EXECUTE AS Clause ]
----------------------------------------
ALTER QUEUE <object>
   queue_settings
   | queue_action
[ ; ]

<object> : :=
{ database_name.schema_name.queue_name | schema_name.queue_name | queue_name }

<queue_settings> : :=
WITH
   [ STATUS = { ON | OFF } [ , ] ]
   [ RETENTION = { ON | OFF } [ , ] ]
   [ ACTIVATION (
       { [ STATUS = { ON | OFF } [ , ] ]
         [ PROCEDURE_NAME = <procedure> [ , ] ]
         [ MAX_QUEUE_READERS = max_readers [ , ] ]
         [ EXECUTE AS { SELF | 'user_name'  | OWNER } ]
       |  DROP }
          ) [ , ]]
         [ POISON_MESSAGE_HANDLING (
          STATUS = { ON | OFF } )
         ]

<queue_action> : :=
   REBUILD [ WITH <query_rebuild_options> ]
   | REORGANIZE [ WITH (LOB_COMPACTION = { ON | OFF } ) ]
   | MOVE TO { file_group | "default" }

<procedure> : :=
{ database_name.schema_name.stored_procedure_name | schema_name.stored_procedure_name | stored_procedure_name }

<queue_rebuild_options> : :=
{
   ( MAXDOP = max_degree_of_parallelism )
}
----------------------------------------
ALTER REMOTE SERVICE BINDING binding_name
   WITH [ USER = <user_name> ] [ , ANONYMOUS = { ON | OFF } ]
[ ; ]
----------------------------------------
ALTER RESOURCE GOVERNOR
      { DISABLE | RECONFIGURE }
    | WITH ( CLASSIFIER_FUNCTION = { schema_name.function_name | NULL } )
    | RESET STATISTICS
    | WITH ( MAX_OUTSTANDING_IO_PER_VOLUME = value )
[ ; ]
----------------------------------------

ALTER RESOURCE POOL { pool_name | "default" }
[WITH
    ( [ MIN_CPU_PERCENT = value ]
    [ [ , ] MAX_CPU_PERCENT = value ]
    [ [ , ] CAP_CPU_PERCENT = value ]
    [ [ , ] AFFINITY {
                        SCHEDULER = AUTO
                      | ( <scheduler_range_spec> )
                      | NUMANODE = ( <NUMA_node_range_spec> )
                      }]
    [ [ , ] MIN_MEMORY_PERCENT = value ]
    [ [ , ] MAX_MEMORY_PERCENT = value ]
    [ [ , ] MIN_IOPS_PER_VOLUME = value ]
    [ [ , ] MAX_IOPS_PER_VOLUME = value ]
)]
[;]

<scheduler_range_spec> ::=
{SCHED_ID | SCHED_ID TO SCHED_ID}[,...n]

<NUMA_node_range_spec> ::=
{NUMA_node_ID | NUMA_node_ID TO NUMA_node_ID}[,...n]


----------------------------------------

-- Syntax for SQL Server (starting with 2012) and Azure SQL Database

ALTER ROLE  role_name
{
       ADD MEMBER database_principal
    |  DROP MEMBER database_principal
    |  WITH NAME = new_name
}
[;]


----------------------------------------
ALTER ROUTE route_name
WITH
  [ SERVICE_NAME = 'service_name' [ , ] ]
  [ BROKER_INSTANCE = 'broker_instance' [ , ] ]
  [ LIFETIME = route_lifetime [ , ] ]
  [ ADDRESS =  'next_hop_address' [ , ] ]
  [ MIRROR_ADDRESS = 'next_hop_mirror_address' ]
[ ; ]
----------------------------------------
ALTER SEARCH PROPERTY LIST list_name
{
   ADD 'property_name'
     WITH
      (
          PROPERTY_SET_GUID = 'property_set_guid'
        , PROPERTY_INT_ID = property_int_id
      [ , PROPERTY_DESCRIPTION = 'property_description' ]
      )
 | DROP 'property_name'
}
;
----------------------------------------
ALTER SECURITY POLICY schema_name.security_policy_name
    (
        { ADD { FILTER | BLOCK } PREDICATE tvf_schema_name.security_predicate_function_name
           ( { column_name | arguments } [ , ...n ] ) ON table_schema_name.table_name
           [ <block_dml_operation> ]  }
        | { ALTER { FILTER | BLOCK } PREDICATE tvf_schema_name.new_security_predicate_function_name
             ( { column_name | arguments } [ , ...n ] ) ON table_schema_name.table_name
           [ <block_dml_operation> ] }
        | { DROP { FILTER | BLOCK } PREDICATE ON table_schema_name.table_name }
        | [ <additional_add_alter_drop_predicate_statements> [ , ...n ] ]
    )    [ WITH ( STATE = { ON | OFF } ) ]
    [ NOT FOR REPLICATION ]
[;]

<block_dml_operation>
    [ { AFTER { INSERT | UPDATE } }
    | { BEFORE { UPDATE | DELETE } } ]
----------------------------------------
ALTER SEQUENCE [schema_name. ] sequence_name
    [ RESTART [ WITH <constant> ] ]
    [ INCREMENT BY <constant> ]
    [ { MINVALUE <constant> } | { NO MINVALUE } ]
    [ { MAXVALUE <constant> } | { NO MAXVALUE } ]
    [ CYCLE | { NO CYCLE } ]
    [ { CACHE [ <constant> ] } | { NO CACHE } ]
    [ ; ]
----------------------------------------
ALTER SERVER AUDIT audit_name
{
    [ TO { { FILE ( <file_options> [, ...n] ) } | APPLICATION_LOG | SECURITY_LOG } | URL]
    [ WITH ( <audit_options> [ , ...n] ) ]
    [ WHERE <predicate_expression> ]
}
| REMOVE WHERE
| MODIFY NAME = new_audit_name
[ ; ]

<file_options>::=
{
      FILEPATH = 'os_file_path'
    | MAXSIZE = { max_size { MB | GB | TB } | UNLIMITED }
    | MAX_ROLLOVER_FILES = { integer | UNLIMITED }
    | MAX_FILES = integer
    | RESERVE_DISK_SPACE = { ON | OFF }
}

<audit_options>::=
{
      QUEUE_DELAY = integer
    | ON_FAILURE = { CONTINUE | SHUTDOWN | FAIL_OPERATION }
    | STATE = = { ON | OFF }
}

<predicate_expression>::=
{
    [NOT ] <predicate_factor>
    [ { AND | OR } [NOT ] { <predicate_factor> } ]
    [,...n ]
}

<predicate_factor>::=
    event_field_name { = | < > | ! = | > | > = | < | < = } { number | ' string ' }
----------------------------------------
ALTER SERVER AUDIT SPECIFICATION audit_specification_name
{
    [ FOR SERVER AUDIT audit_name ]
    [ { { ADD | DROP } ( audit_action_group_name )
      } [, ...n] ]
    [ WITH ( STATE = { ON | OFF } ) ]
}
[ ; ]
----------------------------------------

ALTER SERVER CONFIGURATION
SET <optionspec>
[;]

<optionspec> ::=
{
     <process_affinity>
   | <diagnostic_log>
   | <failover_cluster_property>
   | <hadr_cluster_context>
   | <buffer_pool_extension>
   | <soft_numa>
   | <memory_optimized>
}

<process_affinity> ::=
   PROCESS AFFINITY
   {
     CPU = { AUTO | <CPU_range_spec> }
   | NUMANODE = <NUMA_node_range_spec>
   }
   <CPU_range_spec> ::=
      { CPU_ID | CPU_ID  TO CPU_ID } [ ,...n ]

   <NUMA_node_range_spec> ::=
      { NUMA_node_ID | NUMA_node_ID TO NUMA_node_ID } [ ,...n ]

<diagnostic_log> ::=
   DIAGNOSTICS LOG
   {
     ON
   | OFF
   | PATH = { 'os_file_path' | DEFAULT }
   | MAX_SIZE = { 'log_max_size' MB | DEFAULT }
   | MAX_FILES = { 'max_file_count' | DEFAULT }
   }

<failover_cluster_property> ::=
   FAILOVER CLUSTER PROPERTY <resource_property>
   <resource_property> ::=
      {
        VerboseLogging = { 'logging_detail' | DEFAULT }
      | SqlDumperDumpFlags = { 'dump_file_type' | DEFAULT }
      | SqlDumperDumpPath = { 'os_file_path'| DEFAULT }
      | SqlDumperDumpTimeOut = { 'dump_time-out' | DEFAULT }
      | FailureConditionLevel = { 'failure_condition_level' | DEFAULT }
      | HealthCheckTimeout = { 'health_check_time-out' | DEFAULT }
      }

<hadr_cluster_context> ::=
   HADR CLUSTER CONTEXT = { 'remote_windows_cluster' | LOCAL }

<buffer_pool_extension>::=
    BUFFER POOL EXTENSION
    { ON ( FILENAME = 'os_file_path_and_name' , SIZE = <size_spec> )
    | OFF }

    <size_spec> ::=
        { size [ KB | MB | GB ] }

<soft_numa> ::=
    SOFTNUMA
    { ON | OFF }

<memory-optimized> ::=
   MEMORY_OPTIMIZED
   {
     ON
   | OFF
   | [ TEMPDB_METADATA = { ON [(RESOURCE_POOL='resource_pool_name')] | OFF }
   | [ HYBRID_BUFFER_POOL = { ON | OFF }
   }
----------------------------------------
-- Syntax for SQL Server

ALTER SERVER ROLE server_role_name
{
    [ ADD MEMBER server_principal ]
  | [ DROP MEMBER server_principal ]
  | [ WITH NAME = new_server_role_name ]
} [ ; ]
----------------------------------------

ALTER SERVICE service_name
   [ ON QUEUE [ schema_name . ]queue_name ]
   [ ( < opt_arg > [ , ...n ] ) ]
[ ; ]

<opt_arg> ::=
   ADD CONTRACT contract_name | DROP CONTRACT contract_name
----------------------------------------
ALTER SERVICE MASTER KEY
    [ { <regenerate_option> | <recover_option> } ] [;]

<regenerate_option> ::=
    [ FORCE ] REGENERATE

<recover_option> ::=
    { WITH OLD_ACCOUNT = 'account_name' , OLD_PASSWORD = 'password' }
    |
    { WITH NEW_ACCOUNT = 'account_name' , NEW_PASSWORD = 'password' }
----------------------------------------
ALTER SYMMETRIC KEY Key_name <alter_option>

<alter_option> ::=
   ADD ENCRYPTION BY <encrypting_mechanism> [ , ... n ]
   |
   DROP ENCRYPTION BY <encrypting_mechanism> [ , ... n ]
<encrypting_mechanism> ::=
   CERTIFICATE certificate_name
   |
   PASSWORD = 'password'
   |
   SYMMETRIC KEY Symmetric_Key_Name
   |
   ASYMMETRIC KEY Asym_Key_Name
----------------------------------------

ALTER TABLE { database_name.schema_name.table_name | schema_name.table_name | table_name }
{
    ALTER COLUMN column_name
    {
        [ type_schema_name. ] type_name
            [ (
                {
                   precision [ , scale ]
                 | max
                 | xml_schema_collection
                }
            ) ]
        [ COLLATE collation_name ]
        [ NULL | NOT NULL ] [ SPARSE ]
      | { ADD | DROP }
          { ROWGUIDCOL | PERSISTED | NOT FOR REPLICATION | SPARSE | HIDDEN }
      | { ADD | DROP } MASKED [ WITH ( FUNCTION = ' mask_function ') ]
    }
    [ WITH ( ONLINE = ON | OFF ) ]
    | [ WITH { CHECK | NOCHECK } ]

    | ADD
    {
        <column_definition>
      | <computed_column_definition>
      | <table_constraint>
      | <column_set_definition>
    } [ ,...n ]
      | [ system_start_time_column_name datetime2 GENERATED ALWAYS AS ROW START
                [ HIDDEN ] [ NOT NULL ] [ CONSTRAINT constraint_name ]
            DEFAULT constant_expression [WITH VALUES] ,
                system_end_time_column_name datetime2 GENERATED ALWAYS AS ROW END
                   [ HIDDEN ] [ NOT NULL ][ CONSTRAINT constraint_name ]
            DEFAULT constant_expression [WITH VALUES] ,
        ]
       PERIOD FOR SYSTEM_TIME ( system_start_time_column_name, system_end_time_column_name )
    | DROP
     [ {
         [ CONSTRAINT ][ IF EXISTS ]
         {
              constraint_name
              [ WITH
               ( <drop_clustered_constraint_option> [ ,...n ] )
              ]
          } [ ,...n ]
          | COLUMN [ IF EXISTS ]
          {
              column_name
          } [ ,...n ]
          | PERIOD FOR SYSTEM_TIME
     } [ ,...n ]
    | [ WITH { CHECK | NOCHECK } ] { CHECK | NOCHECK } CONSTRAINT
        { ALL | constraint_name [ ,...n ] }

    | { ENABLE | DISABLE } TRIGGER
        { ALL | trigger_name [ ,...n ] }

    | { ENABLE | DISABLE } CHANGE_TRACKING
        [ WITH ( TRACK_COLUMNS_UPDATED = { ON | OFF } ) ]

    | SWITCH [ PARTITION source_partition_number_expression ]
        TO target_table
        [ PARTITION target_partition_number_expression ]
        [ WITH ( <low_priority_lock_wait> ) ]

    | SET
        (
            [ FILESTREAM_ON =
                { partition_scheme_name | filegroup | "default" | "NULL" } ]
            | SYSTEM_VERSIONING =
                  {
                      OFF
                  | ON
                      [ ( HISTORY_TABLE = schema_name . history_table_name
                          [, DATA_CONSISTENCY_CHECK = { ON | OFF } ]
                          [, HISTORY_RETENTION_PERIOD =
                          {
                              INFINITE | number {DAY | DAYS | WEEK | WEEKS
                  | MONTH | MONTHS | YEAR | YEARS }
                          }
                          ]
                        )
                      ]
                  }
            | DATA_DELETION =
                {
                      OFF
                    | ON
                        [(  [ FILTER_COLUMN = column_name ]
                            [, RETENTION_PERIOD = { INFINITE | number {DAY | DAYS | WEEK | WEEKS
                                    | MONTH | MONTHS | YEAR | YEARS }}]
                        )]
                   }
    | REBUILD
      [ [PARTITION = ALL]
        [ WITH ( <rebuild_option> [ ,...n ] ) ]
      | [ PARTITION = partition_number
           [ WITH ( <single_partition_rebuild_option> [ ,...n ] ) ]
        ]
      ]

    | <table_option>
    | <filetable_option>
    | <stretch_configuration>
}
[ ; ]

-- ALTER TABLE options

<column_set_definition> ::=
    column_set_name XML COLUMN_SET FOR ALL_SPARSE_COLUMNS

<drop_clustered_constraint_option> ::=
    {
        MAXDOP = max_degree_of_parallelism
      | ONLINE = { ON | OFF }
      | MOVE TO
         { partition_scheme_name ( column_name ) | filegroup | "default" }
    }
<table_option> ::=
    {
        SET ( LOCK_ESCALATION = { AUTO | TABLE | DISABLE } )
    }

<filetable_option> ::=
    {
       [ { ENABLE | DISABLE } FILETABLE_NAMESPACE ]
       [ SET ( FILETABLE_DIRECTORY = directory_name ) ]
    }

<stretch_configuration> ::=
    {
      SET (
        REMOTE_DATA_ARCHIVE
        {
            = ON (<table_stretch_options>)
          | = OFF_WITHOUT_DATA_RECOVERY ( MIGRATION_STATE = PAUSED )
          | ( <table_stretch_options> [, ...n] )
        }
            )
    }

<table_stretch_options> ::=
    {
     [ FILTER_PREDICATE = { null | table_predicate_function } , ]
       MIGRATION_STATE = { OUTBOUND | INBOUND | PAUSED }
    }

<single_partition_rebuild__option> ::=
{
      SORT_IN_TEMPDB = { ON | OFF }
    | MAXDOP = max_degree_of_parallelism
    | DATA_COMPRESSION = { NONE | ROW | PAGE | COLUMNSTORE | COLUMNSTORE_ARCHIVE} }
    | ONLINE = { ON [( <low_priority_lock_wait> ) ] | OFF }
}

<low_priority_lock_wait>::=
{
    WAIT_AT_LOW_PRIORITY ( MAX_DURATION = <time> [ MINUTES ],
        ABORT_AFTER_WAIT = { NONE | SELF | BLOCKERS } )
}
----------------------------------------

[ CONSTRAINT constraint_name ]
{
    [ NULL | NOT NULL ]
    { PRIMARY KEY | UNIQUE }
        [ CLUSTERED | NONCLUSTERED ]
        [ WITH FILLFACTOR = fillfactor ]
        [ WITH ( index_option [, ...n ] ) ]
        [ ON { partition_scheme_name (partition_column_name)
            | filegroup | "default" } ]
    | [ FOREIGN KEY ]
        REFERENCES [ schema_name . ] referenced_table_name
            [ ( ref_column ) ]
        [ ON DELETE { NO ACTION | CASCADE | SET NULL | SET DEFAULT } ]
        [ ON UPDATE { NO ACTION | CASCADE | SET NULL | SET DEFAULT } ]
        [ NOT FOR REPLICATION ]
    | CHECK [ NOT FOR REPLICATION ] ( logical_expression )
}
----------------------------------------

column_name <data_type>
[ FILESTREAM ]
[ COLLATE collation_name ]
[ NULL | NOT NULL ]
[
    [ CONSTRAINT constraint_name ] DEFAULT constant_expression [ WITH VALUES ]
    | IDENTITY [ ( seed , increment ) ] [ NOT FOR REPLICATION ]
]
[ ROWGUIDCOL ]
[ SPARSE ]
[ ENCRYPTED WITH
  ( COLUMN_ENCRYPTION_KEY = key_name ,
      ENCRYPTION_TYPE = { DETERMINISTIC | RANDOMIZED } ,
      ALGORITHM =  'AEAD_AES_256_CBC_HMAC_SHA_256'
  ) ]
[ MASKED WITH ( FUNCTION = ' mask_function ') ]
[ <column_constraint> [ ...n ] ]

<data type> ::=
[ type_schema_name . ] type_name
    [ ( precision [ , scale ] | max |
        [ { CONTENT | DOCUMENT } ] xml_schema_collection ) ]

<column_constraint> ::=
[ CONSTRAINT constraint_name ]
{     { PRIMARY KEY | UNIQUE }
        [ CLUSTERED | NONCLUSTERED ]
        [
            WITH FILLFACTOR = fillfactor
          | WITH ( < index_option > [ , ...n ] )
        ]
        [ ON { partition_scheme_name ( partition_column_name )
            | filegroup | "default" } ]
  | [ FOREIGN KEY ]
        REFERENCES [ schema_name . ] referenced_table_name [ ( ref_column ) ]
        [ ON DELETE { NO ACTION | CASCADE | SET NULL | SET DEFAULT } ]
        [ ON UPDATE { NO ACTION | CASCADE | SET NULL | SET DEFAULT } ]
        [ NOT FOR REPLICATION ]
  | CHECK [ NOT FOR REPLICATION ] ( logical_expression )
}
----------------------------------------

column_name AS computed_column_expression
[ PERSISTED [ NOT NULL ] ]
[
    [ CONSTRAINT constraint_name ]
    { PRIMARY KEY | UNIQUE }
        [ CLUSTERED | NONCLUSTERED ]
        [ WITH FILLFACTOR = fillfactor ]
        [ WITH ( <index_option> [, ...n ] ) ]
        [ ON { partition_scheme_name ( partition_column_name ) | filegroup
            | "default" } ]
    | [ FOREIGN KEY ]
        REFERENCES ref_table [ ( ref_column ) ]
        [ ON DELETE { NO ACTION | CASCADE } ]
        [ ON UPDATE { NO ACTION } ]
        [ NOT FOR REPLICATION ]
    | CHECK [ NOT FOR REPLICATION ] ( logical_expression )
]
----------------------------------------
{
    PAD_INDEX = { ON | OFF }
  | FILLFACTOR = fillfactor
  | IGNORE_DUP_KEY = { ON | OFF }
  | STATISTICS_NORECOMPUTE = { ON | OFF }
  | ALLOW_ROW_LOCKS = { ON | OFF }
  | ALLOW_PAGE_LOCKS = { ON | OFF }
  | OPTIMIZE_FOR_SEQUENTIAL_KEY = { ON | OFF }
  | SORT_IN_TEMPDB = { ON | OFF }
  | ONLINE = { ON | OFF }
  | MAXDOP = max_degree_of_parallelism
  | DATA_COMPRESSION = { NONE |ROW | PAGE | COLUMNSTORE | COLUMNSTORE_ARCHIVE }
      [ ON PARTITIONS ( { <partition_number_expression> | <range> }
      [ , ...n ] ) ]
  | ONLINE = { ON [ ( <low_priority_lock_wait> ) ] | OFF }
}

<range> ::=
<partition_number_expression> TO <partition_number_expression>

<single_partition_rebuild__option> ::=
{
    SORT_IN_TEMPDB = { ON | OFF }
  | MAXDOP = max_degree_of_parallelism
  | DATA_COMPRESSION = {NONE | ROW | PAGE | COLUMNSTORE | COLUMNSTORE_ARCHIVE } }
  | ONLINE = { ON [ ( <low_priority_lock_wait> ) ] | OFF }
}

<low_priority_lock_wait>::=
{
    WAIT_AT_LOW_PRIORITY ( MAX_DURATION = <time> [ MINUTES ] ,
                           ABORT_AFTER_WAIT = { NONE | SELF | BLOCKERS } )
}


----------------------------------------
[ CONSTRAINT constraint_name ]
{
    { PRIMARY KEY | UNIQUE }
        [ CLUSTERED | NONCLUSTERED ]
        (column [ ASC | DESC ] [ ,...n ] )
        [ WITH FILLFACTOR = fillfactor
        [ WITH ( <index_option>[ , ...n ] ) ]
        [ ON { partition_scheme_name ( partition_column_name ... )
          | filegroup | "default" } ]
    | FOREIGN KEY
        ( column [ ,...n ] )
        REFERENCES referenced_table_name [ ( ref_column [ ,...n ] ) ]
        [ ON DELETE { NO ACTION | CASCADE | SET NULL | SET DEFAULT } ]
        [ ON UPDATE { NO ACTION | CASCADE | SET NULL | SET DEFAULT } ]
        [ NOT FOR REPLICATION ]
    | CONNECTION
        ( { node_table TO node_table }
          [ , {node_table TO node_table }]
          [ , ...n ]
        )
        [ ON DELETE { NO ACTION | CASCADE } ]
    | DEFAULT constant_expression FOR column [ WITH VALUES ]
    | CHECK [ NOT FOR REPLICATION ] ( logical_expression )
}
----------------------------------------
-- SQL Server Syntax
-- Trigger on an INSERT, UPDATE, or DELETE statement to a table or view (DML Trigger)

ALTER TRIGGER schema_name.trigger_name
ON  ( table | view )
[ WITH <dml_trigger_option> [ ,...n ] ]
 ( FOR | AFTER | INSTEAD OF )
{ [ DELETE ] [ , ] [ INSERT ] [ , ] [ UPDATE ] }
[ NOT FOR REPLICATION ]
AS { sql_statement [ ; ] [ ...n ] | EXTERNAL NAME <method specifier>
[ ; ] }

<dml_trigger_option> ::=
    [ ENCRYPTION ]
    [ <EXECUTE AS Clause> ]

<method_specifier> ::=
    assembly_name.class_name.method_name

-- Trigger on an INSERT, UPDATE, or DELETE statement to a table
-- (DML Trigger on memory-optimized tables)

ALTER TRIGGER schema_name.trigger_name
ON  ( table  )
[ WITH <dml_trigger_option> [ ,...n ] ]
 ( FOR | AFTER )
{ [ DELETE ] [ , ] [ INSERT ] [ , ] [ UPDATE ] }
AS { sql_statement [ ; ] [ ...n ] }

<dml_trigger_option> ::=
    [ NATIVE_COMPILATION ]
    [ SCHEMABINDING ]
    [ <EXECUTE AS Clause> ]

-- Trigger on a CREATE, ALTER, DROP, GRANT, DENY, REVOKE,
-- or UPDATE statement (DDL Trigger)

ALTER TRIGGER trigger_name
ON { DATABASE | ALL SERVER }
[ WITH <ddl_trigger_option> [ ,...n ] ]
{ FOR | AFTER } { event_type [ ,...n ] | event_group }
AS { sql_statement [ ; ] | EXTERNAL NAME <method specifier>
[ ; ] }
}

<ddl_trigger_option> ::=
    [ ENCRYPTION ]
    [ <EXECUTE AS Clause> ]

<method_specifier> ::=
    assembly_name.class_name.method_name

-- Trigger on a LOGON event (Logon Trigger)

ALTER TRIGGER trigger_name
ON ALL SERVER
[ WITH <logon_trigger_option> [ ,...n ] ]
{ FOR| AFTER } LOGON
AS { sql_statement  [ ; ] [ ,...n ] | EXTERNAL NAME < method specifier >
  [ ; ] }

<logon_trigger_option> ::=
    [ ENCRYPTION ]
    [ EXECUTE AS Clause ]

<method_specifier> ::=
    assembly_name.class_name.method_name
----------------------------------------

-- Syntax for SQL Server

ALTER USER userName
 WITH <set_item> [ ,...n ]
[;]

<set_item> ::=
NAME = newUserName
| DEFAULT_SCHEMA = { schemaName | NULL }
| LOGIN = loginName
| PASSWORD = 'password' [ OLD_PASSWORD = 'oldpassword' ]
| DEFAULT_LANGUAGE = { NONE | <lcid> | <language name> | <language alias> }
| ALLOW_ENCRYPTED_VALUE_MODIFICATIONS = [ ON | OFF ]

----------------------------------------
ALTER VIEW [ schema_name . ] view_name [ ( column [ ,...n ] ) ]
[ WITH <view_attribute> [ ,...n ] ]
AS select_statement
[ WITH CHECK OPTION ] [ ; ]

<view_attribute> ::=
{
    [ ENCRYPTION ]
    [ SCHEMABINDING ]
    [ VIEW_METADATA ]
}
----------------------------------------
ALTER WORKLOAD GROUP { group_name | "default" }
[ WITH
    ([ IMPORTANCE = { LOW | MEDIUM | HIGH } ]
      [ [ , ] REQUEST_MAX_MEMORY_GRANT_PERCENT = value ]
      [ [ , ] REQUEST_MAX_CPU_TIME_SEC = value ]
      [ [ , ] REQUEST_MEMORY_GRANT_TIMEOUT_SEC = value ]
      [ [ , ] MAX_DOP = value ]
      [ [ , ] GROUP_MAX_REQUESTS = value ] )
 ]
[ USING { pool_name | "default" } ]
[ ; ]

----------------------------------------
ALTER XML SCHEMA COLLECTION [ relational_schema. ]sql_identifier ADD 'Schema Component'
----------------------------------------
--Backing Up a Whole Database
BACKUP DATABASE { database_name | @database_name_var }
  TO <backup_device> [ ,...n ]
  [ <MIRROR TO clause> ] [ next-mirror-to ]
  [ WITH { DIFFERENTIAL
           | <general_WITH_options> [ ,...n ] } ]
[;]

--Backing Up Specific Files or Filegroups
BACKUP DATABASE { database_name | @database_name_var }
 <file_or_filegroup> [ ,...n ]
  TO <backup_device> [ ,...n ]
  [ <MIRROR TO clause> ] [ next-mirror-to ]
  [ WITH { DIFFERENTIAL | <general_WITH_options> [ ,...n ] } ]
[;]

--Creating a Partial Backup
BACKUP DATABASE { database_name | @database_name_var }
 READ_WRITE_FILEGROUPS [ , <read_only_filegroup> [ ,...n ] ]
  TO <backup_device> [ ,...n ]
  [ <MIRROR TO clause> ] [ next-mirror-to ]
  [ WITH { DIFFERENTIAL | <general_WITH_options> [ ,...n ] } ]
[;]

--Backing Up the Transaction Log (full and bulk-logged recovery models)
BACKUP LOG
  { database_name | @database_name_var }
  TO <backup_device> [ ,...n ]
  [ <MIRROR TO clause> ] [ next-mirror-to ]
  [ WITH { <general_WITH_options> | \<log-specific_optionspec> } [ ,...n ] ]
[;]

<backup_device>::=
 {
  { logical_device_name | @logical_device_name_var }
 | {   DISK
     | TAPE
     | URL } =
     { 'physical_device_name' | @physical_device_name_var | 'NUL' }
 }

<MIRROR TO clause>::=
 MIRROR TO <backup_device> [ ,...n ]

<file_or_filegroup>::=
 {
   FILE = { logical_file_name | @logical_file_name_var }
 | FILEGROUP = { logical_filegroup_name | @logical_filegroup_name_var }
 }

<read_only_filegroup>::=
FILEGROUP = { logical_filegroup_name | @logical_filegroup_name_var }

<general_WITH_options> [ ,...n ]::=
--Backup Set Options
   COPY_ONLY
 | { COMPRESSION | NO_COMPRESSION }
 | DESCRIPTION = { 'text' | @text_variable }
 | NAME = { backup_set_name | @backup_set_name_var }
 | CREDENTIAL
 | ENCRYPTION
 | FILE_SNAPSHOT
 | { EXPIREDATE = { 'date' | @date_var }
        | RETAINDAYS = { days | @days_var } }

--Media Set Options
   { NOINIT | INIT }
 | { NOSKIP | SKIP }
 | { NOFORMAT | FORMAT }
 | MEDIADESCRIPTION = { 'text' | @text_variable }
 | MEDIANAME = { media_name | @media_name_variable }
 | BLOCKSIZE = { blocksize | @blocksize_variable }

--Data Transfer Options
   BUFFERCOUNT = { buffercount | @buffercount_variable }
 | MAXTRANSFERSIZE = { maxtransfersize | @maxtransfersize_variable }

--Error Management Options
   { NO_CHECKSUM | CHECKSUM }
 | { STOP_ON_ERROR | CONTINUE_AFTER_ERROR }

--Compatibility Options
   RESTART

--Monitoring Options
   STATS [ = percentage ]

--Tape Options
   { REWIND | NOREWIND }
 | { UNLOAD | NOUNLOAD }

--Log-specific Options
   { NORECOVERY | STANDBY = undo_file_name }
 | NO_TRUNCATE

--Encryption Options
 ENCRYPTION (ALGORITHM = { AES_128 | AES_192 | AES_256 | TRIPLE_DES_3KEY } , encryptor_options ) <encryptor_options> ::=
   `SERVER CERTIFICATE` = Encryptor_Name | SERVER ASYMMETRIC KEY = Encryptor_Name
----------------------------------------
-- Syntax for SQL Server

BACKUP CERTIFICATE certname TO FILE = 'path_to_file'
    [ WITH PRIVATE KEY
      (
        FILE = 'path_to_private_key_file' ,
        ENCRYPTION BY PASSWORD = 'encryption_password'
        [ , DECRYPTION BY PASSWORD = 'decryption_password' ]
      )
    ]
----------------------------------------
BACKUP MASTER KEY TO FILE = 'path_to_file'
    ENCRYPTION BY PASSWORD = 'password'
----------------------------------------
--To Restore an Entire Database from a Full database backup (a Complete Restore):
RESTORE DATABASE { database_name | @database_name_var }
 [ FROM <backup_device> [ ,...n ] ]
 [ WITH
   {
    [ RECOVERY | NORECOVERY | STANDBY =
        {standby_file_name | @standby_file_name_var }
       ]
   | ,  <general_WITH_options> [ ,...n ]
   | , <replication_WITH_option>
   | , <change_data_capture_WITH_option>
   | , <FILESTREAM_WITH_option>
   | , <service_broker_WITH options>
   | , \<point_in_time_WITH_options-RESTORE_DATABASE>
   } [ ,...n ]
 ]
[;]

--To perform the first step of the initial restore sequence of a piecemeal restore:
RESTORE DATABASE { database_name | @database_name_var }
   <files_or_filegroups> [ ,...n ]
 [ FROM <backup_device> [ ,...n ] ]
   WITH
      PARTIAL, NORECOVERY
      [  , <general_WITH_options> [ ,...n ]
       | , \<point_in_time_WITH_options-RESTORE_DATABASE>
      ] [ ,...n ]
[;]

--To Restore Specific Files or Filegroups:
RESTORE DATABASE { database_name | @database_name_var }
   <file_or_filegroup> [ ,...n ]
 [ FROM <backup_device> [ ,...n ] ]
   WITH
   {
      [ RECOVERY | NORECOVERY ]
      [ , <general_WITH_options> [ ,...n ] ]
   } [ ,...n ]
[;]

--To Restore Specific Pages:
RESTORE DATABASE { database_name | @database_name_var }
   PAGE = 'file:page [ ,...n ]'
 [ , <file_or_filegroups> ] [ ,...n ]
 [ FROM <backup_device> [ ,...n ] ]
   WITH
       NORECOVERY
      [ , <general_WITH_options> [ ,...n ] ]
[;]

--To Restore a Transaction Log:
RESTORE LOG { database_name | @database_name_var }
 [ <file_or_filegroup_or_pages> [ ,...n ] ]
 [ FROM <backup_device> [ ,...n ] ]
 [ WITH
   {
     [ RECOVERY | NORECOVERY | STANDBY =
        {standby_file_name | @standby_file_name_var }
       ]
    | , <general_WITH_options> [ ,...n ]
    | , <replication_WITH_option>
    | , \<point_in_time_WITH_options-RESTORE_LOG>
   } [ ,...n ]
 ]
[;]

--To Revert a Database to a Database Snapshot:
RESTORE DATABASE { database_name | @database_name_var }
FROM DATABASE_SNAPSHOT = database_snapshot_name

<backup_device>::=
{
   { logical_backup_device_name |
      @logical_backup_device_name_var }
 | { DISK
     | TAPE
     | URL
   } = { 'physical_backup_device_name' |
      @physical_backup_device_name_var }
}
Note: URL is the format used to specify the location and the file name for the Microsoft Azure Blob. Although Microsoft Azure storage is a service, the implementation is similar to disk and tape to allow for a consistent and seamless restore experience for all the three devices.
<files_or_filegroups>::=
{
   FILE = { logical_file_name_in_backup | @logical_file_name_in_backup_var }
 | FILEGROUP = { logical_filegroup_name | @logical_filegroup_name_var }
 | READ_WRITE_FILEGROUPS
}

<general_WITH_options> [ ,...n ]::=
--Restore Operation Options
   MOVE 'logical_file_name_in_backup' TO 'operating_system_file_name'
          [ ,...n ]
 | REPLACE
 | RESTART
 | RESTRICTED_USER | CREDENTIAL

--Backup Set Options
 | FILE = { backup_set_file_number | @backup_set_file_number }
 | PASSWORD = { password | @password_variable }

--Media Set Options
 | MEDIANAME = { media_name | @media_name_variable }
 | MEDIAPASSWORD = { mediapassword | @mediapassword_variable }
 | BLOCKSIZE = { blocksize | @blocksize_variable }

--Data Transfer Options
 | BUFFERCOUNT = { buffercount | @buffercount_variable }
 | MAXTRANSFERSIZE = { maxtransfersize | @maxtransfersize_variable }

--Error Management Options
 | { CHECKSUM | NO_CHECKSUM }
 | { STOP_ON_ERROR | CONTINUE_AFTER_ERROR }

--Monitoring Options
 | STATS [ = percentage ]

--Tape Options.
 | { REWIND | NOREWIND }
 | { UNLOAD | NOUNLOAD }

<replication_WITH_option>::=
 | KEEP_REPLICATION

<change_data_capture_WITH_option>::=
 | KEEP_CDC

<FILESTREAM_WITH_option>::=
 | FILESTREAM ( DIRECTORY_NAME = directory_name )

<service_broker_WITH_options>::=
 | ENABLE_BROKER
 | ERROR_BROKER_CONVERSATIONS
 | NEW_BROKER

\<point_in_time_WITH_options-RESTORE_DATABASE>::=
 | {
   STOPAT = { 'datetime'| @datetime_var }
 | STOPATMARK = 'lsn:lsn_number'
                 [ AFTER 'datetime']
 | STOPBEFOREMARK = 'lsn:lsn_number'
                 [ AFTER 'datetime']
   }

\<point_in_time_WITH_options-RESTORE_LOG>::=
 | {
   STOPAT = { 'datetime'| @datetime_var }
 | STOPATMARK = { 'mark_name' | 'lsn:lsn_number' }
                 [ AFTER 'datetime']
 | STOPBEFOREMARK = { 'mark_name' | 'lsn:lsn_number' }
                 [ AFTER 'datetime']
   }
----------------------------------------
RESTORE FILELISTONLY
FROM <backup_device>
[ WITH
 {
--Backup Set Options
   FILE = { backup_set_file_number | @backup_set_file_number }
 | PASSWORD = { password | @password_variable }

--Media Set Options
 | MEDIANAME = { media_name | @media_name_variable }
 | MEDIAPASSWORD = { mediapassword | @mediapassword_variable }

--Error Management Options
 | { CHECKSUM | NO_CHECKSUM }
 | { STOP_ON_ERROR | CONTINUE_AFTER_ERROR }

--Tape Options
 | { REWIND | NOREWIND }
 | { UNLOAD | NOUNLOAD }
 } [ ,...n ]
]
[;]

<backup_device> ::=
{
   { logical_backup_device_name |
      @logical_backup_device_name_var }
   | { DISK | TAPE | URL } = { 'physical_backup_device_name' |
       @physical_backup_device_name_var }
}
----------------------------------------

RESTORE HEADERONLY
FROM <backup_device>
[ WITH
 {
--Backup Set Options
   FILE = { backup_set_file_number | @backup_set_file_number }
 | PASSWORD = { password | @password_variable }

--Media Set Options
 | MEDIANAME = { media_name | @media_name_variable }
 | MEDIAPASSWORD = { mediapassword | @mediapassword_variable }

--Error Management Options
 | { CHECKSUM | NO_CHECKSUM }
 | { STOP_ON_ERROR | CONTINUE_AFTER_ERROR }

--Tape Options
 | { REWIND | NOREWIND }
 | { UNLOAD | NOUNLOAD }
 } [ ,...n ]
]
[;]

<backup_device> ::=
{
   { logical_backup_device_name |
      @logical_backup_device_name_var }
   | { DISK | TAPE | URL } = { 'physical_backup_device_name' |
       @physical_backup_device_name_var }
}
----------------------------------------
RESTORE LABELONLY
FROM <backup_device>
[ WITH
 {
--Media Set Options
   MEDIANAME = { media_name | @media_name_variable }
 | MEDIAPASSWORD = { mediapassword | @mediapassword_variable }

--Error Management Options
 | { CHECKSUM | NO_CHECKSUM }
 | { STOP_ON_ERROR | CONTINUE_AFTER_ERROR }

--Tape Options
 | { REWIND | NOREWIND }
 | { UNLOAD | NOUNLOAD }
 } [ ,...n ]
]
[;]

<backup_device> ::=
{
   { logical_backup_device_name |
      @logical_backup_device_name_var }
   | { DISK | TAPE | URL } = { 'physical_backup_device_name' |
       @physical_backup_device_name_var }
}
----------------------------------------
RESTORE MASTER KEY FROM FILE = 'path_to_file'
    DECRYPTION BY PASSWORD = 'password'
    ENCRYPTION BY PASSWORD = 'password'
    [ FORCE ]

----------------------------------------
RESTORE SERVICE MASTER KEY FROM FILE = 'path_to_file'
    DECRYPTION BY PASSWORD = 'password' [FORCE]
----------------------------------------
RESTORE REWINDONLY
FROM <backup_device> [ ,...n ]
[ WITH {UNLOAD | NOUNLOAD}]
}
[;]

<backup_device> ::=
{
   { logical_backup_device_name |
      @logical_backup_device_name_var }
   | TAPE = { 'physical_backup_device_name' |
       @physical_backup_device_name_var }
}
----------------------------------------
RESTORE VERIFYONLY
FROM <backup_device> [ ,...n ]
[ WITH
 {
   LOADHISTORY

--Restore Operation Option
 | MOVE 'logical_file_name_in_backup' TO 'operating_system_file_name'
          [ ,...n ]

--Backup Set Options
 | FILE = { backup_set_file_number | @backup_set_file_number }
 | PASSWORD = { password | @password_variable }

--Media Set Options
 | MEDIANAME = { media_name | @media_name_variable }
 | MEDIAPASSWORD = { mediapassword | @mediapassword_variable }

--Error Management Options
 | { CHECKSUM | NO_CHECKSUM }
 | { STOP_ON_ERROR | CONTINUE_AFTER_ERROR }

--Monitoring Options
 | STATS [ = percentage ]

--Tape Options
 | { REWIND | NOREWIND }
 | { UNLOAD | NOUNLOAD }
 } [ ,...n ]
]
[;]

<backup_device> ::=
{
   { logical_backup_device_name |
      @logical_backup_device_name_var }
   | { DISK | TAPE | URL } = { 'physical_backup_device_name' |
       @physical_backup_device_name_var }
}
----------------------------------------
CREATE AGGREGATE [ schema_name . ] aggregate_name
        (@param_name <input_sqltype>
        [ ,...n ] )
RETURNS <return_sqltype>
EXTERNAL NAME assembly_name [ .class_name ]

<input_sqltype> ::=
        system_scalar_type | { [ udt_schema_name. ] udt_type_name }

<return_sqltype> ::=
        system_scalar_type | { [ udt_schema_name. ] udt_type_name }
----------------------------------------
CREATE APPLICATION ROLE application_role_name
    WITH PASSWORD = 'password' [ , DEFAULT_SCHEMA = schema_name ]
----------------------------------------
CREATE ASSEMBLY assembly_name
[ AUTHORIZATION owner_name ]
FROM { <client_assembly_specifier> | <assembly_bits> [ ,...n ] }
[ WITH PERMISSION_SET = { SAFE | EXTERNAL_ACCESS | UNSAFE } ]
[ ; ]
<client_assembly_specifier> :: =
        '[\\computer_name\]share_name\[path\]manifest_file_name'
  | '[local_path\]manifest_file_name'

<assembly_bits> :: =
{ varbinary_literal | varbinary_expression }
----------------------------------------
CREATE ASYMMETRIC KEY asym_key_name
   [ AUTHORIZATION database_principal_name ]
   [ FROM <asym_key_source> ]
   [ WITH <key_option> ]
   [ ENCRYPTION BY <encrypting_mechanism> ]
   [ ; ]

<asym_key_source>::=
     FILE = 'path_to_strong-name_file'
   | EXECUTABLE FILE = 'path_to_executable_file'
   | ASSEMBLY assembly_name
   | PROVIDER provider_name

<key_option> ::=
   ALGORITHM = <algorithm>
      |
   PROVIDER_KEY_NAME = 'key_name_in_provider'
      |
      CREATION_DISPOSITION = { CREATE_NEW | OPEN_EXISTING }

<algorithm> ::=
      { RSA_4096 | RSA_3072 | RSA_2048 | RSA_1024 | RSA_512 }

<encrypting_mechanism> ::=
    PASSWORD = 'password'
----------------------------------------
CREATE AVAILABILITY GROUP group_name
   WITH (<with_option_spec> [ ,...n ] )
   FOR [ DATABASE database_name [ ,...n ] ]
   REPLICA ON <add_replica_spec> [ ,...n ]
   AVAILABILITY GROUP ON <add_availability_group_spec> [ ,...2 ]
   [ LISTENER 'dns_name' ( <listener_option> ) ]
[ ; ]

<with_option_spec>::=
    AUTOMATED_BACKUP_PREFERENCE = { PRIMARY | SECONDARY_ONLY| SECONDARY | NONE }
  | FAILURE_CONDITION_LEVEL  = { 1 | 2 | 3 | 4 | 5 }
  | HEALTH_CHECK_TIMEOUT = milliseconds
  | DB_FAILOVER  = { ON | OFF }
  | DTC_SUPPORT  = { PER_DB | NONE }
  | BASIC
  | DISTRIBUTED
  | REQUIRED_SYNCHRONIZED_SECONDARIES_TO_COMMIT = { integer }
  | CLUSTER_TYPE = { WSFC | EXTERNAL | NONE }

<add_replica_spec>::=
  <server_instance> WITH
    (
       ENDPOINT_URL = 'TCP://system-address:port',
       AVAILABILITY_MODE = { SYNCHRONOUS_COMMIT | ASYNCHRONOUS_COMMIT | CONFIGURATION_ONLY },
       FAILOVER_MODE = { AUTOMATIC | MANUAL | EXTERNAL }
       [ , <add_replica_option> [ ,...n ] ]
    )

  <add_replica_option>::=
       SEEDING_MODE = { AUTOMATIC | MANUAL }
     | BACKUP_PRIORITY = n
     | SECONDARY_ROLE ( {
            [ ALLOW_CONNECTIONS = { NO | READ_ONLY | ALL } ]
        [,] [ READ_ONLY_ROUTING_URL = 'TCP://system-address:port' ]
     } )
     | PRIMARY_ROLE ( {
            [ ALLOW_CONNECTIONS = { READ_WRITE | ALL } ]
        [,] [ READ_ONLY_ROUTING_LIST = { ( '<server_instance>' [ ,...n ] ) | NONE } ]
        [,] [ READ_WRITE_ROUTING_URL = { ( '<server_instance>' ) ]
     } )
     | SESSION_TIMEOUT = integer

<add_availability_group_spec>::=
 <ag_name> WITH
    (
       LISTENER_URL = 'TCP://system-address:port',
       AVAILABILITY_MODE = { SYNCHRONOUS_COMMIT | ASYNCHRONOUS_COMMIT },
       FAILOVER_MODE = MANUAL,
       SEEDING_MODE = { AUTOMATIC | MANUAL }
    )

<listener_option> ::=
   {
      WITH DHCP [ ON ( <network_subnet_option> ) ]
    | WITH IP ( { ( <ip_address_option> ) } [ , ...n ] ) [ , PORT = listener_port ]
   }

  <network_subnet_option> ::=
     'ip4_address', 'four_part_ipv4_mask'

  <ip_address_option> ::=
     {
        'ip4_address', 'pv4_mask'
      | 'ipv6_address'
     }
----------------------------------------
CREATE BROKER PRIORITY ConversationPriorityName
FOR CONVERSATION
[ SET ( [ CONTRACT_NAME = {ContractName | ANY } ]
        [ [ , ] LOCAL_SERVICE_NAME = {LocalServiceName | ANY } ]
        [ [ , ] REMOTE_SERVICE_NAME = {'RemoteServiceName' | ANY } ]
        [ [ , ] PRIORITY_LEVEL = {PriorityValue | DEFAULT } ]
       )
]
[;]
----------------------------------------
-- Syntax for SQL Server and Azure SQL Database

CREATE CERTIFICATE certificate_name [ AUTHORIZATION user_name ]
    { FROM <existing_keys> | <generate_new_keys> }
    [ ACTIVE FOR BEGIN_DIALOG = { ON | OFF } ]

<existing_keys> ::=
    ASSEMBLY assembly_name
    | {
        [ EXECUTABLE ] FILE = 'path_to_file'
        [ WITH PRIVATE KEY ( <private_key_options> ) ]
      }
    | {
        BINARY = asn_encoded_certificate
        [ WITH PRIVATE KEY ( <private_key_options> ) ]
      }
<generate_new_keys> ::=
    [ ENCRYPTION BY PASSWORD = 'password' ]
    WITH SUBJECT = 'certificate_subject_name'
    [ , <date_options> [ ,...n ] ]

<private_key_options> ::=
      {
        FILE = 'path_to_private_key'
         [ , DECRYPTION BY PASSWORD = 'password' ]
         [ , ENCRYPTION BY PASSWORD = 'password' ]
      }
    |
      {
        BINARY = private_key_bits
         [ , DECRYPTION BY PASSWORD = 'password' ]
         [ , ENCRYPTION BY PASSWORD = 'password' ]
      }

<date_options> ::=
    START_DATE = 'datetime' | EXPIRY_DATE = 'datetime'

----------------------------------------
-- Syntax for SQL Server and Azure SQL Database

-- Create a clustered columnstore index on disk-based table.
CREATE CLUSTERED COLUMNSTORE INDEX index_name
    ON { database_name.schema_name.table_name | schema_name.table_name | table_name }
    [ WITH ( < with_option> [ ,...n ] ) ]
    [ ON <on_option> ]
[ ; ]

--Create a nonclustered columnstore index on a disk-based table.
CREATE [NONCLUSTERED]  COLUMNSTORE INDEX index_name
    ON { database_name.schema_name.table_name | schema_name.table_name | table_name }
        ( column  [ ,...n ] )
    [ WHERE <filter_expression> [ AND <filter_expression> ] ]
    [ WITH ( < with_option> [ ,...n ] ) ]
    [ ON <on_option> ]
[ ; ]

<with_option> ::=
      DROP_EXISTING = { ON | OFF } -- default is OFF
    | MAXDOP = max_degree_of_parallelism
    | ONLINE = { ON | OFF }
    | COMPRESSION_DELAY  = { 0 | delay [ Minutes ] }
    | DATA_COMPRESSION = { COLUMNSTORE | COLUMNSTORE_ARCHIVE }
      [ ON PARTITIONS ( { partition_number_expression | range } [ ,...n ] ) ]

<on_option>::=
      partition_scheme_name ( column_name )
    | filegroup_name
    | "default"

<filter_expression> ::=
      column_name IN ( constant [ ,...n ]
    | column_name { IS | IS NOT | = | <> | != | > | >= | !> | < | <= | !< } constant
----------------------------------------
CREATE COLUMN ENCRYPTION KEY key_name
WITH VALUES
  (
    COLUMN_MASTER_KEY = column_master_key_name,
    ALGORITHM = 'algorithm_name',
    ENCRYPTED_VALUE = varbinary_literal
  )
[, (
    COLUMN_MASTER_KEY = column_master_key_name,
    ALGORITHM = 'algorithm_name',
    ENCRYPTED_VALUE = varbinary_literal
  ) ]
[;]
----------------------------------------

CREATE COLUMN MASTER KEY key_name
    WITH (
        KEY_STORE_PROVIDER_NAME = 'key_store_provider_name',
        KEY_PATH = 'key_path'
        [,ENCLAVE_COMPUTATIONS (SIGNATURE = signature)]
         )
[;]
----------------------------------------
CREATE CONTRACT contract_name
   [ AUTHORIZATION owner_name ]
      (  {   { message_type_name | [ DEFAULT ] }
          SENT BY { INITIATOR | TARGET | ANY }
       } [ ,...n] )
[ ; ]
----------------------------------------
CREATE CREDENTIAL credential_name
WITH IDENTITY = 'identity_name'
    [ , SECRET = 'secret' ]
        [ FOR CRYPTOGRAPHIC PROVIDER cryptographic_provider_name ]
----------------------------------------
CREATE CRYPTOGRAPHIC PROVIDER provider_name
    FROM FILE = path_of_DLL
----------------------------------------
----------------------------------------
CREATE DATABASE AUDIT SPECIFICATION audit_specification_name
{
    FOR SERVER AUDIT audit_name
        [ { ADD ( { <audit_action_specification> | audit_action_group_name } )
      } [, ...n] ]
    [ WITH ( STATE = { ON | OFF } ) ]
}
[ ; ]
<audit_action_specification>::=
{
      action [ ,...n ]ON [ class :: ] securable BY principal [ ,...n ]
}
----------------------------------------
-- Syntax for SQL Server

CREATE DATABASE ENCRYPTION KEY
       WITH ALGORITHM = { AES_128 | AES_192 | AES_256 | TRIPLE_DES_3KEY }
   ENCRYPTION BY SERVER
    {
        CERTIFICATE Encryptor_Name |
        ASYMMETRIC KEY Encryptor_Name
    }
[ ; ]
----------------------------------------
CREATE DATABASE SCOPED CREDENTIAL credential_name
WITH IDENTITY = 'identity_name'
    [ , SECRET = 'secret' ]


----------------------------------------

CREATE DEFAULT [ schema_name . ] default_name
AS constant_expression [ ; ]
----------------------------------------
CREATE ENDPOINT endPointName [ AUTHORIZATION login ]
[ STATE = { STARTED | STOPPED | DISABLED } ]
AS { TCP } (
   <protocol_specific_arguments>
        )
FOR { TSQL | SERVICE_BROKER | DATABASE_MIRRORING } (
   <language_specific_arguments>
        )

<AS TCP_protocol_specific_arguments> ::=
AS TCP (
  LISTENER_PORT = listenerPort
  [ [ , ] LISTENER_IP = ALL | ( xx.xx.xx.xx IPv4 address ) | ( '__:__1' IPv6 address ) ]

)

<FOR SERVICE_BROKER_language_specific_arguments> ::=
FOR SERVICE_BROKER (
   [ AUTHENTICATION = {
            WINDOWS [ { NTLM | KERBEROS | NEGOTIATE } ]
      | CERTIFICATE certificate_name
      | WINDOWS [ { NTLM | KERBEROS | NEGOTIATE } ] CERTIFICATE certificate_name
      | CERTIFICATE certificate_name WINDOWS [ { NTLM | KERBEROS | NEGOTIATE } ]
    } ]
   [ [ , ] ENCRYPTION = { DISABLED | { { SUPPORTED | REQUIRED }
       [ ALGORITHM { AES | RC4 | AES RC4 | RC4 AES } ] }
   ]
   [ [ , ] MESSAGE_FORWARDING = { ENABLED | DISABLED } ]
   [ [ , ] MESSAGE_FORWARD_SIZE = forward_size ]
)


<FOR DATABASE_MIRRORING_language_specific_arguments> ::=
FOR DATABASE_MIRRORING (
   [ AUTHENTICATION = {
            WINDOWS [ { NTLM | KERBEROS | NEGOTIATE } ]
      | CERTIFICATE certificate_name
      | WINDOWS [ { NTLM | KERBEROS | NEGOTIATE } ] CERTIFICATE certificate_name
      | CERTIFICATE certificate_name WINDOWS [ { NTLM | KERBEROS | NEGOTIATE } ]
   [ [ [ , ] ] ENCRYPTION = { DISABLED | { { SUPPORTED | REQUIRED }
       [ ALGORITHM { AES | RC4 | AES RC4 | RC4 AES } ] }

    ]
   [ , ] ROLE = { WITNESS | PARTNER | ALL }
)
----------------------------------------
CREATE EVENT NOTIFICATION event_notification_name
ON { SERVER | DATABASE | QUEUE queue_name }
[ WITH FAN_IN ]
FOR { event_type | event_group } [ ,...n ]
TO SERVICE 'broker_service' , { 'broker_instance_specifier' | 'current database' }
[ ; ]
----------------------------------------
CREATE EVENT SESSION event_session_name
ON { SERVER | DATABASE }
{
    <event_definition> [ ,...n]
    [ <event_target_definition> [ ,...n] ]
    [ WITH ( <event_session_options> [ ,...n] ) ]
}
;

<event_definition>::=
{
    ADD EVENT [event_module_guid].event_package_name.event_name
         [ ( {
                 [ SET { event_customizable_attribute = <value> [ ,...n] } ]
                 [ ACTION ( { [event_module_guid].event_package_name.action_name [ ,...n] } ) ]
                 [ WHERE <predicate_expression> ]
        } ) ]
}

<predicate_expression> ::=
{
    [ NOT ] <predicate_factor> | {( <predicate_expression> ) }
    [ { AND | OR } [ NOT ] { <predicate_factor> | ( <predicate_expression> ) } ]
    [ ,...n ]
}

<predicate_factor>::=
{
    <predicate_leaf> | ( <predicate_expression> )
}

<predicate_leaf>::=
{
      <predicate_source_declaration> { = | < > | ! = | > | > = | < | < = } <value>
    | [event_module_guid].event_package_name.predicate_compare_name ( <predicate_source_declaration>, <value> )
}

<predicate_source_declaration>::=
{
    event_field_name | ( [event_module_guid].event_package_name.predicate_source_name )
}

<value>::=
{
    number | 'string'
}

<event_target_definition>::=
{
    ADD TARGET [event_module_guid].event_package_name.target_name
        [ ( SET { target_parameter_name = <value> [ ,...n] } ) ]
}

<event_session_options>::=
{
    [    MAX_MEMORY = size [ KB | MB ] ]
    [ [,] EVENT_RETENTION_MODE = { ALLOW_SINGLE_EVENT_LOSS | ALLOW_MULTIPLE_EVENT_LOSS | NO_EVENT_LOSS } ]
    [ [,] MAX_DISPATCH_LATENCY = { seconds SECONDS | INFINITE } ]
    [ [,] MAX_EVENT_SIZE = size [ KB | MB ] ]
    [ [,] MEMORY_PARTITION_MODE = { NONE | PER_NODE | PER_CPU } ]
    [ [,] TRACK_CAUSALITY = { ON | OFF } ]
    [ [,] STARTUP_STATE = { ON | OFF } ]
}
----------------------------------------
CREATE EXTERNAL DATA SOURCE <data_source_name>
WITH
  ( [ LOCATION = '<prefix>://<path>[:<port>]' ]
    [ [ , ] CONNECTION_OPTIONS = '<name_value_pairs>']
    [ [ , ] CREDENTIAL = <credential_name> ]
    [ [ , ] PUSHDOWN = { ON | OFF } ]
    [ [ , ] TYPE = { HADOOP | BLOB_STORAGE } ]
    [ [ , ] RESOURCE_MANAGER_LOCATION = '<resource_manager>[:<port>]' )
[ ; ]
----------------------------------------
CREATE EXTERNAL LANGUAGE language_name
[ AUTHORIZATION owner_name ]
FROM <file_spec> [ ,...2 ]
[ ; ]

<file_spec> ::=
{
    ( CONTENT = { <external_lang_specifier> | <content_bits> },
    FILE_NAME = <external_lang_file_name>
    [ , PLATFORM = <platform> ]
    [ , PARAMETERS = <external_lang_parameters> ]
    [ , ENVIRONMENT_VARIABLES = <external_lang_env_variables> ] )
}

<external_lang_specifier> :: =
{
    '[file_path\]os_file_name'
}

<content_bits> :: =
{
    varbinary_literal
    | varbinary_expression
}

<external_lang_file_name> :: =
'extension_file_name'


<platform> :: =
{
    WINDOWS
  | LINUX
}

<external_lang_parameters> :: =
'extension_specific_parameters'
----------------------------------------
CREATE EXTERNAL LIBRARY library_name
[ AUTHORIZATION owner_name ]
FROM <file_spec> [ ,...2 ]
WITH ( LANGUAGE = <language> )
[ ; ]

<file_spec> ::=
{
    (CONTENT = { <client_library_specifier> | <library_bits> }
    [, PLATFORM = <platform> ])
}

<client_library_specifier> :: =
{
    '[file_path\]manifest_file_name'
}

<library_bits> :: =
{
      varbinary_literal
    | varbinary_expression
}

<platform> :: =
{
      WINDOWS
    | LINUX
}

<language> :: =
{
      'R'
    | 'Python'
    | <external_language>
}
----------------------------------------
-- Create an external file format for DELIMITED (CSV/TSV) files.
CREATE EXTERNAL FILE FORMAT file_format_name
WITH (
        FORMAT_TYPE = DELIMITEDTEXT
    [ , FORMAT_OPTIONS ( <format_options> [ ,...n  ] ) ]
    [ , DATA_COMPRESSION = {
           'org.apache.hadoop.io.compress.GzipCodec'
         | 'org.apache.hadoop.io.compress.DefaultCodec'
        }
     ]);

<format_options> ::=
{
    FIELD_TERMINATOR = field_terminator
    | STRING_DELIMITER = string_delimiter
    | First_Row = integer -- ONLY AVAILABLE FOR AZURE SYNAPSE ANALYTICS
    | DATE_FORMAT = datetime_format
    | USE_TYPE_DEFAULT = { TRUE | FALSE }
    | Encoding = {'UTF8' | 'UTF16'}
}
----------------------------------------
CREATE EXTERNAL RESOURCE POOL pool_name
[ WITH (
    [ MAX_CPU_PERCENT = value ]
    [ [ , ] MAX_MEMORY_PERCENT = value ]
    [ [ , ] MAX_PROCESSES = value ]
    )
]
[ ; ]

<CPU_range_spec> ::=
{ CPU_ID | CPU_ID  TO CPU_ID } [ ,...n ]
----------------------------------------
-- Create a new external table
CREATE EXTERNAL TABLE { database_name.schema_name.table_name | schema_name.table_name | table_name }
    ( <column_definition> [ ,...n ] )
    WITH (
        LOCATION = 'folder_or_filepath',
        DATA_SOURCE = external_data_source_name,
        FILE_FORMAT = external_file_format_name
        [ , <reject_options> [ ,...n ] ]
    )
[;]

<reject_options> ::=
{
    | REJECT_TYPE = value | percentage
    | REJECT_VALUE = reject_value
    | REJECT_SAMPLE_VALUE = reject_sample_value
}

<column_definition> ::=
column_name <data_type>
    [ COLLATE collation_name ]
    [ NULL | NOT NULL ]
----------------------------------------
CREATE FULLTEXT CATALOG catalog_name
     [ON FILEGROUP filegroup ]
     [IN PATH 'rootpath']
     [WITH <catalog_option>]
     [AS DEFAULT]
     [AUTHORIZATION owner_name ]

<catalog_option>::=
     ACCENT_SENSITIVITY = {ON|OFF}
----------------------------------------
CREATE FULLTEXT INDEX ON table_name
   [ ( { column_name
             [ TYPE COLUMN type_column_name ]
             [ LANGUAGE language_term ]
             [ STATISTICAL_SEMANTICS ]
        } [ ,...n]
      ) ]
    KEY INDEX index_name
    [ ON <catalog_filegroup_option> ]
    [ WITH [ ( ] <with_option> [ ,...n] [ ) ] ]
[;]

<catalog_filegroup_option>::=
 {
    fulltext_catalog_name
 | ( fulltext_catalog_name, FILEGROUP filegroup_name )
 | ( FILEGROUP filegroup_name, fulltext_catalog_name )
 | ( FILEGROUP filegroup_name )
 }

<with_option>::=
 {
   CHANGE_TRACKING [ = ] { MANUAL | AUTO | OFF [, NO POPULATION ] }
 | STOPLIST [ = ] { OFF | SYSTEM | stoplist_name }
 | SEARCH PROPERTY LIST [ = ] property_list_name
 }
----------------------------------------
CREATE FULLTEXT STOPLIST stoplist_name
[ FROM { [ database_name.]source_stoplist_name } | SYSTEM STOPLIST ]
[ AUTHORIZATION owner_name ]
;

----------------------------------------
-- Transact-SQL Scalar Function Syntax
CREATE [ OR ALTER ] FUNCTION [ schema_name. ] function_name
( [ { @parameter_name [ AS ][ type_schema_name. ] parameter_data_type
 [ = default ] [ READONLY ] }
    [ ,...n ]
  ]
)
RETURNS return_data_type
    [ WITH <function_option> [ ,...n ] ]
    [ AS ]
    BEGIN
        function_body
        RETURN scalar_expression
    END
[ ; ]
----------------------------------------
-- Transact-SQL Inline Table-Valued Function Syntax
CREATE [ OR ALTER ] FUNCTION [ schema_name. ] function_name
( [ { @parameter_name [ AS ] [ type_schema_name. ] parameter_data_type
    [ = default ] [ READONLY ] }
    [ ,...n ]
  ]
)
RETURNS TABLE
    [ WITH <function_option> [ ,...n ] ]
    [ AS ]
    RETURN [ ( ] select_stmt [ ) ]
[ ; ]


----------------------------------------
-- Transact-SQL Multi-Statement Table-Valued Function Syntax
CREATE [ OR ALTER ] FUNCTION [ schema_name. ] function_name
( [ { @parameter_name [ AS ] [ type_schema_name. ] parameter_data_type
    [ = default ] [READONLY] }
    [ ,...n ]
  ]
)
RETURNS @return_variable TABLE <table_type_definition>
    [ WITH <function_option> [ ,...n ] ]
    [ AS ]
    BEGIN
        function_body
        RETURN
    END
[ ; ]
----------------------------------------
CREATE [ UNIQUE ] [ CLUSTERED | NONCLUSTERED ] INDEX index_name
    ON <object> ( column [ ASC | DESC ] [ ,...n ] )
    [ INCLUDE ( column_name [ ,...n ] ) ]
    [ WHERE <filter_predicate> ]
    [ WITH ( <relational_index_option> [ ,...n ] ) ]
    [ ON { partition_scheme_name ( column_name )
         | filegroup_name
         | default
         }
    ]
    [ FILESTREAM_ON { filestream_filegroup_name | partition_scheme_name | "NULL" } ]

[ ; ]

<object> ::=
{ database_name.schema_name.table_or_view_name | schema_name.table_or_view_name | table_or_view_name }

<relational_index_option> ::=
{
    PAD_INDEX = { ON | OFF }
  | FILLFACTOR = fillfactor
  | SORT_IN_TEMPDB = { ON | OFF }
  | IGNORE_DUP_KEY = { ON | OFF }
  | STATISTICS_NORECOMPUTE = { ON | OFF }
  | STATISTICS_INCREMENTAL = { ON | OFF }
  | DROP_EXISTING = { ON | OFF }
  | ONLINE = { ON | OFF }
  | RESUMABLE = { ON | OFF }
  | MAX_DURATION = <time> [MINUTES]
  | ALLOW_ROW_LOCKS = { ON | OFF }
  | ALLOW_PAGE_LOCKS = { ON | OFF }
  | OPTIMIZE_FOR_SEQUENTIAL_KEY = { ON | OFF }
  | MAXDOP = max_degree_of_parallelism
  | DATA_COMPRESSION = { NONE | ROW | PAGE }
     [ ON PARTITIONS ( { <partition_number_expression> | <range> }
     [ , ...n ] ) ]
}

<filter_predicate> ::=
    <conjunct> [ AND <conjunct> ]

<conjunct> ::=
    <disjunct> | <comparison>

<disjunct> ::=
        column_name IN (constant ,...n)

<comparison> ::=
        column_name <comparison_op> constant

<comparison_op> ::=
    { IS | IS NOT | = | <> | != | > | >= | !> | < | <= | !< }

<range> ::=
<partition_number_expression> TO <partition_number_expression>
----------------------------------------
-- Syntax for SQL Server
CREATE LOGIN login_name { WITH <option_list1> | FROM <sources> }

<option_list1> ::=
    PASSWORD = { 'password' | hashed_password HASHED } [ MUST_CHANGE ]
    [ , <option_list2> [ ,... ] ]

<option_list2> ::=
    SID = sid
    | DEFAULT_DATABASE = database
    | DEFAULT_LANGUAGE = language
    | CHECK_EXPIRATION = { ON | OFF}
    | CHECK_POLICY = { ON | OFF}
    | CREDENTIAL = credential_name

<sources> ::=
    WINDOWS [ WITH <windows_options>[ ,... ] ]
    | CERTIFICATE certname
    | ASYMMETRIC KEY asym_key_name

<windows_options> ::=
    DEFAULT_DATABASE = database
    | DEFAULT_LANGUAGE = language
----------------------------------------
CREATE MASTER KEY [ ENCRYPTION BY PASSWORD ='password' ]
[ ; ]
----------------------------------------
CREATE MESSAGE TYPE message_type_name
    [ AUTHORIZATION owner_name ]
    [ VALIDATION = {  NONE
                    | EMPTY
                    | WELL_FORMED_XML
                    | VALID_XML WITH SCHEMA COLLECTION schema_collection_name
                   } ]
[ ; ]
----------------------------------------
CREATE PARTITION FUNCTION partition_function_name ( input_parameter_type )
AS RANGE [ LEFT | RIGHT ]
FOR VALUES ( [ boundary_value [ ,...n ] ] )
[ ; ]


----------------------------------------
CREATE PARTITION SCHEME partition_scheme_name
AS PARTITION partition_function_name
[ ALL ] TO ( { file_group_name | [ PRIMARY ] } [ ,...n ] )
[ ; ]
----------------------------------------
-- Transact-SQL Syntax for Stored Procedures in SQL Server and Azure SQL Database

CREATE [ OR ALTER ] { PROC | PROCEDURE }
    [schema_name.] procedure_name [ ; number ]
    [ { @parameter [ type_schema_name. ] data_type }
        [ VARYING ] [ = default ] [ OUT | OUTPUT | [READONLY]
    ] [ ,...n ]
[ WITH <procedure_option> [ ,...n ] ]
[ FOR REPLICATION ]
AS { [ BEGIN ] sql_statement [;] [ ...n ] [ END ] }
[;]

<procedure_option> ::=
    [ ENCRYPTION ]
    [ RECOMPILE ]
    [ EXECUTE AS Clause ]
----------------------------------------
CREATE QUEUE <object>
   [ WITH
     [ STATUS = { ON | OFF } [ , ] ]
     [ RETENTION = { ON | OFF } [ , ] ]
     [ ACTIVATION (
         [ STATUS = { ON | OFF } , ]
           PROCEDURE_NAME = <procedure> ,
           MAX_QUEUE_READERS = max_readers ,
           EXECUTE AS { SELF | 'user_name' | OWNER }
            ) [ , ] ]
     [ POISON_MESSAGE_HANDLING (
         [ STATUS = { ON | OFF } ] ) ]
    ]
     [ ON { filegroup | [ DEFAULT ] } ]
[ ; ]

<object> ::=
{ database_name.schema_name.queue_name | schema_name.queue_name | queue_name }

<procedure> ::=
{ database_name.schema_name.stored_procedure_name | schema_name.stored_procedure_name | stored_procedure_name }
----------------------------------------
CREATE REMOTE SERVICE BINDING binding_name
   [ AUTHORIZATION owner_name ]
   TO SERVICE 'service_name'
   WITH  USER = user_name [ , ANONYMOUS = { ON | OFF } ]
[ ; ]
----------------------------------------
CREATE RESOURCE POOL pool_name
[ WITH
    (
        [ MIN_CPU_PERCENT = value ]
        [ [ , ] MAX_CPU_PERCENT = value ]
        [ [ , ] CAP_CPU_PERCENT = value ]
        [ [ , ] AFFINITY {SCHEDULER =
                  AUTO
                | ( <scheduler_range_spec> )
                | NUMANODE = ( <NUMA_node_range_spec> )
                } ]
        [ [ , ] MIN_MEMORY_PERCENT = value ]
        [ [ , ] MAX_MEMORY_PERCENT = value ]
        [ [ , ] MIN_IOPS_PER_VOLUME = value ]
        [ [ , ] MAX_IOPS_PER_VOLUME = value ]
    )
]
[;]

<scheduler_range_spec> ::=
{ SCHED_ID | SCHED_ID TO SCHED_ID }[,...n]

<NUMA_node_range_spec> ::=
{ NUMA_node_ID | NUMA_node_ID TO NUMA_node_ID }[,...n]
----------------------------------------
CREATE ROLE role_name [ AUTHORIZATION owner_name ]
----------------------------------------
CREATE ROUTE route_name
[ AUTHORIZATION owner_name ]
WITH
   [ SERVICE_NAME = 'service_name', ]
   [ BROKER_INSTANCE = 'broker_instance_identifier' , ]
   [ LIFETIME = route_lifetime , ]
   ADDRESS =  'next_hop_address'
   [ , MIRROR_ADDRESS = 'next_hop_mirror_address' ]
[ ; ]
----------------------------------------
CREATE RULE [ schema_name . ] rule_name
AS condition_expression
[ ; ]
----------------------------------------
CREATE SEARCH PROPERTY LIST new_list_name
   [ FROM [ database_name. ] source_list_name ]
   [ AUTHORIZATION owner_name ]
;
----------------------------------------

CREATE SECURITY POLICY [schema_name. ] security_policy_name
    { ADD [ FILTER | BLOCK ] } PREDICATE tvf_schema_name.security_predicate_function_name
      ( { column_name | expression } [ , ...n] ) ON table_schema_name. table_name
      [ <block_dml_operation> ] , [ , ...n]
    [ WITH ( STATE = { ON | OFF }  [,] [ SCHEMABINDING = { ON | OFF } ] ) ]
    [ NOT FOR REPLICATION ]
[;]

<block_dml_operation>
    [ { AFTER { INSERT | UPDATE } }
    | { BEFORE { UPDATE | DELETE } } ]
----------------------------------------
CREATE SELECTIVE XML INDEX index_name
    ON <table_object> (xml_column_name)
    [WITH XMLNAMESPACES (<xmlnamespace_list>)]
    FOR (<promoted_node_path_list>)
    [WITH (<index_options>)]

<table_object> ::=
 { database_name.schema_name.table_name | schema_name.table_name | table_name }

<promoted_node_path_list> ::=
<named_promoted_node_path_item> [, <promoted_node_path_list>]

<named_promoted_node_path_item> ::=
<path_name> = <promoted_node_path_item>

<promoted_node_path_item>::=
<xquery_node_path_item> | <sql_values_node_path_item>

<xquery_node_path_item> ::=
<node_path> [AS XQUERY <xsd_type_or_node_hint>] [SINGLETON]

<xsd_type_or_node_hint> ::=
[<xsd_type>] [MAXLENGTH(x)] | node()

<sql_values_node_path_item> ::=
<node_path> AS SQL <sql_type> [SINGLETON]

<node_path> ::=
character_string_literal

<xsd_type> ::=
character_string_literal

<sql_type> ::=
identifier

<path_name> ::=
identifier

<xmlnamespace_list> ::=
<xmlnamespace_item> [, <xmlnamespace_list>]

<xmlnamespace_item> ::=
<xmlnamespace_uri> AS <xmlnamespace_prefix>

<xml_namespace_uri> ::=
character_string_literal

<xml_namespace_prefix> ::=
identifier

<index_options> ::=
(
  | PAD_INDEX  = { ON | OFF }
  | FILLFACTOR = fillfactor
  | SORT_IN_TEMPDB = { ON | OFF }
  | IGNORE_DUP_KEY = OFF
  | DROP_EXISTING = { ON | OFF }
  | ONLINE = OFF
  | ALLOW_ROW_LOCKS = { ON | OFF }
  | ALLOW_PAGE_LOCKS = { ON | OFF }
  | MAXDOP = max_degree_of_parallelism
)
----------------------------------------
CREATE SEQUENCE [schema_name . ] sequence_name
    [ AS [ built_in_integer_type | user-defined_integer_type ] ]
    [ START WITH <constant> ]
    [ INCREMENT BY <constant> ]
    [ { MINVALUE [ <constant> ] } | { NO MINVALUE } ]
    [ { MAXVALUE [ <constant> ] } | { NO MAXVALUE } ]
    [ CYCLE | { NO CYCLE } ]
    [ { CACHE [ <constant> ] } | { NO CACHE } ]
    [ ; ]
----------------------------------------

CREATE SERVER AUDIT audit_name
{
    TO { [ FILE (<file_options> [ , ...n ] ) ] | APPLICATION_LOG | SECURITY_LOG | URL | EXTERNAL_MONITOR }
    [ WITH ( <audit_options> [ , ...n ] ) ]
    [ WHERE <predicate_expression> ]
}
[ ; ]

<file_options>::=
{
        FILEPATH = 'os_file_path'
    [ , MAXSIZE = { max_size { MB | GB | TB } | UNLIMITED } ]
    [ , { MAX_ROLLOVER_FILES = { integer | UNLIMITED } } | { MAX_FILES = integer } ]
    [ , RESERVE_DISK_SPACE = { ON | OFF } ]
}

<audit_options>::=
{
    [   QUEUE_DELAY = integer ]
    [ , ON_FAILURE = { CONTINUE | SHUTDOWN | FAIL_OPERATION } ]
    [ , AUDIT_GUID = uniqueidentifier ]
}

<predicate_expression>::=
{
    [NOT ] <predicate_factor>
    [ { AND | OR } [NOT ] { <predicate_factor> } ]
    [,...n ]
}

<predicate_factor>::=
    event_field_name { = | < > | ! = | > | > = | < | < = | LIKE } { number | ' string ' }

----------------------------------------
CREATE SERVER AUDIT SPECIFICATION audit_specification_name
FOR SERVER AUDIT audit_name
{
    { ADD ( { audit_action_group_name } )
    } [, ...n]
    [ WITH ( STATE = { ON | OFF } ) ]
}
[ ; ]
----------------------------------------
CREATE SERVER ROLE role_name [ AUTHORIZATION server_principal ]
----------------------------------------
CREATE SERVICE service_name
   [ AUTHORIZATION owner_name ]
   ON QUEUE [ schema_name. ]queue_name
   [ ( contract_name | [DEFAULT][ ,...n ] ) ]
[ ; ]
----------------------------------------
CREATE SPATIAL INDEX index_name
  ON <object> ( spatial_column_name )
    {
       <geometry_tessellation> | <geography_tessellation>
    }
  [ ON { filegroup_name | "default" } ]
[;]

<object> ::=
    { database_name.schema_name.table_name | schema_name.table_name | table_name }

<geometry_tessellation> ::=
{
  <geometry_automatic_grid_tessellation>
| <geometry_manual_grid_tessellation>
}

<geometry_automatic_grid_tessellation> ::=
{
    [ USING GEOMETRY_AUTO_GRID ]
          WITH  (
        <bounding_box>
            [ [,] <tessellation_cells_per_object> [ ,...n] ]
            [ [,] <spatial_index_option> [ ,...n] ]
                 )
}

<geometry_manual_grid_tessellation> ::=
{
       [ USING GEOMETRY_GRID ]
         WITH (
                    <bounding_box>
                        [ [,]<tessellation_grid> [ ,...n] ]
                        [ [,]<tessellation_cells_per_object> [ ,...n] ]
                        [ [,]<spatial_index_option> [ ,...n] ]
   )
}

<geography_tessellation> ::=
{
      <geography_automatic_grid_tessellation> | <geography_manual_grid_tessellation>
}

<geography_automatic_grid_tessellation> ::=
{
    [ USING GEOGRAPHY_AUTO_GRID ]
    [ WITH (
        [ [,] <tessellation_cells_per_object> [ ,...n] ]
        [ [,] <spatial_index_option> ]
     ) ]
}

<geography_manual_grid_tessellation> ::=
{
    [ USING GEOGRAPHY_GRID ]
    [ WITH (
                [ <tessellation_grid> [ ,...n] ]
                [ [,] <tessellation_cells_per_object> [ ,...n] ]
                [ [,] <spatial_index_option> [ ,...n] ]
                ) ]
}

<bounding_box> ::=
{
      BOUNDING_BOX = ( {
       xmin, ymin, xmax, ymax
       | <named_bb_coordinate>, <named_bb_coordinate>, <named_bb_coordinate>, <named_bb_coordinate>
  } )
}

<named_bb_coordinate> ::= { XMIN = xmin | YMIN = ymin | XMAX = xmax | YMAX=ymax }

<tessellation_grid> ::=
{
    GRIDS = ( { <grid_level> [ ,...n ] | <grid_size>, <grid_size>, <grid_size>, <grid_size>  }
        )
}
<tessellation_cells_per_object> ::=
{
   CELLS_PER_OBJECT = n
}

<grid_level> ::=
{
     LEVEL_1 = <grid_size>
  |  LEVEL_2 = <grid_size>
  |  LEVEL_3 = <grid_size>
  |  LEVEL_4 = <grid_size>
}

<grid_size> ::= { LOW | MEDIUM | HIGH }

<spatial_index_option> ::=
{
    PAD_INDEX = { ON | OFF }
  | FILLFACTOR = fillfactor
  | SORT_IN_TEMPDB = { ON | OFF }
  | IGNORE_DUP_KEY = OFF
  | STATISTICS_NORECOMPUTE = { ON | OFF }
  | DROP_EXISTING = { ON | OFF }
  | ONLINE = OFF
  | ALLOW_ROW_LOCKS = { ON | OFF }
  | ALLOW_PAGE_LOCKS = { ON | OFF }
  | MAXDOP = max_degree_of_parallelism
    | DATA_COMPRESSION = { NONE | ROW | PAGE }
}
----------------------------------------
-- Syntax for SQL Server and Azure SQL Database

-- Create statistics on an external table
CREATE STATISTICS statistics_name
ON { table_or_indexed_view_name } ( column [ ,...n ] )
    [ WITH FULLSCAN ] ;

-- Create statistics on a regular table or indexed view
CREATE STATISTICS statistics_name
ON { table_or_indexed_view_name } ( column [ ,...n ] )
    [ WHERE <filter_predicate> ]
    [ WITH
        [ [ FULLSCAN
            [ [ , ] PERSIST_SAMPLE_PERCENT = { ON | OFF } ]
          | SAMPLE number { PERCENT | ROWS }
            [ [ , ] PERSIST_SAMPLE_PERCENT = { ON | OFF } ]
          | <update_stats_stream_option> [ ,...n ]
        [ [ , ] NORECOMPUTE ]
        [ [ , ] INCREMENTAL = { ON | OFF } ]
        [ [ , ] MAXDOP = max_degree_of_parallelism ]
    ] ;

<filter_predicate> ::=
    <conjunct> [AND <conjunct>]

<conjunct> ::=
    <disjunct> | <comparison>

<disjunct> ::=
        column_name IN (constant ,...)

<comparison> ::=
        column_name <comparison_op> constant

<comparison_op> ::=
    IS | IS NOT | = | <> | != | > | >= | !> | < | <= | !<

<update_stats_stream_option> ::=
    [ STATS_STREAM = stats_stream ]
    [ ROWCOUNT = numeric_constant ]
    [ PAGECOUNT = numeric_contant ]
----------------------------------------
CREATE SYMMETRIC KEY key_name
    [ AUTHORIZATION owner_name ]
    [ FROM PROVIDER provider_name ]
    WITH
      [
          <key_options> [ , ... n ]
        | ENCRYPTION BY <encrypting_mechanism> [ , ... n ]
      ]

<key_options> ::=
      KEY_SOURCE = 'pass_phrase'
    | ALGORITHM = <algorithm>
    | IDENTITY_VALUE = 'identity_phrase'
    | PROVIDER_KEY_NAME = 'key_name_in_provider'
    | CREATION_DISPOSITION = {CREATE_NEW | OPEN_EXISTING }

<algorithm> ::=
    DES | TRIPLE_DES | TRIPLE_DES_3KEY | RC2 | RC4 | RC4_128
    | DESX | AES_128 | AES_192 | AES_256

<encrypting_mechanism> ::=
      CERTIFICATE certificate_name
    | PASSWORD = 'password'
    | SYMMETRIC KEY symmetric_key_name
    | ASYMMETRIC KEY asym_key_name
----------------------------------------
-- SQL Server Syntax

CREATE SYNONYM [ schema_name_1. ] synonym_name FOR <object>

<object> :: =
{
    [ server_name.[ database_name ] . [ schema_name_2 ]. object_name
  | database_name . [ schema_name_2 ].| schema_name_2. ] object_name
}
----------------------------------------
-- SQL Server Syntax
-- Trigger on an INSERT, UPDATE, or DELETE statement to a table or view (DML Trigger)

CREATE [ OR ALTER ] TRIGGER [ schema_name . ]trigger_name
ON { table | view }
[ WITH <dml_trigger_option> [ ,...n ] ]
{ FOR | AFTER | INSTEAD OF }
{ [ INSERT ] [ , ] [ UPDATE ] [ , ] [ DELETE ] }
[ WITH APPEND ]
[ NOT FOR REPLICATION ]
AS { sql_statement  [ ; ] [ ,...n ] | EXTERNAL NAME <method specifier [ ; ] > }

<dml_trigger_option> ::=
    [ ENCRYPTION ]
    [ EXECUTE AS Clause ]

<method_specifier> ::=
    assembly_name.class_name.method_name
----------------------------------------

-- User-defined Data Type Syntax
CREATE TYPE [ schema_name. ] type_name
{
    [
      FROM base_type
      [ ( precision [ , scale ] ) ]
      [ NULL | NOT NULL ]
    ]
    | EXTERNAL NAME assembly_name [ .class_name ]
    | AS TABLE ( { <column_definition> | <computed_column_definition> [ ,... n ] }
      [ <table_constraint> ] [ ,... n ]
      [ <table_index> ] [ ,... n ] } )

} [ ; ]

<column_definition> ::=
column_name <data_type>
    [ COLLATE collation_name ]
    [ NULL | NOT NULL ]
    [
        DEFAULT constant_expression ]
      | [ IDENTITY [ ( seed ,increment ) ]
    ]
    [ ROWGUIDCOL ] [ <column_constraint> [ ...n ] ]

<data type> ::=
[ type_schema_name . ] type_name
    [ ( precision [ , scale ] | max |
                [ { CONTENT | DOCUMENT } ] xml_schema_collection ) ]

<column_constraint> ::=
{     { PRIMARY KEY | UNIQUE }
        [ CLUSTERED | NONCLUSTERED ]
        [
            WITH ( <index_option> [ ,...n ] )
        ]
  | CHECK ( logical_expression )
}

<computed_column_definition> ::=

column_name AS computed_column_expression
[ PERSISTED [ NOT NULL ] ]
[
    { PRIMARY KEY | UNIQUE }
        [ CLUSTERED | NONCLUSTERED ]
        [
            WITH ( <index_option> [ ,...n ] )
        ]
    | CHECK ( logical_expression )
]

<table_constraint> ::=
{
    { PRIMARY KEY | UNIQUE }
        [ CLUSTERED | NONCLUSTERED ]
    ( column [ ASC | DESC ] [ ,...n ] )
        [
    WITH ( <index_option> [ ,...n ] )
        ]
    | CHECK ( logical_expression )
}

<index_option> ::=
{
    IGNORE_DUP_KEY = { ON | OFF }
}

< table_index > ::=
  INDEX constraint_name
     [ CLUSTERED | NONCLUSTERED ]   (column [ ASC | DESC ] [ ,... n ] )} }
----------------------------------------

-- Syntax for SQL Server, Azure SQL Database, and Azure SQL Managed Instance

-- Syntax Users based on logins in master
CREATE USER user_name
    [
        { FOR | FROM } LOGIN login_name
    ]
    [ WITH <limited_options_list> [ ,... ] ]
[ ; ]

-- Users that authenticate at the database
CREATE USER
    {
      windows_principal [ WITH <options_list> [ ,... ] ]

    | user_name WITH PASSWORD = 'password' [ , <options_list> [ ,... ]
    | Azure_Active_Directory_principal FROM EXTERNAL PROVIDER
    }

 [ ; ]

-- Users based on Windows principals that connect through Windows group logins
CREATE USER
    {
          windows_principal [ { FOR | FROM } LOGIN windows_principal ]
        | user_name { FOR | FROM } LOGIN windows_principal
}
    [ WITH <limited_options_list> [ ,... ] ]
[ ; ]

-- Users that cannot authenticate
CREATE USER user_name
    {
         WITHOUT LOGIN [ WITH <limited_options_list> [ ,... ] ]
       | { FOR | FROM } CERTIFICATE cert_name
       | { FOR | FROM } ASYMMETRIC KEY asym_key_name
    }
 [ ; ]

<options_list> ::=
      DEFAULT_SCHEMA = schema_name
    | DEFAULT_LANGUAGE = { NONE | lcid | language name | language alias }
    | SID = sid
    | ALLOW_ENCRYPTED_VALUE_MODIFICATIONS = [ ON | OFF ] ]

<limited_options_list> ::=
      DEFAULT_SCHEMA = schema_name ]
    | ALLOW_ENCRYPTED_VALUE_MODIFICATIONS = [ ON | OFF ] ]

-- SQL Database syntax when connected to a federation member
CREATE USER user_name
[;]

-- Syntax for users based on Azure AD logins for Azure SQL Managed Instance
CREATE USER user_name
    [   { FOR | FROM } LOGIN login_name  ]
    | FROM EXTERNAL PROVIDER
    [ WITH <limited_options_list> [ ,... ] ]
[ ; ]

<limited_options_list> ::=
      DEFAULT_SCHEMA = schema_name
    | DEFAULT_LANGUAGE = { NONE | lcid | language name | language alias }
    | ALLOW_ENCRYPTED_VALUE_MODIFICATIONS = [ ON | OFF ] ]
----------------------------------------

CREATE WORKLOAD GROUP group_name
[ WITH
    ( [ IMPORTANCE = { LOW | MEDIUM | HIGH } ]
      [ [ , ] REQUEST_MAX_MEMORY_GRANT_PERCENT = value ]
      [ [ , ] REQUEST_MAX_CPU_TIME_SEC = value ]
      [ [ , ] REQUEST_MEMORY_GRANT_TIMEOUT_SEC = value ]
      [ [ , ] MAX_DOP = value ]
      [ [ , ] GROUP_MAX_REQUESTS = value ] )
 ]
[ USING {
    [ pool_name | "default" ]
    [ [ , ] EXTERNAL external_pool_name | "default" ] ]
    } ]
[ ; ]
----------------------------------------
--Create XML Index
CREATE [ PRIMARY ] XML INDEX index_name
    ON <object> ( xml_column_name )
    [ USING XML INDEX xml_index_name
        [ FOR { VALUE | PATH | PROPERTY } ] ]
    [ WITH ( <xml_index_option> [ ,...n ] ) ]
[ ; ]

<object> ::=
{ database_name.schema_name.table_name | schema_name.table_name | table_name }

<xml_index_option> ::=
{
    PAD_INDEX  = { ON | OFF }
  | FILLFACTOR = fillfactor
  | SORT_IN_TEMPDB = { ON | OFF }
  | IGNORE_DUP_KEY = OFF
  | DROP_EXISTING = { ON | OFF }
  | ONLINE = OFF
  | ALLOW_ROW_LOCKS = { ON | OFF }
  | ALLOW_PAGE_LOCKS = { ON | OFF }
  | MAXDOP = max_degree_of_parallelism
}
----------------------------------------

CREATE XML INDEX index_name
    ON <table_object> ( xml_column_name )
    USING XML INDEX sxi_index_name
    FOR ( <xquery_or_sql_values_path> )
    [WITH ( <index_options> )]

<table_object> ::=
{ database_name.schema_name.table_name | schema_name.table_name | table_name }

<xquery_or_sql_values_path>::=
<path_name>

<path_name> ::=
character string literal

<xmlnamespace_list> ::=
<xmlnamespace_item> [, <xmlnamespace_list>]

<xmlnamespace_item> ::=
xmlnamespace_uri AS xmlnamespace_prefix

<index_options> ::=
(
  | PAD_INDEX  = { ON | OFF }
  | FILLFACTOR = fillfactor
  | SORT_IN_TEMPDB = { ON | OFF }
  | IGNORE_DUP_KEY = OFF
  | DROP_EXISTING = { ON | OFF }
  | ONLINE = OFF
  | ALLOW_ROW_LOCKS = { ON | OFF }
  | ALLOW_PAGE_LOCKS = { ON | OFF }
  | MAXDOP = max_degree_of_parallelism
)
----------------------------------------
CREATE XML SCHEMA COLLECTION [ <relational_schema>. ]sql_identifier AS Expression
----------------------------------------
DROP AGGREGATE [ IF EXISTS ] [ schema_name . ] aggregate_name
----------------------------------------
DROP APPLICATION ROLE rolename
----------------------------------------
DROP ASSEMBLY [ IF EXISTS ] assembly_name [ ,...n ]
[ WITH NO DEPENDENTS ]
[ ; ]
----------------------------------------
DROP ASYMMETRIC KEY key_name [ REMOVE PROVIDER KEY ]
----------------------------------------
DROP AVAILABILITY GROUP group_name
[ ; ]
----------------------------------------
DROP BROKER PRIORITY ConversationPriorityName
[;]
----------------------------------------
DROP CERTIFICATE certificate_name
----------------------------------------
DROP COLUMN ENCRYPTION KEY key_name [;]
----------------------------------------
DROP COLUMN MASTER KEY key_name;

----------------------------------------
DROP CONTRACT contract_name
[ ; ]
----------------------------------------
DROP CREDENTIAL credential_name
----------------------------------------
DROP CRYPTOGRAPHIC PROVIDER provider_name
----------------------------------------
DROP DATABASE AUDIT SPECIFICATION audit_specification_name
[ ; ]
----------------------------------------
DROP DATABASE ENCRYPTION KEY
----------------------------------------
DROP DEFAULT [ IF EXISTS ] { [ schema_name . ] default_name } [ ,...n ] [ ; ]


----------------------------------------
DROP ENDPOINT endPointName
----------------------------------------
-- Drop an external data source
DROP EXTERNAL DATA SOURCE external_data_source_name
[;]
----------------------------------------
-- Drop an external file format
DROP EXTERNAL FILE FORMAT external_file_format_name
[;]
----------------------------------------
DROP EXTERNAL LANGUAGE <language_name>
----------------------------------------
DROP EXTERNAL LIBRARY library_name
[ AUTHORIZATION owner_name ];
----------------------------------------
DROP EXTERNAL RESOURCE POOL pool_name
----------------------------------------
DROP EXTERNAL TABLE { database_name.schema_name.table_name | schema_name.table_name | table_name }
[;]
----------------------------------------
DROP EVENT NOTIFICATION notification_name [ ,...n ]
ON { SERVER | DATABASE | QUEUE queue_name }
[ ; ]
----------------------------------------
DROP EVENT SESSION event_session_name
ON SERVER
----------------------------------------
DROP FULLTEXT CATALOG catalog_name
----------------------------------------
DROP FULLTEXT INDEX ON table_name
----------------------------------------
DROP FULLTEXT STOPLIST stoplist_name
;
----------------------------------------
-- SQL Server, Azure SQL Database

DROP FUNCTION [ IF EXISTS ] { [ schema_name. ] function_name } [ ,...n ]
[;]
----------------------------------------
-- Syntax for SQL Server (All options except filegroup and filestream apply to Azure SQL Database.)

DROP INDEX [ IF EXISTS ]
{ <drop_relational_or_xml_or_spatial_index> [ ,...n ]
| <drop_backward_compatible_index> [ ,...n ]
}

<drop_relational_or_xml_or_spatial_index> ::=
    index_name ON <object>
    [ WITH ( <drop_clustered_index_option> [ ,...n ] ) ]

<drop_backward_compatible_index> ::=
    [ owner_name. ] table_or_view_name.index_name

<object> ::=
{ database_name.schema_name.table_or_view_name | schema_name.table_or_view_name | table_or_view_name }

<drop_clustered_index_option> ::=
{
    MAXDOP = max_degree_of_parallelism
  | ONLINE = { ON | OFF }
  | MOVE TO { partition_scheme_name ( column_name )
            | filegroup_name
            | "default"
            }
  [ FILESTREAM_ON { partition_scheme_name
            | filestream_filegroup_name
            | "default" } ]
}
----------------------------------------
DROP INDEX index_name ON <object>
    [ WITH ( <drop_index_option> [ ,...n ] ) ]

<object> ::=
{ database_name.schema_name.table_or_view_name | schema_name.table_or_view_name | table_or_view_name }

<drop_index_option> ::=
{
    MAXDOP = max_degree_of_parallelism
    | ONLINE = { ON | OFF }
}


----------------------------------------
DROP LOGIN login_name
----------------------------------------
DROP MASTER KEY
----------------------------------------
DROP MESSAGE TYPE message_type_name
[ ; ]
----------------------------------------
DROP PARTITION FUNCTION partition_function_name [ ; ]
----------------------------------------
DROP PARTITION SCHEME partition_scheme_name [ ; ]
----------------------------------------
-- Syntax for SQL Server and Azure SQL Database

DROP { PROC | PROCEDURE } [ IF EXISTS ] { [ schema_name. ] procedure } [ ,...n ]
----------------------------------------
DROP QUEUE <object>
[ ; ]

<object> ::=
{ database_name.schema_name.queue_name | schema_name.queue_name | queue_name }
----------------------------------------
DROP REMOTE SERVICE BINDING binding_name
[ ; ]
----------------------------------------
DROP RESOURCE POOL pool_name
[ ; ]
----------------------------------------
-- Syntax for SQL Server

DROP ROLE [ IF EXISTS ] role_name
----------------------------------------
DROP ROUTE route_name
[ ; ]
----------------------------------------
DROP RULE [ IF EXISTS ] { [ schema_name . ] rule_name } [ ,...n ] [ ; ]
----------------------------------------
DROP SEARCH PROPERTY LIST property_list_name
;
----------------------------------------
DROP SECURITY POLICY [ IF EXISTS ] [schema_name. ] security_policy_name
[;]
----------------------------------------
DROP SENSITIVITY CLASSIFICATION FROM
    <object_name> [, ...n ]

<object_name> ::=
{
    [schema_name.]table_name.column_name
}
----------------------------------------
DROP SEQUENCE [ IF EXISTS ] { database_name.schema_name.sequence_name | schema_name.sequence_name | sequence_name } [ ,...n ]
 [ ; ]
----------------------------------------
DROP SERVER AUDIT audit_name
    [ ; ]
----------------------------------------
DROP SERVER AUDIT SPECIFICATION audit_specification_name
[ ; ]
----------------------------------------
DROP SERVER ROLE role_name
----------------------------------------
DROP SERVICE service_name
[ ; ]
----------------------------------------
DROP [ COUNTER ] SIGNATURE FROM module_name
    BY <crypto_list> [ ,...n ]

<crypto_list> ::=
    CERTIFICATE cert_name
    | ASYMMETRIC KEY Asym_key_name
----------------------------------------
-- Syntax for SQL Server and Azure SQL Database

DROP STATISTICS table.statistics_name | view.statistics_name [ ,...n ]
----------------------------------------
DROP SYMMETRIC KEY symmetric_key_name [REMOVE PROVIDER KEY]
----------------------------------------
DROP SYNONYM [ IF EXISTS ] [ schema. ] synonym_name
----------------------------------------
-- Syntax for SQL Server and Azure SQL Database

DROP TABLE [ IF EXISTS ] { database_name.schema_name.table_name | schema_name.table_name | table_name } [ ,...n ]
[ ; ]
----------------------------------------
-- Trigger on an INSERT, UPDATE, or DELETE statement to a table or view (DML Trigger)

DROP TRIGGER [ IF EXISTS ] [schema_name.]trigger_name [ ,...n ] [ ; ]

-- Trigger on a CREATE, ALTER, DROP, GRANT, DENY, REVOKE or UPDATE statement (DDL Trigger)

DROP TRIGGER [ IF EXISTS ] trigger_name [ ,...n ]
ON { DATABASE | ALL SERVER }
[ ; ]

-- Trigger on a LOGON event (Logon Trigger)

DROP TRIGGER [ IF EXISTS ] trigger_name [ ,...n ]
ON ALL SERVER
----------------------------------------
DROP TYPE [ IF EXISTS ] [ schema_name. ] type_name [ ; ]
----------------------------------------
-- Syntax for SQL Server and Azure SQL Database

DROP USER [ IF EXISTS ] user_name
----------------------------------------
-- Syntax for SQL Server, Azure SQL Database, and Azure Synapse Analytics

DROP VIEW [ IF EXISTS ] [ schema_name . ] view_name [ ...,n ] [ ; ]
----------------------------------------
DROP WORKLOAD GROUP group_name
[;]
----------------------------------------
DROP XML SCHEMA COLLECTION [ relational_schema. ]sql_identifier
----------------------------------------
ADD [ COUNTER ] SIGNATURE TO module_class::module_name
    BY <crypto_list> [ ,...n ]

<crypto_list> ::=
    CERTIFICATE cert_name
    | CERTIFICATE cert_name [ WITH PASSWORD = 'password' ]
    | CERTIFICATE cert_name WITH SIGNATURE = signed_blob
    | ASYMMETRIC KEY Asym_Key_Name
    | ASYMMETRIC KEY Asym_Key_Name [ WITH PASSWORD = 'password'.]
    | ASYMMETRIC KEY Asym_Key_Name WITH SIGNATURE = signed_blob
----------------------------------------
CLOSE MASTER KEY
----------------------------------------
CLOSE { SYMMETRIC KEY key_name | ALL SYMMETRIC KEYS }


----------------------------------------
-- Syntax for SQL Server and Azure SQL Database

-- Simplified syntax for DENY
DENY   { ALL [ PRIVILEGES ] }
     | <permission>  [ ( column [ ,...n ] ) ] [ ,...n ]
    [ ON [ <class> :: ] securable ]
    TO principal [ ,...n ]
    [ CASCADE] [ AS principal ]
[;]

<permission> ::=
{ see the tables below }

<class> ::=
{ see the tables below }
----------------------------------------
DENY { permission [ ,...n ] } ON ASSEMBLY :: assembly_name
    TO database_principal [ ,...n ]
        [ CASCADE ]
        [ AS denying_principal ]
----------------------------------------
DENY { permission  [ ,...n ] }
    ON ASYMMETRIC KEY :: asymmetric_key_name
        TO database_principal [ ,...n ]
    [ CASCADE ]
        [ AS denying_principal ]
----------------------------------------
DENY permission  [ ,...n ] ON AVAILABILITY GROUP :: availability_group_name
        TO < server_principal >  [ ,...n ]
    [ CASCADE ]
    [ AS SQL_Server_login ]

<server_principal> ::=
        SQL_Server_login
    | SQL_Server_login_from_Windows_login
    | SQL_Server_login_from_certificate
    | SQL_Server_login_from_AsymKey
----------------------------------------
DENY permission  [ ,...n ]
    ON CERTIFICATE :: certificate_name
    TO principal [ ,...n ]
    [ CASCADE ]
    [ AS denying_principal ]
----------------------------------------
DENY <permission> [ ,...n ]
    TO <database_principal> [ ,...n ] [ CASCADE ]
    [ AS <database_principal> ]

<permission> ::=
    permission | ALL [ PRIVILEGES ]

<database_principal> ::=
    Database_user
  | Database_role
  | Application_role
  | Database_user_mapped_to_Windows_User
  | Database_user_mapped_to_Windows_Group
  | Database_user_mapped_to_certificate
  | Database_user_mapped_to_asymmetric_key
  | Database_user_with_no_login
----------------------------------------
DENY permission [ ,...n ]
    ON
    {  [ USER :: database_user ]
     | [ ROLE :: database_role ]
     | [ APPLICATION ROLE :: application_role ]
    }
    TO <database_principal> [ ,...n ]
      [ CASCADE ]
      [ AS <database_principal> ]

<database_principal> ::=
    Database_user
  | Database_role
  | Application_role
  | Database_user_mapped_to_Windows_User
  | Database_user_mapped_to_Windows_Group
  | Database_user_mapped_to_certificate
  | Database_user_mapped_to_asymmetric_key
  | Database_user_with_no_login
----------------------------------------
DENY permission  [ ,...n ]
    ON DATABASE SCOPED CREDENTIAL :: credential_name
    TO principal [ ,...n ]
    [ CASCADE ]
    [ AS denying_principal ]
----------------------------------------
DENY permission  [ ,...n ] ON ENDPOINT :: endpoint_name
    TO < server_principal >  [ ,...n ]
    [ CASCADE ]
    [ AS SQL_Server_login ]

<server_principal> ::=
        SQL_Server_login
    | SQL_Server_login_from_Windows_login
    | SQL_Server_login_from_certificate
    | SQL_Server_login_from_AsymKey
----------------------------------------
DENY permission [ ,...n ] ON
    FULLTEXT
        {
           CATALOG :: full-text_catalog_name
           |
           STOPLIST :: full-text_stoplist_name
        }
    TO database_principal [ ,...n ] [ CASCADE ]
        [ AS denying_principal ]
----------------------------------------
DENY <permission> [ ,...n ] ON
    [ OBJECT :: ][ schema_name ]. object_name [ ( column [ ,...n ] ) ]
        TO <database_principal> [ ,...n ]
    [ CASCADE ]
        [ AS <database_principal> ]

<permission> ::=
    ALL [ PRIVILEGES ] | permission [ ( column [ ,...n ] ) ]

<database_principal> ::=
        Database_user
    | Database_role
    | Application_role
    | Database_user_mapped_to_Windows_User
    | Database_user_mapped_to_Windows_Group
    | Database_user_mapped_to_certificate
    | Database_user_mapped_to_asymmetric_key
    | Database_user_with_no_login
----------------------------------------
DENY permission  [ ,...n ] } ON SCHEMA :: schema_name
    TO database_principal [ ,...n ]
    [ CASCADE ]
        [ AS denying_principal ]
----------------------------------------
DENY permission [ ,...n ] ON
        SEARCH PROPERTY LIST :: search_property_list_name
    TO database_principal [ ,...n ] [ CASCADE ]
    [ AS denying_principal ]
----------------------------------------
DENY permission [ ,...n ]
    TO <grantee_principal> [ ,...n ]
    [ CASCADE ]
    [ AS <grantor_principal> ]

<grantee_principal> ::= SQL_Server_login
    | SQL_Server_login_mapped_to_Windows_login
    | SQL_Server_login_mapped_to_Windows_group
    | SQL_Server_login_mapped_to_certificate
    | SQL_Server_login_mapped_to_asymmetric_key
    | server_role

<grantor_principal> ::= SQL_Server_login
    | SQL_Server_login_mapped_to_Windows_login
    | SQL_Server_login_mapped_to_Windows_group
    | SQL_Server_login_mapped_to_certificate
    | SQL_Server_login_mapped_to_asymmetric_key
    | server_role
----------------------------------------
DENY permission [ ,...n ] }
    ON
    { [ LOGIN :: SQL_Server_login ]
      | [ SERVER ROLE :: server_role ] }
    TO <server_principal> [ ,...n ]
    [ CASCADE ]
    [ AS SQL_Server_login ]

<server_principal> ::=
    SQL_Server_login
    | SQL_Server_login_from_Windows_login
    | SQL_Server_login_from_certificate
    | SQL_Server_login_from_AsymKey
    | server_role
----------------------------------------
DENY permission  [ ,...n ] ON
    {
       [ CONTRACT :: contract_name ]
       | [ MESSAGE TYPE :: message_type_name ]
       | [ REMOTE SERVICE BINDING :: remote_binding_name ]
       | [ ROUTE :: route_name ]
       | [ SERVICE :: service_name ]
        }
    TO database_principal [ ,...n ]
    [ CASCADE ]
        [ AS denying_principal ]
----------------------------------------
DENY permission [ ,...n ]
    ON SYMMETRIC KEY :: symmetric_key_name
        TO <database_principal> [ ,...n ] [ CASCADE ]
    [ AS <database_principal> ]

<database_principal> ::=
        Database_user
    | Database_role
    | Application_role
    | Database_user_mapped_to_Windows_User
    | Database_user_mapped_to_Windows_Group
    | Database_user_mapped_to_certificate
    | Database_user_mapped_to_asymmetric_key
    | Database_user_with_no_login
----------------------------------------
DENY { SELECT | EXECUTE } ON [ sys.]system_object TO principal
----------------------------------------
DENY permission  [ ,...n ] ON TYPE :: [ schema_name . ] type_name
        TO <database_principal> [ ,...n ]
    [ CASCADE ]
    [ AS <database_principal> ]

<database_principal> ::=
        Database_user
    | Database_role
    | Application_role
    | Database_user_mapped_to_Windows_User
    | Database_user_mapped_to_Windows_Group
    | Database_user_mapped_to_certificate
    | Database_user_mapped_to_asymmetric_key
    | Database_user_with_no_login
----------------------------------------
DENY permission  [ ,...n ] ON
    XML SCHEMA COLLECTION :: [ schema_name . ]
    XML_schema_collection_name
    TO <database_principal> [ ,...n ]
        [ CASCADE ]
    [ AS <database_principal> ]

<database_principal> ::=
        Database_user
    | Database_role
    | Application_role
    | Database_user_mapped_to_Windows_User
    | Database_user_mapped_to_Windows_Group
    | Database_user_mapped_to_certificate
    | Database_user_mapped_to_asymmetric_key
    | Database_user_with_no_login
----------------------------------------
{ EXEC | EXECUTE } AS <context_specification>
[;]

<context_specification>::=
{ LOGIN | USER } = 'name'
    [ WITH { NO REVERT | COOKIE INTO @varbinary_variable } ]
| CALLER
----------------------------------------
-- SQL Server Syntax
Functions (except inline table-valued functions), Stored Procedures, and DML Triggers
{ EXEC | EXECUTE } AS { CALLER | SELF | OWNER | 'user_name' }

DDL Triggers with Database Scope
{ EXEC | EXECUTE } AS { CALLER | SELF | 'user_name' }

DDL Triggers with Server Scope and logon triggers
{ EXEC | EXECUTE } AS { CALLER | SELF | 'login_name' }

Queues
{ EXEC | EXECUTE } AS { SELF | OWNER | 'user_name' }
----------------------------------------
-- Syntax for SQL Server and Azure SQL Database

-- Simplified syntax for GRANT
GRANT { ALL [ PRIVILEGES ] }
      | permission [ ( column [ ,...n ] ) ] [ ,...n ]
      [ ON [ class :: ] securable ] TO principal [ ,...n ]
      [ WITH GRANT OPTION ] [ AS principal ]
----------------------------------------
GRANT { permission [ ,...n ] } ON ASSEMBLY :: assembly_name
    TO database_principal [ ,...n ]
    [ WITH GRANT OPTION ]
    [ AS granting_principal ]
----------------------------------------
GRANT { permission  [ ,...n ] }
    ON ASYMMETRIC KEY :: asymmetric_key_name
       TO database_principal [ ,...n ]
    [ WITH GRANT OPTION ]
    [ AS granting_principal ]
----------------------------------------
GRANT permission  [ ,...n ] ON AVAILABILITY GROUP :: availability_group_name
        TO < server_principal >  [ ,...n ]
    [ WITH GRANT OPTION ]
    [ AS SQL_Server_login ]

<server_principal> ::=
        SQL_Server_login
    | SQL_Server_login_from_Windows_login
    | SQL_Server_login_from_certificate
    | SQL_Server_login_from_AsymKey
----------------------------------------
GRANT permission  [ ,...n ]
    ON CERTIFICATE :: certificate_name
    TO principal [ ,...n ] [ WITH GRANT OPTION ]
    [ AS granting_principal ]
----------------------------------------
GRANT <permission> [ ,...n ]
    TO <database_principal> [ ,...n ] [ WITH GRANT OPTION ]
    [ AS <database_principal> ]

<permission>::=
permission | ALL [ PRIVILEGES ]

<database_principal> ::=
    Database_user
  | Database_role
  | Application_role
  | Database_user_mapped_to_Windows_User
  | Database_user_mapped_to_Windows_Group
  | Database_user_mapped_to_certificate
  | Database_user_mapped_to_asymmetric_key
  | Database_user_with_no_login
----------------------------------------
GRANT permission [ ,...n ]
    ON
    {  [ USER :: database_user ]
     | [ ROLE :: database_role ]
     | [ APPLICATION ROLE :: application_role ]
    }
    TO <database_principal> [ ,...n ]
       [ WITH GRANT OPTION ]
       [ AS <database_principal> ]

<database_principal> ::=
    Database_user
  | Database_role
  | Application_role
  | Database_user_mapped_to_Windows_User
  | Database_user_mapped_to_Windows_Group
  | Database_user_mapped_to_certificate
  | Database_user_mapped_to_asymmetric_key
  | Database_user_with_no_login
----------------------------------------
GRANT permission  [ ,...n ]
    ON DATABASE SCOPED CREDENTIAL :: credential_name
    TO principal [ ,...n ] [ WITH GRANT OPTION ]
    [ AS granting_principal ]
----------------------------------------
GRANT permission  [ ,...n ] ON ENDPOINT :: endpoint_name
        TO < server_principal >  [ ,...n ]
    [ WITH GRANT OPTION ]
    [ AS SQL_Server_login ]

<server_principal> ::=
        SQL_Server_login
    | SQL_Server_login_from_Windows_login
    | SQL_Server_login_from_certificate
    | SQL_Server_login_from_AsymKey
----------------------------------------
GRANT permission [ ,...n ] ON
    FULLTEXT
        {
           CATALOG :: full-text_catalog_name
           |
           STOPLIST :: full-text_stoplist_name
        }
    TO database_principal [ ,...n ]
    [ WITH GRANT OPTION ]
    [ AS granting_principal ]
----------------------------------------
GRANT <permission> [ ,...n ] ON
    [ OBJECT :: ][ schema_name ]. object_name [ ( column [ ,...n ] ) ]
    TO <database_principal> [ ,...n ]
    [ WITH GRANT OPTION ]
    [ AS <database_principal> ]

<permission> ::=
    ALL [ PRIVILEGES ] | permission [ ( column [ ,...n ] ) ]

<database_principal> ::=
        Database_user
    | Database_role
    | Application_role
    | Database_user_mapped_to_Windows_User
    | Database_user_mapped_to_Windows_Group
    | Database_user_mapped_to_certificate
    | Database_user_mapped_to_asymmetric_key
    | Database_user_with_no_login
----------------------------------------
GRANT permission  [ ,...n ] ON SCHEMA :: schema_name
    TO database_principal [ ,...n ]
    [ WITH GRANT OPTION ]
    [ AS granting_principal ]
----------------------------------------
GRANT permission [ ,...n ] ON
    SEARCH PROPERTY LIST :: search_property_list_name
    TO database_principal [ ,...n ]
    [ WITH GRANT OPTION ]
    [ AS granting_principal ]
----------------------------------------
GRANT permission [ ,...n ]
    TO <grantee_principal> [ ,...n ] [ WITH GRANT OPTION ]
    [ AS <grantor_principal> ]

<grantee_principal> ::= SQL_Server_login
    | SQL_Server_login_mapped_to_Windows_login
    | SQL_Server_login_mapped_to_Windows_group
    | SQL_Server_login_mapped_to_certificate
    | SQL_Server_login_mapped_to_asymmetric_key
    | server_role

<grantor_principal> ::= SQL_Server_login
    | SQL_Server_login_mapped_to_Windows_login
    | SQL_Server_login_mapped_to_Windows_group
    | SQL_Server_login_mapped_to_certificate
    | SQL_Server_login_mapped_to_asymmetric_key
    | server_role
----------------------------------------
GRANT permission [ ,...n ] }
    ON
    { [ LOGIN :: SQL_Server_login ]
      | [ SERVER ROLE :: server_role ] }
    TO <server_principal> [ ,...n ]
    [ WITH GRANT OPTION ]
    [ AS SQL_Server_login ]

<server_principal> ::=
    SQL_Server_login
    | SQL_Server_login_from_Windows_login
    | SQL_Server_login_from_certificate
    | SQL_Server_login_from_AsymKey
    | server_role
----------------------------------------
GRANT permission  [ ,...n ] ON
    {
              [ CONTRACT :: contract_name ]
       | [ MESSAGE TYPE :: message_type_name ]
       | [ REMOTE SERVICE BINDING :: remote_binding_name ]
       | [ ROUTE :: route_name ]
       | [ SERVICE :: service_name ]
    }
    TO database_principal [ ,...n ]
    [ WITH GRANT OPTION ]
        [ AS granting_principal ]

----------------------------------------
GRANT permission [ ,...n ]
    ON SYMMETRIC KEY :: symmetric_key_name
    TO <database_principal> [ ,...n ] [ WITH GRANT OPTION ]
        [ AS <database_principal> ]

<database_principal> ::=
        Database_user
    | Database_role
    | Application_role
    | Database_user_mapped_to_Windows_User
    | Database_user_mapped_to_Windows_Group
    | Database_user_mapped_to_certificate
    | Database_user_mapped_to_asymmetric_key
    | Database_user_with_no_login
----------------------------------------
GRANT { SELECT | EXECUTE } ON [ sys.]system_object TO principal
----------------------------------------
GRANT permission  [ ,...n ] ON TYPE :: [ schema_name . ] type_name
    TO <database_principal> [ ,...n ]
    [ WITH GRANT OPTION ]
    [ AS <database_principal> ]

<database_principal> ::=
        Database_user
    | Database_role
        | Application_role
    | Database_user_mapped_to_Windows_User
    | Database_user_mapped_to_Windows_Group
    | Database_user_mapped_to_certificate
    | Database_user_mapped_to_asymmetric_key
    | Database_user_with_no_login
----------------------------------------
GRANT permission  [ ,...n ] ON
    XML SCHEMA COLLECTION :: [ schema_name . ]
    XML_schema_collection_name
    TO <database_principal> [ ,...n ]
    [ WITH GRANT OPTION ]
    [ AS <database_principal> ]

<database_principal> ::=
        Database_user
    | Database_role
    | Application_role
    | Database_user_mapped_to_Windows_User
    | Database_user_mapped_to_Windows_Group
    | Database_user_mapped_to_certificate
    | Database_user_mapped_to_asymmetric_key
    | Database_user_with_no_login
----------------------------------------
OPEN MASTER KEY DECRYPTION BY PASSWORD = 'password'
----------------------------------------
OPEN SYMMETRIC KEY Key_name DECRYPTION BY <decryption_mechanism>

<decryption_mechanism> ::=
    CERTIFICATE certificate_name [ WITH PASSWORD = 'password' ]
    |
    ASYMMETRIC KEY asym_key_name [ WITH PASSWORD = 'password' ]
    |
    SYMMETRIC KEY decrypting_Key_name
    |
    PASSWORD = 'decryption_password'
----------------------------------------
REVERT
    [ WITH COOKIE = @varbinary_variable ]
----------------------------------------
-- Syntax for SQL Server and Azure SQL Database

-- Simplified syntax for REVOKE
REVOKE [ GRANT OPTION FOR ]
      {
        [ ALL [ PRIVILEGES ] ]
        |
                permission [ ( column [ ,...n ] ) ] [ ,...n ]
      }
      [ ON [ class :: ] securable ]
      { TO | FROM } principal [ ,...n ]
      [ CASCADE] [ AS principal ]
----------------------------------------
REVOKE [ GRANT OPTION FOR ] permission [ ,...n ]
    ON ASSEMBLY :: assembly_name
    { TO | FROM } database_principal [ ,...n ]
    [ CASCADE ]
    [ AS revoking_principal ]
----------------------------------------
REVOKE [ GRANT OPTION FOR ] { permission  [ ,...n ] }
    ON ASYMMETRIC KEY :: asymmetric_key_name
    { TO | FROM } database_principal [ ,...n ]
    [ CASCADE ]
    [ AS revoking_principal ]
----------------------------------------
REVOKE [ GRANT OPTION FOR ] permission  [ ,...n ]
    ON AVAILABILITY GROUP :: availability_group_name
    { FROM | TO } < server_principal >  [ ,...n ]
    [ CASCADE ]
    [ AS SQL_Server_login ]

<server_principal> ::=
        SQL_Server_login
    | SQL_Server_login_from_Windows_login
    | SQL_Server_login_from_certificate
    | SQL_Server_login_from_AsymKey


----------------------------------------
REVOKE [ GRANT OPTION FOR ] permission  [ ,...n ]
    ON CERTIFICATE :: certificate_name
    { TO | FROM } database_principal [ ,...n ]
    [ CASCADE ]
    [ AS revoking_principal ]
----------------------------------------
REVOKE [ GRANT OPTION FOR ] <permission> [ ,...n ]
    { TO | FROM } <database_principal> [ ,...n ]
        [ CASCADE ]
    [ AS <database_principal> ]

<permission> ::=
permission | ALL [ PRIVILEGES ]

<database_principal> ::=
      Database_user
    | Database_role
    | Application_role
    | Database_user_mapped_to_Windows_User
    | Database_user_mapped_to_Windows_Group
    | Database_user_mapped_to_certificate
    | Database_user_mapped_to_asymmetric_key
    | Database_user_with_no_login
----------------------------------------
REVOKE [ GRANT OPTION FOR ] permission [ ,...n ]
    ON
    {  [ USER :: database_user ]
       | [ ROLE :: database_role ]
       | [ APPLICATION ROLE :: application_role ]
    }
    { FROM | TO } <database_principal> [ ,...n ]
        [ CASCADE ]
    [ AS <database_principal> ]

<database_principal> ::=
        Database_user
    | Database_role
    | Application_role
    | Database_user_mapped_to_Windows_User
    | Database_user_mapped_to_Windows_Group
    | Database_user_mapped_to_certificate
    | Database_user_mapped_to_asymmetric_key
    | Database_user_with_no_login
----------------------------------------
REVOKE [ GRANT OPTION FOR ] permission  [ ,...n ]
    ON DATABASE SCOPED CREDENTIAL :: credential_name
    { TO | FROM } database_principal [ ,...n ]
    [ CASCADE ]
    [ AS revoking_principal ]
----------------------------------------
REVOKE [ GRANT OPTION FOR ] permission [ ,...n ]
    ON ENDPOINT :: endpoint_name
    { FROM | TO } <server_principal> [ ,...n ]
    [ CASCADE ]
    [ AS SQL_Server_login ]

<server_principal> ::=
        SQL_Server_login
    | SQL_Server_login_from_Windows_login
    | SQL_Server_login_from_certificate
    | SQL_Server_login_from_AsymKey
----------------------------------------
REVOKE [ GRANT OPTION FOR ] permission [ ,...n ] ON
    FULLTEXT
        {
           CATALOG :: full-text_catalog_name
           |
           STOPLIST :: full-text_stoplist_name
        }
    { TO | FROM } database_principal [ ,...n ]
    [ CASCADE ]
    [ AS revoking_principal ]
----------------------------------------
REVOKE [ GRANT OPTION FOR ] <permission> [ ,...n ] ON
    [ OBJECT :: ][ schema_name ]. object_name [ ( column [ ,...n ] ) ]
        { FROM | TO } <database_principal> [ ,...n ]
    [ CASCADE ]
    [ AS <database_principal> ]

<permission> ::=
    ALL [ PRIVILEGES ] | permission [ ( column [ ,...n ] ) ]

<database_principal> ::=
        Database_user
    | Database_role
    | Application_role
    | Database_user_mapped_to_Windows_User
    | Database_user_mapped_to_Windows_Group
    | Database_user_mapped_to_certificate
    | Database_user_mapped_to_asymmetric_key
    | Database_user_with_no_login
----------------------------------------
REVOKE [ GRANT OPTION FOR ] permission  [ ,...n ]
    ON SCHEMA :: schema_name
    { TO | FROM } database_principal [ ,...n ]
    [ CASCADE ]
    [ AS revoking_principal ]
----------------------------------------
REVOKE [ GRANT OPTION FOR ] permission [ ,...n ] ON
        SEARCH PROPERTY LIST :: search_property_list_name
    { TO | FROM } database_principal [ ,...n ]
    [ CASCADE ]
    [ AS revoking_principal ]
----------------------------------------
REVOKE [ GRANT OPTION FOR ] permission  [ ,...n ]
    { TO | FROM } <grantee_principal> [ ,...n ]
        [ CASCADE ]
    [ AS <grantor_principal> ]

<grantee_principal> ::= SQL_Server_login
        | SQL_Server_login_mapped_to_Windows_login
    | SQL_Server_login_mapped_to_Windows_group
    | SQL_Server_login_mapped_to_certificate
    | SQL_Server_login_mapped_to_asymmetric_key
    | server_role

<grantor_principal> ::= SQL_Server_login
    | SQL_Server_login_mapped_to_Windows_login
    | SQL_Server_login_mapped_to_Windows_group
    | SQL_Server_login_mapped_to_certificate
    | SQL_Server_login_mapped_to_asymmetric_key
    | server_role
----------------------------------------
REVOKE [ GRANT OPTION FOR ] permission [ ,...n ] }
    ON
    { [ LOGIN :: SQL_Server_login ]
      | [ SERVER ROLE :: server_role ] }
    { FROM | TO } <server_principal> [ ,...n ]
    [ CASCADE ]
    [ AS SQL_Server_login ]

<server_principal> ::=
    SQL_Server_login
    | SQL_Server_login_from_Windows_login
    | SQL_Server_login_from_certificate
    | SQL_Server_login_from_AsymKey
    | server_role
----------------------------------------
REVOKE [ GRANT OPTION FOR ] permission [ ,...n ] ON
    {
       [ CONTRACT :: contract_name ]
       | [ MESSAGE TYPE :: message_type_name ]
       | [ REMOTE SERVICE BINDING :: remote_binding_name ]
       | [ ROUTE :: route_name ]
       | [ SERVICE :: service_name ]
        }
    { TO | FROM } database_principal [ ,...n ]
    [ CASCADE ]
    [ AS revoking_principal ]
----------------------------------------
REVOKE [ GRANT OPTION FOR ] permission [ ,...n ]
    ON SYMMETRIC KEY :: symmetric_key_name
        { TO | FROM } <database_principal> [ ,...n ]
    [ CASCADE ]
    [ AS <database_principal> ]

<database_principal> ::=
        Database_user
    | Database_role
    | Application_role
    | Database_user_mapped_to_Windows_User
    | Database_user_mapped_to_Windows_Group
    | Database_user_mapped_to_certificate
    | Database_user_mapped_to_asymmetric_key
    | Database_user_with_no_login
----------------------------------------
REVOKE { SELECT | EXECUTE } ON [sys.]system_object FROM principal


----------------------------------------
REVOKE [ GRANT OPTION FOR ] permission [ ,...n ]
    ON TYPE :: [ schema_name ]. type_name
    { FROM | TO } <database_principal> [ ,...n ]
    [ CASCADE ]
    [ AS <database_principal> ]

<database_principal> ::=
      Database_user
    | Database_role
    | Application_role
    | Database_user_mapped_to_Windows_User
    | Database_user_mapped_to_Windows_Group
    | Database_user_mapped_to_certificate
    | Database_user_mapped_to_asymmetric_key
    | Database_user_with_no_login
----------------------------------------
REVOKE [ GRANT OPTION FOR ] permission [ ,...n ] ON
    XML SCHEMA COLLECTION :: [ schema_name . ]
    XML_schema_collection_name
    { TO | FROM } <database_principal> [ ,...n ]
        [ CASCADE ]
    [ AS <database_principal> ]

<database_principal> ::=
        Database_user
    | Database_role
    | Application_role
    | Database_user_mapped_to_Windows_User
    | Database_user_mapped_to_Windows_Group
    | Database_user_mapped_to_certificate
    | Database_user_mapped_to_asymmetric_key
    | Database_user_with_no_login
----------------------------------------
SETUSER [ 'username' [ WITH NORESET ] ]
----------------------------------------
SET
----------------------------------------
----------------------------------------
----------------------------------------
----------------------------------------
----------------------------------------
----------------------------------------
----------------------------------------
----------------------------------------
----------------------------------------
----------------------------------------


*)
