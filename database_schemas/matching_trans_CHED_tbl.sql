CREATE TABLE `matching_transaction_CHED_tbl` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `tuloy_id` varchar(100) NOT NULL COMMENT 'id from TULOY',
  `status` varchar(50) NOT NULL COMMENT 'e.g., FOUND, NOT FOUND, ERROR',
  `date_time_matched` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_tuloy_id` (`tuloy_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
