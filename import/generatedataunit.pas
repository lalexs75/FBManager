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

unit GenerateDataUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ButtonPanel, ExtCtrls,
  StdCtrls, Spin, ActnList, Menus, DBCtrls, ComCtrls, DB, rxmemds, rxdbgrid,
  rxtooledit, RxTimeEdit, SQLEngineAbstractUnit, fbmsqlscript, fbmSqlParserUnit,
  sqlObjects;

type

  { TGenerateRecord }

  TGenerateRecord = class
  private
    FGenType:Integer;
    FFieldType:TFieldType;
    FValuesList:TStringList;
    FInsParam: TSQLParserField;
    //int params
    FIntMax:Integer;
    FIntMin:Integer;
    FAutoIncCur:Integer;
    FAutoIncStep:Integer;
    //str params
    FUseGUID:Boolean;
    FStrMinLen:Integer;
    FStrMaxLen:Integer;
    //float params
    FFloatMin:Double;
    FFloatMax:Double;
    //DateTiem params;
    FDateTimeMin:TDateTime;
    FDateTimeMax:TDateTime;
    FDateTimeIncludeTime:Boolean;

    FLookUpData:TDataSet;
    FLookUpField:TField;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  { TGenerateDataForm }

  TGenerateDataForm = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    DBMemo1: TDBMemo;
    fldSelAll: TAction;
    fldUnSelAll: TAction;
    ActionList1: TActionList;
    ButtonPanel1: TButtonPanel;
    dsFields: TDataSource;
    FloatSpinEdit1: TFloatSpinEdit;
    FloatSpinEdit2: TFloatSpinEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
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
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    PopupMenu1: TPopupMenu;
    ProgressBar1: TProgressBar;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    RxDateEdit1: TRxDateEdit;
    RxDateEdit2: TRxDateEdit;
    RxDBGrid1: TRxDBGrid;
    rxFields: TRxMemoryData;
    rxFieldsCHEKED: TBooleanField;
    rxFieldsDataGenAsGUID: TBooleanField;
    rxFieldsDataGenAutoIncCurrent: TLongintField;
    rxFieldsDataGenAutoIncStart: TLongintField;
    rxFieldsDataGenAutoIncStep: TLongintField;
    rxFieldsDataGenDateIncludeTime: TBooleanField;
    rxFieldsDataGenDateMax: TDateTimeField;
    rxFieldsDataGenDateMin: TDateTimeField;
    rxFieldsDataGenExtFieldName: TStringField;
    rxFieldsDataGenExtRecordCount: TLongintField;
    rxFieldsDataGenExtTableName: TStringField;
    rxFieldsDataGenFloatMax: TFloatField;
    rxFieldsDataGenFloatMin: TFloatField;
    rxFieldsDataGenIntMax: TLongintField;
    rxFieldsDataGenIntMin: TLongintField;
    rxFieldsDataGenSimpleList: TMemoField;
    rxFieldsDataGenStrEndChar: TStringField;
    rxFieldsDataGenStrMaxLen: TLongintField;
    rxFieldsDataGenStrMinLen: TLongintField;
    rxFieldsDataGenStrStartChar: TStringField;
    rxFieldsDataGenType: TLongintField;
    rxFieldsFieldName: TStringField;
    rxFieldsFieldType: TStringField;
    rxFieldsFieldTypeInt: TLongintField;
    RxTimeEdit1: TRxTimeEdit;
    RxTimeEdit2: TRxTimeEdit;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    SpinEdit5: TSpinEdit;
    SpinEdit6: TSpinEdit;
    SpinEdit7: TSpinEdit;
    SpinEdit8: TSpinEdit;
    SpinEdit9: TSpinEdit;
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure fldSelAllExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup2Change(Sender: TObject);
    procedure rxFieldsAfterScroll(DataSet: TDataSet);
    procedure rxFieldsBeforeScroll(DataSet: TDataSet);
  private
    FGenList:TFPList;
    FTable: TDBTableObject;
    FLockCount:Integer;

    FCmdIns: TSQLCommandInsert;
    FCmdStartTran:TSQLStartTransaction;
    FCmdCommit:TSQLCommit;

    FCurRec:TGenerateRecord;
    procedure LockSave;
    procedure UnLockSave;
    procedure Localize;
    procedure LoadTableInfo;
    procedure UpdateEditControl;
    procedure SaveEditData;
    procedure UpdateRadioGroup2;
    ///
    function InitWrite:Boolean;
    procedure DoneWrite;
    procedure WriteStartTran;
    procedure WriteCommitTran;
    procedure WriteCommand(S:string);

    function DoMakeString:string;
    function DoMakeInteger:Integer;
    function DoMakeDate:TDateTime;
    function DoMakeNumeric:Double;
    function DoMakeBoolean:string;

    function MakeValue:string;
  public
    constructor CreateGenerateDataForm(ATable:TDBTableObject);
    function SaveData:boolean;
  end;


function ShowGenerateDataForm(ATable:TDBTableObject):Boolean;
implementation
uses Math, rxdbutils, IBManMainUnit, StrUtils, fbmStrConstUnit, fbmToolsNV;

function ShowGenerateDataForm(ATable: TDBTableObject): Boolean;
var
  GenerateDataForm: TGenerateDataForm;
begin
  Result:=false;
  GenerateDataForm:=TGenerateDataForm.CreateGenerateDataForm(ATable);
  if GenerateDataForm.ShowModal = mrOk then
    Result:=GenerateDataForm.RadioGroup1.ItemIndex = 1;
  GenerateDataForm.Free;
end;

{$R *.lfm}

{ TGenerateRecord }

constructor TGenerateRecord.Create;
begin
  inherited Create;
  FValuesList:=TStringList.Create;
end;

destructor TGenerateRecord.Destroy;
begin
  FreeAndNil(FValuesList);
  inherited Destroy;
end;

{ TGenerateDataForm }

procedure TGenerateDataForm.fldSelAllExecute(Sender: TObject);
begin
  FillValueForField(rxFieldsCHEKED, ((Sender as TComponent).Tag > 0));
end;

procedure TGenerateDataForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
var
  i: Integer;
begin
  for i:=0 to FGenList.Count-1 do
    TGenerateRecord(FGenList[i]).Free;
  FGenList.Free;

  if Assigned(FCmdIns) then
  begin
    FCmdIns.Free;
    FCmdStartTran.Free;
    FCmdCommit.Free;
  end;
end;

procedure TGenerateDataForm.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  if ModalResult = mrOK then
    CanClose:=SaveData;
end;

procedure TGenerateDataForm.ComboBox1Change(Sender: TObject);
var
  D: TObject;
begin
  ComboBox2.Items.Clear;
  if (ComboBox1.ItemIndex>=0) and (ComboBox1.ItemIndex<ComboBox1.Items.Count) then
  begin
    D:=ComboBox1.Items.Objects[ComboBox1.ItemIndex];
    if D is TDBDataSetObject then
    begin
      if TDBDataSetObject(D).Fields.Count = 0 then
        TDBDataSetObject(D).RefreshFieldList;
      TDBDataSetObject(D).Fields.SaveToStrings(ComboBox2.Items);
    end;
  end;
  SaveEditData;
end;

procedure TGenerateDataForm.ComboBox2Change(Sender: TObject);
begin
  SaveEditData;
end;

procedure TGenerateDataForm.CheckBox1Change(Sender: TObject);
begin
  ComboBox1Change(Sender);
  Label10.Enabled:=not CheckBox1.Checked;
  Label11.Enabled:=Label10.Enabled;
  Label12.Enabled:=Label10.Enabled;
  Label13.Enabled:=Label10.Enabled;
  SpinEdit8.Enabled:=Label10.Enabled;
  SpinEdit9.Enabled:=Label10.Enabled;
  ComboBox3.Enabled:=Label10.Enabled;
  ComboBox4.Enabled:=Label10.Enabled;
end;

procedure TGenerateDataForm.CheckBox3Change(Sender: TObject);
begin
  SpinEdit2.Enabled:=CheckBox3.Checked;
end;

procedure TGenerateDataForm.FormCreate(Sender: TObject);
begin
  FGenList:=TFPList.Create;
  CheckBox3Change(nil);
end;

procedure TGenerateDataForm.RadioGroup2Change(Sender: TObject);
begin
  SaveEditData;
  if rxFields.State <> dsBrowse then
    rxFields.Post;

  UpdateEditControl;
end;

procedure TGenerateDataForm.rxFieldsAfterScroll(DataSet: TDataSet);
begin
  UpdateRadioGroup2;
  UpdateEditControl;
end;

procedure TGenerateDataForm.rxFieldsBeforeScroll(DataSet: TDataSet);
begin
  //
end;

procedure TGenerateDataForm.LockSave;
begin
  Inc(FLockCount)
end;

procedure TGenerateDataForm.UnLockSave;
begin
  if FLockCount>0 then
    Dec(FLockCount);
end;

procedure TGenerateDataForm.Localize;
begin
  fldSelAll.Caption:=sSelectAll;
  fldUnSelAll.Caption:=sUnselectAll;

  Caption:=sTestDataGenerator;
  RadioGroup2.Items[0]:=sGenerateRandomly;
  RadioGroup2.Items[1]:=sGetFromAnotherTable;
  RadioGroup2.Items[2]:=sGetFromList;
  RadioGroup2.Items[3]:=sAutoincremet;

  RadioGroup1.Caption:=sGenerateType;
  RadioGroup1.Items[0]:=sGenerateSQLScript;
  RadioGroup1.Items[1]:=sInsertIntoTable;
  Label1.Caption:=sRecordsToGenerated;
  CheckBox3.Caption:=sCommitAfter;
  RxDBGrid1.ColumnByFieldName('FieldName').Title.Caption:=sFieldName;
  RxDBGrid1.ColumnByFieldName('FieldType').Title.Caption:=sFieldType;
  RadioGroup2.Caption:=sDataGeneratorType;
  GroupBox3.Caption:=sGetFromList;

  GroupBox2.Caption:=sGetFromTable;
  Label5.Caption:=sTableName;
  Label6.Caption:=sFieldName;
  Label7.Caption:=sNumberOfRecords;

  GroupBox4.Caption:=sAutoincremet;
  Label8.Caption:=sInitialValue;
  Label9.Caption:=sStep;
  GroupBox7.Caption:=stime;
  Label16.Caption:=sMinTime;
  Label17.Caption:=sMaxTime;

  GroupBox5.Caption:=sStringConstraints;
  CheckBox1.Caption:=sGenerateGUID;
  Label10.Caption:=sMinLength;
  Label11.Caption:=sMaxLength;

  GroupBox8.Caption:=sNumericConstraints;
  Label18.Caption:=sMinValue;
  Label19.Caption:=sMaxValue;

  GroupBox1.Caption:=sIntegerConstarints;
  Label3.Caption:=sMinValue;
  Label4.Caption:=sMaxValue;

  GroupBox6.Caption:=sDateConstraint;
  Label14.Caption:=sMinDate;
  Label15.Caption:=sMaxDate;
  CheckBox2.Caption:=sIncludeTime;
end;

procedure TGenerateDataForm.LoadTableInfo;
var
  F: TDBField;
begin
  LockSave;
  rxFields.BeforeScroll:=nil;
  rxFields.AfterScroll:=nil;

  rxFields.DisableControls;
  rxFields.CloseOpen;
  if not Assigned(FTable) then Exit;
  for F in FTable.Fields do
  begin
    rxFields.Append;
    rxFieldsCHEKED.AsBoolean:=false;
    rxFieldsFieldName.AsString:=F.FieldName;
    rxFieldsFieldType.AsString:=F.TypeStr;
    rxFieldsFieldTypeInt.AsInteger:=Ord(F.FieldTypeDB);
    rxFieldsDataGenType.AsInteger:=0;

    rxFieldsDataGenIntMin.AsInteger:=-MaxInt-1;
    rxFieldsDataGenIntMax.AsInteger:=MaxInt;
//                                      -2147483648
    rxFieldsDataGenFloatMin.AsFloat:=-MaxDouble-1;
    rxFieldsDataGenFloatMax.AsFloat:=MaxDouble;

    rxFieldsDataGenDateMin.AsDateTime:=IncMonth(Date, -1);
    rxFieldsDataGenDateMax.AsDateTime:=IncMonth(Date, 1) + 1 - 1 / SecsPerDay;
    rxFieldsDataGenDateIncludeTime.AsBoolean:=F.FieldTypeDB in [ftDateTime, ftTimeStamp];

    rxFieldsDataGenAutoIncStart.AsInteger:=0;
    rxFieldsDataGenAutoIncStep.AsInteger:=1;

    if F.FieldTypeDB = ftString then
    begin
      rxFieldsDataGenStrMinLen.AsInteger:=1;
      if Assigned(F.FieldDomain) then
        rxFieldsDataGenStrMaxLen.AsInteger:=F.FieldDomain.FieldLength
      else
       rxFieldsDataGenStrMaxLen.AsInteger:=F.FieldSize;
    end;

    rxFieldsDataGenExtRecordCount.AsInteger:=1000;

    rxFields.Post;
  end;

  rxFields.First;
  rxFields.EnableControls;

  rxFields.BeforeScroll:=@rxFieldsBeforeScroll;
  rxFields.AfterScroll:=@rxFieldsAfterScroll;

  if Assigned(FTable) then
    FTable.OwnerDB.FillListForNames(ComboBox1.Items, [okTable, okForeignTable, okView, okMaterializedView]);

  UpdateEditControl;
  UnLockSave;
end;

procedure TGenerateDataForm.UpdateEditControl;

procedure DoUpdate(P, SP:TGroupBox);
begin
  P.Visible:=P = SP;
  if P.Visible then
  begin
    P.AnchorSideTop.Control:=RadioGroup2;
    P.AnchorSideLeft.Control:=RadioGroup2;
    P.AnchorSideRight.Control:=RadioGroup2;
  end;
end;

var
  G: TGroupBox;
  FT: TFieldType;
begin
  LockSave;
  RadioGroup2.ItemIndex:=rxFieldsDataGenType.AsInteger;
  FT:=TFieldType(rxFieldsFieldTypeInt.AsInteger);
  case rxFieldsDataGenType.AsInteger of
    0:if TFieldType(rxFieldsFieldTypeInt.AsInteger) in StringTypes then
        G:=GroupBox5
      else
      if TFieldType(rxFieldsFieldTypeInt.AsInteger) in [ftDateTime, ftTimeStamp, ftDate] then
        G:=GroupBox6
      else
      if TFieldType(rxFieldsFieldTypeInt.AsInteger) = ftTime then
        G:=GroupBox7
      else
      if TFieldType(rxFieldsFieldTypeInt.AsInteger) in IntegerDataTypes then
        G:=GroupBox1
      else
      if TFieldType(rxFieldsFieldTypeInt.AsInteger) in NumericDataTypes - IntegerDataTypes then
        G:=GroupBox8
      else
      //if TFieldType(rxFieldsFieldTypeInt.AsInteger) = ftBoolean then
        G:=nil;

    1:G:=GroupBox2;
    2:G:=GroupBox3;
    3:G:=GroupBox4;
  else
    G:=nil;
  end;
  DoUpdate(GroupBox1, G);
  DoUpdate(GroupBox2, G);
  DoUpdate(GroupBox3, G);
  DoUpdate(GroupBox4, G);
  DoUpdate(GroupBox5, G);
  DoUpdate(GroupBox6, G);
  DoUpdate(GroupBox7, G);
  DoUpdate(GroupBox8, G);

  if GroupBox1.Visible then
  begin
    SpinEdit3.Value:=rxFieldsDataGenIntMin.AsInteger;
    SpinEdit4.Value:=rxFieldsDataGenIntMax.AsInteger;
  end
  else
  if GroupBox2.Visible then
  begin
    ComboBox1.Text:=rxFieldsDataGenExtTableName.AsString;
    ComboBox2.Text:=rxFieldsDataGenExtFieldName.AsString;
    SpinEdit5.Value:=rxFieldsDataGenExtRecordCount.AsInteger;
  end
  else
{  if GroupBox3.Visible then
  begin
  end
  else}
  if GroupBox4.Visible then
  begin
    SpinEdit6.Value:=rxFieldsDataGenAutoIncStart.AsInteger;
    SpinEdit7.Value:=rxFieldsDataGenAutoIncStep.AsInteger;
  end
  else
  if GroupBox5.Visible then
  begin
    CheckBox1.Checked:=rxFieldsDataGenAsGUID.AsBoolean;
    SpinEdit8.Value:=rxFieldsDataGenStrMinLen.AsInteger;
    SpinEdit9.Value:=rxFieldsDataGenStrMaxLen.AsInteger;
  end
  else
  if GroupBox6.Visible then
  begin
    RxDateEdit1.Date:=rxFieldsDataGenDateMin.AsDateTime;
    RxDateEdit2.Date:=rxFieldsDataGenDateMax.AsDateTime;
    CheckBox2.Enabled:=TFieldType(rxFieldsFieldTypeInt.AsInteger) in [ftDateTime, ftTimeStamp];
    CheckBox2.Checked:=rxFieldsDataGenDateIncludeTime.AsBoolean;
  end
  else
  if GroupBox7.Visible then
  begin
    RxTimeEdit1.Time:=rxFieldsDataGenDateMin.AsDateTime;
    RxTimeEdit2.Time:=rxFieldsDataGenDateMax.AsDateTime;
  end
  else
  if GroupBox8.Visible then
  begin
    FloatSpinEdit1.Value:=rxFieldsDataGenFloatMin.AsFloat;
    FloatSpinEdit2.Value:=rxFieldsDataGenFloatMax.AsFloat;
  end;
  UnLockSave;
end;

procedure TGenerateDataForm.SaveEditData;
begin
  if FLockCount<>0 then Exit;

  if rxFields.State <> dsEdit then
    rxFields.Edit;

  rxFieldsDataGenType.AsInteger:=RadioGroup2.ItemIndex;

  if GroupBox1.Visible then
  begin
    rxFieldsDataGenIntMin.AsInteger := SpinEdit3.Value;
    rxFieldsDataGenIntMax.AsInteger := SpinEdit4.Value;
  end
  else
  if GroupBox2.Visible then
  begin
    rxFieldsDataGenExtTableName.AsString    := ComboBox1.Text;
    rxFieldsDataGenExtFieldName.AsString    := ComboBox2.Text;
    rxFieldsDataGenExtRecordCount.AsInteger := SpinEdit5.Value;
  end
  else
{  if GroupBox3.Visible then
  begin
  end
  else}
  if GroupBox4.Visible then
  begin
    rxFieldsDataGenAutoIncStart.AsInteger := SpinEdit6.Value;
    rxFieldsDataGenAutoIncStep.AsInteger  := SpinEdit7.Value;
  end
  else
  if GroupBox5.Visible then
  begin
    rxFieldsDataGenAsGUID.AsBoolean := CheckBox1.Checked;
    rxFieldsDataGenStrMinLen.AsInteger:=SpinEdit8.Value;
    rxFieldsDataGenStrMaxLen.AsInteger:=SpinEdit9.Value;
  end
  else
  if GroupBox6.Visible then
  begin
    rxFieldsDataGenDateMin.AsDateTime        := RxDateEdit1.Date;
    rxFieldsDataGenDateMax.AsDateTime        := RxDateEdit2.Date;
    rxFieldsDataGenDateIncludeTime.AsBoolean := CheckBox2.Checked;
  end
  else
  if GroupBox7.Visible then
  begin
    rxFieldsDataGenDateMin.AsDateTime        := RxTimeEdit1.Time;
    rxFieldsDataGenDateMax.AsDateTime        := RxTimeEdit2.Time;
  end
  else
  if GroupBox8.Visible then
  begin
    rxFieldsDataGenFloatMin.AsFloat        := FloatSpinEdit1.Value;
    rxFieldsDataGenFloatMax.AsFloat        := FloatSpinEdit2.Value;
  end;
end;

procedure TGenerateDataForm.UpdateRadioGroup2;
begin
  RadioGroup2.Items.BeginUpdate;
  RadioGroup2.Items.Clear;
  if TFieldType(rxFieldsFieldTypeInt.AsInteger) in IntegerDataTypes then
  begin
    RadioGroup2.Items.Add(sGenerateRandomly);
    RadioGroup2.Items.Add(sGetFromAnotherTable);
    RadioGroup2.Items.Add(sGetFromList);
    RadioGroup2.Items.Add(sAutoincremet);
  end
  else
  begin
    RadioGroup2.Items.Add(sGenerateRandomly);
    RadioGroup2.Items.Add(sGetFromAnotherTable);
    RadioGroup2.Items.Add(sGetFromList);
  end;
  RadioGroup2.Items.EndUpdate;
end;

function TGenerateDataForm.InitWrite: Boolean;
var
  P: TGenerateRecord;
  T: TDBDataSetObject;
  S: String;
begin
  if rxFields.State <> dsBrowse then rxFields.Post;

  rxFields.DisableControls;
  rxFields.AfterScroll:=nil;
  rxFields.BeforeScroll:=nil;
  rxFields.First;

  while not rxFields.EOF do
  begin
    if rxFieldsCHEKED.AsBoolean then
    begin
      FCmdIns.Fields.AddParam(rxFieldsFieldName.AsString);

      P:=TGenerateRecord.Create;
      P.FGenType:=rxFieldsDataGenType.AsInteger;
      P.FFieldType:=TFieldType(rxFieldsFieldTypeInt.AsInteger);
      S:=rxFieldsDataGenSimpleList.AsString;
      P.FValuesList.Text:=S;
      //int params
      P.FIntMax:=rxFieldsDataGenIntMax.AsInteger;
      P.FIntMin:=rxFieldsDataGenIntMin.AsInteger;
      P.FAutoIncCur:=rxFieldsDataGenAutoIncStart.AsInteger;
      P.FAutoIncStep:=rxFieldsDataGenAutoIncStep.AsInteger;

      //Str params
      P.FUseGUID:=rxFieldsDataGenAsGUID.AsBoolean;
      P.FStrMaxLen:=rxFieldsDataGenStrMaxLen.AsInteger;
      P.FStrMinLen:=rxFieldsDataGenStrMinLen.AsInteger;

      //float params
      P.FFloatMin:=rxFieldsDataGenFloatMin.AsFloat;
      P.FFloatMax:=rxFieldsDataGenFloatMax.AsFloat;

      //DateTime params
      P.FDateTimeMin:=rxFieldsDataGenDateMin.AsDateTime;
      P.FDateTimeMax:=rxFieldsDataGenDateMax.AsDateTime;
      P.FDateTimeIncludeTime:=rxFieldsDataGenDateIncludeTime.AsBoolean;

      P.FInsParam:=FCmdIns.Params.AddParam('');

      if P.FGenType = 1 then
      begin
        T:=FTable.OwnerDB.DBObjectByName(rxFieldsDataGenExtTableName.AsString, false) as TDBDataSetObject;
        P.FLookUpData:=T.DataSet(rxFieldsDataGenExtRecordCount.AsInteger);
        P.FLookUpData.Active:=true;
        P.FLookUpField:=P.FLookUpData.FieldByName(rxFieldsDataGenExtFieldName.AsString);
      end;
      FGenList.Add(P);
    end;
    rxFields.Next;
  end;
  Result:=FGenList.Count > 0;
  if not Result then Exit;

  FCmdIns.TableName:=FTable.Caption;
  FCmdIns.SchemaName:=FTable.SchemaName;

  if RadioGroup1.ItemIndex = 0 then
    fbManagerMainForm.tlsSqlScript.Execute
  else
  begin

  end;
end;

procedure TGenerateDataForm.DoneWrite;
begin
  rxFields.AfterScroll:=@rxFieldsAfterScroll;
  rxFields.BeforeScroll:=@rxFieldsBeforeScroll;
  rxFields.EnableControls;
end;

procedure TGenerateDataForm.WriteStartTran;
begin
  WriteCommand(FCmdStartTran.AsSQL);
end;

procedure TGenerateDataForm.WriteCommitTran;
begin
  WriteCommand(FCmdCommit.AsSQL);
end;

procedure TGenerateDataForm.WriteCommand(S: string);
begin
  if RadioGroup1.ItemIndex = 0 then
    FBMSqlScripForm.AddLineText(S)
  else
    FTable.OwnerDB.ExecSQL(S, []);
end;

function TGenerateDataForm.DoMakeString: string;
var
  G: TGUID;
  FL, i: Integer;
  P: LongInt;
begin
  Result:='';
  case FCurRec.FGenType of
    1:begin
       //Get from table
        P:=Random(FCurRec.FLookUpData.RecordCount);
        FCurRec.FLookUpData.RecNo:=P+1;
        Result:=FCurRec.FLookUpField.AsString;
      end;
    2:begin
        //Get from list
        if FCurRec.FValuesList.Count > 0 then
          Result:=FCurRec.FValuesList[Random(FCurRec.FValuesList.Count)]
        else
          Result:='';
      end
  else
    //0 - random
    if FCurRec.FUseGUID then
    begin
      CreateGUID(G);
      Result:=GUIDToString(G);
    end
    else
    begin
      FL:=RandomRange(FCurRec.FStrMinLen, FCurRec.FStrMaxLen);
      Result:='';
      for i:=1 to Fl do
        Result:=Result + Chr(RandomRange(32, 127));
    end;
  end;
end;

function TGenerateDataForm.DoMakeInteger: Integer;
var
  P: LongInt;
  A1, A2:Int64;
begin
  case FCurRec.FGenType of
    1:begin
        //Get from table
        P:=Random(FCurRec.FLookUpData.RecordCount);
        FCurRec.FLookUpData.RecNo:=P+1;
        Result:=FCurRec.FLookUpField.AsInteger;
      end;
    2:begin
        if FCurRec.FValuesList.Count > 0 then
          Result:=StrToIntDef(FCurRec.FValuesList[Random(FCurRec.FValuesList.Count)], 0)
        else
          Result:=0;
      end;
    3:begin
        //AutoInc
        FCurRec.FAutoIncCur:=FCurRec.FAutoIncCur + FCurRec.FAutoIncStep;
        Result:=FCurRec.FAutoIncCur;
      end;
  else
    //0 - random
    A1:=FCurRec.FIntMin;
    A2:=FCurRec.FIntMax;
    Result:=RandomRange(A1, A2);
  end
end;

function TGenerateDataForm.DoMakeDate: TDateTime;
var
  P: LongInt;
begin
  case FCurRec.FGenType of
    1:begin
        //Get from table
        P:=Random(FCurRec.FLookUpData.RecordCount);
        FCurRec.FLookUpData.RecNo:=P+1;
        Result:=FCurRec.FLookUpField.AsDateTime;
      end;
    2:begin
        Result:=0;
        if FCurRec.FValuesList.Count > 0 then
        begin
          if FCurRec.FFieldType = ftTime then
            Result:=StrToTimeDef(FCurRec.FValuesList[Random(FCurRec.FValuesList.Count)], Now)
          else
            Result:=StrToDateDef(FCurRec.FValuesList[Random(FCurRec.FValuesList.Count)], Now);
        end;
      end;
  else
    //0 - random
    Result:=FCurRec.FDateTimeMin + (FCurRec.FDateTimeMax - FCurRec.FDateTimeMin) * Random;
    if (FCurRec.FFieldType = ftDate) or ((FCurRec.FFieldType in [ftDateTime, ftTimeStamp]) and not FCurRec.FDateTimeIncludeTime) then
      Result:=Round(Result);
  end;
end;

function TGenerateDataForm.DoMakeNumeric: Double;
var
  P: LongInt;
begin
  case FCurRec.FGenType of
    1:begin
        //Get from table
        P:=Random(FCurRec.FLookUpData.RecordCount);
        FCurRec.FLookUpData.RecNo:=P+1;
        Result:=FCurRec.FLookUpField.AsFloat;
      end;
    2:begin
        Result:=0;
        if FCurRec.FValuesList.Count > 0 then
          Result:=StrToFloatExDef(FCurRec.FValuesList[Random(FCurRec.FValuesList.Count)], 0);
      end;
(*    3:begin
        //AutoInc
        FCurRec.FAutoIncCur:=FCurRec.FAutoIncCur + FCurRec.FAutoIncStep;
        Result:=FCurRec.FAutoIncCur;
      end; *)
  else
    //0 - random
    Result:=FCurRec.FFloatMin + (FCurRec.FFloatMax - FCurRec.FFloatMin) * Random;
  end
end;

function TGenerateDataForm.DoMakeBoolean: string;
var
  P: LongInt;
begin
  case FCurRec.FGenType of
    1:begin
        //Get from table
        P:=Random(FCurRec.FLookUpData.RecordCount);
        FCurRec.FLookUpData.RecNo:=P+1;
        Result:=FCurRec.FLookUpField.AsString;
      end;
    2:begin
        if FCurRec.FValuesList.Count > 0 then
          Result:=FCurRec.FValuesList[Random(FCurRec.FValuesList.Count)]
        else
          Result:='null';
      end;
  else
    //0 - random
    if Random(2) = 0 then
      Result:='false'
    else
      Result:='true'
  end;
end;

function TGenerateDataForm.MakeValue: string;
begin
  Result:='';
  if FCurRec.FFieldType in IntegerDataTypes then
    Result:=IntToStr(DoMakeInteger)
  else
  if FCurRec.FFieldType in NumericDataTypes then
    Result:=FloatToStrEx(DoMakeNumeric)
  else
  if FCurRec.FFieldType = ftDate then
    Result:=DateToStr(DoMakeDate)
  else
  if FCurRec.FFieldType = ftTime then
    Result:=TimeToStr(DoMakeDate)
  else
  if FCurRec.FFieldType in [ftDateTime, ftTimeStamp] then
    Result:=DateTimeToStr( DoMakeDate)
  else
  if FCurRec.FFieldType = ftBoolean then
    Result:=DoMakeBoolean
  else
    Result:=DoMakeString; //StringTypes

  if FCurRec.FFieldType in StringTypes + DataTimeTypes then
    Result:=QuotedStr(Result);
end;

constructor TGenerateDataForm.CreateGenerateDataForm(ATable: TDBTableObject);
begin
  inherited Create(Application);
  FLockCount:=0;
  Localize;
  FTable:=ATable;

  FCmdIns:=FindSQLStatment(FTable.OwnerDB.ClassType, TSQLCommandInsert).Create(nil) as TSQLCommandInsert;
  FCmdStartTran:=FindSQLStatment(FTable.OwnerDB.ClassType, TSQLStartTransaction).Create(nil) as TSQLStartTransaction;
  FCmdCommit:=FindSQLStatment(FTable.OwnerDB.ClassType, TSQLCommit).Create(nil) as TSQLCommit;

  LoadTableInfo;
end;

function TGenerateDataForm.SaveData: boolean;
var
  i, J: Integer;
begin
  Result:=InitWrite;
  if not Result then Exit;

  ProgressBar1.Position:=0;
  ProgressBar1.Max:=SpinEdit1.Value;

  if CheckBox3.Checked then
    WriteStartTran;


  for i:=1 to SpinEdit1.Value do
  begin
    for j:=0 to FGenList.Count-1 do
    begin
      FCurRec:=TGenerateRecord(FGenList[j]);
      FCurRec.FInsParam.Caption:=MakeValue;
    end;
    WriteCommand(FCmdIns.AsSQL);
    FCmdIns.SQLText.Clear;

    if CheckBox3.Checked and (SpinEdit2.Value>0) and (i mod SpinEdit2.Value = 0) and (i<SpinEdit1.Value) then
    begin
      WriteCommitTran;
      WriteStartTran;
    end;

    ProgressBar1.Position:=i;
  end;

  if CheckBox3.Checked then
    WriteCommitTran;

  DoneWrite;
  Result:=true;
end;

end.

