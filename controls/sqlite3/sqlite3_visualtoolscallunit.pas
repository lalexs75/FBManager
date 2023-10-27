{ Free DB Manager

  Copyright (C) 2005-2023 Lagunov Aleksey  alexs75 at yandex.ru

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

unit sqlite3_VisualToolsCallUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineAbstractUnit, fbm_VisualEditorsAbstractUnit,
  SQLite3EngineUnit, SynHighlighterSQL, Forms,
  fdbm_PagedDialogPageUnit,
  cfAbstractConfigFrameUnit;

type

  { TSQLite3VisualTools }

  TSQLite3VisualTools = class(TDBVisualTools)
  private
    procedure tlsShowActivitiMonitorExecute(Sender: TObject);
  protected
  public
    constructor Create(ASQLEngine:TSQLEngineAbstract);override;
    procedure InitSQLSyn(const ASynSQLSyn: TSynSQLSyn);override;

    class function ConnectionDlgPageCount:integer;override;
    class function ConnectionDlgPage(ASQLEngine:TSQLEngineAbstract; APageNum:integer; AOwner:TForm):TPagedDialogPage; override;

    class function GetMenuItems(Index: integer): TMenuItemRec; override;
    class function GetMenuItemCount:integer; override;
    class function ConfigDlgPageCount:integer;override;
    class function ConfigDlgPage(APageNum:integer; AOwner:TForm):TFBMConfigPageAbstract; override;
    class function GetCreateObject:TSQLEngineCreateDBAbstractClass; override;
  end;

implementation
uses fbmStrConstUnit, sqlite3_cf_mainunit, fdbm_cf_LogUnit,
  fdbm_DescriptionUnit, fdbm_ShowObjectsUnit, sqlite3_CreateDatabaseUnit,
  fbmTableEditorFieldsUnit, fbmTableEditorDataUnit,
  fdbmTableEditorForeignKeyUnit, fdbmTableEditorUniqueUnit, fbmDDLPageUnit,
  sqlite3IndexEditorFrameUnit, SQLite3TriggerHeaderEditUnit,
  fbmTableEditorTriggersUnit, fbmViewEditorMainUnit,
  fbmObjectEditorDescriptionUnit, fbmpgTableCheckConstaintUnit,
  fbmTableEditorIndexUnit, SQLiteActivitiMonitorUnit;

{ TSQLite3VisualTools }

procedure TSQLite3VisualTools.tlsShowActivitiMonitorExecute(Sender: TObject);
begin
  ShowpgActivitiMonitorForm
end;

constructor TSQLite3VisualTools.Create(ASQLEngine: TSQLEngineAbstract);
begin
  inherited Create(ASQLEngine);
  RegisterObjEditor(TSQLite3Table,
    [TfbmTableEditorFieldsFrame, {TfdbmTableEditorForeignKeyFrame, TfdbmTableEditorUniqueFrame,} TfbmpgTableCheckConstaintPage,
     TfbmObjectEditorDescriptionFrame],

    [TfbmTableEditorFieldsFrame, TfbmTableEditorDataFrame,
     {TfdbmTableEditorPKListFrame, }TfdbmTableEditorForeignKeyFrame, TfdbmTableEditorUniqueFrame, TfbmpgTableCheckConstaintPage,
     TfbmTableEditorIndexFrame,
     TfbmTableEditorTriggersFrame, {TDependenciesFrame, }

    TfbmDDLPage
   ]);

  RegisterObjEditor(TSQLite3View,
    [TfbmViewEditorMainFrame],
    [TfbmViewEditorMainFrame, TfbmTableEditorFieldsFrame, TfbmTableEditorDataFrame,
     TfbmTableEditorTriggersFrame,
     TfbmObjectEditorDescriptionFrame, TfbmDDLPage]);

  RegisterObjEditor(TSQLite3Triger,
    [TSQLite3TriggerHeaderEditFrame, TfbmObjectEditorDescriptionFrame],
    [TSQLite3TriggerHeaderEditFrame, TfbmObjectEditorDescriptionFrame, TfbmDDLPage]);


  RegisterObjEditor(TSQLite3Index,
    [Tsqlite3IndexEditorPage],
    [Tsqlite3IndexEditorPage, TfbmDDLPage]);
end;

procedure TSQLite3VisualTools.InitSQLSyn(const ASynSQLSyn: TSynSQLSyn);
begin
  ASynSQLSyn.SQLDialect:=sqlSQLite;
end;

class function TSQLite3VisualTools.ConnectionDlgPageCount: integer;
begin
  Result:=4;
end;

class function TSQLite3VisualTools.ConnectionDlgPage(
  ASQLEngine: TSQLEngineAbstract; APageNum: integer; AOwner: TForm
  ): TPagedDialogPage;
begin
  case APageNum of
    0:Result:=TConnectionSQLite3MainPage.Create(ASQLEngine as TSQLEngineSQLite3, AOwner);
    1:Result:=TfdbmCFLogFrame.Create(ASQLEngine, AOwner);
    2:Result:=Tfdbm_ShowObjectsPage.Create(ASQLEngine, AOwner);
    3:Result:=Tfdbm_DescriptionConnectionDlgPage.CreateDescriptionPage(ASQLEngine, AOwner);
  else
    Result:=nil;
  end;
end;

class function TSQLite3VisualTools.GetMenuItems(Index: integer): TMenuItemRec;
begin
  FillChar(Result, Sizeof(Result), 0);
  Result.ImageIndex:=-1;
  case Index of
    0:begin
        Result.ItemName:=sSQLiteDBStat;
        Result.OnClick:=@tlsShowActivitiMonitorExecute;
      end;
  end;
end;

class function TSQLite3VisualTools.GetMenuItemCount: integer;
begin
  Result:=1;
end;

class function TSQLite3VisualTools.ConfigDlgPageCount: integer;
begin
  Result:=0;
end;

class function TSQLite3VisualTools.ConfigDlgPage(APageNum: integer;
  AOwner: TForm): TFBMConfigPageAbstract;
begin
  Result:=nil;
end;

class function TSQLite3VisualTools.GetCreateObject: TSQLEngineCreateDBAbstractClass;
begin
  Result:=TSQLite3CreateDB.Create;
end;

initialization
  RegisterSQLEngine(TSQLEngineSQLite3, TSQLite3VisualTools, sSQLite3Engine);
end.

