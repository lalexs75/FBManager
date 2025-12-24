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

unit pg_con_EditorPrefUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, Spin, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, fdbm_ConnectionAbstractUnit, SQLEngineAbstractUnit,
  PostgreSQLEngineUnit;

type

  { Tpg_con_EditorPrefPage }

  Tpg_con_EditorPrefPage = class(TConnectionDlgPage)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5 : TCheckBox;
    DirectoryEdit1: TDirectoryEdit;
    Label1: TLabel;
    Label2 : TLabel;
    SpinEdit1 : TSpinEdit;
  private
    FSQLEngine:TSQLEngineAbstract;
    procedure InitFrame;
  public
    procedure Localize;override;
    procedure LoadParams(ASQLEngine:TSQLEngineAbstract);override;
    procedure SaveParams;override;
    function PageName:string;override;
    function Validate:boolean;override;
    function TestConnection:boolean;override;
    constructor Create(ASQLEngine:TSQLEngineAbstract; AOwner:TForm);
  end;

implementation
uses fbmStrConstUnit;

{$R *.lfm}

{ Tpg_con_EditorPrefPage }

procedure Tpg_con_EditorPrefPage.InitFrame;
begin

end;

procedure Tpg_con_EditorPrefPage.Localize;
begin
  inherited Localize;
  CheckBox1.Caption:=sLazzyModeLocalVariablesSP;
  CheckBox2.Caption:=sLazzyModeLocalVariablesTrigger;
  Label1.Caption:=sReportFolder;
  CheckBox3.Caption:=sUsePGShedule;
  CheckBox4.Caption:=sUsePGBouncer;
end;

procedure Tpg_con_EditorPrefPage.LoadParams(ASQLEngine: TSQLEngineAbstract);
begin
  InitFrame;
  CheckBox1.Checked := ASQLEngine.SPEditLazzyMode;
  CheckBox2.Checked := ASQLEngine.TriggerEditLazzyMode;
  DirectoryEdit1.Text:=ASQLEngine.ReportManagerFolder;
  CheckBox3.Checked:=ASQLEngine.UseSheduller;

  if ASQLEngine is TSQLEnginePostgre then
  begin
    CheckBox4.Checked:=TSQLEnginePostgre(ASQLEngine).UsePGBouncer;
  end;
end;

procedure Tpg_con_EditorPrefPage.SaveParams;
begin
  FSQLEngine.SPEditLazzyMode:=CheckBox1.Checked;
  FSQLEngine.TriggerEditLazzyMode:=CheckBox2.Checked;
  FSQLEngine.ReportManagerFolder:=DirectoryEdit1.Text;
  FSQLEngine.UseSheduller:=CheckBox3.Checked;

  if FSQLEngine is TSQLEnginePostgre then
  begin
    TSQLEnginePostgre(FSQLEngine).UsePGBouncer:=CheckBox4.Checked;
  end;
end;

function Tpg_con_EditorPrefPage.PageName: string;
begin
  Result:=sMisk;
end;

function Tpg_con_EditorPrefPage.Validate: boolean;
begin
  Result:=true;
end;

function Tpg_con_EditorPrefPage.TestConnection: boolean;
begin
  Result:=true;
end;

constructor Tpg_con_EditorPrefPage.Create(ASQLEngine: TSQLEngineAbstract;
  AOwner: TForm);
var
  P:TControl;
begin
  inherited Create(AOwner);
  FSQLEngine:=ASQLEngine;

  CheckBox3.Visible:=feSheduller in ASQLEngine.SQLEngileFeatures;
  CheckBox4.Visible:=ASQLEngine is TSQLEnginePostgre;
  CheckBox5.Visible :=feDBPing in ASQLEngine.SQLEngileFeatures;
  Label2.Visible :=CheckBox5.Visible;
  SpinEdit1.Visible :=CheckBox5.Visible;
  if CheckBox5.Visible then
  begin
    if CheckBox4.Visible then
      P:=CheckBox4
    else
    if CheckBox3.Visible then
      P:=CheckBox3
    else
      P:=DirectoryEdit1;
    CheckBox5.AnchorSideTop.Control:=P;
  end;

end;

end.

