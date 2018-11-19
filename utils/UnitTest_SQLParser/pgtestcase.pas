unit PGTestCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, fbmSqlParserUnit,
  RxTextHolder, PostgreSQLEngineUnit, CustApp;

type

  { TPGSQLParserTest }

  TPGSQLParserTest= class(TTestCase)
  private
  protected
    FPG: TSQLEnginePostgre;
    procedure SetUp; override;
    procedure TearDown; override;
    function GetNextSQLCmd(ASql: string): TSQLCommandAbstract; inline;
    procedure DoTestSQL(ASql: string);
  published
    //ABORT — прервать текущую транзакцию
    procedure SQLAbort1;
    procedure SQLAbort2;
    procedure SQLAbort3;
    //COMMENT — задать или изменить комментарий объекта
    procedure SQLComment1;
    procedure SQLComment2;
    procedure SQLComment3;
    procedure SQLComment4;
    procedure SQLComment5;
    procedure SQLComment6;
    procedure SQLComment7;
    procedure SQLComment8;
    procedure SQLComment9;
    procedure SQLComment10;
    procedure SQLComment11;
    procedure SQLComment12;
    procedure SQLComment13;
    procedure SQLComment14;
    procedure SQLComment15;
    procedure SQLComment16;
    procedure SQLComment17;
    procedure SQLComment18;
    procedure SQLComment19;
    procedure SQLComment20;
    procedure SQLComment21;
    procedure SQLComment22;
    procedure SQLComment23;
    procedure SQLComment24;
    procedure SQLComment25;
    procedure SQLComment26;
    procedure SQLComment27;
    procedure SQLComment28;
    procedure SQLComment29;
    procedure SQLComment30;
    procedure SQLComment31;
    procedure SQLComment32;
    procedure SQLComment33;
    procedure SQLComment34;
    procedure SQLComment35;
    procedure SQLComment36;
    procedure SQLComment37;
    procedure SQLComment38;
    procedure SQLComment39;
    procedure SQLComment40;
    procedure SQLComment41;
    //CLOSE — закрыть курсор
    procedure SQLClose1;
    procedure SQLClose2;
    //COMMIT — зафиксировать текущую транзакцию
    procedure Commit1;
    procedure Commit2;
    procedure Commit3;
    //BEGIN — начать блок транзакции
    procedure SQLBegin1;
    procedure SQLBegin2;
    procedure SQLBegin3;
    //VACUUM — провести сборку мусора и, возможно, проанализировать базу данных
    procedure SQLVacuum;
    //DISCARD — очистить состояние сеанса
    procedure SQLDiscard1;
    procedure SQLDiscard2;
    procedure SQLDiscard3;
    procedure SQLDiscard4;
    //GRANT — определить права доступа
    procedure SQLGrant1;
    procedure SQLGrant2;
    procedure SQLGrant3;
    //ANALYZE — собрать статистику по базе данных
    procedure SQLAnalyze;
    //CHECKPOINT — записать контрольную точку в журнал транзакций
    procedure SQLCheckpoint;
    //CLUSTER — кластеризовать таблицу согласно индексу
    procedure SQLCluster1;
    procedure SQLCluster2;
    procedure SQLCluster3;
    //COMMIT PREPARED — зафиксировать транзакцию, которая ранее была подготовлена для двухфазной фиксации
    procedure SQLCommitPrepared;
    //COPY — копировать данные между файлом и таблицей
    procedure SQLCopy1;
    procedure SQLCopy2;
    procedure SQLCopy3;
    procedure SQLCopy4;
    //DO — выполнить анонимный блок кода
    procedure SQLDo;
    //DEALLOCATE — освободить подготовленный оператор
    procedure SQLDeallocate;
    //DECLARE — определить курсор
    procedure SQLDeclare;
    //DELETE — удалить записи таблицы
    procedure SQLDelete1;
    procedure SQLDelete2;
    procedure SQLDelete3;
    procedure SQLDelete4;
    procedure SQLDelete5;
    procedure SQLDelete6;
    //END — зафиксировать текущую транзакцию
    procedure SQLEnd1;
    procedure SQLEnd2;
    //EXECUTE — выполнить подготовленный оператор
    procedure SQLExecute1;
    procedure SQLExecute2;
    //EXPLAIN — показать план выполнения оператора
    procedure SQLExplain1;
    procedure SQLExplain2;
    //FETCH — получить результат запроса через курсор
    procedure SQLFetch1;
    procedure SQLFetch2;
    //IMPORT FOREIGN SCHEMA — импортировать определения таблиц со стороннего сервера
    procedure SQLImportForeignSchema1;
    procedure SQLImportForeignSchema2;
    //INSERT — добавить строки в таблицу
    procedure SQLInsert1;
    procedure SQLInsert2;
    procedure SQLInsert3;
    procedure SQLInsert4;
    procedure SQLInsert5;
    procedure SQLInsert6;
    procedure SQLInsert7;
    procedure SQLInsert8;
    procedure SQLInsert9;
    procedure SQLInsert10;
    procedure SQLInsert11;
    procedure SQLInsert12;
    procedure SQLInsert13;
    procedure SQLInsert14;
    procedure SQLInsert15;
    procedure SQLInsert16;
    //LISTEN — ожидать уведомления
    procedure SQLListen;
    //LOAD — загрузить файл разделяемой библиотеки
    procedure SQLLoad;
    //LOCK — заблокировать таблицу
    procedure SQLLock1;
    procedure SQLLock2;
    //MOVE — переместить курсор
    procedure SQLMove1;
    procedure SQLMove2;
    //NOTIFY — сгенерировать уведомление
    procedure SQLNotify1;
    procedure SQLNotify2;
    //PREPARE — подготовить оператор к выполнению
    procedure SQLPrepare1;
    procedure SQLPrepare2;
    //PREPARE TRANSACTION — подготовить текущую транзакцию для двухфазной фиксации
    procedure SQLPrepareTransaction;
    //REASSIGN OWNED — сменить владельца объектов базы данных, принадлежащих заданной роли
    procedure SQLReassignOwned;
    //REFRESH MATERIALIZED VIEW — заменить содержимое материализованного представления
    procedure SQLRefreshMaterializedView1;
    procedure SQLRefreshMaterializedView2;
    //REINDEX — перестроить индексы
    procedure SQLReindex1;
    procedure SQLReindex2;
    procedure SQLReindex3;
    //RELEASE SAVEPOINT — высвободить ранее определённую точку сохранения
    procedure SQLSavepoint;
    //RESET — восстановить значение по умолчанию заданного параметра времени выполнения
    procedure SQLReset1;
    procedure SQLReset2;
    //REVOKE — отозвать права доступа
    procedure SQLRevoke1;
    procedure SQLRevoke2;
    procedure SQLRevoke3;
    procedure SQLRevoke4;
    procedure SQLRevoke5;
    //ROLLBACK — прервать текущую транзакцию
    procedure SQLRollback1;
    procedure SQLRollback2;
    procedure SQLRollback3;
    //ROLLBACK PREPARED — отменить транзакцию, которая ранее была подготовлена для двухфазной фиксации
    procedure SQLRollbackPrepared;
    //ROLLBACK TO SAVEPOINT — откатиться к точке сохранения
    procedure SQLRollbackToSavepoint;
    //SECURITY LABEL — определить или изменить метку безопасности, применённую к объекту
    procedure SQLSecurityLabel;
    //SELECT — получить строки из таблицы или представления
    procedure SQLSelect1;
    procedure SQLSelect2;
    procedure SQLSelect3;
    procedure SQLSelect4;
    procedure SQLSelect5;
    procedure SQLSelect6;
    procedure SQLSelect7;
    procedure SQLSelect8;
    procedure SQLSelect9;
    procedure SQLSelect10;
    procedure SQLSelect11;
    procedure SQLSelect12;
    procedure SQLSelect13;
    //SELECT INTO — создать таблицу из результатов запроса
    procedure SQLSelectInto;
    //SET — изменить параметр времени выполнения
    procedure SQLSet1;
    procedure SQLSet2;
    procedure SQLSet3;
    procedure SQLSet4;
    //SET CONSTRAINTS — установить время проверки ограничений для текущей транзакции
    procedure SQLSetConstraints;
    //SET ROLE — установить идентификатор текущего пользователя в рамках сеанса
    procedure SQLSetRole;
    //SET SESSION AUTHORIZATION — установить идентификатор пользователя сеанса и идентификатор текущего пользователя в рамках сеанса
    procedure SQLSetSessionAuthorization;
    //SET TRANSACTION — установить характеристики текущей транзакции
    procedure SQLSetTransaction;
    //SHOW — показать значение параметра времени выполнения
    procedure SQLShow1;
    procedure SQLShow2;
    procedure SQLShow3;
    //START TRANSACTION — начать блок транзакции
    procedure SQLStartTransaction;
    //TRUNCATE — опустошить таблицу или набор таблиц
    procedure SQLTruncate1;
    procedure SQLTruncate2;
    procedure SQLTruncate3;
    //UNLISTEN — прекратить ожидание уведомления
    procedure SQLUnlisten;
    //UPDATE — изменить строки таблицы
    procedure SQLUpdate1;
    procedure SQLUpdate2;
    procedure SQLUpdate3;
    procedure SQLUpdate4;
    procedure SQLUpdate5;
    procedure SQLUpdate6;
    procedure SQLUpdate7;
    procedure SQLUpdate8;
    procedure SQLUpdate9;
    procedure SQLUpdate10;
    //VALUES — вычислить набор строк
    procedure SQLValues1;
    procedure SQLValues2;

    //ALTER SCHEMA — изменить определение схемы
    procedure AlterSchema1;
    procedure AlterSchema2;
    //CREATE SCHEMA — создать схему
    procedure CreateSchema1;
    procedure CreateSchema2;
    procedure CreateSchema3;
    procedure CreateSchema4;
    //DROP SCHEMA — удалить схему
    procedure DropSchema;

    //CREATE DOMAIN — создать домен
    procedure DomainCreate;
    //ALTER DOMAIN — изменить определение домена
    procedure DomainAlter1;
    procedure DomainAlter2;
    procedure DomainAlter3;
    procedure DomainAlter4;
    procedure DomainAlter5;
    procedure DomainAlter6;
    procedure DomainAlter7;
    procedure DomainAlter8;
    procedure DomainAlter9;
    procedure DomainAlter10;
    procedure DomainAlter11;
    procedure DomainAlter12;
    procedure DomainAlter13;
    procedure DomainAlter14;
    procedure DomainAlter15;
    procedure DomainAlter16;
    procedure DomainAlter17;
    procedure DomainAlter18;
    procedure DomainAlter19;
    procedure DomainAlter20;
    procedure DomainAlter21;
    //DROP DOMAIN — удалить домен
    procedure DomainDrop;

    //CREATE VIEW — создать представление
    procedure CreateView1;
    procedure CreateView2;
    procedure CreateView3;
    procedure CreateView4;
    procedure CreateView5;
    //ALTER VIEW — изменить определение представления
    procedure AlterView1;
    procedure AlterView2;
    //DROP VIEW — удалить представление
    procedure DropView;

    //CREATE MATERIALIZED VIEW — создать материализованное представление
    procedure CreateMaterializedView;
    //ALTER MATERIALIZED VIEW — изменить определение материализованного представления
    procedure AlterMaterializedView;
    //DROP MATERIALIZED VIEW — удалить материализованное представление
    procedure DropMaterializedView;

    //ALTER TRIGGER — изменить определение триггера
    procedure CreateTrigger1;
    procedure CreateTrigger2;
    procedure CreateTrigger3;
    procedure CreateTrigger4;
    procedure CreateTrigger5;
    procedure CreateTrigger6;
    procedure CreateTrigger7;
    //CREATE TRIGGER — создать триггер
    procedure AlterTrigger1;
    procedure AlterTrigger2;
    //DROP TRIGGER — удалить триггер
    procedure DropTrigger;

    //ALTER FUNCTION — изменить определение функции
    procedure AlterFunction1;
    procedure AlterFunction2;
    procedure AlterFunction3;
    procedure AlterFunction4;
    procedure AlterFunction5;
    procedure AlterFunction6;
    //CREATE FUNCTION — создать функцию
    procedure CreateFunction1;
    procedure CreateFunction2;
    procedure CreateFunction3;
    procedure CreateFunction4;
    procedure CreateFunction5;
    procedure CreateFunction6;
    //DROP FUNCTION — удалить функцию
    procedure DropFunction1;
    procedure DropFunction2;
    procedure DropFunction3;
    procedure DropFunction4;

    //ALTER SEQUENCE — изменить определение генератора последовательности
    procedure AlterSequence;
    //CREATE SEQUENCE — создать генератор последовательности
    procedure CreateSequence;
    //DROP SEQUENCE — удалить последовательность
    procedure DropSequence;

    //ALTER INDEX — изменить определение индекса
    procedure AlterIndex1;
    procedure AlterIndex2;
    procedure AlterIndex3;
    //CREATE INDEX — создать индекс
    procedure CreateIndex1;
    procedure CreateIndex2;
    procedure CreateIndex3;
    procedure CreateIndex4;
    procedure CreateIndex5;
    procedure CreateIndex6;
    procedure CreateIndex7;
    procedure CreateIndex8;
    procedure CreateIndex9;
    //DROP INDEX — удалить индекс
    procedure DropIndex;

    //ALTER GROUP — изменить имя роли или членство
    procedure AlterGroup1;
    procedure AlterGroup2;
    //CREATE GROUP — создать роль в базе данных
    procedure CreateGroup;
    //DROP GROUP — удалить роль в базе данных
    procedure DropGroup;

    //ALTER SERVER — изменить определение стороннего сервера
    procedure AlterServer1;
    procedure AlterServer2;
    //CREATE SERVER — создать сторонний сервер
    procedure CreateServer;
    //DROP SERVER — удалить описание стороннего сервера
    procedure DropServer;

    //CREATE DATABASE — создать базу данных
    procedure CreateDatabase1;
    procedure CreateDatabase2;
    procedure CreateDatabase3;
    procedure CreateDatabase4;
    //ALTER DATABASE — изменить атрибуты базы данных
    procedure AlterDatabase;
    //DROP DATABASE — удалить базу данных
    procedure DropDatabase;

    //ALTER TYPE — изменить определение типа
    procedure AlterType1;
    procedure AlterType2;
    procedure AlterType3;
    procedure AlterType4;
    procedure AlterType5;
    procedure AlterType6;
    //CREATE TYPE — создать новый тип данных
    procedure CreateType1;
    procedure CreateType2;
    procedure CreateType3;
    procedure CreateType4;
    procedure CreateType5;
    procedure CreateType6;
    procedure CreateType7;
    //DROP TYPE — удалить тип данных
    procedure DropType;

    //ALTER USER MAPPING — изменить определение сопоставления пользователей
    procedure AlterUserMapping;
    //CREATE USER MAPPING — создать сопоставление пользователя для стороннего сервера
    procedure CreateUserMapping;
    //DROP USER MAPPING — удалить сопоставление пользователя для стороннего сервера
    procedure DropUserMapping;

    //CREATE TRANSFORM — создать трансформацию
    procedure CreateTransform;
    //DROP TRANSFORM — удалить трансформацию
    procedure DropTransform;

    //ALTER TEXT SEARCH CONFIGURATION — изменить определение конфигурации текстового поиска
    procedure AlterTextSearchConfiguration;
    //ALTER TEXT SEARCH DICTIONARY — изменить определение словаря текстового поиска
    procedure AlterTextSearchDictionary1;
    procedure AlterTextSearchDictionary2;
    procedure AlterTextSearchDictionary3;
    //ALTER TEXT SEARCH PARSER — изменить определение анализатора текстового поиска
    procedure AlterTextSearchParser1;
    procedure AlterTextSearchParser2;
    //ALTER TEXT SEARCH TEMPLATE — изменить определение шаблона текстового поиска
    procedure AlterTextSearchTemplate1;
    procedure AlterTextSearchTemplate2;
    //CREATE TEXT SEARCH CONFIGURATION — создать конфигурацию текстового поиска
    procedure CreateTextSearchConfiguration;
    //CREATE TEXT SEARCH DICTIONARY — создать словарь текстового поиска
    procedure CreateTextSearchDictionary;
    //CREATE TEXT SEARCH PARSER — создать анализатор текстового поиска
    procedure CreateTextSearchParser;
    //CREATE TEXT SEARCH TEMPLATE — создать шаблон текстового поиска
    procedure CreateTextSearchTemplate;
    //DROP TEXT SEARCH CONFIGURATION — удалить конфигурацию текстового поиска
    procedure DropTextSearchConfiguration;
    //DROP TEXT SEARCH DICTIONARY — удалить словарь текстового поиска
    procedure DropTextSearchDictionary;
    //DROP TEXT SEARCH PARSER — удалить анализатор текстового поиска
    procedure DropTextSearchParser;
    //DROP TEXT SEARCH TEMPLATE — удалить шаблон текстового поиска
    procedure DropTextSearchTemplate;

    //ALTER TABLESPACE — изменить определение табличного пространства
    procedure AlterTablespace1;
    procedure AlterTablespace2;
    //CREATE TABLESPACE — создать табличное пространство
    procedure CreateTablespace1;
    procedure CreateTablespace2;
    //DROP TABLESPACE — удалить табличное пространство
    procedure DropTablespace;

    //ALTER RULE — изменить определение правила
    procedure AlterRule;
    //CREATE RULE — создать правило перезаписи
    procedure CreateRule1;
    procedure CreateRule2;
    procedure CreateRule3;
    //DROP RULE — удалить правило перезаписи
    procedure DropRule;

    //ALTER POLICY — изменить определение политики защиты на уровне строк
    procedure AlterPolicy;
    //CREATE POLICY — создать новую политику защиты на уровне строк для таблицы
    procedure CreatePolicy1;
    procedure CreatePolicy2;
    procedure CreatePolicy3;
    procedure CreatePolicy4;
    procedure CreatePolicy5;
    procedure CreatePolicy6;
    procedure CreatePolicy7;
    //DROP POLICY — удалить политику защиты на уровне строк для таблицы
    procedure DropPolicy;
    //DROP OWNED — удалить объекты базы данных, принадлежащие роли
    procedure DropOwned;

    //ALTER OPERATOR — изменить определение оператора
    procedure AlterOperator1;
    procedure AlterOperator2;
    //ALTER OPERATOR CLASS — изменить определение класса операторов
    procedure AlterOperatorClass;
    //ALTER OPERATOR FAMILY — изменить определение семейства операторов
    procedure AlterOperatorFamily1;
    procedure AlterOperatorFamily2;
    //CREATE OPERATOR — создать оператор
    procedure CreateOperator;
    //CREATE OPERATOR CLASS — создать класс операторов
    procedure CreateOperatorClass;
    //CREATE OPERATOR FAMILY — создать семейство операторов
    procedure CreateOperatorFamily;
    //DROP OPERATOR — удалить оператор
    procedure DropOperator1;
    procedure DropOperator2;
    procedure DropOperator3;
    procedure DropOperator4;
    //DROP OPERATOR CLASS — удалить класс операторов
    procedure DropOperatorClass;
    //DROP OPERATOR FAMILY — удалить семейство операторов
    procedure DropOperatorFamily;

    //ALTER FOREIGN DATA WRAPPER — изменить определение обёртки сторонних данных
    procedure AlterForeignDataWrapper1;
    procedure AlterForeignDataWrapper2;
    //ALTER FOREIGN TABLE — изменить определение сторонней таблицы
    procedure AlterForeignTable1;
    procedure AlterForeignTable2;
    //CREATE FOREIGN DATA WRAPPER — создать новую обёртку сторонних данных
    procedure CreateForeignDataWrapper1;
    procedure CreateForeignDataWrapper2;
    procedure CreateForeignDataWrapper3;
    //CREATE FOREIGN TABLE — создать стороннюю таблицу
    procedure CreateForeignTable1;
    procedure CreateForeignTable2;
    //DROP FOREIGN DATA WRAPPER — удалить обёртку сторонних данных
    procedure DropForeignDataWrapper;
    //DROP FOREIGN TABLE — удалить стороннюю таблицу
    procedure DropForeignTable;

    //ALTER EXTENSION — изменить определение расширения
    procedure AlterExtension1;
    procedure AlterExtension2;
    procedure AlterExtension3;
    //CREATE EXTENSION — установить расширение
    procedure CreateExtension1;
    procedure CreateExtension2;
    //DROP EXTENSION — удалить расширение
    procedure DropExtension;

    //ALTER LANGUAGE — изменить определение процедурного языка
    procedure AlterLanguage1;
    procedure AlterLanguage2;
    //CREATE LANGUAGE — создать процедурный язык
    procedure CreateLanguage1;
    procedure CreateLanguage2;
    //DROP LANGUAGE — удалить процедурный язык
    procedure DropLanguage;

    //ALTER EVENT TRIGGER — изменить определение событийного триггера
    procedure AlterEventTrigger1;
    procedure AlterEventTrigger2;
    procedure AlterEventTrigger3;
    procedure AlterEventTrigger4;
    //CREATE EVENT TRIGGER — создать событийный триггер
    procedure CreateEventTrigger;
    //DROP EVENT TRIGGER — удалить событийный триггер
    procedure DropEventTrigger;

    //DROP CONVERSION — удалить преобразование
    procedure DropConversion;
    //ALTER CONVERSION — изменить определение перекодировки
    procedure AlterConversion1;
    procedure AlterConversion2;
    //CREATE CONVERSION — создать перекодировку
    procedure CreateConversion;

    //ALTER COLLATION — изменить определение правила сортировки
    //CREATE COLLATION — создать правило сортировки
    //DROP COLLATION — удалить правило сортировки
    procedure AlterCollation1;
    procedure AlterCollation2;
    procedure CreateCollation1;
    procedure CreateCollation2;
    procedure CreateCollation3;
    procedure DropCollation;

    //CREATE CAST — создать приведение
    //DROP CAST — удалить приведение типа
    procedure CreateCast;
    procedure DropCast;

    //CREATE ACCESS METHOD — создать новый метод доступа
    procedure CreateAccessMethod;
    //DROP ACCESS METHOD — удалить метод доступа
    procedure DropAccessMethod;

    //ALTER AGGREGATE — изменить определение агрегатной функции
    procedure AlterAggregate1;
    procedure AlterAggregate2;
    procedure AlterAggregate3;
    procedure AlterAggregate4;
    //CREATE AGGREGATE — создать агрегатную функцию
    procedure CreateAggregate1;
    procedure CreateAggregate2;
    procedure CreateAggregate3;
    procedure CreateAggregate4;
    procedure CreateAggregate5;
    procedure CreateAggregate6;
    procedure CreateAggregate7;
    //DROP AGGREGATE — удалить агрегатную функцию
    procedure DropAggregate1;
    procedure DropAggregate2;
    procedure DropAggregate3;


    //ALTER DEFAULT PRIVILEGES — определить права доступа по умолчанию
    procedure AlterDefaultPrivileges1;
    procedure AlterDefaultPrivileges2;
    procedure AlterDefaultPrivileges3;
    procedure AlterDefaultPrivileges4;
    procedure AlterDefaultPrivileges5;
    //ALTER LARGE OBJECT — изменить определение большого объекта
    procedure AlterLargeObject;
    //ALTER SYSTEM — изменить параметр конфигурации сервера
    procedure AlterSystem1;
    procedure AlterSystem2;
    //CREATE TABLE AS — создать таблицу из результатов запроса
    procedure CreateTableAs1;
    procedure CreateTableAs2;
    procedure CreateTableAs3;

    //CREATE TABLE — создать таблицу
    procedure CreateTable1;
    procedure CreateTable2;
    procedure CreateTable3;
    procedure CreateTable4;
    procedure CreateTable5;
    procedure CreateTable6;
    procedure CreateTable7;
    procedure CreateTable8;
    procedure CreateTable9;
    procedure CreateTable10;
    procedure CreateTable11;
    procedure CreateTable12;
    procedure CreateTable13;
    procedure CreateTable14;
    procedure CreateTable15;
    procedure CreateTable16;
    procedure CreateTable17;
    procedure CreateTable18;
    procedure CreateTable19;
    procedure CreateTabl20;
    procedure CreateTable21;
    procedure CreateTable22;
    procedure CreateTable23;
    procedure CreateTable24;
    procedure CreateTable25;
    procedure CreateTable26;
    procedure CreateTable27;
    procedure CreateTable28;
    procedure CreateTable29;
    procedure CreateTable30;
    //ALTER TABLE — изменить определение таблицы
    procedure AlterTable1;
    procedure AlterTable2;
    //DROP TABLE — удалить таблицу
    procedure DropTable1;
    procedure DropTable2;

    //CREATE ROLE — создать роль в базе данных
    procedure CreateRole;
    //ALTER ROLE — изменить роль в базе данных
    procedure AlterRole1;
    procedure AlterRole2;
    procedure AlterRole3;
    procedure AlterRole4;
    procedure AlterRole5;
    procedure AlterRole6;
    procedure AlterRole7;
    //DROP ROLE — удалить роль в базе данных
    procedure DropRole;

    //ALTER USER — изменить роль в базе данных
    procedure AlterUser1;
    procedure AlterUser2;
    //CREATE USER — создать роль в базе данных
    procedure CreateUser;
    //DROP USER — удалить роль в базе данных
    procedure DropUser;

    procedure GroupCreate;
  end;

  { TPGSQLParserData }

  TPGSQLParserData= class(TDataModule)
    sDataBase: TRxTextHolder;
    sFunctions: TRxTextHolder;
    sAggregate: TRxTextHolder;
    sSystem: TRxTextHolder;
    sSchema: TRxTextHolder;
    sView: TRxTextHolder;
    sTable: TRxTextHolder;
    sDomain: TRxTextHolder;
    sDML: TRxTextHolder;
    sUserAcess: TRxTextHolder;
    sSimpleCmd: TRxTextHolder;
    sComment: TRxTextHolder;
  public
  end;

var
  PGSQLParserData : TPGSQLParserData = nil;

implementation

{$R *.lfm}

procedure TPGSQLParserTest.CreateRole;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreateRole1']);
end;

procedure TPGSQLParserTest.AlterRole1;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterRole1']);
end;

procedure TPGSQLParserTest.AlterRole2;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterRole2']);
end;

procedure TPGSQLParserTest.AlterRole3;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterRole3']);
end;

procedure TPGSQLParserTest.AlterRole4;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterRole4']);
end;

procedure TPGSQLParserTest.AlterRole5;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterRole5']);
end;

procedure TPGSQLParserTest.AlterRole6;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterRole6']);
end;

procedure TPGSQLParserTest.AlterRole7;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterRole7']);
end;

procedure TPGSQLParserTest.DropRole;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['DropRole1']);
end;

procedure TPGSQLParserTest.AlterUser1;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterUser1']);
end;

procedure TPGSQLParserTest.AlterUser2;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterUser2']);
end;

procedure TPGSQLParserTest.CreateUser;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreateUser1']);
end;

procedure TPGSQLParserTest.DropUser;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['DropUser1']);
end;

procedure TPGSQLParserTest.GroupCreate;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreateGroup1']);
end;

procedure TPGSQLParserTest.SQLEnd1;
begin
  DoTestSQL(PGSQLParserData.sDML['END1']);
end;

procedure TPGSQLParserTest.SQLEnd2;
begin
  DoTestSQL(PGSQLParserData.sDML['END2']);
end;

procedure TPGSQLParserTest.SQLExecute1;
begin
  DoTestSQL(PGSQLParserData.sDML['Execute1']);
end;

procedure TPGSQLParserTest.SQLExecute2;
begin
  DoTestSQL(PGSQLParserData.sDML['Execute2']);
end;

procedure TPGSQLParserTest.SQLExplain1;
begin
  DoTestSQL(PGSQLParserData.sDML['Explain1']);
end;

procedure TPGSQLParserTest.SQLExplain2;
begin
  DoTestSQL(PGSQLParserData.sDML['Explain2']);
end;

procedure TPGSQLParserTest.SQLFetch1;
begin
  DoTestSQL(PGSQLParserData.sDML['Fetch1']);
end;

procedure TPGSQLParserTest.SQLFetch2;
begin
  DoTestSQL(PGSQLParserData.sDML['Fetch2']);
end;

procedure TPGSQLParserTest.SQLImportForeignSchema1;
begin
  DoTestSQL(PGSQLParserData.sSchema['ImportForeignSchema1']);
end;

procedure TPGSQLParserTest.SQLImportForeignSchema2;
begin
  DoTestSQL(PGSQLParserData.sSchema['ImportForeignSchema2']);
end;

procedure TPGSQLParserTest.SQLInsert1;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert1']);
end;

procedure TPGSQLParserTest.SQLInsert2;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert2']);
end;

procedure TPGSQLParserTest.SQLInsert3;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert3']);
end;

procedure TPGSQLParserTest.SQLInsert4;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert4']);
end;

procedure TPGSQLParserTest.SQLInsert5;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert5']);
end;

procedure TPGSQLParserTest.SQLInsert6;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert6']);
end;

procedure TPGSQLParserTest.SQLInsert7;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert7']);
end;

procedure TPGSQLParserTest.SQLInsert8;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert8']);
end;

procedure TPGSQLParserTest.SQLInsert9;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert9']);
end;

procedure TPGSQLParserTest.SQLInsert10;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert10']);
end;

procedure TPGSQLParserTest.SQLInsert11;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert11']);
end;

procedure TPGSQLParserTest.SQLInsert12;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert12']);
end;

procedure TPGSQLParserTest.SQLInsert13;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert13']);
end;

procedure TPGSQLParserTest.SQLInsert14;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert14']);
end;

procedure TPGSQLParserTest.SQLInsert15;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert15']);
end;

procedure TPGSQLParserTest.SQLInsert16;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert16']);
end;

procedure TPGSQLParserTest.SQLListen;
begin
  DoTestSQL(PGSQLParserData.sDML['Listen1']);
end;

procedure TPGSQLParserTest.SQLLoad;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Load1']);
end;

procedure TPGSQLParserTest.SQLLock1;
begin
  DoTestSQL(PGSQLParserData.sDML['Lock1']);
end;

procedure TPGSQLParserTest.SQLLock2;
begin
  DoTestSQL(PGSQLParserData.sDML['Lock2']);
end;

procedure TPGSQLParserTest.SQLMove1;
begin
  DoTestSQL(PGSQLParserData.sDML['Move1']);
end;

procedure TPGSQLParserTest.SQLMove2;
begin
  DoTestSQL(PGSQLParserData.sDML['Move2']);
end;

procedure TPGSQLParserTest.SQLNotify1;
begin
  DoTestSQL(PGSQLParserData.sDML['Notify1']);
end;

procedure TPGSQLParserTest.SQLNotify2;
begin
  DoTestSQL(PGSQLParserData.sDML['Notify2']);
end;

procedure TPGSQLParserTest.SQLPrepare1;
begin
  DoTestSQL(PGSQLParserData.sDML['Prepare1']);
end;

procedure TPGSQLParserTest.SQLPrepare2;
begin
  DoTestSQL(PGSQLParserData.sDML['Prepare2']);
end;

procedure TPGSQLParserTest.SQLPrepareTransaction;
begin
  DoTestSQL(PGSQLParserData.sDML['PrepareTransaction1']);
end;

procedure TPGSQLParserTest.SQLReassignOwned;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['ReassignOwned1']);
end;

procedure TPGSQLParserTest.SQLRefreshMaterializedView1;
begin
  DoTestSQL(PGSQLParserData.sView['RefreshMaterializedView1']);
end;

procedure TPGSQLParserTest.SQLRefreshMaterializedView2;
begin
  DoTestSQL(PGSQLParserData.sView['RefreshMaterializedView2']);
end;

procedure TPGSQLParserTest.SQLReindex1;
begin
  DoTestSQL(PGSQLParserData.sTable['Reindex1']);
end;

procedure TPGSQLParserTest.SQLReindex2;
begin
  DoTestSQL(PGSQLParserData.sTable['Reindex2']);
end;

procedure TPGSQLParserTest.SQLReindex3;
begin
  DoTestSQL(PGSQLParserData.sTable['Reindex3']);
end;

procedure TPGSQLParserTest.SQLSavepoint;
begin
  DoTestSQL(PGSQLParserData.sDML['Savepoint1']);
end;

procedure TPGSQLParserTest.SQLReset1;
begin
  DoTestSQL(PGSQLParserData.sSystem['Reset1']);
end;

procedure TPGSQLParserTest.SQLReset2;
begin
  DoTestSQL(PGSQLParserData.sSystem['Reset2']);
end;

procedure TPGSQLParserTest.SQLRevoke1;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['Revoke1']);
end;

procedure TPGSQLParserTest.SQLRevoke2;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['Revoke2']);
end;

procedure TPGSQLParserTest.SQLRevoke3;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['Revoke3']);
end;

procedure TPGSQLParserTest.SQLRevoke4;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['Revoke4']);
end;

procedure TPGSQLParserTest.SQLRevoke5;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['Revoke5']);
end;

procedure TPGSQLParserTest.SQLRollback1;
begin
  DoTestSQL(PGSQLParserData.sDML['Rollback1']);
end;

procedure TPGSQLParserTest.SQLRollback2;
begin
  DoTestSQL(PGSQLParserData.sDML['Rollback2']);
end;

procedure TPGSQLParserTest.SQLRollback3;
begin
  DoTestSQL(PGSQLParserData.sDML['Rollback3']);
end;

procedure TPGSQLParserTest.SQLRollbackPrepared;
begin
  DoTestSQL(PGSQLParserData.sDML['RollbackPrepared1']);
end;

procedure TPGSQLParserTest.SQLRollbackToSavepoint;
begin
  DoTestSQL(PGSQLParserData.sDML['RollbackToSavepoint1']);
end;

procedure TPGSQLParserTest.SQLSecurityLabel;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['SecurityLabel1']);
end;

procedure TPGSQLParserTest.SQLSelect1;
begin
  DoTestSQL(PGSQLParserData.sDML['Select1']);
end;

procedure TPGSQLParserTest.SQLSelect2;
begin
  DoTestSQL(PGSQLParserData.sDML['Select2']);
end;

procedure TPGSQLParserTest.SQLSelect3;
begin
  DoTestSQL(PGSQLParserData.sDML['Select3']);
end;

procedure TPGSQLParserTest.SQLSelect4;
begin
  DoTestSQL(PGSQLParserData.sDML['Select4']);
end;

procedure TPGSQLParserTest.SQLSelect5;
begin
  DoTestSQL(PGSQLParserData.sDML['Select5']);
end;

procedure TPGSQLParserTest.SQLSelect6;
begin
  DoTestSQL(PGSQLParserData.sDML['Select6']);
end;

procedure TPGSQLParserTest.SQLSelect7;
begin
  DoTestSQL(PGSQLParserData.sDML['Select7']);
end;

procedure TPGSQLParserTest.SQLSelect8;
begin
  DoTestSQL(PGSQLParserData.sDML['Select8']);
end;

procedure TPGSQLParserTest.SQLSelect9;
begin
  DoTestSQL(PGSQLParserData.sDML['Select9']);
end;

procedure TPGSQLParserTest.SQLSelect10;
begin
  DoTestSQL(PGSQLParserData.sDML['Select10']);
end;

procedure TPGSQLParserTest.SQLSelect11;
begin
  DoTestSQL(PGSQLParserData.sDML['Select11']);
end;

procedure TPGSQLParserTest.SQLSelect12;
begin
  DoTestSQL(PGSQLParserData.sDML['Select12']);
end;

procedure TPGSQLParserTest.SQLSelect13;
begin
  DoTestSQL(PGSQLParserData.sDML['Select13']);
end;

procedure TPGSQLParserTest.SQLSelectInto;
begin
  DoTestSQL(PGSQLParserData.sDML['SelectInto1']);
end;

procedure TPGSQLParserTest.SQLSet1;
begin
  DoTestSQL(PGSQLParserData.sSystem['Set1']);
end;

procedure TPGSQLParserTest.SQLSet2;
begin
  DoTestSQL(PGSQLParserData.sSystem['Set2']);
end;

procedure TPGSQLParserTest.SQLSet3;
begin
  DoTestSQL(PGSQLParserData.sSystem['Set3']);
end;

procedure TPGSQLParserTest.SQLSet4;
begin
  DoTestSQL(PGSQLParserData.sSystem['Set4']);
end;

procedure TPGSQLParserTest.SQLSetConstraints;
begin
  DoTestSQL(PGSQLParserData.sSystem['SetConstraints1']);
end;

procedure TPGSQLParserTest.SQLSetRole;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['SetRole1']);
end;

procedure TPGSQLParserTest.SQLSetSessionAuthorization;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['SetSessionAuthorization1']);
end;

procedure TPGSQLParserTest.SQLSetTransaction;
begin
  DoTestSQL(PGSQLParserData.sDML['SetTransaction1']);
end;

procedure TPGSQLParserTest.SQLShow1;
begin
  DoTestSQL(PGSQLParserData.sSystem['Show1']);
end;

procedure TPGSQLParserTest.SQLShow2;
begin
  DoTestSQL(PGSQLParserData.sSystem['Show2']);
end;

procedure TPGSQLParserTest.SQLShow3;
begin
  DoTestSQL(PGSQLParserData.sSystem['Show3']);
end;

procedure TPGSQLParserTest.SQLStartTransaction;
begin
  DoTestSQL(PGSQLParserData.sDML['StartTransaction1']);
end;

procedure TPGSQLParserTest.SQLTruncate1;
begin
  DoTestSQL(PGSQLParserData.sDML['Truncate1']);
end;

procedure TPGSQLParserTest.SQLTruncate2;
begin
  DoTestSQL(PGSQLParserData.sDML['Truncate2']);
end;

procedure TPGSQLParserTest.SQLTruncate3;
begin
  DoTestSQL(PGSQLParserData.sDML['Truncate3']);
end;

procedure TPGSQLParserTest.SQLUnlisten;
begin
  DoTestSQL(PGSQLParserData.sDML['Unlisten1']);
end;

procedure TPGSQLParserTest.SQLUpdate1;
begin
  DoTestSQL(PGSQLParserData.sDML['Update1']);
end;

procedure TPGSQLParserTest.SQLUpdate2;
begin
  DoTestSQL(PGSQLParserData.sDML['Update2']);
end;

procedure TPGSQLParserTest.SQLUpdate3;
begin
  DoTestSQL(PGSQLParserData.sDML['Update3']);
end;

procedure TPGSQLParserTest.SQLUpdate4;
begin
  DoTestSQL(PGSQLParserData.sDML['Update4']);
end;

procedure TPGSQLParserTest.SQLUpdate5;
begin
  DoTestSQL(PGSQLParserData.sDML['Update5']);
end;

procedure TPGSQLParserTest.SQLUpdate6;
begin
  DoTestSQL(PGSQLParserData.sDML['Update6']);
end;

procedure TPGSQLParserTest.SQLUpdate7;
begin
  DoTestSQL(PGSQLParserData.sDML['Update7']);
end;

procedure TPGSQLParserTest.SQLUpdate8;
begin
  DoTestSQL(PGSQLParserData.sDML['Update8']);
end;

procedure TPGSQLParserTest.SQLUpdate9;
begin
  DoTestSQL(PGSQLParserData.sDML['Update9']);
end;

procedure TPGSQLParserTest.SQLUpdate10;
begin
  DoTestSQL(PGSQLParserData.sDML['Update10']);
end;

procedure TPGSQLParserTest.SQLValues2;
begin
  DoTestSQL(PGSQLParserData.sDML['Values2']);
end;

procedure TPGSQLParserTest.SQLValues1;
begin
  DoTestSQL(PGSQLParserData.sDML['Values1']);
end;

procedure TPGSQLParserTest.AlterSchema1;
begin
  DoTestSQL(PGSQLParserData.sSchema['AlterSchema1']);
end;

procedure TPGSQLParserTest.AlterSchema2;
begin
  DoTestSQL(PGSQLParserData.sSchema['AlterSchema2']);
end;

procedure TPGSQLParserTest.CreateSchema1;
begin
  DoTestSQL(PGSQLParserData.sSchema['CreateSchema1']);
end;

procedure TPGSQLParserTest.CreateSchema2;
begin
  DoTestSQL(PGSQLParserData.sSchema['CreateSchema2']);
end;

procedure TPGSQLParserTest.CreateSchema3;
begin
  DoTestSQL(PGSQLParserData.sSchema['CreateSchema3']);
end;

procedure TPGSQLParserTest.CreateSchema4;
begin
  DoTestSQL(PGSQLParserData.sSchema['CreateSchema4']);
end;

procedure TPGSQLParserTest.DropSchema;
begin
  DoTestSQL(PGSQLParserData.sSchema['DropSchema1']);
end;

procedure TPGSQLParserTest.SQLClose1;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Close1']);
end;

procedure TPGSQLParserTest.SQLClose2;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Close2']);
end;

procedure TPGSQLParserTest.Commit1;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Commit1']);
end;

procedure TPGSQLParserTest.Commit2;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Commit2']);
end;

procedure TPGSQLParserTest.Commit3;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Commit3']);
end;

procedure TPGSQLParserTest.SQLBegin1;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Begin1']);
end;

procedure TPGSQLParserTest.SQLBegin2;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Begin2']);
end;

procedure TPGSQLParserTest.SQLBegin3;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Begin3']);
end;

procedure TPGSQLParserTest.SQLVacuum;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Vacuum1']);
end;

procedure TPGSQLParserTest.SQLDiscard1;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Discard1']);
end;

procedure TPGSQLParserTest.SQLDiscard2;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Discard2']);
end;

procedure TPGSQLParserTest.SQLDiscard3;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Discard3']);
end;

procedure TPGSQLParserTest.SQLDiscard4;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Discard4']);
end;

procedure TPGSQLParserTest.SQLGrant1;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['Grant1']);
end;

procedure TPGSQLParserTest.SQLGrant2;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['Grant2']);
end;

procedure TPGSQLParserTest.SQLGrant3;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['Grant3']);
end;

procedure TPGSQLParserTest.SQLAnalyze;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Analyze1']);
end;

procedure TPGSQLParserTest.SQLCheckpoint;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Checkpoint1']);
end;

procedure TPGSQLParserTest.SQLCluster1;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Cluster1']);
end;

procedure TPGSQLParserTest.SQLCluster2;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Cluster2']);
end;

procedure TPGSQLParserTest.SQLCluster3;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Cluster3']);
end;

procedure TPGSQLParserTest.SQLCommitPrepared;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['CommitPrepared1']);
end;

procedure TPGSQLParserTest.SQLCopy1;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Copy1']);
end;

procedure TPGSQLParserTest.SQLCopy2;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Copy2']);
end;

procedure TPGSQLParserTest.SQLCopy3;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Copy3']);
end;

procedure TPGSQLParserTest.SQLCopy4;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Copy4']);
end;

procedure TPGSQLParserTest.SQLDo;
begin
  DoTestSQL(PGSQLParserData.sDML['DO1']);
end;

procedure TPGSQLParserTest.SQLDeallocate;
begin
  DoTestSQL(PGSQLParserData.sDML['Deallocate1']);
end;

procedure TPGSQLParserTest.SQLDeclare;
begin
  DoTestSQL(PGSQLParserData.sDML['Declare1']);
end;

procedure TPGSQLParserTest.SQLDelete1;
begin
  DoTestSQL(PGSQLParserData.sDML['Delete1']);
end;

procedure TPGSQLParserTest.SQLDelete2;
begin
  DoTestSQL(PGSQLParserData.sDML['Delete2']);
end;

procedure TPGSQLParserTest.SQLDelete3;
begin
  DoTestSQL(PGSQLParserData.sDML['Delete3']);
end;

procedure TPGSQLParserTest.SQLDelete4;
begin
  DoTestSQL(PGSQLParserData.sDML['Delete4']);
end;

procedure TPGSQLParserTest.SQLDelete5;
begin
  DoTestSQL(PGSQLParserData.sDML['Delete5']);
end;

procedure TPGSQLParserTest.SQLDelete6;
begin
  DoTestSQL(PGSQLParserData.sDML['Delete6']);
end;

procedure TPGSQLParserTest.SetUp;
begin
  PGSQLParserData:=TPGSQLParserData.Create(CustomApplication);
  FPG:=TSQLEnginePostgre.Create;
end;

procedure TPGSQLParserTest.TearDown;
begin
  FreeAndNil(PGSQLParserData);
  FreeAndNil(FPG);
end;

function TPGSQLParserTest.GetNextSQLCmd(ASql: string): TSQLCommandAbstract;
begin
  Result:=GetNextSQLCommand(ASql, FPG, true);
end;

procedure TPGSQLParserTest.DoTestSQL(ASql: string);
var
  V: TSQLCommandAbstract;
begin
  ASql:=TrimRight(ASql);

  if ASql = '' then
    raise Exception.CreateFmt('Пустое SQL выражение : %s', [ASql]);
  //AssertTrue('Пустое SQL выражение', ASql <> '');

  V:=GetNextSQLCmd(ASql);
  AssertNotNull('Не найден парсер выражения : '+ASql, V);
  if Assigned(V) then
  begin
    AssertFalse(V.ErrorMessage + '(' + ASql +')', V.ErrorMessage<>'');
    AssertEquals(ASql, Trim(V.AsSQL));
    V.Free;
  end;
end;

procedure TPGSQLParserTest.SQLAbort1;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Abort1']);
end;

procedure TPGSQLParserTest.SQLAbort2;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Abort2']);
end;

procedure TPGSQLParserTest.SQLAbort3;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Abort3']);
end;

procedure TPGSQLParserTest.SQLComment1;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment1']);
end;

procedure TPGSQLParserTest.SQLComment2;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment2']);
end;

procedure TPGSQLParserTest.SQLComment3;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment3']);
end;

procedure TPGSQLParserTest.SQLComment4;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment4']);
end;

procedure TPGSQLParserTest.SQLComment5;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment5']);
end;

procedure TPGSQLParserTest.SQLComment6;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment6']);
end;

procedure TPGSQLParserTest.SQLComment7;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment7']);
end;

procedure TPGSQLParserTest.SQLComment8;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment8']);
end;

procedure TPGSQLParserTest.SQLComment9;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment9']);
end;

procedure TPGSQLParserTest.SQLComment10;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment10']);
end;

procedure TPGSQLParserTest.SQLComment11;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment11']);
end;

procedure TPGSQLParserTest.SQLComment12;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment12']);
end;

procedure TPGSQLParserTest.SQLComment13;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment13']);
end;

procedure TPGSQLParserTest.SQLComment14;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment14']);
end;

procedure TPGSQLParserTest.SQLComment15;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment15']);
end;

procedure TPGSQLParserTest.SQLComment16;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment16']);
end;

procedure TPGSQLParserTest.SQLComment17;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment17']);
end;

procedure TPGSQLParserTest.SQLComment18;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment18']);
end;

procedure TPGSQLParserTest.SQLComment19;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment19']);
end;

procedure TPGSQLParserTest.SQLComment20;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment20']);
end;

procedure TPGSQLParserTest.SQLComment21;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment21']);
end;

procedure TPGSQLParserTest.SQLComment22;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment22']);
end;

procedure TPGSQLParserTest.SQLComment23;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment23']);
end;

procedure TPGSQLParserTest.SQLComment24;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment24']);
end;

procedure TPGSQLParserTest.SQLComment25;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment25']);
end;

procedure TPGSQLParserTest.SQLComment26;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment26']);
end;

procedure TPGSQLParserTest.SQLComment27;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment27']);
end;

procedure TPGSQLParserTest.SQLComment28;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment28']);
end;

procedure TPGSQLParserTest.SQLComment29;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment29']);
end;

procedure TPGSQLParserTest.SQLComment30;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment30']);
end;

procedure TPGSQLParserTest.SQLComment31;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment31']);
end;

procedure TPGSQLParserTest.SQLComment32;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment32']);
end;

procedure TPGSQLParserTest.SQLComment33;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment33']);
end;

procedure TPGSQLParserTest.SQLComment34;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment34']);
end;

procedure TPGSQLParserTest.SQLComment35;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment35']);
end;

procedure TPGSQLParserTest.SQLComment36;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment36']);
end;

procedure TPGSQLParserTest.SQLComment37;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment37']);
end;

procedure TPGSQLParserTest.SQLComment38;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment38']);
end;

procedure TPGSQLParserTest.SQLComment39;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment39']);
end;

procedure TPGSQLParserTest.SQLComment40;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment40']);
end;

procedure TPGSQLParserTest.SQLComment41;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment41']);
end;

procedure TPGSQLParserTest.DomainCreate;
begin
  DoTestSQL(PGSQLParserData.sDomain['CreateDomain1']);
end;

procedure TPGSQLParserTest.DomainAlter1;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain1']);
end;

procedure TPGSQLParserTest.DomainAlter2;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain2']);
end;

procedure TPGSQLParserTest.DomainAlter3;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain3']);
end;

procedure TPGSQLParserTest.DomainAlter4;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain4']);
end;

procedure TPGSQLParserTest.DomainAlter5;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain5']);
end;

procedure TPGSQLParserTest.DomainAlter6;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain6']);
end;

procedure TPGSQLParserTest.DomainAlter7;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain7']);
end;

procedure TPGSQLParserTest.DomainAlter8;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain8']);
end;

procedure TPGSQLParserTest.DomainAlter9;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain9']);
end;

procedure TPGSQLParserTest.DomainAlter10;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain10']);
end;

procedure TPGSQLParserTest.DomainAlter11;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain11']);
end;

procedure TPGSQLParserTest.DomainAlter12;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain12']);
end;

procedure TPGSQLParserTest.DomainAlter13;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain13']);
end;

procedure TPGSQLParserTest.DomainAlter14;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain14']);
end;

procedure TPGSQLParserTest.DomainAlter15;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain15']);
end;

procedure TPGSQLParserTest.DomainAlter16;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain16']);
end;

procedure TPGSQLParserTest.DomainAlter17;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain17']);
end;

procedure TPGSQLParserTest.DomainAlter18;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain18']);
end;

procedure TPGSQLParserTest.DomainAlter19;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain19']);
end;

procedure TPGSQLParserTest.DomainAlter20;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain20']);
end;

procedure TPGSQLParserTest.DomainAlter21;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain21']);
end;

procedure TPGSQLParserTest.DomainDrop;
begin
  DoTestSQL(PGSQLParserData.sDomain['DropDomain1']);
end;

procedure TPGSQLParserTest.CreateView1;
begin
  DoTestSQL(PGSQLParserData.sView['CreateView1']);
end;

procedure TPGSQLParserTest.CreateView2;
begin
  DoTestSQL(PGSQLParserData.sView['CreateView2']);
end;

procedure TPGSQLParserTest.CreateView3;
begin
  DoTestSQL(PGSQLParserData.sView['CreateView3']);
end;

procedure TPGSQLParserTest.CreateView4;
begin
  DoTestSQL(PGSQLParserData.sView['CreateView4']);
end;

procedure TPGSQLParserTest.CreateView5;
begin
  DoTestSQL(PGSQLParserData.sView['CreateView5']);
end;

procedure TPGSQLParserTest.AlterView1;
begin
  DoTestSQL(PGSQLParserData.sView['AlterView1']);
end;

procedure TPGSQLParserTest.AlterView2;
begin
  DoTestSQL(PGSQLParserData.sView['AlterView2']);
end;

procedure TPGSQLParserTest.DropView;
begin
  DoTestSQL(PGSQLParserData.sView['DropView1']);
end;

procedure TPGSQLParserTest.CreateMaterializedView;
begin
  DoTestSQL(PGSQLParserData.sView['CreateMaterializedView1']);
end;

procedure TPGSQLParserTest.AlterMaterializedView;
begin
  DoTestSQL(PGSQLParserData.sView['AlterMaterializedView1']);
end;

procedure TPGSQLParserTest.DropMaterializedView;
begin
  DoTestSQL(PGSQLParserData.sView['DropMaterializedView1']);
end;

procedure TPGSQLParserTest.CreateTrigger1;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateTrigger1']);
end;

procedure TPGSQLParserTest.CreateTrigger2;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateTrigger2']);
end;

procedure TPGSQLParserTest.CreateTrigger3;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateTrigger3']);
end;

procedure TPGSQLParserTest.CreateTrigger4;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateTrigger4']);
end;

procedure TPGSQLParserTest.CreateTrigger5;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateTrigger5']);
end;

procedure TPGSQLParserTest.CreateTrigger6;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateTrigger6']);
end;

procedure TPGSQLParserTest.CreateTrigger7;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateTrigger7']);
end;

procedure TPGSQLParserTest.AlterTrigger1;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterTrigger1']);
end;

procedure TPGSQLParserTest.AlterTrigger2;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterTrigger2']);
end;

procedure TPGSQLParserTest.DropTrigger;
begin
  DoTestSQL(PGSQLParserData.sFunctions['DropTrigger1']);
end;

procedure TPGSQLParserTest.AlterFunction1;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterFunction1']);
end;

procedure TPGSQLParserTest.AlterFunction2;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterFunction2']);
end;

procedure TPGSQLParserTest.AlterFunction3;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterFunction3']);
end;

procedure TPGSQLParserTest.AlterFunction4;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterFunction4']);
end;

procedure TPGSQLParserTest.AlterFunction5;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterFunction5']);
end;

procedure TPGSQLParserTest.AlterFunction6;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterFunction6']);
end;

procedure TPGSQLParserTest.CreateFunction1;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateFunction1']);
end;

procedure TPGSQLParserTest.CreateFunction2;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateFunction2']);
end;

procedure TPGSQLParserTest.CreateFunction3;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateFunction3']);
end;

procedure TPGSQLParserTest.CreateFunction4;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateFunction4']);
end;

procedure TPGSQLParserTest.CreateFunction5;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateFunction5']);
end;

procedure TPGSQLParserTest.CreateFunction6;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateFunction6']);
end;

procedure TPGSQLParserTest.DropFunction1;
begin
  DoTestSQL(PGSQLParserData.sFunctions['DropFunction1']);
end;

procedure TPGSQLParserTest.DropFunction2;
begin
  DoTestSQL(PGSQLParserData.sFunctions['DropFunction2']);
end;

procedure TPGSQLParserTest.DropFunction3;
begin
  DoTestSQL(PGSQLParserData.sFunctions['DropFunction3']);
end;

procedure TPGSQLParserTest.DropFunction4;
begin
  DoTestSQL(PGSQLParserData.sFunctions['DropFunction4']);
end;

procedure TPGSQLParserTest.AlterSequence;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterSequence1']);
end;

procedure TPGSQLParserTest.CreateSequence;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateSequence1']);
end;

procedure TPGSQLParserTest.DropSequence;
begin
  DoTestSQL(PGSQLParserData.sTable['DropSequence1']);
end;

procedure TPGSQLParserTest.AlterIndex1;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterIndex1']);
end;

procedure TPGSQLParserTest.AlterIndex2;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterIndex2']);
end;

procedure TPGSQLParserTest.AlterIndex3;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterIndex3']);
end;

procedure TPGSQLParserTest.CreateIndex1;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateIndex1']);
end;

procedure TPGSQLParserTest.CreateIndex2;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateIndex2']);
end;

procedure TPGSQLParserTest.CreateIndex3;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateIndex3']);
end;

procedure TPGSQLParserTest.CreateIndex4;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateIndex4']);
end;

procedure TPGSQLParserTest.CreateIndex5;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateIndex5']);
end;

procedure TPGSQLParserTest.CreateIndex6;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateIndex6']);
end;

procedure TPGSQLParserTest.CreateIndex7;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateIndex7']);
end;

procedure TPGSQLParserTest.CreateIndex8;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateIndex8']);
end;

procedure TPGSQLParserTest.CreateIndex9;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateIndex9']);
end;

procedure TPGSQLParserTest.DropIndex;
begin
  DoTestSQL(PGSQLParserData.sTable['DropIndex1']);
end;

procedure TPGSQLParserTest.AlterGroup1;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterGroup1']);
end;

procedure TPGSQLParserTest.AlterGroup2;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterGroup2']);
end;

procedure TPGSQLParserTest.CreateGroup;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreateGroup1']);
end;

procedure TPGSQLParserTest.DropGroup;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['DropGroup1']);
end;

procedure TPGSQLParserTest.AlterServer1;
begin
  DoTestSQL(PGSQLParserData.sDataBase['AlterServer1']);
end;

procedure TPGSQLParserTest.AlterServer2;
begin
  DoTestSQL(PGSQLParserData.sDataBase['AlterServer2']);
end;

procedure TPGSQLParserTest.CreateServer;
begin
  DoTestSQL(PGSQLParserData.sDataBase['CreateServer1']);
end;

procedure TPGSQLParserTest.DropServer;
begin
  DoTestSQL(PGSQLParserData.sDataBase['DropServer1']);
end;

procedure TPGSQLParserTest.CreateDatabase1;
begin
  DoTestSQL(PGSQLParserData.sDataBase['CreateDatabase1']);
end;

procedure TPGSQLParserTest.CreateDatabase2;
begin
  DoTestSQL(PGSQLParserData.sDataBase['CreateDatabase2']);
end;

procedure TPGSQLParserTest.CreateDatabase3;
begin
  DoTestSQL(PGSQLParserData.sDataBase['CreateDatabase3']);
end;

procedure TPGSQLParserTest.CreateDatabase4;
begin
  DoTestSQL(PGSQLParserData.sDataBase['CreateDatabase4']);
end;

procedure TPGSQLParserTest.AlterDatabase;
begin
  DoTestSQL(PGSQLParserData.sDataBase['AlterDatabase1']);
end;

procedure TPGSQLParserTest.DropDatabase;
begin
  DoTestSQL(PGSQLParserData.sDataBase['DropDatabase1']);
end;

procedure TPGSQLParserTest.AlterType1;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterType1']);
end;

procedure TPGSQLParserTest.AlterType2;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterType2']);
end;

procedure TPGSQLParserTest.AlterType3;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterType3']);
end;

procedure TPGSQLParserTest.AlterType4;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterType4']);
end;

procedure TPGSQLParserTest.AlterType5;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterType5']);
end;

procedure TPGSQLParserTest.AlterType6;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterType6']);
end;

procedure TPGSQLParserTest.CreateType1;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateType1']);
end;

procedure TPGSQLParserTest.CreateType2;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateType2']);
end;

procedure TPGSQLParserTest.CreateType3;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateType3']);
end;

procedure TPGSQLParserTest.CreateType4;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateType4']);
end;

procedure TPGSQLParserTest.CreateType5;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateType5']);
end;

procedure TPGSQLParserTest.CreateType6;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateType6']);
end;

procedure TPGSQLParserTest.CreateType7;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateType7']);
end;

procedure TPGSQLParserTest.DropType;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropType1']);
end;

procedure TPGSQLParserTest.AlterUserMapping;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterUserMapping1']);
end;

procedure TPGSQLParserTest.CreateUserMapping;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreateUserMapping1']);
end;

procedure TPGSQLParserTest.DropUserMapping;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['DropUserMapping1']);
end;

procedure TPGSQLParserTest.CreateTransform;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateTransform1']);
end;

procedure TPGSQLParserTest.DropTransform;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropTransform1']);
end;

procedure TPGSQLParserTest.AlterTextSearchConfiguration;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterTextSearchConfiguration1']);
end;

procedure TPGSQLParserTest.AlterTextSearchDictionary1;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterTextSearchDictionary1']);
end;

procedure TPGSQLParserTest.AlterTextSearchDictionary2;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterTextSearchDictionary2']);
end;

procedure TPGSQLParserTest.AlterTextSearchDictionary3;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterTextSearchDictionary3']);
end;

procedure TPGSQLParserTest.AlterTextSearchParser1;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterTextSearchParser1']);
end;

procedure TPGSQLParserTest.AlterTextSearchParser2;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterTextSearchParser2']);
end;

procedure TPGSQLParserTest.AlterTextSearchTemplate1;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterTextSearchTemplate1']);
end;

procedure TPGSQLParserTest.AlterTextSearchTemplate2;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterTextSearchTemplate2']);
end;

procedure TPGSQLParserTest.CreateTextSearchConfiguration;
begin
  DoTestSQL(PGSQLParserData.sAggregate['sCreateTextSearchConfiguration1']);
end;

procedure TPGSQLParserTest.CreateTextSearchDictionary;
begin
  DoTestSQL(PGSQLParserData.sAggregate['CreateTextSearchDictionary1']);
end;

procedure TPGSQLParserTest.CreateTextSearchParser;
begin
  DoTestSQL(PGSQLParserData.sAggregate['CreateTextSearchParser1']);
end;

procedure TPGSQLParserTest.CreateTextSearchTemplate;
begin
  DoTestSQL(PGSQLParserData.sAggregate['CreateTextSearchTemplate1']);
end;

procedure TPGSQLParserTest.DropTextSearchConfiguration;
begin
  DoTestSQL(PGSQLParserData.sAggregate['DropTextSearchConfiguration1']);
end;

procedure TPGSQLParserTest.DropTextSearchDictionary;
begin
  DoTestSQL(PGSQLParserData.sAggregate['DropTextSearchDictionary1']);
end;

procedure TPGSQLParserTest.DropTextSearchParser;
begin
  DoTestSQL(PGSQLParserData.sAggregate['DropTextSearchParser1']);
end;

procedure TPGSQLParserTest.DropTextSearchTemplate;
begin
  DoTestSQL(PGSQLParserData.sAggregate['DropTextSearchTemplate1']);
end;

procedure TPGSQLParserTest.AlterTablespace1;
begin
  DoTestSQL(PGSQLParserData.sDataBase['AlterTablespace1']);
end;

procedure TPGSQLParserTest.AlterTablespace2;
begin
  DoTestSQL(PGSQLParserData.sDataBase['AlterTablespace2']);
end;

procedure TPGSQLParserTest.CreateTablespace1;
begin
  DoTestSQL(PGSQLParserData.sDataBase['CreateTablespace1']);
end;

procedure TPGSQLParserTest.CreateTablespace2;
begin
  DoTestSQL(PGSQLParserData.sDataBase['CreateTablespace2']);
end;

procedure TPGSQLParserTest.DropTablespace;
begin
  DoTestSQL(PGSQLParserData.sDataBase['DropTablespace1']);
end;

procedure TPGSQLParserTest.AlterRule;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterRule1']);
end;

procedure TPGSQLParserTest.CreateRule1;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateRule1']);
end;

procedure TPGSQLParserTest.CreateRule2;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateRule2']);
end;

procedure TPGSQLParserTest.CreateRule3;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateRule3']);
end;

procedure TPGSQLParserTest.DropRule;
begin
  DoTestSQL(PGSQLParserData.sTable['DropRule1']);
end;

procedure TPGSQLParserTest.AlterPolicy;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterPolicy1']);
end;

procedure TPGSQLParserTest.CreatePolicy1;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreatePolicy1']);
end;

procedure TPGSQLParserTest.CreatePolicy2;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreatePolicy2']);
end;

procedure TPGSQLParserTest.CreatePolicy3;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreatePolicy3']);
end;

procedure TPGSQLParserTest.CreatePolicy4;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreatePolicy4']);
end;

procedure TPGSQLParserTest.CreatePolicy5;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreatePolicy5']);
end;

procedure TPGSQLParserTest.CreatePolicy6;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreatePolicy6']);
end;

procedure TPGSQLParserTest.CreatePolicy7;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreatePolicy7']);
end;

procedure TPGSQLParserTest.DropPolicy;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['DropPolicy1']);
end;

procedure TPGSQLParserTest.DropOwned;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['DropOwned1']);
end;

procedure TPGSQLParserTest.AlterOperator1;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterOperator1']);
end;

procedure TPGSQLParserTest.AlterOperator2;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterOperator2']);
end;

procedure TPGSQLParserTest.AlterOperatorClass;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterOperatorClass1']);
end;

procedure TPGSQLParserTest.AlterOperatorFamily1;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterOperatorFamily1']);
end;

procedure TPGSQLParserTest.AlterOperatorFamily2;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterOperatorFamily2']);
end;

procedure TPGSQLParserTest.CreateOperator;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateOperator1']);
end;

procedure TPGSQLParserTest.CreateOperatorClass;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateOperatorClass1']);
end;

procedure TPGSQLParserTest.CreateOperatorFamily;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateOperatorFamily1']);
end;

procedure TPGSQLParserTest.DropOperator1;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropOperator1']);
end;

procedure TPGSQLParserTest.DropOperator2;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropOperator2']);
end;

procedure TPGSQLParserTest.DropOperator3;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropOperator3']);
end;

procedure TPGSQLParserTest.DropOperator4;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropOperator4']);
end;

procedure TPGSQLParserTest.DropOperatorClass;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropOperatorClass1']);
end;

procedure TPGSQLParserTest.DropOperatorFamily;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropOperatorFamily1']);
end;

procedure TPGSQLParserTest.AlterForeignDataWrapper1;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterForeignDataWrapper1']);
end;

procedure TPGSQLParserTest.AlterForeignDataWrapper2;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterForeignDataWrapper2']);
end;

procedure TPGSQLParserTest.AlterForeignTable1;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterForeignTable1']);
end;

procedure TPGSQLParserTest.AlterForeignTable2;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterForeignTable2']);
end;

procedure TPGSQLParserTest.CreateForeignDataWrapper1;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateForeignDataWrapper1']);
end;

procedure TPGSQLParserTest.CreateForeignDataWrapper2;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateForeignDataWrapper2']);
end;

procedure TPGSQLParserTest.CreateForeignDataWrapper3;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateForeignDataWrapper3']);
end;

procedure TPGSQLParserTest.CreateForeignTable1;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateForeignTable1']);
end;

procedure TPGSQLParserTest.CreateForeignTable2;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateForeignTable2']);
end;

procedure TPGSQLParserTest.DropForeignDataWrapper;
begin
  DoTestSQL(PGSQLParserData.sTable['DropForeignDataWrapper1']);
end;

procedure TPGSQLParserTest.DropForeignTable;
begin
  DoTestSQL(PGSQLParserData.sTable['DropForeignTable1']);
end;

procedure TPGSQLParserTest.AlterExtension1;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterExtension1']);
end;

procedure TPGSQLParserTest.AlterExtension2;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterExtension2']);
end;

procedure TPGSQLParserTest.AlterExtension3;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterExtension3']);
end;

procedure TPGSQLParserTest.CreateExtension1;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateExtension1']);
end;

procedure TPGSQLParserTest.CreateExtension2;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateExtension2']);
end;

procedure TPGSQLParserTest.DropExtension;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropExtension1']);
end;

procedure TPGSQLParserTest.AlterLanguage1;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterLanguage1']);
end;

procedure TPGSQLParserTest.AlterLanguage2;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterLanguage2']);
end;

procedure TPGSQLParserTest.CreateLanguage1;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateLanguage1']);
end;

procedure TPGSQLParserTest.CreateLanguage2;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateLanguage2']);
end;

procedure TPGSQLParserTest.DropLanguage;
begin
  DoTestSQL(PGSQLParserData.sFunctions['DropLanguage1']);
end;

procedure TPGSQLParserTest.AlterEventTrigger1;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterEventTrigger1']);
end;

procedure TPGSQLParserTest.AlterEventTrigger2;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterEventTrigger2']);
end;

procedure TPGSQLParserTest.AlterEventTrigger3;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterEventTrigger3']);
end;

procedure TPGSQLParserTest.AlterEventTrigger4;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterEventTrigger4']);
end;

procedure TPGSQLParserTest.CreateEventTrigger;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateEventTrigger1']);
end;

procedure TPGSQLParserTest.DropEventTrigger;
begin
  DoTestSQL(PGSQLParserData.sFunctions['DropEventTrigger1']);
end;

procedure TPGSQLParserTest.DropConversion;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropConversion1']);
end;

procedure TPGSQLParserTest.AlterConversion1;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterConversion1']);
end;

procedure TPGSQLParserTest.AlterConversion2;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterConversion2']);
end;

procedure TPGSQLParserTest.CreateConversion;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateConversion1']);
end;

procedure TPGSQLParserTest.AlterCollation1;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterCollation1']);
end;

procedure TPGSQLParserTest.AlterCollation2;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterCollation2']);
end;

procedure TPGSQLParserTest.CreateCollation1;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateCollation1']);
end;

procedure TPGSQLParserTest.CreateCollation2;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateCollation2']);
end;

procedure TPGSQLParserTest.CreateCollation3;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateCollation3']);
end;

procedure TPGSQLParserTest.DropCollation;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropCollation1']);
end;

procedure TPGSQLParserTest.CreateCast;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateCast1']);
end;

procedure TPGSQLParserTest.DropCast;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropCast1']);
end;

procedure TPGSQLParserTest.CreateAccessMethod;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateAccessMethod1']);
end;

procedure TPGSQLParserTest.DropAccessMethod;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropAccessMethod1']);
end;

procedure TPGSQLParserTest.AlterAggregate1;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterAggregate1']);
end;

procedure TPGSQLParserTest.AlterAggregate2;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterAggregate2']);
end;

procedure TPGSQLParserTest.AlterAggregate3;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterAggregate3']);
end;

procedure TPGSQLParserTest.AlterAggregate4;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterAggregate4']);
end;

procedure TPGSQLParserTest.CreateAggregate1;
begin
  DoTestSQL(PGSQLParserData.sAggregate['CreateAggregate1']);
end;

procedure TPGSQLParserTest.CreateAggregate2;
begin
  DoTestSQL(PGSQLParserData.sAggregate['CreateAggregate2']);
end;

procedure TPGSQLParserTest.CreateAggregate3;
begin
  DoTestSQL(PGSQLParserData.sAggregate['CreateAggregate3']);
end;

procedure TPGSQLParserTest.CreateAggregate4;
begin
  DoTestSQL(PGSQLParserData.sAggregate['CreateAggregate4']);
end;

procedure TPGSQLParserTest.CreateAggregate5;
begin
  DoTestSQL(PGSQLParserData.sAggregate['CreateAggregate5']);
end;

procedure TPGSQLParserTest.CreateAggregate6;
begin
  DoTestSQL(PGSQLParserData.sAggregate['CreateAggregate6']);
end;

procedure TPGSQLParserTest.CreateAggregate7;
begin
  DoTestSQL(PGSQLParserData.sAggregate['CreateAggregate7']);
end;

procedure TPGSQLParserTest.DropAggregate1;
begin
  DoTestSQL(PGSQLParserData.sAggregate['DropAggregate1']);
end;

procedure TPGSQLParserTest.DropAggregate2;
begin
  DoTestSQL(PGSQLParserData.sAggregate['DropAggregate2']);
end;

procedure TPGSQLParserTest.DropAggregate3;
begin
  DoTestSQL(PGSQLParserData.sAggregate['DropAggregate3']);
end;

procedure TPGSQLParserTest.AlterDefaultPrivileges1;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterDefaultPrivileges1']);
end;

procedure TPGSQLParserTest.AlterDefaultPrivileges2;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterDefaultPrivileges2']);
end;

procedure TPGSQLParserTest.AlterDefaultPrivileges3;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterDefaultPrivileges3']);
end;

procedure TPGSQLParserTest.AlterDefaultPrivileges4;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterDefaultPrivileges4']);
end;

procedure TPGSQLParserTest.AlterDefaultPrivileges5;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterDefaultPrivileges5']);
end;

procedure TPGSQLParserTest.AlterLargeObject;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterLargeObject1']);
end;

procedure TPGSQLParserTest.AlterSystem1;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterSystem1']);
end;

procedure TPGSQLParserTest.AlterSystem2;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterSystem2']);
end;

procedure TPGSQLParserTest.CreateTableAs1;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTableAs1']);
end;

procedure TPGSQLParserTest.CreateTableAs2;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTableAs2']);
end;

procedure TPGSQLParserTest.CreateTableAs3;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTableAs3']);
end;

procedure TPGSQLParserTest.CreateTable1;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable1']);
end;

procedure TPGSQLParserTest.CreateTable2;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable2']);
end;

procedure TPGSQLParserTest.CreateTable3;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable3']);
end;

procedure TPGSQLParserTest.CreateTable4;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable4']);
end;

procedure TPGSQLParserTest.CreateTable5;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable5']);
end;

procedure TPGSQLParserTest.CreateTable6;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable6']);
end;

procedure TPGSQLParserTest.CreateTable7;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable7']);
end;

procedure TPGSQLParserTest.CreateTable8;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable8']);
end;

procedure TPGSQLParserTest.CreateTable9;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable9']);
end;

procedure TPGSQLParserTest.CreateTable10;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable10']);
end;

procedure TPGSQLParserTest.CreateTable11;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable11']);
end;

procedure TPGSQLParserTest.CreateTable12;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable12']);
end;

procedure TPGSQLParserTest.CreateTable13;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable13']);
end;

procedure TPGSQLParserTest.CreateTable14;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable14']);
end;

procedure TPGSQLParserTest.CreateTable15;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable15']);
end;

procedure TPGSQLParserTest.CreateTable16;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable16']);
end;

procedure TPGSQLParserTest.CreateTable17;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable17']);
end;

procedure TPGSQLParserTest.CreateTable18;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable18']);
end;

procedure TPGSQLParserTest.CreateTable19;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable19']);
end;

procedure TPGSQLParserTest.CreateTabl20;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable20']);
end;

procedure TPGSQLParserTest.CreateTable21;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable21']);
end;

procedure TPGSQLParserTest.CreateTable22;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable22']);
end;

procedure TPGSQLParserTest.CreateTable23;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable23']);
end;

procedure TPGSQLParserTest.CreateTable24;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable24']);
end;

procedure TPGSQLParserTest.CreateTable25;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable25']);
end;

procedure TPGSQLParserTest.CreateTable26;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable26']);
end;

procedure TPGSQLParserTest.CreateTable27;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable27']);
end;

procedure TPGSQLParserTest.CreateTable28;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable28']);
end;

procedure TPGSQLParserTest.CreateTable29;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable29']);
end;

procedure TPGSQLParserTest.CreateTable30;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable30']);
end;

procedure TPGSQLParserTest.AlterTable1;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterTable1']);
end;

procedure TPGSQLParserTest.AlterTable2;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterTable2']);
end;

procedure TPGSQLParserTest.DropTable1;
begin
  DoTestSQL(PGSQLParserData.sTable['DropTable1']);
end;

procedure TPGSQLParserTest.DropTable2;
begin
  DoTestSQL(PGSQLParserData.sTable['DropTable2']);
end;


initialization
  RegisterTest(TPGSQLParserTest);
end.


