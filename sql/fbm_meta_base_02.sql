
/*------  07.12.2016 14:23:02 ------*/

CREATE TABLE db_folders(
  db_folders_id INTEGER PRIMARY KEY AUTOINCREMENT,
  db_folders_code INTEGER /* Используем для сортировки */,
  db_folders_name VARCHAR(100) /* Наименование папки */,
  db_folders_desc BLOB /* Описание папки */
);


/*------  07.12.2016 14:43:30 ------*/

CREATE TABLE db_database(
/* Список всех зарегистрированных БД */
  db_database_id INTEGER PRIMARY KEY AUTOINCREMENT /* Первичный ключ */,
  db_folders_id INTEGER,
  db_database_caption VARCHAR(250) NOT NULL /* Наименование БД */,
  db_database_sql_engine VARCHAR(100) NOT NULL /* Наименование движка БД */,
  db_database_server_name VARCHAR(250) /* Наименование сервера */,
  db_database_database_name VARCHAR(250) NOT NULL /* Наименование БД */,
  db_database_username VARCHAR(200) /* Имя пользователя */,
  db_database_password VARCHAR(200) /* Пароль подключения */,
  db_database_user_role VARCHAR(200) /* Роль подключения */,
  db_database_connected_charset VARCHAR(100) /* Набор символов для подключения к БД */,
  db_database_server_version VARCHAR(100) /* Строка версии сервера */,
  db_database_remote_port INTEGER /* Сетевой порт для подключения */,
  db_database_description BLOB /* Описание БД */,
 CONSTRAINT fk_db_database_1 FOREIGN KEY (db_folders_id) REFERENCES db_folders (db_folders_id) ON UPDATE CASCADE ON DELETE SET NULL
);

/*------  07.12.2016 15:22:42 ------*/

CREATE TABLE sql_editor_folders(
/* Папки в редакторе SQL */
  sql_editor_folders_id INTEGER PRIMARY KEY /* Первичный ключ */,
  sql_editor_folders_name VARCHAR(100) /* Наименование папки */,
  sql_editor_folders_code INTEGER /* Порядок сортировки */,
  sql_editor_folders_desc BLOB /* Описание папки */,
  db_database_id INTEGER /* ID базы, к которой относится данная папка редактора */,
 CONSTRAINT fk_sql_editor_folders_1 FOREIGN KEY (db_database_id) REFERENCES db_database (db_database_id) ON UPDATE CASCADE ON DELETE CASCADE
);

/*------  07.12.2016 15:28:45 ------*/

CREATE TABLE sql_editors(
/* Таблица содержит все тексты из редаткоров запросов */
  sql_editors_id INTEGER PRIMARY KEY AUTOINCREMENT /* Первичный ключ */,
  db_database_id INTEGER /* ID базы, к которой относится данный запрос */,
  sql_editor_folders_id INTEGER /* ID папки запросов */,
  sql_editors_caption VARCHAR(250) /* Наименование запроса */,
  sql_editors_sort_order VARCHAR /* Порядок сортировки */,
  sql_editors_carret_pos_x INTEGER /* Позиция курсора по X */,
  sql_editors_carret_pos_y INTEGER /* Позиция курсора по Y */,
  sql_editors_sel_start INTEGER /* Начало выделенного фрагмента */,
  sql_editors_sel_end INTEGER /* Конец выделенного фрагмента */,
  sql_editors_body BLOB /*  Текст SQL редактора */,
 CONSTRAINT fk_sql_editors_1 FOREIGN KEY (db_database_id) REFERENCES db_database (db_database_id) ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT fk_sql_editors_2 FOREIGN KEY (sql_editor_folders_id) REFERENCES sql_editor_folders (sql_editor_folders_id) ON UPDATE CASCADE ON DELETE SET NULL
);

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
);

/*------  09.12.2016 11:32:25 ------*/

ALTER TABLE db_folders ADD COLUMN db_folders_expanded BOOLEAN;

ALTER TABLE db_database ADD COLUMN db_database_sort_order INTEGER /* Порядок сортировки */;
/*------  09.12.2016 14:32:26 ------*/

ALTER TABLE db_database ADD COLUMN report_manager_folder VARCHAR(250) /* Папка, в которой находятся шаблоны отчётов */;

/*------  09.12.2016 14:33:59 ------*/

ALTER TABLE db_database ADD COLUMN sp_editor_lazzy_mode BOOLEAN /* Ленивый режим редактора процедур */;

/*------  09.12.2016 14:34:22 ------*/

ALTER TABLE db_database ADD COLUMN trg_editor_lazzy_mode BOOLEAN /* Ленивый режим редактора триггеров */;

/*------  09.12.2016 14:35:29 ------*/

ALTER TABLE db_database ADD COLUMN show_system_domains BOOLEAN /* Отображать системные домены */;

/*------  09.12.2016 14:36:47 ------*/

ALTER TABLE db_database ADD COLUMN show_system_tables BOOLEAN /* Отображать системные таблицы */;

/*------  09.12.2016 14:37:08 ------*/

ALTER TABLE db_database ADD COLUMN show_system_views BOOLEAN /* Отображать системные представления */;

/*------  09.12.2016 15:40:06 ------*/

ALTER TABLE db_database ADD COLUMN db_database_shedule BOOLEAN /* Использовать планировщик сервера */;

/*------  09.12.2016 15:41:01 ------*/

ALTER TABLE db_database ADD COLUMN db_database_library_name VARCHAR(250) /* Путь к библиотеке для подключения к БД */;

/*------  09.12.2016 15:43:23 ------*/

ALTER TABLE db_database ADD COLUMN db_database_authentication_type VARCHAR(250) /* Тип подключения к БД */;

/*------  09.12.2016 15:45:16 ------*/

ALTER TABLE db_database ADD COLUMN db_database_auto_grant BOOLEAN /* Автоматическая раздача привилегий */;

/*------  09.12.2016 16:01:34 ------*/

CREATE TABLE sql_editors_history(
/* Таблица истории параметров запросов */
  sql_editors_history_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT /* Первичный ключ */,
  db_database_id INTEGER NOT NULL /* Код базы данных */,
  sql_editors_history_param_name VARCHAR(250) /* Наименование параметра запроса */,
  sql_editors_history_param_value VARCHAR(500) /* Значение параметра истории */,
  sql_editors_history_param_type INTEGER /* Тип параметра
1 - целое
2 - строка
3 - логическая
4 - дата
5 - вещественное */,
 CONSTRAINT fk_sql_editors_history_1 FOREIGN KEY (db_database_id) REFERENCES db_database (db_database_id) ON UPDATE CASCADE ON DELETE CASCADE
);

/*------  10.12.2016 14:17:46 ------*/

ALTER TABLE db_database ADD COLUMN db_database_use_log_meta BOOLEAN /* Использовать протоколирование изменения метаданных */;

/*------  10.12.2016 14:18:43 ------*/

ALTER TABLE db_database ADD COLUMN db_database_use_log_editor BOOLEAN /* Использовать протоколирование редактора SQL */;

/*------  10.12.2016 14:19:21 ------*/

ALTER TABLE db_database ADD COLUMN db_database_log_meta_filename VARCHAR(250) /* Имя файла для записи протокола */;

/*------  10.12.2016 14:20:00 ------*/

ALTER TABLE db_database ADD COLUMN db_database_log_editor_filename VARCHAR(250) /* Имя файла для протоколирования команд SQL редактора */;

/*------  10.12.2016 14:21:05 ------*/

ALTER TABLE db_database ADD COLUMN db_database_use_log_meta_custom_charset BOOLEAN /* Признак использования не стандарной кодировки протоколирования метаданных */;

/*------  10.12.2016 14:21:42 ------*/

ALTER TABLE db_database ADD COLUMN db_database_log_meta_custom_charset VARCHAR(150) /* Наименование кодировки для протоколирования метаданных */;

/*------  10.12.2016 14:37:26 ------*/

ALTER TABLE db_database ADD COLUMN db_database_use_log_write_timestamp BOOLEAN /* Запись временной метки в файл протокола */;

/*------  10.12.2016 20:20:38 ------*/

CREATE TABLE db_recent_objects(
/* Последние использованные объекты в БД */
  db_recent_objects_id INTEGER PRIMARY KEY AUTOINCREMENT /* Первичный ключ */,
  db_database_id INTEGER NOT NULL /* ID базы данных */,
  db_recent_objects_type INTEGER NOT NULL /* Тип объекта
0 - открытое окно
2 - последние закрытые объекты
3 - последние файлы из редактора sql
4 - последние файлы из редактора скриптов */,
  db_recent_objects_name VARCHAR(250) /* Имя последнего объекта */,
  db_recent_objects_date TIMESTAMP /* Дата и время последнего обращения */,
 CONSTRAINT fk_db_recent_objects_1 FOREIGN KEY (db_database_id) REFERENCES db_database (db_database_id) ON UPDATE CASCADE ON DELETE CASCADE
);

/*------  10.12.2016 21:07:18 ------*/

DROP TABLE db_recent_objects;


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

/*------  10.12.2016 21:50:30 ------*/

CREATE TABLE sql_editors_history_param(
/* Таблица истории параметров запросов */
  sql_editors_history_param_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT /* Первичный ключ */,
  db_database_id INTEGER NOT NULL /* ID базы данных */,
  sql_editors_history_param_name VARCHAR(250) NOT NULL /* Наименование параметра */,
  sql_editors_history_param_value VARCHAR(250) /* Значение параметра */,
  sql_editors_history_param_type INTEGER NOT NULL /* Тип параметра
1 - целое
2 - строка
3 - логическая
4 - дата
5 - вещественное */,
 CONSTRAINT fk_sql_editors_history_param_1 FOREIGN KEY (db_database_id) REFERENCES db_database (db_database_id) ON UPDATE CASCADE ON DELETE CASCADE
);

/*------  10.12.2016 21:52:39 ------*/

DROP TABLE sql_editors_history;

/*------  10.12.2016 22:00:40 ------*/

CREATE TABLE sql_editors_history(
/* Таблица содержит историю запросов */
  sql_editors_history_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT /* Первичный ключ */,
  db_database_id INTEGER NOT NULL /* ID базы данных */,
  sql_editors_history_date TIMESTAMP /* Дата и время выполнения запроса */,
  sql_editors_history_sql_type INTEGER /* Тип запроса
  0 - select,
  1 - ins,
  2 - upd,
  3 - del */,
  sql_editors_history_exec_time TIME /* Время выполнения запроса */,
  sql_editors_history_sql_page_name VARCHAR(250) /* Имя страницы, с которой был запущен запрос */,
  sql_editors_history_sql_text BLOB /* Текст запроса */,
  sql_editors_history_sql_plan BLOB /* План запроса */,
 CONSTRAINT fk_sql_editors_history_1 FOREIGN KEY (db_database_id) REFERENCES db_database (db_database_id) ON UPDATE CASCADE ON DELETE CASCADE
);

/*------  05.04.2019 15:34:43 ------*/

CREATE TABLE db_connection_plugin_data(
/* Информация подключаемых модулей */
  db_database_id INTEGER /* ID базы данных */,
  db_connection_plugin_data_class_type VARCHAR(255) /* Тип плагина */,
  db_connection_plugin_data_variable_name VARCHAR(150) /* Имя переменной */,
  db_connection_plugin_data_variable_value VARCHAR(255) /* Значение переменной */,
 PRIMARY KEY (db_database_id, db_connection_plugin_data_class_type, db_connection_plugin_data_variable_name) CONSTRAINT fk_db_connection_plugin_data_1 FOREIGN KEY (db_database_id) REFERENCES db_database (db_database_id) ON UPDATE CASCADE ON DELETE CASCADE
);
