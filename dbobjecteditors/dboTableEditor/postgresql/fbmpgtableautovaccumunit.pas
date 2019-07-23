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
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
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
    Edit19: TEdit;
    Edit2: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit23: TEdit;
    Edit24: TEdit;
    Edit25: TEdit;
    Edit26: TEdit;
    Edit27: TEdit;
    Edit28: TEdit;
    Edit29: TEdit;
    Edit3: TEdit;
    Edit30: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
  private
    FAutovacuumOptions: TPGAutovacuumOptions;
    FToastAutovacuumOptions: TPGAutovacuumOptions;
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
uses rxAppUtils, fbmStrConstUnit, fbmToolsNV, pg_SqlParserUnit;

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

procedure TfbmpgTableAutoVaccum.CheckBox2Change(Sender: TObject);
var
  E: Boolean;
begin
  E:=CheckBox2.Checked and CheckBox2.Enabled;
  Label11.Enabled:=E;
  Label12.Enabled:=E;
  Label13.Enabled:=E;
  Label14.Enabled:=E;
  Label15.Enabled:=E;
  Label16.Enabled:=E;
  Label17.Enabled:=E;
  Edit19.Enabled:=E;
  Edit20.Enabled:=E;
  Edit21.Enabled:=E;
  Edit22.Enabled:=E;
  Edit23.Enabled:=E;
  Edit24.Enabled:=E;
  Edit25.Enabled:=E;
  Edit26.Enabled:=E;
  Edit27.Enabled:=E;
  Edit28.Enabled:=E;
  Edit29.Enabled:=E;
  Edit30.Enabled:=E;
  Edit31.Enabled:=E;
  Edit32.Enabled:=E;
end;

function TfbmpgTableAutoVaccum.RefreshPage: boolean;
var
  AODef: TPGAutovacuumOptions;
begin
  FAutovacuumOptions:=nil;
  FToastAutovacuumOptions:=nil;
  Result:=true;
  if DBObject is TPGMatView then
  begin
    FAutovacuumOptions:=TPGMatView(DBObject).AutovacuumOptions;
    if TPGMatView(DBObject).ToastRelOID>0 then
      FToastAutovacuumOptions:=TPGMatView(DBObject).ToastAutovacuumOptions;
  end
  else
  if DBObject is TPGTable then
  begin
    FAutovacuumOptions:=TPGTable(DBObject).AutovacuumOptions;
    if TPGTable(DBObject).ToastRelOID>0 then
      FToastAutovacuumOptions:=TPGTable(DBObject).ToastAutovacuumOptions;
  end
  else
    Exit;

  CheckBox1.Checked:=FAutovacuumOptions.Enabled;
  Edit1.Text:=IntToStr(FAutovacuumOptions.VacuumThreshold);
  Edit2.Text:=IntToStr(FAutovacuumOptions.AnalyzeThreshold);
  Edit3.Text:=FloatToStr(FAutovacuumOptions.VacuumScaleFactor);
  Edit4.Text:=FloatToStr(FAutovacuumOptions.AnalyzeScaleFactor);
  Edit5.Text:=IntToStr(FAutovacuumOptions.VacuumCostDelay);
  Edit6.Text:=IntToStr(FAutovacuumOptions.VacuumCostLimit);
  Edit7.Text:=IntToStr(FAutovacuumOptions.FreezeMinAge);
  Edit8.Text:=IntToStr(FAutovacuumOptions.FreezeMaxAge);
  Edit9.Text:=IntToStr(FAutovacuumOptions.FreezeTableAge);
  if Assigned(FToastAutovacuumOptions) then
  begin
    CheckBox2.Checked:=FToastAutovacuumOptions.Enabled;
    Edit19.Text:=IntToStr(FToastAutovacuumOptions.VacuumThreshold);
    Edit21.Text:=FloatToStr(FToastAutovacuumOptions.VacuumScaleFactor);
    Edit23.Text:=IntToStr(FToastAutovacuumOptions.VacuumCostDelay);
    Edit25.Text:=IntToStr(FToastAutovacuumOptions.VacuumCostLimit);
    Edit27.Text:=IntToStr(FToastAutovacuumOptions.FreezeMinAge);
    Edit30.Text:=IntToStr(FToastAutovacuumOptions.FreezeMaxAge);
    Edit31.Text:=IntToStr(FToastAutovacuumOptions.FreezeTableAge);
  end;

  //default values
  AODef:=TSQLEnginePostgre(DBObject.OwnerDB).AutovacuumOptions;
  Edit10.Text:=IntToStr(AODef.VacuumThreshold);
  Edit11.Text:=IntToStr(AODef.AnalyzeThreshold);
  Edit12.Text:=FloatToStr(AODef.VacuumScaleFactor);
  Edit13.Text:=FloatToStr(AODef.AnalyzeScaleFactor);
  Edit14.Text:=IntToStr(AODef.VacuumCostDelay);
  Edit15.Text:=IntToStr(AODef.VacuumCostLimit);
  Edit16.Text:=IntToStr(AODef.FreezeMinAge);
  Edit17.Text:=IntToStr(AODef.FreezeMaxAge);
  Edit18.Text:=IntToStr(AODef.FreezeTableAge);

  Edit20.Text:=IntToStr(AODef.VacuumThreshold);
  Edit22.Text:=FloatToStr(AODef.VacuumScaleFactor);
  Edit24.Text:=IntToStr(AODef.VacuumCostDelay);
  Edit26.Text:=IntToStr(AODef.VacuumCostLimit);
  Edit28.Text:=IntToStr(AODef.FreezeMinAge);
  Edit29.Text:=IntToStr(AODef.FreezeMaxAge);
  Edit32.Text:=IntToStr(AODef.FreezeTableAge);

  CheckBox2.Enabled:=Assigned(FToastAutovacuumOptions);
  CheckBox1Change(nil);
  CheckBox2Change(nil);
end;

function TfbmpgTableAutoVaccum.PageName: string;
begin
  Result:=sAutoVacuum;
end;

constructor TfbmpgTableAutoVaccum.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  PageControl1.ActivePageIndex:=0;
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
  TabSheet1.Caption:=sTable;
  TabSheet2.Caption:=sToastTable;
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

  Label11.Caption:=sVacuumThreshold;
  Label12.Caption:=sVacuumScaleFactor;
  Label13.Caption:=sVacuumCostDelay;
  Label14.Caption:=sVacuumCostLimit;
  Label15.Caption:=sFreezeMinAge;
  Label16.Caption:=sFreezeMaxAge;
  Label17.Caption:=sFreezeTableAge;

  Label10.Caption:=sCurrentValue;
  Label18.Caption:=sCurrentValue;

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
  OP, OA: TAlterTableOperator;
  OAParams: TSQLFields;
  OPParams: TSQLFields;
  OAM, OPM: TPGSQLAlterMaterializedCmd;

procedure CheckOAParams;
begin
  if Assigned(OAParams) then Exit;
  if ASQLObject is TPGSQLAlterTable then
  begin
    OA:=TPGSQLAlterTable(ASQLObject).AddOperator(ataReSetParams);
    OAParams:=OA.Params;
  end
  else
  if ASQLObject is TPGSQLAlterMaterializedView then
  begin
    OAM:=TPGSQLAlterMaterializedView(ASQLObject).Actions.Add(amvAlterReSetParamStor);
    OAParams:=OAM.Params;
  end
  else
    raise Exception.Create('CheckOAParams;');
end;

procedure CheckOPParams;
begin
  if Assigned(OPParams) then Exit;
  if ASQLObject is TPGSQLAlterTable then
  begin
    OP:=TPGSQLAlterTable(ASQLObject).AddOperator(ataSetParams);
    OPParams:=OP.Params;
  end
  else
  if ASQLObject is TPGSQLAlterMaterializedView then
  begin
    OPM:=TPGSQLAlterMaterializedView(ASQLObject).Actions.Add(amvAlterSetParamStor);
    OPParams:=OPM.Params;
  end
  else
    raise Exception.Create('CheckOPParams;');
end;

procedure CheckModifyParamInt(AParamName, AParamValue:string; ACurValue:Int64);
var
  V: Int64;
begin
  V:=StrToInt64Def(AParamValue, -1);
  if V <> ACurValue then
  begin
    if V>-1 then
    begin
      CheckOPParams;
      OPParams.AddParam(AParamName).ParamValue:=IntToStr(V)
    end
    else
    begin
      CheckOAParams;
      OAParams.AddParam(AParamName);
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
      CheckOPParams;
      OPParams.AddParam(AParamName).ParamValue:=FloatToStrEx(V)
    end
    else
    begin
      CheckOAParams;
      OAParams.AddParam(AParamName);
    end;
  end;
end;

procedure SetModifyParamFloat(AName, AValue:string); inline;
var
  V: Extended;
begin
  V:=StrToFloatDef(AValue, -1);
  if V>-1 then OPParams.AddParam(AName).ParamValue:=FloatToStrEx(V);
end;

procedure SetModifyParamInt(AName, AValue:string); inline;
begin
  if StrToInt64Def(AValue, -1)>-1 then OPParams.AddParam(AName).ParamValue:=AValue;
end;

begin
  OP:=nil;
  OA:=nil;
  OAParams:=nil;
  OPParams:=nil;
  Result:=true;

  if CheckBox1.Checked <> FAutovacuumOptions.Enabled then
  begin
    if not CheckBox1.Checked then
    begin
      CheckOAParams;
      OAParams.AddParam('autovacuum_enabled');
      OAParams.AddParam('autovacuum_vacuum_threshold');
      OAParams.AddParam('autovacuum_analyze_threshold');
      OAParams.AddParam('autovacuum_vacuum_scale_factor');
      OAParams.AddParam('autovacuum_analyze_scale_factor');
      OAParams.AddParam('autovacuum_vacuum_cost_delay');
      OAParams.AddParam('autovacuum_vacuum_cost_limit');
      OAParams.AddParam('autovacuum_freeze_min_age');
      OAParams.AddParam('autovacuum_freeze_max_age');
      OAParams.AddParam('autovacuum_freeze_table_age');
    end
    else
    begin
      CheckOPParams;
      OPParams.AddParam('autovacuum_enabled').ParamValue:='true';
      SetModifyParamInt('autovacuum_vacuum_threshold', Edit1.Text);
      SetModifyParamInt('autovacuum_analyze_threshold', Edit2.Text);
      SetModifyParamFloat('autovacuum_vacuum_scale_factor', Edit3.Text);
      SetModifyParamFloat('autovacuum_analyze_scale_factor', Edit4.Text);
      SetModifyParamInt('autovacuum_vacuum_cost_delay', Edit5.Text);
      SetModifyParamInt('autovacuum_vacuum_cost_limit', Edit6.Text);
      SetModifyParamInt('autovacuum_freeze_min_age', Edit7.Text);
      SetModifyParamInt('autovacuum_freeze_max_age', Edit8.Text);
      SetModifyParamInt('autovacuum_freeze_table_age', Edit9.Text);
    end
  end
  else
  if CheckBox1.Checked then
  begin
    CheckModifyParamInt('autovacuum_vacuum_threshold', Edit1.Text, FAutovacuumOptions.VacuumThreshold);
    CheckModifyParamInt('autovacuum_analyze_threshold', Edit2.Text, FAutovacuumOptions.AnalyzeThreshold);
    CheckModifyParamFloat('autovacuum_vacuum_scale_factor', Edit3.Text, FAutovacuumOptions.VacuumScaleFactor);
    CheckModifyParamFloat('autovacuum_analyze_scale_factor', Edit4.Text, FAutovacuumOptions.AnalyzeScaleFactor);
    CheckModifyParamInt('autovacuum_vacuum_cost_delay', Edit5.Text, FAutovacuumOptions.VacuumCostDelay);
    CheckModifyParamInt('autovacuum_vacuum_cost_limit', Edit6.Text, FAutovacuumOptions.VacuumCostLimit);
    CheckModifyParamInt('autovacuum_freeze_min_age', Edit7.Text, FAutovacuumOptions.FreezeMinAge);
    CheckModifyParamInt('autovacuum_freeze_max_age', Edit8.Text, FAutovacuumOptions.FreezeMaxAge);
    CheckModifyParamInt('autovacuum_freeze_table_age', Edit9.Text, FAutovacuumOptions.FreezeTableAge);
  end;


  if CheckBox2.Enabled then
  begin
    if CheckBox2.Checked <> FToastAutovacuumOptions.Enabled then
    begin
      if not CheckBox2.Checked then
      begin
        CheckOAParams;
        OAParams.AddParam('toast.autovacuum_enabled');
        OAParams.AddParam('toast.autovacuum_vacuum_threshold');
        OAParams.AddParam('toast.autovacuum_vacuum_scale_factor');
        OAParams.AddParam('toast.autovacuum_vacuum_cost_delay');
        OAParams.AddParam('toast.autovacuum_vacuum_cost_limit');
        OAParams.AddParam('toast.autovacuum_freeze_min_age');
        OAParams.AddParam('toast.autovacuum_freeze_max_age');
        OAParams.AddParam('toast.autovacuum_freeze_table_age');
      end
      else
      begin
        CheckOPParams;
        OPParams.AddParam('toast.autovacuum_enabled').ParamValue:='true';
        SetModifyParamInt('toast.autovacuum_vacuum_threshold', Edit19.Text);
        SetModifyParamFloat('toast.autovacuum_vacuum_scale_factor', Edit21.Text);
        SetModifyParamInt('toast.autovacuum_vacuum_cost_delay', Edit23.Text);
        SetModifyParamInt('toast.autovacuum_vacuum_cost_limit', Edit25.Text);
        SetModifyParamInt('toast.autovacuum_freeze_min_age', Edit27.Text);
        SetModifyParamInt('toast.autovacuum_freeze_max_age', Edit30.Text);
        SetModifyParamInt('toast.autovacuum_freeze_table_age', Edit31.Text);
      end
    end
    else
    if CheckBox2.Checked then
    begin
      CheckModifyParamInt('toast.autovacuum_vacuum_threshold', Edit19.Text, FToastAutovacuumOptions.VacuumThreshold);
      CheckModifyParamFloat('toast.autovacuum_vacuum_scale_factor', Edit21.Text, FToastAutovacuumOptions.VacuumScaleFactor);
      CheckModifyParamInt('toast.autovacuum_vacuum_cost_delay', Edit23.Text, FToastAutovacuumOptions.VacuumCostDelay);
      CheckModifyParamInt('toast.autovacuum_vacuum_cost_limit', Edit25.Text, FToastAutovacuumOptions.VacuumCostLimit);
      CheckModifyParamInt('toast.autovacuum_freeze_min_age', Edit27.Text, FToastAutovacuumOptions.FreezeMinAge);
      CheckModifyParamInt('toast.autovacuum_freeze_max_age', Edit30.Text, FToastAutovacuumOptions.FreezeMaxAge);
      CheckModifyParamInt('toast.autovacuum_freeze_table_age', Edit31.Text, FToastAutovacuumOptions.FreezeTableAge);
    end;
  end;
end;

end.

