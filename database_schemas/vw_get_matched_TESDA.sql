CREATE VIEW `vw_get_matched_TESDA` AS
select
  `m`.`id` AS `id`,
  `m`.`match_id` AS `match_id`,
  `m`.`enrollment_id` AS `enrollment_id`,
  `m`.`tuloy_id` AS `tuloy_id`,
  `m`.`member_id` AS `member_id`,
  `m`.`uli_id` AS `uli_id`,
  `dswd_4ps_tuloy_dev`.`vmb`.`first_name` AS `first_name`,
  `dswd_4ps_tuloy_dev`.`vmb`.`middle_name` AS `middle_name`,
  `dswd_4ps_tuloy_dev`.`vmb`.`last_name` AS `last_name`,
  `m`.`mm_first_name` AS `mm_first_name`,
  `m`.`mm_middle_name` AS `mm_middle_name`,
  `m`.`mm_last_name` AS `mm_last_name`,
  `dswd_4ps_tuloy_dev`.`vmb`.`region_name` AS `region_name`,
  `dswd_4ps_tuloy_dev`.`vmb`.`province_name` AS `province_name`,
  `dswd_4ps_tuloy_dev`.`vmb`.`city_name` AS `city_name`,
  `dswd_4ps_tuloy_dev`.`vmb`.`barangay_name` AS `barangay_name`,
  JSON_OBJECT(
    'diploma', JSON_OBJECT(
      'program_name', `m`.`diploma`->>'$.program_name',
      'date_enrolled', CAST(`m`.`diploma`->>'$.date_enrolled' AS DATE),
      'program_duration', CAST(`m`.`diploma`->>'$.program_duration' AS UNSIGNED),
      'academic_year', `m`.`diploma`->>'$.academic_year',
      'year_level', CAST(`m`.`diploma`->>'$.year_level' AS UNSIGNED),
      'semester', CAST(`m`.`diploma`->>'$.semester' AS UNSIGNED),
      'enrollment_status', `m`.`diploma`->>'$.enrollment_status',
      'date_encoded', CAST(`m`.`diploma`->>'$.date_encoded' AS DATETIME),
      'date_updated', CAST(`m`.`diploma`->>'$.date_updated' AS DATETIME)
    ),
    'short_course', JSON_OBJECT(
      'program_name', `m`.`short_course`->>'$.program_name',
      'start_date', CAST(`m`.`short_course`->>'$.start_date' AS DATE),
      'end_date', CAST(`m`.`short_course`->>'$.end_date' AS DATE),
      'training_status', `m`.`short_course`->>'$.training_status',
      'enrollment_status', `m`.`short_course`->>'$.enrollment_status',
      'date_encoded', CAST(`m`.`short_course`->>'$.date_encoded' AS DATETIME),
      'date_updated', CAST(`m`.`short_course`->>'$.date_updated' AS DATETIME)
    )
  ) AS `enrollment_details`,
  `m`.`created_at` AS `created_at`,
  `m`.`updated_at` AS `updated_at`
from
  (
    `dswd_4ps_tuloy_dev`.`enroll_matched_TESDA_tbl` `m`
    left join `dswd_4ps_tuloy_dev`.`vw_verify_member_bene` `vmb` on(
      (
        `dswd_4ps_tuloy_dev`.`vmb`.`member_id` = `m`.`member_id`
      )
    )
  );
