Phoebus Alarm Services
======================

Install the Phoebus Alarm services. This includes the alarm server, alarm messages logger, and alarm 
configuration manager.


**Installation location:**
`/opt/epics-services/{{ beamline_name }}/phoebus_alarm/`

**Startup scripts:**
`systemctl start {{beamline_name}}_phoebus_alarm`


Dependencies
------------
OpenJDK 11
role: epics_services_libs_jvm

Phoebus
role: cs_studio_phoebus

Elastic
role: epics_tools_services_elastic

Kafka
role: epics_tools_services_kafka

