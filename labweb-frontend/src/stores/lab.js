import { defineStore } from 'pinia'
import { ref } from 'vue'
import { getLabInfo } from '@/api/labInfo'

export const useLabStore = defineStore('lab', () => {
  const labInfo = ref(null)
  const loading = ref(false)

  async function fetchLabInfo() {
    if (labInfo.value) return labInfo.value
    loading.value = true
    try {
      const res = await getLabInfo()
      labInfo.value = res.data.data
      return labInfo.value
    } finally {
      loading.value = false
    }
  }

  return { labInfo, loading, fetchLabInfo }
})
