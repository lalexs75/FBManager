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

unit fbmRefreshObjTreeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fbmSqlParserUnit, ibmanagertypesunit, sqlObjects;

type
  TObjRec = class
    SchemaName:string;
    ObjName:string;
    ObjectKind:TDBObjectKind;
  end;

  { TObjList }

  TObjList = class
  private
    FList:TFPList;
    function GetCount: integer;
    function GetItem(AIndex: Integer): TObjRec;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Add(ASchemaName, AObjName: string; AObjectKind: TDBObjectKind ): TObjRec;
    function Find(ASchemaName, AObjName: string; AObjectKind: TDBObjectKind ): TObjRec;
    property Item[AIndex:Integer]:TObjRec read GetItem; default;
    property Count:integer read GetCount;
  end;

  { TObjTreeRefresh }

  TObjTreeRefresh = class
  private
    FDataBase: TDataBaseRecord;
    FList:TObjList;
  public
    constructor Create(ADataBase:TDataBaseRecord);
    destructor Destroy; override;
    procedure ProcessCommand(ACmd:TSQLCommandAbstract);
    procedure Execute;

  end;

implementation

{ TObjList }

function TObjList.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TObjList.GetItem(AIndex: Integer): TObjRec;
begin
  Result:=TObjRec(FList[AIndex]);
end;

constructor TObjList.Create;
begin
  inherited Create;
  FList:=TFPList.Create;
end;

destructor TObjList.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TObjList.Clear;
var
  I: Integer;
begin
  for I:=0 to FList.Count-1 do
    TObjRec(FList[I]).Free;
  FList.Clear;
end;

function TObjList.Add(ASchemaName, AObjName:string; AObjectKind:TDBObjectKind): TObjRec;
begin
  Result:=TObjRec.Create;
  FList.Add(Result);
  Result.SchemaName:=ASchemaName;
  Result.ObjName:=AObjName;
  Result.ObjectKind:=AObjectKind;
end;

function TObjList.Find(ASchemaName, AObjName: string; AObjectKind: TDBObjectKind
  ): TObjRec;
var
  i: Integer;
  P: TObjRec;
begin
  Result:=nil;
  for i:=0 to FList.Count-1 do
  begin
    P:=TObjRec(FList[i]);
    if (P.SchemaName=ASchemaName) and (P.ObjName=AObjName) and (P.ObjectKind=AObjectKind) then
      Exit(P)
  end;
end;

{ TObjTreeRefresh }

constructor TObjTreeRefresh.Create(ADataBase: TDataBaseRecord);
begin
  inherited Create;
  FDataBase:=ADataBase;
  FList:=TObjList.Create;
end;

destructor TObjTreeRefresh.Destroy;
begin
  FreeAndNil(FList);
  inherited Destroy;
end;

type
  TMySQLCommandDDL = class(TSQLCommandDDL);

procedure TObjTreeRefresh.ProcessCommand(ACmd: TSQLCommandAbstract);
var
  P: TMySQLCommandDDL;
begin
  if not ((ACmd is TSQLCreateCommandAbstract) or ((ACmd is TSQLDropCommandAbstract))) then Exit;
  P:=TMySQLCommandDDL(ACmd);
  if not Assigned(FList.Find(P.SchemaName, P.Name, P.ObjectKind)) then
    FList.Add(P.SchemaName, P.Name, P.ObjectKind);
end;


procedure TObjTreeRefresh.Execute;
begin

end;

end.

