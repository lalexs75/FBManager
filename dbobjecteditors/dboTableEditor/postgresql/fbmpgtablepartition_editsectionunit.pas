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

unit fbmPGTablePartition_EditSectionUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ButtonPanel,
  ExtCtrls, AnchorDockPanel, PostgreSQLEngineUnit, pg_SqlParserUnit;

type

  { TfbmPGTablePartition_EditSectionForm }

  TfbmPGTablePartition_EditSectionForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    CLabel: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    procedure CheckBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton3Change(Sender: TObject);
  private
    FEngine:TSQLEnginePostgre;
    FPartitionType: TPGSQLPartitionType;
  public
    procedure Localize;
    procedure SetEngine(AEngine:TSQLEnginePostgre; APartitionType: TPGSQLPartitionType);
  end;

var
  fbmPGTablePartition_EditSectionForm: TfbmPGTablePartition_EditSectionForm;

implementation
uses rxAppUtils, fbmStrConstUnit, sqlObjects;

{$R *.lfm}

{ TfbmPGTablePartition_EditSectionForm }

procedure TfbmPGTablePartition_EditSectionForm.FormCreate(Sender: TObject);
begin
  Localize;
end;

procedure TfbmPGTablePartition_EditSectionForm.RadioButton1Change(
  Sender: TObject);
begin
  Label1.Enabled:=RadioButton2.Checked;
  Edit1.Enabled:=RadioButton2.Checked;

  if Label2.Visible then
  begin
    Label2.Enabled:=RadioButton2.Checked;
    Edit2.Enabled:=RadioButton2.Checked;
  end;
end;

procedure TfbmPGTablePartition_EditSectionForm.RadioButton3Change(
  Sender: TObject);
begin
  Label3.Visible:=RadioButton3.Checked;
  Edit3.Visible:=RadioButton3.Checked;

  Label4.Enabled:=RadioButton3.Checked;
  Edit4.Enabled:=RadioButton3.Checked;

  Label5.Visible:=RadioButton4.Checked;
  ComboBox2.Visible:=RadioButton4.Checked;

  CheckBox1.Enabled:=RadioButton3.Checked;
  if not CheckBox1.Enabled then
    CheckBox1.Checked:=false;

  if RadioButton4.Checked and (ComboBox2.Items.Count = 0) and Assigned(FEngine) then
    FEngine.FillListForNames(ComboBox2.Items, [okTable]);
end;

procedure TfbmPGTablePartition_EditSectionForm.CheckBox1Change(Sender: TObject);
begin
  ComboBox1.Enabled:=CheckBox1.Checked;
end;

procedure TfbmPGTablePartition_EditSectionForm.Localize;
begin
  Caption:=sSectionProperty;
  RadioButton1.Caption:=sDefaultSection;
  CheckBox1.Caption:=sDefineTablespace;
  RadioButton2.Caption:=sSectionParams;
  Label4.Caption:=sDescription;
  Label3.Caption:=sSectionName;
  Label5.Caption:=sExistionTable;

  case FPartitionType of
    ptRange:begin
              Label1.Caption:=sFromValue;
              Label2.Caption:=sToValue;
            end;
    ptList: begin
              Label1.Caption:=sRange;
            end;
    ptHash: begin

            end;
  end;
end;

procedure TfbmPGTablePartition_EditSectionForm.SetEngine(
  AEngine: TSQLEnginePostgre; APartitionType: TPGSQLPartitionType);
begin
  FPartitionType:=APartitionType;
  FEngine:=AEngine;
  ComboBox1.Items.Clear;
  if Assigned(FEngine) then
  begin
    FEngine.TableSpaceRoot.FillListForNames(ComboBox1.Items, true);
  end;

  if FPartitionType = ptList then
  begin
    Label2.Visible:=false;
    Edit2.Visible:=false;
    CheckBox1.AnchorSideTop.Control:=Edit1;
  end
  else
  if FPartitionType = ptHash then
  begin

  end;

  RadioButton3Change(nil);
  Localize;
  RadioButton1Change(nil);
  CheckBox1Change(nil);
end;

end.

