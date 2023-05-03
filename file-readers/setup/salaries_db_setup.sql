
-- create database
CREATE DATABASE salariesdb_dev;

-- connect to the database, i.e. set the current database to the one just created:
\connect salariesdb_dev;


create table load_stats (
  load_id integer not null GENERATED ALWAYS AS IDENTITY,
  descr varchar(255),
  load_start_timestamp timestamptz  not null default now(),
  load_end_timestamp timestamptz  not null,
  file_path varchar(255),
  num_records integer not null,
  completed boolean not null,
  has_bad_data boolean not null,
  error_message varchar(255)
);


create table salaries_data(
  id integer not null GENERATED ALWAYS AS IDENTITY,
  name varchar(255) not null,
  dept varchar(255) not null,
  title varchar(255) not null,
  salary numeric not null
);

create table salaries_data_bad(
  id integer not null GENERATED ALWAYS AS IDENTITY,
  name varchar(255),
  dept varchar(255),
  title varchar(255),
  salary varchar(255)
);


-- create and populate db objects	
CREATE TABLE env_info(
	id 				integer not null GENERATED ALWAYS AS IDENTITY,
	item_key 		varchar(100) not null, 
	descr 			varchar(255),
	date_created 	timestamp default now()
);

INSERT INTO env_info(item_key, descr)
VALUES
(
'LOCAL_POSTGRES', 
'SALARIES_DB_DEV - Postgres database running on local Docker instance'
);

