aa_dependency
=============

Installs system-level dependencies required by the
[EPICS Archiver Appliance](https://github.com/archiver-appliance/epicsarchiverap):
Tomcat (with Tomcat Native) and the MySQL JDBC connector.

All packages are installed from RPM repositories. The MySQL connector is
downloaded from the MySQL CDN.

JDK 17 is installed separately via the `jdk_dependency` role.

What it does
------------
- Installs Tomcat and Tomcat Native via RPM
- Creates the dependencies directory and downloads the MySQL connector JAR

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
| `aa_dependencies_loc` | string | Directory to store downloaded dependencies (e.g. `/tmp/aa_tst_dependencies`). |
| `epics_services_account` | string | OS user/group that owns dependency files. |
