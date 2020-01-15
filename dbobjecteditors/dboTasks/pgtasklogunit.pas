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

unit pgTaskLogUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, rxdbgrid, rxtooledit, RxDBGridExportSpreadSheet,
  RxDBGridPrintGrid, ZDataset, ZConnection, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ActnList, Menus, db, fdmAbstractEditorUnit,
  pg_tasks, SQLEngineAbstractUnit;

type

  { TpgTaskLogPage }

  TpgTaskLogPage = class(TEditorPage)
    actRefreshData: TAction;
    ActionList1: TActionList;
    BitBtn1: TBitBtn;
    dsLogs: TDataSource;
    Label1: TLabel;
    Label2: TLabel;
    MenuItem1: TMenuItem;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    quLogsjlgduration: TStringField;
    quLogsjlgid: TLongintField;
    quLogsjlgjobid: TLongintField;
    quLogsjlgstart: TDateTimeField;
    quLogsjlgstatus: TStringField;
    RxDateEdit1: TRxDateEdit;
    RxDateEdit2: TRxDateEdit;
    RxDBGrid1: TRxDBGrid;
    quLogs: TZReadOnlyQuery;
    RxDBGridExportSpreadSheet1: TRxDBGridExportSpreadSheet;
    RxDBGridPrint1: TRxDBGridPrint;
    ZConnection1: TZConnection;
    procedure actRefreshDataExecute(Sender: TObject);
    procedure quLogsBeforeOpen(DataSet: TDataSet);
    procedure quLogsjlgstatusGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure RxDBGrid1GetCellProps(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor);
  private
  public
    function PageName:string;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
  end;

implementation

uses fbmStrConstUnit, PostgreSQLEngineUnit;

{$R *.lfm}

{ TpgTaskLogPage }

procedure TpgTaskLogPage.quLogsBeforeOpen(DataSet: TDataSet);
begin
  quLogs.ParamByName('jlgjobid').AsInteger:=TPGTask(DBObject).TaskID;
  quLogs.ParamByName('date_start').AsDateTime:=RxDateEdit1.Date;
  quLogs.ParamByName('date_end').AsDateTime:=RxDateEdit2.Date;
end;

procedure TpgTaskLogPage.quLogsjlgstatusGetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  aText:=quLogsjlgstatus.AsString;
  if aText<>'' then
    case aText[1] of
      'r':aText:=aText + sRuning;
      's':aText:=aText + sSuccessfullyFinished;
      'f':aText:=aText + sFailed;
      'i':aText:=aText + sNoStepsToExecute;
      'd':aText:=aText + sAborted;
    end;
end;

procedure TpgTaskLogPage.RxDBGrid1GetCellProps(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor);
var
  S: String;
begin
  S:=quLogsjlgstatus.AsString;
  if S<>'' then
    case S[1] of
      'r':Background:=clMoneyGreen;
//      's':aText:=aText + sSuccessfullyFinished;
      'f':Background:=clCream;
      'i':Background:=clSilver;
      'd':Background:=clRed;
    end;
end;

procedure TpgTaskLogPage.actRefreshDataExecute(Sender: TObject);
begin
  quLogs.Close;
  quLogs.Open;
end;

function TpgTaskLogPage.PageName: string;
begin
  Result:=sLogs;
end;

function TpgTaskLogPage.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  case PageAction of
    epaRefresh:actRefreshData.Execute
  else
    Result:=false
  end;
end;

function TpgTaskLogPage.ActionEnabled(PageAction: TEditorPageAction): boolean;
begin
  Result:=PageAction in [epaRefresh];
end;

procedure TpgTaskLogPage.Localize;
begin
  inherited Localize;
  Label1.Caption:=sFromDate;
  Label2.Caption:=sToDate;
  actRefreshData.Caption:=sRefresh;
  actRefreshData.Hint:=sRefreshDataHint;

  RxDBGrid1.ColumnByFieldName('jlgid').Title.Caption:=sID;
  RxDBGrid1.ColumnByFieldName('jlgjobid').Title.Caption:=sJobID;
  RxDBGrid1.ColumnByFieldName('jlgstart').Title.Caption:=sStart;
  RxDBGrid1.ColumnByFieldName('jlgduration').Title.Caption:=sDuration;
  RxDBGrid1.ColumnByFieldName('jlgstatus').Title.Caption:=sStatus;
end;

constructor TpgTaskLogPage.CreatePage(TheOwner: TComponent; ADBObject: TDBObject
  );
begin
  inherited CreatePage(TheOwner, ADBObject);
  ZConnection1.Protocol:='postgresql'; //pgZeosServerVersionProtoStr[FServerVersion];
  RxDateEdit1.Date:=IncMonth(Now, -1);
  RxDateEdit2.Date:=Now + 1;
  quLogs.Connection:=TSQLEnginePostgre(DBObject.OwnerDB).PGSysDB;
  quLogs.BeforeOpen:=@quLogsBeforeOpen;
  quLogs.Open;
end;

end.

