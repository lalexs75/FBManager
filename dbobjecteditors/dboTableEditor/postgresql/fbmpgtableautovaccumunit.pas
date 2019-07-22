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

unit fbmpgTableAutoVaccumUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, fbmSqlParserUnit,
  fdmAbstractEditorUnit, PostgreSQLEngineUnit, SQLEngineAbstractUnit;

type

  { TfbmpgTableAutoVaccum }

  TfbmpgTableAutoVaccum = class(TEditorPage)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
  private
    function RefreshPage:boolean;
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses fbmStrConstUnit, fbmToolsUnit, pg_utils, pg_SqlParserUnit;

{$R *.lfm}

{ TfbmpgTableAutoVaccum }

function TfbmpgTableAutoVaccum.RefreshPage: boolean;
var
  FStp: TStrings;
begin
  Result:=true;
  if DBObject is TPGMatView then
    FStp:=TPGMatView(DBObject).StorageParameters
  else
  if DBObject is TPGTable then
    FStp:=TPGTable(DBObject).StorageParameters
  else
    Exit;

  CheckBox1.Checked:=StrToBoolDef(FStp.Values['autovacuum_enabled'], false);
  if CheckBox1.Checked then
  begin
    if FStp.Values['autovacuum_vacuum_threshold']<>'' then
      Edit1.Text:=FStp.Values['autovacuum_vacuum_threshold']
    else
      Edit1.Text:='-1';

    if FStp.Values['autovacuum_analyze_threshold']<>'' then
      Edit2.Text:=FStp.Values['autovacuum_analyze_threshold']
    else
      Edit2.Text:='-1';
  end
  else
  begin
    Edit1.Text:='-1';
    Edit2.Text:='-1';
  end
(*
  autovacuum_enabled=true,
  autovacuum_vacuum_threshold=50,
  autovacuum_analyze_threshold=50
*)
end;

function TfbmpgTableAutoVaccum.PageName: string;
begin
  Result:=sAutoVacuum;
end;

constructor TfbmpgTableAutoVaccum.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  RefreshPage;
end;

function TfbmpgTableAutoVaccum.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaPrint, epaRefresh, epaCompile];
end;

function TfbmpgTableAutoVaccum.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  case PageAction of
    epaRefresh:Result:=RefreshPage;
  else
    Result:=inherited DoMetod(PageAction);
  end;
end;

procedure TfbmpgTableAutoVaccum.Localize;
begin
  inherited Localize;
end;

function TfbmpgTableAutoVaccum.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  FStp: TStrings;
begin
  FStp:=nil;
  if ASQLObject is TPGSQLCreateTable then
  begin
    FStp:=TPGSQLCreateTable(ASQLObject).StorageParameters;
  end
  else
  if ASQLObject is TPGSQLCreateView then
  begin

  end
  else
  if ASQLObject is TPGSQLAlterTable then
  begin

  end
  else
  if ASQLObject is TPGSQLAlterView then
  begin

  end;
  if not Assigned(FStp) then Exit(false);
  FStp.Values['autovacuum_enabled']:=BoolToStr(CheckBox1.Checked, true); //autovacuum_enabled=true

end;

end.

