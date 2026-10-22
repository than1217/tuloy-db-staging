CREATE TABLE `payment_account` (
  `account_id` int unsigned NOT NULL AUTO_INCREMENT,
  `tuloy_journey_id` varchar(36) NOT NULL,
  `account_type` varchar(50) NOT NULL,
  `account_number` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`account_id`),
  KEY `fk_payment_account_journey` (`tuloy_journey_id`),
  CONSTRAINT `fk_payment_account_journey` FOREIGN KEY (`tuloy_journey_id`) REFERENCES `beneficiary_journey` (`tuloy_journey_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
