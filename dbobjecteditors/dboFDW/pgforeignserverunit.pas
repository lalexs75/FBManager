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

unit pgForeignServerUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ValEdit,
  fdmAbstractEditorUnit, fbmSqlParserUnit, pg_SqlParserUnit,
  SQLEngineAbstractUnit, pgSQLEngineFDW, PostgreSQLEngineUnit;

type

  { TpgForeignServerPage }

  TpgForeignServerPage = class(TEditorPage)
    cbForeignDataWrapper: TComboBox;
    ComboBox2: TComboBox;
    edtServerName: TEdit;
    edtServerType: TEdit;
    edtServerVersion: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
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

{ TpgForeignServerPage }

procedure TpgForeignServerPage.RefreshObject;
var
  i: Integer;
  S1, S2: String;
begin
  FillDictionary;
  if DBObject.State = sdboEdit then
  begin
    ValueListEditor1.Clear;
    edtServerName.Text:=DBObject.Caption;
    edtServerType.Text:=TPGForeignServer(DBObject).ServerType;
    edtServerVersion.Text:=TPGForeignServer(DBObject).ServerVersion;
    edtServerVersion.Text:=TPGForeignServer(DBObject).ServerVersion;
    cbForeignDataWrapper.Text:=DBObject.OwnerRoot.OwnerRoot.Caption;

    for i:=0 to TPGForeignServer(DBObject).Options.Count-1 do
    begin
      S1:=TPGForeignServer(DBObject).Options.Names[i];
      S2:=TPGForeignServer(DBObject).Options.ValueFromIndex[i];
      ValueListEditor1.InsertRow(S1, S2, true);
    end;
  end;
end;

procedure TpgForeignServerPage.FillDictionary;
begin

end;

procedure TpgForeignServerPage.PrintUserMap;
begin

end;

function TpgForeignServerPage.PageName: string;
begin
  Result:=sForeignServer;
end;

constructor TpgForeignServerPage.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
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
end;

function TpgForeignServerPage.SetupSQLObject(ASQLObject: TSQLCommandDDL): boolean;
begin
  Result:=inherited SetupSQLObject(ASQLObject);
end;

end.

