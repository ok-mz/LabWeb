# LabWeb 部署指南 - Oracle Cloud 永久免费方案

## 一、注册 Oracle Cloud 账号

1. 访问 https://cloud.oracle.com/
2. 点击 "Start for Free"
3. 填写注册信息：
   - 国家/地区：China
   - 手机号：+86 你的手机号
   - 需要信用卡验证（不会扣费）
4. 注册完成后登录控制台

## 二、创建虚拟机实例

### 2.1 进入创建页面
1. 登录后点击左上角菜单 → **Compute** → **Instances**
2. 点击 **Create Instance**

### 2.2 配置实例
- **Name**: `labweb-server`
- **Image**: Ubuntu 22.04 Minimal (aarch64) - ARM 架构
- **Shape**: `VM.Standard.A1.Flex` (ARM，4 OCPU，24GB 内存，永久免费)
  - 或 `VM.Standard.E2.1.Micro` (AMD，1 OCPU，1GB 内存，永久免费)

### 2.3 配置网络
- **Virtual cloud network**: 创建新的或使用默认
- **Subnet**: 创建新的或使用默认
- **Public IP**: 分配公网 IP (勾选 Assign a public IPv4 address)

### 2.4 配置 SSH 密钥
- 选择 "Generate a key pair" 下载私钥文件（`.pem`）
- 或上传你自己的公钥

### 2.5 创建实例
点击 **Create**，等待实例状态变为 **Running**

## 三、连接服务器

```bash
# Windows PowerShell 或 Git Bash
chmod 400 ~/Downloads/labweb-server-key.pem
ssh -i ~/Downloads/labweb-server-key.pem ubuntu@<公网IP>
```

## 四、初始化服务器环境

```bash
# 上传部署脚本
scp -i ~/Downloads/labweb-server-key.pem -r deploy/ ubuntu@<公网IP>:~/

# 连接服务器后执行
ssh -i ~/Downloads/labweb-server-key.pem ubuntu@<公网IP>
chmod +x ~/deploy/setup-server.sh
sudo ~/deploy/setup-server.sh
```

## 五、配置 MySQL 密码

```bash
# 连接 MySQL
sudo mysql -u root

# 修改密码（替换 your_password_here）
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your_password_here';
FLUSH PRIVILEGES;
EXIT;
```

## 六、构建并上传项目

### 6.1 本地构建前端
```bash
cd labweb-frontend
npm run build
```

### 6.2 本地构建后端
```bash
cd labweb-backend
mvn clean package -DskipTests
```

### 6.3 上传到服务器
```bash
# 上传前端
scp -i <密钥文件> -r labweb-frontend/dist/ ubuntu@<公网IP>:/opt/labweb/frontend/

# 上传后端
scp -i <密钥文件> labweb-backend/target/*.jar ubuntu@<公网IP>:/opt/labweb/backend/app.jar

# 上传 schema.sql
scp -i <密钥文件> labweb-backend/src/main/resources/schema.sql ubuntu@<公网IP>:~/
```

### 6.4 初始化数据库
```bash
# 在服务器上执行
mysql -u root -p labweb < ~/schema.sql
```

## 七、部署应用

```bash
# 上传配置文件
scp -i <密钥文件> deploy/nginx.conf ubuntu@<公网_IP>:~/
scp -i <密钥文件> labweb-backend/src/main/resources/application-prod.yml ubuntu@<公网_IP>:/opt/labweb/backend/

# 在服务器上执行部署
sudo ~/deploy/deploy.sh
```

## 八、配置防火墙

Oracle Cloud 默认只开放 22 端口，需要手动开放 80 和 443：

### 8.1 云控制台配置
1. 进入 **Networking** → **Virtual Cloud Networks**
2. 点击你的 VCN → **Security Lists** → **Default Security List**
3. 添加入站规则：
   - Source CIDR: `0.0.0.0/0`
   - IP Protocol: `TCP`
   - Destination Port Range: `80,443`

### 8.2 服务器防火墙
```bash
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT 7 -m state --state NEW -p tcp --dport 443 -j ACCEPT
sudo netfilter-persistent save
```

## 九、访问网站

在浏览器中访问：`http://<公网IP>`

## 十、配置域名（可选）

如果你有域名，可以：
1. 添加 A 记录指向服务器公网 IP
2. 修改 `/etc/nginx/sites-available/labweb` 中的 `server_name`
3. 安装 SSL 证书：`sudo apt install certbot python3-certbot-nginx && sudo certbot --nginx`

## 常见问题

### 1. 无法访问网站
- 检查 Oracle Cloud 安全列表是否开放 80 端口
- 检查服务器防火墙：`sudo iptables -L -n`
- 检查 Nginx 状态：`sudo systemctl status nginx`

### 2. 数据库连接失败
- 检查 MySQL 是否运行：`sudo systemctl status mysql`
- 检查密码是否正确
- 检查数据库是否初始化

### 3. 后端启动失败
- 查看日志：`sudo journalctl -u labweb-backend -f`
- 检查 Java 版本：`java -version`
- 检查端口是否被占用：`sudo netstat -tlnp | grep 8080`
