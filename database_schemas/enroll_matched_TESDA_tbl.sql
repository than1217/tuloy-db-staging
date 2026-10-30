CREATE TABLE `enroll_matched_TESDA_tbl` ( 
  `id` INT UNSIGNED AUTO_INCREMENT NOT NULL,
  `match_id` INT UNSIGNED NULL,
  `enrollment_id` INT UNSIGNED NOT NULL,
  `tuloy_id` VARCHAR(50) NULL COMMENT 'Unique id across agency pre-generated from TULOY' ,
  `member_id` INT UNSIGNED NOT NULL COMMENT 'Entry_id' ,
  `uli_id` VARCHAR(50) NULL COMMENT 'TESDA ULI' ,
  `mm_first_name` VARCHAR(100) NULL,
  `mm_middle_name` VARCHAR(100) NULL,
  `mm_last_name` VARCHAR(100) NULL,
  `diploma` JSON NULL COMMENT 'JSON object containing: program_name, date_enrolled, program_duration, academic_year, year_level, semester, enrollment_status, date_encoded, date_updated' ,
  `short_course` JSON NULL COMMENT 'JSON object containing: program_name, start_date, end_date, training_status, date_encoded, date_updated' ,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  `updated_at` TIMESTAMP NULL DEFAULT NULL  ON UPDATE CURRENT_TIMESTAMP ,
  `agency_id` INT UNSIGNED NOT NULL DEFAULT 2 ,
  `has_diploma` TINYINT NULL,
  `has_short_course` TINYINT NULL,
   PRIMARY KEY (`id`),
  CONSTRAINT `fk_tesda_matched_transaction` FOREIGN KEY (`match_id`) REFERENCES `matching_transaction_TESDA_tbl` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
)
ENGINE = InnoDB;
CREATE INDEX `fk_tesda_matched_enrollment` 
ON `enroll_matched_TESDA_tbl` (
  `enrollment_id` ASC
);
CREATE INDEX `fk_tesda_matched_transaction` 
ON `enroll_matched_TESDA_tbl` (
  `match_id` ASC
);
CREATE INDEX `idx_enroll_tesda_tuloy` 
ON `enroll_matched_TESDA_tbl` (
  `tuloy_id` ASC,
  `agency_id` ASC,
  `match_id` ASC,
  `member_id` ASC
);
CREATE INDEX `idx_has_diploma` 
ON `enroll_matched_TESDA_tbl` (
  `has_diploma` ASC
);
CREATE INDEX `idx_has_short_course` 
ON `enroll_matched_TESDA_tbl` (
  `has_short_course` ASC
);
