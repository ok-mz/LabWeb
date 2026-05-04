<template>
  <div class="admin-layout">
    <!-- 侧边栏 -->
    <el-aside width="220px" class="admin-aside">
      <div class="aside-header">
        <el-icon :size="26" color="#fff"><Monitor /></el-icon>
        <span class="aside-title">后台管理</span>
      </div>
      <el-menu
        :default-active="activeMenu"
        background-color="#1a3a5c"
        text-color="#ccc"
        active-text-color="#fff"
        router
      >
        <el-menu-item index="/admin/lab-info">
          <el-icon><OfficeBuilding /></el-icon>
          <span>实验室信息</span>
        </el-menu-item>
        <el-menu-item index="/admin/research">
          <el-icon><DataAnalysis /></el-icon>
          <span>研究方向</span>
        </el-menu-item>
        <el-menu-item index="/admin/publications">
          <el-icon><Document /></el-icon>
          <span>发表成果</span>
        </el-menu-item>
        <el-menu-item index="/admin/tools">
          <el-icon><Tools /></el-icon>
          <span>科研工具</span>
        </el-menu-item>
        <el-menu-item index="/admin/agents">
          <el-icon><Cpu /></el-icon>
          <span>智能助手</span>
        </el-menu-item>
      </el-menu>
    </el-aside>

    <!-- 右侧主体 -->
    <div class="admin-main">
      <!-- 顶栏 -->
      <header class="admin-header">
        <div class="header-left">
          <span class="header-title">生物信息学与基因组学实验室</span>
        </div>
        <div class="header-right">
          <span class="header-user">
            <el-icon><User /></el-icon>
            {{ username }}
          </span>
          <el-button text size="small" @click="handleLogout">
            <el-icon><SwitchButton /></el-icon>
            退出登录
          </el-button>
        </div>
      </header>

      <!-- 内容区 -->
      <div class="admin-content">
        <router-view />
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()

const activeMenu = computed(() => route.path)
const username = computed(() => authStore.username || '管理员')

function handleLogout() {
  authStore.logout()
  router.push('/admin/login')
}
</script>

<style scoped>
.admin-layout {
  display: flex;
  min-height: 100vh;
}
.admin-aside {
  background: #1a3a5c;
  overflow-y: auto;
  flex-shrink: 0;
}
.aside-header {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 24px 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}
.aside-title {
  font-size: 17px;
  font-weight: 600;
  color: #fff;
}
.el-menu {
  border-right: none;
}
.el-menu-item.is-active {
  background-color: #2a6496 !important;
}
.admin-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  background: #f5f7fa;
  min-width: 0;
}
.admin-header {
  height: 56px;
  background: #fff;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.06);
}
.header-title {
  font-size: 15px;
  color: #1a3a5c;
  font-weight: 600;
}
.header-right {
  display: flex;
  align-items: center;
  gap: 20px;
}
.header-user {
  font-size: 14px;
  color: #666;
  display: flex;
  align-items: center;
  gap: 4px;
}
.admin-content {
  flex: 1;
  padding: 24px;
  overflow-y: auto;
}
</style>
