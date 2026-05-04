package com.labweb.controller;

import com.labweb.common.Result;
import com.labweb.entity.FileResource;
import com.labweb.service.FileResourceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.*;

@RestController
@RequestMapping("/api/v1/admin/files")
public class FileController {

    @Value("${file.upload-path}")
    private String uploadPath;

    @Autowired
    private FileResourceService fileResourceService;

    private static final Set<String> ALLOWED_IMAGE_TYPES = new HashSet<>(Arrays.asList(
            "image/jpeg", "image/png", "image/gif", "image/webp", "image/svg+xml"
    ));
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB

    @PostMapping("/upload")
    public Result<Map<String, Object>> upload(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return Result.error("请选择要上传的文件");
        }
        if (file.getSize() > MAX_FILE_SIZE) {
            return Result.error("文件大小不能超过10MB");
        }
        String contentType = file.getContentType();
        if (contentType == null || !ALLOWED_IMAGE_TYPES.contains(contentType)) {
            return Result.error("仅支持上传图片文件（JPG/PNG/GIF/WebP/SVG）");
        }

        String originalName = file.getOriginalFilename();
        String suffix = "";
        if (originalName != null && originalName.contains(".")) {
            suffix = originalName.substring(originalName.lastIndexOf("."));
        }
        String filename = UUID.randomUUID().toString() + suffix;
        String fileType = contentType.startsWith("image/") ? "image" : "other";

        File dest = new File(uploadPath, filename);
        if (!dest.getParentFile().exists()) {
            dest.getParentFile().mkdirs();
        }
        try {
            file.transferTo(dest);
        } catch (IOException e) {
            return Result.error("文件上传失败，请重试");
        }

        FileResource resource = new FileResource();
        resource.setFilename(filename);
        resource.setOriginalName(originalName);
        resource.setFilePath("/uploads/" + filename);
        resource.setFileType(fileType);
        resource.setFileSize(file.getSize());
        fileResourceService.save(resource);

        Map<String, Object> data = new HashMap<>();
        data.put("id", resource.getId());
        data.put("url", "/uploads/" + filename);
        data.put("originalName", originalName);
        return Result.success("上传成功", data);
    }
}
