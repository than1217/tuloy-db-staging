#!/usr/bin/env python3
"""
Import matched CHED records from 'CHED-Matching result - WITH EXISTING HHID.csv'
into the MySQL `enroll_matched_CHED_tbl` table.

Features:
- Disables FOREIGN_KEY_CHECKS for the session so `enrollment_id = 0` can be inserted
- Sets `mothers_maiden_first_name`, `mothers_maiden_middle_name`, `mothers_maiden_last_name` to NULL
- Uses `csv.reader` (index-based) to safely handle duplicate 'Region'/'REGION' headers in the CSV
- Truncates `degree_program_name` to 150 chars by default to match `varchar(150)`
  (or pass `--widen-degree-column` to `ALTER TABLE ... MODIFY degree_program_name VARCHAR(255)`)
- Supports both `mysql-connector-python` and `PyMySQL`
- Supports `--dry-run` to validate CSV parsing and row mapping before connecting to MySQL
"""

from __future__ import annotations

import argparse
import csv
import os
import sys
import time
from pathlib import Path
from typing import Any, Iterator

DEFAULT_CSV_PATH = Path(__file__).resolve().parent / "CHED-Matching result - WITH EXISTING HHID.csv"

INSERT_SQL = """
INSERT INTO `enroll_matched_CHED_tbl` (
    `match_id`,
    `enrollment_id`,
    `pppp_member_id`,
    `member_id`,
    `student_id`,
    `mothers_maiden_first_name`,
    `mothers_maiden_middle_name`,
    `mothers_maiden_last_name`,
    `degree_program_name`,
    `degree_date_enrolled`,
    `degree_program_duration`,
    `degree_academic_year`,
    `degree_year_level`,
    `degree_semester`,
    `enrollment_status`,
    `date_encoded`,
    `date_updated`
) VALUES (
    %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s
)
"""


def get_mysql_connection(
    host: str,
    port: int,
    user: str,
    password: str,
    database: str,
) -> Any:
    """Connect to MySQL using mysql-connector-python or PyMySQL."""
    try:
        import mysql.connector  # type: ignore

        return mysql.connector.connect(
            host=host,
            port=port,
            user=user,
            password=password,
            database=database,
            charset="utf8mb4",
            autocommit=False,
        )
    except ImportError:
        pass

    try:
        import pymysql  # type: ignore

        return pymysql.connect(
            host=host,
            port=port,
            user=user,
            password=password,
            database=database,
            charset="utf8mb4",
            autocommit=False,
        )
    except ImportError as exc:
        raise RuntimeError(
            "Neither 'mysql-connector-python' nor 'PyMySQL' is installed. "
            "Install one with: pip install mysql-connector-python"
        ) from exc


def iter_mapped_rows(
    csv_path: Path,
    max_degree_len: int | None = 150,
    enrollment_status: str | None = None,
) -> Iterator[tuple[Any, ...]]:
    """Read CSV rows and yield parameter tuples for `enroll_matched_CHED_tbl`."""
    with csv_path.open("r", encoding="utf-8-sig", newline="") as f:
        reader = csv.reader(f)
        try:
            header = next(reader)
        except StopIteration as exc:
            raise ValueError(f"CSV file is empty: {csv_path}") from exc

        def find_col(name: str, required: bool = True) -> int | None:
            for idx, col in enumerate(header):
                if col.strip() == name:
                    return idx
            if required:
                raise KeyError(f"Required column '{name}' not found in CSV header: {header}")
            return None

        idx_entry_id = find_col("Entry_id")
        idx_dswd_member_id = find_col("dswd_member_id", required=False)
        idx_degree_program = find_col("Degree Program")
        idx_academic_year = find_col("Academic Year")
        idx_year_level = find_col("Year level")
        idx_match_result = find_col("Matching Result Concat", required=False)

        assert idx_entry_id is not None
        assert idx_degree_program is not None
        assert idx_academic_year is not None
        assert idx_year_level is not None

        for line_num, row in enumerate(reader, start=2):
            if not row:
                continue

            # Skip any 'Not Match' rows if present
            if idx_match_result is not None and row[idx_match_result].strip().lower() == "not match":
                continue

            raw_entry_id = row[idx_entry_id].strip()
            if not raw_entry_id:
                raise ValueError(f"Line {line_num}: Missing Entry_id")
            member_id = int(raw_entry_id)

            if idx_dswd_member_id is not None and idx_dswd_member_id < len(row) and row[idx_dswd_member_id].strip():
                pppp_member_id = row[idx_dswd_member_id].strip()
            else:
                pppp_member_id = f"4ps-{member_id}"

            degree_program = row[idx_degree_program].strip() or None
            if degree_program and max_degree_len is not None and len(degree_program) > max_degree_len:
                degree_program = degree_program[:max_degree_len]

            academic_year = row[idx_academic_year].strip() or None

            raw_year_level = row[idx_year_level].strip()
            degree_year_level = int(raw_year_level) if raw_year_level else None

            yield (
                None,               # match_id
                0,                  # enrollment_id (0 with FK checks disabled)
                pppp_member_id,     # pppp_member_id ('4ps-' + Entry_id)
                member_id,          # member_id (Entry_id)
                None,               # student_id
                None,               # mothers_maiden_first_name
                None,               # mothers_maiden_middle_name
                None,               # mothers_maiden_last_name
                degree_program,     # degree_program_name
                None,               # degree_date_enrolled
                None,               # degree_program_duration
                academic_year,      # degree_academic_year
                degree_year_level,  # degree_year_level
                None,               # degree_semester
                enrollment_status,  # enrollment_status
                None,               # date_encoded
                None,               # date_updated
            )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Import CHED matched CSV into MySQL enroll_matched_CHED_tbl."
    )
    parser.add_argument(
        "--csv-file",
        type=Path,
        default=DEFAULT_CSV_PATH,
        help=f"Path to CSV file (default: {DEFAULT_CSV_PATH.name})",
    )
    parser.add_argument("--host", default=os.getenv("DB_HOST", "127.0.0.1"), help="MySQL host")
    parser.add_argument("--port", type=int, default=int(os.getenv("DB_PORT", "3306")), help="MySQL port")
    parser.add_argument("--user", default=os.getenv("DB_USER", "root"), help="MySQL user")
    parser.add_argument("--password", default=os.getenv("DB_PASSWORD", ""), help="MySQL password")
    parser.add_argument(
        "--database",
        default=os.getenv("DB_DATABASE") or os.getenv("DB_NAME", ""),
        help="MySQL database name",
    )
    
    # SSH Tunnel arguments
    parser.add_argument("--ssh-host", default=os.getenv("SSH_HOST", ""), help="SSH Host for tunneling")
    parser.add_argument("--ssh-port", type=int, default=int(os.getenv("SSH_PORT", "22")), help="SSH Port")
    parser.add_argument("--ssh-user", default=os.getenv("SSH_USER", ""), help="SSH Username")
    parser.add_argument("--ssh-password", default=os.getenv("SSH_PASSWORD", ""), help="SSH Password")
    parser.add_argument("--ssh-pkey", default=os.getenv("SSH_PKEY", ""), help="SSH Private Key path")
    parser.add_argument(
        "--batch-size",
        type=int,
        default=5000,
        help="Number of rows per batch INSERT (default: 5000)",
    )
    parser.add_argument(
        "--enrollment-status",
        default=None,
        help="Optional constant value for enrollment_status column (default: NULL)",
    )
    parser.add_argument(
        "--widen-degree-column",
        action="store_true",
        help="Alter degree_program_name to VARCHAR(255) before importing instead of truncating to 150 chars",
    )
    parser.add_argument(
        "--truncate-table",
        action="store_true",
        help="Truncate enroll_matched_CHED_tbl before inserting rows",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Parse and validate all CSV rows without connecting to MySQL",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    if not args.csv_file.is_file():
        print(f"Error: CSV file not found: {args.csv_file}", file=sys.stderr)
        return 1

    max_degree_len = None if args.widen_degree_column else 150

    if args.dry_run:
        start = time.perf_counter()
        count = 0
        sample: tuple[Any, ...] | None = None
        for row in iter_mapped_rows(
            args.csv_file,
            max_degree_len=max_degree_len,
            enrollment_status=args.enrollment_status,
        ):
            if sample is None:
                sample = row
            count += 1
        elapsed = time.perf_counter() - start
        print(f"[DRY RUN] Validated {count:,} rows in {elapsed:.2f}s.")
        if sample is not None:
            print(f"[DRY RUN] Sample mapped tuple:\n  {sample}")
        return 0

    if not args.database:
        print(
            "Error: Database name is required (--database or DB_NAME env var).",
            file=sys.stderr,
        )
        return 1

    import contextlib

    if args.ssh_host:
        from sshtunnel import SSHTunnelForwarder
        tunnel_kwargs = {
            'ssh_address_or_host': (args.ssh_host, args.ssh_port),
            'ssh_username': args.ssh_user,
            'remote_bind_address': (args.host, args.port)
        }
        if args.ssh_password:
            tunnel_kwargs['ssh_password'] = args.ssh_password
        if args.ssh_pkey:
            tunnel_kwargs['ssh_pkey'] = args.ssh_pkey
            
        tunnel_context = SSHTunnelForwarder(**tunnel_kwargs)
    else:
        tunnel_context = contextlib.nullcontext()

    with tunnel_context as tunnel:
        db_host = args.host
        db_port = args.port
        if tunnel:
            db_host = '127.0.0.1'
            db_port = tunnel.local_bind_port
            print(f"SSH Tunnel established on local port {db_port}.")

        conn = get_mysql_connection(
            host=db_host,
            port=db_port,
            user=args.user,
            password=args.password,
            database=args.database,
        )

        cursor = conn.cursor()
        total_inserted = 0
        start = time.perf_counter()

        try:
            cursor.execute("SET FOREIGN_KEY_CHECKS = 0;")

            if args.widen_degree_column:
                print("Altering degree_program_name column to VARCHAR(255)...")
                cursor.execute(
                    "ALTER TABLE `enroll_matched_CHED_tbl` "
                    "MODIFY COLUMN `degree_program_name` VARCHAR(255) DEFAULT NULL;"
                )

            if args.truncate_table:
                print("Truncating enroll_matched_CHED_tbl...")
                cursor.execute("TRUNCATE TABLE `enroll_matched_CHED_tbl`;")

            batch: list[tuple[Any, ...]] = []
            for row in iter_mapped_rows(
                args.csv_file,
                max_degree_len=max_degree_len,
                enrollment_status=args.enrollment_status,
            ):
                batch.append(row)
                if len(batch) >= args.batch_size:
                    cursor.executemany(INSERT_SQL, batch)
                    conn.commit()
                    total_inserted += len(batch)
                    print(f"Inserted {total_inserted:,} rows...")
                    batch.clear()

            if batch:
                cursor.executemany(INSERT_SQL, batch)
                conn.commit()
                total_inserted += len(batch)
                batch.clear()

            elapsed = time.perf_counter() - start
            print(f"Successfully imported {total_inserted:,} rows into enroll_matched_CHED_tbl in {elapsed:.2f}s.")
            return 0

        except Exception:
            conn.rollback()
            raise
        finally:
            try:
                cursor.execute("SET FOREIGN_KEY_CHECKS = 1;")
            except Exception:
                pass
            cursor.close()
            conn.close()

if __name__ == "__main__":
    sys.exit(main())
