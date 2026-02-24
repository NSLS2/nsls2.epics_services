aa_logging
==========

Deploys custom Log4j2 logging configuration for the
[EPICS Archiver Appliance](https://github.com/archiver-appliance/epicsarchiverap).

Configures rolling file appenders with size and time-based rotation, automatic
cleanup of old log files, and per-service log directories.

What it does
------------
- Creates per-service log directories under the configured log base directory
  (mgmt, engine, etl, retrieval)
- Deploys a `log4j2.xml` configuration file into each service's
  `WEB-INF/classes/` directory
- Sets correct ownership and permissions on all log directories

Dependencies
------------
- `aa_deploy` (the deploy directory must exist and contain deployed webapps
  before logging can be configured)

Depended on by
--------------
- `aa_deploy` (includes this role conditionally when `aa_configure_custom_logs`
  is true)

Role Variables
--------------

This role has no defaults of its own. All variables are expected to be provided
by the calling orchestrator role.

| Variable | Type | Description |
| --- | --- | --- |
| `aa_logs_base_dir` | string | Base directory for log files (e.g. `/var/log/archiver-appliance`). |
| `aa_deploy_location` | string | Root of the deployed Tomcat instances (log4j2.xml is placed inside each webapp). |
| `epics_services_account` | string | OS user/group that owns log files. |
