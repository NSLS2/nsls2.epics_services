cs_studio_phoebus
=================

[Phoebus](https://github.com/ControlSystemStudio/phoebus) is the next-generation
Control System Studio, a Java-based platform for operating large-scale control
systems such as particle accelerators and beamlines. It provides operator interfaces,
alarm handling, archiving, and logging tools.

This role clones and builds Phoebus from source, including site-specific product
builds. The resulting JAR files are used by the alarm services role and can also
be used to run the Phoebus client.

What it does
------------
- Clones the upstream [Phoebus](https://github.com/ControlSystemStudio/phoebus) repository
- Clones a site-specific products repository (configurable)
- Builds Phoebus documentation, core libraries, and product JARs using Maven
- Optionally creates a `run-phoebus` launcher script

Dependencies
------------
- `jdk_dep` and `maven_dep` (OpenJDK 21 and Maven)

Depended on by
--------------
- `phoebus_alarm_svc` (alarm server, logger, and config logger JARs
  are produced by the Phoebus build)

Role Variables
--------------

| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| `cs_studio_phoebus_version` | string | `master` | Git branch/tag for the upstream Phoebus repo. |
| `cs_studio_phoebus_products_repo` | string | `""` | Git URL for the site-specific products repo (must be set per deployment). |
| `cs_studio_phoebus_products_version` | string | `main` | Git branch/tag for the products repo. |
| `cs_studio_phoebus_products_dest` | string | `/opt/css/phoebus-products` | Local clone path for the products repo. |
| `cs_studio_phoebus_java_home` | string | `/usr/lib/jvm/java-21-openjdk` | JAVA_HOME for Maven builds. |
| `cs_studio_phoebus_mvn_home` | string | `/opt/epics-tools/lib/apache-maven-3.9.9` | Maven installation path. |
| `cs_studio_phoebus_jar` | string | `""` | Path to the built product JAR (used by `run-phoebus`). |
| `cs_studio_phoebus_pref` | string | `""` | Path to the preferences file (used by `run-phoebus`). |
| `cs_studio_phoebus_logging` | string | See defaults | Path to the logging configuration file. |
| `cs_studio_phoebus_logback` | string | See defaults | Path to the logback configuration file. |
| `cs_studio_phoebus_owner` | string | `csstudio` | OS user that owns the Phoebus installation. |
| `cs_studio_phoebus_override_mvn_settings` | bool | `false` | Whether to deploy a custom Maven `settings.xml`. |
| `cs_studio_phoebus_force_gpu` | bool | `false` | Force GPU rendering in the `run-phoebus` script. |

The `run-phoebus` script is only created when `cs_studio_phoebus_jar` is set to a
non-empty value.

Example Playbook
----------------

```yaml
- hosts: all
  vars:
    cs_studio_phoebus_products_repo: "https://github.com/myorg/my-phoebus-products.git"
    cs_studio_phoebus_products_version: "main"
  roles:
    - nsls2.epics_services.jdk_dep
    - nsls2.epics_services.maven_dep
    - nsls2.epics_services.cs_studio_phoebus
```
