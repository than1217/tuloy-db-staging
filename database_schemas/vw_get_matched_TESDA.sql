CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vw_get_matched_TESDA` AS
SELECT `m`.`id` AS `id`,`m`.`match_id` AS `match_id`,
  `m`.`enrollment_id` AS `enrollment_id`,`m`.`tuloy_id` AS `tuloy_id`,`m`.`member_id` AS `member_id`,
  `m`.`uli_id` AS `uli_id`,`vmb`.`first_name` AS `first_name`,`vmb`.`middle_name` AS `middle_name`,
  `vmb`.`last_name` AS `last_name`,`m`.`mm_first_name` AS `mm_first_name`,
  `m`.`mm_middle_name` AS `mm_middle_name`,`m`.`mm_last_name` AS `mm_last_name`,`vmb`.`region_name` AS `region_name`,
  `vmb`.`province_name` AS `province_name`,`vmb`.`city_name` AS `city_name`,`vmb`.`barangay_name` AS `barangay_name`,
  json_object(
    'diploma',
    json_object(
      'program_name', json_unquote(json_extract(
                                     `m`.`diploma`, '$.program_name')),
      'date_enrolled', cast(json_unquote(json_extract(
                                           `m`.`diploma`, '$.date_enrolled')) AS date),
      'program_duration',
      cast(json_unquote(json_extract(
                          `m`.`diploma`, '$.program_duration')) AS unsigned), 'academic_year', json_unquote(json_extract(

                                                                                                              `m`.`diploma`,
                                                                                                              '$.academic_year')),
      'year_level', cast(json_unquote(json_extract(
                                        `m`.`diploma`, '$.year_level')) AS unsigned),
      'semester', cast(json_unquote(json_extract(
                                      `m`.`diploma`, '$.semester')) AS unsigned),
      'enrollment_status', json_unquote(json_extract(
                                          `m`.`diploma`, '$.enrollment_status')),
      'date_encoded',
      cast(json_unquote(json_extract(
                          `m`.`diploma`, '$.date_encoded')) AS datetime), 'date_updated',
      cast(json_unquote(json_extract(
                          `m`.`diploma`, '$.date_updated')) AS datetime)), 'short_course',
    json_object(
      'program_name',
      json_unquote(json_extract(
                     `m`.`short_course`, '$.program_name')), 'start_date',
      cast(json_unquote(json_extract(
                          `m`.`short_course`, '$.start_date')) AS date), 'end_date',
      cast(json_unquote(json_extract(
                          `m`.`short_course`, '$.end_date')) AS date), 'training_status',
      json_unquote(json_extract(
                     `m`.`short_course`, '$.training_status')), 'enrollment_status',
      json_unquote(json_extract(
                     `m`.`short_course`, '$.enrollment_status')), 'date_encoded',
      cast(json_unquote(json_extract(
                          `m`.`short_course`, '$.date_encoded')) AS datetime), 'date_updated',
      cast(json_unquote(json_extract(
                          `m`.`short_course`, '$.date_updated')) AS datetime))) AS `enrollment_details`,`m`.`created_at` AS `created_at`,`m`.`updated_at` AS `updated_at`
FROM (`enroll_matched_TESDA_tbl` `m`
      LEFT JOIN `vw_verify_member_bene` `vmb` on((`vmb`.`member_id` = `m`.`member_id`)));
