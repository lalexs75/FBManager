{ Free DB Manager

  Copyright (C) 2005-2019 Lagunov Aleksey  alexs75 at yandex.ru

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


{$IFDEF USE_FB}
  {%H-}fb_VisualToolsCallUnit,
  {%H-}FBSQLEngineUnit,
  {%H-}fbm_cf_mainunit,
  {%H-}fbm_cf_BuckupUnit,
  {%H-}fbm_cf_RestoreUnit,
  {%H-}cfFireBirdOptionsUnit,
  {%H-}cfFirebirdTransactionsParamsUnit,
  {%H-}fb_CharSetUtils,
  {%H-}fb_utils,
  {%H-}fb_ConstUnit,
  {%H-}fbm_cf_TransactionUnit,


  {%H-}fbmUDFMainEditorUnit,
  {%H-}fbmGeneratorMainEditorUnit,
  {%H-}fbmExceptionMainEditorUnit,
  {%H-}fbmRoleMainEditorUnit,
  {%H-}fbmDomainMainEditorUnit,
  {%H-}fbKeywordsUnit,
  {%H-}exsortfb,
  {%H-}fbmFBVariableFrameUnit,
  {%H-}fbSqlTextUnit,
  {%H-}otFirebirdTriggerTemplateUnit,
  {%H-}fbmFirebirdTablePropsUnit,
  {%H-}fbmFBIndexEditorUnit,
  {%H-}fbmFirebirdPackageUnit,
  {%H-}fbmFBFunctionUnit,
  {%H-}otFirebirdFunctionTemplateUnit,
  {%H-}otFirebirdPackageTemplateUnit,
{$ENDIF}

{$IFDEF USE_DBF}
  {%H-}dbf_engineunit,
  {%H-}fdbm_cf_DbfMainUnit,
  {%H-}dbf_visualtoolscallunit,

{$ENDIF}

{$IFDEF ORACLE}
  {%H-}OracleSQLEngine,
  {%H-}fdbm_OraConnectionMainUnit,
  {%H-}oracle_keywords,
  {%H-}ora_VisualToolsCallUnit,
{$ENDIF}

{$IFDEF MS_SQL}
  mssq_engine,
  cf_mssql_mainUnit,
  mssql_sql_lines_unit,
  mssql_ObjectsList,
  mssql_FreeTDSConfig_Unit,
{$ENDIF}

{$IFDEF PostgreSQL}
  {%H-}pg_VisualToolsCallUnit,
  {%H-}PostgreSQLEngineUnit,
  {%H-}fbmUserEditorUnit,
  {%H-}fbmGroupEditFrameUnit,
  {%H-}pg_con_MainPageUnit,
  {%H-}PGKeywordsUnit,
  {%H-}fdbm_SchemeEditorUnit,
  {%H-}pg_utils,
  {%H-}pgTriggerEditorUnit,
  {%H-}fbm_pgEditSequenceUnit,
  {%H-}fbmPostGreeSPedtMainPageUnit,
  {%H-}fbmPostGreeSPedtMainPage_EditParamUnit,
  {%H-}pgTypes,
  {%H-}pgSqlTextUnit,
  {%H-}pgSqlEngineSecurityUnit,
  {%H-}pgCreateDatabaseUnit,
  {%H-}pgActivitiMonitorUnit,
  {%H-}pgIndexEditorFrameUnit,
  {%H-}pgTableSpaceEditorUnit,
  {%H-}fbmpgACLEditUnit,
  {%H-}fbmPGLanguageUnit,
  {%H-}cfPostgreeConfigMiskUnit,
  {%H-}pg_tasks,
  {%H-}pgTaskMainUnit,
  {%H-}pgTaskStepsUnit,
  {%H-}pgTaskTasksUnit,
  {%H-}pgTaskLogUnit,
  {%H-}pgTaskStepsBuildConnectionUnit,
  {%H-}fbmPGLocalVarsEditorFrameUnit,
  {%H-}otPostgreProcTemplateUnit,
  {%H-}otPostgreTriggerTemplateUnit,
  {%H-}pg_con_EditorPrefUnit,
  {%H-}pg_SqlParserUnit,
  {%H-}fbmPGRuleEditorUnit,
  {%H-}fbmPGRuleListUnit,
  {%H-}fbmpgTableCheckConstaintUnit,
  {%H-}fbmpgTableCheckConstaint_EditUnit,
  {%H-}pgEventTriggerEditorUnit,
  {%H-}fbmpgtablepropertysunit,
  {%H-}pgSQLEngineFTS,
  {%H-}fbmFTSConfigUnit,
  {%H-}pgSQLEngineFDW,
  {%H-}pgForeignDW,
  {%H-}pgExtensionUnit,
{$ENDIF}

{$IFDEF MySQL}
  {%H-}mysql_VisualToolsCallUnit,
  {%H-}mysql_engine,
  {%H-}mysql_types,
  {%H-}MySQL_con_MainPageUnit,
  {%H-}mysqlDataModuleUnit,
  {%H-}MySQLKeywords,
  {%H-}fbmMySQLSPEdtMainPageUnit,
  {%H-}fbmMySQLTablePropsUnit,
  {%H-}mysql_SqlParserUnit,
  {%H-}mysql_CreateDatabaseUnit,
  {%H-}MySQLTriggerHeaderEditUnit,
{$ENDIF}

{$IFDEF SQLite3}
  {%H-}SQLite3EngineUnit,
  {%H-}sqlite3_VisualToolsCallUnit,
  {%H-}sqlite3_cf_mainunit,
  {%H-}sqlite3_SqlParserUnit,
  {%H-}sqlite3_keywords,
  {%H-}SQLite3TriggerHeaderEditUnit,
  {%H-}sqlite3_CreateDatabaseUnit,
  {%H-}sqlite3IndexEditorFrameUnit,
  {%H-}sqlite3_SQLTextUnit,
{$ENDIF}
