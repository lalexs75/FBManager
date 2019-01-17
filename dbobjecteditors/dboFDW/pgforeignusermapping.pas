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

unit pgForeignUserMapping;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ValEdit,
  fdmAbstractEditorUnit, fbmSqlParserUnit, pg_SqlParserUnit, SQLEngineAbstractUnit, pgSQLEngineFDW,
  PostgreSQLEngineUnit;

type

  { TpgForeignUserMap }

  TpgForeignUserMap = class(TEditorPage)
    cbDBUsers: TComboBox;
    cbServerName: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ValueListEditor1: TValueListEditor;
  private
    procedure RefreshObject;
    procedure FillDictionary;
    procedure PrintUserMap;
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses fbmStrConstUnit, pgSqlEngineSecurityUnit;

{$R *.lfm}

{ TpgForeignUserMap }

procedure TpgForeignUserMap.RefreshObject;
var
  S, S1: String;
  i: Integer;
begin
  FillDictionary;
  cbServerName.Caption:=DBObject.OwnerRoot.OwnerRoot.Caption;
  if DBObject.State = sdboEdit then
  begin
    cbServerName.Enabled:=false;
    cbDBUsers.Text:=DBObject.Caption;

    ValueListEditor1.Clear;
    for i:=0 to TPGForeignUser(DBObject).Options.Count - 1 do
    begin;
      S:=TPGForeignUser(DBObject).Options.Names[i];
      S1:=TPGForeignUser(DBObject).Options.ValueFromIndex[i];
      ValueListEditor1.InsertRow(S, S1, true);
    end;
  end;
end;

procedure TpgForeignUserMap.FillDictionary;
var
  FSQLE: TSQLEnginePostgre;
begin
  cbDBUsers.Items.Clear;
  FSQLE:=TSQLEnginePostgre(DBObject.OwnerDB);
  TPGSecurityRoot(FSQLE.SecurityRoot).PGUsersRoot.FillListForNames(cbDBUsers.Items, true);
  cbDBUsers.Items.Add('USER');
  cbDBUsers.Items.Add('CURRENT_USER');
  cbDBUsers.Items.Add('PUBLIC');

  cbServerName.Items.Clear;
  DBObject.OwnerRoot.OwnerRoot.OwnerRoot.FillListForNames(cbServerName.Items, true);
end;

procedure TpgForeignUserMap.PrintUserMap;
begin

end;

function TpgForeignUserMap.PageName: string;
begin
  Result:='User mapping';
end;

constructor TpgForeignUserMap.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  RefreshObject;
end;

function TpgForeignUserMap.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaPrint, epaRefresh, epaCompile];
end;

function TpgForeignUserMap.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:PrintUserMap;
    epaRefresh:RefreshObject;
  end;
end;

procedure TpgForeignUserMap.Localize;
begin
  inherited Localize;
  Label1.Caption:=sDatabaseUser;
  Label2.Caption:=sServerName1;
  Label3.Caption:=sOptions;
end;

function TpgForeignUserMap.SetupSQLObject(ASQLObject: TSQLCommandDDL): boolean;
var
  i: Integer;
  S, S1: String;
begin
  Result:=false;
  if (DBObject.State = sdboCreate) and (ASQLObject is TPGSQLCreateUserMapping) then
  begin
    TPGSQLCreateUserMapping(ASQLObject).Name:=cbDBUsers.Text;
    TPGSQLCreateUserMapping(ASQLObject).ServerName:=cbServerName.Text;
    for i:=1 to ValueListEditor1.RowCount-1 do
    begin
      S:=ValueListEditor1.Keys[i];
      S1:=ValueListEditor1.Values[S];
      ASQLObject.Params.AddParamEx(S, S1);
    end;
    Result:=true;
  end
  else
  if (DBObject.State = sdboEdit) and (ASQLObject is TPGSQLAlterUserMapping) then
  begin

  end;
end;

end.

