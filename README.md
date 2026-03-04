# nsls2.epics_services

Ansible collection for deploying EPICS middle-layer services.

Roles are designed to be generic — site-specific configuration (ports,
paths, authentication) is provided via an orchestration role or
`host_vars` in the consuming playbook.

## Installation

```bash
ansible-galaxy collection install nsls2.epics_services
```

Or from a local tarball:

```bash
ansible-galaxy collection build --force --output-path /tmp/
ansible-galaxy collection install /tmp/nsls2-epics_services-*.tar.gz
```

## Roles

### Service roles

These roles deploy EPICS services. Dependencies (JDK, Maven, etc.) must
be installed before these roles run — typically handled by an
orchestration layer.

| Role | Description |
| --- | --- |
| `aa_service` | Archiver Appliance — single-node or clustered. Requires JDK, Tomcat, MariaDB JDBC connector. |
| `channelfinder_service` | ChannelFinder directory service. Requires JDK, Maven, Elasticsearch. |
| `phoebus_alarm_service` | Phoebus alarm server, logger, and config logger. Requires JDK, Maven, Elasticsearch, Kafka, CS-Studio Phoebus. |
| `phoebus_olog_service` | Phoebus Olog electronic logbook service. Requires JDK, Maven, Elasticsearch, MongoDB. |
| `phoebus_olog_webclient_service` | Phoebus Olog web client (React/Node.js). Includes `nodejs_dependency`. |
| `phoebus_web_runtime_service` | Phoebus web runtime (PVWS + DBWR WARs on Tomcat). Requires JDK, Maven, Tomcat. |
| `recceiver_service` | RecCeiver (RecSync) — IOC channel registration. Requires JDK, Maven, Elasticsearch, ChannelFinder. |
| `save_restore_service` | Save/restore service for machine snapshots. Requires procServ. |
| `shift_service` | Shift logbook service on GlassFish 5. Requires JDK 8, MariaDB JDBC connector. |

### Build / configuration roles

| Role | Description |
| --- | --- |
| `cs_studio_phoebus` | Clone and build the Phoebus product from source. |
| `cs_studio_preferences` | Deploy CS-Studio preference files. |
| `cs_studio_bobs` | Deploy CS-Studio BOB display files. |
| `cs_studio_bobs_web` | Build BOB web displays for the display builder web runtime. |
| `cs_studio_bobs_web_cache` | Flush the DBWR display cache. |

### Dependency roles

Shared infrastructure installed once and consumed by multiple services.
Centralizing these ensures consistent versions and single-point upgrades.

| Role | Installs | Key variables |
| --- | --- | --- |
| `jdk_dependency` | OpenJDK (default: 21) | `jdk_version`, `java_home` |
| `maven_dependency` | Apache Maven (default: 3.9.9) | `maven_version`, `mvn_home` |
| `elasticsearch_dependency` | Elasticsearch 8.x | `es_port`, `es_host` |
| `kafka_dependency` | Apache Kafka + Zookeeper | `kafka_port`, `zookeeper_port`, `kafka_java_home` |
| `mongodb_dependency` | MongoDB 6.x | `mongod_port`, `mongod_host` |
| `tomcat_dependency` | Apache Tomcat (RPM) | — |
| `mariadb_dependency` | MariaDB JDBC connector (RPM) | — |
| `nodejs_dependency` | Node.js via NodeSource | `nodejs_version` |
| `procserv_dependency` | procServ process manager | — |

## Architecture

```
Orchestration role (site-specific)
├── defaults/main.yml        # Site defaults (ports, paths, auth)
├── tasks/main.yml            # Enable flags dispatch to per-service files
├── tasks/phoebus_alarm.yml   # include_role: jdk, maven, es, kafka, ...
├── tasks/phoebus_olog.yml    # include_role: jdk, maven, es, mongodb, ...
└── ...
    └── include_role: nsls2.epics_services.<service>

nsls2.epics_services (this collection)
├── roles/*_dependency/       # Shared infrastructure (JDK, Maven, ES, ...)
└── roles/*_service/          # Service deployment (no inline deps)
```

Dependency roles are **idempotent** — they always run and rely on
Ansible's built-in module idempotency to skip unchanged state and fix
configuration drift. Service roles do not install their own
dependencies (with the exception of lightweight, service-specific
packages like procServ or Python libraries).

## License

BSD-3-Clause
