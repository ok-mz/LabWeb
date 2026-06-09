<template>
  <div class="admin-page">
    <div class="admin-card">
      <div class="card-header">
        <h3>Agent 使用日志</h3>
      </div>

      <el-table :data="list" v-loading="loading" stripe>
        <el-table-column prop="agentName" label="Agent" min-width="120" />
        <el-table-column prop="username" label="用户" width="100" />
        <el-table-column prop="accessType" label="访问方式" width="100">
          <template #default="{ row }">
            <el-tag size="small">{{ accessTypeLabel(row.accessType) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="ip" label="IP" width="130" />
        <el-table-column prop="statusCode" label="状态码" width="90" align="center" />
        <el-table-column prop="duration" label="耗时(ms)" width="90" align="center" />
        <el-table-column prop="createdAt" label="时间" width="170" />
      </el-table>

      <div class="pagination-row" v-if="total > pageSize">
        <el-pagination
          v-model:current-page="currentPage"
          :page-size="pageSize"
          :total="total"
          layout="prev, pager, next, total"
          @current-change="fetchData"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getAgentUsageLogs } from '@/api/agentUsageLog'

const list = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = 10
const loading = ref(false)

function accessTypeLabel(type) {
  const map = { link: '外部链接', iframe: '内嵌页面', api: 'API接口' }
  return map[type] || type || '-'
}

async function fetchData() {
  loading.value = true
  try {
    const res = await getAgentUsageLogs({ page: currentPage.value, pageSize })
    const data = res.data.data
    list.value = data.records || []
    total.value = data.total || 0
  } finally {
    loading.value = false
  }
}

onMounted(() => { fetchData() })
</script>

<style scoped>
.admin-page { max-width: 1200px; }
.admin-card { background: #fff; border-radius: 8px; padding: 24px 28px; }
.card-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 18px; }
.card-header h3 { font-size: 18px; color: #1a3a5c; }
.pagination-row { display: flex; justify-content: center; margin-top: 20px; }
</style>
