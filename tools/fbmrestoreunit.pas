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

unit fbmrestoreunit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
  ComCtrls, uib, EditBtn, ExtCtrls, SynEdit, RxIniPropStorage, StdCtrls,
  ButtonPanel, FBSQLEngineUnit;

type

  { TfbmRestoreForm }

  TfbmRestoreForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckGroup1: TCheckGroup;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    FileNameEdit1: TFileNameEdit;
    FileNameEdit2: TFileNameEdit;
    FileNameEdit3: TFileNameEdit;
    RxIniPropStorage1: TRxIniPropStorage;
    UIBRestore1: TUIBRestore;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    PageControl1: TPageControl;
    SynEdit1: TSynEdit;
    tabResult: TTabSheet;
    TabSheet1: TTabSheet;
    procedure BitBtn1Click(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UIBRestore1Verbose(Sender: TObject; Message: string);
  private
    VerboseLogFile:TextFile;
    FStartTime:TDateTime;
    procedure DoLocalize;
  public
    { public declarations }
  end; 

procedure ShowFBRestoreForm;
implementation
uses IBManDataInspectorUnit, fbmToolsUnit, uibase, fb_utils, fbmStrConstUnit;

{$R *.lfm}

var
  fbmRestoreForm: TfbmRestoreForm;

procedure ShowFBRestoreForm;
begin
  fbmRestoreForm:=TfbmRestoreForm.Create(Application);
  fbmRestoreForm.ShowModal;
  fbmRestoreForm.Free;
end;

{ TfbmRestoreForm }

procedure TfbmRestoreForm.FormCreate(Sender: TObject);
begin
  UIBRestore1.LibraryName:='';
  DoLocalize;

  ComboBox1.ItemIndex:=fbManDataInpectorForm.DBList.FillDataBaseList(ComboBox1.Items, TSQLEngineFireBird);
  if ComboBox1.ItemIndex > -1 then
    ComboBox1Change(nil);
end;

procedure TfbmRestoreForm.UIBRestore1Verbose(Sender: TObject; Message: string
  );
begin
  if CheckBox1.Checked then
  begin
    SynEdit1.Lines.Add(Message);
  end;

  if CheckBox2.Checked then
    Writeln(VerboseLogFile, Message);

  if (FStartTime + (ConfigValues.ByNameAsInteger('srBackupRestoreRefreshInterval', 10)/(24*60*600)))<Now then
  begin
    FStartTime:=Now;
    SynEdit1.CaretY:=SynEdit1.Lines.Count;
    Application.ProcessMessages;
  end;
end;

procedure TfbmRestoreForm.ComboBox1Change(Sender: TObject);
var
  Rec:TSQLEngineFireBird;
begin
  Rec:=ComboBox1.Items.Objects[ComboBox1.ItemIndex] as TSQLEngineFireBird;
  if Assigned(Rec) then
  begin
    UIBRestore1.UserName:=Rec.UserName;
    UIBRestore1.PassWord:=Rec.Password;
    UIBRestore1.Database:=Rec.RestoreOptions.roSingleFileName;
    UIBRestore1.Host:=Rec.ServerName;
    UIBRestore1.Protocol:=Rec.Protocol;

    FileNameEdit1.Text:=Rec.RestoreOptions.roSingleFileName;
    CheckBox2.Checked:=Rec.RestoreOptions.roVerboseToFile;
    CheckBox1.Checked:=Rec.RestoreOptions.roVerboseToScreen;
    FileNameEdit2.Text:=Rec.RestoreOptions.roVerboseFileName;
    FileNameEdit3.Text:=Rec.BackupOptions.bkSingleFileName;
    ComboBox2.Text:=IntToStr(Rec.RestoreOptions.roPageSize);
    SetRestoreOptToCheckGroup(Rec.RestoreOptions.roRestoreOption, CheckGroup1);

    UIBRestore1.LibraryName:=GDS32DLL;
  end;
end;


procedure TfbmRestoreForm.BtnOkClick(Sender: TObject);
begin
  if CheckBox2.Checked then
  begin
    AssignFile(VerboseLogFile, FileNameEdit2.Text);
    Rewrite(VerboseLogFile);
  end;

  SynEdit1.Lines.Clear;

  try
    UIBRestore1.Verbose:=CheckBox1.Checked or CheckBox2.Checked;
    UIBRestore1.BackupFiles.Clear;
    UIBRestore1.BackupFiles.Add(FileNameEdit3.Text);
    UIBRestore1.PageSize:=StrToIntDef(ComboBox2.Text, 4096);

    if CheckBox1.Checked  then
      PageControl1.ActivePage:=tabResult;

    UIBRestore1.Options:=MakeRestoreOpt(CheckGroup1);
    
    FStartTime:=Now;

    UIBRestore1.Run;
    ShowMessage(sRestoreSuccessfullyFinished);
  except
    on E:Exception do
      ErrorBoxExcpt(E);
  end;

  if CheckBox2.Checked then
    CloseFile(VerboseLogFile);
end;

procedure TfbmRestoreForm.BitBtn1Click(Sender: TObject);
var
  Rec:TSQLEngineFireBird;
begin
  Rec:=ComboBox1.Items.Objects[ComboBox1.ItemIndex] as TSQLEngineFireBird;
  if Assigned(Rec) then
  begin
    Rec.RestoreOptions.roSingleFileName:=FileNameEdit1.Text;
    Rec.RestoreOptions.roVerboseToFile:=CheckBox2.Checked;
    Rec.RestoreOptions.roVerboseToScreen:=CheckBox1.Checked;
    Rec.RestoreOptions.roVerboseFileName:=FileNameEdit2.Text;
    Rec.BackupOptions.bkSingleFileName:=FileNameEdit3.Text;
    Rec.RestoreOptions.roPageSize:=StrToIntDef(ComboBox2.Text, 4096);
    Rec.RestoreOptions.roRestoreOption:=MakeRestoreOpt(CheckGroup1);

//    fbManDataInpectorForm.SaveAliasList;
  end;
end;

procedure TfbmRestoreForm.DoLocalize;
begin

end;

end.

