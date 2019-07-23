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
    procedure c001SQLAbort1; //ABORT — прервать текущую транзакцию
    procedure c002SQLAbort2;
    procedure c003SQLAbort3;
    procedure c004SQLComment1; //COMMENT — задать или изменить комментарий объекта
    procedure c005SQLComment2;
    procedure c006SQLComment3;
    procedure c007SQLComment4;
    procedure c008SQLComment5;
    procedure c009SQLComment6;
    procedure c010SQLComment7;
    procedure c011SQLComment8;
    procedure c012SQLComment9;
    procedure c013SQLComment10;
    procedure c014SQLComment11;
    procedure c015SQLComment12;
    procedure c015SQLComment13;
    procedure c016SQLComment14;
    procedure c017SQLComment15;
    procedure c018SQLComment16;
    procedure c019SQLComment17;
    procedure c020SQLComment18;
    procedure c021SQLComment19;
    procedure c022SQLComment20;
    procedure c023SQLComment21;
    procedure c024SQLComment22;
    procedure c025SQLComment23;
    procedure c026SQLComment24;
    procedure c027SQLComment25;
    procedure c028SQLComment26;
    procedure c029SQLComment27;
    procedure c030SQLComment28;
    procedure c031SQLComment29;
    procedure c032SQLComment30;
    procedure c033SQLComment31;
    procedure c034SQLComment32;
    procedure c035SQLComment33;
    procedure c036SQLComment34;
    procedure c037SQLComment35;
    procedure c038SQLComment36;
    procedure c039SQLComment37;
    procedure c040SQLComment38;
    procedure c041SQLComment39;
    procedure c042SQLComment40;
    procedure c043SQLComment41;
    procedure c044SQLClose1;//CLOSE — закрыть курсор
    procedure c045SQLClose2;
    procedure c046Commit1;//COMMIT — зафиксировать текущую транзакцию
    procedure c047Commit2;
    procedure c048Commit3;
    procedure c049SQLBegin1; //BEGIN — начать блок транзакции
    procedure c050SQLBegin2;
    procedure c051SQLBegin3;
    procedure c052SQLVacuum; //VACUUM — провести сборку мусора и, возможно, проанализировать базу данных
    procedure c053SQLDiscard1; //DISCARD — очистить состояние сеанса
    procedure c054SQLDiscard2;
    procedure c055SQLDiscard3;
    procedure c056SQLDiscard4;
    procedure c057SQLGrant1; //GRANT — определить права доступа
    procedure c058SQLGrant2;
    procedure c059SQLGrant3;
    procedure c060SQLAnalyze; //ANALYZE — собрать статистику по базе данных
    procedure c061SQLCheckpoint; //CHECKPOINT — записать контрольную точку в журнал транзакций
    procedure c062SQLCluster1; //CLUSTER — кластеризовать таблицу согласно индексу
    procedure c063SQLCluster2;
    procedure c064SQLCluster3;
    procedure c065SQLCommitPrepared; //COMMIT PREPARED — зафиксировать транзакцию, которая ранее была подготовлена для двухфазной фиксации
    procedure c066SQLCopy1; //COPY — копировать данные между файлом и таблицей
    procedure c067SQLCopy2;
    procedure c068SQLCopy3;
    procedure c069SQLCopy4;
    procedure c070SQLDo; //DO — выполнить анонимный блок кода
    procedure c071SQLDeallocate; //DEALLOCATE — освободить подготовленный оператор
    procedure c072SQLDeclare; //DECLARE — определить курсор
    procedure c073SQLDelete1; //DELETE — удалить записи таблицы
    procedure c074SQLDelete2;
    procedure c075SQLDelete3;
    procedure c076SQLDelete4;
    procedure c077SQLDelete5;
    procedure c078SQLDelete6;
    procedure c079SQLEnd1; //END — зафиксировать текущую транзакцию
    procedure c080SQLEnd2;
    procedure c081SQLExecute1; //EXECUTE — выполнить подготовленный оператор
    procedure c082SQLExecute2;
    procedure c083SQLExplain1; //EXPLAIN — показать план выполнения оператора
    procedure c084SQLExplain2;
    procedure c085SQLFetch1; //FETCH — получить результат запроса через курсор
    procedure c086SQLFetch2;
    procedure c087SQLImportForeignSchema1; //IMPORT FOREIGN SCHEMA — импортировать определения таблиц со стороннего сервера
    procedure c088SQLImportForeignSchema2;
    procedure c089SQLInsert1; //INSERT — добавить строки в таблицу
    procedure c090SQLInsert2;
    procedure c091SQLInsert3;
    procedure c092SQLInsert4;
    procedure c093SQLInsert5;
    procedure c094SQLInsert6;
    procedure c095SQLInsert7;
    procedure c096SQLInsert8;
    procedure c097SQLInsert9;
    procedure c098SQLInsert10;
    procedure c099SQLInsert11;
    procedure c100SQLInsert12;
    procedure c101SQLInsert13;
    procedure c102SQLInsert14;
    procedure c103SQLInsert15;
    procedure c104SQLInsert16;
    procedure c105SQLListen; //LISTEN — ожидать уведомления
    procedure c106SQLLoad; //LOAD — загрузить файл разделяемой библиотеки
    procedure c107SQLLock1; //LOCK — заблокировать таблицу
    procedure c108SQLLock2;
    procedure c109SQLMove1; //MOVE — переместить курсор
    procedure c110SQLMove2;
    procedure c111SQLNotify1; //NOTIFY — сгенерировать уведомление
    procedure c112SQLNotify2;
    procedure c113SQLPrepare1; //PREPARE — подготовить оператор к выполнению
    procedure c114SQLPrepare2;
    procedure c115SQLPrepareTransaction; //PREPARE TRANSACTION — подготовить текущую транзакцию для двухфазной фиксации
    procedure c116SQLReassignOwned; //REASSIGN OWNED — сменить владельца объектов базы данных, принадлежащих заданной роли
    procedure c117SQLRefreshMaterializedView1; //REFRESH MATERIALIZED VIEW — заменить содержимое материализованного представления
    procedure c118SQLRefreshMaterializedView2;
    procedure c119SQLReindex1; //REINDEX — перестроить индексы
    procedure c120SQLReindex2;
    procedure c121SQLReindex3;
    procedure c122SQLSavepoint; //RELEASE SAVEPOINT — высвободить ранее определённую точку сохранения
    procedure c123SQLReset1; //RESET — восстановить значение по умолчанию заданного параметра времени выполнения
    procedure c124SQLReset2;
    procedure c125SQLRevoke1; //REVOKE — отозвать права доступа
    procedure c126SQLRevoke2;
    procedure c127SQLRevoke3;
    procedure c128SQLRevoke4;
    procedure c129SQLRevoke5;
    procedure c130SQLRollback1; //ROLLBACK — прервать текущую транзакцию
    procedure c131SQLRollback2;
    procedure c132SQLRollback3;
    procedure c133SQLRollbackPrepared; //ROLLBACK PREPARED — отменить транзакцию, которая ранее была подготовлена для двухфазной фиксации
    procedure c134SQLRollbackToSavepoint; //ROLLBACK TO SAVEPOINT — откатиться к точке сохранения
    procedure c135SQLSecurityLabel; //SECURITY LABEL — определить или изменить метку безопасности, применённую к объекту
    procedure c136SQLSelect1; //SELECT — получить строки из таблицы или представления
    procedure c137SQLSelect2;
    procedure c138SQLSelect3;
    procedure c139SQLSelect4;
    procedure c140SQLSelect5;
    procedure c141SQLSelect6;
    procedure c142SQLSelect7;
    procedure c143SQLSelect8;
    procedure c144SQLSelect9;
    procedure c145SQLSelect10;
    procedure c146SQLSelect11;
    procedure c147SQLSelect12;
    procedure c148SQLSelect13;
    procedure c149SQLSelectInto; //SELECT INTO — создать таблицу из результатов запроса
    procedure c150SQLSet1; //SET — изменить параметр времени выполнения
    procedure c151SQLSet2;
    procedure c152SQLSet3;
    procedure c153SQLSet4;
    procedure c154SQLSetConstraints; //SET CONSTRAINTS — установить время проверки ограничений для текущей транзакции
    procedure c155SQLSetRole; //SET ROLE — установить идентификатор текущего пользователя в рамках сеанса
    procedure c156SQLSetSessionAuthorization; //SET SESSION AUTHORIZATION — установить идентификатор пользователя сеанса и идентификатор текущего пользователя в рамках сеанса
    procedure c157SQLSetTransaction; //SET TRANSACTION — установить характеристики текущей транзакции
    procedure c158SQLShow1; //SHOW — показать значение параметра времени выполнения
    procedure c159SQLShow2;
    procedure c160SQLShow3;
    procedure c161SQLStartTransaction; //START TRANSACTION — начать блок транзакции
    procedure c162SQLTruncate1; //TRUNCATE — опустошить таблицу или набор таблиц
    procedure c163SQLTruncate2;
    procedure c164SQLTruncate3;
    procedure c165SQLUnlisten; //UNLISTEN — прекратить ожидание уведомления
    procedure c166SQLUpdate1; //UPDATE — изменить строки таблицы
    procedure c167SQLUpdate2;
    procedure c168SQLUpdate3;
    procedure c169SQLUpdate4;
    procedure c170SQLUpdate5;
    procedure c171SQLUpdate6;
    procedure c172SQLUpdate7;
    procedure c173SQLUpdate8;
    procedure c174SQLUpdate9;
    procedure c175SQLUpdate10;
    procedure c176SQLValues1; //VALUES — вычислить набор строк
    procedure c177SQLValues2;
    procedure c178AlterSchema1; //ALTER SCHEMA — изменить определение схемы
    procedure c179AlterSchema2;
    procedure c180CreateSchema1; //CREATE SCHEMA — создать схему
    procedure c181CreateSchema2;
    procedure c182CreateSchema3;
    procedure c183CreateSchema4;
    procedure c184DropSchema; //DROP SCHEMA — удалить схему
    procedure c185DomainCreate; //CREATE DOMAIN — создать домен
    procedure c186DomainAlter1; //ALTER DOMAIN — изменить определение домена
    procedure c187DomainAlter2;
    procedure c188DomainAlter3;
    procedure c189DomainAlter4;
    procedure c190DomainAlter5;
    procedure c191DomainAlter6;
    procedure c192DomainAlter7;
    procedure c193DomainAlter8;
    procedure c194DomainAlter9;
    procedure c195DomainAlter10;
    procedure c196DomainAlter11;
    procedure c197DomainAlter12;
    procedure c198DomainAlter13;
    procedure c199DomainAlter14;
    procedure c200DomainAlter15;
    procedure c201DomainAlter16;
    procedure c202DomainAlter17;
    procedure c203DomainAlter18;
    procedure c204DomainAlter19;
    procedure c205DomainAlter20;
    procedure c206DomainAlter21;
    procedure c207DomainDrop; //DROP DOMAIN — удалить домен
    procedure c208CreateView1; //CREATE VIEW — создать представление
    procedure c209CreateView2;
    procedure c210CreateView3;
    procedure c211CreateView4;
    procedure c212CreateView5;
    procedure c213AlterView1; //ALTER VIEW — изменить определение представления
    procedure c214AlterView2;
    procedure c215DropView; //DROP VIEW — удалить представление
    procedure c216CreateMaterializedView; //CREATE MATERIALIZED VIEW — создать материализованное представление
    procedure c217AlterMaterializedView; //ALTER MATERIALIZED VIEW — изменить определение материализованного представления
    procedure c218DropMaterializedView; //DROP MATERIALIZED VIEW — удалить материализованное представление
    procedure c219CreateTrigger1; //ALTER TRIGGER — изменить определение триггера
    procedure c220CreateTrigger2;
    procedure c221CreateTrigger3;
    procedure c222CreateTrigger4;
    procedure c223CreateTrigger5;
    procedure c224CreateTrigger6;
    procedure c225CreateTrigger7;
    procedure c226AlterTrigger1; //CREATE TRIGGER — создать триггер
    procedure c227AlterTrigger2;
    procedure c228DropTrigger; //DROP TRIGGER — удалить триггер
    procedure c229AlterFunction1; //ALTER FUNCTION — изменить определение функции
    procedure c230AlterFunction2;
    procedure c231AlterFunction3;
    procedure c232AlterFunction4;
    procedure c233AlterFunction5;
    procedure c234AlterFunction6;
    procedure c235CreateFunction1; //CREATE FUNCTION — создать функцию
    procedure c236CreateFunction2;
    procedure c237CreateFunction3;
    procedure c238CreateFunction4;
    procedure c239CreateFunction5;
    procedure c240CreateFunction6;
    procedure c241DropFunction1; //DROP FUNCTION — удалить функцию
    procedure c242DropFunction2;
    procedure c243DropFunction3;
    procedure c244DropFunction4;
    procedure c245AlterSequence; //ALTER SEQUENCE — изменить определение генератора последовательности
    procedure c246CreateSequence;//CREATE SEQUENCE — создать генератор последовательности
    procedure c247DropSequence; //DROP SEQUENCE — удалить последовательность
    procedure c248AlterIndex1; //ALTER INDEX — изменить определение индекса
    procedure c249AlterIndex2;
    procedure c250AlterIndex3;
    procedure c251CreateIndex1; //CREATE INDEX — создать индекс
    procedure c252CreateIndex2;
    procedure c253CreateIndex3;
    procedure c254CreateIndex4;
    procedure c255CreateIndex5;
    procedure c256CreateIndex6;
    procedure c257CreateIndex7;
    procedure c258CreateIndex8;
    procedure c259CreateIndex9;
    procedure c260DropIndex; //DROP INDEX — удалить индекс
    procedure c261AlterGroup1; //ALTER GROUP — изменить имя роли или членство
    procedure c262AlterGroup2;
    procedure c263CreateGroup; //CREATE GROUP — создать роль в базе данных
    procedure c264DropGroup; //DROP GROUP — удалить роль в базе данных
    procedure c265AlterServer1; //ALTER SERVER — изменить определение стороннего сервера
    procedure c266AlterServer2;
    procedure c267CreateServer; //CREATE SERVER — создать сторонний сервер
    procedure c268DropServer; //DROP SERVER — удалить описание стороннего сервера
    procedure c269CreateDatabase1; //CREATE DATABASE — создать базу данных
    procedure c270CreateDatabase2;
    procedure c271CreateDatabase3;
    procedure c272CreateDatabase4;
    procedure c273AlterDatabase; //ALTER DATABASE — изменить атрибуты базы данных
    procedure c274DropDatabase; //DROP DATABASE — удалить базу данных
    procedure c275AlterType1; //ALTER TYPE — изменить определение типа
    procedure c276AlterType2;
    procedure c277AlterType3;
    procedure c278AlterType4;
    procedure c279AlterType5;
    procedure c280AlterType6;
    procedure c281CreateType1; //CREATE TYPE — создать новый тип данных
    procedure c282CreateType2;
    procedure c283CreateType3;
    procedure c284CreateType4;
    procedure c285CreateType5;
    procedure c286CreateType6;
    procedure c287CreateType7;
    procedure c288DropType; //DROP TYPE — удалить тип данных
    procedure c289AlterUserMapping; //ALTER USER MAPPING — изменить определение сопоставления пользователей
    procedure c290CreateUserMapping; //CREATE USER MAPPING — создать сопоставление пользователя для стороннего сервера
    procedure c291DropUserMapping; //DROP USER MAPPING — удалить сопоставление пользователя для стороннего сервера
    procedure c292CreateTransform; //CREATE TRANSFORM — создать трансформацию
    procedure c293DropTransform; //DROP TRANSFORM — удалить трансформацию
    procedure c294AlterTextSearchConfiguration; //ALTER TEXT SEARCH CONFIGURATION — изменить определение конфигурации текстового поиска
    procedure c295AlterTextSearchDictionary1; //ALTER TEXT SEARCH CONFIGURATION — изменить определение конфигурации текстового поиска
    procedure c296AlterTextSearchDictionary2;
    procedure c297AlterTextSearchDictionary3;
    procedure c298AlterTextSearchParser1; //ALTER TEXT SEARCH PARSER — изменить определение анализатора текстового поиска
    procedure c299AlterTextSearchParser2;
    procedure c300AlterTextSearchTemplate1; //ALTER TEXT SEARCH TEMPLATE — изменить определение шаблона текстового поиска
    procedure c301AlterTextSearchTemplate2;
    procedure c302CreateTextSearchConfiguration; //CREATE TEXT SEARCH CONFIGURATION — создать конфигурацию текстового поиска
    procedure c303CreateTextSearchDictionary; //CREATE TEXT SEARCH DICTIONARY — создать словарь текстового поиска
    procedure c304CreateTextSearchParser; //CREATE TEXT SEARCH PARSER — создать анализатор текстового поиска
    procedure c305CreateTextSearchTemplate; //CREATE TEXT SEARCH TEMPLATE — создать шаблон текстового поиска
    procedure c306DropTextSearchConfiguration; //DROP TEXT SEARCH CONFIGURATION — удалить конфигурацию текстового поиска
    procedure c307DropTextSearchDictionary; //DROP TEXT SEARCH DICTIONARY — удалить словарь текстового поиска
    procedure c308DropTextSearchParser; //DROP TEXT SEARCH PARSER — удалить анализатор текстового поиска
    procedure c309DropTextSearchTemplate; //DROP TEXT SEARCH TEMPLATE — удалить шаблон текстового поиска
    procedure c310AlterTablespace1; //ALTER TABLESPACE — изменить определение табличного пространства
    procedure c311AlterTablespace2;
    procedure c312CreateTablespace1; //CREATE TABLESPACE — создать табличное пространство
    procedure c313CreateTablespace2;
    procedure c314DropTablespace; //DROP TABLESPACE — удалить табличное пространство
    procedure c315AlterRule; //ALTER RULE — изменить определение правила
    procedure c316CreateRule1; //CREATE RULE — создать правило перезаписи
    procedure c317CreateRule2;
    procedure c318CreateRule3;
    procedure c319DropRule; //DROP RULE — удалить правило перезаписи
    procedure c320AlterPolicy; //ALTER POLICY — изменить определение политики защиты на уровне строк
    procedure c321CreatePolicy1; //CREATE POLICY — создать новую политику защиты на уровне строк для таблицы
    procedure c322CreatePolicy2;
    procedure c323CreatePolicy3;
    procedure c324CreatePolicy4;
    procedure c325CreatePolicy5;
    procedure c326CreatePolicy6;
    procedure c327CreatePolicy7;
    procedure c328DropPolicy; //DROP POLICY — удалить политику защиты на уровне строк для таблицы
    procedure c329DropOwned; //DROP OWNED — удалить объекты базы данных, принадлежащие роли
    procedure c330AlterOperator1; //ALTER OPERATOR — изменить определение оператора
    procedure c331AlterOperator2;
    procedure c332AlterOperatorClass; //ALTER OPERATOR CLASS — изменить определение класса операторов
    procedure c333AlterOperatorFamily1; //ALTER OPERATOR FAMILY — изменить определение семейства операторов
    procedure c334AlterOperatorFamily2;
    procedure c335CreateOperator; //CREATE OPERATOR — создать оператор
    procedure c336CreateOperatorClass; //CREATE OPERATOR CLASS — создать класс операторов
    procedure c337CreateOperatorFamily; //CREATE OPERATOR FAMILY — создать семейство операторов
    procedure c338DropOperator1; //DROP OPERATOR — удалить оператор
    procedure c339DropOperator2;
    procedure c340DropOperator3;
    procedure c341DropOperator4;
    procedure c342DropOperatorClass; //DROP OPERATOR CLASS — удалить класс операторов
    procedure c343DropOperatorFamily; //DROP OPERATOR FAMILY — удалить семейство операторов
    procedure c344AlterForeignDataWrapper1; //ALTER FOREIGN DATA WRAPPER — изменить определение обёртки сторонних данных
    procedure c345AlterForeignDataWrapper2;
    procedure c346AlterForeignTable1; //ALTER FOREIGN TABLE — изменить определение сторонней таблицы
    procedure c347AlterForeignTable2;
    procedure c348CreateForeignDataWrapper1; //CREATE FOREIGN DATA WRAPPER — создать новую обёртку сторонних данных
    procedure c349CreateForeignDataWrapper2;
    procedure c350CreateForeignDataWrapper3;
    procedure c351CreateForeignTable1; //CREATE FOREIGN TABLE — создать стороннюю таблицу
    procedure c352CreateForeignTable2;
    procedure c353DropForeignDataWrapper; //DROP FOREIGN DATA WRAPPER — удалить обёртку сторонних данных
    procedure c354DropForeignTable; //DROP FOREIGN TABLE — удалить стороннюю таблицу
    procedure c355AlterExtension1; //ALTER EXTENSION — изменить определение расширения
    procedure c356AlterExtension2;
    procedure c357AlterExtension3;
    procedure c358CreateExtension1; //CREATE EXTENSION — установить расширение
    procedure c359CreateExtension2;
    procedure c360DropExtension; //DROP EXTENSION — удалить расширение
    procedure c361AlterLanguage1; //ALTER LANGUAGE — изменить определение процедурного языка
    procedure c362AlterLanguage2;
    procedure c363CreateLanguage1; //CREATE LANGUAGE — создать процедурный язык
    procedure c364CreateLanguage2;
    procedure c365DropLanguage; //DROP LANGUAGE — удалить процедурный язык
    procedure c366AlterEventTrigger1; //ALTER EVENT TRIGGER — изменить определение событийного триггера
    procedure c367AlterEventTrigger2;
    procedure c368AlterEventTrigger3;
    procedure c369AlterEventTrigger4;
    procedure c370CreateEventTrigger; //CREATE EVENT TRIGGER — создать событийный триггер
    procedure c371DropEventTrigger; //DROP EVENT TRIGGER — удалить событийный триггер
    procedure c372DropConversion; //DROP CONVERSION — удалить преобразование
    procedure c373AlterConversion1; //ALTER CONVERSION — изменить определение перекодировки
    procedure c374AlterConversion2;
    procedure c375CreateConversion; //CREATE CONVERSION — создать перекодировку
    procedure c376AlterCollation1; //ALTER COLLATION — изменить определение правила сортировки
    procedure c377AlterCollation2;
    procedure c378CreateCollation1; //CREATE COLLATION — создать правило сортировки
    procedure c379CreateCollation2;
    procedure c380CreateCollation3;
    procedure c381DropCollation; //DROP COLLATION — удалить правило сортировки
    procedure c382CreateCast; //CREATE CAST — создать приведение
    procedure c383DropCast; //DROP CAST — удалить приведение типа
    procedure c384CreateAccessMethod; //CREATE ACCESS METHOD — создать новый метод доступа
    procedure c385DropAccessMethod; //DROP ACCESS METHOD — удалить метод доступа
    procedure c386AlterAggregate1; //ALTER AGGREGATE — изменить определение агрегатной функции
    procedure c387AlterAggregate2;
    procedure c388AlterAggregate3;
    procedure c389AlterAggregate4;
    procedure c390CreateAggregate1; //CREATE AGGREGATE — создать агрегатную функцию
    procedure c391CreateAggregate2;
    procedure c392CreateAggregate3;
    procedure c393CreateAggregate4;
    procedure c394CreateAggregate5;
    procedure c395CreateAggregate6;
    procedure c396CreateAggregate7;
    procedure c397DropAggregate1; //DROP AGGREGATE — удалить агрегатную функцию
    procedure c398DropAggregate2;
    procedure c399DropAggregate3;
    procedure c400AlterDefaultPrivileges1; //ALTER DEFAULT PRIVILEGES — определить права доступа по умолчанию
    procedure c401AlterDefaultPrivileges2;
    procedure c402AlterDefaultPrivileges3;
    procedure c403AlterDefaultPrivileges4;
    procedure c404AlterDefaultPrivileges5;
    procedure c405AlterLargeObject; //ALTER LARGE OBJECT — изменить определение большого объекта
    procedure c406AlterSystem1; //ALTER SYSTEM — изменить параметр конфигурации сервера
    procedure c407AlterSystem2;
    procedure c408AlterSystem3;
    procedure c409CreateTableAs1; //CREATE TABLE AS — создать таблицу из результатов запроса
    procedure c410CreateTableAs2;
    procedure c411CreateTableAs3;
    procedure c412CreateTable1; //CREATE TABLE — создать таблицу
    procedure c413CreateTable2;
    procedure c414CreateTable3;
    procedure c415CreateTable4;
    procedure c416CreateTable5;
    procedure c417CreateTable6;
    procedure c418CreateTable7;
    procedure c419CreateTable8;
    procedure c420CreateTable9;
    procedure c421CreateTable10;
    procedure c422CreateTable11;
    procedure c423CreateTable12;
    procedure c424CreateTable13;
    procedure c425CreateTable14;
    procedure c426CreateTable15;
    procedure c427CreateTable16;
    procedure c428CreateTable17;
    procedure c429CreateTable18;
    procedure c430CreateTable19;
    procedure c431CreateTabl20;
    procedure c432CreateTable21;
    procedure c433CreateTable22;
    procedure c434CreateTable23;
    procedure c435CreateTable24;
    procedure c436CreateTable25;
    procedure c437CreateTable26;
    procedure c438CreateTable27;
    procedure c439CreateTable28;
    procedure c440CreateTable29;
    procedure c441CreateTable30;
    procedure c442AlterTable1; //ALTER TABLE — изменить определение таблицы
    procedure c443AlterTable2;
    procedure c444DropTable1; //DROP TABLE — удалить таблицу
    procedure c445DropTable2;
    procedure c446CreateRole; //CREATE ROLE — создать роль в базе данных
    procedure c447AlterRole1; //ALTER ROLE — изменить роль в базе данных
    procedure c448AlterRole2;
    procedure c449AlterRole3;
    procedure c450AlterRole4;
    procedure c451AlterRole5;
    procedure c452AlterRole6;
    procedure c453AlterRole7;
    procedure c454DropRole; //DROP ROLE — удалить роль в базе данных
    procedure c455AlterUser1; //ALTER USER — изменить роль в базе данных
    procedure c456AlterUser2;
    procedure c457CreateUser; //CREATE USER — создать роль в базе данных
    procedure c458DropUser; //DROP USER — удалить роль в базе данных
    procedure c459GroupCreate;
    procedure c460SQLGrant4; //GRANT — определить права доступа
    procedure c461SQLRevoke6; //REVOKE — отозвать права доступа
    procedure c462CreateTable31;
    procedure c463CreateTable32;
    procedure c464AlterTable3;
    procedure c465AlterTable4;
    procedure c466AlterTable5;
    procedure c467CreateMaterializedView2;
    procedure c468AlterMaterializedView2;
    procedure c468AlterMaterializedView3;
    procedure c469AlterMaterializedView4;
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

procedure TPGSQLParserTest.c446CreateRole;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreateRole1']);
end;

procedure TPGSQLParserTest.c447AlterRole1;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterRole1']);
end;

procedure TPGSQLParserTest.c448AlterRole2;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterRole2']);
end;

procedure TPGSQLParserTest.c449AlterRole3;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterRole3']);
end;

procedure TPGSQLParserTest.c450AlterRole4;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterRole4']);
end;

procedure TPGSQLParserTest.c451AlterRole5;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterRole5']);
end;

procedure TPGSQLParserTest.c452AlterRole6;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterRole6']);
end;

procedure TPGSQLParserTest.c453AlterRole7;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterRole7']);
end;

procedure TPGSQLParserTest.c454DropRole;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['DropRole1']);
end;

procedure TPGSQLParserTest.c455AlterUser1;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterUser1']);
end;

procedure TPGSQLParserTest.c456AlterUser2;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterUser2']);
end;

procedure TPGSQLParserTest.c457CreateUser;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreateUser1']);
end;

procedure TPGSQLParserTest.c458DropUser;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['DropUser1']);
end;

procedure TPGSQLParserTest.c459GroupCreate;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreateGroup1']);
end;

procedure TPGSQLParserTest.c460SQLGrant4;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['Grant4']);
end;

procedure TPGSQLParserTest.c461SQLRevoke6;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['Revoke6']);
end;

procedure TPGSQLParserTest.c462CreateTable31;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable31']);
end;

procedure TPGSQLParserTest.c463CreateTable32;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable32']);
end;

procedure TPGSQLParserTest.c464AlterTable3;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterTable3']);
end;

procedure TPGSQLParserTest.c465AlterTable4;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterTable4']);
end;

procedure TPGSQLParserTest.c466AlterTable5;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterTable5']);
end;

procedure TPGSQLParserTest.c467CreateMaterializedView2;
begin
  DoTestSQL(PGSQLParserData.sView['CreateMaterializedView2']);
end;

procedure TPGSQLParserTest.c468AlterMaterializedView2;
begin
  DoTestSQL(PGSQLParserData.sView['AlterMaterializedView2']);
end;

procedure TPGSQLParserTest.c468AlterMaterializedView3;
begin
  DoTestSQL(PGSQLParserData.sView['AlterMaterializedView3']);
end;

procedure TPGSQLParserTest.c469AlterMaterializedView4;
begin
  DoTestSQL(PGSQLParserData.sView['AlterMaterializedView4']);
end;

procedure TPGSQLParserTest.c079SQLEnd1;
begin
  DoTestSQL(PGSQLParserData.sDML['END1']);
end;

procedure TPGSQLParserTest.c080SQLEnd2;
begin
  DoTestSQL(PGSQLParserData.sDML['END2']);
end;

procedure TPGSQLParserTest.c081SQLExecute1;
begin
  DoTestSQL(PGSQLParserData.sDML['Execute1']);
end;

procedure TPGSQLParserTest.c082SQLExecute2;
begin
  DoTestSQL(PGSQLParserData.sDML['Execute2']);
end;

procedure TPGSQLParserTest.c083SQLExplain1;
begin
  DoTestSQL(PGSQLParserData.sDML['Explain1']);
end;

procedure TPGSQLParserTest.c084SQLExplain2;
begin
  DoTestSQL(PGSQLParserData.sDML['Explain2']);
end;

procedure TPGSQLParserTest.c085SQLFetch1;
begin
  DoTestSQL(PGSQLParserData.sDML['Fetch1']);
end;

procedure TPGSQLParserTest.c086SQLFetch2;
begin
  DoTestSQL(PGSQLParserData.sDML['Fetch2']);
end;

procedure TPGSQLParserTest.c087SQLImportForeignSchema1;
begin
  DoTestSQL(PGSQLParserData.sSchema['ImportForeignSchema1']);
end;

procedure TPGSQLParserTest.c088SQLImportForeignSchema2;
begin
  DoTestSQL(PGSQLParserData.sSchema['ImportForeignSchema2']);
end;

procedure TPGSQLParserTest.c089SQLInsert1;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert1']);
end;

procedure TPGSQLParserTest.c090SQLInsert2;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert2']);
end;

procedure TPGSQLParserTest.c091SQLInsert3;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert3']);
end;

procedure TPGSQLParserTest.c092SQLInsert4;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert4']);
end;

procedure TPGSQLParserTest.c093SQLInsert5;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert5']);
end;

procedure TPGSQLParserTest.c094SQLInsert6;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert6']);
end;

procedure TPGSQLParserTest.c095SQLInsert7;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert7']);
end;

procedure TPGSQLParserTest.c096SQLInsert8;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert8']);
end;

procedure TPGSQLParserTest.c097SQLInsert9;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert9']);
end;

procedure TPGSQLParserTest.c098SQLInsert10;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert10']);
end;

procedure TPGSQLParserTest.c099SQLInsert11;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert11']);
end;

procedure TPGSQLParserTest.c100SQLInsert12;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert12']);
end;

procedure TPGSQLParserTest.c101SQLInsert13;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert13']);
end;

procedure TPGSQLParserTest.c102SQLInsert14;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert14']);
end;

procedure TPGSQLParserTest.c103SQLInsert15;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert15']);
end;

procedure TPGSQLParserTest.c104SQLInsert16;
begin
  DoTestSQL(PGSQLParserData.sDML['Insert16']);
end;

procedure TPGSQLParserTest.c105SQLListen;
begin
  DoTestSQL(PGSQLParserData.sDML['Listen1']);
end;

procedure TPGSQLParserTest.c106SQLLoad;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Load1']);
end;

procedure TPGSQLParserTest.c107SQLLock1;
begin
  DoTestSQL(PGSQLParserData.sDML['Lock1']);
end;

procedure TPGSQLParserTest.c108SQLLock2;
begin
  DoTestSQL(PGSQLParserData.sDML['Lock2']);
end;

procedure TPGSQLParserTest.c109SQLMove1;
begin
  DoTestSQL(PGSQLParserData.sDML['Move1']);
end;

procedure TPGSQLParserTest.c110SQLMove2;
begin
  DoTestSQL(PGSQLParserData.sDML['Move2']);
end;

procedure TPGSQLParserTest.c111SQLNotify1;
begin
  DoTestSQL(PGSQLParserData.sDML['Notify1']);
end;

procedure TPGSQLParserTest.c112SQLNotify2;
begin
  DoTestSQL(PGSQLParserData.sDML['Notify2']);
end;

procedure TPGSQLParserTest.c113SQLPrepare1;
begin
  DoTestSQL(PGSQLParserData.sDML['Prepare1']);
end;

procedure TPGSQLParserTest.c114SQLPrepare2;
begin
  DoTestSQL(PGSQLParserData.sDML['Prepare2']);
end;

procedure TPGSQLParserTest.c115SQLPrepareTransaction;
begin
  DoTestSQL(PGSQLParserData.sDML['PrepareTransaction1']);
end;

procedure TPGSQLParserTest.c116SQLReassignOwned;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['ReassignOwned1']);
end;

procedure TPGSQLParserTest.c117SQLRefreshMaterializedView1;
begin
  DoTestSQL(PGSQLParserData.sView['RefreshMaterializedView1']);
end;

procedure TPGSQLParserTest.c118SQLRefreshMaterializedView2;
begin
  DoTestSQL(PGSQLParserData.sView['RefreshMaterializedView2']);
end;

procedure TPGSQLParserTest.c119SQLReindex1;
begin
  DoTestSQL(PGSQLParserData.sTable['Reindex1']);
end;

procedure TPGSQLParserTest.c120SQLReindex2;
begin
  DoTestSQL(PGSQLParserData.sTable['Reindex2']);
end;

procedure TPGSQLParserTest.c121SQLReindex3;
begin
  DoTestSQL(PGSQLParserData.sTable['Reindex3']);
end;

procedure TPGSQLParserTest.c122SQLSavepoint;
begin
  DoTestSQL(PGSQLParserData.sDML['Savepoint1']);
end;

procedure TPGSQLParserTest.c123SQLReset1;
begin
  DoTestSQL(PGSQLParserData.sSystem['Reset1']);
end;

procedure TPGSQLParserTest.c124SQLReset2;
begin
  DoTestSQL(PGSQLParserData.sSystem['Reset2']);
end;

procedure TPGSQLParserTest.c125SQLRevoke1;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['Revoke1']);
end;

procedure TPGSQLParserTest.c126SQLRevoke2;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['Revoke2']);
end;

procedure TPGSQLParserTest.c127SQLRevoke3;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['Revoke3']);
end;

procedure TPGSQLParserTest.c128SQLRevoke4;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['Revoke4']);
end;

procedure TPGSQLParserTest.c129SQLRevoke5;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['Revoke5']);
end;

procedure TPGSQLParserTest.c130SQLRollback1;
begin
  DoTestSQL(PGSQLParserData.sDML['Rollback1']);
end;

procedure TPGSQLParserTest.c131SQLRollback2;
begin
  DoTestSQL(PGSQLParserData.sDML['Rollback2']);
end;

procedure TPGSQLParserTest.c132SQLRollback3;
begin
  DoTestSQL(PGSQLParserData.sDML['Rollback3']);
end;

procedure TPGSQLParserTest.c133SQLRollbackPrepared;
begin
  DoTestSQL(PGSQLParserData.sDML['RollbackPrepared1']);
end;

procedure TPGSQLParserTest.c134SQLRollbackToSavepoint;
begin
  DoTestSQL(PGSQLParserData.sDML['RollbackToSavepoint1']);
end;

procedure TPGSQLParserTest.c135SQLSecurityLabel;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['SecurityLabel1']);
end;

procedure TPGSQLParserTest.c136SQLSelect1;
begin
  DoTestSQL(PGSQLParserData.sDML['Select1']);
end;

procedure TPGSQLParserTest.c137SQLSelect2;
begin
  DoTestSQL(PGSQLParserData.sDML['Select2']);
end;

procedure TPGSQLParserTest.c138SQLSelect3;
begin
  DoTestSQL(PGSQLParserData.sDML['Select3']);
end;

procedure TPGSQLParserTest.c139SQLSelect4;
begin
  DoTestSQL(PGSQLParserData.sDML['Select4']);
end;

procedure TPGSQLParserTest.c140SQLSelect5;
begin
  DoTestSQL(PGSQLParserData.sDML['Select5']);
end;

procedure TPGSQLParserTest.c141SQLSelect6;
begin
  DoTestSQL(PGSQLParserData.sDML['Select6']);
end;

procedure TPGSQLParserTest.c142SQLSelect7;
begin
  DoTestSQL(PGSQLParserData.sDML['Select7']);
end;

procedure TPGSQLParserTest.c143SQLSelect8;
begin
  DoTestSQL(PGSQLParserData.sDML['Select8']);
end;

procedure TPGSQLParserTest.c144SQLSelect9;
begin
  DoTestSQL(PGSQLParserData.sDML['Select9']);
end;

procedure TPGSQLParserTest.c145SQLSelect10;
begin
  DoTestSQL(PGSQLParserData.sDML['Select10']);
end;

procedure TPGSQLParserTest.c146SQLSelect11;
begin
  DoTestSQL(PGSQLParserData.sDML['Select11']);
end;

procedure TPGSQLParserTest.c147SQLSelect12;
begin
  DoTestSQL(PGSQLParserData.sDML['Select12']);
end;

procedure TPGSQLParserTest.c148SQLSelect13;
begin
  DoTestSQL(PGSQLParserData.sDML['Select13']);
end;

procedure TPGSQLParserTest.c149SQLSelectInto;
begin
  DoTestSQL(PGSQLParserData.sDML['SelectInto1']);
end;

procedure TPGSQLParserTest.c150SQLSet1;
begin
  DoTestSQL(PGSQLParserData.sSystem['Set1']);
end;

procedure TPGSQLParserTest.c151SQLSet2;
begin
  DoTestSQL(PGSQLParserData.sSystem['Set2']);
end;

procedure TPGSQLParserTest.c152SQLSet3;
begin
  DoTestSQL(PGSQLParserData.sSystem['Set3']);
end;

procedure TPGSQLParserTest.c153SQLSet4;
begin
  DoTestSQL(PGSQLParserData.sSystem['Set4']);
end;

procedure TPGSQLParserTest.c154SQLSetConstraints;
begin
  DoTestSQL(PGSQLParserData.sSystem['SetConstraints1']);
end;

procedure TPGSQLParserTest.c155SQLSetRole;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['SetRole1']);
end;

procedure TPGSQLParserTest.c156SQLSetSessionAuthorization;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['SetSessionAuthorization1']);
end;

procedure TPGSQLParserTest.c157SQLSetTransaction;
begin
  DoTestSQL(PGSQLParserData.sDML['SetTransaction1']);
end;

procedure TPGSQLParserTest.c158SQLShow1;
begin
  DoTestSQL(PGSQLParserData.sSystem['Show1']);
end;

procedure TPGSQLParserTest.c159SQLShow2;
begin
  DoTestSQL(PGSQLParserData.sSystem['Show2']);
end;

procedure TPGSQLParserTest.c160SQLShow3;
begin
  DoTestSQL(PGSQLParserData.sSystem['Show3']);
end;

procedure TPGSQLParserTest.c161SQLStartTransaction;
begin
  DoTestSQL(PGSQLParserData.sDML['StartTransaction1']);
end;

procedure TPGSQLParserTest.c162SQLTruncate1;
begin
  DoTestSQL(PGSQLParserData.sDML['Truncate1']);
end;

procedure TPGSQLParserTest.c163SQLTruncate2;
begin
  DoTestSQL(PGSQLParserData.sDML['Truncate2']);
end;

procedure TPGSQLParserTest.c164SQLTruncate3;
begin
  DoTestSQL(PGSQLParserData.sDML['Truncate3']);
end;

procedure TPGSQLParserTest.c165SQLUnlisten;
begin
  DoTestSQL(PGSQLParserData.sDML['Unlisten1']);
end;

procedure TPGSQLParserTest.c166SQLUpdate1;
begin
  DoTestSQL(PGSQLParserData.sDML['Update1']);
end;

procedure TPGSQLParserTest.c167SQLUpdate2;
begin
  DoTestSQL(PGSQLParserData.sDML['Update2']);
end;

procedure TPGSQLParserTest.c168SQLUpdate3;
begin
  DoTestSQL(PGSQLParserData.sDML['Update3']);
end;

procedure TPGSQLParserTest.c169SQLUpdate4;
begin
  DoTestSQL(PGSQLParserData.sDML['Update4']);
end;

procedure TPGSQLParserTest.c170SQLUpdate5;
begin
  DoTestSQL(PGSQLParserData.sDML['Update5']);
end;

procedure TPGSQLParserTest.c171SQLUpdate6;
begin
  DoTestSQL(PGSQLParserData.sDML['Update6']);
end;

procedure TPGSQLParserTest.c172SQLUpdate7;
begin
  DoTestSQL(PGSQLParserData.sDML['Update7']);
end;

procedure TPGSQLParserTest.c173SQLUpdate8;
begin
  DoTestSQL(PGSQLParserData.sDML['Update8']);
end;

procedure TPGSQLParserTest.c174SQLUpdate9;
begin
  DoTestSQL(PGSQLParserData.sDML['Update9']);
end;

procedure TPGSQLParserTest.c175SQLUpdate10;
begin
  DoTestSQL(PGSQLParserData.sDML['Update10']);
end;

procedure TPGSQLParserTest.c177SQLValues2;
begin
  DoTestSQL(PGSQLParserData.sDML['Values2']);
end;

procedure TPGSQLParserTest.c176SQLValues1;
begin
  DoTestSQL(PGSQLParserData.sDML['Values1']);
end;

procedure TPGSQLParserTest.c178AlterSchema1;
begin
  DoTestSQL(PGSQLParserData.sSchema['AlterSchema1']);
end;

procedure TPGSQLParserTest.c179AlterSchema2;
begin
  DoTestSQL(PGSQLParserData.sSchema['AlterSchema2']);
end;

procedure TPGSQLParserTest.c180CreateSchema1;
begin
  DoTestSQL(PGSQLParserData.sSchema['CreateSchema1']);
end;

procedure TPGSQLParserTest.c181CreateSchema2;
begin
  DoTestSQL(PGSQLParserData.sSchema['CreateSchema2']);
end;

procedure TPGSQLParserTest.c182CreateSchema3;
begin
  DoTestSQL(PGSQLParserData.sSchema['CreateSchema3']);
end;

procedure TPGSQLParserTest.c183CreateSchema4;
begin
  DoTestSQL(PGSQLParserData.sSchema['CreateSchema4']);
end;

procedure TPGSQLParserTest.c184DropSchema;
begin
  DoTestSQL(PGSQLParserData.sSchema['DropSchema1']);
end;

procedure TPGSQLParserTest.c044SQLClose1;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Close1']);
end;

procedure TPGSQLParserTest.c045SQLClose2;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Close2']);
end;

procedure TPGSQLParserTest.c046Commit1;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Commit1']);
end;

procedure TPGSQLParserTest.c047Commit2;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Commit2']);
end;

procedure TPGSQLParserTest.c048Commit3;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Commit3']);
end;

procedure TPGSQLParserTest.c049SQLBegin1;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Begin1']);
end;

procedure TPGSQLParserTest.c050SQLBegin2;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Begin2']);
end;

procedure TPGSQLParserTest.c051SQLBegin3;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Begin3']);
end;

procedure TPGSQLParserTest.c052SQLVacuum;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Vacuum1']);
end;

procedure TPGSQLParserTest.c053SQLDiscard1;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Discard1']);
end;

procedure TPGSQLParserTest.c054SQLDiscard2;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Discard2']);
end;

procedure TPGSQLParserTest.c055SQLDiscard3;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Discard3']);
end;

procedure TPGSQLParserTest.c056SQLDiscard4;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Discard4']);
end;

procedure TPGSQLParserTest.c057SQLGrant1;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['Grant1']);
end;

procedure TPGSQLParserTest.c058SQLGrant2;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['Grant2']);
end;

procedure TPGSQLParserTest.c059SQLGrant3;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['Grant3']);
end;

procedure TPGSQLParserTest.c060SQLAnalyze;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Analyze1']);
end;

procedure TPGSQLParserTest.c061SQLCheckpoint;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Checkpoint1']);
end;

procedure TPGSQLParserTest.c062SQLCluster1;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Cluster1']);
end;

procedure TPGSQLParserTest.c063SQLCluster2;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Cluster2']);
end;

procedure TPGSQLParserTest.c064SQLCluster3;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Cluster3']);
end;

procedure TPGSQLParserTest.c065SQLCommitPrepared;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['CommitPrepared1']);
end;

procedure TPGSQLParserTest.c066SQLCopy1;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Copy1']);
end;

procedure TPGSQLParserTest.c067SQLCopy2;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Copy2']);
end;

procedure TPGSQLParserTest.c068SQLCopy3;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Copy3']);
end;

procedure TPGSQLParserTest.c069SQLCopy4;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Copy4']);
end;

procedure TPGSQLParserTest.c070SQLDo;
begin
  DoTestSQL(PGSQLParserData.sDML['DO1']);
end;

procedure TPGSQLParserTest.c071SQLDeallocate;
begin
  DoTestSQL(PGSQLParserData.sDML['Deallocate1']);
end;

procedure TPGSQLParserTest.c072SQLDeclare;
begin
  DoTestSQL(PGSQLParserData.sDML['Declare1']);
end;

procedure TPGSQLParserTest.c073SQLDelete1;
begin
  DoTestSQL(PGSQLParserData.sDML['Delete1']);
end;

procedure TPGSQLParserTest.c074SQLDelete2;
begin
  DoTestSQL(PGSQLParserData.sDML['Delete2']);
end;

procedure TPGSQLParserTest.c075SQLDelete3;
begin
  DoTestSQL(PGSQLParserData.sDML['Delete3']);
end;

procedure TPGSQLParserTest.c076SQLDelete4;
begin
  DoTestSQL(PGSQLParserData.sDML['Delete4']);
end;

procedure TPGSQLParserTest.c077SQLDelete5;
begin
  DoTestSQL(PGSQLParserData.sDML['Delete5']);
end;

procedure TPGSQLParserTest.c078SQLDelete6;
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

procedure TPGSQLParserTest.c001SQLAbort1;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Abort1']);
end;

procedure TPGSQLParserTest.c002SQLAbort2;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Abort2']);
end;

procedure TPGSQLParserTest.c003SQLAbort3;
begin
  DoTestSQL(PGSQLParserData.sSimpleCmd['Abort3']);
end;

procedure TPGSQLParserTest.c004SQLComment1;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment1']);
end;

procedure TPGSQLParserTest.c005SQLComment2;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment2']);
end;

procedure TPGSQLParserTest.c006SQLComment3;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment3']);
end;

procedure TPGSQLParserTest.c007SQLComment4;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment4']);
end;

procedure TPGSQLParserTest.c008SQLComment5;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment5']);
end;

procedure TPGSQLParserTest.c009SQLComment6;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment6']);
end;

procedure TPGSQLParserTest.c010SQLComment7;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment7']);
end;

procedure TPGSQLParserTest.c011SQLComment8;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment8']);
end;

procedure TPGSQLParserTest.c012SQLComment9;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment9']);
end;

procedure TPGSQLParserTest.c013SQLComment10;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment10']);
end;

procedure TPGSQLParserTest.c014SQLComment11;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment11']);
end;

procedure TPGSQLParserTest.c015SQLComment12;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment12']);
end;

procedure TPGSQLParserTest.c015SQLComment13;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment13']);
end;

procedure TPGSQLParserTest.c016SQLComment14;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment14']);
end;

procedure TPGSQLParserTest.c017SQLComment15;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment15']);
end;

procedure TPGSQLParserTest.c018SQLComment16;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment16']);
end;

procedure TPGSQLParserTest.c019SQLComment17;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment17']);
end;

procedure TPGSQLParserTest.c020SQLComment18;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment18']);
end;

procedure TPGSQLParserTest.c021SQLComment19;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment19']);
end;

procedure TPGSQLParserTest.c022SQLComment20;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment20']);
end;

procedure TPGSQLParserTest.c023SQLComment21;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment21']);
end;

procedure TPGSQLParserTest.c024SQLComment22;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment22']);
end;

procedure TPGSQLParserTest.c025SQLComment23;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment23']);
end;

procedure TPGSQLParserTest.c026SQLComment24;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment24']);
end;

procedure TPGSQLParserTest.c027SQLComment25;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment25']);
end;

procedure TPGSQLParserTest.c028SQLComment26;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment26']);
end;

procedure TPGSQLParserTest.c029SQLComment27;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment27']);
end;

procedure TPGSQLParserTest.c030SQLComment28;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment28']);
end;

procedure TPGSQLParserTest.c031SQLComment29;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment29']);
end;

procedure TPGSQLParserTest.c032SQLComment30;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment30']);
end;

procedure TPGSQLParserTest.c033SQLComment31;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment31']);
end;

procedure TPGSQLParserTest.c034SQLComment32;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment32']);
end;

procedure TPGSQLParserTest.c035SQLComment33;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment33']);
end;

procedure TPGSQLParserTest.c036SQLComment34;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment34']);
end;

procedure TPGSQLParserTest.c037SQLComment35;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment35']);
end;

procedure TPGSQLParserTest.c038SQLComment36;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment36']);
end;

procedure TPGSQLParserTest.c039SQLComment37;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment37']);
end;

procedure TPGSQLParserTest.c040SQLComment38;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment38']);
end;

procedure TPGSQLParserTest.c041SQLComment39;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment39']);
end;

procedure TPGSQLParserTest.c042SQLComment40;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment40']);
end;

procedure TPGSQLParserTest.c043SQLComment41;
begin
  DoTestSQL(PGSQLParserData.sComment['Comment41']);
end;

procedure TPGSQLParserTest.c185DomainCreate;
begin
  DoTestSQL(PGSQLParserData.sDomain['CreateDomain1']);
end;

procedure TPGSQLParserTest.c186DomainAlter1;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain1']);
end;

procedure TPGSQLParserTest.c187DomainAlter2;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain2']);
end;

procedure TPGSQLParserTest.c188DomainAlter3;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain3']);
end;

procedure TPGSQLParserTest.c189DomainAlter4;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain4']);
end;

procedure TPGSQLParserTest.c190DomainAlter5;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain5']);
end;

procedure TPGSQLParserTest.c191DomainAlter6;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain6']);
end;

procedure TPGSQLParserTest.c192DomainAlter7;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain7']);
end;

procedure TPGSQLParserTest.c193DomainAlter8;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain8']);
end;

procedure TPGSQLParserTest.c194DomainAlter9;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain9']);
end;

procedure TPGSQLParserTest.c195DomainAlter10;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain10']);
end;

procedure TPGSQLParserTest.c196DomainAlter11;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain11']);
end;

procedure TPGSQLParserTest.c197DomainAlter12;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain12']);
end;

procedure TPGSQLParserTest.c198DomainAlter13;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain13']);
end;

procedure TPGSQLParserTest.c199DomainAlter14;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain14']);
end;

procedure TPGSQLParserTest.c200DomainAlter15;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain15']);
end;

procedure TPGSQLParserTest.c201DomainAlter16;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain16']);
end;

procedure TPGSQLParserTest.c202DomainAlter17;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain17']);
end;

procedure TPGSQLParserTest.c203DomainAlter18;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain18']);
end;

procedure TPGSQLParserTest.c204DomainAlter19;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain19']);
end;

procedure TPGSQLParserTest.c205DomainAlter20;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain20']);
end;

procedure TPGSQLParserTest.c206DomainAlter21;
begin
  DoTestSQL(PGSQLParserData.sDomain['AlterDomain21']);
end;

procedure TPGSQLParserTest.c207DomainDrop;
begin
  DoTestSQL(PGSQLParserData.sDomain['DropDomain1']);
end;

procedure TPGSQLParserTest.c208CreateView1;
begin
  DoTestSQL(PGSQLParserData.sView['CreateView1']);
end;

procedure TPGSQLParserTest.c209CreateView2;
begin
  DoTestSQL(PGSQLParserData.sView['CreateView2']);
end;

procedure TPGSQLParserTest.c210CreateView3;
begin
  DoTestSQL(PGSQLParserData.sView['CreateView3']);
end;

procedure TPGSQLParserTest.c211CreateView4;
begin
  DoTestSQL(PGSQLParserData.sView['CreateView4']);
end;

procedure TPGSQLParserTest.c212CreateView5;
begin
  DoTestSQL(PGSQLParserData.sView['CreateView5']);
end;

procedure TPGSQLParserTest.c213AlterView1;
begin
  DoTestSQL(PGSQLParserData.sView['AlterView1']);
end;

procedure TPGSQLParserTest.c214AlterView2;
begin
  DoTestSQL(PGSQLParserData.sView['AlterView2']);
end;

procedure TPGSQLParserTest.c215DropView;
begin
  DoTestSQL(PGSQLParserData.sView['DropView1']);
end;

procedure TPGSQLParserTest.c216CreateMaterializedView;
begin
  DoTestSQL(PGSQLParserData.sView['CreateMaterializedView1']);
end;

procedure TPGSQLParserTest.c217AlterMaterializedView;
begin
  DoTestSQL(PGSQLParserData.sView['AlterMaterializedView1']);
end;

procedure TPGSQLParserTest.c218DropMaterializedView;
begin
  DoTestSQL(PGSQLParserData.sView['DropMaterializedView1']);
end;

procedure TPGSQLParserTest.c219CreateTrigger1;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateTrigger1']);
end;

procedure TPGSQLParserTest.c220CreateTrigger2;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateTrigger2']);
end;

procedure TPGSQLParserTest.c221CreateTrigger3;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateTrigger3']);
end;

procedure TPGSQLParserTest.c222CreateTrigger4;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateTrigger4']);
end;

procedure TPGSQLParserTest.c223CreateTrigger5;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateTrigger5']);
end;

procedure TPGSQLParserTest.c224CreateTrigger6;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateTrigger6']);
end;

procedure TPGSQLParserTest.c225CreateTrigger7;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateTrigger7']);
end;

procedure TPGSQLParserTest.c226AlterTrigger1;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterTrigger1']);
end;

procedure TPGSQLParserTest.c227AlterTrigger2;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterTrigger2']);
end;

procedure TPGSQLParserTest.c228DropTrigger;
begin
  DoTestSQL(PGSQLParserData.sFunctions['DropTrigger1']);
end;

procedure TPGSQLParserTest.c229AlterFunction1;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterFunction1']);
end;


procedure TPGSQLParserTest.c230AlterFunction2;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterFunction2']);
end;

procedure TPGSQLParserTest.c231AlterFunction3;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterFunction3']);
end;

procedure TPGSQLParserTest.c232AlterFunction4;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterFunction4']);
end;

procedure TPGSQLParserTest.c233AlterFunction5;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterFunction5']);
end;

procedure TPGSQLParserTest.c234AlterFunction6;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterFunction6']);
end;

procedure TPGSQLParserTest.c235CreateFunction1;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateFunction1']);
end;

procedure TPGSQLParserTest.c236CreateFunction2;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateFunction2']);
end;

procedure TPGSQLParserTest.c237CreateFunction3;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateFunction3']);
end;

procedure TPGSQLParserTest.c238CreateFunction4;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateFunction4']);
end;

procedure TPGSQLParserTest.c239CreateFunction5;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateFunction5']);
end;

procedure TPGSQLParserTest.c240CreateFunction6;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateFunction6']);
end;

procedure TPGSQLParserTest.c241DropFunction1;
begin
  DoTestSQL(PGSQLParserData.sFunctions['DropFunction1']);
end;

procedure TPGSQLParserTest.c242DropFunction2;
begin
  DoTestSQL(PGSQLParserData.sFunctions['DropFunction2']);
end;

procedure TPGSQLParserTest.c243DropFunction3;
begin
  DoTestSQL(PGSQLParserData.sFunctions['DropFunction3']);
end;

procedure TPGSQLParserTest.c244DropFunction4;
begin
  DoTestSQL(PGSQLParserData.sFunctions['DropFunction4']);
end;

procedure TPGSQLParserTest.c245AlterSequence;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterSequence1']);
end;

procedure TPGSQLParserTest.c246CreateSequence;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateSequence1']);
end;

procedure TPGSQLParserTest.c247DropSequence;
begin
  DoTestSQL(PGSQLParserData.sTable['DropSequence1']);
end;

procedure TPGSQLParserTest.c248AlterIndex1;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterIndex1']);
end;

procedure TPGSQLParserTest.c249AlterIndex2;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterIndex2']);
end;

procedure TPGSQLParserTest.c250AlterIndex3;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterIndex3']);
end;

procedure TPGSQLParserTest.c251CreateIndex1;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateIndex1']);
end;

procedure TPGSQLParserTest.c252CreateIndex2;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateIndex2']);
end;

procedure TPGSQLParserTest.c253CreateIndex3;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateIndex3']);

end;

procedure TPGSQLParserTest.c254CreateIndex4;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateIndex4']);
end;

procedure TPGSQLParserTest.c255CreateIndex5;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateIndex5']);
end;

procedure TPGSQLParserTest.c256CreateIndex6;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateIndex6']);
end;

procedure TPGSQLParserTest.c257CreateIndex7;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateIndex7']);
end;

procedure TPGSQLParserTest.c258CreateIndex8;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateIndex8']);
end;

procedure TPGSQLParserTest.c259CreateIndex9;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateIndex9']);
end;

procedure TPGSQLParserTest.c260DropIndex;
begin
  DoTestSQL(PGSQLParserData.sTable['DropIndex1']);
end;

procedure TPGSQLParserTest.c261AlterGroup1;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterGroup1']);
end;

procedure TPGSQLParserTest.c262AlterGroup2;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterGroup2']);
end;

procedure TPGSQLParserTest.c263CreateGroup;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreateGroup1']);
end;

procedure TPGSQLParserTest.c264DropGroup;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['DropGroup1']);
end;

procedure TPGSQLParserTest.c265AlterServer1;
begin
  DoTestSQL(PGSQLParserData.sDataBase['AlterServer1']);
end;

procedure TPGSQLParserTest.c266AlterServer2;
begin
  DoTestSQL(PGSQLParserData.sDataBase['AlterServer2']);
end;

procedure TPGSQLParserTest.c267CreateServer;
begin
  DoTestSQL(PGSQLParserData.sDataBase['CreateServer1']);
end;

procedure TPGSQLParserTest.c268DropServer;
begin
  DoTestSQL(PGSQLParserData.sDataBase['DropServer1']);
end;

procedure TPGSQLParserTest.c269CreateDatabase1;
begin
  DoTestSQL(PGSQLParserData.sDataBase['CreateDatabase1']);
end;

procedure TPGSQLParserTest.c270CreateDatabase2;
begin
  DoTestSQL(PGSQLParserData.sDataBase['CreateDatabase2']);
end;

procedure TPGSQLParserTest.c271CreateDatabase3;
begin
  DoTestSQL(PGSQLParserData.sDataBase['CreateDatabase3']);
end;

procedure TPGSQLParserTest.c272CreateDatabase4;
begin
  DoTestSQL(PGSQLParserData.sDataBase['CreateDatabase4']);
end;

procedure TPGSQLParserTest.c273AlterDatabase;
begin
  DoTestSQL(PGSQLParserData.sDataBase['AlterDatabase1']);
end;

procedure TPGSQLParserTest.c274DropDatabase;
begin
  DoTestSQL(PGSQLParserData.sDataBase['DropDatabase1']);
end;

procedure TPGSQLParserTest.c275AlterType1;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterType1']);
end;

procedure TPGSQLParserTest.c276AlterType2;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterType2']);
end;

procedure TPGSQLParserTest.c277AlterType3;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterType3']);
end;

procedure TPGSQLParserTest.c278AlterType4;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterType4']);
end;

procedure TPGSQLParserTest.c279AlterType5;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterType5']);
end;

procedure TPGSQLParserTest.c280AlterType6;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterType6']);
end;

procedure TPGSQLParserTest.c281CreateType1;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateType1']);
end;

procedure TPGSQLParserTest.c282CreateType2;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateType2']);
end;

procedure TPGSQLParserTest.c283CreateType3;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateType3']);
end;

procedure TPGSQLParserTest.c284CreateType4;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateType4']);
end;

procedure TPGSQLParserTest.c285CreateType5;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateType5']);
end;

procedure TPGSQLParserTest.c286CreateType6;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateType6']);
end;

procedure TPGSQLParserTest.c287CreateType7;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateType7']);
end;

procedure TPGSQLParserTest.c288DropType;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropType1']);
end;

procedure TPGSQLParserTest.c289AlterUserMapping;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterUserMapping1']);
end;

procedure TPGSQLParserTest.c290CreateUserMapping;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreateUserMapping1']);
end;

procedure TPGSQLParserTest.c291DropUserMapping;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['DropUserMapping1']);
end;

procedure TPGSQLParserTest.c292CreateTransform;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateTransform1']);
end;

procedure TPGSQLParserTest.c293DropTransform;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropTransform1']);
end;

procedure TPGSQLParserTest.c294AlterTextSearchConfiguration;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterTextSearchConfiguration1']);
end;

procedure TPGSQLParserTest.c295AlterTextSearchDictionary1;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterTextSearchDictionary1']);
end;

procedure TPGSQLParserTest.c296AlterTextSearchDictionary2;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterTextSearchDictionary2']);
end;

procedure TPGSQLParserTest.c297AlterTextSearchDictionary3;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterTextSearchDictionary3']);
end;

procedure TPGSQLParserTest.c298AlterTextSearchParser1;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterTextSearchParser1']);
end;

procedure TPGSQLParserTest.c299AlterTextSearchParser2;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterTextSearchParser2']);
end;

procedure TPGSQLParserTest.c300AlterTextSearchTemplate1;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterTextSearchTemplate1']);
end;

procedure TPGSQLParserTest.c301AlterTextSearchTemplate2;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterTextSearchTemplate2']);
end;

procedure TPGSQLParserTest.c302CreateTextSearchConfiguration;
begin
  DoTestSQL(PGSQLParserData.sAggregate['sCreateTextSearchConfiguration1']);
end;

procedure TPGSQLParserTest.c303CreateTextSearchDictionary;
begin
  DoTestSQL(PGSQLParserData.sAggregate['CreateTextSearchDictionary1']);
end;

procedure TPGSQLParserTest.c304CreateTextSearchParser;
begin
  DoTestSQL(PGSQLParserData.sAggregate['CreateTextSearchParser1']);
end;

procedure TPGSQLParserTest.c305CreateTextSearchTemplate;
begin
  DoTestSQL(PGSQLParserData.sAggregate['CreateTextSearchTemplate1']);
end;

procedure TPGSQLParserTest.c306DropTextSearchConfiguration;
begin
  DoTestSQL(PGSQLParserData.sAggregate['DropTextSearchConfiguration1']);
end;

procedure TPGSQLParserTest.c307DropTextSearchDictionary;
begin
  DoTestSQL(PGSQLParserData.sAggregate['DropTextSearchDictionary1']);
end;

procedure TPGSQLParserTest.c308DropTextSearchParser;
begin
  DoTestSQL(PGSQLParserData.sAggregate['DropTextSearchParser1']);
end;

procedure TPGSQLParserTest.c309DropTextSearchTemplate;
begin
  DoTestSQL(PGSQLParserData.sAggregate['DropTextSearchTemplate1']);
end;

procedure TPGSQLParserTest.c310AlterTablespace1;
begin
  DoTestSQL(PGSQLParserData.sDataBase['AlterTablespace1']);
end;

procedure TPGSQLParserTest.c311AlterTablespace2;
begin
  DoTestSQL(PGSQLParserData.sDataBase['AlterTablespace2']);
end;

procedure TPGSQLParserTest.c312CreateTablespace1;
begin
  DoTestSQL(PGSQLParserData.sDataBase['CreateTablespace1']);
end;

procedure TPGSQLParserTest.c313CreateTablespace2;
begin
  DoTestSQL(PGSQLParserData.sDataBase['CreateTablespace2']);
end;

procedure TPGSQLParserTest.c314DropTablespace;
begin
  DoTestSQL(PGSQLParserData.sDataBase['DropTablespace1']);
end;

procedure TPGSQLParserTest.c315AlterRule;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterRule1']);
end;

procedure TPGSQLParserTest.c316CreateRule1;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateRule1']);
end;

procedure TPGSQLParserTest.c317CreateRule2;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateRule2']);
end;

procedure TPGSQLParserTest.c318CreateRule3;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateRule3']);
end;

procedure TPGSQLParserTest.c319DropRule;
begin
  DoTestSQL(PGSQLParserData.sTable['DropRule1']);
end;

procedure TPGSQLParserTest.c320AlterPolicy;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterPolicy1']);
end;

procedure TPGSQLParserTest.c321CreatePolicy1;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreatePolicy1']);
end;

procedure TPGSQLParserTest.c322CreatePolicy2;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreatePolicy2']);
end;

procedure TPGSQLParserTest.c323CreatePolicy3;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreatePolicy3']);
end;

procedure TPGSQLParserTest.c324CreatePolicy4;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreatePolicy4']);
end;

procedure TPGSQLParserTest.c325CreatePolicy5;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreatePolicy5']);
end;

procedure TPGSQLParserTest.c326CreatePolicy6;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreatePolicy6']);
end;

procedure TPGSQLParserTest.c327CreatePolicy7;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['CreatePolicy7']);
end;

procedure TPGSQLParserTest.c328DropPolicy;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['DropPolicy1']);
end;

procedure TPGSQLParserTest.c329DropOwned;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['DropOwned1']);
end;

procedure TPGSQLParserTest.c330AlterOperator1;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterOperator1']);
end;

procedure TPGSQLParserTest.c331AlterOperator2;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterOperator2']);
end;

procedure TPGSQLParserTest.c332AlterOperatorClass;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterOperatorClass1']);
end;

procedure TPGSQLParserTest.c333AlterOperatorFamily1;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterOperatorFamily1']);
end;

procedure TPGSQLParserTest.c334AlterOperatorFamily2;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterOperatorFamily2']);
end;

procedure TPGSQLParserTest.c335CreateOperator;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateOperator1']);
end;

procedure TPGSQLParserTest.c336CreateOperatorClass;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateOperatorClass1']);
end;

procedure TPGSQLParserTest.c337CreateOperatorFamily;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateOperatorFamily1']);
end;

procedure TPGSQLParserTest.c338DropOperator1;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropOperator1']);
end;

procedure TPGSQLParserTest.c339DropOperator2;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropOperator2']);
end;

procedure TPGSQLParserTest.c340DropOperator3;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropOperator3']);
end;

procedure TPGSQLParserTest.c341DropOperator4;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropOperator4']);
end;

procedure TPGSQLParserTest.c342DropOperatorClass;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropOperatorClass1']);
end;

procedure TPGSQLParserTest.c343DropOperatorFamily;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropOperatorFamily1']);
end;

procedure TPGSQLParserTest.c344AlterForeignDataWrapper1;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterForeignDataWrapper1']);
end;

procedure TPGSQLParserTest.c345AlterForeignDataWrapper2;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterForeignDataWrapper2']);
end;

procedure TPGSQLParserTest.c346AlterForeignTable1;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterForeignTable1']);
end;

procedure TPGSQLParserTest.c347AlterForeignTable2;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterForeignTable2']);
end;

procedure TPGSQLParserTest.c348CreateForeignDataWrapper1;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateForeignDataWrapper1']);
end;

procedure TPGSQLParserTest.c349CreateForeignDataWrapper2;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateForeignDataWrapper2']);
end;

procedure TPGSQLParserTest.c350CreateForeignDataWrapper3;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateForeignDataWrapper3']);
end;

procedure TPGSQLParserTest.c351CreateForeignTable1;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateForeignTable1']);
end;

procedure TPGSQLParserTest.c352CreateForeignTable2;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateForeignTable2']);
end;

procedure TPGSQLParserTest.c353DropForeignDataWrapper;
begin
  DoTestSQL(PGSQLParserData.sTable['DropForeignDataWrapper1']);
end;

procedure TPGSQLParserTest.c354DropForeignTable;
begin
  DoTestSQL(PGSQLParserData.sTable['DropForeignTable1']);
end;

procedure TPGSQLParserTest.c355AlterExtension1;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterExtension1']);
end;

procedure TPGSQLParserTest.c356AlterExtension2;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterExtension2']);
end;

procedure TPGSQLParserTest.c357AlterExtension3;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterExtension3']);
end;

procedure TPGSQLParserTest.c358CreateExtension1;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateExtension1']);
end;

procedure TPGSQLParserTest.c359CreateExtension2;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateExtension2']);
end;

procedure TPGSQLParserTest.c360DropExtension;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropExtension1']);
end;

procedure TPGSQLParserTest.c361AlterLanguage1;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterLanguage1']);
end;

procedure TPGSQLParserTest.c362AlterLanguage2;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterLanguage2']);
end;

procedure TPGSQLParserTest.c363CreateLanguage1;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateLanguage1']);
end;

procedure TPGSQLParserTest.c364CreateLanguage2;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateLanguage2']);
end;

procedure TPGSQLParserTest.c365DropLanguage;
begin
  DoTestSQL(PGSQLParserData.sFunctions['DropLanguage1']);
end;

procedure TPGSQLParserTest.c366AlterEventTrigger1;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterEventTrigger1']);
end;

procedure TPGSQLParserTest.c367AlterEventTrigger2;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterEventTrigger2']);
end;

procedure TPGSQLParserTest.c368AlterEventTrigger3;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterEventTrigger3']);
end;

procedure TPGSQLParserTest.c369AlterEventTrigger4;
begin
  DoTestSQL(PGSQLParserData.sFunctions['AlterEventTrigger4']);
end;

procedure TPGSQLParserTest.c370CreateEventTrigger;
begin
  DoTestSQL(PGSQLParserData.sFunctions['CreateEventTrigger1']);
end;

procedure TPGSQLParserTest.c371DropEventTrigger;
begin
  DoTestSQL(PGSQLParserData.sFunctions['DropEventTrigger1']);
end;

procedure TPGSQLParserTest.c372DropConversion;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropConversion1']);
end;

procedure TPGSQLParserTest.c373AlterConversion1;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterConversion1']);
end;

procedure TPGSQLParserTest.c374AlterConversion2;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterConversion2']);
end;

procedure TPGSQLParserTest.c375CreateConversion;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateConversion1']);
end;

procedure TPGSQLParserTest.c376AlterCollation1;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterCollation1']);
end;

procedure TPGSQLParserTest.c377AlterCollation2;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterCollation2']);
end;

procedure TPGSQLParserTest.c378CreateCollation1;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateCollation1']);
end;

procedure TPGSQLParserTest.c379CreateCollation2;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateCollation2']);
end;

procedure TPGSQLParserTest.c380CreateCollation3;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateCollation3']);
end;

procedure TPGSQLParserTest.c381DropCollation;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropCollation1']);
end;

procedure TPGSQLParserTest.c382CreateCast;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateCast1']);
end;

procedure TPGSQLParserTest.c383DropCast;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropCast1']);
end;

procedure TPGSQLParserTest.c384CreateAccessMethod;
begin
  DoTestSQL(PGSQLParserData.sSystem['CreateAccessMethod1']);
end;

procedure TPGSQLParserTest.c385DropAccessMethod;
begin
  DoTestSQL(PGSQLParserData.sSystem['DropAccessMethod1']);
end;

procedure TPGSQLParserTest.c386AlterAggregate1;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterAggregate1']);
end;

procedure TPGSQLParserTest.c387AlterAggregate2;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterAggregate2']);
end;

procedure TPGSQLParserTest.c388AlterAggregate3;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterAggregate3']);
end;

procedure TPGSQLParserTest.c389AlterAggregate4;
begin
  DoTestSQL(PGSQLParserData.sAggregate['AlterAggregate4']);
end;

procedure TPGSQLParserTest.c390CreateAggregate1;
begin
  DoTestSQL(PGSQLParserData.sAggregate['CreateAggregate1']);
end;

procedure TPGSQLParserTest.c391CreateAggregate2;
begin
  DoTestSQL(PGSQLParserData.sAggregate['CreateAggregate2']);
end;

procedure TPGSQLParserTest.c392CreateAggregate3;
begin
  DoTestSQL(PGSQLParserData.sAggregate['CreateAggregate3']);
end;

procedure TPGSQLParserTest.c393CreateAggregate4;
begin
  DoTestSQL(PGSQLParserData.sAggregate['CreateAggregate4']);
end;

procedure TPGSQLParserTest.c394CreateAggregate5;
begin
  DoTestSQL(PGSQLParserData.sAggregate['CreateAggregate5']);
end;

procedure TPGSQLParserTest.c395CreateAggregate6;
begin
  DoTestSQL(PGSQLParserData.sAggregate['CreateAggregate6']);
end;

procedure TPGSQLParserTest.c396CreateAggregate7;
begin
  DoTestSQL(PGSQLParserData.sAggregate['CreateAggregate7']);
end;

procedure TPGSQLParserTest.c397DropAggregate1;
begin
  DoTestSQL(PGSQLParserData.sAggregate['DropAggregate1']);
end;

procedure TPGSQLParserTest.c398DropAggregate2;
begin
  DoTestSQL(PGSQLParserData.sAggregate['DropAggregate2']);
end;

procedure TPGSQLParserTest.c399DropAggregate3;
begin
  DoTestSQL(PGSQLParserData.sAggregate['DropAggregate3']);
end;

procedure TPGSQLParserTest.c400AlterDefaultPrivileges1;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterDefaultPrivileges1']);
end;

procedure TPGSQLParserTest.c401AlterDefaultPrivileges2;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterDefaultPrivileges2']);
end;

procedure TPGSQLParserTest.c402AlterDefaultPrivileges3;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterDefaultPrivileges3']);
end;

procedure TPGSQLParserTest.c403AlterDefaultPrivileges4;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterDefaultPrivileges4']);
end;

procedure TPGSQLParserTest.c404AlterDefaultPrivileges5;
begin
  DoTestSQL(PGSQLParserData.sUserAcess['AlterDefaultPrivileges5']);
end;

procedure TPGSQLParserTest.c405AlterLargeObject;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterLargeObject1']);
end;

procedure TPGSQLParserTest.c406AlterSystem1;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterSystem1']);
end;

procedure TPGSQLParserTest.c407AlterSystem2;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterSystem2']);
end;

procedure TPGSQLParserTest.c408AlterSystem3;
begin
  DoTestSQL(PGSQLParserData.sSystem['AlterSystem3']);
end;

procedure TPGSQLParserTest.c409CreateTableAs1;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTableAs1']);
end;

procedure TPGSQLParserTest.c410CreateTableAs2;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTableAs2']);
end;

procedure TPGSQLParserTest.c411CreateTableAs3;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTableAs3']);

end;

procedure TPGSQLParserTest.c412CreateTable1;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable1']);

end;

procedure TPGSQLParserTest.c413CreateTable2;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable2']);
end;

procedure TPGSQLParserTest.c414CreateTable3;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable3']);
end;

procedure TPGSQLParserTest.c415CreateTable4;
begin

  DoTestSQL(PGSQLParserData.sTable['CreateTable4']);
end;

procedure TPGSQLParserTest.c416CreateTable5;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable5']);
end;

procedure TPGSQLParserTest.c417CreateTable6;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable6']);
end;

procedure TPGSQLParserTest.c418CreateTable7;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable7']);
end;

procedure TPGSQLParserTest.c419CreateTable8;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable8']);
end;

procedure TPGSQLParserTest.c420CreateTable9;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable9']);
end;

procedure TPGSQLParserTest.c421CreateTable10;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable10']);
end;

procedure TPGSQLParserTest.c422CreateTable11;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable11']);
end;

procedure TPGSQLParserTest.c423CreateTable12;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable12']);
end;

procedure TPGSQLParserTest.c424CreateTable13;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable13']);
end;

procedure TPGSQLParserTest.c425CreateTable14;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable14']);
end;

procedure TPGSQLParserTest.c426CreateTable15;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable15']);
end;

procedure TPGSQLParserTest.c427CreateTable16;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable16']);
end;

procedure TPGSQLParserTest.c428CreateTable17;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable17']);
end;

procedure TPGSQLParserTest.c429CreateTable18;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable18']);
end;

procedure TPGSQLParserTest.c430CreateTable19;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable19']);
end;

procedure TPGSQLParserTest.c431CreateTabl20;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable20']);
end;

procedure TPGSQLParserTest.c432CreateTable21;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable21']);
end;

procedure TPGSQLParserTest.c433CreateTable22;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable22']);
end;

procedure TPGSQLParserTest.c434CreateTable23;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable23']);
end;

procedure TPGSQLParserTest.c435CreateTable24;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable24']);
end;

procedure TPGSQLParserTest.c436CreateTable25;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable25']);
end;

procedure TPGSQLParserTest.c437CreateTable26;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable26']);
end;

procedure TPGSQLParserTest.c438CreateTable27;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable27']);
end;

procedure TPGSQLParserTest.c439CreateTable28;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable28']);
end;

procedure TPGSQLParserTest.c440CreateTable29;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable29']);
end;

procedure TPGSQLParserTest.c441CreateTable30;
begin
  DoTestSQL(PGSQLParserData.sTable['CreateTable30']);
end;

procedure TPGSQLParserTest.c442AlterTable1;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterTable1']);
end;

procedure TPGSQLParserTest.c443AlterTable2;
begin
  DoTestSQL(PGSQLParserData.sTable['AlterTable2']);
end;

procedure TPGSQLParserTest.c444DropTable1;
begin
  DoTestSQL(PGSQLParserData.sTable['DropTable1']);
end;

procedure TPGSQLParserTest.c445DropTable2;
begin
  DoTestSQL(PGSQLParserData.sTable['DropTable2']);
end;


initialization
  RegisterTest(TPGSQLParserTest);
end.


