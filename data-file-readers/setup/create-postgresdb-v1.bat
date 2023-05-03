
rem remove the image to start from scratch
 docker stop postgres-instance
 docker rm   -f postgres-instance

docker run --name postgres-instance -e POSTGRES_PASSWORD=postgrespw -p 5432:5432 -d zkot2/postgres:v1
