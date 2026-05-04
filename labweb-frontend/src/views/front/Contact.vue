<template>
  <div class="contact-page">
    <NavBar />

    <section class="page-banner">
      <h1>联系我们</h1>
      <p>欢迎学术交流与合作，期待与您携手共进</p>
    </section>

    <div class="page-content">
      <el-row :gutter="40">
        <el-col :xs="24" :md="12">
          <div class="contact-card card-item">
            <h3>实验室信息</h3>
            <el-divider />
            <div class="info-list" v-if="info">
              <div class="info-item">
                <el-icon :size="20"><School /></el-icon>
                <div>
                  <span class="info-label">实验室名称</span>
                  <span class="info-value">{{ info.labName || '暂无' }}</span>
                </div>
              </div>
              <div class="info-item">
                <el-icon :size="20"><OfficeBuilding /></el-icon>
                <div>
                  <span class="info-label">所属单位</span>
                  <span class="info-value">{{ info.school || '暂无' }} · {{ info.college || '暂无' }}</span>
                </div>
              </div>
              <div class="info-item">
                <el-icon :size="20"><User /></el-icon>
                <div>
                  <span class="info-label">负责人</span>
                  <span class="info-value">{{ info.leader || '暂无' }}</span>
                </div>
              </div>
              <div class="info-item">
                <el-icon :size="20"><Location /></el-icon>
                <div>
                  <span class="info-label">办公地点</span>
                  <span class="info-value">{{ info.location || '暂无' }}</span>
                </div>
              </div>
              <div class="info-item">
                <el-icon :size="20"><Message /></el-icon>
                <div>
                  <span class="info-label">电子邮箱</span>
                  <span class="info-value">{{ info.email || '暂无' }}</span>
                </div>
              </div>
            </div>
            <el-skeleton v-else :rows="5" animated />
          </div>
        </el-col>

        <el-col :xs="24" :md="12">
          <div class="contact-card card-item">
            <h3>合作说明</h3>
            <el-divider />
            <div class="cooperation-text">
              <p>本实验室长期欢迎以下形式的合作：</p>
              <ul>
                <li>联合科研项目申请与合作研究</li>
                <li>计算工具与方法的共同开发</li>
                <li>基因组学数据的联合分析与挖掘</li>
                <li>研究生联合培养与学术互访</li>
                <li>企业技术咨询与成果转化合作</li>
              </ul>
              <p class="cooperation-note">
                如有合作意向，请通过邮件与我们联系，我们将在收到邮件后尽快回复。
              </p>
            </div>
          </div>
        </el-col>
      </el-row>
    </div>

    <Footer />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import NavBar from '@/components/front/NavBar.vue'
import Footer from '@/components/front/Footer.vue'
import { useLabStore } from '@/stores/lab'

const labStore = useLabStore()
const info = ref(null)

onMounted(async () => {
  try {
    info.value = await labStore.fetchLabInfo()
  } catch (e) {
    // 接口未就绪时静默处理
  }
})
</script>

<style scoped>
.contact-card {
  margin-bottom: 24px;
  padding: 32px;
}
.contact-card h3 {
  font-size: 20px;
  color: #1a3a5c;
  margin-bottom: 0;
}
.info-item {
  display: flex;
  align-items: flex-start;
  gap: 14px;
  padding: 14px 0;
  border-bottom: 1px solid #f0f2f5;
  color: #2a6496;
}
.info-item:last-child {
  border-bottom: none;
}
.info-label {
  display: block;
  font-size: 13px;
  color: #999;
  margin-bottom: 2px;
}
.info-value {
  display: block;
  font-size: 15px;
  color: #333;
}
.cooperation-text {
  font-size: 14px;
  color: #555;
  line-height: 2;
}
.cooperation-text ul {
  margin: 12px 0;
  padding-left: 20px;
}
.cooperation-text ul li {
  margin-bottom: 6px;
}
.cooperation-note {
  margin-top: 16px;
  padding: 16px;
  background: #f8fafc;
  border-radius: 6px;
  color: #666;
  font-size: 13px;
}
</style>
