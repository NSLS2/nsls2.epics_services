aa_service
==========

Orchestrator role for a single-instance
[EPICS Archiver Appliance](https://github.com/archiver-appliance/epicsarchiverap)
deployment. The Archiver Appliance monitors EPICS process variables and archives
their values to short-term, medium-term, and long-term storage.

It consists of four services, each running as a separate Tomcat process:

- **Management** -- web UI for configuring PVs and viewing system status
- **Engine** -- connects to EPICS PVs and writes samples to short-term storage
- **ETL** -- moves data between storage tiers (short -> medium -> long)
- **Data Retrieval** -- serves archived data to clients

Each service is managed via its own systemd unit.

**Installation location:**
`/opt/epics-tools/services/archiver_appliance/`

**Service names:**
- `{{ aa_service_prefix }}_mgmt_aa`
- `{{ aa_service_prefix }}_engine_aa`
- `{{ aa_service_prefix }}_etl_aa`
- `{{ aa_service_prefix }}_retrieval_aa`

What it does
------------
This is a thin orchestrator that delegates to composable sub-roles:

1. `aa_dependency` -- installs JDK, Tomcat, MySQL connector
2. `aa_mysql_dependency` -- installs and configures a local MariaDB instance
3. `aa_build` -- clones and builds the Archiver Appliance from source
4. `aa_deploy` -- deploys the built artifacts, configures Tomcat instances,
   installs systemd services

Dependencies
------------
None (all dependencies are handled by the sub-roles).

Depended on by
--------------
None (this is the top-level single-instance deployment role).

Role Variables
--------------

**Optional** (have defaults in `defaults/main.yml`):

| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| `epics_services_account` | string | `csstudio` | OS user that owns service files. |
| `aa_service_prefix` | string | `aa` | Prefix for systemd unit names and startup scripts. |
| `aa_site_name` | string | `Archiver Appliance` | Display name shown in the facility template header. |
| `aa_version` | string | `2.2.1` | Archiver Appliance Git tag to build. |
| `aa_tomcat_home` | string | `/usr/share/tomcat` | System Tomcat installation from RPM. |
| `aa_install_dir` | string | `/opt/epics-tools/services/archiver_appliance` | Base installation directory. |
| `aa_install_location` | string | `{{ aa_install_dir }}/install` | Staging directory for build artifacts. |
| `aa_deploy_location` | string | `{{ aa_install_dir }}/deploy` | Final deployment directory. |
| `aa_identity` | string | `appliance0` | Appliance identity. |
| `cluster_inetport` | integer | `16070` | Cluster communication port. |
| `mgmt_port` | integer | `16065` | Management webapp port. |
| `engine_port` | integer | `16066` | Engine webapp port. |
| `etl_port` | integer | `16067` | ETL webapp port. |
| `data_retrieval_port` | integer | `16068` | Data retrieval webapp port. |
| `aa_mysql_server` | string | `localhost` | MySQL server hostname. |
| `aa_mysql_database` | string | `archappl` | Database name. |
| `aa_mysql_user` | string | `archappl` | Database user. |
| `aa_mysql_password` | string | `archappl` | Database password. |
| `aa_epics_ca_addr_list` | string | `localhost` | EPICS Channel Access address list. |
| `aa_java_opts_engine` | string | `-XX:+UseG1GC -Xmx10G -Xms4G -ea` | JVM options for engine. |
| `aa_java_opts_retrieval` | string | `-XX:+UseG1GC -Xmx10G -Xms4G -ea` | JVM options for retrieval. |
| `aa_java_opts_etl` | string | `-XX:+UseG1GC -Xmx5G -Xms1G -ea` | JVM options for ETL. |
| `aa_java_opts_mgmt` | string | `-XX:+UseG1GC -Xmx5G -Xms1G -ea` | JVM options for mgmt. |
| `aa_sts` | string | `{{ aa_deploy_location }}/data/sts/ArchiverStore` | Short-term storage path. |
| `aa_mts` | string | `{{ aa_deploy_location }}/data/mts/ArchiverStore` | Medium-term storage path. |
| `aa_lts` | string | `{{ aa_deploy_location }}/data/lts/ArchiverStore` | Long-term storage path. |
| `aa_logs_base_dir` | string | `/var/log/archiver-appliance` | Log directory base path. |
| `aa_configure_custom_logs` | bool | `false` | Deploy custom Log4j2 logging configuration. |
| `aa_data_mount_name` | string | `""` | Systemd mount dependency for data volumes. |

Example Playbook
----------------

```yaml
- hosts: archiver
  roles:
    - nsls2.epics_services.aa_service
```
