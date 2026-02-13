#!/bin/bash

# NuttX build script for ESP32-S3
# This script sets up the ESP-IDF environment and builds NuttX

echo "Setting up ESP-IDF environment..."

# 设置ESP-IDF路径
export IDF_PATH=/home/zc/ESP32-IDF/esp-idf

# 检查ESP-IDF是否存在
if [ ! -d "$IDF_PATH" ]; then
    echo "Error: ESP-IDF directory does not exist at $IDF_PATH"
    echo "Please update the IDF_PATH in this script."
    exit 1
fi

# 激活ESP-IDF环境
echo "Activating ESP-IDF environment..."
source $IDF_PATH/export.sh

echo "ESP-IDF environment activated successfully."

# 检查交叉编译器是否可用
if ! command -v xtensa-esp32s3-elf-gcc &> /dev/null; then
    echo "Error: xtensa-esp32s3-elf-gcc is not available in PATH"
    echo "Please make sure ESP-IDF is properly installed and environment is set."
    exit 1
fi

echo "Cross compiler found: $(which xtensa-esp32s3-elf-gcc)"
