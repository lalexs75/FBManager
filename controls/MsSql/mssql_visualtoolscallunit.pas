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
  Classes, SysUtils, fbm_VisualEditorsAbstractUnit;

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

{ TMSSQLVisualTools }

constructor TMSSQLVisualTools.Create(ASQLEngine: TSQLEngineAbstract);
begin
  inherited Create(ASQLEngine);
end;

procedure TMSSQLVisualTools.InitSQLSyn(const ASynSQLSyn: TSynSQLSyn);
begin

end;

class function TMSSQLVisualTools.ConnectionDlgPageCount: integer;
begin
  Result:=inherited ConnectionDlgPageCount;
end;

class function TMSSQLVisualTools.ConnectionDlgPage(
  ASQLEngine: TSQLEngineAbstract; APageNum: integer; AOwner: TForm
  ): TPagedDialogPage;
begin

end;

class function TMSSQLVisualTools.ConfigDlgPageCount: integer;
begin
  Result:=inherited ConfigDlgPageCount;
end;

class function TMSSQLVisualTools.ConfigDlgPage(APageNum: integer; AOwner: TForm
  ): TFBMConfigPageAbstract;
begin

end;

class function TMSSQLVisualTools.GetMenuItems(Index: integer): TMenuItemRec;
begin

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

end;

class function TMSSQLVisualTools.GetCreateObject: TSQLEngineCreateDBAbstractClass;
begin

end;

end.

