CREATE TABLE `bcmd_approval` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `gate_code` varchar(24) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `decision` varchar(8) NOT NULL,
  `approver_role` varchar(24) NOT NULL,
  `approver_label` varchar(64) NOT NULL,
  `reference` varchar(120) NOT NULL,
  `approved_on` date NOT NULL,
  `artifact_sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `recorded_at` timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `ix_bcmd_approval_gate` (`gate_code`,`id`),
  CONSTRAINT `ck_bcmd_approval_artifact` CHECK (((`gate_code` = _utf8mb4'PAYROLL_SEPARATION') or (`artifact_sha256` is not null))),
  CONSTRAINT `ck_bcmd_approval_decision` CHECK ((`decision` in (_utf8mb4'APPROVED',_utf8mb4'REVOKED'))),
  CONSTRAINT `ck_bcmd_approval_gate` CHECK ((`gate_code` in (_utf8mb4'HEADER_FORMAT',_utf8mb4'COLUMN_MAPPING',_utf8mb4'DQA_RULES',_utf8mb4'DPO_DISCLOSURE',_utf8mb4'PAYROLL_SEPARATION'))),
  CONSTRAINT `ck_bcmd_approval_role` CHECK ((((`gate_code` = _utf8mb4'HEADER_FORMAT') and (`approver_role` = _utf8mb4'BCMD_OWNER')) or ((`gate_code` = _utf8mb4'COLUMN_MAPPING') and (`approver_role` in (_utf8mb4'DBA',_utf8mb4'DATA_OWNER'))) or ((`gate_code` = _utf8mb4'DQA_RULES') and (`approver_role` = _utf8mb4'BCMD_OWNER')) or ((`gate_code` = _utf8mb4'DPO_DISCLOSURE') and (`approver_role` = _utf8mb4'DPO')) or ((`gate_code` = _utf8mb4'PAYROLL_SEPARATION') and (`approver_role` = _utf8mb4'MARTIN'))))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
