{ Free DB Manager

  Copyright (C) 2005-2024 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fdmUserEditor_MySQLUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, sqlEngineTypes,
  IniFiles, fbmSqlParserUnit, fdmAbstractEditorUnit, SQLEngineAbstractUnit,
  mysql_engine, sqlObjects, SQLEngineCommonTypesUnit;

type

  { TfdmUserEditor_MySQLForm }

  TfdmUserEditor_MySQLForm = class(TEditorPage)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckGroup1: TCheckGroup;
    edtMaxQueriesPerHour: TEdit;
    edtMaxConnectionsPerHour: TEdit;
    edtMaxUpdatePerHour: TEdit;
    edtMaxUserConnections: TEdit;
    edtUserName: TEdit;
    edtHostName: TEdit;
    edtPassword: TEdit;
    edtPasswordConfirm: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    _Label: TLabel;
    procedure CheckBox1Change(Sender: TObject);
  private
    procedure LoadUserData;
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

uses rxAppUtils, fbmStrConstUnit, fbmToolsUnit, mysql_SqlParserUnit;

{$R *.lfm}

{ TfdmUserEditor_MySQLForm }

procedure TfdmUserEditor_MySQLForm.CheckBox1Change(Sender: TObject);
begin
  CheckGroup1.Enabled:=not CheckBox1.Checked;
end;

procedure TfdmUserEditor_MySQLForm.LoadUserData;
begin
  if not Assigned(DBObject) then Exit;
  edtUserName.Text:=TMySQLUser(DBObject).UserName;
  edtHostName.Text:=TMySQLUser(DBObject).HostName;
  edtPassword.Text:=TMySQLUser(DBObject).Password;
  edtPasswordConfirm.Text:=TMySQLUser(DBObject).Password;

  CheckGroup1.Checked[0]:=msuoSelectPriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[1]:=msuoInsertPriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[2]:=msuoUpdatePriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[3]:=msuoDeletePriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[4]:=msuoCreatePriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[5]:=msuoDropPriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[6]:=msuoReloadPriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[7]:=msuoShutdownPriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[8]:=msuoProcessPriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[9]:=msuoFilePriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[10]:=msuoGrantPriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[11]:=msuoReferencesPriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[12]:=msuoIndexPriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[13]:=msuoAlterPriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[14]:=msuoShowDBPriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[15]:=msuoSuperPriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[16]:=msuoCreateTmpTablePriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[17]:=msuoLockTablesPriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[18]:=msuoExecutePriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[19]:=msuoReplSlavePriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[20]:=msuoReplClientPriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[21]:=msuoCreateViewPriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[22]:=msuoShowViewPriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[23]:=msuoCreateRoutinePriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[24]:=msuoAlterRoutinePriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[25]:=msuoCreateUserPriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[26]:=msuoEventPriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[27]:=msuoTriggerPriv in TMySQLUser(DBObject).UserOptions;
  CheckGroup1.Checked[28]:=msuoCreateTablespacePriv in TMySQLUser(DBObject).UserOptions;

  edtMaxQueriesPerHour.Text:=IntToStr(TMySQLUser(DBObject).MaxQueriesPerHour);
  edtMaxUpdatePerHour.Text:=IntToStr(TMySQLUser(DBObject).MaxUpdatePerHour);
  edtMaxConnectionsPerHour.Text:=IntToStr(TMySQLUser(DBObject).MaxConnectionsPerHour);
  edtMaxUserConnections.Text:=IntToStr(TMySQLUser(DBObject).MaxUserConnections);
end;

function TfdmUserEditor_MySQLForm.PageName: string;
begin
  Result:='User name';
end;

function TfdmUserEditor_MySQLForm.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=inherited DoMetod(PageAction);
end;

function TfdmUserEditor_MySQLForm.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaPrint, epaRefresh, epaCompile];
end;

procedure TfdmUserEditor_MySQLForm.SaveState(const SectionName: string;
  const Ini: TIniFile);
begin
  inherited SaveState(SectionName, Ini);
end;

procedure TfdmUserEditor_MySQLForm.RestoreState(const SectionName: string;
  const Ini: TIniFile);
begin
  inherited RestoreState(SectionName, Ini);
end;

procedure TfdmUserEditor_MySQLForm.Localize;
begin
  inherited Localize;
  CheckGroup1.Items[0]:=sSelect;  //msuoSelectPriv,
  CheckGroup1.Items[1]:=sInsert;  //msuoInsertPriv,
  CheckGroup1.Items[2]:=sUpdate;  //msuoUpdatePriv,
  CheckGroup1.Items[3]:=sDelete;  //msuoDeletePriv,
  CheckGroup1.Items[4]:=sCreate;  //msuoCreatePriv,
  CheckGroup1.Items[5]:=sDropObject; //msuoDropPriv,
  CheckGroup1.Items[6]:=sReload; //msuoReloadPriv,
  CheckGroup1.Items[7]:=sShutdown; //msuoShutdownPriv,
  CheckGroup1.Items[8]:=sProcess; //msuoProcessPriv,
  CheckGroup1.Items[9]:=sFile; //msuoFilePriv,
  CheckGroup1.Items[10]:=sGrant; //msuoGrantPriv,
  CheckGroup1.Items[11]:=sReferences; //msuoReferencesPriv,
  CheckGroup1.Items[12]:=sIndex; //msuoIndexPriv,
  CheckGroup1.Items[13]:=sAlter; //msuoAlterPriv,
  CheckGroup1.Items[14]:=sShowDB; //msuoShowDBPriv,
  CheckGroup1.Items[15]:=sSuper; //msuoSuperPriv,
  CheckGroup1.Items[16]:=sCreateTmpTable; //msuoCreateTmpTablePriv,
  CheckGroup1.Items[17]:=sLockTables; //msuoLockTablesPriv,
  CheckGroup1.Items[18]:=sExecute; //msuoExecutePriv,
  CheckGroup1.Items[19]:=sReplSlave; //msuoReplSlavePriv,
  CheckGroup1.Items[20]:=sReplClient; //msuoReplClientPriv,
  CheckGroup1.Items[21]:=sCreateView; //msuoCreateViewPriv,
  CheckGroup1.Items[22]:=sShowView; //msuoShowViewPriv,
  CheckGroup1.Items[23]:=sCreateRoutine; //msuoCreateRoutinePriv,
  CheckGroup1.Items[24]:=sAlterRroutine; //msuoAlterRroutinePriv,
  CheckGroup1.Items[25]:=sCreateUser; //msuoCreateUserPriv,
  CheckGroup1.Items[26]:=sEvent; //msuoEventPriv,
  CheckGroup1.Items[27]:=sTrigger; //msuoTriggerPriv,
  CheckGroup1.Items[28]:=sCreateTablespace; //msuoCreateTablespacePriv

  Label5.Caption:=sMaxQueriesPerHour;
  Label6.Caption:=sMaxConnectionsPerHour;
  Label7.Caption:=sMaxUpdatePerHour;
  Label8.Caption:=sMaxUserConnections;

  CheckBox1.Caption:=sGrantAll;
  CheckBox2.Caption:=sWithGrantOptions;
end;

constructor TfdmUserEditor_MySQLForm.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  LoadUserData;
end;


function TfdmUserEditor_MySQLForm.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  FCreateUser:TMySQLCreateUser absolute ASQLObject;
  FFlush: TMySQLFlush;
  FGnt: TMySQLGrant;
  FGO:TObjectGrants;
begin
  Result:=false;
  if edtPassword.Text <> edtPasswordConfirm.Text then
  begin
    ErrorBox(sPasswordMismath);
    Exit;
  end;

  if DBObject.State = sdboCreate then
  begin
    if not (ASQLObject is TMySQLCreateUser) then Exit;
    FCreateUser.HostName:=edtHostName.Text;
    FCreateUser.Name:=edtUserName.Text;
    FCreateUser.Password:=edtPassword.Text;

    FCreateUser.MaxQueriesPerHour:=StrToIntDef(edtMaxQueriesPerHour.Text, 0);
    FCreateUser.MaxUpdatePerHour:=StrToIntDef(edtMaxUpdatePerHour.Text, 0);
    FCreateUser.MaxConnectionsPerHour:=StrToIntDef(edtMaxConnectionsPerHour.Text, 0);
    FCreateUser.MaxUserConnections:=StrToIntDef(edtMaxUserConnections.Text, 0);


    FGO:=[];
    if CheckBox1.Checked then
      FGO:=[ogAll]
    else
    begin
      if CheckGroup1.Checked[0] then FGO:=FGO + [ogSelect]; //msuoSelectPriv
      if CheckGroup1.Checked[1] then FGO:=FGO + [ogInsert]; //msuoInsertPriv
      if CheckGroup1.Checked[2] then FGO:=FGO + [ogUpdate]; //msuoUpdatePriv
      if CheckGroup1.Checked[3] then FGO:=FGO + [ogDelete]; //msuoDeletePriv
      if CheckGroup1.Checked[4] then FGO:=FGO + [ogCreate]; //msuoCreatePriv
      if CheckGroup1.Checked[5] then FGO:=FGO + [ogDrop]; //msuoDropPriv
      if CheckGroup1.Checked[6] then FGO:=FGO + [ogReload]; //msuoReloadPriv
      if CheckGroup1.Checked[7] then FGO:=FGO + [ogShutdown]; //msuoShutdownPriv
      if CheckGroup1.Checked[8] then FGO:=FGO + [ogProcess]; //msuoProcessPriv
      if CheckGroup1.Checked[9] then FGO:=FGO + [ogFile]; //msuoFilePriv
      if CheckGroup1.Checked[10] then FGO:=FGO + [ogWGO]; //msuoGrantPriv
      if CheckGroup1.Checked[11] then FGO:=FGO + [ogReference]; //msuoReferencesPriv
      if CheckGroup1.Checked[12] then FGO:=FGO + [ogIndex]; //msuoIndexPriv
      if CheckGroup1.Checked[13] then FGO:=FGO + [ogAlter]; //msuoAlterPriv
      if CheckGroup1.Checked[14] then FGO:=FGO + [ogShowDatabases]; //msuoShowDBPriv
      if CheckGroup1.Checked[15] then FGO:=FGO + [ogSuper]; //msuoSuperPriv
      if CheckGroup1.Checked[16] then FGO:=FGO + [ogTemporary]; //msuoCreateTmpTablePriv
      if CheckGroup1.Checked[17] then FGO:=FGO + [ogLockTables]; //msuoLockTablesPriv
      if CheckGroup1.Checked[18] then FGO:=FGO + [ogExecute]; //msuoExecutePriv
      if CheckGroup1.Checked[19] then FGO:=FGO + [ogReplicationSlave]; //msuoReplSlavePriv
      if CheckGroup1.Checked[20] then FGO:=FGO + [ogReplicationClient]; //msuoReplClientPriv
      if CheckGroup1.Checked[21] then FGO:=FGO + [ogCreateView]; //msuoCreateViewPriv
      if CheckGroup1.Checked[22] then FGO:=FGO + [ogShowView]; //msuoShowViewPriv
      if CheckGroup1.Checked[23] then FGO:=FGO + [ogCreateRoutine]; //msuoCreateRoutinePriv
      if CheckGroup1.Checked[24] then FGO:=FGO + [ogAlterRoutine]; //msuoAlterRroutinePriv
      if CheckGroup1.Checked[25] then FGO:=FGO + [ogCreateUser]; //msuoCreateUserPriv
      if CheckGroup1.Checked[26] then FGO:=FGO + [ogEvent]; //msuoEventPriv
      if CheckGroup1.Checked[27] then FGO:=FGO + [ogTrigger]; //msuoTriggerPriv
      if CheckGroup1.Checked[28] then FGO:=FGO + [ogCreateTablespace]; //msuoCreateTablespacePriv
    end;

    if FGO <> [] then
    begin
      if CheckBox2.Checked then
        FGO:=FGO + [ogWGO];

      FGnt:=TMySQLGrant.Create(FCreateUser);
      FGnt.Params.AddParamEx(edtUserName.Text, edtHostName.Text);
      FGnt.GrantTypes:=FGO;
      FGnt.Tables.Add('*.*', okNone);
      FCreateUser.AddChild(FGnt);
    end;

    FFlush:=TMySQLFlush.Create(FCreateUser);
    FFlush.Params.AddParam('PRIVILEGES');
    FCreateUser.AddChild(FFlush);
    Result:=true;
  end
  else
  begin
    Result:=inherited SetupSQLObject(ASQLObject);
  end;
end;

end.

