#!/bin/bash
# Description: This script use to pull images from public docker
#              registry and push them to local docker registry.

set -euo pipefail

public_registry_host="quay.io"
local_registry_host="localhost:4000"
kolla_release="2025.1-ubuntu-noble"
IMAGE_LIST="kolla-images.list"

# Counters
SUCCESS=0
FAILED=0
FAILED_IMAGES=()

while IFS= read -r image; do
    [[ -z "$image" ]] && continue

    echo "===========> Pull ==> ${image}"
    if docker pull "${public_registry_host}/openstack.kolla/${image}:${kolla_release}"; then
        docker tag "${public_registry_host}/openstack.kolla/${image}:${kolla_release}" \
                   "${local_registry_host}/openstack.kolla/${image}:${kolla_release}"
        echo "===========> Push ==> ${image}"
        if docker push "${local_registry_host}/openstack.kolla/${image}:${kolla_release}"; then
            docker rmi "${public_registry_host}/openstack.kolla/${image}:${kolla_release}"
            ((SUCCESS++)) || true
        else
            echo "ERROR: Push failed for ${image}" >&2
            FAILED_IMAGES+=("$image")
            ((FAILED++)) || true
        fi
    else
        echo "ERROR: Pull failed for ${image}" >&2
        FAILED_IMAGES+=("$image")
        ((FAILED++)) || true
    fi
done < "$IMAGE_LIST"

# Summary
echo ""
echo "=== SUMMARY ==="
echo "Success: $SUCCESS"
echo "Failed:  $FAILED"
if [[ $FAILED -gt 0 ]]; then
    echo "Failed images:"
    printf '  - %s\n' "${FAILED_IMAGES[@]}"
    exit 1
fi
