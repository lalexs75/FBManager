{ Free DB Manager

  Copyright (C) 2005-2021 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fbmEditorOptionsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, StdCtrls, Spin, SynEdit, SynHighlighterSQL, RxIniPropStorage,
  ButtonPanel, ExtCtrls;

type

  { TfbmEditorOptionsForm }

  TfbmEditorOptionsForm = class(TForm)
    Button3: TButton;
    ButtonPanel1: TButtonPanel;
    CheckBox1: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    ColorButton1: TColorButton;
    ColorButton10: TColorButton;
    ColorButton2: TColorButton;
    ColorButton3: TColorButton;
    ColorButton4: TColorButton;
    ColorButton5: TColorButton;
    ColorButton6: TColorButton;
    ColorButton7: TColorButton;
    ColorButton8: TColorButton;
    ColorButton9: TColorButton;
    Edit1: TEdit;
    FontDialog1: TFontDialog;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PageControl1: TPageControl;
    rgCharCaseKeyword: TRadioGroup;
    rgCharCaseIdentif: TRadioGroup;
    RxIniPropStorage1: TRxIniPropStorage;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    Splitter1: TSplitter;
    SynEdit1: TSynEdit;
    SynSQLSyn1: TSynSQLSyn;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    procedure Button3Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox6Change(Sender: TObject);
    procedure CheckBox7Change(Sender: TObject);
    procedure ibmEditorOptionsFormClose(Sender: TObject;
      var CloseAction: TCloseAction);
    procedure ibmEditorOptionsFormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
  private
    procedure UpdateEditor;
    procedure Localaze;
  public
    { public declarations }
  end; 

var
  fbmEditorOptionsForm: TfbmEditorOptionsForm;

implementation
uses fbmToolsUnit, fbmStrConstUnit, fbmUserDataBaseUnit, SynEditTypes,
  SQLEngineCommonTypesUnit;

{$R *.lfm}

{ TfbmEditorOptionsForm }

procedure TfbmEditorOptionsForm.ibmEditorOptionsFormCreate(Sender: TObject);
begin
  //
  Edit1.Text := ConfigValues.ByNameAsString('EditorFontName', defEditorFontName);
  SpinEdit1.Value:=ConfigValues.ByNameAsInteger('EditorFontSize', defEditorFontSize);

  ColorButton1.ButtonColor:=ConfigValues.ByNameAsInteger('esqlColorBkgTables', clWindow);
  ColorButton2.ButtonColor:=ConfigValues.ByNameAsInteger('esqlColorFrgTables', clGreen);
  ColorButton3.ButtonColor:=ConfigValues.ByNameAsInteger('esqlColorBkgString', clAqua);
  ColorButton4.ButtonColor:=ConfigValues.ByNameAsInteger('esqlColorFrgString', clBlack);
  ColorButton5.ButtonColor:=ConfigValues.ByNameAsInteger('esqlColorBkgComment', clWindow);
  ColorButton6.ButtonColor:=ConfigValues.ByNameAsInteger('esqlColorFrgComment', clBlack);
  ColorButton7.ButtonColor:=ConfigValues.ByNameAsInteger('esqlColorBkgNumber', clWindow);
  ColorButton8.ButtonColor:=ConfigValues.ByNameAsInteger('esqlColorFrgNumber', clNavy);
  CheckBox2.Checked:=ConfigValues.ByNameAsBoolean('esqlFontUnderlineTables', false);
  CheckBox3.Checked:=ConfigValues.ByNameAsBoolean('esqlFontUnderlineString', false);
  CheckBox11.Checked:=ConfigValues.ByNameAsBoolean('esqlFontUnderlineComment', false);
  CheckBox12.Checked:=ConfigValues.ByNameAsBoolean('esqlFontUnderlineNumbers', false);
  CheckBox1.Checked:=ConfigValues.ByNameAsBoolean('esqlSyntaxHighlight', true);
  CheckBox5.Checked:=ConfigValues.ByNameAsBoolean('EditorAlwaysVisibleCaret', true);
  CheckBox6.Checked:=ConfigValues.ByNameAsBoolean('esqlShowLineNumbers', true);
  SpinEdit2.Value:=ConfigValues.ByNameAsInteger('EditorShowOnlyLineNumOf', 5);

  CheckBox7.Checked := ConfigValues.ByNameAsBoolean('EditorShowRigthBorder', true);
  SpinEdit3.Value   := ConfigValues.ByNameAsInteger('EditorRigthBorderPos', 80);
  rgCharCaseKeyword.ItemIndex:=ConfigValues.ByNameAsInteger('ectCharCaseKeyword', 0);
  rgCharCaseIdentif.ItemIndex:=ConfigValues.ByNameAsInteger('ectCharCaseIdentif', 0);

  CheckBox8.Checked:=ConfigValues.ByNameAsBoolean('EditorHighlightCurrentWord', true);
  TrackBar1.Position:=ConfigValues.ByNameAsInteger('EditorHighlightCurrentWordTimeInterval', 1500);

  CheckBox9.Checked:=ConfigValues.ByNameAsBoolean('EditorAutoCompletionEnables', true);
  TrackBar2.Position:=ConfigValues.ByNameAsInteger('EditorAutoCompletionTimeInterval', 1000);
  CheckBox10.Checked:=ConfigValues.ByNameAsBoolean('EditorDisableAntialiased', false);
  //

  CheckBox7Change(nil);
  CheckBox6Change(nil);
  TrackBar1Change(nil);
  TrackBar2Change(nil);
  Localaze;
end;

procedure TfbmEditorOptionsForm.TrackBar1Change(Sender: TObject);
begin
  Label11.Caption:=Format(sHighlightDelay, [TrackBar1.Position]);
end;

procedure TfbmEditorOptionsForm.TrackBar2Change(Sender: TObject);
begin
  Label12.Caption:=Format(sHighlightDelay, [TrackBar2.Position]);
end;

procedure TfbmEditorOptionsForm.Button3Click(Sender: TObject);
begin
  FontDialog1.Font.Name:=Edit1.Text;
  FontDialog1.Font.Size:=Round(SpinEdit1.Value);
  if FontDialog1.Execute then
  begin
    Edit1.Text:=FontDialog1.Font.Name;
    SpinEdit1.Value:=FontDialog1.Font.Size;
  end;
end;

procedure TfbmEditorOptionsForm.CheckBox1Change(Sender: TObject);
begin
  UpdateEditor;
end;

procedure TfbmEditorOptionsForm.CheckBox6Change(Sender: TObject);
begin
  Label7.Enabled:=CheckBox6.Checked;
  SpinEdit2.Enabled:=CheckBox6.Checked;
  UpdateEditor;
end;

procedure TfbmEditorOptionsForm.CheckBox7Change(Sender: TObject);
begin
  Label8.Enabled:=CheckBox7.Checked;
  SpinEdit3.Enabled:=CheckBox7.Checked;
  UpdateEditor;
end;

procedure TfbmEditorOptionsForm.ibmEditorOptionsFormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if ModalResult = mrOk then
  begin
    ConfigValues.SetByNameAsString('EditorFontName', Edit1.Text);
    ConfigValues.SetByNameAsInteger('EditorFontSize', SpinEdit1.Value);
    ConfigValues.SetByNameAsInteger('esqlColorBkgTables', ColorButton1.ButtonColor);
    ConfigValues.SetByNameAsInteger('esqlColorFrgTables', ColorButton2.ButtonColor);
    ConfigValues.SetByNameAsInteger('esqlColorBkgString', ColorButton3.ButtonColor);
    ConfigValues.SetByNameAsInteger('esqlColorFrgString', ColorButton4.ButtonColor);
    ConfigValues.SetByNameAsInteger('esqlColorBkgComment', ColorButton5.ButtonColor);
    ConfigValues.SetByNameAsInteger('esqlColorFrgComment', ColorButton6.ButtonColor);
    ConfigValues.SetByNameAsInteger('esqlColorBkgNumber', ColorButton7.ButtonColor);
    ConfigValues.SetByNameAsInteger('esqlColorFrgNumber', ColorButton8.ButtonColor);
    ConfigValues.SetByNameAsBoolean('esqlFontUnderlineTables', CheckBox2.Checked);
    ConfigValues.SetByNameAsBoolean('esqlFontUnderlineString', CheckBox3.Checked);
    ConfigValues.SetByNameAsBoolean('esqlFontUnderlineComment', CheckBox11.Checked);
    ConfigValues.SetByNameAsBoolean('esqlFontUnderlineNumbers', CheckBox12.Checked);
    ConfigValues.SetByNameAsBoolean('esqlSyntaxHighlight', CheckBox1.Checked);
    ConfigValues.SetByNameAsBoolean('EditorAlwaysVisibleCaret', CheckBox5.Checked);
    ConfigValues.SetByNameAsBoolean('esqlShowLineNumbers', CheckBox6.Checked);
    ConfigValues.SetByNameAsInteger('EditorShowOnlyLineNumOf', SpinEdit2.Value);

    ConfigValues.SetByNameAsBoolean('EditorShowRigthBorder', CheckBox7.Checked);
    ConfigValues.SetByNameAsInteger('EditorRigthBorderPos', SpinEdit3.Value);
    ConfigValues.SetByNameAsInteger('ectCharCaseKeyword', rgCharCaseKeyword.ItemIndex);
    ConfigValues.SetByNameAsInteger('ectCharCaseIdentif', rgCharCaseIdentif.ItemIndex);

    ConfigValues.SetByNameAsBoolean('EditorHighlightCurrentWord', CheckBox8.Checked);
    ConfigValues.SetByNameAsInteger('EditorHighlightCurrentWordTimeInterval', TrackBar1.Position);

    ConfigValues.SetByNameAsBoolean('EditorAutoCompletionEnables', CheckBox9.Checked);
    ConfigValues.SetByNameAsInteger('EditorAutoCompletionTimeInterval', TrackBar2.Position);
    ConfigValues.SetByNameAsBoolean('EditorDisableAntialiased', CheckBox10.Checked);
    //
    //StoreParams;
    UserDBModule.SaveConfig;
  end;
end;

procedure TfbmEditorOptionsForm.UpdateEditor;
begin
  SynEdit1.Font.Name:=Edit1.Text;
  SynEdit1.Font.Size:=Round(SpinEdit1.Value);

  if CheckBox5.Checked then
    SynEdit1.Options2:=SynEdit1.Options2 + [eoAlwaysVisibleCaret]
  else
    SynEdit1.Options2:=SynEdit1.Options2 - [eoAlwaysVisibleCaret];

  SynEdit1.Gutter.LineNumberPart.Visible:=CheckBox6.Checked;
  SynEdit1.Gutter.LineNumberPart.ShowOnlyLineNumbersMultiplesOf:=SpinEdit2.Value;

  SynSQLSyn1.Enabled:=CheckBox1.Checked;

  SynSQLSyn1.TableNameAttri.Background:=ColorButton1.ButtonColor;
  SynSQLSyn1.TableNameAttri.Foreground:=ColorButton2.ButtonColor;
  if CheckBox2.Checked then
    SynSQLSyn1.TableNameAttri.Style:=SynSQLSyn1.NumberAttri.Style + [fsUnderline]
  else
    SynSQLSyn1.TableNameAttri.Style:=SynSQLSyn1.NumberAttri.Style - [fsUnderline];

  SynSQLSyn1.StringAttri.Background:=ColorButton3.ButtonColor;
  SynSQLSyn1.StringAttri.Foreground:=ColorButton4.ButtonColor;
  if CheckBox3.Checked then
    SynSQLSyn1.StringAttribute.Style:=SynSQLSyn1.NumberAttri.Style + [fsUnderline]
  else
    SynSQLSyn1.StringAttribute.Style:=SynSQLSyn1.NumberAttri.Style - [fsUnderline];

  SynSQLSyn1.CommentAttribute.Background:=ColorButton5.ButtonColor;
  SynSQLSyn1.CommentAttribute.Foreground:=ColorButton6.ButtonColor;
  if CheckBox11.Checked then
    SynSQLSyn1.CommentAttribute.Style:=SynSQLSyn1.NumberAttri.Style + [fsUnderline]
  else
    SynSQLSyn1.CommentAttribute.Style:=SynSQLSyn1.NumberAttri.Style - [fsUnderline];

  SynSQLSyn1.NumberAttri.Background:=ColorButton7.ButtonColor;
  SynSQLSyn1.NumberAttri.Foreground:=ColorButton8.ButtonColor;
  if CheckBox12.Checked then
    SynSQLSyn1.NumberAttri.Style:=SynSQLSyn1.NumberAttri.Style + [fsUnderline]
  else
    SynSQLSyn1.NumberAttri.Style:=SynSQLSyn1.NumberAttri.Style - [fsUnderline];

  SynEdit1.RightEdge:=SpinEdit3.Value;

  if CheckBox7.Checked then
    SynEdit1.Options:=SynEdit1.Options + [eoHideRightMargin]
  else
    SynEdit1.Options:=SynEdit1.Options - [eoHideRightMargin];

  if CheckBox10.Checked then
    SynEdit1.Font.Quality:=fqDefault
  else
    SynEdit1.Font.Quality:=fqAntialiased;

  SynEdit1.SelectionMode:=smNormal;
end;

procedure TfbmEditorOptionsForm.Localaze;
begin
  Caption:=sEditorOptions;
  TabSheet4.Caption:=sTabCodeCompletionParams;
  TabSheet1.Caption:=sGlobal;
  TabSheet2.Caption:=sDisplay;
  TabSheet3.Caption:=sColor;
  Label9.Caption:=sKeywordCharCase;
  Label10.Caption:=sIdentifiersCharCase;
  CheckBox8.Caption:=sHighlightCurrentWord;
  CheckBox9.Caption:=sEnableAutocompletion;
  Label1.Caption:=sDisplayFont;
  Button3.Caption:=sSelectFont;
  Label2.Caption:=sFontSize;
  CheckBox10.Caption:=sDisableAntialiased;
  CheckBox6.Caption:=sShowLineNumbers;
  Label7.Caption:=sShowOnlyLineNumber;
  CheckBox7.Caption:=sShowRightBorder;
  Label8.Caption:=sRightMarginPosition;

  CheckBox1.Caption:=sSyntaxHighlight;
  CheckBox5.Caption:=sCaretAlwaysVisible;
  rgCharCaseKeyword.Items.Clear;
  rgCharCaseKeyword.Items.Add(sUpperCase);
  rgCharCaseKeyword.Items.Add(sLowerCase);
  rgCharCaseKeyword.Items.Add(sNameCase);
  rgCharCaseKeyword.Items.Add(sFirstLetter);
  rgCharCaseIdentif.Items.Assign(rgCharCaseKeyword.Items);

  Label5.Caption:=sBackground;
  Label6.Caption:=sForeground;
  CheckBox2.Caption:=sUnderline;
  CheckBox3.Caption:=sUnderline;
  CheckBox11.Caption:=sUnderline;
  CheckBox12.Caption:=sUnderline;
  Label3.Caption:=sTables;
  Label4.Caption:=sStrings;
  Label14.Caption:=sComment;
  Label15.Caption:=sNumbers;
end;

end.

