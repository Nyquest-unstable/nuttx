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

# 如果提供了参数，则尝试配置并构建指定的配置
if [ $# -gt 0 ]; then
    BOARD_CONFIG=$1
    echo "Configuring NuttX for: $BOARD_CONFIG"

    # 进入NuttX根目录
    cd "$(dirname "$0")"

    # 使用configure.sh脚本配置NuttX
    ./tools/configure.sh $BOARD_CONFIG

    # 构建NuttX
    echo "Building NuttX for: $BOARD_CONFIG"
    make

    if [ $? -eq 0 ]; then
        echo "Build successful!"
        echo "Output files:"
        ls -la nuttx*
    else
        echo "Build failed!"
        exit 1
    fi
else
    echo "Usage: $0 <board:config>"
    echo "Example: $0 esp32s3-box:buttons"
    echo ""
    echo "Available ESP32S3 configurations in this directory:"
    echo "- esp32s3-box:buttons (for esp32s3-box with button examples)"
    echo "- esp32s3-box:nsh (default NSH configuration)"
    echo "- esp32s3-box:lvgl (LVGL graphics configuration)"
    echo "- esp32s3-eye:nsh (ESP32-S3 Eye configuration)"
    echo ""
    echo "To configure and build esp32s3-box with button example, run:"
    echo "  $0 esp32s3-box:buttons"
fi