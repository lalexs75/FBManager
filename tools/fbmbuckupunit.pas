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

unit fbmbuckupunit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
  ComCtrls, StdCtrls, uib, EditBtn, ExtCtrls, SynEdit, RxIniPropStorage,
  ButtonPanel, XMLPropStorage;

type

  { TfbmBackupForm }

  TfbmBackupForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckGroup1: TCheckGroup;
    ComboBox1: TComboBox;
    FileNameEdit1: TFileNameEdit;
    FileNameEdit2: TFileNameEdit;
    RxIniPropStorage1: TRxIniPropStorage;
    UIBBackup1: TUIBBackup;
    Label1: TLabel;
    Label2: TLabel;
    PageControl1: TPageControl;
    SynEdit1: TSynEdit;
    TabSheet1: TTabSheet;
    tabResult: TTabSheet;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure UIBBackup1Verbose(Sender: TObject; Message: string);
  private
    FStartTime:TDateTime;
    VerboseLogFile:TextFile;
    procedure DoLocalize;
  public
    { public declarations }
  end; 


procedure ShowFBBackupForm;
implementation
uses IBManDataInspectorUnit, fbmToolsUnit, uibase, FBSQLEngineUnit,
  fbmStrConstUnit;

{$R *.lfm}

var
  fbmBackupForm: TfbmBackupForm;

procedure ShowFBBackupForm;
begin
  fbmBackupForm:=TfbmBackupForm.Create(Application);
  fbmBackupForm.ShowModal;
  fbmBackupForm.Free;
end;

{ TfbmBackupForm }

procedure TfbmBackupForm.ComboBox1Change(Sender: TObject);
var
  Rec:TSQLEngineFireBird;
begin
  Rec:=ComboBox1.Items.Objects[ComboBox1.ItemIndex] as TSQLEngineFireBird;
  if Assigned(Rec) then
  begin
    UIBBackup1.UserName:=Rec.UserName;
    UIBBackup1.PassWord:=Rec.Password;
    UIBBackup1.Database:=Rec.DataBaseName;
    UIBBackup1.Host:=Rec.ServerName;
    UIBBackup1.Protocol:=Rec.Protocol;

    FileNameEdit1.Text:=Rec.BackupOptions.bkSingleFileName;
    CheckBox2.Checked:=Rec.BackupOptions.bkVerboseToFile;
    CheckBox1.Checked:=Rec.BackupOptions.bkVerboseToScreen;
    FileNameEdit2.Text:=Rec.BackupOptions.bkVerboseFileName;

    UIBBackup1.LibraryName:=GDS32DLL;
  end;
end;

procedure TfbmBackupForm.FormActivate(Sender: TObject);
begin
  OnActivate:=nil;
  ComboBox1.Height:=FileNameEdit1.Height;
end;

procedure TfbmBackupForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if ModalResult = mrOk then
  begin
    BitBtn1Click(nil);
    CanClose:=ModalResult = mrOk;
  end;
end;

procedure TfbmBackupForm.FormCreate(Sender: TObject);
begin
  ComboBox1.ItemIndex:=fbManDataInpectorForm.DBList.FillDataBaseList(ComboBox1.Items, TSQLEngineFireBird);
  if ComboBox1.ItemIndex > -1 then
    ComboBox1Change(nil);
end;

procedure TfbmBackupForm.UIBBackup1Verbose(Sender: TObject; Message: string);
begin
  if CheckBox1.Checked then
    SynEdit1.Lines.Add(Message);

  if CheckBox2.Checked then
    Writeln(VerboseLogFile, Message);
  SynEdit1.Repaint;
  if (FStartTime + (ConfigValues.ByNameAsInteger('srBackupRestoreRefreshInterval', 10) /(24*60*600)))<Now then
  begin
    FStartTime:=Now;
    SynEdit1.CaretY:=SynEdit1.Lines.Count;
    Application.ProcessMessages;
  end;
end;

procedure TfbmBackupForm.DoLocalize;
begin

end;

procedure TfbmBackupForm.CheckBox1Click(Sender: TObject);
begin
  tabResult.TabVisible:=CheckBox1.Checked;
end;

procedure TfbmBackupForm.BitBtn3Click(Sender: TObject);
var
  Rec:TSQLEngineFireBird;
begin
  Rec:=ComboBox1.Items.Objects[ComboBox1.ItemIndex] as TSQLEngineFireBird;
  if Assigned(Rec) then
  begin
    Rec.BackupOptions.bkSingleFileName:=FileNameEdit1.Text;
    Rec.BackupOptions.bkVerboseToFile:=CheckBox2.Checked;
    Rec.BackupOptions.bkVerboseToScreen:=CheckBox1.Checked;
    Rec.BackupOptions.bkVerboseFileName:=FileNameEdit2.Text;
//    fbManDataInpectorForm.SaveAliasList;
  end;
end;

procedure TfbmBackupForm.BitBtn1Click(Sender: TObject);
begin
  if CheckBox2.Checked then
  begin
    AssignFile(VerboseLogFile, FileNameEdit2.Text);
    Rewrite(VerboseLogFile);
  end;

  SynEdit1.Lines.Clear;

  try
    UIBBackup1.Verbose:=CheckBox1.Checked or CheckBox2.Checked;
    UIBBackup1.BackupFiles.Clear;
    UIBBackup1.BackupFiles.Add(FileNameEdit1.Text);

    if CheckBox1.Checked  then
      PageControl1.ActivePage:=tabResult;
      
    FStartTime:=Now;
    UIBBackup1.Run;
    ShowMessage(sBackupSuccessfullyFinished);
  except
    on E:Exception do
    begin
      ErrorBox(E.Message);
      ModalResult:=mrNone;
    end;
  end;

  if CheckBox2.Checked then
    CloseFile(VerboseLogFile);
end;

end.

