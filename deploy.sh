#!/bin/bash
#
# Deploy web server package on docker

set -e

# Global Variables
PROGNAME=$(basename "${0}")
DOCKER_HUB_BASE_REPO="akshilv"
LOCALHOST="127.0.0.1"
CLEANUP_COMPONENTS=()
CLEANUP_ALL="false"
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
success_msg () {
  echo -e "${GREEN}${1}${NC}"
}

#############################################
# Cleanup containers running on local docker
# Globals:
#   CLEANUP_COMPONENTS
#   LINENO
# Arguments:
#   None
# Returns:
#   None
#############################################
cleanup () {
  local indices
  echo -e "Starting clean up..."
  indices=("${!CLEANUP_COMPONENTS[@]}")
  if [[ ${#indices[@]} == 0 ]] ; then
    error_msg "${LINENO} Nothing to cleanup"
    exit 1
  fi

  # Cleanup in reverse order
  for (( i = ${#indices[@]} -1; i > 0; i-- )) ; do
    kill_web_server "${CLEANUP_COMPONENTS[indices[i]]}"
  done
  if [[ ${CLEANUP_COMPONENTS[0]} == "network" ]] ; then
    delete_docker_network
  fi
  echo -e "Clean up finished"
  if [[ ${CLEANUP_ALL} == "true" ]] ; then
    exit 0
  else
    exit 1
  fi
}

########################
# Prints usage
# Globals:
#   PROGNAME
# Arguments:
#   None
# Returns:
#   None
########################
show_usage () {
  echo -e "Usage: ./${PROGNAME} [-h] [-c] COMPONENT [COMPONENT...]\n
Options:
   -h                     show this help text'
   -c                     clean up all components and the docker bridged network
   COMPONENT values:      (\"node\"|\"postgresql\")"
}

#####################################################
# Checks whether the options passed are valid or not
# Globals:
#   None
# Arguments:
#   $@
# Returns:
#   None
####################################################
check_correct_options () {
  if [[ ${#} == 0 ]] ; then
    error_msg " No arguments passed"
    show_usage
    exit 1
  fi

  # Add options here
  while getopts ':hc' option; do
    case "$option" in
      h)
        show_usage
        exit 0
        ;;
      c)
        echo -e "Starting to cleanup all"
        # Add every web server component as part of the cleanup array
        CLEANUP_COMPONENTS+=("network" "node" "postgresql")
        CLEANUP_ALL="true"
        cleanup
        ;;
      \?)
        error_msg " Illegal option: -${OPTARG}"
        show_usage 1>&2
        exit 1
        ;;
    esac
  done
  shift $((OPTIND - 1))
}

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
    exit 1
  else
    success_msg "Docker is installed"
  fi
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
    exit 1
  else
    success_msg "Successfully created network ${NETWORK_NAME}"
    CLEANUP_COMPONENTS+=("network")
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
  if [[ -z "$(docker network rm ${NETWORK_NAME})" ]] ; then
    error_msg "${LINENO} Could not delete docker network ${NETWORK_NAME}"
  else
    success_msg "Successfully deleted docker network ${NETWORK_NAME}"
  fi
}

# generate_gateway() {
# }

#####################################################################################
# Deploy all the web server components, after necessary checks, based on args passed
# Globals:
#   CLEANUP_COMPONENTS
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
    CLEANUP_COMPONENTS+=("${component}")
  done
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

#################################
# Kills the web server component
# Globals:
#   LINENO
#   WS_NAME
# Arguments:
#   $1 : Component name
# Returns:
#   None
#################################
kill_web_server () {
  populate_variables "${1}"
  echo -e "Removing container for ${WS_NAME}"
  if [[ -z "$(docker kill ${WS_NAME})" ]] ; then
    error_msg "${LINENO} Failed to delete container ${WS_NAME}"
  else
    success_msg "Successfully deleted container ${WS_NAME}"
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
      error_msg "${LINENO} Invalid component"
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
  check_correct_options "${@}"
  check_docker_exists
  create_docker_network
  deploy_web_server_component "${@}"
}

# Execute script
main "${@}"
