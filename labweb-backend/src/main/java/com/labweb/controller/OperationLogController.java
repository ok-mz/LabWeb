package com.labweb.controller;

import com.labweb.common.Result;
import com.labweb.entity.OperationLog;
import com.labweb.service.OperationLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/api/v1/admin")
public class OperationLogController {

    @Autowired
    private OperationLogService operationLogService;

    @GetMapping("/operation-logs")
    public Result<Map<String, Object>> list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        List<OperationLog> records = operationLogService.listByPage(page, pageSize);
        Long total = operationLogService.countTotal();
        Map<String, Object> data = new HashMap<>();
        data.put("records", records);
        data.put("total", total);
        data.put("current", page);
        long pages = total / pageSize + (total % pageSize > 0 ? 1 : 0);
        data.put("pages", pages);
        return Result.success(data);
    }
}
