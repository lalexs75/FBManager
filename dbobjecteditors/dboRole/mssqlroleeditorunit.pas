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

unit mssqlRoleEditorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  fdmAbstractEditorUnit, SQLEngineAbstractUnit, fbmSqlParserUnit;

type

  { TmssqlRoleEditorFrame }

  TmssqlRoleEditorFrame = class(TEditorPage)
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
  private
    procedure LoadRoleData;
    procedure PrintPage;
  public
    function PageName:string; override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean;override;
  end;

implementation
uses fbmStrConstUnit, mssql_sql_parser;

{$R *.lfm}

{ TmssqlRoleEditorFrame }

procedure TmssqlRoleEditorFrame.LoadRoleData;
begin
  Edit1.Text:=DBObject.Caption;
  Edit1.ReadOnly:=DBObject.State = sdboEdit;

end;

procedure TmssqlRoleEditorFrame.PrintPage;
begin

end;

function TmssqlRoleEditorFrame.PageName: string;
begin
  Result:=sRole;
end;

function TmssqlRoleEditorFrame.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:PrintPage;
    epaRefresh:LoadRoleData;
  else
    Result:=false;
    exit;
  end;
end;

function TmssqlRoleEditorFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result := PageAction in [epaPrint, epaCompile, epaRefresh];
end;

constructor TmssqlRoleEditorFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  LoadRoleData;
end;

procedure TmssqlRoleEditorFrame.Localize;
begin
  inherited Localize;
end;

function TmssqlRoleEditorFrame.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
begin
  if ASQLObject is TMSSQLCreateRole then
  begin
    Result:=true;
    TMSSQLCreateRole(ASQLObject).Name:=Edit1.Text;
    TMSSQLCreateRole(ASQLObject).OwnerName:=ComboBox1.Text;
  end
  else
    Result:=inherited SetupSQLObject(ASQLObject);
end;

end.

