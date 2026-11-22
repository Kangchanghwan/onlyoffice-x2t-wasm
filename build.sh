#!/usr/bin/env bash

set -euxo pipefail

PARAMS=

if command -v podman >/dev/null 2>&1
then
  CMD=podman
  export BUILDAH_FORMAT=docker
  PARAMS="--jobs 2"
fi

if command -v docker >/dev/null 2>&1
then
  CMD=docker
  # [cs] podman-only flags must not be passed to docker (podman is preinstalled on GitHub runners)
  PARAMS=
fi

rm -rf results build
$CMD build $PARAMS ${DOCKER_BUILD_EXTRA:-} --target test-output -o results .
$CMD build $PARAMS ${DOCKER_BUILD_EXTRA:-} --target output -o build .
