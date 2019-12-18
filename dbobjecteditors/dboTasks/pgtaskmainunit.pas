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

unit pgTaskMainUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, DividerBevel, Forms, Controls, Graphics,
  fdmAbstractEditorUnit, PostgreSQLEngineUnit, pg_tasks, Dialogs, StdCtrls,
  SQLEngineAbstractUnit, fbmSqlParserUnit;

type

  { TpgTaskMainPage }

  TpgTaskMainPage = class(TEditorPage)
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    DividerBevel1: TDividerBevel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
  private
    procedure LoadTaskData;
  public
    function PageName:string;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation

uses fbmStrConstUnit;

{$R *.lfm}

{ TpgTaskMainPage }

procedure TpgTaskMainPage.LoadTaskData;
var
  i: Integer;
begin
  Edit1.Text:=DBObject.Caption;
  Edit2.Text:=IntToStr(TPGTask(DBObject).TaskID);

  Edit3.Text:=DateTimeToStr(TPGTask(DBObject).DateCreate);
  Edit4.Text:=DateTimeToStr(TPGTask(DBObject).DateModify);
  Edit5.Text:=DateTimeToStr(TPGTask(DBObject).DateRunLast);
  Edit6.Text:=DateTimeToStr(TPGTask(DBObject).DateRunNext);

  CheckBox1.Checked:=TPGTask(DBObject).Enabled;

  ComboBox1.Items.Assign(TPGTasksRoot(DBObject.OwnerRoot).JobClassList);

  for i:=0 to ComboBox1.Items.Count-1 do
    if PtrInt(ComboBox1.Items.Objects[i]) = TPGTask(DBObject).TaskClassID then
    begin
      ComboBox1.ItemIndex:=i;
      break;
    end;
end;

function TpgTaskMainPage.PageName: string;
begin
  Result:=sTask;
end;

function TpgTaskMainPage.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  case PageAction of
    epaRefresh:LoadTaskData;
  else
    Result:=false;
  end;
end;

function TpgTaskMainPage.ActionEnabled(PageAction: TEditorPageAction): boolean;
begin
  Result:=PageAction in [epaRefresh, epaPrint, epaCompile];
end;

procedure TpgTaskMainPage.Localize;
begin
  inherited Localize;
  Label1.Caption:=sTaskName;
  Label2.Caption:=sTaskID;
  CheckBox1.Caption:=sEnabled;
  Label2.Caption:=sTaskClass;

  Label4.Caption:=sDateCreated;
  Label5.Caption:=sDateModified;
  Label6.Caption:=sLastRun;
  Label7.Caption:=sNextRun;
end;

constructor TpgTaskMainPage.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  LoadTaskData;
end;

function TpgTaskMainPage.SetupSQLObject(ASQLObject: TSQLCommandDDL): boolean;
var
  FCmd: TPGSQLTaskCreate;
  FCmd1: TPGSQLTaskAlter;
  Op: TPGAlterTaskOperator;
begin
  Result:=Edit1.Text <> '';
  if not Result then Exit;

  if ASQLObject is TPGSQLTaskCreate then
  begin
    Result:=true;
    FCmd:=TPGSQLTaskCreate(ASQLObject);
    FCmd.Name:=Edit1.Text;
    FCmd.TaskClass:=ComboBox1.Text;
  end
  else
  if ASQLObject is TPGSQLTaskAlter then
  begin
    FCmd1:=TPGSQLTaskAlter(ASQLObject);
    if (Edit1.Text<>DBObject.Caption) or (CheckBox1.Checked <> TPGTask(DBObject).Enabled) then
    begin
      Op:=FCmd1.AddOperator(pgtaAlterTask);
      Op.ID:=TPGTask(DBObject).TaskID;
      Op.Caption:=Edit1.Text;
      Op.Enabled:=CheckBox1.Checked;
    end;
  end
  else
    Result:=false;
end;

end.

