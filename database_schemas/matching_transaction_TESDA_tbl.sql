CREATE TABLE `matching_transaction_TESDA_tbl` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `tuloy_id` varchar(100) NOT NULL COMMENT '4Ps member_id from TULOY',
  `status` varchar(50) NOT NULL COMMENT 'e.g., FOUND, NOT FOUND, ERROR',
  `agency_id` int unsigned NOT NULL DEFAULT '2',
  `date_time_matched` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_tuloy_id` (`tuloy_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=207 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
