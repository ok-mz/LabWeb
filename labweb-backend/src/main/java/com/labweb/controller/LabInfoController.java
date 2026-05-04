package com.labweb.controller;

import com.labweb.common.Result;
import com.labweb.entity.LabInfo;
import com.labweb.service.LabInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1")
public class LabInfoController {

    @Autowired
    private LabInfoService labInfoService;

    @GetMapping("/lab-info")
    public Result<LabInfo> getLabInfo() {
        List<LabInfo> list = labInfoService.list();
        if (list.isEmpty()) {
            return Result.error("暂无实验室信息");
        }
        return Result.success(list.get(0));
    }

    @PutMapping("/admin/lab-info")
    public Result<Void> updateLabInfo(@RequestBody LabInfo labInfo) {
        labInfoService.saveOrUpdate(labInfo);
        return Result.success("更新成功", null);
    }
}
