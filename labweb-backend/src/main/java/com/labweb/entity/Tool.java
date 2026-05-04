package com.labweb.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("tool")
public class Tool {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String name;
    private String icon;
    private String summary;
    private String type;
    private String accessUrl;
    private String docUrl;
    private String permission;
    private String status;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
