Elasticsearch
=============

A single node Elasticsearch installation via the official Elastic RPM repository.

**Service name:**
`systemctl start elasticsearch`

Dependencies
------------
OpenJDK 17
role: epics_tools_libs

| Variable                     | Type   | Description                                                                                      |
|------------------------------|--------|--------------------------------------------------------------------------------------------------|
| `beamline_name`              | string | The unique name of the beamline, used in cluster name and data/log paths.                        |
| `beamline_id`                | int    | The unique 2 digit id used to identify the beamline, this is used to determine the ports.        |
| `elastic_version`            | string | Elasticsearch version to install (default: `8.17.0`).                                            |
| `elastic_heap_size`          | string | JVM heap size for Elasticsearch (default: `4g`).                                                 |
| `elastic_port`               | int    | The HTTP port, default is calculated using the beamline id: `4{{ beamline_id }}92`.               |
