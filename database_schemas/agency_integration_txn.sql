CREATE TABLE `agency_integration_txn` (
  `integration_transaction_id` int unsigned NOT NULL AUTO_INCREMENT,
  `tuloy_journey_id` varchar(36) NOT NULL,
  `agency` varchar(20) NOT NULL,
  `request_payload` json DEFAULT NULL,
  `response_payload` json DEFAULT NULL,
  `status` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`integration_transaction_id`),
  KEY `fk_agency_txn_journey` (`tuloy_journey_id`),
  CONSTRAINT `fk_agency_txn_journey` FOREIGN KEY (`tuloy_journey_id`) REFERENCES `beneficiary_journey` (`tuloy_journey_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
