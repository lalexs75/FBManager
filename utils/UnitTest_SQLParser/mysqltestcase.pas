unit MySQLTestCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, fbmSqlParserUnit,
  RxTextHolder, mysql_engine, CustApp;

type

  { TMySQLParserTest }

  TMySQLParserTest= class(TTestCase)
  protected
    MySQL:TSQLEngineMySQL;
    procedure SetUp; override;
    procedure TearDown; override;
    function GetNextSQLCmd(ASql: string): TSQLCommandAbstract;
    procedure DoTestSQL(ASql: string);
  published
    procedure TestShowFullCollumns;
    procedure TestShowGrantsForUser1;
    procedure TestShowGrantsForUser2;
    procedure TestShowGrantsForUser3;
    procedure TestShowGrantsForUser4;
    procedure TestShowEngine1;
    procedure TestShowEngine2;
    procedure TestShowEngine3;
    procedure ShowVariables1;

    //ALTER DATABASE Syntax
    procedure AlterDatabase;
    //CREATE DATABASE Syntax
    procedure CreateDatabase1;
    procedure CreateDatabase2;
    //DROP DATABASE Syntax
    procedure DropDatabase;

    //CREATE TABLE Syntax
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
    //ALTER TABLE Syntax
    procedure AlterTable1;
    procedure AlterTable2;
    procedure AlterTable3;
    procedure AlterTable4;
    procedure AlterTable5;
    procedure AlterTable6;
    procedure AlterTable7;
    procedure AlterTable8;
    procedure AlterTable9;
    procedure AlterTable10;
    procedure AlterTable11;
    procedure AlterTable12;
    procedure AlterTable13;
    procedure AlterTable14;
    procedure AlterTable15;
    procedure AlterTable16;
    procedure AlterTable17;
    procedure AlterTable18;
    procedure AlterTable19;
    procedure AlterTable20;
    procedure AlterTable21;
    procedure AlterTable22;
    procedure AlterTable23;
    procedure AlterTable24;
    procedure AlterTable25;
    procedure AlterTable26;
    procedure AlterTable27;
    procedure AlterTable28;
    procedure AlterTable29;
    procedure AlterTable30;
    procedure AlterTable31;
    procedure AlterTable32;
    procedure AlterTable33;
    procedure AlterTable34;
    procedure AlterTable35;
    //DROP TABLE Syntax
    procedure DropTable1;
    procedure DropTable2;
    procedure DropTable3;
    procedure DropTable4;
    //REPAIR TABLE
    procedure RepairTable1;

    //ALTER VIEW Syntax
    procedure AlterView;
    //CREATE VIEW Syntax
    procedure CreateView1;
    procedure CreateView2;
    procedure CreateView3;
    procedure CreateView4;
    procedure CreateView5;
    procedure CreateView6;
    //DROP VIEW Syntax
    procedure DropView;


    //CREATE TRIGGER Syntax
    procedure CreateTrigger1;
    procedure CreateTrigger2;
    procedure CreateTrigger3;
    procedure CreateTrigger4;
    procedure CreateTrigger5;
    procedure CreateTrigger6;
    //DROP TRIGGER Syntax
    procedure DropTrigger;

    //ALTER SERVER Syntax
    procedure AlterServer;
    //CREATE SERVER Syntax
    procedure CreateServer;
    //DROP SERVER Syntax
    procedure DropServer1;
    procedure DropServer2;

    //ALTER TABLESPACE Syntax
    procedure AlterTablespace;
    //CREATE TABLESPACE Syntax
    procedure CreateTablespace1;
    procedure CreateTablespace2;
    //DROP TABLESPACE Syntax
    procedure DropTablespace;

    //ALTER EVENT Syntax
    procedure AlterEvent1;
    procedure AlterEvent2;
    procedure AlterEvent3;
    procedure AlterEvent4;
    procedure AlterEvent5;
    procedure AlterEvent6;
    //CREATE EVENT Syntax
    procedure CreateEvent1;
    procedure CreateEvent2;
    procedure CreateEvent3;
    procedure CreateEvent4;
    procedure CreateEvent5;
    procedure CreateEvent6;
    //DROP EVENT Syntax
    procedure DropEvent1;
    procedure DropEvent2;

    //CREATE INDEX Syntax
    procedure CreateIndex1;
    procedure CreateIndex2;
    procedure CreateIndex3;
    procedure CreateIndex4;
    procedure CreateIndex5;
    //DROP INDEX Syntax
    procedure DropIndex;

    //CREATE FUNCTION Syntax
    procedure CreateFunction1;
    procedure CreateFunction2;
    procedure CreateFunction3;
    procedure CreateFunction4;
    procedure CreateFunction5;
    procedure CreateFunction6;
    //DROP FUNCTION Syntax
    procedure DropFunction1;
    procedure DropFunction2;
    //ALTER FUNCTION Syntax
    procedure AlterFunction;

    //CREATE LOGFILE GROUP Syntax
    procedure CreateLogfileGroup1;
    procedure CreateLogfileGroup2;
    //ALTER LOGFILE GROUP Syntax
    procedure AlterLogfileGroup;
    //DROP LOGFILE GROUP Syntax
    procedure DropLogfileGroup1;
    procedure DropLogfileGroup2;
    procedure DropLogfileGroup3;

    //ALTER PROCEDURE Syntax
    procedure AlterProcedure1;
    procedure AlterProcedure2;
    //CREATE PROCEDURE and CREATE FUNCTION Syntax
    procedure CreateProcedure1;
    procedure CreateProcedure2;
    procedure CreateProcedure3;
    procedure CreateProcedure4;
    //DROP PROCEDURE and DROP FUNCTION Syntax
    procedure DropProcedure1;
    procedure DropProcedure2;

    //ALTER INSTANCE Syntax
    procedure AlterInstance;
    //RENAME TABLE Syntax
    procedure RenameTable1;
    procedure RenameTable2;
    procedure RenameTable3;
    procedure RenameTable4;
    procedure RenameTable5;
    procedure RenameTable6;
    //TRUNCATE TABLE Syntax
    procedure TruncateTable1;
    procedure TruncateTable2;
  end;


  { TMySQLParserData }

  TMySQLParserData= class(TDataModule)
    sShow: TRxTextHolder;
    sView: TRxTextHolder;
    sServer: TRxTextHolder;
    sFunction: TRxTextHolder;
    sTable: TRxTextHolder;
  public
  end;

var
  MySQLParserData : TMySQLParserData = nil;

implementation

{$R *.lfm}

procedure TMySQLParserTest.TestShowFullCollumns;
begin
  DoTestSQL(MySQLParserData.sShow['ShowFullCollumns1']);
end;

procedure TMySQLParserTest.TestShowGrantsForUser2;
begin
  DoTestSQL(MySQLParserData.sShow['ShowGrantsForUser2']);
end;

procedure TMySQLParserTest.TestShowGrantsForUser3;
begin
  DoTestSQL(MySQLParserData.sShow['ShowGrantsForUser3']);
end;

procedure TMySQLParserTest.TestShowGrantsForUser4;
begin
  DoTestSQL(MySQLParserData.sShow['ShowGrantsForUser4']);
end;

procedure TMySQLParserTest.TestShowEngine1;
begin
  DoTestSQL(MySQLParserData.sShow['ShowEngine1']);
end;

procedure TMySQLParserTest.TestShowEngine2;
begin
  DoTestSQL(MySQLParserData.sShow['ShowEngine2']);
end;

procedure TMySQLParserTest.TestShowEngine3;
begin
  DoTestSQL(MySQLParserData.sShow['ShowEngine3']);
end;

procedure TMySQLParserTest.ShowVariables1;
begin
  DoTestSQL(MySQLParserData.sShow['ShowVariables1']);
end;

procedure TMySQLParserTest.TestShowGrantsForUser1;
begin
  DoTestSQL(MySQLParserData.sShow['ShowGrantsForUser1']);
end;

procedure TMySQLParserTest.AlterDatabase;
begin
  DoTestSQL(MySQLParserData.sServer['AlterDatabase1']);
end;

procedure TMySQLParserTest.CreateDatabase1;
begin
  DoTestSQL(MySQLParserData.sServer['CreateDatabase1']);
end;

procedure TMySQLParserTest.CreateDatabase2;
begin
  DoTestSQL(MySQLParserData.sServer['CreateDatabase2']);
end;

procedure TMySQLParserTest.DropDatabase;
begin
  DoTestSQL(MySQLParserData.sServer['DropDatabase1']);
end;

procedure TMySQLParserTest.CreateTable1;
begin
  DoTestSQL(MySQLParserData.sTable['CreateTable1']);
end;

procedure TMySQLParserTest.CreateTable2;
begin
  DoTestSQL(MySQLParserData.sTable['CreateTable2']);
end;

procedure TMySQLParserTest.CreateTable3;
begin
  DoTestSQL(MySQLParserData.sTable['CreateTable3']);
end;

procedure TMySQLParserTest.CreateTable4;
begin
  DoTestSQL(MySQLParserData.sTable['CreateTable4']);
end;

procedure TMySQLParserTest.CreateTable5;
begin
  DoTestSQL(MySQLParserData.sTable['CreateTable5']);
end;

procedure TMySQLParserTest.CreateTable6;
begin
  DoTestSQL(MySQLParserData.sTable['CreateTable6']);
end;

procedure TMySQLParserTest.CreateTable7;
begin
  DoTestSQL(MySQLParserData.sTable['CreateTable7']);
end;

procedure TMySQLParserTest.CreateTable8;
begin
  DoTestSQL(MySQLParserData.sTable['CreateTable8']);
end;

procedure TMySQLParserTest.CreateTable9;
begin
  DoTestSQL(MySQLParserData.sTable['CreateTable9']);
end;

procedure TMySQLParserTest.CreateTable10;
begin
  DoTestSQL(MySQLParserData.sTable['CreateTable10']);
end;

procedure TMySQLParserTest.CreateTable11;
begin
  DoTestSQL(MySQLParserData.sTable['CreateTable11']);
end;

procedure TMySQLParserTest.CreateTable12;
begin
  DoTestSQL(MySQLParserData.sTable['CreateTable12']);
end;

procedure TMySQLParserTest.CreateTable13;
begin
  DoTestSQL(MySQLParserData.sTable['CreateTable13']);
end;

procedure TMySQLParserTest.CreateTable14;
begin
  DoTestSQL(MySQLParserData.sTable['CreateTable14']);
end;

procedure TMySQLParserTest.CreateTable15;
begin
  DoTestSQL(MySQLParserData.sTable['CreateTable15']);
end;

procedure TMySQLParserTest.CreateTable16;
begin
  DoTestSQL(MySQLParserData.sTable['CreateTable16']);
end;

procedure TMySQLParserTest.CreateTable17;
begin
  DoTestSQL(MySQLParserData.sTable['CreateTable17']);
end;

procedure TMySQLParserTest.AlterTable1;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable1']);
end;

procedure TMySQLParserTest.AlterTable2;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable2']);
end;

procedure TMySQLParserTest.AlterTable3;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable3']);
end;

procedure TMySQLParserTest.AlterTable4;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable4']);
end;

procedure TMySQLParserTest.AlterTable5;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable5']);
end;

procedure TMySQLParserTest.AlterTable6;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable6']);
end;

procedure TMySQLParserTest.AlterTable7;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable7']);
end;

procedure TMySQLParserTest.AlterTable8;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable8']);
end;

procedure TMySQLParserTest.AlterTable9;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable9']);
end;

procedure TMySQLParserTest.AlterTable10;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable10']);
end;

procedure TMySQLParserTest.AlterTable11;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable11']);
end;

procedure TMySQLParserTest.AlterTable12;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable12']);
end;

procedure TMySQLParserTest.AlterTable13;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable13']);
end;

procedure TMySQLParserTest.AlterTable14;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable14']);
end;

procedure TMySQLParserTest.AlterTable15;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable15']);
end;

procedure TMySQLParserTest.AlterTable16;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable16']);
end;

procedure TMySQLParserTest.AlterTable17;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable17']);
end;

procedure TMySQLParserTest.AlterTable18;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable18']);
end;

procedure TMySQLParserTest.AlterTable19;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable19']);
end;

procedure TMySQLParserTest.AlterTable20;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable20']);
end;

procedure TMySQLParserTest.AlterTable21;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable21']);
end;

procedure TMySQLParserTest.AlterTable22;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable22']);
end;

procedure TMySQLParserTest.AlterTable23;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable23']);
end;

procedure TMySQLParserTest.AlterTable24;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable24']);
end;

procedure TMySQLParserTest.AlterTable25;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable25']);
end;

procedure TMySQLParserTest.AlterTable26;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable26']);
end;

procedure TMySQLParserTest.AlterTable27;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable27']);
end;

procedure TMySQLParserTest.AlterTable28;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable28']);
end;

procedure TMySQLParserTest.AlterTable29;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable29']);
end;

procedure TMySQLParserTest.AlterTable30;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable30']);
end;

procedure TMySQLParserTest.AlterTable31;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable31']);
end;

procedure TMySQLParserTest.AlterTable32;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable32']);
end;

procedure TMySQLParserTest.AlterTable33;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable33']);
end;

procedure TMySQLParserTest.AlterTable34;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable34']);
end;

procedure TMySQLParserTest.AlterTable35;
begin
  DoTestSQL(MySQLParserData.sTable['AlterTable35']);
end;

procedure TMySQLParserTest.DropTable1;
begin
  DoTestSQL(MySQLParserData.sTable['DropTable1']);
end;

procedure TMySQLParserTest.DropTable2;
begin
  DoTestSQL(MySQLParserData.sTable['DropTable2']);
end;

procedure TMySQLParserTest.DropTable3;
begin
  DoTestSQL(MySQLParserData.sTable['DropTable3']);
end;

procedure TMySQLParserTest.DropTable4;
begin
  DoTestSQL(MySQLParserData.sTable['DropTable4']);
end;

procedure TMySQLParserTest.AlterView;
begin
  DoTestSQL(MySQLParserData.sView['AlterView1']);
end;

procedure TMySQLParserTest.CreateView1;
begin
  DoTestSQL(MySQLParserData.sView['CreateView1']);
end;

procedure TMySQLParserTest.CreateView2;
begin
  DoTestSQL(MySQLParserData.sView['CreateView2']);
end;

procedure TMySQLParserTest.CreateView3;
begin
  DoTestSQL(MySQLParserData.sView['CreateView3']);
end;

procedure TMySQLParserTest.CreateView4;
begin
  DoTestSQL(MySQLParserData.sView['CreateView4']);
end;

procedure TMySQLParserTest.CreateView5;
begin
  DoTestSQL(MySQLParserData.sView['CreateView5']);
end;

procedure TMySQLParserTest.CreateView6;
begin
  DoTestSQL(MySQLParserData.sView['CreateView6']);
end;

procedure TMySQLParserTest.DropView;
begin
  DoTestSQL(MySQLParserData.sView['DropView1']);
end;

procedure TMySQLParserTest.RepairTable1;
begin
  DoTestSQL(MySQLParserData.sTable['RepairTable1']);
end;

procedure TMySQLParserTest.CreateTrigger1;
begin
  DoTestSQL(MySQLParserData.sFunction['CreateTrigger1']);
end;

procedure TMySQLParserTest.CreateTrigger2;
begin
  DoTestSQL(MySQLParserData.sFunction['CreateTrigger2']);
end;

procedure TMySQLParserTest.CreateTrigger3;
begin
  DoTestSQL(MySQLParserData.sFunction['CreateTrigger3']);
end;

procedure TMySQLParserTest.CreateTrigger4;
begin
  DoTestSQL(MySQLParserData.sFunction['CreateTrigger4']);
end;

procedure TMySQLParserTest.CreateTrigger5;
begin
  DoTestSQL(MySQLParserData.sFunction['CreateTrigger5']);
end;

procedure TMySQLParserTest.CreateTrigger6;
begin
  DoTestSQL(MySQLParserData.sFunction['CreateTrigger6']);
end;

procedure TMySQLParserTest.DropTrigger;
begin
  DoTestSQL(MySQLParserData.sFunction['DropTrigger1']);
end;

procedure TMySQLParserTest.AlterServer;
begin
  DoTestSQL(MySQLParserData.sServer['AlterServer1']);
end;

procedure TMySQLParserTest.CreateServer;
begin
  DoTestSQL(MySQLParserData.sServer['CreateServer1']);
end;

procedure TMySQLParserTest.DropServer1;
begin
  DoTestSQL(MySQLParserData.sServer['DropServer1']);
end;

procedure TMySQLParserTest.DropServer2;
begin
  DoTestSQL(MySQLParserData.sServer['DropServer2']);
end;

procedure TMySQLParserTest.AlterTablespace;
begin
  DoTestSQL(MySQLParserData.sServer['AlterTablespace1']);
end;

procedure TMySQLParserTest.CreateTablespace1;
begin
  DoTestSQL(MySQLParserData.sServer['CreateTablespace1']);
end;

procedure TMySQLParserTest.CreateTablespace2;
begin
  DoTestSQL(MySQLParserData.sServer['CreateTablespace2']);
end;

procedure TMySQLParserTest.DropTablespace;
begin
  DoTestSQL(MySQLParserData.sServer['DropTablespace1']);
end;

procedure TMySQLParserTest.AlterEvent1;
begin
  DoTestSQL(MySQLParserData.sServer['AlterEvent1']);
end;

procedure TMySQLParserTest.AlterEvent2;
begin
  DoTestSQL(MySQLParserData.sServer['AlterEvent2']);
end;

procedure TMySQLParserTest.AlterEvent3;
begin
  DoTestSQL(MySQLParserData.sServer['AlterEvent3']);
end;

procedure TMySQLParserTest.AlterEvent4;
begin
  DoTestSQL(MySQLParserData.sServer['AlterEvent4']);
end;

procedure TMySQLParserTest.AlterEvent5;
begin
  DoTestSQL(MySQLParserData.sServer['AlterEvent5']);
end;

procedure TMySQLParserTest.AlterEvent6;
begin
  DoTestSQL(MySQLParserData.sServer['AlterEvent6']);
end;

procedure TMySQLParserTest.CreateEvent1;
begin
  DoTestSQL(MySQLParserData.sServer['CreateEvent1']);
end;

procedure TMySQLParserTest.CreateEvent2;
begin
  DoTestSQL(MySQLParserData.sServer['CreateEvent2']);
end;

procedure TMySQLParserTest.CreateEvent3;
begin
  DoTestSQL(MySQLParserData.sServer['CreateEvent3']);
end;

procedure TMySQLParserTest.CreateEvent4;
begin
  DoTestSQL(MySQLParserData.sServer['CreateEvent4']);
end;

procedure TMySQLParserTest.CreateEvent5;
begin
  DoTestSQL(MySQLParserData.sServer['CreateEvent5']);
end;

procedure TMySQLParserTest.CreateEvent6;
begin
  DoTestSQL(MySQLParserData.sServer['CreateEvent6']);
end;

procedure TMySQLParserTest.DropEvent1;
begin
  DoTestSQL(MySQLParserData.sServer['DropEvent1']);
end;

procedure TMySQLParserTest.DropEvent2;
begin
  DoTestSQL(MySQLParserData.sServer['DropEvent2']);
end;

procedure TMySQLParserTest.CreateIndex1;
begin
  DoTestSQL(MySQLParserData.sTable['CreateIndex1']);
end;

procedure TMySQLParserTest.CreateIndex2;
begin
  DoTestSQL(MySQLParserData.sTable['CreateIndex2']);
end;

procedure TMySQLParserTest.CreateIndex3;
begin
  DoTestSQL(MySQLParserData.sTable['CreateIndex3']);
end;

procedure TMySQLParserTest.CreateIndex4;
begin
  DoTestSQL(MySQLParserData.sTable['CreateIndex4']);
end;

procedure TMySQLParserTest.CreateIndex5;
begin
  DoTestSQL(MySQLParserData.sTable['CreateIndex5']);
end;

procedure TMySQLParserTest.DropIndex;
begin
  DoTestSQL(MySQLParserData.sTable['DropIndex1']);
end;

procedure TMySQLParserTest.CreateFunction1;
begin
  DoTestSQL(MySQLParserData.sFunction['CreateFunction1']);
end;

procedure TMySQLParserTest.CreateFunction2;
begin
  DoTestSQL(MySQLParserData.sFunction['CreateFunction2']);
end;

procedure TMySQLParserTest.CreateFunction3;
begin
  DoTestSQL(MySQLParserData.sFunction['CreateFunction3']);
end;

procedure TMySQLParserTest.CreateFunction4;
begin
  DoTestSQL(MySQLParserData.sFunction['CreateFunction4']);
end;

procedure TMySQLParserTest.CreateFunction5;
begin
  DoTestSQL(MySQLParserData.sFunction['CreateFunction5']);
end;

procedure TMySQLParserTest.CreateFunction6;
begin
  DoTestSQL(MySQLParserData.sFunction['CreateFunction6']);
end;

procedure TMySQLParserTest.DropFunction1;
begin
  DoTestSQL(MySQLParserData.sFunction['DropFunction1']);
end;

procedure TMySQLParserTest.DropFunction2;
begin
  DoTestSQL(MySQLParserData.sFunction['DropFunction2']);
end;

procedure TMySQLParserTest.AlterFunction;
begin
  DoTestSQL(MySQLParserData.sFunction['AlterFunction1']);
end;

procedure TMySQLParserTest.CreateLogfileGroup1;
begin
  DoTestSQL(MySQLParserData.sServer['CreateLogfileGroup1']);
end;

procedure TMySQLParserTest.CreateLogfileGroup2;
begin
  DoTestSQL(MySQLParserData.sServer['CreateLogfileGroup2']);
end;

procedure TMySQLParserTest.AlterLogfileGroup;
begin
  DoTestSQL(MySQLParserData.sServer['AlterLogfileGroup1']);
end;

procedure TMySQLParserTest.DropLogfileGroup1;
begin
  DoTestSQL(MySQLParserData.sServer['DropLogfileGroup1']);
end;

procedure TMySQLParserTest.DropLogfileGroup2;
begin
  DoTestSQL(MySQLParserData.sServer['DropLogfileGroup2']);
end;

procedure TMySQLParserTest.DropLogfileGroup3;
begin
  DoTestSQL(MySQLParserData.sServer['DropLogfileGroup3']);
end;

procedure TMySQLParserTest.AlterProcedure1;
begin
  DoTestSQL(MySQLParserData.sFunction['AlterProcedure1']);
end;

procedure TMySQLParserTest.AlterProcedure2;
begin
  DoTestSQL(MySQLParserData.sFunction['AlterProcedure2']);
end;

procedure TMySQLParserTest.CreateProcedure1;
begin
  DoTestSQL(MySQLParserData.sFunction['CreateProcedure1']);
end;

procedure TMySQLParserTest.CreateProcedure2;
begin
  DoTestSQL(MySQLParserData.sFunction['CreateProcedure2']);
end;

procedure TMySQLParserTest.CreateProcedure3;
begin
  DoTestSQL(MySQLParserData.sFunction['CreateProcedure3']);
end;

procedure TMySQLParserTest.CreateProcedure4;
begin
  DoTestSQL(MySQLParserData.sFunction['CreateProcedure4']);
end;

procedure TMySQLParserTest.DropProcedure1;
begin
  DoTestSQL(MySQLParserData.sFunction['DropProcedure1']);
end;

procedure TMySQLParserTest.DropProcedure2;
begin
  DoTestSQL(MySQLParserData.sFunction['DropProcedure2']);
end;

procedure TMySQLParserTest.AlterInstance;
begin
  DoTestSQL(MySQLParserData.sServer['AlterInstance1']);
end;

procedure TMySQLParserTest.RenameTable1;
begin
  DoTestSQL(MySQLParserData.sTable['RenameTable1']);
end;

procedure TMySQLParserTest.RenameTable2;
begin
  DoTestSQL(MySQLParserData.sTable['RenameTable2']);
end;

procedure TMySQLParserTest.RenameTable3;
begin
  DoTestSQL(MySQLParserData.sTable['RenameTable3']);
end;

procedure TMySQLParserTest.RenameTable4;
begin
  DoTestSQL(MySQLParserData.sTable['RenameTable4']);
end;

procedure TMySQLParserTest.RenameTable5;
begin
  DoTestSQL(MySQLParserData.sTable['RenameTable5']);
end;

procedure TMySQLParserTest.RenameTable6;
begin
  DoTestSQL(MySQLParserData.sTable['RenameTable6']);
end;

procedure TMySQLParserTest.TruncateTable1;
begin
  DoTestSQL(MySQLParserData.sTable['TruncateTable1']);
end;

procedure TMySQLParserTest.TruncateTable2;
begin
  DoTestSQL(MySQLParserData.sTable['TruncateTable2']);
end;

procedure TMySQLParserTest.SetUp;
begin
  MySQLParserData :=TMySQLParserData.Create(CustomApplication);
  MySQL:=TSQLEngineMySQL.Create;
end;

procedure TMySQLParserTest.TearDown;
begin
  FreeAndNil(MySQLParserData);
  MySQL.Free;
end;

function TMySQLParserTest.GetNextSQLCmd(ASql: string): TSQLCommandAbstract;
begin
  Result:=GetNextSQLCommand(ASql, MySQL, true);
end;

procedure TMySQLParserTest.DoTestSQL(ASql: string);
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

  RegisterTest(TMySQLParserTest);
end.

