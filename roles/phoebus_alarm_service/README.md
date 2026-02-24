phoebus_alarm_service
=====================

The [Phoebus Alarm System](https://control-system-studio.readthedocs.io/en/latest/services/alarm-server/doc/index.html)
monitors EPICS process variables and generates alarms when values go out of range or
become disconnected. It consists of three services:

- **Alarm Server** -- connects to EPICS PVs via Channel Access/PVAccess, evaluates
  alarm conditions, and publishes state changes to Kafka topics.
- **Alarm Logger** -- reads alarm state changes from Kafka and indexes them into
  Elasticsearch for historical queries.
- **Alarm Config Logger** -- monitors alarm configuration changes in Kafka and
  records them (optionally to a Git repository) for auditing.

Each service runs under [procServ](https://github.com/ralphlange/procServ) for
console access and is managed via systemd.

**Installation location:**
`/opt/epics-tools/services/{{ beamline_name }}/phoebus_alarm/`

**Service names:**
- `{{ beamline_name }}_phoebus_alarm` (alarm server, procServ port 60046)
- `{{ beamline_name }}_phoebus_alarm_logger` (alarm logger, procServ port 60047)
- `{{ beamline_name }}_phoebus_alarm_config_logger` (alarm config logger, procServ port 60048)

What it does
------------
- Copies alarm server, alarm logger, and alarm config logger JARs from the Phoebus build
- Deploys a shared preferences file configuring Kafka, Elasticsearch, and alarm settings
- Creates Kafka topics for the alarm system (config, command, talk)
- Installs procServ and creates run scripts for each service
- Installs systemd service units for each service

Dependencies
------------
- `jdk_dependency` (OpenJDK 17)
- `elasticsearch_dependency` (Elasticsearch -- stores alarm history)
- `kafka_dependency` (Kafka and Zookeeper -- alarm message bus)
- `cs_studio_phoebus` (builds the alarm service JARs)

Depended on by
--------------
None (this is the top-level alarm service role).

Role Variables
--------------

**Required** (no sensible default -- must be set per deployment):

| Variable | Type | Description |
| --- | --- | --- |
| `beamline_name` | string | Beamline identifier, used in paths and service names. |
| `alarm_config` | string | Alarm configuration name (e.g. `TST_OPR`, `XF06BM_OPR`). Must match the client preferences `config_name`. |

**Optional** (have defaults that work for standard single-host deployments):

| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| `java_home` | string | `/usr/lib/jvm/java-17-openjdk` | JAVA_HOME for alarm services. |
| `alarm_epics_ca_addr_list` | string | `localhost` | EPICS Channel Access address list. |
| `epics_services_account` | string | `csstudio` | OS user that owns service files. |
| `kafka_server` | string | `localhost` | Kafka broker hostname. |
| `kafka_port` | int | `9092` | Kafka broker port. |
| `zookeeper_port` | int | `2181` | Zookeeper client port. |
| `kafka_installation` | string | `.../kafka` | Path to the Kafka installation (for topic scripts). |
| `es_host` | string | `localhost` | Elasticsearch hostname. |
| `es_port` | int | `9200` | Elasticsearch HTTP port. |
| `alarm_mail_server` | string | `localhost` | SMTP server for alarm email notifications. |
| `alarm_mail_server_port` | int | `25` | SMTP port. |
| `alarm_mail_server_from` | string | `{{ beamline_name }}_phoebus@localhost` | From address for alarm emails. |
| `phoebus_alarm_server_version` | string | `5.0.0` | Alarm server JAR version. |
| `phoebus_alarm_logger_version` | string | `5.0.0` | Alarm logger JAR version. |
| `phoebus_alarm_config_logger_version` | string | `5.0.0` | Alarm config logger JAR version. |
| `phoebus_alarm_server_procServ_port` | string | `60046` | procServ port for alarm server. |
| `phoebus_alarm_logger_procServ_port` | string | `60047` | procServ port for alarm logger. |
| `phoebus_alarm_config_logger_procServ_port` | string | `60048` | procServ port for alarm config logger. |

Example Playbook
----------------

```yaml
- hosts: all
  vars:
    beamline_name: tst
    alarm_config: TST_OPR
    alarm_mail_server: smtpgw.example.com
    alarm_mail_server_from: tst_phoebus@example.com
  roles:
    - nsls2.epics_services.jdk_dependency
    - nsls2.epics_services.elasticsearch_dependency
    - nsls2.epics_services.kafka_dependency
    - nsls2.epics_services.cs_studio_phoebus
    - nsls2.epics_services.phoebus_alarm_service
```

Or via command line:

```bash
ansible-playbook deploy_alarm.yml -l myhost.example.com \
  -e "beamline_name=tst alarm_config=TST_OPR"
```
