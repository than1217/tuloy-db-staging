CREATE TABLE `bcmd_dqa_issue` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `batch_id` bigint unsigned NOT NULL,
  `member_id` bigint unsigned DEFAULT NULL,
  `member_key` bigint unsigned GENERATED ALWAYS AS (ifnull(`member_id`,0)) STORED NOT NULL,
  `rule_code` varchar(40) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `field_no` tinyint unsigned NOT NULL DEFAULT '0',
  `severity` varchar(5) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_bcmd_issue` (`batch_id`,`member_key`,`field_no`,`rule_code`),
  KEY `ix_bcmd_issue_rule` (`batch_id`,`rule_code`),
  KEY `fk_bcmd_issue_member` (`batch_id`,`member_id`),
  CONSTRAINT `fk_bcmd_issue_batch` FOREIGN KEY (`batch_id`) REFERENCES `bcmd_batch` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_bcmd_issue_member` FOREIGN KEY (`batch_id`, `member_id`) REFERENCES `bcmd_batch_member` (`batch_id`, `id`) ON DELETE RESTRICT,
  CONSTRAINT `ck_bcmd_issue_sev` CHECK ((`severity` in (_utf8mb4'WARN',_utf8mb4'BLOCK')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
