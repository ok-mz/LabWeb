package com.labweb.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.labweb.entity.FileResource;
import com.labweb.mapper.FileResourceMapper;
import com.labweb.service.FileResourceService;
import org.springframework.stereotype.Service;

@Service
public class FileResourceServiceImpl extends ServiceImpl<FileResourceMapper, FileResource> implements FileResourceService {
}
