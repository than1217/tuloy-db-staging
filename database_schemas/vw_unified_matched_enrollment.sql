CREATE VIEW `vw_unified_matched_enrollment` AS
select
  'CHED' AS `agency_name`,
  `c`.`tuloy_id` AS `tuloy_id`,
  `c`.`match_id` AS `match_id`,
  `c`.`enrollment_id` AS `enrollment_id`,
  `c`.`member_id` AS `member_id`,
  `c`.`student_id` AS `agency_student_uli_id`,
  `c`.`mm_first_name` AS `mm_first_name`,
  `c`.`mm_middle_name` AS `mm_middle_name`,
  `c`.`mm_last_name` AS `mm_last_name`,
  'Degree' AS `course_type`,
  `c`.`degree_program_name` AS `program_name`,
  `c`.`degree_date_enrolled` AS `date_enrolled`,
  json_object(
    'program_duration', `c`.`degree_program_duration`,
    'academic_year', `c`.`degree_academic_year`,
    'year_level', `c`.`degree_year_level`,
    'semester', `c`.`degree_semester`
  ) AS `enrollment_details`,
  `c`.`enrollment_status` AS `enrollment_status`,
  `c`.`date_encoded` AS `date_encoded`,
  `c`.`date_updated` AS `date_updated`,
  `c`.`created_at` AS `created_at`,
  `c`.`updated_at` AS `updated_at`
from
  `dswd_4ps_tuloy_dev`.`enroll_matched_CHED_tbl` `c`
union all
select
  'TESDA' AS `agency_name`,
  `t`.`tuloy_id` AS `tuloy_id`,
  `t`.`match_id` AS `match_id`,
  `t`.`enrollment_id` AS `enrollment_id`,
  `t`.`member_id` AS `member_id`,
  `t`.`uli_id` AS `agency_student_uli_id`,
  `t`.`mm_first_name` AS `mm_first_name`,
  `t`.`mm_middle_name` AS `mm_middle_name`,
  `t`.`mm_last_name` AS `mm_last_name`,
  'Diploma' AS `course_type`,
  json_unquote(json_extract(`t`.`diploma`, '$.program_name')) AS `program_name`,
  cast(
    json_unquote(json_extract(`t`.`diploma`, '$.date_enrolled')) as date
  ) AS `date_enrolled`,
  json_object(
    'program_duration', cast(json_unquote(json_extract(`t`.`diploma`, '$.program_duration')) as unsigned),
    'academic_year', json_unquote(json_extract(`t`.`diploma`, '$.academic_year')),
    'year_level', cast(json_unquote(json_extract(`t`.`diploma`, '$.year_level')) as unsigned),
    'semester', cast(json_unquote(json_extract(`t`.`diploma`, '$.semester')) as unsigned)
  ) AS `enrollment_details`,
  json_unquote(
    json_extract(`t`.`diploma`, '$.enrollment_status')
  ) AS `enrollment_status`,
  cast(
    json_unquote(json_extract(`t`.`diploma`, '$.date_encoded')) as datetime
  ) AS `date_encoded`,
  cast(
    json_unquote(json_extract(`t`.`diploma`, '$.date_updated')) as datetime
  ) AS `date_updated`,
  `t`.`created_at` AS `created_at`,
  `t`.`updated_at` AS `updated_at`
from
  `dswd_4ps_tuloy_dev`.`enroll_matched_TESDA_tbl` `t`
where
  (`t`.`diploma` is not null)
union all
select
  'TESDA' AS `agency_name`,
  `t`.`tuloy_id` AS `tuloy_id`,
  `t`.`match_id` AS `match_id`,
  `t`.`enrollment_id` AS `enrollment_id`,
  `t`.`member_id` AS `member_id`,
  `t`.`uli_id` AS `agency_student_uli_id`,
  `t`.`mm_first_name` AS `mm_first_name`,
  `t`.`mm_middle_name` AS `mm_middle_name`,
  `t`.`mm_last_name` AS `mm_last_name`,
  'Short Course' AS `course_type`,
  json_unquote(
    json_extract(`t`.`short_course`, '$.program_name')
  ) AS `program_name`,
  cast(
    json_unquote(json_extract(`t`.`short_course`, '$.start_date')) as date
  ) AS `date_enrolled`,
  json_object(
    'date_ended', cast(json_unquote(json_extract(`t`.`short_course`, '$.end_date')) as date)
  ) AS `enrollment_details`,
  json_unquote(
    json_extract(`t`.`short_course`, '$.training_status')
  ) AS `enrollment_status`,
  cast(
    json_unquote(
      json_extract(`t`.`short_course`, '$.date_encoded')
    ) as datetime
  ) AS `date_encoded`,
  cast(
    json_unquote(
      json_extract(`t`.`short_course`, '$.date_updated')
    ) as datetime
  ) AS `date_updated`,
  `t`.`created_at` AS `created_at`,
  `t`.`updated_at` AS `updated_at`
from
  `dswd_4ps_tuloy_dev`.`enroll_matched_TESDA_tbl` `t`
where
  (`t`.`short_course` is not null)