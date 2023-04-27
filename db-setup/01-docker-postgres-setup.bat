
rem remove the image to start from scratch
 docker stop -f postgres-instance
 docker rm   -f postgres-instance
 docker rmi  -f postgres

docker run --name postgres-instance -e POSTGRES_PASSWORD=postgrespw -p 5432:5432 -d postgres
docker cp malaria_db_setup.sql postgres-instance:/

docker exec postgres-instance psql --file=/malaria_db_setup.sql  -U postgres
