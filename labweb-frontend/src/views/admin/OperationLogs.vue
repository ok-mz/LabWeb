<template>
  <div class="admin-page">
    <div class="admin-card">
      <div class="card-header">
        <h3>操作日志</h3>
      </div>

      <el-table :data="list" v-loading="loading" stripe>
        <el-table-column prop="username" label="用户" width="100" />
        <el-table-column prop="module" label="模块" width="100" />
        <el-table-column prop="action" label="操作" width="90" />
        <el-table-column prop="method" label="方法" width="80" />
        <el-table-column prop="path" label="请求路径" min-width="200" show-overflow-tooltip />
        <el-table-column prop="ip" label="IP" width="130" />
        <el-table-column label="状态" width="80" align="center">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'danger'" size="small">
              {{ row.status === 1 ? '成功' : '失败' }}
            </el-tag>
          </template>
        </el-table-column>
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
import { getOperationLogs } from '@/api/operationLog'

const list = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = 10
const loading = ref(false)

async function fetchData() {
  loading.value = true
  try {
    const res = await getOperationLogs({ page: currentPage.value, pageSize })
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
