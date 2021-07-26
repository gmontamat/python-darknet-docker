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
"cpu" | "cpu-u1804")
  enable_avx
  enable_openmp
  enable_libso
  ;;
"cpu-noopt" | "cpu-noopt-u1804")
  enable_openmp
  enable_libso
  ;;
"cpu-cv" | "cpu-cv-u1804")
  enable_opencv
  enable_avx
  enable_openmp
  enable_libso
  ;;
"cpu-noopt-cv" | "cpu-noopt-cv-u1804")
  enable_opencv
  enable_openmp
  enable_libso
  ;;
"gpu" | "gpu-u1804")
  enable_gpu
  enable_cudnn
  enable_libso
  ;;
"gpu-cv" | "gpu-cv-u1804")
  enable_opencv
  enable_gpu
  enable_cudnn
  enable_libso
  ;;
"gpu-cc53" | "gpu-cc53-u1804")
  enable_gpu
  enable_cudnn
  enable_arch 53
  enable_libso
  ;;
"gpu-cv-cc53" | "gpu-cv-cc53-u1804")
  enable_gpu
  enable_cudnn
  enable_opencv
  enable_arch 53
  enable_libso
  ;;
"gpu-cc60" | "gpu-cc60-u1804")
  enable_gpu
  enable_cudnn
  enable_arch 60
  enable_libso
  ;;
"gpu-cv-cc60" | "gpu-cv-cc60-u1804")
  enable_gpu
  enable_cudnn
  enable_opencv
  enable_arch 60
  enable_libso
  ;;
"gpu-cc61" | "gpu-cc61-u1804")
  enable_gpu
  enable_cudnn
  enable_arch 61
  enable_libso
  ;;
"gpu-cv-cc61" | "gpu-cv-cc61-u1804")
  enable_gpu
  enable_cudnn
  enable_opencv
  enable_arch 61
  enable_libso
  ;;
"gpu-cc62" | "gpu-cc62-u1804")
  enable_gpu
  enable_cudnn
  enable_arch 62
  enable_libso
  ;;
"gpu-cv-cc62" | "gpu-cv-cc62-u1804")
  enable_gpu
  enable_cudnn
  enable_opencv
  enable_arch 62
  enable_libso
  ;;
"gpu-cc70" | "gpu-cc70-u1804")
  enable_gpu
  enable_cudnn
  enable_cudnn_half
  enable_arch 70
  enable_libso
  ;;
"gpu-cv-cc70" | "gpu-cv-cc70-u1804")
  enable_gpu
  enable_cudnn
  enable_cudnn_half
  enable_opencv
  enable_arch 70
  enable_libso
  ;;
"gpu-cc72" | "gpu-cc72-u1804")
  enable_gpu
  enable_cudnn
  enable_cudnn_half
  enable_arch 72
  enable_libso
  ;;
"gpu-cv-cc72" | "gpu-cv-cc72-u1804")
  enable_gpu
  enable_cudnn
  enable_cudnn_half
  enable_opencv
  enable_arch 72
  enable_libso
  ;;
"gpu-cc75" | "gpu-cc75-u1804")
  enable_gpu
  enable_cudnn
  enable_cudnn_half
  enable_arch 75
  enable_libso
  ;;
"gpu-cv-cc75" | "gpu-cv-cc75-u1804")
  enable_gpu
  enable_cudnn
  enable_cudnn_half
  enable_opencv
  enable_arch 75
  enable_libso
  ;;
"gpu-cc80" | "gpu-cc80-u1804")
  enable_gpu
  enable_cudnn
  enable_cudnn_half
  enable_arch 80
  enable_libso
  ;;
"gpu-cv-cc80" | "gpu-cv-cc80-u1804")
  enable_gpu
  enable_cudnn
  enable_cudnn_half
  enable_opencv
  enable_arch 80
  enable_libso
  ;;
"gpu-cc86" | "gpu-cc86-u1804")
  enable_gpu
  enable_cudnn
  enable_cudnn_half
  enable_arch 86
  enable_libso
  ;;
"gpu-cv-cc86" | "gpu-cv-cc86-u1804")
  enable_gpu
  enable_cudnn
  enable_cudnn_half
  enable_opencv
  enable_arch 86
  enable_libso
  ;;
*)
  echo "error: $tag is not supported"
  exit 1
  ;;
esac
