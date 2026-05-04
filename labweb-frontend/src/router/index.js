import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/front/Home.vue')
  },
  {
    path: '/about',
    name: 'About',
    component: () => import('@/views/front/About.vue')
  },
  {
    path: '/research',
    name: 'Research',
    component: () => import('@/views/front/Research.vue')
  },
  {
    path: '/research/:id',
    name: 'ResearchDetail',
    component: () => import('@/views/front/ResearchDetail.vue')
  },
  {
    path: '/publications',
    name: 'Publications',
    component: () => import('@/views/front/Publications.vue')
  },
  {
    path: '/tools',
    name: 'Tools',
    component: () => import('@/views/front/Tools.vue')
  },
  {
    path: '/agents',
    name: 'Agents',
    component: () => import('@/views/front/Agents.vue')
  },
  {
    path: '/contact',
    name: 'Contact',
    component: () => import('@/views/front/Contact.vue')
  },
  {
    path: '/admin/login',
    name: 'AdminLogin',
    component: () => import('@/views/admin/Login.vue')
  },
  {
    path: '/admin',
    component: () => import('@/views/admin/Layout.vue'),
    redirect: '/admin/lab-info',
    meta: { requiresAuth: true },
    children: [
      {
        path: 'lab-info',
        name: 'AdminLabInfo',
        component: () => import('@/views/admin/LabInfo.vue')
      },
      {
        path: 'research',
        name: 'AdminResearch',
        component: () => import('@/views/admin/Research.vue')
      },
      {
        path: 'publications',
        name: 'AdminPublications',
        component: () => import('@/views/admin/Publications.vue')
      },
      {
        path: 'tools',
        name: 'AdminTools',
        component: () => import('@/views/admin/Tools.vue')
      },
      {
        path: 'agents',
        name: 'AdminAgents',
        component: () => import('@/views/admin/Agents.vue')
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() {
    return { top: 0 }
  }
})

router.beforeEach((to, from, next) => {
  if (to.meta.requiresAuth) {
    const token = localStorage.getItem('token')
    if (!token) {
      next('/admin/login')
      return
    }
  }
  next()
})

export default router
