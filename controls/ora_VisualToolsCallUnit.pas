{ Free DB Manager

  Copyright (C) 2005-2018 Lagunov Aleksey  alexs75 at yandex.ru

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

unit ora_VisualToolsCallUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineAbstractUnit, OracleSQLEngine, Forms,
  fbm_VisualEditorsAbstractUnit, fdbm_PagedDialogPageUnit, SynHighlighterSQL,
  cfAbstractConfigFrameUnit;

type

   { TOracleVisualTools }

  TOracleVisualTools = class(TDBVisualTools)
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
uses   fbmStrConstUnit,
  fdbm_cf_LogUnit,
  fdbm_OraConnectionMainUnit,    //Форма нстройки подключения к серверу

  fbmTableEditorDataUnit,
  fbmTableEditorFieldsUnit
  ;


{ TOracleVisualTools }


class function TOracleVisualTools.GetCreateObject: TSQLEngineCreateDBAbstractClass;
begin
  Result:=nil;
end;

class function TOracleVisualTools.GetMenuItems(Index: integer): TMenuItemRec;
begin

end;

class function TOracleVisualTools.GetMenuItemCount: integer;
begin
  Result:=0;
end;

class function TOracleVisualTools.ConfigDlgPageCount: integer;
begin
  Result:=0;
end;

class function TOracleVisualTools.ConfigDlgPage(APageNum: integer;
  AOwner: TForm): TFBMConfigPageAbstract;
begin

end;

constructor TOracleVisualTools.Create(ASQLEngine: TSQLEngineAbstract);
begin
  inherited Create(ASQLEngine);
  RegisterObjEditor(TOraView,
    [TfbmTableEditorFieldsFrame, TfbmTableEditorDataFrame],
    [TfbmTableEditorFieldsFrame, TfbmTableEditorDataFrame]
    );

end;

procedure TOracleVisualTools.InitSQLSyn(const ASynSQLSyn: TSynSQLSyn);
begin
  ASynSQLSyn.SQLDialect:=sqlOracle;
end;

class function TOracleVisualTools.ConnectionDlgPageCount: integer;
begin
  Result:=2;
end;

class function TOracleVisualTools.ConnectionDlgPage(
  ASQLEngine: TSQLEngineAbstract; APageNum: integer; AOwner: TForm
  ): TPagedDialogPage;
begin
  case APageNum of
    0:Result:=TfdbmOraConnectionMainFrame.Create(ASQLEngine, AOwner);
    1:Result:=TfdbmCFLogFrame.Create(ASQLEngine, AOwner);
  else
    Result:=nil;
  end;
end;

initialization
  RegisterSQLEngine(TSQLEngineOracle, TOracleVisualTools, sOracleSQLServer);
end.

