package com.labweb.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("research_direction")
public class ResearchDirection {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String title;
    private String summary;
    private String description;
    private String keywords;
    private String imageUrl;
    private Integer sortOrder;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
