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

unit fbmCFColorMarksPageUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, ColorBox, ExtCtrls, Spin, StdCtrls, SysUtils, Forms, Controls,
  Graphics, Dialogs, DividerBevel, SQLEngineAbstractUnit,
  fdbm_ConnectionAbstractUnit, ibmanagertypesunit;

type

  { TfbmCFColorMarksPage }

  TfbmCFColorMarksPage = class(TConnectionDlgPage)
    CheckBox1 : TCheckBox;
    CheckBox2 : TCheckBox;
    CheckGroup1 : TCheckGroup;
    ColorBox1 : TColorBox;
    ColorBox2 : TColorBox;
    ColorBox3 : TColorBox;
    ColorBox4 : TColorBox;
    ComboBox1 : TComboBox;
    DividerBevel1: TDividerBevel;
    DividerBevel2 : TDividerBevel;
    Label1 : TLabel;
    Label2 : TLabel;
    Label3 : TLabel;
    Label4 : TLabel;
    Label5 : TLabel;
    Label6 : TLabel;
    SpinEdit1 : TSpinEdit;
  private
    FDBRec: TDataBaseRecord;
  public
    procedure Localize;override;
    procedure Activate;override;
    procedure LoadParams(ASQLEngine:TSQLEngineAbstract);override;
    procedure SaveParams;override;
    function PageName:string;override;
    function Validate:boolean;override;
    constructor Create(ASQLEngineAbstract:TSQLEngineAbstract; AOwner:TForm);
  end;

implementation

uses fbmStrConstUnit, IBManDataInspectorUnit;

{$R *.lfm}

procedure TfbmCFColorMarksPage.Localize;
begin
  inherited Localize;
  CheckBox1.Caption:=sAllowColorMarkingDatabaseWindows;
  CheckGroup1.Items[0]:=sCmOnTopOfWindow;
  CheckGroup1.Items[1]:=sCmOnLeftOfWindow;
  CheckGroup1.Items[2]:=sCmOnBottomOfWindow;
  CheckGroup1.Items[3]:=sCmOnRightOfWindow;
  Label1.Caption:=sMarkLineColor;
  Label2.Caption:=sMarkLineThicknessPixels;
  DividerBevel1.Caption:=sDatabaseExplorer;
  CheckBox2.Caption:=sAllowColorMarkingInDBExplorer;
  Label3.Caption:=sBackgroudColor;
  Label4.Caption:=sFontColor;
  DividerBevel2.Caption:=sWindowNavigation;
  Label5.Caption:=sWindowsBarMarkStyle;
  ComboBox1.Items[0]:=sNone;
  ComboBox1.Items[1]:=sUnderline1;
  ComboBox1.Items[2]:=sUpperLine;
  ComboBox1.Items[3]:=sUnderUpperLines;
  Label6.Caption:=sColor;
end;

procedure TfbmCFColorMarksPage.Activate;
begin
  inherited Activate;
end;

procedure TfbmCFColorMarksPage.LoadParams(ASQLEngine : TSQLEngineAbstract);
begin
  if not Assigned(FDBRec) then Exit;
  CheckBox1.Checked:=FDBRec.FcmAllowColorsMarking;
  CheckGroup1.Checked[0]:=FDBRec.FcmWindowTop;
  CheckGroup1.Checked[1]:=FDBRec.FcmWindowLeft;
  CheckGroup1.Checked[2]:=FDBRec.FcmWindowBottom;
  CheckGroup1.Checked[3]:=FDBRec.FcmWindowRight;
  ColorBox1.Selected:=FDBRec.FcmLineColor;
  SpinEdit1.Value:=FDBRec.FcmLineWidth;

  CheckBox2.Checked:=FDBRec.FcmAllowColorsMarkingDBExploer;
  ColorBox2.Selected:=FDBRec.FcmDBExploerBGColor;
  ColorBox3.Selected:=FDBRec.FcmDBExploerFontColor;

  ComboBox1.ItemIndex :=FDBRec.FcmMDIButtonStyle;
  ColorBox4.Selected :=FDBRec.FcmMDIButtonColor;
end;

procedure TfbmCFColorMarksPage.SaveParams;
begin
  if not Assigned(FDBRec) then Exit;
  FDBRec.FcmAllowColorsMarking          := CheckBox1.Checked;
  FDBRec.FcmWindowTop                   := CheckGroup1.Checked[0];
  FDBRec.FcmWindowLeft                  := CheckGroup1.Checked[1];
  FDBRec.FcmWindowBottom                := CheckGroup1.Checked[2];
  FDBRec.FcmWindowRight                 := CheckGroup1.Checked[3];
  FDBRec.FcmLineColor                   := ColorBox1.Selected;
  FDBRec.FcmLineWidth                   := SpinEdit1.Value;
  FDBRec.FcmAllowColorsMarkingDBExploer := CheckBox2.Checked;
  FDBRec.FcmDBExploerBGColor            := ColorBox2.Selected;
  FDBRec.FcmDBExploerFontColor          := ColorBox3.Selected;

  FDBRec.FcmMDIButtonStyle:=ComboBox1.ItemIndex;
  FDBRec.FcmMDIButtonColor:=ColorBox4.Selected;
end;

function TfbmCFColorMarksPage.PageName : string;
begin
  Result:=sColorMark;
end;

function TfbmCFColorMarksPage.Validate : boolean;
begin
  Result :=true;
end;

constructor TfbmCFColorMarksPage.Create(ASQLEngineAbstract : TSQLEngineAbstract; AOwner : TForm);
begin
  inherited Create(AOwner);
  FDBRec:=fbManDataInspectorForm.DBBySQLEngine(ASQLEngineAbstract);
end;

end.

