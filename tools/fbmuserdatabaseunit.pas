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

unit fbmUserDataBaseUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, SynEdit,
  ZMacroQuery, RxTextHolder, ZConnection, ZSqlProcessor, ZDataset, ZSqlUpdate,
  ibmanagertypesunit, IniFiles, LCLType, db;

const
  UserDBFileName              = 'fbm_data.db';
  OldUserDBFileName           = 'fbm_data.db.back';

type

  { TUserDBModule }

  TUserDBModule = class(TDataModule)
    quConnectionPluginsdb_connection_plugin_data_class_type: TStringField;
    quConnectionPluginsdb_connection_plugin_data_variable_name: TStringField;
    quConnectionPluginsdb_connection_plugin_data_variable_value: TStringField;
    quConnectionPluginsdb_database_id: TLargeintField;
    quDBOptionsItems: TZQuery;
    quDBOptionsdb_connection_options_name: TStringField;
    quDBOptionsdb_connection_options_value: TStringField;
    quDBOptionsdb_database_id: TLargeintField;
    quDBOptionsItemsdb_connection_options_name: TStringField;
    quDBOptionsItemsdb_connection_options_value: TStringField;
    quDBOptionsItemsdb_database_id: TLargeintField;
    UpdDB2: TZSQLProcessor;
    quOldDatabases: TZQuery;
    quDatabasesItem: TZQuery;
    quDatabasesdb_database_authentication_type: TStringField;
    quDatabasesdb_database_auto_grant: TBooleanField;
    quDatabasesdb_database_caption: TStringField;
    quDatabasesdb_database_connected_charset: TStringField;
    quDatabasesdb_database_database_name: TStringField;
    quDatabasesdb_database_description: TMemoField;
    quDatabasesdb_database_id: TLargeintField;
    quDatabasesdb_database_library_name: TStringField;
    quDatabasesdb_database_log_editor_filename: TStringField;
    quDatabasesdb_database_log_meta_custom_charset: TStringField;
    quDatabasesdb_database_log_meta_filename: TStringField;
    quDatabasesdb_database_password: TStringField;
    quDatabasesdb_database_remote_port: TLargeintField;
    quDatabasesdb_database_server_name: TStringField;
    quDatabasesdb_database_server_version: TStringField;
    quDatabasesdb_database_shedule: TBooleanField;
    quDatabasesdb_database_sort_order: TLargeintField;
    quDatabasesdb_database_sql_engine: TStringField;
    quDatabasesdb_database_username: TStringField;
    quDatabasesdb_database_user_role: TStringField;
    quDatabasesdb_database_use_log_editor: TBooleanField;
    quDatabasesdb_database_use_log_meta: TBooleanField;
    quDatabasesdb_database_use_log_meta_custom_charset: TBooleanField;
    quDatabasesdb_database_use_log_write_timestamp: TBooleanField;
    quDatabasesdb_folders_id: TLargeintField;
    quDatabasesItemdb_database_authentication_type: TStringField;
    quDatabasesItemdb_database_auto_grant: TBooleanField;
    quDatabasesItemdb_database_caption: TStringField;
    quDatabasesItemdb_database_connected_charset: TStringField;
    quDatabasesItemdb_database_database_name: TStringField;
    quDatabasesItemdb_database_description: TMemoField;
    quDatabasesItemdb_database_id: TLargeintField;
    quDatabasesItemdb_database_library_name: TStringField;
    quDatabasesItemdb_database_log_editor_filename: TStringField;
    quDatabasesItemdb_database_log_meta_custom_charset: TStringField;
    quDatabasesItemdb_database_log_meta_filename: TStringField;
    quDatabasesItemdb_database_password: TStringField;
    quDatabasesItemdb_database_remote_port: TLargeintField;
    quDatabasesItemdb_database_server_name: TStringField;
    quDatabasesItemdb_database_server_version: TStringField;
    quDatabasesItemdb_database_shedule: TBooleanField;
    quDatabasesItemdb_database_sort_order: TLargeintField;
    quDatabasesItemdb_database_sql_engine: TStringField;
    quDatabasesItemdb_database_username: TStringField;
    quDatabasesItemdb_database_user_role: TStringField;
    quDatabasesItemdb_database_use_log_editor: TBooleanField;
    quDatabasesItemdb_database_use_log_meta: TBooleanField;
    quDatabasesItemdb_database_use_log_meta_custom_charset: TBooleanField;
    quDatabasesItemdb_database_use_log_write_timestamp: TBooleanField;
    quDatabasesItemdb_folders_id: TLargeintField;
    quDatabasesItemreport_manager_folder: TStringField;
    quDatabasesItemshow_system_domains: TBooleanField;
    quDatabasesItemshow_system_tables: TBooleanField;
    quDatabasesItemshow_system_views: TBooleanField;
    quDatabasesItemsp_editor_lazzy_mode: TBooleanField;
    quDatabasesItemtrg_editor_lazzy_mode: TBooleanField;
    quDatabasesreport_manager_folder: TStringField;
    quDatabasesshow_system_domains: TBooleanField;
    quDatabasesshow_system_tables: TBooleanField;
    quDatabasesshow_system_views: TBooleanField;
    quDatabasessp_editor_lazzy_mode: TBooleanField;
    quDatabasestrg_editor_lazzy_mode: TBooleanField;
    quFoldersItem: TZQuery;
    quFoldersdb_folders_code: TLargeintField;
    quFoldersdb_folders_desc: TMemoField;
    quFoldersdb_folders_expanded: TBooleanField;
    quFoldersdb_folders_id: TLargeintField;
    quFoldersdb_folders_name: TStringField;
    quFoldersDel: TZQuery;
    quFoldersItemdb_folders_code: TLargeintField;
    quFoldersItemdb_folders_desc: TMemoField;
    quFoldersItemdb_folders_expanded: TBooleanField;
    quFoldersItemdb_folders_id: TLargeintField;
    quFoldersItemdb_folders_name: TStringField;
    quOldFolders: TZQuery;
    quParamsHistorydb_database_id: TLargeintField;
    quParamsHistorysql_editors_history_param_id: TLargeintField;
    quParamsHistorysql_editors_history_param_name: TStringField;
    quParamsHistorysql_editors_history_param_type: TLargeintField;
    quParamsHistorysql_editors_history_param_value: TStringField;
    quRecentItemsdb_database_id: TLargeintField;
    quRecentItemsdb_recent_objects_date: TDateTimeField;
    quRecentItemsdb_recent_objects_id: TLargeintField;
    quRecentItemsdb_recent_objects_name: TStringField;
    quRecentItemsdb_recent_objects_type: TLargeintField;
    quSQLFoldersAll: TZQuery;
    quSQLFoldersAlldb_database_id: TLargeintField;
    quSQLFoldersAllsql_editor_folders_code: TLargeintField;
    quSQLFoldersAllsql_editor_folders_desc: TMemoField;
    quSQLFoldersAllsql_editor_folders_id: TLargeintField;
    quSQLFoldersAllsql_editor_folders_name: TStringField;
    quSQLFoldersdb_database_id: TLargeintField;
    quSQLFoldersIns: TZReadOnlyQuery;
    quSQLFolderssql_editor_folders_code: TLargeintField;
    quSQLFolderssql_editor_folders_desc: TMemoField;
    quSQLFolderssql_editor_folders_id: TLargeintField;
    quSQLFolderssql_editor_folders_name: TStringField;
    quSQLHistorydb_database_id: TLargeintField;
    quSQLHistorysql_editors_history_date: TDateTimeField;
    quSQLHistorysql_editors_history_exec_time: TTimeField;
    quSQLHistorysql_editors_history_id: TLargeintField;
    quSQLHistorysql_editors_history_sql_page_name: TStringField;
    quSQLHistorysql_editors_history_sql_plan: TMemoField;
    quSQLHistorysql_editors_history_sql_text: TMemoField;
    quSQLHistorysql_editors_history_sql_type: TLargeintField;
    quSQLPagesdb_database_id: TLargeintField;
    quSQLPagesIns: TZReadOnlyQuery;
    quSQLPagessql_editors_body: TMemoField;
    quSQLPagessql_editors_caption: TStringField;
    quSQLPagessql_editors_carret_pos_x: TLargeintField;
    quSQLPagessql_editors_carret_pos_y: TLargeintField;
    quSQLPagessql_editors_id: TLargeintField;
    quSQLPagessql_editors_sel_end: TLargeintField;
    quSQLPagessql_editors_sel_start: TLargeintField;
    quSQLPagessql_editors_sort_order: TLargeintField;
    quSQLPagessql_editor_folders_id: TLargeintField;
    quSQLPagesDel: TZReadOnlyQuery;
    quSysConst: TZQuery;
    quSysConst1: TZReadOnlyQuery;
    quSysConst1sys_consts_value_type: TLongintField;
    quSysConst1sys_const_name: TStringField;
    quSysConst1sys_const_value: TStringField;
    quOldSysConst: TZQuery;
    quSysConstsys_consts_value_type: TLargeintField;
    quSysConstsys_const_name: TStringField;
    quSysConstsys_const_value: TStringField;
    UpdDB3: TZSQLProcessor;
    UserDB: TZConnection;
    InitDB: TZSQLProcessor;
    OldUserDB: TZConnection;
    usSysConst: TZUpdateSQL;
    quFolders: TZQuery;
    quDatabases: TZQuery;
    quParamsHistory: TZQuery;
    ZQuery4: TZQuery;
    quRecentItems: TZQuery;
    quSQLHistory: TZQuery;
    quSQLFolders: TZQuery;
    quSQLPages: TZQuery;
    quSQLPagesUpdSO: TZQuery;
    quConnectionPlugins: TZQuery;
    quDBOptions: TZQuery;
    ZReadOnlyQuery1: TZReadOnlyQuery;
    usFolders: TZUpdateSQL;
    usDatabases: TZUpdateSQL;
    usParamsHistory: TZUpdateSQL;
    quSQLFoldersUpd: TZReadOnlyQuery;
    quSQLPagesUpd: TZReadOnlyQuery;
    quLastID: TZReadOnlyQuery;
    quRecentClear: TZReadOnlyQuery;
    quInsRecent: TZReadOnlyQuery;
    ZUpdateSQL4: TZUpdateSQL;
    usRecentItems: TZUpdateSQL;
    usSQLHistory: TZUpdateSQL;
    usSQLFolders: TZUpdateSQL;
    usSQLPages: TZUpdateSQL;
    usConnectionPlugins: TZUpdateSQL;
    usDBOptions: TZUpdateSQL;
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure SystemVariablesLoad;
    procedure SystemVariablesStore;
    //procedure ImportOldConfig;
    procedure InternalCreateUserDB;
    procedure InternalCheckDBVersion;
    procedure InternalConvertDB;
    procedure InternalUpdate2;
    procedure InternalUpdate3;

    procedure ImportDataBaseList;
    procedure ImportLoadRecentObjects(DataBaseID:integer; ADataFolder:string);
//    procedure ImportLoadSQLHistory(DataBaseID:integer; ADataFolder:string);
    procedure ImportLoadSQLPages(Ini:TIniFile; AItemName:string; DataBaseID:integer; ADataFolder:string);
  public
    procedure InitData;
    procedure SaveConfig;
    function GetLastID:integer;
    procedure ClearDesktop(DataBaseID:integer);
    procedure SaveDesktop(AWindowName:string;ADataBaseID, AType:integer);
    procedure DeleteDataBase(DataBaseID:integer);
  end;


var
  UserDBModule: TUserDBModule = nil;

procedure InitDataModule;
implementation
uses {DOM, }fbmToolsUnit, FileUtil, LazFileUtils, LazUTF8, rxConfigValues,
  fb_ConstUnit, variants;

{$R *.lfm}

procedure InitDataModule;
begin
  if not Assigned(UserDBModule) then
    UserDBModule:=TUserDBModule.Create(Application);
  UserDBModule.InitData;
end;


{********* Сервисные функции по сохранению состояния и настроек системы *******}
procedure InternalWriteString(const ConstName, Value:string; ValueType:integer);
begin
  //if fDefRoleName<>'SKLD_ADMIN' then exit;
  { TODO : Необходимо обработать роли пользователя - сохраняем системные настройки только админом }
  UserDBModule.quSysConst.ParamByName('sys_const_name').AsString:=ConstName;
  UserDBModule.quSysConst.Open;
  UserDBModule.quSysConst.FetchAll;
  if UserDBModule.quSysConst.RecordCount<1 then
  begin
    UserDBModule.quSysConst.Append;
    UserDBModule.quSysConstsys_const_name.AsString:=ConstName;
  end
  else
    UserDBModule.quSysConst.Edit;
  UserDBModule.quSysConstsys_const_value.AsString:=Value;
  if UserDBModule.quSysConstsys_consts_value_type.IsNull then
    UserDBModule.quSysConstsys_consts_value_type.AsInteger:=ValueType;
  UserDBModule.quSysConst.Post;
  UserDBModule.quSysConst.Close;
end;

procedure WriteString1(const ConstName, Value:string);
begin
  InternalWriteString(ConstName, Value, cvtString);
end;

procedure WriteInteger1(const ConstName:string; Value:integer);
begin
  InternalWriteString(ConstName, IntToStr(Value), cvtInteger);
end;

procedure WriteBoolean1(const ConstName:string; Value:Boolean);
begin
  InternalWriteString(ConstName, IntToStr(Ord(Value)), cvtBoolean);
end;

procedure WriteDate1(const ConstName:string; Value:TDateTime);
begin
  InternalWriteString(ConstName, DateTimeToStr(Value), cvtDateTime);
end;

procedure WriteFloat1(const ConstName:string; Value:Double);
var
  S:string;
begin
  Str(Value, S);
  InternalWriteString(ConstName, S, cvtFloat);
end;

{ TUserDBModule }

procedure TUserDBModule.DataModuleDestroy(Sender: TObject);
begin
  UserDBModule:=nil;
end;

procedure TUserDBModule.SystemVariablesLoad;
function ToFlts(S:string):Double;
var
  Code:integer;
begin
  Val(S, Result, Code)
end;

begin
  ConfigValues.Clear;
  ConfigValues.BeginUpdate;
  quSysConst1.Open;

  while not quSysConst1.EOF do
  begin
    case quSysConst1sys_consts_value_type.AsInteger of
      cvtInteger : ConfigValues.SetByNameAsInteger(quSysConst1sys_const_name.AsString, quSysConst1sys_const_value.AsInteger);
      cvtString  : ConfigValues.SetByNameAsString(quSysConst1sys_const_name.AsString, quSysConst1sys_const_value.AsString);
      cvtBoolean : ConfigValues.SetByNameAsBoolean(quSysConst1sys_const_name.AsString, quSysConst1sys_const_value.AsString='1');
      cvtDateTime: ConfigValues.SetByNameAsDateTime(quSysConst1sys_const_name.AsString, quSysConst1sys_const_value.AsDateTime);
      cvtFloat   : ConfigValues.SetByNameAsFloat(quSysConst1sys_const_name.AsString, ToFlts(quSysConst1sys_const_value.AsString));
    end;

    quSysConst1.Next;
  end;
  quSysConst1.Close;
  ConfigValues.EndUpdate;
end;

procedure TUserDBModule.SystemVariablesStore;
var
  P: TConfigValue;
begin
  for P in ConfigValues  do
    if P.Modified then
    begin
      case P.DataType of
        cvtInteger : WriteInteger1(P.Name, P.AsInteger);
        cvtString  : WriteString1(P.Name, P.AsString);
        cvtBoolean : WriteBoolean1(P.Name, P.AsBoolean);
        cvtDateTime: WriteDate1(P.Name, P.AsDateTime);
        cvtFloat   : WriteFloat1(P.Name, P.AsFloat);
      end;
    end;
end;

procedure TUserDBModule.InternalCreateUserDB;
begin
  UserDB.Connect;
  InitDB.Execute;
end;

procedure TUserDBModule.InternalCheckDBVersion;
var
  CVer: Integer;
begin
  UserDB.Connect;
  SystemVariablesLoad;
  CVer:=ConfigValues.ByNameAsInteger('GLOBAL/ConfigDBVersion', -1);
  if  CVer< ConfDBVers then
  begin
    UserDB.Disconnect;
    if CVer < 1 then
      InternalConvertDB
    else
    if CVer < 2 then
      InternalUpdate2;

    if CVer < 3 then
      InternalUpdate3;
    UserDB.Connect;
    SystemVariablesLoad;
  end;
end;

procedure TUserDBModule.InternalConvertDB;

procedure DoConvertSysConst;
begin
  quOldSysConst.Open;
  quSysConst.Open;
  while not quOldSysConst.EOF do
  begin
    quSysConst.Append;
    quSysConstsys_const_name.Assign(quOldSysConst.FieldByName('sys_const_name'));
    quSysConstsys_const_value.Assign(quOldSysConst.FieldByName('sys_const_value'));
    quSysConstsys_consts_value_type.Assign(quOldSysConst.FieldByName('sys_consts_value_type'));
    quSysConst.Post;
    quOldSysConst.Next;
  end;
  quOldSysConst.Close;
  quSysConst.Close;
end;

procedure DoConvertFolders;
begin
  quOldFolders.Open;
  quFolders.Open;
  while not quOldFolders.EOF do
  begin
    quFolders.Append;
    quFoldersdb_folders_id.Assign(quOldFolders.FieldByName('db_folders_id'));
    quFoldersdb_folders_code.Assign(quOldFolders.FieldByName('db_folders_code'));
    quFoldersdb_folders_name.Assign(quOldFolders.FieldByName('db_folders_name'));
    quFoldersdb_folders_desc.Assign(quOldFolders.FieldByName('db_folders_desc'));
    quFolders.Post;
    quOldFolders.Next;
  end;
  quOldFolders.Close;
  quFolders.Close;
end;

procedure DoConvertDataBases;
begin
  quDatabases.Open;
  quOldDatabases.Open;
  while not quOldDatabases.EOF do
  begin
    quOldDatabases.Next;
  end;
  quDatabases.Close;
  quOldDatabases.Close;
end;

var
  FOldFileName: String;
begin
  FOldFileName:= LocalCfgFolder + OldUserDBFileName;
  if FileExistsUTF8(FOldFileName) then DeleteFileUTF8(FOldFileName);
  RenameFileUTF8(UserDB.Database, FOldFileName);
  OldUserDB.Database:=FOldFileName;
  OldUserDB.Connect;
  UserDB.Connect;
  InitDB.Execute;
  DoConvertSysConst;
  DoConvertFolders;
  DoConvertDataBases;

  OldUserDB.Disconnect;
end;

procedure TUserDBModule.InternalUpdate2;
begin
  UserDB.Connect;
  UpdDB2.Execute;
  UserDB.Disconnect;
end;

procedure TUserDBModule.InternalUpdate3;
begin
  UserDB.Connect;
  UpdDB3.Execute;
  UserDB.Disconnect;
end;

procedure TUserDBModule.ImportDataBaseList;
var
  DBListStream: TIniFile;
  C: LongInt;
  AItemName, S: String;

procedure DoLoadHistory(id, item:integer);
var
  Par: TStringList;
  ItmNm, FN: String;
  i: Integer;
begin
  ItmNm:='Item_'+IntToStr(item);
  FN:=AppendPathDelim(LocalCfgFolder) + ItmNm + '.parhst';
  if FileExistsUTF8(FN) then
  begin
    Par:=TStringList.Create;
    Par.LoadFromFile(FN);
    for i:=0 to Par.Count-1 do
    begin
      quParamsHistory.Append;
      quParamsHistorydb_database_id.AsInteger:=ID;
      quParamsHistorysql_editors_history_param_name.AsString:=Par.Names[i];
      quParamsHistorysql_editors_history_param_value.AsString:=Par.ValueFromIndex[i];
      quParamsHistorysql_editors_history_param_type.AsInteger:=2;
      quParamsHistory.Post;
    end;
    Par.Free;
    DeleteFileUTF8(FN);
  end;
end;

var
  i, SO: Integer;
  SDataFolder, S1: String;
begin
  DBListStream:=TIniFile.Create(UTF8ToSys(AliasFileName));
  quFolders.Open;
  quDatabases.Open;
  quParamsHistory.Open;
  quRecentItems.Open;
  quSQLHistory.Open;
  quSQLFoldersAll.Open;
  quSQLPages.Open;

  //Read folders
  C:=DBListStream.ReadInteger('Folders', 'RecordCount', 0);
  for i:=0 to C-1 do
  begin
    quFolders.Append;
    quFoldersdb_folders_code.AsInteger:=i;
    quFoldersdb_folders_name.AsString:=DBListStream.ReadString('Folders/Item'+IntToStr(i), 'Name', '');
    quFoldersdb_folders_desc.AsString:=DBListStream.ReadString('Folders/Item'+IntToStr(i), 'Description', '');
    quFoldersdb_folders_expanded.AsBoolean:=DBListStream.ReadBool('Folders/Item'+IntToStr(i), 'Expandex', false);
    quFolders.Post;
  end;
  quFolders.Refresh;

  C:=DBListStream.ReadInteger('General', 'RecordCount', 0);
  for i:=0 to C-1 do
  begin
    AItemName:='Item_'+IntToStr(i);
    quDatabases.Append;
    //quDatabasesdb_database_id: TLargeintField;
    quDatabasesdb_database_sql_engine.AsString:=DBListStream.ReadString(aItemName, 'SQLEngine', '');
    if quDatabasesdb_database_sql_engine.AsString = 'TMySQLEngine' then
      quDatabasesdb_database_sql_engine.AsString:='TSQLEngineMySQL';
    quDatabasesdb_database_sort_order.AsInteger:=i;
    quDatabasesdb_database_description.AsString:='';

    quDatabasesdb_database_database_name.AsString:=DBListStream.ReadString(aItemName, 'DataBaseName', '');
    quDatabasesdb_database_username.AsString:=DBListStream.ReadString(aItemName, 'UserName', '');;
    quDatabasesdb_database_password.AsString:=DBListStream.ReadString(aItemName, 'Password', '');
    quDatabasesdb_database_caption.AsString:=DBListStream.ReadString(aItemName, 'AliasName', '');
    quDatabasesdb_database_server_name.AsString:=DBListStream.ReadString(aItemName, 'ServerName', '');
    quDatabasesdb_database_remote_port.AsInteger:=DBListStream.ReadInteger(aItemName, 'RemotePort', 0);
    quDatabasesdb_database_server_version.AsString:=DBListStream.ReadString(aItemName, 'ServerVersion', '');
    quDatabasesdb_database_connected_charset.AsString:=DBListStream.ReadString(aItemName, TargetOS+'-CharSet', '');

    if DBListStream.ReadString(aItemName, 'RoleName ', '') <> '' then
      quDatabasesdb_database_user_role.AsString:=DBListStream.ReadString(aItemName, 'RoleName ', '')
    else
    if DBListStream.ReadString(aItemName, 'UserRole ', '') <> '' then
      quDatabasesdb_database_user_role.AsString:=DBListStream.ReadString(aItemName, 'UserRole ', '');

    quDatabasesreport_manager_folder.AsString:=DBListStream.ReadString(aItemName, 'ReportManagerFolder', '');
    quDatabasesshow_system_tables.AsBoolean:=DBListStream.ReadBool(aItemName, 'ShowSystemTables', false);
    quDatabasessp_editor_lazzy_mode.AsBoolean:=DBListStream.ReadBool(aItemName, 'SPEditLazzyMode', false);
    quDatabasestrg_editor_lazzy_mode.AsBoolean:=DBListStream.ReadBool(aItemName, 'TriggerEditLazzyMode', false);
    quDatabasesdb_database_shedule.AsBoolean:=DBListStream.ReadBool(aItemName, 'UsePGShedule', false);
    quDatabasesdb_database_library_name.AsString:=DBListStream.ReadString(aItemName, 'ClientLibraryName', '');
    quDatabasesdb_database_authentication_type.AsString:=DBListStream.ReadString(aItemName, 'AuthenticationType', '');
    quDatabasesdb_database_auto_grant.AsBoolean:=DBListStream.ReadBool(AItemName, 'AutoGrantObject', false);
    quDatabasesdb_database_use_log_meta.AsBoolean:=DBListStream.ReadBool(aItemName, 'LogMetadata', false);
    quDatabasesdb_database_use_log_editor.AsBoolean:=DBListStream.ReadBool(aItemName, 'LogSQLEditor', false);
    quDatabasesdb_database_log_meta_filename.AsString:=DBListStream.ReadString(aItemName, 'LogFileMetadata', '');
    quDatabasesdb_database_log_editor_filename.AsString:=DBListStream.ReadString(aItemName, 'LogFileSQLEditor', '');
    quDatabasesdb_database_use_log_meta_custom_charset.AsBoolean:=DBListStream.ReadString(aItemName, 'LogFileCodePage', '') <> '';
    quDatabasesdb_database_log_meta_custom_charset.AsString:=DBListStream.ReadString(aItemName, 'LogFileCodePage', '');
    quDatabasesdb_database_use_log_write_timestamp.AsBoolean:=DBListStream.ReadBool(aItemName, 'LogTimestamp', false);

{
//    HistoryCountSQLEditor:=IniFile.ReadInteger(IniSection, 'HistoryCountSQLEditor', HistoryCountSQLEditor);
//FetchAllData:=IniFile.ReadBool(IniSection, 'FetchAllData', FetchAllData);
    FBackupOptions.Load(IniFile, IniSection);
    FProtocol:= TUIBProtocol(IniFile.ReadInteger(IniSection, 'Protocol', 0));
    FRestoreOptions.Load(IniFile, IniSection);
    FShowSysINF_SCH:=IniFile.ReadBool(IniSection, 'ShowSysINF_SCH', FShowSysINF_SCH);
    FShowSysPG_CATALOG:=IniFile.ReadBool(IniSection, 'ShowSysPG_CATALOG', FShowSysPG_CATALOG);
    FShowSysPG_TEMP_1:=IniFile.ReadBool(IniSection, 'ShowSysPG_TEMP_1', FShowSysPG_TEMP_1);
    FShowSysPG_TEMP_2:=IniFile.ReadBool(IniSection, 'ShowSysPG_TEMP_2', FShowSysPG_TEMP_2);
    FShowSysPG_TOAST:=IniFile.ReadBool(IniSection, 'ShowSysPG_TOAST', FShowSysPG_TOAST);
    FShowSysPG_TOAST_TEMP_1:=IniFile.ReadBool(IniSection, 'ShowSysPG_TOAST_TEMP_1', FShowSysPG_TOAST_TEMP_1);
    FShowSysPG_TOAST_TEMP_2:=IniFile.ReadBool(IniSection, 'ShowSysPG_TOAST_TEMP_2', FShowSysPG_TOAST_TEMP_2);
    FTranParamData:=IniFile.ReadInteger(IniSection, 'TranParamData', 0 {defTranParamData});
    FTranParamMetaData:=IniFile.ReadInteger(IniSection, 'TranParamMetaData', 0 {defTranParamMetaData});
}

    S:=DBListStream.ReadString(aItemName, 'OIFolder', '');
    if S <> '' then
      if quFolders.Locate('db_folders_name', S, []) then
        quDatabasesdb_folders_id.AsInteger:=quFoldersdb_folders_id.AsInteger;

    //FSQLEngineLogOptions.Load(IniFile, IniSection);
    //FDisplayDataOptions.Load(IniFile, IniSection);
    quDatabases.Post;
  end;
  quDatabases.Refresh;

  //Import SQL folder
  quDatabases.First;
  while not quDatabases.EOF do
  begin
    SO:=0;
    AItemName:='Item_'+IntToStr(quDatabasesdb_database_sort_order.AsInteger);
    C:=DBListStream.ReadInteger(aItemName, 'SqlPageCount', 0);
    for i:=0 to C-1 do
    begin
      S:=DBListStream.ReadString(aItemName, 'SQLEdit_Page_'+IntToStr(i+1), '');
      if (S<>'') and (DBListStream.ReadString(aItemName, 'SqlGroup_'+S, '') <> '') then
      begin
        S1:=DBListStream.ReadString(aItemName, 'SqlGroup_'+S, '');
        if not quSQLFoldersAll.Locate('db_database_id;sql_editor_folders_name', VarArrayOf([quDatabasesdb_database_id.AsInteger, S1]), []) then
        begin
          quSQLFoldersAll.Append;
          quSQLFoldersAlldb_database_id.AsInteger:=quDatabasesdb_database_id.AsInteger;
          quSQLFoldersAllsql_editor_folders_code.AsInteger:=SO;
          quSQLFoldersAllsql_editor_folders_name.AsString:=S1;
          quSQLFoldersAll.Post;
          Inc(SO);
        end;
      end;
    end;
    quDatabases.Next;
  end;
  quSQLFoldersAll.Refresh;

  //Import SQL pages and oth
  quDatabases.First;
  while not quDatabases.EOF do
  begin
    AItemName:='Item_'+IntToStr(quDatabasesdb_database_sort_order.AsInteger);
    SDataFolder:=DBListStream.ReadString(aItemName, 'SavedFolder', '');
    DoLoadHistory(quDatabasesdb_database_id.AsInteger, quDatabasesdb_database_sort_order.AsInteger);

    if SDataFolder <> '' then
    begin
      ImportLoadRecentObjects(quDatabasesdb_database_id.AsInteger, SDataFolder);
//      ImportLoadSQLHistory(quDatabasesdb_database_id.AsInteger, SDataFolder);
      ImportLoadSQLPages(DBListStream, AItemName, quDatabasesdb_database_id.AsInteger, SDataFolder);

      DeleteDirectory(LocalCfgFolder + SDataFolder, false);
    end;
    quDatabases.Next;
  end;

  quParamsHistory.Close;
  quDatabases.Close;
  quFolders.Close;
  quRecentItems.Open;
  quSQLHistory.Close;
  quSQLFoldersAll.Close;
  quSQLPages.Close;
(*
  Top:=DBListStream.ReadInteger('DataInpector', 'Top', Top);
  Left:=DBListStream.ReadInteger('DataInpector', 'Left', Left);
  Height:=DBListStream.ReadInteger('DataInpector', 'Height', Height);
  Width:=DBListStream.ReadInteger('DataInpector', 'Width', Width);
*)
  DBListStream.Free;

  DeleteFileUTF8(AliasFileName);
end;

procedure TUserDBModule.ImportLoadRecentObjects(DataBaseID: integer;
  ADataFolder: string);
var
  AFileName, S: String;
  Ini: TIniFile;
  i: Integer;
  C: LongInt;
begin
  AFileName:=AppendPathDelim(LocalCfgFolder + ADataFolder) + 'fbm_db_desktop.ini';
  if not FileExistsUTF8(AFileName) then exit;
  Ini:=TIniFile.Create(UTF8ToSys(AFileName));
  C:=Ini.ReadInteger('Windows', 'Count', 0);
  for i:=0 to C-1 do
  begin
    S:='Window_' + IntToStr(i);
    if Ini.ReadString('Windows', S, '') <> '' then
    begin
      quRecentItems.Append;
      quRecentItemsdb_database_id.AsInteger:=DataBaseID;
      quRecentItemsdb_recent_objects_date.AsDateTime:=Now;
      quRecentItemsdb_recent_objects_type.AsInteger:=0;
      quRecentItemsdb_recent_objects_name.AsString:=Ini.ReadString('Windows', S, '');
      quRecentItems.Post;
    end;
  end;

  if Ini.ReadInteger('SQLEditor', 'Present', 0) = 1 then
  begin
    quRecentItems.Append;
    quRecentItemsdb_database_id.AsInteger:=DataBaseID;
    quRecentItemsdb_recent_objects_date.AsDateTime:=Now;
    quRecentItemsdb_recent_objects_type.AsInteger:=5;
    quRecentItemsdb_recent_objects_name.AsString:='FBM SQL EDITOR';
    quRecentItems.Post;
  end;

  C:=Ini.ReadInteger('SQLSctip_Recent', 'Count', 0);
  for i:=0 to C-1 do
  begin
    S:='Item_0_' + IntToStr(i);
    if Ini.ReadString('SQLSctip_Recent', S+'_FileName', '') <> '' then
    begin
      quRecentItems.Append;
      quRecentItemsdb_database_id.AsInteger:=DataBaseID;
      quRecentItemsdb_recent_objects_date.AsDateTime:=Ini.ReadDateTime('SQLSctip_Recent', S+'_FileDate', Now);
      quRecentItemsdb_recent_objects_type.AsInteger:=4;
      quRecentItemsdb_recent_objects_name.AsString:=Ini.ReadString('SQLSctip_Recent', S+'_FileName', '');
      quRecentItems.Post;
    end;
  end;


  C:=Ini.ReadInteger('DBItems_Recent', 'Count', 0);
  for i:=0 to C-1 do
  begin
    S:='Item_0_' + IntToStr(i);
    if Ini.ReadString('DBItems_Recent', S+'_FileName', '') <> '' then
    begin
      quRecentItems.Append;
      quRecentItemsdb_database_id.AsInteger:=DataBaseID;
      quRecentItemsdb_recent_objects_date.AsDateTime:=Ini.ReadDateTime('SQLSctip_Recent', S+'_FileDate', Now);
      quRecentItemsdb_recent_objects_type.AsInteger:=2;
      quRecentItemsdb_recent_objects_name.AsString:=Ini.ReadString('SQLSctip_Recent', S+'_FileName', '');
      quRecentItems.Post;
    end;
  end;
  Ini.Free;
  DeleteFileUTF8(AFileName);
end;
(*
const
  RootNodeSqlHistory = 'sql_history';

procedure TUserDBModule.ImportLoadSQLHistory(DataBaseID: integer;
  ADataFolder: string);
procedure ParceSqlHistory(const Doc:TXMLDocument);
var
  Root, Node:TDOMElement;
  Cnt, i:integer;
begin
  Root:=Doc.FindNode(RootNodeSqlHistory) as TDOMElement;
  Cnt:=StrToIntDef(Root.GetAttribute('Count'), 0);
  for i:= 0 to Cnt-1 do
  begin
    Node:=TDOMElement(Root.FindNode('Item_'+IntToStr(i)));
    if Assigned(Node) then
    begin
      quSQLHistory.Append;
      //quSQLHistorysql_editors_history_id,
      quSQLHistorydb_database_id.AsInteger:=DataBaseID;
      quSQLHistorysql_editors_history_date.AsDateTime:=StrToFloat(Node.GetAttribute('date'));
      if Node.GetAttribute('sql_type')<>'' then
        quSQLHistorysql_editors_history_sql_type.AsInteger:=StrToIntDef(Node.GetAttribute('sql_type'), 0);
      if Node.GetAttribute('exec_time')<>'' then
        quSQLHistorysql_editors_history_exec_time.AsDateTime:=StrToTimeDef(Node.GetAttribute('exec_time'), 0);
      quSQLHistorysql_editors_history_sql_page_name.AsString:=Node.GetAttribute('plan');
      quSQLHistorysql_editors_history_sql_text.AsString:=Node.GetAttribute('text');
      quSQLHistorysql_editors_history_sql_plan.AsString:=Node.GetAttribute('src_page_name');
      quSQLHistory.Post;
    end;
  end;
end;

var
  Doc:TXMLDocument;
  AFileName: String;
begin
  AFileName:=AppendPathDelim(GlobalCfgFolder + ADataFolder) + 'sql_history.cfg';
  if FileExistsUTF8(AFileName) then
  begin
    ReadXMLFile(Doc, UTF8ToSys(AFileName));
    try
      ParceSqlHistory(Doc);
    finally
      Doc.Free;
    end;
    DeleteFileUTF8(AFileName);
  end;
end;
*)
procedure TUserDBModule.ImportLoadSQLPages(Ini: TIniFile;
  AItemName: string; DataBaseID: integer; ADataFolder: string);
var
  C: LongInt;
  i: Integer;
  SPage, S1, S: String;
begin
  C:=Ini.ReadInteger(aItemName, 'SqlPageCount', 0);
  for i:=1 to C do
  begin
    SPage:=Ini.ReadString(aItemName, 'SQLEdit_Page_'+IntToStr(i), '');
    quSQLPages.Append;
    quSQLPagesdb_database_id.AsInteger:=DataBaseID;
    quSQLPagessql_editors_caption.AsString:=Ini.ReadString(aItemName, 'SqlName_'+SPage, '');
    quSQLPagessql_editors_carret_pos_x.AsInteger:=Ini.ReadInteger(aItemName, 'SQLEdit_'+SPage+'_CaretX', 0);
    quSQLPagessql_editors_carret_pos_y.AsInteger:=Ini.ReadInteger(aItemName, 'SQLEdit_'+SPage+'_CaretY', 0);
    quSQLPagessql_editors_sel_start.AsInteger:=Ini.ReadInteger(aItemName, 'SQLEdit_'+SPage+'_SelStart', 0);
    quSQLPagessql_editors_sel_end.AsInteger:=Ini.ReadInteger(aItemName, 'SQLEdit_'+SPage+'_SelEnd', 0);
    quSQLPagessql_editors_sort_order.AsInteger:=i;
    S:=Ini.ReadString(aItemName, 'SQLEdit_'+SPage+'_FileName', '');
    S:=AppendPathDelim(LocalCfgFolder + ADataFolder) + S;
    S1:=LoadFormTextFile(S);
    quSQLPagessql_editors_body.AsString:=S1;

    S1:=Ini.ReadString(aItemName, 'SqlGroup_'+SPage, '');
    if (S1<>'') then
    begin
      if quSQLFoldersAll.Locate('db_database_id;sql_editor_folders_name', VarArrayOf([DataBaseID, S1]), []) then
        quSQLPagessql_editor_folders_id.AsInteger:=quSQLFoldersAllsql_editor_folders_id.AsInteger;
    end;

    quSQLPages.Post;
    S1:=AppendPathDelim(LocalCfgFolder + ADataFolder) + Ini.ReadString(aItemName, 'SQLEdit_'+SPage+'_FileName', '');
    if FileExistsUTF8(S1) then
      DeleteFileUTF8(S1);
  end;
end;

procedure TUserDBModule.InitData;
var
  DBFileName: String;
begin
  DBFileName:=LocalCfgFolder + UserDBFileName;
  UserDB.Database:=DBFileName;
  if FileExistsUTF8(DBFileName) then
  begin
    InternalCheckDBVersion;
  end
  else
  begin
    InternalCreateUserDB;
  end;
  ConfigValues.SetByNameAsInteger('GLOBAL/ConfigDBVersion', ConfDBVers);
  SystemVariablesStore;
  LoadLocalize(ConfigValues.ByNameAsString('lngFileName', ''));
end;

procedure TUserDBModule.SaveConfig;
begin
  SystemVariablesStore;
end;

function TUserDBModule.GetLastID: integer;
begin
  quLastID.Open;
  Result:=quLastID.Fields[0].AsInteger;
  quLastID.Close;
end;

procedure TUserDBModule.ClearDesktop(DataBaseID: integer);
begin
  quRecentClear.ParamByName('db_database_id').AsInteger:=DataBaseID;
  quRecentClear.ExecSQL;
end;

procedure TUserDBModule.SaveDesktop(AWindowName: string; ADataBaseID,
  AType: integer);
begin
  quInsRecent.ParamByName('db_database_id').AsInteger:=ADataBaseID;
  quInsRecent.ParamByName('db_recent_objects_type').AsInteger:=AType;
  quInsRecent.ParamByName('db_recent_objects_name').AsString:=AWindowName;
  quInsRecent.ParamByName('db_recent_objects_date').AsDateTime:=Now;
  quInsRecent.ExecSQL;
end;

procedure TUserDBModule.DeleteDataBase(DataBaseID: integer);
begin
  UserDB.ExecuteDirect('DELETE FROM db_database WHERE db_database.db_database_id  = '+IntToStr(DataBaseID));

end;

end.

