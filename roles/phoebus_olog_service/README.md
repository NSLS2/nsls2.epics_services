phoebus_olog_service
====================

Install the Phoebus Logbook service.


**Installation location:**
`/opt/epics-tools/services/phoebus_olog/` (configurable via `phoebus_olog_install_dir`)

**Startup scripts:**
`systemctl start phoebus_olog`


Dependencies
------------
OpenJDK 17
role: jdk_dependency

Elastic
role: elasticsearch_dependency

MongoDB
role: mongodb_dependency

Role Variables
--------------

| Variable | Type | Description |
| --- | --- | --- |
| `phoebus_olog_install_dir` | string | Installation directory (default: `/opt/epics-tools/services/phoebus_olog`). |
| `phoebus_olog_version` | string | Git tag to checkout (default: `v5.0.4`). |
| `olog_http_port` | int | HTTP port for the Olog REST API (default: `8080`). |
| `olog_https_port` | int | HTTPS port for the Olog REST API (default: `8443`). |
| `es_port` | int | Elasticsearch port (default: `9200`). |
| `mongod_port` | int | MongoDB port (default: `27017`). |
| `olog_procServ_port` | int | procServ port (default: `60049`). |
