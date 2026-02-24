aa_dependencies
===============

Installs system-level dependencies required by the
[EPICS Archiver Appliance](https://github.com/archiver-appliance/epicsarchiverap):
OpenJDK 17, APR/SSL development libraries, Tomcat (with Tomcat Native), and the
MySQL JDBC connector.

All packages are installed from RPM repositories. The MySQL connector is
downloaded from the MySQL CDN.

What it does
------------
- Installs OpenJDK 17 (`java-17-openjdk`, `java-17-openjdk-devel`) and sets the
  `java_home_rpm` fact
- Installs APR, OpenSSL development headers, gcc, and make (needed for Tomcat
  Native / SSL)
- Installs Tomcat and Tomcat Native via RPM
- Creates the dependencies directory and downloads the MySQL connector JAR

Dependencies
------------
None.

Depended on by
--------------
- `epics_tools_services_aa` (single-instance orchestrator)
- `epics_tools_services_aa_cluster` (cluster orchestrator)

Role Variables
--------------

This role has no defaults of its own. All variables are expected to be provided
by the calling orchestrator role.

| Variable | Type | Description |
| --- | --- | --- |
| `aa_dependencies_loc` | string | Directory to store downloaded dependencies (e.g. `/tmp/aa_tst_dependencies`). |
| `epics_services_account` | string | OS user/group that owns dependency files. |
