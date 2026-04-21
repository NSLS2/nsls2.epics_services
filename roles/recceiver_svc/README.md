recceiver_svc
=============

Deploy the RecSync (recceiver) service, which listens for IOC record
announcements and publishes them to a ChannelFinder server.

**Installation location:**
`/opt/epics-tools/services/recsync` (configurable via `recsync_install_dir`)

**Runtime files:**
`/opt/RecSync` (configurable via `recsync_runtime_dir`)

**Startup scripts:**
`systemctl start recsync`

Dependencies
------------

- `nsls2.epics_services.jdk_dep` (included automatically)
- `nsls2.epics_services.maven_dep` (included automatically)
- `nsls2.epics_services.elasticsearch_dep` (included automatically)
- `nsls2.epics_services.channelfinder_api` (included automatically)

Role Variables
--------------

| Variable | Type | Description |
| --- | --- | --- |
| `epics_services_account` | string | Service account (default: `csstudio`). |
| `recsync_install_dir` | string | RecSync-env clone location (default: `/opt/epics-tools/services/recsync`). |
| `recsync_runtime_dir` | string | RecSync runtime directory (default: `/opt/RecSync`). |
| `recsync_repo` | string | Git repository URL (default: GitHub ChannelFinder/RecSync-env). |
| `recsync_version` | string | Git ref to checkout (default: `master`). |
| `recsync_addr_list` | string | Broadcast address list for IOC discovery (e.g. `127.255.255.255:5049`). |
| `cf_url` | string | ChannelFinder base URL (e.g. `http://localhost:8080/ChannelFinder`). |
| `cf_user` | string | ChannelFinder username (default: `cfstore`). |
| `cf_password` | string | ChannelFinder password (default: `password`). |
