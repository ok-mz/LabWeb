package com.labweb.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.labweb.entity.Tool;
import com.labweb.mapper.ToolMapper;
import com.labweb.service.ToolService;
import org.springframework.stereotype.Service;

@Service
public class ToolServiceImpl extends ServiceImpl<ToolMapper, Tool> implements ToolService {
}
