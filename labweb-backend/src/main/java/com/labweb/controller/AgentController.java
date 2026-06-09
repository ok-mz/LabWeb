package com.labweb.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.labweb.common.Result;
import com.labweb.entity.Agent;
import com.labweb.entity.AgentUsageLog;
import com.labweb.service.AgentService;
import com.labweb.service.AgentUsageLogService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/v1")
public class AgentController {

    @Autowired
    private AgentService agentService;

    @Autowired
    private AgentUsageLogService agentUsageLogService;

    @GetMapping("/agents")
    public Result<Map<String, Object>> list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String keyword) {

        LambdaQueryWrapper<Agent> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(keyword)) {
            wrapper.like(Agent::getName, keyword);
        }
        wrapper.orderByAsc(Agent::getSortOrder);

        Page<Agent> result = agentService.page(new Page<>(page, pageSize), wrapper);
        Map<String, Object> data = new HashMap<>();
        data.put("records", result.getRecords());
        data.put("total", result.getTotal());
        data.put("current", result.getCurrent());
        data.put("pages", result.getPages());
        return Result.success(data);
    }

    @GetMapping("/agents/{id}")
    public Result<Agent> detail(@PathVariable Long id, HttpServletRequest request) {
        Agent agent = agentService.getById(id);
        if (agent == null) {
            return Result.error("助手不存在");
        }
        // Record agent usage
        try {
            AgentUsageLog log = new AgentUsageLog();
            log.setAgentId(agent.getId());
            log.setAgentName(agent.getName());
            Long userId = (Long) request.getAttribute("userId");
            String username = (String) request.getAttribute("username");
            log.setUserId(userId);
            log.setUsername(username != null ? username : "anonymous");
            log.setAccessType(agent.getIntegrationType());
            log.setIp(getClientIp(request));
            log.setUserAgent(request.getHeader("User-Agent"));
            agentUsageLogService.recordUsage(log);
        } catch (Exception ignored) {
        }
        return Result.success(agent);
    }

    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip != null && !ip.isEmpty() && !"unknown".equalsIgnoreCase(ip)) {
            return ip.split(",")[0].trim();
        }
        ip = request.getHeader("X-Real-IP");
        if (ip != null && !ip.isEmpty() && !"unknown".equalsIgnoreCase(ip)) {
            return ip;
        }
        return request.getRemoteAddr();
    }

    @PostMapping("/admin/agents")
    public Result<Void> create(@RequestBody Agent agent) {
        agentService.save(agent);
        return Result.success("新增成功", null);
    }

    @PutMapping("/admin/agents/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody Agent agent) {
        agent.setId(id);
        agentService.updateById(agent);
        return Result.success("更新成功", null);
    }

    @DeleteMapping("/admin/agents/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        agentService.removeById(id);
        return Result.success("删除成功", null);
    }
}
