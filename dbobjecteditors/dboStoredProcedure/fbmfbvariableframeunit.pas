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

unit fbmFBVariableFrameUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, rxdbgrid, rxmemds, Forms, Controls, ActnList,
  ComCtrls, Menus, db, sqlObjects, SQLEngineAbstractUnit, fbmSqlParserUnit,
  fdbm_SynEditorUnit, SQLEngineCommonTypesUnit, FBSQLEngineUnit, Graphics, Grids, DBGrids;

type

  { TfbmFBVariableFrame }

  TfbmFBVariableFrame = class(TFrame)
    ActionList1: TActionList;
    dsLocalVars: TDataSource;
    lvAdd: TAction;
    lvDelete: TAction;
    lvDown: TAction;
    lvPrintList: TAction;
    lvUp: TAction;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    PopupMenu4: TPopupMenu;
    RxDBGrid1: TRxDBGrid;
    rxLocalVars: TRxMemoryData;
    rxLocalVarsParCodePage: TStringField;
    rxLocalVarsParDefValue: TStringField;
    rxLocalVarsParDesc: TStringField;
    rxLocalVarsParName: TStringField;
    rxLocalVarsParPrec: TLongintField;
    rxLocalVarsParSize: TLongintField;
    rxLocalVarsParSubType: TLongintField;
    rxLocalVarsParType: TStringField;
    rxLocalVarsParTypeOf: TBooleanField;
    ToolBar3: TToolBar;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton8: TToolButton;
    procedure lvAddExecute(Sender: TObject);
    procedure lvDeleteExecute(Sender: TObject);
    procedure lvUpExecute(Sender: TObject);
    procedure RxDBGrid1GetCellHint(Sender: TObject; Column: TColumn;
      var AText: String);
    procedure RxDBGrid1GetCellProps(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor);
    procedure rxLocalVarsAfterOpen(DataSet: TDataSet);
    procedure rxLocalVarsAfterPost(DataSet: TDataSet);
    procedure rxLocalVarsAfterScroll(DataSet: TDataSet);
    procedure rxLocalVarsBeforePost(DataSet: TDataSet);
    procedure rxLocalVarsParTypeChange(Sender: TField);
  private
    FDBObject:TDBObject;
    FTypeCol:TRxColumn;
    FSizeCol:TRxColumn;
    FPrecCol:TRxColumn;
    FTypeOfCol:TRxColumn;
    FVarType: TSPVarType;
    procedure Localize;
    procedure UpdateCtrlState;
  public
    constructor Create(TheOwner: TComponent; ADBObject:TDBObject; AVarType:TSPVarType);
    procedure LoadParams(AParams: TSQLFields);
    procedure SaveParams(AParams: TSQLFields);
    procedure FillSynGetKeyWordList(const KeyStartWord: string; const Items: TSynCompletionObjList);
    procedure AddParam(Param: TDBField);
    procedure AddVariable(AVarName:string);
    function Validate:boolean;
    procedure Clear;
  end;

implementation
uses fbmToolsUnit, fbmStrConstUnit, SQLEngineInternalToolsUnit, rxdbutils;

{$R *.lfm}
type

  { TParRecord }

  TParRecord = record
    ParCodePage: String;
    ParDefValue: String;
    ParDesc: String;
    ParName: String;
    ParPrec: Longint;
    ParSize: Longint;
    ParSubType: Longint;
    ParType: String;
    ParTypeOf:Boolean;
  end;

procedure SaveToData(var Rec:TParRecord; rxLocalVars: TRxMemoryData);
begin
  rxLocalVars.Edit;
  rxLocalVars.FieldByName('ParCodePage').AsString:=Rec.ParCodePage;
  rxLocalVars.FieldByName('ParDefValue').AsString:=Rec.ParDefValue;
  rxLocalVars.FieldByName('ParDesc').AsString:=Rec.ParDesc;
  rxLocalVars.FieldByName('ParName').AsString:=Rec.ParName;
  rxLocalVars.FieldByName('ParPrec').AsInteger:=Rec.ParPrec;
  rxLocalVars.FieldByName('ParSize').AsInteger:=Rec.ParSize;
  rxLocalVars.FieldByName('ParSubType').AsInteger:=Rec.ParSubType;
  rxLocalVars.FieldByName('ParType').AsString:=Rec.ParType;
  rxLocalVars.FieldByName('ParTypeOf').AsBoolean:=Rec.ParTypeOf;
  rxLocalVars.Post;
end;

procedure LoadFromData(var Rec:TParRecord; rxLocalVars: TRxMemoryData);
begin
  Rec.ParCodePage := rxLocalVars.FieldByName('ParCodePage').AsString;
  Rec.ParDefValue := rxLocalVars.FieldByName('ParDefValue').AsString;
  Rec.ParDesc     := rxLocalVars.FieldByName('ParDesc').AsString;
  Rec.ParName     := rxLocalVars.FieldByName('ParName').AsString;
  Rec.ParPrec     := rxLocalVars.FieldByName('ParPrec').AsInteger;
  Rec.ParSize     := rxLocalVars.FieldByName('ParSize').AsInteger;
  Rec.ParSubType  := rxLocalVars.FieldByName('ParSubType').AsInteger;
  Rec.ParType     := rxLocalVars.FieldByName('ParType').AsString;
  Rec.ParTypeOf   := rxLocalVars.FieldByName('ParTypeOf').AsBoolean;
end;


{ TfbmFBVariableFrame }

procedure TfbmFBVariableFrame.lvAddExecute(Sender: TObject);
begin
  RxDBGrid1.SetFocus;
  rxLocalVars.Append;//
end;

procedure TfbmFBVariableFrame.lvDeleteExecute(Sender: TObject);
begin
  if rxLocalVars.RecordCount > 0 then
  begin
    RxDBGrid1.SetFocus;
    if QuestionBoxFmt(sDeleteLocalVarQuest, [rxLocalVarsParName.AsString]) then
      rxLocalVars.Delete;
  end;
end;

procedure TfbmFBVariableFrame.lvUpExecute(Sender: TObject);
var
  Rec1, Rec2: TParRecord;
  P: TBookMark;
begin
  rxLocalVars.DisableControls;
  LoadFromData(Rec1, rxLocalVars);
  if (Sender as TComponent).Tag > 0 then
    rxLocalVars.Prior
  else
    rxLocalVars.Next;
  P:=rxLocalVars.Bookmark;
  LoadFromData(Rec2, rxLocalVars);
  SaveToData(Rec1, rxLocalVars);

  if (Sender as TComponent).Tag > 0 then
    rxLocalVars.Next
  else
    rxLocalVars.Prior;

  SaveToData(Rec2, rxLocalVars);
  rxLocalVars.Bookmark:=P;
  rxLocalVars.EnableControls;
end;

procedure TfbmFBVariableFrame.RxDBGrid1GetCellHint(Sender: TObject;
  Column: TColumn; var AText: String);
begin
  if (Column.Field = rxLocalVarsParName) and (Length(rxLocalVarsParName.AsString) > 31) then
    AText:='Length of param '+rxLocalVarsParName.AsString+' is too long (name bigger 31 char)';
end;

procedure TfbmFBVariableFrame.RxDBGrid1GetCellProps(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor);
begin
  if (Field = rxLocalVarsParName) and (Length(rxLocalVarsParName.AsString) > 31) then
    Background:=clRed;
end;

procedure TfbmFBVariableFrame.rxLocalVarsAfterOpen(DataSet: TDataSet);
begin
  FTypeCol:=RxDBGrid1.ColumnByFieldName('ParType');
  FSizeCol:=RxDBGrid1.ColumnByFieldName('ParSize');
  FPrecCol:=RxDBGrid1.ColumnByFieldName('ParPrec');
  FTypeOfCol:=RxDBGrid1.ColumnByFieldName('ParTypeOf');

  FDBObject.OwnerDB.TypeList.FillForTypes(FTypeCol.PickList, true);
  FDBObject.OwnerDB.FillDomainsList(FTypeCol.PickList, false);
  UpdateCtrlState;
end;

procedure TfbmFBVariableFrame.rxLocalVarsAfterPost(DataSet: TDataSet);
begin
  UpdateCtrlState;
end;

procedure TfbmFBVariableFrame.rxLocalVarsAfterScroll(DataSet: TDataSet);
var
  P: TDBMSFieldTypeRecord;
begin
  P:=FDBObject.OwnerDB.TypeList.FindType(rxLocalVarsParType.AsString);

  if Assigned(P) then
  begin
    FTypeOfCol.ReadOnly:=true;
    FSizeCol.ReadOnly:=not P.VarLen;
    FPrecCol.ReadOnly:=not P.VarDec;
  end
  else
  begin
    FSizeCol.ReadOnly:=true;
    FPrecCol.ReadOnly:=true;
    FTypeOfCol.ReadOnly:=not Assigned(TSQLEngineFireBird(FDBObject.OwnerDB).DomainsRoot.ObjByName(rxLocalVarsParType.AsString));
  end;
  UpdateCtrlState;
end;

procedure TfbmFBVariableFrame.rxLocalVarsBeforePost(DataSet: TDataSet);
begin
  if rxLocalVarsParTypeOf.IsNull then
    rxLocalVarsParTypeOf.AsBoolean:=false;
  rxLocalVarsParName.AsString:=FormatStringCase(rxLocalVarsParName.AsString, FDBObject.OwnerDB.MiscOptions.ObjectNamesCharCase);
end;

procedure TfbmFBVariableFrame.rxLocalVarsParTypeChange(Sender: TField);
var
  P: TDBMSFieldTypeRecord;
begin
  P:=FDBObject.OwnerDB.TypeList.FindType(rxLocalVarsParType.AsString);
  if Assigned(P) then
  begin
    FTypeOfCol.ReadOnly:=true;
    rxLocalVarsParTypeOf.AsBoolean:=false;
  end;
end;

constructor TfbmFBVariableFrame.Create(TheOwner: TComponent;
  ADBObject: TDBObject; AVarType: TSPVarType);
begin
  inherited Create(TheOwner);
  FDBObject:=ADBObject;
  FVarType:=AVarType;
  Name:='FBVariable' + ParamTypeFuncToStr(AVarType);
  RxDBGrid1.ColumnByFieldName('ParDefValue').Visible := AVarType <> spvtOutput;
  Localize;
  rxLocalVars.Open;
end;

procedure TfbmFBVariableFrame.Localize;
begin
  case FVarType of
    spvtLocal:begin
        lvAdd.Caption:=sAddLocalVar;
        lvDelete.Caption:=sDeleteLocalVar;
        lvPrintList.Caption:=sPrintLocalVar;

        RxDBGrid1.ColumnByFieldName('ParName').Title.Caption:=sVarName;
      end;
    spvtInput,
    spvtOutput:begin
        lvAdd.Caption:=sAddParam;
        lvDelete.Caption:=sDeleteParam;
        lvPrintList.Caption:=sPrintParams;

        RxDBGrid1.ColumnByFieldName('ParName').Title.Caption:=sParamName;
      end;
  end;
  lvUp.Caption:=sMoveUp;
  lvDown.Caption:=sMoveDown;

  RxDBGrid1.ColumnByFieldName('ParTypeOf').Title.Caption:=sTypeOf;
  RxDBGrid1.ColumnByFieldName('ParType').Title.Caption:=sType;
  RxDBGrid1.ColumnByFieldName('ParSize').Title.Caption:=sSize;
  RxDBGrid1.ColumnByFieldName('ParPrec').Title.Caption:=sPrec;
  RxDBGrid1.ColumnByFieldName('ParDefValue').Title.Caption:=sDefaultValue;
  RxDBGrid1.ColumnByFieldName('ParSubType').Title.Caption:=sSubType;
  RxDBGrid1.ColumnByFieldName('ParCodePage').Title.Caption:=sCodepage;
  RxDBGrid1.ColumnByFieldName('ParDesc').Title.Caption:=sDescription;
end;

procedure TfbmFBVariableFrame.UpdateCtrlState;
begin
  lvUp.Enabled:=rxLocalVars.Active and (rxLocalVars.RecordCount > 1) and (rxLocalVars.RecNo > 1);
  lvDown.Enabled:=rxLocalVars.Active and (rxLocalVars.RecordCount > 1) and (rxLocalVars.RecNo < rxLocalVars.RecordCount);
end;

procedure TfbmFBVariableFrame.LoadParams(AParams: TSQLFields);
var
  P: TSQLParserField;
  i: Integer;
begin
  rxLocalVars.CloseOpen;
  for P in AParams  do
    if (P.InReturn = FVarType) then
    begin
      rxLocalVars.Append;
      //rxLocalVarsParCodePage.AsString:=;
      rxLocalVarsParName.AsString:=P.Caption;
      rxLocalVarsParDefValue.AsString:=P.DefaultValue;
      rxLocalVarsParDesc.AsString:=P.Description;
      rxLocalVarsParPrec.AsInteger:=P.TypePrec;
      rxLocalVarsParSize.AsInteger:=P.TypeLen;
      //rxLocalVarsParSubType.AsInteger:=;
      rxLocalVarsParType.AsString:=P.TypeName;
      rxLocalVarsParTypeOf.AsBoolean:=P.TypeOf;
      rxLocalVars.Post;
    end;
end;

procedure TfbmFBVariableFrame.SaveParams(AParams: TSQLFields);
var
  B: TBookMark;
  P: TSQLParserField;
  D: TDBObject;
begin
  B:=rxLocalVars.Bookmark;
  rxLocalVars.DisableControls;
  try
    rxLocalVars.First;
    while not rxLocalVars.EOF do
    begin
      P:=AParams.AddParam(rxLocalVarsParName.AsString);
      P.DefaultValue:=rxLocalVarsParDefValue.AsString;
      P.Description:=rxLocalVarsParDesc.AsString;
      P.TypeName:=rxLocalVarsParType.AsString;
      D:=TSQLEngineFireBird(FDBObject.OwnerDB).DomainsRoot.ObjByName(P.TypeName);
      if Assigned(D) then
      begin
        P.TypeOf:=rxLocalVarsParTypeOf.AsBoolean;
      end
      else
      begin
        P.TypePrec:=rxLocalVarsParPrec.AsInteger;
        P.TypeLen:=rxLocalVarsParSize.AsInteger;
      end;
      P.InReturn:=FVarType;
      //rxLocalVarsParCodePage.AsString:=;
      //rxLocalVarsParSubType.AsInteger:=;
      rxLocalVars.Next;
    end;
  finally
    rxLocalVars.Bookmark:=B;
    rxLocalVars.EnableControls;
  end;
end;

procedure TfbmFBVariableFrame.FillSynGetKeyWordList(const KeyStartWord: string;
  const Items: TSynCompletionObjList);
var
  B: TBookMark;
begin
  if not rxLocalVars.Active then exit;

  B:=rxLocalVars.Bookmark;
  rxLocalVars.DisableControls;
  try
    rxLocalVars.First;
    while not rxLocalVars.EOF do
    begin
      if (KeyStartWord = '') or (KeyStartWord = ':') or (UpperCase(Copy(rxLocalVarsParName.AsString, 1, Length(KeyStartWord))) = KeyStartWord) then
        Items.Add(scotParam, rxLocalVarsParName.AsString, rxLocalVarsParType.AsString, rxLocalVarsParDesc.AsString);
      rxLocalVars.Next;
    end;
  finally
    rxLocalVars.Bookmark:=B;
    rxLocalVars.EnableControls;
  end;
end;

procedure TfbmFBVariableFrame.AddParam(Param: TDBField);
begin
  rxLocalVars.BeforePost:=nil;
  rxLocalVars.Append;
  rxLocalVarsParName.AsString:=Param.FieldName;
  rxLocalVarsParDesc.AsString:=Param.FieldDescription;
  rxLocalVarsParDefValue.AsString:=Param.FieldDefaultValue;

  if Assigned(Param.FieldDomain) then
  begin
    rxLocalVarsParType.AsString:=Param.FieldTypeDomain;
    rxLocalVarsParTypeOf.AsBoolean:=Param.FieldIsLocal;
  end
  else
    rxLocalVarsParType.AsString:=Param.FieldTypeName;

  rxLocalVarsParSize.AsInteger:=Param.FieldSize;
  rxLocalVarsParPrec.AsInteger:=Param.FieldPrec;
  rxLocalVars.Post;
  rxLocalVars.BeforePost:=@rxLocalVarsBeforePost;
end;

procedure TfbmFBVariableFrame.AddVariable(AVarName: string);
begin
 if not rxLocalVars.Locate('ParName', AVarName, [loCaseInsensitive]) then
 begin
   rxLocalVars.Append;
   rxLocalVarsParName.AsString:=AVarName;
   rxLocalVars.Post;
 end;
end;

function TfbmFBVariableFrame.Validate: boolean;
var
  P: TBookMark;
begin
  Result:=false;
  P:=rxLocalVars.Bookmark;
  rxLocalVars.First;
  while not rxLocalVars.EOF do
  begin
    if Length(rxLocalVarsParName.AsString) > 31 then
    begin
      ErrorBox('Length of '+rxLocalVarsParName.AsString + ' > 31');
      Exit;
    end;
    rxLocalVars.Next;
  end;
  rxLocalVars.Bookmark:=P;
  Result:=true;
end;

procedure TfbmFBVariableFrame.Clear;
begin
  rxLocalVars.CloseOpen;
end;

end.

