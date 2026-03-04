shift_service
=============

Install the shift webservice. This installation includes:

1. Installation of the GlassFish 5.0.1 Java EE server.
2. Configuring MySQL, creating the shift database and user.
3. Deploying the shift web service.

**Installation location:**
`/opt/epics-tools/services/shift` (configurable via `shift_install_dir`)

**Startup scripts:**
`systemctl start shift_glassfish`

Dependencies
------------

OpenJDK 8
role: jdk_dependency

Role Variables
--------------

| Variable | Type | Description |
| --- | --- | --- |
| `shift_install_dir` | string | Installation directory (default: `/opt/epics-tools/services/shift`). |
| `http_port` | int | GlassFish HTTP port (default: `8080`). |
| `https_port` | int | GlassFish HTTPS port (default: `8443`). |
| `admin_port` | int | GlassFish admin port (default: `4848`). |
| `java_home` | string | JDK 8 path (default: `/usr/lib/jvm/java-1.8.0-openjdk`). |
| `shift_jdbc_server` | string | MySQL server hostname (default: `localhost`). |
| `shift_jdbc_dbname` | string | Database name for shift (default: `shift`). |
| `shift_jdbc_user` | string | MySQL username for shift (default: `shift`). |
| `shift_jdbc_password` | string | MySQL password for shift (default: `shift`). |
| `jdbc_root_user` | string | MySQL root password (required when `configure_mysql` is true). |
| `configure_mysql` | bool | Whether to create the MySQL database and user (default: `true`). |
