package com.labweb.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("publication")
public class Publication {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String title;
    private String authors;
    private String type;
    private String venue;
    private Integer year;
    @TableField("abstract")
    private String abstractText;
    private String doi;
    private String paperUrl;
    private String pdfUrl;
    private String codeUrl;
    private String bibtex;
    private Integer isRepresentative;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
