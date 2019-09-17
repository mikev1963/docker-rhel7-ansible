#!/bin/bash

set -e

echo "Building container image"
docker build -t mikev1963/docker-rhel7-ansible --build-arg RHSM_USERNAME=$RHSM_USERNAME --build-arg RHSM_PASSWORD=$RHSM_PASSWORD --build-arg RHSM_POOL_ID=$RHSM_POOL_ID .

echo "Pushing to hub.docker.com"
docker push mikev1963/docker-rhel7-ansible
