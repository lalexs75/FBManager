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
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  fbmSqlParserUnit, fdmAbstractEditorUnit, PostgreSQLEngineUnit,
  SQLEngineAbstractUnit, sqlObjects;

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
uses rxAppUtils, fbmStrConstUnit, fbmToolsUnit, pg_utils, pg_SqlParserUnit;

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

  CheckBox1.Checked:=AO.Enabled;

  AODef:=TSQLEnginePostgre(DBObject.OwnerDB).AutovacuumOptions;
  Edit1.Text:=FloatToStr(AO.VacuumThreshold);
  Edit2.Text:=IntToStr(AO.AnalyzeThreshold);
  Edit3.Text:=FloatToStr(AO.VacuumScaleFactor);
  Edit4.Text:=FloatToStr(AO.AnalyzeScaleFactor);
  Edit5.Text:=IntToStr(AO.VacuumCostDelay);
  Edit6.Text:=IntToStr(AO.VacuumCostLimit);
  Edit7.Text:=IntToStr(AO.FreezeMinAge);
  Edit8.Text:=IntToStr(AO.FreezeMaxAge);
  Edit9.Text:=IntToStr(AO.FreezeTableAge);


  Edit10.Text:=FloatToStr(AODef.VacuumThreshold);
  Edit11.Text:=IntToStr(AODef.AnalyzeThreshold);
  Edit12.Text:=FloatToStr(AODef.VacuumScaleFactor);
  Edit13.Text:=FloatToStr(AODef.AnalyzeScaleFactor);
  Edit14.Text:=IntToStr(AODef.VacuumCostDelay);
  Edit15.Text:=IntToStr(AODef.VacuumCostLimit);
  Edit16.Text:=IntToStr(AODef.FreezeMinAge);
  Edit17.Text:=IntToStr(AODef.FreezeMaxAge);
  Edit18.Text:=IntToStr(AODef.FreezeTableAge);

  CheckBox1Change(nil);
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
  CheckBox1.Caption:=sAutovacuumEnabled;
  Label1.Caption:=sVacuumThreshold;
  Label2.Caption:=sAnalyzeThreshold;
  Label3.Caption:=sVacuumScaleFactor;
  Label4.Caption:=sAnalyzeScaleFactor;
  Label5.Caption:=sVacuumCostDelay;
  Label6.Caption:=sVacuumCostLimit;
  Label7.Caption:=sFreezeMinAge;
  Label8.Caption:=sFreezeMaxAge;
  Label9.Caption:=sFreezeTableAge;

  Edit10.Hint:=sVacuumThresholdHint;
  Edit11.Hint:=sAnalyzeThresholdHint;
  Edit12.Hint:=sVacuumScaleFactorHint;
  Edit13.Hint:=sAnalyzeScaleFactorHint;
  Edit14.Hint:=sVacuumCostDelayHint;
  Edit15.Hint:=sVacuumCostLimitHint;
  Edit16.Hint:=sFreezeMinAgeHint;
  Edit17.Hint:=sFreezeMaxAgeHint;
  Edit18.Hint:=sFreezeTableAgeHint;
end;

function TfbmpgTableAutoVaccum.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  FStp: TStrings;
  AO: TPGAutovacuumOptions;
  OP, OA: TAlterTableOperator;

procedure CheckModifyParamInt(AParamName, AParamValue:string; ACurValue:Int64);
var
  V: Int64;
begin
  V:=StrToInt64Def(AParamValue, -1);
  if V <> ACurValue then
  begin
    if V>-1 then
    begin
      if not Assigned(OP) then OP:=TPGSQLAlterTable(ASQLObject).AddOperator(ataSetParams);
      OP.Params.AddParam(AParamName).ParamValue:=IntToStr(V)
    end
    else
    begin
      if not Assigned(OA) then OA:=TPGSQLAlterTable(ASQLObject).AddOperator(ataReSetParams);
      OA.Params.AddParam(AParamName);
    end;
  end;
end;

procedure CheckModifyParamFloat(AParamName, AParamValue:string; ACurValue:Extended);
var
  V: Extended;
begin
  V:=StrToFloatDef(AParamValue, -1);
  if V <> ACurValue then
  begin
    if V>-1 then
    begin
      if not Assigned(OP) then OP:=TPGSQLAlterTable(ASQLObject).AddOperator(ataSetParams);
      OP.Params.AddParam(AParamName).ParamValue:=FloatToStrEx(V)
    end
    else
    begin
      if not Assigned(OA) then OA:=TPGSQLAlterTable(ASQLObject).AddOperator(ataReSetParams);
      OA.Params.AddParam(AParamName);
    end;
  end;
end;

var
  V: Extended;
  VI: Int64;
begin
  OP:=nil;
  OA:=nil;
  Result:=true;
  FStp:=nil;
  if ASQLObject is TPGSQLAlterTable then
  begin
    AO:=TPGTable(DBObject).AutovacuumOptions;
    if CheckBox1.Checked <> AO.Enabled then
    begin
      if not CheckBox1.Checked then
      begin
        OP:=TPGSQLAlterTable(ASQLObject).AddOperator(ataReSetParams);
        OP.Params.AddParam('autovacuum_enabled');
        OP.Params.AddParam('autovacuum_vacuum_threshold');
        OP.Params.AddParam('autovacuum_analyze_threshold');
        OP.Params.AddParam('autovacuum_vacuum_scale_factor');
        OP.Params.AddParam('autovacuum_analyze_scale_factor');
        OP.Params.AddParam('autovacuum_vacuum_cost_delay');
        OP.Params.AddParam('autovacuum_vacuum_cost_limit');
        OP.Params.AddParam('autovacuum_freeze_min_age');
        OP.Params.AddParam('autovacuum_freeze_max_age');
        OP.Params.AddParam('autovacuum_freeze_table_age');
        Exit;
      end
      else
      begin
        OP:=TPGSQLAlterTable(ASQLObject).AddOperator(ataSetParams);
        OP.Params.AddParam('autovacuum_enabled').ParamValue:='true';
        V:=StrToFloatDef(Edit1.Text, -1);
        if V>-1 then
          OP.Params.AddParam('autovacuum_vacuum_threshold').ParamValue:=FloatToStrEx(V);

        V:=StrToFloatDef(Edit2.Text, -1);
        if V>-1 then
          OP.Params.AddParam('autovacuum_analyze_threshold').ParamValue:=FloatToStrEx(V);

        V:=StrToFloatDef(Edit3.Text, -1);
        if V>-1 then
          OP.Params.AddParam('autovacuum_vacuum_scale_factor').ParamValue:=FloatToStrEx(V);

        V:=StrToFloatDef(Edit4.Text, -1);
        if V>-1 then
          OP.Params.AddParam('autovacuum_analyze_scale_factor').ParamValue:=FloatToStrEx(V);

        VI:=StrToInt64Def(Edit5.Text, -1);
        if V>-1 then
          OP.Params.AddParam('autovacuum_vacuum_cost_delay').ParamValue:=IntToStr(VI);

        VI:=StrToInt64Def(Edit6.Text, -1);
        if V>-1 then
          OP.Params.AddParam('autovacuum_vacuum_cost_limit').ParamValue:=IntToStr(VI);

        VI:=StrToInt64Def(Edit7.Text, -1);
        if V>-1 then
          OP.Params.AddParam('autovacuum_freeze_min_age').ParamValue:=IntToStr(VI);

        VI:=StrToInt64Def(Edit8.Text, -1);
        if V>-1 then
          OP.Params.AddParam('autovacuum_freeze_max_age').ParamValue:=IntToStr(VI);

        VI:=StrToInt64Def(Edit9.Text, -1);
        if V>-1 then
          OP.Params.AddParam('autovacuum_freeze_table_age').ParamValue:=IntToStr(VI);
      end
    end
    else
    if CheckBox1.Checked then
    begin
      CheckModifyParamFloat('autovacuum_vacuum_threshold', Edit1.Text, AO.VacuumThreshold);
      CheckModifyParamFloat('autovacuum_analyze_threshold', Edit2.Text, AO.AnalyzeThreshold);
      CheckModifyParamFloat('autovacuum_vacuum_scale_factor', Edit3.Text, AO.VacuumScaleFactor);
      CheckModifyParamFloat('autovacuum_analyze_scale_factor', Edit4.Text, AO.AnalyzeScaleFactor);
      CheckModifyParamInt('autovacuum_vacuum_cost_delay', Edit5.Text, AO.VacuumCostDelay);
      CheckModifyParamInt('autovacuum_vacuum_cost_limit', Edit6.Text, AO.VacuumCostLimit);
      CheckModifyParamInt('autovacuum_freeze_min_age', Edit7.Text, AO.FreezeMinAge);
      CheckModifyParamInt('autovacuum_freeze_max_age', Edit8.Text, AO.FreezeMaxAge);
      CheckModifyParamInt('autovacuum_freeze_table_age', Edit9.Text, AO.FreezeTableAge);
    end;
  end
(*  else
  if ASQLObject is TPGSQLAlterView then
  begin

  end;
  if not Assigned(FStp) then Exit(false);
  FStp.Values['autovacuum_enabled']:=BoolToStr(CheckBox1.Checked, true); //autovacuum_enabled=true
*)
end;

end.

