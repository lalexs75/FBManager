
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
