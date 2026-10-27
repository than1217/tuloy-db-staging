# tuloy-db-staging
Repository of Tuloy App DB Tables and utility scripts.

## Utility Scripts

### `import_enroll_matched_ched.py`
A script designed to import matched CHED (Commission on Higher Education) records from a CSV file (`CHED-Matching result - WITH EXISTING HHID.csv`) directly into the `enroll_matched_CHED_tbl` MySQL database table.

#### Features
- **Direct & SSH Tunnel Connections**: Connect to the database directly or route the connection through an SSH Tunnel if the database server isn't directly exposed.
- **Data Truncation**: Automatically truncates `degree_program_name` to 150 characters to fit the standard column width.
- **Schema Modification**: Optional flag to automatically expand `degree_program_name` to `VARCHAR(255)` before insertion.
- **Bulk Insert**: Configurable batch size to optimize large data imports.
- **Dry Run Validation**: Can parse and validate the entire CSV without committing changes or even connecting to the database.

#### Requirements
Install dependencies using `pip`:
```bash
pip install mysql-connector-python sshtunnel
```
*(Alternatively, `PyMySQL` is also supported for the database connector.)*

#### Usage

**Standard execution (direct connection):**
```bash
python import_enroll_matched_ched.py \
    --host 127.0.0.1 \
    --port 3306 \
    --user root \
    --password "secret" \
    --database tuloy_db
```

**Execution via SSH Tunnel:**
Use the SSH arguments to route your MySQL connection through an intermediary server:
```bash
python import_enroll_matched_ched.py \
    --ssh-host ssh-gateway.example.com \
    --ssh-user ssh_username \
    --ssh-password "ssh_secret" \
    --host 127.0.0.1 \
    --port 3306 \
    --user db_user \
    --password "db_secret" \
    --database tuloy_db
```

**Common Flags:**
- `--csv-file`: Path to a specific CSV file (Defaults to `CHED-Matching result - WITH EXISTING HHID.csv` in the same directory).
- `--dry-run`: Validates the CSV without making database changes.
- `--widen-degree-column`: Alters `degree_program_name` to `VARCHAR(255)` before insertion.
- `--truncate-table`: Clears `enroll_matched_CHED_tbl` completely before importing new data.
- `--batch-size`: Number of rows per batch INSERT (Default: 5000).

You can also use environment variables (`DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_DATABASE`, `SSH_HOST`, `SSH_PORT`, `SSH_USER`, `SSH_PASSWORD`, `SSH_PKEY`) to omit passing sensitive data via command-line arguments.
