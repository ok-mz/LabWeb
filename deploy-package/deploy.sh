#!/bin/bash

# LabWeb 部署脚本 - 在服务器上执行
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

read -p "MySQL root 密码: " MYSQL_PASSWORD
MYSQL_PASSWORD=${MYSQL_PASSWORD:-labweb2026}

echo ""
echo "=== 1/4 部署前端 ==="
sudo rm -rf /opt/labweb/frontend/*
sudo cp -r "${SCRIPT_DIR}/frontend/"* /opt/labweb/frontend/

echo ""
echo "=== 2/4 部署后端 ==="
sudo cp "${SCRIPT_DIR}/labweb-backend-1.0.0.jar" /opt/labweb/backend/app.jar

echo ""
echo "=== 3/4 配置 Nginx ==="
sudo cp "${SCRIPT_DIR}/nginx.conf" /etc/nginx/sites-available/labweb
sudo ln -sf /etc/nginx/sites-available/labweb /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t && sudo systemctl reload nginx

echo ""
echo "=== 4/4 配置后端服务 ==="
sudo tee /etc/systemd/system/labweb-backend.service > /dev/null <<EOF
[Unit]
Description=LabWeb Backend
After=network.target mysql.service

[Service]
Type=simple
User=root
WorkingDirectory=/opt/labweb/backend
Environment=MYSQL_PASSWORD=${MYSQL_PASSWORD}
ExecStart=/usr/bin/java -jar app.jar --spring.profiles.active=prod
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable labweb-backend
sudo systemctl start labweb-backend

SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || hostname -I | awk '{print $1}')
echo ""
echo "========================================="
echo "  部署完成！"
echo "  访问: http://${SERVER_IP}"
echo "  管理后台: http://${SERVER_IP}/admin/login"
echo "  账号: admin  密码: admin123"
echo "========================================="
