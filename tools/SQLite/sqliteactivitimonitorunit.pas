{ Free DB Manager

  Copyright (C) 2005-2024 Lagunov Aleksey  alexs75 at yandex.ru

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

unit SQLiteActivitiMonitorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, DB, rxmemds, rxdbgrid, fdbm_monitorabstractunit,
  SQLEngineAbstractUnit, ZConnection, ZDataset;

type

  { TSQLiteActivitiMonitorForm }

  TSQLiteActivitiMonitorForm = class(TfdbmMonitorAbstractForm)
    dsStatInfo: TDataSource;
    PageControl1: TPageControl;
    quDBStat: TZReadOnlyQuery;
    RxDBGrid3: TRxDBGrid;
    rxStatInfo: TRxMemoryData;
    rxStatInfoPARAM: TStringField;
    rxStatInfoVALUE: TStringField;
    SQLiteStatDB: TZConnection;
    TabSheet1: TTabSheet;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    procedure LoadDBStat;
    function QueryValue(ASQLText:string; ColNum:integer = 0):string;
  protected
    procedure Localize; override;
    procedure ConnectToDB(ASQLEngine: TSQLEngineAbstract); override;
    procedure StatTimeTick; override;
  public

  end;

procedure ShowpgActivitiMonitorForm;
implementation
uses IBManMainUnit, fbmStrConstUnit, fbmToolsUnit, IBManDataInspectorUnit,
  SQLite3EngineUnit;

var
  SQLiteActivitiMonitorForm: TSQLiteActivitiMonitorForm = nil;
procedure ShowpgActivitiMonitorForm;
begin
  fbManagerMainForm.RxMDIPanel1.ChildWindowsCreate(SQLiteActivitiMonitorForm, TSQLiteActivitiMonitorForm)
end;

{$R *.lfm}

{ TSQLiteActivitiMonitorForm }

procedure TSQLiteActivitiMonitorForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
  SQLiteActivitiMonitorForm:=nil;
end;

procedure TSQLiteActivitiMonitorForm.FormCreate(Sender: TObject);
begin
  DoFillDatabaseList(TSQLEngineSQLite3);

  PageControl1.ActivePageIndex:=0;
end;

procedure TSQLiteActivitiMonitorForm.LoadDBStat;
begin
  rxStatInfo.Close;
  if (not Assigned(SQLEngine)) or (SQLEngine.DataBaseName = '') then exit;
  if not quDBStat.Connection.Connected then exit;
  rxStatInfo.Open;
  rxStatInfo.AppendRecord([sServerVersion1, QueryValue('select sqlite_version()')]);
  rxStatInfo.AppendRecord([sDatabaseList, QueryValue('PRAGMA database_list', 2)]);

  rxStatInfo.AppendRecord([sCompileOptions, QueryValue('PRAGMA compile_options')]);
  rxStatInfo.AppendRecord([sEncoding, QueryValue('PRAGMA encoding')]);
  rxStatInfo.AppendRecord([sAutoVacuum, QueryValue('PRAGMA auto_vacuum')]);
  rxStatInfo.AppendRecord([sCollationList, QueryValue('PRAGMA collation_list', 1)]);
  rxStatInfo.AppendRecord([sTempStoreDirectory, QueryValue('PRAGMA temp_store_directory')]);
  rxStatInfo.AppendRecord([sLegacyFileFormat, QueryValue('PRAGMA legacy_file_format')]);
  rxStatInfo.AppendRecord([sDataVersion, QueryValue('PRAGMA data_version')]);

  rxStatInfo.AppendRecord([sDefaultCacheSize, QueryValue('PRAGMA default_cache_size')]);
  rxStatInfo.AppendRecord([sPageSize1, QueryValue('PRAGMA page_size')]);
  rxStatInfo.AppendRecord([sCacheSize, QueryValue('PRAGMA cache_size')]);
  rxStatInfo.AppendRecord([sPageCount, QueryValue('PRAGMA page_count')]);
  rxStatInfo.AppendRecord([sMaxPageCount, QueryValue('PRAGMA max_page_count')]);
  rxStatInfo.AppendRecord([sJournalMode, QueryValue('PRAGMA journal_mode')]);
  rxStatInfo.AppendRecord([sJournalSizeLimit, QueryValue('PRAGMA journal_size_limit')]);
  rxStatInfo.AppendRecord([sLockingMode, QueryValue('PRAGMA locking_mode')]);
  rxStatInfo.AppendRecord([sSynchronous, QueryValue('PRAGMA synchronous')]);
  rxStatInfo.AppendRecord([sFullfSync, QueryValue('PRAGMA fullfsync')]);

(*


PRAGMA defer_foreign_keys
PRAGMA full_column_names
--PRAGMA legacy_alter_table;

PRAGMA mmap_size;
--PRAGMA module_list;

--PRAGMA pragma_list;
--PRAGMA stats;
*)
end;

function TSQLiteActivitiMonitorForm.QueryValue(ASQLText: string; ColNum:integer = 0
  ): string;
begin
  Result:='';
  quDBStat.SQL.Text:=ASQLText;
  quDBStat.Open;
  while not quDBStat.EOF do
  begin
    if Result <> '' then
      Result:=Result + ', ';
    Result:=Result + quDBStat.Fields[ColNum].AsString;
    quDBStat.Next;
  end;
  quDBStat.Close;
end;

procedure TSQLiteActivitiMonitorForm.Localize;
begin
  inherited Localize;
  TabSheet1.Caption:=sStatistic;

  RxDBGrid3.ColumnByFieldName('PARAM').Title.Caption:=sParamName;
  RxDBGrid3.ColumnByFieldName('VALUE').Title.Caption:=sParamValue;
end;

procedure TSQLiteActivitiMonitorForm.ConnectToDB(ASQLEngine: TSQLEngineAbstract
  );
begin
  inherited ConnectToDB(ASQLEngine);
  SQLiteStatDB.Connected:=false;
  //ClearInfoCharts;
  try
//    rxActivitiData.Active:=true;
    SQLiteStatDB.Database:=ASQLEngine.DataBaseName;
    SQLiteStatDB.HostName:=ASQLEngine.ServerName;
    SQLiteStatDB.User:=ASQLEngine.UserName;
    SQLiteStatDB.Password:=ASQLEngine.Password;
    SQLiteStatDB.Connected:=true;
  finally
  end;

  if (PageControl1.ActivePage = TabSheet1) and SQLiteStatDB.Connected then
    LoadDBStat;

//  FActiveQueryText.SQLEngine:=ASQLEngine;
//  FActiveQueryText2.SQLEngine:=ASQLEngine;
end;

procedure TSQLiteActivitiMonitorForm.StatTimeTick;
begin
  inherited StatTimeTick;
end;

end.

