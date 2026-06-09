#!/bin/bash

# Oracle Cloud 服务器初始化脚本
# 适用于 Ubuntu 22.04 ARM 实例

set -e

echo "=== 更新系统 ==="
sudo apt update && sudo apt upgrade -y

echo "=== 安装 Java 17 ==="
sudo apt install -y openjdk-17-jdk

echo "=== 安装 Node.js 18 ==="
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

echo "=== 安装 MySQL 8.0 ==="
sudo apt install -y mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql

echo "=== 安装 Nginx ==="
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

echo "=== 创建部署目录 ==="
sudo mkdir -p /opt/labweb
sudo mkdir -p /opt/labweb/frontend
sudo mkdir -p /opt/labweb/backend
sudo mkdir -p /opt/labweb/uploads
sudo chown -R $USER:$USER /opt/labweb

echo "=== 配置 MySQL ==="
# 设置 root 密码（请修改为你的密码）
MYSQL_ROOT_PASSWORD="your_password_here"

sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';"
sudo mysql -e "CREATE DATABASE IF NOT EXISTS labweb DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sudo mysql -e "FLUSH PRIVILEGES;"

echo "=== 安装完成 ==="
echo "Java 版本: $(java -version 2>&1 | head -1)"
echo "Node.js 版本: $(node -v)"
echo "MySQL 已启动"
echo "Nginx 已启动"
