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

unit sqlite3_keywords;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, DB, SQLEngineCommonTypesUnit;

function CreateSQLite3KeyWords:TKeywordList;
function CreateSQLiteKeyFunctions:TKeywordList;
procedure FillFieldTypes(Items:TDBMSFieldTypeList);

implementation

type
  TKeywordRecords = array of string;

function CreateSQLite3KeyWords: TKeywordList;
var
  FKeysW : TKeywordRecords;
  S: String;
begin
  FKeysW := TKeywordRecords.Create
    (
{    'CHAR',
    'VARCHAR',
    'TINYTEXT',
    'TEXT',
    'MEDIUMTEXT',
    'LONGTEXT',
    'NCHAR',
    'NVARCHAR',
    'CLOB',
    'TINYINT',
    'SMALLINT',
    'MEDIUMINT',
    'INT',
    'INTEGER',
    'BIGINT',
    'INT2',
    'INT4',
    'INT8',
    'LONG',
    'NUMERIC',
    'DECIMAL',
    'REAL',
    'DOUBLE',
    'PRECISION',
    'FLOAT',
    'BOOLEAN',
    'DATE',
    'DATETIME',
    'TIMESTAMP',
    'TIME',
    'BLOB',}

    'ABORT',
    'ACTION',
    'ADD',
    'AFTER',
    'ALL',
    'ALTER',
    'ANALYZE',
    'AND',
    'AS',
    'ASC',
    'ATTACH',
    'AUTOINCREMENT',
    'BEFORE',
    'BEGIN',
    'BETWEEN',
    'BY',
    'CASCADE',
    'CASE',
    'CAST',
    'CHECK',
    'COLLATE',
    'COLUMN',
    'COMMIT',
    'CONFLICT',
    'CONSTRAINT',
    'CREATE',
    'CROSS',
    'CURRENT_DATE',
    'CURRENT_TIME',
    'CURRENT_TIMESTAMP',
    'DATABASE',
    'DEFAULT',
    'DEFERRABLE',
    'DEFERRED',
    'DELETE',
    'DESC',
    'DETACH',
    'DISTINCT',
    'DROP',
    'EACH',
    'ELSE',
    'END',
    'ESCAPE',
    'EXCEPT',
    'EXCLUSIVE',
    'EXISTS',
    'EXPLAIN',
    'FAIL',
    'FOR',
    'FOREIGN',
    'FROM',
    'FULL',
    'GLOB',
    'GROUP',
    'HAVING',
    'IF',
    'IGNORE',
    'IMMEDIATE',
    'IN',
    'INDEX',
    'INDEXED',
    'INITIALLY',
    'INNER',
    'INSERT',
    'INSTEAD',
    'INTERSECT',
    'INTO',
    'IS',
    'ISNULL',
    'JOIN',
    'KEY',
    'LEFT',
    'LIKE',
    'LIMIT',
    'MATCH',
    'NATURAL',
    'NO',
    'NOT',
    'NOTNULL',
    'NULL',
    'OF',
    'OFFSET',
    'ON',
    'OR',
    'ORDER',
    'OUTER',
    'PLAN',
    'PRAGMA',
    'PRIMARY',
    'PRIMARY',
    'QUERY',
    'RAISE',
    'RECURSIVE',
    'REFERENCES',
    'REGEXP',
    'REINDEX',
    'RELEASE',
    'RENAME',
    'REPLACE',
    'RESTRICT',
    'RIGHT',
    'ROLLBACK',
    'ROW',
    'ROWID',
    'SAVEPOINT',
    'SELECT',
    'SET',
    'TABLE',
    'TEMP',
    'TEMPORARY',
    'THEN',
    'TO',
    'TRANSACTION',
    'TRIGGER',
    'UNION',
    'UNIQUE',
    'UPDATE',
    'USING',
    'VACUUM',
    'VALUES',
    'VIEW',
    'VIRTUAL',
    'WHEN',
    'WHERE',
    'WITH',
    'WITHOUT'
    );

  Result:=TKeywordList.Create(ktKeyword);
  for S in FKeysW do
    Result.Add(S, stKeyword);
end;

function CreateSQLiteKeyFunctions: TKeywordList;
var
  FKeysW : TKeywordRecords;
  S: String;
begin
  FKeysW := TKeywordRecords.Create
    ('abs',
     'changes',
     'char',
     'coalesce',
     'glob',
     'hex',

     'ifnull',
     'instr',
     'last_insert_rowid',
     'length',
     'like',

     'likelihood',
     'likely',
     'load_extension',
     'lower',
     'ltrim',

     'ltrim',
     'max',
     'min',
     'nullif',
     'printf',
     'quote',

     'random',
     'randomblob',
     'replace',
     'round',
     'rtrim',

     'soundex',
     'sqlite_compileoption_get',
     'sqlite_compileoption_used',
     'sqlite_offset',
     'sqlite_source_id',

     'sqlite_version',
     'substr',
     'total_changes',
     'trim',

     'typeof',
     'unicode',
     'unlikely',
     'upper',
     'zeroblob',

     'avg',
     'count',
     'count',
     'group_concat',
     'group_concat',
     'max',
     'min',
     'sum',
     'total',

     'date',
     'time',
     'datetime',
     'julianday',
     'strftime'
  );
  Result:=TKeywordList.Create(ktFunction);
  for S in FKeysW do
    Result.Add(S, stIdentificator);
end;

procedure FillFieldTypes(Items: TDBMSFieldTypeList);
begin
  Items.Add('CHAR', 1, true, false, ftString, '', '', tgCharacterTypes);
  Items.Add('VARCHAR', 1, true, false, ftString, '', '', tgCharacterTypes);
  Items.Add('TINYTEXT', 1, true, false, ftString, '', '', tgCharacterTypes);
  Items.Add('TEXT', 1, true, false, ftString, '', '', tgCharacterTypes);
  Items.Add('MEDIUMTEXT', 1, true, false, ftString, '', '', tgCharacterTypes);
  Items.Add('LONGTEXT', 1, true, false, ftString, '', '', tgCharacterTypes);
  Items.Add('NCHAR', 1, true, false, ftString, '', '', tgCharacterTypes);
  Items.Add('NVARCHAR', 1, true, false, ftString, '', '', tgCharacterTypes);
  Items.Add('CLOB', 1, true, false, ftString, '', '', tgCharacterTypes);

  Items.Add('TINYINT', 2, false, false, ftInteger, '', '', tgNumericTypes);
  Items.Add('SMALLINT', 2, false, false, ftInteger, 'SMALL INT', '', tgNumericTypes);
  Items.Add('MEDIUMINT', 2, false, false, ftInteger, '', '', tgNumericTypes);
  Items.Add('INT', 2, false, false, ftInteger, '', '', tgNumericTypes);
  Items.Add('INTEGER', 2, false, false, ftInteger, 'UNSIGNED'#13'SIGNED'#13'SIGNED INTEGER'#13'UNSIGNED INTEGER', '', tgNumericTypes);
  Items.Add('BIGINT', 2, false, false, ftInteger, '', '', tgNumericTypes);
  Items.Add('INT2', 2, false, false, ftInteger, '', '', tgNumericTypes);
  Items.Add('INT4', 2, false, false, ftInteger, '', '', tgNumericTypes);
  Items.Add('INT8', 2, false, false, ftInteger, '', '', tgNumericTypes);
  Items.Add('LONG', 2, false, false, ftInteger, '', '', tgNumericTypes);
  Items.Add('NUMERIC', 2, true, true, ftFloat, '', '', tgNumericTypes);
  Items.Add('DECIMAL', 2, true, true, ftFloat, '', '', tgNumericTypes);
  Items.Add('REAL', 2, false, false, ftFloat, '', '', tgNumericTypes);
  Items.Add('DOUBLE', 2, false, false, ftFloat, '', '', tgNumericTypes);
  Items.Add('DOUBLE PRECISION', 2, false, false, ftFloat, '', '', tgNumericTypes);
  Items.Add('FLOAT', 2, false, false, ftFloat, '', '', tgNumericTypes);

  Items.Add('BOOLEAN',3, false, false, ftBoolean, '', '', tgBooleanTypes);

  Items.Add('DATE', 4, false, false, ftDateTime, '', '', tgDateTimeTypes);
  Items.Add('DATETIME', 4, false, false, ftDateTime, '', '', tgDateTimeTypes);
  Items.Add('TIMESTAMP', 4, false, false, ftDateTime, '', '', tgDateTimeTypes);
  Items.Add('TIME', 4, false, false, ftDateTime, '', '', tgDateTimeTypes);

  Items.Add('BLOB', 5, false, false, ftBlob, '', '', tgBinaryDataTypes);
end;

end.

