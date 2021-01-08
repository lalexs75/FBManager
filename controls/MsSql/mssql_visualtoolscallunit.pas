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

unit mssql_VisualToolsCallUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLEngineAbstractUnit, mssql_engine, fbm_VisualEditorsAbstractUnit, SynHighlighterSQL, Forms,
  fdbm_PagedDialogPageUnit, cfAbstractConfigFrameUnit;

type

  { TMSSQLVisualTools }

  TMSSQLVisualTools = class(TDBVisualTools)
  private
    //procedure tlsShowTdsCfgManagerExecute(Sender: TObject);
  protected
    constructor Create(ASQLEngine:TSQLEngineAbstract);override;
    procedure InitSQLSyn(const ASynSQLSyn: TSynSQLSyn);override;

    class function ConnectionDlgPageCount:integer;override;
    class function ConnectionDlgPage(ASQLEngine:TSQLEngineAbstract; APageNum:integer; AOwner:TForm):TPagedDialogPage;override;

    class function ConfigDlgPageCount:integer;override;
    class function ConfigDlgPage(APageNum:integer; AOwner:TForm):TFBMConfigPageAbstract;override;
    class function GetMenuItems(Index: integer): TMenuItemRec; override;
    class function GetMenuItemCount:integer; override;

    class function GetObjTemplatePagesCount: integer;override;
    class function GetObjTemplate(Index: integer; Owner:TComponent): TFBMConfigPageAbstract;override;

    class function GetCreateObject:TSQLEngineCreateDBAbstractClass; override;
  end;

implementation
uses fbmStrConstUnit,
  cf_mssql_mainUnit, fdbm_cf_LogUnit, fdbm_DescriptionUnit,
  fbmTableEditorFieldsUnit,
  fbmObjectEditorDescriptionUnit,
  fbmTableEditorDataUnit,
  fbmTableStatisticUnit,
  fbmDDLPageUnit,
  fbmViewEditorMainUnit;

{ TMSSQLVisualTools }

constructor TMSSQLVisualTools.Create(ASQLEngine: TSQLEngineAbstract);
begin
  inherited Create(ASQLEngine);


  RegisterObjEditor(TMSSQLTable,
    [TfbmTableEditorFieldsFrame, TfbmObjectEditorDescriptionFrame],
    [TfbmTableEditorFieldsFrame, TfbmTableEditorDataFrame,
     {TfdbmTableEditorPKListFrame,
     TfdbmTableEditorForeignKeyFrame,
     TfdbmTableEditorUniqueFrame,
     TfbmpgTableCheckConstaintPage,
     TfbmTableEditorIndexFrame,
     TfbmTableEditorTriggersFrame,
     TDependenciesFrame,
     TfbmpgACLEditEditor,}
     TfbmObjectEditorDescriptionFrame,
     TfbmTableStatisticFrame,
     TfbmDDLPage]);

  RegisterObjEditor(TMSSQLView,
    [TfbmViewEditorMainFrame, TfbmObjectEditorDescriptionFrame],
    [TfbmViewEditorMainFrame, TfbmTableEditorFieldsFrame, TfbmTableEditorDataFrame,
     {TfbmTableEditorTriggersFrame, TDependenciesFrame, TfbmpgACLEditEditor, }TfbmObjectEditorDescriptionFrame,
     TfbmTableStatisticFrame, TfbmDDLPage]);
end;

procedure TMSSQLVisualTools.InitSQLSyn(const ASynSQLSyn: TSynSQLSyn);
begin

end;

class function TMSSQLVisualTools.ConnectionDlgPageCount: integer;
begin
  Result:=3;
end;

class function TMSSQLVisualTools.ConnectionDlgPage(
  ASQLEngine: TSQLEngineAbstract; APageNum: integer; AOwner: TForm
  ): TPagedDialogPage;
begin
  case APageNum of
    0:Result:=Tcf_mssql_main_frame.Create(ASQLEngine, AOwner);
    1:Result:=TfdbmCFLogFrame.Create(ASQLEngine, AOwner);
//    2:Result:=Tfdbm_ShowObjectsPage.Create(ASQLEngine, AOwner);
//    3:Result:=Tpg_con_EditorPrefPage.Create(ASQLEngine as TSQLEnginePostgre, AOwner);
//    4:Result:=Tfdbm_ssh_ParamsPage.Create(ASQLEngine, AOwner);
    2:Result:=Tfdbm_DescriptionConnectionDlgPage.CreateDescriptionPage(ASQLEngine, AOwner);
  else
    Result:=nil;
  end;
end;

class function TMSSQLVisualTools.ConfigDlgPageCount: integer;
begin
  Result:=inherited ConfigDlgPageCount;
end;

class function TMSSQLVisualTools.ConfigDlgPage(APageNum: integer; AOwner: TForm
  ): TFBMConfigPageAbstract;
begin
  Result:=nil;
end;

class function TMSSQLVisualTools.GetMenuItems(Index: integer): TMenuItemRec;
begin
//  Result:=nil;
end;

class function TMSSQLVisualTools.GetMenuItemCount: integer;
begin
  Result:=inherited GetMenuItemCount;
end;

class function TMSSQLVisualTools.GetObjTemplatePagesCount: integer;
begin
  Result:=inherited GetObjTemplatePagesCount;
end;

class function TMSSQLVisualTools.GetObjTemplate(Index: integer;
  Owner: TComponent): TFBMConfigPageAbstract;
begin
  Result:=nil;
end;

class function TMSSQLVisualTools.GetCreateObject: TSQLEngineCreateDBAbstractClass;
begin
  Result:=nil;
end;

initialization
  RegisterSQLEngine(TMSSQLEngine, TMSSQLVisualTools, sMSSQLServer);
end.

