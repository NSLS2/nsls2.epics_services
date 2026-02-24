Phoebus Web BOB Files Cache
===========================

Flush the Phoebus web runtime (DBWR) cache after deploying BOB files.

Role Variables
--------------

| Variable | Description | Default |
| --- | --- | --- |
| `phoebus_dbwr_urls` | List of DBWR URLs to flush cache | `[]` (required) |

Example Playbook
----------------

```yaml
- hosts: servers
  vars:
    phoebus_dbwr_urls:
      - "https://webview.example.com/dbwr"
      - "https://webview-dev.example.com/dbwr"
  roles:
    - nsls2.epics_services.cs_studio_bobs_web_cache
```

Dependencies
------------

Phoebus Web runtime:
role: phoebus_web_runtime_service
