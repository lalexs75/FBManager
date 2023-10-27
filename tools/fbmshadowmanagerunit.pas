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

unit fbmshadowmanagerunit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, uib,
  FBCustomDataSet, DB, ExtCtrls, StdCtrls, rxdbgrid, Buttons, ibmanagertypesunit,
  fbmToolsUnit, rxtoolbar, ActnList, Menus, LCLType, LR_DBSet,
  FBSQLEngineUnit;

type

  { TfbmShadowManagerForm }

  TfbmShadowManagerForm = class(TForm)
    frShadowList: TfrDBDataSet;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    shdPrintList: TAction;
    UIBTransaction1: TUIBTransaction;
    MainMenu1: TMainMenu;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    shdRefresh: TAction;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    shdDrop: TAction;
    shdAdd: TAction;
    ActionList1: TActionList;
    ComboBox1: TComboBox;
    Datasource1: TDatasource;
    PopupMenu1: TPopupMenu;
    quShadowList: TFBDataSet;
    Label1: TLabel;
    Panel1: TPanel;
    RxDBGrid1: TRxDBGrid;
    ToolPanel1: TToolPanel;
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure quShadowListAfterOpen(DataSet: TDataSet);
    procedure shdAddExecute(Sender: TObject);
    procedure shdDropExecute(Sender: TObject);
    procedure shdPrintListExecute(Sender: TObject);
    procedure shdRefreshExecute(Sender: TObject);
  private
    FCurEngine:TSQLEngineFireBird;
  public

  end;


procedure ShowShadowManagerForm;
implementation
uses IBManDataInspectorUnit, IBManMainUnit,
  fbmStrConstUnit;

{$R *.lfm}

var
  fbmShadowManagerForm: TfbmShadowManagerForm;

procedure ShowShadowManagerForm;
begin
  if not Assigned(fbmShadowManagerForm) then
    fbmShadowManagerForm:=TfbmShadowManagerForm.Create(Application);
  fbmShadowManagerForm.Show;
end;

{ TfbmShadowManagerForm }

procedure TfbmShadowManagerForm.quShadowListAfterOpen(DataSet: TDataSet);
begin
  shdAdd.Enabled:=quShadowList.Active;
  shdDrop.Enabled:=quShadowList.Active and (quShadowList.RecordCount>0);
  shdRefresh.Enabled:=quShadowList.Active;
end;

procedure TfbmShadowManagerForm.shdAddExecute(Sender: TObject);
begin
  { TODO 5 -oalexs -cинструменты : Необходимо реализовать созданиефайла тени для птицы }
{  if Assigned(FCurRec) and ShowQuestion(sCreateShadow) then
  begin
    S:='';
    fbmShadowManagerEditForm:=TfbmShadowManagerEditForm.Create(Application);
    if fbmShadowManagerEditForm.ShowModal = mrOk then
    begin
      S:=Format(ssqlCreateShadow, [fbmShadowManagerEditForm.SpinEdit1.Value]);
      if fbmShadowManagerEditForm.RadioButton1.Checked then
        S:=S+' MANUAL'
      else
      begin
        S:=S+' AUTO';
        if fbmShadowManagerEditForm.CheckBox1.Checked then
          S:=S+' CONDITIONAL';
      end;
      S:=S+' '''+fbmShadowManagerEditForm.FileNameEdit1.FileName+'''';
    end;
    fbmShadowManagerEditForm.Free;
    if S<>'' then
      FCurRec.ExecSQLScript(S);
    quShadowList.CloseOpen(false);
  end;}
end;

procedure TfbmShadowManagerForm.shdDropExecute(Sender: TObject);
begin
  { TODO 5 -oalexs -cинструменты : Для птицы необходимо реализовать удаление файла тени }
{  if Assigned(FCurRec) and ShowQuestion(sDropShadow) then
  begin
    FCurRec.ExecSQLScript(Format(ssqlDropShadow, [quShadowList.FieldByName('rdb$shadow_number').AsInteger]));
    quShadowList.CloseOpen(false);
  end;}
end;

procedure TfbmShadowManagerForm.shdPrintListExecute(Sender: TObject);
begin
  fbManagerMainForm.LazReportPrint('shadow_list');
end;

procedure TfbmShadowManagerForm.shdRefreshExecute(Sender: TObject);
begin
  quShadowList.CloseOpen(false);
end;

procedure TfbmShadowManagerForm.FormCreate(Sender: TObject);
begin
  ComboBox1.ItemIndex:=fbManDataInpectorForm.DBList.FillDataBaseList(ComboBox1.Items, TSQLEngineFireBird);
  if ComboBox1.ItemIndex>-1 then
    ComboBox1Change(nil);
end;

procedure TfbmShadowManagerForm.ComboBox1Change(Sender: TObject);
begin
  FCurEngine:=ComboBox1.Items.Objects[ComboBox1.ItemIndex] as TSQLEngineFireBird;
  quShadowList.Close;
  if UIBTransaction1.InTransaction then
    UIBTransaction1.Commit;
  UIBTransaction1.DataBase:=nil;

  if Assigned(FCurEngine) and FCurEngine.Connected then
  begin
    UIBTransaction1.DataBase:=FCurEngine.FBDatabase;
    quShadowList.DataBase:=FCurEngine.FBDatabase;
    quShadowList.Transaction:=UIBTransaction1;
    try
      quShadowList.Open;
    except
      on E:Exception do
        ErrorBoxExcpt(E);
    end;
  end;
end;

procedure TfbmShadowManagerForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
  fbmShadowManagerForm:=nil;
end;

end.

