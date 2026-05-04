import request from './index'

export function getTools() {
  return request.get('/tools')
}

export function getToolDetail(id) {
  return request.get(`/tools/${id}`)
}

export function createTool(data) {
  return request.post('/admin/tools', data)
}

export function updateTool(id, data) {
  return request.put(`/admin/tools/${id}`, data)
}

export function deleteTool(id) {
  return request.delete(`/admin/tools/${id}`)
}
