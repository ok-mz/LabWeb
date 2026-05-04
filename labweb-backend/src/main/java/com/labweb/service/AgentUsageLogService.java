package com.labweb.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.labweb.entity.AgentUsageLog;

import java.util.List;

public interface AgentUsageLogService extends IService<AgentUsageLog> {
    List<AgentUsageLog> listByPage(Integer page, Integer pageSize, Long agentId);
    Long countTotal(Long agentId);
    void recordUsage(AgentUsageLog log);
}
