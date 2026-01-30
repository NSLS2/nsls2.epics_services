Save Restore
============

Install the save restore service


**Installation location:**
`/opt/epics-services/{{ beamline_name }}/save_restore/`

**Startup scripts:**
`systemctl start {{beamline_name}}_save_restore`


Dependencies
------------
OpenJDK 17
role: epics_tools_libs

Phoebus
role: cs_studio_phoebus

elastic
role: epics_tools_services_elastic
