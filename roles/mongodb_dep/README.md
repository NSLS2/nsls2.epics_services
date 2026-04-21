mongodb_dep
==================

A simple installation for the public mongod server.

**Startup scripts:**
`systemctl start mongod`

Dependencies
------------

None

Role Variables
--------------

| Variable | Type | Description |
| --- | --- | --- |
| `mongod_port` | int | The port MongoDB listens on (default: `27017`). |
| `mongod_home` | string | The MongoDB home directory (default: `/var/lib/mongodb`). |
| `mongod_data_path` | string | The location of the mongo data directory (default: `{{ mongod_home }}/data`). |
| `mongod_name` | string | The service name for the mongod instance (default: `mongod`). |
