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
unit mysql_types;

{$mode objfpc}

interface

uses
  Classes, SysUtils;

type
  TMySQLServerVersion = (myUnknow,  myVersion4_0, myVersion4_1, myVersion5_0, myVersion5_1, myVersion5_5, myVersion5_6, myVersion5_7,
     maryVersion5_1, maryVersion5_2, maryVersion5_3, maryVersion5_5, maryVersion10_0, maryVersion10_1, maryVersion10_2);

const
  ssql_My_FKDrop  =          'ALTER TABLE %s DROP FOREIGN KEY %s';
  ssql_My_FKNew   =          'ALTER TABLE %s ADD CONSTRAINT %s FOREIGN KEY (%s) REFERENCES %s(%s)';
  ssql_My_IndDrop =          'ALTER TABLE %s DROP INDEX %s';
  ssql_My_IndNew  =          'ALTER TABLE %s ADD %s INDEX %s (%s) COMMENT ''''';
  ssql_My_TrgDrop =          'DROP TRIGGER %s';
  ssql_My_TableDrop =        'DROP TABLE %s';

  MySQLServerVersionNames : array [TMySQLServerVersion] of string =
    ('Unknow', //myUnknow,
     'MySQL version 4.0', //myVersion4_0,
     'MySQL version 4.1', //myVersion4_1,
     'MySQL version 5.0', //myVersion5_0,
     'MySQL version 5.1', //myVersion5_1,
     'MySQL version 5.5', //myVersion5_5,
     'MySQL version 5.6', //myVersion5_6,
     'MySQL version 5.7', //myVersion5_7,
     'MariaDB version 5.1', //maryVersion5_1,
     'MariaDB version 5.2', //maryVersion5_2,
     'MariaDB version 5.3', //maryVersion5_3,
     'MariaDB version 5.5', //maryVersion5_5,
     'MariaDB version 10.0', //maryVersion10_0,
     'MariaDB version 10.1', //maryVersion10_1,
     'MariaDB version 10.2' //maryVersion10_2);
  );

implementation

end.

