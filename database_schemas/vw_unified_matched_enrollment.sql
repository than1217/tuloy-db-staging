CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vw_unified_matched_enrollment` AS WITH
  `unmatched_tesda` AS
  (SELECT `t`.`id` AS `id`,`t`.`match_id` AS `match_id`,
     `t`.`enrollment_id` AS `enrollment_id`,`t`.`tuloy_id` AS `tuloy_id`,`t`.`member_id` AS `member_id`,
     `t`.`uli_id` AS `uli_id`,`t`.`mm_first_name` AS `mm_first_name`,
     `t`.`mm_middle_name` AS `mm_middle_name`,`t`.`mm_last_name` AS `mm_last_name`,`t`.`diploma` AS `diploma`,
     `t`.`short_course` AS `short_course`,`t`.`created_at` AS `created_at`,`t`.`updated_at` AS `updated_at`,
     `t`.`agency_id` AS `agency_id`,`t`.`has_diploma` AS `has_diploma`,
     `t`.`has_short_course` AS `has_short_course`
   FROM `enroll_matched_TESDA_tbl` `t`
   WHERE exists
       (SELECT 1
        FROM `enroll_matched_CHED_tbl` `c`
        WHERE (`c`.`tuloy_id` = `t`.`tuloy_id`)) IS FALSE),
  `unified` AS
  (SELECT 'CHED' AS `agency_name`,`c`.`tuloy_id` AS `tuloy_id`,
     `c`.`member_id` AS `member_id`,
     json_object(
       'degree',
       json_object(
         'student_id', `c`.`student_id`, 'course_type', 'Degree', 'program_name',
         `c`.`degree_program_name`, 'date_enrolled', `c`.`degree_date_enrolled`, 'program_duration',
         `c`.`degree_program_duration`, 'academic_year', `c`.`degree_academic_year`, 'year_level',
         `c`.`degree_year_level`, 'semester', `c`.`degree_semester`, 'enrollment_status',
         `c`.`enrollment_status`, 'date_encoded', `c`.`date_encoded`, 'date_updated', `c`.`date_updated`)) AS `enrollment_details`,`c`.`created_at` AS `created_at`,`c`.`updated_at` AS `updated_at`
   FROM `enroll_matched_CHED_tbl` `c`
   UNION ALL SELECT 'TESDA' AS `agency_name`,`t`.`tuloy_id` AS `tuloy_id`,
     `t`.`member_id` AS `member_id`,
     json_object(
       'diploma',
       json_object(
         'uli_id', `t`.`uli_id`, 'course_type', 'Diploma', 'program_name',
         json_unquote(json_extract(
                        `t`.`diploma`, '$.program_name')), 'date_enrolled',
         cast(json_unquote(json_extract(
                             `t`.`diploma`, '$.date_enrolled')) AS date), 'program_duration',
         cast(json_unquote(json_extract(
                             `t`.`diploma`, '$.program_duration')) AS unsigned), 'academic_year',
         json_unquote(json_extract(
                        `t`.`diploma`, '$.academic_year')), 'year_level',
         cast(json_unquote(json_extract(
                             `t`.`diploma`, '$.year_level')) AS unsigned), 'semester',
         cast(json_unquote(json_extract(
                             `t`.`diploma`, '$.semester')) AS unsigned), 'enrollment_status',
         json_unquote(json_extract(
                        `t`.`diploma`, '$.enrollment_status')), 'date_encoded',
         cast(json_unquote(json_extract(
                             `t`.`diploma`, '$.date_encoded')) AS datetime), 'date_updated',
         cast(json_unquote(json_extract(
                             `t`.`diploma`, '$.date_updated')) AS datetime))) AS `enrollment_details`,`t`.`created_at` AS `created_at`,`t`.`updated_at` AS `updated_at`
   FROM `unmatched_tesda` `t`
   WHERE (`t`.`diploma` IS NOT NULL)
   UNION ALL SELECT 'TESDA' AS `agency_name`,`t`.`tuloy_id` AS `tuloy_id`,
     `t`.`member_id` AS `member_id`,
     json_object(
       'short_course',
       json_object(
         'uli_id', `t`.`uli_id`, 'course_type', 'Short Course', 'program_name',
         json_unquote(json_extract(
                        `t`.`short_course`, '$.program_name')), 'start_date',
         cast(json_unquote(json_extract(
                             `t`.`short_course`, '$.start_date')) AS date), 'end_date',
         cast(json_unquote(json_extract(
                             `t`.`short_course`, '$.end_date')) AS date), 'enrollment_status',
         json_unquote(json_extract(
                        `t`.`short_course`, '$.training_status')), 'date_encoded',
         cast(json_unquote(json_extract(
                             `t`.`short_course`, '$.date_encoded')) AS datetime), 'date_updated',
         cast(json_unquote(json_extract(
                             `t`.`short_course`, '$.date_updated')) AS datetime))) AS `enrollment_details`,`t`.`created_at` AS `created_at`,`t`.`updated_at` AS `updated_at`
   FROM `unmatched_tesda` `t`
   WHERE (`t`.`short_course` IS NOT NULL))
SELECT `u`.`agency_name` AS `agency_name`,`u`.`tuloy_id` AS `tuloy_id`,
  `u`.`member_id` AS `member_id`,`p`.`first_name` AS `first_name`,`p`.`middle_name` AS `middle_name`,
  `p`.`last_name` AS `last_name`,`psgc`.`region_name` AS `region`,`psgc`.`province_name` AS `province`,
  `psgc`.`city_name` AS `municipality`,`bgy`.`name` AS `barangay`,`u`.`enrollment_details` AS `enrollment_details`,
  `u`.`created_at` AS `created_at`,`u`.`updated_at` AS `updated_at`
FROM (((((`unified` `u`
          LEFT JOIN `tbl_person` `p` on((`p`.`person_id` = `u`.`member_id`)))
         LEFT JOIN `tbl_hh_roster` `r` on((`r`.`person_id` = `p`.`person_id`)))
        LEFT JOIN `tbl_household` `h` on((`h`.`household_id` = `r`.`household_id`)))
       LEFT JOIN `lib_psgc_barangay` `bgy` on((`bgy`.`barangay_id` = `h`.`barangay_id`)))
      LEFT JOIN `lib_psgc_denorm` `psgc` on((`psgc`.`barangay_id` = `bgy`.`barangay_id`)));
