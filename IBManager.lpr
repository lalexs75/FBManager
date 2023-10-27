{ Free DB Manager

  Copyright (C) 2005-2018 Lagunov Aleksey  alexs75 at yandex.ru

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

program IBManager;

{$I fbmanager_define.inc}

uses
  Interfaces,
  Forms,

  rxsortmemds,
  lazcontrols,
  zeos_ex,
  tachartlazaruspkg, anchordockpkg,
  zcomponent,
  lr_add_function,
  lrcairoexport,
  fpstdexports,

  rxAppUtils,
  rxlogging,

  IBManMainUnit,
  fbmSQLEditorUnit,
  fEditSearch,
  fbmToolsUnit,
  fbmEnvironmentOptionsUnit,
  ibmSqlUtilsUnit, 
  ibmSqlTextsUnit,
  fbmCompileQestUnit,
  fbmEditorOptionsUnit,
  fbmExportDataUnit,
  ibmanagertypesunit,
  ib_manager_table_editor_field_order_unit,
  fbmfillqueryparamsunit,
  fbmDBObjectEditorUnit,
  fbmUserDataBaseUnit,
  fbmInsertDefSqlUnit,
  IBManDataInspectorUnit,
  SQLEngineAbstractUnit,
{$I sql_enigines_list.inc}
  fbmCreateConnectionUnit,
  fdmAbstractEditorUnit,
  fbmTableEditorDataUnit,
  fbmTableEditorFieldsUnit,
  fbmTableEditorIndexUnit,
  fbmStrConstUnit,
  fbmObjectEditorDescriptionUnit,
  fbmConnectionEditUnit,
  SQLEngineCommonTypesUnit,
  fbmSqlParserUnit,
  cfOIUnit,
  cfAbstractConfigFrameUnit,
  cfGridOptionsUnit,
  cfReportsOptionsUnit,
  cfGeneralOptionsUnit,
  cfSQLEditorOptionsUnit,
  fdbm_ConnectionAbstractUnit,
  fdbm_PagedDialogUnit,
  fdbm_PagedDialogPageUnit,
(*
  fbmErrorBoxUnit,
  fbmShowNewUnit,
*)
  fbmRoleGrantUsersUnit,
  fbmSQLEditorClassesUnit,
  dsObjectsUnit,
  dsDesignerUnit,
  fbmRolesDBObjectsGrantUnit,

  fdbm_SynEditorUnit,
  fdbm_SynEditorCompletionHintUnit,
  fbmdboDependenUnit,
  fdbm_cf_DisplayDataParamsUnit,
  fbmDDLPageUnit,
  fdbmSynAutoCompletionsLists,
  cfKeyboardTemplatesUnit,
  dsLinkPropertysUnit,
  SQLEngineInternalToolsUnit,
  fdbm_ShowObjectsUnit,
  fdbmTableEditorUniqueUnit,
  cfSystemConfirmationUnit,
  fbmObjectTemplatesunit,
  fbmSQLTextCommonUnit,
  fbmSQLParamValueEditorUnit,
  tlsSearchInMetatDataParamsUnit,
  tlsSearchInMetatDataResultUnit,
  tlsProgressOperationUnit,
  fbmSQLEditor_ShowMemoUnit,
  fbmCreateProcTableUnit,
  fbmExtractUnit,
  fbmReportManagerUnit,
  fbmOIFoldersUnit,
  fbmOIFolder_EditUnit,
  fbmCompatibilitySystemUnit,
  sqlObjects,
  fbm_VisualEditorsAbstractUnit,
  ImportDataUnit,
  fdbm_monitorabstractunit,


  cfAutoIncFieldUnit, fbmMakeSQLFromDataSetUnit, fdbm_DescriptionUnit,
  fdmUserEditor_MySQLUnit, otMySQLTriggerTemplateUnit,
  SQLiteActivitiMonitorUnit, fbmRefreshObjTreeUnit, fbmTableStatisticUnit,
  pgForeignUserMapping, pgForeignServerUnit, fdbm_ssh_ParamsUnit,
  SSHConnectionUnit, SSHConnectionPluginConfigUnit, fbmSQLScriptRunQuestionUnit,
  fbmToolsNV, fbmUserObjectsGrantUnit, fbmDocsSystemConfigUnit,
  fbmPGTablePartition_EditKeyUnit, fbmPGTablePartition_EditSectionUnit,
  otPostgreTableTemplateUnit, pgDataBaseStatUnit, GenerateDataUnit,
  pg_definitions, pgToolsFindDuplicateUnit, fbmAbstractSQLEngineToolsUnit,
  pgDBObjectsSizeUnit, pgObjectAnalysisAndWarningsUnit,
  fbmCompillerMessagesUnit, fbmPgObjectEditorsUtils, mssql_VisualToolsCallUnit,
  mssql_sql_parser, mssql_EngineSecurityUnit, mssqlRoleEditorUnit, 
FBSQLEngineSecurityUnit;

{$R IBManager.res}

begin
  InitRxLogs;

  Application.Scaled:=True;

  InitStdAutoCompletions;
  RegisterStdFormats;

  Application.Title:='Free Database Manager';
  Application.Initialize;

  ParseCMDLine;

  InitDataModule;
  InitSysOptions;

  WriteLogInitConfig;

  Application.CreateForm(TfbManagerMainForm, fbManagerMainForm);
  fbManagerMainForm.Show;
  fbManagerMainForm.ShowDataInspector;
  fbManDataInpectorForm.ReadAlialList;
  Application.Run;
end.

