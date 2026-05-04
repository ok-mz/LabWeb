package com.labweb.controller;

import com.labweb.common.Result;
import com.labweb.entity.Tool;
import com.labweb.service.ToolService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1")
public class ToolController {

    @Autowired
    private ToolService toolService;

    @GetMapping("/tools")
    public Result<List<Tool>> list() {
        return Result.success(toolService.list());
    }

    @GetMapping("/tools/{id}")
    public Result<Tool> detail(@PathVariable Long id) {
        Tool tool = toolService.getById(id);
        if (tool == null) {
            return Result.error("工具不存在");
        }
        return Result.success(tool);
    }

    @PostMapping("/admin/tools")
    public Result<Void> create(@RequestBody Tool tool) {
        toolService.save(tool);
        return Result.success("新增成功", null);
    }

    @PutMapping("/admin/tools/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody Tool tool) {
        tool.setId(id);
        toolService.updateById(tool);
        return Result.success("更新成功", null);
    }

    @DeleteMapping("/admin/tools/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        toolService.removeById(id);
        return Result.success("删除成功", null);
    }
}
