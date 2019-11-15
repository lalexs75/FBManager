
/*------  31.07.2019 08:47:15 ------*/

CREATE TABLE db_connection_options(
  db_database_id INTEGER,
  db_connection_options_name VARCHAR(100),
  db_connection_options_value VARCHAR(500),
 PRIMARY KEY (db_database_id, db_connection_options_name)

 CONSTRAINT fk_db_connection_options_1 FOREIGN KEY (db_database_id) REFERENCES db_database (db_database_id) ON UPDATE CASCADE ON DELETE CASCADE
);

/*------  01.08.2019 16:28:53 ------*/

ALTER TABLE db_database ADD COLUMN show_child_objects BOOLEAN;

/*------  15.11.2019 13:57:31 ------*/

ALTER TABLE db_database ADD COLUMN db_database_log_script_exec_filename CHAR(250) /* Протоколирование исполнения скриптов */;

/*------  15.11.2019 14:05:54 ------*/

ALTER TABLE db_database ADD COLUMN db_database_use_log_script_exec BOOLEAN /* Использовать протоколирование редактора скриптов */;
