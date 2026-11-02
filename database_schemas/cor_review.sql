CREATE TABLE `cor_review` (
  `agency` varchar(5) NOT NULL,
  `source_id` bigint unsigned NOT NULL,
  `course_kind` varchar(12) NOT NULL,
  `revision` int unsigned NOT NULL DEFAULT '0',
  `decision` varchar(8) DEFAULT NULL,
  `source_sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  PRIMARY KEY (`agency`,`source_id`,`course_kind`),
  CONSTRAINT `ck_cor_decision` CHECK ((((`revision` = 0) and (`decision` is null) and (`source_sha256` is null)) or ((`revision` > 0) and (`decision` in (_utf8mb4'APPROVED',_utf8mb4'DENIED')) and (`source_sha256` is not null)))),
  CONSTRAINT `ck_cor_source` CHECK ((((`agency` = _utf8mb4'CHED') and (`course_kind` = _utf8mb4'degree')) or ((`agency` = _utf8mb4'TESDA') and (`course_kind` in (_utf8mb4'diploma',_utf8mb4'short_course')))))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
