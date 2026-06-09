#!/bin/bash

# LabWeb 服务器初始化脚本 (Ubuntu/Debian)
set -e

echo "========================================="
echo "  LabWeb 服务器环境安装脚本"
echo "========================================="

read -p "设置 MySQL root 密码（如 labweb2026）: " MYSQL_PASSWORD
MYSQL_PASSWORD=${MYSQL_PASSWORD:-labweb2026}

echo ""
echo "=== 1/4 更新系统 ==="
sudo apt update && sudo apt upgrade -y

echo ""
echo "=== 2/4 安装 Java 17 ==="
sudo apt install -y openjdk-17-jdk
echo "Java: $(java -version 2>&1 | head -1)"

echo ""
echo "=== 3/4 安装 MySQL 8.0 ==="
sudo apt install -y mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASSWORD}';"
sudo mysql -e "CREATE DATABASE IF NOT EXISTS labweb DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sudo mysql -e "FLUSH PRIVILEGES;"

echo ""
echo "=== 4/4 安装 Nginx ==="
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

sudo mkdir -p /opt/labweb/{frontend,backend,uploads}
sudo chown -R $USER:$USER /opt/labweb

echo ""
echo "========================================="
echo "  安装完成！"
echo "  MySQL 密码: ${MYSQL_PASSWORD}"
echo "  请记住此密码，部署时需要用到"
echo "========================================="
