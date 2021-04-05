#!/bin/bash

for var in cpu cpu-noopt cpu-cv cpu-noopt-cv gpu gpu-cv; do

  DOCKER_REPO="gmontamat/python-darknet"
  SOURCE_BRANCH="master"
  SOURCE_COMMIT=$(git ls-remote https://github.com/AlexeyAB/darknet.git ${SOURCE_BRANCH} | awk '{ print $1 }')
  DOCKER_TAG=$var
  VAR=$var

  echo $DOCKER_REPO
  echo $SOURCE_BRANCH
  echo $SOURCE_COMMIT
  echo $DOCKER_TAG
  echo $VAR

  if [[ "$DOCKER_TAG" == gpu* ]]; then
    echo "building with GPU support"
    if [[ "$DOCKER_TAG" == *-cv ]]; then
      echo "building with OpenCV support"
      docker build \
        --build-arg PYTHON_VERSION=3.6 \
        --build-arg CONFIG=$VAR \
        --build-arg SOURCE_BRANCH=$SOURCE_BRANCH \
        --build-arg SOURCE_COMMIT=$SOURCE_COMMIT \
        -t $DOCKER_REPO:$DOCKER_TAG -f Dockerfile.gpu-cv .
    else
      echo "building without OpenCV support"
      docker build \
        --build-arg PYTHON_VERSION=3.6 \
        --build-arg CONFIG=$VAR \
        --build-arg SOURCE_BRANCH=$SOURCE_BRANCH \
        --build-arg SOURCE_COMMIT=$SOURCE_COMMIT \
        -t $DOCKER_REPO:$DOCKER_TAG -f Dockerfile.gpu .
    fi
  else
    echo "building without GPU support"
    if [[ "$DOCKER_TAG" == *-cv ]]; then
      echo "building with OpenCV support"
      docker build \
        --build-arg PYTHON_VERSION=3.6 \
        --build-arg CONFIG=$VAR \
        --build-arg SOURCE_BRANCH=$SOURCE_BRANCH \
        --build-arg SOURCE_COMMIT=$SOURCE_COMMIT \
        -t $DOCKER_REPO:$DOCKER_TAG -f Dockerfile.cpu-cv .
    else
      echo "building without OpenCV support"
      docker build \
        --build-arg PYTHON_VERSION=3.6 \
        --build-arg CONFIG=$VAR \
        --build-arg SOURCE_BRANCH=$SOURCE_BRANCH \
        --build-arg SOURCE_COMMIT=$SOURCE_COMMIT \
        -t $DOCKER_REPO:$DOCKER_TAG -f Dockerfile.cpu .
    fi
  fi

  # docker push $DOCKER_REPO:$DOCKER_TAG
done

echo "run \`docker image prune\` to remove builder images"
