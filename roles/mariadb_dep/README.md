# mariadb_dep

Installs the MariaDB JDBC connector JAR.

**Installation strategy:**

1. Tries the system RPM (`mariadb-java-client` package)
2. Falls back to downloading the JAR from Maven Central if the RPM is unavailable

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `mariadb_connector_jar` | `/usr/lib/java/mariadb-java-client.jar` | Path to the installed JAR |
| `mariadb_connector_version` | `3.3.3` | Version for Maven Central fallback |

## JAR path

After installation the JAR is available at:

```text
/usr/lib/java/mariadb-java-client.jar
```

The JAR ends up at the same path regardless of install method,
so downstream roles do not need to distinguish between RPM and
Maven Central installs.

## Usage

```yaml
- name: Install MariaDB JDBC connector
  ansible.builtin.include_role:
    name: nsls2.epics_services.mariadb_dep
```

## Depended on by

- `nsls2.epics_services.aa_api`
- `nsls2.epics_services.shift_api`
