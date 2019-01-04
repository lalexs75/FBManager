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

unit fbmFBIndexEditorUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, rxdbgrid, rxmemds, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, Buttons, Menus, ActnList, db,
  fdmAbstractEditorUnit, sqlObjects, SQLEngineAbstractUnit, fbmSqlParserUnit,
  FBSQLEngineUnit;

type

  { TfbmFBIndexEditorPage }

  TfbmFBIndexEditorPage = class(TEditorPage)
    ActionList1: TActionList;
    cbTables: TComboBox;
    CheckGroup1: TCheckGroup;
    dsIndexFields: TDataSource;
    edtIndexName: TEdit;
    fldAdd: TAction;
    fldAddAll: TAction;
    fldRemove: TAction;
    fldRemoveAll: TAction;
    Label1: TLabel;
    Label4: TLabel;
    lbFieldList: TListBox;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioGroup1: TRadioGroup;
    RxDBGrid1: TRxDBGrid;
    rxIndexFields: TRxMemoryData;
    rxIndexFieldsFieldName: TStringField;
    rxIndexFieldsNullsPos: TStringField;
    rxIndexFieldsSortOrder: TStringField;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Splitter1: TSplitter;
    procedure cbTablesChange(Sender: TObject);
    procedure fldAddAllExecute(Sender: TObject);
    procedure fldAddExecute(Sender: TObject);
    procedure fldRemoveAllExecute(Sender: TObject);
    procedure fldRemoveExecute(Sender: TObject);
    procedure lbFieldListDblClick(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RxDBGrid1DblClick(Sender: TObject);
  private
    procedure RefreshObject;
    procedure PrintPage;
    procedure DoGenIndexName;
    function TableName:string;
  public
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses fbmStrConstUnit, fb_SqlParserUnit, SQLEngineCommonTypesUnit;

{$R *.lfm}

{ TfbmFBIndexEditorPage }

procedure TfbmFBIndexEditorPage.fldAddExecute(Sender: TObject);
var
  S: String;
begin
  if (lbFieldList.ItemIndex>-1) and (lbFieldList.ItemIndex<lbFieldList.Items.Count) then
  begin
    S:=lbFieldList.Items[lbFieldList.ItemIndex];
    rxIndexFields.Append;
    rxIndexFieldsFieldName.AsString:=S;
    rxIndexFieldsSortOrder.AsString:='ASC';
    rxIndexFields.Post;
    lbFieldList.Items.Delete(lbFieldList.ItemIndex);
    if lbFieldList.Items.Count>0 then
      lbFieldList.ItemIndex:=0;
  end;
end;

procedure TfbmFBIndexEditorPage.fldRemoveAllExecute(Sender: TObject);
begin
  while (rxIndexFields.RecordCount>0) do
    fldRemoveExecute(nil);
end;

procedure TfbmFBIndexEditorPage.fldRemoveExecute(Sender: TObject);
begin
  if rxIndexFields.RecordCount>0 then
  begin
    lbFieldList.ItemIndex:=lbFieldList.Items.Add(rxIndexFieldsFieldName.AsString);
    rxIndexFields.Delete;
  end;
end;

procedure TfbmFBIndexEditorPage.lbFieldListDblClick(Sender: TObject);
begin
  fldAdd.Execute;
end;

procedure TfbmFBIndexEditorPage.RadioButton1Change(Sender: TObject);
begin
  Memo1.Enabled:=RadioButton1.Checked;
  Panel1.Enabled:=RadioButton2.Checked;
end;

procedure TfbmFBIndexEditorPage.RxDBGrid1DblClick(Sender: TObject);
begin
  fldRemove.Execute;
end;

procedure TfbmFBIndexEditorPage.fldAddAllExecute(Sender: TObject);
begin
  while (lbFieldList.Items.Count>0) do
  begin
    lbFieldList.ItemIndex:=lbFieldList.Items.Count-1;
    fldAddExecute(nil);
  end;
end;

procedure TfbmFBIndexEditorPage.cbTablesChange(Sender: TObject);
var
  T:TFireBirdTable;
begin
  lbFieldList.Clear;
  if (cbTables.ItemIndex>-1) and (cbTables.ItemIndex < cbTables.Items.Count) then
  begin
    T:=TFireBirdTable(cbTables.Items.Objects[cbTables.ItemIndex]);
    if Assigned(T) then
      T.FillFieldList(lbFieldList.Items, ccoNoneCase, False);
  end;

  if DBObject.State = sdboCreate then
    DoGenIndexName;
end;

procedure TfbmFBIndexEditorPage.RefreshObject;
var
  PGIF: TIndexField;
begin
  rxIndexFields.CloseOpen;

  edtIndexName.Enabled:=DBObject.State = sdboCreate;
  cbTables.Enabled:=DBObject.State = sdboCreate;
  RadioGroup1.Enabled:=DBObject.State = sdboCreate;

  if DBObject.State = sdboEdit then
  begin
    DBObject.RefreshObject;
    edtIndexName.Text:=DBObject.Caption;
    CheckGroup1.Checked[0]:=TFireBirdIndex(DBObject).IndexUnique;
    CheckGroup1.Checked[1]:=TFireBirdIndex(DBObject).IndexActive;

    if TFireBirdIndex(DBObject).IndexSortOrder = indDescending then
      RadioGroup1.ItemIndex:=1
    else
      RadioGroup1.ItemIndex:=0
      ;
  end;



  cbTables.Items.Clear;
  DBObject.OwnerDB.TablesRoot.FillListForNames(cbTables.Items, true);

  if Assigned(TFireBirdIndex(DBObject).Table) then
    cbTables.Text:=TFireBirdIndex(DBObject).Table.CaptionFullPatch;
  cbTablesChange(nil);

  Memo1.Text:=TFireBirdIndex(DBObject).IndexExpression;
  RadioButton1.Checked:=Trim(TFireBirdIndex(DBObject).IndexExpression) <> '';
  RadioButton2.Checked:=Trim(TFireBirdIndex(DBObject).IndexExpression) = '';

  if DBObject.State <> sdboCreate then
  begin
    for PGIF in TFireBirdIndex(DBObject).IndexFields do
    begin
      rxIndexFields.Append;
      rxIndexFieldsFieldName.AsString:=PGIF.FieldName;
{      case PGIF.NullPos of
        inpFirst:rxIndexFieldsNullsPos.AsString:='First';
        inpLast:rxIndexFieldsNullsPos.AsString:='Last';
      else
        //inpDefault,
      end;}
      rxIndexFields.Post;
    end;
    rxIndexFields.First;
  end;
end;

procedure TfbmFBIndexEditorPage.PrintPage;
begin

end;

procedure TfbmFBIndexEditorPage.DoGenIndexName;
var
  I: Integer;
  S1, S: String;
begin
  if DBObject.State = sdboEdit then exit;;
  S1:=TableName;
  if S1<>'' then
  begin
    I:=0;
    repeat
      inc(i);
      S:='idx_'+S1+'_'+IntToStr(i);
    until not Assigned(DBObject.OwnerRoot.ObjByName(S));
    edtIndexName.Text:=S;
  end;
end;

function TfbmFBIndexEditorPage.TableName: string;
var
  P: TFireBirdTable;
begin
  Result:='';
  if (cbTables.ItemIndex > -1) and (cbTables.ItemIndex < cbTables.Items.Count) then
  begin
    P:=TDBObject(cbTables.Items.Objects[cbTables.ItemIndex]) as TFireBirdTable;
    if Assigned(P) then
      Result:=P.Caption;
  end;
end;

function TfbmFBIndexEditorPage.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:PrintPage;
    epaRefresh:RefreshObject;
  end;
end;

function TfbmFBIndexEditorPage.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaPrint, epaCompile, epaRefresh];
end;

function TfbmFBIndexEditorPage.PageName: string;
begin
  Result:=sIndex;
end;

constructor TfbmFBIndexEditorPage.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  CheckGroup1.Checked[1]:=true;
  RefreshObject;
end;

procedure TfbmFBIndexEditorPage.Localize;
begin
  inherited Localize;
  CheckGroup1.Items[0]:=sUnique;
  CheckGroup1.Items[1]:=sActive;
  RadioGroup1.Items[0]:=sAscending;
  RadioGroup1.Items[1]:=sDescending;
  Label1.Caption:=sIndexName;
  Label4.Caption:=sForTable;
//  RadioButton2.Caption:=sindex;
end;

function TfbmFBIndexEditorPage.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  F: TSQLParserField;
begin
  Result:=true;
  if ASQLObject is TFBSQLCreateIndex then
  begin
    ASQLObject.Name:=edtIndexName.Text;
    TFBSQLCreateIndex(ASQLObject).Active:=CheckGroup1.Checked[1];
    TFBSQLCreateIndex(ASQLObject).Unique:=CheckGroup1.Checked[0];
    if RadioGroup1.ItemIndex = 0 then
      TFBSQLCreateIndex(ASQLObject).SortOrder:=indAscending
    else
      TFBSQLCreateIndex(ASQLObject).SortOrder:=indDescending;
    TFBSQLCreateIndex(ASQLObject).TableName:=cbTables.Text;
    if RadioButton1.Checked then
      TFBSQLCreateIndex(ASQLObject).IndexExpression:=Memo1.Text
    else
    begin
      rxIndexFields.First;
      while not rxIndexFields.EOF do
      begin
        F:=TFBSQLCreateIndex(ASQLObject).Fields.AddParam(rxIndexFieldsFieldName.AsString);
        rxIndexFields.Next;
      end;
      rxIndexFields.First;
      Result:=true;
    end;
  end
  else
  if ASQLObject is TFBSQLAlterIndex then
  begin
    ASQLObject.Name:=edtIndexName.Text;
    TFBSQLAlterIndex(ASQLObject).Active:=CheckGroup1.Checked[1];
  end
  else
    Result:=false;
end;

end.


