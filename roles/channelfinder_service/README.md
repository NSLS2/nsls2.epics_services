channelfinder_service
=====================

Install the ChannelFinder service.

**Installation location:**
`/opt/epics-services/{{ beamline_name }}/cf/`

**Startup scripts:**
`systemctl start {{beamline_name}}_cf`


Dependencies
------------
OpenJDK 11.0.9
role: jdk_dependency

Elastic
role: elasticsearch_dependency
