package com.labweb.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.labweb.common.Result;
import com.labweb.entity.ResearchDirection;
import com.labweb.service.ResearchDirectionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1")
public class ResearchDirectionController {

    @Autowired
    private ResearchDirectionService researchDirectionService;

    @GetMapping("/research-directions")
    public Result<List<ResearchDirection>> list() {
        LambdaQueryWrapper<ResearchDirection> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByAsc(ResearchDirection::getSortOrder);
        return Result.success(researchDirectionService.list(wrapper));
    }

    @GetMapping("/research-directions/{id}")
    public Result<ResearchDirection> detail(@PathVariable Long id) {
        ResearchDirection direction = researchDirectionService.getById(id);
        if (direction == null) {
            return Result.error("研究方向不存在");
        }
        return Result.success(direction);
    }

    @PostMapping("/admin/research-directions")
    public Result<Void> create(@RequestBody ResearchDirection direction) {
        researchDirectionService.save(direction);
        return Result.success("新增成功", null);
    }

    @PutMapping("/admin/research-directions/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody ResearchDirection direction) {
        direction.setId(id);
        researchDirectionService.updateById(direction);
        return Result.success("更新成功", null);
    }

    @DeleteMapping("/admin/research-directions/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        researchDirectionService.removeById(id);
        return Result.success("删除成功", null);
    }
}
