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

unit pgEventTriggerEditorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, StdCtrls, Buttons, Menus, fdmAbstractEditorUnit, sqlObjects,
  SQLEngineAbstractUnit, PostgreSQLEngineUnit, fbmSqlParserUnit,
  fdbm_SynEditorUnit, fbmPGLocalVarsEditorFrameUnit, SQLEngineCommonTypesUnit;

type

  { TpgEventTriggerEditorPage }

  TpgEventTriggerEditorPage = class(TEditorPage)
    cbEnabled: TCheckBox;
    cbLang: TComboBox;
    cbProcList: TComboBox;
    cbEventTriggerType: TComboBox;
    edtCaption: TEdit;
    edtNewProcName: TEdit;
    lblForEvent: TLabel;
    lblLanguage: TLabel;
    lblTriggerName: TLabel;
    PageControl1: TPageControl;
    PageControl2: TPageControl;
    rbCreateNewFunc: TRadioButton;
    rbExistFunc: TRadioButton;
    Splitter2: TSplitter;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    procedure cbEventTriggerTypeChange(Sender: TObject);
    procedure rbCreateNewFuncChange(Sender: TObject);
  private
    EditorFrame:Tfdbm_SynEditorFrame;
    FLocalVars:TfbmPGLocalVarsEditorFrame;
    edtWhenFrame:Tfdbm_SynEditorFrame;
    FMenuDefineVariable: TMenuItem;
    procedure OnGetFieldsList(Sender:Tfdbm_SynEditorFrame; const DBObjName:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);
    procedure OnGetKeyWordList(Sender:Tfdbm_SynEditorFrame; const KeyStartWord:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);
    procedure LoadTrigerBody;
    procedure PrintPage;
    procedure RefreshObject;
    function GetProcText:string;
    procedure TextEditorChange(Sender: TObject);
    procedure DefinePopupMenu;
    procedure DoTextEditorDefineVariable(Sender: TObject);
    procedure TextEditorPopUpMenu(Sender: TObject);
  protected
    procedure SetReadOnly(AValue: boolean);override;
    function CommentCode:boolean;
    function UnCommentCode:boolean;
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    procedure UpdateEnvOptions;override;

    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses pg_sql_lines_unit, fbmStrConstUnit, fbmToolsUnit, pg_SqlParserUnit,
  ibmSqlUtilsUnit, LazUTF8, rxstrutils, strutils, PGKeywordsUnit;

{$R *.lfm}

{ TpgEventTriggerEditorPage }

procedure TpgEventTriggerEditorPage.rbCreateNewFuncChange(Sender: TObject);
begin
  if rbExistFunc.Checked then
    LoadTrigerBody
  else
  begin
    cbEventTriggerTypeChange(nil);
    EditorFrame.EditorText:=ConfigValues.ByNameAsString('ObjTemplate-PostgreSQL-TriggerFuncion', DummyPGTriggerText);
    EditorFrame.Modified:=false;
  end;
end;

procedure TpgEventTriggerEditorPage.cbEventTriggerTypeChange(Sender: TObject);
var
  S: TCaption;
  i: Integer;
  S1: String;
  P: TPGSchema;
begin
  //Создадим имя тригера из меток срабатывания
  if (DBObject.State <> sdboEdit) and ((not edtCaption.Modified) or ((not edtNewProcName.Modified) and rbCreateNewFunc.Checked)) then
  begin
    S:=cbEventTriggerType.Text;

    if not edtCaption.Modified then
    begin
      i:=1;
      repeat
        S1:='ev_'+ S + '_'+IntToStr(i);
        inc(i);
      until not Assigned(TSQLEnginePostgre(DBObject.OwnerDB).EventTriggers.ObjByName(S1));

      edtCaption.Text:=S1;
      edtCaption.Modified:=false;
    end;

    if ((not edtNewProcName.Modified) and rbCreateNewFunc.Checked) then
    begin
      P:=TSQLEnginePostgre(DBObject.OwnerDB).SchemasRoot.PublicSchema;
      if Assigned(P) then
      begin
        i:=1;
        repeat
          S1:='evp_'+ S + '_' + IntToStr(i);
          inc(i);
        until not (Assigned(P.TriggerProc.ObjByName(S1)) or Assigned(P.Procedures.ObjByName(S1)));

        edtNewProcName.Text:=S1;
        edtNewProcName.Modified:=false;
      end;
    end;
  end;
end;

procedure TpgEventTriggerEditorPage.OnGetFieldsList(
  Sender: Tfdbm_SynEditorFrame; const DBObjName: string;
  const Items: TSynCompletionObjList; ACharCase: TCharCaseOptions);
begin
{  if (UpperCase(DBObjName) = 'OLD') or (UpperCase(DBObjName) = 'NEW') then
  begin
    if (cbTables.ItemIndex>-1) and (cbTables.ItemIndex<cbTables.Items.Count) then
    begin
      DBTable:=TPGTable(cbTables.Items.Objects[cbTables.ItemIndex]);
      Items.FillFieldList(DBTable);
    end;
  end; }
end;

procedure TpgEventTriggerEditorPage.OnGetKeyWordList(
  Sender: Tfdbm_SynEditorFrame; const KeyStartWord: string;
  const Items: TSynCompletionObjList; ACharCase: TCharCaseOptions);
var
  SQLCommand:TPGSQLCreateFunction;
  LVP: TPGSQLDeclareLocalVarInt;
  P: TSQLParserField;
  PGTV: TDefVariableRecord;
//  PGTV: TDefVariableRecord;
begin
  SQLCommand:=TPGSQLCreateFunction(SQLParseCommand(GetProcText, TPGSQLCreateFunction, TPGEventTrigger(DBObject).OwnerDB));
  if Assigned(SQLCommand) then
  begin
    for P in SQLCommand.Params do
      if (KeyStartWord = '') or (CompareText(P.Caption, KeyStartWord) = 0) then
        Items.Add(P);
    SQLCommand.Free;
  end;

  if TabSheet5.TabVisible then
    FLocalVars.FillSynCompletionList(KeyStartWord, Items)
  else
  begin
    LVP:=TPGSQLDeclareLocalVarInt.Create;
    try
      LVP.ParseString(EditorFrame.EditorText);
      for P in LVP.Params do
        if (KeyStartWord = '') or (CompareText(P.Caption, KeyStartWord) = 0) then
           Items.Add(P);
    finally
      LVP.Free;
    end;
  end;

  for PGTV in PGEventTriggerVars do
    if (KeyStartWord = '') or (CompareText(PGTV.VarName, KeyStartWord) = 0) then
      Items.Add(scotParam, PGTV.VarName, PGTV.VarType, PGTV.VarDesc);
end;

procedure TpgEventTriggerEditorPage.LoadTrigerBody;
begin
  if Assigned(TPGEventTrigger(DBObject).TriggerSP) then
  begin
    if TabSheet5.TabVisible then
      EditorFrame.EditorText:=FLocalVars.ParseSQL(TPGEventTrigger(DBObject).TriggerSP.ProcedureBody)
    else
      EditorFrame.EditorText:=TPGEventTrigger(DBObject).TriggerSP.ProcedureBody;
  end;
  EditorFrame.Modified:=false;
end;

procedure TpgEventTriggerEditorPage.PrintPage;
begin

end;

procedure TpgEventTriggerEditorPage.RefreshObject;
var
  L: TPGLanguage;
  J, i: Integer;
  Sg: TPGSchema;
  P: TPGFunction;
begin
  cbLang.Items.Clear;
  for i:=0 to TSQLEnginePostgre(DBObject.OwnerDB).LanguageRoot.CountObject - 1 do
  begin
    L:=TSQLEnginePostgre(DBObject.OwnerDB).LanguageRoot.Items[i] as TPGLanguage;
    J:=cbLang.Items.AddObject(L.Caption, L);
    if CompareText(L.Caption, 'PLPGSQL')=0 then
      cbLang.ItemIndex:=j;
  end;

  cbEnabled.Checked:=TPGEventTrigger(DBObject).Active;

  if DBObject.State <> sdboEdit then
  begin
    edtCaption.Enabled:=DBObject.State <> sdboEdit;
    cbEventTriggerTypeChange(nil);
  end
  else
  begin
    edtCaption.Text:=DBObject.Caption;
    cbEventTriggerType.Text:=TPGEventTrigger(DBObject).TriggerEvent;
  end;



  cbProcList.Items.Clear;
  for i:=0 to TSQLEnginePostgre(DBObject.OwnerDB).SchemasRoot.CountGroups - 1 do
  begin
    Sg:=TSQLEnginePostgre(DBObject.OwnerDB).SchemasRoot.Groups[i] as TPGSchema;
    if not Sg.SystemObject then
      for j:=0 to Sg.TriggerProc.CountObject -1 do
      begin
        P:=TPGFunction(Sg.TriggerProc.Items[j]);
        if P.ReturnTypeOID = TSQLEnginePostgre(DBObject.OwnerDB).IDTypeEventTrigger then
        begin
          cbProcList.Items.Add(P.CaptionFullPatch);
          cbProcList.Items.Objects[cbProcList.Items.Count-1]:=P;
          if P = TPGEventTrigger(DBObject).TriggerSP then
            cbProcList.ItemIndex:=cbProcList.Items.Count - 1;
        end;
      end;
  end;


  LoadTrigerBody;

  if TPGEventTrigger(DBObject).TriggerWhen<>'' then
  begin
    edtWhenFrame.EditorText:=TPGEventTrigger(DBObject).TriggerWhen;
    edtWhenFrame.Modified:=false;
    TabSheet3.Caption:=sConditions+' (*)';
  end
  else
    TabSheet3.Caption:=sConditions;
end;

function TpgEventTriggerEditorPage.GetProcText: string;
var
  S:string;
begin
  if rbCreateNewFunc.Checked then
    S:=edtNewProcName.Text
  else
    S:=TPGFunction(cbProcList.Items.Objects[cbProcList.ItemIndex]).CaptionFullPatch;

  Result:='FUNCTION '+S+'() RETURNS event_trigger AS'+LineEnding+'$BODY$ '+LineEnding;

  if TabSheet5.TabVisible then;
    Result:=Result + FLocalVars.VriablesList(true);

  Result:=Result + EditorFrame.EditorText+' $BODY$ LANGUAGE '''+cbLang.Text+'''';// VOLATILE COST 100;';
end;

procedure TpgEventTriggerEditorPage.TextEditorChange(Sender: TObject);
begin
  Modified:=true;
end;

procedure TpgEventTriggerEditorPage.DefinePopupMenu;
begin
  FMenuDefineVariable:=EditorFrame.CreateCTMenuItem(sDefineVariable, @DoTextEditorDefineVariable);
end;

procedure TpgEventTriggerEditorPage.DoTextEditorDefineVariable(Sender: TObject);
var
  S: String;
  St: TStringList;
begin
  S:=Trim(EditorFrame.TextEditor.SelText);
  if TabSheet5.TabVisible and (S<>'') then
  begin
    St:=TStringList.Create;
    if Pos(',', S)>0 then
      StrToStrings(S, St, ',')
    else
      St.Add(S);

    for S in St do
    begin
      if IsValidIdent(Trim(S)) then
        FLocalVars.AddVariable(Trim(S));
    end;
    PageControl2.ActivePage:=TabSheet5;
    St.Free;
  end;
end;

procedure TpgEventTriggerEditorPage.TextEditorPopUpMenu(Sender: TObject);
var
  S: String;
  F: Boolean;
  St: TStringList;
begin
  F:=true;
  St:=TStringList.Create;
  S:=Trim(EditorFrame.TextEditor.SelText);
  if Pos(',', S)>0 then
    StrToStrings(S, St, ',')
  else
    St.Add(S);
  for S in St do
  begin
    if (S='') or (not IsValidIdent(Trim(S))) then
    begin
      F:=false;
      Break;
    end;
  end;
  St.Free;
  FMenuDefineVariable.Enabled:=TabSheet5.TabVisible and F;
end;

procedure TpgEventTriggerEditorPage.SetReadOnly(AValue: boolean);
begin
  inherited SetReadOnly(AValue);
  EditorFrame.ReadOnly:=true;
  edtWhenFrame.ReadOnly:=true;
  PageControl2.Enabled:=false;
end;

function TpgEventTriggerEditorPage.CommentCode: boolean;
var
  S: String;
begin
  Result:=false;
  S:=EditorFrame.EditorText;
  if CommentSQLCode(S, SysCommentStyle) then
  begin
    EditorFrame.EditorText:=S;
    Result:=true;
  end;
end;

function TpgEventTriggerEditorPage.UnCommentCode: boolean;
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

function TpgEventTriggerEditorPage.PageName: string;
begin
  Result:=sEventTrigger;
end;

constructor TpgEventTriggerEditorPage.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  PageControl1.ActivePageIndex:=0;

  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=Self;
  EditorFrame.SQLEngine:=DBObject.OwnerDB;
  EditorFrame.OnGetFieldsList:=@OnGetFieldsList;
  EditorFrame.OnGetKeyWordList:=@OnGetKeyWordList;
  EditorFrame.Name:='EditorFrame';
  EditorFrame.TextEditor.OnChange:=@TextEditorChange;
  EditorFrame.OnPopUpMenu:=@TextEditorPopUpMenu;
  DefinePopupMenu;

  edtWhenFrame:=Tfdbm_SynEditorFrame.Create(Self);
  edtWhenFrame.Parent:=TabSheet3;
  edtWhenFrame.SQLEngine:=DBObject.OwnerDB;
  edtWhenFrame.OnGetFieldsList:=@OnGetFieldsList;
  edtWhenFrame.Name:='edtWhenFrame';

  FLocalVars:=TfbmPGLocalVarsEditorFrame.Create(Self);
  FLocalVars.Parent:=TabSheet5;
  FLocalVars.Align:=alClient;
  FLocalVars.OwnerDB:=DBObject.OwnerDB;

  TabSheet5.TabVisible:=DBObject.OwnerDB.TriggerEditLazzyMode;

  PageControl2.ActivePageIndex:=0;

  FLocalVars.Localize;
  RefreshObject;
end;

function TpgEventTriggerEditorPage.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaRefresh, epaPrint, epaCompile, epaComment, epaUnComment];
end;

function TpgEventTriggerEditorPage.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:PrintPage;
    epaRefresh:RefreshObject;
    epaComment:Result:=CommentCode;
    epaUnComment:Result:=UnCommentCode;
  else
    Result:=false;
  end;
end;

procedure TpgEventTriggerEditorPage.Localize;
begin
  inherited Localize;
  lblTriggerName.Caption:=sTriggerName;
  cbEnabled.Caption:=sTriggerActive;
  lblForEvent.Caption:=sTriggerForEvent;
  rbExistFunc.Caption:=sUseExistingFunction;
  rbCreateNewFunc.Caption:=sCreateNewFunction;
  lblLanguage.Caption:=sLanguage;
  TabSheet3.Caption:=sConditions;

  TabSheet4.Caption:=sDeclaration;
  TabSheet5.Caption:=sLocalVariables;
end;

procedure TpgEventTriggerEditorPage.UpdateEnvOptions;
begin
  EditorFrame.ChangeVisualParams;
  edtWhenFrame.ChangeVisualParams;
end;

function TpgEventTriggerEditorPage.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  FPrc: TPGFunction;
  FCmd: TPGSQLCreateEventTrigger;
  F: TSQLParserField;
  S, SS, SN: String;
begin
  Result:=false;

  FCmd:=ASQLObject as TPGSQLCreateEventTrigger;

  if rbCreateNewFunc.Checked or EditorFrame.Modified then
  begin
    FCmd.TriggerFunction:=TPGSQLCreateFunction.Create(nil);
    if rbCreateNewFunc.Checked then
    begin
      SN:=edtNewProcName.Text;
      if Pos('.', SN) = 0 then
        SS:=TSQLEnginePostgre(DBObject.OwnerDB).SchemasRoot.PublicSchema.Caption
      else
        SS:=Copy2SymbDel(SN, '.');
      FCmd.TriggerFunction.Name:=SN;
      FCmd.TriggerFunction.SchemaName:=SS;
    end
    else
    begin
      FPrc:=TPGFunction(cbProcList.Items.Objects[cbProcList.ItemIndex]);
      FCmd.TriggerFunction.Name:=FPrc.Caption;
      FCmd.TriggerFunction.SchemaName:=FPrc.SchemaName;
    end;

    FCmd.TriggerFunction.Options:=FCmd.TriggerFunction.Options + [ooOrReplase];
    FCmd.TriggerFunction.Language:=cbLang.Text;
    F:=FCmd.TriggerFunction.Output.AddParam('');
    F.TypeName:='event_trigger';

    S:='';
    if TabSheet5.TabVisible then
      S:=S + FLocalVars.VriablesList(true);
    FCmd.TriggerFunction.Body:=S + EditorFrame.EditorText + LineEnding;
  end;

  FCmd.Name:=edtCaption.Text;
  FCmd.TriggerWhen:=Trim(edtWhenFrame.EditorText);

  if rbCreateNewFunc.Checked then
  begin
    FCmd.ProcName:=FCmd.TriggerFunction.FullName;
  end
  else
  begin
    FPrc:=TPGFunction(cbProcList.Items.Objects[cbProcList.ItemIndex]);
    FCmd.ProcName:=FPrc.CaptionFullPatch;
  end;

  if (DBObject.State = sdboCreate) or
     (cbEventTriggerType.Text <> TPGEventTrigger(DBObject).TriggerEvent)
    then
  begin
    FCmd.EventName:=cbEventTriggerType.Text;

  end
  else
    FCmd.EventName:='';


  if (DBObject.State = sdboEdit) then
  begin
    if cbEnabled.Checked then
      FCmd.TriggerState:=trsActive
    else
      FCmd.TriggerState:=trsInactive;

    if (Trim(edtWhenFrame.EditorText) <> Trim(TPGEventTrigger(DBObject).TriggerWhen)) or
       (cbEventTriggerType.Text <> TPGEventTrigger(DBObject).TriggerEvent) then
      FCmd.Options:=FCmd.Options + [ooOrReplase]; //Пересоздадим триггер
  end
  else
  begin
    if not cbEnabled.Checked then
      FCmd.TriggerState:=trsInactive;
  end;

  Result:=true;
end;

end.

