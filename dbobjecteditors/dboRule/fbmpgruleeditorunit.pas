{ Free DB Manager

  Copyright (C) 2005-2021 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fbmPGRuleEditorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, StdCtrls, fdmAbstractEditorUnit, fdbm_SynEditorUnit, fbmToolsUnit,
  SQLEngineCommonTypesUnit, PostgreSQLEngineUnit, SQLEngineAbstractUnit,
  fbmSqlParserUnit;

type

  { TPGRuleEditorPage }

  TPGRuleEditorPage = class(TEditorPage)
    CheckBox1: TCheckBox;
    cbTables: TComboBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    RadioGroup1: TRadioGroup;
    procedure CheckBox2Change(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    EditorFrame:Tfdbm_SynEditorFrame;
    edtWhenFrame:Tfdbm_SynEditorFrame;
    procedure OnGetFieldsList(Sender:Tfdbm_SynEditorFrame; const DBObjName:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);
    procedure OnGetKeyWordList(Sender:Tfdbm_SynEditorFrame; const KeyStartWord:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);
    procedure RefreshObject;
    procedure DoRefresh;
    procedure PrintPage;
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation

uses fbmStrConstUnit, pgTypes, pg_SqlParserUnit, math;

{$R *.lfm}

{ TPGRuleEditorPage }

procedure TPGRuleEditorPage.CheckBox2Change(Sender: TObject);
begin
  Label2.Enabled:=not CheckBox2.Checked;
  EditorFrame.Enabled:=not CheckBox2.Checked;
end;

procedure TPGRuleEditorPage.RadioGroup1Click(Sender: TObject);
var
  S, S1:string;
  T:TDBDataSetObject;
  i:integer;
begin
  if (TPGRule(DBObject).State <> sdboEdit) and (not Edit1.Modified) then
  begin
    T:=TPGRule(DBObject).RelObject;
    S:='rul_';
    if Assigned(T) then
      S:=S+T.Caption;
    if CheckBox1.Checked then
      S:=S+'_i'
    else
      S:=S+'__';
    i:=Min(Max(RadioGroup1.ItemIndex, 0), 3);

    S:=S+LowerCase(Copy(RuleActionStr[TPGRuleAction(i)], 1, 3));

    i:=1;
    repeat
      S1:=S+'_'+IntToStr(i);
      inc(i);
    until not Assigned(TPGRule(DBObject).Schema.RulesRoot.ObjByName(S1));

    Edit1.Text:=S1;
    Edit1.Modified:=false;
  end;
end;

procedure TPGRuleEditorPage.OnGetFieldsList(Sender: Tfdbm_SynEditorFrame;
  const DBObjName: string; const Items: TSynCompletionObjList;
  ACharCase: TCharCaseOptions);
var
  T:TDBDataSetObject;
begin
  if (UpperCase(DBObjName) = 'OLD') or (UpperCase(DBObjName) = 'NEW') then
  begin
    if (cbTables.ItemIndex>-1) and (cbTables.ItemIndex<cbTables.Items.Count) then
    begin
      T:=TDBDataSetObject(cbTables.Items.Objects[cbTables.ItemIndex]);
      Items.FillFieldList(T);
    end;
{    if Assigned(T) then
      T.FillFieldList(Items, ACharCase, False);}
  end;
end;

procedure TPGRuleEditorPage.OnGetKeyWordList(Sender: Tfdbm_SynEditorFrame;
  const KeyStartWord: string; const Items: TSynCompletionObjList;
  ACharCase: TCharCaseOptions);
{var
  i,j:integer;
  P:TLocalVariable;
  SQLCommand:TPGSQLCreateProc;}
begin
{  SQLCommand:=TPGSQLCreateProc(SQLParseCommand(GetProcText, TPGSQLCreateProc, FDBTrigger.OwnerDB));
  if Assigned(SQLCommand) then
  begin
    for i:=0 to SQLCommand.ParamsCount - 1 do
    begin
      P:=TLocalVariable.CreateFrom(SQLCommand.Params[i]);
      Items.Add(P.VarName);
      Items.Objects[Items.Count-1]:=P;
    end;
    SQLCommand.Free;
  end;

  for i:= 0 to CountKeyTriggers-1 do
  begin
    if KeyStartWord = '' then
      j:=Items.Add(PGTriggerVars[i].VarName)
    else
    if UpperCase(Copy(PGTriggerVars[i].VarName, 1, Length(KeyStartWord))) = KeyStartWord then
      j:=Items.Add(PGTriggerVars[i].VarName)
    else
      j:=-1;

    if j>-1 then
    begin
      P:=TLocalVariable.Create(PGTriggerVars[i].VarName, PGTriggerVars[i].VarType, PGTriggerVars[i].VarDesc, spvtLocal);
      Items.Objects[j]:=P;
    end;
  end;}
end;

procedure TPGRuleEditorPage.RefreshObject;
var
  T:TPGView;
  T1:TPGTable;
  i:integer;
begin
  RadioGroup1.ItemIndex:=Ord(TPGRule(DBObject).RuleAction);

  cbTables.Clear;
  for i:=0 to TPGRule(DBObject).Schema.Views.CountObject - 1 do
  begin
    T:=TPGView(TPGRule(DBObject).Schema.Views.Items[i]);
    cbTables.Items.Add(T.CaptionFullPatch);
    cbTables.Items.Objects[cbTables.Items.Count - 1]:=T;
    if TPGRule(DBObject).RelID = T.OID then
      cbTables.ItemIndex:=cbTables.Items.Count - 1;
  end;

  for i:=0 to TPGRule(DBObject).Schema.TablesRoot.CountObject - 1 do
  begin
    T1:=TPGTable(TPGRule(DBObject).Schema.TablesRoot.Items[i]);
    cbTables.Items.Add(T1.CaptionFullPatch);
    cbTables.Items.Objects[cbTables.Items.Count - 1]:=T1;
    if TPGRule(DBObject).RelID = T1.OID then
      cbTables.ItemIndex:=cbTables.Items.Count - 1;
  end;

  EditorFrame.EditorText:=TPGRule(DBObject).RuleSQL;
  edtWhenFrame.EditorText:=TPGRule(DBObject).RuleWhere;
  CheckBox1.Checked:=TPGRule(DBObject).RuleWork = rwINSTEAD;
  CheckBox2.Checked:=TPGRule(DBObject).RuleNothing;

  if TPGRule(DBObject).State = sdboCreate then
    RadioGroup1Click(nil)
  else
    Edit1.Text:=TPGRule(DBObject).Caption;
end;

procedure TPGRuleEditorPage.DoRefresh;
begin
  TPGRule(DBObject).RefreshObject;
  RefreshObject;
end;

procedure TPGRuleEditorPage.PrintPage;
begin

end;

function TPGRuleEditorPage.PageName: string;
begin
  Result:=sRule;
end;

constructor TPGRuleEditorPage.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);

  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=Self;
  EditorFrame.SQLEngine:=DBObject.OwnerDB;
  EditorFrame.OnGetFieldsList:=@OnGetFieldsList;
  EditorFrame.OnGetKeyWordList:=@OnGetKeyWordList;
  EditorFrame.Name:='EditorFrame';

  edtWhenFrame:=Tfdbm_SynEditorFrame.Create(Self);
  edtWhenFrame.Parent:=Panel2;
  edtWhenFrame.SQLEngine:=DBObject.OwnerDB;
  edtWhenFrame.OnGetFieldsList:=@OnGetFieldsList;
  edtWhenFrame.Name:='edtWhenFrame';
  //edtWhereFrame.OnGetKeyWordList:=@OnGetKeyWordList;

  RefreshObject;
  Edit1.Enabled:=DBObject.State = sdboCreate;
end;

function TPGRuleEditorPage.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaPrint, epaRefresh, epaCompile];
end;

function TPGRuleEditorPage.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  Result:=true;
  case PageAction of
    epaRefresh:DoRefresh;
    epaPrint:PrintPage;
  else
    Result:=false;
  end;
end;

procedure TPGRuleEditorPage.Localize;
begin
  inherited Localize;
  Label1.Caption:=sRuleName;
  Label3.Caption:=sRelationName;
  Label2.Caption:=sConditions;

  CheckBox1.Caption:=sINSTEAD;
  CheckBox2.Caption:=sNOTHING;
  RadioGroup1.Caption:=sRuleEvent;
end;

function TPGRuleEditorPage.SetupSQLObject(ASQLObject: TSQLCommandDDL): boolean;
begin
  Result:=false;
  if not (ASQLObject is TPGSQLCreateRule) then exit;

  TPGSQLCreateRule(ASQLObject).Name:=Edit1.Text;
  TPGSQLCreateRule(ASQLObject).TableName:=TPGTable(cbTables.Items.Objects[cbTables.ItemIndex]).CaptionFullPatch;
  TPGSQLCreateRule(ASQLObject).RuleAction:=TPGRuleAction(RadioGroup1.ItemIndex);
  if CheckBox1.Checked then
    TPGSQLCreateRule(ASQLObject).RuleWork:=rwINSTEAD
  else
    TPGSQLCreateRule(ASQLObject).RuleWork:=rwALSO;
  TPGSQLCreateRule(ASQLObject).SQLRuleWhere:=edtWhenFrame.EditorText;
  TPGSQLCreateRule(ASQLObject).RuleNothing:=CheckBox2.Checked;
  if not CheckBox2.Checked then
    TPGSQLCreateRule(ASQLObject).RuleSQL:=EditorFrame.EditorText;

  Result:=true;
end;

end.

