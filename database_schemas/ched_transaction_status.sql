CREATE TABLE `ched_transaction_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tuloy_id` varchar(255) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `error_code` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
