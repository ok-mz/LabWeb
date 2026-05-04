import request from './index'

export function getResearchDirections() {
  return request.get('/research-directions')
}

export function getResearchDetail(id) {
  return request.get(`/research-directions/${id}`)
}

export function createResearch(data) {
  return request.post('/admin/research-directions', data)
}

export function updateResearch(id, data) {
  return request.put(`/admin/research-directions/${id}`, data)
}

export function deleteResearch(id) {
  return request.delete(`/admin/research-directions/${id}`)
}
