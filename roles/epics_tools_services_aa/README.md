epics_tools_services_aa
=======================

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
`/opt/epics-tools/services/{{ beamline_name }}/aa/`

**Service names:**
- `{{ beamline_name }}_mgmt_aa`
- `{{ beamline_name }}_engine_aa`
- `{{ beamline_name }}_etl_aa`
- `{{ beamline_name }}_retrieval_aa`

What it does
------------
This is a thin orchestrator that delegates to composable sub-roles:

1. `aa_dependencies` -- installs JDK, Tomcat, APR/SSL libs, MySQL connector
2. `aa_mysql` -- installs and configures a local MariaDB instance
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

**Required** (no sensible default -- must be set per deployment):

| Variable | Type | Description |
| --- | --- | --- |
| `beamline_name` | string | Beamline identifier, used in paths and service names. |
| `beamline_id` | string | Two-digit beamline ID used to derive port numbers. |

**Optional** (have defaults in `defaults/main.yml`):

| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| `epics_services_account` | string | `csstudio` | OS user that owns service files. |
| `aa_version` | string | `2.2.1` | Archiver Appliance Git tag to build. |
| `aa_tomcat_home` | string | `/usr/share/tomcat` | System Tomcat installation from RPM. |
| `aa_install_location` | string | `/opt/epics-tools/services/{{ beamline_name }}/aa/install` | Staging directory for build artifacts. |
| `aa_deploy_location` | string | `/opt/epics-tools/services/{{ beamline_name }}/aa/deploy` | Final deployment directory. |
| `aa_identity` | string | `appliance0` | Appliance identity. |
| `cluster_inetport` | string | `1{{ beamline_id }}70` | Cluster communication port. |
| `mgmt_port` | string | `1{{ beamline_id }}65` | Management webapp port. |
| `engine_port` | string | `1{{ beamline_id }}66` | Engine webapp port. |
| `etl_port` | string | `1{{ beamline_id }}67` | ETL webapp port. |
| `data_retrieval_port` | string | `1{{ beamline_id }}68` | Data retrieval webapp port. |
| `aa_mysql_server` | string | `localhost` | MySQL server hostname. |
| `aa_mysql_database` | string | `{{ beamline_name }}_archappl` | Database name. |
| `aa_mysql_user` | string | `{{ beamline_name }}_archappl` | Database user. |
| `aa_mysql_password` | string | `{{ beamline_name }}_archappl` | Database password. |
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
  vars:
    beamline_name: tst
    beamline_id: "31"
  roles:
    - nsls2.epics_services.epics_tools_services_aa
```
