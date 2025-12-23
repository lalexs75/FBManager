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

unit pgForeignServerUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ValEdit, DB, sqlEngineTypes,
  rxdbgrid, rxmemds, fdmAbstractEditorUnit, fbmSqlParserUnit, pg_SqlParserUnit,
  SQLEngineAbstractUnit, pgSQLEngineFDW, PostgreSQLEngineUnit;

type

  { TpgForeignServerPage }

  TpgForeignServerPage = class(TEditorPage)
    cbForeignDataWrapper: TComboBox;
    dsData: TDataSource;
    edtOwnerName: TComboBox;
    edtServerName: TEdit;
    edtServerType: TEdit;
    edtServerVersion: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    rxDataKEY: TStringField;
    rxDataValue: TStringField;
    RxDBGrid1: TRxDBGrid;
    rxData: TRxMemoryData;
    procedure RxDBGrid1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure RxDBGrid1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
  private
    procedure RefreshOwnerList;
    procedure RefreshObject;
    procedure FillDictionary;
    procedure PrintUserMap;
    function DoAcceptDrag(const Source: TObject): TControl;
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses fbmStrConstUnit, pgSqlEngineSecurityUnit, sqlObjects, IBManDataInspectorUnit;

{$R *.lfm}

{ TpgForeignServerPage }

procedure TpgForeignServerPage.RxDBGrid1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  Control: TControl;
begin
  Control:=DoAcceptDrag(Source);
  Accept:=(Control = fbManDataInpectorForm.TreeView1) and Assigned(fbManDataInpectorForm.CurrentDB)
    and (fbManDataInpectorForm.CurrentDB.SQLEngine.ClassName = DBObject.OwnerDB.ClassName);
end;

procedure TpgForeignServerPage.RxDBGrid1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  E: TSQLEngineAbstract;
begin
  if not Assigned(fbManDataInpectorForm.CurrentDB) then Exit;

  E:=fbManDataInpectorForm.CurrentDB.SQLEngine;
  rxData.CloseOpen;
  rxData.AppendRecord(['host', E.ServerName]);
  if E.RemotePort>0 then
    rxData.AppendRecord(['port', E.RemotePort]);
  rxData.AppendRecord(['dbname', E.DataBaseName]);
end;

procedure TpgForeignServerPage.RefreshOwnerList;
var
  S: TCaption;
begin
  S:=edtOwnerName.Text;
  edtOwnerName.Items.Clear;
  DBObject.OwnerDB.FillListForNames(edtOwnerName.Items, [okUser]);
  if (S<>'') then
    edtOwnerName.Text:=S;
end;

procedure TpgForeignServerPage.RefreshObject;
var
  i: Integer;
  S1, S2: String;
begin
  FillDictionary;
  RefreshOwnerList;
  edtServerName.Enabled:=DBObject.State <> sdboEdit;
  cbForeignDataWrapper.Text:=DBObject.OwnerRoot.OwnerRoot.Caption;
  cbForeignDataWrapper.Enabled:=false;
  if DBObject.State = sdboEdit then
  begin
    rxData.CloseOpen;
    edtServerName.Text:=DBObject.Caption;
    edtServerType.Text:=TPGForeignServer(DBObject).ServerType;
    edtServerVersion.Text:=TPGForeignServer(DBObject).ServerVersion;
    edtOwnerName.Text:=TPGForeignServer(DBObject).OwnerName;

    for i:=0 to TPGForeignServer(DBObject).Options.Count-1 do
      rxData.AppendRecord([TPGForeignServer(DBObject).Options.Names[i], TPGForeignServer(DBObject).Options.ValueFromIndex[i]]);
    rxData.First;
  end;
end;

procedure TpgForeignServerPage.FillDictionary;
begin

end;

procedure TpgForeignServerPage.PrintUserMap;
begin

end;

function TpgForeignServerPage.DoAcceptDrag(const Source: TObject): TControl;
begin
  if Source is TControl then
    Result:=Source as TControl
  else
  if Source is TDragControlObject then
    Result:=(Source as TDragControlObject).Control
  else
    Result:=nil;
end;

function TpgForeignServerPage.PageName: string;
begin
  Result:=sForeignServer;
end;

constructor TpgForeignServerPage.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  rxData.Open;
  RefreshObject;
end;

function TpgForeignServerPage.ActionEnabled(PageAction: TEditorPageAction): boolean;
begin
  Result:=PageAction in [epaPrint, epaRefresh, epaCompile];
end;

function TpgForeignServerPage.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:PrintUserMap;
    epaRefresh:RefreshObject;
  else
    Result:=false;
  end;
end;

procedure TpgForeignServerPage.Localize;
begin
  inherited Localize;
  Label1.Caption:=sServerName1;
  Label2.Caption:=sServerType;
  Label3.Caption:=sServerVersion1;
  Label4.Caption:=sForeignDataWrapper;
  Label6.Caption:=sOwner;
  Label5.Caption:=sOptions;

  RxDBGrid1.ColumnByFieldName('KEY').Title.Caption:=sParameter;
  RxDBGrid1.ColumnByFieldName('Value').Title.Caption:=sValue;
end;

function TpgForeignServerPage.SetupSQLObject(ASQLObject: TSQLCommandDDL): boolean;
var
  F1: Boolean;
  FCmd: TPGSQLAlterServer;
  FCmd1: TPGSQLCreateServer;
begin
  if ASQLObject is TPGSQLCreateServer then
  begin
    FCmd1:=ASQLObject as TPGSQLCreateServer;
    FCmd1.Name:=edtServerName.Text;
    FCmd1.ServerType:=edtServerType.Text;
    FCmd1.ServerVersion:=edtServerVersion.Text;
    FCmd1.ForeignDataWrapper:=DBObject.OwnerRoot.OwnerRoot.Caption;
    rxData.First;
    while not rxData.EOF do
    begin
      FCmd1.Params.AddParamEx(rxDataKEY.AsString, rxDataValue.AsString);
      rxData.Next;
    end;
    rxData.First;
    Result:=true;
  end
  else
  if ASQLObject is TPGSQLAlterServer then
  begin
    F1:=false;
    if edtOwnerName.Text <> TPGForeignServer(DBObject).OwnerName then
    begin
      if F1 then
      begin
        FCmd:=TPGSQLAlterServer.Create(ASQLObject);
        ASQLObject.AddChild(FCmd);
      end
      else
        FCmd:=ASQLObject as TPGSQLAlterServer;
      FCmd.NewOwner:=edtOwnerName.Text;
      FCmd.Name:=DBObject.Caption;
      F1:=true;
    end;
    Result:=F1;
  end
  else
    Result:=false;

end;

end.

