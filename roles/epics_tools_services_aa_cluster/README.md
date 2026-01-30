
Archiver Appliance
==================
Builds and Deploys the Archiver Appliance
It consists for 4 services
 - Archive engine
 - Manager
 - ETL engine
 - Data Retrieval
 
**Installation location:**
`/opt/epics-tools/{{ beamline_name }}/aa`

**Startup scripts:**
`systemctl start {{beamline_name}}_aa`

Dependencies
------------
OpenJDK 11
role: epics_services_libs_jvm

Role Variables
--------------

| Variable                     | Type   | Description                                                                                      |
|------------------------------|--------|--------------------------------------------------------------------------------------------------|
| `beamline_name`              | string | The unique name of the beamline which will be used to determine the installation location of the |
|                              |        | service.                                                                                         |
| `beamline_id`                | int    | The unique 2 digit id used to identify the beamline, this is used to determing the ports         |
| **build and installation directories**
| `aa_install_location`        | string | The installation location of the archiver services,                                              |
|                              |        | The installation location is used to prepare the various aa services needed in a deployment      |
|                              |        | default is /opt/epics-tools/services/{{ beamline_name }}/aa/install                              |
| `aa_deploy_location`         | string | The deploy location of the archiver services, The deploy location is the final location          |
|                              |        | consisting of the configured and runnable instances of the aa services                           |
|                              |        | default is /opt/epics-tools/services/{{ beamline_name }}/aa/deploy                               |
| `aa_identity`                | string | AA identiry, appliance0                                                                          |
| `cluster_inetport`           | int    | The port for the data retrieval service, default 2{{ beamline_id }}70                            |
| `mgmt_port`                  | int    | The port for the data retrieval service, default 2{{ beamline_id }}65                            |
| `engine_port`                | int    | The port for the data retrieval service, default 2{{ beamline_id }}66                            |
| `etl_port`                   | int    | The port for the data retrieval service, default 2{{ beamline_id }}67                            |
| `data_retrieval_port`        | int    | The port for the data retrieval service, default 2{{ beamline_id }}68                            |
| **AA data store locations**
| `aa_sts`                     | string | location of short term store, default {{ aa_deploy_location }}/data/sts/ArchiverStore            |
| `aa_mts`                     | string | location of short term store, default {{ aa_deploy_location }}/data/mts/ArchiverStore            |
| `aa_lts`                     | string | location of short term store, default {{ aa_deploy_location }}/data/lts/ArchiverStore            |
| **AA database connection settings**
| `aa_mysql_server`            | string | The mysql server host names                                                                      |
| `aa_mysql_database`          | string | The database name for Olog, the default pattern is {{ beamline_name }}_archappl                  |
| `aa_mysql_user`              | string | The mysql user name for Olog, the default pattern is {{ beamline_name }}_archappl                |
| `aa_mysql_password`          | string | The mysql user password for Olog, the default pattern is {{ beamline_name }}_archappl            |
| `jdbc_root_user`             | string | The mysql root password needed to create the olog user and database                              |
