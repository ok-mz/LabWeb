package com.labweb.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.labweb.entity.LabInfo;
import com.labweb.mapper.LabInfoMapper;
import com.labweb.service.LabInfoService;
import org.springframework.stereotype.Service;

@Service
public class LabInfoServiceImpl extends ServiceImpl<LabInfoMapper, LabInfo> implements LabInfoService {
}
