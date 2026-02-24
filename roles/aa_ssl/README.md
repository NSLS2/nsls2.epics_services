aa_ssl
======

Configures SSL/TLS certificates for the
[EPICS Archiver Appliance](https://github.com/archiver-appliance/epicsarchiverap)
cluster deployment.

This role is only included by the cluster orchestrator
(`epics_tools_services_aa_cluster`). Single-instance deployments do not use SSL.

What it does
------------
- Checks that the SSL certificate and private key files exist on disk
- Warns if any certificate files are missing
- Sets correct file permissions on the private key (`0600`) and certificate
  (`0644`)
- Imports the CA certificate chain into the Java truststore so that inter-node
  HTTPS communication is trusted

Dependencies
------------
- `aa_dependencies` (provides `aa_java_home` fact for the Java truststore path)

Depended on by
--------------
- `epics_tools_services_aa_cluster` (cluster orchestrator)

Role Variables
--------------

This role has no defaults of its own. All variables are expected to be provided
by the calling orchestrator role.

| Variable | Type | Description |
| --- | --- | --- |
| `aa_ssl_cert_file` | string | Absolute path to the SSL certificate file. |
| `aa_ssl_key_file` | string | Absolute path to the SSL private key file. |
| `aa_ssl_chain_file` | string | *(Optional)* Absolute path to the CA chain file. When defined, the chain is imported into the Java truststore. |
| `aa_java_home` | string | `JAVA_HOME` path (used to locate the `cacerts` truststore). |
| `epics_services_account` | string | OS user/group that owns certificate files. |
