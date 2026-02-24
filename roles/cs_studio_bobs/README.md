Phoebus BOB Files
=================

Deploy Phoebus .bob display files from git repositories.

Role Variables
--------------

| Variable | Description | Default |
| --- | --- | --- |
| `cs_studio_bobs_config.base_repo` | Base URL for git repositories | `""` (required) |
| `cs_studio_bobs_config.basedir` | Local directory for BOB files | `/opt/css/bobs` |
| `cs_studio_bobs_config.version` | Git branch/tag to checkout | `["main"]` |
| `cs_studio_bobs_config.repos` | List of repository names to clone | `[]` (required) |

Example Playbook
----------------

```yaml
- hosts: servers
  vars:
    cs_studio_bobs_config:
      base_repo: "https://github.com/your-org"
      basedir: /opt/css/bobs
      version:
        - main
      repos:
        - "your-bobs-repo-1"
        - "your-bobs-repo-2"
  roles:
    - nsls2.epics_services.cs_studio_bobs
```

Directory Structure
-------------------

BOB files are deployed to:
```text
{{ basedir }}/{{ version }}/{{ repo_name }}/
```
