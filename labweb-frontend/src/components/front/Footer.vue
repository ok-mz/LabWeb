<template>
  <footer class="footer">
    <div class="footer-inner">
      <div class="footer-top">
        <div class="footer-brand">
          <img src="@/assets/images/logo.png" alt="校徽" class="footer-logo" />
          <span class="footer-lab">{{ labInfo?.labName || '生物信息学与基因组学实验室' }}</span>
        </div>
        <div class="footer-links">
          <router-link to="/research">研究方向</router-link>
          <router-link to="/publications">发表成果</router-link>
          <router-link to="/tools">科研工具</router-link>
          <router-link to="/agents">智能助手</router-link>
          <router-link to="/contact">联系我们</router-link>
        </div>
      </div>
      <p class="footer-copy">&copy; {{ currentYear }} {{ labInfo?.labName || '生物信息学与基因组学实验室' }} · {{ labInfo?.email || 'lab@xxu.edu.cn' }}</p>
    </div>
  </footer>
</template>

<script setup>
import { computed, onMounted } from 'vue'
import { useLabStore } from '@/stores/lab'

const labStore = useLabStore()
const labInfo = computed(() => labStore.labInfo)
const currentYear = new Date().getFullYear()

onMounted(() => { labStore.fetchLabInfo() })
</script>

<style scoped>
.footer {
  margin-top: 48px;
  background: #eef3f7;
  border-top: 1px solid var(--color-border);
}

.footer-inner {
  width: min(var(--container), calc(100% - 40px));
  margin: 0 auto;
  padding: 28px 0 20px;
}

.footer-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}

.footer-brand {
  display: flex;
  align-items: center;
  gap: 10px;
}

.footer-logo {
  height: 40px;
  width: auto;
  object-fit: contain;
}

.footer-lab {
  font-size: 14px;
  font-weight: 600;
  color: var(--color-primary);
}

.footer-links {
  display: flex;
  gap: 20px;
}

.footer-links a {
  font-size: 13px;
  color: var(--color-muted);
  transition: color 0.15s ease;
}

.footer-links a:hover {
  color: var(--color-primary);
}

.footer-copy {
  font-size: 12px;
  color: #8a9aac;
  padding-top: 14px;
  border-top: 1px solid var(--color-border);
}

@media (max-width: 640px) {
  .footer-inner {
    width: min(100% - 28px, var(--container));
  }

  .footer-top {
    flex-direction: column;
    gap: 12px;
    align-items: flex-start;
  }

  .footer-links {
    gap: 14px;
    flex-wrap: wrap;
  }
}
</style>
