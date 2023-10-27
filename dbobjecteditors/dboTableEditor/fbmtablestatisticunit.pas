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

unit fbmTableStatisticUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ActnList, DB,
  rxdbgrid, RxDBGridExportPdf, RxDBGridExportSpreadSheet, RxDBGridPrintGrid,
  fdmAbstractEditorUnit, SQLEngineAbstractUnit, IniFiles;

type

  { TfbmTableStatisticFrame }

  TfbmTableStatisticFrame = class(TEditorPage)
    actPrint: TAction;
    actRefresh: TAction;
    ActionList1: TActionList;
    dsStat: TDataSource;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    PopupMenu1: TPopupMenu;
    RxDBGrid1: TRxDBGrid;
    RxDBGridExportPDF1: TRxDBGridExportPDF;
    RxDBGridExportSpreadSheet1: TRxDBGridExportSpreadSheet;
    RxDBGridPrint1: TRxDBGridPrint;
    procedure actPrintExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
  private
    procedure Print;
    procedure RefreshData;
  public
    function PageName:string;override;
    procedure Activate;override;
    function DoMetod(PageAction: TEditorPageAction): boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    procedure UpdateEnvOptions; override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    procedure SaveState(const SectionName:string; const Ini:TIniFile);override;
    procedure RestoreState(const SectionName:string; const Ini:TIniFile);override;
    procedure Localize;override;
  end;

implementation
uses fbmToolsUnit, fbmStrConstUnit;

{$R *.lfm}

{ TfbmTableStatisticFrame }

procedure TfbmTableStatisticFrame.actRefreshExecute(Sender: TObject);
begin
  RefreshData;
end;

procedure TfbmTableStatisticFrame.actPrintExecute(Sender: TObject);
begin
  Print;
end;

procedure TfbmTableStatisticFrame.Print;
begin
  RxDBGridPrint1.Execute;
end;

procedure TfbmTableStatisticFrame.RefreshData;
begin
  TDBTableObject(DBObject).Statistic.Refresh;
end;

function TfbmTableStatisticFrame.PageName: string;
begin
  Result:=sStatistic;
end;

procedure TfbmTableStatisticFrame.Activate;
begin
  inherited Activate;
  dsStat.DataSet:=TDBTableObject(DBObject).Statistic.StatData;
  if dsStat.DataSet.RecordCount = 0 then
    TDBTableObject(DBObject).Statistic.Refresh;
end;

function TfbmTableStatisticFrame.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  case PageAction of
    epaPrint:Print;
    epaRefresh:RefreshData;
  else
    Result:=false;
  end;
end;

function TfbmTableStatisticFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaPrint, epaRefresh];
end;

procedure TfbmTableStatisticFrame.UpdateEnvOptions;
begin
  inherited UpdateEnvOptions;
  SetRxDBGridOptions(RxDBGrid1);
end;

constructor TfbmTableStatisticFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
end;

procedure TfbmTableStatisticFrame.SaveState(const SectionName: string;
  const Ini: TIniFile);
begin
  inherited SaveState(SectionName, Ini);
end;

procedure TfbmTableStatisticFrame.RestoreState(const SectionName: string;
  const Ini: TIniFile);
begin
  inherited RestoreState(SectionName, Ini);
end;

procedure TfbmTableStatisticFrame.Localize;
begin
  inherited Localize;
  actRefresh.Caption:=sRefresh;
  actPrint.Caption:=sPrint;

  RxDBGrid1.ColumnByFieldName('Caption').Title.Caption:=sCaption;
  RxDBGrid1.ColumnByFieldName('Value').Title.Caption:=sValue;
end;

end.

