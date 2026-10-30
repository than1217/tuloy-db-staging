CREATE OR REPLACE VIEW `vw_verify_member_bene` AS
SELECT
  `p`.`first_name` AS `first_name`,
  `p`.`middle_name` AS `middle_name`,
  `p`.`last_name` AS `last_name`,
  `p`.`date_of_birth` AS `date_of_birth`,
  `p`.`sex_id` AS `sex_id`,
  `p`.`person_id` AS `member_id`,
  `h`.`listahanan_id` AS `listahanan_id`,
  `p`.`lrn` AS `lrn`,
  `p`.`phil_id` AS `philsys`,
  `gl`.`name` AS `grade_level`,
  `g`.`maiden_name` AS `m_maiden_name`,
  `bgy`.`psa_code` AS `bgy_psgc_code`,
  `psgc`.`region_name` AS `region_name`,
  `psgc`.`province_name` AS `province_name`,
  `psgc`.`city_name` AS `city_name`,
  `bgy`.`name` AS `barangay_name`,
  `cs`.`name` AS `client_status`,
  `rs`.`name` AS `roster_status`,
  concat('4Ps-', `p`.`person_id`) AS `tuloy_id`,
  `p`.`match_key` AS `match_keys`
FROM `tbl_person` `p`
LEFT JOIN `tbl_hh_roster` `r` ON `r`.`person_id` = `p`.`person_id`
LEFT JOIN `tbl_household` `h` ON `h`.`household_id` = `r`.`household_id`
LEFT JOIN `tbl_beneficiary` `b` ON `b`.`household_id` = `r`.`household_id`
LEFT JOIN `lib_grade_level` `gl` ON `gl`.`grade_level_id` = `p`.`grade_level_id`
LEFT JOIN `lib_psgc_barangay` `bgy` ON `bgy`.`barangay_id` = `h`.`barangay_id`
LEFT JOIN `lib_psgc_denorm` `psgc` ON `bgy`.`barangay_id` = `psgc`.`barangay_id`
LEFT JOIN `lib_client_status` `cs` ON `cs`.`client_status_id` = `b`.`client_status_id`
LEFT JOIN `lib_roster_status` `rs` ON `rs`.`roster_status_id` = `r`.`roster_status_id`
WHERE `b`.`client_status_id` IN (1, 3, 14, 15, 19, 28)
  AND `gl`.`grade_level_id` IN (13, 14, 15, 16, 22, 23, 24, 28, 29)
  AND `p`.`date_of_birth` > (CURDATE() - INTERVAL 31 YEAR)
  AND `p`.`date_of_birth` <= (CURDATE() - INTERVAL 18 YEAR);
