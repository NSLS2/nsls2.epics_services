shift Service
=============

Install the shift webservice. This installation steps include:

1. Installation of the glassfish 5.0.1 java EE server.
2. Configuring mysql 5.7, create the shift database and the shift user.
3. Deploy the shift web service.

**Installation location:**
`/opt/epics-services/{{ beamline_name }}/glassfish5`

**Startup scripts:**
`systemctl start {{ beamline_name }}_glassfish`

Dependencies
------------

OpenJDK 1.8.0 update 242
role: epics_services_libs_jvm

Role Variables
--------------

| Variable | Type | Description |
| --- | --- | --- |
| `beamline_name` | string | The unique name of the beamline which will be used to determine the installation location of the glassfish service. |
| `beamline_id` | int | The unique 2 digit id used to identify the beamline, this is used to determine the ports. |
| `http_port` | int | The glassfish http port, default `3{{ beamline_id }}80`. |
| `https_port` | int | The glassfish https port, default `3{{ beamline_id }}81`. |
| `admin_port` | int | The glassfish admin port, default `3{{ beamline_id }}48`. |
| `java_home` | string | The location of the jdk used by glassfish, required version is jdk8. |
| `shift_jdbc_server` | string | The mysql server host names. |
| `shift_jdbc_dbname` | string | The database name for shift, default `{{ beamline_name }}_shift`. |
| `shift_jdbc_user` | string | The mysql user name for shift, default `{{ beamline_name }}_shift`. |
| `shift_jdbc_password` | string | The mysql user password for shift, default `shift@{{ beamline_name }}`. |
| `jdbc_root_user` | string | The mysql root password needed to create the shift user and database. |
