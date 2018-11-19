{ Free DB Manager

  Copyright (C) 2005-2018 Lagunov Aleksey  alexs75 at yandex.ru

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

unit MySQLTriggerHeaderEditUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, Spin, ExtCtrls, fdmAbstractEditorUnit, fdbm_SynEditorUnit,
  SQLEngineAbstractUnit, mysql_engine, SQLEngineCommonTypesUnit,
  fbmSqlParserUnit;

type

  { TMySQLTriggerHeaderEditor }

  TMySQLTriggerHeaderEditor = class(TEditorPage)
    CheckBox1: TCheckBox;
    CheckGroup1: TCheckGroup;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    edtTableName: TComboBox;
    edtTrgName: TEdit;
    edtType: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure edtTableNameChange(Sender: TObject);
    procedure edtTypeChange(Sender: TObject);
  private
    EditorFrame:Tfdbm_SynEditorFrame;
    procedure PrintPage;
    procedure LoadTriggerBody;
    procedure UpdateTriggerName;
    procedure OnGetFieldsList(Sender:Tfdbm_SynEditorFrame; const DBObjName:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);
    procedure SynGetKeyWordList(Sender:Tfdbm_SynEditorFrame; const KeyStartWord:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);
    function CommentCode:boolean;
    function UnCommentCode:boolean;
  protected
    procedure SetReadOnly(AValue: boolean);override;
  public
    procedure UpdateEnvOptions;override;
    procedure Localize;override;
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses LR_Class, IBManMainUnit, fbmStrConstUnit, mysql_SqlParserUnit, mysql_types,
  ibmSqlUtilsUnit, fbmToolsUnit, fb_ConstUnit;

{$R *.lfm}

(*const
  ssqlCreateTriggerBody =
      'begin' + LineEnding +
      '  /* Trigger text */' + LineEnding +
      'end';
*)
{ TMySQLTriggerHeaderEditor }

procedure TMySQLTriggerHeaderEditor.edtTableNameChange(Sender: TObject);
var
  FTable: TMySQLTable;
  i, j: Integer;
begin
  UpdateTriggerName;

  if CheckBox1.Visible then
  begin
    FTable:=TMySQLTable(DBObject.OwnerDB.DBObjectByName(edtTableName.Text));
    if Assigned(FTable) then
    begin
      ComboBox2.Items.Clear;
      for i:=0 to FTable.TriggersCategoriesCount-1 do
        for j:=0 to FTable.TriggersCount[i]-1 do
          if FTable.Trigger[i, j]<>DBObject then
            ComboBox2.Items.Add(FTable.Trigger[i, j].Caption);
    end;
  end;
end;

procedure TMySQLTriggerHeaderEditor.edtTypeChange(Sender: TObject);
begin
  UpdateTriggerName;
end;

procedure TMySQLTriggerHeaderEditor.PrintPage;
begin
  frVariables['DBClassTitle']:=DBObject.DBClassTitle;
  frVariables['ObjectName']:=edtTrgName.Text;
  frVariables['TriggerBody']:=EditorFrame.EditorText;
  fbManagerMainForm.LazReportPrint('DBObject_Trigger');
end;

procedure TMySQLTriggerHeaderEditor.LoadTriggerBody;
var
  S: String;
begin
  DBObject.OwnerDB.TablesRoot.FillListForNames(edtTableName.Items, false);

  if DBObject.State <> sdboCreate then
  begin
    edtTrgName.Text:=DBObject.Caption;
    S:=TrimLeft(TMySQLTriger(DBObject).TriggerBody);
{    if UpperCAse(Copy(S, 1, 2)) = 'AS' then
      S:=TrimLeft(Copy(S, 3, Length(S)));

    if TabSheet2.TabVisible then
      EditorFrame.EditorText:=ParseLocalVariable(S)
    else}
      EditorFrame.EditorText:=Trim(S);
  end
  else
  begin
    if Trim(EditorFrame.EditorText) = '' then
    begin
      EditorFrame.EditorText:=sMySqlCreateTriggerBodyNormal;
      CheckGroup1.Checked[0]:=true;
    end;

    UpdateTriggerName;
  end;

  edtTableName.Text:=TMySQLTriger(DBObject).TableName;
  edtTableNameChange(nil);
  edtType.ItemIndex:=ord(ttAfter in TMySQLTriger(DBObject).TriggerType);

  CheckGroup1.Checked[0]:=ttInsert in TMySQLTriger(DBObject).TriggerType;
  CheckGroup1.Checked[1]:=ttUpdate in TMySQLTriger(DBObject).TriggerType;
  CheckGroup1.Checked[2]:=ttDelete in TMySQLTriger(DBObject).TriggerType;

  edtTrgName.Enabled:=DBObject.State = sdboCreate;
end;

procedure TMySQLTriggerHeaderEditor.UpdateTriggerName;

function MakeTriggerName(ASuffix:integer):string;
begin
  Result:='';
  if CheckGroup1.Checked[0] then Result:=Result+'I';
  if CheckGroup1.Checked[1] then Result:=Result+'U';
  if CheckGroup1.Checked[2] then Result:=Result+'D';

  if edtType.ItemIndex = 0 then Result:=Result+'B'
  else Result:=Result+'A';

  //Result:=Result+IntToStr(edtOrder.Value);
  if ASuffix <> 0 then Result:=Result + '_'+IntToStr(ASuffix);
end;

var
  I: Integer;
  S: String;
begin
  if (DBObject.State <> sdboCreate) or (edtTableName.Text = '') then exit;

  I:=0;
  repeat
    S:=ConfigValues.ByNameAsString('ObjTemplate/MySQL/Trigger/Name', ssqlCreateTriggerName);
    S:=StringReplace(S, '%TABLE_NAME%', edtTableName.Text, [rfReplaceAll, rfIgnoreCase]);
    S:=StringReplace(S, '%TRIGGER_TYPE%', MakeTriggerName(I), [rfReplaceAll, rfIgnoreCase]);
      Inc(I);
  until not Assigned(TSQLEngineMySQL(DBObject.OwnerDB).TriggersRoot.ObjByName(S, false));
  edtTrgName.Text:=S;
end;

procedure TMySQLTriggerHeaderEditor.OnGetFieldsList(
  Sender: Tfdbm_SynEditorFrame; const DBObjName: string;
  const Items: TSynCompletionObjList; ACharCase: TCharCaseOptions);
var
  DBTable:TDBDataSetObject;
begin
  if (UpperCase(DBObjName) = 'OLD') or (UpperCase(DBObjName) = 'NEW') then
  begin
    if Assigned(DBObject.OwnerDB) then
    begin
      DBTable:=DBObject.OwnerDB.DBObjectByName(edtTableName.Text) as TDBDataSetObject;
      Items.FillFieldList(DBTable);
{      if Assigned(DBTable) then
        DBTable.FillFieldList(Items, ACharCase, False);}
    end;
  end;
end;

procedure TMySQLTriggerHeaderEditor.SynGetKeyWordList(
  Sender: Tfdbm_SynEditorFrame; const KeyStartWord: string;
  const Items: TSynCompletionObjList; ACharCase: TCharCaseOptions);
var
  SQLCommand:TMySQLCreateTrigger;
  i:integer;
  L, P:TLocalVariable;
//  LVP:TFBLocalVariableParser;
begin
{  if TabSheet2.TabVisible then
    VariableFrame.FillSynGetKeyWordList(KeyStartWord, Items)
  else
  begin
    LVP:=TFBLocalVariableParser.Create;
    try
      LVP.ParseLocalVarsEx(EditorFrame.EditorText);
      for i:=0 to LVP.Params.Count-1 do
      begin
        if (KeyStartWord = '') or
           (UpperCase(Copy(LVP.Params[i].Caption, 1, Length(KeyStartWord))) = KeyStartWord) then
        begin
          P:=TLocalVariable.CreateFrom(LVP.Params[i]);
          Items.Add(P.VarName);
          Items.Objects[Items.Count-1]:=P;
        end;
      end;
    finally
      LVP.Free;
    end;
  end;}
end;

function TMySQLTriggerHeaderEditor.CommentCode: boolean;
var
  S: String;
begin
  Result:=false;
  S:=EditorFrame.EditorText;
  if CommentSQLCode(S, sCommentIBEStyle) then
  begin
    EditorFrame.EditorText:=S;
    Result:=true;
  end;
end;

function TMySQLTriggerHeaderEditor.UnCommentCode: boolean;
var
  S: String;
begin
  Result:=false;
  S:=EditorFrame.EditorText;
  if UnCommentSQLCode(S) then
  begin
    EditorFrame.EditorText:=S;
    Result:=true;
  end;
end;

procedure TMySQLTriggerHeaderEditor.SetReadOnly(AValue: boolean);
begin
  inherited SetReadOnly(AValue);
  edtTableName.Enabled:=not AValue;
  edtTrgName.Enabled:=not AValue;
  edtType.Enabled:=not AValue;
  CheckGroup1.Enabled:=not AValue;
end;

procedure TMySQLTriggerHeaderEditor.UpdateEnvOptions;
begin
  EditorFrame.ChangeVisualParams;
end;

procedure TMySQLTriggerHeaderEditor.Localize;
begin
  inherited Localize;
  Label1.Caption:=sDefiner;
  Label2.Caption:=sTriggerType;
  Label3.Caption:=sTriggerName;
  Label4.Caption:=sTableName;
  CheckBox1.Caption:=sTriggerOrder;
  CheckGroup1.Items[0]:=sTriggerOnInsert;
  CheckGroup1.Items[1]:=sTriggerOnUpdate;
  CheckGroup1.Items[2]:=sTriggerOnDelete;

  edtType.Items[0]:=sBefore;
  edtType.Items[1]:=sAfter;

  TabSheet1.Caption:=sDeclaration;
  TabSheet2.Caption:=sLocalVariables;
end;

function TMySQLTriggerHeaderEditor.PageName: string;
begin
  Result:=sTrigger;
end;

constructor TMySQLTriggerHeaderEditor.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  PageControl1.ActivePageIndex:=0;


  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=Self;
  EditorFrame.OnGetFieldsList:=@OnGetFieldsList;
  EditorFrame.OnGetKeyWordList:=@SynGetKeyWordList;

  TabSheet2.TabVisible:=DBObject.OwnerDB.TriggerEditLazzyMode;

  EditorFrame.SQLEngine:=DBObject.OwnerDB;

  ComboBox3.Visible:=TSQLEngineMySQL(DBObject.OwnerDB).ServerVersion in [myVersion5_5, myVersion5_7];
  Label1.Visible:=TSQLEngineMySQL(DBObject.OwnerDB).ServerVersion in [myVersion5_5, myVersion5_7];
  CheckBox1.Visible:=TSQLEngineMySQL(DBObject.OwnerDB).ServerVersion in [myVersion5_5, myVersion5_7];
  ComboBox1.Visible:=TSQLEngineMySQL(DBObject.OwnerDB).ServerVersion in [myVersion5_5, myVersion5_7];
  ComboBox2.Visible:=TSQLEngineMySQL(DBObject.OwnerDB).ServerVersion in [myVersion5_5, myVersion5_7];

  LoadTriggerBody;

  edtTableName.OnChange:=@edtTableNameChange;
  edtType.OnChange:=@edtTypeChange;
  CheckGroup1.OnClick:=@edtTypeChange;
end;
{
function TMySQLTriggerHeaderEditor.TriggerType: TTriggerTypes;
begin
  if edtType.ItemIndex >0 then
    Result:=[ttBefore]
  else
    Result:=[ttAfter];

  if CheckGroup1.Checked[0] then
    Result:=Result + [ttInsert];

  if CheckGroup1.Checked[1] then
    Result:=Result + [ttUpdate];

  if CheckGroup1.Checked[2] then
    Result:=Result + [ttDelete];
end;
}
function TMySQLTriggerHeaderEditor.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaCompile, epaPrint, epaRefresh, epaComment, epaUnComment];
end;

function TMySQLTriggerHeaderEditor.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:PrintPage;
    epaRefresh:LoadTriggerBody;
    epaComment:Result:=CommentCode;
    epaUnComment:Result:=UnCommentCode;
  end;
end;

function TMySQLTriggerHeaderEditor.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  Rec: TMySQLCreateTrigger;
begin
  Result:=false;
  if not (ASQLObject is TMySQLCreateTrigger) then exit;

  Rec:=ASQLObject as TMySQLCreateTrigger;
  Rec.Name:=edtTrgName.Text;
  Rec.TableName:=edtTableName.Text;

  if DBObject.State = sdboEdit then
    Rec.CreateMode := cmCreateOrAlter;

  Rec.TriggerType:=[];

  if CheckGroup1.Checked[0] then
    Rec.TriggerType:=Rec.TriggerType + [ttInsert];

  if CheckGroup1.Checked[1] then
    Rec.TriggerType:=Rec.TriggerType + [ttUpdate];

  if CheckGroup1.Checked[2] then
    Rec.TriggerType:= Rec.TriggerType + [ttDelete];

  if Rec.TriggerType = [] then
  begin
    InfoBox(sPrecompileError);
    exit;
  end;

  if edtType.ItemIndex = 1 then
    Rec.TriggerType:=Rec.TriggerType + [ttAfter]
  else
    Rec.TriggerType:=Rec.TriggerType + [ttBefore];

  if TSQLEngineMySQL(DBObject.OwnerDB).ServerVersion in [myVersion5_5, myVersion5_7] then
  begin
    Rec.Definer:=ComboBox3.Text;
    if CheckBox1.Checked then
    begin
      if ComboBox1.ItemIndex = 0 then
        Rec.TriggerOrder:=ttBefore
      else
        Rec.TriggerOrder:=ttAfter;
      Rec.TriggerOrderName:=ComboBox2.Text;
    end;
  end;

  Rec.Body:=EditorFrame.EditorText;
  Result:=true;
end;

end.

