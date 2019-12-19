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

unit pg_sql_lines_unit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils; 

const
  DummyPGPartitionSectionName = '%TABLE_NAME%_section_%COUNT%';
  DummyPGPartitionSectionDesc = 'Section of %TABLE_NAME%';
//Запросы на выборку метаданных
const
  sql_PG_UserParams =
                  'select '+
                  '  pg_user.usesysid, '+    // int4	 	User ID (arbitrary number used to reference this user)
                  '  pg_user.usename, '+     // name	 	User name
                  '  pg_user.usecreatedb, '+ // bool	 	User may create databases
                  '  pg_user.usesuper, '+    // bool	 	User is a superuser
                  '  pg_user.usecatupd, '+   // bool	 	User may update system catalogs. (Even a superuser may not do this unless this column is true.)
                  '  cast(pg_user.valuntil as timestamp) as valuntil '+    // abstime	 	Password expiry time (only used for password authentication)
                  'from '+
                  '  pg_user '+
                  'where '+
                  '  pg_user.usename = :usename';

  sql_PG_ACLTables =
                  'select '+
                  '  cast(array_dims(pg_class.relacl) as varchar(20)) as name_dims '+
                  'from '+
                  '  pg_class '+
                  'where '+
                  '  (pg_class.oid  = :oid)';
const
  DummyPGTriggerText =
      'declare'+LineEnding+
      '  variable_name datatype;'+LineEnding +
      'begin'+LineEnding+
      '  statements;'+LineEnding+
      '  return new;'+LineEnding+
      '  exception'+LineEnding+
      '    when exception_name then'+LineEnding+
      '       statements;'+LineEnding+
      'end;';

const
  DummyAIPGTriggerText =
      'begin'+LineEnding+
      '    if (new.%FIELD_NAME% is null) then' + LineEnding +
      '      new.%FIELD_NAME% = NEXTVAL(''%GENERATOR_NAME%'');' + LineEnding +
      '    end if;'+LineEnding +
      '  return new;'+LineEnding +
      'end;';
const
  DummyPGFunctionText =
      'declare'+LineEnding+
      '  variable_name datatype;'+LineEnding +
      'begin'+LineEnding+
      '  statements;'+LineEnding+LineEnding+
      '  exception'+LineEnding+
      '    when exception_name then'+LineEnding+
      '       statements;'+LineEnding+
      'end;';

const
  DummyPGFunctionTextLazy =
      'begin'+LineEnding+
      '  statements;'+LineEnding+LineEnding+
      '  exception'+LineEnding+
      '    when exception_name then'+LineEnding+
      '       statements;'+LineEnding+
      'end;';

implementation

end.


