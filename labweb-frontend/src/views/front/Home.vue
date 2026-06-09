<template>
  <div class="home-page">
    <NavBar />

    <section class="hero-banner">
      <div class="container hero-grid">
        <div class="hero-copy">
          <span class="hero-kicker">计算生物学 · 基因组学 · AI 制药</span>
          <h1>{{ labInfo?.labName || '生物信息学与基因组学实验室' }}</h1>
          <p class="hero-subtitle">{{ labInfo?.school || 'XX大学' }} · {{ labInfo?.college || '生命科学学院' }}</p>
          <p class="hero-desc">
            {{ labInfo?.introduction || '本实验室专注于生物信息学与基因组学前沿研究，围绕结构变异、三维基因组、泛基因组和 AI 制药方向，发展新型计算方法与工具。' }}
          </p>
          <div class="hero-actions">
            <el-button type="primary" size="large" @click="$router.push('/research')">查看研究方向</el-button>
            <el-button size="large" @click="$router.push('/agents')">进入智能助手</el-button>
          </div>
        </div>

        <div class="hero-panel" aria-label="研究平台概览">
          <div class="panel-header">
            <span>核心方向</span>
            <strong>4</strong>
          </div>
          <div class="matrix-list">
            <div class="matrix-item">
              <span>SV</span>
              <p>复杂 SV 识别与疾病关联分析</p>
            </div>
            <div class="matrix-item">
              <span>3D</span>
              <p>染色质高级结构与空间调控网络</p>
            </div>
            <div class="matrix-item">
              <span>PG</span>
              <p>图泛基因组与群体变异表征</p>
            </div>
            <div class="matrix-item">
              <span>AI</span>
              <p>分子生成与药效预测</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section class="section">
      <div class="container">
        <div class="section-header">
          <div>
            <span class="section-kicker">Research Areas</span>
            <h2 class="section-title">研究方向</h2>
          </div>
          <p class="muted-text">以计算方法连接多组学数据、疾病机制与药物研发。</p>
        </div>

        <el-row :gutter="22">
          <el-col v-for="item in directions" :key="item.id" :xs="24" :sm="12" :md="6">
            <div class="direction-card">
              <div class="direction-icon">
                <el-icon :size="30"><component :is="directionIcon(item.id)" /></el-icon>
              </div>
              <h3>{{ item.title }}</h3>
              <p>{{ item.summary }}</p>
            </div>
          </el-col>
        </el-row>

        <div class="section-more">
          <el-button type="primary" plain @click="$router.push('/research')">查看全部研究方向</el-button>
        </div>
      </div>
    </section>

    <section class="section section-soft">
      <div class="container">
        <div class="section-header">
          <div>
            <span class="section-kicker">Selected Work</span>
            <h2 class="section-title">代表性成果</h2>
          </div>
          <p class="muted-text">展示近年来论文、专利、奖项与方法学成果。</p>
        </div>

        <div class="pub-list" v-if="representativePublications.length > 0">
          <article
            v-for="item in representativePublications"
            :key="item.id"
            class="pub-item card-item"
            @click="$router.push('/publications?filter=representative')"
          >
            <span class="tag">{{ item.type || '成果' }}</span>
            <h3>{{ item.title }}</h3>
            <p class="pub-authors">{{ item.authors }}</p>
            <p class="pub-venue">{{ item.venue }} · {{ item.year }}</p>
          </article>
        </div>
        <el-empty v-else description="暂无成果展示" />

        <div class="section-more" v-if="representativePublications.length > 0">
          <el-button type="primary" plain @click="$router.push('/publications?filter=representative')">查看全部代表性成果</el-button>
        </div>
      </div>
    </section>

    <section class="section">
      <div class="container resource-grid">
        <div class="resource-panel">
          <div class="resource-heading">
            <span class="section-kicker">Tools</span>
            <h2>科研工具</h2>
          </div>
          <div class="link-list" v-if="tools.length > 0">
            <div v-for="item in tools" :key="item.id" class="link-item" @click="$router.push('/tools')">
              <div class="link-info">
                <h4>{{ item.name }}</h4>
                <p>{{ item.summary }}</p>
              </div>
              <el-tag :type="item.status === '可用' ? 'success' : 'warning'" effect="plain" size="small">{{ item.status }}</el-tag>
            </div>
          </div>
          <el-empty v-else description="暂无工具" :image-size="64" />
        </div>

        <div class="resource-panel featured">
          <div class="resource-heading">
            <span class="section-kicker">AI Agents</span>
            <h2>智能助手</h2>
          </div>
          <div class="link-list" v-if="agents.length > 0">
            <div v-for="item in agents" :key="item.id" class="link-item" @click="$router.push('/agents')">
              <div class="link-info">
                <h4>{{ item.name }}</h4>
                <p>{{ item.summary }}</p>
              </div>
              <el-tag :type="item.status === '可用' ? 'success' : 'info'" effect="plain" size="small">{{ item.status }}</el-tag>
            </div>
          </div>
          <el-empty v-else description="暂无助手" :image-size="64" />
        </div>
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
    agents.value = aRes.data.data?.records || aRes.data.data || []
  } catch (e) {
    // Public homepage remains readable even if optional lists fail to load.
  }
})
</script>

<style scoped>
.hero-banner {
  position: relative;
  overflow: hidden;
  padding: 88px 0 76px;
  background:
    linear-gradient(135deg, rgba(255, 255, 255, 0.88), rgba(240, 248, 250, 0.72));
}

.hero-grid {
  position: relative;
  display: grid;
  grid-template-columns: minmax(0, 1.1fr) minmax(340px, 0.72fr);
  gap: 52px;
  align-items: center;
}

.hero-kicker {
  display: inline-flex;
  margin-bottom: 18px;
  padding: 7px 12px;
  color: var(--color-primary);
  background: #fff;
  border: 1px solid var(--color-border);
  border-radius: 999px;
  font-size: 13px;
  font-weight: 700;
  box-shadow: var(--shadow-sm);
}

.hero-copy h1 {
  max-width: 820px;
  font-size: 48px;
  line-height: 1.16;
  color: var(--color-ink);
  font-weight: 800;
  margin-bottom: 16px;
}

.hero-subtitle {
  color: var(--color-primary-deep);
  font-size: 18px;
  font-weight: 600;
  margin-bottom: 18px;
}

.hero-desc {
  max-width: 720px;
  color: var(--color-muted);
  font-size: 16px;
  line-height: 1.9;
  margin-bottom: 30px;
}

.hero-actions {
  display: flex;
  gap: 14px;
  flex-wrap: wrap;
}

.hero-panel {
  padding: 22px;
  border: 1px solid rgba(29, 111, 138, 0.22);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.86);
  box-shadow: var(--shadow-md);
}

.panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 18px;
  color: var(--color-muted);
}

.panel-header strong {
  width: 44px;
  height: 44px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  border-radius: 8px;
  background: linear-gradient(135deg, var(--color-primary), var(--color-accent));
}

.matrix-list {
  display: grid;
  gap: 12px;
}

.matrix-item {
  display: grid;
  grid-template-columns: 48px 1fr;
  gap: 12px;
  align-items: center;
  padding: 14px;
  border: 1px solid var(--color-border);
  border-radius: 8px;
  background: var(--color-surface-warm);
}

.matrix-item span {
  height: 38px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  color: var(--color-primary);
  background: var(--color-primary-soft);
  border-radius: 8px;
  font-weight: 800;
}

.matrix-item p {
  color: var(--color-muted);
  font-size: 14px;
  line-height: 1.6;
}

.section {
  padding: 72px 0;
}

.section-soft {
  background: rgba(255, 255, 255, 0.62);
  border-top: 1px solid var(--color-border);
  border-bottom: 1px solid var(--color-border);
}

.section-header {
  display: flex;
  align-items: end;
  justify-content: space-between;
  gap: 28px;
  margin-bottom: 34px;
}

.section-header .muted-text {
  max-width: 430px;
}

.section-more {
  text-align: center;
  margin-top: 28px;
}

.direction-card {
  height: calc(100% - 20px);
  margin-bottom: 20px;
  padding: 28px 22px;
  background: #fff;
  border: 1px solid var(--color-border);
  border-radius: 8px;
  box-shadow: var(--shadow-sm);
  transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
}

.direction-card:hover {
  transform: translateY(-4px);
  border-color: rgba(29, 111, 138, 0.4);
  box-shadow: var(--shadow-md);
}

.direction-icon {
  width: 52px;
  height: 52px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  color: var(--color-primary);
  background: var(--color-primary-soft);
  border-radius: 8px;
  margin-bottom: 18px;
}

.direction-card h3 {
  font-size: 18px;
  color: var(--color-ink);
  margin-bottom: 10px;
}

.direction-card p {
  color: var(--color-muted);
  font-size: 14px;
  line-height: 1.75;
}

.pub-list {
  display: grid;
  gap: 16px;
}

.pub-item {
  cursor: pointer;
}

.pub-item h3 {
  color: var(--color-ink);
  font-size: 18px;
  line-height: 1.5;
  margin: 12px 0 8px;
}

.pub-authors {
  color: var(--color-muted);
  font-size: 14px;
  margin-bottom: 6px;
}

.pub-venue {
  color: var(--color-primary);
  font-size: 14px;
  font-weight: 600;
}

.resource-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 24px;
}

.resource-panel {
  padding: 28px;
  border: 1px solid var(--color-border);
  border-radius: 8px;
  background: #fff;
  box-shadow: var(--shadow-sm);
}

.resource-panel.featured {
  background: linear-gradient(180deg, #ffffff, #f5fbfa);
}

.resource-heading {
  margin-bottom: 20px;
}

.resource-heading h2 {
  color: var(--color-ink);
  font-size: 26px;
}

.link-list {
  display: grid;
  gap: 12px;
}

.link-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  padding: 16px;
  border: 1px solid var(--color-border);
  border-radius: 8px;
  background: var(--color-surface-warm);
  cursor: pointer;
  transition: border-color 0.2s ease, background 0.2s ease;
}

.link-item:hover {
  border-color: rgba(29, 111, 138, 0.36);
  background: #fff;
}

.link-info {
  min-width: 0;
}

.link-info h4 {
  color: var(--color-ink);
  font-size: 15px;
  margin-bottom: 5px;
}

.link-info p {
  color: var(--color-muted);
  font-size: 13px;
  line-height: 1.6;
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

@media (max-width: 900px) {
  .hero-grid,
  .resource-grid {
    grid-template-columns: 1fr;
  }

  .hero-copy h1 {
    font-size: 38px;
  }

  .section-header {
    align-items: flex-start;
    flex-direction: column;
  }
}

@media (max-width: 640px) {
  .hero-banner {
    padding: 56px 0 50px;
  }

  .hero-copy h1 {
    font-size: 31px;
  }

  .section {
    padding: 52px 0;
  }

  .resource-panel {
    padding: 22px;
  }
}
</style>
