#!/bin/bash

# 部署脚本 - 在服务器上执行

set -e

echo "=== 停止服务 ==="
sudo systemctl stop labweb-backend 2>/dev/null || true

echo "=== 部署前端 ==="
sudo rm -rf /opt/labweb/frontend/*
sudo cp -r ../labweb-frontend/dist/* /opt/labweb/frontend/

echo "=== 部署后端 ==="
sudo cp ../labweb-backend/target/*.jar /opt/labweb/backend/app.jar

echo "=== 配置 Nginx ==="
sudo cp nginx.conf /etc/nginx/sites-available/labweb
sudo ln -sf /etc/nginx/sites-available/labweb /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t && sudo systemctl reload nginx

echo "=== 配置后端服务 ==="
sudo tee /etc/systemd/system/labweb-backend.service > /dev/null <<EOF
[Unit]
Description=LabWeb Backend
After=network.target mysql.service

[Service]
Type=simple
User=root
WorkingDirectory=/opt/labweb/backend
ExecStart=/usr/bin/java -jar app.jar --spring.profiles.active=prod
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable labweb-backend
sudo systemctl start labweb-backend

echo "=== 部署完成 ==="
echo "访问 http://$(curl -s ifconfig.me) 查看网站"
