# Darknet Python Docker Images

Python Docker image with the [Darknet](https://github.com/AlexeyAB/darknet) package included. These images reduce the
burden of compiling Darknet's library (`libdarknet.so`) and use it on Python to create YOLOv4, v3, v2 sample apps. Based
on [daisukekobayashi's darknet-docker images](https://github.com/daisukekobayashi/darknet-docker).

## Base Image Tags

CPU images are based on [Python Docker Official Images](https://hub.docker.com/_/python) and GPU images are based on
[nvidia/cuda](https://hub.docker.com/r/nvidia/cuda/).

Tags are options in the [`Makefile`](./Makefile) for building the darknet module. You can check
options [here](https://github.com/AlexeyAB/darknet#how-to-compile-on-linux "How to compile on Linux").

* ``cpu`` tag means images are built with `AVX=1` and `OPENMP=1`.
    - ``noopt`` tag means disabling AVX option ``AVX=0``. If you use cpu based image and get error, try this tag.
* ``cv`` tag means the library is built with the `OPENCV=1` flag
* ``gpu`` tag means images are built with ``GPU=1`` and ``CUDNN=1``
    - ``cc**`` tag means compute compability of GPU. Images with this tag are optimized for GPU architecture. You can
      check compute compatibility of your GPU [here](https://developer.nvidia.com/cuda-gpus "CUDA GPUs"). If compute
      compatibility is greater than or equal to 7.0, images are built with ``CUDNN_HALF=1``.

## Usage

```
$ sudo docker run -it --rm gmontamat/python-darknet:3.6   
Python 3.6.13 (default, Mar 31 2021, 13:24:10) 
[GCC 8.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import darknet
>>> 
```
