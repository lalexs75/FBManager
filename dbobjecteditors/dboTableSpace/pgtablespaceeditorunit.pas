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

unit pgTableSpaceEditorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, fdmAbstractEditorUnit, SQLEngineAbstractUnit, PostgreSQLEngineUnit,
  fbmSqlParserUnit;

type

  { TpgTableSpaceEditorPage }

  TpgTableSpaceEditorPage = class(TEditorPage)
    cbOwnerUser: TComboBox;
    edtFolderName: TDirectoryEdit;
    edtTSName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
  private
    //FDBTableSpace:TPGTableSpace;
    procedure PrintPage;
    //function Compile:boolean;
    procedure UpdateEnvOptions;override;
    procedure RefreshObject;
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses fbmStrConstUnit, pgSqlEngineSecurityUnit, pg_SqlParserUnit;

{$R *.lfm}

{ TpgTableSpaceEditorPage }

procedure TpgTableSpaceEditorPage.PrintPage;
begin

end;

(*
function TpgTableSpaceEditorPage.Compile: boolean;
var
  Rec:TPGTableSpaceDef;
begin
  Rec.TSName:=edtTSName.Text;
  Rec.TSFolder:=edtFolderName.Directory;
  Rec.TSOwner:=cbOwnerUser.Text;
  Result:=TPGTableSpace(DBObject).CompileTS(Rec);
end;
*)
procedure TpgTableSpaceEditorPage.UpdateEnvOptions;
begin
  //inherited UpdateEnvOptions;
end;

procedure TpgTableSpaceEditorPage.RefreshObject;
begin
  cbOwnerUser.Items.Clear;
  TPGSecurityRoot(TSQLEnginePostgre(TPGTableSpace(DBObject).OwnerDB).SecurityRoot).PGUsersRoot.FillListForNames(cbOwnerUser.Items, false);

  edtTSName.Enabled:=TPGTableSpace(DBObject).State = sdboCreate;
  edtTSName.Text:=TPGTableSpace(DBObject).Caption;

  edtFolderName.Text:=TPGTableSpace(DBObject).FolderName;
  cbOwnerUser.Text:=TPGTableSpace(DBObject).OwnerUserName;
end;

function TpgTableSpaceEditorPage.PageName: string;
begin
  Result:=sTableSpace;
end;

constructor TpgTableSpaceEditorPage.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  RefreshObject;
end;

function TpgTableSpaceEditorPage.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaRefresh, epaPrint, epaCompile];
end;

function TpgTableSpaceEditorPage.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:PrintPage;
    epaRefresh:RefreshObject;
//    epaCompile:Result:=Compile;
  else
    Result:=false;
  end;
end;

procedure TpgTableSpaceEditorPage.Localize;
begin
  inherited Localize;
  Label1.Caption:=sTableSpaceName;
  Label2.Caption:=sFileFolder;
  Label3.Caption:=sOwner;
end;

function TpgTableSpaceEditorPage.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
begin
  if ASQLObject is TPGSQLCreateTablespace then
  begin
    TPGSQLCreateTablespace(ASQLObject).Name:=edtTSName.Text;
    TPGSQLCreateTablespace(ASQLObject).Directory:=edtFolderName.Text;
    TPGSQLCreateTablespace(ASQLObject).OwnerName:=cbOwnerUser.Text;
    Result:=true;
  end
  else
    Result:=false;
end;

end.

