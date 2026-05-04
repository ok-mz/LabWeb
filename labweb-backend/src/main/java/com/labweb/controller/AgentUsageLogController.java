package com.labweb.controller;

import com.labweb.common.Result;
import com.labweb.entity.AgentUsageLog;
import com.labweb.service.AgentUsageLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/admin")
public class AgentUsageLogController {

    @Autowired
    private AgentUsageLogService agentUsageLogService;

    @GetMapping("/agent-usage-logs")
    public Result<Map<String, Object>> list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) Long agentId) {
        List<AgentUsageLog> records = agentUsageLogService.listByPage(page, pageSize, agentId);
        Long total = agentUsageLogService.countTotal(agentId);
        Map<String, Object> data = new HashMap<>();
        data.put("records", records);
        data.put("total", total);
        data.put("current", page);
        long pages = total / pageSize + (total % pageSize > 0 ? 1 : 0);
        data.put("pages", pages);
        return Result.success(data);
    }
}
