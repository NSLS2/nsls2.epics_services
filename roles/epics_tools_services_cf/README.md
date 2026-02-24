ChannelFinder Services
=======================

Install the ChannelFinder service.

**Installation location:**
`/opt/epics-services/{{ beamline_name }}/cf/`

**Startup scripts:**
`systemctl start {{beamline_name}}_cf`


Dependencies
------------
OpenJDK 11.0.9
role: epics_services_libs_jvm

Phoebus
role: cs_studio_phoebus

Elastic
role: epics_tools_services_elastic
