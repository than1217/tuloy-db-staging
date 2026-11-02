CREATE TABLE `lib_partner_agency` (
  `agency_id` int unsigned NOT NULL AUTO_INCREMENT,
  `agency_name` varchar(100) NOT NULL,
  `agency_alias` varchar(20) NOT NULL,
  PRIMARY KEY (`agency_id`),
  KEY `idx_agency_alias` (`agency_alias`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
