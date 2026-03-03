kafka_dependency
================

[Apache Kafka](https://kafka.apache.org/) is a distributed event streaming platform.
In the Phoebus alarm stack, Kafka is the message broker that carries alarm state,
commands, and annunciation messages between the alarm server, alarm clients, and
alarm loggers.

[Zookeeper](https://zookeeper.apache.org/) is a coordination service required by
Kafka for broker metadata management.

This role installs a single-node Kafka broker with a co-located Zookeeper instance.

**Service names:**
- `{{ beamline_name }}_zookeeper`
- `{{ beamline_name }}_kafka`

Zookeeper must be started before Kafka (the systemd unit enforces this ordering).

What it does
------------
- Downloads and extracts Kafka 3.9.0 to `/opt/epics-tools/services/{{ beamline_name }}/kafka`
- Configures Zookeeper and Kafka broker properties (ports, data directories)
- Installs systemd services for both Zookeeper and Kafka
- Ensures correct file ownership on the Kafka logs directory

Dependencies
------------
- `jdk_dependency` (OpenJDK 21)

Depended on by
--------------
- `phoebus_alarm_service` (alarm server, logger, and config logger all connect to Kafka)

Role Variables
--------------

| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| `beamline_name` | string | `tst` | Used in installation path and service names. |
| `epics_services_account` | string | `csstudio` | OS user that owns the Kafka installation. |
| `kafka_java_home` | string | `/usr/lib/jvm/java-21-openjdk` | JAVA_HOME for Kafka and Zookeeper. |
| `zookeeper_port` | int | `2181` | Zookeeper client port. |
| `zookeeper_data` | string | `.../kafka/data/zookeeper` | Zookeeper data directory. |
| `kafka_port` | int | `9092` | Kafka broker port. |
| `kafka_logs` | string | `.../kafka/kafka-logs` | Kafka log directory (message storage). |

Example Playbook
----------------

```yaml
- hosts: all
  vars:
    beamline_name: mybeamline
  roles:
    - nsls2.epics_services.jdk_dependency
    - nsls2.epics_services.kafka_dependency
```
