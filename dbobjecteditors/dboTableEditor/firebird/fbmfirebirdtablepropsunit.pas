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

unit fbmFirebirdTablePropsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, ExtCtrls, fdmAbstractEditorUnit, fbmSqlParserUnit, SQLEngineAbstractUnit;

type

  { TfbmFirebirdTablePropsPage }

  TfbmFirebirdTablePropsPage = class(TEditorPage)
    CheckBox1: TCheckBox;
    FileNameEdit1: TFileNameEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioGroup1: TRadioGroup;
    procedure RadioButton1Change(Sender: TObject);
  private
    procedure LoadTableProps;
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    procedure Localize;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses fbmStrConstUnit, fb_SqlParserUnit, FBSQLEngineUnit;

{$R *.lfm}

{ TfbmFirebirdTablePropsPage }

procedure TfbmFirebirdTablePropsPage.RadioButton1Change(Sender: TObject);
begin
  if DBObject.State <> sdboCreate then exit;
  FileNameEdit1.Enabled:=RadioButton2.Checked;
  CheckBox1.Enabled:=RadioButton1.Checked;
  RadioGroup1.Enabled:=RadioButton1.Checked and CheckBox1.Checked;
end;

procedure TfbmFirebirdTablePropsPage.LoadTableProps;
begin
  if DBObject.State <>sdboCreate then
  begin
    RadioButton2.Checked:=TFireBirdTable(DBObject).ExternalFile <> '';
    FileNameEdit1.Text:=TFireBirdTable(DBObject).ExternalFile;

    if TFireBirdTable(DBObject).TempTableAction <> oncNone then
    begin
      CheckBox1.Checked:=true;
      if TFireBirdTable(DBObject).TempTableAction = oncPreserve then
        RadioGroup1.ItemIndex:=1
      else
        RadioGroup1.ItemIndex:=0;
    end;

    RadioButton1.Enabled:=false;
    RadioButton2.Enabled:=false;
    FileNameEdit1.Enabled:=false;
    CheckBox1.Enabled:=false;
    RadioGroup1.Enabled:=false;
  end
  else
    RadioButton1Change(nil);
end;

function TfbmFirebirdTablePropsPage.PageName: string;
begin
  Result:=sProperty;
end;

constructor TfbmFirebirdTablePropsPage.CreatePage(TheOwner: TComponent; ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  LoadTableProps;
end;

procedure TfbmFirebirdTablePropsPage.Localize;
begin
  inherited Localize;
  RadioButton1.Caption:=sNormalMode;
  RadioButton2.Caption:=sExtrenalFile;
  CheckBox1.Caption:=sGlobalTemporaryTable;
  RadioGroup1.Items[0]:=sOnCommitDeleteRows;
  RadioGroup1.Items[1]:=sOnCommitPreserveRows;
end;

function TfbmFirebirdTablePropsPage.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaPrint, epaRefresh, epaCompile];
end;

function TfbmFirebirdTablePropsPage.SetupSQLObject(ASQLObject: TSQLCommandDDL): boolean;
begin
  Result:=True;
  if ASQLObject is TFBSQLCreateTable then
  begin
    if CheckBox1.Checked then
    begin
      if RadioGroup1.ItemIndex = 0 then
        TFBSQLCreateTable(ASQLObject).OnCommit:=oncDelete
      else
        TFBSQLCreateTable(ASQLObject).OnCommit:=oncPreserve;
    end
    else
      TFBSQLCreateTable(ASQLObject).OnCommit:=oncNone;

    if RadioButton2.Checked then
      TFBSQLCreateTable(ASQLObject).FileName:=FileNameEdit1.FileName
    else
      TFBSQLCreateTable(ASQLObject).FileName:='';
  end;
end;

end.

