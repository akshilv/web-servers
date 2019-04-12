#!/bin/bash
#
# Deploy web server package on docker

set -e

# Global Variables
PROGNAME=$(basename "${0}")
DOCKER_HUB_BASE_REPO="akshilv"
LOCALHOST="127.0.0.1"
# Colors
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
NC=$'\033[0m' # No color
# Network related variables
NETWORK_NAME="web-server-network"
SUBNET="172.16.0.0/16"
IP_RANGE="172.16.1.0/24"
GATEWAY="172.16.1.254"
# PG related variables
PG_NAME="web-server-pg"
PG_HOST="172.16.1.1"
PG_REPO="${DOCKER_HUB_BASE_REPO}/${PG_NAME}:latest"
PG_PORT="5432"
# Node related variables
NODE_NAME="web-server-node"
NODE_REPO="${DOCKER_HUB_BASE_REPO}/${NODE_NAME}:latest"
NODE_PORT="4000"
# Generic web-server variables
WS_NAME=""
WS_REPO=""
WS_PORT=""

trap 'cleanup' 2

#################################
# Prints a colored error message
# Globals:
#   RED
#   NC
#   PROGNAME
# Arguments:
#   $1 - Error message
# Returns:
#   None
#################################
error_msg () {
  echo -e "${RED}${PROGNAME}:${1:-" Unknown Error"}${NC}" 1>&2
}

###################################
# Prints a colored success message
# Globals:
#   GREEN
#   NC
# Arguments:
#   $1 - Success message
# Returns:
#   None
###################################
success_msg() {
  echo -e "${GREEN}${1}${NC}"
}

#############################################
# Cleanup containers running on local docker
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#############################################
cleanup () {
  echo -e "Starting clean up..."
  # TODO: do something
  echo -e "Clean up finished"
  exit 1
}

###################################
# Creates a bridged docker network
# Globals:
#   NETWORK_NAME
#   SUBNET
#   IP_RANGE
#   GATEWAY
#   LINENO
# Arguments:
#   None
# Returns:
#   None
###################################
create_docker_network () {
  echo -e "Creating a docker network called ${NETWORK_NAME}"
  if [[ -z "$(docker network create --driver=bridge --subnet=${SUBNET} \
    --ip-range=${IP_RANGE} --gateway=${GATEWAY} ${NETWORK_NAME})" ]] ; then
    error_msg "${LINENO} Could not create network ${NETWORK_NAME}"
    cleanup
  else
    success_msg "Successfully created network ${NETWORK_NAME}"
  fi
}

###########################
# Deletes a docker network
# Globals:
#   NETWORK_NAME
#   LINENO
# Arguments:
#   None
# Returns:
#   None
###########################
delete_docker_network () {
  echo -e "Deleting the docker network ${NETWORK_NAME}..."
  if [[ -z "$(docker network delete ${NETWORK_NAME})" ]] ; then
    error_msg "${LINENO} Could not delete docker network ${NETWORK_NAME}"
  else
    echo -e "Successfully deleted docker network ${NETWORK_NAME}"
  fi
}

# generate_gateway() {
# }

############################################
# Checks whether docker is installed or not
# Globals:
#   LINENO
# Arguments:
#   None
# Returns:
#   None
############################################
check_docker_exists () {
  echo -e "Checking whether docker is installed or not..."
  if [[ -z "$(type -p docker)" ]] ; then
    error_msg "${LINENO} Docker is not installed or requires sudo"
    cleanup
  else
    success_msg "Docker is installed"
  fi
}

#########################
# Kills the pg container
# Globals:
#   LINENO
#   PG_NAME
# Arguments:
#   None
# Returns:
#   None
#########################
# TODO: convert this to a generic kill container
kill_web_server_pg () {
  echo -e "Removing container for ${PG_NAME}"
  if [[ -z "$(docker kill ${PG_NAME})" ]] ; then
    error_msg "${LINENO} Failed to delete container ${PG_NAME}"
  else
    echo -e "Successfully deleted container ${PG_NAME}"
  fi
}

#####################################################################################
# Deploy all the web server components, after necessary checks, based on args passed
# Globals:
#   None
# Arguments:
#   $@
# Returns:
#   None
#####################################################################################
deploy_web_server_component () {
  for component in "${@}" ; do
    echo -e "Deploying web server component for ${component}"
    populate_variables "${component}"
    check_image_exists
    deploy "${component}"
  done

}

#########################################
# Deploy a web server component
# Globals:
#   WS_NAME
#   WS_REPO
#   WS_PORT
#   PG_NAME
#   PG_REPO
#   PG_PORT
#   PG_HOST
#   NETWORK_NAME
#   LOCALHOST
#   LINENO
# Arguments:
#   $1: component that is to be deployed
# Returns:
#   None
#########################################
deploy () {
  local deploy_cmd component_variable
  # Change the component_variable based on the type of component is to be deployed
  if [[ ${1} == "postgresql" && ${WS_NAME} == "${PG_NAME}" && ${WS_REPO} == "${PG_REPO}" && ${WS_PORT} == "${PG_PORT}" ]] ; then
    component_variable="--ip=${PG_HOST}"
  else
    component_variable="-e=PGHOST=${PG_HOST}"
  fi
  deploy_cmd="docker run --rm --name=${WS_NAME} --network=${NETWORK_NAME} \
      -p=${LOCALHOST}:${WS_PORT}:${WS_PORT} ${component_variable} -d ${WS_REPO}"
  echo -e "Deploying..."
  if [[ -z "$(${deploy_cmd})" ]] ; then
    error_msg "${LINENO} Deployment of ${WS_REPO} failed"
    cleanup
  else
    success_msg "Deployment of ${WS_REPO} succeeded"
  fi
}

#############################################
# Check whether a docker image exists or not
# Globals:
#   WS_REPO
#   LINENO
# Arguments:
#   $@
# Returns:
#   None
#############################################
check_image_exists () {
  echo -e "Checking whether ${WS_REPO} image exists locally or not..."
  if [[ -z "$(docker images -q ${WS_REPO})" ]]; then
    echo -e "Image ${WS_REPO} does not exist, downloading..."
    if [[ -z "$(docker pull ${WS_REPO})" ]] ; then
      error_msg "${LINENO} Could not download ${WS_REPO}"
      cleanup
    else
      success_msg "${WS_REPO} successfully downloaded"
    fi
  else
    echo -e "Image ${WS_REPO} exists"
  fi
}

##################################
# Populate global WS_* variables
# Globals:
#   WS_NAME
#   WS_REPO
#   WS_PORT
#   NODE_NAME
#   NODE_REPO
#   NODE_PORT
#   PG_NAME
#   PG_REPO
#   PG_PORT
# Arguments:
#   $1 : component to be deployed
# Returns:
#   None
##################################
populate_variables () {
  case ${1} in
    node)
      WS_NAME=${NODE_NAME}
      WS_REPO=${NODE_REPO}
      WS_PORT=${NODE_PORT}
      ;;
    postgresql)
      WS_NAME=${PG_NAME}
      WS_REPO=${PG_REPO}
      WS_PORT=${PG_PORT}
      ;;
    *)
      echo "Wrong input"
      ;;
    esac
}

###############################
# Main function for the script
# Globals:
#   None
# Arguments:
#   $@
# Returns:
#   None
###############################
main () {
  check_docker_exists
  create_docker_network
  deploy_web_server_pg
  deploy_web_server_component "${@}"
}

# Execute script
main "${@}"