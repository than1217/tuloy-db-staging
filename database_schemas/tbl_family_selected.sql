CREATE TABLE `tbl_family_selected` (
  `id` int NOT NULL AUTO_INCREMENT,
  `household_id` int DEFAULT NULL COMMENT 'FK tbl_household',
  `hh_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `hh_set` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `family_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_household_hhid` (`household_id`,`hh_id`),
  KEY `family_id` (`family_id`)
) ENGINE=InnoDB AUTO_INCREMENT=40884748 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
