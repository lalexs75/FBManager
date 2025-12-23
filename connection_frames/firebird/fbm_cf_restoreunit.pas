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

unit fbm_cf_RestoreUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, FBSQLEngineUnit,
  fbmConnectionEditUnit, StdCtrls, EditBtn, rxdbgrid, ExtCtrls, db, rxmemds,
  SQLEngineAbstractUnit, fdbm_ConnectionAbstractUnit;

type

  { TfbmCFRestoreFrame }

  TfbmCFRestoreFrame = class(TConnectionDlgPage)
    CheckBox4: TCheckBox;
    CheckBox7: TCheckBox;
    CheckGroup2: TCheckGroup;
    Datasource1: TDatasource;
    edtRoSingleFileName: TFileNameEdit;
    edtRoVerboseFileName: TFileNameEdit;
    GroupBox2: TGroupBox;
    GroupBox4: TGroupBox;
    Label13: TLabel;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    edtRoPageSize: TComboBox;
    RxDBGrid2: TRxDBGrid;
    RxMemoryData1: TRxMemoryData;
    Splitter2: TSplitter;
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
uses fbmStrConstUnit, fb_utils, fbmToolsUnit;

{$R *.lfm}

{ TfbmCFRestoreFrame }

procedure TfbmCFRestoreFrame.Localize;
begin
  inherited Localize;
  GroupBox4.Caption:=sRestore;
  RadioButton4.Caption:=sSingleFileRestore;
  RadioButton3.Caption:=sSeparetedFiles;
  GroupBox2.Caption:=sOptions;
  CheckGroup2.Caption:=sRestoreOptons;
  CheckGroup2.Items[0]:=sDeactivateIndexes;
  CheckGroup2.Items[1]:=sNoShadow;
  CheckGroup2.Items[2]:=sNoValidityCheck;
  CheckGroup2.Items[3]:=sOneRelationAtATime;
  CheckGroup2.Items[4]:=sReplace;
  CheckGroup2.Items[5]:=sCreateNewDB;
  CheckGroup2.Items[6]:=sUseAllSpace;
  CheckGroup2.Items[7]:=sValidate;
  Label13.Caption:=sPageSize;
  CheckBox7.Caption:=sLogToFile;
  CheckBox4.Caption:=sLogToScreen;
end;

procedure TfbmCFRestoreFrame.LoadParams(ASQLEngine:TSQLEngineAbstract);
begin
  with TSQLEngineFireBird(ASQLEngine).RestoreOptions do
  begin
    edtRoSingleFileName.Text:=roSingleFileName;
    CheckBox7.Checked:=roVerboseToFile;
    CheckBox4.Checked:=roVerboseToScreen;
    edtRoVerboseFileName.Text:=roVerboseFileName;
    edtRoPageSize.Text:=IntToStr(roPageSize);
    SetRestoreOptToCheckGroup(roRestoreOption, CheckGroup2);
  end;
end;

procedure TfbmCFRestoreFrame.SaveParams;
begin
  with FSQLEngineFireBird.RestoreOptions do
  begin
    roSingleFileName:=edtRoSingleFileName.Text;
    roVerboseToFile:=CheckBox7.Checked;
    roVerboseToScreen:=CheckBox4.Checked;
    roVerboseFileName:=edtRoVerboseFileName.Text;
    roPageSize:=StrToIntDef(edtRoPageSize.Text, 4096);
    roRestoreOption:=MakeRestoreOpt(CheckGroup2);
  end;
end;

function TfbmCFRestoreFrame.PageName: string;
begin
  Result:=sRestore;
end;

constructor TfbmCFRestoreFrame.Create(ASQLEngineFireBird: TSQLEngineFireBird;
  AOwner: TForm);
begin
  inherited Create(AOwner);
  FSQLEngineFireBird:=ASQLEngineFireBird;
end;

end.

