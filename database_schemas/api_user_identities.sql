CREATE TABLE `api_user_identities` (
  `issuer` varbinary(512) NOT NULL,
  `subject` varbinary(1020) NOT NULL,
  `user_id` int NOT NULL,
  `bound_by` varchar(255) NOT NULL,
  `bound_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`issuer`,`subject`),
  UNIQUE KEY `uq_api_user_identity_user` (`user_id`,`issuer`),
  CONSTRAINT `fk_api_user_identity_user` FOREIGN KEY (`user_id`) REFERENCES `api_users` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `ck_api_user_identity_fields` CHECK (((`issuer` <> _utf8mb4'') and (`subject` <> _utf8mb4'') and (`bound_by` <> _utf8mb4'')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
