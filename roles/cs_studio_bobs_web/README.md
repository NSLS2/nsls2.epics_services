Phoebus Web BOB Files
=====================

Deploy Phoebus web .bob display files from git repositories.

Role Variables
--------------

| Variable | Description | Default |
| --- | --- | --- |
| `cs_studio_bobs.base_repo` | Base URL for git repositories | `""` (required) |
| `cs_studio_bobs.basedir` | Local directory for BOB files | `/opt/css/bobs` |
| `cs_studio_bobs.version` | Git branch/tag to checkout | `["main"]` |
| `cs_studio_bobs.repos` | List of repository names to clone | `[]` (required) |

Example Playbook
----------------

```yaml
- hosts: servers
  vars:
    cs_studio_bobs:
      base_repo: "https://github.com/your-org"
      basedir: /opt/css/bobs
      version:
        - main
      repos:
        - "your-web-bobs-repo"
  roles:
    - nsls2.epics_services.cs_studio_bobs_web
```

Dependencies
------------
