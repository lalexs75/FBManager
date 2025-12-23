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

unit cfSQLEditorOptionsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, DividerBevel, LResources, Forms, StdCtrls, Spin,
  Graphics, ColorBox, cfAbstractConfigFrameUnit;

type

  { TcfSQLEditorOptionsFrame }

  TcfSQLEditorOptionsFrame = class(TFBMConfigPageAbstract)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ColorBox1: TColorBox;
    ColorBox2: TColorBox;
    ColorBox3: TColorBox;
    ColorBox4: TColorBox;
    DividerBevel1: TDividerBevel;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    LabelCenter: TLabel;
    LabelCenter1: TLabel;
    se_cdFetchAll: TCheckBox;
    se_cdGoToResult: TCheckBox;
    SpinEdit1: TSpinEdit;
  private
    { private declarations }
  public
    function PageName:string;override;
    procedure LoadData;override;
    procedure SaveData;override;
    procedure Localize;override;
  end;

implementation
uses fbmStrConstUnit, fbmToolsUnit;

{$R *.lfm}

{ TcfSQLEditorOptionsFrame }

function TcfSQLEditorOptionsFrame.PageName: string;
begin
  Result:=sSQLEditor;
end;

procedure TcfSQLEditorOptionsFrame.LoadData;
begin
  {tools}
  CheckBox3.Checked:=ConfigValues.ByNameAsBoolean('Use_table_name_as_alis_in_create_SQL_form', true);
  CheckBox1.Checked:=ConfigValues.ByNameAsBoolean('Show result grid on first page', false);
  {SE - SQL editor}
  se_cdFetchAll.Checked:=ConfigValues.ByNameAsBoolean('seFetchAll', false);
  se_cdGoToResult.Checked:=ConfigValues.ByNameAsBoolean('seGoToResult', true);
  CheckBox2.Checked:=ConfigValues.ByNameAsBoolean('SQLEditor/Show query plan', true);
  SpinEdit1.Value := ConfigValues.ByNameAsInteger('CountSQLHistoryGlobal', 100);

  ColorBox1.Selected:=ConfigValues.ByNameAsInteger('SQLHistory-SELECT_Color', clWindow);
  ColorBox2.Selected:=ConfigValues.ByNameAsInteger('SQLHistory-INSERT_Color', clSkyBlue);
  ColorBox3.Selected:=ConfigValues.ByNameAsInteger('SQLHistory-UPDATE_Color', clMoneyGreen);
  ColorBox4.Selected:=ConfigValues.ByNameAsInteger('SQLHistory-DELETE_Color', clGreen);
end;

procedure TcfSQLEditorOptionsFrame.SaveData;
begin
  ConfigValues.SetByNameAsBoolean('Use_table_name_as_alis_in_create_SQL_form', CheckBox3.Checked);
  ConfigValues.SetByNameAsBoolean('Show result grid on first page', CheckBox1.Checked);
  {SE - SQL editor}
  ConfigValues.SetByNameAsBoolean('seFetchAll', se_cdFetchAll.Checked);
  ConfigValues.SetByNameAsBoolean('seGoToResult', se_cdGoToResult.Checked);
  ConfigValues.SetByNameAsInteger('CountSQLHistoryGlobal', SpinEdit1.Value);
  ConfigValues.SetByNameAsBoolean('SQLEditor/Show query plan', CheckBox2.Checked);

  ConfigValues.SetByNameAsInteger('SQLHistory-SELECT_Color', ColorBox1.Selected);
  ConfigValues.SetByNameAsInteger('SQLHistory-INSERT_Color', ColorBox2.Selected);
  ConfigValues.SetByNameAsInteger('SQLHistory-UPDATE_Color', ColorBox3.Selected);
  ConfigValues.SetByNameAsInteger('SQLHistory-DELETE_Color', ColorBox4.Selected);
end;

procedure TcfSQLEditorOptionsFrame.Localize;
begin
  inherited Localize;
  CheckBox3.Caption:=sUseTableAlisInCreateSQLForm;
  CheckBox1.Caption:=sShowResultGridOnFirstPage;
  GroupBox3.Caption:=sSQLEditor;
  se_cdFetchAll.Caption:=sFetchAll;
  se_cdGoToResult.Caption:=sGoToResultTabAfterExecute;
  Label1.Caption:=sCountSQLEditorHistoryRecords;
  DividerBevel1.Caption:=sSQLHistoryColors;
  CheckBox2.Caption:=sShowQueryPlan;

  Label2.Caption:=sSELECTColor;
  Label3.Caption:=sINSERTColor;
  Label4.Caption:=sUPDATEColor;
  Label5.Caption:=sDELETEColor;
end;

end.

