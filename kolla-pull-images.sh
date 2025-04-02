#!/bin/bash
# Description: This script use to pull images from public docker
#              registry and push them to local docker registry.

public_registry_host="quay.io"
local_registry_host="localhost:4000"
kolla_release="2023.1-ubuntu-jammy"
IMAGE_LIST="kolla-images.list"

#
while IFS= read -r image
do
echo "===========> Pull ==> ${image}"
docker pull "${public_registry_host}/openstack.kolla/${image}:${kolla_release}"
docker tag "${public_registry_host}/openstack.kolla/${image}:${kolla_release}" "${local_registry_host}/openstack.kolla/${image}:${kolla_release}"
echo "===========> Push ==> ${image}"
docker push "${local_registry_host}/openstack.kolla/${image}:${kolla_release}"
docker rmi "${public_registry_host}/openstack.kolla/${image}:${kolla_release}"
done < $IMAGE_LIST
