# Web Server for Node

Basic REST based web server written in Node and deployed on Docker.

## Prerequisites

- Docker

## Running

- Download the docker image
```
docker pull akshilv/web-server-node:latest
```
- Run the docker image using docker
```
docker run --rm --name <WEB_SERVER_NAME> -e "PGHOST=<PG_HOST_IP_ADDRESS>" -p <HOST_MACHINE_PORT>:4000 akshilv/web-server-node:latest
```
- Check if the server is running
```
curl localhost:<HOST_MACHINE_PORT>/api/ping
```

Note: The <APP_PORT> is predefined to run at 4000. To change this, please change the `PORT` environment variable in the Dockerfile

## Connect to a Database

As of now, there's only support for Postgresql.

You can connect to a Postgresql by updating the `conf.json` in the `lib/db` folder, and adding value (IP address in this case) for the environment variable `PGHOST` while starting the container.

You can also deploy Postgresql for web-servers by following the steps [here](https://github.com/akshilv/web-servers/blob/master/postgresql/README.md). This Postgresql image is customized for this Web Servers repository.

You would also need to deploy both the Web Server and Postgresql on the same docker network. You can create a new docker bridged network and make both the containers a part of the network by passing the `--network=<NETWORK_NAME>` flag while running the container.

You can also deploy both the containers by following the steps [here](https://github.com/akshilv/web-servers/blob/master/README.md)

## CRUD APIs

Currently, 4 APIs are supported to perform basic CRUD operations on a USERS table.

To perform these operations, a connection to a Postgresql DB is required along with a USERS table (defined [here](https://github.com/akshilv/web-servers/blob/master/postgresql/create-db.sql)).

The APIs are as following:

- To add a new user
```
curl -H "Content-Type: application/json" -d '{"user_id": <USER_ID>, "user_name": "<USER_NAME>"}' -X POST "localhost:<HOST_MACHINE_PORT>/v1/user"
```
- To retieve an existing user's information:
```
curl -H "Accept: application/json" -X GET "localhost:<HOST_MACHINE_PORT>/v1/user/<USER_NAME>"
```
- To update an user's name:
```
curl -H "Content-Type: application/json" -d '{"new_user_name": "<NEW_USER_NAME>", "user_id": <USER_ID>}' -X PATCH "localhost:<HOST_MACHINE_PORT>/v1/user/<USER_NAME>"
```
- To delete an user:
```
curl -X DELETE "localhost:<HOST_MACHINE_PORT>/user/<USER_NAME>?new_user_name=<NEW_USER_NAME>&user_id=<USER_ID>"
```

## Future Enhancements

- Add more databases support
- Add authentication process for requests
- Add basic unit test cases