#!/bin/bash

# 介绍
echo "喵哥Linux防火墙管理，支持Debian，Ubuntu等操作系统"

# 检查脚本是否以root权限运行
if [ "$(id -u)" != "0" ]; then
    echo "请以root权限运行此脚本"
    exit 1
fi

# 检查系统是否为Debian或Ubuntu
if [ -f /etc/debian_version ]; then
    echo "Debian/Ubuntu系统检测到"
else
    echo "不支持的系统"
    exit 1
fi

# 安装ufw
if ! command -v ufw &> /dev/null; then
    echo "ufw防火墙未安装，正在安装..."
    apt-get update
    apt-get install -y ufw
    echo "ufw防火墙安装完成"
else
    echo "ufw防火墙已安装"
fi

# 如果没有传入参数，则显示使用说明
if [ $# -eq 0 ]; then
    echo "用法：$0 [on|off|status]"
    exit 1
fi

# 根据参数开启、关闭或查看防火墙状态
if [ "$1" == "on" ]; then
    echo "开启ufw防火墙"
    ufw enable
elif [ "$1" == "off" ]; then
    echo "关闭ufw防火墙"
    ufw disable
elif [ "$1" == "status" ]; then
    echo "查看ufw防火墙状态"
    ufw status verbose
else
    echo "无效的参数。用法：$0 [on|off|status]"
    exit 1
fi

