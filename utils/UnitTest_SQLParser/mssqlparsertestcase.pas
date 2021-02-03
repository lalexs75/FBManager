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
    procedure DropDatabase2;
    procedure DropDatabase3;
    procedure DropDatabase4;
    procedure DropDatabase5;
    procedure DropDatabase6;
    procedure DropDatabase7;
    procedure DropDatabase8;
    procedure CreateShema1;
    procedure CreateShema2;
    procedure CreateShema3;
    procedure CreateShema4;
    procedure CreateShema5;
    procedure CreateShema6;
    procedure CreateShema7;
    procedure AlterShema1;
    procedure AlterShema2;
    procedure DropSchema1;
    procedure CreateExternalDataSource1;
    procedure CreateExternalDataSource2;
    procedure CreateExternalDataSource3;
    procedure CreateExternalDataSource4;
    procedure CreateExternalDataSource5;
    procedure CreateExternalDataSource6;
    procedure CreateExternalDataSource7;
    procedure CreateExternalDataSource8;
    procedure CreateExternalDataSource9;
    procedure CreateExternalDataSource10;
    procedure CreateExternalDataSource11;
    procedure CreateExternalDataSource12;
    procedure CreateExternalDataSource13;
    procedure CreateExternalDataSource14;
    procedure CreateExternalDataSource15;
    procedure CreateExternalDataSource16;
    procedure CreateExternalDataSource17;
    procedure AlterExternalDataSource1;
    procedure AlterExternalDataSource2;
    procedure AlterExternalDataSource3;
    procedure DropExternalDataSource1;
    procedure CreateExternalFile1;
    procedure CreateExternalFile2;
    procedure CreateExternalFile3;
    procedure CreateExternalFile4;
    procedure CreateExternalFile5;
    procedure CreateExternalFile6;
    procedure CreateExternalFile7;
    procedure CreateExternalFile8;
    procedure CreateExternalFile9;
    procedure DropExternalFile1;
    procedure CreateXmlSchemaCollection1;
    procedure CreateXmlSchemaCollection2;
    procedure CreateXmlSchemaCollection3;
    procedure CreateXmlSchemaCollection4;
    procedure CreateXmlSchemaCollection5;
    procedure CreateXmlSchemaCollection6;
    procedure CreateXmlSchemaCollection7;
    procedure CreateXmlSchemaCollection8;
    procedure DropXmlSchemaCollection1;
    procedure DropXmlSchemaCollection2;
    procedure DropXmlSchemaCollection3;
    procedure DropXmlSchemaCollection4;
    procedure DropXmlSchemaCollection5;
    procedure CreateType1;
    procedure CreateType2;
    procedure CreateType3;
    procedure CreateType4;
    procedure CreateType5;
    procedure CreateType6;
    procedure DropType1;
    procedure DropType2;
    procedure DropType3;
    procedure DropType4;
    procedure DropType5;
    procedure PartitionScheme1;
    procedure PartitionScheme2;
    procedure PartitionScheme3;
    procedure PartitionScheme4;
    procedure PartitionScheme5;

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
    procedure CreateExternalTable1;
    procedure CreateExternalTable2;
    procedure CreateExternalTable3;
    procedure CreateExternalTable4;
    procedure CreateExternalTable5;
    procedure CreateExternalTable6;
    procedure CreateExternalTable7;
    procedure CreateExternalTable8;
    procedure CreateExternalTable9;
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
    procedure AlterTable36;
    procedure AlterTable37;
    procedure AlterTable38;
    procedure AlterTable39;
    procedure AlterTable40;
    procedure AlterTable41;
    procedure AlterTable42;
    procedure AlterTable43;
    procedure AlterTable44;
    procedure AlterTable45;
    procedure AlterTable46;
    procedure AlterTable47;
    procedure AlterTable48;
    procedure AlterTable49;
    procedure AlterTable50;
    procedure AlterTable51;
    procedure AlterTable52;
    procedure AlterTable53;
    procedure AlterTable54;
    procedure AlterTable55;
    procedure AlterTable56;
    procedure AlterTable57;
    procedure AlterTable58;
    procedure AlterTable59;
    procedure DropTable1;
    procedure DropTable2;
    procedure DropTable3;
    procedure DropTable4;
    procedure DropTable5;
    procedure DropTable6;
    procedure DropTable7;
    procedure DropTable8;
    procedure DropTable9;
    procedure DropTable10;
    procedure DropTable11;
    procedure DropTable12;
    procedure DropTable13;
    procedure DropTable14;
    procedure DropTable15;
    procedure TruncateTable1;
    procedure TruncateTable2;
    procedure CreateIndex1;
    procedure CreateIndex2;
    procedure CreateIndex3;
    procedure CreateIndex4;
    procedure CreateIndex5;
    procedure CreateIndex6;
    procedure CreateIndex7;
    procedure CreateIndex8;
    procedure CreateIndex9;
    procedure CreateIndex10;
    procedure CreateIndex11;
    procedure CreateIndex12;
    procedure CreateIndex13;
    procedure CreateIndex14;
    procedure CreateIndex15;
    procedure CreateIndex16;
    procedure CreateIndex17;
    procedure CreateIndex18;
    procedure CreateIndex19;
    procedure CreateIndex20;
    procedure CreateIndex21;
    procedure CreateIndex22;
    procedure CreateIndex23;
    procedure CreateIndex24;
    procedure CreateIndex25;
    procedure CreateIndex26;
    procedure CreateIndex27;
    procedure AlterIndex1;
    procedure AlterIndex2;
    procedure AlterIndex3;
    procedure AlterIndex4;
    procedure AlterIndex5;
    procedure AlterIndex6;
    procedure AlterIndex7;
    procedure AlterIndex8;
    procedure AlterIndex9;
    procedure AlterIndex10;
    procedure AlterIndex11;
    procedure AlterIndex12;
    procedure AlterIndex13;
    procedure AlterIndex14;
    procedure AlterIndex15;
    procedure AlterIndex16;
    procedure AlterIndex17;
    procedure AlterIndex18;
    procedure AlterIndex19;
    procedure AlterIndex20;
    procedure AlterIndex21;
    procedure AlterIndex22;
    procedure AlterIndex23;
    procedure AlterIndex24;
    procedure AlterIndex25;
    procedure AlterIndex26;
    procedure AlterIndex27;
    procedure AlterIndex28;
    procedure AlterIndex29;
    procedure AlterIndex30;
    procedure AlterIndex31;
    procedure AlterIndex32;
    procedure AlterIndex33;
    procedure AlterIndex34;
    procedure AlterIndex35;
    procedure AlterIndex36;
    procedure AlterIndex37;
    procedure AlterIndex38;
    procedure CreateIndex28;
    procedure CreateIndex29;
    procedure CreateIndex30;
    procedure CreateIndex31;
    procedure CreateIndex32;
    procedure CreateIndex33;
    procedure CreateIndex34;
    procedure CreateIndex35;
    procedure CreateIndex36;
    procedure CreateIndex37;
    procedure CreateIndex38;
    procedure CreateIndex39;
    procedure CreateIndex40;
    procedure CreateIndex41;
    procedure CreateIndex42;
    procedure CreateIndex43;
    procedure CreateIndex44;
    procedure CreateIndex45;
    procedure CreateIndex46;
    procedure CreateIndex47;
    procedure CreateIndex48;
    procedure CreateIndex49;
    procedure CreateIndex50;
    procedure CreateIndex51;
    procedure CreateIndex52;
    procedure CreateIndex53;
    procedure CreateIndex54;
    procedure AlterIndex39;
    procedure AlterIndex40;
    procedure AlterIndex41;
    procedure AlterIndex42;
    procedure AlterIndex43;
    procedure AlterIndex44;
    procedure AlterIndex45;
    procedure AlterIndex46;
    procedure AlterIndex47;
    procedure AlterIndex48;
    procedure CreateIndex55;
    procedure CreateIndex56;
    procedure CreateIndex57;
    procedure CreateIndex58;
    procedure CreateIndex59;
    procedure CreateIndex60;
    procedure CreateIndex61;
    procedure DropIndex1;
    procedure DropIndex2;
    procedure DropIndex3;
    procedure DropIndex4;
    procedure DropIndex5;
    procedure DropIndex6;
    procedure DropIndex7;
    procedure DropIndex8;
    procedure DropIndex9;
    procedure DropIndex10;
    procedure DropIndex11;
    procedure DropIndex12;
    procedure DropIndex13;
    procedure DropIndex14;
    procedure DropIndex15;
    procedure DropIndex16;
    procedure DropTable16;
    procedure DropTable17;
    procedure DropTable18;
    procedure DropTable19;
    procedure DropTable20;

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
    procedure Select11;
    procedure Select12;
    procedure Select13;
    procedure Select14;
    procedure Select15;
    procedure Select16;
    procedure Select17;
    procedure Select18;
    procedure Select19;
    procedure Select20;
    procedure Select21;
    procedure Select22;
    procedure Select23;
    procedure Select24;
    procedure Select25;
    procedure Select26;
    procedure Select27;
    procedure Select28;
    procedure Select29;
    procedure Select30;
    procedure Select31;
    procedure Select32;
    procedure Select33;
    procedure Select34;
    procedure Select35;
    procedure Select36;
    procedure Select37;
    procedure Select38;
    procedure Select39;
    procedure Select40;
    procedure Select41;
    procedure Select42;
    procedure Select43;
    procedure Select44;
    procedure Select45;
    procedure Select46;
    procedure Select47;
    procedure Select48;
    procedure Select49;
    procedure Select50;
    procedure Select51;
    procedure Select52;
    procedure Select53;
    procedure Select54;
    procedure Select55;
    procedure Select56;
    procedure Select57;
    procedure Select58;
    procedure BulkInsert1;
    procedure BulkInsert2;
    procedure BulkInsert3;
    procedure Delete1;
    procedure Delete2;
    procedure Delete3;
    procedure Delete4;
    procedure Delete5;
    procedure Delete6;
    procedure Delete7;
    procedure Delete8;
    procedure Delete9;
    procedure Delete10;
    procedure Delete11;
    procedure Delete12;
    procedure Delete13;
    procedure Delete14;
    procedure Insert1;
    procedure Insert2;
    procedure Insert3;
    procedure Insert4;
    procedure Insert5;
    procedure Insert6;
    procedure Insert7;
    procedure Insert8;
    procedure Insert9;
    procedure Insert10;
    procedure Insert11;
    procedure Insert12;
    procedure Insert13;
    procedure Insert14;
    procedure Insert15;
    procedure Insert16;
    procedure Insert17;
    procedure Insert18;
    procedure Insert19;
    procedure Insert20;
    procedure Insert21;
    procedure Insert22;
    procedure Insert23;
    procedure Insert24;
    procedure Insert25;
    procedure Insert26;
    procedure Insert27;
    procedure Insert28;
    procedure Insert29;
    procedure Insert30;
    procedure Insert31;
    procedure Insert32;
    procedure Insert33;
    procedure Insert34;
    procedure Insert35;
    procedure Insert36;
    procedure Insert37;
    procedure Insert38;
    procedure Insert39;
    procedure Insert40;
    procedure Insert41;
    procedure Insert42;
    procedure Insert43;
    procedure Insert44;
    procedure Insert45;
    procedure Insert46;
    procedure Insert47;
    procedure Insert48;
    procedure Insert49;
    procedure Insert50;
    procedure Insert51;
    procedure Insert52;
    procedure Insert53;
    procedure Insert54;
    procedure Insert55;
    procedure Insert56;
    procedure Insert57;
    procedure Insert58;
    procedure Insert59;
    procedure Update1;
    procedure Update2;
    procedure Update3;
    procedure Update4;
    procedure Update5;
    procedure Update6;
    procedure Update7;
    procedure Update8;
    procedure Update9;
    procedure Update10;
    procedure Update11;
    procedure Merge1;
    procedure Declare1;
    procedure Declare2;
    procedure Declare3;
    procedure Declare4;
    procedure Declare5;
    procedure Declare6;
    procedure Declare7;
    procedure Declare8;
    procedure Declare9;
    procedure Declare10;
    procedure Declare11;
    procedure Declare12;
    procedure Declare13;
    procedure Declare14;
    procedure Declare15;
    procedure Declare16;
    procedure Declare17;
    procedure Declare18;
    procedure Declare19;
    procedure Declare20;
    procedure Declare21;
    procedure Declare22;
    procedure Declare23;
    procedure Declare24;
    procedure Declare25;
    procedure Declare26;
    procedure Declare27;
    procedure Declare28;
    procedure Declare29;
    procedure Declare30;
    procedure Declare31;
    procedure Declare32;
    procedure Declare33;

    procedure CreateProcedure1;
    procedure CreateProcedure2;
    procedure CreateProcedure3;
    procedure CreateProcedure4;
    procedure CreateProcedure5;
    procedure CreateProcedure6;
    procedure CreateProcedure7;
    procedure CreateProcedure8;
    procedure CreateProcedure9;
    procedure CreateProcedure10;
    procedure CreateProcedure11;
    procedure CreateProcedure12;
    procedure CreateProcedure13;
    procedure CreateProcedure14;
    procedure CreateProcedure15;
    procedure CreateProcedure16;
    procedure CreateProcedure17;
    procedure CreateProcedure18;
    procedure CreateProcedure19;
    procedure CreateProcedure20;
    procedure CreateProcedure21;
    procedure CreateProcedure22;
    procedure AlterProcedure1;
    procedure AlterProcedure2;
    procedure AlterProcedure3;
    procedure AlterProcedure4;
    procedure DropProcedure1;
    procedure DropProcedure2;
    procedure DropProcedure3;
    procedure DropProcedure4;
    procedure DropProcedure5;
    procedure DropProcedure6;
    procedure DropProcedure7;
    procedure DropProcedure8;
    procedure CreateFunction1;
    procedure CreateFunction2;
    procedure CreateFunction3;
    procedure CreateFunction4;
    procedure CreateFunction5;
    procedure CreateFunction6;
    procedure DropFunction1;
    procedure PartitionFunction1;
    procedure PartitionFunction2;
    procedure PartitionFunction3;
    procedure PartitionFunction4;
    procedure PartitionFunction5;
    procedure PartitionFunction6;
    procedure PartitionFunction7;
    procedure PartitionFunction8;
    procedure PartitionFunction9;
    procedure PartitionFunction10;
    procedure PartitionFunction11;
    procedure PartitionFunction12;
    procedure PartitionFunction13;
    procedure PartitionFunction14;
    procedure PartitionFunction15;
    procedure PartitionFunction16;
    procedure PartitionFunction17;
    procedure PartitionFunction18;
    procedure PartitionFunction19;
    procedure PartitionFunction20;
    procedure CreateProcedure23;

    //sViews
    procedure CreateView1;
    procedure CreateView2;
    procedure CreateView3;
    procedure CreateView4;
    procedure CreateView5;
    procedure CreateView6;
    procedure CreateView7;
    procedure CreateView8;
    procedure CreateView9;
    procedure CreateView10;
    procedure AlterView1;
    procedure DropView1;
    procedure DropView2;

    //sSequence
    procedure CreateSequence1;
    procedure CreateSequence2;
    procedure CreateSequence3;
    procedure CreateSequence4;
    procedure CreateSequence5;
    procedure CreateSequence6;
    procedure CreateSequence7;
    procedure CreateSequence8;
    procedure CreateSequence9;
    procedure AlterSequence1;
    procedure AlterSequence2;
    procedure AlterSequence3;

    //sSecurity
    procedure Grant1;
    procedure Grant2;
    procedure Grant3;
    procedure Grant4;
    procedure Grant5;
    procedure Grant6;
    procedure Grant7;
    procedure Grant8;
    procedure Grant9;
    procedure Grant10;
    procedure Grant11;
    procedure Grant12;
    procedure Grant13;
    procedure Grant14;
    procedure Grant15;
    procedure Grant16;
    procedure Grant17;
    procedure Grant18;
    procedure Grant19;
    procedure Grant20;
    procedure Grant21;
    procedure Grant22;
    procedure Grant23;
    procedure Grant24;
    procedure Grant25;
    procedure Grant26;
    procedure Grant27;
    procedure Grant28;
    procedure Grant29;
    procedure Grant30;
    procedure Grant31;
    procedure Grant32;
    procedure Grant33;
    procedure Grant34;
    procedure Grant35;
    procedure Grant36;
    procedure Grant37;
    procedure Grant38;
    procedure Grant39;
    procedure Grant40;
    procedure Grant41;
    procedure Grant42;
    procedure Grant43;
    procedure Grant44;
    procedure Grant45;
    procedure Grant46;
    procedure Grant47;
    procedure Grant48;
    procedure Grant49;
    procedure Grant50;
    procedure Revoke1;
    procedure Revoke2;
    procedure Revoke3;
    procedure Revoke4;
    procedure Revoke5;
    procedure Revoke6;
    procedure Revoke7;
    procedure Revoke8;
    procedure Revoke9;
    procedure Revoke10;
    procedure Revoke11;
    procedure Revoke12;
    procedure Revoke13;
    procedure Revoke14;
    procedure Revoke15;
    procedure Revoke16;
    procedure Revoke17;
    procedure Revoke18;
    procedure Revoke19;
    procedure Revoke20;
    procedure Revoke21;
    procedure Revoke22;
    procedure AlterAuthorization1;
    procedure AlterAuthorization2;
    procedure AlterAuthorization3;
    procedure AlterAuthorization4;
    procedure AlterAuthorization5;
    procedure AlterAuthorization6;
    procedure AlterAuthorization7;
    procedure AlterAuthorization8;
    procedure AlterAuthorization9;
    procedure AlterAuthorization10;
    procedure AlterAuthorization11;
    procedure AlterAuthorization12;
    procedure AlterAuthorization13;
    procedure CreateRole1;
    procedure CreateRole2;
    procedure CreateRole3;
    procedure CreateRole4;
    procedure CreateRole5;
    procedure DropRole1;
    procedure CreateRole6;
    procedure CreateRole7;
    procedure CreateRole8;
    procedure CreateRole9;
    procedure CreateRole10;
    procedure CreateRole11;
    procedure CreateRole12;
    procedure DropRole2;
    procedure CreateLogin1;
    procedure CreateLogin2;
    procedure CreateLogin3;
    procedure CreateLogin4;
    procedure CreateLogin5;
    procedure CreateLogin6;
    procedure CreateLogin7;
    procedure CreateLogin8;
    procedure CreateLogin9;
    procedure CreateLogin10;
    procedure CreateLogin11;
    procedure CreateLogin12;
    procedure CreateLogin13;
    procedure CreateLogin14;
    procedure CreateLogin15;
    procedure CreateLogin16;
    procedure AlterLogin1;
    procedure AlterLogin2;
    procedure AlterLogin3;
    procedure AlterLogin4;
    procedure AlterLogin5;
    procedure AlterLogin6;
    procedure AlterLogin7;
    procedure AlterLogin8;
    procedure AlterLogin9;
    procedure AlterLogin10;
    procedure AlterLogin11;
    procedure DropLogin1;
    procedure DropLogin2;
    procedure DropLogin3;
    procedure DropLogin4;
    procedure DropLogin5;
    procedure DropLogin6;
    procedure DropLogin7;
    procedure CreateUser1;
    procedure CreateUser2;
    procedure CreateUser3;
    procedure CreateUser4;
    procedure CreateUser5;
    procedure CreateUser6;
    procedure CreateUser7;
    procedure CreateUser8;
    procedure CreateUser9;
    procedure CreateUser10;
    procedure CreateUser11;
    procedure CreateUser12;
    procedure CreateUser13;
    procedure AlterUser1;
    procedure AlterUser2;
    procedure AlterUser3;
    procedure DropUser1;
    procedure DropUser2;
    procedure DropUser3;
    procedure DropUser4;
    procedure Deny1;
    procedure Deny2;
    procedure Deny3;
    procedure Deny4;
    procedure Deny5;
    procedure Deny6;
    procedure Deny7;
    procedure Deny8;
    procedure Deny9;
    procedure Deny10;
    procedure Deny11;
    procedure Deny12;
    procedure Deny13;
    procedure Deny14;
    procedure Deny15;
    procedure Deny16;
    procedure Deny17;
    procedure Deny18;
    procedure Deny19;
    procedure Deny20;
    procedure Deny21;
    procedure Deny22;
    procedure Authorization1;

    //sSystem
    procedure CreateServer1;
    procedure CreateServer2;
    procedure CreateServer3;
    procedure CreateServer4;
    procedure CreateServer5;
    procedure CreateServer6;
    procedure CreateServer7;
    procedure CreateServer8;
    procedure CreateServer9;
    procedure CreateServer10;
    procedure CreateServer11;
    procedure AlterServer1;
    procedure AlterServer2;
    procedure AlterServer3;
    procedure AlterServer4;
    procedure AlterServer5;
    procedure AlterServer6;
    procedure AlterServer7;
    procedure AlterServer8;
    procedure AlterServer9;
    procedure AlterServer10;
    procedure AlterServer11;
    procedure AlterServer12;
    procedure AlterServer13;
    procedure AlterServer14;
    procedure AlterServer15;
    procedure AlterServer16;
    procedure AlterServer17;
    procedure AlterServer18;
    procedure AlterServer19;
    procedure AlterServer20;
    procedure AlterServer21;
    procedure AlterServer22;
    procedure AlterServer23;
    procedure AlterServer24;
    procedure AlterServer25;
    procedure AlterServer26;
    procedure AlterServer27;
    procedure AlterServer28;
    procedure AlterServer29;
    procedure AlterServer30;
    procedure AlterServer31;
    procedure AlterServer32;
    procedure AlterServer33;
    procedure AlterServer34;
    procedure AlterServer35;
    procedure AlterServer36;
    procedure AlterServer37;
    procedure AlterServer38;
    procedure AlterServer39;
    procedure AlterServer40;
    procedure AlterServer41;
    procedure AlterServer42;
    procedure AlterServer43;
    procedure AlterServer44;
    procedure AlterServer45;
    procedure AlterServer46;
    procedure AlterServer47;
    procedure AlterServer48;
    procedure DropServer1;
    procedure DropServer2;
    procedure DropServer3;
    procedure Open1;
    procedure Open2;
    procedure Fetch1;
    procedure Fetch2;
    procedure Go1;
    procedure Exec1;
    procedure Exec2;
    procedure Exec3;
    procedure Deallocate1;
    procedure Close1;
    procedure CreateStatistic1;
    procedure CreateStatistic2;
    procedure CreateStatistic3;
    procedure CreateStatistic4;
    procedure CreateStatistic5;
    procedure CreateStatistic6;
    procedure CreateStatistic7;
    procedure CreateStatistic8;
    procedure CreateStatistic9;
    procedure CreateStatistic10;
    procedure CreateStatistic11;
    procedure CreateStatistic12;
    procedure CreateStatistic13;
    procedure UpdateStatistic1;
    procedure DropStatistic1;
    procedure CreateAssembly1;
    procedure CreateAssembly2;
    procedure CreateAssembly3;
    procedure CreateAssembly4;
    procedure CreateAssembly5;
    procedure CreateAssembly6;
    procedure CreateAssembly7;
    procedure AlterAssembly1;
    procedure AlterAssembly2;
    procedure AlterAssembly3;
    procedure DropAssembly1;
    procedure AddClassification1;
    procedure AddClassification2;
    procedure DropClassification1;
    procedure DropClassification2;
    procedure CreateAsymmetricKey1;
    procedure CreateAsymmetricKey2;
    procedure CreateAsymmetricKey3;
    procedure AlterAsymmetricKey1;
    procedure AlterAsymmetricKey2;
    procedure AlterAsymmetricKey3;
    procedure DropAsymmetricKey1;
    procedure CreateCertificate1;
    procedure CreateCertificate2;
    procedure CreateCertificate3;
    procedure CreateCertificate4;
    procedure CreateCertificate5;
    procedure CreateCertificate6;
    procedure CreateCertificate7;
    procedure CreateCertificate8;
    procedure CreateCertificate9;
    procedure AlterCertificate1;
    procedure AlterCertificate2;
    procedure AlterCertificate3;
    procedure AlterCertificate4;
    procedure DropCertificate1;
    procedure DropCertificate2;
    procedure CreateAvailabilityGroup1;
    procedure AlterAvailabilityGroup1;
    procedure AlterAvailabilityGroup2;
    procedure AlterAvailabilityGroup3;
    procedure CreateBrokerPriority1;
    procedure CreateBrokerPriority2;
    procedure CreateBrokerPriority3;
    procedure CreateBrokerPriority4;
    procedure CreateBrokerPriority5;
    procedure CreateBrokerPriority6;
    procedure CreateBrokerPriority7;
    procedure CreateBrokerPriority8;
    procedure CreateBrokerPriority9;
    procedure CreateBrokerPriority10;
    procedure CreateBrokerPriority11;
    procedure CreateBrokerPriority12;
    procedure CreateBrokerPriority13;
    procedure CreateBrokerPriority14;
    procedure CreateBrokerPriority15;
    procedure AlterBrokerPriority1;
    procedure DropBrokerPriority1;
    procedure Set1;
    procedure Set2;
    procedure Set3;
    procedure Set4;
    procedure Set5;
    procedure Set6;
    procedure Set7;
    procedure Set8;
    procedure Set9;
    procedure Set10;
    procedure Set11;
    procedure Set12;
    procedure Set13;
    procedure Set14;
    procedure Set15;
    procedure Set16;
    procedure Set17;
    procedure Set18;
    procedure Set19;
    procedure Set20;
    procedure CreateColumnEncryptionKey1;
    procedure CreateColumnEncryptionKey2;
    procedure AlterColumnEncryptionKey1;
    procedure AlterColumnEncryptionKey2;
    procedure DropColumnEncryptionKey1;
    procedure CreateCredential1;
    procedure CreateCredential2;
    procedure CreateCredential3;
    procedure CreateCredential4;
    procedure CreateCredential5;
    procedure CreateCredential6;
    procedure AlterCredential1;
    procedure DropCredential1;
    procedure CreateCryptographicProvider1;
    procedure AlterCryptographicProvider1;
    procedure AlterCryptographicProvider2;
    procedure AlterCryptographicProvider3;
    procedure AlterCryptographicProvider4;
    procedure DropCryptographicProvider1;
    procedure AlterEventSession1;
    procedure AlterEventSession2;
    procedure DropEventSession1;
    procedure CreateExternalLanguage1;
    procedure CreateExternalLanguage2;
    procedure CreateExternalLanguage3;
    procedure AlterExternalLanguage1;
    procedure DropExternalLanguage1;
    procedure CreateExternalLibrary1;
    procedure CreateExternalLibrary2;
    procedure CreateExternalLibrary3;
    procedure CreateExternalLibrary4;
    procedure CreateExternalLibrary5;
    procedure CreateExternalLibrary6;
    procedure CreateExternalLibrary7;
    procedure CreateExternalLibrary8;
    procedure AlterExternalLibrary1;
    procedure AlterExternalLibrary2;
    procedure DropExternalLibrary1;
    procedure CreateExternalResource1;
    procedure AlterExternalResource1;
    procedure DropExternalResource1;
    procedure CreateFulltextCatalog1;
    procedure CreateFulltextCatalog2;
    procedure CreateFulltextCatalog3;
    procedure AlterFulltextCatalog1;
    procedure DropFulltextCatalog1;
    procedure MasterKey1;
    procedure MasterKey2;
    procedure MasterKey3;
    procedure MasterKey4;
    procedure MasterKey5;
    procedure MasterKey6;
    procedure MasterKey7;
    procedure MasterKey8;
    procedure MasterKey9;
    procedure MasterKey10;
    procedure MasterKey11;
    procedure MasterKey12;
    procedure MasterKey13;
    procedure MasterKey14;
    procedure MasterKey15;
    procedure MasterKey16;
    procedure MasterKey17;
    procedure MasterKey18;
    procedure MasterKey19;
    procedure MasterKey20;
    procedure MasterKey21;
    procedure MasterKey22;
    procedure MasterKey23;
    procedure MasterKey24;
    procedure MasterKey25;
    procedure MasterKey26;
    procedure MasterKey27;
    procedure MasterKey28;
    procedure MasterKey29;
    procedure Route1;
    procedure Route2;
    procedure Route3;
    procedure Route4;
    procedure Route5;
    procedure Route6;
    procedure Route7;
    procedure Route8;
    procedure Route9;
    procedure Route10;
    procedure Route11;
    procedure Route12;
    procedure Route13;
    procedure Route14;
    procedure StopList1;
    procedure StopList2;
    procedure StopList3;
    procedure StopList4;
    procedure StopList5;
    procedure StopList6;
    procedure Queue1;
    procedure Queue2;
    procedure Queue3;
    procedure Queue4;
    procedure Queue5;
    procedure Queue6;
    procedure Queue7;
    procedure Queue8;
    procedure Queue9;
    procedure Queue10;
    procedure Queue11;
    procedure Queue12;
    procedure Queue13;
    procedure Queue14;
    procedure Queue15;
    procedure Queue16;
    procedure Resource1;
    procedure Resource2;
    procedure Resource3;
    procedure Resource4;
    procedure Resource5;
    procedure Resource6;
    procedure Resource7;
    procedure Resource8;
    procedure Resource9;
    procedure Resource10;
    procedure Resource11;
    procedure Resource12;
    procedure Resource13;
    procedure Resource14;
    procedure Resource15;
    procedure Resource16;
    procedure Resource17;
    procedure Resource18;
    procedure SecurityPolicy1;
    procedure SecurityPolicy2;
    procedure SecurityPolicy3;
    procedure SecurityPolicy4;
    procedure SecurityPolicy5;
    procedure SecurityPolicy6;
    procedure SecurityPolicy7;
    procedure SecurityPolicy8;
    procedure SymmetricKey1;
    procedure SymmetricKey2;
    procedure SymmetricKey3;
    procedure SymmetricKey4;
    procedure SymmetricKey5;
    procedure SymmetricKey6;
    procedure SymmetricKey7;
    procedure SymmetricKey8;
    procedure SymmetricKey9;
    procedure SymmetricKey10;
    procedure SymmetricKey11;
    procedure SymmetricKey12;
    procedure SymmetricKey13;
    procedure SymmetricKey14;
    procedure SymmetricKey15;
    procedure PropertyList1;
    procedure PropertyList2;
    procedure PropertyList3;
    procedure PropertyList4;
    procedure PropertyList5;
    procedure PropertyList6;
    procedure PropertyList7;
    procedure Service1;
    procedure Service2;
    procedure Service3;
    procedure Service4;
    procedure Service5;
    procedure Service6;
    procedure Service7;
    procedure Service8;
    procedure Service9;
    procedure Service10;
    procedure Service11;
    procedure Service12;
    procedure WorkloadGroup1;
    procedure WorkloadGroup2;
    procedure WorkloadGroup3;
    procedure WorkloadGroup4;
    procedure WorkloadGroup5;
    procedure WorkloadGroup6;
    procedure BackupRestore1;
    procedure BackupRestore2;
    procedure BackupRestore3;
    procedure BackupRestore4;
    procedure BackupRestore5;
    procedure BackupRestore6;
    procedure BackupRestore7;
    procedure BackupRestore8;
    procedure BackupRestore9;
    procedure BackupRestore10;
    procedure BackupRestore11;
    procedure BackupRestore12;
    procedure BackupRestore13;
    procedure BackupRestore14;
    procedure BackupRestore15;
    procedure BackupRestore16;
    procedure BackupRestore17;
    procedure BackupRestore18;
    procedure BackupRestore19;
    procedure BackupRestore20;
    procedure BackupRestore21;
    procedure BackupRestore22;
    procedure BackupRestore23;
    procedure BackupRestore24;
    procedure BackupRestore25;
    procedure BackupRestore26;
    procedure BackupRestore27;
    procedure BackupRestore28;
    procedure BackupRestore29;
    procedure BackupRestore30;
    procedure BackupRestore31;
    procedure BackupRestore32;
    procedure BackupRestore33;
    procedure BackupRestore34;
    procedure BackupRestore35;
    procedure BackupRestore36;
    procedure BackupRestore37;
    procedure BackupRestore38;
    procedure Event1;
    procedure Event2;
    procedure Event3;
    procedure Event4;
    procedure Signature1;
    procedure Signature2;
    procedure Signature3;
    procedure Signature4;
    procedure Signature5;
    procedure Signature6;
    procedure Signature7;
    procedure Revert1;
    procedure Synonym1;
    procedure Synonym2;
    procedure Synonym3;
    procedure Synonym4;
    procedure Synonym5;
    procedure Reconfigure1;
    procedure Rebuild1;
    procedure Rebuild2;
    procedure MessageType1;
    procedure MessageType2;
    procedure MessageType3;
    procedure MessageType4;
    procedure MessageType5;
    procedure MessageType6;
    procedure MessageType7;
    procedure MessageType8;
    procedure Filter1;
    procedure Transaction1;
    procedure Transaction2;
    procedure Default1;
    procedure Default2;
    procedure Default3;
    procedure Default4;
    procedure Aggregate1;
    procedure Aggregate2;
    procedure Contract1;
    procedure Contract2;
    procedure Endpoint1;
    procedure Endpoint2;
    procedure Endpoint3;
    procedure Endpoint4;
    procedure Rule1;
    procedure Rule2;
    procedure Rule3;
    procedure Rule4;
    procedure DBCC1;
    procedure MessageType9;
    procedure Setuser1;
    procedure DropSecurityPolicy1;
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

procedure TMSSQLParserTest.DropDatabase2;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['DropDatabase2']);
end;

procedure TMSSQLParserTest.DropDatabase3;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['DropDatabase3']);
end;

procedure TMSSQLParserTest.DropDatabase4;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['DropDatabase4']);
end;

procedure TMSSQLParserTest.DropDatabase5;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['DropDatabase5']);
end;

procedure TMSSQLParserTest.DropDatabase6;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['DropDatabase6']);
end;

procedure TMSSQLParserTest.DropDatabase7;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['DropDatabase7']);
end;

procedure TMSSQLParserTest.DropDatabase8;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['DropDatabase8']);
end;

procedure TMSSQLParserTest.CreateShema1;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateShema1']);
end;

procedure TMSSQLParserTest.CreateShema2;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateShema2']);
end;

procedure TMSSQLParserTest.CreateShema3;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateShema3']);
end;

procedure TMSSQLParserTest.CreateShema4;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateShema4']);
end;

procedure TMSSQLParserTest.CreateShema5;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateShema5']);
end;

procedure TMSSQLParserTest.CreateShema6;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateShema6']);
end;

procedure TMSSQLParserTest.CreateShema7;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateShema7']);
end;

procedure TMSSQLParserTest.AlterShema1;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterShema1']);
end;

procedure TMSSQLParserTest.AlterShema2;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterShema2']);
end;

procedure TMSSQLParserTest.DropSchema1;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['DropSchema1']);
end;

procedure TMSSQLParserTest.CreateExternalDataSource1;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalDataSource1']);
end;

procedure TMSSQLParserTest.CreateExternalDataSource2;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalDataSource2']);
end;

procedure TMSSQLParserTest.CreateExternalDataSource3;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalDataSource3']);
end;

procedure TMSSQLParserTest.CreateExternalDataSource4;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalDataSource4']);
end;

procedure TMSSQLParserTest.CreateExternalDataSource5;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalDataSource5']);
end;

procedure TMSSQLParserTest.CreateExternalDataSource6;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalDataSource6']);
end;

procedure TMSSQLParserTest.CreateExternalDataSource7;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalDataSource7']);
end;

procedure TMSSQLParserTest.CreateExternalDataSource8;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalDataSource8']);
end;

procedure TMSSQLParserTest.CreateExternalDataSource9;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalDataSource9']);
end;

procedure TMSSQLParserTest.CreateExternalDataSource10;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalDataSource10']);
end;

procedure TMSSQLParserTest.CreateExternalDataSource11;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalDataSource11']);
end;

procedure TMSSQLParserTest.CreateExternalDataSource12;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalDataSource12']);
end;

procedure TMSSQLParserTest.CreateExternalDataSource13;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalDataSource13']);
end;

procedure TMSSQLParserTest.CreateExternalDataSource14;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalDataSource14']);
end;

procedure TMSSQLParserTest.CreateExternalDataSource15;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalDataSource15']);
end;

procedure TMSSQLParserTest.CreateExternalDataSource16;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalDataSource16']);
end;

procedure TMSSQLParserTest.CreateExternalDataSource17;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalDataSource17']);
end;

procedure TMSSQLParserTest.AlterExternalDataSource1;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterExternalDataSource1']);
end;

procedure TMSSQLParserTest.AlterExternalDataSource2;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterExternalDataSource2']);
end;

procedure TMSSQLParserTest.AlterExternalDataSource3;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['AlterExternalDataSource3']);
end;

procedure TMSSQLParserTest.DropExternalDataSource1;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['DropExternalDataSource1']);
end;

procedure TMSSQLParserTest.CreateExternalFile1;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalFile1']);
end;

procedure TMSSQLParserTest.CreateExternalFile2;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalFile2']);
end;

procedure TMSSQLParserTest.CreateExternalFile3;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalFile3']);
end;

procedure TMSSQLParserTest.CreateExternalFile4;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalFile4']);
end;

procedure TMSSQLParserTest.CreateExternalFile5;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalFile5']);
end;

procedure TMSSQLParserTest.CreateExternalFile6;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalFile6']);
end;

procedure TMSSQLParserTest.CreateExternalFile7;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalFile7']);
end;

procedure TMSSQLParserTest.CreateExternalFile8;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalFile8']);
end;

procedure TMSSQLParserTest.CreateExternalFile9;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateExternalFile9']);
end;

procedure TMSSQLParserTest.DropExternalFile1;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['DropExternalFile1']);
end;

procedure TMSSQLParserTest.CreateXmlSchemaCollection1;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateXmlSchemaCollection1']);
end;

procedure TMSSQLParserTest.CreateXmlSchemaCollection2;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateXmlSchemaCollection2']);
end;

procedure TMSSQLParserTest.CreateXmlSchemaCollection3;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateXmlSchemaCollection3']);
end;

procedure TMSSQLParserTest.CreateXmlSchemaCollection4;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateXmlSchemaCollection4']);
end;

procedure TMSSQLParserTest.CreateXmlSchemaCollection5;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateXmlSchemaCollection5']);
end;

procedure TMSSQLParserTest.CreateXmlSchemaCollection6;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateXmlSchemaCollection6']);
end;

procedure TMSSQLParserTest.CreateXmlSchemaCollection7;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateXmlSchemaCollection7']);
end;

procedure TMSSQLParserTest.CreateXmlSchemaCollection8;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateXmlSchemaCollection8']);
end;

procedure TMSSQLParserTest.DropXmlSchemaCollection1;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['DropXmlSchemaCollection1']);
end;

procedure TMSSQLParserTest.DropXmlSchemaCollection2;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['DropXmlSchemaCollection2']);
end;

procedure TMSSQLParserTest.DropXmlSchemaCollection3;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['DropXmlSchemaCollection1']);
end;

procedure TMSSQLParserTest.DropXmlSchemaCollection4;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['DropXmlSchemaCollection4']);
end;

procedure TMSSQLParserTest.DropXmlSchemaCollection5;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['DropXmlSchemaCollection5']);
end;

procedure TMSSQLParserTest.CreateType1;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateType1']);
end;

procedure TMSSQLParserTest.CreateType2;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateType2']);
end;

procedure TMSSQLParserTest.CreateType3;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateType3']);
end;

procedure TMSSQLParserTest.CreateType4;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateType4']);
end;

procedure TMSSQLParserTest.CreateType5;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateType5']);
end;

procedure TMSSQLParserTest.CreateType6;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['CreateType6']);
end;

procedure TMSSQLParserTest.DropType1;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['DropType1']);
end;

procedure TMSSQLParserTest.DropType2;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['DropType2']);
end;

procedure TMSSQLParserTest.DropType3;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['DropType3']);
end;

procedure TMSSQLParserTest.DropType4;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['DropType4']);
end;

procedure TMSSQLParserTest.DropType5;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['DropType5']);
end;

procedure TMSSQLParserTest.PartitionScheme1;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['PartitionScheme1']);
end;

procedure TMSSQLParserTest.PartitionScheme2;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['PartitionScheme2']);
end;

procedure TMSSQLParserTest.PartitionScheme3;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['PartitionScheme3']);
end;

procedure TMSSQLParserTest.PartitionScheme4;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['PartitionScheme4']);
end;

procedure TMSSQLParserTest.PartitionScheme5;
begin
  DoTestSQL(MSSQLParserTestData.sDataBase['PartitionScheme5']);
end;

procedure TMSSQLParserTest.CreateTable1;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable1']);
end;

procedure TMSSQLParserTest.CreateTable2;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable2']);
end;

procedure TMSSQLParserTest.CreateTable3;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable3']);
end;

procedure TMSSQLParserTest.CreateTable4;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable4']);
end;

procedure TMSSQLParserTest.CreateTable5;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable5']);
end;

procedure TMSSQLParserTest.CreateTable6;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable6']);
end;

procedure TMSSQLParserTest.CreateTable7;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable7']);
end;

procedure TMSSQLParserTest.CreateTable8;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable8']);
end;

procedure TMSSQLParserTest.CreateTable9;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable9']);
end;

procedure TMSSQLParserTest.CreateTable10;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable10']);
end;

procedure TMSSQLParserTest.CreateTable11;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable11']);
end;

procedure TMSSQLParserTest.CreateTable12;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable12']);
end;

procedure TMSSQLParserTest.CreateTable13;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable13']);
end;

procedure TMSSQLParserTest.CreateTable14;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable14']);
end;

procedure TMSSQLParserTest.CreateTable15;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable15']);
end;

procedure TMSSQLParserTest.CreateTable16;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable16']);
end;

procedure TMSSQLParserTest.CreateTable17;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable17']);
end;

procedure TMSSQLParserTest.CreateTable18;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable18']);
end;

procedure TMSSQLParserTest.CreateTable19;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable19']);
end;

procedure TMSSQLParserTest.CreateTable20;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable20']);
end;

procedure TMSSQLParserTest.CreateTable21;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable21']);
end;

procedure TMSSQLParserTest.CreateTable22;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable22']);
end;

procedure TMSSQLParserTest.CreateTable23;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable23']);
end;

procedure TMSSQLParserTest.CreateTable24;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable24']);
end;

procedure TMSSQLParserTest.CreateTable25;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable25']);
end;

procedure TMSSQLParserTest.CreateTable26;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable26']);
end;

procedure TMSSQLParserTest.CreateTable27;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable27']);
end;

procedure TMSSQLParserTest.CreateTable28;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable28']);
end;

procedure TMSSQLParserTest.CreateTable29;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable29']);
end;

procedure TMSSQLParserTest.CreateTable30;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable30']);
end;

procedure TMSSQLParserTest.CreateTable31;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable31']);
end;

procedure TMSSQLParserTest.CreateTable32;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable32']);
end;

procedure TMSSQLParserTest.CreateTable33;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable33']);
end;

procedure TMSSQLParserTest.CreateTable34;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable34']);
end;

procedure TMSSQLParserTest.CreateTable35;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable35']);
end;

procedure TMSSQLParserTest.CreateTable36;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable36']);
end;

procedure TMSSQLParserTest.CreateTable37;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable37']);
end;

procedure TMSSQLParserTest.CreateTable38;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable38']);
end;

procedure TMSSQLParserTest.CreateTable39;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable39']);
end;

procedure TMSSQLParserTest.CreateTable40;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable40']);
end;

procedure TMSSQLParserTest.CreateTable41;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable41']);
end;

procedure TMSSQLParserTest.CreateTable42;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable42']);
end;

procedure TMSSQLParserTest.CreateTable43;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable43']);
end;

procedure TMSSQLParserTest.CreateTable44;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable44']);
end;

procedure TMSSQLParserTest.CreateTable45;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable45']);
end;

procedure TMSSQLParserTest.CreateTable46;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable46']);
end;

procedure TMSSQLParserTest.CreateTable47;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable47']);
end;

procedure TMSSQLParserTest.CreateTable48;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable48']);
end;

procedure TMSSQLParserTest.CreateTable49;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable49']);
end;

procedure TMSSQLParserTest.CreateTable50;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable50']);
end;

procedure TMSSQLParserTest.CreateTable51;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable51']);
end;

procedure TMSSQLParserTest.CreateTable52;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable52']);
end;

procedure TMSSQLParserTest.CreateTable53;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable53']);
end;

procedure TMSSQLParserTest.CreateTable54;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable54']);
end;

procedure TMSSQLParserTest.CreateTable55;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable55']);
end;

procedure TMSSQLParserTest.CreateTable56;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable56']);
end;

procedure TMSSQLParserTest.CreateTable57;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable57']);
end;

procedure TMSSQLParserTest.CreateTable58;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable58']);
end;

procedure TMSSQLParserTest.CreateTable59;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable59']);
end;

procedure TMSSQLParserTest.CreateTable60;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable60']);
end;

procedure TMSSQLParserTest.CreateTable61;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable61']);
end;

procedure TMSSQLParserTest.CreateTable62;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable62']);
end;

procedure TMSSQLParserTest.CreateTable63;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable63']);
end;

procedure TMSSQLParserTest.CreateTable64;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable64']);
end;

procedure TMSSQLParserTest.CreateTable65;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable65']);
end;

procedure TMSSQLParserTest.CreateTable66;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable66']);
end;

procedure TMSSQLParserTest.CreateTable67;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable67']);
end;

procedure TMSSQLParserTest.CreateTable68;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable68']);
end;

procedure TMSSQLParserTest.CreateTable69;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable69']);
end;

procedure TMSSQLParserTest.CreateTable70;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable70']);
end;

procedure TMSSQLParserTest.CreateTable71;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable71']);
end;

procedure TMSSQLParserTest.CreateTable72;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable72']);
end;

procedure TMSSQLParserTest.CreateTable73;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable73']);
end;

procedure TMSSQLParserTest.CreateTable74;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable74']);
end;

procedure TMSSQLParserTest.CreateTable75;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable75']);
end;

procedure TMSSQLParserTest.CreateTable76;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable76']);
end;

procedure TMSSQLParserTest.CreateTable77;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable77']);
end;

procedure TMSSQLParserTest.CreateTable78;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable78']);
end;

procedure TMSSQLParserTest.CreateTable79;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable79']);
end;

procedure TMSSQLParserTest.CreateTable80;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable80']);
end;

procedure TMSSQLParserTest.CreateTable81;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable81']);
end;

procedure TMSSQLParserTest.CreateTable82;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable82']);
end;

procedure TMSSQLParserTest.CreateTable83;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable83']);
end;

procedure TMSSQLParserTest.CreateTable84;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable84']);
end;

procedure TMSSQLParserTest.CreateTable85;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable85']);
end;

procedure TMSSQLParserTest.CreateTable86;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable86']);
end;

procedure TMSSQLParserTest.CreateTable87;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable87']);
end;

procedure TMSSQLParserTest.CreateTable88;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable88']);
end;

procedure TMSSQLParserTest.CreateTable89;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable89']);
end;

procedure TMSSQLParserTest.CreateTable90;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable90']);
end;

procedure TMSSQLParserTest.CreateTable91;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable91']);
end;

procedure TMSSQLParserTest.CreateTable92;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable92']);
end;

procedure TMSSQLParserTest.CreateTable93;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable93']);
end;

procedure TMSSQLParserTest.CreateTable94;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable94']);
end;

procedure TMSSQLParserTest.CreateTable95;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable95']);
end;

procedure TMSSQLParserTest.CreateTable96;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateTable96']);
end;

procedure TMSSQLParserTest.CreateExternalTable1;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateExternalTable1']);
end;

procedure TMSSQLParserTest.CreateExternalTable2;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateExternalTable2']);
end;

procedure TMSSQLParserTest.CreateExternalTable3;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateExternalTable3']);
end;

procedure TMSSQLParserTest.CreateExternalTable4;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateExternalTable4']);
end;

procedure TMSSQLParserTest.CreateExternalTable5;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateExternalTable5']);
end;

procedure TMSSQLParserTest.CreateExternalTable6;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateExternalTable6']);
end;

procedure TMSSQLParserTest.CreateExternalTable7;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateExternalTable7']);
end;

procedure TMSSQLParserTest.CreateExternalTable8;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateExternalTable8']);
end;

procedure TMSSQLParserTest.CreateExternalTable9;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateExternalTable9']);
end;

procedure TMSSQLParserTest.AlterTable1;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable1']);
end;

procedure TMSSQLParserTest.AlterTable2;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable2']);
end;

procedure TMSSQLParserTest.AlterTable3;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable3']);
end;

procedure TMSSQLParserTest.AlterTable4;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable4']);
end;

procedure TMSSQLParserTest.AlterTable5;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable5']);
end;

procedure TMSSQLParserTest.AlterTable6;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable6']);
end;

procedure TMSSQLParserTest.AlterTable7;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable7']);
end;

procedure TMSSQLParserTest.AlterTable8;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable8']);
end;

procedure TMSSQLParserTest.AlterTable9;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable9']);
end;

procedure TMSSQLParserTest.AlterTable10;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable10']);
end;

procedure TMSSQLParserTest.AlterTable11;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable11']);
end;

procedure TMSSQLParserTest.AlterTable12;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable12']);
end;

procedure TMSSQLParserTest.AlterTable13;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable13']);
end;

procedure TMSSQLParserTest.AlterTable14;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable14']);
end;

procedure TMSSQLParserTest.AlterTable15;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable15']);
end;

procedure TMSSQLParserTest.AlterTable16;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable16']);
end;

procedure TMSSQLParserTest.AlterTable17;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable17']);
end;

procedure TMSSQLParserTest.AlterTable18;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable18']);
end;

procedure TMSSQLParserTest.AlterTable19;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable19']);
end;

procedure TMSSQLParserTest.AlterTable20;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable20']);
end;

procedure TMSSQLParserTest.AlterTable21;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable21']);
end;

procedure TMSSQLParserTest.AlterTable22;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable22']);
end;

procedure TMSSQLParserTest.AlterTable23;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable23']);
end;

procedure TMSSQLParserTest.AlterTable24;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable24']);
end;

procedure TMSSQLParserTest.AlterTable25;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable25']);
end;

procedure TMSSQLParserTest.AlterTable26;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable26']);
end;

procedure TMSSQLParserTest.AlterTable27;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable27']);
end;

procedure TMSSQLParserTest.AlterTable28;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable28']);
end;

procedure TMSSQLParserTest.AlterTable29;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable29']);
end;

procedure TMSSQLParserTest.AlterTable30;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable30']);
end;

procedure TMSSQLParserTest.AlterTable31;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable31']);
end;

procedure TMSSQLParserTest.AlterTable32;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable32']);
end;

procedure TMSSQLParserTest.AlterTable33;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable33']);
end;

procedure TMSSQLParserTest.AlterTable34;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable34']);
end;

procedure TMSSQLParserTest.AlterTable35;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable35']);
end;

procedure TMSSQLParserTest.AlterTable36;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable36']);
end;

procedure TMSSQLParserTest.AlterTable37;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable37']);
end;

procedure TMSSQLParserTest.AlterTable38;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable38']);
end;

procedure TMSSQLParserTest.AlterTable39;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable39']);
end;

procedure TMSSQLParserTest.AlterTable40;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable40']);
end;

procedure TMSSQLParserTest.AlterTable41;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable41']);
end;

procedure TMSSQLParserTest.AlterTable42;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable42']);
end;

procedure TMSSQLParserTest.AlterTable43;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable43']);
end;

procedure TMSSQLParserTest.AlterTable44;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable44']);
end;

procedure TMSSQLParserTest.AlterTable45;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable45']);
end;

procedure TMSSQLParserTest.AlterTable46;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable46']);
end;

procedure TMSSQLParserTest.AlterTable47;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable47']);
end;

procedure TMSSQLParserTest.AlterTable48;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable48']);
end;

procedure TMSSQLParserTest.AlterTable49;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable49']);
end;

procedure TMSSQLParserTest.AlterTable50;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable50']);
end;

procedure TMSSQLParserTest.AlterTable51;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable51']);
end;

procedure TMSSQLParserTest.AlterTable52;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable52']);
end;

procedure TMSSQLParserTest.AlterTable53;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable53']);
end;

procedure TMSSQLParserTest.AlterTable54;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable54']);
end;

procedure TMSSQLParserTest.AlterTable55;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable55']);
end;

procedure TMSSQLParserTest.AlterTable56;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable56']);
end;

procedure TMSSQLParserTest.AlterTable57;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable57']);
end;

procedure TMSSQLParserTest.AlterTable58;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable58']);
end;

procedure TMSSQLParserTest.AlterTable59;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterTable59']);
end;

procedure TMSSQLParserTest.DropTable1;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropTable1']);
end;

procedure TMSSQLParserTest.DropTable2;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropTable2']);
end;

procedure TMSSQLParserTest.DropTable3;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropTable3']);
end;

procedure TMSSQLParserTest.DropTable4;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropTable4']);
end;

procedure TMSSQLParserTest.DropTable5;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropTable5']);
end;

procedure TMSSQLParserTest.DropTable6;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropTable6']);
end;

procedure TMSSQLParserTest.DropTable7;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropTable7']);
end;

procedure TMSSQLParserTest.DropTable8;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropTable8']);
end;

procedure TMSSQLParserTest.DropTable9;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropTable9']);
end;

procedure TMSSQLParserTest.DropTable10;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropTable10']);
end;

procedure TMSSQLParserTest.DropTable11;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropTable11']);
end;

procedure TMSSQLParserTest.DropTable12;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropTable12']);
end;

procedure TMSSQLParserTest.DropTable13;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropTable13']);
end;

procedure TMSSQLParserTest.DropTable14;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropTable14']);
end;

procedure TMSSQLParserTest.DropTable15;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropTable15']);
end;

procedure TMSSQLParserTest.TruncateTable1;
begin
  DoTestSQL(MSSQLParserTestData.sTable['TruncateTable1']);
end;

procedure TMSSQLParserTest.TruncateTable2;
begin
  DoTestSQL(MSSQLParserTestData.sTable['TruncateTable2']);
end;

procedure TMSSQLParserTest.CreateIndex1;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex1']);
end;

procedure TMSSQLParserTest.CreateIndex2;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex2']);
end;

procedure TMSSQLParserTest.CreateIndex3;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex3']);
end;

procedure TMSSQLParserTest.CreateIndex4;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex4']);
end;

procedure TMSSQLParserTest.CreateIndex5;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex5']);
end;

procedure TMSSQLParserTest.CreateIndex6;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex6']);
end;

procedure TMSSQLParserTest.CreateIndex7;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex7']);
end;

procedure TMSSQLParserTest.CreateIndex8;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex8']);
end;

procedure TMSSQLParserTest.CreateIndex9;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex9']);
end;

procedure TMSSQLParserTest.CreateIndex10;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex10']);
end;

procedure TMSSQLParserTest.CreateIndex11;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex11']);
end;

procedure TMSSQLParserTest.CreateIndex12;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex12']);
end;

procedure TMSSQLParserTest.CreateIndex13;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex13']);
end;

procedure TMSSQLParserTest.CreateIndex14;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex14']);
end;

procedure TMSSQLParserTest.CreateIndex15;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex15']);
end;

procedure TMSSQLParserTest.CreateIndex16;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex16']);
end;

procedure TMSSQLParserTest.CreateIndex17;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex17']);
end;

procedure TMSSQLParserTest.CreateIndex18;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex18']);
end;

procedure TMSSQLParserTest.CreateIndex19;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex19']);
end;

procedure TMSSQLParserTest.CreateIndex20;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex20']);
end;

procedure TMSSQLParserTest.CreateIndex21;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex21']);
end;

procedure TMSSQLParserTest.CreateIndex22;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex22']);
end;

procedure TMSSQLParserTest.CreateIndex23;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex23']);
end;

procedure TMSSQLParserTest.CreateIndex24;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex24']);
end;

procedure TMSSQLParserTest.CreateIndex25;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex25']);
end;

procedure TMSSQLParserTest.CreateIndex26;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex26']);
end;

procedure TMSSQLParserTest.CreateIndex27;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex27']);
end;

procedure TMSSQLParserTest.AlterIndex1;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex1']);
end;

procedure TMSSQLParserTest.AlterIndex2;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex2']);
end;

procedure TMSSQLParserTest.AlterIndex3;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex3']);
end;

procedure TMSSQLParserTest.AlterIndex4;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex4']);
end;

procedure TMSSQLParserTest.AlterIndex5;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex5']);
end;

procedure TMSSQLParserTest.AlterIndex6;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex6']);
end;

procedure TMSSQLParserTest.AlterIndex7;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex7']);
end;

procedure TMSSQLParserTest.AlterIndex8;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex8']);
end;

procedure TMSSQLParserTest.AlterIndex9;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex9']);
end;

procedure TMSSQLParserTest.AlterIndex10;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex10']);
end;

procedure TMSSQLParserTest.AlterIndex11;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex11']);
end;

procedure TMSSQLParserTest.AlterIndex12;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex12']);
end;

procedure TMSSQLParserTest.AlterIndex13;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex13']);
end;

procedure TMSSQLParserTest.AlterIndex14;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex14']);
end;

procedure TMSSQLParserTest.AlterIndex15;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex15']);
end;

procedure TMSSQLParserTest.AlterIndex16;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex16']);
end;

procedure TMSSQLParserTest.AlterIndex17;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex17']);
end;

procedure TMSSQLParserTest.AlterIndex18;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex18']);
end;

procedure TMSSQLParserTest.AlterIndex19;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex19']);
end;

procedure TMSSQLParserTest.AlterIndex20;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex20']);
end;

procedure TMSSQLParserTest.AlterIndex21;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex21']);
end;

procedure TMSSQLParserTest.AlterIndex22;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex22']);
end;

procedure TMSSQLParserTest.AlterIndex23;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex23']);
end;

procedure TMSSQLParserTest.AlterIndex24;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex24']);
end;

procedure TMSSQLParserTest.AlterIndex25;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex25']);
end;

procedure TMSSQLParserTest.AlterIndex26;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex26']);
end;

procedure TMSSQLParserTest.AlterIndex27;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex27']);
end;

procedure TMSSQLParserTest.AlterIndex28;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex28']);
end;

procedure TMSSQLParserTest.AlterIndex29;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex29']);
end;

procedure TMSSQLParserTest.AlterIndex30;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex30']);
end;

procedure TMSSQLParserTest.AlterIndex31;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex31']);
end;

procedure TMSSQLParserTest.AlterIndex32;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex32']);
end;

procedure TMSSQLParserTest.AlterIndex33;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex33']);
end;

procedure TMSSQLParserTest.AlterIndex34;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex34']);
end;

procedure TMSSQLParserTest.AlterIndex35;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex35']);
end;

procedure TMSSQLParserTest.AlterIndex36;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex36']);
end;

procedure TMSSQLParserTest.AlterIndex37;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex37']);
end;

procedure TMSSQLParserTest.AlterIndex38;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex38']);
end;

procedure TMSSQLParserTest.CreateIndex28;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex28']);
end;

procedure TMSSQLParserTest.CreateIndex29;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex29']);
end;

procedure TMSSQLParserTest.CreateIndex30;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex30']);
end;

procedure TMSSQLParserTest.CreateIndex31;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex31']);
end;

procedure TMSSQLParserTest.CreateIndex32;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex32']);
end;

procedure TMSSQLParserTest.CreateIndex33;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex33']);
end;

procedure TMSSQLParserTest.CreateIndex34;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex34']);
end;

procedure TMSSQLParserTest.CreateIndex35;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex35']);
end;

procedure TMSSQLParserTest.CreateIndex36;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex36']);
end;

procedure TMSSQLParserTest.CreateIndex37;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex37']);
end;

procedure TMSSQLParserTest.CreateIndex38;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex38']);
end;

procedure TMSSQLParserTest.CreateIndex39;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex39']);
end;

procedure TMSSQLParserTest.CreateIndex40;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex40']);
end;

procedure TMSSQLParserTest.CreateIndex41;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex41']);
end;

procedure TMSSQLParserTest.CreateIndex42;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex42']);
end;

procedure TMSSQLParserTest.CreateIndex43;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex43']);
end;

procedure TMSSQLParserTest.CreateIndex44;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex44']);
end;

procedure TMSSQLParserTest.CreateIndex45;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex45']);
end;

procedure TMSSQLParserTest.CreateIndex46;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex46']);
end;

procedure TMSSQLParserTest.CreateIndex47;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex47']);
end;

procedure TMSSQLParserTest.CreateIndex48;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex48']);
end;

procedure TMSSQLParserTest.CreateIndex49;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex49']);
end;

procedure TMSSQLParserTest.CreateIndex50;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex50']);
end;

procedure TMSSQLParserTest.CreateIndex51;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex51']);
end;

procedure TMSSQLParserTest.CreateIndex52;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex52']);
end;

procedure TMSSQLParserTest.CreateIndex53;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex53']);
end;

procedure TMSSQLParserTest.CreateIndex54;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex54']);
end;

procedure TMSSQLParserTest.AlterIndex39;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex39']);
end;

procedure TMSSQLParserTest.AlterIndex40;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex40']);
end;

procedure TMSSQLParserTest.AlterIndex41;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex41']);
end;

procedure TMSSQLParserTest.AlterIndex42;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex42']);
end;

procedure TMSSQLParserTest.AlterIndex43;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex43']);
end;

procedure TMSSQLParserTest.AlterIndex44;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex44']);
end;

procedure TMSSQLParserTest.AlterIndex45;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex45']);
end;

procedure TMSSQLParserTest.AlterIndex46;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex46']);
end;

procedure TMSSQLParserTest.AlterIndex47;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex47']);
end;

procedure TMSSQLParserTest.AlterIndex48;
begin
  DoTestSQL(MSSQLParserTestData.sTable['AlterIndex48']);
end;

procedure TMSSQLParserTest.CreateIndex55;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex55']);
end;

procedure TMSSQLParserTest.CreateIndex56;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex56']);
end;

procedure TMSSQLParserTest.CreateIndex57;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex57']);
end;

procedure TMSSQLParserTest.CreateIndex58;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex58']);
end;

procedure TMSSQLParserTest.CreateIndex59;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex59']);
end;

procedure TMSSQLParserTest.CreateIndex60;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex60']);
end;

procedure TMSSQLParserTest.CreateIndex61;
begin
  DoTestSQL(MSSQLParserTestData.sTable['CreateIndex61']);
end;

procedure TMSSQLParserTest.DropIndex1;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropIndex1']);
end;

procedure TMSSQLParserTest.DropIndex2;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropIndex2']);
end;

procedure TMSSQLParserTest.DropIndex3;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropIndex3']);
end;

procedure TMSSQLParserTest.DropIndex4;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropIndex4']);
end;

procedure TMSSQLParserTest.DropIndex5;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropIndex5']);
end;

procedure TMSSQLParserTest.DropIndex6;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropIndex6']);
end;

procedure TMSSQLParserTest.DropIndex7;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropIndex7']);
end;

procedure TMSSQLParserTest.DropIndex8;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropIndex8']);
end;

procedure TMSSQLParserTest.DropIndex9;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropIndex9']);
end;

procedure TMSSQLParserTest.DropIndex10;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropIndex10']);
end;

procedure TMSSQLParserTest.DropIndex11;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropIndex11']);
end;

procedure TMSSQLParserTest.DropIndex12;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropIndex12']);
end;

procedure TMSSQLParserTest.DropIndex13;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropIndex13']);
end;

procedure TMSSQLParserTest.DropIndex14;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropIndex14']);
end;

procedure TMSSQLParserTest.DropIndex15;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropIndex15']);
end;

procedure TMSSQLParserTest.DropIndex16;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropIndex16']);
end;

procedure TMSSQLParserTest.DropTable16;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropTable16']);
end;

procedure TMSSQLParserTest.DropTable17;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropTable17']);
end;

procedure TMSSQLParserTest.DropTable18;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropTable18']);
end;

procedure TMSSQLParserTest.DropTable19;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropTable19']);
end;

procedure TMSSQLParserTest.DropTable20;
begin
  DoTestSQL(MSSQLParserTestData.sTable['DropTable20']);
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

procedure TMSSQLParserTest.Select11;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select11']);
end;

procedure TMSSQLParserTest.Select12;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select12']);
end;

procedure TMSSQLParserTest.Select13;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select13']);
end;

procedure TMSSQLParserTest.Select14;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select14']);
end;

procedure TMSSQLParserTest.Select15;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select15']);
end;

procedure TMSSQLParserTest.Select16;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select16']);
end;

procedure TMSSQLParserTest.Select17;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select17']);
end;

procedure TMSSQLParserTest.Select18;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select18']);
end;

procedure TMSSQLParserTest.Select19;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select19']);
end;

procedure TMSSQLParserTest.Select20;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select20']);
end;

procedure TMSSQLParserTest.Select21;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select21']);
end;

procedure TMSSQLParserTest.Select22;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select22']);
end;

procedure TMSSQLParserTest.Select23;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select23']);
end;

procedure TMSSQLParserTest.Select24;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select24']);
end;

procedure TMSSQLParserTest.Select25;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select25']);
end;

procedure TMSSQLParserTest.Select26;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select26']);
end;

procedure TMSSQLParserTest.Select27;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select27']);
end;

procedure TMSSQLParserTest.Select28;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select28']);
end;

procedure TMSSQLParserTest.Select29;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select29']);
end;

procedure TMSSQLParserTest.Select30;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select30']);
end;

procedure TMSSQLParserTest.Select31;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select31']);
end;

procedure TMSSQLParserTest.Select32;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select32']);
end;

procedure TMSSQLParserTest.Select33;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select33']);
end;

procedure TMSSQLParserTest.Select34;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select34']);
end;

procedure TMSSQLParserTest.Select35;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select35']);
end;

procedure TMSSQLParserTest.Select36;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select36']);
end;

procedure TMSSQLParserTest.Select37;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select37']);
end;

procedure TMSSQLParserTest.Select38;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select38']);
end;

procedure TMSSQLParserTest.Select39;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select39']);
end;

procedure TMSSQLParserTest.Select40;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select40']);
end;

procedure TMSSQLParserTest.Select41;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select41']);
end;

procedure TMSSQLParserTest.Select42;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select42']);
end;

procedure TMSSQLParserTest.Select43;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select43']);
end;

procedure TMSSQLParserTest.Select44;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select44']);
end;

procedure TMSSQLParserTest.Select45;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select45']);
end;

procedure TMSSQLParserTest.Select46;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select46']);
end;

procedure TMSSQLParserTest.Select47;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select47']);
end;

procedure TMSSQLParserTest.Select48;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select48']);
end;

procedure TMSSQLParserTest.Select49;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select49']);
end;

procedure TMSSQLParserTest.Select50;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select50']);
end;

procedure TMSSQLParserTest.Select51;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select51']);
end;

procedure TMSSQLParserTest.Select52;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select52']);
end;

procedure TMSSQLParserTest.Select53;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select53']);
end;

procedure TMSSQLParserTest.Select54;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select54']);
end;

procedure TMSSQLParserTest.Select55;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select55']);
end;

procedure TMSSQLParserTest.Select56;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select56']);
end;

procedure TMSSQLParserTest.Select57;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select57']);
end;

procedure TMSSQLParserTest.Select58;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Select58']);
end;

procedure TMSSQLParserTest.BulkInsert1;
begin
  DoTestSQL(MSSQLParserTestData.sDML['BulkInsert1']);
end;

procedure TMSSQLParserTest.BulkInsert2;
begin
  DoTestSQL(MSSQLParserTestData.sDML['BulkInsert2']);
end;

procedure TMSSQLParserTest.BulkInsert3;
begin
  DoTestSQL(MSSQLParserTestData.sDML['BulkInsert3']);
end;

procedure TMSSQLParserTest.Delete1;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Delete1']);
end;

procedure TMSSQLParserTest.Delete2;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Delete2']);
end;

procedure TMSSQLParserTest.Delete3;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Delete3']);
end;

procedure TMSSQLParserTest.Delete4;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Delete4']);
end;

procedure TMSSQLParserTest.Delete5;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Delete5']);
end;

procedure TMSSQLParserTest.Delete6;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Delete6']);
end;

procedure TMSSQLParserTest.Delete7;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Delete7']);
end;

procedure TMSSQLParserTest.Delete8;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Delete8']);
end;

procedure TMSSQLParserTest.Delete9;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Delete9']);
end;

procedure TMSSQLParserTest.Delete10;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Delete10']);
end;

procedure TMSSQLParserTest.Delete11;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Delete11']);
end;

procedure TMSSQLParserTest.Delete12;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Delete12']);
end;

procedure TMSSQLParserTest.Delete13;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Delete13']);
end;

procedure TMSSQLParserTest.Delete14;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Delete14']);
end;

procedure TMSSQLParserTest.Insert1;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert1']);
end;

procedure TMSSQLParserTest.Insert2;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert2']);
end;

procedure TMSSQLParserTest.Insert3;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert3']);
end;

procedure TMSSQLParserTest.Insert4;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert4']);
end;

procedure TMSSQLParserTest.Insert5;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert5']);
end;

procedure TMSSQLParserTest.Insert6;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert6']);
end;

procedure TMSSQLParserTest.Insert7;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert7']);
end;

procedure TMSSQLParserTest.Insert8;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert8']);
end;

procedure TMSSQLParserTest.Insert9;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert9']);
end;

procedure TMSSQLParserTest.Insert10;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert10']);
end;

procedure TMSSQLParserTest.Insert11;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert11']);
end;

procedure TMSSQLParserTest.Insert12;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert12']);
end;

procedure TMSSQLParserTest.Insert13;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert13']);
end;

procedure TMSSQLParserTest.Insert14;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert14']);
end;

procedure TMSSQLParserTest.Insert15;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert15']);
end;

procedure TMSSQLParserTest.Insert16;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert16']);
end;

procedure TMSSQLParserTest.Insert17;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert17']);
end;

procedure TMSSQLParserTest.Insert18;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert18']);
end;

procedure TMSSQLParserTest.Insert19;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert19']);
end;

procedure TMSSQLParserTest.Insert20;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert20']);
end;

procedure TMSSQLParserTest.Insert21;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert21']);
end;

procedure TMSSQLParserTest.Insert22;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert22']);
end;

procedure TMSSQLParserTest.Insert23;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert23']);
end;

procedure TMSSQLParserTest.Insert24;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert24']);
end;

procedure TMSSQLParserTest.Insert25;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert25']);
end;

procedure TMSSQLParserTest.Insert26;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert26']);
end;

procedure TMSSQLParserTest.Insert27;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert27']);
end;

procedure TMSSQLParserTest.Insert28;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert28']);
end;

procedure TMSSQLParserTest.Insert29;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert29']);
end;

procedure TMSSQLParserTest.Insert30;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert30']);
end;

procedure TMSSQLParserTest.Insert31;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert31']);
end;

procedure TMSSQLParserTest.Insert32;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert32']);
end;

procedure TMSSQLParserTest.Insert33;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert33']);
end;

procedure TMSSQLParserTest.Insert34;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert34']);
end;

procedure TMSSQLParserTest.Insert35;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert35']);
end;

procedure TMSSQLParserTest.Insert36;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert36']);
end;

procedure TMSSQLParserTest.Insert37;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert37']);
end;

procedure TMSSQLParserTest.Insert38;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert38']);
end;

procedure TMSSQLParserTest.Insert39;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert39']);
end;

procedure TMSSQLParserTest.Insert40;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert40']);
end;

procedure TMSSQLParserTest.Insert41;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert41']);
end;

procedure TMSSQLParserTest.Insert42;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert42']);
end;

procedure TMSSQLParserTest.Insert43;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert43']);
end;

procedure TMSSQLParserTest.Insert44;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert44']);
end;

procedure TMSSQLParserTest.Insert45;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert45']);
end;

procedure TMSSQLParserTest.Insert46;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert46']);
end;

procedure TMSSQLParserTest.Insert47;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert47']);
end;

procedure TMSSQLParserTest.Insert48;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert48']);
end;

procedure TMSSQLParserTest.Insert49;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert49']);
end;

procedure TMSSQLParserTest.Insert50;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert50']);
end;

procedure TMSSQLParserTest.Insert51;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert51']);
end;

procedure TMSSQLParserTest.Insert52;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert52']);
end;

procedure TMSSQLParserTest.Insert53;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert53']);
end;

procedure TMSSQLParserTest.Insert54;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert54']);
end;

procedure TMSSQLParserTest.Insert55;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert55']);
end;

procedure TMSSQLParserTest.Insert56;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert56']);
end;

procedure TMSSQLParserTest.Insert57;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert57']);
end;

procedure TMSSQLParserTest.Insert58;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert58']);
end;

procedure TMSSQLParserTest.Insert59;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Insert59']);
end;

procedure TMSSQLParserTest.Update1;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Update1']);
end;

procedure TMSSQLParserTest.Update2;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Update2']);
end;

procedure TMSSQLParserTest.Update3;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Update3']);
end;

procedure TMSSQLParserTest.Update4;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Update4']);
end;

procedure TMSSQLParserTest.Update5;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Update5']);
end;

procedure TMSSQLParserTest.Update6;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Update6']);
end;

procedure TMSSQLParserTest.Update7;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Update7']);
end;

procedure TMSSQLParserTest.Update8;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Update8']);
end;

procedure TMSSQLParserTest.Update9;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Update9']);
end;

procedure TMSSQLParserTest.Update10;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Update10']);
end;

procedure TMSSQLParserTest.Update11;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Update11']);
end;

procedure TMSSQLParserTest.Merge1;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Merge1']);
end;

procedure TMSSQLParserTest.Declare1;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare1']);
end;

procedure TMSSQLParserTest.Declare2;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare2']);
end;

procedure TMSSQLParserTest.Declare3;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare3']);
end;

procedure TMSSQLParserTest.Declare4;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare4']);
end;

procedure TMSSQLParserTest.Declare5;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare5']);
end;

procedure TMSSQLParserTest.Declare6;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare6']);
end;

procedure TMSSQLParserTest.Declare7;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare7']);
end;

procedure TMSSQLParserTest.Declare8;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare8']);
end;

procedure TMSSQLParserTest.Declare9;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare9']);
end;

procedure TMSSQLParserTest.Declare10;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare10']);
end;

procedure TMSSQLParserTest.Declare11;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare11']);
end;

procedure TMSSQLParserTest.Declare12;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare12']);
end;

procedure TMSSQLParserTest.Declare13;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare13']);
end;

procedure TMSSQLParserTest.Declare14;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare14']);
end;

procedure TMSSQLParserTest.Declare15;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare15']);
end;

procedure TMSSQLParserTest.Declare16;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare16']);
end;

procedure TMSSQLParserTest.Declare17;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare17']);
end;

procedure TMSSQLParserTest.Declare18;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare18']);
end;

procedure TMSSQLParserTest.Declare19;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare19']);
end;

procedure TMSSQLParserTest.Declare20;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare20']);
end;

procedure TMSSQLParserTest.Declare21;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare21']);
end;

procedure TMSSQLParserTest.Declare22;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare22']);
end;

procedure TMSSQLParserTest.Declare23;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare23']);
end;

procedure TMSSQLParserTest.Declare24;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare24']);
end;

procedure TMSSQLParserTest.Declare25;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare25']);
end;

procedure TMSSQLParserTest.Declare26;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare26']);
end;

procedure TMSSQLParserTest.Declare27;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare27']);
end;

procedure TMSSQLParserTest.Declare28;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare28']);
end;

procedure TMSSQLParserTest.Declare29;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare29']);
end;

procedure TMSSQLParserTest.Declare30;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare30']);
end;

procedure TMSSQLParserTest.Declare31;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare31']);
end;

procedure TMSSQLParserTest.Declare32;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare32']);
end;

procedure TMSSQLParserTest.Declare33;
begin
  DoTestSQL(MSSQLParserTestData.sDML['Declare33']);
end;

procedure TMSSQLParserTest.CreateProcedure1;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure1']);
end;

procedure TMSSQLParserTest.CreateProcedure2;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure2']);
end;

procedure TMSSQLParserTest.CreateProcedure3;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure3']);
end;

procedure TMSSQLParserTest.CreateProcedure4;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure4']);
end;

procedure TMSSQLParserTest.CreateProcedure5;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure5']);
end;

procedure TMSSQLParserTest.CreateProcedure6;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure6']);
end;

procedure TMSSQLParserTest.CreateProcedure7;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure7']);
end;

procedure TMSSQLParserTest.CreateProcedure8;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure8']);
end;

procedure TMSSQLParserTest.CreateProcedure9;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure9']);
end;

procedure TMSSQLParserTest.CreateProcedure10;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure10']);
end;

procedure TMSSQLParserTest.CreateProcedure11;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure11']);
end;

procedure TMSSQLParserTest.CreateProcedure12;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure12']);
end;

procedure TMSSQLParserTest.CreateProcedure13;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure13']);
end;

procedure TMSSQLParserTest.CreateProcedure14;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure14']);
end;

procedure TMSSQLParserTest.CreateProcedure15;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure15']);
end;

procedure TMSSQLParserTest.CreateProcedure16;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure16']);
end;

procedure TMSSQLParserTest.CreateProcedure17;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure17']);
end;

procedure TMSSQLParserTest.CreateProcedure18;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure18']);
end;

procedure TMSSQLParserTest.CreateProcedure19;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure19']);
end;

procedure TMSSQLParserTest.CreateProcedure20;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure20']);
end;

procedure TMSSQLParserTest.CreateProcedure21;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure21']);
end;

procedure TMSSQLParserTest.CreateProcedure22;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure22']);
end;

procedure TMSSQLParserTest.AlterProcedure1;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['AlterProcedure1']);
end;

procedure TMSSQLParserTest.AlterProcedure2;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['AlterProcedure2']);
end;

procedure TMSSQLParserTest.AlterProcedure3;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['AlterProcedure3']);
end;

procedure TMSSQLParserTest.AlterProcedure4;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['AlterProcedure4']);
end;

procedure TMSSQLParserTest.DropProcedure1;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['DropProcedure1']);
end;

procedure TMSSQLParserTest.DropProcedure2;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['DropProcedure2']);
end;

procedure TMSSQLParserTest.DropProcedure3;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['DropProcedure3']);
end;

procedure TMSSQLParserTest.DropProcedure4;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['DropProcedure4']);
end;

procedure TMSSQLParserTest.DropProcedure5;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['DropProcedure5']);
end;

procedure TMSSQLParserTest.DropProcedure6;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['DropProcedure6']);
end;

procedure TMSSQLParserTest.DropProcedure7;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['DropProcedure7']);
end;

procedure TMSSQLParserTest.DropProcedure8;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['DropProcedure8']);
end;

procedure TMSSQLParserTest.CreateFunction1;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateFunction1']);
end;

procedure TMSSQLParserTest.CreateFunction2;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateFunction2']);
end;

procedure TMSSQLParserTest.CreateFunction3;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateFunction3']);
end;

procedure TMSSQLParserTest.CreateFunction4;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateFunction4']);
end;

procedure TMSSQLParserTest.CreateFunction5;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateFunction5']);
end;

procedure TMSSQLParserTest.CreateFunction6;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateFunction6']);
end;

procedure TMSSQLParserTest.DropFunction1;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['DropFunction1']);
end;

procedure TMSSQLParserTest.PartitionFunction1;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['PartitionFunction1']);
end;

procedure TMSSQLParserTest.PartitionFunction2;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['PartitionFunction2']);
end;

procedure TMSSQLParserTest.PartitionFunction3;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['PartitionFunction3']);
end;

procedure TMSSQLParserTest.PartitionFunction4;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['PartitionFunction4']);
end;

procedure TMSSQLParserTest.PartitionFunction5;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['PartitionFunction5']);
end;

procedure TMSSQLParserTest.PartitionFunction6;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['PartitionFunction6']);
end;

procedure TMSSQLParserTest.PartitionFunction7;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['PartitionFunction7']);
end;

procedure TMSSQLParserTest.PartitionFunction8;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['PartitionFunction8']);
end;

procedure TMSSQLParserTest.PartitionFunction9;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['PartitionFunction9']);
end;

procedure TMSSQLParserTest.PartitionFunction10;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['PartitionFunction10']);
end;

procedure TMSSQLParserTest.PartitionFunction11;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['PartitionFunction11']);
end;

procedure TMSSQLParserTest.PartitionFunction12;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['PartitionFunction12']);
end;

procedure TMSSQLParserTest.PartitionFunction13;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['PartitionFunction13']);
end;

procedure TMSSQLParserTest.PartitionFunction14;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['PartitionFunction14']);
end;

procedure TMSSQLParserTest.PartitionFunction15;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['PartitionFunction15']);
end;

procedure TMSSQLParserTest.PartitionFunction16;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['PartitionFunction16']);
end;

procedure TMSSQLParserTest.PartitionFunction17;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['PartitionFunction17']);
end;

procedure TMSSQLParserTest.PartitionFunction18;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['PartitionFunction18']);
end;

procedure TMSSQLParserTest.PartitionFunction19;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['PartitionFunction19']);
end;

procedure TMSSQLParserTest.PartitionFunction20;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['PartitionFunction20']);
end;

procedure TMSSQLParserTest.CreateProcedure23;
begin
  DoTestSQL(MSSQLParserTestData.sFunctions['CreateProcedure23']);
end;

procedure TMSSQLParserTest.CreateView1;
begin
  DoTestSQL(MSSQLParserTestData.sViews['CreateView1']);
end;

procedure TMSSQLParserTest.CreateView2;
begin
  DoTestSQL(MSSQLParserTestData.sViews['CreateView2']);
end;

procedure TMSSQLParserTest.CreateView3;
begin
  DoTestSQL(MSSQLParserTestData.sViews['CreateView3']);
end;

procedure TMSSQLParserTest.CreateView4;
begin
  DoTestSQL(MSSQLParserTestData.sViews['CreateView4']);
end;

procedure TMSSQLParserTest.CreateView5;
begin
  DoTestSQL(MSSQLParserTestData.sViews['CreateView5']);
end;

procedure TMSSQLParserTest.CreateView6;
begin
  DoTestSQL(MSSQLParserTestData.sViews['CreateView6']);
end;

procedure TMSSQLParserTest.CreateView7;
begin
  DoTestSQL(MSSQLParserTestData.sViews['CreateView7']);
end;

procedure TMSSQLParserTest.CreateView8;
begin
  DoTestSQL(MSSQLParserTestData.sViews['CreateView8']);
end;

procedure TMSSQLParserTest.CreateView9;
begin
  DoTestSQL(MSSQLParserTestData.sViews['CreateView9']);
end;

procedure TMSSQLParserTest.CreateView10;
begin
  DoTestSQL(MSSQLParserTestData.sViews['CreateView10']);
end;

procedure TMSSQLParserTest.AlterView1;
begin
  DoTestSQL(MSSQLParserTestData.sViews['AlterView1']);
end;

procedure TMSSQLParserTest.DropView1;
begin
  DoTestSQL(MSSQLParserTestData.sViews['DropView1']);
end;

procedure TMSSQLParserTest.DropView2;
begin
  DoTestSQL(MSSQLParserTestData.sViews['DropView2']);
end;

procedure TMSSQLParserTest.CreateSequence1;
begin
  DoTestSQL(MSSQLParserTestData.sSequence['CreateSequence1']);
end;

procedure TMSSQLParserTest.CreateSequence2;
begin
  DoTestSQL(MSSQLParserTestData.sSequence['CreateSequence2']);
end;

procedure TMSSQLParserTest.CreateSequence3;
begin
  DoTestSQL(MSSQLParserTestData.sSequence['CreateSequence3']);
end;

procedure TMSSQLParserTest.CreateSequence4;
begin
  DoTestSQL(MSSQLParserTestData.sSequence['CreateSequence4']);
end;

procedure TMSSQLParserTest.CreateSequence5;
begin
  DoTestSQL(MSSQLParserTestData.sSequence['CreateSequence5']);
end;

procedure TMSSQLParserTest.CreateSequence6;
begin
  DoTestSQL(MSSQLParserTestData.sSequence['CreateSequence6']);
end;

procedure TMSSQLParserTest.CreateSequence7;
begin
  DoTestSQL(MSSQLParserTestData.sSequence['CreateSequence7']);
end;

procedure TMSSQLParserTest.CreateSequence8;
begin
  DoTestSQL(MSSQLParserTestData.sSequence['CreateSequence8']);
end;

procedure TMSSQLParserTest.CreateSequence9;
begin
  DoTestSQL(MSSQLParserTestData.sSequence['CreateSequence9']);
end;

procedure TMSSQLParserTest.AlterSequence1;
begin
  DoTestSQL(MSSQLParserTestData.sSequence['AlterSequence1']);
end;

procedure TMSSQLParserTest.AlterSequence2;
begin
  DoTestSQL(MSSQLParserTestData.sSequence['AlterSequence2']);
end;

procedure TMSSQLParserTest.AlterSequence3;
begin
  DoTestSQL(MSSQLParserTestData.sSequence['AlterSequence3']);
end;

procedure TMSSQLParserTest.Grant1;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant1']);
end;

procedure TMSSQLParserTest.Grant2;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant3']);
end;

procedure TMSSQLParserTest.Grant3;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant3']);
end;

procedure TMSSQLParserTest.Grant4;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant4']);
end;

procedure TMSSQLParserTest.Grant5;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant5']);
end;

procedure TMSSQLParserTest.Grant6;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant6']);
end;

procedure TMSSQLParserTest.Grant7;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant7']);
end;

procedure TMSSQLParserTest.Grant8;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant8']);
end;

procedure TMSSQLParserTest.Grant9;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant9']);
end;

procedure TMSSQLParserTest.Grant10;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant10']);
end;

procedure TMSSQLParserTest.Grant11;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant11']);
end;

procedure TMSSQLParserTest.Grant12;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant12']);
end;

procedure TMSSQLParserTest.Grant13;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant13']);
end;

procedure TMSSQLParserTest.Grant14;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant14']);
end;

procedure TMSSQLParserTest.Grant15;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant15']);
end;

procedure TMSSQLParserTest.Grant16;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant16']);
end;

procedure TMSSQLParserTest.Grant17;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant17']);
end;

procedure TMSSQLParserTest.Grant18;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant18']);
end;

procedure TMSSQLParserTest.Grant19;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant19']);
end;

procedure TMSSQLParserTest.Grant20;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant20']);
end;

procedure TMSSQLParserTest.Grant21;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant21']);
end;

procedure TMSSQLParserTest.Grant22;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant22']);
end;

procedure TMSSQLParserTest.Grant23;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant23']);
end;

procedure TMSSQLParserTest.Grant24;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant24']);
end;

procedure TMSSQLParserTest.Grant25;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant25']);
end;

procedure TMSSQLParserTest.Grant26;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant26']);
end;

procedure TMSSQLParserTest.Grant27;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant27']);
end;

procedure TMSSQLParserTest.Grant28;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant28']);
end;

procedure TMSSQLParserTest.Grant29;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant29']);
end;

procedure TMSSQLParserTest.Grant30;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant30']);
end;

procedure TMSSQLParserTest.Grant31;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant31']);
end;

procedure TMSSQLParserTest.Grant32;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant32']);
end;

procedure TMSSQLParserTest.Grant33;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant33']);
end;

procedure TMSSQLParserTest.Grant34;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant34']);
end;

procedure TMSSQLParserTest.Grant35;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant35']);
end;

procedure TMSSQLParserTest.Grant36;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant36']);
end;

procedure TMSSQLParserTest.Grant37;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant37']);
end;

procedure TMSSQLParserTest.Grant38;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant38']);
end;

procedure TMSSQLParserTest.Grant39;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant39']);
end;

procedure TMSSQLParserTest.Grant40;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant40']);
end;

procedure TMSSQLParserTest.Grant41;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant41']);
end;

procedure TMSSQLParserTest.Grant42;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant42']);
end;

procedure TMSSQLParserTest.Grant43;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant43']);
end;

procedure TMSSQLParserTest.Grant44;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant44']);
end;

procedure TMSSQLParserTest.Grant45;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant45']);
end;

procedure TMSSQLParserTest.Grant46;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant46']);
end;

procedure TMSSQLParserTest.Grant47;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant47']);
end;

procedure TMSSQLParserTest.Grant48;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant48']);
end;

procedure TMSSQLParserTest.Grant49;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant49']);
end;

procedure TMSSQLParserTest.Grant50;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Grant40']);
end;

procedure TMSSQLParserTest.Revoke1;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Revoke1']);
end;

procedure TMSSQLParserTest.Revoke2;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Revoke2']);
end;

procedure TMSSQLParserTest.Revoke3;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Revoke3']);
end;

procedure TMSSQLParserTest.Revoke4;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Revoke4']);
end;

procedure TMSSQLParserTest.Revoke5;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Revoke5']);
end;

procedure TMSSQLParserTest.Revoke6;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Revoke6']);
end;

procedure TMSSQLParserTest.Revoke7;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Revoke7']);
end;

procedure TMSSQLParserTest.Revoke8;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Revoke8']);
end;

procedure TMSSQLParserTest.Revoke9;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Revoke9']);
end;

procedure TMSSQLParserTest.Revoke10;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Revoke10']);
end;

procedure TMSSQLParserTest.Revoke11;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Revoke11']);
end;

procedure TMSSQLParserTest.Revoke12;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Revoke12']);
end;

procedure TMSSQLParserTest.Revoke13;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Revoke13']);
end;

procedure TMSSQLParserTest.Revoke14;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Revoke14']);
end;

procedure TMSSQLParserTest.Revoke15;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Revoke15']);
end;

procedure TMSSQLParserTest.Revoke16;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Revoke16']);
end;

procedure TMSSQLParserTest.Revoke17;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Revoke17']);
end;

procedure TMSSQLParserTest.Revoke18;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Revoke18']);
end;

procedure TMSSQLParserTest.Revoke19;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Revoke19']);
end;

procedure TMSSQLParserTest.Revoke20;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Revoke20']);
end;

procedure TMSSQLParserTest.Revoke21;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Revoke21']);
end;

procedure TMSSQLParserTest.Revoke22;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Revoke22']);
end;

procedure TMSSQLParserTest.AlterAuthorization1;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterAuthorization1']);
end;

procedure TMSSQLParserTest.AlterAuthorization2;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterAuthorization2']);
end;

procedure TMSSQLParserTest.AlterAuthorization3;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterAuthorization3']);
end;

procedure TMSSQLParserTest.AlterAuthorization4;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterAuthorization4']);
end;

procedure TMSSQLParserTest.AlterAuthorization5;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterAuthorization5']);
end;

procedure TMSSQLParserTest.AlterAuthorization6;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterAuthorization6']);
end;

procedure TMSSQLParserTest.AlterAuthorization7;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterAuthorization7']);
end;

procedure TMSSQLParserTest.AlterAuthorization8;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterAuthorization8']);
end;

procedure TMSSQLParserTest.AlterAuthorization9;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterAuthorization9']);
end;

procedure TMSSQLParserTest.AlterAuthorization10;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterAuthorization10']);
end;

procedure TMSSQLParserTest.AlterAuthorization11;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterAuthorization11']);
end;

procedure TMSSQLParserTest.AlterAuthorization12;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterAuthorization12']);
end;

procedure TMSSQLParserTest.AlterAuthorization13;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterAuthorization13']);
end;

procedure TMSSQLParserTest.CreateRole1;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateRole1']);
end;

procedure TMSSQLParserTest.CreateRole2;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateRole2']);
end;

procedure TMSSQLParserTest.CreateRole3;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateRole3']);
end;

procedure TMSSQLParserTest.CreateRole4;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateRole4']);
end;

procedure TMSSQLParserTest.CreateRole5;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateRole5']);
end;

procedure TMSSQLParserTest.DropRole1;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['DropRole1']);
end;

procedure TMSSQLParserTest.CreateRole6;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateRole6']);
end;

procedure TMSSQLParserTest.CreateRole7;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateRole7']);
end;

procedure TMSSQLParserTest.CreateRole8;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateRole8']);
end;

procedure TMSSQLParserTest.CreateRole9;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateRole9']);
end;

procedure TMSSQLParserTest.CreateRole10;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateRole10']);
end;

procedure TMSSQLParserTest.CreateRole11;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateRole11']);
end;

procedure TMSSQLParserTest.CreateRole12;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateRole12']);
end;

procedure TMSSQLParserTest.DropRole2;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['DropRole2']);
end;

procedure TMSSQLParserTest.CreateLogin1;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateLogin1']);
end;

procedure TMSSQLParserTest.CreateLogin2;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateLogin2']);
end;

procedure TMSSQLParserTest.CreateLogin3;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateLogin3']);
end;

procedure TMSSQLParserTest.CreateLogin4;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateLogin4']);
end;

procedure TMSSQLParserTest.CreateLogin5;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateLogin5']);
end;

procedure TMSSQLParserTest.CreateLogin6;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateLogin6']);
end;

procedure TMSSQLParserTest.CreateLogin7;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateLogin7']);
end;

procedure TMSSQLParserTest.CreateLogin8;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateLogin8']);
end;

procedure TMSSQLParserTest.CreateLogin9;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateLogin9']);
end;

procedure TMSSQLParserTest.CreateLogin10;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateLogin10']);
end;

procedure TMSSQLParserTest.CreateLogin11;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateLogin11']);
end;

procedure TMSSQLParserTest.CreateLogin12;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateLogin12']);
end;

procedure TMSSQLParserTest.CreateLogin13;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateLogin13']);
end;

procedure TMSSQLParserTest.CreateLogin14;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateLogin14']);
end;

procedure TMSSQLParserTest.CreateLogin15;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateLogin15']);
end;

procedure TMSSQLParserTest.CreateLogin16;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateLogin16']);
end;

procedure TMSSQLParserTest.AlterLogin1;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterLogin1']);
end;

procedure TMSSQLParserTest.AlterLogin2;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterLogin2']);
end;

procedure TMSSQLParserTest.AlterLogin3;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterLogin3']);
end;

procedure TMSSQLParserTest.AlterLogin4;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterLogin4']);
end;

procedure TMSSQLParserTest.AlterLogin5;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterLogin5']);
end;

procedure TMSSQLParserTest.AlterLogin6;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterLogin6']);
end;

procedure TMSSQLParserTest.AlterLogin7;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterLogin7']);
end;

procedure TMSSQLParserTest.AlterLogin8;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterLogin8']);
end;

procedure TMSSQLParserTest.AlterLogin9;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterLogin9']);
end;

procedure TMSSQLParserTest.AlterLogin10;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterLogin10']);
end;

procedure TMSSQLParserTest.AlterLogin11;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterLogin11']);
end;

procedure TMSSQLParserTest.DropLogin1;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['DropLogin1']);
end;

procedure TMSSQLParserTest.DropLogin2;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['DropLogin2']);
end;

procedure TMSSQLParserTest.DropLogin3;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['DropLogin3']);
end;

procedure TMSSQLParserTest.DropLogin4;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['DropLogin4']);
end;

procedure TMSSQLParserTest.DropLogin5;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['DropLogin5']);
end;

procedure TMSSQLParserTest.DropLogin6;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['DropLogin6']);
end;

procedure TMSSQLParserTest.DropLogin7;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['DropLogin7']);
end;

procedure TMSSQLParserTest.CreateUser1;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateUser1']);
end;

procedure TMSSQLParserTest.CreateUser2;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateUser2']);
end;

procedure TMSSQLParserTest.CreateUser3;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateUser3']);
end;

procedure TMSSQLParserTest.CreateUser4;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateUser4']);
end;

procedure TMSSQLParserTest.CreateUser5;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateUser5']);
end;

procedure TMSSQLParserTest.CreateUser6;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateUser6']);
end;

procedure TMSSQLParserTest.CreateUser7;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateUser7']);
end;

procedure TMSSQLParserTest.CreateUser8;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateUser8']);
end;

procedure TMSSQLParserTest.CreateUser9;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateUser9']);
end;

procedure TMSSQLParserTest.CreateUser10;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateUser10']);
end;

procedure TMSSQLParserTest.CreateUser11;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateUser11']);
end;

procedure TMSSQLParserTest.CreateUser12;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateUser12']);
end;

procedure TMSSQLParserTest.CreateUser13;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['CreateUser13']);
end;

procedure TMSSQLParserTest.AlterUser1;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterUser1']);
end;

procedure TMSSQLParserTest.AlterUser2;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterUser2']);
end;

procedure TMSSQLParserTest.AlterUser3;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['AlterUser3']);
end;

procedure TMSSQLParserTest.DropUser1;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['DropUser1']);
end;

procedure TMSSQLParserTest.DropUser2;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['DropUser2']);
end;

procedure TMSSQLParserTest.DropUser3;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['DropUser3']);
end;

procedure TMSSQLParserTest.DropUser4;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['DropUser4']);
end;

procedure TMSSQLParserTest.Deny1;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Deny1']);
end;

procedure TMSSQLParserTest.Deny2;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Deny2']);
end;

procedure TMSSQLParserTest.Deny3;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Deny3']);
end;

procedure TMSSQLParserTest.Deny4;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Deny4']);
end;

procedure TMSSQLParserTest.Deny5;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Deny5']);
end;

procedure TMSSQLParserTest.Deny6;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Deny6']);
end;

procedure TMSSQLParserTest.Deny7;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Deny7']);
end;

procedure TMSSQLParserTest.Deny8;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Deny8']);
end;

procedure TMSSQLParserTest.Deny9;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Deny9']);
end;

procedure TMSSQLParserTest.Deny10;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Deny10']);
end;

procedure TMSSQLParserTest.Deny11;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Deny11']);
end;

procedure TMSSQLParserTest.Deny12;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Deny12']);
end;

procedure TMSSQLParserTest.Deny13;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Deny13']);
end;

procedure TMSSQLParserTest.Deny14;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Deny14']);
end;

procedure TMSSQLParserTest.Deny15;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Deny15']);
end;

procedure TMSSQLParserTest.Deny16;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Deny16']);
end;

procedure TMSSQLParserTest.Deny17;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Deny17']);
end;

procedure TMSSQLParserTest.Deny18;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Deny18']);
end;

procedure TMSSQLParserTest.Deny19;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Deny19']);
end;

procedure TMSSQLParserTest.Deny20;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Deny20']);
end;

procedure TMSSQLParserTest.Deny21;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Deny21']);
end;

procedure TMSSQLParserTest.Deny22;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Deny22']);
end;

procedure TMSSQLParserTest.Authorization1;
begin
  DoTestSQL(MSSQLParserTestData.sSecurity['Authorization1']);
end;

procedure TMSSQLParserTest.CreateServer1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateServer1']);
end;

procedure TMSSQLParserTest.CreateServer2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateServer2']);
end;

procedure TMSSQLParserTest.CreateServer3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateServer3']);
end;

procedure TMSSQLParserTest.CreateServer4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateServer4']);
end;

procedure TMSSQLParserTest.CreateServer5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateServer5']);
end;

procedure TMSSQLParserTest.CreateServer6;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateServer6']);
end;

procedure TMSSQLParserTest.CreateServer7;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateServer7']);
end;

procedure TMSSQLParserTest.CreateServer8;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateServer8']);
end;

procedure TMSSQLParserTest.CreateServer9;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateServer9']);
end;

procedure TMSSQLParserTest.CreateServer10;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateServer10']);
end;

procedure TMSSQLParserTest.CreateServer11;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateServer11']);
end;

procedure TMSSQLParserTest.AlterServer1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer1']);
end;

procedure TMSSQLParserTest.AlterServer2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer2']);
end;

procedure TMSSQLParserTest.AlterServer3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer3']);
end;

procedure TMSSQLParserTest.AlterServer4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer4']);
end;

procedure TMSSQLParserTest.AlterServer5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer5']);
end;

procedure TMSSQLParserTest.AlterServer6;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer6']);
end;

procedure TMSSQLParserTest.AlterServer7;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer7']);
end;

procedure TMSSQLParserTest.AlterServer8;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer8']);
end;

procedure TMSSQLParserTest.AlterServer9;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer9']);
end;

procedure TMSSQLParserTest.AlterServer10;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer10']);
end;

procedure TMSSQLParserTest.AlterServer11;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer11']);
end;

procedure TMSSQLParserTest.AlterServer12;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer12']);
end;

procedure TMSSQLParserTest.AlterServer13;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer13']);
end;

procedure TMSSQLParserTest.AlterServer14;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer14']);
end;

procedure TMSSQLParserTest.AlterServer15;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer15']);
end;

procedure TMSSQLParserTest.AlterServer16;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer16']);
end;

procedure TMSSQLParserTest.AlterServer17;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer17']);
end;

procedure TMSSQLParserTest.AlterServer18;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer18']);
end;

procedure TMSSQLParserTest.AlterServer19;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer19']);
end;

procedure TMSSQLParserTest.AlterServer20;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer20']);
end;

procedure TMSSQLParserTest.AlterServer21;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer21']);
end;

procedure TMSSQLParserTest.AlterServer22;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer22']);
end;

procedure TMSSQLParserTest.AlterServer23;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer23']);
end;

procedure TMSSQLParserTest.AlterServer24;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer24']);
end;

procedure TMSSQLParserTest.AlterServer25;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer25']);
end;

procedure TMSSQLParserTest.AlterServer26;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer26']);
end;

procedure TMSSQLParserTest.AlterServer27;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer27']);
end;

procedure TMSSQLParserTest.AlterServer28;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer28']);
end;

procedure TMSSQLParserTest.AlterServer29;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer29']);
end;

procedure TMSSQLParserTest.AlterServer30;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer30']);
end;

procedure TMSSQLParserTest.AlterServer31;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer31']);
end;

procedure TMSSQLParserTest.AlterServer32;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer32']);
end;

procedure TMSSQLParserTest.AlterServer33;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer33']);
end;

procedure TMSSQLParserTest.AlterServer34;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer34']);
end;

procedure TMSSQLParserTest.AlterServer35;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer35']);
end;

procedure TMSSQLParserTest.AlterServer36;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer36']);
end;

procedure TMSSQLParserTest.AlterServer37;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer37']);
end;

procedure TMSSQLParserTest.AlterServer38;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer38']);
end;

procedure TMSSQLParserTest.AlterServer39;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer39']);
end;

procedure TMSSQLParserTest.AlterServer40;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer40']);
end;

procedure TMSSQLParserTest.AlterServer41;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer41']);
end;

procedure TMSSQLParserTest.AlterServer42;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer42']);
end;

procedure TMSSQLParserTest.AlterServer43;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer43']);
end;

procedure TMSSQLParserTest.AlterServer44;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer44']);
end;

procedure TMSSQLParserTest.AlterServer45;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer45']);
end;

procedure TMSSQLParserTest.AlterServer46;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer46']);
end;

procedure TMSSQLParserTest.AlterServer47;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer47']);
end;

procedure TMSSQLParserTest.AlterServer48;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterServer48']);
end;

procedure TMSSQLParserTest.DropServer1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['DropServer1']);
end;

procedure TMSSQLParserTest.DropServer2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['DropServer2']);
end;

procedure TMSSQLParserTest.DropServer3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['DropServer3']);
end;

procedure TMSSQLParserTest.Open1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Open1']);
end;

procedure TMSSQLParserTest.Open2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Open3']);
end;

procedure TMSSQLParserTest.Fetch1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Fetch1']);
end;

procedure TMSSQLParserTest.Fetch2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Fetch2']);
end;

procedure TMSSQLParserTest.Go1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Go1']);
end;

procedure TMSSQLParserTest.Exec1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Exec1']);
end;

procedure TMSSQLParserTest.Exec2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Exec2']);
end;

procedure TMSSQLParserTest.Exec3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Exec3']);
end;

procedure TMSSQLParserTest.Deallocate1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Deallocate1']);
end;

procedure TMSSQLParserTest.Close1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Close1']);
end;

procedure TMSSQLParserTest.CreateStatistic1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateStatistic1']);
end;

procedure TMSSQLParserTest.CreateStatistic2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateStatistic2']);
end;

procedure TMSSQLParserTest.CreateStatistic3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateStatistic3']);
end;

procedure TMSSQLParserTest.CreateStatistic4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateStatistic4']);
end;

procedure TMSSQLParserTest.CreateStatistic5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateStatistic5']);
end;

procedure TMSSQLParserTest.CreateStatistic6;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateStatistic6']);
end;

procedure TMSSQLParserTest.CreateStatistic7;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateStatistic7']);
end;

procedure TMSSQLParserTest.CreateStatistic8;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateStatistic8']);
end;

procedure TMSSQLParserTest.CreateStatistic9;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateStatistic9']);
end;

procedure TMSSQLParserTest.CreateStatistic10;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateStatistic10']);
end;

procedure TMSSQLParserTest.CreateStatistic11;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateStatistic11']);
end;

procedure TMSSQLParserTest.CreateStatistic12;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateStatistic12']);
end;

procedure TMSSQLParserTest.CreateStatistic13;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateStatistic13']);
end;

procedure TMSSQLParserTest.UpdateStatistic1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['UpdateStatistic1']);
end;

procedure TMSSQLParserTest.DropStatistic1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['DropStatistic1']);
end;

procedure TMSSQLParserTest.CreateAssembly1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateAssembly1']);
end;

procedure TMSSQLParserTest.CreateAssembly2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateAssembly2']);
end;

procedure TMSSQLParserTest.CreateAssembly3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateAssembly3']);
end;

procedure TMSSQLParserTest.CreateAssembly4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateAssembly4']);
end;

procedure TMSSQLParserTest.CreateAssembly5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateAssembly5']);
end;

procedure TMSSQLParserTest.CreateAssembly6;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateAssembly6']);
end;

procedure TMSSQLParserTest.CreateAssembly7;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateAssembly7']);
end;

procedure TMSSQLParserTest.AlterAssembly1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterAssembly1']);
end;

procedure TMSSQLParserTest.AlterAssembly2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterAssembly2']);
end;

procedure TMSSQLParserTest.AlterAssembly3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterAssembly3']);
end;

procedure TMSSQLParserTest.DropAssembly1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['DropAssembly1']);
end;

procedure TMSSQLParserTest.AddClassification1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AddClassification1']);
end;

procedure TMSSQLParserTest.AddClassification2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AddClassification2']);
end;

procedure TMSSQLParserTest.DropClassification1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['DropClassification1']);
end;

procedure TMSSQLParserTest.DropClassification2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['DropClassification2']);
end;

procedure TMSSQLParserTest.CreateAsymmetricKey1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateAsymmetricKey1']);
end;

procedure TMSSQLParserTest.CreateAsymmetricKey2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateAsymmetricKey2']);
end;

procedure TMSSQLParserTest.CreateAsymmetricKey3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateAsymmetricKey3']);
end;

procedure TMSSQLParserTest.AlterAsymmetricKey1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateAsymmetricKey1']);
end;

procedure TMSSQLParserTest.AlterAsymmetricKey2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterAsymmetricKey2']);
end;

procedure TMSSQLParserTest.AlterAsymmetricKey3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterAsymmetricKey3']);
end;

procedure TMSSQLParserTest.DropAsymmetricKey1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['DropAsymmetricKey1']);
end;

procedure TMSSQLParserTest.CreateCertificate1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateCertificate1']);
end;

procedure TMSSQLParserTest.CreateCertificate2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateCertificate2']);
end;

procedure TMSSQLParserTest.CreateCertificate3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateCertificate3']);
end;

procedure TMSSQLParserTest.CreateCertificate4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateCertificate4']);
end;

procedure TMSSQLParserTest.CreateCertificate5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateCertificate5']);
end;

procedure TMSSQLParserTest.CreateCertificate6;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateCertificate6']);
end;

procedure TMSSQLParserTest.CreateCertificate7;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateCertificate7']);
end;

procedure TMSSQLParserTest.CreateCertificate8;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateCertificate8']);
end;

procedure TMSSQLParserTest.CreateCertificate9;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateCertificate9']);
end;

procedure TMSSQLParserTest.AlterCertificate1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterCertificate1']);
end;

procedure TMSSQLParserTest.AlterCertificate2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterCertificate2']);
end;

procedure TMSSQLParserTest.AlterCertificate3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterCertificate3']);
end;

procedure TMSSQLParserTest.AlterCertificate4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterCertificate4']);
end;

procedure TMSSQLParserTest.DropCertificate1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['DropCertificate1']);
end;

procedure TMSSQLParserTest.DropCertificate2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['DropCertificate2']);
end;

procedure TMSSQLParserTest.CreateAvailabilityGroup1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateAvailabilityGroup1']);
end;

procedure TMSSQLParserTest.AlterAvailabilityGroup1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterAvailabilityGroup1']);
end;

procedure TMSSQLParserTest.AlterAvailabilityGroup2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterAvailabilityGroup2']);
end;

procedure TMSSQLParserTest.AlterAvailabilityGroup3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterAvailabilityGroup3']);
end;

procedure TMSSQLParserTest.CreateBrokerPriority1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateBrokerPriority1']);
end;

procedure TMSSQLParserTest.CreateBrokerPriority2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateBrokerPriority2']);
end;

procedure TMSSQLParserTest.CreateBrokerPriority3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateBrokerPriority3']);
end;

procedure TMSSQLParserTest.CreateBrokerPriority4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateBrokerPriority4']);
end;

procedure TMSSQLParserTest.CreateBrokerPriority5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateBrokerPriority5']);
end;

procedure TMSSQLParserTest.CreateBrokerPriority6;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateBrokerPriority6']);
end;

procedure TMSSQLParserTest.CreateBrokerPriority7;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateBrokerPriority7']);
end;

procedure TMSSQLParserTest.CreateBrokerPriority8;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateBrokerPriority8']);
end;

procedure TMSSQLParserTest.CreateBrokerPriority9;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateBrokerPriority9']);
end;

procedure TMSSQLParserTest.CreateBrokerPriority10;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateBrokerPriority10']);
end;

procedure TMSSQLParserTest.CreateBrokerPriority11;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateBrokerPriority11']);
end;

procedure TMSSQLParserTest.CreateBrokerPriority12;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateBrokerPriority12']);
end;

procedure TMSSQLParserTest.CreateBrokerPriority13;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateBrokerPriority13']);
end;

procedure TMSSQLParserTest.CreateBrokerPriority14;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateBrokerPriority14']);
end;

procedure TMSSQLParserTest.CreateBrokerPriority15;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateBrokerPriority15']);
end;

procedure TMSSQLParserTest.AlterBrokerPriority1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterBrokerPriority1']);
end;

procedure TMSSQLParserTest.DropBrokerPriority1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['DropBrokerPriority1']);
end;

procedure TMSSQLParserTest.Set1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Set1']);
end;

procedure TMSSQLParserTest.Set2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Set2']);
end;

procedure TMSSQLParserTest.Set3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Set3']);
end;

procedure TMSSQLParserTest.Set4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Set4']);
end;

procedure TMSSQLParserTest.Set5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Set5']);
end;

procedure TMSSQLParserTest.Set6;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Set6']);
end;

procedure TMSSQLParserTest.Set7;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Set7']);
end;

procedure TMSSQLParserTest.Set8;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Set8']);
end;

procedure TMSSQLParserTest.Set9;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Set9']);
end;

procedure TMSSQLParserTest.Set10;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Set10']);
end;

procedure TMSSQLParserTest.Set11;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Set11']);
end;

procedure TMSSQLParserTest.Set12;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Set12']);
end;

procedure TMSSQLParserTest.Set13;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Set13']);
end;

procedure TMSSQLParserTest.Set14;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Set14']);
end;

procedure TMSSQLParserTest.Set15;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Set15']);
end;

procedure TMSSQLParserTest.Set16;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Set16']);
end;

procedure TMSSQLParserTest.Set17;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Set17']);
end;

procedure TMSSQLParserTest.Set18;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Set18']);
end;

procedure TMSSQLParserTest.Set19;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Set19']);
end;

procedure TMSSQLParserTest.Set20;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Set20']);
end;

procedure TMSSQLParserTest.CreateColumnEncryptionKey1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateColumnEncryptionKey1']);
end;

procedure TMSSQLParserTest.CreateColumnEncryptionKey2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateColumnEncryptionKey2']);
end;

procedure TMSSQLParserTest.AlterColumnEncryptionKey1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterColumnEncryptionKey1']);
end;

procedure TMSSQLParserTest.AlterColumnEncryptionKey2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterColumnEncryptionKey2']);
end;

procedure TMSSQLParserTest.DropColumnEncryptionKey1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['DropColumnEncryptionKey1']);
end;

procedure TMSSQLParserTest.CreateCredential1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateCredential1']);
end;

procedure TMSSQLParserTest.CreateCredential2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateCredential2']);
end;

procedure TMSSQLParserTest.CreateCredential3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateCredential3']);
end;

procedure TMSSQLParserTest.CreateCredential4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateCredential4']);
end;

procedure TMSSQLParserTest.CreateCredential5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateCredential5']);
end;

procedure TMSSQLParserTest.CreateCredential6;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateCredential6']);
end;

procedure TMSSQLParserTest.AlterCredential1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterCredential1']);
end;

procedure TMSSQLParserTest.DropCredential1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['DropCredential1']);
end;

procedure TMSSQLParserTest.CreateCryptographicProvider1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateCryptographicProvider1']);
end;

procedure TMSSQLParserTest.AlterCryptographicProvider1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterCryptographicProvider1']);
end;

procedure TMSSQLParserTest.AlterCryptographicProvider2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterCryptographicProvider2']);
end;

procedure TMSSQLParserTest.AlterCryptographicProvider3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterCryptographicProvider3']);
end;

procedure TMSSQLParserTest.AlterCryptographicProvider4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterCryptographicProvider4']);
end;

procedure TMSSQLParserTest.DropCryptographicProvider1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['DropCryptographicProvider1']);
end;

procedure TMSSQLParserTest.AlterEventSession1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterEventSession1']);
end;

procedure TMSSQLParserTest.AlterEventSession2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterEventSession2']);
end;

procedure TMSSQLParserTest.DropEventSession1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['DropEventSession1']);
end;

procedure TMSSQLParserTest.CreateExternalLanguage1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateExternalLanguage1']);
end;

procedure TMSSQLParserTest.CreateExternalLanguage2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateExternalLanguage2']);
end;

procedure TMSSQLParserTest.CreateExternalLanguage3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateExternalLanguage3']);
end;

procedure TMSSQLParserTest.AlterExternalLanguage1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterExternalLanguage1']);
end;

procedure TMSSQLParserTest.DropExternalLanguage1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['DropExternalLanguage1']);
end;

procedure TMSSQLParserTest.CreateExternalLibrary1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateExternalLibrary1']);
end;

procedure TMSSQLParserTest.CreateExternalLibrary2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateExternalLibrary2']);
end;

procedure TMSSQLParserTest.CreateExternalLibrary3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateExternalLibrary3']);
end;

procedure TMSSQLParserTest.CreateExternalLibrary4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateExternalLibrary4']);
end;

procedure TMSSQLParserTest.CreateExternalLibrary5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateExternalLibrary5']);
end;

procedure TMSSQLParserTest.CreateExternalLibrary6;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateExternalLibrary6']);
end;

procedure TMSSQLParserTest.CreateExternalLibrary7;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateExternalLibrary7']);
end;

procedure TMSSQLParserTest.CreateExternalLibrary8;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateExternalLibrary8']);
end;

procedure TMSSQLParserTest.AlterExternalLibrary1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterExternalLibrary1']);
end;

procedure TMSSQLParserTest.AlterExternalLibrary2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterExternalLibrary2']);
end;

procedure TMSSQLParserTest.DropExternalLibrary1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['DropExternalLibrary1']);
end;

procedure TMSSQLParserTest.CreateExternalResource1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateExternalResource1']);
end;

procedure TMSSQLParserTest.AlterExternalResource1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterExternalResource1']);
end;

procedure TMSSQLParserTest.DropExternalResource1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['DropExternalResource1']);
end;

procedure TMSSQLParserTest.CreateFulltextCatalog1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateFulltextCatalog1']);
end;

procedure TMSSQLParserTest.CreateFulltextCatalog2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateFulltextCatalog2']);
end;

procedure TMSSQLParserTest.CreateFulltextCatalog3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['CreateFulltextCatalog3']);
end;

procedure TMSSQLParserTest.AlterFulltextCatalog1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['AlterFulltextCatalog1']);
end;

procedure TMSSQLParserTest.DropFulltextCatalog1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['DropFulltextCatalog1']);
end;

procedure TMSSQLParserTest.MasterKey1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey1']);
end;

procedure TMSSQLParserTest.MasterKey2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey2']);
end;

procedure TMSSQLParserTest.MasterKey3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey3']);
end;

procedure TMSSQLParserTest.MasterKey4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey4']);
end;

procedure TMSSQLParserTest.MasterKey5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey5']);
end;

procedure TMSSQLParserTest.MasterKey6;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey6']);
end;

procedure TMSSQLParserTest.MasterKey7;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey7']);
end;

procedure TMSSQLParserTest.MasterKey8;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey8']);
end;

procedure TMSSQLParserTest.MasterKey9;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey9']);
end;

procedure TMSSQLParserTest.MasterKey10;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey10']);
end;

procedure TMSSQLParserTest.MasterKey11;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey11']);
end;

procedure TMSSQLParserTest.MasterKey12;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey12']);
end;

procedure TMSSQLParserTest.MasterKey13;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey13']);
end;

procedure TMSSQLParserTest.MasterKey14;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey14']);
end;

procedure TMSSQLParserTest.MasterKey15;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey15']);
end;

procedure TMSSQLParserTest.MasterKey16;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey16']);
end;

procedure TMSSQLParserTest.MasterKey17;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey17']);
end;

procedure TMSSQLParserTest.MasterKey18;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey18']);
end;

procedure TMSSQLParserTest.MasterKey19;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey19']);
end;

procedure TMSSQLParserTest.MasterKey20;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey20']);
end;

procedure TMSSQLParserTest.MasterKey21;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey21']);
end;

procedure TMSSQLParserTest.MasterKey22;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey22']);
end;

procedure TMSSQLParserTest.MasterKey23;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey23']);
end;

procedure TMSSQLParserTest.MasterKey24;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey24']);
end;

procedure TMSSQLParserTest.MasterKey25;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey25']);
end;

procedure TMSSQLParserTest.MasterKey26;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey26']);
end;

procedure TMSSQLParserTest.MasterKey27;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey27']);
end;

procedure TMSSQLParserTest.MasterKey28;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey28']);
end;

procedure TMSSQLParserTest.MasterKey29;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MasterKey29']);
end;

procedure TMSSQLParserTest.Route1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Route1']);
end;

procedure TMSSQLParserTest.Route2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Route2']);
end;

procedure TMSSQLParserTest.Route3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Route3']);
end;

procedure TMSSQLParserTest.Route4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Route4']);
end;

procedure TMSSQLParserTest.Route5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Route5']);
end;

procedure TMSSQLParserTest.Route6;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Route6']);
end;

procedure TMSSQLParserTest.Route7;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Route7']);
end;

procedure TMSSQLParserTest.Route8;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Route8']);
end;

procedure TMSSQLParserTest.Route9;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Route9']);
end;

procedure TMSSQLParserTest.Route10;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Route10']);
end;

procedure TMSSQLParserTest.Route11;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Route11']);
end;

procedure TMSSQLParserTest.Route12;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Route12']);
end;

procedure TMSSQLParserTest.Route13;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Route13']);
end;

procedure TMSSQLParserTest.Route14;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Route14']);
end;

procedure TMSSQLParserTest.StopList1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['StopList1']);
end;

procedure TMSSQLParserTest.StopList2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['StopList2']);
end;

procedure TMSSQLParserTest.StopList3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['StopList3']);
end;

procedure TMSSQLParserTest.StopList4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['StopList4']);
end;

procedure TMSSQLParserTest.StopList5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['StopList5']);
end;

procedure TMSSQLParserTest.StopList6;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['StopList6']);
end;

procedure TMSSQLParserTest.Queue1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Queue1']);
end;

procedure TMSSQLParserTest.Queue2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Queue2']);
end;

procedure TMSSQLParserTest.Queue3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Queue3']);
end;

procedure TMSSQLParserTest.Queue4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Queue4']);
end;

procedure TMSSQLParserTest.Queue5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Queue5']);
end;

procedure TMSSQLParserTest.Queue6;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Queue6']);
end;

procedure TMSSQLParserTest.Queue7;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Queue7']);
end;

procedure TMSSQLParserTest.Queue8;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Queue8']);
end;

procedure TMSSQLParserTest.Queue9;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Queue9']);
end;

procedure TMSSQLParserTest.Queue10;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Queue10']);
end;

procedure TMSSQLParserTest.Queue11;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Queue11']);
end;

procedure TMSSQLParserTest.Queue12;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Queue12']);
end;

procedure TMSSQLParserTest.Queue13;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Queue13']);
end;

procedure TMSSQLParserTest.Queue14;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Queue14']);
end;

procedure TMSSQLParserTest.Queue15;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Queue15']);
end;

procedure TMSSQLParserTest.Queue16;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Queue16']);
end;

procedure TMSSQLParserTest.Resource1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Resource1']);
end;

procedure TMSSQLParserTest.Resource2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Resource2']);
end;

procedure TMSSQLParserTest.Resource3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Resource3']);
end;

procedure TMSSQLParserTest.Resource4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Resource4']);
end;

procedure TMSSQLParserTest.Resource5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Resource5']);
end;

procedure TMSSQLParserTest.Resource6;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Resource6']);
end;

procedure TMSSQLParserTest.Resource7;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Resource7']);
end;

procedure TMSSQLParserTest.Resource8;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Resource8']);
end;

procedure TMSSQLParserTest.Resource9;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Resource9']);
end;

procedure TMSSQLParserTest.Resource10;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Resource10']);
end;

procedure TMSSQLParserTest.Resource11;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Resource11']);
end;

procedure TMSSQLParserTest.Resource12;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Resource12']);
end;

procedure TMSSQLParserTest.Resource13;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Resource13']);
end;

procedure TMSSQLParserTest.Resource14;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Resource14']);
end;

procedure TMSSQLParserTest.Resource15;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Resource15']);
end;

procedure TMSSQLParserTest.Resource16;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Resource16']);
end;

procedure TMSSQLParserTest.Resource17;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Resource17']);
end;

procedure TMSSQLParserTest.Resource18;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Resource18']);
end;

procedure TMSSQLParserTest.SecurityPolicy1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SecurityPolicy1']);
end;

procedure TMSSQLParserTest.SecurityPolicy2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SecurityPolicy2']);
end;

procedure TMSSQLParserTest.SecurityPolicy3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SecurityPolicy3']);
end;

procedure TMSSQLParserTest.SecurityPolicy4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SecurityPolicy4']);
end;

procedure TMSSQLParserTest.SecurityPolicy5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SecurityPolicy5']);
end;

procedure TMSSQLParserTest.SecurityPolicy6;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SecurityPolicy6']);
end;

procedure TMSSQLParserTest.SecurityPolicy7;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SecurityPolicy7']);
end;

procedure TMSSQLParserTest.SecurityPolicy8;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SecurityPolicy8']);
end;

procedure TMSSQLParserTest.SymmetricKey1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SymmetricKey1']);
end;

procedure TMSSQLParserTest.SymmetricKey2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SymmetricKey2']);
end;

procedure TMSSQLParserTest.SymmetricKey3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SymmetricKey3']);
end;

procedure TMSSQLParserTest.SymmetricKey4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SymmetricKey4']);
end;

procedure TMSSQLParserTest.SymmetricKey5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SymmetricKey5']);
end;

procedure TMSSQLParserTest.SymmetricKey6;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SymmetricKey6']);
end;

procedure TMSSQLParserTest.SymmetricKey7;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SymmetricKey7']);
end;

procedure TMSSQLParserTest.SymmetricKey8;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SymmetricKey8']);
end;

procedure TMSSQLParserTest.SymmetricKey9;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SymmetricKey9']);
end;

procedure TMSSQLParserTest.SymmetricKey10;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SymmetricKey10']);
end;

procedure TMSSQLParserTest.SymmetricKey11;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SymmetricKey11']);
end;

procedure TMSSQLParserTest.SymmetricKey12;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SymmetricKey12']);
end;

procedure TMSSQLParserTest.SymmetricKey13;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SymmetricKey13']);
end;

procedure TMSSQLParserTest.SymmetricKey14;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SymmetricKey14']);
end;

procedure TMSSQLParserTest.SymmetricKey15;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['SymmetricKey15']);
end;

procedure TMSSQLParserTest.PropertyList1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['PropertyList1']);
end;

procedure TMSSQLParserTest.PropertyList2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['PropertyList2']);
end;

procedure TMSSQLParserTest.PropertyList3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['PropertyList3']);
end;

procedure TMSSQLParserTest.PropertyList4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['PropertyList4']);
end;

procedure TMSSQLParserTest.PropertyList5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['PropertyList5']);
end;

procedure TMSSQLParserTest.PropertyList6;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['PropertyList6']);
end;

procedure TMSSQLParserTest.PropertyList7;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['PropertyList7']);
end;

procedure TMSSQLParserTest.Service1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Service1']);
end;

procedure TMSSQLParserTest.Service2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Service2']);
end;

procedure TMSSQLParserTest.Service3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Service3']);
end;

procedure TMSSQLParserTest.Service4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Service4']);
end;

procedure TMSSQLParserTest.Service5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Service5']);
end;

procedure TMSSQLParserTest.Service6;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Service6']);
end;

procedure TMSSQLParserTest.Service7;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Service7']);
end;

procedure TMSSQLParserTest.Service8;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Service8']);
end;

procedure TMSSQLParserTest.Service9;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Service9']);
end;

procedure TMSSQLParserTest.Service10;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Service10']);
end;

procedure TMSSQLParserTest.Service11;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Service11']);
end;

procedure TMSSQLParserTest.Service12;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Service12']);
end;

procedure TMSSQLParserTest.WorkloadGroup1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['WorkloadGroup1']);
end;

procedure TMSSQLParserTest.WorkloadGroup2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['WorkloadGroup2']);
end;

procedure TMSSQLParserTest.WorkloadGroup3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['WorkloadGroup3']);
end;

procedure TMSSQLParserTest.WorkloadGroup4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['WorkloadGroup4']);
end;

procedure TMSSQLParserTest.WorkloadGroup5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['WorkloadGroup5']);
end;

procedure TMSSQLParserTest.WorkloadGroup6;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['WorkloadGroup6']);
end;

procedure TMSSQLParserTest.BackupRestore1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore1']);
end;

procedure TMSSQLParserTest.BackupRestore2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore2']);
end;

procedure TMSSQLParserTest.BackupRestore3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore3']);
end;

procedure TMSSQLParserTest.BackupRestore4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore4']);
end;

procedure TMSSQLParserTest.BackupRestore5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore5']);
end;

procedure TMSSQLParserTest.BackupRestore6;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore6']);
end;

procedure TMSSQLParserTest.BackupRestore7;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore7']);
end;

procedure TMSSQLParserTest.BackupRestore8;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore8']);
end;

procedure TMSSQLParserTest.BackupRestore9;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore9']);
end;

procedure TMSSQLParserTest.BackupRestore10;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore10']);
end;

procedure TMSSQLParserTest.BackupRestore11;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore11']);
end;

procedure TMSSQLParserTest.BackupRestore12;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore12']);
end;

procedure TMSSQLParserTest.BackupRestore13;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore13']);
end;

procedure TMSSQLParserTest.BackupRestore14;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore14']);
end;

procedure TMSSQLParserTest.BackupRestore15;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore15']);
end;

procedure TMSSQLParserTest.BackupRestore16;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore16']);
end;

procedure TMSSQLParserTest.BackupRestore17;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore17']);
end;

procedure TMSSQLParserTest.BackupRestore18;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore18']);
end;

procedure TMSSQLParserTest.BackupRestore19;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore19']);
end;

procedure TMSSQLParserTest.BackupRestore20;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore20']);
end;

procedure TMSSQLParserTest.BackupRestore21;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore21']);
end;

procedure TMSSQLParserTest.BackupRestore22;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore22']);
end;

procedure TMSSQLParserTest.BackupRestore23;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore23']);
end;

procedure TMSSQLParserTest.BackupRestore24;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore24']);
end;

procedure TMSSQLParserTest.BackupRestore25;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore25']);
end;

procedure TMSSQLParserTest.BackupRestore26;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore26']);
end;

procedure TMSSQLParserTest.BackupRestore27;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore27']);
end;

procedure TMSSQLParserTest.BackupRestore28;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore28']);
end;

procedure TMSSQLParserTest.BackupRestore29;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore29']);
end;

procedure TMSSQLParserTest.BackupRestore30;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore30']);
end;

procedure TMSSQLParserTest.BackupRestore31;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore31']);
end;

procedure TMSSQLParserTest.BackupRestore32;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore32']);
end;

procedure TMSSQLParserTest.BackupRestore33;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore33']);
end;

procedure TMSSQLParserTest.BackupRestore34;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore34']);
end;

procedure TMSSQLParserTest.BackupRestore35;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore35']);
end;

procedure TMSSQLParserTest.BackupRestore36;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore36']);
end;

procedure TMSSQLParserTest.BackupRestore37;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore37']);
end;

procedure TMSSQLParserTest.BackupRestore38;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['BackupRestore38']);
end;

procedure TMSSQLParserTest.Event1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Event1']);
end;

procedure TMSSQLParserTest.Event2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Event2']);
end;

procedure TMSSQLParserTest.Event3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Event3']);
end;

procedure TMSSQLParserTest.Event4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Event4']);
end;

procedure TMSSQLParserTest.Signature1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Signature1']);
end;

procedure TMSSQLParserTest.Signature2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Signature2']);
end;

procedure TMSSQLParserTest.Signature3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Signature3']);
end;

procedure TMSSQLParserTest.Signature4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Signature4']);
end;

procedure TMSSQLParserTest.Signature5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Signature5']);
end;

procedure TMSSQLParserTest.Signature6;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Signature6']);
end;

procedure TMSSQLParserTest.Signature7;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Signature7']);
end;

procedure TMSSQLParserTest.Revert1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Revert1']);
end;

procedure TMSSQLParserTest.Synonym1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Synonym1']);
end;

procedure TMSSQLParserTest.Synonym2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Synonym2']);
end;

procedure TMSSQLParserTest.Synonym3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Synonym2']);
end;

procedure TMSSQLParserTest.Synonym4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Synonym2']);
end;

procedure TMSSQLParserTest.Synonym5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Synonym2']);
end;

procedure TMSSQLParserTest.Reconfigure1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Reconfigure1']);
end;

procedure TMSSQLParserTest.Rebuild1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Rebuild1']);
end;

procedure TMSSQLParserTest.Rebuild2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Rebuild2']);
end;

procedure TMSSQLParserTest.MessageType1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MessageType1']);
end;

procedure TMSSQLParserTest.MessageType2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MessageType2']);
end;

procedure TMSSQLParserTest.MessageType3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MessageType3']);
end;

procedure TMSSQLParserTest.MessageType4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MessageType4']);
end;

procedure TMSSQLParserTest.MessageType5;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MessageType5']);
end;

procedure TMSSQLParserTest.MessageType6;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MessageType6']);
end;

procedure TMSSQLParserTest.MessageType7;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MessageType7']);
end;

procedure TMSSQLParserTest.MessageType8;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MessageType8']);
end;

procedure TMSSQLParserTest.Filter1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Filter1']);
end;

procedure TMSSQLParserTest.Transaction1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Transaction1']);
end;

procedure TMSSQLParserTest.Transaction2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Transaction2']);
end;

procedure TMSSQLParserTest.Default1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Default1']);
end;

procedure TMSSQLParserTest.Default2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Default2']);
end;

procedure TMSSQLParserTest.Default3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Default3']);
end;

procedure TMSSQLParserTest.Default4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Default4']);
end;

procedure TMSSQLParserTest.Aggregate1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Aggregate1']);
end;

procedure TMSSQLParserTest.Aggregate2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Aggregate2']);
end;

procedure TMSSQLParserTest.Contract1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Contract1']);
end;

procedure TMSSQLParserTest.Contract2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Contract2']);
end;

procedure TMSSQLParserTest.Endpoint1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Endpoint1']);
end;

procedure TMSSQLParserTest.Endpoint2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Endpoint2']);
end;

procedure TMSSQLParserTest.Endpoint3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Endpoint3']);
end;

procedure TMSSQLParserTest.Endpoint4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Endpoint4']);
end;

procedure TMSSQLParserTest.Rule1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Rule1']);
end;

procedure TMSSQLParserTest.Rule2;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Rule2']);
end;

procedure TMSSQLParserTest.Rule3;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Rule3']);
end;

procedure TMSSQLParserTest.Rule4;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Rule4']);
end;

procedure TMSSQLParserTest.DBCC1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['DBCC1']);
end;

procedure TMSSQLParserTest.MessageType9;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['MessageType9']);
end;

procedure TMSSQLParserTest.Setuser1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['Setuser1']);
end;

procedure TMSSQLParserTest.DropSecurityPolicy1;
begin
  DoTestSQL(MSSQLParserTestData.sSystem['DropSecurityPolicy1']);
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
