phoebus_olog_service
====================

Install the Phoebus Logbook service.


**Installation location:**
`/opt/epics-services/{{ beamline_name }}/phoebus_olog/`

**Startup scripts:**
`systemctl start {{beamline_name}}_phoebus_olog`


Dependencies
------------
OpenJDK 17
role: jdk_dependency

Elastic
role: elasticsearch_dependency

MongoDB
role: mongodb_dependency
