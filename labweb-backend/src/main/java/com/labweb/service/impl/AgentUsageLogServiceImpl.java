package com.labweb.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.labweb.entity.AgentUsageLog;
import com.labweb.mapper.AgentUsageLogMapper;
import com.labweb.service.AgentUsageLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class AgentUsageLogServiceImpl extends ServiceImpl<AgentUsageLogMapper, AgentUsageLog> implements AgentUsageLogService {

    @Autowired
    private AgentUsageLogMapper agentUsageLogMapper;

    @Override
    public List<AgentUsageLog> listByPage(Integer page, Integer pageSize, Long agentId) {
        LambdaQueryWrapper<AgentUsageLog> wrapper = new LambdaQueryWrapper<>();
        if (agentId != null) {
            wrapper.eq(AgentUsageLog::getAgentId, agentId);
        }
        wrapper.orderByDesc(AgentUsageLog::getCreatedAt);
        Page<AgentUsageLog> pageResult = this.page(new Page<>(page, pageSize), wrapper);
        return pageResult.getRecords();
    }

    @Override
    public Long countTotal(Long agentId) {
        LambdaQueryWrapper<AgentUsageLog> wrapper = new LambdaQueryWrapper<>();
        if (agentId != null) {
            wrapper.eq(AgentUsageLog::getAgentId, agentId);
        }
        return this.count(wrapper);
    }

    @Override
    public void recordUsage(AgentUsageLog log) {
        this.save(log);
    }
}
