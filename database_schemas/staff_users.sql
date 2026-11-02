CREATE TABLE `staff_users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `issuer` varbinary(512) NOT NULL,
  `subject` varbinary(1020) NOT NULL,
  `disabled` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_staff_identity` (`issuer`,`subject`),
  CONSTRAINT `ck_staff_identity` CHECK (((`issuer` <> _utf8mb4'') and (`subject` <> _utf8mb4'')))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
