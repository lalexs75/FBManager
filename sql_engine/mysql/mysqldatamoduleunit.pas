{ Free DB Manager

  Copyright (C) 2005-2023 Lagunov Aleksey  alexs75 at yandex.ru

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
unit mysqlDataModuleUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, StrHolder, mysql_types;

type

  { TMySqlDM }

  TMySqlDM = class(TDataModule)
    sqlCollations: TStrHolder;
    sqlProcedureParams: TStrHolder;
    sqlTableGrants: TStrHolder;
    sqlProcFuncGrants: TStrHolder;
    sqlUsers: TStrHolder;
    sqlProcedure: TStrHolder;
    sqlTables: TStrHolder;
    sqlCollumns: TStrHolder;
    sqlTable: TStrHolder;
    sqlCharSets: TStrHolder;
    sqlTriggers: TStrHolder;
    sqlTriggerParam: TStrHolder;
    sqlViews: TStrHolder;
    sqlView1: TStrHolder;
    sqlProcedures: TStrHolder;
    sqlTableConstrName: TStrHolder;
    sqlKeyFields: TStrHolder;
    sqlFKList: TStrHolder;
    sqlTableIndex: TStrHolder;
    sqlUser: TStrHolder;
  private
    { private declarations }
  public
    { public declarations }
  end;


function MySqlModule: TMySqlDM;

function MySQLVersionToStr(AVers:TMySQLServerVersion):string;
function MySQLStrToVersion(AStr:string):TMySQLServerVersion;
implementation
uses CustApp;

var
  MySqlDM: TMySqlDM = nil;

function MySqlModule: TMySqlDM;
begin
  if not Assigned(MySqlDM) then
    MySqlDM:=TMySqlDM.Create(CustomApplication);
  Result:=MySqlDM;
end;

function MySQLVersionToStr(AVers: TMySQLServerVersion): string;
begin
  Result:=MySQLServerVersionNames[AVers];
end;

function MySQLStrToVersion(AStr: string): TMySQLServerVersion;
var
  R: TMySQLServerVersion;
begin
  for R in TMySQLServerVersion do
    if CompareText(MySQLServerVersionNames[R], AStr)=0 then
      exit(R);
  Result:=myUnknow;
end;

{$R *.lfm}

{ TMySqlDM }

end.

