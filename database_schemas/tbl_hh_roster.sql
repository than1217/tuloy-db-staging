CREATE TABLE `tbl_hh_roster` (
  `hh_roster_id` int unsigned NOT NULL AUTO_INCREMENT,
  `household_id` int unsigned NOT NULL COMMENT 'Foreign Key of Household.',
  `person_id` int unsigned NOT NULL COMMENT 'Foreign Key of Person.',
  `rel_hh_id` int unsigned NOT NULL COMMENT 'Foreign Key of Relation to Head. Represents the relation between the household roster member in reference to the household head.',
  `roster_status_id` int unsigned DEFAULT NULL COMMENT 'Foreign Key of Roster Status. Represents the current status of the roster member.',
  PRIMARY KEY (`hh_roster_id`) USING BTREE,
  KEY `rel_hh_id` (`rel_hh_id`) USING BTREE,
  KEY `roster_status_id` (`roster_status_id`) USING BTREE,
  KEY `idx_person_hh_covering` (`person_id`,`household_id`,`rel_hh_id`,`roster_status_id`) USING BTREE,
  KEY `idx_hh_person_covering` (`household_id`,`person_id`,`rel_hh_id`,`roster_status_id`) USING BTREE,
  KEY `idx_person_id` (`person_id`),
  KEY `idx_household_id` (`household_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='Table of Household Roster. This is an associative table containing data from Household and Person tables.';
