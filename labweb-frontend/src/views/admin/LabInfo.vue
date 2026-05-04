<template>
  <div class="admin-lab-info">
    <div class="admin-card">
      <h3>实验室基本信息</h3>
      <el-divider />

      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-width="100px"
        label-position="right"
        v-loading="loading"
      >
        <el-row :gutter="24">
          <el-col :span="12">
            <el-form-item label="实验室名称" prop="labName">
              <el-input v-model="form.labName" placeholder="请输入实验室名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="负责人" prop="leader">
              <el-input v-model="form.leader" placeholder="请输入负责人姓名" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="24">
          <el-col :span="12">
            <el-form-item label="所属学校" prop="school">
              <el-input v-model="form.school" placeholder="请输入学校名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="所属学院" prop="college">
              <el-input v-model="form.college" placeholder="请输入学院名称" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="24">
          <el-col :span="12">
            <el-form-item label="办公地点" prop="location">
              <el-input v-model="form.location" placeholder="请输入办公地点" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="电子邮箱" prop="email">
              <el-input v-model="form.email" placeholder="请输入联系邮箱" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="封面图片">
          <div class="upload-row">
            <el-upload
              :show-file-list="false"
              :before-upload="beforeImageUpload"
              :http-request="handleUpload"
              accept="image/*"
            >
              <el-button type="primary" :icon="Upload" :loading="uploading">上传图片</el-button>
            </el-upload>
            <el-image
              v-if="form.coverImage"
              :src="form.coverImage"
              fit="cover"
              style="width:200px;height:120px;border-radius:6px;margin-left:16px"
            />
          </div>
        </el-form-item>

        <el-form-item label="实验室简介" prop="introduction">
          <el-input
            v-model="form.introduction"
            type="textarea"
            :rows="5"
            placeholder="请输入实验室简介"
          />
        </el-form-item>

        <el-form-item label="研究目标" prop="researchGoal">
          <el-input
            v-model="form.researchGoal"
            type="textarea"
            :rows="5"
            placeholder="请输入研究目标"
          />
        </el-form-item>

        <el-form-item>
          <el-button type="primary" :loading="saving" @click="handleSave">
            <el-icon><Check /></el-icon> 保存信息
          </el-button>
          <el-button @click="fetchData">
            <el-icon><Refresh /></el-icon> 重置
          </el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Check, Refresh, Upload } from '@element-plus/icons-vue'
import { getLabInfo, updateLabInfo } from '@/api/labInfo'
import { uploadFile } from '@/api/file'

const formRef = ref(null)
const loading = ref(false)
const saving = ref(false)
const uploading = ref(false)

const form = reactive({
  id: null,
  labName: '',
  school: '',
  college: '',
  leader: '',
  location: '',
  email: '',
  introduction: '',
  researchGoal: '',
  coverImage: ''
})

const rules = {
  labName: [{ required: true, message: '请输入实验室名称', trigger: 'blur' }],
  school: [{ required: true, message: '请输入所属学校', trigger: 'blur' }],
  college: [{ required: true, message: '请输入所属学院', trigger: 'blur' }],
  leader: [{ required: true, message: '请输入负责人', trigger: 'blur' }]
}

function beforeImageUpload(file) {
  const isImage = file.type.startsWith('image/')
  const isLt10M = file.size / 1024 / 1024 < 10
  if (!isImage) { ElMessage.error('只能上传图片文件'); return false }
  if (!isLt10M) { ElMessage.error('图片大小不能超过10MB'); return false }
  return true
}

async function handleUpload({ file }) {
  uploading.value = true
  try {
    const res = await uploadFile(file)
    form.coverImage = res.data.data.url
    ElMessage.success('上传成功')
  } finally {
    uploading.value = false
  }
}

async function fetchData() {
  loading.value = true
  try {
    const res = await getLabInfo()
    const data = res.data.data
    if (data) Object.assign(form, data)
  } catch (e) { /* 首次可能无数据 */ }
  finally { loading.value = false }
}

async function handleSave() {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return
  saving.value = true
  try {
    await updateLabInfo(form)
    ElMessage.success('保存成功')
  } finally {
    saving.value = false
  }
}

onMounted(() => { fetchData() })
</script>

<style scoped>
.admin-card {
  background: #fff;
  border-radius: 8px;
  padding: 28px 32px;
  max-width: 900px;
}
.admin-card h3 {
  font-size: 18px;
  color: #1a3a5c;
}
.upload-row {
  display: flex;
  align-items: center;
}
</style>
