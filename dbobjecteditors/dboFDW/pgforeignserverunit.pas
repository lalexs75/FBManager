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

  { TpgForeignServer }

  TpgForeignServer = class(TEditorPage)
    ComboBox1: TComboBox;
    edtServerName: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
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

{ TpgForeignServer }

procedure TpgForeignServer.RefreshObject;
begin
  FillDictionary;
  if DBObject.State = sdboEdit then
  begin
    edtServerName.Text:=DBObject.Caption;

  end;
end;

procedure TpgForeignServer.FillDictionary;
begin

end;

procedure TpgForeignServer.PrintUserMap;
begin

end;

function TpgForeignServer.PageName: string;
begin
  Result:='Foreign server';
end;

constructor TpgForeignServer.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  RefreshObject;
end;

function TpgForeignServer.ActionEnabled(PageAction: TEditorPageAction): boolean;
begin
  Result:=PageAction in [epaPrint, epaRefresh, epaCompile];
end;

function TpgForeignServer.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:PrintUserMap;
    epaRefresh:RefreshObject;
  end;
end;

procedure TpgForeignServer.Localize;
begin
  inherited Localize;
end;

function TpgForeignServer.SetupSQLObject(ASQLObject: TSQLCommandDDL): boolean;
begin
  Result:=inherited SetupSQLObject(ASQLObject);
end;

end.

