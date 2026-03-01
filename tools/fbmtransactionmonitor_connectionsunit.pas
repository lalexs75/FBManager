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

unit fbmTransactionMonitor_ConnectionsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, ActnList, ExtCtrls, StdCtrls, DBCtrls, uib, uiblib,
  DBGrids, Menus, fbcustomdataset, fdbm_SynEditorUnit, rxtoolbar, RxDBGrid, DB;

type

  { TfbmTransactionMonitor_ConnectionsFrame }

  TfbmTransactionMonitor_ConnectionsFrame = class(TFrame)
    CheckBox1: TCheckBox;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    PopupMenu1: TPopupMenu;
    quConnectionsATTACHMENT_CLIENT_VERSION: TFBAnsiField;
    quConnectionsATTACHMENT_ID: TFBLargeintField;
    quConnectionsATTACHMENT_NAME: TFBAnsiField;
    quConnectionsATTACHMENT_REMOTE_ADDRESS: TFBAnsiField;
    quConnectionsATTACHMENT_REMOTE_HOST: TFBAnsiField;
    quConnectionsATTACHMENT_REMOTE_OS_USER: TFBAnsiField;
    quConnectionsATTACHMENT_REMOTE_PID: TLongintField;
    quConnectionsATTACHMENT_REMOTE_PROCESS: TFBAnsiField;
    quConnectionsATTACHMENT_REMOTE_PROTOCOL: TFBAnsiField;
    quConnectionsATTACHMENT_REMOTE_VERSION: TFBAnsiField;
    quConnectionsATTACHMENT_ROLE: TFBAnsiField;
    quConnectionsATTACHMENT_SERVER_PID: TLongintField;
    quConnectionsATTACHMENT_STATE: TSmallintField;
    quConnectionsATTACHMENT_STAT_ID: TLongintField;
    quConnectionsATTACHMENT_SYSTEM_FLAG: TSmallintField;
    quConnectionsATTACHMENT_USER: TFBAnsiField;
    quConnectionsATTACH_START_TIME: TDateTimeField;
    quConnectionsCHARACTER_SET_NAME: TFBAnsiField;
    quConnectionsSTATEMENT_ID: TFBLargeintField;
    quConnectionsSTATEMENT_SQL_TEXT: TFBAnsiMemoField;
    quConnectionsSTATEMENT_START_TIME: TDateTimeField;
    RxDBGrid1: TRxDBGrid;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    Splitter1: TSplitter;
    tlsDisconect: TAction;
    tlsCancelQuery: TAction;
    ActionList1: TActionList;
    actRefresh: TAction;
    dsConnections: TDataSource;
    quConnections: TFBDataSet;
    Panel2: TPanel;
    Splitter3: TSplitter;
    ToolPanel1: TToolPanel;
    quExecutor: TUIBQuery;
    trConnections: TUIBTransaction;
    procedure actRefreshExecute(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure PopupMenu1Close(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure quConnectionsAfterOpen(DataSet: TDataSet);
    procedure quConnectionsAfterScroll(DataSet: TDataSet);
    procedure quConnectionsBeforeOpen(DataSet: TDataSet);
    procedure tlsCancelQueryExecute(Sender: TObject);
  private
    FPopupMenuActive:Boolean;
    FActiveQueryText:Tfdbm_SynEditorFrame;
    procedure UpdateCtrlState;
  public
    constructor Create(TheOwner: TComponent); override;
    procedure SetDataBase(AUIBDataBase: TUIBDataBase; AUIBTransaction: TUIBTransaction);
    procedure Localize;
    procedure InternalSetEnvOptions;
    procedure UpdateList;
    procedure CloseList;
    property PopupMenuActive:Boolean read FPopupMenuActive;
  end;

implementation
uses fbmStrConstUnit, rxlogging, fbmToolsUnit, ibmsqltextsunit;

{$R *.lfm}

{ TfbmTransactionMonitor_ConnectionsFrame }

procedure TfbmTransactionMonitor_ConnectionsFrame.quConnectionsAfterScroll(DataSet: TDataSet);
begin
  if quConnections.Active and not quConnectionsSTATEMENT_ID.IsNull then
    FActiveQueryText.EditorText:=quConnectionsSTATEMENT_SQL_TEXT.AsString
  else
    FActiveQueryText.EditorText:='';

  UpdateCtrlState;
end;

procedure TfbmTransactionMonitor_ConnectionsFrame.quConnectionsBeforeOpen(DataSet: TDataSet);
begin
  quConnections.Params.ByNameAsInteger['SYSTEM_FLAG']:=Ord(not CheckBox1.Checked);
end;

procedure TfbmTransactionMonitor_ConnectionsFrame.tlsCancelQueryExecute(Sender: TObject);
var
  S: String;
begin
  if (not quConnections.Active) or (quConnections.RecordCount = 0) then Exit;

  case (Sender as TComponent).Tag of
    1:S:=Format(sfbsqlCancelQuery, [quConnectionsSTATEMENT_ID.AsInteger]);
    2:S:=Format(sfbsqlDisconectAttch, [quConnectionsATTACHMENT_ID.AsInteger]);
  else
    Exit;
  end;

  trConnections.StartTransaction;
  try
    quExecutor.SQL.Text:=S;
    quExecutor.ExecSQL;
    trConnections.Commit;
  except
    trConnections.RollBack;
  end;
  UpdateList;
end;

procedure TfbmTransactionMonitor_ConnectionsFrame.UpdateCtrlState;
begin
  actRefresh.Enabled:=quConnections.Active;
  tlsDisconect.Enabled:=quConnections.Active and (quConnectionsATTACHMENT_SYSTEM_FLAG.AsInteger <> 1);
  tlsCancelQuery.Enabled:=quConnections.Active and (quConnectionsATTACHMENT_SYSTEM_FLAG.AsInteger <> 1)
    and (quConnectionsATTACHMENT_STATE.AsInteger > 0);
end;

procedure TfbmTransactionMonitor_ConnectionsFrame.actRefreshExecute(Sender: TObject);
begin
  PopupMenu1Close(nil);
  UpdateList;
end;

procedure TfbmTransactionMonitor_ConnectionsFrame.CheckBox1Change(Sender: TObject);
begin
  UpdateList;
end;

procedure TfbmTransactionMonitor_ConnectionsFrame.PopupMenu1Close(Sender: TObject);
begin
  FPopupMenuActive:=false
end;

procedure TfbmTransactionMonitor_ConnectionsFrame.PopupMenu1Popup(Sender: TObject);
begin
  FPopupMenuActive:=true
end;

procedure TfbmTransactionMonitor_ConnectionsFrame.quConnectionsAfterOpen(DataSet: TDataSet);
begin
  UpdateCtrlState;
end;

constructor TfbmTransactionMonitor_ConnectionsFrame.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FActiveQueryText:=Tfdbm_SynEditorFrame.Create(Self);
  FActiveQueryText.Parent:=Panel2;
  FActiveQueryText.Align:=alClient;
  FActiveQueryText.ReadOnly:=true;
  FActiveQueryText.TextEditor.Gutter.Visible:=false;

  PopupMenu1Close(nil);
end;

procedure TfbmTransactionMonitor_ConnectionsFrame.SetDataBase(AUIBDataBase: TUIBDataBase; AUIBTransaction: TUIBTransaction);
begin
  trConnections.DataBase:=AUIBDataBase;
  quConnections.DataBase:=AUIBDataBase;
  quConnections.Transaction:=AUIBTransaction;
//  quConnections.Transaction:=trConnections;
end;

procedure TfbmTransactionMonitor_ConnectionsFrame.Localize;
var
  CR: TRxColumn;
begin
  actRefresh.Caption:=sRefresh;
  actRefresh.Hint:=sRefreshDataHint;

  tlsDisconect.Caption:=sDisconectConnection;
  tlsDisconect.Hint:=sDisconectConnectionHint;

  tlsCancelQuery.Caption:=sCancelQuery;
  tlsCancelQuery.Hint:=sCancelQueryHint;
  CheckBox1.Caption:=sShowSystemProcess;

  RxDBGrid1.ColumnByFieldName('ATTACHMENT_ID').Title.Caption:=sAttachmentID;
//  RxDBGrid1.ColumnByFieldName('ATTACHMENT_SERVER_PID').Title.Caption:=sDatabaseID;

  CR:=RxDBGrid1.ColumnByFieldName('ATTACHMENT_STATE');
  CR.Title.Caption:=sState;
  TRxColumn(CR).PickList.Clear;
  TRxColumn(CR).PickList.Add(sIdle);
  TRxColumn(CR).PickList.Add(sActive);
//  TRxColumn(CR).PickList.Add(sIdle);

  RxDBGrid1.ColumnByFieldName('ATTACHMENT_NAME').Title.Caption:=sDatabase;
  RxDBGrid1.ColumnByFieldName('ATTACHMENT_USER').Title.Caption:=sUserName;
  RxDBGrid1.ColumnByFieldName('ATTACHMENT_ROLE').Title.Caption:=sRole;
  RxDBGrid1.ColumnByFieldName('ATTACHMENT_REMOTE_PROTOCOL').Title.Caption:=sProtocol;
  RxDBGrid1.ColumnByFieldName('ATTACHMENT_REMOTE_ADDRESS').Title.Caption:=sRemoteAddress;
  RxDBGrid1.ColumnByFieldName('ATTACHMENT_REMOTE_PID').Title.Caption:=sRemotePID;
  RxDBGrid1.ColumnByFieldName('ATTACH_START_TIME').Title.Caption:=sBackendStart;
  RxDBGrid1.ColumnByFieldName('ATTACHMENT_REMOTE_PROCESS').Title.Caption:=sApplicationName;
//  RxDBGrid1.ColumnByFieldName('ATTACHMENT_STAT_ID,
  RxDBGrid1.ColumnByFieldName('ATTACHMENT_CLIENT_VERSION').Title.Caption:=sClientLib;
//  RxDBGrid1.ColumnByFieldName('ATTACHMENT_REMOTE_VERSION').Title.Caption:=sClientLib;
  RxDBGrid1.ColumnByFieldName('ATTACHMENT_REMOTE_HOST').Title.Caption:=sClientHostname;
//  RxDBGrid1.ColumnByFieldName('ATTACHMENT_REMOTE_OS_USER,
//  RxDBGrid1.ColumnByFieldName('ATTACHMENT_SYSTEM_FLAG
  RxDBGrid1.ColumnByFieldName('CHARACTER_SET_NAME').Title.Caption:=sCharSet;
//  RxDBGrid1.ColumnByFieldName('STATEMENT_ID,}
  RxDBGrid1.ColumnByFieldName('STATEMENT_START_TIME').Title.Caption:=sQueryStart;
end;

procedure TfbmTransactionMonitor_ConnectionsFrame.InternalSetEnvOptions;
begin
  FActiveQueryText.ChangeVisualParams;
  SetRxDBGridOptions(RxDBGrid1);
end;

procedure TfbmTransactionMonitor_ConnectionsFrame.UpdateList;
begin
  if FPopupMenuActive then Exit;
  if not trConnections.InTransaction then
    trConnections.StartTransaction;
  quConnections.Close;
  quConnections.Open;
end;

procedure TfbmTransactionMonitor_ConnectionsFrame.CloseList;
begin
  quConnections.Close;
end;

end.

