# Web Server for Node

Basic REST based web server written in Node.

## Prerequisites

- Docker

## Running

- Download the docker image
```
docker pull akshilv/web-server-node:latest
```
- Run the docker image using docker
```
docker run -p <HOST_MACHINE_PORT>:4000 akshilv/web-server-node:latest
```
Alternatively, run using the docker-compose.yml file
```
docker-compose up
```
- Check if the server is running
```
curl localhost:<HOST_MACHINE_PORT>/api/ping
```

Note: The <HOST_MACHINE_PORT> is predefined as 4000 if the image is run using docker-compose.yml.
To change the <HOST_MACHINE_PORT> or the <APP_PORT> (on which the server listens), change the .env file
