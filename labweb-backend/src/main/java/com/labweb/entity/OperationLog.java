package com.labweb.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("operation_log")
public class OperationLog {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private String username;
    private String module;
    private String action;
    private String method;
    private String path;
    private String ip;
    private Integer status;
    private String details;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
}
