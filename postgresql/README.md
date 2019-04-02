# Postgresql for web servers
A simple Postgresql docker image that has some initialization scripts and predefined environment variables.

## Run
To run the Postgresql for web servers, simply add execute the following commands
```
docker pull akshilv/web-server-pg
docker run --rm --name <CONTAINER_NAME> --network <NETWORK_NAME> --ip <IP_ADDRESS> -p <HOST_MACHINE_IP>:<HOST_MACHINE_PORT>:5432 -d akshilv/web-server-pg
```
Note: 
- If you want to persist the database storage, then use the `-v` command.
- Ensure that the web-server containers are also running on the same network as this Postgresql.
- Pass the static IP address defined in the command above to the web-servers containers as environment variable `PGHOST`.