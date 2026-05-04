package com.labweb.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.labweb.entity.Agent;
import com.labweb.mapper.AgentMapper;
import com.labweb.service.AgentService;
import org.springframework.stereotype.Service;

@Service
public class AgentServiceImpl extends ServiceImpl<AgentMapper, Agent> implements AgentService {
}
