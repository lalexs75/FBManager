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

unit fbmExportDataUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, EditBtn, Spin, RxDBGrid, DB, memds, Buttons, DBGrids, RxMemDS;

type

  { TfbmExportDataForm }

  TfbmExportDataForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Datasource1: TDatasource;
    Datasource2: TDatasource;
    Edit1: TEdit;
    EditFormatDate: TEdit;
    EditFormatDateTime: TEdit;
    FileNameEdit1: TFileNameEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    MemDataset1: TMemDataset;
    PageControl1: TPageControl;
    RxDBGrid1: TRxDBGrid;
    RxDBGrid2: TRxDBGrid;
    RxMemoryData1: TRxMemoryData;
    SpinEdit1: TSpinEdit;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure LoadStru(DataSet:TDataSet);
  public
    { public declarations }
  end; 

var
  fbmExportDataForm: TfbmExportDataForm;

procedure ExportData(DataSet:TDataSet; TableName:string);
implementation
{$R *.lfm}

procedure ExportData(DataSet:TDataSet; TableName:string);
begin
  fbmExportDataForm:=TfbmExportDataForm.Create(Application);
  fbmExportDataForm.LoadStru(DataSet);
  fbmExportDataForm.Edit1.Text:=TableName;
  fbmExportDataForm.ShowModal;
  fbmExportDataForm.Free;
end;

{ TfbmExportDataForm }

procedure TfbmExportDataForm.ComboBox1Change(Sender: TObject);
begin
  Label3.Enabled:=ComboBox1.ItemIndex = 0;
  FileNameEdit1.Enabled:=ComboBox1.ItemIndex = 0;
end;

procedure TfbmExportDataForm.Button1Click(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfbmExportDataForm.ComboBox2Change(Sender: TObject);
begin
  if ComboBox2.ItemIndex = 2 then
    Label4.Caption:='SP name'
  else
    Label4.Caption:='Table name';
end;

procedure TfbmExportDataForm.FormActivate(Sender: TObject);
begin
  OnActivate:=nil;
  ComboBox1.Height:=Edit1.Height;
  ComboBox2.Height:=Edit1.Height;
end;

procedure TfbmExportDataForm.FormCreate(Sender: TObject);
begin
  MemDataset1.FieldDefs.Clear;
  MemDataset1.FieldDefs.Add('PK', ftBoolean);
  MemDataset1.FieldDefs.Add('I', ftBoolean);
  MemDataset1.FieldDefs.Add('FieldName', ftString, 40);
  MemDataset1.FieldDefs.Add('FieldType', ftString, 80);
  MemDataset1.CreateTable;
  MemDataset1.Open;
  
  EditFormatDate.Text:=ShortDateFormat;
  EditFormatDateTime.Text:=ShortDateFormat + ' '+ShortTimeFormat;
end;

procedure TfbmExportDataForm.LoadStru(DataSet:TDataSet);
var
  i:integer;
begin
  for i:=0 to DataSet.FieldDefs.Count-1 do
  begin
    MemDataset1.Append;
    MemDataset1.FieldByName('I').AsBoolean:=true;
    MemDataset1.FieldByName('FieldName').AsString:=DataSet.FieldDefs[i].Name;
//    MemDataset1.FieldByName('FieldName').AsBoolean:=DataSet.FieldDefs[i].DataType;
    MemDataset1.Post;
  end;
  RxMemoryData1.CopyStructure(MemDataset1);
  RxMemoryData1.Open;
  RxMemoryData1.Append;
  RxMemoryData1.FieldByName('I').AsBoolean:=true;
  RxMemoryData1.FieldByName('FieldName').AsString:='RxMemoryData1.';
  RxMemoryData1.Post;
//  RxMemoryData1.LoadFromDataSet(MemDataset1, 0, lmCopy);
end;

end.

