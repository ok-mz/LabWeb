<template>
  <div class="admin-page">
    <div class="admin-card">
      <div class="card-header">
        <h3>智能助手管理</h3>
        <el-button type="primary" :icon="Plus" @click="openDialog()">新增助手</el-button>
      </div>

      <el-table :data="list" v-loading="loading" stripe>
        <el-table-column prop="sortOrder" label="排序" width="70" align="center" />
        <el-table-column prop="name" label="名称" min-width="120" />
        <el-table-column prop="summary" label="简介" min-width="180" show-overflow-tooltip />
        <el-table-column prop="integrationType" label="接入方式" width="100">
          <template #default="{ row }">
            <el-tag size="small">{{ row.integrationType || '未设置' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="90">
          <template #default="{ row }">
            <el-tag :type="statusType(row.status)" size="small">{{ row.status || '未接入' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button link type="primary" :icon="Edit" @click="openDialog(row)">编辑</el-button>
            <el-popconfirm title="确定删除该助手吗？" @confirm="handleDelete(row.id)">
              <template #reference>
                <el-button link type="danger" :icon="Delete">删除</el-button>
              </template>
            </el-popconfirm>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 新增/编辑弹窗 -->
    <el-dialog
      v-model="dialogVisible"
      :title="isEdit ? '编辑助手' : '新增助手'"
      width="600px"
      :close-on-click-modal="false"
    >
      <el-form ref="formRef" :model="form" :rules="rules" label-width="90px">
        <el-row :gutter="16">
          <el-col :span="14">
            <el-form-item label="助手名称" prop="name">
              <el-input v-model="form.name" placeholder="请输入助手名称" />
            </el-form-item>
          </el-col>
          <el-col :span="10">
            <el-form-item label="排序" prop="sortOrder">
              <el-input-number v-model="form.sortOrder" :min="0" :max="99" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="接入方式" prop="integrationType">
              <el-select v-model="form.integrationType" placeholder="请选择" style="width:100%">
                <el-option label="外部链接" value="link" />
                <el-option label="内嵌页面" value="iframe" />
                <el-option label="API接口" value="api" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态" prop="status">
              <el-select v-model="form.status" placeholder="请选择" style="width:100%">
                <el-option label="未接入" value="未接入" />
                <el-option label="可用" value="可用" />
                <el-option label="维护中" value="维护中" />
                <el-option label="停用" value="停用" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="简介" prop="summary">
          <el-input v-model="form.summary" type="textarea" :rows="2" placeholder="请输入简介描述" />
        </el-form-item>

        <el-form-item label="访问地址">
          <el-input v-model="form.accessUrl" placeholder="请输入访问链接地址" />
        </el-form-item>

        <el-form-item label="图标">
          <el-upload
            :show-file-list="false"
            :before-upload="beforeImageUpload"
            :http-request="handleUpload"
            accept="image/*"
          >
            <el-button :icon="Upload" :loading="uploading">上传图标</el-button>
          </el-upload>
          <el-image v-if="form.icon" :src="form.icon" fit="contain" style="width:64px;height:64px;margin-top:10px;border-radius:6px" />
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
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Plus, Edit, Delete, Upload } from '@element-plus/icons-vue'
import { getAgents, createAgent, updateAgent, deleteAgent } from '@/api/agent'
import { uploadFile } from '@/api/file'

const list = ref([])
const loading = ref(false)
const dialogVisible = ref(false)
const isEdit = ref(false)
const saving = ref(false)
const uploading = ref(false)
const editId = ref(null)
const formRef = ref(null)

const form = reactive({
  name: '',
  summary: '',
  integrationType: 'link',
  accessUrl: '',
  icon: '',
  status: '未接入',
  sortOrder: 0
})

const rules = {
  name: [{ required: true, message: '请输入助手名称', trigger: 'blur' }]
}

function statusType(status) {
  const map = { '可用': 'success', '未接入': 'info', '维护中': 'warning', '停用': 'danger' }
  return map[status] || 'info'
}

function beforeImageUpload(file) {
  const isImage = file.type.startsWith('image/')
  if (!isImage) { ElMessage.error('只能上传图片文件'); return false }
  if (file.size / 1024 / 1024 > 10) { ElMessage.error('图片大小不能超过10MB'); return false }
  return true
}

async function handleUpload({ file }) {
  uploading.value = true
  try {
    const res = await uploadFile(file)
    form.icon = res.data.data.url
    ElMessage.success('上传成功')
  } finally {
    uploading.value = false
  }
}

function openDialog(row) {
  if (row) {
    isEdit.value = true
    editId.value = row.id
    Object.assign(form, row)
  } else {
    isEdit.value = false
    editId.value = null
    form.name = ''
    form.summary = ''
    form.integrationType = 'link'
    form.accessUrl = ''
    form.icon = ''
    form.status = '未接入'
    form.sortOrder = 0
  }
  dialogVisible.value = true
}

async function handleSave() {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return
  saving.value = true
  try {
    if (isEdit.value) {
      await updateAgent(editId.value, form)
      ElMessage.success('更新成功')
    } else {
      await createAgent(form)
      ElMessage.success('新增成功')
    }
    dialogVisible.value = false
    fetchData()
  } finally {
    saving.value = false
  }
}

async function handleDelete(id) {
  await deleteAgent(id)
  ElMessage.success('删除成功')
  fetchData()
}

async function fetchData() {
  loading.value = true
  try {
    const res = await getAgents()
    list.value = res.data.data || []
  } finally {
    loading.value = false
  }
}

onMounted(() => { fetchData() })
</script>

<style scoped>
.admin-page { max-width: 1000px; }
.admin-card { background: #fff; border-radius: 8px; padding: 24px 28px; }
.card-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 18px; }
.card-header h3 { font-size: 18px; color: #1a3a5c; }
</style>
