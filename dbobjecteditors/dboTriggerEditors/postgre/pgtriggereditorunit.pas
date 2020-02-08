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

unit pgTriggerEditorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, Buttons, Menus, DB, fdmAbstractEditorUnit, sqlObjects,
  PostgreSQLEngineUnit, fdbm_SynEditorUnit, SQLEngineAbstractUnit,
  SQLEngineCommonTypesUnit, fbmSqlParserUnit, fbmToolsUnit,
  fbmPGLocalVarsEditorFrameUnit;

type

  { TpgTriggerEditorPage }

  TpgTriggerEditorPage = class(TEditorPage)
    cbEnabled: TCheckBox;
    cbOnEvent: TCheckGroup;
    cbTables: TComboBox;
    cbProcList: TComboBox;
    cbLang: TComboBox;
    edtCaption: TEdit;
    edtNewProcName: TEdit;
    GroupBox1: TGroupBox;
    lblTriggerName: TLabel;
    lblForTable: TLabel;
    lblLanguage: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    PageControl1: TPageControl;
    PageControl2: TPageControl;
    rbBefore: TRadioButton;
    rbAfter: TRadioButton;
    rbInstead: TRadioButton;
    rbExistFunc: TRadioButton;
    rbCreateNewFunc: TRadioButton;
    rgRowScope: TRadioGroup;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    procedure cbOnEventClick(Sender: TObject);
    procedure cbOnEventItemClick(Sender: TObject; Index: integer);
    procedure cbProcListChange(Sender: TObject);
    procedure cbTablesChange(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure rbCreateNewFuncChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    EditorFrame:Tfdbm_SynEditorFrame;
    FLocalVars:TfbmPGLocalVarsEditorFrame;
    edtWhenFrame:Tfdbm_SynEditorFrame;
    procedure LoadTrigerBody;
    procedure LoadTriggerFields;
    procedure PrintPage;
    procedure RefreshObject;
    procedure OnGetFieldsList(Sender:Tfdbm_SynEditorFrame; const DBObjName:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);
    procedure OnGetKeyWordList(Sender:Tfdbm_SynEditorFrame; const KeyStartWord:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);
    function GetProcText:string;
    procedure UpdateFieldButtons;
    function OnGetHintData(Sender:Tfdbm_SynEditorFrame; const S1, S2:string; out HintText:string):Boolean;
  protected
    FMenuDefineVariable: TMenuItem;
    procedure SetReadOnly(AValue: boolean);override;
    function CommentCode:boolean;
    function UnCommentCode:boolean;
    procedure TextEditorChange(Sender: TObject);

    procedure DefinePopupMenu;
    procedure DoTextEditorDefineVariable(Sender: TObject);
    procedure TextEditorPopUpMenu(Sender: TObject);
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
uses fbmStrConstUnit, pg_sql_lines_unit, PGKeywordsUnit, pg_SqlParserUnit, rxstrutils,
  ibmSqlUtilsUnit, LazUTF8;

{$R *.lfm}

{ TpgTriggerEditorPage }

procedure TpgTriggerEditorPage.cbProcListChange(Sender: TObject);
var
  P:TPGFunction;
begin
  if rbExistFunc.Checked then
  begin
    P:=TPGFunction(cbProcList.Items.Objects[cbProcList.ItemIndex]);
    if Assigned(P) then
      EditorFrame.EditorText:=P.ProcedureBody;
  end;
end;

procedure TpgTriggerEditorPage.cbTablesChange(Sender: TObject);
var
  DBTable:TDBDataSetObject;
begin
  if (cbTables.Items.Count>0) and (cbTables.ItemIndex>=0) and (cbTables.ItemIndex<cbTables.Items.Count) then
  begin
    DBTable:=cbTables.Items.Objects[cbTables.ItemIndex] as TDBDataSetObject;
    cbEnabled.Enabled:=DBTable is TDBTableObject;
    rbBefore.Enabled:=DBTable is TDBTableObject;
    rbAfter.Enabled:=DBTable is TDBTableObject;
    rbInstead.Enabled:=DBTable is TDBViewObject;
  end;
end;

procedure TpgTriggerEditorPage.ListBox2Click(Sender: TObject);
begin
  UpdateFieldButtons;
end;

procedure TpgTriggerEditorPage.cbOnEventClick(Sender: TObject);
var
  S, S1:string;
  i:integer;
begin
  //Создадим имя тригера из меток срабатывания
  if (DBObject.State <> sdboEdit) and ((not edtCaption.Modified) or ((not edtNewProcName.Modified) and rbCreateNewFunc.Checked)) then
  begin
    if rbBefore.Checked then
      S:='_b'
    else
    if rbAfter.Checked then
      S:='_a'
    else
    if rbInstead.Checked then
      S:='_o';

    if rgRowScope.ItemIndex = 0 then
      S:=S+'r'
    else
      S:=S+'s';

    if  cbOnEvent.Checked[0] then
      S:=S+'i';
    if  cbOnEvent.Checked[1] then
      S:=S+'u';
    if  cbOnEvent.Checked[2] then
      S:=S+'d';


    if not edtCaption.Modified then
    begin
      i:=1;
      repeat
        S1:='tr_'+ TPGTrigger(DBObject).TableName + S+'_'+IntToStr(i);
        inc(i);
      until not Assigned(TPGTrigger(DBObject).Schema.Triggers.ObjByName(S1));

      edtCaption.Text:=S1;
      edtCaption.Modified:=false;
    end;

    if ((not edtNewProcName.Modified) and rbCreateNewFunc.Checked) then
    begin
      i:=1;
      repeat
        S1:='trp_'+TPGTrigger(DBObject).TableName+S + '_' + IntToStr(i);
        inc(i);
      until not (Assigned(TPGTrigger(DBObject).Schema.TriggerProc.ObjByName(S1)) or Assigned(TPGTrigger(DBObject).Schema.Procedures.ObjByName(S1)));

      edtNewProcName.Text:=S1;
      edtNewProcName.Modified:=false;
    end;
  end;
  TabSheet2.TabVisible:=cbOnEvent.Checked[1];
  Modified:=true;
end;

procedure TpgTriggerEditorPage.cbOnEventItemClick(Sender: TObject;
  Index: integer);
begin
  cbOnEventClick(nil);
end;

procedure TpgTriggerEditorPage.rbCreateNewFuncChange(Sender: TObject);
begin
  if rbExistFunc.Checked then
    LoadTrigerBody
  else
  begin
    cbOnEventClick(nil);
    EditorFrame.EditorText:=ConfigValues.ByNameAsString('ObjTemplate-PostgreSQL-TriggerFuncion', DummyPGTriggerText);
    EditorFrame.Modified:=false;
  end;
end;

procedure TpgTriggerEditorPage.SpeedButton1Click(Sender: TObject);
begin
  if (ListBox1.Items.Count>0) and (ListBox1.ItemIndex>=0) and (ListBox1.ItemIndex<ListBox1.Items.Count) then
  begin
    ListBox2.Items.Add(ListBox1.Items[ListBox1.ItemIndex]);
    ListBox1.Items.Delete(ListBox1.ItemIndex);
    ListBox2.ItemIndex:=ListBox2.Items.Count-1;
    Modified:=true;
  end;
  UpdateFieldButtons;
end;

procedure TpgTriggerEditorPage.SpeedButton2Click(Sender: TObject);
begin
  if (ListBox2.Items.Count>0) and (ListBox2.ItemIndex>=0) and (ListBox2.ItemIndex<ListBox2.Items.Count) then
  begin
    ListBox1.Items.Add(ListBox2.Items[ListBox2.ItemIndex]);
    ListBox2.Items.Delete(ListBox2.ItemIndex);
    ListBox1.ItemIndex:=ListBox1.Items.Count-1;
    Modified:=true;
  end;
  UpdateFieldButtons;
end;

procedure TpgTriggerEditorPage.SpeedButton3Click(Sender: TObject);
var
  S:string;
begin
  if (ListBox2.Items.Count>0) and (ListBox2.ItemIndex>0) and (ListBox2.ItemIndex<ListBox2.Items.Count) then
  begin
    S:=ListBox2.Items[ListBox2.ItemIndex];
    ListBox2.Items[ListBox2.ItemIndex]:=ListBox2.Items[ListBox2.ItemIndex-1];
    ListBox2.Items[ListBox2.ItemIndex-1]:=S;
    ListBox2.ItemIndex:=ListBox2.ItemIndex-1;
    Modified:=true;
  end;

  UpdateFieldButtons;
end;

procedure TpgTriggerEditorPage.SpeedButton4Click(Sender: TObject);
var
  S:string;
begin
  if (ListBox2.Items.Count>0) and (ListBox2.ItemIndex>=0) and (ListBox2.ItemIndex<ListBox2.Items.Count-1) then
  begin
    S:=ListBox2.Items[ListBox2.ItemIndex];
    ListBox2.Items[ListBox2.ItemIndex]:=ListBox2.Items[ListBox2.ItemIndex+1];
    ListBox2.Items[ListBox2.ItemIndex+1]:=S;
    ListBox2.ItemIndex:=ListBox2.ItemIndex+1;
    Modified:=true;
  end;
  UpdateFieldButtons;
end;

procedure TpgTriggerEditorPage.LoadTrigerBody;
begin
  if Assigned(TPGTrigger(DBObject).TriggerSP) then
  begin
    if TabSheet5.TabVisible then
      EditorFrame.EditorText:=FLocalVars.ParseSQL(TPGTrigger(DBObject).TriggerSP.ProcedureBody)
    else
      EditorFrame.EditorText:=TPGTrigger(DBObject).TriggerSP.ProcedureBody;
  end;
  EditorFrame.Modified:=false;
  Modified:=false;
end;

procedure TpgTriggerEditorPage.LoadTriggerFields;
var
  i:integer;
begin
  ListBox1.Items.Clear;
  if Assigned(DBObject) and Assigned(TPGTrigger(DBObject).TriggerTable) then
  begin
    for i:=0 to TPGTrigger(DBObject).TriggerTable.Fields.Count-1 do
    begin
      if TPGTrigger(DBObject).UpdateFieldsWhere.IndexOf(TPGTrigger(DBObject).TriggerTable.Fields[i].FieldName) < 0 then
        ListBox1.Items.Add(TPGTrigger(DBObject).TriggerTable.Fields[i].FieldName);
    end;
    ListBox2.Items.Assign(TPGTrigger(DBObject).UpdateFieldsWhere);
  end;
  UpdateFieldButtons;
end;

procedure TpgTriggerEditorPage.PrintPage;
begin
  //
end;

procedure TpgTriggerEditorPage.UpdateEnvOptions;
begin
  EditorFrame.ChangeVisualParams;
  edtWhenFrame.ChangeVisualParams;
end;

procedure TpgTriggerEditorPage.RefreshObject;
var
  i, j:integer;
  Sg:TPGSchema;
  P:TPGFunction;
  T:TPGTable;
  L:TPGLanguage;
  V: TPGView;
begin
  cbLang.Items.Clear;
  for i:=0 to TSQLEnginePostgre(DBObject.OwnerDB).LanguageRoot.CountObject - 1 do
  begin
    L:=TSQLEnginePostgre(DBObject.OwnerDB).LanguageRoot.Items[i] as TPGLanguage;
    J:=cbLang.Items.AddObject(L.Caption, L);
    if UpperCase(L.Caption) = 'PLPGSQL' then
      cbLang.ItemIndex:=j;
  end;

  cbEnabled.Checked:=TPGTrigger(DBObject).Active;

  rbBefore.Checked:=ttBefore in TPGTrigger(DBObject).TriggerType;
  rbAfter.Checked:=ttAfter in TPGTrigger(DBObject).TriggerType;
  rbInstead.Checked:=ttInsteadOf in TPGTrigger(DBObject).TriggerType;

  rgRowScope.ItemIndex:=Ord(ttStatement in TPGTrigger(DBObject).TriggerType);

  cbOnEvent.Checked[0]:= ttInsert in TPGTrigger(DBObject).TriggerType;
  cbOnEvent.Checked[1]:= ttUpdate in TPGTrigger(DBObject).TriggerType;
  cbOnEvent.Checked[2]:= ttDelete in TPGTrigger(DBObject).TriggerType;

  if DBObject.State <> sdboEdit then
  begin
    edtCaption.Enabled:=DBObject.State <> sdboEdit;
    cbOnEventClick(nil);
  end
  else
    edtCaption.Text:=DBObject.Caption;



  cbTables.Clear;
  TPGTrigger(DBObject).Schema.TablesRoot.FillListForNames(cbTables.Items, true);
  TPGTrigger(DBObject).Schema.Views.FillListForNames(cbTables.Items, true);
  I:=cbTables.Items.IndexOfObject(TPGTrigger(DBObject).TriggerTable);
  if (I>-1) and (I<cbTables.Items.Count) then
  begin
    cbTables.ItemIndex:=I;
    cbTablesChange(nil);
(*
  for i:=0 to TPGTrigger(DBObject).Schema.TablesRoot.CountObject - 1 do
  begin
    T:=TPGTable(TPGTrigger(DBObject).Schema.TablesRoot.Items[i]);
    cbTables.Items.AddObject(T.CaptionFullPatch, T);
    if TPGTrigger(DBObject).TriggerTable = T then
      cbTables.ItemIndex:=cbTables.Items.Count - 1;
  end;

  for i:=0 to TPGTrigger(DBObject).Schema.Views.CountObject - 1 do
  begin
    V:=TPGView(TPGTrigger(DBObject).Schema.Views.Items[i]);
    cbTables.Items.AddObject(V.CaptionFullPatch, V);
    if TPGTrigger(DBObject).TriggerTable = V then
      cbTables.ItemIndex:=cbTables.Items.Count - 1;
  end;
*)
  end;

  cbProcList.Items.Clear;
  for i:=0 to TSQLEnginePostgre(DBObject.OwnerDB).SchemasRoot.CountGroups - 1 do
  begin
    Sg:=TSQLEnginePostgre(DBObject.OwnerDB).SchemasRoot.Groups[i] as TPGSchema;
    if not Sg.SystemObject then
      for j:=0 to Sg.TriggerProc.CountObject -1 do
      begin
        P:=TPGFunction(Sg.TriggerProc.Items[j]);
        if P.ReturnTypeOID = TSQLEnginePostgre(DBObject.OwnerDB).IDTypeTrigger then
        begin
          cbProcList.Items.Add(P.CaptionFullPatch);
          cbProcList.Items.Objects[cbProcList.Items.Count-1]:=P;
          if P = TPGTrigger(DBObject).TriggerSP then
            cbProcList.ItemIndex:=cbProcList.Items.Count - 1;
        end;
      end;
  end;

  LoadTrigerBody;

  if TPGTrigger(DBObject).TriggerWhen<>'' then
  begin
    edtWhenFrame.EditorText:=TPGTrigger(DBObject).TriggerWhen;
    edtWhenFrame.Modified:=false;
    TabSheet3.Caption:=sConditions+' (*)';
  end
  else
    TabSheet3.Caption:=sConditions;

  TabSheet2.TabVisible:=cbOnEvent.Checked[1];
  LoadTriggerFields;

  Modified:=false;
end;

procedure TpgTriggerEditorPage.OnGetFieldsList(Sender: Tfdbm_SynEditorFrame;
  const DBObjName: string; const Items: TSynCompletionObjList;
  ACharCase: TCharCaseOptions);
var
  DBTable:TDBDataSetObject;
begin
  if (UpperCase(DBObjName) = 'OLD') or (UpperCase(DBObjName) = 'NEW') then
  begin
    if (cbTables.ItemIndex>-1) and (cbTables.ItemIndex<cbTables.Items.Count) then
    begin
      DBTable:=TPGTable(cbTables.Items.Objects[cbTables.ItemIndex]);
      Items.FillFieldList(DBTable);
    end;
  end;
end;

procedure TpgTriggerEditorPage.OnGetKeyWordList(Sender: Tfdbm_SynEditorFrame;
  const KeyStartWord: string; const Items: TSynCompletionObjList;
  ACharCase: TCharCaseOptions);
var
  SQLCommand:TPGSQLCreateFunction;
  LVP: TPGSQLDeclareLocalVarInt;
  P: TSQLParserField;
  PGTV: TDefVariableRecord;
begin
  SQLCommand:=TPGSQLCreateFunction(SQLParseCommand(GetProcText, TPGSQLCreateFunction, TPGTrigger(DBObject).OwnerDB));
  if Assigned(SQLCommand) then
  begin
    for P in SQLCommand.Params do
      if (KeyStartWord = '') or (UTF8UpperCase(UTF8Copy(P.Caption, 1, UTF8Length(KeyStartWord))) = KeyStartWord) then
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
        if (KeyStartWord = '') or (UpperCase(Copy(P.Caption, 1, Length(KeyStartWord))) = KeyStartWord) then
           Items.Add(P);
    finally
      LVP.Free;
    end;
  end;

  for PGTV in PGTriggerVars do
    if (KeyStartWord = '') or (UpperCase(Copy(PGTV.VarName, 1, Length(KeyStartWord))) = KeyStartWord) then
      Items.Add(scotKeyword, PGTV.VarName, PGTV.VarType, PGTV.VarDesc);
end;

function TpgTriggerEditorPage.GetProcText: string;
var
  S:string;
begin
  if rbCreateNewFunc.Checked then
    S:=edtNewProcName.Text
  else
    S:=TPGFunction(cbProcList.Items.Objects[cbProcList.ItemIndex]).CaptionFullPatch;

  Result:='FUNCTION '+S+'() RETURNS trigger AS'+LineEnding+'$BODY$ '+LineEnding;

  if TabSheet5.TabVisible then;
    Result:=Result + FLocalVars.VriablesList(true);

  Result:=Result + EditorFrame.EditorText+' $BODY$ LANGUAGE '''+cbLang.Text+'''';// VOLATILE COST 100;';
end;

procedure TpgTriggerEditorPage.UpdateFieldButtons;
begin
  SpeedButton1.Enabled:=ListBox1.Items.Count>0;
  SpeedButton2.Enabled:=ListBox2.Items.Count>0;

  SpeedButton3.Enabled:=(ListBox2.Items.Count>1) and (ListBox2.ItemIndex>0);
  SpeedButton4.Enabled:=(ListBox2.Items.Count>1) and (ListBox2.ItemIndex<ListBox2.Items.Count-1);
end;

function TpgTriggerEditorPage.OnGetHintData(Sender: Tfdbm_SynEditorFrame;
  const S1, S2: string; out HintText: string): Boolean;
var
  DBTable: TDBDataSetObject;
  F: TDBField;
  P: TBookMark;
begin
  HintText:='';
  Result:=false;
  if (S1<>'') and (S2<>'') then
  begin
    if (S1 = 'NEW') or (S1 = 'OLD') then
    begin
      DBTable:=TDBDataSetObject(cbTables.Items.Objects[cbTables.ItemIndex]);
      if Assigned(DBTable) then
      begin
        F:=DBTable.Fields.FieldByName(S2);
        if Assigned(F) then
        begin
          HintText:=ObjectKindToStr(okField) + ' ' +F.FieldName + ' ' + F.FieldTypeName;
          if F.FieldDescription<>'' then;
            HintText:=HintText + LineEnding + '---------------------------------------' + LineEnding + F.FieldDescription;
          Result:=true;
        end;
      end;
    end;
  end;

  if not Result then
  if (S1<>'') and (S2='') then
  begin
    FLocalVars.rxLocalVars.DisableControls;
    P:=FLocalVars.rxLocalVars.Bookmark;
    if FLocalVars.rxLocalVars.Locate('VAR_NAME', S1, [loCaseInsensitive]) then
    begin
      Result:=true;
      HintText:=sLocalVariables + ' : ' + FLocalVars.rxLocalVarsVAR_NAME.AsString + ' ' + FLocalVars.rxLocalVarsVAR_TYPE.AsString;
      if FLocalVars.rxLocalVarsVAR_DESC.AsString <> '' then
        HintText:=HintText +LineEnding + '---------------------------------------' + LineEnding + FLocalVars.rxLocalVarsVAR_DESC.AsString;
    end;
    FLocalVars.rxLocalVars.Bookmark:=P;
    FLocalVars.rxLocalVars.EnableControls;
  end;
end;

procedure TpgTriggerEditorPage.SetReadOnly(AValue: boolean);
begin
  inherited SetReadOnly(AValue);
  EditorFrame.ReadOnly:=true;
  edtWhenFrame.ReadOnly:=true;
  PageControl2.Enabled:=false;
end;

function TpgTriggerEditorPage.CommentCode: boolean;
var
  S: String;
begin
  Result:=false;
  S:=EditorFrame.EditorText;
  if CommentSQLCode(S, SysCommentStyle) then
  begin
    EditorFrame.EditorText:=S;
    EditorFrame.TextEditor.Modified:=true;
    Result:=true;
  end;
end;

function TpgTriggerEditorPage.UnCommentCode: boolean;
var
  S: String;
begin
  Result:=false;
  S:=EditorFrame.EditorText;
  if UnCommentSQLCode(S) then
  begin
    EditorFrame.EditorText:=S;
    EditorFrame.TextEditor.Modified:=true;
    Result:=true;
  end;
end;

procedure TpgTriggerEditorPage.TextEditorChange(Sender: TObject);
begin
  Modified:=true;
end;

procedure TpgTriggerEditorPage.DefinePopupMenu;
begin
  FMenuDefineVariable:=EditorFrame.CreateCTMenuItem(sDefineVariable, @DoTextEditorDefineVariable);
end;

procedure TpgTriggerEditorPage.DoTextEditorDefineVariable(Sender: TObject);
var
  S: String;
  St:TStringList;
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

procedure TpgTriggerEditorPage.TextEditorPopUpMenu(Sender: TObject);
var
  S: String;
  St:TStringList;
  F: Boolean;
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


function TpgTriggerEditorPage.PageName: string;
begin
  Result:=sTrigger;
end;

constructor TpgTriggerEditorPage.CreatePage(TheOwner: TComponent;
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
  EditorFrame.OnGetHintData:=@OnGetHintData;
  DefinePopupMenu;

  edtWhenFrame:=Tfdbm_SynEditorFrame.Create(Self);
  edtWhenFrame.Parent:=TabSheet3;
  edtWhenFrame.SQLEngine:=DBObject.OwnerDB;
  edtWhenFrame.OnGetFieldsList:=@OnGetFieldsList;
  edtWhenFrame.Name:='edtWhenFrame';
  //edtWhereFrame.OnGetKeyWordList:=@OnGetKeyWordList;

  FLocalVars:=TfbmPGLocalVarsEditorFrame.Create(Self);
  FLocalVars.Parent:=TabSheet5;
  FLocalVars.Align:=alClient;
  FLocalVars.OwnerDB:=TPGTrigger(DBObject).OwnerDB;

  TabSheet5.TabVisible:=TPGTrigger(DBObject).OwnerDB.TriggerEditLazzyMode;

  PageControl2.ActivePageIndex:=0;

  FLocalVars.Localize;
  RefreshObject;
end;

function TpgTriggerEditorPage.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaRefresh, epaPrint, epaCompile, epaComment, epaUnComment];
end;

function TpgTriggerEditorPage.DoMetod(PageAction: TEditorPageAction): boolean;
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

procedure TpgTriggerEditorPage.Localize;
begin
  inherited Localize;
  lblTriggerName.Caption:=sTriggerName;
  cbEnabled.Caption:=sTriggerActive;
  lblForTable.Caption:=sTriggerTableView;
  rbExistFunc.Caption:=sUseExistingFunction;
  rbCreateNewFunc.Caption:=sCreateNewFunction;
  lblLanguage.Caption:=sLanguage;
  TabSheet3.Caption:=sConditions;

  cbOnEvent.Caption:=sOnEvent;
  cbOnEvent.Items[0]:=sInsert;
  cbOnEvent.Items[1]:=sUpdate;
  cbOnEvent.Items[2]:=sDelete;

  GroupBox1.Caption:=sType;
  rbBefore.Caption:=sBefore;
  rbAfter.Caption:=sAfter;
  rbInstead.Caption:=sINSTEAD;

  rgRowScope.Caption:=sRowScope;
  rgRowScope.Items[0]:=sRow;
  rgRowScope.Items[1]:=sStatament;

  TabSheet4.Caption:=sDeclaration;
  TabSheet5.Caption:=sLocalVariables;
end;

function TpgTriggerEditorPage.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;

function CheckWhereFields:boolean;
var
  S: String;
begin
  Result:=false;
  if TPGTrigger(DBObject).UpdateFieldsWhere.Count <> ListBox2.Items.Count then Exit;
  for S in ListBox2.Items do
    if TPGTrigger(DBObject).UpdateFieldsWhere.IndexOf(S) < 0 then exit;
  Result:=true;
end;

var
  FCmd:TPGSQLCreateTrigger;
  F: TSQLParserField;
  S: String;
  FPrc: TPGFunction;
begin
  Result:=false;
//  Exit;
  FCmd:=ASQLObject as TPGSQLCreateTrigger;

  if rbCreateNewFunc.Checked or EditorFrame.Modified then
  begin
    FCmd.TriggerFunction:=TPGSQLCreateFunction.Create(nil);
    if rbCreateNewFunc.Checked then
    begin
      FCmd.TriggerFunction.Name:=edtNewProcName.Text;
      FCmd.TriggerFunction.SchemaName:=TPGTrigger(DBObject).Schema.Caption;
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
    F.TypeName:='trigger';
    S:='';
    if TabSheet5.TabVisible then
      S:=S + FLocalVars.VriablesList(true);
    FCmd.TriggerFunction.Body:=S + EditorFrame.EditorText + LineEnding;
  end;

  FCmd.Name:=edtCaption.Text;
  FCmd.TableName:=TDBDataSetObject(cbTables.Items.Objects[cbTables.ItemIndex]).Caption;
  FCmd.SchemaName:=TDBDataSetObject(cbTables.Items.Objects[cbTables.ItemIndex]).SchemaName;

  if rbCreateNewFunc.Checked then
  begin
    FCmd.ProcName:=FCmd.TriggerFunction.FullName;
  end
  else
  begin
    FPrc:=TPGFunction(cbProcList.Items.Objects[cbProcList.ItemIndex]);
    FCmd.ProcName:=FPrc.CaptionFullPatch;
  end;
  FCmd.TriggerType:=[];

  if cbOnEvent.Checked[0] then
    FCmd.TriggerType:=FCmd.TriggerType + [ttInsert];

  if cbOnEvent.Checked[1] then
    FCmd.TriggerType:=FCmd.TriggerType + [ttUpdate];

  if cbOnEvent.Checked[2] then
    FCmd.TriggerType:=FCmd.TriggerType + [ttDelete];

  if rbBefore.Checked then
    FCmd.TriggerType:=FCmd.TriggerType + [ttBefore]
  else
  if rbAfter.Checked then
    FCmd.TriggerType:=FCmd.TriggerType + [ttAfter]
  else
  if rbInstead.Checked then
    FCmd.TriggerType:=FCmd.TriggerType + [ttInsteadOf];


  if rgRowScope.ItemIndex = 0 then
    FCmd.TriggerType:=FCmd.TriggerType + [ttRow]
  else
    FCmd.TriggerType:=FCmd.TriggerType + [ttStatement];


  if TDBDataSetObject(cbTables.Items.Objects[cbTables.ItemIndex]) is TDBViewObject then
    FCmd.TriggerState:=trsNone
  else
  if (DBObject.State = sdboCreate) or (cbEnabled.Checked <> TPGTrigger(DBObject).Active) then
  begin
    if cbEnabled.Checked then
      FCmd.TriggerState:=trsActive
    else
      FCmd.TriggerState:=trsInactive;
  end;

  FCmd.TriggerWhen:=Trim(edtWhenFrame.EditorText);

  for S in ListBox2.Items do
    FCmd.Params.AddParam(S);

  if (DBObject.State = sdboEdit) then
    if (TPGTrigger(DBObject).TriggerType = FCmd.TriggerType)
      and (Trim(edtWhenFrame.EditorText) = Trim(TPGTrigger(DBObject).TriggerWhen))
      and CheckWhereFields then
      FCmd.TriggerType:=[] //Не надо перекомпилировать сам триггер
    else
      FCmd.Options:=FCmd.Options + [ooOrReplase]; //Пересоздадим триггер

  Result:=true;
end;

end.

