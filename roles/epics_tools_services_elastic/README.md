epics_tools_services_elastic
============================

[Elasticsearch](https://www.elastic.co/elasticsearch) is a distributed search and
analytics engine. In the Phoebus alarm stack, it stores alarm state history and
configuration snapshots written by the alarm logger and alarm config logger services.

This role installs a single-node Elasticsearch instance via the official Elastic RPM
repository with security features disabled for local-only access.

**Service name:** `elasticsearch`

What it does
------------
- Adds the Elasticsearch yum repository and GPG key
- Installs Elasticsearch at a pinned version
- Configures HTTP port, data/log paths, and JVM heap size
- Disables xpack security (SSL, transport, HTTP) for local-only use
- Resets the auto-generated keystore from the RPM install
- Enables the `elasticsearch` systemd service

Dependencies
------------
- `epics_tools_libs` (OpenJDK 17)

Depended on by
--------------
- `epics_tools_services_phoebus_alarm` (alarm logger and alarm config logger write to Elasticsearch)

Role Variables
--------------

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `beamline_name` | string | `tst` | Used in cluster name and data/log paths. |
| `epics_services_account` | string | `csstudio` | OS user for file ownership. |
| `elastic_version` | string | `8.12.0` | Elasticsearch version to install (major.minor.patch). |
| `elastic_heap_size` | string | `4g` | JVM heap size for Elasticsearch. |
| `elastic_port` | int | `9200` | HTTP port for Elasticsearch. |
| `elastic_data` | string | `/var/lib/elasticsearch/{{ beamline_name }}` | Data directory path. |
| `elastic_logs` | string | `/var/log/elasticsearch/{{ beamline_name }}` | Log directory path. |

Example Playbook
----------------

```yaml
- hosts: all
  vars:
    beamline_name: mybeamline
  roles:
    - nsls2.epics_services.epics_tools_libs
    - nsls2.epics_services.epics_tools_services_elastic
```

To override the port or heap size:

```yaml
- hosts: all
  vars:
    beamline_name: mybeamline
    elastic_port: 9201
    elastic_heap_size: "8g"
  roles:
    - nsls2.epics_services.epics_tools_services_elastic
```
