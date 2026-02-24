# jdk_dependency

Installs OpenJDK 17 from RPM packages (`java-17-openjdk` and
`java-17-openjdk-devel`).

## RPM path

After installation the JDK home is available at:

```text
/usr/lib/jvm/java-17-openjdk
```

Roles that depend on a JDK should include this role and reference
that path directly.

## Usage

```yaml
- name: Install JDK 17
  ansible.builtin.include_role:
    name: nsls2.epics_services.jdk_dependency
```

## Depended on by

- `nsls2.epics_services.aa_service`
- `nsls2.epics_services.aa_cluster_service`
