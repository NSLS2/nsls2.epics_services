# tomcat_dep

Installs Tomcat 10.1+ for services using Jakarta EE (`jakarta.servlet`).

**Installation strategy:**

1. Tries the system RPM (`tomcat` package) — available on RHEL 10+
2. Falls back to downloading the Apache binary tarball if the RPM is unavailable (e.g. RHEL 8/9)

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `tomcat_version` | `10.1.34` (shared.yml) | Tomcat version for tarball fallback |
| `tomcat_source_install_dir` | `/opt/tomcat` | Install path for tarball fallback |

## Exported fact

After running, this role sets the `tomcat_home` fact to the correct path:

| Install method | `tomcat_home` value |
|----------------|---------------------|
| RPM | `/usr/share/tomcat` |
| Tarball | `{{ tomcat_source_install_dir }}` (default `/opt/tomcat`) |

Downstream roles should reference `tomcat_home` rather than
hardcoding a path. The `aa_api` and `phoebus_web_runtime_ui`
defaults already do this via `{{ tomcat_home | default('/usr/share/tomcat') }}`.

## Usage

```yaml
- name: Install Tomcat
  ansible.builtin.include_role:
    name: nsls2.epics_services.tomcat_dep
```

## Depended on by

- `nsls2.epics_services.aa_api`
- `nsls2.epics_services.phoebus_web_runtime_ui`
