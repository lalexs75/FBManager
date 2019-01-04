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


unit sqlite3_SQLTextUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, StrHolder;

type

  { Tsqlite3_SQLText }

  Tsqlite3_SQLText = class(TDataModule)
    sqlTables: TStrHolder;
    StrHolder2: TStrHolder;
  private

  public

  end;


function sqlite3Text: Tsqlite3_SQLText;
implementation
uses CustApp;

{$R *.lfm}

var
  Fsqlite3_SQLText: Tsqlite3_SQLText = nil;

function sqlite3Text: Tsqlite3_SQLText;
begin
  if not Assigned(Fsqlite3_SQLText) then
    Fsqlite3_SQLText:=Tsqlite3_SQLText.Create(CustomApplication);
  Result:=Fsqlite3_SQLText;
end;

end.

