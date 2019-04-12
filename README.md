# Web Servers
Basic REST based web servers in various languages.

Each web server component is dockerified and can be run using the deploy script `deploy.sh` or by following the individual component's deployment steps (mentioned in each component's README).

For further details of each component, check out the README within each component's folder.

## Prerequisites
- Docker

## How to deploy
```bash
Usage: ./deploy.sh [-h] [-c] COMPONENT [COMPONENT...]

Options:
   -h                     show this help text
   -c                     clean up all components and the docker bridged network
   COMPONENT values:      ("node"|"postgresql")
```
For example:
```bash
./deploy.sh node postgresql
```
will download the images of `web-server-node` and `web-server-pg` components, and deploy them in a docker bridged network called `web-server-network`.

Note: You can also write a `docker-compose.yml` file for deploying web-server components.

## Modify deployment
To modify the deployment, change the global variables within the deploy script.

## Current supported languages
- Node

## Future enhancements
- Add a UI component
- Add support for other languages
- Add an example `docker-compose.yml` file
