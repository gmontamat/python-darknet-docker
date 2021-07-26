#!/bin/bash

for var in cpu cpu-noopt cpu-cv cpu-noopt-cv gpu gpu-cv \
  gpu-cc53 gpu-cv-cc53 gpu-cc60 gpu-cv-cc60 gpu-cc61 gpu-cv-cc61 gpu-cc62 gpu-cv-cc62 \
  gpu-cc70 gpu-cv-cc70 gpu-cc72 gpu-cv-cc72 gpu-cc75 gpu-cv-cc75 \
  cpu-u1804 cpu-noopt-u1804 cpu-cv-u1804 cpu-noopt-cv-u1804 gpu-u1804 gpu-cv-u1804 \
  gpu-cc53-u1804 gpu-cv-cc53-u1804 gpu-cc60-u1804 gpu-cv-cc60-u1804 gpu-cc61-u1804 gpu-cv-cc61-u1804 \
  gpu-cc62-u1804 gpu-cv-cc62-u1804 gpu-cc70-u1804 gpu-cv-cc70-u1804 gpu-cc72-u1804 gpu-cv-cc72-u1804 \
  gpu-cc75-u1804 gpu-cv-cc75-u1804 \
do

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
    if [[ "$DOCKER_TAG" == *u1804 ]]; then
      BUILDER_IMAGE=nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04
      BASE_IMAGE=nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04
      LIB_OPENCV=libopencv-highgui3.2
    else
      BUILDER_IMAGE=nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04
      BASE_IMAGE=nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04
      LIB_OPENCV=libopencv-highgui4.2
    fi
  else
    if [[ "$DOCKER_TAG" == *u1804 ]]; then
      BUILDER_IMAGE=ubuntu:18.04
      BASE_IMAGE=ubuntu:18.04
      LIB_OPENCV=libopencv-highgui3.2
    else
      BUILDER_IMAGE=ubuntu:20.04
      BASE_IMAGE=ubuntu:20.04
      LIB_OPENCV=libopencv-highgui4.2
    fi
  fi

  if [[ "$DOCKER_TAG" == gpu* ]]; then
    echo "building with GPU support"
    if [[ "$DOCKER_TAG" == *-cv* ]]; then
      echo "building with OpenCV support"
      docker build \
        --build-arg BUILDER_IMAGE=$BUILDER_IMAGE \
        --build-arg BASE_IMAGE=$BASE_IMAGE \
        --build-arg LIB_OPENCV=$LIB_OPENCV \
        --build-arg CONFIG=$VAR \
        --build-arg SOURCE_BRANCH=$SOURCE_BRANCH \
        --build-arg SOURCE_COMMIT=$SOURCE_COMMIT \
        -t $DOCKER_REPO:$DOCKER_TAG -f Dockerfile.gpu-cv .
    else
      echo "building without OpenCV support"
      docker build \
        --build-arg BUILDER_IMAGE=$BUILDER_IMAGE \
        --build-arg BASE_IMAGE=$BASE_IMAGE \
        --build-arg CONFIG=$VAR \
        --build-arg SOURCE_BRANCH=$SOURCE_BRANCH \
        --build-arg SOURCE_COMMIT=$SOURCE_COMMIT \
        -t $DOCKER_REPO:$DOCKER_TAG -f Dockerfile.gpu .
    fi
  else
    echo "building without GPU support"
    if [[ "$DOCKER_TAG" == *-cv* ]]; then
      echo "building with OpenCV support"
      docker build \
        --build-arg BUILDER_IMAGE=$BUILDER_IMAGE \
        --build-arg BASE_IMAGE=$BASE_IMAGE \
        --build-arg LIB_OPENCV=$LIB_OPENCV \
        --build-arg CONFIG=$VAR \
        --build-arg SOURCE_BRANCH=$SOURCE_BRANCH \
        --build-arg SOURCE_COMMIT=$SOURCE_COMMIT \
        -t $DOCKER_REPO:$DOCKER_TAG -f Dockerfile.cpu-cv .
    else
      echo "building without OpenCV support"
      docker build \
        --build-arg BUILDER_IMAGE=$BUILDER_IMAGE \
        --build-arg BASE_IMAGE=$BASE_IMAGE \
        --build-arg CONFIG=$VAR \
        --build-arg SOURCE_BRANCH=$SOURCE_BRANCH \
        --build-arg SOURCE_COMMIT=$SOURCE_COMMIT \
        -t $DOCKER_REPO:$DOCKER_TAG -f Dockerfile.cpu .
    fi
  fi

  docker push $DOCKER_REPO:$DOCKER_TAG
done

echo "run \`docker image prune\` to remove builder images"
