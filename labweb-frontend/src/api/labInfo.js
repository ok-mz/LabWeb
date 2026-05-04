import request from './index'

export function getLabInfo() {
  return request.get('/lab-info')
}

export function updateLabInfo(data) {
  return request.put('/admin/lab-info', data)
}
