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

unit fb_CharSetUtils;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, contnrs, UIB;
(*
type

  { TCollationsItem }

  TCollationsItem = class
  private
    FCollationID: integer;
    FCollationName: string;
    FDescription: string;
  public
    property CollationName:string read FCollationName;
    property CollationID:integer read FCollationID;
    property Description:string read FDescription;
  end;

  { TCharSetItem }

  TCharSetItem = class
  private
    FCollateList:TObjectList;
    FCSBytePerChar: integer;
    FCSDescription: string;
    FCSID: integer;
    FCSName: string;
    FDefCollateName:string;
    function GetCollationsCount: integer;
    function GetCollationsItem(AItem: integer): TCollationsItem;
    function GetDefCollate: TCollationsItem;
  public
    constructor Create;
    destructor Destroy; override;
    procedure FillCollationStrings(const AStr:TStrings);
    function FindCollation(ACollation:string):TCollationsItem;

    property CollationsCount:integer read GetCollationsCount;
    property CollationsItem[AItem:integer]:TCollationsItem read GetCollationsItem;
    property CSName:string read FCSName;
    property CSBytePerChar:integer read FCSBytePerChar;
    property CSDescription:string read FCSDescription;
    property DefCollate:TCollationsItem read GetDefCollate;
    property CSID:integer read FCSID;
  end;

  { TCharSetList }

  TCharSetList = class
  private
    FCSList:TObjectList;
    function GetCharSet(AItem: integer): TCharSetItem;
    function GetCountCharSets: integer;
  public
    constructor Create;
    destructor Destroy; override;
    function FindCharSet(CSID:integer):TCharSetItem;
    function FindItemByName(const ACharSetName:string):integer;
    function FindItemByCSID(CSID:integer):integer;
    procedure FillCSStrings(const AStr:TStrings);

    property CountCharSets:integer read GetCountCharSets;
    property CharSet[AItem:integer]:TCharSetItem read GetCharSet;
  end;

function BuildCharSetList(AQuery:TUIBQuery):TCharSetList;

function DBCharsetToUtf8(const AStr, ACharSet:string):string;
function DBCharsetFromUtf8(const AStr, ACharSet:string):string;
*)
implementation
(*
uses ibmsqltextsunit
  {$IFNDEF WINDOWS}
    , iconvenc
  {$ELSE}
    , LazUTF8
  {$ENDIF}
  ;

function BuildCharSetList(AQuery: TUIBQuery): TCharSetList;
var
  CharSetItem:TCharSetItem;
  CollationsItem:TCollationsItem;
  id:integer;
begin
  Result:=TCharSetList.Create;
  AQuery.SQL.Text:=ssqlCharSetList;
  try
    AQuery.Open;
    while not AQuery.Eof do
    begin
      CharSetItem:=TCharSetItem.Create;
      CharSetItem.FCSBytePerChar:=AQuery.Fields.ByNameAsInteger['RDB$BYTES_PER_CHARACTER'];
      CharSetItem.FCSDescription:=Trim(AQuery.Fields.ByNameAsString['RDB$DESCRIPTION']);
      CharSetItem.FCSID:=AQuery.Fields.ByNameAsInteger['RDB$CHARACTER_SET_ID'];
      CharSetItem.FCSName:=Trim(AQuery.Fields.ByNameAsString['RDB$CHARACTER_SET_NAME']);
      CharSetItem.FDefCollateName:=Trim(AQuery.Fields.ByNameAsString['RDB$DEFAULT_COLLATE_NAME']);

      Result.FCSList.Add(CharSetItem);
      AQuery.Next;
    end;
  finally
    AQuery.Close;
  end;
{
                    '  RDB$CHARACTER_SETS.RDB$FORM_OF_USE, '+
                    '  RDB$CHARACTER_SETS.RDB$NUMBER_OF_CHARACTERS, '+
                    '  RDB$CHARACTER_SETS.RDB$SYSTEM_FLAG, '+
                    '  RDB$CHARACTER_SETS.RDB$FUNCTION_NAME, '+
}

  AQuery.SQL.Text:=ssqlColationList;
  try
    AQuery.Open;
    while not AQuery.Eof do
    begin
      id:=AQuery.Fields.ByNameAsInteger['RDB$CHARACTER_SET_ID'];
      CharSetItem:=Result.FindCharSet(id);
      if Assigned(CharSetItem) then
      begin
        CollationsItem:=TCollationsItem.Create;
        CollationsItem.FCollationID:=AQuery.Fields.ByNameAsInteger['RDB$COLLATION_ID'];
        CollationsItem.FCollationName:=Trim(AQuery.Fields.ByNameAsString['RDB$COLLATION_NAME']);
        CollationsItem.FDescription:=Trim(AQuery.Fields.ByNameAsString['RDB$DESCRIPTION']);
        CharSetItem.FCollateList.Add(CollationsItem);
      end;
      AQuery.Next;
    end;
  finally
    AQuery.Close;
  end;

{
                    '  RDB$COLLATIONS.RDB$COLLATION_ATTRIBUTES, '+
                    '  RDB$COLLATIONS.RDB$SYSTEM_FLAG, '+
                    '  RDB$COLLATIONS.RDB$FUNCTION_NAME, '+
                    '  RDB$COLLATIONS.RDB$BASE_COLLATION_NAME, '+
                    '  RDB$COLLATIONS.RDB$SPECIFIC_ATTRIBUTES '+
}
end;

function DBCharsetToUtf8(const AStr, ACharSet: string): string;
begin
  if ACharSet = 'NONE' then
    Result:=AStr
  else
{$IFNDEF WINDOWS}
  Iconvert(AStr, Result, ACharSet, 'UTF8');
{$ELSE}
  //Плохое решение - пока подпорка
  Result:=WinCPToUTF8(AStr);
{$ENDIF}
end;

function DBCharsetFromUtf8(const AStr, ACharSet: string): string;
begin
  if ACharSet = 'NONE' then
    Result:=AStr
  else
{$IFNDEF WINDOWS}
  Iconvert(AStr, Result, 'UTF8', ACharSet);
{$ELSE}
  //Плохое решение - пока подпорка
  Result:=UTF8ToWinCP(AStr);
{$ENDIF}
end;

{ TCharSetList }
function TCharSetList.GetCountCharSets: integer;
begin
  Result:=FCSList.Count;
end;

function TCharSetList.GetCharSet(AItem: integer): TCharSetItem;
begin
  Result:=TCharSetItem(FCSList[AItem]);
end;

constructor TCharSetList.Create;
begin
  inherited Create;
  FCSList:=TObjectList.Create;
end;

destructor TCharSetList.Destroy;
begin
  FreeAndNil(FCSList);
  inherited Destroy;
end;

function TCharSetList.FindCharSet(CSID: integer): TCharSetItem;
var
  i:integer;
begin
  Result:=nil;
  for i:=0 to FCSList.Count - 1 do
  begin
    if TCharSetItem(FCSList[i]).CSID = CSID then
    begin
      Result:=TCharSetItem(FCSList[i]);
      exit;
    end;
  end;
end;

function TCharSetList.FindItemByName(const ACharSetName: string): integer;
var
  i:integer;
begin
  Result:=-1;
  for i:=0 to FCSList.Count - 1 do
  begin
    if TCharSetItem(FCSList[i]).CSName = ACharSetName then
    begin
      Result:=i;
      exit;
    end;
  end;
end;

function TCharSetList.FindItemByCSID(CSID: integer): integer;
var
  i:integer;
begin
  Result:=-1;
  for i:=0 to FCSList.Count - 1 do
  begin
    if TCharSetItem(FCSList[i]).CSID = CSID then
    begin
      Result:=i;
      exit;
    end;
  end;
end;

procedure TCharSetList.FillCSStrings(const AStr: TStrings);
var
  i:integer;
begin
  AStr.Clear;
  for i:=0 to FCSList.Count - 1 do
    AStr.Add(TCharSetItem(FCSList[i]).CSName);
end;

{ TCharSetItem }

function TCharSetItem.GetCollationsItem(AItem: integer): TCollationsItem;
begin
  Result:=TCollationsItem(FCollateList[AItem]);
end;

function TCharSetItem.GetCollationsCount: integer;
begin
  Result:=FCollateList.Count;
end;

function TCharSetItem.GetDefCollate: TCollationsItem;
begin
  Result:=FindCollation(FDefCollateName);
end;

constructor TCharSetItem.Create;
begin
  inherited Create;
  FCollateList:=TObjectList.Create;
end;

destructor TCharSetItem.Destroy;
begin
  FreeAndNil(FCollateList);
  inherited Destroy;
end;

procedure TCharSetItem.FillCollationStrings(const AStr: TStrings);
var
  i:integer;
begin
  AStr.Clear;
  for i:=0 to FCollateList.Count - 1 do
    AStr.Add(TCollationsItem(FCollateList[i]).CollationName);
end;

function TCharSetItem.FindCollation(ACollation: string): TCollationsItem;
var
  i:integer;
begin
  Result:=nil;
  for i:=0 to FCollateList.Count - 1 do
  begin
    if TCollationsItem(FCollateList[i]).CollationName = ACollation then
    begin
      Result:=TCollationsItem(FCollateList[i]);
      exit;
    end;
  end
end;
*)
end.

