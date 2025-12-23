{ Free DB Manager

  Copyright (C) 2005-2025 Lagunov Aleksey  alexs75 at yandex.ru

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

unit ibmanagertableeditorPkunit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, ButtonPanel, SQLEngineAbstractUnit;

type

  { TfbmTableEditorPkForm }

  TfbmTableEditorPkForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    EditIndexName: TEdit;
    EditTableName: TEdit;
    Label4: TLabel;
    ListBox2: TListBox;
    ListBox1: TListBox;
    Memo1: TMemo;
    PKName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpeedButton2: TSpeedButton;
    SpeedButton1: TSpeedButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox2DblClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    FDBTable:TDBTableObject;
    procedure InitVar(ADBTable: TDBTableObject; ConstrPrif: string);
    procedure UpdateFieldsList;
    procedure FillIndexList;
    procedure FillFieldList;
  public
    procedure Localize;
    function GetFieldNames:string;
    constructor CreatePKEditForm(ADBTable:TDBTableObject);
    constructor CreateUNQEditForm(ADBTable:TDBTableObject);
  end;

var
  fbmTableEditorPkForm: TfbmTableEditorPkForm;

implementation
uses rxAppUtils, fbmToolsUnit, fbmStrConstUnit, SQLEngineCommonTypesUnit, SQLEngineInternalToolsUnit, LazUTF8;

{$R *.lfm}

{ TfbmTableEditorPkForm }

procedure TfbmTableEditorPkForm.SpeedButton2Click(Sender: TObject);
begin
  if (ListBox2.ItemIndex>-1) and (ListBox2.ItemIndex< ListBox2.Items.Count) then
  begin
    ListBox1.Items.Add(ListBox2.Items[ListBox2.ItemIndex]);
    ListBox2.Items.Delete(ListBox2.ItemIndex);
    UpdateFieldsList;
  end;
end;

procedure TfbmTableEditorPkForm.SpeedButton1Click(Sender: TObject);
begin
  if (ListBox1.ItemIndex>-1) and (ListBox1.ItemIndex< ListBox1.Items.Count) then
  begin
    ListBox2.Items.Add(ListBox1.Items[ListBox1.ItemIndex]);
    ListBox1.Items.Delete(ListBox1.ItemIndex);
    UpdateFieldsList;
  end;
end;

procedure TfbmTableEditorPkForm.ListBox1DblClick(Sender: TObject);
begin
  if SpeedButton1.Enabled then
    SpeedButton1.Click;
end;

procedure TfbmTableEditorPkForm.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  if ModalResult = mrOk then
  begin
    CanClose:=ListBox2.Items.Count>0;
    if not CanClose then
      ErrorBox(sPKDlgErr1);
  end;
end;

procedure TfbmTableEditorPkForm.ListBox2DblClick(Sender: TObject);
begin
  if SpeedButton2.Enabled then
    SpeedButton2.Click;
end;

procedure TfbmTableEditorPkForm.UpdateFieldsList;
begin
  SpeedButton1.Enabled:=ListBox1.Items.Count>0;
  SpeedButton2.Enabled:=ListBox2.Items.Count>0;
end;

procedure TfbmTableEditorPkForm.FillIndexList;
begin

end;

procedure TfbmTableEditorPkForm.FillFieldList;
begin
  ListBox1.Items.Clear;
  FDBTable.FillFieldList(ListBox1.Items, ccoNoneCase, False);
end;

procedure TfbmTableEditorPkForm.Localize;
begin
  Caption:=sNewPK;
  Label1.Caption:=sTableName;
  Label2.Caption:=sPKName;
  Label3.Caption:=sIndexName;
  Label4.Caption:=sDescription;
end;

procedure TfbmTableEditorPkForm.InitVar(ADBTable:TDBTableObject; ConstrPrif:string);
begin

  if ADBTable.OwnerDB.MiscOptions.ObjectNamesCharCase = ccoUpperCase then
    ConstrPrif:=UTF8UpperString(ConstrPrif)
  else
  if ADBTable.OwnerDB.MiscOptions.ObjectNamesCharCase = ccoLowerCase then
    ConstrPrif:=UTF8LowerCase(ConstrPrif);

  FDBTable:=ADBTable;
  EditTableName.Text:=FDBTable.Caption;
  PKName.Text:=ConstrPrif+FDBTable.Caption;
  FillFieldList;
  FillIndexList;
  UpdateFieldsList;
end;

function TfbmTableEditorPkForm.GetFieldNames: string;
var
  i:integer;
begin
  Result:='';
  for i:=0 to ListBox2.Items.Count-1 do
  begin
    if Result<>'' then
      Result:=Result+',';
    Result:=Result+ DoFormatName(ListBox2.Items[i]);
  end;
end;

constructor TfbmTableEditorPkForm.CreatePKEditForm(ADBTable: TDBTableObject);
begin
  inherited Create(Application);
  Localize;
  InitVar(ADBTable, 'PK_');
end;

constructor TfbmTableEditorPkForm.CreateUNQEditForm(ADBTable: TDBTableObject);
begin
  inherited Create(Application);
  Localize;
  InitVar(ADBTable, 'UNQ_');
  Caption:=sNewUniqueConstraint;
  Label2.Caption:=sUniqueConstraintName;
end;

end.

