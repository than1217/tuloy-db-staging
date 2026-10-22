CREATE TABLE `education_enrollment` (
  `enrollment_id` int unsigned NOT NULL AUTO_INCREMENT,
  `tuloy_journey_id` varchar(36) NOT NULL,
  `current_stage` varchar(50) NOT NULL,
  `academic_year` varchar(20) NOT NULL,
  `term` varchar(20) NOT NULL,
  `institution_id` varchar(100) NOT NULL,
  `program_course` varchar(150) NOT NULL,
  `enrollment_status` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`enrollment_id`),
  KEY `fk_enrollment_journey` (`tuloy_journey_id`),
  CONSTRAINT `fk_enrollment_journey` FOREIGN KEY (`tuloy_journey_id`) REFERENCES `beneficiary_journey` (`tuloy_journey_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
