{ Free DB Manager

  Copyright (C) 2005-2024 Lagunov Aleksey  alexs75 at yandex.ru

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


unit fbmMakeSQLFromDataSetUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, DB, DBGrids, sqlEngineTypes;

function MakeSQLInsert(ADataSet:TDataSet;const ATableName:string; ASelectedRows: TBookmarkList):string;
function MakeSQLUpdate(ADataSet:TDataSet;const ATableName, APKFields:string; ASelectedRows: TBookmarkList):string;
function MakeSQLUpdateOrInsert(ADataSet:TDataSet;const ATableName, APKFields:string; ASelectedRows: TBookmarkList; AExportEngine:TExportEngine):string;

function MakeRowInsert(ADataSet:TDataSet; const ATableName:string):string;
implementation
uses
  strutils, rxstrutils, fbmToolsNV;

function FieldValueStr(F: TField):string;
begin
  if F.IsNull then
    Result:='null'
  else
  if F.DataType in [ftString, ftTime, ftDate, ftDateTime, ftMemo] then
    Result:=QuotedString(F.AsString, '''')
  else
  if F.DataType in [ftFloat, ftExtended, ftSingle, ftFMTBcd, ftCurrency, ftBCD] then
   Result:=FloatToStrEx(F.AsFloat)
  else
    Result:=F.AsString;
end;

function DoMakeHeader(ADataSet:TDataSet; ATableName:string):string;
var
  i:integer;
begin
  Result:='';
  for i:=0 to ADataSet.Fields.Count - 1 do
  begin
    if Result<>'' then
      Result := Result + ', ';
    Result := Result + ADataSet.Fields[i].FieldName;
  end;
  Result:='insert into '+ATableName + '('+Result+')'+LineEnding+'values (%s);'+LineEnding;
end;


function MakeSQLInsert(ADataSet: TDataSet; const ATableName: string;
  ASelectedRows: TBookmarkList): string;

function DoExportRow(const AFields:string):string;
var
  i:integer;
begin
  Result:='';
  for i:=0 to ADataSet.Fields.Count - 1 do
  begin
    if Result <> '' then
      Result := Result + ', ';
    Result:=Result + FieldValueStr(ADataSet.Fields[i]);
  end;
  Result:=Format(AFields, [Result]);
end;

var
  FFields: String;
  B, B1: TBookMark;
begin
  Result:='';
  if not Assigned(ADataSet) then Exit;

  FFields:=DoMakeHeader(ADataSet, ATableName);
  ADataSet.DisableControls;
  B:=ADataSet.Bookmark;

  if Assigned(ASelectedRows) and (ASelectedRows.Count>1) then
  begin
   for B1 in ASelectedRows do
   begin
     ADataSet.Bookmark:=B1;
     Result:=Result + DoExportRow(FFields);
   end;
  end
  else
  begin
    ADataSet.First;
    while not ADataSet.EOF do
    begin
      Result:=Result + DoExportRow(FFields);
      ADataSet.Next;
    end;
  end;
  ADataSet.Bookmark:=B;
  ADataSet.EnableControls;
end;

function MakeSQLUpdate(ADataSet: TDataSet; const ATableName, APKFields: string;
  ASelectedRows: TBookmarkList): string;

function DoMakeHeader(ATableName:string):string;
begin
  Result:='update'+LineEnding +'  ' +ATableName + LineEnding + 'set' + LineEnding;
end;

function DoExportRow( const AHeader:string):string;
var
  F: TField;
begin
  Result:='';
  for F in ADataSet.Fields do
  begin
    if CompareText(F.FieldName, APKFields)<>0 then
    begin
      if Result<>'' then
        Result:=Result + ',' + LineEnding;

      Result:=Result + '  ' + F.FieldName + ' = ' + FieldValueStr(F);
    end;
  end;
  F:=ADataSet.FieldByName(APKFields);
  Result:=AHeader + Result + LineEnding + 'where' + LineEnding + '  ' + F.FieldName + ' = ' + FieldValueStr(F) + ';' + LineEnding;
end;

var
  AHeader: String;
  B, B1: TBookMark;
begin
  Result:='';
  if not Assigned(ADataSet) then Exit;

  AHeader:=DoMakeHeader(ATableName);
  ADataSet.DisableControls;
  B:=ADataSet.Bookmark;

  if Assigned(ASelectedRows) and (ASelectedRows.Count>1) then
  begin
   for B1 in ASelectedRows do
   begin
     ADataSet.Bookmark:=B1;
     Result:=Result + DoExportRow(AHeader);
   end;
  end
  else
  begin
    ADataSet.First;
    while not ADataSet.EOF do
    begin
      Result:=Result + DoExportRow(AHeader);
      ADataSet.Next;
    end;
  end;
  ADataSet.Bookmark:=B;
  ADataSet.EnableControls;
end;

function MakeSQLUpdateOrInsert(ADataSet: TDataSet; const ATableName,
  APKFields: string; ASelectedRows: TBookmarkList; AExportEngine: TExportEngine
  ): string;
begin

{
insert into system.sys_client(sys_client_id, sys_client_src, sys_client_code, sys_client_name, sys_client_inn, sys_client_org_type, sys_client_adress, sys_client_closed, sys_client_phone, sys_client_email_for_check)
values (-2, -1, 0, 'Юридические лица согласно реестра', '', 2, null, null, null, null)
ON CONFLICT (sys_client_id) DO
UPDATE
SET
 sys_client_name = 'Юридические лица согласно реестра'
WHERE sys_client.sys_client_id  = -2;


}
end;

function MakeRowInsert(ADataSet: TDataSet; const ATableName: string): string;
var
  i:integer;
  FFields: String;
begin
  Result:='';
  FFields:=DoMakeHeader(ADataSet, ATableName);
  for i:=0 to ADataSet.Fields.Count - 1 do
  begin
    if Result <> '' then
      Result := Result + ', ';
    Result:=Result + FieldValueStr(ADataSet.Fields[i]);
  end;
  Result:=Format(FFields, [Result]);
end;

end.

