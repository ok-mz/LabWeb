<template>
  <header class="navbar">
    <div class="navbar-inner">
      <router-link to="/" class="navbar-logo">
        <img src="@/assets/images/logo.png" alt="校徽" class="logo-img" />
        <span class="logo-copy">
          <strong>生物信息学与基因组学实验室</strong>
          <small>Bioinformatics & Genomics Lab</small>
        </span>
      </router-link>

      <nav class="navbar-menu" aria-label="主导航">
        <router-link v-for="item in menuItems" :key="item.path" :to="item.path" class="navbar-link">
          {{ item.label }}
        </router-link>
      </nav>

      <router-link to="/admin/login" class="btn-login" title="后台登录">
        <el-icon><User /></el-icon>
        <span>后台</span>
      </router-link>
    </div>
  </header>
</template>

<script setup>
const menuItems = [
  { path: '/', label: '首页' },
  { path: '/about', label: '实验室概况' },
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
  border-bottom: 1px solid rgba(220, 231, 238, 0.9);
  background: rgba(255, 255, 255, 0.92);
  backdrop-filter: blur(14px);
}

.navbar-inner {
  width: min(var(--container), calc(100% - 40px));
  min-height: 72px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  gap: 24px;
}

.navbar-logo {
  display: inline-flex;
  align-items: center;
  gap: 12px;
  min-width: 280px;
  color: var(--color-ink);
}

.logo-img {
  height: 48px;
  width: auto;
  object-fit: contain;
  flex-shrink: 0;
}

.logo-copy {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.logo-copy strong {
  font-size: 16px;
  line-height: 1.25;
  white-space: nowrap;
}

.logo-copy small {
  color: var(--color-subtle);
  font-size: 12px;
}

.navbar-menu {
  flex: 1;
  min-width: 0;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 2px;
}

.navbar-link {
  position: relative;
  padding: 10px 12px;
  color: var(--color-muted);
  font-size: 14px;
  border-radius: 8px;
  transition: color 0.2s ease, background 0.2s ease;
}

.navbar-link:hover,
.navbar-link.router-link-active {
  color: var(--color-primary);
  background: var(--color-primary-soft);
}

.btn-login {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  height: 38px;
  padding: 0 14px;
  color: var(--color-primary-deep);
  border: 1px solid var(--color-border);
  border-radius: 8px;
  background: #fff;
  font-size: 14px;
  transition: all 0.2s ease;
}

.btn-login:hover {
  color: #fff;
  border-color: var(--color-primary);
  background: var(--color-primary);
}

@media (max-width: 1080px) {
  .navbar-inner {
    align-items: flex-start;
    flex-wrap: wrap;
    gap: 12px;
    padding: 12px 0;
  }

  .navbar-logo {
    flex: 1;
  }

  .navbar-menu {
    order: 3;
    width: 100%;
    justify-content: flex-start;
    overflow-x: auto;
    padding-bottom: 2px;
  }
}

@media (max-width: 640px) {
  .navbar-inner {
    width: min(100% - 28px, var(--container));
  }

  .navbar-logo {
    min-width: 0;
  }

  .logo-copy strong {
    white-space: normal;
    font-size: 15px;
  }

  .logo-copy small {
    display: none;
  }
}
</style>
