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

unit fbmStrConstUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils; 

const
  sProtokol1                        = 'Local';
  sProtokol2                        = 'TCP/IP';
  sProtokol3                        = 'NetBEUI';
  sDDL                              = 'DDL';
  sSQL                              = 'SQL';

  sFireBirdSQLServer                = 'FireBird SQL Server';
  sDBFFiles                         = 'Local DBF files folder';
  sOracleSQLServer                  = 'Oracle SQL Server';
  sMSSQLServer                      = 'MS SQL Server';
  sPostgreeSQLServer                = 'Postgree SQL Server';
  sMySQLServer                      = 'MySQL Server';
  sSQLite3Engine                    = 'SQLite3 engine';

  sFKNameMask                       = 'fk_%s_%d';
  sFKIndexNameMask                  = 'idx_fk_%s_%d';

resourcestring
  //Main windows
  sMenuSystem                       = 'System';
  sExit                             = 'Close';
  sExitHint                         = 'Exit application...';
  sMenuCreateDB                     = 'Create Database';
  sMenuCreateDBHint                 = 'Create new database';
  sMenuRegisterDB                   = 'Register database';
  sMenuRegisterDBHint               = 'Register existing database';
  sMenuUnRegisterDB                 = 'Unregister  database';
  sMenuUnRegisterDBHint             = 'Unregister current database';
  sMenuConnectDB                    = 'Connect';
  sMenuConnectDBHint                = 'Connect to database';
  sMenuDisconnectDB                 = 'Disconnect';
  sMenuDisconnectDBHint             = 'Disconect from database';
  sMenuRefresh                      = 'Refresh';
  sMenuRefreshHint                  = 'Refresh current opbject';

  sMenuTools                        = 'Tools';
  sMenuDBInspector                  = 'DB Inspector';
  sMenuDBInspectorHint              = 'Show database inspector';
  sMenuSQLEditor                    = 'SQL Editor';
  sMenuSQLEditorHint                = 'Show sql editor';
  sMenuSqlScript                    = 'SQL script...';
  sMenuSqlScriptHint                = 'Show SQL script window';
  sMenuSqlBuilder                   = 'SQL builder...';
  sMenuSqlBuilderHint               = 'Show SQL builder window';
  sMenuSearchInMetadata             = 'Search in metadata...';
  sMenuSearchInMetadataHint         = 'Search in metadata';
  sMenuExtractMetadata              = 'Extract metadata...';
  sMenuExtractMetadataHint          = 'Extract metadata...';
  sMenuReportManager                = 'Report manager';
  sMenuReportManagerHint            = 'Report manager';

  sMenuOptions                      = 'Options';
  sMenuOptEditors                   = 'Editor options...';
  sMenuOptEditorsHint               = 'Show editor options...';
  sMenuOptEnironment                = 'Environment Options...';
  sMenuOptEnironmentHint            = 'Show environment options...';
  sMenuCustomizeToolbar             = 'Customize toolbar';
  sMenuCustomizeToolbarHint         = 'Customize toolbar';
  sMenuKeyboardTemplates            = 'Keyboard templates...';
  sMenuKeyboardTemplatesHint        = 'Keyboard templates...';
  sMenuObjectTemplates              = 'Object templates';
  sMenuObjectTemplatesHint          = 'Object templates';

  sMenuWindows                      = 'Windows';
  sMenuReOrder                      = 'Reorder';
  sMenuReOrderHint                  = 'Reorder open window';
  sMenuCloseAll                     = 'Close all';
  sMenuCloseAllHint                 = 'Close all window';

  sMenuHelp                         = 'Help';
  sMenuAbout                        = 'About...';
  sMenuAboutHint                    = 'About of application';
  sMenuNews                         = 'Latest news...';
  sMenuNewsHint                     = 'Show latest news...';
  sMenuSendBugreport                = 'Send bug report';
  sMenuSendBugreportHint            = 'Send bug report';
  sMenuVisitToWebSite               = 'Visit to web site...';
  sMenuVisitToWebSiteHint           = 'Visit to web site...';

  sOIDatabases                      = 'Databases';
  sOIWindows                        = 'Windows';
  sOIRecent                         = 'Recent';
  sOIGotoToObject                   = 'Goto to object';
  sOIRegisterDB                     = 'Register DB';

  sOIEditDBRegistration             = 'Edit DB registration record';
  sOIEditDBRegistrationHint         = 'Edit DB registration record';
  sOICopyRegistration               = 'Copy registration record...';
  sOICopyRegistrationHint           = 'Copy registration record...';
  sOIShowSQLAssistent               = 'Show SQL assistent';
  sOIShowSQLAssistentHint           = 'Show SQL assistent';
  sOIShowObject                     = 'Show object';
  sOIShowObjectHint                 = 'Show object';
  sOIGoToDomains                    = 'Go to domains...';
  sOIGoToDomainsHint                = 'Go to domains...';
  sOIGoToTables                     = 'Go to tables...';
  sOIGoToTablesHint                 = 'Go to tables...';
  sOIGoToViews                      = 'Go to views...';
  sOIGoToViewsHint                  = 'Go to views...';
  sOIGoToSP                         = 'Go to stored proc...';
  sOIGoToSPHint                     = 'Go to stored proc...';
  sOIGoToTriggers                   = 'Go to triggers...';
  sOIGoToTriggersHint               = 'Go to triggers...';
  sOIFindObject                     = 'Find object';
  sOIFindObjectHint                 = 'Find object';
  sOICopyLine                       = 'Copy line to clipboard';
  sOICopyLineHint                   = 'Copy line to clipboard';
  sOICopyAllLines                   = 'Copy all lines to clipboard';
  sOICopyAllLinesHint               = 'Copy all lines to clipboard';
  sOIHideSQLAssistent               = 'Hide SQL assistent';
  sOIHideSQLAssistentHint           = 'Hide SQL assistent';
  sMakeDefSQLText                   = 'Make SQL text';
  sAlias                            = 'Alias';
  sVarPrefix                        = 'Variable prefix';
  sFieldsParametersList             = 'Fields/Parameters list';
  sDatabaseObjectTemplates          = 'Database object templates';
  sKeyboardTemplates                = 'Keyboard templates';
  sTemplate                         = 'Template';
  sTemplates                        = 'Templates';
  sPressShiftSpaceToActivate        = 'Press Shift+Space to activate';
  sBody                             = 'Body';
  sAddTemplate                      = 'Add template';
  sEditTemplate                     = 'Edit template';
  sDeleteTemplate                   = 'Delete template';
  sSaveToFile                       = 'Save to file...';
  sLoadDefault                      = 'Load default';
  sLoginForm                        = 'Login form';
  sProtocol                         = 'Protocol';
  sClientLibraryName                = 'Client library name';
  sDatabasePageSize                 = 'Database page size';
  sDatabaseDialect                  = 'Database dialect';
  sDbfFilesFolder                   = 'Dbf files folder';
  sDatabaseAlias                    = 'Database alias';
  sDatabaseFile                     = 'Database file';
  sVarName                          = 'Variable name';
  sVarType                          = 'Variable type';
  sVarDefValue                      = 'Variable default value';
  sConnections                      = 'Connections';
  sTypeOf                           = 'TypeOf';
  sDatabaseUser                     = 'Database user';

  sExtractMetaForm                  = 'Extract metadata from DB';
  sDatabase                         = 'Database';
  sDatabaseHint                     = 'Select database';
  sObjects                          = 'Objects';
  sProgres                          = 'Progres';
  sSelectDatabase                   = 'Select database';
  sExtractAll                       = 'Extract all';
  sAdd                              = 'Add';
  sAddHint                          = 'Add data';
  sRemove                           = 'Remove';
  sEdit                             = 'Edit';
  sEditHint                         = 'Edit data';
  sApplyScript                      = 'Apply script';
  sServerName1                      = 'Server name';
  sConnect                          = 'Connect';
  sConnectViaSSH                    = 'Connect via SSH';
  sUseSSHTunnel                     = 'Use SSH tunnel';
  sSSHHost                          = 'SSH Host';
  sSSHPort                          = 'SSH port';
  sSSHUser                          = 'SSH User';
  sSSHPassword                      = 'SSH password';
  sSSHIdentifyFile                  = 'SSH identify file';

  sUserList                         = 'User list';
  sAddUserHint                      = 'Add user to server user list';
  sEditUserInList                   = 'Edit user in list';
  sDeleteUserFromServerUserList     = 'Delete user from server user list';
  sNewRole                          = 'New role';
  sDeleteRole                       = 'Delete role';
  sPrintUserList                    = 'Print user list';
  sPrintList                        = 'Print list';
  sPrintListOfAllUserAndRoles       = 'Print list of all user and roles';
  sCopyRoleNameToClipboard          = 'Copy role name to clipboard';

  sFindInMetatada                   = 'Find in metadata';
  sCopylistToClipboard              = 'Copy list to clipboard';
  sCopylistToClipboardHint          = 'Copy of objects list to clipboard';
  sFindInDatabase                   = 'Find in database';
  sFindText                         = 'Text to find';
  sFindOptions                      = 'Find options';
  sCaseSensetive                    = 'Case sensetive';
  sFindInObjects                    = 'Find in objects';
  sFindQuery                        = 'Find query';
  sMessages                         = 'Messages';
  sQueryFields                      = 'Query fields';
  sResultGrid                       = 'Grid';
  sResultForm                       = 'Form';

  sFindInMetatadaResult             = 'Find in metadata result';
  sYes                              = 'Yes';

  sNewField                         = 'New field';
  sEditField                        = 'Edit field';
  sDropField                        = 'Drop field';
  sPrintFieldFist                   = 'Print field list';
  sRefreshFieldFist                 = 'Refresh field list';
  sFieldsOrder                      = 'Fields order...';
  sFieldCount                       = 'Field count: %d';
  sCopyFieldName                    = 'Copy field name';
  sCopyField                        = 'Copy field...';
  sCopyFields                       = 'Copy fields?';
  sPK                               = 'PK';
  sUNQ                              = 'UNQ';
  sImportData                       = 'Import data';
  sImportDataFile                   = 'Import data file';
  sCollumns                         = 'Collumns';
  sSkipBeforeRows                   = 'Skip before rows';
  sSkipAfterRows                    = 'Skip after rows';
  sImport                           = 'Import';
  sImportFromFile                   = 'Import from file "%s"';
  sImportDataToTable                = 'Import data to table';
  sGenerateInsertScript             = 'Generate INSERT script';
  sImportedCollumns                 = 'Imported collumns';

  sNewIndex                         = 'New index';
  sEditIndex                        = 'Edit index';
  sDeleteIndex                      = 'Delete index';
  sPrintIndexList                   = 'Print index list';
  sRefreshIndexList                 = 'Refresh index list';
  sIndexCaption                     = 'Index caption';
  sIndexExpression                  = 'Index expression';
  sOnFields                         = 'On fields';
  sActive                           = 'Active';
  sUserPassword                     = 'User password';
  sCreateParams                     = 'Create params';
  sConnectionParams                 = 'Connection params';
  sDatabaseProperty                 = 'Database property';
  sFBManagerOptions                 = 'FBManager options';
  sOwner                            = 'Owner';
  sCodepage                         = 'Codepage';
  sConnectionLimit                  = 'Connection limit';
  sCType                            = 'CType';
  sRegisterAfterCreate              = 'Register after create';
  sMetadataLogingEnable             = 'Meta data loging enable';
  sSQLMetadataLogFile               = 'SQL metadata log file';
  sSQLEditorLogFile                 = 'SQL editor log file';
  sSQLEditorHistoryCount            = 'SQL editor history count';
  sWriteTimestampIntoLog            = 'Write timestamp into log';
  sEnableLogginMetadataChanges      = 'Enable loggin metadata changes';
  sEnableLogginSQLEditor            = 'Enable loggin SQL editor';
  sUseCustomCodepageForLoggin       = 'Use custom codepage for loggin';
  sCreatePostgreDatabase            = 'Create postgre database...';
  sCreateMySQLDatabase              = 'Create MySQL database...';

  sSelectConnectionType             = 'Select connection type';
  sFKName                           = 'Forign key name';
  sCreateIndex                      = 'Create index';
  sOnTable                          = 'On table';
  sOnUpdate                         = 'On Update';
  sOnDelete                         = 'On Delete';
  sExportToSpreadsheet              = 'Export to spreadsheet';
  sUserName1                        = 'User name';
  sUserID                           = 'User ID';
  sGroupID                          = 'Group ID';
  sGrant                            = 'Grant';
  sWithGrantOptions                 = 'With Grant Options';
  sGrantor                          = 'Grantor';
  sRoleName1                        = 'Role name';
  sAllOobjects                      = 'All objects';
  sGrantForAll                      = 'Grant for all';
  sGrantAll                         = 'Grant all';
  sGrantForAllGO                    = 'Grant to All with GO';
  sGrantAllGO                       = 'Grant All with GO';
  sGrantAlltoAll                    = 'Grant All to All';
  sRevokeFromAll                    = 'Revoke from all';
  sRevokeAll                        = 'Revoke all';
  sRevokeAllFromAll                 = 'Revoke all from all';
  sParamProp                        = 'Param property';
  sParamName                        = 'Param name';
  sParamType                        = 'Param type';
  sInputOutput                      = 'Input/Output';
  sDefaultValue                     = 'Default value';
  sFirstName                        = 'First name';
  sMiddleName                       = 'Middle name';
  sLastName                         = 'Last name';
  sEditUser                         = 'Edit user';
  sSubType                          = 'Sub type';
  sPackageHeader                    = 'Package header';
  sPackageBody                      = 'Package body';
  aNoAction                         = 'No action';
  aIdentityField                    = 'IDENTITY field';
  sStartWith                        = 'START WITH';
  sCreateTriggerForAutoinc          = 'Create trigger for AUTOINC';
  sTriggerBody                      = 'Trigger body';
  sTriggerDescription               = 'Trigger description';
  sRemoteProcess                    = 'Remote process';
  sRemoteProtocol                   = 'Remote protocol';
  sRemoteAddress                    = 'Remote address';
  sUserRole                         = 'User role';
  sStart1                           = 'Start';
  sAttachmentDB                     = 'Attachment DB';
  sAttachmentID                     = 'Attachment ID';
  sNext                             = 'Next';
  sOldActive                        = 'Old active';
  sOldest                           = 'Oldest';
  sOldSnapshot                      = 'Old snapshot';

  //Object names
  sDomain                           = 'Domain';
  sTable                            = 'Table';
  sToastTable                       = 'Toast table';
  sView                             = 'View';
  sTrigger                          = 'Trigger';
  sStoredProcedure                  = 'Stored procedure';
  sException                        = 'Exception';
  sUDF                              = 'UDF';
  sRole                             = 'Role';
  sGenerator                        = 'Generator';
  sUser                             = 'User';
  sRule                             = 'Rule';
  sIndex                            = 'Index';
  sUniqueConstraint                 = 'Unique constraint';
  sSchemeName                       = 'Scheme name';
  sOther                            = 'Other';
  sEventTrigger                     = 'Event trigger';

  //for object grops
  sDomains                          = 'Domains';
  sTables                           = 'Tables';
  sViews                            = 'Views';
  sIndexs                           = 'Indexs';
  sTriggers                         = 'Triggers';
  sStoredProcedures                 = 'Stored procedures';
  sFunctions                        = 'Functions';
  sProcedures                       = 'Procedures';
  sProcedure                        = 'Procedure';
  sTriggerProc                      = 'Trigger procedures';
  sExceptions                       = 'Exceptions';
  sUDFs                             = 'UDFs';
  sRoles                            = 'Roles';
  sGenerators                       = 'Generators';
  sDescription                      = 'Description';
  sPackages                         = 'Packages';
  sPackage                          = 'Package';
  sCheckConstraint                  = 'Check constraint';
  sSystemDomains                    = 'System domains';
  sSystemTables                     = 'System tables';
  sSystemIndex                      = 'System index';
  sPrimaryKey                       = 'Primary key';
  sPrimaryKeys                      = 'Primary keys';
  sForeignKey                       = 'Foreign key';
  sForeignKeys                      = 'Foreign keys';
  sField                            = 'Field';
  sAutoIncField                     = 'Auto increment field';
  sAutoincremet                     = 'Autoincremet';
  sCalculated                       = 'Calculated';
  sUnique                           = 'Unique';
  sSecurity                         = 'Security';
  sUsers                            = 'Users';
  sGroups                           = 'Groups';
  sSequences                        = 'Sequences';
  sSequence                         = 'Sequence';
  sDependencies                     = 'Dependencies';
  sScheme                           = 'Scheme';
  sSchemes                          = 'Schemes';
  sRules                            = 'Rules';
  sTableSpace                       = 'Table space';
  sLanguage                         = 'Language';
  sTableOwner                       = 'Table owner';
  sUseDefFillFactor                 = 'Use default fill factor';
  sInheritsTableFrom                = 'Inherits table from';
  sWithOIDs                         = 'With OIDs';
  sTemporary                        = 'Temporary';
  sTruncate                         = 'Truncate';
  sPreserveRows                     = 'Preserve rows';
  sDeleteRows                       = 'Delete rows';
  sDropTable                        = 'Drop table';
  sTasks                            = 'Tasks';
  sEventTriggers                    = 'Event triggers';
  sMaterializedViews                = 'Materialized View';
  sExtensions                       = 'Extensions';
  sExtension                        = 'Extension';
  sForeignDataWrapper               = 'Foreign data wrapper';
  sFunction                         = 'Function';
  sSystemCatalog                    = 'System catalog';
  sFieldDependencies                = 'Field Dependencies';
  sForeignKeyRule                   = 'Foreign key rule';


  sSchemeOwner                      = 'Scheme owner';

  sRecords                          = 'records';
  sNew                              = 'New ';
  sDrop                             = 'Drop ';
  sRename                           = 'Rename %s "%s"';
  sNewObject                        = 'New object';
  sDropObject                       = 'Drop object';
  sRenameObject                     = 'Rename object';
  sShutdown                         = 'Shutdown';
  sFile                             = 'File';
  sProcess                          = 'Process';
  sProxy                            = 'Proxy';
  sReload                           = 'Reload';
  sAlter                            = 'Alter';
  sShowDB                           = 'Show databses';
  sSuper                            = 'Super';
  sMembership                       = 'Membership';
  sCreateTmpTable                   = 'Create temp. tables';
  sLockTables                       = 'Lock tables';
  sExecute                          = 'Execute';
  sReplSlave                        = 'Repl. slave';
  sReplClient                       = 'Repl. client';
  sShowView                         = 'Show view';
  sCreateRoutine                    = 'Create routine';
  sAlterRroutine                    = 'Alter routine';
  sCreateUser                       = 'Create user';
  sEvent                            = 'Event';
  sCreateTablespace                 = 'Create tablespace';
  sMaxQueriesPerHour                = 'Max queries per hour';
  sMaxConnectionsPerHour            = 'Max connections per hour';
  sMaxUpdatePerHour                 = 'Max update per hour';
  sMaxUserConnections               = 'Max user connections';


  sRolePropertys                    = 'Role propertys';
  sRoleGrantForUser                 = 'Grant for user';
  sRoleGrantForObjects              = 'Grant for objects';

  sBefore                           = 'Before';
  sAfter                            = 'After';
  sBeforeInsert                     = 'Before insert';
  sAfterInsert                      = 'After insert';
  sBeforeUpdate                     = 'Before update';
  sAfterUpdate                      = 'After update';
  sBeforeDelete                     = 'Before delete';
  sAfterDelete                      = 'After delete';
  sTriggerName                      = 'Trigger name';
  sTriggerActive                    = 'Active';
  sTriggerTable                     = 'For table';
  sTriggerForEvent                  = 'For event';
  sUseExistingFunction              = 'Use existing function';
  sUseExistingGenerator             = 'Use existing generator';
  sCreateNewFunction                = 'Create new function';
  sCreateNewGenerator               = 'Create new generator';
  sCreateNewprocedure               = 'Create new procedure';
  sProcedureName                    = 'Procedure name';
  sOnEvent                          = 'On event';
  sType                             = 'Type';
  sRowScope                         = 'For each';
  sSelect                           = 'Select';
  sInsert                           = 'Insert';
  sInsertOrUpdate                   = 'Insert/Update';
  sUpdate                           = 'Update';
  sDelete                           = 'Delete';
  sDeleteHint                       = 'Delete data';
  sRow                              = 'Row';
  sStatament                        = 'Statament';
  sTriggerOrder                     = 'Order';
  sTableName                        = 'Table name';
  sTriggerType                      = 'Trigger type';
  sTriggerOnInsert                  = 'On insert';
  sTriggerOnUpdate                  = 'On update';
  sTriggerOnDelete                  = 'On delete';
  sConditions                       = 'Conditions';
  sNewDomain                        = 'New Domain';
  sCustomType                       = 'Custom type';
  sReferencesTo                     = 'References to';
  sDefiner                          = 'Definer';
  sTriggerNameTemplate              = 'Trigger name template';
  sTriggerNameTags                  = 'Avaliable tags:'#13'%TABLE_NAME% - Table name'#13'%TRIGGER_TYPE% - Trigger type (BI0, AUD1)';
  sSelectAll                        = 'Select all';
  sUnselectAll                      = 'Unselect all';
  sInvertSelections                 = 'Invert selections';
  sInvoker                          = 'Invoker';

  sDeactivateTrigger                = 'Deactivate trigger';
  sActivateTrigger                  = 'Activate trigger';
  sActivateAllTriggers              = 'Activate all triggers';
  sDeactivateAllTrigger             = 'Deactivate all trigger';
  sRecompileAllTriggers             = 'Recompile all triggers';
  sNewTrigger                       = 'New trigger';
  sModifiTrigger                    = 'Modifi trigger';
  sDeleteTrigger                    = 'Delete trigger';

  sNewRule                          = 'New rule';
  sModifiRule                       = 'Modifi rule';
  sDeleteRule                       = 'Delete rule';
  sRuleName                         = 'Rule name';
  sRelationName                     = 'Relation name';
  sRelationOID                      = 'Relation OID';


  sSQLEditor                        = 'SQL editor';
  sDefaultQuerySet                  = '< Default query set >';
  sDeleteQuery                      = 'Delete wthis query?';
  sDeleteQuerySet                   = 'Delete wthis query set an it''s query''s?';
  sEnterQuerySetName                = 'Enter query set name';
  sQuerySetName                     = 'Query set name';
  sProperty                         = 'Property';
  sCreateView                       = 'Create view';
  sCreateViewHint                   = 'Create new view from current select';
  sCreateSP                         = 'Create SP';
  sCreateSPHint                     = 'Create stored procedure from current query';
  sExecuteQuery                     = 'Execute query';
  sExecuteQueryHint                 = 'Execute query from current editor';
  sExecuteQueryFetchAll             = 'Run query and fetch all';
  sExecuteQueryFetchAllHint         = 'Run query and fetch all';
  sPrepareQuery                     = 'Prepare query';
  sPrepareQueryHint                 = 'Prepare query';
  sShowQueryPlan                    = 'Show query plan';
  sClearCurrentQuery                = 'Clear current query...';
  sNewQuery                         = 'New query';
  sDeleteAll                        = 'Delete all';
  sRenameTab                        = 'Rename tab';
  sRenameTabHint                    = 'Rename edit tab';
  sNewQuerySet                      = 'New query set';
  sNewQuerySetHint                  = 'New query set';
  sClear                            = 'Clear';
  sOpenInEditor                     = 'Open in editor';
  sOpenInEditorHint                 = 'Open text from history in SQL editor';
  sDeleteStatement                  = 'Delete statement';
  sDeleteStatementHint              = 'Delete current statement';
  sCopyToClipboard                  = 'Copy to clipboard';
  sCopyToClipboardHint              = 'Copy current statement to clipboard';
  sCopyAllStatementToClip           = 'Copy all statement to clipboard';
  sCopyAllStatementToClipHint       = 'Copy all statement to clipboard';
  sCommit                           = 'Commit';
  sCommitHint                       = 'Commit transaction';
  sRolback                          = 'Rolback';
  sRolbackHint                      = 'Rolback transaction';
  sPrint                            = 'Print';
  sPrintHint                        = 'Print object';
  sPrintQueryResult                 = 'Print query result';
  sCopyCellValue                    = 'Copy cell value';
  sCopyCollumnFieldTitle            = 'Copy collumn field title';
  sEditor                           = 'Editor';
  sResult                           = 'Result';
  sStatistic                        = 'Statistic';
  sHistory                          = 'History';
  sExecTime                         = 'Exec time :';
  sExecComplete                     = 'Exec complete.';
  sCommitAndClose                   = 'Commit and close';
  sCommitAndCloseHint               = 'Commit and close transaction';
  sRolbackAndClose                  = 'Rolback and close';
  sRolbackAndCloseHint              = 'Rolback and close transaction';
  sCompile                          = 'Compile';
  sCompileHint                      = 'Compile object';
  sSQLParseError                    = 'Error in SQL text';
  sCommonQuery                      = 'Common query';
  sSelectedRowsInfo                 = 'Selected rows : %d';
  sInsertedRowsInfo                 = 'Inserted rows : %d';
  sUpdatedRowsInfo                  = 'Updated rows : %d';
  sDeletedRowsInfo                  = 'Deleted rows : %d';
  sWithDataType                     = 'With data type';
  sSeparator                        = 'Separator';
  sShowAllGrants                    = 'Show all';
  sShowOnlyGrants                   = 'Show only with grants';
  sShowOnlyNotGrants                = 'Show only without grants';


  sSuccesConnection                 = 'Successful connection';
  sNotConnected                     = 'Not connected...';
  sExecutionComplete                = 'Execution complete. Execute time : %s.';

  sDescriptionChange                = 'Description change';
  sDescriptionChangeQ               = 'Description change. Save it?';
  sPasswordMismath                  = 'Password mismath.';
  sDelUserConfirm                   = 'Are you sure thet want to delete user %s?';
  sFucntNotComplete                 = 'Function not complete...';
  sNeedRestartConfigCh              = 'You are need restart for apply you changes...';
  sInvalidPath                      = 'Path %s is not valid';
  sUnregisterDatabase               = 'Unregister database?';
  sCreateShadow                     = 'Create shadow?';
  sDropShadow                       = 'Drop shadow?';
  sFilesFilterSQL                   = 'Sql files (*.sql)|*.sql|All files (*)|*';
  sPrecompileError                  = 'Precompiler error.';
  sRecordCount                      = '%d records in table';
  sRecordCountGet                   = 'Get record count';
  sFileNotFound                     = 'File %s not found.';
  sFieldNameReq                     = 'Requared field name.';
  sFieldTypeReq                     = 'Requared field type or domain.';
  sFieldInitialValueReq             = 'For NOT NULL fields you must specify an initial value';
  sUnkonwPGFuncCategor              = 'Unknow function category - %d';
  sEnterDefValue                    = 'Enter default value';
  sEnterDefValueForNotNull          = 'Enter default value for NOT NULL field. String field needs "''".';
  sCountRowToFetch                  = 'Count row to fetch';
  sSQLBuilder                       = 'SQL builder';

  sOptions                          = 'Options';
  sIndexNameIsEmpty                 = 'Index name is empty';
  sDuplicateIndexName               = 'Duplicate index name';
  sSingleFileBackup                 = 'Single file backup';
  sSingleFileRestore                = 'Single file restore';
  sRestoreOptons                    = 'Restore optons';
  sSeparetedFiles                   = 'Separeted files';
  sBackupOptions                    = 'Backup options';
  sIgnoreChecksums                  = 'Ignore checksums';
  sIgnoreLimbo                      = 'Ignore Limbo';
  sMetadataOnly                     = 'Metadata Only';
  sNoGarbageCollection              = 'No Garbage Collection';
  sOldMetadataDesc                  = 'Old Metadata Desc';
  sNonTransportable                 = 'Non Transportable';
  sConvertExtTables                 = 'Convert Ext Tables';
  sExpand                           = 'Expand';
  sLogToFile                        = 'Log to file';
  sLogToScreen                      = 'Log to screen';
  sDeactivateIndexes                = 'Deactivate Indexes';
  sNoShadow                         = 'No Shadow';
  sNoValidityCheck                  = 'No Validity Check';
  sOneRelationAtATime               = 'One Relation At A Time';
  sCreateNewDB                      = 'Create New DB';
  sUseAllSpace                      = 'Use All Space';
  sValidate                         = 'Validate';


  sSQLDialect                       = 'SQL Dialect';
  sSweepInterval                    = 'Sweep interval';
  sPages                            = 'Pages';
  sKB                               = 'KB';
  sBuffers                          = 'Buffers';
  sForcedWrite                      = 'Forced write';
  sReadOnly                         = 'Read only';
  sActiveUsers                      = 'Active users';
  sAliasOfDB                        = 'Alias of %s';
  sAliasOfObj                       = 'Alias of %s';
  sGeneral                          = 'General';
  sLogFiles                         = 'Log files';
  sBackup                           = 'Backup';
  sRestore                          = 'Restore';
  sPage                             = 'Page ';
  sEnterName                        = 'Enter name';
  sSQLPageName                      = 'SQL page name';
  sSearchReplace                    = 'Replace';
  sSearchCaption                    = 'Search';
  sForward                          = '&Forward';
  sBackward                         = '&Backward';
  sDirection                        = 'Direction';
  sSearchFor                        = '&Search for:';
  sReplaceWith                      = '&Replace with:';
  sSearchWholeWords                 = '&Whole words only';
  sSearchSelectedOnly               = 'Selected &text only';
  sSearchFromCursor                 = 'Search from &caret';
  sSearchRegExp                     = '&Regular expressions';

  sLastValue                        = 'Last value';
  sIncrement                        = 'Increment';
  sMaxValue                         = 'Max value';
  sMinValue                         = 'Min value';
  sStartValue                       = 'Start value';
  sIsCycled                         = 'Is cycled';
  sCache                            = 'Cache';

  sConfirm                          = 'Confirm';
  sQuestion                         = 'Question';
  sError                            = 'Error';
  sInformation                      = 'Information';
  sFuntionNotComplete               = 'Funtion not complete...';

  sCopyOf                           = 'Copy of : ';
  sINS                              = 'INS';
  sREPL                             = 'REPL';
  sModified                         = 'Modified';

  sCheckName                        = 'Check name';
  sCheckBody                        = 'Check body';
  sTableCheckConstraint             = 'Table check constraint';
  sConstraintNew                    = 'New constraint';
  sConstraintEdit                   = 'Edit constraint';
  sConstraintDelete                 = 'Delete constraint';
  sServerVersion1                   = 'Server version';
  sShowSystemObjects                = 'Show system objects';
  sShowAdditionalInformation        = 'Show additional information for object (fields/params/etc...)';
  sAutoGrantOnCompileObject         = 'Auto grant on compile object';
  sFetchAllDataFromTable            = 'Fetch all data from table';
  sAlwaysCapitalizeDBObjectsNames   = 'Always capitalize database objects names';
  sOtherOptions                     = 'Other options';
  sFileName                         = 'File name';
  sCompileOptions                   = 'Compile options';
  sAutoVacuum                       = 'Auto vacuum';
  sEncoding                         = 'Encoding';
  sCollationList                    = 'Collation list';
  sTempStoreDirectory               = 'Temp store directory';
  sLegacyFileFormat                 = 'Legacy file format';
  sDataVersion                      = 'Data version';
  sDatabaseList                     = 'Database list';
  sDefaultCacheSize                 = 'Default cache size';
  sCacheSize                        = 'Cache size';
  sMaxPageCount                     = 'Max page count';
  sJournalMode                      = 'Journal mode';
  sJournalSizeLimit                 = 'Journal size limit';
  sLockingMode                      = 'Locking mode';
  sSynchronous                      = 'Synchronous';
  sFullfSync                        = 'Full file sync';
  sAnalyzeScaleFactorHint           = 'Number of tuple inserts, updates, or deletes prior to analyze as a fraction of reltuples';
  sVacuumThresholdHint              = 'Minimum number of tuple updates or deletes prior to vacuum';
  sAnalyzeThresholdHint             = 'Minimum number of tuple inserts, updates, or deletes prior to analyze';
  sVacuumScaleFactorHint            = 'Number of tuple updates or deletes prior to vacuum as a fraction of reltuples';
  sVacuumCostDelayHint              = 'Vacuum cost delay in milliseconds, for autovacuum (ms)';
  sVacuumCostLimitHint              = 'Vacuum cost amount available before napping, for autovacuum';
  sFreezeMinAgeHint                 = 'Minimum age at which VACUUM should freeze a table row';
  sFreezeMaxAgeHint                 = 'Age at which to autovacuum a table to prevent transaction ID wraparound';
  sFreezeTableAgeHint               = 'Age at which VACUUM should scan whole table to freeze tuples';

  sCurrentValue                     = 'Current value';
  sAutovacuumEnabled                = 'Autovacuum enabled';
  sVacuumThreshold                  = 'Vacuum threshold';
  sAnalyzeThreshold                 = 'Analyze threshold';
  sVacuumScaleFactor                = 'Vacuum scale factor';
  sAnalyzeScaleFactor               = 'Analyze scale factor';
  sVacuumCostDelay                  = 'Vacuum cost delay';
  sVacuumCostLimit                  = 'Vacuum cost limit';
  sFreezeMinAge                     = 'Freeze min age';
  sFreezeMaxAge                     = 'Freeze max age';
  sFreezeTableAge                   = 'Freeze table age';

  sToastAutovacuumEnabled           = 'Toast - autovacuum enabled';
  sToastVacuumThreshold             = 'Toast - vacuum threshold';
  sToastVacuumScaleFactor           = 'Toast - vacuum scale factor';
  sToastVacuumCostDelay             = 'Toast - vacuum cost delay';
  sToastVacuumCostLimit             = 'Toast - vacuum cost limit';
  sToastFreezeMinAge                = 'Toast - freeze min age';
  sToastFreezeMaxAge                = 'Toast - freeze max age';
  sToastFreezeTableAge              = 'Toast - freeze table age';


  sServerName                       = 'Server name    = ';
  sDBName                           = 'Data base name = ';
  sUserName                         = 'UserName       = ';
  sClientLib                        = 'Client lib     = ';
  sRoleName                         = 'Role           = ';
  sDialect                          = 'Dialect        = ';
  sServerVersion                    = 'Server version = ';
  sODSVersion                       = 'ODS version    = ';
  sPageSize                         = 'Page size      = ';
  sPageSize1                        = 'Page size';
  sPageCount                        = 'Page count     = ';
  sDBFileSize                       = 'DB file size   = ';
  sDBCharset                        = 'DB Char Set    = ';

  sAppVersion                       = 'Version : ';
  sLCLVersion                       = 'LCL Version: ';
  sBuildDate                        = 'Build date : ';
  sFpcVersion                       = 'FPC version : ';
  sTargetCPU                        = 'Target CPU : ';
  sTargetOS                         = 'Target OS : ';
  sSVNRevision                      = 'SVN revision : ';
  sWidget                           = 'Widget : ';
//  sGTKWidgetSet                     = 'GTK widget set';
//  sGTK2WidgetSet                    = 'GTK 2 widget set';
//  sWin32_64WidgetSet                = 'Win32/Win64 widget set';
//  sWinCEWidgetSet                   = 'WinCE widget set';
//  sCarbonWidgetSet                  = 'Carbon widget set';
//  sQTWidgetSet                      = 'QT widget set';
//  sFpGUIWidgetSet                   = 'FpGUI widget set';
//  sCocoaWidgetSet                   = 'Cocoa widget set';
//  sOtherGUIWidgetSet                = 'Other gui';

  sTableEditor                      = 'Table editor';

  sIndexOnTable                     = 'Indexs on table : ';
  sTable1                           = 'Table : ';
  sFields                           = 'Fields';
  sData                             = 'Data';
  sRecFromTable                     = 'Records from table : ';
  sRecordFetched                    = '%d record fetched';
  sRecordFetchedWithSelected        = '%d record fetched (%d selected)';
  sBugTrackerServName               = 'Shamangrad bugtracker service...';
  sFBManagerWebSite                 = 'FBManager web site...';

  sStoredProcedureName              = 'Procedure name';
  sFunctionName                     = 'Function name';
  sReturnType                       = 'Return type';
  sAVGTime                          = 'AVG Time';
  sAVGLines                         = 'AVG lines';
  sTimeLife                         = 'Time life';
  sIsWindowFunction                 = 'Is window function';
  sRunAsOwner                       = 'Run as owner';
  sReturnNullForEmptyResult         = 'Return null for empty result';
  sTypeReturns                      = 'Type returns';
  sTypeReturns1                     = 'Single value';
  sTypeReturns2                     = 'Set of values';
  sTypeReturns3                     = 'Table';
  sDeclaration                      = 'Declaration';
  sParams                           = 'Params';
  sLocalVariables                   = 'Local variables';
  sAddParam                         = 'Add param';
  sEditParam                        = 'Edit param';
  sDeleteParam                      = 'Delete param';
  sMoveUp                           = 'Move up';
  sMoveDown                         = 'Move down';
  sPrintParams                      = 'Print params';
  sAddLocalVar                      = 'Add local variable';
  sEditLocalVar                     = 'Edit local variable';
  sDeleteLocalVar                   = 'Delete local variable';
  sDeleteLocalVarQuest              = 'Delete local variable %s?';
  sMoveUpLocalVar                   = 'Move up local variable';
  sMoveDownLocalVar                 = 'Move down local variable';
  sPrintLocalVar                    = 'Print local variable';
  sParamsHistory                    = 'Params history';
  sFillQueryParam                   = 'Fill query param';
  sInputParams                      = 'Input params';
  sReturnParams                     = 'Return params';
  sShowObjTree                      = 'Show objects tree';
  sShowObjTreeHint                  = 'Show objects tree';
  sCommentCmd                       = 'Comment selection';
  sCommentCmdHint                   = 'Comment selection';
  sUnCommentCmd                     = 'Uncomment selection';
  sDeleteCmd                        = 'Remove selection';
  sDeleteCmdHint                    = 'Remove selection';
  sShowDML                          = 'Show DML statemenst';
  sShowDMLHint                      = 'Show DML statemenst';
  sDeleteField                      = 'Delete field "%s"?';
  sDefineVariable                   = 'Define variable';
  sDefineInParam                    = 'Define input param';
  sDefineOutParam                   = 'Define output param';
  sDefineInOutParam                 = 'Define In/Out param';
  sDeterministic                    = 'Deterministic';
  sSubroutines                      = 'Nested function/procedures';
  sDeleteFunctionQ                  = 'Delete function "%s"?';
  sDeleteFunctionHint               = 'Delete nested function';
  sAppendFunctionHint               = 'Create new nested function';
  sAppendFunctionQ                  = 'Create new nested function?';
  sFunctionType                     = 'Function type';
  sProcedureType                    = 'Procedure type';
  sSQLSecurity                      = 'Sql security';
  sSQLDataAcess                     = 'SQL data acess';

  sDomainName                       = 'Domain name';
  sNotNull                          = 'Not null';
  sSize                             = 'Size';
  sPrec                             = 'Prec';
  sScale                            = 'Scale';
  sCharSet                          = 'Char set';
  sCollate                          = 'Collate';
  sDefault                          = 'Default';
  sCheck                            = 'Check';
  sArray                            = 'Array';
  sExceptionName                    = 'Exception name';
  sExceptionMessage                 = 'Exception message';
  sGeneratorName                    = 'Generator name';
  sGeneratorValue                   = 'Generator value';
  sIsLocal                          = 'Is local';

  sGroup                            = 'Group';
  sGroupName                        = 'Group name';
  sObjectID                         = 'Object ID';
  sMembers                          = 'Members';
  sPGValidUntil                     = 'Valid until';
  sPGUSerName                       = 'User name';
  sPGNeverExpired                   = 'Never expired';
  sPGMaxConnection                  = 'Max. connections';
  sPGPassword                       = 'Password';
  sPGConfirmPassword                = 'Confirm password';
  sPGRolePrivilege                  = 'Role privilege';

  sPGLoginEnabled                   = 'Login enabled';
  sPGInheritedRight                 = 'Inherited right from owner roles';
  sPGSuperuser                      = 'Superuser';
  sPGAllowCreateDBObjects           = 'Allow create database objects';
  sPGAllowCreateRoles               = 'Allow create roles';
  sPGAllowChangeSystemCatalog       = 'Allow change system catalog directly';
  sPGAllowCreateReplications        = 'Allow create replications and backup';



  sPGPgSqlFunction                  = 'PG : function';
  sPGPgSqlFunctionLazy              = 'PG : function lazy mode';
  sPGPgSqlTrigger                   = 'PG : trigger';

  sFBSqlTrigger                     = 'FB : trigger';
  sFBSqlTriggerLazy                 = 'FB : trigger lazy mode';
  sFBSqlFunction                    = 'FB : function';
  sFBSqlFunctionLazy                = 'FB : function lazy mode';
  sFBSqlPackage                     = 'FB : package';
  sFBSqlPackageLazy                 = 'FB : package lazy mode';

  sMySQLSqlTrigger                     = 'MySQL : trigger';
  sMySQLSqlTriggerLazy                 = 'MySQL : trigger lazy mode';


  sRegister                         = 'Register ';
  sCreateDB                         = 'Create ';
  sRegistrationParams               = 'Registration params';
  sTest                             = 'Test';

  sConstraintName                   = 'Constraint name';
  sOnField                          = 'On field';
  sExtrenalTable                    = 'External table';
  sExtrenalField                    = 'External field';
  sUpdateRule                       = 'Update rule';
  sIndexName                        = 'Index name';
  sIndexSort                        = 'Index sort';
  sSortOrder                        = 'Sort order';
  sAscending                        = 'Ascending';
  sDescending                       = 'Descending';
  sNullsFirst                       = 'Nulls first';
  sNullsLast                        = 'Nulls last';
  sInput                            = 'Input';
  sOutput                           = 'Output';
  sKeyWord                          = 'keyword';
  sKeyFunction                      = 'function';
  sKeyTypes                         = 'types';
  sTriggersList                     = 'Triggers list';
  sAddField                         = 'Add field';
  sAddAllFields                     = 'Add all fields';
  sRemoveField                      = 'Remove field';
  sRemoveAllFields                  = 'Remove all fields';
  sSeparatedPpages                  = 'Separated pages';
  sDontLockOnCreation               = 'Dont lock on creation';
  sForTable                         = 'For table';
  sAccessMetod                      = 'Access metod';
  sFillfactor                       = 'Fillfactor';
  sConditionForPartialIndex         = 'Condition for partial index';
  sNullsPos                         = 'Nulls pos';
  sLanguageName                     = 'Language name';
  sHandlerFunction                  = 'Handler function';
  sValidatorFunction                = 'Validator function';
  sTrusted                          = 'Trusted';
  sExtrenalFile                     = 'Extrenal file';
  sNormalMode                       = 'Normal mode';
  sGlobalTemporaryTable             = 'Global Temporary Table';
  sOnCommitDeleteRows               = 'ON COMMIT DELETE ROWS';
  sOnCommitPreserveRows             = 'ON COMMIT PRESERVE ROWS';
  sOID                              = 'OID';
  sSchemaOID                        = 'Schema OID';
  sToastOID                         = 'Toast OID';
  sOIDFunction                      = 'Function OID';
  sOIDTable                         = 'Table OID';
  sTableSize                        = 'Table size';
  sTotalSize                        = 'Total size';
  sToastSize                        = 'Toast size';
  sIndexSize                        = 'Index size';
  sStatRecordCount                  = 'Record count for statistic';
  sStatPageCount                    = 'Page count for statistic';
  sNoHandler                        = 'No handler';
  sNoValidator                      = 'No validator';


  sNewForeignKey                    = 'New foreign key';
  sDropForeignKey                   = 'Drop foreign key';
  sPrintFKList                      = 'Print FK list';
  sValue                            = 'Value';
  sChangeCount                      = 'Change count';

  //Tasks
  sShedule                          = 'Shedule';
  sDays                             = 'Days';
  sTimes                            = 'Times';
  sExcep                            = 'Excep';
  sDayOfWeek                        = 'Day of week';
  sDayOfMonth                       = 'Day of month';
  sMonth                            = 'Month';
  sHours                            = 'Hours';
  sMinutes                          = 'Minutes';
  sCaption                          = 'Caption';
  sEnabled                          = 'Enabled';
  sDateStart                        = 'Date start';
  sDateFinish                       = 'Date finish';
  sTime                             = 'Time';
  sSqlBody                          = 'Sql body';
  sStepName                         = 'Step name';
  sDatabaseOnCurrentServer          = 'Database on current server';
  sConnectionString                 = 'Connection string';
  sCopyConnectionString             = 'Copy connection string';
  sConnectionStringCopied           = 'Connection string has been successfully copied to clipboard.';


  sSteps                            = 'Steps';
  sStep                             = 'Step';
  sTaskName                         = 'Task name';
  sTaskID                           = 'Task ID';
  sTaskClass                        = 'Task class';
  sDateCreated                      = 'Date created';
  sDateModified                     = 'Date modified';
  sLastRun                          = 'Last run';
  sNextRun                          = 'Next run';
  sTask                             = 'Task';
  sLogs                             = 'Logs';
  sFromDate                         = 'From date';
  sToDate                           = 'To date';
  sRefresh                          = 'Refresh';
  sRefreshHint                      = 'Refresh';
  sRefreshDataHint                  = 'Refresh data';
  sID                               = 'ID';
  sJobID                            = 'Job ID';
  sStart                            = 'Start date';
  sDuration                         = 'Duration';
  sStatus                           = 'Status';
  sRuning                           = ' - running';
  sSuccessfullyFinished             = ' - successfully finished';
  sFailed                           = ' - failed';
  sNoStepsToExecute                 = ' - no steps to execute';
  sAborted                          = ' - aborted';
  sBackupSuccessfullyFinished       = 'Backup successfully finished';
  sRestoreSuccessfullyFinished      = 'Restore successfully finished';
  sRefreshInterval                  = 'Refresh interval';
  sConversion                       = 'Conversion';
  sServer                           = 'Server';
  sColumn                           = 'Column';
  sCollation                        = 'Collation';
  sFilter                           = 'Filter';
  sParameter                        = 'Parameter';
  sAccessMethod                     = 'AccessMethod';
  sAggregate                        = 'Aggregate';
  sMaterializedView                 = 'MaterializedView';
  sCast                             = 'Cast';
  sConstraint                       = 'Constraint';
  sForeignTable                     = 'Foreign table';
  sForeignServer                    = 'Foreign server';
  sLargeObject                      = 'LargeObject';
  sPolicy                           = 'Policy';
  sAutoIncFields                    = 'AutoIncFields';
  sFTSConfig                        = 'FTSConfig';
  sFTSDictionary                    = 'FTSDictionary';
  sFTSParser                        = 'FTSParser';
  sFTSTemplate                      = 'FTSTemplate';
  sTransform                        = 'Transform';
  sOperator                         = 'Operator';
  sOperatorClass                    = 'OperatorClass';
  sOperatorFamily                   = 'OperatorFamily';
  sUserMapping                      = 'UserMapping';
  sFieldFromNamedSelect             = 'field from named select %s';

  sBuildConnectionString            = 'Build connection string';
  sRegistredDatabase                = 'Registred database';
  sEnterValues                      = 'Enter values';
  sHostName                         = 'Host name';
  sDatabaseName                     = 'Database name';
  sPort                             = 'Port';
  sPassword                         = 'Password';
  sConfirmPassword                  = 'Confirm password';

  //const from fb_VisualToolsCallUnit
  sFireBiredDBStat                  = 'Firebird DB Statistic';
  sFireBiredDBBackup                = 'Firebird Database Backup';
  sFireBiredDBRestore               = 'Firebird Database Restore';
  sFireBiredDBShadMan               = 'Firebird DB Shadow manager';
  sFireBiredDBTransMon              = 'Firebird Tranaction monitor';
  sFireBiredUserManag               = 'Firebird user manager';

  sFBTranParamsSnapshot             = 'Snapshot';
  sFBTranParamsReadCommited         = 'Read commited';
  sFBTranParamsReadOnlyTableStab    = 'Read-only table stability';
  sFBTranParamsReadWriteTableStab   = 'Read-write table stability';

  //const from fbmTransactionMonitorUnit
  sFBTranOldestActive               = 'Oldest active';
  sFBTranOldestTran                 = 'Oldest transaction';
  sFBTranOldestSnaps                = 'Oldest snapshot';
  sFBTranNextTrans                  = 'Next transaction';

  //const from pg_VisualToolsCallUnit
  sPostgreSQLDBStat                 = 'Postgres server status';
  sPostgreSQLTableCreateProc        = 'Create procedures';
  sPostgresDBAnaliz                 = 'PG DB Analiz';
  sSQLiteDBStat                     = 'SQLite database status';

  sObjectInspector                  = 'Object inspector';
  sGridOptions                      = 'Grid options';
  sReportsOptions                   = 'Reports options';
  sSQLEditorOptions                 = 'SQL editor options';
  sCompatibility                    = 'Compatibility';
  sFBGloballTransactionProperties   = 'Transaction properties';
  sFBTransactionProperties          = 'Transaction properties';
  sDisplayTableDataProperties       = 'Display data properties';
  sConfirmOptions                   = 'Confirmation';
  sShowObjectDescriptionsAsHint     = 'Show object descriptions as hint';
  sDisableResize                    = 'Disable resize';
  sInterfaceLanguage                = 'Interface language';
  sHintColor                        = 'Hint color';
  sSaveDesktopOnDisconectFromDB     = 'Save desktop on disconect from DB';
  sButtonGlyph                      = 'Button glyph';
  sAlwaysShowGlyph                  = 'Always show glyph';
  sNeverShowGlyph                   = 'Never show glyph';
  sShowObjectNameInObjectEditorForm = 'Show object name in object editor form';
  sFlatButtonsInTaskBar             = 'Flat buttons in task bar';
  sMDICloseByF4                     = 'Close child window by Ctrl+F4';
  sMDISwitchByTab                   = 'Switch child windows by Ctrl+Tab';
  sAskBeforeCloseAllWindows         = 'Ask before close all windows';

  sConfirmExit                      = 'Confirm exit';
  sConfirmCompileObjectsDescription = 'Confirm compile objects description';
  sConfirmCompileObjectGrants       = 'Confirm compile object grants';
  sConfirmExecute                   = 'Confirm execute';
  sExecuteSelectedPartOnly          = 'Execute selected part only';
  sExecuteEntireScript              = 'Execute entire script';
  sExecuteAllFilesFromList          = 'Execute all files from list';
  sAddFile                          = 'Add file';
  sRemoveFile                       = 'Remove file';

  sUseTableAlisInCreateSQLForm      = 'Use table name as alis in create SQL form';
  sShowResultGridOnFirstPage        = 'Show result grid on first page';
  sFetchAll                         = 'Fetch all';
  sGoToResultTabAfterExecute        = 'Go to Result tab after execute';
  sCountSQLEditorHistoryRecords     = 'Count SQL Editor history records';
  sSQLHistoryColors                 = 'SQL history colors';
  sSELECTColor                      = 'SELECT color';
  sINSERTColor                      = 'INSERT color';
  sUPDATEColor                      = 'UPDATE color';
  sDELETEColor                      = 'DELETE color';
  sGridStile                        = 'Grid stile';
  sLazarus                          = 'Lazarus style';
  sStandart                         = 'Standart';
  sNative                           = 'Native';
  sDateSeparator                    = 'Date separator';
  sThousandSeparator                = 'Thousand separator';
  sFieldsFormat                     = 'Fields format';
  sDate                             = 'Date';
  sTimeStamp                        = 'TimeStamp';
  sNumeric                          = 'Numeric';
  sInteger                          = 'Integer';
  sSelectFontForPrint               = 'Select font for print';
  sItsExample                       = 'Its example';
  sShowDesigner                     = 'Show designer';
  sGlobal                           = 'Global';
  sDisplay                          = 'Display';
  sColor                            = 'Color';
  sDisplayFont                      = 'Display font';
  sSelectFont                       = 'Select font';
  sUpperCase                        = 'Upper case';
  sLowerCase                        = 'Lower case';
  sNameCase                         = 'Name case';
  sFirstLetter                      = 'First letter';
  sFontSize                         = 'Font size';
  sDisableAntialiased               = 'Disable antialiased';
  sShowLineNumbers                  = 'Show line numbers';
  sShowOnlyLineNumber               = 'Show only line number';
  sShowRightBorder                  = 'Show right border';
  sEditorOptions                    = 'Editor options';
  sSyntaxHighlight                  = 'Syntax highlight';
  sCaretAlwaysVisible               = 'Caret always visible';
  sSystemCommentStyle               = 'System comment style';
  sComFBMStyle                      = 'Use FBManager style /*$$FBMC$$*/';
  sComIBEStyle                      = 'Use IBExpert style /*$$IBEC$$*/';
  sBackground                       = 'Background';
  sForeground                       = 'Foreground';
  sUnderline                        = 'Underline';
  sStrings                          = 'Strings';
  sComment                          = 'Comment';
  sNumbers                          = 'Numbers';
  sCommitTransactionOnRefresh       = 'Commit transaction on refresh';
  sShowObjectOnGrantPageDefault     = 'Show object on grant page default';
  sCreateIndexAfterCreateFK         = 'Create index after create FK';
  sShowAllObjects                   = 'Show all objects';
  sOnlyShowUsers                    = 'Only show users';
  sOnlyShowGroups                   = 'Only show groups';
  sHotTrack                         = 'Hot track mouse cursor';
  sDisplayMemoValuesAsText          = 'Display memo values as text';
  sFilterStyle                      = 'Filter style';
  sSimple                           = 'Simple';
  sDialog                           = 'Dialog';
  sManualEdit                       = 'Manual edit';
  sBoth                             = 'Both';
  sMDIOptions                       = 'MDI options';
  sMDIMidleClickCloseForm           = 'Midle click close form';
  sMDIShowFormCaptions              = 'Show form captions';
  sMDIShowCloseButton               = 'Show close button';
  sRecordForFetch                   = 'Record for fetch';
  sInitialValueForNewSequence       = 'Initial value for new sequence';
  sAlternateColor                   = 'Alternate color';
  sAllowMultiselect                 = 'Allow multiselect';
  sStripyGrids                      = 'Stripy grids';
  sEnableTooltips                   = 'Enable tooltips';
  sEnableSetWGOFromPopup            = 'Enable set "With Grant Options" from popup menu';

  sFilterInTable                    = 'Filter in table';
  sFilterInTableHint                = 'Show filter in table';
  sSummaryLine                      = 'Summary line';
  sSummaryLineHint                  = 'Show summary line';
  sCopySelectedRecordAsInsert       = 'Copy selected record(s) as INSERT';
  sCopySelectedRecordAsUpdate       = 'Copy selected record(s) as UPDATE';
  sEnterTableName                   = 'Enter table name';
  sSSHFilePath                      = 'SSH file path';
  sSSHPassFilePath                  = 'SSHPass file path';
  sSSHConnectionPlugin              = 'SSH сonnection plugin';



  sShowObjects                      = 'Show objects';

  sGSLazarus                        = 'Lazarus';
  sGSStandart                       = 'Standart';
  sGSNative                         = 'Native';

  sObjectTypes                      = 'Object type''s';
  sObjectType                       = 'Object type';
  sObjectName                       = 'Object name';
  sFieldName                        = 'Field name';
  sFieldType                        = 'Field type';
  sDependCaption1                   = 'Objects, that depend on %s';
  sDependCaption2                   = 'Objects, that %s depends on';
  sCollumnName                      = 'Collumn name';
  sDataType                         = 'Data type';
  sSkipEmpty                        = 'Skip empty';

  sTemplateName                     = 'Template name';
  sEnterTemplateName                = 'Enter template name';
  sDeleteTemplateQ                  = 'Delete template?';
  sLoadDefaultTemplatesQ            = 'Load default templates?';
  sScriptTextModified               = 'Script modified. Save?';
  sConfirmExitQuestion              = 'You sure you exit the program?';
  sDeleteParamQst                   = 'Delete this parametr?';
  sDeleteCheckQst                   = 'Delete this check constraint?';

  sDBNavHintFirst                   = 'First';
  sDBNavHintPrior                   = 'Prior';
  sDBNavHintNext                    = 'Next';
  sDBNavHintLast                    = 'Last';
  sDBNavHintInsert                  = 'Insert';
  sDBNavHintDelete                  = 'Delete';
  sDBNavHintEdit                    = 'Edit';
  sDBNavHintPost                    = 'Post';
  sDBNavHintCancel                  = 'Cancel';
  sDBNavHintRefresh                 = 'Refresh';


  sSynComDesCreateDomain            = 'Create domain'; //Создать домен
  sSynComDesExecProc                = 'Execute procedure'; // Выполнить процедуру
  sSynComDesForignKey               = 'Forign key'; //Внешний ключ
  sSynComDesIterateTable            = 'Iterate table'; //Цикл по таблице
  sSynComDesGroupBy                 = 'group by ';
  sSynComDesGrantAll                = 'Grant all for object';
  sSynComDesInsTable                = 'Insert into table'; //Вставка в таблицу
  sSynComDesExecBlock               = 'Execute block'; //Создать блок
  sSynComDesDeclIntVar              = 'Declare integer variable'; //Объявление целочисленной переменной
  sSynComDesDeclDateVar             = 'Declare date variable'; //Объявление переменной типа ДАТА
  sSynComDesDeclVar                 = 'Declare variable'; //Объявление переменной


  sLinkPropLabel1                   = 'Join tables: %s and %s';
  sLinkPropIncludeAllFrom           = 'Include all from %s';
  sUnlinkTable                      = 'Unlink table';
  sRenameTable                      = 'Rename table';
  sDeleteTable                      = 'Delete table';
  sDefaultCharacterSet              = 'Default character set';
  sDefaultUserName                  = 'Default user name';
  sDefaultPassword                  = 'Default password';
  sDefaultServerVersion             = 'Default server version';

  //DB Objects editors

  //MSSQL - в дальнейшем можно выложить в отдельный файл
  sFreeTdsConfigEditor            = 'Free tds config editor...';
  sFreeTdsDeleteAlias             = 'Delete this alias?';
  sFilesFilterCfg                 = 'Config files (*.cfg)|*.cfg|All files (*)|*';

  //SQL editor
  sSaveAs                         = 'Save as ...';
  sSaveAsHint                     = 'Save file with new name';
  sSetBookmarkNum                 = 'Set/Remove bookmark ';
  sGotoBookmark                   = 'Goto bookmark ';
  sInvertCase                     = 'Invert case';
  sCodeExploer                    = 'Code exploer';
  sFind                           = 'Find';
  sFindNext                       = 'Find next';
  sReplace                        = 'Replace';
  sSave                           = 'Save';
  sLoad                           = 'Load';
  sOpen                           = 'Open';
  sUndo                           = 'Undo';
  sUndoHint                       = 'Undo last editor changes';
  sRedo                           = 'Redo';
  sRedoHint                       = 'Redo last editor changes';
  sPaste                          = 'Paste';
  sCut                            = 'Cut';
  sCutHint                        = 'Cut text to clipboard';
  sCopyHint                       = 'Copy text to clipboard';
  sPasteHint                      = 'Paste text from clipboard';
  sCopy                           = 'Copy';
  sOpenFile                       = 'Open file';
  sOpenFileHint                   = 'Open file';
  sSaveFile                       = 'Save file';
  sSaveFileHint                   = 'Save file';
  sExportData                     = 'Export data...';
  sExportDataHint                 = 'Export data from object...';
  sExportDataToPDF                = 'Export data to PDF';
  sExportDataToSpreadsheet        = 'Export data to Spreadsheet';

  sMisk                           = 'Misk';
  sLazzyModeLocalVariablesSP      = 'Lazzy mode local variables in SP';
  sLazzyModeLocalVariablesTrigger = 'Lazzy mode local variables in triggers';
  sReportFolder                   = 'Report folder';
  sReportManager                  = 'Report manager';
  sRun                            = 'Run';
  sRunHint                        = 'Run object';
  sRunScriptHint                  = 'Run SQL script';
  sStop                           = 'Stop';
  sStopHint                       = 'Stop execute script';
  sDesignReport                   = 'Design report';
  sSelectRootFolder               = 'Select root folder';
  sTextToSQLEditor                = 'Text to SQL editor';
  sCriteria                       = 'Criteria';
  sSelections                     = 'Selections';
  sSorting                        = 'Sorting';
  sBuilder                        = 'Builder';
  sLinkPropertys                  = 'Link propertys';
  sJoinTablesAnd                  = 'Join tables: %s and %s';
  sIncludeAllFrom                 = 'Include all from %s';
  sApply                          = 'Apply';
  sUsePGShedule                   = 'Use pgShedule (if avaliable)';
  sUsePGBouncer                   = 'Connecting via pgBouncer';
  sSrcPageName                    = 'Source page name';
  sAvallableTags                  = 'Avallable tags:';
  sToInsertTableName              = '%TABLE_NAME% - to insert table name';
  sToInsertFieldName              = '%FIELD_NAME% - to insert field name';
  sToInsertTriggerName            = '%TRIGGER_NAME% - to insert trigger name';
  sToInsertGeneratorName          = '%GENERATOR_NAME% - to insert generator name';
  sToInsertTableShemaName         = '%TABLE_SCHEMA_NAME% - to insert table shema name';
  sGeneratorNameTemplate          = 'Generator name template';
  sTriggerText                    = 'Trigger text';
  sDefaultDescription             = 'Default description';

  //Editor options dialog
  sTabCodeCompletionParams        = 'Codetools and auto code completion';
  sKeywordCharCase                = 'Keyword  char case';
  sIdentifiersCharCase            = 'Identifiers char case';
  sHighlightCurrentWord           = 'Highlight current word';
  sEnableAutocompletion           = 'Enable autocompletion';
  sHighlightDelay                   = 'delay %d ms';

  sCloseWindows                   = 'Close';
  sCloseAllExceptThis             = 'Close all except this';
  sCloseAllWindows                = 'Close all';


  sAbout                            = 'About';
  sMainCaption                      = 'Free Database Manager';
  sMainSlogan                       = 'Easy and free control you database';
  sLicense                          = 'License';



  sMemoValue                        = 'Memo value';
  sAsText                           = 'As text';
  sAsImage                          = 'As image';

  sFKDlgErr1                        = 'Not define FK field on main table';
  sFKDlgErr2                        = 'Not define FK field on external table';
  sPKDlgErr1                        = 'Not define PK field on main table';

  sNewPK                            = 'New primary key';
  sNewPKHint                        = 'New primary key for table';
  sDropPrimaryKey                   = 'Drop primary key';
  sDropPrimaryKeyHint               = 'Drop primary key for table';
  sPrintListOfPrimaryKeysHint       = 'Print list of primary keys...';
  sRefresListPK                     = 'Refres primary key list';
  sRefresListPKHint                 = 'Refres primary keys list';
  sPKName                           = 'Primary key name';
  sNewUniqueConstraint              = 'New unique constraint';
  sUniqueConstraintName             = 'Unique constraint name';
  sDropUniqueConstraint             = 'Drop unique constraint';
  sPrintUNQlist                     = 'Print unique constraint list';
  sName                             = 'Name';

  sCreateINSERTorUPDATEProcedure    = 'Create INSERT/UPDATE procedure';
  sCreateSELECTProcedure            = 'Create SELECT procedure';
  sCreateINSERTProcedure            = 'Create INSERT procedure';
  sCreateUPDATEProcedure            = 'Create UPDATE procedure';
  sCreateDELETEProcedure            = 'Create DELETE procedure';
  sGrantExecuteTo                   = 'Grant execute to';

  sACLEdit                          = 'ACL edit';
  sGrantsManager                    = 'Grants manager';
  sUsersGroups                      = 'Users/Groups';
  sUsersAndGroups                   = 'Users and Groups';
  sOnlyUsers                        = 'Only users';
  sOnlyGroups                       = 'Only groups';
  sUsage                            = 'Usage';
  sCreate                           = 'Create';
  sGrantOwnUser                     = 'Grant own. user';
  sReferences                       = 'References';
  sNameUserRole                     = 'Name of user/role';


  sTableSpaceName                   = 'Table space name';
  sTableSpaceSize                   = 'Table space size';
  sFileFolder                       = 'File folder';
  sMoveUpHint                       = 'Move fields up...';
  sMoveDownHint                     = 'Move fields down...';
  sArrayBound                       = 'Array bound';
  sUpper                            = 'Upper';
  sLower                            = 'Lower';
  sEnvironmentOptions               = 'Environment Options';
  sActivitiMonitor                  = 'Activiti monitor';
  sDashboard                        = 'Dashboard';
  sRefreshIntervalInSeconds         = 'Refresh interval (in seconds)';
  sApplicationName                  = 'Application name';
  sState                            = 'State';
  sClientAddress                    = 'Client address';
  sClientHostname                   = 'Client hostname';
  sClientPort                       = 'Client port';
  sBackendStart                     = 'Backend start';
  sQueryStart                       = 'Query start';
  sQuery                            = 'Query';
  sParamValue                       = 'Param value';
  sDatabaseSessions                 = 'Database sessions';
  sTransactionPerSecond             = 'Transaction per second';
  sIdle                             = 'Idle';
  sTotal                            = 'Total';

  sCreateNewFolderTitle             = 'Create DB folder';
  sCreateNewFolderText              = 'Enter DB folder name';
  sDeleteDBFolder                   = 'Delete this folder?';
  sEnterFolderData                  = 'Enter DB folder data';
  sEditFolderDesc                   = 'DB folder description';
  sEditConfigValue                  = 'Edit config value';

  sNewDBFolder                      = 'New DB folder';
  sEditDBFolder                     = 'Edit DB folder';
  sDelBFolder                       = 'Delete DB folder';
  sExpandAll                        = 'Expand all';
  sCollapseAll                      = 'Collapse all';

  sObjectKindNotDefined             = 'ObjectKind not defined for class %s. Object : %';

  sDatabaseID                       = 'Database ID';
  sDatabaseNumBackends              = 'Database backends';
  sTransactionsCommit               = 'Transactions commit';
  sTransactionsRollback             = 'Transactions rollback';
  sDataBlocksRead                   = 'Data blocks read from disk';
  sStatsDateTime                    = 'Stats date';
  sRowCountUpdated                  = 'Rows count updated';
  sRowCountDeleted                  = 'Rows count deleted';
  sStatsDBSize                      = 'Database zise';
  sStatsCallCount                   = 'Call count';
  sStatsFullTime                    = 'Full time';
  sStatsFunctionTime                = 'Function time';
  sConfiguration                    = 'Configuration';


  sBlksHit                          = 'Number of times disk blocks were found already in the buffer cache, so that a read was not necessary (this only includes hits in the PostgreSQL buffer cache, not the operating system''s file system cache)';
  sTupReturned                      = 'Number of rows returned by queries in this database';
  sTupFetched                       = 'Number of rows fetched by queries in this database';
  sTupInserted                      = 'Number of rows inserted by queries in this database';
  sConflicts                        = 'Number of queries canceled due to conflicts with recovery in this database. (Conflicts occur only on standby servers; see pg_stat_database_conflicts for details.)';
  sTempFiles                        = 'Number of temporary files created by queries in this database. All temporary files are counted, regardless of why the temporary file was created (e.g., sorting or hashing), and regardless of the log_temp_files setting.';
  sTempBytes                        = 'Total amount of data written to temporary files by queries in this database. All temporary files are counted, regardless of why the temporary file was created, and regardless of the log_temp_files setting.';
  sDeadlocks                        = 'Number of deadlocks detected in this database';
  sBlkReadTime                      = 'Time spent reading data file blocks by backends in this database, in milliseconds';
  sBlkWriteTime                     = 'Time spent writing data file blocks by backends in this database, in milliseconds';

  sDesc_NEW = 'Variable holding the new database row for INSERT/UPDATE operations in row-level triggers. This variable is NULL in statement-level triggers and for DELETE operations.';
  sDesc_OLD = 'Variable holding the old database row for UPDATE/DELETE operations in row-level triggers. This variable is NULL in statement-level triggers and for INSERT operations.';
  sDesc_TG_NAME = 'Variable that contains the name of the trigger actually fired.';
  sDesc_TG_WHEN = 'A string of BEFORE, AFTER, or INSTEAD OF, depending on the trigger''s definition.';
  sDesc_TG_LEVEL = 'A string of either ROW or STATEMENT depending on the trigger''s definition.';
  sDesc_TG_OP = 'A string of INSERT, UPDATE, DELETE, or TRUNCATE telling for which operation the trigger was fired.';
  sDesc_TG_RELID = 'The object ID of the table that caused the trigger invocation.';
  sDesc_TG_RELNAME = 'The name of the table that caused the trigger invocation. This is now deprecated, and could disappear in a future release. Use TG_TABLE_NAME instead.';
  sDesc_TG_TABLE_NAME = 'The name of the table that caused the trigger invocation.';
  sDesc_TG_TABLE_SCHEMA = 'The name of the schema of the table that caused the trigger invocation.';
  sDesc_TG_NARGS = 'The number of arguments given to the trigger procedure in the CREATE TRIGGER statement.';
  sDesc_TG_ARGV = 'The arguments from the CREATE TRIGGER statement. The index counts from 0. Invalid indexes (less than 0 or greater than or equal to tg_nargs) result in a null value.';

  sDesc_TG_EVENT = 'A string representing the event the trigger is fired for.';
  sDesc_TG_TAG = 'Variable that contains the command tag for which the trigger is fired.';
  sCancelQueryQuestion                         = 'Cancel a running query?';
  sTerminateQueryQuestion                      = 'Terminate a running query?';
  sCancelQuery                                 = 'Cancel query';
  sDisconectConnection                         = 'Disconect connection';

  sTransactionPropertyForData                  = 'Transaction property for data';
  sTransactionPropertyForMetadata              = 'Transaction property for metadata';
  sTransactionPropertyForScriptEditor          = 'Transaction property for script editor';
  sSSHConnectionTimeout                        = 'SSH connection timeout';
  sSSHConnectionLoginFiled                     = 'SSH connection login filed';
  sErrorVariableDefenition                     = 'Error in variable defenition';
  sFillValuesForNotNullCollumn                 = 'Fill values for not null collumn';
  sErrorInParamName                            = 'Error in param name';
implementation

end.

