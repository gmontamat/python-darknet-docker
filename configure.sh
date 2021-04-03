#!/bin/bash

tag="${1}"
makefile="Makefile"

function enable_gpu() {
  echo "enable GPU flag"
  sed -i -e 's/GPU=0/GPU=1/g' $makefile
}

function enable_cudnn() {
  echo "enable CUDNN flag"
  sed -i -e 's/CUDNN=0/CUDNN=1/g' $makefile
}

function enable_cudnn_half() {
  echo "enable CUDNN_HALF flag"
  sed -i -e 's/CUDNN_HALF=0/CUDNN_HALF=1/g' $makefile
}

function enable_opencv() {
  echo "enable OPENCV flag"
  sed -i -e 's/OPENCV=0/OPENCV=1/g' $makefile
}

function enable_avx() {
  echo "enable AVX flag"
  sed -i -e 's/AVX=0/AVX=1/g' $makefile
}

function enable_openmp() {
  echo "enable OPENMP flag"
  sed -i -e 's/OPENMP=0/OPENMP=1/g' $makefile
}

function enable_libso() {
  echo "enable LIBSO flag"
  sed -i -e 's/LIBSO=0/LIBSO=1/g' $makefile
}

function enable_zed_camera() {
  echo "enable ZED_CAMERA flag"
  sed -i -e 's/ZED_CAMERA=0/ZED_CAMERA=1/g' $makefile
}

function enable_debug() {
  echo "enable DEBUG flag"
  sed -i -e 's/DEBUG=0/DEBUG=1/g' $makefile
}

function enable_arch() {
  echo "enable ARCH= -gencode arch=compute_$1,code[sm_$1,compute_$1"
  sed -i -e "s/# ARCH= -gencode arch=compute_$1/ARCH= -gencode arch=compute_$1/g" $makefile
}

case ${tag} in
"3.6")
  enable_avx
  enable_openmp
  enable_libso
  ;;
"3.6-noopt")
  enable_openmp
  enable_libso
  ;;
"3.6-cv")
  enable_opencv
  enable_avx
  enable_openmp
  enable_libso
  ;;
"3.6-noopt-cv")
  enable_opencv
  enable_openmp
  enable_libso
  ;;
*)
  echo "error: $tag is not supported"
  exit 1
  ;;
esac
