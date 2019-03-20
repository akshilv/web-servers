# Postgresql for web servers
A simple Postgresql docker image that has some initialization scripts and environment variables predefined

## Run
To run the Postgresql for web servers, simply add execute the following commands
```
docker pull akshilv/pg-web-server
docker run --rm --name <CONTAINER_NAME> -p <HOST_MACHINE_IP>:<HOST_MACHINE_PORT>:5432 -d akshilv/pg-web-server
```
Note: If you want to persist the database storage, the use the `-v` command