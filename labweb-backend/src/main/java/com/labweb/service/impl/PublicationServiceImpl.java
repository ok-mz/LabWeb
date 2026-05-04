package com.labweb.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.labweb.entity.Publication;
import com.labweb.mapper.PublicationMapper;
import com.labweb.service.PublicationService;
import org.springframework.stereotype.Service;

@Service
public class PublicationServiceImpl extends ServiceImpl<PublicationMapper, Publication> implements PublicationService {
}
