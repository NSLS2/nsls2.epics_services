# jdk_dependency

Installs JDK 21 (or the version set by `jdk_version`).

**Installation strategy:**

1. Tries system OpenJDK RPM (`java-21-openjdk`, `java-21-openjdk-devel`)
2. Falls back to Adoptium Temurin (`temurin-21-jdk`) if the RPM is unavailable
   (e.g. RHEL 8/9 where Java 21 may not be in base repos)

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `jdk_version` | `21` (shared.yml) | JDK major version |
| `jdk_temurin_java_home` | `/usr/lib/jvm/temurin-{{ jdk_version }}-jdk` | JAVA_HOME for Temurin fallback |

## Exported fact

After running, this role sets the `java_home` fact to the correct path:

| Install method | `java_home` value |
|----------------|-------------------|
| OpenJDK RPM | `/usr/lib/jvm/java-{{ jdk_version }}-openjdk` |
| Adoptium Temurin | `/usr/lib/jvm/temurin-{{ jdk_version }}-jdk` |

Downstream roles reference `java_home` (set via `set_fact`) which
overrides the static default in `vars/shared.yml`.

## Usage

```yaml
- name: Install JDK 21
  ansible.builtin.include_role:
    name: nsls2.epics_services.jdk_dependency
```

## Depended on by

- `nsls2.epics_services.aa_service`
- `nsls2.epics_services.cs_studio_phoebus`
- `nsls2.epics_services.phoebus_alarm_service`
- `nsls2.epics_services.kafka_dependency`
- `nsls2.epics_services.elasticsearch_dependency`
