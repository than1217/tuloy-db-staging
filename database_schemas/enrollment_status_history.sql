CREATE TABLE `enrollment_status_history` (
  `history_id` int unsigned NOT NULL AUTO_INCREMENT,
  `enrollment_id` int unsigned NOT NULL,
  `previous_status` varchar(50) DEFAULT NULL,
  `new_status` varchar(50) NOT NULL,
  `remarks` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`history_id`),
  KEY `fk_history_enrollment` (`enrollment_id`),
  CONSTRAINT `fk_history_enrollment` FOREIGN KEY (`enrollment_id`) REFERENCES `education_enrollment` (`enrollment_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
