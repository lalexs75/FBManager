program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, rxnew, rx, lazcontrols, uiblaz, Unit1, SQLEngineAbstractUnit,
  SQLEngineCommonTypesUnit, fbmSqlParserUnit, SQLEngineInternalToolsUnit,
  mysql_engine, MySQLKeywords, mysql_SqlParserUnit, mysql_types,
  SQLite3EngineUnit, sqlite3_keywords, sqlite3_SqlParserUnit, FBSQLEngineUnit,
  fb_SqlParserUnit, fbKeywordsUnit, sqlObjects, fbmStrConstUnit, zcomponent,
  PostgreSQLEngineUnit, pgSqlTextUnit, pg_SqlParserUnit, sqlParserConsts,
  TreeAddChildTokenUnit
  { you can add units after this };

{$R *.res}

begin
  Application.Title:='SQL parser test';
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TTreeAddChildTokenForm, TreeAddChildTokenForm);
  Application.Run;
end.

