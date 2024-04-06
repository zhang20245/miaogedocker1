#!/bin/bash

# 喵哥一键安装docker
# 作者: 喵哥
# 版本: 1.0

# 支持的操作系统和包管理器
declare -A osInfo;
osInfo[/etc/redhat-release]="yum -y install"
osInfo[/etc/arch-release]="pacman -Sy"
osInfo[/etc/debian_version]="apt-get install -y"

# 检测操作系统
for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        package_manager=${osInfo[$f]}
    fi
done

# 检测包管理器
if [ -z "$package_manager" ]; then
    echo "无法确定你的操作系统或包管理器。"
    exit 1
fi

# 安装Docker所需的依赖
if [ "$package_manager" == "apt-get install -y" ]; then
    $package_manager apt-transport-https ca-certificates curl software-properties-common
elif [ "$package_manager" == "yum -y install" ]; then
    $package_manager yum-utils device-mapper-persistent-data lvm2
elif [ "$package_manager" == "pacman -Sy" ]; then
    $package_manager docker
else
    echo "不支持的包管理器。"
    exit 1
fi

# 添加Docker的官方GPG密钥
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# 设置稳定的Docker存储库
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# 再次更新软件包列表
sudo apt-get update

# 安装Docker CE
sudo apt-get install -y docker-ce

# 启动Docker服务
sudo systemctl start docker

# 启用Docker服务以便在启动时启动
sudo systemctl enable docker

# 验证Docker是否已正确安装
sudo docker run hello-world

echo "喵哥Docker一键安装完成。"