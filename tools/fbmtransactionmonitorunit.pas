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

unit fbmTransactionMonitorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SynEdit, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ActnList,
  rxtoolbar, rxmemds, rxdbgrid, TAGraph, TASeries, TAStyles, TADbSource, fbmTransactionMonitor_ConnectionsUnit,
  fbcustomdataset, Menus, uib, ExtCtrls, StdCtrls, LMessages, fbmToolsUnit,
  Buttons, ComCtrls, Spin, db, SQLEngineAbstractUnit,
  fdbm_monitorabstractunit;

type

  { TfbmTransactionMonitorForm }

  TfbmTransactionMonitorForm = class(TfdbmMonitorAbstractForm)
    actRefresh: TAction;
    ActionList1: TActionList;
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    Chart1LineSeries2: TLineSeries;
    Chart1LineSeries3: TLineSeries;
    Chart1LineSeries4: TLineSeries;
    Chart1LineSeries5: TLineSeries;
    Chart1LineSeries6: TLineSeries;
    Chart1LineSeries7: TLineSeries;
    Chart1LineSeries8: TLineSeries;
    Chart2: TChart;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5 : TCheckBox;
    csNEXT_TRANS: TDbChartSource;
    csOLD_ACTIVE: TDbChartSource;
    csOLD: TDbChartSource;
    csOLD_SNAPSHOT: TDbChartSource;
    dsStatInfo: TDataSource;
    dsUsers: TDataSource;
    quStatInfo: TFBDataSet;
    Label11: TLabel;
    Panel5: TPanel;
    Panel6 : TPanel;
    quUsers: TFBDataSet;
    ImageList1: TImageList;
    CLabel: TLabel;
    PageControl1: TPageControl;
    RxDBGrid1: TRxDBGrid;
    RxDBGrid3: TRxDBGrid;
    rxStatInfo: TRxMemoryData;
    rxStatInfoPARAM: TStringField;
    rxStatInfoVALUE: TStringField;
    rxTransInfo: TRxMemoryData;
    rxTransInfoID: TLongintField;
    rxTransInfoNEXT_TRANS: TLongintField;
    rxTransInfoOLD_ACTIVE: TLongintField;
    rxTransInfoOLD_ALL: TLongintField;
    rxTransInfoOLD_SNAPSHOT: TLongintField;
    SpinEdit4: TSpinEdit;
    Splitter1 : TSplitter;
    Splitter2 : TSplitter;
    SynEdit1 : TSynEdit;
    tabConnections: TTabSheet;
    tabGraph: TTabSheet;
    tabServerInfo: TTabSheet;
    UIBDataBase1: TUIBDataBase;
    UIBServerInfo1: TUIBServerInfo;
    UIBTransaction1: TUIBTransaction;
    procedure CheckBox3Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure PageControl1Change(Sender: TObject);
    procedure SpinEdit4Change(Sender: TObject);
    procedure UIBDataBase1AfterConnect(Sender: TObject);
  private
    FConnectionsFrame:TfbmTransactionMonitor_ConnectionsFrame;
    procedure ShowUsers;
    procedure LoadDBStat;
    procedure DoCommitTransaction;
  protected
    procedure InternalSetEnvOptions; override;
    procedure InternalInitConrols; override;
    procedure Localize; override;
    procedure ConnectToDB(ASQLEngine: TSQLEngineAbstract); override;
    procedure StatTimeTick; override;
    procedure ShowStatInfo;
  public
  end;

procedure ShowTransMonitor;
implementation
uses rxstrutils, IBManMainUnit, IBManDataInspectorUnit, StrUtils,
  ibmanagertypesunit, fbmStrConstUnit, FBSQLEngineUnit;

{$R *.lfm}

var
  fbmTransactionMonitorForm: TfbmTransactionMonitorForm = nil;

procedure ShowTransMonitor;
begin
  fbManagerMainForm.RxMDIPanel1.ChildWindowsCreate(fbmTransactionMonitorForm, TfbmTransactionMonitorForm)
end;

{ TfbmTransactionMonitorForm }

procedure TfbmTransactionMonitorForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  fbmTransactionMonitorForm:=nil;
  CloseAction:=caFree;
end;

procedure TfbmTransactionMonitorForm.CheckBox3Change(Sender: TObject);
begin
  MainTimer.Enabled:=CheckBox3.Checked;
end;

procedure TfbmTransactionMonitorForm.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePage = tabConnections then
    FConnectionsFrame.UpdateList
  else
  if PageControl1.ActivePage = tabServerInfo then
    LoadDBStat;
end;

procedure TfbmTransactionMonitorForm.SpinEdit4Change(Sender: TObject);
begin
  MainTimer.Enabled:=false;
  MainTimer.Interval:=SpinEdit4.Value * 1000;
  MainTimer.Enabled:=CheckBox3.Checked;
end;

procedure TfbmTransactionMonitorForm.UIBDataBase1AfterConnect(Sender: TObject);
begin
  UIBTransaction1.StartTransaction;
end;

procedure TfbmTransactionMonitorForm.ShowUsers;
begin
//  quUsers.CloseOpen(true);
  FConnectionsFrame.UpdateList;
end;

procedure TfbmTransactionMonitorForm.LoadDBStat;

procedure ParseVersionStr(S:string;out AMj, AMi, AMr:Integer);
begin
  AMj:=0;
  AMi:=0;
  AMr:=0;
  if S = '' then Exit;
  AMj:=StrToIntDef(Copy2SymbDel(S, '.'), 0);
  if (AMj = 0) or (S = '') then Exit;
  AMi:=StrToIntDef(Copy2SymbDel(S, '.'), 0);
  if (AMi = 0) or (S = '') then Exit;
  AMr:=StrToIntDef(S, 0);
end;

var
  R: Int64;
  V1, V2, V3: Integer;
begin
  rxStatInfo.CloseOpen;
  try
    quStatInfo.Open;
    ParseVersionStr(quStatInfo.FieldByName('FB_ENGINE_VERSION').AsString, V1, V2, V3);

    rxStatInfo.AppendRecord([sServerVersion, UIBDataBase1.InfoVersion]);
    rxStatInfo.AppendRecord([sDatabaseName, quStatInfo.FieldByName('MON$DATABASE_NAME').DisplayText]);
    rxStatInfo.AppendRecord([sSQLDialect, quStatInfo.FieldByName('MON$SQL_DIALECT').DisplayText]);
    rxStatInfo.AppendRecord([sCreationDate, quStatInfo.FieldByName('MON$CREATION_DATE').DisplayText]);

    if V1>2 then
      rxStatInfo.AppendRecord([sDatabaseOwner, quStatInfo.FieldByName('MON$OWNER').DisplayText]);

    rxStatInfo.AppendRecord([sReadOnly, quStatInfo.FieldByName('MON$READ_ONLY').DisplayText]);

    rxStatInfo.AppendRecord([sPageSize, quStatInfo.FieldByName('MON$PAGE_SIZE').DisplayText]);
    rxStatInfo.AppendRecord([sPages, quStatInfo.FieldByName('MON$PAGES').DisplayText]);


    R:=quStatInfo.FieldByName('MON$PAGES').AsLongWord * quStatInfo.FieldByName('MON$PAGE_SIZE').AsLongWord;
    rxStatInfo.AppendRecord([sStatsDBSize, RxPrettySizeName(R)]); //Объём, который занимает на диске база данных с заданным OID

    quStatInfo.Close;
  finally
  end;
  rxStatInfo.First;
end;

procedure TfbmTransactionMonitorForm.DoCommitTransaction;
begin
  if CheckBox4.Checked then
  begin
    FConnectionsFrame.CloseList;
    UIBTransaction1.Commit;
    UIBTransaction1.StartTransaction;
  end;
end;

procedure TfbmTransactionMonitorForm.InternalSetEnvOptions;
begin
  inherited InternalSetEnvOptions;
  FConnectionsFrame.InternalSetEnvOptions;
end;

procedure TfbmTransactionMonitorForm.InternalInitConrols;
begin
  inherited InternalInitConrols;

  FConnectionsFrame:=TfbmTransactionMonitor_ConnectionsFrame.Create(Self);
  FConnectionsFrame.Parent:=tabConnections;
  FConnectionsFrame.Align:=alClient;
  FConnectionsFrame.SetDataBase(UIBDataBase1);
  PageControl1.ActivePageIndex:=0;
  DoFillDatabaseList(TSQLEngineFireBird);

  {  BarChart1.Bars.Clear;
  BOldestActive:=BarChart1.AddBar(sFBTranOldestActive, 0, clRed);
  BOldestTras:=BarChart1.AddBar(sFBTranOldestTran, 0, clMaroon);
  BOldestSnapshot:=BarChart1.AddBar(sFBTranOldestSnaps, 0, clBlack);
  BNextTran:=BarChart1.AddBar(sFBTranNextTrans, 0, clBlue);}

  FConnectionsFrame.quConnections.DataBase:=UIBDataBase1;
  FConnectionsFrame.quConnections.Transaction:=UIBTransaction1;

  SpinEdit4Change(nil);
end;

procedure TfbmTransactionMonitorForm.Localize;
begin
  inherited Localize;
  FConnectionsFrame.Localize;


  Label1.Caption:=sDatabase;
  tabGraph.Caption:=sGeneral;
  tabConnections.Caption:=sConnections;
  tabServerInfo.Caption:=sStatistic;

{  Label2.Caption:=sPageSize;
  Label3.Caption:=sSQLDialect;
  Label4.Caption:=sSweepInterval;
  Label5.Caption:=sODSVersion;
  Label6.Caption:=sSweepInterval;
  Label7.Caption:=sKB;
  GroupBox1.Caption:=sBuffers;
  CheckBox1.Caption:=sForcedWrite;
  CheckBox2.Caption:=sReadOnly;}
  Label11.Caption:=sRefreshInterval;
  CheckBox3.Caption:=sRefreshDataHint;
  CheckBox4.Caption:=sCommitTransactionOnRefresh;

  RxDBGrid1.ColumnByFieldName('MON$ATTACHMENT_ID').Title.Caption:=sAttachmentID;
  RxDBGrid1.ColumnByFieldName('MON$ATTACHMENT_NAME').Title.Caption:=sAttachmentDB;
  RxDBGrid1.ColumnByFieldName('MON$TIMESTAMP').Title.Caption:=sStart1;
  RxDBGrid1.ColumnByFieldName('MON$USER').Title.Caption:=sUserName1;
  RxDBGrid1.ColumnByFieldName('MON$ROLE').Title.Caption:=sUserRole;
  RxDBGrid1.ColumnByFieldName('MON$REMOTE_ADDRESS').Title.Caption:=sRemoteAddress;
  RxDBGrid1.ColumnByFieldName('MON$REMOTE_PROTOCOL').Title.Caption:=sRemoteProtocol;
  RxDBGrid1.ColumnByFieldName('MON$REMOTE_PROCESS').Title.Caption:=sRemoteProcess;

  Chart1LineSeries1.Title:=sNext;
  Chart1LineSeries2.Title:=sOldActive;
  Chart1LineSeries3.Title:=sOldest;
  Chart1LineSeries4.Title:=sOldSnapshot;

  Chart1LineSeries5.Title:=sNext;
  Chart1LineSeries6.Title:=sOldActive;
  Chart1LineSeries7.Title:=sOldest;
  Chart1LineSeries8.Title:=sOldSnapshot;

  RxDBGrid3.ColumnByFieldName('PARAM').Title.Caption:=sParamName;
  RxDBGrid3.ColumnByFieldName('VALUE').Title.Caption:=sParamValue;

  actRefresh.Caption:=sRefresh;
  actRefresh.Hint:=sRefreshHint;
end;

procedure TfbmTransactionMonitorForm.ConnectToDB(ASQLEngine: TSQLEngineAbstract
  );
var
  S: String;
begin
  inherited ConnectToDB(ASQLEngine);
  UIBDataBase1.Connected:=false;
  rxTransInfo.CloseOpen;
  try
    S:=SQLEngine.DataBaseName;
    if SQLEngine.ServerName<>'' then
      S:=SQLEngine.ServerName+':'+S;
//    UIBDataBase1.LibraryName:=TSQLEngineFireBird(SQLEngine).LibraryName;
    UIBDataBase1.UserName:=SQLEngine.UserName;
    UIBDataBase1.PassWord:=SQLEngine.Password;
    UIBDataBase1.DatabaseName:=S;
    UIBDataBase1.Connected:=true;

//    UIBServerInfo1.LibraryName:=TSQLEngineFireBird(SQLEngine).LibraryName;
//    ShowUsers;
//    ShowStatInfo;
    StatTimeTick;
  finally
  end;
end;

procedure TfbmTransactionMonitorForm.StatTimeTick;
begin
  inherited StatTimeTick;
  if not UIBDataBase1.Connected then exit;

  if PageControl1.ActivePage = tabGraph then
    DoCommitTransaction
  else
  if PageControl1.ActivePage = tabConnections then
  begin
    if not FConnectionsFrame.PopupMenuActive then
    begin
      DoCommitTransaction;
      FConnectionsFrame.UpdateList;
    end;
  end
  else
    DoCommitTransaction;
  ;

{
//  ShowUsers;

  if rxTransInfo.RecordCount > 100 then
  begin
    rxTransInfo.First;
    rxTransInfo.Delete;
  end;
  rxTransInfo.Append;
  rxTransInfoID.AsInteger:=TimeID;
(*  rxTransInfoNEXT_TRANS.AsInteger:=UIBDataBase1.InfoNextTransaction;
  rxTransInfoOLD_ACTIVE.AsInteger:=UIBDataBase1.InfoOldestActive;
  rxTransInfoOLD_SNAPSHOT.AsInteger:=UIBDataBase1.InfoOldestSnapshot;
  rxTransInfoOLD_ALL.AsInteger:=UIBDataBase1.InfoOldestTransaction;*)
  rxTransInfo.Post;
}
end;

procedure TfbmTransactionMonitorForm.ShowStatInfo;
begin
{  if UIBDataBase1.Connected then
  begin
    Edit1.Text:=IntToStr(UIBDataBase1.InfoPageSize);
    Edit2.Text:=IntToStr(UIBDataBase1.InfoDbSqlDialect);
    Edit4.Text:=Format('%d.%d', [UIBDataBase1.InfoOdsVersion, UIBDataBase1.InfoOdsMinorVersion]);
    Edit3.Text:=IntToStr(UIBDataBase1.InfoSweepInterval);

    CheckBox1.Checked:=UIBDataBase1.InfoForcedWrites;
    CheckBox2.Checked:=UIBDataBase1.InfoDbReadOnly;

    SpinEdit2.Value:=UIBDataBase1.InfoDbSizeInPages;


    if Assigned(SQLEngine) then
    begin
      UIBServerInfo1.Host:=SQLEngine.ServerName;
      if SQLEngine.ServerName <> '' then
        UIBServerInfo1.Protocol:=proTCPIP
      else
        UIBServerInfo1.Protocol:=proLocalHost;
      UIBServerInfo1.UserName:=SQLEngine.UserName;
      UIBServerInfo1.PassWord:=SQLEngine.PassWord;
      UIBServerInfo1.GetServerInfo;
    end;
  end
  else
  begin
    Edit1.Text:='';
    Edit2.Text:='';
    Edit3.Text:='';
    Edit4.Text:='';
    CheckBox1.Checked:=false;
    CheckBox2.Checked:=false;
  end;    }
end;

end.


