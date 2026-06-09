import request from './index'

export function getOperationLogs(params) {
  return request.get('/admin/operation-logs', { params })
}
