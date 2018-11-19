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

unit fb_utils;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, ExtCtrls, uib, SQLEngineCommonTypesUnit, uiblib;

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
    gds_verInterBase5_x,
    gds_verInterBase6_1,
    gds_verInterBase6_5,
    gds_verInterBase7_0,
    gds_verInterBase7_1,
    gds_verInterBase7_5,
    gds_verYaffil1_0
  );

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
   'InterBase 5.x',
   'InterBase 6.1',
   'InterBase 6.5',
   'InterBase 7.0',
   'InterBase 7.1',
   'InterBase 7.5',
   'Yaffil 1.0'
   );

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



function FB_SqlTypesToString(FBSqlType, FBSqlSubType:integer):string;
function StrToFBServersVersion(S: string):TFBServerVersion;
procedure FillStrServersVer(const S: TStrings);

procedure FillFieldTypes(Items:TDBMSFieldTypeList);
procedure FillUdfReturnStr(const S: TStrings);

function IndexToTransaction(AIndex:integer):TTransParams;

function MakeRestoreOpt(ACheckGroup:TCheckGroup):TRestoreOptions;
procedure SetRestoreOptToCheckGroup(RestOpt:TRestoreOptions; ACheckGroup:TCheckGroup);
function UIBProtocolToStr(AUIBProtocol:TUIBProtocol):string; inline;
function StrToUIBProtocol(AUIBProtocolStr:string):TUIBProtocol;

const
  UdfReturnTypes : array [TUdfRetyrnType] of string = ('By Value', 'By Reference', 'By Descriptor');

const
  TRDefault                 : TTransParams = [tpConcurrency,tpWait,tpWrite];
  TRSnapShot                : TTransParams = [tpConcurrency, tpNowait];
  TRReadCommitted           : TTransParams = [tpReadCommitted, tpRecVersion, tpNowait];
  TRReadOnlyTableStability  : TTransParams = [tpRead, tpConsistency];
  TRReadWriteTableStability : TTransParams = [tpWrite, tpConsistency];

procedure SetTranStrings(const AItems:TStrings);
implementation
uses uibase, fbmStrConstUnit, db;

function StrToFBServersVersion(S: string): TFBServerVersion;
var
  i: TFBServerVersion;
begin
  Result:=gds_verUnknown;
  for i:=Low(TFBServerVersion) to High(TFBServerVersion) do
    if UpperCase(S) = UpperCase(StrServersVer[i]) then
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

function StrToUIBProtocol(AUIBProtocolStr: string): TUIBProtocol;
var
  P: TUIBProtocol;
begin
  for P in TUIBProtocol do
    if UpperCase(UIBProtocolStr[P]) = UpperCase(AUIBProtocolStr) then
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

{
function CreateFieldTypeStr(ATypeID: TdbmsFieldType; ASize, APrec: integer
  ): string;
begin
  if ATypeID = fftNumeric then
    Result:=Format('%s(%d,%d)', [FBFieldTypes[ATypeID], ASize, APrec])
  else
  if ATypeID in dbmsFieldTypesCharacter then
    Result:=Format('%s(%d)', [FBFieldTypes[ATypeID],ASize])
  else
    Result:=FBFieldTypes[ATypeID];
end;

procedure FillFieldTypeStr(const S: TStrings);
var
  i:TdbmsFieldType;
begin
  S.Clear;
  for i:= succ(Low(TdbmsFieldType)) to High(TdbmsFieldType) do
    S.Add(FBFieldTypes[i]);
end;
}

resourcestring
  sDescBIGINT = '8-byte integer type';
  sDescVARCHAR = 'Variable-length data with a maximum of 32,765 characters.';
  sDescINTEGER = 'Integer (whole number) data from -231 (-2,147,483,648) through 231 - 1 (2,147,483,647).';
  sDescSMALLINT = 'Integer data from -215 (-32,768) through 215 - 1 (32,767).';
  sDescTIMESTAMP = 'Date and time data from January 1, 1900, through June 6, 2079, with an accuracy of one minute. Firebird''s has greater range and accuracy.';
  sDescTIME = 'The TIME data type stores the time of day within the range from 00:00:00.0000 to 23:59:59.9999.';
  sDescDATE = 'The DATE data type stores the date. From 01.01.0001 AD to 31.12.9999. Date only, no time element';
  sDescCHAR = 'Size in bytes depends on the encoding, the number of bytes in a character. from 1 to 32,767 bytes. A fixed-length character data type. When its data is displayed, trailing spaces are added to the string up to the specified length. Trailing spaces are not stored in the database but are restored to match the defined length when the column is displayed on the client side. Network traffic is reduced by not sending spaces over the LAN. If the number of characters is not specified, 1 is used by default.';
  sDescNUMERIC = '';
  sDescCSTRING = '';
  sDescQUAD = '';
  sDescFLOAT = '';
  sDescDOUBLE_PRECISION = '';
  sDescBLOB = '';
  sDescBLOBID = '';
  sDescARRAY = '';
  sDescBOOLEAN = '';

procedure FillFieldTypes(Items: TDBMSFieldTypeList);
begin
  Items.Add('NUMERIC',          016,  true,  true,  ftFloat,   '', sDescNUMERIC, tgNumericTypes);
  Items.Add('CHAR',             014,  true, false, ftString,   'CHARACTER', sDescCHAR, tgCharacterTypes);
  Items.Add('VARCHAR',          037,  true, false, ftString,   'CHAR VARYING'+LineEnding+'CHARACTER VARYING', sDescVARCHAR, tgCharacterTypes);
  Items.Add('CSTRING',          040,  true, false, ftString,   '', sDescCSTRING, tgCharacterTypes);
  Items.Add('SMALLINT',         007, false, false, ftSmallint, '', sDescSMALLINT, tgNumericTypes);
  Items.Add('INTEGER',          008, false, false, ftInteger,  '', sDescINTEGER, tgNumericTypes);
  Items.Add('QUAD',             009, false, false, ftLargeint, '', sDescQUAD, tgNumericTypes);
  Items.Add('FLOAT',            010, false, false, ftFloat,    '', sDescFLOAT, tgNumericTypes);
  Items.Add('DOUBLE PRECISION', 027, false, false, ftFloat,    '', sDescDOUBLE_PRECISION, tgNumericTypes);
  Items.Add('TIMESTAMP',        035, false, false, ftTimeStamp,'', sDescTIMESTAMP, tgDateTimeTypes);
  Items.Add('BLOB',             261, false, false, ftBlob,     '', sDescBLOB, tgBinaryDataTypes);
  Items.Add('BLOBID',           045, false, false, ftUnknown,  '', sDescBLOBID, tgBinaryDataTypes);
  Items.Add('DATE',             012, false, false, ftDate,     '', sDescDATE, tgDateTimeTypes);
  Items.Add('TIME',             013, false, false, ftTime,     '', sDescTIME, tgDateTimeTypes);
  Items.Add('BIGINT',             0, false, false, ftLargeint, '', sDescBIGINT, tgNumericTypes);
  Items.Add('ARRAY',              0, false, false, ftUnknown,  '', sDescARRAY, tgArrays);
  Items.Add('BOOLEAN',          023, false, false, ftBoolean,  '', sDescBOOLEAN, tgBooleanTypes);
end;

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

procedure FillUdfReturnStr(const S: TStrings);
var
  i:TUdfRetyrnType;
begin
  S.Clear;
  for i:= Low(TUdfRetyrnType) to High(TUdfRetyrnType) do
    S.Add(UdfReturnTypes[i]);
end;

end.

