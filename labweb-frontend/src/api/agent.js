import request from './index'

export function getAgents() {
  return request.get('/agents')
}

export function getAgentDetail(id) {
  return request.get(`/agents/${id}`)
}

export function createAgent(data) {
  return request.post('/admin/agents', data)
}

export function updateAgent(id, data) {
  return request.put(`/admin/agents/${id}`, data)
}

export function deleteAgent(id) {
  return request.delete(`/admin/agents/${id}`)
}
