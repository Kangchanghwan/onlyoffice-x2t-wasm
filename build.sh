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
# [cs] 결과물을 먼저 만든다. 시험(test.js)이 멈춰도 x2t 는 나오게 하려고 순서를 바꿨다.
$CMD build $PARAMS ${DOCKER_BUILD_EXTRA:-} --target output -o build .
if [ "${SKIP_TESTS:-0}" != "1" ]; then
  timeout "${TEST_TIMEOUT:-1800}" $CMD build $PARAMS ${DOCKER_BUILD_EXTRA:-} --target test-output -o results .
fi
