<template>
  <header class="navbar">
    <div class="navbar-inner">
      <router-link to="/" class="navbar-logo">
        <el-icon :size="28"><Monitor /></el-icon>
        <span class="logo-text">生物信息学与基因组学实验室</span>
      </router-link>
      <nav class="navbar-menu">
        <router-link v-for="item in menuItems" :key="item.path" :to="item.path" class="navbar-link">
          {{ item.label }}
        </router-link>
      </nav>
      <div class="navbar-right">
        <router-link to="/admin/login" class="btn-login">
          <el-icon><User /></el-icon>
          <span>登录</span>
        </router-link>
      </div>
    </div>
  </header>
</template>

<script setup>
const menuItems = [
  { path: '/', label: '首页' },
  { path: '/about', label: '实验室介绍' },
  { path: '/research', label: '研究方向' },
  { path: '/publications', label: '发表成果' },
  { path: '/tools', label: '科研工具' },
  { path: '/agents', label: '智能助手' },
  { path: '/contact', label: '联系我们' }
]
</script>

<style scoped>
.navbar {
  position: sticky;
  top: 0;
  z-index: 100;
  background: #fff;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}
.navbar-inner {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  height: 64px;
  padding: 0 20px;
}
.navbar-logo {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #1a3a5c;
  margin-right: 40px;
}
.logo-text {
  font-size: 18px;
  font-weight: 600;
  white-space: nowrap;
}
.navbar-menu {
  display: flex;
  gap: 4px;
  flex: 1;
}
.navbar-link {
  padding: 8px 14px;
  font-size: 15px;
  color: #555;
  border-radius: 4px;
  transition: color 0.2s, background 0.2s;
}
.navbar-link:hover,
.navbar-link.router-link-active {
  color: #2a6496;
  background: #e8f4fd;
}
.navbar-right {
  margin-left: 20px;
}
.btn-login {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 7px 18px;
  font-size: 14px;
  color: #2a6496;
  border: 1px solid #2a6496;
  border-radius: 4px;
  transition: all 0.2s;
}
.btn-login:hover {
  color: #fff;
  background: #2a6496;
}
</style>
