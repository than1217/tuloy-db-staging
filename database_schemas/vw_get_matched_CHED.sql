CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vw_get_matched_CHED` AS
SELECT `m`.`id` AS `id`,`m`.`match_id` AS `match_id`,
  `m`.`enrollment_id` AS `enrollment_id`,`m`.`tuloy_id` AS `tuloy_id`,`m`.`member_id` AS `member_id`,
  `m`.`student_id` AS `student_id`,`vmb`.`first_name` AS `first_name`,`vmb`.`middle_name` AS `middle_name`,
  `vmb`.`last_name` AS `last_name`,`m`.`mm_first_name` AS `mm_first_name`,
  `m`.`mm_middle_name` AS `mm_middle_name`,`m`.`mm_last_name` AS `mm_last_name`,`vmb`.`region_name` AS `region_name`,
  `vmb`.`province_name` AS `province_name`,`vmb`.`city_name` AS `city_name`,`vmb`.`barangay_name` AS `barangay_name`,
  `m`.`degree_program_name` AS `degree_program_name`,`m`.`degree_date_enrolled` AS `degree_date_enrolled`,
  `m`.`degree_program_duration` AS `degree_program_duration`,`m`.`degree_academic_year` AS `degree_academic_year`,
  `m`.`degree_year_level` AS `degree_year_level`,`m`.`degree_semester` AS `degree_semester`,
  `m`.`enrollment_status` AS `enrollment_status`,`m`.`date_encoded` AS `date_encoded`,`m`.`date_updated` AS `date_updated`,
  `m`.`created_at` AS `created_at`,`m`.`updated_at` AS `updated_at`
FROM (`enroll_matched_CHED_tbl` `m`
      LEFT JOIN `vw_verify_member_bene` `vmb` on((`vmb`.`member_id` = `m`.`member_id`)));
