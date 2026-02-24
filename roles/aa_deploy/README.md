aa_deploy
=========

Unified deployment role for the
[EPICS Archiver Appliance](https://github.com/archiver-appliance/epicsarchiverap).
Handles both single-instance and cluster deployments using the same task flow.

Each Archiver Appliance instance is deployed as **four separate Tomcat
processes** (mgmt, engine, etl, retrieval), each managed by its own systemd
service unit.

**Service names:**
`{{ beamline_name }}_mgmt_aa`, `{{ beamline_name }}_engine_aa`,
`{{ beamline_name }}_etl_aa`, `{{ beamline_name }}_retrieval_aa`

What it does
------------
- Creates install and deploy directories
- Stops any existing per-instance or legacy monolithic services
- Unpacks the built `archappl*.tar.gz` and MySQL connector
- Deploys configuration scripts (single_machine_install.sh,
  deployMultipleTomcats.py, addMysqlConnPool.py, policies.py)
- Deploys `appliances.xml` when cluster appliances are defined
- Runs the installation script with unified environment variables
- Deploys site-specific static content (facility_template_changes.html)
- Deploys per-instance startup scripts and systemd unit files
- Restarts and enables all four instance services
- Optionally includes `aa_logging` for custom Log4j2 configuration
- Optionally cleans up legacy monolithic service files

Dependencies
------------
- `aa_dependencies` (JDK, Tomcat, MySQL connector)
- `aa_mysql` (database must exist before deployment)
- `aa_build` (the built tar.gz must be available)
Depended on by
--------------
- `aa_service` (single-instance orchestrator)
- `aa_cluster_service` (cluster orchestrator)

Role Variables
--------------

**Defaults defined by this role** (`defaults/main.yml`):

| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| `aa_cleanup_legacy_service` | bool | `false` | When `true`, disables and removes the old monolithic `{{ beamline_name }}_aa` service and startup script. |

**Required variables** (provided by the calling orchestrator):

| Variable | Type | Description |
| --- | --- | --- |
| `beamline_name` | string | Beamline identifier, used in paths and service names. |
| `epics_services_account` | string | OS user/group that owns service files. |
| `aa_install_location` | string | Staging directory for unpacked build artifacts. |
| `aa_deploy_location` | string | Final deployment directory for running Tomcat instances. |
| `aa_build_loc` | string | Directory containing the built tar.gz. |
| `aa_dependencies_loc` | string | Directory containing downloaded dependencies. |
| `aa_java_home` | string | `JAVA_HOME` for running Tomcat. |
| `aa_tomcat_home` | string | `TOMCAT_HOME` (system RPM Tomcat location). |
| `aa_mysql_server` | string | MySQL server hostname. |
| `aa_mysql_user` | string | MySQL application user. |
| `aa_mysql_password` | string | MySQL application password. |
| `aa_mysql_database` | string | MySQL database name. |
| `aa_identity` | string | Appliance identity (e.g. `appliance0`). |
| `cluster_inetport` | string | Cluster communication port. |
| `mgmt_port` | string | Management webapp HTTP port. |
| `engine_port` | string | Engine webapp HTTP port. |
| `etl_port` | string | ETL webapp HTTP port. |
| `data_retrieval_port` | string | Data retrieval webapp HTTP port. |
| `aa_epics_ca_addr_list` | string | EPICS Channel Access address list. |
| `aa_java_opts_mgmt` | string | JVM options for the mgmt instance. |
| `aa_java_opts_engine` | string | JVM options for the engine instance. |
| `aa_java_opts_etl` | string | JVM options for the etl instance. |
| `aa_java_opts_retrieval` | string | JVM options for the retrieval instance. |
| `aa_sts` | string | Short-term storage path. |
| `aa_mts` | string | Medium-term storage path. |
| `aa_lts` | string | Long-term storage path. |
| `aa_configure_custom_logs` | bool | Include custom Log4j2 logging configuration. |
| `aa_logs_base_dir` | string | Base directory for log files. |
| `aa_data_mount_name` | string | Systemd mount dependency for data volumes (empty string if none). |

**Optional variables:**

| Variable | Type | Description |
| --- | --- | --- |
| `aa_cluster_appliances` | list | Cluster appliance definitions (triggers appliances.xml deployment). |
