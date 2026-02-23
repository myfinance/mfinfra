#!/bin/bash

# This script sets up a local environment and the toolchain to install the infrastructure as code (IaC) tools, such as Ansible, for the MyFinance project.
# It is intended to be run in OrbStack.

echo "Start installation of IaC Tools(Ansable...)..."
echo "build the docker file"
docker build -t semaphore-sophos .

# Ensure Docker Compose is available
if ! command -v docker-compose &> /dev/null
then
    echo "docker-compose could not be found. Please install Docker Desktop or Docker Compose."
    exit 1
fi

# Start the services in detached mode
docker-compose -f "$(dirname "$0")/docker-compose.yml" up -d

if [ $? -eq 0 ]; then
    echo "Local environment services started successfully."

else
    echo "Failed to start local environment services."
fi
