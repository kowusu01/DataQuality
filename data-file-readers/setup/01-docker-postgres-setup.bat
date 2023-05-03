
rem remove the image to start from scratch
 docker stop postgres-instance
 docker rm   -f postgres-instance
 docker rmi  -f postgres

docker run --name postgres-instance -e POSTGRES_PASSWORD=postgrespw -p 5432:5432 -d postgres
rem docker run --name postgres-instance -e POSTGRES_PASSWORD=postgrespw -p 5432:5432 -d zkot2/postgres:v1

docker cp salaries_db_setup.sql postgres-instance:/


docker exec postgres-instance psql --file=/salaries_db_setup.sql  -U postgres
