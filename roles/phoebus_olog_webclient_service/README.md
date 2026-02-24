phoebus_olog_webclient_service
==============================

Install the Phoebus Logbook Webclient service.


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
