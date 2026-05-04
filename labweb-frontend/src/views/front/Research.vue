<template>
  <div class="research-page">
    <NavBar />

    <section class="page-banner">
      <h1>研究方向</h1>
      <p>聚焦四大前沿领域，以计算方法驱动生物学发现</p>
    </section>

    <div class="page-content">
      <el-skeleton v-if="loading" :rows="6" animated />
      <template v-else-if="directions.length > 0">
        <div v-for="item in directions" :key="item.id" class="direction-item card-item">
          <div class="direction-body">
            <div class="direction-header">
              <span class="direction-index">{{ indexText(item.sortOrder) }}</span>
              <div>
                <h3>{{ item.title }}</h3>
                <div class="keywords" v-if="item.keywords">
                  <el-tag v-for="kw in item.keywords.split(',')" :key="kw" size="small" class="keyword-tag">{{ kw.trim() }}</el-tag>
                </div>
              </div>
            </div>
            <p class="direction-summary">{{ item.summary }}</p>
          </div>
        </div>
      </template>
      <el-empty v-else description="暂无研究方向" />
    </div>

    <Footer />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import NavBar from '@/components/front/NavBar.vue'
import Footer from '@/components/front/Footer.vue'
import { getResearchDirections } from '@/api/research'

const directions = ref([])
const loading = ref(true)

function indexText(order) {
  const labels = { 1: '一', 2: '二', 3: '三', 4: '四' }
  return labels[order] || order
}

onMounted(async () => {
  try {
    const res = await getResearchDirections()
    directions.value = res.data.data || []
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.direction-item {
  margin-bottom: 20px;
  cursor: pointer;
  padding: 28px;
}
.direction-body { }
.direction-header {
  display: flex;
  align-items: flex-start;
  gap: 20px;
  margin-bottom: 16px;
}
.direction-index {
  flex-shrink: 0;
  width: 44px;
  height: 44px;
  line-height: 44px;
  text-align: center;
  background: #2a6496;
  color: #fff;
  font-size: 18px;
  font-weight: 600;
  border-radius: 8px;
}
.direction-header h3 {
  font-size: 20px;
  color: #1a3a5c;
  margin-bottom: 8px;
}
.keywords {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}
.keyword-tag {
  background: #e8f4fd;
  color: #2a6496;
  border: none;
}
.direction-summary {
  font-size: 14px;
  color: #666;
  line-height: 1.8;
  margin-bottom: 12px;
}
.direction-more {
  font-size: 14px;
  color: #2a6496;
}
</style>
