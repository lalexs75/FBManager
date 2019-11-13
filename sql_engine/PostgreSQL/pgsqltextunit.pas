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

unit pgSqlTextUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, StrHolder, RxTextHolder, SQLEngineAbstractUnit;

type

  { TpgSqlTextModule }

  TpgSqlTextModule = class(TDataModule)
    pgFServRefresh: TStrHolder;
    pgFSUserMapRefresh: TStrHolder;
    pgFTsParsers: TRxTextHolder;
    sPgConstraints: TRxTextHolder;
    sPGIndex: TRxTextHolder;
    sPGTableInerited: TRxTextHolder;
    sPGRelation: TRxTextHolder;
    sPGRelationFields: TRxTextHolder;
    sPGTriggersList: TRxTextHolder;
    sPGClass: TRxTextHolder;
    sPGForeignTable: TRxTextHolder;
    sPGForeignData: TRxTextHolder;
    sqlPGFuntions: TRxTextHolder;
    sPGSystem: TRxTextHolder;
    sql_PG_LangList: TRxTextHolder;
    sqlTableSpaces: TRxTextHolder;
    sForeignObj: TRxTextHolder;
    sPGStatistics: TRxTextHolder;
    sPGGroups1: TStrHolder;
    sPGUsers: TStrHolder;
    sqlEventTrigger: TStrHolder;
    sqlSchemasAll: TStrHolder;
    sqlSequence_v10: TStrHolder;
    sqlTypesList: TStrHolder;
    sqlTrigger: TStrHolder;
    sqlIndexTable: TStrHolder;
    sqlPgDepends: TStrHolder;
    sqlPgGetACLParams: TStrHolder;
    sqlPGUserGroupGrants: TStrHolder;
    sql_PG_DomainRefresh: TStrHolder;
    sql_Pg_Rules: TStrHolder;
    sql_Pg_Rule: TStrHolder;
    sql_PG_TypesListAll: TStrHolder;
    sql_PG_ViewRefresh: TStrHolder;
    sqlSchema: TStrHolder;
    sqlSequence: TStrHolder;
    sqlEventTriggers: TStrHolder;
    sPGGroups: TStrHolder;
    sPGRoleParams: TStrHolder;
    sPGTasks: TStrHolder;
    pgFtsConfigs: TStrHolder;
    pgFtsDicts: TStrHolder;
    pgFtsTempl: TStrHolder;
    pgExtensions: TStrHolder;
    pgCollations: TStrHolder;
    pgExtension: TStrHolder;
    pgFSUserMapping: TStrHolder;
    ttt1: TStrHolder;
    pgFtsConfig: TStrHolder;
  private
    { private declarations }
  public
    function PGClassStr(ASQLEngine:TSQLEngineAbstract):string;
    function PGLanguageList(ASQLEngine:TSQLEngineAbstract):string;
    function PGTriggersList(ASQLEngine:TSQLEngineAbstract):string;
    function PGRelationStr(ASQLEngine:TSQLEngineAbstract):string;
    function PGRelationInheritedStr(ASQLEngine:TSQLEngineAbstract):string;
    function PGIndexFieldsStr(ASQLEngine:TSQLEngineAbstract):string;
  end;


function pgSqlTextModule: TpgSqlTextModule;
implementation
uses CustApp, PostgreSQLEngineUnit;

var
  FpgSqlTextModule: TpgSqlTextModule = nil;

  function pgSqlTextModule: TpgSqlTextModule;
begin
  if not Assigned(FpgSqlTextModule) then
    FpgSqlTextModule:=TpgSqlTextModule.Create(CustomApplication);
  Result:=FpgSqlTextModule;
end;

{$R *.lfm}

  { TpgSqlTextModule }

function TpgSqlTextModule.PGClassStr(ASQLEngine: TSQLEngineAbstract): string;
begin
  if TSQLEnginePostgre(ASQLEngine).RealServerVersionMajor >= 10 then
    Result:=sPGClass['pgClass10']
  else
    Result:=sPGClass['pgClass'];
end;

function TpgSqlTextModule.PGLanguageList(ASQLEngine: TSQLEngineAbstract
  ): string;
begin
  if TSQLEnginePostgre(ASQLEngine).RealServerVersionMajor < 9 then
    Result:=sql_PG_LangList['sql_PG_LangList_v8']
  else
    Result:=sql_PG_LangList['sql_PG_LangList'];
end;

function TpgSqlTextModule.PGTriggersList(ASQLEngine: TSQLEngineAbstract
  ): string;
begin
  if (TSQLEnginePostgre(ASQLEngine).RealServerVersion >= 00090004) then
    Result:=sPGTriggersList['sPGTriggerList9_4']
  else
  if (TSQLEnginePostgre(ASQLEngine).RealServerVersionMajor >= 0009) then
    Result:=sPGTriggersList['sPGTriggerList9_4']
  else
    Result:=sPGTriggersList['sPGTriggerList8_0']
end;

function TpgSqlTextModule.PGRelationStr(ASQLEngine: TSQLEngineAbstract): string;
begin
  if TSQLEnginePostgre(ASQLEngine).RealServerVersionMajor >= 10 then
    Result:=sPGRelation['sqlPGRelation10']
  else
    Result:=sPGRelation['sqlPGRelation'];
end;

function TpgSqlTextModule.PGRelationInheritedStr(ASQLEngine: TSQLEngineAbstract
  ): string;
begin
  if TSQLEnginePostgre(ASQLEngine).RealServerVersionMajor >= 10 then
    Result:=sPGTableInerited['sTableInerited10']
  else
    Result:=sPGTableInerited['sTableInerited'];
end;

function TpgSqlTextModule.PGIndexFieldsStr(ASQLEngine: TSQLEngineAbstract
  ): string;
begin
  if TSQLEnginePostgre(ASQLEngine).RealServerVersionMajor >= 11 then
    Result:=sPGIndex['sqlIndexFields_11']
  else
    Result:=sPGIndex['sqlIndexFields'];
end;

end.

