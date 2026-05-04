<template>
  <div class="admin-page">
    <div class="admin-card">
      <div class="card-header">
        <h3>科研工具管理</h3>
        <el-button type="primary" :icon="Plus" @click="openDialog()">新增工具</el-button>
      </div>

      <el-table :data="list" v-loading="loading" stripe>
        <el-table-column prop="name" label="工具名称" min-width="140" />
        <el-table-column prop="summary" label="简介" min-width="200" show-overflow-tooltip />
        <el-table-column prop="status" label="状态" width="90">
          <template #default="{ row }">
            <el-tag :type="row.status === '可用' ? 'success' : 'warning'" size="small">
              {{ row.status }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="accessUrl" label="访问地址" min-width="200" show-overflow-tooltip />
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button link type="primary" :icon="Edit" @click="openDialog(row)">编辑</el-button>
            <el-popconfirm title="确定删除该工具吗？" @confirm="handleDelete(row.id)">
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
      :title="isEdit ? '编辑工具' : '新增工具'"
      width="550px"
      :close-on-click-modal="false"
    >
      <el-form ref="formRef" :model="form" :rules="rules" label-width="90px">
        <el-form-item label="工具名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入工具名称" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="form.status" placeholder="请选择状态" style="width:100%">
            <el-option label="可用" value="可用" />
            <el-option label="维护中" value="维护中" />
          </el-select>
        </el-form-item>
        <el-form-item label="简介" prop="summary">
          <el-input v-model="form.summary" type="textarea" :rows="2" placeholder="请输入工具简介" />
        </el-form-item>
        <el-form-item label="访问地址">
          <el-input v-model="form.accessUrl" placeholder="请输入访问链接" />
        </el-form-item>
        <el-form-item label="文档地址">
          <el-input v-model="form.docUrl" placeholder="请输入文档链接" />
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
import { getTools, createTool, updateTool, deleteTool } from '@/api/tool'
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
  accessUrl: '',
  docUrl: '',
  icon: '',
  status: '可用'
})

const rules = {
  name: [{ required: true, message: '请输入工具名称', trigger: 'blur' }]
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
    form.accessUrl = ''
    form.docUrl = ''
    form.icon = ''
    form.status = '可用'
  }
  dialogVisible.value = true
}

async function handleSave() {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return
  saving.value = true
  try {
    if (isEdit.value) {
      await updateTool(editId.value, form)
      ElMessage.success('更新成功')
    } else {
      await createTool(form)
      ElMessage.success('新增成功')
    }
    dialogVisible.value = false
    fetchData()
  } finally {
    saving.value = false
  }
}

async function handleDelete(id) {
  await deleteTool(id)
  ElMessage.success('删除成功')
  fetchData()
}

async function fetchData() {
  loading.value = true
  try {
    const res = await getTools()
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
