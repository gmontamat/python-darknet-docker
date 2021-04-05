# Darknet & Python Docker Images

Python Docker image with the [Darknet](https://github.com/AlexeyAB/darknet) package included. These images reduce the
burden of compiling Darknet's library (`libdarknet.so`) and use it on Python to create YOLOv4, v3, v2 sample apps. Based
on [daisukekobayashi's darknet-docker images](https://github.com/daisukekobayashi/darknet-docker).

## Base Image Tags

CPU images are based on [Ubuntu Docker Official Images](https://hub.docker.com/_/ubuntu) and GPU images are based on
[nvidia/cuda](https://hub.docker.com/r/nvidia/cuda/). Images include `python 3.6`, an updated version of `pip`, and the
following libraries:

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

```bash
$ sudo docker run --gpus all -it --rm -v $(realpath .):/usr/src/app -v /tmp/.X11-unix:/tmp/.X11-unix \
                  -e DISPLAY=unix$DISPLAY -w /usr/src/app gmontamat/python-darknet:gpu-cv python3 darknet_video.py \
                  --input face-demographics-walking.mp4 --weights yolov4.weights --config_file ./cfg/yolov4.cfg \
                  --data_file ./cfg/coco.data
```

## TODO

- [ ] Support other python versions (3.7/3.8/3.9)
- [ ] Use different base images (ubuntu20.04/python3.9)
- [ ] Compile OpenCV python library for CUDA support instead of just using pre-built binaries
  from [opencv-python](https://pypi.org/project/opencv-python/)

These images are still a work in progress. Feel free to submit feature requests
in [the issues page](https://github.com/gmontamat/python-darknet-docker/issues).
