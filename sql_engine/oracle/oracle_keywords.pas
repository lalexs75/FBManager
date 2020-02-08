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

unit oracle_keywords;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineCommonTypesUnit;

const
  CountKeyWords      = 27;
  CountKeyFunctions  = 79;


type
  TKeywordRecord = record
    Key:string;
  end;

  TKeywordRecords = array [0..CountKeyWords-1] of TKeywordRecord;
//  TKeyFunctionRecords = array [0..CountKeyFunctions-1] of TKeywordRecord;

function CreateOraKeyWords:TKeywordList;
//function CreateFBKeyFunctions:TKeywordList;

implementation
const
  OraKeywords : TKeywordRecords =
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

function CreateOraKeyWords: TKeywordList;
var
  i:integer;
begin
  Result:=TKeywordList.Create(ktKeyword);
  for i:= 0 to CountKeyWords-1 do
    Result.Add(OraKeywords[i].Key, stKeyword);
end;

end.

