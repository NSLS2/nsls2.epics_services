mongodb_dependency
==================

A simple installation for the public mongod server.

**Startup scripts:**
`systemctl start {{ beamline_name }}_mongod`

Dependencies
------------

OpenJDK 11
role: jdk_dependency

Role Variables
--------------

| Variable | Type | Description |
| --- | --- | --- |
| `beamline_name` | string | The unique name of the beamline which will be used to determine the installation location of the service. |
| `beamline_id` | int | The unique 2 digit id used to identify the beamline, this is used to determine the ports. |
| `mongod_data_path` | string | The location of the mongo data directory (optional). |
