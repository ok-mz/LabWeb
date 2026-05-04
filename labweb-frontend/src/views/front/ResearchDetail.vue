<template>
  <div class="detail-page">
    <NavBar />

    <section class="page-banner">
      <h1>{{ direction.title }}</h1>
      <p>{{ direction.summary }}</p>
    </section>

    <div class="page-content">
      <el-skeleton v-if="loading" :rows="8" animated />

      <template v-else-if="direction">
        <div class="keyword-row" v-if="direction.keywords">
          <el-tag v-for="kw in keywords" :key="kw" class="keyword-tag">{{ kw }}</el-tag>
        </div>

        <el-image
          v-if="direction.imageUrl"
          :src="direction.imageUrl"
          fit="cover"
          class="detail-image"
        />

        <div class="detail-description" v-html="renderedDescription"></div>
      </template>

      <el-empty v-else description="该研究方向不存在" />

      <div class="back-row">
        <el-button @click="$router.push('/research')">
          <el-icon><ArrowLeft /></el-icon> 返回研究方向列表
        </el-button>
      </div>
    </div>

    <Footer />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import NavBar from '@/components/front/NavBar.vue'
import Footer from '@/components/front/Footer.vue'
import { getResearchDetail } from '@/api/research'

const route = useRoute()
const direction = ref(null)
const loading = ref(true)

const keywords = computed(() => {
  if (!direction.value?.keywords) return []
  return direction.value.keywords.split(',').map(k => k.trim()).filter(Boolean)
})

const renderedDescription = computed(() => {
  if (!direction.value?.description) return ''
  return direction.value.description
    .replace(/\n/g, '<br/>')
    .replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
})

onMounted(async () => {
  try {
    const res = await getResearchDetail(route.params.id)
    direction.value = res.data.data
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.keyword-row {
  display: flex;
  gap: 10px;
  margin-bottom: 28px;
  flex-wrap: wrap;
}
.keyword-tag {
  background: #e8f4fd;
  color: #2a6496;
  border: none;
  font-size: 13px;
}
.detail-image {
  width: 100%;
  max-height: 400px;
  border-radius: 8px;
  margin-bottom: 32px;
  object-fit: cover;
}
.detail-description {
  font-size: 15px;
  color: #444;
  line-height: 2.2;
}
.detail-description :deep(strong) {
  color: #1a3a5c;
  font-weight: 600;
}
.back-row {
  margin-top: 40px;
  text-align: center;
}
</style>
