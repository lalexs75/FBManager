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

unit fbmdboDependenUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, db, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, rxdbgrid, rxmemds, LR_DBSet,
  fdmAbstractEditorUnit, SQLEngineAbstractUnit;

type

  { TDependenciesFrame }

  TDependenciesFrame = class(TEditorPage)
    dsDependFields: TDatasource;
    dsOnDepFields: TDatasource;
    dsObjDepend: TDatasource;
    dsObjDependOn: TDatasource;
    frObjDepend: TfrDBDataSet;
    frObjDependOn: TfrDBDataSet;
    frDependFields: TfrDBDataSet;
    frOnDepFields: TfrDBDataSet;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    RxDBGrid1: TRxDBGrid;
    RxDBGrid2: TRxDBGrid;
    RxDBGrid3: TRxDBGrid;
    RxDBGrid4: TRxDBGrid;
    rxDependFields: TRxMemoryData;
    rxDependFieldsFIELD_NAME: TStringField;
    rxOnDepFields: TRxMemoryData;
    rxObjDepend: TRxMemoryData;
    rxObjDependOBJECT_NAME: TStringField;
    rxObjDependOBJECT_TYPE: TLongintField;
    rxObjDependOn: TRxMemoryData;
    rxObjDependOnOBJECT_NAME: TStringField;
    rxObjDependOnOBJECT_TYPE: TLongintField;
    rxOnDepFieldsFIELD_NAME: TStringField;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    procedure RxDBGrid1DblClick(Sender: TObject);
    procedure rxObjDependAfterScroll(DataSet: TDataSet);
  private
    procedure LoadDepend;
    procedure PrintDep;
  public
    procedure Localize;override;
    function PageName:string;override;
    procedure Activate;override;
    function DoMetod(PageAction: TEditorPageAction): boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
  end;

var
  DependenciesFrame: TDependenciesFrame;

implementation
uses fbmStrConstUnit, SQLEngineCommonTypesUnit, IBManDataInspectorUnit, rxdbutils,
  ibmanagertypesunit;

{$R *.lfm}

{ TDependenciesFrame }

procedure TDependenciesFrame.RxDBGrid1DblClick(Sender: TObject);
var
  Grid:TRxDBGrid absolute Sender;
  E:TDataBaseRecord;
  S:string;
  DI: TDBInspectorRecord;
  D: TDBObject;
begin
  S:=Grid.DataSource.DataSet.FieldByName('OBJECT_NAME').AsString;
  D:=DBObject.OwnerDB.DBObjectByName(S, false);
  E:=fbManDataInspectorForm.DBBySQLEngine(DBObject.OwnerDB);
  if Assigned(E) then
  begin
    DI:=E.FindDBObject(D);
    if Assigned(DI) then
      DI.Edit;
  end;
//    E.EditOpbject(S);
{
  G:=TDataBaseRecord(FDBObject.OwnerDB.InspectorRecord);
  R:=G.FindDBObject(G.GetDBObject(S));
  if Assigned(R) then
    R.Edit;
  raise Exception.Create('TDependenciesFrame.RxDBGrid1DblClick');}
end;

procedure TDependenciesFrame.rxObjDependAfterScroll(DataSet: TDataSet);
var
  DS:TDataSet;
  S:string;
  Rec:TDependRecord;
  i:integer;
begin
  S:=DataSet.FieldByName('OBJECT_NAME').AsString;
  if rxObjDepend = DataSet then
  begin
    DS:=rxDependFields;
  end
  else
  begin
    DS:=rxOnDepFields;
  end;
  DS.Close;
  DS.Open;
  Rec:=DBObject.DependList.FindDepend(S);
  if Assigned(Rec) then
  begin
    DBObject.RefreshDependenciesField(Rec);

    for i:=0 to Rec.FieldList.Count - 1 do
    begin
      DS.Append;
      DS.FieldByName('FIELD_NAME').AsString:=Rec.FieldList[i];
      DS.Post;
    end;
  end;
end;

procedure TDependenciesFrame.LoadDepend;
var
  i:integer;
  Rec:TDependRecord;
begin
  DBObject.RefreshDependencies;
  rxObjDepend.CloseOpen;
  rxObjDependOn.CloseOpen;
  rxObjDepend.AfterScroll:=nil;
  rxObjDependOn.AfterScroll:=nil;

  for i:=0 to DBObject.DependList.Count - 1 do
  begin
    Rec:=TDependRecord(DBObject.DependList[i]);
    if Rec.DependType <> 0 then
    begin
      rxObjDepend.Append;
      rxObjDependOBJECT_NAME.AsString:=Rec.ObjectName;
      rxObjDependOBJECT_TYPE.AsInteger:=Ord(Rec.ObjectKind);
      rxObjDepend.Post;
    end
    else
    begin
      rxObjDependOn.Append;
      rxObjDependOnOBJECT_NAME.AsString:=Rec.ObjectName;
      rxObjDependOnOBJECT_TYPE.AsInteger:=Ord(Rec.ObjectKind);
      rxObjDependOn.Post;
    end;
  end;

  rxObjDepend.AfterScroll:=@rxObjDependAfterScroll;
  rxObjDependOn.AfterScroll:=@rxObjDependAfterScroll;
  rxObjDependAfterScroll(rxObjDepend);
  rxObjDependAfterScroll(rxObjDependOn);

  rxObjDepend.First;
  rxObjDependOn.First;
end;

procedure TDependenciesFrame.PrintDep;
begin

end;

procedure TDependenciesFrame.Localize;
begin
  inherited Localize;
  Label1.Caption:=Format( sDependCaption1, [DBObject.Caption]);
  Label2.Caption:=Format( sDependCaption2, [DBObject.Caption]);
end;

function TDependenciesFrame.PageName: string;
begin
  Result:=sDependencies;
end;

procedure TDependenciesFrame.Activate;
begin
  LoadDepend;
end;

function TDependenciesFrame.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  Result:=true;
  case PageAction of
    epaRefresh:LoadDepend;
    epaPrint:PrintDep;
  end;
end;

function TDependenciesFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaRefresh, epaPrint];
end;

constructor TDependenciesFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  RxDBGrid1.Columns[0].Title.Caption:='...'; //sObjectType;
  RxDBGrid1.Columns[0].Width:=30;
  RxDBGrid1.Columns[1].Title.Caption:=sObjectName;
  RxDBGrid3.Columns[0].Title.Caption:=sFieldName;

  RxDBGrid2.Columns[0].Title.Caption:='...'; //sObjectType;
  RxDBGrid2.Columns[0].Width:=30;
  RxDBGrid2.Columns[1].Title.Caption:=sObjectName;
  RxDBGrid4.Columns[0].Title.Caption:=sFieldName;

  FillObjKindToImagesIndex(TRxColumn(RxDBGrid1.Columns[0]).KeyList);
  FillObjKindToImagesIndex(TRxColumn(RxDBGrid2.Columns[0]).KeyList);

  LoadDepend;
end;

end.

