 
 
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

CREATE TABLE cases_reported(
	country varchar(255), 
	yr 	numeric, 
	num_cases numeric, 
	num_deaths numeric,
	region varchar(255)
);

