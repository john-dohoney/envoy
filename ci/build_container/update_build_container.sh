#!/bin/bash
set -e

cd ci/build_container
./docker_build.sh
# docker push lyft/envoy-build:$TRAVIS_COMMIT
docker tag lyft/envoy-build:$TRAVIS_COMMIT lyft/envoy-build-test:latest
# docker push lyft/envoy-build:latest
docker push lyft/envoy-build-test:latest
cd ../../
