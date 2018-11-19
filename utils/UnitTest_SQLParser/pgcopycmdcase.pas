unit PGCopyCmdCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, pg_SqlParserUnit,
  fbmSqlParserUnit, sqlObjects;

type

  { TPGCopyCmdCase }

  TPGCopyCmdCase= class(TTestCase)
  protected
    procedure DoTest(FCmd:TSQLCommandAbstract);
  published
    procedure CopyDO;
    procedure DomainCreate;
    procedure DomainAlter;
    procedure DomainDrop;
    procedure Vacum;
    procedure Truncate;
    procedure StartTransaction;
    procedure Commit;
    procedure SQLEnd;
    procedure Rollback;
  end;

implementation
(*
RegisterSQLStatment(TSQLEnginePostgre, TSqlCommandSelect, 'SELECT'); //SELECT — получить строки из таблицы или представления
                                                                     //SELECT INTO — создать таблицу из результатов запроса
RegisterSQLStatment(TSQLEnginePostgre, TSQLCommandInsert, 'INSERT INTO');
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCommandUpdate, 'UPDATE');   //UPDATE — изменить строки таблицы
RegisterSQLStatment(TSQLEnginePostgre, TSQLCommandDelete, 'DELETE FROM'); //DELETE — удалить записи таблицы

ALTER GROUP — изменить имя роли или членство
ALTER MATERIALIZED VIEW — изменить определение материализованного представления
ALTER POLICY — изменить определение политики защиты на уровне строк
ALTER ROLE — изменить роль в базе данных
ALTER SYSTEM — изменить параметр конфигурации сервера
ALTER USER — изменить роль в базе данных
ALTER USER MAPPING — изменить определение сопоставления пользователей

COMMIT — зафиксировать текущую транзакцию
COMMIT PREPARED — зафиксировать транзакцию, которая ранее была подготовлена для двухфазной фиксации

CREATE ACCESS METHOD — создать новый метод доступа
CREATE GROUP — создать роль в базе данных
CREATE MATERIALIZED VIEW — создать материализованное представление
CREATE POLICY — создать новую политику защиты на уровне строк для таблицы
CREATE ROLE — создать роль в базе данных
CREATE TRANSFORM — создать трансформацию
CREATE USER — создать роль в базе данных
CREATE USER MAPPING — создать сопоставление пользователя для стороннего сервера

DROP ACCESS METHOD — удалить метод доступа
DROP GROUP — удалить роль в базе данных
DROP MATERIALIZED VIEW — удалить материализованное представление
DROP POLICY — удалить политику защиты на уровне строк для таблицы
DROP ROLE — удалить роль в базе данных
DROP TRANSFORM — удалить трансформацию
DROP USER — удалить роль в базе данных
DROP USER MAPPING — удалить сопоставление пользователя для стороннего сервера


IMPORT FOREIGN SCHEMA — импортировать определения таблиц со стороннего сервера
INSERT — добавить строки в таблицу
REFRESH MATERIALIZED VIEW — заменить содержимое материализованного представления


RegisterSQLStatment(TSQLEnginePostgre, TPGSQLVacum, 'VACUM');  //VACUUM — провести сборку мусора и, возможно, проанализировать базу данных
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLTruncate, 'TRUNCATE'); //TRUNCATE — опустошить таблицу или набор таблиц
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLStartTransaction, 'START TRANSACTION'); //START TRANSACTION — начать блок транзакции
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCommit, 'COMMIT');
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLEnd, 'END');  //END — зафиксировать текущую транзакцию
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLRollback, 'ROLLBACK'); //ROLLBACK — прервать текущую транзакцию
                                                                    //ROLLBACK PREPARED — отменить транзакцию, которая ранее была подготовлена для двухфазной фиксации
                                                                    //ROLLBACK TO SAVEPOINT — откатиться к точке сохранения
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAbort, 'ABORT');       //ABORT — прервать текущую транзакцию
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLBegin, 'BEGIN');       //BEGIN — начать блок транзакции
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLClose, 'CLOSE');       //CLOSE — закрыть курсор
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCheckpoint, 'CHECKPOINT'); //CHECKPOINT — записать контрольную точку в журнал транзакций
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLSet, 'SET');               //SET — изменить параметр времени выполнения
                                                                        //SET CONSTRAINTS — установить время проверки ограничений для текущей транзакции
                                                                        //SET ROLE — установить идентификатор текущего пользователя в рамках сеанса
                                                                        //SET SESSION AUTHORIZATION — установить идентификатор пользователя сеанса и идентификатор текущего пользователя в рамках сеанса
                                                                        //SET TRANSACTION — установить характеристики текущей транзакции
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLShow, 'SHOW');             //
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAnalyze, 'ANALYZE');       //ANALYZE — собрать статистику по базе данных
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCluster, 'CLUSTER');       //CLUSTER — кластеризовать таблицу согласно индексу
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCopy, 'COPY');             //COPY — копировать данные между файлом и таблицей
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDeallocate, 'DEALLOCATE'); //DEALLOCATE — освободить подготовленный оператор
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDiscard, 'DISCARD');       //DISCARD — очистить состояние сеанса
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDeclare, 'DECLARE');       //DECLARE — определить курсор
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLValues, 'VALUES');         //VALUES — вычислить набор строк
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLReindex, 'REINDEX');       //REINDEX — перестроить индексы
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLUnlisten, 'UNLISTEN');     //UNLISTEN — прекратить ожидание уведомления
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLExecute, 'EXECUTE');       //EXECUTE — выполнить подготовленный оператор
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLExplain, 'EXPLAIN');       //EXPLAIN — показать план выполнения оператора
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLFetch, 'FETCH');           //FETCH — получить результат запроса через курсор
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLListen, 'LISTEN');         //LISTEN — ожидать уведомления
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLLock, 'LOCK');             //LOCK — заблокировать таблицу
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLLoad, 'LOAD');             //LOAD — загрузить файл разделяемой библиотеки
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLMove, 'MOVE');             //MOVE — переместить курсор
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLNotify, 'NOTIFY');         //NOTIFY — сгенерировать уведомление
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLPrepare, 'PREPARE');       //PREPARE — подготовить оператор к выполнению
                                                                        //PREPARE TRANSACTION — подготовить текущую транзакцию для двухфазной фиксации
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLReassignOwned, 'REASSIGN OWNED'); //REASSIGN OWNED — сменить владельца объектов базы данных, принадлежащих заданной роли
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLReleaseSavepoint, 'RELEASE SAVEPOINT'); //RELEASE SAVEPOINT — высвободить ранее определённую точку сохранения
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLSavepoint, 'SAVEPOINT');   //SAVEPOINT — определить новую точку сохранения в текущей транзакции
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLReset, 'RESET');           //RESET — восстановить значение по умолчанию заданного параметра времени выполнения
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLSecurityLabel, 'SECURITY LABEL'); //SECURITY LABEL — определить или изменить метку безопасности, применённую к объекту
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLGrant, 'GRANT');           //GRANT — определить права доступа
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLRevoke, 'REVOKE');         //REVOKE — отозвать права доступа
RegisterSQLStatment(TSQLEnginePostgre, TPGPLSQLReturn, 'RETURN');
RegisterSQLStatment(TSQLEnginePostgre, TPGPLSQLRaise, 'RAISE');
RegisterSQLStatment(TSQLEnginePostgre, TPGPLSQLPerform, 'PERFORM');

///DDL
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterDefaultPrivileges, 'ALTER DEFAULT PRIVILEGES'); //ALTER DEFAULT PRIVILEGES — определить права доступа по умолчанию
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterLargeObject, 'ALTER LARGE OBJECT');   //ALTER LARGE OBJECT — изменить определение большого объекта

RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateAggregate, 'CREATE AGGREGATE'); //CREATE AGGREGATE — создать агрегатную функцию
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterAggregate, 'ALTER AGGREGATE');   //ALTER AGGREGATE — изменить определение агрегатной функции
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropAggregate, 'DROP AGGREGATE');     //DROP AGGREGATE — удалить агрегатную функцию

RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateCast, 'CREATE CAST');     //CREATE CAST — создать приведение
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropCast, 'DROP CAST');         //DROP CAST — удалить приведение типа

RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropOwned, 'DROP OWNED');       //DROP OWNED — удалить объекты базы данных, принадлежащие роли

RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateCollation, 'CREATE COLLATION');  //CREATE COLLATION — создать правило сортировки
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterCollation, 'ALTER COLLATION');    //ALTER COLLATION — изменить определение правила сортировки
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropCollation, 'DROP COLLATION');      //DROP COLLATION — удалить правило сортировки

RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterConversion, 'ALTER CONVERSION');   //ALTER CONVERSION — изменить определение перекодировки
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateConversion, 'CREATE CONVERSION'); //CREATE CONVERSION — создать перекодировку
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropConversion, 'DROP CONVERSION');     //DROP CONVERSION — удалить преобразование

RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateDatabase, 'CREATE DATABASE');     //CREATE DATABASE — создать базу данных
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterDatabase, 'ALTER DATABASE');       //ALTER DATABASE — изменить атрибуты базы данных
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropDatabase, 'DROP DATABASE');         //DROP DATABASE — удалить базу данных

//OPERATOR
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterOperator, 'ALTER OPERATOR');       //ALTER OPERATOR — изменить определение оператора
                                                                                     //ALTER OPERATOR CLASS — изменить определение класса операторов
                                                                                     //ALTER OPERATOR FAMILY — изменить определение семейства операторов
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateOperator, 'CREATE OPERATOR');     //CREATE OPERATOR — создать оператор
                                                                                     //CREATE OPERATOR CLASS — создать класс операторов
                                                                                     //CREATE OPERATOR FAMILY — создать семейство операторов
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropOperator, 'DROP OPERATOR');         //DROP OPERATOR — удалить оператор
                                                                                     //DROP OPERATOR CLASS — удалить класс операторов
                                                                                     //DROP OPERATOR FAMILY — удалить семейство операторов
//TEXT SEARCH
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterTextSearch, 'ALTER TEXT SEARCH');  //ALTER TEXT SEARCH CONFIGURATION — изменить определение конфигурации текстового поиска
                                                                                     //ALTER TEXT SEARCH DICTIONARY — изменить определение словаря текстового поиска
                                                                                     //ALTER TEXT SEARCH PARSER — изменить определение анализатора текстового поиска
                                                                                     //ALTER TEXT SEARCH TEMPLATE — изменить определение шаблона текстового поиска

RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateTextSearchConfig, 'CREATE TEXT SEARCH CONFIGURATION');  //CREATE TEXT SEARCH CONFIGURATION — создать конфигурацию текстового поиска
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateTextSearchDictionary, 'CREATE TEXT SEARCH DICTIONARY'); //CREATE TEXT SEARCH DICTIONARY — создать словарь текстового поиска
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateTextSearchParser, 'CREATE TEXT SEARCH PARSER'); //CREATE TEXT SEARCH PARSER — создать анализатор текстового поиска
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateTextSearchTemplate, 'CREATE TEXT SEARCH TEMPLATE');//CREATE TEXT SEARCH TEMPLATE — создать шаблон текстового поиска

RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropTextSearch, 'DROP TEXT SEARCH');    //DROP TEXT SEARCH CONFIGURATION — удалить конфигурацию текстового поиска
                                                                                     //DROP TEXT SEARCH DICTIONARY — удалить словарь текстового поиска
                                                                                     //DROP TEXT SEARCH PARSER — удалить анализатор текстового поиска
                                                                                     //DROP TEXT SEARCH TEMPLATE — удалить шаблон текстового поиска
//DOMAIN

//EXTENSION
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterExtension, 'ALTER EXTENSION');      //ALTER EXTENSION — изменить определение расширения
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateExtension, 'CREATE EXTENSION');    //CREATE EXTENSION — установить расширение
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropExtension, 'DROP EXTENSION');        //DROP EXTENSION — удалить расширение

//FOREIGN TABLE
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterForeignTable, 'ALTER FOREIGN TABLE'); //ALTER FOREIGN TABLE — изменить определение сторонней таблицы
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateForeignTable, 'CREATE FOREIGN TABLE'); //CREATE FOREIGN TABLE — создать стороннюю таблицу
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropForeignTable, 'DROP FOREIGN TABLE'); //DROP FOREIGN TABLE — удалить стороннюю таблицу

//FOREIGN DATA WRAPPER
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterForeignDataWrapper, 'ALTER FOREIGN DATA WRAPPER');   //ALTER FOREIGN DATA WRAPPER — изменить определение обёртки сторонних данных
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateForeignDataWrapper, 'CREATE FOREIGN DATA WRAPPER'); //CREATE FOREIGN DATA WRAPPER — создать новую обёртку сторонних данных
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropForeignDataWrapper, 'DROP FOREIGN DATA WRAPPER');     //DROP FOREIGN DATA WRAPPER — удалить обёртку сторонних данных

//LANGUAGE
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterLanguage, 'ALTER LANGUAGE');        //ALTER LANGUAGE — изменить определение процедурного языка
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateLanguage, 'CREATE LANGUAGE');      //CREATE LANGUAGE — создать процедурный язык
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropLanguage, 'DROP LANGUAGE');          //DROP LANGUAGE — удалить процедурный язык

//SERVER
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterServer, 'ALTER SERVER');            //ALTER SERVER — изменить определение стороннего сервера
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateServer, 'CREATE SERVER');          //CREATE SERVER — создать сторонний сервер
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropServer, 'DROP SERVER');              //DROP SERVER — удалить описание стороннего сервера

//TYPE
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterType, 'ALTER TYPE');               //ALTER TYPE — изменить определение типа
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateType, 'CREATE TYPE');             //CREATE TYPE — создать новый тип данных
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropType, 'DROP TYPE');                 //DROP TYPE — удалить тип данных

//TABLESPACE
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateTablespace, 'CREATE TABLESPACE'); //CREATE TABLESPACE — создать табличное пространство
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterTablespace, 'ALTER TABLESPACE');   //ALTER TABLESPACE — изменить определение табличного пространства
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropTablespace, 'DROP TABLESPACE');     //DROP TABLESPACE — удалить табличное пространство

//VIEW
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateView, 'CREATE VIEW');             //CREATE VIEW — создать представление
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterView, 'ALTER VIEW');               //ALTER VIEW — изменить определение представления
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropView, 'DROP VIEW');                 //DROP VIEW — удалить представление

RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateMaterializedView, 'CREATE MATERIALIZED VIEW');  //CREATE MATERIALIZED VIEW — создать материализованное представление
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropMaterializedView, 'DROP MATERIALIZED VIEW');      //DROP MATERIALIZED VIEW — удалить материализованное представление

//FUNCTION
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateFunction, 'CREATE FUNCTION');     //CREATE FUNCTION — создать функцию
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterFunction, 'ALTER FUNCTION');       //ALTER FUNCTION — изменить определение функции
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropFunction, 'DROP FUNCTION');         //DROP FUNCTION — удалить функцию

//TRIGGER
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateTrigger, 'CREATE TRIGGER');       //CREATE TRIGGER — создать триггер
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterTrigger, 'ALTER TRIGGER');         //ALTER TRIGGER — изменить определение триггера
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropTrigger, 'DROP TRIGGER');           //DROP TRIGGER — удалить триггер

//EVENT TRIGGER
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateEventTrigger, 'CREATE EVENT TRIGGER'); //CREATE EVENT TRIGGER — создать событийный триггер
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterEventTrigger, 'ALTER EVENT TRIGGER');   //ALTER EVENT TRIGGER — изменить определение событийного триггера
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropEventTrigger, 'DROP EVENT TRIGGER');     //DROP EVENT TRIGGER — удалить событийный триггер

//TABLE
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateTable, 'CREATE TABLE');           //CREATE TABLE — создать таблицу
                                                                                     //CREATE TABLE AS — создать таблицу из результатов запроса
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterTable, 'ALTER TABLE');             //ALTER TABLE — изменить определение таблицы
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropTable, 'DROP TABLE');               //DROP TABLE — удалить таблицу

//RULE
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateRule, 'CREATE RULE');             //CREATE RULE — создать правило перезаписи
//ALTER RULE — изменить определение правила
//DROP RULE — удалить правило перезаписи

//INDEX
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateIndex, 'CREATE INDEX');           //CREATE INDEX — создать индекс
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterIndex, 'ALTER INDEX');             //ALTER INDEX — изменить определение индекса
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropIndex, 'DROP INDEX');               //DROP INDEX — удалить индекс

//SCHEMA
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateSchema, 'CREATE SCHEMA');         //CREATE SCHEMA — создать схему
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterSchema, 'ALTER SCHEMA');           //ALTER SCHEMA — изменить определение схемы
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropSchema, 'DROP SCHEMA');             //DROP SCHEMA — удалить схему

RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateSequence, 'CREATE SEQUENCE');     //CREATE SEQUENCE — создать генератор последовательности
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterSequence, 'ALTER SEQUENCE');       //ALTER SEQUENCE — изменить определение генератора последовательности
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropSequence, 'DROP SEQUENCE');         //DROP SEQUENCE — удалить последовательность

RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCreateGroup, 'CREATE GROUP'); //'CREATE ROLE' 'CREATE USER'
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterRole, 'ALTER ROLE');
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLAlterGroup, 'ALTER GROUP'); //
RegisterSQLStatment(TSQLEnginePostgre, TPGSQLDropGroup, 'DROP GROUP'); //'DROP ROLE' 'DROP USER'

RegisterSQLStatment(TSQLEnginePostgre, TPGSQLCommentOn, 'COMMENT ON');        //COMMENT — задать или изменить комментарий объекта
*)
procedure TPGCopyCmdCase.DoTest(FCmd: TSQLCommandAbstract);
var
  FNewCmd: TObject;
begin
  AssertNotNull('Не указан объект SQL', FCmd);
  if not Assigned(FCmd) then Exit;
  FNewCmd:=FCmd.ClassType.Create;
  AssertNotNull('Не удалось скопировать объект SQL', FCmd);
  if Assigned(FNewCmd) then
  begin
    TSQLCommandAbstract(FNewCmd).Create(nil);
    TSQLCommandAbstract(FNewCmd).Assign(FCmd);
    AssertEquals(FCmd.AsSQL, TSQLCommandAbstract(FNewCmd).AsSQL);
    FNewCmd.Free;
  end;
  FCmd.Free;
end;

procedure TPGCopyCmdCase.CopyDO;
var
  FCmd: TPGSQL_DO;
begin
  //DO — выполнить анонимный блок кода
  FCmd:=TPGSQL_DO.Create(nil);
  FCmd.Language:='plPgSQL';
  FCmd.Body:='$$ begin /* */ end$$';
  DoTest(FCmd);
end;

procedure TPGCopyCmdCase.DomainCreate;
var
  FCmd: TPGSQLCreateDomain;
begin
  //CREATE DOMAIN — создать домен
  FCmd:=TPGSQLCreateDomain.Create(nil);
  FCmd.SchemaName:='public';
  FCmd.Name:='type_integer';
  FCmd.DomainType:='varchar';
  FCmd.TypeLen:=100;
  FCmd.TypePrec:=0;
  FCmd.NotNull:=true;
  FCmd.CharSetName:='UTF8';
  FCmd.CollationName:='ru_RU';
  FCmd.CheckExpression:='value<>''1''';
  FCmd.ConstraintName:='domain_check1';
  FCmd.DefaultValue:='current_user';
  FCmd.IsNull:=false;
  DoTest(FCmd);
end;

procedure TPGCopyCmdCase.DomainAlter;
var
  FCmd: TPGSQLAlterDomain;
  OP: TAlterDomainOperator;
begin
  //ALTER DOMAIN — изменить определение домена
  FCmd:=TPGSQLAlterDomain.Create(nil);
  FCmd.SchemaName:='public';
  FCmd.Name:='type_integer';

  //ALTER DOMAIN имя  RENAME TO новое_имя
  OP:=FCmd.AddOperator(adaRenameDomain);
  OP.ParamValue:='type_integer_ext';

  //ALTER DOMAIN имя { SET DEFAULT выражение | DROP DEFAULT }
  //ALTER DOMAIN имя { SET | DROP } NOT NULL
  //ALTER DOMAIN имя ADD ограничение_домена [ NOT VALID ]
  //ALTER DOMAIN имя DROP CONSTRAINT [ IF EXISTS ] имя_ограничения [ RESTRICT | CASCADE ]
  //ALTER DOMAIN имя RENAME CONSTRAINT имя_ограничения TO имя_нового_ограничения
  //ALTER DOMAIN имя VALIDATE CONSTRAINT имя_ограничения
  //ALTER DOMAIN имя OWNER TO { новый_владелец | CURRENT_USER | SESSION_USER }
  //ALTER DOMAIN имя SET SCHEMA новая_схема

  DoTest(FCmd);
end;

procedure TPGCopyCmdCase.DomainDrop;
var
  FCmd: TPGSQLDropDomain;
begin
  //DROP DOMAIN — удалить домен
  FCmd:=TPGSQLDropDomain.Create(nil);
  FCmd.Name:='type_integer';
  FCmd.SchemaName:='public';
  FCmd.DropRule:=drCascade;
  DoTest(FCmd);
end;

procedure TPGCopyCmdCase.Vacum;
var
  FCmd: TPGSQLVacum;
begin
  //VACUUM — провести сборку мусора и, возможно, проанализировать базу данных
  FCmd:=TPGSQLVacum.Create(nil);
  FCmd.TableName:='table1';
  FCmd.Full:=true;
  FCmd.Freeze:=true;
  FCmd.Verbose:=true;
  FCmd.Analyze:=true;
  DoTest(FCmd);
end;

procedure TPGCopyCmdCase.Truncate;
var
  FCmd: TPGSQLTruncate;
begin
  //TRUNCATE — опустошить таблицу или набор таблиц
  FCmd:=TPGSQLTruncate.Create(nil);
  FCmd.TableName:='table1';
  FCmd.DropRule:=drCascade;
  FCmd.RestartIdentity:=true;
  FCmd.ContinueIdentity:=true;
  FCmd.IsOnly:=false;
  DoTest(FCmd);
end;

procedure TPGCopyCmdCase.StartTransaction;
var
  FCmd: TPGSQLStartTransaction;
begin
  //START TRANSACTION — начать блок транзакции
  FCmd:=TPGSQLStartTransaction.Create(nil);
  //
  DoTest(FCmd);
end;

procedure TPGCopyCmdCase.Commit;
var
  FCmd: TPGSQLCommit;
begin
  //COMMIT
  FCmd:=TPGSQLCommit.Create(nil);
  FCmd.TransactionId:='123';
  DoTest(FCmd);

  FCmd:=TPGSQLCommit.Create(nil);
  DoTest(FCmd);
end;

procedure TPGCopyCmdCase.SQLEnd;
var
  FCmd: TPGSQLEnd;
begin
  //END — зафиксировать текущую транзакцию
  FCmd:=TPGSQLEnd.Create(nil);
  //
  DoTest(FCmd);
end;

procedure TPGCopyCmdCase.Rollback;
var
  FCmd: TPGSQLRollback;
begin
  //ROLLBACK — прервать текущую транзакцию
  FCmd:=TPGSQLRollback.Create(nil);
  FCmd.TransactionId:='123';
  DoTest(FCmd);

  FCmd:=TPGSQLRollback.Create(nil);
  FCmd.SavepointName:='Savepoint1';
  DoTest(FCmd);
end;

initialization

  RegisterTest(TPGCopyCmdCase);
end.

