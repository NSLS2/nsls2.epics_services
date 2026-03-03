# jdk_dependency

Installs OpenJDK 21 from RPM packages (`java-21-openjdk` and
`java-21-openjdk-devel`).

## RPM path

After installation the JDK home is available at:

```text
/usr/lib/jvm/java-21-openjdk
```

Roles that depend on a JDK should include this role and reference
that path directly.

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
