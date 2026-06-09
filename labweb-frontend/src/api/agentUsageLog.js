import request from './index'

export function getAgentUsageLogs(params) {
  return request.get('/admin/agent-usage-logs', { params })
}
