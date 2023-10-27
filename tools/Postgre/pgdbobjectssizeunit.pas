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

unit pgDBObjectsSizeUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ZMacroQuery,
  ZConnection, rxdbgrid, rxmemds, DB, fbmAbstractSQLEngineToolsUnit,
  ibmanagertypesunit, SQLEngineCommonTypesUnit, sqlObjects,
  SQLEngineAbstractUnit;

type

  { TpgDBObjectsSizeTools }

  TpgDBObjectsSizeTools = class(TAbstractSQLEngineTools)
    dsTablesStat: TDataSource;
    pgStatDB: TZConnection;
    quTablesStat: TZMacroQuery;
    quTablesStatavg_rec_count: TFloatField;
    quTablesStatdescription: TMemoField;
    quTablesStatindex: TLargeintField;
    quTablesStatoid: TLongintField;
    quTablesStatrelkind: TStringField;
    quTablesStatrelname: TStringField;
    quTablesStatrelpages: TLongintField;
    quTablesStattoast: TLargeintField;
    quTablesStattotal: TLargeintField;
    RxDBGrid1: TRxDBGrid;
    rxData: TRxMemoryData;
    rxDataavg_rec_count: TFloatField;
    rxDatadescription: TMemoField;
    rxDataindex: TLargeintField;
    rxDataoid: TLongintField;
    rxDatarelkind: TStringField;
    rxDatarelname: TStringField;
    rxDatarelpages: TLongintField;
    rxDatatoast: TLargeintField;
    rxDatatotal: TLargeintField;
    procedure RxDBGrid1DblClick(Sender: TObject);
  private
  protected
    procedure SetSQLEngine(AValue: TSQLEngineAbstract); override;
    procedure Localize;override;
  public
    constructor Create(TheOwner: TComponent); override;
    procedure RefreshPage; override;
    function PageName:string; override;
  end;

implementation
uses fbmStrConstUnit, IBManDataInspectorUnit, PostgreSQLEngineUnit;

{$R *.lfm}

{ TpgDBObjectsSizeTools }

function TpgDBObjectsSizeTools.PageName: string;
begin
  Result:=sObjectsSize;
end;

procedure TpgDBObjectsSizeTools.RxDBGrid1DblClick(Sender: TObject);
var
  D: TDataBaseRecord;
begin
  if rxData.Active and (rxData.RecordCount > 0) then
  begin
    D:=fbManDataInpectorForm.DBBySQLEngine(SQLEngine);
    if Assigned(D) and D.Connected then
      D.ObjectShowEditor(rxDatarelname.AsString);
  end;
end;

procedure TpgDBObjectsSizeTools.SetSQLEngine(AValue: TSQLEngineAbstract);
begin
  inherited SetSQLEngine(AValue as TSQLEnginePostgre);
  pgStatDB.Protocol:='postgresql'; //pgZeosServerVersionProtoStr[FServerVersion];
  pgStatDB.User:=AValue.UserName;
  pgStatDB.Password:=AValue.Password;
  pgStatDB.HostName:=AValue.ServerName;
  pgStatDB.Database:=AValue.DataBaseName;
end;

procedure TpgDBObjectsSizeTools.Localize;
begin
  inherited Localize;

  RxDBGrid1.ColumnByFieldName('oid').Title.Caption:=sOID;
  RxDBGrid1.ColumnByFieldName('relname').Title.Caption:=sRelationName;
  RxDBGrid1.ColumnByFieldName('total').Title.Caption:=sTotalSize;
  RxDBGrid1.ColumnByFieldName('index').Title.Caption:=sIndexSize;
  RxDBGrid1.ColumnByFieldName('toast').Title.Caption:=sToastSize;
  RxDBGrid1.ColumnByFieldName('avg_rec_count').Title.Caption:=sAvgRecCount;
  RxDBGrid1.ColumnByFieldName('relpages').Title.Caption:=sPagesCount;
end;

constructor TpgDBObjectsSizeTools.Create(TheOwner: TComponent);
var
  R: TRxColumn;
begin
  inherited Create(TheOwner);

  R:=RxDBGrid1.ColumnByFieldName('relkind');
  R.KeyList.Clear;
  R.KeyList.Add('r=' + IntToStr(DBObjectKindImages[okTable]));
  R.KeyList.Add('t=' + IntToStr(DBObjectKindImages[okTable]));
  R.KeyList.Add('m=' + IntToStr(DBObjectKindImages[okMaterializedView]));
end;

procedure TpgDBObjectsSizeTools.RefreshPage;
begin
  pgStatDB.Connected:=True;
  rxData.CloseOpen;
  quTablesStat.Open;
  rxData.LoadFromDataSet(quTablesStat, 0, lmAppend);
  quTablesStat.Close;
  pgStatDB.Connected:=false;
end;

end.

