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

unit ibmsqltextsunit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils; 

const
  //Параметры БД
  ssqlDBSelectParams =
                  'select '+
                  '  rdb$database.rdb$character_set_name '+
                  'from '+
                  '  rdb$database';

  //Запросы для таблиц

  ssqlSelectRelConstr =
                  'select '+
                  '  rdb$relation_constraints.rdb$constraint_name, '+
                  '  rdb$relation_constraints.rdb$constraint_type, '+
                  '  rdb$relation_constraints.rdb$deferrable, '+
                  '  rdb$relation_constraints.rdb$index_name, '+
                  '  rdb$relation_constraints.rdb$initially_deferred '+
                  'from '+
                  '  rdb$relation_constraints '+
                  'where '+
                  '  rdb$relation_constraints.rdb$relation_name = ''%s''';
                  
  ssqlSelectIndexSegments =
                  'select '+
                  '  rdb$index_segments.rdb$field_name '+
                  'from '+
                  '  rdb$index_segments '+
                  'where '+
                  '  rdb$index_segments.rdb$index_name = :index_name '+
                  'order by '+
                  '  rdb$index_segments.rdb$field_position';

  ssqlCountRecord =
                  'select count(*) as count_record from ';

  ssqlSelectTrigersForTable =
                  'select '+
                  '  rdb$triggers.rdb$trigger_sequence as tr_sequence, '+
                  '  rdb$triggers.rdb$trigger_type as tr_type, '+
                  '  rdb$triggers.rdb$flags as tr_flags, '+
                  '  rdb$triggers.rdb$trigger_name as tr_name, '+
                  '  rdb$triggers.rdb$trigger_inactive as tr_not_active, '+
                  '  rdb$triggers.rdb$description as tr_description '+
                  'from '+
                  '  rdb$triggers '+
                  'where '+
                  '    ( '+
                  '      (rdb$triggers.rdb$system_flag is null) '+
                  '    or '+
                  '      (rdb$triggers.rdb$system_flag = 0) '+
                  '    ) '+
                  '  and '+
                  '    (rdb$triggers.rdb$relation_name = ''%s'') '+
                  'order by '+
                  '  rdb$triggers.rdb$trigger_name ';

  ssqlIndexList =
                  'select *'+
{                  '  rdb$indices.rdb$index_name, '+
                  '  rdb$indices.rdb$unique_flag, '+
                  '  rdb$indices.rdb$index_inactive, '+
                  '  rdb$indices.rdb$statistics '+}
                  'from '+
                  '  rdb$indices '+
                  'where '+
                  '  rdb$indices.rdb$relation_name=:relation_name '+
                  'order by '+
                  '  rdb$indices.rdb$index_id';


  //Select relation descriptions (table and views)
  ssqlSelectRelDesc = 'select rdb$description from rdb$relations where rdb$relations.rdb$relation_name = :relation_name';
  
  //FireBird - Select all trigers
  ssqlSelectAllTrigers = ' select' +
                         '   rdb$triggers.rdb$trigger_name,' +
                         '   rdb$triggers.rdb$description,' +
                         '   rdb$triggers.rdb$trigger_inactive,' +
                         '   rdb$triggers.rdb$relation_name as relation_name, ' +
                         '   rdb$triggers.rdb$trigger_type,' +
                         '   rdb$triggers.rdb$trigger_sequence' +
                         ' from'+
                         '   rdb$triggers'+
                         ' where'+
                         '     (rdb$triggers.rdb$system_flag is null)'+
                         '   or'+
                         '     (rdb$triggers.rdb$system_flag = 0)'+
                         ' order by'+
                         '   rdb$triggers.rdb$trigger_name';

  //FireBird - Select current trigers
  ssqlSelectCurTriger  = ' select' +
                         '   rdb$triggers.rdb$trigger_inactive,' +
                         '   rdb$triggers.rdb$description,' +
                         '   rdb$triggers.rdb$relation_name,' +
                         '   rdb$triggers.rdb$trigger_type,' +
                         '   rdb$triggers.rdb$trigger_sequence,' +
                         '   rdb$triggers.rdb$trigger_source' +
                         ' from'+
                         '   rdb$triggers'+
                         ' where'+
                         '     (rdb$triggers.rdb$trigger_name = :trigger_name)';


  //Roles
  ssqlRoleCreate =
                  'CREATE ROLE %s';
  ssqlRoleRefresh =
                ' select '+
                '   rdb$roles.rdb$description '+
                ' from '+
                '   rdb$roles '+
                ' where '+
                '   rdb$roles.rdb$role_name = :role_name';

  ssqlRoleGrantDBObjects =
                ' select '+
                '   rdb$user_privileges.rdb$privilege, '+
                '   rdb$user_privileges.rdb$relation_name, '+
                '   rdb$user_privileges.RDB$OBJECT_TYPE '+
                ' from '+
                '   rdb$user_privileges '+
                ' where '+
                '   rdb$user_privileges.rdb$user = :role_name '+
                ' order by '+
                '   rdb$user_privileges.rdb$relation_name';


  ssqlRoleGrantToObject       = 'GRANT %s ON %s TO %s';
  ssqlRoleGrantFromObject     = 'REVOKE %s ON %s FROM %s';
  ssqlRoleGrantToObjectProc   = 'GRANT %s ON PROCEDURE %s TO %s';
  ssqlRoleGrantFromObjectProc = 'REVOKE %s ON PROCEDURE %s FROM %s';


  //UDF
  ssqlUDFRefresh =
                ' select '+
                '   RDB$FUNCTIONS.RDB$FUNCTION_TYPE, '+
                '   RDB$FUNCTIONS.RDB$QUERY_NAME, '+
                '   RDB$FUNCTIONS.RDB$DESCRIPTION, '+
                '   RDB$FUNCTIONS.RDB$MODULE_NAME, '+
                '   RDB$FUNCTIONS.RDB$ENTRYPOINT, '+
                '   RDB$FUNCTIONS.RDB$RETURN_ARGUMENT, '+
                '   RDB$FUNCTIONS.RDB$SYSTEM_FLAG '+
                ' from '+
                '   rdb$functions '+
                ' where '+
                '   rdb$functions.rdb$function_name = :function_name';

  ssqlUDFArgList =
                ' select '+
                '   RDB$FUNCTION_ARGUMENTS.RDB$ARGUMENT_POSITION, '+
                '   RDB$FUNCTION_ARGUMENTS.RDB$MECHANISM, '+
                '   RDB$FUNCTION_ARGUMENTS.RDB$FIELD_TYPE, '+
                '   RDB$FUNCTION_ARGUMENTS.RDB$FIELD_SCALE, '+
                '   RDB$FUNCTION_ARGUMENTS.RDB$FIELD_LENGTH, '+
                '   RDB$FUNCTION_ARGUMENTS.RDB$FIELD_SUB_TYPE, '+
                '   RDB$FUNCTION_ARGUMENTS.RDB$CHARACTER_SET_ID, '+
                '   RDB$FUNCTION_ARGUMENTS.RDB$FIELD_PRECISION, '+
                '   RDB$FUNCTION_ARGUMENTS.RDB$CHARACTER_LENGTH '+
                ' from '+
                '   RDB$FUNCTION_ARGUMENTS '+
                ' where '+
                '   RDB$FUNCTION_ARGUMENTS.RDB$FUNCTION_NAME = :FUNCTION_NAME '+
                ' order by '+
                '   RDB$FUNCTION_ARGUMENTS.RDB$ARGUMENT_POSITION';

  ssqlUDFDescribe = 'COMMENT ON EXTERNAL FUNCTION %S IS ''%S''';

  //Exceptions

  ssqlException =
      ' select'+
      '   rdb$exceptions.rdb$message,'+
      '   rdb$exceptions.rdb$description'+
      ' from'+
      '   rdb$exceptions'+
      ' where'+
      '   rdb$exceptions.rdb$exception_name = :exception_name';

  //Stored proc refres
  ssqlStoredProcRefresh =
                'select '+
                '  RDB$PROCEDURES.RDB$PROCEDURE_NAME, '+
                '  RDB$PROCEDURES.RDB$PROCEDURE_ID, '+
                '  RDB$PROCEDURES.RDB$PROCEDURE_INPUTS, '+
                '  RDB$PROCEDURES.RDB$PROCEDURE_OUTPUTS, '+
                '  RDB$PROCEDURES.RDB$DESCRIPTION, '+
                '  RDB$PROCEDURES.RDB$PROCEDURE_SOURCE, '+
                '  RDB$PROCEDURES.RDB$OWNER_NAME, '+
                '  RDB$PROCEDURES.RDB$SYSTEM_FLAG '+
                'from '+
                '  RDB$PROCEDURES '+
                'where '+
                '  RDB$PROCEDURES.RDB$PROCEDURE_NAME = :PROCEDURE_NAME';

    ssqlView =
                ' select *'+
{                '   RDB$RELATIONS.RDB$RELATION_NAME, '+
                '   RDB$RELATIONS.RDB$VIEW_SOURCE, '+
                '   RDB$RELATIONS.RDB$DESCRIPTION '+
                '   RDB$RELATIONS.RDB$FORMAT, '+
                '   RDB$RELATIONS.RDB$EXTERNAL_FILE, '+
                '   RDB$RELATIONS.RDB$OWNER_NAME, '+
                '   RDB$RELATIONS.RDB$FLAGS, '+
                '   RDB$RELATIONS.RDB$RELATION_TYPE '+}
                ' from '+
                '   RDB$RELATIONS '+
                ' where '+
                '       RDB$RELATIONS.RDB$RELATION_NAME = :RELATION_NAME';


  ssqlCommit            = 'COMMIT';
  ssqlCommitRetaining   = 'COMMIT RETAINING';
  ssqlRollback          = 'ROLBACK';
  ssqlRollbackRetaining = 'ROLBACK RETAINING';


  //SQL for describe objects
    //domains
  metaDescribeDomain =
                  'update RDB$FIELDS set RDB$DESCRIPTION = ''%s'''+#13#10+'where'+#13#10+'  RDB$FIELD_NAME=''%s''';
    //exceptiosn
  metaDescribeException =
                  'update RDB$EXCEPTIONS set RDB$DESCRIPTION = %s where RDB$EXCEPTION_NAME=''%s''';
    //table fields
  metaDescribeField =
                  'update rdb$relation_fields set rdb$relation_fields.rdb$description = ''%s'' '+
                  'where (rdb$relation_fields.rdb$field_name = ''%s'') and '+
                  '(rdb$relation_fields.rdb$relation_name = ''%s'')';

   //tables
  metaDescribeTable =
                  'update rdb$relations '+
                  'set rdb$relations.rdb$description = ''%s'' '+
                  'where rdb$relations.rdb$relation_name = ''%s'' ';


   //triger
  metaDescribeTriger =
                  'update RDB$TRIGGERS set RDB$TRIGGERS.RDB$DESCRIPTION = ''%s'' where RDB$TRIGGERS.RDB$TRIGGER_NAME = ''%s''';


  ssqlAlterDomainUpdNotNull =
                  'update RDB$FIELDS set RDB$NULL_FLAG = %d where RDB$FIELD_NAME = ''%s''';
  ssqlCreateShadow =
                  'CREATE SHADOW %d';
                  
  ssqlAlterTriggerInactive
                 = 'ALTER TRIGGER %s INACTIVE';

  ssqlAlterTriggerActive
                 = 'ALTER TRIGGER %s ACTIVE';


  ssqlIndexDrop  = 'DROP INDEX %s';

  ssqlIndexNew = 'CREATE %s INDEX %s ON %s (%s)';
                         //UNIQUE

  ssqlDeleteField = 'ALTER TABLE %s DROP %s';

  ssqlSelectPkList = ' select '+
                     '   rdb$relation_constraints.rdb$constraint_name, '+
                     '   rdb$relation_constraints.rdb$constraint_type, '+
                     '   rdb$relation_constraints.rdb$index_name '+
                     ' from '+
                     '   rdb$relation_constraints '+
                     ' where '+
                     '     (rdb$relation_constraints.rdb$relation_name = :relation_name) '+
                     '   and '+
                     '     (rdb$relation_constraints.rdb$constraint_type = ''PRIMARY KEY'')';


  ssqlSetFieldPosition = 'alter table %s alter column %s position %d';

  ssqlSelectUNQList =
                    'select '+
                    '  rdb$relation_constraints.rdb$constraint_name, '+
                    '  rdb$relation_constraints.rdb$index_name '+
                    'from '+
                    '  rdb$relation_constraints '+
                    'where '+
                    '    rdb$relation_constraints.rdb$relation_name = :relation_name '+
                    '  and '+
                    '    rdb$relation_constraints.rdb$constraint_type =  ''UNIQUE'' '+
                    'order by '+
                    '  rdb$relation_constraints.rdb$constraint_name';

  ssqlUNQNew =      'alter table %s add constraint %s unique (%s)';


  //Charset and collations
  ssqlSelectDependencies =
                    'select distinct '+
                    '  RDB$DEPENDENCIES.RDB$DEPENDENT_NAME, '+
                    '  RDB$DEPENDENCIES.RDB$DEPENDENT_TYPE '+
                    'from '+
                    '  RDB$DEPENDENCIES '+
                    'where '+
                    '  (RDB$DEPENDENCIES.RDB$DEPENDED_ON_NAME = :DEPENDED_ON_NAME)';

  ssqlSelectDependenciesOn =
                    'select distinct '+
                    '  RDB$DEPENDENCIES.RDB$DEPENDED_ON_NAME, '+
                    '  RDB$DEPENDENCIES.RDB$DEPENDED_ON_TYPE '+
                    'from '+
                    '  RDB$DEPENDENCIES '+
                    'where '+
                    '  (RDB$DEPENDENCIES.RDB$DEPENDENT_NAME = :DEPENDED_ON_NAME)';

  ssqlSelectDependenciesField =
                    'select distinct '+
                    '  RDB$DEPENDENCIES.RDB$FIELD_NAME '+
                    'from '+
                    '  RDB$DEPENDENCIES '+
                    'where '+
                    '    (RDB$DEPENDENCIES.RDB$DEPENDED_ON_NAME = :DEPENDED_ON_NAME) '+
                    '  and '+
                    '    (RDB$DEPENDENCIES.RDB$FIELD_NAME <> '''') '+
                    '  and '+
                    '    (RDB$DEPENDENCIES.RDB$DEPENDENT_NAME = :DEPENDENT_NAME)';


implementation

end.

