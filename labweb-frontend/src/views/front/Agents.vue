<template>
  <div class="agents-page">
    <NavBar />

    <section class="page-banner">
      <h1>智能助手</h1>
      <p>整合实验室自研与外部接入的 AI 分析工具，为基因组数据解析、药物研发和科研问答提供快捷入口。</p>
    </section>

    <main class="page-content">
      <el-skeleton v-if="loading" :rows="8" animated />

      <template v-else-if="agents.length > 0">
        <div class="agents-toolbar">
          <div>
            <span class="section-kicker">AI Agents</span>
            <h2 class="section-title">工具矩阵</h2>
          </div>
          <p class="muted-text">点击可用工具进入对应服务；访问记录会用于后续统计和维护。</p>
        </div>

        <el-row :gutter="24">
          <el-col v-for="item in agents" :key="item.id" :xs="24" :sm="12" :md="8" :lg="6">
            <article class="agent-card card-item">
              <div class="agent-header">
                <div class="agent-icon">
                  <el-image v-if="item.icon" :src="item.icon" fit="contain" style="width:48px;height:48px" />
                  <el-icon v-else :size="30"><Cpu /></el-icon>
                </div>
                <el-tag :type="statusType(item.status)" size="small" effect="plain">
                  {{ item.status || '未接入' }}
                </el-tag>
              </div>

              <h3>{{ item.name }}</h3>
              <p class="agent-summary">{{ item.summary || '该智能助手正在完善说明。' }}</p>

              <div class="agent-meta">
                <span class="meta-item">
                  <el-icon><Connection /></el-icon>
                  {{ integrationLabel(item.integrationType) }}
                </span>
              </div>

              <el-button
                type="primary"
                class="agent-btn"
                :disabled="item.status !== '可用'"
                @click="useAgent(item)"
              >
                {{ item.status === '可用' ? '立即使用' : '暂不可用' }}
              </el-button>
            </article>
          </el-col>
        </el-row>
      </template>

      <el-empty v-else description="暂无智能助手" />
    </main>

    <Footer />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import NavBar from '@/components/front/NavBar.vue'
import Footer from '@/components/front/Footer.vue'
import { getAgents } from '@/api/agent'

const agents = ref([])
const loading = ref(true)

function statusType(status) {
  const map = { 可用: 'success', 未接入: 'info', 维护中: 'warning', 停用: 'danger' }
  return map[status] || 'info'
}

function integrationLabel(type) {
  const map = { link: '外部链接', iframe: '内嵌页面', api: 'API 接口' }
  return map[type] || '外部链接'
}

function useAgent(item) {
  if (item.accessUrl) {
    window.open(item.accessUrl, '_blank')
  }
}

onMounted(async () => {
  try {
    const res = await getAgents({ pageSize: 100 })
    const data = res.data.data
    agents.value = data.records || []
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.agents-toolbar {
  display: flex;
  align-items: end;
  justify-content: space-between;
  gap: 28px;
  margin-bottom: 30px;
}

.agents-toolbar .muted-text {
  max-width: 460px;
}

.agent-card {
  min-height: 320px;
  margin-bottom: 24px;
  display: flex;
  flex-direction: column;
}

.agent-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 18px;
}

.agent-icon {
  width: 58px;
  height: 58px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  color: var(--color-primary);
  border-radius: 8px;
  background: var(--color-primary-soft);
}

.agent-card h3 {
  color: var(--color-ink);
  font-size: 19px;
  line-height: 1.35;
  margin-bottom: 10px;
}

.agent-summary {
  flex: 1;
  color: var(--color-muted);
  font-size: 14px;
  line-height: 1.75;
  display: -webkit-box;
  -webkit-line-clamp: 4;
  -webkit-box-orient: vertical;
  overflow: hidden;
  margin-bottom: 18px;
}

.agent-meta {
  margin-bottom: 18px;
}

.meta-item {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  color: var(--color-muted);
  font-size: 13px;
  padding: 6px 10px;
  background: var(--color-surface-warm);
  border: 1px solid var(--color-border);
  border-radius: 999px;
}

.agent-btn {
  width: 100%;
}

@media (max-width: 768px) {
  .agents-toolbar {
    align-items: flex-start;
    flex-direction: column;
  }
}
</style>
