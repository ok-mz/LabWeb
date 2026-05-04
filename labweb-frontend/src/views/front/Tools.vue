<template>
  <div class="tools-page">
    <NavBar />

    <section class="page-banner">
      <h1>科研工具</h1>
      <p>实验室自主研发与维护的生物信息学分析工具</p>
    </section>

    <div class="page-content">
      <el-skeleton v-if="loading" :rows="6" animated />

      <template v-else-if="tools.length > 0">
        <el-row :gutter="24">
          <el-col v-for="item in tools" :key="item.id" :xs="24" :sm="12" :md="8">
            <div class="tool-card card-item">
              <div class="tool-header">
                <div class="tool-icon">
                  <el-image v-if="item.icon" :src="item.icon" fit="contain" style="width:48px;height:48px" />
                  <el-icon v-else :size="40"><Tools /></el-icon>
                </div>
                <el-tag :type="item.status === '可用' ? 'success' : 'warning'" size="small">
                  {{ item.status }}
                </el-tag>
              </div>
              <h3>{{ item.name }}</h3>
              <p class="tool-summary">{{ item.summary }}</p>
              <div class="tool-actions">
                <el-button v-if="item.accessUrl" type="primary" size="small" @click="openUrl(item.accessUrl)">
                  立即使用
                </el-button>
                <el-button v-if="item.docUrl" size="small" @click="openUrl(item.docUrl)">
                  查看文档
                </el-button>
              </div>
            </div>
          </el-col>
        </el-row>
      </template>

      <el-empty v-else description="暂无科研工具" />
    </div>

    <Footer />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import NavBar from '@/components/front/NavBar.vue'
import Footer from '@/components/front/Footer.vue'
import { getTools } from '@/api/tool'

const tools = ref([])
const loading = ref(true)

function openUrl(url) {
  if (url) window.open(url, '_blank')
}

onMounted(async () => {
  try {
    const res = await getTools()
    tools.value = res.data.data || []
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.tool-card {
  margin-bottom: 24px;
  padding: 28px 24px;
  min-height: 220px;
  display: flex;
  flex-direction: column;
}
.tool-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}
.tool-icon {
  color: #2a6496;
}
.tool-card h3 {
  font-size: 18px;
  color: #1a3a5c;
  margin-bottom: 10px;
}
.tool-summary {
  font-size: 14px;
  color: #888;
  line-height: 1.7;
  flex: 1;
  margin-bottom: 16px;
}
.tool-actions {
  display: flex;
  gap: 10px;
}
</style>
