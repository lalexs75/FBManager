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

unit fbmObjectEditorDescriptionUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, fdmAbstractEditorUnit,
  SQLEngineAbstractUnit, fbmSqlParserUnit, StdCtrls, Menus, ActnList,
  fdbm_SynEditorUnit, Dialogs, sqlObjects;

type

  { TfbmObjectEditorDescriptionFrame }

  TfbmObjectEditorDescriptionFrame = class(TEditorPage)
    MenuItem1: TMenuItem;
  private
    EditorFrame:Tfdbm_SynEditorFrame;
    procedure PrintPage;
    procedure UpdateEnvOptions;override;
  protected
    //
  public
    function PageName:string; override;
    procedure Activate;override;
    procedure DeActivate;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean;override;
  end;

implementation
uses rxAppUtils, fbmStrConstUnit, LR_Class, IBManMainUnit, fbmToolsUnit;

{$R *.lfm}

{ TfbmObjectEditorDescriptionFrame }

procedure TfbmObjectEditorDescriptionFrame.PrintPage;
begin
  frVariables['DBClassTitle']:=DBObject.DBClassTitle;
  frVariables['ObjectName']:=DBObject.Caption;
  frVariables['ObjectDescription']:=EditorFrame.EditorText;
  fbManagerMainForm.LazReportPrint('DBObject_Description');
end;

procedure TfbmObjectEditorDescriptionFrame.UpdateEnvOptions;
begin
  EditorFrame.ChangeVisualParams;
end;

function TfbmObjectEditorDescriptionFrame.PageName: string;
begin
  Result:=sDescription;
end;

procedure TfbmObjectEditorDescriptionFrame.Activate;
begin
  EditorFrame.EditorText:=DBObject.Description;
  EditorFrame.Modified:=false;
end;

procedure TfbmObjectEditorDescriptionFrame.DeActivate;
begin
  if EditorFrame.Modified then
  begin
    DBObject.Description:=EditorFrame.EditorText;
    EditorFrame.Modified:=false;
  end;
end;

function TfbmObjectEditorDescriptionFrame.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaCompile:DeActivate;
    epaPrint:PrintPage;
  else
    exit;
  end;
end;

function TfbmObjectEditorDescriptionFrame.ActionEnabled(
  PageAction: TEditorPageAction): boolean;
begin
  Result := PageAction in [epaPrint, epaCompile];
end;

constructor TfbmObjectEditorDescriptionFrame.CreatePage(TheOwner: TComponent;
  ADBObject :TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);

  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=Self;

  Activate;

  UpdateEnvOptions;
end;

procedure TfbmObjectEditorDescriptionFrame.Localize;
begin
  inherited Localize;
end;

function TfbmObjectEditorDescriptionFrame.SetupSQLObject(
  ASQLObject: TSQLCommandDDL): boolean;
begin
  if ASQLObject is TSQLCommandDDL then
  begin
    TSQLCommandDDL(ASQLObject).Description:=EditorFrame.EditorText;
    Result:=true;
  end
  else
  begin
    Result:=false;
    ErrorBox('TfbmObjectEditorDescriptionFrame.SetupSQLObject');
  end;

end;

end.

