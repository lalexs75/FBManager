unit MSSQLParserTestCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, mssql_engine,
  fbmSqlParserUnit, RxTextHolder;

type

  { TMSSQLParserTest }

  TMSSQLParserTest= class(TTestCase)
  private
    FMSSQLEngine:TMSSQLEngine;
  protected
    procedure SetUp; override;
    procedure TearDown; override;

    function GetNextSQLCmd(ASql: string): TSQLCommandAbstract;
    procedure DoTestSQL(ASql: string);
  published
    procedure DisableTrigger1;
    procedure DisableTrigger2;
    procedure DisableTrigger3;
    procedure DisableTrigger4;
    procedure DisableTrigger5;
    procedure EnableTrigger1;
    procedure EnableTrigger2;
    procedure EnableTrigger3;
    procedure DropTrigger1;
    procedure DropTrigger2;
    procedure DropTrigger3;
    procedure DropTrigger4;
    procedure DropTrigger5;
    procedure CreateTrigger1;
    procedure CreateTrigger2;
    procedure CreateTrigger3;
    procedure CreateTrigger4;
    procedure CreateTrigger5;
    procedure CreateTrigger6;
    procedure CreateTrigger7;
    procedure CreateTrigger8;
    procedure CreateTrigger9;
    procedure CreateTrigger10;
    procedure AlterTrigger1;

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
    procedure CreateDatabase12;
    procedure CreateDatabase13;
    procedure CreateDatabase14;
    procedure CreateDatabase15;
    procedure CreateDatabase16;
    procedure CreateDatabase17;
    procedure CreateDatabase18;
    procedure CreateDatabase19;
    procedure CreateDatabase20;
    procedure CreateDatabase21;
    procedure CreateDatabase22;
    procedure CreateDatabase23;
    procedure CreateDatabase24;
    procedure CreateDatabase25;
    procedure CreateDatabase26;
    procedure CreateDatabase27;
    procedure CreateDatabase28;
    procedure CreateDatabase29;
    procedure CreateDatabase30;
    procedure CreateDatabase31;

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
    procedure AlterDatabase12;
    procedure AlterDatabase13;
    procedure AlterDatabase14;
    procedure AlterDatabase15;
    procedure AlterDatabase16;
    procedure AlterDatabase17;
    procedure AlterDatabase18;
    procedure AlterDatabase19;
    procedure AlterDatabase20;
    procedure AlterDatabase21;
    procedure AlterDatabase22;
    procedure AlterDatabase23;
    procedure AlterDatabase24;
    procedure AlterDatabase25;
    procedure AlterDatabase26;
    procedure AlterDatabase27;
    procedure AlterDatabase28;
    procedure AlterDatabase29;
    procedure AlterDatabase30;
    procedure AlterDatabase31;
    procedure AlterDatabase32;
    procedure AlterDatabase33;
    procedure AlterDatabase34;
    procedure AlterDatabase35;
    procedure AlterDatabase36;
    procedure AlterDatabase37;
    procedure AlterDatabase38;
    procedure AlterDatabase39;
    procedure AlterDatabase40;
    procedure AlterDatabase41;
    procedure AlterDatabase42;
    procedure AlterDatabase43;
    procedure AlterDatabase44;
    procedure AlterDatabase45;
    procedure AlterDatabase46;
    procedure AlterDatabase47;
    procedure AlterDatabase48;
    procedure AlterDatabase49;
    procedure AlterDatabase50;
    procedure AlterDatabase51;
    procedure AlterDatabase52;
    procedure AlterDatabase53;
    procedure AlterDatabase54;
    procedure AlterDatabase55;
    procedure AlterDatabase56;
    procedure AlterDatabase57;
    procedure AlterDatabase58;
    procedure AlterDatabase59;
    procedure AlterDatabase60;
    procedure DropDatabase1;

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
    procedure CreateTable20;
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
    procedure CreateTable31;
    procedure CreateTable32;
    procedure CreateTable33;
    procedure CreateTable34;
    procedure CreateTable35;
    procedure CreateTable36;
    procedure CreateTable37;
    procedure CreateTable38;
    procedure CreateTable39;
    procedure CreateTable40;
    procedure CreateTable41;
    procedure CreateTable42;
    procedure CreateTable43;
    procedure CreateTable44;
    procedure CreateTable45;
    procedure CreateTable46;
    procedure CreateTable47;
    procedure CreateTable48;
    procedure CreateTable49;
    procedure CreateTable50;
    procedure CreateTable51;
    procedure CreateTable52;
    procedure CreateTable53;
    procedure CreateTable54;
    procedure CreateTable55;
    procedure CreateTable56;
    procedure CreateTable57;
    procedure CreateTable58;
    procedure CreateTable59;
    procedure CreateTable60;
    procedure CreateTable61;
    procedure CreateTable62;
    procedure CreateTable63;
    procedure CreateTable64;
    procedure CreateTable65;
    procedure CreateTable66;
    procedure CreateTable67;
    procedure CreateTable68;
    procedure CreateTable69;
    procedure CreateTable70;
    procedure CreateTable71;
    procedure CreateTable72;
    procedure CreateTable73;
    procedure CreateTable74;
    procedure CreateTable75;
    procedure CreateTable76;
    procedure CreateTable77;
    procedure CreateTable78;
    procedure CreateTable79;
    procedure CreateTable80;
    procedure CreateTable81;
    procedure CreateTable82;
    procedure CreateTable83;
    procedure CreateTable84;
    procedure CreateTable85;
    procedure CreateTable86;
    procedure CreateTable87;
    procedure CreateTable88;
    procedure CreateTable89;
    procedure CreateTable90;
    procedure CreateTable91;
    procedure CreateTable92;
    procedure CreateTable93;
    procedure CreateTable94;
    procedure CreateTable95;
    procedure CreateTable96;

    procedure Select1;
    procedure Select2;
    procedure Select3;
    procedure Select4;
    procedure Select5;
    procedure Select6;
    procedure Select7;
    procedure Select8;
    procedure Select9;
    procedure Select10;
  end;

  { TMSSQLParserTestData }

  TMSSQLParserTestData = class(TDataModule)
    sSequence: TRxTextHolder;
    sSecurity: TRxTextHolder;
    sSystem: TRxTextHolder;
    sViews: TRxTextHolder;
    sFunctions: TRxTextHolder;
    sDML: TRxTextHolder;
    sTable: TRxTextHolder;
    sDataBase: TRxTextHolder;
    sTriggers: TRxTextHolder;
  public
  end;

var
  MSSQLParserTestData: TMSSQLParserTestData = nil;
implementation
uses CustApp;
{$R *.lfm}

procedure TMSSQLParserTest.DropTrigger1;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['DropTrigger1']);
end;

procedure TMSSQLParserTest.DropTrigger2;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['DropTrigger2']);
end;

procedure TMSSQLParserTest.DropTrigger3;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['DropTrigger3']);
end;

procedure TMSSQLParserTest.DropTrigger4;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['DropTrigger4']);
end;

procedure TMSSQLParserTest.DropTrigger5;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['DropTrigger5']);
end;

procedure TMSSQLParserTest.CreateTrigger1;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['CreateTrigger1']);
end;

procedure TMSSQLParserTest.CreateTrigger2;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['CreateTrigger2']);
end;

procedure TMSSQLParserTest.CreateTrigger3;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['CreateTrigger3']);
end;

procedure TMSSQLParserTest.CreateTrigger4;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['CreateTrigger4']);
end;

procedure TMSSQLParserTest.CreateTrigger5;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['CreateTrigger5']);
end;

procedure TMSSQLParserTest.CreateTrigger6;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['CreateTrigger6']);
end;

procedure TMSSQLParserTest.CreateTrigger7;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['CreateTrigger7']);
end;

procedure TMSSQLParserTest.CreateTrigger8;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['CreateTrigger8']);
end;

procedure TMSSQLParserTest.CreateTrigger9;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['CreateTrigger9']);
end;

procedure TMSSQLParserTest.CreateTrigger10;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['CreateTrigger10']);
end;

procedure TMSSQLParserTest.AlterTrigger1;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['AlterTrigger1']);
end;

procedure TMSSQLParserTest.CreateDatabase1;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase1']);
end;

procedure TMSSQLParserTest.CreateDatabase2;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase2']);
end;

procedure TMSSQLParserTest.CreateDatabase3;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase3']);
end;

procedure TMSSQLParserTest.CreateDatabase4;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase4']);
end;

procedure TMSSQLParserTest.CreateDatabase5;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase5']);
end;

procedure TMSSQLParserTest.CreateDatabase6;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase6']);
end;

procedure TMSSQLParserTest.CreateDatabase7;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase7']);
end;

procedure TMSSQLParserTest.CreateDatabase8;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase8']);
end;

procedure TMSSQLParserTest.CreateDatabase9;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase9']);
end;

procedure TMSSQLParserTest.CreateDatabase10;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase10']);
end;

procedure TMSSQLParserTest.CreateDatabase11;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase11']);
end;

procedure TMSSQLParserTest.CreateDatabase12;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase12']);
end;

procedure TMSSQLParserTest.CreateDatabase13;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase13']);
end;

procedure TMSSQLParserTest.CreateDatabase14;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase14']);
end;

procedure TMSSQLParserTest.CreateDatabase15;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase15']);
end;

procedure TMSSQLParserTest.CreateDatabase16;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase16']);
end;

procedure TMSSQLParserTest.CreateDatabase17;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase17']);
end;

procedure TMSSQLParserTest.CreateDatabase18;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase18']);
end;

procedure TMSSQLParserTest.CreateDatabase19;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase19']);
end;

procedure TMSSQLParserTest.CreateDatabase20;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase20']);
end;

procedure TMSSQLParserTest.CreateDatabase21;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase21']);
end;

procedure TMSSQLParserTest.CreateDatabase22;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase22']);
end;

procedure TMSSQLParserTest.CreateDatabase23;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase23']);
end;

procedure TMSSQLParserTest.CreateDatabase24;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase24']);
end;

procedure TMSSQLParserTest.CreateDatabase25;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase25']);
end;

procedure TMSSQLParserTest.CreateDatabase26;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase26']);
end;

procedure TMSSQLParserTest.CreateDatabase27;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase27']);
end;

procedure TMSSQLParserTest.CreateDatabase28;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase28']);
end;

procedure TMSSQLParserTest.CreateDatabase29;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase29']);
end;

procedure TMSSQLParserTest.CreateDatabase30;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase30']);
end;

procedure TMSSQLParserTest.CreateDatabase31;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateDatabase31']);
end;

procedure TMSSQLParserTest.AlterDatabase1;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase1']);
end;

procedure TMSSQLParserTest.AlterDatabase2;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase2']);
end;

procedure TMSSQLParserTest.AlterDatabase3;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase3']);
end;

procedure TMSSQLParserTest.AlterDatabase4;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase4']);
end;

procedure TMSSQLParserTest.AlterDatabase5;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase5']);
end;

procedure TMSSQLParserTest.AlterDatabase6;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase6']);
end;

procedure TMSSQLParserTest.AlterDatabase7;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase7']);
end;

procedure TMSSQLParserTest.AlterDatabase8;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase8']);
end;

procedure TMSSQLParserTest.AlterDatabase9;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase9']);
end;

procedure TMSSQLParserTest.AlterDatabase10;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase10']);
end;

procedure TMSSQLParserTest.AlterDatabase11;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase11']);
end;

procedure TMSSQLParserTest.AlterDatabase12;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase12']);
end;

procedure TMSSQLParserTest.AlterDatabase13;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase13']);
end;

procedure TMSSQLParserTest.AlterDatabase14;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase14']);
end;

procedure TMSSQLParserTest.AlterDatabase15;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase15']);
end;

procedure TMSSQLParserTest.AlterDatabase16;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase16']);
end;

procedure TMSSQLParserTest.AlterDatabase17;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase17']);
end;

procedure TMSSQLParserTest.AlterDatabase18;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase18']);
end;

procedure TMSSQLParserTest.AlterDatabase19;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase19']);
end;

procedure TMSSQLParserTest.AlterDatabase20;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase20']);
end;

procedure TMSSQLParserTest.AlterDatabase21;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase21']);
end;

procedure TMSSQLParserTest.AlterDatabase22;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase22']);
end;

procedure TMSSQLParserTest.AlterDatabase23;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase23']);
end;

procedure TMSSQLParserTest.AlterDatabase24;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase24']);
end;

procedure TMSSQLParserTest.AlterDatabase25;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase25']);
end;

procedure TMSSQLParserTest.AlterDatabase26;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase26']);
end;

procedure TMSSQLParserTest.AlterDatabase27;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase27']);
end;

procedure TMSSQLParserTest.AlterDatabase28;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase28']);
end;

procedure TMSSQLParserTest.AlterDatabase29;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase29']);
end;

procedure TMSSQLParserTest.AlterDatabase30;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase30']);
end;

procedure TMSSQLParserTest.AlterDatabase31;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase31']);
end;

procedure TMSSQLParserTest.AlterDatabase32;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase32']);
end;

procedure TMSSQLParserTest.AlterDatabase33;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase33']);
end;

procedure TMSSQLParserTest.AlterDatabase34;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase34']);
end;

procedure TMSSQLParserTest.AlterDatabase35;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase35']);
end;

procedure TMSSQLParserTest.AlterDatabase36;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase36']);
end;

procedure TMSSQLParserTest.AlterDatabase37;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase37']);
end;

procedure TMSSQLParserTest.AlterDatabase38;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase38']);
end;

procedure TMSSQLParserTest.AlterDatabase39;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase39']);
end;

procedure TMSSQLParserTest.AlterDatabase40;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase40']);
end;

procedure TMSSQLParserTest.AlterDatabase41;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase41']);
end;

procedure TMSSQLParserTest.AlterDatabase42;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase42']);
end;

procedure TMSSQLParserTest.AlterDatabase43;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase43']);
end;

procedure TMSSQLParserTest.AlterDatabase44;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase44']);
end;

procedure TMSSQLParserTest.AlterDatabase45;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase45']);
end;

procedure TMSSQLParserTest.AlterDatabase46;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase46']);
end;

procedure TMSSQLParserTest.AlterDatabase47;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase47']);
end;

procedure TMSSQLParserTest.AlterDatabase48;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase48']);
end;

procedure TMSSQLParserTest.AlterDatabase49;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase49']);
end;

procedure TMSSQLParserTest.AlterDatabase50;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase50']);
end;

procedure TMSSQLParserTest.AlterDatabase51;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase51']);
end;

procedure TMSSQLParserTest.AlterDatabase52;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase52']);
end;

procedure TMSSQLParserTest.AlterDatabase53;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase53']);
end;

procedure TMSSQLParserTest.AlterDatabase54;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase54']);
end;

procedure TMSSQLParserTest.AlterDatabase55;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase55']);
end;

procedure TMSSQLParserTest.AlterDatabase56;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase56']);
end;

procedure TMSSQLParserTest.AlterDatabase57;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase57']);
end;

procedure TMSSQLParserTest.AlterDatabase58;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase58']);
end;

procedure TMSSQLParserTest.AlterDatabase59;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase59']);
end;

procedure TMSSQLParserTest.AlterDatabase60;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterDatabase60']);
end;

procedure TMSSQLParserTest.DropDatabase1;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['DropDatabase1']);
end;

procedure TMSSQLParserTest.CreateTable1;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable1']);
end;

procedure TMSSQLParserTest.CreateTable2;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable2']);
end;

procedure TMSSQLParserTest.CreateTable3;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable3']);
end;

procedure TMSSQLParserTest.CreateTable4;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable4']);
end;

procedure TMSSQLParserTest.CreateTable5;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable5']);
end;

procedure TMSSQLParserTest.CreateTable6;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable6']);
end;

procedure TMSSQLParserTest.CreateTable7;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable7']);
end;

procedure TMSSQLParserTest.CreateTable8;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable8']);
end;

procedure TMSSQLParserTest.CreateTable9;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable9']);
end;

procedure TMSSQLParserTest.CreateTable10;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable10']);
end;

procedure TMSSQLParserTest.CreateTable11;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable11']);
end;

procedure TMSSQLParserTest.CreateTable12;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable12']);
end;

procedure TMSSQLParserTest.CreateTable13;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable13']);
end;

procedure TMSSQLParserTest.CreateTable14;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable14']);
end;

procedure TMSSQLParserTest.CreateTable15;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable15']);
end;

procedure TMSSQLParserTest.CreateTable16;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable16']);
end;

procedure TMSSQLParserTest.CreateTable17;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable17']);
end;

procedure TMSSQLParserTest.CreateTable18;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable18']);
end;

procedure TMSSQLParserTest.CreateTable19;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable19']);
end;

procedure TMSSQLParserTest.CreateTable20;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable20']);
end;

procedure TMSSQLParserTest.CreateTable21;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable21']);
end;

procedure TMSSQLParserTest.CreateTable22;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable22']);
end;

procedure TMSSQLParserTest.CreateTable23;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable23']);
end;

procedure TMSSQLParserTest.CreateTable24;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable24']);
end;

procedure TMSSQLParserTest.CreateTable25;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable25']);
end;

procedure TMSSQLParserTest.CreateTable26;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable26']);
end;

procedure TMSSQLParserTest.CreateTable27;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable27']);
end;

procedure TMSSQLParserTest.CreateTable28;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable28']);
end;

procedure TMSSQLParserTest.CreateTable29;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable29']);
end;

procedure TMSSQLParserTest.CreateTable30;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable30']);
end;

procedure TMSSQLParserTest.CreateTable31;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable31']);
end;

procedure TMSSQLParserTest.CreateTable32;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable32']);
end;

procedure TMSSQLParserTest.CreateTable33;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable33']);
end;

procedure TMSSQLParserTest.CreateTable34;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable34']);
end;

procedure TMSSQLParserTest.CreateTable35;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable35']);
end;

procedure TMSSQLParserTest.CreateTable36;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable36']);
end;

procedure TMSSQLParserTest.CreateTable37;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable37']);
end;

procedure TMSSQLParserTest.CreateTable38;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable38']);
end;

procedure TMSSQLParserTest.CreateTable39;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable39']);
end;

procedure TMSSQLParserTest.CreateTable40;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable40']);
end;

procedure TMSSQLParserTest.CreateTable41;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable41']);
end;

procedure TMSSQLParserTest.CreateTable42;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable42']);
end;

procedure TMSSQLParserTest.CreateTable43;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable43']);
end;

procedure TMSSQLParserTest.CreateTable44;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable44']);
end;

procedure TMSSQLParserTest.CreateTable45;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable45']);
end;

procedure TMSSQLParserTest.CreateTable46;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable46']);
end;

procedure TMSSQLParserTest.CreateTable47;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable47']);
end;

procedure TMSSQLParserTest.CreateTable48;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable48']);
end;

procedure TMSSQLParserTest.CreateTable49;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable49']);
end;

procedure TMSSQLParserTest.CreateTable50;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable50']);
end;

procedure TMSSQLParserTest.CreateTable51;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable51']);
end;

procedure TMSSQLParserTest.CreateTable52;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable52']);
end;

procedure TMSSQLParserTest.CreateTable53;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable53']);
end;

procedure TMSSQLParserTest.CreateTable54;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable54']);
end;

procedure TMSSQLParserTest.CreateTable55;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable55']);
end;

procedure TMSSQLParserTest.CreateTable56;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable56']);
end;

procedure TMSSQLParserTest.CreateTable57;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable57']);
end;

procedure TMSSQLParserTest.CreateTable58;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable58']);
end;

procedure TMSSQLParserTest.CreateTable59;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable59']);
end;

procedure TMSSQLParserTest.CreateTable60;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable60']);
end;

procedure TMSSQLParserTest.CreateTable61;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable61']);
end;

procedure TMSSQLParserTest.CreateTable62;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable62']);
end;

procedure TMSSQLParserTest.CreateTable63;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable63']);
end;

procedure TMSSQLParserTest.CreateTable64;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable64']);
end;

procedure TMSSQLParserTest.CreateTable65;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable65']);
end;

procedure TMSSQLParserTest.CreateTable66;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable66']);
end;

procedure TMSSQLParserTest.CreateTable67;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable67']);
end;

procedure TMSSQLParserTest.CreateTable68;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable68']);
end;

procedure TMSSQLParserTest.CreateTable69;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable69']);
end;

procedure TMSSQLParserTest.CreateTable70;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable70']);
end;

procedure TMSSQLParserTest.CreateTable71;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable71']);
end;

procedure TMSSQLParserTest.CreateTable72;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable72']);
end;

procedure TMSSQLParserTest.CreateTable73;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable73']);
end;

procedure TMSSQLParserTest.CreateTable74;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable74']);
end;

procedure TMSSQLParserTest.CreateTable75;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable75']);
end;

procedure TMSSQLParserTest.CreateTable76;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable76']);
end;

procedure TMSSQLParserTest.CreateTable77;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable77']);
end;

procedure TMSSQLParserTest.CreateTable78;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable78']);
end;

procedure TMSSQLParserTest.CreateTable79;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable79']);
end;

procedure TMSSQLParserTest.CreateTable80;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable80']);
end;

procedure TMSSQLParserTest.CreateTable81;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable81']);
end;

procedure TMSSQLParserTest.CreateTable82;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable82']);
end;

procedure TMSSQLParserTest.CreateTable83;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable83']);
end;

procedure TMSSQLParserTest.CreateTable84;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable84']);
end;

procedure TMSSQLParserTest.CreateTable85;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable85']);
end;

procedure TMSSQLParserTest.CreateTable86;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable86']);
end;

procedure TMSSQLParserTest.CreateTable87;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable87']);
end;

procedure TMSSQLParserTest.CreateTable88;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable88']);
end;

procedure TMSSQLParserTest.CreateTable89;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable89']);
end;

procedure TMSSQLParserTest.CreateTable90;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable90']);
end;

procedure TMSSQLParserTest.CreateTable91;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable91']);
end;

procedure TMSSQLParserTest.CreateTable92;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable92']);
end;

procedure TMSSQLParserTest.CreateTable93;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable93']);
end;

procedure TMSSQLParserTest.CreateTable94;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable94']);
end;

procedure TMSSQLParserTest.CreateTable95;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable95']);
end;

procedure TMSSQLParserTest.CreateTable96;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateTable96']);
end;

procedure TMSSQLParserTest.Select1;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select1']);
end;

procedure TMSSQLParserTest.Select2;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select2']);
end;

procedure TMSSQLParserTest.Select3;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select3']);
end;

procedure TMSSQLParserTest.Select4;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select4']);
end;

procedure TMSSQLParserTest.Select5;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select5']);
end;

procedure TMSSQLParserTest.Select6;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select6']);
end;

procedure TMSSQLParserTest.Select7;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select7']);
end;

procedure TMSSQLParserTest.Select8;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select8']);
end;

procedure TMSSQLParserTest.Select9;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select9']);
end;

procedure TMSSQLParserTest.Select10;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select10']);
end;

procedure TMSSQLParserTest.SetUp;
begin
  MSSQLParserTestData:=TMSSQLParserTestData.Create(CustomApplication);
  FMSSQLEngine:=TMSSQLEngine.Create;
end;

procedure TMSSQLParserTest.TearDown;
begin
  FreeAndNil(MSSQLParserTestData);
  FreeAndNil(FMSSQLEngine);
end;

function TMSSQLParserTest.GetNextSQLCmd(ASql: string): TSQLCommandAbstract;
begin
  Result:=GetNextSQLCommand(ASql, FMSSQLEngine, true);
end;

procedure TMSSQLParserTest.DoTestSQL(ASql: string);
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

procedure TMSSQLParserTest.DisableTrigger1;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['DisableTrigger1']);
end;

procedure TMSSQLParserTest.DisableTrigger2;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['DisableTrigger2']);
end;

procedure TMSSQLParserTest.DisableTrigger3;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['DisableTrigger3']);
end;

procedure TMSSQLParserTest.DisableTrigger4;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['DisableTrigger4']);
end;

procedure TMSSQLParserTest.DisableTrigger5;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['DisableTrigger5']);
end;

procedure TMSSQLParserTest.EnableTrigger1;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['EnableTrigger1']);
end;

procedure TMSSQLParserTest.EnableTrigger2;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['EnableTrigger2']);
end;

procedure TMSSQLParserTest.EnableTrigger3;
begin
  DoTestSQL(MSSQLParserTestData.sTriggers['EnableTrigger3']);
end;

initialization
  RegisterTest(TMSSQLParserTest);
end.

    







