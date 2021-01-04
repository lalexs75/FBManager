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

unit fbmTransactionMonitorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ActnList,
  rxtoolbar, rxmemds, rxdbgrid, TAGraph, TASeries, TAStyles, TADbSource,
  fbcustomdataset, Menus, uib, ExtCtrls, StdCtrls, LMessages, fbmToolsUnit,
  EditBtn, Buttons, ComCtrls, Spin, db, SQLEngineAbstractUnit,
  fdbm_monitorabstractunit;

type

  { TfbmTransactionMonitorForm }

  TfbmTransactionMonitorForm = class(TfdbmMonitorAbstractForm)
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
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    ComboBox2: TComboBox;
    csNEXT_TRANS: TDbChartSource;
    csOLD_ACTIVE: TDbChartSource;
    csOLD: TDbChartSource;
    csOLD_SNAPSHOT: TDbChartSource;
    dsUsers: TDataSource;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label11: TLabel;
    Memo1: TMemo;
    Panel5: TPanel;
    quUsers: TFBDataSet;
    GroupBox1: TGroupBox;
    ImageList1: TImageList;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PageControl1: TPageControl;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    RxDBGrid1: TRxDBGrid;
    rxTransInfo: TRxMemoryData;
    rxTransInfoID: TLongintField;
    rxTransInfoNEXT_TRANS: TLongintField;
    rxTransInfoOLD_ACTIVE: TLongintField;
    rxTransInfoOLD_ALL: TLongintField;
    rxTransInfoOLD_SNAPSHOT: TLongintField;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    UIBDataBase1: TUIBDataBase;
    UIBServerInfo1: TUIBServerInfo;
    UIBTransaction1: TUIBTransaction;
    procedure CheckBox3Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure SpinEdit4Change(Sender: TObject);
    procedure UIBDataBase1AfterConnect(Sender: TObject);
    procedure UIBServerInfo1InfoDbName(Sender: TObject; Value: string);
  private
    procedure ShowUsers;
  protected
    procedure Localize; override;
    procedure ConnectToDB(ASQLEngine: TSQLEngineAbstract); override;
    procedure StatTimeTick; override;
    procedure ShowStatInfo;
  public
  end;

procedure ShowTransMonitor;
implementation
uses uibase, IBManMainUnit, IBManDataInspectorUnit, ibmanagertypesunit, fbmStrConstUnit,
  FBSQLEngineUnit;

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

procedure TfbmTransactionMonitorForm.FormCreate(Sender: TObject);
begin
  DoFillDatabaseList(TSQLEngineFireBird);

  {  BarChart1.Bars.Clear;
  BOldestActive:=BarChart1.AddBar(sFBTranOldestActive, 0, clRed);
  BOldestTras:=BarChart1.AddBar(sFBTranOldestTran, 0, clMaroon);
  BOldestSnapshot:=BarChart1.AddBar(sFBTranOldestSnaps, 0, clBlack);
  BNextTran:=BarChart1.AddBar(sFBTranNextTrans, 0, clBlue);}
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

procedure TfbmTransactionMonitorForm.UIBServerInfo1InfoDbName(Sender: TObject;
  Value: string);
begin
  Memo1.Lines.Add(Value);
end;

procedure TfbmTransactionMonitorForm.ShowUsers;
begin
  quUsers.CloseOpen(true);
end;

procedure TfbmTransactionMonitorForm.Localize;
begin
  inherited Localize;

  Label1.Caption:=sDatabase;
  TabSheet2.Caption:=sGeneral;
  Label9.Caption:=sGeneral;
  Label10.Caption:=sActiveUsers;

  Label2.Caption:=sPageSize1;
  Label3.Caption:=sSQLDialect;
  Label4.Caption:=sSweepInterval;
  Label5.Caption:=sODSVersion;
  Label6.Caption:=sSweepInterval;
  Label7.Caption:=sKB;
  GroupBox1.Caption:=sBuffers;
  CheckBox1.Caption:=sForcedWrite;
  CheckBox2.Caption:=sReadOnly;
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
    UIBDataBase1.LibraryName:=TSQLEngineFireBird(SQLEngine).LibraryName;
    UIBDataBase1.UserName:=SQLEngine.UserName;
    UIBDataBase1.PassWord:=SQLEngine.Password;
    UIBDataBase1.DatabaseName:=S;
    UIBDataBase1.Connected:=true;

    UIBServerInfo1.LibraryName:=TSQLEngineFireBird(SQLEngine).LibraryName;
    ShowUsers;
    ShowStatInfo;
  finally
  end;
end;

procedure TfbmTransactionMonitorForm.StatTimeTick;
begin
  inherited StatTimeTick;
  if not UIBDataBase1.Connected then exit;

  if CheckBox4.Checked then
  begin
    UIBTransaction1.Commit;
    UIBTransaction1.StartTransaction;
  end;
  ShowUsers;

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
end;

procedure TfbmTransactionMonitorForm.ShowStatInfo;
begin
  Memo1.Lines.Clear;
  if UIBDataBase1.Connected then
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
  end;
end;

end.

