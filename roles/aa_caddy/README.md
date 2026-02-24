aa_caddy
========

Configures [Caddy](https://caddyserver.com/) as a TLS-terminating reverse proxy
for the
[EPICS Archiver Appliance](https://github.com/archiver-appliance/epicsarchiverap)
cluster deployment.

This role is only included by the cluster orchestrator
(`epics_tools_services_aa_cluster`). Single-instance deployments do not use
Caddy.

What it does
------------
- Installs the Caddy RPM package
- Deploys a Caddyfile that reverse-proxies HTTPS requests to the four local
  Tomcat instances (mgmt, engine, etl, retrieval) over plain HTTP
- Validates the Caddy configuration
- Ensures the Caddy service is started and enabled

Dependencies
------------
- `aa_deploy` (the Tomcat instances and their HTTP ports must be configured
  before Caddy can proxy to them)

Depended on by
--------------
- `epics_tools_services_aa_cluster` (cluster orchestrator)

Role Variables
--------------

**Defaults defined by this role** (`defaults/main.yml`):

| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| `aa_caddy_tls_cert` | string | `""` | Absolute path to the TLS certificate file. |
| `aa_caddy_tls_key` | string | `""` | Absolute path to the TLS private key file. |

**Required variables** (provided by the calling orchestrator):

| Variable | Type | Description |
| --- | --- | --- |
| `beamline_name` | string | Beamline identifier, used in the generated Caddyfile comment. |
| `mgmt_port` | string | HTTP port for the mgmt Tomcat instance. |
| `engine_port` | string | HTTP port for the engine Tomcat instance. |
| `etl_port` | string | HTTP port for the etl Tomcat instance. |
| `data_retrieval_port` | string | HTTP port for the retrieval Tomcat instance. |
