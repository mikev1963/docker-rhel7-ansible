# RHEL 7 Ansible Test Image #

Redhat Enterprise 7 Docker container for ansible playbooks and role testing

## How to Build ##

This image is built on Docker Hub automatically any time the upstream OS container is rebuilt, and any time a commit is made or merged to the master branch. But if you need to build the image on your own locally, do the following:

1. Install Docker
2. cd into this directory
3. run docker build -t rhel7-ansible --build-arg RHSM_USERNAME=$RHSM_USERNAME --build-arg RHSM_PASSWORD=$RHSM_PASSWORD --build-arg RHSM_POOL_ID=$RHSM_POOL_ID .

## Author
Created in 2018 by Michael A. Ventarola
