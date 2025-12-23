{ Free DB Manager

  Copyright (C) 2005-2025 Lagunov Aleksey  alexs75 at yandex.ru

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

unit assistTypesUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils;

type
  TAssistentItemEnumerator = class;

  { TAssistentItem }

  TAssistentItem = class
  private
    FDescription: string;
    FName: string;
    FValue: string;
//    FValues: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    property Name:string read FName write FName;
    property Value:string read FValue write FValue;
    property Description:string read FDescription write FDescription;
//    property Values:TStringList read FValues;
  end;

  { TAssistentItems }

  TAssistentItems = class
  private
    FColName: string;
    FColValue: string;
    FDescription: string;
    FList:TFPList;
    function GetCount: integer;
    function GetItems(AIndex: integer): TAssistentItem; inline;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Add(AName, AValue:string):TAssistentItem;
    function GetEnumerator: TAssistentItemEnumerator;
    property Count:integer read GetCount;
    property Items[AIndex:integer]:TAssistentItem read GetItems; default;
    //
    property Description:string read FDescription write FDescription;
    property ColName:string read FColName write FColName;
    property ColValue:string read FColValue write FColValue;
  end;

  { TAssistentItemEnumerator }

  TAssistentItemEnumerator = class
  private
    FList: TAssistentItems;
    FPosition: Integer;
  public
    constructor Create(AList: TAssistentItems);
    function GetCurrent: TAssistentItem;
    function MoveNext: Boolean;
    property Current: TAssistentItem read GetCurrent;
  end;

implementation

{ TAssistentItems }

function TAssistentItems.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TAssistentItems.GetItems(AIndex: integer): TAssistentItem;
begin
  Result:=TAssistentItem(FList[AIndex]);
end;

constructor TAssistentItems.Create;
begin
  inherited Create;
  FList:=TFPList.Create;
end;

destructor TAssistentItems.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TAssistentItems.Clear;
var
  i: Integer;
begin
  for i:=0 to FList.Count-1 do
    TAssistentItem(FList[i]).Free;
  FList.Clear;
  FDescription:='';
  FColName:='';
  FColValue:='';
end;


function TAssistentItems.Add(AName, AValue: string): TAssistentItem;
begin
  Result:=TAssistentItem.Create;
  Result.Name:=AName;
  Result.FValue:=AValue;
  FList.Add(Result);
end;

function TAssistentItems.GetEnumerator: TAssistentItemEnumerator;
begin
  Result:=TAssistentItemEnumerator.Create(Self);
end;

{ TAssistentItemEnumerator }

constructor TAssistentItemEnumerator.Create(AList: TAssistentItems);
begin
  FList := AList;
  FPosition := -1;
end;

function TAssistentItemEnumerator.GetCurrent: TAssistentItem;
begin
  Result := FList[FPosition];
end;

function TAssistentItemEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

constructor TAssistentItem.Create;
begin
  inherited Create;
//  FValues:=TStringList.Create;
end;

destructor TAssistentItem.Destroy;
begin
//  FValues.Free;
  inherited Destroy;
end;

end.

