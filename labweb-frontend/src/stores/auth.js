import { defineStore } from 'pinia'
import { ref } from 'vue'
import { login as loginApi } from '@/api/auth'

export const useAuthStore = defineStore('auth', () => {
  const token = ref(localStorage.getItem('token') || '')
  const username = ref(localStorage.getItem('username') || '')

  const isLoggedIn = () => !!token.value

  async function login(usernameVal, password) {
    const res = await loginApi(usernameVal, password)
    token.value = res.data.data.token
    username.value = res.data.data.username
    localStorage.setItem('token', token.value)
    localStorage.setItem('username', username.value)
    return res.data
  }

  function logout() {
    token.value = ''
    username.value = ''
    localStorage.removeItem('token')
    localStorage.removeItem('username')
  }

  return { token, username, isLoggedIn, login, logout }
})
