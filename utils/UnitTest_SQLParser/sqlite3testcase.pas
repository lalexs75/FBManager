unit SQLite3TestCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, fbmSqlParserUnit,
  StrHolder, RxTextHolder, SQLite3EngineUnit, CustApp;

type

  { TSQLite3ParserTest }

  TSQLite3ParserTest= class(TTestCase)
  protected
    SQ3: TSQLEngineSQLite3;
    procedure SetUp; override;
    procedure TearDown; override;
    function GetNextSQLCmd(ASql: string): TSQLCommandAbstract;
    procedure DoTestSQL(ASql: string);
  published
    //CREATE TABLE
    procedure CreateTable1;
    procedure CreateTable2;
    procedure CreateTable3;
    procedure CreateTable4;
    procedure CreateTable5;
    procedure CreateTable6;
    procedure CreateTable8;
    procedure CreateTable9;
    procedure CreateTable10;
    procedure CreateTable11;
    //ALTER TABLE
    procedure AlterTable1;
    procedure AlterTable2;
    //DROP TABLE
    procedure DropTable1;
    procedure DropTable2;
    procedure DropTable3;

    //CREATE INDEX
    procedure CreateIndex1;
    procedure CreateIndex2;
    //DROP INDEX
    procedure DropIndex;

    //CREATE TRIGGER
    //DROP TRIGGER
    procedure CreateTrigger1;
    procedure CreateTrigger2;
    procedure DropTrigger1;
    procedure DropTrigger2;

    //CREATE VIEW
    procedure CreateView1;
    procedure CreateView2;
    //DROP VIEW
    procedure DropView1;
    procedure DropView2;
    procedure DropView3;
    (*
ANALYZE
ATTACH DATABASE
BEGIN TRANSACTION
comment
COMMIT TRANSACTION

CREATE VIRTUAL TABLE
DELETE
DETACH DATABASE

END TRANSACTION
EXPLAIN
expression
INDEXED BY

INSERT
ON CONFLICT clause
PRAGMA
REINDEX
RELEASE SAVEPOINT
REPLACE
ROLLBACK TRANSACTION
SAVEPOINT
SELECT
UPDATE
UPSERT
VACUUM
WITH clause
*)
  end;

  { TSQLite3ParserData }

  TSQLite3ParserData = class(TDataModule)
    sViews: TRxTextHolder;
    sTrigger: TRxTextHolder;
    sIndex: TRxTextHolder;
    sTable: TRxTextHolder;
  public
  end;

var
  SQLite3ParserData : TSQLite3ParserData = nil;

implementation

{$R *.lfm}

procedure TSQLite3ParserTest.CreateTable1;
begin
  DoTestSQL(SQLite3ParserData.sTable['CreateTable1']);
end;

procedure TSQLite3ParserTest.CreateTable2;
begin
  DoTestSQL(SQLite3ParserData.sTable['CreateTable2']);
end;

procedure TSQLite3ParserTest.CreateTable3;
begin
  DoTestSQL(SQLite3ParserData.sTable['CreateTable3']);
end;

procedure TSQLite3ParserTest.CreateTable4;
begin
  DoTestSQL(SQLite3ParserData.sTable['CreateTable4']);
end;

procedure TSQLite3ParserTest.CreateTable5;
begin
  DoTestSQL(SQLite3ParserData.sTable['CreateTable5']);
end;

procedure TSQLite3ParserTest.CreateTable6;
begin
  DoTestSQL(SQLite3ParserData.sTable['CreateTable6']);
end;

procedure TSQLite3ParserTest.CreateTable8;
begin
  DoTestSQL(SQLite3ParserData.sTable['CreateTable8']);
end;

procedure TSQLite3ParserTest.CreateTable9;
begin
  DoTestSQL(SQLite3ParserData.sTable['CreateTable9']);
end;

procedure TSQLite3ParserTest.CreateTable10;
begin
  DoTestSQL(SQLite3ParserData.sTable['CreateTable10']);
end;

procedure TSQLite3ParserTest.CreateTable11;
begin
  DoTestSQL(SQLite3ParserData.sTable['CreateTable11']);
end;

procedure TSQLite3ParserTest.AlterTable1;
begin
  DoTestSQL(SQLite3ParserData.sTable['AlterTable1']);
end;

procedure TSQLite3ParserTest.AlterTable2;
begin
  DoTestSQL(SQLite3ParserData.sTable['AlterTable2']);
end;

procedure TSQLite3ParserTest.DropTable1;
begin
  DoTestSQL(SQLite3ParserData.sTable['DropTable1']);
end;

procedure TSQLite3ParserTest.DropTable2;
begin
  DoTestSQL(SQLite3ParserData.sTable['DropTable2']);
end;

procedure TSQLite3ParserTest.DropTable3;
begin
  DoTestSQL(SQLite3ParserData.sTable['DropTable3']);
end;

procedure TSQLite3ParserTest.CreateIndex1;
begin
  DoTestSQL(SQLite3ParserData.sIndex['CreateIndex1']);
end;

procedure TSQLite3ParserTest.CreateIndex2;
begin
  DoTestSQL(SQLite3ParserData.sIndex['CreateIndex2']);
end;

procedure TSQLite3ParserTest.DropIndex;
begin
  DoTestSQL(SQLite3ParserData.sIndex['DropIndex1']);
end;

procedure TSQLite3ParserTest.CreateTrigger1;
begin
  DoTestSQL(SQLite3ParserData.sTrigger['CreateTrigger1']);
end;

procedure TSQLite3ParserTest.CreateTrigger2;
begin
  DoTestSQL(SQLite3ParserData.sTrigger['CreateTrigger2']);
end;

procedure TSQLite3ParserTest.DropTrigger1;
begin
  DoTestSQL(SQLite3ParserData.sTrigger['DropTrigger1']);
end;

procedure TSQLite3ParserTest.DropTrigger2;
begin
  DoTestSQL(SQLite3ParserData.sTrigger['DropTrigger2']);
end;

procedure TSQLite3ParserTest.CreateView1;
begin
  DoTestSQL(SQLite3ParserData.sViews['CreateView1']);
end;

procedure TSQLite3ParserTest.CreateView2;
begin
  DoTestSQL(SQLite3ParserData.sViews['CreateView2']);
end;

procedure TSQLite3ParserTest.DropView1;
begin
  DoTestSQL(SQLite3ParserData.sViews['DropView1']);
end;

procedure TSQLite3ParserTest.DropView2;
begin
  DoTestSQL(SQLite3ParserData.sViews['DropView2']);
end;

procedure TSQLite3ParserTest.DropView3;
begin
  DoTestSQL(SQLite3ParserData.sViews['DropView3']);
end;

procedure TSQLite3ParserTest.SetUp;
begin
  SQLite3ParserData := TSQLite3ParserData.Create(CustomApplication);
  SQ3:=TSQLEngineSQLite3.Create;
end;

procedure TSQLite3ParserTest.TearDown;
begin
  FreeAndNil(SQLite3ParserData);
  SQ3.Free;
end;

function TSQLite3ParserTest.GetNextSQLCmd(ASql: string): TSQLCommandAbstract;
begin
  Result:=GetNextSQLCommand(ASql, SQ3, true);
end;

procedure TSQLite3ParserTest.DoTestSQL(ASql: string);
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

initialization
  RegisterTest(TSQLite3ParserTest);
end.

