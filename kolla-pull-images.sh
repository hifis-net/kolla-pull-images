#!/bin/bash
# Description: This script use to pull images from public docker
#              registry and push them to local docker registry.

public_registry_host="quay.io"
local_registry_host="docker-registry"
kolla_release="zed-ubuntu-jammy"
IMAGE_LIST="kolla-images.list"

#
while IFS= read -r image
do
echo "===========> Pull ==> ${image}"
docker pull "${public_registry_host}/openstack.kolla/${image}:${kolla_release}"
docker tag "${public_registry_host}/openstack.kolla/${image}:${kolla_release}" "$local_registry_host:4000/openstack.kolla/${image}:${kolla_release}"
echo "===========> Push ==> ${image}"
docker push "$local_registry_host:4000/openstack.kolla/${image}:${kolla_release}"
docker rmi "${public_registry_host}/openstack.kolla/${image}:${kolla_release}"
done < $IMAGE_LIST
