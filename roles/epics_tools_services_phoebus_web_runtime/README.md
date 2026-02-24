Phoebus Web Runtime
===================

Install the Phoebus Web Runtime services.

**Installation location:**
`/opt/epics-tools/services/tomcat`

**Startup scripts:**
`systemctl start tomcat`


Dependencies
------------
OpenJDK 1.8.0 update 242
role: epics_services_libs_jvm

Phoebus
role: cs_studio_phoebus

tomcat
role: epics_tools_services_tomcat
