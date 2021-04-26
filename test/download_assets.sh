#!/bin/bash

VIDEO=face-demographics-walking.mp4
MODEL=yolov4.weights
MODEL_TINY=yolov4-tiny.weights


if [[ -f "$VIDEO" ]]; then
    echo "$VIDEO exists."
else
    wget https://github.com/intel-iot-devkit/sample-videos/raw/master/face-demographics-walking.mp4
fi

if [[ -f "$MODEL" ]]; then
    echo "$MODEL exists."
else
    wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.weights
fi

if [[ -f "$MODEL_TINY" ]]; then
    echo "$MODEL_TINY exists."
else
    wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v4_pre/yolov4-tiny.weights
fi
