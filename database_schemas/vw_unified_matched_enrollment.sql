CREATE VIEW `vw_unified_matched_enrollment` AS
WITH unmatched_tesda AS (
  select `t`.* 
  from `dswd_4ps_tuloy_dev`.`enroll_matched_TESDA_tbl` `t`
  where not exists (
    select 1
    from `dswd_4ps_tuloy_dev`.`enroll_matched_CHED_tbl` `c`
    where `c`.`tuloy_id` = `t`.`tuloy_id`
  )
)
select
  'CHED' AS `agency_name`,
  `c`.`tuloy_id` AS `tuloy_id`,
  `c`.`member_id` AS `member_id`,
  `c`.`mm_first_name` AS `mm_first_name`,
  `c`.`mm_middle_name` AS `mm_middle_name`,
  `c`.`mm_last_name` AS `mm_last_name`,
  json_object(
    'degree', json_object(
      'student_id', `c`.`student_id`,
      'course_type', 'Degree',
      'program_name', `c`.`degree_program_name`,
      'date_enrolled', `c`.`degree_date_enrolled`,
      'program_duration', `c`.`degree_program_duration`,
      'academic_year', `c`.`degree_academic_year`,
      'year_level', `c`.`degree_year_level`,
      'semester', `c`.`degree_semester`,
      'enrollment_status', `c`.`enrollment_status`,
      'date_encoded', `c`.`date_encoded`,
      'date_updated', `c`.`date_updated`
    )
  ) AS `enrollment_details`,
  `c`.`created_at` AS `created_at`,
  `c`.`updated_at` AS `updated_at`
from
  `dswd_4ps_tuloy_dev`.`enroll_matched_CHED_tbl` `c`
union all
select
  'TESDA' AS `agency_name`,
  `t`.`tuloy_id` AS `tuloy_id`,
  `t`.`member_id` AS `member_id`,
  `t`.`mm_first_name` AS `mm_first_name`,
  `t`.`mm_middle_name` AS `mm_middle_name`,
  `t`.`mm_last_name` AS `mm_last_name`,
  json_object(
    'diploma', json_object(
      'uli_id', `t`.`uli_id`,
      'course_type', 'Diploma',
      'program_name', json_unquote(json_extract(`t`.`diploma`, '$.program_name')),
      'date_enrolled', cast(json_unquote(json_extract(`t`.`diploma`, '$.date_enrolled')) as date),
      'program_duration', cast(json_unquote(json_extract(`t`.`diploma`, '$.program_duration')) as unsigned),
      'academic_year', json_unquote(json_extract(`t`.`diploma`, '$.academic_year')),
      'year_level', cast(json_unquote(json_extract(`t`.`diploma`, '$.year_level')) as unsigned),
      'semester', cast(json_unquote(json_extract(`t`.`diploma`, '$.semester')) as unsigned),
      'enrollment_status', json_unquote(json_extract(`t`.`diploma`, '$.enrollment_status')),
      'date_encoded', cast(json_unquote(json_extract(`t`.`diploma`, '$.date_encoded')) as datetime),
      'date_updated', cast(json_unquote(json_extract(`t`.`diploma`, '$.date_updated')) as datetime)
    )
  ) AS `enrollment_details`,
  `t`.`created_at` AS `created_at`,
  `t`.`updated_at` AS `updated_at`
from
  `unmatched_tesda` `t`
where
  (`t`.`diploma` is not null)
union all
select
  'TESDA' AS `agency_name`,
  `t`.`tuloy_id` AS `tuloy_id`,
  `t`.`member_id` AS `member_id`,
  `t`.`mm_first_name` AS `mm_first_name`,
  `t`.`mm_middle_name` AS `mm_middle_name`,
  `t`.`mm_last_name` AS `mm_last_name`,
  json_object(
    'short_course', json_object(
      'uli_id', `t`.`uli_id`,
      'course_type', 'Short Course',
      'program_name', json_unquote(json_extract(`t`.`short_course`, '$.program_name')),
      'date_enrolled', cast(json_unquote(json_extract(`t`.`short_course`, '$.start_date')) as date),
      'date_ended', cast(json_unquote(json_extract(`t`.`short_course`, '$.end_date')) as date),
      'enrollment_status', json_unquote(json_extract(`t`.`short_course`, '$.training_status')),
      'date_encoded', cast(json_unquote(json_extract(`t`.`short_course`, '$.date_encoded')) as datetime),
      'date_updated', cast(json_unquote(json_extract(`t`.`short_course`, '$.date_updated')) as datetime)
    )
  ) AS `enrollment_details`,
  `t`.`created_at` AS `created_at`,
  `t`.`updated_at` AS `updated_at`
from
  `unmatched_tesda` `t`
where
  (`t`.`short_course` is not null)