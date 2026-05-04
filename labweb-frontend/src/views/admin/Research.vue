<template>
  <div class="admin-page">
    <div class="admin-card">
      <div class="card-header">
        <h3>研究方向管理</h3>
        <el-button type="primary" :icon="Plus" @click="openDialog()">新增方向</el-button>
      </div>

      <el-table :data="list" v-loading="loading" stripe>
        <el-table-column prop="sortOrder" label="排序" width="70" align="center" />
        <el-table-column prop="title" label="方向名称" min-width="140" />
        <el-table-column prop="summary" label="简要描述" min-width="220" show-overflow-tooltip />
        <el-table-column prop="keywords" label="关键词" min-width="160">
          <template #default="{ row }">
            <el-tag v-for="kw in splitKeywords(row.keywords)" :key="kw" size="small" class="kw-tag">{{ kw }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button link type="primary" :icon="Edit" @click="openDialog(row)">编辑</el-button>
            <el-popconfirm title="确定删除该研究方向吗？" @confirm="handleDelete(row.id)">
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
      :title="isEdit ? '编辑研究方向' : '新增研究方向'"
      width="650px"
      :close-on-click-modal="false"
    >
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="方向名称" prop="title">
          <el-input v-model="form.title" placeholder="请输入方向名称" />
        </el-form-item>
        <el-form-item label="排序序号" prop="sortOrder">
          <el-input-number v-model="form.sortOrder" :min="0" :max="99" />
        </el-form-item>
        <el-form-item label="简要描述" prop="summary">
          <el-input v-model="form.summary" type="textarea" :rows="2" placeholder="请输入简要描述" />
        </el-form-item>
        <el-form-item label="详细描述" prop="description">
          <el-input v-model="form.description" type="textarea" :rows="6" placeholder="请输入详细描述" />
        </el-form-item>
        <el-form-item label="关键词" prop="keywords">
          <el-input v-model="form.keywords" placeholder="多个关键词用逗号分隔" />
        </el-form-item>
        <el-form-item label="配图">
          <el-upload
            :show-file-list="false"
            :before-upload="beforeImageUpload"
            :http-request="handleUpload"
            accept="image/*"
          >
            <el-button :icon="Upload" :loading="uploading">上传图片</el-button>
          </el-upload>
          <el-image v-if="form.imageUrl" :src="form.imageUrl" fit="cover" style="width:200px;height:120px;border-radius:6px;margin-top:10px" />
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
import { getResearchDirections, createResearch, updateResearch, deleteResearch } from '@/api/research'
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
  title: '',
  summary: '',
  description: '',
  keywords: '',
  imageUrl: '',
  sortOrder: 0
})

const rules = {
  title: [{ required: true, message: '请输入方向名称', trigger: 'blur' }],
  summary: [{ required: true, message: '请输入简要描述', trigger: 'blur' }]
}

function splitKeywords(kw) {
  if (!kw) return []
  return kw.split(',').map(k => k.trim()).filter(Boolean)
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
    form.imageUrl = res.data.data.url
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
    form.title = ''
    form.summary = ''
    form.description = ''
    form.keywords = ''
    form.imageUrl = ''
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
      await updateResearch(editId.value, form)
      ElMessage.success('更新成功')
    } else {
      await createResearch(form)
      ElMessage.success('新增成功')
    }
    dialogVisible.value = false
    fetchData()
  } finally {
    saving.value = false
  }
}

async function handleDelete(id) {
  await deleteResearch(id)
  ElMessage.success('删除成功')
  fetchData()
}

async function fetchData() {
  loading.value = true
  try {
    const res = await getResearchDirections()
    list.value = res.data.data || []
  } finally {
    loading.value = false
  }
}

onMounted(() => { fetchData() })
</script>

<style scoped>
.admin-page { max-width: 1100px; }
.admin-card { background: #fff; border-radius: 8px; padding: 24px 28px; }
.card-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 18px; }
.card-header h3 { font-size: 18px; color: #1a3a5c; }
.kw-tag { margin-right: 4px; background: #e8f4fd; color: #2a6496; border: none; }
</style>
