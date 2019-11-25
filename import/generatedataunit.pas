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

unit GenerateDataUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ButtonPanel, ExtCtrls,
  StdCtrls, Spin, ActnList, Menus, DBCtrls, DB, rxmemds, rxdbgrid,
  SQLEngineAbstractUnit;

type

  { TGenerateDataForm }

  TGenerateDataForm = class(TForm)
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    DBMemo1: TDBMemo;
    fldSelAll: TAction;
    fldUnSelAll: TAction;
    ActionList1: TActionList;
    ButtonPanel1: TButtonPanel;
    dsFields: TDataSource;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    PopupMenu1: TPopupMenu;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TDBRadioGroup;
    RxDBGrid1: TRxDBGrid;
    rxFields: TRxMemoryData;
    rxFieldsCHEKED: TBooleanField;
    rxFieldsDataGenAsGUID: TBooleanField;
    rxFieldsDataGenDateIncludeTime: TBooleanField;
    rxFieldsDataGenDateMax: TDateTimeField;
    rxFieldsDataGenDateMin: TDateTimeField;
    rxFieldsDataGenExtFieldName: TStringField;
    rxFieldsDataGenExtTableName: TStringField;
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
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    procedure fldSelAllExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup2Change(Sender: TObject);
    procedure rxFieldsAfterScroll(DataSet: TDataSet);
    procedure rxFieldsBeforeScroll(DataSet: TDataSet);
  private
    FTable: TDBTableObject;
    procedure Localize;
    procedure LoadTableInfo;
    procedure UpdateEditControl;
  public
    constructor CreateGenerateDataForm(ATable:TDBTableObject);
    //function SaveData:boolean;
  end;


procedure ShowGenerateDataForm(ATable:TDBTableObject);
implementation
uses Math;

procedure ShowGenerateDataForm(ATable: TDBTableObject);
var
  GenerateDataForm: TGenerateDataForm;
begin
  GenerateDataForm:=TGenerateDataForm.CreateGenerateDataForm(ATable);
  GenerateDataForm.ShowModal;
  GenerateDataForm.Free;
end;

{$R *.lfm}

{ TGenerateDataForm }

procedure TGenerateDataForm.fldSelAllExecute(Sender: TObject);
begin
  //
end;

procedure TGenerateDataForm.FormCreate(Sender: TObject);
begin
  SpinEdit3.Value:=-MaxInt-1;
  SpinEdit4.Value:=MaxInt;
end;

procedure TGenerateDataForm.RadioGroup2Change(Sender: TObject);
begin
  if rxFields.State <> dsBrowse then
    rxFields.Post;

  UpdateEditControl;
end;

procedure TGenerateDataForm.rxFieldsAfterScroll(DataSet: TDataSet);
begin
  UpdateEditControl;
end;

procedure TGenerateDataForm.rxFieldsBeforeScroll(DataSet: TDataSet);
begin
  //
end;

procedure TGenerateDataForm.Localize;
begin

end;

procedure TGenerateDataForm.LoadTableInfo;
var
  F: TDBField;
begin
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
    rxFields.Post;
  end;

  rxFields.First;
  rxFields.EnableControls;

  rxFields.BeforeScroll:=@rxFieldsBeforeScroll;
  rxFields.AfterScroll:=@rxFieldsAfterScroll;

  UpdateEditControl;
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
begin
  case rxFieldsDataGenType.AsInteger of
    0:G:=GroupBox1;
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
end;

constructor TGenerateDataForm.CreateGenerateDataForm(ATable: TDBTableObject);
begin
  inherited Create(Application);
  Localize;
  FTable:=ATable;
  LoadTableInfo;
end;

end.

