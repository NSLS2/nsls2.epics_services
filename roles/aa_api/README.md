aa_api
======

Self-contained role for deploying the
[EPICS Archiver Appliance](https://github.com/archiver-appliance/epicsarchiverap).
The Archiver Appliance monitors EPICS process variables and archives their values
to short-term, medium-term, and long-term storage.

Supports both **single-instance** and **multi-node cluster** deployments. By
default a single node is deployed. To form a cluster, populate the
`aa_cluster_appliances` list — this triggers generation of `appliances.xml` so
that nodes discover each other.

It consists of four services, each running as a separate Tomcat process:

- **Management** -- web UI for configuring PVs and viewing system status
- **Engine** -- connects to EPICS PVs and writes samples to short-term storage
- **ETL** -- moves data between storage tiers (short -> medium -> long)
- **Data Retrieval** -- serves archived data to clients

Each service is managed via its own systemd unit.

**Installation location:**
`/opt/epics-tools/services/archiver_appliance/`

**Service names:**
- `{{ aa_service_prefix }}_mgmt`
- `{{ aa_service_prefix }}_engine`
- `{{ aa_service_prefix }}_etl`
- `{{ aa_service_prefix }}_retrieval`

Requirements
------------

- **RHEL 10+** (or equivalent): AA 2.2.1 requires Tomcat 10+ (Jakarta EE /
  `jakarta.servlet`). RHEL 8's Tomcat RPM is v9 (`javax.servlet`) and is
  incompatible. RHEL 10 ships Tomcat 10.1+ as an RPM.
- `community.mysql` Ansible collection (for MariaDB user/db tasks)

What it does
------------

1. Installs OpenJDK 21 (`jdk_dep` shared role)
2. Installs Tomcat (`tomcat_dep` shared role) and MariaDB JDBC connector
   (`mariadb_dep` shared role)
3. Installs and configures a local MariaDB instance
4. Clones and builds the Archiver Appliance from source
5. Deploys the built artifacts, configures Tomcat instances,
   deploys `appliances.xml` when cluster appliances are defined,
   installs systemd services
6. Optionally configures custom Log4j2 logging

Dependencies
------------

- `nsls2.epics_services.jdk_dep` (included automatically)
- `nsls2.epics_services.tomcat_dep` (included automatically)
- `nsls2.epics_services.mariadb_dep` (included automatically)
- `community.mysql` collection

Role Variables
--------------

**Optional** (have defaults in `defaults/main.yml`):

| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| `epics_services_account` | string | `csstudio` | OS user that owns service files. |
| `aa_service_prefix` | string | `aa` | Prefix for systemd unit names and startup scripts. |
| `aa_site_name` | string | `Archiver Appliance` | Display name shown in the facility template header. |
| `aa_version` | string | `2.2.1` | Archiver Appliance Git tag to build. |
| `aa_tomcat_home` | string | `/usr/share/tomcat` | Tomcat installation from RPM. |
| `aa_mysql_connector_jar` | string | `/usr/lib/java/mariadb-java-client.jar` | MariaDB JDBC connector JAR from RPM. |
| `aa_install_dir` | string | `/opt/epics-tools/services/archiver_appliance` | Base installation directory. |
| `aa_install_location` | string | `{{ aa_install_dir }}/install` | Staging directory for build artifacts. |
| `aa_deploy_location` | string | `{{ aa_install_dir }}/deploy` | Final deployment directory. |
| `aa_identity` | string | `appliance0` | Appliance identity (must be unique per node in a cluster). |
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
| `aa_cleanup_legacy_service` | bool | `false` | Remove old monolithic AA service unit if present. |
| `aa_ssl_enabled` | bool | `false` | Enable NIO SSL connector on each Tomcat instance. |
| `aa_ssl_keystore_file` | string | `""` | Path to Java keystore (e.g. from `acme_certificates`). |
| `aa_ssl_keystore_password` | string | `changeit` | Keystore password. |
| `aa_ssl_port_mgmt` | integer | `16075` | SSL port for management webapp. |
| `aa_ssl_port_engine` | integer | `16076` | SSL port for engine webapp. |
| `aa_ssl_port_etl` | integer | `16077` | SSL port for ETL webapp. |
| `aa_ssl_port_retrieval` | integer | `16078` | SSL port for data retrieval webapp. |
| `aa_remote_ip_valve_enabled` | bool | `false` | Enable `RemoteIpValve` (preserves real client IPs behind a reverse proxy). |
| `aa_remote_ip_internal_proxies` | string | `127\\.0\\.0\\.1` | Regex matching trusted proxy IPs for `RemoteIpValve`. |
| `aa_health_check_enabled` | bool | `true` | Enable `/health` endpoint (Tomcat >= 9.0.55). |
| `aa_cluster_appliances` | list | `[]` | Cluster appliance definitions (see below). |

Cluster mode
------------

To deploy a multi-node cluster, populate `aa_cluster_appliances` with an entry
for every node. This list must be **identical on all nodes**. Each entry has:

```yaml
aa_cluster_appliances:
  - identity: appliance0
    hostname: archiver1.example.com
    cluster_inetport: "{{ cluster_inetport }}"
  - identity: appliance1
    hostname: archiver2.example.com
    cluster_inetport: "{{ cluster_inetport }}"
```

Set `aa_identity` per host (e.g. via `host_vars/`) to match the corresponding
entry in `aa_cluster_appliances`.

Example Playbooks
-----------------

**Single instance:**

```yaml
- hosts: archiver
  roles:
    - nsls2.epics_services.aa_api
```

**With SSL behind HAProxy (configured from the infrastructure playbook):**

```yaml
- hosts: archiver
  vars:
    aa_ssl_enabled: true
    aa_ssl_keystore_file: "{{ acme_certificates_dir + '/' + acme_certificates_filename.keystore }}"
    aa_ssl_keystore_password: "{{ acme_certificates_keystore_password | default('changeit') }}"
    aa_remote_ip_valve_enabled: true
    aa_remote_ip_internal_proxies: "{{ haproxy_internal_proxies_regex }}"
  roles:
    - nsls2.epics_services.aa_api
```

**Cluster:**

```yaml
- hosts: archiver_cluster
  vars:
    aa_cluster_appliances:
      - identity: appliance0
        hostname: archiver1.example.com
        cluster_inetport: "{{ cluster_inetport }}"
      - identity: appliance1
        hostname: archiver2.example.com
        cluster_inetport: "{{ cluster_inetport }}"
  roles:
    - nsls2.epics_services.aa_api
```
