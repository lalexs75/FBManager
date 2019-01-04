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

unit mssql_sql_lines_unit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineCommonTypesUnit, TDSCTDataBase;

const
  sql_MSSQL_TablesList = 'select '+
                         '  sys.tables.[name], '+
                         '  sys.tables.schema_id '+
                         'from '+
                         '  sys.tables '+
                         'order by '+
                         '  sys.tables.[name]';

  sql_MSSQL_ObjList =
{                         'select '+
                         '  sysobjects.id, '+
                         '  sysobjects.name, '+
                         '  sysobjects.uid '+
                         'from '+
                         '  sysobjects '+
                         'where '+
                         '  sysobjects.[type] = :ObjName '+
                         'order by '+
                         '  sysobjects.name';}

    'select '+
                         '  sys.all_objects.object_id, '+
                         '  sys.all_objects.[name], '+
                         '  sys.all_objects.schema_id '+
                         'from '+
                         '  sys.all_objects '+
                         'where '+
                         '    sys.all_objects.[type] = :ObjName '+
                         '  and '+
                         '    sys.all_objects.schema_id = :schema_id '+
                         'order by '+
                         '  sys.all_objects.[name]';
  sql_MSSQL_ObjListAll =
                         'select '+
                         '  sys.all_objects.object_id, '+
                         '  sys.all_objects.[name], '+
                         '  sys.all_objects.schema_id, '+
                         '  sys.all_objects.[type] '+
                         'from '+
                         '  sys.all_objects '+
                         'order by '+
                         '  sys.all_objects.[name]';

  sql_MSSQL_Schemas = 'select '+
                      '  sys.schemas.schema_id, '+
                      '  sys.schemas.[name] '+
                      'from '+
                      '  sys.schemas '+
                      'order by '+
                      '  sys.schemas.[name]';


const
  CountKeyWords      = 28;
  CountKeyFunctions  = 79;


type
  TKeywordRecord = record
    Key:string;
  end;

  TKeywordRecords = array [0..CountKeyWords-1] of TKeywordRecord;

const
  CTServerVersionStr : array [TCTServerVersion] of string =
    ('MS SQL 6.0', 'MS SQL 6.5', 'MS SQL 7.0', 'MS SQL 2000', 'MS SQL 2005', 'MS SQL 2008',
     'Sybase SQL 10', 'Sybase SQL 9.0');
//   (svMSSQL6, svMSSQL65, svMSSQL70,
//    svMSSQL2000, svMSSQL2005, svMSSQL2008, SybaseSQL10, SybaseSQL9);

function CreateMSSQLKeyWords:TKeywordList;
implementation

const
  MSSQLKeywords : TKeywordRecords =
    (
     (Key:'as'),
     (Key:'asc'),
     (Key:'ascending'),
     (Key:'begin'),
     (Key:'block'),
     (Key:'both'),
     (Key:'case'),
     (Key:'close'),
     (Key:'computed by'),
     (Key:'create'),
     (Key:'declare'),
     (Key:'distinct'),
     (Key:'desc'),
     (Key:'descending'),
     (Key:'execute'),
     (Key:'for'),
     (Key:'from'),
     (Key:'index'),
     (Key:'insensitive'),
     (Key:'numeric'),
     (Key:'on'),
     (Key:'select'),
     (Key:'sum'),
     (Key:'trailing'),
     (Key:'unique'),
     (Key:'using'),
     (Key:'variable'),
     (Key:'where')
     );

function CreateMSSQLKeyWords: TKeywordList;
var
  i:integer;
begin
  Result:=TKeywordList.Create(ktKeyword);
  for i:= 0 to CountKeyWords-1 do
    Result.WordList.Add(MSSQLKeywords[i].Key);
end;

end.

