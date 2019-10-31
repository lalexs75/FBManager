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

unit cfGeneralOptionsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, StdCtrls, ColorBox, ExtCtrls,
  Buttons, cfAbstractConfigFrameUnit;

type

  { TcfGeneralOptionsFrame }

  TcfGeneralOptionsFrame = class(TFBMConfigPageAbstract)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    ColorBox1: TColorBox;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label14: TLabel;
    rgShowBitBtnGlyph: TRadioGroup;
  private
    procedure DoLoadLngList;
  public
    constructor Create(TheOwner: TComponent); override;
    function PageName:string;override;
    procedure LoadData;override;
    procedure SaveData;override;
    procedure Localize;override;
  end;

implementation
uses fbmStrConstUnit, fbmToolsUnit;

{$R *.lfm}

{ TcfGeneralOptionsFrame }

procedure TcfGeneralOptionsFrame.DoLoadLngList;
var
  Sr:TSearchRec;
  R:integer;
  S:string;
begin
  S:=lngFolder+DirectorySeparator+'*.po*';
  R:=FindFirst(S, faAnyFile, SR);
  while R=0 do
  begin
    ComboBox1.Items.Add(Sr.Name);
    R:=FindNext(Sr);
  end;
  FindClose(Sr);
end;

constructor TcfGeneralOptionsFrame.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  DoLoadLngList;
end;

function TcfGeneralOptionsFrame.PageName: string;
begin
  Result:=sGeneral;
end;

procedure TcfGeneralOptionsFrame.LoadData;
var
  i:integer;
begin
  I:=ComboBox1.Items.IndexOf(ConfigValues.ByNameAsString('lngFileName', ''));
  if i<0 then
  begin
    I:=ComboBox1.Items.IndexOf(DefLanguageFile);
    if I<0 then i:=0;
  end;
  ComboBox1.ItemIndex:=i;

  CheckBox1.Checked:=ConfigValues.ByNameAsBoolean('RestoreDBDesktop', true);
  ColorBox1.Selected:=defHintColor;
  rgShowBitBtnGlyph.ItemIndex:=ConfigValues.ByNameAsInteger('defShowBitBtnGlyph', 0);

  CheckBox2.Checked:=ConfigValues.ByNameAsBoolean('defShowObjCaption', true);
  CheckBox3.Checked:=ConfigValues.ByNameAsBoolean('TaskBar/Flat buttons', true);

  CheckBox4.Checked:=ConfigValues.ByNameAsBoolean('TaskBar/Close by F4', true);
  CheckBox5.Checked:=ConfigValues.ByNameAsBoolean('TaskBar/Switch by Tab', true);
  CheckBox6.Checked:=ConfigValues.ByNameAsBoolean('TaskBar/Ask before close all windows', true);
end;

procedure TcfGeneralOptionsFrame.SaveData;
begin
  ConfigValues.SetByNameAsString('lngFileName', ComboBox1.Text);
  ConfigValues.SetByNameAsBoolean('RestoreDBDesktop', CheckBox1.Checked);
  ConfigValues.SetByNameAsInteger('defHintColor', ColorBox1.Selected);
  ConfigValues.SetByNameAsInteger('defShowBitBtnGlyph', rgShowBitBtnGlyph.ItemIndex);
  ConfigValues.SetByNameAsBoolean('defShowObjCaption', CheckBox2.Checked);
  ConfigValues.SetByNameAsBoolean('TaskBar/Flat buttons', CheckBox3.Checked);

  ConfigValues.SetByNameAsBoolean('TaskBar/Close by F4', CheckBox4.Checked);
  ConfigValues.SetByNameAsBoolean('TaskBar/Switch by Tab', CheckBox5.Checked);
  ConfigValues.SetByNameAsBoolean('TaskBar/Ask before close all windows', CheckBox6.Checked);
end;

procedure TcfGeneralOptionsFrame.Localize;
begin
  inherited Localize;
  Label1.Caption:=sInterfaceLanguage;
  Label14.Caption:=sHintColor;
  CheckBox1.Caption:=sSaveDesktopOnDisconectFromDB;
  rgShowBitBtnGlyph.Caption:=sButtonGlyph;
  rgShowBitBtnGlyph.Items.Clear;
  rgShowBitBtnGlyph.Items.Add(sAlwaysShowGlyph);
  rgShowBitBtnGlyph.Items.Add(sNeverShowGlyph);
  rgShowBitBtnGlyph.Items.Add(sDefault);
  CheckBox2.Caption:=sShowObjectNameInObjectEditorForm;
  CheckBox3.Caption:=sFlatButtonsInTaskBar;
  CheckBox4.Caption:=sMDICloseByF4;
  CheckBox5.Caption:=sMDISwitchByTab;
  CheckBox6.Caption:=sAskBeforeCloseAllWindows;
end;

end.

