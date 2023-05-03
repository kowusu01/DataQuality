
-- connect to the database, i.e. set the current database to the one just created:
\connect malariadb_dev;

set AUTOCOMMIT ON;

delete from data_issues_details;
delete from cases_reported_bad;
delete from cases_reported_complete;
delete from load_stats;