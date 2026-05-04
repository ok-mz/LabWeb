<template>
  <div class="agents-page">
    <NavBar />

    <section class="page-banner">
      <h1>智能助手</h1>
      <p>实验室自主研发的AI智能分析平台，助力科学研究与数据分析</p>
    </section>

    <div class="page-content">
      <el-skeleton v-if="loading" :rows="6" animated />

      <template v-else-if="agents.length > 0">
        <el-row :gutter="24">
          <el-col v-for="item in agents" :key="item.id" :xs="24" :sm="12" :md="6">
            <div class="agent-card card-item">
              <div class="agent-header">
                <div class="agent-icon">
                  <el-image v-if="item.icon" :src="item.icon" fit="contain" style="width:56px;height:56px" />
                  <el-icon v-else :size="48"><Cpu /></el-icon>
                </div>
                <el-tag
                  :type="statusType(item.status)"
                  size="small"
                  effect="plain"
                >
                  {{ item.status || '未接入' }}
                </el-tag>
              </div>

              <h3>{{ item.name }}</h3>
              <p class="agent-summary">{{ item.summary }}</p>

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
            </div>
          </el-col>
        </el-row>
      </template>

      <el-empty v-else description="暂无智能助手" />
    </div>

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
  const map = { '可用': 'success', '未接入': 'info', '维护中': 'warning', '停用': 'danger' }
  return map[status] || 'info'
}

function integrationLabel(type) {
  const map = { link: '外部链接', iframe: '内嵌页面', api: 'API接口' }
  return map[type] || '外部链接'
}

function useAgent(item) {
  if (item.accessUrl) {
    window.open(item.accessUrl, '_blank')
  }
}

onMounted(async () => {
  try {
    const res = await getAgents()
    agents.value = res.data.data || []
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.agent-card {
  margin-bottom: 24px;
  padding: 28px 24px;
  text-align: center;
  min-height: 280px;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.agent-header {
  width: 100%;
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: 16px;
}
.agent-icon {
  color: #2a6496;
}
.agent-card h3 {
  font-size: 18px;
  color: #1a3a5c;
  margin-bottom: 10px;
}
.agent-summary {
  font-size: 13px;
  color: #888;
  line-height: 1.7;
  flex: 1;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
  margin-bottom: 16px;
}
.agent-meta {
  margin-bottom: 16px;
}
.meta-item {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 13px;
  color: #999;
}
.agent-btn {
  width: 100%;
}
</style>
