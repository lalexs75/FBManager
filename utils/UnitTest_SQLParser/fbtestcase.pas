unit FBTestCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, fbmSqlParserUnit,
  StrHolder, RxTextHolder, FBSQLEngineUnit, CustApp;

type

  { TFBSQLParserTest }

  TFBSQLParserTest= class(TTestCase)
  protected
    FB: TSQLEngineFireBird;
    procedure SetUp; override;
    procedure TearDown; override;
    function GetNextSQLCmd(ASql: string): TSQLCommandAbstract;
    procedure DoTestSQL(ASql: string);
  published
    procedure Revoke;
    procedure Grant1;
    procedure Grant2;
    procedure Grant3;

    procedure SequenceAlter;
    procedure SequenceDrop1;

    //CREATE DATABASE
    procedure CreateDatabase1;
    procedure CreateDatabase2;
    procedure CreateDatabase3;
    procedure CreateDatabase4;
    procedure CreateDatabase5;
    procedure CreateDatabase6;
    procedure CreateDatabase7;
    procedure CreateDatabase8;
    procedure CreateDatabase9;
    procedure CreateDatabase10;
    procedure CreateDatabase11;
    //ALTER DATABASE
    procedure AlterDatabase1;
    procedure AlterDatabase2;
    procedure AlterDatabase3;
    procedure AlterDatabase4;
    procedure AlterDatabase5;
    procedure AlterDatabase6;
    procedure AlterDatabase7;
    procedure AlterDatabase8;
    procedure AlterDatabase9;
    procedure AlterDatabase10;
    procedure AlterDatabase11;
    //DROP DATABASE
    procedure DropDatabase;

    //CREATE SHADOW
    procedure CreateShadow1;
    procedure CreateShadow2;
    //DROP SHADOW
    procedure DropShadow1;
    procedure DropShadow2;
    procedure DropShadow3;

    //CREATE DOMAIN
    procedure CreateDomain1;
    procedure CreateDomain2;
    procedure CreateDomain3;
    procedure CreateDomain4;
    procedure CreateDomain5;
    procedure CreateDomain6;
    //ALTER DOMAIN
    procedure AlterDomain1;
    procedure AlterDomain2;
    procedure AlterDomain3;
    procedure AlterDomain4;
    procedure AlterDomain5;
    procedure AlterDomain6;
    procedure AlterDomain7;
    procedure AlterDomain8;
    procedure AlterDomain9;
    procedure AlterDomain10;
    procedure AlterDomain11;
    procedure AlterDomain12;
    procedure AlterDomain13;
    procedure AlterDomain14;
    //DROP DOMAIN
    procedure DropDomain1;
    procedure DropDomain2;

    //CREATE TABLE
    //ALTER TABLE
    //DROP TABLE
    //RECREATE TABLE
    procedure CreateTable1;
    procedure CreateTable2;
    procedure CreateTable3;
    procedure CreateTable4;
    procedure CreateTable5;
    procedure CreateTable6;
    procedure CreateTable7;
    procedure CreateTable8;
    procedure CreateTable9;
    procedure AlterTable1;
    procedure AlterTable2;
    procedure AlterTable3;
    procedure AlterTable4;
    procedure AlterTable5;
    procedure AlterTable6;
    procedure AlterTable7;
    procedure DropTable1;
    procedure RecreateTable;

    //CREATE INDEX
    //ALTER INDEX
    //DROP INDEX
    procedure CreateIndex1;
    procedure CreateIndex2;
    procedure CreateIndex3;
    procedure CreateIndex4;
    procedure CreateIndex5;
    procedure AlterIndex1;
    procedure AlterIndex2;
    procedure DropIndex;
    //SET STATISTICS INDEX
    procedure SetStatisticsIndex;

    //CREATE VIEW
    //ALTER VIEW
    //CREATE OR ALTER VIEW
    //DROP VIEW
    //RECREATE VIEW
    procedure CreateView1;
    procedure CreateView2;
    procedure CreateView3;
    procedure CreateView4;
    procedure CreateView5;
    procedure AlterView;
    procedure CreateOrAlterView;
    procedure DropView1;
    procedure DropView2;
    procedure RecreateView1;
    procedure RecreateView2;

    //CREATE TRIGGER
    //ALTER TRIGGER
    //CREATE OR ALTER TRIGGER
    //DROP TRIGGER
    //RECREATE TRIGGER
    procedure CreateTrigger1;
    procedure CreateTrigger2;
    procedure CreateTrigger3;
    procedure CreateTrigger4;
    procedure CreateTrigger5;
    procedure CreateTrigger6;
    procedure CreateTrigger7;
    procedure CreateTrigger8;
    procedure CreateTrigger9;
    procedure AlterTrigger1;
    procedure AlterTrigger2;
    procedure AlterTrigger3;
    procedure AlterTrigger4;
    procedure CreateOrAlterTrigger;
    procedure DropTrigger;
    procedure RecreateTrigger;

    //CREATE PROCEDURE
    //ALTER PROCEDURE
    //CREATE OR ALTER PROCEDURE
    //DROP PROCEDURE
    //RECREATE PROCEDURE
    procedure CreateProcedure1;
    procedure CreateProcedure2;
    procedure AlterProcedure;
    procedure CreateOrAlterProcedure;
    procedure DropProcedure;
    procedure RecreateProcedure;

    //CREATE FUNCTION
    //ALTER FUNCTION
    //CREATE OR ALTER FUNCTION
    //DROP FUNCTION
    //RECREATE FUNCTION
    procedure CreateFunction1;
    procedure CreateFunction2;
    procedure CreateFunction3;
    procedure CreateFunction4;
    procedure CreateFunction5;
    procedure CreateFunction6;
    procedure AlterFunction;
    procedure CreateOrAlterFunction;
    procedure DropFunction;
    procedure RecreateFunction;

    //CREATE PACKAGE
    //ALTER PACKAGE
    //CREATE OR ALTER PACKAGE
    //DROP PACKAGE
    //RECREATE PACKAGE
    procedure CreatePackage;
    procedure AlterPackage;
    procedure CreateOrAlterPackage;
    procedure DropPackage;
    procedure RecreatePackage;

    //CREATE PACKAGE BODY
    //ALTER PACKAGE BODY
    //DROP PACKAGE BODY
    //RECREATE PACKAGE BODY
    procedure CreatePackageBody;
    procedure AlterPackageBody;
    procedure DropPackageBody;
    procedure RecreatePackageBody;


    //CREATE SEQUENCE
    //ALTER SEQUENCE
    //CREATE OR ALTER SEQUENCE
    //DROP SEQUENCE
    //RECREATE SEQUENCE
    //SET GENERATOR
    procedure CreateSequence1;
    procedure CreateSequence2;
    procedure CreateSequence3;
    procedure CreateSequence4;
    procedure AlterSequence1;
    procedure AlterSequence2;
    procedure AlterSequence3;
    procedure CreateOrAlterSequence;
    procedure DropSequence;
    procedure RecreateSequence;
    procedure SetGenerator;

    //DECLARE EXTERNAL FUNCTION
    //ALTER EXTERNAL FUNCTION
    //DROP EXTERNAL FUNCTION
    procedure DeclareExternalFunction1;
    procedure DeclareExternalFunction2;
    procedure DeclareExternalFunction3;
    procedure DeclareExternalFunction4;
    procedure AlterExternalFunction1;
    procedure AlterExternalFunction2;
    procedure DropExternalFunction;

    procedure CreateException1;
    procedure CreateException2;
    procedure CreateException3;
    procedure AlterException1;
    procedure AlterException2;
    procedure CreateOrAlterException1;
    procedure CreateOrAlterException2;
    procedure DropException1;
    procedure DropException2;
    procedure RecreateException;

    //CREATE ROLE
    //ALTER ROLE
    //DROP ROLE
    procedure CreateRole;
    procedure AlterRole1;
    procedure AlterRole2;
    procedure DropRole;

    //DECLARE FILTER
    //DROP FILTER
    //CREATE COLLATION
    //DROP COLLATION
    procedure DeclareFilter1;
    procedure DeclareFilter2;
    procedure DropFilter;
    procedure CreateCollation1;
    procedure CreateCollation2;
    procedure CreateCollation3;
    procedure CreateCollation4;
    procedure CreateCollation5;
    procedure DropCollation;

    //ALTER CHARACTER SET
    //COMMENT ON
    procedure AlterCharacterSet;
    procedure CommentOn1;
    procedure CommentOn2;
    procedure CommentOn3;
    procedure CommentOn4;
    procedure CommentOn5;
    procedure CommentOn6;
    procedure CommentOn7;
    procedure CommentOn8;

    procedure Transaction1;
    procedure Transaction2;
    procedure Transaction3;
    procedure Transaction4;
    procedure Transaction5;
    procedure Transaction6;
    procedure Transaction7;
    procedure Transaction8;
    procedure Transaction9;
    procedure Transaction10;
    procedure Transaction11;

    procedure Rollback1;
    procedure Rollback2;
    procedure Rollback3;
    procedure Rollback4;
    procedure Rollback5;
    procedure Rollback6;
    procedure Rollback7;
    procedure Rollback8;

    procedure Savepoint1;
    procedure Savepoint2;
    procedure Savepoint3;

    procedure Commit1;
    procedure Commit2;
    procedure Commit3;
    procedure Commit4;
    procedure Commit5;
    procedure Commit6;
  end;

  { TFBTestSQLData }

  TFBTestSQLData = class(TDataModule)
    sTransaction: TRxTextHolder;
    sException: TRxTextHolder;
    sComment: TRxTextHolder;
    sDataBase: TRxTextHolder;
    sGenerator: TRxTextHolder;
    sUsers: TRxTextHolder;
    sTable: TRxTextHolder;
    sProcedure: TRxTextHolder;
    sDomain: TRxTextHolder;
    sView: TRxTextHolder;
  end;

var
  FBTestSQLData:TFBTestSQLData = nil;

implementation

{$R *.lfm}

procedure TFBSQLParserTest.Revoke;
begin
  DoTestSQL(FBTestSQLData.sUsers['Revoke1']);
end;

procedure TFBSQLParserTest.Grant1;
begin
  DoTestSQL(FBTestSQLData.sUsers['Graint1']);
end;

procedure TFBSQLParserTest.Grant2;
begin
  DoTestSQL(FBTestSQLData.sUsers['Graint2']);
end;

procedure TFBSQLParserTest.Grant3;
begin
  DoTestSQL(FBTestSQLData.sUsers['Graint3']);
end;

procedure TFBSQLParserTest.SequenceAlter;
begin
  DoTestSQL(FBTestSQLData.sGenerator['AlterSequence4']);
end;

procedure TFBSQLParserTest.SequenceDrop1;
begin
  DoTestSQL(FBTestSQLData.sGenerator['DropSequence2']);
end;


procedure TFBSQLParserTest.CreateDatabase1;
begin
  DoTestSQL(FBTestSQLData.sDataBase['CreateDatabase1']);
end;

procedure TFBSQLParserTest.CreateDatabase2;
begin
  DoTestSQL(FBTestSQLData.sDataBase['CreateDatabase2']);
end;

procedure TFBSQLParserTest.CreateDatabase3;
begin
  DoTestSQL(FBTestSQLData.sDataBase['CreateDatabase3']);
end;

procedure TFBSQLParserTest.CreateDatabase4;
begin
  DoTestSQL(FBTestSQLData.sDataBase['CreateDatabase4']);
end;

procedure TFBSQLParserTest.CreateDatabase5;
begin
  DoTestSQL(FBTestSQLData.sDataBase['CreateDatabase5']);
end;

procedure TFBSQLParserTest.CreateDatabase6;
begin
  DoTestSQL(FBTestSQLData.sDataBase['CreateDatabase6']);
end;

procedure TFBSQLParserTest.CreateDatabase7;
begin
  DoTestSQL(FBTestSQLData.sDataBase['CreateDatabase7']);
end;

procedure TFBSQLParserTest.CreateDatabase8;
begin
  DoTestSQL(FBTestSQLData.sDataBase['CreateDatabase8']);
end;

procedure TFBSQLParserTest.CreateDatabase9;
begin
  DoTestSQL(FBTestSQLData.sDataBase['CreateDatabase9']);
end;

procedure TFBSQLParserTest.CreateDatabase10;
begin
  DoTestSQL(FBTestSQLData.sDataBase['CreateDatabase10']);
end;

procedure TFBSQLParserTest.CreateDatabase11;
begin
  DoTestSQL(FBTestSQLData.sDataBase['CreateDatabase11']);
end;

procedure TFBSQLParserTest.AlterDatabase1;
begin
  DoTestSQL(FBTestSQLData.sDataBase['AlterDatabase1']);
end;

procedure TFBSQLParserTest.AlterDatabase2;
begin
  DoTestSQL(FBTestSQLData.sDataBase['AlterDatabase2']);
end;

procedure TFBSQLParserTest.AlterDatabase3;
begin
  DoTestSQL(FBTestSQLData.sDataBase['AlterDatabase3']);
end;

procedure TFBSQLParserTest.AlterDatabase4;
begin
  DoTestSQL(FBTestSQLData.sDataBase['AlterDatabase4']);
end;

procedure TFBSQLParserTest.AlterDatabase5;
begin
  DoTestSQL(FBTestSQLData.sDataBase['AlterDatabase5']);
end;

procedure TFBSQLParserTest.AlterDatabase6;
begin
  DoTestSQL(FBTestSQLData.sDataBase['AlterDatabase6']);
end;

procedure TFBSQLParserTest.AlterDatabase7;
begin
  DoTestSQL(FBTestSQLData.sDataBase['AlterDatabase7']);
end;

procedure TFBSQLParserTest.AlterDatabase8;
begin
  DoTestSQL(FBTestSQLData.sDataBase['AlterDatabase8']);
end;

procedure TFBSQLParserTest.AlterDatabase9;
begin
  DoTestSQL(FBTestSQLData.sDataBase['AlterDatabase9']);
end;

procedure TFBSQLParserTest.AlterDatabase10;
begin
  DoTestSQL(FBTestSQLData.sDataBase['AlterDatabase10']);
end;

procedure TFBSQLParserTest.AlterDatabase11;
begin
  DoTestSQL(FBTestSQLData.sDataBase['AlterDatabase11']);
end;

procedure TFBSQLParserTest.DropDatabase;
begin
  DoTestSQL(FBTestSQLData.sDataBase['DropDatabase1']);
end;

procedure TFBSQLParserTest.CreateShadow1;
begin
  DoTestSQL(FBTestSQLData.sDataBase['CreateShadow1']);
end;

procedure TFBSQLParserTest.CreateShadow2;
begin
  DoTestSQL(FBTestSQLData.sDataBase['CreateShadow2']);
end;

procedure TFBSQLParserTest.DropShadow1;
begin
  DoTestSQL(FBTestSQLData.sDataBase['DropShadow1']);
end;

procedure TFBSQLParserTest.DropShadow2;
begin
  DoTestSQL(FBTestSQLData.sDataBase['DropShadow2']);
end;

procedure TFBSQLParserTest.DropShadow3;
begin
  DoTestSQL(FBTestSQLData.sDataBase['DropShadow3']);
end;

procedure TFBSQLParserTest.CreateDomain1;
begin
  DoTestSQL(FBTestSQLData.sDomain['CreateDomain1']);
end;

procedure TFBSQLParserTest.CreateDomain2;
begin
  DoTestSQL(FBTestSQLData.sDomain['CreateDomain2']);
end;

procedure TFBSQLParserTest.CreateDomain3;
begin
  DoTestSQL(FBTestSQLData.sDomain['CreateDomain3']);
end;

procedure TFBSQLParserTest.CreateDomain4;
begin
  DoTestSQL(FBTestSQLData.sDomain['CreateDomain4']);
end;

procedure TFBSQLParserTest.CreateDomain5;
begin
  DoTestSQL(FBTestSQLData.sDomain['CreateDomain5']);
end;

procedure TFBSQLParserTest.CreateDomain6;
begin
  DoTestSQL(FBTestSQLData.sDomain['CreateDomain6']);
end;

procedure TFBSQLParserTest.AlterDomain1;
begin
  DoTestSQL(FBTestSQLData.sDomain['AlterDomain1']);
end;

procedure TFBSQLParserTest.AlterDomain2;
begin
  DoTestSQL(FBTestSQLData.sDomain['AlterDomain2']);
end;

procedure TFBSQLParserTest.AlterDomain3;
begin
  DoTestSQL(FBTestSQLData.sDomain['AlterDomain3']);
end;

procedure TFBSQLParserTest.AlterDomain4;
begin
  DoTestSQL(FBTestSQLData.sDomain['AlterDomain4']);
end;

procedure TFBSQLParserTest.AlterDomain5;
begin
  DoTestSQL(FBTestSQLData.sDomain['AlterDomain5']);
end;

procedure TFBSQLParserTest.AlterDomain6;
begin
  DoTestSQL(FBTestSQLData.sDomain['AlterDomain6']);
end;

procedure TFBSQLParserTest.AlterDomain7;
begin
  DoTestSQL(FBTestSQLData.sDomain['AlterDomain7']);
end;

procedure TFBSQLParserTest.AlterDomain8;
begin
  DoTestSQL(FBTestSQLData.sDomain['AlterDomain8']);
end;

procedure TFBSQLParserTest.AlterDomain9;
begin
  DoTestSQL(FBTestSQLData.sDomain['AlterDomain9']);
end;

procedure TFBSQLParserTest.AlterDomain10;
begin
  DoTestSQL(FBTestSQLData.sDomain['AlterDomain10']);
end;

procedure TFBSQLParserTest.AlterDomain11;
begin
  DoTestSQL(FBTestSQLData.sDomain['AlterDomain11']);
end;

procedure TFBSQLParserTest.AlterDomain12;
begin
  DoTestSQL(FBTestSQLData.sDomain['AlterDomain12']);
end;

procedure TFBSQLParserTest.AlterDomain13;
begin
  DoTestSQL(FBTestSQLData.sDomain['AlterDomain13']);
end;

procedure TFBSQLParserTest.AlterDomain14;
begin
  DoTestSQL(FBTestSQLData.sDomain['AlterDomain14']);
end;

procedure TFBSQLParserTest.DropDomain1;
begin
  DoTestSQL(FBTestSQLData.sDomain['DropDomain1']);
end;

procedure TFBSQLParserTest.DropDomain2;
begin
  DoTestSQL(FBTestSQLData.sDomain['DropDomain2']);
end;

procedure TFBSQLParserTest.CreateTable1;
begin
  DoTestSQL(FBTestSQLData.sTable['CreateTable1']);
end;

procedure TFBSQLParserTest.CreateTable2;
begin
  DoTestSQL(FBTestSQLData.sTable['CreateTable2']);
end;

procedure TFBSQLParserTest.CreateTable3;
begin
  DoTestSQL(FBTestSQLData.sTable['CreateTable3']);
end;

procedure TFBSQLParserTest.CreateTable4;
begin
  DoTestSQL(FBTestSQLData.sTable['CreateTable4']);
end;

procedure TFBSQLParserTest.CreateTable5;
begin
  DoTestSQL(FBTestSQLData.sTable['CreateTable5']);
end;

procedure TFBSQLParserTest.CreateTable6;
begin
  DoTestSQL(FBTestSQLData.sTable['CreateTable6']);
end;

procedure TFBSQLParserTest.CreateTable7;
begin
  DoTestSQL(FBTestSQLData.sTable['CreateTable7']);
end;

procedure TFBSQLParserTest.CreateTable8;
begin
  DoTestSQL(FBTestSQLData.sTable['CreateTable8']);
end;

procedure TFBSQLParserTest.CreateTable9;
begin
  DoTestSQL(FBTestSQLData.sTable['CreateTable9']);
end;

procedure TFBSQLParserTest.AlterTable1;
begin
  DoTestSQL(FBTestSQLData.sTable['AlterTable1']);
end;

procedure TFBSQLParserTest.AlterTable2;
begin
  DoTestSQL(FBTestSQLData.sTable['AlterTable2']);
end;

procedure TFBSQLParserTest.AlterTable3;
begin
  DoTestSQL(FBTestSQLData.sTable['AlterTable3']);
end;

procedure TFBSQLParserTest.AlterTable4;
begin
  DoTestSQL(FBTestSQLData.sTable['AlterTable4']);
end;

procedure TFBSQLParserTest.AlterTable5;
begin
  DoTestSQL(FBTestSQLData.sTable['AlterTable5']);
end;

procedure TFBSQLParserTest.AlterTable6;
begin
  DoTestSQL(FBTestSQLData.sTable['AlterTable6']);
end;

procedure TFBSQLParserTest.AlterTable7;
begin
  DoTestSQL(FBTestSQLData.sTable['AlterTable7']);
end;

procedure TFBSQLParserTest.DropTable1;
begin
  DoTestSQL(FBTestSQLData.sTable['DropTable1']);
end;

procedure TFBSQLParserTest.RecreateTable;
begin
  DoTestSQL(FBTestSQLData.sTable['RecreateTable1']);
end;

procedure TFBSQLParserTest.CreateIndex1;
begin
  DoTestSQL(FBTestSQLData.sTable['CreateIndex1']);
end;

procedure TFBSQLParserTest.CreateIndex2;
begin
  DoTestSQL(FBTestSQLData.sTable['CreateIndex2']);
end;

procedure TFBSQLParserTest.CreateIndex3;
begin
  DoTestSQL(FBTestSQLData.sTable['CreateIndex3']);
end;

procedure TFBSQLParserTest.CreateIndex4;
begin
  DoTestSQL(FBTestSQLData.sTable['CreateIndex4']);
end;

procedure TFBSQLParserTest.CreateIndex5;
begin
  DoTestSQL(FBTestSQLData.sTable['CreateIndex5']);
end;

procedure TFBSQLParserTest.AlterIndex1;
begin
  DoTestSQL(FBTestSQLData.sTable['AlterIndex1']);
end;

procedure TFBSQLParserTest.AlterIndex2;
begin
  DoTestSQL(FBTestSQLData.sTable['AlterIndex2']);
end;

procedure TFBSQLParserTest.DropIndex;
begin
  DoTestSQL(FBTestSQLData.sTable['DropIndex1']);
end;

procedure TFBSQLParserTest.SetStatisticsIndex;
begin
  DoTestSQL(FBTestSQLData.sTable['SetStatisticsIndex1']);
end;

procedure TFBSQLParserTest.CreateView1;
begin
  DoTestSQL(FBTestSQLData.sView['CreateView1']);
end;

procedure TFBSQLParserTest.CreateView2;
begin
  DoTestSQL(FBTestSQLData.sView['CreateView2']);
end;

procedure TFBSQLParserTest.CreateView3;
begin
  DoTestSQL(FBTestSQLData.sView['CreateView3']);
end;

procedure TFBSQLParserTest.CreateView4;
begin
  DoTestSQL(FBTestSQLData.sView['CreateView4']);
end;

procedure TFBSQLParserTest.CreateView5;
begin
  DoTestSQL(FBTestSQLData.sView['CreateView5']);
end;

procedure TFBSQLParserTest.AlterView;
begin
  DoTestSQL(FBTestSQLData.sView['AlterView1']);
end;

procedure TFBSQLParserTest.CreateOrAlterView;
begin
  DoTestSQL(FBTestSQLData.sView['CreateOrAlterView1']);
end;

procedure TFBSQLParserTest.DropView1;
begin
  DoTestSQL(FBTestSQLData.sView['DropView1']);
end;

procedure TFBSQLParserTest.DropView2;
begin
  DoTestSQL(FBTestSQLData.sView['DropView2']);
end;

procedure TFBSQLParserTest.RecreateView1;
begin
  DoTestSQL(FBTestSQLData.sView['RecreateView1']);
end;

procedure TFBSQLParserTest.RecreateView2;
begin
  DoTestSQL(FBTestSQLData.sView['RecreateView2']);
end;

procedure TFBSQLParserTest.CreateTrigger1;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreateTrigger1']);
end;

procedure TFBSQLParserTest.CreateTrigger2;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreateTrigger2']);
end;

procedure TFBSQLParserTest.CreateTrigger3;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreateTrigger3']);
end;

procedure TFBSQLParserTest.CreateTrigger4;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreateTrigger4']);
end;

procedure TFBSQLParserTest.CreateTrigger5;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreateTrigger5']);
end;

procedure TFBSQLParserTest.CreateTrigger6;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreateTrigger6']);
end;

procedure TFBSQLParserTest.CreateTrigger7;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreateTrigger7']);
end;

procedure TFBSQLParserTest.CreateTrigger8;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreateTrigger8']);
end;

procedure TFBSQLParserTest.CreateTrigger9;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreateTrigger9']);
end;

procedure TFBSQLParserTest.AlterTrigger1;
begin
  DoTestSQL(FBTestSQLData.sProcedure['AlterTrigger1']);
end;

procedure TFBSQLParserTest.AlterTrigger2;
begin
  DoTestSQL(FBTestSQLData.sProcedure['AlterTrigger2']);
end;

procedure TFBSQLParserTest.AlterTrigger3;
begin
  DoTestSQL(FBTestSQLData.sProcedure['AlterTrigger3']);
end;

procedure TFBSQLParserTest.AlterTrigger4;
begin
  DoTestSQL(FBTestSQLData.sProcedure['AlterTrigger4']);
end;

procedure TFBSQLParserTest.CreateOrAlterTrigger;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreateTrigger1']);
end;

procedure TFBSQLParserTest.DropTrigger;
begin
  DoTestSQL(FBTestSQLData.sProcedure['DropTrigger1']);
end;

procedure TFBSQLParserTest.RecreateTrigger;
begin
  DoTestSQL(FBTestSQLData.sProcedure['RecreateTrigger1']);
end;

procedure TFBSQLParserTest.CreateProcedure1;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreateProcedure1']);
end;

procedure TFBSQLParserTest.CreateProcedure2;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreateProcedure2']);
end;

procedure TFBSQLParserTest.AlterProcedure;
begin
  DoTestSQL(FBTestSQLData.sProcedure['AlterProcedure1']);
end;

procedure TFBSQLParserTest.CreateOrAlterProcedure;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreateOrAlterProcedure1']);
end;

procedure TFBSQLParserTest.DropProcedure;
begin
  DoTestSQL(FBTestSQLData.sProcedure['DropProcedure1']);
end;

procedure TFBSQLParserTest.RecreateProcedure;
begin
  DoTestSQL(FBTestSQLData.sProcedure['RecreateProcedure1']);
end;

procedure TFBSQLParserTest.CreateFunction1;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreateFunction1']);
end;

procedure TFBSQLParserTest.CreateFunction2;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreateFunction2']);
end;

procedure TFBSQLParserTest.CreateFunction3;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreateFunction3']);
end;

procedure TFBSQLParserTest.CreateFunction4;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreateFunction4']);
end;

procedure TFBSQLParserTest.CreateFunction5;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreateFunction5']);
end;

procedure TFBSQLParserTest.CreateFunction6;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreateFunction6']);
end;

procedure TFBSQLParserTest.AlterFunction;
begin
  DoTestSQL(FBTestSQLData.sProcedure['AlterFunction1']);
end;

procedure TFBSQLParserTest.CreateOrAlterFunction;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreateOrAlterFunction1']);
end;

procedure TFBSQLParserTest.DropFunction;
begin
  DoTestSQL(FBTestSQLData.sProcedure['DropFunction1']);
end;

procedure TFBSQLParserTest.RecreateFunction;
begin
  DoTestSQL(FBTestSQLData.sProcedure['RecreateFunction1']);
end;

procedure TFBSQLParserTest.CreatePackage;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreatePackage1']);
end;

procedure TFBSQLParserTest.AlterPackage;
begin
  DoTestSQL(FBTestSQLData.sProcedure['AlterPackage1']);
end;

procedure TFBSQLParserTest.CreateOrAlterPackage;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreateOrAlterPackage1']);
end;

procedure TFBSQLParserTest.DropPackage;
begin
  DoTestSQL(FBTestSQLData.sProcedure['DropPackage1']);
end;

procedure TFBSQLParserTest.RecreatePackage;
begin
  DoTestSQL(FBTestSQLData.sProcedure['RecreatePackage1']);
end;

procedure TFBSQLParserTest.CreatePackageBody;
begin
  DoTestSQL(FBTestSQLData.sProcedure['CreatePackageBody1']);
end;

procedure TFBSQLParserTest.AlterPackageBody;
begin
  DoTestSQL(FBTestSQLData.sProcedure['AlterPackageBody1']);
end;

procedure TFBSQLParserTest.DropPackageBody;
begin
  DoTestSQL(FBTestSQLData.sProcedure['DropPackageBody1']);
end;

procedure TFBSQLParserTest.RecreatePackageBody;
begin
  DoTestSQL(FBTestSQLData.sProcedure['RecreatePackageBody1']);
end;

procedure TFBSQLParserTest.CreateSequence1;
begin
  DoTestSQL(FBTestSQLData.sGenerator['CreateSequence1']);
end;

procedure TFBSQLParserTest.CreateSequence2;
begin
  DoTestSQL(FBTestSQLData.sGenerator['CreateSequence2']);
end;

procedure TFBSQLParserTest.CreateSequence3;
begin
  DoTestSQL(FBTestSQLData.sGenerator['CreateSequence3']);
end;

procedure TFBSQLParserTest.CreateSequence4;
begin
  DoTestSQL(FBTestSQLData.sGenerator['CreateSequence4']);
end;

procedure TFBSQLParserTest.AlterSequence1;
begin
  DoTestSQL(FBTestSQLData.sGenerator['AlterSequence1']);
end;

procedure TFBSQLParserTest.AlterSequence2;
begin
  DoTestSQL(FBTestSQLData.sGenerator['AlterSequence2']);
end;

procedure TFBSQLParserTest.AlterSequence3;
begin
  DoTestSQL(FBTestSQLData.sGenerator['AlterSequence3']);
end;

procedure TFBSQLParserTest.CreateOrAlterSequence;
begin
  DoTestSQL(FBTestSQLData.sGenerator['CreateOrAlterSequence1']);
end;

procedure TFBSQLParserTest.DropSequence;
begin
  DoTestSQL(FBTestSQLData.sGenerator['DropSequence1']);
end;

procedure TFBSQLParserTest.RecreateSequence;
begin
  DoTestSQL(FBTestSQLData.sGenerator['RecreateSequence1']);
end;

procedure TFBSQLParserTest.SetGenerator;
begin
  DoTestSQL(FBTestSQLData.sGenerator['SetGenerator1']);
end;

procedure TFBSQLParserTest.DeclareExternalFunction1;
begin
  DoTestSQL(FBTestSQLData.sProcedure['DeclareExternalFunction1']);
end;

procedure TFBSQLParserTest.DeclareExternalFunction2;
begin
  DoTestSQL(FBTestSQLData.sProcedure['DeclareExternalFunction2']);
end;

procedure TFBSQLParserTest.DeclareExternalFunction3;
begin
  DoTestSQL(FBTestSQLData.sProcedure['DeclareExternalFunction3']);
end;

procedure TFBSQLParserTest.DeclareExternalFunction4;
begin
  DoTestSQL(FBTestSQLData.sProcedure['DeclareExternalFunction4']);
end;

procedure TFBSQLParserTest.AlterExternalFunction1;
begin
  DoTestSQL(FBTestSQLData.sProcedure['AlterExternalFunction1']);
end;

procedure TFBSQLParserTest.AlterExternalFunction2;
begin
  DoTestSQL(FBTestSQLData.sProcedure['AlterExternalFunction2']);
end;

procedure TFBSQLParserTest.DropExternalFunction;
begin
  DoTestSQL(FBTestSQLData.sProcedure['DropExternalFunction1']);
end;

procedure TFBSQLParserTest.CreateException1;
begin
  DoTestSQL(FBTestSQLData.sException['CreateException1']);
end;

procedure TFBSQLParserTest.CreateException2;
begin
  DoTestSQL(FBTestSQLData.sException['CreateException2']);
end;

procedure TFBSQLParserTest.CreateException3;
begin
  DoTestSQL(FBTestSQLData.sException['CreateException3']);
end;

procedure TFBSQLParserTest.AlterException1;
begin
  DoTestSQL(FBTestSQLData.sException['AlterException1']);
end;

procedure TFBSQLParserTest.AlterException2;
begin
  DoTestSQL(FBTestSQLData.sException['AlterException2']);
end;

procedure TFBSQLParserTest.CreateOrAlterException1;
begin
  DoTestSQL(FBTestSQLData.sException['CreateOrAlterException1']);
end;

procedure TFBSQLParserTest.CreateOrAlterException2;
begin
  DoTestSQL(FBTestSQLData.sException['CreateOrAlterException2']);
end;

procedure TFBSQLParserTest.DropException1;
begin
  DoTestSQL(FBTestSQLData.sException['DropException1']);
end;

procedure TFBSQLParserTest.DropException2;
begin
  DoTestSQL(FBTestSQLData.sException['DropException2']);
end;

procedure TFBSQLParserTest.RecreateException;
begin
  DoTestSQL(FBTestSQLData.sException['RecreateException']);
end;

procedure TFBSQLParserTest.CreateRole;
begin
  DoTestSQL(FBTestSQLData.sUsers['CreateRole1']);
end;

procedure TFBSQLParserTest.AlterRole1;
begin
  DoTestSQL(FBTestSQLData.sUsers['AlterRole1']);
end;

procedure TFBSQLParserTest.AlterRole2;
begin
  DoTestSQL(FBTestSQLData.sUsers['AlterRole2']);
end;

procedure TFBSQLParserTest.DropRole;
begin
  DoTestSQL(FBTestSQLData.sUsers['DropRole1']);
end;

procedure TFBSQLParserTest.DeclareFilter1;
begin
  DoTestSQL(FBTestSQLData.sDataBase['DeclareFilter1']);
end;

procedure TFBSQLParserTest.DeclareFilter2;
begin
  DoTestSQL(FBTestSQLData.sDataBase['DeclareFilter2']);
end;

procedure TFBSQLParserTest.DropFilter;
begin
  DoTestSQL(FBTestSQLData.sDataBase['DropFilter1']);
end;

procedure TFBSQLParserTest.CreateCollation1;
begin
  DoTestSQL(FBTestSQLData.sDataBase['CreateCollation1']);
end;

procedure TFBSQLParserTest.CreateCollation2;
begin
  DoTestSQL(FBTestSQLData.sDataBase['CreateCollation2']);
end;

procedure TFBSQLParserTest.CreateCollation3;
begin
  DoTestSQL(FBTestSQLData.sDataBase['CreateCollation3']);
end;

procedure TFBSQLParserTest.CreateCollation4;
begin
  DoTestSQL(FBTestSQLData.sDataBase['CreateCollation4']);
end;

procedure TFBSQLParserTest.CreateCollation5;
begin
  DoTestSQL(FBTestSQLData.sDataBase['CreateCollation5']);
end;

procedure TFBSQLParserTest.DropCollation;
begin
  DoTestSQL(FBTestSQLData.sDataBase['DropCollation1']);
end;

procedure TFBSQLParserTest.AlterCharacterSet;
begin
  DoTestSQL(FBTestSQLData.sDataBase['AlterCharacterSet1']);
end;

procedure TFBSQLParserTest.CommentOn1;
begin
  DoTestSQL(FBTestSQLData.sComment['CommentOn1']);
end;

procedure TFBSQLParserTest.CommentOn2;
begin
  DoTestSQL(FBTestSQLData.sComment['CommentOn2']);
end;

procedure TFBSQLParserTest.CommentOn3;
begin
  DoTestSQL(FBTestSQLData.sComment['CommentOn3']);
end;

procedure TFBSQLParserTest.CommentOn4;
begin
  DoTestSQL(FBTestSQLData.sComment['CommentOn4']);
end;

procedure TFBSQLParserTest.CommentOn5;
begin
  DoTestSQL(FBTestSQLData.sComment['CommentOn5']);
end;

procedure TFBSQLParserTest.CommentOn6;
begin
  DoTestSQL(FBTestSQLData.sComment['CommentOn6']);
end;

procedure TFBSQLParserTest.CommentOn7;
begin
  DoTestSQL(FBTestSQLData.sComment['CommentOn7']);
end;

procedure TFBSQLParserTest.CommentOn8;
begin
  DoTestSQL(FBTestSQLData.sComment['CommentOn8']);
end;

procedure TFBSQLParserTest.Transaction1;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Transaction1']);
end;

procedure TFBSQLParserTest.Transaction2;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Transaction2']);
end;

procedure TFBSQLParserTest.Transaction3;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Transaction3']);
end;

procedure TFBSQLParserTest.Transaction4;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Transaction4']);
end;

procedure TFBSQLParserTest.Transaction5;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Transaction5']);
end;

procedure TFBSQLParserTest.Transaction6;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Transaction6']);
end;

procedure TFBSQLParserTest.Transaction7;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Transaction7']);
end;

procedure TFBSQLParserTest.Transaction8;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Transaction8']);
end;

procedure TFBSQLParserTest.Transaction9;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Transaction9']);
end;

procedure TFBSQLParserTest.Transaction10;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Transaction10']);
end;

procedure TFBSQLParserTest.Transaction11;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Transaction11']);
end;

procedure TFBSQLParserTest.Rollback1;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Rollback1']);
end;

procedure TFBSQLParserTest.Rollback2;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Rollback2']);
end;

procedure TFBSQLParserTest.Rollback3;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Rollback3']);
end;

procedure TFBSQLParserTest.Rollback4;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Rollback4']);
end;

procedure TFBSQLParserTest.Rollback5;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Rollback5']);
end;

procedure TFBSQLParserTest.Rollback6;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Rollback6']);
end;

procedure TFBSQLParserTest.Rollback7;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Rollback7']);
end;

procedure TFBSQLParserTest.Rollback8;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Rollback8']);
end;

procedure TFBSQLParserTest.Savepoint1;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Savepoint1']);
end;

procedure TFBSQLParserTest.Savepoint2;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Savepoint2']);
end;

procedure TFBSQLParserTest.Savepoint3;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Savepoint3']);
end;

procedure TFBSQLParserTest.Commit1;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Commit1']);
end;

procedure TFBSQLParserTest.Commit2;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Commit2']);
end;

procedure TFBSQLParserTest.Commit3;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Commit3']);
end;

procedure TFBSQLParserTest.Commit4;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Commit4']);
end;

procedure TFBSQLParserTest.Commit5;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Commit5']);
end;

procedure TFBSQLParserTest.Commit6;
begin
  DoTestSQL(FBTestSQLData.sTransaction['Commit6']);
end;

procedure TFBSQLParserTest.SetUp;
begin
  FBTestSQLData:=TFBTestSQLData.Create(CustomApplication);
  FB:=TSQLEngineFireBird.Create;
end;

procedure TFBSQLParserTest.TearDown;
begin
  FB.Free;
end;

function TFBSQLParserTest.GetNextSQLCmd(ASql: string): TSQLCommandAbstract;
begin
  Result:=GetNextSQLCommand(ASql, FB, true);
end;

procedure TFBSQLParserTest.DoTestSQL(ASql: string);
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

  RegisterTest(TFBSQLParserTest);
end.

