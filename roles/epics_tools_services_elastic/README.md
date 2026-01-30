Elastic 
=======

A simple single node installation for elastic 8.2.3

**Installation location:**
`/opt/epics-services/{{ beamline_name }}/elastic`

**Startup scripts:**
`systemctl start {{ beamline_name }}_elastic`

Dependencies
------------
OpenJDK 11
role: epics_services_libs_jvm

| Variable                     | Type   | Description                                                                                      |
|------------------------------|--------|--------------------------------------------------------------------------------------------------|
| `beamline_name`              | string | The unique name of the beamline which will be used to determine the installation location of the |
|                              |        | service.                                                                                         |
| `beamline_id`                | int    | The unique 2 digit id used to identify the beamline, this is used to determing the ports         |
| **Elastic port (optional)** 
| `elastic_port`               | int    | The elastic port, the default is calculated using the bemaline id: 4{{beamline_id}}92            |
