
/*------  08.12.2016 15:54:17 ------*/

CREATE TABLE sys_const(
/* Таблица содержит системные параметры */
  sys_const_name VARCHAR(250) PRIMARY KEY/* Наименование параметра */,
  sys_const_value VARCHAR(250) /* Значение параметра */,
  sys_consts_value_type INTEGER /* Тип данных
1 - целое
2 - строка
3 - логическая
4 - дата
5 - вещественное */
);               ;

/*------  08.12.2016 15:54:22 ------*/

DROP TABLE sys_const;;

/*------  08.12.2016 15:54:33 ------*/

CREATE TABLE sys_const(
/* Таблица содержит системные параметры */
  sys_const_name VARCHAR(250) PRIMARY KEY/* Наименование параметра */,
  sys_const_value VARCHAR(250) /* Значение параметра */,
  sys_consts_value_type INTEGER /* Тип данных
1 - целое
2 - строка
3 - логическая
4 - дата
5 - вещественное */
);;

/*------  08.12.2016 15:54:38 ------*/

DROP TABLE sys_const;;

/*------  08.12.2016 15:54:41 ------*/

CREATE TABLE sys_const(
/* Таблица содержит системные параметры */
  sys_const_name VARCHAR(250) PRIMARY KEY/* Наименование параметра */,
  sys_const_value VARCHAR(250) /* Значение параметра */,
  sys_consts_value_type INTEGER /* Тип данных
1 - целое
2 - строка
3 - логическая
4 - дата
5 - вещественное */
);;

/*------  08.12.2016 16:06:38 ------*/

DROP TABLE sys_const;       ;

/*------  08.12.2016 16:06:43 ------*/

CREATE TABLE sys_const(
/* Таблица содержит системные параметры */
  sys_const_name VARCHAR(250) PRIMARY KEY/* Наименование параметра */,
  sys_const_value VARCHAR(250) /* Значение параметра */,
  sys_consts_value_type INTEGER /* Тип данных
1 - целое
2 - строка
3 - логическая
4 - дата
5 - вещественное */
);   ;

/*------  09.12.2016 13:49:45 ------*/

select
  db_folders.db_folders_id,
  db_folders.db_folders_code,
  db_folders.db_folders_name,
  db_folders.db_folders_desc,
  db_folders.db_folders_expanded
from
  db_folders
order by
  db_folders.db_folders_code

;

/*------  09.12.2016 14:07:52 ------*/

ALTER TABLE db_database ADD COLUMN db_database_sort_order INTEGER /* Порядок сортировки */;;

/*------  09.12.2016 15:43:34 ------*/

select
  db_database.db_database_id,
  db_database.db_folders_id,
  db_database.db_database_caption,
  db_database.db_database_sql_engine,
  db_database.db_database_server_name,
  db_database.db_database_database_name,
  db_database.db_database_username,
  db_database.db_database_password,
  db_database.db_database_user_role,
  db_database.db_database_connected_charset,
  db_database.db_database_server_version,
  db_database.db_database_remote_port,
  db_database.db_database_description,
  db_database.db_database_sort_order,
  db_database.report_manager_folder,
  db_database.sp_editor_lazzy_mode,
  db_database.trg_editor_lazzy_mode,
  db_database.show_system_domains,
  db_database.show_system_tables,
  db_database.show_system_views,
  db_database.db_database_shedule,
  db_database.db_database_library_name,
  db_database.db_database_authentication_type
from
  db_database
order by
  coalesce(db_database.db_folders_id, -1),
  db_database.db_database_sort_order

;

/*------  09.12.2016 15:45:25 ------*/

select
  db_database.db_database_id,
  db_database.db_folders_id,
  db_database.db_database_caption,
  db_database.db_database_sql_engine,
  db_database.db_database_server_name,
  db_database.db_database_database_name,
  db_database.db_database_username,
  db_database.db_database_password,
  db_database.db_database_user_role,
  db_database.db_database_connected_charset,
  db_database.db_database_server_version,
  db_database.db_database_remote_port,
  db_database.db_database_description,
  db_database.db_database_sort_order,
  db_database.report_manager_folder,
  db_database.sp_editor_lazzy_mode,
  db_database.trg_editor_lazzy_mode,
  db_database.show_system_domains,
  db_database.show_system_tables,
  db_database.show_system_views,
  db_database.db_database_shedule,
  db_database.db_database_library_name,
  db_database.db_database_authentication_type,
  db_database.db_database_auto_grant
from
  db_database
order by
  coalesce(db_database.db_folders_id, -1),
  db_database.db_database_sort_order

;

/*------  09.12.2016 16:12:35 ------*/

select
  sql_editors_history.sql_editors_history_id,
  sql_editors_history.db_database_id,
  sql_editors_history.sql_editors_history_param_name,
  sql_editors_history.sql_editors_history_param_value,
  sql_editors_history.sql_editors_history_param_type
from
  sql_editors_history
where
  sql_editors_history.db_database_id = :db_database_id
;

/*------  10.12.2016 14:13:49 ------*/

select
  *
from
  db_folders
;

/*------  10.12.2016 14:32:42 ------*/

select
  db_database.db_database_id,
  db_database.db_folders_id,
  db_database.db_database_caption,
  db_database.db_database_sql_engine,
  db_database.db_database_server_name,
  db_database.db_database_database_name,
  db_database.db_database_username,
  db_database.db_database_password,
  db_database.db_database_user_role,
  db_database.db_database_connected_charset,
  db_database.db_database_server_version,
  db_database.db_database_remote_port,
  db_database.db_database_description,
  db_database.db_database_sort_order,
  db_database.report_manager_folder,
  db_database.sp_editor_lazzy_mode,
  db_database.trg_editor_lazzy_mode,
  db_database.show_system_domains,
  db_database.show_system_tables,
  db_database.show_system_views,
  db_database.db_database_shedule,
  db_database.db_database_library_name,
  db_database.db_database_authentication_type,
  db_database.db_database_auto_grant,
  db_database.db_database_use_log_meta,
  db_database.db_database_use_log_editor,
  db_database.db_database_log_meta_filename,
  db_database.db_database_log_editor_filename,
  db_database.db_database_use_log_meta_custom_charset,
  db_database.db_database_log_meta_custom_charset
from
  db_database
order by
  coalesce(db_database.db_folders_id, -1),
  db_database.db_database_sort_order

;

/*------  10.12.2016 14:32:42 ------*/

select
  db_database.db_database_id,
  db_database.db_folders_id,
  db_database.db_database_caption,
  db_database.db_database_sql_engine,
  db_database.db_database_server_name,
  db_database.db_database_database_name,
  db_database.db_database_username,
  db_database.db_database_password,
  db_database.db_database_user_role,
  db_database.db_database_connected_charset,
  db_database.db_database_server_version,
  db_database.db_database_remote_port,
  db_database.db_database_description,
  db_database.db_database_sort_order,
  db_database.report_manager_folder,
  db_database.sp_editor_lazzy_mode,
  db_database.trg_editor_lazzy_mode,
  db_database.show_system_domains,
  db_database.show_system_tables,
  db_database.show_system_views,
  db_database.db_database_shedule,
  db_database.db_database_library_name,
  db_database.db_database_authentication_type,
  db_database.db_database_auto_grant,
  db_database.db_database_use_log_meta,
  db_database.db_database_use_log_editor,
  db_database.db_database_log_meta_filename,
  db_database.db_database_log_editor_filename,
  db_database.db_database_use_log_meta_custom_charset,
  db_database.db_database_log_meta_custom_charset
from
  db_database
order by
  coalesce(db_database.db_folders_id, -1),
  db_database.db_database_sort_order

;

/*------  10.12.2016 20:29:12 ------*/

select
  db_recent_objects.db_recent_objects_id,
  db_recent_objects.db_database_id,
  db_recent_objects.db_recent_objects_type,
  db_recent_objects.db_recent_objects_name,
  db_recent_objects.db_recent_objects_date
from
  db_recent_objects
where
    db_recent_objects.db_database_id = :db_database_id
  and
    db_recent_objects.db_recent_objects_type = :db_recent_objects_type
order by
  db_recent_objects.db_recent_objects_date desc
;

/*------  10.12.2016 21:08:49 ------*/

/******************************************************************************/
/**                           10.12.2016 21:07:01                            **/
/**              /home/alexs/work/FBManager/sql/fbm_meta_base.db             **/
/******************************************************************************/
CREATE TABLE db_recent_objects(
/* Последние использованные объекты в БД */
  db_recent_objects_id INTEGER PRIMARY KEY AUTOINCREMENT /* Первичный ключ */,
  db_database_id INTEGER NOT NULL /* ID базы данных */,
  db_recent_objects_type INTEGER NOT NULL /* Тип объекта
0 - открытое окно
2 - последние закрытые объекты
3 - последние файлы из редактора sql
4 - последние файлы из редактора скриптов
5 - открыто окно редактора SQL. наименование объекта не важно
*/,
  db_recent_objects_name VARCHAR(250) /* Имя последнего объекта */,
  db_recent_objects_date TIMESTAMP /* Дата и время последнего обращения */,
 CONSTRAINT fk_db_recent_objects_1 FOREIGN KEY (db_database_id) REFERENCES db_database (db_database_id) ON UPDATE CASCADE ON DELETE CASCADE
);
;

/*------  10.12.2016 22:17:08 ------*/

select
  sql_editors.sql_editors_id,
  sql_editors.db_database_id,
  sql_editors.sql_editor_folders_id,
  sql_editors.sql_editors_caption,
  sql_editors.sql_editors_sort_order,
  sql_editors.sql_editors_carret_pos_x,
  sql_editors.sql_editors_carret_pos_y,
  sql_editors.sql_editors_sel_start,
  sql_editors.sql_editors_sel_end,
  sql_editors.sql_editors_body
from
  sql_editors
where
  sql_editors.db_database_id = :db_database_id
order by
  sql_editors.sql_editor_folders_id,
  sql_editors.sql_editors_sort_order

;

/*------  10.12.2016 22:18:47 ------*/

select
  sql_editor_folders.sql_editor_folders_id,
  sql_editor_folders.sql_editor_folders_name,
  sql_editor_folders.sql_editor_folders_code,
  sql_editor_folders.sql_editor_folders_desc,
  sql_editor_folders.db_database_id
from
  sql_editor_folders
where
  sql_editor_folders.db_database_id = :db_database_id
order by
  sql_editor_folders.sql_editor_folders_code

;
