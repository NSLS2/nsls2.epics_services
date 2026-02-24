save_restore_service
====================

Install the save restore service


**Installation location:**
`/opt/epics-services/{{ beamline_name }}/save_restore/`

**Startup scripts:**
`systemctl start {{beamline_name}}_save_restore`


Dependencies
------------
OpenJDK 17
role: jdk_dependency

elastic
role: elasticsearch_dependency
