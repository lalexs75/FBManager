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
unit SQLite3TriggerHeaderEditUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls, Buttons, fdmAbstractEditorUnit, fdbm_SynEditorUnit,
  SQLEngineCommonTypesUnit, sqlObjects, SQLEngineAbstractUnit, fbmSqlParserUnit;

type

  { TSQLite3TriggerHeaderEditFrame }

  TSQLite3TriggerHeaderEditFrame = class(TEditorPage)
    cbOnEvent: TCheckGroup;
    CheckBox1: TCheckBox;
    edtTableName: TComboBox;
    edtTrgName: TEdit;
    edtType: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    PageControl1: TPageControl;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure cbOnEventItemClick(Sender: TObject; Index: integer);
    procedure edtOrderChange(Sender: TObject);
  private
    edtWhenFrame:Tfdbm_SynEditorFrame;
    EditorFrame:Tfdbm_SynEditorFrame;
    procedure PrintPage;
    procedure LoadTriggerBody;
    procedure LoadTriggerFields;
    procedure OnGetFieldsList(Sender:Tfdbm_SynEditorFrame; const DBObjName:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);
    procedure SynGetKeyWordList(Sender:Tfdbm_SynEditorFrame; const KeyStartWord:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);
  protected
    procedure SetReadOnly(AValue: boolean);override;
    function CommentCode:boolean;
    function UnCommentCode:boolean;
    procedure UpdateFieldButtons;
  public
    procedure UpdateEnvOptions;override;
    procedure Localize;override;
    function PageName:string;override;
    procedure Activate;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function TriggerType:TTriggerTypes;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses rxAppUtils, LR_Class, IBManMainUnit, SQLite3EngineUnit, sqlite3_SqlParserUnit,
  ibmSqlUtilsUnit, fb_ConstUnit, fbmStrConstUnit, fbmToolsUnit;

{$R *.lfm}
const
  ssqlCreateTriggerBody =
      'begin' + LineEnding +
      '  /* Trigger text */' + LineEnding +
      'end';

{ TSQLite3TriggerHeaderEditFrame }

procedure TSQLite3TriggerHeaderEditFrame.edtOrderChange(Sender: TObject);
var
  S, S1:String;
  i: Integer;
begin
  S:=edtTableName.Text;
  if (DBObject.State = sdboCreate) and (S<>'') then
  begin
    S:='';
    case edtType.ItemIndex of
      0:S:='b';
      1:S:='a';
      2:S:='io'
    end;

    if CheckBox1.Checked then
      S:=S+'r';

    if  cbOnEvent.Checked[0] then
      S:=S+'i';
    if  cbOnEvent.Checked[1] then
      S:=S+'u';
    if  cbOnEvent.Checked[2] then
      S:=S+'d';

    S:=edtTableName.Text+'_'+S + '_%d';
    i:=0;
    repeat
      inc(i);
      S1:=Format(S, [i]);
    until not Assigned(DBObject.OwnerDB.DBObjectByName(S1));
    edtTrgName.Text:=S1;
  end;
end;

procedure TSQLite3TriggerHeaderEditFrame.cbOnEventItemClick(Sender: TObject;
  Index: integer);
begin
  edtOrderChange(nil);
end;

procedure TSQLite3TriggerHeaderEditFrame.PrintPage;
begin
  frVariables['DBClassTitle']:=DBObject.DBClassTitle;
  frVariables['ObjectName']:=edtTrgName.Text;
  frVariables['TriggerBody']:=EditorFrame.EditorText;
  fbManagerMainForm.LazReportPrint('DBObject_Trigger');
end;

procedure TSQLite3TriggerHeaderEditFrame.LoadTriggerBody;
begin
  edtTableName.Items.Clear;
  DBObject.OwnerDB.FillListForNames(edtTableName.Items, [okTable, okView]);
  if DBObject.State <> sdboCreate then
  begin
    edtTrgName.Text:=DBObject.Caption;
    EditorFrame.EditorText:=TSQLite3Triger(DBObject).TriggerBody;
  end
  else
  begin
    if Trim(EditorFrame.EditorText) = '' then
      EditorFrame.EditorText:=ssqlCreateTriggerBody;
  end;

  edtTableName.Text:=TDBTriggerObject(DBObject).TableName;
  if ttBefore in TDBTriggerObject(DBObject).TriggerType then
    edtType.ItemIndex:=0
  else
  if ttAfter in TDBTriggerObject(DBObject).TriggerType then
    edtType.ItemIndex:=1
  else
  if ttInsteadOf in TDBTriggerObject(DBObject).TriggerType then
    edtType.ItemIndex:=2;

  cbOnEvent.Checked[0]:= ttInsert in TDBTriggerObject(DBObject).TriggerType;
  cbOnEvent.Checked[1]:= ttUpdate in TDBTriggerObject(DBObject).TriggerType;
  cbOnEvent.Checked[2]:= ttDelete in TDBTriggerObject(DBObject).TriggerType;


  CheckBox1.Checked:=ttRow in TDBTriggerObject(DBObject).TriggerType;

  edtTrgName.Enabled:=DBObject.State = sdboCreate;

  if TSQLite3Triger(DBObject).TriggerWhen<>'' then
  begin
    edtWhenFrame.EditorText:=TSQLite3Triger(DBObject).TriggerWhen;
    edtWhenFrame.Modified:=false;
    TabSheet3.Caption:=sConditions+' (*)';
  end
  else
    TabSheet3.Caption:=sConditions;

  if (DBObject.State = sdboCreate) and (edtTrgName.Text = '') then
    edtOrderChange(nil);
end;

procedure TSQLite3TriggerHeaderEditFrame.LoadTriggerFields;
var
  i:integer;
begin
  ListBox1.Items.Clear;
  if Assigned(DBObject) and Assigned(TDBTriggerObject(DBObject).TriggerTable) then
  begin
    for i:=0 to TDBTriggerObject(DBObject).TriggerTable.Fields.Count-1 do
    begin
      if TSQLite3Triger(DBObject).UpdateFields.IndexOf(TSQLite3Triger(DBObject).TriggerTable.Fields[i].FieldName) < 0 then
        ListBox1.Items.Add(TSQLite3Triger(DBObject).TriggerTable.Fields[i].FieldName);
    end;
    ListBox2.Items.Assign(TSQLite3Triger(DBObject).UpdateFields);
  end;
  UpdateFieldButtons;
end;

procedure TSQLite3TriggerHeaderEditFrame.OnGetFieldsList(
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

procedure TSQLite3TriggerHeaderEditFrame.SynGetKeyWordList(
  Sender: Tfdbm_SynEditorFrame; const KeyStartWord: string;
  const Items: TSynCompletionObjList; ACharCase: TCharCaseOptions);
begin
{    LVP:=TFBLocalVariableParser.Create(DBObject.OwnerDB);
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

procedure TSQLite3TriggerHeaderEditFrame.SetReadOnly(AValue: boolean);
begin
  inherited SetReadOnly(AValue);
  edtTableName.Enabled:=not AValue;
  edtTrgName.Enabled:=not AValue;
  edtType.Enabled:=not AValue;
  PageControl1.Enabled:=false;
  EditorFrame.ReadOnly:=true;
end;

function TSQLite3TriggerHeaderEditFrame.CommentCode: boolean;
var
  S: String;
begin
  Result:=false;
  S:=EditorFrame.EditorText;
  if CommentSQLCode(S, sCommentFBMStyle) then
  begin
    EditorFrame.EditorText:=S;
    Result:=true;
  end;
end;

function TSQLite3TriggerHeaderEditFrame.UnCommentCode: boolean;
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

procedure TSQLite3TriggerHeaderEditFrame.UpdateFieldButtons;
begin
 SpeedButton1.Enabled:=ListBox1.Items.Count>0;
 SpeedButton2.Enabled:=ListBox2.Items.Count>0;

 SpeedButton3.Enabled:=(ListBox2.Items.Count>1) and (ListBox2.ItemIndex>0);
 SpeedButton4.Enabled:=(ListBox2.Items.Count>1) and (ListBox2.ItemIndex<ListBox2.Items.Count-1);
end;

procedure TSQLite3TriggerHeaderEditFrame.UpdateEnvOptions;
begin
  EditorFrame.ChangeVisualParams;
end;

procedure TSQLite3TriggerHeaderEditFrame.Localize;
begin
  inherited Localize;
  Label3.Caption:=sTriggerName;
  Label4.Caption:=sTableName;
  Label2.Caption:=sTriggerType;
  cbOnEvent.Items[0]:=sInsert;
  cbOnEvent.Items[1]:=sUpdate;
  cbOnEvent.Items[2]:=sDelete;
  CheckBox1.Caption:=sForEachRow;
end;

function TSQLite3TriggerHeaderEditFrame.PageName: string;
begin
  Result:=sTrigger;
end;

procedure TSQLite3TriggerHeaderEditFrame.Activate;
begin
  inherited Activate;
end;

constructor TSQLite3TriggerHeaderEditFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);

  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=Self;
  EditorFrame.OnGetFieldsList:=@OnGetFieldsList;
  EditorFrame.OnGetKeyWordList:=@SynGetKeyWordList;
  EditorFrame.Name:='EditorFrame';

  edtWhenFrame:=Tfdbm_SynEditorFrame.Create(Self);
  edtWhenFrame.Parent:=TabSheet3;
  edtWhenFrame.SQLEngine:=DBObject.OwnerDB;
  edtWhenFrame.OnGetFieldsList:=@OnGetFieldsList;
  edtWhenFrame.Name:='edtWhenFrame';

  EditorFrame.SQLEngine:=DBObject.OwnerDB;

  LoadTriggerBody;
end;

function TSQLite3TriggerHeaderEditFrame.TriggerType: TTriggerTypes;
begin
  case edtType.ItemIndex of
    0:Result:=[ttBefore];
    1:Result:=[ttAfter];
    2:Result:=[ttInsteadOf]
  end;


  if cbOnEvent.Checked[0] then
    Result:=Result + [ttInsert];

  if cbOnEvent.Checked[1] then
    Result:=Result + [ttUpdate];

  if cbOnEvent.Checked[2] then
    Result:=Result + [ttDelete];
end;

function TSQLite3TriggerHeaderEditFrame.ActionEnabled(
  PageAction: TEditorPageAction): boolean;
begin
  Result:=PageAction in [epaCompile, epaPrint, epaRefresh, epaComment, epaUnComment];
end;

function TSQLite3TriggerHeaderEditFrame.DoMetod(PageAction: TEditorPageAction
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

function TSQLite3TriggerHeaderEditFrame.SetupSQLObject(
  ASQLObject: TSQLCommandDDL): boolean;
var
  Rec: TSQLite3SQLCreateTrigger;
begin
  Result:=false;
  Rec:=ASQLObject as TSQLite3SQLCreateTrigger;
  Rec.Name:=edtTrgName.Text;
  Rec.TableName:=edtTableName.Text;
  if DBObject.State = sdboEdit then
    Rec.CreateMode:=cmDropAndCreate;

  Rec.TriggerType:=TriggerType;
  Rec.Body:=EditorFrame.EditorText;

  if Rec.TriggerType = [] then
    InfoBox(sPrecompileError)
  else
   Result:=true;
end;

end.

