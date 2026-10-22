CREATE TABLE `beneficiary_journey` (
  `tuloy_journey_id` varchar(36) NOT NULL DEFAULT (uuid()),
  `member_id` int unsigned NOT NULL,
  `tuloy_journey_ref_no` varchar(50) NOT NULL,
  `listahanan_id` varchar(100) DEFAULT NULL,
  `household_id` varchar(100) DEFAULT NULL,
  `personal_details` json NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`tuloy_journey_id`),
  UNIQUE KEY `uk_member_id` (`member_id`),
  UNIQUE KEY `uk_tuloy_journey_ref_no` (`tuloy_journey_ref_no`),
  KEY `idx_listahanan_id` (`listahanan_id`),
  KEY `idx_household_id` (`household_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
