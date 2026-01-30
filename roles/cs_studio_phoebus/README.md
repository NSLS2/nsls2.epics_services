Phoebus
=======

Install nsls2 phoebus product along with required libraries.

Requirements
------------


Role Variables
--------------

| Variable                       | Type   | Description                                                                                        |
|--------------------------------|--------|----------------------------------------------------------------------------------------------------|
| `cs_studio_phoebus_jar`        | string | The NSLS-II has multiple Phoebus products, this variable allows selection of the required product  |
| `cs_studio_phoebus_pref`       | string | The Phoebus `settings.ini` file to be used by the `run-phoebus` command                            |


Dependencies
------------

`cs_studio_preferences`
`cs_studio_opis`
`epics_tools_libs`


Author Information
------------------

Kunal Shroff <shroffk@bnl.gov>