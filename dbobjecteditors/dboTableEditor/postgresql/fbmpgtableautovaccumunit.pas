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
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure CheckBox1Change(Sender: TObject);
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

procedure TfbmpgTableAutoVaccum.CheckBox1Change(Sender: TObject);
var
  FE: Boolean;
begin
  FE:=CheckBox1.Checked;
  Label1.Enabled:=FE;
  Edit1.Enabled:=FE;
  Label2.Enabled:=FE;
  Edit2.Enabled:=FE;
  Label3.Enabled:=FE;
  Edit3.Enabled:=FE;
  Label4.Enabled:=FE;
  Edit4.Enabled:=FE;
  Label5.Enabled:=FE;
  Edit5.Enabled:=FE;
  Label6.Enabled:=FE;
  Edit6.Enabled:=FE;
  Label7.Enabled:=FE;
  Edit7.Enabled:=FE;
  Label8.Enabled:=FE;
  Edit8.Enabled:=FE;
  Label9.Enabled:=FE;
  Edit9.Enabled:=FE;
  Label10.Enabled:=FE;
  Edit10.Enabled:=FE;
  Edit11.Enabled:=FE;
  Edit12.Enabled:=FE;
  Edit13.Enabled:=FE;
  Edit14.Enabled:=FE;
  Edit15.Enabled:=FE;
  Edit16.Enabled:=FE;
  Edit17.Enabled:=FE;
  Edit18.Enabled:=FE;
end;

function TfbmpgTableAutoVaccum.RefreshPage: boolean;
var
  AO, AODef: TPGAutovacuumOptions;
begin
  Result:=true;
  if DBObject is TPGMatView then
    AO:=TPGMatView(DBObject).AutovacuumOptions
  else
  if DBObject is TPGTable then
    AO:=TPGTable(DBObject).AutovacuumOptions
  else
    Exit;

  AODef:=TSQLEnginePostgre(DBObject.OwnerDB).AutovacuumOptions;
  Edit10.Text:=FloatToStr(AODef.VacuumThreshold);
  Edit11.Text:=FloatToStr(AODef.AnalyzeThreshold);
  Edit12.Text:=FloatToStr(AODef.VacuumScaleFactor);
  Edit13.Text:=FloatToStr(AODef.AnalyzeScaleFactor);
  Edit14.Text:=FloatToStr(AODef.VacuumCostDelay);
  Edit15.Text:=FloatToStr(AODef.VacuumCostLimit);
  Edit16.Text:=FloatToStr(AODef.FreezeMinAge);
  Edit17.Text:=FloatToStr(AODef.FreezeMaxAge);
  Edit18.Text:=FloatToStr(AODef.FreezeTableAge);

(*
  CheckBox1.Checked:=AO.Enabled;
  Edit1:=;
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
*)
(*
autovacuum_enabled=true,
autovacuum_vacuum_threshold = 51,
autovacuum_analyze_threshold = 51,
autovacuum_vacuum_scale_factor = 0.2,
autovacuum_analyze_scale_factor = 0.1,
autovacuum_vacuum_cost_delay = 20,
autovacuum_vacuum_cost_limit = 200,
autovacuum_freeze_min_age = 50000000,
autovacuum_freeze_max_age = 200000000,
  autovacuum_freeze_table_age = 150000000

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
  Edit10.Hint:=sAutovacuumAnalyzeScaleFactorHint;
  Edit11.Hint:=sAutovacuumAnalyzeScaleFactorHint;
end;

function TfbmpgTableAutoVaccum.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  FStp: TStrings;
begin
  Exit(true);
(*
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
*)
end;

end.

