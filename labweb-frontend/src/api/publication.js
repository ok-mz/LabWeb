import request from './index'

export function getPublications(params) {
  return request.get('/publications', { params })
}

export function getPublicationDetail(id) {
  return request.get(`/publications/${id}`)
}

export function createPublication(data) {
  return request.post('/admin/publications', data)
}

export function updatePublication(id, data) {
  return request.put(`/admin/publications/${id}`, data)
}

export function deletePublication(id) {
  return request.delete(`/admin/publications/${id}`)
}
