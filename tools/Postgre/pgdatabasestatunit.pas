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

unit pgDataBaseStatUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ActnList,
  Menus, DB, rxdbgrid, rxtoolbar, ZMacroQuery, ZConnection,
  PostgreSQLEngineUnit, fbmAbstractSQLEngineToolsUnit;

type

  { TpgDataBaseStatForm }

  TpgDataBaseStatForm = class(TForm)
    MenuItem1: TMenuItem;
    PopupMenu1: TPopupMenu;
    TabControl1: TTabControl;
    ToolPanel1: TToolPanel;
    tsRefresh: TAction;
    ActionList1: TActionList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure tsRefreshExecute(Sender: TObject);
  private
    FCurPage:TAbstractSQLEngineTools;
    FPgList:TFPList;
    procedure Localize;
    procedure AddToolsFrame(ATools:TAbstractSQLEngineTools);
    procedure SetCurPageIndex(AIndex:Integer);
  public
    procedure ConnectToDB(ASQLEngine: TSQLEnginePostgre);
  end;

procedure ShowDataBaseStatForm(ASQLEngine: TSQLEnginePostgre);
implementation
uses IBManMainUnit, sqlObjects, SQLEngineCommonTypesUnit, fbmStrConstUnit,
  pgDBObjectsSizeUnit, pgToolsFindDuplicateUnit,
  pgObjectAnalysisAndWarningsUnit;

var
  pgDataBaseStatForm: TpgDataBaseStatForm = nil;

procedure ShowDataBaseStatForm(ASQLEngine: TSQLEnginePostgre);
begin
  fbManagerMainForm.RxMDIPanel1.ChildWindowsCreate(pgDataBaseStatForm, TpgDataBaseStatForm);
  if Assigned(pgDataBaseStatForm) then
    pgDataBaseStatForm.ConnectToDB(ASQLEngine);
end;

{$R *.lfm}

{ TpgDataBaseStatForm }

procedure TpgDataBaseStatForm.FormCreate(Sender: TObject);
var
  R: TRxColumn;
begin
  FPgList:=TFPList.Create;
  TabControl1.Tabs.Clear;

  AddToolsFrame(TpgDBObjectsSizeTools.Create(Self));
  AddToolsFrame(TpgToolsFindDuplicateFrame.Create(Self));
  AddToolsFrame(TpgObjectAnalysisAndWarningsTools.Create(Self));

  TabControl1.TabIndex:=0;
  SetCurPageIndex(0);
  Localize;
end;

procedure TpgDataBaseStatForm.FormDestroy(Sender: TObject);
begin
  pgDataBaseStatForm:= nil;
  FreeAndNil(FPgList);
end;

procedure TpgDataBaseStatForm.TabControl1Change(Sender: TObject);
var
  W, H, L, T: Integer;
begin
  SetCurPageIndex(TabControl1.TabIndex);
  FCurPage.RefreshPage;
end;

procedure TpgDataBaseStatForm.tsRefreshExecute(Sender: TObject);
begin
  if Assigned(FCurPage) then
    FCurPage.RefreshPage;
end;

procedure TpgDataBaseStatForm.Localize;
var
  i: Integer;
begin
  Caption:=sDataBaseStatistic;
  tsRefresh.Caption:=sRefresh;

  for i:=0 to FPgList.Count-1 do
    TAbstractSQLEngineTools(FPgList[i]).Localize;
end;

procedure TpgDataBaseStatForm.AddToolsFrame(ATools: TAbstractSQLEngineTools);
begin
  TabControl1.Tabs.Add(ATools.PageName);
  FPgList.Add(ATools);
  ATools.Parent:=TabControl1;
  ATools.Align:=alClient;
  ATools.Hide;
end;

procedure TpgDataBaseStatForm.SetCurPageIndex(AIndex: Integer);
begin
  if Assigned(FCurPage) then
    FCurPage.Hide;

  FCurPage:=TAbstractSQLEngineTools(FPgList[AIndex]);
  FCurPage.Show;
  FCurPage.BringToFront;
end;

procedure TpgDataBaseStatForm.ConnectToDB(ASQLEngine: TSQLEnginePostgre);
var
  i: Integer;
begin
  for i:=0 to FPgList.Count-1 do
    TAbstractSQLEngineTools(FPgList[i]).SQLEngine:=ASQLEngine;

  tsRefresh.Execute;
end;

end.

