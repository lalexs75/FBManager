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

unit fbmTableEditorDataUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, fdmAbstractEditorUnit,
  IniFiles, rxdbgrid, db, rxtoolbar, RxDBGridExportSpreadSheet,
  RxDBGridPrintGrid, RxDBGridFooterTools, RxDBGridExportPdf,
  SQLEngineAbstractUnit, SQLEngineCommonTypesUnit, LR_PGrid, ExtCtrls, DbCtrls,
  DBGrids, Menus, ActnList, Buttons, fpdataexporter, Controls, StdCtrls, Spin;

type

  { TfbmTableEditorDataFrame }

  TfbmTableEditorDataFrame = class(TEditorPage)
    dataFetchAll: TAction;
    dataGenerate: TAction;
    gridAutoFillCollumn: TAction;
    dataImportBlob: TAction;
    dataCopyAsUpdate: TAction;
    dataCopyAsInsert: TAction;
    dataCopyRows: TAction;
    Label2: TLabel;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem6: TMenuItem;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    statFilter: TAction;
    statFunct: TAction;
    dataImport: TAction;
    dataCopyCellFieldName: TAction;
    dataExportToPDF: TAction;
    dataExportToSpreadSheet: TAction;
    Label1: TLabel;
    MenuItem10: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    RxDBGridExportPDF1: TRxDBGridExportPDF;
    RxDBGridExportSpreadSheet1: TRxDBGridExportSpreadSheet;
    RxDBGridFooterTools1: TRxDBGridFooterTools;
    RxDBGridPrint1: TRxDBGridPrint;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpinEdit1: TSpinEdit;
    statRecordCount: TAction;
    dataExport: TAction;
    dataPrint: TAction;
    ActionList1: TActionList;
    DataSource1: TDatasource;
    DBNavigator1: TDBNavigator;
    FPDataExporter1: TFPDataExporter;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    DataGrid: TRxDBGrid;
    SpeedButton1: TSpeedButton;
    procedure dataCopyAsInsertExecute(Sender: TObject);
    procedure dataCopyAsUpdateExecute(Sender: TObject);
    procedure dataCopyCellFieldNameExecute(Sender: TObject);
    procedure dataCopyRowsExecute(Sender: TObject);
    procedure dataExportExecute(Sender: TObject);
    procedure dataExportToPDFExecute(Sender: TObject);
    procedure dataExportToSpreadSheetExecute(Sender: TObject);
    procedure dataFetchAllExecute(Sender: TObject);
    procedure dataGenerateExecute(Sender: TObject);
    procedure DataGridBeforeSorting(Sender: TObject);
    procedure DataGridColumnSized(Sender: TObject);
    procedure DataGridDblClick(Sender: TObject);
    procedure DataGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure DataGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure dataImportExecute(Sender: TObject);
    procedure dataPrintExecute(Sender: TObject);
    procedure DataSource1StateChange(Sender: TObject);
    procedure gridAutoFillCollumnExecute(Sender: TObject);
    procedure RxDBGridExportSpreadSheet1BeforeExecute(Sender: TObject);
    procedure statFilterExecute(Sender: TObject);
    procedure statFunctExecute(Sender: TObject);
    procedure statRecordCountExecute(Sender: TObject);
  private
    { TODO -oalexs : Тут временно так - в дальнейшем либо сделать специальный объект для хранения размеров, либо вынести код в RxDBGrid }
    FColSized:boolean;
    FColSizes:TStringList;
    FPriorState:TDataSetState;
    procedure Commit;
    procedure DoSaveColSizes;
    procedure Rollback;
    procedure SetRecordCountCaption(const S:string);
    procedure RefreshData;
    function PrimaryKeyField:string;
    procedure DataSetAfterScrollRecord(Sender: TDataSet);
  public
    procedure Localize; override;
    function PageName:string; override;
    procedure Activate; override;
    procedure UpdateEnvOptions; override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    procedure SaveState(const SectionName:string; const Ini:TIniFile);override;
    procedure RestoreState(const SectionName:string; const Ini:TIniFile);override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    destructor Destroy; override;
  end;

implementation
uses fbmStrConstUnit, fbmToolsUnit, fbmSQLEditor_ShowMemoUnit, ImportDataUnit,
  GenerateDataUnit, sqlObjects, fbmMakeSQLFromDataSetUnit, LCLType, Clipbrd,
  rxdconst, rxdbutils, fbmCompillerMessagesUnit;

{$R *.lfm}

{ TfbmTableEditorDataFrame }

procedure TfbmTableEditorDataFrame.dataExportExecute(Sender: TObject);
begin
  if TDBDataSetObject(DBObject).DataSet(-1).Active then
  begin
    FPDataExporter1.Dataset:=TDBDataSetObject(DBObject).DataSet(-1);
    FPDataExporter1.TableNameHint:=TDBDataSetObject(DBObject).CaptionFullPatch;
    FPDataExporter1.Execute;
  end;
end;

procedure TfbmTableEditorDataFrame.dataCopyRowsExecute(Sender: TObject);
begin
  DataGrid.CopyCellValue;
end;

procedure TfbmTableEditorDataFrame.dataCopyCellFieldNameExecute(Sender: TObject
  );
begin
  if Assigned(DataSource1.DataSet) and DataSource1.DataSet.Active and (DataSource1.DataSet.RecordCount>0) then
  begin
    Clipboard.Open;
    Clipboard.AsText:=DataGrid.SelectedColumn.Field.FieldName;
    Clipboard.Close;
  end;
end;

procedure TfbmTableEditorDataFrame.dataCopyAsInsertExecute(Sender: TObject);
begin
  if Assigned(DataSource1.DataSet) and DataSource1.DataSet.Active and (DataSource1.DataSet.RecordCount>0) then
  begin
    Clipboard.Open;
    Clipboard.AsText:=MakeSQLInsert(DataSource1.DataSet, DBObject.CaptionFullPatch, DataGrid.SelectedRows);
    Clipboard.Close;
  end;
end;

procedure TfbmTableEditorDataFrame.dataCopyAsUpdateExecute(Sender: TObject);
begin
  if Assigned(DataSource1.DataSet) and DataSource1.DataSet.Active and (DataSource1.DataSet.RecordCount>0) then
  begin
    Clipboard.Open;
    Clipboard.AsText:=MakeSQLUpdate(DataSource1.DataSet, DBObject.CaptionFullPatch, PrimaryKeyField, DataGrid.SelectedRows);
    Clipboard.Close;
  end;
end;

procedure TfbmTableEditorDataFrame.dataExportToPDFExecute(Sender: TObject);
begin
  RxDBGridExportPDF1.Execute;
end;

procedure TfbmTableEditorDataFrame.dataExportToSpreadSheetExecute(
  Sender: TObject);
begin
  RxDBGridExportSpreadSheet1.Execute;
end;

procedure TfbmTableEditorDataFrame.dataFetchAllExecute(Sender: TObject);
begin
  SpinEdit1.Value:=0;
  TDBDataSetObject(DBObject).DataSet(0).Active:=true;
end;

procedure TfbmTableEditorDataFrame.dataGenerateExecute(Sender: TObject);
begin
  if ShowGenerateDataForm(DBObject as TDBTableObject) then
    DataSource1.DataSet.Refresh;
end;

procedure TfbmTableEditorDataFrame.DataGridBeforeSorting(Sender: TObject);
var
  DS: TDataSet;
  P: LongInt;
begin
  if SpinEdit1.Value > 0 then
  begin
    DS:=TDBDataSetObject(DBObject).DataSet(0);
    DS.DisableControls;
    P:=DS.RecNo;
    DS.Active:=false;
    SpinEdit1.Value:=0;
    DS.Active:=true;
    DS.RecNo:=P;
    DS.EnableControls;
  end;
end;

procedure TfbmTableEditorDataFrame.DataGridColumnSized(Sender: TObject);
begin
  FColSized:=true;
end;

procedure TfbmTableEditorDataFrame.DataGridDblClick(Sender: TObject);
var
  DT: TFieldType;
begin
  DT:=DataGrid.SelectedColumn.Field.DataType;
  if TDBDataSetObject(DBObject).DataSet(-1).Active and (TDBDataSetObject(DBObject).DataSet(-1).RecordCount>0) and (DataGrid.SelectedColumn.Field.DataType in [ftMemo, ftBlob] ) then
  begin
    fbmSQLEditor_ShowMemoForm:=TfbmSQLEditor_ShowMemoForm.Create(Application);
    fbmSQLEditor_ShowMemoForm.Datasource1.DataSet:=DataGrid.DataSource.DataSet;
    fbmSQLEditor_ShowMemoForm.DBMemo1.DataField:=DataGrid.SelectedColumn.Field.FieldName;
    fbmSQLEditor_ShowMemoForm.DBImage1.DataField:=DataGrid.SelectedColumn.Field.FieldName;
    fbmSQLEditor_ShowMemoForm.ShowModal;
    fbmSQLEditor_ShowMemoForm.Free;
  end;
end;

procedure TfbmTableEditorDataFrame.DataGridKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if ssCtrl in Shift then
  begin
    if Assigned(DataSource1.DataSet) and  DataSource1.DataSet.Active then
    begin
      if Key = VK_ADD then
      begin
        DataGrid.AutoFillColumns:=false;
        DataGrid.OptimizeColumnsWidthAll;
      end
      else
      if Key = VK_SUBTRACT then
        DataGrid.AutoFillColumns:=true;
    end;
  end;
end;

procedure TfbmTableEditorDataFrame.DataGridMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FColSized then
    DoSaveColSizes;
end;

procedure TfbmTableEditorDataFrame.dataImportExecute(Sender: TObject);
begin
  ImportDataForm:=TImportDataForm.CreateImportForm(DBObject as TDBTableObject);
  if ImportDataForm.ShowModal = mrOk then
  begin
    ;
  end;
  ImportDataForm.Free;
end;

procedure TfbmTableEditorDataFrame.dataPrintExecute(Sender: TObject);
begin
  RxDBGridPrint1.PreviewReport;
end;

procedure TfbmTableEditorDataFrame.DataSource1StateChange(Sender: TObject);
var
  i:integer;
  C:TRxColumn;
  F: TDBField;
  S: String;
begin
  if Assigned(DataSource1.DataSet) then
  begin
    if (FPriorState = dsInactive) and (DataSource1.DataSet.State = dsBrowse) then
    begin
      if DataSource1.DataSet.Active then
      begin
        for i:=0 to FColSizes.Count-1 do
        begin
          C:=DataGrid.ColumnByFieldName(FColSizes.Names[i]);
          if Assigned(C) then
            C.Width:=StrToIntDef(FColSizes.ValueFromIndex[i], C.Width);
        end;
        //Update grid collumn hints
        for F in TDBDataSetObject(DBObject).Fields do
        begin
          S:=Trim(F.FieldDescription);
          if S <> '' then
          begin
            C:=DataGrid.ColumnByFieldName(F.FieldName);
            if Assigned(C) then
            begin
              TRxColumnTitle(C.Title).ShowHint:=true;
              TRxColumnTitle(C.Title).Hint:=S;
            end;
          end;
        end;
      end;
    end
    else
    if ( not(FPriorState in dsEditModes)) and (DataSource1.DataSet.State in dsEditModes) then
    begin
      if DBObject is TDBTableObject then
        if not TDBTableObject(DBObject).ExistsPrimaryKey then
          if not ConfigValues.ByNameAsBoolean('Grid/Enable edit data in tables without primary key', true) then
          begin
            ClearMsg;
            ShowMsg(ppTableNotHavePK, DBObject.CaptionFullPatch, 0, 0);
            DataSource1.DataSet.Cancel;
            abort;
          end;
    end;
    FPriorState:=DataSource1.DataSet.State;
  end
  else
    FPriorState:=dsInactive;
end;

procedure TfbmTableEditorDataFrame.gridAutoFillCollumnExecute(Sender: TObject);
begin
  DataGrid.OptimizeColumnsWidthAll;
end;

procedure TfbmTableEditorDataFrame.RxDBGridExportSpreadSheet1BeforeExecute(
  Sender: TObject);
begin
  RxDBGridExportSpreadSheet1.PageName:=TDBDataSetObject(DBObject).Caption;
  RxDBGridExportSpreadSheet1.FileName:=TDBDataSetObject(DBObject).Caption+'.ods';
end;

procedure TfbmTableEditorDataFrame.statFilterExecute(Sender: TObject);
begin
  if rdgFilter in DataGrid.OptionsRx then
  begin
    DataGrid.OptionsRx:=DataGrid.OptionsRx - [rdgFilter];
    DataSource1.DataSet.Filtered := False;
    DataGrid.CalcStatTotals;
  end
  else
    DataGrid.OptionsRx:=DataGrid.OptionsRx + [rdgFilter];
end;

procedure TfbmTableEditorDataFrame.statFunctExecute(Sender: TObject);
begin
  RxDBGridFooterTools1.Execute;
end;

procedure TfbmTableEditorDataFrame.statRecordCountExecute(Sender: TObject);
var
  Cnt:integer;
begin
  if TDBDataSetObject(DBObject).DataSet(SpinEdit1.Value).Active then
    Cnt:=TDBDataSetObject(DBObject).RecordCount
  else
    Cnt:=0;
  SetRecordCountCaption(Format(sRecordCount, [Cnt]));
end;

procedure TfbmTableEditorDataFrame.Commit;
begin
  TDBDataSetObject(DBObject).Commit;
  SetRecordCountCaption('');
end;

procedure TfbmTableEditorDataFrame.DoSaveColSizes;
var
  i: integer;
begin
  FColSizes.Clear;
  for i:=0 to DataGrid.Columns.Count-1 do
    FColSizes.Values[DataGrid.Columns[i].FieldName]:=IntToStr(DataGrid.Columns[i].Width);
  FColSized:=false;
end;

procedure TfbmTableEditorDataFrame.Rollback;
begin
  TDBDataSetObject(DBObject).RollBack;
  SetRecordCountCaption('');
end;

procedure TfbmTableEditorDataFrame.SetRecordCountCaption(const S:string);
begin
  if S<>'' then
    statRecordCount.Caption:=S
  else
    statRecordCount.Caption:=sRecordCountGet;
  SpeedButton1.Width:=16 + SpeedButton1.Glyph.Width + SpeedButton1.Canvas.TextWidth(statRecordCount.Caption);
end;

procedure TfbmTableEditorDataFrame.RefreshData;
begin
  if Assigned(DataSource1.DataSet) and DataSource1.DataSet.Active then
  begin
    RefreshQuery(DataSource1.DataSet);
    //DataSource1.DataSet.Refresh;
  end;
end;

function TfbmTableEditorDataFrame.PrimaryKeyField: string;
var
  i: Integer;
  C: TPrimaryKeyRecord;
begin
  Result:='';
  for i:=0 to TDBTableObject(DBObject).ConstraintCount-1 do
  begin
    C:=TDBTableObject(DBObject).Constraint[i];
    if C.ConstraintType = ctPrimaryKey then
    begin
      Result:=C.FieldList;
      Exit;
    end;
  end;
end;

procedure TfbmTableEditorDataFrame.DataSetAfterScrollRecord(Sender: TDataSet);
begin
  if DataGrid.SelectedRows.Count > 1 then
    Label2.Caption:=Format(sRecordFetchedWithSelected, [DataSource1.DataSet.RecordCount, DataGrid.SelectedRows.Count])
  else
    Label2.Caption:=Format(sRecordFetched, [DataSource1.DataSet.RecordCount]);
end;

procedure TfbmTableEditorDataFrame.Localize;
begin
  inherited Localize;
  dataPrint.Caption:=sPrint;
  dataExport.Caption:=sExportData;
  dataExportToSpreadSheet.Caption:=sExportToSpreadsheet;
  dataExportToPDF.Caption:=sExportDataToPDF;
  dataCopyRows.Caption:=sCopyCellValue;
  dataCopyCellFieldName.Caption:=sCopyFieldName;

  RxDBGridFooterTools1.Caption:=sRxDBGridToolsCaption;
  RxDBGridExportSpreadSheet1.Caption:=sToolsExportSpeadSheet;
  RxDBGridExportPDF1.Caption:=sToolsExportPDF;
  dataImport.Caption:=sImportData;
  dataGenerate.Caption:=sTestDataGenerator;

  statFilter.Caption:=sFilterInTable;
  statFilter.Hint:=sFilterInTableHint;
  statFunct.Caption:=sSummaryLine;
  statFunct.Hint:=sSummaryLineHint;

  dataCopyAsInsert.Caption:=sCopySelectedRecordAsInsert;
  dataCopyAsUpdate.Caption:=sCopySelectedRecordAsUpdate;

  gridAutoFillCollumn.Caption:=sAutoFillCollumnWidth;
  gridAutoFillCollumn.Caption:=sAutoFillCollumnWidthHint;

  dataFetchAll.Caption:=sFetchAll;
  dataFetchAll.Hint:=sFetchAll;
end;

function TfbmTableEditorDataFrame.PageName: string;
begin
  Result:=sData;
end;

procedure TfbmTableEditorDataFrame.Activate;
var
  DS: TDataSet;
  P1: TDataSetNotifyEvent;
  C: Boolean;
begin
  if not Assigned(DataSource1.DataSet) then
  begin
    DS:=TDBDataSetObject(DBObject).DataSet(SpinEdit1.Value);
    P1:=DS.AfterScroll;
    C:=Assigned(P1);
    DS.AfterScroll:=@DataSetAfterScrollRecord;

    DataSource1.DataSet:=DS;
  end
  else
    TDBDataSetObject(DBObject).DataSet(SpinEdit1.Value);

  if not DataSource1.DataSet.Active then
  begin
    DataSource1.DataSet.Active:=true;
    DataSetAfterScrollRecord(DS);
  end;
  SetRxDBGridOptions(DataGrid);

(*  DataGrid.ReadOnly:=false;
  if DBObject is TDBTableObject then
    if not TDBTableObject(DBObject).ExistsPrimaryKey then
      if not ConfigValues.ByNameAsBoolean('Grid/Enable edit data in tables without primary key', true) then
        DataGrid.ReadOnly:=true;
*)
end;

procedure TfbmTableEditorDataFrame.UpdateEnvOptions;
begin
  inherited UpdateEnvOptions;
  SetRxDBGridOptions(DataGrid);
  SpinEdit1.Value:=ConfigValues.ByNameAsInteger('DBGrid fetch record count', 1000);
end;

function TfbmTableEditorDataFrame.DoMetod(PageAction:TEditorPageAction):boolean;
begin
  Result:=true;
  case PageAction of
    epaCommit:Commit;
    epaRolback:RollBack;
    epaPrint:dataPrint.Execute;
    epaRefresh:RefreshData;
    epaDelete:DBNavigator1.BtnClick(nbDelete);
    epaExport:dataExport.Execute;
  end;
end;

function TfbmTableEditorDataFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaPrint, epaRefresh, epaDelete, epaCommit, epaRolback, epaExport];
end;

procedure TfbmTableEditorDataFrame.SaveState(const SectionName: string;
  const Ini: TIniFile);
begin
  SaveRxDBGridState(SectionName+'.DataGrid', Ini, DataGrid);
end;

procedure TfbmTableEditorDataFrame.RestoreState(const SectionName: string;
  const Ini: TIniFile);
var
  Cnt, i, W:integer;
  S, FFieldName:string;
begin
  S:=SectionName+'.DataGrid';
  Cnt:=Ini.ReadInteger(S, 'Columns.Count', 0);
  FColSizes.Clear;
  for i:=0 to Cnt - 1 do
  begin
    FFieldName:=Ini.ReadString(S, 'Column_'+IntToStr(i)+'.FieldName', '');
    W:=Ini.ReadInteger(S, 'Column_'+IntToStr(i)+'.Width', -1);
    if W>0 then
      FColSizes.Values[FFieldName]:=IntToStr(W);
  end;
end;

constructor TfbmTableEditorDataFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  SpinEdit1.Value:=ConfigValues.ByNameAsInteger('DBGrid fetch record count', 1000);
  RxDBGridPrint1.ReportTitle:=sRecFromTable + DBObject.Caption;
  FColSizes:=TStringList.Create;

  SetDBNavigatorHint(DBNavigator1);

  Label1.Caption:=sCountRowToFetch;
  RxDBGridExportSpreadSheet1.PageName:=DBObject.Caption;
  RxDBGridExportSpreadSheet1.FileName:=DBObject.Caption + '.ods';

  RxDBGridExportPDF1.FileName:=DBObject.Caption + '.pdf';
  statRecordCount.Caption:=sRecordCountGet;
  dataImport.Enabled:=DBObject is TDBTableObject;
  dataImport.Visible:=DBObject is TDBTableObject;
  MenuItem2.Visible:=DBObject is TDBTableObject;
  dataGenerate.Visible:=DBObject is TDBTableObject;
end;

destructor TfbmTableEditorDataFrame.Destroy;
begin
  FreeAndNil(FColSizes);
  inherited Destroy;
end;

end.

