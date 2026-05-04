<template>
  <div class="about-page">
    <NavBar />

    <section class="page-banner">
      <h1>实验室介绍</h1>
      <p>了解我们的研究背景、团队方向与发展愿景</p>
    </section>

    <div class="page-content">
      <el-skeleton v-if="loading" :rows="8" animated />
      <template v-else-if="info">
        <div class="about-header">
          <el-image
            v-if="info.coverImage"
            :src="info.coverImage"
            fit="cover"
            class="cover-image"
          />
          <div class="about-header-text">
            <h2>{{ info.labName || '实验室名称' }}</h2>
            <div class="about-meta">
              <span><el-icon><OfficeBuilding /></el-icon> {{ info.school }}</span>
              <span><el-icon><School /></el-icon> {{ info.college }}</span>
              <span><el-icon><User /></el-icon> 负责人：{{ info.leader }}</span>
            </div>
          </div>
        </div>

        <el-divider />

        <div class="about-section" v-if="info.introduction">
          <h3>实验室简介</h3>
          <p class="about-text">{{ info.introduction }}</p>
        </div>

        <div class="about-section" v-if="info.researchGoal">
          <h3>研究目标</h3>
          <p class="about-text">{{ info.researchGoal }}</p>
        </div>

        <el-divider />

        <div class="about-section">
          <h3>研究方向</h3>
          <el-row :gutter="20">
            <el-col v-for="dir in directions" :key="dir.id" :xs="24" :sm="12" :md="6">
              <div class="dir-card card-item">
                <h4>{{ dir.title }}</h4>
                <p>{{ dir.summary }}</p>
              </div>
            </el-col>
          </el-row>
        </div>

        <el-divider />

        <div class="about-contact" v-if="info">
          <h3>联系方式</h3>
          <el-descriptions :column="2" border>
            <el-descriptions-item label="办公地点">{{ info.location }}</el-descriptions-item>
            <el-descriptions-item label="电子邮箱">{{ info.email }}</el-descriptions-item>
          </el-descriptions>
        </div>
      </template>
      <el-empty v-else description="暂无实验室信息" />
    </div>

    <Footer />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import NavBar from '@/components/front/NavBar.vue'
import Footer from '@/components/front/Footer.vue'
import { useLabStore } from '@/stores/lab'
import { getResearchDirections } from '@/api/research'

const labStore = useLabStore()
const info = ref(null)
const directions = ref([])
const loading = ref(true)

onMounted(async () => {
  try {
    info.value = await labStore.fetchLabInfo()
    const res = await getResearchDirections()
    directions.value = res.data.data || []
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.cover-image {
  width: 100%;
  max-height: 360px;
  border-radius: 8px;
  margin-bottom: 24px;
  object-fit: cover;
}
.about-header-text h2 {
  font-size: 26px;
  color: #1a3a5c;
  margin-bottom: 12px;
}
.about-meta {
  display: flex;
  gap: 24px;
  color: #666;
  font-size: 14px;
  flex-wrap: wrap;
}
.about-meta span {
  display: flex;
  align-items: center;
  gap: 4px;
}
.about-section {
  margin: 32px 0;
}
.about-section h3 {
  font-size: 20px;
  color: #1a3a5c;
  margin-bottom: 16px;
  padding-left: 12px;
  border-left: 3px solid #2a6496;
}
.about-text {
  font-size: 15px;
  color: #555;
  line-height: 2;
  text-indent: 2em;
}
.dir-card {
  margin-bottom: 16px;
}
.dir-card h4 {
  font-size: 16px;
  color: #1a3a5c;
  margin-bottom: 8px;
}
.dir-card p {
  font-size: 13px;
  color: #888;
  line-height: 1.7;
}
.about-contact {
  margin: 32px 0;
}
.about-contact h3 {
  font-size: 20px;
  color: #1a3a5c;
  margin-bottom: 16px;
  padding-left: 12px;
  border-left: 3px solid #2a6496;
}
</style>
