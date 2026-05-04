import request from './index'

export function uploadFile(file) {
  const formData = new FormData()
  formData.append('file', file)
  return request.post('/admin/files/upload', formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}
