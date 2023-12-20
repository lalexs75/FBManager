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

unit fbmTableFieldEditorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Buttons, SynEdit, SynHighlighterSQL, DB, DBGrids, rxmemds, Spin,
  sqlObjects, ibmanagertypesunit, ButtonPanel, ExtCtrls, SQLEngineAbstractUnit,
  fdbm_SynEditorUnit;

type

  { TfbmTableFieldEditorForm }

  TfbmTableFieldEditorForm = class(TForm)
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    ButtonPanel1: TButtonPanel;
    cbNotNull: TCheckBox;
    cbPrimaryKey: TCheckBox;
    cbDomains: TComboBox;
    cbFieldType: TComboBox;
    cbAutoIncField: TCheckBox;
    cbCreateFKIndex: TCheckBox;
    cbForignKey: TCheckBox;
    cbFKTableName: TComboBox;
    cbFKUpdateRule: TComboBox;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    CB_CharSet: TComboBox;
    cbCollations: TComboBox;
    cbFKDeleteRule: TComboBox;
    Datasource1: TDatasource;
    dbGrid2: TdbGrid;
    Edit1: TEdit;
    Edit2: TEdit;
    edtDescription: TSynEdit;
    edtFKName: TEdit;
    edtIndexName: TEdit;
    edtTableName: TEdit;
    edtFieldName: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    edtTypeDesc: TMemo;
    ListBox3: TListBox;
    ListBox4: TListBox;
    Memo1: TMemo;
    PageControl1: TPageControl;
    cbDomainCheck: TRadioButton;
    cbCustomTypeCheck: TRadioButton;
    PageControl2: TPageControl;
    PageControl3: TPageControl;
    Panel1: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioGroup1: TRadioGroup;
    RxMemoryData1: TRxMemoryData;
    edtSize: TSpinEdit;
    edtScale: TSpinEdit;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    edtComputedSource: TSynEdit;
    edtCheck: TSynEdit;
    edtDefaultValue: TSynEdit;
    SpinEdit1: TSpinEdit;
    SynSQLSyn1: TSynSQLSyn;
    TabSheet1: TTabSheet;
    TabForignKey: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    tabArray: TTabSheet;
    TabSheet6: TTabSheet;
    TabComputedSource: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure cbDomainsChange(Sender: TObject);
    procedure cbNotNullChange(Sender: TObject);
    procedure CB_CharSetChange(Sender: TObject);
    procedure cbForignKeyChange(Sender: TObject);
    procedure cbCreateFKIndexChange(Sender: TObject);
    procedure cbFKTableNameChange(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure edtFieldNameChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure ListBox3DblClick(Sender: TObject);
    procedure ListBox4DblClick(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure RadioButton4Change(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    FTable:TDBTableObject;
    FTableName:string;
    SQLEngine:TSQLEngineAbstract;
    FConstList:TStringList;
    procedure FillDomainList;
    procedure FillGeneratorList;
    procedure FillStdTypes;
    procedure FillTablesList;
    function GetDomainStr:string;
    function GetFieldName: string;
    function GetFKFieldsName: string;
    function GetFKTableName: string;
    function GetSelectedDomain: TDBDomain;
    procedure SetFieldName(const AValue: string);
    procedure MakeFKName;
    procedure CreateIndexName;
    procedure SetFKFieldsName(AValue: string);
    procedure SetFKTableName(AValue: string);
    function DoConvertGenNames(S:string):string;
    function DoConvertTriggerNames(S:string):string;
    procedure DoUpdateAutoIncGenName;
    procedure DoUpdateAutoIncTrigger;
    procedure DoCheckFiledNameAndTypeFK;
  public
    EditorFrame: Tfdbm_SynEditorFrame;
    EditorFrameDesc: Tfdbm_SynEditorFrame;
    procedure Localize;
    constructor CreateFieldEditor(ATable: TDBTableObject; ATableName: string; AConstList:TStringList);
    procedure ShowInitialValue(AShow:boolean);
    procedure FillSQLField(AItem:TSQLParserField);
    property FieldName:string read GetFieldName write SetFieldName;
    property SelectedDomain:TDBDomain read GetSelectedDomain;
    property FKTableName:string read GetFKTableName write SetFKTableName;
    property FKFieldsName:string read GetFKFieldsName write SetFKFieldsName;
    function ForeignKeyRuleOnUpdate:TForeignKeyRule;
    function ForeignKeyRuleOnDelete:TForeignKeyRule;
    function PrimaryKeyName:string;
  end;

var
  fbmTableFieldEditorForm: TfbmTableFieldEditorForm;

implementation
uses ibmanagertablefieldeditorArrayBoundunit, strutils, rxAppUtils, rxboxprocs,
  fb_utils, SQLEngineCommonTypesUnit, fbmToolsUnit, SQLEngineInternalToolsUnit,
  fbmStrConstUnit;

{$R *.lfm}

{ TfbmTableFieldEditorForm }

procedure TfbmTableFieldEditorForm.RadioButton2Change(Sender: TObject);
begin
  cbDomains.Enabled:=cbDomainCheck.Checked;
  Button3.Enabled:=cbDomainCheck.Checked;

  cbFieldType.Enabled:=cbCustomTypeCheck.Checked;
  ComboBox2Change(nil);
end;

procedure TfbmTableFieldEditorForm.Button3Click(Sender: TObject);
var
  ObjName:string;
begin
{  if FDBRec.DomainsRecord.NewGrpItem(ObjName) then
  begin
    FillDomainList;
    cbDomains.Text:=ObjName;
  end;}
end;

procedure TfbmTableFieldEditorForm.Button4Click(Sender: TObject);
begin
  ibmanagertablefieldeditorArrayBoundForm:=TibmanagertablefieldeditorArrayBoundForm.Create(Application);
  if ibmanagertablefieldeditorArrayBoundForm.ShowModal = mrOk then
  begin
  end;
  ibmanagertablefieldeditorArrayBoundForm.Free;
end;

procedure TfbmTableFieldEditorForm.cbDomainsChange(Sender: TObject);
var
  P:TDBObject;
  T: TDBMSFieldTypeRecord;
  S: String;
begin
  if (not edtDescription.Modified) and (cbDomains.ItemIndex>-1) and (cbDomains.ItemIndex<cbDomains.Items.Count) then
  begin
    P:=TDBObject(cbDomains.Items.Objects[cbDomains.ItemIndex]);

    if Trim(edtDescription.Text) = '' then
    begin
      edtDescription.Text:=P.Description;
      edtDescription.Modified:=false;
    end;

    S:='';
    if P is TDBDomain then
    begin
      T:=TDBDomain(P).FieldType;
      if Assigned(T) then
        S:=T.GetFieldTypeStr(TDBDomain(P).FieldLength, TDBDomain(P).FieldDecimal) + '  ' + TrimRight(T.Description) + LineEnding;
    end;

    edtTypeDesc.Text:=S + Trim(P.Description);
  end;
  cbNotNullChange(nil);
end;

procedure TfbmTableFieldEditorForm.cbNotNullChange(Sender: TObject);
var
  NN: Boolean;
  P: TDBObject;
begin
  if Edit1.Visible then
  begin
    NN:=cbNotNull.Checked;
    if cbDomainCheck.Checked and (cbDomains.ItemIndex>-1) and (cbDomains.ItemIndex < cbDomains.Items.Count) then
    begin
      P:=TDBObject(cbDomains.Items.Objects[cbDomains.ItemIndex]);
      if Assigned(P) and (P is TDBDomain) then
      begin
        if not P.Loaded then P.RefreshObject;
        NN:=NN or TDBDomain(P).NotNull;
      end;
    end;
    Label15.Enabled:=NN;
    Edit1.Enabled:=NN;
  end;
end;

procedure TfbmTableFieldEditorForm.CB_CharSetChange(Sender: TObject);
begin
   cbCollations.Items.Clear;
  if CB_CharSet.Text <> '' then
    SQLEngine.FillCollationList(CB_CharSet.Text, cbCollations.Items);
end;

procedure TfbmTableFieldEditorForm.cbForignKeyChange(Sender: TObject);
begin
  TabForignKey.TabVisible:=cbForignKey.Checked;
  if cbForignKey.Checked then
  begin
    PageControl1.ActivePage:=TabForignKey;
    MakeFKName;
  end;
end;

procedure TfbmTableFieldEditorForm.cbCreateFKIndexChange(Sender: TObject);
begin
  Label14.Enabled:=cbCreateFKIndex.Checked;
  edtIndexName.Enabled:=cbCreateFKIndex.Checked;

  if cbCreateFKIndex.Checked then
    CreateIndexName;
end;

procedure TfbmTableFieldEditorForm.cbFKTableNameChange(Sender: TObject);
var
  T:TDBTableObject;
  i:integer;
begin
  ListBox4.Items.Clear;
  I:=cbFKTableName.ItemIndex;
  if (i>=0) and (i<cbFKTableName.Items.Count) then
  begin
    T:=TDBTableObject(cbFKTableName.Items.Objects[i]);
    ListBox3.Items.Clear;
    T.FillFieldList(ListBox3.Items, ccoNoneCase, False);
    if ListBox3.Items.Count>0 then
      ListBox3.ItemIndex:=0;
  end;
end;

procedure TfbmTableFieldEditorForm.ComboBox2Change(Sender: TObject);
var
  P:TDBMSFieldTypeRecord;
begin
  if (cbFieldType.ItemIndex<0) or (cbFieldType.ItemIndex>=SQLEngine.TypeList.Count) then
    exit;
  P:=SQLEngine.TypeList[cbFieldType.ItemIndex];
  edtTypeDesc.Text:=P.Description;

  CB_CharSet.Enabled:=P.DBType in dbFieldTypesCharacter;
  Label8.Enabled:=CB_CharSet.Enabled;
  cbCollations.Enabled:=CB_CharSet.Enabled;
  Label9.Enabled:=CB_CharSet.Enabled;

  edtSize.Enabled:=P.VarLen and cbCustomTypeCheck.Checked;
  Label6.Enabled:=edtSize.Enabled;

  edtScale.Enabled:=P.VarDec and cbCustomTypeCheck.Checked;
  Label7.Enabled:=edtScale.Enabled;

  if P.VarLen then
  begin
    { TODO : Необходимо ввести константы максимальной длинны и макс. длинно дробной части }
    if P.DBType in dbFieldTypesCharacter then
      edtSize.MaxValue:=65535
    else
      edtSize.MaxValue:=20;
  end;
end;

procedure TfbmTableFieldEditorForm.edtFieldNameChange(Sender: TObject);
begin
  if TabSheet6.TabVisible then
  begin
    DoUpdateAutoIncGenName;
    DoUpdateAutoIncTrigger;
  end;
end;

procedure TfbmTableFieldEditorForm.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
var
  P: TDBObject;
  NN: Boolean;
begin
  if ModalResult = mrOk then
  begin
    //CanClose:=DBIsValidIdent(edtFieldName.Text);
    CanClose:=Trim(edtFieldName.Text)<>'';
   // if CanClose then
   //   CanClose:=DBIsValidIdent(edtFieldName.Text);
   //  else
    if CanClose then
    begin
      if cbDomainCheck.Checked then
        CanClose:=cbDomains.ItemIndex>-1
      else
        CanClose:=cbFieldType.ItemIndex>-1;
      if not CanClose then
        ErrorBox(sFieldTypeReq)
      else
      begin
        if Edit1.Visible and (Trim(edtComputedSource.Text) = '') then
        begin
          NN:=cbNotNull.Checked;
          if cbDomainCheck.Checked then
          begin
            P:=TDBObject(cbDomains.Items.Objects[cbDomains.ItemIndex]);
            if Assigned(P) and (P is TDBDomain) then
              NN:=NN or TDBDomain(P).NotNull;
          end;
          if NN and (Edit1.Text = '') then
          begin
            ErrorBox(sFieldInitialValueReq);
            PageControl1.ActivePage:=TabSheet1;
            Edit1.SetFocus;
            CanClose:=false;
          end;
        end;
      end;
    end
    else
    begin
      ErrorBox(sFieldNameReq);
      edtFieldName.SetFocus;
    end;
  end;
end;

procedure TfbmTableFieldEditorForm.ListBox3DblClick(Sender: TObject);
begin
  SpeedButton4.Click;
end;

procedure TfbmTableFieldEditorForm.ListBox4DblClick(Sender: TObject);
begin
  SpeedButton3.Click;
end;

procedure TfbmTableFieldEditorForm.RadioButton4Change(Sender: TObject);
begin
  Label16.Enabled:=RadioButton2.Checked;
  SpinEdit1.Enabled:=RadioButton2.Checked;
  ComboBox1.Enabled:=RadioButton2.Checked;

  Label4.Enabled:=RadioButton3.Checked;
  Edit3.Enabled:=RadioButton3.Checked;
  
  Label5.Enabled:=RadioButton4.Checked;
  ComboBox3.Enabled:=RadioButton4.Checked;

  CheckBox1.Enabled:=RadioButton3.Checked or RadioButton4.Checked;
  Label17.Enabled:=CheckBox1.Enabled and CheckBox1.Checked;
  PageControl2.Enabled:=CheckBox1.Enabled and CheckBox1.Checked;
  Edit2.Enabled:=CheckBox1.Enabled and CheckBox1.Checked;
  EditorFrame.Enabled:=CheckBox1.Enabled and CheckBox1.Checked;
  EditorFrameDesc.Enabled:=CheckBox1.Enabled and CheckBox1.Checked;

  DoUpdateAutoIncTrigger;
end;

procedure TfbmTableFieldEditorForm.SpeedButton4Click(Sender: TObject);
begin
  if (Sender as TSpeedButton).Tag = 3 then
  begin
    BoxMoveSelectedItems(ListBox3, ListBox4);
    if ConfigValues.ByNameAsBoolean('Fields editro/Ask to fill name from FK', true) then
      DoCheckFiledNameAndTypeFK;
  end
  else
    BoxMoveSelectedItems(ListBox4, ListBox3)
end;

procedure TfbmTableFieldEditorForm.FillDomainList;
begin
  if Assigned(SQLEngine) then
  begin
    //cbDomains.Items.Clear;
    SQLEngine.FillDomainsList(cbDomains.Items, true);
  end;
end;

procedure TfbmTableFieldEditorForm.FillGeneratorList;
begin
  if Assigned(SQLEngine) then
  begin
    ComboBox3.Items.Clear;
    SQLEngine.FillListForNames(ComboBox3.Items, [okSequence]);
  end;
end;

procedure TfbmTableFieldEditorForm.FillStdTypes;
begin
  CB_CharSet.Items.Clear;
  cbFieldType.Items.Clear;

  SQLEngine.FillStdTypesList(cbFieldType.Items);
  //set def type to NUMERIC
  //if cbFieldType.Items.Count>0 then
  //   cbFieldType.ItemIndex:=0;

  //fill charsets
  SQLEngine.FillCharSetList(CB_CharSet.Items);
end;

procedure TfbmTableFieldEditorForm.FillTablesList;
begin
  cbFKTableName.Items.Clear;
  FTable.OwnerDB.FillListForNames(cbFKTableName.Items, [okPartitionTable, okTable]);

  if cbFKTableName.Items.Count>0 then
  begin
    cbFKTableName.ItemIndex:=0;
    cbFKTableNameChange(nil);
  end;
end;

function TfbmTableFieldEditorForm.GetDomainStr: string;
var
  P:TDBMSFieldTypeRecord;
begin
  if cbDomainCheck.Checked then
    Result:=cbDomains.Text
  else
  begin
    P:=SQLEngine.TypeList[cbFieldType.ItemIndex];
    Result:=P.GetFieldTypeStr(edtSize.Value, edtScale.Value);
  end;
end;

function TfbmTableFieldEditorForm.GetFieldName: string;
begin
  Result:=edtFieldName.Text;
end;

function TfbmTableFieldEditorForm.GetFKFieldsName: string;
var
  S: String;
begin
  Result:='';
  for S in ListBox4.Items do
  begin
    if Result<> '' then Result:=Result + ',';
    Result:=Result + S;
  end;
end;

function TfbmTableFieldEditorForm.GetFKTableName: string;
begin
  Result:=cbFKTableName.Text;
end;

function TfbmTableFieldEditorForm.GetSelectedDomain: TDBDomain;
var
  i:integer;
begin
  Result:=nil;
  if cbDomainCheck.Checked then
  begin
    i:=cbDomains.ItemIndex;
    if (i>-1) and (i<cbDomains.Items.Count) then
      Result:=cbDomains.Items.Objects[i] as TDBDomain;
  end;
  if Assigned(Result) and not Result.Loaded then
    Result.RefreshObject;
end;

procedure TfbmTableFieldEditorForm.SetFieldName(const AValue: string);
begin
  edtFieldName.Text:=AValue;
end;

procedure TfbmTableFieldEditorForm.MakeFKName;
var
  i:integer;
  S:string;
  Fnd: Boolean;
begin
  i:=0;
  repeat
    inc(i);
    S:=FormatStringCase(Format(sFKNameMask, [FTableName,i]), FTable.OwnerDB.MiscOptions.ObjectNamesCharCase);
    if Assigned(FConstList) then
      Fnd:=FConstList.IndexOf(S) >= 0
    else
      Fnd:=Assigned(FTable.ConstraintFind(S));
  until not Fnd;
  edtFKName.Text:=S;

  if utSetFKName in FTable.UITableOptions then
    cbCreateFKIndex.Checked:=ConfigValues.ByNameAsBoolean(FTable.OwnerDB.ClassName+'\CreateIndexAfterCreateFK', false);
end;

procedure TfbmTableFieldEditorForm.CreateIndexName;
var
  i:integer;
  s:string;
  Fnd: Boolean;
begin
  if FTable.State = sdboEdit then FTable.IndexListRefresh;
  i:=0;
  repeat
    Inc(i);
    S:=FormatStringCase(Format(sFKIndexNameMask,[FTableName, i]), FTable.OwnerDB.MiscOptions.ObjectNamesCharCase);

    if Assigned(FConstList) then
      Fnd:=FConstList.IndexOf(S) >= 0
    else
      Fnd:=Assigned(FTable.IndexFind(S));

  until not Fnd;
  edtIndexName.Text:=S;
end;

procedure TfbmTableFieldEditorForm.SetFKFieldsName(AValue: string);
begin
  //
end;

procedure TfbmTableFieldEditorForm.SetFKTableName(AValue: string);
begin
  cbFKTableName.Text:=AValue;
end;

function TfbmTableFieldEditorForm.DoConvertGenNames(S: string): string;
begin
  S:=StringReplace(S, '%FIELD_NAME%', edtFieldName.Text, [rfReplaceAll, rfIgnoreCase]);
  S:=StringReplace(S, '%TABLE_NAME%', edtTableName.Text, [rfReplaceAll, rfIgnoreCase]);
  if FTable.SchemaName<>'' then
    S:=StringReplace(S, '%TABLE_SCHEMA_NAME%', FTable.SchemaName, [rfReplaceAll, rfIgnoreCase]);
  Result:=S;
end;

function TfbmTableFieldEditorForm.DoConvertTriggerNames(S: string): string;
begin
  S:=StringReplace(S, '%FIELD_NAME%', edtFieldName.Text, [rfReplaceAll, rfIgnoreCase]);
  S:=StringReplace(S, '%TABLE_NAME%', edtTableName.Text, [rfReplaceAll, rfIgnoreCase]);
  S:=StringReplace(S, '%TRIGGER_NAM%', edtFieldName.Text, [rfReplaceAll, rfIgnoreCase]);
  if RadioButton3.Checked then
    S:=StringReplace(S, '%GENERATOR_NAME%', DoFormatName2(Edit3.Text), [rfReplaceAll, rfIgnoreCase])
  else
    S:=StringReplace(S, '%GENERATOR_NAME%', DoFormatName2(ComboBox3.Text), [rfReplaceAll, rfIgnoreCase]);
  if FTable.SchemaName<>'' then
    S:=StringReplace(S, '%TABLE_SCHEMA_NAME%', FTable.SchemaName, [rfReplaceAll, rfIgnoreCase]);
  Result:=S;
end;

procedure TfbmTableFieldEditorForm.DoUpdateAutoIncGenName;
begin
  if Assigned(FTable) then
    Edit3.Text:=DoConvertGenNames(ConfigValues.ByNameAsString('AutoIncriment/Generator/Name/' + FTable.OwnerDB.GetEngineName, ''));
end;

procedure TfbmTableFieldEditorForm.DoUpdateAutoIncTrigger;
begin
  if Assigned(FTable) and CheckBox1.Checked then
  begin
    EditorFrame.EditorText:=DoConvertTriggerNames(ConfigValues.ByNameAsString('AutoIncriment/Trigger/Text/' + FTable.OwnerDB.GetEngineName, ''));
    Edit2.Text:=DoConvertTriggerNames(ConfigValues.ByNameAsString('AutoIncriment/Trigger/Name/' + FTable.OwnerDB.GetEngineName, ''));
    EditorFrameDesc.EditorText:=DoConvertTriggerNames(ConfigValues.ByNameAsString('AutoIncriment/Trigger/Description/' + FTable.OwnerDB.GetEngineName, ''));
  end
  else
    EditorFrame.EditorText:='';
end;

procedure TfbmTableFieldEditorForm.DoCheckFiledNameAndTypeFK;
var
  F: TDBField;
  TT: TDBMSFieldTypeRecord;
  S: String;
begin
  if (edtFieldName.Text = '') or (cbDomainCheck.Visible and cbDomainCheck.Checked and (cbDomains.ItemIndex < 0)) or (cbCustomTypeCheck.Checked and (cbFieldType.ItemIndex<0)) then
  begin
    if (ListBox4.Items.Count = 0) and (ListBox4.ItemIndex>-1) or
      (not QuestionBox(sFillFieldNameAndType)) then exit;

    if edtFieldName.Text = '' then
      edtFieldName.Text:=ListBox4.Items[ListBox4.ItemIndex];

    F:=ListBox4.Items.Objects[ListBox4.ItemIndex] as TDBField;
    if not Assigned(F) then Exit;

    if Trim(edtDescription.Text) = '' then
      edtDescription.Text:=F.FieldDescription;

    if cbDomainCheck.Visible and Assigned(F.FieldDomain) then
    begin
      if cbDomains.ItemIndex<0 then
      begin
        cbDomainCheck.Checked:=true;
        S:=F.FieldDomain.CaptionFullPatch;
        cbDomains.Text:=F.FieldDomain.CaptionFullPatch;
      end;
      Exit;
    end
    else
    if cbFieldType.ItemIndex<0 then
    begin
      cbCustomTypeCheck.Checked:=true;
      TT:=FTable.OwnerDB.TypeList.FindType(F.FieldTypeName);
      if Assigned(TT) then
        cbFieldType.Text:=TT.TypeName;
      edtSize.Value:=F.FieldSize;
      edtScale.Value:=F.FieldPrec;
    end;
  end;
end;

procedure TfbmTableFieldEditorForm.ShowInitialValue(AShow: boolean);
begin
  Label15.Visible:=AShow;
  Edit1.Visible:=AShow;
  if AShow then
  begin
    Label10.AnchorSide[akTop].Control:=Edit1;
    cbNotNullChange(nil);
  end
  else
    Label10.AnchorSide[akTop].Control:=edtTypeDesc;
end;

procedure TfbmTableFieldEditorForm.Localize;
begin
  Caption:=sNewField;
  TabSheet1.Caption:=sFieldType;
  TabSheet3.Caption:=sCheck;
  TabSheet4.Caption:=sDefaultValue;
  tabArray.Caption:=sArray;
  TabSheet6.Caption:=sAutoincremet;
  TabComputedSource.Caption:=sCalculated;
  Label1.Caption:=sTableName;
  Label2.Caption:=sFieldName;
  Label4.Caption:=sGeneratorName;
  Label5.Caption:=sGeneratorName;
  Label6.Caption:=sSize;
  Label7.Caption:=sScale;
  Label8.Caption:=sCharSet;
  Label9.Caption:=sCollate;
  Label10.Caption:=sDescription;
  Label15.Caption:=sInitialValue;
  cbNotNull.Caption:=sNotNull;
  cbPrimaryKey.Caption:=sPrimaryKey;
  cbAutoIncField.Caption:=sAutoIncField;
  Button3.Caption:=sNewDomain;
  cbDomainCheck.Caption:=sDomain;
  cbCustomTypeCheck.Caption:=sCustomType;

  Button4.Caption:=sAdd;
  Button5.Caption:=sRemove;

  RadioGroup1.Caption:=sSortOrder;
  RadioGroup1.Items.Clear;
  RadioGroup1.Items.Add(sAscending);
  RadioGroup1.Items.Add(sDescending);

  cbForignKey.Caption:=sReferencesTo;
  TabForignKey.Caption:=sForeignKey;
  Label3.Caption:=sFKName;
  cbCreateFKIndex.Caption:=sCreateIndex;
  Label11.Caption:=sOnTable;
  Label12.Caption:=sOnUpdate;
  Label13.Caption:=sOnDelete;

  RadioButton1.Caption:=aNoAction;
  RadioButton2.Caption:=aIdentityField;
  Label16.Caption:=sStartWith;
  RadioButton3.Caption:=sCreateNewGenerator;
  RadioButton4.Caption:=sUseExistingGenerator;
  CheckBox1.Caption:=sCreateTriggerForAutoinc;
  Label17.Caption:=sTriggerName;
  TabSheet2.Caption:=sTriggerBody;
  TabSheet7.Caption:=sTriggerDescription;

  TabSheet8.Caption:=sForeignKeyRule;
  TabSheet9.Caption:=sDescription;
end;

constructor TfbmTableFieldEditorForm.CreateFieldEditor(ATable: TDBTableObject;
  ATableName: string; AConstList: TStringList);
begin
  inherited Create(Application);
  FConstList:=AConstList;
  PageControl1.ActivePageIndex:=0;
  PageControl2.ActivePageIndex:=0;
  Localize;
  FTable:=ATable;
  FTableName:=ATableName;
  SQLEngine:=ATable.OwnerDB;

  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Name:='EditorFrame';
  EditorFrame.Align:=alClient;
  EditorFrame.Parent:=TabSheet2;
  EditorFrame.ChangeVisualParams;
  EditorFrame.TextEditor.Highlighter:=SynSQLSyn1;
  EditorFrame.SQLEngine:=SQLEngine;

  EditorFrameDesc:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrameDesc.Name:='EditorFrameDesc';
  EditorFrameDesc.Align:=alClient;
  EditorFrameDesc.Parent:=TabSheet7;
  EditorFrameDesc.ChangeVisualParams;


  SetEditorOptions(edtDescription);


  if okDomain in ATable.OwnerDB.SQLEngineCapability then
  begin
    FillDomainList;
    if cbDomains.Items.Count = 0 then
      cbCustomTypeCheck.Checked:=true;
  end
  else
  begin
    cbDomainCheck.Visible:=false;
    cbDomains.Visible:=false;
    Button3.Visible:=false;

    cbCustomTypeCheck.AnchorSide[akTop].Control:=TabSheet1;
    cbCustomTypeCheck.AnchorSide[akTop].Side:=asrTop;

    cbCustomTypeCheck.Checked:=true;
  end;

  tabArray.TabVisible:=feArrayFields in ATable.OwnerDB.SQLEngileFeatures;
  TabComputedSource.TabVisible:=feComputedTableFields in ATable.OwnerDB.SQLEngileFeatures;

  cbAutoIncField.Visible:=okAutoIncFields in ATable.OwnerDB.SQLEngineCapability;
  TabSheet6.TabVisible:=(FTable.State = sdboCreate) and (okSequence in ATable.OwnerDB.SQLEngineCapability);

  FillGeneratorList;
  if Assigned(ATable) then
    edtTableName.Text:=ATable.CaptionFullPatch
  else
    edtTableName.Enabled:=true;

//  ShowInitialValue(Assigned(ATable) and (ATable.State = sdboEdit));

  FillStdTypes;
  FillTablesList;

  RadioButton2Change(nil);
  RadioButton4Change(nil);
  cbForignKeyChange(nil);

  if Assigned(ATable) and Assigned(ATable.OwnerDB) then
    TabSheet9.Visible:=(feDescribeTableConstraint in ATable.OwnerDB.SQLEngileFeatures)
  else
    TabSheet9.Visible:=false;
end;

procedure TfbmTableFieldEditorForm.FillSQLField(AItem: TSQLParserField);
var
  P: TDBMSFieldTypeRecord;
begin
  AItem.Caption:=GetFieldName;
  AItem.TableName:=edtTableName.Text;
  AItem.Description:=TrimRight(edtDescription.Text);
  AItem.DefaultValue:=TrimRight(edtDefaultValue.Text);
  AItem.TypeLen:=0;
  AItem.TypePrec:=0;
  //AItem.InReturn:=
  if cbDomainCheck.Checked then
  begin
    AItem.TypeName:=cbDomains.Text;
  end
  else
  begin
    P:=SQLEngine.TypeList[cbFieldType.ItemIndex];
    AItem.TypeName:=P.TypeName;
    if P.VarLen then
    begin
      AItem.TypeLen:=edtSize.Value;
      if P.VarDec then
        AItem.TypePrec:=edtScale.Value;
    end;

    if CB_CharSet.Enabled then
    begin
      AItem.CharSetName:=CB_CharSet.Text;
      AItem.Collate:=cbCollations.Text;
    end;
  end;

  //AItem.TypeOf:boolean;
  if cbNotNull.Checked then
    AItem.Params:=AItem.Params + [fpNotNull]
  else
    AItem.Params:=AItem.Params - [fpNotNull];

  AItem.PrimaryKey:=cbPrimaryKey.Checked;
  AItem.CheckExpr:=TrimRight(edtCheck.Text);
  if TabComputedSource.TabVisible then
  begin
    AItem.ComputedSource:=Trim(edtComputedSource.Text);
  end;

  if cbAutoIncField.Visible and cbAutoIncField.Checked then
    AItem.Params:=AItem.Params + [fpAutoInc]
  else
    AItem.Params:=AItem.Params - [fpAutoInc];
end;

function TfbmTableFieldEditorForm.ForeignKeyRuleOnUpdate: TForeignKeyRule;
begin
  case cbFKUpdateRule.ItemIndex of
    1:Result:=fkrCascade;
    2:Result:=fkrSetNull;
    3:Result:=fkrSetDefault;
  else
    Result:=fkrNone
  end;
end;

function TfbmTableFieldEditorForm.ForeignKeyRuleOnDelete: TForeignKeyRule;
begin
  case cbFKDeleteRule.ItemIndex of
    1:Result:=fkrCascade;
    2:Result:=fkrSetNull;
    3:Result:=fkrSetDefault;
  else
    Result:=fkrNone
  end;
end;

function TfbmTableFieldEditorForm.PrimaryKeyName: string;
begin
  if cbPrimaryKey.Checked then
    Result:=FormatStringCase('PK_'+FTableName, FTable.OwnerDB.MiscOptions.ObjectNamesCharCase)
  else
    Result:='';
end;

end.

