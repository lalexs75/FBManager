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
    SCHEMA
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
    SCHEMA
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

  { TPGSQLCommentOn }

  { TMSSQLCommentOn }

  TMSSQLCommentOn = class(TSQLCommentOn)
  protected
    procedure MakeSQL;override;
  public
    property TableName;
    property SchemaName;
  end;

implementation

uses SQLEngineCommonTypesUnit;

{ TMSSQLCommentOn }

procedure TMSSQLCommentOn.MakeSQL;
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
        if Description = '' then
          AddSQLCommandEx('EXEC sp_dropextendedproperty ''MS_Description'', N''schema'', N''%s'', N''table'', N''%s'', N''column'', N''%s''', [SchemaName, TableName, Name])
        else
          AddSQLCommandEx('EXEC sp_addextendedproperty ''MS_Description'', N%s, N''schema'', N''%s'', N''table'', N''%s'', N''column'', N''%s''', [QuotedStr(Description), SchemaName, TableName, Name]);
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

