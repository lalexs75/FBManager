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

unit pgSQLEngineFDW;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLEngineAbstractUnit, sqlObjects, PostgreSQLEngineUnit,
  fbmSqlParserUnit, SQLEngineInternalToolsUnit;

type

  { TPGForeignDataWrapperRoot }

  TPGForeignDataWrapperRoot = class(TPGDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
  public
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    destructor Destroy; override;
    procedure Clear;override;
    function GetObjectType: string;override;
  end;

  TPGForeignDataWrapper = class(TPGDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
  public
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    destructor Destroy; override;
    procedure Clear;override;
    function GetObjectType: string;override;
    procedure RefreshObject; override;
    class function DBClassTitle:string; override;
  end;

implementation
uses pg_SqlParserUnit, pgSqlTextUnit;

{ TPGForeignDataWrapper }

function TPGForeignDataWrapper.DBMSObjectsList: string;
begin
  Result:=inherited DBMSObjectsList;
end;

constructor TPGForeignDataWrapper.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
end;

destructor TPGForeignDataWrapper.Destroy;
begin
  inherited Destroy;
end;

procedure TPGForeignDataWrapper.Clear;
begin
  inherited Clear;
end;

function TPGForeignDataWrapper.GetObjectType: string;
begin
  Result:='Foreign data wrapper';
end;

procedure TPGForeignDataWrapper.RefreshObject;
begin
end;

class function TPGForeignDataWrapper.DBClassTitle: string;
begin
  Result:='Foreign data wrapper';
end;

{ TPGForeignDataWrapperRoot }

function TPGForeignDataWrapperRoot.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.pgFDW.Strings.Text;
end;

constructor TPGForeignDataWrapperRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okForeignDataWrapper;

  FDropCommandClass:=TPGSQLDropForeignDataWrapper;
end;

destructor TPGForeignDataWrapperRoot.Destroy;
begin
  inherited Destroy;
end;

procedure TPGForeignDataWrapperRoot.Clear;
begin
  inherited Clear;
end;

function TPGForeignDataWrapperRoot.GetObjectType: string;
begin
  Result:='Foreign data wrapper';
end;

end.

