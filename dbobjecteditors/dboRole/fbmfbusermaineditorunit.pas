{ Free DB Manager

  Copyright (C) 2005-2023 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fbmFBUserMainEditorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ValEdit,
  ExtCtrls, fdmAbstractEditorUnit, SQLEngineAbstractUnit, fbmSqlParserUnit,
  FBSQLEngineUnit, FBSQLEngineSecurityUnit;

type

  { TfbmFBUserMainEditorFrame }

  TfbmFBUserMainEditorFrame = class(TEditorPage)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    CLabel: TLabel;
    Panel1: TPanel;
    ValueListEditor1: TValueListEditor;
  private
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    procedure PrintPage;
    procedure LoadUserData;
  public
    procedure Localize;override;
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses fbmStrConstUnit, fb_SqlParserUnit;

{$R *.lfm}

{ TfbmFBUserMainEditorFrame }

function TfbmFBUserMainEditorFrame.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:PrintPage;
  end;
end;

function TfbmFBUserMainEditorFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
{  if DBObject.State = sdboCreate then }
    Result:=PageAction in [epaPrint, epaCompile]
{  else
    Result:=PageAction in [epaPrint]; }
end;

procedure TfbmFBUserMainEditorFrame.PrintPage;
begin
  //frVariables['DBClassTitle']:=DBObject.DBClassTitle;
  //frVariables['ObjectName']:=edtRoleName.Text;
  //fbManagerMainForm.LazReportPrint('DBObject_User');
end;

procedure TfbmFBUserMainEditorFrame.LoadUserData;
var
  F: TFireBirUser;
  i: Integer;
begin

  Edit2.Text:='';
  Edit3.Text:='';
  if DBObject.State = sdboCreate then Exit;

  Edit1.Text:=DBObject.Caption;
  F:=TFireBirUser(DBObject);
  Edit4.Text:=F.FirstName;
  Edit5.Text:=F.MiddleName;
  Edit6.Text:=F.LastName;
  Edit7.Text:=F.Plugin;
  CheckBox2.Checked:=F.Active;
  CheckBox1.Checked:=F.IsAdmin;

  for i:=0 to F.Params.Count-1 do
    ValueListEditor1.InsertRow(F.Params.Names[i], F.Params.ValueFromIndex[i], true);
end;

procedure TfbmFBUserMainEditorFrame.Localize;
begin
  inherited Localize;
  Label1.Caption:=sUserName1;
  Label2.Caption:=sPassword;
  Label3.Caption:=sPassword; //!!

  Label4.Caption:=sFirstName;
  Label5.Caption:=sMiddleName;
  Label6.Caption:=sLastName;

  Label7.Caption:=sPlugin;
//  Label8.Caption:=satPlugin;

  CheckBox1.Caption:=sAdminRole;
  CheckBox2.Caption:=sActive;

end;

function TfbmFBUserMainEditorFrame.PageName: string;
begin
  Result:=sUser;
end;

constructor TfbmFBUserMainEditorFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  LoadUserData;
end;

function TfbmFBUserMainEditorFrame.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  FC: TFBSQLCreateUser;
  i: Integer;
  FA: TFBSQLAlterUser;
begin
  Result:=false;
  if ASQLObject is TFBSQLCreateUser then
  begin
    FC:=TFBSQLCreateUser(ASQLObject);
    FC.Name:=Edit1.Text;
    FC.FirstName:=Edit4.Text;
    FC.MiddleName:=Edit5.Text;
    FC.LastName:=Edit6.Text;
    FC.Password:=Edit2.Text;
    FC.PluginName:=Edit7.Text;

    if CheckBox1.Checked then
      FC.GrantOptions:=goGrant;

    if CheckBox2.Checked then
      FC.State:=trsActive
    else
      FC.State:=trsInactive;

    for i:=0 to ValueListEditor1.RowCount-1 do
      FC.Params.AddParamEx(ValueListEditor1.Cells[0, i], ValueListEditor1.Cells[1, i]);

    Result:=true;
  end
  else
  if ASQLObject is TFBSQLAlterUser then
  begin
    FA:=ASQLObject as TFBSQLAlterUser;
  end;
end;

end.

