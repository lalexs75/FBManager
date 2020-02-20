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
unit fbmPGLocalVarsEditorFrameUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, rxmemds, rxdbgrid, Forms, Controls, ActnList,
  Menus, ComCtrls, db, sqlObjects, SQLEngineAbstractUnit, fdbm_SynEditorUnit, Graphics,
  fdmAbstractEditorUnit;

type
  TVarParRec = record
    VarName:string;
    VarType:string;
    VarDefValue:string;
    VarDescription:string;
  end;

  { TfbmPGLocalVarsEditorFrame }

  TfbmPGLocalVarsEditorFrame = class(TFrame)
    ActionList1: TActionList;
    dsLocalVars: TDataSource;
    lvAdd: TAction;
    lvDelete: TAction;
    lvDown: TAction;
    lvPrintList: TAction;
    lvUp: TAction;
    MenuItem10: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    PopupMenu3: TPopupMenu;
    RxDBGrid2: TRxDBGrid;
    rxLocalVars: TRxMemoryData;
    rxLocalVarsIsError: TBooleanField;
    rxLocalVarsVAR_DESC: TStringField;
    rxLocalVarsVAR_DEV_VALUE: TStringField;
    rxLocalVarsVAR_NAME: TStringField;
    rxLocalVarsVAR_TYPE: TStringField;
    ToolBar2: TToolBar;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton7: TToolButton;
    ToolButton9: TToolButton;
    procedure lvAddExecute(Sender: TObject);
    procedure lvDeleteExecute(Sender: TObject);
    procedure lvDownExecute(Sender: TObject);
    procedure lvUpExecute(Sender: TObject);
    procedure RxDBGrid2ColEnter(Sender: TObject);
    procedure RxDBGrid2GetCellProps(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor);
    procedure rxLocalVarsAfterEdit(DataSet: TDataSet);
    procedure rxLocalVarsAfterScroll(DataSet: TDataSet);
  private
    FOwnerDB: TSQLEngineAbstract;
    procedure GetCurParRecord(var R:TVarParRec);
    procedure SetCurParRecord(var R:TVarParRec);
  public
    constructor Create(TheOwner: TComponent); override;
    procedure Localize;
    function VriablesList(ForPG:boolean):string;
    procedure FillSynCompletionList(const KeyStartWord:string; const AItems:TSynCompletionObjList);
    procedure FillStringList(const AItems:TStringList); inline;
    function ParseSQL(SqlLine:string):string;
    procedure AddVariable(AVarName:string);
    procedure DoPreParse(AVarList:TStringList; AOwner: TEditorPage);
    property OwnerDB:TSQLEngineAbstract read FOwnerDB write FOwnerDB;
    //function Validate:boolean;
  end;

implementation
uses fbmSqlParserUnit, fbmToolsUnit, fbmStrConstUnit, SQLEngineCommonTypesUnit, pg_SqlParserUnit,
  PostgreSQLEngineUnit, FBSQLEngineUnit, fb_SqlParserUnit, rxdbutils,
  fbmCompillerMessagesUnit;

{$R *.lfm}

{ TfbmPGLocalVarsEditorFrame }

procedure TfbmPGLocalVarsEditorFrame.lvAddExecute(Sender: TObject);
begin
  RxDBGrid2.SetFocus;
  rxLocalVars.Append;//
end;

procedure TfbmPGLocalVarsEditorFrame.lvDeleteExecute(Sender: TObject);
begin
  if rxLocalVars.RecordCount > 0 then
  begin
    RxDBGrid2.SetFocus;
    if QuestionBoxFmt(sDeleteLocalVarQuest, [rxLocalVarsVAR_NAME.AsString]) then
      rxLocalVars.Delete;
  end;
end;

procedure TfbmPGLocalVarsEditorFrame.lvDownExecute(Sender: TObject);
var
  R1, R2: TVarParRec;
begin
  rxLocalVars.DisableControls;
  GetCurParRecord(R1);
  rxLocalVars.Next;
  GetCurParRecord(R2);
  rxLocalVars.Prior;
  SetCurParRecord(R2);
  rxLocalVars.Next;
  SetCurParRecord(R1);
  rxLocalVars.EnableControls;
end;

procedure TfbmPGLocalVarsEditorFrame.lvUpExecute(Sender: TObject);
var
  R1, R2: TVarParRec;
begin
  if rxLocalVars.RecNo < 2 then exit;

  rxLocalVars.DisableControls;
  GetCurParRecord(R1);
  rxLocalVars.Prior;
  GetCurParRecord(R2);
  rxLocalVars.Next;
  SetCurParRecord(R2);
  rxLocalVars.Prior;
  SetCurParRecord(R1);
  rxLocalVars.EnableControls;
end;

procedure TfbmPGLocalVarsEditorFrame.RxDBGrid2ColEnter(Sender: TObject);
var
  P: TStrings;
begin
  if RxDBGrid2.SelectedColumn = RxDBGrid2.ColumnByFieldName('VAR_TYPE') then
  begin
    P:=RxDBGrid2.SelectedColumn.PickList;
    FOwnerDB.TypeList.FillForTypes(P, true);
    FOwnerDB.FillDomainsList(P, false);
  end;
end;

procedure TfbmPGLocalVarsEditorFrame.RxDBGrid2GetCellProps(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor);
begin
  if rxLocalVarsIsError.AsBoolean then
    Background:=clRed;
end;

procedure TfbmPGLocalVarsEditorFrame.rxLocalVarsAfterEdit(DataSet: TDataSet);
begin
  if rxLocalVarsIsError.AsBoolean then
    rxLocalVarsIsError.AsBoolean:=false;
end;

procedure TfbmPGLocalVarsEditorFrame.rxLocalVarsAfterScroll(DataSet: TDataSet);
begin
  lvDelete.Enabled:=rxLocalVars.Active and (rxLocalVars.RecordCount > 0);
  lvDown.Enabled:=rxLocalVars.Active and (rxLocalVars.RecNo < rxLocalVars.RecordCount);
  lvUp.Enabled:=rxLocalVars.Active and (rxLocalVars.RecNo > 1);
end;

procedure TfbmPGLocalVarsEditorFrame.GetCurParRecord(var R: TVarParRec);
begin
  R.VarName:=rxLocalVarsVAR_NAME.AsString;
  R.VarType:=rxLocalVarsVAR_TYPE.AsString;
  R.VarDefValue:=rxLocalVarsVAR_DEV_VALUE.AsString;
  R.VarDescription:=rxLocalVarsVAR_DESC.AsString;
end;

procedure TfbmPGLocalVarsEditorFrame.SetCurParRecord(var R: TVarParRec);
begin
  rxLocalVars.Edit;
  rxLocalVarsVAR_NAME.AsString      := R.VarName;
  rxLocalVarsVAR_TYPE.AsString      := R.VarType;
  rxLocalVarsVAR_DEV_VALUE.AsString := R.VarDefValue;
  rxLocalVarsVAR_DESC.AsString      := R.VarDescription;
  rxLocalVars.Post;
end;

constructor TfbmPGLocalVarsEditorFrame.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  rxLocalVars.Open;
end;

procedure TfbmPGLocalVarsEditorFrame.Localize;
begin
  lvAdd.Caption:=sAddLocalVar;
  lvDelete.Caption:=sDeleteLocalVar;
  lvUp.Caption:=sMoveUpLocalVar;
  lvDown.Caption:=sMoveDownLocalVar;
  lvPrintList.Caption:=sPrintLocalVar;
  lvAdd.Hint:=sAddLocalVar;
  lvDelete.Hint:=sDeleteLocalVar;
  lvUp.Hint:=sMoveUpLocalVar;
  lvDown.Hint:=sMoveDownLocalVar;
  lvPrintList.Hint:=sPrintLocalVar;

  RxDBGrid2.ColumnByFieldName('VAR_NAME').Title.Caption:=sVarName;
  RxDBGrid2.ColumnByFieldName('VAR_TYPE').Title.Caption:=sVarType;
  RxDBGrid2.ColumnByFieldName('VAR_DEV_VALUE').Title.Caption:=sVarDefValue;
  RxDBGrid2.ColumnByFieldName('VAR_DESC').Title.Caption:=sDescription;
end;

function TfbmPGLocalVarsEditorFrame.VriablesList(ForPG: boolean): string;
var
  P: TBookMark;
begin
  Result:='';

  if rxLocalVars.State <> dsBrowse then
    rxLocalVars.Post;

  if rxLocalVars.RecordCount = 0 then exit;

  P:=rxLocalVars.Bookmark;
  rxLocalVars.DisableControls;
  rxLocalVars.First;
  while not rxLocalVars.EOF do
  begin
    Result:=Result + '  ';

    if not ForPG then
      Result:=Result + 'declare variable ';

    Result:=Result + rxLocalVarsVAR_NAME.AsString + ' ' + rxLocalVarsVAR_TYPE.AsString;

    if rxLocalVarsVAR_DEV_VALUE.AsString <> '' then
      Result:=Result + ' default ' + rxLocalVarsVAR_DEV_VALUE.AsString;

    Result:=Result + ';';

    if rxLocalVarsVAR_DESC.AsString<>'' then
      Result:=Result + ' --'+rxLocalVarsVAR_DESC.AsString;
    Result:=Result + LineEnding;
    rxLocalVars.Next;
  end;
  rxLocalVars.Bookmark:=P;
  rxLocalVars.EnableControls;

  if (Result <> '') and ForPG then
    Result:='declare' + LineEnding + Result;
end;

procedure TfbmPGLocalVarsEditorFrame.FillSynCompletionList(
  const KeyStartWord: string; const AItems: TSynCompletionObjList);
var
  B: TBookMark;
  R: TSynCompletionObjItem;
begin
  B:=rxLocalVars.Bookmark;
  rxLocalVars.DisableControls;
  try
    rxLocalVars.First;
    while not rxLocalVars.EOF do
    begin
      if (KeyStartWord = '') or (UpperCase(Copy(rxLocalVarsVAR_NAME.AsString, 1, Length(KeyStartWord))) = KeyStartWord) then
      begin
        R:=AItems.Add(scotParam, rxLocalVarsVAR_NAME.AsString, rxLocalVarsVAR_TYPE.AsString, rxLocalVarsVAR_DESC.AsString);
        R.IOTypeName:='Local';
      end;
      rxLocalVars.Next;
    end;

  finally
    rxLocalVars.Bookmark:=B;
    rxLocalVars.EnableControls;
  end;
end;

procedure TfbmPGLocalVarsEditorFrame.FillStringList(const AItems: TStringList);
begin
  FieldValueToStrings(rxLocalVars, 'VAR_NAME', AItems);
end;

function TfbmPGLocalVarsEditorFrame.ParseSQL(SqlLine: string): string;
var
  i: Integer;
  LVP: TSQLDeclareLocalVarParser;
begin
  Result:='';
  rxLocalVars.EmptyTable;
  if SqlLine = '' then exit;

  { TODO : Необходимо отнести в класс БД }
  if FOwnerDB is TSQLEnginePostgre then
    LVP:=TPGSQLDeclareLocalVarInt.Create
  else
  if FOwnerDB is TSQLEngineFireBird then
    LVP:=TPGSQLDeclareLocalVarInt.Create
  else
    exit;

  try
    LVP.ParseString(SqlLine);
    for i:=0 to LVP.Params.Count-1 do
    begin
      rxLocalVars.Append;
      rxLocalVarsVAR_NAME.AsString:=LVP.Params[i].Caption;
      rxLocalVarsVAR_TYPE.AsString:=LVP.Params[i].TypeName;
      rxLocalVarsVAR_DESC.AsString:=LVP.Params[i].Description;
      rxLocalVarsVAR_DEV_VALUE.AsString:=LVP.Params[i].DefaultValue;
      rxLocalVars.Post;
    end;
    Result:=Copy(SqlLine, LVP.CurPos, Length(SqlLine));
  finally
    LVP.Free;
  end;
  rxLocalVars.First;
end;

procedure TfbmPGLocalVarsEditorFrame.AddVariable(AVarName: string);
begin
  if not rxLocalVars.Locate('VAR_NAME', AVarName, [loCaseInsensitive]) then
  begin
    rxLocalVars.Append;
    rxLocalVarsVAR_NAME.AsString:=AVarName;
    //rxLocalVarsVAR_TYPE.AsString:=LVP.Params[i].TypeName;
    //rxLocalVarsVAR_DESC.AsString:=LVP.Params[i].Description;
    //rxLocalVarsVAR_DEV_VALUE.AsString:=LVP.Params[i].DefaultValue;
    rxLocalVars.Post;
  end;
end;

procedure TfbmPGLocalVarsEditorFrame.DoPreParse(AVarList: TStringList;
  AOwner: TEditorPage);
var
  B: TBookMark;
begin
  rxLocalVars.DisableControls;
  B:=rxLocalVars.Bookmark;
  rxLocalVars.First;
  while not rxLocalVars.EOF do
  begin
    AVarList.Add(rxLocalVarsVAR_NAME.AsString);

    if (not IsValidIdent(rxLocalVarsVAR_NAME.AsString)) then
      AOwner.ShowMsg(ppLocalVarNameNotDefined, rxLocalVarsVAR_NAME.AsString, 1, rxLocalVars.RecNo);

    if (Trim(rxLocalVarsVAR_TYPE.AsString) = '') then
      AOwner.ShowMsg(ppLocalVarTypeNotDefined, rxLocalVarsVAR_TYPE.AsString, 1, rxLocalVars.RecNo);
    rxLocalVars.Next;
  end;
  rxLocalVars.Bookmark:=B;
  rxLocalVars.EnableControls;
end;
(*
function TfbmPGLocalVarsEditorFrame.Validate: boolean;
var
  P: TBookMark;
begin
  Result:=true;
  rxLocalVars.First;
  while not rxLocalVars.EOF do
  begin
    if (not IsValidIdent(rxLocalVarsVAR_NAME.AsString)) or (Trim(rxLocalVarsVAR_TYPE.AsString) = '') then
    begin
      if Result then
        P:=rxLocalVars.Bookmark;
      rxLocalVars.Edit;
      rxLocalVarsIsError.AsBoolean:=true;
      rxLocalVars.Post;
      Result:=false;
    end;
    rxLocalVars.Next;
  end;

  if not Result then
    rxLocalVars.Bookmark:=P;
end;
*)
end.

