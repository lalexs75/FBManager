{ Free DB Manager

  Copyright (C) 2005-2024 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fbm_cf_BuckupUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, FBSQLEngineUnit,
  fbmConnectionEditUnit, StdCtrls, EditBtn, rxdbgrid, ExtCtrls,
  SQLEngineAbstractUnit, fdbm_ConnectionAbstractUnit;

type

  { TfbmCFBackupFrame }

  TfbmCFBackupFrame = class(TConnectionDlgPage)
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckGroup1: TCheckGroup;
    edtBkSingleFileName: TFileNameEdit;
    edtBkVerboseFileName: TFileNameEdit;
    GroupBox1: TGroupBox;
    GroupBox3: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RxDBGrid1: TRxDBGrid;
    Splitter1: TSplitter;
  private
    FSQLEngineFireBird:TSQLEngineFireBird;
  public
    procedure Localize;override;
    procedure LoadParams(ASQLEngine:TSQLEngineAbstract);override;
    procedure SaveParams;override;
    function PageName:string;override;
    constructor Create(ASQLEngineFireBird:TSQLEngineFireBird; AOwner:TForm);
  end;

implementation
uses fbmStrConstUnit;

{$R *.lfm}

{ TfbmCFBackupFrame }

procedure TfbmCFBackupFrame.Localize;
begin
  inherited Localize;
  GroupBox1.Caption:=sBackup;
  RadioButton2.Caption:=sSingleFileBackup;
  RadioButton1.Caption:=sSeparetedFiles;
  GroupBox3.Caption:=sOptions;

  CheckGroup1.Caption:=sBackupOptions;
  CheckGroup1.Items[0]:=sIgnoreChecksums;
  CheckGroup1.Items[1]:=sIgnoreLimbo;
  CheckGroup1.Items[2]:=sMetadataOnly;
  CheckGroup1.Items[3]:=sNoGarbageCollection;
  CheckGroup1.Items[4]:=sOldMetadataDesc;
  CheckGroup1.Items[5]:=sNonTransportable;
  CheckGroup1.Items[6]:=sConvertExtTables;
  CheckGroup1.Items[7]:=sExpand;

  CheckBox5.Caption:=sLogToFile;
  CheckBox6.Caption:=sLogToScreen;
end;

procedure TfbmCFBackupFrame.LoadParams(ASQLEngine:TSQLEngineAbstract);
begin
  with TSQLEngineFireBird(ASQLEngine).BackupOptions do
  begin
    edtBkSingleFileName.Text:=bkSingleFileName;
    CheckBox5.Checked:=bkVerboseToFile;
    CheckBox6.Checked:=bkVerboseToScreen;
    edtBkVerboseFileName.Text:=bkVerboseFileName;
  end;
end;

procedure TfbmCFBackupFrame.SaveParams;
begin
  with FSQLEngineFireBird.BackupOptions do
  begin
    bkSingleFileName:=edtBkSingleFileName.Text;
    bkVerboseToFile:=CheckBox5.Checked;
    bkVerboseToScreen:=CheckBox6.Checked;
    bkVerboseFileName:=edtBkVerboseFileName.Text;
  end;
end;

function TfbmCFBackupFrame.PageName: string;
begin
  Result:=sBackup;
end;

constructor TfbmCFBackupFrame.Create(ASQLEngineFireBird: TSQLEngineFireBird;
  AOwner: TForm);
begin
  inherited Create(AOwner);
  FSQLEngineFireBird:=ASQLEngineFireBird;
end;

end.

