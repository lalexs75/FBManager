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

unit oracle_Sql_Lines_Unit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils; 

const
//users
  sql_ora_UserList =
         'select '+
         '  ALL_USERS.USERNAME, '+
         '  ALL_USERS.USER_ID '+
         'from '+
         '  ALL_USERS '+
         'order by '+
         '  ALL_USERS.USERNAME';

//Tables
  sql_ora_TablesList =
         'select '+
         '  * '+
         'from '+
         '  ALL_TABLES '+
         'order by '+
         '  ALL_TABLES.OWNER, '+
         '  ALL_TABLES.TABLE_NAME';

//Table fileds
  sql_ora_RelationFields =
         'select '+
//         '  OWNER, '+
//         '  TABLE_NAME, '+
         '  COLUMN_NAME, '+
         '  DATA_TYPE, '+
         '  DATA_TYPE_MOD, '+
         '  DATA_TYPE_OWNER, '+
         '  DATA_LENGTH, '+
         '  DATA_PRECISION, '+
         '  DATA_SCALE, '+
         '  NULLABLE, '+
         '  COLUMN_ID, '+
         '  DEFAULT_LENGTH, '+
         '  DATA_DEFAULT, '+
         '  NUM_DISTINCT, '+
         '  LOW_VALUE, '+
         '  HIGH_VALUE, '+
         '  DENSITY, '+
         '  NUM_NULLS, '+
         '  NUM_BUCKETS, '+
         '  LAST_ANALYZED, '+
         '  SAMPLE_SIZE, '+
         '  CHARACTER_SET_NAME, '+
         '  CHAR_COL_DECL_LENGTH, '+
         '  GLOBAL_STATS, '+
         '  USER_STATS, '+
         '  AVG_COL_LEN, '+
         '  CHAR_LENGTH, '+
         '  CHAR_USED, '+
         '  V80_FMT_IMAGE '+
//         '  DATA_UPGRADED '+
         'from '+
         '  ALL_TAB_COLUMNS '+
         'where '+
         '    ALL_TAB_COLUMNS.TABLE_NAME = :TABLE_NAME '+
         '  and '+
         '    ALL_TAB_COLUMNS.OWNER = :OWNER '+
         'order by '+
         '  ALL_TAB_COLUMNS.COLUMN_ID';

//Sequences
  sql_ora_SequencesList =
         'select '+
         '  * '+
         'from '+
         '  ALL_SEQUENCES '+
         'order by '+
         '  ALL_SEQUENCES.SEQUENCE_OWNER, '+
         '  ALL_SEQUENCES.SEQUENCE_NAME';

//Views
  sql_ora_ViewsList =
         'select '+
         '  ALL_VIEWS.OWNER, '+
         '  ALL_VIEWS.VIEW_NAME '+
         'from '+
         '  ALL_VIEWS '+
         'order by '+
         '  ALL_VIEWS.OWNER, '+
         '  ALL_VIEWS.VIEW_NAME';

//Triggers
  sql_ora_TriggersList =
         'select '+
         '  ALL_TRIGGERS.OWNER, '+
         '  ALL_TRIGGERS.TRIGGER_NAME, '+
         '  ALL_TRIGGERS.TABLE_NAME '+
         'from '+
         '  ALL_TRIGGERS '+
         'order by '+
         '  ALL_TRIGGERS.OWNER, '+
         '  ALL_TRIGGERS.TRIGGER_NAME';

implementation

end.

