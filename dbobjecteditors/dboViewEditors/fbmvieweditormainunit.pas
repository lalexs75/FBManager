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

unit fbmViewEditorMainUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, SynEdit, LMessages,
  fdmAbstractEditorUnit, SQLEngineAbstractUnit, fbmToolsUnit,
  fdbm_SynEditorUnit, fbmSqlParserUnit, sqlObjects;

type

  { TfbmViewEditorMainFrame }

  TfbmViewEditorMainFrame = class(TEditorPage)
  private
    EditorFrame:Tfdbm_SynEditorFrame;
    function DoMetod(PageAction: TEditorPageAction): boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    procedure PrintPage;
    procedure RefreshData;
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses rxAppUtils, fbmStrConstUnit, ibmanagertypesunit, LR_Class, IBManMainUnit;

{$R *.lfm}

{ TfbmViewEditorMainFrame }

function TfbmViewEditorMainFrame.PageName: string;
begin
  Result:=sSQL;
end;

function TfbmViewEditorMainFrame.DoMetod(PageAction:TEditorPageAction):boolean;
begin
  Result:=true;
  case PageAction of
    epaRefresh:RefreshData;
    epaPrint:PrintPage;
  end;
end;

function TfbmViewEditorMainFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaCompile, epaRefresh, epaPrint];
end;

procedure TfbmViewEditorMainFrame.PrintPage;
begin
  frVariables['DBClassTitle']:=DBObject.DBClassTitle;
  frVariables['ObjectName']:=DBObject.Caption;
  frVariables['ViewBody']:=EditorFrame.EditorText;
  fbManagerMainForm.LazReportPrint('DBObject_View');
end;

procedure TfbmViewEditorMainFrame.RefreshData;
begin
  EditorFrame.EditorText:=DBObject.DDLAlter;
end;

constructor TfbmViewEditorMainFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);

  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=Self;
  EditorFrame.SQLEngine:=DBObject.OwnerDB;

  RefreshData;
end;

function TfbmViewEditorMainFrame.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  P: TSQLParser;
begin
  if ASQLObject is TSQLCreateView then
  begin
    P:=TSQLParser.Create(EditorFrame.EditorText, DBObject.OwnerDB);
    try
      TSQLCreateView(ASQLObject).ParseSQL(P);
    finally
      P.Free;
    end;
    Result:=TSQLCreateView(ASQLObject).State = cmsNormal;
    if not Result then
    begin
      EditorFrame.TextEditor.CaretXY:=TSQLCreateView(ASQLObject).ErrorPosition;
      ErrorBox(TSQLCreateView(ASQLObject).ErrorMessage);
    end
    else
    if (DBObject.State <> sdboCreate) and (TSQLCreateView(ASQLObject).CreateMode = cmCreate) then
      TSQLCreateView(ASQLObject).Options := TSQLCreateView(ASQLObject).Options + [ooOrReplase];
  end
  else
    Result:=true;

end;

end.

