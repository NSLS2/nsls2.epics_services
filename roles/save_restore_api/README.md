save_restore_api
================

Install the save and restore service.

**Installation location:**
`/opt/epics-tools/services/save_restore` (configurable via `save_restore_install_dir`)

**Startup scripts:**
`systemctl start save_restore`


Dependencies
------------
OpenJDK 21
role: jdk_dep

Elasticsearch
role: elasticsearch_dep

Role Variables
--------------

| Variable | Type | Description |
| --- | --- | --- |
| `save_restore_install_dir` | string | Installation directory (default: `/opt/epics-tools/services/save_restore`). |
| `save_restore_version` | string | Service JAR version (default: `4.7.4`). |
| `save_restore_http_port` | int | HTTP port (default: `8080`). |
| `save_restore_https_port` | int | HTTPS port (default: `8443`). |
| `save_restore_procServ_port` | int | procServ port (default: `60052`). |
| `es_host` | string | Elasticsearch host (default: `localhost`). |
| `es_port` | int | Elasticsearch port (default: `9200`). |
| `ad_enabled` | bool | Enable Active Directory authentication (default: `true`). |
| `ad_url` | string | AD server URL (default: empty, set in inventory). |
| `ad_domain` | string | AD domain (default: empty, set in inventory). |
