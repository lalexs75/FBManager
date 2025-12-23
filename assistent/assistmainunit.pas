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

unit assistMainUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, ComCtrls, StdCtrls, DB, RxDBGrid, rxmemds,
  assistTypesUnit, ibmanagertypesunit, fbmOIFoldersUnit, SQLEngineAbstractUnit,
  rxdbverticalgrid;

type

  { TassistMainFrame }

  TassistMainFrame = class(TFrame)
    dsFields: TDataSource;
    dsProps: TDataSource;
    Memo1: TMemo;
    PageControl1: TPageControl;
    RxDBGrid1: TRxDBGrid;
    RxDBGrid2: TRxDBGrid;
    rxFields: TRxMemoryData;
    rxFieldsFIELD_DESCRIPTION: TStringField;
    rxFieldsFIELD_DOMAIN: TStringField;
    rxFieldsFIELD_NAME: TStringField;
    rxFieldsFIELD_NO: TLongintField;
    rxFieldsFIELD_NOT_NULL: TBooleanField;
    rxFieldsFIELD_PK: TBooleanField;
    rxFieldsFIELD_TYPE: TStringField;
    rxProps: TRxMemoryData;
    rxPropsPROP_NAME: TStringField;
    rxPropsPROP_VALUE: TStringField;
    tabFields: TTabSheet;
    tabProperty: TTabSheet;
    tabDescription: TTabSheet;
  private
    FItems:TAssistentItems;
    procedure ClearAssistData;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    function UpdateAssistent(ARec:TDBInspectorRecord):Boolean;
    procedure UpdateAssistentFolder(ARec:TOIFolder);
    procedure Localize;
  end;

implementation
uses fbmStrConstUnit;

{$R *.lfm}

{ TassistMainFrame }

procedure TassistMainFrame.ClearAssistData;
begin
  rxFields.CloseOpen;
  rxProps.CloseOpen;
  Memo1.Clear;
  FItems.Clear;
end;

constructor TassistMainFrame.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FItems:=TAssistentItems.Create;
end;

destructor TassistMainFrame.Destroy;
begin
  FreeAndNil(FItems);
  inherited Destroy;
end;

function TassistMainFrame.UpdateAssistent(ARec: TDBInspectorRecord): Boolean;
var
  R: TAssistentItem;
  P: TDBObject;
  FVT: Boolean;
  F: TDBField;
begin
  ClearAssistData;
  FVT:=false;
  if Assigned(ARec) then
  begin
    Result:=ARec.SetSqlAssistentData(FItems);
    Memo1.Text:=FItems.Description;
    RxDBGrid2.ColumnByFieldName('PROP_NAME').Title.Caption:=FItems.ColName;
    RxDBGrid2.ColumnByFieldName('PROP_VALUE').Title.Caption:=FItems.ColValue;
    for R in FItems do
    begin
      rxProps.Append;
      rxPropsPROP_NAME.AsString:=R.Name;
      rxPropsPROP_VALUE.AsString:=R.Value;
      rxProps.Post;
    end;
    rxProps.First;

    P:=ARec.DBObject;
    if Assigned(P) then
    begin
      if P is TDBDataSetObject then
      begin
        FVT:=True;
        if not P.Loaded then
          P.RefreshObject;
        for F in TDBDataSetObject(P).Fields do
        begin
          rxFields.Append;
          rxFieldsFIELD_NO.AsInteger:=F.FieldNum;
          rxFieldsFIELD_NAME.AsString:=F.FieldName;
          rxFieldsFIELD_PK.AsBoolean:=F.FieldPK;
          rxFieldsFIELD_NOT_NULL.AsBoolean:=F.FieldNotNull;
          rxFieldsFIELD_TYPE.AsString:=F.FieldTypeName;
          rxFieldsFIELD_DOMAIN.AsString:=F.FieldTypeDomain;
          rxFieldsFIELD_DESCRIPTION.AsString:=F.FieldDescription;
          rxFields.Post;
        end;
        rxFields.First;
      end;
    end
  end;
  if FVT and not tabFields.TabVisible then
    PageControl1.ActivePage:=tabFields;
  tabFields.TabVisible:=FVT;
end;

procedure TassistMainFrame.UpdateAssistentFolder(ARec: TOIFolder);
var
  R: TAssistentItem;
begin
  ClearAssistData;
  if PageControl1.ActivePage = tabFields then
    PageControl1.ActivePage:=tabProperty;
  tabFields.TabVisible:=false;
  tabProperty.TabVisible:=true;
  tabDescription.TabVisible:=true;
  if not Assigned(ARec) then Exit;
  ARec.SetSqlAssistentData(FItems);
  Memo1.Text:=FItems.Description;
  RxDBGrid2.ColumnByFieldName('PROP_NAME').Title.Caption:=FItems.ColName;
  RxDBGrid2.ColumnByFieldName('PROP_VALUE').Title.Caption:=FItems.ColValue;
  for R in FItems do
  begin
    rxProps.Append;
    rxPropsPROP_NAME.AsString:=R.Name;
    rxPropsPROP_VALUE.AsString:=R.Value;
    rxProps.Post;
  end;
  rxProps.First;
end;

procedure TassistMainFrame.Localize;
begin
  tabFields.Caption:=sField;
  tabProperty.Caption:=sProperty;
  tabDescription.Caption:=sDescription;

  RxDBGrid2.ColumnByFieldName('PROP_NAME').Title.Caption:=sObjects;
  RxDBGrid2.ColumnByFieldName('PROP_VALUE').Title.Caption:=sDescription;


  RxDBGrid1.ColumnByFieldName('FIELD_PK').Title.Caption:=sPK;
//  RxDBGrid1.ColumnByFieldName('FIELD_UNQ').Title.Caption:=sUNQ;
  RxDBGrid1.ColumnByFieldName('FIELD_NAME').Title.Caption:=sFieldName;
  RxDBGrid1.ColumnByFieldName('FIELD_TYPE').Title.Caption:=sFieldType;
  RxDBGrid1.ColumnByFieldName('FIELD_DOMAIN').Title.Caption:=sDomain;
//  RxDBGrid1.ColumnByFieldName('FIELD_AUTOINC').Title.Caption:=sAutoincremet;
  RxDBGrid1.ColumnByFieldName('FIELD_NOT_NULL').Title.Caption:=sNotNull;
  RxDBGrid1.ColumnByFieldName('FIELD_DESCRIPTION').Title.Caption:=sDescription;
//  RxDBGrid1.ColumnByFieldName('FIELD_SIZE').Title.Caption:=sSize;
//  RxDBGrid1.ColumnByFieldName('FIELD_PREC').Title.Caption:=sPrec;
//  RxDBGrid1.ColumnByFieldName('FIELD_IS_LOCAL').Title.Caption:=sIsLocal;
//  RxDBGrid1.ColumnByFieldName('FIELD_DESC_EX').Title.Caption:=sDescription;
//  RxDBGrid1.ColumnByFieldName('FIELD_COLLATE').Title.Caption:=sCollate;
//  RxDBGrid1.ColumnByFieldName('FIELD_CHARSET').Title.Caption:=sCharSet;
//  RxDBGrid1.ColumnByFieldName('FIELD_DEF_VALUE').Title.Caption:=sDefaultValue;
end;

end.

