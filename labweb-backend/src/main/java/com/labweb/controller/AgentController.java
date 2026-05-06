package com.labweb.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.labweb.common.Result;
import com.labweb.entity.Agent;
import com.labweb.service.AgentService;
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
    public Result<Agent> detail(@PathVariable Long id) {
        Agent agent = agentService.getById(id);
        if (agent == null) {
            return Result.error("助手不存在");
        }
        return Result.success(agent);
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
