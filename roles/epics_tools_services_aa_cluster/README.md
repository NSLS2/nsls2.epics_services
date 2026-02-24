epics_tools_services_aa_cluster
================================

Orchestrator role for a multi-node
[EPICS Archiver Appliance](https://github.com/archiver-appliance/epicsarchiverap)
cluster deployment with SSL/TLS. The Archiver Appliance monitors EPICS process
variables and archives their values to short-term, medium-term, and long-term
storage.

It consists of four services, each running as a separate Tomcat process:

- **Management** -- web UI for configuring PVs and viewing system status
- **Engine** -- connects to EPICS PVs and writes samples to short-term storage
- **ETL** -- moves data between storage tiers (short -> medium -> long)
- **Data Retrieval** -- serves archived data to clients

Each service is managed via its own systemd unit. All inter-node communication
uses HTTPS with APR SSL connectors.

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
3. `aa_ssl` -- validates SSL certificates and imports the CA chain into the Java
   truststore
4. `aa_build` -- clones and builds the Archiver Appliance from source
5. `aa_deploy` -- deploys the built artifacts with SSL-enabled Tomcat instances,
   configures `appliances.xml` for the cluster, installs systemd services

Dependencies
------------
None (all dependencies are handled by the sub-roles).

An external certificate management solution (e.g. ACME / Let's Encrypt) should
provision SSL certificates to the paths configured in `aa_ssl_cert_file`,
`aa_ssl_key_file`, and `aa_ssl_chain_file` before this role runs.

Depended on by
--------------
None (this is the top-level cluster deployment role).

Role Variables
--------------

**Required** (no sensible default -- must be set per deployment):

| Variable | Type | Description |
| --- | --- | --- |
| `beamline_name` | string | Beamline identifier, used in paths and service names. |
| `beamline_id` | string | Two-digit beamline ID used to derive port numbers. |
| `aa_ssl_cert_file` | string | Absolute path to the SSL certificate file. |
| `aa_ssl_key_file` | string | Absolute path to the SSL private key file. |
| `aa_epics_ca_addr_list` | string | EPICS Channel Access address list (broadcast address for the subnet). |

**Optional** (have defaults in `defaults/main.yml`):

| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| `epics_services_account` | string | `epics-services-{{ beamline_name }}` | OS user that owns service files. |
| `aa_enable_ssl` | bool | `true` | Enable HTTPS connectors (set by this role's defaults). |
| `aa_version` | string | `2.2.1` | Archiver Appliance Git tag to build. |
| `aa_tomcat_home` | string | `/usr/share/tomcat` | System Tomcat installation from RPM. |
| `aa_install_location` | string | `/opt/epics-tools/services/{{ beamline_name }}/aa/install` | Staging directory. |
| `aa_deploy_location` | string | `/opt/epics-tools/services/{{ beamline_name }}/aa/deploy` | Deployment directory. |
| `aa_identity` | string | `appliance0` | Appliance identity (must be unique per node). |
| `cluster_inetport` | string | `1{{ beamline_id }}70` | Cluster communication port. |
| `aa_ssl_port_mgmt` | string | `1{{ beamline_id }}75` | HTTPS port for mgmt. |
| `aa_ssl_port_engine` | string | `1{{ beamline_id }}76` | HTTPS port for engine. |
| `aa_ssl_port_etl` | string | `1{{ beamline_id }}77` | HTTPS port for ETL. |
| `aa_ssl_port_retrieval` | string | `1{{ beamline_id }}78` | HTTPS port for retrieval. |
| `aa_ssl_chain_file` | string | `""` | CA chain file path (optional, imported into Java truststore). |
| `aa_trusted_proxies` | list | `["0:0:0:0:0:0:0:1", "127.0.0.1"]` | IPs trusted for X-Forwarded-* headers. |
| `aa_mysql_server` | string | `localhost` | MySQL server hostname. |
| `aa_mysql_database` | string | `{{ beamline_name }}_archappl` | Database name. |
| `aa_mysql_user` | string | `{{ beamline_name }}_archappl` | Database user. |
| `aa_mysql_password` | string | `{{ beamline_name }}_archappl` | Database password. |
| `aa_java_opts_engine` | string | `-XX:+UseG1GC -Xmx10G -Xms4G -ea` | JVM options for engine. |
| `aa_java_opts_retrieval` | string | `-XX:+UseG1GC -Xmx10G -Xms4G -ea` | JVM options for retrieval. |
| `aa_java_opts_etl` | string | `-XX:+UseG1GC -Xmx5G -Xms1G -ea` | JVM options for ETL. |
| `aa_java_opts_mgmt` | string | `-XX:+UseG1GC -Xmx5G -Xms1G -ea` | JVM options for mgmt. |
| `aa_sts` | string | `{{ aa_deploy_location }}/data/sts/ArchiverStore` | Short-term storage path. |
| `aa_mts` | string | `{{ aa_deploy_location }}/data/mts/ArchiverStore` | Medium-term storage path. |
| `aa_lts` | string | `{{ aa_deploy_location }}/data/lts/ArchiverStore` | Long-term storage path. |
| `aa_logs_base_dir` | string | `/var/log/archiver-appliance` | Log directory base path. |
| `aa_configure_custom_logs` | bool | `true` | Deploy custom Log4j2 logging configuration. |
| `aa_data_mount_name` | string | `""` | Systemd mount dependency for data volumes. |
| `aa_cluster_appliances` | list | `[]` | Cluster appliance definitions (see below). |

**Cluster appliances configuration:**

The `aa_cluster_appliances` list defines all nodes in the cluster. It must be
identical on every node. Each entry has:

```yaml
aa_cluster_appliances:
  - identity: appliance0
    hostname: archiver1.example.com
    cluster_inetport: "{{ cluster_inetport }}"
  - identity: appliance1
    hostname: archiver2.example.com
    cluster_inetport: "{{ cluster_inetport }}"
```

Example Playbook
----------------

```yaml
- hosts: archiver_cluster
  vars:
    beamline_name: tst
    beamline_id: "31"
    aa_ssl_cert_file: /etc/pki/tls/certs/archiver.crt
    aa_ssl_key_file: /etc/pki/tls/private/archiver.key
    aa_ssl_chain_file: /etc/pki/tls/certs/ca-bundle.crt
    aa_epics_ca_addr_list: 10.0.0.255
    aa_cluster_appliances:
      - identity: appliance0
        hostname: archiver1.example.com
        cluster_inetport: "{{ cluster_inetport }}"
      - identity: appliance1
        hostname: archiver2.example.com
        cluster_inetport: "{{ cluster_inetport }}"
  roles:
    - nsls2.epics_services.epics_tools_services_aa_cluster
```

Set `aa_identity` per host (e.g. via `host_vars/`) to match the corresponding
entry in `aa_cluster_appliances`.
