CREATE TABLE `audit_log` (
  `log_id` int unsigned NOT NULL AUTO_INCREMENT,
  `tuloy_journey_id` varchar(36) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `details` json DEFAULT NULL,
  `user_info` varchar(100) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `idx_audit_journey_id` (`tuloy_journey_id`),
  KEY `idx_audit_action` (`action`),
  KEY `idx_audit_timestamp` (`timestamp`),
  KEY `idx_audit_journey_timestamp` (`tuloy_journey_id`,`timestamp`),
  CONSTRAINT `fk_audit_journey` FOREIGN KEY (`tuloy_journey_id`) REFERENCES `beneficiary_journey` (`tuloy_journey_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
