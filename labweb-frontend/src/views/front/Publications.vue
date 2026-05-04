<template>
  <div class="publications-page">
    <NavBar />

    <section class="page-banner">
      <h1>发表成果</h1>
      <p>实验室近年发表的高水平论文、专利及科研成果</p>
    </section>

    <div class="page-content">
      <!-- 筛选栏 -->
      <div class="filter-bar">
        <el-input
          v-model="keyword"
          placeholder="搜索标题、作者或摘要..."
          clearable
          :prefix-icon="Search"
          style="width: 300px"
          @clear="search"
          @keyup.enter="search"
        />
        <el-select v-model="filterType" placeholder="成果类型" clearable style="width: 140px" @change="search">
          <el-option label="论文" value="论文" />
          <el-option label="专利" value="专利" />
          <el-option label="软著" value="软著" />
          <el-option label="获奖" value="获奖" />
        </el-select>
        <el-select v-model="filterYear" placeholder="发表年份" clearable style="width: 140px" @change="search">
          <el-option v-for="y in yearRange" :key="y" :label="String(y)" :value="y" />
        </el-select>
        <el-button type="primary" @click="search">搜索</el-button>
      </div>

      <!-- 加载状态 -->
      <el-skeleton v-if="loading" :rows="6" animated />

      <!-- 成果列表 -->
      <template v-else-if="records.length > 0">
        <div v-for="item in records" :key="item.id" class="pub-item card-item">
          <div class="pub-header">
            <div class="pub-left">
              <span class="tag">{{ item.type }}</span>
              <span class="pub-year">{{ item.year }}</span>
            </div>
            <el-tag v-if="item.isRepresentative" type="danger" size="small" effect="dark">代表作</el-tag>
          </div>
          <h3 class="pub-title">{{ item.title }}</h3>
          <p class="pub-authors" v-if="item.authors">{{ item.authors }}</p>
          <p class="pub-venue" v-if="item.venue">{{ item.venue }}</p>
          <p class="pub-abstract" v-if="item.abstractText">{{ item.abstractText }}</p>
          <div class="pub-actions" v-if="item.doi">
            <el-link :href="item.doi" target="_blank" type="primary" :underline="false">
              <el-icon><Link /></el-icon> 查看原文
            </el-link>
          </div>
        </div>

        <!-- 分页 -->
        <div class="pagination-row">
          <el-pagination
            v-model:current-page="currentPage"
            :page-size="pageSize"
            :total="total"
            layout="prev, pager, next, total"
            @current-change="fetchData"
          />
        </div>
      </template>

      <el-empty v-else description="暂无发表成果" />
    </div>

    <Footer />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { Search, Link } from '@element-plus/icons-vue'
import NavBar from '@/components/front/NavBar.vue'
import Footer from '@/components/front/Footer.vue'
import { getPublications } from '@/api/publication'

const records = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const loading = ref(true)
const keyword = ref('')
const filterType = ref('')
const filterYear = ref('')

const currentYear = new Date().getFullYear()
const yearRange = computed(() => {
  const years = []
  for (let y = currentYear; y >= currentYear - 20; y--) {
    years.push(y)
  }
  return years
})

function search() {
  currentPage.value = 1
  fetchData()
}

async function fetchData() {
  loading.value = true
  try {
    const params = {
      page: currentPage.value,
      pageSize: pageSize.value
    }
    if (keyword.value) params.keyword = keyword.value
    if (filterType.value) params.type = filterType.value
    if (filterYear.value) params.year = filterYear.value
    const res = await getPublications(params)
    const data = res.data.data
    records.value = data.records || []
    total.value = data.total || 0
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchData()
})
</script>

<style scoped>
.filter-bar {
  display: flex;
  gap: 12px;
  margin-bottom: 24px;
  flex-wrap: wrap;
}
.pub-item {
  margin-bottom: 16px;
  padding: 24px 28px;
}
.pub-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 10px;
}
.pub-left {
  display: flex;
  align-items: center;
  gap: 10px;
}
.pub-year {
  font-size: 13px;
  color: #999;
}
.pub-title {
  font-size: 17px;
  color: #1a3a5c;
  margin-bottom: 6px;
  line-height: 1.5;
}
.pub-authors {
  font-size: 13px;
  color: #777;
  margin-bottom: 4px;
}
.pub-venue {
  font-size: 13px;
  color: #2a6496;
  font-style: italic;
  margin-bottom: 10px;
}
.pub-abstract {
  font-size: 13px;
  color: #888;
  line-height: 1.7;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
  margin-bottom: 10px;
}
.pub-actions {
  display: flex;
  gap: 16px;
}
.pagination-row {
  display: flex;
  justify-content: center;
  margin-top: 32px;
}
</style>
