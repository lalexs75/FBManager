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

unit ImportDataUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, rxdbgrid, rxmemds, RxIniPropStorage,
  fpspreadsheetgrid, fpspreadsheetctrls, Forms, Grids, Controls, Graphics,
  Dialogs, StdCtrls, EditBtn, ButtonPanel, Spin, ExtCtrls, ActnList, Buttons,
  ComCtrls, Menus, StdActns, db, SQLEngineAbstractUnit, fpspreadsheet, fpsTypes,
  fpsutils;

type

  { TImportDataForm }

  TImportDataForm = class(TForm)
    actOpen: TAction;
    ActionList1: TActionList;
    BitBtn1: TBitBtn;
    ButtonPanel1: TButtonPanel;
    CheckBox1: TCheckBox;
    dsFieldList: TDataSource;
    FileNameEdit1: TFileNameEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    PageControl1: TPageControl;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    RadioGroup1: TRadioGroup;
    RxDBGrid1: TRxDBGrid;
    rxFieldList: TRxMemoryData;
    rxFieldListColName: TStringField;
    rxFieldListDataType: TLongintField;
    rxFieldListDefValue: TStringField;
    rxFieldListFieldName: TStringField;
    rxFieldListFieldSize: TLongintField;
    rxFieldListNotNull: TBooleanField;
    rxFieldListSkipEmpty: TBooleanField;
    RxIniPropStorage1: TRxIniPropStorage;
    sCellEdit1: TsCellEdit;
    sCellIndicator1: TsCellIndicator;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    sWorkbookSource1: TsWorkbookSource;
    sWorkbookTabControl1: TsWorkbookTabControl;
    sWorksheetGrid1: TsWorksheetGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure actOpenExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure rxFieldListAfterOpen(DataSet: TDataSet);
    procedure rxFieldListAfterScroll(DataSet: TDataSet);
    procedure rxFieldListColNameChange(Sender: TField);
    procedure rxFieldListDataTypeChange(Sender: TField);
    procedure SpinEdit1Change(Sender: TObject);
    procedure sWorksheetGrid1Selection(Sender: TObject; aCol, aRow: Integer);
    procedure sWorksheetGrid1PrepareCanvas(sender: TObject; aCol,
      aRow: Integer; aState: TGridDrawState);
  private
    FTable: TDBTableObject;
    FRxColName: TRxColumn;
    FRxDefValue: TRxColumn;
    FRxDataType: TRxColumn;
    procedure LoadFile(const AFileName: String);
    procedure CreateWorkSheet;
    procedure EnableControlData(AEnable:boolean);
    procedure UpdateColumnsParams;
    procedure FillDataColumns;
    //save result
    function SaveToScript:boolean;
    function SaveToTable:boolean;
    procedure Localize;
    procedure PMFieldClick(Sender: TObject);
    function ValidateDate:boolean;
  public
    constructor CreateImportForm(ATable:TDBTableObject);
    function SaveData:boolean;
  end;

var
  ImportDataForm: TImportDataForm;

implementation
uses LazUTF8, rxAppUtils, fbmStrConstUnit, fbmToolsUnit, rxdbutils, IBManMainUnit, fbmsqlscript;

{$R *.lfm}

{ TImportDataForm }

procedure TImportDataForm.actOpenExecute(Sender: TObject);
begin
  LoadFile(FileNameEdit1.FileName);
  EnableControlData(true);
end;

procedure TImportDataForm.FormCloseQuery(Sender: TObject; var CanClose: boolean
  );
begin
  if ModalResult = mrOK then
  begin
    CanClose:=ValidateDate;
    if CanClose then
      CanClose:=SaveData;
  end;
end;

procedure TImportDataForm.rxFieldListAfterOpen(DataSet: TDataSet);
begin
  FRxColName:=RxDBGrid1.ColumnByFieldName('ColName');
  FRxDefValue:=RxDBGrid1.ColumnByFieldName('DefValue');
  FRxDataType:=RxDBGrid1.ColumnByFieldName('DataType');
end;

procedure TImportDataForm.rxFieldListAfterScroll(DataSet: TDataSet);
begin
  if Assigned(sWorksheetGrid1) then
    sWorksheetGrid1.Invalidate;

  FRxDefValue.ReadOnly:=rxFieldListDataType.AsInteger<>7;
end;

procedure TImportDataForm.rxFieldListColNameChange(Sender: TField);
begin
  sWorksheetGrid1.Invalidate;
end;

procedure TImportDataForm.rxFieldListDataTypeChange(Sender: TField);
begin
  FRxDefValue.ReadOnly:=rxFieldListDataType.AsInteger<>7;
end;

procedure TImportDataForm.SpinEdit1Change(Sender: TObject);
begin
  sWorksheetGrid1.Invalidate;
end;

procedure TImportDataForm.LoadFile(const AFileName: String);
begin
  // Load file
  Screen.Cursor := crHourglass;
  try
    sWorksheetGrid1.LoadFromSpreadsheetFile(UTF8ToSys(AFileName));
  except
  end;
  Screen.Cursor := crDefault;
  Caption := Format(sImportFromFile, [ AFilename ]);
  UpdateColumnsParams;
  SpinEdit1Change(nil);
end;

procedure TImportDataForm.CreateWorkSheet;
begin
{  sWorksheetGrid1:=TsWorksheetGrid.Create(Self);
  sWorksheetGrid1.Parent:=sWorkbookTabControl1;
  sWorksheetGrid1.Align:=alClient;
  sWorksheetGrid1.Options:=sWorksheetGrid1.Options + [goColSizing];
  sWorksheetGrid1.PopupMenu:=PopupMenu1;
  sWorksheetGrid1.OnPrepareCanvas:=@sWorksheetGrid1PrepareCanvas;
  sWorksheetGrid1.OnSelection:=@sWorksheetGrid1Selection;
  sWorksheetGrid1.NewWorkbook(5, 5);}

  sCellEdit1.AutoSize:=true;
  sCellIndicator1.AutoSize:=true;

end;

procedure TImportDataForm.EnableControlData(AEnable: boolean);
begin
{  if not AEnable then
    PageControl1.ActivePageIndex:=0;
//  TabSheet2.TabVisible:=AEnable;
//  actNext.Enabled:=AEnable;
}
end;

procedure TImportDataForm.sWorksheetGrid1PrepareCanvas(sender: TObject; aCol,
  aRow: Integer; aState: TGridDrawState);
var
  FCol: Cardinal;
begin
  if (aRow > 0) and (aCol > 0) then
  begin
    if ((aRow-1) < SpinEdit1.Value) then
      sWorksheetGrid1.Canvas.Brush.Color:=clSilver
    else
    if ((aRow) > (sWorksheetGrid1.RowCount - SpinEdit2.Value - 1)) then
      sWorksheetGrid1.Canvas.Brush.Color:=clSilver
    else
    if (PageControl1.ActivePage = TabSheet2) and ParseCellColString(rxFieldListColName.AsString, FCol) then
    begin
      if FCol = aCol - 1 then
        sWorksheetGrid1.Canvas.Brush.Color:=clSkyBlue;
    end;
  end;
end;

procedure TImportDataForm.sWorksheetGrid1Selection(Sender: TObject; aCol,
  aRow: Integer);
var
  r, c: Cardinal;
  cell: PCell;
  s: String;
begin
{  if sWorksheetGrid1.Workbook = nil then
    exit;

  r := sWorksheetGrid1.GetWorksheetRow(ARow);
  c := sWorksheetGrid1.GetWorksheetCol(ACol);

  cell := sWorksheetGrid1.Worksheet.FindCell(r, c);
  if cell <> nil then
  begin
    s := sWorksheetGrid1.Worksheet.ReadFormulaAsString(cell, true);
    if s <> '' then
    begin
      if s[1] <> '=' then s := '=' + s;
      EdFormula.Text := s;
    end
    else
      case cell^.ContentType of
        cctNumber:
          EdFormula.Text := FloatToStr(cell^.NumberValue);
        cctDateTime:
          if cell^.DateTimeValue < 1.0 then
            EdFormula.Text := FormatDateTime('tt', cell^.DateTimeValue)
          else
            EdFormula.Text := FormatDateTime('c', cell^.DateTimeValue);
        cctUTF8String:
          EdFormula.Text := cell^.UTF8StringValue;
        else
          EdFormula.Text := sWorksheetGrid1.Worksheet.ReadAsUTF8Text(cell);
      end;
  end
  else
    EdFormula.Text := '';

  EdCellAddress.Text := GetCellString(r, c, [rfRelRow, rfRelCol]);   }
end;

procedure TImportDataForm.UpdateColumnsParams;
var
  i: Integer;
begin
  FRxColName.PickList.Clear;

  for i:=0 to sWorksheetGrid1.ColCount - 2 do
  begin
    FRxColName.PickList.Add(GetColString(i));
    if sWorksheetGrid1.ColWidths[i+1]<10 then
      sWorksheetGrid1.ColWidths[i+1]:=40;
  end;

  SpinEdit1.MaxValue:=sWorksheetGrid1.RowCount;
  SpinEdit2.MaxValue:=sWorksheetGrid1.RowCount;
end;

procedure TImportDataForm.FillDataColumns;
var
  F: TDBField;
  M: TMenuItem;
  i: Integer;
begin
  for i:=0 to FTable.Fields.Count-1 do
  begin
    F:=FTable.Fields[i];
    rxFieldList.Append;
    rxFieldListFieldName.AsString:=F.FieldName;
    rxFieldListDataType.AsInteger:=0;
    rxFieldListFieldSize.AsInteger:=F.FieldSize;
    rxFieldListSkipEmpty.AsBoolean:=false;

    if Assigned(F.FieldDomain) then
      rxFieldListNotNull.AsBoolean:=F.FieldDomain.NotNull
    else
      rxFieldListNotNull.AsBoolean:=F.FieldNotNull;

    rxFieldList.Post;

    M:=TMenuItem.Create(PopupMenu1);
    PopupMenu1.Items.Add(M);
    M.Caption:=sField + ' : ' + F.FieldName;
    M.Tag:=I;
    M.OnClick:=@PMFieldClick;
  end;
  rxFieldList.First;
end;

function TImportDataForm.SaveToScript: boolean;
var
  FSql:TStringList;

procedure DoCreateSQL;
var
  S, FieldNames, SIns, S1: String;
  I, FSize: Integer;
  FCol: Cardinal;
  Cell: PCell;
  F: TDBField;
  FSkip:boolean;
  L: Longint;
  RR: Extended;
begin
  rxFieldList.DisableControls;
  FieldNames:='';
  rxFieldList.First;
  while not rxFieldList.EOF do
  begin
    if (rxFieldListColName.AsString <> '') or (rxFieldListDataType.AsInteger = 7) then
    begin
      if FieldNames<>'' then FieldNames:=FieldNames + ', ';
      FieldNames:=FieldNames + rxFieldListFieldName.AsString;
    end;
    rxFieldList.Next;
  end;
  if FieldNames = '' then exit;

  SIns:='insert into ' + FTable.CaptionFullPatch + LineEnding + '  (' + FieldNames + ')'+LineEnding + 'values' + LineEnding +'  ';
  for I:=SpinEdit1.Value to sWorksheetGrid1.RowCount - SpinEdit2.Value - 2 do
  begin
    FSkip:=false;
    S:='';
    rxFieldList.First;
    while not rxFieldList.EOF do
    begin
      S1:='';
      if (rxFieldListDataType.AsInteger = 7) then
      begin
        //Manual value
        if S <> '' then S:=S+', ';
        F:=FTable.Fields.FieldByName(rxFieldListFieldName.AsString);
        if F.FieldTypeDB in StringTypes + DataTimeTypes then
          S:=S + AnsiQuotedStr(UTF8Copy(rxFieldListDefValue.AsString, 1, F.FieldSize), '''')
        else
          S:=S + rxFieldListDefValue.AsString;
      end
      else
      if (rxFieldListColName.AsString <> '') then
      begin
        //Value from spreadsheet
        if S <> '' then S:=S+', ';
        if ParseCellColString(rxFieldListColName.AsString, FCol) then
        begin
          Cell := sWorksheetGrid1.Worksheet.FindCell(I, FCol);
          if Assigned(Cell) then
          begin
            case cell^.ContentType of
              cctNumber:
                //S1:=FloatToStr(cell^.NumberValue);
                S1:=FloatToStrEx(cell^.NumberValue);
              cctDateTime:
                if cell^.DateTimeValue < 1.0 then
                  S1:=FormatDateTime('tt', Cell^.DateTimeValue)
                else
                  S1:=FormatDateTime('c', Cell^.DateTimeValue);
              cctUTF8String:
                S1 := Cell^.UTF8StringValue;
              cctEmpty:begin
                S1:='';
                if rxFieldListSkipEmpty.AsBoolean then
                  FSkip:=true;
              end
            else
                S1 := sWorksheetGrid1.Worksheet.ReadAsUTF8Text(Cell);
            end;
          end;
        end;
        F:=FTable.Fields.FieldByName(rxFieldListFieldName.AsString);
        if F.FieldTypeDB in StringTypes + DataTimeTypes then
        begin
          if S1<>'' then
          begin
            if Assigned(F.FieldDomain) then
              FSize:=F.FieldDomain.FieldLength
            else
              FSize:=F.FieldSize;

            if F.FieldTypeDB in StringTypes then
              S:=S + AnsiQuotedStr(TrimRight(UTF8Copy(S1, 1, FSize)), '''')
            else
              S:=S + AnsiQuotedStr(S1, '''');
          end
          else
            S:=S + 'null';
        end
        else
        if F.FieldTypeDB in IntegerDataTypes then
        begin
          if not ValidInteger(S1) then
          begin
            if rxFieldListDefValue.AsString<>'' then
              S:=S + rxFieldListDefValue.AsString
            else
              S:=S + 'null'
          end
          else
            S:=S + S1;
        end
        else
        if F.FieldTypeDB in NumericDataTypes then
        begin
          if not ValidFloat(S1) then
          begin
            if rxFieldListDefValue.AsString<>'' then
              S:=S + rxFieldListDefValue.AsString
            else
              S:=S + 'null'
          end
          else
            S:=S + S1;
        end
        else
          S:=S + S1;
      end;
      rxFieldList.Next;
    end;
    if not FSkip then
      FSql.Add(SIns + '(' + S + ');' + LineEnding);
  end;
  rxFieldList.First;
  rxFieldList.EnableControls;
end;

begin
  FSql:=TStringList.Create;
  DoCreateSQL;
  Result:=FSql.Count > 1;
  if Result then
  begin
    fbManagerMainForm.tlsSqlScriptExecute(nil);
    if Assigned(FBMSqlScripForm) then
      FBMSqlScripForm.SetSQLText(FSql.Text)
    else
      Result:=false;
  end;
  FSql.Free;
end;

function TImportDataForm.SaveToTable: boolean;
begin
  NotCompleteFunction;
  Result:=false;
end;

procedure TImportDataForm.Localize;
begin
  Caption:=sImportData;
  actOpen.Caption:=sOpen;
  Label1.Caption:=sImportDataFile;
  Label2.Caption:=sSkipBeforeRows;
  Label3.Caption:=sSkipAfterRows;
  Label4.Caption:=sImportedCollumns;

  TabSheet1.Caption:=sParams;
  TabSheet2.Caption:=sCollumns;
  RadioGroup1.Caption:=sImport;
  RadioGroup1.Items[0]:=sImportDataToTable;
  RadioGroup1.Items[1]:=sGenerateInsertScript;

  RxDBGrid1.ColumnByFieldName('FieldName').Title.Caption:=sFieldName;
  RxDBGrid1.ColumnByFieldName('ColName').Title.Caption:=sCollumnName;
  RxDBGrid1.ColumnByFieldName('DataType').Title.Caption:=sDataType;
  RxDBGrid1.ColumnByFieldName('DefValue').Title.Caption:=sDefaultValue;
  RxDBGrid1.ColumnByFieldName('SkipEmpty').Title.Caption:=sSkipEmpty;
  RxDBGrid1.ColumnByFieldName('NotNull').Title.Caption:=sNotNull;
end;

procedure TImportDataForm.PMFieldClick(Sender: TObject);
begin
//  ShowMessage(sWorksheetGrid1.Col.ToString + ' + ' + T.ToString);
  if (TComponent(Sender).Tag >= 0) and (TComponent(Sender).Tag < FTable.Fields.Count) then
  begin
    if rxFieldList.Locate('FieldName', FTable.Fields[TComponent(Sender).Tag].FieldName, []) then
    begin
      rxFieldList.Edit;
      rxFieldListColName.AsString:=GetColString(sWorksheetGrid1.Col-1);
      rxFieldList.Post;
    end;
  end;
end;

function TImportDataForm.ValidateDate: boolean;
begin
  rxFieldList.First;
  while not rxFieldList.EOF do
  begin
    if rxFieldListNotNull.AsBoolean then
    begin
      if (rxFieldListColName.AsString = '') and (rxFieldListDefValue.AsString = '') then
      begin
        ErrorBox(sFillValuesForNotNullCollumn);
        Exit(false);
      end;
    end;
    rxFieldList.Next;
  end;
  rxFieldList.First;
  Result:=true;
end;

constructor TImportDataForm.CreateImportForm(ATable: TDBTableObject);
begin
  inherited Create(Application);
  CreateWorkSheet;
  Localize;
  FTable:=ATable;
  rxFieldList.Open;
  FillDataColumns;
end;

function TImportDataForm.SaveData: boolean;
begin
  if RadioGroup1.ItemIndex <> 0 then
    Result:=SaveToScript
  else
    Result:=SaveToTable;
end;

end.

