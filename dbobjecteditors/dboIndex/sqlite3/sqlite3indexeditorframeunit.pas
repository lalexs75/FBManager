{ Free DB Manager

  Copyright (C) 2005-2020 Lagunov Aleksey  alexs75 at yandex.ru

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

unit sqlite3IndexEditorFrameUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, rxdbgrid, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Buttons, Menus, ActnList, fdmAbstractEditorUnit,
  db, rxmemds, SQLEngineAbstractUnit, fbmSqlParserUnit, sqlObjects;

type

  { Tsqlite3IndexEditorPage }

  Tsqlite3IndexEditorPage = class(TEditorPage)
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
    Label6: TLabel;
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
  private
    procedure PrintPage;
    procedure RefreshObject;
  public
    procedure Activate;override;
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses fbmStrConstUnit, fbmToolsUnit, pgTypes, SQLEngineCommonTypesUnit,
  SQLite3EngineUnit, rxdbutils;

{$R *.lfm}

{ Tsqlite3IndexEditorPage }

procedure Tsqlite3IndexEditorPage.cbTablesChange(Sender: TObject);
var
  T:TDBTableObject;
begin
  lbFieldList.Clear;
  if (cbTables.ItemIndex>-1) and (cbTables.ItemIndex < cbTables.Items.Count) then
  begin
    T:=TDBTableObject(cbTables.Items.Objects[cbTables.ItemIndex]);
    if Assigned(T) then
      T.FillFieldList(lbFieldList.Items, ccoNoneCase, False);
  end;
end;

procedure Tsqlite3IndexEditorPage.fldAddAllExecute(Sender: TObject);
begin
  while (lbFieldList.Items.Count>0) do
  begin
    lbFieldList.ItemIndex:=lbFieldList.Items.Count-1;
    fldAddExecute(nil);
  end;
end;

procedure Tsqlite3IndexEditorPage.fldAddExecute(Sender: TObject);
var
  S:string;
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

procedure Tsqlite3IndexEditorPage.fldRemoveAllExecute(Sender: TObject);
begin
  while (rxIndexFields.RecordCount>0) do
    fldRemoveExecute(nil);
end;

procedure Tsqlite3IndexEditorPage.fldRemoveExecute(Sender: TObject);
begin
  if rxIndexFields.RecordCount>0 then
  begin
    lbFieldList.ItemIndex:=lbFieldList.Items.Add(rxIndexFieldsFieldName.AsString);
    rxIndexFields.Delete;
  end;
end;

procedure Tsqlite3IndexEditorPage.lbFieldListDblClick(Sender: TObject);
begin
  fldAdd.Execute;
end;

procedure Tsqlite3IndexEditorPage.PrintPage;
begin
  //
end;

procedure Tsqlite3IndexEditorPage.RefreshObject;
var
  i:integer;
  S:string;
  F: TIndexField;
begin
  rxIndexFields.CloseOpen;
  edtIndexName.Enabled:=DBObject.State = sdboCreate;
  if DBObject.State <> sdboCreate then
  begin
    DBObject.RefreshObject;
    edtIndexName.Text:=DBObject.Caption;
  end
  else
  begin
    if (edtIndexName.Text = '') and Assigned(TSQLite3Index(DBObject).Table) then
    begin
      I:=0;
      repeat
        inc(i);
        S:='idx_'+TSQLite3Index(DBObject).Table.Caption+'_'+IntToStr(i);
      until not Assigned(DBObject.OwnerRoot.ObjByName(S));
      edtIndexName.Text:=S;
    end;
  end;

  cbTables.Enabled:=DBObject.State = sdboCreate;

  cbTables.Items.Clear;
  DBObject.OwnerDB.FillListForNames(cbTables.Items, [okTable]);

  if Assigned(TSQLite3Index(DBObject).Table) then
    cbTables.Text:=TSQLite3Index(DBObject).Table.Caption;
  cbTablesChange(nil);

  CheckGroup1.Checked[0]:=TSQLite3Index(DBObject).IndexUnique;

  Memo1.Text:=TSQLite3Index(DBObject).WhereExpression;

  if DBObject.State <> sdboCreate then
  begin
    for i:=0 to  TSQLite3Index(DBObject).IndexFields.Count-1 do
    begin
      F:=TSQLite3Index(DBObject).IndexFields[i];
      rxIndexFields.Append;
      rxIndexFieldsFieldName.AsString:=F.FieldName;
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

procedure Tsqlite3IndexEditorPage.Activate;
begin
  RefreshObject;
end;

function Tsqlite3IndexEditorPage.PageName: string;
begin
  Result:=sIndexs;
end;

constructor Tsqlite3IndexEditorPage.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  rxIndexFields.Open;
end;

function Tsqlite3IndexEditorPage.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaCompile, epaRefresh, epaPrint];
end;

function Tsqlite3IndexEditorPage.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    //epaCompile:Result:=Compile;
    epaRefresh:RefreshObject;
    epaPrint:PrintPage;
  end;
end;

procedure Tsqlite3IndexEditorPage.Localize;
begin
  Label1.Caption:=sIndexName;
  Label4.Caption:=sForTable;
  Label6.Caption:=sConditionForPartialIndex;

  fldAdd.Caption:=sAddField;
  fldAddAll.Caption:=sAddAllFields;
  fldRemove.Caption:=sRemoveField;
  fldRemoveAll.Caption:=sRemoveAllFields;

  fldAdd.Hint:=sAddField;
  fldAddAll.Hint:=sAddAllFields;
  fldRemove.Hint:=sRemoveField;
  fldRemoveAll.Hint:=sRemoveAllFields;

  CheckGroup1.Items[0]:=sUnique;

  RxDBGrid1.ColumnByFieldName('FieldName').Title.Caption:=sFieldName;
  RxDBGrid1.ColumnByFieldName('SortOrder').Title.Caption:=sSortOrder;
  RxDBGrid1.ColumnByFieldName('NullsPos').Title.Caption:=sNullsPos;
end;

function Tsqlite3IndexEditorPage.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
begin
  Result:=false;
  if (ASQLObject is TSQLCreateIndex) and (rxIndexFields.RecordCount > 0) then
  begin
    ASQLObject.Name:=edtIndexName.Text;
    TSQLCreateIndex(ASQLObject).Unique:=CheckGroup1.Checked[0];
    TSQLCreateIndex(ASQLObject).TableName:=cbTables.Text;
    rxIndexFields.First;
    while not rxIndexFields.EOF do
    begin
      TSQLCreateIndex(ASQLObject).Fields.AddParam(rxIndexFieldsFieldName.AsString);
      rxIndexFields.Next;
    end;
    rxIndexFields.First;
    Result:=true;
  end;
end;

end.

