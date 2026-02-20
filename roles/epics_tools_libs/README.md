epics_tools_libs
================

Installs shared build and runtime libraries used by EPICS services: OpenJDK and
Apache Maven.

OpenJDK provides the Java runtime required by Elasticsearch, Kafka, and all Phoebus
services. Maven is required to build Phoebus from source (used by `cs_studio_phoebus`).

This role is a **dependency for all other roles** in this collection and should be
listed first in any playbook.

What it does
------------
- Installs OpenJDK 8, 11, and 17 via RHEL RPM packages
- Creates compatibility symlinks at `/opt/epics-tools/lib/jvm/jdk-{version}`
  (handles migration from previous tarball-based installs)
- Installs Apache Maven from the official tarball

Dependencies
------------
None.

Depended on by
--------------
- `epics_tools_services_elastic`
- `epics_tools_services_kafka`
- `cs_studio_phoebus`
- `epics_tools_services_phoebus_alarm`

Role Variables
--------------

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `jdk_packages` | list | See below | List of JDK versions to install. Each entry has `version`, `package`, and `rpm_path`. |
| `jdk_symlink_base` | string | `/opt/epics-tools/lib/jvm` | Directory where JDK symlinks are created. |
| `maven_version` | string | `3.9.9` | Apache Maven version to install. |
| `maven_url` | string | Apache archive URL | Download URL for the Maven tarball. |
| `epics_tools_libs_epics_services_account` | string | `csstudio` | OS user that owns the installed files. |

Default `jdk_packages`:

```yaml
jdk_packages:
  - { version: "8", package: "java-1.8.0-openjdk-devel", rpm_path: "/usr/lib/jvm/java-1.8.0-openjdk" }
  - { version: "11", package: "java-11-openjdk-devel", rpm_path: "/usr/lib/jvm/java-11-openjdk" }
  - { version: "17", package: "java-17-openjdk-devel", rpm_path: "/usr/lib/jvm/java-17-openjdk" }
```

Example Playbook
----------------

```yaml
- hosts: all
  roles:
    - nsls2.epics_services.epics_tools_libs
```

To install only JDK 17:

```yaml
- hosts: all
  vars:
    jdk_packages:
      - { version: "17", package: "java-17-openjdk-devel", rpm_path: "/usr/lib/jvm/java-17-openjdk" }
  roles:
    - nsls2.epics_services.epics_tools_libs
```
