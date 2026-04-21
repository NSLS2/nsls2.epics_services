phoebus_olog_ui
===============

Install the Phoebus Logbook Webclient service.


**Installation location:**
`/opt/epics-tools/services/phoebus_olog_webclient/` (configurable via `phoebus_olog_webclient_install_dir`)

**Startup scripts:**
`systemctl start phoebus_olog_webclient`


Dependencies
------------
Node.js
role: nodejs_dep

Phoebus Olog
role: phoebus_olog_api

Role Variables
--------------

| Variable | Type | Description |
| --- | --- | --- |
| `phoebus_olog_webclient_install_dir` | string | Installation directory (default: `/opt/epics-tools/services/phoebus_olog_webclient`). |
| `phoebus_olog_webclient_version` | string | Git tag to checkout (default: `v2.2.1`). |
| `phoebus_olog_url` | string | URL of the Olog REST API (default: `http://localhost:8080/Olog`). |
| `olog_webclient_procServ_port` | int | procServ port (default: `60050`). |
