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

unit dbf_visualtoolscallunit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, dbf_engineunit, SQLEngineAbstractUnit, Forms, SynHighlighterSQL,
  fbm_VisualEditorsAbstractUnit, fdbm_PagedDialogPageUnit,  cfAbstractConfigFrameUnit;

type

  { TDBFVisualTools }

  TDBFVisualTools = class(TDBVisualTools)
  private
  protected
  public
    constructor Create(ASQLEngine:TSQLEngineAbstract);override;
    procedure InitSQLSyn(const ASynSQLSyn: TSynSQLSyn);override;

    class function ConnectionDlgPageCount:integer;override;
    class function ConnectionDlgPage(ASQLEngine:TSQLEngineAbstract; APageNum:integer; AOwner:TForm):TPagedDialogPage; override;

    class function GetMenuItems(Index: integer): TMenuItemRec; override;
    class function GetMenuItemCount:integer; override;
    class function ConfigDlgPageCount:integer;override;
    class function ConfigDlgPage(APageNum:integer; AOwner:TForm):TFBMConfigPageAbstract; override;
    class function GetCreateObject:TSQLEngineCreateDBAbstractClass; override;
  end;

implementation
uses fbmStrConstUnit, fbmTableEditorFieldsUnit, fbmTableEditorDataUnit, fbmTableEditorIndexUnit,
  fdbm_cf_DbfMainUnit, fdbm_cf_LogUnit, fdbm_ShowObjectsUnit;

{ TDBFVisualTools }

constructor TDBFVisualTools.Create(ASQLEngine: TSQLEngineAbstract);
begin
  inherited Create(ASQLEngine);

  RegisterObjEditor(TDbfTable,
    [TfbmTableEditorFieldsFrame, TfbmTableEditorDataFrame, TfbmTableEditorIndexFrame],
    [TfbmTableEditorFieldsFrame, TfbmTableEditorDataFrame, TfbmTableEditorIndexFrame]);

end;

procedure TDBFVisualTools.InitSQLSyn(const ASynSQLSyn: TSynSQLSyn);
begin
  //
end;

class function TDBFVisualTools.ConnectionDlgPageCount: integer;
begin
  Result:=3;
end;

class function TDBFVisualTools.ConnectionDlgPage(
  ASQLEngine: TSQLEngineAbstract; APageNum: integer; AOwner: TForm
  ): TPagedDialogPage;
begin
  case APageNum of
    0:Result:=TfdbmCFDbfMainFrame.Create(ASQLEngine as TDBFEngine, AOwner);
    1:Result:=TfdbmCFLogFrame.Create(ASQLEngine, AOwner);
    2:Result:=Tfdbm_ShowObjectsPage.Create(ASQLEngine, AOwner);
  else
    Result:=nil;
  end;
end;

class function TDBFVisualTools.GetMenuItems(Index: integer): TMenuItemRec;
begin
  //Result:=0;
end;

class function TDBFVisualTools.GetMenuItemCount: integer;
begin
  Result:=0;
end;

class function TDBFVisualTools.ConfigDlgPageCount: integer;
begin
  Result:=0;
end;

class function TDBFVisualTools.ConfigDlgPage(APageNum: integer; AOwner: TForm
  ): TFBMConfigPageAbstract;
begin

end;

class function TDBFVisualTools.GetCreateObject: TSQLEngineCreateDBAbstractClass;
begin
  Result:=nil;
end;

initialization
  RegisterSQLEngine(TDBFEngine, TDBFVisualTools, sDBFFiles);
end.

