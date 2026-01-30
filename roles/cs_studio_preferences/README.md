CS-Studio & Phoebus Preferences
===============================

Deploy CS-Studio and Phoebus preferences from a git repository.

Role Variables
--------------

| Variable | Description | Default |
|----------|-------------|---------|
| `cs_studio_preferences_config.repo` | Git repository URL for preferences | `""` (required) |
| `cs_studio_preferences_config.version` | Git branch/tag to checkout | `main` |
| `cs_studio_preferences_config.basedir` | Local directory for preferences | `/opt/css/preferences` |
| `cs_studio_preferences_config.configdir` | Local directory for configuration | `/opt/css/configuration` |
| `cs_studio_preferences_config.user` | Owner of preferences files | `csstudio` |

Example Playbook
----------------

```yaml
- hosts: servers
  vars:
    cs_studio_preferences_config:
      repo: "https://github.com/your-org/your-preferences-repo.git"
      version: main
      basedir: /opt/css/preferences
      configdir: /opt/css/configuration
      user: csstudio
  roles:
    - nsls2.epics_services.cs_studio_preferences
```
