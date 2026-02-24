Phoebus Logbook Services
========================

Install the Phoebus Logbook service.


**Installation location:**
`/opt/epics-services/{{ beamline_name }}/phoebus_olog/`

**Startup scripts:**
`systemctl start {{beamline_name}}_phoebus_olog`


Dependencies
------------
OpenJDK 17
role: epics_services_libs_jvm

Phoebus
role: cs_studio_phoebus

Elastic
role: epics_tools_services_elastic

MongoDB
role: epics_tools_services_mongodb
