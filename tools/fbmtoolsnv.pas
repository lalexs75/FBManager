{ Free DB Manager

  Copyright (C) 2005-2020 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fbmToolsNV;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils;

function StrToFloatExDef(ANum:string; ADefValue:Double):Double;
function FloatToStrEx(ANum:Double):string;

function ValidInteger(const S: string): boolean;
function ValidFloat(const S: string): boolean;
implementation

function FloatToStrEx(ANum: Double): string;
begin
  if Trunc(ANum) = ANum then
    Str(Trunc(ANum), Result)
  else
    Str(ANum:15:4, Result);
  Result:=Trim(Result);
end;

function ValidInteger(const S: string): boolean;
var
  R, Code:Integer;
begin
  Val(Trim(S), R, Code);
  Result:=Code = 0;
end;

function ValidFloat(const S: string): boolean;
var
  Code:Integer;
  R:Double;
begin
  Val(Trim(S), R, Code);
  Result := Code = 0;
end;

function StrToFloatExDef(ANum: string; ADefValue: Double): Double;
var
  Code:Integer;
begin
  Val(ANum, Result, Code);
  if Code<>0 then
    Result:=ADefValue;
end;
end.

