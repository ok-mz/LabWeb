package com.labweb.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("file_resource")
public class FileResource {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String filename;
    private String originalName;
    private String filePath;
    private String fileType;
    private Long fileSize;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
}
