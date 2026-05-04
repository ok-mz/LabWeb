-- =============================================
-- LabWeb 实验室官网 数据库建表脚本
-- 数据库: labweb (application.yml 中配置 createDatabaseIfNotExist=true 自动创建)
-- =============================================

-- 1. 管理员用户表
CREATE TABLE IF NOT EXISTS `user` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `username`    VARCHAR(50)  NOT NULL COMMENT '用户名',
    `password_hash` VARCHAR(255) NOT NULL COMMENT 'BCrypt加密密码',
    `email`       VARCHAR(100)          DEFAULT NULL COMMENT '邮箱',
    `status`      TINYINT      NOT NULL DEFAULT 1 COMMENT '状态: 1-启用 0-禁用',
    `created_at`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员用户表';

-- 2. 实验室信息表 (单条记录)
CREATE TABLE IF NOT EXISTS `lab_info` (
    `id`            BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `lab_name`      VARCHAR(200)          DEFAULT NULL COMMENT '实验室名称',
    `school`        VARCHAR(200)          DEFAULT NULL COMMENT '所属学校',
    `college`       VARCHAR(200)          DEFAULT NULL COMMENT '所属学院',
    `leader`        VARCHAR(100)          DEFAULT NULL COMMENT '负责人',
    `location`      VARCHAR(300)          DEFAULT NULL COMMENT '办公地点',
    `email`         VARCHAR(100)          DEFAULT NULL COMMENT '联系邮箱',
    `introduction`  TEXT                  DEFAULT NULL COMMENT '实验室简介',
    `research_goal` TEXT                  DEFAULT NULL COMMENT '研究目标',
    `cover_image`   VARCHAR(500)          DEFAULT NULL COMMENT '封面图片URL',
    `created_at`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实验室信息表';

-- 3. 研究方向表
CREATE TABLE IF NOT EXISTS `research_direction` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `title`       VARCHAR(200) NOT NULL COMMENT '方向名称',
    `summary`     VARCHAR(500)          DEFAULT NULL COMMENT '简要描述',
    `description` TEXT                  DEFAULT NULL COMMENT '详细描述',
    `keywords`    VARCHAR(500)          DEFAULT NULL COMMENT '关键词，逗号分隔',
    `image_url`   VARCHAR(500)          DEFAULT NULL COMMENT '配图URL',
    `sort_order`  INT          NOT NULL DEFAULT 0 COMMENT '排序序号',
    `created_at`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='研究方向表';

-- 4. 发表成果表
CREATE TABLE IF NOT EXISTS `publication` (
    `id`               BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `title`            VARCHAR(500) NOT NULL COMMENT '成果标题',
    `authors`          VARCHAR(1000)         DEFAULT NULL COMMENT '作者列表',
    `type`             VARCHAR(50)           DEFAULT NULL COMMENT '类型: 论文/专利/软著/获奖',
    `venue`            VARCHAR(300)          DEFAULT NULL COMMENT '期刊/会议名称',
    `year`             INT                   DEFAULT NULL COMMENT '发表年份',
    `abstract`         TEXT                  DEFAULT NULL COMMENT '摘要',
    `doi`              VARCHAR(200)          DEFAULT NULL COMMENT 'DOI链接',
    `paper_url`        VARCHAR(500)          DEFAULT NULL COMMENT '论文链接',
    `pdf_url`          VARCHAR(500)          DEFAULT NULL COMMENT 'PDF下载地址',
    `code_url`         VARCHAR(500)          DEFAULT NULL COMMENT '代码仓库地址',
    `bibtex`           TEXT                  DEFAULT NULL COMMENT 'BibTeX引用',
    `is_representative` TINYINT     NOT NULL DEFAULT 0 COMMENT '是否代表作: 1-是 0-否',
    `created_at`       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_type` (`type`),
    KEY `idx_year` (`year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='发表成果表';

-- 5. 科研工具表
CREATE TABLE IF NOT EXISTS `tool` (
    `id`         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `name`       VARCHAR(200) NOT NULL COMMENT '工具名称',
    `icon`       VARCHAR(500)          DEFAULT NULL COMMENT '图标URL',
    `summary`    VARCHAR(500)          DEFAULT NULL COMMENT '工具简介',
    `type`       VARCHAR(50)           DEFAULT NULL COMMENT '工具类型',
    `access_url` VARCHAR(500)          DEFAULT NULL COMMENT '访问地址',
    `doc_url`    VARCHAR(500)          DEFAULT NULL COMMENT '文档地址',
    `permission` VARCHAR(50)           DEFAULT NULL COMMENT '权限要求',
    `status`     VARCHAR(20)  NOT NULL DEFAULT '可用' COMMENT '状态: 可用/维护中',
    `created_at` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='科研工具表';

-- 6. Agent配置表
CREATE TABLE IF NOT EXISTS `agent` (
    `id`              BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `name`            VARCHAR(200) NOT NULL COMMENT 'Agent名称',
    `icon`            VARCHAR(500)          DEFAULT NULL COMMENT '图标URL',
    `summary`         VARCHAR(500)          DEFAULT NULL COMMENT '简介描述',
    `integration_type` VARCHAR(20)          DEFAULT 'link' COMMENT '接入方式: link/iframe/api',
    `access_url`      VARCHAR(500)          DEFAULT NULL COMMENT '访问地址',
    `api_host`        VARCHAR(200)          DEFAULT NULL COMMENT 'API主机地址',
    `api_port`        INT                   DEFAULT NULL COMMENT 'API端口',
    `api_path`        VARCHAR(300)          DEFAULT NULL COMMENT 'API路径',
    `api_url`         VARCHAR(500)          DEFAULT NULL COMMENT '完整API地址（优先）',
    `method`          VARCHAR(10)           DEFAULT 'GET' COMMENT '请求方法: GET/POST',
    `permission`      VARCHAR(50)           DEFAULT NULL COMMENT '权限要求',
    `status`          VARCHAR(20)  NOT NULL DEFAULT '未接入' COMMENT '状态: 未接入/可用/维护中',
    `sort_order`      INT          NOT NULL DEFAULT 0 COMMENT '排序序号',
    `created_at`      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Agent配置表';

-- 8. 操作日志表
CREATE TABLE IF NOT EXISTS `operation_log` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `user_id`     BIGINT       NOT NULL COMMENT '操作用户ID',
    `username`    VARCHAR(50)  NOT NULL COMMENT '用户名',
    `module`      VARCHAR(50)  NOT NULL COMMENT '操作模块',
    `action`      VARCHAR(50)  NOT NULL COMMENT '操作类型',
    `method`      VARCHAR(10)  NOT NULL COMMENT '请求方法',
    `path`        VARCHAR(200) NOT NULL COMMENT '请求路径',
    `ip`          VARCHAR(50)           DEFAULT NULL COMMENT '操作IP',
    `status`      TINYINT      NOT NULL DEFAULT 1 COMMENT '执行状态: 1-成功 0-失败',
    `details`     TEXT                  DEFAULT NULL COMMENT '操作详情',
    `created_at`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_user` (`user_id`),
    KEY `idx_module` (`module`),
    KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作日志表';

-- 9. Agent使用日志表
CREATE TABLE IF NOT EXISTS `agent_usage_log` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `agent_id`    BIGINT       NOT NULL COMMENT 'Agent ID',
    `agent_name`  VARCHAR(200) NOT NULL COMMENT 'Agent名称',
    `user_id`     BIGINT                DEFAULT NULL COMMENT '使用用户ID',
    `username`    VARCHAR(50)           DEFAULT NULL COMMENT '用户名',
    `access_type` VARCHAR(20)  NOT NULL COMMENT '访问方式: link/iframe/api',
    `ip`          VARCHAR(50)           DEFAULT NULL COMMENT '访问IP',
    `user_agent`  VARCHAR(500)          DEFAULT NULL COMMENT 'User-Agent',
    `status_code` INT          NOT NULL DEFAULT 200 COMMENT '响应状态码',
    `duration`    INT                   DEFAULT NULL COMMENT '响应耗时(ms)',
    `created_at`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_agent` (`agent_id`),
    KEY `idx_user` (`user_id`),
    KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Agent使用日志表';


-- =============================================
-- 初始数据
-- =============================================

-- 初始管理员账号: admin / admin123  (BCrypt加密)
INSERT INTO `user` (`username`, `password_hash`, `email`, `status`) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5Eh', 'admin@lab.edu.cn', 1);

-- 实验室信息初始记录
INSERT INTO `lab_info` (`lab_name`, `school`, `college`, `leader`, `location`, `email`, `introduction`, `research_goal`) VALUES
('生物信息学与基因组学实验室', 'XX大学', '生命科学学院', '张教授', '生命科学楼A座501室', 'lab@xxu.edu.cn',
 '本实验室专注于生物信息学与基因组学前沿研究，围绕结构变异、三维基因组、泛基因组和AI制药四大方向，致力于发展新型计算方法与工具，解析生命科学中的关键问题。',
 '以计算生物学方法为核心，整合多组学数据，构建从基因组变异检测到功能解析的完整分析体系，推动精准医学与药物研发。');

-- 4大研究方向初始数据
INSERT INTO `research_direction` (`title`, `summary`, `description`, `keywords`, `sort_order`) VALUES
('结构变异',
 '聚焦复杂结构变异的识别、注释与群体层面的功能解析，支撑疾病关联、群体进化与精准诊断研究。',
 '结构变异（Structural Variation, SV）是基因组变异的重要类型，包括缺失、插入、倒位、易位等复杂重排。本方向致力于：\n\n1. **长读长与短读长联合检测框架**：整合PacBio HiFi、Oxford Nanopore等三代测序数据与Illumina短读长数据，开发高灵敏度、高特异性的SV检测流程。\n2. **复杂重排的断点解析与可视化**：针对复杂基因组重排事件，实现单碱基精度的断点定位与交互式可视化。\n3. **结构变异在疾病与表型中的关联分析**：建立SV与疾病表型、群体进化特征的统计关联模型，挖掘功能性SV位点。',
 '结构变异,长读长测序,断点检测,疾病关联,群体基因组学', 1),

('三维基因组',
 '围绕染色质高级结构、增强子互作与空间调控网络，构建多尺度三维基因组计算分析能力。',
 '三维基因组学（3D Genomics）研究染色质在细胞核内的空间组织结构及其对基因表达调控的影响。本方向聚焦于：\n\n1. **Hi-C / Micro-C 数据处理与互作建模**：从原始测序数据到互作矩阵的标准化分析流程，支持多种分辨率下的染色质互作图谱构建。\n2. **TAD、Loop 与调控单元联合分析**：识别拓扑关联结构域（TAD）、染色质环（Loop）等关键结构特征，结合ChIP-seq、ATAC-seq等多组学数据解析调控逻辑。\n3. **三维结构变化对表达调控的解释**：比较不同细胞状态或疾病条件下的三维基因组重塑，揭示空间构象变化与基因表达失调的因果关系。',
 '三维基因组,Hi-C,染色质构象,TAD,增强子互作', 2),

('泛基因组',
 '建设多样本参考表示与图结构分析流程，提升群体遗传变异表征能力，避免单一参考偏差。',
 '泛基因组（Pan-genome）突破了单一线性参考基因组的局限，以图结构或多序列比对方式表征群体中所有遗传变异。本方向主要研究：\n\n1. **图泛基因组构建与索引**：基于Minigraph、PGGB等工具构建高质量图泛基因组，支持大规模群体的变异存储与高效查询。\n2. **多参考比对与变异召回优化**：利用图基因组进行短读长/长读长数据的比对，显著提升SV和复杂区域变异的检出率。\n3. **群体差异位点与功能区域挖掘**：在泛基因组框架下识别群体特有序列、拷贝数变异及功能元件，为进化与适应研究提供新视角。',
 '泛基因组,图基因组,多参考比对,群体变异,结构变异检测', 3),

('AI 制药',
 '结合生物序列、结构信息与多模态学习，服务于靶点发现、分子生成、药效预测与机制解释。',
 'AI制药（AI-driven Drug Discovery）利用深度学习、图神经网络和大语言模型等技术，加速药物研发全流程。本方向关注：\n\n1. **分子生成与筛选模型**：基于强化学习、扩散模型等方法的类药分子从头设计，结合ADMET性质预测进行虚拟筛选。\n2. **蛋白质结构表征与结合位点评估**：利用AlphaFold、ESMFold等结构预测结果，结合几何深度学习进行药物-靶标结合亲和力预测。\n3. **生物医学知识图谱与智能问答接口**：构建整合基因-疾病-药物-通路的知识图谱，提供面向药物研发的自然语言问答与推理能力。',
 'AI制药,分子生成,药物靶点预测,知识图谱,深度学习', 4);
