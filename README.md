# Darknet & Python Docker Images

[![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/gmontamat/python-darknet)](https://hub.docker.com/r/gmontamat/python-darknet)
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/gmontamat/python-darknet)](https://hub.docker.com/r/gmontamat/python-darknet)
[![Docker Pulls](https://img.shields.io/docker/pulls/gmontamat/python-darknet)](https://hub.docker.com/r/gmontamat/python-darknet)
[![GitHub](https://img.shields.io/github/license/gmontamat/python-darknet-docker)](https://github.com/gmontamat/python-darknet-docker/blob/main/LICENSE)

Python Docker image with the [Darknet](https://github.com/AlexeyAB/darknet) package included. These images eliminate the
burden of compiling Darknet's library (`libdarknet.so`) and import it into Python using
[its wrapper](https://github.com/AlexeyAB/darknet/blob/master/darknet.py) to create YOLOv4, v3, v2 sample apps. Based
on [daisukekobayashi's darknet-docker images](https://github.com/daisukekobayashi/darknet-docker).

## Base Image Tags

CPU images are based on [Ubuntu Docker Official Images](https://hub.docker.com/_/ubuntu) (`ubuntu:20.04`) and GPU images
are based on [nvidia/cuda](https://hub.docker.com/r/nvidia/cuda/) (`nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04`).
Images include `python3.8`, an updated version of `pip`, and the following libraries:

* [Darknet](https://github.com/AlexeyAB/darknet)
* [Numpy](https://pypi.org/project/numpy/)
* [OpenCV](https://pypi.org/project/opencv-python/)

Tags indicate whether the image supports GPU or not. They also refer to different flags in
the [`Makefile`](https://github.com/AlexeyAB/darknet/blob/master/Makefile) for building the module. You can check the
meaning of each
flag [here](https://github.com/AlexeyAB/darknet#how-to-compile-on-linux-using-make "How to compile on Linux").

* ``cpu`` tag indicates images are built with `AVX=1` and `OPENMP=1`
    - The ``noopt`` tag means the AVX option is disabled (``AVX=0``). If you use a ``cpu`` image and get errors, try
      this tag.
* ``cv`` tag means the library is built with the `OPENCV=1` flag
* ``gpu`` tag means images are built with ``GPU=1`` and ``CUDNN=1``
    - The ``cc**`` tag indicates compute compatibility of GPU. Images with this tag are optimized for a certain GPU
      architecture. You can check compute compatibility of your
      GPU [here](https://developer.nvidia.com/cuda-gpus "CUDA GPUs"). If compute compatibility is greater than or equal
      to 7.0, images are built with ``CUDNN_HALF=1``.
* ``u1804`` tag means the images are based on `ubuntu:18.04` (when CPU-based) or
  `nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04` (when GPU-based), and include `python3.6` instead of `python3.8`

## Usage

### Basic

The `python` interpreter runs by default when you start the container:

```
$ docker run -it --rm gmontamat/python-darknet:cpu
Python 3.6.9 (default, Jan 26 2021, 15:33:00)
[GCC 8.4.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import darknet
>>> import numpy as np
>>> import cv2
>>> 
```

### Run custom code

Use volumes to share Python code in `/usr/src/app`, define it as the working directory, and specify the command to be
run. The following example shows how to do this using the [code included](./test) which is taken from the
[Darknet repository](https://github.com/AlexeyAB/darknet/blob/master/darknet_images.py "darknet_images.py"):

```bash
$ git clone https://github.com/gmontamat/python-darknet-docker.git
$ cd python-darknet-docker
$ wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.weights \
       -O test/yolov4.weights
$ xhost +
$ docker run --gpus all -it --rm -v $(realpath ./test):/usr/src/app \
             -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY \
             -w /usr/src/app gmontamat/python-darknet:gpu python3 darknet_images.py \
             --input sample.jpg --weights yolov4.weights \
             --config_file cfg/yolov4.cfg --data_file cfg/coco.data
```

Check the [troubleshooting docker GUI apps section](#troubleshooting-docker-gui-apps) for more information about
the `xhost` command.

### Video inference

Python is not the most suitable language to handle video streams. Compared to other compiled languages like *C++* or
SDKs such as [NVIDIA DeepStream](https://developer.nvidia.com/deepstream-sdk), video inference won't run as smoothly.
However, it is possible to perform real-time tracking on Python using its `multiprocessing` module and a powerful GPU.
YOLOv4 & SORT run at 15fps on a system with an *Intel Core i7* and a *GeForce GTX 1080*. Mobile GPUs such as the
*Quadro M1000M* run YOLOv4 at 3fps but can run YOLOv4-Tiny at 60fps.

You can test video inference using the [sample code in this repo](./test) taken from
the [Darknet repository](https://github.com/AlexeyAB/darknet/blob/master/darknet_video.py "darknet_video.py"):

```bash
$ git clone https://github.com/gmontamat/python-darknet-docker.git
$ cd python-darknet-docker
$ wget https://github.com/intel-iot-devkit/sample-videos/raw/master/face-demographics-walking.mp4 \
       -O test/face-demographics-walking.mp4
$ wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v4_pre/yolov4-tiny.weights \
       -O test/yolov4-tiny.weights
$ xhost +
$ docker run --gpus all -it --rm -v $(realpath ./test):/usr/src/app \
             -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY \
             -w /usr/src/app gmontamat/python-darknet:gpu python3 darknet_video.py \
             --input face-demographics-walking.mp4 --weights yolov4-tiny.weights \
             --config_file cfg/yolov4-tiny.cfg --data_file cfg/coco.data
```

Or, if you prefer using your webcam (`/dev/video0` on Linux):

```bash
$ git clone https://github.com/gmontamat/python-darknet-docker.git
$ cd python-darknet-docker
$ wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v4_pre/yolov4-tiny.weights \
       -O test/yolov4-tiny.weights
$ xhost +
$ docker run --gpus all -it --rm -v $(realpath ./test):/usr/src/app \
             -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY \
             --device=/dev/video0 -w /usr/src/app gmontamat/python-darknet:gpu \
             python3 darknet_video.py --weights yolov4-tiny.weights \
             --config_file cfg/yolov4-tiny.cfg --data_file cfg/coco.data
```

#### Troubleshooting docker GUI apps

Running `xhost +` grants any local user access to your X screen. That might be OK for a single-user machine, but usually
not for a multi-user system. To get things back to normal, with controlled access to the X screen, run `xhost -`.

If you skip this command, you may encounter an error message like the following:

```
No protocol specified
Error: Can't open display X:X
```

It can also be fixed by running `xhost local:root` before you start the container, if you use Docker with `sudo`. Or, if
you use the `docker` group to run containers without `sudo`, run `xhost local:docker`.

### Advanced usage

These images can serve as base images for more complex Docker applications where additional packages and dependencies
are required. In such case, begin the `Dockerfile` with:

```dockerfile
FROM gmontamat/python-darknet:gpu
```

## TODO

- [ ] Support other python versions (3.7/3.8/3.9)
- [ ] Use different base images (ubuntu20.04/python3.9)
- [ ] Compile OpenCV python library for CUDA support instead of just using pre-built binaries
  from [opencv-python](https://pypi.org/project/opencv-python/)

These images are still a work in progress. Feel free to submit feature requests
in [the issues page](https://github.com/gmontamat/python-darknet-docker/issues).
