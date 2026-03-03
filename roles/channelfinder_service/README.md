channelfinder_service
=====================

Install the ChannelFinder service.


**Installation location:**
`/opt/epics-tools/services/channelfinder/` (configurable via `channelfinder_install_dir`)

**Startup scripts:**
`systemctl start channelfinder`


Dependencies
------------
OpenJDK 21
role: jdk_dependency

Elastic
role: elasticsearch_dependency

Role Variables
--------------

| Variable | Type | Description |
| --- | --- | --- |
| `channelfinder_install_dir` | string | Installation directory (default: `/opt/epics-tools/services/channelfinder`). |
| `cf_version` | string | Git tag to checkout (default: `ChannelFinder-4.7.3`). |
| `cf_http_port` | int | HTTP port for the ChannelFinder REST API (default: `8080`). |
| `cf_https_port` | int | HTTPS port for the ChannelFinder REST API (default: `8443`). |
| `es_port` | int | Elasticsearch port (default: `9200`). |
| `cf_procServ_port` | int | procServ port (default: `60051`). |
