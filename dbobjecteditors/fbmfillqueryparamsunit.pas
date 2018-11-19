{ Free DB Manager

  Copyright (C) 2005-2018 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fbmfillqueryparamsunit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ActnList,
  rxtoolbar, ComCtrls, ExtCtrls, ButtonPanel, Buttons,
  ibmanagertypesunit, SQLEngineAbstractUnit, fbmSqlParserUnit,
  fbmSQLParamValueEditorUnit;

type

  { TfbmFillQueryParamsForm }

  TfbmFillQueryParamsForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    OpenDialog1: TOpenDialog;
    prmApply: TAction;
    prmLoad: TAction;
    prmSave: TAction;
    ActionList1: TActionList;
    PageControl1: TPageControl;
    SaveDialog1: TSaveDialog;
    ScrollBox1: TScrollBox;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ToolPanel1: TToolPanel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure prmLoadExecute(Sender: TObject);
    procedure prmSaveExecute(Sender: TObject);
  private
    FSQLQuery:TSQLQueryControl;
    procedure DoMakeControls;
    procedure DoFillParams;
    procedure DoLoadParFormList;
    procedure DoSaveParToList;
  public
    procedure Localize;
    constructor CreateEditForm(ASQLQuery:TSQLQueryControl);
  end; 


function FillParamsList(ASQLQuery:TSQLQueryControl; DBRec:TDataBaseRecord; ASQLCommand:TSQLCommandAbstract):boolean;
implementation
uses LCLType, fbmStrConstUnit, fbmUserDataBaseUnit;

{$R *.lfm}

function FillParamsList(ASQLQuery:TSQLQueryControl; DBRec:TDataBaseRecord; ASQLCommand:TSQLCommandAbstract):boolean;
var
  fbmFillQueryParamsForm: TfbmFillQueryParamsForm;
begin
  fbmFillQueryParamsForm:=TfbmFillQueryParamsForm.CreateEditForm(ASQLQuery);
  fbmFillQueryParamsForm.DoMakeControls;
  Result:=fbmFillQueryParamsForm.ShowModal = mrOk;
  if Result then
    fbmFillQueryParamsForm.DoFillParams;
  fbmFillQueryParamsForm.Free;
end;

{ TfbmFillQueryParamsForm }

procedure TfbmFillQueryParamsForm.prmSaveExecute(Sender: TObject);
begin
{  if SaveDialog1.Execute then
  begin
    DoSaveParToList(FSaveParList);
    FSaveParList.SaveToFile(SaveDialog1.FileName);
  end;}
end;

procedure TfbmFillQueryParamsForm.DoMakeControls;
var
  I:integer;
//  Ofs:integer;
  Edt:TfbmSQLParamValueEditorFrame;
  Pr:TControl;
begin
  Pr:=ScrollBox1;
  for i:=0 to FSQLQuery.ParamCount-1 do
  begin
    Edt:=TfbmSQLParamValueEditorFrame.Create(Self);
    Edt.Name:='Cntr_'+IntToStr(I);
    Edt.Parent:=ScrollBox1;
    Edt.Left:=0;
    Edt.Width:=ScrollBox1.Width;
    Edt.AnchorSide[akRight].Control:=ScrollBox1;
    Edt.AnchorSide[akRight].Side:=asrRight;
    Edt.AnchorSide[akLeft].Control:=ScrollBox1;
    Edt.AnchorSide[akLeft].Side:=asrLeft;

    Edt.AnchorSideTop.Control:=PR;
    if Pr = ScrollBox1 then
      Edt.AnchorSideTop.Side:=asrTop
    else
      Edt.AnchorSideTop.Side:=asrBottom;

    Edt.Height:=Edt.Edit1.Top + Edt.Edit1.Height;
    Edt.SetParam(FSQLQuery.Param[i]);
    Edt.BorderSpacing.Around:=6;

    PR:=Edt
  end;
  DoLoadParFormList;
end;

procedure TfbmFillQueryParamsForm.DoFillParams;
var
  Cntr:TfbmSQLParamValueEditorFrame;
  I:integer;
begin
  for i:=0 to FSQLQuery.ParamCount-1 do
  begin
    Cntr:=FindComponent('Cntr_'+IntToStr(I)) as TfbmSQLParamValueEditorFrame;
    if not Assigned(Cntr) then
      raise Exception.Create('Не найден компонент параметра')
    else
      Cntr.GetParam(FSQLQuery.Param[i]);
  end;
  DoSaveParToList;
end;

procedure TfbmFillQueryParamsForm.DoLoadParFormList;
var
  i:integer;
  Cntr:TfbmSQLParamValueEditorFrame;
  S: TTranslateString;
begin
  UserDBModule.quParamsHistory.ParamByName('db_database_id').AsInteger:=FSQLQuery.Owner.DatabaseID;
  UserDBModule.quParamsHistory.Open;
  for i:=0 to FSQLQuery.ParamCount-1 do
  begin
    Cntr:=FindComponent('Cntr_'+IntToStr(I)) as TfbmSQLParamValueEditorFrame;
    if Assigned(Cntr) then
    begin
      S:=Cntr.Hint;
      if UserDBModule.quParamsHistory.Locate('sql_editors_history_param_name', S, []) then
      begin
        Cntr.DataType:=UserDBModule.quParamsHistorysql_editors_history_param_type.AsInteger;
        if UserDBModule.quParamsHistorysql_editors_history_param_value.IsNull then
          Cntr.CheckBox2.Checked:=true
        else
          Cntr.TextValue:=UserDBModule.quParamsHistorysql_editors_history_param_value.AsString;
      end;
    end;
  end;
  UserDBModule.quParamsHistory.Close;
end;

procedure TfbmFillQueryParamsForm.DoSaveParToList;
var
  i:integer;
  Cntr:TfbmSQLParamValueEditorFrame;
  S: TTranslateString;
begin
  UserDBModule.quParamsHistory.ParamByName('db_database_id').AsInteger:=FSQLQuery.Owner.DatabaseID;
  UserDBModule.quParamsHistory.Open;
  for i:=0 to FSQLQuery.ParamCount-1 do
  begin
    Cntr:=FindComponent('Cntr_'+IntToStr(I)) as TfbmSQLParamValueEditorFrame;
    if Assigned(Cntr) then
    begin
      S:=Cntr.Hint;
      if UserDBModule.quParamsHistory.Locate('sql_editors_history_param_name', S, []) then
        UserDBModule.quParamsHistory.Edit
      else
      begin
        UserDBModule.quParamsHistory.Append;
        UserDBModule.quParamsHistorydb_database_id.AsInteger:=FSQLQuery.Owner.DatabaseID;
        UserDBModule.quParamsHistorysql_editors_history_param_name.AsString:=S;
      end;
      UserDBModule.quParamsHistorysql_editors_history_param_type.AsInteger:=Cntr.DataType;
      if Cntr.CheckBox2.Checked then
        UserDBModule.quParamsHistorysql_editors_history_param_value.Clear
      else
        UserDBModule.quParamsHistorysql_editors_history_param_value.AsString:=Cntr.TextValue;
      UserDBModule.quParamsHistory.Post;
    end;
  end;
  UserDBModule.quParamsHistory.Close;
end;

procedure TfbmFillQueryParamsForm.Localize;
begin
  prmSave.Caption:=sSave;
  prmLoad.Caption:=sLoad;
  prmApply.Caption:=sApply;
  TabSheet1.Caption:=sParams;
  TabSheet2.Caption:=sParamsHistory;
end;

constructor TfbmFillQueryParamsForm.CreateEditForm(ASQLQuery: TSQLQueryControl);
begin
  inherited Create(Application);
  FSQLQuery:=ASQLQuery;
  Localize;
  PageControl1.ActivePageIndex:=0;
end;

procedure TfbmFillQueryParamsForm.prmLoadExecute(Sender: TObject);
begin
{  if OpenDialog1.Execute then
  begin
    FSaveParList.LoadFromFile(OpenDialog1.FileName);
    DoLoadParFormList(FSaveParList);
  end;}
end;

procedure TfbmFillQueryParamsForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Return then
    ModalResult:=mrOk;
end;


end.

