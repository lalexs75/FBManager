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

unit pg_VisualToolsCallUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineAbstractUnit, Forms, SynHighlighterSQL,
  fbm_VisualEditorsAbstractUnit, cfAbstractConfigFrameUnit, fdbm_PagedDialogPageUnit,
  pgSqlEngineSecurityUnit;

type

  { TPostgreVisualTools }

  TPostgreVisualTools = class(TDBVisualTools)
  private
    procedure tlsShowActivitiMonitorExecute(Sender: TObject);
    procedure tlsCreateProcedureExecute(Sender: TObject);
    procedure tlsPGDBAnalizExecute(Sender: TObject);
  protected

  public
    constructor Create(ASQLEngine:TSQLEngineAbstract);override;
    procedure InitSQLSyn(const ASynSQLSyn: TSynSQLSyn);override;

    class function ConnectionDlgPageCount:integer;override;
    class function ConnectionDlgPage(ASQLEngine:TSQLEngineAbstract; APageNum:integer; AOwner:TForm):TPagedDialogPage;override;

    class function ConfigDlgPageCount:integer;override;
    class function ConfigDlgPage(APageNum:integer; AOwner:TForm):TFBMConfigPageAbstract;override;
    class function GetMenuItems(Index: integer): TMenuItemRec; override;
    class function GetMenuItemCount:integer; override;

    class function GetObjTemplatePagesCount: integer;override;
    class function GetObjTemplate(Index: integer; Owner:TComponent): TFBMConfigPageAbstract;override;

    class function GetCreateObject:TSQLEngineCreateDBAbstractClass; override;
  end;

implementation
uses pgActivitiMonitorUnit, pgDataBaseStatUnit, fbmStrConstUnit,
  fbmCreateProcTableUnit, otPostgreProcTemplateUnit,
  otPostgreTriggerTemplateUnit, IBManMainUnit, IBManDataInspectorUnit,
  PostgreSQLEngineUnit, pg_tasks, pg_sql_lines_unit, fbmUserEditorUnit,
  fbmObjectEditorDescriptionUnit, fbmGroupEditFrameUnit, fbmRoleGrantUsersUnit,
  fbmUserObjectsGrantUnit, fbmDDLPageUnit,
  //Конфигурация
     cfPostgreeConfigMiskUnit, otPostgreTableTemplateUnit, cfAutoIncFieldUnit,
  //Connection pages
     pg_con_MainPageUnit,
     fdbm_cf_LogUnit,
     fdbm_ShowObjectsUnit, fdbm_DescriptionUnit, fdbm_ssh_ParamsUnit,
  //Object Editors
     fbmTableEditorDataUnit,
     fbmTableEditorFieldsUnit,
     fbmpgTablePropertysUnit,           //Редактор свойств таблицы
     fbmViewEditorMainUnit, fdbm_SchemeEditorUnit, fbmDomainMainEditorUnit,
     fbmTableEditorTriggersUnit, fdbmTableEditorPKListUnit,
     fdbmTableEditorForeignKeyUnit, fdbmTableEditorUniqueUnit,
     fbm_pgEditSequenceUnit, fbmPostGreeSPedtMainPageUnit, pgFunctionConfigUnit,      //Редактор процедуры
     pgTriggerEditorUnit,               //Редактор тригера
     pgEventTriggerEditorUnit,          //Редактор триггера по событию
     pgIndexEditorFrameUnit,            //Редактор индекса
     fbmTableEditorIndexUnit,
     pgTableSpaceEditorUnit,            //Редактор табличного пространства
     fbmToolsUnit,              //Общие запросы для всех SQL серверов
     fbmdboDependenUnit, pgForeignDW, pgExtensionUnit, fbmFTSConfigUnit,
     fbmPGRuleEditorUnit,
     fbmPGRuleListUnit,                //Зависимости
     fbmpgACLEditUnit, fbmpgTableCheckConstaintUnit, fbmpgTableAutoVaccumUnit,
     pgForeignTablePropertyUnit, fbmPGTablePartitionUnit,                  //Права доступа
     fbmPGLanguageUnit,                 //Языки
     fbmTableStatisticUnit,
     pgForeignUserMapping, pgForeignServerUnit,

     pg_con_EditorPrefUnit,

     pgTaskMainUnit,
     pgTaskStepsUnit,
     pgTaskTasksUnit,
     pgTaskLogUnit,

     pgSQLEngineFTS, pgSQLEngineFDW,

     pgCreateDatabaseUnit

  ;

{ TPostgreVisualTools }

procedure TPostgreVisualTools.tlsShowActivitiMonitorExecute(Sender: TObject);
begin
  ShowpgActivitiMonitorForm
end;

procedure TPostgreVisualTools.tlsCreateProcedureExecute(Sender: TObject);
var
  fbmCreateProcTableForm: TfbmCreateProcTableForm;
begin
  if Assigned(fbManDataInpectorForm) and Assigned(fbManDataInpectorForm.CurrentObject)
    and Assigned(fbManDataInpectorForm.CurrentObject.DBObject)
    and (fbManDataInpectorForm.CurrentObject.DBObject is TPGTable) then
  begin
    fbmCreateProcTableForm:=TfbmCreateProcTableForm.CreateEditForm(fbManDataInpectorForm.CurrentObject.DBObject as TPGTable);
    fbManagerMainForm.RxMDIPanel1.ChildWindowsAdd(fbmCreateProcTableForm);
  end;
end;

procedure TPostgreVisualTools.tlsPGDBAnalizExecute(Sender: TObject);
begin
  if Assigned(fbManDataInpectorForm) and Assigned(fbManDataInpectorForm.CurrentDB) and (fbManDataInpectorForm.CurrentDB.SQLEngine is TSQLEnginePostgre) then
    ShowDataBaseStatForm(fbManDataInpectorForm.CurrentDB.SQLEngine as TSQLEnginePostgre);
end;

class function TPostgreVisualTools.GetObjTemplatePagesCount: integer;
begin
  Result:=5;
end;

class function TPostgreVisualTools.GetObjTemplate(Index: integer;
  Owner: TComponent): TFBMConfigPageAbstract;
begin
  case Index of
    0:Result:=TotPostgreProcTemplatePage.CreateTools(Owner, false);
    1:Result:=TotPostgreProcTemplatePage.CreateTools(Owner, True);
    2:Result:=TotPostgreTriggerTemplatePage.Create(Owner);
    3:begin
        Result:=TcfAutoIncFieldFrame.Create(Owner);
        TcfAutoIncFieldFrame(Result).SQLEngineClass:=TSQLEnginePostgre;
        TcfAutoIncFieldFrame(Result).PageNameStr:='PG : AutoIncParams';
        TcfAutoIncFieldFrame(Result).DummyTriggerText:=DummyAIPGTriggerText;
        TcfAutoIncFieldFrame(Result).UseSchemas:=true;
      end;
    4:Result:=TotPostgreTableTemplateFrame.Create(Owner);
  else
    Result:=nil;
  end;
end;

constructor TPostgreVisualTools.Create(ASQLEngine: TSQLEngineAbstract);
begin
  inherited Create(ASQLEngine);
  RegisterObjEditor(TPGSchema,
    [Tfdbm_SchemeEditorForm, TfbmObjectEditorDescriptionFrame],
    [Tfdbm_SchemeEditorForm, TDependenciesFrame, TfbmpgACLEditEditor, TfbmObjectEditorDescriptionFrame,
     TfbmTableStatisticFrame, TfbmDDLPage]);

  RegisterObjEditor(TPGDomain,
    [TfbmDomainMainEditorFrame, TfbmObjectEditorDescriptionFrame],
    [TfbmDomainMainEditorFrame, TDependenciesFrame, TfbmObjectEditorDescriptionFrame,
     TfbmTableStatisticFrame, TfbmDDLPage]);

  RegisterObjEditor(TPGRule,
    [TPGRuleEditorPage, TfbmObjectEditorDescriptionFrame],
    [TPGRuleEditorPage, TfbmObjectEditorDescriptionFrame, TfbmDDLPage]);

  RegisterObjEditor(TPGTable,
    [TfbmTableEditorFieldsFrame, TfbmpgTablePropertysFrame, TfbmPGTablePartitionPage, TfbmpgTableCheckConstaintPage,
     TfbmObjectEditorDescriptionFrame],
    [TfbmTableEditorFieldsFrame, TfbmTableEditorDataFrame, TfdbmTableEditorPKListFrame,
     TfdbmTableEditorForeignKeyFrame, TfdbmTableEditorUniqueFrame, TfbmpgTableCheckConstaintPage,
     TfbmTableEditorIndexFrame, TfbmTableEditorTriggersFrame, TfbmPGTablePartitionPage, TPGRuleListPage, TfbmpgTablePropertysFrame,
     TfbmpgTableAutoVaccum, TDependenciesFrame, TfbmpgACLEditEditor, TfbmObjectEditorDescriptionFrame,
     TfbmTableStatisticFrame, TfbmDDLPage]);

  RegisterObjEditor(TPGView,
    [TfbmViewEditorMainFrame, TfbmObjectEditorDescriptionFrame],
    [TfbmViewEditorMainFrame, TfbmTableEditorFieldsFrame, TfbmTableEditorDataFrame,
     TfbmTableEditorTriggersFrame, TPGRuleListPage, TDependenciesFrame, TfbmpgACLEditEditor, TfbmObjectEditorDescriptionFrame,
     TfbmTableStatisticFrame, TfbmDDLPage]);

  RegisterObjEditor(TPGMatView,
    [TfbmViewEditorMainFrame, TfbmObjectEditorDescriptionFrame],
    [TfbmViewEditorMainFrame, TfbmTableEditorFieldsFrame, TfbmTableEditorDataFrame,
     TfbmTableEditorIndexFrame, TPGRuleListPage,
     TfbmpgTableAutoVaccum, TDependenciesFrame, TfbmpgACLEditEditor,
     TfbmObjectEditorDescriptionFrame,
     TfbmTableStatisticFrame, TfbmDDLPage]);

  RegisterObjEditor(TPGSequence,
    [Tfbm_pgEditSequencePage, TfbmObjectEditorDescriptionFrame],
    [Tfbm_pgEditSequencePage, TDependenciesFrame, TfbmpgACLEditEditor, TfbmObjectEditorDescriptionFrame,
    TfbmTableStatisticFrame, TfbmDDLPage]);

  RegisterObjEditor(TPGTrigger,
    [TpgTriggerEditorPage, TfbmObjectEditorDescriptionFrame],
    [TpgTriggerEditorPage, TDependenciesFrame, TfbmObjectEditorDescriptionFrame,
     TfbmTableStatisticFrame, TfbmDDLPage]);

  RegisterObjEditor(TPGEventTrigger,
    [TpgEventTriggerEditorPage, TfbmObjectEditorDescriptionFrame],
    [TpgEventTriggerEditorPage, TDependenciesFrame, TfbmObjectEditorDescriptionFrame,
     TfbmTableStatisticFrame, TfbmDDLPage]
    );

  RegisterObjEditor(TPGFunction,
    [TfbmPostGreeFunctionEdtMainPage, TfbmObjectEditorDescriptionFrame],
    [TfbmPostGreeFunctionEdtMainPage, TDependenciesFrame, TfbmpgACLEditEditor,
     TpgFunctionConfigFrame, TfbmObjectEditorDescriptionFrame,
     TfbmTableStatisticFrame, TfbmDDLPage]);

  RegisterObjEditor(TPGTriggerFunction,
    [TfbmPostGreeFunctionEdtMainPage, TfbmObjectEditorDescriptionFrame],
    [TfbmPostGreeFunctionEdtMainPage, TDependenciesFrame,
     TfbmObjectEditorDescriptionFrame,
     TfbmTableStatisticFrame, TfbmDDLPage]);

  RegisterObjEditor(TPGIndex,
    [TpgIndexEditorPage, TfbmObjectEditorDescriptionFrame],
    [TpgIndexEditorPage, TDependenciesFrame, TfbmObjectEditorDescriptionFrame,
     TfbmTableStatisticFrame, TfbmDDLPage]);

  RegisterObjEditor(TPGLanguage,
    [TfbmPGLanguagePage, TfbmObjectEditorDescriptionFrame],
    [TfbmPGLanguagePage, TDependenciesFrame, TfbmpgACLEditEditor, TfbmObjectEditorDescriptionFrame,
     TfbmDDLPage]);

  RegisterObjEditor(TPGTableSpace,
    [TpgTableSpaceEditorPage, TfbmObjectEditorDescriptionFrame],
    [TpgTableSpaceEditorPage, TDependenciesFrame, TfbmpgACLEditEditor, TfbmObjectEditorDescriptionFrame,
     TfbmTableStatisticFrame, TfbmDDLPage]);

  RegisterObjEditor(TPGUser,
    [TfbmUserEditorForm, TfbmObjectEditorDescriptionFrame],
    [TfbmUserEditorForm, TfbmUserObjectsGrantFrame, TfbmObjectEditorDescriptionFrame, TfbmDDLPage]
    );

  RegisterObjEditor(TPGGroup,
    [TfbmGroupEditFrameEditor, TfbmObjectEditorDescriptionFrame],
    [TfbmGroupEditFrameEditor, TfbmRoleGrantUsersFrame, TfbmUserObjectsGrantFrame, TfbmObjectEditorDescriptionFrame, TfbmDDLPage]);

  RegisterObjEditor(TPGTask,
    [TpgTaskMainPage, TpgTaskStepsPage, TpgTaskShedulePage, TfbmObjectEditorDescriptionFrame],
    [TpgTaskMainPage, TpgTaskStepsPage, TpgTaskShedulePage, TpgTaskLogPage, TfbmObjectEditorDescriptionFrame, TfbmTableStatisticFrame, TfbmDDLPage]);

  RegisterObjEditor(TPGExtension,
      [TpgExtensionEditor, TfbmObjectEditorDescriptionFrame],
      [TpgExtensionEditor, TfbmObjectEditorDescriptionFrame, TfbmTableStatisticFrame, TfbmDDLPage]
    );

  RegisterObjEditor(TPGCollation,
      [TfbmObjectEditorDescriptionFrame, TfbmDDLPage],
      [TfbmObjectEditorDescriptionFrame, TfbmDDLPage]
    );

  //FTS
  RegisterObjEditor(TPGFTSConfigurations,
      [TfbmFTSConfigEditorPage, TfbmObjectEditorDescriptionFrame],
      [TfbmFTSConfigEditorPage, TfbmObjectEditorDescriptionFrame, TfbmDDLPage]
    );
  RegisterObjEditor(TPGFTSDictionares,
      [TfbmObjectEditorDescriptionFrame],
      [TfbmObjectEditorDescriptionFrame, TfbmDDLPage]
    );
  RegisterObjEditor(TPGFTSParsers,
      [TfbmObjectEditorDescriptionFrame],
      [TfbmObjectEditorDescriptionFrame, TfbmTableStatisticFrame, TfbmDDLPage]
    );
  RegisterObjEditor(TPGFTSTemplate,
      [TfbmObjectEditorDescriptionFrame],
      [TfbmObjectEditorDescriptionFrame, TfbmDDLPage]
    );

  //FOREIGN DATA

  RegisterObjEditor(TPGForeignDataWrapper,
      [TpgForeignDataWrap, TfbmObjectEditorDescriptionFrame],
      [TpgForeignDataWrap, TfbmpgACLEditEditor, TfbmObjectEditorDescriptionFrame, TfbmTableStatisticFrame, TfbmDDLPage]
    );

  RegisterObjEditor(TPGForeignServer,
      [TpgForeignServerPage, TfbmObjectEditorDescriptionFrame],
      [TpgForeignServerPage, TfbmpgACLEditEditor, TfbmObjectEditorDescriptionFrame, TfbmTableStatisticFrame, TfbmDDLPage]
  );

  RegisterObjEditor(TPGForeignUser,
    [TpgForeignUserMap{, TfbmObjectEditorDescriptionFrame}],
    [TpgForeignUserMap, {TfbmObjectEditorDescriptionFrame, }TfbmDDLPage]
  );

  RegisterObjEditor(TPGForeignTable,
    [TpgForeignTablePropertyFrame, TfbmTableEditorFieldsFrame, TfbmObjectEditorDescriptionFrame],
    [TfbmTableEditorFieldsFrame, TfbmTableEditorDataFrame, TpgForeignTablePropertyFrame, TDependenciesFrame,
     TfbmpgACLEditEditor, TfbmObjectEditorDescriptionFrame, TfbmTableStatisticFrame, TfbmDDLPage]);
end;

procedure TPostgreVisualTools.InitSQLSyn(const ASynSQLSyn: TSynSQLSyn);
begin
  ASynSQLSyn.SQLDialect:=sqlPostgres;
end;

class function TPostgreVisualTools.ConnectionDlgPageCount: integer;
begin
  Result:=6;
end;

class function TPostgreVisualTools.ConnectionDlgPage(
  ASQLEngine: TSQLEngineAbstract; APageNum: integer; AOwner: TForm
  ): TPagedDialogPage;
begin
  case APageNum of
    0:Result:=Tpg_con_MainPage.Create(ASQLEngine as TSQLEnginePostgre, AOwner);
    1:Result:=TfdbmCFLogFrame.Create(ASQLEngine as TSQLEnginePostgre, AOwner);
    2:Result:=Tfdbm_ShowObjectsPage.Create(ASQLEngine, AOwner);
    3:Result:=Tpg_con_EditorPrefPage.Create(ASQLEngine as TSQLEnginePostgre, AOwner);
    4:Result:=Tfdbm_ssh_ParamsPage.Create(ASQLEngine, AOwner);
    5:Result:=Tfdbm_DescriptionConnectionDlgPage.CreateDescriptionPage(ASQLEngine as TSQLEnginePostgre, AOwner);
  else
    Result:=nil;
  end;
end;

class function TPostgreVisualTools.ConfigDlgPageCount: integer;
begin
  Result:=1;
end;

class function TPostgreVisualTools.ConfigDlgPage(APageNum: integer;
  AOwner: TForm): TFBMConfigPageAbstract;
begin
  case APageNum of
    0:Result:=TcfPostgreeConfigMiskFrame.Create(AOwner);
  else
    Result:=nil;
  end;
end;

class function TPostgreVisualTools.GetMenuItems(Index: integer): TMenuItemRec;
begin
  FillChar(Result, Sizeof(Result), 0);
  Result.ImageIndex:=-1;
  case Index of
    0:begin
        Result.ItemName:=sPostgreSQLDBStat;
        Result.OnClick:=@tlsShowActivitiMonitorExecute;
      end;
    1:begin
        Result.ItemName:=sPostgreSQLTableCreateProc;
        Result.OnClick:=@tlsCreateProcedureExecute;
      end;
    2:begin
        Result.ItemName:=sPostgresDBAnaliz;
        Result.OnClick:=@tlsPGDBAnalizExecute;
      end;
  end;
end;

class function TPostgreVisualTools.GetMenuItemCount: integer;
begin
  Result:=3;
end;

class function TPostgreVisualTools.GetCreateObject: TSQLEngineCreateDBAbstractClass;
begin
  Result:=TPGEngineCreateDBClass.Create;
end;

initialization
  RegisterSQLEngine(TSQLEnginePostgre, TPostgreVisualTools, sPostgreeSQLServer);
end.

