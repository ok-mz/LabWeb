<template>
  <div class="admin-page">
    <div class="admin-card">
      <div class="card-header">
        <h3>发表成果管理</h3>
        <el-button type="primary" :icon="Plus" @click="openDialog()">新增成果</el-button>
      </div>

      <!-- 筛选栏 -->
      <div class="filter-bar">
        <el-input v-model="searchKeyword" placeholder="搜索标题或作者..." clearable style="width:240px" @clear="fetchData" @keyup.enter="fetchData" />
        <el-select v-model="searchType" placeholder="成果类型" clearable style="width:130px" @change="fetchData">
          <el-option label="论文" value="论文" />
          <el-option label="专利" value="专利" />
          <el-option label="软著" value="软著" />
          <el-option label="获奖" value="获奖" />
        </el-select>
        <el-select v-model="searchYear" placeholder="年份" clearable style="width:110px" @change="fetchData">
          <el-option v-for="y in yearRange" :key="y" :label="String(y)" :value="y" />
        </el-select>
        <el-button type="primary" @click="fetchData">搜索</el-button>
      </div>

      <el-table :data="list" v-loading="loading" stripe>
        <el-table-column prop="title" label="标题" min-width="240" show-overflow-tooltip />
        <el-table-column prop="type" label="类型" width="80" />
        <el-table-column prop="authors" label="作者" min-width="150" show-overflow-tooltip />
        <el-table-column prop="venue" label="期刊/会议" min-width="150" show-overflow-tooltip />
        <el-table-column prop="year" label="年份" width="70" />
        <el-table-column label="代表作" width="80" align="center">
          <template #default="{ row }">
            <el-tag v-if="row.isRepresentative" type="danger" size="small" effect="dark">是</el-tag>
            <span v-else style="color:#ccc">否</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="160" fixed="right">
          <template #default="{ row }">
            <el-button link type="primary" :icon="Edit" @click="openDialog(row)">编辑</el-button>
            <el-popconfirm title="确定删除该成果吗？" @confirm="handleDelete(row.id)">
              <template #reference>
                <el-button link type="danger" :icon="Delete">删除</el-button>
              </template>
            </el-popconfirm>
          </template>
        </el-table-column>
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

    <!-- 新增/编辑弹窗 -->
    <el-dialog
      v-model="dialogVisible"
      :title="isEdit ? '编辑成果' : '新增成果'"
      width="650px"
      :close-on-click-modal="false"
    >
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="成果标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入成果标题" />
        </el-form-item>
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="成果类型" prop="type">
              <el-select v-model="form.type" placeholder="请选择" style="width:100%">
                <el-option label="论文" value="论文" />
                <el-option label="专利" value="专利" />
                <el-option label="软著" value="软著" />
                <el-option label="获奖" value="获奖" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="发表年份" prop="year">
              <el-input-number v-model="form.year" :min="1990" :max="2030" style="width:100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="作者列表" prop="authors">
          <el-input v-model="form.authors" placeholder="多个作者用逗号分隔" />
        </el-form-item>
        <el-form-item label="期刊/会议" prop="venue">
          <el-input v-model="form.venue" placeholder="请输入期刊或会议名称" />
        </el-form-item>
        <el-form-item label="DOI链接" prop="doi">
          <el-input v-model="form.doi" placeholder="请输入DOI链接地址" />
        </el-form-item>
        <el-form-item label="摘要" prop="abstractText">
          <el-input v-model="form.abstractText" type="textarea" :rows="4" placeholder="请输入摘要" />
        </el-form-item>
        <el-form-item label="是否代表作">
          <el-switch v-model="form.isRepresentative" :active-value="1" :inactive-value="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSave">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Plus, Edit, Delete } from '@element-plus/icons-vue'
import { getPublications, createPublication, updatePublication, deletePublication } from '@/api/publication'

const list = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = 10
const loading = ref(false)
const dialogVisible = ref(false)
const isEdit = ref(false)
const saving = ref(false)
const editId = ref(null)
const formRef = ref(null)

const searchKeyword = ref('')
const searchType = ref('')
const searchYear = ref('')

const currentYear = new Date().getFullYear()
const yearRange = computed(() => {
  const years = []
  for (let y = currentYear; y >= 1990; y--) years.push(y)
  return years
})

const form = reactive({
  title: '',
  authors: '',
  type: '',
  year: currentYear,
  venue: '',
  doi: '',
  abstractText: '',
  isRepresentative: 0
})

const rules = {
  title: [{ required: true, message: '请输入成果标题', trigger: 'blur' }],
  type: [{ required: true, message: '请选择成果类型', trigger: 'change' }]
}

function openDialog(row) {
  if (row) {
    isEdit.value = true
    editId.value = row.id
    Object.assign(form, row)
  } else {
    isEdit.value = false
    editId.value = null
    form.title = ''
    form.authors = ''
    form.type = ''
    form.year = currentYear
    form.venue = ''
    form.doi = ''
    form.abstractText = ''
    form.isRepresentative = 0
  }
  dialogVisible.value = true
}

async function handleSave() {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return
  saving.value = true
  try {
    if (isEdit.value) {
      await updatePublication(editId.value, form)
      ElMessage.success('更新成功')
    } else {
      await createPublication(form)
      ElMessage.success('新增成功')
    }
    dialogVisible.value = false
    fetchData()
  } finally {
    saving.value = false
  }
}

async function handleDelete(id) {
  await deletePublication(id)
  ElMessage.success('删除成功')
  fetchData()
}

async function fetchData() {
  loading.value = true
  try {
    const params = { page: currentPage.value, pageSize }
    if (searchKeyword.value) params.keyword = searchKeyword.value
    if (searchType.value) params.type = searchType.value
    if (searchYear.value) params.year = searchYear.value
    const res = await getPublications(params)
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
.filter-bar { display: flex; gap: 10px; margin-bottom: 16px; flex-wrap: wrap; }
.pagination-row { display: flex; justify-content: center; margin-top: 20px; }
</style>
