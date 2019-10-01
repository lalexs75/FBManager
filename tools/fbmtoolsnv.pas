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

