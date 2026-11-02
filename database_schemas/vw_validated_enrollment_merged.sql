CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vw_validated_enrollment_merged` AS WITH `UniqueTuloy` AS
  (SELECT `enroll_matched_CHED_tbl`.`tuloy_id` AS `tuloy_id`
   FROM `enroll_matched_CHED_tbl`
   WHERE (`enroll_matched_CHED_tbl`.`tuloy_id` IS NOT NULL)
   UNION SELECT `enroll_matched_TESDA_tbl`.`tuloy_id` AS `tuloy_id`
   FROM `enroll_matched_TESDA_tbl`
   WHERE (`enroll_matched_TESDA_tbl`.`tuloy_id` IS NOT NULL))
SELECT `pa`.`agency_alias` AS `agency_alias`,`ut`.`tuloy_id` AS `tuloy_id`,
  coalesce(`c`.`match_id`, `t`.`match_id`) AS `match_id`,coalesce(
                                                           `c`.`member_id`,
                                                           `t`.`member_id`) AS `member_id`
FROM (((`UniqueTuloy` `ut`
        LEFT JOIN `enroll_matched_CHED_tbl` `c` on((`c`.`tuloy_id` = `ut`.`tuloy_id`)))
       LEFT JOIN `enroll_matched_TESDA_tbl` `t` on((`t`.`tuloy_id` = `ut`.`tuloy_id`)))
      LEFT JOIN `lib_partner_agency` `pa` on((`pa`.`agency_id` = (CASE
                                                                      WHEN (`c`.`tuloy_id` IS NOT NULL) THEN 1 ELSE 2
                                                                  END))));
