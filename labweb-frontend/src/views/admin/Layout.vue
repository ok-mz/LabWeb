<template>
  <div class="admin-layout">
    <el-aside width="220px" class="admin-aside">
      <div class="aside-header">
        <span class="aside-mark">
          <el-icon :size="20"><Monitor /></el-icon>
        </span>
        <div>
          <span class="aside-title">后台管理</span>
          <small>LabWeb Console</small>
        </div>
      </div>

      <el-menu
        :default-active="activeMenu"
        background-color="transparent"
        text-color="var(--color-muted)"
        active-text-color="var(--color-primary)"
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
        <el-menu-item index="/admin/operation-logs">
          <el-icon><Notebook /></el-icon>
          <span>操作日志</span>
        </el-menu-item>
        <el-menu-item index="/admin/agent-usage-logs">
          <el-icon><DataLine /></el-icon>
          <span>使用日志</span>
        </el-menu-item>
      </el-menu>
    </el-aside>

    <div class="admin-main">
      <header class="admin-header">
        <div class="header-left">
          <span class="header-title">生物信息学与基因组学实验室</span>
        </div>
        <div class="header-right">
          <span class="header-user">
            <el-icon><User /></el-icon>
            {{ username }}
          </span>
          <el-button type="primary" plain size="small" @click="handleLogout">
            <el-icon><SwitchButton /></el-icon>
            退出登录
          </el-button>
        </div>
      </header>

      <main class="admin-content">
        <router-view />
      </main>
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
  background: #f5f7fa;
}

.admin-aside {
  flex-shrink: 0;
  overflow-y: auto;
  background: #fff;
  border-right: 1px solid var(--color-border);
}

.aside-header {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 20px 16px;
  border-bottom: 1px solid var(--color-border);
}

.aside-mark {
  width: 36px;
  height: 36px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  color: var(--color-primary);
  border-radius: 8px;
  background: var(--color-primary-soft);
}

.aside-title {
  display: block;
  color: var(--color-ink);
  font-size: 15px;
  font-weight: 700;
  line-height: 1.3;
}

.aside-header small {
  color: var(--color-subtle);
  font-size: 11px;
}

.el-menu {
  border-right: none;
  padding: 8px;
}

.el-menu-item {
  height: 42px;
  margin-bottom: 2px;
  border-radius: 6px;
  font-size: 14px;
}

.el-menu-item:hover {
  background: var(--color-primary-soft) !important;
}

.el-menu-item.is-active {
  background: var(--color-primary-soft) !important;
  font-weight: 600;
}

.admin-main {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
}

.admin-header {
  min-height: 56px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  padding: 0 24px;
  background: #fff;
  border-bottom: 1px solid var(--color-border);
}

.header-title {
  color: var(--color-ink);
  font-size: 15px;
  font-weight: 600;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.header-user {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  color: var(--color-muted);
  font-size: 13px;
}

.admin-content {
  flex: 1;
  min-width: 0;
  padding: 24px;
  overflow-y: auto;
}

@media (max-width: 900px) {
  .admin-layout {
    flex-direction: column;
  }

  .admin-aside {
    width: 100% !important;
  }

  .el-menu {
    display: flex;
    overflow-x: auto;
  }

  .el-menu-item {
    flex-shrink: 0;
  }

  .admin-header {
    align-items: flex-start;
    flex-direction: column;
    padding: 12px 16px;
  }
}
</style>
