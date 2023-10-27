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

unit fbmUserDataBaseUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, SynEdit,
  ZMacroQuery, RxTextHolder, ZConnection, ZSqlProcessor, ZDataset, ZSqlUpdate,
  ZSqlMonitor, ibmanagertypesunit, IniFiles, LCLType, db, LR_ChBox;

const
  UserDBFileName              = 'fbm_data.db';
  OldUserDBFileName           = 'fbm_data.db.back';

type

  { TUserDBModule }

  TUserDBModule = class(TDataModule)
    quDBOptionsItems: TZQuery;
    quDBOptionsItemsdb_connection_options_name: TStringField;
    quDBOptionsItemsdb_connection_options_value: TStringField;
    quDBOptionsItemsdb_database_id: TLargeintField;
    UpdDB2: TZSQLProcessor;
    quOldDatabases: TZQuery;
    quDatabasesItem: TZQuery;
    quFoldersItem: TZQuery;
    quFoldersDel: TZQuery;
    quOldFolders: TZQuery;
    quSQLFoldersAll: TZQuery;
    quSQLFoldersAlldb_database_id: TLargeintField;
    quSQLFoldersAllsql_editor_folders_code: TLargeintField;
    quSQLFoldersAllsql_editor_folders_desc: TMemoField;
    quSQLFoldersAllsql_editor_folders_id: TLargeintField;
    quSQLFoldersAllsql_editor_folders_name: TStringField;
    quSQLFoldersIns: TZReadOnlyQuery;
    quSQLPagesIns: TZReadOnlyQuery;
    quSQLPagesDel: TZReadOnlyQuery;
    quSysConst: TZQuery;
    quSysConst1: TZReadOnlyQuery;
    quSysConst1sys_consts_value_type: TLongintField;
    quSysConst1sys_const_name: TStringField;
    quSysConst1sys_const_value: TStringField;
    quOldSysConst: TZQuery;
    UpdDB3: TZSQLProcessor;
    UpdDB4: TZSQLProcessor;
    UpdDB5: TZSQLProcessor;
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
    ZSQLMonitor1: TZSQLMonitor;
    ZUpdateSQL4: TZUpdateSQL;
    usRecentItems: TZUpdateSQL;
    usSQLHistory: TZUpdateSQL;
    usSQLFolders: TZUpdateSQL;
    usSQLPages: TZUpdateSQL;
    usConnectionPlugins: TZUpdateSQL;
    usDBOptions: TZUpdateSQL;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FfrCheckBox:TfrCheckBoxObject;
    procedure DoIntLRObjects;
    procedure SystemVariablesLoad;
    procedure SystemVariablesStore;
    //procedure ImportOldConfig;
    procedure InternalCreateUserDB;
    procedure InternalCheckDBVersion;
    procedure InternalConvertDB;
    procedure InternalUpdate2;
    procedure InternalUpdate3;
    procedure InternalUpdate4;
    procedure InternalUpdate5;

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
uses fbmToolsUnit, FileUtil, LazFileUtils, LazUTF8, rxConfigValues, fb_ConstUnit,
  variants, pg_utils, ZClasses;

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
    UserDBModule.quSysConst.FieldByName('sys_const_name').AsString:=ConstName;
  end
  else
    UserDBModule.quSysConst.Edit;
  UserDBModule.quSysConst.FieldByName('sys_const_value').AsString:=Value;
  if UserDBModule.quSysConst.FieldByName('sys_consts_value_type').IsNull then
    UserDBModule.quSysConst.FieldByName('sys_consts_value_type').AsInteger:=ValueType;
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

procedure TUserDBModule.DoIntLRObjects;
begin
  FfrCheckBox:=TfrCheckBoxObject.Create(Self);
end;

procedure TUserDBModule.DataModuleCreate(Sender: TObject);
begin
  DoIntLRObjects;
  {$IF (ZEOS_MAJOR_VERSION = 7) and  (ZEOS_MINOR_VERSION < 3)}
  UserDB.Protocol:='sqlite-3';
  {$ELSE}
  UserDB.Protocol:='sqlite';
  {$ENDIF}
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

procedure DoBackupBase;
var
  S, S1: String;
  I: Integer;
begin
  S:=LocalCfgFolder + UserDBFileName;
  I:=0;
  repeat
    S1:=S + '.ver-'+IntToStr(CVer)+'.' + DateToStr(Date) + '-'+ IntToStr(i) + '.bak';
  until FileExistsUTF8(S);
  CopyFile(S, S1, true);
end;

begin
  UserDB.Connect;
  SystemVariablesLoad;
  CVer:=ConfigValues.ByNameAsInteger('GLOBAL/ConfigDBVersion', -1);
  if  CVer< ConfDBVers then
  begin
    UserDB.Disconnect;
    DoBackupBase;


    if CVer < 1 then
      InternalConvertDB
    else
    if CVer < 2 then
      InternalUpdate2;

    if CVer < 3 then
      InternalUpdate3;

    if CVer < 4 then
      InternalUpdate4;

    if CVer < 5 then
      InternalUpdate5;

    UserDB.Connect;
    SystemVariablesLoad;
    ConfigValues.SetByNameAsInteger('GLOBAL/ConfigDBVersion', ConfDBVers);
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
    quSysConst.FieldByName('sys_const_name').Assign(quOldSysConst.FieldByName('sys_const_name'));
    quSysConst.FieldByName('sys_const_value').Assign(quOldSysConst.FieldByName('sys_const_value'));
    quSysConst.FieldByName('sys_consts_value_type').Assign(quOldSysConst.FieldByName('sys_consts_value_type'));
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
    quFolders.FieldByName('db_folders_id').Assign(quOldFolders.FieldByName('db_folders_id'));
    quFolders.FieldByName('db_folders_code').Assign(quOldFolders.FieldByName('db_folders_code'));
    quFolders.FieldByName('db_folders_name').Assign(quOldFolders.FieldByName('db_folders_name'));
    quFolders.FieldByName('db_folders_desc').Assign(quOldFolders.FieldByName('db_folders_desc'));
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
  OldUserDB.Protocol:=UserDB.Protocol;
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
  try
    UpdDB2.Execute;
  finally
    UserDB.Disconnect;
  end;
end;

procedure TUserDBModule.InternalUpdate3;
begin
  UserDB.Connect;
  try
    UpdDB3.Execute;
  finally
    UserDB.Disconnect;
  end;
end;

procedure TUserDBModule.InternalUpdate4;
begin
  UserDB.Connect;
  try
    UpdDB4.Execute;
  finally
    UserDB.Disconnect;
  end;
end;

procedure TUserDBModule.InternalUpdate5;
begin
  UserDB.Connect;
  try
    UpdDB5.Execute;
  finally
    UserDB.Disconnect;
  end;
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
      quParamsHistory.FieldByName('db_database_id').AsInteger:=ID;
      quParamsHistory.FieldByName('sql_editors_history_param_name').AsString:=Par.Names[i];
      quParamsHistory.FieldByName('sql_editors_history_param_value').AsString:=Par.ValueFromIndex[i];
      quParamsHistory.FieldByName('sql_editors_history_param_type').AsInteger:=2;
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
    quFolders.FieldByName('db_folders_code').AsInteger:=i;
    quFolders.FieldByName('db_folders_name').AsString:=DBListStream.ReadString('Folders/Item'+IntToStr(i), 'Name', '');
    quFolders.FieldByName('db_folders_desc').AsString:=DBListStream.ReadString('Folders/Item'+IntToStr(i), 'Description', '');
    quFolders.FieldByName('db_folders_expanded').AsBoolean:=DBListStream.ReadBool('Folders/Item'+IntToStr(i), 'Expandex', false);
    quFolders.Post;
  end;
  quFolders.Refresh;

  C:=DBListStream.ReadInteger('General', 'RecordCount', 0);
  for i:=0 to C-1 do
  begin
    AItemName:='Item_'+IntToStr(i);
    quDatabases.Append;
    //quDatabasesdb_database_id: TLargeintField;
    quDatabases.FieldByName('db_database_sql_engine').AsString:=DBListStream.ReadString(aItemName, 'SQLEngine', '');
    if quDatabases.FieldByName('db_database_sql_engine').AsString = 'TMySQLEngine' then
      quDatabases.FieldByName('db_database_sql_engine').AsString:='TSQLEngineMySQL';
    quDatabases.FieldByName('db_database_sort_order').AsInteger:=i;
    quDatabases.FieldByName('db_database_description').AsString:='';

    quDatabases.FieldByName('db_database_database_name').AsString:=DBListStream.ReadString(aItemName, 'DataBaseName', '');
    quDatabases.FieldByName('db_database_username').AsString:=DBListStream.ReadString(aItemName, 'UserName', '');;
    quDatabases.FieldByName('db_database_password').AsString:=DBListStream.ReadString(aItemName, 'Password', '');
    quDatabases.FieldByName('db_database_caption').AsString:=DBListStream.ReadString(aItemName, 'AliasName', '');
    quDatabases.FieldByName('db_database_server_name').AsString:=DBListStream.ReadString(aItemName, 'ServerName', '');
    quDatabases.FieldByName('db_database_remote_port').AsInteger:=DBListStream.ReadInteger(aItemName, 'RemotePort', 0);
    quDatabases.FieldByName('db_database_server_version').AsString:=DBListStream.ReadString(aItemName, 'ServerVersion', '');
    quDatabases.FieldByName('db_database_connected_charset').AsString:=DBListStream.ReadString(aItemName, TargetOS+'-CharSet', '');

    if DBListStream.ReadString(aItemName, 'RoleName ', '') <> '' then
      quDatabases.FieldByName('db_database_user_role').AsString:=DBListStream.ReadString(aItemName, 'RoleName ', '')
    else
    if DBListStream.ReadString(aItemName, 'UserRole ', '') <> '' then
      quDatabases.FieldByName('db_database_user_role').AsString:=DBListStream.ReadString(aItemName, 'UserRole ', '');

    quDatabases.FieldByName('report_manager_folder').AsString:=DBListStream.ReadString(aItemName, 'ReportManagerFolder', '');
    quDatabases.FieldByName('show_system_tables').AsBoolean:=DBListStream.ReadBool(aItemName, 'ShowSystemTables', false);
    quDatabases.FieldByName('sp_editor_lazzy_mode').AsBoolean:=DBListStream.ReadBool(aItemName, 'SPEditLazzyMode', false);
    quDatabases.FieldByName('trg_editor_lazzy_mode').AsBoolean:=DBListStream.ReadBool(aItemName, 'TriggerEditLazzyMode', false);
    quDatabases.FieldByName('db_database_shedule').AsBoolean:=DBListStream.ReadBool(aItemName, 'UsePGShedule', false);
    quDatabases.FieldByName('db_database_library_name').AsString:=DBListStream.ReadString(aItemName, 'ClientLibraryName', '');
    quDatabases.FieldByName('db_database_authentication_type').AsString:=DBListStream.ReadString(aItemName, 'AuthenticationType', '');
    quDatabases.FieldByName('db_database_auto_grant').AsBoolean:=DBListStream.ReadBool(AItemName, 'AutoGrantObject', false);
    quDatabases.FieldByName('db_database_use_log_meta').AsBoolean:=DBListStream.ReadBool(aItemName, 'LogMetadata', false);
    quDatabases.FieldByName('db_database_use_log_editor').AsBoolean:=DBListStream.ReadBool(aItemName, 'LogSQLEditor', false);
    quDatabases.FieldByName('db_database_log_meta_filename').AsString:=DBListStream.ReadString(aItemName, 'LogFileMetadata', '');
    quDatabases.FieldByName('db_database_log_editor_filename').AsString:=DBListStream.ReadString(aItemName, 'LogFileSQLEditor', '');
    quDatabases.FieldByName('db_database_use_log_meta_custom_charset').AsBoolean:=DBListStream.ReadString(aItemName, 'LogFileCodePage', '') <> '';
    quDatabases.FieldByName('db_database_log_meta_custom_charset').AsString:=DBListStream.ReadString(aItemName, 'LogFileCodePage', '');
    quDatabases.FieldByName('db_database_use_log_write_timestamp').AsBoolean:=DBListStream.ReadBool(aItemName, 'LogTimestamp', false);


    S:=DBListStream.ReadString(aItemName, 'OIFolder', '');
    if S <> '' then
      if quFolders.Locate('db_folders_name', S, []) then
        quDatabases.FieldByName('db_folders_id').AsInteger:=quFolders.FieldByName('db_folders_id').AsInteger;

    quDatabases.Post;
  end;
  quDatabases.Refresh;

  //Import SQL folder
  quDatabases.First;
  while not quDatabases.EOF do
  begin
    SO:=0;
    AItemName:='Item_'+IntToStr(quDatabases.FieldByName('db_database_sort_order').AsInteger);
    C:=DBListStream.ReadInteger(aItemName, 'SqlPageCount', 0);
    for i:=0 to C-1 do
    begin
      S:=DBListStream.ReadString(aItemName, 'SQLEdit_Page_'+IntToStr(i+1), '');
      if (S<>'') and (DBListStream.ReadString(aItemName, 'SqlGroup_'+S, '') <> '') then
      begin
        S1:=DBListStream.ReadString(aItemName, 'SqlGroup_'+S, '');
        if not quSQLFoldersAll.Locate('db_database_id;sql_editor_folders_name', VarArrayOf([quDatabases.FieldByName('db_database_id').AsInteger, S1]), []) then
        begin
          quSQLFoldersAll.Append;
          quSQLFoldersAlldb_database_id.AsInteger:=quDatabases.FieldByName('db_database_id').AsInteger;
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
    AItemName:='Item_'+IntToStr(quDatabases.FieldByName('db_database_sort_order').AsInteger);
    SDataFolder:=DBListStream.ReadString(aItemName, 'SavedFolder', '');
    DoLoadHistory(quDatabases.FieldByName('db_database_id').AsInteger, quDatabases.FieldByName('db_database_sort_order').AsInteger);

    if SDataFolder <> '' then
    begin
      ImportLoadRecentObjects(quDatabases.FieldByName('db_database_id').AsInteger, SDataFolder);
      ImportLoadSQLPages(DBListStream, AItemName, quDatabases.FieldByName('db_database_id').AsInteger, SDataFolder);

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
      quRecentItems.FieldByName('db_database_id').AsInteger:=DataBaseID;
      quRecentItems.FieldByName('db_recent_objects_date').AsDateTime:=Now;
      quRecentItems.FieldByName('db_recent_objects_type').AsInteger:=0;
      quRecentItems.FieldByName('db_recent_objects_name').AsString:=Ini.ReadString('Windows', S, '');
      quRecentItems.Post;
    end;
  end;

  if Ini.ReadInteger('SQLEditor', 'Present', 0) = 1 then
  begin
    quRecentItems.Append;
    quRecentItems.FieldByName('db_database_id').AsInteger:=DataBaseID;
    quRecentItems.FieldByName('db_recent_objects_date').AsDateTime:=Now;
    quRecentItems.FieldByName('db_recent_objects_type').AsInteger:=5;
    quRecentItems.FieldByName('db_recent_objects_name').AsString:='FBM SQL EDITOR';
    quRecentItems.Post;
  end;

  C:=Ini.ReadInteger('SQLSctip_Recent', 'Count', 0);
  for i:=0 to C-1 do
  begin
    S:='Item_0_' + IntToStr(i);
    if Ini.ReadString('SQLSctip_Recent', S+'_FileName', '') <> '' then
    begin
      quRecentItems.Append;
      quRecentItems.FieldByName('db_database_id').AsInteger:=DataBaseID;
      quRecentItems.FieldByName('db_recent_objects_date').AsDateTime:=Ini.ReadDateTime('SQLSctip_Recent', S+'_FileDate', Now);
      quRecentItems.FieldByName('db_recent_objects_type').AsInteger:=4;
      quRecentItems.FieldByName('db_recent_objects_name').AsString:=Ini.ReadString('SQLSctip_Recent', S+'_FileName', '');
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
      quRecentItems.FieldByName('db_database_id').AsInteger:=DataBaseID;
      quRecentItems.FieldByName('db_recent_objects_date').AsDateTime:=Ini.ReadDateTime('SQLSctip_Recent', S+'_FileDate', Now);
      quRecentItems.FieldByName('db_recent_objects_type').AsInteger:=2;
      quRecentItems.FieldByName('db_recent_objects_name').AsString:=Ini.ReadString('SQLSctip_Recent', S+'_FileName', '');
      quRecentItems.Post;
    end;
  end;
  Ini.Free;
  DeleteFileUTF8(AFileName);
end;

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
    quSQLPages.FieldByName('db_database_id').AsInteger:=DataBaseID;
    quSQLPages.FieldByName('sql_editors_caption').AsString:=Ini.ReadString(aItemName, 'SqlName_'+SPage, '');
    quSQLPages.FieldByName('sql_editors_carret_pos_x').AsInteger:=Ini.ReadInteger(aItemName, 'SQLEdit_'+SPage+'_CaretX', 0);
    quSQLPages.FieldByName('sql_editors_carret_pos_y').AsInteger:=Ini.ReadInteger(aItemName, 'SQLEdit_'+SPage+'_CaretY', 0);
    quSQLPages.FieldByName('sql_editors_sel_start').AsInteger:=Ini.ReadInteger(aItemName, 'SQLEdit_'+SPage+'_SelStart', 0);
    quSQLPages.FieldByName('sql_editors_sel_end').AsInteger:=Ini.ReadInteger(aItemName, 'SQLEdit_'+SPage+'_SelEnd', 0);
    quSQLPages.FieldByName('sql_editors_sort_order').AsInteger:=i;
    S:=Ini.ReadString(aItemName, 'SQLEdit_'+SPage+'_FileName', '');
    S:=AppendPathDelim(LocalCfgFolder + ADataFolder) + S;
    S1:=LoadFormTextFile(S);
    quSQLPages.FieldByName('sql_editors_body').AsString:=S1;

    S1:=Ini.ReadString(aItemName, 'SqlGroup_'+SPage, '');
    if (S1<>'') then
    begin
      if quSQLFoldersAll.Locate('db_database_id;sql_editor_folders_name', VarArrayOf([DataBaseID, S1]), []) then
        quSQLPages.FieldByName('sql_editor_folders_id').AsInteger:=quSQLFoldersAllsql_editor_folders_id.AsInteger;
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
  if LocalDBConfigFileName<>'' then
    DBFileName:=LocalDBConfigFileName
  else
    DBFileName:=LocalCfgFolder + UserDBFileName;

  UserDB.Database:=DBFileName;
  if FileExistsUTF8(DBFileName) then
  begin
    InternalCheckDBVersion;
  end
  else
  begin
    InternalCreateUserDB;
    ConfigValues.SetByNameAsInteger('GLOBAL/ConfigDBVersion', ConfDBVers);
  end;
  SystemVariablesStore;
  LoadLocalize(ConfigValues.ByNameAsString('lngFileName', DefLanguageFile));

  //
  pgShowTtablePartiotions:=ConfigValues.ByNameAsBoolean('TSQLEnginePostgre\Show table partiotions', PGShowTtablePartiotions);
  pgUseParamsChar:=ConfigValues.ByNameAsBoolean('TSQLEnginePostgre\Use params char', pgUseParamsChar);
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

