{ Free DB Manager

  Copyright (C) 2005-2018 Lagunov Aleksey  alexs75 at yandex.ru

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

unit cfGridOptionsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, StdCtrls, ExtCtrls, Spin, Graphics,
  ColorBox, cfAbstractConfigFrameUnit;

type

  { TcfGridOptionsFrame }

  TcfGridOptionsFrame = class(TFBMConfigPageAbstract)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    ColorBox1: TColorBox;
    Edit1: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    SpinEdit1: TSpinEdit;
  private
    { private declarations }
  public
    constructor Create(TheOwner: TComponent); override;
    function PageName:string;override;
    procedure LoadData;override;
    procedure SaveData;override;
    procedure Localize;override;
  end;

implementation
uses fbmStrConstUnit, fbmToolsUnit, SQLEngineCommonTypesUnit, rxstrutils;

{$R *.lfm}

{ TcfGridOptionsFrame }

constructor TcfGridOptionsFrame.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  RadioGroup1.Items.Clear;
  RadioGroup1.Items.Add(sGSLazarus);
  RadioGroup1.Items.Add(sGSStandart);
  RadioGroup1.Items.Add(sGSNative);
end;

function TcfGridOptionsFrame.PageName: string;
begin
  Result:=sGridOptions;
end;

procedure TcfGridOptionsFrame.LoadData;
begin
  RadioGroup1.ItemIndex:=ConfigValues.ByNameAsInteger('goStyle', 0);
  Edit4.Text:=ConfigValues.ByNameAsString('goffDate', '');
  Edit5.Text:=ConfigValues.ByNameAsString('goffTime', '');
  Edit8.Text:=ConfigValues.ByNameAsString('goffTimeStamp', '');
  Edit6.Text:=ConfigValues.ByNameAsString('goffNumeric', '');
  Edit7.Text:=ConfigValues.ByNameAsString('goffInteger', '');

  Edit9.Text:=DateSeparator;
  Edit1.Text:=ThousandSeparator;
  CheckBox1.Checked:=ConfigValues.ByNameAsBoolean('Grid/Show memo values', true);
  CheckBox2.Checked:=ConfigValues.ByNameAsBoolean('Grid/Allow multiselect', true);
  CheckBox3.Checked:=ConfigValues.ByNameAsBoolean('Grid/Stripy grids', true);
  CheckBox4.Checked:=ConfigValues.ByNameAsBoolean('Grid/Enable tooltips', true);

  RadioGroup2.ItemIndex:=ConfigValues.ByNameAsInteger('Grid filter style', 0);

  SpinEdit1.Value:=ConfigValues.ByNameAsInteger('DBGrid fetch record count', 1000);
  ColorBox1.Selected:=ConfigValues.ByNameAsInteger('Grid/Alternate color', clSkyBlue);
end;

procedure TcfGridOptionsFrame.SaveData;
begin
  ConfigValues.SetByNameAsInteger('goStyle', RadioGroup1.ItemIndex);
  ConfigValues.SetByNameAsString('goffDate', Edit4.Text);
  ConfigValues.SetByNameAsString('goffTime', Edit5.Text);
  ConfigValues.SetByNameAsString('goffTimeStamp', Edit8.Text);
  ConfigValues.SetByNameAsString('goffNumeric', Edit6.Text);
  ConfigValues.SetByNameAsString('goffInteger', Edit7.Text);

  if Edit9.Text<>'' then
    DateSeparator:=Edit9.Text[1];
  if Edit1.Text<>'' then
    ThousandSeparator:=Edit1.Text[1];

  ConfigValues.SetByNameAsString('DateSeparator', QuotedString(DateSeparator, '"'));
  ConfigValues.SetByNameAsString('ThousandSeparator',  QuotedString(ThousandSeparator, '"'));
  ConfigValues.SetByNameAsBoolean('Grid/Show memo values', CheckBox1.Checked);
  ConfigValues.SetByNameAsBoolean('Grid/Show memo values', CheckBox1.Checked);
  ConfigValues.SetByNameAsBoolean('Grid/Allow multiselect', CheckBox2.Checked);
  ConfigValues.SetByNameAsBoolean('Grid/Stripy grids', CheckBox3.Checked);
  ConfigValues.SetByNameAsBoolean('Grid/Enable tooltips', CheckBox4.Checked);

  ConfigValues.SetByNameAsInteger('Grid filter style', RadioGroup2.ItemIndex);
  ConfigValues.SetByNameAsInteger('DBGrid fetch record count', SpinEdit1.Value);

  ConfigValues.SetByNameAsInteger('Grid/Alternate color', ColorBox1.Selected);
end;

procedure TcfGridOptionsFrame.Localize;
begin
  inherited Localize;

  RadioGroup1.Caption:=sGridStile;
  RadioGroup1.Items[0]:=sLazarus;
  RadioGroup1.Items[1]:=sStandart;
  RadioGroup1.Items[2]:=sNative;

  GroupBox1.Caption:=sFieldsFormat;
  Label1.Caption:=sThousandSeparator;
  Label3.Caption:=sAlternateColor;
  Label5.Caption:=sDate;
  Label6.Caption:=sTime;
  Label9.Caption:=sTimeStamp;
  Label7.Caption:=sNumeric;
  Label8.Caption:=sInteger;
  Label11.Caption:=sDateSeparator;

  CheckBox1.Caption:=sDisplayMemoValuesAsText;
  CheckBox2.Caption:=sAllowMultiselect;
  CheckBox3.Caption:=sStripyGrids;
  CheckBox4.Caption:=sEnableTooltips;

  RadioGroup2.Caption:=sFilterStyle;
  RadioGroup2.Items[0]:=sSimple;
  RadioGroup2.Items[1]:=sDialog;
  RadioGroup2.Items[2]:=sManualEdit;
  RadioGroup2.Items[3]:=sBoth;

  Label2.Caption:=sRecordForFetch;
end;

end.

