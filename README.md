# Darknet & Python Docker Images

Python Docker image with the [Darknet](https://github.com/AlexeyAB/darknet) package included. These images reduce the
burden of compiling Darknet's library (`libdarknet.so`) and use it on Python to create YOLOv4, v3, v2 sample apps. Based
on [daisukekobayashi's darknet-docker images](https://github.com/daisukekobayashi/darknet-docker).

## Base Image Tags

CPU images are based on [Ubuntu Docker Official Images](https://hub.docker.com/_/ubuntu) (`ubuntu:18.04`) and GPU images
are based on [nvidia/cuda](https://hub.docker.com/r/nvidia/cuda/) (`nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04`).
Images include `python 3.6`, an updated version of `pip`, and the following libraries:

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

## Usage

### Basic

```
$ sudo docker run -it --rm gmontamat/python-darknet:cpu
Python 3.6.9 (default, Jan 26 2021, 15:33:00)
[GCC 8.4.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import darknet
>>> import numpy as np
>>> import cv2
>>> 
```

### Video inference

Python is not the most suitable language to handle video streams. Compared to other compiled languages like *C++* or
SDKs such as [NVIDIA DeepStream](https://developer.nvidia.com/deepstream-sdk), video inference won't run as smoothly.
However, it is possible to perform real-time tracking on Python using its `multiprocessing` module and a powerful GPU.
YOLOv4+SORT runs at ~15fps on a system with an *Intel Core i7* and a *GeForce GTX 1080*. Mobile GPUs such as the
*Quadro M1000M* run YOLOv4 at 4fps but can run YOLOv4-Tiny at 30fps.

You can test video inference using the [sample code in this repo](./test/video) taken from
the [Darknet repository](https://github.com/AlexeyAB/darknet/blob/master/darknet_video.py):

```bash
$ git clone https://github.com/gmontamat/python-darknet-docker.git
$ cd python-darknet-docker
$ wget https://github.com/intel-iot-devkit/sample-videos/raw/master/face-demographics-walking.mp4 \
       -O test/video/face-demographics-walking.mp4
$ wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v4_pre/yolov4-tiny.weights \
       -O test/video/yolov4-tiny.weights
$ sudo docker run --gpus all -it --rm -v $(realpath ./test/video):/usr/src/app \
                  -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY \
                  -w /usr/src/app gmontamat/python-darknet:gpu python3 darknet_video.py \
                  --input face-demographics-walking.mp4 --weights yolov4-tiny.weights \
                  --config_file cfg/yolov4-tiny.cfg --data_file cfg/coco.data
```

Or, if you prefer using your webcam (`/dev/video0` on Linux):

```bash
$ git clone https://github.com/gmontamat/python-darknet-docker.git
$ cd python-darknet-docker
$ sudo docker run --gpus all -it --rm -v $(realpath ./test/video):/usr/src/app \
                  -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY \
                  --device=/dev/video0 -w /usr/src/app gmontamat/python-darknet:gpu \
                  python3 darknet_video.py --weights yolov4-tiny.weights \
                  --config_file cfg/yolov4-tiny.cfg --data_file cfg/coco.data
```

If you encounter the following error:

```
No protocol specified
Error: Can't open display X:X
```

Fix it by running `xhost local:root` before you start the container, if you use Docker with `sudo`. Or, if you use
the `docker` group to run containers without `sudo`, use `xhost local:docker`.

## TODO

- [ ] Support other python versions (3.7/3.8/3.9)
- [ ] Use different base images (ubuntu20.04/python3.9)
- [ ] Compile OpenCV python library for CUDA support instead of just using pre-built binaries
  from [opencv-python](https://pypi.org/project/opencv-python/)

These images are still a work in progress. Feel free to submit feature requests
in [the issues page](https://github.com/gmontamat/python-darknet-docker/issues).
