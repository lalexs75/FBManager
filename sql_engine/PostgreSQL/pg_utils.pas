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

unit pg_utils;

{$I fbmanager_define.inc}

{.$Define LinkDynamically}

interface

uses
  Classes, SysUtils, contnrs, SQLEngineCommonTypesUnit, DB, PostgreSQLEngineUnit,
  SQLEngineAbstractUnit, sqlObjects, pgTypes;

procedure FillFieldTypes(Items:TDBMSFieldTypeList);
function ConvertFieldList(pgFieldList:string;const Obj:TDBDataSetObject):string;
function ParsePGArrayString(ArrayStr:string;const Items:TStrings):integer;
function ParsePGArrayChar(ArrayStr:string;out Items:TCharArray; ADelimiter:Char = ','):integer;
function ParsePGArrayInt(ArrayStr:string;out Items:TIntegerArray; ADelimiter:Char = ','):integer;
function ParsePGArrayByte(ArrayStr:string;out Items:TByteArray; ADelimiter:Char = ','):integer;

function StrToPGSPVolatCat(const S:string):TPGSPVolatCat;
//function PGFieldLoadMetaInfo(const Own:TDBDataSetObject; const FQuery:TDataSet):TPGField;

procedure FillPGVersion(const Items:TStrings);

//procedure ExecuteDirectPG(const QueryStr : string; const PQConnection:TPQConnection);

function PGClassTypeToDBObjectKind(const S:string):TDBObjectKind;
function PGConstraintTypeToDBObjectKind(const S: string): TDBObjectKind;

var
  pgShowTtablePartiotions : boolean = false;

implementation
uses strutils, fbmStrConstUnit, dbconst;


resourcestring
  s_pg_bigint =  'signed eight-byte integer';
  s_pg_bigserial = 'autoincrementing eight-byte integer';
  s_pg_bit = 'fixed-length bit string';
  s_pg_bit_varying = 'variable-length bit string';
  s_pg_boolean = 'logical Boolean (true/false)';
  s_pg_box = 'rectangular box on a plane';
  s_pg_bytea = 'binary data ("byte array")';
  s_pg_varchar = 'variable-length character string';
  s_pg_char = 'fixed-length character string';
  s_pg_cidr = 'IPv4 or IPv6 network address';
  s_pg_circle = 'circle on a plane';
  s_pg_date = 'calendar date (year, month, day)';
  s_pg_double_precision = 'double precision floating-point number (8 bytes)';
  s_pg_inet = 'IPv4 or IPv6 host address';
  s_pg_integer = 'signed four-byte integer';
  s_pg_interval = 'interval [ fields ] [ (p) ] - time span';
  s_pg_line = 'infinite line on a plane';
  s_pg_lseg = 'line segment on a plane';
  s_pg_macaddr = 'MAC (Media Access Control) address';
  s_pg_money = 'currency amount';
  s_pg_numeric = 'exact numeric of selectable precision';
  s_pg_path = 'geometric path on a plane';
  s_pg_point = 'geometric point on a plane';
  s_pg_polygon = 'closed geometric path on a plane';
  s_pg_real = 'single precision floating-point number (4 bytes)';
  s_pg_smallint = 'signed two-byte integer';
  s_pg_serial = 'autoincrementing four-byte integer';
  s_pg_text = 'variable-length character string';
  s_pg_time = 'time of day (no time zone)'; //time [ (p) ] [ without time zone ] ---- time of day (no time zone)
  s_pg_time_wtz = 'time of day, including time zone'; //time [ (p) ] with time zone -----time of day, including time zone
  s_pg_timestamp = 'date and time (no time zone)'; //timestamp [ (p) ] [ without time zone ] ---- date and time (no time zone)
  s_pg_timestamp_wtz = 'date and time, including time zone'; //timestamp [ (p) ] with time zone ---- date and time, including time zone
  s_pg_tsquery = 'text search query';
  s_pg_tsvector = 'text search document';
  s_pg_txid_snapshot = 'user-level transaction ID snapshot';
  s_pg_uuid = 'universally unique identifier';
  s_pg_XMLData = 'XML data';
  s_pg_UnknowData = 'Unknow data';

  s_pg_any = 'Indicates that a function accepts any input data type.';
  s_pg_anyarray = 'Indicates that a function accepts any array data type.';
  s_pg_anyelement = 'Indicates that a function accepts any data type.';
  s_pg_anyenum = 'Indicates that a function accepts any enum data type.';
  s_pg_anynonarray = 'Indicates that a function accepts any non-array data type.';
  s_pg_cstring = 'Indicates that a function accepts or returns a null-terminated C string.';
  s_pg_internal = 'Indicates that a function accepts or returns a server-internal data type.';
  s_pg_language_handler = 'A procedural language call handler is declared to return language_handler.';
  s_pg_record = 'Identifies a function returning an unspecified row type.';
  s_pg_trigger = 'A trigger function is declared to return trigger.';
  s_pg_void = 'Indicates that a function returns no value.';
  s_pg_opaque = 'An obsolete type name that formerly served all the above purposes.';

procedure FillFieldTypes(Items: TDBMSFieldTypeList);
begin
  Items.Add('bigint', 0, false, false, ftLargeint, 'int8', s_pg_bigint, tgNumericTypes);
  Items.Add('bigserial', 0, false, false, ftLargeint, 'serial8', s_pg_bigserial, tgNumericTypes);
  Items.Add('bit', 0, true, false, ftUnknown, '', s_pg_bit, tgBitStringTypes);
  Items.Add('bit varying', 0, true, false, ftUnknown, 'varbit', s_pg_bit_varying, tgBitStringTypes);
  Items.Add('boolean', 0, false, false, ftBoolean, 'bool', s_pg_boolean, tgBooleanTypes);
  Items.Add('box', 0, false, false, ftUnknown, '', s_pg_box, tgGeometricTypes);
  Items.Add('bytea', 0, false, false, ftUnknown, '', s_pg_bytea, tgBinaryDataTypes);
  Items.Add('varchar', 0, true, false, ftString, 'character varying', s_pg_varchar, tgCharacterTypes);
  Items.Add('char', 0, true, false, ftString, 'character;bpchar', s_pg_char, tgCharacterTypes);
  Items.Add('"char"', 0, true, false, ftString, '', s_pg_char, tgCharacterTypes);
  Items.Add('cidr', 0, false, false, ftUnknown, '', s_pg_cidr, tgNetworkAddressTypes);
  Items.Add('circle', 0, false, false, ftUnknown, '', s_pg_circle, tgGeometricTypes);
  Items.Add('date', 0, false, false, ftDate, '', s_pg_date, tgDateTimeTypes);
  Items.Add('double precision', 0, false, false, ftFloat, 'float8', s_pg_double_precision, tgNumericTypes);
  Items.Add('inet', 0, false, false, ftUnknown, '', s_pg_inet, tgNetworkAddressTypes);
  Items.Add('integer', 0, false, false, ftInteger, 'int'#13'int4', s_pg_integer, tgNumericTypes);
  Items.Add('interval', 0, true, false, ftUnknown,  '', s_pg_interval, tgDateTimeTypes);
  Items.Add('line', 0, false, false, ftUnknown, '', s_pg_line, tgGeometricTypes);
  Items.Add('lseg', 0, false, false, ftUnknown, '', s_pg_lseg, tgGeometricTypes);
  Items.Add('macaddr', 0, false, false, ftUnknown, '', s_pg_macaddr, tgNetworkAddressTypes);
  Items.Add('money', 0, false, false, ftCurrency, '', s_pg_money, tgMonetaryTypes);
  Items.Add('numeric', 0, true, true, ftFloat, 'decimal', s_pg_numeric, tgNumericTypes);
  Items.Add('path', 0, false, false, ftUnknown, '', s_pg_path, tgGeometricTypes);
  Items.Add('point', 0, false, false, ftUnknown, '', s_pg_point, tgGeometricTypes);
  Items.Add('polygon', 0, false, false, ftUnknown, '', s_pg_polygon, tgGeometricTypes);
  Items.Add('real', 0, false, false, ftFloat, 'float4', s_pg_real, tgNumericTypes);
  Items.Add('smallint', 0, false, false, ftSmallint, 'int2',s_pg_smallint, tgNumericTypes);
  Items.Add('serial', 0, false, false, ftAutoInc, '', s_pg_serial, tgNumericTypes);
  Items.Add('text', 0, false, false, ftMemo, '', s_pg_text, tgCharacterTypes);
  Items.Add('time', 0, false, false, ftTime, '', s_pg_time, tgDateTimeTypes);
  Items.Add('time with time zone', 0, false, false, ftTime, 'timetz', s_pg_time_wtz, tgDateTimeTypes);
  Items.Add('timestamp', 0, false, false, ftTimeStamp, 'timestamp without time zone', s_pg_timestamp, tgDateTimeTypes);
  Items.Add('timestamp with time zone', 0, false, false, ftTimeStamp, 'timestamptz', s_pg_timestamp_wtz, tgDateTimeTypes);
  Items.Add('tsquery', 0, false, false, ftUnknown, '', s_pg_tsquery, tgTextSearchTypes);
  Items.Add('tsvector', 0, false, false, ftUnknown, '', s_pg_tsvector, tgTextSearchTypes);
  Items.Add('txid_snapshot', 0, false, false, ftUnknown, '', s_pg_txid_snapshot, tgUnknow); { TODO : Необходимо разобраться с группой типа }
  Items.Add('uuid', 0, false, false, ftGuid, '', s_pg_uuid, tgUUIDTypes);
  Items.Add('xml', 0, false, false, ftUnknown, '', s_pg_XMLData, tgXMLTypes);

  Items.Add('regproc', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgObjectTypes);
  Items.Add('oid', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgObjectTypes);
  Items.Add('tid', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgUnknow); { TODO : Необходимо разобраться с группой типа }
  Items.Add('xid', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgUnknow); { TODO : Необходимо разобраться с группой типа }
  Items.Add('cid', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgUnknow); { TODO : Необходимо разобраться с группой типа }
  Items.Add('smgr', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgUnknow); { TODO : Необходимо разобраться с группой типа }
  Items.Add('abstime', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgUnknow); { TODO : Необходимо разобраться с группой типа }
  Items.Add('reltime', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgUnknow); { TODO : Необходимо разобраться с группой типа }
  Items.Add('tinterval', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgUnknow); { TODO : Необходимо разобраться с группой типа }
  Items.Add('unknown', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgUnknow); { TODO : Необходимо разобраться с группой типа }
  Items.Add('aclitem', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgUnknow); { TODO : Необходимо разобраться с группой типа }
//  Items.Add('bpchar', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgUnknow); { TODO : Необходимо разобраться с группой типа }
  Items.Add('refcursor', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgUnknow); { TODO : Необходимо разобраться с группой типа }
  Items.Add('regprocedure', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgObjectTypes);
  Items.Add('regoper', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgObjectTypes);
  Items.Add('regoperator', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgObjectTypes);
  Items.Add('regclass', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgObjectTypes);
  Items.Add('regtype', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgObjectTypes);
  Items.Add('gtsvector', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgUnknow); { TODO : Необходимо разобраться с группой типа }
  Items.Add('regconfig', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgUnknow); { TODO : Необходимо разобраться с группой типа }
  Items.Add('regdictionary', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgUnknow); { TODO : Необходимо разобраться с группой типа }
  Items.Add('pg_node_tree', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgUnknow);
  Items.Add('regrole', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgUnknow);
  Items.Add('regnamespace', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgUnknow);
  Items.Add('pg_ndistinct', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgUnknow);
  Items.Add('pg_dependencies', 0, false, false, ftUnknown, '', s_pg_UnknowData, tgUnknow);


  Items.Add('any', 0, false, false, ftUnknown, '', s_pg_any, tgPseudoTypes);  //Указывает, что функция принимает любой вводимый тип данных.
  Items.Add('anyarray', 0, false, false, ftUnknown, '', s_pg_anyarray, tgPseudoTypes);  //Указывает, что функция принимает любой тип массива (см. Подраздел 36.2.5).
  Items.Add('anyelement', 0, false, false, ftUnknown, '', s_pg_anyelement, tgPseudoTypes); //Указывает, что функция принимает любой тип данных (см. Подраздел 36.2.5).
  Items.Add('anyenum', 0, false, false, ftUnknown, '', s_pg_anyenum, tgPseudoTypes); //Указывает, что функция принимает любое перечисление (см. Подраздел 36.2.5 и Раздел 8.7).
  Items.Add('anynonarray', 0, false, false, ftUnknown, '', s_pg_anynonarray, tgPseudoTypes); //Указывает, что функция принимает любой тип данных, кроме массивов (см. Подраздел 36.2.5).
  Items.Add('anyrange', 0, false, false, ftUnknown, '', s_pg_anyenum, tgPseudoTypes); //Указывает, что функция принимает любой диапазонный тип данных (см. Подраздел 36.2.5 и Раздел 8.17).
  Items.Add('cstring', 0, false, false, ftUnknown, '', s_pg_cstring, tgPseudoTypes); //Указывает, что функция принимает или возвращает строку в стиле C.
  Items.Add('event_trigger', 0, false, false, ftUnknown, '', s_pg_void, tgPseudoTypes);  //Функция событийного триггера объявляется как возвращающая тип event_trigger.
  Items.Add('fdw_handler', 0, false, false, ftUnknown, '', s_pg_void, tgPseudoTypes);  //9.6 - Обработчик обёртки сторонних данных объявляется как возвращающий тип fdw_handler.
  Items.Add('index_am_handler', 0, false, false, ftUnknown, '', s_pg_void, tgPseudoTypes);  //Обработчик метода доступа индекса объявляется как возвращающий тип index_am_handler.
  Items.Add('internal', 0, false, false, ftUnknown, '', s_pg_internal, tgPseudoTypes); //Указывает, что функция принимает или возвращает внутренний серверный тип данных.
  Items.Add('language_handler', 0, false, false, ftUnknown, '', s_pg_language_handler, tgPseudoTypes); //Обработчик процедурного языка объявляется как возвращающий тип language_handler.
  Items.Add('opaque', 0, false, false, ftUnknown, '', s_pg_opaque, tgPseudoTypes);    //Устаревший тип, который раньше использовался во всех вышеперечисленных случаях.
  Items.Add('pg_ddl_command', 0, false, false, ftUnknown, '', s_pg_void, tgPseudoTypes);  //Обозначает представление команд DDL, доступное событийным триггерам.
  Items.Add('record', 0, false, false, ftUnknown, '', s_pg_record, tgPseudoTypes);    //Указывает, что функция принимает или возвращает неопределённый тип строки.
  Items.Add('trigger', 0, false, false, ftUnknown, '', s_pg_trigger, tgPseudoTypes);  //Триггерная функция объявляется как возвращающая тип trigger.
  Items.Add('tsm_handler', 0, false, false, ftUnknown, '', s_pg_void, tgPseudoTypes);  //Обработчик метода выборки из таблицы объявляется как возвращающий тип tsm_handler.
  Items.Add('void', 0, false, false, ftUnknown, '', s_pg_void, tgPseudoTypes);        //Указывает, что функция не возвращает значение.
end;

function ConvertFieldList(pgFieldList: string;const Obj: TDBDataSetObject): string;
var
  k:integer;

procedure DoFind(FNum:string; var R:string);
var
  j, kk:integer;
begin
  kk:=StrToInt(FNum);
  if Obj.Fields.Count = 0 then
    Obj.RefreshFieldList;

  for j:=0 to Obj.Fields.Count - 1 do
  begin
    if Obj.Fields[j].FieldNum = kk then
    begin
      if R<>'' then
        R:=R+',';
      R:=R+Obj.Fields[j].FieldName;
      exit;
    end;
  end;
end;

begin
  Result:='';
  pgFieldList:=StringsReplace(pgFieldList, ['{', '}'], ['',''], [rfReplaceAll]);
  while pgFieldList<>'' do
  begin
    K:=Pos(',', pgFieldList);
    if K>0 then
    begin
      DoFind(Copy(pgFieldList, 1, K-1), Result);
      Delete(pgFieldList, 1, K);
    end
    else
    begin
      DoFind(pgFieldList, Result);
      pgFieldList:='';
    end;
  end;
end;

function ParsePGArrayString(ArrayStr: string;const Items:TStrings): integer;
var
  i, j:integer;
begin
  ArrayStr:=StringsReplace(ArrayStr, ['{', '}'], ['',''], [rfReplaceAll]);
  Result:=0;
  while ArrayStr<>'' do
  begin
    j:=Pos(',', ArrayStr);
    if j>0 then
    begin
      Items.Add(Copy(ArrayStr, 1, j-1));
      Delete(ArrayStr, 1, j)
    end
    else
    begin
      Items.Add(ArrayStr);
      ArrayStr:='';
    end;
    inc(Result);
  end;
end;

function DoCountItems(ArrayStr: string; ADelimiter:Char):Integer;
var
  FInStr: Boolean;
  i: Integer;
begin
  Result:=0;
  if ArrayStr = '' then Exit;
  FInStr:=false;
  for i:=1 to Length(ArrayStr) do
  begin
    if ArrayStr[i] = '"' then
      FInStr:=not FInStr
    else
    if not FInStr then
    begin
      if ArrayStr[i] = ADelimiter then
        Inc(Result);
    end
  end;
  Inc(Result);
end;

function ParsePGArrayChar(ArrayStr: string; out Items: TCharArray; ADelimiter:Char = ','): integer;

function GetString(var I:Integer):string;
begin
  Result:='';
end;

var
  i, FCnt: Integer;
  S: String;
begin
  FCnt:=DoCountItems(ArrayStr, ADelimiter);
  SetLength(Items, FCnt);
  if ArrayStr = '' then Exit(0);

  i:=1;
  Result:=0;
  while I<Length(ArrayStr) do
  begin
    Inc(I);
    if ArrayStr[i] = '{' then
    else
    if ArrayStr[i] = '}' then I:=Length(ArrayStr) + 1
    else
    if ArrayStr[i] = '"' then
    begin
      S:=GetString(i);
      if S<>'' then
        Items[Result]:=S[1];
      AbstractError;
    end
    else
    if ArrayStr[i] = ADelimiter then
    begin
      Inc(Result);
      if Result>FCnt then
        AbstractError;
    end
    else
      Items[Result]:=ArrayStr[i];
  end;
  Inc(Result);
end;

function ParsePGArrayInt(ArrayStr: string; out Items: TIntegerArray; ADelimiter:Char = ','): integer;
begin
  AbstractError;
end;

function ParsePGArrayByte(ArrayStr: string; out Items: TByteArray; ADelimiter:Char = ','): integer;
begin
  AbstractError;
end;

function StrToPGSPVolatCat(const S:string):TPGSPVolatCat;
begin
  if S<>'' then
    case S[1] of
      'v':Result:=pgvcVOLATILE;
      's':Result:=pgvcSTABLE;
      'i':Result:=pgvcIMMUTABLE;
    else
      raise Exception.CreateFmt(sUnkonwPGFuncCategor, [S]);
    end
  else
     raise Exception.CreateFmt(sUnkonwPGFuncCategor, [''' ''']);
end;

procedure FillPGVersion(const Items: TStrings);
var
//  i:TPGServerVersion;
  S: String;
begin
  Items.Clear;
  for S in pgServerVersionStr do
    Items.Add(S);
{  for i:=Low(TPGServerVersion) to High(TPGServerVersion) do
    Items.Add(pgServerVersionStr[i]);}
end;
{
ResourceString
  SErrRollbackFailed = 'Rollback transaction failed';
  SErrCommitFailed = 'Commit transaction failed';
  SErrConnectionFailed = 'Connection to database failed';
  SErrTransactionFailed = 'Start of transacion failed';
  SErrClearSelection = 'Clear of selection failed';
  SErrExecuteFailed = 'Execution of query failed';
  SErrFieldDefsFailed = 'Can not extract field information from query';
  SErrFetchFailed = 'Fetch of data failed';
  SErrPrepareFailed = 'Preparation of query failed.';
}

function PGClassTypeToDBObjectKind(const S: string): TDBObjectKind;
begin
  if S = 'r' then
    Result:=okTable
  else
  if S = 'i' then
    Result:=okIndex
  else
  if S = 'S' then
    Result:=okSequence
  else
  if S = 'v' then
    Result:=okSequence
  {else
  if S = 'c' then
    Result:=okSequence
  else
  if S = 's' then
    Result:=okSequence
  else
  if S = 't' then
    Result:=okSequence}
  else
    Result:=okOther
end;

function PGConstraintTypeToDBObjectKind(const S: string): TDBObjectKind;
begin
  if S = 'c' then
    Result:=okCheckConstraint
  else
  if S = 'f' then
    Result:=okForeignKey
  else
  if S = 'p' then
    Result:=okPrimaryKey
  else
  if S = 'u' then
    Result:=okUniqueConstraint
  else
    Result:=okOther
end;

end.

