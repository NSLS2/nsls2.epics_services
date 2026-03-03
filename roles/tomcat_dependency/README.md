# tomcat_dependency

Installs Tomcat from the RPM package (`tomcat`).

Requires **RHEL 10+** (or equivalent) to get Tomcat 10.1+, which is needed
by services using Jakarta EE (`jakarta.servlet`).

## RPM path

After installation the Tomcat home is available at:

```text
/usr/share/tomcat
```

Roles that depend on Tomcat should include this role and reference
that path directly.

## Usage

```yaml
- name: Install Tomcat
  ansible.builtin.include_role:
    name: nsls2.epics_services.tomcat_dependency
```

## Depended on by

- `nsls2.epics_services.aa_service`
