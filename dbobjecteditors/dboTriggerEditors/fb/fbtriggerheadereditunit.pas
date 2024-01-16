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

unit fbTriggerHeaderEditUnit;

{$I fbmanager_define.inc}


interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, fdmAbstractEditorUnit,
  SQLEngineAbstractUnit, ExtCtrls, StdCtrls, Spin, SynEdit, LMessages, Controls,
  SQLEngineCommonTypesUnit, fbmSqlParserUnit, Grids, ComCtrls, Menus,
  sqlObjects, fbmToolsUnit, fdbm_SynEditorUnit, fbmFBVariableFrameUnit,
  FBSQLEngineUnit;

type

  { TfbTriggerHeaderEditFrame }

  TfbTriggerHeaderEditFrame = class(TEditorPage)
    cbActive: TCheckBox;
    cbOnInsert: TCheckBox;
    cbOnUpdate: TCheckBox;
    cbOnDelete: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    edtType: TComboBox;
    edtTableName: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    edtTrgName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    PageControl1: TPageControl;
    Panel3: TPanel;
    edtOrder: TSpinEdit;
    Splitter1: TSplitter;
    TabSheet1: TTabSheet;
    tabLocalVar: TTabSheet;
    procedure edtOrderChange(Sender: TObject);
  private
    EditorFrame:Tfdbm_SynEditorFrame;
    procedure PrintPage;
    procedure LoadTriggerBody;
    procedure OnGetFieldsList(Sender:Tfdbm_SynEditorFrame; const DBObjName:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);
    procedure SynGetKeyWordList(Sender:Tfdbm_SynEditorFrame; const KeyStartWord:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);
  protected
    VariableFrame:TfbmFBVariableFrame;
    FMenuDefineVariable: TMenuItem;
    procedure SetReadOnly(AValue: boolean);override;
    function CommentCode:boolean;
    function UnCommentCode:boolean;

    procedure DefinePopupMenu;
    procedure DoTextEditorDefineVariable(Sender: TObject);
    procedure TextEditorPopUpMenu(Sender: TObject);
    procedure TextEditorChange(Sender: TObject);

    function ParseLocalVariable(SqlLine:String):string;
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
uses rxAppUtils, fbmStrConstUnit, ibmanagertypesunit, LR_Class, IBManMainUnit, fb_SqlParserUnit,
  ibmSqlUtilsUnit, fb_ConstUnit;

{$R *.lfm}

{ TfbTriggerHeaderEditFrame }

procedure TfbTriggerHeaderEditFrame.edtOrderChange(Sender: TObject);

function MakeTriggerName(ASuffix:integer):string;
begin
  Result:='';
  if cbOnInsert.Checked then Result:=Result+'I';
  if cbOnUpdate.Checked then Result:=Result+'U';
  if cbOnDelete.Checked then Result:=Result+'D';

  if edtType.ItemIndex = 0 then Result:=Result+'B'
  else Result:=Result+'A';

  Result:=Result+IntToStr(edtOrder.Value);
  if ASuffix <> 0 then Result:=Result + '_'+IntToStr(ASuffix);
end;

var
  S:String;
  I: Integer;
begin
  if (DBObject.State = sdboCreate) and (edtTableName.Text<>'') then
  begin
    I:=0;
    repeat
      S:=ConfigValues.ByNameAsString('ObjTemplate/FireBirdSQL/Trigger/Name', ssqlCreateTriggerName);
      S:=StringReplace(S, '%TABLE_NAME%', edtTableName.Text, [rfReplaceAll, rfIgnoreCase]);
      S:=StringReplace(S, '%TRIGGER_TYPE%', MakeTriggerName(I), [rfReplaceAll, rfIgnoreCase]);
      Inc(I);
    until not Assigned(TSQLEngineFireBird(DBObject.OwnerDB).TriggersRoot.ObjByName(S, false));
    edtTrgName.Text:=S;
  end;
end;

procedure TfbTriggerHeaderEditFrame.PrintPage;
begin
  frVariables['DBClassTitle']:=DBObject.DBClassTitle;
  frVariables['ObjectName']:=edtTrgName.Text;
  frVariables['TriggerBody']:=EditorFrame.EditorText;
  fbManagerMainForm.LazReportPrint('DBObject_Trigger');
end;

procedure TfbTriggerHeaderEditFrame.LoadTriggerBody;
var
  S: String;
begin
  DBObject.OwnerDB.TablesRoot.FillListForNames(edtTableName.Items, false);

  if DBObject.State <> sdboCreate then
  begin
    edtTrgName.Text:=DBObject.Caption;
    edtOrder.Value:=TFireBirdTriger(DBObject).Sequence;
    S:=TrimLeft(TFireBirdTriger(DBObject).TriggerBody);
    if CompareText(Copy(S, 1, 2), 'AS')=0 then
      S:=TrimLeft(Copy(S, 3, Length(S)));

    if tabLocalVar.TabVisible then
      EditorFrame.EditorText:=ParseLocalVariable(S)
    else
      EditorFrame.EditorText:=Trim(S);
  end
  else
  begin
    if Trim(EditorFrame.EditorText) = '' then
    begin
      if tabLocalVar.TabVisible then
        EditorFrame.EditorText:=ConfigValues.ByNameAsString('ObjTemplate/FireBirdSQL/Trigger/Lazy', ssqlCreateTriggerBodyLazy)
      else
        EditorFrame.EditorText:=ConfigValues.ByNameAsString('ObjTemplate/FireBirdSQL/Trigger/Normal', ssqlCreateTriggerBodyNormal);
      cbActive.Checked:=true;
      cbOnInsert.Checked:=true;
    end;
  end;

  edtTableName.Text:=TFireBirdTriger(DBObject).TableName;
  cbActive.Checked:=TFireBirdTriger(DBObject).Active;
  edtType.ItemIndex:=ord(ttAfter in TFireBirdTriger(DBObject).TriggerType);

  cbOnInsert.Checked:=ttInsert in TFireBirdTriger(DBObject).TriggerType;
  cbOnUpdate.Checked:=ttUpdate in TFireBirdTriger(DBObject).TriggerType;
  cbOnDelete.Checked:=ttDelete in TFireBirdTriger(DBObject).TriggerType;

  edtTrgName.Enabled:=DBObject.State = sdboCreate;
end;

procedure TfbTriggerHeaderEditFrame.OnGetFieldsList(
  Sender: Tfdbm_SynEditorFrame; const DBObjName: string;
  const Items: TSynCompletionObjList; ACharCase: TCharCaseOptions);
var
  DBTable:TDBDataSetObject;
begin
  if (CompareText(DBObjName, 'OLD')=0) or (CompareText(DBObjName, 'NEW')=0) then
  begin
    if Assigned(DBObject.OwnerDB) then
    begin
      DBTable:=DBObject.OwnerDB.DBObjectByName(edtTableName.Text) as TDBDataSetObject;
      Items.FillFieldList(DBTable);
{
      if Assigned(DBTable) then
        DBTable.FillFieldList(Items, ACharCase, False);}
    end;
  end;
end;

procedure TfbTriggerHeaderEditFrame.SetReadOnly(AValue: boolean);
begin
  inherited SetReadOnly(AValue);
  edtOrder.Enabled:=not AValue;
  edtTableName.Enabled:=not AValue;
  edtTrgName.Enabled:=not AValue;
  edtType.Enabled:=not AValue;
  cbActive.Enabled:=not AValue;
  cbOnDelete.Enabled:=not AValue;
  cbOnUpdate.Enabled:=not AValue;
  cbOnInsert.Enabled:=not AValue;
end;

function TfbTriggerHeaderEditFrame.CommentCode: boolean;
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

function TfbTriggerHeaderEditFrame.UnCommentCode: boolean;
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

procedure TfbTriggerHeaderEditFrame.DefinePopupMenu;
begin
  FMenuDefineVariable:=EditorFrame.CreateCTMenuItem(sDefineVariable, @DoTextEditorDefineVariable, 1);
end;

procedure TfbTriggerHeaderEditFrame.DoTextEditorDefineVariable(Sender: TObject);
var
  S: String;
begin
  S:=Trim(EditorFrame.TextEditor.SelText);
  if tabLocalVar.TabVisible and (S<>'') and IsValidIdent(S) then
  begin
    if (Sender as TComponent).Tag = 1 then
    begin
      VariableFrame.AddVariable(S);
      PageControl1.ActivePage:=tabLocalVar;
    end
  end;
end;

procedure TfbTriggerHeaderEditFrame.TextEditorPopUpMenu(Sender: TObject);
var
  S: String;
begin
  S:=Trim(EditorFrame.TextEditor.SelText);
  FMenuDefineVariable.Enabled:=tabLocalVar.TabVisible and (S<>'') and IsValidIdent(S);
end;

procedure TfbTriggerHeaderEditFrame.TextEditorChange(Sender: TObject);
begin
  Modified:=true;
end;

function TfbTriggerHeaderEditFrame.ParseLocalVariable(SqlLine: String): string;
var
  LVP:TFBLocalVariableParser;
  K, i: Integer;
  P: TSQLParserField;
begin
  LVP:=TFBLocalVariableParser.Create(nil);
  K:=LVP.ParseLocalVarsEx(SqlLine);
  Result:=Copy(SqlLine, K, Length(SqlLine));
  VariableFrame.LoadParams(LVP.Params);
  LVP.Free;
end;

procedure TfbTriggerHeaderEditFrame.SynGetKeyWordList(
  Sender: Tfdbm_SynEditorFrame; const KeyStartWord: string;
  const Items: TSynCompletionObjList; ACharCase: TCharCaseOptions);
var
  SQLCommand:TFBSQLCreateTrigger;
  LVP:TFBLocalVariableParser;
  F: TSQLParserField;
begin
  if tabLocalVar.TabVisible then
    VariableFrame.FillSynGetKeyWordList(KeyStartWord, Items)
  else
  begin
    LVP:=TFBLocalVariableParser.Create(nil);
    try
      LVP.ParseLocalVarsEx(EditorFrame.EditorText);
      for F in LVP.Params do
        if (KeyStartWord = '') or (CompareText(F.Caption, KeyStartWord)= 0) then
          Items.Add(F);
    finally
      LVP.Free;
    end;
  end;
end;

procedure TfbTriggerHeaderEditFrame.UpdateEnvOptions;
begin
  EditorFrame.ChangeVisualParams;
end;

procedure TfbTriggerHeaderEditFrame.Localize;
begin
  inherited Localize;
  Label3.Caption:=sTriggerName;
  Label1.Caption:=sTriggerOrder;
  Label4.Caption:=sTableName;
  Label2.Caption:=sTriggerType;
  cbOnInsert.Caption:=sTriggerOnInsert;
  cbOnUpdate.Caption:=sTriggerOnUpdate;
  cbOnDelete.Caption:=sTriggerOnDelete;
  cbActive.Caption:=sTriggerActive;
  TabSheet1.Caption:=sDeclaration;
  tabLocalVar.Caption:=sLocalVariables;

  edtType.Clear;
  edtType.Items.Add(sBefore);
  edtType.Items.Add(sAfter);
end;

function TfbTriggerHeaderEditFrame.PageName: string;
begin
  Result:=sTrigger;
end;

constructor TfbTriggerHeaderEditFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);

  PageControl1.ActivePageIndex:=0;


  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=Self;
  EditorFrame.OnGetFieldsList:=@OnGetFieldsList;
  EditorFrame.OnGetKeyWordList:=@SynGetKeyWordList;
  EditorFrame.TextEditor.OnChange:=@TextEditorChange;
  EditorFrame.OnPopUpMenu:=@TextEditorPopUpMenu;
  DefinePopupMenu;

  tabLocalVar.TabVisible:=DBObject.OwnerDB.TriggerEditLazzyMode;

  EditorFrame.SQLEngine:=DBObject.OwnerDB;

  VariableFrame:=TfbmFBVariableFrame.Create(Self, DBObject, spvtLocal);
  VariableFrame.Parent:=tabLocalVar;
  VariableFrame.Align:=alClient;

  LoadTriggerBody;

  if DBObject.State = sdboCreate then
  begin
    edtOrderChange(nil);
    edtTrgName.OnChange:=@edtOrderChange;
    edtOrder.OnChange:=@edtOrderChange;
    edtType.OnChange:=@edtOrderChange;
    cbOnUpdate.OnChange:=@edtOrderChange;
    cbOnInsert.OnChange:=@edtOrderChange;
    cbOnDelete.OnChange:=@edtOrderChange;
  end;
end;
{
function TfbTriggerHeaderEditFrame.TriggerType: TTriggerTypes;
begin
  if edtType.ItemIndex >0 then
    Result:=[ttBefore]
  else
    Result:=[ttAfter];

  if cbOnInsert.Checked then
    Result:=Result + [ttInsert];

  if cbOnUpdate.Checked then
    Result:=Result + [ttUpdate];

  if cbOnDelete.Checked then
    Result:=Result + [ttDelete];
end;
}
function TfbTriggerHeaderEditFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaCompile, epaPrint, epaRefresh, epaComment, epaUnComment];
end;

function TfbTriggerHeaderEditFrame.DoMetod(PageAction: TEditorPageAction
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

function TfbTriggerHeaderEditFrame.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  Rec: TFBSQLCreateTrigger;
begin
  Result:=false;
  if not (ASQLObject is TFBSQLCreateTrigger) then exit;

  if tabLocalVar.TabVisible and not VariableFrame.Validate then
  begin
    ErrorBox(sErrorInParamName);
    exit;
  end;

  Rec:=ASQLObject as TFBSQLCreateTrigger;
  Rec.Name:=edtTrgName.Text;
  Rec.TableName:=edtTableName.Text;

  if DBObject.State = sdboEdit then
    Rec.Options := Rec.Options + [ooOrReplase];

  if cbActive.Checked then
    Rec.TriggerState:=trsActive
  else
    Rec.TriggerState:=trsInactive
    ;
  Rec.Position:=edtOrder.Value;

  Rec.TriggerType:=[];

  if cbOnInsert.Checked then
    Rec.TriggerType:=Rec.TriggerType + [ttInsert];

  if cbOnUpdate.Checked then
    Rec.TriggerType:=Rec.TriggerType + [ttUpdate];

  if cbOnDelete.Checked then
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

  if tabLocalVar.TabVisible then
    VariableFrame.SaveParams(Rec.Params);

  Rec.Body:=EditorFrame.EditorText;
  Result:=true;
end;

end.

