<template>
  <div class="home-page">
    <NavBar />

    <!-- 主视觉 Banner -->
    <section class="hero-banner">
      <div class="hero-content">
        <h1 class="hero-title">{{ labInfo?.labName || '生物信息学与基因组学实验室' }}</h1>
        <p class="hero-subtitle">{{ labInfo?.school || 'XX大学' }} · {{ labInfo?.college || '生命科学学院' }}</p>
        <p class="hero-desc">{{ labInfo?.introduction || '本实验室专注于生物信息学与基因组学前沿研究。' }}</p>
        <div class="hero-actions">
          <el-button type="primary" size="large" @click="$router.push('/about')">了解详情</el-button>
        </div>
      </div>
    </section>

    <!-- 研究方向概览 -->
    <section class="section">
      <div class="container">
        <div class="section-header">
          <h2>研究方向</h2>
          <p class="section-subtitle">聚焦四大前沿领域，以计算方法驱动生物学发现</p>
        </div>
        <el-row :gutter="24">
          <el-col v-for="item in directions" :key="item.id" :xs="24" :sm="12" :md="6">
            <div class="direction-card">
              <div class="direction-icon">
                <el-icon :size="36"><component :is="directionIcon(item.id)" /></el-icon>
              </div>
              <h3>{{ item.title }}</h3>
              <p>{{ item.summary }}</p>
            </div>
          </el-col>
        </el-row>
        <div class="section-more">
          <el-button text type="primary" @click="$router.push('/research')">查看全部研究方向 →</el-button>
        </div>
      </div>
    </section>

    <!-- 代表性成果 -->
    <section class="section section-bg">
      <div class="container">
        <div class="section-header">
          <h2>代表性成果</h2>
          <p class="section-subtitle">近年发表的高水平论文与科研成果</p>
        </div>
        <div class="pub-list" v-if="representativePublications.length > 0">
          <div v-for="item in representativePublications" :key="item.id" class="pub-item card-item" @click="$router.push('/publications?filter=representative')">
            <span class="tag">{{ item.type }}</span>
            <h3>{{ item.title }}</h3>
            <p class="pub-authors">{{ item.authors }}</p>
            <p class="pub-venue">{{ item.venue }} · {{ item.year }}</p>
          </div>
        </div>
        <el-empty v-else description="暂无成果展示" />
        <div class="section-more" v-if="representativePublications.length > 0">
          <el-button text type="primary" @click="$router.push('/publications?filter=representative')">查看全部代表性成果 →</el-button>
        </div>
      </div>
    </section>

    <!-- 科研工具 & Agent快捷入口 -->
    <section class="section">
      <div class="container">
        <el-row :gutter="32">
          <el-col :xs="24" :md="12">
            <div class="section-header">
              <h2>科研工具</h2>
            </div>
            <div class="link-list" v-if="tools.length > 0">
              <div v-for="item in tools" :key="item.id" class="link-item" @click="$router.push('/tools')">
                <div class="link-info">
                  <h4>{{ item.name }}</h4>
                  <p>{{ item.summary }}</p>
                </div>
                <el-tag :type="item.status === '可用' ? 'success' : 'warning'" size="small">{{ item.status }}</el-tag>
              </div>
            </div>
            <el-empty v-else description="暂无工具" :image-size="60" />
          </el-col>
          <el-col :xs="24" :md="12">
            <div class="section-header">
              <h2>智能助手</h2>
            </div>
            <div class="link-list" v-if="agents.length > 0">
              <div v-for="item in agents" :key="item.id" class="link-item" @click="$router.push('/agents')">
                <div class="link-info">
                  <h4>{{ item.name }}</h4>
                  <p>{{ item.summary }}</p>
                </div>
                <el-tag :type="item.status === '可用' ? '' : 'info'" size="small">{{ item.status }}</el-tag>
              </div>
            </div>
            <el-empty v-else description="暂无助手" :image-size="60" />
          </el-col>
        </el-row>
      </div>
    </section>

    <Footer />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import NavBar from '@/components/front/NavBar.vue'
import Footer from '@/components/front/Footer.vue'
import { useLabStore } from '@/stores/lab'
import { getResearchDirections } from '@/api/research'
import { getPublications } from '@/api/publication'
import { getTools } from '@/api/tool'
import { getAgents } from '@/api/agent'

const labStore = useLabStore()
const labInfo = ref(null)
const directions = ref([])
const representativePublications = ref([])
const tools = ref([])
const agents = ref([])

function directionIcon(id) {
  const icons = { 1: 'DataAnalysis', 2: 'Connection', 3: 'Grid', 4: 'Cpu' }
  return icons[id] || 'Histogram'
}

function openTool(url) {
  if (url) window.open(url, '_blank')
}

onMounted(async () => {
  labInfo.value = await labStore.fetchLabInfo()
  try {
    const [dRes, pRes, tRes, aRes] = await Promise.all([
      getResearchDirections(),
      getPublications({ pageSize: 4, isRepresentative: 1 }),
      getTools(),
      getAgents()
    ])
    directions.value = dRes.data.data || []
    representativePublications.value = pRes.data.data?.records || []
    tools.value = tRes.data.data || []
    agents.value = aRes.data.data || []
  } catch (e) { /* 接口未就绪时静默 */ }
})
</script>

<style scoped>
.hero-banner {
  background: linear-gradient(135deg, #1a3a5c 0%, #2a6496 50%, #4a8bc2 100%);
  color: #fff;
  padding: 100px 0 80px;
  text-align: center;
}
.hero-content { max-width: 800px; margin: 0 auto; padding: 0 20px; }
.hero-title { font-size: 36px; font-weight: 700; margin-bottom: 12px; }
.hero-subtitle { font-size: 18px; opacity: 0.85; margin-bottom: 20px; }
.hero-desc { font-size: 15px; opacity: 0.75; line-height: 1.8; margin-bottom: 32px; max-width: 600px; margin-left: auto; margin-right: auto; }
.hero-actions { display: flex; gap: 16px; justify-content: center; }
.btn-outline { border-color: rgba(255,255,255,0.6); color: #fff; }

.section { padding: 64px 0; }
.section-bg { background: #f8fafc; }
.section-header { text-align: center; margin-bottom: 40px; }
.section-header h2 { font-size: 28px; color: #1a3a5c; margin-bottom: 8px; }
.section-subtitle { font-size: 15px; color: #888; }
.section-more { text-align: center; margin-top: 24px; }

.direction-card {
  background: #fff;
  border: 1px solid #eef2f7;
  border-radius: 10px;
  padding: 32px 20px;
  text-align: center;
  transition: all 0.25s;
  margin-bottom: 20px;
}
.direction-card:hover { border-color: #2a6496; box-shadow: 0 6px 24px rgba(42,100,150,0.12); transform: translateY(-4px); }
.direction-icon { color: #2a6496; margin-bottom: 16px; }
.direction-card h3 { font-size: 17px; color: #1a3a5c; margin-bottom: 10px; }
.direction-card p { font-size: 13px; color: #888; line-height: 1.6; }

.pub-item { margin-bottom: 14px; cursor: pointer; }
.pub-item h3 { font-size: 16px; color: #1a3a5c; margin: 8px 0 6px; }
.pub-authors { font-size: 13px; color: #888; margin-bottom: 4px; }
.pub-venue { font-size: 13px; color: #2a6496; }

.link-list { background: #fff; border-radius: 8px; border: 1px solid #eef2f7; }
.link-item { display: flex; align-items: center; justify-content: space-between; padding: 16px 20px; cursor: pointer; border-bottom: 1px solid #f0f2f5; transition: background 0.15s; }
.link-item:last-child { border-bottom: none; }
.link-item:hover { background: #f8fafc; }
.link-info h4 { font-size: 15px; color: #1a3a5c; margin-bottom: 4px; }
.link-info p { font-size: 13px; color: #999; display: -webkit-box; -webkit-line-clamp: 1; -webkit-box-orient: vertical; overflow: hidden; }

@media (max-width: 768px) {
  .hero-title { font-size: 26px; }
  .hero-banner { padding: 60px 0 50px; }
}
</style>
