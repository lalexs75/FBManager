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

unit fbmRoleMainEditorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, StdCtrls,
  fdmAbstractEditorUnit, SQLEngineAbstractUnit, fbmSqlParserUnit,
  FBSQLEngineUnit;

type

  { TfbmRoleMainEditorFrame }

  TfbmRoleMainEditorFrame = class(TEditorPage)
    edtRoleName: TEdit;
    Label1: TLabel;
  private
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    procedure PrintPage;
    procedure LoadRoleData;
  public
    procedure Localize;override;
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses fbmStrConstUnit, LR_Class, IBManMainUnit, fb_SqlParserUnit;

{$R *.lfm}

{ TfbmRoleMainEditorFrame }

function TfbmRoleMainEditorFrame.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:PrintPage;
  end;
end;

function TfbmRoleMainEditorFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  if DBObject.State = sdboCreate then
    Result:=PageAction in [epaPrint, epaCompile]
  else
    Result:=PageAction in [epaPrint];
end;

procedure TfbmRoleMainEditorFrame.PrintPage;
begin
  frVariables['DBClassTitle']:=DBObject.DBClassTitle;
  frVariables['ObjectName']:=edtRoleName.Text;
  fbManagerMainForm.LazReportPrint('DBObject_Role');
end;

procedure TfbmRoleMainEditorFrame.LoadRoleData;
begin
  Label1.Enabled:=DBObject.State = sdboCreate;
  edtRoleName.Enabled:=DBObject.State = sdboCreate;
  edtRoleName.Text:=DBObject.Caption;
end;

procedure TfbmRoleMainEditorFrame.Localize;
begin
  inherited Localize;
  Label1.Caption:=sRoleName1;
end;

function TfbmRoleMainEditorFrame.PageName: string;
begin
  Result:=sRole;
end;

constructor TfbmRoleMainEditorFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  LoadRoleData;
end;

function TfbmRoleMainEditorFrame.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
begin
  Result:=false;
  if not (ASQLObject is TFBSQLCreateRole) then exit;
  ASQLObject.Name:=edtRoleName.Text;
  Result:=true;
end;

end.

