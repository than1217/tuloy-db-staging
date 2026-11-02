CREATE TABLE `tbl_family_assoc_ops` (
  `fam_assoc_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key of tbl_family_assoc',
  `family_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Family ID from CBMS',
  `hh_roster_id` int unsigned DEFAULT NULL COMMENT 'Foreign key of tbl_hh_roster',
  `person_id` int unsigned NOT NULL COMMENT 'Foreign Key of Person.',
  `rel_fam_head` int unsigned DEFAULT NULL COMMENT 'Foreign key of lib_relation_to_family_head',
  `user_id` int DEFAULT NULL,
  `dt_inserted` datetime NOT NULL,
  `dt_updated` datetime DEFAULT NULL,
  `archived` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`fam_assoc_id`) USING BTREE,
  KEY `idx_tbl_family_assoc_ops_family_id` (`family_id`) USING BTREE,
  KEY `idx_tbl_family_assoc_ops_rel_fam_head` (`rel_fam_head`) USING BTREE,
  KEY `idx_tbl_family_assoc_ops_archived` (`archived`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=262857421 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
