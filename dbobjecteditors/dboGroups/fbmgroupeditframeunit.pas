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

unit fbmGroupEditFrameUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ActnList, Buttons, ExtCtrls, Spin, rxdbgrid, rxmemds, rxtooledit, pgTypes,
  SQLEngineAbstractUnit, fdmAbstractEditorUnit, PostgreSQLEngineUnit, IniFiles,
  fbmSqlParserUnit, pgSqlEngineSecurityUnit, pg_SqlParserUnit;

type

  { TfbmGroupEditFrameEditor }

  TfbmGroupEditFrameEditor = class(TEditorPage)
    CheckBox1: TCheckBox;
    CheckGroup1: TCheckGroup;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    RxDateEdit1: TRxDateEdit;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckGroup1ItemClick(Sender: TObject; Index: integer);
  private
    procedure LoadGroupData;
    procedure PrintGroupCard;
    function GroupOptions:TPGUserOptions;
  public
    function PageName:string;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    procedure SaveState(const SectionName:string; const Ini:TIniFile);override;
    procedure RestoreState(const SectionName:string; const Ini:TIniFile);override;
    procedure Localize;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses fbmStrConstUnit, fbmToolsUnit;

{$R *.lfm}

{ TfbmGroupEditFrameEditor }

procedure TfbmGroupEditFrameEditor.CheckBox1Change(Sender: TObject);
begin
  Label3.Enabled:=not CheckBox1.Checked;
  RxDateEdit1.Enabled:=not CheckBox1.Checked;
end;

procedure TfbmGroupEditFrameEditor.CheckGroup1ItemClick(Sender: TObject;
  Index: integer);
begin
  if (Index = 2) and CheckGroup1.Checked[2] then
    CheckGroup1.Checked[5]:=true;
end;

procedure TfbmGroupEditFrameEditor.LoadGroupData;
begin
  SpinEdit1.Enabled:=DBObject.State = sdboCreate;
  SpinEdit1.Value:=TPGGroup(DBObject).ObjID;
  Edit1.Text:=DBObject.Caption;

  CheckGroup1.Checked[0]:=puoLoginEnabled in TPGGroup(DBObject).UserOptions;
  CheckGroup1.Checked[1]:=puoInheritedRight in TPGGroup(DBObject).UserOptions;
  CheckGroup1.Checked[2]:=puoSuperuser in TPGGroup(DBObject).UserOptions;
  CheckGroup1.Checked[3]:=puoCreateDatabaseObjects in TPGGroup(DBObject).UserOptions;
  CheckGroup1.Checked[4]:=puoCreateRoles in TPGGroup(DBObject).UserOptions;
  CheckGroup1.Checked[5]:=puoChangeSystemCatalog in TPGGroup(DBObject).UserOptions;
  CheckGroup1.Checked[6]:=puoReplication in TPGGroup(DBObject).UserOptions;

  CheckBox1.Checked:=puoNeverExpired in TPGGroup(DBObject).UserOptions;
  if not CheckBox1.Checked then
    RxDateEdit1.Date:=TPGGroup(DBObject).PwdValidDate;

  SpinEdit2.Value:=TPGGroup(DBObject).ConnectionsLimit;
end;

procedure TfbmGroupEditFrameEditor.PrintGroupCard;
begin

end;

function TfbmGroupEditFrameEditor.GroupOptions: TPGUserOptions;
begin
  Result:=[];
  if CheckGroup1.Checked[0] then
    Result:=Result + [puoLoginEnabled];
  if CheckGroup1.Checked[1] then
    Result:=Result + [puoInheritedRight];
  if CheckGroup1.Checked[2] then
    Result:=Result + [puoSuperuser];
  if CheckGroup1.Checked[3] then
    Result:=Result + [puoCreateDatabaseObjects];
  if CheckGroup1.Checked[4] then
    Result:=Result + [puoCreateRoles];
  if CheckGroup1.Checked[5] then
    Result:=Result + [puoChangeSystemCatalog];
  if CheckGroup1.Checked[6] then
    Result:=Result + [puoReplication];

  if CheckBox1.Checked then
    Result:=Result + [puoNeverExpired];
end;

function TfbmGroupEditFrameEditor.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  CG: TPGSQLCreateRole;
begin
  Result:=false;
  if (DBObject.State = sdboCreate) and (ASQLObject is TPGSQLCreateRole) then
  begin
    CG:=TPGSQLCreateRole(ASQLObject);
    CG.UserOptions:=GroupOptions;
    CG.Name:=Edit1.Text;
    CG.ConnectionLimit:=SpinEdit2.Value;
    //CG.o
    Result:=true;
  end
  else
  if (DBObject.State = sdboEdit) and (ASQLObject is TPGSQLAlterGroup) then
  begin
  end
end;

function TfbmGroupEditFrameEditor.PageName: string;
begin
  Result:=sGroup;
end;

function TfbmGroupEditFrameEditor.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:PrintGroupCard;
    epaRefresh:LoadGroupData;
//    epaCompile:Result:=CompileGroup;
  else
    Result:=false;
  end;
end;

function TfbmGroupEditFrameEditor.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaPrint, epaRefresh, epaCompile];
end;

procedure TfbmGroupEditFrameEditor.SaveState(const SectionName: string;
  const Ini: TIniFile);
begin
  inherited SaveState(SectionName, Ini);
end;

procedure TfbmGroupEditFrameEditor.RestoreState(const SectionName: string;
  const Ini: TIniFile);
begin
  inherited RestoreState(SectionName, Ini);
end;

procedure TfbmGroupEditFrameEditor.Localize;
begin
  Label1.Caption:=sGroupName;
  Label2.Caption:=sObjectID;
  Label3.Caption:=sPGValidUntil;
  Label4.Caption:=sPGMaxConnection;
  CheckBox1.Caption:=sPGNeverExpired;
  CheckGroup1.Caption:=sPGRolePrivilege;
  CheckGroup1.Items.BeginUpdate;
  CheckGroup1.Items.Clear;
  CheckGroup1.Items.Add(sPGLoginEnabled);
  CheckGroup1.Items.Add(sPGInheritedRight);
  CheckGroup1.Items.Add(sPGSuperuser);
  CheckGroup1.Items.Add(sPGAllowCreateDBObjects);
  CheckGroup1.Items.Add(sPGAllowCreateRoles);
  CheckGroup1.Items.Add(sPGAllowChangeSystemCatalog);
  CheckGroup1.Items.Add(sPGAllowCreateReplications);
  CheckGroup1.Items.EndUpdate;
end;

constructor TfbmGroupEditFrameEditor.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
var
  SQLEngine: TSQLEnginePostgre;
begin
  inherited CreatePage(TheOwner, ADBObject);
  SQLEngine:=TSQLEnginePostgre(ADBObject.OwnerDB);
  LoadGroupData;
  CheckGroup1.CheckEnabled[0]:=false;
  CheckGroup1.CheckEnabled[4]:=SQLEngine.ServerVersion < pgVersion9_6;
end;

end.

