#!/usr/bin/env bash

# Attention: this script should be manually synced with the server!

LOGS_ROOT=/home/ubuntu/logs
ALL_DEPLOYMENTS_ROOT=/home/ubuntu/deployments
DEPLOYMENT_ROOT="$ALL_DEPLOYMENTS_ROOT/search-engine"
LOG_PATH="$LOGS_ROOT/deploy-search-engine.log"

function logmsg {
  echo "$(date +'%d-%m-%Y %H:%M:%S.%N') — $1" >> "$LOG_PATH"
}

# log commands on execution
set +x

# create necessary directories
mkdir -p "$LOGS_ROOT" "$ALL_DEPLOYMENTS_ROOT"

logmsg "Deployment triggered"

# remove old deployment files
rm -rf "$DEPLOYMENT_ROOT"

# clone the repository
logmsg "Cloning repository..."
git clone --depth=1 https://github.com/one-zero-eight/InNoHassle-Search "$DEPLOYMENT_ROOT"

# check Docker is running
if ! docker info > /dev/null 2>&1; then
  logmsg "Docker is not running, exiting..."
  exit 1
fi

# use template as the configuration file
if [ -f "$DEPLOYMENT_ROOT/config.template.yaml" ]; then
    cp "$DEPLOYMENT_ROOT/config.template.yaml" "$DEPLOYMENT_ROOT/config.yaml"
fi

logmsg "Running docker compose up"
docker compose -f "$DEPLOYMENT_ROOT/docker-compose.yaml" up --force-recreate --build --detach

set -x
