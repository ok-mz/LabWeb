package com.labweb.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.labweb.entity.ResearchDirection;
import com.labweb.mapper.ResearchDirectionMapper;
import com.labweb.service.ResearchDirectionService;
import org.springframework.stereotype.Service;

@Service
public class ResearchDirectionServiceImpl extends ServiceImpl<ResearchDirectionMapper, ResearchDirection> implements ResearchDirectionService {
}
