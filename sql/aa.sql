PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE db_folders( 
  /* Таблица содержит список папок с зарегистрированными БД */
  db_folders_id INTEGER PRIMARY KEY AUTOINCREMENT /* Первичный ключ */, 
  db_folders_code INTEGER /* Порядок сортировки */, 
  db_folders_name VARCHAR(100) /* Наименование папки БД*/,
  db_folders_desc TEXT /* описание папки */, 
  db_folders_expanded BOOLEAN /* Признак распахнутости папки */
);
CREATE TABLE db_database(
/* Список всех зарегистрированных БД */
  db_database_id INTEGER PRIMARY KEY AUTOINCREMENT /* Первичный ключ */,
  db_folders_id INTEGER /* Код папки */,
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
  db_database_description TEXT /* Описание БД */, 
  db_database_sort_order INTEGER /* Порядок сортировки */, 
  report_manager_folder VARCHAR(250) /* Папка, в которой находятся шаблоны отчётов */, 
  sp_editor_lazzy_mode BOOLEAN /* Ленивый режим редактора процедур */, 
  trg_editor_lazzy_mode BOOLEAN /* Ленивый режим редактора триггеров */, 
  show_system_domains BOOLEAN /* Отображать системные домены */, 
  show_system_tables BOOLEAN /* Отображать системные таблицы */, 
  show_system_views BOOLEAN /* Отображать системные представления */, 
  db_database_shedule BOOLEAN /* Использовать планировщик сервера */, 
  db_database_library_name VARCHAR(250) /* Путь к библиотеке для подключения к БД */, 
  db_database_authentication_type VARCHAR(250) /* Тип подключения к БД */, 
  db_database_auto_grant BOOLEAN /* Автоматическая раздача привилегий */, 
  db_database_use_log_meta BOOLEAN /* Использовать протоколирование изменения метаданных */, 
  db_database_use_log_editor BOOLEAN /* Использовать протоколирование редактора SQL */, 
  db_database_log_meta_filename VARCHAR(250) /* Имя файла для записи протокола */, 
  db_database_log_editor_filename VARCHAR(250) /* Имя файла для протоколирования команд SQL редактора */, 
  db_database_use_log_meta_custom_charset BOOLEAN /* Признак использования не стандарной кодировки протоколирования метаданных */, 
  db_database_log_meta_custom_charset VARCHAR(150) /* Наименование кодировки для протоколирования метаданных */, 
  db_database_use_log_write_timestamp BOOLEAN /* Запись временной метки в файл протокола */,
 CONSTRAINT fk_db_database_1 FOREIGN KEY (db_folders_id) REFERENCES db_folders (db_folders_id) ON UPDATE CASCADE ON DELETE SET NULL
);
CREATE TABLE sql_editor_folders(
/* Папки в редакторе SQL */
  sql_editor_folders_id INTEGER PRIMARY KEY AUTOINCREMENT/* Первичный ключ */,
  sql_editor_folders_name VARCHAR(100) /* Наименование папки */,
  sql_editor_folders_code INTEGER /* Порядок сортировки */,
  sql_editor_folders_desc TEXT /* Описание папки */,
  db_database_id INTEGER /* ID базы, к которой относится данная папка редактора */,
 CONSTRAINT fk_sql_editor_folders_1 FOREIGN KEY (db_database_id) REFERENCES db_database (db_database_id) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE sql_editors(
/* Таблица содержит все тексты из редаткоров запросов */
  sql_editors_id INTEGER PRIMARY KEY AUTOINCREMENT /* Первичный ключ */,
  db_database_id INTEGER /* ID базы, к которой относится данный запрос */,
  sql_editor_folders_id INTEGER /* ID папки запросов */,
  sql_editors_caption VARCHAR(250) /* Наименование запроса */,
  sql_editors_sort_order INTEGER /* Порядок сортировки */,
  sql_editors_carret_pos_x INTEGER /* Позиция курсора по X */,
  sql_editors_carret_pos_y INTEGER /* Позиция курсора по Y */,
  sql_editors_sel_start INTEGER /* Начало выделенного фрагмента */,
  sql_editors_sel_end INTEGER /* Конец выделенного фрагмента */,
  sql_editors_body TEXT /*  Текст SQL редактора */,
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
  sql_editors_history_sql_text TEXT /* Текст запроса */,
  sql_editors_history_sql_plan TEXT /* План запроса */,
 CONSTRAINT fk_sql_editors_history_1 FOREIGN KEY (db_database_id) REFERENCES db_database (db_database_id) ON UPDATE CASCADE ON DELETE CASCADE
);
COMMIT;
