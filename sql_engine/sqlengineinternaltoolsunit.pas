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

unit SQLEngineInternalToolsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineCommonTypesUnit, DB;

type
  TDBItemsEnumerator = class;

  //Объекты абстракции при чтении структуры БД
  TDBItem = class
      ObjId:integer;
      SchemeID:integer;
      ObjName:string;
      ObjType:string;
      ObjDesc:string;
      ObjOwnData:Integer;
      ObjRelName:string;
      ObjData:string;
      ObjType2:Integer;
    end;

  { TDBItems }

  TDBItems = class
  private
    FCountUse: integer;
    FList:TFPList;
    ObjTypeName:string;
    function GetCount: integer;
    function GetItems(AItem: Integer): TDBItem;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function GetEnumerator: TDBItemsEnumerator;
    function Add(AObjectName:string):TDBItem;
    property Count:integer read GetCount;
    property CountUse:integer read FCountUse;
    property Items[AItem:Integer]:TDBItem read GetItems; default;
  end;

  { TDBItemsEnumerator }

  TDBItemsEnumerator = class
  private
    FList: TDBItems;
    FPosition: Integer;
  public
    constructor Create(AList: TDBItems);
    function GetCurrent: TDBItem;
    function MoveNext: Boolean;
    property Current: TDBItem read GetCurrent;
  end;

  { TDBObjectsItems }

  TDBObjectsItems = class
  private
    FList:TFPList;
    function GetItems(const ObjTypeName: string): TDBItems;
    function DoFindObjItem(const ObjTypeName: string):TDBItems;
  protected
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    function AddTypes(const AObjTypeName:string):TDBItems;
    procedure RelaseTypes(const AObjTypeName:string);
    property Items[ObjTypeName:string]:TDBItems read GetItems;default;
  end;


function DoFormatName(const AName:string; aQute:boolean = false):string;
function sysConfirmCompileDescEx:TSqlExecParams;
function sysConfirmCompileGrantsEx:TSqlExecParams;
function FormatStringCase(const AStr:string; ACharCase:TCharCaseOptions):string;
procedure FBDataSetAfterOpen(DS:TDataSet);
function DBIsValidIdent(const Ident: string): Boolean;

implementation
uses LazUTF8, fbmToolsUnit;
(*
procedure FreeDBSQLObjectList(First: PDBSQLObject);
var
  Next:PDBSQLObject;
begin
  while Assigned(First) do
  begin
    Next:=First^.NextObj;
    Dispose(First);
    First:=Next;
  end;
end;
*)
function DoFormatName(const AName:string; aQute:boolean = false):string;
var
  FLoCase, FHiCase: Boolean;
  i: Integer;
begin
  FLoCase:=false;
  FHiCase:=false;
  for i:=1 to Length(AName) do
  begin
    if (AName[i]>#127) or (AName[i] = '"') then
      aQute:=true
    else
    if AName[i] in ['a'..'z'] then
      FLoCase:=true
    else
    if AName[i] in ['A'..'Z'] then
      FHiCase:=true;
  end;

  if FLoCase and FHiCase then
    aQute:=true;

  if aQute then
    Result:=AnsiQuotedStr(AName, '"')
  else
    Result:=AName;
end;

function sysConfirmCompileDescEx: TSqlExecParams;
begin
  if ConfigValues.ByNameAsBoolean('sysConfirmCompileDesc', true) then
    Result:=[sepShowCompForm]
  else
    Result:=[]
end;

function sysConfirmCompileGrantsEx: TSqlExecParams;
begin
  if ConfigValues.ByNameAsBoolean('sysConfirmCompileGrants', true) then
    Result:=[sepShowCompForm]
  else
    Result:=[]
end;

function FormatStringCase(const AStr: string; ACharCase: TCharCaseOptions
  ): string;
begin
  case ACharCase of
    ccoUpperCase:Result:=UTF8UpperCase(AStr);
    ccoLowerCase:Result:=UTF8LowerCase(AStr);
    ccoNameCase, { TODO : Тут надо реализовать процедуру UTF8NameCase, пока переводим только первый символ }
    ccoFirstLetterCase:Result:=UTF8UpperCase(UTF8Copy(AStr, 1, 1)) + UTF8LowerCase(UTF8Copy(AStr, 2, Length(AStr)));
  else
    Result:=AStr;
  end;
end;

procedure FBDataSetAfterOpen(DS:TDataSet);
var
  i:integer;
  F:TField;
begin
  for i:=0 to DS.Fields.Count - 1 do
  begin
    F:=DS.Fields[i];
    case F.DataType of
      ftFloat: if (ConfigValues.ByNameAsString('goffNumeric', '')<>'') then (F as TFloatField).DisplayFormat:=ConfigValues.ByNameAsString('goffNumeric', '');
      ftDate: if (ConfigValues.ByNameAsString('goffDate', '')<>'') then (F as TDateTimeField).DisplayFormat:=ConfigValues.ByNameAsString('goffDate', '');
      ftTime: if (ConfigValues.ByNameAsString('goffTime', '')<>'') then (F as TDateTimeField).DisplayFormat:=ConfigValues.ByNameAsString('goffTime', '');
      ftTimeStamp: if (ConfigValues.ByNameAsString('goffTimeStamp', '')<>'') then (F as TDateTimeField).DisplayFormat:=ConfigValues.ByNameAsString('goffTimeStamp', '');
    end;
  end;
end;

function DBIsValidIdent(const Ident: string): Boolean;
const
  Alpha = ['A'..'Z', 'a'..'z', '_'];
  AlphaNum = Alpha + ['0'..'9', '$'];
  Dot = '.';
var
  First: Boolean;
  I, Len: Integer;
begin
  Len := Length(Ident);
  if Len < 1 then Exit(False);
  First := True;
  for I := 1 to Len do
  begin
    if First then
    begin
      Result := Ident[I] in Alpha;
      First := False;
    end
    else
      Result := Ident[I] in AlphaNum;
    if not Result then
      Break;
  end;
end;

{ TDBItemsEnumerator }

constructor TDBItemsEnumerator.Create(AList: TDBItems);
begin
  FList := AList;
  FPosition := -1;
end;

function TDBItemsEnumerator.GetCurrent: TDBItem;
begin
  Result := FList[FPosition];
end;

function TDBItemsEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TDBObjectsItem }

function TDBItems.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TDBItems.GetItems(AItem: Integer): TDBItem;
begin
  Result:=TDBItem(FList[AItem]);
end;

constructor TDBItems.Create;
begin
  inherited Create;
  FList:=TFPList.Create;
end;

destructor TDBItems.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TDBItems.Clear;
var
  i: Integer;
begin
  for i:=0 to FList.Count-1 do
    TDBItem(FList[i]).Free;
  FList.Clear;
end;

function TDBItems.GetEnumerator: TDBItemsEnumerator;
begin
  Result:=TDBItemsEnumerator.Create(Self);
end;

function TDBItems.Add(AObjectName: string): TDBItem;
begin
  Result:=TDBItem.Create;
  FList.Add(Result);
  Result.ObjName:=AObjectName;
end;

{ TDBObjectsItems }

function TDBObjectsItems.GetItems(const ObjTypeName: string): TDBItems;
begin
  Result:=DoFindObjItem(ObjTypeName);
end;

function TDBObjectsItems.DoFindObjItem(const ObjTypeName: string): TDBItems;
var
  i:integer;
begin
  Result:=nil;
  for i:=0 to FList.Count - 1 do
    if TDBItems(FList[i]).ObjTypeName = ObjTypeName then
    begin
      Result:=TDBItems(FList[i]);
      exit;
    end;
end;

procedure TDBObjectsItems.Clear;
var
  i: Integer;
begin
  for i:=0 to FList.Count-1 do
    TDBItems(FList[i]).Free;
  FList.Clear;
end;

function TDBObjectsItems.AddTypes(const AObjTypeName: string): TDBItems;
begin
  Result:=DoFindObjItem(AObjTypeName);
  if not Assigned(Result) then
  begin
    Result:=TDBItems.Create;
    Result.ObjTypeName:=AObjTypeName;
    FList.Add(Result);
  end;
  Inc(Result.FCountUse);
end;

procedure TDBObjectsItems.RelaseTypes(const AObjTypeName: string);
var
  P: TDBItems;
begin
  P:=DoFindObjItem(AObjTypeName);
  if Assigned(P) then
  begin
    Dec(P.FCountUse);
    if P.FCountUse<=0 then
    begin
      P.FCountUse:=0;
      P.Clear;
    end;
  end
{$IFDEF DEBUG}
  else
    raise Exception.CreateFmt('Cashed object %s not found.', [AObjTypeName]);
{$ENDIF}
end;

constructor TDBObjectsItems.Create;
begin
  inherited Create;
  FList:=TFPList.Create;
end;

destructor TDBObjectsItems.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

end.

