# maven_dependency

Installs Apache Maven from a tarball into
`/opt/epics-tools/lib/apache-maven-{{ maven_version }}`.

## Defaults

| Variable | Default |
| --- | --- |
| `maven_version` | `3.9.9` |
| `maven_url` | Apache archive URL for the configured version |
| `maven_dependency_owner` | `csstudio` |

## Usage

```yaml
- name: Install Maven
  ansible.builtin.include_role:
    name: nsls2.epics_services.maven_dependency
```
