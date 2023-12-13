{ Free DB Manager

  Copyright (C) 2005-2023 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fdbm_SynEditorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Menus, ActnList, Dialogs,
  SynEdit, fbmToolsUnit, LMessages, Controls, SynCompletion, SynHighlighterSQL,
  ibmanagertypesunit, SQLEngineAbstractUnit, ComCtrls, LCLType, Graphics,
  SQLEngineCommonTypesUnit, StdCtrls, ExtCtrls, StdActns, SynEditKeyCmds, types,
  SynEditMarkupHighAll, SynEditMiscClasses, fbmSqlParserUnit, sqlObjects;

type
  TSynCompletionObjItemType = (scotDBObject, scotKeyword, scotParam, scotField);
  TSynCompletionObjListEnumerator = class;

  { TSynCompletionObjItem }

  TSynCompletionObjItem = class
  private
    FIOTypeName: string;
    FTypeName: string;
    FItemType: TSynCompletionObjItemType;
    FKeywordType: TKeywordType;
    FObjectAlias: string;
    FObjectDesc: string;
    FObjectName: string;
    FObjectType: TDBObjectKind;
    function GetCaption: string;
  public
    constructor Create;
    property ItemType:TSynCompletionObjItemType read FItemType;
    property ObjectType:TDBObjectKind read FObjectType write FObjectType;
    property KeywordType:TKeywordType read FKeywordType write FKeywordType;
    property TypeName:string read FTypeName;
    property ObjectName:string read FObjectName;
    property ObjectAlias:string read FObjectAlias write FObjectAlias;
    property ObjectDesc:string read FObjectDesc;
    property IOTypeName:string read FIOTypeName write FIOTypeName;
    property Caption:string read GetCaption;
  end;

  { TSynCompletionObjList }

  TSynCompletionObjList = class
  private
    FList: TFPList;
    function GetCount: integer;
    function GetItems(AIndex: integer): TSynCompletionObjItem;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Add(const AItemType:TSynCompletionObjItemType; const AObjectName, AObjectType, AObjectDesc:string):TSynCompletionObjItem; overload;
    function Add(const AKeywordType:TKeywordType; const AObjectName:string):TSynCompletionObjItem; overload;
    function Add(const ADBObject:TDBObject):TSynCompletionObjItem; overload;
    function Add(const AField:TDBField):TSynCompletionObjItem; overload;
    function Add(const ASQLField:TSQLParserField):TSynCompletionObjItem; overload;
    function Add(const ASQLTable:TTableItem):TSynCompletionObjItem; overload;

    procedure Remove(AItem:TSynCompletionObjItem);
    function GetEnumerator: TSynCompletionObjListEnumerator;
    procedure FillStrings(AList:TStrings);
    procedure FillFieldList(ADBObject:TDBObject);
  public
    property Items[AIndex:integer]:TSynCompletionObjItem read GetItems; default;
    property Count:integer read GetCount;
  end;

  { TSynCompletionObjListEnumerator }

  TSynCompletionObjListEnumerator = class
  private
    FList: TSynCompletionObjList;
    FPosition: Integer;
  public
    constructor Create(AList: TSynCompletionObjList);
    function GetCurrent: TSynCompletionObjItem;
    function MoveNext: Boolean;
    property Current: TSynCompletionObjItem read GetCurrent;
  end;

type
  Tfdbm_SynEditorFrame = class;

  TOnGetDBObjectByAlias = function(Sender:Tfdbm_SynEditorFrame; const ATableAlias:string; out DBObjName:string):TDBObject of object;

  TOnGetFieldsList = procedure(Sender:Tfdbm_SynEditorFrame; const DBObjName:string; const Items:TSynCompletionObjList;
    ACharCase:TCharCaseOptions) of object;
  TOnGetKeyWordList = procedure(Sender:Tfdbm_SynEditorFrame; const KeyStartWord:string; const Items:TSynCompletionObjList;
    ACharCase:TCharCaseOptions) of object;
  TOnLoadFileEdit = procedure(Sender:Tfdbm_SynEditorFrame; const TextEditor: TSynEdit; const AFileName:string) of object;
  TOnBeforeSaveFileEdit = procedure(Sender:Tfdbm_SynEditorFrame; const TextEditor: TSynEdit;var AFileName:string) of object;
  TOnGetHintData = function(Sender:Tfdbm_SynEditorFrame; const S1, S2:string; out HintText:string):Boolean of object;

  { Tfdbm_SynEditorFrame }

  Tfdbm_SynEditorFrame = class(TFrame)
    MenuItem47: TMenuItem;
    MenuItem49: TMenuItem;
    optEditors: TAction;
    edtSelectAll: TAction;
    edtDelete: TAction;
    edtCopy: TAction;
    edtCut: TAction;
    edtUndo: TAction;
    edtPaste: TAction;
    ceCommentCode: TAction;
    ceUncommentCode: TAction;
    edtSaveAs: TAction;
    ceCharNameCase: TAction;
    ceCharInvertCase: TAction;
    ceCharLowerCase: TAction;
    edtFind: TAction;
    edtFindNext: TAction;
    edtReplace: TAction;
    ceCharUpperCase: TAction;
    edtSave: TAction;
    edtOpen: TAction;
    edtRedo: TAction;
    ednGotoBookmark9: TAction;
    ednGotoBookmark0: TAction;
    ednGotoBookmark2: TAction;
    ednGotoBookmark3: TAction;
    ednGotoBookmark4: TAction;
    ednGotoBookmark5: TAction;
    ednGotoBookmark6: TAction;
    ednGotoBookmark7: TAction;
    ednGotoBookmark8: TAction;
    ednSetBookmark9: TAction;
    ednSetBookmark1: TAction;
    ednSetBookmark2: TAction;
    ednSetBookmark3: TAction;
    ednSetBookmark4: TAction;
    ednSetBookmark5: TAction;
    ednSetBookmark6: TAction;
    ednSetBookmark7: TAction;
    ednSetBookmark8: TAction;
    ednGotoBookmark1: TAction;
    ednSetBookmark0: TAction;
    ActionList1: TActionList;
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
    MenuItem34: TMenuItem;
    MenuItem35: TMenuItem;
    MenuItem36: TMenuItem;
    MenuItem37: TMenuItem;
    MenuItem38: TMenuItem;
    MenuItem39: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem40: TMenuItem;
    MenuItem41: TMenuItem;
    MenuItem42: TMenuItem;
    MenuItem43: TMenuItem;
    MenuItem44: TMenuItem;
    MenuItem45: TMenuItem;
    MenuItem46: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    SaveDialog1: TSaveDialog;
    SynAutoComplete1: TSynAutoComplete;
    SynCompletion1: TSynCompletion;
    SynSQLSyn1: TSynSQLSyn;
    TextEditor: TSynEdit;
    SynCompletionTimer: TTimer;
    procedure ceCharUpperCaseExecute(Sender: TObject);
    procedure ceCommentCodeExecute(Sender: TObject);
    procedure ceUncommentCodeExecute(Sender: TObject);
    procedure ednGotoBookmark0Execute(Sender: TObject);
    procedure ednSetBookmark0Execute(Sender: TObject);
    procedure edtCopyExecute(Sender: TObject);
    procedure edtCutExecute(Sender: TObject);
    procedure edtDeleteExecute(Sender: TObject);
    procedure edtFindExecute(Sender: TObject);
    procedure edtFindNextExecute(Sender: TObject);
    procedure edtOpenExecute(Sender: TObject);
    procedure edtPasteExecute(Sender: TObject);
    procedure edtRedoExecute(Sender: TObject);
    procedure edtReplaceExecute(Sender: TObject);
    procedure edtSaveAsExecute(Sender: TObject);
    procedure edtSaveExecute(Sender: TObject);
    procedure edtSelectAllExecute(Sender: TObject);
    procedure edtUndoExecute(Sender: TObject);
    procedure optEditorsExecute(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure SynCompletion1CodeCompletion(var Value: string;
      SourceValue: string; var SourceStart, SourceEnd: TPoint;
      KeyChar: TUTF8Char; Shift: TShiftState);
    procedure SynCompletion1Execute(Sender: TObject);
    procedure SynCompletion1KeyNextChar(Sender: TObject);
    procedure SynCompletion1KeyPrevChar(Sender: TObject);
    function SynCompletion1PaintItem(const AKey: string; ACanvas: TCanvas; X,
      Y: integer; Selected: boolean; Index: integer): boolean;
    procedure SynCompletion1SearchPosition(var Position: integer);
    procedure SynCompletionTimerTimer(Sender: TObject);
    procedure TextEditorClick(Sender: TObject);
    procedure TextEditorCommandProcessed(Sender: TObject;
      var Command: TSynEditorCommand; var AChar: TUTF8Char; Data: pointer);
    procedure TextEditorDblClick(Sender: TObject);
    procedure TextEditorDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TextEditorDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure TextEditorEnter(Sender: TObject);
    procedure TextEditorExit(Sender: TObject);
    procedure TextEditorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TextEditorKeyPress(Sender: TObject; var Key: char);
    procedure TextEditorMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TextEditorProcessUserCommand(Sender: TObject;
      var Command: TSynEditorCommand; var AChar: TUTF8Char; Data: pointer);
    procedure TextEditorShowHint(Sender: TObject; HintInfo: PHintInfo);
  protected
    procedure SetEnabled(Value: Boolean); override;
    procedure SaveAsToFile;virtual;
  private
    //SynCompletion procedures
    FSynCompletionObjList:TSynCompletionObjList;
    FSQLParser:TSQLParser;
    procedure FillSynCompletionList(const AFilterStr:string = '');
    procedure CloseCompletion(Sender: TObject);
    procedure MakeCompletionList;

    procedure OnSynCompletionKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure ProcessForHint;
    function GetPreviousToken: string;
  private
    FOnBeforeSaveFile: TOnBeforeSaveFileEdit;
    FOnEditorChangeStatus: TNotifyEvent;
    FOnGetHintData: TOnGetHintData;
    FSynCompletionTimerEnabled: Boolean;
    FSynMarkup:TSynEditMarkupHighlightAllCaret;
    FFileName: string;
    FOnGetDBObjectByAlias:TOnGetDBObjectByAlias;
    FOnGetFieldsList: TOnGetFieldsList;
    FOnGetKeyWordList: TOnGetKeyWordList;
    FOnGetObjAliasList: TOnGetKeyWordList;
    FOnLoadFileEdit: TOnLoadFileEdit;
    FOnSaveFileEdit: TOnLoadFileEdit;
    FSQLEngine: TSQLEngineAbstract;
    FOnPopUpMenu:TNotifyEvent;
    DBRecord:TDataBaseRecord;
    function GetCurWord:string;
    function GetCurWordX(out X:integer):string;
    function GetReadOnly: boolean;
    procedure SelectCurWord;
    function GetEditorText: string;
    function GetModified: boolean;
    procedure SetReadOnly(AValue: boolean);
    function SynEditAcceptDrag(const Source: TObject): TControl;
    procedure DoSearchReplaceText(AReplace: boolean; ABackwards: boolean);
    procedure LMEditorChangeParams(var message: TLMNoParams); message LM_EDITOR_CHANGE_PARMAS;
    procedure LMNotyfyDelObject(var Message: TLMessage); message LM_NOTIFY_OBJECT_DELETE;
    procedure SetEditorText(const AValue: string);
    procedure SetHandlers(AEnable:boolean);
    procedure SetModified(const AValue: boolean);
    procedure SetSQLEngine(const AValue: TSQLEngineAbstract);
    procedure ShowInsertDefSqlForm(DBObject:TDBObject; const TableAlis:string; const X:integer);
    procedure ShowSearchReplaceDialog(AReplace: boolean);
    procedure ChangeCaseSelection(CaseAction:TCharCaseOptions);
    procedure EditorStatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure UpdateSynMarkup;
    procedure MakeAliasList(AList: TStringList);
  public
    {$IFDEF DEBUG}
    MemoLog:TMemo;
    procedure writeLog(const S:string);
    {$ENDIF}
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeVisualParams;
    procedure OpenFile(const AFileName:string);
    procedure Localize;
    procedure UpdateStatusBar;
    procedure TextInsert(X,Y:integer; AText:string);
    procedure CompletionListClear;
    function CreateCTMenuItem(const ACaption:string; AEventHandler:TNotifyEvent; ATag:Integer = 0):TMenuItem;
    function DoTestValidIdentList(S:string):Boolean;
    function DoFillIdentListFromSQL(S:string):TStrings;

    property EditorText:string read GetEditorText write SetEditorText;
    property SQLEngine:TSQLEngineAbstract read FSQLEngine write SetSQLEngine;
    property Modified:boolean read GetModified write SetModified;
    property OnGetFieldsList:TOnGetFieldsList read FOnGetFieldsList write FOnGetFieldsList;
    property OnGetKeyWordList:TOnGetKeyWordList read FOnGetKeyWordList write FOnGetKeyWordList;
    property OnGetObjAliasList: TOnGetKeyWordList read FOnGetObjAliasList write FOnGetObjAliasList;
    property OnGetDBObjectByAlias:TOnGetDBObjectByAlias read FOnGetDBObjectByAlias write FOnGetDBObjectByAlias;
    property FileName:string read FFileName write FFileName;
    property OnLoadFileEdit:TOnLoadFileEdit read FOnLoadFileEdit write FOnLoadFileEdit;
    property OnSaveFileEdit:TOnLoadFileEdit read FOnSaveFileEdit write FOnSaveFileEdit;
    property OnBeforeSaveFile:TOnBeforeSaveFileEdit read FOnBeforeSaveFile write FOnBeforeSaveFile;
    property ReadOnly:boolean read GetReadOnly write SetReadOnly;
    property OnPopUpMenu:TNotifyEvent read FOnPopUpMenu write FOnPopUpMenu;
    property OnEditorChangeStatus:TNotifyEvent read FOnEditorChangeStatus write FOnEditorChangeStatus;
    property OnGetHintData:TOnGetHintData read FOnGetHintData write FOnGetHintData;
  end;

var
  bSearchBackwards:Boolean;
  bSearchCaseSensitive:Boolean;
  bSearchFromCaret:Boolean;
  bSearchSelectionOnly:Boolean;
  bSearchWholeWords:Boolean;
  bSearchRegExp:Boolean;
  sSearchText, sReplaceText:String;
  sReplaceTextHistory, sSearchTextHistory:String;

implementation
uses IBManMainUnit, SynEditTypes, fEditSearch, IBManDataInspectorUnit, LCLIntf,
  fbmInsertDefSqlUnit, LCLProc, LazFileUtils, strutils, rxAppUtils,
  fbmStrConstUnit, fdbm_SynEditorCompletionHintUnit,
  fdbmSynAutoCompletionsLists, SQLEngineInternalToolsUnit, LazUTF8;

{$R *.lfm}

type
  THackSynEdit = class(TCustomSynEdit);

{ TSynCompletionObjItem }

function TSynCompletionObjItem.GetCaption: string;
begin
  if FObjectAlias <> '' then
    Result:=FObjectAlias
  else
    Result:=FObjectName;
end;

constructor TSynCompletionObjItem.Create;
begin
  inherited Create;
  FKeywordType:=ktNone;
  FObjectType:=okNone;
end;

{ TSynCompletionObjListEnumerator }

constructor TSynCompletionObjListEnumerator.Create(AList: TSynCompletionObjList
  );
begin
  FList := AList;
  FPosition := -1;
end;

function TSynCompletionObjListEnumerator.GetCurrent: TSynCompletionObjItem;
begin
  Result := FList[FPosition];
end;

function TSynCompletionObjListEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TSynCompletionObjList }

function TSynCompletionObjList.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TSynCompletionObjList.GetItems(AIndex: integer): TSynCompletionObjItem;
begin
  Result:=TSynCompletionObjItem(FList[AIndex])
end;

constructor TSynCompletionObjList.Create;
begin
  inherited Create;
  FList:=TFPList.Create;
end;

destructor TSynCompletionObjList.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TSynCompletionObjList.Clear;
var
  i: Integer;
begin
  for i:=0 to FList.Count-1 do
    TSynCompletionObjItem(FList[i]).Free;
  FList.Clear;
end;

function TSynCompletionObjList.Add(const AItemType: TSynCompletionObjItemType;
  const AObjectName, AObjectType, AObjectDesc: string): TSynCompletionObjItem;
begin
  Result:=TSynCompletionObjItem.Create;
  Result.FItemType:=AItemType;
  Result.FObjectName:=AObjectName;
  Result.FTypeName:=AObjectType;
  Result.FObjectDesc:=AObjectDesc;
  FList.Add(Result);
end;

function TSynCompletionObjList.Add(const AKeywordType: TKeywordType;
  const AObjectName: string): TSynCompletionObjItem;
begin
  Result:=TSynCompletionObjItem.Create;
  Result.FObjectType:=okNone;
  Result.FKeywordType:=AKeywordType;
  Result.FObjectName:=AObjectName;
  Result.FItemType:=scotKeyword;
  FList.Add(Result);
end;

function TSynCompletionObjList.Add(const ADBObject: TDBObject
  ): TSynCompletionObjItem;
begin
  if not Assigned(ADBObject) then exit;
  Result:=TSynCompletionObjItem.Create;
  Result.FObjectType:=ADBObject.DBObjectKind;
  Result.FObjectName:=ADBObject.Caption;
  Result.FObjectDesc:=ADBObject.Description;
  Result.FItemType:=scotDBObject;
  Result.FTypeName:=ADBObject.DBClassTitle;
  FList.Add(Result);
end;

function TSynCompletionObjList.Add(const AField: TDBField
  ): TSynCompletionObjItem;
begin
  if not Assigned(AField) then exit;
  Result:=TSynCompletionObjItem.Create;
  Result.FObjectType:=okField;
  Result.FObjectName:=AField.FieldName;
  Result.FObjectDesc:=AField.FieldDescription;
  if Assigned(AField.FieldDomain) then
    Result.FTypeName:=AField.FieldTypeDomain
  else
    Result.FTypeName:=AField.FieldTypeName;
  Result.FItemType:=scotField;
  FList.Add(Result);
end;

function TSynCompletionObjList.Add(const ASQLField: TSQLParserField
  ): TSynCompletionObjItem;
begin
  if not Assigned(ASQLField) then exit;
  Result:=TSynCompletionObjItem.Create;
  Result.FObjectName:=ASQLField.Caption;
  Result.FObjectDesc:=ASQLField.Description;
  Result.FTypeName:=ASQLField.FullTypeName;
  Result.FIOTypeName:=ParamTypeFuncToStr(ASQLField.InReturn);
  Result.FItemType:=scotParam;

  FList.Add(Result);
end;

function TSynCompletionObjList.Add(const ASQLTable: TTableItem
  ): TSynCompletionObjItem;
begin
  if not Assigned(ASQLTable) then exit;
  Result:=TSynCompletionObjItem.Create;
  Result.FObjectName:=ASQLTable.FullName;
  Result.FTypeName:='table';
  if ASQLTable.TableType = stitVirtualTable then
  begin
    Result.FObjectName:=ASQLTable.TableAlias;
    Result.FObjectDesc:='select expression : ' + ASQLTable.TableExpression;
  end
  else
    Result.FObjectName:=ASQLTable.FullName;
  Result.FItemType:=scotDBObject;
  Result.FObjectType:=okTable;
  FList.Add(Result);
end;

procedure TSynCompletionObjList.Remove(AItem: TSynCompletionObjItem);
begin
  FList.Remove(AItem);
  AItem.Free;
end;

function TSynCompletionObjList.GetEnumerator: TSynCompletionObjListEnumerator;
begin
  Result:=TSynCompletionObjListEnumerator.Create(Self);
end;

procedure TSynCompletionObjList.FillStrings(AList: TStrings);
var
  R: TSynCompletionObjItem;
begin
  AList.Clear;
  for R in Self do
    AList.AddObject(R.Caption, R);
end;

type
  THackSP = class(TDBStoredProcObject);

procedure TSynCompletionObjList.FillFieldList(ADBObject: TDBObject);
var
  F: TDBField;
  i: Integer;
  P: TDBObject;
  G: TDBRootObject;
begin
  if not Assigned(ADBObject) then exit;

  if not ADBObject.Loaded then
    ADBObject.RefreshObject;

  if ADBObject is TDBDataSetObject then
  begin
    for F in TDBDataSetObject(ADBObject).Fields do
      Add(F);
  end
  else
  if ADBObject is TDBStoredProcObject then
  begin
    for F in THackSP(ADBObject).FieldsIN do
      Add(F);
    for F in THackSP(ADBObject).FieldsOut do
      Add(F);
  end
  else
  if ADBObject is TDBRootObject then
  begin
    for i:=0 to TDBRootObject(ADBObject).CountGroups - 1 do
    begin
      G:=TDBRootObject(ADBObject).Groups[i];
      if G.State <> sdboVirtualObject then
        Add(G);
      if (G is TDBRootObject) and (G.DBObjectKind in [okDomain, okPartitionTable, okTable, okView, okFunction, okStoredProc, okSequence, okMaterializedView]) then
        FillFieldList(G);
    end;

    for i:=0 to TDBRootObject(ADBObject).CountObject-1 do
    begin
      P:=TDBRootObject(ADBObject).Items[i];
      if P.State <> sdboVirtualObject then
        Add(P);
      if (P is TDBRootObject) and (P.DBObjectKind in [okPartitionTable, okTable, okView, okStoredProc, okFunction]) then
        FillFieldList(P);
    end;
  end;
end;


{ Tfdbm_SynEditorFrame }

procedure Tfdbm_SynEditorFrame.edtFindExecute(Sender: TObject);
begin
  ShowSearchReplaceDialog(False);
end;

procedure Tfdbm_SynEditorFrame.edtFindNextExecute(Sender: TObject);
begin
  if sSearchText <> '' then
  begin
    DoSearchReplaceText(False, bSearchBackwards);
    bSearchFromCaret:= True;
  end
  else
    edtFind.Execute;
end;

procedure Tfdbm_SynEditorFrame.edtOpenExecute(Sender: TObject);
begin
  OpenDialog1.FileName:=FFileName;
  if OpenDialog1.Execute then
    OpenFile(OpenDialog1.FileName);
end;

procedure Tfdbm_SynEditorFrame.edtPasteExecute(Sender: TObject);
begin
  TextEditor.PasteFromClipboard;
end;

procedure Tfdbm_SynEditorFrame.edtRedoExecute(Sender: TObject);
begin
  TextEditor.Redo;
end;

procedure Tfdbm_SynEditorFrame.edtReplaceExecute(Sender: TObject);
begin
  ShowSearchReplaceDialog(True);
end;

procedure Tfdbm_SynEditorFrame.edtSaveAsExecute(Sender: TObject);
begin
  SaveAsToFile;
end;

procedure Tfdbm_SynEditorFrame.edtSaveExecute(Sender: TObject);
begin
  if FFileName = '' then
    edtSaveAs.Execute
  else
  begin
    TextEditor.Lines.SaveToFile(FFileName);
    TextEditor.Modified:=false;
  end;
end;

procedure Tfdbm_SynEditorFrame.edtSelectAllExecute(Sender: TObject);
begin
  TextEditor.SelectAll;
end;

procedure Tfdbm_SynEditorFrame.edtUndoExecute(Sender: TObject);
begin
  TextEditor.Undo;
end;

procedure Tfdbm_SynEditorFrame.optEditorsExecute(Sender: TObject);
begin
  fbManagerMainForm.optEditorsExecute(Sender);
end;

procedure Tfdbm_SynEditorFrame.PopupMenu1Popup(Sender: TObject);
begin
  if Assigned(FOnPopUpMenu) then
    FOnPopUpMenu(PopupMenu1);
  ceCommentCode.Enabled:=TextEditor.SelStart < TextEditor.SelEnd;
  ceUncommentCode.Enabled:=ceCommentCode.Enabled;
end;

procedure Tfdbm_SynEditorFrame.SynCompletion1CodeCompletion(var Value: string;
  SourceValue: string; var SourceStart, SourceEnd: TPoint; KeyChar: TUTF8Char;
  Shift: TShiftState);
begin
  if Assigned(SQLEngine) then
    Value:=DoFormatName(Value, false, SQLEngine.QuteIdentificatorChar)
  else
    Value:=DoFormatName(Value);
end;

procedure Tfdbm_SynEditorFrame.SynCompletion1Execute(Sender: TObject);
begin
  {$IFDEF DEBUG}
  writeLog('Tfdbm_SynEditorFrame.SynCompletion1Execute');
  {$ENDIF}
  MakeCompletionList;

  FillSynCompletionList(UTF8UpperCase(SynCompletion1.CurrentString));
end;

procedure Tfdbm_SynEditorFrame.SynCompletion1KeyNextChar(Sender: TObject);
var
  NewPrefix: String;
  Line: String;
  LogCaret: TPoint;
  AddPrefix: String;
begin
  {$IFDEF DEBUG} writeLog('Tfdbm_SynEditorFrame.SynCompletion1KeyNextChar');{$ENDIF}
  LogCaret:=TextEditor.LogicalCaretXY;
  if LogCaret.Y>TextEditor.Lines.Count then exit;
  Line:=TextEditor.Lines[LogCaret.Y-1];
  if LogCaret.X > UTF8Length(Line) then exit;
  AddPrefix:=UTF8Copy(Line, LogCaret.X, 1);
  NewPrefix:=SynCompletion1.CurrentString+AddPrefix;
  {$IFDEF DEBUG} writeLog('NewPrefix='+NewPrefix);{$ENDIF}
  inc(LogCaret.X);
  TextEditor.LogicalCaretXY:=LogCaret;
  SynCompletion1.CurrentString:=NewPrefix;
end;

procedure Tfdbm_SynEditorFrame.SynCompletion1KeyPrevChar(Sender: TObject);
var
  NewPrefix: String;
begin
  {$IFDEF DEBUG} writeLog('Tfdbm_SynEditorFrame.SynCompletion1KeyPrevChar');{$ENDIF}
  NewPrefix:=SynCompletion1.CurrentString;
  if NewPrefix='' then exit;
  TextEditor.CaretX:=TextEditor.CaretX-1;
  UTF8Delete(NewPrefix, UTF8Length(NewPrefix), 1);
  {$IFDEF DEBUG} writeLog('NewPrefix='+NewPrefix);{$ENDIF}
  SynCompletion1.CurrentString:=NewPrefix;
end;

function Tfdbm_SynEditorFrame.SynCompletion1PaintItem(const AKey: string;
  ACanvas: TCanvas; X, Y: integer; Selected: boolean; Index: integer): boolean;

procedure OutItemText(S:string; ASyle:TFontStyles; var X_Pos, Y_Pos:integer);
var
  l:integer;
begin
  L:=ACanvas.TextWidth(S);
  begin
    ACanvas.Font.Style:=ASyle;
    SetBkMode(ACanvas.Handle, TRANSPARENT);
    ACanvas.TextOut(X_Pos, Y_Pos, S);
  end;
  X_Pos:=X_Pos + L
end;

var
  S, S1, S2:string;
  P: TSynCompletionObjItem;
begin
  S1:='';
  with ACanvas do
  begin
    if (Index>=0) and (Index<SynCompletion1.ItemList.Count) then
    begin
      if Assigned(SynCompletion1.ItemList.Objects[Index]) then
      begin
        if not (SynCompletion1.ItemList.Objects[Index] is TSynCompletionObjItem) then
          raise Exception.Create('(SynCompletion1.ItemList.Objects[Index] is TSynCompletionObjItem)');
        P:=TSynCompletionObjItem(SynCompletion1.ItemList.Objects[Index]);

        if P.ItemType = scotDBObject then
        begin
          S:=P.TypeName+' ';
          inc(X, 2);
          fbManagerMainForm.ImageList2.Draw(ACanvas, X, Y, ord(P.ObjectType)+1);
          X:=X+20;
          if P.ObjectAlias <> '' then
            S1:=S1 + ' -- ' + Format(sAliasOfObj, [P.ObjectName]);
          if P.ObjectDesc <> '' then
            S1:=S1 + ' -- ' + StrConvertDesc(P.ObjectDesc);
        end
        else
        if P.ItemType = scotField then
        begin
          S:=sField+' ';
          if P.TypeName <> '' then
            S1:=' : '+P.TypeName
          else
            S1:=' ';
          inc(X, 2);
          fbManagerMainForm.ImageList2.Draw(ACanvas, X, Y, 14);
          X:=X+20;
          if P.ObjectDesc <> '' then
            S1:=S1 + ' -- ' + Trim(StrConvertDesc(P.ObjectDesc));
        end
        else
        if P.ItemType = scotKeyword then
        begin
          S:=P.ObjectName+' ';
          inc(X, 2);
          fbManagerMainForm.ImageList2.Draw(ACanvas, X, Y, 11 + Ord(P.KeywordType));
          X:=X+20;
        end
        else
        if P.ItemType = scotParam then
        begin
          inc(X, 2);
          fbManagerMainForm.ImageList2.Draw(ACanvas, X, Y, 68);
          X:=X+20;

           ACanvas.Font:=SynCompletion1.Editor.Font;
           ACanvas.Font.Color:=clGreen;
           S:=P.IOTypeName + ' ';
           OutItemText(S, [fsBold, fsItalic], X, Y);
           S:='';
           if P.TypeName <> '' then
             S1:=' : ' + P.TypeName + ' '
           else
             S1:=S1 + ' ';
           if P.ObjectDesc<>'' then
             S1:=S1 + ' -- ' + StrConvertDesc(P.ObjectDesc);
         end;
      end
      else
        S:='(none) ';
    end
    else
      S:='';

    ACanvas.Font:=SynCompletion1.Editor.Font;
    if Selected then
      ACanvas.Font.Color:=clWhite
    else
      ACanvas.Font.Color:=clBlack;

    OutItemText(S, [], X, Y);
    OutItemText(AKey, [fsBold], X, Y);

    if S1<>'' then
    begin
      if Pos('--', S1)>0 then
      begin
        S2:=Copy(S1, Pos('--', S1), Length(S1));
        Delete(S1, Pos('--', S1), Length(S1));
      end;
      OutItemText(S1, [], X, Y);
      if S2 <>'' then
        OutItemText(S2, [fsItalic], X, Y);
    end;
  end;
  Result:=true;
end;

procedure Tfdbm_SynEditorFrame.SynCompletion1SearchPosition(
  var Position: integer);
begin
  {$IFDEF DEBUG} writeLog('Tfdbm_SynEditorFrame.SynCompletion1SearchPosition');{$ENDIF}

  if FSynCompletionObjList.Count = 0 then
    MakeCompletionList;


  FillSynCompletionList(UTF8UpperCase(SynCompletion1.CurrentString));

  if SynCompletion1.ItemList.Count > 0 then
    Position := 0
  else
    Position := -1;
end;

procedure Tfdbm_SynEditorFrame.SynCompletionTimerTimer(Sender: TObject);
var
  S:string;
  P:TPoint;
begin
  SynCompletionTimer.Enabled:=false;
  if SynCompletion1.IsActive then exit;
  if (TextEditor.CaretY > 0) and (TextEditor.CaretY<=TextEditor.Lines.Count) then
  begin
    S:=TextEditor.Lines[TextEditor.CaretY-1];
    if (S<>'') and (Length(S)>TextEditor.CaretX-2) and (TextEditor.CaretX > 1) then
    begin
      p := ClientToScreen(Point(TextEditor.CaretXPix, TextEditor.CaretYPix + TextEditor.LineHeight + 1));
      SynCompletion1.Execute(GetPreviousToken, p.x, p.y);
    end;
  end;
end;

procedure Tfdbm_SynEditorFrame.TextEditorClick(Sender: TObject);
begin
  UpdateStatusBar;
end;

procedure Tfdbm_SynEditorFrame.TextEditorCommandProcessed(Sender: TObject;
  var Command: TSynEditorCommand; var AChar: TUTF8Char; Data: pointer);
begin
  if (Command=ecChar) and (AChar=#27) then
  begin
    // close hint windows
    HideCodeContext;
  end;
end;

procedure Tfdbm_SynEditorFrame.TextEditorDblClick(Sender: TObject);
var
  S:string;
begin
  if not Assigned(DBRecord) then exit;
  S:=GetCurWord;
  if (S<>'') then
    DBRecord.ObjectShowEditor(S);
end;

procedure Tfdbm_SynEditorFrame.TextEditorDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  Rec:TDBInspectorRecord;
  i:integer;
  N:TTreeNode;
  Control :TControl;
  S:string;

  DBObject:TDBObject;
begin
  DBObject:=nil;

  Control:=SynEditAcceptDrag(Source);
  Rec:=fbManDataInpectorForm.CurrentObject;
  if Assigned(Rec) then
    DBObject:=Rec.DBObject;

  if (Control = fbManDataInpectorForm.TreeView1) and Assigned(DBObject) then
  begin
    if (fbManDataInpectorForm.TreeView1.GetFirstMultiSelected <> nil) or (ssCtrl in GetKeyShiftState) then
    begin
      N:=fbManDataInpectorForm.TreeView1.GetFirstMultiSelected;
      if N<>nil then
      begin
        if (not Assigned(N.GetNextMultiSelected)) and not (ssCtrl in GetKeyShiftState) then
        begin
          ShowInsertDefSqlForm(DBObject, '', TextEditor.LogicalCaretXY.X)
        end
        else
          while N<>nil do
          begin
            TextEditor.Lines.Add(N.Text);
            N:=N.GetNextMultiSelected;
          end;
      end;
    end
    else
      ShowInsertDefSqlForm(DBObject, '', TextEditor.LogicalCaretXY.X)
  end
  else
  if (Control = fbManDataInpectorForm.LB_SQLAssistent) and Assigned(Rec)  then
  begin
    S:='';
    for i:= 0 to fbManDataInpectorForm.LB_SQLAssistent.Items.Count-1 do
      if fbManDataInpectorForm.LB_SQLAssistent.Selected[i] then

       S:=S + Rec.Caption + '.' + fbManDataInpectorForm.LB_SQLAssistent.Items[i] + LineEnding;

    TextEditor.SelText:=S;
  end;
  TextEditor.SetFocus;
end;

procedure Tfdbm_SynEditorFrame.TextEditorDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  Control :TControl;
begin
  Control:=SynEditAcceptDrag(Source);
  Accept:= (Control = fbManDataInpectorForm.TreeView1) or (Control = fbManDataInpectorForm.LB_SQLAssistent);
end;

procedure Tfdbm_SynEditorFrame.TextEditorEnter(Sender: TObject);
begin
  UpdateStatusBar;
end;

procedure Tfdbm_SynEditorFrame.TextEditorExit(Sender: TObject);
begin
  HideCodeContext;
end;

procedure Tfdbm_SynEditorFrame.TextEditorKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  S, FTableAlias, S1:string;
  P:TDBObject;
  X, I: integer;
  FList: TStringList;
begin
  SynCompletionTimer.Enabled:=false;
  if not Assigned(DBRecord) then exit;
  if (Key = vk_Return) and (ssCtrl in Shift) then
  begin
    FTableAlias:='';
    S:=GetCurWordX(X);
    P:=DBRecord.GetDBObject(S);

    if (not Assigned(P)) and Assigned(FOnGetDBObjectByAlias) then
    begin
      FList:=TStringList.Create;
      MakeAliasList(FList);
      I:=FList.IndexOf(S);
      if I>-1 then
        P:=FList.Objects[I] as TDBObject;
    end;

    if (not Assigned(P)) and Assigned(FOnGetDBObjectByAlias) then
    begin
      P:=FOnGetDBObjectByAlias(Self, S, S1);
      FTableAlias:=S;
    end;

    if Assigned(P) then
    begin
      if (ssShift in Shift) then
        fbManDataInpectorForm.SelectObject(P)
      else
      if (ssAlt in Shift) then
        ShowInsertDefSqlForm(P, FTableAlias, X)
      else
        P.Edit;
    end;
    Key:=0;
    UpdateStatusBar;
  end
  else
  if (Key = VK_SPACE) and (ssCtrl in Shift) and (ssShift in Shift) then
    ProcessForHint;
end;

procedure Tfdbm_SynEditorFrame.TextEditorKeyPress(Sender: TObject; var Key: char
  );
begin
  SynCompletionTimer.Enabled:=false;
  if Key in [')', ';'] then
    HideCodeContext
  else
  if (Key in ['.']) and FSynCompletionTimerEnabled then
    SynCompletionTimer.Enabled:=true;
end;

procedure Tfdbm_SynEditorFrame.TextEditorMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  P:TPoint;
  S:string;
begin
  if not Assigned(DBRecord) then exit;

  P.X:=X;
  P.Y:=Y;
  S:=TextEditor.GetWordAtRowCol(TextEditor.PixelsToRowColumn(P));

  if (S<>'') and ((TextEditor.Highlighter as TSynSQLSyn).TableNames.IndexOf(S)>0) then
    TextEditor.Cursor:=crHandPoint
  else
    TextEditor.Cursor:=crIBeam;
end;

procedure Tfdbm_SynEditorFrame.TextEditorProcessUserCommand(Sender: TObject;
  var Command: TSynEditorCommand; var AChar: TUTF8Char; Data: pointer);
begin
  case Command of
    ecUpperCaseBlock : ChangeCaseSelection(ccoUpperCase);
    ecLowerCaseBlock : ChangeCaseSelection(ccoLowerCase);
    ecToggleCaseBlock  : ChangeCaseSelection(ccoChangeCase);
  else
    exit;
  end;  //case
  Command:=ecNone;
end;

procedure Tfdbm_SynEditorFrame.TextEditorShowHint(Sender: TObject;
  HintInfo: PHintInfo);
var
  S, SHint, S1,  SF: String;
  P, P1: TDBObject;
  CP: TPoint;
  i: LongInt;
  F: TDBField;
begin
  if not Assigned(DBRecord) then exit;
  CP:=TextEditor.PixelsToRowColumn(HintInfo^.CursorPos);

  SHint:='';
  S:=TextEditor.GetWordAtRowCol(CP);
  S1:='';
  SF:='';
  if (CP.Y >0) and (CP.Y <= TextEditor.Lines.Count) then
  begin
    S1:=TextEditor.Lines[CP.Y-1];
    if (Length(S1)>2) then
    begin
      i:=CP.X;
      while (i>0) and (S1[i]>' ') and (pos(S1[i], SynCompletion1.EndOfTokenChr) = 0) do Dec(I);
      if (I>1) and (S1[i]='.') then
      begin
        SF:=S;
        S:=TextEditor.GetWordAtRowCol(Point(I-1, CP.Y));
      end;
    end;
  end;

  if S<>'' then
  begin
    P:=DBRecord.GetDBObject(S);
    if Assigned(P) then
    begin
      if (SF<>'') then
      begin
        if (P.DBObjectKind in [okPartitionTable, okTable, okMaterializedView, okView]) then
        begin
          F:=(P as TDBDataSetObject).Fields.FieldByName(SF);
          if Assigned(F) then
          begin
            SHint:=ObjectKindToStr(okField) + ' ' +F.FieldName + ' ' + F.FieldTypeName + LineEnding;
            if F.FieldDescription<>'' then
              SHint:=SHint + '---------------------------------------' + LineEnding + F.FieldDescription + LineEnding;
          end;
        end
        else
        if (P.DBObjectKind = okScheme) and (P is TDBRootObject) then
        begin
          P1:=TDBRootObject(P).ObjByName(SF);
          if Assigned(P1) then P:=P1;
        end;
      end;
      SHint:=SHint + ObjectKindToStr(P.DBObjectKind) + ' ' + P.CaptionFullPatch;
      if P.Description <> '' then SHint:=SHint + LineEnding + P.Description;

    end
    else
    if Assigned(FOnGetHintData) then
      if FOnGetHintData(Self, UTF8UpperCase(S), UTF8UpperCase(SF), S1) then
        SHint:=S1;

    HintInfo^.HintStr:=SHint;

  end;
end;

procedure Tfdbm_SynEditorFrame.SetEnabled(Value: Boolean);
begin
  inherited SetEnabled(Value);
  TextEditor.Enabled:=Value;
{  if Value then
    ActionList1.State:=asNormal
  else
    ActionList1.State:=asSuspended;}
end;

procedure Tfdbm_SynEditorFrame.SaveAsToFile;
begin
  if Assigned(FOnBeforeSaveFile) then
    FOnBeforeSaveFile(Self, TextEditor, FFileName);

  SaveDialog1.FileName:=FFileName;
  if SaveDialog1.Execute then
  begin
    FFileName:=SaveDialog1.FileName;
    TextEditor.Lines.SaveToFile(FFileName);
    TextEditor.Modified:=false;
    if Assigned(FOnSaveFileEdit) then
      FOnSaveFileEdit(Self, TextEditor, FFileName);
  end;
end;

procedure Tfdbm_SynEditorFrame.ChangeVisualParams;
begin
  SetEditorOptions(TextEditor);
  FillAutoCompleteItems(SynAutoComplete1);

  FSynCompletionTimerEnabled:=ConfigValues.ByNameAsBoolean('EditorAutoCompletionEnables', true);
  SynCompletionTimer.Interval:=ConfigValues.ByNameAsInteger('EditorAutoCompletionTimeInterval', 1000);

  UpdateSynMarkup;
end;

procedure Tfdbm_SynEditorFrame.OpenFile(const AFileName: string);
begin
  if FileExistsUTF8(AFileName) then
  begin
    FFileName:=AFileName;
    TextEditor.Lines.LoadFromFile(FFileName);
    TextEditor.Modified:=false;
    if Assigned(FOnLoadFileEdit) then
      FOnLoadFileEdit(Self, TextEditor, AFileName);
  end
  else
    ErrorBoxExt(sFileNotFound, [AFileName]);
end;

procedure Tfdbm_SynEditorFrame.Localize;
begin
  edtSaveAs.Caption:=sSaveAs;

  MenuItem37.Caption:=sCodeExploer;
  ceCharNameCase.Caption:=sNameCase;
  ceCharInvertCase.Caption:=sInvertCase;
  ceCharLowerCase.Caption:=sLowerCase;
  ceCharUpperCase.Caption:=sUpperCase;

  edtFind.Caption:=sFind;
  edtFindNext.Caption:=sFindNext;
  edtReplace.Caption:=sReplace;
  edtSave.Caption:=sSave;
  edtOpen.Caption:=sOpen;
  edtUndo.Caption:=sUndo;
  edtUndo.Hint:=sUndoHint;
  edtRedo.Caption:=sRedo;
  edtPaste.Caption:=sPaste;
  edtCut.Caption:=sCut;
  edtCopy.Caption:=sCopy;
  ceCommentCode.Caption:=sCommentCmd;
  ceUncommentCode.Caption:=sUnCommentCmd;

  MenuItem1.Caption:=sSetBookmarkNum;
  MenuItem2.Caption:=sGotoBookmark;

  ednGotoBookmark1.Caption:=sGotoBookmark+'1';
  ednGotoBookmark0.Caption:=sGotoBookmark+'1';
  ednGotoBookmark2.Caption:=sGotoBookmark+'1';
  ednGotoBookmark3.Caption:=sGotoBookmark+'1';
  ednGotoBookmark4.Caption:=sGotoBookmark+'1';
  ednGotoBookmark5.Caption:=sGotoBookmark+'1';
  ednGotoBookmark6.Caption:=sGotoBookmark+'1';
  ednGotoBookmark7.Caption:=sGotoBookmark+'1';
  ednGotoBookmark8.Caption:=sGotoBookmark+'1';
  ednGotoBookmark9.Caption:=sGotoBookmark+'1';
  ednSetBookmark1.Caption:=sSetBookmarkNum + '1';
  ednSetBookmark2.Caption:=sSetBookmarkNum + '2';
  ednSetBookmark3.Caption:=sSetBookmarkNum + '3';
  ednSetBookmark4.Caption:=sSetBookmarkNum + '4';
  ednSetBookmark5.Caption:=sSetBookmarkNum + '5';
  ednSetBookmark6.Caption:=sSetBookmarkNum + '6';
  ednSetBookmark7.Caption:=sSetBookmarkNum + '7';
  ednSetBookmark8.Caption:=sSetBookmarkNum + '8';
  ednSetBookmark9.Caption:=sSetBookmarkNum + '9';
  ednSetBookmark0.Caption:=sSetBookmarkNum + '0';
  OpenDialog1.Title:=sOpenFile;
  SaveDialog1.Title:=sSaveFile;
  optEditors.Caption:=sMenuOptEditors;
end;

procedure Tfdbm_SynEditorFrame.DoSearchReplaceText(AReplace: boolean;
  ABackwards: boolean);
var
  Options: TSynSearchOptions;
begin
  if AReplace then
    Options := [ssoPrompt, ssoReplace, ssoReplaceAll]
  else
    Options := [];
  if ABackwards then
    Include(Options, ssoBackwards);
  if bSearchCaseSensitive then
    Include(Options, ssoMatchCase);
  if not bSearchFromCaret then
    Include(Options, ssoEntireScope);
  if bSearchSelectionOnly then
    Include(Options, ssoSelectedOnly);
  if bSearchWholeWords then
    Include(Options, ssoWholeWord);
  if bSearchRegExp then
    Include(Options, ssoRegExpr);
  if TextEditor.SearchReplace(sSearchText, sReplaceText, Options) = 0 then
  begin
    if ssoBackwards in Options then
      TextEditor.BlockEnd := TextEditor.BlockBegin
    else
      TextEditor.BlockBegin := TextEditor.BlockEnd;
    TextEditor.CaretXY := TextEditor.BlockBegin;
  end;
end;

function Tfdbm_SynEditorFrame.GetEditorText: string;
begin
  Result:=TextEditor.Text;
end;

function Tfdbm_SynEditorFrame.GetModified: boolean;
begin
  Result:=TextEditor.Modified;
end;

procedure Tfdbm_SynEditorFrame.SetReadOnly(AValue: boolean);
begin
  TextEditor.ReadOnly:=AValue
end;


procedure Tfdbm_SynEditorFrame.SetEditorText(const AValue: string);
begin
  SetHandlers(false);
  TextEditor.Text:=AValue;
  SetHandlers(true);
  if Assigned(TextEditor.OnChange) then
    TextEditor.OnChange(TextEditor);
end;

procedure Tfdbm_SynEditorFrame.SetModified(const AValue: boolean);
begin
  TextEditor.Modified:=AValue;
end;

procedure Tfdbm_SynEditorFrame.SetSQLEngine(const AValue: TSQLEngineAbstract);
begin
  if FSQLEngine=AValue then exit;
  FSQLEngine:=AValue;
  if Assigned(FSQLEngine) then
  begin
    DBRecord:=fbManDataInpectorForm.DBBySQLEngine(FSQLEngine);
    TextEditor.Highlighter:=DBRecord.SynSQLSyn;
  end
  else
  begin
    DBRecord:=nil;
    TextEditor.Highlighter:=nil;
  end;
  FSQLParser.Owner:=AValue;
  ChangeVisualParams;
end;

procedure Tfdbm_SynEditorFrame.ShowSearchReplaceDialog(AReplace: boolean);
var
  SRDialog: TfrmEditSearchReplace;
begin
  SRDialog := TfrmEditSearchReplace.Create(Self, AReplace);
  // assign search options
  SRDialog.SearchBackwards := bSearchBackwards;
  SRDialog.SearchCaseSensitive := bSearchCaseSensitive;
  SRDialog.SearchFromCursor := bSearchFromCaret;
  SRDialog.SearchInSelectionOnly := bSearchSelectionOnly;
  // start with last search text
  SRDialog.SearchText:=GetCurWord;

  SRDialog.SearchTextHistory := sSearchTextHistory;
  if AReplace then
  begin
    SRDialog.ReplaceText := sReplaceText;
    SRDialog.ReplaceTextHistory := sReplaceTextHistory;
  end;
  SRDialog.SearchWholeWords := bSearchWholeWords;
  if SRDialog.ShowModal = mrOK then
  begin
    bSearchBackwards := SRDialog.SearchBackwards;
    bSearchCaseSensitive := SRDialog.SearchCaseSensitive;
    bSearchFromCaret := SRDialog.SearchFromCursor;
    bSearchSelectionOnly := SRDialog.SearchInSelectionOnly;
    bSearchWholeWords := SRDialog.SearchWholeWords;
    bSearchRegExp := SRDialog.SearchRegExp;
    sSearchText := SRDialog.SearchText;
    sSearchTextHistory := SRDialog.SearchTextHistory;
    if AReplace then
    begin
      sReplaceText := SRDialog.ReplaceText;
      sReplaceTextHistory := SRDialog.ReplaceTextHistory;
    end;
//      bSearchFromCaret := gbSearchFromCaret;
    if sSearchText <> '' then
    begin
        DoSearchReplaceText(AReplace, bSearchBackwards);
        bSearchFromCaret := True;
    end;
  end;
  SRDialog.Free;
end;

procedure Tfdbm_SynEditorFrame.UpdateStatusBar;
begin
  if Assigned(fbManagerMainForm) then
    fbManagerMainForm.UpdateEditorInfo(Self);
end;

procedure Tfdbm_SynEditorFrame.TextInsert(X, Y: integer; AText: string);
var
  P: TPoint;
begin
  P:=TextEditor.CaretXY;
  TextEditor.CaretX:=X;
  TextEditor.CaretY:=Y;
  TextEditor.InsertTextAtCaret(AText);
  TextEditor.CaretXY:=P;
end;

procedure Tfdbm_SynEditorFrame.ChangeCaseSelection(CaseAction: TCharCaseOptions
  );
var
  OldBlockBegin, OldBlockEnd: TPoint;
  OldMode: TSynSelectionMode;
begin
  if not Enabled then exit;
  if not TextEditor.SelAvail then exit;
  OldBlockBegin:=TextEditor.BlockBegin;
  OldBlockEnd:=TextEditor.BlockEnd;
  OldMode:=TextEditor.SelectionMode;
  TextEditor.BeginUpdate;
  TextEditor.BeginUndoBlock;

  case CaseAction of
    ccoUpperCase: TextEditor.SelText:=UTF8UpperCase(TextEditor.SelText);
    ccoLowerCase: TextEditor.SelText:=UTF8LowerCase(TextEditor.SelText);
//    ccoNameCase: TextEditor.SelText:=SwapCase(TextEditor.SelText);
//    ccoFirstLetterCase: TextEditor.SelText:=SwapCase(TextEditor.SelText);
    ccoChangeCase: TextEditor.SelText:=UTF8SwapCase(TextEditor.SelText);
  end;

  TextEditor.BlockBegin:=OldBlockBegin;
  TextEditor.BlockEnd:=OldBlockEnd;
  TextEditor.SelectionMode := OldMode;
  TextEditor.EndUndoBlock;
  TextEditor.EndUpdate;
end;

procedure Tfdbm_SynEditorFrame.EditorStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
begin

  edtRedo.Enabled:=TextEditor.CanRedo;
  edtUndo.Enabled:=TextEditor.CanUndo;

//  edtPaste.Enabled:=TextEditor.CanPaste;
  edtCut.Enabled:=TextEditor.SelText<>'';
  edtCopy.Enabled:=TextEditor.SelText<>'';

  UpdateStatusBar;

  if Assigned(FOnEditorChangeStatus) then
    FOnEditorChangeStatus(Self);
end;

procedure Tfdbm_SynEditorFrame.UpdateSynMarkup;
begin
  FSynMarkup.MarkupInfo.FrameColor:=clSilver;
  FSynMarkup.MarkupInfo.Background:=clLtGray;
  FSynMarkup.Enabled:=ConfigValues.ByNameAsBoolean('EditorHighlightCurrentWord', true);
  FSynMarkup.WaitTime:=ConfigValues.ByNameAsInteger('EditorHighlightCurrentWordTimeInterval', 1500);
  FSynMarkup.Trim:=true;
  FSynMarkup.FullWord:=true;
  FSynMarkup.IgnoreKeywords:=false;
end;

procedure Tfdbm_SynEditorFrame.MakeAliasList(AList: TStringList);
var
  P: TSQLParser;
  S, S1: String;
  DBObj: TDBObject;
  K: Integer;
  FPos: TParserPosition;
  FALIndex: TStringList;
  R: TSynCompletionObjItem;
begin
  if not Assigned(TextEditor.Highlighter) or (not (TextEditor.Highlighter is TSynSQLSyn)) then exit;

  if not Assigned(AList) then
  begin
    FALIndex:=TStringList.Create;
    FALIndex.Sorted:=true;
    AList:=FALIndex;
  end
  else
    FALIndex:=nil;

  P:=TSQLParser.Create(EditorText, FSQLEngine);

  while not P.Eof do
  begin
    S:=P.GetNextWord;
    if S<>'' then
    begin
      if (TextEditor.Highlighter as TSynSQLSyn).TableNames.IndexOf(S) >= 0 then
      begin
        DBObj:=FSQLEngine.DBObjectByName(S, false);
        if Assigned(DBObj) then
        begin
          FPos:=P.Position;
          S1:=P.GetNextWord;
          if CompareText(S1, 'AS')=0 then
            S1:=P.GetNextWord;

          if (P.WordType(nil, S1, nil) = stIdentificator) and ((TextEditor.Highlighter as TSynSQLSyn).TableNames.IndexOf(S1) < 0) then
          begin
            if (AList.IndexOf(S1) < 0) and not FSQLEngine.KeyWords.Find(S1) then
            begin
              if Assigned(FALIndex) then
              begin
                R:=FSynCompletionObjList.Add(DBObj);
                R.ObjectAlias:=S1;
              end;
              AList.AddObject(S1, DBObj);
            end
            else;
          end
          else
            P.Position:=FPos;
        end;
      end;
    end
  end;
  P.Free;

  if Assigned(FALIndex) then
    FALIndex.Free;
end;

{$IFDEF DEBUG}
procedure Tfdbm_SynEditorFrame.writeLog(const S: string);
begin
  MemoLog.Lines.Add(S);
end;
{$ENDIF}

procedure Tfdbm_SynEditorFrame.LMEditorChangeParams(var message: TLMNoParams);
begin
  inherited;
  ChangeVisualParams;
end;

procedure Tfdbm_SynEditorFrame.LMNotyfyDelObject(var Message: TLMessage);
begin
  inherited;
  CompletionListClear;
end;

constructor Tfdbm_SynEditorFrame.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  {$IFDEF DEBUG}
  MemoLog:=TMemo.Create(Self);
  MemoLog.Parent:=Self;
  MemoLog.Align:=alBottom;
  {$ENDIF}
  FSynCompletionObjList:=TSynCompletionObjList.Create;
  SetHandlers(true);
  SynCompletion1.OnKeyDown:=@OnSynCompletionKeyDown;
  SynCompletion1.OnCancel:=@CloseCompletion;
  FSynMarkup:=TSynEditMarkupHighlightAllCaret(TextEditor.MarkupByClass[TSynEditMarkupHighlightAllCaret]);


  TextEditor.Text:='';
  Align:=alClient;
  //
  SaveDialog1.Filter:=sFilesFilterSQL;
  OpenDialog1.Filter:=sFilesFilterSQL;
  FSQLParser:=TSQLParser.Create('', nil);

  Localize;

  UpdateSynMarkup;
end;

destructor Tfdbm_SynEditorFrame.Destroy;
begin
  HideCodeContext;
  SetHandlers(false);
  CompletionListClear;
  FreeThenNil(FSQLParser);
  FreeAndNil(FSynCompletionObjList);
  inherited Destroy;
end;

procedure Tfdbm_SynEditorFrame.SetHandlers(AEnable: boolean);
begin
  if AEnable then
    TextEditor.OnStatusChange:=@EditorStatusChange
  else
    TextEditor.OnStatusChange:=nil;
end;

function Tfdbm_SynEditorFrame.GetCurWord: string;
begin
  if TextEditor.SelText<>'' then
    Result:=TextEditor.SelText
  else
    Result:=TextEditor.GetWordAtRowCol(TextEditor.CaretXY);
end;

function Tfdbm_SynEditorFrame.GetCurWordX(out X: integer): string;
var
  FEndX: integer;
begin
  if TextEditor.SelText<>'' then
  begin
    Result:=TextEditor.SelText;
    X:=TextEditor.BlockBegin.X;
  end
  else
  begin
    Result:=TextEditor.GetWordAtRowCol(TextEditor.CaretXY);
    TextEditor.GetWordBoundsAtRowCol(TextEditor.CaretXY, X, FEndX);
  end;
end;

function Tfdbm_SynEditorFrame.GetReadOnly: boolean;
begin
  Result:=TextEditor.ReadOnly;
end;

procedure Tfdbm_SynEditorFrame.SelectCurWord;
begin
  if (GetCurWord <> '') and (TextEditor.SelText = '') then
    TextEditor.SelectWord;
end;

function Tfdbm_SynEditorFrame.SynEditAcceptDrag(const Source: TObject
  ): TControl;
begin
  if Source is TControl then
    Result:=Source as TControl
  else
  if Source is TDragControlObject then
    Result:=(Source as TDragControlObject).Control
  else
    Result:=nil;
end;


procedure Tfdbm_SynEditorFrame.FillSynCompletionList(const AFilterStr: string);
var
  i, Len, k:integer;
  R: TSynCompletionObjItem;
begin
  {$IFDEF DEBUG}
  writeLog('Tfdbm_SynEditorFrame.FillCopletionList.  AFilterStr='+AFilterStr);
  {$ENDIF}
  SynCompletion1.ItemList.BeginUpdate;
  SynCompletion1.ItemList.Clear;

  if FSynCompletionObjList.Count > 0 then
  begin
    if AFilterStr = '' then
      FSynCompletionObjList.FillStrings(SynCompletion1.ItemList)
    else
    begin
      Len:=UTF8Length(AFilterStr);
      for R in FSynCompletionObjList do
        if UTF8UpperCase(UTF8Copy(R.Caption, 1, Len)) = AFilterStr then
          SynCompletion1.ItemList.AddObject(R.Caption, R);
    end;
  end;
  SynCompletion1.ItemList.EndUpdate;
  {$IFDEF DEBUG}
  writeLog('FillCopletionList complete. Items.Count='+IntToStr(CompletionList.Count));
  {$ENDIF}
end;

procedure Tfdbm_SynEditorFrame.CompletionListClear;
var
  i, K: Integer;
begin
  {$IFDEF DEBUG}
  writeLog('Tfdbm_SynEditorFrame.CompletionListClear');
  {$ENDIF}
  for i:=0 to FSynCompletionObjList.Count-1 do
  begin
    K:=SynCompletion1.ItemList.IndexOfObject(FSynCompletionObjList[i]);
    if K>=0 then
      SynCompletion1.ItemList.Objects[K]:=nil;
  end;

  FSynCompletionObjList.Clear;
end;

function Tfdbm_SynEditorFrame.CreateCTMenuItem(const ACaption: string;
  AEventHandler: TNotifyEvent; ATag: Integer): TMenuItem;
var
  M: TMenuItem;
begin
  if MenuItem37.Count = 7 then
  begin
    M:=TMenuItem.Create(PopupMenu1);
    M.Caption:='-';
    MenuItem37.Add(M);
  end;

  Result:=TMenuItem.Create(PopupMenu1);
  Result.Caption:=ACaption;
  Result.OnClick:=AEventHandler;
  Result.Tag:=ATag;
  MenuItem37.Add(Result);
end;

function Tfdbm_SynEditorFrame.DoTestValidIdentList(S: string): Boolean;
var
  P: TSQLParser;
  F: Boolean;
  W: String;
begin
  F:=true;
  Result:=true;
  P:=TSQLParser.Create(S, nil);
  while (not P.Eof) and F do
  begin
    W:=P.GetNextWord;
    if W <> ',' then
    begin
      if P.WordType(nil, W, nil) <> stIdentificator then
      begin
        F:=false;
        Break;
      end;
    end;
  end;
  if F then
    Result:=true;
  P.Free;
end;

function Tfdbm_SynEditorFrame.DoFillIdentListFromSQL(S: string): TStrings;
var
  P: TSQLParser;
  W: String;
begin
  if S = '' then Exit;
  Result:=TStringList.Create;
  P:=TSQLParser.Create(S, nil);
  while (not P.Eof) do
  begin
    W:=P.GetNextWord;
    if W <> ',' then
    begin
      if P.WordType(nil, W, nil) = stIdentificator then
        Result.Add(W)
      else
        Break;
    end;
  end;
  P.Free;
end;

procedure Tfdbm_SynEditorFrame.CloseCompletion(Sender: TObject);
begin
  {$IFDEF DEBUG}
  writeLog('Tfdbm_SynEditorFrame.CloseCompletion');
  {$ENDIF}
  if SynCompletion1.TheForm.Visible then
    SynCompletion1.Deactivate;
  CompletionListClear;
end;

procedure Tfdbm_SynEditorFrame.MakeCompletionList;
function DoTestField(out aTableName, aCurStr:string):boolean;
var
  S:string;
  i,j:integer;
begin
  aTableName:='';
  aCurStr:='';
  Result:=false;
  with TextEditor do
  begin
    S:=UTF8Copy(LineText, 1, CaretX-1);
    I:=Length(S);
    if (S<>'') then
    begin
      if ((S[i] in ['A'..'z','"', '0'..'9','.','$']) or (Assigned(FSQLEngine) and (S[i] = FSQLEngine.QuteIdentificatorChar))) then
      begin
        while (i>0) and (S[i] in ['A'..'z','"', '0'..'9','$']) do Dec(I);
        aCurStr:=Copy(S, i+1, Length(S));

        Result:=(I>0) and (S[i]='.');
        if Result then
        begin
          j:=i-1;
          if S[j] = '"' then
          begin
            Dec(i);
            Dec(j);
            while (j>0) and (S[j] <>'"') do Dec(j);
            if J = 0 then Exit;
          end
          else
          if Assigned(FSQLEngine) and (S[j] = FSQLEngine.QuteIdentificatorChar) then
          begin
            Dec(i);
            Dec(j);
            while (j>0) and (S[j] <> FSQLEngine.QuteIdentificatorChar) do Dec(j);
            if J = 0 then Exit;
          end
          else
          while (j>0) and (S[j] in ['A'..'z', '0'..'9','$']) do Dec(j);
          aTableName:=Copy(S, j+1, i-j-1);
        end;
      end
      else
      if S[i] = ':' then
      begin
        aCurStr:=':';
        aTableName:='';
      end;
    end;
  end;
end;

procedure DoFillTableList{(ATableName:string)};

procedure DoFill2(D:TDBRootObject);
var
  i, k:integer;
  Item:TDBObject;
begin
  if not Assigned(D) then exit;

  if (D.DBObjectKind = okScheme) and (D.State <> sdboVirtualObject) then
  begin
{    k:=CompletionList.Add(D.Caption);
    CompletionList.Objects[k]:=D;}
    FSynCompletionObjList.Add(D);
  end;

  for i:=0 to D.CountGroups - 1 do
    DoFill2(D.Groups[i]);

  for i:=0 to D.CountObject-1 do
  begin;
    Item:=D[i];
    FSynCompletionObjList.Add(Item);
{    k:=CompletionList.Add(Item.Caption);
    CompletionList.Objects[k]:=Item;}
  end;
end;

var
  i:integer;
begin
  for i:=0 to FSQLEngine.Groups.Count - 1 do
    DoFill2(FSQLEngine.Groups[i] as TDBRootObject);
end;

procedure DoFillFieldList(ATableName:string);
var
  DBObj:TDBObject;
  FList: TStringList;
begin
  DBObj:=DBRecord.GetDBObject(ATableName);
  if not Assigned(DBObj) and (ATableName<>'') and (ATableName[1] = '"') and (ATableName[Length(ATableName)] = '"') then
    DBObj:=DBRecord.GetDBObject(AnsiDequotedStr(ATableName, '"'));

  if Assigned(DBObj) and (DBObj.DBObjectKind in [okPartitionTable, okTable, okView, okStoredProc, okFunction, okScheme, okSequence, okMaterializedView]) then
    FSynCompletionObjList.FillFieldList(DBObj)
  else
  begin
    FList:=TStringList.Create;
    FList.Sorted:=true;
    MakeAliasList(FList);
    if FList.IndexOf(ATableName)>=0 then
    begin
      DBObj:=TDBObject(FList.Objects[FList.IndexOf(ATableName)]);
      if Assigned(DBObj) then
        FSynCompletionObjList.FillFieldList(DBObj)
    end;
    FList.Free;

    if FSynCompletionObjList.Count = 0 then
    begin
      if Assigned(FOnGetFieldsList) then
        FOnGetFieldsList(Self, ATableName, FSynCompletionObjList, ccoNoneCase);
    end;
  end;
end;

procedure FillKeywords;
var
  i, j, k:Integer;
  KeywordList:TKeywordList;
begin
  for i:=0 to FSQLEngine.KeywordsList.Count-1 do
  begin
    KeywordList:=FSQLEngine.KeywordsList[i] as TKeywordList;
    for j:=0 to KeywordList.Count - 1 do
    begin
{      k:=CompletionList.Add(UTF8UpperCase(KeywordList[j]));
      CompletionList.Objects[k]:=KeywordList;}
      FSynCompletionObjList.Add(KeywordList.KeywordType, UTF8UpperCase(KeywordList[j]));
    end;
  end;
end;

var
  TableName:string;
  CurStr:string;
  L:TStringList;
begin
  CompletionListClear;


  if DoTestField(TableName, CurStr) then
  begin
    {$IFDEF DEBUG}
    WriteLog('DoFillFieldList(TableName) : "'+CurStr+'"');
    {$ENDIF DEBUG}
    DoFillFieldList(TableName)
  end
  else
  begin
    if Assigned(FOnGetKeyWordList) then
      FOnGetKeyWordList( Self, UpperCase(CurStr), FSynCompletionObjList, ccoNoneCase);

    MakeAliasList(nil);

    DoFillTableList;


    if Assigned(FOnGetObjAliasList) then
      FOnGetObjAliasList(Self, UpperCase(CurStr), FSynCompletionObjList, ccoNoneCase);
    FillKeywords;
  end;
end;

procedure Tfdbm_SynEditorFrame.OnSynCompletionKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:SynCompletion1.Deactivate;
  else
    Exit;
  end;
  Key:=0;
end;

type
  TDBStoredProcObjectHack = class(TDBStoredProcObject);

procedure Tfdbm_SynEditorFrame.ProcessForHint;
var
  S, S1:string;
  i, j, k:integer;
  FCodeContexts:TCodeHintInfo;
  DBObj:TDBObject;
  DBObjS:TDBStoredProcObjectHack;
  F: TDBField;
begin
  S:=TextEditor.LineText;

  if S = '' then
    exit;

  i:=TextEditor.CaretXY.X;
  K:=0;
  while (i>0) and (not (S[i] in ['(', ';'])) do
  begin
    if S[i] = ',' then Inc(K);
    Dec(i);
  end;

  if (i=0) or (S[i] = ';') then exit;

  FCodeContexts.BracketPos.X:=i;
  FCodeContexts.BracketPos.Y:=TextEditor.CaretXY.Y;

  Dec(i);
  j:=i{-1};
  while (i>1) and (S[i] in ['A'..'Z', 'a'..'z', '_', '0'..'9','.', '"']) do Dec(i);

  FCodeContexts.FunctionNamePos.X:=i;
  FCodeContexts.FunctionNamePos.Y:=TextEditor.CaretXY.Y;

  S1:=Trim(Copy(S, i, j-i + 1));
  if S1 <> '' then
  begin

    DBObj:=DBRecord.GetDBObject(s1);
    if Assigned(DBObj) and (DBObj is TDBStoredProcObject) and (DBObj.DBObjectKind in [okStoredProc, okFunction]) then
    begin
      DBObjS:=TDBStoredProcObjectHack(DBObj);
      DBObjS.RefreshObject;
      S:=DBObjS.CaptionFullPatch;
      S1:='';
      for i:=0 to DBObjS.FieldsIN.Count-1 do
      begin
        F:=DBObjS.FieldsIN[i];
        if F.IOType in [spvtInput, spvtInOut] then
        begin
          if S1<>'' then S1:=S1 + ', ';
          if i = k then S1:=S1 + '\b';
          S1:=S1 + F.FieldTypeStr;
          if i = k then S1:=S1 + '\*';
        end;
      end;

      if S1<>'' then S1:='(' + S1 + ')';
      FCodeContexts.HintText:=S + S1;
      FCodeContexts.EditorFrame:=Self;
      FCodeContexts.DBObject:=DBObj;
      ShowCodeContext(FCodeContexts);
    end;
  end;
end;

function Tfdbm_SynEditorFrame.GetPreviousToken: string;
var
  s: string;
  i: integer;
begin
  s := TextEditor.LineText;
  i := TextEditor.LogicalCaretXY.X - 1;
  if i > length(s) then
    result := ''
  else
  begin
    while (i > 0) and (s[i] > ' ') and (pos(s[i], SynCompletion1.EndOfTokenChr) = 0) do
    Begin
          dec(i);
    end;
    result := copy(s, i + 1, TextEditor.LogicalCaretXY.X - i - 1);
  end
end;

procedure Tfdbm_SynEditorFrame.ShowInsertDefSqlForm(DBObject: TDBObject;
  const TableAlis: string; const X: integer);
var
  S:string;
begin
  if not Assigned(DBRecord) then exit;
  if ShowInsertSQLDefForm(DBObject, DBRecord.SQLEngine, X - 1, TableAlis, S) then
  begin
    SelectCurWord;
    TextEditor.SelText:=Trim(S);
  end;
end;

procedure Tfdbm_SynEditorFrame.ednSetBookmark0Execute(Sender: TObject);
var
  i, X, Y, X1, Y1:integer;
begin
  i:=(Sender as TComponent).Tag;
  X:=TextEditor.CaretX;
  Y:=TextEditor.CaretY;
  if TextEditor.GetBookMark(i, X1, Y1) then
  begin
    if Y1 = Y then
      TextEditor.ClearBookMark(I)
    else
      TextEditor.SetBookMark(I, X, Y);
  end
  else
    TextEditor.SetBookMark(I, X, Y);
end;

procedure Tfdbm_SynEditorFrame.edtCopyExecute(Sender: TObject);
begin
  TextEditor.CopyToClipboard;
end;

procedure Tfdbm_SynEditorFrame.edtCutExecute(Sender: TObject);
begin
  TextEditor.CutToClipboard;
end;

procedure Tfdbm_SynEditorFrame.edtDeleteExecute(Sender: TObject);
begin
  TextEditor.ClearSelection;
end;

procedure Tfdbm_SynEditorFrame.ednGotoBookmark0Execute(Sender: TObject);
var
  i:integer;
begin
  i:=(Sender as TComponent).Tag;
  TextEditor.GotoBookMark(i);
end;

procedure Tfdbm_SynEditorFrame.ceCharUpperCaseExecute(Sender: TObject);
begin
  case TComponent(Sender).Tag of
    0:TextEditor.CommandProcessor(ecUpperCaseBlock, '', nil);
    1:TextEditor.CommandProcessor(ecLowerCaseBlock, '', nil);
    2:TextEditor.CommandProcessor(ecTitleCase, '', nil);
    3:TextEditor.CommandProcessor(ecToggleCaseBlock, '', nil);
  else
  end;
end;

procedure Tfdbm_SynEditorFrame.ceCommentCodeExecute(Sender: TObject);
var
  S: String;
begin
  S:=TextEditor.SelText;
  if S<>'' then
    TextEditor.SelText:='/*'+SysCommentStyle + S + SysCommentStyle + '*/';
end;

procedure Tfdbm_SynEditorFrame.ceUncommentCodeExecute(Sender: TObject);
var
  S, S1, S2: String;
begin
  S:=Trim(TextEditor.SelText);
  if S<>'' then
  begin
    S1 := UTF8Copy(S, 1, UTF8Length('/*'+SysCommentStyle));
    S2 := UTF8Copy(S, UTF8Length(S) - UTF8Length(SysCommentStyle + '*/') + 1, UTF8Length(SysCommentStyle + '*/'));
    if (S1 = '/*'+SysCommentStyle) and
       (S2 = SysCommentStyle + '*/') then
    begin
      S:=UTF8Copy(S, UTF8Length('/*'+SysCommentStyle)+1, UTF8Length(S));
      S:=UTF8Copy(S, 1, UTF8Length(S) - UTF8Length(SysCommentStyle + '*/'));
      TextEditor.SelText:=S;
    end;
  end;
end;

end.

