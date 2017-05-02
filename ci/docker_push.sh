#!/bin/bash

# Do not ever set -x here, it is a security hazard as it will place the credentials below in the
# Travis logs.
set -e

# this is needed to verify the example images
docker build -f ci/Dockerfile-envoy-image -t lyft/envoy:latest .
# verify the Alpine build even when we're not pushing it
make -C ci/build_alpine_container

# push the envoy image on merge to master
want_push='false'
for branch in "master"
do
   if [ "$TRAVIS_BRANCH" == "$branch" ]
   then
       want_push='true'
   fi
done
# if [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$want_push" == "true" ]
if [ "$TRAVIS_PULL_REQUEST" == "true" ]
then
    docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD
    # docker push lyft/envoy:latest
    # docker tag lyft/envoy:latest lyft/envoy:$TRAVIS_COMMIT
    # docker push lyft/envoy:$TRAVIS_COMMIT
    # docker tag lyft/envoy-alpine:latest lyft/envoy-alpine:$TRAVIS_COMMIT
    # docker push lyft/envoy-alpine:$TRAVIS_COMMIT
    # docker push lyft/envoy-alpine:latest
    # docker tag lyft/envoy-alpine-debug:latest lyft/envoy-alpine-debug:$TRAVIS_COMMIT
    # docker push lyft/envoy-alpine-debug:$TRAVIS_COMMIT
    # docker push lyft/envoy-alpine-debug:latest

    if [[ $(git diff HEAD^ ci/build_container/) ]]; then
        echo "There are changes in the ci/build_container directory"
        echo "Updating lyft/envoy-build image"
        ./ci/build_container/update_build_container.sh
    else
        echo "The ci/build_container directory has not changed"
    fi
else
    echo 'Ignoring PR branch for docker push.'
fi
