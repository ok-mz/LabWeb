package com.labweb.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("lab_info")
public class LabInfo {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String labName;
    private String school;
    private String college;
    private String leader;
    private String location;
    private String email;
    private String introduction;
    private String researchGoal;
    private String coverImage;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
