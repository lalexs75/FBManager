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

unit fdbm_SchemeEditorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  sqlObjects, SQLEngineCommonTypesUnit, fdmAbstractEditorUnit,
  SQLEngineAbstractUnit, fbmSqlParserUnit, PostgreSQLEngineUnit;

type

  { Tfdbm_SchemeEditorForm }

  Tfdbm_SchemeEditorForm = class(TEditorPage)
    edtOwnerName: TComboBox;
    edtSchemeName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
  protected
    procedure UserListRefresh;
    procedure PrintScheme;
  public
    function PageName:string;override;
    function ImageName:string;override;
    procedure Activate;override;
    function DoMetod(PageAction: TEditorPageAction): boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

var
  fdbm_SchemeEditorForm: Tfdbm_SchemeEditorForm;

implementation
uses fbmStrConstUnit, pg_SqlParserUnit;

{$R *.lfm}

{ Tfdbm_SchemeEditorForm }

procedure Tfdbm_SchemeEditorForm.UserListRefresh;
var
  S:string;
begin
  S:=edtOwnerName.Text;
  edtOwnerName.Items.Clear;
  DBObject.OwnerDB.FillListForNames(edtOwnerName.Items, [okUser]);
  if (S<>'') then
    edtOwnerName.Text:=S;
//    and (edtOwnerName.Items.IndexOf())
end;

procedure Tfdbm_SchemeEditorForm.PrintScheme;
begin

end;

function Tfdbm_SchemeEditorForm.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
begin
  Result:=true;
  if ASQLObject is TPGSQLCreateSchema then
  begin
    TPGSQLCreateSchema(ASQLObject).Name:=edtSchemeName.Text;
    TPGSQLCreateSchema(ASQLObject).OwnerUserName:=edtOwnerName.Text;
  end
  else
  if ASQLObject is TPGSQLAlterSchema then
  begin
    TPGSQLAlterSchema(ASQLObject).SchemaNewName:=edtSchemeName.Text;
    TPGSQLAlterSchema(ASQLObject).SchemaNewOwner:=edtOwnerName.Text;
  end
  else
  begin
    Result:=false;
    raise Exception.Create('Tfdbm_SchemeEditorForm.SetupSQLObject');
  end;
end;

function Tfdbm_SchemeEditorForm.PageName: string;
begin
  Result:=sSchemeName;
end;

function Tfdbm_SchemeEditorForm.ImageName: string;
begin
  Result:='';
end;

procedure Tfdbm_SchemeEditorForm.Activate;
begin
  UserListRefresh;
end;

function Tfdbm_SchemeEditorForm.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaRefresh:UserListRefresh;
    epaPrint:PrintScheme;
  end;
end;

function Tfdbm_SchemeEditorForm.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaPrint, epaRefresh, epaCompile];
end;

constructor Tfdbm_SchemeEditorForm.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  UserListRefresh;

  edtSchemeName.Text:=DBObject.Caption;
  edtOwnerName.Text:=TPGSchema(DBObject).OwnerName;
end;

procedure Tfdbm_SchemeEditorForm.Localize;
begin
  inherited Localize;
  Label1.Caption:=sSchemeName;
  Label2.Caption:=sSchemeOwner;
end;

end.

