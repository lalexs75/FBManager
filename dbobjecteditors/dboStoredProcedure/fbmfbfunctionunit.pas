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

unit fbmFBFunctionUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  ExtCtrls, PairSplitter, ActnList, Buttons, Menus, db, rxmemds, rxdbgrid,
  SQLEngineCommonTypesUnit, sqlObjects, fdmAbstractEditorUnit, fb_SqlParserUnit,
  SQLEngineAbstractUnit, fbmSqlParserUnit, fdbm_SynEditorUnit, FBSQLEngineUnit,
  fbmFBVariableFrameUnit;

type

  { TfbmFBFunctionEditor }

  TfbmFBFunctionEditor = class(TEditorPage)
    dsSubRout: TDataSource;
    Label4: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    PopupMenu1: TPopupMenu;
    RxDBGrid1: TRxDBGrid;
    rxSubRout: TRxMemoryData;
    rxSubRoutSR_BODY: TMemoField;
    rxSubRoutSR_NAME: TStringField;
    rxSubRoutSR_TYPE: TLongintField;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    srDelete: TAction;
    srNew: TAction;
    ActionList1: TActionList;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    edtFuncName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    PageControl1: TPageControl;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    Splitter1: TSplitter;
    tabHeader: TTabSheet;
    tabInputParams: TTabSheet;
    tabLocalVar: TTabSheet;
    tabSubRoutines: TTabSheet;
    procedure rxSubRoutAfterScroll(DataSet: TDataSet);
    procedure rxSubRoutBeforeScroll(DataSet: TDataSet);
    procedure srDeleteExecute(Sender: TObject);
    procedure srNewExecute(Sender: TObject);
  private
    EditorFrame:Tfdbm_SynEditorFrame;
    NFEditorFrame:Tfdbm_SynEditorFrame;
    InputParFrame:TfbmFBVariableFrame;
    VariableFrame:TfbmFBVariableFrame;
    FMenuDefineVariable: TMenuItem;
    FMenuDefineInParam: TMenuItem;
    FLVParser:TFBLocalVariableParser;
    procedure PrintPage;
    procedure RefreshObject;
    function ParseLocalVariable(SqlLine: String): string;
    procedure SynGetKeyWordList(Sender:Tfdbm_SynEditorFrame; const KeyStartWord:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);

    function CommentCode:boolean;
    function UnCommentCode:boolean;
    procedure TextEditorChange(Sender: TObject);

    procedure DefinePopupMenu;
    procedure DoTextEditorDefineVariable(Sender: TObject);
    procedure TextEditorPopUpMenu(Sender: TObject);
  public
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    destructor Destroy; override;

    function PageName:string;override;
    procedure UpdateEnvOptions;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses rxAppUtils, ibmanagertypesunit, fbmStrConstUnit, LR_Class, IBManMainUnit,
  ibmSqlUtilsUnit, fbmToolsUnit, fb_ConstUnit, fb_utils, fbSqlTextUnit;

{$R *.lfm}

{ TfbmFBFunctionEditor }

procedure TfbmFBFunctionEditor.rxSubRoutAfterScroll(DataSet: TDataSet);
var
  P: TSQLParserField;
begin
  if rxSubRout.Active and (rxSubRout.RecordCount > 0) then
  begin
    FLVParser.Clear;
    P:=FLVParser.Params.AddParam(rxSubRoutSR_NAME.AsString);
    P.InReturn:=TSPVarType(rxSubRoutSR_TYPE.AsInteger);
    P.CheckExpr:=rxSubRoutSR_BODY.AsString;
    NFEditorFrame.EditorText:=FLVParser.AsSQL;
    NFEditorFrame.Modified:=false;
  end;
end;

procedure TfbmFBFunctionEditor.rxSubRoutBeforeScroll(DataSet: TDataSet);
var
  P: TSQLParserField;
begin
  if rxSubRout.RecordCount = 0 then Exit;
  FLVParser.Clear;
  FLVParser.ParseLocalVarsEx(NFEditorFrame.EditorText);
  if (FLVParser.Params.Count>0) and NFEditorFrame.Modified then
  begin
    P:=FLVParser.Params[0];
    rxSubRout.Edit;
    rxSubRoutSR_TYPE.AsInteger:=Ord(P.InReturn);
    rxSubRoutSR_BODY.AsString:=P.CheckExpr;
    rxSubRoutSR_NAME.AsString:=P.Caption;
    rxSubRout.Post;
  end;
end;

procedure TfbmFBFunctionEditor.srDeleteExecute(Sender: TObject);
begin
  if (not rxSubRout.Active) or (rxSubRout.RecordCount = 0) then Exit;
  if QuestionBoxFmt(sDeleteFunctionQ, [rxSubRoutSR_NAME.AsString]) then
    rxSubRout.Delete;
end;

procedure TfbmFBFunctionEditor.srNewExecute(Sender: TObject);
begin
  if QuestionBox(sAppendFunctionQ) then
  begin
    rxSubRout.Append;
    rxSubRoutSR_TYPE.AsInteger:=Ord(spvtSubFunction);
    rxSubRoutSR_BODY.AsString:='() returns integer'+LineEnding+'as'+LineEnding+'begin'+LineEnding+'  return 0;'+LineEnding+'end';
    rxSubRoutSR_NAME.AsString:='new_function';
    rxSubRout.Post;
    rxSubRoutAfterScroll(nil);
  end;
end;

procedure TfbmFBFunctionEditor.PrintPage;
begin

end;

procedure TfbmFBFunctionEditor.UpdateEnvOptions;
begin
  inherited UpdateEnvOptions;
  EditorFrame.ChangeVisualParams;
end;

procedure TfbmFBFunctionEditor.RefreshObject;
var
  F, R: TDBField;
begin
  //
  InputParFrame.Clear;

  DBObject.OwnerDB.TypeList.FillForTypes(ComboBox2.Items, true);
  DBObject.OwnerDB.FillListForNames(ComboBox2.Items, [okDomain]);
  //DBObject.OwnerDB.FillDomainsList(ComboBox2.Items, false);

  //Заполним список входных параметров
  for F in TFireBirdFunction(DBObject).FieldsIN do
    InputParFrame.AddParam(F);

  //Сформируем список выходных параметров

  if DBObject.State <> sdboCreate then
  begin
    EditorFrame.EditorText:=ParseLocalVariable(TFireBirdFunction(DBObject).ProcedureBody);
    edtFuncName.Text:=TFireBirdFunction(DBObject).CaptionFullPatch;
    CheckBox1.Checked:=TFireBirdFunction(DBObject).Deterministic;
    R:=TFireBirdFunction(DBObject).RetunValue;
    if Assigned(R) then
    begin
      ComboBox2.Text:=R.FieldTypeName;
      ComboBox1.Text:=R.FieldCollateName;
    end;
  end
  else
  begin
    if tabLocalVar.TabVisible then
      EditorFrame.EditorText:=ConfigValues.ByNameAsString('ObjTemplate/FireBirdSQL/Function/Lazy', fbSqlModule.fbtFunctionLazy.Strings.Text)
    else
      EditorFrame.EditorText:=ConfigValues.ByNameAsString('ObjTemplate/FireBirdSQL/Function/Normal', fbSqlModule.fbtFunction.Strings.Text);
  end;
end;

function TfbmFBFunctionEditor.ParseLocalVariable(SqlLine: String): string;
var
  LVP: TFBLocalVariableParser;
  K: Integer;
  P: TSQLParserField;
begin
  LVP:=TFBLocalVariableParser.Create(nil);
  K:=LVP.ParseLocalVarsEx(SqlLine);
  Result:=Copy(SqlLine, K, Length(SqlLine));
  VariableFrame.LoadParams(LVP.Params);

  rxSubRout.AfterScroll:=nil;
  rxSubRout.BeforeScroll:=nil;
  rxSubRout.CloseOpen;
  for P in LVP.Params do
  begin
    if P.InReturn in [spvtSubFunction, spvtSubProc] then
    begin
      rxSubRout.Append;
      rxSubRoutSR_TYPE.AsInteger:=Ord(P.InReturn);
      rxSubRoutSR_NAME.AsString:=P.Caption;
      rxSubRoutSR_BODY.AsString:=P.CheckExpr;
      rxSubRout.Post;
    end;
  end;
  rxSubRout.AfterScroll:=@rxSubRoutAfterScroll;
  rxSubRout.BeforeScroll:=@rxSubRoutBeforeScroll;
  rxSubRoutAfterScroll(nil);

  LVP.Free;
end;

procedure TfbmFBFunctionEditor.SynGetKeyWordList(Sender: Tfdbm_SynEditorFrame;
  const KeyStartWord: string; const Items: TSynCompletionObjList;
  ACharCase: TCharCaseOptions);
var
  LVP: TFBLocalVariableParser;
  P: TSQLParserField;
  BM: TBookMark;
begin
  InputParFrame.FillSynGetKeyWordList(KeyStartWord, Items);
  //OutputParFrame.FillSynGetKeyWordList(KeyStartWord, Items);

  if tabLocalVar.TabVisible then
    VariableFrame.FillSynGetKeyWordList(KeyStartWord, Items)
  else
  begin
    LVP:=TFBLocalVariableParser.Create(nil);
    try
      LVP.ParseLocalVarsEx(EditorFrame.EditorText);
      for P in LVP.Params do
        if (KeyStartWord = '') or (UpperCase(Copy(P.Caption, 1, Length(KeyStartWord))) = KeyStartWord) then
          Items.Add(P);
    finally
      LVP.Free;
    end;
  end;

  if tabSubRoutines.TabVisible then
  begin
    BM:=rxSubRout.Bookmark;
    try
      rxSubRout.AfterScroll:=nil;
      rxSubRout.BeforeScroll:=nil;
      if tabSubRoutines.TabVisible then
      begin
        rxSubRout.First;
        while not rxSubRout.EOF do
        begin
          if (KeyStartWord = '') or (UpperCase(Copy(rxSubRoutSR_NAME.AsString, 1, Length(KeyStartWord))) = KeyStartWord) then
            Items.Add(scotParam, rxSubRoutSR_NAME.AsString, '', '');
          rxSubRout.Next;
        end;
      end;
      rxSubRout.AfterScroll:=@rxSubRoutAfterScroll;
      rxSubRout.BeforeScroll:=@rxSubRoutBeforeScroll;
    finally
      rxSubRout.Bookmark:=BM;
    end;
  end;
end;

function TfbmFBFunctionEditor.CommentCode: boolean;
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

function TfbmFBFunctionEditor.UnCommentCode: boolean;
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

procedure TfbmFBFunctionEditor.TextEditorChange(Sender: TObject);
begin
  Modified:=true;
end;

procedure TfbmFBFunctionEditor.DefinePopupMenu;
begin
  FMenuDefineVariable:=EditorFrame.CreateCTMenuItem(sDefineVariable, @DoTextEditorDefineVariable, 1);
  FMenuDefineInParam:=EditorFrame.CreateCTMenuItem(sDefineInParam, @DoTextEditorDefineVariable, 2);
end;

procedure TfbmFBFunctionEditor.DoTextEditorDefineVariable(Sender: TObject);
var
  S: String;
begin
  S:=Trim(EditorFrame.TextEditor.SelText);
  if (S<>'') and IsValidIdent(S) then
  if (Sender as TComponent).Tag = 1 then
  begin
    if tabLocalVar.TabVisible then
    begin
      VariableFrame.AddVariable(S);
      PageControl1.ActivePage:=tabLocalVar;
    end;
  end
  else
  if (Sender as TComponent).Tag = 2 then
  begin
    InputParFrame.AddVariable(S);
    PageControl1.ActivePage:=tabInputParams;
  end
end;

procedure TfbmFBFunctionEditor.TextEditorPopUpMenu(Sender: TObject);
var
  S: String;
begin
  S:=Trim(EditorFrame.TextEditor.SelText);
  FMenuDefineVariable.Enabled:=tabLocalVar.TabVisible and (S<>'') and IsValidIdent(S);
  FMenuDefineInParam.Enabled:=FMenuDefineVariable.Enabled;
end;

function TfbmFBFunctionEditor.PageName: string;
begin
  Result:=sFunction;
end;

constructor TfbmFBFunctionEditor.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  PageControl1.ActivePageIndex:=0;

  tabSubRoutines.TabVisible:=TSQLEngineFireBird(DBObject.OwnerDB).ServerVersion in [gds_verFirebird3_0];
  if tabSubRoutines.TabVisible then
    rxSubRout.Open;

  FLVParser:=TFBLocalVariableParser.Create(nil);

  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Name:='EditorFrame';
  EditorFrame.Parent:=Self;
  EditorFrame.SQLEngine:=DBObject.OwnerDB;
  EditorFrame.OnGetKeyWordList:=@SynGetKeyWordList;
  EditorFrame.TextEditor.OnChange:=@TextEditorChange;
  EditorFrame.OnPopUpMenu:=@TextEditorPopUpMenu;
  DefinePopupMenu;

  NFEditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  NFEditorFrame.Name:='NFEditorFrame';
  NFEditorFrame.Parent:=PairSplitterSide2;
  NFEditorFrame.SQLEngine:=DBObject.OwnerDB;
  NFEditorFrame.OnGetKeyWordList:=@SynGetKeyWordList;
  NFEditorFrame.TextEditor.OnChange:=@TextEditorChange;

  PageControl1.Align:=alTop;
  PageControl1.Height:=200;
  PageControl1.ActivePageIndex:=0;


  EditorFrame.SQLEngine:=DBObject.OwnerDB;

  InputParFrame:=TfbmFBVariableFrame.Create(Self, DBObject, spvtInput);
  InputParFrame.Parent:=tabInputParams;
  InputParFrame.Align:=alClient;

  VariableFrame:=TfbmFBVariableFrame.Create(Self, DBObject, spvtLocal);
  VariableFrame.Parent:=tabLocalVar;
  VariableFrame.Align:=alClient;

  RefreshObject;
end;

destructor TfbmFBFunctionEditor.Destroy;
begin
  FreeAndNil(FLVParser);
  inherited Destroy;
end;

function TfbmFBFunctionEditor.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaCompile, epaPrint, epaRefresh, epaComment, epaUnComment];
end;

function TfbmFBFunctionEditor.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:PrintPage;
    epaComment:Result:=CommentCode;
    epaUnComment:Result:=UnCommentCode;
    epaRefresh:RefreshObject;
  end;
end;

procedure TfbmFBFunctionEditor.Localize;
begin
  inherited Localize;
  Label1.Caption:=sStoredProcedureName;
  CheckBox1.Caption:=sDeterministic;
  tabHeader.Caption:=sDeclaration;
  tabInputParams.Caption:=sInputParams;
  tabLocalVar.Caption:=sLocalVariables;
  tabSubRoutines.Caption:=sSubroutines;
  srDelete.Hint:=sDeleteFunctionHint;
  srNew.Hint:=sAppendFunctionHint;
end;

function TfbmFBFunctionEditor.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  SP: TFBSQLCreateFunction;
  P: TSQLParserField;
begin
  Result:=false;
  if ASQLObject is TFBSQLCreateFunction then
  begin
    if not (InputParFrame.Validate and VariableFrame.Validate) then exit;

    SP:=TFBSQLCreateFunction(ASQLObject);
    SP.Name:=edtFuncName.Text;
    SP.Body:=EditorFrame.EditorText;

    if DBObject.State = sdboEdit then
      SP.CreateMode:=cmCreateOrAlter;

    InputParFrame.SaveParams(SP.Params);

    rxSubRout.AfterScroll:=nil;
    rxSubRout.BeforeScroll:=nil;
    if tabSubRoutines.TabVisible then
    begin
      if NFEditorFrame.Modified then
        rxSubRoutBeforeScroll(nil);

      rxSubRout.First;
      while not rxSubRout.EOF do
      begin
        P:=SP.Params.AddParam(rxSubRoutSR_NAME.AsString);
        P.InReturn:=TSPVarType(rxSubRoutSR_TYPE.AsInteger);
        P.CheckExpr:=rxSubRoutSR_BODY.AsString;
        rxSubRout.Next;
      end;
    end;
    rxSubRout.AfterScroll:=@rxSubRoutAfterScroll;
    rxSubRout.BeforeScroll:=@rxSubRoutBeforeScroll;

    SP.Deterministic:=CheckBox1.Checked;
    SP.ReturnType:=ComboBox2.Text;

    VariableFrame.SaveParams(SP.Params);
    Result:=true;
  end
  else
    ErrorBox('TfbmFBFunctionEditor.SetupSQLObject');
end;

end.

