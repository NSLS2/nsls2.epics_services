aa_mysql_dependency
===================

Installs and configures a local MariaDB instance for the
[EPICS Archiver Appliance](https://github.com/archiver-appliance/epicsarchiverap).

Uses unix socket authentication so no pre-existing root password is required.

What it does
------------
- Installs PyMySQL (Python MySQL client library for Ansible modules)
- Installs `mariadb-server` and `mariadb` client via RPM
- Starts and enables the MariaDB systemd service
- Waits for the MariaDB socket to become available
- Sets the MySQL root password idempotently (using socket auth with
  `check_implicit_admin`)
- Creates the Archiver Appliance database
- Creates the application database user and grants privileges

Dependencies
------------
None.

Depended on by
--------------
- `aa_service` (single-instance orchestrator)
- `aa_cluster_service` (cluster orchestrator)

Role Variables
--------------

This role has no defaults of its own. All variables are expected to be provided
by the calling orchestrator role.

| Variable | Type | Description |
| --- | --- | --- |
| `aa_mysql_database` | string | Database name to create (e.g. `tst_archappl`). |
| `aa_mysql_user` | string | Application database user. |
| `aa_mysql_password` | string | Application database user password. |
| `aa_mysql_root_password` | string | *(Optional)* Root password. Defaults to `aa_mysql_password` if not set. |
