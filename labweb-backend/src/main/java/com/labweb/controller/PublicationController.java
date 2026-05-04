package com.labweb.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.labweb.common.Result;
import com.labweb.entity.Publication;
import com.labweb.service.PublicationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/v1")
public class PublicationController {

    @Autowired
    private PublicationService publicationService;

    @GetMapping("/publications")
    public Result<Map<String, Object>> list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer isRepresentative) {

        LambdaQueryWrapper<Publication> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(type)) {
            wrapper.eq(Publication::getType, type);
        }
        if (year != null) {
            wrapper.eq(Publication::getYear, year);
        }
        if (isRepresentative != null) {
            wrapper.eq(Publication::getIsRepresentative, isRepresentative);
        }

        Page<Publication> result = publicationService.page(new Page<>(page, pageSize), wrapper);
        Map<String, Object> data = new HashMap<>();
        data.put("records", result.getRecords());
        data.put("total", result.getTotal());
        data.put("current", result.getCurrent());
        data.put("pages", result.getPages());
        return Result.success(data);
    }

    @GetMapping("/publications/{id}")
    public Result<Publication> detail(@PathVariable Long id) {
        Publication publication = publicationService.getById(id);
        if (publication == null) {
            return Result.error("成果不存在");
        }
        return Result.success(publication);
    }

    @PostMapping("/admin/publications")
    public Result<Void> create(@RequestBody Publication publication) {
        publicationService.save(publication);
        return Result.success("新增成功", null);
    }

    @PutMapping("/admin/publications/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody Publication publication) {
        publication.setId(id);
        publicationService.updateById(publication);
        return Result.success("更新成功", null);
    }

    @DeleteMapping("/admin/publications/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        publicationService.removeById(id);
        return Result.success("删除成功", null);
    }
}
