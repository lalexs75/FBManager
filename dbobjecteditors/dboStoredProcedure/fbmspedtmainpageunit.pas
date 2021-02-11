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

unit fbmSPEdtMainPageUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, fdmAbstractEditorUnit,
  fbmToolsUnit, Controls, ActnList, ExtCtrls, ComCtrls, Menus, StdCtrls, db,
  rxtoolbar, SQLEngineCommonTypesUnit, rxmemds, rxdbgrid, sqlObjects,
  SQLEngineAbstractUnit, fbmSqlParserUnit, fdbm_SynEditorUnit, FBSQLEngineUnit,
  fbmFBVariableFrameUnit;

type

  { TfbmSPEdtMainPageFrame }

  TfbmSPEdtMainPageFrame = class(TEditorPage)
    ActionList1: TActionList;
    edtProcName: TEdit;
    Label1: TLabel;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    MenuItem32: TMenuItem;
    MenuItem33: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    PageControl1: TPageControl;
    rxLocalVarsParCodePage: TStringField;
    rxLocalVarsParDefValue: TStringField;
    rxLocalVarsParDesc: TStringField;
    rxLocalVarsParName: TStringField;
    rxLocalVarsParPrec: TLongintField;
    rxLocalVarsParSize: TLongintField;
    rxLocalVarsParSubType: TLongintField;
    rxLocalVarsParType: TStringField;
    rxLocalVarsParTypeOf: TBooleanField;
    rxParamListDefValue1: TStringField;
    rxParamListDesc1: TStringField;
    rxParamListID1: TLongintField;
    rxParamListInOut1: TLongintField;
    rxParamListInputParTypeOf: TBooleanField;
    rxParamListInputOldParName: TStringField;
    rxParamListInputOldParType: TStringField;
    rxParamListInputParCodePage: TStringField;
    rxParamListInputParDefValue: TStringField;
    rxParamListInputParDesc: TStringField;
    rxParamListInputParName: TStringField;
    rxParamListInputParPrec: TLongintField;
    rxParamListInputParSize: TLongintField;
    rxParamListInputParSubType: TLongintField;
    rxParamListInputParType: TStringField;
    rxParamListOldParName1: TStringField;
    rxParamListOldParType1: TStringField;
    rxParamListOutputOldParName: TStringField;
    rxParamListOutputOldParType: TStringField;
    rxParamListOutputParCodePage: TStringField;
    rxParamListOutputParDesc: TStringField;
    rxParamListOutputParName: TStringField;
    rxParamListOutputParPrec: TLongintField;
    rxParamListOutputParSize: TLongintField;
    rxParamListOutputParSubType: TLongintField;
    rxParamListOutputParType: TStringField;
    rxParamListOutputParTypeOf: TBooleanField;
    rxParamListParName1: TStringField;
    rxParamListType1: TStringField;
    Splitter1: TSplitter;
    tabInputParams: TTabSheet;
    tabReturnParams: TTabSheet;
    tabLocalVars: TTabSheet;
    tabHeader: TTabSheet;
  private
    FOldHight:integer;
    EditorFrame:Tfdbm_SynEditorFrame;
    InputParFrame:TfbmFBVariableFrame;
    OutputParFrame:TfbmFBVariableFrame;
    VariableFrame:TfbmFBVariableFrame;
    FMenuDefineVariable: TMenuItem;
    FMenuDefineInParam: TMenuItem;
    FMenuDefineOutParam: TMenuItem;
    procedure PrintPage;
    procedure UpdateEnvOptions;override;
    procedure RefreshObject;
    function ParseLocalVariable(SqlLine: String): string;
    procedure SynGetKeyWordList(Sender:Tfdbm_SynEditorFrame; const KeyStartWord:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);

    function CommentCode:boolean;
    function UnCommentCode:boolean;

    procedure DefinePopupMenu;
    procedure DoTextEditorDefineVariable(Sender: TObject);
    procedure TextEditorPopUpMenu(Sender: TObject);
    procedure TextEditorChange(Sender: TObject);
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses rxAppUtils, ibmanagertypesunit, fbmStrConstUnit, LR_Class, IBManMainUnit, fb_SqlParserUnit,
  ibmSqlUtilsUnit, fb_ConstUnit;

{$R *.lfm}

{ TfbmSPEdtMainPageFrame }

procedure TfbmSPEdtMainPageFrame.PrintPage;
begin
  frVariables['DBClassTitle']:=DBObject.DBClassTitle;
  frVariables['ObjectName']:=DBObject.Caption;
  frVariables['ProcBody']:=EditorFrame.EditorText;
  fbManagerMainForm.LazReportPrint('DBObject_StoredProc');
end;

function TfbmSPEdtMainPageFrame.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  SP: TFBSQLCreateProcedure;
begin
  Result:=false;
  if ASQLObject is TFBSQLCreateProcedure then
  begin
    if not (InputParFrame.Validate and OutputParFrame.Validate and  VariableFrame.Validate) then exit;

    SP:=TFBSQLCreateProcedure(ASQLObject);
    SP.Name:=edtProcName.Text;
    SP.Body:=EditorFrame.EditorText;

    if DBObject.State = sdboEdit then
      SP.Options:=Sp.Options + [ooOrReplase];

    InputParFrame.SaveParams(SP.Params);
    OutputParFrame.SaveParams(SP.Params);
    VariableFrame.SaveParams(SP.Params);
    Result:=true;
  end
  else
    ErrorBox('TfbmSPEdtMainPageFrame.SetupSQLObject');
end;

procedure TfbmSPEdtMainPageFrame.UpdateEnvOptions;
begin
  EditorFrame.ChangeVisualParams;
end;

procedure TfbmSPEdtMainPageFrame.RefreshObject;
var
  F: TDBField;
begin
  //Заполним список входных параметров
  for F in TFireBirdStoredProc(DBObject).FieldsIN do
    InputParFrame.AddParam(F);

  //Сформируем список выходных параметров
  for F in TFireBirdStoredProc(DBObject).FieldsOut do
    OutputParFrame.AddParam(F);

  EditorFrame.EditorText:=ParseLocalVariable(TFireBirdStoredProc(DBObject).ProcedureBody);

  edtProcName.Text:=DBObject.Caption;
  tabHeader.TabVisible := DBObject.State <> sdboEdit;
  if not tabHeader.TabVisible then
    if PageControl1.ActivePage = tabHeader then
      PageControl1.ActivePageIndex:=1;
end;

function TfbmSPEdtMainPageFrame.ParseLocalVariable(SqlLine: String): string;
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

procedure TfbmSPEdtMainPageFrame.SynGetKeyWordList(
  Sender: Tfdbm_SynEditorFrame; const KeyStartWord: string;
  const Items: TSynCompletionObjList; ACharCase: TCharCaseOptions);
var
  LVP: TFBLocalVariableParser;
  P: TSQLParserField;
begin
  InputParFrame.FillSynGetKeyWordList(KeyStartWord, Items);
  OutputParFrame.FillSynGetKeyWordList(KeyStartWord, Items);

  if tabLocalVars.TabVisible then
    VariableFrame.FillSynGetKeyWordList(KeyStartWord, Items)
  else
  begin
    LVP:=TFBLocalVariableParser.Create(nil);
    try
      LVP.ParseLocalVarsEx(EditorFrame.EditorText);
      for P in LVP.Params do
        if (KeyStartWord = '') or (CompareText(P.Caption, KeyStartWord) = 0) then
          Items.Add(P);
    finally
      LVP.Free;
    end;
  end;
end;

function TfbmSPEdtMainPageFrame.CommentCode: boolean;
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

function TfbmSPEdtMainPageFrame.UnCommentCode: boolean;
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

procedure TfbmSPEdtMainPageFrame.DefinePopupMenu;
begin
  FMenuDefineVariable:=EditorFrame.CreateCTMenuItem(sDefineVariable, @DoTextEditorDefineVariable, 1);
  FMenuDefineInParam:=EditorFrame.CreateCTMenuItem(sDefineInParam, @DoTextEditorDefineVariable, 2);
  FMenuDefineOutParam:=EditorFrame.CreateCTMenuItem(sDefineOutParam, @DoTextEditorDefineVariable, 3);
end;

procedure TfbmSPEdtMainPageFrame.DoTextEditorDefineVariable(Sender: TObject);
var
  S: String;
begin
  S:=Trim(EditorFrame.TextEditor.SelText);
  if (S<>'') and IsValidIdent(S) then
  if (Sender as TComponent).Tag = 1 then
  begin
    if tabLocalVars.TabVisible then
    begin
      VariableFrame.AddVariable(S);
      PageControl1.ActivePage:=tabLocalVars;
    end;
  end
  else
  if (Sender as TComponent).Tag = 2 then
  begin
    InputParFrame.AddVariable(S);
    PageControl1.ActivePage:=tabInputParams;
  end
  else
  if (Sender as TComponent).Tag = 3 then
  begin
    OutputParFrame.AddVariable(S);
    PageControl1.ActivePage:=tabReturnParams;
  end;
end;

procedure TfbmSPEdtMainPageFrame.TextEditorPopUpMenu(Sender: TObject);
var
  S: String;
begin
  S:=Trim(EditorFrame.TextEditor.SelText);
  FMenuDefineVariable.Enabled:=tabLocalVars.TabVisible and (S<>'') and IsValidIdent(S);
  FMenuDefineInParam.Enabled:=FMenuDefineVariable.Enabled;
  FMenuDefineOutParam.Enabled:=FMenuDefineVariable.Enabled;
end;

procedure TfbmSPEdtMainPageFrame.TextEditorChange(Sender: TObject);
begin
  Modified:=true;
end;

function TfbmSPEdtMainPageFrame.PageName: string;
begin
  Result:=sStoredProcedure;
end;


constructor TfbmSPEdtMainPageFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=Self;
  EditorFrame.SQLEngine:=DBObject.OwnerDB;
  EditorFrame.OnGetKeyWordList:=@SynGetKeyWordList;
  EditorFrame.TextEditor.OnChange:=@TextEditorChange;
  EditorFrame.OnPopUpMenu:=@TextEditorPopUpMenu;
  DefinePopupMenu;

  PageControl1.Align:=alTop;
  PageControl1.Height:=200;
  PageControl1.ActivePageIndex:=0;


  EditorFrame.SQLEngine:=DBObject.OwnerDB;

  InputParFrame:=TfbmFBVariableFrame.Create(Self, DBObject, spvtInput);
  InputParFrame.Parent:=tabInputParams;
  InputParFrame.Align:=alClient;

  OutputParFrame:=TfbmFBVariableFrame.Create(Self, DBObject, spvtOutput);
  OutputParFrame.Parent:=tabReturnParams;
  OutputParFrame.Align:=alClient;

  VariableFrame:=TfbmFBVariableFrame.Create(Self, DBObject, spvtLocal);
  VariableFrame.Parent:=tabLocalVars;
  VariableFrame.Align:=alClient;

  RefreshObject;
end;

function TfbmSPEdtMainPageFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaCompile, epaPrint, epaRefresh, epaComment, epaUnComment];
end;

function TfbmSPEdtMainPageFrame.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:PrintPage;
    epaComment:Result:=CommentCode;
    epaUnComment:Result:=UnCommentCode;
  end;
end;

procedure TfbmSPEdtMainPageFrame.Localize;
begin
  inherited Localize;
  Label1.Caption:=sStoredProcedureName;
  tabHeader.Caption:=sDeclaration;
  tabInputParams.Caption:=sInputParams;
  tabReturnParams.Caption:=sReturnParams;
  tabLocalVars.Caption:=sLocalVariables;
end;

end.

