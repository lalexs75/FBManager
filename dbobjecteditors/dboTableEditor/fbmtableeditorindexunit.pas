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

unit fbmTableEditorIndexUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, SQLEngineAbstractUnit,
  DBGrids, rxdbgrid, rxmemds, RxDBGridPrintGrid, db, LR_PGrid,
  fdmAbstractEditorUnit, Menus, ActnList, IniFiles;

type

  { TfbmTableEditorIndexFrame }

  TfbmTableEditorIndexFrame = class(TEditorPage)
    indRefresh: TAction;
    indNew: TAction;
    indEdit: TAction;
    indDelete: TAction;
    indPrint: TAction;
    ActionList1: TActionList;
    dsIndexList: TDatasource;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    PopupMenu1: TPopupMenu;
    RxDBGrid1: TRxDBGrid;
    RxDBGridPrint1: TRxDBGridPrint;
    rxIndexList: TRxMemoryData;
    rxIndexListActive: TBooleanField;
    rxIndexListCAPTION: TStringField;
    rxIndexListEXPRESSION: TStringField;
    rxIndexListIndex_Fields: TStringField;
    rxIndexListIndex_Num: TLongintField;
    rxIndexListSortOrder: TStringField;
    rxIndexListUnique: TBooleanField;
    procedure indDeleteExecute(Sender: TObject);
    procedure indEditExecute(Sender: TObject);
    procedure indNewExecute(Sender: TObject);
    procedure indPrintExecute(Sender: TObject);
    procedure indRefreshExecute(Sender: TObject);
    procedure RxDBGrid1DblClick(Sender: TObject);
  private
    procedure NewIndex;
    procedure EditIndex;
    procedure DropIndex;
    procedure RefreshIndexList;
    procedure RefreshIndexRow;
  public
    procedure Localize;override;
    function PageName:string;override;
    procedure Activate;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    procedure SaveState(const SectionName:string; const Ini:TIniFile);override;
    procedure RestoreState(const SectionName:string; const Ini:TIniFile);override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
  end;

implementation
uses fbmStrConstUnit, fbmToolsUnit, SQLEngineCommonTypesUnit, sqlObjects;

{$R *.lfm}

{ TfbmTableEditorIndexFrame }

procedure TfbmTableEditorIndexFrame.indPrintExecute(Sender: TObject);
begin
  DoMetod(epaPrint);
end;

procedure TfbmTableEditorIndexFrame.indNewExecute(Sender: TObject);
begin
  NewIndex;
end;

procedure TfbmTableEditorIndexFrame.indEditExecute(Sender: TObject);
begin
  EditIndex;
end;

procedure TfbmTableEditorIndexFrame.indDeleteExecute(Sender: TObject);
begin
  DropIndex;
end;

procedure TfbmTableEditorIndexFrame.indRefreshExecute(Sender: TObject);
begin
  RefreshIndexList
end;

procedure TfbmTableEditorIndexFrame.RxDBGrid1DblClick(Sender: TObject);
begin
  EditIndex;
end;

procedure TfbmTableEditorIndexFrame.NewIndex;
var
  S:string;
begin
  S:=TDBDataSetObject(DBObject).IndexNew;
  if S<>'' then
  begin
    RefreshIndexList;
    rxIndexList.Locate('CAPTION', S, []);
  end;
end;

procedure TfbmTableEditorIndexFrame.EditIndex;
begin
  if TDBDataSetObject(DBObject).IndexEdit(rxIndexListCAPTION.AsString) then
    RefreshIndexRow;
end;

procedure TfbmTableEditorIndexFrame.DropIndex;
begin
  if TDBDataSetObject(DBObject).IndexDelete(rxIndexListCAPTION.AsString) then
    RefreshIndexList;
end;

procedure TfbmTableEditorIndexFrame.RefreshIndexList;
var
  i: integer;
  TII:TIndexItem;
begin
  TDBDataSetObject(DBObject).IndexListRefresh;
  rxIndexList.EmptyTable;
  for i:=0 to TDBDataSetObject(DBObject).IndexCount - 1 do
  begin
    TII:=TDBDataSetObject(DBObject).IndexItem[i];
    rxIndexList.Append;
    rxIndexListIndex_Num.AsInteger:=i;
    rxIndexListCAPTION.AsString:=TII.IndexName;
    rxIndexListEXPRESSION.AsString:=TII.IndexExpression;
    rxIndexListIndex_Fields.AsString:=TII.IndexField;
    rxIndexListUnique.AsBoolean:=TII.Unique;
    rxIndexListActive.AsBoolean:=TII.Active;

    //rxIndexListDescending.AsBoolean:=TII.Descending;
    rxIndexListSortOrder.AsString:=IndexSortOrderStr(TII.SortOrder);

    rxIndexList.Post;
  end;
end;

procedure TfbmTableEditorIndexFrame.RefreshIndexRow;
begin

end;

procedure TfbmTableEditorIndexFrame.Localize;
begin
  inherited Localize;
  indNew.Caption:=sNewIndex;
  indEdit.Caption:=sEditIndex;
  indDelete.Caption:=sDeleteIndex;
  indPrint.Caption:=sPrintIndexList;
  indRefresh.Caption:=sRefreshIndexList;

  RxDBGrid1.ColumnByFieldName('CAPTION').Title.Caption:=sIndexCaption;
  RxDBGrid1.ColumnByFieldName('EXPRESSION').Title.Caption:=sIndexExpression;
  RxDBGrid1.ColumnByFieldName('Index_Fields').Title.Caption:=sOnFields;
  RxDBGrid1.ColumnByFieldName('Active').Title.Caption:=sActive;
  RxDBGrid1.ColumnByFieldName('SortOrder').Title.Caption:=sSortOrder;
  RxDBGrid1.ColumnByFieldName('Unique').Title.Caption:=sUnique;
end;

function TfbmTableEditorIndexFrame.PageName: string;
begin
  Result:=sIndexs;
end;

procedure TfbmTableEditorIndexFrame.Activate;
begin
  RefreshIndexList;
end;

function TfbmTableEditorIndexFrame.DoMetod(PageAction:TEditorPageAction):boolean;
begin
  Result:=true;
  case PageAction of
    epaRefresh:RefreshIndexList;
    epaPrint:RxDBGridPrint1.PreviewReport;
    epaAdd:NewIndex;
    epaEdit:EditIndex;
    epaDelete:DropIndex;
  else
    exit;
  end;
end;

function TfbmTableEditorIndexFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaPrint, epaRefresh, epaAdd, epaDelete, epaEdit];
end;

procedure TfbmTableEditorIndexFrame.SaveState(const SectionName: string;
  const Ini: TIniFile);
begin
  SaveRxDBGridState(SectionName+'.IndexListGrid', Ini, RxDBGrid1);
end;

procedure TfbmTableEditorIndexFrame.RestoreState(const SectionName: string;
  const Ini: TIniFile);
begin
  RestoreRxDBGridState(SectionName+'.IndexListGrid', Ini, RxDBGrid1);
end;

constructor TfbmTableEditorIndexFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  rxIndexList.Open;
end;

end.

