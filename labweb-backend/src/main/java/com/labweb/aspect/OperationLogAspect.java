package com.labweb.aspect;

import com.labweb.entity.OperationLog;
import com.labweb.service.OperationLogService;
import jakarta.servlet.http.HttpServletRequest;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

@Aspect
@Component
public class OperationLogAspect {

    @Autowired
    private OperationLogService operationLogService;

    @Pointcut("execution(* com.labweb.controller..*Controller.*(..))")
    public void controllerMethods() {}

    @Around("controllerMethods()")
    public Object logOperation(ProceedingJoinPoint joinPoint) throws Throwable {
        ServletRequestAttributes attrs = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attrs == null) {
            return joinPoint.proceed();
        }

        HttpServletRequest request = attrs.getRequest();
        String path = request.getRequestURI();
        String method = request.getMethod();

        // Only log admin operations, skip login
        if (!path.startsWith("/api/v1/admin/") || path.equals("/api/v1/admin/login")) {
            return joinPoint.proceed();
        }

        long startTime = System.currentTimeMillis();
        Object result;
        int status = 1;
        try {
            result = joinPoint.proceed();
        } catch (Throwable e) {
            status = 0;
            throw e;
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            try {
                OperationLog log = new OperationLog();
                Long userId = (Long) request.getAttribute("userId");
                String username = (String) request.getAttribute("username");
                log.setUserId(userId);
                log.setUsername(username);
                log.setMethod(method);
                log.setPath(path);
                log.setIp(getClientIp(request));
                log.setStatus(status);
                log.setModule(extractModule(path));
                log.setAction(extractAction(method));
                log.setDetails("耗时: " + duration + "ms");
                operationLogService.recordLog(log);
            } catch (Exception ignored) {
                // Logging should not affect the main request
            }
        }
        return result;
    }

    private String extractModule(String path) {
        // /api/v1/admin/publications -> publications
        String[] parts = path.split("/");
        if (parts.length >= 5) {
            return parts[4];
        }
        return "unknown";
    }

    private String extractAction(String method) {
        return switch (method.toUpperCase()) {
            case "POST" -> "新增";
            case "PUT" -> "更新";
            case "DELETE" -> "删除";
            case "GET" -> "查询";
            default -> method;
        };
    }

    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip != null && !ip.isEmpty() && !"unknown".equalsIgnoreCase(ip)) {
            return ip.split(",")[0].trim();
        }
        ip = request.getHeader("X-Real-IP");
        if (ip != null && !ip.isEmpty() && !"unknown".equalsIgnoreCase(ip)) {
            return ip;
        }
        return request.getRemoteAddr();
    }
}
