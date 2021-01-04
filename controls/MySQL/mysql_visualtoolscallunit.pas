{ Free DB Manager

  Copyright (C) 2005-2021 Lagunov Aleksey  alexs75 at yandex.ru

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

unit mysql_VisualToolsCallUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineAbstractUnit, mysql_engine, Forms,
  SynHighlighterSQL, fbm_VisualEditorsAbstractUnit, fdbm_PagedDialogPageUnit,
  cfAbstractConfigFrameUnit, otMySQLTriggerTemplateUnit;

type

   { TMySQLVisualTools }

  TMySQLVisualTools = class(TDBVisualTools)
  private
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

    class function GetObjTemplatePagesCount: integer;override;
    class function GetObjTemplate(Index: integer; Owner:TComponent): TFBMConfigPageAbstract;override;
  end;

implementation
uses   fbmStrConstUnit, fdbm_cf_LogUnit, fdbm_DescriptionUnit,
  fdbm_ssh_ParamsUnit, fdbm_ShowObjectsUnit, pg_con_EditorPrefUnit,

  fbmpgACLEditUnit,
  fbmTableEditorDataUnit, fbmObjectEditorDescriptionUnit,
  fbmTableEditorFieldsUnit, fbmTableEditorTriggersUnit,
  fdbmTableEditorPKListUnit, fdbmTableEditorForeignKeyUnit,
  fbmTableEditorIndexUnit, fbmMySQLTablePropsUnit,
  fbmDDLPageUnit, fbmdboDependenUnit,
  mysql_CreateDatabaseUnit, fbmMySQLSPEdtMainPageUnit,
  MySQLTriggerHeaderEditUnit, fbmViewEditorMainUnit,
  MySQL_con_MainPageUnit, fdmUserEditor_MySQLUnit
  ;


{ TMySQLVisualTools }


class function TMySQLVisualTools.GetCreateObject: TSQLEngineCreateDBAbstractClass;
begin
  Result:=TMySQLCreateDBClass.Create;
end;

class function TMySQLVisualTools.GetObjTemplatePagesCount: integer;
begin
  Result:=2;
end;

class function TMySQLVisualTools.GetObjTemplate(Index: integer;
  Owner: TComponent): TFBMConfigPageAbstract;
begin
  case Index of
    0:Result:=TotMySQLTriggerTemplateFrame.CreateTools(Owner, false);
    1:Result:=TotMySQLTriggerTemplateFrame.CreateTools(Owner, true);
  end;
end;

class function TMySQLVisualTools.GetMenuItems(Index: integer): TMenuItemRec;
begin
  FillChar(Result, SizeOf(Result), 0);
end;

class function TMySQLVisualTools.GetMenuItemCount: integer;
begin
  Result:=0;
end;

class function TMySQLVisualTools.ConfigDlgPageCount: integer;
begin
  Result:=0;
end;

class function TMySQLVisualTools.ConfigDlgPage(APageNum: integer;
  AOwner: TForm): TFBMConfigPageAbstract;
begin
  Result:=nil;
end;

constructor TMySQLVisualTools.Create(ASQLEngine: TSQLEngineAbstract);
begin
  inherited Create(ASQLEngine);
  RegisterObjEditor(TMySQLTable,
    [TfbmTableEditorFieldsFrame, TfbmMySQLTablePropsFrame, TfbmObjectEditorDescriptionFrame],
    [TfbmTableEditorFieldsFrame, TfbmTableEditorDataFrame, TfbmTableEditorIndexFrame,
     TfdbmTableEditorPKListFrame, TfdbmTableEditorForeignKeyFrame, TfbmTableEditorTriggersFrame,
     TfbmObjectEditorDescriptionFrame, TfbmMySQLTablePropsFrame, TDependenciesFrame, TfbmpgACLEditEditor, TfbmDDLPage]);

  RegisterObjEditor(TMySQLView,
    [TfbmViewEditorMainFrame],
    [TfbmViewEditorMainFrame, TfbmTableEditorFieldsFrame, TDependenciesFrame, TfbmTableEditorDataFrame, TfbmDDLPage]);

  RegisterObjEditor(TMySQLTriger,
    [TMySQLTriggerHeaderEditor, TfbmObjectEditorDescriptionFrame],
    [TMySQLTriggerHeaderEditor, TfbmObjectEditorDescriptionFrame, TfbmDDLPage]);

  RegisterObjEditor(TMySQLProcedure,
    [TfbmMySQLSPEdtMainPage, TfbmObjectEditorDescriptionFrame],
    [TfbmMySQLSPEdtMainPage, TfbmObjectEditorDescriptionFrame, TDependenciesFrame, TfbmpgACLEditEditor, TfbmDDLPage]);

  RegisterObjEditor(TMySQLFunction,
    [TfbmMySQLSPEdtMainPage, TfbmObjectEditorDescriptionFrame],
    [TfbmMySQLSPEdtMainPage, TfbmObjectEditorDescriptionFrame, TDependenciesFrame, TfbmpgACLEditEditor, TfbmDDLPage]);

  RegisterObjEditor(TMySQLUser,
    [TfdmUserEditor_MySQLForm],
    [TfdmUserEditor_MySQLForm, TfbmDDLPage]);

end;

procedure TMySQLVisualTools.InitSQLSyn(const ASynSQLSyn: TSynSQLSyn);
begin
  ASynSQLSyn.SQLDialect:=sqlMySQL;
end;

class function TMySQLVisualTools.ConnectionDlgPageCount: integer;
begin
  Result:=6;
end;

class function TMySQLVisualTools.ConnectionDlgPage(
  ASQLEngine: TSQLEngineAbstract; APageNum: integer; AOwner: TForm
  ): TPagedDialogPage;
begin
  case APageNum of
    0:Result:=TMySQL_con_MainPage.CreateConnectForm(ASQLEngine as TSQLEngineMySQL, AOwner);
    1:Result:=TfdbmCFLogFrame.Create(ASQLEngine , AOwner);
    2:Result:=Tpg_con_EditorPrefPage.Create(ASQLEngine , AOwner);
    3:Result:=Tfdbm_ssh_ParamsPage.Create(ASQLEngine, AOwner);
    4:Result:=Tfdbm_ShowObjectsPage.Create(ASQLEngine, AOwner);
    5:Result:=Tfdbm_DescriptionConnectionDlgPage.CreateDescriptionPage(ASQLEngine, AOwner);
  else
    Result:=nil;
  end;
end;

initialization
  RegisterSQLEngine(TSQLEngineMySQL, TMySQLVisualTools, sMySQLServer);
end.

