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
unit fbmDDLPageUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs, 
    fdmAbstractEditorUnit, SQLEngineAbstractUnit, fdbm_SynEditorUnit;

type

  { TfbmDDLPage }

  TfbmDDLPage = class(TEditorPage)
  private
    EditorFrame:Tfdbm_SynEditorFrame;
    function DoMetod(PageAction: TEditorPageAction): boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    procedure PrintPage;
    procedure LoadPage;
    procedure UpdateEnvOptions;override;
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    procedure Activate;override;
    procedure Localize;override;
  end;

var
  fbmDDLPage: TfbmDDLPage;

implementation
uses fbmStrConstUnit, LR_Class, IBManMainUnit, DB;

{$R *.lfm}

{ TfbmDDLPage }

function TfbmDDLPage.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:PrintPage;
    epaRefresh:LoadPage;
  end;
end;

function TfbmDDLPage.ActionEnabled(PageAction: TEditorPageAction): boolean;
begin
  Result:=PageAction in [epaRefresh, epaPrint];
end;

procedure TfbmDDLPage.PrintPage;
begin
  frVariables['DBClassTitle']:=DBObject.DBClassTitle;
  frVariables['ObjectName']:=DBObject.Caption;
  frVariables['DDLBody']:=EditorFrame.EditorText;
  fbManagerMainForm.LazReportPrint('DBObject_DDL');
end;

procedure TfbmDDLPage.LoadPage;
begin
  EditorFrame.EditorText:=DBObject.DDLCreate;
end;

procedure TfbmDDLPage.UpdateEnvOptions;
begin
  EditorFrame.ChangeVisualParams;
end;

function TfbmDDLPage.PageName: string;
begin
  Result:=sDDL;
end;

constructor TfbmDDLPage.CreatePage(TheOwner: TComponent;
  ADBObject:TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);

  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=Self;
  EditorFrame.SQLEngine:=DBObject.OwnerDB;

  EditorFrame.TextEditor.ReadOnly:=true;
end;

procedure TfbmDDLPage.Activate;
begin
  LoadPage;
end;

procedure TfbmDDLPage.Localize;
begin
//
end;

end.

