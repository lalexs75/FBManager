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

unit fbmTableEditorFieldsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, fdmAbstractEditorUnit,
  ComCtrls, rxdbgrid, rxmemds, RxDBGridExportSpreadSheet, RxDBGridPrintGrid,
  RxDBGridExportPdf, RxDBGridFooterTools, db, DbCtrls, ExtCtrls,
  SQLEngineAbstractUnit, DBGrids, Menus, LR_PGrid, ActnList,
  SQLEngineCommonTypesUnit, fbmSqlParserUnit, sqlObjects, ibmanagertypesunit,
  Controls, StdCtrls, IniFiles, LR_Class;

type

  { TfbmTableEditorFieldsFrame }

  TfbmTableEditorFieldsFrame = class(TEditorPage)
    fldGotoForeignTable: TAction;
    dsFieldDeps: TDataSource;
    fldCopy: TAction;
    fldCopyFieldName: TAction;
    edtTableName: TEdit;
    fldOrder: TAction;
    fldPrint: TAction;
    fldRefresh: TAction;
    fldEdit: TAction;
    fldDelete: TAction;
    fldNew: TAction;
    ActionList1: TActionList;
    dsFieldList: TDatasource;
    DBMemo1: TDBMemo;
    Label1: TLabel;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    PageControl1: TPageControl;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    FieldListGrid: TRxDBGrid;
    RxDBGrid1: TRxDBGrid;
    RxDBGridExportPDF1: TRxDBGridExportPDF;
    RxDBGridExportSpreadSheet1: TRxDBGridExportSpreadSheet;
    RxDBGridFooterTools1: TRxDBGridFooterTools;
    RxDBGridPrint1: TRxDBGridPrint;
    rxFieldDepsOBJECT_NAME: TStringField;
    rxFieldDepsOBJECT_TYPE: TStringField;
    rxFieldDepsOBJ_DEL: TBooleanField;
    rxFieldDepsUBJ_UPDATE: TBooleanField;
    rxFieldList: TRxMemoryData;
    rxFieldListAUTO_INC_CREATE_TRIGGER: TBooleanField;
    rxFieldListAUTO_INC_GEN_NAME: TStringField;
    rxFieldListAUTO_INC_GEN_TYPE: TLongintField;
    rxFieldListAUTO_INC_GEN_TYPE_SEQ_PARAMS: TLongintField;
    rxFieldListAUTO_INC_SEQ_INIT_VALUE: TLongintField;
    rxFieldListAUTO_INC_TRIGGER_BODY: TMemoField;
    rxFieldListAUTO_INC_TRIGGER_DESC: TMemoField;
    rxFieldListAUTO_INC_TRIGGER_NAME: TStringField;
    rxFieldListCALC_FIELD_STORED_TYPE: TLongintField;
    rxFieldListCALC_FIELD_STORED_TYPE_OLD: TLongintField;
    rxFieldListFIELD_AUTOINC: TBooleanField;
    rxFieldListFIELD_CHARSET: TStringField;
    rxFieldListFIELD_CHECK: TStringField;
    rxFieldListFIELD_COLLATE: TStringField;
    rxFieldListFIELD_COMPUTED_SOURCE: TMemoField;
    rxFieldListFIELD_DEF_VALUE: TStringField;
    rxFieldListFIELD_DESCRIPTION: TMemoField;
    rxFieldListFIELD_DESC_EX1: TStringField;
    rxFieldListFIELD_DOMAIN: TStringField;
    rxFieldListFIELD_IS_LOCAL: TBooleanField;
    rxFieldListFIELD_NAME: TStringField;
    rxFieldListFIELD_NO: TLongintField;
    rxFieldListFIELD_NOT_NULL: TBooleanField;
    rxFieldListFIELD_PK: TBooleanField;
    rxFieldListFIELD_PREC: TLongintField;
    rxFieldListFIELD_SIZE: TLongintField;
    rxFieldListFIELD_TYPE: TStringField;
    rxFieldListFIELD_UNQ: TBooleanField;
    rxFieldListFK_DESC: TMemoField;
    rxFieldListFK_FIELDS: TStringField;
    rxFieldListFK_INDEX_NAME: TStringField;
    rxFieldListFK_NAME: TStringField;
    rxFieldListFK_RULE: TLongintField;
    rxFieldListFK_TABEL_NAME: TStringField;
    rxFieldListOLD_FIELD_AUTOINC: TBooleanField;
    rxFieldListOLD_FIELD_CHARSET: TStringField;
    rxFieldListOLD_FIELD_CHECK: TStringField;
    rxFieldListOLD_FIELD_COLLATE: TStringField;
    rxFieldListOLD_FIELD_COMPUTED_SOURCE: TMemoField;
    rxFieldListOLD_FIELD_DEF_VALUE: TStringField;
    rxFieldListOLD_FIELD_DESCRIPTION: TStringField;
    rxFieldListOLD_FIELD_DOMAIN: TStringField;
    rxFieldListOLD_FIELD_NAME: TStringField;
    rxFieldListOLD_FIELD_NOT_NULL: TBooleanField;
    rxFieldListOLD_FIELD_PK: TBooleanField;
    rxFieldListOLD_FIELD_PREC: TLongintField;
    rxFieldListOLD_FIELD_SIZE: TLongintField;
    rxFieldListOLD_FIELD_TYPE: TStringField;
    rxFieldListOLD_FIELD_UNQ: TBooleanField;
    rxFieldDeps: TRxMemoryData;
    Splitter1: TSplitter;
    TabSheet1: TTabSheet;
    tabFieldDependencies: TTabSheet;
    procedure FieldListGridDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FieldListGridDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure fldCopyExecute(Sender: TObject);
    procedure fldCopyFieldNameExecute(Sender: TObject);
    procedure fldDeleteExecute(Sender: TObject);
    procedure fldEditExecute(Sender: TObject);
    procedure fldGotoForeignTableExecute(Sender: TObject);
    procedure fldNewExecute(Sender: TObject);
    procedure fldOrderExecute(Sender: TObject);
    procedure fldPrintExecute(Sender: TObject);
    procedure FieldListGridDblClick(Sender: TObject);
    procedure fldRefreshExecute(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure RxDBGrid1DblClick(Sender: TObject);
    procedure RxDBGridExportSpreadSheet1BeforeExecute(Sender: TObject);
    procedure rxFieldListAfterCancel(DataSet: TDataSet);
    procedure rxFieldListAfterDelete(DataSet: TDataSet);
    procedure rxFieldListAfterPost(DataSet: TDataSet);
    procedure rxFieldListAfterScroll(DataSet: TDataSet);
    procedure rxFieldListFIELD_COMPUTED_SOURCEGetText(Sender: TField;
      var aText: string; DisplayText: Boolean);
    procedure rxFieldListFIELD_DESC_EX1GetText(Sender: TField;
      var aText: string; DisplayText: Boolean);
  private
    procedure DoFillRecordFromField(const R: TDBField);
    procedure FillSQLField(AItem:TSQLParserField);
    procedure DoFillEditForm;
    procedure DoEditInsFieldNewTable(AIns:boolean);
    procedure ReNumberFields;
    procedure DoReorderFields(AFieldNames:TStrings);
  protected
    procedure FieldListRefresh;
    procedure UpdateControls;
    procedure UpdateFieldDependencies;
    procedure SaveEditFormData;
    procedure CompileEditFormData(ASqlObj: TSQLAlterTable);
  public
    procedure Localize;override;
    function PageName:string;override;
    function ImageName:string;override;
    procedure Activate;override;
    function DoMetod(PageAction: TEditorPageAction): boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    procedure SaveState(const SectionName:string; const Ini:TIniFile);override;
    procedure RestoreState(const SectionName:string; const Ini:TIniFile);override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses rxAppUtils, fbmStrConstUnit, ib_manager_table_editor_field_order_unit, fbmToolsUnit,
  fbmDBObjectEditorUnit, IBManDataInspectorUnit, SQLEngineInternalToolsUnit,
  fbmTableFieldEditorUnit, Clipbrd, fbmCompillerMessagesUnit;

{$R *.lfm}

{ TfbmTableEditorFieldsFrame }

procedure TfbmTableEditorFieldsFrame.FieldListGridDblClick(Sender: TObject);
begin
  DoMetod(epaEdit);
end;

procedure TfbmTableEditorFieldsFrame.fldRefreshExecute(Sender: TObject);
begin
  FieldListRefresh;
end;

procedure TfbmTableEditorFieldsFrame.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePage = tabFieldDependencies then
    rxFieldListAfterScroll(nil);
end;

procedure TfbmTableEditorFieldsFrame.PopupMenu1Popup(Sender: TObject);
var
  C: TPrimaryKeyRecord;
  i: Integer;
begin
  if (DBObject.DBObjectKind in [okPartitionTable, okTable])  and fldCopyFieldName.Enabled and (DBObject.State = sdboEdit) then
  begin
    if not TDBTableObject(DBObject).IsLoadedFK then
      TDBTableObject(DBObject).RefreshConstraintForeignKey;

    for i:=0 to TDBTableObject(DBObject).ConstraintCount-1 do
    begin
      C:=TDBTableObject(DBObject).Constraint[I];
      if C is TForeignKeyRecord then
        if Assigned(C.FieldListArr.FindParam(rxFieldListFIELD_NAME.AsString)) then
        begin
          fldGotoForeignTable.Enabled:=true;
          Exit;
        end;
    end;
  end;
  fldGotoForeignTable.Enabled:=false;
end;

procedure TfbmTableEditorFieldsFrame.RxDBGrid1DblClick(Sender: TObject);
var
  D: TDBObject;
  E: TDataBaseRecord;
  DI: TDBInspectorRecord;
begin
  if rxFieldDeps.Active and (rxFieldDeps.RecordCount>0) then
  begin
    D:=DBObject.OwnerDB.DBObjectByName(rxFieldDepsOBJECT_NAME.AsString, false);
    E:=fbManDataInpectorForm.DBBySQLEngine(DBObject.OwnerDB);
    if Assigned(E) then
    begin
      DI:=E.FindDBObject(D);
      if Assigned(DI) then
        DI.Edit;
    end;
  end;
end;

procedure TfbmTableEditorFieldsFrame.RxDBGridExportSpreadSheet1BeforeExecute(
  Sender: TObject);
begin
  RxDBGridExportSpreadSheet1.PageName:=DBObject.Caption;
  RxDBGridExportSpreadSheet1.FileName:=DBObject.Caption+'.ods';
end;

procedure TfbmTableEditorFieldsFrame.rxFieldListAfterCancel(DataSet: TDataSet);
begin
  UpdateControls;
end;

procedure TfbmTableEditorFieldsFrame.rxFieldListAfterDelete(DataSet: TDataSet);
begin
  UpdateControls;
end;

procedure TfbmTableEditorFieldsFrame.rxFieldListAfterPost(DataSet: TDataSet);
begin
  if DBObject.State <> sdboCreate then
    if rxFieldListFIELD_DESCRIPTION.AsString <> TDBDataSetObject(DBObject).Fields.FieldByName(rxFieldListFIELD_NAME.AsString).FieldDescription then
      TDBDataSetObject(DBObject).Fields.FieldByName(rxFieldListFIELD_NAME.AsString).FieldDescription:=rxFieldListFIELD_DESCRIPTION.AsString;
  UpdateControls;
end;

procedure TfbmTableEditorFieldsFrame.rxFieldListAfterScroll(DataSet: TDataSet);
begin
  UpdateControls;
  if (DBObject.State <> sdboCreate) and (PageControl1.ActivePage = tabFieldDependencies) then
    UpdateFieldDependencies;

  if Owner is TfbmDBObjectEditorForm then
    TfbmDBObjectEditorForm(Owner).CtrlUpdateActions
  else
    abort;
end;

procedure TfbmTableEditorFieldsFrame.rxFieldListFIELD_COMPUTED_SOURCEGetText(
  Sender: TField; var aText: string; DisplayText: Boolean);
begin
  if DisplayText then
    aText:=Sender.AsString;
end;

procedure TfbmTableEditorFieldsFrame.rxFieldListFIELD_DESC_EX1GetText(
  Sender: TField; var aText: string; DisplayText: Boolean);
begin
  aText:=rxFieldListFIELD_DESCRIPTION.AsString;
  if DisplayText then
    aText:=StrConvertDesc(aText);
end;

procedure TfbmTableEditorFieldsFrame.DoFillRecordFromField(const R: TDBField);
begin
  rxFieldListFIELD_NO.AsInteger:=rxFieldList.RecordCount + 1;
  rxFieldListFIELD_NAME.AsString:=R.FieldName;
  rxFieldListFIELD_TYPE.AsString:=R.FieldTypeName;
  rxFieldListFIELD_DOMAIN.AsString:=R.FieldTypeDomain;
  rxFieldListFIELD_SIZE.AsInteger:=R.FieldSize;
  rxFieldListFIELD_PREC.AsInteger:=R.FieldPrec;
  rxFieldListFIELD_DESCRIPTION.AsString:=R.FieldDescription;
  rxFieldListFIELD_PK.AsBoolean:=R.FieldPK;
  rxFieldListFIELD_UNQ.AsBoolean:=R.FieldUNIC;
  rxFieldListFIELD_NOT_NULL.AsBoolean:=R.FieldNotNull;
  rxFieldListFIELD_DEF_VALUE.AsString:=R.FieldDefaultValue;
  rxFieldListFIELD_AUTOINC.AsBoolean:=R.FieldAutoInc;
  rxFieldListFIELD_IS_LOCAL.AsBoolean:=R.FieldIsLocal;
  rxFieldListFIELD_COLLATE.AsString:=R.FieldCollateName;
  rxFieldListFIELD_CHARSET.AsString:=R.FieldCharSetName;

  if foComputed in R.FieldOptions then
  begin
    rxFieldListFIELD_COMPUTED_SOURCE.AsString:=R.FieldComputedSource;
    if foVirtual in R.FieldOptions then
      rxFieldListCALC_FIELD_STORED_TYPE.AsInteger:=1
    else
      rxFieldListCALC_FIELD_STORED_TYPE.AsInteger:=0;
  end;

  rxFieldListOLD_FIELD_AUTOINC.Assign(rxFieldListFIELD_AUTOINC);
  rxFieldListOLD_FIELD_DEF_VALUE.Assign(rxFieldListFIELD_DEF_VALUE);
  rxFieldListOLD_FIELD_DESCRIPTION.Assign(rxFieldListFIELD_DESCRIPTION);
  rxFieldListOLD_FIELD_DOMAIN.Assign(rxFieldListFIELD_DOMAIN);
  rxFieldListOLD_FIELD_NAME.Assign(rxFieldListFIELD_NAME);
  rxFieldListOLD_FIELD_NOT_NULL.Assign(rxFieldListFIELD_NOT_NULL);
  rxFieldListOLD_FIELD_PK.Assign(rxFieldListFIELD_PK);
  rxFieldListOLD_FIELD_PREC.Assign(rxFieldListFIELD_PREC);
  rxFieldListOLD_FIELD_SIZE.Assign(rxFieldListFIELD_SIZE);
  rxFieldListOLD_FIELD_TYPE.Assign(rxFieldListFIELD_TYPE);
  rxFieldListOLD_FIELD_UNQ.Assign(rxFieldListFIELD_UNQ);
  rxFieldListOLD_FIELD_COLLATE.Assign(rxFieldListFIELD_COLLATE);
  rxFieldListOLD_FIELD_COMPUTED_SOURCE.Assign(rxFieldListFIELD_COMPUTED_SOURCE);
  rxFieldListOLD_FIELD_CHARSET.Assign(rxFieldListFIELD_CHARSET);
  rxFieldListOLD_FIELD_COLLATE.Assign(rxFieldListFIELD_COLLATE);
end;

procedure TfbmTableEditorFieldsFrame.FillSQLField(AItem: TSQLParserField);
var
  P: TDBMSFieldTypeRecord;
  D: TDBObject;
begin
  if rxFieldList.Active and (rxFieldList.RecordCount > 0) then
  begin
    AItem.Caption:=rxFieldListFIELD_NAME.AsString;
    AItem.TableName:=DBObject.CaptionFullPatch;
    AItem.Description:=TrimRight(rxFieldListFIELD_DESCRIPTION.AsString);
    AItem.DefaultValue:=TrimRight(rxFieldListFIELD_DEF_VALUE.AsString);
    AItem.PrimaryKey:=rxFieldListFIELD_PK.AsBoolean;
    AItem.TypeLen:=0;
    AItem.TypePrec:=0;

    D:=DBObject.OwnerDB.DBObjectByName(rxFieldListFIELD_DOMAIN.AsString);
    if Assigned(D) and (D is TDBDomain) then
    begin
      AItem.TypeName:=TDBDomain(D).CaptionFullPatch;
    end
    else
    begin
      P:=DBObject.OwnerDB.TypeList.FindType(rxFieldListFIELD_TYPE.AsString);
      if Assigned(P) then
      begin
        AItem.TypeName:=P.TypeName;
        if P.VarLen then
        begin
          AItem.TypeLen:=rxFieldListFIELD_SIZE.AsInteger;
          if P.VarDec then
            AItem.TypePrec:=rxFieldListFIELD_PREC.AsInteger;
        end;
      end;
    end;
    //AItem.TypeOf:=rxFieldListFIELD_NAME.AsBoolean;
    if rxFieldListFIELD_NOT_NULL.AsBoolean then
      AItem.Params:=AItem.Params + [fpNotNull]
    else
      AItem.Params:=AItem.Params - [fpNotNull];

    if rxFieldListFIELD_AUTOINC.AsBoolean then
      AItem.Params:=AItem.Params + [fpAutoInc]
    else
      AItem.Params:=AItem.Params - [fpAutoInc];

    if (not (okAutoIncFields in DBObject.OwnerDB.SQLEngineCapability)) and (rxFieldListAUTO_INC_GEN_TYPE.AsInteger=1) then
    begin
      AItem.Params:=AItem.Params + [fpAutoInc];
      AItem.AutoIncInitValue:=rxFieldListAUTO_INC_SEQ_INIT_VALUE.AsInteger
{      Com
      rxFieldListAUTO_INC_GEN_TYPE_SEQ_PARAMS.AsInteger;}
    end;

    if feComputedTableFields in DBObject.OwnerDB.SQLEngileFeatures then
    begin
      AItem.ComputedSource:=rxFieldListFIELD_COMPUTED_SOURCE.AsString;
      if rxFieldListCALC_FIELD_STORED_TYPE.AsInteger = 0 then
        AItem.Params:=AItem.Params + [fpStored]
      else
      if rxFieldListCALC_FIELD_STORED_TYPE.AsInteger = 1 then
        AItem.Params:=AItem.Params + [fpVirtual]
      ;
    end;
  end;
end;

procedure TfbmTableEditorFieldsFrame.DoFillEditForm;
var
  D: TDBObject;
  P: TDBMSFieldTypeRecord;
begin
  fbmTableFieldEditorForm.ShowInitialValue(false);
  fbmTableFieldEditorForm.edtFieldName.Text := rxFieldListFIELD_NAME.AsString;
  fbmTableFieldEditorForm.cbNotNull.Checked := rxFieldListFIELD_NOT_NULL.AsBoolean;
  if fbmTableFieldEditorForm.cbAutoIncField.Visible then
    fbmTableFieldEditorForm.cbAutoIncField.Checked:=rxFieldListFIELD_AUTOINC.AsBoolean;
                                                                            //db_recent_objects
  D:=DBObject.OwnerDB.DBObjectByName(rxFieldListFIELD_DOMAIN.AsString);
  if Assigned(D) and (D is TDBDomain) then
  begin
    fbmTableFieldEditorForm.cbDomainCheck.Checked:=true;
    fbmTableFieldEditorForm.cbDomains.Text:=D.CaptionFullPatch;
    fbmTableFieldEditorForm.cbFieldType.Text:=TDBDomain(D).FieldType.TypeName;
    if TDBDomain(D).FieldType.VarLen then
    begin
      fbmTableFieldEditorForm.edtSize.Value := TDBDomain(D).FieldLength;
      if TDBDomain(D).FieldType.VarDec then
        fbmTableFieldEditorForm.edtScale.Value := TDBDomain(D).FieldDecimal;
    end;
    fbmTableFieldEditorForm.cbCollations.Text := rxFieldListFIELD_COLLATE.AsString;
  end
  else
  begin
    fbmTableFieldEditorForm.cbCustomTypeCheck.Checked:=true;
    if fbmTableFieldEditorForm.cbFieldType.Items.IndexOf(rxFieldListFIELD_TYPE.AsString) > -1 then
    begin
      fbmTableFieldEditorForm.cbFieldType.Text := rxFieldListFIELD_TYPE.AsString;
      fbmTableFieldEditorForm.ComboBox2Change(nil);
    end
    else
    begin
      P:=DBObject.OwnerDB.TypeList.FindType(rxFieldListFIELD_TYPE.AsString);
      if Assigned(P) then
      begin
        fbmTableFieldEditorForm.cbFieldType.Text := P.TypeName;
        fbmTableFieldEditorForm.ComboBox2Change(nil);
      end;
    end;
    fbmTableFieldEditorForm.edtSize.Value := rxFieldListFIELD_SIZE.AsInteger;
    fbmTableFieldEditorForm.edtScale.Value := rxFieldListFIELD_PREC.AsInteger;
    fbmTableFieldEditorForm.CB_CharSet.Text := rxFieldListFIELD_CHARSET.AsString;
    fbmTableFieldEditorForm.cbCollations.Text := rxFieldListFIELD_COLLATE.AsString;
  end;

  fbmTableFieldEditorForm.edtDescription.Text   := rxFieldListFIELD_DESCRIPTION.AsString;
  fbmTableFieldEditorForm.edtDefaultValue.Text   := rxFieldListFIELD_DEF_VALUE.AsString;
  fbmTableFieldEditorForm.cbPrimaryKey.Checked  := rxFieldListFIELD_PK.AsBoolean;
  fbmTableFieldEditorForm.edtCheck.Text := rxFieldListFIELD_CHECK.AsString;

  fbmTableFieldEditorForm.cbForignKey.Checked:=rxFieldListFK_TABEL_NAME.AsString <> '';
  if fbmTableFieldEditorForm.cbForignKey.Checked then
  begin
    fbmTableFieldEditorForm.cbFKTableName.Text:=rxFieldListFK_TABEL_NAME.AsString;
    fbmTableFieldEditorForm.cbFKTableNameChange(nil);
    fbmTableFieldEditorForm.edtFKName.Text:=rxFieldListFK_NAME.AsString;
    fbmTableFieldEditorForm.Memo1.Text:=rxFieldListFK_DESC.AsString;

    fbmTableFieldEditorForm.cbCreateFKIndex.Checked:=rxFieldListFK_INDEX_NAME.AsString <> '';
    fbmTableFieldEditorForm.edtIndexName.Text:=rxFieldListFK_INDEX_NAME.AsString;

    fbmTableFieldEditorForm.ListBox4.Items.Text:=rxFieldListFK_FIELDS.AsString;
    fbmTableFieldEditorForm.cbFKUpdateRule.ItemIndex:=Ord(rxFieldListFK_RULE.AsInteger and %00000011);
    fbmTableFieldEditorForm.cbFKDeleteRule.ItemIndex:=Ord(rxFieldListFK_RULE.AsInteger and %00001100) shr 2;
  end;

  if feComputedTableFields in DBObject.OwnerDB.SQLEngileFeatures then
  begin
    fbmTableFieldEditorForm.edtComputedSource.Text:=rxFieldListFIELD_COMPUTED_SOURCE.AsString;
    fbmTableFieldEditorForm.ComboBox2.ItemIndex:=rxFieldListCALC_FIELD_STORED_TYPE.AsInteger;
  end;

  if okSequence in DBObject.OwnerDB.SQLEngineCapability then
  begin
    fbmTableFieldEditorForm.RadioButton1.Checked:=rxFieldListAUTO_INC_GEN_TYPE.AsInteger=0;
    fbmTableFieldEditorForm.RadioButton2.Checked:=rxFieldListAUTO_INC_GEN_TYPE.AsInteger=1;
    fbmTableFieldEditorForm.SpinEdit1.Value:=rxFieldListAUTO_INC_SEQ_INIT_VALUE.AsInteger;
    fbmTableFieldEditorForm.ComboBox1.ItemIndex:=rxFieldListAUTO_INC_GEN_TYPE_SEQ_PARAMS.AsInteger;
    fbmTableFieldEditorForm.RadioButton3.Checked:=rxFieldListAUTO_INC_GEN_TYPE.AsInteger=2;
    fbmTableFieldEditorForm.RadioButton4.Checked:=rxFieldListAUTO_INC_GEN_TYPE.AsInteger=3;

    if rxFieldListAUTO_INC_GEN_TYPE.AsInteger = 2 then
      fbmTableFieldEditorForm.Edit3.Text:=rxFieldListAUTO_INC_GEN_NAME.AsString
    else
    if rxFieldListAUTO_INC_GEN_TYPE.AsInteger = 3 then
      fbmTableFieldEditorForm.ComboBox3.Text:=rxFieldListAUTO_INC_GEN_NAME.AsString;
    fbmTableFieldEditorForm.CheckBox1.Checked:=rxFieldListAUTO_INC_CREATE_TRIGGER.AsBoolean;
    fbmTableFieldEditorForm.Edit2.Text:=rxFieldListAUTO_INC_TRIGGER_NAME.AsString;
    fbmTableFieldEditorForm.EditorFrame.EditorText:=rxFieldListAUTO_INC_TRIGGER_BODY.AsString;
  end;
end;

procedure TfbmTableEditorFieldsFrame.DoEditInsFieldNewTable(AIns: boolean);
var
  P: TDBMSFieldTypeRecord;
  D: TDBObject;
  FConstList: TStringList;
  PB: TBookMark;
begin
  FConstList:=TStringList.Create;
  FConstList.Sorted:=true;

  PB:=rxFieldList.Bookmark;
  rxFieldList.DisableControls;
  rxFieldList.First;
  while not rxFieldList.EOF do
  begin
    if rxFieldListFK_NAME.AsString <> '' then FConstList.Add(rxFieldListFK_NAME.AsString);
    if rxFieldListFK_INDEX_NAME.AsString <> '' then FConstList.Add(rxFieldListFK_INDEX_NAME.AsString);
    rxFieldList.Next;
  end;
  rxFieldList.Bookmark:=PB;
  rxFieldList.EnableControls;

  fbmTableFieldEditorForm:=TfbmTableFieldEditorForm.CreateFieldEditor(DBObject as TDBTableObject, edtTableName.Text, FConstList);
  if not AIns then
  begin
    DoFillEditForm;
    fbmTableFieldEditorForm.edtTableName.Text:=edtTableName.Text;
  end
  else
  begin
    fbmTableFieldEditorForm.ShowInitialValue(false);
    fbmTableFieldEditorForm.edtTableName.Text:=edtTableName.Text;
  end;

  if fbmTableFieldEditorForm.ShowModal = mrOk then
  begin
    if AIns then
    begin
      rxFieldList.Append;
      rxFieldListFIELD_NO.AsInteger:=rxFieldList.RecordCount + 1;
    end
    else
      rxFieldList.Edit;
    SaveEditFormData;
    rxFieldList.Post;
    rxFieldListAfterScroll(nil);
  end;
  fbmTableFieldEditorForm.Free;
  FConstList.Free;
end;

procedure TfbmTableEditorFieldsFrame.ReNumberFields;
var
  P: TBookMark;
begin
  P:=rxFieldList.Bookmark;
  try
    rxFieldList.DisableControls;
    rxFieldList.First;
    while not rxFieldList.EOF do
    begin
      rxFieldList.Edit;
      rxFieldListFIELD_NO.AsInteger:=rxFieldList.RecNo;
      rxFieldList.Post;
      rxFieldList.Next;
    end;
  finally
    rxFieldList.Bookmark:=P;
    rxFieldList.EnableControls;
  end;
end;

procedure TfbmTableEditorFieldsFrame.DoReorderFields(AFieldNames: TStrings);
var
  i: Integer;
  S: String;
begin
  for i:=0 to AFieldNames.Count-1 do
  begin
    S:=AFieldNames[i];
    if rxFieldList.Locate('FIELD_NAME', S, []) then
    begin
      rxFieldList.Edit;
      rxFieldListFIELD_NO.AsInteger:=i+1;
      rxFieldList.Post;
    end;
  end;
  rxFieldList.SortOnFields('FIELD_NO');
end;

procedure TfbmTableEditorFieldsFrame.FieldListRefresh;
var
  R: TDBField;
begin
  if DBObject.State = sdboCreate then exit;
  TDBDataSetObject(DBObject).RefreshFieldList;
  rxFieldList.EmptyTable;
  rxFieldList.DisableControls;
  rxFieldList.AfterPost:=nil;
  rxFieldList.AfterScroll:=nil;
  for R in TDBDataSetObject(DBObject).Fields do
  begin
    if not R.SystemField then
    begin
      rxFieldList.Append;
      DoFillRecordFromField(R);
      rxFieldList.Post;
    end;
  end;
  rxFieldList.AfterScroll:=@rxFieldListAfterScroll;
  rxFieldList.AfterPost:=@rxFieldListAfterPost;
  rxFieldList.First;
  rxFieldList.EnableControls;

  UpdateControls;
  TfbmDBObjectEditorForm(Owner).CtrlUpdateActions;

  if Assigned(Parent) then
    FieldListGrid.OptimizeColumnsWidth('FIELD_NAME;FIELD_TYPE;FIELD_DOMAIN');
end;

procedure TfbmTableEditorFieldsFrame.UpdateControls;
begin
  fldCopyFieldName.Enabled:=rxFieldList.Active and (rxFieldList.RecordCount > 0);

  fldNew.Enabled:=utAddFields in TDBDataSetObject(DBObject).UITableOptions;
  fldEdit.Enabled:=(utEditField in TDBDataSetObject(DBObject).UITableOptions) and (rxFieldList.RecordCount > 0) and rxFieldListFIELD_IS_LOCAL.AsBoolean;
  fldDelete.Enabled:=(utDropFields in TDBDataSetObject(DBObject).UITableOptions) and (rxFieldList.RecordCount > 0) and rxFieldListFIELD_IS_LOCAL.AsBoolean;
end;

procedure TfbmTableEditorFieldsFrame.UpdateFieldDependencies;
var
  F: TDBField;
  L: TStringList;
  S: String;
  i: Integer;
  Obj: TDBObject;
begin
  F:=TDBDataSetObject(DBObject).Fields.FieldByName(rxFieldListFIELD_NAME.AsString);
  if not Assigned(F) then Exit;

  L:=F.RefreshDependenciesFromField;
  if not Assigned(L) then exit;
  rxFieldDeps.CloseOpen;
  for i:=0 to L.Count-1 do
  begin
    S:=L[i];
    rxFieldDeps.Append;
    rxFieldDepsOBJECT_NAME.AsString:=S;
    Obj:=TDBObject(L.Objects[i]);
    if Assigned(Obj) then
      rxFieldDepsOBJECT_TYPE.AsString:= Obj.OwnerRoot.GetObjectType;
    rxFieldDeps.Post;
  end;
  L.Free;
end;

procedure TfbmTableEditorFieldsFrame.SaveEditFormData;
var
  D: TDBObject;
  P: TDBMSFieldTypeRecord;
begin
  rxFieldListFIELD_AUTOINC.AsBoolean:=fbmTableFieldEditorForm.cbAutoIncField.Checked;
  rxFieldListFIELD_IS_LOCAL.AsBoolean:=true;
  rxFieldListFIELD_NAME.AsString:=fbmTableFieldEditorForm.edtFieldName.Text;
  rxFieldListFIELD_DEF_VALUE.AsString:=fbmTableFieldEditorForm.edtDefaultValue.Text;
  rxFieldListFIELD_DESCRIPTION.AsString:=fbmTableFieldEditorForm.edtDescription.Text;
  rxFieldListFIELD_NOT_NULL.AsBoolean:=fbmTableFieldEditorForm.cbNotNull.Checked;
  rxFieldListFIELD_PK.AsBoolean:=fbmTableFieldEditorForm.cbPrimaryKey.Checked;
  rxFieldListFIELD_SIZE.AsInteger:=0;
  rxFieldListFIELD_PREC.AsInteger:=0;
  if fbmTableFieldEditorForm.cbDomainCheck.Checked then
  begin
    rxFieldListFIELD_DOMAIN.AsString:=fbmTableFieldEditorForm.cbDomains.Text;
    D:=DBObject.OwnerDB.DBObjectByName(rxFieldListFIELD_DOMAIN.AsString);
    if Assigned(D) and (D is TDBDomain) then
    begin
      rxFieldListFIELD_TYPE.AsString:=TDBDomain(D).FieldType.TypeName;
      if TDBDomain(D).FieldType.VarLen then
      begin
        rxFieldListFIELD_SIZE.AsInteger:=TDBDomain(D).FieldLength;
        if TDBDomain(D).FieldType.VarDec then
          rxFieldListFIELD_PREC.AsInteger:=TDBDomain(D).FieldDecimal;
      end;
    end
    else
      rxFieldListFIELD_TYPE.AsString:='';
  end
  else
  begin
    rxFieldListFIELD_DOMAIN.AsString:='';
    P:=DBObject.OwnerDB.TypeList.FindType(fbmTableFieldEditorForm.cbFieldType.Text);
    if Assigned(P) then
    begin
      rxFieldListFIELD_TYPE.AsString:=P.TypeName;
      if P.VarLen then
      begin
        rxFieldListFIELD_SIZE.AsInteger:=fbmTableFieldEditorForm.edtSize.Value;
        if P.VarDec then
          rxFieldListFIELD_PREC.AsInteger:=fbmTableFieldEditorForm.edtScale.Value;
      end;
      if fbmTableFieldEditorForm.CB_CharSet.Enabled then
      begin
        rxFieldListFIELD_CHARSET.AsString:=fbmTableFieldEditorForm.CB_CharSet.Text;
        rxFieldListFIELD_COLLATE.AsString:=fbmTableFieldEditorForm.cbCollations.Text;
      end
      else
      begin
        rxFieldListFIELD_CHARSET.AsString:='';
        rxFieldListFIELD_COLLATE.AsString:='';
      end;
    end
    else
      raise Exception.Create('DBObject.OwnerDB.TypeList.FindType(fbmTableFieldEditorForm.cbFieldType.Text)');
  end;

  rxFieldListFIELD_UNQ.AsBoolean:=false; //fbmTableFieldEditorForm.cbPrimaryKey.Checked;
  rxFieldListFIELD_COLLATE.AsString:=fbmTableFieldEditorForm.cbCollations.Text;

  if fbmTableFieldEditorForm.cbForignKey.Checked then
  begin
    rxFieldListFK_NAME.AsString:=fbmTableFieldEditorForm.edtFKName.Text;
    rxFieldListFK_TABEL_NAME.AsString:=fbmTableFieldEditorForm.cbFKTableName.Text;

    if fbmTableFieldEditorForm.cbCreateFKIndex.Checked then
      rxFieldListFK_INDEX_NAME.AsString:=fbmTableFieldEditorForm.edtIndexName.Text
    else
      rxFieldListFK_INDEX_NAME.AsString:='';

    rxFieldListFK_FIELDS.AsString:=fbmTableFieldEditorForm.ListBox4.Items.Text;
    rxFieldListFK_RULE.AsInteger := fbmTableFieldEditorForm.cbFKUpdateRule.ItemIndex +
                                    fbmTableFieldEditorForm.cbFKDeleteRule.ItemIndex shl 2;
    rxFieldListFK_DESC.AsString := fbmTableFieldEditorForm.Memo1.Text;
  end
  else
  begin
    rxFieldListFK_NAME.AsString:='';
    rxFieldListFK_TABEL_NAME.AsString:='';
    rxFieldListFK_INDEX_NAME.AsString:='';
    rxFieldListFK_FIELDS.AsString:='';
    rxFieldListFK_RULE.AsInteger := 0;
    rxFieldListFK_DESC.AsString := '';
  end;

  if feComputedTableFields in DBObject.OwnerDB.SQLEngileFeatures then
  begin
    rxFieldListFIELD_COMPUTED_SOURCE.AsString:=TrimRight(fbmTableFieldEditorForm.edtComputedSource.Text);
    rxFieldListCALC_FIELD_STORED_TYPE.AsInteger:=fbmTableFieldEditorForm.ComboBox2.ItemIndex;
  end;

  if (okSequence in DBObject.OwnerDB.SQLEngineCapability) and (fbmTableFieldEditorForm.TabSheet6.TabVisible) then
  begin
    rxFieldListAUTO_INC_GEN_TYPE_SEQ_PARAMS.AsInteger:=0;
    if fbmTableFieldEditorForm.RadioButton1.Checked then
      rxFieldListAUTO_INC_GEN_TYPE.AsInteger:=0
    else
    if fbmTableFieldEditorForm.RadioButton2.Checked then
    begin
      rxFieldListAUTO_INC_GEN_TYPE.AsInteger:=1;
      rxFieldListAUTO_INC_GEN_TYPE_SEQ_PARAMS.AsInteger:=fbmTableFieldEditorForm.ComboBox1.ItemIndex;
    end
    else
    if fbmTableFieldEditorForm.RadioButton3.Checked then
      rxFieldListAUTO_INC_GEN_TYPE.AsInteger:=2
    else
    if fbmTableFieldEditorForm.RadioButton4.Checked then
      rxFieldListAUTO_INC_GEN_TYPE.AsInteger:=3
    else
      rxFieldListAUTO_INC_GEN_TYPE.AsInteger:=0;


    if rxFieldListAUTO_INC_GEN_TYPE.AsInteger = 2 then
      rxFieldListAUTO_INC_GEN_NAME.AsString:=fbmTableFieldEditorForm.Edit3.Text
    else
    if rxFieldListAUTO_INC_GEN_TYPE.AsInteger = 3 then
      rxFieldListAUTO_INC_GEN_NAME.AsString:=fbmTableFieldEditorForm.ComboBox3.Text;

    rxFieldListAUTO_INC_CREATE_TRIGGER.AsBoolean:=fbmTableFieldEditorForm.CheckBox1.Checked;
    rxFieldListAUTO_INC_TRIGGER_BODY.AsString:=fbmTableFieldEditorForm.EditorFrame.EditorText;
    rxFieldListAUTO_INC_TRIGGER_NAME.AsString:=fbmTableFieldEditorForm.Edit2.Text;
    rxFieldListAUTO_INC_TRIGGER_DESC.AsString:=fbmTableFieldEditorForm.EditorFrameDesc.EditorText;
    rxFieldListAUTO_INC_SEQ_INIT_VALUE.AsInteger:=fbmTableFieldEditorForm.SpinEdit1.Value;
  end;
end;

procedure TfbmTableEditorFieldsFrame.CompileEditFormData(ASqlObj: TSQLAlterTable
  );
var
  OP: TAlterTableOperator;
  C: TSQLConstraintItem;
  P1: TSQLParserField;
begin
  OP:=ASqlObj.AddOperator(ataAddColumn);
  fbmTableFieldEditorForm.FillSQLField(OP.Field);

  if fbmTableFieldEditorForm.Edit1.Visible then
  begin
    OP.InitialValue:=fbmTableFieldEditorForm.Edit1.Text;
    if Assigned(fbmTableFieldEditorForm.SelectedDomain) then
      { TODO : Возможно надо будет уточнить тип домена }
      OP.DBMSTypeName:=fbmTableFieldEditorForm.SelectedDomain.FieldType.TypeName
    else
      OP.DBMSTypeName:=OP.Field.TypeName;
  end;

  if fbmTableFieldEditorForm.cbForignKey.Checked then
  begin
    C:=OP.Constraints.Add(ctForeignKey, fbmTableFieldEditorForm.edtFKName.Text);
    C.ConstraintFields.AddParam(fbmTableFieldEditorForm.edtFieldName.Text);
    C.ForeignTable:=fbmTableFieldEditorForm.FKTableName;
    //C.ForeignFields.AddParam(fbmTableFieldEditorForm.FKFieldsName);
    C.ForeignFields.AsString:=fbmTableFieldEditorForm.FKFieldsName;
    C.ForeignKeyRuleOnUpdate:=fbmTableFieldEditorForm.ForeignKeyRuleOnUpdate;
    C.ForeignKeyRuleOnDelete:=fbmTableFieldEditorForm.ForeignKeyRuleOnDelete;
    if fbmTableFieldEditorForm.cbCreateFKIndex.Checked then
    begin
      C.IndexName:=fbmTableFieldEditorForm.edtIndexName.Text;
      case fbmTableFieldEditorForm.RadioGroup1.ItemIndex of
        0:C.IndexSortOrder:=indAscending;
        1:C.IndexSortOrder:=indDescending;
      end;
    end;
    C.Description:=TrimRight(fbmTableFieldEditorForm.Memo1.Text);
  end;

  if DBObject.CompileSQLObject(ASqlObj, [sepShowCompForm]) then
  begin
    FieldListRefresh;
    rxFieldList.Locate('FIELD_NAME', OP.Field.Caption, []);
  end;
end;

procedure TfbmTableEditorFieldsFrame.Localize;
begin
  Label1.Caption:=sTableName;
  TabSheet1.Caption:=sDescription;
  tabFieldDependencies.Caption:=sFieldDependencies;
  fldNew.Caption:=sNewField;
  fldEdit.Caption:=sEditField;
  fldDelete.Caption:=sDropField;
  fldPrint.Caption:=sPrintFieldFist;
  fldRefresh.Caption:=sRefreshFieldFist;
  fldOrder.Caption:=sFieldsOrder;
  fldCopyFieldName.Caption:=sCopyFieldName;
  fldCopy.Caption:=sCopyField;
  fldGotoForeignTable.Caption:=sGoToForeignTable;


//  FieldListGrid.ColumnByFieldName('FIELD_NO').Title.Caption:=;
  FieldListGrid.ColumnByFieldName('FIELD_PK').Title.Caption:=sPK;
  FieldListGrid.ColumnByFieldName('FIELD_UNQ').Title.Caption:=sUNQ;
  FieldListGrid.ColumnByFieldName('FIELD_NAME').Title.Caption:=sFieldName;
  FieldListGrid.ColumnByFieldName('FIELD_TYPE').Title.Caption:=sFieldType;
  FieldListGrid.ColumnByFieldName('FIELD_DOMAIN').Title.Caption:=sDomain;
  FieldListGrid.ColumnByFieldName('FIELD_AUTOINC').Title.Caption:=sAutoincremet;
  FieldListGrid.ColumnByFieldName('FIELD_NOT_NULL').Title.Caption:=sNotNull;
  FieldListGrid.ColumnByFieldName('FIELD_SIZE').Title.Caption:=sSize;
  FieldListGrid.ColumnByFieldName('FIELD_PREC').Title.Caption:=sPrec;
  FieldListGrid.ColumnByFieldName('FIELD_IS_LOCAL').Title.Caption:=sIsLocal;
  FieldListGrid.ColumnByFieldName('FIELD_DESC_EX').Title.Caption:=sDescription;
  FieldListGrid.ColumnByFieldName('FIELD_COLLATE').Title.Caption:=sCollate;
  FieldListGrid.ColumnByFieldName('FIELD_CHARSET').Title.Caption:=sCharSet;
  FieldListGrid.ColumnByFieldName('FIELD_DEF_VALUE').Title.Caption:=sDefaultValue;

  RxDBGrid1.ColumnByCaption('OBJECT_NAME').Title.Caption:=sObjectName;
  RxDBGrid1.ColumnByCaption('OBJECT_TYPE').Title.Caption:=sObjectType;
end;

procedure TfbmTableEditorFieldsFrame.fldNewExecute(Sender: TObject);
var
  FSqlObj: TSQLAlterTable;
  OP: TAlterTableOperator;
  C: TSQLConstraintItem;
begin
  if DBObject.State = sdboCreate then
    DoEditInsFieldNewTable(true)
  else
  begin
    FSqlObj:=DBObject.CreateSQLObject as TSQLAlterTable;
    if Assigned(FSqlObj) then
    begin
      fbmTableFieldEditorForm:=TfbmTableFieldEditorForm.CreateFieldEditor(DBObject as TDBTableObject, DBObject.Caption, nil);
      fbmTableFieldEditorForm.ShowInitialValue(utAlterAddFieldInitialValue in (DBObject as TDBTableObject).UITableOptions);
      if fbmTableFieldEditorForm.ShowModal = mrOk then
        CompileEditFormData(FSqlObj);
      fbmTableFieldEditorForm.Free;
      FreeAndNil(FSqlObj);
    end
    else
      ErrorBox('Error TfbmTableEditorFieldsFrame.fldNewExecute ' + DBObject.OwnerDB.ClassName);
  end;
end;

procedure TfbmTableEditorFieldsFrame.fldEditExecute(Sender: TObject);
var
  FSqlObj: TSQLAlterTable;
  OP: TAlterTableOperator;
  FIsDomain: Boolean;
  CT: TSQLConstraintItem;
begin
  if DBObject.State = sdboCreate then
    DoEditInsFieldNewTable(false)
  else
  begin
    FSqlObj:=DBObject.CreateSQLObject as TSQLAlterTable;
    if Assigned(FSqlObj) then
    begin
      fbmTableFieldEditorForm:=TfbmTableFieldEditorForm.CreateFieldEditor(DBObject as TDBTableObject, edtTableName.Text, nil);
      fbmTableFieldEditorForm.ShowInitialValue(false);
      DoFillEditForm;
      FIsDomain:=fbmTableFieldEditorForm.cbDomainCheck.Checked;
      if fbmTableFieldEditorForm.ShowModal = mrOk then
      begin
        //Изменили признак NOT NULL
        if fbmTableFieldEditorForm.cbNotNull.Checked <> rxFieldListFIELD_NOT_NULL.AsBoolean then
        begin
          if fbmTableFieldEditorForm.cbNotNull.Checked then
            OP:=FSqlObj.AddOperator(ataAlterColumnSetNotNull)
          else
            OP:=FSqlObj.AddOperator(ataAlterColumnDropNotNull);
          fbmTableFieldEditorForm.FillSQLField(OP.Field);
        end;

        //Изменили первичный ключ
        if fbmTableFieldEditorForm.cbPrimaryKey.Checked <> rxFieldListFIELD_PK.AsBoolean then
        begin
          if fbmTableFieldEditorForm.cbPrimaryKey.Checked then
          begin
            OP:=FSqlObj.AddOperator(ataAddTableConstraint);
            CT:=OP.Constraints.Add(ctPrimaryKey);
            CT.ConstraintFields.AddParam(fbmTableFieldEditorForm.edtFieldName.Text);
            CT.ConstraintName:=fbmTableFieldEditorForm.PrimaryKeyName;
          end;
        end;

        //Изменение имени колонки
        if fbmTableFieldEditorForm.edtFieldName.Text <> rxFieldListFIELD_NAME.AsString then
        begin;
          OP:=FSqlObj.AddOperator(ataRenameColumn);
          FillSQLField(OP.OldField);
          FillSQLField(OP.Field);
          OP.Field.Caption:=fbmTableFieldEditorForm.edtFieldName.Text;
        end;

        //Изменили тип или домен
        if
          (FIsDomain <> fbmTableFieldEditorForm.cbDomainCheck.Checked) or

          (fbmTableFieldEditorForm.cbDomainCheck.Checked and (fbmTableFieldEditorForm.cbDomains.Text <> rxFieldListFIELD_DOMAIN.AsString)) or

          (fbmTableFieldEditorForm.cbCustomTypeCheck.Checked and
            (
             (fbmTableFieldEditorForm.cbFieldType.Text <> rxFieldListFIELD_TYPE.AsString) or
             (fbmTableFieldEditorForm.edtSize.Value <> rxFieldListFIELD_SIZE.AsInteger) or
             (fbmTableFieldEditorForm.edtScale.Value <> rxFieldListFIELD_PREC.AsInteger)
            )
          ) then
        begin
          OP:=FSqlObj.AddOperator(ataAlterColumnSetDataType);
          fbmTableFieldEditorForm.FillSQLField(OP.Field);
        end;

        //Изменили значение по умолчанию
        if TrimRight(fbmTableFieldEditorForm.edtDefaultValue.Text) <> rxFieldListFIELD_DEF_VALUE.AsString then
        begin
          if TrimRight(fbmTableFieldEditorForm.edtDefaultValue.Text) = '' then
            OP:=FSqlObj.AddOperator(ataAlterColumnDropDefault)
          else
            OP:=FSqlObj.AddOperator(ataAlterColumnSetDefaultExp);
          fbmTableFieldEditorForm.FillSQLField(OP.Field);
        end;

        //Изменили занчение check проверки
(*
        if TrimRight(fbmTableFieldEditorForm.edtCheck.Text) <> rxFieldListFIELD_CHECK.AsString then
        begin
          if TrimRight(fbmTableFieldEditorForm.edtDefaultValue.Text) = '' then
            OP:=FSqlObj.AddOperator(ataAlterColumnDropDefault)
          else
            OP:=FSqlObj.AddOperator(ataAlterColumnSetDefaultExp);
          fbmTableFieldEditorForm.FillSQLField(OP.Field);
        end
*)
        //Изменение описания колонки
        if TrimRight(fbmTableFieldEditorForm.edtDescription.Text) <> rxFieldListFIELD_DESCRIPTION.AsString then
        begin;
          OP:=FSqlObj.AddOperator(ataAlterColumnDescription);
          fbmTableFieldEditorForm.FillSQLField(OP.Field);
        end;

        //Добавим FK
        if fbmTableFieldEditorForm.cbForignKey.Checked then
        begin
          OP:=FSqlObj.AddOperator(ataAddTableConstraint);
          CT:=OP.Constraints.Add(ctForeignKey);
          CT.ConstraintName:=fbmTableFieldEditorForm.edtFKName.Text;
          CT.ConstraintFields.AddParam(fbmTableFieldEditorForm.edtFieldName.Text);
          CT.ForeignTable:=fbmTableFieldEditorForm.FKTableName;
          CT.ForeignFields.AddParam(fbmTableFieldEditorForm.FKFieldsName);
          CT.ForeignKeyRuleOnUpdate:=fbmTableFieldEditorForm.ForeignKeyRuleOnUpdate;
          CT.ForeignKeyRuleOnDelete:=fbmTableFieldEditorForm.ForeignKeyRuleOnDelete;
          if fbmTableFieldEditorForm.cbCreateFKIndex.Checked then
            CT.IndexName:=fbmTableFieldEditorForm.edtIndexName.Text;
          CT.Description:=TrimRight(fbmTableFieldEditorForm.Memo1.Text);
        end;

        if DBObject.CompileSQLObject(FSqlObj, [sepShowCompForm]) then
        begin
          FieldListRefresh;
          rxFieldList.Locate('FIELD_NAME', fbmTableFieldEditorForm.edtFieldName.Text, []);
        end;
      end;
      fbmTableFieldEditorForm.Free;
    end
    else
      ErrorBox('Error TfbmTableEditorFieldsFrame.fldEditExecute ' + DBObject.OwnerDB.ClassName);
  end
end;

procedure TfbmTableEditorFieldsFrame.fldGotoForeignTableExecute(Sender: TObject
  );
var
  i: Integer;
  C: TPrimaryKeyRecord;
begin
  if not TDBTableObject(DBObject).IsLoadedFK then
    TDBTableObject(DBObject).RefreshConstraintForeignKey;

  for i:=0 to TDBTableObject(DBObject).ConstraintCount-1 do
  begin
    C:=TDBTableObject(DBObject).Constraint[I];
    if C is TForeignKeyRecord then
      if Assigned(C.FieldListArr.FindParam(rxFieldListFIELD_NAME.AsString)) then
      begin
        DBObject.OwnerDB.EditObject(DBObject.OwnerDB.DBObjectByName(TForeignKeyRecord(C).FKTableName, false));
        Exit;
      end;
  end;
end;

procedure TfbmTableEditorFieldsFrame.fldDeleteExecute(Sender: TObject);
var
  FieldName:string;
  FSqlObj: TSQLAlterTable;
  OP: TAlterTableOperator;
begin
  if DBObject.State = sdboCreate then
  begin
    if (rxFieldList.RecordCount > 0) and QuestionBoxFmt(sDeleteField, [rxFieldListFIELD_NAME.AsString]) then
    begin
      rxFieldList.Delete;
      ReNumberFields;
    end;
  end
  else
  begin
    FieldName:=rxFieldListFIELD_NAME.AsString;
    FSqlObj:=DBObject.CreateSQLObject as TSQLAlterTable;
    if Assigned(FSqlObj) then
    begin
      OP:=FSqlObj.AddOperator(ataDropColumn);
      OP.Field.Caption:=FieldName;
      OP.Field.TableName:=DBObject.CaptionFullPatch;
      if DBObject.CompileSQLObject(FSqlObj, [sepShowCompForm]) then
        FieldListRefresh;
    end
    else
      ErrorBox('Error TfbmTableEditorFieldsFrame.fldDeleteExecute ' + DBObject.OwnerDB.ClassName);
  end;
end;

procedure TfbmTableEditorFieldsFrame.fldCopyFieldNameExecute(Sender: TObject);
begin
  if rxFieldList.Active and (rxFieldList.RecordCount > 0) then
    Clipboard.AsText:=rxFieldListFIELD_NAME.AsString;
end;

procedure TfbmTableEditorFieldsFrame.fldCopyExecute(Sender: TObject);
var
  //FIsDomain: Boolean;
  FSqlObj: TSQLAlterTable;
begin
  if rxFieldList.RecordCount = 0 then Exit;

  fbmTableFieldEditorForm:=TfbmTableFieldEditorForm.CreateFieldEditor(DBObject as TDBTableObject, edtTableName.Text, nil);
  fbmTableFieldEditorForm.ShowInitialValue(false);
  DoFillEditForm;
  //FIsDomain:=fbmTableFieldEditorForm.cbDomainCheck.Checked;
  fbmTableFieldEditorForm.edtFieldName.Text:='';

  if fbmTableFieldEditorForm.ShowModal = mrOk then
  begin
    if DBObject.State = sdboCreate then
    begin
      rxFieldList.Append;
      rxFieldListFIELD_NO.AsInteger:=rxFieldList.RecordCount + 1;
      SaveEditFormData;
      rxFieldList.Post;
      rxFieldListAfterScroll(nil);
    end
    else
    begin
      FSqlObj:=DBObject.CreateSQLObject as TSQLAlterTable;
      if Assigned(FSqlObj) then
      begin
        CompileEditFormData(FSqlObj);
        FreeAndNil(FSqlObj);
      end;
    end;
  end;
  fbmTableFieldEditorForm.Free;
end;

procedure TfbmTableEditorFieldsFrame.FieldListGridDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  Control: TControl;
begin
  Control:=DoAcceptDrag(Source);
  Accept:=(DBObject.State = sdboCreate)
    and (Control = fbManDataInpectorForm.TreeView1) and Assigned(fbManDataInpectorForm.CurrentObject)
    and Assigned(fbManDataInpectorForm.CurrentDB)
    //and (fbManDataInpectorForm.CurrentDB.SQLEngine = DBObject.OwnerDB)
    and Assigned(fbManDataInpectorForm.CurrentObject.DBObject)
    and (fbManDataInpectorForm.CurrentObject.DBObject.DBObjectKind in [okPartitionTable, okTable, okView, okMaterializedView]);
end;

procedure TfbmTableEditorFieldsFrame.FieldListGridDragDrop(Sender,
  Source: TObject; X, Y: Integer);
var
  Control: TControl;
  FDBTable: TDBDataSetObject;
  F: TDBField;
begin
  Control:=DoAcceptDrag(Source);
  if (Control <> fbManDataInpectorForm.TreeView1) or (not Assigned(fbManDataInpectorForm.CurrentObject))
    or (not Assigned(fbManDataInpectorForm.CurrentObject.DBObject))
    //or (not (fbManDataInpectorForm.CurrentDB.SQLEngine = DBObject.OwnerDB))
    or (not (fbManDataInpectorForm.CurrentObject.DBObject.DBObjectKind in [okPartitionTable, okTable, okView, okMaterializedView])) then Exit;

  if not QuestionBox(sCopyFields) then Exit;

  FDBTable:=fbManDataInpectorForm.CurrentObject.DBObject as TDBDataSetObject;
  for F in FDBTable.Fields do
  begin
    if not (rxFieldList.Locate('FIELD_NAME', F.FieldName, []) or F.SystemField) then
    begin
      rxFieldList.Append;
      DoFillRecordFromField(F);
      rxFieldList.Post;
    end;
  end;
end;

procedure TfbmTableEditorFieldsFrame.fldOrderExecute(Sender: TObject);

procedure DoFill;
var
  P:TBookmark;
begin
  fbmTableEditorFieldOrderForm.ListBox1.Items.Clear;
  rxFieldList.DisableControls;
  P:=rxFieldList.Bookmark;
  rxFieldList.First;
  try
    while not rxFieldList.EOF do
    begin
      fbmTableEditorFieldOrderForm.ListBox1.Items.Add(rxFieldListFIELD_NAME.AsString);
      rxFieldList.Next;
    end;
  finally
    rxFieldList.Bookmark:=P;
    rxFieldList.EnableControls;
  end;
end;

begin
  fbmTableEditorFieldOrderForm:=TfbmTableEditorFieldOrderForm.Create(Application);
  DoFill;
  if fbmTableEditorFieldOrderForm.ShowModal = mrOk then
  begin
    if DBObject.State = sdboCreate then
      DoReorderFields(fbmTableEditorFieldOrderForm.ListBox1.Items)
    else
    begin
      (DBObject as TDBTableObject).SetFieldsOrder(fbmTableEditorFieldOrderForm.ListBox1.Items);
      FieldListRefresh;
    end;
  end;
  fbmTableEditorFieldOrderForm.Free;
end;

procedure TfbmTableEditorFieldsFrame.fldPrintExecute(Sender: TObject);
begin
  RxDBGridPrint1.PreviewReport;
end;

function TfbmTableEditorFieldsFrame.PageName: string;
begin
  Result:=sFields;
end;

function TfbmTableEditorFieldsFrame.ImageName: string;
begin
  Result:='';
end;

procedure TfbmTableEditorFieldsFrame.Activate;
begin
  if DBObject.State <> sdboCreate then
    FieldListRefresh;
end;

function TfbmTableEditorFieldsFrame.DoMetod(PageAction:TEditorPageAction):boolean;
begin
  Result:=true;
  case PageAction of
    epaAdd:fldNew.Execute;
    epaEdit:fldEdit.Execute;
    epaDelete:fldDelete.Execute;
    epaRefresh:FieldListRefresh;
    epaPrint:fldPrint.Execute;
  end;
end;

function TfbmTableEditorFieldsFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  case PageAction of
    epaAdd:Result:=fldNew.Enabled;
    epaEdit:Result:=fldEdit.Enabled;
    epaDelete:Result:=fldDelete.Enabled;
    epaCompile:Result:=(DBObject.State = sdboCreate) and (not (DBObject is TDBViewObject))
  else
    Result:=PageAction in [epaPrint, epaRefresh];
  end;
end;

procedure TfbmTableEditorFieldsFrame.SaveState(const SectionName: string;
  const Ini: TIniFile);
begin
  SaveRxDBGridState(SectionName+'.FieldListGrid', Ini, FieldListGrid);
end;

procedure TfbmTableEditorFieldsFrame.RestoreState(const SectionName: string;
  const Ini: TIniFile);
begin
  RestoreRxDBGridState(SectionName+'.FieldListGrid', Ini, FieldListGrid);
end;

constructor TfbmTableEditorFieldsFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);

  PageControl1.ActivePageIndex:=0;
  rxFieldList.Open;
  FieldListRefresh;
  Panel1.Visible:=DBObject.State = sdboCreate;
  FieldListGrid.ColumnByFieldName('FIELD_DOMAIN').Visible:=okDomain in DBObject.OwnerDB.SQLEngineCapability;
  FieldListGrid.ColumnByFieldName('FIELD_AUTOINC').Visible:=okAutoIncFields in DBObject.OwnerDB.SQLEngineCapability;
  FieldListGrid.ColumnByFieldName('FIELD_IS_LOCAL').Visible:=feInheritedTables in DBObject.OwnerDB.SQLEngileFeatures;
  FieldListGrid.ColumnByFieldName('FIELD_COMPUTED_SOURCE').Visible:=feComputedTableFields in DBObject.OwnerDB.SQLEngileFeatures;

  tabFieldDependencies.TabVisible:=(feFieldDepsList in DBObject.OwnerDB.SQLEngileFeatures) and (DBObject.State <> sdboCreate);

  if DBObject.State <> sdboCreate then
    edtTableName.Text:=DBObject.Caption;


  UpdateControls;
end;

function TfbmTableEditorFieldsFrame.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  R: TSQLCreateTable;
  F: TSQLParserField;
  C: TSQLConstraintItem;
  C_PK : TSQLConstraintItem;
  AIO: TAutoIncObject;
  FExistsPK:Boolean;
begin
  if DBObject is TDBViewObject then
  begin
    //for View this editor READ ONLY
    Result:=true;
    exit;
  end;

  FExistsPK:=false;
  if (DBObject.State = sdboCreate) then
  begin
    if edtTableName.Text = '' then
    begin
      ErrorBox(sEnterTableName);
      Exit(false);
    end;
    C_PK:=nil;

    R:=ASQLObject as TSQLCreateTable;
    R.Name:=edtTableName.Text;
    rxFieldList.First;
    while not rxFieldList.EOF do
    begin
      F:=R.Fields.AddParam(rxFieldListFIELD_NAME.AsString);
      FillSQLField(F);
      if F.PrimaryKey then
        FExistsPK:=true;
      if F.PrimaryKey and(fePKAutoName in DBObject.OwnerDB.SQLEngileFeatures)  then
      begin
        //Костыль для птицы и имени PK
        F.PrimaryKey:=false;
        if not Assigned(C_PK) then
        begin
          C_PK:=R.SQLConstraints.Add(ctPrimaryKey);
          C_PK.ConstraintName:=FormatStringCase('pk_' + UpperCase(edtTableName.Text),DBObject.OwnerDB.MiscOptions.ObjectNamesCharCase);
          C_PK.IndexName:=FormatStringCase('idx_pk_' + UpperCase(edtTableName.Text),DBObject.OwnerDB.MiscOptions.ObjectNamesCharCase);
        end;
        C_PK.ConstraintFields.AddParam(F.Caption);
      end;
      rxFieldList.Next;
    end;

    rxFieldList.First;
    while not rxFieldList.EOF do
    begin
      if rxFieldListFK_TABEL_NAME.AsString <> '' then
      begin
        C:=R.SQLConstraints.Add(ctForeignKey, rxFieldListFK_NAME.AsString);
        C.ForeignTable:=rxFieldListFK_TABEL_NAME.AsString;
        C.ConstraintFields.AddParam(rxFieldListFIELD_NAME.AsString);
        C.IndexName:=rxFieldListFK_INDEX_NAME.AsString;
        C.ForeignFields.AddParam(Trim(rxFieldListFK_FIELDS.AsString));
        C.ForeignKeyRuleOnUpdate:=TForeignKeyRule(rxFieldListFK_RULE.AsInteger and %00000011);
        C.ForeignKeyRuleOnDelete:=TForeignKeyRule((rxFieldListFK_RULE.AsInteger and %00001100) shr 2);
        C.Description:=TrimRight(rxFieldListFK_DESC.AsString);
      end;
      rxFieldList.Next;
    end;

    AIO:=nil;
    rxFieldList.First;
    while not rxFieldList.EOF do
    begin
      if Assigned(AIO) then
        AIO.Clear;

      if (rxFieldListAUTO_INC_GEN_TYPE.AsInteger in [2]) and (rxFieldListAUTO_INC_GEN_NAME.AsString <> '') then
      begin
        if not Assigned(AIO) then
          AIO:=R.GetAutoIncObject;
        AIO:=R.GetAutoIncObject;
        if Assigned(AIO) then
          AIO.SequenceName:=rxFieldListAUTO_INC_GEN_NAME.AsString;
      end
      else
      if (rxFieldListAUTO_INC_GEN_TYPE.AsInteger = 1) then
      begin
        F:=R.Fields.FindParam(rxFieldListFIELD_NAME.AsString);
        if rxFieldListAUTO_INC_GEN_TYPE_SEQ_PARAMS.AsInteger = 0 then
          F.AutoIncType:=faioGeneratedAlways
        else
          F.AutoIncType:=faioGeneratedByDefault;
      end;

      if (rxFieldListAUTO_INC_CREATE_TRIGGER.AsBoolean) and (rxFieldListAUTO_INC_TRIGGER_BODY.AsString<>'') then
      begin
        if not Assigned(AIO) then
          AIO:=R.GetAutoIncObject;
        if Assigned(AIO) then
        begin
          AIO.TriggerName:=rxFieldListAUTO_INC_TRIGGER_NAME.AsString;
          AIO.TriggerBody:=rxFieldListAUTO_INC_TRIGGER_BODY.AsString;
          AIO.TriggerDesc:=rxFieldListAUTO_INC_TRIGGER_DESC.AsString;
        end;
      end;

      if Assigned(AIO) then
        AIO.MakeObjects;
      rxFieldList.Next;
    end;

    if Assigned(AIO) then
      FreeAndNil(AIO);

    if not FExistsPK then
      ShowMsg(ppTableNotHavePK, R.FullName, 0, 0);
  end;
  Result:=true;
end;

end.

{

Новое поле - Insert
Изменить - Shift+Insert
Удалить - Del
Обновить - F5
Печать - Ctrl+P
Копировать имя поля - Alt+C (логичное Ctrl+C занято системой и копирует значение выделенной ячейки, что удобно).
Порядок полей - Alt+S
}
