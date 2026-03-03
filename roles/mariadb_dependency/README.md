# mariadb_dependency

Installs the MariaDB JDBC connector from the RPM package
(`mariadb-java-client`).

## RPM path

After installation the JAR is available at:

```text
/usr/lib/java/mariadb-java-client.jar
```

Roles that depend on the MariaDB connector should include this role
and reference that path directly.

## Usage

```yaml
- name: Install MariaDB JDBC connector
  ansible.builtin.include_role:
    name: nsls2.epics_services.mariadb_dependency
```

## Depended on by

- `nsls2.epics_services.aa_service`
