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
- Check if the server is running
```
curl localhost:<HOST_MACHINE_PORT>/api/ping
```

Note: The <APP_PORT> is predefined to run at 3000. To change this, please change the `PORT` environment variable in the Dockerfile
