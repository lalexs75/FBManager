{ Free DB Manager

  Copyright (C) 2005-2020 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fbm_pgEditSequenceUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, fdmAbstractEditorUnit, PostgreSQLEngineUnit, SQLEngineAbstractUnit,
  fbmSqlParserUnit, sqlObjects;

type

  { Tfbm_pgEditSequencePage }

  Tfbm_pgEditSequencePage = class(TEditorPage)
    cbCycle: TCheckBox;
    edtSeqName: TEdit;
    edtStart: TEdit;
    edtInc: TEdit;
    edtMin: TEdit;
    edtMax: TEdit;
    edtCashe: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edtLastValue: TSpinEdit;
  private
    procedure LoadGenerator;
    procedure LoadGeneratorEx;
    procedure PrintPage;
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    procedure Localize;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses fbmStrConstUnit, fbmToolsUnit, LR_Class, IBManMainUnit, pg_SqlParserUnit;

{$R *.lfm}

{ Tfbm_pgEditSequencePage }

function Tfbm_pgEditSequencePage.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:PrintPage;
    epaRefresh:LoadGeneratorEx;
  else
    Result:=false;
    exit;
  end;
end;

function Tfbm_pgEditSequencePage.ActionEnabled(PageAction: TEditorPageAction): boolean;
begin
  Result := PageAction in [epaPrint, epaCompile, epaRefresh];
end;

procedure Tfbm_pgEditSequencePage.LoadGenerator;
begin
  edtSeqName.Text:=DBObject.Caption;
  edtSeqName.Enabled:=DBObject.State = sdboCreate;
  edtInc.Text:=IntToStr(TPGSequence(DBObject).IncByValue);
  edtMin.Text:=IntToStr(TPGSequence(DBObject).MinValue);
  edtMax.Text:=IntToStr(TPGSequence(DBObject).MaxValue);
  edtCashe.Text:=IntToStr(TPGSequence(DBObject).CasheValue);

  if DBObject.State = sdboCreate then
  begin
    edtLastValue.Value:=ConfigValues.ByNameAsInteger('TSQLEnginePostgre\Initial value for new sequence', 0);
    edtStart.Text:=IntToStr( ConfigValues.ByNameAsInteger('TSQLEnginePostgre\Initial value for new sequence', 0));
  end
  else
  begin
    edtLastValue.Value:=TPGSequence(DBObject).LastValue;
    edtStart.Text:=IntToStr(TPGSequence(DBObject).StartValue);
  end;
end;

procedure Tfbm_pgEditSequencePage.LoadGeneratorEx;
begin
  if DBObject.State <> sdboCreate then
    DBObject.RefreshObject;
  LoadGenerator;
end;

procedure Tfbm_pgEditSequencePage.PrintPage;
begin
  frVariables['DBClassTitle']:=DBObject.DBClassTitle;
  frVariables['ObjectName']:=DBObject.Caption;
  frVariables['ObjectDescription']:=DBObject.Description;
  fbManagerMainForm.LazReportPrint('DBObject_Sequence');
end;

procedure Tfbm_pgEditSequencePage.Localize;
begin
  Label1.Caption:=sSequence;
  Label2.Caption:=sStartValue;
  Label3.Caption:=sIncrement;
  Label4.Caption:=sMinValue;
  Label5.Caption:=sMaxValue;
  Label6.Caption:=sCache;
  Label7.Caption:=sLastValue;
  cbCycle.Caption:=sIsCycled;
end;

function Tfbm_pgEditSequencePage.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
begin
  if ASQLObject is TPGSQLCreateSequence then
  begin
    Result:=true;
    TPGSQLCreateSequence(ASQLObject).Name:=edtSeqName.Text;
    TPGSQLCreateSequence(ASQLObject).Start:=StrToInt64Def(edtStart.Text, TPGSequence(DBObject).StartValue);
    TPGSQLCreateSequence(ASQLObject).MinValue:=StrToInt64Def(edtMin.Text, TPGSequence(DBObject).MinValue);
    TPGSQLCreateSequence(ASQLObject).MaxValue:=StrToInt64Def(edtMax.Text, TPGSequence(DBObject).MaxValue);
    TPGSQLCreateSequence(ASQLObject).IncrementBy:=StrToInt64Def(edtInc.Text, TPGSequence(DBObject).IncByValue);
    TPGSQLCreateSequence(ASQLObject).NoCycle:=not cbCycle.Checked;
    TPGSQLCreateSequence(ASQLObject).Cache:=StrToIntDef(edtCashe.Text, TPGSequence(DBObject).CasheValue);
    TPGSQLCreateSequence(ASQLObject).CurrentValue:=edtLastValue.Value;

    if ASQLObject is TPGSQLAlterSequence then
    begin
      TPGSQLAlterSequence(ASQLObject).SequenceOldName:=DBObject.Caption;
      TPGSQLAlterSequence(ASQLObject).OldValue:=TPGSequence(DBObject).LastValue;
    end;
  end
  else
    Result:=false;
end;

function Tfbm_pgEditSequencePage.PageName: string;
begin
  Result:=sGenerator;
end;

constructor Tfbm_pgEditSequencePage.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  edtLastValue.MaxValue:=High(edtLastValue.MaxValue);
  LoadGenerator;
end;

end.

