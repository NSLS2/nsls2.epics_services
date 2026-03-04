phoebus_web_runtime_service
===========================

Install the Phoebus Web Runtime services (PVWS and DBWR) into Tomcat.

**Installation location:**
`/usr/share/tomcat` (configurable via `tomcat_dest`)

**Startup scripts:**
`systemctl start tomcat`


Dependencies
------------

- `nsls2.epics_services.jdk_dependency` (included automatically)
- `nsls2.epics_services.tomcat_dependency` (included automatically)
- `nsls2.epics_services.maven_dependency` (included automatically)

Role Variables
--------------

| Variable | Type | Description |
| --- | --- | --- |
| `tomcat_dest` | string | Tomcat installation directory (default: `/usr/share/tomcat`). |
| `tomcat_service_name` | string | Systemd service name for Tomcat (default: `tomcat`). |
| `pvws_repo` | string | Git repository URL for PVWS (default: GitHub CSS). |
| `pvws_version` | string | Git ref to checkout for PVWS (default: `main`). |
| `pvws_dest` | string | Clone destination for PVWS (default: `/opt/css/pvws`). |
| `dbwr_repo` | string | Git repository URL for DBWR (default: GitHub CSS). |
| `dbwr_version` | string | Git ref to checkout for DBWR (default: `main`). |
| `dbwr_dest` | string | Clone destination for DBWR (default: `/opt/css/dbwr`). |
| `epics_ca_addr_list` | string | EPICS Channel Access address list (default: `localhost`). |
| `epics_ca_max_array_bytes` | int | EPICS CA max array bytes (default: `1000000`). |
