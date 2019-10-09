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

unit fbmPostGreeSPedtMainPageUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Spin, ActnList, Menus, ComCtrls, db, rxmemds, rxdbgrid, rxtoolbar,
  sqlObjects, fdmAbstractEditorUnit, PostgreSQLEngineUnit, fdbm_SynEditorUnit,
  fbmToolsUnit, LMessages, SQLEngineAbstractUnit, fbmSqlParserUnit,
  fbmPGLocalVarsEditorFrameUnit, SQLEngineCommonTypesUnit;

type
  TpgTypeParRec = record
    IO:integer;
    ParName:string;
    ParType:string;
    DefValue:string;
    Desc:string;
  end;

type

  { TfbmPostGreeFunctionEdtMainPage }

  TfbmPostGreeFunctionEdtMainPage = class(TEditorPage)
    cbIsStrict: TCheckBox;
    cbIsWindow: TCheckBox;
    CheckBox2: TCheckBox;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    PageControl1: TPageControl;
    Panel1: TGroupBox;
    parAdd: TAction;
    parEdit: TAction;
    parDel: TAction;
    parMoveUp: TAction;
    parMoveDown: TAction;
    parPrintList: TAction;
    ActionList1: TActionList;
    cbRetType: TComboBox;
    cbLang: TComboBox;
    cbVolatCat: TComboBox;
    dsParamList: TDatasource;
    edtName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    RadioGroup1: TRadioGroup;
    RxDBGrid1: TRxDBGrid;
    rxLocalVarsVAR_DESC: TStringField;
    rxLocalVarsVAR_DEV_VALUE: TStringField;
    rxLocalVarsVAR_NAME: TStringField;
    rxLocalVarsVAR_TYPE: TStringField;
    rxParamList: TRxMemoryData;
    rxParamListDefValue: TStringField;
    rxParamListDesc: TStringField;
    rxParamListID: TLongintField;
    rxParamListInOut: TLongintField;
    rxParamListOldParName: TStringField;
    rxParamListOldParType: TStringField;
    rxParamListParName: TStringField;
    rxParamListType: TStringField;
    edtAVGTime: TSpinEdit;
    edtAVGRows: TSpinEdit;
    Splitter1: TSplitter;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    procedure parDelExecute(Sender: TObject);
    procedure parEditExecute(Sender: TObject);
    procedure parMoveDownExecute(Sender: TObject);
    procedure parMoveUpExecute(Sender: TObject);
    procedure parPrintListExecute(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure RxDBGrid1DblClick(Sender: TObject);
    procedure RxDBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure rxParamListAfterDelete(DataSet: TDataSet);
    procedure rxParamListIDGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure rxParamListInOutGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
  private
    FMenuDefineVariable: TMenuItem;
    FMenuDefineInParam: TMenuItem;
    FMenuDefineOutParam: TMenuItem;
    FMenuDefineInOutParam: TMenuItem;
    FParamModified:boolean;
    EditorFrame:Tfdbm_SynEditorFrame;
    FLocalVars:TfbmPGLocalVarsEditorFrame;
    procedure LoadProcedureBody;
    procedure PrintPage;
    procedure TextEditorChange(Sender: TObject);
    procedure RefreshObject;
    procedure GetCurParRecord(out R:TpgTypeParRec);
    procedure SetCurParRecord(R:TpgTypeParRec);

    procedure SynGetKeyWordList(Sender:Tfdbm_SynEditorFrame; const KeyStartWord:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);
    procedure SynGetFieldsList(Sender:Tfdbm_SynEditorFrame; const DBObjName:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);
    function SynOnGetDBObjectByAlias(Sender:Tfdbm_SynEditorFrame; const ATableAlias:string; out DBObjName:string):TDBObject;
    procedure SynGetAliasList(Sender:Tfdbm_SynEditorFrame; const KeyStartWord:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);

    procedure LMEditorChangeParams(var message: TLMNoParams); message LM_EDITOR_CHANGE_PARMAS;
    procedure ChangeVisualParams;
    procedure DoAdd;
    procedure DoEdit;
    procedure DoDelete;
    function CommentCode:boolean;
    function UnCommentCode:boolean;

    procedure DefinePopupMenu;
    procedure DoTextEditorDefineVariable(Sender: TObject);
    procedure TextEditorPopUpMenu(Sender: TObject);
    function PGFunctionGetHintData(Sender:Tfdbm_SynEditorFrame; const S1, S2:string; out HintText:string):Boolean;
  public
    function PageName:string;override;
    procedure UpdateEnvOptions;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses rxAppUtils, LR_Class, LCLType, rxstrutils, IBManMainUnit, strutils, fbmStrConstUnit,
  pgTypes, ibmSqlUtilsUnit, pg_sql_lines_unit, pg_SqlParserUnit,
  fbmPostGreeSPedtMainPage_EditParamUnit;

{$R *.lfm}

{ TfbmPostGreeFunctionEdtMainPage }

procedure TfbmPostGreeFunctionEdtMainPage.parEditExecute(Sender: TObject);
begin
  fbmPostGreeSPedtMainPage_EditParamForm:=TfbmPostGreeSPedtMainPage_EditParamForm.Create(Application);
  DBObject.OwnerDB.TypeList.FillForTypes(fbmPostGreeSPedtMainPage_EditParamForm.cbType.Items, true);
  DBObject.OwnerDB.FillDomainsList(fbmPostGreeSPedtMainPage_EditParamForm.cbType.Items, false);


  if (Sender as TComponent).Tag = 1 then
    rxParamList.Append
  else
  begin
    fbmPostGreeSPedtMainPage_EditParamForm.Edit1.Text:=rxParamListParName.AsString;
    fbmPostGreeSPedtMainPage_EditParamForm.cbType.Text:=rxParamListType.AsString;
    fbmPostGreeSPedtMainPage_EditParamForm.cbInOut.ItemIndex:=rxParamListInOut.AsInteger-1;
    fbmPostGreeSPedtMainPage_EditParamForm.Memo1.Text:=rxParamListDesc.AsString;

    rxParamList.Edit;
  end;//
  if fbmPostGreeSPedtMainPage_EditParamForm.ShowModal = mrOk then
  begin
    rxParamListDesc.AsString:=fbmPostGreeSPedtMainPage_EditParamForm.Memo1.Text;
    rxParamListType.AsString   := fbmPostGreeSPedtMainPage_EditParamForm.cbType.Text;
    rxParamListInOut.AsInteger := fbmPostGreeSPedtMainPage_EditParamForm.cbInOut.ItemIndex + 1;

    rxParamListParName.AsString:=fbmPostGreeSPedtMainPage_EditParamForm.Edit1.Text;
    rxParamList.Post;
    Modified:=true;
  end
  else
    rxParamList.Cancel;
  fbmPostGreeSPedtMainPage_EditParamForm.Free;
end;

procedure TfbmPostGreeFunctionEdtMainPage.parMoveDownExecute(Sender: TObject);
var
  R1, R2:TpgTypeParRec;
begin
  if rxParamList.RecNo = rxParamList.RecordCount then exit;

  rxParamList.DisableControls;
  GetCurParRecord(R1);
  rxParamList.Next;
  GetCurParRecord(R2);
  rxParamList.Prior;
  SetCurParRecord(R2);
  rxParamList.Next;
  SetCurParRecord(R1);
  rxParamList.EnableControls;
  FParamModified:=true;
end;

procedure TfbmPostGreeFunctionEdtMainPage.parMoveUpExecute(Sender: TObject);
var
  R1, R2:TpgTypeParRec;
begin
  if rxParamList.RecNo < 2 then exit;

  rxParamList.DisableControls;
  GetCurParRecord(R1);
  rxParamList.Prior;
  GetCurParRecord(R2);
  rxParamList.Next;
  SetCurParRecord(R2);
  rxParamList.Prior;
  SetCurParRecord(R1);
  rxParamList.EnableControls;
  FParamModified:=true;
end;

procedure TfbmPostGreeFunctionEdtMainPage.parDelExecute(Sender: TObject);
begin
  if rxParamList.Active and (rxParamList.RecordCount > 0) then
    if QuestionBox(sDeleteParamQst) then
      rxParamList.Delete;
end;

procedure TfbmPostGreeFunctionEdtMainPage.parPrintListExecute(Sender: TObject);
begin
  //
end;

procedure TfbmPostGreeFunctionEdtMainPage.RadioGroup1Click(Sender: TObject);
begin
  Label4.Enabled:=RadioGroup1.ItemIndex>0;
  edtAVGRows.Enabled:=RadioGroup1.ItemIndex>0;
end;

procedure TfbmPostGreeFunctionEdtMainPage.RxDBGrid1DblClick(Sender: TObject);
begin
  parEdit.Execute;
end;

procedure TfbmPostGreeFunctionEdtMainPage.RxDBGrid1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_INSERT then
    parAdd.Execute;
end;

procedure TfbmPostGreeFunctionEdtMainPage.rxParamListAfterDelete(DataSet: TDataSet);
begin
  FParamModified:=true;
  Modified:=true;
end;

procedure TfbmPostGreeFunctionEdtMainPage.rxParamListIDGetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  if rxParamList.RecordCount > 0 then
    aText:=IntToStr(rxParamList.RecNo);
end;

procedure TfbmPostGreeFunctionEdtMainPage.rxParamListInOutGetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  aText:=ParamTypeFuncToStr(TSPVarType(rxParamListInOut.AsInteger));
(*  case TSPVarType(rxParamListInOut.AsInteger) of
    spvtInput:aText:='IN';
    spvtOutput:aText:='OUT';
    spvtInOut:aText:='INOUT';
    spvtVariadic:aText:='VARIADIC';
    spvtTable:aText:='TABLE';
  else
    aText:='';
  end; *)
end;

procedure TfbmPostGreeFunctionEdtMainPage.LoadProcedureBody;
var
  aSql:TStringList;
  S, S1:string;
  P: Classes.TPoint;

begin
  aSql:=TStringList.Create;
  if (TPGFunction(DBObject).State = sdboCreate) and (Trim(TPGFunction(DBObject).ProcedureBody) = '') then
  begin
    if TSQLEnginePostgre(TPGFunction(DBObject).OwnerDB).SPEditLazzyMode then
      aSql.Text:=ConfigValues.ByNameAsString('ObjTemplate-PostgreSQL-StdFuncion-Lazy', DummyPGFunctionTextLazy)
    else
      aSql.Text:=ConfigValues.ByNameAsString('ObjTemplate-PostgreSQL-StdFuncion', DummyPGFunctionText)
  end
  else
    aSql.Text:=TPGFunction(DBObject).ProcedureBody;

  if rxParamList.RecordCount>0 then
  begin
    while (aSql.Count>0) do
    begin
      S:=aSql[0];
      if Copy(S, 1, 6) = '--$FBM' then
      begin
        Delete(S, 1, 7);
        S1:=Copy2SpaceDel(S);
        if rxParamList.Locate('ParName', S1, [loCaseInsensitive]) then
        begin
          rxParamList.Edit;
          rxParamListDesc.AsString:=S;
          rxParamList.Post;
          aSql.Delete(0);
        end
        else
          Break;
      end
      else
        Break;
    end;
  end;

  if TabSheet3.TabVisible then
    aSql.Text:=FLocalVars.ParseSQL(aSql.Text);

  P:=EditorFrame.TextEditor.CaretXY;
  EditorFrame.EditorText:=aSql.Text;
  EditorFrame.TextEditor.CaretXY:=P;
  aSql.Free;

end;

procedure TfbmPostGreeFunctionEdtMainPage.PrintPage;
begin
  frVariables['DBClassTitle']:=TPGFunction(DBObject).DBClassTitle;
  frVariables['ObjectName']:=TPGFunction(DBObject).Caption;
  frVariables['ProcBody']:=EditorFrame.EditorText;
  fbManagerMainForm.LazReportPrint('DBObject_StoredProc');
end;

procedure TfbmPostGreeFunctionEdtMainPage.UpdateEnvOptions;
begin
  EditorFrame.ChangeVisualParams;
end;

procedure TfbmPostGreeFunctionEdtMainPage.RefreshObject;
var
  P: TDBField;
  D: TDBDomain;
begin
  edtName.Caption:=TPGFunction(DBObject).Caption;
  cbVolatCat.ItemIndex:=Ord(TPGFunction(DBObject).VolatilityCategories)-1;
  cbIsWindow.Checked:=TPGFunction(DBObject).isWindow;
  cbIsStrict.Checked:=TPGFunction(DBObject).isStrict;
  RadioGroup1.ItemIndex:=Ord(TPGFunction(DBObject).ReturnSetType);

  if TPGFunction(DBObject).AVGTime>0 then
    edtAVGTime.Value:=TPGFunction(DBObject).AVGTime
  else
    edtAVGTime.Value:=100;

  edtAVGRows.Value:=TPGFunction(DBObject).AVGRows;

  cbLang.Items.Clear;
  TSQLEnginePostgre(TPGFunction(DBObject).OwnerDB).LanguageRoot.FillListForNames(cbLang.Items, false);
  TPGFunction(DBObject).OwnerDB.TypeList.FillForTypes(cbRetType.Items, true);
  TPGFunction(DBObject).OwnerDB.FillDomainsList(cbRetType.Items, false);

  rxParamList.CloseOpen;

  if TPGFunction(DBObject).State <> sdboCreate then
  begin
    if Assigned(TPGFunction(DBObject).Language) then
      cbLang.Text:=TPGFunction(DBObject).Language.Caption;

    for P in TPGFunction(DBObject).FieldsIN do
    begin
      rxParamList.Append;
      rxParamListParName.AsString:=P.FieldName;
      rxParamListOldParName.AsString:=P.FieldName;
      if Assigned(P.FieldTypeRecord) then
        rxParamListType.AsString:=P.FieldTypeRecord.TypeName
      else
      begin
        D:=P.FieldDomain;
        if Assigned(D) then
          rxParamListType.AsString:=D.CaptionFullPatch;
      end;

      rxParamListInOut.AsInteger:=Ord(P.IOType);
      rxParamListOldParType.AsString:=rxParamListType.AsString;
      rxParamList.Post;
    end;

    if Assigned(TPGFunction(DBObject).ResultType) then
    begin
      if Assigned(TPGFunction(DBObject).ResultType.FieldDomain) then
        cbRetType.Text:=TPGFunction(DBObject).ResultType.FieldDomain.CaptionFullPatch
      else
        cbRetType.Text:=TPGFunction(DBObject).ResultType.FieldTypeRecord.TypeName;
    end;
  end;
  LoadProcedureBody;
  FParamModified:=false;
  Modified:=false;
end;

procedure TfbmPostGreeFunctionEdtMainPage.GetCurParRecord(out R: TpgTypeParRec);
begin
  R.IO:=rxParamListInOut.AsInteger;
  R.ParName:=rxParamListParName.AsString;
  R.ParType:=rxParamListType.AsString;
  R.DefValue:=rxParamListDefValue.AsString;
  R.Desc:=rxParamListDesc.AsString;
end;

procedure TfbmPostGreeFunctionEdtMainPage.SetCurParRecord(R: TpgTypeParRec);
begin
  rxParamList.Edit;
  rxParamListInOut.AsInteger   := R.IO;
  rxParamListParName.AsString  := R.ParName;
  rxParamListType.AsString     := R.ParType;
  rxParamListDefValue.AsString := R.DefValue;
  rxParamListDesc.AsString     := R.Desc;
  rxParamList.Post;
  FParamModified:=true;
end;

procedure TfbmPostGreeFunctionEdtMainPage.SynGetKeyWordList(
  Sender: Tfdbm_SynEditorFrame; const KeyStartWord: string;
  const Items: TSynCompletionObjList; ACharCase: TCharCaseOptions);
var
  B:TBookmark;
  Prs: TSQLParser;
  S: String;
  FSt: TSQLTextStatement;
  LVP: TPGSQLDeclareLocalVarInt;
  P: TSQLParserField;
  R: TSynCompletionObjItem;
  T: TTableItem;
  CDDL: TSQLCommandDDL;
  CDML: TSQLCommandAbstractSelect;
begin
  B:=rxParamList.Bookmark;
  rxParamList.DisableControls;
  try
    rxParamList.First;
    while not rxParamList.EOF do
    begin
      if (KeyStartWord = '') or (UpperCase(Copy(rxParamListParName.AsString, 1, Length(KeyStartWord))) = KeyStartWord) then
      begin
        R:=Items.Add(scotParam, rxParamListParName.AsString, rxParamListType.AsString, rxParamListDesc.AsString);
        R.IOTypeName:=rxParamListInOut.DisplayText;
      end;
      rxParamList.Next;
    end;
  finally
    rxParamList.Bookmark:=B;
    rxParamList.EnableControls;
  end;

  if TabSheet3.TabVisible then
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

  Prs:=TSQLParser.Create(EditorFrame.EditorText, TPGFunction(DBObject).OwnerDB);
  S:=UpperCase(Prs.GetNextWord);
  if S = 'BEGIN' then
  begin
    Prs.ParseScript(false);
    FSt:=Prs.StatementAtXY(EditorFrame.TextEditor.CaretX, EditorFrame.TextEditor.CaretY);
    if Assigned(FSt) and Assigned(FSt.SQLCommand) then
    begin
      if (FSt.SQLCommand is TSQLCommandAbstractSelect) then
      begin
        CDML:=TSQLCommandAbstractSelect(FSt.SQLCommand);
        for T in CDML.Tables do
          Items.Add(DBObject.OwnerDB.DBObjectByName(T.FullName));
          //Items.FillFieldList(DBObject.OwnerDB.DBObjectByName(T.FullName));
      end
      else
      if (FSt.SQLCommand is TSQLCommandDDL) then
      begin
        CDDL:=TSQLCommandDDL(FSt.SQLCommand);
        for T in CDDL.Tables do
          Items.Add(DBObject.OwnerDB.DBObjectByName(T.FullName));
//          Items.FillFieldList(DBObject.OwnerDB.DBObjectByName(T.FullName));
      end
    end;
  end;
  Prs.Free;
end;

procedure TfbmPostGreeFunctionEdtMainPage.SynGetFieldsList(
  Sender: Tfdbm_SynEditorFrame; const DBObjName: string;
  const Items: TSynCompletionObjList; ACharCase: TCharCaseOptions);
var
  P: TSQLParser;
  FSt: TSQLTextStatement;
  S: String;
  T: TTableItem;
begin
  P:=TSQLParser.Create(EditorFrame.EditorText, TPGFunction(DBObject).OwnerDB);
  S:=UpperCase(P.GetNextWord);
  if S = 'BEGIN' then
  begin
    P.ParseScript(false);
    FSt:=P.StatementAtXY(EditorFrame.TextEditor.CaretX, EditorFrame.TextEditor.CaretY);
    if Assigned(FSt) and Assigned(FSt.SQLCommand) and (FSt.SQLCommand is TSQLCommandAbstractSelect) then
    begin
      for T in TSQLCommandAbstractSelect(FSt.SQLCommand).Tables do
        if UpperCase(T.TableAlias) = UpperCase(DBObjName) then
          Items.FillFieldList(DBObject.OwnerDB.DBObjectByName(T.Name));
    end;
  end;
  P.Free;
end;

function TfbmPostGreeFunctionEdtMainPage.SynOnGetDBObjectByAlias(
  Sender: Tfdbm_SynEditorFrame; const ATableAlias: string; out DBObjName: string
  ): TDBObject;
var
  P: TSQLParser;
  FSt: TSQLTextStatement;
  S: String;
  T: TTableItem;
begin
  Result:=nil;
  DBObjName:='';

  P:=TSQLParser.Create(EditorFrame.EditorText, TPGFunction(DBObject).OwnerDB);
  S:=UpperCase(P.GetNextWord);
  if S = 'BEGIN' then
  begin
    P.ParseScript(false);
    FSt:=P.StatementAtXY(EditorFrame.TextEditor.CaretX, EditorFrame.TextEditor.CaretY);
    if Assigned(FSt) and Assigned(FSt.SQLCommand) and (FSt.SQLCommand is TSQLCommandAbstractSelect) then
    begin
      for T in TSQLCommandAbstractSelect(FSt.SQLCommand).Tables do
      begin
        if UpperCase(T.TableAlias) = UpperCase(ATableAlias) then
        begin
          Result:=TPGFunction(DBObject).OwnerDB.DBObjectByName(T.Name);
          if Assigned(Result) then
          begin
            DBObjName:=Result.Caption;
            break;
          end;
        end;
      end;
    end;
  end;
  P.Free;
end;

procedure TfbmPostGreeFunctionEdtMainPage.SynGetAliasList(
  Sender: Tfdbm_SynEditorFrame; const KeyStartWord: string;
  const Items: TSynCompletionObjList; ACharCase: TCharCaseOptions);
var
  FSt: TSQLTextStatement;
  i: Integer;
  DBObj:TDBObject;
begin
(*  P:=TSQLParser.Create(EditorFrame.EditorText, TPGFunction(DBObject).OwnerDB);
  S:=UpperCase(P.GetNextWord);
  if S = 'BEGIN' then
  begin
    P.ParseScript(false);
    FSt:=P.StatementAtXY(EditorFrame.TextEditor.CaretX, EditorFrame.TextEditor.CaretY);

    if Assigned(FSt) and Assigned(FSt.SQLCommand) and (FSt.SQLCommand is TSQLCommandAbstractSelect) then
    begin
      for i:=0 to TSQLCommandAbstractSelect(FSt.SQLCommand).Tables.Count - 1 do
        if UpperCase(TSQLCommandAbstractSelect(FSt.SQLCommand).Tables[i].TableAlias) <> UpperCase(TSQLCommandAbstractSelect(FSt.SQLCommand).Tables[i].Name) then
        begin
          if Items.IndexOf(TSQLCommandAbstractSelect(FSt.SQLCommand).Tables[i].TableAlias)<0 then
          begin
            DBObj:=TPGFunction(DBObject).OwnerDB.DBObjectByName(TSQLCommandAbstractSelect(FSt.SQLCommand).Tables[i].Name);
            if Assigned(DBObj) then
            begin
              Items.Insert(0, TSQLCommandAbstractSelect(FSt.SQLCommand).Tables[i].TableAlias);
              Items.Objects[0]:=DBObj;
            end;
          end;
        end;
    end;
  end;
  P.Free; *)

end;

procedure TfbmPostGreeFunctionEdtMainPage.LMEditorChangeParams(
  var message: TLMNoParams);
begin
  inherited;
  ChangeVisualParams;
end;

procedure TfbmPostGreeFunctionEdtMainPage.ChangeVisualParams;
begin
//  RadioGroup1.Controls[2].Enabled:=false;//
end;

procedure TfbmPostGreeFunctionEdtMainPage.DoAdd;
begin
  if PageControl1.ActivePage = TabSheet3 then
    FLocalVars.lvAdd.Execute
  else
    parAdd.Execute;
end;

procedure TfbmPostGreeFunctionEdtMainPage.DoEdit;
begin
  if PageControl1.ActivePageIndex = 2 then
  else
    parEdit.Execute;
end;

procedure TfbmPostGreeFunctionEdtMainPage.DoDelete;
begin
  if PageControl1.ActivePage = TabSheet3 then
    FLocalVars.lvDelete.Execute
  else
    parDel.Execute;
end;

function TfbmPostGreeFunctionEdtMainPage.CommentCode: boolean;
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

function TfbmPostGreeFunctionEdtMainPage.UnCommentCode: boolean;
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

procedure TfbmPostGreeFunctionEdtMainPage.TextEditorChange(Sender: TObject);
begin
  Modified:=true;
end;

procedure TfbmPostGreeFunctionEdtMainPage.DefinePopupMenu;
begin
  FMenuDefineVariable:=EditorFrame.CreateCTMenuItem(sDefineVariable, @DoTextEditorDefineVariable, 1);
  FMenuDefineInParam:=EditorFrame.CreateCTMenuItem(sDefineInParam, @DoTextEditorDefineVariable, 2);
  FMenuDefineOutParam:=EditorFrame.CreateCTMenuItem(sDefineOutParam, @DoTextEditorDefineVariable, 3);
  FMenuDefineInOutParam:=EditorFrame.CreateCTMenuItem(sDefineInOutParam, @DoTextEditorDefineVariable, 4);
end;

procedure TfbmPostGreeFunctionEdtMainPage.DoTextEditorDefineVariable(Sender: TObject);
var
  S: String;
  St: TStringList;
begin
  S:=Trim(EditorFrame.TextEditor.SelText);
  if TabSheet3.TabVisible and (S<>'') then
  begin
    St:=TStringList.Create;
    if Pos(',', S)>0 then
      StrToStrings(S, St, ',')
    else
      St.Add(S);

    for S in St do
    begin
      if IsValidIdent(Trim(S)) then
      begin
        if (Sender as TComponent).Tag = 1 then
        begin
          FLocalVars.AddVariable(Trim(S));
          PageControl1.ActivePage:=TabSheet3;
        end
        else
        begin
          if not rxParamList.Locate('ParName', Trim(S), [loCaseInsensitive]) then
          begin
            rxParamList.Append;
            rxParamListParName.AsString:=Trim(S);
            rxParamListInOut.AsInteger:=(Sender as TComponent).Tag - 1;
            rxParamList.Post;
          end;
          PageControl1.ActivePage:=TabSheet2;
        end
      end;
    end;
    St.Free;
  end;
end;

procedure TfbmPostGreeFunctionEdtMainPage.TextEditorPopUpMenu(Sender: TObject);
var
  S: String;
  F: Boolean;
  St: TStringList;
begin
  F:=TabSheet3.TabVisible;
  if F then
  begin
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
  end;
  FMenuDefineVariable.Enabled:=F;
  FMenuDefineInParam.Enabled:=F;
  FMenuDefineOutParam.Enabled:=F;
  FMenuDefineInOutParam.Enabled:=F;
end;

function TfbmPostGreeFunctionEdtMainPage.PGFunctionGetHintData(
  Sender: Tfdbm_SynEditorFrame; const S1, S2: string; out HintText: string
  ): Boolean;
var
  P: TBookMark;
begin
  if (S2 = '') and (S1<>'') then
  begin
    rxParamList.DisableControls;
    P:=rxParamList.Bookmark;
    if rxParamList.Locate('ParName', S1, [loCaseInsensitive]) then
    begin
      Result:=true;
      HintText:=sParameter + ' : ' + ParamTypeFuncToStr(TSPVarType(rxParamListInOut.AsInteger)) + ' ' + rxParamListParName.AsString + ' ' + rxParamListType.AsString;
      if rxParamListDesc.AsString <> '' then
        HintText:=HintText +LineEnding + '---------------------------------------' + LineEnding + rxParamListDesc.AsString;
    end;
    rxParamList.Bookmark:=P;
    rxParamList.EnableControls;
    if Result then Exit;


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

function TfbmPostGreeFunctionEdtMainPage.PageName: string;
begin
  Result:=sFunction;
end;

constructor TfbmPostGreeFunctionEdtMainPage.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);

  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=Self;
  EditorFrame.SQLEngine:=DBObject.OwnerDB;
  EditorFrame.OnGetKeyWordList:=@SynGetKeyWordList;
  EditorFrame.OnGetObjAliasList:=@SynGetAliasList;
  EditorFrame.OnGetFieldsList:=@SynGetFieldsList;
  EditorFrame.OnGetDBObjectByAlias:=@SynOnGetDBObjectByAlias;
  EditorFrame.TextEditor.OnChange:=@TextEditorChange;
  EditorFrame.OnPopUpMenu:=@TextEditorPopUpMenu;
  EditorFrame.OnGetHintData:=@PGFunctionGetHintData;

  DefinePopupMenu;

  FLocalVars:=TfbmPGLocalVarsEditorFrame.Create(Self);
  FLocalVars.Parent:=TabSheet3;
  FLocalVars.Align:=alClient;
  FLocalVars.OwnerDB:=TPGFunction(DBObject).OwnerDB;

  TabSheet3.TabVisible:=TSQLEnginePostgre(TPGFunction(DBObject).OwnerDB).SPEditLazzyMode;
  PageControl1.ActivePageIndex:=Ord(DBObject.State <> sdboCreate);
  FLocalVars.Localize;
  RefreshObject;
end;

function TfbmPostGreeFunctionEdtMainPage.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaAdd, epaEdit, epaDelete, epaRefresh, epaPrint,
                         epaCompile, epaComment, epaUnComment];
end;

function TfbmPostGreeFunctionEdtMainPage.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaAdd:DoAdd;
    epaEdit:DoEdit;
    epaDelete:DoDelete;
    epaPrint:PrintPage;
    epaRefresh:RefreshObject;
    epaComment:Result:=CommentCode;
    epaUnComment:Result:=UnCommentCode;
  else
    Result:=false;
  end;
end;

procedure TfbmPostGreeFunctionEdtMainPage.Localize;
begin
  Label1.Caption:=sFunctionName;
  Label2.Caption:=sReturnType;
  Label3.Caption:=sLanguage;
  Label5.Caption:=sAVGTime;
  Label4.Caption:=sAVGLines;
  Label6.Caption:=sTimeLife;
  cbIsWindow.Caption:=sIsWindowFunction;
  CheckBox2.Caption:=sRunAsOwner;
  cbIsStrict.Caption:=sReturnNullForEmptyResult;
  RadioGroup1.Caption:=sTypeReturns;
  RadioGroup1.Items[0]:=sTypeReturns1;
  RadioGroup1.Items[1]:=sTypeReturns2;
  RadioGroup1.Items[2]:=sTypeReturns3;
  TabSheet1.Caption:=sDeclaration;
  TabSheet2.Caption:=sParams;
  TabSheet3.Caption:=sLocalVariables;

  parAdd.Caption:=sAddParam;
  parEdit.Caption:=sEditParam;
  parDel.Caption:=sDeleteParam;
  parMoveUp.Caption:=sMoveUp;
  parMoveDown.Caption:=sMoveDown;
  parPrintList.Caption:=sPrintParams;
  parAdd.Hint:=sAddParam;
  parEdit.Hint:=sEditParam;
  parDel.Hint:=sDeleteParam;
  parMoveUp.Hint:=sMoveUp;
  parMoveDown.Hint:=sMoveDown;
  parPrintList.Hint:=sPrintParams;

  RxDBGrid1.ColumnByFieldName('ParName').Title.Caption:=sParamName;
  RxDBGrid1.ColumnByFieldName('Type').Title.Caption:=sParamType;
  RxDBGrid1.ColumnByFieldName('DefValue').Title.Caption:=sDefaultValue;
  RxDBGrid1.ColumnByFieldName('Desc').Title.Caption:=sDescription;

  ChangeVisualParams;
end;

function TfbmPostGreeFunctionEdtMainPage.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  F: TSQLParserField;
  FCmd : TPGSQLCreateFunction absolute ASQLObject;
  aSql: String;
  P: TDBField;
  D: TDBDomain;
  FCntOutput: Integer;
begin
  Result:=false;
  FParamModified:=false;
  if not (ASQLObject is TPGSQLCreateFunction) then exit;

  if TabSheet3.TabVisible then
    if not FLocalVars.Validate then
    begin
      PageControl1.ActivePage:=TabSheet3;
      ErrorBox(sErrorVariableDefenition);
      Exit;
    end;

  if (DBObject.State = sdboEdit)  then
  begin

    FParamModified:=TPGFunction(DBObject).FieldsIN.Count <> rxParamList.RecordCount;

    if RadioGroup1.ItemIndex <> Ord(TPGFunction(DBObject).ReturnSetType) then
        FParamModified:=true;

    if Assigned(TPGFunction(DBObject).ResultType) then
    begin
      if Assigned(TPGFunction(DBObject).ResultType.FieldDomain) then
        FParamModified := FParamModified or (cbRetType.Text <> TPGFunction(DBObject).ResultType.FieldDomain.CaptionFullPatch)
      else
        FParamModified := FParamModified or (cbRetType.Text <> TPGFunction(DBObject).ResultType.FieldTypeRecord.TypeName);
    end;
  end
  else
  begin
    if Pos('"', edtName.Text) = 0 then
      FCmd.Name:=LowerCase(edtName.Text)
    else
      FCmd.Name:=LowerCase(edtName.Text)
  end;

  FCntOutput:=0;
  rxParamList.First;
  while not rxParamList.EOF do
  begin
    F:=ASQLObject.Params.AddParamWithType(rxParamListParName.AsString, rxParamListType.AsString);
    F.InReturn:=TSPVarType(rxParamListInOut.AsInteger);
    if F.InReturn in [spvtOutput, spvtInOut] then
      Inc(FCntOutput);

    F.Description:=rxParamListDesc.AsString;
    if rxParamListOldParType.AsString<>rxParamListType.AsString then
      FParamModified:=true;
    if rxParamListParName.AsString <> rxParamListOldParName.AsString then
      FParamModified:=true;
    rxParamList.Next;
  end;
  rxParamList.First;

  aSql:='';
  if TabSheet3.TabVisible then
    aSql:=aSql + FLocalVars.VriablesList(true);
  FCmd.Body:=aSql + Trim(EditorFrame.EditorText)+LineEnding;
  FCmd.Language:=cbLang.Text;
  FCmd.VolatilityCategories:=TPGSPVolatCat(cbVolatCat.ItemIndex+1);
  FCmd.Cost:=edtAVGTime.Value;

  if cbIsStrict.Checked then
    FCmd.Strict:=srStrict;
  FCmd.isWindow:=cbIsWindow.Checked;

  if (RadioGroup1.ItemIndex>0)  then
    FCmd.AVGRows:=edtAVGRows.Value;
  FCmd.SetOF:=RadioGroup1.ItemIndex = 1;

  if FCntOutput > 1 then
  begin
    F:=FCmd.Output.AddParam('');
    F.TypeName:='record';
  end
  else
  begin
    F:=FCmd.Output.AddParam('');
    F.TypeName:=cbRetType.Text;
  end;
{
    case RadioGroup1.ItemIndex of
      1:aSql := aSql + 'SETOF ';
      2:aSql := aSql + 'TABLE ';
    end;
}
  Result:=true;
  if FParamModified and (DBObject.State = sdboEdit) then
  begin
    FCmd.PGSQLDropFunction.SchemaName:=DBObject.SchemaName;
    FCmd.PGSQLDropFunction.Name:=DBObject.Caption;

    for P in TPGFunction(DBObject).FieldsIN do
    begin
      F:=FCmd.PGSQLDropFunction.Params.AddParam(P.FieldName);
      F.InReturn:=P.IOType;

      if Assigned(P.FieldTypeRecord) then
        F.TypeName:=P.FieldTypeRecord.TypeName
      else
      begin
        D:=P.FieldDomain;
        if Assigned(D) then
          F.TypeName:=D.CaptionFullPatch
        else
        begin
          ErrorBoxExt('Result type not defined for param %s', [P.FieldName]);
          F.TypeName:='';
          Result:=false;
        end;
      end;
    end;
  end
  else
    if (DBObject.State = sdboEdit)  then
      FCmd.CreateMode:=cmCreateOrAlter;
end;

end.

