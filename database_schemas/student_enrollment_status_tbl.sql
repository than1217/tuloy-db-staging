CREATE TABLE `student_enrollment_status_tbl` (
  `id` int NOT NULL AUTO_INCREMENT,
  `beneficiary_id` int NOT NULL,
  `academic_year` varchar(20) NOT NULL,
  `semester` varchar(20) NOT NULL,
  `agency_source` varchar(20) NOT NULL,
  `verification_status` varchar(50) NOT NULL,
  `matched_institution` varchar(255) DEFAULT NULL,
  `matched_program` varchar(255) DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `ix_student_enrollment_status_tbl_id` (`id`),
  KEY `ix_student_enrollment_status_tbl_beneficiary_id` (`beneficiary_id`),
  CONSTRAINT `student_enrollment_status_tbl_ibfk_1` FOREIGN KEY (`beneficiary_id`) REFERENCES `tuloy_beneficiary_tbl` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
