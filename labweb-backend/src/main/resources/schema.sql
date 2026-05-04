-- LabWeb 数据库建表脚本（SpringBoot启动时自动执行）
-- spring.sql.init.mode=always 控制

CREATE TABLE IF NOT EXISTS `user` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT,
    `username`    VARCHAR(50)  NOT NULL,
    `password_hash` VARCHAR(255) NOT NULL,
    `email`       VARCHAR(100),
    `status`      TINYINT      NOT NULL DEFAULT 1,
    `created_at`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `lab_info` (
    `id`            BIGINT       NOT NULL AUTO_INCREMENT,
    `lab_name`      VARCHAR(200),
    `school`        VARCHAR(200),
    `college`       VARCHAR(200),
    `leader`        VARCHAR(100),
    `location`      VARCHAR(300),
    `email`         VARCHAR(100),
    `introduction`  TEXT,
    `research_goal` TEXT,
    `cover_image`   VARCHAR(500),
    `created_at`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `research_direction` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT,
    `title`       VARCHAR(200) NOT NULL,
    `summary`     VARCHAR(500),
    `description` TEXT,
    `keywords`    VARCHAR(500),
    `image_url`   VARCHAR(500),
    `sort_order`  INT          NOT NULL DEFAULT 0,
    `created_at`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `publication` (
    `id`               BIGINT       NOT NULL AUTO_INCREMENT,
    `title`            VARCHAR(500) NOT NULL,
    `authors`          VARCHAR(1000),
    `type`             VARCHAR(50),
    `venue`            VARCHAR(300),
    `year`             INT,
    `abstract`         TEXT,
    `doi`              VARCHAR(200),
    `is_representative` TINYINT     NOT NULL DEFAULT 0,
    `created_at`       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_type` (`type`),
    KEY `idx_year` (`year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `tool` (
    `id`         BIGINT       NOT NULL AUTO_INCREMENT,
    `name`       VARCHAR(200) NOT NULL,
    `icon`       VARCHAR(500),
    `summary`    VARCHAR(500),
    `access_url` VARCHAR(500),
    `doc_url`    VARCHAR(500),
    `status`     VARCHAR(20)  NOT NULL DEFAULT '可用',
    `created_at` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `agent` (
    `id`              BIGINT       NOT NULL AUTO_INCREMENT,
    `name`            VARCHAR(200) NOT NULL,
    `icon`            VARCHAR(500),
    `summary`         VARCHAR(500),
    `integration_type` VARCHAR(20)  DEFAULT 'link',
    `access_url`      VARCHAR(500),
    `api_host`        VARCHAR(200),
    `api_port`        INT,
    `api_path`        VARCHAR(300),
    `status`          VARCHAR(20)  NOT NULL DEFAULT '未接入',
    `sort_order`      INT          NOT NULL DEFAULT 0,
    `created_at`      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `file_resource` (
    `id`            BIGINT       NOT NULL AUTO_INCREMENT,
    `filename`      VARCHAR(500) NOT NULL,
    `original_name` VARCHAR(500) NOT NULL,
    `file_path`     VARCHAR(500) NOT NULL,
    `file_type`     VARCHAR(50)  NOT NULL,
    `file_size`     BIGINT       NOT NULL DEFAULT 0,
    `created_at`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- 初始数据（spring.sql.init.mode=always 每次启动都会尝试执行，
-- 但 IGNORE / ON DUPLICATE KEY 保证不会重复插入）
-- =============================================

INSERT IGNORE INTO `user` (`username`, `password_hash`, `email`, `status`) VALUES
('admin', '$2b$12$DgN.m.O7oPC4DZNCRf/3aeEGix7Z3mHXpD1K6R2f785o9M3MrgGXG', 'admin@lab.edu.cn', 1);

INSERT IGNORE INTO `lab_info` (`id`, `lab_name`, `school`, `college`, `leader`, `location`, `email`, `introduction`, `research_goal`) VALUES
(1,
 '生物信息学与基因组学实验室',
 'XX大学',
 '生命科学学院',
 '张教授',
 '生命科学楼A座501室',
 'lab@xxu.edu.cn',
 '本实验室专注于生物信息学与基因组学前沿研究，围绕结构变异、三维基因组、泛基因组和AI制药四大方向，致力于发展新型计算方法与工具，解析生命科学中的关键问题。',
 '以计算生物学方法为核心，整合多组学数据，构建从基因组变异检测到功能解析的完整分析体系，推动精准医学与药物研发。');

INSERT IGNORE INTO `research_direction` (`id`, `title`, `summary`, `description`, `keywords`, `sort_order`) VALUES
(1, '结构变异',
 '聚焦复杂结构变异的识别、注释与群体层面的功能解析，支撑疾病关联、群体进化与精准诊断研究。',
 '结构变异（Structural Variation, SV）是基因组变异的重要类型，包括缺失、插入、倒位、易位等复杂重排。本方向致力于：\n\n1. **长读长与短读长联合检测框架**：整合PacBio HiFi、Oxford Nanopore等三代测序数据与Illumina短读长数据，开发高灵敏度、高特异性的SV检测流程。\n2. **复杂重排的断点解析与可视化**：针对复杂基因组重排事件，实现单碱基精度的断点定位与交互式可视化。\n3. **结构变异在疾病与表型中的关联分析**：建立SV与疾病表型、群体进化特征的统计关联模型，挖掘功能性SV位点。',
 '结构变异,长读长测序,断点检测,疾病关联,群体基因组学', 1),

(2, '三维基因组',
 '围绕染色质高级结构、增强子互作与空间调控网络，构建多尺度三维基因组计算分析能力。',
 '三维基因组学（3D Genomics）研究染色质在细胞核内的空间组织结构及其对基因表达调控的影响。本方向聚焦于：\n\n1. **Hi-C / Micro-C 数据处理与互作建模**：从原始测序数据到互作矩阵的标准化分析流程，支持多种分辨率下的染色质互作图谱构建。\n2. **TAD、Loop 与调控单元联合分析**：识别拓扑关联结构域（TAD）、染色质环（Loop）等关键结构特征，结合ChIP-seq、ATAC-seq等多组学数据解析调控逻辑。\n3. **三维结构变化对表达调控的解释**：比较不同细胞状态或疾病条件下的三维基因组重塑，揭示空间构象变化与基因表达失调的因果关系。',
 '三维基因组,Hi-C,染色质构象,TAD,增强子互作', 2),

(3, '泛基因组',
 '建设多样本参考表示与图结构分析流程，提升群体遗传变异表征能力，避免单一参考偏差。',
 '泛基因组（Pan-genome）突破了单一线性参考基因组的局限，以图结构或多序列比对方式表征群体中所有遗传变异。本方向主要研究：\n\n1. **图泛基因组构建与索引**：基于Minigraph、PGGB等工具构建高质量图泛基因组，支持大规模群体的变异存储与高效查询。\n2. **多参考比对与变异召回优化**：利用图基因组进行短读长/长读长数据的比对，显著提升SV和复杂区域变异的检出率。\n3. **群体差异位点与功能区域挖掘**：在泛基因组框架下识别群体特有序列、拷贝数变异及功能元件，为进化与适应研究提供新视角。',
 '泛基因组,图基因组,多参考比对,群体变异,结构变异检测', 3),

(4, 'AI 制药',
 '结合生物序列、结构信息与多模态学习，服务于靶点发现、分子生成、药效预测与机制解释。',
 'AI制药（AI-driven Drug Discovery）利用深度学习、图神经网络和大语言模型等技术，加速药物研发全流程。本方向关注：\n\n1. **分子生成与筛选模型**：基于强化学习、扩散模型等方法的类药分子从头设计，结合ADMET性质预测进行虚拟筛选。\n2. **蛋白质结构表征与结合位点评估**：利用AlphaFold、ESMFold等结构预测结果，结合几何深度学习进行药物-靶标结合亲和力预测。\n3. **生物医学知识图谱与智能问答接口**：构建整合基因-疾病-药物-通路的知识图谱，提供面向药物研发的自然语言问答与推理能力。',
 'AI制药,分子生成,药物靶点预测,知识图谱,深度学习', 4);
