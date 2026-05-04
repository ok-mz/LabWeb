package com.labweb.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("agent_usage_log")
public class AgentUsageLog {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long agentId;
    private String agentName;
    private Long userId;
    private String username;
    private String accessType;
    private String ip;
    private String userAgent;
    private Integer statusCode;
    private Integer duration;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
}
