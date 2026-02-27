{ Free DB Manager

  Copyright (C) 2005-2025 Lagunov Aleksey  alexs75 at yandex.ru

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

unit pgActivitiMonitorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, StdCtrls, ActnList, Spin, Grids, Menus, Buttons, ibmanagertypesunit,
  db, fdbm_monitorabstractunit, SQLEngineAbstractUnit, rxdbgrid, rxtoolbar,
  rxmemds, RxIniPropStorage, TASources, TAGraph, TASeries, TALegendPanel,
  TADbSource, TAIntervalSources, SynEdit, ZMacroQuery, ZDataset, ZConnection,
  fdbm_SynEditorUnit, PostgreSQLEngineUnit;

type

  { TpgActivitiMonitorForm }

  TpgActivitiMonitorForm = class(TfdbmMonitorAbstractForm)
    dsPGLocks: TDataSource;
    Panel5: TPanel;
    PopupMenu2: TPopupMenu;
    quActiveSessionspid: TLongintField;
    quPGLocksblocked_pid: TLongintField;
    quPGLocksblocked_statement: TMemoField;
    quPGLocksblocked_user: TStringField;
    quPGLocksblocking_pid: TLongintField;
    quPGLocksblocking_user: TStringField;
    quPGLockscurrent_statement_in_blocking_process: TMemoField;
    Splitter5: TSplitter;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    tlsRefreskPGLocks: TAction;
    CheckBox3: TCheckBox;
    Label4: TLabel;
    MenuItem4: TMenuItem;
    Panel4: TPanel;
    RxDBGrid4: TRxDBGrid;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpinEdit2: TSpinEdit;
    Splitter4: TSplitter;
    TabSheet3: TTabSheet;
    Timer3: TTimer;
    tlsRefreshConnectionsList: TAction;
    DateTimeIntervalChartSource1: TDateTimeIntervalChartSource;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    Panel3: TPanel;
    PopupMenu1: TPopupMenu;
    quConnectionspid: TLongintField;
    rxActivitiDataID: TDateTimeField;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    tlsCancelQuery: TAction;
    tlsDisconectConnection: TAction;
    ActionList1: TActionList;
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    Chart1LineSeries2: TLineSeries;
    Chart1LineSeries3: TLineSeries;
    Chart2: TChart;
    Chart2LineSeries1: TLineSeries;
    Chart2LineSeries2: TLineSeries;
    Chart2LineSeries3: TLineSeries;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    csTransAct: TDbChartSource;
    csTransIdle: TDbChartSource;
    csTransRolback: TDbChartSource;
    dsStatInfo: TDataSource;
    dsActiveSessions: TDatasource;
    csActAct: TDbChartSource;
    csActIdl: TDbChartSource;
    dsConnections: TDataSource;
    dsActivitiData: TDataSource;
    csActAll: TDbChartSource;
    Label2: TLabel;
    Label3: TLabel;
    PageControl1: TPageControl;
    Panel2: TPanel;
    quActivConectc_active_tran: TLargeintField;
    quActivConectc_all: TLargeintField;
    quActivConectc_idle: TLargeintField;
    quActivConectc_idle_in_rollback: TLargeintField;
    quActivConectc_idle_in_tran: TLargeintField;
    quActiveSessionsapplication_name: TStringField;
    quActiveSessionsbackend_start: TDateTimeField;
    quActiveSessionsclient_addr: TStringField;
    quActiveSessionsclient_hostname: TStringField;
    quActiveSessionsclient_port: TLongintField;
    quActiveSessionsdatid: TLongintField;
    quActiveSessionsdatname: TStringField;
    quActiveSessionsquery: TMemoField;
    quActiveSessionsquery_start: TDateTimeField;
    quActiveSessionsstate: TMemoField;
    quActiveSessionsusename: TStringField;
    quConnectionsapplication_name: TStringField;
    quConnectionsbackend_start: TDateTimeField;
    quConnectionsclient_addr: TStringField;
    quConnectionsclient_hostname: TStringField;
    quConnectionsclient_port: TLongintField;
    quConnectionsdatid: TLongintField;
    quConnectionsdatname: TStringField;
    quConnectionsquery: TMemoField;
    quConnectionsquery_start: TDateTimeField;
    quConnectionsstate: TStringField;
    quConnectionsusename: TStringField;
    rxActivitiDataACTIVE: TLongintField;
    rxActivitiDataALL: TLongintField;
    rxActivitiDataIDLE: TLongintField;
    rxActivitiDataIN_TRANS_ACTIVE: TLongintField;
    rxActivitiDataIN_TRANS_IDLE: TLongintField;
    rxActivitiDataIN_TRANS_ROLBACK: TLongintField;
    RxDBGrid1: TRxDBGrid;
    rxActivitiData: TRxMemoryData;
    RxDBGrid2: TRxDBGrid;
    RxDBGrid3: TRxDBGrid;
    RxIniPropStorage1: TRxIniPropStorage;
    rxStatInfo: TRxMemoryData;
    rxStatInfoPARAM: TStringField;
    rxStatInfoVALUE: TStringField;
    SpinEdit1: TSpinEdit;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    tabDashboard: TTabSheet;
    Timer2: TTimer;
    pgStatDB: TZConnection;
    quActiveSessions: TZQuery;
    quConnections: TZQuery;
    quActivConect: TZReadOnlyQuery;
    quDBStat: TZReadOnlyQuery;
    quCancelQuery: TZReadOnlyQuery;
    quTerminate: TZReadOnlyQuery;
    quPGLocks: TZQuery;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure pgStatDBBeforeConnect(Sender: TObject);
    procedure quActiveSessionsAfterScroll(DataSet: TDataSet);
    procedure quConnectionsAfterScroll(DataSet: TDataSet);
    procedure quPGLocksAfterScroll(DataSet: TDataSet);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure tlsCancelQueryExecute(Sender: TObject);
    procedure tlsDisconectConnectionExecute(Sender: TObject);
    procedure tlsRefreshConnectionsListExecute(Sender: TObject);
    procedure tlsRefreskPGLocksExecute(Sender: TObject);
  private
    FActiveQueryText:Tfdbm_SynEditorFrame;
    FActiveQueryText2:Tfdbm_SynEditorFrame;
    FActiveQueryText3:Tfdbm_SynEditorFrame;
    FActiveQueryText4:Tfdbm_SynEditorFrame;
    procedure RefreshInfoCharts;
    procedure RefreshConnections;
    procedure RefreshPGLocks;
    procedure LoadDBStat;
    procedure ClearInfoCharts;
  protected
    procedure Localize; override;
    procedure ConnectToDB(ASQLEngine: TSQLEngineAbstract); override;
    procedure StatTimeTick; override;
  public
    { public declarations }
  end; 


procedure ShowpgActivitiMonitorForm;
implementation

uses IBManMainUnit, fbmStrConstUnit, fbmToolsUnit, IBManDataInspectorUnit,
  rxAppUtils, rxstrutils;

{$R *.lfm}

var
  pgActivitiMonitorForm: TpgActivitiMonitorForm = nil;

procedure ShowpgActivitiMonitorForm;
begin
  fbManagerMainForm.RxMDIPanel1.ChildWindowsCreate(pgActivitiMonitorForm, TpgActivitiMonitorForm)
end;

  { TpgActivitiMonitorForm }

procedure TpgActivitiMonitorForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
  pgActivitiMonitorForm:=nil;
end;

procedure TpgActivitiMonitorForm.FormCreate(Sender: TObject);
begin
  pgStatDB.Protocol:='postgresql'; //pgZeosServerVersionProtoStr[FServerVersion];

  ClearInfoCharts;

  FActiveQueryText:=Tfdbm_SynEditorFrame.Create(Self);
  FActiveQueryText.Name:='FActiveQueryText';
  FActiveQueryText.Parent:=Panel3;
  FActiveQueryText.ReadOnly:=true;
  FActiveQueryText.Align:=alRight;
  FActiveQueryText.Width:=Panel3.Width div 4;
  FActiveQueryText.TextEditor.Gutter.Visible:=false;
  Splitter1.Left:=FActiveQueryText.Top - Splitter1.Width;

  FActiveQueryText2:=Tfdbm_SynEditorFrame.Create(Self);
  FActiveQueryText2.Name:='FActiveQueryText2';
  FActiveQueryText2.Parent:=TabSheet1;
  FActiveQueryText2.ReadOnly:=true;
  FActiveQueryText2.Align:=alRight;
  FActiveQueryText2.Width:=TabSheet1.Width div 4;
  FActiveQueryText2.TextEditor.Gutter.Visible:=false;
  Splitter3.Left:=FActiveQueryText2.Top - Splitter3.Width;

  FActiveQueryText3:=Tfdbm_SynEditorFrame.Create(Self);
  FActiveQueryText3.Name:='FActiveQueryText3';
  FActiveQueryText3.Parent:=Panel5;
  FActiveQueryText3.Top:=StaticText1.Height;
  FActiveQueryText3.ReadOnly:=true;
  FActiveQueryText3.Align:=alTop;
  //FActiveQueryText3.Width:=TabSheet3.Width div 4;
  FActiveQueryText3.TextEditor.Gutter.Visible:=false;
  Splitter5.Align:=alTop;

  FActiveQueryText4:=Tfdbm_SynEditorFrame.Create(Self);
  FActiveQueryText4.Name:='FActiveQueryText4';
  FActiveQueryText4.Parent:=Panel5;
  FActiveQueryText4.ReadOnly:=true;
  FActiveQueryText4.Align:=alClient;
  //FActiveQueryText4.Width:=TabSheet3.Width div 4;
  FActiveQueryText4.TextEditor.Gutter.Visible:=false;

  StaticText2.Top:=Splitter5.Top + Splitter5.Height;
  StaticText2.Align:=alTop;

  DoFillDatabaseList(TSQLEnginePostgre);

  PageControl1.ActivePageIndex:=0;
end;

procedure TpgActivitiMonitorForm.PageControl1Change(Sender: TObject);
begin
  Timer2.Enabled:=(PageControl1.ActivePage = TabSheet1) and (CheckBox2.Checked);
  Timer3.Enabled:=(PageControl1.ActivePage = TabSheet3) and (CheckBox3.Checked);

  quConnections.Active:=(PageControl1.ActivePage = TabSheet1) and (quConnections.Connection.Connected);
  quPGLocks.Active:=(PageControl1.ActivePage = TabSheet3) and (quConnections.Connection.Connected);

  if PageControl1.ActivePage = TabSheet2 then
    LoadDBStat;
end;

procedure TpgActivitiMonitorForm.pgStatDBBeforeConnect(Sender: TObject);
begin
  pgStatDB.Properties.Clear;
  pgStatDB.Properties.Add('AutoEncodeStrings=');
  pgStatDB.Properties.Add('codepage=');
  pgStatDB.Properties.Add('controls_cp=CP_UTF8');
  {$IFNDEF WINDOWS}
  //pgStatDB.Properties.Add('application_name=FBManager');
  //pgStatDB.Properties.Values['application_name']:=Application.Title;
  pgStatDB.Properties.Values['application_name']:=ExtractFileName(ParamStr(0));
  {$ENDIF}
end;

procedure TpgActivitiMonitorForm.quActiveSessionsAfterScroll(DataSet: TDataSet);
begin
  FActiveQueryText.EditorText:=quActiveSessionsquery.AsString;
end;

procedure TpgActivitiMonitorForm.quConnectionsAfterScroll(DataSet: TDataSet);
begin
  FActiveQueryText2.EditorText:=quConnectionsquery.AsString;
end;

procedure TpgActivitiMonitorForm.quPGLocksAfterScroll(DataSet: TDataSet);
begin
  FActiveQueryText3.EditorText:=quPGLocksblocked_statement.AsString;
  FActiveQueryText4.EditorText:=quPGLockscurrent_statement_in_blocking_process.AsString;
end;

procedure TpgActivitiMonitorForm.SpinEdit1Change(Sender: TObject);
begin
  Timer2.Enabled:=false;
  Timer2.Interval:=SpinEdit1.Value * 1000;
  Timer2.Enabled:=(PageControl1.ActivePage = TabSheet1) and CheckBox2.Checked;
end;

procedure TpgActivitiMonitorForm.SpinEdit2Change(Sender: TObject);
begin
  Timer3.Enabled:=false;
  Timer3.Interval:=SpinEdit2.Value * 1000;
  Timer3.Enabled:=(PageControl1.ActivePage = TabSheet3) and CheckBox3.Checked;
end;

procedure TpgActivitiMonitorForm.Timer2Timer(Sender: TObject);
begin
  if pgStatDB.Connected and CheckBox2.Checked then
  begin
    try
      RefreshConnections;
    except
      CheckBox2.Checked:=false;
      Timer2.Enabled:=false;
    end;
  end;
end;

procedure TpgActivitiMonitorForm.Timer3Timer(Sender: TObject);
begin
  if pgStatDB.Connected and CheckBox3.Checked then
    RefreshPGLocks;
end;

procedure TpgActivitiMonitorForm.tlsCancelQueryExecute(Sender: TObject);
begin
  if QuestionBox(sCancelQueryQuestion) then
  begin
    quCancelQuery.ParamByName('pid').AsInteger:=quConnectionspid.AsInteger;
    quCancelQuery.Open;
    quCancelQuery.Close;
    tlsRefreshConnectionsList.Execute;
  end;
end;

procedure TpgActivitiMonitorForm.tlsDisconectConnectionExecute(Sender: TObject);
begin
  if QuestionBox(sCancelQueryQuestion) then
  begin
    quTerminate.ParamByName('pid').AsInteger:=quConnectionspid.AsInteger;
    quTerminate.Open;
    quTerminate.Close;
    tlsRefreshConnectionsList.Execute;
  end;
end;

procedure TpgActivitiMonitorForm.tlsRefreshConnectionsListExecute(Sender: TObject);
begin
  RefreshConnections;
end;

procedure TpgActivitiMonitorForm.tlsRefreskPGLocksExecute(Sender: TObject);
begin
  RefreshPGLocks;
end;

procedure TpgActivitiMonitorForm.Localize;
begin
  inherited Localize;
  Caption:=sActivitiMonitor;
  tabDashboard.Caption:=sDashboard;
  TabSheet1.Caption:=sConnections;
  TabSheet2.Caption:=sStatistic;
  TabSheet3.Caption:=sPGLocks;
  Label3.Caption:=sRefreshIntervalInSeconds;
  Label4.Caption:=sRefreshIntervalInSeconds;
  CheckBox1.Caption:=sRefresh;
  CheckBox2.Caption:=sRefresh;
  CheckBox3.Caption:=sRefresh;
  tlsRefreshConnectionsList.Caption:=sRefreshDataHint;
  tlsRefreskPGLocks.Caption:=sRefreshDataHint;
  tlsCancelQuery.Caption:=sCancelQuery;
  tlsCancelQuery.Hint:=sCancelQueryHint;
  tlsDisconectConnection.Caption:=sDisconectConnection;
  tlsDisconectConnection.Hint:=sDisconectConnectionHint;
  StaticText1.Caption:=sBlockedStatement;
  StaticText2.Caption:=sCurrentStatementInBlockingProcess;

  RxDBGrid3.ColumnByFieldName('PARAM').Title.Caption:=sParamName;
  RxDBGrid3.ColumnByFieldName('VALUE').Title.Caption:=sParamValue;


  RxDBGrid1.ColumnByFieldName('datid').Title.Caption:=sDatabaseID;
  RxDBGrid1.ColumnByFieldName('datname').Title.Caption:=sDatabase;
  RxDBGrid1.ColumnByFieldName('usename').Title.Caption:=sUserName1;
  RxDBGrid1.ColumnByFieldName('application_name').Title.Caption:=sApplicationName;
  RxDBGrid1.ColumnByFieldName('state').Title.Caption:=sState;
  RxDBGrid1.ColumnByFieldName('client_addr').Title.Caption:=sClientAddress;
  RxDBGrid1.ColumnByFieldName('client_hostname').Title.Caption:=sClientHostname;
  RxDBGrid1.ColumnByFieldName('client_port').Title.Caption:=sClientPort;
  RxDBGrid1.ColumnByFieldName('backend_start').Title.Caption:=sBackendStart;
  RxDBGrid1.ColumnByFieldName('query_start').Title.Caption:=sQueryStart;
//  RxDBGrid1.ColumnByFieldName('query').Title.Caption:=sQuery;


  RxDBGrid2.ColumnByFieldName('datid').Title.Caption:=sDatabaseID;
  RxDBGrid2.ColumnByFieldName('datname').Title.Caption:=sDatabase;
  RxDBGrid2.ColumnByFieldName('usename').Title.Caption:=sUserName1;
  RxDBGrid2.ColumnByFieldName('application_name').Title.Caption:=sApplicationName;
  RxDBGrid2.ColumnByFieldName('client_addr').Title.Caption:=sClientAddress;
  RxDBGrid2.ColumnByFieldName('client_hostname').Title.Caption:=sClientHostname;
  RxDBGrid2.ColumnByFieldName('client_port').Title.Caption:=sClientPort;
  RxDBGrid2.ColumnByFieldName('backend_start').Title.Caption:=sBackendStart;
  RxDBGrid2.ColumnByFieldName('query_start').Title.Caption:=sQueryStart;
//  RxDBGrid2.ColumnByFieldName('query').Title.Caption:=sQuery;

  RxDBGrid4.ColumnByFieldName('blocked_pid').Title.Caption:=sBlockedPid;
  RxDBGrid4.ColumnByFieldName('blocked_user').Title.Caption:=sBlockedUser;
  RxDBGrid4.ColumnByFieldName('blocking_pid').Title.Caption:=sBlockingPid;
  RxDBGrid4.ColumnByFieldName('blocking_user').Title.Caption:=sBlockingUser;

  Chart1.Title.Text.Text:=sDatabaseSessions;
  (Chart1.Series[0] as TLineSeries).Title:=sActive;
  (Chart1.Series[1] as TLineSeries).Title:=sIdle;
  (Chart1.Series[2] as TLineSeries).Title:=sTotal;

  Chart2.Title.Text.Text:=sTransactionPerSecond;
  (Chart2.Series[0] as TLineSeries).Title:=sActive;
  (Chart2.Series[1] as TLineSeries).Title:=sIdle;
  (Chart2.Series[2] as TLineSeries).Title:=sRolback;
end;

procedure TpgActivitiMonitorForm.ConnectToDB(ASQLEngine: TSQLEngineAbstract);
begin
  inherited ConnectToDB(ASQLEngine);
  pgStatDB.Connected:=false;
  ClearInfoCharts;
  try
//    rxActivitiData.Active:=true;
    pgStatDB.Database:=ASQLEngine.DataBaseName;
    pgStatDB.HostName:=ASQLEngine.ServerName;
    pgStatDB.User:=ASQLEngine.UserName;
    pgStatDB.Password:=ASQLEngine.Password;
    pgStatDB.Connected:=true;
  finally
  end;

  if (PageControl1.ActivePage = TabSheet2) and pgStatDB.Connected then
    LoadDBStat;

  FActiveQueryText.SQLEngine:=ASQLEngine;
  FActiveQueryText2.SQLEngine:=ASQLEngine;
  FActiveQueryText3.SQLEngine:=ASQLEngine;
  FActiveQueryText4.SQLEngine:=ASQLEngine;
end;

procedure TpgActivitiMonitorForm.StatTimeTick;
begin
  inherited StatTimeTick;
  if pgStatDB.Connected then
  begin
    try
      RefreshInfoCharts;
    except
      DisableTimer;
      ErrorBox('Ошибка');
    end;
  end;
end;

procedure TpgActivitiMonitorForm.RefreshInfoCharts;
begin
  quActivConect.Open;
  rxActivitiData.DisableControls;
  if rxActivitiData.RecordCount > 100 then
  begin
    rxActivitiData.First;
    rxActivitiData.Delete;
  end;
  rxActivitiData.Append;
  //rxActivitiDataID.AsInteger:=TimeID;
  rxActivitiDataID.AsDateTime:=Now;
  rxActivitiDataALL.AsInteger:=quActivConectc_all.AsInteger;
  rxActivitiDataIDLE.AsInteger:=quActivConectc_idle.AsInteger;
  rxActivitiDataACTIVE.AsInteger:=rxActivitiDataALL.AsInteger - rxActivitiDataIDLE.AsInteger;

  rxActivitiDataIN_TRANS_IDLE.AsInteger:=quActivConectc_idle_in_tran.AsInteger;
  rxActivitiDataIN_TRANS_ACTIVE.AsInteger:=quActivConectc_active_tran.AsInteger;
  rxActivitiDataIN_TRANS_ROLBACK.AsInteger:=quActivConectc_idle_in_rollback.AsInteger;

  rxActivitiData.Post;
  rxActivitiData.EnableControls;

  (Chart1.Series[0] as TLineSeries).Title:=sActive + ' (' + IntToStr(quActivConectc_all.AsInteger - quActivConectc_idle.AsInteger) + ')';
  (Chart1.Series[1] as TLineSeries).Title:=sIdle + ' ('+IntToStr(quActivConectc_idle.AsInteger)+')';
  (Chart1.Series[2] as TLineSeries).Title:=sTotal + ' ('+IntToStr(quActivConectc_all.AsInteger)+')';

  (Chart2.Series[0] as TLineSeries).Title:=sActive + ' (' + IntToStr(quActivConectc_active_tran.AsInteger) + ')';
  (Chart2.Series[1] as TLineSeries).Title:=sIdle + ' (' + IntToStr(quActivConectc_idle_in_tran.AsInteger) + ')';
  (Chart2.Series[2] as TLineSeries).Title:=sRolback + ' (' + IntToStr(quActivConectc_idle_in_rollback.AsInteger) + ')';

  quActivConect.Close;

  if CheckBox1.Checked then
  begin
    quActiveSessions.Active:=false;
    quActiveSessions.Active:=true;
  end;
end;

procedure TpgActivitiMonitorForm.RefreshConnections;
begin
  quConnections.Close;
  quConnections.Open;
end;

procedure TpgActivitiMonitorForm.RefreshPGLocks;
begin
  quPGLocks.Close;
  quPGLocks.Open;
end;

procedure TpgActivitiMonitorForm.LoadDBStat;
begin
  rxStatInfo.Close;
  if (not Assigned(SQLEngine)) or (SQLEngine.DataBaseName = '') then exit;
  if not quDBStat.Connection.Connected then exit;
  quDBStat.ParamByName('DBName').AsString:=SQLEngine.DataBaseName;
  quDBStat.Open;
  rxStatInfo.Open;
  if quDBStat.RecordCount > 0 then
  begin
    rxStatInfo.AppendRecord([sServerVersion1, pgStatDB.ServerVersionStr]);
    rxStatInfo.AppendRecord([sDatabaseID, quDBStat.FieldByName('datid').AsString]);
    rxStatInfo.AppendRecord([sDatabaseName, quDBStat.FieldByName('datname').AsString]);               //Имя базы данных
    rxStatInfo.AppendRecord([sDatabaseNumBackends, quDBStat.FieldByName('numbackends').AsString]);    //Количество серверных процессов, в настоящее время подключённых к этой базе данных. Это единственный столбец в этом представлении, значение в котором отражает текущее состояние; все другие столбцы возвращают суммарные значения со времени последнего сброса статистики.
    rxStatInfo.AppendRecord([sTransactionsCommit, quDBStat.FieldByName('xact_commit').AsString]);     //Количество зафиксированных транзакций в этой базе данных
    rxStatInfo.AppendRecord([sTransactionsRollback, quDBStat.FieldByName('xact_rollback').AsString]); //Количество транзакций в этой базе данных, для которых был выполнен откат транзакции
    rxStatInfo.AppendRecord([sDataBlocksRead, quDBStat.FieldByName('blks_read').AsString]);           //Количество прочитанных дисковых блоков в этой базе данных
    rxStatInfo.AppendRecord([sBlksHit, quDBStat.FieldByName('blks_hit').AsString]);                   //Сколько раз дисковые блоки обнаруживались в буферном кеше, так что чтение с диска не потребовалось (в значение входят только случаи обнаружения в буферном кеше Postgres Pro, а не в кеше файловой системы ОС)
    rxStatInfo.AppendRecord([sTupReturned, quDBStat.FieldByName('tup_returned').AsString]);           //Количество строк, возвращённое запросами в этой базе данных
    rxStatInfo.AppendRecord([sTupFetched, quDBStat.FieldByName('tup_fetched').AsString]);             //Количество строк, извлечённое запросами в этой базе данных
    rxStatInfo.AppendRecord([sTupInserted, quDBStat.FieldByName('tup_inserted').AsString]);           //Количество строк, вставленное запросами в этой базе данных
    rxStatInfo.AppendRecord([sRowCountUpdated, quDBStat.FieldByName('tup_updated').AsString]);        //Количество строк, изменённое запросами в этой базе данных
    rxStatInfo.AppendRecord([sRowCountDeleted, quDBStat.FieldByName('tup_deleted').AsString]);        //Количество строк, удалённое запросами в этой базе данных
    rxStatInfo.AppendRecord([sConflicts, quDBStat.FieldByName('conflicts').AsString]);                //Количество запросов, отменённых из-за конфликта с восстановлением в этой базе данных. (Конфликты происходят только на резервных серверах; более подробно смотрите pg_stat_database_conflicts.)
    rxStatInfo.AppendRecord([sTempFiles, quDBStat.FieldByName('temp_files').AsString]);               //Количество временных файлов, созданных запросами в этой базе данных. Подсчитываются все временные файлы независимо от причины их создания (например, для сортировки или для хеширования) и независимо от установленного значения log_temp_files
    //rxStatInfo.AppendRecord([sTempBytes, quDBStat.FieldByName('temp_bytes').AsString]);               //Общий объём данных, записанных во временные файлы запросами в этой базе данных. Учитываются все временные файлы, вне зависимости от того, по какой причине они созданы и вне зависимости от значения log_temp_files.
    rxStatInfo.AppendRecord([sTempBytes, RxPrettySizeName(quDBStat.FieldByName('temp_bytes').AsLargeInt)]);               //Общий объём данных, записанных во временные файлы запросами в этой базе данных. Учитываются все временные файлы, вне зависимости от того, по какой причине они созданы и вне зависимости от значения log_temp_files.
    rxStatInfo.AppendRecord([sDeadlocks, quDBStat.FieldByName('deadlocks').AsString]);                //Количество взаимных блокировок, зафиксированное в этой базе данных
    rxStatInfo.AppendRecord([sBlkReadTime, quDBStat.FieldByName('blk_read_time').AsString]);          //Время, затраченное серверными процессами в этой базе данных, на чтение блоков из файлов данных, в миллисекундах
    rxStatInfo.AppendRecord([sBlkWriteTime, quDBStat.FieldByName('blk_write_time').AsString]);        //Время, затраченное серверными процессами в этой базе данных, на запись блоков в файлы данных, в миллисекундах
    rxStatInfo.AppendRecord([sStatsDateTime, quDBStat.FieldByName('stats_reset').AsString]);                     //Последнее время сброса этих статистических данных
    rxStatInfo.AppendRecord([sStatsDBSize, RxPrettySizeName(quDBStat.FieldByName('database_size').AsLargeInt)]);  //Объём, который занимает на диске база данных с заданным OID
  end;
  quDBStat.Close;
  rxStatInfo.First;
end;

procedure TpgActivitiMonitorForm.ClearInfoCharts;
var
  i: Integer;
  D: TDateTime;
begin
  quActiveSessions.Active:=false;

  rxActivitiData.Active:=false;
  rxActivitiData.Open;
  D:=Now - 1 / SecsPerDay * 100;
  for i:=0 to 99 do
  begin
    rxActivitiData.Append;
    rxActivitiDataID.AsDateTime:=D ;
    D:=D + 1 / SecsPerDay;
    rxActivitiData.Post;
  end;
end;

end.

