CREATE VIEW `vw_verify_member_bene` AS select
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
    `g`.`account_no` AS `account_no`,
    `bgy`.`psa_code` AS `bgy_psgc_code`,
    `bgy`.`name` AS `barangay_name`,
    `cs`.`name` AS `client_status`,
    `rs`.`name` AS `roster_status`,
    `p`.`match_key` AS `match_keys`
from
    ((((((((`tbl_person` `p`
left join `tbl_hh_roster` `r` on
    ((`r`.`person_id` = `p`.`person_id`)))
left join `tbl_household` `h` on
    ((`h`.`household_id` = `r`.`household_id`)))
left join `tbl_beneficiary` `b` on
    ((`b`.`household_id` = `r`.`household_id`)))
left join `lib_grade_level` `gl` on
    ((`gl`.`grade_level_id` = `p`.`grade_level_id`)))
left join `tbl_grantee` `g` on
    ((`g`.`person_id` = `p`.`person_id`)))
left join `lib_psgc_barangay` `bgy` on
    ((`bgy`.`barangay_id` = `h`.`barangay_id`)))
left join `lib_client_status` `cs` on
    ((`cs`.`client_status_id` = `b`.`client_status_id`)))
left join `lib_roster_status` `rs` on
    ((`rs`.`roster_status_id` = `r`.`roster_status_id`)))
where
    ((`b`.`client_status_id` in (1, 3, 14))
        and (`r`.`roster_status_id` = 1)
        and (`gl`.`grade_level_id` in (22, 23, 24, 28, 29)));
