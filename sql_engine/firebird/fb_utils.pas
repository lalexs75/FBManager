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

unit fb_utils;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, ExtCtrls, uib, SQLEngineCommonTypesUnit, uiblib;

const
  //#define dtype_unknown	0
  dtype_unknown = 0;
  //#define dtype_text		1
  dtype_text = 1;
  //#define dtype_cstring	2
  dtype_cstring = 2;
  //#define dtype_varying	3
  dtype_varying = 3;
  //
  //#define dtype_packed	6
  dtype_packed = 6;
  //#define dtype_byte		7
  dtype_byte = 7;
  //#define dtype_short		8
  dtype_short = 8;
  //#define dtype_long		9
  dtype_long = 9;
  //#define dtype_quad		10
  dtype_quad = 10;
  //#define dtype_real		11
  dtype_real = 11;
  //#define dtype_double	12
  dtype_double = 12;
  //#define dtype_d_float	13
  dtype_d_float = 13;
  //#define dtype_sql_date	14
  dtype_sql_date = 14;
  //#define dtype_sql_time	15
  dtype_sql_time = 15;
  //#define dtype_timestamp	16
  dtype_timestamp = 16;
  //#define dtype_blob		17
  dtype_blob = 17;
  //#define dtype_array		18
  dtype_array = 18;
  //#define dtype_int64		19
  dtype_int64 = 19;
  //#define dtype_dbkey		20
  dtype_dbkey = 20;
  //#define dtype_boolean	21
  dtype_boolean = 21;
  //#define dtype_dec64		22
  dtype_dec64 = 22;
  //#define dtype_dec128	23
  dtype_dec128 = 23;
  //#define dtype_int128	24
  dtype_int128 = 24;
  //#define dtype_sql_time_tz	25
  dtype_sql_time_tz = 25;
  //#define dtype_timestamp_tz	26
  dtype_timestamp_tz = 26;
  //#define dtype_ex_time_tz	27
  dtype_ex_time_tz = 27;
  //#define dtype_ex_timestamp_tz	28
  dtype_ex_timestamp_tz = 28;
  //#define DTYPE_TYPE_MAX	29
  DTYPE_TYPE_MAX = 29;

type

  TUdfRetyrnType = ( urtByValue, urtByReference, urtByDescriptor);

type
  TFBServerVersion = (
    gds_verUnknown,
    gds_verFirebird1_0,
    gds_verFirebird1_5,
    gds_verFirebird2_0,
    gds_verFirebird2_1,
    gds_verFirebird2_5,
    gds_verFirebird3_0,
    gds_verFirebird4_0,
    gds_verFirebird5_0,
    gds_verInterBase5_x,
    gds_verInterBase6_1,
    gds_verInterBase6_5,
    gds_verInterBase7_0,
    gds_verInterBase7_1,
    gds_verInterBase7_5,
    gds_verYaffil1_0
  );

type
  TFBSystemPrivileges =
    (unused = 0,
     USER_MANAGEMENT = 1,
     READ_RAW_PAGES = 2,
     CREATE_USER_TYPES = 3,
     USE_NBACKUP_UTILITY = 4,
     CHANGE_SHUTDOWN_MODE = 5,
     TRACE_ANY_ATTACHMENT = 6,
     MONITOR_ANY_ATTACHMENT = 7,
     ACCESS_SHUTDOWN_DATABASE = 8,
     CREATE_DATABASE = 9,
     DROP_DATABASE = 10,
     USE_GBAK_UTILITY = 11,
     USE_GSTAT_UTILITY = 12,
     USE_GFIX_UTILITY = 13,
     IGNORE_DB_TRIGGERS = 14,
     CHANGE_HEADER_SETTINGS = 15,
     SELECT_ANY_OBJECT_IN_DATABASE = 16,
     ACCESS_ANY_OBJECT_IN_DATABASE = 17,
     MODIFY_ANY_OBJECT_IN_DATABASE = 18,
     CHANGE_MAPPING_RULES = 19,
     USE_GRANTED_BY_CLAUSE = 20,
     GRANT_REVOKE_ON_ANY_OBJECT = 21,
     GRANT_REVOKE_ANY_DDL_RIGHT = 22,
     CREATE_PRIVILEGED_ROLES = 23,
     GET_DBCRYPT_INFO = 24,
     MODIFY_EXT_CONN_POOL = 25,
     REPLICATE_INTO_DATABASE = 26,
     PROFILE_ANY_ATTACHMENT = 27
     );
  TFBSystemPrivilegesSet = set of TFBSystemPrivileges;

type
  TUDFParamsRecord = record
    ArgPosition:integer;
    Mechanism:integer;
    FieldType:integer;
    FieldScale:integer;
    FieldLength:integer;
    FieldSubType:integer;
    CharSetId:integer;
    Precision:integer;
    CharSetLength:integer;
  end;
  TUDFParamsArray = array [0..0] of TUDFParamsRecord;
  PUDFParamsArray = ^TUDFParamsArray;


const
  UIBProtocolStr:array[TUIBProtocol] of string = ('proLocalHost', 'proTCPIP', 'proNetBEUI');

  StrServersVer : array [TFBServerVersion] of string =
  ('Unknown',
   'Firebird 1.0',
   'Firebird 1.5',
   'Firebird 2.0',
   'Firebird 2.1',
   'Firebird 2.5',
   'Firebird 3.0',
   'Firebird 4.0',
   'Firebird 5.0',
   'InterBase 5.x',
   'InterBase 6.1',
   'InterBase 6.5',
   'InterBase 7.0',
   'InterBase 7.1',
   'InterBase 7.5',
   'Yaffil 1.0'
   );

const
  FBSystemPrivilegesStr : array [TFBSystemPrivileges] of string = (
    'unused',
    'USER_MANAGEMENT',
    'READ_RAW_PAGES',
    'CREATE_USER_TYPES',
    'USE_NBACKUP_UTILITY',
    'CHANGE_SHUTDOWN_MODE',
    'TRACE_ANY_ATTACHMENT',
    'MONITOR_ANY_ATTACHMENT',
    'ACCESS_SHUTDOWN_DATABASE',
    'CREATE_DATABASE',
    'DROP_DATABASE',
    'USE_GBAK_UTILITY',
    'USE_GSTAT_UTILITY',
    'USE_GFIX_UTILITY',
    'IGNORE_DB_TRIGGERS',
    'CHANGE_HEADER_SETTINGS',
    'SELECT_ANY_OBJECT_IN_DATABASE',
    'ACCESS_ANY_OBJECT_IN_DATABASE',
    'MODIFY_ANY_OBJECT_IN_DATABASE',
    'CHANGE_MAPPING_RULES',
    'USE_GRANTED_BY_CLAUSE',
    'GRANT_REVOKE_ON_ANY_OBJECT',
    'GRANT_REVOKE_ANY_DDL_RIGHT',
    'CREATE_PRIVILEGED_ROLES',
    'GET_DBCRYPT_INFO',
    'MODIFY_EXT_CONN_POOL',
    'REPLICATE_INTO_DATABASE',
    'PROFILE_ANY_ATTACHMENT'
);


//function FB_SqlTypesToString(FBSqlType, FBSqlSubType:integer):string;
function StrToFBServersVersion(const S: string):TFBServerVersion;
procedure FillStrServersVer(const S: TStrings);

procedure FillFieldTypes(Items:TDBMSFieldTypeList);
procedure FillUdfReturnStr(const S: TStrings);

function IndexToTransaction(AIndex:integer):TTransParams;

function MakeRestoreOpt(ACheckGroup:TCheckGroup):TRestoreOptions;
procedure SetRestoreOptToCheckGroup(RestOpt:TRestoreOptions; ACheckGroup:TCheckGroup);
function UIBProtocolToStr(AUIBProtocol:TUIBProtocol):string; inline;
function StrToUIBProtocol(const AUIBProtocolStr:string):TUIBProtocol;

const
  UdfReturnTypes : array [TUdfRetyrnType] of string = ('By Value', 'By Reference', 'By Descriptor');

const
  TRDefault                 : TTransParams = [tpConcurrency,tpWait,tpWrite];
  TRSnapShot                : TTransParams = [tpConcurrency, tpNowait];
  TRReadCommitted           : TTransParams = [tpReadCommitted, tpRecVersion, tpNowait];
  TRReadOnlyTableStability  : TTransParams = [tpRead, tpConsistency];
  TRReadWriteTableStability : TTransParams = [tpWrite, tpConsistency];

procedure SetTranStrings(const AItems:TStrings);
function GetDefaultFB3Lib:string;
implementation
uses uibase, fbmStrConstUnit, db;

function StrToFBServersVersion(const S: string): TFBServerVersion;
var
  i: TFBServerVersion;
begin
  Result:=gds_verUnknown;
  for i:=Low(TFBServerVersion) to High(TFBServerVersion) do
    if CompareText(S, StrServersVer[i])=0 then
      Exit(I);
end;

procedure FillStrServersVer(const S: TStrings);
var
  i:TFBServerVersion;
begin
  S.Clear;
  for i:=Low(TFBServerVersion) to High(TFBServerVersion) do
    S.Add(StrServersVer[i]);
end;

function IndexToTransaction(AIndex: integer): TTransParams;
begin
  case AIndex of
    0:Result:=TRSnapShot; //Snapshot
    1:Result:=TRReadCommitted; //Read commited
    2:Result:=TRReadOnlyTableStability; //Read-only table stability
    3:Result:=TRReadWriteTableStability; //Read-write table stability
  else
    Result:=TRDefault;
  end;
end;

function MakeRestoreOpt(ACheckGroup:TCheckGroup):TRestoreOptions;
begin
  Result:=[];

  if ACheckGroup.Checked[0] then
    Result:=Result + [roDeactivateIndexes];

  if ACheckGroup.Checked[1] then
    Result:=Result + [roNoShadow];

  if ACheckGroup.Checked[2] then
    Result:=Result + [roNoValidityCheck];

  if ACheckGroup.Checked[3] then
    Result:=Result + [roOneRelationAtATime];

  if ACheckGroup.Checked[4] then
    Result:=Result + [roReplace];

  if ACheckGroup.Checked[5] then
    Result:=Result + [roCreateNewDB];

  if ACheckGroup.Checked[6] then
    Result:=Result + [roUseAllSpace];

{  if ACheckGroup.Checked[7] then
    Result:=Result + [roValidate];}
end;

procedure SetRestoreOptToCheckGroup(RestOpt:TRestoreOptions; ACheckGroup:TCheckGroup);
begin
  ACheckGroup.Checked[0]:= roDeactivateIndexes in RestOpt;
  ACheckGroup.Checked[1]:= roNoShadow in RestOpt;
  ACheckGroup.Checked[2]:= roNoValidityCheck in RestOpt;
  ACheckGroup.Checked[3]:= roOneRelationAtATime in RestOpt;
  ACheckGroup.Checked[4]:= roReplace in RestOpt;
  ACheckGroup.Checked[5]:= roCreateNewDB in RestOpt;
  ACheckGroup.Checked[6]:= roUseAllSpace in RestOpt;
//  ACheckGroup.Checked[7]:= roValidate in RestOpt;
end;


function UIBProtocolToStr(AUIBProtocol: TUIBProtocol): string;
begin
  Result:=UIBProtocolStr[AUIBProtocol];
end;

function StrToUIBProtocol(const AUIBProtocolStr: string): TUIBProtocol;
var
  P: TUIBProtocol;
begin
  for P in TUIBProtocol do
    if CompareText(UIBProtocolStr[P], AUIBProtocolStr)=0 then
      Exit(P);
  P:=proTCPIP;
end;

procedure SetTranStrings(const AItems: TStrings);
begin
  AItems.Clear;
  AItems.Add(sFBTranParamsSnapshot);
  AItems.Add(sFBTranParamsReadCommited);
  AItems.Add(sFBTranParamsReadOnlyTableStab);
  AItems.Add(sFBTranParamsReadWriteTableStab);
end;

function GetDefaultFB3Lib: string;
{$IFDEF WINDOWS}
var
  F: String;
{$ENDIF}
begin
  {$IFDEF WINDOWS}
  F:= ExtractFileDir(ParamStr(0)) + '\fbclient.dll';
  if FileExists(F) then
    Result:=F
  else
  begin
    F:= ExtractFileDir(ParamStr(0)) + '\dlls\fblib\fbclient.dll';
    if FileExists(F) then
      Result:=F
    else
      Result:=GDS32DLL;
  end;
  {$ELSE}
  Result:=GDS32DLL;
  {$ENDIF}
end;

resourcestring
  sDescBIGINT = '8-byte integer type';
  sDescVARCHAR = 'Variable-length data with a maximum of 32,765 characters.';
  sDescINTEGER = 'Integer (whole number) data from -231 (-2,147,483,648) through 231 - 1 (2,147,483,647).';
  sDescINT64 = 'Signed 64-bit integer.';
  sDescSMALLINT = 'Integer data from -215 (-32,768) through 215 - 1 (32,767).';
  sDescTIMESTAMP = 'Date and time data from January 1, 1900, through June 6, 2079, with an accuracy of one minute. Firebird''s has greater range and accuracy.';
  sDescTIME = 'The TIME data type stores the time of day within the range from 00:00:00.0000 to 23:59:59.9999.';
  sDescDATE = 'The DATE data type stores the date. From 01.01.0001 AD to 31.12.9999. Date only, no time element';
  sDescCHAR = 'Size in bytes depends on the encoding, the number of bytes in a character. from 1 to 32,767 bytes. A fixed-length character data type. When its data is displayed, trailing spaces are added to the string up to the specified length. Trailing spaces are not stored in the database but are restored to match the defined length when the column is displayed on the client side. Network traffic is reduced by not sending spaces over the LAN. If the number of characters is not specified, 1 is used by default.';
  sDescNUMERIC = '';
  sDescCSTRING = '';
  sDescQUAD = '';
  sDescFLOAT = 'Single-precision, IEEE-754 binary32, ~7 digits';
  sDescFLOAT16 = 'Decimal floating-point type, IEEE-754 decimal64.';
  sDescFLOAT34 = 'Decimal floating-point type, IEEE-754 decimal128.';
  sDescDOUBLE_PRECISION = '';
  sDescBLOB = 'A data type of variable size for storing large amounts of data';
  sDescBLOBID = '';
  sDescARRAY = '';
  sDescBOOLEAN = 'Boolean data type';


procedure FillFieldTypes(Items: TDBMSFieldTypeList);
var
  P: TDBMSFieldTypeRecord;
begin
  P:=Items.Add('NUMERIC',          016,  true,  true,  ftFloat,   '', sDescNUMERIC, tgNumericTypes);
  P.SubTypeId:=1;
  Items.Add('SMALLINT',         007, false, false, ftSmallint, '', sDescSMALLINT, tgNumericTypes); //RDB$FIELD_TYPE	7	SHORT		1
  Items.Add('INTEGER',          008, false, false, ftInteger,  '', sDescINTEGER, tgNumericTypes);  //RDB$FIELD_TYPE	8	LONG		1
  Items.Add('QUAD',             009, false, false, ftLargeint, '', sDescQUAD, tgNumericTypes);     //RDB$FIELD_TYPE	9	QUAD		1
  Items.Add('FLOAT',            010, false, false, ftFloat,    '', sDescFLOAT, tgNumericTypes);    //RDB$FIELD_TYPE	10	FLOAT		1
  Items.Add('DATE',             012, false, false, ftDate,     '', sDescDATE, tgDateTimeTypes);    //RDB$FIELD_TYPE	12	DATE		1
  Items.Add('TIME',             013, false, false, ftTime,     '', sDescTIME, tgDateTimeTypes);    //RDB$FIELD_TYPE	13	TIME		1
  Items.Add('CHAR',             014, true, false, ftString,   'CHARACTER', sDescCHAR, tgCharacterTypes); //RDB$FIELD_TYPE	14	TEXT		1
  Items.Add('BIGINT',           016, false, false, ftLargeint,   '', sDescBIGINT, tgNumericTypes);       //RDB$FIELD_TYPE	16	INT64		1
  Items.Add('BOOLEAN',          023, false, false, ftBoolean,  '', sDescBOOLEAN, tgBooleanTypes);         //RDB$FIELD_TYPE	23	BOOLEAN		1
  Items.Add('DECFLOAT(16)',     024, false, false, ftFloat,    '', sDescFLOAT16, tgNumericTypes);    //RDB$FIELD_TYPE	24	DECFLOAT(16)		1
  Items.Add('DECFLOAT(34)',     025, false, false, ftFloat,    '', sDescFLOAT34, tgNumericTypes);    //RDB$FIELD_TYPE	25	DECFLOAT(34)		1

  Items.Add('INT128',           026, false, false, ftLargeint, '', sDescBIGINT, tgNumericTypes); //  RDB$FIELD_TYPE	26	INT128		1
  Items.Add('DOUBLE PRECISION', 027, false, false, ftFloat,    '', sDescDOUBLE_PRECISION, tgNumericTypes);//RDB$FIELD_TYPE	27	DOUBLE		1

  Items.Add('TIME WITH TIME ZONE', 028, false, false, ftTime, '', sDescTIME, tgDateTimeTypes);    //RDB$FIELD_TYPE	28	TIME WITH TIME ZONE		1
  Items.Add('TIMESTAMP WITH TIME ZONE', 029, false, false, ftTime, '', sDescTIME, tgDateTimeTypes);    //RDB$FIELD_TYPE	29	TIMESTAMP WITH TIME ZONE		1

  Items.Add('TIMESTAMP',        035, false, false, ftTimeStamp,'', sDescTIMESTAMP, tgDateTimeTypes); //RDB$FIELD_TYPE	35	TIMESTAMP		1

  Items.Add('VARCHAR',          037,  true, false, ftString,   'CHAR VARYING'+LineEnding+'CHARACTER VARYING', sDescVARCHAR, tgCharacterTypes);//RDB$FIELD_TYPE	37	VARYING		1
  Items.Add('CSTRING',          040,  true, false, ftString,   '', sDescCSTRING, tgCharacterTypes); //RDB$FIELD_TYPE	40	CSTRING		1
  Items.Add('BLOBID',           045, false, false, ftUnknown,  '', sDescBLOBID, tgBinaryDataTypes); //RDB$FIELD_TYPE	45	BLOB_ID		1
  Items.Add('BLOB',             261, false, false, ftBlob,     '', sDescBLOB, tgBinaryDataTypes);   //RDB$FIELD_TYPE	261	BLOB		1
  Items.Add('ARRAY',              0, false, false, ftUnknown,  '', sDescARRAY, tgArrays);

end;
{
type
  TdbmsFieldType = (fftUnKnown, fftNumeric, fftChar, fftVarchar, fftCstring, fftSmallint,
    fftInteger, fftQuad, fftFloat, fftDoublePrecision, fftTimestamp, fftBlob, fftBlobId,
    fftDate, fftTime, fftInt64, fftArray, fftBoolean);

function FB_SqlTypeToFBType(FBSqlType, FBSqlSubType: integer): TdbmsFieldType;
begin
  case FBSqlType of
    007:Result:=fftSmallint;
    008:Result:=fftInteger;
    009:Result:=fftQuad;
    010:Result:=fftFloat;
    012:Result:=fftDate;
    013:Result:=fftTime;
    014:Result:=fftChar;
    016:case FBSqlSubType of
          0:Result:=fftInt64;
          1:Result:=fftNumeric;
        end;
    023:Result:=fftBoolean;
    027:Result:=fftDoublePrecision;
    035:Result:=fftTimestamp;
    037:Result:=fftVarchar;
    040:Result:=fftCstring;
    045:Result:=fftBlobId;
    261:Result:=fftBlob;
  else
    Result:=fftUnKnown;
    raise Exception.CreateFmt('Unknow data type %d %d', [FBSqlType, FBSqlSubType]);
  end;
end;

const
  FBFieldTypes: array [TdbmsFieldType] of string =
   ('', 'NUMERIC', 'CHAR', 'VARCHAR', 'CSTRING', 'SMALLINT', 'INTEGER', 'QUAD',
    'FLOAT', 'DOUBLE PRECISION', 'TIMESTAMP', 'BLOB', 'BLOBID', 'DATE', 'TIME',
    'BIGINT' , 'ARRAY', 'BOOLEAN');

function FB_SqlTypesToString(FBSqlType, FBSqlSubType: integer): string;
begin
  Result:=FBFieldTypes[FB_SqlTypeToFBType(FBSqlType, FBSqlSubType)];
end;
}

procedure FillUdfReturnStr(const S: TStrings);
var
  i:TUdfRetyrnType;
begin
  S.Clear;
  for i:= Low(TUdfRetyrnType) to High(TUdfRetyrnType) do
    S.Add(UdfReturnTypes[i]);
end;

end.

