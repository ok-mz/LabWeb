package com.labweb.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.labweb.entity.OperationLog;

import java.util.List;

public interface OperationLogService extends IService<OperationLog> {
    List<OperationLog> listByPage(Integer page, Integer pageSize);
    Long countTotal();
}
