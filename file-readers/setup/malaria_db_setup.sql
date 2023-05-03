 
 
-- create database
CREATE DATABASE malariadb_dev;

-- connect to the database, i.e. set the current database to the one just created:
\connect malariadb_dev;


-- create and populate db objects	
CREATE TABLE env_info(
	id 	varchar(15) not null primary key, 
	date_created 	timestamp default now(),
	descr 		varchar(255),
	is_active 	char(1) default 1 
);

INSERT INTO env_info(id, descr)
VALUES
(
'LOCAL_POSTGRES', 
'DEV - Postgres database running on local Docker instance'
);


create table load_stats (
  load_id integer not null GENERATED ALWAYS AS IDENTITY,
  descr varchar(255),
  load_timestamp timestamptz  not null default now(),  
  file_path varchar(255),
  completed boolean not null,
  num_records integer not null,
  bad_data_count integer not null default 0, 
  warning_data_count integer default 0,
  error_message varchar(255)
);



CREATE TABLE cases_reported_complete(
  load_id integer not null,
  record_number int not null, --line number from the file
	country varchar(255) not null, 
	year 	integer not null, 
	num_cases integer not null, 
	num_deaths integer not null,
	region varchar(255) not null
);


-- insert bad data here, use varchar for all columsn 
-- because some data may be invalid and fail conversion
CREATE TABLE cases_reported_bad(
  load_id integer not null,
  record_number int not null, --line number from the file
	country varchar(255), 
	year 	varchar(255), 
	num_cases varchar(255), 
	num_deaths varchar(255),
	region varchar(255)
);

create table data_issues_details(
  load_id integer not null,
  record_number int not null, --line number from the file
  column_name varchar(255),
  issue varchar(255) not null
)
