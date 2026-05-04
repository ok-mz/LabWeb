<template>
  <footer class="footer">
    <div class="footer-inner">
      <div class="footer-section">
        <h4>生物信息学与基因组学实验室</h4>
        <p>XX大学生命科学学院</p>
        <p>生命科学楼A座501室</p>
      </div>
      <div class="footer-section">
        <h4>研究方向</h4>
        <p>结构变异 · 三维基因组</p>
        <p>泛基因组 · AI制药</p>
      </div>
      <div class="footer-section">
        <h4>联系方式</h4>
        <p>邮箱：lab@xxu.edu.cn</p>
        <p>电话：010-XXXX-XXXX</p>
      </div>
    </div>
    <div class="footer-copyright">
      <p>Copyright &copy; {{ currentYear }} 生物信息学与基因组学实验室. All Rights Reserved.</p>
    </div>
  </footer>
</template>

<script setup>
const currentYear = new Date().getFullYear()
</script>

<style scoped>
.footer {
  background: #1a3a5c;
  color: #ccc;
  padding: 0;
  margin-top: 60px;
}
.footer-inner {
  max-width: 1200px;
  margin: 0 auto;
  padding: 48px 20px 32px;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 40px;
}
.footer-section h4 {
  color: #fff;
  font-size: 16px;
  margin-bottom: 16px;
  font-weight: 600;
}
.footer-section p {
  font-size: 14px;
  line-height: 2;
  color: #aaa;
}
.footer-copyright {
  text-align: center;
  padding: 20px;
  border-top: 1px solid rgba(255, 255, 255, 0.08);
  font-size: 13px;
  color: #777;
}
@media (max-width: 768px) {
  .footer-inner {
    grid-template-columns: 1fr;
    gap: 24px;
  }
}
</style>
