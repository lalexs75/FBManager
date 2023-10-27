{ Free DB Manager

  Copyright (C) 2005-2023 Lagunov Aleksey  alexs75 at yandex.ru

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

unit pg_definitions;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils;
const
  //pg_trigger.h
  ///* Bits within tgtype */
  //#define TRIGGER_TYPE_ROW				(1 << 0)
  //#define TRIGGER_TYPE_BEFORE				(1 << 1)
  //#define TRIGGER_TYPE_INSERT				(1 << 2)
  //#define TRIGGER_TYPE_DELETE				(1 << 3)
  //#define TRIGGER_TYPE_UPDATE				(1 << 4)
  //#define TRIGGER_TYPE_TRUNCATE			(1 << 5)
  //#define TRIGGER_TYPE_INSTEAD			(1 << 6)

  pg_TRIGGER_TYPE_ROW              = 1 shl 0;
  pg_TRIGGER_TYPE_BEFORE           = 1 shl 1;
  pg_TRIGGER_TYPE_INSERT           = 1 shl 2;
  pg_TRIGGER_TYPE_DELETE           = 1 shl 3;
  pg_TRIGGER_TYPE_UPDATE           = 1 shl 4;
  pg_TRIGGER_TYPE_TRUNCATE         = 1 shl 5;
  pg_TRIGGER_TYPE_INSTEAD          = 1 shl 6;

implementation

end.

