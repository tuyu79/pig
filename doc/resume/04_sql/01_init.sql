-- ============================================================
-- 简历系统数据库建表脚本
-- Database: pig (与 pig 项目共用数据库，表前缀 resume_*)
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

USE pig;

-- ============================================================
-- 1. 简历主表
-- ============================================================
DROP TABLE IF EXISTS `resume_resume`;
CREATE TABLE `resume_resume` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '所属用户ID',
  `title` varchar(100) NOT NULL COMMENT '简历标题',
  `template_id` bigint NOT NULL DEFAULT '1' COMMENT '使用模板ID',
  `avatar` varchar(500) DEFAULT NULL COMMENT '头像URL',
  `full_name` varchar(50) DEFAULT NULL COMMENT '姓名',
  `gender` char(1) DEFAULT NULL COMMENT '性别 0-男 1-女',
  `birth_date` date DEFAULT NULL COMMENT '出生日期',
  `phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `location` varchar(200) DEFAULT NULL COMMENT '所在城市',
  `post_code` varchar(20) DEFAULT NULL COMMENT '邮编',
  `address` varchar(500) DEFAULT NULL COMMENT '详细地址',
  `summary` text COMMENT '自我评价',
  `expected_position` varchar(100) DEFAULT NULL COMMENT '期望职位',
  `expected_salary` varchar(50) DEFAULT NULL COMMENT '期望薪资',
  `expected_city` varchar(100) DEFAULT NULL COMMENT '期望城市',
  `job_nature` char(1) DEFAULT NULL COMMENT '工作性质 0-全职 1-兼职',
  `earliest_entry_date` date DEFAULT NULL COMMENT '最快入职日期',
  `is_default` char(1) NOT NULL DEFAULT '0' COMMENT '是否默认简历 0-否 1-是',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态 0-草稿 1-已完成',
  `view_count` int NOT NULL DEFAULT '0' COMMENT '浏览次数',
  `create_by` varchar(64) NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL DEFAULT '' COMMENT '修改人',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志 0-未删除 1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_is_default` (`is_default`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='简历主表';

-- ============================================================
-- 2. 模板表
-- ============================================================
DROP TABLE IF EXISTS `resume_template`;
CREATE TABLE `resume_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(50) NOT NULL COMMENT '模板名称',
  `code` varchar(50) NOT NULL COMMENT '模板编码',
  `description` varchar(255) DEFAULT NULL COMMENT '模板描述',
  `thumbnail` varchar(500) DEFAULT NULL COMMENT '缩略图URL',
  `preview_html` longtext COMMENT '预览HTML',
  `config_json` text COMMENT '模板配置JSON',
  `category` varchar(50) DEFAULT NULL COMMENT '模板分类',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `is_active` char(1) NOT NULL DEFAULT '1' COMMENT '是否启用 0-否 1-是',
  `create_by` varchar(64) NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL DEFAULT '' COMMENT '修改人',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志 0-未删除 1-已删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='简历模板表';

-- 插入默认模板
INSERT INTO `resume_template` (`id`, `name`, `code`, `description`, `category`, `sort_order`, `is_active`) VALUES
(1, '简洁风格', 'simple', '简洁大方的标准简历模板', 'common', 1, '1'),
(2, '专业风格', 'professional', '适合资深人士的专业模板', 'common', 2, '1'),
(3, '创意风格', 'creative', '富有创意的简历模板', 'creative', 3, '1');

-- ============================================================
-- 3. 教育经历表
-- ============================================================
DROP TABLE IF EXISTS `resume_education`;
CREATE TABLE `resume_education` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `resume_id` bigint NOT NULL COMMENT '简历ID',
  `school_name` varchar(100) NOT NULL COMMENT '学校名称',
  `degree` char(1) DEFAULT NULL COMMENT '学历 0-高中 1-大专 2-本科 3-硕士 4-博士',
  `major` varchar(100) DEFAULT NULL COMMENT '专业',
  `start_date` date DEFAULT NULL COMMENT '开始日期',
  `end_date` date DEFAULT NULL COMMENT '结束日期',
  `is_current` char(1) NOT NULL DEFAULT '0' COMMENT '是否在读 0-否 1-是',
  `description` text COMMENT '在校经历/描述',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_by` varchar(64) NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL DEFAULT '' COMMENT '修改人',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志 0-未删除 1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_resume_id` (`resume_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='教育经历表';

-- ============================================================
-- 4. 工作经历表
-- ============================================================
DROP TABLE IF EXISTS `resume_work`;
CREATE TABLE `resume_work` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `resume_id` bigint NOT NULL COMMENT '简历ID',
  `company_name` varchar(100) NOT NULL COMMENT '公司名称',
  `department` varchar(100) DEFAULT NULL COMMENT '部门名称',
  `position` varchar(100) NOT NULL COMMENT '职位名称',
  `start_date` date DEFAULT NULL COMMENT '开始日期',
  `end_date` date DEFAULT NULL COMMENT '结束日期',
  `is_current` char(1) NOT NULL DEFAULT '0' COMMENT '是否在职 0-否 1-是',
  `work_content` text COMMENT '工作内容',
  `achievements` text COMMENT '工作业绩',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_by` varchar(64) NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL DEFAULT '' COMMENT '修改人',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志 0-未删除 1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_resume_id` (`resume_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工作经历表';

-- ============================================================
-- 5. 项目经历表
-- ============================================================
DROP TABLE IF EXISTS `resume_project`;
CREATE TABLE `resume_project` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `resume_id` bigint NOT NULL COMMENT '简历ID',
  `project_name` varchar(100) NOT NULL COMMENT '项目名称',
  `role` varchar(100) DEFAULT NULL COMMENT '项目角色',
  `company_name` varchar(100) DEFAULT NULL COMMENT '公司/团队名称',
  `start_date` date DEFAULT NULL COMMENT '开始日期',
  `end_date` date DEFAULT NULL COMMENT '结束日期',
  `project_url` varchar(500) DEFAULT NULL COMMENT '项目链接',
  `description` text COMMENT '项目描述',
  `responsibilities` text COMMENT '项目职责',
  `technologies` varchar(500) DEFAULT NULL COMMENT '使用技术',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_by` varchar(64) NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL DEFAULT '' COMMENT '修改人',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志 0-未删除 1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_resume_id` (`resume_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='项目经历表';

-- ============================================================
-- 6. 专业技能表
-- ============================================================
DROP TABLE IF EXISTS `resume_skill`;
CREATE TABLE `resume_skill` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `resume_id` bigint NOT NULL COMMENT '简历ID',
  `skill_name` varchar(100) NOT NULL COMMENT '技能名称',
  `proficiency` char(1) DEFAULT NULL COMMENT '熟练度 0-了解 1-熟悉 2-精通',
  `category` varchar(50) DEFAULT NULL COMMENT '技能分类',
  `description` varchar(500) DEFAULT NULL COMMENT '技能描述',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_by` varchar(64) NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL DEFAULT '' COMMENT '修改人',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志 0-未删除 1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_resume_id` (`resume_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='专业技能表';

-- ============================================================
-- 7. 证书资质表
-- ============================================================
DROP TABLE IF EXISTS `resume_cert`;
CREATE TABLE `resume_cert` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `resume_id` bigint NOT NULL COMMENT '简历ID',
  `cert_name` varchar(100) NOT NULL COMMENT '证书名称',
  `issuing_agency` varchar(100) DEFAULT NULL COMMENT '发证机构',
  `issue_date` date DEFAULT NULL COMMENT '获得日期',
  `expiry_date` date DEFAULT NULL COMMENT '有效期至',
  `cert_code` varchar(100) DEFAULT NULL COMMENT '证书编号',
  `cert_url` varchar(500) DEFAULT NULL COMMENT '证书图片URL',
  `description` varchar(500) DEFAULT NULL COMMENT '证书描述',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_by` varchar(64) NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL DEFAULT '' COMMENT '修改人',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志 0-未删除 1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_resume_id` (`resume_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='证书资质表';

-- ============================================================
-- 8. 作品集表
-- ============================================================
DROP TABLE IF EXISTS `resume_portfolio`;
CREATE TABLE `resume_portfolio` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `resume_id` bigint NOT NULL COMMENT '简历ID',
  `title` varchar(100) NOT NULL COMMENT '作品标题',
  `description` varchar(500) DEFAULT NULL COMMENT '作品描述',
  `link_url` varchar(500) DEFAULT NULL COMMENT '作品链接',
  `cover_image` varchar(500) DEFAULT NULL COMMENT '封面图URL',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_by` varchar(64) NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL DEFAULT '' COMMENT '修改人',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志 0-未删除 1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_resume_id` (`resume_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='作品集表';

SET FOREIGN_KEY_CHECKS = 1;
